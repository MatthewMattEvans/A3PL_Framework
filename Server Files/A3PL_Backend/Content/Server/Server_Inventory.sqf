/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["Server_Inventory_Verify", {
	private _player = param [0,objNull];
	private _change = false;
	{
		if ((_x select 1) < 1) then {
			_index = _forEachIndex;
			(_player getVariable "Player_Inventory") set [_index, "REMOVE"];
			_change = true;
		};
	} forEach (_player getVariable "Player_Inventory");
	if (_change) then {
		_player setVariable ["Player_Inventory", ((_player getVariable "Player_Inventory") - ["REMOVE"]), true];
	};
	[] remoteExec ["A3PL_Inventory_SetCurrent",_player];
}] call compile_Server;

["Server_Inventory_Add", {
	params [
		["_player", objNull, [objNull]],
		["_class", "", [""]],
		["_amount", 0, [0]],
		["_log", true, [true]]
	];

	if (_class isEqualTo "cash") exitwith {
		private _playerMoney = _player getVariable ["Player_Cash",0];
		if (isNil "_playerMoney") exitwith {};
		[_player,"Player_Cash",(_playerMoney + _amount)] call Server_Core_ChangeVar;
	};
	if (isNull _player) exitWith {};
	private _newArray = [(_player getVariable 'Player_Inventory'), _class, _amount] call BIS_fnc_addToPairs;
	_player setVariable ['Player_Inventory', _newArray, true];
	[_player] call Server_Inventory_Verify;
	[] remoteExec ["A3PL_Inventory_SetCurrent",_player];

	if(_log) then {[getPlayerUID _player,(_player getVariable ["character_id",""]),"Inv_Server_Add",[format ["Item: %1 | Amount: %2",_class,_amount]]] call Server_Log_New;};
}] call compile_Server;

["Server_Inventory_Pickup", {
	params [
		["_player",objNull,[objNull]],
		["_obj",objNull,[objNull]],
		["_amount",0,[0]]
	];
	private _prevTotal = 0;
	private _newTotal = 0;
	if (isNull _player) exitWith {diag_log "ERROR: _player null in Server_Inventory_Pickup";};
	if (isNull _obj) exitwith {diag_log format ["ERROR: _obj null in Server_Inventory_Pickup - Player: %1",name _player];};

	private _class = _obj getVariable ["class",nil];
	if (isNil "_class") exitwith {diag_log format ["ERROR: _class nil in Server_Inventory_Pickup - Player: %1",name _player];};

	if (_obj getVariable ["used",false]) exitwith {};
	_obj setVariable ["used",true,false];

	if (_class isEqualTo "cash") then {
		_amount = _obj getVariable "cash";
		_prevTotal = _player getVariable ["player_cash",0];
	} else {
		_prevTotal = [_class,_player] call A3PL_Inventory_Return;
	};

	deleteVehicle _obj;
	[_player,_class,_amount,false] call Server_Inventory_Add;

	if (_class isEqualTo "cash") then {
		_newTotal = _player getVariable ["player_cash",0];
	} else {
		_newTotal = [_class,_player] call A3PL_Inventory_Return;
	};
	[getPlayerUID _player,(_player getVariable ["character_id",""]),"Inv_Virtual_Pickup",[format ["Item: %1 | Amount: %2 | PrevTotal: %3 | NewTotal: %4",_class,_amount,_prevTotal,_newTotal]]] call Server_Log_New;
}] call compile_Server;

