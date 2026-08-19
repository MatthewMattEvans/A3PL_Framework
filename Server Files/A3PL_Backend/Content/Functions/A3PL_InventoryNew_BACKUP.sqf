/*
	A3PL_InventoryNew.sqf
	Nouveau systeme d'inventaire adapte du framework Edaly
	Adaptation pour A3PL Framework
*/

// ============================================================================
// DEFINES & CONSTANTS (doit correspondre a defines_inventorynew.hpp)
// ============================================================================

// Main Inventory Dialog
#define INVENTORY_DISPLAY_NAME "A3PL_RscDisplayInventoryNew"
#define INVENTORY_DISPLAY_IDD 6400
#define INVENTORY_SEARCH_TITLE_IDC 6401
#define INVENTORY_SEARCH_EDIT_IDC 6402
#define INVENTORY_FILTERS_TITLE_IDC 6403
#define INVENTORY_FILTER_1_IMAGE_IDC 6404
#define INVENTORY_FILTER_1_BUTTON_IDC 6405
#define INVENTORY_FILTER_2_IMAGE_IDC 6406
#define INVENTORY_FILTER_2_BUTTON_IDC 6407
#define INVENTORY_FILTER_3_IMAGE_IDC 6408
#define INVENTORY_FILTER_3_BUTTON_IDC 6409
#define INVENTORY_FILTER_4_IMAGE_IDC 6410
#define INVENTORY_FILTER_4_BUTTON_IDC 6411
#define INVENTORY_FILTER_5_IMAGE_IDC 6474
#define INVENTORY_FILTER_5_BUTTON_IDC 6475
#define INVENTORY_FILTER_6_IMAGE_IDC 6476
#define INVENTORY_FILTER_6_BUTTON_IDC 6477
#define INVENTORY_FILTER_7_IMAGE_IDC 6478
#define INVENTORY_FILTER_7_BUTTON_IDC 6479
#define INVENTORY_TITLE_IDC 6412
#define INVENTORY_LIST_IDC 6413
#define INVENTORY_PROGRESS_BAR_IDC 6414
#define INVENTORY_PROGRESS_TITLE_IDC 6415
#define EQUIPMENT_TITLE_IDC 6416

// Equipment slots IDCs
#define EQUIPMENT_SECONDARYWEAPON_BUTTON_IDC 6417
#define EQUIPMENT_PRIMARYWEAPON_BUTTON_IDC 6418
#define EQUIPMENT_HANDGUNWEAPON_BUTTON_IDC 6419
#define EQUIPMENT_BINOCULARS_BUTTON_IDC 6420
#define EQUIPMENT_COMPASS_BUTTON_IDC 6421
#define EQUIPMENT_HEADGEAR_BUTTON_IDC 6422
#define EQUIPMENT_WATCH_BUTTON_IDC 6423
#define EQUIPMENT_GOGGLES_BUTTON_IDC 6424
#define EQUIPMENT_VEST_BUTTON_IDC 6425
#define EQUIPMENT_UNIFORM_BUTTON_IDC 6426
#define EQUIPMENT_BACKPACK_BUTTON_IDC 6427
#define EQUIPMENT_PRIMARYWEAPON_FLASHLIGHT_BUTTON_IDC 6428
#define EQUIPMENT_PRIMARYWEAPON_MAGAZINE_BUTTON_IDC 6429
#define EQUIPMENT_PRIMARYWEAPON_MUZZLE_BUTTON_IDC 6430
#define EQUIPMENT_PRIMARYWEAPON_OPTIC_BUTTON_IDC 6431
#define EQUIPMENT_SECONDARYWEAPON_FLASHLIGHT_BUTTON_IDC 6432
#define EQUIPMENT_SECONDARYWEAPON_MAGAZINE_BUTTON_IDC 6433
#define EQUIPMENT_SECONDARYWEAPON_MUZZLE_BUTTON_IDC 6434
#define EQUIPMENT_SECONDARYWEAPON_OPTIC_BUTTON_IDC 6435
#define EQUIPMENT_HANDGUNWEAPON_FLASHLIGHT_BUTTON_IDC 6436
#define EQUIPMENT_HANDGUNWEAPON_MAGAZINE_BUTTON_IDC 6437
#define EQUIPMENT_HANDGUNWEAPON_MUZZLE_BUTTON_IDC 6438
#define EQUIPMENT_HANDGUNWEAPON_OPTIC_BUTTON_IDC 6439
#define EQUIPMENT_MAP_BUTTON_IDC 6440

// Equipment pictures IDCs
#define EQUIPMENT_HANDGUNWEAPON_PICTURE_IDC 6441
#define EQUIPMENT_BINOCULARS_PICTURE_IDC 6442
#define EQUIPMENT_COMPASS_PICTURE_IDC 6443
#define EQUIPMENT_MAP_PICTURE_IDC 6444
#define EQUIPMENT_WATCH_PICTURE_IDC 6445
#define EQUIPMENT_PRIMARYWEAPON_PICTURE_IDC 6446
#define EQUIPMENT_SECONDARYWEAPON_PICTURE_IDC 6447
#define EQUIPMENT_PRIMARYWEAPON_FLASHLIGHT_PICTURE_IDC 6448
#define EQUIPMENT_SECONDARYWEAPON_FLASHLIGHT_PICTURE_IDC 6449
#define EQUIPMENT_HANDGUNWEAPON_FLASHLIGHT_PICTURE_IDC 6450
#define EQUIPMENT_HANDGUNWEAPON_MAGAZINE_PICTURE_IDC 6451
#define EQUIPMENT_SECONDARYWEAPON_MAGAZINE_PICTURE_IDC 6452
#define EQUIPMENT_PRIMARYWEAPON_MAGAZINE_PICTURE_IDC 6453
#define EQUIPMENT_SECONDARYWEAPON_MUZZLE_PICTURE_IDC 6454
#define EQUIPMENT_PRIMARYWEAPON_MUZZLE_PICTURE_IDC 6455
#define EQUIPMENT_HANDGUNWEAPON_MUZZLE_PICTURE_IDC 6456
#define EQUIPMENT_HANDGUNWEAPON_OPTIC_PICTURE_IDC 6457
#define EQUIPMENT_SECONDARYWEAPON_OPTIC_PICTURE_IDC 6458
#define EQUIPMENT_PRIMARYWEAPON_OPTIC_PICTURE_IDC 6459
#define EQUIPMENT_UNIFORM_PICTURE_IDC 6460
#define EQUIPMENT_BACKPACK_PICTURE_IDC 6461
#define EQUIPMENT_VEST_PICTURE_IDC 6462
#define EQUIPMENT_HEADGEAR_PICTURE_IDC 6463
#define EQUIPMENT_GOGGLES_PICTURE_IDC 6464

// Character body parts IDCs
#define CHARACTER_ARMS_IDC 6465
#define CHARACTER_BODY_IDC 6466
#define CHARACTER_HANDS_IDC 6467
#define CHARACTER_HEAD_IDC 6468
#define CHARACTER_LEGS_IDC 6469
#define CHARACTER_HUNGER_BACKGROUND_IDC 6470
#define CHARACTER_HEALTH_BACKGROUND_IDC 6471
#define CHARACTER_THIRST_BACKGROUND_IDC 6472
#define CHARACTER_STATUSES_IDC 6473

// Player info IDCs (playtime, premium)
#define INVENTORY_PLAYTIME_IDC 6485
#define INVENTORY_PREMIUM_IDC 6486

// Grid Inventory System IDCs
#define INVENTORY_GRID_GROUP_IDC 6480
#define INVENTORY_GRID_SCROLL_IDC 6481
#define INVENTORY_GRID_DRAG_PICTURE_IDC 6482
#define INVENTORY_GRID_TOOLTIP_IDC 6483
#define INVENTORY_GRID_ROTATE_BUTTON_IDC 6484
#define INVENTORY_GRID_CELL_BASE_IDC 6600
#define INVENTORY_GRID_ITEM_BASE_IDC 7000

// Transfer Dialog
#define TRANSFER_DISPLAY_NAME "A3PL_RscDisplayTransferNew"
#define TRANSFER_DISPLAY_IDD 6500
#define TRANSFER_TARGET_PROGRESSBAR_IDC 6517
#define TRANSFER_TARGET_PROGRESS_INFO_IDC 6519
#define TRANSFER_TARGET_INVENTORY_LIST_IDC 6503
#define TRANSFER_TARGET_HEADER_IDC 6514
#define TRANSFER_PLAYER_HEADER_IDC 6515
#define TRANSFER_PLAYER_PROGRESSBAR_IDC 6518
#define TRANSFER_PLAYER_PROGRESS_INFO_IDC 6520
#define TRANSFER_PLAYER_INVENTORY_LIST_IDC 6505
#define TRANSFER_TOOLTIP_IDC 6507

// Weapon slots constants (Arma 3)
#define WeaponNoSlot 0
#define WeaponSlotPrimary 1
#define WeaponSlotSecondary 4
#define WeaponSlotHandGun 2
#define WeaponSlotHandGunItem 16
#define WeaponSlotItem 256
#define WeaponSlotBinocular 4096
#define WeaponHardMounted 65536
#define WeaponSlotInventory 131072

// Equipment slots
#define DEFAULT_SLOT 0
#define MUZZLE_SLOT 101
#define OPTICS_SLOT 201
#define FLASHLIGHT_SLOT 301
#define BIPOD_SLOT 302
#define FIRSTAIDKIT_SLOT 401
#define FINS_SLOT 501
#define BREATHINGBOMB_SLOT 601
#define NVG_SLOT 602
#define GOGGLE_SLOT 603
#define SCUBA_SLOT 604
#define HEADGEAR_SLOT 605
#define FACTOR_SLOT 607
#define RADIO_SLOT 611
#define HMD_SLOT 616
#define BINOCULAR_SLOT 617
#define MEDIKIT_SLOT 619
#define TOOLKIT_SLOT 620
#define VEST_SLOT 701
#define UNIFORM_SLOT 801
#define BACKPACK_SLOT 901

// Cargo limits
#define LOAD_MAX_GLOVEBOX 40
#define LOAD_MAX_MAILBOX 120
#define LOAD_MAX_FURNACE_TOP 200
#define LOAD_MAX_FURNACE_BOT 200
#define LOAD_MAX_TRASHCAN 200
#define LOAD_MAX_TRADE_TRADE 500

// ============================================================================
// HELPER MACROS (remplacent GVAR_UI, SVAR_UI)
// ============================================================================

// uiNamespace getVariable avec default
#define GVAR_UI(var,def) (uiNamespace getVariable [var, def])
// uiNamespace setVariable
#define SVAR_UI(var,val) (uiNamespace setVariable [var, val])

// ============================================================================
// CONFIG HELPER FUNCTIONS
// Remplace l'acces aux configs HPP par les hashmaps SQF
// ============================================================================

/*
	A3PL_InventoryNew_GetFilter
	Retourne les donnees d'un filtre depuis la hashmap
	Params: filterName (string)
	Returns: [iconDefault, iconFocus, condition, tooltip, itemsCode, fromCode, loadCode, isVirtual, isKeys, isLicenses] ou nil
*/
["A3PL_InventoryNew_GetFilter", {
	params [["_filterName", "", [""]]];
	if (_filterName isEqualTo "") exitWith {nil};
	Inventory_Filters getOrDefault [_filterName, nil]
}] call compile_Global;

/*
	A3PL_InventoryNew_GetFiltersList
	Retourne la liste ordonnee des noms de filtres
	Returns: array de strings
*/
["A3PL_InventoryNew_GetFiltersList", {
	Inventory_FiltersOrder
}] call compile_Global;

/*
	A3PL_InventoryNew_GetEquipmentSlot
	Retourne les donnees d'un slot d'equipement depuis la hashmap
	Params: slotName (string)
	Returns: [code, icon, tooltip, descShort, buttonIDC, imageIDC] ou nil
*/
["A3PL_InventoryNew_GetEquipmentSlot", {
	params [["_slotName", "", [""]]];
	if (_slotName isEqualTo "") exitWith {nil};
	Inventory_Equipment getOrDefault [_slotName, nil]
}] call compile_Global;

/*
	A3PL_InventoryNew_GetEquipmentSlotsList
	Retourne la liste des noms de slots d'equipement
	Returns: array de strings
*/
["A3PL_InventoryNew_GetEquipmentSlotsList", {
	keys Inventory_Equipment
}] call compile_Global;

/*
	A3PL_InventoryNew_GetActions
	Retourne la hashmap d'actions selon le type
	Params: actionType (string) - "item", "virtual", "key", "license", "cash", "equipment"
	Returns: hashmap ou createHashMap vide
*/
["A3PL_InventoryNew_GetActions", {
	params [["_actionType", "", [""]]];
	switch (_actionType) do {
		case "item": { Inventory_ItemActions };
		case "virtual": { Inventory_VirtualItemActions };
		case "key": { Inventory_KeyActions };
		case "license": { Inventory_LicenseActions };
		case "cash": { Inventory_CashActions };
		case "equipment": { Inventory_EquipmentActions };
		default { createHashMap };
	}
}] call compile_Global;

/*
	A3PL_InventoryNew_GetActionsOrder
	Retourne l'ordre des actions selon le type
	Params: actionType (string)
	Returns: array de strings
*/
["A3PL_InventoryNew_GetActionsOrder", {
	params [["_actionType", "", [""]]];
	switch (_actionType) do {
		case "item": { Inventory_ItemActionsOrder };
		case "virtual": { Inventory_VirtualItemActionsOrder };
		case "key": { Inventory_KeyActionsOrder };
		case "license": { Inventory_LicenseActionsOrder };
		case "cash": { Inventory_CashActionsOrder };
		case "equipment": { Inventory_EquipmentActionsOrder };
		default { [] };
	}
}] call compile_Global;

