/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Inventory_Get", {
	private _player = param [0,player];
	private _inv = _player getVariable ["player_inventory",[]];
	_inv;
}] call compile_Global;

["A3PL_Inventory_GetCash", {
	private _player = param [0,player];
	private _cash = _player getvariable ["player_cash",0];
	_cash;
}] call compile_Global;

["A3PL_Inventory_Clear",
{
	private _obj = param [0,Player_Item];
	private _delete = param [1,true];
	private _setNull = param [2,true];
	if (_delete) then {
		deleteVehicle _obj;
	};
	if (_setNull) then {
		Player_Item = objNull;
		Player_ItemClass = '';
	};
}] call compile_Global;

["A3PL_Inventory_Add", {
	params [
		["_class", "", [""]],
		["_amount", 0, [0]], 
		["_bypass", false, [false]]
	];
	private _exit = false;
	if(!_bypass) then {
		if(_amount > 0) then {
			if (([[_class,_amount]] call A3PL_Inventory_TotalWeight) > Player_MaxWeight) exitwith {
				_exit = true;
				[format [("STR_A3PL_Inventory_YouCantAddThisObjectToYourInventory" call A3PL_Localize),Player_MaxWeight],Color_Red] call A3PL_Notification;
			};
		};
	};
	if(_exit) exitwith {};
	[player, _class, _amount] remoteExec ["Server_Inventory_Add",2];
}] call compile_Global;

["A3PL_Inventory_SetCurrent", {
	private _weight = [] call A3PL_Inventory_TotalWeight;
	if(_weight < 200) then {
		if(isForcedWalk player) then {player forceWalk false;};
	} else {
		if(!isForcedWalk player) then {player forceWalk true;};
	};
}] call compile_Global;

["A3PL_Inventory_Remove", {
	params ["_class", "_amount"];
	[_class, -(_amount)] call A3PL_Inventory_Add;
}] call compile_Global;

["A3PL_Inventory_Verify", {
	private _player = param [0,player];
	private _change = false;
	{
		if ((_x select 1) < 1) then {
			_index = _forEachIndex;
			(_player getVariable "Player_Inventory") set [_index, "REMOVE"];
			_change = true;
		};
	} forEach (_player getVariable "Player_Inventory");
	if (_change) then {
		_player setVariable ["Player_Inventory", ((_player getVariable "Player_Inventory") - ["REMOVE"]), true];
	};
	[] call A3PL_Inventory_SetCurrent;
}] call compile_Global;

["A3PL_Inventory_Return", {
	private _class = param [0,""];
	private _player = param [1,player];
	private _amount = [(_player getVariable ["Player_Inventory",[]]), _class, 0] call BIS_fnc_getFromPairs;
	_amount;
}] call compile_Global;

["A3PL_Inventory_Has", {
	private _class = param [0,""];
	private _amount = param [1,1];
	private _player = param [2,player];
	if (_class isEqualTo "cash") exitwith {if (_player getVariable ["player_cash",0] >= _amount) then {true;} else {false;};};
	private _inventoryAmount = [_class,_player] call A3PL_Inventory_Return;
	if (_inventoryAmount < _amount) exitWith {false};
	true
}] call compile_Global;

["A3PL_Inventory_TotalWeight",
{
	private ["_inventory"];
	private _return = 0;
	private _itemToAdd = _this;
	if (count _itemToAdd > 1) then {
		_itemToAdd = _itemToAdd select 0;
		_inventory = [(_itemToAdd select 1)] call A3PL_Inventory_Get;
	} else {
		_inventory = [player] call A3PL_Inventory_Get;
	};
	if (count _itemToAdd > 0) then {
		{
			_inventory = [_inventory, (_x select 0), (_x select 1), true] call BIS_fnc_addToPairs;
		} foreach _itemToAdd;
	};

	{
		private ["_amount", "_itemWeight"];
		_amount = _x select 1;
		_itemWeight = ([_x select 0, 'weight'] call A3PL_Config_GetItem) * _amount;
		_return = _return + _itemWeight;
	} forEach _inventory;
	_return;
}] call compile_Global;

