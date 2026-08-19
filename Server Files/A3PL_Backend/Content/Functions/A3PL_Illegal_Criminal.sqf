/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
['A3PL_Criminal_Ziptie', {
	params["_obj"];
	if(_obj getVariable ["pVar_RedNameOn",false]) exitWith {};
	[getPlayerUID _obj,(_obj getVariable ["character_id",""]),"Civ_Ziptied",[format ["Location: %1 | Ziptied By: %2",(getPosATL _obj),(player getVariable["name","unknown"])]]] remoteExec ["Server_Log_New",2];

	private _policeAnim = switch (animationState _obj) do {
		case "amovpercmstpsnonwnondnon": {1};
		case "amovpercmstpsraswrfldnon": {1};
		case "amovpercmstpsraswpstdnon": {1};
		case "amovpercmstpsraswlnrdnon": {1};
		case "a3pl_idletohandsup": {2};
		case "a3pl_handsuptokneel": {3};
		case "amovpknlmstpsnonwnondnon": {4};
		case "amovpknlmstpsraswpstdnon": {4};
		case "amovpknlmstpsraswrfldnon": {4};
		case "amovpknlmstpsraswlnrdnon": {4};
		case "amovppnemstpsnonwnondnon": {5};
		case "amovppnemstpsraswrfldnon": {5};
		case "amovppnemstpsraswpstdnon": {5};
		case "unconscious": {5};
		default {5};
	};

	_obj setVariable ["Zipped",true,true];
	[false] call A3PL_Inventory_PutBack;
	["zipties", 1] call A3PL_Inventory_Remove;
	[player,_obj,_policeAnim] remoteExec ["A3PL_Police_HandleAnim",0];
}] call compile_Global;

