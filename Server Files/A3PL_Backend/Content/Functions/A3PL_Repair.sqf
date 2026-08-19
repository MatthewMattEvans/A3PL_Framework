/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/

/*
	REPAIR SYSTEM
*/

["A3PL_Repair_GetColorFromPercentage", {
	params [
		["_percent", 0, [0]]
	];

	private _color = [1, 0, 0, 1]; // Red
	private _colorHex = "#CB2323";

	if (_percent >= 75) then {
		_color = [0, 1, 0, 1]; // Green
		_colorHex = "#0A8B0A";
	} else {
		if (_percent >= 50) then {
			_color = [1, 0.65, 0, 1]; // Orange
			_colorHex = "#FFA500";
		} else {
			if (_percent >= 25) then {
				_color = [1, 1, 0, 1]; // Yellow
				_colorHex = "#FFFF00";
			};
		};
	};

	[_color, _colorHex];
}] call compile_Global;

["A3PL_Repair_GetHitPointsDamagesAverage", {
	params [
		["_target", objNull, [objNull]]
	];

	if (isNull _target) exitWith {1};

	private _hitPoints = getAllHitPointsDamage _target;
	if (_hitPoints isEqualTo []) exitWith {0};

	private _damages = _hitPoints#2;
	if (_damages isEqualTo []) exitWith {0};

	private _sum = 0;
	{_sum = _sum + _x} forEach _damages;

	_sum / (count _damages);
}] call compile_Global;

/*
	Fonction pour appliquer les dégâts sur le propriétaire local du véhicule
	Appelée via remoteExec sur le propriétaire du véhicule
*/
["A3PL_Repair_ApplyDamage", {
	params [
		["_vehicle", objNull, [objNull]],
		["_hitPoint", "", [""]],
		["_damage", 0, [0]]
	];

	if (isNull _vehicle) exitWith {};
	if (_hitPoint isEqualTo "") exitWith {};

	_vehicle setHitPointDamage [_hitPoint, _damage];
}] call compile_Global;

/*
	Fonction utilitaire pour vérifier si le joueur est dans un atelier
*/
["A3PL_Repair_IsInWorkshop", {
	private _nearBuildings = nearestObjects [player, ["Land_A3PL_Garage"], 25];
	(count _nearBuildings) > 0;
}] call compile_Global;

/*
	Fonction utilitaire pour calculer le niveau de réparation selon les traits et la situation
	Retourne: [repairPercent, repairMethod, canRepair, reason]
	repairMethod: "none", "macgyver", "basic", "tinkerer", "mechanic", "company"
*/
["A3PL_Repair_GetRepairLevel", {
	params [
		["_item", "", [""]],
		["_workshopOnly", false, [false]]
	];

	private _traits = player getVariable ["Player_Traits", []];
	private _hasMacGyver = "macgyver" in _traits;
	private _hasGreaseMonkey = "grease_monkey" in _traits;
	private _hasTinkerer = "tinkerer" in _traits;
	private _hasMechanic = "mechanic" in _traits;
	private _isInWorkshop = [] call A3PL_Repair_IsInWorkshop;
	private _hasItem = if (_item isEqualTo "") then {false} else {[_item] call A3PL_Inventory_Has};

	// Vérifier si le joueur a le job Company (c'est un JOB, pas un trait)
	private _playerJob = player getVariable ["job", ""];
	private _isCompanyJob = _playerJob isEqualTo ("STR_Common_Company" call A3PL_Localize);

	// Si pièce nécessite atelier et joueur pas dans atelier
	if (_workshopOnly && !_isInWorkshop && _hasItem) exitWith {
		[0, "none", false, "STR_A3PL_Repair_Error_NeedWorkshop"]
	};

	// Si pièce nécessite atelier, vérifier job Company OU compétence mechanic/tinkerer
	if (_workshopOnly && _isInWorkshop && _hasItem && !_isCompanyJob && !_hasMechanic && !_hasTinkerer) exitWith {
		[0, "none", false, "STR_A3PL_Repair_Error_NeedCompanyOrSkill"]
	};

	// Réparation avec pièce
	if (_hasItem) exitWith {
		// Mechanic: 100% avec pièce
		if (_hasMechanic) exitWith {
			[100, "mechanic", true, ""]
		};

		// Job Company (sans compétence mechanic): peut réparer à 100% dans l'atelier
		if (_isCompanyJob && _workshopOnly && _isInWorkshop) exitWith {
			[100, "company", true, ""]
		};

		// Tinkerer: 50% avec pièce (seulement certaines pièces)
		if (_hasTinkerer) exitWith {
			if (_item in Config_Repair_Tinkerer_Parts) then {
				[50, "tinkerer", true, ""]
			} else {
				// Tinkerer ne peut pas utiliser cette pièce, réparation basique sans consommer la pièce
				if (_hasGreaseMonkey) then {
					[40, "grease_monkey", true, ""]
				} else {
					[25, "basic", true, ""]
				};
			};
		};

		// Sans trait requis: réparation basique sans consommer la pièce
		// Le joueur sera notifié qu'il n'a pas le skill pour utiliser la pièce
		if (_hasGreaseMonkey) then {
			[40, "grease_monkey_no_skill", true, ""]
		} else {
			[25, "basic_no_skill", true, ""]
		};
	};

	// Réparation sans pièce - Non autorisée (sauf MacGyver qui est géré séparément)
	[0, "none", false, "STR_A3PL_Repair_Error_NoPart"]
}] call compile_Global;

