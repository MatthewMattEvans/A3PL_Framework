/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Warehouses_OpenBuyMenu",
{
	disableSerialization;
	private _obj = param [0,objNull];
	if (isNull _obj) exitwith {};
	private _warehouses = nearestObjects [player, Config_Warehouses_List, 20];
	if (count _warehouses < 1) exitwith {[("STR_A3PL_Warehouses_CannotFindHouse" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	A3PL_Warehouses_Object = _warehouses select 0;
	private _price = [A3PL_Warehouses_Object,0] call A3PL_Warehouses_GetData;
 	createDialog "Dialog_WarehouseBuy";
	private _display = findDisplay 75;
	private _control = _display displayCtrl 1000;
	_control ctrlSetText format ["%1",[_price, 1, 2, true] call CBA_fnc_formatNumber];
}] call compile_Global;

["A3PL_Warehouses_Buy",
{
	private _warehouses = nearestObjects [player, Config_Warehouses_List, 20];
	if (count _warehouses < 1) exitwith {[("STR_A3PL_Warehouses_CannotFindHouse" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	A3PL_Warehouses_Object = _warehouses select 0;
	private _price = [A3PL_Warehouses_Object,0] call A3PL_Warehouses_GetData;
	private _level = [A3PL_Warehouses_Object,3] call A3PL_Warehouses_GetData;
	private _hasAccount = [player,1] call A3PL_Bank_hasAccount;
	if (!_hasAccount) exitwith {[("STR_Common_NoBankAccount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _pBank = player getVariable["Player_Bank",0];
	if (_pBank < _price) exitwith {[("STR_A3PL_Warehouses_InsufficientFunds" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!isNil {A3PL_Warehouses_Object getVariable ["doorid",nil]}) exitwith {[("STR_A3PL_Warehouses_Owned" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!isNil {player getVariable ["warehouse",nil]}) exitwith {[("STR_A3PL_Warehouses_OwnedByYou" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	[A3PL_Warehouses_Object,player,true,_price] remoteExec ["Server_Warehouses_Assign", 2];
	closeDialog 0;
	_namePos = [getPos A3PL_Warehouses_Object] call A3PL_Housing_PosAddress;
	[format [("STR_A3PL_Warehouses_Bought" call A3PL_Localize),_price,_namePos],Color_Green] call A3PL_Notification;
	[("STR_Common_FederalReserve" call A3PL_Localize),_price] remoteExec ["Server_Government_AddBalance",2];
	[A3PL_Warehouses_Object] spawn
	{
		private _warehouse = param [0,objNull];
		private _marker = createMarkerLocal [format["warehouse_%1",round (random 1000)],visiblePosition _warehouse];
		_marker setMarkerTypeLocal "A3FL_Markers_OwnedWarehouse";
		_marker setMarkerSizeLocal [0.7, 0.7];
		_marker setMarkerAlphaLocal 1;
		_marker setMarkerColorLocal "Default";
		_marker setMarkerTextLocal (format [("STR_A3PL_Warehouses_Marker" call A3PL_Localize),toUpperANSI((_warehouse getVariable ["doorid",["1",("STR_Common_Unknown" call A3PL_Localize)]]) select 1)]);
	};
	[getPlayerUID player,(player getVariable ["character_id",""]),"Warehouse_Bought",[format ["Price: %1 | Location: %2",_price,getPosATL A3PL_Warehouses_Object]]] remoteExec ["Server_Log_New",2];
	A3PL_Warehouses_Object = nil;
}] call compile_Global;

["A3PL_Warehouses_Init",
{
	private ["_keys","_doorID","_keyID","_buildings","_marker","_text","_apt","_aptNumber"];
	waituntil {sleep 1; _keys = player getVariable "keys"; !isNil "_keys"};
	_keys = ["warehouse"] call A3PL_Housing_keyFilter;
	_buildings = nearestObjects [[5000,5000,0], Config_Warehouses_List, 5000];
	{
		_doorID = _x getVariable "doorID";
		if (!isNil "_doorID") then
		{
			if ((_doorID select 1) IN _keys) then
			{
				_marker = createMarkerLocal [format["warehouse_%1",round (random 1000)],visiblePosition _x];
				_marker setMarkerTypeLocal "A3FL_Markers_OwnedWarehouse";
				_marker setMarkerSizeLocal [0.7, 0.7];
				_marker setMarkerAlphaLocal 1;
				_marker setMarkerColorLocal "Default";
				_marker setMarkerTextLocal (format [("STR_A3PL_Warehouses_Marker" call A3PL_Localize),toUpperANSI(_doorID select 1)]);
			};
		};
	} foreach _buildings;
}] call compile_Global;

["A3PL_Warehouses_SetMarker",
{
	private _warehouse = param [0,objNull];
	private _marker = createMarkerLocal [format["warehouse_%1",round (random 1000)],visiblePosition _warehouse];
	_marker setMarkerTypeLocal "A3FL_Markers_OwnedWarehouse";
	_marker setMarkerSizeLocal [0.7, 0.7];
	_marker setMarkerAlphaLocal 1;
	_marker setMarkerColorLocal "Default";
	_marker setMarkerTextLocal (format [("STR_A3PL_Warehouses_Marker" call A3PL_Localize),toUpperANSI((_warehouse getVariable ["doorid",["1",("STR_Common_Unknown" call A3PL_Localize)]]) select 1)]);
}] call compile_Global;

["A3PL_Warehouses_GetData",
{
	private _wh = param [0,objNull];
	private _dataIndex = param [1,0];
	private _whMap = Config_Warehouses_Data;
	private _whData = _whMap get (typeOf _wh);
	private _return = _whData#_dataIndex;
	_return;
}] call compile_Global;

["A3PL_Warehouses_SellOpen",
{
	disableSerialization;
	private _sign = param[0,objNull];
	if(isNull _sign) exitWith {};
	private _near = nearestObjects [player, Config_Warehouses_List, 30,true];
	if(count(_near) isEqualTo 0) exitWith {[("STR_A3PL_Warehouses_NoWarehousesNearby" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _warehouse = _near select 0;
	private _owners = _warehouse getVariable ["owner",[]];
	if(count _owners isEqualTo 0) exitwith {};
	private _owner = _owners select 0;
	if((player getVariable ["character_id",""]) isEqualTo _owner) then {
		createDialog "Dialog_EstateSell";
		private _display = findDisplay 67;
		private _price = ([_warehouse,0] call A3PL_Warehouses_GetData) * 0.75;
		private _control = _display displayCtrl 1100;
		_control ctrlSetStructuredText parseText format ["<t align='left'>$%1</t>",[_price, 1, 0, true] call CBA_fnc_formatNumber];
		buttonSetAction [100, "call A3PL_Warehouses_Sell;"];		
	} else {
		[("STR_A3PL_Warehouses_SellOnlyOwner" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};
}] call compile_Global;

["A3PL_Warehouses_Sell",
{
	closeDialog 0;
	private _sign = (nearestObjects [player, ["Land_A3PL_BusinessSign"], 10,true]) select 0;
	private _warehouse = (nearestObjects [player, Config_Warehouses_List, 30,true]) select 0;
	private _whPrice = ([_warehouse,0] call A3PL_Warehouses_GetData) * 0.75;
	[getPos player,_whPrice, _sign, _warehouse] remoteExec ["Server_Warehouses_Sold",2];
	private _marker = [getPos _warehouse, "warehouse"] call A3PL_Lib_NearestMarker;
	deleteMarkerLocal _marker;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Warehouse_Sold",[format ["Price: %1 | Location: %2",_whPrice,(getPosATL _warehouse)]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

["A3PL_Warehouses_LeaveWarehouse",
{
	private _near = nearestObjects [player, Config_Warehouses_List, 30,true];
	if(count(_near) isEqualTo 0) exitWith {[("STR_A3PL_Warehouses_NoWarehousesNearby" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _owners = (_near select 0) getVariable ["owner",[]];
	if(count _owners isEqualTo 0) exitwith {};
	private _owner = _owners select 0;
	if((player getVariable ["character_id",""]) isEqualTo _owner) exitWith {[("STR_A3PL_Warehouses_OwnerCannotLeave" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[player, (_near select 0)] remoteExec ["Server_Warehouses_RemoveMember",2];
}] call compile_Global;

["A3PL_Warehouses_RemoveRoommateReceive",
{
	params[
		["_roommates", [], [[]]]
	];

	if (_roommates isEqualTo []) exitWith {
		[("STR_A3PL_Warehouses_RoommatesError" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};

	disableSerialization;

	createDialog "Dialog_Roommates";
	private _display = findDisplay 87;

	{
		private _i = lbAdd [1500, (_x select 1)];
		lbSetData [1500, _i, (_x select 0)];
	} forEach _roommates;

	A3PL_Warehouses_RoommatesOpen = true;
}] call compile_Global;

["A3PL_Warehouses_RemoveRoommate",
{
	disableSerialization;
	private _display = findDisplay 87;
	private _sel = lbCurSel 1500;
	if (_sel isEqualTo -1) exitWith {[("STR_A3PL_Warehouses_SelectRoommate" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _removeID = lbData [1500, _sel];
	private _near = nearestObjects [player, Config_Warehouses_List, 30,true];
	if (count _near isEqualTo 0) exitWith {};
	private _warehouse = _near select 0;
	private _isConnected = [_removeID] call A3PL_Lib_charIDToObject;
	if (isNull _isConnected) then {
		[player, _removeID] remoteExec ["Server_Warehouses_RemoveMemberOffline", 2];
	} else {
		[_isConnected, _warehouse] remoteExec ["Server_Warehouses_RemoveMember", 2];
	};
	closeDialog 0;
	A3PL_Warehouses_RoommatesOpen = nil;
}] call compile_Global;

["A3PL_Warehouse_Raid",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private _buildings = nearestObjects [player, Config_Warehouses_List, 10];
	if (count _buildings isEqualTo 0) exitWith {[("STR_A3PL_Housing_RaidNoBuilding" call A3PL_Localize), Color_Red] call A3PL_Notification;};
	private _warehouse = _buildings#0;

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
		private _owners = _warehouse getVariable ["owner",[]];
		{
			private _ownerPlayer = [_x] call A3PL_Lib_charIDToObject;
			if (!isNull _ownerPlayer) then {
				[("STR_A3PL_Housing_RaidAlert" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _ownerPlayer];
			};
		} forEach _owners;
	};

	[player, _warehouse] remoteExec ["Server_Warehouses_LoadBox", 2];
	[("STR_A3PL_Housing_RaidComplete" call A3PL_Localize), Color_Green] call A3PL_Notification;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Warehouse_Raid",[format ["Warehouse: %1 | Location: %2",typeOf _warehouse,getPosATL _warehouse]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;
