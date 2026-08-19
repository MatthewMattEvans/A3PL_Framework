/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
['Server_Locker_Load', {
	private _lockers = ["SELECT locker, owner, items, objects, vstorage FROM players_lockers", 2, true] call Server_Database_Async;
	{
		private _locker = call compile (_x#0);
		_locker setVariable ["owner",_x#1,true];
		private _itemsRaw = _x#2;
		private _items = [];
		if(_itemsRaw != "" && !isNil {_itemsRaw}) then {
			_items = call compile _itemsRaw;
			if(!(_items isEqualType [])) then {_items = [];};
		};
		private _vStorage = [_x#4] call Server_Database_ToArray;
		_locker setVariable["storage",_vStorage,true];
		
		private _weapons = [];
		private _magazines = [];
		private _itemsList = [];
		private _backpacks = [];
		
		if(count _items > 0) then {
			private _item0 = _items select 0;
			if(_item0 isEqualType []) then {_weapons = _item0;};
		};
		if(count _items > 1) then {
			private _item1 = _items select 1;
			if(_item1 isEqualType []) then {_magazines = _item1;};
		};
		if(count _items > 2) then {
			private _item2 = _items select 2;
			if(_item2 isEqualType []) then {_itemsList = _item2;};
		};
		if(count _items > 3) then {
			private _item3 = _items select 3;
			if(_item3 isEqualType []) then {_backpacks = _item3;};
		};
		
		{_locker addWeaponCargoGlobal [_x,1]} foreach _weapons;
		{_locker addMagazineCargoGlobal [_x,1]} foreach _magazines;
		{_locker addItemCargoGlobal [_x,1]} foreach _itemsList;
		{_locker addBackpackCargoGlobal [_x,1]} foreach _backpacks;
	} foreach _lockers;
}] call compile_Server;

['Server_Locker_Insert', {
	params[
		["_locker", objNull, [objNull]],
		["_player", objNull, [objNull]]
	];

	private _lockerPrice = 5000;
	private _playerCash = _player getVariable ["Player_Cash", 0];

	if(_playerCash < _lockerPrice) exitWith {
		[format[("STR_Server_Locker_Insert_NotEnoughMoney" call A3PL_Localize),(_lockerPrice-_playerCash)], Color_Red] remoteExec ["A3PL_Notification", (owner _player)];
	};

	_player setVariable ["Player_Cash", (_playerCash - _lockerPrice), true];
	_locker setVariable ["owner", (_player getVariable ["character_id",""]), true];
	[("STR_Common_FederalReserve" call A3PL_Localize),_lockerPrice] remoteExec ["Server_Government_AddBalance",2];

	[format[("STR_Server_Locker_Insert_YouBoughtLockerFor" call A3PL_Localize),_lockerPrice], Color_Green] remoteExec ["A3PL_Notification", (owner _player)];
	[getPlayerUID _player,(_player getVariable ["character_id",""]),"Locker_Buy",[format ["Locker: %1",_locker]]] call Server_Log_New;

	private _query = format ["INSERT INTO players_lockers(locker, owner) VALUES ('%1','%2')",_locker, (_player getVariable ["character_id",""])];
	[_query, 1] call Server_Database_Async;
}] call compile_Server;

['Server_Locker_Sell', {
	params[
		["_locker", objNull, [objNull]],
		["_player", objNull, [objNull]]
	];

	if (!((_locker getVariable ["owner", ""]) isEqualTo (_player getVariable ["character_id",""]))) exitWith {
		[("STR_Server_Locker_Sell_NotYourLocker" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", (owner _player)];
	};

	_hasBankAccount = (_player getVariable ["Player_BankActive",0]) isnotEqualTo 0;
	if (!hasBankAccount) exitWith {[("STR_Server_Locker_Sell_NoBankAccount" call A3PL_Localize),Color_Green] remoteExec ["A3PL_Notification", (owner _player)];};

	private _salePrice = 5000;
	private _playerBank = _player getVariable ["Player_Bank",0];
	_player setVariable ["Player_Bank", (_playerBank + _salePrice), true];
	_locker setVariable ["owner", "", true];

	[format[("STR_Server_Locker_Sell_Success" call A3PL_Localize), _salePrice], Color_Green] remoteExec ["A3PL_Notification", (owner _player)];
	[getPlayerUID _player,(_player getVariable ["character_id",""]),"Locker_Sell",[format ["Locker: %1",_locker]]] call Server_Log_New;
	[("STR_Common_FederalReserve" call A3PL_Localize),-_salePrice] remoteExec ["Server_Government_AddBalance",2];

	private _query = format ["DELETE FROM players_lockers WHERE locker = '%1' AND owner = '%2'", _locker, (_player getVariable ["character_id",""])];
	[_query, 1] call Server_Database_Async;
}] call compile_Server;

['Server_Locker_Save', {
	private _lockers = ["SELECT locker, owner, items, objects FROM players_lockers", 2, true] call Server_Database_Async;
	diag_log format["[DEBUG] Server_Locker_Save found %1 lockers to save", count _lockers];
	{
		diag_log format["[DEBUG] Server_Locker_Save saving locker %1", _x select 0];
		private _locker = call compile (_x select 0);
		private _objects = [];
		private _items = [weaponCargo _locker, magazineCargo _locker, itemCargo _locker, backpackCargo _locker];
		private _storage = [_locker getVariable["storage",[]]] call Server_Database_Array;;
		diag_log format["[DEBUG] Server_Locker_Save locker %1 has %2 items | storage: %3", _x select 0, _items, _storage];
		private _query = format["UPDATE players_lockers SET items='%1',objects='%2',vstorage='%3' WHERE locker ='%4'",_items,_objects,_storage,_locker];
		[_query,1] spawn Server_Database_Async;
		diag_log format["[DEBUG] Server_Locker_Save saved locker %1", _x select 0];
	} foreach _lockers;
}] call compile_Server;
