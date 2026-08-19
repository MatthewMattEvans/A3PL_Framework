/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
//deals with getting inherance information from configFile for usage in text by Factory_Open
["A3PL_Factory_Inheritance",
{
	private _class = param [0,""];
	private _type = param [1,""];
	private _info = param [2,""];
	private _return = "";
	private _mainClass = "";

	if (_type isEqualTo "item") exitwith {
		_return = switch (_info) do {
			case ("img"): {""};
			case ("name"): {[_class,"name"] call A3PL_Config_GetItem};
		};
		_return;
	};
	_mainClass = switch (_type) do {
		case ("weapon"): {"CfgWeapons"};
		case ("magazine"): {"cfgMagazines"};
		case ("mag"): {"cfgMagazines"};
		case ("uniform"): {"CfgWeapons"};
		case ("vest"): {"CfgWeapons"};
		case ("headgear"): {"CfgWeapons"};
		case ("backpack"): {"CfgVehicles"};
		case ("goggles"): {"CfgGlasses"};
		case ("aitem"): {"CfgWeapons"};
		default {"cfgVehicles"};
	};

	_return = switch (_info) do {
		case ("img"): { getText (configFile >> _mainClass >> _class >> "picture") };
		case ("name"): { getText (configFile >> _mainClass >> _class >> "displayName") };
		case ("mainClass"): { _mainClass };
	};
	_return;
}] call compile_Global;

["A3PL_Factory_DialogLoop",
{
	disableSerialization;
	private ["_duration","_secLeft","_id","_timeEnd","_name"];
	private _display = findDisplay 45;
	if (isNull _display) exitwith {};
	private _type = _display getVariable ["A3PL_Factory_Type", ""];
	private _var = player getVariable ["player_factories",[]];
	private _craftID = nil;
	{
		private _id = _x select 0;
		if (([_id, "type"] call A3PL_Config_GetPlayerFactory) == _type) exitwith {_craftID = _id;};
	} foreach _var;
	if (isNil "_craftID") exitwith {};

	private _id = [_craftID, "id"] call A3PL_Config_GetPlayerFactory;
	private _duration = ([_id,_type,"time"] call A3PL_Config_GetFactory) * ([_craftID, "count"] call A3PL_Config_GetPlayerFactory);
	private _timeEnd = [_craftID, "finish"] call A3PL_Config_GetPlayerFactory;
	private _name = [([_id,_type,"class"] call A3PL_Config_GetFactory),([_id,_type,"type"] call A3PL_Config_GetFactory),"name"] call A3PL_Factory_Inheritance;
	_duration = [_duration] call A3FL_Factory_LevelBoost;
	while {!isNull _display} do {
		if(!isNil "Player_CraftInterrupt") exitWith {
			(_display displayCtrl 1105) progressSetPosition 0;
			(_display displayCtrl 1104) ctrlSetStructuredText parseText "";
		};
		_secLeft = -(diag_ticktime) + _timeEnd;
		(_display displayCtrl 1105) progressSetPosition (1-(_secLeft / _duration));
		if (_secLeft < 0) then {_secLeft = 0};
		if(_secLeft > 60) then {
			_minLeft = ceil (_secLeft/60);
			(_display displayCtrl 1104) ctrlSetStructuredText parseText format [("STR_A3PL_Factory_TimeRemaining" call A3PL_Localize),_name,_minLeft];
			if(_minLeft > 60) then {
				(_display displayCtrl 1104) ctrlSetStructuredText parseText format [("STR_A3PL_Factory_TimeRemainingHours" call A3PL_Localize),_name,round(_minLeft/60)];
			};
		} else {
			(_display displayCtrl 1104) ctrlSetStructuredText parseText format [("STR_A3PL_Factory_TimeRemainingSeconds" call A3PL_Localize),_name,ceil _secLeft];
		};
		uiSleep 1;
		if (_secLeft <= 0) exitwith {};
	};
}] call compile_Global;

//can check whether we have an item in the factory storage or not. can also be used by the server
["A3PL_Factory_Has",
{
	private ["_item","_amount","_player","_has","_found","_storage","_type"];
	_item = param [0,""];
	_amount = param [1,1];
	_type = param [2,""];
	_player = param [3,player];
	_has = false;
	_found = false;
	_storage = _player getVariable ["player_fstorage",[]];

	{
		if (_x select 0 == _type) then
		{
			{
				private ["_storageItem","_isFactory","_itemType"];
				_storageItem = _x select 0;
				_isFactory = _storageItem splitString "_";
				if ((_isFactory select 0) isEqualTo "f") then {_isFactory = true; _itemType = [_storageItem,_type,"type"] call A3PL_Config_GetFactory;} else {_isFactory = false;};
				if (isNil "_itemType") then {_itemType = ""};
				if (_isFactory && (_itemType isEqualTo "item")) then {_storageItem = [_storageItem,_type,"class"] call A3PL_Config_GetFactory;};
				if (_storageItem == _item) exitwith
				{
					if ((_x select 1) >= _amount) then
					{
						_has = true
					};
					_found = true;
				};
			} foreach (_x select 1);
			if (_found) exitwith {};
		};
	} foreach _storage;
	_has;
}] call compile_Global;

