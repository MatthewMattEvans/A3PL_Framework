/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["Server_Fuel_Save", {
	{
		private _query = format ["UPDATE fuelstations SET fuel = '%1', bCash = '%3', gallonprice = '%4' WHERE id = '%2'",(_x getVariable ["petrol",0]),_forEachIndex,(_x getVariable ["bCash",0]),(_x getVariable ["gallonprice",6])];
		[_query,1] spawn Server_Database_Async;
		sleep 2;
	} foreach FuelStations;
}] call compile_Server;

["Server_Fuel_Load", {
	private _query = ["SELECT id,fuel,bCash,gallonprice FROM fuelstations", 2, true] call Server_Database_Async;
	
	{
		private _stationData = _query select _forEachIndex;
		if (!isNil "_stationData") then {
			_x setVariable ["petrol",(_stationData#1),true];
			_x setVariable ["bCash",(_stationData#2),true];
			_x setVariable ["gallonprice",(_stationData#3),true];

			private _gallonPrice = str (_stationData#3);
			if ((_stationData#3 >= 1) && (_stationData#3 < 10)) then {
				_x setObjectTextureGlobal [50,format ["\A3PL_Cars\Common\Number_Plates\%1.paa",0]];
				_x setObjectTextureGlobal [52,format ["\A3PL_Cars\Common\Number_Plates\%1.paa",0]];
				_x setObjectTextureGlobal [51,format ["\A3PL_Cars\Common\Number_Plates\%1.paa",str(_gallonPrice)]];
			};
			if ((_stationData#3 >= 10) && (_stationData#3 < 100)) then {
				_x setObjectTextureGlobal [50,format ["\A3PL_Cars\Common\Number_Plates\%1.paa",0]];
				_x setObjectTextureGlobal [52,format ["\A3PL_Cars\Common\Number_Plates\%1.paa",(str(_gallonPrice) splitString "") select 1]];
				_x setObjectTextureGlobal [51,format ["\A3PL_Cars\Common\Number_Plates\%1.paa",(str(_gallonPrice) splitString "") select 2]];
			};
			if (_stationData#3 >= 100) then {
				_x setObjectTextureGlobal [50,format ["\A3PL_Cars\Common\Number_Plates\%1.paa",(str(_gallonPrice) splitString "") select 1]];
				_x setObjectTextureGlobal [52,format ["\A3PL_Cars\Common\Number_Plates\%1.paa",(str(_gallonPrice) splitString "") select 2]];
				_x setObjectTextureGlobal [51,format ["\A3PL_Cars\Common\Number_Plates\%1.paa",(str(_gallonPrice) splitString "") select 3]];
			};
		};
	} forEach FuelStations;
}] call compile_Server;

["Server_Fuel_Credit", {
	params [
		["_price",0,[0]],
		["_station",objNull,[objNull]]
	];

	private _scash = _station getVariable ["bCash",0];
	[_station,"bCash",(_scash + _price)] call Server_Core_ChangeVar;
}] call compile_Server;

["Server_Fuel_Refund", {
	params [
		["_player",objNull,[objNull]],
		["_refund",0,[0]]
	];

	private _pcash = _player getVariable ["Player_Cash",0];
	[_player,"Player_Cash",(_pcash + _refund)] call Server_Core_ChangeVar;
	[format [("STR_Server_Fuel_Refund" call A3PL_Localize),_refund], Color_Green] remoteExec ["A3PL_Notification",_player];
}] call compile_Server;

["Server_Fuel_TakeCash", {
	params 
	[
		["_player",objNull,[objNull]],
		["_station",objNull,[objNull]]
	];

	private _pcash = _player getVariable ["player_cash",0];
	private _scash = _station getVariable ["bCash",0];
	[_player,"Player_Cash",(_pcash + _scash)] call Server_Core_ChangeVar;
	[_station,"bCash",0] call Server_Core_ChangeVar;
	[format[("STR_Server_Fuel_YouTakeCash" call A3PL_Localize),_scash], Color_Green] remoteExec ["A3PL_Notification",_player];
}] call compile_Server;
