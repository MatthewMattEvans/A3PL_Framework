/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Waste_StartJob",
{
	private _location = param [0,player_objintersect];
	if (!(call A3PL_Player_AntiSpam)) exitWith {};
	private _currentJob = player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
	if (_currentJob isNotEqualTo ("STR_Common_Job_Waste" call A3PL_Localize)) exitWith {[("STR_A3PL_Job_Waste_TakeJobAtJobCenter" call A3PL_Localize),Color_Red] call A3PL_Notification;}; 

	private _spawnLoc = switch(_location) do {
		case NPC_WasteManagement: {[6196.97,7625.79,0.3]};
		default {[2119.36,5155.03,0.3]};
	};
	private _posBlocked = (nearestObjects[_spawnLoc,["Car","Ship","Air","Tank"],5]) isNotEqualTo [];
	if(_posBlocked) then {
		[("STR_A3PL_Job_Waste_SomethingBlockSpawnPoint" call A3PL_Localize),Color_Red] call A3PL_Notification;
	} else {
		[("STR_A3PL_Job_Waste_Description" call A3PL_Localize),Color_Green] call A3PL_Notification;
		["A3PL_P362_Garbage_Truck",_spawnLoc,("STR_Common_Job_Waste" call A3PL_Localize)] spawn A3PL_Lib_JobVehicle_Assign;
	};	
}] call compile_Global;

["A3PL_Waste_CheckNear",
{
	private _bin = param [0,objNull];
	private _nearTrucks = nearestObjects [_bin, ["A3PL_P362_Garbage_Truck"], 10];
	if (count _nearTrucks isEqualTo 0) exitwith {false;};
	private _truck = _nearTrucks#0;
	private _bin1pos = _truck modelToWorld [-0.731541,-4.48728,-1.12253];
	private _bin2pos = _truck modelToWorld [0.298429,-4.48728,-1.12253];
	private _bin1dist = _bin1pos distance _bin;
	private _bin2dist = _bin2pos distance _bin;
	if ((_bin1dist < 0.9) || {(_bin2dist < 0.9)}) then {true;} else	{false;};
}] call compile_Global;

["A3PL_Waste_LoadBin",
{
	private _bin = param [0,objNull];
	private _nearTrucks = nearestObjects [_bin, ["A3PL_P362_Garbage_Truck"], 10];
	if (count _nearTrucks isEqualTo 0) exitwith {[("STR_A3PL_Job_Waste_NoTruckNear" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _truck = _nearTrucks#0;

	private _bin1pos = _truck modelToWorld [-0.731541,-4.48728,-1.12253];
	private _bin2pos = _truck modelToWorld [0.298429,-4.48728,-1.12253];
	private _bin1dist = _bin1pos distance _bin;
	private _bin2dist = _bin2pos distance _bin;

	if ((_bin1dist < 0.9) || {(_bin2dist < 0.9)}) then
	{
		[_bin,true] remoteExec ['A3PL_Lib_HideObject', 2];
		if (_bin1dist < _bin2dist) then {
			_truck animateSource ["Bin1", 0.1];
			_truck setVariable ["bin1",_bin,true];
		} else {
			_truck animateSource ["Bin2", 0.1];
			_truck setVariable ["bin2",_bin,true];
		};
	};
}] call compile_Global;

["A3PL_Waste_UnloadBin",
{
	params[["_truck",objNull,[objNull]],["_name","",[""]]];
	private _bin = _truck getVariable [_name,objNull];
	switch (_name) do {
		case "bin1": {
			[_bin,false] remoteExec ['A3PL_Lib_HideObject', 2];
			_truck animateSource ["Bin1", 0];
		};
		case "bin2": {
			[_bin,false] remoteExec ['A3PL_Lib_HideObject', 2];
			_truck animateSource ["Bin2", 0];
		};
	};
	_truck setVariable [_name,nil,true];
}] call compile_Global;

["A3PL_Waste_FlipBin",
{
	params[["_truck",objNull,[objNull]],["_anim","",[""]]];
	if(isNil {_truck getVariable[_anim,nil]}) exitWith {[("STR_A3PL_Job_Waste_ChargeTrashOnTruck" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _binObj = _truck getVariable [_anim,Objnull];
	private _trashCount = _truck getVariable["trashCount",0];
	private _clearTime = _binObj getVariable ["ClearTime",serverTime-Job_Waste_Clear_Time];
	if((serverTime-_clearTime) < Job_Waste_Clear_Time) exitWith {[("STR_A3PL_Job_Waste_AlreadyCleared" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_binObj setVariable ["ClearTime",serverTime];
	_truck animateSource [_anim, 1];
	_truck setVariable["trashCount",_trashCount+1,true];

	// Check if player has the employee trait
	private _traits = player getVariable ["Player_Traits", []];
	private _hasEmployeeTrait = "employee" in _traits;

	// Employee trait: 25% salary bonus
	private _reward = Job_Waste_Reward;
	if (_hasEmployeeTrait) then {
		_reward = _reward * 1.25;
	};

	if(isNil "Player_Paycheck") then {Player_Paycheck = _reward;} else {Player_Paycheck = Player_Paycheck + _reward;};
	[player, Player_Paycheck] remoteExec ["Server_Player_UpdatePaycheck",2];
	[format[("STR_A3PL_Job_Waste_FlipReward" call A3PL_Localize),_reward],Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Waste_EmptyTruck",
{
	params[["_truck",objNull,[objNull]]];
	private _trashCount = _truck getVariable["trashCount",0];
	if(_trashCount isEqualTo 0) exitwith {["",Color_Red] call A3PL_Notification;};
	private _pay = Job_Waste_EmptyTruck_Reward * _trashCount;
	_truck setVariable["trashCount",0,true];

	// Check if player has the employee trait
	private _traits = player getVariable ["Player_Traits", []];
	private _hasEmployeeTrait = "employee" in _traits;

	// Employee trait: 25% salary bonus
	if (_hasEmployeeTrait) then {
		_pay = _pay * 1.25;
	};

	if(isNil "Player_Paycheck") then {Player_Paycheck = _pay;} else {Player_Paycheck = Player_Paycheck + _pay;};
	[player, Player_Paycheck] remoteExec ["Server_Player_UpdatePaycheck",2];
	[format[("STR_A3PL_Job_Waste_EmptyTruckReward" call A3PL_Localize),_pay],Color_Green] call A3PL_Notification;
}] call compile_Global;
