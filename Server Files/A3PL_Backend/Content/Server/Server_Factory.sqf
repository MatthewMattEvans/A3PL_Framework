/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["Server_Factory_Finalise", {
	private ["_i"];
	params[
		["_player",objNull,[objNull]],
		["_type","",[""]],
		["_id","",[""]],
		["_required",[],[[]]],
		["_add",1,[1]],
		["_hasFail", false, [false]]
	];
	private _items = [_type,"items",_player] call A3PL_Config_GetPlayerFStorage;

	private _storage = _player getVariable ["player_fstorage",[]];
	private _amount = ([_id,_type,"output"] call A3PL_Config_GetFactory)*_add;

	if (_hasFail) then {
		private _giveBackAmmount = Config_Factories_BP#1;
		private _random = random 100;

		private _arrayWithAllItems=[];
		{
			for "_i" from 1 to _x#1 do
			{
				_arrayWithAllItems pushBack _x#0;
			};
		}forEach _required;

		private _numberRemoveItems = (count _arrayWithAllItems)*(1-(_giveBackAmmount/100));
		for "_i" from 1 to _numberRemoveItems do
		{
			private _index = floor(random(count _arrayWithAllItems));
			private _randomItem = _arrayWithAllItems#_index;

			_items = [_items, _randomItem, -1, true] call BIS_fnc_addToPairs;

			_arrayWithAllItems deleteAt _index;
		};
	}else{
		{
			_items = [_items, _x#0, -(_x#1), true] call BIS_fnc_addToPairs;
		} foreach _required;
	};

	{
		if (_x#1 < 1) then {
			_items deleteAt _forEachIndex;
		};
	} forEach _items;

	{
		if (_x#0 == _type) exitwith {_i = _forEachIndex};
	} foreach _storage;
	if (isNil "_i") exitwith {};

	private _newArr = _storage#_i;
	_newArr set [1,_items];

	if (count _items isEqualTo 0) then {
		_storage deleteAt _i;
	} else {
		_storage set [_i,_newArr];
	};
	_player setvariable ["player_fStorage",_storage,true];

	if (_hasFail) exitWith {};

	if (([_id,_type,"type"] call A3PL_Config_GetFactory) isEqualTo "item") then
	{
		private ["_isFactory"];
		_isFactory = if ((_id splitString "_")#0 isEqualTo "f") then {true;} else {false;};
		if (_isFactory) then {_id = [_id,_type,"class"] call A3PL_Config_GetFactory;};
	};
	[_player,_type,[_id,_amount],false] call Server_Factory_Add;
}] call compile_Server;

["Server_Factory_Add", {
	private ["_i"];
	params[
		["_player",objNull,[objNull]],
		["_type","",[""]],
		["_item",["",1],[[]]],
		["_move",true,[true]],
		["_obj",nil,[objNull]]
	];
	private _fail = false;
	if (_move) then {
		if (!isNil "_obj") then {
			if (isNull _obj) exitwith {_fail = true;};
			deleteVehicle _obj;
		} else {
			private _has = [(_item#0),(_item#1),_player] call Server_Inventory_Has;
			if (!_has) exitwith {_fail = true;};
			private _inventory = _player getVariable ["player_inventory",[]];
			private _class = _item#0;
			private _amount = _item#1;
			if (_class isEqualTo "cash") exitwith {
				_player setvariable ["player_cash",((_player getVariable ["player_cash",0]) - _amount),true];
			};
			_inventory = [_inventory, _class, -(_amount), true] call BIS_fnc_addToPairs;
			_player setvariable ["player_inventory",_inventory,true];
			[_player] call Server_Inventory_Verify;
		};
	};
	if (_fail) exitwith {};

	_storage = _player getvariable ["player_fStorage",[]];
	_newArr = [_type,"items",_player] call A3PL_Config_GetPlayerFStorage;
	{
		if (_x#0 == _type) exitwith {_i = _forEachIndex;};
	} foreach _storage;

	if (!(_newArr isEqualType true)) then {
		_newArr = [_newArr, _item#0, _item#1, true] call BIS_fnc_addToPairs;
		if (isNil "_i") exitwith {};
		(_storage#_i) set [1,_newArr];
	} else {
		_storage pushBack [_type,[[_item#0,_item#1]]];
	};

	_player setvariable ["player_fstorage",_storage,true];
	_query = format ["UPDATE players SET f_storage='%1' WHERE charid='%2'", ([_storage] call Server_Database_Array), (_player getVariable ["character_id",""])];
	[_query,1] spawn Server_Database_Async;
	
	if (_newArr isEqualType []) then {
		_newTotal = 0;
		{
			if(_x#0 isEqualTo (_item#0)) exitWith {_newTotal = _x#1;}
		} forEach _newArr;
		[getPlayerUID _player, (_player getVariable ["character_id",""]), "Factory_Add",[format ["Factory: %1 | Item: %2 | Amount: %3 | NewTotal: %4",_type,_item#0,_item#1,_newTotal]]] call Server_Log_New;
	};
}] call compile_Server;

["Server_Factory_Collect", {
	private ["_i","_query","_storage","_items","_id","_amount"];
	params[
		["_player",objNull,[objNull]],
		["_type","",[""]],
		["_item",[],[[]]]
	];

	_id = _item#0;
	_amount = _item#1;
	_storage = _player getVariable ["player_fstorage",[]];
	_items = [_type,"items",_player] call A3PL_Config_GetPlayerFStorage;
	if (_storage isEqualType true) then {_storage = []};

	if (!([_id,_amount,_type,_player] call A3PL_Factory_Has)) exitwith {};
	_items = [_items, _id, -(_amount), true] call BIS_fnc_addToPairs;
	{
		if ((_x#1) < 1) then {
			_items deleteAt _forEachIndex
		};
	} forEach _items;

	{
		if (_x#0 == _type) exitwith {_i = _forEachIndex};
	} foreach _storage;
	if (isNil "_i") exitwith {};

	_newArr = _storage select _i;
	_newArr set [1,_items];

	if (count _items isEqualTo 0) then {
		_storage deleteAt _i;
	} else {
		_storage set [_i,_newArr];
	};
	_player setvariable ["player_fstorage",_storage,true];
	_query = format ["UPDATE players SET f_storage='%1' WHERE charid='%2'", ([_storage] call Server_Database_Array), (_player getVariable ["character_id",""])];
	[_query,1] spawn Server_Database_Async;

	[_player,_item,_type] call Server_Factory_Create;
}] call compile_Server;

["Server_Factory_Create", {
	params[
		["_player",objNull,[]],
		["_item",[],[[]]],
		["_type","",[""]],
		["_classType","item",[""]],
		["_forcePos",locationNull,[]]
	];
	private _id = _item#0;
	private _amount = _item#1;
	private _isFactory = if ((_id splitString "_")#0 isEqualTo "f") then {true;} else {false;};

	if (_isFactory) then {
		_classType = [_id,_type,"type"] call A3PL_Config_GetFactory;
		_id = [_id,_type,"class"] call A3PL_Config_GetFactory;
	};
	switch (true) do
	{
		case (_classType isEqualTo "car"):
		{
			private _pos = locationNull;
			if ((_forcePos isEqualTo locationNull) || _forcePos isEqualTo []) then {_pos = (getPos _player) findEmptyPosition [3,65,_id];} else {_pos = _forcePos};
			private _lp = [_player,_id,"vehicle",true] call Server_Vehicle_Buy;
			if (_id IN ["A3FL_LCM","A3PL_RHIB","A3PL_Motorboat","A3PL_Yacht","C_Scooter_Transport_01_F","A3PL_RBM"]) exitWith {};
			_pos = [_pos#0,_pos#1,(_pos#2) + 0.5];
			_veh = [_id,_pos,_lp,_player] call Server_Vehicle_Spawn;
			_veh setDir 90;
			[_veh,_player] remoteExec ["A3PL_Lib_ChangeLocality", 2];
		};
		case (_classType isEqualTo "plane"): {
			[_player,_id,"plane",true] call Server_Vehicle_Buy;
		};
		case (_classType isEqualTo "item"):
		{
			private _canPickup = [_id,"canPickup"] call A3PL_Config_GetItem;
			private _simulation = [_id,"simulation"] call A3PL_Config_GetItem;
			private _cid = [(_player getVariable ["character_id",""])] call A3PL_Config_GetCompanyID;
			if (_canPickup) then {
				[_player,_id,_amount,false] call Server_Inventory_Add;
			} else {
				if(_amount > 1) exitWith {[("STR_Server_Factory_OnlyOneItem" call A3PL_Localize),Color_red] call A3PL_Notification; [_player,_type,[_id,_amount],false] call Server_Factory_Add;};
				private _objClass = [_id,"class"] call A3PL_Config_GetItem;
				private _obj = createVehicle [_objClass, (getpos _player), [], 0, "CAN_COLLIDE"];
				_obj setVariable ["owner",(_player getVariable ["character_id",""]),true];
				_obj setVariable ["class",_id,true];
				[_obj,_player] remoteExec ["A3PL_Lib_ChangeLocality",2];
				if (_cid isNotEqualTo 0) then {_obj setVariable["cid",_cid,true];};
			};
		};
		case (_classType IN ["vest","uniform","goggles","headgear","backpack","weapon","magazine","aitem","weaponitem","secweaponitem"]):
		{
			private ["_obj"];
			private _cid = [(_player getVariable ["character_id",""])] call A3PL_Config_GetCompanyID;
			if (_classType isEqualTo "uniform") then {
				_obj = createVehicle ["A3PL_Clothing", (getPosATL _player), [], 0, "CAN_COLLIDE"];
			} else {
				_obj = createVehicle ["A3PL_Crate", (getPosATL _player), [], 0, "CAN_COLLIDE"];
			};
			_obj setVariable ["owner",(_player getVariable ["character_id",""]),true];
			_obj setVariable ["class","ainv",true];
			_obj setVariable ["ainv",[_classtype,_id,_amount],true];
			if (_cid isNotEqualTo 0) then {_obj setVariable["cid",_cid,true];};		
		};
	};
	[getPlayerUID _player,(_player getVariable ["character_id",""]),"Factory_Collect",[format ["Factory: %1 | Item: %2 | Amount: %3",_type,_item,_amount]]] call Server_Log_New;
}] call compile_Server;
