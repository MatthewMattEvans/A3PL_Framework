/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/

["Server_Camera_setCameraVar", {
	params [
		["_atm",objNull,[objNull]],
		["_time","",[""]],
		["_nearPlayersFace",[],[[]]]
	];
	
	if (isNull _atm || {_time isEqualTo ""} || {_nearPlayersFace isEqualTo []}) exitWith {};
	
	private _stock = _atm getVariable ["camera",[]];
	if(count _stock > 0) then {
		_stock pushBack [_time,[_nearPlayersFace]];
		_atm setVariable ["camera",_stock];
	} else {
		_atm setVariable ["camera",[[_time,[_nearPlayersFace]]]];
	};
}] call compile_Server;

["Server_Camera_getCameraVar", {
	params [
		["_obj",objNull,[objNull]]
	];
	
	if (isNull _obj) exitWith {};
	
	missionNamespace setVariable ["A3PL_retrieveArrayCamera",(_obj getVariable["camera",[]]),remoteExecutedOwner];
}] call compile_Server;