["A3PL_Factory_Craft",
{
	if(!(call A3PL_Player_AntiSpamLong)) exitWith {};
	disableSerialization;
	private _display = findDisplay 45;
	private _type = _display getVariable ["A3PL_Factory_Type", ""];
	private _toCraft = floor(parseNumber(ctrlText (_display displayCtrl 1406)));
	private _alreadyCrafting = false;
	private _var = player getVariable ["player_factories",[]];

	if(_toCraft < 1) exitWith {[("STR_Common_InvalidAmount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	{
		if (([(_x select 0), "type"] call A3PL_Config_GetPlayerFactory) isEqualTo _type) exitwith {_alreadyCrafting = true;};
	} foreach _var;

	if(!isNil "Player_CraftInterrupt") exitWith {[("STR_A3PL_Factory_CraftInterruptionInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_alreadyCrafting) then {
		{
			if ((_x select 3) isEqualTo _type) exitwith {_var deleteAt _forEachIndex};
		} foreach _var;
		player setVariable ["player_factories",_var,false];
		Player_CraftInterrupt = true;
		[("STR_A3PL_Factory_CraftInterrupted" call A3PL_Localize),Color_Red] call A3PL_Notification;
	} else {
		private _control = _display displayCtrl 1500;
		if (lbCurSel _control < 0) exitwith {[("STR_A3PL_Factory_NoItemSelected" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		private _id = _control lbData (lbCurSel _control);
		private _required = [_id,_type,"required"] call A3PL_Config_GetFactory;
		if (isNil "_required" OR (count _required < 1)) exitwith {["Unexpected error occured trying to retrieve items for recipe in _Craft",Color_Red] call A3PL_Notification;};

		private _temp = [];
		private _failed = false;
		{
			private _id = _x select 0;
			private _amount = (_x select 1)*_toCraft;
			_temp pushBack [_id,_amount];
			if (!([_id,_amount,_type] call A3PL_Factory_Has)) exitwith {_failed=true};
		} foreach _required;
		_required = _temp;

		if (_failed) exitwith {[format[("STR_A3PL_Factory_NoMaterials" call A3PL_Localize),_toCraft],Color_Red] call A3PL_Notification;};

		private _sec = ([_id,_type,"time"] call A3PL_Config_GetFactory)*_toCraft;
		_sec = [_sec] call A3FL_Factory_LevelBoost;
		private _classType = [_id,_type,"type"] call A3PL_Config_GetFactory;
		private _classname = [_id,_type,"class"] call A3PL_Config_GetFactory;
		private _craftID = floor (random 10000);
		private _var = player getVariable ["Player_Factories",[]];
		_var pushback [_craftID,_classname,_required,_type,_classType,_id,1,(diag_ticktime + _sec),_toCraft];
		player setVariable ["Player_Factories",_var,false];
		[getPlayerUID player,(player getVariable ["character_id",""]),"Factory_Craft_Started",[format ["Factory: %1 | Item: %2 | Amount: %3 | Duration: %4 seconds",_type,_classname,_toCraft,_sec]]] remoteExec ["Server_Log_New",2];
		[] spawn A3PL_Factory_DialogLoop;
		[_craftID,_sec,_required,_toCraft] spawn
		{
			private _craftID = param [0,0];
			private _sec = param [1,0];
			private _required = param [2,[]];
			private _toCraft = param [3,1];
			private _type = [_craftID, "type"] call A3PL_Config_GetPlayerFactory;
			private _classtype = [_craftID, "classtype"] call A3PL_Config_GetPlayerFactory;
			private _classname = [_craftID, "classname"] call A3PL_Config_GetPlayerFactory;
			private _id = [_craftID, "id"] call A3PL_Config_GetPlayerFactory;
			private _name = [_classname,_classType,"name"] call A3PL_Factory_Inheritance;
			private _xpToAdd = _toCraft;
			private _curSleep = 0;
			while{_curSleep < _sec} do {
				if(!isNil "Player_CraftInterrupt") exitWith {
					[getPlayerUID player,(player getVariable ["character_id",""]),"Factory_Craft_Cancel",[format ["Factory: %1 | Item: %2 | Amount: %3",_type,_classname,_toCraft]]] remoteExec ["Server_Log_New",2];
				};
				_curSleep = _curSleep + 1;
				sleep 1;
			};
			if(!isNil "Player_CraftInterrupt" || {_curSleep < _sec}) exitWith {[] spawn A3PL_Factory_Cancel;};

			private _hasFailed = false;

			if ((_id find "blueprint") isNotEqualTo -1) then {
				private _chanceFail = Config_Factories_BP#0;
				private _random = (random 100);

				if (_random <= _chanceFail) then {
					_hasFailed = true;
					[format [("STR_A3PL_Factory_BlueprintCraftFailed" call A3PL_Localize),_name,_type,([_id,_type,"output"] call A3PL_Config_GetFactory)*_toCraft],Color_Red] call A3PL_Notification;
					[getPlayerUID player,(player getVariable ["character_id",""]),"Factory_Craft_Failed",[format ["Factory: %1 | Item: %2 | Amount: %3 | Duration: %4 seconds",_type,_classname,_toCraft,_sec]]] remoteExec["Server_Log_New",2];

				};
			};
			
			if (!_hasFailed) then {
				[format [("STR_A3PL_Factory_BlueprintCraftSucceeded" call A3PL_Localize),_name,_type,([_id,_type,"output"] call A3PL_Config_GetFactory)*_toCraft],Color_Green] call A3PL_Notification;
				[getPlayerUID player,(player getVariable ["character_id",""]),"Factory_Craft_Completed",[format ["Factory: %1 | Item: %2 | Amount: %3 | Duration: %4 seconds",_type,_classname,_toCraft,_sec]]] remoteExec["Server_Log_New",2];
			};
			

			[player,_type,_id, _required, _toCraft, _hasFailed] remoteExec ["Server_Factory_Finalise", 2];
			sleep 1;
			private _var = player getVariable ["player_factories",[]];
			{
				if ((_x select 0) isEqualTo _craftID) exitwith {_var deleteAt _forEachIndex};
			} foreach _var;
		};
	};
}] call compile_Global;

["A3FL_Factory_LevelBoost", {
	private _timeEnd = param [0,0];
	_timeEnd;
}] call compile_Global;

//set all the items required, colour will display whether we have the item or not
["A3PL_Factory_SetRecipe",
{
	disableSerialization;
	private ["_display","_control","_type","_id","_desc","_classType","_class","_ctrlID","_preview","_lbArray"];
	_display = findDisplay 45;
	_ctrlID = param [0,1500];
	_preview = param [1,true];
	_type = _display getVariable ["A3PL_Factory_Type", ""];
	_control = _display displayCtrl _ctrlID;
	if ((lbCurSel _control) < 0) exitwith {};
	_id = _control lbData (lbCurSel _control);
	_required = [_id,_type,"required"] call A3PL_Config_GetFactory;
	_classType = [_id,_type,"type"] call A3PL_Config_GetFactory;
	if (_preview) then {
		[_type,_id] spawn A3PL_Factory_ObjectPreviewSpawn;
	};
	_control = _display displayCtrl 1501;

	_lbArray = [];
	{
		private ["_i","_name","_amount","_id"];
		_id = _x select 0;
		_amount = _x select 1;
		_name = format ["%1x %2",_amount,([_id,"name"] call A3PL_Config_GetItem)];
		if ([_id,_amount,_type] call A3PL_Factory_Has) then {
			_lbArray pushback [_name,_id,true];
		} else {
			_lbArray pushback [_name,_id,false];
		};
	} foreach _required;

	lbClear _control;
	{
		_i = _control lbAdd (_x select 0);
		_control lbSetData [_i,(_x select 1)];
		if (_x select 2) then {_control lbSetColor [_i,[0, 1, 0, 1]];} else {_control lbSetColor [_i,[1, 0, 0, 1]];};
	} foreach _lbArray;

	_desc = [_id,_type,"desc"] call A3PL_Config_GetFactory;
	_control = _display displayCtrl 1103;
	_control ctrlSetStructuredText parseText format ["%1",_desc];
}] call compile_Global;

["A3PL_Factory_Open",
{
	disableSerialization;
	private _type = param [0,""];
	if (!isNull Player_Item) then {call A3PL_Inventory_PutBack;};
	createDialog "Dialog_Factory";
	(findDisplay 45) call A3PL_Dialog_Localize;
	[] spawn A3PL_Factory_DialogLoop;
	[_type] spawn A3PL_Factory_ObjectPreview;
	[_type] spawn {
		disableSerialization;
		private _type = param [0,""];
		while {!isNull (findDisplay 45)} do {
			[_type] call A3PL_Factory_Refresh;
			uiSleep 0.5;
		};
	};

	private _display = findDisplay 45;
	private _control = _display displayCtrl 1100;
	_control CtrlSetText (_type call A3PL_Localize);
	_display setVariable ["A3PL_Factory_Type", _type];

	private _control = _display displayCtrl 1500;
	_control ctrlAddEventHandler ["LBSelChanged",{[1500] call A3PL_Factory_SetRecipe;}];
	private _recipes = ["all",_type] call A3PL_Config_GetFactory;

	{
		private _id = _x select 0;
		private _class = [_id,_type,"class"] call A3PL_Config_GetFactory;
		private _classType = [_id,_type,"type"] call A3PL_Config_GetFactory;
		private _img = [_class,_classType,"img"] call A3PL_Factory_Inheritance;
		private _name = [_class,_classType,"name"] call A3PL_Factory_Inheritance;
		_i = _control lbAdd _name;
		//_control lbSetPicture [_i,_img];
		_control lbSetData [_i,_id];
	} foreach _recipes;
	_control lbSetCurSel 0;

	[_type] call A3PL_Factory_Refresh;
}] call compile_Global;

//get the storage minus what we are using in crafting right now
["A3PL_Factory_GetStorage",
{
	private _type = param [0,""];
	private _player = param[1,player];
	private _storage = [_type,"items",_player] call A3PL_Config_GetPlayerFStorage;
	if (_storage isEqualType true) exitwith {_storage = []; _storage;};
	private _fact = _player getVariable ["player_factories",[]];
	private _subtract = [];

	{
		private ["_class","_amount","_items"];
		{
			_class = _x select 0;
			_amount = _x select 1;
			_subtract = [_subtract, _class, _amount, true] call BIS_fnc_addToPairs;
		} foreach (_x select 2);
	} foreach _fact;

	{
		private ["_class","_amount"];
		_class = _x select 0;
		_amount = _x select 1;
		_storage = [_storage, _class, -(_amount), true] call BIS_fnc_addToPairs;
	} foreach _subtract;

	{
		if ((_x select 1) < 1) then {
			_storage deleteAt _forEachIndex;
		};
	} forEach _storage;
	_storage;
}] call compile_Global;

["A3PL_Factory_Refresh",
{
	disableSerialization;
	private _type = param [0,""];
	private _display = findDisplay 45;
	if (isNull _display) exitwith {};
	private _control = _display displayCtrl 1502;
	private _storage = [_type] call A3PL_Factory_GetStorage;
	private _inventory = player getVariable ["player_inventory",[]];
	if (_storage isEqualType true) then {_storage = []};

	_lbArray = [];
	{
		private _id = _x select 0;
		private _amount = _x select 1;
		private _isFactory = _id splitString "_";
		private _name = "";
		private _img = "";
		if ((_isFactory select 0) isEqualTo "f") then {_isFactory = true;} else {_isFactory = false;};
		if (_isFactory) then {
			_class = [_id,_type,"class"] call A3PL_Config_GetFactory;
			_classType = [_id,_type,"type"] call A3PL_Config_GetFactory;
			_img = [_class,_classType,"img"] call A3PL_Factory_Inheritance;
			_name = [_class,_classType,"name"] call A3PL_Factory_Inheritance;
		} else {
			_name = [_id,"name"] call A3PL_Config_GetItem;
			_img = [_id,"icon"] call A3PL_Config_GetItem;
		};
		_lbArray pushback [format ["%1 (%2x)",_name,_amount],_id];
	} foreach _storage;

	lbClear _control;
	{
		_i = _control lbAdd (_x select 0);
		_control lbSetPicture [_i,""];
		_control lbSetData [_i,(_x select 1)];
	} foreach _lbArray;
	_lbArray = [];

	_control = _display displayCtrl 1503;
	{
		private ["_i","_id","_amount"];
		_id = _x select 0;
		_amount = _x select 1;
		_lbArray pushback [format ["%1 (%2x)",([_id,"name"] call A3PL_Config_GetItem),_amount],_id];
	} foreach _inventory;

	lbClear _control;
	{
		_i = _control lbAdd (_x select 0);
		_control lbSetData [_i,(_x select 1)];
	} foreach _lbArray;
	_i = _control lbAdd format ["Cash (%1x)",(player getvariable ["player_cash",0])];
	_control lbSetData [_i,"cash"];

	_near = player nearEntities [["Thing"],20];
	{
		if ((!isNil {_x getVariable ["ainv",nil]}) || (!isNil {_x getVariable ["finv",nil]}) || (isNil {_x getVariable ["class",nil]})) then
		{
			_near deleteAt _forEachIndex;
		};
	} foreach _near;
	{
		private _charID = (player getVariable ["character_id",""]);
		private _owner = _x getVariable ["owner",nil];
		private _cid = [_charID] call A3PL_Config_GetCompanyID;
		private _objCid = _x getVariable ["cid",0];
		if ((_charID) isEqualTo _owner || {_cid isEqualTo _objCid}) then
		{
			private _id = _x getVariable ["class",""];
			private _amount = 1;
			private _i = _control lbAdd format ["%1 (%2x)",([_id,"name"] call A3PL_Config_GetItem),_amount];
			_control lbSetData [_i,format ["OBJ_%1",_x]];
		};
	} foreach _near;
	[1500,false] call A3PL_Factory_SetRecipe;
}] call compile_Global;

["A3PL_Factory_Collect",
{
	private _display = findDisplay 45;
	private _control = _display displayCtrl 1502;
	if (lbCurSel _control < 0) exitwith {[("STR_A3PL_Factory_NoSelection" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if !(call A3PL_Player_AntiSpam) exitWith {[("STR_Common_AntiSpam" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _type = _display getVariable ["A3PL_Factory_Type", ""];
	private _id = _control lbData (lbCurSel _control);
	private _isCrafting = false;
	{
		if ((_x select 3) isEqualTo _type) exitwith {_isCrafting = true;};
	} foreach (player getVariable ["player_factories",[]]);
	if (_isCrafting) exitwith {[("STR_A3PL_Factory_ErrorCraftInProgress" call A3PL_Localize)] call A3PL_Notification;};

	private _classType = [_id,_type,"type"] call A3PL_Config_GetFactory;
	private _canPickup = [_id,"canPickup"] call A3PL_Config_GetItem;
	private _amount = if (_canPickup || {_classType isEqualTo "magazine"}) then {floor(parseNumber (ctrlText 1400))} else {1};

	if (_amount < 1) exitwith {["STR_Common_InvalidAmount" call A3PL_Localize,Color_Red] call A3PL_Notification;};
	if !([_id,_amount,_type] call A3PL_Factory_Has) exitwith {["STR_A3PL_Factory_NotEnoughToWithdraw" call A3PL_Localize,Color_Red] call A3PL_Notification;};
	if ((_canPickup) && {([[_id,_amount]] call A3PL_Inventory_TotalWeight) > Player_MaxWeight}) exitwith {["STR_Common_NotEnoughSpace" call A3PL_Localize,Color_Red] call A3PL_Notification;};
	// Verifier la place dans la grille d'inventaire virtuel
	if ((_canPickup) && {!([_id, _amount] call A3PL_InventoryNew_CanAddItem)}) exitWith {
		["STR_A3PL_Inventory_NotEnoughGridSpace" call A3PL_Localize, Color_Red] call A3PL_Notification;
	};
	
	[player,_type,[_id,_amount]] remoteExec ["Server_Factory_Collect",2];
	_type spawn {
		uiSleep 2;
		[_this] call A3PL_Factory_Refresh;
	};
}] call compile_Global;

["A3PL_Factory_Add",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private ["_display","_control","_type","_id","_amount","_typeOf","_fail","_obj","_cashCheck"];
	_display = findDisplay 45;
	_control = _display displayCtrl 1503;
	_type = _display getVariable ["A3PL_Factory_Type", ""];
	_id = _control lbData (lbCurSel _control);
	_control = _display displayCtrl 1400;
	_amount = floor(parseNumber (ctrlText _control));
	if (_amount < 1) exitwith {[("STR_Common_InvalidAmount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_fail = false;

	_splitted = _id splitString "_";
	if ((_splitted select 0) isEqualTo "OBJ") then
	{
		_typeOf = "";
		_typeOf = toArray _id;
		_typeOf deleteAt 0;_typeOf deleteAt 0;_typeOf deleteAt 0;_typeOf deleteAt 0;
		_typeOf = toString _typeOf;
	};
	if (_fail) exitwith {["System: Error retrieving object typeOf in _Factory_Add",Color_Red] call A3PL_Notification;};
	if (!isNil "_typeOf") then
	{
		_obj = [_typeOf] call A3PL_Lib_vehStringToObj;
	};
	if (_fail) exitwith {["System: Error retrieving object in _Factory_Add",Color_Red] call A3PL_Notification;};
	if (isNil "_obj") then
	{
		if(_id isEqualTo "cash") exitwith {[("STR_A3PL_Factory_CannotStoreMoney" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		if(_id IN Factory_BlackList) exitwith {[("STR_A3PL_Factory_CannotStoreIllegalItems" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		if ((_type isEqualTo ("STR_Common_FactoryName_Foods" call A3PL_Localize)) && (!(toLower _id IN Factory_Foods_AllowItems))) exitWith {[("STR_A3PL_Factory_CannotStoreFood" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		if ((_type isEqualTo ("STR_Common_FactoryName_Goods" call A3PL_Localize)) && (toLower _id IN Factory_Goods_BlackList)) exitWith {[("STR_A3PL_Factory_CannotStoreInThisFactory" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		[player,_type,[_id,_amount]] remoteExec ["Server_Factory_Add",2];
	}
	else
	{
		if (isNull _obj) exitwith {_fail = true};
		_id = _obj getVariable ["class",nil];
		if(_id IN ["distillery","distillery_hose","jug","jug_moonshine","jug_green","jug_green_moonshine","cocaine_brick","planter","scale","grinder","weed_rack","cocaine_barrel","fan","lamp_200w","lamp_500w","lamp_1000w"]) exitwith {[("STR_A3PL_Factory_CannotStoreIllegalItems" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		if (isNil "_id") exitwith {_fail = true};
		[player,_type,[_id,1],true,_obj] remoteExec ["Server_Factory_Add",2];
	};
	if (_fail) exitwith {["System: Error retrieving itemClass from object",Color_Red] call A3PL_Notification;};
}] call compile_Global;

["A3PL_Factory_ObjectPreview",
{
	disableSerialization;
	private _factory = param [0,""];
	private _display = findDisplay 45;
	private _logic = "logic" createvehicleLocal [0,0,0];
	_logic setposATL (["pos",_factory] call A3PL_Config_GetFactory);
	private _cam = "camera" camCreate [0,0,0];
	FACTORYCAMERA = _cam;
	FACTORYLOGIC = _logic;
	_cam camSetTarget _logic;
	_cam camCommit 0;
	_cam cameraEffect ["internal", "BACK"];
	_cam attachto [_logic, [0,5,2]];
	showCinemaBorder false;
	private _dir = random 359;
	private _interval = 0.1;
	while {!isNull _display} do {
		_dir = _dir + _interval;
		_logic setDir _dir;
		uiSleep 0.01;
	};

	{
		deleteVehicle _x;
	} foreach (attachedObjects (missionNameSpace getVariable ["A3PL_FACTORY_OBJPRV",objNull]));
	deleteVehicle (missionNameSpace getVariable ["A3PL_FACTORY_OBJPRV",objNull]);
	FACTORYCAMERA = nil;
	FACTORYLOGIC = nil;
	camDestroy _cam;
	deleteVehicle _logic;
	player cameraEffect ["terminate", "BACK"];
}] call compile_Global;

["A3PL_Factory_ObjectPreviewSpawn",
{
	disableSerialization;
	params[["_factory","",[""]],["_id","",[""]]];
	private _class = [_id,_factory,"class"] call A3PL_Config_GetFactory;
	private _itemType = [_id,_factory,"type"] call A3PL_Config_GetFactory;
	private _pos = ["pos",_factory] call A3PL_Config_GetFactory;
	private _display = findDisplay 45;
	private _camera = missionNameSpace getVariable ["FACTORYCAMERA",objNull];
	private _logic = missionNameSpace getVariable ["FACTORYLOGIC",objNull];
	private _curObj = missionNameSpace getVariable ["A3PL_FACTORY_OBJPRV",objNull];
	deleteVehicle _curObj;
	sleep 0.01;

	if (isNull findDisplay 45) exitwith {};
	if (!(call A3PL_Player_AntiListboxSpam)) exitwith {};

	switch (true) do
	{
		case (_itemType isEqualTo "item"):
		{
			_class = [_class,"class"] call A3PL_Config_GetItem;
			A3PL_FACTORY_OBJPRV = _class createvehicleLocal [0,0,0];
			A3PL_FACTORY_OBJPRV allowDamage false;
			A3PL_FACTORY_OBJPRV setPosATL _pos;
			A3PL_FACTORY_OBJPRV setDir (random 359);
			A3PL_FACTORY_OBJPRV enableSimulation false;
			_camera attachto [_logic, [0,2,2]];
		};

		case (_itemType IN ["weapon","magazine","aitem","weaponitem","secweaponitem"]):
		{
			A3PL_FACTORY_OBJPRV = "groundWeaponHolder" createvehicleLocal [0,0,0];
			switch (_itemType) do
			{
				case ("weapon"): {A3PL_FACTORY_OBJPRV addWeaponCargo [_class,1];};
				case ("magazine"): {A3PL_FACTORY_OBJPRV addMagazineCargo [_class,1];};
				case ("aitem"): {A3PL_FACTORY_OBJPRV addItemCargo [_class,1];};
				case ("weaponitem"): {A3PL_FACTORY_OBJPRV addItemCargo [_class,1];};
				case ("secweaponitem"): {A3PL_FACTORY_OBJPRV addItemCargo [_class,1];};
			};

			A3PL_FACTORY_OBJPRV setPosATL _pos;
			A3PL_FACTORY_OBJPRV setDir (random 359);
			_camera attachto [_logic, [0,0.1,1]];
		};

		case (_itemType IN ["car","plane","heli"]):
		{
			A3PL_FACTORY_OBJPRV = _class createvehicleLocal [0,0,0];
			A3PL_FACTORY_OBJPRV allowDamage false;
			A3PL_FACTORY_OBJPRV setPosATL _pos;
			A3PL_FACTORY_OBJPRV setDir (random 359);
			_camera attachto [_logic, [0,5,2]];
		};

		case (_itemType IN ["vest","uniform","goggles","headgear","backpack"]):
		{
			A3PL_FACTORY_OBJPRV = "C_man_p_beggar_F" createvehicleLocal [0,0,0];
			A3PL_FACTORY_OBJPRV allowDamage false;
			A3PL_FACTORY_OBJPRV setPosATL [_pos select 0,_pos select 1,((_pos select 2) - 1)];
			A3PL_FACTORY_OBJPRV setDir (random 359);
			A3PL_FACTORY_OBJPRV enableSimulation false;
			switch (_itemType) do
			{
				case ("uniform"): {removeUniform A3PL_FACTORY_OBJPRV; A3PL_FACTORY_OBJPRV addUniform _class; };
				case ("vest"): {removeVest A3PL_FACTORY_OBJPRV; A3PL_FACTORY_OBJPRV addVest _class; };
				case ("headgear"): {removeHeadGear A3PL_FACTORY_OBJPRV; A3PL_FACTORY_OBJPRV addHeadGear _class; };
				case ("backpack"): {removeBackPack A3PL_FACTORY_OBJPRV; A3PL_FACTORY_OBJPRV addBackPack _class; };
				case ("goggles"): {removeGoggles A3PL_FACTORY_OBJPRV; A3PL_FACTORY_OBJPRV addGoggles _class; };
				case ("weapon"): {removeAllWeapons A3PL_FACTORY_OBJPRV; A3PL_FACTORY_OBJPRV addWeapon _class; };
			};
			_camera attachto [_logic, [0,2,2]];
		};
	};
}] call compile_Global;

["A3PL_Factory_CrateInfo",
{
	private _crate = param [0,objNull];
	private _aInv = _crate getVariable ["ainv",nil];
	private _finv = _crate getVariable ["finv",nil];
	if ((isNil "_aInv") && (isNil "_finv")) exitwith {["System: Missing inv variables on this object in _CrateCheck -> report this bug",Color_Red] call A3PL_Notification;};
	[_aInv#0,_aInv#1,_aInv#2];
}] call compile_Global;

["A3PL_Factory_CrateName",
{
	private _id = param [0,""];
	private _classType = param [1,""];
	if (_classType isEqualTo "item") exitwith {[_id,"name"] call A3PL_Config_GetItem};
	private _name = switch (_classType) do {
			case "car": {getText (configFile >> "CfgVehicles" >> _id >> "displayName")};
			case "weapon": {getText (configFile >> "CfgWeapons" >> _id >> "displayName")};
			case "magazine": {getText (configFile >> "CfgMagazines" >> _id >> "displayName")};
			case "mag": {getText (configFile >> "CfgMagazines" >> _id >> "displayName")};
			case "uniform": {getText (configFile >> "CfgWeapons" >> _id >> "displayName")};
			case "vest": {getText (configFile >> "CfgWeapons" >> _id >> "displayName")};
			case "headgear": {getText (configFile >> "CfgWeapons" >> _id >> "displayName")};
			case "backpack": {getText (configFile >> "CfgWeapons" >> _id >> "displayName")};
			case "goggles": {getText (configFile >> "CfgGlasses" >> _id >> "displayName")};
			case "aitem": {getText (configFile >> "CfgWeapons" >> _id >> "displayName")};
			case "item": {[_id,"name"] call A3PL_Config_GetItem};
			default {getText (configFile >> "CfgVehicles" >> _id >> "displayName")};
		};
	_name;
}] call compile_Global;

["A3PL_Factory_CrateCollect",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private _crate = param [0,objNull];
	private _info = [_crate] call A3PL_Factory_CrateInfo;
	private _classtype = _info select 0;
	private _id = _info select 1;
	private _amount = _info select 2;
	private _owner = _crate getVariable ["owner",""];
	private _charID = (player getVariable ["character_id",""]);
	private _cid = [_charID] call A3PL_Config_GetCompanyID;
	private _objCid = _crate getVariable ["cid",0];

	if ((_charID isNotEqualTo _owner) && (_cid isNotEqualTo _objCid)) exitwith {[("STR_A3PL_Factory_AskOwnerToSell" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _fail = false;
	private _exit = false;
	switch (_classtype) do {
		case ("item"): {
			[_id,_amount] call A3PL_Inventory_Add;
		};
		case ("weapon"): {
			if(player canAdd [_id, _amount]) then {
				player addItem _id;
			} else {
				player addWeapon _id;
			};
		};
		case ("magazine"): {
			if(player canAdd [_id, _amount]) then {
				player addMagazines [_id,_amount];
			} else {
				_exit = true;
			};
		};
		case ("aitem"): {
			if(player canAdd [_id, _amount]) then {
				for [{_i = 0}, {_i < _amount},{_i = _i + 1}] do {
					player addItem _id;
				};
			} else {
				_exit = true;
			};
		};
		case ("uniform"): {player addUniform _id; };
		case ("vest"): {player addVest _id;};
		case ("headgear"): {player addHeadGear _id;};
		case ("backpack"): {player addBackPack _id;};
		case ("goggles"): {player addGoggles _id;};
		default {_fail = true;};
	};
	if (_exit) exitwith {[("STR_A3PL_Factory_NotEnoughSpace" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_fail) exitwith {[format ["Error: Undefined _classType in _CrateCollect (ID: %1) > report this bug",_id],Color_Red] call A3PL_Notification;};
	deleteVehicle _crate;
	[format [("STR_A3PL_Factory_Took" call A3PL_Localize),_amount,[_id,_classType] call A3PL_Factory_CrateName],Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Factory_CrateCheck",
{
	private _crate = param [0,objNull];
	if ((isNil {_crate getVariable ["aInv",nil]}) && (isNil {_crate getVariable ["fInv",nil]})) exitwith {
		private _id = _crate getVariable ["class",""];
		private _amount = _crate getVariable ["amount",1];
		private _name = [_id,"name"] call A3PL_Config_GetItem;
		[format [("STR_A3PL_Factory_WhatIsIt" call A3PL_Localize),_amount,_name],Color_Green] call A3PL_Notification;
	};
	if (_crate getVariable["JobCargo",false]) exitWith {[("STR_A3PL_Factory_ItsABox" call A3PL_Localize),Color_Green] call A3PL_Notification;};
	private _info = [_crate] call A3PL_Factory_CrateInfo;
	private _classType = _info#0;
	private _id = _info#1;
	private _amount = _info#2;
	private _name = [_id,_classType] call A3PL_Factory_CrateName;
	[format [("STR_A3PL_Factory_WhatIsIt" call A3PL_Localize),_amount,_name],Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Factory_GetRemaining",
{
	private _factory = param [0,("STR_A3PL_Factory_Undefined" call A3PL_Localize)];
	if(_factory isEqualTo ("STR_A3PL_Factory_Undefined" call A3PL_Localize)) exitWith {};
	private _time = "";
	private _craftID = -1;
	private _var = player getVariable ["player_factories",[]];
	private _time = "";
	{
		if (([(_x select 0), "type"] call A3PL_Config_GetPlayerFactory) isEqualTo _factory) exitWith {_craftID = (_x select 0);};
	} foreach _var;

	if(_craftID < 0) then {
		_time = ("STR_Common_Available" call A3PL_Localize);
	} else {
		_timeEnd = [_craftID, "finish"] call A3PL_Config_GetPlayerFactory;
		_time = str(-(diag_ticktime) + _timeEnd);
	};
	_time;
}] call compile_Global;

["A3PL_Factory_GetRemainingName",
{
	private _factory = param [0,("STR_A3PL_Factory_Undefined" call A3PL_Localize)];
	if(_factory isEqualTo ("STR_A3PL_Factory_Undefined" call A3PL_Localize)) exitWith {};
	private _return = "";
	private _craftID = -1;
	private _var = player getVariable ["player_factories",[]];
	{
		if (([(_x select 0), "type"] call A3PL_Config_GetPlayerFactory) isEqualTo _factory) exitWith {_craftID = (_x select 0);};
	} foreach _var;
	if(_craftID < 0) exitWith {""};

	private _id = [_craftID, "id"] call A3PL_Config_GetPlayerFactory;
	private _return = [([_id,_factory,"class"] call A3PL_Config_GetFactory),([_id,_factory,"type"] call A3PL_Config_GetFactory),"name"] call A3PL_Factory_Inheritance;
	_return;
}] call compile_Global;

["A3PL_Factory_AdjustRemaining",
{
	private _time = param [0,"0"];
	private _time = round(parseNumber(_time));
	private _return = "";
	if (_time < 0) then {_time = 0};
	if(_time > 60) then {
		_minLeft = ceil (_time/60);
		_return = format [("STR_A3PL_Factory_iPhoneRemainingMinutes" call A3PL_Localize),round(_minLeft)];
		if(_minLeft > 60) then {
			_return = format [("STR_A3PL_Factory_iPhoneRemainingHours" call A3PL_Localize),round(_minLeft/60)];
		};
	} else {
		_return = format [("STR_A3PL_Factory_iPhoneRemainingSeconds" call A3PL_Localize),ceil _time];
	};
	_return;
}] call compile_Global;

["A3PL_Factory_Cancel",
{
	waitUntil{((progressPosition ((findDisplay 45) displayCtrl 1105)) isEqualTo 0) || {isNull (findDisplay 45)}};
	Player_CraftInterrupt = nil;
}] call compile_Global;

["A3PL_Factory_Search",
{
	disableSerialization;
	private _display = findDisplay 45;
	if (isNull _display) exitwith {};
	private _search = ctrlText (_display displayCtrl 1405);
	private _type = _display getVariable ["A3PL_Factory_Type", ""];
	private _control = _display displayCtrl 1500;
	lbClear _control;
	private _recipes = ["all",_type] call A3PL_Config_GetFactory;
	{
		private _id = _x select 0;
		private _class = [_id,_type,"class"] call A3PL_Config_GetFactory;
		private _classType = [_id,_type,"type"] call A3PL_Config_GetFactory;
		private _name = [_class,_classType,"name"] call A3PL_Factory_Inheritance;
		if([_search, _name] call BIS_fnc_inString) then {
			private _img = [_class,_classType,"img"] call A3PL_Factory_Inheritance;
			_i = _control lbAdd _name;
			_control lbSetPicture [_i,_img];
			_control lbSetData [_i,_id];
		};
	} foreach _recipes;
	_control lbSetCurSel 0;
}] call compile_Global;
