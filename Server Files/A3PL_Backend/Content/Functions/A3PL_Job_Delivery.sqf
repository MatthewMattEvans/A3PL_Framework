/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Delivery_StartJob",
{
	_npc = param [0,objNull];
	if(isNull(_npc)) exitWith {};
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private _currentJob = player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
	if (_currentJob isNotEqualTo ("STR_Common_Job_Deliver" call A3PL_Localize)) exitWith {[("STR_A3PL_Job_Delivery_GoToJobCenter" call A3PL_Localize),Color_Red] call A3PL_Notification;}; 

	private _spawnPos = [];
	switch(str(_npc)) do {
		case("npc_mailman"): {_spawnPos = [6387.942,7546.177,0.001];};
		case("npc_mailman_silverton"): {_spawnPos = [2853.394,5607.033,0.1];};
		case("npc_mailman_stoney"): {_spawnPos = [3508.85,7537.62,0.1];};
		case("npc_mailman_northdale"): {_spawnPos = [10313.1,8556.05,0];};
		case("npc_mailman_beachV"): {_spawnPos = [4143.49,6317.9,0];};
	};

	private _posBlocked = (nearestObjects[_spawnPos,["Car","Ship","Air","Tank"],5]) isNotEqualTo [];
	if(_posBlocked) then {
		[("STR_A3PL_Job_Delivery_SomethingBlockSpawnPoint" call A3PL_Localize),Color_Red] call A3PL_Notification;
	} else {
		[("STR_A3PL_Job_Delivery_CheckDeliveryAddress" call A3PL_Localize),Color_Green] call A3PL_Notification;
		uiSleep (random 2 + 2);
		["A3PL_Mailtruck",_spawnPos,("STR_Common_Job_Deliver" call A3PL_Localize)] spawn A3PL_Lib_JobVehicle_Assign;
		uiSleep (random 2 + 2);
		call A3PL_Delivery_GenPackage;
	};	
}] call compile_Global;

["A3PL_Delivery_Deliver",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private ["_package","_pos","_label"];
	_package = objNull;
	{
		if ((typeOf _x) == "A3PL_DeliveryBox") exitwith {_package = _x; true;};
	} foreach ([player] call A3PL_Lib_AttachedAll);
	if (isNull _package) exitwith {[("STR_A3PL_Job_Delivery_NoPackcageInHands" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_label = _package getVariable ["label",[]];
	_pos = _label select 0;

	if ((player distance _pos) < 10) then
	{
		deleteVehicle _package;

		// Check if player has the employee trait
		private _traits = player getVariable ["Player_Traits", []];
		private _hasEmployeeTrait = "employee" in _traits;

		// Employee trait: 25% salary bonus
		private _reward = Job_Delivery_Reward;
		if (_hasEmployeeTrait) then {
			_reward = _reward * 1.25;
		};

		[format[("STR_A3PL_Job_Delivery_YouEarned" call A3PL_Localize),_reward],Color_Green] call A3PL_Notification;
		if(isNil "Player_Paycheck") then {Player_Paycheck = _reward;} else {Player_Paycheck = Player_Paycheck + (_reward * A3PL_Event_Paycheck);};
		[player, Player_Paycheck] remoteExec ["Server_Player_UpdatePaycheck",2];
	} else {
		[("STR_A3PL_Job_Delivery_YoureNotNearDeliveryPoint" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};
}] call compile_Global;

["A3PL_Delivery_Label",
{
	private ["_package","_address","_item","_label"];
	_package = param [0,objNull];
	_label = _package getVariable ["label",[]];
	_address = (_label select 2) call A3PL_Localize;
	_item = (_label select 1) call A3PL_Localize;
	if (count _label == 0) exitwith {["Unable to retrieve delivery label",Color_Red] call A3PL_Notification;};
	[format [("STR_A3PL_Job_Delivery_DeliverAt" call A3PL_Localize),_item,_address],Color_Green] call A3PL_Notification;
	[_label select 0] spawn A3PL_GPS_Navigate;
}] call compile_Global;

["A3PL_Delivery_Pickup",
{
	private ["_package"];
	_package = param [0,objNull];
	player playAction "Gesture_carry_box";
	call A3PL_Placeables_QuickAction;
	[_package] spawn
	{
		_package = param [0,objNull];
		if(typeOf _package == "A3FL_DrugBag") then {
			_package setDir ((getDir player) + 90);
		} else {
			_package setDir (getDir player);
		};
		while {_package IN (attachedObjects player)} do {
			uiSleep 0.5;
			if (isNull _package) exitwith {};
		};
		player playAction "gesture_stop";
	};
}] call compile_Global;

["A3PL_Delivery_GenPackage",
{
	private ["_locations","_package","_packages","_jobVeh"];

	_attachPoints = [
		[-0.7,0,-0.87],[-0.3,0,-0.87],[0.15,0,-0.87],[0.6,0,-0.87],
		[-0.7,-1.9,-0.87],[-0.3,-1.9,-0.87],[0.15,-1.9,-0.87],[0.6,-1.9,-0.87]
	];

	_attachpoints = _attachPoints call BIS_fnc_arrayShuffle;
	_locations = Job_Delivery_Locations call BIS_fnc_arrayShuffle;

	_jobVeh = player getVariable ["jobVehicle",objNull];
	if (isNull _jobVeh) exitwith {[("STR_A3PL_Job_Delivery_RetakeJob" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	for "_i" from 0 to (3 + (round (random 3))) do {
		_package = createVehicle ["A3PL_DeliveryBox", getpos player, [], 0, "CAN_COLLIDE"];
		_package attachTo [_jobVeh,(_attachPoints select _i)];
		_package setVariable ["class","mail",true];
		_package setVariable ["owner",(player getVariable ["character_id",""]),true];
		_package setVariable ["label",(_locations select (random ((count _locations) - 1)))];
	};
	[("STR_A3PL_Job_Delivery_CheckTrunk" call A3PL_Localize),Color_Green] call A3PL_Notification;
	// GPS to first delivery location
	private _firstDest = _locations select 0;
	if (!isNil "_firstDest") then { [_firstDest select 0] spawn A3PL_GPS_Navigate; };
}] call compile_Global;
