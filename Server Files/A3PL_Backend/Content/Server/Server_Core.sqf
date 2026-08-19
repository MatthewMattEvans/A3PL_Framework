/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
['Server_Core_Variables', {
	A3PL_RetrievedInventory = true;
	Server_Storage_ListVehicles = [];
	
	//Variable that stores a list of owned/sold houses
	Server_HouseList = [];
	Server_WarehouseList = [];
	Server_CrackhouseList = [];

	//Variable that stores all fishing buoys
	Server_FishingBuoys = [];

	//greenhouses
	Server_JobFarming_GreenHouses = [];

	//List of all jailed players
	Server_Jailed_Players = [];

	// List of all vehicles stolen from a dealership
	Server_Dealership_Vehicles = [];
	Server_GoFast_Vehicles = [];

	A3PL_Uber_Drivers = [];
	A3PL_Uber_Riders = [];

	A3PL_HitchingVehicles = ["A3PL_Car_Base","A3PL_Truck_Base","A3FL_F450","A3FL_F150"];

	//Fire Scripts
	Server_TerrainFires = [];
	Server_FireLooping = true;
	publicVariable "Server_FireLooping";

	Server_Police_DispatchCount = 0;
	Server_Police_Dispatch = [];
	publicVariable "Server_Police_Dispatch";

	//markerlist
	Server_JobRoadWorker_Marked = [];
	publicVariable "Server_JobRoadWorker_Marked";

	Server_StartMarkers = allMapMarkers;
	publicVariable "Server_StartMarkers";

	//Lottery
	Server_LotteryEntries = [];
	publicVariable "Server_LotteryEntries";

	//Online players character IDs
	Server_Online_Players_charIDs =[];
	publicVariable "Server_Online_Players_charIDs";

	Server_Shopstocks = [];
	publicVariableServer "Server_Shopstocks";

	Recent_Shots =[];
	publicVariable "Recent_Shots";
}] call compile_Server;

["Server_Core_SavePersistentVar", {
	if (!isDedicated) exitwith {};
	private _var = param [0,""];
	private _toArray = param [1,true];
	private _query = if (_toArray) then {
		format ["UPDATE persistent_vars SET value='%2' WHERE var = '%1'",_var,[(call compile _var)] call Server_Database_Array];
	} else {
		format ["UPDATE persistent_vars SET value='%2' WHERE var = '%1'",_var,(call compile _var)];
	};
	[_query,1] spawn Server_Database_Async;
}] call compile_Server;

["Server_Core_ChangeVar", {
	params [
		["_obj",objNull,[objNull]],
		["_variable","ERROR",[""]],
		["_value","ERROR"]
	];

	if (isNull _obj) exitWith {};
	if ((str _variable) isEqualTo "ERROR") exitWith {};
	if ((str _value) isEqualTo "ERROR") exitWith {};
	_obj setVariable [_variable, _value, true];
}] call compile_Server;

["Server_Core_GetDefVehicles",{Server_Core_DefVehicles = allMissionObjects "All";}] call compile_Server;