/*
	Fonction pour obtenir le temps de réparation selon les traits
*/
["A3PL_Repair_GetRepairTime", {
	params [
		["_baseTime", 10, [0]]
	];

	private _traits = player getVariable ["Player_Traits", []];
	private _hasGreaseMonkey = "grease_monkey" in _traits;

	// Grease Monkey: -30% de temps de réparation
	if (_hasGreaseMonkey) then {
		_baseTime * 0.7
	} else {
		_baseTime
	};
}] call compile_Global;

["A3PL_Vehicle_RepairSelection", {
	if !(params [
		["_target", objNull, [objNull]],
		["_hitPoint", "", [""]]
	]) exitWith {false};

	if (isNull _target) exitWith {
		[("STR_A3PL_Repair_Error_NoTarget" call A3PL_Localize), Color_Red] call A3PL_Notification;
		false;
	};
	if !(alive _target) exitWith {
		[("STR_A3PL_Repair_Error_InvalidTarget" call A3PL_Localize), Color_Red] call A3PL_Notification;
		false;
	};
	if ((speed _target) >= 1) exitWith {
		[("STR_A3PL_Repair_Error_VehicleSpeed" call A3PL_Localize), Color_Red] call A3PL_Notification;
		false;
	};

	private _hitPointKey = "";
	{
		if ((toLower _x) isEqualTo (toLower _hitPoint)) exitWith {
			_hitPointKey = _x;
		};
	} forEach (keys Config_Repair);

	private _config = if (_hitPointKey isNotEqualTo "") then {
		Config_Repair get _hitPointKey;
	} else {
		nil;
	};
	if (isNil "_config") exitWith {
		[("STR_A3PL_Repair_Error_Occurs" call A3PL_Localize), Color_Red] call A3PL_Notification;
		false;
	};

	private _tool = _config get "tool";
	if ((_tool isNotEqualTo "") && {player_itemClass isNotEqualTo _tool}) exitWith {
		private _toolName = [_tool, "name"] call A3PL_Config_GetItem;
		if (_toolName isEqualTo false) then {_toolName = _tool;};
		[format [("STR_A3PL_Repair_Error_NoTool" call A3PL_Localize), _toolName], Color_Red] call A3PL_Notification;
		false;
	};

	private _item = _config get "item";
	private _workshopOnly = _config getOrDefault ["workshopOnly", false];

	private _repairData = [_item, _workshopOnly] call A3PL_Repair_GetRepairLevel;
	private _repair = _repairData#0;
	private _repairMethod = _repairData#1;
	private _canRepair = _repairData#2;
	private _reason = _repairData#3;

	if (!_canRepair) exitWith {
		[(_reason call A3PL_Localize), Color_Red] call A3PL_Notification;
		false;
	};

	private _health = floor((1 - (_target getHitPointDamage _hitPoint)) * 100);
	if (_health >= _repair) exitWith {
		[
			format [
				("STR_A3PL_Repair_Message_MaxRepair" call A3PL_Localize),
				(_config get "name") call A3PL_Localize,
				([_health] call A3PL_Repair_GetColorFromPercentage)#1,
				_health,
				"%",
				([_repair] call A3PL_Repair_GetColorFromPercentage)#1,
				_repair
			],
			Color_Red
		] call A3PL_Notification;
		false;
	};

	closeDialog 0;

	if (Player_ActionDoing) exitWith {
		[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize), Color_Red] call A3PL_Notification;
		false;
	};

	private _baseTime = _config getOrDefault ["time", 10];
	private _repairTime = [_baseTime] call A3PL_Repair_GetRepairTime;

	[format [("STR_A3PL_Repair_Progress_Repairing" call A3PL_Localize), (_config get "name") call A3PL_Localize], _repairTime] spawn A3PL_Lib_LoadAction;
	waitUntil {Player_ActionDoing};

	while {Player_ActionDoing} do {
		if !(alive _target) exitWith {Player_ActionInterrupted = true;};
		private _distance = 5;
		if (typeOf _target IN ["A3FL_T440_Tow_Truck"]) then {
			_distance = 10;
		};
		if ((player distance _target) > _distance) exitWith {Player_ActionInterrupted = true;};
		if (player getVariable ["restrained", false]) exitWith {Player_ActionInterrupted = true;};
		if (player getVariable ["surrender", false]) exitWith {Player_ActionInterrupted = true;};
		if ((speed _target) >= 1) exitWith {Player_ActionInterrupted = true;};
		if ((_tool isNotEqualTo "") && {player_itemClass isNotEqualTo _tool}) exitWith {Player_ActionInterrupted = true;};
	};

	if (Player_ActionInterrupted) exitWith {false;};

	if (_repairMethod in ["tinkerer", "mechanic", "company"]) then {
		if !([_item] call A3PL_Inventory_Has) exitWith {
			[("STR_A3PL_Repair_Error_NoItem" call A3PL_Localize), Color_Red] call A3PL_Notification;
			false;
		};
		[_item, 1] call A3PL_Inventory_Remove;
	};

	if (_repairMethod in ["grease_monkey_no_skill", "basic_no_skill"]) then {
		[("STR_A3PL_Repair_Warning_NoSkillForPart" call A3PL_Localize), Color_Orange] call A3PL_Notification;
	};

	private _damageValue = (100 - _repair) / 100;
	[_target, _hitPoint, _damageValue] remoteExec ["A3PL_Repair_ApplyDamage", _target];

	private _methodText = switch (_repairMethod) do {
		case "mechanic": {"STR_A3PL_Repair_Method_Mechanic" call A3PL_Localize};
		case "company": {"STR_A3PL_Repair_Method_Company" call A3PL_Localize};
		case "tinkerer": {"STR_A3PL_Repair_Method_Tinkerer" call A3PL_Localize};
		case "grease_monkey";
		case "grease_monkey_no_skill": {"STR_A3PL_Repair_Method_GreaseMonkey" call A3PL_Localize};
		case "basic_no_skill";
		default {"STR_A3PL_Repair_Method_Basic" call A3PL_Localize};
	};

	[
		format [
			("STR_A3PL_Repair_Message_RepairedWithMethod" call A3PL_Localize),
			(_config get "name") call A3PL_Localize,
			([_repair] call A3PL_Repair_GetColorFromPercentage)#1,
			_repair,
			"%",
			_methodText
		],
		Color_Green
	] call A3PL_Notification;

	true;
}] call compile_Global;

