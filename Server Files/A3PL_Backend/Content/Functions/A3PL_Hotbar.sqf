/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/

// ============================================================================
// A3PL_Hotbar_Init - Initialize the hotbar system
// Variables are initialized in A3PL_Player_VariablesSetup
// ============================================================================
["A3PL_Hotbar_Init", {
	// Initialize hotbar data
	Hotbar_Data = ["", "", "", "", "", "", "", "", "", ""];
	Hotbar_UI_Visible = false;
	Hotbar_MapHidden = false;
	Hotbar_IsDragging = false;
	Hotbar_DragItem = "";
	Hotbar_DragFromSlot = -1;

	// Load saved hotbar from player data
	[] call A3PL_Hotbar_Load;

	// Add key event handlers for slots 1-0
	[] call A3PL_Hotbar_AddKeyHandlers;

	// Create the UI
	[] call A3PL_Hotbar_CreateUI;

	// Start update loop
	[] spawn A3PL_Hotbar_UpdateLoop;

	diag_log "A3PL_Hotbar: Initialized";
}] call compile_Global;

// ============================================================================
// A3PL_Hotbar_CanAssign - Check if an item can be assigned to hotbar
// Used by CfgInventoryActions condition to show/hide hotbar menu
// For physical items: only weapons (CfgWeapons) can be assigned
// Excludes: uniforms, vests, backpacks, headgear, goggles
// ============================================================================
["A3PL_Hotbar_CanAssign", {
	params [["_item", "", [""]]];
	if (_item isEqualTo "") exitWith {false};

	// Check if it's in CfgWeapons
	if !(isClass (configFile >> "CfgWeapons" >> _item)) exitWith {false};

	// Exclude uniforms (CfgWeapons >> Uniform)
	if (isClass (configFile >> "CfgWeapons" >> _item) && {getText (configFile >> "CfgWeapons" >> _item >> "ItemInfo" >> "type") == "801"}) exitWith {false};

	// Exclude vests (CfgWeapons >> Vest)
	if (isClass (configFile >> "CfgWeapons" >> _item) && {getText (configFile >> "CfgWeapons" >> _item >> "ItemInfo" >> "type") == "701"}) exitWith {false};

	// Exclude headgear (CfgWeapons >> H_)
	if (getText (configFile >> "CfgWeapons" >> _item >> "ItemInfo" >> "type") == "605") exitWith {false};

	// Exclude goggles (CfgGlasses)
	if (isClass (configFile >> "CfgGlasses" >> _item)) exitWith {false};

	// Exclude backpacks (CfgVehicles)
	if (isClass (configFile >> "CfgVehicles" >> _item) && {getNumber (configFile >> "CfgVehicles" >> _item >> "isBackpack") == 1}) exitWith {false};

	true
}] call compile_Global;

// ============================================================================
// A3PL_Hotbar_AddKeyHandlers - Add CBA keybinds for hotbar slots
// ============================================================================
["A3PL_Hotbar_AddKeyHandlers", {
	#include "\a3\editor_f\Data\Scripts\dikCodes.h"

	// Add CBA keybinds for each hotbar slot (customizable by player)
	[format["A3PL : %1","STR_A3PL_Hotbar_Category" call A3PL_Localize], "hotbar_slot_1", "STR_A3PL_Hotbar_Slot1" call A3PL_Localize, {
		if (vehicle player != player) exitWith {};
		[0] call A3PL_Hotbar_UseSlot;
	}, "", [DIK_1, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_Hotbar_Category" call A3PL_Localize], "hotbar_slot_2", "STR_A3PL_Hotbar_Slot2" call A3PL_Localize, {
		if (vehicle player != player) exitWith {};
		[1] call A3PL_Hotbar_UseSlot;
	}, "", [DIK_2, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_Hotbar_Category" call A3PL_Localize], "hotbar_slot_3", "STR_A3PL_Hotbar_Slot3" call A3PL_Localize, {
		if (vehicle player != player) exitWith {};
		[2] call A3PL_Hotbar_UseSlot;
	}, "", [DIK_3, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_Hotbar_Category" call A3PL_Localize], "hotbar_slot_4", "STR_A3PL_Hotbar_Slot4" call A3PL_Localize, {
		if (vehicle player != player) exitWith {};
		[3] call A3PL_Hotbar_UseSlot;
	}, "", [DIK_4, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_Hotbar_Category" call A3PL_Localize], "hotbar_slot_5", "STR_A3PL_Hotbar_Slot5" call A3PL_Localize, {
		if (vehicle player != player) exitWith {};
		[4] call A3PL_Hotbar_UseSlot;
	}, "", [DIK_5, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_Hotbar_Category" call A3PL_Localize], "hotbar_slot_6", "STR_A3PL_Hotbar_Slot6" call A3PL_Localize, {
		if (vehicle player != player) exitWith {};
		[5] call A3PL_Hotbar_UseSlot;
	}, "", [DIK_6, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_Hotbar_Category" call A3PL_Localize], "hotbar_slot_7", "STR_A3PL_Hotbar_Slot7" call A3PL_Localize, {
		if (vehicle player != player) exitWith {};
		[6] call A3PL_Hotbar_UseSlot;
	}, "", [DIK_7, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_Hotbar_Category" call A3PL_Localize], "hotbar_slot_8", "STR_A3PL_Hotbar_Slot8" call A3PL_Localize, {
		if (vehicle player != player) exitWith {};
		[7] call A3PL_Hotbar_UseSlot;
	}, "", [DIK_8, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_Hotbar_Category" call A3PL_Localize], "hotbar_slot_9", "STR_A3PL_Hotbar_Slot9" call A3PL_Localize, {
		if (vehicle player != player) exitWith {};
		[8] call A3PL_Hotbar_UseSlot;
	}, "", [DIK_9, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_Hotbar_Category" call A3PL_Localize], "hotbar_slot_10", "STR_A3PL_Hotbar_Slot10" call A3PL_Localize, {
		if (vehicle player != player) exitWith {};
		[9] call A3PL_Hotbar_UseSlot;
	}, "", [DIK_0, [false, false, false]]] call CBA_fnc_addKeybind;

	// Add mouse event handlers for drag & drop (non-customizable)
	(findDisplay 46) displayAddEventHandler ["MouseButtonDown", {
		params ["_display", "_button", "_xPos", "_yPos"];
		if (_button == 0 && !dialog) then {
			private _slotIndex = [_xPos, _yPos] call A3PL_Hotbar_GetSlotAtPosition;
			if (_slotIndex >= 0) then {
				[_slotIndex] call A3PL_Hotbar_StartDragFromHotbar;
			};
		};
	}];

	(findDisplay 46) displayAddEventHandler ["MouseButtonUp", {
		params ["_display", "_button", "_xPos", "_yPos"];
		if (_button == 0) then {
			[] call A3PL_Hotbar_EndDrag;
		};
	}];
}] call compile_Global;

