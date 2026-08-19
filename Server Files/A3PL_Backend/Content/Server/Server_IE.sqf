/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
#define SHIPSPAWNPOS [3617.37,8460.23,5]
#define SHIPTARGETPOS [3617.37,7760.23,0]
#define SHIPTIMEINDOCK 300
#define SHIPARRIVETIMEOUT 300

["Server_IE_Init",
{
	private _Database_IE_Prices = ["SELECT * FROM import_export", 2, true] call Server_Database_Async;
	Server_IE_Prices = [];
	{
		private _ore = _x#0;
		private _importPrice = [((_x#3)*1.1), ((_x#3)*1.4)] call BIS_fnc_randomInt;
		private _exportPrice = [((_x#3)*0.5), ((_x#3)*0.9)] call BIS_fnc_randomInt;
		private _recommanded = _x#3;
		Server_IE_Prices pushBack [_ore,_importPrice,_exportPrice,_recommanded];
	} forEach _Database_IE_Prices;
	publicVariable "Server_IE_Prices";
}] call compile_Server;

//changes the prices based on the containerArray supplied by IE_ShipImport and IE_ShipExport
["Server_IE_PriceChange",
{
	private ["_cArray","_import","_itemArray","_newPrice"];
	_cArray = param [0,[]];
	_import = param [1,true]; //whether we are importing or exporting
	_itemArray = []; //the final array which we will use the calculate the new prices
	{
		_itemArray = [_itemArray, (_x select 1), (_x select 2),false] call BIS_fnc_addToPairs;
	} foreach _cArray;

	{
		private ["_item","_amount","_itemIndex","_ieArray","_currentBuyPrice","_currentSellPrice","_query"];
		_item = _x select 0;
		_amount = _x select 1;

		//get the item index
		{
			if ((_x select 0) == _item) exitwith
			{
				_ieArray = _x;
				_itemIndex = _forEachIndex;
			};
		} foreach Server_IE_Prices;
		if (isNil "_itemIndex") exitwith {};

		//change the price
		_currentBuyPrice = _ieArray select 1;
		_currentSellPrice = _ieArray select 2;

		//update local array
		Server_IE_Prices set [_itemIndex,_ieArray];

		//update database
		_query = format ["UPDATE import_export SET import='%1',export='%2',recommanded='%3' WHERE item='%4'",(_ieArray select 1),(_ieArray select 2),(_ieArray select 3),(_ieArray select 0)];
		[_query,1] spawn Server_Database_Async;
	} foreach _itemArray;
	publicVariable "Server_IE_Prices";
}] call compile_Server;

["Server_IE_ShipImport",
{
	private ["_ship","_driver","_targetPos","_timeOut","_timeOutLimit","_container","_cArray"];
	if (!isNil "Server_IE_Running") exitwith {};
	Server_IE_Running = true;
	if (isNil "IE_Ship") then {
		IE_Ship = createVehicle ["A3PL_Container_Ship",SHIPSPAWNPOS,[],100,"CAN_COLLIDE"];
		IE_Ship allowDamage false;
		_driver = (createGroup civilian) createUnit ["C_man_p_beggar_F",SHIPSPAWNPOS,[],0,""];
		_driver moveInDriver IE_Ship;
		_driver allowDamage false;
	};
	IE_Ship setPos SHIPSPAWNPOS;
	IE_Ship setFuel 1;
	_targetPos = SHIPTARGETPOS;
	IE_Ship setDir (IE_Ship getDir _targetPos);
	IE_Ship move _targetPos;
	IE_Ship setBehaviour "CARELESS";
	_container = 0;
	_cArray = [];
	{
		private ["_charID"];
		_charID = _x getVariable ["character_id",""];
		{
			if (!(_x select 2)) then
			{
				_container = _container + 1;
				if (_container > 72) exitwith {};
				_cAnim = format ["c%1",_container];
				IE_Ship animateSource [_cAnim,1];
				_cArray pushback [_charID,(_x select 0),(_x select 1)];
			};
		} foreach (_x getVariable ["player_importing",[]]);
		if (_container > 72) exitwith {};
	} foreach allPlayers;
	IE_Ship setVariable ["containerItems",_cArray,true];
	[_cArray] call Server_IE_PriceChange;

	_timeOut = 0;
	_timeOutLimit = SHIPARRIVETIMEOUT;
	Server_IE_ShipImbound = true;
	publicVariable "Server_IE_ShipImbound";
	while {(IE_Ship distance2D SHIPTARGETPOS) > 50} do {uiSleep 3; _timeOut = _timeOut + 3; if (_timeOut > _timeOutLimit) exitwith {true;}};
	if (_timeOut > _timeOutLimit) then {
		[] remoteExec ["A3PL_IE_ShipLost",-2];
		Server_IE_Running = nil;
	} else {
		IE_Ship setVelocity [0,0,0];
		IE_Ship setDir 189.077;
		IE_Ship setPosASL SHIPTARGETPOS;
		[] remoteExec ["A3PL_IE_ShipArrived",-2];
		[IE_Ship] spawn {
			private _ship = param [0,objNull];
			private _wait = 0;
			while {
				uiSleep 2;
				_wait < SHIPTIMEINDOCK
			} do {
				_wait = _wait + 2;
				if ((_ship distance2D SHIPTARGETPOS) > 5) then {
					_ship setDir 189.077; _ship setPosASL SHIPTARGETPOS
				}; _ship setVelocity [0,0,0];
			};
			[_ship] spawn Server_IE_ShipExport;
		};
	};
	Server_IE_ShipImbound = nil;
	publicVariable "Server_IE_ShipImbound";
}] call compile_Server;

["Server_IE_ShipExport",
{
	private _ship = param [0,objNull];
	_ship setDir (getDir _ship + 180);
	_ship move SHIPSPAWNPOS;
	for "_i" from 1 to 72 do {
		_cAnim = format ["c%1",_i];
		if ((_ship animationSourcePhase _cAnim) > 0.1) then {
			_ship animateSource [_cAnim,0];
		};
	};
	private _container = 0;
	private _cArray = [];
	{
		private _charID = _x getVariable ["character_id",""];
		{
			_container = _container + 1;
			if (_container > 72) exitwith {};
			_cAnim = format ["c%1",_container];
			_ship animateSource [_cAnim,1];
			_cArray pushback [_charID,(_x select 0),(_x select 1)];
		} foreach (_x getVariable ["player_exporting",[]]);
		if (_container > 72) exitwith {};
	} foreach allPlayers;
	_ship setVariable ["containerItems",_cArray];
	[_cArray,false] call Server_IE_PriceChange;

	Server_IE_ShipOutbound = true;
	publicVariable "Server_IE_ShipOutbound";

	Server_ShipLeavingTime = serverTime;
	publicVariable "Server_ShipLeavingTime";

	private _timeOut = 0;
	private _timeOutLimit = 600;
	while {(_ship distance2D SHIPSPAWNPOS) > 35} do {sleep 2; _timeOut = _timeOut + 2; if (_timeOut > _timeOutLimit) exitwith {true;}};
	[] remoteExec ["A3PL_IE_ShipLeft",-2];

	_ship deleteVehicleCrew (driver _ship);
	deleteVehicle _ship;
	IE_Ship = nil;
	Server_IE_ShipOutbound = nil;
	publicVariable "Server_IE_ShipOutbound";
	Server_IE_Running = nil;
}] call compile_Server;
