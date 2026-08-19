/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["Server_Log_New",
{

	params["_uid","_charID","_action",["_data",[]]];
	private _dataString = "";
	if (_data isEqualType []) then {
		{
			if(_dataString isEqualTo "") then {
				_dataString = _x;
			} else {
				_dataString = format["%1:%2 ",_dataString,_x];
			};
		} forEach _data;
	} else {
		_dataString = _data;
	};

	private _strArray = _dataString splitString "";
	_dataString = "";
	{if(!(_x IN ["'"])) then {_dataString = _dataString + _x;};} forEach _strArray;

	[format ["INSERT INTO logs (uid, charid, type, data) VALUES ('%1','%2','%3','%4')",_uid,_charID,_action,_dataString],1] spawn Server_Database_Async;
}] call compile_Server;

["Server_AdminLoginsert",
{
	params["_admin","_type","_data"];
	private _adminname = format ["%1 (%2)",_admin getvariable ["name","Undefined"],name _admin];
	private _adminuid = getPlayerUID _admin;
	private _dataString = "";
	if (_data isEqualType []) then {
		{
			if(_dataString isEqualTo "") then {
				_dataString = _x;
			} else {
				_dataString = format["%1:%2 ",_dataString,_x];
			};
		} forEach _data;
	} else {
		_dataString = _data;
	};

	private _strArray = _dataString splitString "";
	_dataString = "";
	{if(!(_x IN ["'"])) then {_dataString = _dataString + _x;};} forEach _strArray;


	private _insert = format ["INSERT INTO logs_admin (adminname, uid, type, data) VALUES ('%1','%2','%3','%4')",_adminname,_adminuid,_type,_dataString];
	[_insert,1] spawn Server_Database_Async;
}] call compile_Server;

["Server_Log_ExecCall",
{
	params["_execName","_target","_details"];
	private _insert = format ["INSERT INTO wl_activity (exec_name, type, target, details, date) VALUES ('%1','In-Game Activity','%2','%3',NOW())",_execName,_target,_details];
	[_insert,1] spawn Server_Database_Async;
}] call compile_Server;

["Server_Log_ClockIn",
{
	params["_admin"];
	private _uid = getPlayerUID _admin;
	private _query = format ["SELECT clock_id FROM wl_clock WHERE `admin_id` = '%1' AND `stop_time` IS NULL",_uid];
	private _return = [_query, 2] call Server_Database_Async;
	if(count(_return) > 0) exitWith {};
	[format["INSERT INTO `wl_clock`(admin_id, start_time) VALUES('%1',NOW())",_uid],1] spawn Server_Database_Async;
	[_admin,"AdminLoggedIn"] call Server_AdminLoginsert;
}] call compile_Server;

["Server_Log_ClockOut",
{
	params["_uid"];
	private _query = format ["SELECT clock_id FROM wl_clock WHERE `admin_id` = '%1' AND `stop_time` IS NULL",_uid];
	private _return = [_query, 2] call Server_Database_Async;
	if(count(_return) isEqualTo 0) exitWith {};	
	[format["UPDATE wl_clock SET stop_time = NOW() WHERE clock_id = %1",_return#0],1] spawn Server_Database_Async;
}] call compile_Server;

["Server_Log_FactionExpense",
{
	params[
		["_player",objNull,[objNull]],
		["_shop","",[""]],
		["_item","",[""]],
		["_amount",0,[0]],
		["_price",0,[0]]
	];
	private _faction = _player getVariable ["faction","citizen"];
	private _charID = (_player getVariable ["character_id",""]);
	private _insert = format ["INSERT INTO faction_expenses (charid, shop, faction, item, amount, price) VALUES ('%1','%2','%3','%4','%5','%6')",_charID,_shop,_faction,_item,_amount,_price];
	[_insert,1] spawn Server_Database_Async;
}] call compile_Server;


["Server_Log_Faction_ClockIn",
{
	params["_charID","_faction"];
	private _query = format ["SELECT clock_id FROM wl_faction_clock WHERE `charid` = '%1' AND `stop_time` IS NULL",_charID];
	private _return = [_query, 2] call Server_Database_Async;
	if(count(_return) > 0) exitWith {};
	[format["INSERT INTO `wl_faction_clock`(charid, faction, start_time) VALUES('%1','%2',NOW())",_charID,_faction],1] spawn Server_Database_Async;
}] call compile_Server;

["Server_Log_Faction_ClockOut",
{
	params["_charID"];
	private _query = format ["SELECT clock_id FROM wl_faction_clock WHERE `charid` = '%1' AND `stop_time` IS NULL",_charID];
	private _return = [_query, 2] call Server_Database_Async;
	if(count(_return) isEqualTo 0) exitWith {};	
	[format["UPDATE wl_faction_clock SET stop_time = NOW() WHERE clock_id = %1",_return#0],1] spawn Server_Database_Async;
}] call compile_Server;