// ============================================================================
// A3PL_Hotbar_UseSlot - Use the item in a specific hotbar slot (toggle behavior)
// Supports both virtual items and ArmA weapons
// ============================================================================
["A3PL_Hotbar_UseSlot", {
	params [["_slotIndex", -1, [0]]];

	if (vehicle player != player) then {
		private _itemClass = Hotbar_Data select _slotIndex;
		private _inWater = underwater player || {isTouchingGround player && {surfaceIsWater getPos player}};

		if !(_itemClass == "net" && _inWater) exitWith {};
	};

	if (_slotIndex < 0 || _slotIndex >= Hotbar_SlotCount) exitWith {};

	private _maxSlots = player getVariable ["Player_HotbarSlots", 5];
	private _isPremium = (player getVariable ["Player_PerkDay", 0]) > 0;
	if (_slotIndex >= _maxSlots && !_isPremium) exitWith {
		["STR_A3PL_Hotbar_PremiumOnly" call A3PL_Localize, [1, 0.8, 0.2, 1]] call A3PL_Notification;
	};

	private _itemClass = Hotbar_Data select _slotIndex;

	if (_itemClass == "") exitWith {
		["STR_A3PL_Hotbar_EmptySlot" call A3PL_Localize, [0.8, 0.8, 0.8, 1]] call A3PL_Notification;
	};

	if (isClass (configFile >> "CfgWeapons" >> _itemClass)) exitWith {
		if (Player_ItemClass != "") then {
			[false] call A3PL_Inventory_PutBack;
		};
		[_itemClass] call A3PL_Hotbar_UseWeapon;
	};

	if (Player_ItemClass == _itemClass) exitWith {
		[false] call A3PL_Inventory_PutBack;
		[] call A3PL_Hotbar_UpdateUI;
	};

	if (Player_ItemClass != "") then {
		[false] call A3PL_Inventory_PutBack;
	};

	if (currentWeapon player != "") then {
		player action ["SwitchWeapon", player, player, -1];
	};

	private _inventory = [] call A3PL_Inventory_Get;
	private _hasItem = false;
	private _amount = 0;

	{
		if ((_x select 0) == _itemClass) then {
			_hasItem = true;
			_amount = _amount + (_x select 1);
		};
	} forEach _inventory;

	if (!_hasItem || _amount <= 0) exitWith {
		["STR_A3PL_Hotbar_NoItem" call A3PL_Localize, [1, 0.5, 0.5, 1]] call A3PL_Notification;
		[] call A3PL_Hotbar_UpdateUI;
	};

	private _canUse = [_itemClass, "canUse"] call A3PL_Config_GetItem;
	if (!_canUse) exitWith {
		["STR_A3PL_Hotbar_CantUse" call A3PL_Localize, [1, 0.5, 0.5, 1]] call A3PL_Notification;
	};

	// Comportement normal - A3PL_Inventory_Use va mettre l'item en main puis on pourra le dropper
	// L'exception pour le net dans l'eau est gérée dans A3PL_Inventory_Use
	[_itemClass] call A3PL_Inventory_Use;

	[] call A3PL_Hotbar_UpdateUI;
}] call compile_Global;

