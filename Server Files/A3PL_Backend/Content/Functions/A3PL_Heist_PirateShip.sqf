/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/

["A3PL_Robberies_PirateShip", {
	private _isBeingRobbed = Ship_BlackMarket getVariable["robProgress",false];
	private _cooldown = Ship_BlackMarket getVariable ["RobCooldown",serverTime-Heist_PirateShip_Cooldown];
	if (_isBeingRobbed) exitWith {[("STR_A3PL_Heist_PirateShip_AlreadyBeingRobbed" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_cooldown > (serverTime-Heist_PirateShip_Cooldown)) exitWith {[("STR_A3PL_Heist_PirateShip_RecentlyRobbed" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((currentWeapon player) isEqualTo "") exitwith {[("STR_Common_NoWeaponEquipped" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((currentWeapon player) IN Cant_Rob_With_This) exitwith {[("STR_Common_InvalidWeapon" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (Player_ActionDoing) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _sdCount = count ([("STR_Common_FISD" call A3PL_Localize)] call A3PL_Lib_FactionPlayers);
	if (_sdCount < Heist_PirateShip_Min_Cops) exitWith {[format[("STR_A3PL_Heist_PirateShip_MinCopsToRob" call A3PL_Localize),Heist_PirateShip_Min_Cops],Color_Red] call A3PL_Notification;};

	[("STR_Common_FISD" call A3PL_Localize),("STR_A3PL_Heist_PirateShip_Piracy" call A3PL_Localize),getPos Ship_BlackMarket,("STR_A3PL_Heist_PirateShip_IntrudersOnBoard" call A3PL_Localize),("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
	[getPlayerUID player,(player getVariable ["character_id",""]),"Robbery_PShip_Start",[format ["Position: %1",(getPosATL Ship_BlackMarket)]]] remoteExec ["Server_Log_New",2];

	[("STR_A3PL_Heist_PirateShip_RobberyInProgress" call A3PL_Localize),Heist_PirateShip_Timer] spawn A3PL_Lib_LoadActionQTE;
	waitUntil{Player_ActionDoing};
	while {Player_ActionDoing} do {
		if((player distance Ship_BlackMarket) > 20) exitWith {Player_ActionInterrupted = true;};
		if (!(player getVariable["A3PL_Medical_Alive",true])) exitWith {Player_ActionInterrupted = true;};
		if ((vehicle player) isNotEqualTo player) exitwith {Player_ActionInterrupted = true;};
		if (player getVariable ["Incapacitated",false]) exitwith {Player_ActionInterrupted = true;};
	};
	sleep 0.5;
	if(Player_ActionInterrupted) exitWith {
		[("STR_A3PL_Heist_PirateShip_RobberyCanceled" call A3PL_Localize),Color_Red] call A3PL_Notification;
		[getPlayerUID player,(player getVariable ["character_id",""]),"Robbery_PShip_Cancel",[format ["Position: %1",(getPosATL Ship_BlackMarket)]]] remoteExec ["Server_Log_New",2];
	};
	[] call A3PL_Robberies_PirateShipSuccess;
}] call compile_Global;

["A3PL_Capture_Flag", {
	private _target = param [0,player_objIntersect];
	if ((currentWeapon player) isEqualTo "") exitwith {[("STR_Common_NoWeaponEquipped" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((currentWeapon player) IN Cant_Rob_With_This) exitwith {[("STR_Common_InvalidWeapon" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (Player_ActionDoing) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};

    [("STR_A3PL_Heist_PirateShip_CaptureFlag" call A3PL_Localize),Color_red] remoteExec ["A3PL_Notification",-2];

	[("STR_A3PL_Heist_PirateShip_CaptureFlagInProgress" call A3PL_Localize),Heist_PirateShip_CaptureFlag_Timer] spawn A3PL_Lib_LoadActionQTE;
	waitUntil{Player_ActionDoing};
	while {Player_ActionDoing} do {
		if ((player distance2D _target) > 15) exitWith {Player_ActionInterrupted = true;};
		if (!(player getVariable["A3PL_Medical_Alive",true])) exitWith {Player_ActionInterrupted = true;};
		if ((vehicle player) isNotEqualTo player) exitwith {Player_ActionInterrupted = true;};
		if (player getVariable ["Incapacitated",false]) exitwith {Player_ActionInterrupted = true;};
	};
	sleep 0.5;
	if(Player_ActionInterrupted) exitWith {
		[("STR_A3PL_Heist_PirateShip_CaptureFlagCanceled" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};
	[("STR_A3PL_Heist_PirateShip_CaptureFlagSuccess" call A3PL_Localize),Color_green] remoteExec ["A3PL_Notification",-2];
}] call compile_Global;

["A3PL_Robberies_PirateShipSuccess", {
	private _countFISD = count([("STR_Common_FISD" call A3PL_Localize)] call A3PL_Lib_FactionPlayers);
	private _moneyAmount = Heist_PirateShip_Money_Reward + round(random Heist_PirateShip_Money_Random_Reward) + (Heist_PirateShip_Money_Random_With_Cops_Reward*_countFISD);
	private _currentMoney = player getVariable["Player_Cash",0];
	private _finalArray = [];
	private _itemCount = 2 + round(random(5));
	for "_i" from 0 to _itemCount do {
		_item = (selectRandom Heist_PirateShip_Items_Reward);
		_finalArray = [_finalArray, _item select 0, _item select 1, true] call BIS_fnc_addToPairs;
	};
	{
		[(_x select 0),(_x select 1)] call A3PL_Inventory_Add;
	} foreach _finalArray;
	private _weaponHolder = createVehicle ["GroundWeaponHolder", getposATL player, [], 0, "CAN_COLLIDE"];
	_weaponHolder addItemCargoGlobal ["A3PL_Cowboy",1];

	player setVariable["Player_Cash",_currentMoney+_moneyAmount,true];
	Ship_BlackMarket setVariable ["RobCooldown",diag_Ticktime,true];
	[getPlayerUID player,(player getVariable ["character_id",""]),"Robbery_PShip_Success",[format ["Position: %1 | CashReward: %2 | ItemReward: %3",(getPosATL Ship_BlackMarket),_moneyAmount,_finalArray]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;