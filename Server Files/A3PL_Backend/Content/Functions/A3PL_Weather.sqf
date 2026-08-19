/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
/*
	Start Locations: Crime Base, The T 
	Destinations: Usine de marchandises, DOC
*/
["A3FL_Weather_Tornado",
{
	private["_startLocation","_endLocation"];
	private _tornado_start = selectRandom [
 		[("STR_A3PL_Weather_Location1" call A3PL_Localize),[8241.77,8609.79,0.00138474]],
 		[("STR_A3PL_Weather_Location2" call A3PL_Localize),[3840.21,4704.29,0.00143909]],
		[("STR_A3PL_Weather_Location3" call A3PL_Localize),[4013.14,6974.52,0.00135803]],
		[("STR_A3PL_Weather_Location4" call A3PL_Localize),[7702.66,6680.67,0.00143909]],
		[("STR_A3PL_Weather_Location5" call A3PL_Localize),[8623.92,6866.17,0.00143814]],
		[("STR_A3PL_Weather_Location6" call A3PL_Localize),[5871.49,4963.6,0.00120401]]
	];

	private _tornado_dest = selectRandom [
 		[("STR_A3PL_Weather_Location7" call A3PL_Localize),[6592.49,6163.28,0.00143814]],
 		[("STR_A3PL_Weather_Location8" call A3PL_Localize),[4779.4,6001.1,0.00143886]],
		[("STR_A3PL_Weather_Location9" call A3PL_Localize),[5577.19,5951.76,0.00146675]],
		[("STR_A3PL_Weather_Location10" call A3PL_Localize),[6308.69,6557.15,0.00143886]],
		[("STR_A3PL_Weather_Location11" call A3PL_Localize),[2580.25,5523.79,0.277536]]
	];

	private _aiGroup = createGroup west;

	private _startLocation = _tornado_start select 0;
	private _endLocation = _tornado_dest select 0;
	private _tornado_start = _tornado_start select 1;
	private _tornado_dest = _tornado_dest select 1;

	_tornadosource = "Land_HelipadEmpty_F" createVehicle _tornado_start;
	_tornadomid	= "Land_HelipadEmpty_F" createVehicle _tornado_start;
	_tornadend = "Land_HelipadEmpty_F" createVehicle _tornado_dest;

	_marker = createMarker ["TORNADO",_tornadosource];
	_marker setMarkerShape "ICON";
	_marker setMarkerType "A3FL_Markers_Tornado";
	_marker setMarkerText ("STR_A3PL_Weather_Tornado" call A3PL_Localize);
	_tornadomid setPosATL [getPosATL _tornadosource select 0,getPosATL _tornadosource select 1,100];
	[_tornadosource,_tornadomid] remoteExec ["A3FL_Weather_Tornado_Effect",-2,true];
	[_tornadomid] remoteExec ["A3FL_Weather_Tornado_Sound",-2,true];
	[_tornadosource] spawn {_tuner_tor = _this select 0;while {!isNull _tuner_tor} do {	[_tuner_tor] remoteExec ["A3FL_Weather_Tornado_Thunder",-2,true];sleep 3}};
	[_startLocation,_endLocation] remoteExec ["A3FL_Weather_Tornado_Alert",2];
	[_tornadosource,_tornadomid] remoteExec ["A3FL_Weather_Tornado_Damage",-2,true];

	a3fl_tornado = "start";
	publicvariable "a3fl_tornado";
	a3fl_foglevel = fog;
	a3fl_rainlevel = rain;
	a3fl_thundlevel = lightnings;
	a3fl_windlevel = wind;
	a3fl_overcastlevel = overcast;
	publicVariable "a3fl_foglevel";
	publicVariable "a3fl_rainlevel";
	publicVariable "a3fl_thundlevel";
	publicVariable "a3fl_windlevel";
	publicVariable "a3fl_overcastlevel";
	sleep 0.1;
	setWind [20, 20, true];
	30 setFog [3,1,7];
	30 setRain 5;
	30 setOvercast 5;

	while {a3fl_tornado isEqualTo "start"} do
	{
		private _reldir = getpos _tornadosource getDir _tornadend;
		private _fct = selectRandom [90,-90];
		private _op_dir = _reldir+random _fct;
		private _dist = 3+(random 4);
		private _new_poz = [getpos _tornadosource,_dist, _op_dir] call BIS_fnc_relPos;
		_tornadosource setpos _new_poz;
		_marker setMarkerPos _new_poz;
		
		if (_tornadosource distance _tornado_dest < 20) then {a3fl_tornado = "stop"; publicVariable "a3fl_tornado";}; 
		sleep 1;
		_tornadomid setPosATL [getPosATL _tornadosource select 0,getPosATL _tornadosource select 1,100];
		sleep 0.5;
	};
	[_tornadosource,["uragan_end",2000]] remoteExec ["say3d"];
	deleteVehicle _tornadomid;
	sleep 20;
	[("STR_A3PL_Weather_Alert" call A3PL_Localize),("STR_A3PL_Weather_AlertDescription" call A3PL_Localize),("STR_A3PL_Weather_FishersNews" call A3PL_Localize)] remoteExec ["A3PL_Player_News",-2];
	deleteMarker _marker;
	deleteVehicle _tornadosource;
	deleteVehicle _tornadend;
	30 setFog 0;
	60 setRain a3fl_rainlevel;
	60 setLightnings a3fl_thundlevel;
	60 setOvercast a3fl_overcastlevel;
	setWind [a3fl_windlevel select 0, a3fl_windlevel select 1, true];
}] call compile_Global;

