/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Medical_Loop",
{
    private _bloodLevel = player getVariable ["A3PL_Medical_Blood",Medical_Max_BloodLevel];
    private _wounds = player getVariable ["A3PL_Wounds",[]];
    private _beingTreated = player getVariable["beingTreated",false];
    private _bloodChange = 0;
    if (_bloodLevel > 0) then {
        {
            for "_i" from 1 to (count _x-1) do {
                private _woundArr = _x select _i;
                private _wound = _woundArr select 0;
                private _isTreated = _woundArr select 1;
                if (!_isTreated) then {
                    _bloodChange = _bloodChange - ([_wound,3] call A3PL_Config_GetWoundData);
                };
            };
        } foreach _wounds;
        if (_bloodChange isNotEqualTo 0 && {!_beingTreated}) then {[player,_bloodChange] call A3PL_Medical_ApplyVar;};
    };
    if(_bloodChange isEqualTo 0 && _bloodLevel isNotEqualTo Medical_Max_BloodLevel) exitwith {};
    if(!isNil "Player_WipedBlood") exitWith {};
    if(_bloodLevel < Medical_Max_BloodLevel) then {
        if(Player_CurBloodOverlay > (_bloodLevel/Medical_Max_BloodLevel) && {Player_CurBloodOverlay > 0}) then {
            Player_CurBloodOverlay = Player_CurBloodOverlay - 0.01;
        };
        player setVariable["bloodOverlay",true,true];
    } else {
        Player_CurBloodOverlay = 1;
        player setVariable["bloodOverlay",false,true];
    };
    ["\A3PL_Common\GUI\medical\overlay_blood.paa",1,Player_CurBloodOverlay] call A3PL_HUD_SetOverlay;
}] call compile_Global;

["A3PL_Medical_Hit",
{
	params [["_unit",objNull,[objNull]]];
	private ["_sHit","_sDamage","_sBullet"];
	private _unconscious = !(player getVariable["A3PL_Medical_Alive",true]);
	private _timeRemain = player getVariable ["TimeRemaining",600];
	private _customDamageBullets = [];

	private _getHit = _unit getVariable ["getHit",[]];
	private _tmpDmg = 0;
	A3PL_HitTime = nil;
	_unit setVariable ["getHit",nil,false];

	{
		private ["_sel","_dmg","_bullet"];
		_sel = _x select 0;
		_dmg = _x select 1;
		_bullet = _x select 2;
		if (_bullet isEqualTo "") then {
			if (_dmg > _tmpDmg) then {
				_sHit = _sel;
				_sDamage = _dmg;
				_sBullet = _bullet;
				_tmpDmg = _dmg;
			};
		} else {
			if ((_dmg > _tmpDmg) && (_sel != "")) then {
				_sHit = _sel;
				_sDamage = _dmg;
				_sBullet = _bullet;
				_tmpDmg = _dmg;
			};
		};
	} foreach _getHit;
	if (isNil "_sHit") exitwith {};

	if ((isBurning player) && {_sBullet isEqualTo ""} && {_sHit IN ["spine1","spine2","spine3"]}) then {_sBullet = "FireDamage";};
	if (_unconscious && {_timeRemain < 580} && {!(_sBullet IN Medical_DoubleTap_Blacklist_Weapons)}) exitWith {
		[getPlayerUID player,(player getVariable ["character_id",""]),"Medical_Hit_DoubleTapped",[format ["Offender: %1",_unit getVariable["name","unknown"]]]] remoteExec ["Server_Log_New",2];
		player setVariable ["DoubleTapped",true,true];
	};
	if (_unconscious) exitwith {};
	if (_sBullet IN Medical_NoHitDamage) then {_sDamage = 0;};

	private _handles = [_sHit,_sDamage,_sBullet] call A3PL_Medical_GenerateWounds;
	if(_handles) then {
		private _applyDamage = [_sHit,_sBullet,_sDamage] call A3PL_Medical_GetDamage;

		// Trait adrenaline_junkie - reduces damage by 20% when active
		if (_unit getVariable ["A3PL_Adrenaline_Active", false]) then {
			_applyDamage = _applyDamage * 0.8;
		};

		private _curHit = 0;
		if(_sHit isEqualTo "pelvis") then {_sHit = "legs";};
		if (_sHit isEqualTo "") then {
			_curHit = damage _unit;
			if(_curHit + _applyDamage < 0.8) then {
				_unit setDamage (_curHit + _applyDamage);
				_unit setBleedingRemaining 60;
			} else {
				_unit setDamage 0.8;
				_unit setBleedingRemaining 120;
			};
		} else {
			_curHit = _unit getHit _sHit;
			if(_curHit + _applyDamage < 0.8) then {
				_unit setHit [_sHit, _applyDamage];
				_unit setBleedingRemaining 60;
			} else {
				_unit setHit [_sHit, 0.8];
				_unit setBleedingRemaining 120;
			};
		};
	};
}] call compile_Global;

