/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Exterminator_Start",
{
	if (!(call A3PL_Player_AntiSpam)) exitWith {};
	private _currentJob = player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
	if (_curentJob isNotEqualTo ("STR_Common_Job_Exterminator" call A3PL_Localize)) exitWith {[("STR_A3PL_Job_Exterminator_GoToJobCenter" call A3PL_Localize),Color_Red] call A3PL_Notification;}; 
	if (handgunWeapon player isEqualTo "") exitwith {[("STR_A3PL_Job_Exterminator_NeedWeapon" call A3PL_Localize)] call A3PL_Notification;};
	[("STR_A3PL_Job_Exterminator_Welcome" call A3PL_Localize),Color_Green] call A3PL_Notification;
	[("STR_A3PL_Job_Exterminator_TakeTruck" call A3PL_Localize),Color_Green] call A3PL_Notification;
	["A3PL_Mailtruck",[10004.1,7937.21,0.1],("STR_Common_Job_Exterminator" call A3PL_Localize)] spawn A3PL_Lib_JobVehicle_Assign;
	call A3PL_Exterminator_PestStart;
}] call compile_Global;

["A3PL_Exterminator_PestStart",
{
	private _animals = missionNameSpace getVariable ["A3PL_Exterminator_PestAnimals",[]];
	if ((count _animals) >= 4) exitwith {[] spawn A3PL_Exterminator_Loop;};
	call A3PL_Exterminator_SpawnPest;
	[] spawn A3PL_Exterminator_Loop;
}] call compile_Global;
 
["A3PL_Exterminator_SpawnPest",
{
	private _animals = missionNameSpace getVariable ["A3PL_Exterminator_PestAnimals",[]];
	{deleteVehicle _x} foreach _animals;
	private _houses = nearestObjects [[7661.16,6609.34,0],Buildings_Trailer,6000];
	private _pos = getPosATL (_houses select (floor(random ((count _houses)-1))));
	if (isNil "_pos") exitwith {call A3PL_Exterminator_SpawnPest;};
	A3PL_Exterminator_PestAnimals = [];
	for "_i" from 0 to (8 + (round (random 2))) do {
		_animal = createAgent ["Rabbit_F", _pos, [], 25, "NONE"];
		A3PL_Exterminator_PestAnimals pushback _animal;
	};
	publicVariable "A3PL_Exterminator_PestAnimals";
	[_pos] spawn A3PL_GPS_Navigate;
}] call compile_Global;

["A3PL_Exterminator_Loop",
{
	private _animals = missionNameSpace getVariable ["A3PL_Exterminator_PestAnimals",[]];
	[_animals] call A3PL_Exterminator_KillEH;
	waitUntil {(player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) isEqualTo ("STR_Common_Job_Exterminator" call A3PL_Localize)};
	while {(player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) isEqualTo ("STR_Common_Job_Exterminator" call A3PL_Localize)} do {
		private ["_markers","_marker"];
		_animals = missionNameSpace getVariable ["A3PL_Exterminator_PestAnimals",[]];
		_markers = [];
		{
			_marker = createMarkerLocal [format["%1_marker",floor (random 5000)],getpos _x];
			_marker setMarkerShapeLocal "ICON";
			_marker setMarkerColorLocal "ColorRed";
			_marker setMarkerTypeLocal "Mil_dot";
			_marker setMarkerTextLocal format[("STR_A3PL_Job_Exterminator_PestAnimals" call A3PL_Localize)];
			_markers pushback _marker;
		} foreach _animals;
		{ deleteMarkerLocal _x; } foreach (missionNameSpace getVariable ["A3PL_Exterminator_Markers",[]]);
		A3PL_Exterminator_Markers = _markers;
		uiSleep 2;
	};
	{ deleteMarkerLocal _x; } foreach A3PL_Exterminator_Markers;
}] call compile_Global;

["A3PL_Exterminator_KillEH",
{
	private _animals = param [0,[]];
	{
		_x removeAllEventHandlers "killed";
		_x addEventHandler ["killed",
		{
			if ((param [2,objNull]) isEqualTo player) then
			{
				private _animal = param [0,objNull];

				// Check if player has the employee trait
				private _traits = player getVariable ["Player_Traits", []];
				private _hasEmployeeTrait = "employee" in _traits;

				// Employee trait: 25% salary bonus
				private _reward = Job_Exterminator_Reward;
				if (_hasEmployeeTrait) then {
					_reward = _reward * 1.25;
				};

				[format[("STR_A3PL_Job_Exterminator_YouKilledPest" call A3PL_Localize),_reward],Color_Green] call A3PL_Notification;
				player setVariable ["player_cash",(player getVariable ["player_cash",0]) + _reward,true];
				A3PL_Exterminator_PestAnimals = A3PL_Exterminator_PestAnimals - [_animal];
				publicVariable "A3PL_Exterminator_PestAnimals";
				deleteVehicle _animal;
				if (count A3PL_Exterminator_PestAnimals <= 4) then
				{
					call A3PL_Exterminator_PestStart;
					[("STR_A3PL_Job_Exterminator_AreaClean" call A3PL_Localize),Color_Green] call A3PL_Notification;
				};
			};
		}];
	} foreach _animals;
}] call compile_Global;
