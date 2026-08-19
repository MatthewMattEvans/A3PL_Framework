/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Police_TowBoat",
{
	private _towing = param[0,objNull];
	private _target = param[1,objNull];
	private _towingOffset = switch(typeOf _towing) do {
		default{[0,-6.9,-1.3]};
	};
	private _targetOffset = switch(typeOf _target) do {
		case "A3PL_Motorboat": {[0, 3, 0]};
		case "A3PL_RHIB": {[0, 2.7, 0.2]};
		case "C_Scooter_Transport_01_F": {[0, 1.7, -0.9]};
		case "A3FL_LCM": {[1.05, 9.6, -0.89]};
		case "A3PL_RBM": {[0.2, 6.8, 0]};
		default{[0, 0, 0]};
	};

	if(((typeOf _target) isEqualTo "A3FL_LCM") && {false}) exitWith {[("STR_A3PL_Police_LowerRamp" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if((_towing distance2D _target) >= 30) exitWith {[("STR_A3PL_Police_BoatTooFar" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if(_towing getVariable["towing",false]) exitWith {[("STR_A3PL_Police_AlreadyTowingBoat" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _rope = ropeCreate [_towing, _towingOffset, _target, _targetOffset, 30];
	_towing setVariable["towing",true,true];
	_towing setVariable["towingRope",_rope,true];
	_towing setTowParent _target;
}] call compile_Global;

["A3PL_Police_UntowBoat",
{
	private _towing = param[0,objNull];
	private _rope = _towing getVariable["towingRope",nil];
	if(!isNil "_rope") then {ropeDestroy _rope;};
	_towing setVariable["towing",nil,true];
	_towing setVariable["towingRope",nil,true];
}] call compile_Global;

["A3PL_Police_GPS",
{
	private _job = player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
	private _vehicles = [];
	private _markerColor = "colorBLUFOR";

	switch (_job) do {
		case ("STR_Common_FIFR" call A3PL_Localize): {
			_markerColor = "ColorRed";
			{
				private ["_typeOf","_found"];
				_typeOf = typeOf _x;
				_found = false;
				if(_typeOf isEqualTo "A3PL_Silverado_FD_Brush") then {
					_vehicles pushback [_x,""];
					_found = true;
				};
                if(_typeOf isEqualTo "EC_F450_Brush") then {
                    _vehicles pushback [_x,""];
                    _found = true;
                };
				if(_typeOf isEqualTo "EC_F150_A") then {
                    _vehicles pushback [_x,""];
                    _found = true;
                };
				if(_typeOf isEqualTo "EC_E350_A") then {
                    _vehicles pushback [_x,""];
                    _found = true;
                };
				if(_typeOf isEqualTo "A3PL_RBM") then {
                    _vehicles pushback [_x,""];
                    _found = true;
                };
				if(_typeOf isEqualTo "A3PL_Pierce_Pumper") then {
					_vehicles pushback [_x,""];
					_found = true;
				};
				if(_typeOf isEqualTo "A3PL_Pierce_Ladder") then {
					_vehicles pushback [_x,""];
					_found = true;
				};
				if(_typeOf isEqualTo "A3PL_Pierce_Rescue") then {
					_vehicles pushback [_x,""];
					_found = true;
				};
				if(_typeOf isEqualTo "A3FL_T440_Water_Tanker") then {
					_vehicles pushback [_x,""];
					_found = true;
				};
				if(_typeOf isEqualTo "A3PL_Pierce_Heavy_Ladder") then {
					_vehicles pushback [_x,""];
					_found = true;
				};
				if(_typeOf IN ["A3PL_E350","Jonzie_Ambulance","A3PL_CVPI_PD","A3PL_Tahoe_FD","A3PL_Mustang_PD","A3PL_Silverado_FD","A3FL_Explorer_Platinum_FD_20","A3FL_Taurus_FD","A3PL_Charger15_FD","A3FL_Tahoe_FD","A3PL_Mustang_PD","A3FL_CamaroZL1_PD"]) then {
					if((_x getVariable["CAD_Faction",""]) isEqualTo _job) then {
						_vehicles pushback [_x,""];
					};
					_found = true;
				};
				if (_typeOf IN ["Heli_Medium01_Medic_H","A3FL_AS_365"]) then {
					if((_x getVariable["CAD_Faction",""]) isEqualTo _job) then {
						_vehicles pushback [_x,""];
					};
					_found = true;
				};
				if (!_found) then {
					if (((typeOf _x) find "_FD") isNotEqualTo -1) then {
						_vehicles pushback [_x,"FD #"];
					};
				};
			} foreach vehicles;
		};
		case "dispatch": {
			{
				private ["_type","_callSign"];
				_type = typeOf _x;
				_callSign = "";
				_callSign = switch (_type) do {
					case "A3PL_Cutter": {" USCGC "};
					case "A3PL_Goose_USCG": {" WHALE "};
					case "A3PL_Jayhawk": {" GUARDIAN "};
					case "A3FL_AS_365": {" HITRON "};
					default {""};
				};
				if ((_x getVariable["CAD_On",false])) then {_vehicles pushBack [_x,format["%1%2 ",toUpper(_x getVariable["CAD_Faction",""]),_callSign]];};
			} foreach vehicles;
		};
		default {
			{
				if ((_x getVariable["CAD_On",false]) && {_x getVariable["CAD_Faction",""] isEqualTo _job && {!underwater _x}}) then {_vehicles pushBack [_x,""];};
			} foreach vehicles;
		};
	};

	if (!isNil "A3PL_Police_GPSmarkers") then {
		{deleteMarkerLocal _x;} foreach A3PL_Police_GPSmarkers;
	};

	A3PL_Police_GPSmarkers = [];
	{
		private _veh = _x#0;
		private _title = _x#1;
		private _squadnb = _veh getVariable["CAD_Squad",("STR_A3PL_Police_Undefined" call A3PL_Localize)];
		_marker = createMarkerLocal [format["unit_%1",random(999)],visiblePosition (_veh)];
		_marker setMarkerTypeLocal "A3PL_GPS";
		_marker setMarkerColorLocal _markerColor;
		_marker setMarkerSizeLocal [0.6, 0.6];
		_marker setMarkerDirLocal floor((getDir _veh) - 40);
		_marker setMarkerTextLocal format["%1%2",_title,_squadnb];
		A3PL_Police_GPSmarkers pushback _marker;
	} foreach _vehicles;
}] call compile_Global;

["A3PL_Police_HandleBreach",
{
	private _whitelist = [("STR_Common_FISD" call A3PL_Localize)];
	private _pJob = player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
	if(!(_pJob IN _whitelist)) exitWith {};

	private _intersect = missionNameSpace getVariable ["player_objintersect",objNull];
	private _nameIntersect = missionNameSpace getVariable ["player_nameintersect",""];

	if ((player distance (_intersect modelToWorld (_intersect selectionPosition _nameIntersect)) < 2) && (_nameIntersect IN ["door_1","door_2","door_3","door_4","door_5","door_6","door_7","door_8","door_9","door_10","door_11","door_12","door_13","door_14","door_15","door_16","door_17","door_18","door_19","door_20","door_21","door_22","door_23","door_24","door_25","door_26","door_27","door_28","door_29","door_30","door_31","door_32","door_33","door_34","door_35","door_36","door_37","door_38","door_39","door_40","door_41","door_42","door_43","door_44","door_45","door_46","door_47","door_48","door_49","door_50","storagedoor1","storagedoor2","storagedoor3","sdstoragedoor3","sdstoragedoor6","door_1_button","door_2_button","door_3_button","door_4_button","door_5_button","door_6_button","door_7_button","door_8_button","door_9_button","door_10_button","door_11_button","door_12_button","door_13_button","door_14_button","door_15_button","door_16_button","door_17_button","door_18_button","door_19_button","door_20_button","door_21_button","door_22_button","door_23_button","door_24_button","door_25_button","door_26_button","door_27_button","door_28_button","door_29_button","door_30_button","door_1_button2","door_2_button2","door_3_button2","door_4_button2","door_5_button2","door_6_button2","door_7_button2","door_8_button2","door_9_button2","door_10_button2","door_11_button2","door_12_button2","door_13_button2","door_14_button2","door_15_button2","door_16_button2","door_17_button2","door_18_button2","door_19_button2","door_20_button2","door_21_button2","door_22_button2","door_23_button2","door_24_button2","door_25_button2","door_26_button2","door_27_button2","door_28_button2","door_29_button2","door_30_button2","door_8_button1","door_8_button2"])) then {
		if (_nameIntersect IN ["door_1_button","door_2_button","door_3_button","door_4_button","door_5_button","door_6_button","door_7_button","door_8_button","door_9_button","door_10_button","door_11_button","door_12_button","door_13_button","door_14_button","door_15_button","door_16_button","door_17_button","door_18_button","door_19_button","door_20_button","door_21_button","door_22_button","door_23_button","door_24_button","door_25_button","door_26_button","door_27_button","door_28_button","door_29_button","door_30_button","door_1_button2","door_2_button2","door_3_button2","door_4_button2","door_5_button2","door_6_button2","door_7_button2","door_8_button2","door_9_button2","door_10_button2","door_11_button2","door_12_button2","door_13_button2","door_14_button2","door_15_button2","door_16_button2","door_17_button2","door_18_button2","door_19_button2","door_20_button2","door_21_button2","door_22_button2","door_23_button2","door_24_button2","door_25_button2","door_26_button2","door_27_button2","door_28_button2","door_29_button2","door_30_button2","door_8_button1","door_8_button2"]) then {[] call A3PL_Intersect_HandleDoors;};
		_intersect animate [_nameIntersect,1];
		_intersect setvariable [_var,0,false];
		_intersect setVariable [_var,(_intersect getVariable [_var,0]) + 0.2,false];
	};
}] call compile_Global;

["A3FL_Police_Frisk",
{
	private _target = param [0,objNull];
	if (!Player_ActionCompleted) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((player getVariable["cuffed",false]) || (player getVariable["zipped",false])) exitWith {};
	if (_target getVariable ["frisk",false]) exitwith {[("STR_A3PL_Police_AlreadyFrisking" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_target setVariable ["frisk",true,true];

	[("STR_A3PL_Police_Frisked" call A3PL_Localize), Color_green] remoteExec ["A3PL_Notification",_target];
	[player,"AmovPercMstpSnonWnonDnon_AinvPercMstpSnonWnonDnon_Putdown"] remoteExec ["A3PL_Lib_SyncAnim",0];
	[_target] spawn
	{
		private _target = param [0,objNull];

		if (Player_ActionDoing) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		[("STR_A3PL_Police_Frisking" call A3PL_Localize),PD_Time_To_Frisk] spawn A3PL_Lib_LoadAction;
		private _success = true;
		waitUntil{Player_ActionDoing};
		while {Player_ActionDoing} do {
			if ((player distance2D _target) > 5) exitWith {_success = false;};
			if ((animationState player) isEqualTo "amovpercmstpsnonwnondnon") then {[player,"AmovPercMstpSnonWnonDnon_AinvPercMstpSnonWnonDnon_Putdown"] remoteExec ["A3PL_Lib_SyncAnim",0];};
		};
		player switchMove "";
		if(Player_ActionInterrupted || !_success) exitWith {
			[("STR_A3PL_Police_FriskCanceled" call A3PL_Localize),Color_Red] call A3PL_Notification;
			[("STR_A3PL_Police_FriskCanceled" call A3PL_Localize), Color_green] remoteExec ["A3PL_Notification",_target];
			_target setVariable ["frisk",nil,true];
		};
		_target setVariable ["frisk",nil,true];

		// Check if player has the customs_officer trait
		private _traits = player getVariable ["Player_Traits", []];
		private _hasCustomsOfficerTrait = "customs_officer" in _traits;

		private _weps = weapons _target;
		private _classOne = ["hgun_Pistol_heavy_01_F","hgun_ACPC2_F","A3FL_Beretta92","A3FL_Glock17","A3FL_Glock17_Tan","A3FL_Glock17S","A3FL_Glock17_T","A3FL_Glock26","A3FL_Glock18","hgun_P07_blk_F","hgun_P07_khk_F","hgun_P07_F","hgun_Pistol_01_F","hgun_Rook40_F","A3PL_P226","A3FL_P227","hgun_Pistol_heavy_02_F","A3FL_Python","A3FL_PythonGold","A3FL_FNX45","A3ER_P320","hgun_Pistol_Signal_F","A3PL_Taser","A3PL_Taser2","A3PL_High_Pressure","A3FL_FiveSeven","A3FL_FiveSeven_Black","A3FL_FiveSeven_Pink"];
		private _highClass = ["A3PL_M16","A3PL_M16_Training","A3FL_M4","A3FL_M4_Training","A3FL_M870","arifle_AKM_F","A3FL_AK110","A3FL_AK110_Gold","A3FL_MK18","A3FL_ACR","A3FL_ACR_Pink","A3FL_ACR_Weeb","A3FL_Benelli","SMG_05_F","SMG_02_F","SMG_01_F","A3FL_UMP","A3FL_Vector","A3FL_MP7","A3FL_Uzi","A3FL_MP5K","A3FL_Thompson","A3FL_DesertEagle","A3FL_DesertEagleGold"];
		private _melee = ["A3FL_GolfDriver","A3FL_BaseballBat","A3FL_BaseballBatGold","A3FL_PoliceBaton","A3PL_FireAxe","A3PL_Shovel","A3PL_Pickaxe","A3PL_Golf_Club","A3FL_DickStick","A3FL_DickStickGold","A3FL_Crowbar","A3PL_Jaws","A3FL_PepperSpray"];
		private _authorized = ["A3PL_Paintball_Marker","A3PL_Paintball_Marker_Camo","A3PL_Paintball_Marker_DigitalBlue","A3PL_Paintball_Marker_Green","A3PL_Paintball_Marker_PinkCamo","A3PL_Paintball_Marker_Purple","A3PL_Paintball_Marker_Red","A3PL_Paintball_Marker_Yellow","A3PL_FireExtinguisher"];
		private _hasClassOne = false;
		private _hasHighClass = false;
		private _hasMelee = false;
		private _hasAuthorized = false;
		if (_weps isNotEqualTo []) then {
			{
				if (_x IN _classOne) then {_hasClassOne = true;};
				if (_x IN _highClass) then {_hasHighClass = true;};
				if (_x IN _melee) then {_hasMelee = true;};
				if (_x IN _authorized) then {_hasAuthorized = true;};
			} foreach _weps;
			if (_hasHighClass) then {
				[("STR_A3PL_Police_PossibleWeapon" call A3PL_Localize),Color_Red] call A3PL_Notification;
			};
			if (_hasClassOne) then {
				private _rand = random 100;
				// Customs_officer trait: 25% bonus detection chance (30% -> 55%)
				private _threshold = 70;
				if (_hasCustomsOfficerTrait) then {
					_threshold = 45;
				};
				if (_rand >= _threshold) then {
					[("STR_A3PL_Police_NoWeapon" call A3PL_Localize),Color_Green] call A3PL_Notification;
				} else  {
					[("STR_A3PL_Police_PossibleWeapon" call A3PL_Localize),Color_Red] call A3PL_Notification;
				};
			};
			if (_hasMelee) then {
				private _rand = random 100;
				// Customs_officer trait: 25% bonus detection chance (10% -> 35%)
				private _threshold = 90;
				if (_hasCustomsOfficerTrait) then {
					_threshold = 65;
				};
				if (_rand >= _threshold) then {
					[("STR_A3PL_Police_NoWeapon" call A3PL_Localize),Color_Green] call A3PL_Notification;
				} else  {
					[("STR_A3PL_Police_PossibleWeapon" call A3PL_Localize),Color_Red] call A3PL_Notification;
				};
			};
			if (_hasAuthorized) then {
				private _rand = random 100;
				// Customs_officer trait: 25% bonus detection chance (10% -> 35%)
				private _threshold = 90;
				if (_hasCustomsOfficerTrait) then {
					_threshold = 65;
				};
				if (_rand >= _threshold) then {
					[("STR_A3PL_Police_NoWeapon" call A3PL_Localize),Color_Green] call A3PL_Notification;
				} else  {
					[("STR_A3PL_Police_PossibleAuthorizedWeapon" call A3PL_Localize),Color_Red] call A3PL_Notification;
				};
			};
		} else {
			private _rand = random 100;
			if (_rand >= 70) then {
				[("STR_A3PL_Police_PossibleWeapon" call A3PL_Localize),Color_Red] call A3PL_Notification;
			} else {
				[("STR_A3PL_Police_NoWeapon" call A3PL_Localize),Color_Green] call A3PL_Notification;
			};
		};
	};
}] call compile_Global;

["A3PL_Police_PatDown", {
	private _target = param [0,objNull];
	if (!Player_ActionCompleted) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_target getVariable ["patdown",false]) exitwith {[("STR_A3PL_Police_AlreadyPatting" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((player getVariable["cuffed",false]) || (player getVariable["zipped",false])) exitWith {};
	_target setVariable ["patdown",true,true];

	[("STR_A3PL_Police_Patted" call A3PL_Localize), Color_green] remoteExec ["A3PL_Notification",_target];
	[player,"AmovPercMstpSnonWnonDnon_AinvPercMstpSnonWnonDnon_Putdown"] remoteExec ["A3PL_Lib_SyncAnim",0];
	[_target] spawn
	{
		private _target = param [0,objNull];
		if (Player_ActionDoing) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		[("STR_A3PL_Police_Patting" call A3PL_Localize),PD_Time_To_Patdown] spawn A3PL_Lib_LoadAction;
		private _success = true;
		waitUntil{Player_ActionDoing};
		while {Player_ActionDoing} do {
			if ((player distance2D _target) > 5) exitWith {_success = false;};
			if ((animationState player) isEqualTo "amovpercmstpsnonwnondnon") then {[player,"AmovPercMstpSnonWnonDnon_AinvPercMstpSnonWnonDnon_Putdown"] remoteExec ["A3PL_Lib_SyncAnim",0];};
		};
		player switchMove "";
		if(Player_ActionInterrupted || !_success) exitWith {
			[("STR_A3PL_Police_PattingCanceled" call A3PL_Localize),Color_Red] call A3PL_Notification;
			[("STR_A3PL_Police_PattingCanceled" call A3PL_Localize), Color_green] remoteExec ["A3PL_Notification",_target];
			_target setVariable ["patdown",nil,true];
		};
		_target setVariable ["patdown",nil,true];

		_items = assignedItems _target + items _target;
		_vitems = [_target] call A3PL_Inventory_Get;
		_weps = weapons _target;
		_mags = magazines _target;
		if (currentMagazine _target != "") then {_mags pushback (currentMagazine _target);};

		private _conditions = (animationState _target IN ["a3pl_idletohandsup","a3pl_handsuptokneel"]) || (_target getVariable ["Cuffed",false]) || (_target getVariable ["Zipped",false]) || (!(Player_ObjIntersect getVariable["A3PL_Medical_Alive",true]));
		if(!_conditions) exitWith {};
		[getPlayerUID player,(player getVariable ["character_id",""]),"LEO_Patdown_Start",[format ["Target: %1",_target getVariable["name","unknown"]]]] remoteExec ["Server_Log_New",2];
		[getPlayerUID _target,(_target getVariable ["character_id",""]),"LEO_Patdown_Started",[format ["Molester: %1",player getVariable["name","unknown"]]]] remoteExec ["Server_Log_New",2];
		createDialog "Dialog_PatDown";
		_display = findDisplay 93;
		_display call A3PL_Dialog_Localize;

		_control = _display displayCtrl 1500;
		{
			if !(_x IN _weps) then {
				_index = _control lbAdd format ["%1",getText (configFile >> "CfgWeapons" >> _x >> "displayName")];
				_control lbSetData [_index,_x];
				_control lbSetValue [_index,0];
			};
		} foreach _items;

		_headgear = headgear _target;
		if(!(_headgear isEqualTo "")) then {
			_index = _control lbAdd format ["%1",getText (configFile >> "CfgWeapons" >> _headgear >> "displayName")];
			_control lbSetData [_index,_headgear];
			_control lbSetValue [_index,5];
		};

		_uniform = uniform _target;
		if(!(_uniform isEqualTo "")) then {
			_index = _control lbAdd format ["%1",getText (configFile >> "CfgWeapons" >> _uniform >> "displayName")];
			_control lbSetData [_index,_uniform];
			_control lbSetValue [_index,1];
		};

		_goggles = goggles _target;
		if(!(_goggles isEqualTo "")) then {
			_index = _control lbAdd format ["%1",getText (configFile >> "CfgGlasses" >> _goggles >> "displayName")];
			_control lbSetData [_index,_goggles];
			_control lbSetValue [_index,4];
		};

		_vest = vest _target;
		if(!(_vest isEqualTo "")) then {
			_index = _control lbAdd format ["%1",getText (configFile >> "CfgWeapons" >> _vest >> "displayName")];
			_control lbSetData [_index,_vest];
			_control lbSetValue [_index,2];
		};

		_backpack = backpack _target;
		if(!(_backpack isEqualTo "")) then {
			_index = _control lbAdd format ["%1",getText (configFile >> "CfgVehicles" >> _backpack >> "displayName")];
			_control lbSetData [_index,_backpack];
			_control lbSetValue [_index,3];
		};

        private _chance = random 100;
        private _getChance = 70;
        if(_getChance > _chance) then {
    		if(!isNil {_target getVariable ["fakeName",nil]}) then {
    			_index = _control lbAdd format [("STR_A3PL_Police_FakeID" call A3PL_Localize),_target getVariable ["fakeName",""]];
    			_control lbSetData [_index,"Fake ID"];
    			_control lbSetValue [_index,6];
    		};
    		_control lbSetCurSel 0;
        } else {
            if(!isNil {_target getVariable ["fakeName",nil]}) then {
                _index = _control lbAdd format [("STR_A3PL_Police_NoFakeID" call A3PL_Localize)];
            };
            _control lbSetCurSel 0;
        };

		_control = _display displayCtrl 1501;
		{
			_index = _control lbAdd format ["%1",getText (configFile >> "CfgWeapons" >> _x >> "displayName")];
			_control lbSetData [_index,_x];
			_control lbSetValue [_index,0];
		} foreach _weps;
		{
			_index = _control lbAdd format ["%1",getText (configFile >> "CfgMagazines" >> _x >> "displayName")];
			_control lbSetData [_index,_x];
			_control lbSetValue [_index,1];
		} foreach _mags;
		_control lbSetCurSel 0;

		_control = _display displayCtrl 1502;
		{
			_index = _control lbAdd format ["(%2x) %1",[_x select 0, "name"] call A3PL_Config_GetItem, _x select 1];
			_control lbSetData [_index,_x select 0];
			_control lbSetValue [_index,_x select 1];
		} foreach _vitems;

		_index = _control lbAdd format["$%1", [_target getVariable ["Player_Cash",0], 1, 0, true] call CBA_fnc_formatNumber];
		_control lbSetData [_index,"cash"];
		_control lbSetValue [_index,_target getVariable ["Player_Cash",0]];
		_control lbSetCurSel 0;

		_control = _display displayCtrl 1600;
		_control ctrlAddEventHandler ["buttonDown",{["item"] call A3PL_Police_PatDownTake}];
		_control = _display displayCtrl 1601;
		_control ctrlAddEventHandler ["buttonDown",{["wep"] call A3PL_Police_PatDownTake}];
		_control = _display displayCtrl 1602;
		_control ctrlAddEventHandler ["buttonDown",{["vitems"] call A3PL_Police_PatDownTake}];

		_control = _display displayCtrl 1100;
		_control ctrlSetStructuredText parseText format[("STR_A3PL_Police_PattingX" call A3PL_Localize),_target getVariable["name",("STR_Common_Unknown" call A3PL_Localize)]];

		A3PL_Police_Target = _target;
		_display displayAddEventHandler ["unload",{A3PL_Police_Target setVariable ["patdown",nil,true]; A3PL_Police_Target = nil; A3PL_Police_WeaponHolder = nil;}];

		while{!isNull findDisplay 93} do {
			private _conditions = (animationState A3PL_Police_Target IN ["a3pl_idletohandsup","a3pl_handsuptokneel"]) || (A3PL_Police_Target getVariable ["Cuffed",false]) || (A3PL_Police_Target getVariable ["Zipped",false]) || (!(Player_ObjIntersect getVariable["A3PL_Medical_Alive",true]));
			if((!_conditions) || ((player distance2D A3PL_Police_Target) > 5)) then {
				closeDialog 0;
			};
		};
	};
}] call compile_Global;

["A3PL_Police_PatDownTake",
{
	disableSerialization;
	private ["_type","_class","_target","_weaponHolder","_display","_control","_itemName"];
	_type = param [0,""];
	_display = findDisplay 93;
	if (isNil "A3PL_Police_Target") exitwith {["System: Error in Police_PatDownTake :: _target is undefined"] call A3PL_Notification;};

	_target = A3PL_Police_Target;
	if (isNil "A3PL_Police_WeaponHolder") then
	{
		A3PL_Police_WeaponHolder = createVehicle ["GroundWeaponHolder", getposATL player, [], 0, "CAN_COLLIDE"];
	} else
	{
		if (isNull A3PL_Police_WeaponHolder) then
		{
			A3PL_Police_WeaponHolder = createVehicle ["GroundWeaponHolder", getposATL player, [], 0, "CAN_COLLIDE"];
		};
	};
	_weaponHolder = A3PL_Police_WeaponHolder;

	_amount = 1;
	switch (_type) do
	{
		case ("item"):
		{
			_control = _display displayCtrl 1500;
			_class = _control lbData (lbCurSel _control);
			_itemtype = _control lbValue (lbCurSel _control);
			switch (_itemtype) do
			{
				case 0:
				{
					_itemName = getText (configFile >> "CfgWeapons" >> _class >> "displayName");
					if (_class IN (assignedItems _target)) then
					{
						_target unAssignItem _class;
					};
					_target removeItem _class;
					_weaponHolder addItemCargoGlobal [_class,1];
				};
				case 1:
				{
					_itemName = getText (configFile >> "CfgWeapons" >> _class >> "displayName");
					removeUniform _target;
					_weaponHolder addItemCargoGlobal [_class,1];
				};
				case 2:
				{
					_itemName = getText (configFile >> "CfgWeapons" >> _class >> "displayName");
					removeVest _target;
					_weaponHolder addItemCargoGlobal [_class,1];
				};
				case 3:
				{
					_itemName = getText (configFile >> "CfgVehicles" >> _class >> "displayName");
					if(_class isEqualTo "A3PL_Backpack_Money") then {
						_value = (backpackContainer _target) getVariable ["bankCash", 0];
						removeBackpackGlobal _target;
						_weaponHolder addBackpackCargoGlobal [_class,1];
						(firstBackpack _weaponHolder) setVariable["bankCash",_value,true];
					} else {
						removeBackpackGlobal _target;
						_weaponHolder addBackpackCargoGlobal [_class,1];
					};
				};
				case 4:
				{
					_itemName = getText (configFile >> "CfgGlasses" >> _class >> "displayName");
					removeGoggles _target;
					_weaponHolder addItemCargoGlobal [_class,1];
				};
				case 5:
				{
					_itemName = getText (configFile >> "CfgWeapons" >> _class >> "displayName");
					removeHeadgear _target;
					_weaponHolder addItemCargoGlobal [_class,1];
				};
				case 6:
				{
					_itemName = _class;
					_target setVariable ["fakeName",nil,true];
				};
			};
		};
		case ("wep"):
		{
			_control = _display displayCtrl 1501;
			_class = _control lbData (lbCurSel _control);
			if(isClass (configFile >> "CfgWeapons" >> _class)) then {
				_itemName = getText (configFile >> "CfgWeapons" >> _class >> "displayName");
				_accs = ["","",""];
				{
					if (_x isEqualTo _class) exitWith {
						_target removeWeaponGlobal _x;
						_accs = _target weaponAccessories _class;
					};
				} forEach weapons _target;
				{
					if (_x isEqualTo _class) exitWith {
						_target removeItemFromUniform _x;
						_accs = [_class] call A3PL_Lib_GetWeaponAccsCargo;
					};
				} forEach uniformItems _target;
				{
					if (_x isEqualTo _class) exitWith {
						_target removeItemFromVest _x;
						_accs = [_class] call A3PL_Lib_GetWeaponAccsCargo;
					};
				} forEach vestItems _target;
				{
					if (_x isEqualTo _class) exitWith {
						_target removeItemFromBackpack _x;
						_accs = [_class] call A3PL_Lib_GetWeaponAccsCargo;
					};
				} forEach backpackItems _target;
				_weaponHolder addWeaponWithAttachmentsCargoGlobal [[_class, _accs select 0, _accs select 1, _accs select 2, [], [], ""], 1];
			} else {
				_itemName = getText (configFile >> "CfgMagazines" >> _class >> "displayName");
				_target removeMagazineGlobal _class;
				_weaponHolder addMagazineCargoGlobal [_class,1];
			};
		};
		case ("vitems"):
		{
			_control = _display displayCtrl 1502;
			_class = _control lbData (lbCurSel _control);
			_amount = _control lbValue (lbCurSel _control);
			_itemName = [_class, "name"] call A3PL_Config_GetItem;
			if(_class isEqualTo "cash") then {
				[_target, 'Player_Cash', ((_target getVariable 'Player_Cash') - _amount)] remoteExec ["Server_Core_ChangeVar",2];
				[player, 'Player_Cash', ((player getVariable 'Player_Cash') + _amount)] remoteExec ["Server_Core_ChangeVar",2];
			} else {
				[_class,-_amount] remoteExec ["A3PL_Inventory_Add",_target];
				[_class,_amount] call A3PL_Inventory_Add;
			};
		};
	};
	_control lbDelete (lbCurSel _control);

	[format [("STR_A3PL_Police_Took" call A3PL_Localize),_itemName,_amount],Color_Green] call A3PL_Notification;
	[format [("STR_A3PL_Police_TookFrom" call A3PL_Localize),_itemName,_amount]] remoteExec ["A3PL_Notification",_target];
	[getPlayerUID _target,(_target getVariable ["character_id",""]),"LEO_Patdown_Taken",[format ["Taken By: %1 | Item: %2 | Amount: %3",player getVariable["name","unknown"],_itemName,_amount]]] remoteExec ["Server_Log_New",2];
	[getPlayerUID player,(player getVariable ["character_id",""]),"LEO_Patdown_Take",[format ["Taken From: %1 | Item: %2 | Amount: %3",_target getVariable["name","unknown"],_itemName,_amount]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

['A3PL_Police_Cuff', {
	params["_obj","_cop"];
	if(_obj getVariable ["pVar_RedNameOn",false]) exitWith {};
	[getPlayerUID player,(player getVariable ["character_id",""]),"LEO_Handcuff",[format ["Location: %1 | Handcuffed By: %2 (%3)",(getPosATL player),(_cop getVariable ["character_id",""]),(getPlayerUID _cop)]]] remoteExec ["Server_Log_New",2];
	if ((animationState _obj) IN ["amovpercmstpsnonwnondnon","amovpercmstpsraswrfldnon","amovpercmstpsraswpstdnon","amovpercmstpsraswlnrdnon"]) exitwith
	{
		_obj setVariable ["Cuffed",true,true];
		playSound3D ["A3PL_Common\effects\cuff.ogg", player, false, getPosATL player, 5, 1, 20];
		[player,_obj,1] remoteExec ["A3PL_Police_HandleAnim",0];
		[false] call A3PL_Inventory_PutBack;
		["handcuffs", 1] call A3PL_Inventory_Remove;
	};
	if ((animationState _obj) isEqualTo "a3pl_idletohandsup") exitwith
	{
		_obj setVariable ["Cuffed",true,true];
		playSound3D ["A3PL_Common\effects\cuff.ogg", player, false, getPosATL player, 5, 1, 20];
		[player,_obj,2] remoteExec ["A3PL_Police_HandleAnim",0];
		[false] call A3PL_Inventory_PutBack;
		["handcuffs", 1] call A3PL_Inventory_Remove;
	};
	if ((animationState _obj) isEqualTo "a3pl_handsuptokneel") exitwith
	{
		_obj setVariable ["Cuffed",true,true];
		playSound3D ["A3PL_Common\effects\cuff.ogg", player, false, getPosATL player, 5, 1, 20];
		[player,_obj,3] remoteExec ["A3PL_Police_HandleAnim",0];
		[false] call A3PL_Inventory_PutBack;
		["handcuffs", 1] call A3PL_Inventory_Remove;
	};
	if (animationState _obj IN ["amovpknlmstpsnonwnondnon","amovpknlmstpsraswpstdnon","amovpknlmstpsraswrfldnon","amovpknlmstpsraswlnrdnon"]) exitwith
	{
		_obj setVariable ["Cuffed",true,true];
		playSound3D ["A3PL_Common\effects\cuff.ogg", player, false, getPosATL player, 5, 1, 20];
		[player,_obj,4] remoteExec ["A3PL_Police_HandleAnim",0];
		[false] call A3PL_Inventory_PutBack;
		["handcuffs", 1] call A3PL_Inventory_Remove;
	};
	if (animationState _obj IN ["amovppnemstpsnonwnondnon","amovppnemstpsraswrfldnon","amovppnemstpsraswpstdnon"]) exitwith
	{
		_obj setVariable ["Cuffed",true,true];
		playSound3D ["A3PL_Common\effects\cuff.ogg", player, false, getPosATL player, 5, 1, 20];
		[player,_obj,5] remoteExec ["A3PL_Police_HandleAnim",0];
		[false] call A3PL_Inventory_PutBack;
		["handcuffs", 1] call A3PL_Inventory_Remove;
	};
	if ((animationState _obj) isEqualTo "unconscious") exitwith
	{
		_obj setVariable ["Cuffed",true,true];
		playSound3D ["A3PL_Common\effects\cuff.ogg", player, false, getPosATL player, 5, 1, 20];
		[player,_obj,5] remoteExec ["A3PL_Police_HandleAnim",0];
		[false] call A3PL_Inventory_PutBack;
		["handcuffs", 1] call A3PL_Inventory_Remove;
	};
	_obj setVariable ["Cuffed",true,true];
	[false] call A3PL_Inventory_PutBack;
	["handcuffs", 1] call A3PL_Inventory_Remove;
	waitUntil{(animationState _obj) isEqualTo "amovppnemstpsnonwnondnon"};
	[player,_obj,5] remoteExec ["A3PL_Police_HandleAnim",0];
}] call compile_Global;

['A3PL_Police_Uncuff', {
	private _obj = _this select 0;
	private _cop = _this select 1;
	private _Cuffed = _obj getVariable ["Cuffed",false];
	private _alive = _obj getVariable["A3PL_Medical_Alive",true];
	if(_Cuffed && {!_alive}) exitwith {[("STR_A3PL_Police_CantUncuffDead" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[getPlayerUID player,(player getVariable ["character_id",""]),"LEO_UnHandcuff",[format ["Location: %1 | UnHandcuffed By: %2 (%3)",(getPosATL player),(_cop getVariable ["character_id",""]),(getPlayerUID _cop)]]] remoteExec ["Server_Log_New",2];
	if (_Cuffed) then {
		["handcuffs",1] call A3PL_Inventory_Add;
		[player,_obj,7] remoteExec ["A3PL_Police_HandleAnim",0];
		_obj setVariable ["Cuffed",false,true];
		_obj setVariable ["escorted",nil,true];
		if((vehicle _obj) isEqualTo _obj) then {
			["gesture_stop",_obj] remoteExec ["A3PL_Lib_Gesture", -2];
			[_obj,""] remoteExec ["A3PL_Lib_SyncAnim", -2];
		};
	};
}] call compile_Global;

['A3PL_Police_CuffKick', {
	private _obj = _this select 0;
	if ((animationState _obj) isEqualTo "a3pl_handsupkneelcuffed") then {
		[player,_obj,6] remoteExec ["A3PL_Police_HandleAnim", -2];
	};
}] call compile_Global;

['A3PL_Police_HandleAnim', {
	private _cop = _this select 0;
	private _civ = _this select 1;
	private _number = _this select 2;

	switch (_number) do
	{
		case 1:
		{
			if (local _civ) then
			{
				if (!isPlayer _civ) exitwith {
					_civ setdir ((getDir _civ) + 50);
				};
				player setdir ((getDir player) + 50);
			};
			[_cop,_civ] spawn
			{
				private _cop = _this select 0;
				private _civ = _this select 1;
				_civ switchmove "A3PL_HandsupToKneel";
				sleep 3;
				_civ switchmove "A3PL_HandsupKneelGetCuffed";
				_cop switchmove "A3PL_Cuff";
				if (local _cop) then {
					_cop attachTo [_civ,[0,0,0]];
				};
				sleep 4;
				if (local _cop) then {
					detach _cop;
				};
				_civ switchmove "A3PL_HandsupKneelCuffed";
				_cop switchmove "";
			};
		};
		case 2:
		{
			[_cop,_civ] spawn
			{
				private _cop = _this select 0;
				private _civ = _this select 1;
				_civ switchmove "A3PL_HandsupToKneel";
				sleep 3;
				_civ switchmove "A3PL_HandsupKneelGetCuffed";
				_cop switchmove "A3PL_Cuff";
				if (local _cop) then {
					_cop attachTo [_civ,[0,0,0]];
				};
				sleep 4;
				if (local _cop) then {
					detach _cop;
				};
				_civ switchmove "A3PL_HandsupKneelCuffed";
				_cop switchmove "";
			};
		};
		case 3:
		{
			[_cop,_civ] spawn
			{
				private _cop = _this select 0;
				private _civ = _this select 1;
				_civ switchmove "A3PL_HandsupKneelGetCuffed";
				_cop switchmove "A3PL_Cuff";
				if (local _cop) then {
					_cop attachTo [_civ,[0,0,0]];
				};
				sleep 4;
				if (local _cop) then {
					detach _cop;
				};
				_civ switchmove "A3PL_HandsupKneelCuffed";
				_cop switchmove "";
			};
		};
		case 4:
		{
			if (local _civ) then {
				if (!isPlayer _civ) exitwith {
					_civ setdir ((getDir _civ) + 50);
				};
				player setdir ((getDir player) + 50);
			};
			[_cop,_civ] spawn
			{
				private _cop = _this select 0;
				private _civ = _this select 1;
				_civ switchmove "A3PL_HandsupKneelGetCuffed";
				_cop switchmove "A3PL_Cuff";
				if (local _cop) then {
					_cop attachTo [_civ,[0,0,0]];
				};
				sleep 4;
				if (local _cop) then {
					detach _cop;
				};
				_civ switchmove "A3PL_HandsupKneelCuffed";
				_cop switchmove "";
			};
		};
		case 5:
		{
			if !(_civ getVariable["A3PL_Medical_Alive",true]) exitWith {};
			if (local _civ) then
			{
				if (!isPlayer _civ) exitwith
				{
					_civ setdir ((getDir _civ) + 50);
				};
				player setdir ((getDir player) + 50);
			};
			_civ switchmove "A3PL_HandsupKneelKicked";
		};
		case 6:
		{
			[_cop,_civ] spawn
			{
				private _cop = _this select 0;
				private _civ = _this select 1;
				_cop switchmove "A3PL_CuffKickDown";
				if (local _cop) then {
					_cop attachTo [_civ,[0,0,0]];
				};
				sleep 1;
				_civ switchmove "A3PL_HandsupKneelKicked";
				sleep 3;
				_cop switchmove "";
				if (local _cop) then {
					detach _cop;
				};
				if (local _civ) then {
					if (!isPlayer _civ) exitwith {
						_civ setdir ((getDir _civ) - 50);
					};
					player setdir ((getDir player) - 50);
				};
			};
		};
		case 7:
		{
			_civ spawn {
				if (local _this) then {
					_this setdir ((getDir _this) - 50);
				};
				if ((animationState _this) isEqualTo "a3pl_handsupkneelcuffed") then {
					_this switchmove "amovpknlmstpsnonwnondnon";
				} else {
					_this switchmove "amovppnemstpsnonwnondnon";
				};
			};
		};

	};
}] call compile_Global;

['A3PL_Police_Surrender', {
	private _obj = _this select 0;
	private _upDown = _this select 1;

	//1 No hands up -> Hands up
	//2 Hands up -> Normal
	//3 Hands up -> kneeled hands up
	//4 Kneeled hands up -> hands up
	//5 Kneeled -> Kneeled hands up
	//6 Prone -> Kneeled hands up

	[] spawn A3PL_Lib_CloseInventoryDialog;
	if (((animationState _obj) IN ["a3pl_idletohandsup","a3pl_kneeltohandsup"]) && (_upDown)) exitwith
	{
		[player,2] remoteExec ["A3PL_Police_SurrenderAnim", -2];
	};
	if (((animationState _obj) IN ["a3pl_idletohandsup","a3pl_kneeltohandsup"]) && (!_upDown)) exitwith
	{
		[player,3] remoteExec ["A3PL_Police_SurrenderAnim", -2];
	};
	if (((animationState _obj) isEqualTo "a3pl_handsuptokneel") && (_upDown)) exitwith
	{
		[player,4] remoteExec ["A3PL_Police_SurrenderAnim", -2];
	};
	if ((animationState _obj) isEqualTo "amovpknlmstpsnonwnondnon") exitwith
	{
		[player,5] remoteExec ["A3PL_Police_SurrenderAnim", -2];
	};
	if ((animationState _obj) isEqualTo "amovppnemstpsnonwnondnon") exitwith
	{
		[player,6] remoteExec ["A3PL_Police_SurrenderAnim", -2];
	};
	[player,1] remoteExec ["A3PL_Police_SurrenderAnim", -2];
	Player_ActionInterrupted = true;
}] call compile_Global;

['A3PL_Police_SurrenderAnim', {
	private _civ = _this select 0;
	private _number = _this select 1;
	switch (_number) do
	{
		case 1:
		{
			if (local _civ) then {
				if (!isPlayer _civ) exitwith {
					_civ setdir ((getDir _civ) + 50);
				};
				player setdir ((getDir player) + 50);
			};
			_civ switchmove "A3PL_IdleToHandsup";
		};
		case 2:
		{
			if (local _civ) then {
				if (!isPlayer _civ) exitwith {
					_civ setdir ((getDir _civ) - 50);
				};
				player setdir ((getDir player) - 50);
			};
			_civ switchmove "";
		};
		case 3:
		{
			_civ switchmove "A3PL_HandsupToKneel";
		};
		case 4:
		{
			_civ switchmove "A3PL_KneelToHandsup";
		};
		case 5:
		{
			if (local _civ) then {
				if (!isPlayer _civ) exitwith {
					_civ setdir ((getDir _civ) - 50);
				};
				player setdir ((getDir player) - 50);
			};
			_civ switchmove "A3PL_HandsupKneel";
		};
		case 6:
		{
			if (local _civ) then {
				if (!isPlayer _civ) exitwith {
					_civ setdir ((getDir _civ) - 50);
				};
				player setdir ((getDir player) - 50);
			};
			_civ switchmove "A3PL_HandsupKneel";
		};
	};
}] call compile_Global;

['A3PL_Police_SpikeHit', {
	private _vehicle = param[0,"None"];
	private _spike = param[1,objNull];
	if (_vehicle isEqualTo "None") exitWith {["What the fronk",Color_Red] call A3PL_Notification;};
	if (!isNull _spike) then {deleteVehicle _spike;};
	private _veh = "Land_HelipadEmpty_F" createVehicleLocal (getpos _vehicle);
	_veh attachTo [_vehicle, [0, 0, 1]];

	_veh say3D ["flattire",40,1];
	sleep 3;
	deleteVehicle _veh;
	sleep 0.3;

	private _wheels = ["HitLFWheel","HitRFWheel","HitLF2Wheel","HitRF2Wheel"];
	private _wheel = selectRandom _wheels;
	_vehicle setHitPointDamage[_wheel,1];
	_vehicle say3D ["tirepop",40,1];
	sleep 2;
	private _wheel2 = selectRandom _wheels;
	_vehicle setHitPointDamage[_wheel2,1];
	_vehicle say3D ["tirepop",40,1];

	sleep 10;
	_vehicle setVariable ["spiked",false];
}] call compile_Global;

['A3PL_Police_Drag',
{
	private _civ = _this select 0;
	private _escorted = _civ getVariable ["escorted",false];
	private _escorting = player getVariable ["escorting",false];
	if (_escorting) exitWith {player getVariable ["escorting",false];};
	if (_escorted) exitwith {_civ setVariable ["escorted",nil,true];};
	if (_civ getVariable["Cuffed",false]) then {
		player forceWalk true;
		_civ setVariable ["escorted",true,true];
		player setVariable["escorting",true];
		["gesture_restrain"] remoteExec ["A3PL_Lib_Gesture", _civ];
		[_civ,""] remoteExec ["A3PL_Lib_SyncAnim", -2];
		_civ attachTo [player,[0,0.8,0]];
		[_civ] spawn
		{
			private _civ = param [0,objNull];
			while {(_civ getVariable ["escorted",false]) && (player getVariable["escorting",false])} do
			{
				if (isNull player) exitwith {};
				if !(_civ getVariable["Cuffed",false]) exitWith {};
			};
			player forceWalk false;
			detach _civ;
			_civ setVariable ["escorted",nil,true];
			player setVariable["escorting",nil];
			if((vehicle _civ) isEqualTo _civ) then {
				["gesture_stop"] call A3PL_Lib_Gesture;
				[_civ,"a3pl_handsupkneelcuffed"] remoteExec ["A3PL_Lib_SyncAnim", -2];
			};
		};
	} else {
		[("STR_A3PL_Police_NotCuffed" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};
}] call compile_Global;

['A3PL_Police_WaterDrag', {
	private _civ = _this select 0;
	private _dragged = _civ getVariable ["dragged",false];
	if (_dragged) exitWith {_civ setVariable ["dragged",Nil,true];};
	private _alreadyDrag = player getVariable["dragging", false];
	if(_alreadyDrag) exitWith {[("STR_A3PL_Police_AlreadyEscorting" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	player setVariable["dragging", true, true];
	[("STR_A3PL_Police_EscortingOutOfWater" call A3PL_Localize),Color_Green] call A3PL_Notification;
	[player] remoteExec ["A3PL_Police_WaterDragReceive",_civ];
}] call compile_Global;

['A3PL_Police_WaterDragReceive',
{
	private _cop = param [0,objNull];
	[("STR_A3PL_Police_EscortedOutOfWater" call A3PL_Localize),Color_Red] call A3PL_Notification;
	player setVariable ["dragged",true,true];
	[_cop] spawn
	{
		private _cop = param [0,objNull];
		if (isNull _cop) exitwith {};
		while {(player getVariable ["dragged",false]) && (vehicle _cop isKindOf "Civilian_F") && (surfaceIsWater position player) && (_cop getVariable ["dragging",false])} do
		{
			sleep 2;
			if (isNull _cop) exitwith {};
			if (((player distance _cop) > 3) && (vehicle _cop isKindOf "Civilian_F")) then {
				player setPosASL (getposASL _cop);
			};
		};
		_cop setVariable["dragging", false, true];
		player setVariable["dragged",false,true];
		[("STR_A3PL_Police_NotEscortedAnymore" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};
}] call compile_Global;

['A3PL_Police_Stand',
{
	[player,"amovpercmstpsnonwnondnon"] remoteExec ["A3PL_Lib_SyncAnim",-2];
	sleep 2.5;
	["gesture_restrain"] call A3PL_Lib_Gesture;
}] call compile_Global;

['A3PL_Police_Putdown',
{
	["gesture_stop"] call A3PL_Lib_Gesture;
	[player,"a3pl_handsupkneelcuffed"] remoteExec ["A3PL_Lib_SyncAnim", -2];
}] call compile_Global;

["A3PL_Police_Detain",
{
	private ["_car","_near"];
	_car = param [0,objNull];
	_near = nearestObjects [player,["C_man_1"],5];
	_near = _near - [player];
	if (count _near < 1) exitwith {[("STR_A3PL_Police_NoNearbyIndividuals" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_near = _near select 0;
	if((_near getVariable["Cuffed",false]) || _near getVariable["Zipped",false]) exitwith {
		_near setVariable["dragged",nil,true];
		[_near,""] remoteExec ["A3PL_Lib_SyncAnim", -2];
		if(typeOf _car isNotEqualTo "A3PL_RBM") then {
			[_car] remoteExec ["A3PL_Lib_MoveInPass",_near];
		} else {
			[_car,true,3] remoteExec ["A3PL_Lib_MoveInPass",_near];
		};
	};
	[("STR_A3PL_Police_NoNearbyCuffedOrEscorted" call A3PL_Localize),Color_Red] call A3PL_Notification;
}] call compile_Global;

["A3PL_Police_Impound",
{
	private _veh = cursorObject;
	if (isNull _veh) exitwith {[("STR_A3PL_Police_NoVehicleFound" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if(_veh distance player > 7) exitWith {[("STR_A3PL_Police_TooFarFromVehicle" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((typeOf _veh) IN PD_Impound_Bypass) exitwith {[("STR_A3PL_Police_VehicleCannotBeImpounded" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (((_veh isKindOf "Car") || (_veh isKindOf "Tank"))) exitwith {
		if (Impound_NewSystem isEqualTo 1) then {
			if (_veh getVariable ["impound",false]) then {
				[_veh] call A3PL_JobRoadWorker_ToggleMark;
			} else {
				A3PL_Impound_MarkTarget = _veh;
				createDialog "Dialog_ImpoundMark";
				private _display = findDisplay 41;
				_display call A3PL_Dialog_Localize;
			};
		} else {
			[_veh] call A3PL_JobRoadWorker_ToggleMark;
		};
	};
	[_veh] remoteExec ["Server_Police_Impound", 2];
	[("STR_A3PL_Police_VehicleImpounded" call A3PL_Localize),Color_Red] call A3PL_Notification;
}] call compile_Global;

["A3PL_Police_ImpoundConfirm",
{
	disableSerialization;
	private _display = findDisplay 41;
	if (isNull _display) exitWith {};
	private _veh = A3PL_Impound_MarkTarget;
	if (isNull _veh) exitWith {closeDialog 0;};
	private _durationStr = ctrlText (_display displayCtrl 1400);
	private _unitSel = lbCurSel (_display displayCtrl 1401);
	private _duration = parseNumber _durationStr;
	if (_duration <= 0) exitWith {[("STR_A3PL_Police_InvalidDuration" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _durationMinutes = switch (_unitSel) do {
		case 0: {_duration};
		case 1: {_duration * 60};
		case 2: {_duration * 1440};
		default {_duration * 1440};
	};
	closeDialog 0;
	[_veh,_durationMinutes] remoteExec ["Server_JobRoadWorker_Mark", 2];
	[format ["Vehicle marked for impound (%1 min)",_durationMinutes],Color_Green] call A3PL_Notification;
	A3PL_Impound_MarkTarget = objNull;
}] call compile_Global;

["A3PL_Police_unDetain",
{
	private _car = param [0,objNull];
	private _ejectAll = param [1,true];
	private _pass = crew _car;
	private _ejectFail = false;
	if((speed _car) >= 2) exitWith {[("STR_A3PL_Police_MovingVehicleCannotBeEjected" call A3PL_Localize),Color_Red] call A3PL_Notification;_ejectFail = true;};
	if(count _pass isEqualTo 0) exitWith {[("STR_A3PL_Police_NoPassengersToEject" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if (_car getVariable ["locked",false]) then {
		private _windowDriver = _car getHitPointDamage "hitglass2";
		private _windowPasssenger = _car getHitPointDamage "hitglass4";
		if ((_windowDriver isEqualTo 0) && (_windowPasssenger isEqualTo 0)) exitWith {[("STR_A3PL_Police_VehicleLocked" call A3PL_Localize),Color_Red] call A3PL_Notification;_ejectFail = true;};
	};
	if (!(_ejectFail)) exitWith {
		{
			[_x, _car, _ejectAll] spawn {
				_pass = _this#0;
				_car = _this#1;
				_ejectAll = _this#2;
				if (_car getVariable ["trapped",false]) exitWith {[("STR_A3PL_Police_PassengersTrapped" call A3PL_Localize),Color_Red] call A3PL_Notification;};
				if (_ejectAll) then {
					_pass action ["getOut", _car];
					if ((_pass getVariable ["Cuffed",false]) || (_pass getVariable ["Zipped",false])) then {
						sleep 1.5;
						_pass setVelocityModelSpace [0,4,2];
						[_pass,"a3pl_handsupkneelcuffed"] remoteExec ["A3PL_Lib_SyncAnim", -2];
					};
				} else {
					if ((_pass getVariable ["Cuffed",false]) || (_pass getVariable ["Zipped",false])) then {
						_pass action ["getOut", _car];
						sleep 0.5;
						_pass setVelocityModelSpace [0,4,2];
						[_pass,"a3pl_handsupkneelcuffed"] remoteExec ["A3PL_Lib_SyncAnim", -2];
					};
				};
			};
		} foreach _pass;
	};
}] call compile_Global;

["A3PL_Police_OpenTicketMenu",
{
	disableSerialization;
	Player_TicketAmount = Nil;
	createDialog "Dialog_CreateTicket";
	(findDisplay 38) call A3PL_Dialog_Localize;
}] call compile_Global;

["A3PL_Police_CreateTicket",
{
	disableSerialization;
	private _display = findDisplay 38;
	private _control = _display displayCtrl 1400;
	private _ticketAmount = parseNumber (ctrlText _control);
	closeDialog 0;
	if (_ticketAmount < 1) exitwith {[("STR_Common_InvalidAmount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	Player_Item = "A3PL_Ticket" createVehicle (getPos player);
	Player_Item attachTo [player, [0,0,0], "RightHand"];
	Player_ItemClass = "ticket";
	Player_TicketAmount = _ticketAmount;
	[("STR_A3PL_Police_TicketIssued" call A3PL_Localize),Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Police_GiveTicket",
{
	private _player = param [0,objNull];
	if (!isPlayer _player) exitwith {[("STR_A3PL_Police_NotLookingAtIndividual" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (isNil "Player_TicketAmount") exitwith {[("STR_A3PL_Police_ImpossibleToIssueTicket" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[Player_Item] call A3PL_Inventory_Clear;
	[format [("STR_A3PL_Police_TicketIssuedToPerson" call A3PL_Localize),(_player getVariable ["name",name _player])],Color_Green] call A3PL_Notification;
	[Player_TicketAmount,player] remoteExec ["A3PL_Police_ReceiveTicket",_player];
	player playMove 'AmovPercMstpSnonWnonDnon_AinvPercMstpSnonWnonDnon_Putdown';
	Player_TicketAmount = Nil;
}] call compile_Global;

["A3PL_Police_GiveTicketResponse",
{
	private _r = param [0,1];
	private _text = switch (_r) do {
		case 1: {[("STR_A3PL_Police_CitizenRefusedTicket" call A3PL_Localize),Color_red];};
		case 2: {[("STR_A3PL_Police_CitizenAcceptedTicket" call A3PL_Localize),Color_green];};
		case 3: {[("STR_A3PL_Police_CitizenNotEnoughMoney" call A3PL_Localize),Color_red];};
		default {["Error while answering the ticket",Color_red]};
	};
	_text call A3PL_Notification;
}] call compile_Global;

["A3PL_Police_ReceiveTicket",
{
	disableSerialization;
	Player_TicketCop = Nil;
	Player_TicketAmount = Nil;
	closeDialog 0;
	Player_TicketAmount = param [0,1];
	Player_TicketCop = param [1,objNull];
	createDialog "Dialog_ReceiveTicket";
	(findDisplay 37) call A3PL_Dialog_Localize;
	(findDisplay 37) displayAddEventHandler ["KeyDown", "if ((_this#1) isEqualTo 1) then { true }"];
	ctrlSetText [1000,format [("STR_A3PL_Police_TicketAmount" call A3PL_Localize),Player_TicketAmount]];
}] call compile_Global;

["A3PL_Police_RefuseTicket",
{
	closeDialog 0;
	[1] remoteExec ["A3PL_Police_GiveTicketResponse",Player_TicketCop];
	[getPlayerUID player,(player getVariable ["character_id",""]),"LEO_Ticket_Refused",[format ["Given By: %1 | Amount: %2 | Money: %3",Player_TicketCop getVariable["name","unknown"],Player_TicketAmount,(player getVariable["player_bank",0] + player getVariable["player_cash",0])]]] remoteExec ["Server_Log_New",2];
	Player_TicketCop = Nil;
	Player_TicketAmount = Nil;
	[("STR_A3PL_Police_TicketRefused" call A3PL_Localize),Color_Red] call A3PL_Notification;
}] call compile_Global;

["A3PL_Police_PayTicket",
{
	closeDialog 0;
	if (isNil "Player_TicketAmount") exitwith {[("STR_A3PL_Police_EnterAmount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _pBank = player getVariable ["player_bank",0];
	private _money = _pBank + (player getVariable["player_cash",0]);
	if (_pbank < Player_TicketAmount) exitWith {
		[3] remoteExec ["A3PL_Police_GiveTicketResponse",Player_TicketCop];
		[getPlayerUID player,(player getVariable ["character_id",""]),"LEO_Ticket_NoDollars",[format ["Given By: %1 | Amount: %2 | Money: %3",Player_TicketCop getVariable["name","unknown"],Player_TicketAmount,_money]]] remoteExec ["Server_Log_New",2];
	};
	[Player_TicketAmount,player,Player_TicketCop] remoteExec ["Server_Police_PayTicket", 2];
	[2, Player_TicketAmount] remoteExec ["A3PL_Police_GiveTicketResponse",Player_TicketCop];
	[format[("STR_A3PL_Police_TicketPaid" call A3PL_Localize),Player_TicketAmount],Color_Green] call A3PL_Notification;
	[getPlayerUID player,(player getVariable ["character_id",""]),"LEO_Ticket_Paid",[format ["Given By: %1 | Amount: %2 | OldMoney : %3 | NewMoney : %4",Player_TicketCop getVariable["name","unknown"],Player_TicketAmount,_money,(_money - Player_TicketAmount)]]] remoteExec ["Server_Log_New",2];
	Player_TicketAmount = Nil;
	Player_TicketCop = Nil;
}] call compile_Global;

["A3PL_Police_SeizeVirtualItems",
{
	private _target = param [0,player_objintersect];
	private _class = _target getVariable["class",""];
	private _amount = _target getVariable["amount",1];
	private _name = [_class, 'name'] call A3PL_Config_GetItem;
	if !(_target getVariable["stolen",false]) then {[2, [_class, _amount]] call A3PL_Police_SeizeItems;};
	deleteVehicle _target;
	[format[("STR_A3PL_Police_ObjectSeized" call A3PL_Localize),_amount,_name],Color_Red] call A3PL_Notification;
}] call compile_Global;

["A3PL_Police_SeizePhysicalItems",
{
	private _target = param [0,player_objintersect];
	private _class = _target getVariable["class",""];
	private _amount = _target getVariable["amount",1];
	private _name = [_class, 'name'] call A3PL_Config_GetItem;

	if (Player_ActionDoing) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[("STR_A3PL_Police_SeizingInProgress" call A3PL_Localize),15] spawn A3PL_Lib_LoadAction;
	waitUntil{Player_ActionDoing};
	[player,"AmovPercMstpSnonWnonDnon_AinvPercMstpSnonWnonDnon_Putdown"] remoteExec ["A3PL_Lib_SyncAnim",0];
	while {Player_ActionDoing} do {
		if ((player distance2D _target) > 5) exitWith {Player_ActionInterrupted = true;};
		if ((animationState player) isEqualTo "amovpercmstpsnonwnondnon") then {[player,"AmovPercMstpSnonWnonDnon_AinvPercMstpSnonWnonDnon_Putdown"] remoteExec ["A3PL_Lib_SyncAnim",0];};
	};
	if ((vehicle player) isEqualTo player) then {player switchMove "";};
	if (Player_ActionInterrupted) exitWith {[("STR_A3PL_Police_SeizingCanceled" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	[1] call A3PL_Police_SeizeItems;
	[format[("STR_A3PL_Police_ObjectSeized" call A3PL_Localize),_amount,_name],Color_Red] call A3PL_Notification;
}] call compile_Global;

["A3PL_Police_StartJailPlayer",
{
	params[["_target",objNull,[objNull]]];
	createDialog "Dialog_JailPlayer";
	(findDisplay 40) call A3PL_Dialog_Localize;
	A3PL_JailPlayer_Target = _target;
}] call compile_Global;

["A3PL_Police_JailPlayer",
{
	private	_time = parseNumber (ctrlText 1400);
	if((player getVariable ["dbVar_AdminLevel",0] isEqualTo 0) && (_time > PD_Prison_Max_Time)) exitWith {[format[("STR_A3PL_Police_InvalidJailTime" call A3PL_Localize),PD_Prison_Max_Time],Color_Red] call A3PL_Notification;};

	closeDialog 0;
	if((isNull cursorTarget) || (!isPlayer cursorTarget)) exitWith {[("STR_A3PL_Police_LookingAtAnotherPlayer" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if(typeName _time != "SCALAR") exitWith {["BUG: Invalid Number, Please report to Developers!",Color_Red] call A3PL_Notification;};
	if(_time <= 0) exitWith {[("STR_A3PL_Police_InvalidJailTime2" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	[_time, A3PL_JailPlayer_Target] remoteExec ["Server_Police_JailPlayer",2];
}] call compile_Global;

["A3PL_Police_ReleasePlayer",
{
	player setVariable ["jailed",false,true];
	player setVariable ["jail_mark",false,true];
	private _atSD = nearestObjects [player, ["Land_A3PL_Sheriffpd","Land_A3FL_SheriffPD","Land_EC_SheriffHQ"], 50];
	private _atDOC = count(nearestObjects [player, ["Land_A3PL_Prison"], 50]) > 0;
	private _FISD = [("STR_Common_FISD" call A3PL_Localize)] call A3PL_Lib_FactionPlayers;
	if(_atDOC) then {
		if(count(_FISD) > PD_Prison_Need_To_Be_Release_By_Player) then {
			[("STR_A3PL_Police_Released" call A3PL_Localize),Color_Green] call A3PL_Notification;
			[format[("STR_A3PL_Police_DOCReleased" call A3PL_Localize),player getVariable["name","unknown"]],Color_blue,("STR_Common_FISD" call A3PL_Localize),3] spawn A3PL_Lib_JobMessage;
		} else {
			player setPosATL [4739.77,6007.54,0.00143886];
			player setDir 178.9;
			removeUniform player;
			[("STR_A3PL_Police_ReleasedNoSD" call A3PL_Localize),Color_Green] call A3PL_Notification;
		};
	};
	if(count(_atSD) > 0) then {
		private _SD = _atSD#0;
		player setPosATL (_SD modelToWorld [-4.5,8,0]);
		player setDir (getDir _SD);
		removeUniform player;
		[("STR_A3PL_Police_ReleasedNoSD" call A3PL_Localize),Color_Green] call A3PL_Notification;
	};
}] call compile_Global;

["A3PL_Police_RadarLoop",
{
	private _veh = param [0,objNull];
	private _radardir = "Front";
	private _Beam = "Land_HelipadEmpty_F" createVehicleLocal getpos _veh;
	private _Beam2 = "Land_HelipadEmpty_F" createVehicleLocal getpos _veh;
	_Beam attachTo [ _veh, [0.0, 50.0, 0.75]];
	_Beam2 attachTo [ _veh, [0.0, 150.0, 0.75]];

	[_veh] spawn A3PL_Police_RadarLoopSync;
	while {player IN _veh} do
	{
		if (_veh animationPhase "Radar_Master" > 0.5) then
		{
			private ["_inter","_target","_speed","_forward","_dist"];
			_forward = _veh getVariable ["forward",true];
			if (_veh animationPhase "Radar_Front" >= 0.5) then
			{
				_Beam attachTo [ _veh, [ 0.0, 50.0, 0.75 ] ];
				_Beam2 attachTo [ _veh, [ 0.0, 150.0, 0.75 ] ];
				_radardir = "Front";
			}else
			{
				_Beam attachTo [ _veh, [ 0.0, -60.0, 0.75 ] ];
				_Beam2 attachTo [ _veh, [ 0.0, -150.0, 0.75 ] ];
				_radardir = "Rear";
			};
			_tag2 = nearestObject [_Beam2, "LandVehicle"];
			_tag = nearestObject [_Beam, "LandVehicle"];
			if(isNull _tag) then {_tag = _tag2};
			if(isNull _tag2) then {_tag2 = _tag};
			if (!(isNull _tag)) then
			{
				private _target = _tag;
				private _speed = (speed _target) * 0.621371;
				[_veh,"target",_speed] call A3PL_Police_RadarSet;
				if ((_speed > (_veh getVariable ["lockfast",-1000])) && (_veh getVariable ["locktarget",_target] == _target)) then //set new lockfast if higher than previous
				{
					[_veh,"lockfast",_speed] call A3PL_Police_RadarSet;
					_veh setvariable ["lockfast",_speed,false];
					_veh setvariable ["locktarget",_target,false];
				};
			};
			_speed = (speed _veh) * 0.621371;
			[_veh,"patrol",_speed] call A3PL_Police_RadarSet;
		};
		uiSleep 0.1;
	};
	deleteVehicle _Beam;
	deleteVehicle _Beam2;
}] call compile_Global;

["A3PL_Police_RadarLoopSync",
{
	private _veh = param [0,objNull];
	private _tempVar = _veh getVariable ["radar_prev",["","","","","","","","",""]];
	if (!isNil "RadarLoopSyncRunning") exitwith {};
	RadarLoopSyncRunning = true;
	while {player IN _veh} do
	{
		if (_veh animationPhase "Radar_Master" > 0.5) then
		{
			private _tex = getObjectTextures _veh;
			for "_i" from 8 to 16 do
			{
				private ["_newTex"];
				_newTex = _tex#_i;
				if ((_tempVar#(_i-8)) != _newTex) then
				{
					_veh setObjectTextureGlobal [_i,_newTex];
					_tempVar set [_i,_newTex];
				};
			};
			_veh setVariable ["radar_prev",_tempVar,false];
		};
		sleep 1.5;
	};
	RadarLoopSyncRunning = nil;
}] call compile_Global;

["A3PL_Police_RadarSet",
{
	private _veh = param [0,objNull];
	private _type = param [1,"target"];
	private _number = param [2,0];
	private _global = param [3,false];
	private _selStart = switch (_type) do {
		case ("target"): {8};
		case ("lockfast"): {11};
		case ("patrol"): {14};
		case default {8};
	};

	private _number = [_number, 3] call CBA_fnc_formatNumber;
	if ((count _number) > 3) then {
		_number = toArray _number;
		_number deleteAt 0;
		_number = toString _number;
	};
	for "_i" from _selStart to (_selStart + 2) do {
		if (_global) then
		{
			_veh setObjectTextureGlobal [_i,format ["\a3pl_cars\common\textures\numbers\%1.paa",(_number select [(_i - _selStart),1])]];
		} else {
			_veh setObjectTexture [_i,format ["\a3pl_cars\common\textures\numbers\%1.paa",(_number select [(_i - _selStart),1])]];
		};
	};
}] call compile_Global;

["A3PL_Police_MarkHouse",
{
	private _house = param [0,""];
	private _name = param [1,"unknown"];
	private _warehouse = param [2,false];
	private _marker = createMarkerLocal [format ["Marked_House_%1",random 4000], _house];
	_marker setMarkerShapeLocal "ICON";
	_marker setMarkerTypeLocal "mil_warning";
	if(_warehouse) then {
		_marker setMarkerTextLocal format[("STR_A3PL_Police_Warehouse" call A3PL_Localize), _name];
	} else {
		_marker setMarkerTextLocal format[("STR_A3PL_Police_House" call A3PL_Localize), _name];
	};
	_marker setMarkerColorLocal "ColorRed";
	uiSleep 120;
	deleteMarkerLocal _marker;
}] call compile_Global;

["A3PL_Police_Panic",
{
	private _action = [("STR_Config_Interactions_PanicButton_Confirm" call A3PL_Localize)] call A3PL_Lib_ConfirmationDialog;
	if (!isNil "_action" && {!_action}) exitWith {};
	private _faction = player getVariable ["faction",""];
	private _panicCooldown = player getVariable ["panicCooldown",false];
	private _factionMembers = [_faction] call A3PL_Lib_FactionPlayers;

	if (_faction isEqualTo ("STR_Common_DOJ" call A3PL_Localize)) then {
		_factionMembers = [("STR_Common_FISD" call A3PL_Localize)] call A3PL_Lib_FactionPlayers;
		_faction = ("STR_Common_FISD" call A3PL_Localize);
		_factionMembers append ([("STR_Common_FIFR" call A3PL_Localize)] call A3PL_Lib_FactionPlayers);
		[("STR_Common_DOJ" call A3PL_Localize),("STR_A3PL_Police_DOJPanic" call A3PL_Localize),getPos player,("STR_A3PL_Police_DOJPanicMessage" call A3PL_Localize),("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
	};

	if (_faction isEqualTo ("STR_Common_GOV" call A3PL_Localize)) then {
		_factionMembers = [("STR_Common_FISD" call A3PL_Localize)] call A3PL_Lib_FactionPlayers;
		_faction = ("STR_Common_FISD" call A3PL_Localize);
		_factionMembers append ([("STR_Common_FIFR" call A3PL_Localize)] call A3PL_Lib_FactionPlayers);
		[("STR_Common_GOV" call A3PL_Localize),("STR_A3PL_Police_GOVPanic" call A3PL_Localize),getPos player,("STR_A3PL_Police_GOVPanicMessage" call A3PL_Localize),("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
	};

	if (_faction isEqualTo ("STR_Common_FIFR" call A3PL_Localize)) then {
		_factionMembers = [("STR_Common_FISD" call A3PL_Localize)] call A3PL_Lib_FactionPlayers;
		_faction = ("STR_Common_FISD" call A3PL_Localize);
		_factionMembers append ([("STR_Common_FIFR" call A3PL_Localize)] call A3PL_Lib_FactionPlayers);
		[("STR_Common_FIFR" call A3PL_Localize),("STR_A3PL_Police_FIFRPanic" call A3PL_Localize),getPos player,("STR_A3PL_Police_FIFRPanicMessage" call A3PL_Localize),("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
	};

	if (_panicCooldown) exitWith {[("STR_A3PL_Police_PanicCooldown" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	[_faction,("STR_A3PL_Police_FISDPanic" call A3PL_Localize),getPos player,("STR_A3PL_Police_FISDPanicMessage" call A3PL_Localize),("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
	[player] remoteExec ["A3PL_Police_PanicMarker", _factionMembers];
	player setVariable ["panicCooldown",true,false];

	player playActionNow "A3FL_RadioAnim_02";
	sleep 0.8;
	player playActionNow "GestureNod";

	sleep 180;
	player setVariable ["panicCooldown",false,false];
}] call compile_Global;

["A3PL_Police_PanicMarker",
{
	private _player = param [0,objNull];
	playSound3D ["A3PL_Common\effects\panic-button.ogg", player, false, getPosASL player, 5, 1, 25];
	[_player,"Panic Button","ColorRed","mil_warning",60] spawn A3PL_Lib_CreateMarker;
}] call compile_Global;

["A3PL_Police_SeizeItems",
{
	private _typeOfSeize = param [0,0];
	private _data = param [1,[]];
	private _addToStorage = [];
	if(_typeOfSeize isEqualTo 0) exitWith {};
	switch(_typeOfSeize) do {
		case 1: {
			_holders = nearestObjects [player, ["groundWeaponHolder"],3];
			{
				{_addToStorage pushback ["weapon", _x, 1];} forEach (weaponCargo _x);
				{_addToStorage pushback ["magazine", _x, 1];} forEach (magazineCargo _x);
				{_addToStorage pushback ["aitem", _x, 1];} forEach (itemCargo _x);
				deleteVehicle _x;
			} forEach _holders;
		};
		case 2: {
			_addToStorage pushback ["item", _data#0, _data#1];
		};
	};
	private _evidenceBoxes = [evidence_box_nd,evidence_box_elk];
	private _evidenceBox = evidence_box_svt;

	{
		if ((player distance2D _x) < (player distance2D _evidenceBox)) then {_evidenceBox = _x;};
	} forEach _evidenceBoxes;
	if((player distance2D A3FL_Seize_Storage) < 50) then {_evidenceBox = A3FL_Seize_Storage;}; //500000000000
	{
		private _type = _x#0;
		private _class = _x#1;
		private _amount = _x#2;
		switch(_type) do {
			case("weapon"): {
				_evidenceBox addWeaponCargoGlobal [_class, _amount];
			};
			case("magazine"): {
				if !(_class IN ["A3PL_ShovelMag","A3PL_PickAxeMag","A3PL_FireaxeMag","A3FL_DickStick_Mag","A3FL_BaseballBatMag","A3FL_GolfDriverMag","A3FL_PoliceBatonMag"]) then {
					_evidenceBox addMagazineCargoGlobal [_class, _amount];
				};
			};
			case("aitem"): {
				if (["A3PL_iphone_1", _class] call BIS_fnc_inString) then {_class = "A3PL_iphone_1";};
				if (["A3PL_3310_1", _class] call BIS_fnc_inString) then {_class = "A3PL_3310_1";};
				if (["a3pl_sonySD_1", _class] call BIS_fnc_inString) then {_class = "a3pl_sonySD_1";};
				if (["a3pl_sonyFD_1", _class] call BIS_fnc_inString) then {_class = "a3pl_sonyFD_1";};
				if (["a3pl_sonyDOJ_1", _class] call BIS_fnc_inString) then {_class = "a3pl_sonyDOJ_1";};
				_evidenceBox addItemCargoGlobal [_class, _amount];
			};
			case("item"): {
				_virtuals = _evidenceBox getVariable ['storage',[]];
				_newArray = [_virtuals, _class, _amount] call BIS_fnc_addToPairs;
				_evidenceBox setVariable ['storage', _newArray, true];
			};
		};
	} foreach _addToStorage;
}] call compile_Global;

["A3PL_Police_Breathalizer",
{
	private _target = param [0,objNull];
	[player] remoteExec ["A3PL_Police_BreathalizerReturn",_target];
	[player_item] call A3PL_Inventory_Clear;
	[player,"breathalizer",-1] remoteExec ["Server_Inventory_Add",2];
}] call compile_Global;

["A3PL_Police_BreathalizerReturn",
{
	private _cop = param [0,objNull];
	[format[("STR_A3PL_Police_AlcoholLevel" call A3PL_Localize),Player_Alcohol,"%"], Color_blue] remoteExec ["A3PL_Notification",_cop];
}] call compile_Global;

["A3PL_Police_FakeID",{
	createDialog "Dialog_FakeID";
	(findDisplay 5) call A3PL_Dialog_Localize;
}] call compile_Global;

["A3PL_Police_FakeIDSave", {
	private _name = ctrlText 1401;
	player setVariable["fakeName",_name,true];
	closeDialog 0;
	[format[("STR_A3PL_Police_NewFakeID" call A3PL_Localize),_name],Color_Green] call A3PL_Notification;
	[getPlayerUID player,(player getVariable ["character_id",""]),"LEO_FakeID_Selected",[format ["Fake ID: %1",_name]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

["A3PL_Police_MirandaCard",
{
	disableSerialization;
	("Hud_MirandaCard" call BIS_fnc_rscLayer) cutRsc ["Dialog_Miranda", "PLAIN", 2];
	sleep 10;
	("Hud_MirandaCard" call BIS_fnc_rscLayer) cutFadeOut 1;
}] call compile_Global;

["A3PL_Police_OpenSquadNb", {
	private _veh = param [0,objNull];
	createDialog "Dialog_SquadNb";
	(findDisplay 5 displayCtrl 1600) ctrlSetText ("STR_UI_SetName_Save" call A3PL_Localize);
	buttonSetAction [1600, "call A3PL_Police_SaveSquadNb;"];
	ctrlSetText [1400, _veh getVariable["CAD_Squad",((netId _veh) splitString ":") select 1]];
	A3PL_SquadNb_Veh = _veh;
}] call compile_Global;

["A3PL_Police_SaveSquadNb", {
	private _number = param[0,""];
	private _faction = player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];

	if(_number isEqualTo "") then {_number = ctrlText 1400;};
	if((count _number) > 8) exitWith {[("STR_A3PL_Police_FakeIDTooLong" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if((typeOf A3PL_SquadNb_Veh) IN ["A3PL_Pierce_Rescue","A3PL_Pierce_Pumper","A3PL_Pierce_Ladder","A3PL_Pierce_Heavy_Ladder"]) then {
		private _numberArray = _number splitString "";
		private _TruckNumber2 = format ["\A3PL_FD\textures\Truck_Numbers\%1.paa", _numberArray select 0];
		private _TruckNumber3 = format ["\A3PL_FD\textures\Truck_Numbers\%1.paa", _numberArray select 1];
		A3PL_SquadNb_Veh setObjectTextureGlobal [8, _TruckNumber2];
		A3PL_SquadNb_Veh setObjectTextureGlobal [9, _TruckNumber3];
		A3PL_SquadNb_Veh setVariable ["CAD_Squad",_number,true];
	} else {
		if((typeOf A3PL_SquadNb_Veh) IN ["A3PL_Silverado_FD_Brush","EC_F450_Brush"]) then {
			private _numberArray = _number splitString "";
			private _TruckNumber = format ["\A3PL_FD\textures\Truck_Numbers\%1.paa", _numberArray select 0];
			A3PL_SquadNb_Veh setObjectTextureGlobal [8, _TruckNumber];
			A3PL_SquadNb_Veh setVariable ["CAD_Squad",_number,true];
		} else {
			A3PL_SquadNb_Veh setVariable ["CAD_Squad",_number,true];
		};
	};
	A3PL_SquadNb_Veh setVariable["CAD_Faction",_faction,true];
	A3PL_SquadNb_Veh = nil;
	closeDialog 0;
}] call compile_Global;

["A3PL_Police_EvidenceMarker", {
	private _obj = param [0,objNull];
	createDialog "Dialog_SquadNb";
	(findDisplay 5 displayCtrl 1600) ctrlSetText ("STR_UI_SetName_Save" call A3PL_Localize);
	buttonSetAction [1600, "call A3PL_Police_EvidenceMarkerSet;"];
	ctrlSetText [1400, "1"];
	A3PL_EvidenceMarker = _obj;
}] call compile_Global;

["A3PL_Police_EvidenceMarkerSet", {
	private _number = ctrlText 1400;
	if !(_number IN ['1','2','3','4','5','6','7','8','9']) exitWith {[("STR_A3PL_Police_InvalidNumber" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _texture = format ["\A3FL_Objects\Police\data\EM\%1.paa", _number];
	A3PL_EvidenceMarker setObjectTextureGlobal [0, _texture];

	A3PL_EvidenceMarker = nil;
	closeDialog 0;
}] call compile_Global;

["A3PL_Police_SetPowder", {
	player setVariable["hasPowder",serverTime,true];
}] call compile_Global;

["A3PL_Police_CheckPowder", {
	private _target = param[0,objNull];
	private _hasPowder = (serverTime - (_target getVariable["hasPowder",0])) < PD_Check_Powder;
	private _reference = [(player getVariable ["character_id",""])] call A3PL_Police_GetGunRef;
	private _text = if(_hasPowder) then {
		format[("STR_A3PL_Police_PowderFound" call A3PL_Localize),_reference];
	} else {
		("STR_A3PL_Police_NoPowderFound" call A3PL_Localize);
	};
	[_text,Color_Blue] call A3PL_Notification;
	[player_item] call A3PL_Inventory_Clear;
	[player,"powdertestkit",-1] remoteExec ["Server_Inventory_Add",2];
}] call compile_Global;

["A3PL_Police_DropCasing", {
	private _veh = vehicle player;
	private _classname = typeOf _veh;
	if(_classname IN ["A3PL_Jayhawk","A3FL_AS_365"]) exitWith {};
	if(player getVariable ["pVar_RedNameOn",false]) exitWith {};
	private _chance = random 100;
	if(_chance > 50) exitWith {};
	private _nearCasings = count(player nearEntities ["A3FL_Bullet_Casings", 10]);
	if(_nearCasings >= 3) exitWith {};
	private _weapon = currentWeapon player;
	private _weaponName = getText (configFile >> "CfgWeapons" >> _weapon >> "displayName");
	private _reference = [(player getVariable ["character_id",""])] call A3PL_Police_GetGunRef;
	private _data = format["%1|%2",_weaponName,_reference];
	private _distances = [0.5,0.25,0.2,-0.1,-0.25,-0.5];
	private _pos = position player;
	_pos set[0, (_pos#0 + selectRandom _distances)];
	_pos set[1, (_pos#1 + selectRandom _distances)];
	private _casing = "A3FL_Bullet_Casings" createVehicle _pos;
	_casing setVariable["class","bulletcasing",true];
	_casing setVariable["evidence_data",_data,true];
	_casing setPosATL(_pos);
}] call compile_Global;

["A3PL_Police_BagEvidence", {
	private _evidence = param[0,objNull];
	if (isNull _evidence) exitWith {};
	if !(["evidence_bag",1] call A3PL_Inventory_Has) exitWith {[("STR_A3PL_Police_NoEvidenceBag" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	["evidence_bag"] call A3PL_Inventory_Use;
	["evidence_bag",-1] call A3PL_Inventory_Add;
	private _data = _evidence getVariable["evidence_data","no evidence found"];
	Player_Item setVariable["evidence",_data,true];
	deleteVehicle _evidence;
}] call compile_Global;

["A3PL_Police_GetGunRef", {
	private _fullID = (param[0,""]) splitString "";
	private _ref = "";
	for "_i" from 8 to 12 do {
		_ref = format["%1%2",_ref,(_fullID select _i)];
	};
	_ref;
}] call compile_Global;

["A3PL_Police_Analyze", {
	if ((isNull Player_Item) || {!(Player_ItemClass isEqualTo "evidence_bag")}) exitwith {[("STR_A3PL_Police_NoProofToAnalyze" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (npc_evidence getVariable["inUse",false]) exitWith {[("STR_A3PL_Police_LabAlreadyInProcess" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _bag = Player_Item;
	private _type = Player_Item getVariable["evidence_type",0];
	private _data = _bag getVariable["evidence",nil];
	if (isNil "_data") exitWith {[("STR_A3PL_Police_EmptyEvidenceBag" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _split = _data splitString "|";
	private _text = switch(_type) do {
		case 0: {
			format[("STR_A3PL_Police_AnalysisInfo" call A3PL_Localize),_split select 0,_split select 1];
		};
	};

	npc_evidence setVariable["inUse",true,true];

	if (Player_ActionDoing) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[("STR_A3PL_Police_AnalysisInProgress" call A3PL_Localize),PD_Analyze_Timer] spawn A3PL_Lib_LoadAction;
	waitUntil{Player_ActionDoing};
	while {Player_ActionDoing} do {
		if ((player distance2D npc_evidence) > 5) exitWith {[("STR_A3PL_Police_LeftLab" call A3PL_Localize),Color_Red] call A3PL_Notification; Player_ActionInterrupted = true;};
	};
	if(Player_ActionInterrupted) exitWith {};
	npc_evidence setVariable["inUse",false,true];
	[_text,Color_Blue] call A3PL_Notification;

	["evidence_bag",-1] call A3PL_Inventory_Add;
	[] call A3PL_Inventory_Clear;
}] call compile_Global;

["A3PL_Police_Bargate",
{
	private _bargate = (nearestObjects [player, ["Land_A3FL_DOC_Gate","Land_A3PL_BarGate","Land_A3PL_BarGate_Left","Land_A3PL_BarGate_Right","Land_A3FL_DOC_Warehouse","Land_Eclipse_Bollard_1","Land_Eclipse_Bollard_2","Land_Eclipse_Bollard_3","Land_Eclipse_Bollard_4"], 20]) select 0;
	private _veh = typeOf (vehicle player);
	private _source = true;
	private _canUse = [getPos _bargate] call A3PL_Config_CanUseBargate;
	if !(_canUse) exitWith {};
	private _allowedVehicles = (Config_FISD_Vehs + Config_FIFR_Vehs + Config_DOJ_Vehs);
	if ((_veh IN _allowedVehicles) || ((typeOf _bargate IN ["Land_Eclipse_Bollard_1","Land_Eclipse_Bollard_2","Land_Eclipse_Bollard_3","Land_Eclipse_Bollard_4"]) && ((player distance [6228.60,7543.07,0]) < 10))) then {
		private _anim = switch(typeOf _bargate) do {
			case "Land_A3PL_Bargate_Right": {"bargate2"};
			case "Land_A3PL_Bargate_Left": {"bargate1"};
			case "Land_Eclipse_Bollard_1": {"togglebollard"};
			case "Land_Eclipse_Bollard_2": {"togglebollard"};
			case "Land_Eclipse_Bollard_3": {"togglebollard"};
			case "Land_Eclipse_Bollard_4": {"togglebollard"};
			case "Land_A3FL_DOC_Warehouse": {
				if((player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) isEqualTo ("STR_Common_FISD" call A3PL_Localize)) then {
					"door_4"
				};
			};
			case "Land_A3FL_DOC_Gate": {
				private _distanceOne = player distance2D (_bargate modelToWorldVisual (_bargate selectionPosition ["Gate_1_Pos","Memory"]));
				private _distanceTwo = player distance2D (_bargate modelToWorldVisual (_bargate selectionPosition ["Gate_2_Pos","Memory"]));
				_source = false;
				if(_distanceTwo>_distanceOne) then {
					"Gate_1"
				} else {
					"Gate_2"
				};
			};
			default {
				private _distanceOne = player distance2D (_bargate modelToWorldVisual (_bargate selectionPosition ["button_bargate1","Memory"]));
				private _distanceTwo = player distance2D (_bargate modelToWorldVisual (_bargate selectionPosition ["button_bargate2","Memory"]));
				if(_distanceTwo>_distanceOne) then {
					"bargate1"
				} else {
					"bargate2"
				};
			};
		};
		if(_source) then {
			if ((_bargate animationSourcePhase _anim) < 0.5) then {
			_bargate animateSource [_anim,1];
			} else {
				_bargate animateSource [_anim,0];
			};
		} else {
			if ((_bargate animationPhase _anim) < 0.5) then {
				_bargate animate [_anim,1];
			} else {
				_bargate animate [_anim,0];
			};
		};
	};
}] call compile_Global;

["A3PL_Police_EmptyEvidence",
{
	private _storage = A3FL_Seize_Storage;
	private _vInv = _storage getVariable["storage",[]];
	private _FISD = [("STR_Common_FISD" call A3PL_Localize)] call A3PL_Lib_FactionPlayers;
	private _aitems = getItemCargo _storage;
	private _mags = getMagazineCargo _storage;
	private _backpacks = getBackpackCargo _storage;
	private _weapons = getWeaponCargo _storage;
	private _target = param [0,player_objIntersect];
	if (count(_FISD) < PD_Evidences_Members_Required) exitWith {[format[("STR_A3PL_Police_NotEnoughSDToEmptyEvidenceLocker" call A3PL_Localize),PD_Evidences_Members_Required],Color_Red] call A3PL_Notification;};
	if (_vInv isEqualTo [] && {_weapons isEqualTo []} && {_backpacks isEqualTo []} && {_mags isEqualTo []} && {_aitems isEqualTo []}) exitwith {[("STR_A3PL_Police_EvidenceLockerEmpty" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	[("STR_A3PL_Police_FISDTransportEvidence" call A3PL_Localize),("STR_A3PL_Police_FISDTransportEvidenceMessage" call A3PL_Localize),("STR_Common_FishersNews" call A3PL_Localize)] remoteExec ["A3PL_Player_News",-2];

	[("STR_A3PL_Police_UnloadingEvidence" call A3PL_Localize),PD_Evidences_Time_To_Unload] spawn A3PL_Lib_LoadAction;
	waitUntil{Player_ActionDoing};
	while {Player_ActionDoing} do {
		if ((player distance2D _target) > 2) exitWith {Player_ActionInterrupted = true;};
		if (player getVariable ["Incapacitated",false]) exitwith {Player_ActionInterrupted = true;};
		if ((vehicle player) isNotEqualTo player) exitwith {Player_ActionInterrupted = true;};
	};
	sleep 0.5;
	if(Player_ActionInterrupted) exitWith {
		[("STR_Common_ActionInterrupted" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};
	clearItemCargoGlobal _storage;
	clearMagazineCargoGlobal _storage;
	clearWeaponCargoGlobal _storage;
	clearBackpackCargoGlobal _storage;
	_storage setVariable["storage",[],true];

	{
		[("STR_Common_SheriffsDepartment" call A3PL_Localize),PD_Evidences_Reward] remoteExec ["Server_Government_AddBalance",2];
		[format[("STR_A3PL_Police_EvidenceUnloaded" call A3PL_Localize),PD_Evidences_Reward],Color_blue] remoteExec ["A3PL_Notification",_x];
	} foreach _FISD;
}] call compile_Global;

["A3PL_Police_BlueprintBuy",
{
	[] spawn {
		private _action = [format[("STR_A3PL_Police_BlueprintPurchase" call A3PL_Localize),GOV_Faction_Blueprint_Price]] call A3PL_Lib_ConfirmationDialog;
		if (!isNil "_action" && {!_action}) exitWith {};

		private _factionBalance = [player] call A3PL_Government_MyFactionBalance;
		if(_factionBalance < GOV_Faction_Blueprint_Price) exitwith {[("STR_A3PL_Police_BlueprintNoMoney" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		[_factionBalance,-GOV_Faction_Blueprint_Price,"",format[("STR_Common_BlueprintPurchase" call A3PL_Localize)]] remoteExec ["Server_Government_AddBalance",2];

		["blueprint_fisd",1] call A3PL_Inventory_Add;
	};
}] call compile_Global;

["A3PL_Police_BlueprintEquipmentBuy",
{
	[] spawn {
		private _action = [format[("STR_Common_BlueprintAmmoPurchase" call A3PL_Localize),GOV_Faction_EQ_Blueprint_Price]] call A3PL_Lib_ConfirmationDialog;
		if (!isNil "_action" && {!_action}) exitWith {};

		private _factionBalance = [player] call A3PL_Government_MyFactionBalance;
		if(_factionBalance < GOV_Faction_EQ_Blueprint_Price) exitwith {[("STR_A3PL_Police_BlueprintNoMoney" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		[_factionBalance,-GOV_Faction_EQ_Blueprint_Price,"",format[("STR_Common_BlueprintAmmoPurchase" call A3PL_Localize)]] remoteExec ["Server_Government_AddBalance",2];

		["blueprinteq_fisd",1] call A3PL_Inventory_Add;
	};
}] call compile_Global;

#define STATUSLIST [("STR_Common_Available" call A3PL_Localize),("STR_A3PL_Police_Unavailable" call A3PL_Localize),("STR_A3PL_Police_OnScene" call A3PL_Localize),("STR_A3PL_Police_EnRoute" call A3PL_Localize),("STR_A3PL_Police_Occupied" call A3PL_Localize)]

["A3PL_Police_OpenMDT",
{
	params [["_veh",objNull]];
	private _ofc = "";
	if (isNull _veh) exitwith {};
	if ((player getVariable["Cuffed",false]) || (player getVariable["Cuffed",false])) exitWith {[("STR_A3PL_Police_MDTHandcuffed" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!(_veh getVariable["CAD_On",false]) && {!((player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)])}) exitwith {[("STR_A3PL_Police_ComputerLocked" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_veh getVariable["CAD_InUse",false]) exitWith {[("STR_A3PL_Police_MDTInUse" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((_veh getVariable["CAD_Faction","citizen"]) isEqualTo ("STR_Common_FIFR" call A3PL_Localize) && {((player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) isNotEqualTo ("STR_Common_FIFR" call A3PL_Localize))}) exitwith {[("STR_A3PL_Police_FIFRComputersAccessDenied" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if !(_veh getVariable["CAD_On",false]) then {
		_veh setVariable["CAD_On",true,true];
		_ofc = format["%2 %1",player getVariable ["name","UNKNOWN"],[player getVariable["faction","citizen"],"rank", (player getVariable ["character_id",""])] call A3PL_Config_GetFactionRankData];
		_veh setVariable["CAD_Ofc",_ofc,true];
		_veh setVariable["CAD_Faction",(player getVariable "job"),true];
	};
	_veh setVariable["CAD_InUse",true,true];
	A3FL_Police_MDT = _veh;

	createDialog "Dialog_CAD";
	(findDisplay 95) call A3PL_Dialog_Localize;

	private _commandsList = [_veh] call A3PL_Police_GetCommands;
	private _specList = [_veh] call A3PL_Police_GetSpecs;
	private _districts = [_veh] call A3PL_Police_GetDistricts;
	private _faction = _veh getVariable["CAD_Faction",""];
	private _display = findDisplay 95;

	for "_i" from 0 to 4 do {
		ctrlShow [1100 + _i, false];
		ctrlShow [1400 + _i, false];
	};

	_control = _display displayCtrl 2100;
	{
		_index = _control lbAdd _x#0;
		_control lbSetData [_index, _x#1];
	} forEach _commandsList;
	_control ctrlAddEventHandler ["LBSelChanged","_this call A3PL_Police_PopulateInputs;"];

	_control = _display displayCtrl 2101;
	{
		_control lbAdd _x;
	} forEach STATUSLIST;
	private _sIndex = STATUSLIST find (_veh getVariable["CAD_Status",("STR_A3PL_Police_Unavailable" call A3PL_Localize)]);
	_control lbSetCurSel _sIndex;
	_control ctrlAddEventHandler ["LBSelChanged","[_this#0,_this#1,true] call A3PL_Police_SetStatus;"];

	_control = _display displayCtrl 2104;
	{
		_control lbAdd _x;
	} forEach STATUSLIST;
	_control ctrlAddEventHandler ["LBSelChanged","[_this#0,_this#1,false] call A3PL_Police_SetStatus;"];

	_control = _display displayCtrl 2102;
	{
		_control lbAdd _x;
	} forEach _specList;
	private _sIndex = _specList find (_veh getVariable["CAD_Spec","-"]);
	_control lbSetCurSel _sIndex;
	_control ctrlAddEventHandler ["LBSelChanged","_this call A3PL_Police_SetSpec;"];

	_control = _display displayCtrl 2103;
	{
		_control lbAdd _x;
	} forEach _districts;
	private _dIndex = _districts find (_veh getVariable["CAD_District",""]);
	_control lbSetCurSel _dIndex;
	_control ctrlAddEventHandler ["LBSelChanged","[_this#0,_this#1,true] call A3PL_Police_SetDistrict;"];

	_control = _display displayCtrl 2106;
	{
		_control lbAdd _x;
	} forEach _districts;
	_control ctrlAddEventHandler ["LBSelChanged","[_this#0,_this#1,false] call A3PL_Police_SetDistrict;"];

	_control = _display displayCtrl 2105;
	{
		if ((_x getVariable["CAD_On",false]) && {_x getVariable["CAD_Faction",""] isEqualTo _faction || player getVariable["faction",""] isEqualTo "dispatch"} && {!(underwater _x)} && {_x getVariable ["CAD_Squad",""] isNotEqualTo ""}) then {
			private _i = _control lbAdd (_x getVariable["CAD_Squad",""]);
			_control lbSetData[_i, netId _x];
		};
	} foreach vehicles - [A3FL_Police_MDT];
	_control ctrlAddEventHandler ["LBSelChanged","_this call A3PL_Police_UnitSelected;"];

	_control = _display displayCtrl 1405;
	_control ctrlSetText (_veh getVariable ["CAD_Squad",("STR_A3PL_Police_Undefined" call A3PL_Localize)]);
	_control = _display displayCtrl 1406;
	_control ctrlSetText (_veh getVariable ["CAD_Info",("STR_A3PL_Police_NoAdditionalInfo" call A3PL_Localize)]);

	if((_veh getVariable ["CAD_Screen",""]) isEqualTo "") then {
		[("STR_A3PL_Police_VehicleConnected" call A3PL_Localize)] call A3PL_Police_UpdateComputer;
	} else {
		[_veh getVariable "CAD_Screen"] call A3PL_Police_UpdateComputer;
	};

	[_faction] spawn A3PL_Police_LoadUnits;
	[_faction] call A3PL_Police_GetCalls;


	private _fieldMemory = _veh getVariable["CAD_FieldMemory",[]];
	if(_fieldMemory isEqualTo []) exitWith {ctrlShow [1107, false]};
	_control = _display displayCtrl 2100;
	if (_fieldMemory#0 isNotEqualTo -1) then {_control lbSetCurSel _fieldMemory#0;};

	for "_i" from 0 to 4 do {
		ctrlSetText [1400 + _i, _fieldMemory#(_i+1)];
	};
	if(_fieldMemory#6) then {ctrlShow [1106,false]} else {ctrlShow [1107, false]};
	if((player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) isEqualTo ("STR_Common_FIFR" call A3PL_Localize)) then {ctrlEnable[999,false]};
}] call compile_Global;

["A3PL_Police_PopulateInputs",
{
	params ["_control", "_selectedIndex"];
	private _display = findDisplay 95;
	private _cmd = _control lbData _selectedIndex;
	private _textList = [_cmd] call A3PL_Police_GetInputs;
	private _count = count(_textList);
	for "_i" from 0 to 4 do {
		ctrlShow [1100 + _i, false];
		ctrlShow [1400 + _i, false];
	};

	for "_i" from 0 to 4 do {
		_ctrl = _display displayCtrl (1100 + _i);
		_ctrlE = _display displayCtrl (1400 + _i);
		if(_i < _count) then {
			if ((ctrlText _ctrl) isNotEqualTo (_textList#_i)) then {
				_ctrl ctrlSetStructuredText parseText format["<t size='1.5'>%1</t>",_textList#_i];
				_ctrlE ctrlSetText "";
			};
			_ctrl ctrlShow true;
			_ctrlE ctrlShow true;
		} else {
			_ctrl ctrlSetStructuredText parseText "";
			_ctrlE ctrlSetText "";
		};
	};
}] call compile_Global;

["A3PL_Police_GetInputs",
{
	params [["_cmd",""]];
	private _list = switch(_cmd) do {
		case "createcall": {[("STR_A3PL_Police_Institution" call A3PL_Localize),("STR_A3PL_Police_Title" call A3PL_Localize),("STR_A3PL_Police_Information" call A3PL_Localize)]};
		case "lookup": {[("STR_A3PL_Police_Name" call A3PL_Localize)]};
		case "lookuplicense": {[("STR_A3PL_Police_Registration" call A3PL_Localize)]};
		case "lookupvehicles": {[("STR_A3PL_Police_Name" call A3PL_Localize)]};
		case "lookupcvehicles": {[("STR_A3PL_Police_CompanyName" call A3PL_Localize)]};
		case "lookupcompany": {[("STR_A3PL_Police_CompanyName" call A3PL_Localize)]};
		case "lookupaddress": {[("STR_A3PL_Police_Name" call A3PL_Localize)]};
		case "lookupwarehouse": {[("STR_A3PL_Police_Name" call A3PL_Localize)]};
		case "markstolen": {[("STR_A3PL_Police_Registration" call A3PL_Localize)]};
		case "markfound": {[("STR_A3PL_Police_Registration" call A3PL_Localize)]};
		case "insertbolo": {[("STR_A3PL_Police_Description" call A3PL_Localize)]};
		case "removebolo": {[("STR_A3PL_Police_WantedID" call A3PL_Localize)]};
		case "setcaution": {[("STR_A3PL_Police_Name" call A3PL_Localize),("STR_A3PL_Police_Note" call A3PL_Localize)]};
		case "clearcautions": {[("STR_A3PL_Police_Name" call A3PL_Localize)]};
		case "viewlicense": {[("STR_A3PL_Police_LicenseCode" call A3PL_Localize)]};
		case "renewlicense": {[("STR_A3PL_Police_Name" call A3PL_Localize),("STR_A3PL_Police_LicenseCode" call A3PL_Localize)]};
		case "revokelicense": {[("STR_A3PL_Police_Name" call A3PL_Localize),("STR_A3PL_Police_LicenseCode" call A3PL_Localize)]};
		case "insertarrest": {[("STR_A3PL_Police_Name" call A3PL_Localize),("STR_A3PL_Police_Time" call A3PL_Localize),("STR_A3PL_Police_Information" call A3PL_Localize)]};
		case "insertreport": {[("STR_A3PL_Police_Name" call A3PL_Localize),("STR_A3PL_Police_Title" call A3PL_Localize),("STR_A3PL_Police_Information" call A3PL_Localize)]};
		case "insertwarning": {[("STR_A3PL_Police_Name" call A3PL_Localize),("STR_A3PL_Police_Title" call A3PL_Localize),("STR_A3PL_Police_Information" call A3PL_Localize)]};
		case "insertticket": {[("STR_A3PL_Police_Name" call A3PL_Localize),("STR_A3PL_Police_Amount" call A3PL_Localize),("STR_A3PL_Police_Information" call A3PL_Localize)]};
		case "insertwarrant": {[("STR_A3PL_Police_Name" call A3PL_Localize),("STR_A3PL_Police_WarrantType" call A3PL_Localize),("STR_A3PL_Police_Information" call A3PL_Localize)]};
		case "warninglist": {[("STR_A3PL_Police_Name" call A3PL_Localize)]};
		case "ticketlist": {[("STR_A3PL_Police_Name" call A3PL_Localize)]};
		case "arrestlist": {[("STR_A3PL_Police_Name" call A3PL_Localize)]};
		case "warrantlist": {[("STR_A3PL_Police_Name" call A3PL_Localize)]};
		case "warrantinfo": {[("STR_A3PL_Police_Name" call A3PL_Localize),("STR_A3PL_Police_WarrantID" call A3PL_Localize)]};
		case "removewarrant": {[("STR_A3PL_Police_Name" call A3PL_Localize),("STR_A3PL_Police_WarrantID" call A3PL_Localize)]};
		case "removearrest": {[("STR_A3PL_Police_Name" call A3PL_Localize),("STR_A3PL_Police_ArrestDate" call A3PL_Localize)]};
		case "evidencelock": {[("STR_A3PL_Police_EvidenceStation" call A3PL_Localize)]};
		case "lookpatient": {[("STR_A3PL_Police_Name" call A3PL_Localize)]};
		case "lookhistory": {[("STR_A3PL_Police_Name" call A3PL_Localize)]};
		case "addhistory": {[("STR_A3PL_Police_Name" call A3PL_Localize),("STR_A3PL_Police_Location" call A3PL_Localize),("STR_A3PL_Police_Information" call A3PL_Localize)]};
		case "callvfd": {[("STR_A3PL_Police_Message" call A3PL_Localize)]};
		case "callpro": {[("STR_A3PL_Police_Message" call A3PL_Localize),("STR_A3PL_Police_Recipient" call A3PL_Localize)]};
		case "callallpro": {[("STR_A3PL_Police_Message" call A3PL_Localize)]};
		case "callall": {[("STR_A3PL_Police_Message" call A3PL_Localize)]};
		case "cctv": {[("STR_A3PL_Police_Location" call A3PL_Localize)]};
		case "clearfires": {[]};
		case "pausefires": {[]};
		default {[]};
	};
	_list;
}] call compile_Global;

["A3PL_Police_GetCommands",
{
	params [["_veh",objNull]];
	private _faction = if (isNil {_veh getVariable["CAD_Faction",nil]}) then {player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]} else {_veh getVariable["CAD_Faction",nil]};
	private _list = switch(_faction) do {
		case ("STR_Common_FISD" call A3PL_Localize): {[[("STR_A3PL_Police_CreateDispatch" call A3PL_Localize),"createcall"],[("STR_A3PL_Police_ConsultCriminalRecord" call A3PL_Localize),"lookup"],[("STR_A3PL_Police_ConsultRegistration" call A3PL_Localize),"lookuplicense"],[("STR_A3PL_Police_InsertWarning" call A3PL_Localize),"insertwarning"],[("STR_A3PL_Police_ViewWarnings" call A3PL_Localize),"warninglist"],[("STR_A3PL_Police_InsertFine" call A3PL_Localize),"insertticket"],[("STR_A3PL_Police_ViewFines" call A3PL_Localize),"ticketlist"],[("STR_A3PL_Police_ViewWarrants" call A3PL_Localize),"warrantlist"],[("STR_A3PL_Police_ViewWarrantInfo" call A3PL_Localize),"warrantinfo"],[("STR_A3PL_Police_InsertArrest" call A3PL_Localize),"insertarrest"],[("STR_A3PL_Police_ViewArrests" call A3PL_Localize),"arrestlist"],[("STR_A3PL_Police_InsertReport" call A3PL_Localize),"insertreport"],[("STR_A3PL_Police_ReportStolenVehicle" call A3PL_Localize),"markstolen"],[("STR_A3PL_Police_ReportFoundVehicle" call A3PL_Localize),"markfound"],[("STR_A3PL_Police_ViewStolenVehicles" call A3PL_Localize),"stolenvehicles"],[("STR_A3PL_Police_ViewBOLOs" call A3PL_Localize),"bololist"],[("STR_A3PL_Police_InsertBOLO" call A3PL_Localize),"insertbolo"],[("STR_A3PL_Police_RemoveBOLO" call A3PL_Localize),"removebolo"],[("STR_A3PL_Police_InternalNote" call A3PL_Localize),"setcaution"],[("STR_A3PL_Police_ClearInternalNotes" call A3PL_Localize),"clearcautions"],[("STR_A3PL_Police_ViewLicenses" call A3PL_Localize),"viewlicense"],[("STR_A3PL_Police_DarknetLogs" call A3PL_Localize),"darknet"],[("STR_A3PL_Police_CCTVAccess" call A3PL_Localize),"cctv"],[("STR_A3PL_Police_ActivateDOCAlarm" call A3PL_Localize),"doclockdown"],[("STR_A3PL_Police_UnlockEvidenceLocker" call A3PL_Localize),"evidencelock"]]};
		case ("STR_Common_DOJ" call A3PL_Localize): {[[("STR_A3PL_Police_ConsultCriminalRecord" call A3PL_Localize),"lookup"],[("STR_A3PL_Police_ViewLicenses" call A3PL_Localize),"viewlicense"],[("STR_A3PL_Police_RenewLicense" call A3PL_Localize),"renewlicense"],[("STR_A3PL_Police_RevokeLicense" call A3PL_Localize),"revokelicense"],[("STR_A3PL_Police_ViewArrests" call A3PL_Localize),"arrestlist"],[("STR_A3PL_Police_InsertArrest" call A3PL_Localize),"insertarrest"],[("STR_A3PL_Police_ConsultRegistration" call A3PL_Localize),"lookuplicense"],[("STR_A3PL_Police_ConsultVehicles" call A3PL_Localize),"lookupvehicles"],[("STR_A3PL_Police_ConsultAddress" call A3PL_Localize),"lookupaddress"],[("STR_A3PL_Police_ConsultWarehouse" call A3PL_Localize),"lookupwarehouse"],[("STR_A3PL_Police_ConsultCompany" call A3PL_Localize),"lookupcompany"],[("STR_A3PL_Police_ConsultCompanyVehicles" call A3PL_Localize),"lookupcvehicles"],[("STR_A3PL_Police_ViewFines" call A3PL_Localize),"ticketlist"],[("STR_A3PL_Police_ViewWarrants" call A3PL_Localize),"warrantlist"],[("STR_A3PL_Police_ViewWarrantInfo" call A3PL_Localize),"warrantinfo"],[("STR_A3PL_Police_InsertWarrant" call A3PL_Localize),"insertwarrant"],[("STR_A3PL_Police_RemoveWarrant" call A3PL_Localize),"removewarrant"]]};
		case ("STR_Common_FIFR" call A3PL_Localize): {[[("STR_A3PL_Police_CreateDispatch" call A3PL_Localize),"createcall"],[("STR_A3PL_Police_ViewPatientInfo" call A3PL_Localize),"lookpatient"],[("STR_A3PL_Police_ConsultMedicalRecord" call A3PL_Localize),"lookhistory"],[("STR_A3PL_Police_AddMedicalRecord" call A3PL_Localize),"addhistory"],[("STR_A3PL_Police_OpenCloseClinics" call A3PL_Localize),"clinic"],[("STR_A3PL_Police_ViewHydrants" call A3PL_Localize),"showhydrant"],[("STR_A3PL_Police_ViewWindDirection" call A3PL_Localize),"wind"],[("STR_A3PL_Police_UseVFDPager" call A3PL_Localize),"callvfd"],[("STR_A3PL_Police_UseFIFRPager" call A3PL_Localize),"callpro"],[("STR_A3PL_Police_UseGlobalPager" call A3PL_Localize),"callallpro"],[("STR_A3PL_Police_UseGlobalPager" call A3PL_Localize),"callall"],[("STR_A3PL_Police_TriggerFirestationAlarm" call A3PL_Localize),"sendcall"],[("STR_A3PL_Police_ViewLicenses" call A3PL_Localize),"viewlicense"],[("STR_A3PL_Police_RevokeLicense" call A3PL_Localize),"revokelicense"],[("STR_A3PL_Admin_Perm_DeletFire" call A3PL_Localize),"clearfires"],[("STR_A3PL_Admin_Perm_PauseFire" call A3PL_Localize),"pausefires"]]};
		case ("STR_Common_GOV" call A3PL_Localize): {[[("STR_A3PL_Police_ConsultCriminalRecord" call A3PL_Localize),"lookup"],[("STR_A3PL_Police_ViewLicenses" call A3PL_Localize),"viewlicense"],[("STR_A3PL_Police_RenewLicense" call A3PL_Localize),"renewlicense"],[("STR_A3PL_Police_RevokeLicense" call A3PL_Localize),"revokelicense"],[("STR_A3PL_Police_ViewArrests" call A3PL_Localize),"arrestlist"],[("STR_A3PL_Police_InsertArrest" call A3PL_Localize),"insertarrest"],[("STR_A3PL_Police_ConsultRegistration" call A3PL_Localize),"lookuplicense"],[("STR_A3PL_Police_ConsultAddress" call A3PL_Localize),"lookupaddress"],[("STR_A3PL_Police_ConsultWarehouse" call A3PL_Localize),"lookupwarehouse"],[("STR_A3PL_Police_ConsultCompany" call A3PL_Localize),"lookupcompany"],[("STR_A3PL_Police_ViewFines" call A3PL_Localize),"ticketlist"],[("STR_A3PL_Police_ViewWarrants" call A3PL_Localize),"warrantlist"],[("STR_A3PL_Police_ViewWarrantInfo" call A3PL_Localize),"warrantinfo"]]};
		default {[]};
	};
	_list;
}] call compile_Global;

["A3PL_Police_GetCalls",
{
	params[["_faction",""]];
	private _display = findDisplay 95;
	if(isNull _display) exitwith {};
	private _control = _display displayCtrl 1501;
	lbClear _control;
	{
		if((_x#0) isEqualTo _faction || player getVariable["faction",""] isEqualTo "dispatch") then {
			_index = if(count(_x#4) > 1) then {_control lbAdd format[("STR_A3PL_Police_UnitsResponding" call A3PL_Localize),_x#1,count(_x#4)]} else {_control lbAdd format[("STR_A3PL_Police_UnitResponding" call A3PL_Localize),_x#1,count(_x#4)]};
			_control lbSetValue [_index, _forEachIndex];
			if(A3FL_Police_MDT IN _x#4) then {_control lbSetColor [_index, [0.5,0.5,0,1]];};
		};
	} forEach Server_Police_Dispatch;
	_control ctrlAddEventHandler ["LBSelChanged","_this call A3PL_Police_CallSelected;"];
}] call compile_Global;

["A3PL_Police_CallSelected",
{
	params ["_control", "_selectedIndex"];
	if (_selectedIndex isEqualTo -1) exitwith {[("STR_A3PL_Police_SelectCall" call A3PL_Localize),Color_Blue] call A3PL_Notification;};
	private _index = _control lbValue _selectedIndex;
	private _callData = Server_Police_Dispatch#_index;
	if (A3FL_Police_MDT IN _callData#4) then {ctrlSetText [888, ("STR_A3PL_Police_Unassign" call A3PL_Localize)];} else {ctrlSetText [888, ("STR_A3PL_Police_Assign" call A3PL_Localize)];};
	private _display = findDisplay 95;
	private _units = _display displayCtrl 2105;
	private _unitIdx = lbCurSel _units;
	if(_unitIdx isEqualTo -1) exitwith {};
	private _unit = objectFromNetId (_units lbData _unitIdx);
	if (_unit IN _callData#4) then {ctrlSetText [889, ("STR_A3PL_Police_Unassign" call A3PL_Localize)];} else {ctrlSetText [889, ("STR_A3PL_Police_Assign" call A3PL_Localize)];};
}] call compile_Global;

["A3PL_Police_UnitSelected",
{
	params ["_control", "_selectedIndex"];
	private _display = findDisplay 95;
	private _callControl = _display displayCtrl 1501;
	private _targetId = _control lbData _selectedIndex;
	private _target = objectFromNetId _targetId;
	if(lbCurSel _callControl isNotEqualTo -1) then {
		private _index = _callControl lbValue (lbCurSel _callControl);
		private _callData = Server_Police_Dispatch#_index;
		if (_target IN (_callData#4)) then {ctrlSetText [889, ("STR_A3PL_Police_Unassign" call A3PL_Localize)]} else {ctrlSetText [889, ("STR_A3PL_Police_Assign" call A3PL_Localize)]};
	};
	private _statusControl = _display displayCtrl 2104;
	private _targetStatus = _target getVariable["CAD_Status",("STR_A3PL_Police_Unavailable" call A3PL_Localize)];
	private _sIndex = STATUSLIST find _targetStatus;
	_statusControl lbSetCurSel _sIndex;
	private _districtControl = _display displayCtrl 2106;
	private _districts = [_target] call A3PL_Police_GetDistricts;
	private _targetDistrict = _target getVariable["CAD_District",""];
	private _sIndex = _districts find _targetDistrict;
	_districtControl lbSetCurSel _sIndex;
	[_targetId] call A3PL_Police_ShowInfo;
}] call compile_Global;

["A3PL_Police_ShowCall",
{
	params[["_faction",""]];
	private _display = findDisplay 95;
	private _control = _display displayCtrl 1501;
	private _index = _control lbValue (lbCurSel _control);
	if (_index isEqualTo -1) exitwith {[("STR_A3PL_Police_SelectCall" call A3PL_Localize),Color_Blue] call A3PL_Notification;};
	private _callData = Server_Police_Dispatch#_index;
	ctrlShow [1106, false];
	private _mapControl = _display displayCtrl 1107;
	_mapControl ctrlShow true;
	_mapControl ctrlMapAnimAdd [0.8, 0.015, _callData#2];
	ctrlMapAnimCommit _mapControl;
}] call compile_Global;

["A3PL_Police_AttachCall",
{
	params [["_self",true,[true]]];
	private _display = findDisplay 95;
	private _control = _display displayCtrl 1501;
	if (lbCurSel _control isEqualTo -1) exitwith {[("STR_A3PL_Police_SelectCall" call A3PL_Localize),Color_Blue] call A3PL_Notification;};
	private _index = _control lbValue (lbCurSel _control);
	if (_index isEqualTo -1) exitwith {[("STR_A3PL_Police_SelectCall" call A3PL_Localize),Color_Blue] call A3PL_Notification;};

	private _units = _display displayCtrl 2105;
	private _targetUnit = if(_self) then {A3FL_Police_MDT} else {objectFromNetId (_units lbData (lbCurSel _units))};
	private _curCall = _targetUnit getVariable["CAD_Call",nil];
	private _callData = Server_Police_Dispatch#_index;
	private _detach = if(_targetUnit IN (_callData#4)) then {true} else {false};
	if(!isNil "_curCall" && {!_detach}) exitwith {[("STR_A3PL_Police_AlreadyAssigned" call A3PL_Localize),Color_Blue] call A3PL_Notification;};
	[_index,_targetUnit,_detach,player] remoteExecCall ["Server_Police_AttachDispatch",2];
	private _officer = _targetUnit getVariable["CAD_Ofc",""];
	if(_detach) then {
		if(_self) then {ctrlSetText [888, ("STR_A3PL_Police_AssignSelfToCall" call A3PL_Localize)]} else {ctrlSetText [889, ("STR_A3PL_Police_AssignToCall" call A3PL_Localize)]};
		if(_self) then {lbSetCurSel [2101, 0]};
		if(_self) then {_control lbSetColor [lbCurSel _control, [1, 1, 1, 1]]};
		_targetUnit setVariable["CAD_Status",("STR_Common_Available" call A3PL_Localize),true];
		_targetUnit setVariable["CAD_Call",nil,true];
		if(!_self) then {
			if(!isNull driver _targetUnit) then {
				[format[("STR_A3PL_Police_UnassignedFrom" call A3PL_Localize),_callData#1,_officer],Color_blue] remoteExec ["A3PL_Notification",driver _target];
			};
		};
	} else {
		if(_self) then {ctrlSetText [888, ("STR_A3PL_Police_Unassign" call A3PL_Localize)]} else {ctrlSetText [889, ("STR_A3PL_Police_Unassign" call A3PL_Localize)]};
		if(_self) then {lbSetCurSel [2101, 3]};
		if(_self) then {_control lbSetColor [lbCurSel _control, [0.5,0.5,0,1]]};
		_targetUnit setVariable["CAD_Status",("STR_A3PL_Police_EnRoute" call A3PL_Localize),true];
		_targetUnit setVariable["CAD_Call",_index,true];
		if(_self) then { [_callData#2] spawn A3PL_GPS_Navigate; };
		if(!_self) then {
			if(!isNull driver _targetUnit) then {
				[format[("STR_A3PL_Police_AssignedTo" call A3PL_Localize),_callData#1,_officer],Color_blue] remoteExec ["A3PL_Notification",driver _target];
			};
		};
	};
}] call compile_Global;

["A3PL_Police_InfoCall",
{
	private _display = findDisplay 95;
	private _control = _display displayCtrl 1501;
	if (lbCurSel _control isEqualTo -1) exitwith {[("STR_A3PL_Police_SelectCall" call A3PL_Localize),Color_Blue] call A3PL_Notification;};
	if(ctrlVisible 1107) then {
		ctrlShow [1106, true];
		ctrlShow [1107, false];
	};
	private _index = _control lbValue (lbCurSel _control);
	private _callData = Server_Police_Dispatch#_index;
	private _callInfo = _callData#3;
	private _callUnits = _callData#4;
	private _compileInfo = format[("STR_A3PL_Police_UnitsResponding" call A3PL_Localize),_callInfo, count(_callUnits)];
	{
		private ["_squad","_status","_color"];
		_squad = _x getVariable["CAD_Squad",("STR_A3PL_Police_Undefined" call A3PL_Localize)];
		_status = _x getVariable["CAD_Status",("STR_Common_Available" call A3PL_Localize)];
		_compileInfo = _compileInfo + format["    - %1 (%2)<br/>",_squad,_status];
	} forEach _callUnits;

	private _newstruct = format[("STR_A3PL_Police_DispatchDetails" call A3PL_Localize),(A3FL_Police_MDT getVariable ["CAD_Screen",""]),_compileInfo];
	A3FL_Police_MDT setVariable ["CAD_Screen",_newstruct,true];
	[_newstruct] call A3PL_Police_UpdateComputer;
}] call compile_Global;

["A3PL_Police_ResolveCall",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private _display = findDisplay 95;
	private _control = _display displayCtrl 1501;
	if (lbCurSel _control isEqualTo -1) exitwith {[("STR_A3PL_Police_SelectCall" call A3PL_Localize),Color_Blue] call A3PL_Notification;};
	private _index = _control lbValue (lbCurSel _control);
	[_index,A3FL_Police_MDT,player] remoteExecCall ["Server_Police_ResolveDispatch",2];
}] call compile_Global;

["A3PL_Police_GetStatusColor",
{
	params [["_status",""]];
	private _color = switch(_status) do {
		case ("STR_Common_Available" call A3PL_Localize): {[0,0.65,0,1]};
		case ("STR_A3PL_Police_Unavailable" call A3PL_Localize): {[0.75,0,0,1]};
		case ("STR_A3PL_Police_OnScene" call A3PL_Localize): {[0.12549019607,0.69803921568,0.66666666666,1]};
		case ("STR_A3PL_Police_EnRoute" call A3PL_Localize): {[0.5,0.5,0,1]};
		case ("STR_A3PL_Police_Occupied" call A3PL_Localize): {[1,0.8431372549,0,1]};
		case "PANIC": {[1,0,0,1]};
		default {[0.62,0.62,0.62,1]};
	};
	_color;
}] call compile_Global;

["A3PL_Police_GetSpecs",
{
	params [["_veh",objNull]];
	private _faction = if (isNil {_veh getVariable["CAD_Faction",nil]}) then {player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]} else {_veh getVariable["CAD_Faction",nil]};
	private _list = switch(_faction) do {
		case ("STR_Common_FISD" call A3PL_Localize): {["-","LAW ENF","HWY ENF","K9","ERT","UC","INT","MRTM","CMD"]};
		case ("STR_Common_FIFR" call A3PL_Localize): {["-","fifrvfd","FM","SR","FES","CMD","RT"]};
		case ("STR_Common_DOJ" call A3PL_Localize): {["-"]};
		case ("STR_Common_GOV" call A3PL_Localize): {["-"]};
		default {[]};
	};
	_list;
}] call compile_Global;

["A3PL_Police_GetDistricts",
{
	params [["_veh",objNull]];
	private _faction = if (isNil {_veh getVariable["CAD_Faction",nil]}) then {player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]} else {_veh getVariable["CAD_Faction",nil]};
	private _list = switch(_faction) do {
		case ("STR_Common_FISD" call A3PL_Localize): {["","Lincoln","Adam","Tango"]};
		case ("STR_Common_FIFR" call A3PL_Localize): {["","Elk","Silverton","Northdale",("STR_A3PL_Police_Airbase" call A3PL_Localize),("STR_A3PL_Police_TrainingCenter" call A3PL_Localize),("STR_A3PL_Police_Patrol" call A3PL_Localize)]};
		case ("STR_Common_DOJ" call A3PL_Localize): {[]};
		case ("STR_Common_GOV" call A3PL_Localize): {[]};
		default {[]};
	};
	_list;
}] call compile_Global;

["A3PL_Police_SetStatus",
{
	params ["_control","_selectedIndex","_self"];
	private _status = _control lbText _selectedIndex;
	private _callsign = ctrlText 1405;
	if(_self && {_callsign IN ["",("STR_A3PL_Police_Undefined" call A3PL_Localize)]}) exitWith {[("STR_A3PL_Police_EnterCallSign" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if(_self) then {
		A3FL_Police_MDT setVariable["CAD_Status",_status,true];
	} else {
		private _display = findDisplay 95;
		private _units = _display displayCtrl 2105;
		private _unitIdx = lbCurSel _units;
		if(_unitIdx isEqualTo -1) exitwith {};
		private _targetNetId = _units lbData _unitIdx;
		private _target = objectFromNetId _targetNetId;
		_target setVariable["CAD_Status",_status,true];
	};
}] call compile_Global;

["A3PL_Police_SetSpec",
{
	params ["_control","_selectedIndex"];
	private _spec = _control lbText _selectedIndex;
	private _callsign = ctrlText 1405;
	if(_callsign IN ["",("STR_A3PL_Police_Undefined" call A3PL_Localize)]) exitWith {[("STR_A3PL_Police_EnterCallSign" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	A3FL_Police_MDT setVariable["CAD_Spec",_spec,true];
}] call compile_Global;

["A3PL_Police_SetDistrict",
{
	params ["_control","_selectedIndex","_self"];
	private _district = _control lbText _selectedIndex;
	private _callsign = ctrlText 1405;
	if(_self && {_callsign IN ["",("STR_A3PL_Police_Undefined" call A3PL_Localize)]}) exitWith {[("STR_A3PL_Police_EnterCallSign" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if(_self) then {
		A3FL_Police_MDT setVariable["CAD_District",_district,true];
	} else {
		private _display = findDisplay 95;
		private _units = _display displayCtrl 2105;
		private _unitIdx = lbCurSel _units;
		if(_unitIdx isEqualTo -1) exitwith {};
		private _targetNetId = _units lbData _unitIdx;
		private _target = objectFromNetId _targetNetId;
		_target setVariable["CAD_District",_district,true];
	};
}] call compile_Global;

["A3PL_Police_SetCAD",
{
	private _callsign = ctrlText 1405;
	private _addinfo = ctrlText 1406;
	if(_callsign IN ["",("STR_A3PL_Police_Undefined" call A3PL_Localize)]) then {[("STR_A3PL_Police_EnterCallSign" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _csUsed = [_callsign,A3FL_Police_MDT] call A3PL_Police_isCallsignUsed;
	if(_csUsed) exitWith {[("STR_A3PL_Police_CallSignAlreadyUsed" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	A3FL_Police_MDT setVariable["CAD_Squad",_callsign,true];
	if(typeOf A3FL_Police_MDT IN ["A3PL_Pierce_Heavy_Ladder","A3PL_Pierce_Pumper","A3PL_Pierce_Rescue"]) then {
		private _numberArray = _callsign splitString "";
		private _TruckNumber2 = format ["\A3PL_FD\textures\Truck_Numbers\%1.paa", _numberArray#(count _numberArray-2)];
		private _TruckNumber3 = format ["\A3PL_FD\textures\Truck_Numbers\%1.paa", _numberArray#(count _numberArray-1)];
		A3FL_Police_MDT setObjectTextureGlobal [8, _TruckNumber2];
		A3FL_Police_MDT setObjectTextureGlobal [9, _TruckNumber3];
	};
	if(typeOf A3FL_Police_MDT IN ["A3PL_Silverado_FD_Brush","EC_F450_Brush"]) then {
		private _numberArray = _callsign splitString "";
		private _TruckNumber = format ["\A3PL_FD\textures\Truck_Numbers\%1.paa", _numberArray#(count _numberArray-1)];
		A3FL_Police_MDT setObjectTextureGlobal [8, _TruckNumber];
	};
	if(_addinfo isEqualTo "") then {_addinfo = ("STR_A3PL_Police_NoAdditionalInfo" call A3PL_Localize)};
	A3FL_Police_MDT setVariable["CAD_Info",_addinfo,true];
}] call compile_Global;

["A3PL_Police_isCallsignUsed",
{
	params[["_callsign",("STR_A3PL_Police_Undefined" call A3PL_Localize)],["_veh",objNull]];
	if(isNull _veh) exitwith {};
	private _faction = _veh getVariable["CAD_Faction","citizen"];
	private _isUsed = false;
	{
		if ((_x getVariable["CAD_On",false]) && {_x getVariable["CAD_Faction",""] isEqualTo _faction} && {!(underwater _x)} && {((_x getVariable["CAD_Squad","UNDEF"]) isEqualTo _callsign)} && {(_x isNotEqualTo _veh)}) exitwith {_isUsed = true;};
	} foreach vehicles;
	_isUsed;
}] call compile_Global;

["A3PL_Police_ClearMDT",
{
	for "_i" from 0 to 4 do {
		ctrlSetText [1400 + _i, ""];
	};
	if(!isNil "ClearCAD") then {
		A3FL_Police_MDT setVariable ["CAD_Screen","",true];
		[("STR_A3PL_Police_VehicleConnected" call A3PL_Localize)] call A3PL_Police_UpdateComputer;
		ClearCAD = nil;
	} else {
		ClearCAD = true;
		sleep 2.5;
		ClearCAD = nil;
	};
}] call compile_Global;

["A3PL_Police_MapMDT",
{
	if(ctrlVisible 1107) then {
		ctrlShow [1106, true];
		ctrlShow [1107, false];
	} else {
		ctrlShow [1106, false];
		ctrlShow [1107, true];
	};
}] call compile_Global;

["A3PL_Police_LoadUnits",
{
	params[["_faction",""]];
	private ["_ctrlMemory","_allUnits"];
	private _display = findDisplay 95;
	private _ctrlGrp = _display displayCtrl 960;
	_ctrlMemory = [];
	while{!isNull (findDisplay 95)} do {
		_allUnits = [];
		if(player getVariable["faction",""] isEqualTo "dispatch") then {
			{
				if ((_x getVariable["CAD_On",false]) && {!(underwater _x)}) then {_allUnits pushBack _x;};
			} foreach vehicles;
		} else {
			{
				if ((_x getVariable["CAD_On",false]) && {_x getVariable["CAD_Faction",""] isEqualTo _faction} && {!(underwater _x)}) then {_allUnits pushBack _x;};
			} foreach vehicles;
		};

		{ctrlDelete _x;} foreach _ctrlMemory;
		_ctrlMemory = [];

		{
			private ["_callsign","_status","_spec","_district","_ofc","_tmp","_statusColor"];
			_callsign = if(player getVariable["faction",""] isEqualTo "dispatch") then {format["[%1] %2",toUpper(_x getVariable["CAD_Faction",""]),_x getVariable["CAD_Squad",("STR_A3PL_Police_Undefined" call A3PL_Localize)]]} else {_x getVariable["CAD_Squad",("STR_A3PL_Police_Undefined" call A3PL_Localize)]};
			_status = _x getVariable["CAD_Status",("STR_A3PL_Police_Unavailable" call A3PL_Localize)];
			_spec = _x getVariable["CAD_Spec","-"];
			_district = _x getVariable["CAD_District",""];
			_statusColor = [_status] call A3PL_Police_GetStatusColor;
			_tmp = _display ctrlCreate ["UnitsList", -1, _ctrlGrp];
			_ctrlMemory pushback _tmp;
			_pos = ctrlPosition _tmp;
			_pos set [1, (_pos#1) + (_pos#3) * _forEachIndex];
			(_tmp controlsGroupCtrl 961) ctrlSetText _callsign;
			(_tmp controlsGroupCtrl 962) ctrlSetText _status;
			(_tmp controlsGroupCtrl 962) ctrlSetTextColor _statusColor;
			(_tmp controlsGroupCtrl 963) ctrlSetText _spec;
			(_tmp controlsGroupCtrl 964) ctrlSetText _district;
			_tmp ctrlAddEventHandler ["MouseButtonClick",format["['%1',true] call A3PL_Police_ShowInfo;",netId _x]];
			_tmp ctrlSetPosition _pos;
			_tmp ctrlCommit 0;
		} forEach _allUnits;
		sleep 2;
	};
}] call compile_Global;

["A3PL_Police_ShowInfo",
{
	params["_netIdVeh",["_fromList",false]];
	private _display = findDisplay 95;
	if(_fromList) exitWith {
		private _unitsSelect = _display displayCtrl 2105;
		for "_i" from 0 to (lbSize _unitsSelect)-1 do {
			if(_unitsSelect lbData _i isEqualTo _netIdVeh) exitwith {
				_unitsSelect lbSetCurSel _i;
			};
		};
	};
	private _veh = _netIdVeh call BIS_fnc_objectFromNetId;
	private	_ofc = _veh getVariable["CAD_Ofc",""];
	private _infoBox = _display displayCtrl 1109;
	private _addInfo = _veh getVariable["CAD_Info",("STR_A3PL_Police_NoAdditionalInfo" call A3PL_Localize)];
	private _call = _veh getVariable["CAD_Call",-1];
	private _callTitle = if(_call isNotEqualTo -1) then {format["<br/>Dispatch: %1",Server_Police_Dispatch#_call#1]} else {""};
	private _vehName = getText (configFile >> "CfgVehicles" >> typeOf _veh >> "displayName");
	_infoBox ctrlSetStructuredText parseText format["<t size='0.9'>%1<br/>%2%4<br/>%3</t>",_ofc,_addInfo,_vehName,_callTitle];
	[getPos _veh] call A3PL_Police_ShowUnit;
}] call compile_Global;

["A3PL_Police_ShowUnit",
{
	params["_pos"];
	ctrlShow [1106, false];
	private _display = findDisplay 95;
	private _mapControl = _display displayCtrl 1107;
	_mapControl ctrlShow true;
	_mapControl ctrlMapAnimAdd [0.8, 0.025, _pos];
	ctrlMapAnimCommit _mapControl;
}] call compile_Global;

["A3PL_Police_CloseMDT",
{
	private _fieldMemory = [];
	private _display = findDisplay 95;
	private _control = _display displayCtrl 2100;
	_fieldMemory pushback (lbCurSel _control);
	for "_i" from 0 to 4 do {
		_fieldMemory pushback (ctrlText (1400 + _i));
	};
	_fieldMemory pushback (ctrlVisible 1107);
	A3FL_Police_MDT setVariable["CAD_FieldMemory",_fieldMemory,true];
	A3FL_Police_MDT setVariable["CAD_InUse",false,true];
	A3FL_Police_MDT = nil;
}] call compile_Global;

["A3PL_Police_PanicMDT",
{
	closeDialog 0;
	private _faction = A3FL_Police_MDT getVariable["CAD_Faction",""];
	if (_faction IN ["",""]) exitWith {};
	private _panicCooldown = player getVariable ["panicCooldown",false];
	private _factionMembers = [_faction] call A3PL_Lib_FactionPlayers;
	if (_panicCooldown) exitWith {[("STR_A3PL_Police_PanicCooldown" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[A3FL_Police_MDT] remoteExec ["A3PL_Police_PanicMarker", _factionMembers];
	A3FL_Police_MDT setVariable["CAD_Status","PANIC",true];
	player setVariable ["panicCooldown",true,false];
	[_faction,("STR_A3PL_Police_FISDPanic" call A3PL_Localize),getPos player,("STR_A3PL_Police_FISDPanicMessage" call A3PL_Localize),("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
	sleep 180;
	player setVariable ["panicCooldown",false,false];
}] call compile_Global;

["A3PL_Police_ShutdownMDT",
{
	if(A3FL_Police_MDT getVariable ["CAD_Faction","citizen"] isNotEqualTo (player getVariable ["faction","citizen"])) exitWith {[("STR_A3PL_Police_CannotTurnOffMDT" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	A3FL_Police_MDT setVariable["CAD_On",nil,true];
	A3FL_Police_MDT setVariable["CAD_Faction",nil,true];
	A3FL_Police_MDT setVariable["CAD_Squad",nil,true];
	A3FL_Police_MDT setVariable["CAD_Ofc",nil,true];
	A3FL_Police_MDT setVariable["CAD_Status",nil,true];
	A3FL_Police_MDT setVariable["CAD_Spec",nil,true];
	A3FL_Police_MDT setVariable["CAD_Call",nil,true];
	A3FL_Police_MDT setVariable["CAD_FieldMemory",nil,true];
	A3FL_Police_MDT setVariable["CAD_Screen",nil,true];
	closeDialog 0;
}] call compile_Global;

["A3PL_Police_ExecuteMDT",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private _display = findDisplay 95;
	private _control = _display displayCtrl 2100;
	private _cmd = _control lbData (lbCurSel _control);
	private _inputs = [];
	private _faction = A3FL_Police_MDT getVariable ["CAD_Faction","citizen"];
	private _civCheck = !(player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]);
	private _cmdBlacklist = ["insertarrest","insertbolo","insertwarrant","insertwarning","insertticket","removebolo","removewarrant","removearrest"];
	if(_civCheck && {(_cmd in _cmdBlacklist)}) exitwith {[("STR_A3PL_Police_UnauthorizedCommands" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _allowedChars = toArray "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 ,:-";
	for "_i" from 0 to 4 do {
		_inputs pushBack ctrlText (1400 + _i);
	};
	private _errorCheck = false;
	{
		{
			if !(_x in _allowedChars) exitWith {_errorCheck = true;};
		} forEach (toArray _x);
	} forEach _inputs;
	if (_errorCheck) exitwith {[("STR_A3PL_Police_ErrorInCharacters" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _requiredInputs = [_cmd] call A3PL_Police_GetInputs;
	for "_i" from 0 to count(_requiredInputs)-1 do {
		if(_inputs#_i isEqualTo "") exitwith {_errorCheck=true;};
	};
	if (_errorCheck) exitwith {[("STR_A3PL_Police_FillAllRequiredFields" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	ctrlShow [1106,true];
	ctrlShow [1107,false];
	private _output = switch(_cmd) do {
		case "createcall": {
			private _selectedFaction = toLower(_inputs#0);
			if !(_selectedFaction IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize)]) exitWith {("STR_A3PL_Police_EnterValidInstitution" call A3PL_Localize);};
			private _callLocation = customWaypointPosition;
			if(_callLocation isEqualTo []) exitwith {("STR_A3PL_Police_SetGPSLocation" call A3PL_Localize)};
			[_selectedFaction,_inputs#1,_callLocation,_inputs#2,("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
			if(_selectedFaction isEqualTo _faction) then {[_faction] call A3PL_Police_GetCalls};
			format [("STR_A3PL_Police_DispatchCreated" call A3PL_Localize),_inputs#1];
		};
		case "cctv": {
			private _location = toUpper(_inputs#0);
			private _locationList = [
				["DOC",[4760.97,6114.37,0]],
				["SILVERTON",[2684.83,5512.44,0]],
				["ELK",[6124.47,7383.62,0]],
				["NORTHDALE",[10227.5,8537.29,0]]
			];
			private _selectedLocation = [];
			{
				if(_x#0 isEqualTo _location) exitwith {_selectedLocation=_x#1;};
			} forEach _locationList;
			if (_selectedLocation isEqualTo []) exitwith {("STR_A3PL_Police_EnterValidLocation" call A3PL_Localize)};
			[_selectedLocation] spawn A3PL_CCTV_Open;
		};
		case "lookup": {
			[player,_inputs#0,_cmd] remoteExec ["Server_Police_Database", 2];
			format [("STR_A3PL_Police_Database_PersonSearch" call A3PL_Localize),_inputs#0];
		};
		case "lookupvehicles": {
			[player,_inputs#0,_cmd] remoteExec ["Server_Police_Database", 2];
			format [("STR_A3PL_Police_Database_VehiclesSearch" call A3PL_Localize),_inputs#0];
		};
		case "lookupcvehicles": {
			[player,_inputs#0,_cmd] remoteExec ["Server_Police_Database", 2];
			format [("STR_A3PL_Police_Database_VehiclesSearch" call A3PL_Localize),_inputs#0];
		};
		case "lookuplicense": {
			[player,_inputs#0,_cmd] remoteExec ["Server_Police_Database", 2];
			format [("STR_A3PL_Police_Database_VehicleSearch" call A3PL_Localize),_inputs#0];
		};
		case "lookupcompany": {
			[player,_inputs#0,_cmd] remoteExec ["Server_Police_Database", 2];
			format [("STR_A3PL_Police_Database_PersonSearch" call A3PL_Localize),_inputs#0];
		};
		case "lookupaddress": {
			[player,_inputs#0,_cmd] remoteExec ["Server_Police_Database",2];
			format [("STR_A3PL_Police_Database_AddressSearch" call A3PL_Localize),_inputs#0];
		};
		case "lookupwarehouse": {
			[player,_inputs#0,_cmd] remoteExec ["Server_Police_Database",2];
			format [("STR_A3PL_Police_Database_WarehouseSearch" call A3PL_Localize),_inputs#0];
		};
		case "markstolen": {
			[player,_inputs#0,_cmd] remoteExec ["Server_Police_Database", 2];
			format[("STR_A3PL_Police_Database_MarkVehicleStolen" call A3PL_Localize),_inputs#0];
		};
		case "insertarrest": {
			private _issuedBy = player getVariable ["name",name player];
			[player,[_inputs#0,_inputs#1,_inputs#2,_issuedBy],_cmd] remoteExec ["Server_Police_Database", 2];
			format[("STR_A3PL_Police_Database_ArrestInsert" call A3PL_Localize),_inputs#0];
		};
		case "arrestlist": {
			[player,_inputs#0,_cmd] remoteExec ["Server_Police_Database", 2];
			format [("STR_A3PL_Police_Database_ArrestSearch" call A3PL_Localize),_inputs#0];
		};
		case "removearrest": {
			[player,[_inputs#0,_inputs#1],_cmd] remoteExec ["Server_Police_Database", 2];
			format[("STR_A3PL_Police_Database_ArrestDelete" call A3PL_Localize),_inputs#0];
		};
		case "insertreport": {
			private _issuedBy = player getVariable ["name",name player];
			[player,[_inputs#0,_inputs#1,_inputs#2,_issuedBy],_cmd] remoteExec ["Server_Police_Database", 2];
			format[("STR_A3PL_Police_Database_ReportInsert" call A3PL_Localize),_inputs#0];
		};
		case "insertwarning": {
			private _issuedBy = player getVariable ["name",name player];
			[player,[_inputs#0,_inputs#1,_inputs#2,_issuedBy],_cmd] remoteExec ["Server_Police_Database", 2];
			format[("STR_A3PL_Police_Database_WarningInsert" call A3PL_Localize),_inputs#0];
		};
		case "warninglist": {
			[player,_inputs#0,_cmd] remoteExec ["Server_Police_Database", 2];
			format[("STR_A3PL_Police_Database_WarningSearch" call A3PL_Localize),_inputs#0];
		};
		case "insertticket": {
			private _issuedBy = player getVariable ["name",name player];
			[player,[_inputs#0,_inputs#1,_inputs#2,_issuedBy],_cmd] remoteExec ["Server_Police_Database", 2];
			format[("STR_A3PL_Police_Database_FineInsert" call A3PL_Localize),_inputs#0];
		};
		case "ticketlist": {
			[player,_inputs#0,_cmd] remoteExec ["Server_Police_Database", 2];
			format [("STR_A3PL_Police_Database_FineSearch" call A3PL_Localize),_inputs#0];
		};
		case "insertwarrant": {
			private _issuedBy = player getVariable ["name",name player];
			[player,[_inputs#0,_inputs#1,_inputs#2,_issuedBy],_cmd] remoteExec ["Server_Police_Database", 2];
			format[("STR_A3PL_Police_Database_WarrantInsert" call A3PL_Localize),_inputs#0];
		};
		case "warrantlist": {
			[player,_inputs#0,_cmd] remoteExec ["Server_Police_Database", 2];
			format [("STR_A3PL_Police_Database_WarrantSearch" call A3PL_Localize),_inputs#0];
		};
		case "warrantinfo": {
			private _offset = (parseNumber (_inputs#1)) - 1;
			if (_offset < 0) then {
				("STR_A3PL_Police_Database_WarrantError" call A3PL_Localize);
			} else {
				[player,_inputs#0,_cmd,_offset] remoteExec ["Server_Police_Database", 2];
				format [("STR_A3PL_Police_Database_WarrantSearchID" call A3PL_Localize),_inputs#0];
			};
		};
		case "removewarrant": {
			private _offset = (parseNumber (_inputs#1)) - 1;
			if (_offset < 0) then {
				("STR_A3PL_Police_Database_WarrantError" call A3PL_Localize);
			} else {
				[player,_inputs#0,_cmd,_offset] remoteExec ["Server_Police_Database", 2];
				format [("STR_A3PL_Police_Database_WarrantDelete" call A3PL_Localize),_inputs#0];
			};
		};
		case "markfound": {
			[player,_inputs#0,_cmd] remoteExec ["Server_Police_Database", 2];
			format[("STR_A3PL_Police_Database_VehicleFound" call A3PL_Localize),_inputs#0];
		};
		case "stolenvehicles": {
			[player, [""], _cmd] remoteExec ["Server_Police_Database", 2];
			("STR_A3PL_Police_Database_VehicleStolen" call A3PL_Localize);
		};
		case "setcaution": {
			private _cautionDesc = _inputs#1;
			private _issuedBy = player getVariable ["name", name player];
			if (count(_cautionDesc) <= 3) exitWith {("STR_A3PL_Police_Database_InvalidDescription" call A3PL_Localize);};
			[player, [_issuedBy, _inputs#0, _cautionDesc], _cmd] remoteExec ["Server_Police_Database", 2];
			format [("STR_A3PL_Police_Database_NotesUpdate" call A3PL_Localize), _inputs#0];
		};
		case "clearcautions": {
			[player, [_inputs#0], _cmd] remoteExec ["Server_Police_Database", 2];
			format [("STR_A3PL_Police_Database_NotesClear" call A3PL_Localize), _inputs#0];
		};
		case "darknet": {
			[player,"",_cmd] remoteExec ["Server_Police_Database", 2];
		};
		case "bololist": {
			[player, "", _cmd] remoteExec ["Server_Police_Database", 2];
			("STR_A3PL_Police_Database_BOLOList" call A3PL_Localize);
		};
		case "insertbolo": {
			private _boloDesc = _inputs#0;
			if (count(_boloDesc) <= 8) exitWith {("STR_A3PL_Police_Database_InvalidDescription" call A3PL_Localize);};
			private _issuedBy = player getVariable ["name", name player];
			[player, [_issuedBy, _boloDesc], _cmd] remoteExec ["Server_Police_Database", 2];
			format [("STR_A3PL_Police_Database_BOLOInsert" call A3PL_Localize)];
		};
		case "removebolo": {
			private _boloID = _inputs#0;
			private _boloIDNum = parseNumber _boloID;
			if (!([_boloID] call A3PL_Police_IsStringNumber)) exitWith {("STR_A3PL_Police_Database_BOLOInvalidID" call A3PL_Localize);};
			[player, [_boloIDNum], _cmd] remoteExec ["Server_Police_Database", 2];
			format [("STR_A3PL_Police_Database_BOLODelete" call A3PL_Localize), _boloID];
		};
		case "revokelicense": {
			private _license = _inputs#1;
			private _command = [_faction] call A3PL_Government_isFactionLeader;
			if (_faction isEqualTo ("STR_Common_FIFR" call A3PL_Localize) && !_command) exitWith {("STR_A3PL_Police_Database_FIFRCommandOnly" call A3PL_Localize);};
			if ([_license] call A3PL_Config_LicenseExists) then {
				private _canRevoke = [_license,3] call A3PL_Config_GetLicenseData;
				private _pJob = player getVariable["faction","citizen"];
				if(_pJob IN _canRevoke) then {
					[player, [_inputs#0, _license], _cmd] remoteExec ["Server_Police_Database", 2];
					("STR_A3PL_Police_Database_LicenseRevoke" call A3PL_Localize);
				} else {
					format[("STR_A3PL_Police_Database_LicenseRevokeAccessDenied" call A3PL_Localize),_license];
				};
			} else {
				format[("STR_A3PL_Police_Database_LicenseUnknown" call A3PL_Localize),_license];
			};
		};
		case "renewlicense": {
			private _license = toLower (_inputs#1);
			if([_license] call A3PL_Config_LicenseExists) then {
				private _canRenew = [_license,2] call A3PL_Config_GetLicenseData;
				private _pJob = player getVariable["faction","citizen"];
				if(_pJob IN _canRenew) then {
					[player, [_inputs#0, _license], _cmd] remoteExec ["Server_Police_Database", 2];
					("STR_A3PL_Police_Database_LicenseRenew" call A3PL_Localize);
				} else {
					format[("STR_A3PL_Police_Database_LicenseRenewAccessDenied" call A3PL_Localize),_license];
				};
			} else {
				format[("STR_A3PL_Police_Database_LicenseUnknown" call A3PL_Localize),_license];
			};
		};
		case "viewlicense": {
			private _license = toLower (_inputs#0);
			if([_license] call A3PL_Config_LicenseExists) then {
				private _canRenew = [_license,2] call A3PL_Config_GetLicenseData;
				private _pJob = player getVariable["faction","citizen"];
				if(_pJob IN _canRenew) then {
					[player, _license, _cmd] remoteExec ["Server_Police_Database", 2];
					format[("STR_A3PL_Police_Database_LicenseHolders" call A3PL_Localize),toUpper(_license)];
				} else {
					format[("STR_A3PL_Police_Database_LicenseHoldersAccessDenied" call A3PL_Localize),toUpper(_license)];
				};
			} else {
				format[("STR_A3PL_Police_Database_LicenseUnknown" call A3PL_Localize),_license];
			};
		};
		case "doclockdown": {
			call A3PL_Prison_Lockdown;
			("STR_A3PL_Police_Database_EmergencySystemActivated" call A3PL_Localize);
		};
		case "evidencelock": {
			private _isLead = [("STR_Common_FISD" call A3PL_Localize)] call A3PL_Government_isFactionLeader;
			if (!_isLead) exitwith {("STR_A3PL_Police_Database_EvidenceLockerUnlockError" call A3PL_Localize);};
			private _station = _inputs#0;
			if !(_station IN ["DOC","Silverton","Elk","Northdale"]) exitWith {("STR_A3PL_Police_Database_EvidenceLockerUnlockUnknown" call A3PL_Localize);};
			private _boxObj = switch(_station) do {
				case "DOC": {A3FL_Seize_Storage};
				case "Silverton": {evidence_box_svt};
				case "Elk": {evidence_box_elk};
				case "Northdale": {evidence_box_nd};
			};
			if(isNull _boxObj) exitwith {("STR_A3PL_Police_UnknownSystemError" call A3PL_Localize)};
			if(_boxObj getVariable["locked",true]) then {
				_boxObj setVariable["locked",false,true];
				format[("STR_A3PL_Police_Database_EvidenceLockerUnlock" call A3PL_Localize),_station];
			} else {
				_boxObj setVariable["locked",true,true];
				format[("STR_A3PL_Police_Database_EvidenceLockerLock" call A3PL_Localize),_station];
			};
		};
		case "lookpatient": {
			[player,_inputs#0,_cmd] remoteExec ["Server_Police_Database", 2];
			format [("STR_A3PL_Police_Database_PatientLookup" call A3PL_Localize),_inputs#0];
		};
		case "sendcall": {
			["A3PL_Common\effects\firecall.ogg",150,2,10] spawn A3PL_FD_FireStationAlarm;
			("STR_A3PL_Police_Database_AlarmTriggered" call A3PL_Localize);
		};
		case "wind": {format [("STR_A3PL_Police_Database_WindDirection" call A3PL_Localize),[windDir] call A3PL_Lib_GetHeading];};
		case "showhydrant": {
			[] spawn A3PL_FD_ShowHydrant;
			ctrlShow [1106, false];
			private _display = findDisplay 95;
			private _mapControl = _display displayCtrl 1107;
			_mapControl ctrlShow true;
			_mapControl ctrlMapAnimAdd [1, 0.03, getPos player];
			ctrlMapAnimCommit _mapControl;
			("STR_A3PL_Police_DataBase_HydrantsOnMap" call A3PL_Localize);
		};
		case "clinic": {
			[] remoteExec ["Server_FD_SwitchClinic",2];
			if(A3PL_FD_Clinic) then {
				("STR_A3PL_Police_Database_ClinicClosed" call A3PL_Localize);
			} else {
				("STR_A3PL_Police_Database_ClinicOpened" call A3PL_Localize);
			};
		};
		case "callvfd": {
			[_inputs#0,0,""] spawn A3PL_FD_Beeper;
			format [("STR_A3PL_Police_Database_VFDPager" call A3PL_Localize)];
		};
		case "callpro": {
			[_inputs#0,1,_inputs#1] spawn A3PL_FD_Beeper;
			format [("STR_A3PL_Police_Database_FIFRPager" call A3PL_Localize)];
		};
		case "callallpro": {
			[_inputs#0,2,""] spawn A3PL_FD_Beeper;
			format [("STR_A3PL_Police_Database_FIFRPager" call A3PL_Localize)];
		};
		case "callall": {
			[_inputs#0,2,""] spawn A3PL_FD_Beeper;
			format [("STR_A3PL_Police_Database_GlobalPager" call A3PL_Localize)];
		};
		case "lookhistory": {
			[player,_inputs#0,_cmd] remoteExec ["Server_Police_Database", 2];
			format [("STR_A3PL_Police_Database_MedicalRecordLookup" call A3PL_Localize),_inputs#0];
		};
		case "addhistory":
		{
			private _issuedBy = player getVariable ["name",name player];
			[player,[_inputs#0,_inputs#1,_inputs#2,_issuedBy],_cmd] remoteExec ["Server_Police_Database", 2];
			format[("STR_A3PL_Police_Database_MedicalRecordAdd" call A3PL_Localize),_inputs#0];
		};
		case "clearfires": {
			private _isCommand = [("STR_Common_FIFR" call A3PL_Localize)] call A3PL_Government_isFactionLeader;
			if (_isCommand) then {
				call A3PL_Admin_RemoveFire;
				("STR_A3PL_Police_Database_FireSuppression" call A3PL_Localize);
			} else {
				("STR_A3PL_Police_Database_FIFRCommandOnly" call A3PL_Localize);
			};
		};
		case "pausefires": {
			private _isCommand = [("STR_Common_FIFR" call A3PL_Localize)] call A3PL_Government_isFactionLeader;
			if (_isCommand) then {
				[] remoteExec ["Server_Fire_PauseFire", 2];
				if (Server_FireLooping) then {
					("STR_A3PL_Police_Database_FireSpreadResumed" call A3PL_Localize);
				} else {
					("STR_A3PL_Police_Database_FireSpreadPaused" call A3PL_Localize);
				};
			} else {
				("STR_A3PL_Police_Database_FIFRCommandOnly" call A3PL_Localize);
			};
		};
		default {"Unknown command"};
	};

	_newstruct = format["%1<br />%2",(A3FL_Police_MDT getVariable ["CAD_Screen",""]),_output];
	A3FL_Police_MDT setVariable ["CAD_Screen",_newstruct,true];
	[_newstruct] call A3PL_Police_UpdateComputer;
}] call compile_Global;

['A3PL_Police_UpdateComputer',
{
	params[["_input","",[""]]];
	private _display = findDisplay 95;
	private _control = _display displayCtrl 1105;
	private _controlPos = ctrlPosition _control;
	private _array = [_input, "<br />"] call CBA_fnc_split;
	if(count _array > 50) then {
		private _remove = (count _array) - 50;
		for "_i" from 0 to _remove-1 do {
			_array deleteAt 0;
		};
	};
	private _text = [_array, "<br />"] call CBA_fnc_join;
	A3FL_Police_MDT setVariable ["CAD_Screen",_text,true];
	_control ctrlSetStructuredText parseText _text;

	_newH = ctrlTextHeight _control;
	_control ctrlSetPosition [_controlPos#0, _controlPos#1, _controlPos#2, _newH];
	_control ctrlCommit 0;

	private _ctrlGrp = _display displayCtrl 1106;
	_ctrlGrp ctrlSetAutoScrollSpeed 0.000001;
	_ctrlGrp ctrlSetAutoScrollDelay 0.000001;
}] call compile_Global;

['A3PL_Police_IsStringNumber',
{
	params[["_str","0"]];
	{
		if (!(_x isEqualTo "0") && (parseNumber _x isEqualTo 0)) exitWith {true};
	} count (_str splitString "") isEqualTo 0;
}] call compile_Global;

['A3PL_Police_DatabaseEnterReceive',
{
	disableSerialization;
	params["_name","_command",["_return",""]];
	private _output = "";
	switch (_command) do {
		case "lookup":
		{
			if (count _return > 0) then
			{
				_warrantCount = ("STR_Common_No" call A3PL_Localize);
				if ((_return select 2) > 0) then {
					_warrantCount = format["<t color='#ff0000'>%1</t>",("STR_Common_Yes" call A3PL_Localize)];
				};
				_cautionStr = "";
				if ((count(_return select 9)) >= 3) then {
					_cautionStr = format[("STR_A3PL_Police_Database_CautionNote" call A3PL_Localize), _return select 9];
				};
				_licensesStr = "";
				{
					if((_x#0) isNotEqualTo "gang") then {
						_licensesStr = if(_licensesStr isEqualTo "") then {
							format ["<br/>%1 - %2 - %3", [_x#0,0] call A3PL_Config_GetLicenseData, _x#1, _x#3]
						} else {
							format ["%1<br/>%2 - %3 - %4",_licensesStr,[_x#0,0] call A3PL_Config_GetLicenseData, _x#1, _x#3]
						};
					};
				} foreach (_return select 12);
				if(_licensesStr isEqualTo "") then {_licensesStr = ("STR_A3PL_Police_Database_NoLicenses" call A3PL_Localize);};

				_employment = (_return select 11);
				if(_employment isEqualTo "none") then {
					if((_return select 10) IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) then {
						_employment = toUpperANSI(_return select 10);
					} else {
						_employment = ("STR_Common_Job_Unemployed" call A3PL_Localize);
					};
				};

				_output = format [("STR_A3PL_Police_Database_CriminalRecord" call A3PL_Localize),
				_name,
				(_return select 0),
				(_return select 1),
				_warrantCount,
				(_return select 5),
				(_return select 4),
				(_return select 3),
				(_return select 6),
				(_return select 7),
				_licensesStr,
				[(_return select 8), 1, 0, true] call CBA_fnc_formatNumber,
				_employment,
				_cautionStr
				];
			} else
			{
				_output = format [("STR_A3PL_Police_Database_NoResults" call A3PL_Localize),_name];
			};
		};
		case "lookupvehicles":
		{
			if (count _return > 0) then
			{
				{
					_vehName = getText(configFile >>  "CfgVehicles" >>  _x select 1 >> "displayName");
					_stolen = ("STR_Common_No" call A3PL_Localize);
					if ((_x select 2) == 1) then
					{
						_stolen = format["<t color='#ff0000'>%1</t>",("STR_Common_Yes" call A3PL_Localize)];
					};

					_output = _output + (format [("STR_A3PL_Police_Database_VehicleInfo" call A3PL_Localize),_forEachIndex+1,_x select 0,_vehName,_stolen]);
				} foreach _return;
				_output = (_output + ("STR_A3PL_Police_Database_VehicleInfo_End" call A3PL_Localize));
			} else
			{
				_output = format [("STR_A3PL_Police_Database_VehicleInfo_NoResults" call A3PL_Localize)];
			};
		};
		case "lookuplicense":
		{
			if(count _return > 1) then {
				private _name = _return select 0;
				private _class = _return select 2;
				private _insured = _return select 3;
				private _plate = _return select 6;
				private _info = _return select 7;
				private _isInsured = ("STR_Common_Yes" call A3PL_Localize);
				private _vehName = getText(configFile >>  "CfgVehicles" >>  _class >> "displayName");
				private _stolen = if ((_return select 1) > 0) then {format["<t color='#ff0000'>%1</t>",("STR_Common_Yes" call A3PL_Localize)]} else {("STR_Common_No" call A3PL_Localize)};
				private _insured = if(_insured isEqualTo 0) then {("STR_Common_No" call A3PL_Localize)} else {("STR_Common_Yes" call A3PL_Localize)};
				_output = format[("STR_A3PL_Police_Database_PlateInfo" call A3PL_Localize),_plate,_name,_vehName,_stolen,_insured,_info];
				if(count(_return) isEqualTo 9) then {
					_output = _output + format[("STR_A3PL_Police_Database_CompanyVehicleInfo" call A3PL_Localize),_return select 8];
				};
			} else {
				_output = format [("STR_A3PL_Police_Database_PlateInfo_NoResults" call A3PL_Localize),_return select 0];
			};
		};
		case "lookupcompany":
		{
			if(count _return > 1) then {
				_name = _return select 0;
				_desc = _return select 1;
				_boss = _return select 2;
				_bank = _return select 3;
				_licensesStr = "";
				{
					_licensesStr = if(_licensesStr isEqualTo "") then {
						format ["<br/>%1", [_x,0] call A3PL_Config_GetLicenseData]
					} else {
						format ["%1<br/>%2",_licensesStr,[_x,0] call A3PL_Config_GetLicenseData]
					};
				} foreach (_return select 4);
				if(_licensesStr isEqualTo "") then {_licensesStr = ("STR_A3PL_Police_Database_CompanyNoLicenses" call A3PL_Localize);};

				_output = format[("STR_A3PL_Police_Database_CompanyInfo" call A3PL_Localize),_name,_desc,_boss,[_bank, 1, 0, true] call CBA_fnc_formatNumber,_licensesStr];
			} else {
				_output = format [("STR_A3PL_Police_Database_CompanyInfo_NoResults" call A3PL_Localize),_name];
			};
		};
		case "lookupaddress":
		{
			private _house = parseSimpleArray(_return#0);
			private _name = _return#1;
			if(!isNil "_house") then {
				[_house, _name] spawn A3PL_Police_MarkHouse;
				ctrlShow [1106, false];
				private _display = findDisplay 95;
				private _mapControl = _display displayCtrl 1107;
				_mapControl ctrlShow true;
				_mapControl ctrlMapAnimAdd [1, 0.03, _house];
				ctrlMapAnimCommit _mapControl;
				"";
			} else {
				_output = ("STR_A3PL_Police_Database_NoAddressFound" call A3PL_Localize);
			};
		};
		case "lookupwarehouse":
		{
			private _warehouse = parseSimpleArray(_return#0);
			private _name = _return#1;
			if(!isNil "_warehouse") then {
				[_warehouse, _name,true] spawn A3PL_Police_MarkHouse;
				ctrlShow [1106, false];
				private _display = findDisplay 95;
				private _mapControl = _display displayCtrl 1107;
				_mapControl ctrlShow true;
				_mapControl ctrlMapAnimAdd [1, 0.03, _warehouse];
				ctrlMapAnimCommit _mapControl;
				"";
			} else {
				_output = ("STR_A3PL_Police_Database_NoAddressFound" call A3PL_Localize);
			};
		};
		case "markstolen": {_output = _return;};
		case "markfound": {_output = _return;};
		case "warrantlist":
		{
			if (count _return > 0) then
			{
				{
					_output = _output + (format [("STR_A3PL_Police_Database_WarrantList" call A3PL_Localize),_forEachIndex+1,_x select 0,_x select 1,_x select 2]);
				} foreach _return;
				_output = (_output + ("STR_A3PL_Police_Database_WarrantList_End" call A3PL_Localize));
			} else
			{
				_output = format [("STR_A3PL_Police_Database_WarrantList_NoResults" call A3PL_Localize),_name];
			};
		};
		case "warrantinfo":
		{
			if (count _return > 0) then {
				_output = format [("STR_A3PL_Police_Database_WarrantInfo" call A3PL_Localize),_name,_return select 0,_return select 1,_return select 2];
			} else {
				_output = format [("STR_A3PL_Police_Database_WarrantInfo_NoResults" call A3PL_Localize),_name];
			};
		};
		case "removewarrant": {_output = _return;};
		case "ticketlist":
		{
			if (count _return > 0) then {
				{
					_output = _output + (format [("STR_A3PL_Police_Database_TicketList" call A3PL_Localize),_x select 0,_x select 1,_x select 2,_x select 3]);
				} foreach _return;
				_output = _output;
			} else {
				_output = format [("STR_A3PL_Police_Database_TicketList_NoResults" call A3PL_Localize),_name];
			};
		};
		case "arrestlist":
		{
			if (count _return > 0) then {
				{
					_output = _output + (format [("STR_A3PL_Police_Database_ArrestList" call A3PL_Localize),_x select 0,_x select 1,_x select 2,_x select 3]);
				} foreach _return;
				_output = _output;
			} else {
				_output = format [("STR_A3PL_Police_Database_ArrestList_NoResults" call A3PL_Localize),_name];
			};
		};
		case "removearrest": {_output = _return;};
		case "warninglist":
		{
			if (count _return > 0) then
			{
				{
					_output = _output + (format [("STR_A3PL_Police_Database_WarningList" call A3PL_Localize),_x select 0,_x select 1,_x select 2]);
				} foreach _return;
				_output = _output;
			} else
			{
				_output = format [("STR_A3PL_Police_Database_WarningList_NoResults" call A3PL_Localize),_name];
			};
		};
		case "insertwarrant": {_output = _return;};
		case "insertticket": {_output = _return;};
		case "insertwarning": {_output = _return;};
		case "insertreport": {_output = _return;};
		case "insertarrest": {_output = _return;};
		case "lookupcvehicles":
		{
			if (count _return > 0) then
			{
				{
					_vehName = getText(configFile >>  "CfgVehicles" >>  _x select 1 >> "displayName");
					_stolen = ("STR_Common_No" call A3PL_Localize);
					if ((_x select 2) == 1) then
					{
						_stolen = format["<t color='#ff0000'>%1</t>",("STR_Common_Yes" call A3PL_Localize)];
					};

					_output = _output + (format [("STR_A3PL_Police_Database_VehicleInfo" call A3PL_Localize),_forEachIndex+1,_x select 0,_vehName,_stolen]);
				} foreach _return;
				_output = (_output + ("STR_A3PL_Police_Database_VehicleInfo_End" call A3PL_Localize));
			} else
			{
				_output = format [("STR_A3PL_Police_Database_VehicleInfo_NoResults" call A3PL_Localize)];
			};
		};
		case "darknet":
		{
			if (count _return > 0) then
			{
				{
					_output = _output + (format [("STR_A3PL_Police_Database_DarknetLogs" call A3PL_Localize),_x select 0,_x select 1]);
				} foreach _return;
			} else {
				_output = ("STR_A3PL_Police_Database_DarknetLogs_NoResults" call A3PL_Localize);
			};
		};
		case "setcaution": {_output = _return;};
		case "clearcautions": {_output = _return;};
		case "bololist":
		{
			if (count _return > 0) then {
				{
					_output = _output + (format [("STR_A3PL_Police_Database_BOLOListReturn" call A3PL_Localize), _x select 0, _x select 2, _x select 1, _x select 3]);
				} foreach _return;
				_output = _output;
			} else {
				_output = format [("STR_A3PL_Police_Database_BOLOList_NoResults" call A3PL_Localize)];
			};
		};
		case "insertbolo": {_output = _return;};
		case "removebolo": {_output = _return;};
		case "stolenvehicles":
		{
			if (count _return > 0) then
			{
				{
					_vehName = getText(configFile >>  "CfgVehicles" >>  _x select 2 >> "displayName");
					_output = _output + (format [("STR_A3PL_Police_Database_StolenVehicleList" call A3PL_Localize), _forEachIndex+1, _x select 1, _vehName, _x select 3]);
				} foreach _return;
				_output = (_output + ("STR_A3PL_Police_Database_VehicleInfo_End" call A3PL_Localize));
			} else
			{
				_output = format [("STR_A3PL_Police_Database_StolenVehicleList_NoResults" call A3PL_Localize)];
			};
		};
		case "revokelicense": {_output = _return;};
		case "renewlicense": {_output = _return;};
		case "viewlicense": {
			if ((count _return) > 0) then {
				private _data = "<t align='center'>";
				{
					_data = _data + format["%1<br/>",_x];
				} foreach _return;
				_data = _data + "</t>";
				_output = _data;
			} else {
				_output = ("STR_A3PL_Police_Database_LicensesHolders_NoResults" call A3PL_Localize);
			};
		};
		case "lookpatient": {
			if ((count _return) > 0) then {
				_output = format [("STR_A3PL_Police_Database_PatientInfo" call A3PL_Localize),(_return select 2),(_return select 0),(_return select 1),(_return select 3)];
			} else {
				_output = format [("STR_A3PL_Police_Database_NoResults" call A3PL_Localize),_name];
			};
		};
		case "lookhistory": {
			if ((count _return) > 0) then {
				private _data = "";
				{
					_data = _data + (format [("STR_A3PL_Police_Database_MedicalRecord" call A3PL_Localize),_x select 5,_x select 3,_x select 2,_x select 4]);
				} foreach _return;
				_output = _data;
			} else {
				_output = format [("STR_A3PL_Police_Database_MedicalRecord_NoResults" call A3PL_Localize),_name];
			};
		};
		case "addhistory": {_output=_return;};
		default {_output = ("STR_A3PL_Police_Database_InvalidCommand" call A3PL_Localize);};
	};
	private _newstruct = format["%1<br />%2",(A3FL_Police_MDT getVariable "CAD_Screen"),_output];
	A3FL_Police_MDT setVariable ["CAD_Screen",_newstruct,true];
	[_newstruct] call A3PL_Police_UpdateComputer;
}] call compile_Global;

["A3FL_Police_LegCuff",
{
	params [["_person", objNull, [objNull]]];
	private _isLegCuffed = _person getVariable ["LegCuffed",false];

	if(_isLegCuffed) exitWith {
		_person setVariable["LegCuffed",false];
		_person forceWalk false;
		[("STR_A3PL_Police_RemoveLegCuffs" call A3PL_Localize),Color_green] remoteExec ["A3PL_Notification",_person];
	};

	_person setVariable["LegCuffed",true];
	_person forceWalk true;
	[("STR_A3PL_Police_LegCuffsOn" call A3PL_Localize),Color_red] remoteExec ["A3PL_Notification",_person];
}] call compile_Global;

["A3FL_Police_CheckSeatBelt",
{
    private _veh = param [0,objNull];

    if(isNull driver _veh) exitWith {["Whaaaaa???",Color_Yellow] call A3PL_Notification;};

    private _driver = driver _veh;
    private _hasSeatbelt = _driver getVariable["SeatbeltOn",false];

    if(_hasSeatbelt) then {
        [("STR_A3PL_Police_SeatbeltOn" call A3PL_Localize),Color_Green] call A3PL_Notification;
    } else {
        [("STR_A3PL_Police_SeatbeltOff" call A3PL_Localize),Color_Red] call A3PL_Notification;
    };
}] call compile_Global;

["A3FL_Police_RemoveFakePlate", {
	params [
		["_veh",objNull,[objNull]]
	];
	private _hasFakePlate = _veh getVariable ["isFakePlate",false];
	if (!_hasFakePlate) exitWith {[("STR_A3PL_Police_NoFakePlateOn" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if (Player_ActionDoing) exitWith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[("STR_A3PL_Police_RemovingFakePlate" call A3PL_Localize),PD_Remove_Fake_Plate_Time] spawn A3PL_Lib_LoadAction;
	waitUntil {Player_ActionDoing};
	player playMoveNow 'Acts_carFixingWheel';
	while {Player_ActionDoing} do {
		if ((player distance2D _veh) > 5) exitwith {Player_ActionInterrupted = true};
        if (!(player getVariable["A3PL_Medical_Alive",true])) exitWith {Player_ActionInterrupted = true;};
        if ((vehicle player) != player) exitwith {Player_ActionInterrupted = true;};
        if (player getVariable ["Incapacitated",false]) exitwith {Player_ActionInterrupted = true;};
        if ((animationstate player) != "Acts_carFixingWheel") then {player playMoveNow 'Acts_carFixingWheel';};
	};

	[player,""] remoteExec ["A3PL_Lib_SyncAnim",0];
	if (Player_ActionInterrupted) exitWith {[("STR_Common_ActionInterrupted" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _originalLP = (_veh getVariable ["owner",[]])#1;
	[_originalLP,_veh] remoteExec ["Server_Vehicle_Init_SetLicensePlate",2];
	[("STR_A3PL_Police_RemovedFakePlate" call A3PL_Localize),Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Police_ReachForFirearm", {
	params["_target","_user"];
	if(_target getVariable ["pVar_RedNameOn",false]) exitWith {};
	private _chance = random 100;

	_pistol = handgunWeapon _target;

	if (_pistol isEqualTo "") exitwith {
		[("STR_A3PL_Police_NoWeapon" call A3PL_Localize),Color_Red] remoteExec ["A3PL_Notification",_user];
	};

	// Check if user has the pickpocket trait
	private _traits = _user getVariable ["Player_Traits", []];
	private _hasPickpocketTrait = "pickpocket" in _traits;

	// Pickpocket trait: 20% less chance to alert
	private _alertThreshold = PD_Reach_For_Firearm_ChanceAlert;
	if (_hasPickpocketTrait) then {
		_alertThreshold = _alertThreshold + 20;
	};

	if ((_pistol != "") && (_chance >= _alertThreshold)) then {
		[("STR_A3PL_Police_TryingToTakeWeapon" call A3PL_Localize),Color_Orange] remoteExec ["A3PL_Notification",_target];
	};

	[("STR_A3PL_Police_RetrievingWeapon" call A3PL_Localize),Reach_For_Firearm_Timer] spawn A3PL_Lib_LoadAction;
	waitUntil{Player_ActionDoing};
	[_user,"Acts_TerminalOpen"] remoteExec ["A3PL_Lib_SyncAnim",0];
	while {Player_ActionDoing} do {
		if (!(_user getVariable["A3PL_Medical_Alive",true])) exitWith {Player_ActionInterrupted=true;};
		if ((vehicle _user) != _user) exitwith {Player_ActionInterrupted=true;};
		if (_user getVariable ["Incapacitated",false]) exitwith {Player_ActionInterrupted=true;};
	};
	if(Player_ActionInterrupted) exitWith {[("STR_Common_ActionInterrupted" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if (_chance >= PD_Reach_For_Firearm_ChanceSuccess) then {
		if (_pistol != "") then {
			_user addWeapon _pistol;
			_target removeWeapon _pistol;
		}; 
		[("STR_A3PL_Police_RetrievedWeapon" call A3PL_Localize),Color_Green] remoteExec ["A3PL_Notification",_user];
		[("STR_A3PL_Police_WeaponTaken" call A3PL_Localize),Color_Green] remoteExec ["A3PL_Notification",_target];
	} else {
		[("STR_A3PL_Police_FailedToRetrieveWeapon" call A3PL_Localize)] remoteExec ["A3PL_Notification",_user];
		[("STR_A3PL_Police_FailedWeaponTaken" call A3PL_Localize)] remoteExec ["A3PL_Notification",_target];
	};

}] call compile_Global;