["Server_Core_Clean", {
	private _startTime = time;
	private _toDelete = [];
	private _allMO = allMissionObjects "All";
	private _ignore = ["A3PL_MobileCrane","A3PL_Anchor","A3PL_FSS_Siren","A3PL_FSS_Phaser","A3PL_FSS_Priority","A3PL_FSS_Rumbler","A3PL_EQ2B_Wail","A3PL_Whelen_Warble","A3PL_AirHorn_1","A3PL_FSUO_Siren","A3PL_Whelen_Priority3","A3PL_FIPA20A_Priority","A3PL_Electric_Horn","A3PL_Whelen_Siren","A3PL_Whelen_Priority""A3PL_Whelen_Priority2""A3PL_Electric_Airhorn","A3PL_Lifebuoy","A3PL_rescueBasket","A3PL_Ladder","A3PL_OilBarrel","A3PL_MiniExcavator_Bucket","A3PL_MiniExcavator_Jackhammer","A3PL_MiniExcavator_Claw","A3PL_TapeSign","A3PL_PlasticBarrier_01","A3PL_PlasticBarrier_02","A3PL_Road_Bollard","A3PL_RoadBarrier","A3PL_AAA_Box","A3PL_Corn","A3PL_Marijuana","A3PL_Wheat","A3PL_Lettuce","A3PL_Coco_Plant","A3FL_Carrot_Grow","A3PL_Sugarcane_Plant","A3FL_Tobacco_Plant","A3PL_DeliveryBox","A3PL_Net","A3PL_Stinger","A3PL_Camping_Light","Alsatian_Sand_F","Alsatian_Black_F","Alsatian_Sandblack_F","Land_WoodenTable_small_F","Land_cargo_house_slum_F","Rope","A3PL_Yacht_Pirate","A3PL_Pumpjack","A3PL_OilBarrel","A3PL_Drillhole","A3PL_Ladder","A3PL_FireObject","A3PL_FD_HoseEnd1_Float","A3PL_FD_HoseEnd2_Float","A3PL_FD_HoseEnd2","A3PL_FD_HoseEnd1","A3PL_FD_EmptyPhysx","A3PL_FD_yAdapter","A3PL_FD_HydrantWrench_F","Box_GEN_Equip_F","A3PL_Container_Hook","A3PL_Container_Ship","A3PL_RoadCone_x10","A3PL_RoadCone","Land_A3PL_Tree3","Rabbit_F","A3PL_Grainsack_Malt","A3PL_Grainsack_Yeast","A3PL_Grainsack_CornMeal","A3PL_Distillery","A3PL_Distillery_Hose","A3PL_Jug","A3PL_Jug_Green","Land_A3PL_EstateSign","A3PL_FireHydrant","A3FL_Cannabis_Plant","Land_PortableLight_double_F","Land_Device_slingloadable_F","PortableHelipadLight_01_yellow_F","Land_Pipes_large_F","Land_Tribune_F","Land_RampConcrete_F","Land_Crash_barrier_F","Land_GH_Stairs_F","RoadCone_L_F","RoadBarrier_F","RoadBarrier_small_F","Land_Razorwire_F","Land_Can_Dented_F","O_Heli_Light_02_unarmed_F","SoundSource_4","SoundSource_3","SoundSource_2","SoundSource_1","A3PL_EMS_Stretcher","A3PL_PlasticBarrel","A3PL_Resource_Ore_Iron","A3PL_Resource_Ore_Coal","A3PL_Resource_Ore_Bauxite","A3PL_Resource_Ore_Sulphur","A3PL_Resource_Ore_Sapphire","A3PL_Resource_Ore_Vivianite","A3PL_Resource_Ore_Emerald","A3PL_Resource_Ore_Gold","A3PL_Resource_Ore_Amethyst","A3PL_BucketSand","A3PL_Bucket","A3FL_Banana","A3FL_Carrot","A3FL_Chicken","A3FL_Hoagie","A3FL_CandyCane","A3FL_Donut_Plain","A3FL_Donut_Pink","A3FL_Donut_Chocolate","A3FL_AppleJuice","A3PL_CarltonDraught","A3PL_Coopers","A3PL_Tooheys","A3PL_HamCheeseSanga","A3PL_VegemiteSandwhich","A3FL_Soda","A3FL_Tobacco","A3PL_Garage"];

	{
		if (((_x getVariable ["clean",0]) > 0) && ((Server_Core_DefVehicles find _x) isEqualTo -1)) then
		{
			private ["_class"];
			_skip = false;
			_class = _x getVariable ["class",nil];
			if (!isNil "_class") then
			{
				if (!([_class,"canPickup"] call A3PL_Config_GetItem)) then {_skip = true;};
			};
			if (!_skip) then {_toDelete pushback _x;};
		} else {
			_x setVariable ["clean",1,false];
		};
	} foreach _allMO;
	if(!isNil "A3FL_FireEvent_Wreck" && {!isNull A3FL_FireEvent_Wreck}) then {
		if((serverTime-(A3FL_FireEvent_Wreck getVariable["TimeCreated",serverTime-1800])) >= 1800) then {deleteVehicle A3FL_FireEvent_Wreck};
	};
	{
		if (isNil {_x getVariable ["owner",nil]}) then {
			if ((!isNull (attachedTo _x)) OR (!isNil {_x getVariable ["bItem",nil]}) OR ((typeOf _x) IN _ignore)) then {
				_x setVariable ["clean",nil,false];
			} else {
				deleteVehicle _x;
			};
		};
	} foreach _toDelete;
}] call compile_Server;

