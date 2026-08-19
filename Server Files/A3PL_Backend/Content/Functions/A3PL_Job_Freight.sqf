/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Freight_Start",
{
	private _currentJob = player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
	if (_currentJob isNotEqualTo ("STR_Common_Job_Freight" call A3PL_Localize)) exitWith {[("STR_A3PL_Job_Freight_GoToJobCenter" call A3PL_Localize),Color_Red] call A3PL_Notification;}; 

	private _startPoint = param [0,objNull];
	if (!isNil {player getVariable "deliveryPlane"}) exitwith {[("STR_A3PL_Job_Freight_AlreadyInMission" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _planes = nearestObjects [player, ["A3PL_Cessna172", "A3PL_Goose_Base"], 30];
	if(count (_planes) isEqualTo 0) exitWith {[("STR_A3PL_Job_Freight_NoAirplaneNear" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _plane = _planes#0;
	if (((_plane getVariable["owner",""])#0) isNotEqualTo (player getVariable ["character_id",""])) exitWith {[("STR_A3PL_Job_Freight_ThisIsNotYourAircraft" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_plane getVariable["onDelivery",false]) exitWith {[("STR_A3PL_Job_Freight_AircraftAlreadyUsedForDelivery" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _destinations = [
		[npc_freight_svt,("STR_A3PL_Job_Freight_SilvertonAirport" call A3PL_Localize),"marker_job_airfreight"],
		[npc_freight_nd,("STR_A3PL_Job_Freight_NorthdaleAirport" call A3PL_Localize),"marker_job_airfreight2"]
	];
	switch(_startPoint) do {
		case npc_freight_svt: {_destinations deleteAt 0;};
		case npc_freight_nd: {_destinations deleteAt 1;};
	};
	private _destination = selectRandom _destinations;
	[_startPoint,_plane] spawn A3PL_Freight_SpawnCargo;
	player setVariable["deliveryPlane",_plane];
	_plane setVariable["onDelivery",true,true];
	_plane setVariable["onDeliveryDest",_destination#0,true];
	_plane addEventHandler ["Killed",{call A3PL_Freight_DestroyFees;}];

	_destination#2 setMarkerTextLocal ("STR_A3PL_Job_Freight_DeliveryPoint" call A3PL_Localize);
	[format[("STR_A3PL_Job_Freight_DeliverAt" call A3PL_Localize),_destination#1],Color_Green] call A3PL_Notification;
	[getPos(_destination#0)] spawn A3PL_GPS_Navigate;
}] call compile_Global;

["A3PL_Freight_SpawnCargo",
{
	private _startPoint = param [0,objNull];
	private _plane = param [1,objNull];
	private _boxesLocation = switch(_startPoint) do {
		case npc_freight_svt: {[("STR_A3PL_Job_Freight_SilvertonAirport" call A3PL_Localize),[2525.39,5285.13,0.105808]]};
		case npc_freight_nd: {[("STR_A3PL_Job_Freight_NorthdaleAirport" call A3PL_Localize),[10814.2,8817.2,0.105806]]};
	};
	private _amount = 8 + round(random 7);
	for "_i" from 0 to (_amount-1) do {
		private ["_pos","_b"];
		_pos = [(_boxesLocation#1), 15] call CBA_fnc_randPos;
		_b = createVehicle["A3PL_Crate",_pos, [], 0, "CAN_COLLIDE"];
		_b setVariable["JobCargo",true,true];
		_b setVariable["FreightCargo",true,true];
		_b setVariable["JobVehicle",_plane,true];
		_b setVariable["class","jobcargo",true];
		_b setVariable ["owner",(player getVariable ["character_id",""]),true];
	};
	[format[("STR_A3PL_Job_Freight_BoxWaitingYou" call A3PL_Localize),_boxesLocation#0],Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Freight_Load",
{
	private _crate = param [0,objNull];
	private _aircraft = _crate getVariable["JobVehicle",objNull];
	if (isNull _aircraft) exitwith {[("STR_A3PL_Job_Freight_CantLocateAircraft" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((_crate distance _aircraft) > 10) exitwith {[("STR_A3PL_Job_Freight_MoveBox" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _curValue = _aircraft getVariable["JobValue",0];
	deleteVehicle _crate;
	_aircraft setVariable["JobValue",(_curValue+Job_Freight_Value),true];
	[("STR_A3PL_Job_Freight_BoxesLoaded" call A3PL_Localize),Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Freight_Unload",
{
	private _unloadPoint = param[0,objNull];
	private _plane = player getVariable["deliveryPlane",objNull];
	if (Player_ActionDoing) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if(isNull _plane) exitWith {[("STR_A3PL_Job_Freight_CantLocateAircraft" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if((player distance _plane) > 25) exitWith {[("STR_A3PL_Job_Freight_AircraftNeedToBeMoreNearest" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _destination = _plane getVariable["onDeliveryDest",objNull];
	if(_unloadPoint isNotEqualTo _destination) exitWith {[("STR_A3PL_Job_Freight_WrongDestination" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _cargoValue = _plane getVariable["JobValue",0];
	private _boxesAmount = _cargoValue/Job_Freight_Value;
	private _building = nearestObjects[_unloadPoint, ["Land_A3FL_Airport_Hangar"], 20];
	for "_i" from 0 to (_boxesAmount-1) do {
		private ["_pos","_b"];
		_pos = [getPosATL (_building#0), 18] call CBA_fnc_randPos;
		_b = createVehicle["A3PL_Crate",_pos, [], 0, "CAN_COLLIDE"];
		_b setVariable["JobCargo",true,true];
		_b setVariable["JobDestination",_destination,true];
		_b setVariable["class","jobcargo",true];
		_b setVariable ["owner",(player getVariable ["character_id",""]),true];
	};
	_plane setVariable["JobValue",nil,true];
	_plane removeEventHandler ["Killed", 0];
	_plane setVariable["onDelivery",false,true];
	player setVariable["deliveryPlane",nil];
	[("STR_Common_Job_Unemployed" call A3PL_Localize)] call A3PL_NPC_TakeJob;
	[("STR_A3PL_Job_Freight_BoxesUnloaded" call A3PL_Localize),Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Freight_DestroyFees",
{
	private _fees = Job_Freight_Detroy_Fees + round(random Job_Freight_Detroy_Fees_Random);
	_hasBankAccount = [player,1] call A3PL_Bank_HasAccount;
	if (!_hasBankAccount) exitwith {
		[("STR_A3PL_Job_Freight_Destroyed1" call A3PL_Localize),Color_Red] call A3PL_Notification;
		private _debts = player getVariable["Player_Debt",0];
		player setVariable["Player_Debt",_debts-_fees];
		player setVariable["deliveryPlane",nil];
		[("STR_Common_Job_Unemployed" call A3PL_Localize)] call A3PL_NPC_TakeJob;
	};
	private _currentBank = player getVariable["Player_Bank",0];
	if(_fees > _currentBank) then {
		private _cantpay = _fees - _currentBank;
		player setVariable["Player_Bank",0,true];
		private _debts = player getVariable["Player_Debt",0];
		player setVariable["Player_Debt",_debts-_cantpay];
		[format[("STR_A3PL_Job_Freight_Destroyed2" call A3PL_Localize),_currentBank,_cantpay],Color_Red] call A3PL_Notification;
	} else {
		player setVariable["Player_Bank",_currentBank-_fees,true];
		[format[("STR_A3PL_Job_Freight_Destroyed3" call A3PL_Localize),_fees],Color_Red] call A3PL_Notification;
	};
	player setVariable["deliveryPlane",nil];
	[("STR_Common_Job_Unemployed" call A3PL_Localize)] call A3PL_NPC_TakeJob;
}] call compile_Global;

["A3PL_Freight_End",
{
	private _npc = param[0,objNull];
	if (isNull _npc) exitWith {};
	private _nearCrates = nearestObjects[player, ["A3PL_Crate"],10];
	private _pay = 0;
	private _marker = [getPos _npc] call A3PL_Lib_NearestMarker;
	_marker setMarkerTextLocal ("STR_A3PL_Job_Freight_MapMarker" call A3PL_Localize);
	{
		if(_x getVariable["JobDestination",objNull] isEqualTo _npc && {_x getVariable["owner",""] isEqualTo (player getVariable ["character_id",""])}) then {_pay = _pay + (Job_Freight_Reward + round(random Job_Freight_Reward_Random));deleteVehicle _x;};
	} forEach _nearCrates;
	if(_pay isEqualTo 0) exitWith {};

	// Check if player has the employee trait
	private _traits = player getVariable ["Player_Traits", []];
	private _hasEmployeeTrait = "employee" in _traits;

	// Employee trait: 25% salary bonus
	if (_hasEmployeeTrait) then {
		_pay = _pay * 1.25;
	};

	[format[("STR_A3PL_Job_Freight_DeliveryFinished" call A3PL_Localize),_pay],Color_Green] call A3PL_Notification;
	if(isNil "Player_Paycheck") then {Player_Paycheck = _pay;} else {Player_Paycheck = Player_Paycheck + _pay;};
	[player, Player_Paycheck] remoteExec ["Server_Player_UpdatePaycheck",2];
}] call compile_Global;
