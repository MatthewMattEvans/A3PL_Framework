/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Prison_HandleDoor",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private _jail = param [0,objNull];
	private _name = param [1,""];
	private _factionReq = !((count([("STR_Common_FISD" call A3PL_Localize)] call A3PL_Lib_FactionPlayers)) >= PD_Prison_FactionRequired_Keycard);
	private _faction = player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] IN [("STR_Common_FISD" call A3PL_Localize)];
	if(!(_faction) && _factionReq && (["keycard",1] call A3PL_Inventory_Has)) exitwith {[format[("STR_A3PL_Prison_NotEnoughFISDToUseAccessCard" call A3PL_Localize),PD_Prison_FactionRequired_Keycard],Color_Red] call A3PL_Notification;};

	if (_name IN ["door_20","door_21"]) exitwith {[_jail,_name,false] call A3PL_Lib_ToggleAnimation;};
	if (_name IN
	[
		"door_1_button","door_1_button2","door_2_button","door_2_button2","door_3_button","door_3_button2",
		"door_4_button","door_4_button2","door_5_button","door_5_button2","door_6_button","door_6_button2",
		"door_7_button","door_7_button2","door_8_button","door_8_button2","door_9_button","door_9_button2",
		"door_10_button","door_10_button2","door_11_button","door_11_button2","door_12_button","door_12_button2",
		"door_13_button","door_13_button2","door_14_button","door_14_button2","door_15_button","door_15_button2",
		"door_16_button","door_16_button2","door_22_button","door_22_button2","door_23_button","door_23_button2","door_24_button","door_25_button","door_26_button"
	]) exitwith { _name = _name select [0,(_name find "_button")]; [_jail,_name,false] call A3PL_Lib_ToggleAnimation;};
	if (_name IN
	[
		"console_cell1","console_cell2","console_cell3","console_cell4","console_cell5","console_cell6","console_cell7","console_cell8","console_cell9","console_cell10","console_cell11","console_cell12","console_cell13","console_cell14",
		"console_maincell1","console_maincell2","console_maincell3",
		"console_garage"
	]) exitwith
	{
		private ["_anim","_hSel"];
		_anim = "";
		_hSel = -1;
		switch (_name) do
		{
			case ("console_cell1"): {_anim = "cell_door_1"; _hSel = 0;};
			case ("console_cell2"): {_anim = "cell_door_2"; _hSel = 1;};
			case ("console_cell3"): {_anim = "cell_door_3"; _hSel = 2;};
			case ("console_cell4"): {_anim = "cell_door_4"; _hSel = 3;};
			case ("console_cell5"): {_anim = "cell_door_5"; _hSel = 4;};
			case ("console_cell6"): {_anim = "cell_door_6"; _hSel = 5;};
			case ("console_cell7"): {_anim = "cell_door_7"; _hSel = 6;};
			case ("console_cell8"): {_anim = "cell_door_8"; _hSel = 7;};
			case ("console_cell9"): {_anim = "cell_door_9"; _hSel = 8;};
			case ("console_cell10"): {_anim = "cell_door_10"; _hSel = 9;};
			case ("console_cell11"): {_anim = "cell_door_11"; _hSel = 10;};
			case ("console_cell12"): {_anim = "cell_door_12"; _hSel = 11;};
			case ("console_cell13"): {_anim = "cell_door_13"; _hSel = 12;};
			case ("console_cell14"): {_anim = "cell_door_14"; _hSel = 13;};
			case ("console_maincell1"): {_anim = "door_19"; _hSel = 15;};
			case ("console_maincell2"): {_anim = "door_18"; _hSel = 16;};
			case ("console_maincell3"): {_anim = "door_17"; _hSel = 17;};
			case ("console_garage"): {_anim = "door_23"; _hSel = 14;};
		};
		playSound3D ["A3FL_Buildings\Data\OpenBuzz.wav", _jail, true, getPosASL _jail, 3, 1, 200];
		if (_jail animationPhase _anim < 0.5) then {
			_jail setObjectTextureGlobal [_hSel,"#(argb,8,8,3)color(0,1,0,1.0,co)"];
			[_jail,_anim,false,1] call A3PL_Lib_ToggleAnimation;
		} else {
			_jail setObjectTextureGlobal [_hSel,"#(argb,8,8,3)color(1,0,0,1.0,co)"];
			[_jail,_anim,false,0] call A3PL_Lib_ToggleAnimation;
		};
	};
	if (_name isEqualTo "console_lockdown") exitwith {
		call A3PL_Prison_Lockdown;
	};
}] call compile_Global;

