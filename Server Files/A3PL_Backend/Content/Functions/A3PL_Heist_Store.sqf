/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/

["A3PL_Robberies_Store", {
	params [["_store",objNull,[objNull]]];

	private _storeType = ("STR_A3PL_Heist_Store_FuelStation" call A3PL_Localize); 
	private _faction = Heist_Store_Faction_Required;
	private _leos = [_faction] call A3PL_Lib_FactionPlayers;
	private _weapon = currentWeapon player;
	private _weaponName = getText (configFile >> "CfgWeapons" >> _weapon >> "displayName");
	private _timeElapsed = 0;
	private _RobberVolume = 0;
	private _robbedTime = missionNamespace getVariable ["GasCooldown",serverTime-Heist_Store_Cooldown];
	private _isSecured = (serverTime - (_store getVariable["secured",0])) < Heist_Store_Cooldown_Secure;
	private _duration = switch(true) do {
		case (_weapon IN Heist_Store_Type1): {Heist_Store_Type1_Duration};
		case (_weapon IN Heist_Store_Type2): {Heist_Store_Type2_Duration};
		case (_weapon IN Heist_Store_Type3): {Heist_Store_Type3_Duration};
		case (_weapon IN Heist_Store_Type4): {Heist_Store_Type4_Duration};
		default {Heist_Store_Default_Duration};
	};
	
	if (player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) exitWith {[("STR_Common_CantHeistOnDuty" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_store IN [npc_fuel_1,npc_fuel_3,npc_fuel_4,npc_fuel_6,npc_fuel_7,npc_fuel_8,npc_fuel_9,npc_fuel_10]) then {
		_storeType = ("STR_A3PL_Heist_Store_FuelStation" call A3PL_Localize); _robbedTime = missionNamespace getVariable ["GasCooldown",serverTime-Heist_Store_Cooldown];};
	if (_store IN [npc_mcfisher,npc_mcfisher_1,npc_mcfisher_2,npc_mcfisher_3,npc_mcfisher_5,npc_mcfisher_6]) then {
		_storeType = "McFishers"; _robbedTime = missionNamespace getVariable ["McFishersCooldown",serverTime-Heist_Store_Cooldown];};
	if (_store IN [npc_tacohell_1,npc_tacohell_3]) then {
		_storeType = "Taco Hell"; _robbedTime = missionNamespace getVariable ["TacoHellCooldown",serverTime-Heist_Store_Cooldown];};
	if (_store IN [Robbable_Shop_1,Robbable_Shop_2,Robbable_Shop_4,Robbable_Shop_6,Robbable_Shop_7,Robbable_Shop_8,Robbable_Shop_9,Robbable_Shop_10]) then {
		_storeType = ("STR_A3PL_Heist_Store_RobbableShop" call A3PL_Localize); _robbedTime = missionNamespace getVariable ["StoreCooldown",serverTime-Heist_Store_Cooldown];}; 

	if (_isSecured) exitWith {[("STR_A3PL_Heist_Store_Secured" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if (_robbedTime > (serverTime-Heist_Store_Cooldown)) exitWith {[("STR_A3PL_Heist_Store_RecentlyRobbed" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if (_weapon isEqualTo "") exitwith {[("STR_Common_NoWeaponEquipped" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if (_weapon IN Cant_Rob_With_This) exitwith {[("STR_Common_InvalidWeapon" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if((count(_leos)) < Heist_Store_Min_Cops) exitWith {[format [("STR_A3PL_Heist_Store_MinCopsToRob" call A3PL_Localize),_faction,Heist_Store_Min_Cops],Color_Red] call A3PL_Notification;};

	private _isBeingRobbed = _store getVariable ["isBeingRobbed",false];
	if (_isBeingRobbed) exitWith {[("STR_A3PL_Heist_Store_AlreadyBeingRobbed" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	[getPlayerUID player,(player getVariable ["character_id",""]),"Robbery_Store_Start",[format ["Type: %1 | Weapon: %2 | Position: %3",_storeType,_weapon,(getPosATL player)]]] remoteExec ["Server_Log_New",2];
	[("STR_A3PL_Heist_Store_RobberyInProgress" call A3PL_Localize),Color_Green] call A3PL_Notification;
	playSound3D ["A3PL_Common\effects\burglaralarm.ogg", _store, false, getPosASL _store, 1, 1, 200];

	private _namePos = [getPos _store] call A3PL_Housing_PosAddress;
	[_store,("STR_Common_AlarmTriggered" call A3PL_Localize),"ColorWhite","A3FL_Markers_911Call"] remoteExec ["A3PL_Lib_CreateMarker",_leos];
	[getPos _store] remoteExec ["A3PL_GPS_NavigateToPosition",_leos];
	[_faction,("STR_A3PL_Heist_Store_Robbery" call A3PL_Localize),getPos _store,format[("STR_A3PL_Heist_Store_RobberyReported" call A3PL_Localize),_namePos],("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];

	private _nearVehicles = nearestObjects [player, ["Car"],30];
	private _nearVehicle = if (count _nearVehicles > 0) then {_nearVehicles#0} else {objNull};
	private _vehName = if (!isNull _nearVehicle) then {
		getText (configFile >> "CfgVehicles" >> typeOf _nearVehicle >> "displayName")
	} else {
		("STR_Common_Unknown" call A3PL_Localize)
	};
	_store setVariable ["nearVehicle",_vehName,true];

	private _clothesWorn = getText (configFile >> "CfgWeapons" >> uniform player >> "displayName");
	_store setVariable ["clothingWorn",_clothesWorn,true];

	_store setVariable["weaponUsed",_weaponName,true];
	_store setVariable ["isBeingRobbed",true,true];
	if (Player_ActionDoing) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	missionNamespace setVariable ["Heist_Duration", _duration];
	[("STR_A3PL_Heist_Store_RobberyInProgressPlayer" call A3PL_Localize),_duration] spawn A3PL_Lib_LoadActionQTE;
	waitUntil{Player_ActionDoing};

	while {Player_ActionDoing} do {
        if ((player distance2D _store) > 15) exitwith {Player_ActionInterrupted = true;};
        if (!(vehicle player isEqualTo player)) exitwith {Player_ActionInterrupted = true;};
        if (player getVariable ["Incapacitated", false]) exitwith {Player_ActionInterrupted = true;};
        if ((currentWeapon player) isEqualTo "") exitwith {Player_ActionInterrupted = true;};

        private _RobberVolume = (call TFAR_fnc_ActiveSwRadio) call TFAR_fnc_getSwVolume;
        if ((player call TFAR_fnc_isSpeaking) && (_RobberVolume > Heist_Store_Minimum_Level_Speaking)) then {
            private _currentDur = missionNamespace getVariable ["Heist_Duration", _duration];
            missionNamespace setVariable ["Heist_Duration", _currentDur - Heist_Store_Reduction_Speak_Cooldown];
        };

        player addEventHandler ["Fired", {
            private _currentDur = missionNamespace getVariable ["Heist_Duration", _duration];
            missionNamespace setVariable ["Heist_Duration", _currentDur - Heist_Store_Reduction_Shooting];
        }];

        sleep 0.5;
    };

	if(Player_ActionInterrupted) exitWith {
		_store setVariable["stolenGoods","Nothing",true];
		_store setVariable ["isBeingRobbed",false,true];
		[("STR_A3PL_Heist_Store_RobberyCanceled" call A3PL_Localize),Color_Red] call A3PL_Notification;
		[getPlayerUID player,(player getVariable ["character_id",""]),"Robbery_Store_Cancel",[format ["Type: %1 | Weapon: %2 | Position: %3",_storeType,_weapon,(getPosATL player)]]] remoteExec ["Server_Log_New",2];
		player removeAllEventHandlers "Fired";
	};

	[("STR_A3PL_Heist_Store_RobberySuccess" call A3PL_Localize),Color_Green] call A3PL_Notification;
	[_storeType,_store,_faction,_weaponName] call A3PL_Robberies_StoreReward;
	_store setVariable ["isBeingRobbed",false,true];
	player removeAllEventHandlers "Fired";

	if (_storeType isEqualTo ("STR_A3PL_Heist_Store_FuelStation" call A3PL_Localize)) then {
		missionNamespace setVariable ["GasCooldown",serverTime,true];
	};
	if (_storeType isEqualTo "McFishers") then {
		missionNamespace setVariable ["McFishersCooldown",serverTime,true];
	};
	if (_storeType isEqualTo "Taco Hell") then {
		missionNamespace setVariable ["TacoHellCooldown",serverTime,true];
	};
	if (_storeType isEqualTo ("STR_A3PL_Heist_Store_RobbableShop" call A3PL_Localize)) then {
		missionNamespace setVariable ["StoreCooldown",serverTime,true];
	};
}] call compile_Global;

["A3PL_Robberies_StoreReward", {
	params [
		["_storeType",("STR_A3PL_Heist_Store_FuelStation" call A3PL_Localize),[""]],
		["_storeClerk",objNull,[objNull]],
		["_faction",Heist_Store_Faction_Required,[""]],
		["_weaponName","Unknown",[""]]
	];

	private _leos = count([_faction] call A3PL_Lib_FactionPlayers);
	private _baseCashReward = _leos * Heist_Store_Money_Reward;
	private _cashRewardFinal = 0;

	private _stolenArray = [];
	private _stolenString = "";

	if (_storeType isEqualTo ("STR_A3PL_Heist_Store_FuelStation" call A3PL_Localize)) then {
		_cashRewardFinal = _baseCashReward + (round (random Heist_Store_GasStation_Money_Random_Reward)) * A3PL_Event_CrimePayout;
		_stolenArray pushback ["repairwrench",8 + (round(random 15))];
		_stolenArray pushback ["jerrycan",5 + (round(random 10))];
		_stolenArray pushback ["cash",_cashRewardFinal];
	};
	if (_storeType isEqualTo "McFishers") then {
		_cashRewardFinal = _baseCashReward + (round (random Heist_Store_McFishers_Money_Random_Reward)) * A3PL_Event_CrimePayout;
		_stolenArray pushback ["burger_full_cooked",1 + (round(random 10))];
		_stolenArray pushback ["cash",_cashRewardFinal];
	};
	if (_storeType isEqualTo "Taco Hell") then {
		_cashRewardFinal = _baseCashReward + (round (random Heist_Store_TacoHell_Money_Random_Reward)) * A3PL_Event_CrimePayout;
		_stolenArray pushback ["taco_cooked",1 + (round(random 10))];
		_stolenArray pushback ["cash",_cashRewardFinal];
	};
	if (_storeType isEqualTo ("STR_A3PL_Heist_Store_RobbableShop" call A3PL_Localize)) then {
		_cashRewardFinal = _baseCashReward + (round (random Heist_Store_Store_Money_Random_Reward)) * A3PL_Event_CrimePayout;
		_stolenArray pushback ["repairwrench",1 + (round(random 10))];
		_stolenArray pushback ["cash",_cashRewardFinal];
	};

	{
		private _class = _x select 0;
		private _amnt = _x select 1;
		[_class,_amnt] call A3PL_Inventory_Add;
		if(_stolenString isEqualTo "") then {
			_stolenString = format["%1x %2",_amnt,[_class,"name"] call A3PL_Config_GetItem];
		} else {
			_stolenString = _stolenString + format[", %1x %2",_amnt,[_class,"name"] call A3PL_Config_GetItem];
		};
	} foreach _stolenArray;

	_storeClerk setVariable["stolenGoods",_stolenString,true];
	_storeClerk setVariable["weaponUsed",_weaponName,true];
	[format [("STR_A3PL_Heist_Store_RobberyLoot" call A3PL_Localize),_stolenString],Color_Green] call A3PL_Notification;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Robbery_Store_Success",[format ["Type: %1 | Position: %2 | Reward: %3",_storeType,(getPosATL player),_stolenString]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

["A3PL_Robberies_StoreQuestion", {
	params [["_store",objNull,[objNull]]];

	private _stolenGoods = _store getVariable["stolenGoods","Nothing"];
	private _weaponUsed = _store getVariable["weaponUsed","Unknown"];
	private _falseAlarmStatus = _store getVariable["falseAlarm",""];
	private _nearBuilding = (nearestObjects [getpos _store,Heist_Store_Store_Questions_Near_Buildings, 50])#0;
	private _alarmStatus = _nearBuilding getVariable["alarmStatus","repaired"];
	if(_falseAlarmStatus isEqualTo "notStarted") exitWith {
		[("STR_A3PL_Heist_Store_AlarmTriggered" call A3PL_Localize),Color_Yellow] call A3PL_Notification;
		_nearBuilding setVariable["alarmStatus","notRepaired",true];
		_store setVariable["falseAlarm","started",true];
	};
	if (_falseAlarmStatus isEqualTo "started") exitWith {
		[("STR_A3PL_Heist_Store_AlarmReset" call A3PL_Localize),Color_Yellow] call A3PL_Notification;
	};
	if (_falseAlarmStatus isEqualTo "resolved") exitWith {
		[("STR_A3PL_Heist_Store_AlarmReseted" call A3PL_Localize),Color_Green] call A3PL_Notification;
		[Heist_Store_Cops_Account_Reward,Heist_Store_Cops_Reward] remoteExec ["Server_Government_AddBalance",2];
		_store setVariable["falseAlarm","",true];
	};
	if(_stolenGoods isEqualTo "Nothing" && {_weaponUsed isEqualTo "Unknown"}) exitWith {[("STR_Common_NoRecentRobbery" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _rand = floor (random 2);
	if (_rand isEqualTo 0) then {
		private _clothes = _store getVariable ["clothingWorn","Unknown"];
		[format [("STR_Common_SuspectSeen" call A3PL_Localize),_clothes],Color_Blue] call A3PL_Notification;
	};
	if (_rand isEqualTo 1) then {
		private _veh = _store getVariable ["nearVehicle","Unknown"];
		[format [("STR_Common_VehicleSpotted" call A3PL_Localize),_veh],Color_Blue] call A3PL_Notification;
	};

	[format [("STR_Common_StolenGoods" call A3PL_Localize),_stolenGoods],Color_Blue] call A3PL_Notification;
	[format [("STR_Common_WeaponDescription" call A3PL_Localize),_weaponUsed],Color_Blue] call A3PL_Notification;
}] call compile_Global;

["A3PL_Robberies_StoreRepair", {
	params [["_storeBldg",objNull,[objNull]]];

	private _alarmStatus = _storeBldg getVariable["alarmStatus","repaired"];
	if (_alarmStatus isEqualTo "notRepaired") exitWith {
		_storeBldg setVariable["alarmStatus","repaired",true];
		[("STR_A3PL_Heist_Store_AlarmReactivatedNotif" call A3PL_Localize),Color_Green] call A3PL_Notification;
		private _nearNPC = (nearestObjects [getpos _storeBldg,["C_man_w_worker_F"], 10])#0;
		_nearNPC setVariable["falseAlarm","resolved",true];
	};
}] call compile_Global;