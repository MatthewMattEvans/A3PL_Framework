/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["Server_Admin_WasFedFIFR", {
	params["_player"];
	private _charID = _player getVariable["character_id",""];
	private _query = format ["SELECT faction FROM players WHERE charid = '%1'",_charID];
	private _playerData = [_query, 2] call Server_Database_Async;
	_player setVariable["faction",_playerData#0,true];
	_player setVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize),true];
}] call compile_Server;

["Server_Admin_ToggleEvent", {
	params["_eventVar","_getEventData"];
	
	call compile format ['%1 = %2;',_eventVar,_getEventData#1];
	publicVariable _eventVar;

	[_getEventData#0, Color_Pink] remoteExec ["A3PL_Notification",-2];
}] call compile_Server;