["A3FL_Weather_Tornado_Damage",
{
	private _tsource = _this select 0;
	private _tmid = _this select 1;
	private _chance = random(100);
	private _wound = selectRandom ["right lower arm","left lower arm","left upper leg","right upper leg","left lower leg","right lower leg"];
	while {a3fl_tornado isEqualTo "start"} do {
		{
			if(_x getVariable ["pVar_RedNameOn",true]) exitWith {};
			if(_x != _tsource || _x != _tmid) then {
				if((_x isKindOf "Car") || (_x isKindOf "Man") || (_x isKindOf "Air")) then {
					_x setvelocity [(random 10) * selectRandom [-1,1],(random 10)* selectRandom [-1,1],20+(random 10)* selectRandom [-1,1]];
					if(_x isKindOf "Man") then {
						if (_chance <= 10) then {
							[_x,_wound,"bruise"] call A3PL_Medical_ApplyWound;
						};
						if(_chance <= 1) then {
							[_x,_wound,"cut"] call A3PL_Medical_ApplyWound;
						};
					} else {
						_x setdamage 0.5;
					};
					sleep 0.5;
				} else {
					_x setdamage [1,false];
				};
			};
		} foreach (ASLToAGL getPosASL _tsource nearEntities [["Man","Car","Air","Building"], 100]);
	};
}] call compile_Global;

