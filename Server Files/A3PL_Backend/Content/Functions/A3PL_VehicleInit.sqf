/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
//Handle Vehicle Inits - Client Side
//U stands for unloaded, the loading screen copies this (compileFinal to prevent hacking) into A3PL_HandleVehicleInit, this will run all vehicle inits located in config.cpp as soon as this function excists
//Vehicle inits can simply be disabled by disabling this variable being copied in A3PL_Loading
['A3PL_Vehicle_HandleInitU', {
	params [
		"_vehicle"
	];

	if (isDedicated) exitwith {};

	private _veh = objNull;
	if (_vehicle isEqualType []) then {
		if(_vehicle#0 isEqualType []) then {
			_veh = _vehicle#0#0;
		} else {
			_veh = _vehicle#0;
		};
	} else {
		_veh = _vehicle;
	};

	private _class = typeOf _veh;
	private _isCar = _veh isKindOf "Car";
	private _initfunction = !isNil ('A3PL_Vehicle_Init_' + _class);
	
	//if (_isCar) then {_veh call A3PL_Vehicle_Init_A3PL_Engine;}; //Doit regarder l'interaction pour démarrer le véhicule
	if (_initfunction) then {
		_veh call (missionNamespace getVariable ('A3PL_Vehicle_Init_' + _class));
	};
	if (_class IN ["Heli_Medium01_Coastguard_H","Heli_Medium01_Sheriff_H","Heli_Medium01_Luxury_H","Heli_Medium01_Medic_H","Heli_Medium01_Military_H","Heli_Medium01_Veteran_H"]) then {_veh call A3PL_Vehicle_Init_Heli_Medium01_H;};
	if (_class IN (Config_FISD_Vehs + Config_FIFR_Vehs)) then {_veh call A3PL_Vehicle_Init_FactionVeh;_veh setVariable ["TF_RadioType", "a3pl_megaphone", true];}; 

	_veh addEventHandler ["ContainerClosed",
	{
		private _container = param [0,objNull];
		[_container] remoteExec ["Server_Storage_Vehicle", 2];
	}];
	_veh addEventHandler ["ContainerOpened",
	{
		private _container = param [0,objNull];
		if (_container getVariable ["locked",true]) then {
			[] spawn A3PL_Lib_CloseInventoryDialog;
			[("STR_A3PL_VehicleInit_TrunkLocked" call A3PL_Localize),Color_Red] call A3PL_Notification;
		};
	}];
	
	private _canTow = false;
	{
		if (_veh isKindOf _x) then {_canTow = true;};
	} foreach A3PL_HitchingVehicles;
	if (_canTow) then {_veh call A3PL_Vehicle_Init_A3PL_F150;};
}] call compile_Global;

/*["A3PL_Vehicle_Init_A3PL_Engine",
{
	_this addEventHandler ["Engine", {
		private _var = _this#0 getVariable "ignition";
		if ((isNil "_var") && (local(_this#0))) then {
			(vehicle player) engineOn false;
		};
	}];
}] call compile_Global;*/

