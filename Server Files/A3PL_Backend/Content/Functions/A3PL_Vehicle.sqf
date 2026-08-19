/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Vehicle_OpenStorage",
{
	if(!([] call A3PL_Player_AntiSpam)) exitWith {};
	disableSerialization;
	private ["_veh","_display"];

	if((vehicle player) isEqualTo player) then {
		_veh = param[0,vehicle player];
	} else {
		_veh = param [0,player_objintersect];
	};

	if ((isNull _veh)) exitwith {[("STR_A3PL_Vehicle_NotAvailable" call A3PL_Localize)] call A3PL_Notification;};
	if (damage _veh isEqualTo 1) exitwith {["Ce véhicule a été détruit",Color_Red] call A3PL_Notification;};

	private _pos = getPos _veh;
	private _onWater = !(_pos isFlatEmpty [-1, -1, -1, -1, 2, false] isEqualTo []);
	if (_onWater && (_veh isKindOf "car")) exitWith {[("STR_A3PL_Vehicle_OnWater" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((typeOf _veh isNotEqualTo "A3PL_EMS_Locker") && {(count(nearestObjects[player, ["Land_A3PL_storage"], 8]) > 0)}) exitWith {[("STR_A3PL_Vehicle_FarGarageToOpenTrunk" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_veh getVariable ["inuse",false]) exitwith {[("STR_A3PL_Vehicle_InUse" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_veh setVariable ["inuse",true,true];

	if(((vehicle player) isEqualTo player) && (!(animationState player IN ["crew"]))) then {
		player playMove 'AmovPercMstpSnonWnonDnon_AinvPercMstpSnonWnonDnon';
	};

	createDialog "Dialog_VehicleStorage";

	_display = findDisplay 30;
	A3PL_Veh_Interact = _veh;

	[_display] call A3PL_Vehicle_StorageFillLB;
	_display displayAddEventHandler ["unload",{A3PL_Veh_Interact setVariable ["inuse",nil,true]; A3PL_Veh_Interact = nil;}];

	[] spawn {
		private _hndl = ppEffectCreate ['dynamicBlur', 505];
		_hndl ppEffectEnable true;
		_hndl ppEffectAdjust [5];
		_hndl ppEffectCommit 0;
		waitUntil {isNull findDisplay 30};
		ppEffectDestroy _hndl;
		closeDialog 0;
	};
	_veh spawn {
		private _maxDistance = if(_this isKindOf "Ship") then {20} else {8};
		while{(_this distance2D player) < _maxDistance} do {
			uiSleep 1;
		};
		closeDialog 0;
	};
}] call compile_Global;

["A3PL_Vehicle_AddToVehicle",
{
	private["_itemAmount","_vehicleStorage","_inventory"];
	disableSerialization;
	_display = findDisplay 30;

	if(!([] call A3PL_Player_AntiSpam)) exitWith {};

	_itemAmount = parseNumber (ctrlText 1400);
	if (_itemAmount < 1) exitwith {[("STR_Common_InvalidNumber" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_control = _display displayCtrl 1500;
	_index = lbCurSel _control;
	if (_control lbText _index == "") exitwith {[("STR_A3PL_Vehicle_SelectedInvalidItem" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_vehicleStorage = A3PL_Veh_Interact getVariable ["storage",[]];
	_inventory = player getVariable ["player_inventory",[]];

	if (_itemAmount > ((_inventory select _index) select 1)) exitwith {[("STR_A3PL_Vehicle_NotEnoughAmount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_itemClass = (_inventory select _index) select 0;

	_vehCapacity = [(typeOf A3PL_Veh_Interact)] call A3PL_Config_GetVehicleCapacity;
	_itemTotalWeight = ([_itemClass, 'weight'] call A3PL_Config_GetItem) * _itemAmount;
	_vehTotalWeight = [A3PL_Veh_Interact] call A3PL_Vehicle_TotalWeight;
	if ((_itemTotalWeight + _vehTotalWeight) > _vehCapacity) exitwith {[format [("STR_A3PL_Vehicle_InsufficientSpace" call A3PL_Localize)],Color_Red] call A3PL_Notification;};

	A3PL_Veh_Interact setVariable ["storage",([_vehicleStorage, _itemClass, _itemAmount,false] call BIS_fnc_addToPairs),true];
	player setVariable ["player_inventory",([_inventory, _itemClass, -(_itemAmount),false] call BIS_fnc_addToPairs),true];
	[] call A3PL_Inventory_Verify;
	[_display,A3PL_Veh_Interact] call A3PL_Vehicle_StorageFillLB;

	private _plate = (A3PL_Veh_Interact getVariable["owner",["",""]])#1;
	private _owner = (A3PL_Veh_Interact getVariable["owner",["",""]])#0;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Inv_Virtual_TrunkAdd",[format ["Item: %1 | Amount: %2 | Veh Plate: %3 | Veh Owner: %4",_itemClass,_itemAmount,_plate,_owner]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

["A3PL_Vehicle_TakeFromVehicle",
{
	disableSerialization;
	_display = findDisplay 30;

	if(!([] call A3PL_Player_AntiSpam)) exitWith {};

	_itemAmount = parseNumber (ctrlText 1401);
	if (_itemAmount < 1) exitwith {[("STR_Common_InvalidNumber" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if(((getPos A3PL_Veh_Interact) isFlatEmpty  [-1, -1, -1, -1, 2, false] isNotEqualTo []) && (A3PL_Veh_Interact isKindOf "car")) exitWith {[("STR_A3PL_Vehicle_OnWater" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_control = _display displayCtrl 1501;
	_index = lbCurSel _control;
	if (_control lbText _index == "") exitwith {[("STR_A3PL_Vehicle_SelectedInvalidItem" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_vehicleStorage = A3PL_Veh_Interact getVariable ["storage",[]];
	_inventory = player getVariable ["player_inventory",[]];

	if (_itemAmount > ((_vehicleStorage select _index) select 1)) exitwith {[("STR_A3PL_Vehicle_NotEnoughAmount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_itemClass = (_vehicleStorage select _index) select 0;

	if (([[_itemClass,_itemAmount]] call A3PL_Inventory_TotalWeight) > Player_MaxWeight) exitwith {[("STR_Common_NotEnoughSpace" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	// Verifier la place dans la grille d'inventaire virtuel
	if !([_itemClass, _itemAmount] call A3PL_InventoryNew_CanAddItem) exitWith {
		["STR_A3PL_Inventory_NotEnoughGridSpace" call A3PL_Localize, Color_Red] call A3PL_Notification;
	};

	A3PL_Veh_Interact setVariable ["storage",([_vehicleStorage, _itemClass, -(_itemAmount),false] call BIS_fnc_addToPairs),true];
	player setVariable ["player_inventory",([_inventory, _itemClass, _itemAmount,false] call BIS_fnc_addToPairs),true];
	[A3PL_Veh_Interact] call A3PL_Vehicle_StorageVerify;
	[] call A3PL_Inventory_Verify;
	[_display,A3PL_Veh_Interact] call A3PL_Vehicle_StorageFillLB;

	private _plate = (A3PL_Veh_Interact getVariable["owner",["",""]])#1;
	private _owner = (A3PL_Veh_Interact getVariable["owner",["",""]])#0;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Inv_Virtual_TrunkTake",[format ["Item: %1 | Amount: %2 | Veh Plate: %3 | Veh Owner: %4",_itemClass,_itemAmount,_plate,_owner]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

["A3PL_Vehicle_StorageVerify", {
	private ["_veh", "_index", "_forEachIndex","_change"];
	_veh = param [0,objNull];
	_change = false;
	{
		if ((_x select 1) < 1) then {
			_index = _forEachIndex;
			(_veh getVariable "storage") set [_index, "REMOVE"];
			_change = true;
		};
	} forEach (_veh getVariable "storage");

	if (_change) then
	{
		_veh setVariable ["storage", ((_veh getVariable "storage") - ["REMOVE"]), true];
	};
}] call compile_Global;

["A3PL_Vehicle_StorageFillLB",
{
	private ["_display","_control"];
	_display = param [0,displayNull];

	_totalWeight = [] call A3PL_Inventory_TotalWeight;
	_capacity = round((_totalWeight/Player_MaxWeight)*100);
	_capColor = switch(true) do {
		case (_capacity < 20): {"#00FF00"};
		case (_capacity >= 50): {"#FFFF00"};
		case (_capacity >= 75): {"#FFA500"};
		case (_capacity >= 100): {"#ff0000"};
		default {"#ffffff"};
	};
	_control = _display displayCtrl 1100;
	_control ctrlSetStructuredText parseText format[("STR_A3PL_Vehicle_Inventory" call A3PL_Localize), _capacity, "%", _capColor];

	_vehTotalWeight = [A3PL_Veh_Interact] call A3PL_Vehicle_TotalWeight;
	_vehCapacity = [(typeOf A3PL_Veh_Interact)] call A3PL_Config_GetVehicleCapacity;
	_capacity = round((_vehTotalWeight/_vehCapacity)*100);
	_capColor = switch(true) do {
		case (_capacity < 20): {"#00FF00"};
		case (_capacity >= 50): {"#FFFF00"};
		case (_capacity >= 75): {"#FFA500"};
		case (_capacity >= 100): {"#ff0000"};
		default {"#ffffff"};
	};
	_control = _display displayCtrl 1101;
	_control ctrlSetStructuredText parseText format[("STR_A3PL_Vehicle_Vehicle" call A3PL_Localize), _capacity, "%", _capColor];

	_control = _display displayCtrl 1500;
	lbClear _control;
	{
		private ["_itemName", "_amount", "_index","_itemWeight"];
		_itemName = [_x select 0, "name"] call A3PL_Config_GetItem;
		_amount = _x select 1;
		_itemWeight = ([_x select 0, "weight"] call A3PL_Config_GetItem) * _amount;
		_itempicture = [_x select 0, "picture"] call A3PL_Config_GetItem;

		_index = _control lbAdd format["%2 %1 (%3 lbs)", _itemName, _amount, _itemWeight];
		_control lbSetData [_index, _x select 0];
		_control lbSetPicture [_index,_itempicture];
	} forEach ([] call A3PL_Inventory_Get);

	_vehInventory = A3PL_Veh_Interact getVariable["storage",[]];
	_control = _display displayCtrl 1501;
	lbClear _control;
	{
		private ["_itemName", "_amount", "_index","_itemWeight"];
		_itemName = [_x select 0, "name"] call A3PL_Config_GetItem;
		_amount = _x select 1;
		_itemWeight = ([_x select 0, "weight"] call A3PL_Config_GetItem) * _amount;
		_itempicture = [_x select 0, "picture"] call A3PL_Config_GetItem;

		_index = _control lbAdd format["%2 %1 (%3 lbs)", _itemName, _amount, _itemWeight];
		_control lbSetData [_index, _x select 0];
		_control lbSetPicture [_index,_itempicture];
	} forEach _vehInventory;
}] call compile_Global;

["A3PL_Vehicle_TotalWeight",
{
	private _veh = param [0,objNull];
	private _return = 0;
	private _inventory = _veh getVariable["storage",[]];
	{
		private ["_amount", "_itemWeight"];
		_amount = _x select 1;
		_itemWeight = ([_x select 0, 'weight'] call A3PL_Config_GetItem) * _amount;
		_return = _return + _itemWeight;
	} forEach _inventory;
	_return;
}] call compile_Global;

["A3PL_Vehicle_AddKey",
{
	private _veh = param [0,objNull];
	private _add = param [1,true];
	if(_add) then {
		if(_veh IN A3PL_Player_Vehicles) exitWith {};
		A3PL_Player_Vehicles pushback _veh;
		[format[("STR_A3PL_Vehicle_KeyReceived" call A3PL_Localize),getText(configFile >> "CfgVehicles" >> (typeOf _veh) >> "displayName")],Color_Green] call A3PL_Notification;
	} else {
		A3PL_Player_Vehicles = A3PL_Player_Vehicles - [_veh];
	};
	[A3PL_Player_Vehicles, (player getVariable ["character_id",""])] remoteExec ["Server_Vehicle_SaveKeys",2];
	[] call A3PL_Vehicle_KeysVerify;
}] call compile_Global;

["A3PL_Vehicle_SetAllKeys",
{
	private _keys = param [0,[]];
	{
		A3PL_Player_Vehicles pushBack _x;
	} forEach _keys;
	[] call A3PL_Vehicle_KeysVerify;
}] call compile_Global;

["A3PL_Vehicle_KeysVerify",
{
	private _tmp = A3PL_Player_Vehicles;
	{
		if((isNull _x)) then {
			_tmp deleteAt _forEachIndex;
		};
	} forEach A3PL_Player_Vehicles;
	A3PL_Player_Vehicles = _tmp;
}] call compile_Global;

//This function clears all soundSources from an object
//[_veh,true] call A3PL_Vehicle_SoundSourceClear <- that will clear all siren objects from vehicle
//[_veh,false,true] call A3PL_Vehicle_SoundSourceClear <- that will clear only manual siren object from vehicle
//[_veh,false,false] call A3PL_Vehicle_SoundSourceClear <- that will clear only the siren object from vehicle
["A3PL_Vehicle_SoundSourceClear",
{
	private ["_veh"];
	_veh = param [0,objNull];
	_clearAll = param [1,true];
	_clearManual = param [2,true];
	_clearAnim = param [3,true];

	if (_clearAnim) exitwith {
		{deleteVehicle _x} forEach (_veh getVariable "SoundSource");
		_veh animate ["SoundSource_1",0, true];_veh animate ["SoundSource_2",0, true];
		_veh animate ["SoundSource_3",0, true];_veh animate ["SoundSource_4",0, true];
		_veh animate ["SoundSource_5",0, true];_veh animate ["SoundSource_6",0, true];
		_veh animate ["SoundSource_7",0, true];_veh animate ["SoundSource_8",0, true];
		_veh animate ["SoundSource_9",0, true];_veh animate ["SoundSource_10",0, true];
		_veh animate ["SoundSource_11",0, true];_veh animate ["SoundSource_12",0, true];
		_veh animate ["SoundSource_13",0, true];_veh animate ["SoundSource_14",0, true];
		_veh animate ["SoundSource_15",0, true];_veh animate ["SoundSource_16",0, true];
		_veh animate ["SoundSource_17",0, true];_veh animate ["SoundSource_18",0, true];
		_veh animate ["SoundSource_19",0, true];_veh animate ["SoundSource_20",0, true];
	};
	if (_clearAll) exitwith {
		{
			if ((typeOf _x) == "#dynamicSound") then {deleteVehicle _x;};
		} forEach (attachedObjects _veh);
	};
	if (_clearManual) then {
		deleteVehicle (_veh getVariable ["manual",objNull]); //We have to do it this way because setVariable doesn't work on soundSources... retarded and causes siren getting stuck on rare occasions
	} else {
		deleteVehicle (_veh getVariable ["siren",objNull]);
	};
}] call compile_Global;

["A3PL_Vehicle_SoundSourceCreate",
{
	private ["_Siren","_SoundSource_1","_SoundSource_2","_SoundSource_3","_SoundSource_4","_SoundSource_5"];
	private _veh = _this;
	private _classname = typeOf _veh;
	if(_classname isEqualTo "C_man_1") exitwith {
		[getPlayerUID player,(player getVariable ["character_id",""]),"BugAttempt_Sirens",[format ["Help Me: %1","Step Fronk"]]] remoteExec ["Server_Log_New",2];
		['STR_A3PL_Vehicle_CantActivateSiren' call A3PL_Localize,Color_Red] call A3PL_Notification;
	};
	private _sirenType = switch (true) do
	{
		case (_classname IN ["A3PL_Pierce_Rescue","A3PL_Pierce_Pumper","A3PL_Pierce_Ladder","A3PL_Pierce_Heavy_Ladder","A3FL_T440_Water_Tanker"]): {"fire"};
		case (_classname IN ["A3FL_F150_FD","A3FL_Explorer_Platinum_FD_20","A3PL_Tahoe_FD","A3FL_Taurus_FD","A3PL_Silverado_FD","A3PL_Silverado_FD_Brush","A3PL_Charger15_FD","A3FL_Tahoe_FD","EC_F450_Brush","EC_Explorer19_FD","EC_Charger_Hellcat_20_FD","A3PL_CVPI_FD","EC_DodgeRam_FD"]): {"fire_FR"};
		case (_classname IN ["Jonzie_Ambulance","A3PL_E350","EC_E350_A","EC_F150_A"]): {"ems"};
		case (_classname IN ["A3FL_T440_Tow_Truck","A3PL_P362_TowTruck","A3PL_F150_Marker","A3FL_F150_ML","A3PL_Silverado_ML","A3FL_E350_ML","A3PL_Ram_ML"]): {"civ"};
		default {"police"};
	};
	switch (_sirenType) do
	{
		case "police":
		{
			_SoundSource_1 = createSoundSource ["A3FL_FSUTD_1", [0,0,0], [], 0];
			_SoundSource_1 attachTo [_veh, [0,0,0], "SoundSource_1"];
			_SoundSource_2 = createSoundSource ["A3FL_FSUTD_5", [0,0,0], [], 0];
			_SoundSource_2 attachTo [_veh, [0,0,0], "SoundSource_2"];
			_SoundSource_3 = createSoundSource ["A3FL_Priority", [0,0,0], [], 0];
			_SoundSource_3 attachTo [_veh, [0,0,0], "SoundSource_3"];
			_SoundSource_4 = createSoundSource ["A3FL_FSUTD_2", [0,0,0], [], 0];
			_SoundSource_4 attachTo [_veh, [0,0,0], "SoundSource_4"];
			_SoundSource_5 = createSoundSource ["A3FL_FSUTD_3", [0,0,0], [], 0];
			_SoundSource_5 attachTo [_veh, [0,0,0], "SoundSource_5"];
			_Siren = [_SoundSource_1,_SoundSource_2,_SoundSource_3,_SoundSource_4,_SoundSource_5];
			_veh setVariable ["SoundSource",_Siren,true];
		};
		case "fire":
		{
			_SoundSource_1 = createSoundSource ["A3PL_EQ2B_Wail", [0,0,0], [], 0];
			_SoundSource_1 attachTo [_veh, [0,0,0], "SoundSource_1"];
			_SoundSource_2 = createSoundSource ["A3PL_Whelen_Warble", [0,0,0], [], 0];
			_SoundSource_2 attachTo [_veh, [0,0,0], "SoundSource_2"];
			_SoundSource_3 = createSoundSource ["A3PL_AirHorn_1", [0,0,0], [], 0];
			_SoundSource_3 attachTo [_veh, [0,0,0], "SoundSource_3"];
			_Siren = [_SoundSource_1,_SoundSource_2,_SoundSource_3];
			_veh setVariable ["SoundSource",_Siren,true];
		};
		case "fire_FR":
		{
			_SoundSource_1 = createSoundSource ["A3PL_FSUO_Siren", [0,0,0], [], 0];
			_SoundSource_1 attachTo [_veh, [0,0,0], "SoundSource_1"];
			_SoundSource_2 = createSoundSource ["A3PL_Whelen_Priority3", [0,0,0], [], 0];
			_SoundSource_2 attachTo [_veh, [0,0,0], "SoundSource_2"];
			_SoundSource_3 = createSoundSource ["A3PL_FIPA20A_Priority", [0,0,0], [], 0];
			_SoundSource_3 attachTo [_veh, [0,0,0], "SoundSource_3"];
			_SoundSource_4 = createSoundSource ["A3PL_Electric_Horn", [0,0,0], [], 0];
			_SoundSource_4 attachTo [_veh, [0,0,0], "SoundSource_4"];
			_Siren = [_SoundSource_1,_SoundSource_2,_SoundSource_3,_SoundSource_4];
			_veh setVariable ["SoundSource",_Siren,true];
		};
		case "ems": {
            private _SoundSource_1 = createSoundSource ["A3PL_EQ2B_Wail", [0,0,0], [], 0];
            _SoundSource_1 attachTo [_veh, [0,0,0], "SoundSource_1"];
			private _SoundSource_2 = createSoundSource ["A3PL_Whelen_Siren", [0,0,0], [], 0];
			_SoundSource_2 attachTo [_veh, [0,0,0], "SoundSource_2"];
			private _SoundSource_3 = createSoundSource ["A3PL_AirHorn_1", [0,0,0], [], 0];
			_SoundSource_3 attachTo [_veh, [0,0,0], "SoundSource_3"];
			private _SoundSource_4 = createSoundSource ["A3PL_Whelen_Warble", [0,0,0], [], 0];
			_SoundSource_4 attachTo [_veh, [0,0,0], "SoundSource_4"];
			private _SoundSource_5 = createSoundSource ["A3PL_Whelen_Priority", [0,0,0], [], 0];
			_SoundSource_5 attachTo [_veh, [0,0,0], "SoundSource_5"];
			private _SoundSource_6 = createSoundSource ["A3PL_Electric_Horn", [0,0,0], [], 0];
			_SoundSource_6 attachTo [_veh, [0,0,0], "SoundSource_6"];
			private _Siren = [_SoundSource_1,_SoundSource_2,_SoundSource_3,_SoundSource_4,_SoundSource_5,_SoundSource_6];
			_veh setVariable ["SoundSource",_Siren,true];
		};
	};
}] call compile_Global;

["A3PL_Vehicle_ELS_PlaySound",
{
	params [["_veh", objNull], ["_soundName", ""]];
	if (isNull _veh || _soundName isEqualTo "") exitWith {};
	playSound3D [format["A3PL_Common\ELS\%1.ogg", _soundName], _veh, false, getPosASL _veh, 5, 1, 50];
}] call compile_Global;

["A3PL_Vehicle_SirenHotkey",
{
	if (player getVariable ["Cuffed",false] or player getVariable ["Zipped",false]) exitWith{};
	params[["_action",0,[0]]];
	private _veh = vehicle player;
	private _classname = typeOf _veh;
	private _sirenType = switch (true) do
	{
		case (_classname IN ["A3PL_Pierce_Rescue","A3PL_Pierce_Pumper","A3PL_Pierce_Ladder","A3PL_Pierce_Heavy_Ladder","A3FL_T440_Water_Tanker"]): {"fire"};
		case (_classname IN ["A3FL_F150_FD","A3FL_Explorer_Platinum_FD_20","A3PL_Tahoe_FD","A3FL_Taurus_FD","A3PL_Silverado_FD","A3PL_Silverado_FD_Brush","A3PL_Charger15_FD","A3FL_Tahoe_FD","EC_F450_Brush","EC_Explorer19_FD","EC_Charger_Hellcat_20_FD","A3PL_CVPI_FD","EC_DodgeRam_FD"]): {"fire_FR"};
		case (_classname IN ["Jonzie_Ambulance","A3PL_E350","EC_E350_A","EC_F150_A"]): {"ems"};
		case (_classname IN ["A3FL_T440_Tow_Truck","A3PL_P362_TowTruck","A3PL_F150_Marker","A3FL_F150_ML","A3PL_Silverado_ML","A3FL_E350_ML","A3PL_Ram_ML"]): {"civ"};
		default {"police"};
	};
	
	private _currentCode = _veh getVariable ["A3PL_ELS_CurrentCode", 0];
	private _newCode = _currentCode;
	switch (_sirenType) do
	{
		case "police":
		{
			switch (_action) do
			{
				case 1 :
				{
					_newCode = 0;
					[_veh,false,false,true] call A3PL_Vehicle_SoundSourceClear;
					_veh call A3PL_Vehicle_SoundSourceCreate;
					_veh animate ["Siren_Control_Switch",0];
					_veh animate ["Directional_Switch",0];
					_veh animate ["Directional_F",0];
					if (_veh animationSourcePhase "lightbar" > 0.5) then
					{
						_veh animateSource ["Lightbar",0];
					};
				};
				case 2 :
				{
					if (_veh animationSourcePhase "lightbar" > 0.5) then
					{
						_newCode = 0;
						[_veh,false,false,true] call A3PL_Vehicle_SoundSourceClear;
						_veh call A3PL_Vehicle_SoundSourceCreate;
						_veh animate ["Directional_Switch",1];
						_veh animate ["Directional_F",1];
					} else
					{
						_newCode = 2;
						_veh animateSource ["Lightbar",1];
						player action ["lightOn",_veh];
						_veh animate ["Directional_Switch",1];
						_veh animate ["Directional_F",1];
					};
				};
				case 3 :
				{
					_newCode = 3;
					[_veh,false,false,true] call A3PL_Vehicle_SoundSourceClear;

					_veh call A3PL_Vehicle_SoundSourceCreate;
					_veh animateSource ["Lightbar",1];
					player action ["lightOn",_veh];
					_veh animate ["Siren_Control_Switch",1];
					_veh animate ["Siren_Control_Noob",12];
					_veh animate ["SoundSource_1",1, true];
					_veh animate ["Directional_Switch",1];
					_veh animate ["Directional_F",1];
				};
				case 4 :
				{
					if (_veh animationPhase "SoundSource_2" == 0) then
					{
						_veh animate ["SoundSource_2",1, true];
						_veh animate ["FT_Switch_36",1];
						[_veh, "press"] call A3PL_Vehicle_ELS_PlaySound;
					}else
					{
						_veh animate ["SoundSource_2",0, true];
						_veh animate ["FT_Switch_36",0];
						[_veh, "release"] call A3PL_Vehicle_ELS_PlaySound;
					};
				};
				case 5 :
				{
					if (_veh animationPhase "SoundSource_3" == 0) then
					{
						_veh animate ["SoundSource_3",1, true];
						_veh animate ["FT_Switch_36",1];
						[_veh, "press"] call A3PL_Vehicle_ELS_PlaySound;
					}else
					{
						_veh animate ["SoundSource_3",0, true];
						_veh animate ["FT_Switch_36",0];
						[_veh, "release"] call A3PL_Vehicle_ELS_PlaySound;
					};
				};
				case 6 :
				{
					if (_veh animationPhase "SoundSource_4" < 0.5) then
					{
						_veh animate ["SoundSource_4",1, true];
						_veh animate ["FT_Switch_37",1];
						[_veh, "press"] call A3PL_Vehicle_ELS_PlaySound;
					}else
					{
						_veh animate ["SoundSource_4",0, true];
						_veh animate ["FT_Switch_37",0];
						[_veh, "release"] call A3PL_Vehicle_ELS_PlaySound;
					};
				};
				case 7 :
				{
					if (_veh animationPhase "SoundSource_5" < 0.5) then
					{
						_veh animate ["SoundSource_5",1, true];
						_veh animate ["FT_Switch_38",1];
						[_veh, "press"] call A3PL_Vehicle_ELS_PlaySound;
					}else
					{
						_veh animate ["SoundSource_5",0, true];
						_veh animate ["FT_Switch_38",0];
						[_veh, "release"] call A3PL_Vehicle_ELS_PlaySound;
					};
				};
			};
		};
		case "ems":
		{
			switch (_action) do
			{
				case 1 :
				{
					_newCode = 0;
					[_veh,false,false,true] call A3PL_Vehicle_SoundSourceClear;
					_veh call A3PL_Vehicle_SoundSourceCreate;
					_veh animate ["Siren_Control_Switch",0];
					_veh animate ["Directional_Switch",0];
					_veh animate ["Directional_F",0];
					if (_veh animationSourcePhase "lightbar" > 0.5) then
					{
						_veh animateSource ["Lightbar",0];
					};
				};
				case 2 :
				{
					if (_veh animationSourcePhase "lightbar" > 0.5) then
					{
						_newCode = 0;
						[_veh,false,false,true] call A3PL_Vehicle_SoundSourceClear;
						_veh call A3PL_Vehicle_SoundSourceCreate;
						_veh animate ["Directional_Switch",1];
						_veh animate ["Directional_F",1];
					} else
					{
						_newCode = 2;
						_veh animateSource ["Lightbar",1];
						player action ["lightOn",_veh];
						_veh animate ["Directional_Switch",1];
						_veh animate ["Directional_F",1];
					};
				};
				case 3 :
				{
					_newCode = 3;
					[_veh,false,false,true] call A3PL_Vehicle_SoundSourceClear;
					_veh call A3PL_Vehicle_SoundSourceCreate;
					_veh animateSource ["Lightbar",1];
					player action ["lightOn",_veh];
					_veh animate ["Siren_Control_Switch",1];
					_veh animate ["Siren_Control_Noob",12];
					_veh animate ["SoundSource_1",1, true];
					_veh animate ["Directional_Switch",1];
					_veh animate ["Directional_F",1];
				};
				case 4 :
				{
					if (_veh animationPhase "SoundSource_2" < 0.5 && {!A3PL_Manual_KeyDown}) then
					{
						_veh animate ["SoundSource_2",1, true];
						_veh animate ["FT_Switch_36",1];
						[_veh, "press"] call A3PL_Vehicle_ELS_PlaySound;
					}else
					{
						_veh animate ["SoundSource_2",0, true];
						_veh animate ["FT_Switch_36",0];
						[_veh, "release"] call A3PL_Vehicle_ELS_PlaySound;
					};
				};
				case 5 :
				{
					if (_veh animationPhase "SoundSource_3" < 0.5 && {!A3PL_Manual_KeyDown}) then
					{
						_veh animate ["SoundSource_3",1, true];
						_veh animate ["FT_Switch_36",1];
						[_veh, "press"] call A3PL_Vehicle_ELS_PlaySound;
					}else
					{
						_veh animate ["SoundSource_3",0, true];
						_veh animate ["FT_Switch_36",0];
						[_veh, "release"] call A3PL_Vehicle_ELS_PlaySound;
					};
				};
				case 6 :
				{
					if (_veh animationPhase "SoundSource_4" > 0.5 && {!A3PL_Manual_KeyDown}) then
					{
						_veh animate ["SoundSource_4",1, true];
						_veh animate ["FT_Switch_37",1];
						[_veh, "press"] call A3PL_Vehicle_ELS_PlaySound;
					}else
					{
						_veh animate ["SoundSource_4",0, true];
						_veh animate ["FT_Switch_37",0];
						[_veh, "release"] call A3PL_Vehicle_ELS_PlaySound;
					};
				};
				case 7 :
				{
					if (_veh animationPhase "SoundSource_5" < 0.5) then
					{
						_veh animate ["SoundSource_5",1, true];
						_veh animate ["FT_Switch_38",1];
						[_veh, "press"] call A3PL_Vehicle_ELS_PlaySound;
					}else
					{
						_veh animate ["SoundSource_5",0, true];
						_veh animate ["FT_Switch_38",0];
						[_veh, "release"] call A3PL_Vehicle_ELS_PlaySound;
					};
				};
			};
		};
		case "fire_FR":
		{
			switch (_action) do
			{
				case 1 :
				{
					_newCode = 0;
					[_veh,false,false,true] call A3PL_Vehicle_SoundSourceClear;
					_veh call A3PL_Vehicle_SoundSourceCreate;
					_veh animate ["Siren_Control_Switch",0];
					_veh animate ["Directional_Switch",0];
					_veh animate ["Directional_F",0];
					if (_veh animationSourcePhase "lightbar" > 0.5) then
					{
						_veh animateSource ["Lightbar",0];
					};
				};
				case 2 :
				{
					if (_veh animationSourcePhase "lightbar" > 0.5) then
					{
						_newCode = 0;
						[_veh,false,false,true] call A3PL_Vehicle_SoundSourceClear;
						_veh call A3PL_Vehicle_SoundSourceCreate;
						_veh animate ["Directional_Switch",1];
						_veh animate ["Directional_F",1];
					} else
					{
						_newCode = 2;
						_veh animateSource ["Lightbar",1];
						player action ["lightOn",_veh];
						_veh animate ["Directional_Switch",1];
						_veh animate ["Directional_F",1];
					};
				};
				case 3 :
				{
					_newCode = 3;
					[_veh,false,false,true] call A3PL_Vehicle_SoundSourceClear;
					_veh call A3PL_Vehicle_SoundSourceCreate;
					_veh animateSource ["Lightbar",1];
					player action ["lightOn",_veh];
					_veh animate ["Siren_Control_Switch",1];
					_veh animate ["Siren_Control_Noob",12];
					_veh animate ["SoundSource_1",1, true];
					_veh animate ["Directional_Switch",1];
					_veh animate ["Directional_F",1];
				};
				case 4 :
				{
					if (_veh animationPhase "SoundSource_2" < 0.5 && {!A3PL_Manual_KeyDown}) then
					{
						_veh animate ["SoundSource_2",1, true];
						_veh animate ["FT_Switch_36",1];
						[_veh, "press"] call A3PL_Vehicle_ELS_PlaySound;
					}else
					{
						_veh animate ["SoundSource_2",0, true];
						_veh animate ["FT_Switch_36",0];
						[_veh, "release"] call A3PL_Vehicle_ELS_PlaySound;
					};
				};
				case 5 :
				{
					if (_veh animationPhase "SoundSource_3" < 0.5 && {!A3PL_Manual_KeyDown}) then
					{
						_veh animate ["SoundSource_3",1, true];
						_veh animate ["FT_Switch_36",1];
						[_veh, "press"] call A3PL_Vehicle_ELS_PlaySound;
					}else
					{
						_veh animate ["SoundSource_3",0, true];
						_veh animate ["FT_Switch_36",0];
						[_veh, "release"] call A3PL_Vehicle_ELS_PlaySound;
					};
				};
				case 6 :
				{
					if (_veh animationPhase "SoundSource_4" > 0.5 && {!A3PL_Manual_KeyDown}) then
					{
						_veh animate ["SoundSource_4",1, true];
						_veh animate ["FT_Switch_37",1];
						[_veh, "press"] call A3PL_Vehicle_ELS_PlaySound;
					}else
					{
						_veh animate ["SoundSource_4",0, true];
						_veh animate ["FT_Switch_37",0];
						[_veh, "release"] call A3PL_Vehicle_ELS_PlaySound;
					};
				};
			};
		};
		case "fire":
		{
			switch (_action) do
			{
				case 1 :
				{
					_newCode = 0;
					[_veh,false,false,true] call A3PL_Vehicle_SoundSourceClear;
					_veh call A3PL_Vehicle_SoundSourceCreate;
					_veh animate ["Siren_Control_Switch",0];
					if (_veh animationSourcePhase "lightbar" > 0.5) then
					{
						_veh animateSource ["Lightbar",0];
						_veh animate ["Directional_Switch",0];
						_veh animate ["Directional_F",0];
					};
				};
				case 2 :
				{
					if (_veh animationSourcePhase "lightbar" > 0.5) then
					{
						_newCode = 0;
						[_veh,false,false,true] call A3PL_Vehicle_SoundSourceClear;
						_veh call A3PL_Vehicle_SoundSourceCreate;
						_veh animate ["Directional_Switch",1];
						_veh animate ["Directional_F",1];
					} else
					{
						_newCode = 2;
						_veh animateSource ["Lightbar",1];
						player action ["lightOn",_veh];
						_veh animate ["Directional_Switch",1];
						_veh animate ["Directional_F",1];
					};
				};
				case 3 :
				{
					_newCode = 3;
					[_veh,false,false,true] call A3PL_Vehicle_SoundSourceClear;
					_veh call A3PL_Vehicle_SoundSourceCreate;
					_veh animateSource ["Lightbar",1];
					player action ["lightOn",_veh];
					_veh animate ["Siren_Control_Switch",1];
					_veh animate ["Siren_Control_Noob",12];
					_veh animate ["SoundSource_1",1, true];
				};
				case 4 :
				{
					if (_veh animationPhase "SoundSource_2" < 0.5) then
					{
						_veh animate ["SoundSource_2",1, true];
						_veh animate ["FT_Switch_36",1];
						[_veh, "press"] call A3PL_Vehicle_ELS_PlaySound;
					}else
					{
						_veh animate ["SoundSource_2",0, true];
						_veh animate ["FT_Switch_36",0];
						[_veh, "release"] call A3PL_Vehicle_ELS_PlaySound;
					};
				};
				case 5 :
				{
					if (_veh animationPhase "SoundSource_3" < 0.5 && {!A3PL_Manual_KeyDown}) then
					{
						_veh animate ["SoundSource_3",1, true];
						_veh animate ["FT_Switch_36",1];
						[_veh, "press"] call A3PL_Vehicle_ELS_PlaySound;
					}else
					{
						_veh animate ["SoundSource_3",0, true];
						_veh animate ["FT_Switch_36",0];
						[_veh, "release"] call A3PL_Vehicle_ELS_PlaySound;
					};
				};
			};
		};
		case "civ":
		{
			switch (_action) do
			{
				case 1 :
				{
					[_veh,false,false,true] call A3PL_Vehicle_SoundSourceClear;
					_veh animate ["Siren_Control_Switch",0];
					_veh animate ["Directional_Switch",0];
					_veh animate ["Directional_F",0];
					if (_veh animationSourcePhase "lightbar" > 0.5) then
					{
						_veh animateSource ["Lightbar",0];
					};
				};
				case 2 :
				{
					if (_veh animationSourcePhase "lightbar" > 0.5) then
					{
						[_veh,false,false,true] call A3PL_Vehicle_SoundSourceClear;
						_veh animate ["Directional_Switch",0];
						_veh animate ["Directional_F",0];
					} else
					{
						_veh animateSource ["Lightbar",1];
						player action ["lightOn",_veh];
						_veh animate ["Directional_Switch",1];
						_veh animate ["Directional_F",1];
					};
				};
			};
		};
		case "Ship":
		{
			switch (_action) do
			{
				case 1 :
				{
					if (_veh animationPhase "SoundSource_1" > 0.5) then
					{
						_veh animateSource ["Lightbar",0];
					};
				};
				case 2 :
				{
					if (_veh animationPhase "SoundSource_1" < 0.5) then
					{
						_veh animate ["SoundSource_1",1, true];
					};
				};
			};
		};
	};
	
	if (_newCode != _currentCode && _action <= 3) then
	{
		switch (true) do
		{
			case (_newCode == 0):
			{
				[_veh, "off"] call A3PL_Vehicle_ELS_PlaySound;
			};
			case (_currentCode == 0 && _newCode == 2):
			{
				[_veh, "on"] call A3PL_Vehicle_ELS_PlaySound;
			};
			case (_currentCode == 0 && _newCode == 3):
			{
				[_veh, "on"] call A3PL_Vehicle_ELS_PlaySound;
			};
			case (_currentCode == 2 && _newCode == 3):
			{
				[_veh, "upgrade"] call A3PL_Vehicle_ELS_PlaySound;
			};
			case (_currentCode == 3 && _newCode == 2):
			{
				[_veh, "downgrade"] call A3PL_Vehicle_ELS_PlaySound;
			};
		};
		_veh setVariable ["A3PL_ELS_CurrentCode", _newCode, true];
	};
}] call compile_Global;

["A3PL_Vehicle_Repair",
{
    private _car = param [0, objNull];
    private _damage = getAllHitPointsDamage _car;
    if (isNull _car) exitWith {};
    if (!(vehicle player isEqualTo player)) exitWith {
        [("STR_A3PL_Vehicle_CantRepairInside" call A3PL_Localize), Color_Red] call A3PL_Notification;
    };
    if (Player_ActionDoing) exitWith {
        [("STR_Common_ActionAlreadyInProgress" call A3PL_Localize), Color_Red] call A3PL_Notification;
    };

    [_car, player] remoteExec ["A3PL_Lib_ChangeLocality", 2];
    [("STR_A3PL_Vehicle_Repairing" call A3PL_Localize), 30] spawn A3PL_Lib_LoadAction;
    waitUntil {Player_ActionDoing};
    player playMoveNow 'Acts_carFixingWheel';
    while {Player_ActionDoing} do {
        if ((player distance2D _car) > 15) exitWith {Player_ActionInterrupted = true};
        if (!(player getVariable ["A3PL_Medical_Alive", true])) exitWith {Player_ActionInterrupted = true;};
        if ((vehicle player) != player) exitWith {Player_ActionInterrupted = true;};
        if (player getVariable ["Incapacitated", false]) exitWith {Player_ActionInterrupted = true;};
        if (!(player_itemClass isEqualTo "repairwrench")) exitWith {Player_ActionInterrupted = true;};
        if ((animationState player) != "Acts_carFixingWheel") then {
            player playMoveNow 'Acts_carFixingWheel';
        };
    };

    [player, ""] remoteExec ["A3PL_Lib_SyncAnim", 0];
    if (Player_ActionInterrupted) exitWith {
        [("STR_A3PL_Vehicle_RepairFailed" call A3PL_Localize), Color_Red] call A3PL_Notification;
    };

    private _damageValue = 0.7;

    _car setDamage _damageValue;

    [("STR_A3PL_Vehicle_RepairSuccessPartial" call A3PL_Localize), Color_Green] call A3PL_Notification;

    [player_item] call A3PL_Inventory_Clear;
    [player, "repairwrench", -1] remoteExec ["Server_Inventory_Add", 2];
}] call compile_Global;

["A3PL_Vehicle_Trailer_Unhitch",
{
	private _trailer = _this select 0;
	private _TruckArray = nearestObjects [(_trailer modelToWorld [0,3,0]), A3PL_HitchingVehicles, 7];
	if ((count _TruckArray) isEqualTo 0) exitwith {[("STR_A3PL_Vehicle_NoVehiclesNearby" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _truck = _TruckArray select 0;
	[_trailer] remoteExec ["Server_Vehicle_EnableSimulation", 2];
	[_truck] remoteExec ["Server_Vehicle_EnableSimulation", 2];
	_trailer animateSource ["Hitched",0,true];
	_truck animateSource ["Hitched",0,true];
	[_trailer] remoteExec ["Server_Vehicle_EnableSimulation", 2];
	[_truck] remoteExec ["Server_Vehicle_EnableSimulation", 2];
}] call compile_Global;

["A3PL_Vehicle_Trailer_Hitch", {
	private _trailer = param [0,objNull];
	private _offset = 3;
	private _ramp = false;
	if (typeOf _trailer IN ["A3PL_Lowloader"]) then {
		_offset = 5;
		if (_trailer animationPhase "ramp" > 0) then {_ramp = true;};
	};
	if (_ramp) exitwith {[("STR_A3PL_Vehicle_RaiseRampFirst" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _TruckArray = nearestObjects [(_trailer modelToWorld [0,_offset,0]), A3PL_HitchingVehicles, 16.5];
	{
		if (typeOf _x IN ["Jonzie_Ambulance","A3PL_E350"]) then {
			_TruckArray = _TruckArray - [_x];
		};
	} forEach _TruckArray;
	if (count _TruckArray isEqualTo 0) exitwith {[("STR_A3PL_Vehicle_NoVehiclesNearby" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _truck = _truckArray select 0;
	_truck allowDamage false;

	if !(local _truck) then {
		[_truck,player] remoteExec ["A3PL_Lib_ChangeLocality",2];
	};

	if !(local _trailer) then {
		[_trailer,player] remoteExec ["A3PL_Lib_ChangeLocality",2];
	};

	switch(typeOf _trailer) do {
		case "A3PL_Lowloader": {
			_trailer attachTo [_truck, [0, -6.185, -0.2]];
			detach _trailer;
		};
		case "A3PL_Tanker_Trailer": {
			_trailer attachTo [_truck, [0, -6.9, -0.05]];
			detach _trailer;
		};
		case "A3PL_Box_Trailer": {
			_trailer attachTo [_truck, [0, -7.9, -0.05]];
			detach _trailer;
		};
		case "A3PL_Car_Trailer": {
			switch (true) do {
				case (typeOf _truck isEqualTo "A3PL_Ram"): {
					_trailer attachTo [_truck, [0, -7.55, -0.85]];
				};
				case (typeOf _truck IN ["A3PL_F150"]): {
					_trailer attachTo [_truck, [0, -7.73, -0.28]];
				};
				case (typeOf _truck IN ["A3FL_F150","A3FL_F150_ML"]): {
					_trailer attachTo [_truck, [0, -7.7, -0.0]];
				};
				case (typeOf _truck IN ["A3PL_F150_Marker"]): {
					_trailer attachTo [_truck, [0, -8.05, 1.27]];
				};
				case (typeOf _truck IN ["A3PL_Silverado","A3PL_Silverado_PD","A3PL_Silverado_PD_ST","A3PL_Silverado_FD"]): {
					_trailer attachTo [_truck, [0, -7.95, 1.45]];
				};
				case (typeOf _truck IN ["A3PL_Tahoe","A3PL_Tahoe_PD","A3PL_Tahoe_FD"]): {
					_trailer attachTo [_truck, [0, -7.5, -0.13]];
				};
				case (typeOf _truck isEqualTo "A3PL_Wrangler"): {
					_trailer attachTo [_truck, [0, -7.08, -0.9]];
				};
				case (typeOf _truck IN ["A3PL_Charger15","A3PL_Charger15_PD","A3PL_Charger15_PD_ST","A3PL_Charger15_FD"]): {
					_trailer attachTo [_truck, [0, -7.8, 1.34]];
				};
			};
		};
		case "A3PL_Drill_Trailer": {
			switch (true) do {
				case (typeOf _truck isEqualTo "A3PL_Ram"): {
					_trailer attachTo [_truck, [0, -4.485, -0.85]];
				};
				case (typeOf _truck IN ["A3FL_F150","A3FL_F150_ML"]): {
					_trailer attachTo [_truck, [0, -4.68, -0.25]];
				};
				case (typeOf _truck isEqualTo "A3PL_F150"): {
					_trailer attachTo [_truck, [0, -4.73, -0.48]];
				};
				case (typeOf _truck isEqualTo "A3PL_F150_Marker"): {
					_trailer attachTo [_truck, [0, -5.025, 1.13]];
				};
				case (typeOf _truck IN ["A3PL_Silverado","A3PL_Silverado_PD","A3PL_Silverado_PD_ST","A3PL_Silverado_FD"]): {
					_trailer attachTo [_truck, [0, -4.95, 1.03]];
				};
				case (typeOf _truck IN ["A3PL_Tahoe","A3PL_Tahoe_PD","A3PL_Tahoe_FD"]): {
					_trailer attachTo [_truck, [0, -4.48, -0.31]];
				};
				case (typeOf _truck isEqualTo "A3PL_Wrangler"): {
					_trailer attachTo [_truck, [0, -4.02, -0.95]];
				};
				case (typeOf _truck isEqualTo "A3PL_Camaro"): {
					_trailer attachTo [_truck, [0, -4.38, -0.32]];
				};
				case (typeOf _truck IN ["A3PL_Charger15","A3PL_Charger15_PD","A3PL_Charger15_PD_ST","A3PL_Charger15_FD"]): {
					_trailer attachTo [_truck, [0, -4.8, 1.2]];
				};
			};
		};
		case "A3PL_Small_Boat_Trailer": {
			switch (true) do {
				case (typeOf _truck isEqualTo "A3PL_Ram"): {
					_trailer attachTo [_truck, [0, -5.48, -0.85]];
				};
				case (typeOf _truck IN ["A3FL_F150","A3FL_F150_ML"]): {
					_trailer attachTo [_truck, [0, -5.7, -0.3]];
				};
				case (typeOf _truck IN ["A3PL_F150"]): {
					_trailer attachTo [_truck, [0, -5.75, -0.48]];
				};
				case (typeOf _truck IN ["A3PL_F150_Marker"]): {
					_trailer attachTo [_truck, [0, -6.03, 1.2]];
				};
				case (typeOf _truck IN ["A3PL_Silverado","A3PL_Silverado_PD","A3PL_Silverado_PD_ST","A3PL_Silverado_FD"]): {
					_trailer attachTo [_truck, [0, -5.94, 1.23]];
				};
				case (typeOf _truck IN ["A3PL_Tahoe","A3PL_Tahoe_PD","A3PL_Tahoe_FD"]): {
					_trailer attachTo [_truck, [0, -5.5, -0.23]];
				};
				case (typeOf _truck isEqualTo "A3PL_Wrangler"): {
					_trailer attachTo [_truck, [0, -5.02, -1]];
				};
				case (typeOf _truck isEqualTo "A3PL_Camaro"): {
					_trailer attachTo [_truck, [0, -5.36, -0.22]];
				};
				case (typeOf _truck IN ["A3PL_Charger15","A3PL_Charger15_PD","A3PL_Charger15_PD_ST","A3PL_Charger15_FD"]): {
					_trailer attachTo [_truck, [0, -5.7, 1]];
				};
				case (typeOf _truck isEqualTo "A3PL_Pierce_Rescue"): {
					_trailer attachTo [_truck, [0, -9.1, -0.55]];
				};
			};
		}
	};

	detach _trailer;

	[_trailer] remoteExec ["Server_Vehicle_EnableSimulation", 2];
	[_truck] remoteExec ["Server_Vehicle_EnableSimulation", 2];

	_trailer animateSource ["Hitched",20,true];
	_truck animateSource ["Hitched",20,true];

	[_trailer] remoteExec ["Server_Vehicle_EnableSimulation", 2];
	[_truck] remoteExec ["Server_Vehicle_EnableSimulation", 2];

	_truck spawn {sleep 60;_this allowDamage true;};
}] call compile_Global;

["A3PL_Vehicle_TrailerAttach",
{
	private _trailer = param [0,objNull];
	if (typeOf _trailer != "A3PL_Small_Boat_Trailer") exitwith {["System: Incorrect type (try again)",Color_Red] call A3PL_Notification;};
	private _boats = nearestObjects [_trailer, ["Ship"], 6];
	if (count _boats < 1) exitwith {[("STR_A3PL_Vehicle_NoBoatsNearby" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_boat = _boats select 0;
	switch (typeOf _boat) do {
		case ("A3PL_RHIB"): {_boat attachTo [_trailer,[0,-0.57,0.9]];};
		case default {_boat attachTo [_trailer,[0,-0.25,0.9]]; };
	};
	[_boat] remoteExec ["Server_Vehicle_EnableSimulation", 2];
}] call compile_Global;

["A3PL_Vehicle_TrailerRamp",
{
	private ["_trailer"];
	_trailer = param [0,objNull];
	if (isNull _trailer) exitwith {[("STR_A3PL_Vehicle_NotLookingTrailer" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!(_trailer isKindOf "Car")) exitwith {[("STR_A3PL_Vehicle_NotLookingVehicle" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!(local _trailer)) exitwith {[("STR_A3PL_Vehicle_NotOwner" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_truck = getPos _trailer nearestObject "A3PL_P362";
	if ((_trailer animationPhase "ramp") < 0.5) then
	{
		_trailer animate ["ramp",1];
		[_trailer] spawn
		{
			private _trailer = param [0,objNull];
			private _t = 0;
			if (isNull _trailer) exitwith {};
			waitUntil {sleep 0.1; _t = _t + 0.1; (_t >= 6) OR ((_trailer animationPhase "ramp" >= 1))};
			if (_trailer animationPhase "ramp" < 0.9) exitwith {_trailer animate ["ramp",0,true]};
			if (!(local _trailer)) exitwith {_trailer animate ["ramp",0,true]};
			[_trailer] remoteExec ["Server_Vehicle_EnableSimulation", 2];
			{
				detach _x;
			} foreach (attachedObjects _trailer);
		};
	}
	else
	{
		private ["_vehicles","_vehiclesTrailer"];
		_vehicles = nearestObjects [_trailer, ["Air","Thing","LandVehicle","Ship"], 10]; //nearest vehicles
		_vehicles = _vehicles - [_trailer];
		_vehicles = _vehicles - [_truck];
		_vehiclesTrailer = [];
		{
			if ((getpos _x) inArea [_trailer modelToWorld [0,0,0], 6.1, 1,(getDir _trailer+90), true]) then
			{
				_vehiclesTrailer pushback _x;
			};
		} foreach _vehicles;
		{
			[_x,_trailer] call BIS_Fnc_AttachToRelative;
		} foreach _vehiclesTrailer;
		[_trailer] remoteExec ["Server_Vehicle_EnableSimulation", 2];
		_trailer animate ["ramp",0,true];
	};
}] call compile_Global;

["A3PL_Vehicle_TrailerAttachObjects",
{
	private ["_trailer"];
	_trailer = param [0,objNull];
	if (isNull _trailer) exitwith {[("STR_A3PL_Vehicle_NotLookingTrailer" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!(_trailer isKindOf "Car")) exitwith {[("STR_A3PL_Vehicle_NotLookingVehicle" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!(local _trailer)) exitwith {[("STR_A3PL_Vehicle_NotOwner" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	//first check if ramp is up
	if ((_trailer animationsourcePhase "Ramp") < 0.5) then
	{
		//lower the ramp
		_trailer animatesource ["Ramp",1];
		[_trailer] spawn
		{
			private ["_trailer","_t"];
			_trailer = param [0,objNull];
			if (isNull _trailer) exitwith {};
			_t = 0;
			waitUntil {sleep 0.1; _t = _t + 0.1; (_t >= 6) OR ((_trailer animationsourcePhase "Ramp" >= 1))}; //wait until the the ramp is fully lowered
			if (_trailer animationsourcePhase "Ramp" < 0.9) exitwith {_trailer animatesource ["Ramp",0]};
			if (!(local _trailer)) exitwith {_trailer animatesource ["Ramp",0]};

			//disable simulation on trailer so vehicles can be moved up
			[_trailer] remoteExec ["Server_Vehicle_EnableSimulation", 2];

			//detach the vehicles on the trailer
			{
				detach _x;
			} foreach (attachedObjects _trailer);
		};
	} else
	{
		private ["_vehicles","_vehiclesTrailer"];

		//attach all vehicles on the trailer
		_vehicles = nearestObjects [_trailer, ["Air","Thing","LandVehicle","Ship"], 10]; //nearest vehicles
		_vehicles = _vehicles - [_trailer];
		_vehiclesTrailer = []; //vehicles actually on the trailer
		{
			if ((getpos _x) inArea [_trailer modelToWorld [0,0,0], 3.1, 1,(getDir _trailer+90), true]) then
			{
				_vehiclesTrailer pushback _x;
			};
		} foreach _vehicles;

		//attach only the vehicles on the actual trailer
		{
			//_x attachTo [_trailer];
			[_x,_trailer] call BIS_Fnc_AttachToRelative;
		} foreach _vehiclesTrailer;

		//enablesimulation on the trailer again
		[_trailer] remoteExec ["Server_Vehicle_EnableSimulation", 2];
		_trailer animatesource ["Ramp",0];
	};
}] call compile_Global;

["A3PL_Vehicle_TowTruck_Unloadcar",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private _truck = _this select 0;
	private _towing = _truck getVariable ["Towed_Car",objNull];
	if ((!local _truck) OR ((!isNull _towing) && (!local _towing))) exitWith {[player,_truck,_towing] remoteExec ["Server_Vehicle_AtegoHandle", 2];[("STR_A3PL_Vehicle_Definition" call A3PL_Localize)] call A3PL_Notification;};
	if (_truck isEqualTo _towing) exitWith {};
	private _angle = 0;
	private _towingXYZ = _towing getVariable "XYZ";
	private _height = _towingXYZ select 0;
	private _distance = _towingXYZ select 2;
	private _Eheight = _towingXYZ select 3;
	if ((_truck animationSourcePhase "truck_flatbed") < 0.5) then {
		[_truck,_angle] spawn A3PL_Vehicle_TowTruck_Ramp_down;
	};
	private _maxDistance = if(typeOf _truck isEqualTo "A3FL_T440_Tow_Truck") then {-7.5} else {-5.7};
	private _rHeight = if(typeOf _truck isEqualTo "A3FL_T440_Tow_Truck") then {0.0025} else {0.0016};
	while {true} do {
		waitUntil {(_truck animationSourcePhase "truck_flatbed") > 0.5};
		_towing attachTo [_truck,[0,_distance,_Eheight],"flatbed_middle"];
		_distance = _distance - 0.015;
		_Eheight = _Eheight - (_rHeight);
		if (_distance <= _maxDistance) exitWith {_height = _Eheight;};
		sleep 0.01;
	};
	detach _towing;
	_towing setPos (getPos _towing);
	_towing setVelocity [0, 0, 1];
	_truck setVariable ["Towing",false,true];
	_towing setVariable ["Towed", false, true];
}] call compile_Global;

["A3PL_Vehicle_TowTruck_Loadcar", {
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private _truck = _this select 0;
	private _towpoint = "Land_HelipadEmpty_F" createVehicleLocal (getpos _truck);
	private _offset = if(typeOf _truck isEqualTo "A3PL_P362_TowTruck") then {[0,-6.41919,-2.1209]} else {[0,-12,0]};
	_towpoint attachTo [_truck,_offset];
	private _towing = (getpos _towpoint) nearestObject "AllVehicles";
	if (isPlayer _towing) exitWith{[("STR_A3PL_Vehicle_NotAbleToTow" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (typeOf _towing IN ["C_man_w_worker_F","A3FL_Stretcher","A3FL_Wheelchair","A3PL_Gas_Hose","A3PL_GasHose","A3PL_RBM"]) exitWith{[("STR_A3PL_Vehicle_NotAbleToTowObject" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _alignment = [_truck, _towing] call BIS_fnc_relativeDirTo;
	if ((_towpoint distance _towing) >= 6) exitWith {deleteVehicle _towpoint;[("STR_A3PL_Vehicle_IsTooFar" call A3PL_Localize),Color_Yellow] call A3PL_Notification;};
	deleteVehicle _towpoint;
	if (_alignment > 182) exitWith  {[("STR_A3PL_Vehicle_NotCorrectlyPositioned" call A3PL_Localize),Color_Yellow] call A3PL_Notification;};
	if (_alignment < 178) exitWith  {[("STR_A3PL_Vehicle_NotCorrectlyPositioned" call A3PL_Localize),Color_Yellow] call A3PL_Notification;};
	if ((_truck animationSourcePhase "truck_flatbed") < 0.5) exitWith {[("STR_A3PL_Vehicle_RampNeedToBeOnGround" call A3PL_Localize),Color_Yellow] call A3PL_Notification;};
	if (_truck == _towing) exitWith {[("STR_A3PL_Vehicle_NotCorrectlyPositioned" call A3PL_Localize),Color_Yellow] call A3PL_Notification;};
	if ((!local _truck) OR ((!isNull _towing) && (!local _towing))) exitWith {[player,_truck,_towing] remoteExec ["Server_Vehicle_AtegoHandle", 2];};
	{unassignVehicle _x;_x action ["EJECT", vehicle _x];sleep 0.4;} foreach crew _towing;
	_towing engineOn false;
	sleep 0.5;
	private _distance = -5.7323;
	private _height = 0.373707;
	private _Eheight = 0.373707;
	private _angle = 0;
	private _shift = 0;
	_towing setvectorUp [0,_angle,1];
	private _towingdir = [_towing, _truck] call BIS_fnc_relativeDirTo;
	if (_towingdir > 170 && _towingdir < 190) then  {_towingdir = 180;} else {_towingdir = 0;};
	private _Edistance = 0;
	private _UnSupported_Vehicles = ["A3PL_Pierce_Rescue","A3PL_Pierce_Pumper","A3PL_Pierce_Ladder","A3PL_Pierce_Heavy_Ladder","A3PL_P362_TowTruck","A3PL_Box_Trailer","A3PL_Tanker_Trailer","A3PL_Lowloader","A3PL_Boat_Trailer","A3PL_MobileCrane"];
	if (((typeOf _towing) in _UnSupported_Vehicles) || (_towing isKindOf "Air")) exitWith {[("STR_A3PL_Vehicle_CantTowThisCar" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_wheel1 = _towing selectionPosition "wheel_1_1_bound";
	_wheel2 = _towing selectionPosition "wheel_2_2_bound";
	_height = -(_wheel1 select 2) - 1;
	_Edistance = -((_wheel1 select 1)+(_wheel2 select 1))/2;
	_distance = _Edistance - 5.5;
	_shift = -((_wheel1 select 0)+(_wheel2 select 0))/2;
	_type = typeOf _towing;
	switch (_type) do
	{
		case "A3PL_E350": {_height = _height - 0.2;_shift = _shift + 0.1;};
		case "Jonzie_Ambulance": {_height = _height - 0.2;_Edistance = _Edistance - 0.4;};
		case "A3PL_Small_Boat_Trailer": {_height = _height + 0.3;_Edistance = _Edistance - 1;_shift = _shift - 0.5;_towing attachTo [_truck,[_shift,_distance,_Endheight],"flatbed_middle"];};
		case "A3PL_Drill_Trailer": {_shift = _shift - 0.4;_towing attachTo [_truck,[_shift,_distance,_Endheight],"flatbed_middle"];};
		case "A3PL_MiniExcavator": {_height = _height + 0.5;_Edistance = _Edistance - 1.4;_towing attachTo [_truck,[_shift,_distance,_Endheight],"flatbed_middle"];};
	};
	while {true} do
	{
		waitUntil {_truck animationSourcePhase "truck_flatbed" isEqualTo 1};
		_towing attachTo [_truck,[_shift,_distance,_height],"flatbed_middle"];
		_towing setDir _towingdir;
		_towing setvectorUp [0,_angle,1];
		_distance = _distance + 0.01;
		_height = _height + 0.0014;
		_angle = _angle - 0.001846;
		if (_angle <= -0.23) exitWith {_Eheight = _height;};
		sleep 0.01;
	};
	while {true} do
	{
		waitUntil {_truck animationSourcePhase "truck_flatbed" isEqualTo 1};
		_towing attachTo [_truck,[_shift,_distance,_Eheight],"flatbed_middle"];
		_distance = _distance + 0.02;
		_Eheight = _Eheight + 0.0035;
		if (_distance >= _Edistance) exitWith {};
		sleep 0.01;
	};
	[_truck,_angle] spawn A3PL_Vehicle_TowTruck_Ramp_up;
	switch (_type) do
	{
		case "A3PL_E350": {_Endheight = _Eheight + 0.2;_towing attachTo [_truck,[_shift,_distance,_Endheight],"flatbed_middle"];};
		case "Jonzie_Ambulance": {_Endheight = _Eheight + 0.35;_towing attachTo [_truck,[_shift,_distance,_Endheight],"flatbed_middle"];};
		case "A3PL_Ram": {_Endheight = _Eheight - 0.1;_towing attachTo [_truck,[_shift,_distance,_Endheight],"flatbed_middle"];};
		case "A3PL_Tahoe": {_Endheight = _Eheight - 0.05;_towing attachTo [_truck,[_shift,_distance,_Endheight],"flatbed_middle"];};
		case "A3PL_Tahoe_PD": {_Endheight = _Eheight - 0.05;_towing attachTo [_truck,[_shift,_distance,_Endheight],"flatbed_middle"];};
		case "A3PL_Tahoe_PD_Slicktop": {_Endheight = _Eheight - 0.05;_towing attachTo [_truck,[_shift,_distance,_Endheight],"flatbed_middle"];};
		case "A3PL_Tahoe_FD": {_Endheight = _Eheight - 0.05;_towing attachTo [_truck,[_shift,_distance,_Endheight],"flatbed_middle"];};
		case "A3PL_Camaro": {_Endheight = _Eheight + 0.04;_towing attachTo [_truck,[_shift,_distance,_Endheight],"flatbed_middle"];};
		case "A3PL_Gallardo": {_Endheight = _Eheight + 0.04;_towing attachTo [_truck,[_shift,_distance,_Endheight],"flatbed_middle"];};
		case "A3PL_MailTruck": {_Endheight = _Eheight - 0.08;_towing attachTo [_truck,[_shift,_distance,_Endheight],"flatbed_middle"];};
		case "A3PL_VetteZR1": {_Endheight = _Eheight + 0.06;_towing attachTo [_truck,[_shift,_distance,_Endheight],"flatbed_middle"];};
		case "A3PL_CRX": {_Endheight = _Eheight + 0.08;_towing attachTo [_truck,[_shift,_distance,_Endheight],"flatbed_middle"];};
		case "A3PL_Small_Boat_Trailer": {_Endheight = _Eheight + 0.08;_towing attachTo [_truck,[_shift,_distance,_Endheight],"flatbed_middle"];};
		case "A3PL_Drill_Trailer": {_Endheight = _Eheight + 0.02;_towing attachTo [_truck,[_shift,_distance,_Endheight],"flatbed_middle"];};
		case "A3PL_MiniExcavator": {_Endheight = _Eheight - 0.15;_towing attachTo [_truck,[_shift,_distance,_Endheight],"flatbed_middle"];};
		case "A3PL_P362": {_Endheight = _Eheight + 0.2;_towing attachTo [_truck,[_shift,_distance,_Endheight],"flatbed_middle"];};
	};
	_towing setPos getPos _towing;
	_towing setVariable ["XYZ", [_height,_Edistance,_distance,_Eheight], true];
	_towing setVariable ["Towed", true, true];
	_truck setVariable ["Towed_Car",_towing,true];
	_truck setVariable ["Towing",true,true];
}] call compile_Global;

["A3PL_Vehicle_TowTruck_Ramp_up",
{
	private _truck = _this select 0;
	private _angle = _this select 1;
	private _towing = _truck getVariable ["Towed_Car",objNull];
	_truck animateSource ["truck_flatbed",0];
	_truck animate ["Ramp_Switch",0];
	if (isNull _towing) exitWith {};
	while {_angle < 0} do
	{
		waitUntil {_truck animationSourcePhase "truck_flatbed" < 1};
		_angle = _angle + 0.00088567911;
		_towing setVectorUp [0,_angle,1];
		sleep 0.01;
	};
	_towing setVectorUp [0,0,1];
	_towing setPos(getPos _towing);
}] call compile_Global;

["A3PL_Vehicle_TowTruck_Ramp_down",
{
	private _truck = _this select 0;
	private _angle = _this select 1;
	private _towing = _truck getVariable ["Towed_Car",objNull];
	_truck animateSource ["truck_flatbed",1];
	_truck animate ["Ramp_Switch",1];
}] call compile_Global;

['A3PL_Pickup_Ladder',
{
	private _Ladder = _this select 0;
	_Ladder attachTo [player,  [0, 1, 0]];
	_Ladder setdir 180;
	Ladderkeydown =
	{
		_Ladder = nearestObject [player, "A3PL_Ladder"];
		_key = _this select 1;
		_return = false;

		switch _key do {
			case 201: {
				_val = _Ladder animationPhase "Ladder";
				_valu = _val + 0.01;
				if (_valu >= 1) then {_valu = 1};
				_Ladder animate ["Ladder",_valu];
				_return = true;

			};
			case 209: {
				_val = _Ladder animationPhase "Ladder";
				_valu = _val - 0.01;
				if (_valu <= 0) then {_valu = 0};
				_Ladder animate ["Ladder",_valu];
				_return = true;
			};
		};
		_return;
	};
	waituntil {!(IsNull (findDisplay 46))};
	_Ladderkeys = (FindDisplay 46) DisplayAddEventHandler ["keydown","_this call Ladderkeydown;"];
	waitUntil {attachedTo _Ladder != player};
	(finddisplay 46) displayremoveeventhandler ["keydown",_Ladderkeys];
}] call compile_Global;

["A3PL_Vehicle_Mooring",
{
	private ["_veh","_pos","_boat","_towpos","_rope_1","_MooringPos","_boatrope"];
	_veh = player_objintersect;
	_Pos = Player_NameIntersect;
	_boat = vehicle player;
	if (_boat == _veh) exitWith {};
	if (!(_boat isKindOf "Ship")) exitWith {[("STR_A3PL_Vehicle_YouNeedToBeInBoat" call A3PL_Localize),Color_Yellow] call A3PL_Notification;};
	_towpos = _boat selectionPosition ["Anchor", "Memory"];
	_MooringPos = _veh selectionPosition Player_NameIntersect;
	_boatrope = nearestObject [_boat, "rope"];
	if(_veh == (ropeAttachedTo _boat)) exitwith {{deleteVehicle _x;} forEach (nearestObjects [_boat, ["rope"], 5])};
	_Rope_1 = ropeCreate [_veh,_MooringPos, _boat, _towpos, 15];
}] call compile_Global;

['A3PL_Vehicle_Anchor', {
	private ["_veh","_typeOf","_anchor","_anchorX","_sealevel","_Anchorpos","_AnchorWorldpos","_AnchorX_pos","_AnchorX_Height","_Rope_1","_config_offsetY","_relPos","_offsetX","_offsetZ","_offsetY","_length"];
	_veh = _this select 0;
	_typeOf = typeOf _veh;
	_sealevel = abs (getTerrainHeightASL getPos _veh);
	_anchor = _veh getVariable "Boat_Anchor";
	if (isNil "_anchor") then {_anchor = objNull;};
	if ((speed _veh) > 5) exitWith {};
	if (_veh getVariable ["InUse",false]) exitWith {[("STR_A3PL_Vehicle_AnchorAlreadyInUse" call A3PL_Localize),Color_Yellow] call A3PL_Notification;};
	//if (!local _veh) exitwith {[netID _veh,netID player] remoteExec ["A3PL_Lib_ChangeLocality", 2];["System: The boat is not local to you - request send to change locality - please try again",Color_Yellow] call A3PL_Notification;};
	if (isNull _anchor) then {
		_veh setVariable ["InUse",true,true];
		_Anchorpos = _veh selectionPosition "Anchor_Release";
		_AnchorWorldpos = _veh modelToWorld _Anchorpos;
		_anchorX = "A3PL_Anchor" createvehicle _AnchorWorldpos;
		_anchorX setPos [_AnchorWorldpos select 0,_AnchorWorldpos select 1,_AnchorWorldpos select 2];
		_AnchorX_pos = getPosATL _anchorX;
		_AnchorX_Height = _AnchorX_pos select 2;
		_Rope_1 = ropeCreate [_veh, "Anchor", _anchorX, [0, 0, 0.4], (_AnchorX_Height + 4)];//
		sleep 1;
		_anchor = "Land_HelipadEmpty_F" createvehicle _AnchorWorldpos;
		_anchor setDir getDir _veh;
		_veh setVariable ["Boat_Anchor",_anchor,true];
		sleep 0.5;
		[_veh, _anchor] call BIS_fnc_attachToRelative;
		_veh setVariable ["InUse",false,true];
	} else {
		_veh setVariable ["InUse",true,true];
		if (count ropes _veh < 1) exitwith {_anchorX = nearestObject [_veh, "A3PL_Anchor"];_veh setVariable ["Boat_Anchor",objNull,true];deleteVehicle _anchor;deleteVehicle _anchorX;_veh setVariable ["InUse",false,true];};
		_Rope_1 = (ropes _veh) select 0;
		_length = ropeLength _Rope_1;
		_windspeed = (_length/10);
		if(typeOf _veh == "A3PL_Yacht")then {_Rope_1 = (nearestObjects [(_veh modeltoworld (_veh selectionPosition ["Anchor", "Memory"])), ["rope"], 30])select 0;};
		ropeUnwind [_Rope_1, _windspeed, 0];
		while {_length > 0.6} do {_length = ropeLength _Rope_1;sleep 0.2;};
		waitUntil {_length < 0.6};
		sleep 2;
		_anchorX = nearestObject [_veh, "A3PL_Anchor"];
		if(typeOf _veh == "A3PL_Yacht")then {{deleteVehicle _x;} forEach (nearestObjects [(_veh modeltoworld (_veh selectionPosition ["Anchor", "Memory"])), ["rope"], 30])}else
		{{ropeDestroy _x;} foreach (ropes _veh)};
		detach _veh;
		sleep 0.1;
		_veh setVariable ["Boat_Anchor",objNull,true];
		deleteVehicle _anchor;
		deleteVehicle _anchorX;
		_veh setVariable ["InUse",false,true];
	};
}] call compile_Global;

["A3PL_Vehicle_DisableSimulation",
{
	private _veh = _this select 0;
	if ((speed _veh) > 3) exitWith {[("STR_A3PL_Vehicle_YouNeedToStopTheBoatBefore" call A3PL_Localize),Color_Yellow] call A3PL_Notification;};
	if ((typeOf _veh) IN ["A3PL_Cutter","A3FL_LCM"]) then {
		if (simulationEnabled _veh) then {
			[_veh] remoteExec ["Server_Vehicle_EnableSimulation", 2];
			[("STR_A3PL_Vehicle_SimulationDeactivated" call A3PL_Localize),Color_Green] call A3PL_Notification;
		} else {
			[_veh] remoteExec ["Server_Vehicle_EnableSimulation", 2];
			[("STR_A3PL_Vehicle_SimulationActivated" call A3PL_Localize),Color_Green] call A3PL_Notification;
		};
	};
}] call compile_Global;

["A3PL_Vehicle_SecureHelicopter",
{
	private _cutter = param [0,objNull];
	if (typeOf _cutter != "A3PL_Cutter") exitwith {["System: Incorrect type (try again)",Color_Red] call A3PL_Notification;};
	private _helis = nearestObjects [_cutter, ["A3FL_AS_365","A3PL_Jayhawk","A3FL_M_900_Base_F","Heli_Medium01_Coastguard_H","Heli_Medium01_H","Heli_Medium01_Sheriff_H","Heli_Medium01_Luxury_H","Heli_Medium01_Military_H","Heli_Medium01_Medic_H","Heli_Medium01_Veteran_H"], 50];
	if (count _helis < 1) exitwith {[("STR_A3PL_Vehicle_NoHeliNearby" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _heli = _helis select 0;
	switch (typeOf _heli) do {
		case ("A3FL_AS_365"): {_heli attachTo [_cutter,[0,-17,-5.2]];};
		case ("A3PL_Jayhawk"): {_heli attachTo [_cutter,[0,-17,-5.5]];};
		case ("A3FL_M_900_Base_F"): {_heli attachTo [_cutter,[0,-17,-7.2]];};
		case ("Heli_Medium01_Coastguard_H"): {_heli attachTo [_cutter,[0,-17,-5]];};
		case ("Heli_Medium01_H"): {_heli attachTo [_cutter,[0,-17,-5]];};
		case ("Heli_Medium01_Sheriff_H"): {_heli attachTo [_cutter,[0,-17,-5]];};
		case ("Heli_Medium01_Luxury_H"): {_heli attachTo [_cutter,[0,-17,-5]];};
		case ("Heli_Medium01_Military_H"): {_heli attachTo [_cutter,[0,-17,-5]];};
		case ("Heli_Medium01_Medic_H"): {_heli attachTo [_cutter,[0,-17,-5]];};
		case ("Heli_Medium01_Veteran_H"): {_heli attachTo [_cutter,[0,-17,-5]];};
	};
	[("STR_A3PL_Vehicle_HeliAttachedToCutter" call A3PL_Localize),Color_Green] call A3PL_Notification;
	[_heli] remoteExec ["Server_Vehicle_EnableSimulation", 2];
}] call compile_Global;

["A3PL_Vehicle_UnsecureHelicopter",
{
	private _cutter = param [0,objNull];
	if (typeOf _cutter != "A3PL_Cutter") exitwith {["Incorrect type (try again)",Color_Red] call A3PL_Notification;};
	private _helis = nearestObjects [_cutter, ["A3FL_AS_365","A3PL_Jayhawk","A3FL_M_900_Base_F"], 50];
	if (count _helis < 1) exitwith {[("STR_A3PL_Vehicle_NoHeliNearby" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _heli = _helis select 0;
	{detach _x;} foreach (attachedObjects _cutter);
	[("STR_A3PL_Vehicle_HeliUntacched" call A3PL_Localize),Color_Green] call A3PL_Notification;

	[_heli] remoteExec ["Server_Vehicle_EnableSimulation", 2];
}] call compile_Global;

["A3PL_Vehicle_SecureVehicle",
{
	private _vehicle = param [0,objNull];

	private _ships = nearestObjects [_vehicle, ["A3FL_LCM"], 30];
	if (count _ships < 1) exitwith {[("STR_A3PL_Vehicle_NoHeliNearby" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _ship = _ships select 0;

	if(_ship IN A3PL_Player_Vehicles) then {
		[_vehicle, _ship, false] call BIS_fnc_attachToRelative;
		[("STR_A3PL_Vehicle_VehicleAttachedToBoat" call A3PL_Localize),Color_Green] call A3PL_Notification;
		[_vehicle] remoteExec ["Server_Vehicle_EnableSimulation", 2];
	} else {
		[("STR_A3PL_Vehicle_YouDoNotHaveBoatKeys" call A3PL_Localize),Color_Red] call A3PL_Notification;
	}
}] call compile_Global;

["A3PL_Vehicle_UnsecureVehicle",
{
	private _ship = param [0,objNull];

	{
		detach _x;
		[_x] remoteExec ["Server_Vehicle_EnableSimulation", 2];
	} foreach (attachedObjects _ship);
	[("STR_A3PL_Vehicle_AllVehiclesDetached" call A3PL_Localize),Color_Green] call A3PL_Notification;

}] call compile_Global;

["A3PL_Vehicle_Jerrycan",
{
	private _veh = param [0,objNull];
	if (isNull _veh) exitwith {};
	if ((typeOf _veh IN ["A3PL_RBM","Heli_Medium01_H","Heli_Medium01_Luxury_H","Heli_Medium01_Military_H","Heli_Medium01_Veteran_H","Heli_Medium01_Coastguard_H","Heli_Medium01_Sheriff_H","Heli_Medium01_Medic_H","Heli_Medium01_H","Heli_Medium01_Luxury_H","Heli_Medium01_Military_H","Heli_Medium01_Veteran_H","Heli_Medium01_Coastguard_H","Heli_Medium01_Sheriff_H","Heli_Medium01_Medic_H","Heli_Medium01_H","Heli_Medium01_Luxury_H","Heli_Medium01_Military_H","Heli_Medium01_Veteran_H","Heli_Medium01_Coastguard_H","Heli_Medium01_Sheriff_H","Heli_Medium01_Medic_H","A3PL_Motorboat","A3PL_RHIB","A3PL_Yacht","A3PL_Jayhawk","A3FL_AS_365","A3FL_M_900_Base_F","A3PL_Cessna172"]) && (player_itemClass isNotEqualTo "kerosene_jerrycan")) exitwith {[("STR_A3PL_Vehicle_ThisCarNeedKerosene" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!(player_itemClass IN ["jerrycan","kerosene_jerrycan"])) exitwith {[("STR_A3PL_Vehicle_YouDontHaveJerrycan" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!local _veh) exitwith {[("STR_A3PL_Vehicle_OnlyLastConductorCanFill" call A3PL_Localize)] call A3PL_Notification;};

	private _classname = typeOf _veh;
	private _vector = [[0,1,0],[1,0,0]];
	private _vectorEnd = [[0,1,0],[0,0,1]];
	private _attachTo = _veh selectionPosition "gasTank";
	switch (true) do
	{
		case (_classname IN ["A3PL_Rover","A3PL_P362","A3PL_P362_TowTruck","A3PL_P362_Garbage_Truck","A3PL_BMW_M3","A3PL_911GT2","A3PL_Taurus","A3FL_Taurus_PD","A3FL_Taurus_PD_ST","A3PL_Taurus_FD","A3FL_BMW_M6","A3FL_BMW_M6_Tuned","A3FL_Smart_Car","A3FL_Mercedes_Benz_AMG_C63","A3FL_Nissan_GTR","A3FL_Nissan_GTR_LW"]): {
			_vector = [[0,-1,0],[-1,0,0]];
			_vectorEnd = [[0,-1,0],[0,0,1]];
			_attachTo set [0,(_attachTo select 0) + 0.1];
			_attachTo set [2,(_attachTo select 2) + 0.1];
		};
		default {
			_attachTo set [0,(_attachTo select 0) - 0.3];
			_attachTo set [2,(_attachTo select 2) + 0.2];
		};
	};

	private _jerryCan = Player_Item;
	[player_itemClass,-1] call A3PL_Inventory_Add;
	Player_Item = objNull;
	Player_ItemClass = '';

	detach _jerryCan;
	_jerryCan attachTo [_veh,_attachTo];
	sleep 0.2;
	_jerryCan setVectorDirAndUp _vector;

	playSound3D ["A3PL_Common\effects\gasoline.ogg", _jerrycan, false, getPos _jerryCan, 5, 1.1, 40];
	sleep 4.5;
	_jerryCan setVectorDirAndUp _vectorEnd;
	sleep 1;
	deleteVehicle _jerryCan;

	_veh setFuel ((fuel _veh) + 0.25);
	[player,"jerrycan_empty",1] remoteExec ["Server_Inventory_Add",2];
}] call compile_Global;

["A3PL_Vehicle_Unflip",
{
	private ["_car"];
	_car = param [0,objNull];
	if (isNull _car) exitwith {};
	if (animationstate player == "Acts_carFixingWheel") exitwith {[("STR_A3PL_Vehicle_YouAlreadyFlipACar" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!(vehicle player == player)) exitwith {[("STR_A3PL_Vehicle_YouCanBeInsideCarToFlip" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (player getVariable ["repairing",false]) exitwith {[("STR_A3PL_Vehicle_YouAlreadyFlipACar" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	Player_ActionCompleted = false;
	[("STR_A3PL_Vehicle_Retournement" call A3PL_Localize),20] spawn A3PL_Lib_LoadAction;
	while {sleep 0.5; !Player_ActionCompleted } do
	{
		if ((player distance2D _car) > 10) exitWith {[("STR_A3PL_Vehicle_YouTooFar" call A3PL_Localize),Color_Red] call A3PL_Notification; _success = false;};
		if (!(vehicle player == player)) exitwith {Player_ActionInterrupted = true;};
		if (player getVariable ["Incapacitated",false]) exitwith {Player_ActionInterrupted = true;};
		if (!alive player) exitwith {Player_ActionInterrupted = true;};
		player playmove "Acts_carFixingWheel";
	};
	if (Player_ActionInterrupted) exitWith {Player_ActionDoing = false;};

	[_car] spawn
	{
		private _car = param [0,objNull];
		private _normalVec = surfaceNormal getPos _car;
		_car setVectorUp _normalVec;
		_car setPosATL [getPosATL _car select 0, getPosATL _car select 1, 0];
	};
	player switchMove "";
	[("STR_A3PL_Vehicle_VehicleFlipped" call A3PL_Localize),Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Vehicle_ControlSpotlight", {
	keysEVH =
	{
		_key = _this select 1;
		_return = false;
		switch _key do
		{
			case 201:
			{
				_val = vehicle player animationSourcePhase "Spotlight_Rotate";
				_valu = _val + 0.05;
				if (_valu >= 1.047) then {_valu = 1.047};
				vehicle player animateSource ["spotlight_rotate",_valu];
				_return = true;
			};
			case 209:
			{
				_val = vehicle player animationSourcePhase "Spotlight_Rotate";
				_valu = _val - 0.05;
				if (_valu <= -1.571) then {_valu = -1.571};
				vehicle player animateSource ["spotlight_rotate",_valu];
				_return = true;
			};
			case 199:
			{
				private _veh = vehicle player;
				if (_veh animationSourcePhase "Spotlight" < 0.5) then {
					_veh animateSource ["Spotlight",1];
					if (_veh animationSourcePhase "Head_Lights" < 0.5) then{player action ["lightOn",_veh];};
				} else {
					_veh animateSource ["Spotlight",0];
					if (_veh animationSourcePhase "Head_Lights" < 0.5) then{player action ["lightOff",_veh];};
				};
				_return = true;
			};
			case 10: {
				private _veh = vehicle player;
				if (_veh animationPhase "PD_Switch_9" < 0.5) then {
					_veh animate ["PD_Switch_9",1];
					_veh animate ["DS_Floodlights",1];
				} else {
					_veh animate ["PD_Switch_9",0];
					_veh animate ["DS_Floodlights",0];
				};
			};
			case 11: {
				private _veh = vehicle player;
				if (_veh animationPhase "PD_Switch_10" < 0.5) then {
					_veh animate ["PD_Switch_10",1];
					_veh animate ["PS_Floodlights",1];
				} else {
					_veh animate ["PD_Switch_10",0];
					_veh animate ["PS_Floodlights",0];
				};
			};
		};
		_return;
	};
	waituntil {!isNull findDisplay 46};
	_keysEVH = (findDisplay 46) DisplayAddEventHandler ["keydown","_this call keysEVH"];
	waitUntil {(vehicle player) isEqualTo player};
	(findDisplay 46) displayremoveeventhandler ["keydown",_keysEVH];
}] call compile_Global;

["A3PL_Vehicle_LCMRamp", {
	rampKeysFnc =
	{
		_key = _this select 1;
		_return = false;
		switch _key do
		{
			case 75:
			{
				_val = vehicle player animationSourcePhase "trunk";
				_valu = _val + 0.01;
				if (_valu >= 1) then {_valu = 1};
				vehicle player animateSource ["trunk",_valu];
				_return = true;
			};
			case 77:
			{
				_val = vehicle player animationSourcePhase "trunk";
				_valu = _val - 0.01;
				if (_valu <= 0) then {_valu = 0};
				vehicle player animateSource ["trunk",_valu];
				_return = true;
			};
		};
		_return;
	};
	waituntil {!isNull findDisplay 46};
	_keyHandler = (findDisplay 46) DisplayAddEventHandler ["keydown","_this call rampKeysFnc"];
	waitUntil {(typeOf (vehicle player)) isNotEqualTo "A3FL_LCM"};
	(findDisplay 46) displayremoveeventhandler ["keydown",_keyHandler];
}] call compile_Global;

["A3PL_Vehicle_LoadStretcher", {
	private _veh = param[0,objNull];
	private _type = typeOf _veh;
	private _stretcher = _veh getVariable["Stretcher",objNull];
	private _offsetA = [];
	private _offsetB = [];
	switch (true) do 
	{
		case (_type isEqualTo "EC_E350_A"): {_offsetA = [0,-1.6,0.45]; _offsetB = [0,-5,-0.1]};
		case (_type isEqualTo "EC_F150_A"): {_offsetA = [-0.2,-1.6,0.4]; _offsetB = [-0.2,-5,-0.1]};
		case (_type isEqualTo"Jonzie_Ambulance"): {_offsetA = [0,-1,0.6]; _offsetB = [0,-5,-0.1]};
		default {_offsetA = [0,0,0.35]; _offsetB = [0,-3.5,-0.1]};
	};
	if (isNull _stretcher) then {
		cursorObject animateDoor [player_nameintersect, 1];
		private _stretchers = nearestObjects[_veh, ["A3FL_Stretcher"], 20];
		if((count _stretchers) isEqualTo 0) exitWith {[("STR_A3PL_Vehicle_NoStretcherAround" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		_stretcher = _stretchers#0;
		if(_veh animationSourcePhase "Legs" isEqualTo 0) then {
			_stretcher animateSource["Legs",1,true];
		};
		_stretcher attachTo[_veh,_offsetA];
		_veh setVariable["Stretcher",_stretcher,true];
	} else {
		cursorObject animateDoor [player_nameintersect, 1];
		_stretcher animateSource["Legs",0];
		_stretcher attachTo[_veh,_offsetB];
		detach _stretcher;
		_veh setVariable["Stretcher",objNull,true];
	};
}] call compile_Global;

["A3PL_Vehicle_PalletLifterAttachObjects",
{
	private ["_trailer"];
	_trailer = param [0,objNull];
	if (isNull _trailer) exitwith {["Erreur! (NullTrailer still has interact)", Color_Red] call A3PL_Notification;};
	private ["_vehicles","_vehiclesTrailer"];
	private _vehicles = nearestObjects [_trailer, ["LandVehicle","Ship"], 10];
	_vehicles = _vehicles - [_trailer];
	_vehiclesTrailer = [];
	{
		if ((getpos _x) inArea [_trailer modelToWorld [0,0,0],5,10,90,false]) then
		{
			_vehiclesTrailer pushback _x;
		};
	} foreach _vehicles;
	private _amountAttached = count _vehiclesTrailer;
	if (_amountAttached < 1) exitwith {[("STR_A3PL_Vehicle_NoCarToAttached" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if (Player_ActionDoing) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[_trailer,player] remoteExec ["A3PL_Lib_ChangeLocality",2];
	player playMoveNow 'Acts_carFixingWheel';
    [("STR_A3PL_Vehicle_Attachment" call A3PL_Localize),30,false] spawn A3PL_Lib_LoadAction;
	player playMoveNow 'Acts_carFixingWheel';
    waitUntil{Player_ActionDoing};
    while {Player_ActionDoing} do {
        if ((player distance2D _trailer) > 25) exitwith {Player_ActionInterrupted = true};
        if (!(player getVariable ["A3PL_Medical_Alive",true])) exitWith {Player_ActionInterrupted = true;};
        if ((vehicle player) != player) exitwith {Player_ActionInterrupted = true;};
        if (player getVariable ["Incapacitated",false]) exitwith {Player_ActionInterrupted = true;};
		if (!(player_itemClass isEqualTo "helo_rope")) exitwith {Player_ActionInterrupted = true;};
        if ((animationstate player) != "Acts_carFixingWheel") then {player playMoveNow 'Acts_carFixingWheel';};
    };

    [player, ""] remoteExec ["A3PL_Lib_SyncAnim",0];
    if(Player_ActionInterrupted) exitWith {[("STR_A3PL_Vehicle_AttachmentFailed" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[player_item] call A3PL_Inventory_Clear;
	[player,"helo_rope",-1] remoteExec ["Server_Inventory_Add",2];

	{
		[_x,_trailer] call BIS_Fnc_AttachToRelative;
	} foreach _vehiclesTrailer;
	private _disRet = format[("STR_A3PL_Vehicle_YouAttachedCar" call A3PL_Localize), _amountAttached];
	[_trailer, true] remoteExec ["enableSimulationGlobal", 2];
	_trailer setVariable ["vehiclesLoaded",true, true];
	[_disRet, Color_Green] call A3PL_Notification;
}] call compile_Global;

// ["A3PL_Vehicle_PalletLifterDetachObjects",
// {
// 	private ["_trailer"];
// 	_trailer = param [0,objNull];
// 	if (isNull _trailer) exitwith {["Erreur! (NullTrailer still has interact)", Color_Red] call A3PL_Notification;};

// 		if (Player_ActionDoing) exitwith {[localize"STR_Common_ActionAlreadyInProgress",Color_Red] call A3PL_Notification;};
// 	[_trailer,player] remoteExec ["A3PL_Lib_ChangeLocality",2];
//     [localize"STR_A3PL_Vehicle_Dettach",30,false] spawn A3PL_Lib_LoadAction;
// 	player playMoveNow 'Acts_carFixingWheel';
//     waitUntil{Player_ActionDoing};
//     while {Player_ActionDoing} do {
//         if ((player distance2D _trailer) > 25) exitwith {Player_ActionInterrupted = true};
//         if (!(player getVariable ["A3PL_Medical_Alive",true])) exitWith {Player_ActionInterrupted = true;};
//         if ((vehicle player) != player) exitwith {Player_ActionInterrupted = true;};
//         if (player getVariable ["Incapacitated",false]) exitwith {Player_ActionInterrupted = true;};
//         if ((animationstate player) != "Acts_carFixingWheel") then {player playMoveNow 'Acts_carFixingWheel';};
//     };

//     [player, ""] remoteExec ["A3PL_Lib_SyncAnim",0];
//     if(Player_ActionInterrupted) exitWith {[localize"STR_A3PL_Vehicle_DetachFailed",Color_Red] call A3PL_Notification;};
// 	[_trailer, false] remoteExec ["enableSimulationGlobal", 2];
// 	private _amountDetached = count (attachedObjects _trailer);
// 	_trailer setVariable ["vehiclesLoaded",false, true];
// 	{
// 			detach _x;
// 	} foreach (attachedObjects _trailer);
// 	if (_amountDetached > 0) then {
// 		[player,"helo_rope",1] remoteExec ["Server_Inventory_Add",2];
// 	};
// 	private _disRet = format [localize"STR_A3PL_Vehicle_ReadyToCharge",_amountDetached];
// 	[_disRet, Color_Yellow] call A3PL_Notification;
// }] call compile_Global;

["A3PL_Vehicle_PalletLifterEnableSimulation",
{
	private _vehicle = param [0,objNull];

	private _palletLifters = nearestObjects [_vehicle, ["A3FL_PalletLifter"], 30];
	if (count _palletLifters < 1) exitwith {[localize"STR_A3PL_Vehicle_NoHeliNearby",Color_Red] call A3PL_Notification;};
	private _palletLifter = _palletLifters select 0;

	if(_palletLifter IN A3PL_Player_Vehicles) then {
		[_vehicle, _palletLifter, false] call BIS_fnc_attachToRelative;
		[localize"STR_A3PL_Vehicle_VehicleAttachedToBoat",Color_Green] call A3PL_Notification;
		[_vehicle] remoteExec ["Server_Vehicle_EnableSimulation", 2];
	} else {
		[localize"STR_A3PL_Vehicle_YouDoNotHaveBoatKeys",Color_Red] call A3PL_Notification;
	}
}] call compile_Global;

["A3PL_Vehicle_PalletLifterDetachObjects",
{
	private _palletLifter = param [0,objNull];

	{
		detach _x;
		[_x] remoteExec ["Server_Vehicle_EnableSimulation", 2];
	} foreach (attachedObjects _palletLifter);
	[localize"STR_A3PL_Vehicle_AllVehiclesDetached",Color_Green] call A3PL_Notification;

}] call compile_Global;