["Server_Inventory_Drop", {
	params [
		["_player",objNull,[objNull]],
		["_obj",objNull,[objNull]],
		["_class",""],
		["_amount",1]
	];
	private _newTotal = 0;
	private _prevTotal = 0;
	if (isNull(_player)) exitWith {diag_log "ERROR: _player in Server_Inventory_Drop is null"};
	if(!isNull _obj) then {
		if (_class isEqualTo "cash") then {
			_prevTotal = _player getVariable ["player_cash",0];
			} else {
			_prevTotal = [_class,_player] call A3PL_Inventory_Return;
		};
		[_obj,"class",_class] call Server_Core_ChangeVar;
		if (_amount != 1) then {[_obj,"amount",_amount] call Server_Core_ChangeVar;};
		[_obj,"owner",(_player getVariable ["character_id",""])] call Server_Core_ChangeVar;
		if(_class IN ["doorkey","housekey"]) exitwith {};
		if(_class isEqualTo "cash") then {[_obj,"cash",_amount] call Server_Core_ChangeVar;};
	};
	[_player, _class, -(_amount)] call Server_Inventory_Add;
	
	if (_class isEqualTo "cash") then {
		_newTotal = _player getVariable ["player_cash",0];
	} else {
		_newTotal = [_class,_player] call A3PL_Inventory_Return;
	};
	[getPlayerUID _player,(_player getVariable ["character_id",""]),"Inv_Virtual_Drop",[format ["Item: %1 | Amount: %2 | PrevTotal: %3 | NewTotal: %4",_class,_amount,_prevTotal,_newTotal]]] call Server_Log_New;
}] call compile_Server;

["Server_Inventory_Return", {
	params [
		["_class","",[""]],
		["_player",objNull,[objNull]]
	];
	private _amount = [(_player getVariable 'Player_Inventory'), _class, 0] call BIS_fnc_getFromPairs;
	_amount;
}] call compile_Server;

["Server_Inventory_Has", {
	params [
    ["_class","",[""]],
    ["_amount",1,[1]],
    ["_player",objNull,[objNull]]
  ];

	if (_class isEqualTo "cash") exitwith {if (_player getVariable ["player_cash",0] >= _amount) then {true;} else {false;};};
	private _inventoryAmount = [_class,_player] call Server_Inventory_Return;
	if (_inventoryAmount < _amount) exitWith {false};
	true
}] call compile_Server;

["Server_Inventory_RemoveAll",
{
	private _player = param [0,objNull];
	_player setVariable ["player_inventory",[],true];
	_player setVariable ["player_cash",0,true];
	[_player,false] call Server_Gear_Save;
}] call compile_Server;

["Server_Inventory_TotalWeight",
{
	private _return = 0;
	private _itemToAdd = param [0,[]];
	private _player = param [1,objNull];
	private _inventory = _player getVariable ["player_inventory",[]];
	if (count _itemToAdd > 0) then {
		{
			_inventory = [_inventory, (_x select 0), (_x select 1), true] call BIS_fnc_addToPairs;
		} foreach _itemToAdd;
	};
	{
		private _amount = _x select 1;
		private _itemWeight = ([_x select 0, 'weight'] call A3PL_Config_GetItem) * _amount;
		_return = _return + _itemWeight;
	} forEach _inventory;
	_return;
}] call compile_Server;

["Server_Inventory_PickupCheck", {
	params [
		["_player", objNull, [objNull]],
		["_className", "", [""]],
		["_location", [0,0,0], [[]]],
		["_time", 0, [0]]
	];
	if (isNil "A3FL_InventoryPickupQueue") then {
		A3FL_InventoryPickupQueue = [];
	};
	A3FL_InventoryPickupQueue pushBack [_player, _className, _location, _time];
	if (count A3FL_InventoryPickupQueue > 5) then {
		A3FL_InventoryPickupQueue deleteAt 0;
	};
	for "_i" from 0 to (count A3FL_InventoryPickupQueue - 1) do {
		(A3FL_InventoryPickupQueue select _i) params [
			["_player2", objNull, [objNull]],
			["_className2", "", [""]],
			["_location2", [0,0,0], [[]]],
			["_time2", 0, [0]]
		];
		if ((_player isNotEqualTo _player2) && (getNumber(configFile >> "CfgWeapons" >> _className >> "type") IN [1,2]) && (_className isEqualTo _className2) && (abs(_time - _time2) < 50) && ((_location distance _location2) < 50)) exitWith {
			[getPlayerUID _player,(_player getVariable ["character_id",""]),"PossibleDupe",[format ["%1 and %2 took the same item %3",_player getVariable["name",""],_player2 getVariable["name",""],_className]]] call Server_Log_New;
		};
	};
}] call compile_Server;
