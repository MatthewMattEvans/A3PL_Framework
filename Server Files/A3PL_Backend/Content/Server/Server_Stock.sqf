/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["Server_Stock_Info",{
	private _mode = param [0,""];
	private _player = param [1,objNull];
	private _obj = param [2,objNull];

	private _result = [format ["SELECT type, service, items, vehicles FROM stock WHERE classname='%1'",_obj], 2,true] call Server_Database_Async;
	private _type = _result#0#0;
	private _service = _result#0#1;
	private _items = _result#0#2;
	private _vehicles = _result#0#3;

	private _pservice = toLower (_player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]);
	private _faction = false;
	private _ranks = [];

	switch (true) do {
		case(_pservice isEqualTo ("STR_Common_Company" call A3PL_Localize)): {
			_pservice = [(_player getVariable ["character_id",""])] call A3PL_Config_GetCompanyID;
		};
		case(_pservice IN [("STR_Common_FIFR" call A3PL_Localize),("STR_Common_FISD" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]): {
			_faction = true;
		};
		default {
			_pservice = "Civil";
		};
	};

	private _exit = false;
	if (_faction) then {
		if (_pservice isNotEqualTo _service) exitWith {_exit = true;};
		private _allRanks = missionNameSpace getVariable ["Server_Government_FactionRanks",[]];
		{
			if (_x#0 isEqualTo _pservice) exitwith {_ranks = _x#1;};
		} foreach _allRanks;
	} else {
		if ((str (_pservice)) isNotEqualTo _service) exitWith {_exit = true;};
		_ranks = [_pservice, "ranks"] call A3PL_Config_GetCompanyData;
	};

	if (_exit) exitWith {};

	if (_mode isEqualTo 0) then {
		if (_type isEqualTo "vehicles") then {
			[_type,_service,_vehicles,_ranks,_obj] remoteExec ["A3PL_Stock_Man_OpenReceive", (owner _player)];
		} else {
			[_type,_service,_items,_ranks,_obj] remoteExec ["A3PL_Stock_Man_OpenReceive", (owner _player)];
		};
	} else {
		if (_type isEqualTo "vehicles") then {
			[_type,_service,_vehicles,_obj] remoteExec ["A3PL_Stock_View_OpenReceive", (owner _player)];
		} else {
			[_type,_service,_items,_obj] remoteExec ["A3PL_Stock_View_OpenReceive", (owner _player)];
		};
	};
}] call compile_Server;

["Server_Stock_UpdateItems",{
	private _stocktype = param [0,"items"];
	private _items = param [1,[]];
	private _obj = param [2,objNull];

	private _query = "";

	if (_stocktype isEqualTo "items") then {
		_query = format ["UPDATE stock SET items='%1' WHERE classname='%2'", _items, _obj];
		[_query,1] spawn Server_Database_Async;
	} else {
		_query = format ["UPDATE stock SET vehicles='%1' WHERE classname='%2'", _items, _obj];
		[_query,1] spawn Server_Database_Async;
	};
}] call compile_Server;

["Server_Stock_InsertLog",{
	private _shop = param [0,objNull];
	private _player = param [1,objNull];
	private _object = param [2,""];
	private _amount = param [3,0];
	private _type = param [4,"item"];
	private _plate = param [5,""];
	
	if (_plate isEqualTo "") then {
		[format ["INSERT INTO logs_stock (classname, player, object, amount, type) VALUES ('%1','%2','%3','%4','%5')",_shop,_player,_object,_amount,_type],1] spawn Server_Database_Async;
	} else {
		[format ["INSERT INTO logs_stock (classname, player, object, amount, type, plate) VALUES ('%1','%2','%3','%4','%5','%6')",_shop,_player,_object,_amount,_type,_plate],1] spawn Server_Database_Async;
	};
}] call compile_Server;

["Server_Stock_GetLogs",{
	private _shop = param [0,objNull];
	private _player = param [1,objNull];
	private _plate = param [2,false];

	private _result = "";
	
	if (_plate) then {
		_result = [format ["SELECT classname, player, object, amount, type, plate, time FROM logs_stock WHERE classname='%1'",_shop], 2,true] call Server_Database_Async;
	} else {
		_result = [format ["SELECT classname, player, object, amount, type, time FROM logs_stock WHERE classname='%1'",_shop], 2,true] call Server_Database_Async;
	};
	
	A3PL_LogsResponse = _result;
	A3PL_Responded = true;
	(owner _player) publicVariableClient "A3PL_Responded";
	(owner _player) publicVariableClient "A3PL_LogsResponse";
}] call compile_Server;

["Server_Stock_VehicleWithdraw",{
	private _player = param [0,objNull];
	if (isNull _player) exitwith {diag_log "Error in Server_Vehicle_Buy: _player is Null"};
	private _charID = (_player getVariable ["character_id",""]);
	private _class = param [1,""];
	private _type = param [2,"vehicle"];
	private _id = param [3,("STR_Common_Vehicle_Plate_Federal" call A3PL_Localize)];
	private _color = param [4,""];
	if(_color isEqualTo "") then {_color = "#(argb,8,8,3)color(0,0,0,1.0,CO)";};
	private _material = param [5,""];
	private _vstorage = param [6,[]];
	private _istorage = param [7,[]];
	private _fuel = param [8,0];
	private _damage = param [9,0];
	private _mode = param [10,0];
	private _addons = param [11,[]];
	private _water = param [12,0];
	private _gasType = param [13,("STR_Common_None" call A3PL_Localize)];
	private _gasAmount = param [14,0];
	private _pos = param [15,[0,0,0]];
	private _dir = param [16,0];
	private _stockobj = param [17,objNull];
	private _gasType2 = param [18,("STR_Common_None" call A3PL_Localize)];
	private _gasAmount2 = param [19,0];
	private _vars = [];
	private _capacity = 0;

	private _finalColor = [_color, "?antislash?", "\\"] call CBA_fnc_replace;
	private _finalMaterial = [_material, "?antislash?", "\\"] call CBA_fnc_replace;

	_color = [_color, "?antislash?", "\"] call CBA_fnc_replace;
	_material = [_material, "?antislash?", "\"] call CBA_fnc_replace;

	switch (true) do {
		case (_water > 0): {
			_vars pushBack ["water",_water];
		};
		case (_gasAmount > 0): {
			_vars pushBack ["gasType",_gasType];
			_vars pushBack ["gasAmount",_gasAmount];
		};
	};
	if (_gasAmount2 > 0) then {
		_vars pushBack ["gasType2",_gasType2];
		_vars pushBack ["gasAmount2",_gasAmount2];
	};

	if (_mode isEqualTo 0) then {
		if (_class IN ["A3FL_LCM","A3PL_RHIB","A3PL_Motorboat","A3PL_Yacht","C_Scooter_Transport_01_F","A3PL_RBM"]) exitWith {};
		_vars pushBack ["stockobj",_stockobj];
		
		private _query = format ["INSERT INTO players_objects (id,type,class,charid,plystorage,color,material,vstorage,istorage,fuel,damage,tuning,vars,spawn,pos,dir) VALUES ('%1','%2','%3','%4','%13','%5','%6','%7','%8','%9','%10','%11','%12','1','%14','%15')",
			_id,
			_type,
			_class,
			_charID,
			_finalColor,
			_finalMaterial,
			[_vstorage] call Server_Database_Array,
			[_istorage] call Server_Database_Array,
			_fuel,
			[_damage] call Server_Database_Array,
			[_addons] call Server_Database_Array,
			[_vars] call Server_Database_Array,
			_mode,
			[_pos] call Server_Database_Array,
			_dir
		];
		[_query,1] spawn Server_Database_Async;
		
		switch (_class) do {
			case "A3FL_T440_Tow_Truck": { _pos = [_pos#0 - (3.5 * sin _dir), _pos#1 - (3.5 * cos _dir), (_pos#2) + 0.7]; };
			case "A3FL_T440_Gas_Tanker": { _pos = [_pos#0 - (3.5 * sin _dir), _pos#1 - (3.5 * cos _dir), (_pos#2) + 0.7]; };
			case "A3PL_Pierce_Heavy_Ladder": { _pos = [_pos#0 - (2.4 * sin _dir), _pos#1 - (2.4 * cos _dir), (_pos#2) + 0.7]; };
			case "A3PL_Lowloader": { _pos = [_pos#0 + (0.2 * sin _dir), _pos#1 + (0.2 * cos _dir), (_pos#2) + 0.7]; };
			case "A3FL_AS_365": { _pos = [_pos#0, _pos#1, (_pos#2) + 0.2]; };
			case "Heli_Medium01_Medic_H": { _pos = [_pos#0, _pos#1, (_pos#2) + 0.2]; };
			default { _pos = [_pos#0,_pos#1,(_pos#2) + 0.7]; };
		};
		
		_veh = [_class,[12626.2,1710,0.5],_id,_player] call Server_Vehicle_Spawn;
		_veh setDir _dir;
		_veh setPosATL _pos;
		sleep 0.1;
		[_veh,_player] remoteExec ["A3PL_Lib_ChangeLocality", 2];

		_veh setFuel _fuel;

		if((count _damage) > 0) then {
			_parts = getAllHitPointsDamage _veh;
			for "_i" from 0 to ((count _damage) - 1) do {
				_veh setHitPointDamage [format ["%1",((_parts select 0) select _i)],_damage select _i];
			};
		};

		if(_color != "<null>") then {
			_veh setObjectTextureGlobal [0,_color];
		};
		if(_material != "<null>") then {
			_veh setObjectMaterialGlobal [0,_material];
		};

		_veh setVariable["storage",_vstorage,true];
		
		if ((count _istorage) > 0) then {
			private _items = _istorage#0;
			private _mags = _istorage#1;
			private _backpacks = _istorage#2;
			private _weapons = _istorage#3;

			clearItemCargoGlobal _veh;
			clearMagazineCargo _veh;
			clearWeaponCargoGlobal _veh;
			clearBackpackCargoGlobal _veh;
			for "_i" from 0 to ((count (_items#0)) - 1) do {
				_veh addItemCargoGlobal [((_items#0)#_i), ((_items#1)#_i)];
			};
			for "_i" from 0 to ((count (_mags#0)) - 1) do {
				_veh addMagazineCargoGlobal [((_mags#0)#_i), ((_mags#1)#_i)];
			};
			for "_i" from 0 to ((count (_backpacks#0)) - 1) do {
				_veh addBackpackCargoGlobal [((_backpacks#0)#_i), ((_backpacks#1)#_i)];
			};
			for "_i" from 0 to ((count (_weapons#0)) - 1) do {
				_veh addWeaponCargoGlobal [((_weapons#0)#_i), ((_weapons#1)#_i)];
			};
		};

		if ((count _addons) > 0) then {
			{
				_animName = _x select 0;
				_animPhase = _x select 1;
				_veh animatesource [_animName, _animPhase, true];
			} foreach _addons;
		};

		if (_water > 0) then {
			_capacity = switch (_class) do {
				case ("A3PL_Pierce_Pumper"): { 1800 };
				case ("A3PL_Silverado_FD_Brush"): { 800 };
				case ("EC_F450_Brush"): { 800 };
				case ("A3FL_T440_Water_Tanker"): { 5000 };
				case ("A3PL_Pierce_Heavy_Ladder"): { 1200 };
				default { 1800 };
			};
			_veh animate ["Water_Gauge1",_water / _capacity];
			_veh setVariable ["water",_water,true];
		};

		if (_gasAmount > 0) then {
			_veh setVariable ["gasType",_gasType,true];
			_veh setVariable ["gasAmount",_gasAmount,true];
		};
		if (_gasAmount2 > 0) then {
			_veh setVariable ["gasType2",_gasType2,true];
			_veh setVariable ["gasAmount2",_gasAmount2,true];
		};

		_veh setVariable ["stockobj",_stockobj,true];
	} else {
		private _query = format ["INSERT INTO players_objects (id,type,class,charid,plystorage,color,material,vstorage,istorage,fuel,damage,tuning,vars) VALUES ('%1','%2','%3','%4','%13','%5','%6','%7','%8','%9','%10','%11','%12')",
			_id,
			_type,
			_class,
			_charID,
			_finalColor,
			_finalMaterial,
			[_vstorage] call Server_Database_Array,
			[_istorage] call Server_Database_Array,
			_fuel,
			[_damage] call Server_Database_Array,
			[_addons] call Server_Database_Array,
			[_vars] call Server_Database_Array,
			_mode
		];
		[_query,1] spawn Server_Database_Async;
	};
}] call compile_Server;

/*
	Server_Stock_ReturnVehicles
	Remet tous les vehicules avec une variable stockobj dans leur stock respectif
	Appele avant un redemarrage serveur
*/
["Server_Stock_ReturnVehicles", {
	private _delete = param [0, true];
	diag_log "------------------------------ [STOCK] Returning Stock Vehicles ------------------------------";

	private _stockGroups = createHashMap;

	{
		if (alive _x) then {
			private _stockobjRaw = _x getVariable ["stockobj", nil];

			if (!isNil "_stockobjRaw") then {
				private _stockobj = if (_stockobjRaw isEqualType "") then { _stockobjRaw } else { str _stockobjRaw };
				private _owner = _x getVariable ["owner", []];
				if (count _owner < 2) then { continue; };

				private _plate = _owner#1;
				private _class = typeOf _x;

				diag_log format ["[STOCK] Collecting vehicle %1 with plate %2 for stock %3", _class, _plate, _stockobj];

				private _Path = (getObjectTextures _x)#0;
				private _material = (getObjectMaterials _x)#0;
				private _Pathformat = format ["%1", _Path];
				private _materialFormat = format ["%1", _material];
				if (isNil "_materialFormat") then { _materialFormat = ""; };
				private _texture = [_Pathformat, "\", "?antislash?"] call CBA_fnc_replace;
				private _materialLocation = [_materialFormat, "\", "?antislash?"] call CBA_fnc_replace;

				private _fuel = fuel _x;
				private _damage = [];
				if (count (getAllHitPointsDamage _x) isEqualTo 3) then {
					_damage = (getAllHitPointsDamage _x)#2;
				};

				private _vehItems = getItemCargo _x;
				private _vehMags = getMagazineCargo _x;
				private _vehBackpacks = getBackpackCargo _x;
				private _vehWeapons = getWeaponCargo _x;
				private _istorage = [];
				if !((count (_vehItems#0) isEqualTo 0) && (count (_vehMags#0) isEqualTo 0) && (count (_vehBackpacks#0) isEqualTo 0) && (count (_vehWeapons#0) isEqualTo 0)) then {
					_istorage = [_vehItems, _vehMags, _vehBackpacks, _vehWeapons];
				};

				private _vstorage = _x getVariable ["storage", []];

				private _water = _x getVariable ["water", 0];
				private _gasType = _x getVariable ["gasType", ""];
				private _gasAmount = _x getVariable ["gasAmount", 0];
				private _gasType2 = _x getVariable ["gasType2", ""];
				private _gasAmount2 = _x getVariable ["gasAmount2", 0];
				private _addons = [];

				private _veh = _x;
				{
					private _phase = _veh animationSourcePhase _x;
					if (_phase > 0) then {
						_addons pushBack [_x, _phase];
					};
				} forEach (animationNames _veh);

				private _vehData = [
					["plate", _plate],
					["color", _texture],
					["material", _materialLocation],
					["inv", _istorage],
					["vinv", _vstorage],
					["fuel", _fuel],
					["damage", _damage]
				];

				if (_gasType != "" && _gasAmount > 0) then {
					_vehData pushBack ["gasType", _gasType];
					_vehData pushBack ["gasAmount", _gasAmount];
				};
				if (_gasType2 != "" && _gasAmount2 > 0) then {
					_vehData pushBack ["gasType2", _gasType2];
					_vehData pushBack ["gasAmount2", _gasAmount2];
				};

				if (count _addons > 0) then {
					_vehData pushBack ["addons", _addons];
				};

				if (_water > 0) then {
					_vehData pushBack ["water", _water];
				};

				private _stockList = _stockGroups getOrDefault [_stockobj, []];
				_stockList pushBack [_plate, _vehData, _x];
				_stockGroups set [_stockobj, _stockList];
			};
		};
	} forEach ((allMissionObjects "LandVehicle") + (allMissionObjects "Air") + (allMissionObjects "Ship"));

	{
		private _stockobj = _x;
		private _vehList = _y;

		diag_log format ["[STOCK] Processing stock %1 with %2 vehicles", _stockobj, count _vehList];

		private _result = [format ["SELECT vehicles FROM stock WHERE classname='%1'", _stockobj], 2, true] call Server_Database_Async;

		if (count _result > 0 && count (_result#0) > 0) then {
			private _vehiclesRaw = _result#0#0;
			private _vehicles = [];

			if (_vehiclesRaw isEqualType []) then {
				_vehicles = _vehiclesRaw;
			} else {
				if (_vehiclesRaw isEqualType "" && {_vehiclesRaw isNotEqualTo "" && _vehiclesRaw isNotEqualTo "[]"}) then {
					_vehicles = call compile _vehiclesRaw;
				};
			};

			if (isNil "_vehicles" || {!(_vehicles isEqualType [])}) then { _vehicles = []; };

			{
				_x params ["_plate", "_vehData", "_vehObj"];

				private _found = false;
				{
					private _vehEntry = _x;
					private _currentIndex = _forEachIndex;
					private _vehProps = _vehEntry#6;

					{
						if ((_x#0) isEqualTo "plate" && (_x#1) isEqualTo _plate) exitWith {
							_vehEntry set [1, 1];
							_vehEntry set [6, _vehData];
							_vehicles set [_currentIndex, _vehEntry];
							_found = true;
							diag_log format ["[STOCK] Found and updated vehicle %1 in stock %2", _plate, _stockobj];
						};
					} forEach _vehProps;

					if (_found) exitWith {};
				} forEach _vehicles;

				if (_found) then {
					private _deleteQuery = format ["DELETE FROM players_objects WHERE id='%1'", _plate];
					[_deleteQuery, 1] spawn Server_Database_Async;

					if (_delete) then {
						[_vehObj] call Server_Vehicle_Despawn;
					};
				} else {
					diag_log format ["[STOCK] WARNING: Vehicle with plate %1 not found in stock %2", _plate, _stockobj];
				};
			} forEach _vehList;

			private _updateQuery = format ["UPDATE stock SET vehicles='%1' WHERE classname='%2'", _vehicles, _stockobj];
			[_updateQuery, 1] spawn Server_Database_Async;
			diag_log format ["[STOCK] Stock %1 updated with all vehicles", _stockobj];
		} else {
			diag_log format ["[STOCK] ERROR: Stock %1 not found in database", _stockobj];
		};
	} forEach _stockGroups;

	diag_log "------------------------------ [STOCK] Stock Vehicles Return Complete ------------------------------";
}] call compile_Server;