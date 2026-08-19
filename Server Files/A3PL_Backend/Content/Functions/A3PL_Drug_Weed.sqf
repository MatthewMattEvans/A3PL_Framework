/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3FL_Weed_HangPlant", {
    // private _trailer = nearestObjects [getPos player,["Land_A3FL_Trailer","Land_A3FL_Trailer_2","Land_A3FL_Trailer_3","Land_A3FL_Trailer_4","Land_A3FL_Trailer_5","Land_A3FL_Trailer_6"],10];

	// if (count(_trailer) isEqualTo 0) exitWith {[("STR_Common_Mobilhome" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	// private _chid = ((_trailer#0) getVariable ["doorid",[[],""]])#1;
	// if (!(_chid IN (player getVariable "keys"))) exitWith {[("STR_Common_MobilhomeOwnership" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	params [
		["_rack",objNull,[objNull]],
		["_pItem",objNull,[objNull]]
	];

    private _class = typeOf _pItem;
    private _className = _pItem getVariable["class",nil];
    private _classAmount = _pItem getVariable["amount",0];
    private _acceptedItems = ["cannabis_plant_stage1","cannabis_plant_stage2","cannabis_plant_stage3","cannabis_plant_stage4"];
    
    if (!isNil _class) exitWith {};
    if !(_className IN _acceptedItems) exitwith {[("STR_A3PL_Weed_ItemNotDryable" call A3PL_Localize),Color_Red] call A3PL_Notification;};

    private _hangPoints = _rack getVariable["HangPoints",[]];
    private _usedHangPoints = _rack getVariable["UsedPoints",[]];
    private _defaultPoints = ["HangPoint1","HangPoint4","HangPoint7","HangPoint11","HangPoint25","HangPoint28","HangPoint31","HangPoint35","HangPoint61","HangPoint64","HangPoint67","HangPoint71"];
    if ((_hangPoints isEqualTo []) && (_usedHangPoints isEqualTo [])) then {
        _hangPoints = _defaultPoints;
    };
    if (count(_usedHangPoints) isEqualTo count(_defaultPoints)) exitWith {[("STR_A3PL_Weed_HangPlant_Full" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	
	private _hungPlants = ["A3FL_Cannabis_Plant_Hanging_Stage1","A3FL_Cannabis_Plant_Hanging_Stage2","A3FL_Cannabis_Plant_Hanging_Stage3","A3FL_Cannabis_Plant_Hanging_Stage4"];
	private _nearByPlants = nearestObjects [player,_hungPlants,100];
	if(count(_nearByPlants) > 500) exitWith {[localize"STR_A3PL_Job_Farming_TooMuchPlant",Color_Red] call A3PL_Notification;};
    [player,_classname,-1] remoteExec ["Server_Inventory_Add",2];
	if(!isNil 'Player_ItemAmount') then {
		Player_ItemAmount = Player_ItemAmount - 1;
		if((Player_ItemAmount isEqualTo 0)) then{[] call A3PL_Inventory_Clear;};
	};
    private _nextPoint = _hangPoints select 0;
    private _item = createVehicle [_class,getpos _rack, [], 0, "CAN_COLLIDE"];
  	_item setVariable["class", _className, true];
    _item setVariable["attachedPoint",_nextPoint,true];
    _item allowDamage false;
    _Item attachTo [_rack, [0,0,-0.5], _nextPoint];
    _item setVectorUp [0,0,-1];

    [_item, getPlayerUID player, player getVariable ["character_id",""], player] remoteExec ["Server_Weed_DryLoop",2];
	player setVariable["isHanging",true,true];
    [("STR_A3PL_Weed_HangPlant_Success" call A3PL_Localize),Color_Green] call A3PL_Notification;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Weed_HangPlant",["Weed hanging success"]] remoteExec ["Server_Log_New",2];
    _hangPoints deleteAt 0;
    _usedHangPoints pushBack _nextPoint;
    _rack setVariable["HangPoints",_hangPoints,true];
    _rack setVariable["UsedPoints",_usedHangPoints,true];
}] call compile_Global;

["A3FL_Weed_TrimPlant", {
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
    // private _trailer = nearestObjects [getPos player,["Land_A3FL_Trailer","Land_A3FL_Trailer_2","Land_A3FL_Trailer_3","Land_A3FL_Trailer_4","Land_A3FL_Trailer_5","Land_A3FL_Trailer_6"],10];

	// if (count(_trailer) isEqualTo 0) exitWith {[("STR_Common_Mobilhome" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	// private _chid = ((_trailer#0) getVariable ["doorid",[[],""]])#1;
	// if (!(_chid IN (player getVariable "keys"))) exitWith {[("STR_Common_MobilhomeOwnership" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    params [["_scale",objNull,[objNull]]];

	private _nearPlants = nearestObjects [_scale,["A3FL_Cannabis_Plant_Hanging_Stage4"],2];
	private _totalPlants = 0;
	private _totalBuds = 0;
	private _weightOver = false;
	if(!isNull Player_Item) exitwith {[("STR_A3PL_Weed_DropItem" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	{
		if ((_x getVariable["class",""]) isEqualTo "cannabis_plant_stage4" && (_x getVariable ["held", false]) isNotEqualTo true) then {
			_stackPlant = _x getVariable["amount",1];
			_totalPlants = _totalPlants + _stackPlant;
		};
	} foreach _nearPlants; 

	if (_totalPlants > 10) exitWith {[("STR_A3PL_Weed_TrimPlant_Maximum" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_totalPlants < 1) exitWith {[("STR_A3PL_Weed_TrimPlant_NoPlants" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	for "_i" from 1 to _totalPlants do {
		private _budsFrmPlant = round (random [5,10,15]);
		private _traits = player getVariable ["Player_Traits", []];
		if ("weed" in _traits) then {
			_budsFrmPlant = _budsFrmPlant + round (random [1,7,10]);
		};
		_totalBuds = _totalBuds + _budsFrmPlant;
	};

	if (_totalBuds < 1) exitWith {[("STR_A3PL_Weed_TrimPlant_NoBuds" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_weightOver = if(([["cannabis_bud",_totalBuds]] call A3PL_Inventory_TotalWeight) <= Player_MaxWeight) then {true} else {false};

	if (_weightOver) then {
		{
			if ((_x getVariable["class",""]) isEqualTo "cannabis_plant_stage4" && (_x getVariable ["held", false]) isNotEqualTo true) then {
				deleteVehicle _x;
			};
		} foreach _nearPlants;

		[format [("STR_A3PL_Weed_TrimPlant_Success" call A3PL_Localize),_totalBuds,_totalPlants],Color_Green] call A3PL_Notification;
		["cannabis_bud",_totalBuds] call A3PL_Inventory_Add;
	} else {
		[("STR_A3PL_Weed_TrimPlant_NoSpace" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};
}] call compile_Global;

["A3FL_Weed_BagOpen", {
    disableSerialization;
	params [["_scale",objNull,[objNull]]];

    // private _trailer = nearestObjects [getPos player,["Land_A3FL_Trailer","Land_A3FL_Trailer_2","Land_A3FL_Trailer_3","Land_A3FL_Trailer_4","Land_A3FL_Trailer_5","Land_A3FL_Trailer_6"],10];

	// if (count(_trailer) isEqualTo 0) exitWith {[("STR_Common_Mobilhome" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	// private _chid = ((_trailer#0) getVariable ["doorid",[[],""]])#1;
	// if (!(_chid IN (player getVariable "keys"))) exitWith {[("STR_Common_MobilhomeOwnership" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _nearBuds = nearestObjects [_scale,["A3PL_Cannabis_Bud"],2];
	private _nearBags = nearestObjects [_scale,["A3FL_Drug_Bag_Empty"],2];
	private _allBuds = 0;
	{
		if ((_x getVariable ["class",""]) isEqualTo "cannabis_bud") then {
			_stackBuds = _x getVariable["amount",1];
			_allBuds = _allBuds + _stackBuds;
		};
	} foreach _nearBuds;
	if (_allBuds < 1) exitwith {[("STR_A3PL_Weed_NoBudsNearby" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if ((count _nearBags) < 1) exitWith {[("STR_A3PL_Weed_NoBagsNearby" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	createDialog "Dialog_BagWeed";
	private _display = findDisplay 74;
	_display call A3PL_Dialog_Localize;
	private _ctrl = _display displayCtrl 1000;
	_ctrl ctrlSetText (format [("STR_A3PL_Weed_TrimAmount" call A3PL_Localize),_allBuds*5]);

	private _ctrl = _display displayCtrl 1600;
	_ctrl buttonSetAction "call A3FL_Weed_Bag";
	A3FL_Weed_Scale = _scale;
}] call compile_Global;

["A3FL_Weed_Bag", {
    if(!(call A3PL_Player_AntiSpamLong)) exitWith {};
	disableSerialization;
    // private _trailer = nearestObjects [getPos player,["Land_A3FL_Trailer","Land_A3FL_Trailer_2","Land_A3FL_Trailer_3","Land_A3FL_Trailer_4","Land_A3FL_Trailer_5","Land_A3FL_Trailer_6"],10];

	// if (count(_trailer) isEqualTo 0) exitWith {[("STR_Common_Mobilhome" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	// private _chid = ((_trailer#0) getVariable ["doorid",[[],""]])#1;
	// if (!(_chid IN (player getVariable "keys"))) exitWith {[("STR_Common_MobilhomeOwnership" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    private _scale = missionNameSpace getVariable ["A3FL_Weed_Scale",objNull];
	if(!isNull Player_Item) exitwith {[("STR_A3PL_Weed_DropItem" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (isNull _scale) exitwith { ["Unable to determine scale (report this bug)",Color_Red] call A3PL_Notification;};
	private _nearBuds = nearestObjects [_scale,["A3PL_Cannabis_Bud"],2];
	private _nearBags = nearestObjects [_scale,["A3FL_Drug_Bag_Empty"],2];

	private _display = findDisplay 74;
	private _ctrl = _display displayCtrl 1400;
	private _grams = floor(parseNumber (ctrlText _ctrl));
	if (!(_grams IN [5,10,25,50,100])) exitwith {[("STR_A3PL_Weed_BagWeight_Invalid" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((count _nearBags) < 1) exitWith {[("STR_A3PL_Weed_NoBagsNearby" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (([[format ["weed_bag_%1g",_grams],1]] call A3PL_Inventory_TotalWeight) > Player_MaxWeight) exitwith {[format [("STR_A3PL_Weed_BagWeight_Exceeded" call A3PL_Localize),Player_MaxWeight],Color_Red] call A3PL_Notification;};

	private _amount = 0;
	private _totalBuds = [];
	{
		if ((_x getVariable ["class",""]) isEqualTo "cannabis_bud") then {
			_amount = _amount + (_x getVariable["amount",1])*5;
			_totalBuds pushBack _x;
		};
	} foreach _nearBuds;
	if (_amount < _grams) exitwith {[("STR_A3PL_Weed_NotEnoughBuds" call A3PL_Localize),Color_Red] call A3PL_Notification;_totalBuds = [];};

	private _removedAmount = 0;
	private _budAmount = 1;
	private _toRemove = (_grams/5);
	{
		_budAmount = _x getVariable["amount",1];
		if(_budAmount > (_toRemove-_removedAmount)) exitWith {
			_x setVariable["amount",_budAmount-(_toRemove-_removedAmount),true];
		};
		_removedAmount = _removedAmount + _budAmount;
		deleteVehicle _x;
		if(_removedAmount isEqualTo _toRemove) exitWith {};	
	} forEach _totalBuds;

	private _nearestBag = _nearBags#0;
	private _bagStack = _nearestBag getVariable["amount",1];
	if (_bagStack > 1) then {
		_nearestBag setVariable["amount",(_bagStack - 1),true];
	} else {
		deleteVehicle _nearestBag;
	};

	[format [("STR_A3PL_Weed_Packaged" call A3PL_Localize),_grams],Color_Green] call A3PL_Notification;
	[format ["weed_bag_%1g",_grams],1] call A3PL_Inventory_Add;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Drugs_Crafted",[format ["Drug: %1 | Amount: %2 Grams","Bagged Weed",_grams]]] remoteExec ["Server_Log_New",2];
	closeDialog 0;
	A3FL_Weed_Scale = nil;
}] call compile_Global;

["A3FL_Weed_Grind", {
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	params [["_grinder",objNull,[objNull]]];
    // private _trailer = nearestObjects [getPos player,["Land_A3FL_Trailer","Land_A3FL_Trailer_2","Land_A3FL_Trailer_3","Land_A3FL_Trailer_4","Land_A3FL_Trailer_5","Land_A3FL_Trailer_6"],10];

	// if (count(_trailer) isEqualTo 0) exitWith {[("STR_Common_Mobilhome" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	// private _chid = ((_trailer#0) getVariable ["doorid",[[],""]])#1;
	// if (!(_chid IN (player getVariable "keys"))) exitWith {[("STR_Common_MobilhomeOwnership" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    private _nearBags = nearestObjects [_grinder,["A3FL_Weed_Bag_100g","A3FL_Weed_Bag_50g","A3FL_Weed_Bag_25g","A3FL_Weed_Bag_10g","A3FL_Weed_Bag_5g"],3,true];
	private _amtToGrind = 0;
	if (_grinder getVariable["inUse",false]) exitWith {[("STR_A3PL_Weed_GrinderWorking" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	{
		private _amtPerBag = switch(typeOf _x) do {
			case "A3FL_Weed_Bag_5g": {5};
			case "A3FL_Weed_Bag_10g": {10};
			case "A3FL_Weed_Bag_25g": {25};
			case "A3FL_Weed_Bag_50g": {50};
			case "A3FL_Weed_Bag_100g": {100};
		};
		private _itemClass = switch (typeOf _x) do {
			case "A3FL_Weed_Bag_5g": {"weed_bag_5g"};
			case "A3FL_Weed_Bag_10g": {"weed_bag_10g"};
			case "A3FL_Weed_Bag_25g": {"weed_bag_25g"};
			case "A3FL_Weed_Bag_50g": {"weed_bag_50g"};
			case "A3FL_Weed_Bag_100g": {"weed_bag_100g"};
		};
		_amtPerBag = _amtPerBag * (_x getVariable["amount",1]);
		_amtToGrind = _amtToGrind + _amtPerBag;
		deleteVehicle _x;
		player_itemClass = "";
		[_itemClass,_x getVariable["amount",1]] call A3PL_Inventory_Remove;
	} forEach _nearbags;
	if (_amtToGrind isEqualTo 0) exitWith {[("STR_A3PL_Weed_NoBagstoGrind" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[format[("STR_A3PL_Weed_GrinderStarted" call A3PL_Localize),_amtToGrind,_amtToGrind*0.1],Color_Green] call A3PL_Notification;
	[_grinder,_amtToGrind] spawn {
		private _grinder = param [0,objNull];
		private _amt = param [1,1];
		_grinder setVariable ["inUse",true,true];
		sleep (0.1*_amt);
		[format[("STR_A3PL_Weed_GrinderFinished" call A3PL_Localize),_amt],Color_Green] call A3PL_Notification;
		_grinder setVariable ["inUse",nil,true];
		_grinder setVariable ["grindedWeed",(_grinder getVariable ["grindedWeed",0])+_amt,true];
	};
}] call compile_Global;

["A3FL_Weed_CheckGrinder", {
	params [["_grinder",objNull,[objNull]]];
    // private _trailer = nearestObjects [getPos player,["Land_A3FL_Trailer","Land_A3FL_Trailer_2","Land_A3FL_Trailer_3","Land_A3FL_Trailer_4","Land_A3FL_Trailer_5","Land_A3FL_Trailer_6"],10];

	// if (count(_trailer) isEqualTo 0) exitWith {[("STR_Common_Mobilhome" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	// private _chid = ((_trailer#0) getVariable ["doorid",[[],""]])#1;
	// if (!(_chid IN (player getVariable "keys"))) exitWith {[("STR_Common_MobilhomeOwnership" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    private _grinded = _grinder getVariable ["grindedWeed",0];
	private _containers = ceil (_grinded / 100);
	[format[("STR_A3PL_Weed_GrinderContents" call A3PL_Localize),_grinded,_containers],Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3FL_Weed_GrindCollect", {
	if (!(call A3PL_Player_AntiSpam)) exitWith {};
    // private _trailer = nearestObjects [getPos player,["Land_A3FL_Trailer","Land_A3FL_Trailer_2","Land_A3FL_Trailer_3","Land_A3FL_Trailer_4","Land_A3FL_Trailer_5","Land_A3FL_Trailer_6"],10];

	// if (count(_trailer) isEqualTo 0) exitWith {[("STR_Common_Mobilhome" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	// private _chid = ((_trailer#0) getVariable ["doorid",[[],""]])#1;
	// if (!(_chid IN (player getVariable "keys"))) exitWith {[("STR_Common_MobilhomeOwnership" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    if (Player_ItemClass isNotEqualTo "") exitWith {[("STR_A3PL_Weed_DropItem" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	params [["_grinder",objNull,[objNull]]];

	private _amtInGrinder = _grinder getVariable ["grindedWeed",0];
	private _invContainers = 0;
	if (["weed_grinded_empty",1] call A3PL_Inventory_Has) then {
		_invContainers = ["weed_grinded_empty"] call A3PL_Inventory_Return;
	};

	if (_amtInGrinder <= 0) exitWith {[("STR_A3PL_Weed_GrinderNotEnoughWeed" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_invContainers <= 0) exitWith {[("STR_A3PL_Weed_GrinderNeedEmptyContainer" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_grinder getVariable["inUse",false]) exitWith {[("STR_A3PL_Weed_GrinderInUse" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _amtCollected = 0;
	private _containersUsed = 0;

	if (_grinder getVariable["inUse2",false]) exitWith {[("STR_A3PL_Weed_GrinderInUse2" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_grinder setVariable ["inUse2",true,true];

	for "_i" from 0 to _invContainers do {
		sleep 0.1;
		private _amtToCollect = _grinder getVariable ["grindedWeed",0];
		private _containersLeft = ["weed_grinded_empty"] call A3PL_Inventory_Return;
		if ((_amtToCollect <= 0) || (_containersLeft < 1)) exitWith {};
		if (_amtToCollect >= 100) then {
			_grinder setVariable ["grindedWeed",(_amtToCollect - 100),true];
			["weed_grinded_100",1] call A3PL_Inventory_Add;
			_amtCollected = _amtCollected + 100;
			_containersUsed = _containersUsed + 1;
			["weed_grinded_empty",1] call A3PL_Inventory_Remove;
		} else {
			_grinder setVariable ["grindedWeed",0,true];
			[format["weed_grinded_%1",_amtToCollect],1] call A3PL_Inventory_Add;
			_amtCollected = _amtCollected + _amtToCollect;
			_containersUsed = _containersUsed + 1;
			["weed_grinded_empty",1] call A3PL_Inventory_Remove;
		};
	};
	_grinder setVariable ["inUse2",nil,true];
	[format[("STR_A3PL_Weed_GrinderCollected" call A3PL_Localize),_amtCollected,_containersUsed],Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3FL_Weed_RollBlunt", {
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
    // private _trailer = nearestObjects [getPos player,["Land_A3FL_Trailer","Land_A3FL_Trailer_2","Land_A3FL_Trailer_3","Land_A3FL_Trailer_4","Land_A3FL_Trailer_5","Land_A3FL_Trailer_6"],10];

	// if (count(_trailer) isEqualTo 0) exitWith {[("STR_Common_Mobilhome" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	// private _chid = ((_trailer#0) getVariable ["doorid",[[],""]])#1;
	// if (!(_chid IN (player getVariable "keys"))) exitWith {[("STR_Common_MobilhomeOwnership" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    if (Player_ItemClass isNotEqualTo "") exitwith {[("STR_A3PL_Weed_DropItem" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	params [["_scale",objNull,[objNull]]];

	private _grindedContainers = ["weed_grinded_5","weed_grinded_10","weed_grinded_15","weed_grinded_20","weed_grinded_25","weed_grinded_30","weed_grinded_35","weed_grinded_40","weed_grinded_45","weed_grinded_50","weed_grinded_55","weed_grinded_60","weed_grinded_65","weed_grinded_70","weed_grinded_75","weed_grinded_80","weed_grinded_85","weed_grinded_90","weed_grinded_95","weed_grinded_100"];
	private _invSwishers = 0;
	private _invGrinded = [];
	private _grindedTotal = 0;

	{
		private _class = _x;
		private _amount = 0;
		if ([_class,1] call A3PL_Inventory_Has) then {
			_amount = [_class] call A3PL_Inventory_Return;
			_invGrinded pushBack [_class,_amount];
		};
	} forEach _grindedContainers;
	
	if (["swishers",1] call A3PL_Inventory_Has) then {
		_invSwishers = ["swishers"] call A3PL_Inventory_Return;
	};

	{
		private _class = _x#0;
		private _amount = _x#1;
		private _values = _class splitString "_";
		private _value = parseNumber (_values#2);
		_grindedTotal = _grindedTotal + (_value * _amount);
	} forEach _invGrinded;

	if (_invSwishers < 1) exitWith {[("STR_A3PL_Weed_NeedOCB" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_grindedTotal < 10) exitWith {[("STR_A3PL_Weed_RollJoint_NeedWeed" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _craftableGrinded = floor (_grindedTotal / 10);
	private _craftableActual = _craftableGrinded;
	if (_craftableGrinded > _invSwishers) then {
		_craftableActual = _invSwishers;
	};
	private _gramsUsed = _craftableActual * 10;
	private _gramsToReturn = _grindedTotal - _gramsUsed;

	{
		private _class = _x#0;
		private _amount = _x#1;
		[_class,-(_amount)] call A3PL_Inventory_Add;
	} forEach _invGrinded;

	["swishers",-(_craftableActual)] call A3PL_Inventory_Add;

	private _gramsReturn = [];

	for "_i" from 0 to 100 do {
		if (_gramsToReturn < 1) exitWith{};
		private _amt = switch (true) do {
			case (_gramsToReturn >= 100): {100};
			case (_gramsToReturn >= 95): {95};
			case (_gramsToReturn >= 90): {90};
			case (_gramsToReturn >= 85): {85};
			case (_gramsToReturn >= 80): {80};
			case (_gramsToReturn >= 75): {75};
			case (_gramsToReturn >= 70): {70};
			case (_gramsToReturn >= 65): {65};
			case (_gramsToReturn >= 60): {60};
			case (_gramsToReturn >= 55): {55};
			case (_gramsToReturn >= 50): {50};
			case (_gramsToReturn >= 45): {45};
			case (_gramsToReturn >= 40): {40};
			case (_gramsToReturn >= 35): {35};
			case (_gramsToReturn >= 30): {30};
			case (_gramsToReturn >= 25): {25};
			case (_gramsToReturn >= 20): {20};
			case (_gramsToReturn >= 15): {15};
			case (_gramsToReturn >= 10): {10};
			case (_gramsToReturn >= 5): {5};
			case (_gramsToReturn >= 0): {0};
		};
		_gramsReturn pushBack _amt;
		_gramsToReturn = _gramsToReturn - _amt;
	};

	{
		private _value = _x;
		private _class = format ["weed_grinded_%1",_value];
		[_class,1,true] call A3PL_Inventory_Add;
	} forEach _gramsReturn;
	["blunt",_craftableActual,true] call A3PL_Inventory_Add;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Drugs_Crafted",[format ["Drug: %1 | Amount: %2","Blunt",_craftableActual]]] remoteExec ["Server_Log_New",2];
	[format[("STR_A3PL_Weed_RollJoint_Success" call A3PL_Localize),_craftableActual,_invSwishers,_grindedTotal],Color_Green] call A3PL_Notification;

	
}] call compile_Global;