["A3PL_Vehicle_RepairAction", {
	disableSerialization;

	private _display = findDisplay 2900; // VEHICLE_REPAIR_DISPLAY_IDD
	if (isNull _display) exitWith {};

	[
		_display getVariable ["target", objNull],
		lbData [2901, lbCurSel 2901] // VEHICLE_REPAIR_LIST
	] spawn A3PL_Vehicle_RepairSelection;
}] call compile_Global;

["A3PL_Vehicle_RepairLbSelChanged", {
	disableSerialization;

	params [
		["_list", controlNull, [controlNull]],
		["_sel", -1, [-1]]
	];

	private _display = findDisplay 2900;
	if (isNull _display) exitWith {};

	private _part = _list lbData _sel;
	if (_part isEqualTo "") exitWith {};

	private _target = _display getVariable ["target", objNull];
	if (isNull _target) exitWith {};

	private _partKey = "";
	{
		if ((toLower _x) isEqualTo (toLower _part)) exitWith {
			_partKey = _x;
		};
	} forEach (keys Config_Repair);

	private _config = if (_partKey isNotEqualTo "") then {
		Config_Repair get _partKey;
	} else {
		nil;
	};
	if (isNil "_config") exitWith {};

	private _health = floor((1 - (_target getHitPointDamage _part)) * 100);
	private _item = _config get "item";
	private _tool = _config get "tool";
	private _workshopOnly = _config getOrDefault ["workshopOnly", false];
	private _hasTool = (_tool isEqualTo "") || {player_itemClass isEqualTo _tool};
	private _hasItem = if (_item isEqualTo "") then {false} else {[_item] call A3PL_Inventory_Has};
	private _isInWorkshop = [] call A3PL_Repair_IsInWorkshop;

	private _repairData = [_item, _workshopOnly] call A3PL_Repair_GetRepairLevel;
	private _repair = _repairData#0;
	private _repairMethod = _repairData#1;
	private _canRepair = _repairData#2;
	private _reason = _repairData#3;

	private _traits = player getVariable ["Player_Traits", []];
	private _hasMacGyver = "macgyver" in _traits;
	private _hasGreaseMonkey = "grease_monkey" in _traits;
	private _hasTinkerer = "tinkerer" in _traits;
	private _hasMechanic = "mechanic" in _traits;

	private _toolPicture = "";
	private _toolName = "";
	if (_tool isNotEqualTo "") then {
		private _toolIconResult = [_tool, "icon"] call A3PL_Config_GetItem;
		private _toolNameResult = [_tool, "name"] call A3PL_Config_GetItem;
		if (!(_toolIconResult isEqualTo false)) then {_toolPicture = _toolIconResult;};
		if (!(_toolNameResult isEqualTo false)) then {_toolName = _toolNameResult;};
	};

	private _itemPicture = "";
	private _itemName = "";
	if (_item isNotEqualTo "") then {
		private _itemIconResult = [_item, "icon"] call A3PL_Config_GetItem;
		private _itemNameResult = [_item, "name"] call A3PL_Config_GetItem;
		if (!(_itemIconResult isEqualTo false)) then {_itemPicture = _itemIconResult;};
		if (!(_itemNameResult isEqualTo false)) then {_itemName = _itemNameResult;};
	};

	private _traitText = "";
	if (_hasMechanic) then {
		_traitText = format ["<t color='#0A8B0A'>%1</t>", "STR_A3PL_Repair_Trait_Mechanic" call A3PL_Localize];
	} else {
		if (_hasTinkerer) then {
			_traitText = format ["<t color='#FFA500'>%1</t>", "STR_A3PL_Repair_Trait_Tinkerer" call A3PL_Localize];
		} else {
			if (_hasGreaseMonkey) then {
				_traitText = format ["<t color='#FFFF00'>%1</t>", "STR_A3PL_Repair_Trait_GreaseMonkey" call A3PL_Localize];
			} else {
				_traitText = format ["<t color='#CB2323'>%1</t>", "STR_A3PL_Repair_Trait_None" call A3PL_Localize];
			};
		};
	};

	private _workshopText = "";
	if (_workshopOnly) then {
		if (_isInWorkshop) then {
			_workshopText = format ["<t color='#0A8B0A'>%1</t>", "STR_A3PL_Repair_Workshop_Inside" call A3PL_Localize];
		} else {
			_workshopText = format ["<t color='#CB2323'>%1</t>", "STR_A3PL_Repair_Workshop_Required" call A3PL_Localize];
		};
	};

	private _methodText = switch (_repairMethod) do {
		case "mechanic": {format ["<t color='#0A8B0A'>%1 (100%%)</t>", "STR_A3PL_Repair_Method_Mechanic" call A3PL_Localize]};
		case "company": {format ["<t color='#0A8B0A'>%1 (100%%)</t>", "STR_A3PL_Repair_Method_Company" call A3PL_Localize]};
		case "tinkerer": {format ["<t color='#FFA500'>%1 (50%%)</t>", "STR_A3PL_Repair_Method_Tinkerer" call A3PL_Localize]};
		case "grease_monkey": {format ["<t color='#FFFF00'>%1 (40%%)</t>", "STR_A3PL_Repair_Method_GreaseMonkey" call A3PL_Localize]};
		case "grease_monkey_no_skill": {format ["<t color='#FFFF00'>%1 (40%%)</t><br/><t color='#FFA500' size='0.9'>%2</t>", "STR_A3PL_Repair_Method_GreaseMonkey" call A3PL_Localize, "STR_A3PL_Repair_Warning_NoSkillShort" call A3PL_Localize]};
		case "basic_no_skill": {format ["<t color='#CB2323'>%1 (25%%)</t><br/><t color='#FFA500' size='0.9'>%2</t>", "STR_A3PL_Repair_Method_Basic" call A3PL_Localize, "STR_A3PL_Repair_Warning_NoSkillShort" call A3PL_Localize]};
		case "basic": {format ["<t color='#CB2323'>%1 (25%%)</t>", "STR_A3PL_Repair_Method_Basic" call A3PL_Localize]};
		default {format ["<t color='#CB2323'>%1</t>", "STR_A3PL_Repair_Method_None" call A3PL_Localize]};
	};

	(_display displayCtrl 2905) ctrlSetStructuredText parseText format [
		"<t size='1.1'>%1</t>",
		(_config get "name") call A3PL_Localize
	];

	(_display displayCtrl 2907) ctrlSetStructuredText parseText format [
		"<t size='1.1' color='%1'>%2%3</t>",
		([_health] call A3PL_Repair_GetColorFromPercentage)#1,
		_health,
		"%"
	];

	(_display displayCtrl 2908) ctrlSetStructuredText parseText format [
		"<t color='%1'>%2</t></t>",
		if _hasTool then {"#0A8B0A"} else {"#CB2323"},
		_toolName
	];

	(_display displayCtrl 2909) ctrlSetStructuredText parseText format [
		"<t color='%1'>%2</t></t>",
		if _hasItem then {"#0A8B0A"} else {"#CB2323"},
		_itemName
	];

	ctrlEnable [2906, _hasTool && _canRepair && {_health < _repair}];
}] call compile_Global;

