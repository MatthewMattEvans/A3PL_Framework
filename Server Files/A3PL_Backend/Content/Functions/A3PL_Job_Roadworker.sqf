/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_JobRoadworker_RepairTerrain",
{
	private ["_tObjects","_obj","_timeLeft"];

	if (!(vehicle player isEqualTo player)) exitwith {[("STR_A3PL_Job_Roadworker_CantBeInAcar" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_tObjects = nearestTerrainObjects [player, [], 5];
	if (count _tObjects < 1) exitwith {[("STR_A3PL_Job_Roadworker_NoObjectNear" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_obj = _tObjects select 0;
	if (damage _obj < 1) exitwith {[("STR_A3PL_Job_Roadworker_NotDamaged" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_obj setDamage 0;

	_timeLeft = missionNameSpace getVariable ["A3PL_JobRoadworker_Timer",(diag_ticktime-2)];
	if (_timeLeft > diag_ticktime) exitwith {[format [("STR_A3PL_Job_Roadworker_NeedToWait" call A3PL_Localize),round(_timeLeft-diag_ticktime)],Color_Red] call A3PL_Notification;};
	missionNameSpace setVariable ["A3PL_JobRoadworker_Timer",(diag_ticktime + (30 + random 3))];

	// Check if player has the employee trait
	private _traits = player getVariable ["Player_Traits", []];
	private _hasEmployeeTrait = "employee" in _traits;

	// Employee trait: 25% salary bonus
	private _reward = Job_Roadworker_RepairTerrain_Reward;
	if (_hasEmployeeTrait) then {
		_reward = _reward * 1.25;
	};

	[format[("STR_A3PL_Job_Roadworker_Repaired" call A3PL_Localize),_reward],Color_Green] call A3PL_Notification;
	[player, 'Player_Cash', ((player getVariable 'Player_Cash')  + _reward)] remoteExec ["Server_Core_ChangeVar",2];
	[getPlayerUID player,(player getVariable ["character_id",""]),"JobRoadWorker_RepairTerrain",[format ["Object: %1 | Position: %2",typeOf _obj,(getPosATL _obj)]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

["A3PL_JobRoadWorker_ToggleMark",
{
	private _veh = param [0,objNull];
	if (isNull _veh) then {
		_veh = player_objintersect;
		if (!(_veh isKindOf "LandVehicle")) then {_veh = cursorobject};
		if (isNull _veh) exitwith {[("STR_A3PL_Job_Roadworker_ErrorImpoundLook" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	};
	if (_veh getVariable ["impound",false]) then {
		[_veh] remoteExec ["Server_JobRoadWorker_UnMark", 2];
		[("STR_A3PL_Job_Roadworker_SignalRemoved" call A3PL_Localize),Color_Red] call A3PL_Notification;
	} else {
		[_veh] remoteExec ["Server_JobRoadWorker_Mark", 2];
		[("STR_A3PL_Job_Roadworker_Marked" call A3PL_Localize),Color_Green] call A3PL_Notification;
	};
}] call compile_Global;

["A3PL_JobRoadWorker_MarkResponse",
{
	private _veh = param [0,objNull];
	private _license = (_veh getvariable ["owner",["0","ERROR"]]) select 1;
	[format [("STR_A3PL_Job_Roadworker_NewCarAvailableToImpound" call A3PL_Localize),_license],Color_Green] call A3PL_Notification;
	if (!isNull _veh) then { [getPosATL _veh] spawn A3PL_GPS_Navigate; };
}] call compile_Global;

["A3PL_JobRoadWorker_MarkerLoop",
{
	private _isRoadside = (player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) isEqualTo ("STR_Common_Job_Roadworker" call A3PL_Localize);
    private _isCorporate = [(player getVariable ["character_id",""])] call A3PL_Config_InCompany;
    private _hasLicense = [player,"impound"] call A3PL_Company_HasLicense;
    private _job = (player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) isEqualTo ("STR_Common_Company" call A3PL_Localize);
	private _isAdmin = player getVariable ["pVar_RedNameOn",false];
	private _vehicles = [];

	{deleteMarkerLocal _x;} foreach A3PL_Jobroadworker_MarkerList;
	if((!_isRoadside) && (!_isCorporate || !_hasLicense || !_job)) exitWith {};

	A3PL_Jobroadworker_MarkerList = [];

	{
		if(!isNull _x) then {_vehicles pushback _x;};
	} foreach Server_JobRoadWorker_Marked;

	{
		_lp = (_x getvariable ["owner",["0","ERROR"]]) select 1;
		_marker = createMarkerLocal [format ["impound_%1",random 4000], _x];
		_marker setMarkerShapeLocal "ICON";
		_marker setMarkerTypeLocal "A3FL_Markers_VehImpound";
		_marker setMarkerTextLocal format [("STR_A3PL_Job_Roadworker_MapMarker" call A3PL_Localize),_lp];
		_marker setMarkerColorLocal "Default";
		_marker setMarkerSizeLocal [0.7, 0.7];
		A3PL_Jobroadworker_MarkerList pushback _marker;
	} foreach _vehicles;
}] call compile_Global;

["A3PL_JobRoadWorker_Impound",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};

    private _isRoadside = (player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) isEqualTo ("STR_Common_Job_Roadworker" call A3PL_Localize);
    private _isCorporate = [(player getVariable ["character_id",""])] call A3PL_Config_InCompany;
    private _hasLicense = [player,"impound"] call A3PL_Company_HasLicense;
    private _job = (player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) isEqualTo ("STR_Common_Company" call A3PL_Localize);

    if((!_isRoadside) && (!_isCorporate && !_hasLicense && !_job)) exitWith {};

	private _cars = player nearEntities [["Car","Tank"],10];
	if (count _cars == 0) exitwith {[("STR_A3PL_Job_Roadworker_NoCarMarkedForImpoundNear" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	
	private _car = _cars select 0;
	if (isNull _car) exitwith {[("STR_A3PL_Job_Roadworker_NoCarMarkedForImpoundNear" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!(_car getVariable ["impound",false])) exitwith {[("STR_A3PL_Job_Roadworker_CarNotMarked" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((_car getVariable ["Towed",false])) exitwith {[("STR_A3PL_Job_Roadworker_VehicleTowedError" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[_car,player] remoteExec ["Server_JobRoadWorker_Impound",2];
}] call compile_Global;

["A3PL_JobRoadWorker_OpenImpoundList",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private _isRoadside = (player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) isEqualTo ("STR_Common_Job_Roadworker" call A3PL_Localize);
	private _isCorporate = [(player getVariable ["character_id",""])] call A3PL_Config_InCompany;
	private _hasLicense = [player,"impound"] call A3PL_Company_HasLicense;
	private _job = (player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) isEqualTo ("STR_Common_Company" call A3PL_Localize);
	if((!_isRoadside) && (!_isCorporate || !_hasLicense || !_job)) exitWith {};
	createDialog "Dialog_ImpoundList";
	[player] remoteExec ["Server_JobRoadWorker_GetImpounded",2];
}] call compile_Global;

["A3PL_JobRoadWorker_ImpoundListReceive",
{
	disableSerialization;
	private _array = param [0,[]];
	private _display = findDisplay 42;
	if (isNull _display) exitWith {};
	private _control = _display displayCtrl 1500;
	A3PL_ImpoundList_Data = _array;
	{
		private _id = _x select 0;
		private _class = _x select 1;
		private _customName = _x select 2;
		private _impoundTimestamp = _x select 4;
		private _impoundDuration = _x select 5;
		private _displayName = getText (configFile >> "CfgVehicles" >> _class >> "displayName");
		private _index = _control lbAdd format ["%1 [%2]",_displayName,toUpper _id];
		_control lbSetData [_index,str _forEachIndex];
	} forEach _array;
	_control ctrlAddEventHandler ["LBSelChanged",{call A3PL_JobRoadWorker_ImpoundVehicleInfo;}];
}] call compile_Global;

["A3PL_JobRoadWorker_ImpoundVehicleInfo",
{
	disableSerialization;
	private _display = findDisplay 42;
	if (isNull _display) exitWith {};
	private _listCtrl = _display displayCtrl 1500;
	private _infoCtrl = _display displayCtrl 1501;
	lbClear _infoCtrl;
	private _sel = lbCurSel _listCtrl;
	if (_sel < 0) exitWith {};
	private _dataIndex = parseNumber (_listCtrl lbData _sel);
	private _data = A3PL_ImpoundList_Data select _dataIndex;
	private _id = _data select 0;
	private _class = _data select 1;
	private _fuel = _data select 3;
	private _impoundTimestamp = _data select 4;
	private _impoundDuration = _data select 5;
	private _vehPrice = [_class] call A3PL_Config_GetVehicleMSRP;
	private _displayName = getText (configFile >> "CfgVehicles" >> _class >> "displayName");

	_infoCtrl lbAdd format [("STR_A3PL_Job_Roadworker_InfoVehicle" call A3PL_Localize),_displayName];
	_infoCtrl lbAdd format [("STR_A3PL_Job_Roadworker_InfoPlate" call A3PL_Localize),toUpper _id];
	_infoCtrl lbAdd format [("STR_A3PL_Job_Roadworker_InfoFuel" call A3PL_Localize),round(_fuel * 100),"%"];

	if (_impoundDuration > 0 && _impoundTimestamp > 0) then {
		_infoCtrl lbAdd format [("STR_A3PL_Job_Roadworker_InfoDuration" call A3PL_Localize),_impoundDuration];
		_infoCtrl lbAdd "---";
		private _remainingDays = (_impoundDuration / 1440) max 0.01;
		private _dailyPercent = Impound_DailyPercent / 100;
		private _maxPercent = Impound_MaxPercent / 100;
		private _percent = (_dailyPercent * _remainingDays) min _maxPercent;
		private _cost = round (_vehPrice * _percent);
		_infoCtrl lbAdd format [("STR_A3PL_Job_Roadworker_InfoEarlyReleaseCost" call A3PL_Localize),_cost];
		_infoCtrl lbAdd ("STR_A3PL_Job_Roadworker_InfoTimeCalculated" call A3PL_Localize);
	} else {
		_infoCtrl lbAdd ("STR_A3PL_Job_Roadworker_InfoFreeRelease" call A3PL_Localize);
	};
}] call compile_Global;

["A3PL_JobRoadWorker_ReleaseVehicle",
{
	disableSerialization;
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private _display = findDisplay 42;
	if (isNull _display) exitWith {};
	private _listCtrl = _display displayCtrl 1500;
	private _sel = lbCurSel _listCtrl;
	if (_sel < 0) exitWith {};
	private _dataIndex = parseNumber (_listCtrl lbData _sel);
	private _data = A3PL_ImpoundList_Data select _dataIndex;
	private _id = _data select 0;
	private _class = _data select 1;
	private _impoundDuration = _data select 5;
	private _payEarly = (_impoundDuration > 0);
	[player,_id,_class,_payEarly] remoteExec ["Server_JobRoadWorker_ReleaseVehicle",2];
	closeDialog 0;
}] call compile_Global;

["A3PL_JobRoadWorker_RentVehicle",
{
	private["_spawnLoc","_location"];
	_location = param [0,player_objintersect];
	_pCash = player getVariable["Player_Cash",0];
	_job = player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];

    private _isCorporate = [(player getVariable ["character_id",""])] call A3PL_Config_InCompany;
    private _hasLicense = [player,"impound"] call A3PL_Company_HasLicense;
    if (_isCorporate && _hasLicense) exitWith {[("STR_A3PL_Job_Roadworker_CantRentThisCar" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if(_job isNotEqualTo ("STR_Common_Job_Roadworker" call A3PL_Localize)) exitWith {[("STR_A3PL_Job_Roadworker_GoToJobCenter" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	/* START HOW TO PAY */
	player setVariable ["paymentResult",objNull];
	[Job_Roadworker_RentVehicle_Price] call A3PL_Bank_HowToPay;
	[_location,_spawnLoc] spawn {
		params["_location","_spawnLoc"];
		waitUntil {(player getVariable "paymentResult") isNotEqualTo objNull};
		if (!(player getVariable "paymentResult")) exitWith {};
		/* END HOW TO PAY */
		[format[("STR_A3PL_Job_Roadworker_VehicleRent" call A3PL_Localize),Job_Roadworker_RentVehicle_Price],Color_Green] call A3PL_Notification;

		switch(_location) do {
		case npc_roadworker: {_spawnLoc = [2858.05,5551.04,0.5];}; // Silverton
		case npc_roadworker_1: {_spawnLoc = [6491.83,7591.55,0.422];}; // Elk City
		case npc_roadworker_2: {_spawnLoc = [7228.984,6291.964,0.794];}; // Blackwood City
		case npc_roadworker_3: {_spawnLoc = [10236.220,8455.28,0.388];}; // Northdale
		case npc_roadworker_5: {_spawnLoc = [9857.64,7905.97,0.2];}; //Deadwood 
		default {_spawnLoc = [2353.047,5479.137,0.766];};
		};

		["A3PL_P362_TowTruck",_spawnLoc,("STR_Common_Job_Roadworker" call A3PL_Localize),Job_Roadworker_RentVehicle_Price] spawn A3PL_Lib_JobVehicle_Assign;
	};
}] call compile_Global;