["A3FL_Weather_Tornado_Effect",
{
	_tsource = _this select 0;
	_tornadomid = _this select 1;

	_white_vortex = "#particlesource" createVehicle getPos _tsource;
	_urcet = "#particlesource" createVehicle getPos _tsource;
	_turning = "#particlesource" createVehicle getPos _tsource;
	_leaves  = "#particlesource" createVehicle getPos _tsource;
	_hat = "#particlesource" createVehicle getPos _tornadomid;

	_white_vortex setParticleCircle [50, [0.2, -0.5, 0.9]];
	_white_vortex setParticleRandom [2,[0.25,0.25,0],[0.175,0.175,0.3],0,1,[0,0,0,0.1],0,0];
	_white_vortex setParticleParams [["\A3\data_f\cl_basic.p3d", 1, 0, 1], "", "Billboard", 1, 10, [0, 0, 0], [0, 0, 0.75], 15, 17, 13, 0.7, [15, 17, 19], [[0.5, 0.5, 0.5, 0.3], [0.25, 0.25, 0.25, 0.5], [0.5, 0.5, 0.5, 0]], [0.08],0.5,0, "", "", _tsource];
	_white_vortex setDropInterval 0.05;
	_leaves setParticleCircle [35, [10, -10, 0]]; 
	_leaves setParticleRandom [5, [0.25, 0.25, 0], [0.175, 0.175, 0], 2, 0.25, [0, 0, 0, 0.1], 1, 1];
	_leaves setParticleParams [["\A3\data_f\ParticleEffects\Hit_Leaves\Sticks_Green", 1, 1, 1], "", "SpaceObject", 1, 15, [0, 0, 5], [0, 0, 25], 0.75, 15, 7.9, 0.085, [5, 5, 5], [[0, 0, 0, 1], [0.25, 0.25, 0.25, 0.5]], [0.08], 1, 0.25, "", "",_tsource];
	_leaves setDropInterval 0.3;
	_turning setParticleCircle [30,[0,0,0]];
	_turning setParticleRandom [3,[0.25,0.25,0],[0.175,0.175,0.3],100,1,[0,0,0,0.1],0,0];
	_turning setParticleParams [["\A3\data_f\cl_basic.p3d", 1, 0, 1], "", "Billboard", 1,10,[0,0,0],[0,0,150],63,1,8,0.5,[12,12,20],[[0.1,0.1,0.1,0.03],[0.1,0.1,0.1,0.1],[0,0,0,0.5]],[0.08],1,1, "", "", _tsource];
	_turning setDropInterval 0.01;
	_urcet setParticleCircle [5,[0,0,0]];
	_urcet setParticleRandom [3,[0.1,0.1,30],[2,2,1],55,0.51,[0,0,0,0.1],0.1,0.2];
	_urcet setParticleParams [["\A3\data_f\cl_basic.p3d", 1, 0, 1], "", "Billboard", 1,8,[0,0,20],[0,0,3],63,5.5,7,0,[3,5,7,8,15,35,40],[[0.1,0.1,0.1,0],[0,0,0,0.5],[0.1,0.1,0.1,0.5],[0.1,0.1,0.1,0.5],[0,0,0,1],[0,0,0,0.5],[0,0,0,0.5]],[0.08],0,0, "", "", _tsource];
	_urcet setDropInterval 0.005;
	sleep 9;
	_hat setParticleCircle [0,[0,0,0]];
	_hat setParticleRandom [5,[20,20,1],[400,400,5],50,2,[0,0,0,0.1],0,0];
	_hat setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1],"","Billboard",1,16,[0,0,150],[0,0,250],80,11.5,7.9,0.1,[10,20,35],[[0,0,0,0.5],[0,0,0,0.5],[0,0,0,0]],[0.08],0,0,"", "", _tornadomid];
	_hat setDropInterval 0.002;
	waitUntil {a3fl_tornado isEqualTo "stop"};
	_source_end_part = "#particlesource" createVehicle (getpos _tsource);
	_source_end_part setParticleCircle [50, [0.2, 0.5, 0.9]];
	_source_end_part setParticleRandom [0, [0.25, 0.25, 0], [0.175, 0.175, 0.3], 0, 1, [0, 0, 0, 0.1], 0, 0];
	_source_end_part setParticleParams [["\A3\data_f\cl_basic.p3d", 1, 0, 1], "", "Billboard", 1, 10, [0, 0, 0], [0, 0, 0.75], 15, 17, 13, 0.7, [15, 17, 19], [[0.5, 0.5, 0.5, 0.3], [0.25, 0.25, 0.25, 0.5], [0.5, 0.5, 0.5, 0]], [0.08], 0.1, 3, "", "", _tsource];
	_source_end_part setDropInterval 0.05;
	deleteVehicle _white_vortex;
	deleteVehicle _urcet;
	deleteVehicle _turning;
	deleteVehicle _leaves;
	deleteVehicle _hat;
	sleep 17;
	deleteVehicle _source_end_part;
}] call compile_Global;