// ============================================================================
// A3PL_Hotbar_UseWeapon - Toggle an ArmA weapon from hotbar
// Swaps weapons properly including those stored in uniform/vest/backpack
// Based on A3PL_Lib_WeaponSwap logic
// ============================================================================
["A3PL_Hotbar_UseWeapon", {
	params [["_weaponClass", "", [""]]];

	if (_weaponClass == "") exitWith {};

	// Check if player has this weapon (either equipped or in inventory)
	private _hasWeapon = [player, _weaponClass] call BIS_fnc_hasItem;

	if (!_hasWeapon) exitWith {
		["STR_A3PL_Hotbar_NoWeapon" call A3PL_Localize, [1, 0.5, 0.5, 1]] call A3PL_Notification;
		[] call A3PL_Hotbar_UpdateUI;
	};

	// Check current weapon state
	private _currentWeapon = currentWeapon player;

	// If already holding this weapon - holster it
	if (_currentWeapon == _weaponClass) exitWith {
		player action ["SwitchWeapon", player, player, -1];
		[] call A3PL_Hotbar_UpdateUI;
	};

	// Check if weapon is already in hand slot (equipped as primary/secondary/handgun)
	private _isEquipped = _weaponClass in [primaryWeapon player, secondaryWeapon player, handgunWeapon player];

	if (_isEquipped) then {
		// Weapon is already equipped in a slot, just select it
		player selectWeapon _weaponClass;
	} else {
		// Weapon is in inventory (uniform/vest/backpack) - need to swap
		// This is spawned to allow for sleep
		[_weaponClass, _currentWeapon] spawn {
			params ["_weaponClass", "_currentWeapon"];

			// Get weapon type from config
			private _weaponType = getNumber (configFile >> "CfgWeapons" >> _weaponClass >> "type");
			// type: 1 = primary, 2 = handgun, 4 = secondary (launcher)

			// Determine which slot weapon to swap with
			private _slotWeapon = "";
			private _slotAttachments = [];
			switch (_weaponType) do {
				case 1: {
					_slotWeapon = primaryWeapon player;
					_slotAttachments = primaryWeaponItems player;
				};
				case 2: {
					_slotWeapon = handgunWeapon player;
					_slotAttachments = handgunItems player;
				};
				case 4: {
					_slotWeapon = secondaryWeapon player;
					_slotAttachments = secondaryWeaponItems player;
				};
			};

			// Play holster animation
			[player, "amovpercmstpsnonwnondnon", 1] remoteExec ["A3PL_Lib_SyncAnim", 0];
			sleep 1.5;

			// Get current magazine info for the slot weapon (if any)
			private _slotMag = [];
			if (_slotWeapon != "") then {
				private _currMag = "";
				switch (_weaponType) do {
					case 1: { _currMag = primaryWeaponMagazine player select 0; };
					case 2: { _currMag = handgunMagazine player select 0; };
					case 4: { _currMag = secondaryWeaponMagazine player select 0; };
				};
				if (!isNil "_currMag" && {_currMag != ""}) then {
					private _magDetail = (currentMagazineDetail player) splitString "([]/:)";
					if (count _magDetail > 1) then {
						_slotMag = [_currMag, parseNumber (_magDetail # 1)];
					} else {
						_slotMag = [_currMag, 0];
					};
				};
			};

			// Find the target weapon in inventory with its full data
			private _targetWeaponData = [];
			{
				private _container = _x;
				private _cargoWeapons = weaponsItemsCargo _container;
				{
					if (_x # 0 == _weaponClass) exitWith {
						_targetWeaponData = _x;
					};
				} forEach _cargoWeapons;
				if (count _targetWeaponData > 0) exitWith {};
			} forEach [uniformContainer player, vestContainer player, backpackContainer player];

			// If we found the weapon data, perform the swap
			if (count _targetWeaponData > 0) then {
				// Remove current slot weapon and store it in uniform
				if (_slotWeapon != "") then {
					player removeWeapon _slotWeapon;
					(uniformContainer player) addWeaponWithAttachmentsCargoGlobal [[_slotWeapon, _slotAttachments # 0, _slotAttachments # 1, _slotAttachments # 2, _slotMag, [], ""], 1];
				};

				// Remove target weapon from inventory and equip it
				player removeItem _weaponClass;

				// Add magazine first if exists
				private _targetMag = _targetWeaponData # 4;
				if (count _targetMag > 0 && {(_targetMag # 0) != ""}) then {
					player addMagazine _targetMag;
				};

				// Add the weapon
				player addWeapon _weaponClass;

				// Add attachments based on weapon type
				private _attachments = [_targetWeaponData # 1, _targetWeaponData # 2, _targetWeaponData # 3];
				{
					if (_x != "") then {
						switch (_weaponType) do {
							case 1: { player addPrimaryWeaponItem _x; };
							case 2: { player addHandgunItem _x; };
							case 4: { player addSecondaryWeaponItem _x; };
						};
					};
				} forEach _attachments;

				// Select the weapon
				player selectWeapon _weaponClass;
			};

			[] call A3PL_Hotbar_UpdateUI;
		};
	};

	[] call A3PL_Hotbar_UpdateUI;
}] call compile_Global;

// ============================================================================
// A3PL_Hotbar_SetSlot - Set an item or weapon to a specific hotbar slot
// Unified system: any slot can hold virtual items OR ArmA weapons
// ============================================================================
["A3PL_Hotbar_SetSlot", {
	params [["_slotIndex", -1, [0]], ["_itemClass", "", [""]]];

	if (_slotIndex < 0 || _slotIndex >= Hotbar_SlotCount) exitWith {false};

	// Check premium/purchased slots for slots beyond player's limit
	private _maxSlots = player getVariable ["Player_HotbarSlots", 5];
	private _isPremium = (player getVariable ["Player_PerkDay", 0]) > 0;
	if (_slotIndex >= _maxSlots && _itemClass != "" && !_isPremium) exitWith {
		["STR_A3PL_Hotbar_PremiumOnly" call A3PL_Localize, [1, 0.8, 0.2, 1]] call A3PL_Notification;
		false
	};

	// Check blacklist (only for virtual items, not weapons)
	if (_itemClass != "" && {!isClass (configFile >> "CfgWeapons" >> _itemClass)} && {_itemClass in Hotbar_Blacklist}) exitWith {
		["STR_A3PL_Hotbar_Blacklisted" call A3PL_Localize, [1, 0.5, 0.5, 1]] call A3PL_Notification;
		false
	};

	// Remove item from other slots if it exists (prevent duplicates)
	if (_itemClass != "") then {
		for "_i" from 0 to (Hotbar_SlotCount - 1) do {
			if ((Hotbar_Data select _i) == _itemClass) then {
				Hotbar_Data set [_i, ""];
			};
		};
	};

	// Set the slot
	Hotbar_Data set [_slotIndex, _itemClass];

	// Save to database
	[] call A3PL_Hotbar_Save;

	// Update UI
	[] call A3PL_Hotbar_UpdateUI;

	true
}] call compile_Global;

// ============================================================================
// A3PL_Hotbar_ClearSlot - Clear a specific hotbar slot
// ============================================================================
["A3PL_Hotbar_ClearSlot", {
	params [["_slotIndex", -1, [0]]];

	[_slotIndex, ""] call A3PL_Hotbar_SetSlot;
}] call compile_Global;

// ============================================================================
// A3PL_Hotbar_Save - Save hotbar to player data (for database)
// ============================================================================
["A3PL_Hotbar_Save", {
	// Save as array to player variable (will be saved by Server_Gear_Save)
	player setVariable ["player_hotbar", Hotbar_Data, true];
}] call compile_Global;

// ============================================================================
// A3PL_Hotbar_Load - Load hotbar from player data
// ============================================================================
["A3PL_Hotbar_Load", {
	private _hotbarData = player getVariable ["player_hotbar", []];

	// Handle both array and string formats for compatibility
	if (_hotbarData isEqualType "") then {
		if (_hotbarData != "") then {
			_hotbarData = _hotbarData splitString ",";
		} else {
			_hotbarData = [];
		};
	};

	if (count _hotbarData > 0) then {
		// Validate and apply
		for "_i" from 0 to (Hotbar_SlotCount - 1) do {
			if (_i < count _hotbarData) then {
				private _item = _hotbarData select _i;
				if (_item isEqualType "" && {_item != ""} && {!(_item in Hotbar_Blacklist)}) then {
					Hotbar_Data set [_i, _item];
				} else {
					Hotbar_Data set [_i, ""];
				};
			} else {
				Hotbar_Data set [_i, ""];
			};
		};
	};

	diag_log format ["A3PL_Hotbar: Loaded data: %1", Hotbar_Data];
}] call compile_Global;

// ============================================================================
// A3PL_Hotbar_CreateUI - Create the hotbar UI elements
// ============================================================================
["A3PL_Hotbar_CreateUI", {
	disableSerialization;

	if (isNull (findDisplay 46)) exitWith {
		diag_log "A3PL_Hotbar: Display 46 not found, retrying...";
		[] spawn {
			sleep 1;
			[] call A3PL_Hotbar_CreateUI;
		};
	};

	[] call A3PL_Hotbar_DestroyUI;

	("A3PL_Hotbar" call BIS_fnc_rscLayer) cutRsc ["Dialog_Hotbar", "PLAIN"];

	private _display = uiNamespace getVariable ["A3PL_HotbarDisplay", displayNull];
	if (isNull _display) exitWith {
		diag_log "A3PL_Hotbar: Hotbar display not ready, retrying...";
		[] spawn {
			sleep 0.5;
			[] call A3PL_Hotbar_CreateUI;
		};
	};

	// Set static key numbers on each slot
	for "_i" from 0 to (Hotbar_SlotCount - 1) do {
		private _keyCtrl = _display displayCtrl (Hotbar_UI_BaseIDC + (_i * 10) + 2);
		private _keyNum = if (_i == 9) then {"0"} else {str (_i + 1)};
		_keyCtrl ctrlSetStructuredText parseText format ["<t size='0.5' color='#AAAAAA' shadow='1'>%1</t>", _keyNum];
	};

	Hotbar_UI_Visible = true;

	[] call A3PL_Hotbar_UpdateUI;

	diag_log "A3PL_Hotbar: UI Created";
}] call compile_Global;

// ============================================================================
// A3PL_Hotbar_DestroyUI - Remove hotbar UI elements
// ============================================================================
["A3PL_Hotbar_DestroyUI", {
	("A3PL_Hotbar" call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
	uiNamespace setVariable ["A3PL_HotbarDisplay", displayNull];
	Hotbar_UI_Visible = false;
}] call compile_Global;

// ============================================================================
// A3PL_Hotbar_UpdateUI - Update the hotbar display with current items
// Unified system: any slot can hold virtual items OR ArmA weapons
// ============================================================================
["A3PL_Hotbar_UpdateUI", {
	disableSerialization;

	if (!Hotbar_UI_Visible) exitWith {};

	private _display = uiNamespace getVariable ["A3PL_HotbarDisplay", displayNull];
	if (isNull _display) exitWith {};

	private _inventory = [] call A3PL_Inventory_Get;

	private _invMap = createHashMap;
	{
		private _itemClass = _x select 0;
		private _itemAmount = _x select 1;
		private _currentAmount = _invMap getOrDefault [_itemClass, 0];
		_invMap set [_itemClass, _currentAmount + _itemAmount];
	} forEach _inventory;

	private _currentWeapon = currentWeapon player;
	private _playerWeapons = weapons player;

	private _maxSlots = player getVariable ["Player_HotbarSlots", 5];
	private _isPremium = (player getVariable ["Player_PerkDay", 0]) > 0;

	for "_i" from 0 to (Hotbar_SlotCount - 1) do {
		private _iconCtrl = _display displayCtrl (Hotbar_UI_BaseIDC + (_i * 10) + 1);
		private _amountCtrl = _display displayCtrl (Hotbar_UI_BaseIDC + (_i * 10) + 3);
		private _bgCtrl = _display displayCtrl (Hotbar_UI_BaseIDC + (_i * 10));
		private _lockCtrl = _display displayCtrl (Hotbar_UI_BaseIDC + (_i * 10) + 4);

		private _itemClass = Hotbar_Data select _i;

		private _isLockedSlot = (_i >= _maxSlots) && !_isPremium;

		if (_isLockedSlot) then {
			_iconCtrl ctrlSetText "";
			_amountCtrl ctrlSetStructuredText parseText "";
			_bgCtrl ctrlSetText "#(argb,8,8,3)color(0.05,0.05,0.05,0.8)";
			_lockCtrl ctrlSetText "A3FL_Props\icons\lock_ca.paa";
		} else {
			_lockCtrl ctrlSetText "";

			if (_itemClass == "") then {
				_iconCtrl ctrlSetText "";
				_amountCtrl ctrlSetStructuredText parseText "";
				_bgCtrl ctrlSetText "#(argb,8,8,3)color(0.1,0.1,0.1,0.7)";
			} else {
				if (isClass (configFile >> "CfgWeapons" >> _itemClass)) then {
					private _hasWeapon = _itemClass in _playerWeapons;
					private _picture = getText (configFile >> "CfgWeapons" >> _itemClass >> "picture");
					_iconCtrl ctrlSetText _picture;

					_amountCtrl ctrlSetStructuredText parseText "";

					if (_hasWeapon) then {
						if (_currentWeapon == _itemClass) then {
							_bgCtrl ctrlSetText "#(argb,8,8,3)color(0.2,0.3,0.2,0.9)";
						} else {
							_bgCtrl ctrlSetText "#(argb,8,8,3)color(0.12,0.12,0.15,0.8)";
						};
					} else {
						_bgCtrl ctrlSetText "#(argb,8,8,3)color(0.2,0.1,0.1,0.8)";
					};
				} else {
					private _picture = [_itemClass, "picture"] call A3PL_Config_GetItem;
					private _amount = _invMap getOrDefault [_itemClass, 0];

					_iconCtrl ctrlSetText _picture;

					_amountCtrl ctrlSetStructuredText parseText "";

					if (_amount > 0) then {
						if (player_itemClass == _itemClass) then {
							_bgCtrl ctrlSetText "#(argb,8,8,3)color(0.2,0.3,0.2,0.9)";
						} else {
							_bgCtrl ctrlSetText "#(argb,8,8,3)color(0.15,0.15,0.15,0.8)";
						};
					} else {
						_bgCtrl ctrlSetText "#(argb,8,8,3)color(0.2,0.1,0.1,0.8)";
					};
				};
			};
		};
	};
}] call compile_Global;

// ============================================================================
// A3PL_Hotbar_UpdateLoop - Periodic update loop for hotbar
// ============================================================================
["A3PL_Hotbar_UpdateLoop", {
	while {true} do {
		sleep 1;

		private _isShowGPS = profileNameSpace getVariable ["A3PL_ShowGPS", true];

		if (!_isShowGPS && Hotbar_UI_Visible) then {
			[] call A3PL_Hotbar_DestroyUI;
		};

		if (_isShowGPS && !Hotbar_UI_Visible && !isNull (findDisplay 46) && !(Hotbar_MapHidden)) then {
			[] call A3PL_Hotbar_CreateUI;
		};

		if (Hotbar_UI_Visible && !isNull (uiNamespace getVariable ["A3PL_HotbarDisplay", displayNull])) then {
			[] call A3PL_Hotbar_UpdateUI;
		};
	};
}] call compile_Global;

// ============================================================================
// A3PL_Hotbar_StartDragFromInventory - Start dragging an item from inventory to hotbar
// ============================================================================
["A3PL_Hotbar_StartDragFromInventory", {
	params [["_itemClass", "", [""]]];

	if (_itemClass == "") exitWith {};

	// Check blacklist only for virtual items (not weapons)
	if (!isClass (configFile >> "CfgWeapons" >> _itemClass) && {_itemClass in Hotbar_Blacklist}) exitWith {
		["STR_A3PL_Hotbar_Blacklisted" call A3PL_Localize, [1, 0.5, 0.5, 1]] call A3PL_Notification;
	};

	Hotbar_DragItem = _itemClass;
	Hotbar_DragFromSlot = -1; // -1 means from inventory
	Hotbar_IsDragging = true;

	// Create drag icon that follows cursor
	disableSerialization;
	private _display = findDisplay 1001;
	if (isNull _display) exitWith {};

	// Get picture - check if weapon or virtual item
	private _picture = "";
	if (isClass (configFile >> "CfgWeapons" >> _itemClass)) then {
		_picture = getText (configFile >> "CfgWeapons" >> _itemClass >> "picture");
	} else {
		_picture = [_itemClass, "picture"] call A3PL_Config_GetItem;
	};
	if (!(_picture isEqualType "") || _picture == "") then {
		_picture = "";
	};

	private _dragCtrl = _display ctrlCreate ["RscPicture", 86100];
	_dragCtrl ctrlSetPosition [0, 0, 0.04 * safezoneW, 0.04 * safezoneH];
	_dragCtrl ctrlSetText _picture;
	_dragCtrl ctrlCommit 0;

	// Start drag update loop
	[] spawn {
		disableSerialization;
		private _display = findDisplay 1001;
		while {Hotbar_IsDragging && !isNull _display} do {
			private _mousePos = getMousePosition;
			private _dragCtrl = _display displayCtrl 86100;
			if (!isNull _dragCtrl) then {
				_dragCtrl ctrlSetPosition [(_mousePos select 0) - 0.02 * safezoneW, (_mousePos select 1) - 0.02 * safezoneH, 0.04 * safezoneW, 0.04 * safezoneH];
				_dragCtrl ctrlCommit 0;
			};
			sleep 0.01;
		};
	};
}] call compile_Global;

// ============================================================================
// A3PL_Hotbar_StartDragFromHotbar - Start dragging an item from hotbar slot
// Unified system: can drag from any slot
// ============================================================================
["A3PL_Hotbar_StartDragFromHotbar", {
	params [["_slotIndex", -1, [0]]];

	if (_slotIndex < 0 || _slotIndex >= Hotbar_SlotCount) exitWith {};

	private _itemClass = Hotbar_Data select _slotIndex;
	if (_itemClass == "") exitWith {};

	Hotbar_DragItem = _itemClass;
	Hotbar_DragFromSlot = _slotIndex;
	Hotbar_IsDragging = true;

	// Create drag icon
	disableSerialization;
	private _display = findDisplay 46;
	if (isNull _display) then {_display = findDisplay 1001;};
	if (isNull _display) exitWith {};

	// Get picture - check if weapon or virtual item
	private _picture = "";
	if (isClass (configFile >> "CfgWeapons" >> _itemClass)) then {
		_picture = getText (configFile >> "CfgWeapons" >> _itemClass >> "picture");
	} else {
		_picture = [_itemClass, "picture"] call A3PL_Config_GetItem;
	};
	if (!(_picture isEqualType "") || _picture == "") then {
		_picture = "";
	};

	private _dragCtrl = _display ctrlCreate ["RscPicture", 86100];
	_dragCtrl ctrlSetPosition [0, 0, 0.04 * safezoneW, 0.04 * safezoneH];
	_dragCtrl ctrlSetText _picture;
	_dragCtrl ctrlCommit 0;

	// Start drag update loop
	[] spawn {
		disableSerialization;
		private _display = findDisplay 46;
		if (isNull _display) then {_display = findDisplay 1001;};
		while {Hotbar_IsDragging && !isNull _display} do {
			private _mousePos = getMousePosition;
			private _dragCtrl = _display displayCtrl 86100;
			if (!isNull _dragCtrl) then {
				_dragCtrl ctrlSetPosition [(_mousePos select 0) - 0.02 * safezoneW, (_mousePos select 1) - 0.02 * safezoneH, 0.04 * safezoneW, 0.04 * safezoneH];
				_dragCtrl ctrlCommit 0;
			};
			sleep 0.01;
		};
	};
}] call compile_Global;

// ============================================================================
// A3PL_Hotbar_EndDrag - End dragging and process drop
// ============================================================================
["A3PL_Hotbar_EndDrag", {
	if (!Hotbar_IsDragging) exitWith {};

	private _mousePos = getMousePosition;
	private _targetSlot = [_mousePos select 0, _mousePos select 1] call A3PL_Hotbar_GetSlotAtPosition;

	// Remove drag icon from all displays
	disableSerialization;
	{
		private _disp = findDisplay _x;
		if (!isNull _disp) then {
			private _dragCtrl = _disp displayCtrl 86100;
			if (!isNull _dragCtrl) then {ctrlDelete _dragCtrl;};
		};
	} forEach [46, 602, 1001];

	// Process drop
	if (Hotbar_DragFromSlot == -1) then {
		// Dragging from inventory
		if (_targetSlot >= 0) then {
			// Drop on hotbar slot - assign item
			[_targetSlot, Hotbar_DragItem] call A3PL_Hotbar_SetSlot;
		};
	} else {
		// Dragging from hotbar
		if (_targetSlot >= 0 && _targetSlot != Hotbar_DragFromSlot) then {
			// Check premium for target slot 5-9 (keys 6,7,8,9,0)
			private _perkDay = player getVariable ["Player_PerkDay", 0];
			if (_targetSlot >= 5 && _perkDay <= 0) exitWith {
				["STR_A3PL_Hotbar_PremiumOnly" call A3PL_Localize, [1, 0.8, 0.2, 1]] call A3PL_Notification;
				Hotbar_IsDragging = false;
				Hotbar_DragItem = "";
				Hotbar_DragFromSlot = -1;
			};
			// Drop on different hotbar slot - swap/move
			private _targetItem = Hotbar_Data select _targetSlot;
			Hotbar_Data set [_targetSlot, Hotbar_DragItem];
			Hotbar_Data set [Hotbar_DragFromSlot, _targetItem];
			player setVariable ["player_hotbar", Hotbar_Data, true];
			[] call A3PL_Hotbar_UpdateUI;
			[format["STR_A3PL_Hotbar_SlotAssigned" call A3PL_Localize, _targetSlot + 1], [0.5, 1, 0.5, 1]] call A3PL_Notification;
		} else {
			if (_targetSlot == -1) then {
				// Drop outside hotbar - remove item
				Hotbar_Data set [Hotbar_DragFromSlot, ""];
				player setVariable ["player_hotbar", Hotbar_Data, true];
				[] call A3PL_Hotbar_UpdateUI;
				["STR_A3PL_Hotbar_ItemRemoved" call A3PL_Localize, [0.8, 0.8, 0.8, 1]] call A3PL_Notification;
			};
		};
	};

	Hotbar_IsDragging = false;
	Hotbar_DragItem = "";
	Hotbar_DragFromSlot = -1;
}] call compile_Global;

// ============================================================================
// A3PL_Hotbar_CancelDrag - Cancel current drag operation
// ============================================================================
["A3PL_Hotbar_CancelDrag", {
	if (!Hotbar_IsDragging) exitWith {};

	// Remove drag icon from all displays
	disableSerialization;
	{
		private _disp = findDisplay _x;
		if (!isNull _disp) then {
			private _dragCtrl = _disp displayCtrl 86100;
			if (!isNull _dragCtrl) then {ctrlDelete _dragCtrl;};
		};
	} forEach [46, 602, 1001];

	Hotbar_IsDragging = false;
	Hotbar_DragItem = "";
	Hotbar_DragFromSlot = -1;
}] call compile_Global;

// ============================================================================
// A3PL_Hotbar_RemoveItem - Remove an item from all hotbar slots
// ============================================================================
["A3PL_Hotbar_RemoveItem", {
	params [["_itemClass", "", [""]]];

	if (_itemClass == "") exitWith {};

	private _removed = false;
	for "_i" from 0 to (Hotbar_SlotCount - 1) do {
		if ((Hotbar_Data select _i) == _itemClass) then {
			Hotbar_Data set [_i, ""];
			_removed = true;
		};
	};

	if (_removed) then {
		[] call A3PL_Hotbar_Save;
		[] call A3PL_Hotbar_UpdateUI;
		["STR_A3PL_Hotbar_ItemRemoved" call A3PL_Localize, [0.8, 0.8, 0.8, 1]] call A3PL_Notification;
	};
}] call compile_Global;

// ============================================================================
// A3PL_Hotbar_Show - Show the hotbar
// ============================================================================
["A3PL_Hotbar_Show", {
	if (!Hotbar_UI_Visible) then {
		[] call A3PL_Hotbar_CreateUI;
	};
}] call compile_Global;

// ============================================================================
// A3PL_Hotbar_Hide - Hide the hotbar
// ============================================================================
["A3PL_Hotbar_Hide", {
	[] call A3PL_Hotbar_DestroyUI;
}] call compile_Global;

// ============================================================================
// A3PL_Hotbar_Toggle - Toggle hotbar visibility
// ============================================================================
["A3PL_Hotbar_Toggle", {
	if (Hotbar_UI_Visible) then {
		[] call A3PL_Hotbar_Hide;
	} else {
		[] call A3PL_Hotbar_Show;
	};
}] call compile_Global;

// ============================================================================
// DRAG & DROP FUNCTIONS FOR INVENTORY INTEGRATION
// ============================================================================

// A3PL_Hotbar_StartDrag - Called when dragging an item from inventory
["A3PL_Hotbar_StartDrag", {
	params [["_itemClass", "", [""]]];

	Hotbar_DragItem = _itemClass;
	Hotbar_DragFromSlot = -1;

	diag_log format ["A3PL_Hotbar: Started dragging item: %1", _itemClass];
}] call compile_Global;

// A3PL_Hotbar_StartDragFromSlot - Called when dragging from a hotbar slot
["A3PL_Hotbar_StartDragFromSlot", {
	params [["_slotIndex", -1, [0]]];

	if (_slotIndex >= 0 && _slotIndex < Hotbar_SlotCount) then {
		Hotbar_DragItem = Hotbar_Data select _slotIndex;
		Hotbar_DragFromSlot = _slotIndex;
	};
}] call compile_Global;

// A3PL_Hotbar_DropOnSlot - Called when dropping an item on a hotbar slot
["A3PL_Hotbar_DropOnSlot", {
	params [["_slotIndex", -1, [0]]];

	if (Hotbar_DragItem == "") exitWith {false};
	if (_slotIndex < 0 || _slotIndex >= Hotbar_SlotCount) exitWith {false};

	// If dragging from another slot, swap
	if (Hotbar_DragFromSlot >= 0 && Hotbar_DragFromSlot != _slotIndex) then {
		private _targetItem = Hotbar_Data select _slotIndex;
		Hotbar_Data set [Hotbar_DragFromSlot, _targetItem];
	};

	// Set the new slot
	[_slotIndex, Hotbar_DragItem] call A3PL_Hotbar_SetSlot;

	// Clear drag state
	Hotbar_DragItem = "";
	Hotbar_DragFromSlot = -1;

	true
}] call compile_Global;

// A3PL_Hotbar_CancelDrag - Cancel current drag operation
["A3PL_Hotbar_CancelDrag", {
	Hotbar_DragItem = "";
	Hotbar_DragFromSlot = -1;
}] call compile_Global;

// A3PL_Hotbar_GetSlotAtPosition - Get hotbar slot index at screen position
// Reads actual control positions from the dialog at runtime
["A3PL_Hotbar_GetSlotAtPosition", {
	params [["_posX", 0, [0]], ["_posY", 0, [0]]];

	disableSerialization;
	private _display = uiNamespace getVariable ["A3PL_HotbarDisplay", displayNull];
	if (isNull _display) exitWith {-1};

	private _result = -1;
	for "_i" from 0 to (Hotbar_SlotCount - 1) do {
		private _bgCtrl = _display displayCtrl (Hotbar_UI_BaseIDC + (_i * 10));
		if (!isNull _bgCtrl) then {
			private _pos = ctrlPosition _bgCtrl;
			private _cx = _pos select 0;
			private _cy = _pos select 1;
			private _cw = _pos select 2;
			private _ch = _pos select 3;
			if (_posX >= _cx && _posX <= (_cx + _cw) && _posY >= _cy && _posY <= (_cy + _ch)) then {
				_result = _i;
			};
		};
	};

	_result
}] call compile_Global;
