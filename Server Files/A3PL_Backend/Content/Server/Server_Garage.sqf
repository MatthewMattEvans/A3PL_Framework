/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["Server_Garage_UpdateAddons", {
	params [
		["_veh",objNull,[objNull]],
		["_addons",[],[[]]]
	];

	private _var = _veh getVariable ["owner",[]];
	if((count _var) isEqualTo 0) exitWith {};
	private _id = _var select 1;
	private _addons = [_addons] call Server_Database_Array;
	private _query = format ["UPDATE players_objects SET tuning = '%2' WHERE id = '%1'",_id,_addons];
	[_query,1] spawn Server_Database_Async;
}] call compile_Server;