["A3PL_Prison_Lockdown",
{
	private _pos = getPos player;
	private _jail = (nearestObjects [_pos, ["Land_A3PL_Prison"], 1000])#0;
	private _gate = (nearestObjects [_pos, ["Land_A3FL_DOC_Gate"], 1000])#0;
	private _wh = (nearestObjects [_pos, ["Land_A3FL_DOC_Warehouse"], 1000])#0;
	private _cooldown = _jail getVariable["lockdownEngaged",serverTime-300];
	if(_cooldown > (serverTime-300)) exitWith {[("STR_A3PL_Prison_LockdownCooldown" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_jail setVariable["lockdownEngaged",serverTime,true];
	playSound3D ["A3PL_Common\effects\lockdown.ogg", _jail, false, getPosASL _jail, 5, 1, 750];
	{
		if (_x != "#(argb,8,8,3)color(1,0,0,1.0,co)") then {
			_jail setObjectTextureGlobal [_forEachIndex,"#(argb,8,8,3)color(1,0,0,1.0,co)"];
		};
	} foreach (getObjectTextures _jail);
	{
		if (_jail animationPhase _x > 0.1) then {[_jail,_x,false,0] call A3PL_Lib_ToggleAnimation;};
	} foreach ["cell_door_1","cell_door_2","cell_door_3","cell_door_4","cell_door_5","cell_door_6","cell_door_7","cell_door_8","cell_door_9","cell_door_10","cell_door_11","cell_door_12","cell_door_13","cell_door_14","door_19","door_18","door_17","door_23"];
	{
		if (_wh animationPhase _x > 0.1) then {[_wh,_x,false,0] call A3PL_Lib_ToggleAnimation;};
	} foreach ["door_1","door_2","door_3","door_4"];
	{
		if (_gate animationPhase _x > 0.1) then {[_gate,_x,false,0] call A3PL_Lib_ToggleAnimation;};
	} foreach ["door_1","door_2","door_3","door_4","door_5","door_6","door_7","door_8","door_9","door_10","gate_1","gate_2"];
	{
		if (_x != "#(argb,8,8,3)color(1,0,0,1.0,co)") then {
			_gate setObjectTextureGlobal [_forEachIndex,"#(argb,8,8,3)color(1,0,0,1.0,co)"];
		};
	} foreach (getObjectTextures _gate);
	{
		if (_x animationPhase "door_1" > 0.1) then {[_x,"door_1",false,0] call A3PL_Lib_ToggleAnimation;};
	} foreach (nearestObjects [_jail, ["Land_A3FL_DOC_Wall_Tower","Land_A3FL_DOC_Wall_Tower_Corner"], 600]);
}] call compile_Global;

["A3PL_Prison_LockpickCell",
{
	private _cellDoor = param [0,objNull];
	private _prison = param [1, objNull];

	if (count([("STR_Common_FISD" call A3PL_Localize)] call A3PL_Lib_FactionPlayers) < PD_Prison_FactionRequired_LockpickCell) exitWith {[format[("STR_A3PL_Prison_NotEnoughFISDToLockpickCell" call A3PL_Localize),PD_Prison_FactionRequired_LockpickCell],Color_Red] call A3PL_Notification;};
	player playmove "Acts_carFixingWheel";
	[("STR_A3PL_Prison_LockpickingCell" call A3PL_Localize),Color_Yellow] call A3PL_Notification;

	if (Player_ActionDoing) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[("STR_Common_LockpickingInProgress" call A3PL_Localize),PD_Prison_Time_To_LockpickCell] spawn A3PL_Lib_LoadAction;
	waitUntil{Player_ActionDoing};
	while {Player_ActionDoing} do {
		if (!(vehicle player isEqualTo player)) exitwith {Player_ActionInterrupted = true;};
		if (player getVariable ["Incapacitated",false]) exitwith {Player_ActionInterrupted = true;};
		if (!(player_itemClass isEqualTo "v_lockpick")) exitwith {Player_ActionInterrupted = true;};
		if (!(["v_lockpick",1] call A3PL_Inventory_Has)) exitwith {Player_ActionInterrupted = true;};
		if ((animationState player) != "Acts_carFixingWheel") then {player playmove "Acts_carFixingWheel";}
	};
	if ((vehicle player) isEqualTo player) then {player switchMove "";};
	if(Player_ActionInterrupted) exitWith {[("STR_Common_LockpickingFailed" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	[player_item] call A3PL_Inventory_Clear;
	[player,"v_lockpick",-1] remoteExec ["Server_Inventory_Add",2];

	_chance = random 100;
	if(_chance >= 75) exitWith {
		[("STR_Common_LockpickingFailed" call A3PL_Localize),Color_Red] call A3PL_Notification;
		[getPlayerUID player,(player getVariable ["character_id",""]),"Lockpick_Cell_Fail",[format ["Cell Door: %1",_cellDoor]]] remoteExec ["Server_Log_New",2];
	};
	[getPlayerUID player,(player getVariable ["character_id",""]),"Lockpick_Cell_Success",[format ["Cell Door: %1",_cellDoor]]] remoteExec ["Server_Log_New",2];
	[("STR_A3PL_Prison_LockpickCellSucceeded" call A3PL_Localize),Color_Green] call A3PL_Notification;
	_prison animate [_cellDoor,1];
}] call compile_Global;

["A3PL_Prison_SearchTrash",
{
	if(!(player getVariable ["jailed",false])) exitWith {[("STR_A3PL_Prison_NoJailTimeToSearch" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[("STR_A3PL_Prison_SearchingTrash" call A3PL_Localize),Color_Yellow] call A3PL_Notification;

	if (Player_ActionDoing) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[player,"AmovPercMstpSnonWnonDnon_AinvPercMstpSnonWnonDnon_Putdown"] remoteExec ["A3PL_Lib_SyncAnim",0];
	[("STR_A3PL_Prison_SearchingTrashInProgress" call A3PL_Localize),PD_Prison_Time_To_SearchTrash] spawn A3PL_Lib_LoadAction;
	waitUntil{Player_ActionDoing};
	while {Player_ActionDoing} do {
		if ((animationState player) isEqualTo "amovpercmstpsnonwnondnon") then {[player,"AmovPercMstpSnonWnonDnon_AinvPercMstpSnonWnonDnon_Putdown"] remoteExec ["A3PL_Lib_SyncAnim",0];};
	};
	player switchMove "";
	if(Player_ActionInterrupted) exitWith {[("STR_Common_ActionInterrupted" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _rareItems = ["coffee_cup_large","v_lockpick","keycard","zipties","cyanide_pills","cocaine","weed_bag_100g","weed_bag_50g"];
	private _commonItems = ["seed_marijuana","coffee_cup_medium","burger_cooked","taco_cooked","applejuice","lettuce"];
	private _pItems = ["A3FL_BaseballBat","A3PL_Pickaxe","A3PL_Shovel","A3FL_PoliceBaton"];

	[(selectRandom _commonItems), 1] call A3PL_Inventory_Add;
	[("STR_A3PL_Prison_CommonItemFound" call A3PL_Localize),Color_Green] call A3PL_Notification;

	private _rollRare = floor(random 100) + 1;

	if (_rollRare <= 10) then {
		[(selectRandom _rareItems), 1] call A3PL_Inventory_Add;
		[("STR_A3PL_Prison_RareItemFound" call A3PL_Localize), Color_Green] call A3PL_Notification;
	};

	if (_rollRare <= 20) then {
		player addItem (selectRandom _pItems);
		[("STR_A3PL_Prison_WeaponItemFound" call A3PL_Localize), Color_Green] call A3PL_Notification;
	};
}] call compile_Global;

["A3PL_Prison_DigOut",
{
	private _factionReq = (count([("STR_Common_FISD" call A3PL_Localize)] call A3PL_Lib_FactionPlayers)) < PD_Prison_FactionRequired_To_DigOut;
	if (!(call A3PL_Player_AntiSpam)) exitWith {};
	if (_factionReq) exitwith {[format[("STR_A3PL_Prison_NotEnoughFISDToDigOut" call A3PL_Localize),PD_Prison_FactionRequired_To_DigOut],Color_Red] call A3PL_Notification;};
	if (player getVariable ["Digging",false]) exitWith{[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (currentWeapon player != "A3PL_Shovel") exitwith {[("STR_A3PL_Prison_NeedShovel" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (Player_ActionDoing) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	player setVariable ["Digging",true,true];
	[player,"A3PL_Shovel_Dig"] remoteExec ["A3PL_Lib_SyncAnim", 0];

	[("STR_A3PL_Prison_DiggingOutOfPrison" call A3PL_Localize),PD_Prison_Time_To_DigOut] spawn A3PL_Lib_LoadAction;
	waitUntil{Player_ActionDoing};
	while {Player_ActionDoing} do {
		if (!(player getVariable["A3PL_Medical_Alive",true])) exitWith {Player_ActionInterrupted = false;};
		if ((vehicle player) != player) exitWith {Player_ActionInterrupted = false;};
		if (player getVariable ["Incapacitated",false]) exitwith {Player_ActionInterrupted = false;};
		if (player getVariable ["Cuffed",false]) exitwith {Player_ActionInterrupted = false;};
	};

	[player,""] remoteExec ["A3PL_Lib_SyncAnim", 0];
	player setVariable ["Digging",false,true];
	if(Player_ActionInterrupted) exitWith {[("STR_Common_ActionInterrupted" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_suceedChance = random 100;
	if(_suceedChance > 70) then {
		[("STR_A3PL_Prison_DiggingOutOfPrison_Succeeded" call A3PL_Localize),Color_Green] call A3PL_Notification;
		_positions = [[4791.35,6206.43,0.00143886],[4722.96,6202.12,0.00178289],[4724.76,6066.46,0.00209379],[4794.03,6112.77,0.00143862]];
		player setPosATL (selectRandom _positions);
	} else {
		[("STR_A3PL_Prison_DiggingOutOfPrison_Failed" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};
}] call compile_Global;

["A3PL_Prison_Markers",
{
	{deleteMarkerLocal _x} foreach A3PL_Inmates_Markers;
	A3PL_Inmates_Markers = nil;
	if(!((player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) isEqualTo ("STR_Common_FISD" call A3PL_Localize))) exitWith {};
	A3PL_Inmates_Markers = [];
	{
		if (_x IN Server_Jail_Markers_charIDs) then {
			_player = [_x] call A3PL_Lib_charIDToObject;
			_marker = createMarkerLocal [format["%1",round (random 1000)],visiblePosition _player];
			_marker setMarkerShapeLocal "ICON";
			_marker setMarkerColorLocal "ColorYellow";
			_marker setMarkerTypeLocal "mil_dot";
			_marker setMarkerAlphaLocal 0.7;
			if ((_player getVariable ["jailed",false])) then {
				_marker setMarkerTextLocal format[("STR_A3PL_Prison_PrisonerMarker" call A3PL_Localize),(_player getVariable ["name",("STR_Common_Unknown" call A3PL_Localize)]), (_player getVariable ["jailtime",0])];
			} else {
				_marker setMarkerTextLocal format[("STR_A3PL_Prison_PrisonerBracelet" call A3PL_Localize),(_player getVariable ["name",("STR_Common_Unknown" call A3PL_Localize)])];
			};
			A3PL_Inmates_Markers pushback _marker;
		};
	} foreach Server_Online_Players_charIDs;
}] call compile_Global;

["A3PL_PrisonGate_HandleDoor",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private _obj = param [0,objNull];
	private _name = param [1,""];
	private _factionReq = !((count([("STR_Common_FISD" call A3PL_Localize)] call A3PL_Lib_FactionPlayers)) >= PD_Prison_FactionRequired_Keycard);
	private _faction = player getVariable["faction","citizen"] IN [("STR_Common_FISD" call A3PL_Localize)];

	if(_name IN ["door_11","door_12","door_13","door_14"]) exitwith {
		if (_obj animationPhase _anim < 0.5) then {
			[_obj,_anim,false,1] call A3PL_Lib_ToggleAnimation;
		} else {
			[_obj,_anim,false,0] call A3PL_Lib_ToggleAnimation;
		};
	};
	if(!_faction && _factionReq && (["keycard",1] call A3PL_Inventory_Has)) exitwith {[format[("STR_A3PL_Prison_NotEnoughFISDToUseAccessCard" call A3PL_Localize),PD_Prison_FactionRequired_Keycard],Color_Red] call A3PL_Notification;};

	if (_name IN
	[
		"console_door1","console_door2","console_door3","console_door4","console_door5","console_door6","console_door7","console_door8","console_door9","console_door10",
		"console_gate1","console_gate2",
		"door_1_button","door_1_button2","door_2_button","door_2_button2","door_3_button","door_3_button2",
		"door_4_button","door_4_button2","door_5_button","door_5_button2","door_6_button","door_6_button2",
		"door_7_button","door_7_button2","door_8_button","door_8_button2","door_9_button","door_9_button2",
		"door_10_button","door_10_button2"
	]) exitwith {
		private _anim = "";
		private _hSel = -1;
		switch (_name) do
		{
			case ("door_1_button"): {_anim = "door_1"; _hSel = 0;};
			case ("door_1_button2"): {_anim = "door_1"; _hSel = 0;};
			case ("door_2_button"): {_anim = "door_2"; _hSel = 1;};
			case ("door_2_button2"): {_anim = "door_2"; _hSel = 1;};
			case ("door_3_button"): {_anim = "door_3"; _hSel = 2;};
			case ("door_3_button2"): {_anim = "door_3"; _hSel = 2;};
			case ("door_4_button"): {_anim = "door_4"; _hSel = 3;};
			case ("door_4_button2"): {_anim = "door_4"; _hSel = 3;};
			case ("door_5_button"): {_anim = "door_5"; _hSel = 4;};
			case ("door_5_button2"): {_anim = "door_5"; _hSel = 4;};
			case ("door_6_button"): {_anim = "door_6"; _hSel = 5;};
			case ("door_6_button2"): {_anim = "door_6"; _hSel = 5;};
			case ("door_7_button"): {_anim = "door_7"; _hSel = 6;};
			case ("door_7_button2"): {_anim = "door_7"; _hSel = 6;};
			case ("door_8_button"): {_anim = "door_8"; _hSel = 7;};
			case ("door_8_button2"): {_anim = "door_8"; _hSel = 7;};
			case ("door_9_button"): {_anim = "door_9"; _hSel = 8;};
			case ("door_9_button2"): {_anim = "door_9"; _hSel = 8;};
			case ("door_10_button"): {_anim = "door_10"; _hSel = 9;};
			case ("door_10_button2"): {_anim = "door_10"; _hSel = 9;};

			case ("console_door1"): {_anim = "door_1"; _hSel = 0;};
			case ("console_door2"): {_anim = "door_2"; _hSel = 1;};
			case ("console_door3"): {_anim = "door_3"; _hSel = 2;};
			case ("console_door4"): {_anim = "door_4"; _hSel = 3;};
			case ("console_door5"): {_anim = "door_5"; _hSel = 4;};
			case ("console_door6"): {_anim = "door_6"; _hSel = 5;};
			case ("console_door7"): {_anim = "door_7"; _hSel = 6;};
			case ("console_door8"): {_anim = "door_8"; _hSel = 7;};
			case ("console_door9"): {_anim = "door_9"; _hSel = 8;};
			case ("console_door10"): {_anim = "door_10"; _hSel = 9;};
			case ("console_gate1"): {_anim = "gate_1";};
			case ("console_gate2"): {_anim = "gate_2";};
		};
		if (_obj animationPhase _anim < 0.5) then {
			_obj setObjectTextureGlobal [_hSel,"#(argb,8,8,3)color(0,1,0,1.0,co)"];
			[_obj,_anim,false,1] call A3PL_Lib_ToggleAnimation;
			playSound3D ["A3FL_Buildings\Data\OpenBuzz.wav", _obj, false, getPosASL _obj, 3, 1, 500]; 
		} else {
			_obj setObjectTextureGlobal [_hSel,"#(argb,8,8,3)color(1,0,0,1.0,co)"];
			[_obj,_anim,false,0] call A3PL_Lib_ToggleAnimation;
		};
	};
	if (_name isEqualTo "console_lockdown") exitwith {
		call A3PL_Prison_Lockdown;
	};
}] call compile_Global;

["A3PL_PrisonTower_HandleDoor",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private _obj = param [0,objNull];
	private _name = param [1,""];
	private _factionReq = !((count([("STR_Common_FISD" call A3PL_Localize)] call A3PL_Lib_FactionPlayers)) >= PD_Prison_FactionRequired_Keycard);
	if (_name IN ["door_2"]) exitwith {[_obj,"door_2",false] call A3PL_Lib_ToggleAnimation;};

	if(!(player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] IN [("STR_Common_FISD" call A3PL_Localize)]) && {_factionReq && !(["keycard",1] call A3PL_Inventory_Has)}) exitwith {[format[("STR_A3PL_Prison_NotEnoughFISDToUseAccessCard" call A3PL_Localize),PD_Prison_FactionRequired_Keycard],Color_Red] call A3PL_Notification;};

	if (_name IN ["door_1_button","door_1_button2"]) exitwith
	{
		private _anim = "";
		switch (_name) do
		{
			case ("door_1_button"): {_anim = "door_1";};
			case ("door_1_button2"): {_anim = "door_1";};
		};
		if (_obj animationPhase _anim < 0.5) then {
			[_obj,_anim,false,1] call A3PL_Lib_ToggleAnimation;
		} else {
			[_obj,_anim,false,0] call A3PL_Lib_ToggleAnimation;
		};
	};
}] call compile_Global;

["A3PL_Prison_Suicide",
{
	["cyanide_pills",-1] call A3PL_Inventory_Add;
	[player, "chest", "drug_overdose"] call A3PL_Medical_ApplyWound;
	[] call A3PL_Inventory_Clear;
	sleep 5;
	player setDamage 1;
}] call compile_Global;

["A3PL_Prison_HandleWarehouse",
{
	private _obj = param [0,objNull];
	private _name = param [1,""];
	private _factionReq = (count([("STR_Common_FISD" call A3PL_Localize)] call A3PL_Lib_FactionPlayers) < PD_Prison_FactionRequired_Keycard) && !(["keycard",1] call A3PL_Inventory_Has);
	if(!(player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] IN [("STR_Common_FISD" call A3PL_Localize)]) && {_factionReq}) exitwith {[format[("STR_A3PL_Prison_NotEnoughFISDToUseAccessCard" call A3PL_Localize),PD_Prison_FactionRequired_Keycard],Color_Red] call A3PL_Notification;};
	if (_name IN ["door_1_button","door_1_button2","door_2_button","door_2_button2","door_3_button","door_4_button"]) exitwith
	{
		private _anim = switch (_name) do {
			case "door_1_button": {"door_1";};
			case "door_1_button2": {"door_1";};
			case "door_2_button": {"door_2";};
			case "door_2_button2": {"door_2";};
			case "door_3_button": {"door_3";};
			case "door_4_button": {"door_4";};
		};
		if (_anim isEqualTo "door_3") then {playSound3D ["A3FL_Buildings\Data\OpenBuzz.wav", _obj, true, getPosASL _obj, 3, 1, 200];};
		if (_obj animationPhase _anim < 0.5) then {
			[_obj,_anim,true,1] call A3PL_Lib_ToggleAnimation;
		} else {
			[_obj,_anim,true,0] call A3PL_Lib_ToggleAnimation;
		};
	};
}] call compile_Global;

["A3PL_DOC_BlueprintBuy",
{
    [] spawn {
        private _action = [format[("STR_A3PL_Prison_BlueprintsPurchase" call A3PL_Localize),GOV_Faction_Blueprint_Price]] call A3PL_Lib_ConfirmationDialog;
        if (!isNil "_action" && {!_action}) exitWith {};

        private _factionBalance = [player] call A3PL_Government_MyFactionBalance;
        if(_factionBalance < GOV_Faction_Blueprint_Price) exitwith {[("STR_A3PL_Prison_BlueprintNoMoney" call A3PL_Localize),Color_Red] call A3PL_Notification;};
        [_factionBalance,-GOV_Faction_Blueprint_Price,"",format[("STR_Common_BlueprintPurchase" call A3PL_Localize)]] remoteExec ["Server_Government_AddBalance",2];

        ["blueprint_fisd",1] call A3PL_Inventory_Add;
    };
}] call compile_Global;

["A3PL_DOC_BlueprintEquipmentBuy",
{
    [] spawn {
        private _action = [format[("STR_Common_BlueprintAmmoPurchase" call A3PL_Localize),GOV_Faction_EQ_Blueprint_Price]] call A3PL_Lib_ConfirmationDialog;
        if (!isNil "_action" && {!_action}) exitWith {};

        private _factionBalance = [player] call A3PL_Government_MyFactionBalance;
        if(_factionBalance < GOV_Faction_EQ_Blueprint_Price) exitwith {[("STR_A3PL_Prison_BlueprintNoMoney" call A3PL_Localize),Color_Red] call A3PL_Notification;};
        [_factionBalance,-GOV_Faction_EQ_Blueprint_Price,"",("STR_Common_BlueprintAmmoPurchase" call A3PL_Localize)] remoteExec ["Server_Government_AddBalance",2];

        ["blueprinteq_fisd",1] call A3PL_Inventory_Add;
    };
}] call compile_Global;

["A3PL_Prison_RemoveJail",
{
	private _target = param [0,objNull];
	_target setVariable ["jail_mark",false,true];
	_target setVariable ["jailed",false,true];
	_target setVariable ["jailtime",nil,true];
	[_target] remoteExec ["Server_Criminal_RemoveJail", 2];
}] call compile_Global;