["Server_Core_RepairTerrain", {
	{
		if (((damage _x) isEqualTo 1) && {!(_x getVariable["burnt",false])}) then {_x setDamage 0;};
	} foreach nearestTerrainObjects [[6690.16,7330.15,0], [], 10000];
}] call compile_Server;

["Server_Core_Restart", {
	[format [("STR_Server_Core_Restart10m" call A3PL_Localize)],Color_Yellow] remoteExec ["A3PL_Notification", -2];
	[format [("STR_Server_Core_Restart10m" call A3PL_Localize)],Color_Yellow] remoteExec ["A3PL_Notification", -2];
	[format [("STR_Server_Core_Restart10m" call A3PL_Localize)],Color_Yellow] remoteExec ["A3PL_Notification", -2];
	["A3PL_Common\effects\airalarm.ogg",2500,0,10] spawn A3PL_FD_FireStationAlarm;
	call Server_Company_Save;
	0 setRain 1;
	0 setFog [0.3, 0.3, 8];
	setWind [10, 10, true];
	0 setGusts 1;
	0 setOvercast 1;
	0 setLightnings 1;
	forceWeatherChange;
	[4] remoteExec ["BIS_fnc_earthquake",-2];

	for "_i" from 0 to 2 do {
		sleep 140;
		[4] remoteExec ["BIS_fnc_earthquake",-2];
		[format [("STR_Server_Core_RestartFewMinutes" call A3PL_Localize)],Color_Yellow] remoteExec ["A3PL_Notification", -2];
		[format [("STR_Server_Core_RestartFewMinutes" call A3PL_Localize)],Color_Yellow] remoteExec ["A3PL_Notification", -2];
		[format [("STR_Server_Core_RestartFewMinutes" call A3PL_Localize)],Color_Yellow] remoteExec ["A3PL_Notification", -2];
		["A3PL_Common\effects\airalarm.ogg",2500,0,10] spawn A3PL_FD_FireStationAlarm;
	};

	[("STR_Server_Core_Restart" call A3PL_Localize),Color_Yellow] remoteExec ["A3PL_Notification", -2];
	[("STR_Server_Core_Restart" call A3PL_Localize),Color_Yellow] remoteExec ["A3PL_Notification", -2];
	[("STR_Server_Core_Restart" call A3PL_Localize),Color_Yellow] remoteExec ["A3PL_Notification", -2];
	[("STR_Server_Core_Restart" call A3PL_Localize),Color_Yellow] remoteExec ["A3PL_Notification", -2];
	[("STR_Server_Core_Restart" call A3PL_Localize),Color_Yellow] remoteExec ["A3PL_Notification", -2];
	[("STR_Server_Core_Restart" call A3PL_Localize),Color_Yellow] remoteExec ["A3PL_Notification", -2];
	[("STR_Server_Core_Restart" call A3PL_Localize),Color_Yellow] remoteExec ["A3PL_Notification", -2];
	[("STR_Server_Core_Restart" call A3PL_Localize),Color_Yellow] remoteExec ["A3PL_Notification", -2];
	[("STR_Server_Core_Restart" call A3PL_Localize),Color_Yellow] remoteExec ["A3PL_Notification", -2];
	[("STR_Server_Core_Restart" call A3PL_Localize),Color_Yellow] remoteExec ["A3PL_Notification", -2];

    call Server_Core_Save;
	[true] call Server_Stock_ReturnVehicles;
    //[false] spawn Server_Vehicle_Save;
	[true] call Server_Housing_SaveItems;
	[true] call Server_Warehouses_SaveItems;
	[true] call Server_Crackhouses_SaveItems;

	// Stop Web API before restart
	call Server_API_Stop;
	diag_log "[A3PL] Web API stopped before restart";

	sleep 120;

}] call compile_Server;

