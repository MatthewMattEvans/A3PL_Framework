/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["Server_Setup_SetupDatabase",{
	// Configuration base principale (existante)
	["Database", "SQL", "TEXT2"] call Server_Database_Setup;
	
	// Configuration base panel (nouvelle - optionnelle)
	["Panel", "SQL", "TEXT2"] call Server_Database_Setup;
	
	"extDB3" callExtension "9:LOCK";
	A3PL_DatabaseSetup = true;
}] call compile_Server;

["Server_Setup_ResetPlayerDB",{
	["CALL ResetDatabase();", 1] call Server_Database_Async;
}] call compile_Server;

["Server_Setup_Init",{
	diag_log format["[DEBUG] Starting server Initialization at %1", time];
	 private _commandLock = "PyAWkhAM76RRxkdS" serverCommand "#lock";
	A3PL_server_isReady = false;
	A3PL_soonReboot = false;

	//setup database
	call Server_Setup_SetupDatabase;
	diag_log format["[DEBUG] Starting Databases initialization at %1", time];
	waitUntil {(isNil 'A3PL_DatabaseSetup') isEqualTo false};
	diag_log format["[DEBUG] Databases are initialized at %1", time];
	Server_Setup_SetupDatabase = Nil;

	// Initialize Web API (PHP <-> SQF bridge)
	call Server_API_Init;
	diag_log format["[DEBUG] Web API initialized at %1", time];

	//setup server variables
	call Server_Core_Variables;
	diag_log format["[DEBUG] Server variables initialized at %1", time];

	//initialize localization system
	call A3PL_Localization_Init;
	call A3PL_Localization_Build;

	//initialize keypad global codes
	[] call Server_Keypad_Init;
	diag_log format["[DEBUG] Keypad global codes initialized at %1", time];
	
	//setup all the configuration files
	call Server_Setup_Config_Init;
	diag_log format["[DEBUG] Configuration files initialized at %1", time];

	//initialize keypad faction buildings configuration
	call A3PL_Config_Master_Server;
	diag_log format["[DEBUG] Master Config initialized at %1", time];
	
	//load auto-spawn NPCs
	call Server_NPC_LoadAutoSpawn;
	diag_log format["[DEBUG] Auto-spawn NPCs loaded at %1", time];

	//Setup 'HandleDisconnect' missionEventHandler (located in Server_Gear)
	call Server_Gear_HandleDisconnect;
	diag_log format["[DEBUG] Disconnection is handled at %1", time];

	//Temporary Hotfix
	//all this crap runs into post-init
	[] spawn {
		diag_log format["[DEBUG] Post-init SPAWN starting at %1", time];
		private _startTime = time;
		waitUntil {!isNil "npc_bank"};
		diag_log format["[DEBUG] Post-init NPC_bank found at %1", time];
		call Server_Addresses_Setup;
		diag_log format["[DEBUG] Post-init Addresses_Setup done at %1", time];
		call Server_Housing_Initialize;
		diag_log format["[DEBUG] Post-init Housing_Initialize done at %1", time];
		call Server_Warehouses_Initialize;
		diag_log format["[DEBUG] Post-Init Warehouses_Initialize done at %1", time];
		call Server_Crackhouses_Initialize;
		diag_log format["[DEBUG] Post-Init Crackhouses_Initialize done at %1", time];
		
		[] call Server_Housing_LoadItems;
		diag_log format["[DEBUG] Post-init Housing_LoadItems done at %1", time];
		[] call Server_Warehouses_LoadItems;
		diag_log format["[DEBUG] Post-init Warehouses_LoadItems done at %1", time];
		[] call Server_Crackhouses_LoadItems;
		diag_log format["[DEBUG] Post-init Crackhouses_LoadItems done at %1", time];
		
		//load all keypad codes
		[] call Server_Keypad_LoadAll;
		diag_log format["[DEBUG] Post-init Keypad codes loaded at %1", time];

		//call Server_JobFarming_DrugDealerPos;
		[] spawn Server_JobWildcat_RandomizeOil;
		diag_log format["[DEBUG] Post-init Server_JobWildcat_RandomizeOil spawned at %1", time];
		[] spawn Server_JobWildcat_RandomizeRes;
		diag_log format["[DEBUG] Post-init Server_JobWildcat_RandomizeRes spawned at %1", time];

		call Server_Core_GetDefVehicles;				//create the defaulte vehicles array (for use in cleanup script)
		diag_log format["[DEBUG] Post-init GetDefVehicles done at %1", time];
		call Server_JobPicking_Init;					//get the marker locations for picking locations
		diag_log format["[DEBUG] Post-init JobPicking_Init done at %1", time];
		[] spawn Server_Lumber_TreeRespawn;				//spawn trees for lumberyacking
		diag_log format["[DEBUG] Post-init Server_Lumber_TreeRespawn spawned at %1", time];
		call Server_Company_LoadAll;
		diag_log format["[DEBUG] Post-init Company_LoadAll done at %1", time];
		call Server_Company_LoadShop;
		diag_log format["[DEBUG] Post-init Company_LoadShop done at %1", time];

		//load stock values
		call Server_ShopStock_Load;
		diag_log format["[DEBUG] Post-init ShopStock_Load done at %1", time];
		[] spawn Server_Locker_Load;
		diag_log format["[DEBUG] Post-init Server_Locker_Load spawned at %1", time];
		
		diag_log format["[DEBUG] Post-init SPAWN finished at %1 (Duration: %2s)", time, time - _startTime];
	};

	call Server_Bowling_Setup;
	call Server_IE_Init;
	call Server_Phone_FishJobs_Init;
	call Server_Setup_ResetPlayerDB;

	call Server_JobFarming_PlantationSetup;

	["CALL deleteOldForfait();",1] call Server_Database_Async;
	["CALL deleteOldSms();",1] call Server_Database_Async;
	["CALL vehiclesToGarage();",1] call Server_Database_Async;
	["CALL resetPlayerPosition();",1] call Server_Database_Async;

	/*Get All FuelStations*/
	private _FuelPositions = [
		[11293.7,9040.11,0],	//Weapons Factory
		[10228.2,8490.94,0],	//Northdale
		[6165.03,7456.52,0],	//Elk City
		[4165.8,6170.87,0],		//Beach Valley
		[3436.19,7521.23,0],	//Stoney Creek
		[2605.94,5615.21,0],	//Silverton
		[9842.12,7973.37,0],	//Deadwood
		[7007.51,6418.07,0]		//Blackwood
	];
	FuelStations = [];
	{
		_tank = nearestObject [_x,"Land_A3PL_Gas_Station"];
		FuelStations pushBack _tank;
	} foreach _FuelPositions;
	publicVariable "FuelStations";
	[] spawn Server_Fuel_Load;

	//Spawn Crane Right Import Export
	/*	private _craneright = createVehicle ["A3PL_MobileCrane", [3693.044,7625.027,39.260], [], 0, "CAN_COLLIDE"];
		_craneright setDir 52.482;
		_craneright setFuel 0;
		_craneright addEventHandler ["GetIn",
		{
			params ["_veh","_position","_unit"];
			if (!local _unit) exitwith {};
			if (_position isEqualTo "driver") then{[_veh] spawn A3PL_IE_CraneGetIn;};
		}];

		//Spawn Crane Left Import Export
		private _craneleft = createVehicle ["A3PL_MobileCrane", [3659.797,7681.037,37.850], [], 0, "CAN_COLLIDE"];
		_craneleft setDir 232.025;
		_craneleft setFuel 0;
		_craneleft addEventHandler ["GetIn",
		{
			params ["_veh","_position","_unit"];
			if (!local _unit) exitwith {};
			if (_position isEqualTo "driver") then{[_veh] spawn A3PL_IE_CraneGetIn;};
		}];
	*/

	private _FISD_Events = 2700 + (random 3000);
	private _FIFR_Events = 2700 + (random 3000);

	["itemAdd", ["Server_EventsLoop", { call Server_Events_Random; }, 3600]] call BIS_fnc_loop;
	["itemAdd", ["Server_FireEventsLoop", { [] spawn Server_Events_FireEvents; }, _FIFR_Events]] call BIS_fnc_loop;
	["itemAdd", ["Server_FISDEventsLoop", { [] call Server_Events_FISDEvents; }, _FISD_Events]] call BIS_fnc_loop;

	["itemAdd", ["Server_PoliceLoop", { call Server_Police_JailLoop; }, 60]] call BIS_fnc_loop;
	["itemAdd", ["Server_Loop_Fishing", {call Server_fisherman_loop;}, 45]] call BIS_fnc_loop;

	//["itemAdd", ["Server_Loop_DealerPos", {call Server_JobFarming_DrugDealerPos;}, 1200]] call BIS_fnc_loop;
	["itemAdd", ["Server_Loop_RepairTerrain", {[] spawn Server_Core_RepairTerrain;}, 600]] call BIS_fnc_loop;
	["itemAdd", ["Server_Loop_BusinessLoop", {
		diag_log format["[DEBUG] Server_Loop_BusinessLoop starting at %1", time];
		[] spawn Server_Business_Loop;
	}, 300]] call BIS_fnc_loop;

	["itemAdd", ["Server_Loop_OilReset", {[] spawn Server_JobWildcat_ResetOil;}, 1800]] call BIS_fnc_loop;
	["itemAdd", ["Server_Loop_ResReset", {[] spawn Server_JobWildcat_ResetOre;}, 1800]] call BIS_fnc_loop;

	["itemAdd", ["Server_Loop_Criminal_MoveNPCs", {[] spawn Server_Criminal_MoveNPCs;}, 10800]] call BIS_fnc_loop;

	//cleanup
	["itemAdd", ["Server_Loop_Cleanup", {
		diag_log format["[DEBUG] Server_Loop_Cleanup starting at %1", time];
		[] spawn Server_Core_Clean;
	}, 900]] call BIS_fnc_loop;
	["itemAdd", ["Server_Loop_Weather", {[] spawn Server_Core_Weather;}, 1200]] call BIS_fnc_loop;

	//Fire
	["itemAdd", ["Server_Fire_FireLoop", {[] spawn Server_Fire_FireLoop;}, 15]] call BIS_fnc_loop;

	//Picking loop - TEMPORAIREMENT DÉSACTIVÉ POUR PERFORMANCES
	//["itemAdd", ["Server_Loop_Picking", {[] spawn Server_JobPicking_Loop;}, 15]] call BIS_fnc_loop;

	["itemAdd", ["Loop_NPC_TimeWindows", {call Server_NPC_UpdateTimeWindows;}, 60, 'seconds']] call BIS_fnc_loop;

	// Mushroom picking loop
	["itemAdd", ["Server_Loop_ShroomPicking", {[] spawn Server_Shrooms_Loop;}, 15]] call BIS_fnc_loop;

	["itemAdd", ["Server_Loop_TurtlesMove", {[] spawn Server_Criminal_TurtlesMove;}, 3600]] call BIS_fnc_loop;

	//tree respawn for lumberyack
	["itemAdd", ["Server_Loop_TreeRespawn", {[] spawn Server_Lumber_TreeRespawn;}, 1800]] call BIS_fnc_loop;

	//loop for import_export
	["itemAdd", ["Server_Loop_IE", {[] spawn Server_IE_ShipImport;}, 2100]] call BIS_fnc_loop;

	//Lottery
	["itemAdd", ["Server_Loop_Lottery",{[] spawn Server_Core_Lottery;}, 3600]] call BIS_fnc_loop;

	//loop for animals
	["itemAdd", ["Server_Loop_Hunting",{[] spawn Server_Hunting_HandleLoop;}, 30]] call BIS_fnc_loop;
	
	["itemAdd", ["Server_Loop_Save",{
		diag_log format["[DEBUG] Server_Loop_Save starting at %1", time];
		call Server_Core_Save;
	}, 1800]] call BIS_fnc_loop;

	["itemAdd", ["Server_Loop_SaveFurnitures",{
		diag_log format["[DEBUG] Server_Loop_SaveFurnitures starting at %1", time];
		[] spawn Server_Core_SaveFurnitures;
	}, 3600]] call BIS_fnc_loop;

	// Appel initial au démarrage
	[] spawn Server_Core_RestartLoop;
	
	["itemAdd", ["Server_Loop_RestartAnnoucement",{[] spawn Server_Core_RestartLoop;}, 60]] call BIS_fnc_loop;

	["itemAdd", ["Server_Loop_countDownForfait",{[] spawn Server_Phone_countDownForfait;}, 1800]] call BIS_fnc_loop;

	["itemAdd", ["Server_FishJobsUpdate", { [] spawn Server_Phone_FishJobs_Update; }, 60]] call BIS_fnc_loop;

	// FactoryV2 - Traitement des crafts actifs (toutes les 5 secondes)
	["itemAdd", ["Server_Loop_FactoryV2_ProcessCrafts", {[] call Server_FactoryV2_ProcessCrafts;}, 5]] call BIS_fnc_loop;

	// FactoryV2 - Vérification des abonnements (toutes les 60 secondes, exécute à 6h00 UTC)
	["itemAdd", ["Server_Loop_FactoryV2_CheckSubscriptions", {
		private _timeUTC = systemTimeUTC;
		private _hour = _timeUTC select 3;
		private _minute = _timeUTC select 4;

		// Exécuter à 6h00 UTC (entre 6:00 et 6:01)
		if (_hour == 6 && _minute == 0) then {
			[] call Server_FactoryV2_ProcessSubscriptions;
		};
	}, 60]] call BIS_fnc_loop;

	["itemAdd", ["Server_Loop_SaveGear",
	{
		diag_log format["[DEBUG] Server_Loop_SaveGear starting at %1 - Players: %2", time, count allPlayers];
		[] spawn {
			private _startTime = time;
			diag_log format["[DEBUG] Server_Loop_SaveGear SPAWN started at %1", _startTime];
			{
				diag_log format["[DEBUG] Spawning Server_Gear_Save for %1 at %2", name _x, time];
				[_x,false] spawn Server_Gear_Save;
				sleep 10;
			} foreach allPlayers;
			diag_log format["[DEBUG] Server_Loop_SaveGear SPAWN finished at %1 (Duration: %2s)", time, time - _startTime];
		};
	}, 300]] call BIS_fnc_loop;

	//loop save veh
	//["itemAdd", ["Server_Loop_Vehicle_Save",{[false] spawn Server_Vehicle_Save;}, 1800]] call BIS_fnc_loop;

	//lastly load all the persistent vars from database
	private _pVars = ["SELECT * FROM persistent_vars", 2, true] call Server_Database_Async;
	{
		private _compile = format['%1 = %2;',(_x select 0),([(_x select 1)] call Server_Database_ToArray)];
		call compile _compile;
		if (_x#2 isEqualTo 1) then {
			publicVariable (_x#0);
		};
	} foreach _pVars;

	call Server_FactoryV2_Init;
	diag_log format["[DEBUG] FactoryV2 initialized at %1", time];
	call Server_Police_SeizureLoad;
	[] spawn Server_TrafficLight_Init;
	[] spawn Server_Criminal_MoveNPCs;
	diag_log format["[DEBUG] Server_Criminal_MoveNPCs spawned at %1", time];
	[] spawn Server_Criminal_initNPCs;
	diag_log format["[DEBUG] Server_Criminal_initNPCs spawned at %1", time];
	//[] spawn Server_Vehicle_Load;
	//diag_log format["[DEBUG] Server_Vehicle_Load spawned at %1", time];

	//check addons
	Server_ModVersion = getNumber (configFile >> "CfgPatches" >> "A3PL_Common" >> "requiredVersion");
	publicVariable "Server_ModVersion";

	//Tell clients that server is setup
	A3PL_ServerLoaded = true;
	publicVariable "A3PL_ServerLoaded";

	A3PL_FD_Clinic = true;
	publicVariable "A3PL_FD_Clinic";

	A3PL_Event_DblXP = 1;
	publicVariable "A3PL_Event_DblXP";

	A3PL_Event_DblHarvest = 1;
	publicVariable "A3PL_Event_DblHarvest";

	A3PL_Event_Paycheck = 1;
	publicVariable "A3PL_Event_Paycheck";

	A3PL_Event_CrimePayout = 1;
	publicVariable "A3PL_Event_CrimePayout";

    Server_ThreatLevel = "green";
    publicVariable "Server_ThreatLevel";

	Christmas_Mapping_Spawned = false;
	publicVariable "Christmas_Mapping_Spawned";

	A3PL_server_isReady = true;
	publicVariable "A3PL_server_isReady";

	[] remoteExec ["A3PL_SmartMarker_mapMarker",2];
	"markerIsConfig" addPublicVariableEventHandler
	{
		diag_log format["------------------------ MARKERS ------------------------"];
		diag_log format["Marker is config %1", _this select 1];
		diag_log format["------------------------ MARKERS ------------------------"];
	};

	 private _commandUnlock = "PyAWkhAM76RRxkdS" serverCommand "#unlock";
}] call compile_Server;

["Server_Setup_Config_Init",{
	diag_log format["[DEBUG] Starting configuration files initialization at %1", time];

	// Config Master (variables globales de configuration)
	diag_log format["[DEBUG] Starting Config Master initialization at %1", time];
	private _configMaster = ["SELECT name, value, public, needs_compile FROM config_master", 2, true] call Server_Database_Async;
	{
		private _name = _x select 0;
		private _value = _x select 1;
		private _public = (_x select 2) isEqualTo 1;
		private _needsCompile = (_x select 3) isEqualTo 1;

		if (_needsCompile) then {
			call compile format['%1 = %2;', _name, _value];
		} else {
			call compile format['%1 = %2;', _name, str _value];
		};

		if (_public) then {
			publicVariable _name;
		};
	} forEach _configMaster;
	diag_log format["[DEBUG] Config Master initialized - %1 variables loaded at %2", count _configMaster, time];

	// Items
	diag_log format["[DEBUG] Starting Items files initialization at %1", time];
	private _query = ["SELECT * FROM config_items",2,true] call Server_Database_Async;

	Config_ItemMap = createHashMapFromArray (
		_query apply {
			private _weight = parseNumber (_x select 3);
			[
				_x select 1,
				[
					[_x select 2, '?y?', "'"] call CBA_fnc_replace,
					_weight,
					_x select 4,
					_x select 5,
					(_x select 6) isEqualTo 1,
					(_x select 7) isEqualTo 1,
					(_x select 8) isEqualTo 1,
					(_x select 9) isEqualTo 1,
					(_x select 10) isEqualTo 1,
					_x select 11,
					[_x select 12] call Server_Database_ToArray,
					_x select 13,
					_x select 14,
					_x select 15
				]
			]
		}
	);
	publicVariable "Config_ItemMap";

	diag_log format["[DEBUG] Items files initialized at %1", time];

	// Jobs
	diag_log format["[DEBUG] Starting Jobs files initialization at %1", time];
	_query = ["SELECT * FROM config_jobs",2,true] call Server_Database_Async;

	Config_Paychecks = createHashMapFromArray (
		_query apply {
			[_x select 1, [_x select 2] call Server_Database_ToArray]
		}
	);
	publicVariable "Config_Paychecks";

	diag_log format["[DEBUG] Jobs files initialized at %1", time];

	// Combineable items
	diag_log format["[DEBUG] Starting Combineable Items files initialization at %1", time];
	_query = ["SELECT * FROM config_combineitems",2,true] call Server_Database_Async;

	Config_CombineItems = _query apply {
		[_x select 1, [_x select 2] call Server_Database_ToArray, _x select 3]
	};
	publicVariable "Config_CombineItems";

	diag_log format["[DEBUG] Combineable Items files initialized at %1", time];

	// Licenses
	diag_log format["[DEBUG] Starting Licenses files initialization at %1", time];
	_query = ["SELECT * FROM config_licenses",2,true] call Server_Database_Async;

	Config_Licenses = createHashMapFromArray (
		_query apply {
			[
				_x select 1,
				[
					[_x select 2, '?y?', "'"] call CBA_fnc_replace,
					(_x select 3) isEqualTo 1,
					[_x select 4] call Server_Database_ToArray,
					[_x select 5] call Server_Database_ToArray,
					_x select 6,
					_x select 7
				]
			]
		}
	);
	publicVariable "Config_Licenses";

	diag_log format["[DEBUG] Licenses files initialized at %1", time];

	// Illegal NPCs hideouts
	diag_log format["[DEBUG] Starting Illegal NPCs Hideouts files initialization at %1", time];
	_query = ["SELECT * FROM config_illegalnpcs_hideout",2,true] call Server_Database_Async;

	IllegalNPC_Hideout = _query apply {
		[
			_x select 1,
			[[_x select 2, _x select 3, _x select 4, _x select 5]] 
		] 
	};
	publicVariable "IllegalNPC_Hideout";

	diag_log format["[DEBUG] Illegal NPCs Hideouts files initialized at %1", time];

	// Illegal NPCs
	diag_log format["[DEBUG] Starting Illegal NPCs files initialization at %1", time];
	_query = ["SELECT * FROM config_illegalnpcs",2,true] call Server_Database_Async;

	IllegalNPC = _query apply {
		private _MarkerPos = [];
		if (_x select 6 != "") then {
			_MarkerPos pushBack (_x select 6); 
			_MarkerPos pushBack (_x select 7); 
		}; 
		[ 
			_x select 1, 
			[_x select 2, _x select 3, _x select 4, _x select 5], 
			_MarkerPos 
		] 
	};
	publicVariable "IllegalNPC";

	diag_log format["[DEBUG] Illegal NPCs files initialized at %1", time];

	// Wounds
	diag_log format["[DEBUG] Starting Wounds files initialization at %1", time];
	_query = ["SELECT * FROM config_medical_wounds",2,true] call Server_Database_Async;

	Config_Medical_Wounds = createHashMapFromArray (
		_query apply {
			[
				_x select 1, 
				[
					[_x select 2, '?y?', "'"] call CBA_fnc_replace, 
					_x select 3, 
					_x select 4, 
					_x select 5, 
					_x select 6, 
					(_x select 7) isEqualTo 1, 
					_x select 8 
				] 
			] 
		} 
	);
	publicVariable "Config_Medical_Wounds";

	diag_log format["[DEBUG] Medical Wounds files initialized at %1", time];

	// Bargates
	diag_log format["[DEBUG] Starting Bargates files initialization at %1", time];
	_query = ["SELECT * FROM config_objects_bargates",2,true] call Server_Database_Async;

	Config_Objects_Bargates = _query apply {
		[
			[_x select 1, _x select 2, _x select 3],
			[_x select 4] call Server_Database_ToArray 
		] 
	}; 
	publicVariable "Config_Objects_Bargates";

	diag_log format["[DEBUG] Bargates files initialized at %1", time];

	// Items offsets
	diag_log format["[DEBUG] Starting Items Offsets files initialization at %1", time];
	_query = ["SELECT * FROM config_items_zoffset",2,true] call Server_Database_Async;

	Config_Items_ZOffset = createHashMapFromArray (
		_query apply {
			[
				_x select 1, 
				[_x select 2, _x select 3] 
			] 
		} 
	);
	publicVariable "Config_Items_ZOffset";

	diag_log format["[DEBUG] Items Offsets files initialized at %1", time];

	// Placeables & Furnitures
	diag_log format["[DEBUG] Starting Placeables files initialization at %1", time];
	_query = ["SELECT * FROM config_placeables",2,true] call Server_Database_Async;

	Config_Placeables = _query apply { _x select 1 };
	publicVariable "Config_Placeables";

	diag_log format["[DEBUG] Placeables files initialized at %1", time];

	diag_log format["[DEBUG] Starting Furniture files initialization at %1", time];
	_query = ["SELECT * FROM config_furniture",2,true] call Server_Database_Async;

	Config_Furniture = _query apply { _x select 1 };
	publicVariable "Config_Furniture";

	diag_log format["[DEBUG] Furniture files initialized at %1", time];

	// Ores
	diag_log format["[DEBUG] Starting Ores files initialization at %1", time];
	_query = ["SELECT * FROM config_resources_ores",2,true] call Server_Database_Async;

	Config_Resources_Ores = _query apply {
		[
			_x select 1,
			_x select 2, 
			_x select 3, 
			_x select 4, 
			_x select 5, 
			_x select 6 
		] 
	}; 
	publicVariable "Config_Resources_Ores";

	diag_log format["[DEBUG] Ores files initialized at %1", time];

	// Achievements
	diag_log format["[DEBUG] Starting Achievements files initialization at %1", time];
	_query = ["SELECT * FROM config_achievement",2,true] call Server_Database_Async;

	Config_Achievement = createHashMapFromArray (
		_query apply {
			[
				_x select 1,
				[
					[_x select 2, '?y?', "'"] call CBA_fnc_replace, 
					[_x select 3, '?y?', "'"] call CBA_fnc_replace, 
					_x select 4, 
					[_x select 5] call Server_Database_ToArray, 
					_x select 6
				] 
			] 
		} 
	);
	publicVariable "Config_Achievement";

	diag_log format["[DEBUG] Achievements files initialized at %1", time];

	// Houses
	diag_log format["[DEBUG] Starting Houses files initialization at %1", time];
	_query = ["SELECT * FROM config_houses_list",2,true] call Server_Database_Async;

	Config_Houses_List = _query apply { _x select 1 };
	publicVariable "Config_Houses_List";

	_query = ["SELECT * FROM config_houses_data",2,true] call Server_Database_Async;

	Config_Houses_Data = createHashMapFromArray (
		_query apply {
			[
				_x select 1,
				[
					_x select 2, 
					_x select 3, 
					_x select 4, 
					_x select 5
				] 
			] 
		}
	);
	publicVariable "Config_Houses_Data";

	diag_log format["[DEBUG] Houses files initialized at %1", time];

	// Crackhouses
	diag_log format["[DEBUG] Starting Crackhouses files initialization at %1", time];
	_query = ["SELECT * FROM config_crackhouses_list",2,true] call Server_Database_Async;

	Config_Crackhouses_List = _query apply { _x select 1 };
	publicVariable "Config_Crackhouses_List";

	_query = ["SELECT * FROM config_crackhouses_data",2,true] call Server_Database_Async;

	Config_Crackhouses_Data = createHashMapFromArray (
		_query apply {
			[
				_x select 1,
				[
					_x select 2,
					_x select 3,
					_x select 4,
					_x select 5
				]
			]
		}
	);
	publicVariable "Config_Crackhouses_Data";

	diag_log format["[DEBUG] Crackhouses files initialized at %1", time];

	// Warehouses
	diag_log format["[DEBUG] Starting Warehouses files initialization at %1", time];
	_query = ["SELECT * FROM config_warehouses_list",2,true] call Server_Database_Async;

	Config_Warehouses_List = _query apply { _x select 1 };
	publicVariable "Config_Warehouses_List";

	_query = ["SELECT * FROM config_warehouses_data",2,true] call Server_Database_Async;

	Config_Warehouses_Data = createHashMapFromArray (
		_query apply {
			[
				_x select 1,
				[
					_x select 2,
					_x select 3,
					_x select 4,
					_x select 5
				]
			]
		}
	);
	publicVariable "Config_Warehouses_Data";

	diag_log format["[DEBUG] Warehouses files initialized at %1", time];

	// Hunger & Thirst
	diag_log format["[DEBUG] Starting Hunger & Thirst files initialization at %1", time];
	_query = ["SELECT * FROM config_food",2,true] call Server_Database_Async;

	Config_Food = createHashMapFromArray (
		_query apply {
			[
				_x select 1,
				[
					_x select 2,
					(_x select 3) isEqualTo 1,
					_x select 4
				]
			]
		}
	);
	publicVariable "Config_Food";

	_query = ["SELECT * FROM config_thirst",2,true] call Server_Database_Async;

	Config_Thirst = createHashMapFromArray (
		_query apply {
			[
				_x select 1,
				[
					_x select 2,
					(_x select 3) isEqualTo 1,
					_x select 4,
					_x select 5,
					_x select 6
				]
			]
		}
	);
	publicVariable "Config_Thirst";

	diag_log format["[DEBUG] Hunger & Thirst files initialized at %1", time];

	// Garage Upgrades
	diag_log format["[DEBUG] Starting Garage Upgrades files initialization at %1", time];
	_query = ["SELECT * FROM config_garage",2,true] call Server_Database_Async;
	
	private _garageMap = createHashMap;
	{
		private _vehicleClass = _x select 1;
		private _upgradeData = [
			_x select 2,  // upgrade_id
			_x select 3,  // upgrade_type  
			_x select 4,  // upgrade_class
			[_x select 5, '?y?', "'"] call CBA_fnc_replace,  // title
			[_x select 6, '?y?', "'"] call CBA_fnc_replace,  // description
			_x select 7,  // cam_target
			[_x select 8, _x select 9, _x select 10],  // cam_offset [x,y,z]
			_x select 11, // install_price
			if ((_x select 12) isEqualTo []) then {[]} else {_x select 12}, // required_items
			if ((_x select 13) isEqualTo "") then {false} else {_x select 13}  // stock_item
		];
		
		if (_vehicleClass in _garageMap) then {
			(_garageMap get _vehicleClass) pushBack _upgradeData;
		} else {
			_garageMap set [_vehicleClass, [_upgradeData]];
		};
	} forEach _query;
	
	Config_Garage_Upgrade = keys _garageMap apply {
		private _upgrades = _garageMap get _x;
		[_x] + _upgrades
	};
	publicVariable "Config_Garage_Upgrade";

	diag_log format["[DEBUG] Garage Upgrades files initialized at %1", time];

	// Shops - Taxes
	diag_log format["[DEBUG] Starting Shops - Taxes files initialization at %1", time];
	_query = ["SELECT * FROM config_shops_taxsystem",2,true] call Server_Database_Async;

	Config_Shops_TaxSystem = _query apply {
		[ 
			_x select 1, 
			_x select 2, 
			_x select 3
		]
	};
	publicVariable "Config_Shops_TaxSystem";

	diag_log format["[DEBUG] Shops - Taxes files initialized at %1", time];

	// Shops - Stock system
	diag_log format["[DEBUG] Starting Shops - Stock system files initialization at %1", time];
	_query = ["SELECT * FROM config_shops_stocksystem",2,true] call Server_Database_Async;

	Config_Shops_StockSystem = _query apply { _x select 1 };
	publicVariable "Config_Shops_StockSystem";

	diag_log format["[DEBUG] Shops - Stock system files initialized at %1", time];

	// Shops - Items
	diag_log format["[DEBUG] Starting Shops - Items files initialization at %1", time];
	_query = ["SELECT * FROM config_shops",2,true] call Server_Database_Async;
	private _shopsPositions = [];
	{
		private _shopName = _x select 1;
		private _position = _x select 2;
		private _secondaryPosition = if ((_x select 3) isEqualTo "") then {""} else {_x select 3};
		
		_shopsPositions pushBack [_shopName, _position, _secondaryPosition];
	} forEach _query;
	
	_query = ["SELECT * FROM config_shops_items",2,true] call Server_Database_Async;
	private _shopsItems = [];
	{
		private _shopName = _x select 1;
		private _itemData = [
			_x select 2,
			_x select 3,
			_x select 4,
			_x select 5,
			_x select 6
		];
		
		private _found = false;
		{
			if ((_x select 0) isEqualTo _shopName) then {
				(_x select 1) pushBack _itemData;
				_found = true;
			};
		} forEach _shopsItems;
		
		if (!_found) then {
			_shopsItems pushBack [_shopName, [_itemData]];
		};
	} forEach _query;
	
	Config_Shops_Items = [];
	{
		private _shopName = _x select 0;
		private _items = _x select 1;
		private _shopPositions = [];
		
		{
			if ((_x select 0) isEqualTo _shopName) then {
				_shopPositions = _x;
			};
		} forEach _shopsPositions;
		
		if ((_shopPositions select 2) isEqualTo "") then {
			Config_Shops_Items pushBack [_shopName, _items, _shopPositions select 1];
		} else {
			Config_Shops_Items pushBack [_shopName, _items, _shopPositions select 1, _shopPositions select 2];
		};
	} forEach _shopsItems;
	publicVariable "Config_Shops_Items";

	diag_log format["[DEBUG] Shops - Items files initialized at %1", time];

	// Vehicles
	diag_log format["[DEBUG] Starting Vehicles files initialization at %1", time];
	_query = ["SELECT * FROM config_veh_admin",2,true] call Server_Database_Async;

	Config_Vehicles_Admin = [];
	private _vehiclePrefixes = [];
	
	{
		private _vehiclePrefix = _x select 1;
		private _variant = _x select 2;
		private _currentDisplayName = _x select 3;
		private _fullClassName = format ["%1_%2",_vehiclePrefix,_variant];
		
		private _configDisplayName = getText (configFile >> "CfgVehicles" >> _fullClassName >> "displayName");
		
		if (_configDisplayName != _currentDisplayName) then {
			[format ["UPDATE config_veh_admin SET display_name = '%1' WHERE vehicle_prefix = '%2' AND variant = '%3'", _configDisplayName, _vehiclePrefix, _variant],1] call Server_Database_Async;
		};
		
		private _found = false;
		{
			if ((_x select 0) isEqualTo _vehiclePrefix) then {
				(_x select 1) pushBack _variant;
				_found = true;
			};
		} forEach _vehiclePrefixes;
		
		if (!_found) then {
			_vehiclePrefixes pushBack [_vehiclePrefix, [_variant]];
		};
	} forEach _query;
	
	{
		Config_Vehicles_Admin pushBack [_x select 0, _x select 1];
	} forEach _vehiclePrefixes;
	publicVariable "Config_Vehicles_Admin";

	_query = ["SELECT * FROM config_veh_ml",2,true] call Server_Database_Async;

	Config_ML_Vehs = _query apply { _x select 1 };
	publicVariable "Config_ML_Vehs";

	_query = ["SELECT * FROM config_veh_fisd",2,true] call Server_Database_Async;

	Config_FISD_Vehs = _query apply { _x select 1 };
	publicVariable "Config_FISD_Vehs";

	_query = ["SELECT * FROM config_veh_fisd_hel",2,true] call Server_Database_Async;

	Config_FISD_Hel = _query apply { _x select 1 };
	publicVariable "Config_FISD_Hel";

	_query = ["SELECT * FROM config_veh_fifr",2,true] call Server_Database_Async;

	Config_FIFR_Vehs = _query apply { _x select 1 };
	publicVariable "Config_FIFR_Vehs";

	_query = ["SELECT * FROM config_veh_fifr_hel",2,true] call Server_Database_Async;

	Config_FIFR_Hel = _query apply { _x select 1 };
	publicVariable "Config_FIFR_Hel";

	_query = ["SELECT * FROM config_veh_doj",2,true] call Server_Database_Async;

	Config_DOJ_Vehs = _query apply { _x select 1 };
	publicVariable "Config_DOJ_Vehs";

	_query = ["SELECT * FROM config_veh_slicktop",2,true] call Server_Database_Async;

	Config_Slicktop_Vehs = _query apply { _x select 1 };
	publicVariable "Config_Slicktop_Vehs";

	_query = ["SELECT * FROM config_veh_lightbar",2,true] call Server_Database_Async;

	Config_Lightbar_Vehs = _query apply { _x select 1 };
	publicVariable "Config_Lightbar_Vehs";

	_query = ["SELECT * FROM config_veh_motorboat",2,true] call Server_Database_Async;

	Config_Motorboat = _query apply { _x select 1 };
	publicVariable "Config_Motorboat";

	diag_log format["[DEBUG] Vehicles files initialized at %1", time];

	// FactoryV2 - Licenses
	diag_log format["[DEBUG] Starting FactoryV2 Licenses files initialization at %1", time];
	_query = ["SELECT id, name, price, IFNULL(preview_pos,'') as preview_pos, IFNULL(is_civilian,0) as is_civilian, IFNULL(sectors,'') as sectors, IFNULL(npcs,'') as npcs FROM config_factoryv2_licenses", 2, true] call Server_Database_Async;

	Config_FactoryV2_Licenses = createHashMapFromArray (
		_query apply {
			private _previewPos = _x select 3;
			if (_previewPos isEqualType "" && {_previewPos != "" && _previewPos != "[]"}) then {
				_previewPos = parseSimpleArray _previewPos;
			};
			private _licenseIdKey = _x select 0;
			if (!(_licenseIdKey isEqualType "")) then {_licenseIdKey = str _licenseIdKey;};
			private _sectors = [_x select 5] call Server_Database_ToArray;
			if (isNil "_sectors") then {_sectors = [];};
			if !(_sectors isEqualType []) then {_sectors = [];};
			private _npcs = [_x select 6] call Server_Database_ToArray;
			if (isNil "_npcs") then {_npcs = [];};
			if !(_npcs isEqualType []) then {_npcs = [];};
			[
				_licenseIdKey,
				[
					_x select 1,  // 0: name
					_x select 2,  // 1: price
					_previewPos,  // 2: preview_pos
					_x select 4,  // 3: is_civilian
					_sectors,     // 4: sectors (array)
					_npcs         // 5: npcs (array of variable names)
				]
			]
		}
	);
	publicVariable "Config_FactoryV2_Licenses";

	diag_log format["[DEBUG] FactoryV2 Licenses files initialized at %1", time];

	// FactoryV2 - Crafts
	diag_log format["[DEBUG] Starting FactoryV2 Crafts files initialization at %1", time];
	_query = ["SELECT id, name, price, required_items, base_duration, license_id, IFNULL(classname,'') as classname, IFNULL(class_type,'item') as class_type, IFNULL(output_amount,1) as output_amount, IFNULL(description,'') as description, IFNULL(is_civilian,0) as is_civilian, IFNULL(craft_fee,0) as craft_fee, IFNULL(sectors,'') as sectors FROM config_factoryv2_crafts", 2, true] call Server_Database_Async;
	if (isNil "_query") then {_query = [];};
	if !(_query isEqualType []) then {_query = [];};

	Config_FactoryV2_Crafts = createHashMapFromArray (
		_query apply {
			private _requiredItems = [_x select 3] call Server_Database_ToArray;
			if (isNil "_requiredItems") then {_requiredItems = [];};
			if !(_requiredItems isEqualType []) then {_requiredItems = [];};

			private _licenseID = _x select 5;
			if (!(_licenseID isEqualType "")) then {_licenseID = str _licenseID;};

			private _craftID = _x select 0;
			if (!(_craftID isEqualType "")) then {_craftID = str _craftID;};

			private _sectors = [_x select 12] call Server_Database_ToArray;
			if (isNil "_sectors") then {_sectors = [];};
			if !(_sectors isEqualType []) then {_sectors = [];};

			[
				_craftID,
				[
					_x select 1,   // 0: name
					_x select 2,   // 1: price
					_requiredItems, // 2: required_items
					_x select 4,   // 3: base_duration
					_licenseID,    // 4: license_id
					_x select 6,   // 5: classname
					_x select 7,   // 6: class_type
					_x select 8,   // 7: output_amount
					if ((_x select 9) isEqualType "") then {[_x select 9, '?y?', "'"] call CBA_fnc_replace} else {""}, // 8: description
					_x select 10,  // 9: is_civilian
					_x select 11,  // 10: craft_fee
					_sectors       // 11: sectors (array)
				]
			]
		}
	);
	publicVariable "Config_FactoryV2_Crafts";

	diag_log format["[DEBUG] FactoryV2 Crafts files initialized at %1", time];

	// FactoryV2 - Upgrades
	diag_log format["[DEBUG] Starting FactoryV2 Upgrades files initialization at %1", time];
	_query = ["SELECT id, name, price, upgrade_type, upgrade_value FROM config_factoryv2_upgrades", 2, true] call Server_Database_Async;

	Config_FactoryV2_Upgrades = createHashMapFromArray (
		_query apply {
			// upgrade_id: garder comme string sans double conversion
			private _upgradeIdKey = _x select 0;
			if (!(_upgradeIdKey isEqualType "")) then {_upgradeIdKey = str _upgradeIdKey;};
			[
				_upgradeIdKey, // id as string key
				[
					_x select 1, // name
					_x select 2, // price
					_x select 3, // upgrade_type
					_x select 4  // upgrade_value
				]
			]
		}
	);
	publicVariable "Config_FactoryV2_Upgrades";

	diag_log format["[DEBUG] FactoryV2 Upgrades files initialized at %1", time];

	// Billboards textures
	diag_log format["[DEBUG] Starting Billboards textures initialization at %1", time];
	_query = ["SELECT * FROM config_billboards",2,true] call Server_Database_Async;

	{
		private _name = _x select 1;
		private _texture0 = _x select 2;
		private _texture1 = _x select 3;
		private _object = missionNamespace getVariable [_name, objNull];

		if (!isNull _object) then {
			_object setObjectTextureGlobal [0, _texture0];
			_object setObjectTextureGlobal [1, _texture1];
			diag_log format["[DEBUG] Billboard '%1' textures applied", _name];
		} else {
			diag_log format["[WARNING] Billboard '%1' not found in mission", _name];
		};
	} forEach _query;

	diag_log format["[DEBUG] Billboards textures initialized at %1", time];

	// Doorplates textures
	diag_log format["[DEBUG] Starting Doorplates textures initialization at %1", time];
	_query = ["SELECT * FROM config_doorplates",2,true] call Server_Database_Async;

	{
		private _name = _x select 1;
		private _texture = _x select 2;
		private _object = missionNamespace getVariable [_name, objNull];

		if (!isNull _object) then {
			_object setObjectTextureGlobal [0, _texture];
			diag_log format["[DEBUG] Doorplate '%1' texture applied", _name];
		} else {
			diag_log format["[WARNING] Doorplate '%1' not found in mission", _name];
		};
	} forEach _query;

	diag_log format["[DEBUG] Doorplates textures initialized at %1", time];

	diag_log format["[DEBUG] Configuration variables are initialized at %1", time];

}] call compile_Server;
