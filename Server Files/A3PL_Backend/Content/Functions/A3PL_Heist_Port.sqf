/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/

["A3PL_Robberies_Port", {
	params [["_port",player_objintersect,[objNull]]];

	private _weapon = currentWeapon player;
	private _weaponName = getText (configFile >> "CfgWeapons" >> _weapon >> "displayName");
	private _RobberVolume = 0;
	private _duration = switch(true) do {
		case (_weapon IN Heist_Port_Weapons_Type1): {Heist_Port_Weapons_Type1_Duration};
		case (_weapon IN Heist_Port_Weapons_Type2): {Heist_Port_Weapons_Type2_Duration};
		case (_weapon IN Heist_Port_Weapons_Type3): {Heist_Port_Weapons_Type3_Duration};
		case (_weapon IN Heist_Port_Weapons_Type4): {Heist_Port_Weapons_Type4_Duration};
		default {Heist_Port_Weapons_Default_Duration};
	};

	private _portCooldown = _port getVariable ["PortCooldown",serverTime - Heist_Port_Cooldown];
	private _portRobCooldown = player getVariable ["PortRobCooldown",serverTime - Heist_Port_Rob_Cooldown];
	private _isSecured = (serverTime - (_port getVariable["secured",0])) < Heist_Port_Cooldown;

	if (_portCooldown > (serverTime - Heist_Port_Cooldown)) exitWith {[("STR_A3PL_Heist_Port_AlreadyRobbedRecently" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_portRobCooldown > (serverTime - Heist_Port_Rob_Cooldown)) exitWith {[("STR_A3PL_Heist_Port_AlreadyRobbedRecentlyPlayer" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_isSecured) exitWith {[("STR_A3PL_Heist_Port_PortSecured" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if (player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) exitWith {[("STR_Common_CantHeistOnDuty" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((currentWeapon player) isEqualTo "") exitwith {[("STR_Common_NoWeaponEquipped" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _sdCount = count ([("STR_Common_FISD" call A3PL_Localize)] call A3PL_Lib_FactionPlayers);
	if (_sdCount < Heist_Port_Min_Cops) exitWith {[format[("STR_A3PL_Heist_Port_MinCopsToRob" call A3PL_Localize),Heist_Port_Min_Cops],Color_Red] call A3PL_Notification;};

	private _isBeingRobbed = _port getVariable ["isBeingRobbed",false];
	if (_isBeingRobbed) exitWith {[("STR_A3PL_Heist_Port_AlreadyBeingRobbed" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _namePos = switch(_port) do {
		case npc_port_1: {"Stoney Creek"};
		case npc_port_2: {("STR_Common_FactoryName_Steel" call A3PL_Localize)};
		case npc_port_3: {"Elk City"};
		case npc_port_4: {("STR_Common_WeaponFactory" call A3PL_Localize)};
		case npc_port_5: {("STR_Common_MarineFactory" call A3PL_Localize)};
		case npc_port_7: {"King Landings"};
		case npc_port_8: {("STR_A3PL_Heist_Port_SilvertonPort" call A3PL_Localize)};
		default {("STR_Common_UnknownLocation" call A3PL_Localize)};
	};

	[("STR_Common_FISD" call A3PL_Localize),("STR_A3PL_Heist_Port_Robbery" call A3PL_Localize),getPos player,format[("STR_A3PL_Heist_Port_RobberyReported" call A3PL_Localize),_namePos],("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];

	private _durationBoost = switch(_port) do {
		case npc_port_1: {10};
		case npc_port_2: {0};
		case npc_port_3: {-15};
		case npc_port_4: {20};
		case npc_port_5: {10};
		case npc_port_7: {15};
		case npc_port_8: {20};
		default {0};
	};

	private _timeToRob = _duration + _durationBoost;

	_port setVariable ["isBeingRobbed",true,true];
	_port setVariable ["weaponUsed",_weaponName,true];

	private _nearVehicles = nearestObjects [player, ["Car"],30];
	private _nearVehicle = if (count _nearVehicles > 0) then {_nearVehicles#0} else {objNull};
	private _vehName = if (!isNull _nearVehicle) then {
		getText (configFile >> "CfgVehicles" >> typeOf _nearVehicle >> "displayName")
	} else {
		("STR_Common_Unknown" call A3PL_Localize)
	};
	_port setVariable ["nearVehicle",_vehName,true];

	private _clothesWorn = getText (configFile >> "CfgWeapons" >> uniform player >> "displayName");
	_port setVariable ["clothingWorn",_clothesWorn,true];

	[getPlayerUID player,(player getVariable ["character_id",""]),"Robbery_Port_Start",[format ["Port: %1 | Position: %2 | Weapon: %3",_port,(getPosATL _port),_weapon]]] remoteExec ["Server_Log_New",2];
	if (Player_ActionDoing) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[("STR_A3PL_Heist_Port_RobberyInProgress" call A3PL_Localize),_timeToRob] spawn A3PL_Lib_LoadActionQTE;
	waitUntil {Player_ActionDoing};
	while {Player_ActionDoing} do {
		if ((player distance2D _port) > 5) exitWith {Player_ActionInterrupted = true;};
		if (!(vehicle player isEqualTo player)) exitwith {Player_ActionInterrupted = true;};
		if (player getVariable ["Incapacitated",false]) exitwith {Player_ActionInterrupted = true;};
		if ((currentWeapon player) isEqualTo "") exitWith {Player_ActionInterrupted = true;};
		_RobberVolume = (call TFAR_fnc_ActiveSwRadio) call TFAR_fnc_getSwVolume;
		if ((player call TFAR_fnc_isSpeaking) && (_RobberVolume > Heist_Store_Minimum_Level_Speaking)) then {_duration = _duration - Heist_Store_Reduction_Speak_Cooldown;};
		private _shotsFired = 0;
		player addEventHandler ["Fired", {
			_shotsFired = _shotsFired + 1;
			_duration = _duration - Heist_Store_Reduction_Shooting;
		}];
	};
	if(Player_ActionInterrupted) exitWith {
		_port setVariable ["isBeingRobbed",false,true];
		_port setVariable["stolenGoods","Nothing",true];
		[("STR_A3PL_Heist_Port_RobberyCanceled" call A3PL_Localize),Color_Red] call A3PL_Notification;
		[getPlayerUID player,(player getVariable ["character_id",""]),"Robbery_Port_Cancel",[format ["Port: %1 | Position: %2 | Weapon: %3",_port,(getPosATL _port),_weapon]]] remoteExec ["Server_Log_New",2];
		player removeAllEventHandlers "Fired";
	};

	[("STR_A3PL_Heist_Port_RobberySuccess" call A3PL_Localize),Color_Green] call A3PL_Notification;
	[("STR_A3PL_Heist_Port_RobberyLoot" call A3PL_Localize),Color_Yellow] call A3PL_Notification;
	player removeAllEventHandlers "Fired";
	[_port] call A3PL_Robberies_PortReward;
	_port setVariable ["isBeingRobbed",false,true];
	_port setVariable ["PortCooldown",serverTime,true];
	player setVariable ["PortRobCooldown",serverTime,true];
}] call compile_Global;

["A3PL_Robberies_PortReward", {
	params [["_port",player_objintersect,[objNull]]];

	private _sdCount = count ([("STR_Common_FISD" call A3PL_Localize)] call A3PL_Lib_FactionPlayers);
	private _itemsArray = Heist_Port_Items_Reward;
	private _weaponsArray = Heist_Port_Weapons_Reward;
	private _magsArray = Heist_Port_Magazines_Reward;

	if (_sdCount >= 3) then {
		private _bonusItems = Heist_Port_BonusItems_Cops_Superior_Or_Egal_3_Reward;
		_itemsArray append _bonusItems;
		private _bonusWeapons = Heist_Port_BonusWeapons_Cops_Superior_Or_Egal_3_Reward;
		_weaponsArray append _bonusWeapons;
	};
	if (_sdCount >= 5) then {
		private _bonusItems = Heist_Port_BonusItems_Cops_Superior_Or_Egal_5_Reward;
		_itemsArray append _bonusItems;
		private _bonusWeapons = Heist_Port_BonusWeapons_Cops_Superior_Or_Egal_5_Reward;
		_weaponsArray append _bonusWeapons;
		private _bonusMags = Heist_Port_BonusMagazines_Cops_Superior_Or_Egal_5_Reward;
		_magsArray append _bonusMags;
	};
	if (_sdCount >= 7) then {
		private _bonusItems = Heist_Port_BonusItems_Cops_Superior_Or_Egal_7_Reward;
		_itemsArray append _bonusItems;
	};
	private _rewardArray = [];
	private _rewardString = "";

	private _rewardPulls = (floor (_sdCount / 2)) + 3 + (round(random 4));
	for "_i" from 0 to _rewardPulls do {
		_rewardArray pushBack (selectRandom _itemsArray);
	};
	if (_sdCount >= 3) then {
		_rewardArray pushBack (selectRandom _weaponsArray);
		if (_magsArray isNotEqualTo []) then {
			_rewardArray pushBack (selectRandom _magsArray);
		};
	};

	{
		private _type = _x select 0;
		private _class = _x select 1;
		private _maxAmount = _x select 2;
		private _amount = 1;
		private _enoughtSpace = "";
		private _weaponholder = objNull;
		if (_class isEqualTo "cash") then {
			_amount = _maxAmount;
		} else {
			_amount = 1 + round(random _maxAmount);
		};
		switch(_type) do {
			case("item"): {
				_enoughtSpace = (([[_class,_amount]] call A3PL_Inventory_TotalWeight) <= Player_MaxWeight);
				if(_enoughtSpace) then {
					[_class,_amount] call A3PL_Inventory_Add;
				} else {
					_obj = _itemClass createVehicle (getPos player);
					_obj setPosASL (AGLtoASL (player modelToWorld [0,1,0]));
				};
				if(_rewardString isEqualTo "") then {
					_rewardString = format["%1x %2",_amount,[_class,"name"] call A3PL_Config_GetItem];
				} else {
					_rewardString = _rewardString + format[", %1x %2",_amount,[_class,"name"] call A3PL_Config_GetItem];
				};
			};
			case("weapon"): {
				_nearby = nearestObjects [player, ["GroundWeaponHolder"], 10];
				if ((count _nearby) < 1) then {
					_weaponHolder = createVehicle ["GroundWeaponHolder", getposATL player, [], 0, "CAN_COLLIDE"];
				} else {
					_weaponHolder = _nearby#0;
				};
				_weaponHolder addWeaponCargoGlobal [_class,1];
				if(_rewardString isEqualTo "") then {
					_rewardString = format["%1x %2",_amount,getText (configFile >> "CfgWeapons" >> _class >> "displayName")];
				} else {
					_rewardString = _rewardString + format[", %1x %2",_amount, getText (configFile >> "CfgWeapons" >> _class >> "displayName")];
				};
			};
			case("magazine"): {
				_nearby = nearestObjects [player, ["GroundWeaponHolder"], 10];
				if ((count _nearby) < 1) then {
					_weaponHolder = createVehicle ["GroundWeaponHolder", getposATL player, [], 0, "CAN_COLLIDE"];
				} else {
					_weaponHolder = _nearby#0;
				};
				_weaponHolder addMagazineCargoGlobal [_class,_amount];
				if(_rewardString isEqualTo "") then {
					_rewardString = format["%1x %2",_amount,getText (configFile >> "CfgMagazines" >> _class >> "displayName")];
				} else {
					_rewardString = _rewardString + format[", %1x %2",_amount,getText (configFile >> "CfgMagazines" >> _class >> "displayName")];
				};
			};
		};
	} foreach _rewardArray;

	_port setVariable["stolenGoods",_rewardString,true];
	[getPlayerUID player,(player getVariable ["character_id",""]),"Robbery_Port_Success",[format ["Port: %1 | Position: %2 | Reward: %3",_port,getPosATL _port,_rewardString]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

["A3PL_Robberies_PortQuestion", {
	params [["_port",player_objintersect,[objNull]]];

	private _stolenGoods = _port getVariable["stolenGoods","Nothing"];
	private _weaponUsed = _port getVariable["weaponUsed","Unknown"];
	private _falseAlarmStatus = _port getVariable["falseAlarm",""];
	if (_falseAlarmStatus isEqualTo "notStarted") exitWith {
		[("STR_A3PL_Heist_Port_FalseAlarm" call A3PL_Localize),Color_Yellow] call A3PL_Notification;
		_port setVariable["falseAlarm","",true];
	};
	if(_stolenGoods isEqualTo "Nothing" && {_weaponUsed isEqualTo "Unknown"}) exitWith {[("STR_Common_NoRecentRobbery" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _rand = floor (random 2);
	if (_rand isEqualTo 0) then {
		private _clothes = _port getVariable ["clothingWorn","Unknown"];
		[format [("STR_Common_SuspectSeen" call A3PL_Localize),_clothes],Color_Blue] call A3PL_Notification;
	};
	if (_rand isEqualTo 1) then {
		private _veh = _port getVariable ["nearVehicle","Unknown"];
		[format [("STR_Common_VehicleSpotted" call A3PL_Localize),_veh],Color_Blue] call A3PL_Notification;
	};

	[format [("STR_Common_StolenGoods" call A3PL_Localize),_stolenGoods],Color_Blue] call A3PL_Notification;
	[format [("STR_Common_WeaponDescription" call A3PL_Localize),_weaponUsed],Color_Blue] call A3PL_Notification;
	[("STR_Common_SheriffsDepartment" call A3PL_Localize),Heist_Port_Questions_Reward] remoteExec ["Server_Government_AddBalance",2];
}] call compile_Global;