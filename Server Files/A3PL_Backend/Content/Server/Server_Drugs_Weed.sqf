/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["Server_Weed_DryLoop", {
	params [["_plant",objNull,[objNull]], ["_playerUID","",[""]],  ["_charID","",[""]],  ["_playerObj",objNull,[objNull]]];

	if (isNull _plant) exitWith {};

	private _nearFan = count(nearestObjects[_plant, ["A3PL_Fan"], 5]) > 0;
	private _timer = if(_nearFan) then {Weed_Time_To_Dry_With_Fan} else {Weed_Time_To_Dry_Without_Fan};
	private _curTime = 0;
	private _error = false;
	private _currentState = _plant getVariable ["class",nil];
	if(isNil "_currentState") exitWith {};
	private _states = ["cannabis_plant_stage1","cannabis_plant_stage2","cannabis_plant_stage3","cannabis_plant_stage4"];
	private _stateIndex = _states find _currentState;
	if(_stateIndex isEqualTo -1) exitWith {};
	private _drying = _plant getVariable["isDrying",nil];
	if (!isNil "_drying") exitWith {};
	_plant setVariable["isDrying",true,true];

	for "_i" from _stateIndex to count(_states)-1 do {
		while{_curTime < _timer} do {
			if(isNull _plant) exitWith {
				_error = true;
				[_playerUID,_charID,"Weed_DryLoop",["Drying cancelled (plant removed)"]] call Server_Log_New;
			};
			_curTime = _curTime + 1;
			sleep 1;
		};
		if(_error) exitWith {};
		_plant setObjectTextureGlobal [0, format["A3FL_Drugs\Weed\Plant\data\plant_%1_co.paa",_i+1]];
		_plant setVariable["class",_states#_i,true];
		_curTime = 0;
	};
	if(_error) exitWith {};
	[("STR_A3PL_Weed_Drying_Completed" call A3PL_Localize),Color_Green] remoteExec ["A3PL_Notification",_playerObj];
	[_playerUID,_charID,"Weed_DryLoop",["Weed dried"]] call Server_Log_New;
	_plant setVariable["isDrying",nil,true];
}] call compile_Server;