["Server_Core_Weather", {
	private _chance = random(100);
	
	private _nextWeather = switch(true) do {
		case (_chance < 90): {"sunny"};
		case ((_chance >= 91) && {_chance <= 93}): {"thunder"};
		case ((_chance >= 94) && {_chance <= 97}): {"rainny"};
		case (_chance >= 98): {"foggy"};
	};
	switch(_nextWeather) do {
		case('sunny'): {
			60 setFog 0;
			60 setOvercast 0;
			60 setLightnings 0;
			60 setRain 0;
			60 setWaves 0;
			60 setGusts 0;
			setWind [0, 0, true];
		};
		case('rainny'): {
			60 setFog 0;
			60 setOvercast 0.5;
			60 setLightnings 0;
			60 setRain 0.5;
			60 setWaves 0.3;
			60 setGusts 0.3;
		};
		case('thunder'): {
			60 setFog 0;
			60 setOvercast 1;
			60 setLightnings 1;
			60 setRain 1;
			60 setWaves 0.6;
			60 setGusts 0.5;
		};
		case('foggy'): {
			60 setFog 0.3;
			60 setOvercast 0.8;
			60 setLightnings 0;
			60 setRain 0;
			60 setWaves 0.2;
			60 setGusts 0;
		};
	};

	/* WINTER MODE
	private _nextWeather = switch(true) do {
		case (_chance < 50): {"sunny"};
		case ((_chance >= 50) && {_chance <= 60}): {"thunder"};
		case ((_chance >= 60) && {_chance <= 80}): {"rainny"};
		case (_chance >= 80): {"foggy"};
	};
	switch(_nextWeather) do {
		case('sunny'): {
			60 setFog 0;
			60 setOvercast 0;
			60 setLightnings 0;
			60 setRain 0;
			60 setWaves 0;
			60 setGusts 0;
			setWind [0, 0, true];
		};
		case('rainny'): {
			60 setFog 1; 
			60 setOvercast 1; 
			60 setLightnings 0; 
			60 setRain 0.7; 
			60 setWaves 0.1; 
			60 setGusts 1; 
			setWind [5, 5, false];
		};
		case('thunder'): {
			60 setFog 1; 
			60 setOvercast 1; 
			60 setLightnings 0; 
			60 setRain 1; 
			60 setWaves 0.1; 
			60 setGusts 1; 
			setWind [5, 5, false];
		};
		case('foggy'): {
			60 setFog 1; 
			60 setOvercast 1; 
			60 setLightnings 0; 
			60 setRain 0.5; 
			60 setWaves 0; 
			60 setGusts 0; 
			setWind [0, 0, true];
		};
	};
	*/
	60 setWindDir random(359);
}] call compile_Server;

["Server_Core_Save", {
	call Server_ShopStock_Save;
	call Server_Locker_Save;
	call Server_Police_SeizureSave;
	[] spawn Server_Fuel_Save;
}] call compile_Server;

["Server_Core_SaveFurnitures", {
	[false] call Server_Housing_SaveItems;
	[false] call Server_Warehouses_SaveItems;
	[false] call Server_Crackhouses_SaveItems;
}] call compile_Server;

["Server_Core_RestartTimer", {
	[("STR_Server_Core_Restart1hr" call A3PL_Localize),Color_Yellow] remoteExec ["A3PL_Notification", -2];
	sleep 900;
	[("STR_Server_Core_Restart45mn" call A3PL_Localize),Color_Yellow] remoteExec ["A3PL_Notification", -2];
	sleep 900;
	[("STR_Server_Core_Restart30mn" call A3PL_Localize),Color_Yellow] remoteExec ["A3PL_Notification", -2];
	sleep 600;
	A3PL_soonReboot = true;
	publicVariable "A3PL_soonReboot";
	private _serverLock = "PyAWkhAM76RRxkdS" serverCommand "#lock";
	[("STR_Server_Core_Restart20mn" call A3PL_Localize),Color_Yellow] remoteExec ["A3PL_Notification", -2];
	sleep 600;
	call Server_Core_Restart;
}] call compile_Server;

