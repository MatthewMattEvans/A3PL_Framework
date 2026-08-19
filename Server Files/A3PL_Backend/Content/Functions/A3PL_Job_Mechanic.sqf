/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_JobMechanic_UseLift",
{
	params [["_obj",objNull,[objNull]]];
	private _vehicles = nearestObjects [(_obj modelToWorld [-4,-1,-2]),["Car"],4];
	if ((typeOf _obj) IN ["A3PL_Garage_CarLift","A3PL_Garage_TruckLift"]) then {
		_vehicles = nearestObjects [(_obj modelToWorld [0,1,0]),["Car"],4];
	};
	private _veh = if(count _vehicles > 0) then {_vehicles#0} else {nil};
	private _pos = if(!isNil "_veh") then {getPosATL _veh} else {nil};
	private _posZ = if(!isNil "_veh") then {_pos#2} else {nil};
	private _heightOffset = switch (typeOf _obj) do {
		case "Land_A3PL_Garage": {0.0};
		case "A3PL_Garage_CarLift": {0.0};
		case "A3PL_Garage_TruckLift": {0.6};
		default {0.0};
	};
	if (!isNil "_veh") then {_veh setposATL [_pos#0,_pos#1,_posZ+0.1];};
	if (_obj animationSourcePhase "car_lift" < 0.75) then {
		_obj animateSource ["car_lift",(1.5 - _heightOffset)];
		if (!isNil "_posZ") then {
			uisleep 1.5;
			if ((getPosATL _veh)#2 <= (_posZ + 0.1)) then
			{
				_obj animateSource ["car_lift",0];
			};
		};
	} else {
		_obj animateSource ["car_lift",0];
		if (!isNil "_posZ") then {
			uisleep 1.5;
			if ((getPosATL _veh)#2 >= (_posZ - 0.1)) then {
				_obj animateSource ["car_lift",(1.5 - _heightOffset)];
			};
		};
	};
}] call compile_Global;