["A3FL_Weather_Tornado_Thunder",
{
	private["_thunder_tornado","_fulger_prez","_fireChance","_fifr","_direction","_thunder","_relativePosition","_bolt","_lighting","_light"];
	_thunder_tornado = _this select 0;
	_fulger_prez = random 53;
	_fireChance = random(100);
	_fifr = count([("STR_Common_FIFR" call A3PL_Localize)] call A3PL_Lib_FactionPlayers);

	if (_fulger_prez > 47) then {
		_direction = [_thunder_tornado, 2, random 360, [0]] call BIS_fnc_param;
		_thunder = selectRandom ["thunder_1", "thunder_2"];
		private "_relativePosition";
		_relativePosition = [_thunder_tornado, 0, _direction] call bis_fnc_relPos;
		private "_bolt";
		_bolt = createvehicle ["LightningBolt", _relativePosition, [], 0, "can_collide"];
		_bolt setVelocity [0, 0, -10];
		_lighting = "lightning_F" createvehiclelocal _relativePosition;
		_lighting setdir random 360;
		_lighting setpos _relativePosition;
		_light = "#lightpoint" createvehiclelocal _relativePosition;
		_light setLightDayLight true;
		_light setpos _relativePosition;
		_light setLightBrightness random 30;
		_light setLightAmbient [0.5, 0.5, 1];
		_light setlightcolor [1, 1, 2];
		sleep (0.3 + random 0.1);
		_thunder_tornado say3d [_thunder,2000];
		deletevehicle _bolt;
		deletevehicle _light;
		deletevehicle _lighting;
		if (_fifr >= 5 && _fireChance <= 10) then {[_relativePosition] call A3PL_Fire_StartFire;};
	};
}] call compile_Global;

["A3FL_Weather_Tornado_Sound",
{
	_object = _this select 0;
	while{a3fl_tornado isEqualTo "start"} do {_object say3d ["uragan_1",4000];sleep 150;};
}] call compile_Global;

