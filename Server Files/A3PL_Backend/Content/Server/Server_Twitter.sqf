/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["Server_Twitter_HandleMsg", {
	params [
		["_playerid","",[""]],
		["_msg","",[""]],
		["_msgcolor","",[""]],
		["_namepicture","",[""]],
		["_name","",[""]],
		["_namecolor","",[""]],
		["_table","logs_twitter",[""]]
	];
	private _query = format["INSERT INTO %1 (name, charid, chatmessage, messageinfo) VALUES('%2','%3','%4','%5')",_table,_name,_playerid,([_msg] call Server_Twitter_StripQuotes),([[_namepicture,_namecolor,_msgcolor]] call Server_Database_Array)];
	[_query,1] call Server_Database_Async;
	if (_table isNotEqualTo "") exitWith {};
	if !(isDedicated) exitWith {[_msg,_msgcolor,_namepicture,_name,_namecolor,""] remoteExec ["A3PL_Twitter_NewMsg",2];};
	[_msg,_msgcolor,_namepicture,_name,_namecolor,""] remoteExec ["A3PL_Twitter_NewMsg",-2];
}] call compile_Server;

["Server_Twitter_StripQuotes", {
	private _msg = toArray (param [0,""]);
	private _del = [];
	{
		if (_x isEqualTo 39) then {_del pushback _forEachIndex};
	} foreach _msg;
	{
		_msg deleteAt (_x - _forEachIndex);
	} foreach _del;
	toString _msg;
}] call compile_Server;