["A3PL_Medical_GenerateWounds",
{
	params [
		["_sHit","",[""]],
		["_sDamage",0,[0]],
		["_sBullet","",[""]]
	];

	// Check if player has the resistance trait
	private _traits = player getVariable ["Player_Traits", []];
	private _hasResistanceTrait = "resistance" in _traits;

	// Resistance trait: reduce damage taken to reduce wound generation
	if (_hasResistanceTrait) then {
		_sDamage = _sDamage * 0.7; // 30% damage reduction
	};

	if(_sBullet isEqualTo "A3FL_PepperSpray_Ball") exitwith {
		if(!((goggles player) IN Medical_Masks_Protect_Peperspray)) then {
			if(!([player,"head","pepper_spray"] call A3PL_Medical_HasWound)) then {
				[player,"head","pepper_spray"] call A3PL_Medical_ApplyWound;
			};
		};
		false;
	};
	if(_sBullet IN Medical_Ragdoll_Weapons_With_Bruise) exitWith {
		[player,([_sHit] call A3PL_Medical_GetHitPart),"bruise"] call A3PL_Medical_ApplyWound;
		private _chance = random 100;
		if(_chance > 40) then {
			[] call A3PL_Lib_Ragdoll;
		};
		false;
	};
	if(_sBullet IN Medical_Ragdoll_Weapons_With_Cut) exitWith {
		[player,([_sHit] call A3PL_Medical_GetHitPart),"cut"] call A3PL_Medical_ApplyWound;
		private _chance = random 100;
		if(_chance >= 40) then {
			[] call A3PL_Lib_Ragdoll;
		};
		false;
	};
	if(_sBullet IN Medical_NoDamage_Or_Others) exitwith {
		private _partName = switch(_sHit) do {
			case ("head"): {("STR_A3PL_Medical_head" call A3PL_Localize)};
			case ("face_hub"): {("STR_A3PL_Medical_face_hub" call A3PL_Localize)};
			case ("chest"): {("STR_A3PL_Medical_chest" call A3PL_Localize)};
			case ("torso"): {("STR_A3PL_Medical_torso" call A3PL_Localize)};
			case ("pelvis"): {("STR_A3PL_Medical_pelvis" call A3PL_Localize)};
			case ("spine1"): {("STR_A3PL_Medical_spine1" call A3PL_Localize)};
			case ("spine2"): {("STR_A3PL_Medical_spine2" call A3PL_Localize)};
			case ("spine3"): {("STR_A3PL_Medical_spine3" call A3PL_Localize)};
			case ("arms"): {("STR_A3PL_Medical_arms" call A3PL_Localize)};
			case ("legs"): {("STR_A3PL_Medical_legs" call A3PL_Localize)};
			case ("hands"): {("STR_A3PL_Medical_hands" call A3PL_Localize)};
			case ("body"): {("STR_A3PL_Medical_body" call A3PL_Localize)};
			case ("neck"): {("STR_A3PL_Medical_neck" call A3PL_Localize)};
		};
		[format[("STR_A3PL_Medical_Hitted" call A3PL_Localize),_partName],Color_Blue] call A3PL_Notification;
		player playaction "gesture_wave";
		false;
	};

	if((_sHit isEqualTo "") && (_sBullet isEqualTo "") && (!isNull objectParent player)) exitWith {
		if (_sDamage > 0.13) then
		{
			if(((driver (vehicle player)) isEqualTo player) && (_sDamage > 0.009)) then {
				_fifr = [("STR_Common_FIFR" call A3PL_Localize)] call A3PL_Lib_FactionPlayers;
				if((count(_fifr) >= Medical_FIFR_Number_To_Be_Trapped) && ((vehicle player) isKindOf "Car")) then {
					_chance = random 100;
					if(_chance > 85) then {
						(vehicle player) setVariable["trapped",true,true];
						(vehicle player) setHitPointDamage ["hitengine", 1.0];
						[("STR_A3PL_Medical_StuckInsideCar" call A3PL_Localize),Color_Red] call A3PL_Notification;
						[("STR_Common_FIFR" call A3PL_Localize),("STR_A3PL_Medical_PeapoleStuck" call A3PL_Localize),getPos player,("STR_A3PL_Medical_PeopleStuckNotification" call A3PL_Localize),("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
						[position player, ("STR_A3PL_Medical_PeapoleStuck" call A3PL_Localize),"ColorRed"] remoteExec ["A3PL_Lib_CreateMarker",_fifr];
						[getPos player] remoteExec ["A3PL_GPS_NavigateToPosition",_fifr];
					};
					_fireChance = random 100;
					if((_sDamage > 0.04) && (_fireChance > 90)) then {
						[(getPosATL player)] call A3PL_Fire_StartFire;
						[("STR_A3PL_Medical_CarFireAfterAccident" call A3PL_Localize),Color_Red] call A3PL_Notification;
						[("STR_Common_FIFR" call A3PL_Localize),("STR_A3PL_Medical_CarFire" call A3PL_Localize),getPos player,("STR_A3PL_Medical_CarFireNotification" call A3PL_Localize),("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
						[position player, ("STR_A3PL_Medical_CarFire" call A3PL_Localize),"ColorRed"] remoteExec ["A3PL_Lib_CreateMarker",_fifr];
						[getPos player] remoteExec ["A3PL_GPS_NavigateToPosition",_fifr];
					};
				};
			};
			_injuries = round (random 3);
			for "_i" from 1 to _injuries do {
				_parts = ["torso","pelvis","left upper leg","left lower leg","right upper leg","head","chest","right lower leg","right upper arm","left upper arm","left lower arm","right lower arm"];
				_part = _parts select (round (random [0,5,11]));
				switch (true) do
				{
					case (_part isEqualTo "head"): { if (!([player,_part,"concussion"] call A3PL_Medical_HasWound) && (player getVariable ["SeatbeltOn",true])) then {[player,"head","concussion"] call A3PL_Medical_ApplyWound;};};
					default {[player,_part,(selectRandom ["cut","bruise","wound_minor"])] call A3PL_Medical_ApplyWound;};
				};
			};
		};
		if (_sDamage >= 0.23) then {
			_injuries = round (random 4);
			for "_i" from 1 to _injuries do {
				_parts = ["torso","pelvis","left upper leg","left lower leg","right upper leg","chest","right lower leg","head","right upper arm","left lower arm","right lower arm","left upper arm"];
				_part = _parts select (round (random [0,5,11]));
				switch (true) do {
					case (_part isEqualTo "head"): { if (!([player,_part,"concussion"] call A3PL_Medical_HasWound)) then {[player,"head","concussion"] call A3PL_Medical_ApplyWound;};};
					default {
						if (player getVariable ["SeatbeltOn",false]) then {
							[("STR_A3PL_Medical_BigAccident" call A3PL_Localize),Color_Red] call A3PL_Notification;
							[player,_part,(selectRandom ["cut","wound_minor"])] call A3PL_Medical_ApplyWound;
						} else {
							// Check if player has the crash_survivor trait
							private _hasCrashSurvivorTrait = "crash_survivor" in _traits;

							// Crash_survivor trait: 50% chance to avoid ejection
							private _shouldEject = true;
							if (_hasCrashSurvivorTrait && {random 100 < 50}) then {
								_shouldEject = false;
							};

							if (_shouldEject) then {
								[vehicle player] spawn A3LL_Lib_Eject;
							};
							[("STR_A3PL_Medical_BigAccident" call A3PL_Localize),Color_Red] call A3PL_Notification;
							[player,_part,(selectRandom ["cut","bruise","wound_minor","wound_major","bone_broken","bone_broken"])] call A3PL_Medical_ApplyWound;
						};
					};
				};
			};
		};
		true;
	};
	if((_sHit IN ["pelvis","head"]) && (_sBullet isEqualTo "") && ((vehicle player) isEqualTo player)) exitWith {
		if ((_sDamage >= 0.1) && (_sDamage < 0.25)) then {
			_injuries = round (random 2);
			for "_i" from 1 to _injuries do {
				_parts = ["left lower leg","right upper leg","left lower leg","pelvis","left upper leg","right upper leg","left upper leg","right lower leg","left lower leg","left upper leg","head","right upper leg","right lower leg","head","head","right lower leg"];
				_part = _parts select (round (random [0,7,15]));
				if(_part isEqualTo "head") then {
					[player,"head","concussion"] call A3PL_Medical_ApplyWound;
				} else {
					[player,_part,(selectRandom ["cut","bruise","wound_minor"])] call A3PL_Medical_ApplyWound;
				};
			};
		};
		if (_sDamage > 0.25) then
		{
			_injuries = 1 + round (random 1);
			for "_i" from 1 to _injuries do
			{
				_parts = ["left lower leg","right upper leg","left lower leg","left upper leg","pelvis","left upper leg","right lower leg","left lower leg","left upper leg","head","right upper leg","right upper leg","right lower leg","head","head","right lower leg"];
				_part = _parts select (round (random [0,7,15]));
				if(_part isEqualTo "head") then {
					[player,"head","concussion"] call A3PL_Medical_ApplyWound;
				} else {
					[player,_part,(selectRandom ["cut","bruise","wound_major","bone_broken"])] call A3PL_Medical_ApplyWound;
				};
			};
		};
		true;
	};
	if((_sHit IN ["pelvis","head"]) && (_sBullet isEqualTo "") && ((vehicle player) isEqualTo player)) exitWith {
		if ((_sDamage >= 0.1) && (_sDamage < 0.25)) then {
			_injuries = round (random 2);
			for "_i" from 1 to _injuries do {
				_parts = ["left lower leg","right upper leg","left lower leg","pelvis","left upper leg","right upper leg","left upper leg","right lower leg","left lower leg","left upper leg","head","right upper leg","right lower leg","head","head","right lower leg"];
				_part = _parts select (round (random [0,7,15]));
				if(_part isEqualTo "head") then {
					[player,"head","concussion"] call A3PL_Medical_ApplyWound;
				} else {
					[player,_part,(selectRandom ["cut","bruise","wound_minor"])] call A3PL_Medical_ApplyWound;
				};
			};
		};
		if (_sDamage > 0.25) then
		{
			_injuries = 1 + round (random 1);
			for "_i" from 1 to _injuries do
			{
				_parts = ["left lower leg","right upper leg","left lower leg","left upper leg","pelvis","left upper leg","right lower leg","left lower leg","left upper leg","head","right upper leg","right upper leg","right lower leg","head","head","right lower leg"];
				_part = _parts select (round (random [0,7,15]));
				if(_part isEqualTo "head") then {
					[player,"head","concussion"] call A3PL_Medical_ApplyWound;
				} else {
					[player,_part,(selectRandom ["cut","bruise","wound_major","bone_broken"])] call A3PL_Medical_ApplyWound;
				};
			};
		};
		true;
	};
	if(_sBullet isEqualTo "FireDamage") exitWith {
		_part = selectRandom ["torso","torso","torso","pelvis","left upper leg","left lower leg","right upper leg","chest","right lower leg","right upper arm","torso","right lower arm","left lower arm","left upper arm","right lower arm","left lower arm","head","right lower arm","head","head","head"];
		_injury = selectRandom ["smoke_minor","smoke_major","burn_first","burn_second","burn_third"];
		_hasOxygen = ((goggles player) isEqualTo "A3PL_FD_Mask") && {_vest isEqualTo "A3PL_FD_Oxygen"};
		if(_injury IN ["smoke_minor","smoke_major"]) then {
			if (!_hasOxygen && {_part IN ["head","chest","torso"]}) then {
				if (!([player,_part,_injury] call A3PL_Medical_HasWound)) then {
					[player,_part,_injury] call A3PL_Medical_ApplyWound;
				};
			};
		} else {
			if !((uniform player) isEqualTo "A3PL_FD_Protective_Uniform") then {
				[player,_part,_injury] call A3PL_Medical_ApplyWound;
			};
		};
		false;
	};
	if(!(_sBullet isEqualTo "") && {!(_sHit isEqualTo "")}) exitWith {
		_bulletWound = [_sBullet] call A3PL_Medical_GetBulletWound;
		if(_sHit IN ["neck","spine3","body"]) then {
			if((vest player) isEqualTo Medical_SuicideVest_Classname) then {[] call A3PL_Criminal_SuicideVest;};
			[player,"chest",_bulletWound,_sBullet] call A3PL_Medical_ApplyWound;
		} else {
			[player,([_sHit] call A3PL_Medical_GetHitPart),_bulletWound,_sBullet] call A3PL_Medical_ApplyWound;
		};
		true;
	};
	false;
}] call compile_Global;

["A3PL_Medical_ApplyWound",
{
	params [
		["_unit",player,[objNull]],
		["_part","",[""]],
		["_wound","",[""]],
		["_bullet","",[""]]
	];
	private _partF = false;
	private _set = true;
	private _wounds = _unit getVariable ["A3PL_Wounds",[]];
	private _partName = switch(_part) do {
		case ("head"): {("STR_A3PL_Medical_head" call A3PL_Localize)};
		case ("chest"): {("STR_A3PL_Medical_chest" call A3PL_Localize)};
		case ("torso"): {("STR_A3PL_Medical_torso" call A3PL_Localize)};
		case ("pelvis"): {("STR_A3PL_Medical_pelvis" call A3PL_Localize)};
		case ("left upper leg"): {("STR_A3PL_Medical_leftupperleg" call A3PL_Localize)};
		case ("left lower leg"): {("STR_A3PL_Medical_leftlowerleg" call A3PL_Localize)};
		case ("right upper leg"): {("STR_A3PL_Medical_rightupperleg" call A3PL_Localize)};
		case ("right lower leg"): {("STR_A3PL_Medical_rightlowerleg" call A3PL_Localize)};
		case ("left upper arm"): {("STR_A3PL_Medical_leftupperarm" call A3PL_Localize)};
		case ("left lower arm"): {("STR_A3PL_Medical_leftlowerarm" call A3PL_Localize)};
		case ("right upper arm"): {("STR_A3PL_Medical_rightupperarm" call A3PL_Localize)};
		case ("right lower arm"): {("STR_A3PL_Medical_rightlowerarm" call A3PL_Localize)};
	};

	{
		if ((_x#0) isEqualTo _part) then {
			if ((count _x) > 5) exitwith {_partF=true;_set=false;};
			_x pushback [_wound,false];
			_partF = true;
		};
	} foreach _wounds;

	if (!_partF) then {_wounds pushback [_part,[_wound,false]];};
	if (_set) then {
		_unit setVariable ["A3PL_Wounds",_wounds,true];
		[_unit,format [("STR_A3PL_Medical_subidamage" call A3PL_Localize),(_unit getVariable ["name",name _unit]),([_wound,0] call A3PL_Config_GetWoundData),_partName],[1, 0, 0, 1]] call A3PL_Medical_AddLog;
	};

	private _bloodLoss = [_wound,2] call A3PL_Config_GetWoundData;
	if (_bloodLoss > 0) then {
		_bloodLoss = [_bloodLoss,_part,_wound] call A3PL_Medical_BloodLoss;
		[_unit,-(_bloodLoss)] call A3PL_Medical_ApplyVar;
	};

	if (_wound isEqualTo "concussion") then {[] spawn A3PL_Medical_Concussion;};
	if (_wound isEqualTo "pepper_spray") then {[] spawn A3PL_Medical_PepperSpray;};
    [format[("STR_A3PL_Medical_BlessedAt" call A3PL_Localize),_partName], Color_Red] remoteExecCall ["A3PL_Notification",_unit];
}] call compile_Global;

["A3PL_Medical_ApplyVar",
{
	params [
		["_unit",player,[player]],
		["_change",0,[0]]
	];
	private _bloodValue = _unit getVariable ["A3PL_Medical_Blood",Medical_Max_BloodLevel];
	private _newValue = _bloodValue + _change;
	if (_newValue < 0) then {_newValue = 0;};
	if (_newValue > Medical_Max_BloodLevel) then {_newValue = Medical_Max_BloodLevel;};
	if (_newValue isEqualTo 0) then {
		if (player getVariable["A3PL_Medical_Alive",true]) then {_unit setDamage 1;};
	};
	_unit setVariable["bloodOverlay",true,true];
	_unit setVariable ["A3PL_Medical_Blood",_newValue,true];
	[(findDisplay 73)] call A3PL_Medical_LoadParts;
}] call compile_Global;

["A3PL_Medical_TreatWoundButton",
{
	disableSerialization;
	private _display = findDisplay 73;
	private _isEMS = (player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) isEqualTo ("STR_Common_FIFR" call A3PL_Localize);
	if (count([("STR_Common_FIFR" call A3PL_Localize)] call A3PL_Lib_FactionPlayers) < Medical_Number_FIFR_Minimum_To_Treat && (player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) isEqualTo ("STR_Common_FISD" call A3PL_Localize) && ["med",player] call A3PL_DMV_Check) then {_isEMS = true;};
	if ("doctor" in (player getVariable ["Player_Traits", []])) then {_isEMS = true;};
	private _unit = missionNameSpace getVariable ["A3PL_MedicalVar_Target",objNull];
	private _part = missionNameSpace getVariable ["A3PL_MedicalVar_CurrentPart",nil];

	if (isNull _unit) exitwith {["Error: Unknown target"] call A3PL_Notification;};
	if (isNil "_part") exitwith {["Unable to determine the selected body part"] call A3PL_Notification;};

	private _control = _display displayCtrl 1502;
	if ((lbCurSel _control) isEqualTo -1) exitwith {[("STR_A3PL_Medical_SelectTreatment" call A3PL_Localize)] call A3PL_Notification;};
	private _item = _control lbData (lbCurSel _control);

	if(_item isEqualTo "medS_bloodbag") exitWith {
		if (!([_item,1] call A3PL_Inventory_Has)) exitwith {[("STR_A3PL_Medical_YouDontHaveThis" call A3PL_Localize)] call A3PL_Notification;};
		if (_isEMS) then
		{
			if ((_unit getVariable ["A3PL_Medical_Blood",Medical_Max_BloodLevel]) >= Medical_Max_BloodLevel) exitwith {[("STR_A3PL_Medical_FullBloodLvl" call A3PL_Localize)] call A3PL_Notification;};
			if (player_itemClass == _item) then {[] call A3PL_Inventory_Clear};
			["medS_bloodbag",-1] call A3PL_Inventory_Add;
			[_unit,Medical_Blood_PerBag] call A3PL_Medical_ApplyVar;
			[("STR_A3PL_Medical_BloodAdministred" call A3PL_Localize),Color_Green] call A3PL_Notification;
			[player,format [("STR_A3PL_Medical_EMSAdministredBlood" call A3PL_Localize),(player getVariable ["name",name player])],[0, 1, 0, 1]] call A3PL_Medical_AddLog;
			[(findDisplay 73),_unit] call A3PL_Medical_LoadParts;
		} else {
			[("STR_A3PL_Medical_YoureNotOnDuty" call A3PL_Localize)] call A3PL_Notification;
		};
	};
	if(_item isEqualTo "pull_taser") exitwith {
		if ([_unit,_part,"taser_probes"] call A3PL_Medical_HasWound) then {
			[_unit,_part,"taser_probes","",lbCurSel 1501] call A3PL_Medical_Treat;
		};
	};

	private _control = _display displayCtrl 1501;
	if (lbCurSel _control isEqualTo -1) exitwith {[("STR_A3PL_Medical_SelectWound" call A3PL_Localize)] call A3PL_Notification;};
	private _wound = _control lbData (lbCurSel _control);

	if ((_item isEqualTo ([_wound,4] call A3PL_Config_GetWoundData)) OR ((_item isEqualTo ([_wound,6] call A3PL_Config_GetWoundData)) && _isEMS)) then {
		[_unit,_part,_wound,_item,lbCurSel 1501] call A3PL_Medical_Treat;
	} else {
		[("STR_A3PL_Medical_ThisItemCantBeUseToTreat" call A3PL_Localize)] call A3PL_Notification;
	};
}] call compile_Global;

["A3PL_Medical_Treat",
{
	params [
		["_unit",objNull,[objNull]],
		["_part","",[""]],
		["_wound","",[""]],
		["_item","",[""]],
		["_woundIndex",0,[0]]
	];
	private _woundName = [_wound,0] call A3PL_Config_GetWoundData;
	private _isEMS = (player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) isEqualTo ("STR_Common_FIFR" call A3PL_Localize);
	if (count([("STR_Common_FIFR" call A3PL_Localize)] call A3PL_Lib_FactionPlayers) < Medical_Number_FIFR_Minimum_To_Treat && (player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) isEqualTo ("STR_Common_FISD" call A3PL_Localize) && ["med",player] call A3PL_DMV_Check) then {_isEMS = true;};
	if (["doctor"] call A3PL_Trait_Has) then {_isEMS = true;};
	private _wounds = _unit getVariable ["A3PL_Wounds",[]];
	{
		if ((_x select 0) == _part) exitwith
		{
			_i = _woundIndex + 1;
			_woundArr = _x select _i;
			if ((_woundArr select 0) isEqualTo _wound) exitwith
			{
				if ((_item isEqualTo ([_wound,6] call A3PL_Config_GetWoundData)) && _isEMS) then {
					[("STR_A3PL_Medical_YouTreatedThisWound" call A3PL_Localize),Color_Green] call A3PL_Notification;
					[format [("STR_A3PL_Medical_YouTreated" call A3PL_Localize),_woundName],Color_Green] call A3PL_Notification;
					[_unit,format [("STR_A3PL_Medical_EMSTreated" call A3PL_Localize),(player getVariable ["name",name player]),_woundName],[0, 1, 0, 1]] call A3PL_Medical_AddLog;
					_x deleteAt _i;
					[_item,-1] call A3PL_Inventory_Add;
				} else {
					if ([_wound,5] call A3PL_Config_GetWoundData) then
					{
						[format [("STR_A3PL_Medical_YouTreated" call A3PL_Localize),_woundName],Color_Green] call A3PL_Notification;
						[_unit,format [("STR_A3PL_Medical_Treated" call A3PL_Localize),(player getVariable ["name",name player]),_woundName],[0, 1, 0, 1]] call A3PL_Medical_AddLog;
						_x deleteAt _i;
						[_item,-1] call A3PL_Inventory_Add;
					} else {
						if(_woundArr select 1) exitWith {[("STR_A3PL_Medical_WoundAlreadyTreated" call A3PL_Localize),Color_Red] call A3PL_Notification;};
						[_unit,format [("STR_A3PL_Medical_TreatedOn" call A3PL_Localize),(player getVariable ["name",name player]),_woundName,_part],[0, 1, 0, 1]] call A3PL_Medical_AddLog;
						[format [("STR_A3PL_Medical_YouTreatedWoundButNeedToGoClinic" call A3PL_Localize),_woundName]] call A3PL_Notification;
						_woundArr set [1,true];
						[_item,-1] call A3PL_Inventory_Add;
					};
				};
				if ((count _x) < 2) then {_wounds deleteAt _forEachIndex;};
			};
		};
	} foreach _wounds;

	_unit setVariable ["A3PL_Wounds",_wounds,true];
	[(findDisplay 73),_unit] call A3PL_Medical_LoadParts;
	[] call A3PL_Medical_SelectPart;
	[] remoteExecCall ["A3PL_Medical_LimpCheck",_unit];
}] call compile_Global;

["A3PL_Medical_Open",
{
	disableSerialization;
	private _unit = param [0,player];
	// private _fifrCount = count([("STR_Common_FIFR" call A3PL_Localize)] call A3PL_Lib_FactionPlayers);
	// private _isFifr = player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] isEqualTo ("STR_Common_FIFR" call A3PL_Localize);
	// if(_unit isNotEqualTo player && !_isFifr && (_fifrCount isNotEqualTo 0)) exitwith {[("STR_A3PL_Medical_FirstAidOnlyIfNoFD" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	createDialog "dialog_medical";
	private _display = findDisplay 73;
	_display call A3PL_Dialog_Localize;
	call A3PL_Medical_LimpCheck;
	if(!([player,"head","pepper_spray"] call A3PL_Medical_HasWound)) then {
		[] spawn {
			_hndl = ppEffectCreate ['dynamicBlur', 505];
			_hndl ppEffectEnable true;
			_hndl ppEffectAdjust [5];
			_hndl ppEffectCommit 0;
			waitUntil {isNull findDisplay 73};
			ppEffectDestroy _hndl;
		};
	};

	A3PL_MedicalVar_CurrentPart = "chest";
	A3PL_MedicalVar_Target = _unit;
	["chest"] call A3PL_Medical_SelectPart;

	_display displayAddEventHandler ["unLoad", {
		A3PL_MedicalVar_CurrentPart = nil;
		A3PL_MedicalVar_Controls = nil;
	}];

	private _control = _display displayCtrl 1100;
	if (_unit isEqualTo player) then {
		_control ctrlSetStructuredText parseText format ["<t size='1.4' align='center' font='PuristaSemiBold'>%1</t>",toUpperANSI (player getVariable ["name",name player])];
	} else {
		_control ctrlSetStructuredText parseText format ["<t size='1.4' align='center' font='PuristaSemiBold'>%1</t>",toUpperANSI ([_unit] call A3PL_Player_GetNameTag)];
	};

	[_display,_unit] call A3PL_Medical_LoadParts;
	while {!isNull _display} do {
		sleep 0.2;
		call A3PL_Medical_LoadItems;
	};
}] call compile_Global;

["A3PL_Medical_LoadItems",
{
	disableSerialization;
	private _player = missionNameSpace getVariable ["A3PL_MedicalVar_Target",objNull];
	private _part = missionNameSpace getVariable ["A3PL_MedicalVar_CurrentPart","chest"];
	private _display = findDisplay 73;
	private _control = _display displayCtrl 1502;
	private _lbArray = [];

	if([_player,_part,"taser_probes"] call A3PL_Medical_HasWound) then {
		_lbArray pushback [("STR_A3PL_Medical_RemoveTaserProbes" call A3PL_Localize),"pull_taser"];
	};
	if (_part IN ["right upper arm","left upper arm","left lower arm","right lower arm"]) then {
		private _itemAmount = ["medS_bloodbag"] call A3PL_Inventory_Return;
		if (["medS_bloodbag",1] call A3PL_Inventory_Has) then {
			_lbArray pushback [(format ["%1 (x%2)",(["medS_bloodbag","name"] call A3PL_Config_GetItem),_itemAmount]),"medS_bloodbag"];
		};
	};

	{
		private _itemName = _x select 0;
		private _itemAmount = _x select 1;
		if ((_itemName find "med_") isEqualTo 0) then {
			_lbArray pushback [(format ["%1 (x%2)",[_itemName,"name"] call A3PL_Config_GetItem,_itemAmount]),_itemName];
		};
	} foreach (player getVariable ["player_inventory",[]]);

	lbClear _control;
	{
		private _index = _control lbAdd (_x select 0);
		_control lbSetData [_index,(_x select 1)];
	} foreach _lbArray;
}] call compile_Global;

["A3PL_Medical_LoadParts",
{
	disableSerialization;
	private _display = param [0,(findDisplay 73)];
	private _player = param [1,missionNameSpace getVariable ["A3PL_MedicalVar_Target",objNull]];
	private _vars = _player getVariable ["A3PL_Medical_Blood",Medical_Max_BloodLevel];

	if (isNull _display) exitwith {};

	private _control = _display displayCtrl 1103;
	_control ctrlSetStructuredText parseText format [("STR_A3PL_Medical_Liter" call A3PL_Localize),(_vars/1000)];

	private _control = _display displayCtrl 1500;
	private _log = [] + (_player getVariable ["A3PL_MedicalLog",[]]);
	reverse _log;
	lbClear _control;
	{
		private _index = _control lbAdd (_x select 0);
		_control lbSetColor [_index,(_x select 1)];
	} foreach _log;

	if (!isNil {missionNameSpace getVariable ["A3PL_MedicalVar_Controls",nil]}) then {
		{ctrlDelete _x;} foreach A3PL_MedicalVar_Controls;
	};

	private _wounds = _player getVariable ["A3PL_Wounds",[]];
	if ((count _wounds) > 0) then
	{
		A3PL_MedicalVar_Controls = [];
		{
			private ["_control","_img","_color"];
			_img = switch (_x select 0) do
			{
				case ("head"): {"head"};
				case ("chest"): {"spine03"};
				case ("torso"): {"spine02"};
				case ("pelvis"): {"spine01"};
				case ("left upper leg"): {"right_leg_upper"};
				case ("left lower leg"): {"right_leg_lower"};
				case ("right upper leg"): {"left_leg_upper"};
				case ("right lower leg"): {"left_leg_lower"};
				case ("left upper arm"): {"right_arm_upper"};
				case ("left lower arm"): {"right_arm_lower"};
				case ("right upper arm"): {"left_arm_upper"};
				case ("right lower arm"): {"left_arm_lower"};
			};
			if (isNil "_img") exitwith {["Error: _img not defined"] call A3PL_Notification;};

			_color = "";
			for "_i" from 1 to (count _x-1) do
			{
				private ["_woundArr"];
				_woundArr = _x select _i;
				if (_woundArr select 1) then { if (!(_color IN ["red","orange"])) then { _color = "green"; }; } else
				{
					_color = [_woundArr#0,1] call A3PL_Config_GetWoundData;
				};
				if (_color isEqualTo "red") exitwith {};
			};

			_control = _display ctrlCreate ["RscPicture",-1];
			_control ctrlSetPosition (ctrlPosition (_display displayCtrl 1201));
			_control ctrlCommit 0;
			_control ctrlSetText format ["\A3PL_Common\GUI\medical\man_%1_%2.paa",_img,_color];
			A3PL_MedicalVar_Controls pushback _control;
		} foreach (_player getVariable ["A3PL_Wounds",[]]);
	};
}] call compile_Global;

["A3PL_Medical_SelectPart",
{
	disableSerialization;
	private _part = param [0,A3PL_MedicalVar_CurrentPart];
	private _player = missionNameSpace getVariable ["A3PL_MedicalVar_Target",objNull];
	A3PL_MedicalVar_CurrentPart = _part;
	private _partName = switch(_part) do {
		case ("head"): {("STR_A3PL_Medical_head" call A3PL_Localize)};
		case ("chest"): {("STR_A3PL_Medical_chest" call A3PL_Localize)};
		case ("torso"): {("STR_A3PL_Medical_torso" call A3PL_Localize)};
		case ("pelvis"): {("STR_A3PL_Medical_pelvis" call A3PL_Localize)};
		case ("left upper leg"): {("STR_A3PL_Medical_leftupperleg" call A3PL_Localize)};
		case ("left lower leg"): {("STR_A3PL_Medical_leftlowerleg" call A3PL_Localize)};
		case ("right upper leg"): {("STR_A3PL_Medical_rightupperleg" call A3PL_Localize)};
		case ("right lower leg"): {("STR_A3PL_Medical_rightlowerleg" call A3PL_Localize)};
		case ("left upper arm"): {("STR_A3PL_Medical_leftupperarm" call A3PL_Localize)};
		case ("left lower arm"): {("STR_A3PL_Medical_leftlowerarm" call A3PL_Localize)};
		case ("right upper arm"): {("STR_A3PL_Medical_rightupperarm" call A3PL_Localize)};
		case ("right lower arm"): {("STR_A3PL_Medical_rightlowerarm" call A3PL_Localize)};
	};
	private _display = findDisplay 73;
	private _control = _display displayCtrl 1104;
	_control ctrlSetStructuredText parseText format ["<t size='1' align='center' font='PuristaSemiBold'>%1</t>",toUpperANSI _partName];

	private _control = _display displayCtrl 1501;
	lbClear _control;
	{
		if (_x#0 == _part) then {
			for "_i" from 1 to (count _x-1) do {
				private ["_woundArr","_index","_woundClass","_woundColor","_color"];
				_woundArr = _x#_i;
				_woundClass = _woundArr#0;
				_index = _control lbAdd ([_woundClass,0] call A3PL_Config_GetWoundData);
				_control lbSetData [_index,_woundClass];
				_woundColor = if(_woundArr#1) then {"green"} else {[_woundClass,1] call A3PL_Config_GetWoundData};
				_color = switch (_woundColor) do {
					case "red": {[1, 0, 0, 1]};
					case "orange": {[0.5, 0.5, 0, 1]};
					case "green": {[0, 1, 0, 1]};
				};
				if (_color isEqualType []) then {_control lbSetColor [_index,_color];};
			};
		};
	} foreach (_player getVariable ["A3PL_Wounds",[]]);
}] call compile_Global;

/*
	Get Data Functions
*/

["A3PL_Medical_GetHitPart",
{
	params [["_sHit","",[""]]];
	private _mHit = switch (true) do {
		default {"head"};
		case (_sHit IN ["face_hub","head"]): {"head"};
		case (_sHit IN ["pelvis","spine1"]): {"pelvis"};
		case (_sHit isEqualTo "spine2"): {"torso"};
		case (_sHit IN ["neck","spine3","body"]): {"chest"};
		case (_sHit IN ["arms","hands"]): {selectRandom ["right upper arm","right lower arm","left lower arm","left upper arm"]};
		case (_sHit isEqualTo "legs"): {selectRandom ["right upper leg","right lower leg","left lower leg","left upper leg"]};
	};
	_mHit;
}] call compile_Global;

["A3PL_Medical_GetDamage",
{
	params [
		["_selection","",[""]],
		["_projectile","",[""]],
		["_defDamage",0,[0]]
	];
	private _selectionDamage = switch(true) do {
		case (_sHit IN ["face_hub","head"]): {0.4};
		case (_sHit IN ["pelvis","spine1","spine2"]): {0.2};
		case (_sHit IN ["neck","spine3","body"]): {0.3};
		case (_sHit IN ["arms","hands"]): {0.1};
		case (_sHit isEqualTo "legs"): {0.1};
		default {0};
	};
	private _projectileDamage = switch(true) do {
		case (_projectile IN Medical_Projectile_Damage_Classnames_1): {Medical_Projectile_Damage_1};
		case (_projectile IN Medical_Projectile_Damage_Classnames_2): {Medical_Projectile_Damage_2};
		case (_projectile IN Medical_Projectile_Damage_Classnames_3): {Medical_Projectile_Damage_3};
		case (_projectile IN Medical_Projectile_Damage_Classnames_4): {Medical_Projectile_Damage_4};
		case (_projectile IN Medical_Projectile_Damage_Classnames_5): {Medical_Projectile_Damage_5};
		case (_projectile IN Medical_Projectile_Damage_Classnames_6): {Medical_Projectile_Damage_6};
		case (_projectile IN Medical_Projectile_Damage_Classnames_7): {Medical_Projectile_Damage_7};
		default {0};
	};
	if((_selectionDamage isEqualTo 0) || {_projectileDamage isEqualTo 0}) then {
		_defDamage;
	} else {
		_selectionDamage + _projectileDamage;
	};
}] call compile_Global;

["A3PL_Medical_BloodLoss",
{
	params [
		["_bloodLoss",0,[0]],
		["_part","",[""]],
		["_wound","",[""]]
	];
	if(!(_wound IN ["bullet_9","bullet_45","bullet_357","bullet_46","bullet_50","bullet_556","bullet_570","bullet_65","bullet_68","bullet_762","bullet_12","bullet_12S","bullet_338","bullet_127","bullet_408","bullet_3006"])) exitWith {_bloodLoss};
	private _partDamage = switch(true) do {
		case ((_part IN ["face_hub","head"]) && {_wound isEqualTo "bullet_9"}): {Medical_BloodLoss_With_9_Bullets};
		case ((_part IN ["face_hub","head"]) && {_wound isEqualTo "bullet_45"}): {Medical_BloodLoss_With_45_Bullets};
		case ((_part IN ["face_hub","head"]) && {_wound isEqualTo "bullet_357"}): {Medical_BloodLoss_With_357_Bullets};
		case ((_part IN ["face_hub","head"]) && {_wound isEqualTo "bullet_46"}): {Medical_BloodLoss_With_46_Bullets};
		case ((_part IN ["face_hub","head"]) && {_wound isEqualTo "bullet_50"}): {Medical_BloodLoss_With_50_Bullets};
		case ((_part IN ["face_hub","head"]) && {_wound isEqualTo "bullet_556"}): {Medical_BloodLoss_With_556_Bullets};
		case ((_part IN ["face_hub","head"]) && {_wound isEqualTo "bullet_68"}): {Medical_BloodLoss_With_68_Bullets};
		case ((_part IN ["face_hub","head"]) && {_wound isEqualTo "bullet_762"}): {Medical_BloodLoss_With_762_Bullets};
		case ((_part IN ["face_hub","head"]) && {_wound isEqualTo "bullet_12"}): {Medical_BloodLoss_With_12_Bullets};
		case (_part IN ["pelvis","spine1","spine2"]): {1};
		case (_part IN ["neck","spine3","body"]): {1};
		case (_part IN ["arms","hands"]): {0.8};
		case (_part isEqualTo "legs"): {0.8};
		default {1};
	};
	_bloodLoss * _partDamage;
}] call compile_Global;

["A3PL_Medical_GetBulletWound",
{
	params [["_projectile","",[""]]];
	private _bulletWound = switch(true) do {
		case (_projectile IN Medical_9_Bullets): {"bullet_9"};
		case (_projectile IN Medical_45_Bullets): {"bullet_45"};
		case (_projectile IN Medical_357_Bullets): {"bullet_357"};
		case (_projectile IN Medical_46_Bullets): {"bullet_46"};
		case (_projectile IN Medical_50_Bullets): {"bullet_50"};
		case (_projectile IN Medical_556_Bullets): {"bullet_556"};
		case (_projectile IN Medical_570_Bullets): {"bullet_570"};
		case (_projectile IN Medical_65_Bullets): {"bullet_65"};
		case (_projectile IN Medical_68_Bullets): {"bullet_68"};
		case (_projectile IN Medical_762_Bullets): {"bullet_762"};
		case (_projectile IN Medical_338_Bullets): {"bullet_338"};
		case (_projectile IN Medical_127_Bullets): {"bullet_127"};
		case (_projectile IN Medical_408_Bullets): {"bullet_408"};
		case (_projectile IN Medical_12_Bullets): {"bullet_12"};
		case (_projectile IN Medical_12S_Bullets): {"bullet_12S"};
		case (_projectile IN Medical_3006_Bullets): {"bullet_3006"};
		default {"shrapnel"};
	};
	_bulletWound;
}] call compile_Global;

["A3PL_Medical_HasWound",
{
	params [["_player",objNull,[objNull]], ["_part","",[""]], ["_woundsCheck",[],[]]];
	private _hasWound = false;
	private _pWounds = _player getVariable ["A3PL_Wounds",[]];
	private _wound = "";
	if ((_woundsCheck isEqualType "")) then {_woundsCheck = [_woundsCheck];};
	{
		_wound = _x;
		{
			if ((_x select 0) == _part) exitwith {
				for "_i" from 1 to (count _x-1) do {
					private _woundArr = _x select _i;
					if ((_woundArr select 0) == _wound) exitwith {
						_hasWound = true;
					};
				};
			};
		} foreach _pWounds;
	} foreach _woundsCheck;
	_hasWound;
}] call compile_Global;

["A3PL_Medical_IsWoundStable",
{
	params [["_player",objNull,[objNull]], ["_part","",[""]], ["_woundsCheck",[],[]]];
	private _hasWound = false;
	private _pWounds = _player getVariable ["A3PL_Wounds",[]];
	private _wound = "";
	if (_woundsCheck isEqualType "") then {_woundsCheck = [_woundsCheck];};
	{
		_wound = _x;
		{
			if ((_x select 0) == _part) exitwith {
				for "_i" from 1 to (count _x-1) do {
					private _woundArr = _x select _i;
					if ((_woundArr select 0) == _wound) exitwith {
						_hasWound = _woundArr select 1;
					};
				};
			};
		} foreach _pWounds;
	} foreach _woundsCheck;
	_hasWound;
}] call compile_Global;

/*
	NPCs Functions
*/

["A3PL_Medical_Heal",
{
	if (!A3PL_FD_Clinic) exitwith {[("STR_A3PL_Medical_YouCantBeHealedHereWhenFDAreOnDuty" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _healPrice = Medical_Heal_Price;
	private _npc = player_objintersect;
	private _timeTaken = 0;
	if((count([("STR_Common_FIFR" call A3PL_Localize)] call A3PL_Lib_FactionPlayers)) isEqualTo 0) then {
		private _pWounds = player getVariable ["A3PL_Wounds",[]];
		{
			private _pWound = _x#1#0;
			private _timeToAdd = switch (_pWound) do {
				case "cut": {15};
				case "bone_broken": {45};
				case "wound_minor": {30};
				case "wound_major": {60};
				default {30};
			};
			_timeTaken = _timeTaken + _timeToAdd;
		} forEach _pWounds;
	} else {
		_timeTaken = 120;
	};
	if (_timeTaken isEqualTo 0) then {_timeTaken = 30;};
	if (_timeTaken > 180) then {_timeTaken = 180;};
	/* START HOW TO PAY */
	[_healPrice] call A3PL_Bank_HowToPay;
	waitUntil {(player getVariable["paymentResult", objNull]) isNotEqualTo objNull};
	if (!(player getVariable "paymentResult")) exitWith {};
	/* END HOW TO PAY */
	[("STR_Common_FireDepartment" call A3PL_Localize),_healPrice] remoteExec ["Server_Government_AddBalance",2];

	private _bulletWound = [player] call A3PL_Medical_HasBulletWound;
	if(_bulletWound) then {
		private _namePos = [getPos _npc] call A3PL_Housing_PosAddress;
		[("STR_Common_FISD" call A3PL_Localize),("STR_A3PL_Medical_BulletWound" call A3PL_Localize),getPos player,format[("STR_A3PL_Medical_SomeoneAskedToBeHealForBulletWound" call A3PL_Localize),_namePos],("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
	};

	[format [("STR_A3PL_Medical_WaitBeforeBeTotallyHealed" call A3PL_Localize),_timeTaken],Color_Orange] call A3PL_Notification;
	if (Player_ActionDoing) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	player setVariable["beingTreated",true,true];
	[("STR_A3PL_Medical_Heal" call A3PL_Localize),_timeTaken] spawn A3PL_Lib_LoadAction;
	waitUntil{Player_ActionDoing};
	while {Player_ActionDoing} do {
		if ((vehicle player) isNotEqualTo player) exitwith {Player_ActionInterrupted = true;};
		if ((player distance2D _npc) > 10) then {Player_ActionInterrupted = true;}
	};
	player setVariable["beingTreated",nil,true];
	if(Player_ActionInterrupted) exitWith {[("STR_A3PL_Medical_HealCancelled" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	[getPlayerUID player,(player getVariable ["character_id",""]),"Medical_DrBob",[format ["Location: %1 | Time Taken: %2",(getPosATL player),_timeTaken]]] remoteExec ["Server_Log_New",2];

	player setDamage 0;
	player setVariable ["A3PL_Wounds",[],true];
	player setVariable ["A3PL_Medical_Blood",Medical_Max_BloodLevel,true];
	player setVariable ["A3PL_Medical_Alive",true,true];
}] call compile_Global;

["A3PL_Medical_Heal_Ill",
{
	private _healPrice = Medical_Illegal_Heal_Price;
	private _pCash = player getVariable ["player_cash",0];
	private _npc = player_objintersect;
	private _faction = player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
	if(_faction IN [("STR_Common_FIFR" call A3PL_Localize),("STR_Common_FISD" call A3PL_Localize)]) exitWith {[("STR_A3PL_Medical_YouCantBeHealedHereWhenFDAreOnDuty" call A3PL_Localize)] call A3PL_Notification;};
	if (_healPrice > _pCash) exitwith {[format [("STR_A3PL_Medical_YouNeedMoneyToBeHealed" call A3PL_Localize),_healPrice-_pCash]] call A3PL_Notification;};
	player setVariable ["player_cash",(player getVariable ["player_cash",0]) - _healPrice,true];
	private _timeTaken = 0;
	if((count([("STR_Common_FIFR" call A3PL_Localize)] call A3PL_Lib_FactionPlayers)) isEqualTo 0) then {
		private _pWounds = player getVariable ["A3PL_Wounds",[]];
		{
			private _pWound = _x#1#0;
			private _timeToAdd = switch (_pWound) do {
				case "cut": {15};
				case "bone_broken": {45};
				case "wound_minor": {30};
				case "wound_major": {60};
				default {30};
			};
			_timeTaken = _timeTaken + _timeToAdd;
		} forEach _pWounds;
	} else {
		_timeTaken = 120;
	};
	if (_timeTaken isEqualTo 0) then {_timeTaken = 30;};
	if (_timeTaken > 180) then {_timeTaken = 180;};

	[format[("STR_A3PL_Medical_WaitBeforeBeTotallyHealed" call A3PL_Localize),_timeTaken],Color_Orange] call A3PL_Notification;
	if (Player_ActionDoing) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[("STR_A3PL_Medical_Heal" call A3PL_Localize),_timeTaken] spawn A3PL_Lib_LoadAction;
	waitUntil{Player_ActionDoing};
	while {Player_ActionDoing} do {
		if ((vehicle player) isNotEqualTo player) exitwith {Player_ActionInterrupted = true;};
		if (player distance2D _npc > 10) then {Player_ActionInterrupted = true;}
	};
	if(Player_ActionInterrupted) exitWith {[("STR_A3PL_Medical_HealCancelled" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	[getPlayerUID player,(player getVariable ["character_id",""]),"Medical_DrBob_Ill",[format ["Location: %1 | Time Taken: %2",(getPosATL player),_timeTaken]]] remoteExec ["Server_Log_New",2];

	player setDamage 0;
	player setVariable ["A3PL_Wounds",[],true];
	player setVariable ["A3PL_Medical_Blood",Medical_Max_BloodLevel,true];
	player setVariable ["A3PL_Medical_Alive",true,true];
}] call compile_Global;

/*
	Medical System Effects
*/

["A3PL_Medical_PepperSpray",{
	private _hndl = ppEffectCreate ['dynamicBlur', 505];
	_hndl ppEffectEnable true;
	_hndl ppEffectAdjust [5];
	_hndl ppEffectCommit 0;
	waitUntil {!([player,"head","pepper_spray"] call A3PL_Medical_HasWound)};
	ppEffectDestroy _hndl;
}] call compile_Global;

["A3PL_Medical_Concussion",{
	private _hndl = ppEffectCreate ['ColorCorrections', 50];
	_hndl ppEffectEnable true;
	_hndl ppEffectAdjust [1, 0.4, 0, [0, 0, 0, 0], [1, 1, 1, 0.5], [0.299, 0.587, 0.114, 0]];
	_hndl ppEffectCommit 0;
	waitUntil {([player,"head","concussion"] call A3PL_Medical_IsWoundStable) || !([player,"head","concussion"] call A3PL_Medical_HasWound)};
	_hndl ppEffectAdjust [1, 0.8, 0, [0, 0, 0, 0], [1, 1, 1, 0.8], [0.299, 0.587, 0.114, 0]];
	_hndl ppEffectCommit 0;
	waitUntil {!([player,"head","concussion"] call A3PL_Medical_HasWound)};
	ppEffectDestroy _hndl;
}] call compile_Global;

["A3PL_Medical_Tazed", {
	params [
		["_unit",objNull,[objNull]],
		["_shooter",objNull,[objNull]],
		["_selection","",[""]],
		["_projectile","",[""]]
	];
	if (isNull _unit || isNull _shooter) exitWith {player allowDamage true; Player_Ragdoll = false;};
	if (_shooter isKindOf "CAManBase" && (alive player)) then {
		if (!Player_Ragdoll) then {
			if (_projectile IN ["A3PL_TaserBullet","A3PL_Taser2_Ammo"]) then {[player,[_selection] call A3PL_Medical_GetHitPart,"taser_probes"] call A3PL_Medical_ApplyWound;};
			if((vest _unit) isEqualTo "A3PL_SuicideVest") then {call A3PL_Criminal_SuicideVest;};
			[] call A3LL_Lib_Ragdoll_Tazer;
		};
	};
}] call compile_Global;

/*
	Medical Logging System
*/

["A3PL_Medical_AddLog",
{
	params [
		["_unit",player,[player]],
		["_text","",[""]],
		["_color","",[[]]]
	];
	private _log = _unit getVariable ["A3PL_MedicalLog",[]];
	if ((count _log) >= Medical_LogLimit) then {_log deleteAt 0;};
	_log pushback [format ["%2:%3 - %1",_text,(date select 3),(date select 4)],_color];
	_unit setVariable ["A3PL_MedicalLog",_log,true];
}] call compile_Global;

["A3PL_Medical_ClearLog",
{
	private _player = param [0,A3PL_MedicalVar_Target];
	private _job = player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
	if !(_job isEqualTo ("STR_Common_FIFR" call A3PL_Localize)) exitwith {[("STR_A3PL_Medical_OnlyEMSCanConsultFiles" call A3PL_Localize)] call A3PL_Notification;};
	if (isNull _player) exitwith {};
	_player setVariable ["A3PL_MedicalLog",nil,true];
	[(findDisplay 73),_player] call A3PL_Medical_LoadParts;
}] call compile_Global;

/*
	Die function
*/

["A3PL_Medical_Die",
{
	params [["_unit",objNull,[objNull]],["_corspe",objNull,[objNull]]];
	private _lastDamage = _corspe getVariable ["lastDamage",("STR_Common_Unknown" call A3PL_Localize)];
	disableSerialization;

	[getPlayerUID _unit,(_unit getVariable ["character_id",""]),"Medical_Death",[format ["Killer: %1 | Position: %2",_unit getVariable["lastDamage","self"], getPosATL player]]] remoteExec ["Server_Log_New",2];
	if(Player_ActionDoing) then {Player_ActionInterrupted = true;};

	[_unit,"AinjPpneMstpSnonWrflDnon"] remoteExec ["A3PL_Lib_SyncAnim",-2];
	_unit setVariable ["A3PL_Medical_Alive",false,true];
	_unit setVariable ["TimeRemaining",_timer,true];
	_unit setVariable ["tf_voiceVolume", 0, true];
	_unit setDamage 0;
	_unit setDir (getDir _corspe);
	_unit setPosASL (visiblePositionASL _corspe);
	_unit setUnitLoadout A3PL_Player_DeadBodyGear;
	deleteVehicle _corspe;

	A3PL_deathCam = "CAMERA" camCreate (getPosATL _unit);
	A3PL_deathCam cameraEffect ["INTERNAL","BACK"];
	A3PL_deathCam camSetTarget _unit;
	A3PL_deathCam camSetRelPos [0,3.5,4.5];
	A3PL_deathCam camSetFOV .5;
	A3PL_deathCam camSetFocus [50,0];
	A3PL_deathCam camCommit 0;

	[_unit,_lastDamage,600] spawn {
		disableSerialization;
		private _unit = _this select 0;
		private _lastDamage = _this select 1;
		private _timer = _this select 2;
		private _exit = false;
		private _called = "";
		private _getDay = _unit getVariable["Player_PerkDay",0];
		if ((["life_alert",1] call A3PL_Inventory_Has) || {(_getDay > 0)}) then {
			_called = ("STR_A3PL_Medical_HaveLifeAlert" call A3PL_Localize);
		} else {
			_called = ("STR_A3PL_Medical_DoNotHaveLifeAlert" call A3PL_Localize);
		};
		while {!(_unit getVariable ["A3PL_Medical_Alive",false])} do
		{
			_unit setOxygenRemaining 1;
			private _format = format [("STR_A3PL_Medical_DoNotDoubleTapped" call A3PL_Localize),_timer,_lastDamage];
			if(_unit getVariable ["DoubleTapped",false]) then {
				_format = format [("STR_A3PL_Medical_DoubleTapped" call A3PL_Localize),_timer,_lastDamage];
				if ((animationState _unit) != "Incapacitated") then {
					[_unit,"Incapacitated"] remoteExec ["A3PL_Lib_SyncAnim",-2];
				};
			} else {
				if ((animationState _unit) != "AinjPpneMstpSnonWrflDnon") then {
					[_unit,"AinjPpneMstpSnonWrflDnon"] remoteExec ["A3PL_Lib_SyncAnim",-2];
				};
			};
			cutText[format["%1 %2",_format,_called],"BLACK FADED", 600, false, true, false];
			sleep 1;
			if !(_unit getVariable["reviving",false]) then {_timer = _timer - 1;};
			_unit setVariable ["TimeRemaining",_timer,true];
			if (_timer <= 0) exitwith {_exit = true;};
			private _chance = random 101;
			if (_chance > 85) then {
			cutText[format["%1 %2",_format,_called],"BLACK IN", -1, false, true, false];
			sleep 1;
			if !(_unit getVariable["reviving",false]) then {_timer = _timer - 1;};
			_unit setVariable ["TimeRemaining",_timer,true];
			if (_timer <= 0) exitwith {_exit = true;};
			cutText[format["%1 %2",_format,_called],"BLACK OUT", -1, false, true, false];
			sleep 1;
			if !(_unit getVariable["reviving",false]) then {_timer = _timer - 1;};
			_unit setVariable ["TimeRemaining",_timer,true];
			if (_timer <= 0) exitwith {_exit = true;};
			};
		};
		if(_exit) then {
			call A3PL_Medical_Respawn;
			cutText["","BLACK IN"];
		} else {
			[] spawn A3PL_Medical_Revived;
			cutText["","BLACK IN"];
		};
	};
}] call compile_Global;

["A3PL_Medical_Respawn",
{
	private _bodyPos = getPos player;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Medical_Respawned",[format ["Position: %1",(getPosATL player)]]] remoteExec ["Server_Log_New",2];

	A3PL_deathCam cameraEffect ["TERMINATE","BACK"];
	camDestroy A3PL_deathCam;
	if(dialog) then {closeDialog 0;};

	player switchMove "";
	player setDamage 0;
	player setVariable ["DoubleTapped",nil,true];
	player setVariable ["Incapacitated",false,true];
	player setVariable ["Cuffed",nil,true];
	player setVariable ["Zipped",nil,true];
	player setVariable ["A3PL_Wounds",[],true];
	player setVariable ["A3PL_Medical_Alive",true,true];
	player setVariable ["A3PL_Medical_Blood",Medical_Max_BloodLevel,true];
	player setVariable ["A3PL_MedicalLog",nil,true];
	player setVariable ["TimeRemaining",nil,true];
	player setVariable ["jail_mark",false,true];
	player setVariable ["jailed",false,true];
	player setVariable ["jailtime",nil,true];
	player setVariable ["fakeName",nil,true];
	[player] remoteExec ["Server_Criminal_RemoveJail", 2];

	player allowDamage true;

	Player_Hunger = 100;
	Player_Thirst = 100;
	Player_Alcohol = 0;
	Player_Drugs = [0,0,0];
	player setVariable ["player_hunger",Player_Hunger,false];
	player setVariable ["player_thirst",Player_Thirst,false];
	player setVariable ["player_alcohol",Player_Alcohol,false];
	player setVariable ["player_drugs",Player_Drugs,false];

	if (Pee_System == true) then {
		Player_Pee = 100;
		player setVariable ["player_pee",Player_Pee,false];
	};
	if (Sleep_System == true) then {
		Player_Sleep = 100;
		player setVariable ["player_sleep",Player_Sleep,false];
	};

	removeHeadgear player;
	removeGoggles player;
	removeAllItemsWithMagazines player;
	removeAllWeapons player;
	removeAllContainers player;
	//removeAllAssignedItems player;

	[player] remoteExec ["Server_Inventory_RemoveAll", 2];
	if(player getVariable "gender" isEqualTo "male") then {
		player addUniform (selectRandom Medical_Uniform_ToAdd_After_Death);
	} else {
		player addUniform (selectRandom Medical_Female_Uniform_ToAdd_After_Death);
	};
	player linkItem "ItemGPS";
	player linkItem "ItemMap";
	player linkItem "ItemCompass";

	private _nearestClinic = nearestObjects [_bodyPos, ["Land_A3PL_Clinic"], 10000];
	if(count(_nearestClinic) > 0) then {
		private _clinic = _nearestClinic select 0;
		private _clinicPos = getPos _clinic;
		private _nearDOC = count(nearestObjects [_clinicPos, ["Land_A3PL_Prison"], 100]) > 0;
		if(_nearDOC) then {
			_clinic = _nearestClinic select 1;
		};
		player setPosATL (_clinic modelToWorld [-7,-7,-2.5]);
		player setDir ((getDir _clinic)-140);
	} else {
		player setPos [3039.39,5625.54,0.00143909];
		player setdir 28;
	};
	player playAction "PlayerStand";

	if (life_radio_connected) then {
		life_radio_connected = false;
		A3PL_iPhone_Freq = 0;
		player setVariable ["tf_unable_to_use_radio", true];
		[(call TFAR_fnc_activeSwRadio), 1, (player getVariable ["character_id",""])] call TFAR_fnc_SetChannelFrequency;
	};
	A3PL_Sony_Freq = 0;
	player setVariable ["SonyFreq",0,true];
	A3PL_Sony_FreqAdd = 0;
	player setVariable ["SonyFreqAdd",0,true];
	player setVariable ["tf_voiceVolume", 1, true];
	[player] remoteExec ["Server_Phone_getPhoneNumber",2];
	disableUserInput false;
}] call compile_Global;

["A3PL_Medical_ChestCompressions",{
	private _target = param [0,objNull];
	private _isBeingRevived = _target getVariable["reviving",false];

	if (_isBeingRevived) exitWith {[("STR_A3PL_Medical_SomeoneALreadyDoingRCP" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (Player_ActionDoing) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	player playmove "AinvPknlMstpSnonWnonDr_medic0";

	_target = _target getVariable["realPlayer",_target];
	[_target] spawn
	{
		private _target = param [0,objNull];
		if (Player_ActionDoing) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		[("STR_A3PL_Medical_RCP" call A3PL_Localize),Medical_CPR_Timer] spawn A3PL_Lib_LoadAction;
		[getPlayerUID player,(player getVariable ["character_id",""]),"Medical_CPR_Attempted",[format ["Target: %1",_target getVariable["name","unknown"]]]] remoteExec ["Server_Log_New",2];
		[getPlayerUID _target,(_target getVariable ["character_id",""]),"Medical_CPR_Attempt",[format ["Attempted By: %1",player getVariable["name","unknown"]]]] remoteExec ["Server_Log_New",2];
		_target setVariable["reviving",true,true];
		waitUntil{Player_ActionDoing};
		while {Player_ActionDoing} do {
			if(!(player getVariable["A3PL_Medical_Alive",true])) exitWith {Player_ActionInterrupted = true;};
			if (!(vehicle player isEqualTo player)) exitwith {Player_ActionInterrupted = true;};
			if (player getVariable ["Incapacitated",false]) exitwith {Player_ActionInterrupted = true;};
			if (animationState player != "AinvPknlMstpSnonWnonDr_medic0") then {player playmove "AinvPknlMstpSnonWnonDr_medic0";}
		};
		_target setVariable["reviving",false,true];

		if ((vehicle player) isEqualTo player) then {player switchMove "";};
		if (Player_ActionInterrupted) exitWith {
			[("STR_A3PL_Medical_RCPCancelled" call A3PL_Localize),Color_Red] call A3PL_Notification;
			[getPlayerUID player,(player getVariable ["character_id",""]),"Medical_CPR_Cancelled",[format ["Target: %1",_target getVariable["name","unknown"]]]] remoteExec ["Server_Log_New",2];
			[getPlayerUID _target,(_target getVariable ["character_id",""]),"Medical_CPR_Cancel",[format ["Cancelled By: %1",player getVariable["name","unknown"]]]] remoteExec ["Server_Log_New",2];
		};
		private _chance = random 100;
		if(["cpr",player] call A3PL_DMV_Check) then {_chance = random 45;};
		if(count([("STR_Common_FIFR" call A3PL_Localize)] call A3PL_Lib_FactionPlayers) < 3 && ["cpr",player] call A3PL_DMV_Check) then {_chance = random 28;};
		if((player getVariable ["job", ("STR_Common_Job_Unemployed" call A3PL_Localize)]) isEqualTo ("STR_Common_FIFR" call A3PL_Localize)) then {_chance = 0;};
		if(_chance <= 25) then {
			[_target,1500] call A3PL_Medical_ApplyVar;
			_target setVariable ["A3PL_Medical_Alive",true,true];
			[getPlayerUID player,(player getVariable ["character_id",""]),"Medical_CPR_Succeed",[format ["Target: %1",_target getVariable["name","unknown"]]]] remoteExec ["Server_Log_New",2];
			[getPlayerUID _target,(_target getVariable ["character_id",""]),"Medical_CPR_Success",[format ["CPRd By: %1",player getVariable["name","unknown"]]]] remoteExec ["Server_Log_New",2];
		} else {
			[("STR_A3PL_Medical_RCPFailed" call A3PL_Localize),Color_Red] call A3PL_Notification;
			[getPlayerUID player,(player getVariable ["character_id",""]),"Medical_CPR_Failed",[format ["Target: %1",_target getVariable["name","unknown"]]]] remoteExec ["Server_Log_New",2];
			[getPlayerUID _target,(_target getVariable ["character_id",""]),"Medical_CPR_Fail",[format ["Failed By: %1",player getVariable["name","unknown"]]]] remoteExec ["Server_Log_New",2];
		};
	};
}] call compile_Global;

["A3PL_Medical_DragBody",{
	private _target = param [0,objNull];
	private _dragged = _target getVariable["dragged",false];
	private _dragging = player getVariable["dragging",false];

	if (_dragged) exitWith {[("STR_A3PL_Medical_SomeoneAlreadyDragBody" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_dragging) exitWith {[("STR_A3PL_Medical_YouAlreadyDragABody" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	player setVariable["dragging",true,true];
	_target setVariable["dragged",true,true];
	_target attachTo [player,[0,1,0]];

	player playAction "grabDrag";
	player forceWalk true;
	Player_ActionDoing = true;
	while{(player getVariable["dragging",false])} do {
		if (_target getVariable["A3PL_Medical_Alive",true]) exitWith {};
		if !(player getVariable["A3PL_Medical_Alive",true]) exitWith {};
		if ((player distance _target) > 5) exitWith {};
		if (Player_ActionInterrupted) exitWith {};
	};
	Player_ActionDoing = false;
	if(Player_ActionInterrupted) then {Player_ActionInterrupted = false};
	detach _target;
	player playMove "amovpknlmstpsraswrfldnon";
	player forceWalk false;
	player setVariable["dragging",nil,true];
	_target setVariable["dragged",nil,true];
}] call compile_Global;

["A3PL_Medical_Revived",
{
	if(!isNil "A3PL_deathCam") then {
		A3PL_deathCam cameraEffect ["TERMINATE","BACK"];
		camDestroy A3PL_deathCam;
	};
	if(dialog) then {closeDialog 0;};
	player setVariable ["DoubleTapped",nil,true];
	player setVariable ["Incapacitated",false,true];
	player setVariable ["A3PL_Medical_Alive",true,true];
	player setVariable ["TimeRemaining",nil,true];
	player setVariable ["tf_voiceVolume", 1, true];
	player switchMove "AidlPpneMstpSnonWnonDnon_AI";
	call A3LL_EventHandlers_RadioAnim;
	if(player getVariable["cuffed",false] || {player getVariable["zipped",false]}) then {[player,"A3PL_HandsupKneelKicked"] remoteExec ["A3PL_Lib_SyncAnim", -2];};
	if((backpack player) isEqualTo "A3PL_LR") then {[(call TFAR_fnc_activeLrRadio), A3PL_Player_DeadRadio] call TFAR_fnc_setLrSettings;};
	disableUserInput false;
}] call compile_Global;

["A3PL_Medical_LifeAlert",
{
	private _position = getPos player;
	private _fMembers = [] call A3PL_Lib_AllFactionPlayers;
	[player,"life_alert",-1] remoteExec ["Server_Inventory_Add",2];
	[("STR_Common_FIFR" call A3PL_Localize),("STR_A3PL_Medical_LifeAlert" call A3PL_Localize),_position,("STR_A3PL_Medical_LifeAlertDeclanched" call A3PL_Localize),("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
	[_position, ("STR_A3PL_Medical_LifeAlert" call A3PL_Localize),"Default","A3FL_Markers_Medical"] remoteExec ["A3PL_Lib_CreateMarker",_fMembers];
	[_position] remoteExec ["A3PL_GPS_NavigateToPosition",_fMembers];
}] call compile_Global;

["A3PL_Medical_TrumpCare",
{
	private _position = getPos player;
	private _fMembers = [] call A3PL_Lib_AllFactionPlayers;
	[("STR_Common_FIFR" call A3PL_Localize),("STR_A3PL_Medical_LifeAlertTrumpCare" call A3PL_Localize),_position,("STR_A3PL_Medical_LifeAlertTrumpCare" call A3PL_Localize),("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
	[_position, "Trump Care","Default","A3FL_Markers_Medical"] remoteExec ["A3PL_Lib_CreateMarker",_fMembers];
	[_position] remoteExec ["A3PL_GPS_NavigateToPosition",_fMembers];
}] call compile_Global;

["A3PL_Medical_BloodBag",
{
	private _target = param [0,objNull];
	private _job = _target getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];

	private _filledCooldown = _target getVariable ["BloogBagFilled",serverTime - Medical_BloodBag_Cooldown];
	if (_filledCooldown > (serverTime - Medical_BloodBag_Cooldown)) exitWith {[("STR_A3PL_Medical_BloodAlreadyFIlled" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	[("STR_A3PL_Medical_EMSTakeYourBlood" call A3PL_Localize), Color_green] remoteExec ["A3PL_Notification",_target];
	[player,"AmovPercMstpSnonWnonDnon_AinvPercMstpSnonWnonDnon_Putdown"] remoteExec ["A3PL_Lib_SyncAnim",0];

	[_target] spawn
	{
		private _target = param [0,objNull];
		private _blood = _target getVariable["A3PL_Medical_Blood",Medical_Max_BloodLevel];
		if (_blood < Medical_BloodLoss_DonSang) exitWith {[("STR_A3PL_Medical_PlayerDoNotHaveEnoughBlood" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		if (Player_ActionDoing) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		[("STR_A3PL_Medical_TakingBlood" call A3PL_Localize),8] spawn A3PL_Lib_LoadAction;
		private _success = true;
		waitUntil{Player_ActionDoing};
		while {Player_ActionDoing} do {
			if ((player distance2D _target) > 5) exitWith {_success = false;};
			if ((animationState player) isEqualTo "amovpercmstpsnonwnondnon") then {[player,"AmovPercMstpSnonWnonDnon_AinvPercMstpSnonWnonDnon_Putdown"] remoteExec ["A3PL_Lib_SyncAnim",0];};
		};
		player switchMove "";
		if(Player_ActionInterrupted || !_success) exitWith {
			[("STR_A3PL_Medical_StopTaking" call A3PL_Localize),Color_Red] call A3PL_Notification;
			[("STR_A3PL_Medical_TakingBloodStopped" call A3PL_Localize), Color_green] remoteExec ["A3PL_Notification",_target];
		};
		_target setVariable ["BloogBagFilled",serverTime,true];
		private _newBlood = _blood - Medical_BloodLoss_DonSang;
		_target setVariable ["A3PL_Medical_Blood",_newBlood,true];
		[player,"meds_bloodbagempty",-1] remoteExec ["Server_Inventory_Add",2];
		["meds_bloodbag",2] call A3PL_Inventory_Add;
		[] call A3PL_Inventory_Clear;
		[("STR_A3PL_Medical_YouTakedBlood" call A3PL_Localize),Color_Red] call A3PL_Notification;
		
		// Régénération progressive du sang de la cible
		[_target, _blood, _newBlood] spawn {
			params ["_target", "_originalBlood", "_currentBlood"];
			private _bloodToRegen = Medical_BloodLoss_DonSang;
			private _regenAmount = 50; // Quantité de sang régénérée par cycle
			private _regenInterval = 30; // Intervalle en secondes entre chaque régénération
			private _maxBlood = _target getVariable ["A3PL_Medical_Blood",Medical_Max_BloodLevel];
			
			while {_bloodToRegen > 0 && alive _target} do {
				uiSleep _regenInterval;
				if (!alive _target) exitWith {};
				
				private _currentBloodLevel = _target getVariable ["A3PL_Medical_Blood",Medical_Max_BloodLevel];
				if (_currentBloodLevel >= _originalBlood) exitWith {}; // Le sang est déjà revenu à son niveau initial
				
				private _regen = _regenAmount;
				if (_regen > _bloodToRegen) then {
					_regen = _bloodToRegen;
				};
				if ((_currentBloodLevel + _regen) > _originalBlood) then {
					_regen = _originalBlood - _currentBloodLevel;
				};
				
				_bloodToRegen = _bloodToRegen - _regen;
				_target setVariable ["A3PL_Medical_Blood", _currentBloodLevel + _regen, true];
			};
		};
	};
}] call compile_Global;

["A3PL_Medical_Autograft",
{
	private _target = param [0,objNull];
	private _job = _target getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];

	private _filledCooldown = _target getVariable ["AutograftFilled",serverTime - Medical_Autograft_Cooldown];
	if (_filledCooldown > (serverTime - Medical_Autograft_Cooldown)) exitWith {[("STR_A3PL_Medical_BloodAlreadyFIlled" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	[("STR_A3PL_Medical_TakingSkin" call A3PL_Localize), Color_green] remoteExec ["A3PL_Notification",_target];
	[player,"AmovPercMstpSnonWnonDnon_AinvPercMstpSnonWnonDnon_Putdown"] remoteExec ["A3PL_Lib_SyncAnim",0];

	[_target] spawn
	{
		private _target = param [0,objNull];
		if (Player_ActionDoing) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		[("STR_A3PL_Medical_TakingBlood" call A3PL_Localize),8] spawn A3PL_Lib_LoadAction;
		private _success = true;
		waitUntil{Player_ActionDoing};
		while {Player_ActionDoing} do {
			if ((player distance2D _target) > 5) exitWith {_success = false;};
			if ((animationState player) isEqualTo "amovpercmstpsnonwnondnon") then {[player,"AmovPercMstpSnonWnonDnon_AinvPercMstpSnonWnonDnon_Putdown"] remoteExec ["A3PL_Lib_SyncAnim",0];};
		};
		player switchMove "";
		if(Player_ActionInterrupted || !_success) exitWith {
			[("STR_A3PL_Medical_StopTaking" call A3PL_Localize),Color_Red] call A3PL_Notification;
			[("STR_A3PL_Medical_TakingBloodStopped" call A3PL_Localize), Color_green] remoteExec ["A3PL_Notification",_target];
		};
		_target setVariable ["AutograftFilled",serverTime,true];
		[player,"med_autograftkit",-1] remoteExec ["Server_Inventory_Add",2];
		["med_autograft",1] call A3PL_Inventory_Add;
		[] call A3PL_Inventory_Clear;
		[("STR_A3PL_Medical_YouTakedSkin" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};
}] call compile_Global;

["A3PL_Medical_Killed",
{
	params [["_unit",objNull,[objNull]]];
	_unit setVariable ["tf_voiceVolume", 0, true];
	if !((vehicle _unit) isEqualTo _unit) then {
		UnAssignVehicle _unit;
		_unit action ["getOut", vehicle _unit];
		_unit setPosATL [(getPosATL _unit select 0) + 3, (getPosATL _unit select 1) + 1, 0];
	};
	if (dialog) then {closeDialog 0;};
	private _getDay = _unit getVariable["Player_PerkDay",0];
	if (_getDay > 0) then {call A3PL_Medical_TrumpCare;};
	if((["life_alert"] call A3PL_Inventory_Has) && !(_getDay > 0)) then {call A3PL_Medical_LifeAlert;};

	A3PL_Player_DeadBodyGear = getUnitLoadout _unit;
	if((backpack _unit) isEqualTo "A3PL_LR") then {A3PL_Player_DeadRadio = (call TFAR_fnc_activeLrRadio) call TFAR_fnc_getLrSettings;};
	
	if(player getVariable ["dbVar_AdminLevel",0] < 3) then {disableUserInput true;};
}] call compile_Global;

["A3PL_Medical_LimpCheck",
{
	private _wounds = player getVariable["A3PL_Wounds",[]];
	private _hitParts = (getAllHitPointsDamage player) select 1;
	if(_wounds isEqualTo []) exitWith {player setDamage 0;};
	{
		private _selections = switch (true) do {
			default {[]};
			case (_x IN ["face_hub","head"]): {["head"]};
			case (_x IN ["pelvis","spine1"]): {["pelvis"]};
			case (_x isEqualTo "spine2"): {["torso"]};
			case (_x IN ["neck","spine3","body"]): {["chest"]};
			case (_x IN ["arms","hands"]): {["right upper arm","right lower arm","left lower arm","left upper arm"]};
			case (_x isEqualTo "legs"): {["right upper leg","right lower leg","left lower leg","left upper leg"]};
		};
		private _isHit = ({(_x select 0) IN _selections} count _wounds) > 0;
		if(!_isHit) then {player setHit [_x,0];};
	} foreach _hitParts;
}] call compile_Global;

["A3PL_Medical_RemoveWound",
{
	params [
		["_unit",objNull,[objNull]],
		["_part","",[""]],
		["_wound","",[""]]
	];
	private _woundName = [_wound,0] call A3PL_Config_GetWoundData;
	private _wounds = _unit getVariable ["A3PL_Wounds",[]];
	{
		if ((_x select 0) == _part) exitwith
		{
			_i = 1;
			_woundArr = _x select _i;
			if ((_woundArr select 0) isEqualTo _wound) exitwith
			{
				_x deleteAt _i;
				if ((count _x) < 2) then {_wounds deleteAt _forEachIndex;};
			};
		};
	} foreach _wounds;
	_unit setVariable ["A3PL_Wounds",_wounds,true];
	[] remoteExecCall ["A3PL_Medical_LimpCheck",_unit];
}] call compile_Global;

["A3PL_Medical_HasBulletWound",
{
	params [
		["_unit",objNull,[objNull]]
	];
	private _hasBulletWound = false;
	private _wounds = _unit getVariable ["A3PL_Wounds",[]];
	{

		for "_i" from 1 to (count _x-1) do {
			private _woundArr = _x#_i;
			if (["bullet", _woundArr#0] call BIS_fnc_inString) exitwith {_hasBulletWound = true;};
		};
		if(_hasBulletWound) exitWith {};
	} foreach _wounds;
	_hasBulletWound;
}] call compile_Global;
