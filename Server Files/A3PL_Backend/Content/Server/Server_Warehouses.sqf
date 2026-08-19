/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
#define WAREHOUSELIST ["Land_John_Hangar","Land_A3FL_Warehouse"]

["Server_Warehouses_SaveItems",
{
	private _delete = param [0,false];
	{
		private _warehouse = _x;
		private _items = nearestObjects [_warehouse, [],30];
		private _itemsToSave = [];
		{
			if (typeOf _x IN ["A3PL_WheelieBin"]) exitWith {};
			if (!isNil {_x getVariable "class"} && ((nearestObjects[_x, WAREHOUSELIST, 30]) find _warehouse) != -1) then {
				_itemsToSave pushback _x;
			};
		} foreach _items; 
		private _pItems = [];
		{
			_pItems pushback [(typeOf _x),(_x getVariable "class"),getPosASL _x,getDir _x];
			if (_delete) then {deleteVehicle _x; _warehouse setVariable ["furn_loaded",false,true];};
		} foreach _itemsToSave;
		private _myItems = str(_pItems);
		private _query = format ["UPDATE warehouses SET pitems='%1' WHERE location ='%2'",_myItems,(getpos _warehouse)];
		[_query,1] spawn Server_Database_Async;
	} foreach Server_WarehouseList;
}] call compile_Server;

