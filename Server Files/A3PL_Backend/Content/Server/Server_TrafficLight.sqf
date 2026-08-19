/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["Server_TrafficLight_LightA", {
	params [
		["_trafficlight",objNull,[objNull]]
	];

	private _displayName = getText (configFile >> "CfgVehicles" >> typeOf _trafficlight >> "displayName");
	private _lightP = "\A3PL_Common\TrafficLights\trafficlight.paa";
	if ((_displayName find "Alternate") > -1 || {isNull _trafficlight}) exitwith {};

	uiSleep 3;
	private _loopCount = 0;

	for "_i" from 0 to 1 step 0 do {
		_loopCount = _loopCount + 1;
		
			_trafficlight setObjectTextureGlobal[1,""];
			_trafficlight setObjectTextureGlobal[2,""];
			_trafficlight setObjectTextureGlobal[3,_lightP];
			uiSleep 15;
			_trafficlight setObjectTextureGlobal[1,""];
			_trafficlight setObjectTextureGlobal[2,_lightP];
			_trafficlight setObjectTextureGlobal[3,""];
			uiSleep 4;
			_trafficlight setObjectTextureGlobal[1,_lightP];
			_trafficlight setObjectTextureGlobal[2,""];
			_trafficlight setObjectTextureGlobal[3,""];
			uiSleep 20;
	};
}] call compile_Server;

["Server_TrafficLight_LightB", {
	params [
		["_trafficlight",objNull,[objNull]]
	];

	private _displayName = getText (configFile >> "CfgVehicles" >> typeOf _trafficlight >> "displayName");
	private _lightP = "\A3PL_Common\TrafficLights\trafficlight.paa";
	if ((_displayName find "Alternate") == -1 || {isNull _trafficlight}) exitwith {};

	uiSleep 3;
	private _loopCount = 0;

	for "_i" from 0 to 1 step 0 do {
		_loopCount = _loopCount + 1;

			_trafficlight setObjectTextureGlobal[1,_lightP];
			_trafficlight setObjectTextureGlobal[2,""];
			_trafficlight setObjectTextureGlobal[3,""];
			uiSleep 20;
			_trafficlight setObjectTextureGlobal[1,""];
			_trafficlight setObjectTextureGlobal[2,""];
			_trafficlight setObjectTextureGlobal[3,_lightP];
			uiSleep 15;
			_trafficlight setObjectTextureGlobal[1,""];
			_trafficlight setObjectTextureGlobal[2,_lightP];
			_trafficlight setObjectTextureGlobal[3,""];
			uiSleep 4;
	};
}] call compile_Server;

["Server_TrafficLight_OrangeRed", {
	params [
		["_trafficlight",objNull,[objNull]]
	];

	uiSleep 3;

	private _lightP = "\A3PL_Common\TrafficLights\trafficlight.paa";
	private _loopCount = 0;
	for "_i" from 0 to 1 step 0 do {
		_loopCount = _loopCount + 1;
		if (_trafficlight getVariable ["A3PL_LightOff",true]) then {
			_trafficlight setObjectTextureGlobal[1,""];
			_trafficlight setObjectTextureGlobal[2,_lightP];
			_trafficlight setObjectTextureGlobal[3,""];
			uiSleep 1;
			_trafficlight setObjectTextureGlobal[1,""];
			_trafficlight setObjectTextureGlobal[2,""];
			_trafficlight setObjectTextureGlobal[3,""];
			uiSleep 1;
		} else {
			if ((_trafficlight getVariable ["A3PL_LightOff",true]) isEqualTo false) then {
				_trafficlight setObjectTextureGlobal[1,""];
				_trafficlight setObjectTextureGlobal[2,_lightP];
				_trafficlight setObjectTextureGlobal[3,""];
				uiSleep 2;
				_trafficlight setObjectTextureGlobal[1,_lightP];
				_trafficlight setObjectTextureGlobal[2,""];
				_trafficlight setObjectTextureGlobal[3,""];
				uiSleep 25;
				_trafficlight setVariable ["A3PL_LightOff",true];
			};
		};
	};
}] call compile_Server;

["Server_TrafficLight_FD", {
	params [
		["_position",[]]
	];

	
	private _job = _player getVariable ["job","STR_Common_Job_Unemployed" call A3PL_Localize];
	if (_job != ("STR_Common_FIFR" call A3PL_Localize)) exitWith {};
	if (_position isEqualTo []) exitWith {};
	private _nearestlights = (nearestObjects [_position, [], 100, false]) select {typeOf _x isEqualTo "fyd_fdtrafficlight"};

	{
		_x setVariable ["A3PL_LightOff",false];
	} forEach _nearestlights;
	
}] call compile_Server;

["Server_TrafficLight_Init",{
	private _startTime = time;
	private _terrainobj = nearestObjects [[4407.328,5727.98,0], [], 10000, false];
	private _objectsA = _terrainobj select {typeOf _x in ["fyd_trafficlight_v1_0","fyd_trafficlight_v1_1","fyd_trafficlight_v1_2","fyd_trafficlight_v1_3","fyd_trafficlight_v1_4","fyd_trafficlight_v2_0","fyd_trafficlight_v2_1","fyd_trafficlight_v2_2","fyd_trafficlight_v2_3","fyd_trafficlight_v2_4","fyd_trafficlight_v2_5","fyd_trafficlight_v2_6"]};
	private _objectsB = _terrainobj select {typeOf _x in ["fyd_trafficlight_v1_0a","fyd_trafficlight_v1_1a","fyd_trafficlight_v1_2a","fyd_trafficlight_v1_3a","fyd_trafficlight_v1_4a","fyd_trafficlight_v2_0a","fyd_trafficlight_v2_1a","fyd_trafficlight_v2_2a","fyd_trafficlight_v2_3a","fyd_trafficlight_v2_4a","fyd_trafficlight_v2_5a","fyd_trafficlight_v2_6a"]};
	private _firedepartmentlights = _terrainobj select {typeOf _x isEqualTo "fyd_fdtrafficlight"};
	
	{
		[_x] spawn Server_TrafficLight_LightA;
	} forEach _objectsA;

	{
		[_x] spawn Server_TrafficLight_LightB;
	} forEach _objectsB;

	{
		[_x] spawn Server_TrafficLight_OrangeRed;
	} forEach _firedepartmentlights;
	
}] call compile_Server;