["A3PL_Vehicle_RepairOpen", {
	disableSerialization;
	private _target = param [0, objNull, [objNull]];
	if (isNull _target) exitWith {
		[("STR_A3PL_Repair_Error_InvalidTarget" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};

	createDialog "RscDisplayVehicleRepair";
	private _display = findDisplay 2900;
	if (isNull _display) exitWith {
		[("STR_A3PL_Repair_Error_Occurs" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};

	_display call A3PL_Dialog_Localize;

	_display setVariable ["target", _target];

	private _distance = player distance _target;
	private _health = round((1 - ([_target] call A3PL_Repair_GetHitPointsDamagesAverage)) * 100);

	(_display displayCtrl 2903) ctrlSetStructuredText parseText format [ 
		"<t size='1.1'><t align='center'><t color='%2'>%3</t>%1</t></t>",
		"%",
		([_health] call A3PL_Repair_GetColorFromPercentage)#1,
		_health
	];

	[] call A3PL_Vehicle_RepairUpdate;

	while {!(isNull _display)} do {
		if (
			(isNull _target)
			|| {!(alive _target)}
			|| {abs(_distance - (player distance _target)) > 1}
			|| {player getVariable ["restrained", false]}
			|| {player getVariable ["surrender", false]}
		) exitWith {closeDialog 0};

		uiSleep 0.5;
	};
}] call compile_Global;

["A3PL_Vehicle_RepairUpdate", {
	disableSerialization;
	private _display = findDisplay 2900;
	if (isNull _display) exitWith {};

	private _target = _display getVariable ["target", objNull];
	if (isNull _target) exitWith {};

	private _type = cbChecked (_display displayCtrl 2902);
	private _list = _display displayCtrl 2901;
	lbClear _list;

	private _hitPoints = getAllHitPointsDamage _target;
	if (_hitPoints isEqualTo []) exitWith {};

	private _hitPointNames = _hitPoints#0;
	private _hitPointSelections = _hitPoints#1;

	{
		private _part = _x;
		private _partIndex = _forEachIndex;

		private _selection = _hitPointSelections select _partIndex;
		if (_selection isEqualTo "") then {continue}; 

		private _partKey = "";
		{
			if ((toLower _x) isEqualTo (toLower _part)) exitWith {
				_partKey = _x;
			};
		} forEach (keys Config_Repair);

		private _config = if (_partKey isNotEqualTo "") then {
			Config_Repair get _partKey;
		} else {
			nil;
		};

		if (!isNil "_config") then {
			private _health = floor((1 - (_target getHitPointDamage _part)) * 100);

			if (!_type || {_health < 100}) then {
				private _index = _list lbAdd ((_config get "name") call A3PL_Localize);
				private _color = ([_health] call A3PL_Repair_GetColorFromPercentage)#0;

				_list lbSetTooltip [_index, (_config get "name") call A3PL_Localize];
				_list lbSetData [_index, _part];
				_list lbSetTextRight [_index, format ["%1%2", _health, "%"]];
				_list lbSetPicture [_index, _config get "picture"];
				_list lbSetPictureColor [_index, _color];
				_list lbSetColorRight [_index, _color];
			};
		};
	} forEach _hitPointNames;

	if ((lbSize _list) isEqualTo 0) then {
		(_display displayCtrl 2905) ctrlShow false; 
		(_display displayCtrl 2906) ctrlShow false; 
		_list lbAdd (("STR_A3PL_Repair_UI_Empty" call A3PL_Localize));
	} else {
		(_display displayCtrl 2905) ctrlShow true; 
		(_display displayCtrl 2906) ctrlShow true; 
	};

	_list lbSetCurSel 0;
}] call compile_Global;

["A3PL_Vehicle_GetPartFromSelection", {
	private _selection = param [0, "", [""]];

	if (_selection isEqualTo "") exitWith {""};

	private _result = "";
	{
		private _hitPoint = _x;
		private _config = Config_Repair get _hitPoint;
		if (!isNil "_config") then {
			private _select = _config getOrDefault ["select", ""];
			if (_select isEqualTo _selection) exitWith {
				_result = _hitPoint;
			};
		};
	} forEach (keys Config_Repair);

	_result;
}] call compile_Global;

["A3PL_Repair_MacGyver", {
	/*
		MacGyver trait - Emergency repair without parts
		Repairs vehicle to 50% HP max, lasts 10 minutes
	*/
	params [
		["_vehicle", objNull, [objNull]]
	];

	if (isNull _vehicle) exitWith {
		[("STR_A3PL_Repair_Error_NoTarget" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};

	private _traits = player getVariable ["Player_Traits", []];
	if !("macgyver" in _traits) exitWith {
		[("STR_A3PL_Trait_MacGyver_Required" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};

	if (_vehicle getVariable ["A3PL_MacGyver_Repaired", false]) exitWith {
		[("STR_A3PL_Repair_AlreadyMacGyvered" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};

	if ((speed _vehicle) >= 1) exitWith {
		[("STR_A3PL_Repair_Error_VehicleSpeed" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};

	player playMove "AinvPknlMstpSnonWnonDnon_medic_1";
	if (Player_ActionDoing) exitWith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[("STR_A3PL_Repair_MacGyvering" call A3PL_Localize), 15] spawn A3PL_Lib_LoadActionQTE;
	waitUntil{Player_ActionDoing};
	while {Player_ActionDoing} do {
		if (!(player getVariable["A3PL_Medical_Alive",true])) exitWith {Player_ActionInterrupted = true;};
		if ((vehicle player) != player) exitWith {Player_ActionInterrupted = true;};
		if (player getVariable ["Incapacitated",false]) exitWith {Player_ActionInterrupted = true;};
	};
	if(Player_ActionInterrupted) exitWith {};

	private _hitPointsData = getAllHitPointsDamage _vehicle;
	if (_hitPointsData isEqualTo []) exitWith {
		[("STR_A3PL_Repair_NoHitPoints" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};

	private _hitPointNames = _hitPointsData select 0;
	private _hitPointDamages = _hitPointsData select 2;
	private _savedDamages = [];

	{
		_savedDamages pushBack _x;
	} forEach _hitPointDamages;

	{
		private _hitPointName = _x;
		private _damage = _hitPointDamages select _forEachIndex;
		if (_damage > 0.5) then {
			_vehicle setHitPointDamage [_hitPointName, 0.5];
		} else {
			_vehicle setHitPointDamage [_hitPointName, _damage * 0.5];
		};
	} forEach _hitPointNames;

	_vehicle setVariable ["A3PL_MacGyver_Repaired", true, true];
	_vehicle setVariable ["A3PL_MacGyver_SavedDamages", [_hitPointNames, _savedDamages], true];

	[("STR_A3PL_Repair_MacGyverSuccess" call A3PL_Localize), Color_Green] call A3PL_Notification;

	[{
		params ["_vehicle", "_hitPointNames", "_savedDamages"];

		if (isNull _vehicle) exitWith {};

		{
			_vehicle setHitPointDamage [_x, _savedDamages select _forEachIndex];
		} forEach _hitPointNames;

		_vehicle setVariable ["A3PL_MacGyver_Repaired", false, true];
		_vehicle setVariable ["A3PL_MacGyver_SavedDamages", nil, true];

	}, [_vehicle, _hitPointNames, _savedDamages], 600] call CBA_fnc_waitAndExecute;
}] call compile_Global;