["Server_Warehouses_LockUnlockFurnitures",
{
	private _player = param [0,objNull];
	private _warehouse = param [1,objNull];
	private _items = nearestObjects [_warehouse, [],30];
	private _itemsToLock = [];
	{
		if (typeOf _x IN ["A3PL_WheelieBin"]) exitWith {};
		if (!isNil {_x getVariable "class"} && ((nearestObjects[_x, WAREHOUSELIST, 30]) find _warehouse) != -1) then {
			_itemsToLock pushback _x;
		};
	} foreach _items;
	private _lockStatus = !(_itemsToLock#0 getVariable ["locked",false]);
	{
		_x setVariable ["locked",_lockStatus,true];
	} foreach _itemsToLock;
	if (_lockStatus) then {
		_lockStatus = 1;
		["STR_A3PL_Placeables_FurnituresLocked" call A3PL_Localize, Color_Green] remoteExec ["A3PL_Notification", _player];
	} else {
		["STR_A3PL_Placeables_FurnituresUnlocked" call A3PL_Localize, Color_Green] remoteExec ["A3PL_Notification", _player];
		_lockStatus = 0;
	};
	private _query = format ["UPDATE warehouses SET itemslocked='%1' WHERE location ='%2'",_lockStatus,(getpos _warehouse)];
	[_query,1] spawn Server_Database_Async;
}] call compile_Server;

["Server_Warehouses_LoadItems",
{
	{
		private _warehouse = _x;
		if (_warehouse getVariable ["furn_loaded",false]) then {continue; diag_log "Furniture already spawned";};
		_warehouse setVariable ["furn_loaded",true,true];

		private _query = format ["SELECT pitems, itemslocked FROM warehouses WHERE location = '%1'",(getpos _warehouse)];
		private _result = [_query, 2] call Server_Database_Async;
		private _pItems = _result select 0;
		private _itemsLocked = _result select 1;

		private _locked = false;
		if (!isNil "_itemsLocked" && (_itemsLocked) isEqualTo 1) then { _locked = true; };

		private _allOwners = _warehouse getVariable ["owner",[]]; 
		private _objects = [];
		{
			private _classname = _x#0;
			private _class = _x#1;
			private _pos = _x#2;
			private _dir = _x#3;
			private _obj = createVehicle [_classname, _pos, [], 0, "CAN_COLLIDE"];
			if (!([_class,"simulation"] call A3PL_Config_GetItem)) then {[_obj] call Server_Housing_LoadItemsSimulation;};
			_obj setDir _dir;
			_obj setPosASL _pos;
			_obj setVariable ["owner",_allOwners,true];
			_obj setVariable ["class",_class,true];
			_obj setVariable ["locked",_locked,true];
		} foreach _pItems;
	} foreach Server_WarehouseList;
}] call compile_Server;

["Server_Warehouses_LoadBox",
{
	private _player = param [0,objNull];
	private _warehouse = param [1,objNull];
	private _pos = getposATL _player;
	_pos = [_pos select 0,_pos select 1,((_pos select 2) + 0.25)];
	private _items = [[],[],[]];
	private _vItems = [[],[],[]];
	if (!isNil {_warehouse getVariable "box_spawned"}) exitwith {};
	_warehouse setVariable ["box_spawned",true,false];

	if (isDedicated) then { _items = [format ["SELECT items FROM warehouses WHERE location = '%1'",(getpos _warehouse)], 2, true] call Server_Database_Async;} else {_items = [[],[],[]];};
	if (isDedicated) then { _vItems = [format ["SELECT vitems FROM warehouses WHERE location = '%1'",(getpos _warehouse)], 2, true] call Server_Database_Async;} else {_vitems = [[],[],[]];};
	private _box = createVehicle ["Box_GEN_Equip_F",_pos, [], 0, "CAN_COLLIDE"];
	_box allowDamage false;
	private _cargoItems = ((_items select 0) select 0);
	private _weapons = _cargoItems select 0;
	private _magazines = _cargoItems select 1;
	private _actualitems = _cargoItems select 2;
	private _backpacks = _cargoItems select 3;

	clearItemCargoGlobal _box;
	clearWeaponCargoGlobal _box;
	clearMagazineCargoGlobal _box;
	clearBackpackCargoGlobal _box;

	{_box addWeaponCargoGlobal [_x,1]} foreach _weapons;
	{_box addMagazineCargoGlobal [_x,1]} foreach _magazines;
	{_box addItemCargoGlobal [_x,1]} foreach _actualitems;
	{_box addBackpackCargoGlobal [_x,1]} foreach _backpacks;

	private _virtualItems = call compile ((_vItems select 0) select 0);
	_box setVariable ["storage",_virtualItems,true];

	private _sCapacity = [_warehouse,2] call A3PL_Warehouses_GetData;
	_box setVariable ["capacity",_sCapacity,true];
	_box setVariable["warehouse",true,true];
}] call compile_Server;

["Server_Warehouses_SaveBox",
{
	private _warehouse = param [0,objNull];
	private _box = param [1,objNull];
	private _pos = getpos _warehouse;
	private _aitems = itemCargo _box;
	{
		if (["a3pl_iphone_1", _x] call BIS_fnc_inString) then {
			_aitems set[_forEachIndex,"a3pl_iphone_1"];
		};
		if (["a3pl_3310_1", _x] call BIS_fnc_inString) then {
			_aitems set[_forEachIndex,"a3pl_3310_1"];
		};
		if (["a3pl_sonySD_1", _x] call BIS_fnc_inString) then {
			_aitems set[_forEachIndex,"a3pl_sonySD_1"];
		};
		if (["a3pl_sonyFD_1", _x] call BIS_fnc_inString) then {
			_aitems set[_forEachIndex,"a3pl_sonyFD_1"];
		};
	} foreach _aitems;
	private _items = [weaponCargo _box,magazineCargo _box,_aitems,backpackCargo _box];
	private _myItems = str (_items);
	private _query = format ["UPDATE warehouses SET items='%1',vitems='%3' WHERE location ='%2'",_myItems,_pos,(_box getVariable ["storage",[]])];
	[_query,1] spawn Server_Database_Async;

	deleteVehicle _box;

	_warehouse setVariable ["box_spawned",nil,false];
}] call compile_Server;

["Server_Warehouses_Initialize",
{
	private ["_warehouses","_query","_return","_charID","_pos","_doorID","_near","_signs"];
	_warehouses = ["SELECT charids,location,doorid FROM warehouses", 2, true] call Server_Database_Async;
	{
		private ["_pos","_charIDs","_doorid"];
		_charIDs = [(_x select 0)] call Server_Database_ToArray;
		_pos = call compile (_x select 1);
		_doorid = _x select 2;

		_near = nearestObjects [_pos, ["Land_John_Hangar","Land_A3FL_Warehouse"],10];
		if (count _near isEqualTo 0) then
		{
			_query = format ["DELETE FROM warehouses WHERE location = '%1'",_pos];
			[_query,1] spawn Server_Database_Async;
		} else {
			_near = _near select 0;
		    if (_pos isNotEqualTo (getpos _near)) then
			{
				_query = format ["UPDATE warehouses SET location='%1', classname = '%3' WHERE location ='%2'",(getpos _near),_pos, (typeOf _near)];
				[_query,1] spawn Server_Database_Async;
			};

			_signs = nearestObjects [_pos, ["Land_A3PL_BusinessSign"],25];
			if (count _signs > 0) then
			{
				(_signs select 0) setObjectTextureGlobal [0,"\A3PL_Objects\Street\business_sign\business_rented_co.paa"];
			};

			_near setVariable ["doorID",[_charIDs,_doorid],true];
			_near setVariable ["owner",_charIDs,true];
			Server_WarehouseList pushback _near;
		};			
	} foreach _warehouses;
	publicVariable "Server_WarehouseList";
}] call compile_Server;

["Server_Warehouses_Assign",
{
	private _object = param [0,objNull];
	private _player = param [1,objNull];
	private _takeMoney = param [2,true];
	private _price = param [3,0];
	private _charID = _player getVariable ["character_id",""];

	_object setVariable ["owner",[_charID],true];
	if (_takeMoney) then
	{
		_player setVariable ["player_bank",((_player getVariable ["player_bank",0]) - _price),true];
	};
	private _keyID = [_player,_object,"",true,"warehouse"] call Server_Housing_CreateKey;
	if (!(_object IN Server_WarehouseList)) then
	{
		Server_WarehouseList pushback _object;
	};

	private _pos = getpos _object;
	_charID = [[_charID]] call Server_Database_Array;
	private _insert = format ["INSERT INTO warehouses (charids,classname,location,doorid,items,pitems) VALUES ('%1','%2','%3','%4','[[],[],[]]','[]') ON DUPLICATE KEY UPDATE doorID='%3'",_charID,typeOf _object,_pos,_keyID];
	[_insert,1] spawn Server_Database_Async;

	_player setVariable ["warehouse",_object,true];

	private _signs = nearestObjects [_pos, ["Land_A3PL_BusinessSign"],20];
	if (count _signs > 0) then
	{
		(_signs select 0) setObjectTextureGlobal [0,"\A3PL_Objects\Street\business_sign\business_rented_co.paa"];
	};

}] call compile_Server;

["Server_Warehouses_AddMember",
{
	_owner = param [0,objNull];
	_new = param [1,objNull];
	_warehouse = param [2,objNull];


	_actuals = _warehouse getVariable "owner";
	if((_actuals find (_new getVariable ["character_id",""])) != -1) exitWith {};

	_actuals pushback(_new getVariable ["character_id",""]);
	_warehouse setVariable["owner", _actuals,true];

	_actuals = [_actuals] call Server_Database_Array;
	_query = format ["UPDATE warehouses SET charids='%1' WHERE location ='%2'",_actuals,(getpos _warehouse)];
	[_query,1] spawn Server_Database_Async;

	_new setVariable ["warehouse",_warehouse,true];
	_keysid = (_warehouse getVariable ["doorID",[]] select 1);
	_oldKeys = _new getVariable ["keys",[]];
	_oldKeys pushBack _keysid;
	_new setVariable ["keys",_oldKeys,true];

	[("STR_Server_Warehouses_AddMember_YouGetKey" call A3PL_Localize),Color_Green] remoteExec ["A3PL_Notification",owner _new];
	[_warehouse] remoteExec ["A3PL_Warehouses_SetMarker",_new];
}] call compile_Server;

["Server_Warehouses_RemoveMember",
{
	private _old = param [0,objNull];
	private _warehouse = param [1,objNull];
	private _charID = _old getVariable ["character_id",""];
	private _allMembers = _warehouse getVariable "owner";
	if((_allMembers find _charID) != -1) then {
		_allMembers deleteAt (_allMembers find _charID);
		_warehouse setVariable["owner", _allMembers,true];

		private _allMembers = [_allMembers] call Server_Database_Array;
		private _query = format ["UPDATE warehouses SET charids='%1' WHERE location ='%2'", _allMembers, (getpos _warehouse)];
		[_query,1] spawn Server_Database_Async;

		_keys = _old getVariable ["keys",[]];
		_keys deleteAt (_keys find (_warehouse getVariable "doorid" select 1));
		_old setVariable ["keys",_keys,true];
		_old setVariable ["warehouse",nil,true];
		[("STR_Server_Warehouses_RemoveMember_KeyRemoved" call A3PL_Localize),Color_Yellow] remoteExec ["A3PL_Notification",owner _old];
	};
}] call compile_Server;

["Server_Warehouses_GetRoommates",
{
	params[
		["_player", objNull, [objNull]]
	];

	private _warehouse = _player getVariable ["warehouse", objNull];

	if (isNull _warehouse) exitWith {
		[("STR_Server_Warehouses_YouDontHaveWarehouse" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", (owner _player)];
	};

	private _charIDs = _warehouse getVariable ["owner", []];

	if (!((_player getVariable ["character_id",""]) isEqualTo (_charIDs select 0))) exitWith {
		[("STR_Server_Warehouses_OnlyOwnerCanManageRoommates" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", (owner _player)];
	};

	private _names = [];

	{
		private _query = format ["SELECT name FROM players WHERE charid = '%1'", _x];
		private _result = [_query, 2] call Server_Database_Async;
		_names pushBack ([_x, _result select 0]);
	} foreach _charIDs;

	[_names] remoteExec ["A3PL_Warehouses_RemoveRoommateReceive", (owner _player)];
}] call compile_Server;

["Server_Warehouses_RemoveMemberOffline",
{
	params[
		["_player", objNull, [objNull]],
		["_removedRoommate", "", [""]]
	];

	private _warehouse = _player getVariable ["warehouse", objNull];
	private _members = _warehouse getVariable ["owner", []];

	if ((_members find _removedRoommate) != -1) then {
		_members deleteAt (_members find _removedRoommate);
		_warehouse setVariable ["owner", _members, true];

		_members = [_members] call Server_Database_Array;

		_query = format ["UPDATE warehouses SET charids='%1' WHERE location='%2'", _members, (getpos _warehouse)];
		[_query, 1] call Server_Database_Async;

		private _warehouseID = ((_warehouse getVariable ["doorid", []]) select 1);
		[_removedRoommate, _warehouseID] call Server_Warehouses_RemoveOfflineKey;

		[("STR_Server_Warehouses_YouKickedRoommate" call A3PL_Localize), Color_Green] remoteExec ["A3PL_Notification", (owner _player)];
	} else {
		[("STR_Server_Warehouses_ErrorRemovingRoommate" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", (owner _player)];
	};
}] call compile_Server;

["Server_Warehouses_RemoveOfflineKey",
{
	params[
		["_charID", "", [""]],
		["_warehouseID", "", [""]]
	];

	private _query = format ["SELECT userkey FROM players WHERE charid = '%1'", _charID];
	private _result = [_query, 2] call Server_Database_Async;

	private _keys = [(([(_result select 0)] call Server_Database_ToArray) - [_warehouseID])] call Server_Database_Array;

	private _query = format ["UPDATE players SET userkey='%1' WHERE charid='%2'", _keys, _charID];
	[_query, 1] call Server_Database_Async;
}] call compile_Server;

["Server_Warehouses_Sold",
{
	params [
		["_pos",[0,0,0],[[]]],
		["_clientPart",0,[0]],
		["_sign",objNull,[objNull]],
		["_warehouse",objNull,[objNull]]
	];

	_hasBankAccount = (_player getVariable ["Player_BankActive",0]) isnotEqualTo 0;
	if (!_hasBankAccount) exitWith {[("STR_Server_Warehouses_Sold_YouDoNotHaveBankAccount" call A3PL_Localize),Color_Green] remoteExec["A3PL_Notification",_player];};
	_sign setVariable["houseSelling",false,true];
	_sign setObjectTextureGlobal [0,"\A3PL_Objects\Street\estate_sign\house_sale_co.paa"];

	private _charIDs = _warehouse getVariable ["owner",[]];
	private _id = (_warehouse getVariable ["doorid",[]]) select 1;
	private _query = format ["DELETE FROM warehouses WHERE location ='%1'",getPos(_warehouse)];
	[_query,1] spawn Server_Database_Async;

	private _charID = _charIDs select 0;

	_warehouse setVariable ["owner",nil,true];
	_warehouse setVariable ["doorid",nil,true];

	private _furnitures = nearestObjects [_pos, ["Thing"],100];
	{if((_x getVariable "owner") isEqualTo _charID) then {deleteVehicle _x;};} foreach _furnitures;

	private _player = [_charID] call A3PL_Lib_charIDToObject;
	if(!isNull _player) then {
		_pbank = _player getVariable ["Player_Bank",0];
		_keys = _player	getVariable["keys",[]];
		_player setVariable ["Player_Bank",_pbank+_clientPart,true];
		_player setVariable ["keys",_keys - [_id],true];
		_player setVariable ["warehouse",nil,true];
		[format[("STR_Server_Warehouses_Sold_YouSoldWarehouseFor" call A3PL_Localize),_clientPart], Color_Green] remoteExec ["A3PL_Notification",_player];
	};
	if(count(_charIDs) > 1) then {
		for "_i" from 1 to count(_charIDs)-1 do {
			private ["_roommate","_keys"];
			_roomate = [_x] call A3PL_Lib_charIDToObject;
			_keys = _roomate getVariable["keys",[]];
			_roomate setVariable ["warehouse",nil,true];
			_roomate setVariable ["keys",_keys - [_id],true];
		};
	};
}] call compile_Server;