["A3PL_Inventory_Open", {
	if(player getVariable ["patdown",false]) exitwith {
		[("STR_Common_DuplicateAttempt" call A3PL_Localize),Color_Red] call A3PL_Notification;
		[getPlayerUID player,(player getVariable ["character_id",""]),"BugAttempt_PatdownDupe",[format ["WTF: %1","PatdownVirtCloningAttempt"]]] remoteExec ["Server_Log_New",2];
	};
	if(player getVariable["inventory_opened",false]) exitWith {};
	if(Player_ActionDoing) exitWith {[("STR_A3PL_Inventory_YouCantOpenYourInventoryByDoingSomething" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if((vehicle player == player) && (!(animationState player IN ["crew"]))) then {
		player playMove 'AmovPercMstpSnonWnonDnon_AinvPercMstpSnonWnonDnon';
	};

	player setVariable ["inventory_opened", true, true];
	createDialog "Dialog_Inventory";
	(findDisplay 1001) call A3PL_Dialog_Localize;

	(findDisplay 1001) displayAddEventHandler ["MouseButtonDown", {
		params ["_display", "_button", "_xPos", "_yPos"];
		if (_button == 0) then {
			// Use the same function as display 46 for consistency
			private _slotIndex = [_xPos, _yPos] call A3PL_Hotbar_GetSlotAtPosition;
			if (_slotIndex >= 0) then {
				[_slotIndex] call A3PL_Hotbar_StartDragFromHotbar;
			};
		};
	}];
	(findDisplay 1001) displayAddEventHandler ["MouseButtonUp", {
		params ["_display", "_button", "_xPos", "_yPos"];
		if (_button == 0) then {
			[] call A3PL_Hotbar_EndDrag;
		};
	}];

	[] call A3PL_Inventory_Populate;
	[] spawn {
		_hndl = ppEffectCreate ['dynamicBlur', 505];
		_hndl ppEffectEnable true;
		_hndl ppEffectAdjust [5];
		_hndl ppEffectCommit 0;

		waitUntil {isNull findDisplay 1001};
		if(!([player,"head","pepper_spray"] call A3PL_Medical_HasWound)) then {
			ppEffectDestroy _hndl;
		};
		player setVariable ["inventory_opened", false, true];
	};
}] call compile_Global;

["A3PL_Inventory_Populate", {
	private ['_display','_keys',"_cash"];
	_display = findDisplay 1001;

	buttonSetAction [14671, "[] call A3PL_Inventory_Use"];
	buttonSetAction [14672,
	"
		private ['_display','_amount'];
		_amount = floor(parseNumber (ctrlText 14471));
		if (_amount < 1) exitwith {['STR_A3PL_Inventory_EnterValidAmount' call A3PL_Localize,Color_Red] call A3PL_Notification;};
		['',true] call A3PL_Inventory_Use;
		[true,_amount] call A3PL_Inventory_Drop;
	"];
	buttonSetAction [14674, "closeDialog 0;"];

	_control = _display displayCtrl 14571;
	{
		private ["_itemName", "_amount", "_index","_itemWeight"];
		_itemName = [_x select 0, "name"] call A3PL_Config_GetItem;
		_itempicture = [_x select 0, "picture"] call A3PL_Config_GetItem;
		_amount = _x select 1;
		_itemWeight = ([_x select 0, "weight"] call A3PL_Config_GetItem) * _amount;

		_index = _control lbAdd format[("STR_A3PL_Inventory_Weight" call A3PL_Localize), _itemName, _amount, _itemWeight];
		_control lbSetData [_index, _x select 0];
		_control lbSetPicture [_index,_itempicture];
	} forEach ([] call A3PL_Inventory_Get);

	private _pControl = _display displayCtrl 14573;
	private _playerWeapons = weapons player select {
		private _weaponType = getNumber (configFile >> "CfgWeapons" >> _x >> "type");
		_weaponType != 4096
	};
	{
		private _weaponClass = _x;
		private _weaponName = getText (configFile >> "CfgWeapons" >> _weaponClass >> "displayName");
		private _weaponPicture = getText (configFile >> "CfgWeapons" >> _weaponClass >> "picture");

		private _index = _pControl lbAdd _weaponName;
		_pControl lbSetData [_index, _weaponClass];
		_pControl lbSetPicture [_index, _weaponPicture];
	} forEach _playerWeapons;

	_pControl ctrlRemoveAllEventHandlers "MouseButtonDown";
	_pControl ctrlAddEventHandler ["MouseButtonDown", {
		params ["_control", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];
		if (_button == 0) then {
			private _index = lbCurSel _control;
			if (_index >= 0) then {
				private _itemClass = _control lbData _index;
				if (_itemClass != "") then {
					[_itemClass] call A3PL_Hotbar_StartDragFromInventory;
				};
			};
		};
	}];

	_pControl ctrlRemoveAllEventHandlers "MouseButtonUp";
	_pControl ctrlAddEventHandler ["MouseButtonUp", {
		params ["_control", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];
		if (_button == 0) then {
			[] call A3PL_Hotbar_EndDrag;
		};
	}];

	_control ctrlRemoveAllEventHandlers "KeyDown";
	_control ctrlAddEventHandler ["KeyDown", {_this call A3PL_Inventory_Reorganize;}];

	_control ctrlRemoveAllEventHandlers "MouseButtonDown";
	_control ctrlAddEventHandler ["MouseButtonDown", {
		params ["_control", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];
		if (_button == 0) then {
			private _index = lbCurSel _control;
			if (_index >= 0) then {
				private _itemClass = _control lbData _index;
				if (_itemClass != "") then {
					[_itemClass] call A3PL_Hotbar_StartDragFromInventory;
				};
			};
		};
	}];

	_control ctrlRemoveAllEventHandlers "MouseButtonUp";
	_control ctrlAddEventHandler ["MouseButtonUp", {
		params ["_control", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];
		if (_button == 0) then {
			[] call A3PL_Hotbar_EndDrag;
		};
	}];

	_control = _display displayCtrl 14471;
	_control ctrlSetText "1";

	_keys = player getVariable ["keys",[]];
	if (isNil "_keys") exitwith {};
	{
		_count = count _x;
		if (count _x isEqualTo 4) then {
			_index = lbAdd [1900,format [("STR_A3PL_Inventory_GreenhouseKey" call A3PL_Localize),_x]];
			lbSetData [1900, _index,_x];
		};
		if (count _x isEqualTo 5) then {
			_index = lbAdd [1900,format [("STR_A3PL_Inventory_HouseKey" call A3PL_Localize),_x]];
			lbSetData [1900, _index,_x];
		};
		if (count _x isEqualTo 6) then
		{
			_index = lbAdd [1900,("STR_A3PL_Inventory_MotelKey" call A3PL_Localize)];
			lbSetData [1900, _index,_x];
		};
		if (count _x isEqualTo 8) then {
			_index = lbAdd [1900,format [("STR_A3PL_Inventory_WarehouseKey" call A3PL_Localize),_x]];
			lbSetData [1900, _index,_x];
		};
		if (count _x isEqualTo 9) then {
			_index = lbAdd [1900,format [("STR_A3PL_Inventory_CrackhouseKey" call A3PL_Localize),_x]];
			lbSetData [1900, _index,_x];
		};
	} forEach _keys;

	if(count(player getVariable ["licenses",[]]) isEqualTo 0) then {
		lbAdd [1503,("STR_A3PL_Inventory_NoLicenses" call A3PL_Localize)];
	} else {
		{
			lbAdd [1503,([_x,0] call A3PL_Config_GetLicenseData)];
		} forEach (player getVariable ["licenses",[]]);
	};

	_cash = player getVariable "Player_Cash";
	if (isNil "_cash") exitwith {};
	if (_cash isEqualTo 0) exitwith {};
	_index = lbAdd [14571, format[("STR_A3PL_Inventory_CashSign" call A3PL_Localize), [player getVariable ["Player_Cash",0], 1, 0, true] call CBA_fnc_formatNumber]];
	lbSetData [14571, _index, "cash"];

	private _infoLines = [];

	private _capacity = round(((call A3PL_Inventory_TotalWeight)/Player_MaxWeight)*100);
	private _capColor = switch(true) do {
		case (_capacity >= 100): {"#ff0000"};
		case (_capacity >= 75): {"#FFA500"};
		case (_capacity >= 50): {"#FFFF00"};
		case (_capacity < 20): {"#00FF00"};
		default {"#FFFFFF"};
	};
	_infoLines pushBack format["<t font='PuristaSemiBold' align='center' size='0.75' color='#CCCCCC'>Capacity: <t color='%1'>%2%%</t></t>", _capColor, _capacity];

	private _perkDay = player getVariable ["Player_PerkDay",0];
	private _premColor = "#ff0000";
	private _premText = "No offer";
	if (_perkDay > 15) then {
		_premColor = "#00FF00";
		_premText = format["%1 days", _perkDay];
	} else {
		if (_perkDay > 3) then {
			_premColor = "#FFFF00";
			_premText = format["%1 days", _perkDay];
		} else {
			if (_perkDay > 0) then {
				_premText = format["%1 %2", _perkDay, if (_perkDay == 1) then {"day"} else {"days"}];
			};
		};
	};
	_infoLines pushBack format["<t font='PuristaSemiBold' align='center' size='0.65'><img size='0.65' color='#FFFFFF' image='A3PL_Common\icons\fydpass.paa'/> Premium: <t color='%1'>%2</t></t>", _premColor, _premText];

	private _ptText = "";
	if (Player_PlayTime == 0) then {
		_ptText = "<t color='#ff0000'>None</t>";
	} else {
		private _months = floor(Player_PlayTime / (60 * 24 * 30));
		private _days = floor((Player_PlayTime % (60 * 24 * 30)) / (60 * 24));
		private _hours = floor((Player_PlayTime % (60 * 24)) / 60);
		private _minutes = Player_PlayTime % 60;

		private _parts = [];
		if (_months > 0) then { _parts pushBack format["%1 month%2", _months, if (_months > 1) then {"s"} else {""}]; };
		if (_days > 0) then { _parts pushBack format["%1 day%2", _days, if (_days > 1) then {"s"} else {""}]; };
		if (_hours > 0) then { _parts pushBack format["%1 hour%2", _hours, if (_hours > 1) then {"s"} else {""}]; };
		if (_minutes > 0) then { _parts pushBack format["%1 min%2", _minutes, if (_minutes > 1) then {"s"} else {""}]; };

		_ptText = format["<t color='#00FF00'>%1</t>", _parts joinString ", "];
	};
	_infoLines pushBack format["<t font='PuristaSemiBold' align='center' size='0.65' color='#CCCCCC'>Playtime: %1</t>", _ptText];

	_control = _display displayCtrl 1605;
	_control ctrlSetStructuredText parseText (_infoLines joinString "<br/>");
}] call compile_Global;

["A3PL_Inventory_Reorganize", {
	params ["_displayorcontrol", "_key", "_shift", "_ctrl", "_alt"];
	if(isNull _displayorcontrol) exitWith {false};
	if !(_key IN [201,209]) exitWith {false};
	if(!(call A3PL_Player_AntiSpam)) exitWith {true};
	private _curIndex = lbCurSel _displayorcontrol;
	if(_curIndex < 0) exitwith {true};
	if((_displayorcontrol lbData _curIndex) isEqualTo "cash") exitWith {true};
	private _inventory = [] call A3PL_Inventory_Get;
	if((_curIndex isEqualTo count(_inventory)-1) && {_key isEqualTo 209}) exitWith {true};
	private _curItem = _inventory#_curIndex;
	private _newInventory = [];
	_inventory deleteAt _curIndex;
	private _targetIndex = if(_key isEqualTo 201) then {_curIndex - 1} else {_curIndex + 1};
	if(_targetIndex isEqualTo -1) exitwith {true};
	for "_i" from 0 to _targetIndex-1 do {
		_newInventory pushBack [(_inventory#_i#0),(_inventory#_i#1)];
	};
	_newInventory pushBack [_curItem#0,_curItem#1];
	for "_i" from _targetIndex to (count _inventory)-1 do {
		_newInventory pushBack [(_inventory#_i#0),(_inventory#_i#1)];
	};
	player setVariable ["player_inventory",_newInventory,true];
	lbClear _displayorcontrol;
	{
		private ["_itemName", "_amount", "_index","_itemWeight"];
		_itemName = [_x#0, "name"] call A3PL_Config_GetItem;
		_amount = _x#1;
		_itemWeight = ([_x#0, "weight"] call A3PL_Config_GetItem) * _amount;
		_index = _displayorcontrol lbAdd format[("STR_A3PL_Inventory_Weight" call A3PL_Localize), _itemName, _amount, _itemWeight];
		_displayorcontrol lbSetData [_index, _x#0];
	} forEach _newInventory;
	_index = _displayorcontrol lbAdd format[("STR_A3PL_Inventory_CashSign" call A3PL_Localize), [player getVariable ["Player_Cash",0], 1, 0, true] call CBA_fnc_formatNumber];
	_displayorcontrol lbSetData [_index, "cash"];
	_displayorcontrol lbSetCurSel _targetIndex;
	true;
}] call compile_Global;

["A3PL_Inventory_Use",
{
	disableSerialization;
	private ['_selection', '_classname', '_itemClass', '_itemDir', '_canUse', '_format',"_display","_attach"];
	_className = param [0,""];
	_forDrop = param [1,false];
	_amount = 1;
	if (_className isEqualTo "") then
	{
		_display = findDisplay 1001;
		_selection = lbCurSel 14571;
		_classname = lbData [14571, _selection];
		_amount = floor(parseNumber (ctrlText (_display displayCtrl 14471)));
	};

	_itemClass = [_classname, 'class'] call A3PL_Config_GetItem;
	_itemDir = [_classname, 'dir'] call A3PL_Config_GetItem;
	_canUse = [_classname, 'canUse'] call A3PL_Config_GetItem;
	_attach = [_classname, 'attach'] call A3PL_Config_GetItem;
	_maxTake = [_classname, 'maxTake'] call A3PL_Config_GetItem;

	if (_canUse isEqualTo false) exitWith {[("STR_A3PL_Inventory_CantBeUsed" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((animationState player) isEqualTo "A3PL_TakenHostage") exitwith {[("STR_A3PL_Inventory_CantUseHostage" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (animationState player IN ["a3pl_handsuptokneel","a3pl_handsupkneelgetcuffed","a3pl_cuff","a3pl_handsupkneelcuffed","a3pl_handsupkneelkicked","a3pl_cuffkickdown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","a3pl_handsupkneel"]) exitWith {[("STR_A3PL_Inventory_CantUseHandcuffed" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!(isNull Player_Item)) then {[false] call A3PL_Inventory_PutBack;};

	if (_amount < 1) exitWith {[("STR_A3PL_Inventory_DoesntHaveThisAmountToTake" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!([_classname,_amount] call A3PL_Inventory_Has)) exitwith {[("STR_A3PL_Inventory_DoesntHaveThisAmountToTake" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_maxTakeErr = false;
	if(!_forDrop) then {
		if (_amount > _maxTake) exitwith {
			[format[("STR_A3PL_Inventory_MaxTake" call A3PL_Localize),_maxTake],Color_Red] call A3PL_Notification;
			_maxTakeErr = true;
		};
	};
	if(_maxTakeErr) exitWith {};

	Player_ItemAmount = _amount;
	if((vehicle player) == player) then {
		Player_Item = _itemClass createVehicle (getPos player);
	};
	if (_classname isEqualTo "popcornbucket") then {
		Player_Item attachTo [player, _attach, 'LeftHand'];
	} else {
		Player_Item attachTo [player, _attach, 'RightHand'];
	};

	Player_Item setVariable["class",_classname,true];
	Player_Item setVariable["held", true, true];

	if (((vehicle player) isEqualTo player) && (!(animationState player IN ["crew"]))) then {player playMove 'AmovPercMstpSnonWnonDnon_AmovPercMstpSrasWpstDnon';};

	Player_Item setDir _itemDir;
	Player_ItemClass = toLower _classname;
	if (!isNil "_display") then {closeDialog 0;};
	if (_classname isEqualTo "Lifebuoy") then {Player_Item allowDamage false;};
	if (_classname isEqualTo "evidence_marker") then {[Player_Item] call A3PL_Police_EvidenceMarker;};

	[Player_Item,_attach] spawn A3PL_Placeable_AttachedLoop;
}] call compile_Global;

["A3PL_Inventory_PutBack", {
  private _displayNotification = param [0, true];
	private _itemClass = Player_ItemClass;

	if (_itemClass isEqualTo "") exitwith {["There is no itemClass assigned",Color_Red] call A3PL_Notification;};
	if !((Player_Item getVariable["evidence",""]) isEqualTo "") exitWith {[("STR_A3PL_Inventory_CantBeStoredInYourInventory" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	detach Player_Item;
	deleteVehicle Player_Item;

	Player_Item = objNull;
	Player_ItemClass = '';
	Player_ItemAmount = nil;
	if (_displayNotification isEqualTo true) then {
		if (!(animationState player IN ["crew"])) then {
			player playMove 'AmovPercMstpSnonWnonDnon_AmovPercMstpSrasWpstDnon';
		};
		private _format = format[("STR_A3PL_Inventory_YouStored" call A3PL_Localize), [_itemClass, 'name'] call A3PL_Config_GetItem];
		[_format,Color_Yellow] call A3PL_Notification;
	};
}] call compile_Global;

["A3PL_Inventory_Drop", {
	private _setPos = param [0,true];
	private _amount = param [1,0];
	private _itemClass = param [2,Player_ItemClass];;
	private _obj = Player_Item;
	private _droppedItems = server getVariable 'droppedObjects';
	if(!isNil 'Player_ItemAmount' && {_amount isEqualTo 0}) then {_amount = Player_ItemAmount;};

	if(_amount < 1) exitWith {[("STR_A3PL_Inventory_EnterValidAmount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!([_itemClass,_amount] call A3PL_Inventory_Has)) exitwith {[("STR_A3PL_Inventory_DontHaveThisAmountToDrop" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (isNull _obj) exitwith {[("STR_A3PL_Inventory_NothingToDropInYourHands" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!isNil "Player_isEating") exitwith {[("STR_A3PL_Inventory_CantDoThisByEating" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!isNil "Player_isDrinking") exitwith {[("STR_A3PL_Inventory_CantDoThisByDrinking" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!(animationState player IN ["crew"])) then {player playMove 'AmovPercMstpSnonWnonDnon_AinvPercMstpSnonWnonDnon_Putdown';};

	if (_setPos) then
	{
		switch(_itemClass) do {
			case ("fd_mask"): {
				deleteVehicle _obj;
				_holder = createVehicle ["GroundWeaponHolder", getposATL player, [], 0, "CAN_COLLIDE"];
				_holder addItemCargoGlobal ["A3PL_FD_Mask",1];
			};
			case ("bucket_empty"): {
				if(_amount <= 5) then {
					deleteVehicle _obj;
					private _pos = getPos player;
					private _dir = getDir player;
					private _val = 1.5;
					for "_i" from 1 to _amount do {
						_bucket = createVehicle ["A3PL_Bucket", [(_pos select 0) + (sin _dir * _val),(_pos select 1) + (cos _dir * _val),(_pos select 2)], [], 0, "CAN_COLLIDE"];
						_bucket setVariable["owner",(player getVariable ["character_id",""]),true];
						_bucket setVariable["class","bucket_empty",true];
						_bucket setVariable["amount",1,true];
						_val = _val + 0.5;
					};
				} else {
					detach _obj;
					_obj setPosASL (AGLtoASL (player modelToWorld [0,1,0]));
				};
			};
			default {
				detach _obj;
				_obj setPosASL (AGLtoASL (player modelToWorld [0,1,0]));
			};
		};
	};

	Player_Item setVariable ["held", nil, true];
	Player_Item = objNull;
	Player_ItemClass = '';
	switch (_itemclass) do {
		case "doorkey": {[_obj, player] remoteExec ['Server_Housing_dropKey', 2];};
		case "cash": {[player,_obj,_itemClass,Player_ItemAmount] remoteExec ["Server_Inventory_Drop", 2];};
		default {
			if ((_itemClass isEqualTo "evidence_bag") && (_obj getVariable["evidence",""] isNotEqualTo "")) exitWith {};
			[player,_obj,_itemClass,_amount] remoteExec ["Server_Inventory_Drop", 2];
		};
	};
	[format[("STR_A3PL_Inventory_YouDropped" call A3PL_Localize), _amount, [_itemClass, 'name'] call A3PL_Config_GetItem],Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Inventory_Pickup", {
	private _obj = param [0,objNull];
	private _moveToHand = param [1,false];
	private _amount = _obj getVariable ["amount",1];
	private _exitAP = false;
	private _exitAC = false; 

	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	if (_obj getVariable ["inUse",false]) exitWith {[("STR_A3PL_Inventory_CantPickObjectInUsing" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if(Player_ActionDoing) exitWith {[("STR_A3PL_Inventory_CantPickObjectInUsing" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if((player getVariable ["Cuffed",false]) || (player getVariable ["Zipped",false])) exitWith {};
	if (isNull _obj) exitwith {[("STR_A3PL_Inventory_InventoryErrorCode1" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _classname = _obj getVariable "class";
	if (isNil "_classname") exitwith {[("STR_A3PL_Inventory_InventoryErrorCode2" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!isNull Player_Item) exitwith {[("STR_A3PL_Inventory_AlreadyHaveObjectInHands" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _canPickup = [_classname,"canPickup"] call A3PL_Config_GetItem;
	if (_canPickup) then {
		private _weightOver = ([[_classname,_amount]] call A3PL_Inventory_TotalWeight) > Player_MaxWeight;
		if (_weightOver) exitWith {[("STR_Common_NotEnoughSpace" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	};
	

	private _isPlanterFull = false;
	if (_className isEqualTo "planter") then {
		_nearPlants = nearestObjects [player, Housing_Max_Items_Planter,3];
		if (count(_nearPlants) >= 1) then {_isPlanterFull = true;};
	};

	if (_isPlanterFull) exitWith {[("STR_A3PL_Inventory_PlantFull" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _attachedTo = attachedTo _obj;
	if (!isNull _attachedTo) then {
		if ((isPlayer _attachedTo) && (!(_attachedTo isKindOf "Car"))) then {
			_exitAP = true;
		};
		if ((_classname isEqualTo "jerrycan") && (_attachedTo isKindOf "Car")) then {
			_exitAC = true;
		};
	};
	if (_exitAP) exitwith {[("STR_A3PL_Inventory_CantPickObjectFromAnotherPlayer" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_exitAC) exitwith {[("STR_A3PL_Inventory_CantPickJerrycanByUse" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((_classname isEqualTo "toolbox") && (!((player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] IN [("STR_Common_FISD" call A3PL_Localize)])))) exitWith {[("STR_A3PL_Inventory_OnlySDCanMove" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (((count (_obj getVariable ["ainv",[]])) != 0) OR ((count (_obj getVariable ["finv",[]])) != 0)) exitwith {[_obj] call A3PL_Placeables_Pickup;};

	
	if (!_canPickup) exitwith {[_obj] call A3PL_Placeables_Pickup;};
	if ((typeOf _obj) isEqualTo "A3PL_FD_HoseEnd1_Float") then
	{
		private _hydrant = (nearestObjects [_obj,["Land_A3PL_FireHydrant"], 1]) select 0;
		if (!isNil "_hydrant") then {
			_hydrant animateSource ["cap_hide",0];
		};
	};
	if ((_classname isEqualTo "evidence_bag") && {!((_obj getVariable["evidence",""]) isEqualTo "")}) exitWith {
		_attach = [_classname, 'attach'] call A3PL_Config_GetItem;
		Player_ItemAmount = 1;
		Player_Item = _obj;
		Player_Item setVariable ["held", true, true];
		Player_Item attachTo [player, _attach, 'RightHand'];
		Player_Item setDir 0;
		Player_ItemClass = _classname;
		[Player_Item,_attach] spawn A3PL_Placeable_AttachedLoop;
	};
	if ((_classname isEqualTo "apple") && {!simulationEnabled _obj}) exitwith {[_obj] spawn A3PL_Resources_Picking;};
	if ((_classname isEqualTo "shrooms") && {!simulationEnabled _obj}) exitwith {[_obj] spawn A3PL_Shrooms_Pick;};

	private _weedPlants = ["cannabis_plant_stage1","cannabis_plant_stage2","cannabis_plant_stage3","cannabis_plant_stage4"];
	if (((typeOf _attachedTo) isEqualTo "A3FL_Weed_Rack") && (_classname IN _weedPlants)) then {
		private _memPoint = _obj getVariable["attachedPoint",nil];
		private _usedPoints = _attachedTo getVariable["UsedPoints",[]];
		private _hangPoints = _attachedTo getVariable["HangPoints",[]];

		_hangPoints pushBack _memPoint;
		_usedPoints deleteAt (_usedPoints find _memPoint);
		_attachedTo setVariable["HangPoints",_hangPoints,true];
		_attachedTo setVariable["UsedPoints",_usedPoints,true];
		_obj setVariable["isDrying",nil,true];
	};

	player playMove 'AmovPercMstpSnonWnonDnon_AinvPercMstpSnonWnonDnon_Putdown';

	if (_obj getVariable ["inUse",false]) exitWith {};
	_obj setVariable ["inUse",true,true];

	switch (_classname) do {
		case "doorkey": {[_obj, player] remoteExecCall ["Server_Housing_PickupKey", 2];};
		case "cash": {[player, _obj] remoteExecCall ["Server_Inventory_Pickup", 2]};
		default {[player, _obj, _amount] remoteExecCall ["Server_Inventory_Pickup", 2];};
	};

	if (_moveToHand) then {[_classname] call A3PL_Inventory_Use;};
	[format[("STR_A3PL_Inventory_YouPickedup" call A3PL_Localize),_amount, [_classname, "name"] call A3PL_Config_GetItem],Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Inventory_Throw", {
	private _obj = Player_Item;
	private _itemClass = Player_ItemClass;
	private _amount = 1;
	if(!isNil 'Player_ItemAmount') then {_amount = Player_ItemAmount;};
	if(_itemClass in ["A3PL_BucketFull","A3PL_Bucket","bucket_empty","bucket_full"]) exitWith {[("STR_A3PL_Inventory_Stop" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (isNull _obj) exitwith {[("STR_A3PL_Inventory_NothingToDropInYourHands" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!isNil "Player_isEating") exitwith {[("STR_A3PL_Inventory_CantDoThisByEating" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!isNil "Player_isDrinking") exitwith {[("STR_A3PL_Inventory_CantDoThisByDrinking" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (count (player nearObjects ["A3PL_Container_Ship", 100]) > 0) exitwith {};

	player playaction "Gesture_throw";
	sleep 0.5;
	detach _obj;

	private _playerVelocity = velocity player;
	private _playerDir = direction player;
	_obj setVelocity [((_playerVelocity select 0) + (sin _playerDir * 7)), ((_playerVelocity select 1) + (cos _playerDir * 7)), ((_playerVelocity select 2) + 7)];
	switch (_itemClass) do {
		case "doorkey": {[_obj, player] remoteExec ['Server_Housing_dropKey', 2];};
		case "cash": {[player,_obj,_itemClass,Player_ItemAmount] remoteExec["Server_Inventory_Drop", 2];};
		default {[player,_obj,_itemClass,_amount] remoteExec["Server_Inventory_Drop", 2];};
	};
	Player_Item setVariable ["held", nil, true];
	Player_Item = objNull;
	Player_ItemClass = '';
}] call compile_Global;
