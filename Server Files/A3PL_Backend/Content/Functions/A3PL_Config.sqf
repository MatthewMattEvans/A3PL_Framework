/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/

["A3PL_Config_GetItem",
{
	params [["_class",""],["_search","",[""]]];
	if (_class isEqualTo "") exitWith {false;};

	private _itemMap = Config_ItemMap;
	private _itemData = _itemMap getOrDefault [toLower(_class),""];
	if ((count _itemData) isEqualTo 0) exitwith {false;};
	private _return = switch (_search) do {
		case ("name"): {
			if (_itemData#0 isEqualTo "inh") then {
				getText (configFile >> "CfgVehicles" >> (_itemData#2) >> "displayName");
			} else {
				_itemData#0;
			};
		};
		case ("displayName"): {
			if (_itemData#0 isEqualTo "inh") then {
				getText (configFile >> "CfgVehicles" >> (_itemData#2) >> "displayName");
			} else {
				_itemData#0;
			};
		};
		case ("icon"): {getText (configFile >> "CfgVehicles" >> (_itemData#2) >> "picture")};
		case ("weight"): {_itemData#1};
		case ("class"): {_itemData#2};
		case ("dir"): {_itemData#3};
		case ("canDrop"): {_itemData#4};
		case ("canGive"): {_itemData#5};
		case ("canUse"): {_itemData#6};
		case ("canPickup"): {_itemData#7};
		case ("simulation"): {_itemData#8};
		case ("fnc"): {_itemData#9};
		case ("attach"): {_itemData#10};
		case ("desc"): {_itemData#11};
		case ("maxTake"): {_itemData#12};
		case ("picture"): {_itemData#13};
		default {_return};
	};
	_return;
}] call compile_Global;

["A3PL_Config_GetLicenseData",
{
	private _license = param [0,""];
	private _dataIndex = param [1,0];
	private _licenseMap = Config_Licenses;
	private _licenseData = _licenseMap get _license;
	if (isNil "_licenseData") exitWith {nil};
	private _return = _licenseData#_dataIndex;
	_return;
}] call compile_Global;

["A3PL_Config_LicenseExists",
{
	private _return = false;
	private _license = toLowerANSI (param [0,""]);
	private _licenseMap = Config_Licenses;
	_return = _license in _licenseMap;
	_return;
}] call compile_Global;

["A3PL_Config_GetPaycheckPay",
{
	private _return = 0;
	private _job = param [0,nil];
	private _jobMap = Config_Paychecks;
	private _jobData = _jobMap get _job;
	_return = _jobData;
	_return;
}] call compile_Global;

["A3PL_Config_GetFood",
{
	private _food = param [0,""];
	private _dataIndex = param [1,0];
	private _foodMap = Config_Food;
	private _foodData = _foodMap get _food;
	private _return = _foodData#_dataIndex;
	_return;
}] call compile_Global;

["A3PL_Config_GetThirst",
{
	private _drink = param [0,""];
	private _dataIndex = param [1,0];
	private _drinkMap = Config_Thirst;
	private _drinkData = _drinkMap get _drink;
	private _return = _drinkData#_dataIndex;
	_return;
}] call compile_Global;


["A3PL_Config_HasStorage", {
	params [["_class","",[""]]];
	private _return = false;
	private _vehicleData = Config_Vehicles_Data getOrDefault [_class, []];
	if ((count _vehicleData) > 0) then {
		_return = true;
	};
	_return;
}] call compile_Global;


["A3PL_Config_GetVehicleCapacity", {
	params [["_class","",[""]]];
	private _return = 0;
	private _vehicleData = Config_Vehicles_Data getOrDefault [_class, []];
	if ((count _vehicleData) > 0) then {
		_return = _vehicleData select 0;
	};
	_return;
}] call compile_Global;


["A3PL_Config_GetVehicleMSRP", {
	params [["_class","",[""]]];
	private _return = 0;
	private _vehicleData = Config_Vehicles_Data getOrDefault [_class, []];
	if ((count _vehicleData) > 1) then {
		_return = _vehicleData select 1;
	};
	_return;
}] call compile_Global;

["A3PL_Config_GetShop", {
	params [["_class","",[""]],["_itemClass","",[""]]];
	private _return = [];
	{
		if((_x#0) == _class) exitwith {
			switch (_itemClass) do {
				case ("pos"): {_return = _x#2;};
				case ("spawnpos"): {_return = _x#3;};
				default {_return = _x#1};
			};
		};
	} forEach Config_Shops_Items;
	_return;
}] call compile_Global;

/*["A3PL_Config_GetMarker", {
	params [["_markername","",[""]],["_info","",[""]]];
	private _return = [];
	if ((isNil _markername) && (isNil _info)) exitWith {
		{
			_return pushBackUnique _x#0;
		} forEach Config_SmartMarkers;
		_return;
	};
	{
		if((_x#0) == _markername) exitwith {
			switch (_info) do {
				case ("isSmallPopup"): {_return = _x#1#1;};
				case ("isSpecific"): {_return = _x#2#1;};
				case ("title"): {_return = _x#3#1;};
				case ("color"): {_return = _x#4#1;};
				case ("type"): {_return = _x#5#1;};
				case ("hours"): {_return = _x#6#1;};
				case ("description"): {_return = _x#7#1;};
				case ("masterType"): {_return = _x#8#1;};
				case ("mastertypeIcon"): {_return = _x#9#1;};
				case ("owner"): {_return = _x#10#1;};
				case ("businessName"): {_return = _x#11#1;};
				default {_return = _x#0};
			};
		};
	} forEach Config_SmartMarkers;
	_return;
}] call compile_Global;*/

["A3PL_Config_GetFactory",
{
	params [["_class","",[""]],["_factory","",[""]],["_search","",[""]]];
	private _config = [];
	private _return = false;

	{
		if((_x#0) isEqualTo _factory) exitWith {
			_config append _x;
		};
	} forEach Config_Factories;

	if (_class isEqualTo "all") exitwith { _return = _config; _return deleteAt 0; _return deleteAt 0; _return;};
	if (_class isEqualTo "pos") exitwith { _return = _config#1; _return;};

	_config deleteRange [0, 1];
	{
		if ((_x#0) isEqualTo _class) exitWith {_config = _x};
	} foreach _config;
	_return = switch (_search) do {
		case "id": { _config#0; };
		case "class": { _config#1; };
		case "type": { _config#2; };
		case "time": { _config#3; };
		case "required": { _config#4; };
		case "output": { _config#5; };
		case "desc": { _config#6; };
	};
	_return;
}] call compile_Global;

["A3PL_Config_GetPlayerFactory",
{
	params [["_class","",[]],["_search","",[""]]];
	private _return = [];
	{
		if ((_x#0) == _class) exitWith {
			_return = _x;
		};
	} forEach (player getVariable ["player_factories",[]]);
	_return = switch (_search) do {
		default {false};
		case "craftID": {_return#0};
		case "classname": {_return#1};
		case "required": {_return#2};
		case "type": {_return#3};
		case "classtype": {_return#4};
		case "id": {_return#5};
		case "amount": {_return#6};
		case "finish": {_return#7};
		case "count": {_return#8};
	};
	_return;
}] call compile_Global;

["A3PL_Config_GetPlayerFStorage",
{
	params [["_class","",[""]],["_search","",[""]],["_player",player,[objNull]]];
	private _return = [];

	{
		if ((_x select 0) == _class) exitWith {_return = _x;};
	} forEach (_player getVariable ["player_fStorage",[]]);
	if ((count _return) isEqualTo 0) exitwith {false;};
	_return = switch (_search) do {
		default {false};
		case "type": {_return#0};
		case "items": {_return#1};
	};
	_return;
}] call compile_Global;

["A3PL_Config_GetGarageUpgrade",
{
	params [["_class","",[""]],["_typeOf","",[""]],["_search","",[""]]];
	private _return = [];
	{
		if((_x select 0) isEqualTo _typeOf) exitWith {
			_return = [] + _x;
		};
	} forEach Config_Garage_Upgrade;
	if (_class isEqualTo "all") exitwith {_return deleteAt 0;_return;};

	_return deleteAt 0;
	{
		if ((_x select 0) == _class) then {_return = _x};
	} foreach _return;
	_return = switch (_search) do {
		default {false};
		case "id": {_return#0};
		case "type": {_return#1};
		case "class": {_return#2};
		case "title": {_return#3};
		case "desc": {_return#4};
		case "camTarget": {_return#5};
		case "camOffset": {_return#6};
		case "price": {_return#7};
		case "required": {_return#8};
		case "stock": {_return#9};
	};
	_return;
}] call compile_Global;

["A3PL_Config_GetGaragePaint",
{
	params [["_class","",[""]],["_typeOf","",[""]],["_search","",[""]],["_faction","",[""]]];
	private _searchClass = format ["%1_Textures",_typeOf];
	private _config = [];
	{
		private ["_name","_requiredJob"];
		_name = getText (configFile >> "CfgVehicles" >> _searchClass >> "Skins" >> (configName _x) >> "Name");
		_requiredJob = getText (configFile >> "CfgVehicles" >> _searchClass >> "Skins" >> (configName _x) >> "faction");
		if((_requiredJob isEqualTo "citizen") || {_faction isEqualTo _requiredJob}) then {
			_config append [[configName _x,getArray (configFile >> "CfgVehicles" >> _searchClass >> "Skins" >> (configName _x) >> "Texture_Path"),_name]];
		};
	} forEach ("true" configClasses (configFile >> "CfgVehicles" >> _searchClass >> "Skins"));

	if (_class isEqualTo "all") exitwith {_config;};
	{
		if (_x#0 isEqualTo _class) exitWith {_config = _x};
	} foreach _config;

	private _return = switch (_search) do {
		case "id": {_config#0};
		case "file": {_config#1};
		case "title": {_config#2};
		default {false};
	};
	_return;
}] call compile_Global;

["A3PL_Config_GetGarageRepair",
{
	params [["_class","",[""]],["_search","",[""]]];
	private _config = [];
	private _Config_Garage_Repair = [
		["engine",("STR_A3PL_Config_Engine" call A3PL_Localize)],
		["body",("STR_A3PL_Config_Body" call A3PL_Localize)],
		["wheel_1_1_steering",("STR_A3PL_Config_Wheel_FL" call A3PL_Localize)],
		["wheel_1_2_steering",("STR_A3PL_Config_Wheel_RL" call A3PL_Localize)],
		["wheel_2_1_steering",("STR_A3PL_Config_Wheel_FR" call A3PL_Localize)],
		["wheel_2_2_steering",("STR_A3PL_Config_Wheel_RR" call A3PL_Localize)],
		["glass1",("STR_A3PL_Config_Window_Front" call A3PL_Localize)],
		["glass2",("STR_A3PL_Config_Window_FL" call A3PL_Localize)],
		["glass3",("STR_A3PL_Config_Window_RL" call A3PL_Localize)],
		["glass4",("STR_A3PL_Config_Window_FR" call A3PL_Localize)],
		["glass5",("STR_A3PL_Config_Window_RR" call A3PL_Localize)],
		["glass6",("STR_A3PL_Config_Window_Rear" call A3PL_Localize)],
		["l svetlo",("STR_A3PL_Config_Light_Left" call A3PL_Localize)],
		["p svetlo",("STR_A3PL_Config_Light_Right" call A3PL_Localize)],
		["spotlight_hit",("STR_A3PL_Config_Spotlight" call A3PL_Localize)]
	];

	{
		if((_x#0) isEqualTo _class) then  {
			_config append _x;
		};
	} forEach _Config_Garage_Repair;

	if ((count _config) isEqualTo 0) exitwith {false;};
	private _return = switch (_search) do {
		case "id": {_config#0};
		case "title": {_config#1};
		default {_class};
	};
	_return;
}] call compile_Global;

["A3PL_Config_GetRanks",
{
	params [["_class","",[""]],["_search","",[""]]];
	private _config = [];
	private _index = -1;

	{
		if((_x#0) == _class) exitWith {
			_config append _x;
			_index = _forEachIndex;
		};
	} forEach Server_Government_FactionRanks;

	if ((count _config) isEqualTo 0) exitwith {[[],_index];};
	private _return = switch (_search) do {
		case "faction": {_config#0};
		case "ranks": {_config#1};
		default {[]};
	};
	[_return,_index];
}] call compile_Global;

["A3PL_Config_GetWoundData",
{
	params [["_wound","",[""]],["_dataIndex",0,[0]]];
	private _woundMap = Config_Medical_Wounds;
	private _woundData = _woundMap get _wound;
	private _return = _woundData#_dataIndex;
	_return;
}] call compile_Global;

["A3PL_Config_isTaxed",
{
	params [["_class","",[""]]];
	private _return = false;
	{
		if((_x#0) isEqualTo _class) exitWith {_return = true;};
	} forEach Config_Shops_TaxSystem;
	_return;
}] call compile_Global;

["A3PL_Config_GetTaxes",
{
	params [["_class","",[""]]];
	private _return = "";
	{
		if((_x#0) == _class) exitWith  {_return = _x#1;};
	} forEach (missionNameSpace getVariable ["Config_Government_Taxes",[]]);
	_return;
}] call compile_Global;

["A3PL_Config_GetTaxSeting",
{
	params [["_class","",[""]],["_search","",[""]]];
	{
		if((_x#0) isEqualTo _class) exitWith {
			_return = _x;
		};
	} forEach Config_Shops_TaxSystem;
	private _return = switch (_search) do {
		case "budget": {_return#1};
		case "tax": {_return#2};
	};
	_return;
}] call compile_Global;

["A3PL_Config_GetFactionRankData",
{
	private ["_faction", "_config","_rankData","_search","_charID"];

	_faction = param [0,""];
	_search = param [1,""];
	_charID = param [2,""];
	_config = [];
	_rankData = [];
	_return = "";

	if (_faction == "") exitWith {false;};

	{
		if((_x select 0) == _faction) exitWith {
			_config = _x select 1;
		};
	} forEach Server_Government_FactionRanks;

	{
		if(_charID IN (_x select 1)) exitWith {
			_rankData = _x;
		};
	} forEach _config;

	if ((count _rankData) == 0) then {_rankData = ["Reserve",[_charID],0];};
	switch (_search) do {
		default { _return = _rankData; };
		case "rank": { _return = _rankData select 0; };
		case "pay": { _return = _rankData select 2; };
	};
	_return;
}] call compile_Global;

["A3PL_Config_InCompany",
{
	params [["_charID","",[""]]];
	private _return = false;
	{
		for "_i" from 0 to count(_x#3) do {
			if(_charID isEqualTo ((_x#3)#_i)#0) exitWith  {_return = true;};
		};
	} forEach Server_Companies;
	_return;
}] call compile_Global;

["A3PL_Config_IsCompanyBoss",
{
	params [["_charID","",[""]]];
	private _return = false;
	{
		if(_charID isEqualTo (_x#2)) exitwith {_return = true;};
	} forEach Server_Companies;
	_return;
}] call compile_Global;

["A3PL_Config_GetCompanyID",
{
	params [["_charID","",[""]]];
	private _return = 0;
	{
		for "_i" from 0 to count(_x#3) do {
			if(_charID isEqualTo (((_x#3)#_i)#0)) exitWith  {
				_return = _x#0;
			};
		};
	} forEach Server_Companies;
	_return;
}] call compile_Global;

["A3PL_Config_GetCompanyData",
{
	params [["_id",0,[0]],["_search","",[""]]];
	private _return = [];
	{
		if(_id isEqualTo (_x#0)) exitWith {_return = _x;};
	} forEach Server_Companies;
	if(count _return isEqualTo 0) exitWith {};
	_return = switch (_search) do {
		case "id": {_return#0};
		case "name": {_return#1};
		case "boss": {_return#2};
		case "employees": {_return#3};
		case "bank": {_return#4};
		case "licenses": {_return#5};
		case "ranks": {_return#7};
		case "sector": {if (count _return > 8) then {_return#8} else {[]}};
	};
	_return;
}] call compile_Global;

["A3FL_Config_GetCompanyPermissions",
{
	params [["_id",""],["_search","",[""]],["_charID","",[""]]];
	private _config = [];
	private _permData = [];

	if (_id isEqualTo "") exitWith {false;};
	{
		if((_x#0) isEqualTo _id) exitWith {
			_config = _x#7;
		};
	} forEach Server_Companies;
	if(_config isEqualTo []) exitwith {false;};

	{
		if(_charID IN (_x#1)) exitWith {
			_permData = _x;
		};
	} forEach _config;
	if(_permData isEqualTo []) exitwith {false;};
	private _return = switch (_search) do {
		default {_permData};
		case "hire": {_permData#3};
		case "shop": {_permData#4};
		case "bank": {_permData#5};
		case "ranks": {_permData#6};
		case "garage": {_permData#7};
		case "transfer": {_permData#8};
		case "twitter": {_permData#9};
		case "filesmanager": {_permData#10};
		case "stockaccess": {_permData#11};
		case "stockmanage": {_permData#12};
	};
	_return;
}] call compile_Global;

["A3FL_Config_GetCompanyRankData",
{
	params [["_id",""],["_search","",[""]],["_charID","",[""]]];
	private _config = [];
	private _rankData = [];

	if (_id isEqualTo "") exitWith {false;};
	{
		if((_x#0) isEqualTo _id) exitWith {
			_config = _x#7;
		};
	} forEach Server_Companies;

	if ((_config isEqualTo []) && {_search isEqualTo "pay"}) exitWith {0};
	if ((_config isEqualTo []) && {_search isEqualTo "rank"}) exitwith {("STR_A3PL_Config_NoRank" call A3PL_Localize);};
	{
		if(_charID IN (_x#1)) exitWith {
			_rankData = _x;
		};
	} forEach _config;

	if (count _rankData isEqualTo 0) then {_rankData = _config select ((count _config) - 1);};
	private _return = switch (_search) do {
		default {_rankData};
		case "rank": {_rankData#0};
		case "pay": {_rankData#2};
	};
	_return;
}] call compile_Global;

["A3PL_Config_CanUseBargate", {
	params [["_pos",[0,0,0],[[]]]];
	private _return = true;
	private _pFaction = player getVariable["faction","citizen"];
	if ((vehicle player) isNotEqualTo player) then {
		private _vFaction = (vehicle player) getVariable["faction",nil];
		if(!isNil "_vFaction") then {
			_pFaction = _vFaction;
		};
	};
	{
		if(((_x#0) distance _pos) < 10) then {
			if(!(_pFaction IN (_x#1))) exitWith {
				_return	= false;
			};
		};
	} forEach Config_Objects_Bargates;
	_return;
}] call compile_Global;

["A3PL_Config_GetBalance",
{
	params [["_job","",[""]]];
	private _balance = switch (_job) do {
		case ("STR_Common_FISD" call A3PL_Localize): {("STR_Common_SheriffsDepartment" call A3PL_Localize)};
		case ("STR_Common_FIFR" call A3PL_Localize): {("STR_Common_FireDepartment" call A3PL_Localize)};
		case ("STR_Common_DOJ" call A3PL_Localize): {("STR_Common_DepartmentOfJustice" call A3PL_Localize)};
		case ("STR_Common_GOV" call A3PL_Localize): {("STR_Common_Government" call A3PL_Localize)};
		default {""};
	};
	_balance;
}] call compile_Global;
