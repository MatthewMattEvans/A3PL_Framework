/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["Server_Vehicle_Buy",
{
	private _player = param [0,objNull];
	if (isNull _player) exitwith {diag_log "Error in Server_Vehicle_Buy: _player is Null"};
	private _charID = (_player getVariable ["character_id",""]);
	private _class = param [1,""];
	private _type = param [2,"vehicle"];
	private _inStorage = param [3,false];
	private _id = [7] call Server_Housing_GenerateID;
	private _color = getArray(configFile >> "CfgVehicles" >> _class >> "hiddenSelectionsTextures");
	if(count(_color) isNotEqualTo 0) then {_color = _color#0} else {_color = "#(argb,8,8,3)color(0,0,0,1.0,CO)";};
	private _query = format ["INSERT INTO players_objects (id,type,class,charid,color) VALUES ('%1','%2','%3','%4','%5')",_id,_type,_class,_charID,_color];
	if (_inStorage) then {
		_query = format ["INSERT INTO players_objects (id,type,class,charid,plystorage,color) VALUES ('%1','%2','%3','%4','1','%5')",_id,_type,_class,_charID,_color];
	};
	[_query,1] spawn Server_Database_Async;
	_id
}] call compile_Server;

["Server_Vehicle_Sell",
{
	private _vehicle = param [0,objNull];
	private _id = (_vehicle getVariable ["owner",[]]);
	[_vehicle] call Server_Vehicle_Despawn;
	if(count(_id) isEqualTo 0) exitWith {};
	private _query = format ["DELETE FROM players_objects WHERE id='%1'",_id select 1];
	[_query,1] spawn Server_Database_Async;
}] call compile_Server;

// ["Server_Vehicle_InitLPChange",
// {
// 	params [
// 		["_player",objNull,[objNull]],
// 		["_veh",objNull,[objNull]],
// 		["_newLP","",[""]]
// 	];
// 	private _currentLP = (_veh getVariable ["owner",["",""]]) select 1;
// 	private _canChange = _veh getVariable ["numPChange",0];

// 	if(_canChange isEqualTo 1) exitWith {[2] remoteExec ["A3PL_Garage_SetLicensePlateResponse", (owner _player), false];};
// 	private _exist = [_newLP] call Server_Vehicle_CheckLP;
// 	if (_exist) exitwith {[0] remoteExec ["A3PL_Garage_SetLicensePlateResponse", (owner _player), false];};

// 	[_newLP,_veh] call Server_Vehicle_Init_SetLicensePlate;

// 	private _query = format ["UPDATE players_objects SET id = '%2',numpchange='1',iscustomplate='1' WHERE id = '%1'",_currentLP,_newLP];
// 	[_query,1] spawn Server_Database_Async;

//   	_player setVariable ["player_cash",(_player getVariable ["player_cash",0]) - 20000,true];
// 	_veh setVariable ["owner",[(_player getVariable ["character_id",""]),_newLP],true];
// 	_veh setVariable ["numPChange",1,true];
// 	_veh setVariable ["isCustomPlate",1,true];
// 	[1] remoteExec ["A3PL_Garage_SetLicensePlateResponse", (owner _player), false];
// }] call compile_Server;

["Server_Vehicle_CheckLP",
{
	private _newLP = param [0,""];
	private _return = false;
	private _query = format ["SELECT id FROM players_objects WHERE id='%1'",_newLP];
	private _idexist = [_query, 2, true] call Server_Database_Async;
	if ((count _idexist) > 0) then {_return = true;};
	_return;
}] call compile_Server;

['Server_Vehicle_Spawn', {
	private _startTime = time;
	params[["_class",""],["_pos",[0,0,0]],["_id",-1],["_owner",objNull],["_doj",false],["_dmv",false],["_noKeys",false]];
	private _initfunction = !isNil ('Server_Vehicle_Init_' + _class);
	private _lightbarInit = Config_Lightbar_Vehs;
    private _slicktopInit = Config_Slicktop_Vehs;
	private _veh = ObjNull;
	private _job = _owner getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];

	if (typename _pos == 'Object') then {
		_hotFix = (getPosATL _pos);
		_hotFix set[2, (_hotFix#2)+0.75];
		_veh = createVehicle [_class, _hotFix, [], 0, 'CAN_COLLIDE'];
		_veh setDir (getDir _pos);
		_veh setPosATL _hotFix;
	} else {
		_veh = createVehicle [_class, _pos, [], 0, 'CAN_COLLIDE'];
	};
	if (isNull _veh) exitwith {diag_log "Server_Vehicle_Spawn Error: _veh isNull"};

	_veh setFuelCargo 0;
	_veh setVariable ["owner",[(_owner getVariable ["character_id",""]),_id],true];
	_veh setVariable ["locked",true,true];
	Server_Storage_ListVehicles pushback _veh;
	if ((toLowerANSI _id) IN [("STR_Common_Job_Waste" call A3PL_Localize),("STR_Common_Job_Deliver" call A3PL_Localize),("STR_Common_Job_Exterminator" call A3PL_Localize),("STR_Common_Vehicle_Plate_Karting" call A3PL_Localize),("STR_Common_Job_Roadworker" call A3PL_Localize),("STR_Common_Job_Captain" call A3PL_Localize),("STR_Common_Job_BetterBuy" call A3PL_Localize),("STR_Common_Job_Taxi" call A3PL_Localize)]) then {
		switch (_class) do {
			case ("A3PL_P362_Garbage_Truck"): {
				_veh setObjectTextureGlobal [0,"\A3PL_Textures\Peterbilt_Garbage_Truck\Waste_Management_Garbage_Truck.paa"];
				if(_pos isEqualTo [2119.36,5155.03,0.3]) then {_veh setDir 178.6;};
			};
			case ("A3PL_Mailtruck"):
			{
				if (_id isEqualTo ("STR_Common_Job_Exterminator" call A3PL_Localize)) then {
					_veh setObjectTextureGlobal [0,"\A3PL_Textures\MailTruck\Exterminator_Truck.paa"];
				};
				if (_id isEqualTo ("STR_Common_Job_Deliver" call A3PL_Localize)) then
				{
					private _setDir = switch{_pos} do {
						case [6056.77,7393.57,0]: {33.8471};
						case [3507.66,7541.57,0]: {96};
						case [10313.1,8556.05,0]: {271.516};
						case [4143.49,6317.9,0]: {91.5289};
						case [2213.505,11845.4,0]: {271.575};
						default {30};
					};
					_veh setDir(_setDir);
				};
			};
		};
		_owner setVariable ["jobVehicle",_veh,true];
	};
	if (_id isEqualTo ("STR_Common_Vehicle_Plate_Federal" call A3PL_Localize)) then {_veh setDir (getDir _owner)};
	if (_doj) then {
		_texture = switch (_class) do {
			case "A3FL_Taurus": {"\A3PL_Textures\Taurus\DOJ.paa"};
			case "A3FL_Tahoe": {"\A3PL_Textures\Tahoe18\DOJ.paa"};
			case "A3FL_Focus": {"\A3PL_Textures\Focus\DOJ.paa"};
			case "A3FL_Mustang15": {"\A3PL_Textures\Mustang15\DOJ.paa"};
		};
		_veh setObjectTextureGlobal [0,_texture];
		_owner setVariable ["dojVehicle",_veh,true];
		_veh setVariable ["dojVehicle",true,true];
		_veh setDir 305;
	};
	if (_class isEqualTo "A3PL_Lowloader") then {
		_veh setObjectTextureGlobal [0,"\A3PL_Textures\Lowloader\Hazard.paa"];
	};
	if ((_class isEqualTo "A3FL_AS_365") && (_job isEqualTo ("STR_Common_FIFR" call A3PL_Localize))) then {
		_veh setObjectTextureGlobal [0,"\A3PL_Textures\AS365\FIFR_Dolphin.paa"];
	};

	[_veh,_id] call Server_Vehicle_Init_General;

	if (_initfunction) then {_veh call (missionNamespace getVariable ('Server_Vehicle_Init_' + _class));};
	if (_class IN _lightbarInit) then {_veh call Server_Vehicle_Init_FactionCar;};
	if (_class IN _slicktopInit) then {_veh call Server_Vehicle_Siren_Init;};

	if ((typeOf _veh) IN A3PL_HitchingVehicles) then{_veh call Server_Vehicle_Init_A3PL_F150;};
	if(typeOf _veh IN ["A3PL_MiniExcavator","A3PL_Boat_Trailer","A3PL_Box_Trailer","A3PL_Lowloader","A3PL_Tanker_Trailer","A3PL_Drill_Trailer","A3PL_Small_Boat_Trailer","A3PL_Car_Trailer"]) then {
		_veh allowdamage false;
	};
	if (!(_noKeys isEqualTo true)) then {
		[_veh] remoteExec ["A3PL_Vehicle_AddKey",_owner];
	};
	_veh;
}] call compile_Server;

["Server_Vehicle_Despawn", {
	private _veh = param [0,objNull];
	private _attObjs = attachedObjects _veh;
	if (_attObjs isEqualTo []) then {
		deleteVehicle _veh;
	} else {
		{
			deleteVehicle _x;
		} forEach _attObjs;
		deleteVehicle _veh;
	};
}] call compile_Server;

["Server_Vehicle_Init_FactionCar",
{
	_this call Server_Vehicle_Siren_Init;
	private _light_1 = "A3PL_Floodlight_Level" createVehicle [0,0,0];
	private _light_2 = "A3PL_Floodlight_Level" createVehicle [0,0,0];
	_light_1 attachTo [_this, [0.03, 0, 0.8], "Floodlight_1"];
	_light_2 attachTo [_this, [-0.03, 0, 0.8], "Floodlight_2"];
	_light_2 setdir 180;
	_this animate ["Pushbar_Addon",1];
	_this animate ["Spotlight_Addon",1];
}] call compile_Server;

["Server_Vehicle_Siren_Init",
{
	private _veh = _this;
	private _classname = typeOf _veh;
	private _sirenType = "police";
	switch (true) do {
		case (_classname IN ["A3PL_Pierce_Rescue","A3PL_Pierce_Pumper","A3PL_Pierce_Ladder","A3PL_Pierce_Heavy_Ladder","A3FL_T440_Water_Tanker"]): {_sirenType = "fire";};
		case (_classname IN ["A3FL_F150_FD","A3PL_Silverado_FD_Brush","A3PL_Charger15_FD","A3FL_Taurus_FD","A3FL_Tahoe_FD","A3PL_Tahoe_FD","EC_F450_Brush","EC_Explorer19_FD","EC_Charger_Hellcat_20_FD","A3PL_CVPI_FD","EC_DodgeRam_FD"]): {_sirenType = "fire_FR";};
		case (_classname IN ["Jonzie_Ambulance","A3PL_E350","EC_E350_A","EC_F150_A"]): {_sirenType = "ems";};
	};
	switch (_sirenType) do {
		case "police": {
			private _SoundSource_1 = createSoundSource ["A3FL_FSUTD_1", [0,0,0], [], 0];
			_SoundSource_1 attachTo [_veh, [0,0,0], "SoundSource_1"];
			private _SoundSource_2 = createSoundSource ["A3FL_FSUTD_5", [0,0,0], [], 0];
			_SoundSource_2 attachTo [_veh, [0,0,0], "SoundSource_2"];
			private _SoundSource_3 = createSoundSource ["A3FL_Priority", [0,0,0], [], 0];
			_SoundSource_3 attachTo [_veh, [0,0,0], "SoundSource_3"];
			private _SoundSource_4 = createSoundSource ["A3FL_FSUTD_2", [0,0,0], [], 0];
			_SoundSource_4 attachTo [_veh, [0,0,0], "SoundSource_4"];
			private _SoundSource_5 = createSoundSource ["A3FL_FSUTD_3", [0,0,0], [], 0];
			_SoundSource_5 attachTo [_veh, [0,0,0], "SoundSource_5"];
			_Siren = [_SoundSource_1,_SoundSource_2,_SoundSource_3,_SoundSource_4,_SoundSource_5];
			_veh setVariable ["SoundSource",_Siren,true];
		};
		case "fire": {
			private _SoundSource_1 = createSoundSource ["A3PL_EQ2B_Wail", [0,0,0], [], 0];
			_SoundSource_1 attachTo [_veh, [0,0,0], "SoundSource_1"];
			private _SoundSource_2 = createSoundSource ["A3PL_Whelen_Warble", [0,0,0], [], 0];
			_SoundSource_2 attachTo [_veh, [0,0,0], "SoundSource_2"];
			private _SoundSource_3 = createSoundSource ["A3PL_AirHorn_1", [0,0,0], [], 0];
			_SoundSource_3 attachTo [_veh, [0,0,0], "SoundSource_3"];
			private _Siren = [_SoundSource_1,_SoundSource_2,_SoundSource_3];
			_veh setVariable ["SoundSource",_Siren,true];
		};
		case "fire_FR": {
			private _SoundSource_1 = createSoundSource ["A3PL_FSUO_Siren", [0,0,0], [], 0];
			_SoundSource_1 attachTo [_veh, [0,0,0], "SoundSource_1"];
			private _SoundSource_2 = createSoundSource ["A3PL_Whelen_Priority3", [0,0,0], [], 0];
			_SoundSource_2 attachTo [_veh, [0,0,0], "SoundSource_2"];
			private _SoundSource_3 = createSoundSource ["A3PL_FIPA20A_Priority", [0,0,0], [], 0];
			_SoundSource_3 attachTo [_veh, [0,0,0], "SoundSource_3"];
			private _SoundSource_4 = createSoundSource ["A3PL_Electric_Horn", [0,0,0], [], 0];
			_SoundSource_4 attachTo [_veh, [0,0,0], "SoundSource_4"];
			private _Siren = [_SoundSource_1,_SoundSource_2,_SoundSource_3,_SoundSource_4];
			_veh setVariable ["SoundSource",_Siren,true];
		};
		case "ems":
		{
			_SoundSource_1 = createSoundSource ["A3PL_Whelen_Siren", [0,0,0], [], 0];
			_SoundSource_1 attachTo [_veh, [0,0,0], "SoundSource_1"];
			_SoundSource_2 = createSoundSource ["A3PL_Whelen_Priority", [0,0,0], [], 0];
			_SoundSource_2 attachTo [_veh, [0,0,0], "SoundSource_2"];
			_SoundSource_3 = createSoundSource ["A3PL_Whelen_Priority2", [0,0,0], [], 0];
			_SoundSource_3 attachTo [_veh, [0,0,0], "SoundSource_3"];
			_SoundSource_4 = createSoundSource ["A3PL_Electric_Airhorn", [0,0,0], [], 0];
			_SoundSource_4 attachTo [_veh, [0,0,0], "SoundSource_4"];
			_SoundSource_5 = createSoundSource ["A3PL_Electric_Horn", [0,0,0], [], 0];
			_SoundSource_5 attachTo [_veh, [0,0,0], "SoundSource_5"];
			_Siren = [_SoundSource_1,_SoundSource_2,_SoundSource_3,_SoundSource_4,_SoundSource_5];
			_veh setVariable ["SoundSource",_Siren,true];
		};
	};
}] call compile_Server;

['Server_Vehicle_Init_A3PL_Jayhawk', {
	private _basket = "A3PL_RescueBasket" createVehicle [0,0,0];
	_basket allowdamage false;
	_basket setVariable ["locked",false,true];
	_basket attachTo [_this, [0,999999,0] ];
	_this setVariable ["basket",_basket,true];
	_basket setVariable ["vehicle",_this,true];
}] call compile_Server;

['Server_Vehicle_Init_A3PL_F150',
{
	_this addEventHandler ["GetIn",
	{
		params ["_veh","_pos","_unit"];
		if (_pos isNotEqualTo "driver") exitwith {};
		private _trailerArray = nearestObjects [(_veh modelToWorld [0,-4,0]), ["A3PL_Trailer_Base"], 6.5];
		if ((count _trailerArray) > 0) then {
			private _trailerArray = _trailerArray select 0;
			if (!((owner _trailerArray) isEqualTo (owner _unit))) then {
				_trailerArray setOwner (owner _unit);
			};
		};
	}];
}] call compile_Server;

['Server_Vehicle_Init_A3PL_Pierce_Pumper',
{
	_this call Server_Vehicle_Siren_Init;
	private _light_1 = "A3PL_Floodlight_Double" createVehicle [0,0,0];
	private _light_2 = "A3PL_Floodlight_Double" createVehicle [0,0,0];
	private _Rotator1 = "A3PL_Red_Rotator" createVehicle [0,0,0];
	private _Rotator2 = "A3PL_White_Rotator" createVehicle [0,0,0];
	private _Rotator3 = "A3PL_Red_Rotator_off" createVehicle [0,0,0];
	private _Rotator4 = "A3PL_White_Rotator_off" createVehicle [0,0,0];
	private _Rotator5 = "A3PL_Red_Rotator" createVehicle [0,0,0];
	private _Rotator6 = "A3PL_White_Rotator" createVehicle [0,0,0];
	private _Rotator7 = "A3PL_Red_Rotator_off" createVehicle [0,0,0];
	private _Rotator8 = "A3PL_White_Rotator_off" createVehicle [0,0,0];
	private _Rotator9 = "A3PL_Red_Rotator" createVehicle [0,0,0];
	private _Rotator10 = "A3PL_White_Rotator" createVehicle [0,0,0];
	private _Rotator11 = "A3PL_Red_Rotator_off" createVehicle [0,0,0];
	private _Flag = "A3PL_Mini_Flag_US" createVehicle [0,0,0];
	_light_1 attachTo [_this, [0, 0, 0.79], "Floodlight_1"];
	_light_2 attachTo [_this, [0, 0, 0.79], "Floodlight_2"];
	_Rotator1 attachTo [_this, [0, 0.44, 1.01], "Rotator_Light1"];
	_Rotator2 attachTo [_this, [0, -0.44, 1.01], "Rotator_Light2"];
	_Rotator3 attachTo [_this, [0, 0.44, 1.01], "Rotator_Light3"];
	_Rotator4 attachTo [_this, [0, -0.44, 1.01], "Rotator_Light4"];
	_Rotator5 attachTo [_this, [0, 0.44, 1.01], "Rotator_Light5"];
	_Rotator6 attachTo [_this, [0, -0.44, 1.01], "Rotator_Light6"];
	_Rotator7 attachTo [_this, [0, 0.44, 1.01], "Rotator_Light7"];
	_Rotator8 attachTo [_this, [0, -0.44, 1.01], "Rotator_Light8"];
	_Rotator9 attachTo [_this, [0, 0.44, 1.01], "Rotator_Light9"];
	_Rotator10 attachTo [_this, [0, -0.44, 1.01], "Rotator_Light10"];
	_Rotator11 attachTo [_this, [0, 0.44, 1.01], "Rotator_Light11"];
	_Flag attachTo [_this, [0.85, -4.59, -2.24]];
	_light_2 setdir 180;
	_Flag setFlagTexture "\A3\Data_F\Flags\Flag_us_CO.paa";
	[_this,"ENGINE"] call A3PL_FD_SetFireTruckNumber;
	_this setVariable ["water",0,true];
	_this setVariable ["pressure","low",true];
	_this animate ["Water_Gauge1",0];
}] call compile_Server;

['Server_Vehicle_Init_A3PL_Pierce_Rescue',
{
	_this call Server_Vehicle_Siren_Init;
	private _light_1 = "A3PL_RescueTruck_Light" createVehicle [0,0,0];
	private _light_3 = "A3PL_RescueTruck_Light" createVehicle [0,0,0];
	private _light_4 = "A3PL_RescueTruck_Light" createVehicle [0,0,0];
	private _light_6 = "A3PL_RescueTruck_Light" createVehicle [0,0,0];
	private _Rotator1 = "A3PL_Red_Rotator" createVehicle [0,0,0];
	private _Rotator2 = "A3PL_White_Rotator" createVehicle [0,0,0];
	private _Rotator3 = "A3PL_Red_Rotator_off" createVehicle [0,0,0];
	private _Rotator4 = "A3PL_White_Rotator_off" createVehicle [0,0,0];
	private _Rotator5 = "A3PL_Red_Rotator" createVehicle [0,0,0];
	private _Rotator6 = "A3PL_White_Rotator" createVehicle [0,0,0];
	private _Rotator7 = "A3PL_Red_Rotator_off" createVehicle [0,0,0];
	private _Rotator8 = "A3PL_White_Rotator_off" createVehicle [0,0,0];
	private _Rotator9 = "A3PL_Red_Rotator" createVehicle [0,0,0];
	private _Rotator10 = "A3PL_White_Rotator" createVehicle [0,0,0];
	private _Rotator11 = "A3PL_Red_Rotator_off" createVehicle [0,0,0];
	_Rotator1 attachTo [_this, [0, 0.44, 1.01], "Rotator_Light1"];
	_Rotator2 attachTo [_this, [0, -0.44, 1.01], "Rotator_Light2"];
	_Rotator3 attachTo [_this, [0, 0.44, 1.01], "Rotator_Light3"];
	_Rotator4 attachTo [_this, [0, -0.44, 1.01], "Rotator_Light4"];
	_Rotator5 attachTo [_this, [0, 0.44, 1.01], "Rotator_Light5"];
	_Rotator6 attachTo [_this, [0, -0.44, 1.01], "Rotator_Light6"];
	_Rotator7 attachTo [_this, [0, 0.44, 1.01], "Rotator_Light7"];
	_Rotator8 attachTo [_this, [0, -0.44, 1.01], "Rotator_Light8"];
	_Rotator9 attachTo [_this, [0, 0.44, 1.01], "Rotator_Light9"];
	_Rotator10 attachTo [_this, [0, -0.44, 1.01], "Rotator_Light10"];
	_Rotator11 attachTo [_this, [0, 0.44, 1.01], "Rotator_Light11"];
	_light_1 attachTo [_this, [0, 0, 0.35], "top_light_1"];
	_light_3 attachTo [_this, [0, 0, 0.35], "top_light_3"];
	_light_4 attachTo [_this, [0, 0, 0.35], "top_light_4"];
	_light_6 attachTo [_this, [0, 0, 0.35], "top_light_6"];
	[_this,"RESCUE"] call A3PL_FD_SetFireTruckNumber;
}] call compile_Server;

['Server_Vehicle_Init_A3FL_T440_Water_Tanker',
{
	_this call Server_Vehicle_Siren_Init;
	private _Rotator1 = "A3PL_Red_Rotator" createVehicle [0,0,0];
	private _Rotator2 = "A3PL_White_Rotator" createVehicle [0,0,0];
	private _Rotator3 = "A3PL_Red_Rotator_off" createVehicle [0,0,0];
	private _Rotator4 = "A3PL_White_Rotator_off" createVehicle [0,0,0];
	private _Rotator5 = "A3PL_Red_Rotator" createVehicle [0,0,0];
	private _Rotator6 = "A3PL_White_Rotator" createVehicle [0,0,0];
	private _Rotator7 = "A3PL_Red_Rotator_off" createVehicle [0,0,0];
	private _Rotator8 = "A3PL_White_Rotator_off" createVehicle [0,0,0];
	private _Rotator9 = "A3PL_Red_Rotator" createVehicle [0,0,0];
	private _Rotator10 = "A3PL_White_Rotator" createVehicle [0,0,0];
	private _Rotator11 = "A3PL_Red_Rotator_off" createVehicle [0,0,0];
	_Rotator1 attachTo [_this, [0, 0.44, 1.01], "Rotator_Light1"];
	_Rotator2 attachTo [_this, [0, -0.44, 1.01], "Rotator_Light2"];
	_Rotator3 attachTo [_this, [0, 0.44, 1.01], "Rotator_Light3"];
	_Rotator4 attachTo [_this, [0, -0.44, 1.01], "Rotator_Light4"];
	_Rotator5 attachTo [_this, [0, 0.44, 1.01], "Rotator_Light5"];
	_Rotator6 attachTo [_this, [0, -0.44, 1.01], "Rotator_Light6"];
	_Rotator7 attachTo [_this, [0, 0.44, 1.01], "Rotator_Light7"];
	_Rotator8 attachTo [_this, [0, -0.44, 1.01], "Rotator_Light8"];
	_Rotator9 attachTo [_this, [0, 0.44, 1.01], "Rotator_Light9"];
	_Rotator10 attachTo [_this, [0, -0.44, 1.01], "Rotator_Light10"];
	_Rotator11 attachTo [_this, [0, 0.44, 1.01], "Rotator_Light11"];
	_this setVariable ["water",0,true];
	_this animate ["Water_Gauge1",0];
	[_this,"TANKER"] call A3PL_FD_SetFireTruckNumber;
	_this setObjectTextureGlobal[8,"A3PL_Textures\Kenworth\FIFR_Tanker.paa"];
}] call compile_Server;

['Server_Vehicle_Init_A3PL_Pierce_Heavy_Ladder',{
	_this call Server_Vehicle_Siren_Init;
	private _light_1 = "A3PL_Floodlight_Double" createVehicle [0,0,0];
	private _light_2 = "A3PL_Floodlight_Double" createVehicle [0,0,0];
	private _light_3 = "A3PL_Floodlight_Double" createVehicle [0,0,0];
	private _light_4 = "A3PL_Floodlight_Double" createVehicle [0,0,0];
	private _Ladder = "A3PL_Rear_Ladder" createVehicle [0,0,0];
	private _Flag = "A3PL_Mini_Flag_US" createVehicle [0,0,0];
	_light_1 attachTo [_this, [0, 0, 0], "Floodlight_1"];
	_light_2 attachTo [_this, [0, 0, 0], "Floodlight_2"];
	_light_3 attachTo [_this, [0, 0, 0], "Floodlight_3"];
	_light_4 attachTo [_this, [0, 0, 0], "Floodlight_4"];
	_Ladder attachTo [_this, [0, -5.5, -1]];
	_Flag attachTo [_this, [-0.05, 0.39, -2.3], "Flag_Point"];
	_light_3 setdir 180;
	_light_4 setdir 180;
	_Flag setFlagTexture "\A3\Data_F\Flags\Flag_us_CO.paa";
	[_this,"LADDER"] call A3PL_FD_SetFireTruckNumber;
}] call compile_Server;

["Server_Vehicle_Init_A3PL_Silverado_FD_Brush",{
	_this call Server_Vehicle_Siren_Init;
	private _light_1 = "A3PL_Floodlight_Level" createVehicle [0,0,0];
	private _light_2 = "A3PL_Floodlight_Level" createVehicle [0,0,0];
	_light_1 attachTo [_this, [0.03, 0, 0.8], "Floodlight_1"];
	_light_2 attachTo [_this, [-0.03, 0, 0.8], "Floodlight_2"];
	_light_2 setdir 180;
	[_this,"BRUSH",6] call A3PL_FD_SetFireTruckNumber;
}] call compile_Server;

["Server_Vehicle_Init_EC_F450_Brush",{
    _this call Server_Vehicle_Siren_Init;
    private _light_1 = "A3PL_Floodlight_Level" createVehicle [0,0,0];
    private _light_2 = "A3PL_Floodlight_Level" createVehicle [0,0,0];
    _light_1 attachTo [_this, [0.03, 0, 0.8], "Floodlight_1"];
    _light_2 attachTo [_this, [-0.03, 0, 0.8], "Floodlight_2"];
    _light_2 setdir 180;
    [_this,"BRUSH",6] call A3PL_FD_SetFireTruckNumber;
}] call compile_Server;

['Server_Vehicle_Init_Jonzie_Ambulance',
{
	_this call Server_Vehicle_Siren_Init;
	private _light_1 = "A3PL_Floodlight" createVehicle [0,0,0];
	private _light_2 = "A3PL_Floodlight" createVehicle [0,0,0];
	private _light_3 = "A3PL_Floodlight" createVehicle [0,0,0];
	private _light_4 = "A3PL_Floodlight" createVehicle [0,0,0];
	private _light_5 = "A3PL_Floodlight" createVehicle [0,0,0];
	private _light_6 = "A3PL_Floodlight" createVehicle [0,0,0];
	private _light_7 = "A3PL_Interior_light" createVehicle [0,0,0];
	_light_1 attachTo [_this, [0.03, 0, 0.8], "Floodlight_1"];
	_light_2 attachTo [_this, [0.03, 0, 0.8], "Floodlight_2"];
	_light_3 attachTo [_this, [-0.03, 0, 0.8], "Floodlight_3"];
	_light_4 attachTo [_this, [-0.03, 0, 0.8], "Floodlight_4"];
	_light_5 attachTo [_this, [0, 0, 0.8], "Floodlight_5"];
	_light_6 attachTo [_this, [0, 0, 0.8], "Floodlight_6"];
	_light_7 attachTo [_this, [0, 0, 0], "Interior_Lights"];
	_light_3 setdir 180;
	_light_4 setdir 180;
	_light_5 setdir 270;
	_light_6 setdir 270;
	private _offsetA = [];
	private _type = typeof _this;
	switch (true) do 
	{
		case (_type isEqualTo "EC_E350_A"): {_offsetA = [0,-1.6,0.45];};
		case (_type isEqualTo "EC_F150_A"): {_offsetA = [-0.2,-1.6,0.4];};
		case (_type isEqualTo"Jonzie_Ambulance"): {_offsetA = [0,-1,0.6];};
		default {_offsetA = [0,0,0.35];};
	};
	private _stretcher = "A3FL_Stretcher" createVehicle [0,0,0];
	_stretcher animateSource["Legs",1,true];
	_stretcher attachTo[_this, _offsetA];
	_stretcher setVariable["locked",false,true];
	_stretcher setVariable["class","stretcher",true];
	_this setVariable["Stretcher",_stretcher,true];
}] call compile_Server;
['Server_Vehicle_Init_A3PL_E350',{_this call Server_Vehicle_Init_Jonzie_Ambulance;}] call compile_Server;
['Server_Vehicle_Init_EC_E350_A',{_this call Server_Vehicle_Init_Jonzie_Ambulance;}] call compile_Server;
['Server_Vehicle_Init_EC_F150_A',{_this call Server_Vehicle_Init_Jonzie_Ambulance;}] call compile_Server;

["Server_Vehicle_Init_C_Van_02_transport_F",
{
	_this setObjectTextureGlobal [1, "\a3\Soft_F_Orange\Van_02\Data\van_wheel_transport_co.paa"];
	_this setObjectTextureGlobal [2, "\a3\Soft_F_Orange\Van_02\Data\van_glass_civservice_ca.paa"];
}] call compile_Server;

["Server_Vehicle_Init_SetLicensePlate", {
    params ["_plate", "_vehicle"];
    private _extraVehicles = ["C_Van_02_transport_F"];
    
    if (typeOf _vehicle IN _extraVehicles) then {
        _vehicle setPlateNumber toUpperANSI(_plate);
    };
    
    for "_i" from 0 to (count _plate) - 1 do {
        private _char = _plate select [_i, 1];
        private _texturePath = format ["A3PL_Cars\Common\Number_Plates\%1.paa", _char];
        
        if (fileExists _texturePath) then {
            _vehicle setObjectTextureGlobal [_i + 1, _texturePath];
        };
    };
    
    if (_vehicle getVariable ["isFakePlate", false]) then {
        _vehicle setVariable ["isFakePlate", nil, true];
    };
}] call compile_Server;

["Server_Vehicle_Init_A3FL_Stretcher",{
	_this setVariable["locked",false,true];
	_this setVariable["class","stretcher",true];
}] call compile_Server;

["Server_Vehicle_Init_A3FL_Wheelchair",{
	_this setVariable["locked",false,true];
	_this setVariable["class","wheelchair",true];
}] call compile_Server;

['Server_Vehicle_Init_General', {
	params [["_veh",objNull,[objNull]],["_id","",[""]]];
	_veh lock 2;
	_veh addMPEventHandler ["MPKilled", {[_this select 0] spawn Server_Fire_VehicleExplode;}];
	_veh addEventHandler ["GetOut", {
		params ["_vehicle","_role"];
		if(_role isEqualTo "driver") then {[_vehicle] spawn Server_Fuel_Vehicle;};
	}];
	if (_veh isKindOf "LandVehicle") then {
		_veh animate ["Camo1",1];
		_veh animate ["Glass0_destruct",1];
		if (_id isNotEqualTo "") then {[_id,_veh] call Server_Vehicle_Init_SetLicensePlate;};
	};
}] call compile_Server;

["Server_Vehicle_TrailerDetach",
{
	private _boat = param [0,objNull];
	private _trailer = attachedTo _boat;
	if ((isNull _trailer) || {isNull _boat}) exitwith {};
	_boat allowDamage false;
	if (owner _trailer isEqualTo (owner _boat)) then {_boat setOwner (owner _trailer);};
	[_boat] spawn {
		private _boat = param [0,objNull];
		[_boat] remoteExec ["Server_Vehicle_EnableSimulation", 2];
		sleep 1.5;
		detach _boat;
		sleep 10;
		_boat allowDamage true;
	};
}] call compile_Server;

["Server_Vehicle_EnableSimulation",
{
	params [["_veh",objNull,[objNull]],["_force",false,[false]],["_forceEnable",false,[false]]];
	if (isNull _veh) exitwith {};
	if (_force) exitwith {_veh enableSimulationGlobal _forceEnable;};
	if (simulationEnabled _veh) then {
		_veh enableSimulationGlobal false;
	} else {
		_veh enableSimulationGlobal true;
	};
}] call compile_Server;

["Server_Vehicle_AtegoHandle",
{
	params [["_player",objNull,[objNull]],["_truck",objNull,[objNull]],["_car",objNull,[objNull]]];
	private _oTruck = owner _truck;
	private _oPlayer = owner _player;
	private _oCar = owner _car;
	if (_oTruck isNotEqualTo _oPlayer) then {_truck setOwner _oPlayer;};
	if (!isNull _car && {_oCar isNotEqualTo _oTruck}) then {_car setOwner _oPlayer;};
	[_truck,_car] remoteExec ["A3PL_Vehicle_AtegoTowResponse", _oPlayer];
}] call compile_Server;

["Server_Vehicle_Insure",
{
	params [["_vehID",""]];
	if(_vehId isEqualTo "") exitWith {};
	private _query = format ["UPDATE players_objects SET insurance = '1' WHERE id = '%1'",_vehID];
	[_query,1] spawn Server_Database_Async;
}] call compile_Server;

["Server_Vehicle_GPS",
{
	params [["_vehID",""]];
	if(_vehId isEqualTo "") exitWith {};
	private _query = format ["UPDATE players_objects SET gps = '1' WHERE id = '%1'",_vehID];
	[_query,1] spawn Server_Database_Async;
}] call compile_Server;

["Server_Vehicle_GetGPS",
{
	private _player = param [0,objNull];
	private _charID = (_player getVariable ["character_id",""]);
	private _query = format ["SELECT id FROM players_objects WHERE charid='%1' AND gps=1 AND plystorage=0",_charID];
	A3PL_GPS = [_query,2] call Server_Database_Async;
	(owner _player) publicVariableClient "A3PL_GPS";
}] call compile_Server;

["Server_Vehicle_SaveKeys",
{
	params [["_data",[]],["_charID",""]];
	if(_charID isEqualTo "") exitWith {};
	private _data = _data - [objNull];
	missionNamespace setVariable [format ["%1_KEYS",_charID],_data];
}] call compile_Server;

["Server_Vehicle_SetPaint",
{
	private _vehicle = param [0,objNull];
	private _texture = param [1,""];
	private _id = _vehicle getVariable ["owner",[]];
	if(count(_id) isEqualTo 0) exitWith {};
	if(_texture isEqualType []) then {_texture = [_texture] call Server_Database_Array;};
	_texture = [_texture, "\", "\\"] call CBA_fnc_replace;
	private _query = format ["UPDATE players_objects SET color = '%2' WHERE id = '%1'",_id select 1,_texture];
	[_query,1] spawn Server_Database_Async;
}] call compile_Server;

["Server_Vehicle_Save", {
	private _delete = param [0,false];
    {
        if (alive _x) then
        {
            _var = _x getVariable ["owner",[]];
            if((count _var) isNotEqualTo 0) then
            {
                diag_log format["Saving vehicle -%1- [%2:%3]", typeOf(_x), (_var#0), (_var#1)];

                private _charID = _var#0;
                private _id = _var#1;

                if (_id IN [("STR_Common_Job_Waste" call A3PL_Localize),("STR_Common_Job_Deliver" call A3PL_Localize),("STR_Common_Job_Exterminator" call A3PL_Localize),("STR_Common_Vehicle_Plate_Karting" call A3PL_Localize),("STR_Common_Job_Roadworker" call A3PL_Localize),("STR_Common_Job_Captain" call A3PL_Localize),("STR_Common_Job_BetterBuy" call A3PL_Localize),("STR_Common_Job_Taxi" call A3PL_Localize)]) exitwith {
                    diag_log format["Job Vehicle not saved -%1-", typeOf(_x)];
                };
                if (_id IN [("STR_Common_Vehicle_Plate_Federal" call A3PL_Localize)]) exitwith {
                    diag_log format["Admin Vehicle not saved -%1-", typeOf(_x)];
                };

                if(typeOf _x IN ["A3PL_MiniExcavator","A3PL_Boat_Trailer","A3PL_Box_Trailer","A3PL_Lowloader","A3PL_Tanker_Trailer","A3PL_Drill_Trailer","A3PL_Small_Boat_Trailer","A3PL_Car_Trailer"]) exitwith {
					diag_log format["Trailer Vehicle not saved -%1-", typeOf(_x)];
				};

				private _Path = (getObjectTextures _x)#0;
				private _material = (getObjectMaterials _x)#0;
				private _Pathformat = format ["%1",_Path];
				private _materialFormat = format ["%1",_material];
				if (isNil "_materialFormat") then {_materialFormat = ""};
				private _texture = [_Pathformat, "\", "\\"] call CBA_fnc_replace;
				private _materialLocation = [_materialFormat, "\", "\\"] call CBA_fnc_replace;
				
                private _cid = _x getVariable["cid",0];
                private _damage = [];
                if(count(getAllHitPointsDamage _x) isEqualTo 3) then {
                    _damage = [(getAllHitPointsDamage _x)#2] call Server_Database_Array;
                };
				private _gasType = _x getVariable ["gasType",("STR_Common_None" call A3PL_Localize)];
				private _gasAmount = _x getVariable ["gasAmount",0];
				private _gps = _x getVariable ["gps",0];

				private _vars = [];
				private _water = _x getVariable ["water",0];
				if (_water > 0) then {
					_vars pushBack ["water",_water];
				};
				private _stockobj = _x getVariable ["stockobj",nil];
				if (!isNil "_stockobj") then {
					_vars pushBack ["stockobj",_stockobj];
				};
				private _gasAmount = _x getVariable ["gasAmount",0];
				if (_gasAmount > 0) then {
					private _gasType = _x getVariable ["gasType",("STR_Common_None" call A3PL_Localize)];
					_vars pushBack ["gasType",_gasType];
					_vars pushBack ["gasAmount",_gasAmount];
				};
				private _gasAmount2 = _x getVariable ["gasAmount2",0];
				if (_gasAmount2 > 0) then {
					private _gasType2 = _x getVariable ["gasType2",("STR_Common_None" call A3PL_Localize)];
					_vars pushBack ["gasType2",_gasType2];
					_vars pushBack ["gasAmount2",_gasAmount2];
				};
				private _bItem = _x getVariable ["bitem",nil];
				if (!isNil "_bItem") then {
					_vars pushBack ["bitem",_bItem];
				};

                private _query = format ["UPDATE players_objects SET plystorage='0', spawn='1', impounded='0', pos='%4', dir='%5', fuel='%6', color='%7', material='%8', damage='%9', cid='%3', gasType='%10', gasAmount='%11', gps='%12', vars='%13' WHERE charid ='%1' AND id='%2'",
                    _charID,
                    _id,
                    _cid,
                    (getPosATL _x),
                    (getDir _x),
                    (fuel _x),
                    _texture,
                    _materialLocation,
                    _damage,
					_gasType,
					_gasAmount,
					_gps,
					[_vars] call Server_Database_Array
                ];
                [_query,1] spawn Server_Database_Async;

                [_x] call Server_Storage_VehicleVirtual;
                [_x] call Server_Storage_Vehicle;
				if (_delete) then {
					[_x] call Server_Vehicle_Despawn;
				};
            };
        };
    } forEach ((allMissionObjects "LandVehicle") + (allMissionObjects "Air") + (allMissionObjects "Ship"));
}] call compile_Server;

/*

        0       players_objects.id,
        1       players_objects.type,
        2       players_objects.class,
        3       players_objects.customName,
        4       players_objects.charid,
        5       players_objects.plystorage,
        6       players_objects.spawn,
        7       players_objects.pos,
        8       players_objects.dir,
        9       players_objects.vars,
        10      players_objects.impounded,
        11      players_objects.fuel,
        12      players_objects.color,
        13      players_objects.material,
        14      players_objects.stolen,
        15      players_objects.numpchange,
        16      players_objects.iscustomplate,
        17      players_objects.vstorage,
        18      players_objects.istorage,
        19      players_objects.tuning,
        20      players_objects.damage,
        21      players_objects.insurance,
        22      players_objects.cid,
		23 		players_objects.gasType,
		24 		players_objects.gasAmount,
		25		players_objects.gps
		26		players_objects.last_pos

*/
["Server_Vehicle_Load", {
    diag_log "------------------------------ [VEHICLES] Loading ------------------------------";

    {
		if((_x#2) IN ["A3PL_MiniExcavator","A3PL_Boat_Trailer","A3PL_Box_Trailer","A3PL_Lowloader","A3PL_Tanker_Trailer","A3PL_Drill_Trailer","A3PL_Small_Boat_Trailer","A3PL_Car_Trailer"]) then {
			[format["UPDATE players_objects SET spawn='0',plystorage='1',impounded='0',pos='[]',dir='[]' WHERE id='%1'", (_x#0)], 1] call Server_Database_Async;
			diag_log format["NOT LOADED/TO_GARAGE (TRAILERS AND EXCAVATOR) -%1- %2:%3", (_x#4), (_x#2), (_x#1)];
		};

        if ((_x#7) isEqualTo [] || (_x#8) isEqualTo []) then
        {
            diag_log format["CANNOT SPAWN/TO_GARAGE (NO POS OR DIR) -%1- %2:%3", (_x#4), (_x#2), (_x#1)];
            [format["UPDATE players_objects SET spawn='0',plystorage='1',impounded='0',pos='[]',dir='[]' WHERE id='%1'", (_x#0)], 1] call Server_Database_Async;
        } else {
			private _vehicle = [(_x#2),(call compile format ["%1", (_x#7)]),(_x#0),(_x#4),(call compile format ["%1", (_x#8)])] call Server_Vehicle_SpawnAfterLoad;
			if (isNil "_vehicle") then {continue;};
			diag_log format["LOADING VEHICLE -%1-", (_x#0)];
			
            _vehicle allowDamage false;
			_vehicle setPos (call compile format ["%1", (_x select 7)]);
            _vehicle setVariable ["cid",(_x#22),true];
			_vehicle setVariable ["gasType",(_x#23),true];
			_vehicle setVariable ["gasAmount",(_x#24),true];
			_vehicle setVariable ["gps",(_x#25),true];
			
			if (_x#9 isNotEqualTo []) then {
				_vars = [(_x#9)] call Server_Database_ToArray;
				{
					switch (_x#0) do {
						case "water" : {
							_vehicle setVariable ["water",(_x#1),true];
						};
						case "stockobj" : {
							_vehicle setVariable ["stockobj",(_x#1),true];
						};
						case "gasType" : {
							_vehicle setVariable ["gasType",(_x#1),true];
						};
						case "gasAmount" : {
							_vehicle setVariable ["gasAmount",(_x#1),true];
						};
						case "gasType2" : {
							_vehicle setVariable ["gasType2",(_x#1),true];
						};
						case "gasAmount2" : {
							_vehicle setVariable ["gasAmount2",(_x#1),true];
						};
						case "bitem" : {
							_vehicle setVariable ["bitem",(_x#1),true];
						};
					};
				} forEach _vars;
			};

            if(_x#11 < 0.1 && {_vehicle isKindOf "Ship"}) then {
                _vehicle setFuelCargo 0.1;
            } else {
                _vehicle setFuelCargo (_x#11);
            };

            _damage = [(_x#20)] call Server_Database_ToArray;
            if((count _damage) > 0) then {
                _parts = getAllHitPointsDamage _vehicle;
                for "_i" from 0 to ((count _damage) - 1) do {
                    _vehicle setHitPointDamage [format ["%1",((_parts#0)#_i)],_damage#_i];
                };
            };

            if((_x#12) != "<null>") then {
                _vehicle setObjectTextureGlobal [0,(_x#12)];
            };
            if((_x#13) != "<null>") then {
                _vehicle setObjectMaterialGlobal [0,(_x#13)];
            };

            _vehicle setVariable["numPChange",(_x#15),true];
            _vehicle setVariable["isCustomPlate",(_x#16),true];

            if((_x#21) isEqualTo 1) then {
                _vehicle setVariable["insurance",true,true];
            } else {
                _vehicle setVariable["insurance",false,true];
            };

            _iInventory = [(_x#18)] call Server_Database_ToArray;
            if ((count _iInventory) > 0) then {
                _items = _iInventory#0;
                _mags = _iInventory#1;
                _backpacks = _iInventory#2;
                _weapons = _iInventory#3;

                clearItemCargoGlobal _vehicle;
                clearMagazineCargo _vehicle;
                clearWeaponCargoGlobal _vehicle;
                clearBackpackCargoGlobal _vehicle;
                for "_i" from 0 to ((count (_items#0)) - 1) do {
                    _vehicle addItemCargoGlobal [((_items#0)#_i), ((_items#1)#_i)];
                };
                for "_i" from 0 to ((count (_mags#0)) - 1) do {
                    _vehicle addMagazineCargoGlobal [((_mags#0)#_i), ((_mags#1)#_i)];
                };
                for "_i" from 0 to ((count (_backpacks#0)) - 1) do {
                    _vehicle addBackpackCargoGlobal [((_backpacks#0)#_i), ((_backpacks#1)#_i)];
                };
                for "_i" from 0 to ((count (_weapons#0)) - 1) do {
                    _vehicle addWeaponCargoGlobal [((_weapons#0)#_i), ((_weapons#1)#_i)];
                };
            };

            _virtualInventory = [(_x#17)] call Server_Database_ToArray;
            _vehicle setVariable["storage",_virtualInventory,true];

            _addons = [(_x#19)] call Server_Database_ToArray;
            if ((count _addons) > 0) then {
                {
                    _animName = _x#0;
                    _animPhase = _x#1;
                    _vehicle animatesource [_animName, _animPhase, true];
                } foreach _addons;
            };

            [format["UPDATE players_objects SET plystorage='0',impounded='0' WHERE id='%1'", (_x#0)], 1] call Server_Database_Async;

            _vehicle allowDamage true;
			_vehicle enableSimulation true;

            if(typeOf _vehicle IN ["A3PL_MiniExcavator"]) then {
                _vehicle allowdamage false;
            };

			diag_log format["LOADED/TO_MAP -%1- %2:%3 (%4)", (_x#4), (_x#2), (_x#1), (_x#0)];
        };
    } forEach ((["SELECT id,type,class,customName,charid,plystorage,spawn,pos,dir,vars,impounded,fuel,color,material,stolen,numpchange,iscustomplate,vstorage,istorage,tuning,damage,insurance,cid,gasType,gasAmount,gps,last_pos FROM players_objects WHERE spawn='1' AND plystorage='0' AND impounded='0'",2,true] call Server_Database_Async));


    diag_log "------------------------------ [VEHICLES] Ready ------------------------------";
}] call compile_Server;

["Server_Vehicle_addKeysAfterLoad", {
    private _player = param [0,objNull];
    private _job = _player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
    private _policeCars = Config_FISD_Vehs + Config_FISD_Hel;
    private _fifrCars = Config_FIFR_Vehs + Config_FIFR_Hel;

    _vehicles = nearestObjects [player, ["LandVehicle","Air","Plane","Helicopter","Ship","Car"],20000];
    {
        _owner = _x getVariable ["owner",[]];
		if !(_owner isEqualType []) then {
			continue;
		};

        if ((_owner#0) isEqualTo (_player getVariable ["character_id",""])) then {
            diag_log format["Vehicle key added -%1- %2", (_owner#0), (_owner#1)];
            [_x] remoteExec ["A3PL_Vehicle_AddKey",_player];
        };
        if ((_job isEqualTo ("STR_Common_FISD" call A3PL_Localize)) && ((typeOf _x) IN _policeCars) && ((_owner#0) isNotEqualTo (_player getVariable ["character_id",""]))) then {
            diag_log format["FISD Vehicle key added -%1- %2", (_owner#0), (_owner#1)];
            [_x] remoteExec ["A3PL_Vehicle_AddKey",_player];
        };
        if ((_job isEqualTo ("STR_Common_FIFR" call A3PL_Localize)) && ((typeOf _x) IN _fifrCars) && ((_owner#0) isNotEqualTo (_player getVariable ["character_id",""]))) then {
            diag_log format["FIFR Vehicle key added -%1- %2", (_owner#0), (_owner#1)];
            [_x] remoteExec ["A3PL_Vehicle_AddKey",_player];
        };
    } forEach _vehicles;
}] call compile_Server;

['Server_Vehicle_SpawnAfterLoad', {
    params[["_class",""],["_pos",[0,0,0]],["_id",-1],["_owner",""],["_dir",[0,0,0]]];
    private _initfunction = !isNil ('Server_Vehicle_Init_' + _class);
    private _lightbarInit = Config_Lightbar_Vehs;
    private _slicktopInit = Config_Slicktop_Vehs;
    private _veh = objNull;
	if (_dir isEqualTo [] || _pos isEqualTo []) exitWith {
		diag_log "CANNOT SPAWN/SPAWNAFTERLOAD (NO POS OR DIR)";
        [format["UPDATE players_objects SET spawn='0',plystorage='1',impounded='0',pos='[]',dir='[]' WHERE id='%1'", _id], 1] call Server_Database_Async;
	};

    if (typename _pos == 'Object') then {
        _hotFix = (getPosATL _pos);
        _hotFix set[2, (_hotFix#2)+0.75];
        _veh = createVehicle [_class, _hotFix, [], 0, 'CAN_COLLIDE'];
        _veh setDir (getDir _pos);
        _veh setPosATL _hotFix;
    } else {
        _veh = createVehicle [_class, [12625.9,1713.92,0], [], 0, 'CAN_COLLIDE'];
		_veh enableSimulation false;
		_veh setDir _dir;
    };
    if (isNull _veh) exitwith {diag_log "Server_Vehicle_SpawnAfterLoad Error: _veh isNull"; objNull;};

    _veh setFuelCargo 0;
    _veh setVariable ["owner",[(_owner),_id],true];
    _veh setVariable ["locked",true,true];
    Server_Storage_ListVehicles pushback _veh;

    [_veh,_id] call Server_Vehicle_Init_General;

    if (_initfunction) then {_veh call (missionNamespace getVariable ('Server_Vehicle_Init_' + _class));};
    if (_class IN _lightbarInit) then {_veh call Server_Vehicle_Init_FactionCar;};
    if (_class IN _slicktopInit) then {_veh call Server_Vehicle_Siren_Init;};

    if ((typeOf _veh) IN A3PL_HitchingVehicles) then{_veh call Server_Vehicle_Init_A3PL_F150;};
    _veh;
}] call compile_Server;

["Server_Vehicle_SetHitPointDamage", {
	params [
		["_vehicle", objNull, [objNull]],
		["_hitPoint", "", [""]],
		["_damage", 0, [0]]
	];

	if (isNull _vehicle) exitWith {};
	if (_hitPoint isEqualTo "") exitWith {};

	_vehicle setHitPointDamage [_hitPoint, _damage];
}] call compile_Server;
