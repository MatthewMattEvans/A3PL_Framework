/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_BetterBuy_Cash", {
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	params [
		["_building",objNull,[objNull]],
		["_intersect","",[""]]
	];

	if (isNull _building || {_intersect isEqualTo ""}) exitWith {};
	private _isBeingRobbed = _building getVariable[format["%1_robbed",_intersect],false];
	private _cooldown = _building getVariable ["RobCooldown",serverTime-Heist_BetterBuy_Cooldown];
	if (_isBeingRobbed) exitWith {[("STR_A3PL_Job_BetterBuy_AlreadyRobbed" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_cooldown > (serverTime-Heist_BetterBuy_Cooldown)) exitWith {[("STR_A3PL_Job_BetterBuy_AlreadyRobbed30Mn" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) exitWith {[("STR_A3PL_Job_BetterBuy_YouCanRobOnDuty" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_building setVariable[format["%1_robbery",_intersect],true,true];

	private _startPos = getPos player;
	private _namePos = [getPos _building] call A3PL_Housing_PosAddress;
	private _cops = [("STR_Common_FISD" call A3PL_Localize)] call A3PL_Lib_FactionPlayers;
	if(count(_cops) < Heist_BetterBuy_Min_Cops) exitWith {[format[("STR_A3PL_Job_BetterBuy_NotEnoughSD" call A3PL_Localize),Heist_BetterBuy_Min_Cops],Color_Red] call A3PL_Notification;};
	[("STR_Common_FISD" call A3PL_Localize),("STR_A3PL_Job_BetterBuy_RobberyStore" call A3PL_Localize),getPos _building,format[("STR_A3PL_Job_BetterBuy_RobberyReported" call A3PL_Localize),_namePos],("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
	[_building,("STR_A3PL_Job_BetterBuy_Alarm" call A3PL_Localize),"ColorWHITE","A3FL_Markers_911Call"] remoteExec ["A3PL_Lib_CreateMarker",_cops];
	[getPos _building] remoteExec ["A3PL_GPS_NavigateToPosition",_cops];
	playSound3D ["A3PL_Common\effects\burglaralarm.ogg", _building, false, getPosASL _building, 1, 1, 200];
	[("STR_A3PL_Job_BetterBuy_Lockpick" call A3PL_Localize),Heist_BetterBuy_Time] spawn A3PL_Lib_LoadAction;
	waitUntil{Player_ActionDoing};
	player playMoveNow 'Acts_carFixingWheel';
	while {Player_ActionDoing} do {
		if ((player distance _startPos) > 20) exitWith {Player_ActionInterrupted = true;};
		if (!(player getVariable["A3PL_Medical_Alive",true])) exitWith {Player_ActionInterrupted = true;};
		if ((vehicle player) != player) exitwith {Player_ActionInterrupted = true;};
		if (player getVariable ["Incapacitated",false]) exitwith {Player_ActionInterrupted = true;};
		if (!(player_itemClass isEqualTo "v_lockpick")) exitwith {Player_ActionInterrupted = true;};
		if ((animationstate player) != "Acts_carFixingWheel") then {player playMoveNow 'Acts_carFixingWheel';};
	};
	_building setVariable[format["%1_robbery",_intersect],nil,true];
	if(Player_ActionInterrupted) exitWith {[("STR_A3PL_Job_BetterBuy_LockpickCancelled" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_building setVariable ["RobCooldown",serverTime,true];

	[player_item] call A3PL_Inventory_Clear;
	[player,"v_lockpick",-1] remoteExec ["Server_Inventory_Add",2];

	private _cashAmount = Heist_BetterBuy_Reward + round(random Heist_BetterBuy_Random_Reward);
	private _currentMoney = player getVariable["Player_Cash",0];
	player setVariable["Player_Cash",_currentMoney+_cashAmount,true];

	[format[("STR_A3PL_Job_BetterBuy_YouRobbed" call A3PL_Localize),[_cashAmount, 1, 0, true] call CBA_fnc_formatNumber],Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_BetterBuy_Furniture", {
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	params [["_building",objNull,[objNull]]];

	_building = position _intersect nearestObject "Land_A3FL_Better_Buy";
	if (isNull _building || {isNull _intersect}) exitWith {};
	private _isBeingRobbed = _intersect getVariable["robbery",false];
	private _cooldown = _building getVariable ["RobCooldown",serverTime-Heist_BetterBuy_Furniture_Cooldown];
	private _cops = [("STR_Common_FISD" call A3PL_Localize)] call A3PL_Lib_FactionPlayers;
	if(count(_cops) < Heist_BetterBuy_Furniture_Min_Cops) exitWith {[format[("STR_A3PL_Job_BetterBuy_NoEnoughSD" call A3PL_Localize),Heist_BetterBuy_Furniture_Min_Cops],Color_Red] call A3PL_Notification;};
	if (_isBeingRobbed) exitWith {[("STR_A3PL_Job_BetterBuy_RobAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_cooldown > (serverTime-Heist_BetterBuy_Furniture_Cooldown)) exitWith {[("STR_A3PL_Job_BetterBuy_AlreadyRobbed30Mn" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((currentWeapon player) isEqualTo "") exitwith {[("STR_Common_NoWeaponEquipped" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((currentWeapon player) IN Cant_Rob_With_This) exitwith {[("STR_A3PL_Job_BetterBuy_CantRobWithThisGun" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) exitWith {[("STR_A3PL_Job_BetterBuy_YouCanRobOnDuty" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_intersect setVariable["robbery",true,true];

	[("STR_Common_FISD" call A3PL_Localize),("STR_A3PL_Job_BetterBuy_RobberyStore" call A3PL_Localize),getPos _building,format[("STR_A3PL_Job_BetterBuy_RobberyReported" call A3PL_Localize),[getPos _building] call A3PL_Housing_PosAddress],("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
	playSound3D ["A3PL_Common\effects\burglaralarm.ogg", _building, false, getPosASL _building, 1, 1, 200];
	[("STR_A3PL_Job_BetterBuy_RobberyShop" call A3PL_Localize),Heist_BetterBuy_Furniture_Time] spawn A3PL_Lib_LoadAction;
	waitUntil{Player_ActionDoing};
	while {Player_ActionDoing} do {
		if ((player distance _intersect) > 20) exitWith {Player_ActionInterrupted = true;};
		if (!(player getVariable["A3PL_Medical_Alive",true])) exitWith {Player_ActionInterrupted = true;};
		if ((vehicle player) != player) exitwith {Player_ActionInterrupted = true;};
		if (player getVariable ["Incapacitated",false]) exitwith {Player_ActionInterrupted = true;};
	};
	_intersect setVariable["robbery",false,true];
	if(Player_ActionInterrupted) exitWith {[("STR_A3PL_Job_BetterBuy_LockpickCancelled" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	[_building] call A3PL_BetterBuy_Spawn;
	[("STR_A3PL_Job_BetterBuy_RobberyShopSuccess" call A3PL_Localize),Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_BetterBuy_Spawn", {
	params [["_building",objNull,[objNull]]];

	if(isNull _building) exitWith {};
	private _furnitureCount = Job_BetterBuy_NumberOf_Furnitures + round(random Job_BetterBuy_Random_NumberOf_Furnitures);
	private _offset = [[15,9,-2],[8,12,-2],[5,12,-2],[8,9,-2],[3,9,-2],[0,10,-2],[-2,12,-2],[-2.5,10,-2],[10,12,-2],[16,15,-2]];
	private _deliveryLocation = selectRandom Heist_BetterBuy_DeliveryLocation;
	for "_i" from 0 to _furnitureCount do {
		private _class = selectRandom Job_BetterBuy_Furnitures;
		private _object = createVehicle [(([_class,"class"]) call A3PL_Config_GetItem), [0,0,0], [], 0, "CAN_COLLIDE"];
		_object setVariable ["class",_class,true];
		_object setVariable ["stolen",true,true];
		[_object,player] remoteExec ["A3PL_Lib_ChangeLocality", 2];
		_object setpos (_building modelToWorld _offset#_i);
	};

	[format[("STR_A3PL_Job_BetterBuy_TakeFurniture" call A3PL_Localize),_deliveryLocation#0],Color_Green] call A3PL_Notification;
	private _marker = createMarkerLocal [format ["bb_robbery_%1",random 4000], _deliveryLocation#1];
	_marker setMarkerShapeLocal "ICON";
	_marker setMarkerTypeLocal "Mil_dot";
	_marker setMarkerTextLocal ("STR_A3PL_Job_BetterBuy_StolenFurnitureMarker" call A3PL_Localize);
	_marker setMarkerColorLocal "ColorRed";
	[_deliveryLocation#1] spawn A3PL_GPS_Navigate;

	npc_bb_robbery setPos (_deliveryLocation#1);
	npc_bb_robbery setDir (_deliveryLocation#2);

	sleep 600;
	deleteMarkerLocal _marker;
}] call compile_Global;

["A3PL_BetterBuy_Deliver", {
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	params [["_intersect",objNull,[objNull]]];

	if(isNull _intersect) exitWith {};
	private _nearbyFurnitures = nearestObjects[_intersect,Job_BetterBuy_FurnituresTypeOf,5];
	private _cash = 0;
	{
		if(_x getVariable ["stolen",false]) then {
			_cash = (_cash +(Heist_BetterBuy_Deliver_Reward + round(random Heist_BetterBuy_Deliver_Random_Reward)));
			deleteVehicle _x;
		};
	} foreach _nearbyFurnitures;

	if(_cash isEqualTo 0) exitWith {[("STR_A3PL_Job_BetterBuy_NoFurnitureStolenNear" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	["cash",_cash] call A3PL_Inventory_Add;
	[format[("STR_A3PL_Job_BetterBuy_YouEarnedForStolenFurniture" call A3PL_Localize),_cash],Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_BetterBuy_JobFurniture", {
    params [["_intersect",objNull,[objNull]]];

    private _building = position _intersect nearestObject "Land_A3FL_Better_Buy";
    if (isNull _building || {isNull _intersect}) exitWith {};
    private _job = player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
    if !(_job isEqualTo ("STR_Common_Job_BetterBuy" call A3PL_Localize)) exitWith {[("STR_A3PL_Job_BetterBuy_YoureNotWorkingForBetterBuy" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    
    private _jobVeh = player getVariable ["jobVehicle",objNull];
    if ((!(isNull _jobVeh)) && ((typeof _jobVeh) isEqualTo "A3PL_MailTruck")) exitWith {[("STR_A3PL_Job_BetterBuy_CantUseThisCar" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    
    private _lastTime = player getVariable ["BB_Furniture",serverTime-Job_BetterBuy_Cooldown];
    if(_lastTime > (serverTime-Job_BetterBuy_Cooldown)) exitWith {[("STR_A3PL_Job_BetterBuy_MissionAlreadyTaked" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    player setVariable ["BB_Furniture",serverTime,false];
    [("STR_A3PL_Job_BetterBuy_GoToPoint" call A3PL_Localize),Color_Green] call A3PL_Notification;
    [_building] spawn A3PL_BetterBuy_JobSpawn;
}] call compile_Global;

["A3PL_BetterBuy_JobSpawn", {
	params [["_building",objNull,[objNull]]];

	if(isNull _building) exitWith {};
	private _furnitureCount = Job_BetterBuy_NumberOf_Furnitures + round(random Job_BetterBuy_Random_NumberOf_Furnitures);
	private _offset = [[15,9,-2],[8,12,-2],[5,12,-2],[8,9,-2],[3,9,-2],[0,10,-2],[-2,12,-2],[-2.5,10,-2],[10,12,-2],[16,15,-2]];
	private _deliveryLocation = selectRandom Job_BetterBuy_DeliveryLocation;
	for "_i" from 0 to _furnitureCount do {
		private _class = selectRandom Job_BetterBuy_Furnitures;
		private _object = createVehicle [(([_class,"class"]) call A3PL_Config_GetItem), [0,0,0], [], 0, "CAN_COLLIDE"];
		_object setVariable ["class",_class,true];
		_object setVariable ["betterbuy",true,true];
		_object setVariable ["bb_delivery",_deliveryLocation#1,true];
		_object setVariable ["p_charid",(player getVariable ["character_id",""])];
		A3PL_BetterBuy pushBack _object;
		[_object,player] remoteExec ["A3PL_Lib_ChangeLocality", 2];
		_object setpos (_building modelToWorld _offset#_i);
	};

	[format[("STR_A3PL_Job_BetterBuy_TakeFurniture" call A3PL_Localize),_deliveryLocation#0],Color_Green] call A3PL_Notification;
	private _markerLegal = createMarkerLocal [format ["bb_delivery_%1",random 4000], getPos(_deliveryLocation#1)];
	_markerLegal setMarkerShapeLocal "ICON";
	_markerLegal setMarkerTypeLocal "Mil_dot";
	_markerLegal setMarkerTextLocal ("STR_A3PL_Job_BetterBuy_FurnitureMarker" call A3PL_Localize);
	_markerLegal setMarkerColorLocal "ColorRed";
	[getPos(_deliveryLocation#1)] spawn A3PL_GPS_Navigate;

	sleep 600;
	deleteMarkerLocal _markerLegal;
}] call compile_Global;

["A3PL_BetterBuy_JobDeliver", {
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	params [["_intersect",objNull,[objNull]]];
	if(isNull _intersect) exitWith {};
	
	private _nearbyFurnitures = nearestObjects[_intersect,Job_BetterBuy_FurnituresTypeOf,5];
	private _cash = 0;
	{
		if(_x getVariable ["betterbuy",false] && {_x getVariable ["bb_delivery",objNull] isEqualTo _intersect} && {_x getVariable ["p_charid",nil] isEqualTo (player getVariable ["character_id",""])}) then {
			_cash = _cash + (Job_BetterBuy_Reward + round(random Job_BetterBuy_Random_Reward));
			deleteVehicle _x;
			A3PL_BetterBuy deleteAt (A3PL_BetterBuy find _x);
		}
	} foreach _nearbyFurnitures;

	if(_cash isEqualTo 0) exitWith {[("STR_A3PL_Job_BetterBuy_NoFurnitureNear" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	// Check if player has the employee trait
	private _traits = player getVariable ["Player_Traits", []];
	private _hasEmployeeTrait = "employee" in _traits;

	// Employee trait: 25% salary bonus
	if (_hasEmployeeTrait) then {
		_cash = _cash * 1.25;
	};

	if(isNil "Player_Paycheck") then {Player_Paycheck = _cash;} else {Player_Paycheck = Player_Paycheck + _cash;};
	[player, Player_Paycheck] remoteExec ["Server_Player_UpdatePaycheck",2];

	[format[("STR_A3PL_Job_BetterBuy_YouEarnedForFurnitureDelivery" call A3PL_Localize),_cash],Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_BetterBuy_RentVehicle", {
	params [
		["_location",player_objintersect,[objNull]],
		["_class",Job_BetterBuy_Vehicle_Classname,[Job_BetterBuy_Vehicle_Classname]],
		["_price",Job_BetterBuy_Price,[Job_BetterBuy_Price]]
	];

	private _job = player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];

	if (_job isNotEqualTo ("STR_Common_Job_BetterBuy" call A3PL_Localize)) exitWith {[("STR_A3PL_Job_BetterBuy_NeedToWorkForUsToRent" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _spawnLoc = switch(_location) do {
		case npc_betterbuy: {[6993.96,6365.62,0.00143862]};
		default {[6993.96,6365.62,0.00143862]};
	};
	private _posBlocked = (nearestObjects[_spawnLoc,["Car","Ship","Air","Tank"],5]) isNotEqualTo [];
	if(_posBlocked) then {
		[("STR_A3PL_Job_BetterBuy_SomethingBlockSpawnPoint" call A3PL_Localize),Color_Red] call A3PL_Notification;
	} else {
		/* START HOW TO PAY */
    	player setVariable ["paymentResult",objNull];
		[_price] call A3PL_Bank_HowToPay;
		[_class, _spawnLoc, _price] spawn {
			params ["_class", "_spawnLoc", "_price"];
			waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
			if (!(player getVariable "paymentResult")) exitWith {};
			/* END HOW TO PAY */
			[("STR_A3PL_Job_BetterBuy_VehicleReady" call A3PL_Localize),Color_Green] call A3PL_Notification;
			[_class,_spawnLoc,("STR_Common_Job_BetterBuy" call A3PL_Localize),_price] spawn A3PL_Lib_JobVehicle_Assign;
		};
	};
}] call compile_Global;
