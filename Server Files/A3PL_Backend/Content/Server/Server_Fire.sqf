/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["Server_Fire_PauseFire", {
	if (Server_FireLooping) then {
		Server_FireLooping = false;
	} else {
		Server_FireLooping = true;
	};
	publicVariable "Server_FireLooping";
}] call compile_Server;

["Server_Fire_Destroy", {
	params [["_fireobject",objNull,[objNull]]];

	{deleteVehicle _x;} foreach (_fireobject nearEntities [Config_Placeables,4]);
	{ _x hideObjectGlobal true; } foreach nearestTerrainObjects [_fireobject,["TREE", "SMALL TREE", "BUSH","FOREST"],4];
	{
		_x setDamage 1;
		_x setVariable["burnt",true,true];
	} foreach (nearestObjects [_fireobject, ["Land_Fence1_DED_Fence_01_F","Land_Fence2_DED_Fence_02_F","Land_A3FL_Fence_Wood4_1m","Land_A3FL_Fence_Wood4_4m","Land_A3FL_Fence_Wood2_1m","Land_A3FL_Fence_Wood2_4m","Land_A3FL_Fence_Wood_Doorway2_4m","Land_A3FL_Fence_Wood_Doorway4_2m"],2]);
}] call compile_Server;

["Server_Fire_StartFire", {
	params[
		["_position",[],[[]]],
		["_dir",windDir,[1]],
		["_posBypass",false,[false]]
	];

	if (count _position < 3) exitwith {};
	private _onWater = !(_position isFlatEmpty [-1, -1, -1, -1, 2, false] isEqualTo []);
	if(_onWater) exitWith {};
	if (!_posBypass) then {_position = [_position#0, _position#1, 0];};
	private _fireobject = createVehicle ["A3PL_FireObject",_position, [], 0, "CAN_COLLIDE"];
	_fireobject addEventhandler ["HandleDamage",{[param [0,objNull],param [4,""],param [6,objNull]] spawn Server_Fire_HandleDamage;}];
	_fireObject setDir _dir;
	[_fireObject] call Server_Fire_AddFireParticles;
	Server_TerrainFires pushBack [_fireObject];
	[_fireobject] call Server_Fire_Destroy;
	_fireobject;
}] call compile_Server;

["Server_Fire_AddFireParticles", {
	params [["_fireobject",objNull,[objNull]]];

	if (isNull _fireObject) exitwith {};

	private _fireChance = random [-10, 40, 100];
	private _fireType = switch(true) do {
		case (_fireChance < 10): {["SmallFireBarrel",[]]};
		case (_fireChance > 60 && {_fireChance < 75}): {["AirObjectDestructionFire",["BigDestructionSmoke"]]};
		case (_fireChance >= 75 && {_fireChance < 85}): {["ObjectDestructionFire1Smallx",["BigDestructionSmoke","HouseDestrSmokeLongSmall"]]};
		case (_fireChance >= 85): {["BigDestructionFire",["BigDestructionSmoke","HouseDestrSmokeLongSmall"]]};
		default {["MediumDestructionFire",["MediumDestructionSmoke"]]};
	};

	private _fireParticles = createVehicle ["#particleSource", getposATL _fireObject, [], 0, "CAN_COLLIDE"];
	_fireParticles setParticleClass (_fireType#0);
	_fireParticles attachTo [_fireObject,[0,0,0]];
	_fireObject setVariable["fireType",_fireType#0,true];

	private _smokeChance = random 100;
	if(_smokeChance < 10 && {_fireType#1 isNotEqualTo []}) then {
		private _smokeType = selectRandom (_fireType#1);
		private _smokeParticles = createVehicle ["#particleSource", getposATL _fireObject, [], 0, "CAN_COLLIDE"];
		_smokeParticles setParticleClass _smokeType;
		_smokeParticles attachTo [_fireObject,[0,0,0]];
	};
}] call compile_Server;

["Server_Fire_Killed", {
	params [["_fireobject",objNull,[objNull]]];

	{
		deleteVehicle _x;
	} foreach (attachedObjects _fireObject);

	{
		_loopIndex = _forEachIndex;
		_fireArray = _x;
		{
			if (_fireObject == _x) exitwith {
				if (count _fireArray < 2) then {
					Server_TerrainFires deleteAt _loopIndex;
				} else {
					Server_TerrainFires set [_loopIndex,_fireArray-[_x]];
				};
			};
		} foreach _x;
	} foreach Server_TerrainFires;
	deleteVehicle _fireObject;
}] call compile_Server;

["Server_Fire_HandleDamage", {
	params [
		["_fireobject",objNull,[objNull]],
		["_projectile","",[""]],
		["_instig",objNull,[objNull]]
	];

	private _dmg = 0;
	if (_projectile IN ["A3PL_Extinguisher_Water_Ball","A3PL_High_Pressure_Water_Ball","A3PL_Medium_Pressure_Water_Ball","A3PL_Low_Pressure_Water_Ball","A3PL_High_Pressure_Foam_Ball","A3PL_Medium_Pressure_Foam_Ball","A3PL_Low_Pressure_Foam_Ball"]) then
	{
		switch(_projectile) do {
			case("A3PL_Extinguisher_Water_Ball"): {_dmg = 0.1;};
			case("A3PL_High_Pressure_Water_Ball"): {_dmg = 0.3;};
			case("A3PL_Medium_Pressure_Water_Ball"): {_dmg = 0.15;};
			case("A3PL_Low_Pressure_Water_Ball"): {_dmg = 0.1;};
			case("A3PL_High_Pressure_Foam_Ball"): {_dmg = 0.4;};
			case("A3PL_Medium_Pressure_Foam_Ball"): {_dmg = 0.25;};
			case("A3PL_Low_Pressure_Foam_Ball"): {_dmg = 0.2;};
		};
		_newDmg = (_fireObject getVariable ["dmg",0]) + _dmg;
		if (_newDmg >= 1) then
		{
			[_fireObject] call Server_Fire_Killed;
		} else {
			_fireObject setVariable ["dmg",_newDmg,false];
		};
	};
	_dmg = 0;
	_dmg;
}] call compile_Server;

["Server_Fire_RemoveFires", {
	{
		{
			{
				deleteVehicle _x;
			} foreach attachedObjects _x;
			deleteVehicle _x;
		} foreach _x;
	} foreach (missionNameSpace getVariable ["Server_TerrainFires",[]]);
	Server_TerrainFires = [];
}] call compile_Server;

["Server_Fire_FireLoop", {
	if(Server_TerrainFires isEqualTo []) exitWith {};
	if (!Server_FireLooping) exitWith {};
	private _fifr = count([("STR_Common_FIFR" call A3PL_Localize)] call A3PL_Lib_FactionPlayers);
	{
		private _loopIndex = _forEachIndex;
		private _fireArray = _x;
		private _spreadArray = [];

		if ((count _fireArray) > 0) then {_spreadArray pushback (_fireArray select (count _fireArray - 1));};
		if (((count _fireArray) > 1) && {_fifr > 3}) then {_spreadArray pushback (_fireArray select (count _fireArray - 2));}; 
		if (((count _fireArray) > 4) && {_fifr > 5}) then {_spreadArray pushback (_fireArray select (count _fireArray - 3));}; 
		if (((count _fireArray) > 6) && {_fifr > 7}) then {_spreadArray pushback (_fireArray select (count _fireArray - 4));}; 
		{
			private _latestFire = _x;
			private _fireType = _latestFire getVariable["fireType","MediumDestructionFire"];
			private _newDir = random [1,windDir,359];
			private _dist = switch(_fireType) do {
				case "ObjectDestructionFire1Smallx": {random [5,7,8]};
				case "AirObjectDestructionFire": {random [2,4,5]};
				case "BigDestructionFire": {random [5,7,8]};
				case "MediumDestructionFire": {random [2,4,5]};
				default {random [2,4,5]};
			};
			private _position = [_latestFire, _dist, _newDir] call BIS_fnc_relPos;
			private _correctSurface = (surfaceType _position) IN ["#cype_grass","#cype_forest","#cype_plowedfield","#GdtDirt"];
			private _maxFires = _fifr * 15;
			private _nearFireCount = count (_position nearEntities [["A3PL_Fireobject"],150]);

			if (_correctSurface && (!isOnRoad _position) && (_nearFireCount <= _maxFires)) then
			{
				private _fireObject = createVehicle ["A3PL_Fireobject", _position, [], 0, "CAN_COLLIDE"];
				_fireObject addEventhandler ["HandleDamage",{[param [0,objNull],param [4,""],param [6,objNull]] call Server_Fire_HandleDamage;}];
				_fireObject setDir _newDir;
				[_fireObject] call Server_Fire_AddFireParticles;

				_fireArray pushback _fireObject;
				Server_TerrainFires set [_loopIndex,_fireArray];
				[_fireObject] call Server_Fire_Destroy;
			};
		} foreach _spreadArray;
	} foreach Server_TerrainFires;
}] call compile_Server;

["Server_Fire_VehicleExplode", {
	if (!isDedicated) exitWith {};
	private _veh = param [0,objNull];
	private _var = _veh getVariable ["owner",[]];

	_exploded = _veh getVariable["exploded",false];
	if(_exploded) exitWith {};
	_veh setVariable["exploded",true,true];

	[_veh] call A3PL_Vehicle_SoundSourceClear;
	_sirenObj = _veh getVariable ["sirenObj",objNull];
	if (!isNull _sirenObj) then {deleteVehicle _sirenObj;};
	_stockobj = _veh getVariable ["stockobj",nil];
	_plate = _veh getVariable ["owner",[]];

	if((count _var) > 0) then {
		private _id = _var select 1;
		private _charID = _var select 0;
		private _player = [_charID] call A3PL_Lib_charIDToObject;
		private _UID = ([format["SELECT uid FROM players WHERE charid='%1'",_charID],2] call Server_Database_Async)#0;
		[_veh,false] remoteExec ["A3PL_Vehicle_AddKey",_player];

		private _isGPS = _veh getVariable ["gps",false];
		if(_isGPS isEqualTo true) then {
			{
				deleteMarkerLocal _x;
			} forEach A3PL_PlayerGPS_Markers;
		};

		private _isInsured = _veh getVariable ["insurance",false];
		//if((typeOf _veh) IN ["A3PL_MiniExcavator","A3PL_Car_Trailer","A3PL_Lowloader","A3PL_Small_Boat_Trailer","A3PL_Drill_Trailer","A3PL_Tanker_Trailer","A3PL_Box_Trailer"]) then {_isInsured = true;};
		if(_isInsured) then {
			[_veh] call Server_Storage_VehicleVirtual;
			private _query = format ["UPDATE players_objects SET plystorage = '1',spawn='0',pos='[]',dir='[]',impounded='0' WHERE id = '%1'",_id];
			[_query,1] spawn Server_Database_Async;
			diag_log format["VEHICLE EXPLOSED - %1 - GO TO GARAGE WITH INSURANCE", _id];
		} else {
			if !(isNil "_stockobj") then {
				private _vehicles = [format ["SELECT vehicles FROM stock WHERE classname='%1'",_stockobj], 2,true] call Server_Database_Async;
				_vehicles = _vehicles#0#0;
				private _vehicle = "";
				private _index = -1;
				{
					_index = _index + 1;
					private _vars = _x#6;
					private _selplate = "";
					{
						if (_x#0 isEqualTo "plate") then {
							_selplate = _x#1;
						};
						if (_x#0 IN ["inv","vinv"]) then {
							_x set [1, []];
						};
					} forEach _vars;

					if (_selplate isEqualTo _plate#1) exitWith {
						_vehicle = _x;
					};
				} forEach _vehicles;

				_vehicle set [1,1];
				_vehicles set [_index,_vehicle];

				[_veh] call Server_Vehicle_Sell;
				["vehicles",_vehicles,_stockobj] call Server_Stock_UpdateItems;
				diag_log format["VEHICLE EXPLOSED - %1 - GO TO STOCK", _id];
			} else {
				private _query = format ["UPDATE players_objects SET istorage = '[]', vstorage = '[]', impounded='1', spawn='0', plystorage='1', gps='0',pos='[]',dir='[]' WHERE id = '%1'",_id];
				[_query,1] spawn Server_Database_Async;
				diag_log format["VEHICLE EXPLOSED - %1 - GO TO IMPOUND WITHOUT INSURANCE", _id];
			};
		};

		[_UID,_charID,"Vehicle_Explode",[format ["Vehicle: %1 | Plate: %2 | Insured: %3",typeOf _veh,_id,_isInsured]]] call Server_Log_New;
	};

	private _fifr = [("STR_Common_FIFR" call A3PL_Localize)] call A3PL_Lib_FactionPlayers;
	private _fires = count(_veh nearEntities [["A3PL_Fireobject"], 10]);
	if (((count(_fifr)) >= 5) && {_fires isEqualTo 0}) then {
		private _marker = createMarker [format ["vehiclefire_%1",random 4000], position (_veh)];
		_marker setMarkerShape "ICON";
		_marker setMarkerType "A3FL_Markers_Fire";
		_marker setMarkerText "INCENDIE";
		_marker setMarkerColor "Default";
		[("STR_Common_FIFR" call A3PL_Localize),"Véhicule incendié",getPos _veh,"Un véhicule a été déclaré en feu",("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
		["A3PL_Common\effects\firecall.ogg",150,2,10] spawn A3PL_FD_FireStationAlarm;
		[getposATL (_veh)] spawn Server_Fire_StartFire;
		sleep 230;
		deleteMarker _marker;
	};
}] call compile_Server;

['Server_FD_SwitchClinic', {
	if (A3PL_FD_Clinic) then {
		A3PL_FD_Clinic = false;
	} else {
		A3PL_FD_Clinic = true;
	};
	publicVariable "A3PL_FD_Clinic";
}] call compile_Server;
