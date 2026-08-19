/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_HouseRobbery_Rob",
{
	private _building = param [0,objNull];
	private _buildingType = typeOf _building;
	private _buildingRank = "";
	private _buildingSilentChance = 0;

	private _houseCooldown = _building getVariable ["HouseRobCooldown",serverTime - Heist_House_Cooldown];
	private _wHouseCooldown = _building getVariable ["WHouseRobCooldown",serverTime - Heist_House_Warehouse_Cooldown];
	private _cHouseCooldown = _building getVariable ["CHouseRobCooldown",serverTime - Heist_House_Crackhouse_Cooldown];

	private _houseRobCooldown = player getVariable ["HouseRobCooldown",serverTime - Heist_House_Rob_Cooldown];
	private _whouseRobCooldown = player getVariable ["WHouseRobCooldown",serverTime - Heist_House_Rob_Warehouse_Cooldown];
	private _chouseRobCooldown = player getVariable ["CHouseRobCooldown",serverTime - Heist_House_Rob_Crackhouse_Cooldown];

	private _timeToRob = Heist_House_Time_To_Rob;

	private _nearCity = text ((nearestLocations [player, ["NameCityCapital","NameCity","NameVillage"], 5000]) select 0);
	private _cops = [("STR_Common_FISD" call A3PL_Localize)] call A3PL_Lib_FactionPlayers;
	private _attemptAllowed = true;

	if (player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) exitWith {[("STR_Common_CantHeistOnDuty" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (count(_cops) < Heist_House_Min_Cops) exitWith {[format [("STR_A3PL_Heist_Houses_NotEnoughCops" call A3PL_Localize),Heist_House_Min_Cops],Color_Red] call A3PL_Notification;_attemptAllowed = false;};

	private _robberyType = if (_buildingType IN Config_Warehouses_List) then {"Warehouse";} else {if (_buildingType IN Config_Houses_List) then {"House";};if (_buildingType IN Config_Crackhouses_List) then {"Crackhouse";};};


	if (_robberyType isEqualTo "House") then {
		if ((player getVariable ["house",objNull]) isEqualTo _building) exitWith {[("STR_A3PL_Heist_Houses_CannotRobOwnHouse" call A3PL_Localize),Color_Red] call A3PL_Notification;_attemptAllowed = false;};
		if (_houseCooldown > (serverTime - Heist_House_Cooldown)) exitWith {[("STR_A3PL_Heist_Houses_HouseCooldown" call A3PL_Localize),Color_Red] call A3PL_Notification;_attemptAllowed = false;};
		if (_houseRobCooldown > (serverTime - Heist_House_Rob_Cooldown)) exitWith {[("STR_A3PL_Heist_Houses_HouseCooldownPlayer" call A3PL_Localize),Color_Red] call A3PL_Notification;_attemptAllowed = false;};
		[getPlayerUID player,(player getVariable ["character_id",""]),"Robbery_House_Start",[format ["Position: %1",(getPosATL _building)]]] remoteExec ["Server_Log_New",2];
	};

	if (_robberyType isEqualTo "Warehouse") then {
		if ((player getVariable ["warehouse",objNull]) isEqualTo _building) exitWith {[("STR_A3PL_Heist_Houses_CannotRobOwnWarehouse" call A3PL_Localize),Color_Red] call A3PL_Notification;_attemptAllowed = false;};
		if (_wHouseCooldown > (serverTime - Heist_House_Warehouse_Cooldown)) exitWith {[("STR_A3PL_Heist_Houses_WarehouseCooldown" call A3PL_Localize),Color_Red] call A3PL_Notification;_attemptAllowed = false;};
		if (_whouseRobCooldown > (serverTime - Heist_House_Rob_Warehouse_Cooldown)) exitWith {[("STR_A3PL_Heist_Houses_WarehouseCooldownPlayer" call A3PL_Localize),Color_Red] call A3PL_Notification;_attemptAllowed = false;};
		[getPlayerUID player,(player getVariable ["character_id",""]),"Robbery_Warehouse_Start",[format ["Position: %1",(getPosATL _building)]]] remoteExec ["Server_Log_New",2];
	};

	if (_robberyType isEqualTo "Crackhouse") then {
		if ((player getVariable ["crackhouse",objNull]) isEqualTo _building) exitWith {[("STR_A3PL_Heist_Houses_CannotRobOwnCrackhouse" call A3PL_Localize),Color_Red] call A3PL_Notification;_attemptAllowed = false;};
		if (_cHouseCooldown > (serverTime - Heist_House_Crackhouse_Cooldown)) exitWith {[("STR_A3PL_Heist_Houses_CrackhouseCooldown" call A3PL_Localize),Color_Red] call A3PL_Notification;_attemptAllowed = false;};
		if (_chouseRobCooldown > (serverTime - Heist_House_Rob_Crackhouse_Cooldown)) exitWith {[("STR_A3PL_Heist_Houses_CrackhouseCooldownPlayer" call A3PL_Localize),Color_Red] call A3PL_Notification;_attemptAllowed = false;};
		[getPlayerUID player,(player getVariable ["character_id",""]),"Robbery_Crackhouse_Start",[format ["Position: %1",(getPosATL _building)]]] remoteExec ["Server_Log_New",2];
	};

	if (!_attemptAllowed) exitWith {};

	if (_buildingType IN Heist_House_Buildings_Type_Shed) then {
		_buildingRank = "Shed";
		_buildingSilentChance = Heist_House_ChanceSilentAlarm_Shed;
	};
	if (_buildingType IN Heist_House_Buildings_Type_Trailer) then {
		_buildingRank = "Trailer";
		_buildingSilentChance = Heist_House_ChanceSilentAlarm_Trailer;
	};
	if (_buildingType IN Heist_House_Buildings_Type_SingleStory) then {
		_buildingRank = "Single Story";
		_buildingSilentChance = Heist_House_ChanceSilentAlarm_SingleStory;
	};
	if (_buildingType IN Heist_House_Buildings_Type_TwoStory) then {
		_buildingRank = "Two Story";
		_buildingSilentChance = Heist_House_ChanceSilentAlarm_TwoStory;
	};
	if (_buildingType IN Heist_House_Buildings_Type_SmallMansion) then {
		_buildingRank = "Small Mansion";
		_buildingSilentChance = Heist_House_ChanceSilentAlarm_SmallMansion;
	};
	if (_buildingType IN Heist_House_Buildings_Type_BigMansion) then {
		_buildingRank = "Big Mansion";
		_buildingSilentChance = Heist_House_ChanceSilentAlarm_BigMansion;
	};
	if (_buildingType IN Heist_House_Buildings_Type_Warehouse) then {
		_buildingRank = "Warehouse";
		_buildingSilentChance = Heist_House_ChanceSilentAlarm_Warehouse;
	};
	if (_buildingType IN Heist_House_Buildings_Type_Crackhouse) then {
		_buildingRank = "Crackhouse";
		_buildingSilentChance = Heist_House_ChanceSilentAlarm_Crackhouse;
	};

	private _isBeingRobbed = _building getVariable["isBeingRobbed",false];
	if (_isBeingRobbed) exitWith {[("STR_A3PL_Heist_Houses_RobberyAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _silentAlarmChance = random 100;

	if (_silentAlarmChance >= _buildingSilentChance) then {
		[_building] spawn A3pl_HouseRobbery_AlarmSilent;
	};

	[_building] spawn A3PL_HouseRobbery_AlarmVerbal;

	player playMove "Acts_carFixingWheel";
	player setVariable ["isLockpicking",true,true];
	_building setVariable ["isBeingRobbed",true,true];

	[_building,_buildingRank,_timeToRob,_robberyType] spawn
	{
		private _building = param [0,objNull];
		private _buildingRank = param [1,"Shed"];
		private _timeToRob = param [2,1];
		private _robberyType = param [3,"House"];
		private _robSuccess = true;
		if (Player_ActionDoing) exitWith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		[("STR_Common_LockpickingInProgress" call A3PL_Localize),_timeToRob] spawn A3PL_Lib_LoadActionQTE;
		waitUntil{Player_ActionDoing};
		while {Player_ActionDoing} do {
			if ((player getVariable ["Cuffed",false]) || (player getVariable ["Zipped",false])) exitWith {};
			if (!((vehicle player) isEqualTo player)) exitwith {_robSuccess = false;};
			if (player getVariable ["Incapacitated",false]) exitwith {_robSuccess = false;};
			if (!(player_itemClass isEqualTo "v_lockpick")) exitwith {_robSuccess = false;};
			if (!(["v_lockpick",1] call A3PL_Inventory_Has)) exitwith {_robSuccess = false;};
			if (animationState player != "Acts_carFixingWheel") then {player playmove "Acts_carFixingWheel";}
		};
		player setVariable ["isLockpicking",false,true];
		player switchMove "";
		if (Player_ActionInterrupted || !(_robSuccess)) exitWith {
			[("STR_Common_LockpickingFailed" call A3PL_Localize),Color_Red] call A3PL_Notification;
			if (_robberyType isEqualTo "House") then {
				[getPlayerUID player,(player getVariable ["character_id",""]),"Robbery_House_Cancel",[format ["Position: %1",(getPosATL _building)]]] remoteExec ["Server_Log_New",2];
			};
			if (_robberyType isEqualTo "Warehouse") then {
				[getPlayerUID player,(player getVariable ["character_id",""]),"Robbery_Warehouse_Cancel",[format ["Position: %1",(getPosATL _building)]]] remoteExec ["Server_Log_New",2];
			};
			if (_robberyType isEqualTo "Crackhouse") then {
				[getPlayerUID player,(player getVariable ["character_id",""]),"Robbery_Crackhouse_Cancel",[format ["Position: %1",(getPosATL _building)]]] remoteExec ["Server_Log_New",2];
			};
		};

		[player_item] call A3PL_Inventory_Clear;
		[player,"v_lockpick",-1] remoteExec ["Server_Inventory_Add",2];
		_building setVariable ["isBeingRobbed",false,true];

		private _random = random 100;
		private _pickingChance = Heist_House_Lockpick_Chance;
		if(_random > _pickingChance) exitWith {
			[("STR_Common_LockpickingFailed" call A3PL_Localize),Color_Red] call A3PL_Notification;
		};
		[("STR_A3PL_Heist_Houses_LockpickingSuccess" call A3PL_Localize),Color_Green] call A3PL_Notification;

		[_building,_buildingRank,_robberyType,("STR_Common_FISD" call A3PL_Localize)] call A3PL_HouseRobbery_Success;
	};
}] call compile_Global;

["A3PL_HouseRobbery_AlarmSilent",
{
	private _building = param [0,objNull];
	private _cops = [_faction] call A3PL_Lib_FactionPlayers;
	private _buildingPos = [getPos _building] call A3PL_Housing_PosAddress;

	[("STR_Common_FISD" call A3PL_Localize),("STR_A3PL_Heist_Houses_Robbery" call A3PL_Localize),getPos _building,format[("STR_A3PL_Heist_Houses_RobberyReported" call A3PL_Localize),_buildingPos],("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
	[_building,format[" %1",("STR_A3PL_Heist_Houses_Robbery" call A3PL_Localize)],"ColorWHITE","A3FL_Markers_911Call"] remoteExec ["A3PL_Lib_CreateMarker",_cops];
	[getPos _building] remoteExec ["A3PL_GPS_NavigateToPosition",_cops];

}] call compile_Global;

["A3PL_HouseRobbery_AlarmVerbal",
{
	private _building = param [0,objNull];
	private _y = 60;
	while {_y > 0} do {
		playSound3D ["A3\Sounds_F\sfx\alarmCar.wss", _building, true, _building, 3, 1, 400];
		uiSleep 2;
		_y = _y - 1;
	};
}] call compile_Global;

["A3PL_HouseRobbery_AlertLEO",
{
	private _building = param [0,objNull];
	private _faction = param [1,("STR_Common_FISD" call A3PL_Localize)];
	private _cops = [_faction] call A3PL_Lib_FactionPlayers;
	private _buildingPos = [getPos _building] call A3PL_Housing_PosAddress;

	[_faction,("STR_A3PL_Heist_Houses_Robbery" call A3PL_Localize),getPos _building,format[("STR_A3PL_Heist_Houses_RobberyReported" call A3PL_Localize),_buildingPos],("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
	[_building," Cambriolage","ColorWHITE","A3FL_Markers_911Call"] remoteExec ["A3PL_Lib_CreateMarker",_cops];
	[getPos _building] remoteExec ["A3PL_GPS_NavigateToPosition",_cops];
}] call compile_Global;

["A3PL_HouseRobbery_Success",
{
	private _building = param [0,objNull];
	private _buildingRank = param [1,"Shed"];
	private _robberyType = param [2,"House"];
	private _faction = param [2,("STR_Common_FISD" call A3PL_Localize)];
	private _leos = [_faction] call A3PL_Lib_FactionPlayers;
	private _leoCount = count _leos;

	private _basicPulls = (floor (_leoCount / 1)) + 4;
	private _valuablePulls = (floor (_leoCount / 2)) + 2;
	private _rarePulls = (floor (_leoCount / 3));

	private _virtualItems = [];
	private _physicalItems = [];

	private _basicItems = [];
	private _valuableItems = [];
	private _rareItems = [];
	private _weaponItems = [];

	if (_robberyType isEqualTo "House") then {
		_building setVariable ["HouseRobCooldown",serverTime,true];
		player setVariable ["HouseRobCooldown",serverTime,true];
	};
	if (_robberyType isEqualTo "Warehouse") then {
		_building setVariable ["WHouseRobCooldown",serverTime,true];
		player setVariable ["WHouseRobCooldown",serverTime,true];
	};
	if (_robberyType isEqualTo "Crackhouse") then {
		_building setVariable ["CHouseRobCooldown",serverTime,true];
		player setVariable ["CHouseRobCooldown",serverTime,true];
	};
	_building setVariable ["robbed",true,true];
	_building setVariable ["unlocked",true,true];

	if (_buildingRank isEqualTo "Shed") then {
		_basicItems = Heist_House_Reward_basicItems_Shed;
		_valuableItems = Heist_House_Reward_valuableItems_Shed;
		_rareItems = Heist_House_Reward_rareItems_Shed;
	};
	if (_buildingRank isEqualTo "Trailer") then {
		_basicItems = Heist_House_Reward_basicItems_Trailer;
		_valuableItems = Heist_House_Reward_valuableItems_Trailer;
		_rareItems = Heist_House_Reward_rareItems_Trailer;
	};
	if (_buildingRank isEqualTo "Single Story") then {
		_basicItems = Heist_House_Reward_basicItems_SingleStory;
		_valuableItems = Heist_House_Reward_valuableItems_SingleStory;
		_rareItems = Heist_House_Reward_rareItems_SingleStory;
		_weaponItems = selectRandom Heist_House_Reward_Random_Weapons_SingleStory;
	};
	if (_buildingRank isEqualTo "Two Story") then {
		_basicItems = Heist_House_Reward_basicItems_TwoStory;
		_valuableItems = Heist_House_Reward_valuableItems_TwoStory;
		_weaponItems = selectRandom Heist_House_Reward_Random_Weapons_TwoStory;
	};
	if (_buildingRank isEqualTo "Small Mansion") then {
		_basicItems = Heist_House_Reward_basicItems_SmallMansion;
		_valuableItems = Heist_House_Reward_valuableItems_SmallMansion;
		_weaponItems = selectRandom Heist_House_Reward_Random_Weapons_SmallMansion;
	};
	if (_buildingRank isEqualTo "Big Mansion") then {
		_basicItems = Heist_House_Reward_basicItems_BigMansion;
		_valuableItems = Heist_House_Reward_valuableItems_BigMansion;
		_weaponItems = selectRandom Heist_House_Reward_Random_Weapons_BigMansion;
	};
	if (_buildingRank isEqualTo "Warehouse") then {
		_basicItems = Heist_House_Reward_basicItems_Warehouse;
		_valuableItems = Heist_House_Reward_valuableItems_Warehouse;
		_rareItems = Heist_House_Reward_rareItems_Warehouse;
	};
	if (_buildingRank isEqualTo "Crackhouse") then {
		_basicItems = Heist_House_Reward_basicItems_Crackhouse;
		_valuableItems = Heist_House_Reward_valuableItems_Crackhouse;
		_rareItems = Heist_House_Reward_rareItems_Crackhouse;
	};

	for "_i" from 0 to _basicPulls do {
		_item = selectRandom _basicItems;
		_virtualItems = [_virtualItems, _item select 0, _item select 1, true] call BIS_fnc_addToPairs;
	};
	for "_i" from 0 to _valuablePulls do {
		_item = selectRandom _valuableItems;
		_virtualItems = [_virtualItems, _item select 0, _item select 1, true] call BIS_fnc_addToPairs;
	};
	if (_rareItems isNotEqualTo []) then {
		for "_i" from 0 to _rarePulls do {
		_item = selectRandom _rareItems;
		_virtualItems = [_virtualItems, _item select 0, _item select 1, true] call BIS_fnc_addToPairs;
		};
	};

	_physicalItems pushBack _weaponItems;

	_lootCrate = createVehicle ["Land_MetalCase_01_medium_F", [(getPosATL _building select 0),(getPosATL _building select 1),1.2], [], 0, "CAN_COLLIDE"];
	_lootCrate setVariable["storage",_virtualItems,true];
	_lootCrate setVariable["capacity",2000,true];
	{_lootCrate addItemCargoGlobal _x;} forEach _physicalItems;
	if (_robberyType isEqualTo "House") then {
		[getPlayerUID player,(player getVariable ["character_id",""]),"Robbery_House_Success",[format ["Position: %1 | Virtual Items: %2 | Physical Items: %3",(getPosATL _building),str(_virtualItems),str(_physicalItems)]]] remoteExec ["Server_Log_New",2];
	};
	if (_robberyType isEqualTo "Warehouse") then {
		[getPlayerUID player,(player getVariable ["character_id",""]),"Robbery_Warehouse_Success",[format ["Position: %1 | Virtual Items: %2 | Physical Items: %3",(getPosATL _building),str(_virtualItems),str(_physicalItems)]]] remoteExec ["Server_Log_New",2];
	};
	if (_robberyType isEqualTo "Crackhouse") then {
		[getPlayerUID player,(player getVariable ["character_id",""]),"Robbery_Crackhouse_Success",[format ["Position: %1 | Virtual Items: %2 | Physical Items: %3",(getPosATL _building),str(_virtualItems),str(_physicalItems)]]] remoteExec ["Server_Log_New",2];
	};
	[_building,_faction] call A3PL_HouseRobbery_AlertLEO;
}] call compile_Global;

["A3PL_HouseRobbery_Secure",
{
	private _building = param [0,objNull];
	private _box = _building nearEntities [["Land_MetalCase_01_medium_F"],20];
	{deleteVehicle _x;} forEach _box;
	_building setVariable ["unlocked",Nil,true];
	for "_i" from 1 to 8 do {[_building,format["Door_%1",_i],false,0] call A3PL_Lib_ToggleAnimation;};
	[("STR_A3PL_Heist_Houses_Secured" call A3PL_Localize),Color_Green] call A3PL_Notification;
	_building setVariable ["robbed",false,true];
}] call compile_Global;
