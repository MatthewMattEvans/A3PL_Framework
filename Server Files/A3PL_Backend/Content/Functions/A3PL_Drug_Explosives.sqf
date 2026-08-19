/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3FL_Explosives_AddItem", {
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
    // private _trailer = nearestObjects [getPos player,["Land_A3FL_Trailer","Land_A3FL_Trailer_2","Land_A3FL_Trailer_3","Land_A3FL_Trailer_4","Land_A3FL_Trailer_5","Land_A3FL_Trailer_6"],10];

	// if (count(_trailer) isEqualTo 0) exitWith {[("STR_Common_Mobilhome" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	// private _chid = ((_trailer#0) getVariable ["doorid",[[],""]])#1;
	// if (!(_chid IN (player getVariable "keys"))) exitWith {[("STR_Common_MobilhomeOwnership" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    private _barrel = param [0,objNull];
	private _tempNeeded = _barrel getVariable ["tempNeeded",0];
	private _tempCurrent = _barrel getVariable ["tempCurrent",0];
	
	if([player] call A3PL_Lib_CanInteract) exitwith {[("STR_Common_HandcuffedError" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_barrel getVariable ["running",false]) exitwith {[("STR_A3PL_Explosives_InProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	
	if (_tempNeeded isEqualTo 0) then {
		private _randTemp = round(random [192,306,420]);
		_barrel setVariable ["tempNeeded",_randTemp,true];
	};

	private _item = Player_ItemClass;
	private _amount = Player_ItemAmount;
	private _acceptedItems = ["Rubber","matches","rdx","ethanol"];

	if(_amount > 1) exitWith {[("STR_A3PL_Explosives_OneAtATime" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!(_item IN _acceptedItems)) exitWith {[("STR_A3PL_Explosives_NotExplosiveIngredient" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _tempToAdd = switch (_item) do {
		case "Rubber":{-10};
		case "matches":{10};
		case "rdx":{-1};
		case "ethanol":{1};
	};
	_tempCurrent = _tempCurrent + _tempToAdd;
	_barrel setVariable ["tempCurrent",_tempCurrent,true];
	[Player_ItemClass,-_amount] call A3PL_Inventory_Add;
	[false] call A3PL_Inventory_PutBack;

	_items = [(_barrel getVariable ["items",[]]), _item, _amount] call BIS_fnc_addToPairs;
	_items sort true;
	_barrel setVariable ["items",_items,true];
	[format [("STR_A3PL_Explosives_AddItem" call A3PL_Localize),[_item,"name"] call A3PL_Config_GetItem],Color_Green] call A3PL_Notification;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Explosive_AddItem",[format["%1 Added to the barrel",([_item,"name"] call A3PL_Config_GetItem)]]] remoteExec ["Server_Log_New",2];
	sleep 1;
	_tempNeeded = _barrel getVariable ["tempNeeded",0];
	_tempCurrent = _barrel getVariable ["tempCurrent",0];
	if (_tempCurrent > _tempNeeded) then {
		[("STR_A3PL_Explosives_TooHot" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};
	if (_tempCurrent < _tempNeeded) then {
		[("STR_A3PL_Explosives_TooCold" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};
	if (_tempCurrent isEqualTo _tempNeeded) then {
		[("STR_A3PL_Explosives_RightTemperature" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};

	private _chance = random 100;
	private _fisd = [("STR_Common_FISD" call A3PL_Localize)] call A3PL_Lib_FactionPlayers;
	private _fifr = [("STR_Common_FIFR" call A3PL_Localize)] call A3PL_Lib_FactionPlayers;
	private _nearestCity = text ((nearestLocations [_npcName, ["NameCityCapital","NameCity","NameVillage"], 5000]) select 0);
	if(_tempCurrent > _tempNeeded && _chance >= Explosives_Explosion_AddItem_Chances) then {
		[("STR_A3PL_Explosives_WayTooHot" call A3PL_Localize),Color_Red] call A3PL_Notification;
		sleep 10;
		_explosion = "DemoCharge_Remote_Ammo_Scripted" createVehicle (getPos _barrel);
		_explosion setDamage 1;
		[("STR_Common_FISD" call A3PL_Localize),("STR_A3PL_Explosives_Explosion" call A3PL_Localize),getPos _drill,format[("STR_A3PL_Explosives_ExplosionReported" call A3PL_Localize),_nearestCity],("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
		[("STR_Common_FIFR" call A3PL_Localize),("STR_A3PL_Explosives_Explosion" call A3PL_Localize),getPos _drill,format[("STR_A3PL_Explosives_ExplosionReported" call A3PL_Localize),_nearestCity],("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
		[getPlayerUID player,(player getVariable ["character_id",""]),"Explosive_AddItem",[format["Explosion : FISD and FIFR warned"]]] remoteExec ["Server_Log_New",2];
		if((count _fifr) >= Explosives_FireRescue_Needed_To_Create_Fire_When_AddItem) then {[getPosATL (_pos),windDir,false] remoteExec ["Server_Fire_StartFire", 2];};
	};
}] call compile_Global;

["A3FL_Explosives_CheckTemp", {
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
    // private _trailer = nearestObjects [getPos player,["Land_A3FL_Trailer","Land_A3FL_Trailer_2","Land_A3FL_Trailer_3","Land_A3FL_Trailer_4","Land_A3FL_Trailer_5","Land_A3FL_Trailer_6"],10];

	// if (count(_trailer) isEqualTo 0) exitWith {[("STR_Common_Mobilhome" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	// private _chid = ((_trailer#0) getVariable ["doorid",[[],""]])#1;
	// if (!(_chid IN (player getVariable "keys"))) exitWith {[("STR_Common_MobilhomeOwnership" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    private _barrel = param [0,objNull];
	private _temp = _barrel getVariable ["temp",0];
	private _tempToGet = _barrel getVariable ["temptoget",0];
	[format [("STR_A3PL_Explosives_TemperatureCheck" call A3PL_Localize),_temp,_tempToGet],Color_Green] call A3PL_Notification;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Explosive_CheckTemp",[format["Temperature: %1/%2",_temp,_tempToGet]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

["A3FL_Explosives_Reset", {
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
    // private _trailer = nearestObjects [getPos player,["Land_A3FL_Trailer","Land_A3FL_Trailer_2","Land_A3FL_Trailer_3","Land_A3FL_Trailer_4","Land_A3FL_Trailer_5","Land_A3FL_Trailer_6"],10];

	// if (count(_trailer) isEqualTo 0) exitWith {[("STR_Common_Mobilhome" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	// private _chid = ((_trailer#0) getVariable ["doorid",[[],""]])#1;
	// if (!(_chid IN (player getVariable "keys"))) exitWith {[("STR_Common_MobilhomeOwnership" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    private _barrel = param [0,objNull];
	_barrel setVariable ["tempCurrent",0,true];
	_barrel setVariable ["tempNeeded",0,true];
	[("STR_A3PL_Explosives_Reset" call A3PL_Localize),Color_Green] call A3PL_Notification;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Explosive_Reset",[format["Reset"]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

["A3FL_Explosives_Collect", {
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
    // private _trailer = nearestObjects [getPos player,["Land_A3FL_Trailer","Land_A3FL_Trailer_2","Land_A3FL_Trailer_3","Land_A3FL_Trailer_4","Land_A3FL_Trailer_5","Land_A3FL_Trailer_6"],10];

	// if (count(_trailer) isEqualTo 0) exitWith {[("STR_Common_Mobilhome" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	// private _chid = ((_trailer#0) getVariable ["doorid",[[],""]])#1;
	// if (!(_chid IN (player getVariable "keys"))) exitWith {[("STR_Common_MobilhomeOwnership" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    private _barrel = param [0,objNull];
	if (_barrel getVariable ["running",false]) exitwith {[("STR_A3PL_Explosives_CollectInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _collection = _barrel getVariable ["items",[]];
	{
		[_x select 0, _x select 1] call A3PL_Inventory_Add;
		[format [("STR_A3PL_Explosives_Collected" call A3PL_Localize),_x select 1,[_x select 0,"name"] call A3PL_Config_GetItem],Color_Green] call A3PL_Notification;
		[getPlayerUID player,(player getVariable ["character_id",""]),"Explosive_Collect",[format["Amount collected: %1 | Items: %2",(_x select 1),([_x select 0,"name"] call A3PL_Config_GetItem)]]] remoteExec ["Server_Log_New",2];
	} forEach _collection;
	_barrel setVariable["items",[],true];
}] call compile_Global;

["A3FL_Explosives_Produce", {
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
    // private _trailer = nearestObjects [getPos player,["Land_A3FL_Trailer","Land_A3FL_Trailer_2","Land_A3FL_Trailer_3","Land_A3FL_Trailer_4","Land_A3FL_Trailer_5","Land_A3FL_Trailer_6"],10];

	// if (count(_trailer) isEqualTo 0) exitWith {[("STR_Common_Mobilhome" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	// private _chid = ((_trailer#0) getVariable ["doorid",[[],""]])#1;
	// if (!(_chid IN (player getVariable "keys"))) exitWith {[("STR_Common_MobilhomeOwnership" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    private _barrel = param [0,objNull];
	private _stage = param [1,1];
	private _chance = random 100;
	private _tempCurrent = _barrel getVariable ["tempCurrent",0];
	private _tempNeeded = _barrel getVariable ["tempNeeded",0];
	if(_tempCurrent < _tempNeeded && _chance <= Explosives_Explosion_Produce_Chances) exitWith {
		[("STR_A3PL_Explosives_WayTooHot" call A3PL_Localize),Color_Red] call A3PL_Notification;
		sleep 10;
		_explosion = "DemoCharge_Remote_Ammo_Scripted" createVehicle (getPos _barrel);
		_explosion setDamage 1;
		[("STR_Common_FISD" call A3PL_Localize),("STR_A3PL_Explosives_Explosion" call A3PL_Localize),getPos _drill,format[("STR_A3PL_Explosives_ExplosionReported" call A3PL_Localize),_nearestCity],("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
		[("STR_Common_FIFR" call A3PL_Localize),("STR_A3PL_Explosives_Explosion" call A3PL_Localize),getPos _drill,format[("STR_A3PL_Explosives_ExplosionReported" call A3PL_Localize),_nearestCity],("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
		[getPlayerUID player,(player getVariable ["character_id",""]),"Explosive_Produce",[format["Explosion : FISD and FIFR warned"]]] remoteExec ["Server_Log_New",2];
		if((count _fifr) >= Explosives_FireRescue_Needed_To_Create_Fire_When_Produce) then {[getPosATL (_pos),windDir,false] remoteExec ["Server_Fire_StartFire", 2];};
	};
	if (_tempCurrent < _tempNeeded) exitWith {
		[("STR_A3PL_Explosives_Failed" call A3PL_Localize),Color_Red] call A3PL_Notification;
		[getPlayerUID player,(player getVariable ["character_id",""]),"Explosive_Produce",["Process failed"]] remoteExec ["Server_Log_New",2];
		_barrel setVariable ["tempCurrent",0,true];
		_barrel setVariable ["tempNeeded",0,true];
	};
	if (_barrel getVariable ["running",false]) exitwith {[("STR_A3PL_Explosives_AlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_barrel setVariable ["running",true,true];
	[("STR_A3PL_Explosives_ProcessStarted" call A3PL_Localize),Color_Green] call A3PL_Notification;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Explosive_Produce",["Process started"]] remoteExec ["Server_Log_New",2];

	private _sound = createSoundSource ["A3PL_Boiling", (getpos _barrel), [], 0];
	private _posSound = getPos _barrel;
	private _succes = false;
	while {(_timeLeft > 0) && (_barrel getVariable ["running",false])} do
	{
		if (_posSound isNotEqualTo (getpos _barrel)) then
		{
			_sound setPos (getpos _barrel);
			_posSound = getpos _barrel;
		};
		_timeLeft = _timeLeft - 1;
		_barrel setVariable ["timeleft",_timeLeft,true];
		if (_timeLeft < 1) exitwith {_succes = true;};
		uiSleep 1;
	};
	_barrel setVariable ["running",false,true];
	deleteVehicle _sound;

	if (_succes) then {
		[("STR_A3PL_Explosives_ProcessCompleted" call A3PL_Localize),Color_Green] call A3PL_Notification;
		[getPlayerUID player,(player getVariable ["character_id",""]),"Explosive_Produce",["Process completed"]] remoteExec ["Server_Log_New",2];
	} else {
		[("STR_A3PL_Explosives_Failed" call A3PL_Localize),Color_Red] call A3PL_Notification;
		[getPlayerUID player,(player getVariable ["character_id",""]),"Explosive_Produce",["Process failed"]] remoteExec ["Server_Log_New",2];
	};

	if(_stage isEqualTo 1) then {
		_inv pushBack ["synthrubber",1];
		_barrel setVariable ["items",_inv,true];
	};
	if(_stage isEqualTo 2) then {
		_inv pushBack ["explosivemix",1];
		_barrel setVariable ["items",_inv,true];
	};
	if(_stage isEqualTo 3) then {
		_inv pushBack ["c4",1];
		_barrel setVariable ["items",_inv,true];
	};
}] call compile_Global;

["A3FL_Explosives_InBarrel", {
	private _item = param [0,""];
	private _barrel = param [1,cursorObject];
	private _found = false;
	private _items = _barrel getVariable["items",[]];
	{
		if(_item isEqualTo (_x select 0)) exitWith{_found = true};
	} forEach _items;
	if(_found) exitWith {true};
	false
}] call compile_Global;