['A3PL_Criminal_Unzip', {
	private _obj = _this select 0;
	private _Cuffed = _obj getVariable ["Zipped",false];
	private _alive = _obj getVariable["A3PL_Medical_Alive",true];
	if(_Cuffed && {!_alive}) exitwith {[("STR_A3PL_Illegal_Criminal_CantRemoveZipTiesDead" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[getPlayerUID _obj,(_obj getVariable ["character_id",""]),"Civ_UnZiptied",[format ["Location: %1 | UnZiptied By: %2",(getPosATL _obj),(player getVariable["name","unknown"])]]] remoteExec ["Server_Log_New",2];
	if (_Cuffed) then {
		["zipties",1] call A3PL_Inventory_Add;
		[player,_obj,7] remoteExec ["A3PL_Police_HandleAnim",0];
		_obj setVariable ["Zipped",false,true];
		_obj setVariable ["dragged",nil,true];
		if((vehicle _obj) isEqualTo _obj) then {
			["gesture_stop",_obj] call A3PL_Lib_Gesture;
			[_obj,""] remoteExec ["A3PL_Lib_SyncAnim", -2];
		};
	};
}] call compile_Global;

["A3PL_Criminal_RemoveTime",{
	if (Remove_AnkleMonitor_Price > (player getVariable ["player_cash",0])) exitwith {[format [("STR_A3PL_Illegal_Criminal_NotEnoughMoneyBracelet" call A3PL_Localize),Remove_AnkleMonitor_Price],Color_Red] call A3PL_Notification;};

	player setVariable ["player_cash",(player getVariable ["player_cash",0]) - Remove_AnkleMonitor_Price,true];

	player setVariable ["jail_mark",false,true];
	player setVariable ["jailed",false,true];
	player setVariable ["jailtime",nil,true];
	
	private _charID = player getVariable ["character_id",""];
	Server_Jail_Markers_charIDs deleteAt (Server_Jail_Markers_charIDs find _charID);
	publicVariable "Server_Jail_Markers_charIDs";
	["Server_Jail_Markers_charIDs",true] remoteExec ["Server_Core_SavePersistentVar"];

	[player] remoteExec ["Server_Criminal_RemoveJail", 2];

	[("STR_A3PL_Illegal_Criminal_BraceletRemoved" call A3PL_Localize)] call A3PL_Notification;
}] call compile_Global;

["A3PL_Criminal_Work", {
	if !(player getVariable ["jailed",false]) exitWith {[("STR_A3PL_Illegal_Criminal_ActivityPrisonersOnly" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (Player_ActionDoing) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	[("STR_A3PL_Illegal_Criminal_LicensePlateFactory" call A3PL_Localize),Manufacturing_Plate_Time] spawn A3PL_Lib_LoadActionQTE;
	waitUntil{Player_ActionDoing};
	player playMoveNow 'Acts_carFixingWheel';
	while {Player_ActionDoing} do {
		if (!(player getVariable["A3PL_Medical_Alive",true])) exitWith {Player_ActionInterrupted = true;};
		if ((vehicle player) isNotEqualTo player) exitWith {Player_ActionInterrupted = true;};
		if (player getVariable ["Incapacitated",false]) exitwith {Player_ActionInterrupted = true;};
	};
	if(Player_ActionInterrupted) exitWith {[("STR_Common_ActionInterrupted" call A3PL_Localize),Color_Red] call A3PL_Notification;};

    if (Active_GoodBehavior == true) then {
        _chance = selectRandom[1,2];
        if(_chance isEqualTo 2) then {
            _time = player getVariable ["jailtime",0];
            _newTime = _time - 1;
            [("STR_A3PL_Illegal_Criminal_JailTimeReduced" call A3PL_Localize),Color_Green] call A3PL_Notification;
            [_newTime, player] remoteExec ["Server_Police_JailPlayer",2];
        };
    };
	player setVariable ["player_cash",(player getVariable ["player_cash",0]) + Manufacturing_Plate_Reward,true];
	[format[("STR_A3PL_Illegal_Criminal_YouFinishedJob" call A3PL_Localize),Manufacturing_Plate_Reward],Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Criminal_PickCar", {
	private _car = param [0,objNull];
	if (isNull _car) exitWith {[("STR_A3PL_Illegal_Criminal_ErrorFindVehicle" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if !(_car getVariable["locked",false]) exitWith {[("STR_A3PL_Illegal_Criminal_VehicleAlreadyUnlocked" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (animationstate player isEqualTo "Acts_carFixingWheel") exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (Player_ActionDoing) exitwith {[("STR_A3PL_Illegal_Criminal_YouAreAlreadyHotwiring" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (player distance _car > 9) exitWith {[("STR_A3PL_Illegal_Criminal_TooFarFromVehicle" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_car IN A3PL_Player_Vehicles) exitwith {[("STR_A3PL_Illegal_Criminal_YouAlreadyHaveKeys" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((count allPlayers) < 5) exitWith {[("STR_A3PL_Illegal_Criminal_CantHotwireVehiclePlayers" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((typeof _car IN (Config_FISD_Vehs + Config_FIFR_Vehs)) && (count([("STR_Common_FISD" call A3PL_Localize)] call A3PL_Lib_FactionPlayers) < 1)) exitWith {[("STR_A3PL_Illegal_Criminal_CantHotwireVehicleFISD" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _pickingTime = Car_Lockpicking_Time;

	// Trait quick_fingers - reduces lockpicking time by 30%
	private _traits = player getVariable ["Player_Traits", []];
	if ("quick_fingers" in _traits) then {
		_pickingTime = _pickingTime * 0.7;
	};

	[("STR_Common_LockpickingInProgress" call A3PL_Localize),_pickingTime] spawn A3PL_Lib_LoadActionQTE;
	waitUntil{Player_ActionDoing};
	player playMoveNow 'Acts_carFixingWheel';
	while {Player_ActionDoing} do {
		if ((player distance2D _car) > 9) exitWith {Player_ActionInterrupted = true;};
		if (vehicle player isNotEqualTo player) exitwith {Player_ActionInterrupted = true;};
		if (!(player_itemClass isEqualTo "v_lockpick")) exitwith {Player_ActionInterrupted = true;};
		if ((animationstate player) != "Acts_carFixingWheel") then {player playMoveNow 'Acts_carFixingWheel';};
	};
	player switchMove "";
	if(Player_ActionInterrupted) exitWith {[("STR_A3PL_Illegal_Criminal_LockpickFailed" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	[player_item] call A3PL_Inventory_Clear;
	[player,"v_lockpick",-1] remoteExec ["Server_Inventory_Add",2];

	private _chance = random 100;
	private _pickingChance = Car_Lockpicking_Chance;
	if(_chance < _pickingChance) then {
		[("STR_A3PL_Illegal_Criminal_YouFailedToHotwire" call A3PL_Localize),Color_Red] call A3PL_Notification;
		_y = Car_Lockpicking_Chance;
		while {_y > 0} do {
			playSound3D ["A3\Sounds_F\sfx\alarmCar.wss", _car, true, _car, 3, 1, 100];
			uiSleep 2;
			_y = _y - 1;
		};
		[getPlayerUID player,(player getVariable ["character_id",""]),"Lockpick_Vehicle_Fail",[format ["Location: %1 | Vehicle: %2 | Plate: %3",getPosATL player,typeOf _car,(_car getVariable ["owner",["",""]])#1]]] remoteExec ["Server_Log_New",2];
	} else {
		_car setVariable ["locked",false,true];
		[("STR_A3PL_Illegal_Criminal_YouHotwiredVehicle" call A3PL_Localize),Color_Green] call A3PL_Notification;
		[getPlayerUID player,(player getVariable ["character_id",""]),"Lockpick_Vehicle_Success",[format ["Location: %1 | Vehicle: %2 | Plate: %3",getPosATL player,typeOf _car,(_car getVariable ["owner",["",""]])#1]]] remoteExec ["Server_Log_New",2];
	};
}] call compile_Global;

["A3PL_Criminal_SuicideVest",
{
	private _nearO = nearestObjects[player, [], 20];
	private _suicide = "Bo_Mk82" createVehicle [0,0,9999];
	_suicide setPos (getPos player);
	_suicide setVelocity [100,0,0];
	{
		if ((!(_x getVariable ["pVar_RedNameOn",false])) && (!(_x isKindOf "Thing"))) then {_x setDamage 1};
		if (_x isKindOf "Thing") then {deleteVehicle _x};
	} foreach _nearO;
	removeVest player;
	[] spawn {
		sleep 15;
		call A3PL_Medical_Respawn;
	};
	[getPlayerUID player,(player getVariable ["character_id",""]),"SuicideVest_Triggered",[format ["Location: %1",(getPosATL player)]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

['A3PL_Criminal_Drag',
{
	private _civ = _this select 0;
	private _escorted = _civ getVariable ["escorted",false];
	private _escorting = player getVariable ["escorting",false];
	if (_escorting) exitWith {player getVariable ["escorting",false];};
	if (_escorted) exitwith {_civ setVariable ["escorted",nil,true];};
	if (_civ getVariable["Zipped",false]) then {
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
				if !(_civ getVariable["Zipped",false]) exitWith {};
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
		[("STR_A3PL_Illegal_Criminal_PlayerNotHandcuffed" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};
}] call compile_Global;

["A3PL_Criminal_PickHandcuffs",{
	private _target = param [0,objNull];
    private _mode = _this select 1;

	switch (_mode) do {
        case 0: {
			if (vehicle player isNotEqualTo player) exitwith {[("STR_A3PL_Illegal_Criminal_YouCantPickHandcuffsWhileInVehicle" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			if (Player_ActionDoing) exitwith {[("STR_A3PL_Illegal_Criminal_YouAreAlreadyPickingHandcuffs" call A3PL_Localize),Color_Red] call A3PL_Notification;};

			private _pickingTime = Handcuffs_Lockpicking_Time;

			// Trait quick_fingers - reduces lockpicking time by 30%
			private _traits = player getVariable ["Player_Traits", []];
			if ("quick_fingers" in _traits) then {
				_pickingTime = _pickingTime * 0.7;
			};

			player playmove "Acts_carFixingWheel";
			[("STR_A3PL_Illegal_Criminal_LockpickInProgress" call A3PL_Localize),_pickingTime] spawn A3PL_Lib_LoadActionQTE;
			waitUntil {Player_ActionDoing};
			while {Player_ActionDoing} do {
				if ((player distance2D _target) > 5) exitWith {[("STR_A3PL_Illegal_Criminal_YouNeedToBeCloser" call A3PL_Localize),Color_Red] call A3PL_Notification; Player_ActionInterrupted = true;};
				if (vehicle player isNotEqualTo player) exitwith {Player_ActionInterrupted = true;};
				if (!(["v_lockpick",1] call A3PL_Inventory_Has)) exitwith {Player_ActionInterrupted = true;};
			};
			if ((vehicle player) isEqualTo player) then {player switchMove "";};
			if(Player_ActionInterrupted) exitWith {[("STR_A3PL_Illegal_Criminal_LockpickFailed" call A3PL_Localize),Color_Red] call A3PL_Notification;};

			["v_lockpick",-1] call A3PL_Inventory_Add;
			_chance = random 100;
			private _pickingChance = Handcuffs_Lockpicking_Chance;
			if(_chance < _pickingChance) then {
				[("STR_A3PL_Illegal_Criminal_YouFailedToPickHandcuffs" call A3PL_Localize),Color_Red] call A3PL_Notification;
			} else {
				[_target] call A3PL_Police_Uncuff;
				[("STR_A3PL_Illegal_Criminal_YouPickedHandcuffs" call A3PL_Localize),Color_Green] call A3PL_Notification;
			};
		};
		case 1: {
            if (!(["v_lockpick",1] call A3PL_Inventory_Has)) exitwith {[("STR_A3PL_Illegal_Criminal_YouDontHaveLockpick" call A3PL_Localize),Color_Red] call A3PL_Notification;};
            if (!(animationState player IN ["a3pl_handsuptokneel", "a3pl_handsupkneelgetcuffed", "a3pl_cuff", "a3pl_handsupkneelcuffed", "a3pl_handsupkneelkicked", "a3pl_cuffkickdown", "a3pl_idletohandsup", "a3pl_kneeltohandsup", "a3pl_handsuptokneel", "a3pl_handsupkneel"])) exitWith {[("STR_A3PL_Illegal_Criminal_YouAreNotHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
            if (vehicle player isNotEqualTo player) exitwith {[("STR_A3PL_Illegal_Criminal_YouCantPickHandcuffsWhileInVehicle" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			if (Player_ActionDoing) exitwith {[("STR_A3PL_Illegal_Criminal_YouAreAlreadyPickingHandcuffs" call A3PL_Localize),Color_Red] call A3PL_Notification;};

			private _pickingTime = Handcuffs_Lockpicking_Time;

			// Trait quick_fingers - reduces lockpicking time by 30%
			private _traits = player getVariable ["Player_Traits", []];
			if ("quick_fingers" in _traits) then {
				_pickingTime = _pickingTime * 0.7;
			};

			player playmove "Acts_carFixingWheel";
			[("STR_A3PL_Illegal_Criminal_LockpickInProgress" call A3PL_Localize),_pickingTime] spawn A3PL_Lib_LoadActionQTE;
			waitUntil {Player_ActionDoing};
			while {Player_ActionDoing} do {
				if (vehicle player isNotEqualTo player) exitwith {Player_ActionInterrupted = true;};
				if (!(["v_lockpick",1] call A3PL_Inventory_Has)) exitwith {Player_ActionInterrupted = true;};
			};
			if ((vehicle player) isEqualTo player) then {player switchMove "";};
			if(Player_ActionInterrupted) exitWith {[("STR_A3PL_Illegal_Criminal_LockpickFailed" call A3PL_Localize),Color_Red] call A3PL_Notification;};

			["v_lockpick",-1] call A3PL_Inventory_Add;
			_chance = random 100;
			private _pickingChance = Handcuffs_Lockpicking_Chance;
			if(_chance < _pickingChance) then {
				[("STR_A3PL_Illegal_Criminal_YouFailedToPickHandcuffs" call A3PL_Localize),Color_Red] call A3PL_Notification;
			} else {
				[player] call A3PL_Police_Uncuff;
				[("STR_A3PL_Illegal_Criminal_YouPickedHandcuffs" call A3PL_Localize),Color_Green] call A3PL_Notification;
			};
        };
    };
}] call compile_Global;

["A3FL_Criminal_PickAnkleMonitor", {
	private _target = param [0,objNull];

	if (vehicle player isNotEqualTo player) exitWith {[("STR_A3PL_Illegal_Criminal_YouCantPickHandcuffsWhileInVehicle" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (Player_ActionDoing) exitwith {[("STR_A3PL_Illegal_Criminal_YouAreAlreadyPickingHandcuffs" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _pickingTime = AnkleMonitor_Lockpicking_Time;

	// Trait quick_fingers - reduces lockpicking time by 30%
	private _traits = player getVariable ["Player_Traits", []];
	if ("quick_fingers" in _traits) then {
		_pickingTime = _pickingTime * 0.7;
	};

	player playmove "Acts_carFixingWheel";
	[("STR_A3PL_Illegal_Criminal_LockpickInProgress" call A3PL_Localize),_pickingTime] spawn A3PL_Lib_LoadActionQTE;
	waitUntil {Player_ActionDoing};
	while {Player_ActionDoing} do {
		if ((player distance2D _target) > 5) exitWith {[("STR_A3PL_Illegal_Criminal_YouNeedToBeCloser" call A3PL_Localize),Color_Red] call A3PL_Notification; Player_ActionInterrupted = true;};
		if (vehicle player isNotEqualTo player) exitwith {Player_ActionInterrupted = true;};
		if (!(["v_lockpick",1] call A3PL_Inventory_Has)) exitwith {Player_ActionInterrupted = true;};
	};
	if ((vehicle player) isEqualTo player) then {player switchMove "";};
	if(Player_ActionInterrupted) exitWith {[("STR_A3PL_Illegal_Criminal_LockpickFailed" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	["v_lockpick",-1] call A3PL_Inventory_Add;
	_chance = random 100;
	private _pickingChance = AnkleMonitor_Lockpicking_Chance;
	if(_chance < _pickingChance) then {
		[("STR_A3PL_Illegal_Criminal_YouFailedToPickHandcuffs" call A3PL_Localize),Color_Red] call A3PL_Notification;
	} else {
		[("STR_A3PL_Illegal_Criminal_YouPickedHandcuffs" call A3PL_Localize),Color_Green] call A3PL_Notification;

		_target setVariable ["jail_mark",false,true];
		_target setVariable ["jailed",false,true];
		_target setVariable ["jailtime",nil,true];

		[_target] remoteExec ["Server_Criminal_RemoveJail", 2];
		[("STR_A3PL_Illegal_Criminal_YourBraceletHasBeenCut" call A3PL_Localize), Color_red] remoteExec ["A3PL_Notification",_target];
	};
}] call compile_Global;

["A3PL_Criminal_FindNPC",{
	private _cost = param[0,FindNPC_Default_Price];
	private _npc = param[1,""];
	private _playerCash = player getVariable["Player_Cash",0];
	if(_cost > _playerCash) exitWith {[format [("STR_A3PL_Illegal_Criminal_YouNeedMoneyToFindDealer" call A3PL_Localize),_cost],Color_Red] call A3PL_Notification;};
	private _npcName = "";
	private _npcNameFull = "";
	private _randomNumber = floor(random 5);
	private _mapArea = false;
	switch (_npc) do {
		case "illtrader": {
			_npcName = npc_ill_trader;
			_npcNameFull = ("STR_A3PL_Illegal_Criminal_Illegal_Trader" call A3PL_Localize);
		};
		case "moonshine": {
			_npcName = npc_ill_moonshine;
			_npcNameFull = ("STR_A3PL_Illegal_Criminal_Moonshine_Dealer" call A3PL_Localize);
		};
		case "cocaine": {
			_npcName = npc_ill_cocaine;
			_npcNameFull = ("STR_A3PL_Illegal_Criminal_Cocaine_Dealer" call A3PL_Localize);
		};
		case "shrooms": {
			_npcName = npc_ill_shrooms;
			_npcNameFull = ("STR_A3PL_Illegal_Criminal_Mushroom_Dealer" call A3PL_Localize);
		};
		case "weed": {
			_npcName = npc_ill_weed;
			_npcNameFull = ("STR_A3PL_Illegal_Criminal_Weed_Dealer" call A3PL_Localize);
		};
	};
	private _nearestCity = text ((nearestLocations [_npcName, ["NameCityCapital","NameCity","NameVillage"], 5000]) select 0);
	player setVariable ["Player_Cash",(_playerCash - _cost),true];
	[format [("STR_A3PL_Illegal_Criminal_YouPaidForInfo" call A3PL_Localize),_cost,_npcNameFull,_nearestCity],Color_Green] call A3PL_Notification;

	if(_mapArea) then {
		_exactLocation = getPos _npcName;
		_pos = [(_exactLocation#0) + (-50 + (random 300)),(_exactLocation#1) + (-50 + (random 300))];
		[_pos,_npcNameFull,"A3FL_Markers_RedBox",500] spawn A3PL_Lib_MapArea;
	};
}] call compile_Global;

["A3PL_Criminal_FakePlate",{
	disableSerialization;
	private _nearVeh = nearestObjects [player, ["Car"], 20];
	private _veh = objNull;
	{
		if(((_x getVariable ["owner",["",""]])#0) isEqualTo (player getVariable ["character_id",""])) exitWith {_veh = _x;};
	} forEach _nearVeh;
	if(isNull _veh) exitWith {[("STR_A3PL_Illegal_Criminal_NoVehiclesNearby" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _action = [format[("STR_A3PL_Illegal_Criminal_InstallingFakePlate" call A3PL_Localize),getText (configFile >> "CfgVehicles" >> typeOf _veh >> "displayName"),FakePlate_Install_Price]] call A3PL_Lib_ConfirmationDialog;
	if (!isNil "_action" && {!_action}) exitWith {[("STR_A3PL_Illegal_Criminal_YouDecidedToKeepOriginalPlate" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[_veh,player] remoteExec ["Server_Criminal_IllPlate",2];
}] call compile_Global;

["A3PL_Criminal_FakeID", {
	private _action = [format[("STR_A3PL_Illegal_Criminal_TakeFakeID" call A3PL_Localize),FakeID_Create_Price]] call A3PL_Lib_ConfirmationDialog;
	if (!isNil "_action" && {!_action}) exitWith {[("STR_A3PL_Illegal_Criminal_YouDecidedNotToBuyFakeID" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _pCash = player getVariable["Player_Cash",0];
	if(_pCash < FakeID_Create_Price) exitWith {[format[("STR_A3PL_Illegal_Criminal_YouDontHaveMoneyForFakeID" call A3PL_Localize),FakeID_Create_Price],Color_Red] call A3PL_Notification;};
	player setVariable ["player_cash",_pCash - FakeID_Create_Price,true];
	private _gender = player getVariable["gender","male"];
	private _firstNames = if(_gender isEqualTo "male") then {["John","Jake","Arron","Andrew","Daniel","Daniel","Simon","Shafik","Daniel","James","Paul","Kirk","Matthew","Ronnie","Jason","Spencer","Colin","Dick","Robert","Jacob","Carson","Radwan","Henry","Hank","Richard","Benzion","Quinn","Andrew","Ashton","Edward"]} else {["Susanne","Teresa","Amelia","Emily","Joanne","Megan","Katie","Jennifer","Dannielle","Sarah","Pauline","Samantha","Jennifer","Virgina","Peyton","Dina","Madeleine","Lindsey","Fatima","Kate","Sara","Caroline","Mary","Heather","Rachel","Allisa","Kamala","Nicole","Rosa","Anne"]};
	private _lastNames = if(_gender isEqualTo "male") then {["James","Williams","Rodewell","Jerram","Poulson","Walsh","Molloy","Megji","Jamieson","Burcher","Jamieson","Cumberbatch","Cook","Bradley","Blackmore","Allan","Brown","Potter","Smirnoff","Baldhead","Wells","Hassen","Hayes","Hill","Hatfield","Lewis","Jacobs","Wakefield","Wash","Sharp"]} else {["Jones","McKenna","Clark","Reed","Maddox","William","Swift","Spelling","Walker","Fisher","Jonas","Pickering","Cox","Waterfalls","Perry","Finch","Worley","McClure","Dolan","Hilton","Hamm","Watson","Arnolds","Heinz","Jones","Fink","Harris","Olsen","Parks","Frank"]};
	private _name = format["%1 %2", selectRandom _firstNames, selectRandom _lastNames];
	player setVariable["fakeName",_name,true];
	[format[("STR_A3PL_Illegal_Criminal_YouAreNowKnownAs" call A3PL_Localize),_name],Color_Green] call A3PL_Notification;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Civ_FakeID_Selected",[format ["Fake ID: %1",_name]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

["A3PL_Criminal_ShotNotification", {
	params ["_pos"];

	// Base chance of police being alerted (100% by default)
	private _alertChance = 100;

	// Check if player has the hitman trait - reduces alert chance by 50%
	private _traits = player getVariable ["Player_Traits", []];
	if ("hitman" in _traits) then {
		_alertChance = _alertChance - 50;
	};

	// Check if weapon has a suppressor - reduces alert chance by 35%
	private _currentWeapon = currentWeapon player;
	if (_currentWeapon != "") then {
		private _muzzleAttachment = player weaponAccessories _currentWeapon select 0;
		if (!isNil "_muzzleAttachment" && {_muzzleAttachment != ""}) then {
			// Check if attachment is a suppressor by checking config
			private _itemType = getNumber (configFile >> "CfgWeapons" >> _muzzleAttachment >> "ItemInfo" >> "type");
			// Type 101 = muzzle attachment (suppressors)
			if (_itemType == 101) then {
				_alertChance = _alertChance - 35;
			};
		};
	};

	// Roll for alert chance
	if ((random 100) > _alertChance) exitWith {};

    private _recent = false;
    {
        if (_pos distance _x < 100) exitWith { _recent = true };
    } forEach Recent_Shots;

    if (!_recent) then {
        [("STR_Common_FISD" call A3PL_Localize),("STR_A3PL_Illegal_Criminal_ShotsHeard" call A3PL_Localize), _pos, format[("STR_A3PL_Illegal_Criminal_ShotsHeardAt" call A3PL_Localize), [_pos] call A3PL_Housing_PosAddress], ("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch", 2];

        [("STR_A3PL_Illegal_Criminal_WarningShotsHeard" call A3PL_Localize), Color_Blue] call A3PL_Notification;

        Recent_Shots pushBack _pos;

        private _index = count Recent_Shots - 1;
        [] spawn {
            sleep 300;
            Recent_Shots deleteAt _index;
        };
    };
}] call compile_Global;

["A3PL_Criminal_Print", {
    private['_chance','_blueprints','_var'];
    _blueprints = ["blueprint_fisd","blueprinteq_fisd","blueprint_fifr"];
  	
  	_pCash = player getVariable ["player_cash",0];
    if (CopyBlueprint_Price > _pCash) exitwith {[format [("STR_A3PL_Illegal_Criminal_NeedMoneyForPhotocopy" call A3PL_Localize),CopyBlueprint_Price-_pCash],Color_Red] call A3PL_Notification;};

    if !(player_itemClass in _blueprints) exitWith {[("STR_A3PL_Illegal_Criminal_YouDontHaveBlueprintInHands" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    if (!Player_ActionCompleted) exitWith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};

    player setVariable ["player_cash",_pCash - CopyBlueprint_Price,true];

    Player_ActionCompleted = false;
    [("STR_A3PL_Illegal_Criminal_PhotocopyInProgress" call A3PL_Localize),10+random 2] spawn A3PL_Lib_LoadActionQTE;
    waitUntil {!Player_ActionCompleted};

    _var = player_itemClass;
    _chance = random(100);
    if(_chance > 25) then {
        [player_item] call A3PL_Inventory_Clear;
        [player, _var, +1] remoteExec ["Server_Inventory_Add", 2];
        [format[("STR_A3PL_Illegal_Criminal_YouSuccessfullyPhotocopied" call A3PL_Localize),_var],Color_Green] call A3PL_Notification;
    } else {
        [player_item] call A3PL_Inventory_Clear;
        [player, _var, -1] remoteExec ["Server_Inventory_Add", 2];
        [format[("STR_A3PL_Illegal_Criminal_YouFailedToPhotocopy" call A3PL_Localize),_var],Color_Red] call A3PL_Notification;
    };
}] call compile_Global;