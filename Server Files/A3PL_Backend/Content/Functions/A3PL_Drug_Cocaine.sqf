/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Cocaine_AddItem",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};

    // private _trailer = nearestObjects [getPos player,["Land_A3FL_Trailer","Land_A3FL_Trailer_2","Land_A3FL_Trailer_3","Land_A3FL_Trailer_4","Land_A3FL_Trailer_5","Land_A3FL_Trailer_6"],10];

	// if (count(_trailer) isEqualTo 0) exitWith {[("STR_Common_Mobilhome" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	// private _chid = ((_trailer#0) getVariable ["doorid",[[],""]])#1;
	// if !(_chid IN (player getVariable "keys")) exitWith {[("STR_Common_MobilhomeOwnership" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _barrel = param [0,objNull];
	if((player getVariable ["Cuffed",false]) || (player getVariable ["Zipped",false]) || ((animationState player) == "a3pl_takenhostage")) exitwith {[("STR_Common_HandcuffedError" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_barrel getVariable ["running",false]) exitwith {[("STR_A3PL_Cocaine_BarrelInUse" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _item = Player_ItemClass;
	private _amount = Player_ItemAmount;
	if(_amount > 5) exitWith {[("STR_A3PL_Cocaine_LimitReached" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[Player_ItemClass,-_amount] call A3PL_Inventory_Add;
	[false] call A3PL_Inventory_PutBack;
	if(_item isEqualTo "kerosene_jerrycan") then {
		_jerrycan = Player_Item;
		detach _jerrycan;
		private _attachpoint = _barrel selectionPosition "item_pickup";
		_attachpoint set [0,(_attachPoint select 0) - 0.3];
		_attachpoint set [0,(_attachPoint select 1) + 1];
		_attachpoint set [2,(_attachPoint select 2) + 0.2];
		_jerrycan attachTo [_barrel,_attachPoint];
		_jerrycan setVectorDirAndUp [[0,1,0],[1,0,0]];
		playSound3D ["A3PL_Common\effects\gasoline.ogg", _barrel, false, getPos _barrel, 5, 1.1, 40];
		uiSleep 4.5;
		_jerrycan setVectorDirAndUp [[0,1,0],[0,0,1]];
		uiSleep 1;
		deleteVehicle _jerrycan;
		[player,"jerrycan_empty",1] remoteExec ["Server_Inventory_Add",2];
	};
	_items = [(_barrel getVariable ["items",[]]), _item, _amount] call BIS_fnc_addToPairs;
	_items sort true;
	_barrel setVariable ["items",_items,true];

	[format [("STR_A3PL_Cocaine_AddedItem" call A3PL_Localize),[_item,"name"] call A3PL_Config_GetItem],Color_Green] call A3PL_Notification;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Cocaine_AddItem",[format["Item: %1 | Amount: %2 | Added to the barrel",_item,_amount]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

["A3PL_Cocaine_CheckContents",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};

    // private _trailer = nearestObjects [getPos player,["Land_A3FL_Trailer","Land_A3FL_Trailer_2","Land_A3FL_Trailer_3","Land_A3FL_Trailer_4","Land_A3FL_Trailer_5","Land_A3FL_Trailer_6"],10];

	// if (count(_trailer) isEqualTo 0) exitWith {[("STR_Common_Mobilhome" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	// private _chid = ((_trailer#0) getVariable ["doorid",[[],""]])#1;
	// if (!(_chid IN (player getVariable "keys"))) exitWith {[("STR_Common_MobilhomeOwnership" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _barrel = param [0,objNull];
	private _items = _barrel getVariable ["items",[]];
	private _itemNames = [];
	private _itemNameString = "";
	private _compileList = [];

	{
		_tmp = [(_x select 0),"name"] call A3PL_Config_GetItem;
		_itemNames pushBack [_x select 1,_tmp];
	} forEach _items;
	{
		_itemNameString = _x joinString " ";
		_compileList pushBack _itemNameString;
	} forEach _itemNames;

	_fullStringList = _compileList joinString ", ";
	if(_itemNames isEqualTo []) then {
		_fullStringList = "rien";
	};

	[format [("STR_A3PL_Cocaine_CheckContent" call A3PL_Localize),_fullStringList],Color_Green] call A3PL_Notification;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Cocaine_CheckContent",[format["Items: %1 | Barrel content checked",_items]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

["A3PL_Cocaine_Reset",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private _action = [("STR_Intersect_EmptyBarrel_Confirm" call A3PL_Localize)] call A3PL_Lib_ConfirmationDialog;
	if (!isNil "_action" && {!_action}) exitWith {};

    // private _trailer = nearestObjects [getPos player,["Land_A3FL_Trailer","Land_A3FL_Trailer_2","Land_A3FL_Trailer_3","Land_A3FL_Trailer_4","Land_A3FL_Trailer_5","Land_A3FL_Trailer_6"],10];

	// if (count(_trailer) isEqualTo 0) exitWith {[("STR_Common_Mobilhome" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	// private _chid = ((_trailer#0) getVariable ["doorid",[[],""]])#1;
	// if (!(_chid IN (player getVariable "keys"))) exitWith {[("STR_Common_MobilhomeOwnership" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _barrel = param [0,objNull];
	_barrel setVariable ["items",[],true];
	[("STR_A3PL_Cocaine_ResetBarrel" call A3PL_Localize),Color_Red] call A3PL_Notification;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Cocaine_Reset",[format["Retrait des items du baril"]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

["A3PL_Cocaine_Collect",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
    // private _trailer = nearestObjects [getPos player,["Land_A3FL_Trailer","Land_A3FL_Trailer_2","Land_A3FL_Trailer_3","Land_A3FL_Trailer_4","Land_A3FL_Trailer_5","Land_A3FL_Trailer_6"],10];

	// if (count(_trailer) isEqualTo 0) exitWith {[("STR_Common_Mobilhome" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	// private _chid = ((_trailer#0) getVariable ["doorid",[[],""]])#1;
	// if (!(_chid IN (player getVariable "keys"))) exitWith {[("STR_Common_MobilhomeOwnership" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _barrel = param [0,objNull];
	if (_barrel getVariable ["running",false]) exitwith {[("STR_A3PL_Cocaine_CollectErrorInUse" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _collection = _barrel getVariable ["items",[]];
	{
		[_x select 0, _x select 1] call A3PL_Inventory_Add;
		[format [("STR_A3PL_Cocaine_Collect" call A3PL_Localize),_x select 1,[_x select 0,"name"] call A3PL_Config_GetItem],Color_Green] call A3PL_Notification;
		[getPlayerUID player,(player getVariable ["character_id",""]),"Cocaine_Collect",[format["Items: %2 | Amount: %1 | Barrel content collected",(_x select 1),([_x select 0,"name"] call A3PL_Config_GetItem)]]] remoteExec ["Server_Log_New",2];
	} forEach _collection;
	_barrel setVariable["items",[],true];
}] call compile_Global;

["A3PL_Cocaine_Produce",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
    // private _trailer = nearestObjects [getPos player,["Land_A3FL_Trailer","Land_A3FL_Trailer_2","Land_A3FL_Trailer_3","Land_A3FL_Trailer_4","Land_A3FL_Trailer_5","Land_A3FL_Trailer_6"],10];

	// if (count(_trailer) isEqualTo 0) exitWith {[("STR_Common_Mobilhome" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	// private _chid = ((_trailer#0) getVariable ["doorid",[[],""]])#1;
	// if (!(_chid IN (player getVariable "keys"))) exitWith {[("STR_Common_MobilhomeOwnership" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _barrel = param [0,objNull];
	private _stage = param [1,1];
	if (_barrel getVariable ["running",false]) exitwith {[("STR_A3PL_Cocaine_ProcessInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_barrel setVariable ["running",true,true];
	[("STR_A3PL_Cocaine_ProcessStarted" call A3PL_Localize),Color_Green] call A3PL_Notification;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Cocaine_ProduceStart",["Cocaine process started"]] remoteExec ["Server_Log_New",2];

	private _sound = createSoundSource ["A3PL_Boiling", (getpos _barrel), [], 0];
	private _posSound = getPos _barrel;
	private _succes = false;
	private _timeLeft = Cocaine_Produce_Timer + round random Cocaine_Produce_Timer_Random;
	_barrel setVariable ["timeleft",_timeLeft,true];	

	private _smokeParticles = createVehicle ["#particleSource", getposATL _barrel, [], 0, "CAN_COLLIDE"];
	_smokeParticles setParticleClass "SmallDestructionSmoke";
	_smokeParticles attachTo [_barrel,[0,0,0]];

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
	deleteVehicle _smokeParticles;

	if (_succes) then {
		[("STR_A3PL_Cocaine_ProcessFinished" call A3PL_Localize),Color_Green] call A3PL_Notification;
		[getPlayerUID player,(player getVariable ["character_id",""]),"Cocaine_ProcessFinished",["Cocaine process finished"]] remoteExec ["Server_Log_New",2];
	} else {
		[("STR_A3PL_Cocaine_ProcessFailed" call A3PL_Localize),Color_Red] call A3PL_Notification;
		[getPlayerUID player,(player getVariable ["character_id",""]),"Cocaine_ProcessNotSuccess",["Cocaine process failed"]] remoteExec ["Server_Log_New",2];
	};

	private _randomToAdd = 0;
	private _traits = player getVariable ["Player_Traits", []];
	if ("cocaine" in _traits) then {
		_randomToAdd = round (random [0,2,3]);
	};

	if(_stage isEqualTo 1) then {
		_inv = _barrel getVariable["items",[]];
		_inv deleteRange [0,5];
		_inv pushBack ["coca_paste",2 + round(random 3) + _randomToAdd];
		_barrel setVariable ["items",_inv,true];
	};
	if(_stage isEqualTo 2) then {
		_inv = _barrel getVariable["items",[]];
		_inv deleteRange [0,3];
		_inv pushBack ["cocaine_base",3 + round(random 4) + _randomToAdd];
		_barrel setVariable ["items",_inv,true];
	};
	if(_stage isEqualTo 3) then {
		_inv = _barrel getVariable["items",[]];
		_inv deleteRange [0,4];
		_inv pushBack ["cocaine_hydrochloride",3 + round(random 2) + _randomToAdd];
		_barrel setVariable ["items",_inv,true];
	};
}] call compile_Global;

["A3PL_Cocaine_InBarrel", {
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

["A3PL_Cocaine_CreateBrick",{
	private _target = param [0,player_objIntersect];
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
    // private _trailer = nearestObjects [getPos player,["Land_A3FL_Trailer","Land_A3FL_Trailer_2","Land_A3FL_Trailer_3","Land_A3FL_Trailer_4","Land_A3FL_Trailer_5","Land_A3FL_Trailer_6"],10];

	// if (count(_trailer) isEqualTo 0) exitWith {[("STR_Common_Mobilhome" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	// private _chid = ((_trailer#0) getVariable ["doorid",[[],""]])#1;
	// if (!(_chid IN (player getVariable "keys"))) exitWith {[("STR_Common_MobilhomeOwnership" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if((player getVariable ["Cuffed",false]) || (player getVariable ["Zipped",false]) || ((animationState player) == "a3pl_takenhostage")) exitwith {[("STR_Common_HandcuffedError" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if(!(["cocaine_hydrochloride",Cocaine_Hydrochloride_Needed_To_Make_Brick] call A3PL_Inventory_Has)) exitWith{[format[("STR_A3PL_Cocaine_ProduceNeedChlorhydrate" call A3PL_Localize),Cocaine_Hydrochloride_Needed_To_Make_Brick],Color_Red] call A3PL_Notification;};
	private _npcCoke = npc_ill_cocaine;
	if ((player distance2D _npcCoke) <= Cocaine_Distance_Dealer) exitWith {[("STR_A3PL_Cocaine_DealerProximity" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (Player_ActionDoing) exitWith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[("STR_A3PL_Cocaine_Fabrication" call A3PL_Localize),Cocaine_Brick_Fabrication_Timer] spawn A3PL_Lib_LoadAction;
	waitUntil{Player_ActionDoing};
	player playMoveNow 'Acts_carFixingWheel';
	while {Player_ActionDoing} do {
		if ((player getVariable ["Cuffed",false]) || (player getVariable ["Zipped",false]) || ((animationState player) == "a3pl_takenhostage")) exitwith {Player_ActionInterrupted = true;};
		if ((player distance2D _target) > 5) exitWith {Player_ActionInterrupted = true;};
		if !(player getVariable["A3PL_Medical_Alive",true]) exitWith {Player_ActionInterrupted = true;};
		if ((vehicle player) isNotEqualTo player) exitwith {Player_ActionInterrupted = true;};
		if (player getVariable ["Incapacitated",false]) exitwith {Player_ActionInterrupted = true;};
		if ((animationstate player) != "Acts_carFixingWheel") then {player playMoveNow 'Acts_carFixingWheel';};
	};
	[player, ""] remoteExec ["A3PL_Lib_SyncAnim",0];
	if(Player_ActionInterrupted) exitWith {[("STR_A3PL_Cocaine_FabricationCancelled" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if(!(["cocaine_hydrochloride",Cocaine_Hydrochloride_Needed_To_Make_Brick] call A3PL_Inventory_Has)) exitWith{[format[("STR_A3PL_Cocaine_ProduceNeedChlorhydrate" call A3PL_Localize),Cocaine_Hydrochloride_Needed_To_Make_Brick],Color_Red] call A3PL_Notification;};
	[player,"cocaine_hydrochloride",-Cocaine_Hydrochloride_Needed_To_Make_Brick] remoteExec ["Server_Inventory_Add",2];
	["cocaine_brick"] call PO_Achievement_Learn;
	[("STR_A3PL_Cocaine_FabricationSuccess" call A3PL_Localize),Color_Green] call A3PL_Notification;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Cocaine_CreateBrick",["Cocaine Brick fabrication success"]] remoteExec ["Server_Log_New",2];
	_pos = getposatl player;
	_pos set[2, (_pos#2 + 0.2)];
	_brick = createVehicle ["A3FL_DrugBag", _pos, [], 0, "CAN_COLLIDE"];
	_brick setVariable ["class","cocaine_brick",true];
	_brick setVariable ["owner",(player getVariable ["character_id",""]),true];
}] call compile_Global;

["A3PL_Cocaine_BreakDownBrick",
{
	private _target = param [0,player_objIntersect];
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
    // private _trailer = nearestObjects [getPos player,["Land_A3FL_Trailer","Land_A3FL_Trailer_2","Land_A3FL_Trailer_3","Land_A3FL_Trailer_4","Land_A3FL_Trailer_5","Land_A3FL_Trailer_6"],10];

	// if (count(_trailer) isEqualTo 0) exitWith {[("STR_Common_Mobilhome" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	// private _chid = ((_trailer#0) getVariable ["doorid",[[],""]])#1;
	// if (!(_chid IN (player getVariable "keys"))) exitWith {[("STR_Common_MobilhomeOwnership" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    if((player getVariable ["Cuffed",false]) || (player getVariable ["Zipped",false]) || ((animationState player) == "a3pl_takenhostage")) exitwith {[("STR_Common_HandcuffedError" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _near = nearestObjects [_target, ["A3FL_DrugBag"],2];
	if ((count _near) < 1) exitwith {[("STR_A3PL_Cocaine_NoCocaineBricks" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_target getVariable["inUse",false]) exitWith {[("STR_A3PL_Cocaine_BalanceInUse" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (Player_ActionDoing) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _bagCount = Cocaine_Bag_Count + (round(random Cocaine_Bag_Count_Random));
	[player,"cocaine",_bagCount] remoteExec ["Server_Inventory_Add",2];
	[format[("STR_A3PL_Cocaine_BrickBreakingSuccess" call A3PL_Localize),_bagCount],Color_Green] call A3PL_Notification;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Cocaine_BreakDownBrick",[format["Cocaine bags | Amount: %1",_bagCount]]] remoteExec ["Server_Log_New",2];
	deleteVehicle (_near select 0);
}] call compile_Global;