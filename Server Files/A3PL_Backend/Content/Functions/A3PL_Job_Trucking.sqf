/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3FL_Trucking_Start", {
	private _currentJob = player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
	if (_curentJob isNotEqualTo ("STR_Common_Job_Trucking" call A3PL_Localize)) exitWith {[("STR_A3PL_Job_Trucking_TakeTheJobAtJobCenter" call A3PL_Localize),Color_Red] call A3PL_Notification;}; 

	private _startPoint = param [0,objNull];
	private _vehicles = nearestObjects [player, Job_Trucking_Whitelisted_Cars, 15];
	if(count (_vehicles) isEqualTo 0) exitWith {[("STR_A3PL_Job_Trucking_NoAppropriateVehicleAround" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _vehicle = _vehicles#0;
	if(((_vehicle getVariable["owner",""])#0) isNotEqualTo (player getVariable ["character_id",""])) exitWith {[("STR_A3PL_Job_Trucking_ThisIsNotYourCar" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if(_vehicle getVariable["onDelivery",false]) exitWith {[("STR_A3PL_Job_Trucking_VehicleAlreadyUsedForDelivery" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _destination = selectRandom Job_Trucking_Destinations;
	private _destString = [_destination] call A3FL_Trucking_DestString;
	[format[("STR_A3PL_Job_Trucking_NeedToBeDeliveredAt" call A3PL_Localize),_destString],Color_Green] call A3PL_Notification;
	private _marker = createMarkerLocal ["trucking_delivery", getPos(_destination)];
	_marker setMarkerShapeLocal "ICON";
	_marker setMarkerSizeLocal [0.6,0.6];
	_marker setMarkerTypeLocal "A3FL_Markers_TruckingJob";
	_marker setMarkerTextLocal ("STR_A3PL_Job_Trucking_Deliver" call A3PL_Localize);
	[getPos(_destination)] spawn A3PL_GPS_Navigate;

	player setVariable["deliveryVehicle",_vehicle,false];
	_vehicle setVariable["onDelivery",true,true];
	_vehicle setVariable["onDeliveryDest",_destination,true];
	_vehicle addEventHandler ["Killed",{call A3FL_Trucking_DestroyFees;}];
	[_startPoint,_vehicle] spawn A3FL_Trucking_SpawnCargo;
}] call compile_Global;

["A3FL_Trucking_SpawnCargo", {
	params [
		["_startPoint",objNull,[objNull]],
		["_vehicle",objNull,[objNull]]
	];

	private _boxesLocation = switch(_startPoint) do {
		case npc_trucking_st: {[[[3048.12,5322.52,0.00105524],[3048.11,5323.3,3.71933e-005],[3048.11,5324.09,1.90735e-005],[3048.14,5324.9,-0.00122833]],88.8892]};
		case npc_trucking_bw: {[[[7235.51,6274.66,0],[7235.49,6275.65,0.00143862],[7235.48,6276.65,-0.00380278],[7235.52,6277.64,-1.90735e-006]],269.5]};
	};
	private _amount = [_vehicle] call A3FL_Trucking_GetVehiclePay;
	private _val = 0;
	private _y = 0;
	for "_i" from 0 to (_amount-1) do {
		private ["_pos","_b"];
		if(_i isEqualTo 17) then {_y = 1;_val=0;};
		if(_i isEqualTo 34) then {_y = 2;_val=0;};
		if(_i isEqualTo 51) then {_y = 3;_val=0;};
		_pos = ((_boxesLocation#0)#_y);
		_b = createVehicle["A3PL_Crate",[(_pos#0) + (sin (_boxesLocation#1) * _val),(_pos#1) + (cos (_boxesLocation#1) * _val),_pos#2], [], 0, "CAN_COLLIDE"];
		_b setVariable["JobCargo",true,true];
		_b setVariable["class","jobcargo",true];
		_b setVariable ["owner",(player getVariable ["character_id",""]),true];
		_b setVariable["JobDestination",(_vehicle getVariable["onDeliveryDest",objNull]),true];
		_val = _val + 0.7;
	};
	[("STR_A3PL_Job_Trucking_CrateWaitingOnYou" call A3PL_Localize),Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3FL_Trucking_CheckCargo", {
	params [
		["_crate",objNull,[objNull]]
	];

	if (isNull _crate) exitWith {};
	private _destination = _crate getVariable ["jobdestination",objNull];
	private _destString = [_destination] call A3FL_Trucking_DestString;
	[format[("STR_A3PL_Job_Trucking_NeedToBeDeliveredAt" call A3PL_Localize),_destString],Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3FL_Trucking_GetVehiclePay", {
	private _veh = param [0,objNull];
	if(isNull _veh) exitWith {};
	private _pay = switch(typeOf _veh) do {
		case "A3PL_F150": {Job_Trucking_Pay_F150};
		case "A3PL_F150_Marker": {Job_Trucking_Pay_F150};
		case "A3FL_F150": {Job_Trucking_Pay_F150};
		case "A3FL_F150_ML": {Job_Trucking_Pay_F150};
		case "A3FL_F450": {Job_Trucking_Pay_F450};
		case "A3PL_Ram": {Job_Trucking_Pay_Ram};
		case "A3PL_Ram_ML": {Job_Trucking_Pay_Ram};
		case "EC_DodgeRam": {Job_Trucking_Pay_Ram};
		case "A3PL_Silverado": {Job_Trucking_Pay_Silverado};
		case "A3PL_Silverado_ML": {Job_Trucking_Pay_Silverado};
		case "A3PL_MailTruck": {Job_Trucking_Pay_Mailtruck};
		case "A3FL_T370": {Job_Trucking_Pay_T370};
		case "A3FL_T440": {Job_Trucking_Pay_T440};
		case "A3PL_Box_Trailer": {Job_Trucking_Pay_BoxTrailer};
		case "A3PL_Car_Trailer": {Job_Trucking_Pay_CarTrailer};
		case "A3PL_Lowloader": {Job_Trucking_Pay_LowLoader};
		default {0};
	};
	_pay;
}] call compile_Global;

["A3FL_Trucking_Unload", {
	private _unloadPoint = param[0,objNull];
	private _vehicle = player getVariable["deliveryVehicle",objNull];
	if(isNull _vehicle) exitWith {[("STR_A3PL_Job_Trucking_CantFindTheCar" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if((player distance _vehicle) > 20) exitWith {[("STR_A3PL_Job_Trucking_CarNotNear" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _destination = _vehicle getVariable["onDeliveryDest",objNull];
	if(_unloadPoint isNotEqualTo _destination) exitWith {[("STR_A3PL_Job_Trucking_WrongDestination" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _nearCrates = nearestObjects[_unloadPoint, ["A3PL_Crate"],20];
	private _expectedCrates = [_vehicle] call A3FL_Trucking_GetVehiclePay;
	private _deliveredCrates = [];
	{
		if(_x getVariable["JobDestination",objNull] isEqualTo _unloadPoint && {(isNull attachedTo _x)}) then {
			_deliveredCrates pushback _x;
		};
	} forEach _nearCrates;
	if(count(_deliveredCrates) isNotEqualTo _expectedCrates) exitwith {[format[("STR_A3PL_Job_Trucking_CrateWaitedForThisDelivery" call A3PL_Localize),_expectedCrates],Color_Red] call A3PL_Notification;};
	[((count _deliveredCrates)*Job_Trucking_Reward)] call A3FL_Trucking_End;
	{deleteVehicle _x;} foreach _deliveredCrates;

	_vehicle setVariable["onDeliveryCargo",nil,true];
	_vehicle removeEventHandler ["Killed", 0];
}] call compile_Global;

["A3FL_Trucking_End", {
	private _pay = param[0,0];
	if(_pay > 0) then {
		// Check if player has the employee trait
		private _traits = player getVariable ["Player_Traits", []];
		private _hasEmployeeTrait = "employee" in _traits;

		// Employee trait: 25% salary bonus
		if (_hasEmployeeTrait) then {
			_pay = _pay * 1.25;
		};

		[format[("STR_A3PL_Job_Trucking_DeliveryFinished" call A3PL_Localize),_pay],Color_Green] call A3PL_Notification;
		if(isNil "Player_Paycheck") then {Player_Paycheck = _pay;} else {Player_Paycheck = Player_Paycheck + _pay;};
		[player, Player_Paycheck] remoteExec ["Server_Player_UpdatePaycheck",2];
	};
	private _vehicle = player getVariable["deliveryVehicle",objNull];
	_vehicle setVariable["onDelivery",nil,true];
	player setVariable["deliveryVehicle",nil];
	[("STR_Common_Job_Unemployed" call A3PL_Localize)] call A3PL_NPC_TakeJob;
}] call compile_Global;

["A3FL_Trucking_DestString", {
	private _delPoint = param [0,objNull];
	private _return = switch(_delPoint) do {
		case npc_import: {("STR_A3PL_Job_Trucking_Destination1" call A3PL_Localize)};
		case npc_furniture_6: {("STR_A3PL_Job_Trucking_Destination2" call A3PL_Localize)};
		case npc_perkfurniture_1: {("STR_A3PL_Job_Trucking_Destination3" call A3PL_Localize)};
		case npc_mailman_silverton: {("STR_A3PL_Job_Trucking_Destination4" call A3PL_Localize)};
		case npc_mailman_beachV: {("STR_A3PL_Job_Trucking_Destination5" call A3PL_Localize)};
		case npc_hardware_1: {("STR_A3PL_Job_Trucking_Destination6" call A3PL_Localize)};
		case npc_mailman_stoney: {("STR_A3PL_Job_Trucking_Destination7" call A3PL_Localize)};
		case npc_perkfurniture_6: {("STR_A3PL_Job_Trucking_Destination8" call A3PL_Localize)};
		case npc_goodsfactory: {("STR_A3PL_Job_Trucking_Destination9" call A3PL_Localize)};
		case npc_mailman: {("STR_A3PL_Job_Trucking_Destination10" call A3PL_Localize)};
		case npc_mailman_northdale: {("STR_A3PL_Job_Trucking_Destination11" call A3PL_Localize)};
		case NPC_general_3: {("STR_A3PL_Job_Trucking_Destination12" call A3PL_Localize)};
		case npc_fonderie: {("STR_Common_FactoryName_Steel" call A3PL_Localize)};
		default {("STR_Common_UnknownLocation" call A3PL_Localize)};
	};
	_return;
}] call compile_Global;

["A3FL_Trucking_DestroyFees", {
	params ["_unit", "_killer", "_instigator", "_useEffects"];
	private _cargoValue = [_unit] call A3FL_Trucking_GetVehiclePay;
	private _fees = _cargoValue * Job_Trucking_Destroy_Fees;
	_hasBankAccount = [player,1] call A3PL_Bank_HasAccount;
	if (!_hasBankAccount) exitwith {
		[("STR_A3PL_Job_Trucking_VehicleDestroyed" call A3PL_Localize),Color_Red] call A3PL_Notification;
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
		[format[("STR_A3PL_Job_Trucking_VehicleDestroyed2" call A3PL_Localize),_currentBank,_cantpay],Color_Red] call A3PL_Notification;
	} else {
		player setVariable["Player_Bank",_currentBank-_fees,true];
		[format[("STR_A3PL_Job_Trucking_VehicleDestroyed3" call A3PL_Localize),_fees],Color_Red] call A3PL_Notification;
	};
	player setVariable["deliveryPlane",nil];
	[("STR_Common_Job_Unemployed" call A3PL_Localize)] call A3PL_NPC_TakeJob;
}] call compile_Global;