["A3FL_Weather_Tornado_Alert",
{
	private _startLocation = _this select 0;
	private _endLocation = _this select 1;

	switch (_startLocation) do {
		case ("STR_A3PL_Weather_Location1" call A3PL_Localize): {
			[("STR_A3PL_Weather_Alert" call A3PL_Localize),("STR_A3PL_Weather_AlertLocation1" call A3PL_Localize),("STR_A3PL_Weather_FishersNews" call A3PL_Localize)] remoteExec ["A3PL_Player_News",-2];
		};
		case ("STR_A3PL_Weather_Location2" call A3PL_Localize): {
			[("STR_A3PL_Weather_Alert" call A3PL_Localize),("STR_A3PL_Weather_AlertLocation2" call A3PL_Localize),("STR_A3PL_Weather_FishersNews" call A3PL_Localize)] remoteExec ["A3PL_Player_News",-2];
		};
		case ("STR_A3PL_Weather_Location3" call A3PL_Localize): {
			[("STR_A3PL_Weather_Alert" call A3PL_Localize),("STR_A3PL_Weather_AlertLocation3" call A3PL_Localize),("STR_A3PL_Weather_FishersNews" call A3PL_Localize)] remoteExec ["A3PL_Player_News",-2];
		};
		case ("STR_A3PL_Weather_Location4" call A3PL_Localize): {
			[("STR_A3PL_Weather_Alert" call A3PL_Localize),("STR_A3PL_Weather_AlertLocation4" call A3PL_Localize),("STR_A3PL_Weather_FishersNews" call A3PL_Localize)] remoteExec ["A3PL_Player_News",-2];
		};
		case ("STR_A3PL_Weather_Location5" call A3PL_Localize): {
			[("STR_A3PL_Weather_Alert" call A3PL_Localize),("STR_A3PL_Weather_AlertLocation5" call A3PL_Localize),("STR_A3PL_Weather_FishersNews" call A3PL_Localize)] remoteExec ["A3PL_Player_News",-2];
		};
		case ("STR_A3PL_Weather_Location6" call A3PL_Localize): {
			[("STR_A3PL_Weather_Alert" call A3PL_Localize),("STR_A3PL_Weather_AlertLocation6" call A3PL_Localize),("STR_A3PL_Weather_FishersNews" call A3PL_Localize)] remoteExec ["A3PL_Player_News",-2];
		};
	};

	["A3PL_Common\effects\airalarm.ogg",2500,0,10] remoteExec ["A3PL_FD_FireStationAlarm",-2];
	sleep 60;

	switch (_endLocation) do {
		case ("STR_A3PL_Weather_Location7" call A3PL_Localize): {
			[("STR_A3PL_Weather_AlertLocation7" call A3PL_Localize),Color_red] remoteExec ["A3PL_Notification",-2];
			sleep 1;
			[("STR_A3PL_Weather_AlertLocation7" call A3PL_Localize),Color_red] remoteExec ["A3PL_Notification",-2];
			sleep 1;
			[("STR_A3PL_Weather_AlertLocation7" call A3PL_Localize),Color_red] remoteExec ["A3PL_Notification",-2];
		};
		case ("STR_A3PL_Weather_Location8" call A3PL_Localize): {
			[("STR_A3PL_Weather_AlertLocation8" call A3PL_Localize),Color_red] remoteExec ["A3PL_Notification",-2];
			sleep 1;
			[("STR_A3PL_Weather_AlertLocation8" call A3PL_Localize),Color_red] remoteExec ["A3PL_Notification",-2];
			sleep 1;
			[("STR_A3PL_Weather_AlertLocation8" call A3PL_Localize),Color_red] remoteExec ["A3PL_Notification",-2];
		};
		case ("STR_A3PL_Weather_Location9" call A3PL_Localize): {
			[("STR_A3PL_Weather_AlertLocation9" call A3PL_Localize),Color_red] remoteExec ["A3PL_Notification",-2];
			sleep 1;
			[("STR_A3PL_Weather_AlertLocation9" call A3PL_Localize),Color_red] remoteExec ["A3PL_Notification",-2];
			sleep 1;
			[("STR_A3PL_Weather_AlertLocation9" call A3PL_Localize),Color_red] remoteExec ["A3PL_Notification",-2];
		};
		case ("STR_A3PL_Weather_Location10" call A3PL_Localize): {
			[("STR_A3PL_Weather_AlertLocation10" call A3PL_Localize),Color_red] remoteExec ["A3PL_Notification",-2];
			sleep 1;
			[("STR_A3PL_Weather_AlertLocation10" call A3PL_Localize),Color_red] remoteExec ["A3PL_Notification",-2];
			sleep 1;
			[("STR_A3PL_Weather_AlertLocation10" call A3PL_Localize),Color_red] remoteExec ["A3PL_Notification",-2];
		};
		case ("STR_A3PL_Weather_Location11" call A3PL_Localize): {
			[("STR_A3PL_Weather_AlertLocation11" call A3PL_Localize),Color_red] remoteExec ["A3PL_Notification",-2];
			sleep 1;
			[("STR_A3PL_Weather_AlertLocation11" call A3PL_Localize),Color_red] remoteExec ["A3PL_Notification",-2];
			sleep 1;
			[("STR_A3PL_Weather_AlertLocation11" call A3PL_Localize),Color_red] remoteExec ["A3PL_Notification",-2];
		};
	};
}] call compile_Global;
