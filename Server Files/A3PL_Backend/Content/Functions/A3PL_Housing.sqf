/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Housing_VirtualOpen",
{
	disableSerialization;
	private _box = param [0,player_objintersect];
	if (isNull _box) exitwith {["Storage is not available (_box is null)"] call A3PL_Notification;};
	if (player distance _box > 5 ) exitwith {[("STR_A3PL_Housing_TooFarFromStorage" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (player getVariable ["patdown",false]) exitwith {[("STR_A3PL_Housing_Patdown" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_box getVariable ["inuse",false]) exitwith {[("STR_A3PL_Housing_StorageInUse" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_box setVariable ["inuse",true,true];

	createDialog "Dialog_HouseVirtual";
	private _display = findDisplay 37;

	A3PL_Housing_StorageBox = _box;
	_display displayAddEventHandler ["unload",{A3PL_Housing_StorageBox setVariable ["inuse",nil,true]; A3PL_Housing_StorageBox = nil;}];

	private _capacity = _box getVariable ["capacity",0];
	[_display,_box] spawn A3PL_Housing_VirtualFillLB;
}] call compile_Global;

["A3PL_Housing_VirtualFillLB",
{
	private _display = param [0,displayNull];
	private _box = param [1,objNull];
	private _isWarehouse = _box getVariable["warehouse",false];
	private _isCrackhouse = _box getVariable["crackhouse",false];
	private _control = _display displayCtrl 1500;
	lbClear _control;
	{
		_itempicture = [_x select 0, "picture"] call A3PL_Config_GetItem;
		_item = _x select 0;
		_control lbAdd format ["%1 (x%2)",([_item,"name"] call A3PL_Config_GetItem),_x select 1];
		_control lbSetData [_forEachIndex,_item];
		_control lbSetPicture [_forEachIndex,_itempicture];
	} foreach (player getVariable ["player_inventory",[]]);

	if(_isWarehouse) then {
		private _near = player nearEntities [["Thing"],20];
		private _cid = [(player getVariable ["character_id",""])] call A3PL_Config_GetCompanyID;
		sleep 0.0005;
		{

			if ((!isNil {_x getVariable ["ainv",nil]}) || (!isNil {_x getVariable ["finv",nil]}) || (isNil {_x getVariable ["class",nil]})) then {
				private _id = _x getVariable ["class",""];
				if (_id isEqualTo "cocaine_brick") exitWith {};
				if ((_id isEqualTo "planter") && (count (nearestObjects [_x,Housing_Max_Items_Planter,3]) > 0)) exitWith {};
				_near deleteAt _forEachIndex;
			};
		} foreach _near;
		{
			if (((_x getVariable ["cid",0]) IN [0,_cid]) && {!isNull _x}) then
			{
				private _id = _x getVariable ["class",""];
				if (_id isEqualTo "cocaine_brick") exitWith {};
				if ((_id isEqualTo "planter") && (count (nearestObjects [_x,Housing_Max_Items_Planter,3]) > 0)) exitWith {};
				private _i = _control lbAdd format ["%1 (%2x)",([_id,"name"] call A3PL_Config_GetItem),1];
				_control lbSetData [_i,format ["OBJ_%1",_x]];
			};
		} foreach _near;
	};

	if(_isCrackhouse) then {
		private _near = player nearEntities [["Thing"],20];
		sleep 0.0005;
		{

			if ((!isNil {_x getVariable ["ainv",nil]}) || (!isNil {_x getVariable ["finv",nil]}) || (isNil {_x getVariable ["class",nil]})) then {
				private _id = _x getVariable ["class",""];
				if (_id isEqualTo "cocaine_brick") exitWith {};
				if ((_id isEqualTo "planter") && (count (nearestObjects [_x,Housing_Max_Items_Planter,3]) > 0)) exitWith {};
				_near deleteAt _forEachIndex;
			};
		} foreach _near;
	};

	_control = _display displayCtrl 1501;
	lbClear _control;
	{
		_itempicture = [_x select 0, "picture"] call A3PL_Config_GetItem;
		_item = _x select 0;
		_control lbAdd format ["%1 (x%2)",([_item,"name"] call A3PL_Config_GetItem),_x select 1];
		_control lbSetData [_forEachIndex,_item];
		_control lbSetPicture [_forEachIndex,_itempicture];
	} foreach (_box getVariable ["storage",[]]);

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
	_control ctrlSetStructuredText parseText format["<t font='PuristaSemiBold' align='center' size='1.18' >%4</t><br/><t font='PuristaSemiBold' align='center' size='1.05' color='%3'>%1%2</t>", _capacity, "%", _capColor,("STR_A3PL_Housing_Inventory" call A3PL_Localize)];

	_boxTotalWeight = [_box] call A3PL_Vehicle_TotalWeight;
	_vehCapacity = _box getVariable["capacity",0];
	_capacity = round((_boxTotalWeight/_vehCapacity)*100);
	_capColor = switch(true) do {
		case (_capacity < 20): {"#00FF00"};
		case (_capacity >= 50): {"#FFFF00"};
		case (_capacity >= 75): {"#FFA500"};
		case (_capacity >= 100): {"#ff0000"};
		default {"#ffffff"};
	};
	_control = _display displayCtrl 1101;
	_control ctrlSetStructuredText parseText format["<t font='PuristaSemiBold' align='center' size='1.18' >%4</t><br/><t font='PuristaSemiBold' align='center' size='1.05' color='%3'>%1%2</t>", _capacity, "%", _capColor,("STR_A3PL_Housing_Storage" call A3PL_Localize)];
}] call compile_Global;

["A3PL_Housing_VirtualChange",
{
	disableSerialization;
	private ["_index","_display","_control","_storage","_inventory","_index","_itemClass","_itemAmount"];
	_add = param [0,true];
	_display = findDisplay 37;
	if (_add) then { _control = _display displayCtrl 1500;} else {_control = _display displayCtrl 1501;};
	if (isNull A3PL_Housing_StorageBox) exitwith {["Storage is not available (_box is null)"] call A3PL_Notification;};

	_storage = A3PL_Housing_StorageBox getVariable ["storage",[]];
	_inventory = player getVariable ["player_inventory",[]];
	_index = lbCurSel _control;
	if (_index isEqualTo -1) exitwith {[("STR_A3PL_Housing_NoObjectSelected" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if (_add) then
	{
		private ["_itemClass","_itemAmount","_veh"];
		_itemData = _control lbData (lbCurSel _control);
		_splitted = _itemData splitString "_";
		_itemError = false;
		_veh = nil;
		if ((_splitted select 0) isEqualTo "OBJ" && {!_itemError}) then {
			private _typeOf = toArray _itemData;
			_typeOf deleteAt 0;_typeOf deleteAt 0;_typeOf deleteAt 0;_typeOf deleteAt 0;
			_typeOf = toString _typeOf;
			_veh = [_typeOf] call A3PL_Lib_vehStringToObj;
			if(typeName _veh isEqualTo "STRING") exitWith {_itemError = true;};
			_itemClass = _veh getVariable["class",""];
			_itemAmount = 1;
		} else {
			_itemClass = (_inventory select _index) select 0;
			_itemAmount = floor(parseNumber (ctrlText 1400));
			if (_itemAmount < 1) exitwith {_itemError = true;};
			if (_itemAmount > ((_inventory select _index) select 1)) exitwith {_itemError = true;};
		};
		if (_itemError) exitWith {[("STR_Common_InvalidAmount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		
		_boxCapacity = A3PL_Housing_StorageBox getVariable["capacity",0];
		_itemTotalWeight = ([_itemClass, 'weight'] call A3PL_Config_GetItem) * _itemAmount;
		_boxTotalWeight = [A3PL_Housing_StorageBox] call A3PL_Vehicle_TotalWeight;
		if ((_itemTotalWeight + _boxTotalWeight) > _boxCapacity) exitwith {[("STR_A3PL_Housing_StorageFull" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		if (!isNil "_veh") then {deleteVehicle _veh;};

		A3PL_Housing_StorageBox setVariable ["storage",([_storage, _itemClass, _itemAmount,false] call BIS_fnc_addToPairs),true];
		player setVariable ["player_inventory",([_inventory, _itemClass, -(_itemAmount),false] call BIS_fnc_addToPairs),true];
		[] call A3PL_Inventory_Verify;
		[getPlayerUID player,(player getVariable ["character_id",""]),"Inv_Virtual_HouseAdd",[format ["Item: %1 | Amount: %2",_itemClass,_itemAmount]]] remoteExec ["Server_Log_New",2]; 
	} else {
		_itemClass = (_storage select _index) select 0;
		_itemAmount = floor(parseNumber (ctrlText 1401));
		_itemError = false;
		if (_itemAmount < 1) exitwith {[("STR_Common_InvalidAmount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		if (_itemAmount > ((_storage select _index) select 1)) exitwith {[("STR_A3PL_Housing_NoAmount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		if !([_itemClass,"canPickup"] call A3PL_Config_GetItem) then {
			for "_i" from 1 to _itemAmount do {
				[player,[_itemClass,1],"item"] remoteExec ["Server_Factory_Create",2];
			};
		} else {
			if (([[_itemClass,_itemAmount]] call A3PL_Inventory_TotalWeight) > Player_MaxWeight) exitwith {_itemError = true;};
			player setVariable ["player_inventory",([_inventory, _itemClass, _itemAmount,false] call BIS_fnc_addToPairs),true];
		};
		if(_itemError) exitWith {[format [("STR_A3PL_Housing_WeightLimitExceeded" call A3PL_Localize),Player_MaxWeight],Color_Red] call A3PL_Notification;};
		A3PL_Housing_StorageBox setVariable ["storage",([_storage, _itemClass, -(_itemAmount),false] call BIS_fnc_addToPairs),true];
		[A3PL_Housing_StorageBox] call A3PL_Housing_VirtualVerify;
		[getPlayerUID player,(player getVariable ["character_id",""]),"Inv_Virtual_HouseTake",[format ["Item: %1 | Amount: %2",_itemClass,_itemAmount]]] remoteExec ["Server_Log_New",2];
	};
	[] call A3PL_Inventory_SetCurrent;
	[_display,A3PL_Housing_StorageBox] spawn A3PL_Housing_VirtualFillLB;
}] call compile_Global;

["A3PL_Housing_VirtualVerify", {
	private _box = param [0,objNull];
	private _change = false;
	{
		if ((_x select 1) < 1) then {
			_index = _forEachIndex;
			(_box getVariable "storage") set [_index, "REMOVE"];
			_change = true;
		};
	} forEach (_box getVariable "storage");
	if (_change) then {
		_box setVariable ["storage", ((_box getVariable "storage") - ["REMOVE"]), true];
	};
}] call compile_Global;

["A3PL_Housing_CheckOwn",
{
	private ["_obj","_keyID","_doorID"];

	_obj = param [0,objNull];
	_keyID = param [1,""];
	_return = false;
	_doorID = _obj getVariable "doorID";

	if ((typeOf _obj) == "Land_A3PL_Motel") then
	{
		_name  = _this select 2;
		_doorID = _obj getVariable "doorID";
		{
			if ((_x select 2) == _name) exitwith
			{
				if (_x select 1 == _keyid) then
				{
					_return = true;
				};
			};
		} foreach _doorID;
	} else
	{
		if (_keyID == (_doorID select 1)) then
		{
			_return = true;
		};
	};
	_return;
}] call compile_Global;

["A3PL_Housing_keyFilter",
{
	private _keys = player getVariable "keys";
	private _filteredKeys = [];
	private _nr = 6;
	private _filter = _this select 0;
	switch (_filter) do {
		case "house": {_nr = 5;};
		case "apt": {_nr = 4;};
		case "cars": {_nr = 6;};
		case "warehouse": {_nr = 8};
		case "crackhouse": {_nr = 9};
		default {_nr = 7;};
	};
	{
		if ((count _x) isEqualTo _nr) then {
			_filteredKeys pushback _x;
		};
	} foreach _keys;
	_filteredKeys;
}] call compile_Global;

["A3PL_Housing_PickupKey",
{
	private _obj = player_objintersect;
	if (typeOf _obj != "A3PL_HouseKey") exitwith {};
	[_obj, player] remoteExec ["Server_Housing_PickupKey", 2];
}] call compile_Global;

["A3PL_Housing_Grabkey",
{
	if((animationState player) isEqualTo "a3pl_takenhostage") exitwith {[("STR_A3PL_Housing_HostageSituation" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if(animationState player IN ["a3pl_handsuptokneel","a3pl_handsupkneelgetcuffed","a3pl_cuff","a3pl_handsupkneelcuffed","a3pl_handsupkneelkicked","a3pl_cuffkickdown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","a3pl_handsupkneel"]) exitWith {[("STR_A3PL_Housing_Handcuffed" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _keyID = lbdata [1900,(lbCurSel 1900)];
	if (!(isNull Player_Item)) then {[false] call A3PL_Inventory_PutBack;};

	Player_Item = "A3PL_HouseKey" createVehicle (getPos player);
	Player_Item attachTo [player, [0,0,1], 'RightHand'];
	Player_ItemClass = "doorkey";
	Player_Item setVariable ["keyID",_keyID,true];
	[Player_Item] spawn A3PL_Placeable_AttachedLoop;

	player setVariable ["inventory_opened", nil, true];
	closeDialog 0;
	private _format = ("STR_A3PL_Housing_KeyTaken" call A3PL_Localize);
	[_format,Color_Yellow] call A3PL_Notification;
}] call compile_Global;

["A3PL_Housing_GetData",
{
	private _house = param [0,objNull];
	private _dataIndex = param [1,0];
	private _houseMap = Config_Houses_Data;
	private _houseData = _houseMap get (typeOf _house);
	private _return = _houseData#_dataIndex;
	_return;
}] call compile_Global;

["A3PL_Housing_OpenBuyMenu",
{
	disableSerialization;
	private _obj = param [0,objNull];
	if (isNull _obj) exitwith {};
	private _houses = nearestObjects [player, Config_Houses_List, 20];
	if (count _houses < 1) exitwith {["Can not find a house nearby (Inform an administrator that this house is not working properly)",Color_Red] call A3PL_Notification;};
	A3PL_Housing_Object = _houses select 0;
	private _price = [A3PL_Housing_Object,0] call A3PL_Housing_GetData;
 	createDialog "Dialog_HouseBuy";
	private _display = findDisplay 72;
	private _control = _display displayCtrl 1000;
	_control ctrlSetText format ["%1",[_price, 1, 2, true] call CBA_fnc_formatNumber];
}] call compile_Global;

["A3PL_Housing_Buy",
{
	private _price = [A3PL_Housing_Object,0] call A3PL_Housing_GetData;
	private _level = [A3PL_Housing_Object,3] call A3PL_Housing_GetData;
	private _namePos = [getPos A3PL_Housing_Object] call A3PL_Housing_PosAddress;
	private _adminLevel = player getVariable["dBVar_AdminLevel",0];
	private _hasAccount = [player,1] call A3PL_Bank_HasAccount;
	private _pBank = player getVariable["player_bank",0];
	private _getDay = player getVariable ["Player_PerkDay",0];
	if (_pBank < _price) exitwith {[("STR_A3PL_Housing_NotEnoughMoney" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!_hasAccount) exitWith {[("STR_Common_NoBankAccount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!isNil {A3PL_Housing_Object getVariable ["doorid",nil]}) exitwith {[("STR_A3PL_Housing_AlreadyBought" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((!isNil {player getVariable ["house",nil]}) && !(_getDay > 0)) exitwith {[("STR_A3PL_Housing_OneHouseLimit" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	
	[A3PL_Housing_Object,player,true,_price] remoteExec ["Server_Housing_AssignHouse", 2];
	[format [("STR_A3PL_Housing_Bought" call A3PL_Localize),_price,_namePos],Color_Green] call A3PL_Notification;
	[("STR_Common_FederalReserve" call A3PL_Localize),_price] remoteExec ["Server_Government_AddBalance",2];
	[A3PL_Housing_Object] spawn
	{
		private _house = param [0,objNull];
		private _marker = createMarkerLocal [format["house_%1",round (random 1000)],visiblePosition _house];
		_marker setMarkerTypeLocal "A3FL_Markers_OwnedHouse";
		_marker setMarkerSizeLocal [0.7, 0.7];
		_marker setMarkerAlphaLocal 1;
		_marker setMarkerColorLocal "Default";
		_marker setMarkerTextLocal (format [("STR_A3PL_Housing_Name" call A3PL_Localize),toUpperANSI((_house getVariable ["doorid",["1",("STR_Common_Unknown" call A3PL_Localize)]]) select 1)]);
	};
	A3PL_Housing_Object = nil;
	[getPlayerUID player,(player getVariable ["character_id",""]),"House_Bought",[format ["Location: %1 | Price: %2",(getPosATL _house),_price]]] remoteExec ["Server_Log_New",2];
	closeDialog 0;
}] call compile_Global;

["A3PL_Housing_Init",
{
	private ["_keys","_doorID","_keyID","_buildings","_marker","_text","_apt","_aptNumber"];

	waituntil {sleep 1; _keys = player getVariable "keys"; !isNil "_keys"};
	_keys = ["house"] call A3PL_Housing_keyFilter;
	_buildings = nearestObjects [[5000,5000,0], Config_Houses_List, 10000];
	{
		_doorID = _x getVariable "doorID";
		if (!isNil "_doorID") then
		{
			if ((_doorID select 1) IN _keys) then
			{
				_marker = createMarkerLocal [format["house_%1",round (random 1000)],visiblePosition _x];
				_marker setMarkerTypeLocal "A3FL_Markers_OwnedHouse";
				_marker setMarkerSizeLocal [0.7, 0.7];
				_marker setMarkerAlphaLocal 1;
				_marker setMarkerColorLocal "Default";
				_marker setMarkerTextLocal (format [("STR_A3PL_Housing_Name" call A3PL_Localize),toUpperANSI(_doorID select 1)]);
			};
		};
	} foreach _buildings;

	_apt = param [0,objNull];
	_aptNumber = param [1,-1];
	if ((isNull _apt) OR (_aptNumber == -1)) exitwith {};

	_marker = [_apt] call A3PL_Lib_NearestMarker;
	_marker setMarkerColorLocal "Default";
	_text = markerText _marker;
	_marker setMarkerTextLocal (format [("STR_A3PL_Housing_Room" call A3PL_Localize),_text,_aptNumber]);
	_marker setMarkerAlphaLocal 1;
}] call compile_Global;

["A3PL_Housing_AptAssignedMsg",
{
	private _objAssigned = param [0,objNull];
	private _aptAssigned = param [1,"0"];
	private _marker = [_objAssigned] call A3PL_Lib_NearestMarker;
	private _text = markerText _marker;
	[format [("STR_A3PL_Housing_AssignedRoom" call A3PL_Localize),_aptAssigned,_text],Color_Green] call A3PL_Notification;
	[_objAssigned,_aptAssigned] call A3PL_Housing_Init;
}] call compile_Global;

["A3PL_RealEstates_Open",
{
	disableSerialization;
	_sign = param[0,objNull];
	if(isNull _sign) exitWith {};

	_near = nearestObjects [player, Config_Houses_List, 20,true];
	if(count(_near) isEqualTo 0) exitWith {[("STR_A3PL_Housing_NoNearbyHouse" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_house = _near select 0;
	_owners = _house getVariable ["owner",[]];
	if(count _owners isEqualTo 0) exitwith {};
	_owner = _owners select 0;
	if((player getVariable ["character_id",""]) isEqualTo _owner) then {
		createDialog "Dialog_EstateSell";
		_display = findDisplay 67;
		_price = ([_house,0] call A3PL_Housing_GetData) * 0.75;
		_control = _display displayCtrl 1100;
		_control ctrlSetStructuredText parseText format ["<t align='center'>$%1</t>",[_price, 1, 0, true] call CBA_fnc_formatNumber];
	} else {
		[("STR_A3PL_Housing_NotOwner" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};
}] call compile_Global;

["A3PL_RealEstates_Sell",
{
	closeDialog 0;
	private _sign = (nearestObjects [player, ["Land_A3PL_EstateSign"], 10,true]) select 0;
	private _house = (nearestObjects [player, Config_Houses_List, 20,true]) select 0;
	private _housePrice = ([_house,0] call A3PL_Housing_GetData) * Housing_Sell_Coef;
	[getPos player,_housePrice, _sign, _house] remoteExec ["Server_Housing_Sold",2];
	private _marker = [getPos _house, "house"] call A3PL_Lib_NearestMarker;
	deleteMarkerLocal _marker;
	[getPlayerUID player,(player getVariable ["character_id",""]),"House_Sold",[format ["Location: %1 | Price: %2",(getPosATL _house),_housePrice]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

["A3PL_Housing_SetMarker",
{
	private _house = param [0,objNull];
	private _marker = createMarkerLocal [format["house_%1",round (random 1000)],visiblePosition _house];
	_marker setMarkerTypeLocal "A3FL_Markers_OwnedHouse";
	_marker setMarkerSizeLocal [0.7, 0.7];
	_marker setMarkerAlphaLocal 1;
	_marker setMarkerColorLocal "Default";
	_marker setMarkerTextLocal (format [("STR_A3PL_Housing_Key" call A3PL_Localize),((_house getVariable ["doorid",["1",("STR_Common_Unknown" call A3PL_Localize)]]) select 1)]);
}] call compile_Global;

["A3PL_Housing_PosAddress",
{
	private _position = param [0,[0,0,0]];
	private _adress = ("STR_Common_UnknownAddress" call A3PL_Localize);
	if (isNil "_position") exitWith {_adress;};
	private _building = (nearestObjects [_position, Buildings_Used_For_Address, 80])#0;
	_address = _building getVariable["Building_Address",("STR_Common_UnknownAddress" call A3PL_Localize)];
	_address;
}] call compile_Global;

["A3PL_Housing_LeaveHouse",
{
	private _near = nearestObjects [player, Config_Houses_List, 20,true];
	if(count(_near) isEqualTo 0) exitWith {[("STR_A3PL_Housing_NoNearbyHouse" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _owners = (_near select 0) getVariable ["owner",[]];
	if(count _owners isEqualTo 0) exitwith {};
	private _owner = _owners select 0;
	if((player getVariable ["character_id",""]) isEqualTo _owner) exitWith {[("STR_A3PL_Housing_OwnerLeave" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[player, (_near select 0)] remoteExec ["Server_Housing_RemoveMember",2];
}] call compile_Global;

["A3PL_Housing_RemoveRoommateReceive",
{
	params[
		["_roommates", [], [[]]]
	];

	if (_roommates isEqualTo []) exitWith {
		[("STR_A3PL_Housing_RoommatesError" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};

	disableSerialization;

	createDialog "Dialog_Roommates";
	private _display = findDisplay 87;

	{
		private _i = lbAdd [1500, (_x select 1)];
		lbSetData [1500, _i, (_x select 0)];
	} forEach _roommates;
}] call compile_Global;

["A3PL_Housing_RemoveRoommate",
{
	if (!isNil "A3PL_Warehouses_RoommatesOpen" && {A3PL_Warehouses_RoommatesOpen}) then {
		A3PL_Warehouses_RoommatesOpen = nil;
		call A3PL_Warehouses_RemoveRoommate;
	} else {
		private _display = findDisplay 87;
		private _control = _display displayCtrl 1500;
		private _removeID = _control lbData (lbCurSel _control);

		private _house = player getVariable ["house", objNull];

		if ((player getVariable ["character_id",""]) isEqualTo _removeID) exitWith {
			[("STR_A3PL_Housing_OwnerKickSelf" call A3PL_Localize),Color_Red] call A3PL_Notification;
		};

		private _allPlayers = call BIS_fnc_listPlayers;
		private _isConnected = [objNull, false];
		{
			if ((_x getVariable ["character_id",""]) isEqualTo _removeID) exitWith {
				_isConnected = [_x, true];
			};
		} forEach _allPlayers;

		if (!(isNull _house)) then {
			if (!(_isConnected select 1)) then {
				[player, _removeID] remoteExec ["Server_Housing_RemoveMemberOffline", 2];
			} else {
				[("STR_A3PL_Housing_RoommateKicked" call A3PL_Localize),Color_Green] call A3PL_Notification;
				[(_isConnected select 0), _house] remoteExec ["Server_Housing_RemoveMember", 2];
			};
		};

		closeDialog 0;
	};
}] call compile_Global;

["A3PL_Housing_ShowUnowned",
{
	private ["_return","_nearestSign"];
    private _search = param [0,"None"];
	private _markerList = [];
	switch(_search) do {
        case ("STR_A3PL_Housing_Hangar" call A3PL_Localize): { _return = Buildings_Hangar; };
        case ("STR_A3PL_Housing_Caravan" call A3PL_Localize): { _return = Buildings_Trailer; };
		case ("STR_A3PL_Housing_SingleStory" call A3PL_Localize): { _return = Building_Plane; };
		case ("STR_A3PL_Housing_1FloorGarage" call A3PL_Localize): { _return = Buildings_1Floor_1Garage; };
		case ("STR_A3PL_Housing_1Floor" call A3PL_Localize): { _return = Buildings_1Floor; };
		case ("STR_A3PL_Housing_1FloorSmallL" call A3PL_Localize): { _return = Buildings_1FloorLittle_L; };
        case ("STR_A3PL_Housing_1FloorLargeL" call A3PL_Localize): { _return = Buildings_1FloorBig_L; };
		case ("STR_A3PL_Housing_2FloorGarage" call A3PL_Localize): { _return = Buildings_2Floors_1Garage; };
        case ("STR_A3PL_Housing_2Floor" call A3PL_Localize): { _return = Buildings_2Floors; };
        case ("STR_A3PL_Housing_Villa" call A3PL_Localize): { _return = Buildings_Villas; };
        case ("STR_A3PL_Housing_BigVilla" call A3PL_Localize): { _return = Buildings_BigVillas; };
    };
	private _houses = nearestObjects [player, _return, 500];

	if (_search isEqualTo "None") exitWith {["Someone didnt call the function properly",Color_Red] call A3PL_Notification;};
	{
		_owners = _x getVariable ["owner",[]];
		_nearestSign = (nearestObjects [getPos _x,["Land_A3PL_EstateSign"],20]);
		if (_owners isEqualTo [] && count(_nearestSign) > 0) then {
			_marker = createMarkerLocal [format["%1_marker",floor (random 5000)],getpos _x];
			_marker setMarkerShapeLocal "ICON";
			_marker setMarkerTypeLocal "A3FL_Markers_UnownedHouse";
			_marker setMarkerTextLocal "";
			_marker setMarkerColorLocal "Default";
			_marker setMarkerAlphaLocal 0.8;

			_markerList pushBack (_marker);
		};
	} forEach _houses;
	_count = count(_markerList);
	[format[("STR_A3PL_Housing_NearbyUnownedHouses" call A3PL_Localize),_count,_search],Color_Yellow] call A3PL_Notification;
	uiSleep 120;
	{deleteMarkerLocal _x;} forEach _markerList;
	waitUntil {_markerList isEqualTo []};
	[("STR_A3PL_Housing_MapBlipRemoved" call A3PL_Localize),Color_Yellow] call A3PL_Notification;
}] call compile_Global;

["A3PL_Housing_DropKey",
{
	params [["_keyID", "", [""]]];

	if (_keyID isEqualTo "") exitWith {};

	if ((animationState player) isEqualTo "a3pl_takenhostage") exitWith {
		[("STR_A3PL_Housing_HostageSituation" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};

	if (animationState player IN ["a3pl_handsuptokneel","a3pl_handsupkneelgetcuffed","a3pl_cuff","a3pl_handsupkneelcuffed","a3pl_handsupkneelkicked","a3pl_cuffkickdown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","a3pl_handsupkneel"]) exitWith {
		[("STR_A3PL_Housing_Handcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};

	if (!(isNull Player_Item)) then {
		[false] call A3PL_Inventory_PutBack;
	};

	Player_Item = "A3PL_HouseKey" createVehicle (getPos player);
	Player_Item attachTo [player, [0,0,1], "RightHand"];
	Player_ItemClass = "doorkey";
	Player_Item setVariable ["keyID", _keyID, true];
	[Player_Item] spawn A3PL_Placeable_AttachedLoop;

	player setVariable ["inventory_opened", nil, true];
	[("STR_A3PL_Housing_KeyTaken" call A3PL_Localize), Color_Yellow] call A3PL_Notification;
}] call compile_Global;

["A3PL_Housing_Raid",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private _buildings = nearestObjects [player, Config_Houses_List, 10];
	if (count _buildings isEqualTo 0) exitWith {[("STR_A3PL_Housing_RaidNoBuilding" call A3PL_Localize), Color_Red] call A3PL_Notification;};
	private _house = _buildings#0;

	private _action = [("STR_A3PL_Housing_RaidConfirm" call A3PL_Localize)] call A3PL_Lib_ConfirmationDialog;
	if (!isNil "_action" && {!_action}) exitWith {};

	if (Player_ActionDoing) exitWith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[("STR_A3PL_Housing_RaidProgress" call A3PL_Localize), 30] spawn A3PL_Lib_LoadActionQTE;
	waitUntil{Player_ActionDoing};
	while {Player_ActionDoing} do {
		if (!(player getVariable["A3PL_Medical_Alive",true])) exitWith {Player_ActionInterrupted = true;};
		if ((vehicle player) != player) exitWith {Player_ActionInterrupted = true;};
		if (player getVariable ["Incapacitated",false]) exitWith {Player_ActionInterrupted = true;};
	};
	if(Player_ActionInterrupted) exitWith {};

	if (random 1 < Raid_Alert_Chance) then {
		private _owners = _house getVariable ["owner",[]];
		{
			private _ownerPlayer = [_x] call A3PL_Lib_charIDToObject;
			if (!isNull _ownerPlayer) then {
				[("STR_A3PL_Housing_RaidAlert" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _ownerPlayer];
			};
		} forEach _owners;
	};

	[player, _house] remoteExec ["Server_Housing_LoadBox", 2];
	[("STR_A3PL_Housing_RaidComplete" call A3PL_Localize), Color_Green] call A3PL_Notification;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Housing_Raid",[format ["House: %1 | Location: %2",typeOf _house,getPosATL _house]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;