/*
	A3PL_InventoryNew_BuildContextMenu
	Construit le menu contextuel depuis les hashmaps
	Params: [position, item, count, actionType, filterName]
	actionType: "item", "virtual", "key", "license", "cash", "equipment"
*/
["A3PL_InventoryNew_BuildContextMenu", {
	params [
		["_position", [0, 0], [[]]],
		["_item", "", [""]],
		["_count", 1, [0]],
		["_actionType", "item", [""]],
		["_filterName", "all", [""]]
	];

	disableSerialization;

	if (_item isEqualTo "" || _count isEqualTo 0) exitWith {};

	private _actions = [_actionType] call A3PL_InventoryNew_GetActions;
	private _actionsOrder = [_actionType] call A3PL_InventoryNew_GetActionsOrder;

	if (count _actionsOrder isEqualTo 0) exitWith {};

	private _xPos = _position#0;
	private _yPos = _position#1;
	private _len = 0.10313 * safezoneW;
	private _height = 0.0220073 * safezoneH;

	// Clear existing menu
	{ctrlDelete _x} forEach (uiNamespace getVariable ["InventoryRightClickCtrls", []]);
	uiNamespace setVariable ["InventoryRightClickCtrls", []];

	private _idc = 8050;
	private _first = controlNull;
	private _display = uiNamespace getVariable [INVENTORY_DISPLAY_NAME, displayNull];
	if (isNull _display) exitWith {};

	private _from = "";
	// Recuperer le "from" du filtre actuel
	private _filterData = [_filterName] call A3PL_InventoryNew_GetFilter;
	if (!isNil "_filterData") then {
		private _fromResult = call (_filterData#5);
		if (!isNil "_fromResult") then {
			_from = _fromResult;
		};
	};

	{
		private _actionName = _x;
		private _actionData = _actions getOrDefault [_actionName, nil];
		if (!isNil "_actionData") then {
			_actionData params ["_conditionCode", "_text", "_code", "_subActions"];

			// Evaluer la condition
			private _conditionResult = call _conditionCode;
			if (_conditionResult) then {
				private _ctrl = _display ctrlCreate ["A3PL_Inv_RscButton", _idc];
				_ctrl ctrlSetPosition [_xPos, _yPos, _len, _height];

				if (isNull _first) then {
					_first = _ctrl;
				};

				// Traduire le texte si c'est une cle de localisation
				private _localizedText = if (_text select [0, 4] == "STR_") then {_text call A3PL_Localize} else {_text};

				if (count _subActions > 0) then {
					// Menu avec sous-actions
					_ctrl ctrlSetText format ["%1 ...", _localizedText];
					// Stocker les donnees dans uiNamespace avec un ID unique
					private _subMenuId = format ["subMenu_%1", _idc];
					uiNamespace setVariable [_subMenuId, [_subActions, _item, _count, _filterName, _from]];
					_ctrl buttonSetAction format ["
						private _data = uiNamespace getVariable '%1';
						_data params ['_subActions', '_item', '_count', '_filterName', '_from'];
						private _ctrl = (findDisplay 6400) displayCtrl %2;
						private _pos = ctrlPosition _ctrl;
						[[[(_pos#0) + (_pos#2), _pos#1], _item, _count, _subActions, _filterName, _from]] call A3PL_InventoryNew_BuildSubMenu;
					", _subMenuId, _idc];
				} else {
					// Action directe
					_ctrl ctrlSetText _localizedText;
					// Stocker les donnees dans uiNamespace avec un ID unique
					private _actionId = format ["action_%1", _idc];
					uiNamespace setVariable [_actionId, [_code, _item, _count, _from]];
					diag_log format ["BuildContextMenu: Creating button for action %1, item=%2, count=%3, from=%4", _actionName, _item, _count, _from];
					_ctrl buttonSetAction format ["
						[] spawn {
							diag_log 'Button clicked - starting action';
							uiNamespace setVariable ['InventoryRightAction', true];
							private _data = uiNamespace getVariable '%1';
							diag_log format ['Retrieved data: %%1', _data];
							_data params ['_code', '_item', '_count', '_from'];
							diag_log format ['Params: item=%%1, count=%%2, from=%%3, code=%%4', _item, _count, _from, _code];
							[] call A3PL_InventoryNew_ClearRightClick;
							[_item, _count, _from] call _code;
							[] call A3PL_InventoryNew_Update;
							uiNamespace setVariable ['InventoryRightAction', false];
						};
					", _actionId];
				};

				_ctrl ctrlSetEventHandler ["MouseButtonDown", "if ((_this#1) isEqualTo 0) then {uiNamespace setVariable ['InventoryClickTarget', _this#0]}"];
				_ctrl ctrlCommit 0;
				uiNamespace setVariable ["InventoryRightClickCtrls", (uiNamespace getVariable "InventoryRightClickCtrls") + [_ctrl]];
				_yPos = _yPos + _height;
				_idc = _idc + 1;
			};
		};
	} forEach _actionsOrder;

	if (!isNull _first) then {
		ctrlSetFocus _first;
	};
}] call compile_Global;

/*
	A3PL_InventoryNew_BuildSubMenu
	Construit un sous-menu contextuel
	Params: [[position, item, count, subActions, filterName, from]]
*/
["A3PL_InventoryNew_BuildSubMenu", {
	params [["_args", [], [[]]]];
	_args params [
		["_position", [0, 0], [[]]],
		["_item", "", [""]],
		["_count", 1, [0]],
		["_subActions", [], [[]]],
		["_filterName", "all", [""]],
		["_from", "", [""]]
	];

	disableSerialization;

	diag_log format ["BuildSubMenu: item=%1, count=%2, filterName=%3, subActions count=%4", _item, _count, _filterName, count _subActions];

	private _xPos = _position#0;
	private _yPos = _position#1;
	private _len = 0.10313 * safezoneW;
	private _height = 0.0220073 * safezoneH;

	// Clear existing submenu
	{ctrlDelete _x} forEach (uiNamespace getVariable ["InventoryRightClickSubsCtrls", []]);
	uiNamespace setVariable ["InventoryRightClickSubsCtrls", []];

	private _idc = 8080;
	private _display = uiNamespace getVariable [INVENTORY_DISPLAY_NAME, displayNull];
	if (isNull _display) exitWith {
		diag_log "BuildSubMenu: EXIT - display is null";
	};

	{
		_x params ["_subName", "_conditionCode", "_text", "_code"];

		diag_log format ["BuildSubMenu: Evaluating subAction %1, text=%2", _subName, _text];

		// Evaluer la condition
		private _conditionResult = call _conditionCode;
		diag_log format ["BuildSubMenu: Condition result for %1 = %2", _subName, _conditionResult];
		if (_conditionResult) then {
			private _ctrl = _display ctrlCreate ["A3PL_Inv_RscButton", _idc];
			_ctrl ctrlSetPosition [_xPos, _yPos, _len, _height];
			// Traduire le texte si c'est une cle de localisation
			private _localizedText = if (_text select [0, 4] == "STR_") then {_text call A3PL_Localize} else {_text};
			_ctrl ctrlSetText _localizedText;
			// Stocker les donnees dans uiNamespace avec un ID unique
			private _subActionId = format ["subAction_%1", _idc];
			uiNamespace setVariable [_subActionId, [_code, _item, _count, _from]];
			_ctrl buttonSetAction format ["
				[] spawn {
					uiNamespace setVariable ['InventoryRightAction', true];
					private _data = uiNamespace getVariable '%1';
					_data params ['_code', '_item', '_count', '_from'];
					[] call A3PL_InventoryNew_ClearRightClick;
					[_item, _count, _from] call _code;
					[] call A3PL_InventoryNew_Update;
					uiNamespace setVariable ['InventoryRightAction', false];
				};
			", _subActionId];

			_ctrl ctrlSetEventHandler ["MouseButtonDown", "if ((_this#1) isEqualTo 0) then {uiNamespace setVariable ['InventoryClickTarget', _this#0]}"];
			_ctrl ctrlCommit 0;
			uiNamespace setVariable ["InventoryRightClickSubsCtrls", (uiNamespace getVariable "InventoryRightClickSubsCtrls") + [_ctrl]];
			_yPos = _yPos + _height;
			_idc = _idc + 1;
		};
	} forEach _subActions;
}] call compile_Global;

// ============================================================================
// UTILITY FUNCTIONS
// ============================================================================

/*
	A3PL_InventoryNew_CanPerformItemAction
	Verifie si le joueur peut effectuer une action sur un item (use/give/drop)
	Ne peut pas si: dans un vehicule OU dans l'eau
	Params: [itemClass (optional), showNotification (optional, default true)]
	Return: boolean
*/
["A3PL_InventoryNew_CanPerformItemAction", {
	private _itemClass = "";
	private _showNotification = true;

	if (_this isEqualType []) then {
		if (count _this > 0) then {
			private _firstArg = _this#0;
			if (_firstArg isEqualType "") then {
				_itemClass = _firstArg;
				if (count _this > 1 && {(_this#1) isEqualType true}) then {
					_showNotification = _this#1;
				};
			} else {
				if (_firstArg isEqualType true) then {
					_showNotification = _firstArg;
				};
			};
		};
	} else {
		if (_this isEqualType true) then {
			_showNotification = _this;
		} else {
			if (_this isEqualType "") then {
				_itemClass = _this;
			};
		};
	};

	if ((vehicle player) != player) exitWith {
		if (_showNotification) then {
			["STR_A3PL_Inventory_CantDoThisInVehicle" call A3PL_Localize, Color_Red] call A3PL_Notification;
		};
		false
	};

	private _playerPos = getPosASL player;
	private _waterDepth = 0 - (_playerPos select 2);
	private _isSwimming = (animationState player) in ["aswmpercmstpsnonwnondnon", "aswmpercmrunslowwnondnon", "aswmpercmstpslowwnondnon_aswmpercmrunsnonwnondnon", "aswmprcrrunsnonwnondnon"];
	private _isUnderwater = surfaceIsWater (position player) && {(getPos player select 2) < 0};

	if (_isSwimming || _isUnderwater || (_waterDepth > 1)) exitWith {
		if (_itemClass == "net") exitWith {true};

		if (_showNotification) then {
			["STR_A3PL_Inventory_CantDoThisInWater" call A3PL_Localize, Color_Red] call A3PL_Notification;
		};
		false
	};

	true
}] call compile_Global;

/*
	A3PL_InventoryNew_FormatInv
	Convertit un array d'items en format [[items], [counts]]
	Respecte le maxStack: si un item depasse son maxStack, il est divise en plusieurs stacks
	Params: array d'items (peut contenir des doublons)
	Return: [[classnames], [counts]]
	Note: Le cash utilise Player_Cash pour le count, pas le nombre d'occurrences
*/
["A3PL_InventoryNew_FormatInv", {
	private _classnames = [];
	private _counts = [];
	private _processed = [];

	{
		private _current = _x;
		if !(_current in _processed) then {
			_processed pushBack _current;

			private _totalCount = 0;

			// Cas special: cash utilise Player_Cash
			if (_current isEqualTo "cash") then {
				_totalCount = player getVariable ["Player_Cash", 0];
				// Cash n'a pas de maxStack
				_classnames pushBack _current;
				_counts pushBack _totalCount;
			} else {
				// Compter le total pour cet item
				{
					if (_x isEqualTo _current) then {
						_totalCount = _totalCount + 1;
					};
				} forEach _this;

				// Obtenir le maxStack de l'item
				private _itemSize = [_current] call A3PL_InventoryNew_GetItemGridSize;
				private _maxStack = _itemSize#2;

				// Diviser en stacks selon maxStack
				if (_maxStack > 0 && _totalCount > _maxStack) then {
					// Creer plusieurs stacks
					private _remaining = _totalCount;
					while {_remaining > 0} do {
						private _stackSize = _maxStack min _remaining;
						_classnames pushBack _current;
						_counts pushBack _stackSize;
						_remaining = _remaining - _stackSize;
					};
				} else {
					// Un seul stack
					_classnames pushBack _current;
					_counts pushBack _totalCount;
				};
			};
		};
	} forEach (_this - [""]);

	[_classnames, _counts];
}] call compile_Global;

/*
	A3PL_InventoryNew_FillCtrlList
	Remplit un listbox avec des items formates
	Params: [control, formatedInv, stack (optional)]
*/
["A3PL_InventoryNew_FillCtrlList", {
	params [
		["_ctrl", controlNull, [controlNull]],
		["_formatedInv", [[], []], [[]]],
		["_stack", true, [true]]
	];

	if (isNull _ctrl) exitWith {};

	lbClear _ctrl;

	{
		private _info = [_x] call A3PL_InventoryNew_FetchItemInfo;
		private _index = _ctrl lbAdd (_info#1);
		if (_stack) then {
			_ctrl lbSetTextRight [_index, str((_formatedInv#1)#_forEachIndex)];
			_ctrl lbSetValue [_index, (_formatedInv#1)#_forEachIndex];
		};
		_ctrl lbSetData [_index, _x];
		_ctrl lbSetPicture [_index, _info#2];
		_ctrl lbSetTooltip [_index, _info#3];
	} forEach (_formatedInv#0);

	if ((lbSize _ctrl) > 0) then {
		lbSort [_ctrl, "ASC"];
	};
}] call compile_Global;

/*
	A3PL_InventoryNew_FetchItemParent
	Trouve la config parent d'un item
	Params: classname
	Return: "CfgMagazines", "CfgWeapons", "CfgVehicles", "CfgGlasses" ou ""
*/
["A3PL_InventoryNew_FetchItemParent", {
	private _classname = param [0, "", [""]];

	if (_classname isEqualTo "") exitWith {""};

	switch (true) do {
		case (isClass(configFile >> "CfgMagazines" >> _classname)): {"CfgMagazines"};
		case (isClass(configFile >> "CfgWeapons" >> _classname)): {"CfgWeapons"};
		case (isClass(configFile >> "CfgVehicles" >> _classname)): {"CfgVehicles"};
		case (isClass(configFile >> "CfgGlasses" >> _classname)): {"CfgGlasses"};
		default {""};
	};
}] call compile_Global;

/*
	A3PL_InventoryNew_GetAssetConfig
	Recupere la config d'un asset (item, weapon, vehicle, glasses)
	Params: classname
	Return: config ou configNull
*/
["A3PL_InventoryNew_GetAssetConfig", {
	private _classname = param [0, "", [""]];

	if (_classname isEqualTo "") exitWith {configNull};

	private _parent = [_classname] call A3PL_InventoryNew_FetchItemParent;
	if (_parent isEqualTo "") exitWith {configNull};

	configFile >> _parent >> _classname;
}] call compile_Global;

/*
	A3PL_InventoryNew_GetItemConfig
	Alias pour CBA_fnc_getItemConfig - recupere config d'un item
	Params: classname
	Return: config ou configNull
*/
["A3PL_InventoryNew_GetItemConfig", {
	private _classname = _this;
	if ((typeName _classname) isEqualTo "ARRAY") then {
		_classname = _this#0;
	};

	if (_classname isEqualTo "") exitWith {configNull};

	// Cherche dans l'ordre: CfgWeapons, CfgMagazines, CfgVehicles, CfgGlasses
	private _cfg = configFile >> "CfgWeapons" >> _classname;
	if (isClass _cfg) exitWith {_cfg};

	_cfg = configFile >> "CfgMagazines" >> _classname;
	if (isClass _cfg) exitWith {_cfg};

	_cfg = configFile >> "CfgVehicles" >> _classname;
	if (isClass _cfg) exitWith {_cfg};

	_cfg = configFile >> "CfgGlasses" >> _classname;
	if (isClass _cfg) exitWith {_cfg};

	configNull;
}] call compile_Global;

/*
	A3PL_InventoryNew_GetItemMass
	Recupere la masse d'un item
	Params: classname
	Return: nombre (masse)
*/
["A3PL_InventoryNew_GetItemMass", {
	if (_this isEqualTo "") exitWith {0};

	private _cfg = [_this] call A3PL_InventoryNew_GetAssetConfig;
	if (isNull _cfg) exitWith {0};

	switch (true) do {
		case (isNumber(_cfg >> "WeaponSlotsInfo" >> "mass")): {getNumber(_cfg >> "WeaponSlotsInfo" >> "mass")};
		case (isNumber(_cfg >> "ItemInfo" >> "mass")): {getNumber(_cfg >> "ItemInfo" >> "mass")};
		case (isNumber(_cfg >> "mass")): {getNumber(_cfg >> "mass")};
		default {0};
	};
}] call compile_Global;

/*
	A3PL_InventoryNew_GetItemName
	Recupere le nom d'un item
	Params: classname
	Return: string (nom)
*/
["A3PL_InventoryNew_GetItemName", {
	private _cfg = _this call A3PL_InventoryNew_GetItemConfig;
	if (isNull _cfg) exitWith {""};

	getText(_cfg >> "displayName");
}] call compile_Global;

/*
	A3PL_InventoryNew_GetItemSlotName
	Recupere le nom du slot d'equipement d'un item
	Params: classname
	Return: string (nom du slot localise)
*/
["A3PL_InventoryNew_GetItemSlotName", {
	if (_this isEqualTo "") exitWith {""};

	private _cfg = [_this] call A3PL_InventoryNew_GetAssetConfig;
	if (isNull _cfg) exitWith {""};

	private _parent = [_this] call A3PL_InventoryNew_FetchItemParent;
	private _ret = "";

	switch (_parent) do {
		case "CfgVehicles": {
			if (getNumber(_cfg >> "isbackpack") isEqualTo 0) exitWith {};
			_ret = ("STR_A3PL_Inventory_EquipBackpack" call A3PL_Localize);
		};

		case "CfgGlasses": {
			_ret = ("STR_A3PL_Inventory_EquipGoggles" call A3PL_Localize);
		};

		case "CfgMagazines": {
			_ret = ("STR_A3PL_Inventory_SlotWeaponMagazine" call A3PL_Localize);
		};

		case "CfgWeapons": {
			switch (getNumber(_cfg >> "type")) do {
				case WeaponSlotBinocular: {
					_ret = ("STR_A3PL_Inventory_EquipBinoculars" call A3PL_Localize);
				};
				case WeaponSlotPrimary: {
					_ret = ("STR_A3PL_Inventory_EquipPrimaryWeapon" call A3PL_Localize);
				};
				case WeaponSlotHandGun: {
					_ret = ("STR_A3PL_Inventory_EquipHandgun" call A3PL_Localize);
				};
				case WeaponSlotSecondary: {
					_ret = ("STR_A3PL_Inventory_EquipSecondaryWeapon" call A3PL_Localize);
				};
				case WeaponSlotInventory: {
					switch (getNumber(_cfg >> "itemInfo" >> "type")) do {
						case DEFAULT_SLOT: {
							switch (getText(_cfg >> "simulation")) do {
								case "ItemRadio";
								case "ItemWatch";
								case "ItemCompass";
								case "ItemMap": {
									_ret = ("STR_A3PL_Inventory_SlotAssignable" call A3PL_Localize);
								};
							};
						};
						case HEADGEAR_SLOT: {
							_ret = ("STR_A3PL_Inventory_EquipHeadgear" call A3PL_Localize);
						};
						case UNIFORM_SLOT: {
							_ret = ("STR_A3PL_Inventory_EquipUniform" call A3PL_Localize);
						};
						case VEST_SLOT: {
							_ret = ("STR_A3PL_Inventory_EquipVest" call A3PL_Localize);
						};
					};
				};
			};
		};
	};

	if (_ret isEqualTo "") exitWith {("STR_A3PL_Inventory_SlotObject" call A3PL_Localize)};

	_ret;
}] call compile_Global;

/*
	A3PL_InventoryNew_GetItemDescription
	Recupere la description complete d'un item
	Params: classname
	Return: string (description formatee)
*/
["A3PL_InventoryNew_GetItemDescription", {
	private _cfg = _this call A3PL_InventoryNew_GetItemConfig;
	if (isNull _cfg) exitWith {""};

	private _mass = _this call A3PL_InventoryNew_GetItemMass;
	private _ret = format ["%1 %2\n", ("STR_A3PL_Inventory_Mass" call A3PL_Localize), _mass];

	private _slotName = _this call A3PL_InventoryNew_GetItemSlotName;
	if !(_slotName isEqualTo "") then {
		_ret = _ret + format ["%1 %2\n", ("STR_A3PL_Inventory_Type" call A3PL_Localize), _slotName];
	};

	private _desc = getText(_cfg >> "descriptionshort");
	if (_desc isNotEqualTo "") then {
		_ret = _ret + "\n" + _desc + "\n";
	};

	_ret;
}] call compile_Global;

/*
	A3PL_InventoryNew_FetchItemInfo
	Recupere toutes les infos d'un item
	Params: classname
	Return: [classname, name, picture, description, mass]
*/
["A3PL_InventoryNew_FetchItemInfo", {
	private _classname = param [0, "", [""]];

	if (_classname isEqualTo "") exitWith {[]};

	private _cfg = [_classname] call A3PL_InventoryNew_GetAssetConfig;
	if (isNull _cfg) exitWith {
		diag_log format ["A3PL_InventoryNew: Warning - %1 is not a known item", _classname];
		["", "", "", "", 0]
	};

	[
		_classname,
		_classname call A3PL_InventoryNew_GetItemName,
		getText(_cfg >> "picture"),
		_classname call A3PL_InventoryNew_GetItemDescription,
		_classname call A3PL_InventoryNew_GetItemMass
	];
}] call compile_Global;

// ============================================================================
// INVENTORY CHECK FUNCTIONS
// ============================================================================

/*
	A3PL_InventoryNew_HasItem
	Verifie si le joueur possede un item
	Params: classname
	Return: boolean
*/
["A3PL_InventoryNew_HasItem", {
	_this in ((items player) + (magazines player));
}] call compile_Global;

/*
	A3PL_InventoryNew_HasItems
	Verifie si le joueur possede plusieurs items avec quantites
	Params: [[item, count], [item, count], ...]
	Return: boolean
*/
["A3PL_InventoryNew_HasItems", {
	private _ret = true;
	private _inventory = ((uniformItems player) + (vestItems player) + (backpackItems player)) call A3PL_InventoryNew_FormatInv;
	private _items = _inventory#0;
	private _count = _inventory#1;

	{
		private _index = _items find (_x#0);
		if (_index isEqualTo -1) exitWith {_ret = false};
		if ((_count#_index) < (_x#1)) exitWith {_ret = false};
	} forEach _this;

	_ret;
}] call compile_Global;

/*
	A3PL_InventoryNew_HasEquipment
	Verifie si le joueur a un equipement specifique
	Params: classname
	Return: boolean
*/
["A3PL_InventoryNew_HasEquipment", {
	if (_this isEqualTo "") exitWith {false};

	_this in ([primaryWeapon player, secondaryWeapon player, handgunWeapon player]
		+ [goggles player, headgear player, binocular player, vest player, uniform player, backpack player]
		+ (assignedItems player));
}] call compile_Global;

/*
	A3PL_InventoryNew_ItemCount
	Compte le nombre d'un item dans l'inventaire du joueur
	Params: classname
	Return: nombre
*/
["A3PL_InventoryNew_ItemCount", {
	{_x isEqualTo _this} count ((items player) + (magazines player));
}] call compile_Global;

/*
	A3PL_InventoryNew_CanEquipItem
	Verifie si un item peut etre equipe
	Params: classname
	Return: boolean
*/
["A3PL_InventoryNew_CanEquipItem", {
	private _item = param [0, "", [""]];

	if (_item isEqualTo "") exitWith {false};

	private _cfg = _item call A3PL_InventoryNew_GetItemConfig;
	if (isNull _cfg) exitWith {false};

	private _ret = false;

	switch ([_item] call A3PL_InventoryNew_FetchItemParent) do {
		case "CfgWeapons": {
			private _type = getNumber(_cfg >> "type");

			if ((_type isEqualTo WeaponSlotPrimary) && {(primaryWeapon player) isEqualTo ""}) exitWith {_ret = true};
			if ((_type isEqualTo WeaponSlotSecondary) && {(secondaryWeapon player) isEqualTo ""}) exitWith {_ret = true};
			if ((_type isEqualTo WeaponSlotHandGun) && {(handgunWeapon player) isEqualTo ""}) exitWith {_ret = true};
			if ((_type isEqualTo WeaponSlotBinocular) && {(binocular player) isEqualTo ""}) exitWith {_ret = true};

			if (_type isEqualTo WeaponSlotInventory) then {
				private _simulation = getText(_cfg >> "simulation");

				if ((_simulation in ["ItemMap", "ItemWatch", "ItemCompass"]) && {!(_item in (assignedItems player))}) exitWith {_ret = true};
				if (_simulation isEqualTo "Weapon") then {
					private _type_item = getNumber(_cfg >> "itemInfo" >> "type");

					// Verifier les attachements d'armes (101=muzzle, 201=optic, 301=flashlight, 302=bipod)
					if (_type_item in [101, 201, 301, 302]) exitWith {
						// C'est un attachement - verifier si le joueur a une arme qui peut l'accepter
						private _hasWeapon = (primaryWeapon player) isNotEqualTo "" || {(handgunWeapon player) isNotEqualTo ""} || {(secondaryWeapon player) isNotEqualTo ""};
						_ret = _hasWeapon;
					};

					if ((_type_item isEqualTo VEST_SLOT) && {(vest player) isEqualTo ""}) exitWith {_ret = true};
					if ((_type_item isEqualTo UNIFORM_SLOT) && {(uniform player) isEqualTo ""}) exitWith {_ret = true};
					if ((_type_item isEqualTo HEADGEAR_SLOT) && {(headgear player) isEqualTo ""}) exitWith {_ret = true};
				};
			};
		};
		case "CfgMagazines": {
			private _slotsCompatible = {_x == _item} count (
				(getArray(configFile >> "CfgWeapons" >> (primaryWeapon player) >> "magazines")) +
				(getArray(configFile >> "CfgWeapons" >> (handgunWeapon player) >> "magazines")) +
				(getArray(configFile >> "CfgWeapons" >> (secondaryWeapon player) >> "magazines"))
			);
			_ret = _slotsCompatible > 0;
		};
		case "CfgVehicles": {
			_ret = (getNumber(_cfg >> "isBackpack") isEqualTo 1) && {(backpack player) isEqualTo ""};
		};
		case "CfgGlasses": {
			_ret = (goggles player) isEqualTo "";
		};
	};

	_ret;
}] call compile_Global;

// ============================================================================
// UNIT CONTAINER FUNCTIONS (Player inventory capacity)
// ============================================================================

/*
	A3PL_InventoryNew_GetUnitContainerMaxLoad
	Recupere la capacite max de l'inventaire du joueur
	Params: unit
	Return: nombre (poids max)
*/
["A3PL_InventoryNew_GetUnitContainerMaxLoad", {
	private _unit = param [0, objNull, [objNull]];
	if (isNull _unit) exitWith {0};

	(
		(getContainerMaxLoad (uniform _unit))
		+ (getContainerMaxLoad (vest _unit))
		+ (getContainerMaxLoad (backpack _unit))
	) max 0;
}] call compile_Global;

/*
	A3PL_InventoryNew_GetUnitContainerLoadAbs
	Recupere le poids actuel de l'inventaire du joueur
	Params: unit
	Return: nombre (poids actuel)
*/
["A3PL_InventoryNew_GetUnitContainerLoadAbs", {
	private _unit = param [0, objNull, [objNull]];
	if (isNull _unit) exitWith {0};

	private _weight = 0;

	{
		_weight = _weight + (_x call A3PL_InventoryNew_GetItemMass);
	} forEach (uniformItems _unit) + (vestItems _unit) + (backpackItems _unit);

	_weight;
}] call compile_Global;

/*
	A3PL_InventoryNew_GetUnitContainerLoad
	Recupere le ratio de chargement de l'inventaire du joueur (0-1)
	Params: unit
	Return: nombre (ratio 0-1)
*/
["A3PL_InventoryNew_GetUnitContainerLoad", {
	private _unit = param [0, objNull, [objNull]];
	if (isNull _unit) exitWith {0};

	private _maxLoad = _unit call A3PL_InventoryNew_GetUnitContainerMaxLoad;
	if (_maxLoad isEqualTo 0) exitWith {1};

	private _load = _unit call A3PL_InventoryNew_GetUnitContainerLoadAbs;
	if (_load isEqualTo 0) exitWith {0};

	_load / _maxLoad;
}] call compile_Global;

// ============================================================================
// CARGO FUNCTIONS (Vehicle/Container inventory)
// ============================================================================

/*
	A3PL_InventoryNew_GetCargoMaxLoad
	Recupere la capacite max d'un cargo
	Params: [target, variable]
	Return: nombre (poids max)
*/
["A3PL_InventoryNew_GetCargoMaxLoad", {
	private _target = _this#0;
	private _variable = _this#1;

	// Les vehicules et Box_GEN_Equip_F utilisent le systeme cargo vanilla - utiliser maximumLoad
	private _isVehicleCargo = (_target isKindOf "Car" || _target isKindOf "Air" || _target isKindOf "Ship" || (typeOf _target) isEqualTo "Box_GEN_Equip_F" || (typeOf _target) isEqualTo "A3PL_EMS_Locker" || (typeOf _target) isEqualTo "B_supplyCrate_F" || (typeOf _target) isEqualTo "GroundWeaponHolder");
	if (_isVehicleCargo) exitWith {
		getNumber(configFile >> "CfgVehicles" >> typeOf(_target) >> "maximumLoad")
	};

	switch (true) do {
		case (_variable isEqualTo "reserve");
		case (typeOf(_target) isEqualTo "GroundWeaponHolder"): {
			_this call A3PL_InventoryNew_GetCargoLoadAbs
		};
		case (_variable isEqualTo "glovebox"): {LOAD_MAX_GLOVEBOX};
		case (_variable isEqualTo "trash"): {LOAD_MAX_TRASHCAN};
		case (_variable isEqualTo "oven"): {LOAD_MAX_FURNACE_TOP};
		case (_variable isEqualTo "combustibles"): {LOAD_MAX_FURNACE_BOT};
		case (_variable isEqualTo "cargo"): {
			getNumber(configFile >> "CfgVehicles" >> typeOf(_target) >> "maximumLoad")
		};
		case (_variable isEqualTo "furniture"): {
			getNumber(configFile >> "CfgContainers" >> typeOf(_target) >> "maximumLoad")
		};
		case (["letter_box", _variable] call BIS_fnc_inString): {LOAD_MAX_MAILBOX};
		default {0};
	};
}] call compile_Global;

/*
	A3PL_InventoryNew_GetCargoLoadAbs
	Recupere le poids actuel d'un cargo
	Params: [target, variable ou inventory array]
	Return: nombre (poids actuel)
*/
["A3PL_InventoryNew_GetCargoLoadAbs", {
	if !(params [
		["_target", objNull, [objNull]],
		["_variable", "", ["", []]]
	]) exitWith {
		diag_log "A3PL_InventoryNew_GetCargoLoadAbs: Missing parameter(s)";
		0
	};

	if (isNull _target) exitWith {0};

	private "_inventory";

	if ((typeName _variable) isEqualTo "ARRAY") then {
		_inventory = _variable;
	} else {
		// Les vehicules et Box_GEN_Equip_F utilisent le systeme cargo vanilla
		private _isVehicleCargo = (_target isKindOf "Car" || _target isKindOf "Air" || _target isKindOf "Ship" || (typeOf _target) isEqualTo "Box_GEN_Equip_F" || (typeOf _target) isEqualTo "A3PL_EMS_Locker" || (typeOf _target) isEqualTo "B_supplyCrate_F" || (typeOf _target) isEqualTo "GroundWeaponHolder");
		if (_isVehicleCargo) then {
			// Recuperer tous les items du cargo vanilla
			private _allItems = (itemCargo _target) + (weaponCargo _target) + (magazineCargo _target) + (backpackCargo _target);
			private _items = [];
			private _counts = [];

			{
				private _idx = _items find _x;
				if (_idx == -1) then {
					_items pushBack _x;
					_counts pushBack 1;
				} else {
					_counts set [_idx, (_counts#_idx) + 1];
				};
			} forEach _allItems;

			_inventory = [_items, _counts];
		} else {
			// GroundWeaponHolder utilise toujours "GroundCargo" comme variable
			private _actualVar = if ((typeOf _target) isEqualTo "GroundWeaponHolder") then {"GroundCargo"} else {_variable};
			_inventory = _target getVariable [_actualVar, [[], []]];
		};
	};

	private _weight = 0;

	{
		_weight = _weight + ((_x call A3PL_InventoryNew_GetItemMass) * ((_inventory#1)#_forEachIndex));
	} forEach (_inventory#0);

	_weight;
}] call compile_Global;

/*
	A3PL_InventoryNew_GetCargoLoad
	Recupere le ratio de chargement d'un cargo (0-1)
	Params: [target, variable ou inventory array]
	Return: nombre (ratio 0-1)
*/
["A3PL_InventoryNew_GetCargoLoad", {
	if !(params [
		["_target", objNull, [objNull]],
		["_variable", "", ["", []]]
	]) exitWith {
		diag_log "A3PL_InventoryNew_GetCargoLoad: Missing parameter(s)";
		0
	};

	if (isNull _target) exitWith {0};

	private _maxLoad = [_target, _variable] call A3PL_InventoryNew_GetCargoMaxLoad;
	if (_maxLoad isEqualTo 0) exitWith {1};

	private _load = [_target, _variable] call A3PL_InventoryNew_GetCargoLoadAbs;
	if (_load isEqualTo 0) exitWith {0};

	_load / _maxLoad;
}] call compile_Global;

/*
	A3PL_InventoryNew_CargoItemCount
	Compte le nombre d'un item dans un cargo
	Params: [target, variable, item]
	Return: nombre
*/
["A3PL_InventoryNew_CargoItemCount", {
	if !(params [
		["_target", objNull, [objNull]],
		["_variable", "", ["", []]],
		["_item", "", [""]]
	]) exitWith {
		diag_log format ["A3PL_InventoryNew_CargoItemCount: Warning - wrong parameters %1.", _this];
		0
	};

	if (_item isEqualTo "") exitWith {0};

	private _count = 0;
	private "_inventory";

	if ((typeName _variable) isEqualTo "ARRAY") then {
		_inventory = _variable;
	} else {
		_inventory = _target getVariable [_variable, [[], []]];
	};

	{
		if (_x isEqualTo _item) exitWith {_count = (_inventory#1)#_forEachIndex};
	} forEach (_inventory#0);

	_count;
}] call compile_Global;

/*
	A3PL_InventoryNew_CargoIsItemAllowed
	Verifie si un item est autorise dans un cargo
	Params: [target, variable, item]
	Return: boolean
*/
["A3PL_InventoryNew_CargoIsItemAllowed", {
	switch (true) do {
		case ((_this#1) isEqualTo "furniture"): {
			private _allowed = getArray(configFile >> "CfgContainers" >> typeOf(_this#0) >> "allowed");
			(_allowed isEqualTo []) || {(_this#2) in _allowed}
		};
		case (["letter_box", _this#1] call BIS_fnc_inString): {
			private _weight = (_this#2) call A3PL_InventoryNew_GetItemMass;
			(_weight < 3)
		};
		default {true};
	};
}] call compile_Global;

/*
	A3PL_InventoryNew_CargoHasItems
	Verifie si un cargo contient des items specifiques
	Params: [target, variable, [[items], [counts]]]
	Return: boolean
*/
["A3PL_InventoryNew_CargoHasItems", {
	if !(params [
		["_target", objNull, [objNull]],
		["_variable", "", [""]],
		["_has", [[], []], [[]], 2]
	]) exitWith {
		diag_log format ["A3PL_InventoryNew_CargoHasItems: Warning - wrong parameters %1.", _this];
		false
	};

	// Les vehicules et Box_GEN_Equip_F utilisent le systeme cargo vanilla
	private _isVehicleCargo = (_target isKindOf "Car" || _target isKindOf "Air" || _target isKindOf "Ship" || (typeOf _target) isEqualTo "Box_GEN_Equip_F" || (typeOf _target) isEqualTo "A3PL_EMS_Locker" || (typeOf _target) isEqualTo "B_supplyCrate_F" || (typeOf _target) isEqualTo "GroundWeaponHolder");
	if (_isVehicleCargo) exitWith {
		private _ret = true;
		private _hasItems = _has#0;
		private _hasCounts = _has#1;

		// Recuperer tous les items du cargo vanilla
		private _allItems = (itemCargo _target) + (weaponCargo _target) + (magazineCargo _target) + (backpackCargo _target);
		private _items = [];
		private _counts = [];

		{
			private _idx = _items find _x;
			if (_idx == -1) then {
				_items pushBack _x;
				_counts pushBack 1;
			} else {
				_counts set [_idx, (_counts#_idx) + 1];
			};
		} forEach _allItems;

		{
			private _index = _items find _x;
			if (_index isEqualTo -1) exitWith {_ret = false};
			if ((_counts#_index) < (_hasCounts#_forEachIndex)) exitWith {_ret = false};
		} forEach _hasItems;

		_ret
	};

	// GroundWeaponHolder utilise toujours "GroundCargo" comme variable
	private _actualVar = if ((typeOf _target) isEqualTo "GroundWeaponHolder") then {"GroundCargo"} else {_variable};

	private _ret = true;
	private _inventory = _target getVariable [_actualVar, [[], []]];
	private _items = _inventory#0;
	private _count = _inventory#1;

	{
		private _index = _items find _x;

		if (_index isEqualTo -1) exitWith {_ret = false};
		if ((_count#_index) < ((_has#1)#_forEachIndex)) exitWith {_ret = false};
	} forEach (_has#0);

	_ret;
}] call compile_Global;

/*
	A3PL_InventoryNew_CanAddItemCargo
	Verifie si on peut ajouter un item a un cargo
	Params: [target, variable, item, count]
	Return: boolean
*/
["A3PL_InventoryNew_CanAddItemCargo", {
	params [
		["_target", objNull, [objNull]],
		["_variable", "", [""]],
		["_item", "", [""]],
		["_count", 0, [0]]
	];

	if (isNull(_target) || {_variable isEqualTo ""} || {_item isEqualTo ""} || {_count <= 0}) exitWith {false};
	if ((typeOf(_target) isEqualTo "GroundWeaponHolder") || {_variable isEqualTo "reserve"}) exitWith {true};

	private _current = [_target, _variable] call A3PL_InventoryNew_GetCargoLoadAbs;
	private _added = (_item call A3PL_InventoryNew_GetItemMass) * _count;
	private _max = [_target, _variable] call A3PL_InventoryNew_GetCargoMaxLoad;

	_current + _added <= _max;
}] call compile_Global;

/*
	A3PL_InventoryNew_CanAddItemsCargo
	Verifie si on peut ajouter plusieurs items a un cargo
	Params: [target, variable, items (array ou formatted)]
	Return: boolean
*/
["A3PL_InventoryNew_CanAddItemsCargo", {
	params [
		["_target", objNull, [objNull]],
		["_variable", "", [""]],
		["_items", [], [[]]]
	];

	if (isNull(_target) || {_items isEqualTo []}) exitWith {false};

	private _isVehicleCargo = (_target isKindOf "Car" || _target isKindOf "Air" || _target isKindOf "Ship" || (typeOf _target) isEqualTo "Box_GEN_Equip_F" || (typeOf _target) isEqualTo "A3PL_EMS_Locker" || (typeOf _target) isEqualTo "B_supplyCrate_F" || (typeOf _target) isEqualTo "GroundWeaponHolder");
	if (_isVehicleCargo) exitWith {true};

	if (_variable isEqualTo "") exitWith {false};

	private _weight = [_target, _variable] call A3PL_InventoryNew_GetCargoLoadAbs;

	if ((typeName (_items#0)) isEqualTo "ARRAY") then {
		{
			_weight = _weight + ((_x call A3PL_InventoryNew_GetItemMass) * ((_items#1)#_forEachIndex));
		} forEach (_items#0);
	} else {
		{
			_weight = _weight + (_x call A3PL_InventoryNew_GetItemMass);
		} forEach _items;
	};

	_weight <= ([_target, _variable] call A3PL_InventoryNew_GetCargoMaxLoad);
}] call compile_Global;

// ============================================================================
// CARGO ADD/REMOVE FUNCTIONS
// ============================================================================

/*
	A3PL_InventoryNew_AddItemCargo
	Ajoute un item a un cargo
	Params: [target, variable, item, count]
	Return: boolean
*/
["A3PL_InventoryNew_AddItemCargo", {
	if !(params [
		["_target", objNull, [objNull]],
		["_variable", "", [""]],
		["_item", "", [""]],
		["_count", 0, [0]]
	]) exitWith {
		diag_log "A3PL_InventoryNew_AddItemCargo: Missing parameter(s)";
		false
	};

	if ((_item isEqualTo "") || {_count <= 0} || {_variable isEqualTo ""}) exitWith {false};
	if !([_target, _variable, _item, _count] call A3PL_InventoryNew_CanAddItemCargo) exitWith {false};

	private _inventory = _target getVariable [_variable, [[], []]];
	private _index = (_inventory#0) find _item;

	if (_index isEqualTo -1) then {
		(_inventory#0) pushBack _item;
		(_inventory#1) pushBack _count;
	} else {
		(_inventory#1) set [_index, ((_inventory#1)#_index) + _count];
	};

	_target setVariable [_variable, _inventory, true];

	// Gestion visuelle pour GroundWeaponHolder
	if (typeOf(_target) isEqualTo "GroundWeaponHolder") then {
		[_target, _item] call A3PL_InventoryNew_AddItemHolder;
	};

	true;
}] call compile_Global;

/*
	A3PL_InventoryNew_AddItemsCargo
	Ajoute plusieurs items a un cargo
	Params: [target, variable, [[items], [counts]]]
	Return: boolean
*/
["A3PL_InventoryNew_AddItemsCargo", {
	params [
		["_target", objNull, [objNull]],
		["_var", "", [""]],
		["_items", [], [[], []]]
	];

	if (isNull(_target) || {_items isEqualTo []}) exitWith {false};
	if (_items isEqualTo [[], []]) exitWith {true};

	private _isGroundHolder = (typeOf _target) isEqualTo "GroundWeaponHolder";
	private _isVehicleCargo = (_target isKindOf "Car" || _target isKindOf "Air" || _target isKindOf "Ship" || (typeOf _target) isEqualTo "Box_GEN_Equip_F" || (typeOf _target) isEqualTo "A3PL_EMS_Locker" || (typeOf _target) isEqualTo "B_supplyCrate_F" || (typeOf _target) isEqualTo "GroundWeaponHolder");

	if (!_isVehicleCargo && {_var isEqualTo ""}) exitWith {false};

	if (_isVehicleCargo) exitWith {
		private _addItems = _items#0;
		private _addCounts = _items#1;

		{
			private _item = _x;
			private _count = _addCounts#_forEachIndex;
			private _parent = [_item] call A3PL_InventoryNew_FetchItemParent;

			switch (_parent) do {
				case "CfgMagazines": {
					_target addMagazineCargoGlobal [_item, _count];
				};
				case "CfgWeapons": {
					_target addWeaponCargoGlobal [_item, _count];
				};
				case "CfgVehicles": {
					_target addBackpackCargoGlobal [_item, _count];
				};
				default {
					_target addItemCargoGlobal [_item, _count];
				};
			};
		} forEach _addItems;
		true
	};

	private _actualVar = if (_isGroundHolder) then {"GroundCargo"} else {_var};

	private _cargo = _target getVariable [_actualVar, [[],[]]];
	private _cargoItems = _cargo#0;
	private _cargoCounts = _cargo#1;
	private _addItems = _items#0;
	private _addCounts = _items#1;

	{
		private _index = _cargoItems find _x;
		if (_index isEqualTo -1) then {
			_cargoItems pushBack _x;
			_cargoCounts pushBack (_addCounts#_forEachIndex);
		} else {
			_cargoCounts set [_index, (_cargoCounts#_index) + (_addCounts#_forEachIndex)];
		};

		_target setVariable [_actualVar, [_cargoItems, _cargoCounts], false];

		if (_isGroundHolder) then {
			[_target, _x] call A3PL_InventoryNew_AddItemHolder;
		};
	} forEach _addItems;

	_target setVariable [_actualVar, [_cargoItems, _cargoCounts], true];
	true;
}] call compile_Global;

/*
	A3PL_InventoryNew_AddItemHolder
	Ajoute un item visuellement a un GroundWeaponHolder
	Params: [target, item]
	Return: boolean
*/
["A3PL_InventoryNew_AddItemHolder", {
	if !(params [
		["_target", objNull, [objNull]],
		["_item", "", [""]]
	]) exitWith {false};

	if ((isNull _target) || {_item isEqualTo ""}) exitWith {false};

	private _parent = [_item] call A3PL_InventoryNew_FetchItemParent;
	if (_parent isEqualTo "") exitWith {false};

	switch (_parent) do {
		case "CfgMagazines": {
			if (((magazineCargo _target) find _item) isEqualTo -1) then {
				_target addMagazineCargoGlobal [_item, 1];
			};
		};
		case "CfgWeapons": {
			if (((weaponCargo _target) find _item) isEqualTo -1) then {
				_target addWeaponCargoGlobal [_item, 1];
			};
		};
		case "CfgVehicles": {
			if (((backpackCargo _target) find _item) isEqualTo -1) then {
				_target addBackpackCargoGlobal [_item, 1];
			};
		};
		default {
			if (((itemCargo _target) find _item) isEqualTo -1) then {
				_target addItemCargoGlobal [_item, 1];
			};
		};
	};

	true;
}] call compile_Global;

/*
	A3PL_InventoryNew_AddItemGround
	Ajoute un item au sol (cree ou utilise un GroundWeaponHolder existant)
	Params: [posATL, classname, count, nearValidPosition (optional)]
	Return: GroundWeaponHolder ou objNull
*/
["A3PL_InventoryNew_AddItemGround", {
	params [
		["_posATL", [0, 0, 0], [[]]],
		["_classname", "", [""]],
		["_count", 0, [0]],
		["_nearValidPosition", false, [false]]
	];

	if ((_classname isEqualTo "") || {_count <= 0}) exitWith {objNull};

	private _holders = nearestObjects [_posATL, ["GroundWeaponHolder"], 3];
	private _index = _holders findIf {isNil {_x getVariable "cargo_inUse"}};
	private _holder = objNull;

	if (_index isEqualTo -1) then {
		_holder = "GroundWeaponHolder" createVehicle [0, 0, 0];
		if (_nearValidPosition) then {
			_holder setPosATL (_posATL findEmptyPosition [0, 7, "GroundWeaponHolder"]);
		} else {
			_holder setPosATL _posATL;
		};
	} else {
		_holder = _holders#_index;
	};

	if (isNull _holder) exitWith {objNull};

	// Stocker dans une variable pour gerer proprement les quantites
	private _cargo = _holder getVariable ["GroundCargo", [[], []]];
	private _idx = (_cargo#0) find _classname;
	if (_idx isEqualTo -1) then {
		(_cargo#0) pushBack _classname;
		(_cargo#1) pushBack _count;
	} else {
		(_cargo#1) set [_idx, ((_cargo#1)#_idx) + _count];
	};
	_holder setVariable ["GroundCargo", _cargo, true];

	// Ajouter aussi physiquement pour l'affichage visuel
	_holder addItemCargoGlobal [_classname, _count];
	_holder;
}] call compile_Global;

/*
	A3PL_InventoryNew_AddItemsGround
	Ajoute plusieurs items au sol
	Params: [posATL, [[items], [counts]]]
	Return: GroundWeaponHolder ou objNull
*/
["A3PL_InventoryNew_AddItemsGround", {
	if !(params [
		["_posATL", [0, 0, 0], [[]]],
		["_items", [], [[]]]
	]) exitWith {
		diag_log "A3PL_InventoryNew_AddItemsGround: Missing parameter(s)";
		objNull
	};

	if (_items isEqualTo [] || {_items isEqualTo [[], []]}) exitWith {objNull};

	private _holder = nearestObjects [_posATL, ["GroundWeaponHolder"], 2];
	private _isNewHolder = _holder isEqualTo [];
	if (_isNewHolder) then {
		_holder = "GroundWeaponHolder" createVehicle [0, 0, 0];
		_holder setPosATL _posATL;
	} else {
		_holder = _holder#0;
	};

	private _classnames = _items#0;
	private _counts = _items#1;

	private _cargo = _holder getVariable ["GroundCargo", [[], []]];
	{
		private _idx = (_cargo#0) find _x;
		if (_idx isEqualTo -1) then {
			(_cargo#0) pushBack _x;
			(_cargo#1) pushBack (_counts#_forEachIndex);
		} else {
			(_cargo#1) set [_idx, ((_cargo#1)#_idx) + (_counts#_forEachIndex)];
		};
	} forEach _classnames;
	_holder setVariable ["GroundCargo", _cargo, true];

	{
		_holder addItemCargoGlobal [_x, _counts#_forEachIndex];
	} forEach _classnames;
	_holder;
}] call compile_Global;

/*
	A3PL_InventoryNew_RemoveItemCargo
	Retire un item d'un cargo
	Params: [target, variable, item, count]
	Return: boolean
*/
["A3PL_InventoryNew_RemoveItemCargo", {
	params [
		["_target", objNull, [objNull]],
		["_var", "", [""]],
		["_item", "", [""]],
		["_count", 0, [0]]
	];

	if ((_item isEqualTo "") || {_count < 0}) exitWith {false};
	if (_count isEqualTo 0) exitWith {true};

	private _isGroundHolder = (typeOf _target) isEqualTo "GroundWeaponHolder";
	private _isVehicleCargo = (_target isKindOf "Car" || _target isKindOf "Air" || _target isKindOf "Ship" || (typeOf _target) isEqualTo "Box_GEN_Equip_F" || (typeOf _target) isEqualTo "A3PL_EMS_Locker" || (typeOf _target) isEqualTo "B_supplyCrate_F" || _isGroundHolder);

	if (_isVehicleCargo) exitWith {
		private _currentItems = itemCargo _target;
		private _currentWeapons = weaponCargo _target;
		private _currentMagazines = magazineCargo _target;
		private _currentBackpacks = backpackCargo _target;

		private _allCargo = _currentItems + _currentWeapons + _currentMagazines + _currentBackpacks;
		private _itemCount = {_x isEqualTo _item} count _allCargo;
		if (_itemCount < _count) exitWith {false};

		private _remainingItems = +_currentItems;
		private _remainingWeapons = +_currentWeapons;
		private _remainingMagazines = +_currentMagazines;
		private _remainingBackpacks = +_currentBackpacks;

		private _toRemove = _count;

		private _idx = _remainingItems find _item;
		while {_idx != -1 && _toRemove > 0} do {
			_remainingItems deleteAt _idx;
			_toRemove = _toRemove - 1;
			_idx = _remainingItems find _item;
		};

		if (_toRemove > 0) then {
			_idx = _remainingWeapons find _item;
			while {_idx != -1 && _toRemove > 0} do {
				_remainingWeapons deleteAt _idx;
				_toRemove = _toRemove - 1;
				_idx = _remainingWeapons find _item;
			};
		};

		if (_toRemove > 0) then {
			_idx = _remainingMagazines find _item;
			while {_idx != -1 && _toRemove > 0} do {
				_remainingMagazines deleteAt _idx;
				_toRemove = _toRemove - 1;
				_idx = _remainingMagazines find _item;
			};
		};

		if (_toRemove > 0) then {
			_idx = _remainingBackpacks find _item;
			while {_idx != -1 && _toRemove > 0} do {
				_remainingBackpacks deleteAt _idx;
				_toRemove = _toRemove - 1;
				_idx = _remainingBackpacks find _item;
			};
		};

		private _hasRemaining = (count _remainingItems > 0) || (count _remainingWeapons > 0) || (count _remainingMagazines > 0) || (count _remainingBackpacks > 0);

		if (_hasRemaining) then {
			if (_isGroundHolder) then {
				private _cargo = _target getVariable ["GroundCargo", [[], []]];
				private _index = (_cargo#0) find _item;
				if (_index isNotEqualTo -1) then {
					private _sum = ((_cargo#1)#_index) - _count;
					if (_sum <= 0) then {
						(_cargo#0) deleteAt _index;
						(_cargo#1) deleteAt _index;
					} else {
						(_cargo#1) set [_index, _sum];
					};
				};

				private _pos = getPos _target;
				private _newHolder = createVehicle ["GroundWeaponHolder", _pos, [], 0, "CAN_COLLIDE"];

				{_newHolder addItemCargoGlobal [_x, 1];} forEach _remainingItems;
				{_newHolder addWeaponCargoGlobal [_x, 1];} forEach _remainingWeapons;
				{_newHolder addMagazineCargoGlobal [_x, 1];} forEach _remainingMagazines;
				{_newHolder addBackpackCargoGlobal [_x, 1];} forEach _remainingBackpacks;

				if !(_cargo isEqualTo [[],[]]) then {
					_newHolder setVariable ["GroundCargo", _cargo, true];
				};

				private _inUseValue = _target getVariable [format ["%1_inUse", _var], ""];
				if (_inUseValue isNotEqualTo "") then {
					_newHolder setVariable [format ["%1_inUse", _var], _inUseValue, true];
				};

				private _display = findDisplay TRANSFER_DISPLAY_IDD;
				if (!isNull _display) then {
					private _params = _display getVariable ["params", []];
					if (count _params > 0) then {
						_params set [0, _newHolder];
						_display setVariable ["params", _params];
						Player_ObjIntersect = _newHolder;
					};
				};

				deleteVehicle _target;
				_target = _newHolder;
			} else {
				clearItemCargoGlobal _target;
				clearWeaponCargoGlobal _target;
				clearMagazineCargoGlobal _target;
				clearBackpackCargoGlobal _target;

				{_target addItemCargoGlobal [_x, 1];} forEach _remainingItems;
				{_target addWeaponCargoGlobal [_x, 1];} forEach _remainingWeapons;
				{_target addMagazineCargoGlobal [_x, 1];} forEach _remainingMagazines;
				{_target addBackpackCargoGlobal [_x, 1];} forEach _remainingBackpacks;
			};

		} else {
			if (_isGroundHolder) then {
				deleteVehicle _target;
			} else {
				clearItemCargoGlobal _target;
				clearWeaponCargoGlobal _target;
				clearMagazineCargoGlobal _target;
				clearBackpackCargoGlobal _target;
			};
		};

		diag_log "[RemoveItemCargo] RETURNING TRUE";
		true
	};

	diag_log format ["[RemoveItemCargo] NOT VehicleCargo - checking variable '%1'", _var];

	if (_var isEqualTo "") exitWith {
		diag_log "[RemoveItemCargo] VARIABLE IS EMPTY - returning FALSE";
		false
	};

	private _cargo = _target getVariable [_var, [[], []]];
	private _index = (_cargo#0) find _item;
	if (_index isEqualTo -1) exitWith {false};

	private _sum = ((_cargo#1)#_index) - _count;
	if (_sum < 0) exitWith {false};

	if (_sum isEqualTo 0) then {
		(_cargo#0) deleteAt _index;
		(_cargo#1) deleteAt _index;
	} else {
		(_cargo#1) set [_index, _sum];
	};

	if (_cargo isEqualTo [[],[]]) then {
		_target setVariable [_var, nil, true];
	} else {
		_target setVariable [_var, _cargo, true];
	};

	true;
}] call compile_Global;

/*
	A3PL_InventoryNew_RemoveItemsCargo
	Retire plusieurs items d'un cargo
	Params: [target, variable, [[items], [counts]]]
	Return: boolean
*/
["A3PL_InventoryNew_RemoveItemsCargo", {
	params [
		["_target", objNull, [objNull]],
		["_var", "", [""]],
		["_items", [], [[], []]]
	];

	if (isNull(_target) || {_items isEqualTo []} || {_var isEqualTo ""} || {_items isEqualTo [[], []]}) exitWith {false};

	// GroundWeaponHolder utilise toujours "GroundCargo" comme variable
	private _isGroundHolder = (typeOf _target) isEqualTo "GroundWeaponHolder";
	// Les vehicules et Box_GEN_Equip_F utilisent le systeme cargo vanilla
	private _isVehicleCargo = (_target isKindOf "Car" || _target isKindOf "Air" || _target isKindOf "Ship" || (typeOf _target) isEqualTo "Box_GEN_Equip_F" || (typeOf _target) isEqualTo "A3PL_EMS_Locker" || (typeOf _target) isEqualTo "B_supplyCrate_F" || (typeOf _target) isEqualTo "GroundWeaponHolder");

	// Pour les vehicules, utiliser les commandes vanilla (clear et re-add)
	if (_isVehicleCargo) exitWith {
		private _removeItems = _items#0;
		private _removeCounts = _items#1;

		// Creer une hashmap des items a retirer
		private _toRemoveMap = createHashMap;
		{
			_toRemoveMap set [_x, _removeCounts#_forEachIndex];
		} forEach _removeItems;

		// Sauvegarder tout le cargo actuel
		private _currentItems = itemCargo _target;
		private _currentWeapons = weaponCargo _target;
		private _currentMagazines = magazineCargo _target;
		private _currentBackpacks = backpackCargo _target;

		// Vider le cargo
		clearItemCargoGlobal _target;
		clearWeaponCargoGlobal _target;
		clearMagazineCargoGlobal _target;
		clearBackpackCargoGlobal _target;

		// Remettre les items sauf ceux a retirer
		{
			private _removeCount = _toRemoveMap getOrDefault [_x, 0];
			if (_removeCount > 0) then {
				_toRemoveMap set [_x, _removeCount - 1];
			} else {
				_target addItemCargoGlobal [_x, 1];
			};
		} forEach _currentItems;

		{
			private _removeCount = _toRemoveMap getOrDefault [_x, 0];
			if (_removeCount > 0) then {
				_toRemoveMap set [_x, _removeCount - 1];
			} else {
				_target addWeaponCargoGlobal [_x, 1];
			};
		} forEach _currentWeapons;

		{
			private _removeCount = _toRemoveMap getOrDefault [_x, 0];
			if (_removeCount > 0) then {
				_toRemoveMap set [_x, _removeCount - 1];
			} else {
				_target addMagazineCargoGlobal [_x, 1];
			};
		} forEach _currentMagazines;

		{
			private _removeCount = _toRemoveMap getOrDefault [_x, 0];
			if (_removeCount > 0) then {
				_toRemoveMap set [_x, _removeCount - 1];
			} else {
				_target addBackpackCargoGlobal [_x, 1];
			};
		} forEach _currentBackpacks;

		true
	};

	private _actualVar = if (_isGroundHolder) then {"GroundCargo"} else {_var};

	if !([_target, _actualVar, _items] call A3PL_InventoryNew_CargoHasItems) exitWith {false};

	private _cargo = _target getVariable [_actualVar, [[],[]]];
	private _cargoItems = _cargo#0;
	private _cargoCounts = _cargo#1;
	private _removeItems = _items#0;
	private _removeCounts = _items#1;

	{
		private _index = _cargoItems find _x;
		private _count = _cargoCounts#_index;
		private _sum = _count - (_removeCounts#_forEachIndex);

		if (_sum isEqualTo 0) then {
			_cargoItems deleteAt _index;
			_cargoCounts deleteAt _index;
		} else {
			_cargoCounts set [_index, _sum];
		};
	} forEach _removeItems;

	if (_isGroundHolder && {_cargoItems isEqualTo []}) then {
		deleteVehicle _target;
	} else {
		if (_cargoItems isEqualTo []) then {
			_target setVariable [_actualVar, nil, true];
		} else {
			_target setVariable [_actualVar, [_cargoItems, _cargoCounts], true];
		};

		// Retirer les items physiquement du GroundWeaponHolder
		if (_isGroundHolder) then {
			{
				[_target, _x, _removeCounts#_forEachIndex] call A3PL_InventoryNew_RemoveItemHolder;
			} forEach _removeItems;
		};
	};

	true;
}] call compile_Global;

/*
	A3PL_InventoryNew_RemoveItemHolder
	Retire un/des item(s) visuellement d'un GroundWeaponHolder
	Params: [target, item, count (default 1)]
	Return: boolean
*/
["A3PL_InventoryNew_RemoveItemHolder", {
	params [
		["_target", objNull, [objNull]],
		["_item", "", [""]],
		["_removeCount", 1, [0]]
	];

	if ((isNull _target) || {_item isEqualTo ""} || {_removeCount < 1}) exitWith {false};

	switch (true) do {
		case (((magazineCargo _target) find _item) isNotEqualTo -1): {
			private _mags = magazinesAmmoCargo _target;
			clearMagazineCargoGlobal _target;
			private _removed = 0;
			{
				if ((_x#0 isEqualTo _item) && {_removed < _removeCount}) then {
					_removed = _removed + 1;
				} else {
					_target addMagazineAmmoCargo [_x#0, 1, _x#1];
				};
			} forEach _mags;
		};
		case (((weaponCargo _target) find _item) isNotEqualTo -1): {
			private _weapons = weaponsItemsCargo _target;
			clearWeaponCargoGlobal _target;
			private _removed = 0;
			{
				if ((_x#0 isEqualTo _item) && {_removed < _removeCount}) then {
					_removed = _removed + 1;
				} else {
					_target addWeaponWithAttachmentsCargoGlobal [_x, 1];
				};
			} forEach _weapons;
		};
		case (((backpackCargo _target) find _item) isNotEqualTo -1): {
			private _backpacks = getBackpackCargo _target;
			clearBackpackCargoGlobal _target;
			{
				private _currentCount = (_backpacks#1)#_forEachIndex;
				if (_x isEqualTo _item) then {
					private _remaining = _currentCount - _removeCount;
					if (_remaining > 0) then {
						_target addBackpackCargoGlobal [_x, _remaining];
					};
				} else {
					_target addBackpackCargoGlobal [_x, _currentCount];
				};
			} forEach (_backpacks#0);
		};
		case (((itemCargo _target) find _item) isNotEqualTo -1): {
			private _items = getItemCargo _target;
			clearItemCargoGlobal _target;
			{
				private _currentCount = (_items#1)#_forEachIndex;
				if (_x isEqualTo _item) then {
					private _remaining = _currentCount - _removeCount;
					if (_remaining > 0) then {
						_target addItemCargoGlobal [_x, _remaining];
					};
				} else {
					_target addItemCargoGlobal [_x, _currentCount];
				};
			} forEach (_items#0);
		};
	};

	true;
}] call compile_Global;

/*
	A3PL_InventoryNew_GetCargoItemFromModel
	Trouve un item dans un cargo par son modele 3D
	Params: [target, variable, model]
	Return: classname ou ""
*/
["A3PL_InventoryNew_GetCargoItemFromModel", {
	params [
		["_target", objNull, [objNull]],
		["_variable", "", [""]],
		["_model", "", [""]]
	];

	if ((isNull _target) || {_model isEqualTo ""} || {_variable isEqualTo ""}) exitWith {""};

	// Normalise le chemin du modele
	if (((toArray _model)#0) isNotEqualTo 92) then {
		_model = format ["\%1", _model];
	};

	private _ret = "";
	private _inventory = _target getVariable [_variable, [[], []]];

	{
		private _cfg = [_x] call A3PL_InventoryNew_GetAssetConfig;
		private _cmp = getText(_cfg >> "model");

		if (_cmp isNotEqualTo "") then {
			if (((toArray _cmp)#0) isNotEqualTo 92) then {
				_cmp = format ["\%1", _cmp];
			};

			if (_cmp == _model) exitWith {
				_ret = configName _cfg;
			};
		};
	} forEach (_inventory#0);

	_ret;
}] call compile_Global;

// ============================================================================
// ITEM HANDLING FUNCTIONS (Player inventory)
// ============================================================================

/*
	A3PL_InventoryNew_HandleItem
	Ajoute ou retire un item de l'inventaire du joueur
	Params: [add (bool), item, count, target container (optional)]
	Return: boolean
*/
["A3PL_InventoryNew_HandleItem", {
	params [
		["_bool", false, [false]],
		["_item", "", [""]],
		["_count", 0, [0]],
		["_target", "", [""]]
	];

	if ((_count isEqualTo 0) || {_item isEqualTo ""}) exitWith {false};

	private _itemCfg = _item call A3PL_InventoryNew_GetItemConfig;
	if (isNull _itemCfg) exitWith {false};

	private _ret = false;

	if (_target isEqualTo "") then {
		// Inventaire general
		if (_bool) then {
			if (player canAdd [_item, _count]) then {
				for "_i" from 1 to _count do {player addItem _item};
				_ret = true;
			};
		} else {
			private _has = {_x isEqualTo _item} count ((items player) + (magazines player));

			if (_has >= _count) then {
				for "_i" from 1 to _count do {player removeItem _item};
				_ret = true;
			};
		};
	} else {
		// Conteneur specifique (uniform, vest, backpack)
		private _targetCfg = _target call A3PL_InventoryNew_GetItemConfig;
		private _targetType = getNumber(_targetCfg >> "ItemInfo" >> "type");

		switch (true) do {
			case (getNumber(_targetCfg >> "isbackpack") isEqualTo 1): {
				if (_bool) then {
					if (player canAddItemToBackpack [_item, _count]) then {
						for "_i" from 1 to _count do {player addItemToBackpack _item};
						_ret = true;
					};
				} else {
					private _has = {_x isEqualTo _item} count (backpackItems player);

					if (_has >= _count) then {
						for "_i" from 1 to _count do {player removeItemFromBackpack _item};
						_ret = true;
					};
				};
			};
			case (_targetType isEqualTo VEST_SLOT): {
				if (_bool) then {
					if (player canAddItemToVest [_item, _count]) then {
						for "_i" from 1 to _count do {player addItemToVest _item};
						_ret = true;
					};
				} else {
					private _has = {_x isEqualTo _item} count (vestItems player);

					if (_has >= _count) then {
						for "_i" from 1 to _count do {player removeItemFromVest _item};
						_ret = true;
					};
				};
			};
			case (_targetType isEqualTo UNIFORM_SLOT): {
				if (_bool) then {
					if (player canAddItemToUniform [_item, _count]) then {
						for "_i" from 1 to _count do {player addItemToUniform _item};
						_ret = true;
					};
				} else {
					private _has = {_x isEqualTo _item} count (uniformItems player);

					if (_has >= _count) then {
						for "_i" from 1 to _count do {player removeItemFromUniform _item};
						_ret = true;
					};
				};
			};
		};
	};

	// Si on retire un item et qu'on a un item en main, verifier s'il faut le lacher
	if (!_bool && {_ret} && {!isNull(player getVariable ["handCarry", objNull])}) then {
		private _handItem = player getVariable ["handItem", ""];
		if ((_handItem isEqualTo _item) && {!(_item call A3PL_InventoryNew_HasItem)}) then {
			[player] call A3PL_InventoryNew_HandCarryItem;
		};
	};

	// Si on ajoute un outil avec durabilité, ajouter automatiquement un chargeur plein
	if (_bool && {_ret} && {!isNil "Config_ToolMagazines"}) then {
		private _magazine = Config_ToolMagazines getOrDefault [_item, ""];
		if (_magazine isNotEqualTo "") then {
			// Ajouter un chargeur par outil ajouté
			for "_i" from 1 to _count do {
				player addMagazine _magazine;
			};
		};
	};

	_ret;
}] call compile_Global;

/*
	A3PL_InventoryNew_HandleEquip
	Equipe ou desequipe un item
	Params: [equip (bool), item]
	Return: boolean
*/
["A3PL_InventoryNew_HandleEquip", {
	if !(params [
		["_bool", false, [false]],
		["_item", "", [""]]
	]) exitWith {
		diag_log format ["A3PL_InventoryNew_HandleEquip: Warning - wrong parameters %1.", _this];
		false
	};

	if (_item isEqualTo "") exitWith {false};

	private _cfg = [_item] call A3PL_InventoryNew_GetAssetConfig;
	if (isNull _cfg) exitWith {false};

	private _parent = [_item] call A3PL_InventoryNew_FetchItemParent;
	private _ret = false;

	switch (_parent) do {
		case "CfgVehicles": {
			private _backpack = backpack player;

			if (getNumber(_cfg >> "isbackpack") isEqualTo 0) exitWith {};
			if (_bool) then {
				if (_backpack isEqualTo "") then {
					player addBackpack _item;
					_ret = true;
				};
			} else {
				if ((backpack player) isEqualTo _item) then {
					removeBackpack player;
					_ret = true;
				};
			};
		};

		case "CfgGlasses": {
			private _goggles = goggles player;

			if (_bool) then {
				if (_goggles isEqualTo "") then {
					player addGoggles _item;
					_ret = true;
				};
			} else {
				if (_goggles isEqualTo _item) then {
					removeGoggles player;
					_ret = true;
				};
			};
		};

		case "CfgMagazines": {
			switch (true) do {
				case ((getArray(configFile >> "CfgWeapons" >> (primaryWeapon player) >> "magazines") findIf {_x isEqualTo _item}) isNotEqualTo -1): {
					private _magazines = primaryWeaponMagazine player;

					if (_bool) then {
						if (_magazines isEqualTo []) then {
							player addPrimaryWeaponItem _item;
							_ret = true;
						};
					} else {
						if (_item in _magazines) then {
							player removePrimaryWeaponItem _item;
							[true, _item, 1] call A3PL_InventoryNew_HandleItem;
							_ret = true;
						};
					};
				};
				case ((getArray(configFile >> "CfgWeapons" >> (handgunWeapon player) >> "magazines") findIf {_x isEqualTo _item}) isNotEqualTo -1): {
					private _magazines = handgunMagazine player;

					if (_bool) then {
						if (_magazines isEqualTo []) then {
							player addHandgunItem _item;
							_ret = true;
						};
					} else {
						if (_item in _magazines) then {
							player removeHandgunItem _item;
							[true, _item, 1] call A3PL_InventoryNew_HandleItem;
							_ret = true;
						};
					};
				};
				case ((getArray(configFile >> "CfgWeapons" >> (secondaryWeapon player) >> "magazines") findIf {_x isEqualTo _item}) isNotEqualTo -1): {
					private _magazines = secondaryWeaponMagazine player;

					if (_bool) then {
						if (_magazines isEqualTo []) then {
							player addSecondaryWeaponItem _item;
							_ret = true;
						};
					} else {
						if (_item in _magazines) then {
							player removeSecondaryWeaponItem _item;
							[true, _item, 1] call A3PL_InventoryNew_HandleItem;
							_ret = true;
						};
					};
				};
			};
		};

		case "CfgWeapons": {
			private _primaryItems = primaryWeaponItems player;
			private _handgunItems = handgunItems player;
			private _secondaryItems = secondaryWeaponItems player;
			private _isAttachment = (_item in _primaryItems) || {_item in _handgunItems} || {_item in _secondaryItems};

			diag_log format ["A3PL_InventoryNew_HandleEquip: item=%1, bool=%2, isAttachment=%3", _item, _bool, _isAttachment];
			diag_log format ["  primaryItems=%1", _primaryItems];
			diag_log format ["  handgunItems=%1", _handgunItems];
			diag_log format ["  secondaryItems=%1", _secondaryItems];

			if (_isAttachment) then {
				if (_bool) exitWith {
					diag_log "  Trying to equip attachment directly - returning false";
					_ret = false;
				};

				if (_item in _primaryItems) then {
					diag_log "  Removing from primary weapon";
					player removePrimaryWeaponItem _item;
					[true, _item, 1] call A3PL_InventoryNew_HandleItem;
					_ret = true;
				} else {
					if (_item in _handgunItems) then {
						diag_log "  Removing from handgun";
						player removeHandgunItem _item;
						[true, _item, 1] call A3PL_InventoryNew_HandleItem;
						_ret = true;
					} else {
						if (_item in _secondaryItems) then {
							diag_log "  Removing from secondary weapon";
							player removeSecondaryWeaponItem _item;
							[true, _item, 1] call A3PL_InventoryNew_HandleItem;
							_ret = true;
						};
					};
				};
				diag_log format ["  Result: _ret=%1", _ret];
			} else {
			switch (getNumber(_cfg >> "type")) do {
				case WeaponSlotBinocular: {
					private _binocular = binocular player;

					if (_bool) then {
						if (_binocular isEqualTo "") then {
							player addWeapon _item;
							_ret = true;
						};
					} else {
						if (_binocular isEqualTo _item) then {
							player removeWeapon _item;
							_ret = true;
						};
					};
				};
				case WeaponSlotPrimary: {
					private _weapon = primaryWeapon player;

					if (_bool) then {
						if (_weapon isEqualTo "") then {
							private _magsBefore = magazines player;
							player addWeapon _item;
							private _loadedMag = primaryWeaponMagazine player;
							{player removePrimaryWeaponItem _x} forEach _loadedMag;
							private _magsAfter = magazines player;
							{
								private _magType = _x;
								private _countBefore = {_x isEqualTo _magType} count _magsBefore;
								private _countAfter = {_x isEqualTo _magType} count _magsAfter;
								if (_countAfter < _countBefore) then {
									player addItem _magType;
								};
							} forEach (_magsBefore arrayIntersect _magsBefore);
							_ret = true;
						};
					} else {
						if (_item isEqualTo _weapon) then {
							// Save magazines and attachments before removing weapon
							private _magazines = primaryWeaponMagazine player;
							private _attachments = (primaryWeaponItems player) - [""];
							player removeWeapon _item;
							// Add magazines and attachments back to inventory
							{[true, _x, 1] call A3PL_InventoryNew_HandleItem} forEach _magazines;
							{[true, _x, 1] call A3PL_InventoryNew_HandleItem} forEach _attachments;
							_ret = true;
						};
					};
				};
				case WeaponSlotHandGun: {
					private _weapon = handgunWeapon player;

					if (_bool) then {
						if (_weapon isEqualTo "") then {
							private _magsBefore = magazines player;
							player addWeapon _item;
							private _loadedMag = handgunMagazine player;
							{player removeHandgunItem _x} forEach _loadedMag;
							private _magsAfter = magazines player;
							{
								private _magType = _x;
								private _countBefore = {_x isEqualTo _magType} count _magsBefore;
								private _countAfter = {_x isEqualTo _magType} count _magsAfter;
								if (_countAfter < _countBefore) then {
									player addItem _magType;
								};
							} forEach (_magsBefore arrayIntersect _magsBefore);
							_ret = true;
						};
					} else {
						if (_item isEqualTo _weapon) then {
							// Save magazines and attachments before removing weapon
							private _magazines = handgunMagazine player;
							private _attachments = (handgunItems player) - [""];
							player removeWeapon _item;
							// Add magazines and attachments back to inventory
							{[true, _x, 1] call A3PL_InventoryNew_HandleItem} forEach _magazines;
							{[true, _x, 1] call A3PL_InventoryNew_HandleItem} forEach _attachments;
							_ret = true;
						};
					};
				};
				case WeaponSlotSecondary: {
					private _weapon = secondaryWeapon player;

					if (_bool) then {
						if (_weapon isEqualTo "") then {
							private _magsBefore = magazines player;
							player addWeapon _item;
							private _loadedMag = secondaryWeaponMagazine player;
							{player removeSecondaryWeaponItem _x} forEach _loadedMag;
							private _magsAfter = magazines player;
							{
								private _magType = _x;
								private _countBefore = {_x isEqualTo _magType} count _magsBefore;
								private _countAfter = {_x isEqualTo _magType} count _magsAfter;
								if (_countAfter < _countBefore) then {
									player addItem _magType;
								};
							} forEach (_magsBefore arrayIntersect _magsBefore);
							_ret = true;
						};
					} else {
						if (_item isEqualTo _weapon) then {
							// Save magazines and attachments before removing weapon
							private _magazines = secondaryWeaponMagazine player;
							private _attachments = (secondaryWeaponItems player) - [""];
							player removeWeapon _item;
							// Add magazines and attachments back to inventory
							{[true, _x, 1] call A3PL_InventoryNew_HandleItem} forEach _magazines;
							{[true, _x, 1] call A3PL_InventoryNew_HandleItem} forEach _attachments;
							_ret = true;
						};
					};
				};
				case WeaponSlotInventory: {
					switch (getNumber(_cfg >> "itemInfo" >> "type")) do {
						case DEFAULT_SLOT: {
							switch (getText(_cfg >> "simulation")) do {
								case "ItemRadio";
								case "ItemWatch";
								case "ItemCompass";
								case "ItemMap": {
									private _assigned = assignedItems player;

									if (_bool) then {
										if !(_item in _assigned) then {
											player linkItem _item;
											_ret = true;
										};
									} else {
										if (_item in _assigned) then {
											player unlinkItem _item;
											_ret = true;
										};
									};
								};
							};
						};
						case HEADGEAR_SLOT: {
							private _headgear = headgear player;

							if (_bool) then {
								if (_headgear isEqualTo "") then {
									player addHeadgear _item;
									_ret = true;
								};
							} else {
								if (_headgear isEqualTo _item) then {
									removeHeadgear player;
									_ret = true;
								};
							};
						};
						case UNIFORM_SLOT: {
							private _uniform = uniform player;

							if (_bool) then {
								if (_uniform isEqualTo "") then {
									player forceAddUniform _item;
									_ret = true;
								};
							} else {
								if (_uniform isEqualTo _item) then {
									removeUniform player;
									_ret = true;
								};
							};
						};
						case VEST_SLOT: {
							private _vest = vest player;

							if (_bool) then {
								if (_vest isEqualTo "") then {
									player addVest _item;
									_ret = true;
								};
							} else {
								if (_vest isEqualTo _item) then {
									removeVest player;
									_ret = true;
								};
							};
						};
					};
				};
			};
			}; 
		};
	};

	_ret;
}] call compile_Global;

/*
	A3PL_InventoryNew_EquipmentItems
	Recupere les items lies a un equipement (contenu uniform, vest, backpack, attachements arme)
	Params: item
	Return: array d'items
*/
["A3PL_InventoryNew_EquipmentItems", {
	private _item = param [0, "", [""]];

	if (_item isEqualTo "") exitWith {[]};

	private _cfg = [_item] call A3PL_InventoryNew_GetAssetConfig;
	if (isNull _cfg) exitWith {[]};

	private _parent = [_item] call A3PL_InventoryNew_FetchItemParent;
	private _ret = [];

	switch (_parent) do {
		case "CfgVehicles": {
			if (((backpack player) isEqualTo _item) && {getNumber(_cfg >> "isbackpack") > 0}) then {
				_ret = backpackItems player;
			};
		};

		case "CfgWeapons": {
			switch (getNumber(_cfg >> "type")) do {
				case WeaponSlotPrimary: {
					if (_item isEqualTo (primaryWeapon player)) then {
						_ret = (primaryWeaponItems player) + (primaryWeaponMagazine player);
					};
				};
				case WeaponSlotHandGun: {
					if (_item isEqualTo (handgunWeapon player)) then {
						_ret = (handgunItems player) + (handgunMagazine player);
					};
				};
				case WeaponSlotSecondary: {
					if (_item isEqualTo (secondaryWeapon player)) then {
						_ret = (secondaryWeaponItems player) + (secondaryWeaponMagazine player);
					};
				};
				case WeaponSlotInventory: {
					switch (getNumber(_cfg >> "itemInfo" >> "type")) do {
						case UNIFORM_SLOT: {
							if (_item isEqualTo (uniform player)) then {
								_ret = uniformItems player;
							};
						};
						case VEST_SLOT: {
							if (_item isEqualTo (vest player)) then {
								_ret = vestItems player;
							};
						};
					};
				};
			};
		};
	};

	_ret - [""];
}] call compile_Global;

/*
	A3PL_InventoryNew_ForceAddItem
	Force l'ajout d'un item (equipe si possible, sinon inventaire, sinon sol)
	Params: [item, count]
*/
["A3PL_InventoryNew_ForceAddItem", {
	if !(params [
		["_item", "", [""]],
		["_count", 0, [0]]
	]) exitWith {};

	if ((_item isEqualTo "") || {_count <= 0}) exitWith {};

	if (([_item] call A3PL_InventoryNew_CanEquipItem) && {[true, _item] call A3PL_InventoryNew_HandleEquip}) exitWith {};
	if ([true, _item, _count] call A3PL_InventoryNew_HandleItem) exitWith {};

	[getPosATL player, _item, _count] call A3PL_InventoryNew_AddItemGround;
	["STR_A3PL_Inventory_ErrItemAddedFloor" call A3PL_Localize, Color_Orange] call A3PL_Notification;
}] call compile_Global;

/*
	A3PL_InventoryNew_DropItem
	Jette un item de l'inventaire au sol
	Params: [item, count, from container (optional)]
	Return: boolean
*/
["A3PL_InventoryNew_DropItem", {
	params [
		["_item", "", [""]],
		["_count", 1, [0]],
		["_from", "", [""]]
	];

	// Verifier si le joueur peut effectuer l'action (pas dans vehicule/eau)
	// Exception pour le filet qui peut etre droppe dans l'eau
	if !([_item] call A3PL_InventoryNew_CanPerformItemAction) exitWith {false};

	if ([false, _item, _count, _from] call A3PL_InventoryNew_HandleItem) exitWith {
		[getPosATL player, _item, _count] call A3PL_InventoryNew_AddItemGround;
		true
	};

	false;
}] call compile_Global;

/*
	A3PL_InventoryNew_DropEquipment
	Jette un equipement (avec son contenu)
	Params: item
	Return: boolean
*/
["A3PL_InventoryNew_DropEquipment", {
	private _item = param [0, "", [""]];

	diag_log format ["[DropEquipment] CALLED with item:%1", _item];

	if (_item isEqualTo "") exitWith {false};

	if !(call A3PL_InventoryNew_CanPerformItemAction) exitWith {false};

	private _cfg = _item call A3PL_InventoryNew_GetItemConfig;
	private _parent = [_item] call A3PL_InventoryNew_FetchItemParent;
	diag_log format ["[DropEquipment] parent:%1, cfg:%2", _parent, _cfg];

	if (_parent isEqualTo "CfgWeapons") then {
		// Essayer les deux variantes de casse pour ItemInfo
		private _itemType = getNumber(_cfg >> "ItemInfo" >> "type");
		if (_itemType isEqualTo 0) then {
			_itemType = getNumber(_cfg >> "itemInfo" >> "type");
		};
		diag_log format ["[DropEquipment] itemType from config: %1", _itemType];
		if (_itemType in [101, 201, 301, 302]) then {
			if ([false, _item] call A3PL_InventoryNew_HandleEquip) then {
				if ([false, _item, 1] call A3PL_InventoryNew_HandleItem) then {
					[getPosATL player, _item, 1] call A3PL_InventoryNew_AddItemGround;
					true
				} else {
					false
				};
			} else {
				false
			};
		} else {
			// Verifier si c'est un uniforme (801) ou un gilet (701)
			diag_log format ["[DropEquipment] itemType=%1, checking for 801/701", _itemType];
			if (_itemType in [801, 701]) then {
				// Sauvegarder le contenu AVANT de retirer l'equipement
				private _containerContent = [_item] call A3PL_InventoryNew_EquipmentItems;
				private _containerType = if (_itemType isEqualTo 801) then {"uniform"} else {"vest"};
				diag_log format ["[DropEquipment] Container %1 (%2) content before drop: %3 (count=%4)", _item, _containerType, _containerContent, count _containerContent];

				// Retirer l'equipement
				if !([false, _item] call A3PL_InventoryNew_HandleEquip) exitWith {
					diag_log "[DropEquipment] HandleEquip failed";
					false
				};

				// Creer le GroundWeaponHolder avec seulement le conteneur
				private _holder = [getPosATL player, _item, 1] call A3PL_InventoryNew_AddItemGround;
				diag_log format ["[DropEquipment] Created holder: %1, isNull=%2", _holder, isNull _holder];

				// Stocker le contenu sauvegarde sur le holder (utiliser HashMap pour plusieurs conteneurs)
				if (!isNull _holder && {count _containerContent > 0}) then {
					private _allContents = _holder getVariable ["A3PL_ContainerContents", createHashMap];
					_allContents set [_item, [_containerType, _containerContent]];
					_holder setVariable ["A3PL_ContainerContents", _allContents, true];
					// Garder aussi l'ancien format pour compatibilite
					_holder setVariable ["A3PL_ContainerContent", [_item, _containerType, _containerContent], true];
					diag_log format ["[DropEquipment] Saved container content on holder: %1", [_item, _containerType, _containerContent]];
					// Verification immediate
					private _verify = _holder getVariable ["A3PL_ContainerContent", []];
					diag_log format ["[DropEquipment] Verification - content on holder: %1", _verify];
				} else {
					diag_log format ["[DropEquipment] NOT saving content - holder null=%1, content count=%2", isNull _holder, count _containerContent];
				};

				!isNull _holder
			} else {
				// Autres equipements CfgWeapons (armes, etc.)
				private _items = [_item] call A3PL_InventoryNew_EquipmentItems;
				if !([false, _item] call A3PL_InventoryNew_HandleEquip) exitWith {false};

				private _parentType = [_item] call A3PL_InventoryNew_FetchItemParent;
				private _itemsToAdd = if (_parentType isEqualTo "CfgWeapons") then {
					_items select {([_x] call A3PL_InventoryNew_FetchItemParent) isNotEqualTo "CfgMagazines"}
				} else {
					_items
				};

				!isNull([getPosATL player, (_itemsToAdd + [_item]) call A3PL_InventoryNew_FormatInv] call A3PL_InventoryNew_AddItemsGround)
			};
		};
	} else {
		// Traitement special pour les magazines equipes (evite duplication)
		if (_parent isEqualTo "CfgMagazines") then {
			private _removed = false;

			// Retirer le magazine de l'arme sans l'ajouter a l'inventaire
			if (_item in (primaryWeaponMagazine player)) then {
				player removePrimaryWeaponItem _item;
				_removed = true;
			} else { if (_item in (handgunMagazine player)) then {
				player removeHandgunItem _item;
				_removed = true;
			} else { if (_item in (secondaryWeaponMagazine player)) then {
				player removeSecondaryWeaponItem _item;
				_removed = true;
			}}};

			if (_removed) then {
				[getPosATL player, _item, 1] call A3PL_InventoryNew_AddItemGround;
				true
			} else {
				false
			};
		} else {
			// Sacs a dos (CfgVehicles) - preserver le contenu
			private _cfgVehicle = configFile >> "CfgVehicles" >> _item;
			private _isBackpack = isClass _cfgVehicle && {getNumber(_cfgVehicle >> "isbackpack") > 0};

			if (_isBackpack) then {
				// Sauvegarder le contenu AVANT de retirer l'equipement
				private _containerContent = [_item] call A3PL_InventoryNew_EquipmentItems;
				diag_log format ["[DropEquipment] Backpack %1 content before drop: %2", _item, _containerContent];

				// Retirer l'equipement
				if !([false, _item] call A3PL_InventoryNew_HandleEquip) exitWith {false};

				// Creer le GroundWeaponHolder avec seulement le conteneur
				private _holder = [getPosATL player, _item, 1] call A3PL_InventoryNew_AddItemGround;

				// Stocker le contenu sauvegarde sur le holder (format: [item, type, items])
				if (!isNull _holder && {count _containerContent > 0}) then {
					_holder setVariable ["A3PL_ContainerContent", [_item, "backpack", _containerContent], true];
					diag_log format ["[DropEquipment] Saved backpack content on holder: %1", [_item, "backpack", _containerContent]];
				};

				!isNull _holder
			} else {
				// Autres equipements (non-conteneurs)
				private _items = [_item] call A3PL_InventoryNew_EquipmentItems;
				if !([false, _item] call A3PL_InventoryNew_HandleEquip) exitWith {false};
				!isNull([getPosATL player, (_items + [_item]) call A3PL_InventoryNew_FormatInv] call A3PL_InventoryNew_AddItemsGround)
			};
		};
	};
}] call compile_Global;

/*
	A3PL_InventoryNew_EquipItemFromInventory
	Equipe un item depuis l'inventaire
	Params: [item, from container]
	Return: boolean
*/
["A3PL_InventoryNew_EquipItemFromInventory", {
	params [
		["_item", "", [""]],
		["_from", "", [""]]
	];

	if (_item isEqualTo "") exitWith {false};

	if !([_item] call A3PL_InventoryNew_CanEquipItem) exitWith {false};

	private _ret = false;
	private _cfg = _item call A3PL_InventoryNew_GetItemConfig;
	private _type = getNumber(_cfg >> "type");
	private _parent = [_item] call A3PL_InventoryNew_FetchItemParent;

	if (_parent isEqualTo "CfgMagazines") then {
		private _primaryWeapon = primaryWeapon player;
		private _handgunWeapon = handgunWeapon player;
		private _secondaryWeapon = secondaryWeapon player;

		if (_primaryWeapon isNotEqualTo "" && {_item in (getArray(configFile >> "CfgWeapons" >> _primaryWeapon >> "magazines"))}) then {
			if ((primaryWeaponMagazine player) isEqualTo []) then {
				if ([false, _item, 1, _from] call A3PL_InventoryNew_HandleItem) then {
					player addPrimaryWeaponItem _item;
					_ret = true;
				};
			};
		} else {
			if (_handgunWeapon isNotEqualTo "" && {_item in (getArray(configFile >> "CfgWeapons" >> _handgunWeapon >> "magazines"))}) then {
				if ((handgunMagazine player) isEqualTo []) then {
					if ([false, _item, 1, _from] call A3PL_InventoryNew_HandleItem) then {
						player addHandgunItem _item;
						_ret = true;
					};
				};
			} else {
				if (_secondaryWeapon isNotEqualTo "" && {_item in (getArray(configFile >> "CfgWeapons" >> _secondaryWeapon >> "magazines"))}) then {
					if ((secondaryWeaponMagazine player) isEqualTo []) then {
						if ([false, _item, 1, _from] call A3PL_InventoryNew_HandleItem) then {
							player addSecondaryWeaponItem _item;
							_ret = true;
						};
					};
				};
			};
		};
	} else {
	if (_parent isEqualTo "CfgWeapons") then {
		private _itemType = getNumber(_cfg >> "itemInfo" >> "type");
		if (_itemType in [101, 201, 301, 302]) then {
			private _primaryWeapon = primaryWeapon player;
			private _handgunWeapon = handgunWeapon player;
			private _secondaryWeapon = secondaryWeapon player;

			private _attachmentSlot = switch (_itemType) do {
				case 101: {0};
				case 301: {1};
				case 201: {2};
				case 302: {3};
				default {-1};
			};

			if (_primaryWeapon isNotEqualTo "" && {_attachmentSlot >= 0}) then {
				private _currentAttachment = (primaryWeaponItems player) select _attachmentSlot;
				if (_currentAttachment isEqualTo "") then {
					if ([false, _item, 1, _from] call A3PL_InventoryNew_HandleItem) then {
						player addPrimaryWeaponItem _item;
						_ret = true;
					};
				};
			};

			if (!_ret && _handgunWeapon isNotEqualTo "" && {_attachmentSlot >= 0}) then {
				private _currentAttachment = (handgunItems player) select _attachmentSlot;
				if (_currentAttachment isEqualTo "") then {
					if ([false, _item, 1, _from] call A3PL_InventoryNew_HandleItem) then {
						player addHandgunItem _item;
						_ret = true;
					};
				};
			};

			if (!_ret && _secondaryWeapon isNotEqualTo "" && {_attachmentSlot >= 0}) then {
				private _currentAttachment = (secondaryWeaponItems player) select _attachmentSlot;
				if (_currentAttachment isEqualTo "") then {
					if ([false, _item, 1, _from] call A3PL_InventoryNew_HandleItem) then {
						player addSecondaryWeaponItem _item;
						_ret = true;
					};
				};
			};
		} else {
		if ((_type isEqualTo WeaponSlotPrimary)
			|| {_type isEqualTo WeaponSlotSecondary}
			|| {_type isEqualTo WeaponSlotHandGun}
			|| {_type isEqualTo WeaponSlotBinocular}) then {
			if ([false, _item, 1, _from] call A3PL_InventoryNew_HandleItem) then {
				_ret = [true, _item] call A3PL_InventoryNew_HandleEquip;
			};
		} else {
			player assignItem _item;
			_ret = true;
		};
		};
	} else {
		player assignItem _item;
		_ret = true;
	};
	};

	_ret;
}] call compile_Global;

/*
	A3PL_InventoryNew_UnequipToInventory
	Desequipe un item vers l'inventaire
	Params: item
	Return: boolean
*/
["A3PL_InventoryNew_UnequipToInventory", {
	private _item = param [0, "", [""]];
	diag_log format ["A3PL_InventoryNew_UnequipToInventory called with item=%1", _item];
	if (_item isEqualTo "") exitWith {
		diag_log "  EXIT: empty item";
		false
	};

	private _ret = false;
	private _cfg = _item call A3PL_InventoryNew_GetItemConfig;
	private _type = getNumber(_cfg >> "type");
	private _itemInfoType = getNumber(_cfg >> "itemInfo" >> "type");
	private _parent = [_item] call A3PL_InventoryNew_FetchItemParent;
	diag_log format ["  cfg=%1, type=%2, itemInfoType=%3, parent=%4", _cfg, _type, _itemInfoType, _parent];

	// Verifier si c'est un sac à dos avant de le retirer
	private _isBackpack = (isClass _cfg && {getNumber(_cfg >> "isBackpack") == 1} && {(backpack player) isEqualTo _item});

	// Verifier si c'est un uniforme ou un gilet
	private _isUniform = (_itemInfoType isEqualTo UNIFORM_SLOT) && {(uniform player) isEqualTo _item};
	private _isVest = (_itemInfoType isEqualTo VEST_SLOT) && {(vest player) isEqualTo _item};

	if (_parent isEqualTo "CfgMagazines") then {
		if !(player canAdd _item) exitWith {false};
		if ([false, _item] call A3PL_InventoryNew_HandleEquip) then {
			_ret = true;
		};
	} else {
	// Gerer les uniformes et gilets en priorite
	if (_isUniform || _isVest) then {
		diag_log format ["  Processing container: isUniform=%1, isVest=%2", _isUniform, _isVest];

		// Sauvegarder le contenu du conteneur
		private _containerItems = if (_isUniform) then {uniformItems player} else {vestItems player};
		diag_log format ["  Container items: %1", _containerItems];

		// Retirer le conteneur
		if (_isUniform) then {
			removeUniform player;
		} else {
			removeVest player;
		};

		// Verifier si le joueur peut effectuer une action (pas dans vehicule/eau)
		if !(call A3PL_InventoryNew_CanPerformItemAction) exitWith {
			// Remettre le conteneur si on ne peut pas le jeter
			if (_isUniform) then {
				player forceAddUniform _item;
				{player addItemToUniform _x} forEach _containerItems;
			} else {
				player addVest _item;
				{player addItemToVest _x} forEach _containerItems;
			};
			false
		};

		// Essayer de mettre le conteneur dans le backpack
		private _hasBackpack = (backpack player) isNotEqualTo "";
		private _addedToBackpack = false;

		if (_hasBackpack && {player canAddItemToBackpack _item}) then {
			player addItemToBackpack _item;
			_addedToBackpack = true;
			diag_log "  Added container to backpack";

			// Transferer le contenu vers l'inventaire disponible
			{
				if (player canAdd _x) then {
					player addItem _x;
				} else {
					// Si pas de place, jeter au sol
					[getPosATL player, _x, 1] call A3PL_InventoryNew_AddItemGround;
				};
			} forEach _containerItems;
		};

		if (!_addedToBackpack) then {
			// Pas de place dans le backpack - jeter au sol avec le contenu
			diag_log "  Dropping container and contents to ground";

			// Creer un holder au sol
			private _holder = "GroundWeaponHolder" createVehicle [0, 0, 0];
			_holder setPosATL (getPosATL player);

			// Ajouter le conteneur visuellement
			_holder addItemCargoGlobal [_item, 1];

			// Stocker le contenu dans une variable sur le holder pour le recuperer plus tard
			private _cargo = [[_item], [1]];
			{
				private _idx = (_cargo#0) find _x;
				if (_idx isEqualTo -1) then {
					(_cargo#0) pushBack _x;
					(_cargo#1) pushBack 1;
				} else {
					(_cargo#1) set [_idx, ((_cargo#1)#_idx) + 1];
				};

				// Ajouter visuellement au holder
				private _itemParent = [_x] call A3PL_InventoryNew_FetchItemParent;
				switch (_itemParent) do {
					case "CfgMagazines": { _holder addMagazineCargoGlobal [_x, 1]; };
					case "CfgWeapons": { _holder addWeaponCargoGlobal [_x, 1]; };
					default { _holder addItemCargoGlobal [_x, 1]; };
				};
			} forEach _containerItems;

			_holder setVariable ["GroundCargo", _cargo, true];

			// Stocker les items qui etaient dans le conteneur pour les restaurer au ramassage
			private _containerType = if (_isUniform) then {"uniform"} else {"vest"};
			_holder setVariable ["A3PL_ContainerContent", [_item, _containerType, _containerItems], true];

			["STR_A3PL_Inventory_ErrItemAddedFloor" call A3PL_Localize, Color_Orange] call A3PL_Notification;
		};

		_ret = true;
	} else {
	// Gerer les attachements d'armes
	if (_parent isEqualTo "CfgWeapons") then {
		// Verifier si c'est un attachement equipe sur une arme
		private _primaryItems = primaryWeaponItems player;
		private _handgunItems = handgunItems player;
		private _secondaryItems = secondaryWeaponItems player;
		private _isAttachment = (_item in _primaryItems) || {_item in _handgunItems} || {_item in _secondaryItems};

		diag_log format ["  CfgWeapons item, isAttachment=%1", _isAttachment];

		if (_isAttachment) then {
			diag_log "  This is an attachment - calling HandleEquip";
			if ([false, _item] call A3PL_InventoryNew_HandleEquip) then {
				diag_log "  HandleEquip returned true";
				_ret = true;
			};
		} else {
		// Gerer les armes completes
		if ((_type isEqualTo WeaponSlotPrimary)
			|| {_type isEqualTo WeaponSlotSecondary}
			|| {_type isEqualTo WeaponSlotHandGun}
			|| {_type isEqualTo WeaponSlotBinocular}) then {

			private _weaponItems = [_item] call A3PL_InventoryNew_EquipmentItems;

			if ([false, _item] call A3PL_InventoryNew_HandleEquip) then {
				if (player canAdd _item) then {
					player addItem _item;
					_ret = true;
				} else {
					if (call A3PL_InventoryNew_CanPerformItemAction) then {
						[getPosATL player, (_weaponItems + [_item]) call A3PL_InventoryNew_FormatInv] call A3PL_InventoryNew_AddItemsGround;
						["STR_A3PL_Inventory_ErrItemAddedFloor" call A3PL_Localize, Color_Orange] call A3PL_Notification;
					};
					_ret = true;
				};
			};
		} else {
			// Items assignables (map, watch, compass, radio)
			if !(player canAdd _item) exitWith {false};
			player unassignItem _item;
			_ret = true;
		};
		};
	} else {
		// Autres items (CfgVehicles - backpacks, CfgGlasses - goggles)
		if (_isBackpack) then {
			private _backpackItems = backpackItems player;

			if ([false, _item] call A3PL_InventoryNew_HandleEquip) then {
				if (call A3PL_InventoryNew_CanPerformItemAction) then {
					[getPosATL player, (_backpackItems + [_item]) call A3PL_InventoryNew_FormatInv] call A3PL_InventoryNew_AddItemsGround;
					["STR_A3PL_Inventory_ErrItemAddedFloor" call A3PL_Localize, Color_Orange] call A3PL_Notification;
				};
				_ret = true;
			};
		} else {
			// Goggles ou autre
			if ([false, _item] call A3PL_InventoryNew_HandleEquip) then {
				if (player canAdd _item) then {
					player addItem _item;
				} else {
					if (call A3PL_InventoryNew_CanPerformItemAction) then {
						[getPosATL player, _item, 1] call A3PL_InventoryNew_AddItemGround;
						["STR_A3PL_Inventory_ErrItemAddedFloor" call A3PL_Localize, Color_Orange] call A3PL_Notification;
					};
				};
				_ret = true;
			};
		};
	};
	};
	};

	// Si un sac à dos a été retiré, migrer les items virtuels hors grille
	if (_ret && _isBackpack) then {
		[] call A3PL_InventoryNew_MigrateVirtualOverflow;
	};

	_ret;
}] call compile_Global;

/*
	A3PL_InventoryNew_TransfertItemTo
	Transfere un item d'un conteneur a un autre
	Params: [item, count, from, to]
	Return: boolean
*/
["A3PL_InventoryNew_TransfertItemTo", {
	if (!params[
		["_item", "", [""]],
		["_count", 1, [0]],
		["_from", "", [""]],
		["_to", "", [""]]
	]) exitWith {
		diag_log format ["A3PL_InventoryNew_TransfertItemTo: Warning - wrong parameters %1.", _this];
		false
	};

	if ((_item isEqualTo "") || {_count isEqualTo 0} || {_from isEqualTo ""} || {_to isEqualTo ""}) exitWith {false};

	while {!([true, _item, _count, _to] call A3PL_InventoryNew_HandleItem) && {_count > 0}} do {
		_count = _count - 1;
	};

	if (_count isEqualTo 0) exitWith {false};

	if !([false, _item, _count, _from] call A3PL_InventoryNew_HandleItem) exitWith {
		[false, _item, _count, _to] call A3PL_InventoryNew_HandleItem;
		false
	};

	true;
}] call compile_Global;

/*
	A3PL_InventoryNew_ClearGear
	Retire tout l'equipement du joueur
*/
["A3PL_InventoryNew_ClearGear", {
	if ((hmd player) isNotEqualTo "") then {
		player unlinkItem (hmd player);
	};

	{
		player unassignItem _x
	} forEach (assignedItems player);

	removeUniform player;
	removeVest player;
	removeBackpack player;
	removeGoggles player;
	removeHeadGear player;
	removeAllWeapons player;
}] call compile_Global;

/*
	A3PL_InventoryNew_ComplexArrayToSimple
	Convertit un array [[items], [counts]] en [[item, count], ...]
	Params: [[items], [counts]]
	Return: [[item, count], ...]
*/
["A3PL_InventoryNew_ComplexArrayToSimple", {
	private _complexArray = param[0, [], [[]]];
	private _array1 = _complexArray#0;
	private _array2 = _complexArray#1;
	private _newArray = [];

	for "_i" from 0 to (count _array1 - 1) do {
		_newArray pushBack [_array1#_i, _array2#_i];
	};

	_newArray;
}] call compile_Global;

/*
	A3PL_InventoryNew_HandCarryItem
	Attache un item a la main du joueur (visuel)
	Params: [target, item (optional), memory point (optional)]
*/
["A3PL_InventoryNew_HandCarryItem", {
	params [
		["_target", objNull, [objNull]],
		["_item", "", [""]],
		["_memory", "righthand", [""]]
	];

	if (isNull _target) exitWith {};

	private _previous = _target getVariable ["handCarry", objNull];

	if (!isNull _previous) then {
		detach _previous;
		deleteVehicle _previous;
		_target setVariable ["handCarry", nil];
		_target setVariable ["handItem", nil];
	};

	if (_item isEqualTo "") exitWith {};

	private _type = "foot";
	if (!((vehicle _target) isKindOf "Man")) then {
		_type = "vehicle";
	};

	private _cfg = _item call A3PL_InventoryNew_GetItemConfig;
	private _model = getText(_cfg >> "model");

	// Normalise le chemin du modele
	if (((toArray _model)#0) isEqualTo 92) then {
		_model = [_model, 1, count _model] call BIS_fnc_trimString;
	};

	private _obj = createSimpleObject [_model, [0, 0, 0], false];

	switch (_type) do {
		case "foot": {
			_obj attachTo [_target, [-0.085, -0.06, 0.025], _memory, true];
			_obj setVectorDirAndUp [[1,0,0], [0,1,0]];
		};
		case "vehicle": {
			_obj attachTo [_target, [-0.03, 0, 0.05], _memory, true];
			_obj setDir 95;
		};
	};

	_target setVariable ["handCarry", _obj];
	_target setVariable ["handItem", _item];
}] call compile_Global;

// ============================================================================
// UI FUNCTIONS - Right Click Menu
// ============================================================================

/*
	A3PL_InventoryNew_RightClick
	Gere le clic droit sur un item dans l'inventaire
	Params: [control, button, xPos, yPos, shift, ctrl, alt, slot (optional)]
*/
["A3PL_InventoryNew_RightClick", {
	disableSerialization;
	params ["_control", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt", ["_slot", false]];

	diag_log format ["RightClick called: button=%1, pos=[%2,%3]", _button, _xPos, _yPos];

	private _display = GVAR_UI(INVENTORY_DISPLAY_NAME, displayNull);
	if (isNull _display) exitWith { diag_log "RightClick: display is null, exiting"; };

	// Verifier d'abord si c'est un clic sur un item de la grille
	private _gridTarget = GVAR_UI("InventoryGridClickTarget", controlNull);
	private _gridItem = GVAR_UI("InventoryGridClickItem", []);

	diag_log format ["RightClick: gridTarget=%1, gridItem=%2", _gridTarget, _gridItem];

	if (!isNull _gridTarget && {!(_gridItem isEqualTo [])}) then {
		// C'est un clic sur un item de grille
		diag_log "RightClick: Grid item detected, processing...";
		SVAR_UI("InventoryGridClickTarget", controlNull);
		SVAR_UI("InventoryGridClickItem", []);

		if (_button isNotEqualTo 1) exitWith {
			diag_log format ["RightClick: Exiting due to button=%1 (not right click)", _button];
		};

		// Reset RightAction flag if stuck
		uiNamespace setVariable ["InventoryRightAction", false];

		if (GVAR_UI("InventoryTimeSpeed", 0) > time) exitWith {
			diag_log format ["RightClick: Exiting due to TimeSpeed=%1 > time=%2", GVAR_UI("InventoryTimeSpeed", 0), time];
		};
		SVAR_UI("InventoryTimeSpeed", time + 0.1);

		_gridItem params ["_classname", "_posX", "_posY", "_rotated", "_count"];

		// Determiner si c'est un item virtuel selon le filtre actuel
		private _isVirtual = _display getVariable ["grid_isVirtual", false];
		private _filterName = uiNamespace getVariable ["inventoryFilterName", "all"];

		// Cas special pour le cash
		private _actionType = if (_classname isEqualTo "cash") then {
			"cash"
		} else {
			if (_isVirtual) then {"virtual"} else {"item"}
		};

		diag_log format ["RightClick: Creating menu for %1, count=%2, actionType=%3, isVirtual=%4", _classname, _count, _actionType, _isVirtual];
		[[_xPos, _yPos], _classname, _count, _actionType, _filterName] call A3PL_InventoryNew_BuildContextMenu;
	} else {
		// Comportement original pour listbox et equipement
		private _target = GVAR_UI("InventoryClickTarget", controlNull);
		if (isNull _target) exitWith {
			// Ne pas clear si un menu vient d'etre cree (evite de fermer le menu des items de grille)
			if (GVAR_UI("InventoryTimeSpeed", 0) > time) exitWith {};
			[] call A3PL_InventoryNew_ClearRightClick;
		};
		SVAR_UI("InventoryClickTarget", controlNull);

		if ((_button isNotEqualTo 1) || {uiNamespace getVariable ["InventoryRightAction", false]}) exitWith {};

		if (GVAR_UI("InventoryTimeSpeed", 0) > time) exitWith {};
		SVAR_UI("InventoryTimeSpeed", time + 0.1);

		private ["_item", "_count", "_actionType"];
		private _filterName = uiNamespace getVariable ["inventoryFilterName", "all"];
		private _rowHeight = getNumber(missionConfigFile >> INVENTORY_DISPLAY_NAME >> "controls" >> (ctrlClassName _target) >> "rowHeight");

		if (_rowHeight isNotEqualTo 0) then {
			private _pos = ctrlPosition _target;
			private _hiddenRows = (lbSize _target) - (_pos#3 / _rowHeight);
			private _hiddenHeight = _hiddenRows * _rowHeight;
			private _clickPos = _yPos - (_pos#1) + (_hiddenHeight * ((ctrlScrollValues _target)#0));
			private _sel = floor((_clickPos / _rowHeight) + ((ctrlScrollValues _target)#0));

			if (_sel > (lbSize _target)) exitWith {
				_target lbSetCurSel -1;
			};
			if ((lbCurSel _target) isNotEqualTo _sel) then {
				_target lbSetCurSel _sel;
			};
			_item = _target lbData _sel;
			_count = _target lbValue _sel;

			// Verifier le type d'item selon le filtre actuel
			if (_filterName isEqualTo "keys") then {
				// C'est une cle
				_actionType = "key";
			} else {
			if (_filterName isEqualTo "licenses") then {
				// C'est une licence - pas d'actions disponibles
				_actionType = "license";
			} else {
				// Verifier si c'est un item virtuel (prefix "virtual:")
				if ((_item select [0, 8]) isEqualTo "virtual:") then {
					_item = _item select [8]; // Retirer le prefix
					_actionType = "virtual";
				} else {
					_actionType = "item";
				};
			};
			};
		} else {
			_item = _target getVariable "item";
			_count = 1;
			_actionType = "equipment";
		};

		if ((isNil "_item") || {isNil "_count"} || {_item isEqualTo ""} || {_count isEqualTo 0}) exitWith {};

		[[_xPos, _yPos], _item, _count, _actionType, _filterName] call A3PL_InventoryNew_BuildContextMenu;
	};
}] call compile_Global;

/*
	A3PL_InventoryNew_ClearRightClick
	Nettoie le menu contextuel
*/
["A3PL_InventoryNew_ClearRightClick", {
	private _ctrls = GVAR_UI("InventoryRightClickCtrls", []) + GVAR_UI("InventoryRightClickSubsCtrls", []);
	diag_log format ["ClearRightClick called, deleting %1 controls", count _ctrls];
	{
		ctrlDelete _x;
	} forEach _ctrls;

	SVAR_UI("InventoryRightClickCtrls", []);
	SVAR_UI("InventoryRightClickSubsCtrls", []);
}] call compile_Global;

/*
	A3PL_InventoryNew_MenuCreate
	Cree le menu contextuel avec les actions disponibles
	Params: [position, item, count, config]
*/
["A3PL_InventoryNew_MenuCreate", {
	private ["_idc", "_var"];

	disableSerialization;

	params [
		["_position", [0, 0], [[]], 2],
		["_item", "", [""]],
		["_count", 1, [0]],
		["_cfg", configNull, [configNull]]
	];

	diag_log format ["MenuCreate called: pos=%1, item=%2, count=%3, cfg=%4", _position, _item, _count, _cfg];

	if (isNull(_cfg) || {_item isEqualTo ""} || {_count isEqualTo 0}) exitWith {
		diag_log format ["MenuCreate: Exiting due to null cfg=%1, empty item=%2, or zero count=%3", isNull _cfg, _item isEqualTo "", _count isEqualTo 0];
	};

	private _xPos = _position#0;
	private _yPos = _position#1;
	private _len = 0.10313 * safezoneW;
	private _height = 0.0220073 * safezoneH;

	if ((configName _cfg) isEqualTo "subs") then {
		{ctrlDelete _x} forEach (uiNamespace getVariable ["InventoryRightClickSubsCtrls", []]);
		uiNamespace setVariable ["InventoryRightClickSubsCtrls", []];
		_idc = 8080;
		_var = "InventoryRightClickSubsCtrls";
	} else {
		{ctrlDelete _x} forEach (uiNamespace getVariable ["InventoryRightClickCtrls", []]);
		uiNamespace setVariable ["InventoryRightClickCtrls", []];
		_idc = 8050;
		_var = "InventoryRightClickCtrls";
	};

	private _first = controlNull;
	private _display = uiNamespace getVariable [INVENTORY_DISPLAY_NAME, displayNull];
	if (isNull _display) exitWith {};

	diag_log format ["MenuCreate: Processing %1 config classes", count ("true" configClasses _cfg)];
	{
		private _conditionText = getText(_x >> "condition");
		private _conditionResult = call compile _conditionText;
		diag_log format ["MenuCreate: Action %1, condition='%2', result=%3", configName _x, _conditionText, _conditionResult];
		if (_conditionResult) then {
			private _ctrl = _display ctrlCreate ["A3PL_Inv_RscButton", _idc];
			diag_log format ["MenuCreate: Created button for %1 at [%2, %3]", configName _x, _xPos, _yPos];
			_ctrl ctrlSetPosition [_xPos, _yPos, _len, _height];

			if (isNull _first) then {
				_first = _ctrl;
			};

			if (isClass(_x >> "subs")) then {
				_ctrl ctrlSetText format ["%1 ...", getText(_x >> "text")];
				_ctrl buttonSetAction format ["[[%4,%5],'%1',%2, missionConfigFile >> '%6' >> '%3' >> 'subs'] call A3PL_InventoryNew_MenuCreate;", _item, _count, configName _x, _xPos + _len, _yPos, configName _cfg];
			} else {
				_ctrl ctrlSetText getText(_x >> "text");
				_ctrl buttonSetAction format ["
					[] spawn {
						uiNamespace setVariable ['InventoryRightAction', true];
						[] call A3PL_InventoryNew_ClearRightClick;
						private _item = '%1';
						private _count = %2;
						%3;
						[] call A3PL_InventoryNew_Update;
						uiNamespace setVariable ['InventoryRightAction', false];
					};
				", _item, _count, getText(_x >> "code")];
			};

			_ctrl ctrlSetEventHandler ["MouseButtonDown", "if ((_this#1) isEqualTo 0) then {uiNamespace setVariable ['InventoryClickTarget', _this#0]}"];
			_ctrl ctrlCommit 0;
			uiNamespace setVariable [_var, (uiNamespace getVariable _var) + [_ctrl]];
			_yPos = _yPos + _height;
			_idc = _idc + 1;
		};
	} forEach ("true" configClasses _cfg);

	if (!isNull _first) then {
		ctrlSetFocus _first;
	};
}] call compile_Global;

// ============================================================================
// UI FUNCTIONS - Main Inventory Display
// ============================================================================

/*
	A3PL_InventoryNew_Update
	Met a jour l'affichage de l'inventaire
*/
["A3PL_InventoryNew_Update", {
	disableSerialization;
	private _display = uiNamespace getVariable [INVENTORY_DISPLAY_NAME, displayNull];
	if (isNull _display) exitWith {};

	// Liste equipements - utilise maintenant Inventory_Equipment hashmap
	{
		private _slotName = _x;
		private _slotData = [_slotName] call A3PL_InventoryNew_GetEquipmentSlot;
		if (!isNil "_slotData") then {
			_slotData params ["_codeFunc", "_icon", "_tooltip", "_descShort", "_buttonIDC", "_imageIDC"];
			private _item = call _codeFunc;
			if (isNil "_item") then { _item = ""; };

			// Traduire tooltip et descShort si ce sont des cles de localisation
			private _tooltipLocalized = if (_tooltip select [0, 4] == "STR_") then {_tooltip call A3PL_Localize} else {_tooltip};
			private _descShortLocalized = if (_descShort select [0, 4] == "STR_") then {_descShort call A3PL_Localize} else {_descShort};

			if (_item isEqualTo "") then {
				(_display displayCtrl _imageIDC) ctrlSetText _icon;
				(_display displayCtrl _buttonIDC) ctrlSetTooltip _tooltipLocalized;
				(_display displayCtrl _buttonIDC) ctrlEnable false;
			} else {
				private _info = [_item] call A3PL_InventoryNew_FetchItemInfo;

				(_display displayCtrl _imageIDC) ctrlSetText (_info#2);
				private _desc = if ((_info#3) isEqualTo "") then {
					_descShortLocalized
				} else {
					_info#3
				};
				(_display displayCtrl _buttonIDC) setVariable ["item", _item];
				(_display displayCtrl _buttonIDC) ctrlSetTooltip format ["%1\n%2", _info#1, _desc];
				(_display displayCtrl _buttonIDC) ctrlSetEventHandler [
					"MouseButtonDown",
					"if ((_this#1) isEqualTo 1) then {uiNamespace setVariable ['InventoryClickTarget', _this#0]}"
				];
				(_display displayCtrl _buttonIDC) ctrlSetEventHandler [
					"MouseButtonUp",
					"_this call A3PL_InventoryNew_RightClick"
				];
				(_display displayCtrl _buttonIDC) ctrlEnable true;
			};
		};
	} forEach ([] call A3PL_InventoryNew_GetEquipmentSlotsList);

	// Liste items
	private _inventory = _display displayCtrl INVENTORY_LIST_IDC;
	lbClear _inventory;

	// Utilise maintenant Inventory_Filters hashmap
	private _filterType = uiNamespace getVariable ["inventoryFilterName", "all"];
	private _filterData = [_filterType] call A3PL_InventoryNew_GetFilter;
	if (isNil "_filterData") then {
		_filterType = "all";
		_filterData = ["all"] call A3PL_InventoryNew_GetFilter;
	};

	// [iconDefault, iconFocus, condition, tooltip, itemsCode, fromCode, loadCode, isVirtual, isKeys, isLicenses]
	private _itemsRaw = call (_filterData#4);
	if (isNil "_itemsRaw") then { _itemsRaw = []; };
	private _items = _itemsRaw call A3PL_InventoryNew_FormatInv;
	if (isNil "_items" || {!(_items isEqualType [])}) then { _items = [[], []]; };
	private _search = ctrlText (_display displayCtrl INVENTORY_SEARCH_EDIT_IDC);

	// Items ArmA standard
	{
		private _info = [_x] call A3PL_InventoryNew_FetchItemInfo;
		if ((_search isEqualTo "") || {[_search, _info#1] call BIS_fnc_inString}) then {
			private _index = _inventory lbAdd (_info#1);
			_inventory lbSetData [_index, _x];
			_inventory lbSetValue [_index, (_items#1)#_forEachIndex];
			_inventory lbSetPicture [_index, _info#2];
			_inventory lbSetTextRight [_index, str((_items#1)#_forEachIndex)];
			_inventory lbSetTooltip [_index, _info#3];
		};
	} forEach (_items#0);

	// Si filtre "all", ajouter aussi les items virtuels
	if (_filterType isEqualTo "all") then {
		private _virtualInv = player getVariable ["player_inventory", []];
		{
			_x params ["_class", "_amount"];
			if (_amount > 0) then {
				private _info = [_class] call A3PL_InventoryNew_FetchVirtualItemInfo;
				private _displayName = _info#1;
				private _picture = _info#2;
				private _desc = _info#3;

				if ((_search isEqualTo "") || {[_search, _displayName] call BIS_fnc_inString}) then {
					private _index = _inventory lbAdd _displayName;
					_inventory lbSetData [_index, format ["virtual:%1", _class]]; // Prefix pour identifier items virtuels
					_inventory lbSetValue [_index, _amount];
					_inventory lbSetPicture [_index, _picture];
					_inventory lbSetTextRight [_index, str _amount];
					_inventory lbSetTooltip [_index, _desc];
				};
			};
		} forEach _virtualInv;
	};

	if ((lbSize _inventory) > 0) then {
		lbSort [_inventory, "ASC"];
	};

	_inventory lbSetCurSel -1;

	// Barre de charge - utilise maintenant loadCode du filtre
	private _load = call (_filterData#6);
	if (isNil "_load") then { _load = 0; };

	(_display displayCtrl INVENTORY_PROGRESS_BAR_IDC) progressSetPosition _load;
	(_display displayCtrl INVENTORY_PROGRESS_TITLE_IDC) ctrlSetText format ["%1%2", floor(_load * 100), "%"];

	// Filtres - utilise maintenant Inventory_FiltersOrder
	private _filterIDCs = [
		[INVENTORY_FILTER_1_IMAGE_IDC, INVENTORY_FILTER_1_BUTTON_IDC],
		[INVENTORY_FILTER_2_IMAGE_IDC, INVENTORY_FILTER_2_BUTTON_IDC],
		[INVENTORY_FILTER_3_IMAGE_IDC, INVENTORY_FILTER_3_BUTTON_IDC],
		[INVENTORY_FILTER_4_IMAGE_IDC, INVENTORY_FILTER_4_BUTTON_IDC],
		[INVENTORY_FILTER_5_IMAGE_IDC, INVENTORY_FILTER_5_BUTTON_IDC],
		[INVENTORY_FILTER_6_IMAGE_IDC, INVENTORY_FILTER_6_BUTTON_IDC],
		[INVENTORY_FILTER_7_IMAGE_IDC, INVENTORY_FILTER_7_BUTTON_IDC]
	];
	private _filterIndex = 0;
	private _filtersOrder = [] call A3PL_InventoryNew_GetFiltersList;

	{
		private _fName = _x;
		private _fData = [_fName] call A3PL_InventoryNew_GetFilter;

		if (!isNil "_fData" && {_filterIndex < count _filterIDCs}) then {
			private _idcPair = _filterIDCs#_filterIndex;
			private _ctrlPicture = _display displayCtrl (_idcPair#0);
			private _ctrlButton = _display displayCtrl (_idcPair#1);

			// [iconDefault, iconFocus, condition, tooltip, itemsCode, fromCode, loadCode, isVirtual, isKeys, isLicenses]
			if (call (_fData#2)) then {
				if (_filterType isEqualTo _fName) then {
					_ctrlPicture ctrlSetText (_fData#1);
				} else {
					_ctrlPicture ctrlSetText (_fData#0);
				};

				_ctrlButton buttonSetAction format [
					"uiNamespace setVariable ['inventoryFilterName', '%1']; [] call A3PL_InventoryNew_Update;",
					_fName
				];
				// Traduire le tooltip si c'est une cle de localisation
				private _tooltipText = _fData#3;
				if (_tooltipText select [0, 4] == "STR_") then {_tooltipText = _tooltipText call A3PL_Localize};
				_ctrlButton ctrlSetTooltip _tooltipText;

				_ctrlPicture ctrlShow true;
				_ctrlButton ctrlShow true;
			} else {
				_ctrlPicture ctrlShow false;
				_ctrlButton ctrlShow false;
			};

			_filterIndex = _filterIndex + 1;
		};
	} forEach _filtersOrder;

	// Cacher les filtres non utilises restants
	for "_i" from _filterIndex to ((count _filterIDCs) - 1) do {
		private _idcPair = _filterIDCs#_i;
		ctrlShow [_idcPair#0, false];
		ctrlShow [_idcPair#1, false];
	};

	// =========================================
	// INVENTORY RENDERING (LIST vs GRID)
	// =========================================

	// _filterType est deja defini plus haut comme string
	_display setVariable ["currentFilter", _filterType];

	// Recuperer les controles
	private _gridGroup = _display displayCtrl INVENTORY_GRID_GROUP_IDC;
	private _listBox = _display displayCtrl INVENTORY_LIST_IDC;

	// Si filtre "all" -> afficher liste, sinon afficher grille
	if (_filterType isEqualTo "all") then {
		// Mode LISTE pour "all items" (c'est un resume, pas un vrai conteneur)

		// Cacher la grille
		_gridGroup ctrlSetPosition [10 * safezoneW + safezoneX, 10 * safezoneH + safezoneY, 0, 0];
		_gridGroup ctrlCommit 0;

		// Afficher la listbox a la bonne position
		_listBox ctrlSetPosition [
			0.546406 * safezoneW + safezoneX,
			0.324 * safezoneH + safezoneY,
			0.216563 * safezoneW,
			0.385 * safezoneH
		];
		_listBox ctrlCommit 0;

		diag_log "A3PL_InventoryNew_Update: Mode LISTE pour filtre 'all'";
	} else {
		if (_filterType isEqualTo "virtual") then {
			// Mode GRILLE pour items virtuels

			// Verifier et migrer les items en overflow (joueur non-premium avec items premium)
			[] call A3PL_InventoryNew_MigrateVirtualOverflow;

			// Cacher la listbox
			_listBox ctrlSetPosition [10 * safezoneW + safezoneX, 10 * safezoneH + safezoneY, 0, 0];
			_listBox ctrlCommit 0;

			// Afficher la grille a la bonne position
			_gridGroup ctrlSetPosition [
				0.546406 * safezoneW + safezoneX,
				0.324 * safezoneH + safezoneY,
				0.216563 * safezoneW,
				0.385 * safezoneH
			];
			_gridGroup ctrlCommit 0;

			// Taille de grille selon statut premium (config dans Config_Inventory_Grid.sqf)
			private _gridSize = [] call A3PL_InventoryNew_GetVirtualGridSize;
			diag_log format ["A3PL_InventoryNew_Update: Virtual inventory, gridSize=%1", _gridSize];

			// Charger le layout sauvegarde
			private _savedLayout = [_filterType] call A3PL_InventoryNew_LoadGridLayout;

			// Convertir l'inventaire virtuel en grille
			private _grid = [_gridSize, _savedLayout] call A3PL_InventoryNew_VirtualInventoryToGrid;
			diag_log format ["A3PL_InventoryNew_Update: Virtual grid rows=%1", count _grid];

			// Afficher la grille (mode virtuel)
			[_display, _grid, _gridSize, true] call A3PL_InventoryNew_RenderGrid;
		} else {
		if (_filterType isEqualTo "keys") then {
			// Mode LISTE pour les cles

			// Cacher la grille
			_gridGroup ctrlSetPosition [10 * safezoneW + safezoneX, 10 * safezoneH + safezoneY, 0, 0];
			_gridGroup ctrlCommit 0;

			// Afficher la listbox a la bonne position
			_listBox ctrlSetPosition [
				0.546406 * safezoneW + safezoneX,
				0.324 * safezoneH + safezoneY,
				0.216563 * safezoneW,
				0.385 * safezoneH
			];
			_listBox ctrlCommit 0;

			// Ajouter le handler de clic droit pour la listbox
			_listBox ctrlSetEventHandler ["MouseButtonDown", "if ((_this#1) isEqualTo 1) then {uiNamespace setVariable ['InventoryClickTarget', _this#0]}"];

			// Recuperer les cles du joueur
			private _keys = [] call A3PL_InventoryNew_GetKeysItems;
			diag_log format ["A3PL_InventoryNew_Update: Keys filter, keys=%1", _keys];

			// Ajouter les cles a la listbox
			lbClear _listBox;
			{
				private _keyID = _x;
				private _displayName = [_keyID] call A3PL_InventoryNew_GetKeyDisplayName;
				private _index = _listBox lbAdd _displayName;
				_listBox lbSetData [_index, _keyID];
				_listBox lbSetValue [_index, 1];
				_listBox lbSetPicture [_index, "\A3PL_Common\GUI\inventory\UI_icons\ui_keys_gs_32_w.paa"];
			} forEach _keys;

			if (count _keys == 0) then {
				_listBox lbAdd "No keys";
			};

			diag_log "A3PL_InventoryNew_Update: Mode LISTE pour filtre 'keys'";
		} else {
		if (_filterType isEqualTo "licenses") then {
			// Mode LISTE pour les licences

			// Cacher la grille
			_gridGroup ctrlSetPosition [10 * safezoneW + safezoneX, 10 * safezoneH + safezoneY, 0, 0];
			_gridGroup ctrlCommit 0;

			// Afficher la listbox a la bonne position
			_listBox ctrlSetPosition [
				0.546406 * safezoneW + safezoneX,
				0.324 * safezoneH + safezoneY,
				0.216563 * safezoneW,
				0.385 * safezoneH
			];
			_listBox ctrlCommit 0;

			// Ajouter le handler de clic droit pour la listbox
			_listBox ctrlSetEventHandler ["MouseButtonDown", "if ((_this#1) isEqualTo 1) then {uiNamespace setVariable ['InventoryClickTarget', _this#0]}"];

			// Recuperer les licences du joueur
			private _licenses = [] call A3PL_InventoryNew_GetLicensesItems;
			diag_log format ["A3PL_InventoryNew_Update: Licenses filter, licenses=%1", _licenses];

			// Ajouter les licences a la listbox (meme methode que l'ancien inventaire)
			lbClear _listBox;
			{
				private _licenseClass = _x;
				private _displayName = [_licenseClass, 0] call A3PL_Config_GetLicenseData;
				private _index = _listBox lbAdd _displayName;
				_listBox lbSetData [_index, _licenseClass];
				_listBox lbSetValue [_index, 1];
				_listBox lbSetPicture [_index, "\A3PL_Common\GUI\inventory\UI_icons\ui_licenses_gs_32_w.paa"];
			} forEach _licenses;

			if (count _licenses == 0) then {
				_listBox lbAdd ("STR_A3PL_Inventory_NoLicenses" call A3PL_Localize);
			};

			diag_log "A3PL_InventoryNew_Update: Mode LISTE pour filtre 'licenses'";
		} else {
			// Mode GRILLE pour uniform/vest/backpack

			// Cacher la listbox
			_listBox ctrlSetPosition [10 * safezoneW + safezoneX, 10 * safezoneH + safezoneY, 0, 0];
			_listBox ctrlCommit 0;

			// Afficher la grille a la bonne position
			_gridGroup ctrlSetPosition [
				0.546406 * safezoneW + safezoneX,
				0.324 * safezoneH + safezoneY,
				0.216563 * safezoneW,
				0.385 * safezoneH
			];
			_gridGroup ctrlCommit 0;

			// Obtenir le conteneur approprie selon le filtre
			private _containerClass = switch (_filterType) do {
				case "uniform": { uniform player };
				case "vest": { vest player };
				case "backpack": { backpack player };
				default { "" };
			};

			// Obtenir la taille de grille pour ce conteneur
			private _gridSize = [_containerClass] call A3PL_InventoryNew_GetContainerGridSize;
			diag_log format ["A3PL_InventoryNew_Update: containerClass=%1, gridSize=%2", _containerClass, _gridSize];

			// Charger le layout sauvegarde
			private _savedLayout = [_filterType] call A3PL_InventoryNew_LoadGridLayout;

			// Convertir l'inventaire en grille
			private _grid = [_gridSize, _items, _savedLayout] call A3PL_InventoryNew_InventoryToGrid;
			diag_log format ["A3PL_InventoryNew_Update: items count=%1, grid rows=%2", count (_items#0), count _grid];

			// Afficher la grille
			[_display, _grid, _gridSize, false] call A3PL_InventoryNew_RenderGrid;
		};
		};
		};
	};
}] call compile_Global;

/*
	A3PL_InventoryNew_Open
	Ouvre le dialog d'inventaire
	Params: display
*/
["A3PL_InventoryNew_Open", {
	disableSerialization;

	if (isNull _this) exitWith {};

	SVAR_UI(INVENTORY_DISPLAY_NAME, _this);
	SVAR_UI("inventoryFilterName", "all");
	SVAR_UI("InventoryTimeSpeed", 0);

	// Initialiser les variables de grille
	_this setVariable ["grid_isDragging", false];
	_this setVariable ["grid_dragItem", []];
	_this setVariable ["grid_dragRotated", false];
	_this setVariable ["grid_hoverCell", controlNull];
	_this setVariable ["currentGrid", []];
	_this setVariable ["currentGridSize", [5, 4]];
	_this setVariable ["currentFilter", "all"];

	// Initialiser les grilles des conteneurs physiques si pas encore fait
	[] call A3PL_InventoryNew_InitContainerGrids;

	// Cacher le tooltip et drag picture au demarrage
	private _tooltip = _this displayCtrl INVENTORY_GRID_TOOLTIP_IDC;
	if (!isNull _tooltip) then {
		_tooltip ctrlShow false;
		_tooltip ctrlSetPosition [0, 0, 0, 0];
		_tooltip ctrlCommit 0;
	};

	private _dragPic = _this displayCtrl INVENTORY_GRID_DRAG_PICTURE_IDC;
	if (!isNull _dragPic) then {
		_dragPic ctrlShow false;
		_dragPic ctrlSetPosition [0, 0, 0, 0];
		_dragPic ctrlCommit 0;
	};

	[] call A3PL_InventoryNew_Update;

	private _search = _this displayCtrl INVENTORY_SEARCH_EDIT_IDC;
	_search ctrlSetEventHandler ["KeyDown", "[] call A3PL_InventoryNew_Update;"];

	// Event pour la rotation (touche R) pendant le drag
	_this displayAddEventHandler ["KeyDown", {
		params ["_display", "_key", "_shift", "_ctrl", "_alt"];
		// R key = 19
		if (_key isEqualTo 19) then {
			private _isDragging = _display getVariable ["grid_isDragging", false];
			if (_isDragging) then {
				private _fnc = missionNamespace getVariable ["A3PL_InventoryNew_GridRotateItem", {}];
				[_display] call _fnc;
				true // Consume l'event
			} else {
				false
			};
		} else {
			false
		};
	}];

	// Event pour annuler le drag avec Escape
	_this displayAddEventHandler ["KeyDown", {
		params ["_display", "_key"];
		// Escape = 1
		if (_key isEqualTo 1) then {
			private _isDragging = _display getVariable ["grid_isDragging", false];
			if (_isDragging) then {
				private _cancelFnc = missionNamespace getVariable ["A3PL_InventoryNew_GridCancelDrag", {}];
				[_display] call _cancelFnc;
				// Re-rendre la grille pour restaurer l'item
				private _grid = _display getVariable ["currentGrid", []];
				private _gridSize = _display getVariable ["currentGridSize", [5, 4]];
				private _isVirtual = _display getVariable ["grid_isVirtual", false];
				if !(_grid isEqualTo []) then {
					private _renderFnc = missionNamespace getVariable ["A3PL_InventoryNew_RenderGrid", {}];
					[_display, _grid, _gridSize, _isVirtual] call _renderFnc;
				};
				true
			} else {
				false
			};
		} else {
			false
		};
	}];

	// Event global MouseButtonUp pour gerer le drop
	_this displayAddEventHandler ["MouseButtonUp", {
		params ["_display", "_button"];
		if (_button isEqualTo 0) then {
			private _isDragging = _display getVariable ["grid_isDragging", false];
			if (_isDragging) then {
				// Ignorer le MouseButtonUp si le drag vient juste de demarrer (meme clic)
				private _justStarted = _display getVariable ["grid_dragJustStarted", false];
				if (_justStarted) exitWith {
					_display setVariable ["grid_dragJustStarted", false];
					diag_log "MouseButtonUp: ignored because drag just started";
				};

				// Verifier si on est sur une cellule valide
				private _hoverCell = _display getVariable ["grid_hoverCell", controlNull];

				if (!isNull _hoverCell) then {
					// Drop sur la cellule
					private _dropFnc = missionNamespace getVariable ["A3PL_InventoryNew_GridDropItem", {}];
					[_display, _hoverCell] call _dropFnc;
				} else {
					// Annuler le drag et remettre l'item a sa place
					private _cancelFnc = missionNamespace getVariable ["A3PL_InventoryNew_GridCancelDrag", {}];
					[_display] call _cancelFnc;
					// Re-rendre la grille pour restaurer l'item
					private _grid = _display getVariable ["currentGrid", []];
					private _gridSize = _display getVariable ["currentGridSize", [5, 4]];
					private _isVirtual = _display getVariable ["grid_isVirtual", false];
					if !(_grid isEqualTo []) then {
						private _renderFnc = missionNamespace getVariable ["A3PL_InventoryNew_RenderGrid", {}];
						[_display, _grid, _gridSize, _isVirtual] call _renderFnc;
					};
				};
			};
		};
	}];

	// Appliquer les traductions des titres du dialog
	private _inventoryTitle = _this displayCtrl INVENTORY_TITLE_IDC;
	if (!isNull _inventoryTitle) then {
		_inventoryTitle ctrlSetText ("STR_A3PL_Inventory_DialogTitle" call A3PL_Localize);
	};
	private _equipmentTitle = _this displayCtrl EQUIPMENT_TITLE_IDC;
	if (!isNull _equipmentTitle) then {
		_equipmentTitle ctrlSetText ("STR_A3PL_Inventory_DialogEquipment" call A3PL_Localize);
	};

	// Afficher le playtime et premium
	[_this] call A3PL_InventoryNew_UpdatePlayerInfo;
}] call compile_Global;

/*
	A3PL_InventoryNew_UpdatePlayerInfo
	Met a jour l'affichage du playtime et du premium
	Utilise les memes strings que l'ancien inventaire
*/
["A3PL_InventoryNew_UpdatePlayerInfo", {
	disableSerialization;
	params [["_display", displayNull, [displayNull]]];

	if (isNull _display) then {
		_display = findDisplay INVENTORY_DISPLAY_IDD;
	};
	if (isNull _display) exitWith {};

	// === Playtime ===
	private _playtimeCtrl = _display displayCtrl INVENTORY_PLAYTIME_IDC;
	if (!isNull _playtimeCtrl) then {
		private _playTime = Player_PlayTime;

		if (_playTime == 0) then {
			_playtimeCtrl ctrlSetStructuredText parseText format["STR_A3PL_Inventory_PlaytimeNone" call A3PL_Localize, _playTime];
		} else {
			private _months = floor(_playTime / (60 * 24 * 30));
			private _days = floor((_playTime % (60 * 24 * 30)) / (60 * 24));
			private _hours = floor((_playTime % (60 * 24)) / 60);
			private _minutes = _playTime % 60;

			private _timeString = "";

			if (_months > 0) then {
				_timeString = format["STR_A3PL_Inventory_Months" call A3PL_Localize, _months];
			};
			if (_days > 0) then {
				if (_timeString != "") then {
					_timeString = format["STR_A3PL_Inventory_Days" call A3PL_Localize, _timeString, _days, if (_days > 1) then {"s"} else {""}];
				} else {
					_timeString = format["STR_A3PL_Inventory_Day" call A3PL_Localize, _days, if (_days > 1) then {"s"} else {""}];
				};
			};
			if (_hours > 0) then {
				if (_timeString != "") then {
					_timeString = format["STR_A3PL_Inventory_Hours" call A3PL_Localize, _timeString, _hours, if (_hours > 1) then {"s"} else {""}];
				} else {
					_timeString = format["STR_A3PL_Inventory_Hour" call A3PL_Localize, _hours, if (_hours > 1) then {"s"} else {""}];
				};
			};
			if (_minutes > 0) then {
				if (_timeString != "") then {
					_timeString = format["STR_A3PL_Inventory_Minutes" call A3PL_Localize, _timeString, _minutes, if (_minutes > 1) then {"s"} else {""}];
				} else {
					_timeString = format["STR_A3PL_Inventory_Minute" call A3PL_Localize, _minutes, if (_minutes > 1) then {"s"} else {""}];
				};
			};

			_playtimeCtrl ctrlSetStructuredText parseText format["STR_A3PL_Inventory_Playtime" call A3PL_Localize, _timeString];
		};
	};

	// === Premium Days ===
	private _premiumCtrl = _display displayCtrl INVENTORY_PREMIUM_IDC;
	if (!isNull _premiumCtrl) then {
		private _perkDay = player getVariable ["Player_PerkDay", 0];

		if (_perkDay > 15) then {
			_premiumCtrl ctrlSetStructuredText parseText format["STR_A3PL_Inventory_DaysGreen" call A3PL_Localize, _perkDay];
		} else {
			if (_perkDay <= 15 && _perkDay > 3) then {
				_premiumCtrl ctrlSetStructuredText parseText format["STR_A3PL_Inventory_DaysYellow" call A3PL_Localize, _perkDay];
			};
			if (_perkDay <= 3 && _perkDay > 1) then {
				_premiumCtrl ctrlSetStructuredText parseText format["STR_A3PL_Inventory_DaysRed" call A3PL_Localize, _perkDay];
			};
			if (_perkDay == 1) then {
				_premiumCtrl ctrlSetStructuredText parseText format["STR_A3PL_Inventory_DayRed" call A3PL_Localize, _perkDay];
			};
			if (_perkDay == 0) then {
				_premiumCtrl ctrlSetStructuredText parseText format["STR_A3PL_Inventory_NoPremium" call A3PL_Localize];
			};
		};
	};
}] call compile_Global;

/*
	A3PL_InventoryNew_CharacterUpdate
	Fonction desactivee - elements UI supprimes
*/
["A3PL_InventoryNew_CharacterUpdate", {
	// Fonction vide - elements de personnage supprimes de l'UI
}] call compile_Global;

// ============================================================================
// UI FUNCTIONS - Transfer Menu
// ============================================================================

/*
	A3PL_InventoryNew_TransferMenuUpdateLists
	Met a jour les listes du menu de transfert
*/
["A3PL_InventoryNew_TransferMenuUpdateLists", {
	disableSerialization;
	private _display = findDisplay TRANSFER_DISPLAY_IDD;
	if (isNull _display) exitWith {};

	(_display getVariable ["params", []]) params [
		["_target", objNull, [objNull]],
		["_variable", "", [""]],
		["_title", "", [""]],
		["_options", [], [[]]]
	];

	_options params [
		["_canStore", true, [true]],
		["_canTake", true, [true]],
		["_deleteOnEmpty", false, [false]],
		["_hideNotAllowed", false, [false]]
	];

	// Inventaire joueur
	(_display displayCtrl TRANSFER_PLAYER_PROGRESS_INFO_IDC) ctrlSetText format [
		"%2%1 (%3/%4lb)",
		"%",
		((player call A3PL_InventoryNew_GetUnitContainerLoad) * 100) toFixed 2,
		player call A3PL_InventoryNew_GetUnitContainerLoadAbs,
		player call A3PL_InventoryNew_GetUnitContainerMaxLoad
	];

	(_display displayCtrl TRANSFER_PLAYER_PROGRESSBAR_IDC) progressSetPosition (player call A3PL_InventoryNew_GetUnitContainerLoad);

	[_display displayCtrl TRANSFER_PLAYER_INVENTORY_LIST_IDC, (
		(uniformItems player) +
		(vestItems player) +
		(backpackItems player) +
		(assignedItems player) +
		[
			primaryWeapon player,
			secondaryWeapon player,
			handgunWeapon player,
			headgear player,
			goggles player,
			vest player,
			backpack player,
			uniform player
		]
	) call A3PL_InventoryNew_FormatInv] call A3PL_InventoryNew_FillCtrlList;

	// Inventaire cible
	private _ctrl_target = _display displayCtrl TRANSFER_TARGET_INVENTORY_LIST_IDC;

	if (_hideNotAllowed && {!_canTake}) then {
		lbClear _ctrl_target;
		_ctrl_target lbAdd ("STR_A3PL_Inventory_Denied" call A3PL_Localize);
	} else {
		// GroundWeaponHolder utilise la variable GroundCargo
		// Les vehicules (Car, Air, Ship) et Box_GEN_Equip_F utilisent le systeme cargo vanilla
		// Tous les autres utilisent la variable passee en parametre (ex: "cargo")
		private _targetItems = [];
		private _isVehicleCargo = (_target isKindOf "Car" || _target isKindOf "Air" || _target isKindOf "Ship" || (typeOf _target) isEqualTo "Box_GEN_Equip_F" || (typeOf _target) isEqualTo "A3PL_EMS_Locker" || (typeOf _target) isEqualTo "B_supplyCrate_F" || (typeOf _target) isEqualTo "GroundWeaponHolder" || (typeOf _target) isEqualTo "GroundWeaponHolder");

		if (_isVehicleCargo) then {
				// Pour les vehicules, recuperer le contenu du cargo vanilla
				private _items = [];
				private _counts = [];

				// Items du cargo
				{
					private _idx = _items find _x;
					if (_idx == -1) then {
						_items pushBack _x;
						_counts pushBack 1;
					} else {
						_counts set [_idx, (_counts#_idx) + 1];
					};
				} forEach (itemCargo _target);

				// Armes du cargo
				{
					private _idx = _items find _x;
					if (_idx == -1) then {
						_items pushBack _x;
						_counts pushBack 1;
					} else {
						_counts set [_idx, (_counts#_idx) + 1];
					};
				} forEach (weaponCargo _target);

				// Magazines du cargo
				{
					private _idx = _items find _x;
					if (_idx == -1) then {
						_items pushBack _x;
						_counts pushBack 1;
					} else {
						_counts set [_idx, (_counts#_idx) + 1];
					};
				} forEach (magazineCargo _target);

				// Sacs a dos du cargo
				{
					private _idx = _items find _x;
					if (_idx == -1) then {
						_items pushBack _x;
						_counts pushBack 1;
					} else {
						_counts set [_idx, (_counts#_idx) + 1];
					};
				} forEach (backpackCargo _target);

				_targetItems = [_items, _counts];
			} else {
				_targetItems = _target getVariable [_variable, [[], []]];
			};
		[_ctrl_target, _targetItems] call A3PL_InventoryNew_FillCtrlList;
	};

	if (((lbSize _ctrl_target) isEqualTo 0) && {_deleteOnEmpty}) exitWith {
		deleteVehicle _target;
		closeDialog 0;
	};

	(_display displayCtrl TRANSFER_TARGET_PROGRESS_INFO_IDC) ctrlSetText format [
		"%2%1 (%3/%4lb)",
		"%",
		(([_target, _variable] call A3PL_InventoryNew_GetCargoLoad) * 100) toFixed 2,
		[_target, _variable] call A3PL_InventoryNew_GetCargoLoadAbs,
		[_target, _variable] call A3PL_InventoryNew_GetCargoMaxLoad
	];

	(_display displayCtrl TRANSFER_TARGET_PROGRESSBAR_IDC) progressSetPosition ([_target, _variable] call A3PL_InventoryNew_GetCargoLoad);
}] call compile_Global;

/*
	A3PL_InventoryNew_TransferMenuOpen
	Ouvre le menu de transfert d'items
	Params: [target, variable, title, options, callbacks]
*/
["A3PL_InventoryNew_TransferMenuOpen", {
	if (!canSuspend) exitWith {
		diag_log "A3PL_InventoryNew_TransferMenuOpen: Functions must be handled by the Scheduler";
	};

	params [
		["_target", objNull, [objNull]],
		["_variable", "", [""]],
		["_title", "", [""]],
		["_options", [], [[]]],
		["_callBacks", [], [[]]]
	];

	_options params [
		["_canStore", true, [true]],
		["_canTake", true, [true]],
		["_deleteOnEmpty", false, [false]],
		["_hideNotAllowed", false, [false]],
		["_skipAnimation", false, [false]]
	];

	_callBacks params [
		["_onOpen", "", [""]],
		["_onClose", "", [""]]
	];

	if (isNull _target) exitWith {
		diag_log "TransferMenuOpen: EXIT - target is null";
	};

	// Verifier si le joueur est dans le vehicule cible
	private _playerInTargetVehicle = (vehicle player) isEqualTo _target && {_target isNotEqualTo player};

	private _distance = player distance _target;
	if (_distance > 3 && {!_playerInTargetVehicle}) exitWith {
		diag_log format ["TransferMenuOpen: EXIT - distance too far (%1m > 3m)", _distance];
	};

	if (Player_ObjIntersect isNotEqualTo _target && {!_playerInTargetVehicle}) exitWith {
		diag_log "TransferMenuOpen: EXIT - player not looking at target";
	};

	private _isGroundHolder = (typeOf _target) isEqualTo "GroundWeaponHolder";
	private _isVehicleType = (_target isKindOf "Car" || _target isKindOf "Air" || _target isKindOf "Ship");

	diag_log format ["TransferMenuOpen: target=%1, type=%2, isGroundHolder=%3, isVehicle=%4", _target, typeOf _target, _isGroundHolder, _isVehicleType];

	if (!_isGroundHolder && !_isVehicleType && {(isNil {_target getVariable _variable}) && {([_target, _variable] call A3PL_InventoryNew_GetCargoMaxLoad) isEqualTo 0}}) exitWith {
		diag_log "TransferMenuOpen: EXIT - target invalid (no cargo var and maxLoad=0)";
		["STR_A3PL_Inventory_ErrTargetInvalid" call A3PL_Localize, Color_Red] call A3PL_Notification;
	};

	private _inUse = _target getVariable [format ["%1_inUse", _variable], ""];
	if ((_inUse isNotEqualTo "")
		&& !(_inUse isEqualTo (getPlayerUID player))
		&& {(({(getPlayerUID _x) isEqualTo _inUse} count allPlayers) > 0)}) exitWith {
		["STR_A3PL_Inventory_ErrAlreadyInUse" call A3PL_Localize, Color_Red] call A3PL_Notification;
	};

	if (dialog) then {closeDialog 0};

	private _distanceMax = 3;

	_inUse = _target getVariable [format ["%1_inUse", _variable], ""];
	if ((_inUse isNotEqualTo "")
		&& {!(_inUse isEqualTo (getPlayerUID player))}
		&& {(({(getPlayerUID _x) isEqualTo _inUse} count allPlayers) > 0)}) exitWith {
		["STR_A3PL_Inventory_ErrAlreadyInUse" call A3PL_Localize, Color_Red] call A3PL_Notification;
	};

	_target setVariable [format ["%1_inUse", _variable], getPlayerUID player, true];

	diag_log "TransferMenuOpen: Creating dialog...";
	createDialog TRANSFER_DISPLAY_NAME;
	private _display = findDisplay TRANSFER_DISPLAY_IDD;
	diag_log format ["TransferMenuOpen: Dialog created, display=%1, isNull=%2", _display, isNull _display];
	if (isNull _display) exitWith {
		diag_log "TransferMenuOpen: EXIT - display is null after createDialog";
	};

	private _targetHeader = _display displayCtrl TRANSFER_TARGET_HEADER_IDC;
	if (!isNull _targetHeader) then {
		if (_title isNotEqualTo "") then {
			_targetHeader ctrlSetText _title;
		} else {
			_targetHeader ctrlSetText ("STR_A3PL_Inventory_TransferTarget" call A3PL_Localize);
		};
	};
	private _playerHeader = _display displayCtrl TRANSFER_PLAYER_HEADER_IDC;
	if (!isNull _playerHeader) then {
		_playerHeader ctrlSetText ("STR_A3PL_Inventory_TransferYou" call A3PL_Localize);
	};
	private _tooltip = _display displayCtrl TRANSFER_TOOLTIP_IDC;
	if (!isNull _tooltip) then {
		private _text = format [
			"%1\n%2",
			"STR_A3PL_Inventory_TransferDragHint" call A3PL_Localize,
			"STR_A3PL_Inventory_TransferDoubleClickHint" call A3PL_Localize
		];
		_tooltip ctrlSetText _text;
	};

	_display setVariable ["params", _this];


	[] call A3PL_InventoryNew_TransferMenuUpdateLists;

	if (_onOpen isNotEqualTo "") then {call compile _onOpen};

	diag_log format ["TransferMenuOpen: Entering while loop, display exists=%1", !isNull(findDisplay TRANSFER_DISPLAY_IDD)];

	while {!isNull(findDisplay TRANSFER_DISPLAY_IDD)} do {
		private _currentDisplay = findDisplay TRANSFER_DISPLAY_IDD;
		private _currentParams = _currentDisplay getVariable ["params", []];
		private _currentTarget = if (count _currentParams > 0) then {_currentParams#0} else {_target};

		if ((isNull _currentTarget) || {!(player isKindOf "Man") && {!(alive _currentTarget)}}) exitWith {
			closeDialog 0;
		};

		// Verifier si le joueur est dans le vehicule cible
		private _inTargetVehicle = (vehicle player) isEqualTo _currentTarget && {_currentTarget isNotEqualTo player};

		private _dist = player distance _currentTarget;
		if (_dist > _distanceMax && {!_inTargetVehicle}) exitWith {
			closeDialog 0;
		};

		private _currentIsGWH = (typeOf _currentTarget) isEqualTo "GroundWeaponHolder";
		if (!_currentIsGWH && {!_inTargetVehicle} && {Player_ObjIntersect isNotEqualTo _currentTarget}) exitWith {
			closeDialog 0;
		};

		private _inUseVar = _currentTarget getVariable [format ["%1_inUse", _variable], ""];
		private _myUID = getPlayerUID player;
		if (_inUseVar isNotEqualTo _myUID) exitWith {
			closeDialog 0;
		};

		uiSleep 0.5;
	};

	private _finalDisplay = findDisplay TRANSFER_DISPLAY_IDD;
	private _finalParams = _finalDisplay getVariable ["params", []];
	private _finalTarget = if (count _finalParams > 0) then {_finalParams#0} else {_target};
	_finalTarget setVariable [format ["%1_inUse", _variable], nil, true];

	if (_onClose isNotEqualTo "") then {call compile _onClose};
}] call compile_Global;

/*
	A3PL_InventoryNew_TransferMenuOnLbDropTarget
	Gere le drop d'items vers la cible
	Params: [control, xPos, yPos, listboxIDC, listboxInfo]
*/
["A3PL_InventoryNew_TransferMenuOnLbDropTarget", {
	disableSerialization;

	params ["_control", "_xPos", "_yPos", "_listboxIDC", "_listboxInfo"];

	if (_listboxIDC isNotEqualTo TRANSFER_PLAYER_INVENTORY_LIST_IDC) exitWith {};

	private _display = findDisplay TRANSFER_DISPLAY_IDD;
	if (isNull(_display) || {_display getVariable ["busy", false]}) exitWith {};

	_display setVariable ["busy", true];

	(_display getVariable ["params", []]) params [
		["_target", objNull, [objNull]],
		["_variable", "", [""]],
		["_title", "", [""]],
		["_options", [], [[]]]
	];

	_options params [
		["_canStore", true, [true]]
	];

	if (!_canStore) exitWith {
		_display setVariable ["busy", false];
	};

	private _items = [];

	{
		private _count = _x#1;
		private _item = _x#2;

		if ((_item isNotEqualTo "") && {[_target, _variable, _item] call A3PL_InventoryNew_CargoIsItemAllowed}) then {
			private _equipmentItems = [_item] call A3PL_InventoryNew_EquipmentItems;
			private _notAllowedItems = _equipmentItems select {!([_target, _variable, _x] call A3PL_InventoryNew_CargoIsItemAllowed)};

			_equipmentItems = _equipmentItems - _notAllowedItems;

			while {
				private _testItems = [];
				for "_i" from 1 to _count do {
					_testItems pushBack _item;
				};

				(_count > 0) && {!([_target, _variable, _testItems + _equipmentItems] call A3PL_InventoryNew_CanAddItemsCargo)}
			} do {
				_count = _count - 1;
			};

			if (_count > 0) then {
				if ([false, _item] call A3PL_InventoryNew_HandleEquip) then {
					_count = _count - 1;
					_items = _items + _equipmentItems + [_item];

					{
						[_x, 1] call A3PL_InventoryNew_ForceAddItem;
					} forEach _notAllowedItems;
				};
				if ((_count > 0) && {[false, _item, _count] call A3PL_InventoryNew_HandleItem}) then {
					for "_i" from 1 to _count do {
						_items pushBack _item;
					};
					[] call A3PL_InventoryNew_SyncAllContainerGrids;
				};
			};
		};
	} forEach _listboxInfo;

	[_target, _variable, _items call A3PL_InventoryNew_FormatInv] call A3PL_InventoryNew_AddItemsCargo;
	_display setVariable ["busy", false];

	[] call A3PL_InventoryNew_TransferMenuUpdateLists;
}] call compile_Global;

/*
	A3PL_InventoryNew_TransferMenuOnLbDropPlayer
	Gere le drop d'items vers le joueur
	Params: [control, xPos, yPos, listboxIDC, listboxInfo]
*/
["A3PL_InventoryNew_TransferMenuOnLbDropPlayer", {
	disableSerialization;

	params ["_control", "_xPos", "_yPos", "_listboxIDC", "_listboxInfo"];

	if (_listboxIDC isNotEqualTo TRANSFER_TARGET_INVENTORY_LIST_IDC) exitWith {};

	private _display = findDisplay TRANSFER_DISPLAY_IDD;
	if (isNull(_display) || {_display getVariable ["busy", false]}) exitWith {};

	_display setVariable ["busy", true];

	(_display getVariable ["params", []]) params [
		["_target", objNull, [objNull]],
		["_variable", "", [""]],
		["_title", "", [""]],
		["_options", [], [[]]]
	];

	_options params [
		["_canStore", true, [true]],
		["_canTake", true, [true]]
	];

	if (!_canTake) exitWith {
		_display setVariable ["busy", false];
	};

	{
		private _count = _x#1;
		private _item = _x#2;

		if (_item isNotEqualTo "") then {
			private _canAddResult = [_item, _count] call A3PL_InventoryNew_CanAddItemPhysical;
			private _canAddToGrid = _canAddResult#0;
			private _targetContainer = _canAddResult#1;

			if (!_canAddToGrid) then {
				while {(_count > 0) && {!(([_item, _count] call A3PL_InventoryNew_CanAddItemPhysical)#0)}} do {
					_count = _count - 1;
				};
				_canAddResult = [_item, _count] call A3PL_InventoryNew_CanAddItemPhysical;
				_canAddToGrid = _canAddResult#0;
				_targetContainer = _canAddResult#1;
			};

			if ((_count < (_x#1)) && {[_item] call A3PL_InventoryNew_CanEquipItem}) then {
				_count = _count + 1;
			};

			private _equipped = false;
			if ((_count > 0) && {[_target, _variable, _item, _count] call A3PL_InventoryNew_RemoveItemCargo}) then {
				if ([true, _item] call A3PL_InventoryNew_HandleEquip) then {
					_count = _count - 1;
					_equipped = true;
				};
				if (_count > 0) then {
					// Verifier si on peut ajouter a l'inventaire
					if (_canAddToGrid && {_targetContainer isNotEqualTo ""}) then {
						[_item, _count, _targetContainer] call A3PL_InventoryNew_AddItemToContainerGrid;
						[true, _item, _count] call A3PL_InventoryNew_HandleItem;
					} else {
						// Pas de place - remettre dans le conteneur source
						[_target, _variable, [[_item, _count]] call A3PL_InventoryNew_FormatInv] call A3PL_InventoryNew_AddItemsCargo;
						["STR_A3PL_Inventory_NotEnoughGridSpace" call A3PL_Localize, Color_Red] call A3PL_Notification;
					};
				};
				[_item] call A3PL_InventoryNew_HandleMeleeWeaponMagazine;

				// Restaurer le contenu d'un uniforme/gilet si present
				if (_equipped) then {
					private _containerContent = _target getVariable ["A3PL_ContainerContent", []];
					if (count _containerContent > 0) then {
						_containerContent params ["_storedItem", "_containerType", "_storedItems"];

						if (_storedItem isEqualTo _item) then {
							diag_log format ["Restoring container content via drag: type=%1, items=%2", _containerType, _storedItems];

							{
								switch (_containerType) do {
									case "uniform": {
										if (player canAddItemToUniform _x) then {
											player addItemToUniform _x;
										} else {
											if (player canAdd _x) then {
												player addItem _x;
											} else {
												[getPosATL player, _x, 1] call A3PL_InventoryNew_AddItemGround;
											};
										};
									};
									case "vest": {
										if (player canAddItemToVest _x) then {
											player addItemToVest _x;
										} else {
											if (player canAdd _x) then {
												player addItem _x;
											} else {
												[getPosATL player, _x, 1] call A3PL_InventoryNew_AddItemGround;
											};
										};
									};
									case "backpack": {
										if (player canAddItemToBackpack _x) then {
											player addItemToBackpack _x;
										} else {
											if (player canAdd _x) then {
												player addItem _x;
											} else {
												[getPosATL player, _x, 1] call A3PL_InventoryNew_AddItemGround;
											};
										};
									};
								};
							} forEach _storedItems;

							_target setVariable ["A3PL_ContainerContent", nil, true];
						};
					};
				};
			};
		};
	} forEach _listboxInfo;

	_display setVariable ["busy", false];
	[] call A3PL_InventoryNew_TransferMenuUpdateLists;
}] call compile_Global;

/*
	A3PL_InventoryNew_HandleMeleeWeaponMagazine
	Ajoute le magazine pour les armes de melee (reproduit la logique de l'EVH "Take")
	Params: itemClass (string)
*/
["A3PL_InventoryNew_HandleMeleeWeaponMagazine", {
	params [["_itemClass", "", [""]]];

	if (_itemClass isEqualTo "A3PL_Shovel") exitWith {
		player removeMagazines "A3PL_ShovelMag";
		player addMagazine "A3PL_ShovelMag";
	};
	if (_itemClass isEqualTo "A3PL_Pickaxe") exitWith {
		player removeMagazines "A3PL_PickAxeMag";
		player addMagazine "A3PL_PickAxeMag";
	};
	if (_itemClass isEqualTo "A3PL_Jaws") exitWith {
		player removeMagazines "A3PL_FireAxeMag";
		player addMagazine "A3PL_FireAxeMag";
	};
	if (_itemClass isEqualTo "A3PL_FireAxe") exitWith {
		player removeMagazines "A3PL_FireAxeMag";
		player addMagazine "A3PL_FireAxeMag";
	};
	if (_itemClass isEqualTo "A3PL_Scythe") exitWith {
		player removeMagazines "A3PL_ScytheMag";
		player addMagazine "A3PL_ScytheMag";
	};
	if (_itemClass isEqualTo "A3FL_GolfDriver") exitWith {
		player removeMagazines "A3FL_GolfDriverMag";
		player addMagazine "A3FL_GolfDriverMag";
	};
	if (_itemClass isEqualTo "A3FL_BaseballBat" || {_itemClass isEqualTo "A3FL_BaseballBatGold"}) exitWith {
		player removeMagazines "A3FL_BaseballBatMag";
		player addMagazine "A3FL_BaseballBatMag";
	};
	if (_itemClass isEqualTo "A3FL_PoliceBaton") exitWith {
		player removeMagazines "A3FL_PoliceBatonMag";
		player addMagazine "A3FL_PoliceBatonMag";
	};
	if (_itemClass isEqualTo "A3FL_DickStick") exitWith {
		player removeMagazines "A3FL_DickStick_Mag";
		player addMagazine "A3FL_DickStick_Mag";
	};
	if (_itemClass isEqualTo "A3FL_DickStickGold") exitWith {
		player removeMagazines "A3FL_DickStick_Mag";
		player addMagazine "A3FL_DickStick_Mag";
	};
	if (_itemClass isEqualTo "A3FL_Crowbar") exitWith {
		player removeMagazines "A3FL_Crowbar_Mag";
		player addMagazine "A3FL_Crowbar_Mag";
	};
}] call compile_Global;

/*
	A3PL_InventoryNew_TransferMenuOnLbDblClickTarget
	Gere le double-clic sur un item de la cible (prendre 1)
	Params: [control, selectedIndex]
*/
["A3PL_InventoryNew_TransferMenuOnLbDblClickTarget", {
	params ["_control", "_selectedIndex"];

	private _item = _control lbData _selectedIndex;
	if (_item isEqualTo "") exitWith {};

	private _display = findDisplay TRANSFER_DISPLAY_IDD;
	if (isNull(_display) || {_display getVariable ["busy", false]}) exitWith {};

	_display setVariable ["busy", true];

	(_display getVariable ["params", []]) params [
		["_target", objNull, [objNull]],
		["_variable", "", [""]],
		["_title", "", [""]],
		["_options", [], [[]]]
	];

	_options params [
		["_canStore", true, [true]],
		["_canTake", true, [true]]
	];

	if (!_canTake) exitWith {
		_display setVariable ["busy", false];
	};

	private _canAddResult = [_item, 1] call A3PL_InventoryNew_CanAddItemPhysical;
	private _canAddToGrid = _canAddResult#0;
	private _targetContainer = _canAddResult#1;

	private _canEquip = [_item] call A3PL_InventoryNew_CanEquipItem;
	private _equipped = false;

	// Si ni equipable ni ajout possible, afficher notification et ne pas retirer du conteneur
	if (!_canEquip && !_canAddToGrid) exitWith {
		["STR_A3PL_Inventory_NotEnoughGridSpace" call A3PL_Localize, Color_Red] call A3PL_Notification;
		_display setVariable ["busy", false];
	};

	if ((_canEquip || _canAddToGrid) && {[_target, _variable, _item, 1] call A3PL_InventoryNew_RemoveItemCargo}) then {
		if (!_canEquip || {!([true, _item] call A3PL_InventoryNew_HandleEquip)}) then {
			// Si on ne peut pas equiper mais qu'on peut ajouter a la grille
			if (_canAddToGrid) then {
				if (_targetContainer isNotEqualTo "") then {
					[_item, 1, _targetContainer] call A3PL_InventoryNew_AddItemToContainerGrid;
				};
				[true, _item, 1] call A3PL_InventoryNew_HandleItem;
			} else {
				// Ni equipable ni ajout possible - remettre dans le conteneur source
				[_target, _variable, [[_item, 1]] call A3PL_InventoryNew_FormatInv] call A3PL_InventoryNew_AddItemsCargo;
				["STR_A3PL_Inventory_NotEnoughGridSpace" call A3PL_Localize, Color_Red] call A3PL_Notification;
			};
		} else {
			_equipped = true;
		};
		[_item] call A3PL_InventoryNew_HandleMeleeWeaponMagazine;

		// Restaurer le contenu d'un uniforme/gilet si present
		diag_log format ["[TransferDblClick] Item=%1, _equipped=%2, _target=%3", _item, _equipped, _target];

		// Essayer d'abord le nouveau format HashMap, puis l'ancien format
		private _allContents = _target getVariable ["A3PL_ContainerContents", createHashMap];
		private _containerData = _allContents getOrDefault [_item, []];
		diag_log format ["[TransferDblClick] A3PL_ContainerContents HashMap for item: %1", _containerData];

		// Fallback vers l'ancien format si le nouveau est vide
		private _containerContent = [];
		private _containerType = "";
		private _storedItems = [];

		if (count _containerData > 0) then {
			_containerType = _containerData#0;
			_storedItems = _containerData#1;
		} else {
			// Ancien format
			_containerContent = _target getVariable ["A3PL_ContainerContent", []];
			diag_log format ["[TransferDblClick] Fallback to A3PL_ContainerContent: %1", _containerContent];
			if (count _containerContent > 0) then {
				_containerContent params ["_storedItem", "_cType", "_sItems"];
				if (_storedItem isEqualTo _item) then {
					_containerType = _cType;
					_storedItems = _sItems;
				};
			};
		};

		diag_log format ["[TransferDblClick] Final: containerType=%1, storedItems=%2", _containerType, _storedItems];

		if (_equipped && {count _storedItems > 0}) then {
			diag_log format ["Restoring container content: type=%1, items=%2", _containerType, _storedItems];

			// Restaurer les items dans le conteneur equipe
			{
				switch (_containerType) do {
					case "uniform": {
						if (player canAddItemToUniform _x) then {
							player addItemToUniform _x;
						} else {
							if (player canAdd _x) then {
								player addItem _x;
							} else {
								[getPosATL player, _x, 1] call A3PL_InventoryNew_AddItemGround;
							};
						};
					};
					case "vest": {
						if (player canAddItemToVest _x) then {
							player addItemToVest _x;
						} else {
							if (player canAdd _x) then {
								player addItem _x;
							} else {
								[getPosATL player, _x, 1] call A3PL_InventoryNew_AddItemGround;
							};
						};
					};
					case "backpack": {
						if (player canAddItemToBackpack _x) then {
							player addItemToBackpack _x;
						} else {
							if (player canAdd _x) then {
								player addItem _x;
							} else {
								[getPosATL player, _x, 1] call A3PL_InventoryNew_AddItemGround;
							};
						};
					};
				};
			} forEach _storedItems;

			// Nettoyer les variables
			private _allContentsClean = _target getVariable ["A3PL_ContainerContents", createHashMap];
			_allContentsClean deleteAt _item;
			_target setVariable ["A3PL_ContainerContents", _allContentsClean, true];
			_target setVariable ["A3PL_ContainerContent", nil, true];
		};
	};

	_display setVariable ["busy", false];
	[] call A3PL_InventoryNew_TransferMenuUpdateLists;
}] call compile_Global;

/*
	A3PL_InventoryNew_TransferMenuOnLbDblClickPlayer
	Gere le double-clic sur un item du joueur (stocker 1)
	Params: [control, selectedIndex]
*/
["A3PL_InventoryNew_TransferMenuOnLbDblClickPlayer", {
	params ["_control", "_selectedIndex"];

	private _item = _control lbData _selectedIndex;
	if (_item isEqualTo "") exitWith {};

	private _display = findDisplay TRANSFER_DISPLAY_IDD;
	if (isNull(_display) || {_display getVariable ["busy", false]}) exitWith {};

	_display setVariable ["busy", true];

	(_display getVariable ["params", []]) params [
		["_target", objNull, [objNull]],
		["_variable", "", [""]],
		["_title", "", [""]],
		["_options", [], [[]]]
	];

	_options params [
		["_canStore", true, [true]]
	];

	if (!_canStore || {!([_target, _variable, _item] call A3PL_InventoryNew_CargoIsItemAllowed)}) exitWith {
		_display setVariable ["busy", false];
	};

	private _items = [_item] call A3PL_InventoryNew_EquipmentItems;
	private _notAllowedItems = _items select {!([_target, _variable, _x] call A3PL_InventoryNew_CargoIsItemAllowed)};

	_items = _items + [_item];
	if ([_target, _variable, _items] call A3PL_InventoryNew_CanAddItemsCargo) then {
		if (([false, _item] call A3PL_InventoryNew_HandleEquip) || {[false, _item, 1] call A3PL_InventoryNew_HandleItem}) then {
			_items = _items - _notAllowedItems;
			[_target, _variable, _items call A3PL_InventoryNew_FormatInv] call A3PL_InventoryNew_AddItemsCargo;

			{
				[_x, 1] call A3PL_InventoryNew_ForceAddItem;
			} forEach _notAllowedItems;

			// Synchroniser les grilles apres retrait de l'item
			[] call A3PL_InventoryNew_SyncAllContainerGrids;
		};
	};

	_display setVariable ["busy", false];
	[] call A3PL_InventoryNew_TransferMenuUpdateLists;
}] call compile_Global;

// ============================================================================
// GRID INVENTORY SYSTEM - Core Functions
// ============================================================================

/*
	A3PL_InventoryNew_GetContainerGridSize
	Recupere la taille de grille d'un conteneur
	Params: classname du conteneur
	Return: [colonnes, lignes]
*/
["A3PL_InventoryNew_GetContainerGridSize", {
	params [["_classname", "", [""]]];

	if (_classname isEqualTo "") exitWith {[5, 4]};

	// Verifier que la config est chargee
	if (isNil "Inventory_Grid_Containers") exitWith {[5, 4]};

	// Chercher dans la config
	private _size = Inventory_Grid_Containers getOrDefault [_classname, []];

	// Si pas trouve, utiliser les valeurs par defaut selon le type
	if (_size isEqualTo []) then {
		private _cfg = configFile >> "CfgWeapons" >> _classname;
		if (isClass _cfg) then {
			private _type = getNumber(_cfg >> "ItemInfo" >> "type");
			_size = switch (_type) do {
				case 801: { Inventory_Grid_Containers getOrDefault ["_default_uniform", [5, 4]] };  // Uniform
				case 701: { Inventory_Grid_Containers getOrDefault ["_default_vest", [4, 3]] };    // Vest
				default { [5, 4] };
			};
		} else {
			// Verifier si c'est un backpack
			_cfg = configFile >> "CfgVehicles" >> _classname;
			if (isClass _cfg) then {
				_size = Inventory_Grid_Containers getOrDefault ["_default_backpack", [6, 5]];
			} else {
				_size = [5, 4];
			};
		};
	};

	_size
}] call compile_Global;

/*
	A3PL_InventoryNew_GetItemGridSize
	Recupere la taille d'un item dans la grille
	Params: classname de l'item
	Return: [largeur, hauteur, maxStack]
*/
["A3PL_InventoryNew_GetItemGridSize", {
	params [["_classname", "", [""]]];

	if (_classname isEqualTo "") exitWith {[1, 1, 10]};

	// Verifier que la config est chargee
	if (isNil "Inventory_Grid_Items") exitWith {[1, 1, 10]};

	private _size = Inventory_Grid_Items getOrDefault [_classname, []];

	if (_size isEqualTo []) then {
		// Verifier si c'est un uniforme (type 801) - taille 2x2
		private _cfg = configFile >> "CfgWeapons" >> _classname;
		if (isClass _cfg) then {
			// Essayer les deux variantes de casse pour ItemInfo
			private _itemType = getNumber(_cfg >> "ItemInfo" >> "type");
			if (_itemType isEqualTo 0) then {
				_itemType = getNumber(_cfg >> "itemInfo" >> "type");
			};
			diag_log format ["[GetItemGridSize] classname=%1, itemType=%2", _classname, _itemType];
			if (_itemType isEqualTo 801) then {
				_size = [2, 2, 1];
				diag_log format ["[GetItemGridSize] Uniform detected, setting size to 2x2"];
			};
		};
	};

	if (_size isEqualTo []) then {
		_size = Inventory_Grid_Items getOrDefault ["_default", [1, 1, 10]];
	};

	// Trait drug_mule - increases maxstack for drug items by 50%
	private _traits = player getVariable ["Player_Traits", []];
	if ("drug_mule" in _traits) then {
		private _drugItems = Player_illegalItems;
		if (_classname in _drugItems) then {
			private _newMaxStack = round((_size#2) * 1.5);
			_size set [2, _newMaxStack];
		};
	};

	_size
}] call compile_Global;

/*
	A3PL_InventoryNew_GetItemCustomDescription
	Recupere la description personnalisee d'un item (depuis Config_Inventory_Grid.sqf)
	Params: classname de l'item
	Return: description (string) ou "" si pas de description
*/
["A3PL_InventoryNew_GetItemCustomDescription", {
	params [["_classname", "", [""]]];

	if (_classname isEqualTo "") exitWith {""};

	if (isNil "Inventory_Grid_Descriptions") exitWith {""};

	Inventory_Grid_Descriptions getOrDefault [_classname, ""]
}] call compile_Global;

/*
	A3PL_InventoryNew_InitGrid
	Initialise une grille vide
	Params: [colonnes, lignes] ou colonnes, lignes
	Return: grille 2D (array de arrays, false = vide)
*/
["A3PL_InventoryNew_InitGrid", {
	private ["_cols", "_rows"];

	// Gerer le cas ou on passe un array [cols, rows] au lieu de deux params
	if ((_this isEqualType []) && {count _this == 2} && {(_this#0) isEqualType 0}) then {
		_cols = _this#0;
		_rows = _this#1;
	} else {
		params [
			["_c", 5, [0]],
			["_r", 4, [0]]
		];
		_cols = _c;
		_rows = _r;
	};

	if (_cols <= 0 || _rows <= 0) exitWith {[]};

	private _grid = [];
	for "_y" from 0 to (_rows - 1) do {
		private _row = [];
		for "_x" from 0 to (_cols - 1) do {
			_row pushBack false;
		};
		_grid pushBack _row;
	};

	_grid
}] call compile_Global;

/*
	A3PL_InventoryNew_IsCellEmpty
	Verifie si une cellule de grille est vide
	Une cellule vide peut etre: false (grille normale) ou "" (grille virtuelle)
	Params: cellData
	Return: boolean
*/
["A3PL_InventoryNew_IsCellEmpty", {
	params [["_cell", false]];
	(_cell isEqualTo false) || (_cell isEqualTo "")
}] call compile_Global;

/*
	A3PL_InventoryNew_CanPlaceItem
	Verifie si un item peut etre place a une position
	Params: [grid, classname, posX, posY, rotated, isVirtual]
	Return: boolean
*/
["A3PL_InventoryNew_CanPlaceItem", {
	params [
		["_grid", [], [[]]],
		["_classname", "", [""]],
		["_posX", 0, [0]],
		["_posY", 0, [0]],
		["_rotated", false, [false]],
		["_isVirtual", false, [false]]
	];

	if (_grid isEqualTo [] || {_classname isEqualTo ""}) exitWith {false};

	// Verifier que la grille est bien formatee (premiere ligne doit etre un array)
	private _firstRow = _grid#0;
	if !(_firstRow isEqualType []) exitWith {false};

	private _itemSize = if (_isVirtual) then {
		[_classname] call A3PL_InventoryNew_GetVirtualItemGridSize
	} else {
		[_classname] call A3PL_InventoryNew_GetItemGridSize
	};
	private _itemW = if (_rotated) then {_itemSize#1} else {_itemSize#0};
	private _itemH = if (_rotated) then {_itemSize#0} else {_itemSize#1};

	private _gridRows = count _grid;
	private _gridCols = count _firstRow;

	// Verifier les limites
	if (_posX < 0 || {_posY < 0} || {_posX + _itemW > _gridCols} || {_posY + _itemH > _gridRows}) exitWith {false};

	// Verifier que toutes les cases sont libres
	private _canPlace = true;
	for "_y" from _posY to (_posY + _itemH - 1) do {
		private _row = _grid#_y;
		if !(_row isEqualType []) exitWith {_canPlace = false};
		for "_x" from _posX to (_posX + _itemW - 1) do {
			private _cellData = _row#_x;
			if !([_cellData] call A3PL_InventoryNew_IsCellEmpty) exitWith {
				_canPlace = false;
			};
		};
		if (!_canPlace) exitWith {};
	};

	_canPlace
}] call compile_Global;

/*
	A3PL_InventoryNew_PlaceItem
	Place un item dans la grille
	Params: [grid, classname, posX, posY, rotated, count, isVirtual]
	Return: nouvelle grille (ou ancienne si echec)
*/
["A3PL_InventoryNew_PlaceItem", {
	params [
		["_grid", [], [[]]],
		["_classname", "", [""]],
		["_posX", 0, [0]],
		["_posY", 0, [0]],
		["_rotated", false, [false]],
		["_count", 1, [0]],
		["_isVirtual", false, [false]]
	];

	if (!([_grid, _classname, _posX, _posY, _rotated, _isVirtual] call A3PL_InventoryNew_CanPlaceItem)) exitWith {_grid};

	private _itemSize = if (_isVirtual) then {
		[_classname] call A3PL_InventoryNew_GetVirtualItemGridSize
	} else {
		[_classname] call A3PL_InventoryNew_GetItemGridSize
	};
	private _itemW = if (_rotated) then {_itemSize#1} else {_itemSize#0};
	private _itemH = if (_rotated) then {_itemSize#0} else {_itemSize#1};

	// Creer l'identifiant de l'item [classname, originX, originY, rotated, count]
	private _itemData = [_classname, _posX, _posY, _rotated, _count];

	// Marquer toutes les cases occupees
	for "_y" from _posY to (_posY + _itemH - 1) do {
		for "_x" from _posX to (_posX + _itemW - 1) do {
			_grid#_y set [_x, _itemData];
		};
	};

	_grid
}] call compile_Global;

/*
	A3PL_InventoryNew_RemoveItemAt
	Retire un item de la grille a une position
	Params: [grid, posX, posY, isVirtual]
	Return: [nouvelle grille, itemData retiree ou []]
*/
["A3PL_InventoryNew_RemoveItemAt", {
	params [
		["_grid", [], [[]]],
		["_posX", 0, [0]],
		["_posY", 0, [0]],
		["_isVirtual", false, [false]]
	];

	if (_grid isEqualTo []) exitWith {[_grid, []]};

	// Verifier que la grille est valide
	private _firstRow = _grid#0;
	if !(_firstRow isEqualType []) exitWith {[_grid, []]};

	private _gridRows = count _grid;
	private _gridCols = count _firstRow;

	if (_posX < 0 || {_posY < 0} || {_posX >= _gridCols} || {_posY >= _gridRows}) exitWith {[_grid, []]};

	// Verifier que la ligne cible est un array
	private _targetRow = _grid#_posY;
	if !(_targetRow isEqualType []) exitWith {[_grid, []]};
	if (_posX >= count _targetRow) exitWith {[_grid, []]};

	private _cellData = _targetRow#_posX;
	diag_log format ["RemoveItemAt: posX=%1, posY=%2, cellData=%3, cellDataType=%4", _posX, _posY, _cellData, typeName _cellData];
	if ([_cellData] call A3PL_InventoryNew_IsCellEmpty) exitWith {
		diag_log "RemoveItemAt: cell is empty, returning empty";
		[_grid, []]
	};

	// Recuperer les infos de l'item
	_cellData params ["_classname", "_originX", "_originY", "_rotated", "_count"];
	diag_log format ["RemoveItemAt: item=%1, origin=[%2,%3], rotated=%4, count=%5", _classname, _originX, _originY, _rotated, _count];

	private _itemSize = if (_isVirtual) then {
		[_classname] call A3PL_InventoryNew_GetVirtualItemGridSize
	} else {
		[_classname] call A3PL_InventoryNew_GetItemGridSize
	};
	private _itemW = if (_rotated) then {_itemSize#1} else {_itemSize#0};
	private _itemH = if (_rotated) then {_itemSize#0} else {_itemSize#1};

	// Valeur de cellule vide (false pour physique, "" pour virtuel)
	private _emptyValue = if (_isVirtual) then {""} else {false};

	// Liberer toutes les cases occupees par cet item
	diag_log format ["RemoveItemAt: clearing from [%1,%2] to [%3,%4]", _originX, _originY, _originX + _itemW - 1, _originY + _itemH - 1];
	for "_y" from _originY to (_originY + _itemH - 1) do {
		for "_x" from _originX to (_originX + _itemW - 1) do {
			_grid#_y set [_x, _emptyValue];
		};
	};

	diag_log format ["RemoveItemAt: returning grid rows=%1, cellData=%2", count _grid, _cellData];
	[_grid, _cellData]
}] call compile_Global;

/*
	A3PL_InventoryNew_FindFreeSlot
	Trouve une position libre pour un item (auto-placement)
	Params: [grid, classname, rotated]
	Return: [posX, posY] ou [-1, -1] si pas de place
*/
["A3PL_InventoryNew_FindFreeSlot", {
	params [
		["_grid", [], [[]]],
		["_classname", "", [""]],
		["_rotated", false, [false]]
	];

	if (_grid isEqualTo [] || {_classname isEqualTo ""}) exitWith {[-1, -1]};

	// Verifier que la grille est bien formatee
	private _firstRow = _grid#0;
	if !(_firstRow isEqualType []) exitWith {[-1, -1]};

	private _gridRows = count _grid;
	private _gridCols = count _firstRow;

	private _itemSize = [_classname] call A3PL_InventoryNew_GetItemGridSize;
	private _itemW = if (_rotated) then {_itemSize#1} else {_itemSize#0};
	private _itemH = if (_rotated) then {_itemSize#0} else {_itemSize#1};

	private _foundPos = [-1, -1];

	// Chercher de haut en bas, de gauche a droite
	for "_y" from 0 to (_gridRows - _itemH) do {
		for "_x" from 0 to (_gridCols - _itemW) do {
			if ([_grid, _classname, _x, _y, _rotated] call A3PL_InventoryNew_CanPlaceItem) exitWith {
				_foundPos = [_x, _y];
			};
		};
		if !(_foundPos isEqualTo [-1, -1]) exitWith {};
	};

	// Si pas trouve et item peut etre tourne, essayer avec rotation
	if (_foundPos isEqualTo [-1, -1] && {_itemW != _itemH}) then {
		private _rotatedW = _itemH;
		private _rotatedH = _itemW;

		for "_y" from 0 to (_gridRows - _rotatedH) do {
			for "_x" from 0 to (_gridCols - _rotatedW) do {
				if ([_grid, _classname, _x, _y, !_rotated] call A3PL_InventoryNew_CanPlaceItem) exitWith {
					_foundPos = [_x, _y, true]; // true = rotation necessaire
				};
			};
			if (count _foundPos > 2) exitWith {};
		};
	};

	_foundPos
}] call compile_Global;

/*
	A3PL_InventoryNew_CanStackItem
	Verifie si un item peut etre stacke sur un existant
	Params: [grid, classname, posX, posY, countToAdd]
	Return: boolean
*/
["A3PL_InventoryNew_CanStackItem", {
	params [
		["_grid", [], [[]]],
		["_classname", "", [""]],
		["_posX", 0, [0]],
		["_posY", 0, [0]],
		["_countToAdd", 1, [0]]
	];

	if (_grid isEqualTo [] || {_classname isEqualTo ""}) exitWith {false};

	// Verifier que la grille est bien formatee
	private _firstRow = _grid#0;
	if !(_firstRow isEqualType []) exitWith {false};

	private _gridRows = count _grid;
	private _gridCols = count _firstRow;

	if (_posX < 0 || {_posY < 0} || {_posX >= _gridCols} || {_posY >= _gridRows}) exitWith {false};

	private _row = _grid#_posY;
	if !(_row isEqualType []) exitWith {false};

	private _cellData = _row#_posX;
	if ([_cellData] call A3PL_InventoryNew_IsCellEmpty) exitWith {false};

	_cellData params ["_existingClass", "_originX", "_originY", "_rotated", "_currentCount"];

	// Verifier que c'est le meme item
	if (_existingClass isNotEqualTo _classname) exitWith {false};

	// Verifier le max stack
	private _itemSize = [_classname] call A3PL_InventoryNew_GetItemGridSize;
	private _maxStack = _itemSize#2;

	(_currentCount + _countToAdd) <= _maxStack
}] call compile_Global;

/*
	A3PL_InventoryNew_AddToStack
	Ajoute des items a un stack existant
	Params: [grid, posX, posY, countToAdd]
	Return: nouvelle grille
*/
["A3PL_InventoryNew_AddToStack", {
	params [
		["_grid", [], [[]]],
		["_posX", 0, [0]],
		["_posY", 0, [0]],
		["_countToAdd", 1, [0]]
	];

	if (_grid isEqualTo []) exitWith {_grid};

	private _cellData = _grid#_posY#_posX;
	if ([_cellData] call A3PL_InventoryNew_IsCellEmpty) exitWith {_grid};

	_cellData params ["_classname", "_originX", "_originY", "_rotated", "_currentCount"];

	// Mettre a jour le count
	private _newData = [_classname, _originX, _originY, _rotated, _currentCount + _countToAdd];

	// Mettre a jour toutes les cases de l'item
	private _itemSize = [_classname] call A3PL_InventoryNew_GetItemGridSize;
	private _itemW = if (_rotated) then {_itemSize#1} else {_itemSize#0};
	private _itemH = if (_rotated) then {_itemSize#0} else {_itemSize#1};

	for "_y" from _originY to (_originY + _itemH - 1) do {
		for "_x" from _originX to (_originX + _itemW - 1) do {
			_grid#_y set [_x, _newData];
		};
	};

	_grid
}] call compile_Global;

/*
	A3PL_InventoryNew_CanAddItem
	Verifie si un item peut etre ajoute a l'inventaire virtuel du joueur
	Prend en compte le stacking et les slots libres
	Params: [classname, amount]
	Return: boolean
*/
["A3PL_InventoryNew_CanAddItem", {
	params [
		["_classname", "", [""]],
		["_amount", 1, [0]]
	];

	if (_classname isEqualTo "" || _amount <= 0) exitWith {false};

	// Obtenir la taille de la grille (incluant bonus backpack et premium)
	private _gridSize = [] call A3PL_InventoryNew_GetVirtualGridSize;
	private _totalSlots = (_gridSize#0) * (_gridSize#1);

	// Obtenir le maxStack de l'item
	private _itemSize = [_classname] call A3PL_InventoryNew_GetItemGridSize;
	private _maxStack = _itemSize#2;

	// Recuperer l'inventaire actuel (le vrai, pas la grille)
	private _inventory = player getVariable ["Player_Inventory", []];

	// Calculer combien d'items on a deja de cette classe
	private _currentAmount = 0;
	{
		if ((_x#0) isEqualTo _classname) exitWith {
			_currentAmount = _x#1;
		};
	} forEach _inventory;

	// Calculer le nombre total d'items apres ajout
	private _newTotalAmount = _currentAmount + _amount;

	// Calculer le nombre de stacks necessaires
	private _stacksNeeded = ceil (_newTotalAmount / _maxStack);

	// Compter le nombre total de stacks utilises actuellement (chaque item = 1 stack minimum)
	private _currentStacks = 0;
	{
		private _itemClass = _x#0;
		private _itemAmount = _x#1;
		private _itemMaxStack = ([_itemClass] call A3PL_InventoryNew_GetItemGridSize)#2;
		_currentStacks = _currentStacks + ceil (_itemAmount / _itemMaxStack);
	} forEach _inventory;

	// Retirer les stacks de l'item qu'on ajoute (on va les recalculer)
	private _currentStacksForItem = if (_currentAmount > 0) then {ceil (_currentAmount / _maxStack)} else {0};
	private _otherStacks = _currentStacks - _currentStacksForItem;

	// Verifier si on a assez de place pour les nouveaux stacks
	private _totalStacksAfter = _otherStacks + _stacksNeeded;

	_totalStacksAfter <= _totalSlots
}] call compile_Global;

/*
	A3PL_InventoryNew_GetGridItems
	Recupere la liste des items uniques dans une grille
	Params: grid
	Return: [[classname, posX, posY, rotated, count], ...]
*/
["A3PL_InventoryNew_GetGridItems", {
	params [["_grid", [], [[]]]];

	if (_grid isEqualTo []) exitWith {[]};

	// Verifier que la grille est valide (premiere ligne doit etre un array)
	if (count _grid == 0) exitWith {[]};
	private _firstRow = _grid#0;
	if !(_firstRow isEqualType []) exitWith {[]};

	private _items = [];
	private _processed = [];

	{
		private _row = _x;
		private _y = _forEachIndex;
		// Verifier que la ligne est un array avant d'iterer
		if (_row isEqualType []) then {
			{
				// Verifier que c'est bien un item (tableau avec au moins 3 elements)
				// Les cases vides peuvent etre false (grille normale) ou "" (grille virtuelle)
				if ((_x isEqualType []) && {count _x >= 3}) then {
					_x params ["_classname", "_originX", "_originY"];
					private _key = format ["%1_%2_%3", _classname, _originX, _originY];
					if !(_key in _processed) then {
						_processed pushBack _key;
						_items pushBack _x;
					};
				};
			} forEach _row;
		};
	} forEach _grid;

	_items
}] call compile_Global;

/*
	A3PL_InventoryNew_GridToInventory
	Convertit une grille en format inventaire standard [[items], [counts]]
	Params: grid
	Return: [[classnames], [counts]]
*/
["A3PL_InventoryNew_GridToInventory", {
	params [["_grid", [], [[]]]];

	private _items = [_grid] call A3PL_InventoryNew_GetGridItems;
	private _classnames = [];
	private _counts = [];

	{
		_x params ["_classname", "_posX", "_posY", "_rotated", "_count"];
		private _index = _classnames find _classname;
		if (_index isEqualTo -1) then {
			_classnames pushBack _classname;
			_counts pushBack _count;
		} else {
			_counts set [_index, (_counts#_index) + _count];
		};
	} forEach _items;

	[_classnames, _counts]
}] call compile_Global;

/*
	A3PL_InventoryNew_InventoryToGrid
	Convertit un inventaire standard en grille (auto-placement)
	Params: [gridSize, formattedInventory, savedLayout]
	Return: grille remplie
*/
["A3PL_InventoryNew_InventoryToGrid", {
	params [
		["_gridSize", [5, 4], [[]]],
		["_inventory", [[], []], [[]]],
		["_savedLayout", [], [[]]]
	];

	private _grid = _gridSize call A3PL_InventoryNew_InitGrid;

	// D'abord, placer les items avec layout sauvegarde
	{
		_x params ["_classname", "_posX", "_posY", "_rotated"];
		private _index = (_inventory#0) find _classname;
		if (_index != -1) then {
			private _count = (_inventory#1)#_index;
			if (_count > 0) then {
				private _itemSize = [_classname] call A3PL_InventoryNew_GetItemGridSize;
				private _maxStack = _itemSize#2;
				private _toPlace = _count min _maxStack;

				if ([_grid, _classname, _posX, _posY, _rotated] call A3PL_InventoryNew_CanPlaceItem) then {
					_grid = [_grid, _classname, _posX, _posY, _rotated, _toPlace] call A3PL_InventoryNew_PlaceItem;
					(_inventory#1) set [_index, _count - _toPlace];
				};
			};
		};
	} forEach _savedLayout;

	// Ensuite, auto-placer les items restants
	{
		private _classname = _x;
		private _count = (_inventory#1)#_forEachIndex;

		while {_count > 0} do {
			private _itemSize = [_classname] call A3PL_InventoryNew_GetItemGridSize;
			private _maxStack = _itemSize#2;
			private _toPlace = _count min _maxStack;

			// Chercher un slot libre
			private _freeSlot = [_grid, _classname, false] call A3PL_InventoryNew_FindFreeSlot;

			if !(_freeSlot isEqualTo [-1, -1]) then {
				private _rotated = if (count _freeSlot > 2) then {_freeSlot#2} else {false};
				_grid = [_grid, _classname, _freeSlot#0, _freeSlot#1, _rotated, _toPlace] call A3PL_InventoryNew_PlaceItem;
				_count = _count - _toPlace;
			} else {
				// Pas de place, sortir
				_count = 0;
			};
		};
	} forEach (_inventory#0);

	_grid
}] call compile_Global;

/*
	A3PL_InventoryNew_SaveGridLayout
	Sauvegarde la disposition de la grille dans profileNamespace
	Params: [filterType, grid]
*/
["A3PL_InventoryNew_SaveGridLayout", {
	params [
		["_filterType", "all", [""]],
		["_grid", [], [[]]]
	];

	private _items = [_grid] call A3PL_InventoryNew_GetGridItems;
	private _layout = [];

	{
		_x params ["_classname", "_posX", "_posY", "_rotated", "_count"];
		_layout pushBack [_classname, _posX, _posY, _rotated];
	} forEach _items;

	private _varName = format ["A3PL_InventoryGrid_%1", _filterType];
	profileNamespace setVariable [_varName, _layout];
	saveProfileNamespace;
}] call compile_Global;

/*
	A3PL_InventoryNew_LoadGridLayout
	Charge la disposition de la grille depuis profileNamespace
	Params: filterType
	Return: [[classname, posX, posY, rotated], ...]
*/
["A3PL_InventoryNew_LoadGridLayout", {
	params [["_filterType", "all", [""]]];

	private _varName = format ["A3PL_InventoryGrid_%1", _filterType];
	profileNamespace getVariable [_varName, []]
}] call compile_Global;

// ============================================================================
// GRID INVENTORY SYSTEM - UI Rendering Functions
// ============================================================================

/*
	A3PL_InventoryNew_GridClearControls
	Supprime tous les controles de la grille
	Params: display
*/
["A3PL_InventoryNew_GridClearControls", {
	params [["_display", displayNull, [displayNull]]];

	if (isNull _display) exitWith {};

	private _gridGroup = _display displayCtrl INVENTORY_GRID_GROUP_IDC;
	if (isNull _gridGroup) exitWith {};

	// Supprimer les controles de cellules (IDC 6600-6999)
	for "_i" from 0 to 399 do {
		private _ctrl = _display displayCtrl (INVENTORY_GRID_CELL_BASE_IDC + _i);
		if (!isNull _ctrl) then {ctrlDelete _ctrl};
	};

	// Supprimer les controles d'items (IDC 7000-7499)
	for "_i" from 0 to 499 do {
		private _ctrl = _display displayCtrl (INVENTORY_GRID_ITEM_BASE_IDC + _i);
		if (!isNull _ctrl) then {ctrlDelete _ctrl};
	};

	// Cacher le drag picture et tooltip
	private _dragPic = _display displayCtrl INVENTORY_GRID_DRAG_PICTURE_IDC;
	if (!isNull _dragPic) then {
		_dragPic ctrlShow false;
		_dragPic ctrlSetPosition [0, 0, 0, 0];
		_dragPic ctrlCommit 0;
	};

	private _tooltip = _display displayCtrl INVENTORY_GRID_TOOLTIP_IDC;
	if (!isNull _tooltip) then {
		_tooltip ctrlShow false;
		_tooltip ctrlSetPosition [0, 0, 0, 0];
		_tooltip ctrlCommit 0;
	};
}] call compile_Global;

/*
	A3PL_InventoryNew_RenderGrid
	Affiche la grille dans le dialog
	Params: [display, grid, gridSize]
*/
["A3PL_InventoryNew_RenderGrid", {
	params [
		["_display", displayNull, [displayNull]],
		["_grid", [], [[]]],
		["_gridSize", [5, 4], [[]]],
		["_isVirtual", false, [false]]
	];

	// Stocker si c'est un mode virtuel
	_display setVariable ["grid_isVirtual", _isVirtual];

	if (isNull _display) exitWith {
		diag_log "A3PL_InventoryNew_RenderGrid: Display is null!";
	};

	// Verifier que les constantes de la grille sont definies
	if (isNil "Inventory_Grid_CellWidth") exitWith {
		diag_log "A3PL_InventoryNew_RenderGrid: Config_Inventory_Grid not loaded!";
	};

	_gridSize params ["_cols", "_rows"];
	diag_log format ["A3PL_InventoryNew_RenderGrid: cols=%1, rows=%2", _cols, _rows];

	// Nettoyer les anciens controles
	[_display] call A3PL_InventoryNew_GridClearControls;

	private _gridGroup = _display displayCtrl INVENTORY_GRID_GROUP_IDC;
	if (isNull _gridGroup) exitWith {
		diag_log format ["A3PL_InventoryNew_RenderGrid: GridGroup is null! IDC=%1", INVENTORY_GRID_GROUP_IDC];
	};

	// Ajouter event handler pour le clic droit sur le groupe (capture les clics sur les items)
	_gridGroup ctrlRemoveAllEventHandlers "MouseButtonUp";
	_gridGroup ctrlAddEventHandler ["MouseButtonUp", {
		params ["_ctrl", "_button", "_xPos", "_yPos"];
		if (_button == 1) then {
			// Clic droit - verifier si on a des donnees d'item stockees
			private _gridItem = uiNamespace getVariable ["InventoryGridClickItem", []];
			private _gridTarget = uiNamespace getVariable ["InventoryGridClickTarget", controlNull];
			if (!isNull _gridTarget && {!(_gridItem isEqualTo [])}) then {
				private _mousePos = getMousePosition;
				private _display = uiNamespace getVariable ["A3PL_RscDisplayInventoryNew", displayNull];
				private _fnc = missionNamespace getVariable ["A3PL_InventoryNew_RightClick", {}];
				[_display, _button, _mousePos#0, _mousePos#1, false, false, false] call _fnc;
			};
		};
	}];

	diag_log format ["A3PL_InventoryNew_RenderGrid: GridGroup found, creating %1 cells", _cols * _rows];

	// Parametres de la grille (avec valeurs par defaut si config non chargee)
	private _cellWidthRatio = if (isNil "Inventory_Grid_CellWidth") then {0.0247} else {Inventory_Grid_CellWidth};
	private _cellHeightRatio = if (isNil "Inventory_Grid_CellHeight") then {0.044} else {Inventory_Grid_CellHeight};
	private _cellSpacingRatio = if (isNil "Inventory_Grid_CellSpacing") then {0.001} else {Inventory_Grid_CellSpacing};

	private _cellW = _cellWidthRatio * safezoneW;
	private _cellH = _cellHeightRatio * safezoneH;
	private _spacing = _cellSpacingRatio * safezoneW;

	// Creer les cellules de la grille
	private _cellIndex = 0;
	for "_y" from 0 to (_rows - 1) do {
		for "_x" from 0 to (_cols - 1) do {
			private _posX = _x * (_cellW + _spacing);
			private _posY = _y * (_cellH + _spacing);

			// Creer le fond de la cellule (RscButton pour les events)
			private _cellIdc = INVENTORY_GRID_CELL_BASE_IDC + _cellIndex;
			private _cell = _display ctrlCreate ["RscButton", _cellIdc, _gridGroup];

			_cell ctrlSetPosition [_posX, _posY, _cellW, _cellH];
			_cell ctrlSetBackgroundColor Inventory_Grid_CellColorEmpty;
			_cell ctrlSetText "";

			// Stocker la position de la cellule
			_cell setVariable ["gridPos", [_x, _y]];
			_cell setVariable ["isGridCell", true];

			// Events pour la cellule - highlight au survol
			// Note: ctrlParent d'un controle dans RscControlsGroup retourne le groupe, pas le display
			_cell ctrlAddEventHandler ["MouseEnter", {
				params ["_ctrl"];
				private _display = uiNamespace getVariable ["A3PL_RscDisplayInventoryNew", displayNull];
				private _isDragging = _display getVariable ["grid_isDragging", false];

				if (_isDragging) then {
					_display setVariable ["grid_hoverCell", _ctrl];
					private _fnc = missionNamespace getVariable ["A3PL_InventoryNew_GridShowDropPreview", {}];
					[_display, _ctrl] call _fnc;
				} else {
					private _gridPos = _ctrl getVariable ["gridPos", [-1, -1]];
					private _grid = _display getVariable ["currentGrid", []];
					if (_grid isEqualTo []) exitWith {};

					_gridPos params ["_gx", "_gy"];
					if (_gx < 0 || _gy < 0) exitWith {};
					if (_gy >= count _grid) exitWith {};
					private _row = _grid#_gy;
					if !(_row isEqualType []) exitWith {};
					if (_gx >= count _row) exitWith {};

					private _cellData = _row#_gx;
					// Cellule vide = false ou ""
					private _isEmpty = (_cellData isEqualTo false) || (_cellData isEqualTo "");
					if (_isEmpty) then {
						_ctrl ctrlSetBackgroundColor Inventory_Grid_CellColorHover;
					};
				};
			}];

			_cell ctrlAddEventHandler ["MouseExit", {
				params ["_ctrl"];
				private _display = uiNamespace getVariable ["A3PL_RscDisplayInventoryNew", displayNull];
				private _isDragging = _display getVariable ["grid_isDragging", false];

				if (_isDragging) then {
					_display setVariable ["grid_hoverCell", controlNull];
					private _fnc = missionNamespace getVariable ["A3PL_InventoryNew_GridClearDropPreview", {}];
					[_display] call _fnc;
				} else {
					private _gridPos = _ctrl getVariable ["gridPos", [-1, -1]];
					private _grid = _display getVariable ["currentGrid", []];
					if (_grid isEqualTo []) exitWith {};

					_gridPos params ["_gx", "_gy"];
					if (_gx < 0 || _gy < 0) exitWith {};
					if (_gy >= count _grid) exitWith {};
					private _row = _grid#_gy;
					if !(_row isEqualType []) exitWith {};
					if (_gx >= count _row) exitWith {};

					private _cellData = _row#_gx;
					// Cellule vide = false ou ""
					private _isEmpty = (_cellData isEqualTo false) || (_cellData isEqualTo "");
					if (_isEmpty) then {
						_ctrl ctrlSetBackgroundColor Inventory_Grid_CellColorEmpty;
					};
				};
			}];

			// Click pour drop si en mode drag
			_cell ctrlAddEventHandler ["ButtonClick", {
				params ["_ctrl"];
				private _display = uiNamespace getVariable ["A3PL_RscDisplayInventoryNew", displayNull];
				private _isDragging = _display getVariable ["grid_isDragging", false];

				if (_isDragging) then {
					// Ignorer si le drag vient juste de demarrer (meme clic)
					private _justStarted = _display getVariable ["grid_dragJustStarted", false];
					if (_justStarted) exitWith {
						_display setVariable ["grid_dragJustStarted", false];
						diag_log "Cell ButtonClick: ignored because drag just started";
					};
					private _fnc = missionNamespace getVariable ["A3PL_InventoryNew_GridDropItem", {}];
					[_display, _ctrl] call _fnc;
				};
			}];

			_cell ctrlCommit 0;
			_cellIndex = _cellIndex + 1;
		};
	};

	// Rendre les items sur la grille
	[_display, _grid] call A3PL_InventoryNew_RenderGridItems;

	// Stocker la grille dans le display
	_display setVariable ["currentGrid", _grid];
	_display setVariable ["currentGridSize", _gridSize];
}] call compile_Global;

/*
	A3PL_InventoryNew_RenderGridItems
	Affiche les items sur la grille
	Params: [display, grid]
*/
["A3PL_InventoryNew_RenderGridItems", {
	params [
		["_display", displayNull, [displayNull]],
		["_grid", [], [[]]]
	];

	if (isNull _display || _grid isEqualTo []) exitWith {};

	private _gridGroup = _display displayCtrl INVENTORY_GRID_GROUP_IDC;
	if (isNull _gridGroup) exitWith {};

	// Verifier si mode virtuel
	private _isVirtual = _display getVariable ["grid_isVirtual", false];

	// Recuperer les items uniques
	private _items = [_grid] call A3PL_InventoryNew_GetGridItems;
	diag_log format ["[RenderGridItems] Found %1 items to render: %2", count _items, _items];

	// Parametres de la grille (avec valeurs par defaut si config non chargee)
	private _cellWidthRatio = if (isNil "Inventory_Grid_CellWidth") then {0.0247} else {Inventory_Grid_CellWidth};
	private _cellHeightRatio = if (isNil "Inventory_Grid_CellHeight") then {0.044} else {Inventory_Grid_CellHeight};
	private _cellSpacingRatio = if (isNil "Inventory_Grid_CellSpacing") then {0.001} else {Inventory_Grid_CellSpacing};

	private _cellW = _cellWidthRatio * safezoneW;
	private _cellH = _cellHeightRatio * safezoneH;
	private _spacing = _cellSpacingRatio * safezoneW;

	// Creer les controles visuels pour chaque item
	{
		_x params ["_classname", "_posX", "_posY", "_rotated", "_count"];

		// Utiliser la bonne fonction selon le mode
		private _itemSize = if (_isVirtual) then {
			[_classname] call A3PL_InventoryNew_GetVirtualItemGridSize
		} else {
			[_classname] call A3PL_InventoryNew_GetItemGridSize
		};

		// Protection contre les valeurs nil ou invalides
		if (isNil "_itemSize" || {!(_itemSize isEqualType [])} || {count _itemSize < 2}) then {
			diag_log format ["A3PL_InventoryNew_RenderGridItems: Invalid itemSize for %1, defaulting to [1,1]", _classname];
			_itemSize = [1, 1, 1];
		};

		private _itemW = if (_rotated) then {_itemSize#1} else {_itemSize#0};
		private _itemH = if (_rotated) then {_itemSize#0} else {_itemSize#1};

		// Protection contre NaN
		if (isNil "_itemW" || {!(_itemW isEqualType 0)}) then { _itemW = 1; };
		if (isNil "_itemH" || {!(_itemH isEqualType 0)}) then { _itemH = 1; };

		// Position et taille du controle
		private _ctrlX = _posX * (_cellW + _spacing);
		private _ctrlY = _posY * (_cellH + _spacing);
		private _ctrlW = _itemW * _cellW + (_itemW - 1) * _spacing;
		private _ctrlH = _itemH * _cellH + (_itemH - 1) * _spacing;

		// Recuperer l'icone de l'item via FetchItemInfo ou FetchVirtualItemInfo
		private _itemInfo = if (_isVirtual) then {
			[_classname] call A3PL_InventoryNew_FetchVirtualItemInfo
		} else {
			[_classname] call A3PL_InventoryNew_FetchItemInfo
		};
		private _icon = _itemInfo select 2;

		// Creer le fond de l'item (RscButton pour les events de clic)
		private _itemBgIdc = INVENTORY_GRID_ITEM_BASE_IDC + (_forEachIndex * 2);
		private _itemBg = _display ctrlCreate ["RscButton", _itemBgIdc, _gridGroup];
		_itemBg ctrlSetPosition [_ctrlX, _ctrlY, _ctrlW, _ctrlH];
		_itemBg ctrlSetBackgroundColor Inventory_Grid_CellColorOccupied;
		_itemBg ctrlSetText "";

		// Stocker les infos de l'item
		_itemBg setVariable ["itemData", _x];
		_itemBg setVariable ["gridPos", [_posX, _posY]];
		_itemBg setVariable ["isGridItem", true];

		// Events pour l'item
		_itemBg ctrlAddEventHandler ["MouseEnter", {
			params ["_ctrl"];
			private _display = uiNamespace getVariable ["A3PL_RscDisplayInventoryNew", displayNull];
			private _itemData = _ctrl getVariable ["itemData", []];
			if (_itemData isEqualTo []) exitWith {};

			private _isDragging = _display getVariable ["grid_isDragging", false];
			if (!_isDragging) then {
				// Afficher le tooltip
				private _fnc = missionNamespace getVariable ["A3PL_InventoryNew_GridShowTooltip", {}];
				[_display, _ctrl, _itemData] call _fnc;
			};
		}];

		_itemBg ctrlAddEventHandler ["MouseExit", {
			params ["_ctrl"];
			private _display = uiNamespace getVariable ["A3PL_RscDisplayInventoryNew", displayNull];
			private _fnc = missionNamespace getVariable ["A3PL_InventoryNew_GridHideTooltip", {}];
			[_display] call _fnc;
		}];

		_itemBg ctrlAddEventHandler ["ButtonClick", {
			params ["_ctrl"];
			private _display = uiNamespace getVariable ["A3PL_RscDisplayInventoryNew", displayNull];

			// Clic gauche - selectionner/deplacer l'item
			private _isDragging = _display getVariable ["grid_isDragging", false];
			if (!_isDragging) then {
				private _fnc = missionNamespace getVariable ["A3PL_InventoryNew_GridStartDrag", {}];
				[_display, _ctrl] call _fnc;
			};
		}];

		// Clic droit pour le menu contextuel - appeler RightClick directement
		_itemBg ctrlAddEventHandler ["MouseButtonDown", {
			params ["_ctrl", "_button"];
			diag_log format ["GRID ITEM MouseButtonDown: button=%1, itemData=%2", _button, _ctrl getVariable ["itemData", []]];
			if (_button == 1) then {
				// Clic droit - stocker les donnees et appeler RightClick directement
				private _itemData = _ctrl getVariable ["itemData", []];
				if !(_itemData isEqualTo []) then {
					uiNamespace setVariable ["InventoryGridClickTarget", _ctrl];
					uiNamespace setVariable ["InventoryGridClickItem", _itemData];
					// Appeler RightClick directement car MouseButtonUp du groupe ne se declenche pas
					private _mousePos = getMousePosition;
					private _display = uiNamespace getVariable ["A3PL_RscDisplayInventoryNew", displayNull];
					diag_log format ["GRID ITEM calling RightClick: mousePos=%1, display=%2", _mousePos, _display];
					[_display, 1, _mousePos#0, _mousePos#1, false, false, false] call A3PL_InventoryNew_RightClick;
				};
			};
		}];

		_itemBg ctrlCommit 0;

		// Creer l'icone de l'item (RscPicture)
		private _itemPicIdc = INVENTORY_GRID_ITEM_BASE_IDC + (_forEachIndex * 2) + 1;
		private _itemPic = _display ctrlCreate ["RscPictureKeepAspect", _itemPicIdc, _gridGroup];
		_itemPic ctrlSetPosition [_ctrlX + 0.002, _ctrlY + 0.002, _ctrlW - 0.004, _ctrlH - 0.004];
		_itemPic ctrlSetText _icon;
		_itemPic ctrlEnable false; // Pour que les clics passent au bouton en dessous
		_itemPic ctrlCommit 0;

		// Afficher le count si > 1 (sauf pour le cash qui affiche le montant dans le tooltip)
		if (_count > 1 && !(_classname isEqualTo "cash")) then {
			private _countIdc = INVENTORY_GRID_ITEM_BASE_IDC + 250 + _forEachIndex;
			private _countText = _display ctrlCreate ["RscStructuredText", _countIdc, _gridGroup];
			_countText ctrlSetPosition [_ctrlX, _ctrlY + _ctrlH - 0.02, _ctrlW, 0.02];
			private _countLabel = format ["<t align='right' size='0.8'>x%1</t>", _count];
			_countText ctrlSetStructuredText parseText _countLabel;
			_countText ctrlEnable false;
			_countText ctrlCommit 0;
		};

		// Marquer les cellules comme occupees visuellement
		for "_cy" from _posY to (_posY + _itemH - 1) do {
			for "_cx" from _posX to (_posX + _itemW - 1) do {
				private _cellIndex = _cy * (count (_grid#0)) + _cx;
				private _cellCtrl = _display displayCtrl (INVENTORY_GRID_CELL_BASE_IDC + _cellIndex);
				if (!isNull _cellCtrl) then {
					_cellCtrl ctrlSetBackgroundColor [0, 0, 0, 0]; // Transparent car item par dessus
				};
			};
		};

	} forEach _items;
}] call compile_Global;

/*
	A3PL_InventoryNew_GridShowTooltip
	Affiche le tooltip d'un item
	Params: [display, ctrl, itemData]
*/
["A3PL_InventoryNew_GridShowTooltip", {
	params [
		["_display", displayNull, [displayNull]],
		["_ctrl", controlNull, [controlNull]],
		["_itemData", [], [[]]]
	];

	if (isNull _display || _itemData isEqualTo []) exitWith {};

	_itemData params ["_classname", "_posX", "_posY", "_rotated", "_count"];

	private _tooltip = _display displayCtrl INVENTORY_GRID_TOOLTIP_IDC;
	if (isNull _tooltip) exitWith {};

	// Verifier si mode virtuel
	private _isVirtual = _display getVariable ["grid_isVirtual", false];

	// Utiliser la bonne fonction selon le mode
	private _itemInfo = if (_isVirtual) then {
		[_classname] call A3PL_InventoryNew_FetchVirtualItemInfo
	} else {
		[_classname] call A3PL_InventoryNew_FetchItemInfo
	};
	private _displayName = _itemInfo select 1;
	private _itemSize = if (_isVirtual) then {
		[_classname] call A3PL_InventoryNew_GetVirtualItemGridSize
	} else {
		[_classname] call A3PL_InventoryNew_GetItemGridSize
	};
	// Pour les items virtuels, la description est dans itemInfo[3]
	private _description = if (_isVirtual) then {
		_itemInfo select 3
	} else {
		[_classname] call A3PL_InventoryNew_GetItemCustomDescription
	};

	// Construire le texte du tooltip
	private _text = format [
		("STR_A3PL_Inventory_ToolTip" call A3PL_Localize),
		_displayName,
		_count,
		_itemSize#0,
		_itemSize#1,
		if (_rotated) then {" (tourne)"} else {""}
	];

	// Ajouter la description si elle existe
	if (_description != "") then {
		_text = _text + format ["<br/><t size='0.6' color='#66aaff'>%1</t>", _description];
	};

	_tooltip ctrlSetStructuredText parseText _text;

	// Dimensions du tooltip (ajuste si description presente)
	private _tooltipW = 0.22;
	private _tooltipH = if (_description != "") then {0.13} else {0.10};

	private _mousePos = getMousePosition;
	private _mouseX = _mousePos#0;
	private _mouseY = _mousePos#1;

	private _tooltipX = _mouseX - (_tooltipW / 2);
	private _tooltipY = _mouseY - _tooltipH - 0.02;

	if (_tooltipX < safezoneX) then {
		_tooltipX = safezoneX + 0.01;
	};
	if (_tooltipX + _tooltipW > safezoneX + safezoneW) then {
		_tooltipX = safezoneX + safezoneW - _tooltipW - 0.01;
	};

	if (_tooltipY < safezoneY) then {
		_tooltipY = _mouseY + 0.03;
	};

	_tooltip ctrlSetPosition [_tooltipX, _tooltipY, _tooltipW, _tooltipH];
	_tooltip ctrlShow true;
	_tooltip ctrlCommit 0;
}] call compile_Global;

/*
	A3PL_InventoryNew_GridHideTooltip
	Cache le tooltip
	Params: display
*/
["A3PL_InventoryNew_GridHideTooltip", {
	params [["_display", displayNull, [displayNull]]];

	if (isNull _display) exitWith {};

	private _tooltip = _display displayCtrl INVENTORY_GRID_TOOLTIP_IDC;
	if (!isNull _tooltip) then {
		_tooltip ctrlShow false;
		_tooltip ctrlSetPosition [0, 0, 0, 0];
		_tooltip ctrlCommit 0;
	};
}] call compile_Global;

/*
	A3PL_InventoryNew_GridStartDrag
	Commence le drag d'un item
	Params: [display, ctrl]
*/
["A3PL_InventoryNew_GridStartDrag", {
	params [
		["_display", displayNull, [displayNull]],
		["_ctrl", controlNull, [controlNull]]
	];

	if (isNull _display || isNull _ctrl) exitWith {};

	private _itemData = _ctrl getVariable ["itemData", []];
	if (_itemData isEqualTo []) exitWith {};

	_itemData params ["_classname", "_posX", "_posY", "_rotated", "_count"];

	// Stocker l'item en cours de drag
	_display setVariable ["grid_isDragging", true];
	_display setVariable ["grid_dragItem", _itemData];
	_display setVariable ["grid_dragRotated", _rotated];
	_display setVariable ["grid_dragSourceCtrl", _ctrl];
	// Flag pour ignorer le premier MouseButtonUp (meme clic que le ButtonClick qui demarre le drag)
	_display setVariable ["grid_dragJustStarted", true];

	// Cacher le tooltip
	[_display] call A3PL_InventoryNew_GridHideTooltip;

	// Afficher l'image de drag
	private _dragPic = _display displayCtrl INVENTORY_GRID_DRAG_PICTURE_IDC;
	if (!isNull _dragPic) then {
		// Recuperer l'icone via FetchItemInfo [classname, name, picture, description, mass]
		private _itemInfo = [_classname] call A3PL_InventoryNew_FetchItemInfo;
		private _icon = _itemInfo select 2;
		_dragPic ctrlSetText _icon;

		private _itemSize = [_classname] call A3PL_InventoryNew_GetItemGridSize;
		private _itemW = if (_rotated) then {_itemSize#1} else {_itemSize#0};
		private _itemH = if (_rotated) then {_itemSize#0} else {_itemSize#1};

		// Taille de l'icone de drag (en coordonnees normalisees 0-1)
		// Utiliser une taille fixe proportionnelle pour que ce soit visible
		private _w = _itemW * 0.035;
		private _h = _itemH * 0.055;

		// Stocker la taille pour le MouseMoving
		_display setVariable ["grid_dragSize", [_w, _h]];

		// Demarrer le suivi de la souris
		_display displayAddEventHandler ["MouseMoving", {
			params ["_display"];
			private _isDragging = _display getVariable ["grid_isDragging", false];
			if (!_isDragging) exitWith {};

			private _dragPic = _display displayCtrl INVENTORY_GRID_DRAG_PICTURE_IDC;
			if (isNull _dragPic) exitWith {};

			// Utiliser getMousePosition pour les coordonnees absolues ecran
			private _mousePos = getMousePosition;
			private _dragSize = _display getVariable ["grid_dragSize", [0.05, 0.05]];
			_dragPic ctrlSetPosition [(_mousePos#0) - (_dragSize#0)/2, (_mousePos#1) - (_dragSize#1)/2, _dragSize#0, _dragSize#1];
			_dragPic ctrlCommit 0;
		}];

		// Position initiale
		private _mousePos = getMousePosition;
		_dragPic ctrlSetPosition [(_mousePos#0) - _w/2, (_mousePos#1) - _h/2, _w, _h];
		_dragPic ctrlShow true;
		_dragPic ctrlCommit 0;
	};

	// Rendre l'item source semi-transparent
	_ctrl ctrlSetBackgroundColor [0.2, 0.2, 0.2, 0.3];
}] call compile_Global;

/*
	A3PL_InventoryNew_GridShowDropPreview
	Montre la preview de drop (valide/invalide)
	Params: [display, targetCtrl]
*/
["A3PL_InventoryNew_GridShowDropPreview", {
	params [
		["_display", displayNull, [displayNull]],
		["_targetCtrl", controlNull, [controlNull]]
	];

	if (isNull _display || isNull _targetCtrl) exitWith {};

	private _dragItem = _display getVariable ["grid_dragItem", []];
	if (_dragItem isEqualTo []) exitWith {};

	_dragItem params ["_classname"];
	private _rotated = _display getVariable ["grid_dragRotated", false];
	private _targetPos = _targetCtrl getVariable ["gridPos", [-1, -1]];

	if (_targetPos isEqualTo [-1, -1]) exitWith {};

	private _grid = _display getVariable ["currentGrid", []];
	if (_grid isEqualTo []) exitWith {};

	private _isVirtual = _display getVariable ["grid_isVirtual", false];

	// Retirer temporairement l'item source pour la verification
	private _tempGrid = +_grid;
	_dragItem params ["_srcClass", "_srcX", "_srcY", "_srcRotated", "_srcCount"];
	_tempGrid = ([_tempGrid, _srcX, _srcY, _isVirtual] call A3PL_InventoryNew_RemoveItemAt)#0;

	// Verifier si le placement est valide
	private _canPlace = [_tempGrid, _classname, _targetPos#0, _targetPos#1, _rotated, _isVirtual] call A3PL_InventoryNew_CanPlaceItem;

	// Colorer les cellules concernees
	private _itemSize = [_classname] call A3PL_InventoryNew_GetItemGridSize;
	private _itemW = if (_rotated) then {_itemSize#1} else {_itemSize#0};
	private _itemH = if (_rotated) then {_itemSize#0} else {_itemSize#1};

	private _gridCols = count (_grid#0);
	private _color = if (_canPlace) then {Inventory_Grid_CellColorValid} else {Inventory_Grid_CellColorInvalid};

	for "_y" from (_targetPos#1) to ((_targetPos#1) + _itemH - 1) do {
		for "_x" from (_targetPos#0) to ((_targetPos#0) + _itemW - 1) do {
			if (_x >= 0 && _y >= 0 && _x < _gridCols && _y < count _grid) then {
				private _cellIndex = _y * _gridCols + _x;
				private _cellCtrl = _display displayCtrl (INVENTORY_GRID_CELL_BASE_IDC + _cellIndex);
				if (!isNull _cellCtrl) then {
					_cellCtrl ctrlSetBackgroundColor _color;
				};
			};
		};
	};
}] call compile_Global;

/*
	A3PL_InventoryNew_GridClearDropPreview
	Reset les couleurs de preview apres MouseExit
	Params: display
*/
["A3PL_InventoryNew_GridClearDropPreview", {
	params [["_display", displayNull, [displayNull]]];

	if (isNull _display) exitWith {};

	private _grid = _display getVariable ["currentGrid", []];
	if (_grid isEqualTo []) exitWith {};

	private _gridCols = count (_grid#0);
	private _gridRows = count _grid;

	// Parcourir toutes les cellules et reset leur couleur
	for "_y" from 0 to (_gridRows - 1) do {
		for "_x" from 0 to (_gridCols - 1) do {
			private _cellIndex = _y * _gridCols + _x;
			private _cellCtrl = _display displayCtrl (INVENTORY_GRID_CELL_BASE_IDC + _cellIndex);
			if (!isNull _cellCtrl) then {
				private _cellData = _grid#_y#_x;
				if ([_cellData] call A3PL_InventoryNew_IsCellEmpty) then {
					_cellCtrl ctrlSetBackgroundColor Inventory_Grid_CellColorEmpty;
				} else {
					// Case occupee par un item - transparente car item par dessus
					_cellCtrl ctrlSetBackgroundColor [0, 0, 0, 0];
				};
			};
		};
	};
}] call compile_Global;

/*
	A3PL_InventoryNew_GridDropItem
	Drop un item a une position
	Params: [display, targetCtrl]
*/
["A3PL_InventoryNew_GridDropItem", {
	params [
		["_display", displayNull, [displayNull]],
		["_targetCtrl", controlNull, [controlNull]]
	];

	if (isNull _display) exitWith {
		diag_log "GridDropItem: display is null";
	};

	private _dragItem = _display getVariable ["grid_dragItem", []];
	if (_dragItem isEqualTo []) exitWith {
		diag_log "GridDropItem: dragItem is empty";
	};

	_dragItem params ["_classname", "_srcX", "_srcY", "_srcRotated", "_count"];
	private _rotated = _display getVariable ["grid_dragRotated", false];
	private _isVirtual = _display getVariable ["grid_isVirtual", false];

	diag_log format ["GridDropItem: item=%1, src=[%2,%3], rotated=%4, count=%5, isVirtual=%6", _classname, _srcX, _srcY, _srcRotated, _count, _isVirtual];

	private _targetPos = if (!isNull _targetCtrl) then {
		_targetCtrl getVariable ["gridPos", [-1, -1]]
	} else {
		[-1, -1]
	};
	diag_log format ["GridDropItem: targetPos=%1", _targetPos];

	private _grid = _display getVariable ["currentGrid", []];
	if (_grid isEqualTo []) exitWith {
		diag_log "GridDropItem: grid is empty, cancelling";
		[_display] call A3PL_InventoryNew_GridCancelDrag;
	};

	diag_log format ["GridDropItem: grid rows=%1, first row type=%2", count _grid, typeName (_grid#0)];

	// Retirer l'item de sa position source
	private _result = [_grid, _srcX, _srcY, _isVirtual] call A3PL_InventoryNew_RemoveItemAt;
	diag_log format ["GridDropItem: RemoveItemAt returned, result count=%1, result#0 type=%2, result#1=%3", count _result, typeName (_result#0), _result#1];
	_grid = _result#0;
	diag_log format ["GridDropItem: after remove, grid rows=%1", count _grid];

	private _success = false;

	if !(_targetPos isEqualTo [-1, -1]) then {
		// Verifier si on peut placer l'item
		private _canPlace = [_grid, _classname, _targetPos#0, _targetPos#1, _rotated, _isVirtual] call A3PL_InventoryNew_CanPlaceItem;
		diag_log format ["GridDropItem: canPlace=%1 at [%2,%3]", _canPlace, _targetPos#0, _targetPos#1];
		if (_canPlace) then {
			_grid = [_grid, _classname, _targetPos#0, _targetPos#1, _rotated, _count, _isVirtual] call A3PL_InventoryNew_PlaceItem;
			_success = true;
			diag_log "GridDropItem: item placed successfully";
		};
	};

	if (!_success) then {
		// Remettre l'item a sa position originale
		diag_log format ["GridDropItem: placing back at original position [%1,%2]", _srcX, _srcY];
		_grid = [_grid, _classname, _srcX, _srcY, _srcRotated, _count, _isVirtual] call A3PL_InventoryNew_PlaceItem;
	};

	// Nettoyer le drag
	[_display] call A3PL_InventoryNew_GridCancelDrag;

	// Mettre a jour la variable globale de la grille AVANT le render
	if (_isVirtual) then {
		player setVariable ["player_inventory_grid", _grid];
		diag_log "GridDropItem: updated player_inventory_grid";
	};

	// Mettre a jour l'affichage
	private _gridSize = _display getVariable ["currentGridSize", [5, 4]];
	diag_log format ["GridDropItem: calling RenderGrid with gridSize=%1, grid rows=%2", _gridSize, count _grid];
	[_display, _grid, _gridSize, _isVirtual] call A3PL_InventoryNew_RenderGrid;

	// Sauvegarder le layout si succes
	if (_success) then {
		private _filterType = _display getVariable ["currentFilter", "all"];
		[_filterType, _grid] call A3PL_InventoryNew_SaveGridLayout;
		diag_log format ["GridDropItem: layout saved for filter=%1", _filterType];
	};
}] call compile_Global;

/*
	A3PL_InventoryNew_GridCancelDrag
	Annule le drag en cours
	Params: display
*/
["A3PL_InventoryNew_GridCancelDrag", {
	params [["_display", displayNull, [displayNull]]];

	if (isNull _display) exitWith {};

	_display setVariable ["grid_isDragging", false];
	_display setVariable ["grid_dragItem", []];
	_display setVariable ["grid_dragRotated", false];
	_display setVariable ["grid_dragSize", [0, 0]];
	_display setVariable ["grid_dragJustStarted", false];

	// Cacher le tooltip
	[_display] call A3PL_InventoryNew_GridHideTooltip;

	// Retirer le handler MouseMoving
	_display displayRemoveAllEventHandlers "MouseMoving";

	// Cacher le drag picture
	private _dragPic = _display displayCtrl INVENTORY_GRID_DRAG_PICTURE_IDC;
	if (!isNull _dragPic) then {
		_dragPic ctrlShow false;
		_dragPic ctrlSetText "";
		_dragPic ctrlSetPosition [0, 0, 0, 0];
		_dragPic ctrlCommit 0;
	};

	// Restaurer la source si elle existe
	private _sourceCtrl = _display getVariable ["grid_dragSourceCtrl", controlNull];
	if (!isNull _sourceCtrl) then {
		_sourceCtrl ctrlSetBackgroundColor Inventory_Grid_CellColorOccupied;
	};
	_display setVariable ["grid_dragSourceCtrl", controlNull];
}] call compile_Global;

/*
	A3PL_InventoryNew_GridRotateItem
	Tourne l'item en cours de drag
	Params: display
*/
["A3PL_InventoryNew_GridRotateItem", {
	params [["_display", displayNull, [displayNull]]];

	if (isNull _display) exitWith {};

	private _isDragging = _display getVariable ["grid_isDragging", false];
	if (!_isDragging) exitWith {};

	private _dragItem = _display getVariable ["grid_dragItem", []];
	if (_dragItem isEqualTo []) exitWith {};

	_dragItem params ["_classname"];

	// Inverser la rotation
	private _rotated = _display getVariable ["grid_dragRotated", false];
	_rotated = !_rotated;
	_display setVariable ["grid_dragRotated", _rotated];

	// Mettre a jour la taille du drag picture
	private _dragPic = _display displayCtrl INVENTORY_GRID_DRAG_PICTURE_IDC;
	if (!isNull _dragPic) then {
		private _itemSize = [_classname] call A3PL_InventoryNew_GetItemGridSize;
		private _itemW = if (_rotated) then {_itemSize#1} else {_itemSize#0};
		private _itemH = if (_rotated) then {_itemSize#0} else {_itemSize#1};

		private _cellW = Inventory_Grid_CellWidth * safezoneW;
		private _cellH = Inventory_Grid_CellHeight * safezoneH;

		private _pos = ctrlPosition _dragPic;
		private _centerX = (_pos#0) + (_pos#2)/2;
		private _centerY = (_pos#1) + (_pos#3)/2;

		private _w = _itemW * _cellW;
		private _h = _itemH * _cellH;

		_dragPic ctrlSetPosition [_centerX - _w/2, _centerY - _h/2, _w, _h];
		_dragPic ctrlCommit 0;
	};
}] call compile_Global;

// ============================================================================
// VIRTUAL ITEMS FUNCTIONS
// ============================================================================

/*
	A3PL_InventoryNew_GetVirtualItems
	Retourne la liste des items virtuels du joueur
	Format retourne: array de classnames (pour compatibilite avec FormatInv)
	Le cash est traite separement - utilise Player_Cash et un seul item
	Returns: array
*/
["A3PL_InventoryNew_GetVirtualItems", {
	private _inventory = player getVariable ["player_inventory", []];
	private _items = [];

	{
		_x params ["_class", "_amount"];
		// Ignorer le cash dans player_inventory - il est gere via Player_Cash
		if (_class isEqualTo "cash") then {
			continue;
		};
		// Ajouter autant de fois que la quantite (pour FormatInv)
		for "_i" from 1 to _amount do {
			_items pushBack _class;
		};
	} forEach _inventory;

	// Ajouter le cash depuis Player_Cash (un seul item)
	private _cashAmount = player getVariable ["Player_Cash", 0];
	if (_cashAmount > 0) then {
		_items pushBack "cash";
	};

	_items
}] call compile_Global;

/*
	A3PL_InventoryNew_GetKeysItems
	Retourne la liste des cles du joueur (maisons, motels, warehouses, crackhouses)
	Format retourne: array de strings (keyID)
	Returns: array
*/
["A3PL_InventoryNew_GetKeysItems", {
	private _keys = player getVariable ["keys", []];
	if (isNil "_keys") then { _keys = [] };
	_keys
}] call compile_Global;

/*
	A3PL_InventoryNew_GetKeyDisplayName
	Retourne le nom d'affichage d'une cle en fonction de son ID
	Params: keyID (string)
	Returns: string
*/
["A3PL_InventoryNew_GetKeyDisplayName", {
	params [["_keyID", "", [""]]];

	private _len = count _keyID;
	private _name = switch (_len) do {
		case 4: { format ["Greenhouse Key (%1)", _keyID] };
		case 5: { format ["House Key (%1)", _keyID] };
		case 6: { "Motel Key" };
		case 8: { format ["Warehouse Key (%1)", _keyID] };
		case 9: { format ["Crackhouse Key (%1)", _keyID] };
		default { format ["Key (%1)", _keyID] };
	};

	_name
}] call compile_Global;

/*
	A3PL_InventoryNew_GetLicensesItems
	Retourne la liste des licences du joueur
	Format retourne: array de strings (licenseClass)
	Returns: array
*/
["A3PL_InventoryNew_GetLicensesItems", {
	private _licenses = player getVariable ["licenses", []];
	if (isNil "_licenses") then { _licenses = [] };
	_licenses
}] call compile_Global;

/*
	A3PL_InventoryNew_GetLicenseDisplayName
	Retourne le nom d'affichage d'une licence en fonction de sa classe
	Utilise A3PL_Config_GetLicenseData pour recuperer le nom
	Params: licenseClass (string)
	Returns: string
*/
["A3PL_InventoryNew_GetLicenseDisplayName", {
	params [["_licenseClass", "", [""]]];

	private _name = [_licenseClass, 0] call A3PL_Config_GetLicenseData;
	if (isNil "_name" || {_name isEqualTo ""}) then {
		_name = _licenseClass;
	};

	_name
}] call compile_Global;

/*
	A3PL_InventoryNew_GetVirtualLoad
	Retourne la charge actuelle de l'inventaire virtuel (ratio 0-1)
	Returns: number
*/
["A3PL_InventoryNew_GetVirtualLoad", {
	private _totalWeight = [] call A3PL_Inventory_TotalWeight;
	private _maxWeight = 250; // Poids max par defaut

	(_totalWeight / _maxWeight) min 1
}] call compile_Global;

/*
	A3PL_InventoryNew_GetVirtualGridSize
	Retourne la taille de grille pour l'inventaire virtuel
	Les joueurs premium ont une grille plus grande
	Returns: [colonnes, lignes]
*/
["A3PL_InventoryNew_GetVirtualGridSize", {
	// Verifier si le joueur est premium
	private _isPremium = (player getVariable ["perk_day", 0]) > 0;

	// Verifier si le joueur porte un sac à dos
	private _hasBackpack = !((backpack player) isEqualTo "");

	// Calculer la taille totale de la grille
	private _baseGrid = Inventory_Grid_Virtual_Default;
	private _width = _baseGrid#0;
	private _height = _baseGrid#1;

	// Ajouter les lignes du sac à dos si équipé
	if (_hasBackpack) then {
		// Check if player has the back_steel trait
		private _traits = player getVariable ["Player_Traits", []];
		private _hasBackSteelTrait = "back_steel" in _traits;

		// Back_steel trait: increase backpack grid from [8,4] to [8,7]
		private _backpackGrid = Inventory_Grid_Virtual_Backpack;
		if (_hasBackSteelTrait) then {
			_backpackGrid = Inventory_Grid_Virtual_Backpack_With_Trait;
		};
		_height = _height + (_backpackGrid#1);
	};

	// Ajouter les lignes premium si le joueur est premium
	if (_isPremium) then {
		private _premiumGrid = Inventory_Grid_Virtual_Premium;
		_height = _height + (_premiumGrid#1);
	};

	[_width, _height]
}] call compile_Global;

/*
	A3PL_InventoryNew_MigrateVirtualOverflow
	Verifie si des items virtuels sont dans des slots hors grille (ex: joueur non-premium)
	et les deplace vers des slots libres ou les jette au sol
	Cette fonction est appelee a l'ouverture du filtre virtuel
*/
["A3PL_InventoryNew_MigrateVirtualOverflow", {
	private _gridSize = [] call A3PL_InventoryNew_GetVirtualGridSize;
	private _maxCols = _gridSize#0;
	private _maxRows = _gridSize#1;
	private _maxSlots = _maxCols * _maxRows;

	// Recuperer l'inventaire virtuel
	private _inventory = player getVariable ["player_inventory", []];
	private _totalItems = 0;

	// Compter le nombre total d'items (en tenant compte des stacks)
	{
		_x params ["_class", "_amount"];
		private _itemSize = [_class] call A3PL_InventoryNew_GetVirtualItemGridSize;
		private _maxStack = _itemSize#2;

		// Nombre de slots necessaires pour cet item
		private _slotsNeeded = ceil (_amount / _maxStack);
		_totalItems = _totalItems + _slotsNeeded;
	} forEach _inventory;

	// Si le nombre total d'items depasse la grille, on doit migrer
	if (_totalItems > _maxSlots) then {
		private _overflow = _totalItems - _maxSlots;
		private _droppedItems = [];

		diag_log format ["A3PL_InventoryNew_MigrateVirtualOverflow: Overflow detected, %1 slots over limit", _overflow];

		// Parcourir l'inventaire en sens inverse pour supprimer les derniers items
		private _inventoryReverse = +_inventory;
		reverse _inventoryReverse;

		private _slotsToFree = _overflow;

		{
			if (_slotsToFree <= 0) exitWith {};

			_x params ["_class", "_amount"];
			private _itemSize = [_class] call A3PL_InventoryNew_GetVirtualItemGridSize;
			private _maxStack = _itemSize#2;

			// Combien de stacks cet item occupe
			private _slotsUsed = ceil (_amount / _maxStack);

			if (_slotsUsed <= _slotsToFree) then {
				// Jeter tout cet item
				[false, _amount, _class] call A3PL_Inventory_Drop;
				_droppedItems pushBack [_class, _amount];
				_slotsToFree = _slotsToFree - _slotsUsed;
				diag_log format ["A3PL_InventoryNew_MigrateVirtualOverflow: Dropped all %1x %2", _amount, _class];
			} else {
				// Jeter partiellement
				private _amountToDrop = _slotsToFree * _maxStack;
				if (_amountToDrop > _amount) then {_amountToDrop = _amount};
				[false, _amountToDrop, _class] call A3PL_Inventory_Drop;
				_droppedItems pushBack [_class, _amountToDrop];
				_slotsToFree = 0;
				diag_log format ["A3PL_InventoryNew_MigrateVirtualOverflow: Dropped partial %1x %2", _amountToDrop, _class];
			};
		} forEach _inventoryReverse;

		// Notifier le joueur
		if (count _droppedItems > 0) then {
			["STR_A3PL_Inventory_ErrItemAddedFloor" call A3PL_Localize, [1, 0.5, 0, 1]] call A3PL_Notification;
		};

		// Effacer le layout sauvegarde pour forcer un re-calcul
		private _varName = "A3PL_InventoryGrid_virtual";
		profileNamespace setVariable [_varName, nil];
		saveProfileNamespace;
	};
}] call compile_Global;

/*
	A3PL_InventoryNew_FetchVirtualItemInfo
	Recupere les infos d'un item virtuel depuis Config_ItemMap
	Params: classname
	Returns: [classname, displayName, picture, description, weight]
*/
["A3PL_InventoryNew_FetchVirtualItemInfo", {
	params [["_class", "", [""]]];

	if (_class isEqualTo "") exitWith {["", "", "", "", 0]};

	// Cas special: Cash
	if (_class isEqualTo "cash") exitWith {
		private _cashAmount = player getVariable ["Player_Cash", 0];
		private _formattedCash = [_cashAmount, 1, 0, true] call CBA_fnc_formatNumber;
		["cash", format ["$%1", _formattedCash], "po_ui\Data\items\cash.paa", "", 0]
	};

	private _name = [_class, "name"] call A3PL_Config_GetItem;
	private _picture = [_class, "picture"] call A3PL_Config_GetItem;
	private _desc = [_class, "desc"] call A3PL_Config_GetItem;
	private _weight = [_class, "weight"] call A3PL_Config_GetItem;

	// Si pas trouve, utiliser le classname comme nom
	if (isNil "_name" || {_name isEqualTo ""}) then {
		_name = _class;
	};
	if (isNil "_picture") then {_picture = "";};
	if (isNil "_desc") then {_desc = "";};
	if (isNil "_weight") then {_weight = 0;};

	[_class, _name, _picture, _desc, _weight]
}] call compile_Global;

/*
	A3PL_InventoryNew_IsVirtualItem
	Verifie si un item est un item virtuel (existe dans Config_ItemMap)
	Params: classname
	Returns: bool
*/
["A3PL_InventoryNew_IsVirtualItem", {
	params [["_class", "", [""]]];

	if (_class isEqualTo "") exitWith {false};

	private _name = [_class, "name"] call A3PL_Config_GetItem;
	!(isNil "_name" || {_name isEqualTo ""})
}] call compile_Global;

/*
	A3PL_InventoryNew_GetVirtualItemGridSize
	Retourne la taille d'un item virtuel dans la grille
	Les items virtuels sont tous 1x1 par defaut, stackables
	Params: classname
	Returns: [width, height, maxStack]
*/
["A3PL_InventoryNew_GetVirtualItemGridSize", {
	params [["_class", "", [""]]];

	// Verifier si l'item a une taille custom dans Inventory_Grid_Items
	private _customSize = Inventory_Grid_Items getOrDefault [_class, []];

	if !(_customSize isEqualTo []) exitWith {_customSize};

	// Utiliser _default si l'item n'est pas trouve
	private _defaultSize = Inventory_Grid_Items getOrDefault ["_default", [1, 1, 10]];
	_defaultSize
}] call compile_Global;

/*
	A3PL_InventoryNew_VirtualInventoryToGrid
	Convertit l'inventaire virtuel en structure de grille
	Params: [gridSize, savedLayout]
	Returns: grid array
*/
["A3PL_InventoryNew_VirtualInventoryToGrid", {
	params [
		["_gridSize", [8, 6], [[]]],
		["_savedLayout", [], [[]]]
	];

	private _cols = _gridSize#0;
	private _rows = _gridSize#1;

	// Initialiser grille vide
	private _grid = [];
	for "_y" from 0 to (_rows - 1) do {
		private _row = [];
		for "_x" from 0 to (_cols - 1) do {
			_row pushBack "";
		};
		_grid pushBack _row;
	};

	// Recuperer l'inventaire virtuel - copie pour tracking
	private _inventory = +(player getVariable ["player_inventory", []]);
	private _itemsToPlace = createHashMap;

	// Creer une hashmap avec les quantites de chaque item
	// Ignorer le cash dans player_inventory - il est gere via Player_Cash
	{
		_x params ["_class", "_amount"];
		if (_amount > 0 && !(_class isEqualTo "cash")) then {
			_itemsToPlace set [_class, _amount];
		};
	} forEach _inventory;

	// Ajouter le cash comme item special depuis Player_Cash (un seul item)
	private _cash = player getVariable ["Player_Cash", 0];
	if (_cash > 0) then {
		_itemsToPlace set ["cash", _cash];
	};

	// D'abord, placer les items selon le layout sauvegarde
	{
		_x params ["_class", "_posX", "_posY", "_rotated"];

		// Verifier si on a encore cet item a placer
		private _remaining = _itemsToPlace getOrDefault [_class, 0];
		if (_remaining > 0) then {
			private _itemSize = [_class] call A3PL_InventoryNew_GetVirtualItemGridSize;
			private _itemW = if (_rotated) then {_itemSize#1} else {_itemSize#0};
			private _itemH = if (_rotated) then {_itemSize#0} else {_itemSize#1};
			private _maxStack = _itemSize#2;

			// Verifier que la position est dans les limites
			if (_posX >= 0 && _posY >= 0 && _posX + _itemW <= _cols && _posY + _itemH <= _rows) then {
				// Verifier que la place est libre
				private _canPlace = true;
				for "_dy" from 0 to (_itemH - 1) do {
					for "_dx" from 0 to (_itemW - 1) do {
						private _cellContent = (_grid#(_posY + _dy))#(_posX + _dx);
						if !(_cellContent isEqualTo "") then {
							_canPlace = false;
						};
					};
				};

				if (_canPlace) then {
					// Cas special: cash - toujours un seul item avec le montant total
					private _stackAmount = if (_class isEqualTo "cash") then {
						_remaining
					} else {
						_remaining min _maxStack
					};
					private _itemData = [_class, _posX, _posY, _rotated, _stackAmount];

					for "_dy" from 0 to (_itemH - 1) do {
						for "_dx" from 0 to (_itemW - 1) do {
							(_grid#(_posY + _dy)) set [_posX + _dx, _itemData];
						};
					};

					// Mettre a jour la quantite restante
					_itemsToPlace set [_class, _remaining - _stackAmount];
				};
			};
		};
	} forEach _savedLayout;

	// Ensuite, placer les items restants automatiquement
	private _currentX = 0;
	private _currentY = 0;

	{
		private _class = _x;
		private _remaining = _y;

		while {_remaining > 0 && _currentY < _rows} do {
			private _itemSize = [_class] call A3PL_InventoryNew_GetVirtualItemGridSize;
			private _itemW = _itemSize#0;
			private _itemH = _itemSize#1;
			private _maxStack = _itemSize#2;

			// Cas special: cash - toujours un seul item avec le montant total
			private _stackAmount = if (_class isEqualTo "cash") then {
				_remaining
			} else {
				_remaining min _maxStack
			};
			private _placed = false;

			while {!_placed && _currentY < _rows} do {
				if (_currentX + _itemW <= _cols && _currentY + _itemH <= _rows) then {
					// Verifier si la place est libre
					private _canPlace = true;
					for "_dy" from 0 to (_itemH - 1) do {
						for "_dx" from 0 to (_itemW - 1) do {
							private _cellContent = (_grid#(_currentY + _dy))#(_currentX + _dx);
							if !(_cellContent isEqualTo "") then {
								_canPlace = false;
							};
						};
					};

					if (_canPlace) then {
						private _itemData = [_class, _currentX, _currentY, false, _stackAmount];

						for "_dy" from 0 to (_itemH - 1) do {
							for "_dx" from 0 to (_itemW - 1) do {
								(_grid#(_currentY + _dy)) set [_currentX + _dx, _itemData];
							};
						};

						_placed = true;
						_remaining = _remaining - _stackAmount;

						// Avancer a la prochaine position pour le prochain stack
						_currentX = _currentX + _itemW;
						if (_currentX >= _cols) then {
							_currentX = 0;
							_currentY = _currentY + 1;
						};
					};
				};

				if (!_placed) then {
					_currentX = _currentX + 1;
					if (_currentX >= _cols) then {
						_currentX = 0;
						_currentY = _currentY + 1;
					};
				};
			};
		};
	} forEach _itemsToPlace;

	_grid
}] call compile_Global;

// ============================================================================
// INPUT AMOUNT DIALOG
// Affiche un dialog pour entrer une quantite
// Params: [_title, _message, _maxAmount, _callback, _closeInventory]
// ============================================================================

["A3PL_InventoryNew_InputAmount", {
	params [
		["_title", "Amount", [""]],
		["_message", "Enter amount:", [""]],
		["_maxAmount", 1, [0]],
		["_callback", {}, [{}]],
		["_closeInventory", false, [false]]
	];

	// Stocker le callback et les infos pour utilisation apres validation
	uiNamespace setVariable ["A3PL_InputAmount_Callback", _callback];
	uiNamespace setVariable ["A3PL_InputAmount_MaxAmount", _maxAmount];
	uiNamespace setVariable ["A3PL_InputAmount_Item", _item];
	uiNamespace setVariable ["A3PL_InputAmount_Count", _count];
	uiNamespace setVariable ["A3PL_InputAmount_CloseInventory", _closeInventory];

	// Creer le dialog d'entree
	private _display = findDisplay INVENTORY_DISPLAY_IDD;
	if (isNull _display) exitWith {};

	// Supprimer ancien dialog si existe
	private _oldGroup = _display displayCtrl 9900;
	if (!isNull _oldGroup) then {
		ctrlDelete _oldGroup;
	};

	// Creer le groupe conteneur
	private _group = _display ctrlCreate ["RscControlsGroup", 9900];
	_group ctrlSetPosition [
		0.35 * safezoneW + safezoneX,
		0.35 * safezoneH + safezoneY,
		0.3 * safezoneW,
		0.2 * safezoneH
	];
	_group ctrlCommit 0;

	// Background
	private _bg = _display ctrlCreate ["RscText", 9901, _group];
	_bg ctrlSetPosition [0, 0, 0.3 * safezoneW, 0.2 * safezoneH];
	_bg ctrlSetBackgroundColor [0.1, 0.1, 0.1, 0.95];
	_bg ctrlCommit 0;

	// Title
	private _titleCtrl = _display ctrlCreate ["RscText", 9902, _group];
	_titleCtrl ctrlSetPosition [0.01 * safezoneW, 0.01 * safezoneH, 0.28 * safezoneW, 0.03 * safezoneH];
	_titleCtrl ctrlSetText _title;
	_titleCtrl ctrlSetTextColor [1, 1, 1, 1];
	_titleCtrl ctrlCommit 0;

	// Message
	private _msgCtrl = _display ctrlCreate ["RscText", 9903, _group];
	_msgCtrl ctrlSetPosition [0.01 * safezoneW, 0.05 * safezoneH, 0.28 * safezoneW, 0.03 * safezoneH];
	_msgCtrl ctrlSetText _message;
	_msgCtrl ctrlSetTextColor [0.8, 0.8, 0.8, 1];
	_msgCtrl ctrlCommit 0;

	// Input field
	private _input = _display ctrlCreate ["RscEdit", 9904, _group];
	_input ctrlSetPosition [0.01 * safezoneW, 0.09 * safezoneH, 0.28 * safezoneW, 0.035 * safezoneH];
	_input ctrlSetBackgroundColor [0.2, 0.2, 0.2, 1];
	_input ctrlSetText "1";
	_input ctrlCommit 0;
	ctrlSetFocus _input;

	// Bouton Confirm
	private _btnConfirm = _display ctrlCreate ["RscButton", 9905, _group];
	_btnConfirm ctrlSetPosition [0.01 * safezoneW, 0.14 * safezoneH, 0.13 * safezoneW, 0.04 * safezoneH];
	_btnConfirm ctrlSetText "Confirm";
	_btnConfirm ctrlSetBackgroundColor [0.2, 0.5, 0.2, 1];
	_btnConfirm ctrlAddEventHandler ["ButtonClick", {
		params ["_ctrl"];
		private _display = ctrlParent _ctrl;
		private _input = _display displayCtrl 9904;
		private _group = _display displayCtrl 9900;

		private _value = parseNumber (ctrlText _input);
		private _maxAmount = uiNamespace getVariable ["A3PL_InputAmount_MaxAmount", 1];
		private _callback = uiNamespace getVariable ["A3PL_InputAmount_Callback", {}];
		private _item = uiNamespace getVariable ["A3PL_InputAmount_Item", ""];
		private _count = uiNamespace getVariable ["A3PL_InputAmount_Count", 0];
		private _closeInventory = uiNamespace getVariable ["A3PL_InputAmount_CloseInventory", false];

		// Valider la valeur
		if (_value < 1) then { _value = 1 };
		if (_value > _maxAmount) then { _value = _maxAmount };
		_value = floor _value;

		// Fermer le dialog input
		ctrlDelete _group;

		// Fermer l'inventaire si demande (pour drop)
		if (_closeInventory) then {
			(findDisplay INVENTORY_DISPLAY_IDD) closeDisplay 0;
		};

		// Executer le callback avec _item, _count et _amount disponibles
		[_value, _item, _count, _callback] spawn {
			params ["_amount", "_item", "_count", "_callback"];
			[_amount, _item, _count] call _callback;
		};

		// Rafraichir l'inventaire si pas ferme
		if (!_closeInventory) then {
			[] call A3PL_InventoryNew_RefreshGrid;
		};
	}];
	_btnConfirm ctrlCommit 0;

	// Bouton Cancel
	private _btnCancel = _display ctrlCreate ["RscButton", 9906, _group];
	_btnCancel ctrlSetPosition [0.16 * safezoneW, 0.14 * safezoneH, 0.13 * safezoneW, 0.04 * safezoneH];
	_btnCancel ctrlSetText "Cancel";
	_btnCancel ctrlSetBackgroundColor [0.5, 0.2, 0.2, 1];
	_btnCancel ctrlAddEventHandler ["ButtonClick", {
		params ["_ctrl"];
		private _display = ctrlParent _ctrl;
		private _group = _display displayCtrl 9900;
		ctrlDelete _group;
	}];
	_btnCancel ctrlCommit 0;

}] call compile_Global;

/*
	A3PL_Inventory_DropCash
	Drop cash from the new inventory system
	Params: amount
*/
["A3PL_Inventory_DropCash", {
	params [["_amount", 0, [0]]];

	private _cashAmount = player getVariable ["Player_Cash", 0];

	if (_amount < 1) exitWith {
		["STR_A3PL_Inventory_DropCashMinimum" call A3PL_Localize, [1, 0.2, 0.2, 1]] call A3PL_Notification;
	};

	if (_amount > _cashAmount) exitWith {
		[format ["STR_A3PL_Inventory_DropCashNotEnough" call A3PL_Localize, _amount, _cashAmount], [1, 0.2, 0.2, 1]] call A3PL_Notification;
	};

	// Use the existing A3PL_Inventory_Use and A3PL_Inventory_Drop system
	Player_ItemClass = "cash";
	Player_ItemAmount = _amount;
	["cash", true] call A3PL_Inventory_Use;
	[true, _amount] call A3PL_Inventory_Drop;
}] call compile_Global;

["A3PL_Inventory_Use",
{
	disableSerialization;
	private ['_selection', '_classname', '_itemClass', '_itemDir', '_canUse', '_format',"_display","_attach"];
	_className = param [0,""];
	_forDrop = param [1,false];
	_customAmount = param [2, -1];
	_amount = 1;
	if (_className isEqualTo "") then
	{
		_display = findDisplay 1001;
		_selection = lbCurSel 14571;
		_classname = lbData [14571, _selection];
		_amount = floor(parseNumber (ctrlText (_display displayCtrl 14471)));
	} else {
		if (_customAmount > 0) then {
			_amount = _customAmount;
		};
	};

	if !(call A3PL_InventoryNew_CanPerformItemAction) exitWith {};

	_itemClass = [_classname, 'class'] call A3PL_Config_GetItem;
	_itemDir = [_classname, 'dir'] call A3PL_Config_GetItem;
	_canUse = [_classname, 'canUse'] call A3PL_Config_GetItem;
	_attach = [_classname, 'attach'] call A3PL_Config_GetItem;
	_maxTake = [_classname, 'maxTake'] call A3PL_Config_GetItem;

	if (_canUse isEqualTo false) exitWith {["STR_A3PL_Inventory_CantBeUsed" call A3PL_Localize,Color_Red] call A3PL_Notification;};
	if ((animationState player) isEqualTo "A3PL_TakenHostage") exitwith {["STR_A3PL_Inventory_CantUseHostage" call A3PL_Localize,Color_Red] call A3PL_Notification;};
	if (animationState player IN ["a3pl_handsuptokneel","a3pl_handsupkneelgetcuffed","a3pl_cuff","a3pl_handsupkneelcuffed","a3pl_handsupkneelkicked","a3pl_cuffkickdown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","a3pl_handsupkneel"]) exitWith {["STR_A3PL_Inventory_CantUseHandcuffed" call A3PL_Localize,Color_Red] call A3PL_Notification;};
	if (!(isNull Player_Item)) then {[false] call A3PL_Inventory_PutBack;};

	if (_amount < 1) exitWith {["STR_A3PL_Inventory_DoesntHaveThisAmountToTake" call A3PL_Localize,Color_Red] call A3PL_Notification;};
	if (!([_classname,_amount] call A3PL_Inventory_Has)) exitwith {["STR_A3PL_Inventory_DoesntHaveThisAmountToTake" call A3PL_Localize,Color_Red] call A3PL_Notification;};

	_maxTakeErr = false;
	if(!_forDrop) then {
		if (_amount > _maxTake) exitwith {
			[format["STR_A3PL_Inventory_MaxTake" call A3PL_Localize,_maxTake],Color_Red] call A3PL_Notification;
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
	private _amount = if (isNil "Player_ItemAmount") then {1} else {Player_ItemAmount};

	if (_itemClass isEqualTo "") exitwith {["There is no itemClass assigned",Color_Red] call A3PL_Notification;};
	if !((Player_Item getVariable["evidence",""]) isEqualTo "") exitWith {["STR_A3PL_Inventory_CantBeStoredInYourInventory" call A3PL_Localize,Color_Red] call A3PL_Notification;};

	detach Player_Item;
	deleteVehicle Player_Item;

	Player_Item = objNull;
	Player_ItemClass = '';
	Player_ItemAmount = nil;
	if (_displayNotification isEqualTo true) then {
		if (!(animationState player IN ["crew"])) then {
			player playMove 'AmovPercMstpSnonWnonDnon_AmovPercMstpSrasWpstDnon';
		};
		private _format = format["STR_A3PL_Inventory_YouStored" call A3PL_Localize, [_itemClass, 'name'] call A3PL_Config_GetItem];
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

	if !([_itemClass] call A3PL_InventoryNew_CanPerformItemAction) exitWith {};

	if(_amount < 1) exitWith {["STR_A3PL_Inventory_EnterValidAmount" call A3PL_Localize,Color_Red] call A3PL_Notification;};
	if (!([_itemClass,_amount] call A3PL_Inventory_Has)) exitwith {["STR_A3PL_Inventory_DontHaveThisAmountToDrop" call A3PL_Localize,Color_Red] call A3PL_Notification;};
	if (isNull _obj) exitwith {["STR_A3PL_Inventory_NothingToDropInYourHands" call A3PL_Localize,Color_Red] call A3PL_Notification;};
	if (!isNil "Player_isEating") exitwith {["STR_A3PL_Inventory_CantDoThisByEating" call A3PL_Localize,Color_Red] call A3PL_Notification;};
	if (!isNil "Player_isDrinking") exitwith {["STR_A3PL_Inventory_CantDoThisByDrinking" call A3PL_Localize,Color_Red] call A3PL_Notification;};
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
	[format["STR_A3PL_Inventory_YouDropped" call A3PL_Localize, _amount, [_itemClass, 'name'] call A3PL_Config_GetItem],Color_Green] call A3PL_Notification;
}] call compile_Global;

/*
	A3PL_Inventory_Give
	Donne un item de l'inventaire virtuel a un autre joueur
	Params: [item classname, amount]
	Return: void
*/
["A3PL_Inventory_Give", {
	params [
		["_item", "", [""]],
		["_amount", 1, [0]]
	];

	if (_item isEqualTo "" || _amount < 1) exitWith {};

	if !(call A3PL_InventoryNew_CanPerformItemAction) exitWith {};

	if !([_item, _amount] call A3PL_Inventory_Has) exitWith {
		["STR_A3PL_Inventory_DoesntHaveThisAmountToTake" call A3PL_Localize, Color_Red] call A3PL_Notification;
	};

	// Chercher le joueur le plus proche dans 3m
	private _targetPlayer = objNull;
	private _nearPlayers = (position player) nearEntities ["CAManBase", 3];
	{
		if (isPlayer _x && {_x != player} && {alive _x}) exitWith {
			_targetPlayer = _x;
		};
	} forEach _nearPlayers;

	if (isNull _targetPlayer) exitWith {
		["STR_A3PL_Inventory_NoPlayerNearby" call A3PL_Localize, Color_Red] call A3PL_Notification;
	};

	// Fermer l'inventaire
	(findDisplay 6400) closeDisplay 0;

	// Retirer du donneur et ajouter au receveur
	[player, _item, -_amount] remoteExec ["Server_Inventory_Add", 2];
	[_targetPlayer, _item, _amount] remoteExec ["Server_Inventory_Add", 2];

	// Notifications
	private _itemName = [_item, 'name'] call A3PL_Config_GetItem;
	if (_itemName isEqualTo "") then {_itemName = [_item, 'displayName'] call A3PL_Config_GetItem;};
	[format["STR_A3PL_Inventory_YouGave" call A3PL_Localize, _amount, _itemName], Color_Green] call A3PL_Notification;
	[format["STR_A3PL_Inventory_YouReceived" call A3PL_Localize, _amount, _itemName], Color_Green] remoteExec ["A3PL_Notification", _targetPlayer];

	// Rafraichir la grille virtuelle
	[] call A3PL_InventoryNew_RefreshGrid;
}] call compile_Global;

["A3PL_Inventory_Pickup", {
	private _obj = param [0,objNull];
	private _moveToHand = param [1,false];
	private _amount = _obj getVariable ["amount",1];
	private _exitAP = false;
	private _exitAC = false; 

	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	if (_obj getVariable ["inUse",false]) exitWith {["STR_A3PL_Inventory_CantPickObjectInUsing" call A3PL_Localize,Color_Red] call A3PL_Notification;};
	if(Player_ActionDoing) exitWith {["STR_A3PL_Inventory_CantPickObjectInUsing" call A3PL_Localize,Color_Red] call A3PL_Notification;};
	if((player getVariable ["Cuffed",false]) || (player getVariable ["Zipped",false])) exitWith {};
	if (isNull _obj) exitwith {["STR_A3PL_Inventory_InventoryErrorCode1" call A3PL_Localize,Color_Red] call A3PL_Notification;};

	private _classname = _obj getVariable "class";
	if (isNil "_classname") exitwith {["STR_A3PL_Inventory_InventoryErrorCode2" call A3PL_Localize,Color_Red] call A3PL_Notification;};
	if (!isNull Player_Item) exitwith {["STR_A3PL_Inventory_AlreadyHaveObjectInHands" call A3PL_Localize,Color_Red] call A3PL_Notification;};

	private _canPickup = [_classname,"canPickup"] call A3PL_Config_GetItem;
	if (_canPickup) then {
		private _weightOver = ([[_classname,_amount]] call A3PL_Inventory_TotalWeight) > Player_MaxWeight;
		if (_weightOver) exitWith {["STR_Common_NotEnoughSpace" call A3PL_Localize,Color_Red] call A3PL_Notification;};

		// Verifier qu'il y a assez de place dans la grille d'inventaire
		private _canAddToGrid = [_classname, _amount] call A3PL_InventoryNew_CanAddItem;
		if (!_canAddToGrid) exitWith {["STR_A3PL_Inventory_NotEnoughGridSpace" call A3PL_Localize,Color_Red] call A3PL_Notification;};
	};

	private _isPlanterFull = false;
	if (_className isEqualTo "planter") then {
		_nearPlants = nearestObjects [player, Housing_Max_Items_Planter,3];
		if (count(_nearPlants) >= 1) then {_isPlanterFull = true;};
	};

	if (_isPlanterFull) exitWith {["STR_A3PL_Inventory_PlantFull" call A3PL_Localize,Color_Red] call A3PL_Notification;};

	private _attachedTo = attachedTo _obj;
	if (!isNull _attachedTo) then {
		if ((isPlayer _attachedTo) && (!(_attachedTo isKindOf "Car"))) then {
			_exitAP = true;
		};
		if ((_classname isEqualTo "jerrycan") && (_attachedTo isKindOf "Car")) then {
			_exitAC = true;
		};
	};
	if (_exitAP) exitwith {["STR_A3PL_Inventory_CantPickObjectFromAnotherPlayer" call A3PL_Localize,Color_Red] call A3PL_Notification;};
	if (_exitAC) exitwith {["STR_A3PL_Inventory_CantPickJerrycanByUse" call A3PL_Localize,Color_Red] call A3PL_Notification;};
	if ((_classname isEqualTo "toolbox") && (!((player getVariable["job","STR_Common_Job_Unemployed" call A3PL_Localize] IN ["STR_Common_FISD" call A3PL_Localize])))) exitWith {["STR_A3PL_Inventory_OnlySDCanMove" call A3PL_Localize,Color_Red] call A3PL_Notification;};
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
	[format["STR_A3PL_Inventory_YouPickedup" call A3PL_Localize,_amount, [_classname, "name"] call A3PL_Config_GetItem],Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Inventory_Throw", {
	private _obj = Player_Item;
	private _itemClass = Player_ItemClass;
	private _amount = 1;
	if(!isNil 'Player_ItemAmount') then {_amount = Player_ItemAmount;};
	if(_itemClass in ["A3PL_BucketFull","A3PL_Bucket","bucket_empty","bucket_full"]) exitWith {["STR_A3PL_Inventory_Stop" call A3PL_Localize,Color_Red] call A3PL_Notification;};
	if (isNull _obj) exitwith {["STR_A3PL_Inventory_NothingToDropInYourHands" call A3PL_Localize,Color_Red] call A3PL_Notification;};
	if (!isNil "Player_isEating") exitwith {["STR_A3PL_Inventory_CantDoThisByEating" call A3PL_Localize,Color_Red] call A3PL_Notification;};
	if (!isNil "Player_isDrinking") exitwith {["STR_A3PL_Inventory_CantDoThisByDrinking" call A3PL_Localize,Color_Red] call A3PL_Notification;};
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
			// Verifier le poids
			if (([[_class,_amount]] call A3PL_Inventory_TotalWeight) > Player_MaxWeight) exitwith {
				_exit = true;
				[format ["STR_A3PL_Inventory_YouCantAddThisObjectToYourInventory" call A3PL_Localize,Player_MaxWeight],Color_Red] call A3PL_Notification;
			};
			// Verifier l'espace dans la grille virtuelle
			if (!([_class, _amount] call A3PL_InventoryNew_CanAddItem)) exitWith {
				_exit = true;
				["STR_A3PL_Inventory_NotEnoughGridSpace" call A3PL_Localize, Color_Red] call A3PL_Notification;
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

["A3PL_Inventory_DropCash", {
	params [["_amount", 1, [0]]];

	// Verifications
	if (_amount < 1) exitWith {["STR_A3PL_Inventory_EnterValidAmount" call A3PL_Localize, Color_Red] call A3PL_Notification;};

	private _currentCash = player getVariable ["Player_Cash", 0];
	if (_currentCash < _amount) exitWith {["STR_A3PL_Inventory_DontHaveThisAmountToDrop" call A3PL_Localize, Color_Red] call A3PL_Notification;};

	if (!((vehicle player) isKindOf "Man")) exitWith {["STR_A3PL_Inventory_CantDropInVehicle" call A3PL_Localize, Color_Red] call A3PL_Notification;};

	// Animation
	if (!(animationState player IN ["crew"])) then {
		player playMove "AmovPercMstpSnonWnonDnon_AinvPercMstpSnonWnonDnon_Putdown";
	};

	// Creer l'objet cash au sol
	private _pos = player modelToWorld [0, 1, 0];
	private _obj = "A3PL_Money" createVehicle _pos;
	_obj setPosASL (AGLtoASL _pos);
	_obj setVariable ["class", "cash", true];
	_obj setVariable ["cash", _amount, true];
	_obj setVariable ["amount", _amount, true];
	_obj setVariable ["owner", (player getVariable ["character_id", ""]), true];

	// Retirer l'argent du joueur via le serveur
	[player, _obj, "cash", _amount] remoteExec ["Server_Inventory_Drop", 2];

	// Notification
	private _formattedAmount = [_amount, 1, 0, true] call CBA_fnc_formatNumber;
	[format ["STR_A3PL_Inventory_YouDropped" call A3PL_Localize, format ["$%1", _formattedAmount], ""], Color_Yellow] call A3PL_Notification;
}] call compile_Global;

// ============================================================================
// PHYSICAL CONTAINER GRID SYSTEM
// Gestion des grilles d'inventaire pour les conteneurs physiques Arma 3
// (uniformes, gilets, sacs a dos)
// ============================================================================

/*
	A3PL_InventoryNew_GetContainerType
	Determine le type de conteneur (uniform, vest, backpack)
	Params: classname
	Return: "uniform" | "vest" | "backpack" | ""
*/
["A3PL_InventoryNew_GetContainerType", {
	params [["_classname", "", [""]]];

	if (_classname isEqualTo "") exitWith {""};

	// Verifier dans CfgWeapons (uniforms et vests)
	private _cfg = configFile >> "CfgWeapons" >> _classname;
	if (isClass _cfg) then {
		private _type = getNumber(_cfg >> "ItemInfo" >> "type");
		switch (_type) do {
			case 801: { "uniform" };  // Uniform
			case 701: { "vest" };     // Vest
			default { "" };
		};
	} else {
		// Verifier dans CfgVehicles (backpacks)
		_cfg = configFile >> "CfgVehicles" >> _classname;
		if (isClass _cfg && {getNumber(_cfg >> "isBackpack") == 1}) then {
			"backpack"
		} else {
			""
		};
	};
}] call compile_Global;

/*
	A3PL_InventoryNew_InitContainerGrids
	Initialise les grilles pour tous les conteneurs du joueur
	Doit etre appele au spawn/connexion du joueur
*/
["A3PL_InventoryNew_InitContainerGrids", {
	[] call A3PL_InventoryNew_SyncAllContainerGrids;
	diag_log "A3PL_InventoryNew_InitContainerGrids: Container grids synchronized";
}] call compile_Global;

/*
	A3PL_InventoryNew_SyncGridFromContainer
	Synchronise une grille depuis le contenu actuel d'un conteneur Arma
	Params: [grid, containerType]
	Return: grid mise a jour
*/
["A3PL_InventoryNew_SyncGridFromContainer", {
	params [
		["_grid", [], [[]]],
		["_containerType", "", [""]]
	];

	if (_grid isEqualTo [] || _containerType isEqualTo "") exitWith {_grid};

	private _items = switch (_containerType) do {
		case "uniform": { uniformItems player };
		case "vest": { vestItems player };
		case "backpack": { backpackItems player };
		default { [] };
	};

	diag_log format ["[SyncGridFromContainer] Container: %1 | Items: %2", _containerType, _items];

	private _itemCounts = createHashMap;
	{
		private _count = _itemCounts getOrDefault [_x, 0];
		_itemCounts set [_x, _count + 1];
	} forEach _items;

	diag_log format ["[SyncGridFromContainer] ItemCounts: %1", _itemCounts];

	private _gridSize = if (count _grid > 0) then {[count (_grid#0), count _grid]} else {[5, 4]};
	private _newGrid = _gridSize call A3PL_InventoryNew_InitGrid;
	{
		private _classname = _x;
		private _count = _y;

		while {_count > 0} do {
			private _itemSize = [_classname] call A3PL_InventoryNew_GetItemGridSize;
			private _maxStack = _itemSize#2;
			if (_maxStack <= 0) then {_maxStack = 1};
			private _toPlace = _count min _maxStack;

			private _freeSlot = [_newGrid, _classname, false] call A3PL_InventoryNew_FindFreeSlot;
			if !(_freeSlot isEqualTo [-1, -1]) then {
				private _rotated = if (count _freeSlot > 2) then {_freeSlot#2} else {false};
				_newGrid = [_newGrid, _classname, _freeSlot#0, _freeSlot#1, _rotated, _toPlace] call A3PL_InventoryNew_PlaceItem;
				_count = _count - _toPlace;
			} else {
				_count = 0;
			};
		};
	} forEach _itemCounts;

	_newGrid
}] call compile_Global;

/*
	A3PL_InventoryNew_GetContainerGrid
	Recupere la grille d'un conteneur specifique
	Params: containerType ("uniform", "vest", "backpack")
	Return: grid ou [] si pas de conteneur
*/
["A3PL_InventoryNew_GetContainerGrid", {
	params [["_containerType", "", [""]]];

	private _varName = format ["player_%1_grid", _containerType];
	player getVariable [_varName, []]
}] call compile_Global;

/*
	A3PL_InventoryNew_SetContainerGrid
	Definit la grille d'un conteneur specifique
	Params: [containerType, grid]
*/
["A3PL_InventoryNew_SetContainerGrid", {
	params [
		["_containerType", "", [""]],
		["_grid", [], [[]]]
	];

	private _varName = format ["player_%1_grid", _containerType];
	player setVariable [_varName, _grid];
}] call compile_Global;

/*
	A3PL_InventoryNew_CanAddItemPhysical
	Verifie si un item physique peut etre ajoute dans un des conteneurs
	Utilise le systeme de grille au lieu de "player canAdd"
	Params: [classname, count]
	Return: [canAdd, containerType] ou [false, ""]
*/
["A3PL_InventoryNew_CanAddItemPhysical", {
	params [
		["_classname", "", [""]],
		["_count", 1, [0]]
	];

	if (_classname isEqualTo "" || _count <= 0) exitWith {[false, ""]};

	private _itemSize = [_classname] call A3PL_InventoryNew_GetItemGridSize;
	private _itemW = _itemSize#0;
	private _itemH = _itemSize#1;
	private _maxStack = _itemSize#2;

	// Tester chaque conteneur dans l'ordre: uniform, vest, backpack
	private _containers = [
		["uniform", uniform player, player getVariable ["player_uniform_grid", []]],
		["vest", vest player, player getVariable ["player_vest_grid", []]],
		["backpack", backpack player, player getVariable ["player_backpack_grid", []]]
	];

	private _result = [false, ""];

	{
		_x params ["_type", "_containerClass", "_grid"];

		if (_containerClass isNotEqualTo "" && !(_grid isEqualTo [])) then {
			// Essayer de placer l'item dans cette grille
			private _canPlace = [_grid, _classname, _count] call A3PL_InventoryNew_CanFitInGrid;
			if (_canPlace) exitWith {
				_result = [true, _type];
			};
		};
	} forEach _containers;

	_result
}] call compile_Global;

/*
	A3PL_InventoryNew_CanFitInGrid
	Verifie si un item (avec quantite) peut tenir dans une grille
	Params: [grid, classname, count]
	Return: boolean
*/
["A3PL_InventoryNew_CanFitInGrid", {
	params [
		["_grid", [], [[]]],
		["_classname", "", [""]],
		["_count", 1, [0]]
	];

	if (_grid isEqualTo [] || _classname isEqualTo "" || _count <= 0) exitWith {false};

	private _itemSize = [_classname] call A3PL_InventoryNew_GetItemGridSize;
	private _maxStack = _itemSize#2;
	private _remainingCount = _count;

	// Copie de la grille pour simulation
	private _testGrid = +_grid;

	// 1. D'abord essayer de stacker sur les items existants
	private _existingItems = [_testGrid] call A3PL_InventoryNew_GetGridItems;
	{
		_x params ["_existingClass", "_posX", "_posY", "_rotated", "_currentCount"];
		if (_existingClass isEqualTo _classname && _currentCount < _maxStack) then {
			private _canAdd = _maxStack - _currentCount;
			private _toAdd = _canAdd min _remainingCount;
			_remainingCount = _remainingCount - _toAdd;
			if (_remainingCount <= 0) exitWith {};
		};
	} forEach _existingItems;

	if (_remainingCount <= 0) exitWith {true};

	// 2. Ensuite essayer de placer de nouveaux stacks
	while {_remainingCount > 0} do {
		private _freeSlot = [_testGrid, _classname, false] call A3PL_InventoryNew_FindFreeSlot;
		if (_freeSlot isEqualTo [-1, -1]) exitWith {}; // Plus de place

		private _stackAmount = _maxStack min _remainingCount;
		private _rotated = if (count _freeSlot > 2) then {_freeSlot#2} else {false};
		_testGrid = [_testGrid, _classname, _freeSlot#0, _freeSlot#1, _rotated, _stackAmount] call A3PL_InventoryNew_PlaceItem;
		_remainingCount = _remainingCount - _stackAmount;
	};

	_remainingCount <= 0
}] call compile_Global;

/*
	A3PL_InventoryNew_AddItemToContainerGrid
	Ajoute un item a la grille d'un conteneur et synchronise avec Arma
	Params: [classname, count, containerType]
	Return: boolean (success)
*/
["A3PL_InventoryNew_AddItemToContainerGrid", {
	params [
		["_classname", "", [""]],
		["_count", 1, [0]],
		["_containerType", "", [""]]
	];

	if (_classname isEqualTo "" || _count <= 0 || _containerType isEqualTo "") exitWith {false};

	private _grid = [_containerType] call A3PL_InventoryNew_GetContainerGrid;
	if (_grid isEqualTo []) exitWith {false};

	private _itemSize = [_classname] call A3PL_InventoryNew_GetItemGridSize;
	private _maxStack = _itemSize#2;
	private _remainingCount = _count;

	// 1. D'abord essayer de stacker sur les items existants
	private _existingItems = [_grid] call A3PL_InventoryNew_GetGridItems;
	{
		_x params ["_existingClass", "_posX", "_posY", "_rotated", "_currentCount"];
		if (_existingClass isEqualTo _classname && _currentCount < _maxStack) then {
			private _canAdd = _maxStack - _currentCount;
			private _toAdd = _canAdd min _remainingCount;
			// Mettre a jour le count dans la grille
			_grid = [_grid, _classname, _posX, _posY, _rotated, _currentCount + _toAdd] call A3PL_InventoryNew_PlaceItem;
			_remainingCount = _remainingCount - _toAdd;
			if (_remainingCount <= 0) exitWith {};
		};
	} forEach _existingItems;

	// 2. Placer les items restants dans de nouveaux slots
	while {_remainingCount > 0} do {
		private _freeSlot = [_grid, _classname, false] call A3PL_InventoryNew_FindFreeSlot;
		if (_freeSlot isEqualTo [-1, -1]) exitWith {}; // Plus de place

		private _stackAmount = _maxStack min _remainingCount;
		private _rotated = if (count _freeSlot > 2) then {_freeSlot#2} else {false};
		_grid = [_grid, _classname, _freeSlot#0, _freeSlot#1, _rotated, _stackAmount] call A3PL_InventoryNew_PlaceItem;
		_remainingCount = _remainingCount - _stackAmount;
	};

	// Sauvegarder la grille
	[_containerType, _grid] call A3PL_InventoryNew_SetContainerGrid;

	_remainingCount <= 0
}] call compile_Global;

/*
	A3PL_InventoryNew_RemoveItemFromContainerGrid
	Retire un item de la grille d'un conteneur
	Params: [classname, count, containerType]
	Return: boolean (success)
*/
["A3PL_InventoryNew_RemoveItemFromContainerGrid", {
	params [
		["_classname", "", [""]],
		["_count", 1, [0]],
		["_containerType", "", [""]]
	];

	if (_classname isEqualTo "" || _count <= 0 || _containerType isEqualTo "") exitWith {false};

	private _grid = [_containerType] call A3PL_InventoryNew_GetContainerGrid;
	if (_grid isEqualTo []) exitWith {false};

	private _remainingToRemove = _count;
	private _existingItems = [_grid] call A3PL_InventoryNew_GetGridItems;

	// Parcourir les items et retirer la quantite demandee
	{
		_x params ["_existingClass", "_posX", "_posY", "_rotated", "_currentCount"];
		if (_existingClass isEqualTo _classname && _remainingToRemove > 0) then {
			private _toRemove = _currentCount min _remainingToRemove;
			private _newCount = _currentCount - _toRemove;

			if (_newCount <= 0) then {
				// Retirer completement l'item de la grille (false = inventaire physique)
				_grid = ([_grid, _posX, _posY, false] call A3PL_InventoryNew_RemoveItemAt)#0;
			} else {
				// Mettre a jour le count
				_grid = [_grid, _classname, _posX, _posY, _rotated, _newCount] call A3PL_InventoryNew_PlaceItem;
			};

			_remainingToRemove = _remainingToRemove - _toRemove;
		};
		if (_remainingToRemove <= 0) exitWith {};
	} forEach _existingItems;

	// Sauvegarder la grille
	[_containerType, _grid] call A3PL_InventoryNew_SetContainerGrid;

	_remainingToRemove <= 0
}] call compile_Global;

// Note: A3PL_InventoryNew_RemoveItemAt est defini plus haut dans le fichier (ligne ~3612)
// avec le format: [grid, posX, posY, isVirtual] -> [grid, cellData]

/*
	A3PL_InventoryNew_FindContainerForItem
	Trouve le meilleur conteneur pour un item
	Params: [classname, count]
	Return: containerType ("uniform", "vest", "backpack") ou ""
*/
["A3PL_InventoryNew_FindContainerForItem", {
	params [
		["_classname", "", [""]],
		["_count", 1, [0]]
	];

	private _result = [_classname, _count] call A3PL_InventoryNew_CanAddItemPhysical;
	_result#1
}] call compile_Global;

/*
	A3PL_InventoryNew_OnContainerChanged
	Appele quand un conteneur est change (equip/desequip)
	Reinitialise la grille pour le nouveau conteneur
	Params: [containerType, newClassname]
*/
["A3PL_InventoryNew_OnContainerChanged", {
	params [
		["_containerType", "", [""]],
		["_newClassname", "", [""]]
	];

	private _varName = format ["player_%1_grid", _containerType];

	if (_newClassname isEqualTo "") then {
		// Conteneur retire - supprimer la grille
		player setVariable [_varName, []];
	} else {
		// Nouveau conteneur - creer une nouvelle grille
		private _gridSize = [_newClassname] call A3PL_InventoryNew_GetContainerGridSize;
		private _grid = _gridSize call A3PL_InventoryNew_InitGrid;
		// Synchroniser avec le contenu actuel
		_grid = [_grid, _containerType] call A3PL_InventoryNew_SyncGridFromContainer;
		player setVariable [_varName, _grid];
	};

	diag_log format ["A3PL_InventoryNew_OnContainerChanged: %1 changed to %2", _containerType, _newClassname];
}] call compile_Global;

/*
	A3PL_InventoryNew_SyncAllContainerGrids
	Synchronise toutes les grilles de conteneurs avec l'inventaire Arma actuel
	Utile apres des modifications externes
*/
["A3PL_InventoryNew_SyncAllContainerGrids", {
	// Uniforme
	private _uniform = uniform player;
	if (_uniform isNotEqualTo "") then {
		private _gridSize = [_uniform] call A3PL_InventoryNew_GetContainerGridSize;
		private _grid = _gridSize call A3PL_InventoryNew_InitGrid;
		_grid = [_grid, "uniform"] call A3PL_InventoryNew_SyncGridFromContainer;
		player setVariable ["player_uniform_grid", _grid];
	} else {
		player setVariable ["player_uniform_grid", []];
	};

	// Gilet
	private _vest = vest player;
	if (_vest isNotEqualTo "") then {
		private _gridSize = [_vest] call A3PL_InventoryNew_GetContainerGridSize;
		private _grid = _gridSize call A3PL_InventoryNew_InitGrid;
		_grid = [_grid, "vest"] call A3PL_InventoryNew_SyncGridFromContainer;
		player setVariable ["player_vest_grid", _grid];
	} else {
		player setVariable ["player_vest_grid", []];
	};

	// Sac a dos
	private _backpack = backpack player;
	if (_backpack isNotEqualTo "") then {
		private _gridSize = [_backpack] call A3PL_InventoryNew_GetContainerGridSize;
		private _grid = _gridSize call A3PL_InventoryNew_InitGrid;
		_grid = [_grid, "backpack"] call A3PL_InventoryNew_SyncGridFromContainer;
		player setVariable ["player_backpack_grid", _grid];
	} else {
		player setVariable ["player_backpack_grid", []];
	};

	diag_log "A3PL_InventoryNew_SyncAllContainerGrids: All grids synchronized";
}] call compile_Global;
