/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/

// Affichage du nom d'objet selon le type (héritage)
["A3PL_FactoryV2_Inheritance", {
	params ["_class", "_type", ["_info", "name"]];
	private _return = "";
	private _mainClass = "";

	if (_type isEqualTo "item") then {
		_mainClass = "CfgVehicles";
		_return = switch (_info) do {
			case ("img"): {""};
			case ("name"): {
				private _res = [_class, "name"] call A3PL_Config_GetItem;
				if (_res isEqualType false || {_res isEqualTo false}) then { _res = ""; };
				_res
			};
			case ("mainClass"): { _mainClass };
			default { "" };
		};
	} else {
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
			default {"CfgVehicles"};
		};
		_return = switch (_info) do {
			case ("img"): { getText (configFile >> _mainClass >> _class >> "picture") };
			case ("name"): {
				private _res = getText (configFile >> _mainClass >> _class >> "displayName");
				if (_res isEqualType false || {_res isEqualTo ""}) then { _res = _class; };
				_res
			};
			case ("mainClass"): { _mainClass };
			default { "" };
		};
	};
	if (isNil "_return" || {_return isEqualType false || {_return isEqualTo ""}}) then { _return = _class; };
	_return;
}] call compile_Global;

// Notification de craft terminé - résout le nom d'affichage côté client
["A3PL_FactoryV2_CraftCompletedNotify", {
	params [["_classname", ""], ["_classType", "item"], ["_amount", 1]];
	private _displayName = [_classname, _classType, "name"] call A3PL_FactoryV2_Inheritance;
	[format[("STR_Server_FactoryV2_CraftCompleted" call A3PL_Localize), _displayName, _amount], Color_Green] call A3PL_Notification;
}] call compile_Global;

// ============================================================================
// PREVIEW SYSTEM
// ============================================================================

// Nettoyer la preview
["A3PL_FactoryV2_CleanupPreview", {
	FACTORYV2_ROTATE = false;
	FACTORYV2_SESSION_ID = (missionNamespace getVariable ["FACTORYV2_SESSION_ID", 0]) + 1;
	
	private _obj = missionNamespace getVariable ["FACTORYV2_OBJPRV", objNull];
	if (!isNull _obj) then {
		{deleteVehicle _x} forEach attachedObjects _obj;
		deleteVehicle _obj;
	};
	
	private _cam = missionNamespace getVariable ["FACTORYV2_CAMERA", objNull];
	if (!isNull _cam) then {camDestroy _cam};
	
	FACTORYV2_OBJPRV = nil;
	FACTORYV2_CAMERA = nil;
	FACTORYV2_PREVIEW_POS = nil;
	
	player cameraEffect ["terminate", "BACK", "rtt_factoryv2"];
}] call compile_Global;

