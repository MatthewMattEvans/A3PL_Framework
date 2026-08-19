/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["Server_Player_UpdatePaycheck",{
	private _player = param [0,objNull];
	private _paycheck = param [1,0];
	private _query = format ["UPDATE players SET paycheck='%1' WHERE charid='%2'",_paycheck, (_player getVariable ["character_id",""])];
	[_query,1] spawn Server_Database_Async;
}] call compile_Server;

["Server_Player_Whitelist",{
	private _charID = param [0,""];
	private _faction = param [1,""];
	[format ["UPDATE players SET faction='%1' WHERE charid='%2'",_faction,_charID],1] spawn Server_Database_Async;
}] call compile_Server;

["Server_Player_Lastseen",{
	private _charID = param [0,""];
	[format ["UPDATE players SET lastseen=CURRENT_TIMESTAMP() WHERE charid='%1'",_charID],1] spawn Server_Database_Async;
}] call compile_Server;

["Server_Player_LoadPlayTime",{
	params [["_unit",objNull,[objNull]]];
	private _charID = (_unit getVariable ["character_id",""]);
	private _query = format ["SELECT playtime FROM players WHERE charid='%1'",_charID];
	private _result = [_query,2] call Server_Database_Async;
	if (!isNil "_result" && (_result#0 > 0)) then {
		_result = _result#0;
	} else {
		_result = 0;
	};
	[_result] remoteExec ["A3PL_Player_receivePlayTime",_unit]; 
}] call compile_Server;

["Server_Player_LoadTotalPlayTime",{
	params [["_unit",objNull,[objNull]]];
	private _uid = getPlayerUID _unit;
	private _query = [format["SELECT charid FROM players WHERE uid='%1'", _uid], 2, true] call Server_Database_Async;
	private _totalPlaytime = 0;
	{
		private _playtime = [format ["SELECT playtime FROM players WHERE charid='%1'",_x#0], 2] call Server_Database_Async;
		if (!isNil "_playtime" && {_playtime isEqualType []} && {count _playtime > 0}) then {
			_totalPlaytime = _totalPlaytime + (_playtime#0);
		};
	} forEach _query;
	
	if (!isNil "_totalPlaytime" && {_totalPlaytime > 0}) then {
		_result = _totalPlaytime;
	} else {
		_result = 0;
	};
	[_result] remoteExec ["A3PL_Player_receivePlayTime",_unit];
}] call compile_Server;

["Server_Player_SavePlayTime",{
	private _player = param [0,objNull];
	private _playtime = param [1,0];
	private _charID = (_player getVariable ["character_id",""]);
	private _query = format ["UPDATE `players` SET `playtime` = '%2' WHERE `charid` = '%1'",_charID,_playtime];
	private _result = [_query,2] call Server_Database_Async;
}] call compile_Server;

["Server_Player_SyncStats",{
	params [
		["_player", objNull, [objNull]],
		["_hunger", 100, [0]],
		["_thirst", 100, [0]],
		["_alcohol", 0, [0]],
		["_drugs", [0,0,0], [[]]],
		["_pee", 100, [0]],
		["_sleep", 100, [0]],
		["_sportLevel", 0, [0]],
		["_sportSpeed", 1, [0]],
		["_scopeStability", 1, [0]],
		["_maxTimeTired", 30, [0]]
	];
	
	if (isNull _player) exitWith {};
	
	// Update server-side variables with client values
	_player setVariable ["player_hunger", _hunger, false];
	_player setVariable ["player_thirst", _thirst, false];
	_player setVariable ["player_alcohol", _alcohol, false];
	_player setVariable ["player_drugs", _drugs, false];
	_player setVariable ["player_pee", _pee, false];
	_player setVariable ["player_sleep", _sleep, false];
	_player setVariable ["Player_SportLevel", _sportLevel, false];
	_player setVariable ["Player_SportSpeed", _sportSpeed, false];
	_player setVariable ["Player_ScopeStability", _scopeStability, false];
	_player setVariable ["Player_maxTimeTired", _maxTimeTired, false];
}] call compile_Server;