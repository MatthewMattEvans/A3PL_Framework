/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
#define DEFAULTFARE [25,10,10,5]

["A3PL_JobTaxi_SetupFare",
{
	disableSerialization;
	private ["_veh","_control","_display"];
	_veh = vehicle player;
	createDialog "Dialog_TaxiMeter";
	_display = findDisplay 29;
	//set existing fares in dialog
	{
		_control = _display displayCtrl (1400+_forEachIndex);
		_control ctrlSetText format ["%1",_x];
	} foreach (_veh getVariable ["fare",DEFAULTFARE]);

	//button EH
	_control = _display displayCtrl 1600;
	_control ctrlAddEventHandler ["buttonDown",{call A3PL_JobTaxi_SetFare;}];
}] call compile_Global;

["A3PL_JobTaxi_SetFare",
{
	private ["_newFareArray","_display","_invalidInput","_veh","_rate"];
	_display = findDisplay 29;
	_veh = vehicle player;
	if (isNull _display) exitwith {};
	if ((typeOf _veh) != "A3PL_CVPI_Taxi") exitwith {[("STR_A3PL_Job_Taxi_YoureNotInTaxi" call A3PL_Localize)] call A3PL_Notification;};
	if ((driver _veh) != player) exitwith {[("STR_A3PL_Job_Taxi_OnlyConductorCanEditPrice" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	//set new fares
	_newFareArray = [];
	_invalidInput = false;
	{
		_ctrl = _display displayCtrl _x;
		_rate = parseNumber ctrlText _ctrl;
		if (_rate < 0) exitwith {_invalidInput = true;};
		_newFareArray pushback _rate;
	} foreach [1400,1401,1402,1403];
	if (_invalidInput) exitwith {[("STR_A3PL_Job_Taxi_WrongFixedPrice" call A3PL_Localize)] call A3PL_Notification;};
	//set the rate
	_rate = format ["%1",(_newFareArray select 1)];
	if (count _rate > 2) exitwith {[("STR_A3PL_Job_Taxi_CanBeMoreThan90Dollars" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (count _rate == 1) then {_rate = format ["0%1",_rate];};
	{
		_veh setObjectTextureGlobal [_x,format ["\a3pl_cars\common\textures\numbers\%1.paa",_rate select [_forEachIndex,1]]];
	} foreach [8,9];

	_srate = _newFareArray select 2;
	_60srate = _newFareArray select 3;
	_extrasplus = _srate + _60srate;
	_extras = format ["%1",_extrasplus];
	if (_extrasplus > 1000) exitwith {[("STR_A3PL_Job_Taxi_CanBeMoreThan1000Dollars" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (count _extras == 1) then {_extras = format ["0%1",_extras];};
	{
		_veh setObjectTextureGlobal [_x,format ["\a3pl_cars\common\textures\numbers\%1.paa",_extras select [_forEachIndex,1]]];
	} foreach [16,17,18];

	//set variable
	_veh setVariable ["fare",_newFareArray,true];
	[("STR_A3PL_Job_Taxi_NewPriceApplied" call A3PL_Localize),Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_JobTaxi_FareLoop",
{
	private ["_veh","_tDistance","_tFare","_tTimeStationary","_tTime","_pos","_cpos","_fareArray","_sleepAmount"];
	private ["_tFareInitial","_tFareMiles","_tFare60sec","_tFare60SecStat"];
	_veh = param [0,objNull];
	_sleepAmount = 6; //variable we use to sync globally the taxi meter every 5 sec
	_tDistance = 0; //total distance in miles
	_tTimeStationary = 0; //total time in sec the car was stationary
	_tTime = 0; //total time in sec the fare was running
	_tFare = 0; //total fare in dollars
	_pos = getpos _veh;
	while {player == (driver _veh)} do
	{
		sleep 1;
		if (_veh getVariable ["fare_reset",false]) then
		{
			_tDistance = 0;
			_tTimeStationary = 0;
			_tTime = 0;
			{
				_veh setObjectTextureGlobal [_x,"\a3pl_cars\common\textures\numbers\0.paa"];
			} foreach [15,14,13,12,11,10];
			_veh setVariable ["fare_reset",false,false];
		};
		if (_veh getVariable ["fare_running",false]) then
		{
			_fareArray = _veh getVariable ["fare",DEFAULTFARE];
			_cPos = getpos _veh; //current pos
			_distance = (_cPos distance2D _pos) *0.000621371;
			_tDistance = _tDistance + _distance;

			//Increase total time
			_tTime = _tTime + 1;
			//increase time stationairy if necesarry
			if ((_cPos distance2D _pos) < 3) then {_tTimeStationary = _tTimeStationary + 1;};

			//calculate the total fare
			_tFareInitial = _fareArray select 0;
			_tFareMiles = (_tDistance / 0.2) * (_fareArray select 1);
			_tFare60sec = (_tTime / 60) * (_fareArray select 2);
			_tFare60SecStat = (_tTimeStationary / 60) * (_fareArray select 3);
			_tFare = round (_tFareInitial + _tFareMiles + _tFare60sec + _tFare60SecStat);

			//set the fare
			_tfare = format ["%1",_tfare];
			{
				if (((count _tfare) - _forEachIndex) <= 0) exitwith {}; //"20"
				_veh setObjectTexture [_x,format ["\a3pl_cars\common\textures\numbers\%1.paa",(_tfare select [((count _tfare - 1) - _forEachIndex),1])]];
			} foreach [15,14,13,12,11,10];

			//sync numbers every 5 seconds
			if (_sleepAmount > 5) then
			{
				_textures = getObjectTextures _veh;
				{
					_veh setObjectTextureGlobal [_x,_textures select _x];
				} foreach [15,14,13,12,11,10];
				_sleepAmount = 0;
			};

			//set a new _pos
			_pos = getpos _veh;
			_sleepAmount = _sleepAmount + 1;
		};
	};
}] call compile_Global;

["A3PL_JobTaxi_FareStart",
{
	private ["_veh"];
	_veh = param [0,objNull];
	if (isNil {_veh getVariable ["fare",nil]}) exitwith {[("STR_A3PL_Job_Taxi_AddPriceFirst" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_veh setVariable ["fare_running",true,false];
}] call compile_Global;

["A3PL_JobTaxi_FarePause",
{
	private ["_veh"];
	_veh = param [0,objNull];
	_veh setVariable ["fare_running",false,false];
}] call compile_Global;

["A3PL_JobTaxi_FareReset",
{
	private ["_veh"];
	_veh = param [0,objNull];
	_veh setVariable ["fare_reset",true,false];
	_veh setVariable ["fare_running",false,false];
}] call compile_Global;

["A3PL_JobTaxi_RentVehicle", {
	params [
		["_location",player_objintersect,[objNull]],
		["_class",Job_Taxi_Vehicle_Classname,[Job_Taxi_Vehicle_Classname]],
		["_price",Job_Taxi_Price,[Job_Taxi_Price]]
	];

	private _job = player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
	if (_job isNotEqualTo ("STR_Common_Job_Taxi" call A3PL_Localize)) exitWith {[("STR_A3PL_Job_Taxi_GoToJobCenter" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	
	private _spawnLoc = switch(_location) do {
		case npc_taximan: {[6946.606,6399.792,0]};
		default {[6946.606,6399.792,0]};
	};
	private _posBlocked = (nearestObjects[_spawnLoc,["Car","Ship","Air","Tank"],5]) isNotEqualTo [];
	if(_posBlocked) then {
		[("STR_A3PL_Job_Taxi_SomethingBlockSpawnPoint" call A3PL_Localize),Color_Red] call A3PL_Notification;
	} else {
    	/* START HOW TO PAY */
		player setVariable ["paymentResult",objNull];
		[_price] call A3PL_Bank_HowToPay;
		[_class, _spawnLoc, _price] spawn {
			params ["_class", "_spawnLoc", "_price"];
			waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
			if (!(player getVariable "paymentResult")) exitWith {};
			/* END HOW TO PAY */
			[("STR_A3PL_Job_Taxi_VehicleReady" call A3PL_Localize),Color_Green] call A3PL_Notification;
    		[_class,_spawnLoc,("STR_Common_Job_Taxi" call A3PL_Localize),_price] spawn A3PL_Lib_JobVehicle_Assign;
		};
	};
}] call compile_Global;