["Server_Core_RestartLoop", {
    diag_log "[RESTART] Server_Core_RestartLoop called";

    _utcTime = "extDB3" callExtension "9:UTC_TIME";
    if (_utcTime isEqualTo "") then {
        diag_log "[RESTART] ERROR: extDB3 UTC_TIME returned empty string";
    };

    _justTime = (parseSimpleArray _utcTime) select 1;
	private _exit = false;
    if (isNil "_justTime") then {
        diag_log format ["[RESTART] ERROR: Failed to parse UTC_TIME, raw: %1", _utcTime];
    } else {
        _hourMin = [(_justTime select 3) % 24, (_justTime select 4)];
        _currentHour = _hourMin select 0;
        _currentMin = _hourMin select 1;

        if (isNil "Server_Core_RestartTimes") then {
            private _dbResult = ["SELECT hour FROM config_restarts ORDER BY hour ASC", 2, true] call Server_Database_Async;
			if (count _dbResult == 0) exitWith {
				diag_log "[RESTART] No restart times configured in database";
				_exit = true;
			};
            Server_Core_RestartTimes = [];
            {
                Server_Core_RestartTimes pushBack (_x select 0);
            } forEach _dbResult;
            diag_log format ["[RESTART] Loaded restart times from database: %1", Server_Core_RestartTimes];
        };

		if (_exit) exitWith {};

        _restartTimes = if (count Server_Core_RestartTimes > 0) then {Server_Core_RestartTimes} else {[8,20]};

        _nextRestartHour = -1;
        {
            if (_x > _currentHour) then {
                if (_nextRestartHour isEqualTo -1 || _x < _nextRestartHour) then {
                    _nextRestartHour = _x;
                };
            };
        } forEach _restartTimes;

        if (_nextRestartHour isEqualTo -1) then {
            _nextRestartHour = _restartTimes select 0;
        };

        if (isNil "Server_Core_RestartLoop_Initialized") then {
            Server_Core_RestartLoop_Initialized = true;
            _minStr = if (_currentMin < 10) then {format ["0%1", _currentMin]} else {str _currentMin};
            diag_log format ["[RESTART] Server started - Current time: %1h%2 - Next restart at: %3h00", _currentHour, _minStr, _nextRestartHour];
        };

        {
            if ((_currentHour isEqualTo (_x - 1)) && (_currentMin isEqualTo 0)) then {
                [] spawn Server_Core_RestartTimer;
                diag_log format ["[RESTART] Announced Restart At: %1h00", _currentHour];
            };
        } forEach _restartTimes;
    };
}] call compile_Server;

["Server_Core_Lottery", {
	if(isNil "Server_LotteryEntries") exitWith {};
	if (count Server_LotteryEntries == 0) exitWith {
		[("STR_Server_Core_Lottery_Failed" call A3PL_Localize),Color_Yellow] remoteExec ["A3PL_Notification", -2];
		Server_LotteryEntries = [];
		publicVariable "Server_LotteryEntries";
	};
	private _prize = 2500 * count Server_LotteryEntries;

	Server_LotteryEntries call BIS_fnc_arrayShuffle;
	private _winner = selectRandom Server_LotteryEntries;
	private _winnerName = _winner getVariable["name",("STR_Common_Unknown" call A3PL_Localize)];

	[format[("STR_Server_Core_Lottery_Success" call A3PL_Localize),_winnerName,_prize],Color_Yellow] remoteExec ["A3PL_Notification", -2];
	_hasBankAccount = (_winner getVariable ["Player_BankActive",0]) isnotEqualTo 0;
	if (!_hasBankAccount) exitWith {[("STR_Server_Core_Lottery_Looser" call A3PL_Localize),Color_Red] remoteExec ["A3PL_Notification",_winner];};
	private _pBank = _winner getVariable["Player_Bank",0];
	_winner setVariable["Player_Bank",_pBank+_prize,true];
	[getPlayerUID _winner,(_winner getVariable ["character_id",""]),"Lottery_Win",[format ["LOTTERY WIN : %1",_prize]]] call Server_Log_New;
	Server_LotteryEntries = [];
	publicVariable "Server_LotteryEntries";
}] call compile_Server;

["Server_Core_say3D", {
	private _o = _this select 0;
	private _s = _this select 1;
	if(isNil "_o" OR {isNil "_s"}) exitWith {};

	_o say3D _s;
}] call compile_Server;