["A3PL_Vehicle_Init_A3PL_Pierce_Heavy_Ladder",
{
	_this addEventHandler ["Fired",{[_this#0] call A3PL_FD_LadderHeavyFired;}];
	_this addEventHandler ["GetIn",
	{
		params ["_vehicle", "_role", "_unit", "_turret"];
		[_vehicle,player] remoteExec ["A3PL_Lib_ChangeLocality", 2];
		if (_role isEqualTo "gunner") then{[] spawn A3PL_FD_ControlLadder;};
	}];
}] call compile_Global;

["A3PL_Vehicle_Init_A3FL_M_900_Base_F",
{
	_this animate["addDoors",1];
	_this addEventHandler ["GetIn", {
		params ["_veh","_position","_unit"];
		if (!local _unit) exitwith {};
		if (_position IN ["gunner","driver"]) then {[_veh] spawn A3PL_ATC_GetInAircraft;};
	}];
}] call compile_Global;

["A3PL_Vehicle_Init_A3PL_MiniExcavator",
{
	private _veh = _this;
	_veh addEventHandler ["GetIn",
	{
		params ["_veh", "_role", "_unit", "_turret"];
		player action ["ManualFire", _veh];
		if ((_veh animationPhase "Bucket") > 0.5) then
		{
			_veh removeMagazineTurret  ["A3PL_JackhammerMag",[0]];
			_veh removeWeaponTurret ["A3PL_Machinery_Pickaxe",[0,0]];
			_veh addWeaponTurret ["A3PL_Machinery_Bucket",[0,0]];
			_veh addMagazineTurret ["A3PL_BucketMag",[0]];
		};
		if ((_veh animationPhase "Jackhammer") > 0.5) then
		{
			_veh removeMagazineTurret  ["A3PL_BucketMag",[0]];
			_veh removeWeaponTurret ["A3PL_Machinery_Bucket",[0,0]];
			_veh addWeaponTurret ["A3PL_Machinery_Pickaxe",[0,0]];
			_veh addMagazineTurret ["A3PL_JackhammerMag",[0]];
		};
	}];
	_veh addEventHandler ["Fired",
	{
		params ["_veh","_wep"];
		if (!(_wep IN ["A3PL_Machinery_Bucket","A3PL_Shovel"]) || {(_veh animationPhase "Jackhammer") > 0.5}) exitwith
		{
			_veh removeMagazineTurret  ["A3PL_BucketMag",[0]];
			_veh removeWeaponTurret ["A3PL_Machinery_Bucket",[0,0]];
		};
	}];
}] call compile_Global;

['A3PL_Vehicle_Init_A3PL_Ski_Base',
{
	private _veh = _this;
	if (local _veh) then {_veh allowDamage false};
	_veh setVariable["locked",false,true];
	_veh addEventHandler ["GetIn",
	{
		params ["_veh","_pos","_unit"];
		if (_unit isEqualTo player) then
		{
			_veh animate ["wheel",1];
			[_veh] spawn
			{
				params ["_veh"];
				waituntil {sleep 0.5; player IN _veh};
				while {player IN _veh} do
				{
					private _bank = (_veh call BIS_fnc_getPitchBank)#1;
					if ((_bank > 60) OR (_bank < -60)) then
					{
						private ["_attachedTo","_dir","_vel","_y","_p","_r"];
						_attachedTo = (ropeAttachedTo _veh);
						if (isNull _attachedTo) exitwith {};
						_dir = getDir _attachedTo;
						_vel = velocity _veh;
						_y = getdir _veh;
						_p = 0;
						_r = 0;
						_veh setVectorDirAndUp
						[
						 [ sin _y * cos _p,cos _y * cos _p,sin _p],
						 [ [ sin _r,-sin _p,cos _r * cos _p],-_y] call BIS_fnc_rotateVector2D
						];
						_veh setVelocity _vel;
						_veh setDir _dir;
					};
					sleep 0.5;
				};
			};
		};
	}];
	_veh addEventHandler ["GetOut",
	{
		params ["_unit","_pos","_veh"];
		if (_unit isEqualTo player) then{_veh animate ["wheel",0];};
	}];
	_veh addEventHandler ["Local", {
		if (_this#1) then {
			_this#0 allowDamage false;
		};
	}];
}] call compile_Global;

['A3PL_Vehicle_Init_A3PL_F150',
{
	_this addEventHandler ["GetIn",
	{
		params ["_veh","_pos","_unit"];
		if (!local _unit) exitwith {};
		if (_pos isNotEqualTo "driver") exitwith {};

		[_veh] spawn
		{
			params ["_veh"];
			while {driver _veh isEqualTo player} do
			{
				_trailerArray = nearestObjects [_veh modelToWorld [0,-4,0], ["A3PL_Trailer_Base"], 6.5];
				_trailerArray = _trailerArray#0;
				if (!isNil "_trailerArray") then
				{
					if (_trailerArray animationSourcePhase "Hitched" > 4 && _veh animationSourcePhase "Throttle" > 0.1 && _veh animationSourcePhase "Speed" < 3) then
					{
						_vel = velocity _veh;
						_dir = getDir _veh;
						_speed = 0.3;
						_newVel =
						[
							_vel#0 + (sin _dir * _speed),
							_vel#1 + (cos _dir * _speed),
							_vel#2
						];
						_veh setVelocity _newVel;

						_vel = velocity _trailerArray;
						_dir = getDir _trailerArray;
						_newVel =
						[
							_vel#0 + (sin _dir * _speed),
							_vel#1 + (cos _dir * _speed),
							_vel#2
						];
						_trailerArray setVelocity _newVel;
					};

					if( _veh animationSourcePhase "Gear" == -1 && _trailerArray animationSourcePhase "Hitched" > 4 && _veh animationSourcePhase "Throttle" > 0.1 && _veh animationSourcePhase "Speed" < 3) then
					{
						_vel = velocity _veh;
						_dir = getDir _veh;
						_speed = -0.3;
						_newVel =
						[
							_vel#0 + (sin _dir * _speed),
							_vel#1 + (cos _dir * _speed),
							_vel#2
						];
						_veh setVelocity _newVel;

						_vel = velocity _trailerArray;
						_dir = getDir _trailerArray;
						_speed = -0.5;
						_newVel =
						[
							_vel#0 + (sin _dir * _speed),
							_vel#1 + (cos _dir * _speed),
							_vel#2
						];
						_trailerArray setVelocity _newVel;
					};
				};
			sleep 1;
			};
		};
	}];
}] call compile_Global;

['A3PL_Vehicle_Init_A3PL_Jayhawk', {
	private _veh = _this;
	_veh addEventHandler ["GetIn", {
		params ["_veh","_position","_unit"];
		if (!local _unit) exitwith {};
		if (_position IN ["gunner","driver"]) then {[_veh] spawn A3PL_ATC_GetInAircraft;};
	}];
	_veh addEventHandler ["Engine", {
		if (((_this#0 animationPhase "ignition_Switch") < 0.5) && (player IN (_this#0))) then {
			(vehicle player) engineOn false;
		};
	}];
}] call compile_Global;

['A3PL_Vehicle_Init_A3FL_AS_365', {
	private _veh = _this;
	_veh addEventHandler ["GetIn",
	{
		params ["_veh","_position","_unit"];
		if (!local _unit) exitwith {};
		if (_position IN ["gunner","driver"]) then {[_veh] spawn A3PL_ATC_GetInAircraft;};
	}];
	_veh addEventHandler ["Engine", {
		if ((((_this select 0) animationPhase "ignition_Switch") < 0.5) && (player IN (_this select 0))) then {
			(vehicle player) engineOn false;
		};
	}];
}] call compile_Global;

['A3PL_Vehicle_Init_A3FL_AS350_CIV', {
	private _veh = _this;
	_veh addEventHandler ["GetIn",
	{
		params ["_veh","_position","_unit"];
		if (!local _unit) exitwith {};
		if (_position IN ["gunner","driver"]) then {[_veh] spawn A3PL_ATC_GetInAircraft;};
	}];
	_veh addEventHandler ["Engine", {
		if ((((_this select 0) animationPhase "ignition") < 0.5) && (player IN (_this select 0))) then {
			(vehicle player) engineOn false;
		};
	}];
}] call compile_Global;

["A3PL_Vehicle_Init_Heli_Medium01_H",
{
	private _veh = _this;
	_veh setVariable ["clearance",true,true];
	_veh setVariable ["Inspection",[],false];
	_veh addEventHandler ["GetIn",
	{
		params ["_veh","_position","_unit"];
		if (!local _unit) exitwith {};
		if (_position IN ["gunner","driver"]) then{[_veh] spawn A3PL_ATC_GetInAircraft;};
	}];
	_veh addEventHandler ["Engine", {
		if (((_this#0 animationPhase "switch_starter") < 1.9) && (player IN (_this#0))) then {
			(vehicle player) engineOn false;
		};
	}];
}] call compile_Global;

['A3PL_Vehicle_Init_A3PL_Cutter', {
	private _veh = _this;
	_veh addEventHandler ["Local", {if (_this#1) then {(_this#0) allowDamage false; };}];
	_veh addEventHandler ["Fired",{
		[_this#0] spawn {
			_this#0 animate ["gunback",0.5];
			sleep 0.4;
			_this#0 animate ["gunback",0];
		};
	}];
}] call compile_Global;

["A3PL_Vehicle_Init_A3PL_Goose_Base",
{
	private _veh = _this;
	_veh setVariable ["clearance",true,true];
	_veh addEventHandler ["GetIn",
	{
		params ["_veh","_position","_unit"];
		if (!local _unit) exitwith {};
		if (_position IN ["gunner","driver"]) then {[_veh] spawn A3PL_ATC_GetInAircraft;};
	}];
	_veh addEventHandler ["Engine",
	{
		if ((((_this#0) animationSourcePhase "Ignition") < 0.5) && (local (_this#0))) then
		{
			(_this#0) engineOn false;
		};
	}];
	_veh addEventHandler ["HandleDamage", {
		params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];
		private _overWater = !(position _unit isFlatEmpty [-1, -1, -1, -1, 2, false] isEqualTo []);
		private _dmg = if(_overWater && {_projectile isEqualTo ""}) then {0} else {_damage};
		if(_projectile isEqualTo "B_408_Ball") then {_unit setHit ["hitengine",1];};
		_dmg;
	}];
}] call compile_Global;
["A3PL_Vehicle_Init_A3PL_Goose_USCG",{_this call A3PL_Vehicle_Init_A3PL_Goose_Base;}] call compile_Global;

["A3PL_Vehicle_Init_A3PL_RHIB",
{
	_this addEventHandler ["HandleDamage",
	{
		params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];
		if (_projectile isEqualTo "B_408_Ball") then {_unit setHit ["engine_hit",1];};
	}];
}] call compile_Global;

["A3PL_Vehicle_Init_A3PL_Cessna172",
{
	private _veh = _this;
	_veh setVariable ["clearance",true,true];
	_veh addEventHandler ["GetIn",
	{
		params ["_vehicle", "_role", "_unit", "_turret"];
		if (!local _unit) exitwith {};
		if (_position IN ["gunner","driver"]) then {[_veh] spawn A3PL_ATC_GetInAircraft;};
	}];
	_veh addEventHandler ["Engine",
	{
		if ((((_this#0) animationSourcePhase "Ignition") < 0.5) && (local (_this#0))) then
		{
			(_this#0) engineOn false;
		};
	}];
}] call compile_Global;

["A3PL_Vehicle_Init_A3FL_LCM", {
	_this addEventHandler ["GetIn",
	{
		params ["_veh","_position","_unit"];
		if (!local _unit) exitwith {};
		if (_position isEqualTo "driver") then{[_veh] spawn A3PL_Vehicle_LCMRamp;};
	}];
	_this addEventHandler ["HandleDamage",
	{
		private _veh = _this select 0;
		private _projectile = _this select 4;
		if (_projectile IN ["B_408_Ball","Sh_105mm_HEAT_MP_T_Red"]) then {
			_veh setFuel 0;
		};
	}];
}] call compile_Global;

["A3PL_Vehicle_Init_A3PL_CVPI_Taxi",
{
	_this addEventHandler ["GetIn",
	{
		params ["_veh","_position","_unit"];
		if (!local _unit) exitwith {};
		if (_position isEqualTo "driver") then{[_veh] spawn A3PL_JobTaxi_FareLoop;};
	}];
}] call compile_Global;

["A3PL_Vehicle_Init_FactionVeh",
{
	_this addEventHandler ["GetIn",
	{
		params ["_vehicle", "_role", "_unit", "_turret"];
		if (!local _unit) exitwith {};
		if (_role isEqualTo "driver") then
		{
			if !(["FD", typeOf _vehicle] call BIS_fnc_inString) then {[_vehicle] spawn A3PL_Police_RadarLoop;};
			[_vehicle] spawn A3PL_Vehicle_ControlSpotlight;
		};
	}];
}] call compile_Global;

["A3PL_Vehicle_setVehSpeaker",
{
	private _var = (vehicle player) getVariable ["Megaphone",0];
	if(_var > 0) exitWith {[("STR_A3PL_VehicleInit_MegaphoneAlreadyActive" call A3PL_Localize),Color_Red] spawn A3PL_Notification;};

	private _freq = random[10000,50000,99999];
	//Channel
	[call TFAR_fnc_activeLrRadio, 3] call TFAR_fnc_setLrChannel;
	//Freq
	[call TFAR_fnc_activeLrRadio, str(_freq)] call TFAR_fnc_setLrFrequency;
	//Speaker ON
	(call TFAR_fnc_activeLrRadio) call TFAR_fnc_setLrSpeakers;
	//volume
	[call TFAR_fnc_activeLrRadio, 10] call TFAR_fnc_setLrVolume;
	//Radio Code
	[call TFAR_fnc_activeLrRadio, "_bluefor"] call TFAR_fnc_setLrRadioCode;

	(vehicle player) setVariable ["Megaphone",_freq,true];
	[("STR_A3PL_VehicleInit_MegaphoneActivated" call A3PL_Localize),Color_Green] spawn A3PL_Notification;
}] call compile_Global;