// Initialiser la preview avec caméra rotative
["A3PL_FactoryV2_ObjectPreview", {
	params [["_idc", 25007], ["_pos", []]];
	disableSerialization;
	
	private _display = findDisplay 2500;
	if (isNull _display) exitWith {};
	
	[] call A3PL_FactoryV2_CleanupPreview;
	
	// Position: paramètre > actuelle > défaut hangar
	private _previewPos = if (count _pos >= 3) then {_pos} else {[12601.9, 1740.74, 0.5]};
	private _cam = "camera" camCreate _previewPos;
	
	FACTORYV2_CAMERA = _cam;
	FACTORYV2_PREVIEW_POS = _previewPos;
	FACTORYV2_ROTATE = true;
	FACTORYV2_CAM_DISTANCE = 5;
	FACTORYV2_CAM_HEIGHT = 1.5;
	
	_cam cameraEffect ["internal", "BACK", "rtt_factoryv2"];
	showCinemaBorder false;
	(_display displayCtrl _idc) ctrlSetText "#(argb,512,512,1)r2t(rtt_factoryv2,1.0)";
	
	private _sessionID = missionNamespace getVariable ["FACTORYV2_SESSION_ID", 0];
	
	[_sessionID] spawn {
		params ["_mySession"];
		private _angle = 0;
		
		while {FACTORYV2_ROTATE && {(missionNamespace getVariable ["FACTORYV2_SESSION_ID", -1]) == _mySession}} do {
			private _cam = missionNamespace getVariable ["FACTORYV2_CAMERA", objNull];
			if (isNull _cam) exitWith {};
			
			private _pos = missionNamespace getVariable ["FACTORYV2_PREVIEW_POS", [12601.9, 1740.74, 0.5]];
			private _dist = missionNamespace getVariable ["FACTORYV2_CAM_DISTANCE", 5];
			private _h = missionNamespace getVariable ["FACTORYV2_CAM_HEIGHT", 1.5];
			
			_cam setPos [(_pos#0) + _dist * sin _angle, (_pos#1) + _dist * cos _angle, (_pos#2) + _h];
			_cam camSetTarget _pos;
			_cam camCommit 0;
			
			_angle = (_angle + 0.3) mod 360;
			uiSleep 0.016;
		};
	};
}] call compile_Global;

// Spawn un objet dans la preview
["A3PL_FactoryV2_ObjectPreviewSpawn", {
	params [["_classname", ""], ["_classType", "item"]];
	disableSerialization;
	
	private _old = missionNamespace getVariable ["FACTORYV2_OBJPRV", objNull];
	if (!isNull _old) then {
		{deleteVehicle _x} forEach attachedObjects _old;
		deleteVehicle _old;
	};
	
	if (isNull findDisplay 2500 || {isNull (missionNamespace getVariable ["FACTORYV2_CAMERA", objNull])} || {_classname == ""}) exitWith {};
	
	private _pos = missionNamespace getVariable ["FACTORYV2_PREVIEW_POS", [12601.9, 1740.74, 0.5]];
	private _obj = objNull;
	private _camDist = 5;
	private _camH = 1.5;
	
	private _typeParams = createHashMapFromArray [
		["item", [2, 0.5]],
		["weapon", [1, 0.3]], ["magazine", [1, 0.3]], ["aitem", [1, 0.3]], ["weaponitem", [1, 0.3]], ["secweaponitem", [1, 0.3]],
		["car", [12, 3]], ["plane", [12, 3]], ["heli", [12, 3]], ["vehicle", [12, 3]],
		["vest", [3, 1]], ["uniform", [3, 1]], ["goggles", [3, 1]], ["headgear", [3, 1]], ["backpack", [3, 1]]
	];
	
	private _params = _typeParams getOrDefault [_classType, [5, 1.5]];
	_camDist = _params#0;
	_camH = _params#1;
	
	switch (true) do {
		case (_classType isEqualTo "item"): {
			private _itemClass = [_classname, "class"] call A3PL_Config_GetItem;
			private _vehicleClass = _classname;
			if (!isNil "_itemClass") then {
				if ((typeName _itemClass) isEqualTo "STRING" && {_itemClass != ""}) then {
					_vehicleClass = _itemClass;
				};
			};
			_obj = _vehicleClass createVehicleLocal _pos;
		};
		
		case (_classType in ["weapon", "magazine", "aitem", "weaponitem", "secweaponitem"]): {
			_obj = "groundWeaponHolder" createVehicleLocal _pos;
			switch (_classType) do {
				case "weapon": {_obj addWeaponCargo [_classname, 1]};
				case "magazine": {_obj addMagazineCargo [_classname, 1]};
				default {_obj addItemCargo [_classname, 1]};
			};
		};
		
		case (_classType in ["car", "plane", "heli", "vehicle"]): {
			_obj = _classname createVehicleLocal _pos;
		};
		
		case (_classType in ["vest", "uniform", "goggles", "headgear", "backpack"]): {
			_obj = "C_man_p_beggar_F" createVehicleLocal _pos;
			switch (_classType) do {
				case "uniform": {removeUniform _obj; _obj forceAddUniform _classname};
				case "vest": {removeVest _obj; _obj addVest _classname};
				case "headgear": {removeHeadGear _obj; _obj addHeadGear _classname};
				case "backpack": {removeBackpack _obj; _obj addBackpack _classname};
				case "goggles": {removeGoggles _obj; _obj addGoggles _classname};
			};
		};
		
		default {
			_obj = _classname createVehicleLocal _pos;
		};
	};
	
	if (!isNull _obj) then {
		_obj allowDamage false;
		_obj enableSimulationGlobal false;
		_obj setPos _pos;
		_obj setDir 0;
		FACTORYV2_OBJPRV = _obj;
		FACTORYV2_CAM_DISTANCE = _camDist;
		FACTORYV2_CAM_HEIGHT = _camH;
	};
}] call compile_Global;

// Parser une position (string ou array)
// Afficher une preview complète (caméra + objet)
// Params: [_idc, _classname, _classType, _pos (optionnel)]
["A3PL_FactoryV2_ShowPreview", {
	   params [
		   ["_idc", 25007],
		   ["_classname", ""],
		   ["_classType", "item"],
		   ["_pos", []]
	   ];
   
	disableSerialization;
	private _display = findDisplay 2500;
	if (isNull _display || _classname == "") exitWith {};
   
	   // Robustly guess classType if missing
	   if (isNil "_classType" || {_classType isEqualTo ""}) then {
		   // If the id is a factory-crafted item (f_xxx), resolve via Config_FactoryV2_Crafts
		   private _resolvedPreviewPos = [];
		   private _parts = _classname splitString "_";
		   if ((count _parts) > 0 && {(toLower (_parts#0)) isEqualTo "f"}) then {
			   private _craftData = [_classname] call A3PL_FactoryV2_GetCraftData;
			   if (count _craftData >= 2) then {
				   private _resolvedClass = _craftData select 0;
				   private _resolvedType = _craftData select 1;
				   private _resolvedPreview = _craftData select 2;
				   if (!isNil "_resolvedClass" && {_resolvedClass != ""}) then {
					   _classname = _resolvedClass;
				   };
				   if (!isNil "_resolvedType" && {_resolvedType != ""}) then {
					   _classType = _resolvedType;
				   } else {
					   _classType = "item";
				   };
				   if (!isNil "_resolvedPreview" && {count _resolvedPreview >= 3}) then {
					   _resolvedPreviewPos = _resolvedPreview;
				   };
			   } else {
				   _classType = "item";
			   };
		   } else {
			   _classType = "item";
		   };
	   };
	// Position par défaut si non fournie. Priority: explicit _pos param > resolved preview from craft > default hangar
	private _previewPos = if (count _pos >= 3) then {_pos} else { if (count _resolvedPreviewPos >= 3) then {_resolvedPreviewPos} else {[12601.9, 1740.74, 0.5]} };
   
	// Vérifier si on doit recréer la caméra
	private _cam = missionNamespace getVariable ["FACTORYV2_CAMERA", objNull];
	private _currentPos = missionNamespace getVariable ["FACTORYV2_PREVIEW_POS", []];

	if (isNull _cam || {!(_previewPos isEqualTo _currentPos)}) then {
		[_idc, _previewPos] call A3PL_FactoryV2_ObjectPreview;
	} else {
		(_display displayCtrl _idc) ctrlSetText "#(argb,512,512,1)r2t(rtt_factoryv2,1.0)";
	};

	[_classname, _classType] spawn A3PL_FactoryV2_ObjectPreviewSpawn;
}] call compile_Global;

// Helper: Récupérer les données d'un craft depuis les Config HashMaps
// Version simple: parcourt Config_FactoryV2_Crafts et compare (_v select 0) avec l'ID fourni
// Retourne: [classname, classType, previewPos] ou [] si non trouvé
// Config_FactoryV2_Crafts: craftID -> [name, price, required_items, base_duration, license_id, classname, class_type, output_amount, description]
// Config_FactoryV2_Licenses: licenseID -> [name, price, preview_pos]
["A3PL_FactoryV2_GetCraftData", {
	params ["_itemID"];

	if (isNil "_itemID" || _itemID isEqualTo "") exitWith {[]};
	private _data = [];
	
	if (_itemID isEqualType "") then {
		private _splitString = _itemID splitString "_";
		if (_splitString#0 isEqualTo "craft") then {
			_itemID = call compile (_splitString#1);
		};
	};

	if (_itemID isEqualType 0) then {
		_itemID = str _itemID;
		_data = Config_FactoryV2_Crafts getOrDefault [_itemID, []];
	} else {
		{
			private _k = _x;
			private _v = _y;
			if (count _v >= 1) then {
				private _name = _v select 0;
				if (toLower _name isEqualTo toLower _itemID) then { _data = _v;};
			};
		} forEach Config_FactoryV2_Crafts;
	};

	if (count _data < 7) exitWith {[]};

	private _classname = _data select 5;
	private _classType = _data select 6;
	private _licenseID = _data select 4;
	private _price = _data select 1;

	if (isNil "_classname" || _classname isEqualTo "") exitWith {[]};

	private _previewPos = [];
	if ((!isNil "_licenseID") && (_licenseID isNotEqualTo "") && (_licenseID isNotEqualTo 0)) then {
		private _licenseEntry = Config_FactoryV2_Licenses getOrDefault [_licenseID, []];
		if (count _licenseEntry >= 3) then {
			_previewPos = _licenseEntry select 2;
		};
	};

	if (count _previewPos < 3) then {
		_previewPos = [12601.9, 1740.74, 0.5];
	};

	[_classname, _classType, _previewPos, _price];
}] call compile_Global;

// Ouvrir le dialog FactoryV2
// Paramètres:
//   - Mode civil: ["civ"] call A3PL_FactoryV2_Open;
//   - Mode entreprise: ["company", _cid] call A3PL_FactoryV2_Open;
["A3PL_FactoryV2_Open", {
	params [["_mode", "company"], ["_cidParam", 0]];
	disableSerialization;

	private _charID = player getVariable ["character_id", ""];
	private _ownerType = "";
	private _ownerID = "";
	private _isCivilian = false;
	private _cid = 0;

	if (_mode isEqualTo "civ") then {
		// === MODE CIVIL ===
		_ownerType = "player";
		_ownerID = _charID;
		_isCivilian = true;
	} else {
		// === MODE ENTREPRISE ===
		// CID passé en paramètre
		_cid = _cidParam;

		if (_cid isEqualTo 0) exitWith {
			[("STR_A3PL_FactoryV2_NoCompany" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};

		private _employees = [_cid, "employees"] call A3PL_Config_GetCompanyData;
		if (isNil "_employees") exitWith {
			[("STR_A3PL_FactoryV2_CompanyNotFound" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};

		private _isMember = false;
		{
			if ((_x select 0) isEqualTo _charID) exitWith {_isMember = true;};
		} foreach _employees;

		if (!_isMember) exitWith {
			[("STR_A3PL_FactoryV2_NotMember" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};

		_ownerType = "company";
		_ownerID = _cid;
	};

	if (_ownerType isEqualTo "" || _ownerID isEqualTo "") exitWith {
		[("STR_A3PL_FactoryV2_AccessDenied" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};

	if (!isNull Player_Item) then {call A3PL_Inventory_PutBack;};
	createDialog "Dialog_Factory_V2";

	A3PL_FactoryV2_UpgradesEHAdded = false;

	// Stocker les informations de propriétaire pour le client
	player setVariable ["A3PL_FactoryV2_OwnerType", _ownerType];
	player setVariable ["A3PL_FactoryV2_OwnerID", _ownerID];
	player setVariable ["A3PL_FactoryV2_IsCivilian", _isCivilian];
	player setVariable ["A3PL_FactoryV2_NpcObj", player_objintersect];
	// Garder CID si c'est une entreprise (pour rétro-compatibilité)
	if (!_isCivilian) then {
		player setVariable ["A3PL_FactoryV2_CID", _cid];
	};

	[_ownerType, _ownerID, player, player_objintersect] remoteExec ["Server_FactoryV2_LoadData", 2];

	[_ownerType, _ownerID, _isCivilian] spawn A3PL_FactoryV2_InitUI;
}] call compile_Global;

// Initialiser l'UI
["A3PL_FactoryV2_InitUI", {
	disableSerialization;
	private _ownerType = param [0, "company"];
	private _ownerID = param [1, 0];
	private _isCivilian = param [2, false];
	private _display = findDisplay 2500;

	if (isNull _display) exitWith {};

	A3PL_FactoryV2_EventHandlersAdded = false;
	A3PL_FactoryV2_FactoryTreeLoaded = false;

	_display displayAddEventHandler ["Unload", {
		[] call A3PL_FactoryV2_CleanupPreview;
		A3PL_FactoryV2_EventHandlersAdded = nil;
		A3PL_FactoryV2_FactoryEHAdded = nil;
		A3PL_FactoryV2_CraftsEHAdded = nil;
		A3PL_FactoryV2_StorageEHAdded = nil;
		A3PL_FactoryV2_ShareEHAdded = nil;
		A3PL_FactoryV2_FactoryTreeLoaded = nil;
		A3PL_FactoryV2_FactoryCrafts = nil;
		A3PL_FactoryV2_FactoryLicenses = nil;
		A3PL_FactoryV2_ShareableCrafts = nil;
		A3PL_FactoryV2_TotalSlots = nil;
		FACTORYV2_CURRENT_PAGE = nil;
		player setVariable ["A3PL_FactoryV2_CID", nil];
		player setVariable ["A3PL_FactoryV2_OwnerType", nil];
		player setVariable ["A3PL_FactoryV2_OwnerID", nil];
		player setVariable ["A3PL_FactoryV2_IsCivilian", nil];
	}];

	(_display displayCtrl 25001) ctrlAddEventHandler ["ButtonClick", {[0] call A3PL_FactoryV2_SwitchPage;}];
	(_display displayCtrl 28001) ctrlAddEventHandler ["ButtonClick", {[1] call A3PL_FactoryV2_SwitchPage;}];
	(_display displayCtrl 26001) ctrlAddEventHandler ["ButtonClick", {[2] call A3PL_FactoryV2_SwitchPage;}];
	(_display displayCtrl 27001) ctrlAddEventHandler ["ButtonClick", {[3] call A3PL_FactoryV2_SwitchPage;}];
	if (_isCivilian) then {
		(_display displayCtrl 29001) ctrlEnable false;
		(_display displayCtrl 29001) ctrlSetTooltip ("STR_A3PL_FactoryV2_ShareNotAvailableCivilian" call A3PL_Localize);
	} else {
		(_display displayCtrl 29001) ctrlAddEventHandler ["ButtonClick", {[4] call A3PL_FactoryV2_SwitchPage;}];
	};

	[0] call A3PL_FactoryV2_SwitchPage;

	[] spawn {
		while {!isNull (findDisplay 2500)} do {
			[] call A3PL_FactoryV2_RefreshData;
			uiSleep 15;
		};
	};

	[] spawn {
		while {!isNull (findDisplay 2500)} do {
			[] call A3PL_FactoryV2_UpdateActiveCraftsDisplay;
			uiSleep 1;
		};
	};
}] call compile_Global;

// Changer de page
["A3PL_FactoryV2_SwitchPage", {
	disableSerialization;
	private _page = param [0, 0];
	private _display = findDisplay 2500;
	
	if (isNull _display) exitWith {};
	
	// Stocker la page actuelle
	FACTORYV2_CURRENT_PAGE = _page;
	
	// Liste des IDC par page
	private _pageControls = [
		// Page 0: Factory (My Factory)
		[250000, 25002, 25003, 25004, 25005, 25006, 25007, 25008, 25009, 25010, 25011, 25012, 25013, 25014, 25015, 25016, 25017, 25018, 25019, 25020, 25021, 25022, 25023, 25024, 25025, 25026, 25027, 25028, 25029, 25030, 25031, 25032, 25033],
		// Page 1: Crafts
		[28000, 28002, 28003, 28004, 28005, 28006],
		// Page 2: Storage
		[26000, 26002, 26003, 26004, 26005, 26006, 26007, 26008],
		// Page 3: Upgrades
		[27000, 27002, 27003, 27004, 27005, 27006, 27007, 27008, 27009, 27010, 27011, 27012, 27013, 27014, 27015, 27016, 27017, 27018, 27019, 27020, 27021, 27022, 27023, 27024, 27025],
		// Page 4: Share
		[29000, 29002, 29003, 29004, 29005, 29006, 29007, 29008, 29009, 29010, 29011]
	];
	
	// Cacher tous les backgrounds
	{(_display displayCtrl _x) ctrlShow false;} foreach [250000, 26000, 27000, 28000, 29000];
	
	// Cacher tous les contrôles de toutes les pages
	{
		{
			private _ctrl = _display displayCtrl _x;
			if (!isNull _ctrl) then {
				_ctrl ctrlShow false;
			};
		} foreach _x;
	} foreach _pageControls;
	
	// Afficher le background de la page active
	private _backgrounds = [250000, 28000, 26000, 27000, 29000];
	(_display displayCtrl (_backgrounds select _page)) ctrlShow true;
	
	// Afficher les contrôles de la page active
	{
		private _ctrl = _display displayCtrl _x;
		if (!isNull _ctrl) then {
			_ctrl ctrlShow true;
		};
	} foreach (_pageControls select _page);
	
	// Charger les données de la page
	// Note: La preview sera initialisée quand un craft est sélectionné (via ShowPreview)
	// pour utiliser la position de la licence depuis la DB
	
	switch (_page) do {
		case 0: {[] call A3PL_FactoryV2_LoadMyFactory;};
		case 1: {[] call A3PL_FactoryV2_LoadCrafts;};
		case 2: {[] call A3PL_FactoryV2_LoadStorage;};
		case 3: {[] call A3PL_FactoryV2_LoadUpgrades;};
		case 4: {
			// Bloquer l'accès à la page Share pour les civils
			private _isCivilian = player getVariable ["A3PL_FactoryV2_IsCivilian", false];
			if (_isCivilian) then {
				[("STR_A3PL_FactoryV2_ShareNotAvailableCivilian" call A3PL_Localize), Color_Red] call A3PL_Notification;
				[0] call A3PL_FactoryV2_SwitchPage;
			} else {
				[] call A3PL_FactoryV2_LoadShare;
			};
		};
	};
}] call compile_Global;

// Charger la page My Factory
["A3PL_FactoryV2_LoadMyFactory", {
	disableSerialization;
	private _display = findDisplay 2500;
	if (isNull _display) exitWith {};

	private _ownerType = player getVariable ["A3PL_FactoryV2_OwnerType", ""];
	private _ownerID = player getVariable ["A3PL_FactoryV2_OwnerID", ""];
	if (_ownerType isEqualTo "" || _ownerID isEqualTo "") exitWith {};

	(_display displayCtrl 25032) ctrlSetText "1";

	if (isNil "A3PL_FactoryV2_FactoryEHAdded" || {!A3PL_FactoryV2_FactoryEHAdded}) then {
		private _startButton = _display displayCtrl 25033;
		_startButton ctrlAddEventHandler ["ButtonClick", {[] call A3PL_FactoryV2_StartCraftFromUI;}];
		
		private _searchControl = _display displayCtrl 25003;
		_searchControl ctrlAddEventHandler ["KeyUp", {[] call A3PL_FactoryV2_SearchCraftsInFactory;}];
		
		private _craftTree = _display displayCtrl 25002;
		_craftTree ctrlAddEventHandler ["TreeSelChanged", {
			params ["_control", "_selectedPath"];
			disableSerialization;
			private _display = findDisplay 2500;
			if (isNull _display) exitWith {};
			
			private _descCtrl = _display displayCtrl 25004;
			private _amountCtrl = _display displayCtrl 25005;
			private _reqItemsCtrl = _display displayCtrl 25006;
			
			if (count _selectedPath < 1) exitWith {
				_descCtrl ctrlSetStructuredText parseText "";
				_amountCtrl ctrlSetStructuredText parseText "";
				lbClear _reqItemsCtrl;
			};
			
			private _data = _control tvData _selectedPath;
			if (_data isEqualTo "" || {(_data find "license_") == 0}) exitWith {
				_descCtrl ctrlSetStructuredText parseText "";
				_amountCtrl ctrlSetStructuredText parseText "";
				lbClear _reqItemsCtrl;
			};
			
			private _craftID = _data;
			private _craftData = [(call compile _craftID)] call A3PL_FactoryV2_GetCraftData;
			if (count _craftData >= 3) then {
				[25007, _craftData#0, _craftData#1, _craftData#2] call A3PL_FactoryV2_ShowPreview;
			};
			
			private _outputAmount = 1;
			private _description = "";
			private _requiredItems = [];
			
			if (!isNil "A3PL_FactoryV2_FactoryCrafts") then {
				{
					private _rawID = _x select 0;
					private _id = if (_rawID isEqualType "") then {_rawID} else {str _rawID};
					if (_id isEqualTo _craftID) exitWith {
						_outputAmount = if (count _x > 6) then {_x select 6} else {1};
						_description = if (count _x > 7) then {_x select 7} else {""};
						_requiredItems = if (count _x > 8) then {_x select 8} else {[]};
					};
				} foreach A3PL_FactoryV2_FactoryCrafts;
			};

			_descCtrl ctrlSetStructuredText parseText format ["<t size='0.9'>%1</t>", _description];
			
			_amountCtrl ctrlSetStructuredText parseText format ["<t size='1.2' align='center'>%1</t>", _outputAmount];
			
			lbClear _reqItemsCtrl;
			private _storage = missionNamespace getVariable ["A3PL_FactoryV2_CurrentStorage", []];
			{
				if (_x isEqualType []) then {
					private _itemID = _x select 0;
					private _itemIDLower = toLower _itemID;
					private _itemAmount = if (count _x > 1) then {_x select 1} else {1};
					   private _itemName = [_itemID, "item", "name"] call A3PL_FactoryV2_Inheritance;
					   if (isNil "_itemName" || {_itemName isEqualTo ""}) then {_itemName = _itemID;};

					private _inStock = 0;
					{if ((toLower (_x select 0)) isEqualTo _itemIDLower) exitWith {_inStock = _x select 1;};} forEach _storage;
					
					private _index = _reqItemsCtrl lbAdd format ["%1 x%2 (%3 %4)", _itemName, _itemAmount, _inStock, ("STR_A3PL_FactoryV2_InStock" call A3PL_Localize)];
					
					if (_inStock >= _itemAmount) then {
						_reqItemsCtrl lbSetColor [_index, [0.2, 0.8, 0.2, 1]];
					} else {
						_reqItemsCtrl lbSetColor [_index, [0.8, 0.2, 0.2, 1]];
					};
				};
			} foreach _requiredItems;
		}];
		
		A3PL_FactoryV2_FactoryEHAdded = true;
	};
	
	[25007] call A3PL_FactoryV2_ObjectPreview;

	private _npcObj = player getVariable ["A3PL_FactoryV2_NpcObj", objNull];
	[_ownerType, _ownerID, player, _npcObj] remoteExec ["Server_FactoryV2_GetStorage", 2];

	[_ownerType, _ownerID, player] remoteExec ["Server_FactoryV2_GetActiveCrafts", 2];

	if (isNil "A3PL_FactoryV2_FactoryTreeLoaded" || {!A3PL_FactoryV2_FactoryTreeLoaded}) then {
		private _npcObj = player getVariable ["A3PL_FactoryV2_NpcObj", objNull];
		[_ownerType, _ownerID, player, _npcObj] remoteExec ["Server_FactoryV2_GetOwnedCraftsForFactory", 2];
	};
}] call compile_Global;

// Recevoir les crafts actifs depuis le serveur
["A3PL_FactoryV2_ReceiveActiveCrafts", {
	disableSerialization;
	private _activeCrafts = param [0, []];
	private _totalSlots = param [1, 1];
	private _display = findDisplay 2500;
	if (isNull _display) exitWith {};

	A3PL_FactoryV2_TotalSlots = _totalSlots;

	diag_log format ["[FactoryV2] ReceiveActiveCrafts - Raw data: %1", _activeCrafts];

	private _receivedAt = diag_tickTime;

	private _processedCrafts = [];
	{
		private _craftDBID = _x select 0;
		private _craftName = _x select 1;
		private _secondsRemaining = _x select 2;
		private _duration = _x select 3;
		private _amount = _x select 4;
		private _craftClass = if (count _x > 5) then {_x select 5} else {""};
		private _craftType = if (count _x > 6) then {_x select 6} else {"item"};

		if (_secondsRemaining isEqualType "") then {
			_secondsRemaining = parseNumber _secondsRemaining;
		};

		diag_log format ["[FactoryV2] Craft %1 - secondsRemaining: %2, duration: %3", _craftDBID, _secondsRemaining, _duration];

		_processedCrafts pushBack [_craftDBID, _craftName, _secondsRemaining, _duration, _amount, _craftClass, _craftType];
	} forEach _activeCrafts;

	A3PL_FactoryV2_ActiveCraftsData = _processedCrafts;
	A3PL_FactoryV2_DataReceivedAt = _receivedAt; 
	diag_log format ["[FactoryV2] Processed crafts stored: %1, receivedAt: %2", _processedCrafts, _receivedAt];

	private _slotControls = [
		[25008, 25009, 25010],
		[25011, 25012, 25013],
		[25014, 25015, 25016],
		[25017, 25018, 25019],
		[25020, 25021, 25022],
		[25023, 25024, 25025],
		[25026, 25027, 25028],
		[25029, 25030, 25031]
	];

	for "_i" from 0 to 7 do {
		private _slot = _slotControls select _i;
		private _nameCtrl = _display displayCtrl (_slot select 0);
		private _objCtrl = _display displayCtrl (_slot select 1);
		private _progressCtrl = _display displayCtrl (_slot select 2);

		private _isVisible = _i < _totalSlots;
		_nameCtrl ctrlShow _isVisible;
		_objCtrl ctrlShow _isVisible;
		_progressCtrl ctrlShow _isVisible;

		if (_isVisible) then {
			_nameCtrl ctrlSetStructuredText parseText format ["<t size='0.9'>Slot %1 - <t color='#00FF00'>%2</t></t>", _i + 1, ("STR_A3PL_FactoryV2_SlotFree" call A3PL_Localize)];
			_objCtrl ctrlSetStructuredText parseText "";
			_progressCtrl progressSetPosition 0;
		};
	};

	[] call A3PL_FactoryV2_UpdateActiveCraftsDisplay;
}] call compile_Global;

// Boucle d'affichage - utilise les secondes restantes calculées par MySQL + temps écoulé local
["A3PL_FactoryV2_UpdateActiveCraftsDisplay", {
	disableSerialization;
	private _display = findDisplay 2500;
	if (isNull _display) exitWith {};

	private _activeCrafts = missionNamespace getVariable ["A3PL_FactoryV2_ActiveCraftsData", []];
	private _totalSlots = missionNamespace getVariable ["A3PL_FactoryV2_TotalSlots", 1];
	private _dataReceivedAt = missionNamespace getVariable ["A3PL_FactoryV2_DataReceivedAt", 0];

	private _elapsedSinceReceived = if (_dataReceivedAt > 0) then {diag_tickTime - _dataReceivedAt} else {0};

	private _lastDebug = missionNamespace getVariable ["A3PL_FactoryV2_LastDebugTime", 0];
	if (diag_tickTime - _lastDebug > 5) then {
		diag_log format ["[FactoryV2] UpdateDisplay - DataReceivedAt: %1, ElapsedSince: %2, CurrentTickTime: %3", _dataReceivedAt, _elapsedSinceReceived, diag_tickTime];
		diag_log format ["[FactoryV2] UpdateDisplay - ActiveCrafts count: %1, Data: %2", count _activeCrafts, _activeCrafts];
		missionNamespace setVariable ["A3PL_FactoryV2_LastDebugTime", diag_tickTime];
	};

	private _slotControls = [
		[25008, 25009, 25010],
		[25011, 25012, 25013],
		[25014, 25015, 25016],
		[25017, 25018, 25019],
		[25020, 25021, 25022],
		[25023, 25024, 25025],
		[25026, 25027, 25028],
		[25029, 25030, 25031]
	];

	private _craftCount = count _activeCrafts;
	for "_i" from _craftCount to (_totalSlots - 1) do {
		private _slot = _slotControls select _i;
		private _nameCtrl = _display displayCtrl (_slot select 0);
		private _objCtrl = _display displayCtrl (_slot select 1);
		private _progressCtrl = _display displayCtrl (_slot select 2);

		_nameCtrl ctrlSetStructuredText parseText format ["<t size='0.9'>Slot %1 - <t color='#00FF00'>%2</t></t>", _i + 1, ("STR_A3PL_FactoryV2_SlotFree" call A3PL_Localize)];
		_objCtrl ctrlSetStructuredText parseText "";
		_progressCtrl progressSetPosition 0;
	};

	{
		if (_forEachIndex >= _totalSlots) exitWith {};

		private _craftDBID = _x select 0;
		private _craftName = _x select 1;
		private _secondsRemainingAtReceive = _x select 2;
		private _totalDuration = _x select 3;
		private _amount = _x select 4;
		private _craftClass = if (count _x > 5) then {_x select 5} else {""};
		private _craftType = if (count _x > 6) then {_x select 6} else {"item"};

		if (_craftClass != "") then {
			private _displayName = [_craftClass, _craftType, "name"] call A3PL_FactoryV2_Inheritance;
			if (!isNil "_displayName" && {_displayName != ""}) then {
				_craftName = _displayName;
			};
		};

		private _slot = _slotControls select _forEachIndex;
		private _nameCtrl = _display displayCtrl (_slot select 0);
		private _objCtrl = _display displayCtrl (_slot select 1);
		private _progressCtrl = _display displayCtrl (_slot select 2);

		private _secLeft = (_secondsRemainingAtReceive - _elapsedSinceReceived) max 0;
		private _progress = if (_totalDuration > 0) then {(1 - (_secLeft / _totalDuration)) min 1 max 0} else {1};

		private _timeStr = "";
		if (_secLeft > 3600) then {
			_timeStr = format ["%1h %2m", floor(_secLeft / 3600), floor((_secLeft mod 3600) / 60)];
		} else {
			if (_secLeft > 60) then {
				_timeStr = format ["%1m %2s", floor(_secLeft / 60), floor(_secLeft mod 60)];
			} else {
				_timeStr = format ["%1s", floor _secLeft];
			};
		};

		_nameCtrl ctrlSetStructuredText parseText format ["<t size='0.9'>Slot %1 - <t color='#FFA500'>%2</t></t>", _forEachIndex + 1, _timeStr];
		_objCtrl ctrlSetStructuredText parseText format ["<t size='0.85'>%1 (x%2)</t>", _craftName, _amount];
		_progressCtrl progressSetPosition _progress;
	} foreach _activeCrafts;
}] call compile_Global;

["A3PL_FactoryV2_ParseDateTime", {
	params ["_dateTimeStr"];

	private _parts = _dateTimeStr splitString " :-";
	if (count _parts < 6) exitWith {systemTimeUTC};

	[
		parseNumber (_parts select 0),
		parseNumber (_parts select 1),
		parseNumber (_parts select 2),
		parseNumber (_parts select 3),
		parseNumber (_parts select 4),
		parseNumber (_parts select 5)
	]
}] call compile_Global;

["A3PL_FactoryV2_DateTimeToTimestamp", {
	params ["_dateTime"];

	private _year = _dateTime select 0;
	private _month = _dateTime select 1;
	private _day = _dateTime select 2;
	private _hour = _dateTime select 3;
	private _minute = _dateTime select 4;
	private _second = _dateTime select 5;

	private _yearsSince2020 = _year - 2020;
	private _days = _yearsSince2020 * 365 + floor(_yearsSince2020 / 4);

	private _daysPerMonth = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
	for "_i" from 1 to (_month - 1) do {
		_days = _days + (_daysPerMonth select _i);
	};
	_days = _days + _day;

	(_days * 86400) + (_hour * 3600) + (_minute * 60) + _second
}] call compile_Global;

// Recevoir les crafts possédés pour la page Factory (arbre de gauche)
["A3PL_FactoryV2_ReceiveOwnedCraftsForFactory", {
	disableSerialization;

	private _crafts = param [0, []];
	private _licenses = param [1, []];

	if (!isNil "A3PL_FactoryV2_LoadingForShare" && {A3PL_FactoryV2_LoadingForShare}) exitWith {
		A3PL_FactoryV2_LoadingForShare = false;
		[_crafts, _licenses] call A3PL_FactoryV2_ReceiveShareableCrafts;
	};

	private _display = findDisplay 2500;
	if (isNull _display) exitWith {};
		
	A3PL_FactoryV2_FactoryCrafts = _crafts;
	A3PL_FactoryV2_FactoryLicenses = _licenses;
	
	private _craftTree = _display displayCtrl 25002;
	tvClear _craftTree;
	
	private _licenseIndices = [];
	
	private _normalizeID = {
		private _val = _this;
		if (_val isEqualType "") then {_val} else {str _val};
	};
	
	{
		private _licenseID = (_x select 0) call _normalizeID;
		private _licenseName = _x select 1;
		private _hasLicense = _x select 2;
				
		if (_hasLicense) then {
			private _index = _craftTree tvAdd [[], _licenseName];
			_craftTree tvSetData [[_index], format ["license_%1", _licenseID]];
			_licenseIndices pushBack [_licenseID, _index];
		};
	} foreach _licenses;
		
	{
		private _craftID = _x select 0;
		private _craftClass = _x select 4;
		private _craftType = _x select 5;
		private _hasCraft = _x select 2;
		private _licenseID = (_x select 3) call _normalizeID;
		private _isShared = if (count _x > 10) then {_x select 10} else {false};
		private _craftDisplayName = [_craftClass, _craftType, "name"] call A3PL_FactoryV2_Inheritance;
		if (isNil "_craftDisplayName" || {_craftDisplayName isEqualTo ""}) then { _craftDisplayName = _craftClass; };

		if (_isShared) then {
			_craftDisplayName = format ["%1 %2", _craftDisplayName, "STR_A3PL_FactoryV2_SharedTag" call A3PL_Localize];
		};

		if (_hasCraft) then {
			private _parentIndex = -1;
			{
				if ((_x select 0) isEqualTo _licenseID) exitWith {
					_parentIndex = _x select 1;
				};
			} foreach _licenseIndices;
			if (_parentIndex >= 0) then {
				private _index = _craftTree tvAdd [[_parentIndex], _craftDisplayName];
				_craftTree tvSetData [[_parentIndex, _index], _craftID];
			} else {
				private _index = _craftTree tvAdd [[], _craftDisplayName];
				_craftTree tvSetData [[_index], _craftID];
			};
		};
	} foreach _crafts;
	
	A3PL_FactoryV2_FactoryTreeLoaded = true;
}] call compile_Global;

// Lancer un craft depuis l'UI
["A3PL_FactoryV2_StartCraftFromUI", {
	if (!(call A3PL_Player_AntiSpam)) exitWith {};
	disableSerialization;
	private _display = findDisplay 2500;
	if (isNull _display) exitWith {};
	
	private _craftTree = _display displayCtrl 25002;
	private _selectedPath = tvCurSel _craftTree;
	
	// Vérifier qu'il y a une sélection
	if (count _selectedPath < 1) exitWith {
		[("STR_A3PL_FactoryV2_NoSelection" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	
	private _data = _craftTree tvData _selectedPath;
	
	// Vérifier que ce n'est pas une licence (les licences ont un data qui commence par "license_")
	if (_data isEqualTo "" || {(_data select [0, 8]) isEqualTo "license_"}) exitWith {
		[("STR_A3PL_FactoryV2_NoSelection" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	
	private _amountText = ctrlText (_display displayCtrl 25032);
	private _amount = floor(parseNumber _amountText);
	if (_amount < 1) then {_amount = 1;};

	private _craftID = parseNumber _data;
	private _ownerType = player getVariable ["A3PL_FactoryV2_OwnerType", ""];
	private _ownerID = player getVariable ["A3PL_FactoryV2_OwnerID", ""];
	if (_ownerType isEqualTo "" || _ownerID isEqualTo "") exitWith {};

	private _npcObj = player getVariable ["A3PL_FactoryV2_NpcObj", objNull];
	[_ownerType, _ownerID, _craftID, _amount, player, _npcObj] remoteExec ["Server_FactoryV2_StartCraft", 2];
}] call compile_Global;

// Rechercher dans les crafts (page Factory)
["A3PL_FactoryV2_SearchCraftsInFactory", {
	disableSerialization;
	private _display = findDisplay 2500;
	if (isNull _display) exitWith {};

	private _searchText = toLower (ctrlText (_display displayCtrl 25003));
	private _craftTree = _display displayCtrl 25002;

	tvClear _craftTree;

	if (isNil "A3PL_FactoryV2_FactoryCrafts" || isNil "A3PL_FactoryV2_FactoryLicenses") exitWith {};

	private _crafts = A3PL_FactoryV2_FactoryCrafts;
	private _licenses = A3PL_FactoryV2_FactoryLicenses;

	private _licenseIndices = [];

	private _normalizeID = {
		private _val = _this;
		if (_val isEqualType "") then {_val} else {str _val};
	};

	private _licensesWithMatches = [];

	{
		private _craftID = _x select 0;
		private _craftClass = _x select 4;
		private _craftType = _x select 5;
		private _hasCraft = _x select 2;
		private _licenseID = (_x select 3) call _normalizeID;
		private _isShared = if (count _x > 10) then {_x select 10} else {false};

		if (!_hasCraft) then {continue;};

		private _craftDisplayName = [_craftClass, _craftType, "name"] call A3PL_FactoryV2_Inheritance;
		if (isNil "_craftDisplayName" || {_craftDisplayName isEqualTo ""}) then {_craftDisplayName = _craftClass;};

		if (_searchText != "" && {!((toLower _craftDisplayName) find _searchText >= 0)}) then {continue;};

		if !(_licenseID in _licensesWithMatches) then {
			_licensesWithMatches pushBack _licenseID;
		};
	} foreach _crafts;

	{
		private _licenseID = (_x select 0) call _normalizeID;
		private _licenseName = _x select 1;
		private _hasLicense = _x select 2;

		if (_hasLicense && {_licenseID in _licensesWithMatches}) then {
			private _index = _craftTree tvAdd [[], _licenseName];
			_craftTree tvSetData [[_index], format ["license_%1", _licenseID]];
			_licenseIndices pushBack [_licenseID, _index];
		};
	} foreach _licenses;

	{
		private _craftID = _x select 0;
		private _craftClass = _x select 4;
		private _craftType = _x select 5;
		private _hasCraft = _x select 2;
		private _licenseID = (_x select 3) call _normalizeID;
		private _isShared = if (count _x > 10) then {_x select 10} else {false};

		if (!_hasCraft) then {continue;};

		private _craftDisplayName = [_craftClass, _craftType, "name"] call A3PL_FactoryV2_Inheritance;
		if (isNil "_craftDisplayName" || {_craftDisplayName isEqualTo ""}) then {_craftDisplayName = _craftClass;};

		if (_searchText != "" && {!((toLower _craftDisplayName) find _searchText >= 0)}) then {continue;};

		if (_isShared) then {
			_craftDisplayName = format ["%1 %2", _craftDisplayName, "STR_A3PL_FactoryV2_SharedTag" call A3PL_Localize];
		};

		private _parentIndex = -1;
		{
			if ((_x select 0) isEqualTo _licenseID) exitWith {
				_parentIndex = _x select 1;
			};
		} foreach _licenseIndices;

		if (_parentIndex >= 0) then {
			private _index = _craftTree tvAdd [[_parentIndex], _craftDisplayName];
			_craftTree tvSetData [[_parentIndex, _index], _craftID];
		} else {
			private _index = _craftTree tvAdd [[], _craftDisplayName];
			_craftTree tvSetData [[_index], _craftID];
		};
	} foreach _crafts;

	if (_searchText != "") then {
		for "_i" from 0 to ((count _licenseIndices) - 1) do {
			_craftTree tvExpand [_i];
		};
	};
}] call compile_Global;

// Charger la page Crafts
["A3PL_FactoryV2_LoadCrafts", {
	disableSerialization;
	private _display = findDisplay 2500;
	if (isNull _display) exitWith {};

	private _ownerType = player getVariable ["A3PL_FactoryV2_OwnerType", ""];
	private _ownerID = player getVariable ["A3PL_FactoryV2_OwnerID", ""];
	private _isCivilian = player getVariable ["A3PL_FactoryV2_IsCivilian", false];
	if (_ownerType isEqualTo "" || _ownerID isEqualTo "") exitWith {};
	
	if (isNil "A3PL_FactoryV2_CraftsEHAdded" || {!A3PL_FactoryV2_CraftsEHAdded}) then {
		private _buyButton = _display displayCtrl 28006;
		_buyButton ctrlAddEventHandler ["ButtonClick", {[] call A3PL_FactoryV2_BuyCraft;}];
		
		private _myCraftsTree = _display displayCtrl 28002;
		_myCraftsTree ctrlAddEventHandler ["TreeSelChanged", {
			params ["_control", "_selectedPath"];
			if (count _selectedPath < 1) exitWith {};
			private _data = _control tvData _selectedPath;
			
			private _display = findDisplay 2500;
			private _priceCtrl = _display displayCtrl 28005;
			_priceCtrl ctrlSetStructuredText parseText "";
			
			if (_data isEqualTo "" || {(_data find "license_") == 0}) exitWith {};
			private _craftData = [_data] call A3PL_FactoryV2_GetCraftData;
			if (count _craftData >= 3) then {
				[28003, _craftData#0, _craftData#1, _craftData#2] call A3PL_FactoryV2_ShowPreview;
			};
		}];
		
		private _availableTree = _display displayCtrl 28004;
		_availableTree ctrlAddEventHandler ["TreeSelChanged", {
			params ["_control", "_selectedPath"];
			if (count _selectedPath < 1) exitWith {};
			private _data = _control tvData _selectedPath;
			if (_data isEqualTo "") exitWith {};
			
			private _display = findDisplay 2500;
			private _priceCtrl = _display displayCtrl 28005;

			// Déterminer le solde disponible selon le type de propriétaire
			private _isCivilian = player getVariable ["A3PL_FactoryV2_IsCivilian", false];
			private _availableFunds = 0;
			if (_isCivilian) then {
				_availableFunds = player getVariable ["player_bank", 0];
			} else {
				private _cid = player getVariable ["A3PL_FactoryV2_CID", 0];
				_availableFunds = [_cid, "bank"] call A3PL_Config_GetCompanyData;
				if (isNil "_availableFunds") then {_availableFunds = 0;};
			};

			if ((_data find "license_") == 0) then {
				private _licenseID = ((_data splitString "_") select 1);
				private _licenseData = Config_FactoryV2_Licenses getOrDefault [_licenseID, []];
				private _price = if (count _licenseData >= 2) then {_licenseData select 1} else {0};
				if (_price isEqualType "") then {_price = parseNumber _price;};

				private _color = if (_availableFunds >= _price) then {"#00FF00"} else {"#FF0000"};
				_priceCtrl ctrlSetStructuredText parseText format ["<t align='center' color='%1'>$%2</t>", _color, [_price, 1, 0, true] call CBA_fnc_formatNumber];
			} else {
				private _craftID = call compile ((_data splitString "_") select 1);
				private _craftData = [_craftID] call A3PL_FactoryV2_GetCraftData;
				private _price = _craftData select 3;

				private _color = if (_availableFunds >= _price) then {"#00FF00"} else {"#FF0000"};
				_priceCtrl ctrlSetStructuredText parseText format ["<t align='center' color='%1'>$%2</t>", _color, [_price, 1, 0, true] call CBA_fnc_formatNumber];

				if (count _craftData >= 3) then {
					[28003, _craftData#0, _craftData#1, _craftData#2] call A3PL_FactoryV2_ShowPreview;
				};
			};
		}];

		A3PL_FactoryV2_CraftsEHAdded = true;
	};

	[28003] call A3PL_FactoryV2_ObjectPreview;

	private _npcObj = player getVariable ["A3PL_FactoryV2_NpcObj", objNull];
	[_ownerType, _ownerID, player, _npcObj] remoteExec ["Server_FactoryV2_GetAvailableCrafts", 2];
}] call compile_Global;

// Recevoir les crafts disponibles depuis le serveur
["A3PL_FactoryV2_ReceiveAvailableCrafts", {
	private _crafts = param [0, []];
	private _licenses = param [1, []];
	private _display = findDisplay 2500;

	diag_log format ["[FactoryV2 Client] ReceiveAvailableCrafts - Display: %1, Crafts count: %2, Licenses count: %3", _display, count _crafts, count _licenses];

	if (isNull _display) exitWith {
		diag_log "[FactoryV2 Client] ReceiveAvailableCrafts - Display is NULL, exiting";
	};

	private _myCraftsTree = _display displayCtrl 28002;
	diag_log format ["[FactoryV2 Client] ReceiveAvailableCrafts - myCraftsTree: %1", _myCraftsTree];
	tvClear _myCraftsTree;
	
	private _availableTree = _display displayCtrl 28004;
	tvClear _availableTree;
	
	private _ownedLicenseIndices = [];
	private _availableLicenseIndices = [];
	
	private _normalizeID = {
		private _val = _this;
		if (_val isEqualType "") then {
			_val
		} else {
			str _val
		};
	};
	
	{
		private _licenseID = (_x select 0) call _normalizeID;
		private _licenseName = _x select 1;
		private _hasLicense = _x select 3;
		
		if (_hasLicense) then {
			private _index = _myCraftsTree tvAdd [[], _licenseName];
			_myCraftsTree tvSetData [[_index], format ["license_%1", _licenseID]];
			_ownedLicenseIndices pushBack [_licenseID, _index];
		};
	} foreach _licenses;
	
	{
		private _craftID = _x select 0;
		private _craftName = _x select 1;
		private _classname = _x select 7;
		private _classType = _x select 8;
		private _hasCraft = _x select 3;
		private _licenseID = (_x select 4) call _normalizeID;
		private _isShared = if (count _x > 10) then {_x select 10} else {false};

		private _craftDisplayName = [_classname, _classType, "name"] call A3PL_FactoryV2_Inheritance;

		if (_isShared) then {
			_craftDisplayName = format ["%1 %2", _craftDisplayName, "STR_A3PL_FactoryV2_SharedTag" call A3PL_Localize];
		};

		if (_hasCraft) then {
			private _parentIndex = -1;
			{
				if ((_x select 0) isEqualTo _licenseID) exitWith {
					_parentIndex = _x select 1;
				};
			} foreach _ownedLicenseIndices;

			if (_parentIndex >= 0) then {
				private _index = _myCraftsTree tvAdd [[_parentIndex], _craftDisplayName];
				_myCraftsTree tvSetData [[_parentIndex, _index], format ["craft_%1", _craftID]];
			} else {
				private _index = _myCraftsTree tvAdd [[], _craftDisplayName];
				_myCraftsTree tvSetData [[_index], format ["craft_%1", _craftID]];
			};
		};
	} foreach _crafts;
	
	{
		private _licenseID = (_x select 0) call _normalizeID;
		private _licenseName = _x select 1;
		private _licensePrice = _x select 2;
		private _hasLicense = _x select 3;
		
		if (!_hasLicense) then {
			private _index = _availableTree tvAdd [[], _licenseName];
			_availableTree tvSetData [[_index], format ["license_%1", _licenseID]];
			
			_availableLicenseIndices pushBack [_licenseID, _index];
		};
	} foreach _licenses;
	
	{
		private _craftID = _x select 0;
		private _craftName = _x select 1;
		private _classname = _x select 7;
		private _classType = _x select 8;
		private _craftPrice = _x select 2;
		private _hasCraft = _x select 3;
		private _licenseID = (_x select 4) call _normalizeID;

		private _craftDisplayName = [_classname, _classType, "name"] call A3PL_FactoryV2_Inheritance;

		if (!_hasCraft) then {
			private _parentIndex = -1;
			{
				if ((_x select 0) isEqualTo _licenseID) exitWith {
					_parentIndex = _x select 1;
				};
			} foreach _availableLicenseIndices;
			
			if (_parentIndex >= 0) then {
				private _index = _availableTree tvAdd [[_parentIndex], _craftDisplayName];
				_availableTree tvSetData [[_parentIndex, _index], format ["craft_%1", _craftID]];
			} else {
				private _index = _availableTree tvAdd [[], _craftDisplayName];
				_availableTree tvSetData [[_index], format ["craft_%1", _craftID]];
			};
		};
	} foreach _crafts;

	_myCraftsTree ctrlCommit 0;
	_availableTree ctrlCommit 0;

	diag_log "[FactoryV2 Client] ReceiveAvailableCrafts - Trees rebuilt";
}] call compile_Global;

// Acheter un craft ou une licence
["A3PL_FactoryV2_BuyCraft", {
	if (!(call A3PL_Player_AntiSpam)) exitWith {};
	disableSerialization;
	private _display = findDisplay 2500;
	if (isNull _display) exitWith {};

	private _control = _display displayCtrl 28004;
	private _selectedPath = tvCurSel _control;
	if (count _selectedPath < 1) exitWith {
		[("STR_A3PL_FactoryV2_NoSelection" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};

	private _data = _control tvData _selectedPath;
	if (_data isEqualTo "") exitWith {};

	private _ownerType = player getVariable ["A3PL_FactoryV2_OwnerType", ""];
	private _ownerID = player getVariable ["A3PL_FactoryV2_OwnerID", ""];
	if (_ownerType isEqualTo "" || _ownerID isEqualTo "") exitWith {};

	// Vérifier si c'est une licence ou un craft
	private _npcObj = player getVariable ["A3PL_FactoryV2_NpcObj", objNull];
	if (_data find "license_" == 0) then {
		private _licenseID = parseNumber ((_data splitString "_") select 1);
		[_ownerType, _ownerID, _licenseID, true, player, _npcObj] remoteExec ["Server_FactoryV2_Buy", 2];
	} else {
		if (_data find "craft_" == 0) then {
			private _craftID = parseNumber ((_data splitString "_") select 1);
			[_ownerType, _ownerID, _craftID, false, player, _npcObj] remoteExec ["Server_FactoryV2_Buy", 2];
		};
	};
}] call compile_Global;

// Charger la page Storage
["A3PL_FactoryV2_LoadStorage", {
	disableSerialization;
	private _display = findDisplay 2500;
	if (isNull _display) exitWith {};

	private _ownerType = player getVariable ["A3PL_FactoryV2_OwnerType", ""];
	private _ownerID = player getVariable ["A3PL_FactoryV2_OwnerID", ""];
	if (_ownerType isEqualTo "" || _ownerID isEqualTo "") exitWith {};

	(_display displayCtrl 26003) ctrlSetText "1";
	(_display displayCtrl 26007) ctrlSetText "1";

	if (isNil "A3PL_FactoryV2_StorageEHAdded" || {!A3PL_FactoryV2_StorageEHAdded}) then {
		private _removeButton = _display displayCtrl 26004;
		_removeButton ctrlAddEventHandler ["ButtonClick", {["toInventory"] call A3PL_FactoryV2_TransferItem;}];
		
		private _addButton = _display displayCtrl 26008;
		_addButton ctrlAddEventHandler ["ButtonClick", {["toStorage"] call A3PL_FactoryV2_TransferItem;}];
		
		private _storageList = _display displayCtrl 26002;
		_storageList ctrlAddEventHandler ["LBSelChanged", {
			params ["_control", "_selectedIndex"];
			disableSerialization;
			private _display = findDisplay 2500;
			private _amountCtrl = _display displayCtrl 26003;

			if (_selectedIndex < 0) exitWith {
				_amountCtrl ctrlEnable true;
				_amountCtrl ctrlSetText "1";
			};
			private _itemID = _control lbData _selectedIndex;
			if (_itemID isEqualTo "") exitWith {
				_amountCtrl ctrlEnable true;
				_amountCtrl ctrlSetText "1";
			};

			private _classType = "item";
			private _realClass = _itemID;
			private _parts = _itemID splitString "_";
			if ((count _parts) > 0 && {(toLower (_parts#0)) isEqualTo "f"}) then {
				private _craftData = [_itemID] call A3PL_FactoryV2_GetCraftData;
				_realClass = _craftData#0;
				_classType = _craftData#1;
				[26005, _craftData#0, _craftData#1, _craftData#2] call A3PL_FactoryV2_ShowPreview;
			} else {
				[26005, _itemID, "item"] call A3PL_FactoryV2_ShowPreview;
			};

			private _disableAmount = false;
			if (_classType in ["vehicle", "car", "plane", "heli", "boat"]) then {
				_disableAmount = true;
			} else {
				if (_classType isEqualTo "item") then {
					private _canPickup = [_realClass, "canPickup"] call A3PL_Config_GetItem;
					if (!isNil "_canPickup" && {!_canPickup}) then {
						_disableAmount = true;
					};
				};
			};

			if (_disableAmount) then {
				_amountCtrl ctrlEnable false;
				_amountCtrl ctrlSetText "1";
			} else {
				_amountCtrl ctrlEnable true;
			};
		}];
		
		private _inventoryList = _display displayCtrl 26006;
		_inventoryList ctrlAddEventHandler ["LBSelChanged", {
			params ["_control", "_selectedIndex"];
			disableSerialization;
			private _display = findDisplay 2500;
			private _amountCtrl = _display displayCtrl 26007;

			if (_selectedIndex < 0) exitWith {
				_amountCtrl ctrlEnable true;
				_amountCtrl ctrlSetText "1";
			};
			private _itemID = _control lbData _selectedIndex;
			if (_itemID isEqualTo "") exitWith {
				_amountCtrl ctrlEnable true;
				_amountCtrl ctrlSetText "1";
			};

			if ((_itemID select [0, 4]) isEqualTo "OBJ|") then {
				_amountCtrl ctrlEnable false;
				_amountCtrl ctrlSetText "1";
			} else {
				_amountCtrl ctrlEnable true;
			};

			private _classType = "item";
			private _parts = _itemID splitString "_";
			if ((count _parts) > 0 && {(toLower (_parts#0)) isEqualTo "f"}) then {
				private _craftData = [_itemID] call A3PL_FactoryV2_GetCraftData;
				if (count _craftData >= 2) then {
					private _resolvedType = _craftData select 1;
					if (!isNil "_resolvedType" && {_resolvedType != ""}) then {_classType = _resolvedType;};
				};
			} else { _classType = "item"; };
			[26005, _itemID, _classType] call A3PL_FactoryV2_ShowPreview;
		}];
		
		A3PL_FactoryV2_StorageEHAdded = true;
	};
	
	[26005] call A3PL_FactoryV2_ObjectPreview;

	private _npcObj = player getVariable ["A3PL_FactoryV2_NpcObj", objNull];
	[_ownerType, _ownerID, player, _npcObj] remoteExec ["Server_FactoryV2_GetStorage", 2];

	[] call A3PL_FactoryV2_RefreshInventory;
}] call compile_Global;

// Recevoir le stockage depuis le serveur
["A3PL_FactoryV2_ReceiveStorage", {
	disableSerialization;
	private _storage = param [0, []];
	private _maxStorage = param [1, 1000];
	private _currentStorage = param [2, 0];
	private _display = findDisplay 2500;
	if (isNull _display) exitWith {};
	
	// Stocker le storage pour l'utiliser dans d'autres fonctions (affichage items requis)
	A3PL_FactoryV2_CurrentStorage = _storage;
	
	private _control = _display displayCtrl 26002; // Liste du stockage
	lbClear _control;	
	

	{
		private _itemID = _x select 0;
		private _amount = _x select 1;
		private _itemName = "";
		// Détection: si l'ID commence par f_xxx -> item crafté par l'usine (splitString check)
		private _lowerID = toLower _itemID;
		private _classType = "item";
		private _parts = _lowerID splitString "_";
		if ((count _parts) > 0 && {(toLower (_parts#0)) isEqualTo "f"}) then {
			private _craftData = [_itemID] call A3PL_FactoryV2_GetCraftData;
			if (count _craftData >= 2) then {
				private _resolvedClass = _craftData select 0;
				_classType = _craftData select 1;
				_itemName = [_resolvedClass, _classType, "name"] call A3PL_FactoryV2_Inheritance;
				if (_itemName isEqualTo "") then { _itemName = _itemID; };
			} else {
				_classType = "item";
			};
		} else {
			_classType = "item";
			_itemName = [_itemID, _classType, "name"] call A3PL_FactoryV2_Inheritance;
			if (_itemName isEqualTo "") then { _itemName = _itemID; };
		};

		private _index = _control lbAdd format ["%1 x%2", _itemName, _amount];
		_control lbSetData [_index, _itemID];
	} foreach _storage;
	
	// Rafraîchir l'inventaire
	[] call A3PL_FactoryV2_RefreshInventory;
}] call compile_Global;

// Rafraîchir l'inventaire dans la page Storage
["A3PL_FactoryV2_RefreshInventory", {
	disableSerialization;
	private _display = findDisplay 2500;
	if (isNull _display) exitWith {};
	
	private _control = _display displayCtrl 26006;
	lbClear _control;

	private _inventory = player getVariable ["player_inventory", []];
	private _lbArray = [];
	{
		private _itemID = _x select 0;
		private _amount = _x select 1;
		private _itemName = [_itemID, "item", "name"] call A3PL_FactoryV2_Inheritance;
		if (isNil "_itemName" || {_itemName isEqualTo ""}) then { _itemName = _itemID; };
		_lbArray pushBack [format ["%1 (%2x)", _itemName, _amount], _itemID];
	} foreach _inventory;

	_lbArray pushBack [format ["Cash (%1x)", (player getVariable ["player_cash", 0])], "cash"];

	private _near = player nearEntities [["Thing"], 20];
	private _toDelete = [];
	{
		if ((!isNil {_x getVariable ["ainv", nil]}) || (!isNil {_x getVariable ["finv", nil]}) || (isNil {_x getVariable ["class", nil]})) then {
			_toDelete pushBack _forEachIndex;
		};
	} forEach _near;
	{
		_near deleteAt (_toDelete select ((count _toDelete) - _forEachIndex - 1));
	} forEach _toDelete;
	{
		private _charID = player getVariable ["character_id", ""];
		private _owner = _x getVariable ["owner", nil];
		if (isNil "_owner") exitWith {};
		private _cid = [_charID] call A3PL_Config_GetCompanyID;
		private _objCid = _x getVariable ["cid", 0];
		if ((_charID isEqualTo _owner) || {_cid isEqualTo _objCid}) then {
			private _id = _x getVariable ["class", ""];
			private _amount = 1;
			private _itemName = [_id, "item", "name"] call A3PL_FactoryV2_Inheritance;
			if (isNil "_itemName" || {_itemName isEqualTo ""}) then { _itemName = _id; };
			private _netId = netId _x;
			_lbArray pushBack [format ["%1 (%2x)", _itemName, _amount], format ["OBJ|%1|%2", _id, _netId]];
		};
	} forEach _near;

	{
		private _i = _control lbAdd (_x select 0);
		_control lbSetData [_i, (_x select 1)];
	} forEach _lbArray;
}] call compile_Global;

// Transférer un item (vers stockage ou vers inventaire)
// Paramètre: "toStorage" ou "toInventory"
["A3PL_FactoryV2_TransferItem", {
	if (!(call A3PL_Player_AntiSpam)) exitWith {};
	params [["_direction", "toStorage"]];

	disableSerialization;
	private _display = findDisplay 2500;
	if (isNull _display) exitWith {};

	private _sourceControl = _display displayCtrl 26002;
	private _amountControl = _display displayCtrl 26003;
	private _serverFunction = "Server_FactoryV2_AddToInventory";

	if (_direction isEqualTo "toStorage") then {
		_sourceControl = _display displayCtrl 26006;
		_amountControl = _display displayCtrl 26007;
		_serverFunction = "Server_FactoryV2_AddToStorage";
	};

	private _sel = lbCurSel _sourceControl;
	if (_sel < 0) exitWith {
		[("STR_A3PL_FactoryV2_NoSelection" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};

	private _itemID = _sourceControl lbData _sel;
	if (isNil "_itemID" || {_itemID isEqualTo ""}) exitWith {
		[("STR_A3PL_FactoryV2_NoSelection" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};

	private _amountText = ctrlText _amountControl;
	private _amount = floor(parseNumber _amountText);
	if (_amount < 1) then {_amount = 1;};

	private _ownerType = player getVariable ["A3PL_FactoryV2_OwnerType", ""];
	private _ownerID = player getVariable ["A3PL_FactoryV2_OwnerID", ""];
	if (_ownerType isEqualTo "" || _ownerID isEqualTo "") exitWith {};

	private _netId = "";
	private _realItemID = _itemID;
	if ((_itemID select [0, 4]) isEqualTo "OBJ|") then {
		private _parts = _itemID splitString "|";
		if (count _parts >= 3) then {
			_realItemID = _parts select 1;
			_netId = _parts select 2;
			private _obj = objectFromNetId _netId;
			if (isNull _obj) exitWith {
				[("STR_A3PL_FactoryV2_ObjectNotFound" call A3PL_Localize), Color_Red] call A3PL_Notification;
				_netId = "";
			};
		};
	};

	private _npcObj = player getVariable ["A3PL_FactoryV2_NpcObj", objNull];
	if (_netId isEqualTo "") then {
		[_ownerType, _ownerID, [_realItemID, _amount], player, true, objNull, _npcObj] remoteExec [_serverFunction, 2];
	} else {
		[_ownerType, _ownerID, [_realItemID, _amount], player, true, _netId, _npcObj] remoteExec [_serverFunction, 2];
	};
}] call compile_Global;

// Charger la page Upgrades
["A3PL_FactoryV2_LoadUpgrades", {
	disableSerialization;
	private _display = findDisplay 2500;
	if (isNull _display) exitWith {};

	private _ownerType = player getVariable ["A3PL_FactoryV2_OwnerType", ""];
	private _ownerID = player getVariable ["A3PL_FactoryV2_OwnerID", ""];
	private _isCivilian = player getVariable ["A3PL_FactoryV2_IsCivilian", false];
	if (_ownerType isEqualTo "" || _ownerID isEqualTo "") exitWith {};

	if (isNil "A3PL_FactoryV2_UpgradesEHAdded" || {!A3PL_FactoryV2_UpgradesEHAdded}) then {
		private _buyUpgradeButton = _display displayCtrl 27007;
		_buyUpgradeButton ctrlAddEventHandler ["ButtonClick", {[] call A3PL_FactoryV2_BuyUpgrade;}];

		private _buySlotButton = _display displayCtrl 27025;
		_buySlotButton ctrlAddEventHandler ["ButtonClick", {[] call A3PL_FactoryV2_BuySlot;}];

		private _availableTree = _display displayCtrl 27004;
		_availableTree ctrlAddEventHandler ["TreeSelChanged", {
		params ["_control", "_selectedPath"];
		if (count _selectedPath < 1) exitWith {};

		private _display = findDisplay 2500;
		private _upgradeID = _control tvData _selectedPath;
		if (_upgradeID isEqualTo "") exitWith {};

		diag_log format ["[FactoryV2] TreeSelChanged - UpgradeID from tvData: '%1' (type: %2)", _upgradeID, typeName _upgradeID];

		private _upgradeData = Config_FactoryV2_Upgrades getOrDefault [_upgradeID, []];
		diag_log format ["[FactoryV2] TreeSelChanged - Upgrade data from HashMap: %1 (count: %2)", _upgradeData, count _upgradeData];
		if (count _upgradeData > 0) then {
			private _upgradeName = _upgradeData select 0;
			private _upgradePrice = _upgradeData select 1;
			private _upgradeType = _upgradeData select 2;
			private _upgradeValue = _upgradeData select 3;

			private _typeStr = switch (_upgradeType) do {
				case "speed": {("STR_A3PL_FactoryV2_UpgradeType_Speed" call A3PL_Localize)};
				case "efficiency": {("STR_A3PL_FactoryV2_UpgradeType_Efficiency" call A3PL_Localize)};
				case "storage": {("STR_A3PL_FactoryV2_UpgradeType_Storage" call A3PL_Localize)};
				default {_upgradeType};
			};

			private _descText = format ["<t size='1'>%1</t><br/><br/><t size='0.9'>Type: %2<br/>Bonus: +%3</t>", _upgradeName, _typeStr, _upgradeValue];
			private _descCtrl = _display displayCtrl 27005;
			_descCtrl ctrlSetStructuredText parseText _descText;

			// Déterminer le solde disponible selon le type de propriétaire
			private _isCivilian = player getVariable ["A3PL_FactoryV2_IsCivilian", false];
			private _availableFunds = 0;
			if (_isCivilian) then {
				_availableFunds = player getVariable ["player_bank", 0];
			} else {
				private _cid = player getVariable ["A3PL_FactoryV2_CID", 0];
				_availableFunds = [_cid, "bank"] call A3PL_Config_GetCompanyData;
				if (isNil "_availableFunds") then {_availableFunds = 0;};
			};
			private _color = if (_availableFunds >= _upgradePrice) then {"#00FF00"} else {"#FF0000"};

			private _priceCtrl = _display displayCtrl 27006;
			_priceCtrl ctrlSetStructuredText parseText format ["<t align='center' color='%1'>$%2</t>", _color, [_upgradePrice, 1, 0, true] call CBA_fnc_formatNumber];
		};
	}];

		A3PL_FactoryV2_UpgradesEHAdded = true;
	};

	[_ownerType, _ownerID, player] remoteExec ["Server_FactoryV2_GetUpgrades", 2];
}] call compile_Global;

// Recevoir les upgrades depuis le serveur
["A3PL_FactoryV2_ReceiveUpgrades", {
	disableSerialization;
	private _upgrades = param [0, []];
	private _factoryStats = param [1, []];
	private _display = findDisplay 2500;
	if (isNull _display) exitWith {};

	diag_log format ["[FactoryV2] Client received upgrades - Count: %1, Upgrades: %2", count _upgrades, _upgrades];
	diag_log format ["[FactoryV2] Client received factoryStats - Type: %1, Value: %2", typeName _factoryStats, _factoryStats];

	private _statsText = _display displayCtrl 27003;
	private _slots = _factoryStats select 0;
	private _speed = _factoryStats select 1;
	private _efficiency = _factoryStats select 2;
	private _maxStorage = _factoryStats select 3;

	private _statsFormatted = format [
		("STR_A3PL_FactoryV2_CurrentStats" call A3PL_Localize),
		_slots,
		_speed,
		_efficiency,
		_maxStorage
	];
	_statsText ctrlSetStructuredText parseText format ["<t size='0.8'>%1</t>", _statsFormatted];

	private _myUpgradesTree = _display displayCtrl 27002;
	tvClear _myUpgradesTree;

	private _availableTree = _display displayCtrl 27004;
	tvClear _availableTree;

	{
		private _upgradeID = _x select 0;
		private _upgradeName = _x select 1;
		private _upgradePrice = _x select 2;
		private _upgradeType = _x select 3;
		private _upgradeValue = _x select 4;
		private _hasUpgrade = _x select 5;

		if (_hasUpgrade) then {
			private _index = _myUpgradesTree tvAdd [[], _upgradeName];
			_myUpgradesTree tvSetData [[_index], _upgradeID];
		} else {
			private _index = _availableTree tvAdd [[], _upgradeName];
			_availableTree tvSetData [[_index], _upgradeID];
		};
	} foreach _upgrades;
	
	private _slotControls = [
		[27008, 27009], 
		[27010, 27011], 
		[27012, 27013], 
		[27014, 27015], 
		[27016, 27017], 
		[27018, 27019], 
		[27020, 27021], 
		[27022, 27023]
	];
	
	for "_i" from 0 to 7 do {
		private _slot = _slotControls select _i;
		private _nameCtrl = _display displayCtrl (_slot select 0);
		private _statusCtrl = _display displayCtrl (_slot select 1);
		
		_nameCtrl ctrlShow true;
		_statusCtrl ctrlShow true;
		
		_nameCtrl ctrlSetStructuredText parseText format ["<t size='0.9'>Slot %1</t>", _i + 1];
		
		if (_i < _slots) then {
			_statusCtrl ctrlSetStructuredText parseText format ["<t size='0.85' color='#00FF00'>%1</t>", ("STR_A3PL_FactoryV2_SlotPurchased" call A3PL_Localize)];
		} else {
			_statusCtrl ctrlSetStructuredText parseText format ["<t size='0.85' color='#FF6600'>%1</t>", ("STR_A3PL_FactoryV2_SlotNotPurchased" call A3PL_Localize)];
		};
	};
	
	private _slotPriceCtrl = _display displayCtrl 27024;
	private _slotPrice = 50000;
	if (_slots >= 8) then {
		_slotPriceCtrl ctrlSetStructuredText parseText format ["<t size='0.9' color='#888888'>%1</t>", ("STR_A3PL_FactoryV2_MaxSlotsReached" call A3PL_Localize)];
	} else {
		// Déterminer le solde disponible selon le type de propriétaire
		private _isCivilian = player getVariable ["A3PL_FactoryV2_IsCivilian", false];
		private _availableFunds = 0;
		if (_isCivilian) then {
			_availableFunds = player getVariable ["player_bank", 0];
		} else {
			private _cid = player getVariable ["A3PL_FactoryV2_CID", 0];
			_availableFunds = [_cid, "bank"] call A3PL_Config_GetCompanyData;
			if (isNil "_availableFunds") then {_availableFunds = 0;};
		};
		private _slotColor = if (_availableFunds >= _slotPrice) then {"#00FF00"} else {"#FF0000"};
		_slotPriceCtrl ctrlSetStructuredText parseText format ["<t size='0.9' color='%1'>$%2</t>", _slotColor, [_slotPrice] call CBA_fnc_formatNumber];
	};
}] call compile_Global;

// Acheter un upgrade
["A3PL_FactoryV2_BuyUpgrade", {
	if (!(call A3PL_Player_AntiSpam)) exitWith {};
	disableSerialization;
	diag_log "[FactoryV2] A3PL_FactoryV2_BuyUpgrade called";

	private _display = findDisplay 2500;
	if (isNull _display) exitWith {
		diag_log "[FactoryV2] Display is null, exiting";
	};

	private _control = _display displayCtrl 27004;
	private _selectedPath = tvCurSel _control;
	diag_log format ["[FactoryV2] Selected path: %1", _selectedPath];

	if (count _selectedPath < 1) exitWith {
		diag_log "[FactoryV2] No selection, showing notification";
		[("STR_A3PL_FactoryV2_NoSelection" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};

	private _upgradeID = _control tvData _selectedPath;
	diag_log _upgradeID;
	diag_log format ["[FactoryV2] Upgrade ID String: %1", _upgradeID];

	private _ownerType = player getVariable ["A3PL_FactoryV2_OwnerType", ""];
	private _ownerID = player getVariable ["A3PL_FactoryV2_OwnerID", ""];
	if (_ownerType isEqualTo "" || _ownerID isEqualTo "") exitWith {};

	diag_log format ["[FactoryV2] Upgrade ID (final): %1, OwnerType: %2, OwnerID: %3", _upgradeID, _ownerType, _ownerID];

	[_ownerType, _ownerID, _upgradeID, player] remoteExec ["Server_FactoryV2_BuyUpgrade", 2];
	diag_log "[FactoryV2] remoteExec sent to server";
}] call compile_Global;

// Acheter un slot
["A3PL_FactoryV2_BuySlot", {
	if (!(call A3PL_Player_AntiSpam)) exitWith {};
	disableSerialization;
	private _ownerType = player getVariable ["A3PL_FactoryV2_OwnerType", ""];
	private _ownerID = player getVariable ["A3PL_FactoryV2_OwnerID", ""];
	if (_ownerType isEqualTo "" || _ownerID isEqualTo "") exitWith {};

	[_ownerType, _ownerID, player] remoteExec ["Server_FactoryV2_BuySlot", 2];
}] call compile_Global;

// Charger la page Share
["A3PL_FactoryV2_LoadShare", {
	disableSerialization;
	private _display = findDisplay 2500;
	if (isNull _display) exitWith {};

	private _ownerType = player getVariable ["A3PL_FactoryV2_OwnerType", ""];
	private _ownerID = player getVariable ["A3PL_FactoryV2_OwnerID", ""];
	if (_ownerType isEqualTo "" || _ownerID isEqualTo "") exitWith {};
	
	if (isNil "A3PL_FactoryV2_ShareEHAdded" || {!A3PL_FactoryV2_ShareEHAdded}) then {
		private _shareButton = _display displayCtrl 29006;
		_shareButton ctrlAddEventHandler ["ButtonClick", {[] call A3PL_FactoryV2_ShareCraft;}];
		
		private _removeButton = _display displayCtrl 29007;
		_removeButton ctrlAddEventHandler ["ButtonClick", {[] call A3PL_FactoryV2_RemoveShare;}];
		
		private _setSubscriptionButton = _display displayCtrl 29008;
		_setSubscriptionButton ctrlAddEventHandler ["ButtonClick", {[true] call A3PL_FactoryV2_SetSharePrice;}];
		
		private _setCraftPriceButton = _display displayCtrl 29009;
		_setCraftPriceButton ctrlAddEventHandler ["ButtonClick", {[false] call A3PL_FactoryV2_SetSharePrice;}];
		
		private _setPriceButton = _display displayCtrl 29011;
		_setPriceButton ctrlAddEventHandler ["ButtonClick", {[] call A3PL_FactoryV2_SetPrice;}];
		
		private _searchEdit = _display displayCtrl 29005;
		_searchEdit ctrlAddEventHandler ["KeyUp", {[] call A3PL_FactoryV2_SearchShareTarget;}];

		// EH pour récupérer les infos d'un partage existant quand on sélectionne une personne dans Share_SharedPerson (29004)
		private _sharedPersonList = _display displayCtrl 29004;
		_sharedPersonList ctrlAddEventHandler ["LBSelChanged", {
			params ["_control", "_selectedIndex"];
			if (_selectedIndex < 0) exitWith {};

			disableSerialization;
			private _display = findDisplay 2500;

			// Récupérer les données du partage sélectionné (format: shareID_targetType_targetID)
			private _shareData = _control lbData _selectedIndex;
			private _parts = _shareData splitString "_";
			if (count _parts < 3) exitWith {};

			private _targetType = _parts select 1;
			private _targetID = _parts select 2;

			// Récupérer le craft sélectionné
			private _shareTree = _display displayCtrl 29002;
			private _selectedPath = tvCurSel _shareTree;
			if (count _selectedPath < 1) exitWith {};
			private _craftData = _shareTree tvData _selectedPath;
			if (_craftData isEqualTo "" || {(_craftData find "license_") == 0}) exitWith {};
			private _craftID = parseNumber _craftData;

			private _ownerType = player getVariable ["A3PL_FactoryV2_OwnerType", ""];
			private _ownerID = player getVariable ["A3PL_FactoryV2_OwnerID", ""];

			// Demander au serveur les infos du partage existant
			[_ownerType, _ownerID, _craftID, _targetType, _targetID, player] remoteExec ["Server_FactoryV2_GetShareInfo", 2];
		}];

		private _shareTree = _display displayCtrl 29002;
		_shareTree ctrlAddEventHandler ["TreeSelChanged", {
			params ["_control", "_selectedPath"];
			disableSerialization;
			private _display = findDisplay 2500;

			private _sharedPersonCtrl = _display displayCtrl 29004;
			lbClear _sharedPersonCtrl;

			if (count _selectedPath < 1) exitWith {};
			private _data = _control tvData _selectedPath;
			if (_data isEqualTo "" || {(_data find "license_") == 0}) exitWith {};

			private _craftID = call compile _data;
			private _craftData = [_craftID] call A3PL_FactoryV2_GetCraftData;
			if (count _craftData >= 3) then {
				[29003, _craftData#0, _craftData#1, _craftData#2] call A3PL_FactoryV2_ShowPreview;
			};

			private _ownerType = player getVariable ["A3PL_FactoryV2_OwnerType", ""];
			private _ownerID = player getVariable ["A3PL_FactoryV2_OwnerID", ""];
			[_ownerType, _ownerID, _craftID, player] remoteExec ["Server_FactoryV2_GetCraftShares", 2];
		}];

		A3PL_FactoryV2_ShareEHAdded = true;
	};
	
	[29003] call A3PL_FactoryV2_ObjectPreview;

	A3PL_FactoryV2_LoadingForShare = true;
	private _npcObj = player getVariable ["A3PL_FactoryV2_NpcObj", objNull];
	[_ownerType, _ownerID, player, _npcObj] remoteExec ["Server_FactoryV2_GetOwnedCraftsForFactory", 2];
}] call compile_Global;

// Recevoir les crafts partageables depuis le serveur (appelé depuis ReceiveOwnedCraftsForFactory si LoadingForShare = true)
["A3PL_FactoryV2_ReceiveShareableCrafts", {
	disableSerialization;
	private _crafts = param [0, []];
	private _licenses = param [1, []];
	private _display = findDisplay 2500;
	if (isNull _display) exitWith {};

	A3PL_FactoryV2_ShareableCrafts = _crafts;

	private _shareTree = _display displayCtrl 29002;
	tvClear _shareTree;

	private _licenseIndices = [];

	private _normalizeID = {
		private _val = _this;
		if (_val isEqualType "") then {_val} else {str _val};
	};

	{
		private _licenseID = (_x select 0) call _normalizeID;
		private _licenseName = _x select 1;
		private _hasLicense = _x select 2;

		if (_hasLicense) then {
			private _index = _shareTree tvAdd [[], _licenseName];
			_shareTree tvSetData [[_index], format ["license_%1", _licenseID]];
			_licenseIndices pushBack [_licenseID, _index];
		};
	} foreach _licenses;

	{
		private _craftID = _x select 0;
		private _craftClass = _x select 4;
		private _craftType = _x select 5;
		private _hasCraft = _x select 2;
		private _licenseID = (_x select 3) call _normalizeID;
		private _isShared = if (count _x > 10) then {_x select 10} else {false};

		if (_isShared) then {continue;};

		private _craftDisplayName = [_craftClass, _craftType, "name"] call A3PL_FactoryV2_Inheritance;
		if (isNil "_craftDisplayName" || {_craftDisplayName isEqualTo ""}) then {_craftDisplayName = _craftClass;};

		if (_hasCraft) then {
			private _parentIndex = -1;
			{
				if ((_x select 0) isEqualTo _licenseID) exitWith {
					_parentIndex = _x select 1;
				};
			} foreach _licenseIndices;

			if (_parentIndex >= 0) then {
				private _index = _shareTree tvAdd [[_parentIndex], _craftDisplayName];
				_shareTree tvSetData [[_parentIndex, _index], _craftID];
			} else {
				private _index = _shareTree tvAdd [[], _craftDisplayName];
				_shareTree tvSetData [[_index], _craftID];
			};
		};
	} foreach _crafts;
}] call compile_Global;

// Rechercher une cible pour le partage
["A3PL_FactoryV2_SearchShareTarget", {
	disableSerialization;
	private _display = findDisplay 2500;
	if (isNull _display) exitWith {};

	private _searchText = ctrlText (_display displayCtrl 29005);
	if (_searchText isEqualTo "") exitWith {};

	private _ownerType = player getVariable ["A3PL_FactoryV2_OwnerType", ""];
	private _ownerID = player getVariable ["A3PL_FactoryV2_OwnerID", ""];
	[_ownerType, _ownerID, _searchText, player] remoteExec ["Server_FactoryV2_SearchShareTarget", 2];
}] call compile_Global;

// Recevoir les résultats de recherche (affichés dans 29012 - Share_ResearchList)
["A3PL_FactoryV2_ReceiveSearchResults", {
	disableSerialization;
	private _results = param [0, []];
	private _display = findDisplay 2500;
	if (isNull _display) exitWith {};

	private _control = _display displayCtrl 29012;
	lbClear _control;

	{
		private _type = _x select 0; // "player" ou "company"
		private _name = _x select 1;
		private _id = _x select 2;

		private _typeLabel = if (_type isEqualTo "player") then {"STR_A3PL_FactoryV2_TypePlayer" call A3PL_Localize} else {"STR_A3PL_FactoryV2_TypeCompany" call A3PL_Localize};
		private _index = _control lbAdd format ["[%1] %2", _typeLabel, _name];
		_control lbSetData [_index, format ["%1_%2", _type, _id]];
	} foreach _results;
}] call compile_Global;

// Recevoir les partages existants pour un craft (affichés dans 29004 - Share_SharedPerson)
["A3PL_FactoryV2_ReceiveCraftShares", {
	disableSerialization;
	private _shares = param [0, []];
	private _display = findDisplay 2500;
	if (isNull _display) exitWith {};

	private _control = _display displayCtrl 29004;
	lbClear _control;

	{
		private _shareID = _x select 0;
		private _targetType = _x select 1; // "player" ou "company"
		private _targetName = _x select 2;
		private _targetID = _x select 3;
		private _shareType = _x select 4; // "subscription" ou "craft"
		private _price = _x select 5;
		private _status = if (count _x > 6) then {_x select 6} else {"active"};

		private _typeLabel = if (_targetType isEqualTo "player") then {"STR_A3PL_FactoryV2_TypePlayerShort" call A3PL_Localize} else {"STR_A3PL_FactoryV2_TypeCompanyShort" call A3PL_Localize};
		private _shareLabel = if (_shareType isEqualTo "subscription") then {"STR_A3PL_FactoryV2_ShareTypeSubscription" call A3PL_Localize} else {"STR_A3PL_FactoryV2_ShareTypeCraft" call A3PL_Localize};
		private _statusLabel = if (_status isEqualTo "pending") then {format [" %1", "STR_A3PL_FactoryV2_StatusPending" call A3PL_Localize]} else {""};
		private _index = _control lbAdd format ["[%1] %2 - %3 $%4%5", _typeLabel, _targetName, _shareLabel, _price, _statusLabel];
		_control lbSetData [_index, format ["%1_%2_%3", _shareID, _targetType, _targetID]];
	} foreach _shares;
}] call compile_Global;

// Recevoir les infos d'un partage existant et pré-remplir les champs
["A3PL_FactoryV2_ReceiveShareInfo", {
	disableSerialization;
	params [["_exists", false], ["_shareType", ""], ["_price", 0]];

	private _display = findDisplay 2500;
	if (isNull _display) exitWith {};

	private _priceEdit = _display displayCtrl 29010;

	if (_exists) then {
		A3PL_FactoryV2_ShareType = _shareType;
		A3PL_FactoryV2_SharePrice = _price;
		_priceEdit ctrlSetText str _price;
	} else {
		_priceEdit ctrlSetText "";
	};
}] call compile_Global;

// Définir le prix de partage
["A3PL_FactoryV2_SetSharePrice", {
	disableSerialization;
	private _isSubscription = param [0, false];
	
	A3PL_FactoryV2_ShareType = if (_isSubscription) then {"subscription"} else {"craft"};
	
	[format[("STR_A3PL_FactoryV2_PriceTypeSet" call A3PL_Localize), localize(if (_isSubscription) then {"STR_A3PL_FactoryV2_Subscription"} else {"STR_A3PL_FactoryV2_CraftPrice"})], Color_Green] call A3PL_Notification;
}] call compile_Global;

// Définir le prix
["A3PL_FactoryV2_SetPrice", {
	disableSerialization;
	private _display = findDisplay 2500;
	if (isNull _display) exitWith {};
	
	if (isNil "A3PL_FactoryV2_ShareType") exitWith {
		[("STR_A3PL_FactoryV2_NoPriceType" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	
	private _priceText = ctrlText (_display displayCtrl 29010);
	private _price = parseNumber _priceText;
	
	if (_price <= 0) exitWith {
		[("STR_A3PL_FactoryV2_InvalidPrice" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	
	A3PL_FactoryV2_SharePrice = _price;
	[("STR_A3PL_FactoryV2_PriceSet" call A3PL_Localize), Color_Green] call A3PL_Notification;
}] call compile_Global;

// Partager un craft
["A3PL_FactoryV2_ShareCraft", {
	if (!(call A3PL_Player_AntiSpam)) exitWith {};
	disableSerialization;
	private _display = findDisplay 2500;
	if (isNull _display) exitWith {};

	private _craftControl = _display displayCtrl 29002;
	private _selectedPath = tvCurSel _craftControl;
	if (count _selectedPath < 1) exitWith {
		[("STR_A3PL_FactoryV2_NoCraftSelected" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};

	private _craftData = _craftControl tvData _selectedPath;
	if (_craftData isEqualTo "" || {(_craftData find "license_") == 0}) exitWith {
		[("STR_A3PL_FactoryV2_NoCraftSelected" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};

	private _targetControl = _display displayCtrl 29012;
	if (lbCurSel _targetControl < 0) exitWith {
		[("STR_A3PL_FactoryV2_NoTargetSelected" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};

	if (isNil "A3PL_FactoryV2_ShareType" || isNil "A3PL_FactoryV2_SharePrice") exitWith {
		[("STR_A3PL_FactoryV2_NoPriceSet" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};

	private _craftID = parseNumber _craftData;
	private _targetData = _targetControl lbData (lbCurSel _targetControl);
	private _targetType = (_targetData splitString "_") select 0;
	private _targetID = (_targetData splitString "_") select 1;

	private _ownerType = player getVariable ["A3PL_FactoryV2_OwnerType", ""];
	private _ownerID = player getVariable ["A3PL_FactoryV2_OwnerID", ""];
	[_ownerType, _ownerID, _craftID, _targetType, _targetID, A3PL_FactoryV2_ShareType, A3PL_FactoryV2_SharePrice, player] remoteExec ["Server_FactoryV2_ShareCraft", 2];
}] call compile_Global;

// Retirer un partage
["A3PL_FactoryV2_RemoveShare", {
	if (!(call A3PL_Player_AntiSpam)) exitWith {};
	disableSerialization;
	private _display = findDisplay 2500;
	if (isNull _display) exitWith {};

	private _sharedPersonCtrl = _display displayCtrl 29004;
	if (lbCurSel _sharedPersonCtrl < 0) exitWith {
		[("STR_A3PL_FactoryV2_NoTargetSelected" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};

	private _shareData = _sharedPersonCtrl lbData (lbCurSel _sharedPersonCtrl);
	private _parts = _shareData splitString "_";
	if (count _parts < 3) exitWith {
		[("STR_A3PL_FactoryV2_Error" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};

	private _shareID = parseNumber (_parts select 0);

	private _ownerType = player getVariable ["A3PL_FactoryV2_OwnerType", ""];
	private _ownerID = player getVariable ["A3PL_FactoryV2_OwnerID", ""];

	private _craftControl = _display displayCtrl 29002;
	private _selectedPath = tvCurSel _craftControl;
	private _craftID = 0;
	if (count _selectedPath >= 1) then {
		private _craftData = _craftControl tvData _selectedPath;
		if (!(_craftData isEqualTo "") && {(_craftData find "license_") != 0}) then {
			_craftID = parseNumber _craftData;
		};
	};

	[_ownerType, _ownerID, _shareID, _craftID, player] remoteExec ["Server_FactoryV2_RemoveShare", 2];
}] call compile_Global;

// Rafraîchir les données
["A3PL_FactoryV2_RefreshData", {
	disableSerialization;
	private _display = findDisplay 2500;
	if (isNull _display) exitWith {};

	// Récupérer les paramètres depuis les variables du joueur (source de vérité)
	private _ownerType = player getVariable ["A3PL_FactoryV2_OwnerType", ""];
	private _ownerID = player getVariable ["A3PL_FactoryV2_OwnerID", ""];
	if (_ownerType isEqualTo "" || _ownerID isEqualTo "") exitWith {};

	// Déterminer la page actuelle en vérifiant quel background est visible
	private _currentPage = 0;
	private _backgrounds = [250000, 28000, 26000, 27000, 29000];
	{
		if (ctrlShown (_display displayCtrl _x)) then {
			_currentPage = _forEachIndex;
		};
	} foreach _backgrounds;

	// Ne rafraîchir que les pages qui ont des données dynamiques
	// Les modifications envoient directement les données mises à jour, donc pas besoin de refresh auto pour Storage
	switch (_currentPage) do {
		case 0: {[_ownerType, _ownerID, player] remoteExec ["Server_FactoryV2_GetActiveCrafts", 2];}; // Active crafts - besoin de refresh pour la progression
		case 1: {}; // Crafts - liste statique, pas de refresh (évite de replier les arbres)
		case 2: {}; // Storage - les modifications envoient directement les données, pas de refresh auto (évite le flip-flop)
		case 3: {}; // Upgrades - liste statique, pas de refresh
		case 4: {}; // Share - pas de refresh auto nécessaire
	};
}] call compile_Global;

// Recevoir une demande de partage de craft
["A3PL_FactoryV2_ReceiveShareRequest", {
	params [["_shareID", 0], ["_ownerName", ""], ["_craftID", 0], ["_shareType", "craft"], ["_price", 0]];

	if (_shareID isEqualTo 0) exitWith {};

	private _craftData = [_craftID] call A3PL_FactoryV2_GetCraftData;
	private _craftName = format ["Craft #%1", _craftID];
	if (count _craftData >= 2) then {
		private _classname = _craftData select 0;
		private _classType = _craftData select 1;
		private _displayName = [_classname, _classType, "name"] call A3PL_FactoryV2_Inheritance;
		if (!isNil "_displayName" && {_displayName != ""}) then {
			_craftName = _displayName;
		};
	};

	private _typeText = if (_shareType isEqualTo "subscription") then {
		format [("STR_A3PL_FactoryV2_ShareRequestSubscription" call A3PL_Localize), _price]
	} else {
		format [("STR_A3PL_FactoryV2_ShareRequestCraft" call A3PL_Localize), _price]
	};

	private _message = format [("STR_A3PL_FactoryV2_ShareRequestMessage" call A3PL_Localize), _ownerName, _craftName, _typeText];

	private _accepted = [_message] call A3PL_Lib_ConfirmationDialog;

	[_shareID, _accepted, player] remoteExec ["Server_FactoryV2_RespondToShare", 2];
}] call compile_Global;

// Lancer un craft
["A3PL_FactoryV2_StartCraft", {
	if (!(call A3PL_Player_AntiSpam)) exitWith {};
	disableSerialization;
	private _craftID = param [0, 0];
	private _amount = param [1, 1];

	if (_amount < 1) exitWith {
		[("STR_Common_InvalidAmount" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};

	private _ownerType = player getVariable ["A3PL_FactoryV2_OwnerType", ""];
	private _ownerID = player getVariable ["A3PL_FactoryV2_OwnerID", ""];
	if (_ownerType isEqualTo "" || _ownerID isEqualTo "") exitWith {};

	[_ownerType, _ownerID, _craftID, _amount, player] remoteExec ["Server_FactoryV2_StartCraft", 2];
}] call compile_Global;
