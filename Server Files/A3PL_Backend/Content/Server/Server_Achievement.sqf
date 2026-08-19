/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/

["Server_Achievement_Update", {
	params["_player","_achievement"];
	_achievement = [_achievement] call Server_Database_mresArray;
	private _charID = _player getVariable["character_id",""];
	private _query = format["UPDATE players SET achievement='%1' WHERE charid='%2'", _achievement, _charID];
	private _result = [_query,2] call Server_Database_Async;
}] call compile_Server;

["Server_Achievement_Get", {
	private _owner = [_this,0,ObjNull,[ObjNull]] call BIS_fnc_param;
	private _charID = _owner getVariable["character_id",""];

	if(isNull _owner) exitWith {};

	_owner = owner _owner;

	private _query = format ["SELECT achievement FROM players WHERE charID='%1'",_charID];
	private _queryResult = [_query,2] call Server_Database_Async;
	
	if (_queryResult isEqualType [] && {count _queryResult > 0}) then {
		_queryResult = _queryResult#0;
		_queryResult = [(_queryResult)] call Server_Database_ToArray;
	} else {
		_queryResult = [];
	};

	_queryResult remoteExec ["PO_Achievement_Get", _owner];
}] call compile_Server;