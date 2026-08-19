/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/

// Stock Management
["A3PL_Stock_Man_AskOpen",{
	params[["_obj",objNull, [objNull]]];
	if (_obj isEqualTo objNull) exitwith {[("STR_A3PL_Stock_ErrorNoObj" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[0,player,_obj] remoteExec ["Server_Stock_Info", 2];
}] call compile_Global;

["A3PL_Stock_Man_OpenReceive",{
	params[
		["_objtype","item",["item"]],
		["_service","",[""]],
		["_items",[],[[]]],
		["_ranks",[],[[]]],
		["_obj",objNull,[objNull]]
	];
	disableSerialization;

	if (_service isEqualTo "") exitwith {[("STR_A3PL_Stock_ErrorNoService" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_obj getVariable ["inUse",false]) exitwith {[("STR_A3PL_Stock_AlreadyInUse" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _pItems = assignedItems player + items player;
	private _pweps = weapons player;
	private _vinventory = player getVariable ["player_inventory", []];
	if ("Binocular" IN _pItems) then {_pItems = _pItems - ["Binocular"]};
    private _pmags = magazines player;
    if (currentMagazine player != "") then {_pmags pushback (currentMagazine player);};

	A3PL_OBJTYPE = _objtype;
	A3PL_STOCKEDITSERVICE = _service;
	A3PL_STOCKRANKS = _ranks;
	A3PL_STOCKITEMS = _items;
	A3PL_STOCKOBJ = _obj;

	A3PL_STOCKOBJ setVariable ["inUse",true,true];
	
	createDialog "A3PL_StockManage";
	private _display = findDisplay 1102;
	_display displayAddEventHandler ["Unload",{A3PL_STOCKEDITSERVICE = nil; A3PL_STOCKRANKS = nil; A3PL_STOCKITEMS = nil; A3PL_STOCKLICENSES = nil; A3PL_STOCKOBJ setVariable ["inUse",nil,true]; A3PL_STOCKOBJ = nil; }];

	private _control = _display displayCtrl 1503;
	{
		private _index = _control lbAdd _x#0;
		_control lbSetData [_index,_x#0];
	} foreach _ranks;

	_control = _display displayCtrl 1513;
	private _licenses = [];
	if (A3PL_STOCKEDITSERVICE IN [("STR_Common_FIFR" call A3PL_Localize),("STR_Common_FISD" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) then {
		{
			if ((_x find _service) > -1) then {
				_licenses pushBack _x;
			};
		} forEach (toArray Config_Licenses)#0;
	} else {
		_licenses = [[(player getVariable ["character_id",""])] call A3PL_Config_GetCompanyID, "licenses"] call A3PL_Config_GetCompanyData;
	};
	
	A3PL_STOCKLICENSES = _licenses;

	{
		private _name = [_x,0] call A3PL_Config_GetLicenseData;
		if (!isNil "_name") then {
			private _index = _control lbAdd _name;
			_control lbSetData [_index,_x];
		};
	} foreach _licenses;

	_control = _display displayCtrl 1500;
	private _i = _control lbAdd ("STR_A3PL_Stock_NoSelection" call A3PL_Localize);
	if (_objtype isEqualTo "items") then {
		_control lbSetData [_i,'["",0,"","",[[],[],[]],[[],[],[]],"item",0]'];
	} else {
		_control lbSetData [_i,'["",0,"","",[[],[],[]],[[],[],[]],[],"vehicle",0]'];
	};
	{
		private _type = "item";
		private _vars = [];
		if (_objtype IN ["vehicles","plane"]) then {
			_vars = _x#6;
			_type = _x#7;
		} else {
			_type = _x#6;
		};
		private _itemName = "";
		switch (_type) do
		{
			case ("aitem"): { _itemName = getText (configFile >> "CfgWeapons" >> _x#0 >> "displayName"); };
			case ("item"): { _itemName = [_x#0,"name"] call A3PL_Config_GetItem; };
			case ("backpack"): { _itemName = getText (configFile >> "CfgVehicles" >> _x#0 >> "displayName"); };
			case ("uniform"): { _itemName = getText (configFile >> "CfgWeapons" >> _x#0 >> "displayName"); };
			case ("vest"): { _itemName = getText (configFile >> "CfgWeapons" >> _x#0 >> "displayName"); };
			case ("headgear"): { _itemName = getText (configFile >> "CfgWeapons" >> _x#0 >> "displayName"); };
			case ("vehicle"): { _itemName = getText (configFile >> "CfgVehicles" >> _x#0 >> "displayName"); };
			case ("plane"): { _itemName = getText (configFile >> "CfgVehicles" >> _x#0 >> "displayName"); };
			case ("weapon"): { _itemName = getText (configFile >> "CfgWeapons" >> _x#0 >> "displayName"); };
			case ("weaponPrimary"): { _itemName = getText (configFile >> "CfgWeapons" >> _x#0 >> "displayName"); };
			case ("magazine"): { _itemName = getText (configFile >> "CfgMagazines" >> _x#0 >> "displayName"); };
			case ("goggles"): { _itemName = getText (configFile >> "CfgGlasses" >> _x#0 >> "displayName"); };
			case ("waitem"): { _itemName = getText (configFile >> "CfgWeapons" >> _x#0 >> "displayName"); };
		};
		private _customName = _x#2;

		if (_customName isNotEqualTo "") then {
			_itemName = _customName;
		};

		private _replacedContent = "";
		_replacedContent = [_itemName, '?z?', '"'] call CBA_fnc_replace;
		_replacedContent = [_replacedContent, '?y?', "'"] call CBA_fnc_replace;
		_replacedContent = [_replacedContent, '?x?', "\"] call CBA_fnc_replace;

		private _count = _x#1;
		private _index = _control lbAdd format ["(%1x) %2", _count, _replacedContent];
		
		private _desc = _x#3;
		private _rankperms = _x#4;
		private _licensesperms = _x#5;
		private _info = "";
		
		if (_objtype IN ["vehicles","plane"]) then {
			_info = format['["%1",%2,"%3","%4",%5,%6,%7,"%8",%9]', _x#0, _count, _customName, _desc, _rankperms, _licensesperms, _vars, _type, _forEachIndex];
		} else {
			_info = format['["%1",%2,"%3","%4",%5,%6,"%7",%8]', _x#0, _count, _customName, _desc, _rankperms, _licensesperms, _type, _forEachIndex];
		}; 
		_control lbSetData [_index,_info];
	} foreach _items;

	_control ctrlAddEventHandler ["LBSelChanged","[] spawn A3PL_Stock_Man_RefreshSelection;"];

	_control = _display displayCtrl 1502;
	_control lbAdd ("STR_A3PL_Stock_NoSelection" call A3PL_Localize);

	if (_objtype isEqualTo "items") then {
		private _itemCount = createHashMap;

		{
			private _itemName = _x;
			if (isNil {_itemCount get _itemName}) then {
				_itemCount set [_itemName, 0];
			};
			_itemCount set [_itemName, (_itemCount get _itemName) + 1];
		} foreach _pItems;

		private _goggles = goggles player;
		if (!(_goggles isEqualTo "")) then {
			if (isNil {_itemCount get _goggles}) then {
				_itemCount set [_goggles, 1];
			} else {
				private _gogglesCount = (_itemCount get _goggles) + 1;
				_itemCount set [_goggles, _gogglesCount];
			};
		};

		{
			private _displayName = "";
			if (isClass (configFile >> "CfgWeapons" >> _x)) then {
				_displayName = getText (configFile >> "CfgWeapons" >> _x >> "displayName");
			} else {
				if (isClass (configFile >> "CfgGlasses" >> _x)) then {
					_displayName = getText (configFile >> "CfgGlasses" >> _x >> "displayName");
				} else {
					if (isClass (configFile >> "CfgMagazines" >> _x)) then {
						_displayName = getText (configFile >> "CfgMagazines" >> _x >> "displayName");
					} else {
						_displayName = _x;
					};
				};
			};
			if (_displayName isEqualTo "") then {
				_displayName = ("STR_Common_Unknown" call A3PL_Localize);
			};
			private _index = _control lbAdd format ["%1", _displayName];
			private _info = format["%1,%2", "aitem", _x];
			_control lbSetData [_index, _info];
			_control lbSetValue [_index, 0];
		} forEach (keys _itemCount);

		private _headgear = headgear player;
		if (!(_headgear isEqualTo "")) then {
			private _headgearName = getText (configFile >> "CfgWeapons" >> _headgear >> "displayName");
			_index = _control lbAdd format ["%1", _headgearName];
			private _info = format["%1,%2", "headgear", _headgear];
			_control lbSetData [_index, _info];
			_control lbSetValue [_index, 3];
		};

		private _uniform = uniform player;
		if (!(_uniform isEqualTo "")) then {
			private _uniformName = getText (configFile >> "CfgWeapons" >> _uniform >> "displayName");
			_index = _control lbAdd format ["%1", _uniformName];
			private _info = format["%1,%2", "uniform", _uniform];
			_control lbSetData [_index, _info];
			_control lbSetValue [_index, 1];
		};

		private _vest = vest player;
		if (!(_vest isEqualTo "")) then {
			private _vestName = getText (configFile >> "CfgWeapons" >> _vest >> "displayName");
			_index = _control lbAdd format ["%1", _vestName];
			private _info = format["%1,%2", "vest", _vest];
			_control lbSetData [_index, _info];
			_control lbSetValue [_index, 2];
		};

		private _backpack = backpack player;
		if (!(_backpack isEqualTo "")) then {
			private _backpackName = getText (configFile >> "CfgVehicles" >> _backpack >> "displayName");
			_index = _control lbAdd format ["%1", _backpackName];
			private _info = format["%1,%2", "backpack", _backpack];
			_control lbSetData [_index, _info];
			_control lbSetValue [_index, 0];
		};

		private _weaponCount = createHashMap;
		{
			private _wepName = _x;
			if (isNil {_weaponCount get _wepName}) then {
				_weaponCount set [_wepName, 0];
			};
			_weaponCount set [_wepName, (_weaponCount get _wepName) + 1];
		} foreach _pweps;

		{
			_index = _control lbAdd format ["%1", getText (configFile >> "CfgWeapons" >> _x >> "displayName")];
			private _info = format["%1,%2", "weapon", _x];
			_control lbSetData [_index, _info];
			_control lbSetValue [_index, 0];
		} forEach (keys _weaponCount);

		private _magCount = createHashMap;
		{
			private _magName = _x;
			if (isNil {_magCount get _magName}) then {
				_magCount set [_magName, 0];
			};
			_magCount set [_magName, (_magCount get _magName) + 1];
		} foreach _pmags;

		{
			_index = _control lbAdd format ["%1", getText (configFile >> "CfgMagazines" >> _x >> "displayName")];
			private _info = format["%1,%2", "magazine", _x];
			_control lbSetData [_index, _info];
			_control lbSetValue [_index, 0];
		} forEach (keys _magCount);

		{
			private _id = _x select 0;
			private _infoString = format["%1,%2","item",_id];
			private _i = _control lbAdd format ["%1",([_id,"name"] call A3PL_Config_GetItem)];
			_control lbSetData [_i,_infoString];
		} foreach _vinventory;
	};

	private _near = player nearEntities [["Thing"],20];
	for "_i" from (count _near - 1) to 0 step -1 do {
		private _obj = _near#_i;
		if (
			!isNil {_obj getVariable ["ainv", nil]} || 
			!isNil {_obj getVariable ["finv", nil]} || 
			isNil {_obj getVariable ["class", nil]}
		) then {
			_near deleteAt _i;
		};
	};
	if (_near isNotEqualTo []) then {
		{
			private _id = _x getVariable ["class",""];
			private _infoString = format["%1,%2","item",_id];
			private _i = _control lbAdd format ["%1",([_id,"name"] call A3PL_Config_GetItem)];
			_control lbSetData [_i,_infoString];
		} foreach _near;
	};

	if (_objtype isEqualTo "vehicles") then {
		private _cars = player nearEntities [["Car","Tank","Ship"],20];
		private _planes = player nearEntities [["Air","Plane"],20];
		private _vehList = [];
		{
			private _first_X = _x;
			{

				private _class = format ["%1_%2",_first_X#0,_x];
				_vehList pushBack _class;
			} foreach (_x#1);
		} forEach Config_Vehicles_Admin;
		{
			if ((!isNil {_x getVariable ["ainv",nil]}) || (!isNil {_x getVariable ["finv",nil]}) || ((isNil {_x getVariable ["class",nil]}) && !(typeOf _x IN _vehList))) then
			{
				_cars deleteAt _forEachIndex;
			};
		} foreach _cars;
		{
			private _id = _x getVariable ["class",""];
			private _owner = _x getVariable ["owner",[]];
			private _stockobj = _x getVariable ["stockobj",objNull];
			if (_id isEqualTo "") then {
				_id = typeOf _x;
			};
			if (((isNil "_id") || (_id isEqualTo "")) || _owner isEqualTo [] || _stockObj isEqualTo A3PL_STOCKOBJ) exitWith {
				_cars deleteAt _forEachIndex;
			};
			private _itemName = getText (configFile >> "CfgVehicles" >> _id >> "displayName");
			private _infoString = format["%1,%2,%3,%4","vehicle",_id,_owner#1,str _x];
			private _i = _control lbAdd format ["%1",_itemName];
			_control lbSetData [_i,_infoString];
		} foreach _cars;
		{
			if ((!isNil {_x getVariable ["ainv",nil]}) || (!isNil {_x getVariable ["finv",nil]}) || ((isNil {_x getVariable ["class",nil]}) && !(typeOf _x IN _vehList))) then
			{
				_planes deleteAt _forEachIndex;
			};
		} foreach _planes;
		{
			private _id = _x getVariable ["class",""];
			private _owner = _x getVariable ["owner",[]];
			private _stockobj = _x getVariable ["stockobj",objNull];
			if (_id isEqualTo "") then {
				_id = typeOf _x;
			};
			if (((isNil "_id") || (_id isEqualTo "")) || _owner isEqualTo [] || _stockObj isEqualTo A3PL_STOCKOBJ) exitWith {
				_cars deleteAt _forEachIndex;
			};
			private _itemName = getText (configFile >> "CfgVehicles" >> _id >> "displayName");
			private _infoString = format["%1,%2,%3,%4","plane",_id,_owner#1,str _x];
			private _i = _control lbAdd format ["%1",_itemName];
			_control lbSetData [_i,_infoString];
		} foreach _planes;
	};
}] call compile_Global;

["A3PL_Stock_Man_RefreshList",{
	params[
		["_items",[],[[]]]
	];

	A3PL_STOCKITEMS = _items;

	private _display = findDisplay 1102;
	private _control = _display displayCtrl 1500;
	lbClear _control;
	_control lbAdd ("STR_A3PL_Stock_NoSelection" call A3PL_Localize);

	{
		private _type = _x#6;
		private _index = _x#7;
		private _vars = [];
		if (A3PL_OBJTYPE isEqualTo "vehicles") then {
			_vars = _x#6;
			_type = _x#7;
			_index = _x#8;
		};
		private _itemName = "";
		switch (_type) do
		{
			case ("aitem"): { _itemName = getText (configFile >> "CfgWeapons" >> _x#0 >> "displayName"); };
			case ("item"): { _itemName = [_x#0,"name"] call A3PL_Config_GetItem; };
			case ("backpack"): { _itemName = getText (configFile >> "CfgVehicles" >> _x#0 >> "displayName"); };
			case ("uniform"): { _itemName = getText (configFile >> "CfgWeapons" >> _x#0 >> "displayName"); };
			case ("vest"): { _itemName = getText (configFile >> "CfgWeapons" >> _x#0 >> "displayName"); };
			case ("headgear"): { _itemName = getText (configFile >> "CfgWeapons" >> _x#0 >> "displayName"); };
			case ("vehicle"): { _itemName = getText (configFile >> "CfgVehicles" >> _x#0 >> "displayName"); };
			case ("plane"): { _itemName = getText (configFile >> "CfgVehicles" >> _x#0 >> "displayName"); };
			case ("weapon"): { _itemName = getText (configFile >> "CfgWeapons" >> _x#0 >> "displayName"); };
			case ("weaponPrimary"): { _itemName = getText (configFile >> "CfgWeapons" >> _x#0 >> "displayName"); };
			case ("magazine"): { _itemName = getText (configFile >> "CfgMagazines" >> _x#0 >> "displayName"); };
			case ("goggles"): { _itemName = getText (configFile >> "CfgGlasses" >> _x#0 >> "displayName"); };
			case ("waitem"): { _itemName = getText (configFile >> "CfgWeapons" >> _x#0 >> "displayName"); };
		};
		private _customName = _x#2;

		if (_customName isNotEqualTo "") then {
			_itemName = _customName;
		};

		private _replacedContent = "";
		_replacedContent = [_itemName, '?z?', '"'] call CBA_fnc_replace;
		_replacedContent = [_replacedContent, '?y?', "'"] call CBA_fnc_replace;
		_replacedContent = [_replacedContent, '?x?', "\"] call CBA_fnc_replace;

		private _count = _x#1;
		private _index = _control lbAdd format ["(%1x) %2", _count, _replacedContent];
		
		private _desc = _x#3;
		private _rankperms = _x#4;
		private _licensesperms = _x#5;
		private _info = format['["%1",%2,"%3","%4",%5,%6,"%7",%8]', _x#0, _count, _customName, _desc, _rankperms, _licensesperms, _type, _index];
		if (A3PL_OBJTYPE isNotEqualTo "items") then {
			_info = format['["%1",%2,"%3","%4",%5,%6,%7,"%8",%9]', _x#0, _count, _customName, _desc, _rankperms, _licensesperms,_vars, _type, _index];
		};
		_control lbSetData [_index,_info];
	} foreach _items;
}] call compile_Global;

["A3PL_Stock_Man_RefreshSelection",{
	private _display = findDisplay 1102;
	private _control = _display displayCtrl 1503;
	lbClear _control;

	{
		private _index = _control lbAdd _x#0;
		_control lbSetData [_index,_x#0];
	} foreach A3PL_STOCKRANKS;

	_control = _display displayCtrl 1513;
	lbClear _control;
	
	{
		private _name = [_x,0] call A3PL_Config_GetLicenseData;
		if (!isNil "_name") then {
			private _index = _control lbAdd _name;
			_control lbSetData [_index,_x];
		};
	} foreach A3PL_STOCKLICENSES;

	_control = _display displayCtrl 1500;
	private _selected = _control lbText (lbCurSel _control);

	if (_selected isNotEqualTo ("STR_A3PL_Stock_NoSelection" call A3PL_Localize)) then {
		private _obj = _control lbData (lbCurSel _control);
		_obj = call compile _obj;
		private _classname = _obj#0;
		private _customName = _obj#2;
		private _desc = _obj#3;
		private _rankperms = _obj#4;
		private _licensesperms = _obj#5;
		private _type = _obj#6;
		private _index = _obj#7;
		private _vars = [];
		private _damage = ("STR_UI_Common_No" call A3PL_Localize);
		private _gasAmount = 0;
		private _gasAmount2 = 0;
		if (A3PL_OBJTYPE isEqualTo "vehicles") then {
			_vars = _obj#6;
			_type = _obj#7;
			_index = _obj#8;

			_control = _display displayCtrl 1523;
			lbClear _control;
			
			{
				if (_x#0 isEqualTo "damage") then {
					{
						
						if (_x > 0) exitWith {
							_damage = ("STR_UI_Common_Yes" call A3PL_Localize);
						};
					} forEach _x#1;
				};
				if (_x#0 isEqualTo "gasAmount") then {_gasAmount = _x#1;};
				if (_x#0 isEqualTo "gasAmount2") then {_gasAmount2 = _x#1;};
			} forEach _vars;
			_control lbAdd format [("STR_A3PL_Stock_Vehicle" call A3PL_Localize),_classname];
			_control lbAdd format [("STR_A3PL_Stock_Damaged" call A3PL_Localize),_damage];
			{

				switch (_x#0) do {
					case ("plate"): {_control lbAdd format [("STR_A3PL_Stock_LicensePlate" call A3PL_Localize),_x#1];};
					case ("fuel"): {_control lbAdd format [("STR_A3PL_Stock_Gas" call A3PL_Localize),_x#1];};
					case ("water"): {_control lbAdd format [("STR_A3PL_Stock_Citern" call A3PL_Localize),_x#1];};
					case ("gasType"): {_control lbAdd format [("STR_A3PL_Stock_CiternContent" call A3PL_Localize),_gasAmount,_x#1];};
					case ("gasType2"): {_control lbAdd format [("STR_A3PL_Stock_CiternContent2" call A3PL_Localize),_gasAmount2,_x#1];};
				};
			} forEach _vars;

			_control = _display displayCtrl 1500;
		};

		private _itemName = "";
		switch (_type) do
		{
			case ("aitem"): { _itemName = getText (configFile >> "CfgWeapons" >> _classname >> "displayName"); };
			case ("item"): { _itemName = [_classname,"name"] call A3PL_Config_GetItem; };
			case ("backpack"): { _itemName = getText (configFile >> "CfgVehicles" >> _classname >> "displayName"); };
			case ("uniform"): { _itemName = getText (configFile >> "CfgWeapons" >> _classname >> "displayName"); };
			case ("vest"): { _itemName = getText (configFile >> "CfgWeapons" >> _classname >> "displayName"); };
			case ("headgear"): { _itemName = getText (configFile >> "CfgWeapons" >> _classname >> "displayName"); };
			case ("vehicle"): { _itemName = getText (configFile >> "CfgVehicles" >> _classname >> "displayName"); };
			case ("plane"): { _itemName = getText (configFile >> "CfgVehicles" >> _classname >> "displayName"); };
			case ("weapon"): { _itemName = getText (configFile >> "CfgWeapons" >> _classname >> "displayName"); };
			case ("weaponPrimary"): { _itemName = getText (configFile >> "CfgWeapons" >> _classname >> "displayName"); };
			case ("magazine"): { _itemName = getText (configFile >> "CfgMagazines" >> _classname >> "displayName"); };
			case ("goggles"): { _itemName = getText (configFile >> "CfgGlasses" >> _classname >> "displayName"); };
			case ("waitem"): { _itemName = getText (configFile >> "CfgWeapons" >> _classname >> "displayName"); };
		};

		{
			if (_x#0 IN _rankperms#0) then {
				lbSetColor [1503, _forEachIndex, [0,0.7,0,1]];
			};
			if (_x#0 IN _rankperms#1) then {
				lbSetColor [1503, _forEachIndex, [1,1,1,1]];
			};
			if (_x#0 IN _rankperms#2) then {
				lbSetColor [1503, _forEachIndex, [1,0,0,1]];
			};
		} forEach A3PL_STOCKRANKS;

		{
			if (_x IN _licensesperms#0) then {
				lbSetColor [1513, _forEachIndex, [0,0.7,0,1]];
			};
			if (_x IN _licensesperms#1) then {
				lbSetColor [1513, _forEachIndex, [1,1,1,1]];
			};
			if (_x IN _licensesperms#2) then {
				lbSetColor [1513, _forEachIndex, [1,0,0,1]];
			};
		} forEach A3PL_STOCKLICENSES;

		private _replacedContent = "";
		_control = _display displayCtrl 1509;
		if (_customName isNotEqualTo "") then {
			_replacedContent = [_customName, '?z?', '"'] call CBA_fnc_replace;
			_replacedContent = [_replacedContent, '?y?', "'"] call CBA_fnc_replace;
			_replacedContent = [_replacedContent, '?x?', "\"] call CBA_fnc_replace;
			
			_control ctrlSetText _replacedContent;
		} else {	
			_control ctrlSetText _itemName;
		};

		_control = _display displayCtrl 1504;
		if (_desc isNotEqualTo "") then {
			_replacedContent = [_desc, '?z?', '"'] call CBA_fnc_replace;
			_replacedContent = [_replacedContent, '?y?', "'"] call CBA_fnc_replace;
			_replacedContent = [_replacedContent, '?x?', "\"] call CBA_fnc_replace;
			
			_control ctrlSetText _replacedContent;
		} else {
			_control ctrlSetText "";
		};
	};

	if (_selected isEqualTo ("STR_A3PL_Stock_NoSelection" call A3PL_Localize)) then {
		_control = _display displayCtrl 1509;
		_control ctrlSetText _selected;

		_control = _display displayCtrl 1504;
		_control ctrlSetText "";
	};

	A3PL_LogsResponse = [];
	A3PL_Responded = false;
	if (A3PL_OBJTYPE isEqualTo "vehicles") then {
		[A3PL_STOCKOBJ,player,true] remoteExec ["Server_Stock_GetLogs",2];
	} else {
		[A3PL_STOCKOBJ,player,false] remoteExec ["Server_Stock_GetLogs",2];
	};
	
	waitUntil { A3PL_Responded };

	reverse A3PL_LogsResponse;

	_control = _display displayCtrl 1501;
	lbClear _control;
	{
		private _player = _x#1;
		private _object = _x#2;
		private _amount = _x#3;
		private _type = _x#4;
		private _time = _x#5;
		private _plate = ("STR_Common_Vehicle_Plate_Federal" call A3PL_Localize);

		if (_type IN ["vehicle","plane"]) then {
			_plate = _x#5;
			_time = _x#6;
		};
		private _text = "";
		private _itemName = "";
		private _i = 0;

		switch (_type) do
		{
			case ("aitem"): { _itemName = getText (configFile >> "CfgWeapons" >> _object >> "displayName"); };
			case ("item"): { _itemName = [_object,"name"] call A3PL_Config_GetItem; };
			case ("backpack"): { _itemName = getText (configFile >> "CfgVehicles" >> _object >> "displayName"); };
			case ("uniform"): { _itemName = getText (configFile >> "CfgWeapons" >> _object >> "displayName"); };
			case ("vest"): { _itemName = getText (configFile >> "CfgWeapons" >> _object >> "displayName"); };
			case ("headgear"): { _itemName = getText (configFile >> "CfgWeapons" >> _object >> "displayName"); };
			case ("vehicle"): { _itemName = getText (configFile >> "CfgVehicles" >> _object >> "displayName"); };
			case ("plane"): { _itemName = getText (configFile >> "CfgVehicles" >> _object >> "displayName"); };
			case ("weapon"): { _itemName = getText (configFile >> "CfgWeapons" >> _object >> "displayName"); };
			case ("weaponPrimary"): { _itemName = getText (configFile >> "CfgWeapons" >> _object >> "displayName"); };
			case ("magazine"): { _itemName = getText (configFile >> "CfgMagazines" >> _object >> "displayName"); };
			case ("goggles"): { _itemName = getText (configFile >> "CfgGlasses" >> _object >> "displayName"); };
			case ("waitem"): { _itemName = getText (configFile >> "CfgWeapons" >> _object >> "displayName"); };
		};
		
		if (_selected isEqualTo ("STR_A3PL_Stock_NoSelection" call A3PL_Localize)) then {
				if (_amount > 0) then {
					_text = format ["+%1 %2 | %3 | %4/%5/%6 %9 %7:%8", _amount, _itemName, _player, _time#2, _time#1, _time#0, _time#3, _time#4, ("STR_Common_At" call A3PL_Localize)];
					
					_i = _control lbAdd _text;
					lbSetColor [1501, _i, [0,0.7,0,1]];
				} else {
					_text = format ["%1 %2 | %3 | %4/%5/%6 %9 %7:%8", _amount, _itemName, _player, _time#2, _time#1, _time#0, _time#3, _time#4, ("STR_Common_At" call A3PL_Localize)];

					_i = _control lbAdd _text;
					lbSetColor [1501, _i, [1,0,0,1]];
				};
		} else {
			_control = _display displayCtrl 1500;
			private _obj = _control lbData (lbCurSel _control);
			_obj = call compile _obj;
			private _classname = _obj#0;
			private _vars = [];
			private _objplate = ("STR_Common_Vehicle_Plate_Federal" call A3PL_Localize);
			private _condition = (_object isEqualTo _classname);
			if (A3PL_OBJTYPE isEqualTo "vehicles") then {
				_vars = _obj#6;

				{
					if (_x#0 isEqualTo "plate") then {
						_objplate = _x#1;
					};
				} forEach _vars;
				_condition = (_object isEqualTo _classname && _objplate isEqualTo _plate);
			};
			

			_control = _display displayCtrl 1501;
			if (_condition) then {
				if (_amount > 0) then {
					_text = format ["+%1 %2 | %3 | %4/%5/%6 à %7:%8", _amount, _itemName, _player, _time#2, _time#1, _time#0, _time#3, _time#4];
					
					_i = _control lbAdd _text;
					lbSetColor [1501, _i, [0,0.7,0,1]];
				} else {
					_text = format ["%1 %2 | %3 | %4/%5/%6 à %7:%8", _amount, _itemName, _player, _time#2, _time#1, _time#0, _time#3, _time#4];

					_i = _control lbAdd _text;
					lbSetColor [1501, _i, [1,0,0,1]];
				};
			};
		};
	} foreach A3PL_LogsResponse;
}] call compile_Global;

["A3PL_Stock_Man_AddObject",{
	private _display = findDisplay 1102;
	private _control = _display displayCtrl 1502;
	if (_control lbText (lbCurSel _control) IN [("STR_A3PL_Stock_NoSelection" call A3PL_Localize),""]) exitWith {
		[("STR_A3PL_Stock_NoObjectSelected" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};

	private _obj = _control lbData (lbCurSel _control);
	private _data = _obj splitString ",";
	private _type = _data#0;
	private _classname = _data#1;
	private _plate = ("STR_Common_Vehicle_Plate_Federal" call A3PL_Localize);
	private _vars = [];
	private _vehObj = objNull;
	private _exit = false;

	if (A3PL_OBJTYPE isNotEqualTo "items") then {
		_plate = _data#2;
		if (_plate IN Garage_Default_Plate) exitWith {
			[("STR_A3PL_Stock_VehicleCantBeAddedToStock" call A3PL_Localize), Color_Red] call A3PL_Notification;
			_exit = true;
		};
		_vars pushBack ["plate",_plate];

		_vehObj = [_data#3] call A3PL_Lib_vehStringToObj;
	};

	private _ranks = [];
	{
		if ((_x#0 isEqualTo _classname) && (A3PL_OBJTYPE isEqualTo "items")) exitWith {
			[("STR_A3PL_Stock_ObjectAlreadyInStock" call A3PL_Localize), Color_Red] call A3PL_Notification;
			_exit = true;
		};
	} forEach A3PL_STOCKITEMS;

	if (_exit) exitWith {};

	if (A3PL_STOCKEDITSERVICE IN [("STR_Common_FIFR" call A3PL_Localize),("STR_Common_FISD" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) then {
		{
			_ranks pushBack _x#0;
		} forEach A3PL_STOCKRANKS;
	} else {
		_ranks = A3PL_STOCKRANKS;
	};

	if (A3PL_OBJTYPE isEqualTo "items") then {
		A3PL_STOCKITEMS pushBack [_classname, 0, "", "", [[],_ranks,[]], [[],A3PL_STOCKLICENSES,[]], _type];
		[A3PL_OBJTYPE,A3PL_STOCKITEMS,A3PL_STOCKOBJ] remoteExec ["Server_Stock_UpdateItems",2];
	} else {
		private _Path = (getObjectTextures _vehObj)#0;
		private _material = (getObjectMaterials _vehObj)#0;
		private _PathFormat = format ["%1",_Path];
		private _materialFormat = format ["%1",_material];

		private _vehItems = getItemCargo _vehObj;
		private _vehMags = getMagazineCargo _vehObj;
		private _vehBackpacks = getBackpackCargo _vehObj;
		private _vehWeapons = getWeaponCargo _vehObj;

		private _inventory = [_vehItems,_vehMags,_vehBackpacks,_vehWeapons];
		if ((count (_vehItems select 0) isEqualTo 0) && (count (_vehMags select 0) isEqualTo 0) && (count (_vehBackpacks select 0) isEqualTo 0) && (count (_vehWeapons select 0) isEqualTo 0)) then {
			_inventory = [];
		};
		_vars pushBack ["inv",_inventory];

		private _storage = _vehObj getVariable["storage",[]];
		_vars pushBack ["vinv",_storage];

		private _fuel = fuel _vehObj;
		_vars pushBack ["fuel",_fuel];

		private _damage = [];
		if(count(getAllHitPointsDamage _vehObj) isEqualTo 3) then {
			_damage = (getAllHitPointsDamage _vehObj)#2;
		};
		_vars pushBack ["damage",_damage];

		private _upgrades = ["all",(typeOf _vehObj),""] call A3PL_Config_GetGarageUpgrade;
		private _addons = [];
		{_addons pushBack ([_x select 0, _vehObj animationSourcePhase (_x select 0)]);} foreach _upgrades;
		if (count _addons isNotEqualTo 0) then {
			_vars pushBack ["addons",_addons];
		};

		if (isNil "_materialFormat") then {_materialFormat = ""};
		_PathFormat = [_Pathformat, "\", "?antislash?"] call CBA_fnc_replace;
		_materialFormat = [_materialFormat, "\", "?antislash?"] call CBA_fnc_replace;

		_vars pushBack ["color",_PathFormat];
		_vars pushBack ["material",_materialFormat];

		private _water = _vehObj getVariable ["water",0];
		if (_water > 0) then {
			_vars pushBack ["water",_water];
		};

		private _gasType = _vehObj getVariable ["gasType",("STR_Common_None" call A3PL_Localize)];
		if (_gasType isNotEqualTo ("STR_Common_None" call A3PL_Localize)) then {
			private _gasAmount = _vehObj getVariable ["gasAmount",0];
			_vars pushBack ["gasType",_gasType];
			_vars pushBack ["gasAmount",_gasAmount];
		};
		private _gasType2 = _vehObj getVariable ["gasType2",("STR_Common_None" call A3PL_Localize)];
		if (_gasType2 isNotEqualTo ("STR_Common_None" call A3PL_Localize)) then {
			private _gasAmount2 = _vehObj getVariable ["gasAmount2",0];
			_vars pushBack ["gasType2",_gasType2];
			_vars pushBack ["gasAmount2",_gasAmount2];
		};

		private _pJob = player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
		if ((_pJob IN [("STR_Common_FIFR" call A3PL_Localize),("STR_Common_FISD" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) || ((_vehObj getVariable ["owner",[]]) select 0) isEqualTo (player getVariable ["character_id",""])) then {
			[_vehObj] remoteExec ["Server_Vehicle_Sell",2];
			A3PL_STOCKITEMS pushBack [_classname, 1, "", "", [[],_ranks,[]], [[],A3PL_STOCKLICENSES,[]],_vars, _type];
			[A3PL_OBJTYPE,A3PL_STOCKITEMS,A3PL_STOCKOBJ] remoteExec ["Server_Stock_UpdateItems",2];
		} else {
			[("STR_A3PL_Stock_VehicleCantBeAddedToStock" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};
	};

	[A3PL_STOCKITEMS] call A3PL_Stock_Man_RefreshList;
	_control = _display displayCtrl 1500;
	_control lbSetCurSel 0;
	[] spawn A3PL_Stock_Man_RefreshSelection;
	[("STR_A3PL_Stock_AddedToStock" call A3PL_Localize),Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Stock_Man_RemoveObject",{
	private _display = findDisplay 1102;
	private _control = _display displayCtrl 1500;
	if (_control lbText (lbCurSel _control) IN [("STR_A3PL_Stock_NoSelection" call A3PL_Localize),""]) exitWith {
		[("STR_A3PL_Stock_NoObjectSelected" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};

	private _obj = _control lbData (lbCurSel _control);
	_obj = call compile _obj;
	private _classname = _obj#0;
	private _count = _obj#1;
	
	private _exit = false;
	if ((_count > 0) && (A3PL_OBJTYPE isEqualTo "items")) then {
		[("STR_A3PL_Stock_EmptyTheItemStockBeforeRemove" call A3PL_Localize), Color_Red] call A3PL_Notification;
		_exit = true;
	};
	if (A3PL_OBJTYPE isEqualTo "vehicles") then {
		if (_count == 0) exitWith {
			[("STR_A3PL_Stock_VehicleNeedToBeStored" call A3PL_Localize), Color_Red] call A3PL_Notification;
			_exit = true;
		};

		private _vars = _obj#6;
		private _type = _obj#7;

		private _id = ("STR_Common_Vehicle_Plate_Federal" call A3PL_Localize);
		private _color = "";
		private _material = "";
		private _inv = [];
		private _vinv = [];
		private _fuel = 0;
		private _damage = 0;
		private _addons = [];
		private _water = 0;
		private _gasType = ("STR_Common_None" call A3PL_Localize);
		private _gasAmount = 0;
		private _gasType2 = ("STR_Common_None" call A3PL_Localize);
		private _gasAmount2 = 0;

		{
			switch (_x#0) do
			{
				case ("plate"): { _id = _x#1; };
				case ("color"): { _color = _x#1; };
				case ("material"): { _material = _x#1; };
				case ("inv"): { _inv = _x#1; };
				case ("vinv"): { _vinv = _x#1; };
				case ("fuel"): { _fuel = _x#1; };
				case ("damage"): { _damage = _x#1; };
				case ("addons"): { _addons = _x#1; };
				case ("water"): { _water = _x#1; };
				case ("gasType"): { _gasType = _x#1; };
				case ("gasAmount"): { _gasAmount = _x#1; };
				case ("gasType2"): { _gasType2 = _x#1; };
				case ("gasAmount2"): { _gasAmount2 = _x#1; };
			};
		} forEach _vars;

		[player, _classname, _type, _id, _color, _material, _vinv, _inv, _fuel, _damage, 1, _addons, _water, _gasType, _gasAmount, [], 0, objNull, _gasType2, _gasAmount2] remoteExec ["Server_Stock_VehicleWithdraw",2];
	};

	if (_exit) exitWith {};
	
	A3PL_STOCKITEMS deleteAt ((lbCurSel _control) - 1);
	[A3PL_STOCKITEMS] call A3PL_Stock_Man_RefreshList;
	_control lbSetCurSel 0;
	[] spawn A3PL_Stock_Man_RefreshSelection;
	[A3PL_OBJTYPE,A3PL_STOCKITEMS,A3PL_STOCKOBJ] remoteExec ["Server_Stock_UpdateItems",2];

	[("STR_A3PL_Stock_RemovedFromStock" call A3PL_Localize),Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Stock_Man_ModifyRankOrLicense",{
	private _mode = param [0,0];

	private _display = findDisplay 1102;
	private _control = _display displayCtrl 1503;
	private _rank = "";
	private _license = "";
	private _exit = false;
	if (_mode IN [0,1,2]) then {
		_rank = _control lbText (lbCurSel _control);
		if (_control lbText (lbCurSel _control) isEqualTo "") exitWith {
			[("STR_A3PL_Stock_NoRankSelected" call A3PL_Localize), Color_Red] call A3PL_Notification;
			_exit = true;
		};
	} else {
		_control = _display displayCtrl 1513;
		_license = _control lbData (lbCurSel _control);
		if (_control lbText (lbCurSel _control) isEqualTo "") exitWith {
			[("STR_A3PL_Stock_NoLicenseSelected" call A3PL_Localize), Color_Red] call A3PL_Notification;
			_exit = true;
		};
	};

	if (_exit) exitWith {};

	_control = _display displayCtrl 1500;
	if (_control lbText (lbCurSel _control) IN [("STR_A3PL_Stock_NoSelection" call A3PL_Localize),""]) exitWith {
		[("STR_A3PL_Stock_NoObjectSelected" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	private _obj = _control lbData (lbCurSel _control);
	_obj = call compile _obj;
	private _classname = _obj#0;
	private _count = _obj#1;
	private _customName = _obj#2;
	private _desc = _obj#3;
	private _rankperms = _obj#4;
	private _licensesperms = _obj#5;
	private _type = _obj#6;
	private _vars = [];

	if (A3PL_OBJTYPE isNotEqualTo "items") then {
		_vars = _obj#6;
		_type = _obj#7;
	};
	

	switch (_mode) do {
		case 0: {
			if (_rank IN _rankperms#0) exitWith {
				[("STR_A3PL_Stock_RankAlreadyHaveThisState" call A3PL_Localize), Color_Red] call A3PL_Notification;
			};
			_rankperms#0 pushBack _rank;
			_rankperms#1 deleteAt (_rankperms#1 find _rank);
			_rankperms#2 deleteAt (_rankperms#2 find _rank);
		};
		case 1: {
			if (_rank IN _rankperms#1) exitWith {
				[("STR_A3PL_Stock_RankAlreadyHaveThisState" call A3PL_Localize), Color_Red] call A3PL_Notification;
			};
			_rankperms#0 deleteAt (_rankperms#0 find _rank);
			_rankperms#1 pushBack _rank;
			_rankperms#2 deleteAt (_rankperms#2 find _rank);
		};
		case 2: {
			if (_rank IN _rankperms#2) exitWith {
				[("STR_A3PL_Stock_RankAlreadyHaveThisState" call A3PL_Localize), Color_Red] call A3PL_Notification;
			};
			_rankperms#0 deleteAt (_rankperms#0 find _rank);
			_rankperms#1 deleteAt (_rankperms#1 find _rank);
			_rankperms#2 pushBack _rank;
		};
		case 3: {
			if (_license IN _licensesperms#0) exitWith {
				[("STR_A3PL_Stock_LicenseAlreadyHavethisState" call A3PL_Localize), Color_Red] call A3PL_Notification;
			};
			_licensesperms#0 pushBack _license;
			_licensesperms#1 deleteAt (_licensesperms#1 find _license);
			_licensesperms#2 deleteAt (_licensesperms#2 find _license);
		};
		case 4: {
			if (_license IN _licensesperms#1) exitWith {
				[("STR_A3PL_Stock_LicenseAlreadyHavethisState" call A3PL_Localize), Color_Red] call A3PL_Notification;
			};
			_licensesperms#0 deleteAt (_licensesperms#0 find _license);
			_licensesperms#1 pushBack _license;
			_licensesperms#2 deleteAt (_licensesperms#2 find _license);
		};
		case 5: {
			if (_license IN _licensesperms#2) exitWith {
				[("STR_A3PL_Stock_LicenseAlreadyHavethisState" call A3PL_Localize), Color_Red] call A3PL_Notification;
			};
			_licensesperms#0 deleteAt (_licensesperms#2 find _license);
			_licensesperms#1 deleteAt (_licensesperms#1 find _license);
			_licensesperms#2 pushBack _license;
		};
	};

	A3PL_STOCKITEMS deleteAt ((lbCurSel _control) - 1);
	if (A3PL_OBJTYPE isNotEqualTo "items") then {
		A3PL_STOCKITEMS insert [(lbCurSel _control) - 1,[[_classname,_count,_customName,_desc,_rankperms,_licensesperms,_vars,_type]]];
	} else {
		A3PL_STOCKITEMS insert [(lbCurSel _control) - 1,[[_classname,_count,_customName,_desc,_rankperms,_licensesperms,_type]]];
	};

	[A3PL_STOCKITEMS] call A3PL_Stock_Man_RefreshList;
	[] spawn A3PL_Stock_Man_RefreshSelection;
	[A3PL_OBJTYPE,A3PL_STOCKITEMS,A3PL_STOCKOBJ] remoteExec ["Server_Stock_UpdateItems",2];
}] call compile_Global;

["A3PL_Stock_Man_ModifyDescOrName",{
	private _mode = param [0,0];
	private _display = findDisplay 1102;
	private _control = _display displayCtrl 1509;
	private _name = "";
	private _description = "";
	private _exit = false;
	if (_mode isEqualTo 0) then {
		_name = ctrlText _control;
		if (count _name > 30) exitwith {
			[("STR_A3PL_Stock_30CharMax" call A3PL_Localize),Color_Red] call A3PL_Notification;
			_exit = true;
		};
	} else {
		_control = _display displayCtrl 1504;
		_description = ctrlText _control;
		if (count _description > 150) exitwith {
			[("STR_A3PL_Stock_150CharMax" call A3PL_Localize),Color_Red] call A3PL_Notification;
			_exit = true;
		};
	};

	if (_exit) exitWith {};

	_control = _display displayCtrl 1500;
	if (_control lbText (lbCurSel _control) IN [("STR_A3PL_Stock_NoSelection" call A3PL_Localize),""]) exitWith {
		[("STR_A3PL_Stock_NoObjectSelected" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	private _obj = _control lbData (lbCurSel _control);
	_obj = call compile _obj;
	private _classname = _obj#0;
	private _count = _obj#1;
	private _customName = _obj#2;
	private _desc = _obj#3;
	private _rankperms = _obj#4;
	private _licensesperms = _obj#5;
	private _type = _obj#6;
	private _vars = [];

	if (A3PL_OBJTYPE isNotEqualTo "items") then {
		_vars = _obj#6;
		_type = _obj#7;
	};

	private _replacedContent = "";

	if (_mode isEqualTo 0) then {
		_replacedContent = [_name, '"', '?z?'] call CBA_fnc_replace;
		_replacedContent = [_replacedContent, "'", '?y?'] call CBA_fnc_replace;
		_replacedContent = [_replacedContent, "\", '?x?'] call CBA_fnc_replace;
		
		_customName = _replacedContent;
		[("STR_A3PL_Stock_NameChanged" call A3PL_Localize),Color_Green] call A3PL_Notification;
	} else {
		_replacedContent = [_description, '"', '?z?'] call CBA_fnc_replace;
		_replacedContent = [_replacedContent, "'", '?y?'] call CBA_fnc_replace;
		_replacedContent = [_replacedContent, "\", '?x?'] call CBA_fnc_replace;
		
		_desc = _replacedContent;
		[("STR_A3PL_Stock_DescriptionChanged" call A3PL_Localize),Color_Green] call A3PL_Notification;
	};
	A3PL_STOCKITEMS deleteAt ((lbCurSel _control) - 1);
	if (A3PL_OBJTYPE isNotEqualTo "items") then {
		A3PL_STOCKITEMS insert [(lbCurSel _control) - 1,[[_classname,_count,_customName,_desc,_rankperms,_licensesperms,_vars,_type]]];
	} else {
		A3PL_STOCKITEMS insert [(lbCurSel _control) - 1,[[_classname,_count,_customName,_desc,_rankperms,_licensesperms,_type]]];
	};
	
	[A3PL_STOCKITEMS] call A3PL_Stock_Man_RefreshList;
	[] spawn A3PL_Stock_Man_RefreshSelection;
	[A3PL_OBJTYPE,A3PL_STOCKITEMS,A3PL_STOCKOBJ] remoteExec ["Server_Stock_UpdateItems",2];
}] call compile_Global;

// Stock
["A3PL_Stock_View_AskOpen",{
	params[["_obj",objNull, [objNull]]];
	if (_obj isEqualTo objNull) exitwith {[("STR_A3PL_Stock_ErrorNoObj" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if(player getVariable ["inventory_opened",false]) exitwith {
		[getPlayerUID player,(player getVariable ["character_id",""]),"InventoryShopCloningAttempt",[]] remoteExec ["Server_Log_New",2];
		['STR_A3PL_Stock_ReopenTheShop' call A3PL_Localize,Color_Red] call A3PL_Notification;
	};
	if (!(player_itemClass isEqualTo "")) exitwith {
		[getPlayerUID player,(player getVariable ["character_id",""]),"InventoryShopOpenWithItemAttempt",[]] remoteExec ["Server_Log_New",2];
		['STR_A3PL_Stock_RemoveThatYouHaveInYourHands' call A3PL_Localize,Color_Red] call A3PL_Notification;
	};

	[1,player,_obj] remoteExec ["Server_Stock_Info", 2];
}] call compile_Global;

["A3PL_Stock_View_OpenReceive",{
	params[
		["_type","items",["items"]],
		["_service","",[""]],
		["_items",[],[[]]],
		["_obj",objNull,[objNull]]
	];
	disableSerialization;

	if (_service isEqualTo "") exitwith {[("STR_A3PL_Stock_ErrorNoService" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_obj getVariable ["inUse",false]) exitwith {[("STR_A3PL_Stock_AlreadyInUse" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _pItems = assignedItems player + items player;
	private _pweps = weapons player;
	private _vinventory = player getVariable ["player_inventory", []];
	if ("Binocular" IN _pItems) then {_pItems = _pItems - ["Binocular"]};
    private _pmags = magazines player;
    if (currentMagazine player != "") then {_pmags pushback (currentMagazine player);};

	A3PL_OBJTYPE = _type;
	A3PL_STOCKEDITSERVICE = _service;
	A3PL_STOCKITEMS = _items;
	A3PL_STOCKOBJ = _obj;

	A3PL_STOCKOBJ setVariable ["inUse",true,true];

	private _display = 0;
	if (A3PL_OBJTYPE isNotEqualTo "items") then {
		createDialog "A3PL_StockVeh";
		_display = findDisplay 1104;
	} else {
		createDialog "A3PL_Stock";
		_display = findDisplay 1103;
	};
	
	_display displayAddEventHandler ["Unload",{A3PL_OBJTYPE = nil; A3PL_STOCKEDITSERVICE = nil; A3PL_STOCKITEMS = nil; A3PL_STOCKOBJ setVariable ["inUse",nil,true]; A3PL_STOCKOBJ = nil;}];

	_control = _display displayCtrl 1600;
	if (_items isEqualTo []) then {
		private _noI = _control lbAdd ("STR_A3PL_Stock_NoObjectAvailable" call A3PL_Localize);
		_control lbSetData [_noI, "['dildo',0,'','STR_A3PL_Stock_ComebackLater' call A3PL_Localize,[],[],'item',0]"];
		if (A3PL_OBJTYPE isNotEqualTo "items") then {
			_control lbSetData [_noI, "['dildo',0,'','STR_A3PL_Stock_ComebackLater' call A3PL_Localize,[],[],[],'item',0]"];
		};
	};

	{
		private ["_itemName", "_i"];
		private _replacedContent = "";
		private _itemClass = _x#0;
		private _itemAmount = _x#1;
		private _itemCustomName = _x#2;
		private _itemDesc = _x#3;
		private _itemRanks = _x#4;
		private _itemLicenses = _x#5;
		private _itemType = _x#6;
		private _vars = [];

		if (A3PL_OBJTYPE isNotEqualTo "items") then {
			_vars = _x#6;
			_itemType = _x#7;
		};

		_itemName = switch (_itemType) do {
			case "item": { [_itemClass,"name"] call A3PL_Config_GetItem; };
			case "aitem": { getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName"); };
			case "backpack": { getText (configFile >> "CfgVehicles" >> _itemClass >> "displayName"); };
			case "uniform": { getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName"); };
			case "vest": { getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName"); };
			case "headgear": { getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName"); };
			case "vehicle": { getText (configFile >> "CfgVehicles" >> _itemClass >> "displayName"); };
			case "plane": { getText (configFile >> "CfgVehicles" >> _itemClass >> "displayName"); };
			case "weapon": { getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName"); };
			case "weaponPrimary": { getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName"); };
			case "magazine": { getText (configFile >> "CfgMagazines" >> _itemClass >> "displayName"); };
			case "goggles": { getText (configFile >> "CfgGlasses" >> _itemClass >> "displayName"); };
			case "waitem": { getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName"); };
		};
		

		
		if (_itemCustomName isNotEqualTo "") then {
			_replacedContent = [_itemCustomName, '?z?', '"'] call CBA_fnc_replace;
			_replacedContent = [_replacedContent, '?y?', "'"] call CBA_fnc_replace;
			_replacedContent = [_replacedContent, '?x?', "\"] call CBA_fnc_replace;
			
			_itemName = format ["%1 [%2]",_replacedContent,_itemName];
		};

		private _pRank = "Recruit";
		if (A3PL_STOCKEDITSERVICE IN [("STR_Common_FIFR" call A3PL_Localize),("STR_Common_FISD" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) then {
			_pRank = [_service,"rank", (player getVariable ["character_id",""])] call A3PL_Config_GetFactionRankData;
			
		} else {
			_pRank = [[(player getVariable ["character_id",""])] call A3PL_Config_GetCompanyID, "rank", (player getVariable ["character_id",""])] call A3FL_Config_GetCompanyRankData;
		};
		
		
		if !(_service IN [("STR_Common_FIFR" call A3PL_Localize),("STR_Common_FISD" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) then {
			
		};
		
		private _pLicenses = player getVariable ["licenses",[]];
		private _access = false;

		switch (true) do {
			case (_itemRanks#0 isNotEqualTo []): {
				if ((_itemLicenses#0 isEqualTo [])) then {
					if (((_pLicenses findIf { _x IN _itemLicenses#2 }) isEqualTo -1) && (_pRank IN _itemRanks#0)) then {
						_access = true;
					};
				} else {
					if (!((_pLicenses findIf { _x IN _itemLicenses#0 }) isEqualTo -1) || (_pRank IN _itemRanks#0)) then {
						_access = true;
					};
				};
			};
			case (_itemRanks#0 isEqualTo []): {
				if ((_itemLicenses#0 isNotEqualTo [])) then {
					if (!((_pLicenses findIf { _x IN _itemLicenses#0 }) isEqualTo -1) && !(_pRank IN _itemRanks#2)) then {
						_access = true;
					};
				} else {
					if (((_pLicenses findIf { _x IN _itemLicenses#2 }) isEqualTo -1) && !(_pRank IN _itemRanks#2)) then {
						_access = true;
					};
				};
			};
		};


		if (_access) then {
			if ([_itemClass, "canPickup"] call A3PL_Config_GetItem) then {
				_amount = [_itemClass] call A3PL_Inventory_Return;
				if (_amount > 0) then {
					_i = _control lbAdd format ["%1 (Inv: %2x)", _itemName, _amount];
				} else {
					_i = _control lbAdd _itemName;
				};
			} else {
				if (_itemType in ["vehicle", "plane"]) then {
					_objects = player nearEntities [[_itemClass], 10];
					_selplate = "";
					_fittingobjects = [];
					{
						if (_x#0 isEqualTo "plate") then {
							_selplate = _x#1;
						};
					} forEach _vars;
					{
						_plate = _x getVariable ["owner",[]];
						if (_plate isNotEqualTo []) then {
							if ((_plate select 1) isEqualTo _selplate) then {
								_fittingobjects pushBack _x;
							};
						};
					} forEach _objects;
					if ((count _fittingobjects) > 0) then {
						_i = _control lbAdd format [("STR_A3PL_Stock_Near" call A3PL_Localize), _itemName, (count _fittingobjects)];
					} else {
						_i = _control lbAdd _itemName;
					};
				} else {
					_i = _control lbAdd _itemName;
				};
			};
			
			private _info = format['["%1",%2,"%3","%4",%5,%6,"%7",%8]', _itemClass, _itemAmount, _itemCustomName, _itemDesc, _itemRanks, _itemLicenses, _itemType, _forEachIndex];
			if (A3PL_OBJTYPE isNotEqualTo "items") then {
				_info = format['["%1",%2,"%3","%4",%5,%6,%7,"%8",%9]', _itemClass, _itemAmount, _itemCustomName, _itemDesc, _itemRanks, _itemLicenses, _vars, _itemType, _forEachIndex];
			};
			_control lbSetData [_i, _info];
		};
	} foreach _items;

	if (lbSize _control isEqualTo 0) then {
		private _noI = _control lbAdd ("STR_A3PL_Stock_NoObjectAvailable" call A3PL_Localize);
		_control lbSetData [_noI, "['dildo',0,'','STR_A3PL_Stock_ComebackLater' call A3PL_Localize,[],[],'item',0]"];
	};

	_control = _display displayCtrl 1602;
	_control ctrlAddEventHandler ["ButtonDown",format ["['%1'] call A3PL_Stock_View_Withdraw;",A3PL_STOCKOBJ]];
	_control = _display displayCtrl 1603;
	_control ctrlAddEventHandler ["ButtonDown",format ["['%1'] call A3PL_Stock_View_Deposit;",A3PL_STOCKOBJ]];
	_control = _display displayCtrl 1600;
	_control ctrlAddEventHandler ["LBSelChanged",format ["['%1'] spawn A3PL_Stock_View_ItemSwitch;",A3PL_STOCKOBJ]];

	A3PL_SHOP_CAMERA = "camera" camCreate (ASLToAGL eyePos A3PL_STOCKOBJ);
	A3PL_SHOP_CAMERA camSetRelPos [0,0,0];
	A3PL_SHOP_CAMERA cameraEffect ["internal", "BACK"];
	A3PL_SHOP_CAMERA camCommit 0;
	showCinemaBorder false;

	_control = _display displayCtrl 1600;
	_control lbSetCurSel 0;

	[A3PL_SHOP_CAMERA] spawn
	{
		private _display = 0;
		disableSerialization;
		if (A3PL_OBJTYPE isNotEqualTo "items") then {
			_display = findDisplay 1104;
		} else {
			_display = findDisplay 1103;
		};
		waitUntil { isNull _display };
		deleteVehicle A3PL_SHOP_ITEMPREVIEW;
		{deleteVehicle _x;} foreach _this;
		A3PL_SHOP_ITEMPREVIEW = nil;
		player cameraEffect ["terminate", "BACK"];
	};

	_control = _display displayCtrl 1601;
	_control sliderSetRange [-180, 180];
	_control sliderSetPosition 0;
	_control ctrlAddEventHandler ["SliderPosChanged",
	{
		A3PL_SHOP_ITEMPREVIEW setDir (param [1,180]);
	}];
}] call compile_Global;

["A3PL_Stock_View_Withdraw",{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};

	private _display = 0;
	if (A3PL_OBJTYPE isNotEqualTo "items") then {
		_display = findDisplay 1104;
	} else {
		_display = findDisplay 1103;
	};
	

	private _control = _display displayCtrl 1600;
	private _selectedIndex = lbCurSel _control;
	if (_control lbText (_selectedIndex) IN [("STR_A3PL_Stock_NoObjectAvailable" call A3PL_Localize),""]) exitWith {
		[("STR_A3PL_Stock_NoObjectSelected" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	private _obj = _control lbData (_selectedIndex);
	_obj = call compile _obj;
	private _classname = _obj#0;
	private _count = _obj#1;
	private _customName = _obj#2;
	private _desc = _obj#3;
	private _rankperms = _obj#4;
	private _licensesperms = _obj#5;
	private _type = _obj#6;
	private _index = _obj#7;
	private _vars = [];

	private _id = ("STR_Common_Vehicle_Plate_Federal" call A3PL_Localize);
	private _color = "";
	private _material = "";
	private _inv = [];
	private _vinv = [];
	private _fuel = 0;
	private _damage = 0;
	private _addons = [];
	private _water = 0;
	private _gasType = ("STR_Common_None" call A3PL_Localize);
	private _gasAmount = 0;
	private _gasType2 = ("STR_Common_None" call A3PL_Localize);
	private _gasAmount2 = 0;
	private _finalColor = "";
	private _pos = [0,0,0.5];
	private _dir = 0;
	private _exit = false;

	private _stockobj = A3PL_STOCKOBJ;

	if (A3PL_OBJTYPE isNotEqualTo "items") then {
		_vars = _obj#6;
		_type = _obj#7;
		_index = _obj#8;

		{
			switch (_x#0) do
			{
				case ("plate"): { _id = _x#1; };
				case ("color"): { _color = _x#1; };
				case ("material"): { _material = _x#1; };
				case ("inv"): { _inv = _x#1; };
				case ("vinv"): { _vinv = _x#1; };
				case ("fuel"): { _fuel = _x#1; };
				case ("damage"): { _damage = _x#1; };
				case ("addons"): { _addons = _x#1; };
				case ("water"): { _water = _x#1; };
				case ("gasType"): { _gasType = _x#1; };
				case ("gasAmount"): { _gasAmount = _x#1; };
				case ("gasType2"): { _gasType2 = _x#1; };
				case ("gasAmount2"): { _gasAmount2 = _x#1; };
			};
		} forEach _vars;
	};


	if (isNil "_material") then {_material = ""};

	private _amount = 1;
	if (_type IN ["item","magazine"]) then
	{
		_control = _display displayCtrl 1604;
		_amount = floor(parseNumber (ctrlText _control));
	};
	if (_amount < 1) exitwith {[("STR_A3PL_Stock_EnterValidAmount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_amount > _count) exitwith {[("STR_A3PL_Stock_NoEnoughStock" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_count = _count - _amount;

	_control = _display displayCtrl 1600;
	A3PL_STOCKITEMS deleteAt (_index);
	if (A3PL_OBJTYPE isNotEqualTo "items") then {
		_pos = getPos A3PL_STOCKOBJ;
		_dir = getDir A3PL_STOCKOBJ;

		if (A3PL_STOCKEDITSERVICE IN [("STR_Common_FIFR" call A3PL_Localize),("STR_Common_FISD" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) then {
			_pos = [
				(_pos select 0) + (13 * sin _dir), 
				(_pos select 1) + (13 * cos _dir),
				0
			];
		} else {
			_pos = [
				(_pos select 0) + (7.5 * sin _dir), 
				(_pos select 1) + (7.5 * cos _dir),
				0
			];
		};

		private _posBlocked = (nearestObjects[_pos,["Car","Ship","Air","Tank"],5]) isNotEqualTo [];
		if(_posBlocked) exitWith {
			[("STR_A3PL_Stock_SomethingBlockApparitionPoint" call A3PL_Localize),Color_Red] call A3PL_Notification; _exit = true;
		};

		_control lbSetData [_selectedIndex, format ['["%1",%2,"%3","%4",%5,%6,%7,"%8",%9]', _classname, _count, _customName, _desc, _rankperms, _licensesperms, _vars, _type, _index]];
		A3PL_STOCKITEMS insert [_index,[[_classname,_count,_customName,_desc,_rankperms,_licensesperms,_vars,_type]]];
	} else {
		_control lbSetData [_selectedIndex, format ['["%1",%2,"%3","%4",%5,%6,"%7",%8]', _classname, _count, _customName, _desc, _rankperms, _licensesperms, _type, _index]];
		A3PL_STOCKITEMS insert [_index,[[_classname,_count,_customName,_desc,_rankperms,_licensesperms,_type]]];
	};

	if (_exit) exitWith {};

	private _itemName = ("STR_Common_Unknown" call A3PL_Localize);
	private _canTake = true;

	private _weaponHolder = createVehicle ["GroundWeaponHolder", getposATL player, [], 0, "CAN_COLLIDE"];

	switch (_type) do
	{
		case "aitem": {
            _itemName = getText (configFile >> "CfgWeapons" >> _classname >> "displayName");
			for "_i" from 1 to _amount do {player addItem _classname;};
		};
		case "waitem": {
            _itemName = getText (configFile >> "CfgWeapons" >> _classname >> "displayName");
			for "_i" from 1 to _amount do {player addItem _classname;};
		};
		case ("item"):
		{
			if ([_classname,"canPickup"] call A3PL_Config_GetItem) then
			{
				if((([[_classname,_amount]] call A3PL_Inventory_TotalWeight) <= Player_MaxWeight) && ([_classname, _amount] call A3PL_InventoryNew_CanAddItem)) then {
					[_classname,_amount] call A3PL_Inventory_Add;
				} else {
					_canTake = false;
				};
			} else {
				private _veh = createVehicle [([_classname,"class"] call A3PL_Config_GetItem), getposATL player, [], 0, "CAN_COLLIDE"];
				if (!([_classname,"simulation"] call A3PL_Config_GetItem)) then	{[_veh] remoteExec ["Server_Vehicle_EnableSimulation",2];};
				_veh setVariable ["class",_classname,true];
				_veh setVariable ["owner",(player getVariable ["character_id",""]),true];
				_veh setVariable ["cid",[(player getVariable ["character_id",""])] call A3PL_Config_GetCompanyID,true];
				private _pJob = player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
				if (_pJob IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) then {
					_veh setVariable ["job",_pJob,true];
				};
				[_veh,player] remoteExec ["A3PL_Lib_ChangeLocality", 2];
			};
			_itemName = [_classname,"name"] call A3PL_Config_GetItem;
		};
		case ("backpack"):
		{
			player addBackPack _classname;
			_itemName = getText (configFile >> "CfgVehicles" >> _classname >> "displayName");
		};
		case ("uniform"): 
		{
			private _itemInUniform = uniformItems player;
			private _weaponItems = weaponsItems (uniformContainer player);
			{
				private _classname = _x#0;
				_itemInUniform = _itemInUniform - [_classname];
			} forEach _weaponItems;

			player addUniform _classname;
			if (_itemInUniform isNotEqualTo []) then
			{
				private _weaponHolder = createVehicle ["GroundWeaponHolder", getposATL player, [], 0, "CAN_COLLIDE"];
				{
					if (!(player canAddItemToUniform _x)) then {
						_weaponHolder addItemCargo [_x,1];
						continue;
					};

					player addItemToUniform _x;
				} foreach _itemInUniform;

				{
					(uniformContainer player) addWeaponWithAttachmentsCargoGlobal [_x, 1];
				}forEach _weaponItems;
			};

			_itemName = getText (configFile >> "CfgWeapons" >> _classname >> "displayName");
		};
		case ("vest"): 
		{
			private _vestItems = vestItems player;
			private _weaponItems = weaponsItems (vestContainer player);
			{
				private _classname = _x#0;
				_vestItems = _vestItems - [_classname];
			} forEach _weaponItems;

			player addVest _classname;

			if (_vestItems isNotEqualTo []) then
			{
				private _weaponHolder = createVehicle ["GroundWeaponHolder", getposATL player, [], 0, "CAN_COLLIDE"];
				{
					if (! (player canAddItemToVest _x)) then {
						_weaponHolder addItemCargo [_x,1];
						continue;
					};

					player addItemToVest _x;
				} foreach _vestItems;

				{
					(vestContainer player) addWeaponWithAttachmentsCargoGlobal [_x, 1];
				}forEach _weaponItems;
			};
			
			_itemName = getText (configFile >> "CfgWeapons" >> _classname >> "displayName");
		};
		case ("headgear"): 
		{
			player addHeadgear _classname;

			_itemName = getText (configFile >> "CfgWeapons" >> _classname >> "displayName");
		};
		case ("vehicle"): 
		{
			[player, _classname, _type, _id, _color, _material, _vinv, _inv, _fuel, _damage, 0, _addons, _water, _gasType, _gasAmount, _pos, _dir, _stockobj, _gasType2, _gasAmount2] remoteExec ["Server_Stock_VehicleWithdraw",2];
			
			_itemName = getText (configFile >> "CfgVehicles" >> _classname >> "displayName");
		};
		case ("plane"): 
		{
			[player, _classname, _type, _id, _color, _material, _vinv, _inv, _fuel, _damage, 0, _addons, 0, ("STR_Common_None" call A3PL_Localize), 0, _pos, _dir, _stockobj] remoteExec ["Server_Stock_VehicleWithdraw",2];
			
			_itemName = getText (configFile >> "CfgVehicles" >> _classname >> "displayName");
		};
		case "weapon": {
			_itemName = getText (configFile >> "CfgWeapons" >> _classname >> "displayName");
            (createVehicle ["GroundWeaponHolder", getposATL player, [], 0, "CAN_COLLIDE"]) addWeaponCargoGlobal [_classname,_amount];
		};
		case ("magazine"): 
		{
			player addMagazines [_classname,_amount];
			
			_itemName = getText (configFile >> "CfgMagazines" >> _classname >> "displayName");
		};
		case ("goggles"): 
		{
			player addGoggles _classname;
			
			_itemName = getText (configFile >> "CfgGlasses" >> _classname >> "displayName");
		};
	};
	if(!_canTake) exitWith {[("STR_Common_NotEnoughSpace" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	[A3PL_OBJTYPE,A3PL_STOCKITEMS,A3PL_STOCKOBJ] remoteExec ["Server_Stock_UpdateItems",2];

	if (_customName isNotEqualTo "") then {
		private _replacedContent = "";
		_replacedContent = [_customName, '?z?', '"'] call CBA_fnc_replace;
		_replacedContent = [_replacedContent, '?y?', "'"] call CBA_fnc_replace;
		_replacedContent = [_replacedContent, '?x?', "\"] call CBA_fnc_replace;
		
		[format [("STR_A3PL_Stock_YouRemovedFromStock" call A3PL_Localize),_amount,_replacedContent,_itemName],Color_Green] call A3PL_Notification;
	} else {
		[format [("STR_A3PL_Stock_YouRemovedFromStock2" call A3PL_Localize),_amount,_itemName],Color_Green] call A3PL_Notification;
	};

	if (A3PL_OBJTYPE isNotEqualTo "items") then {
		[A3PL_STOCKOBJ, player getVariable ["name","John Doe"],_classname,format["-%1",_amount],_type,_id] remoteExec ["Server_Stock_InsertLog",2];
		[getPlayerUID player,(player getVariable ["character_id",""]),"Stock_ItemWithdrawn",[format ["Stock: %1 | Item: %2 | Plate: %3 | Amount: %4",A3PL_STOCKOBJ,_itemName,_id,_amount]]] remoteExec ["Server_Log_New",2];
	} else {
		[A3PL_STOCKOBJ, player getVariable ["name","John Doe"],_classname,format["-%1",_amount],_type] remoteExec ["Server_Stock_InsertLog",2];
		[getPlayerUID player,(player getVariable ["character_id",""]),"Stock_ItemWithdrawn",[format ["Stock: %1 | Item: %2 | Amount: %3",A3PL_STOCKOBJ,_itemName,_amount]]] remoteExec ["Server_Log_New",2];
	};
	[A3PL_STOCKOBJ] spawn A3PL_Stock_View_ItemSwitch;
}] call compile_Global;

["A3PL_Stock_View_Deposit",{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};

	private _display = 0;
	if (A3PL_OBJTYPE isNotEqualTo "items") then {
		_display = findDisplay 1104;
	} else {
		_display = findDisplay 1103;
	};
	private _control = _display displayCtrl 1600;
	private _selectedIndex = lbCurSel _control;
	if (_control lbText (_selectedIndex) IN [("STR_A3PL_Stock_NoObjectAvailable" call A3PL_Localize),""]) exitWith {
		[("STR_A3PL_Stock_NoObjectAvailable" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	private _obj = _control lbData (_selectedIndex);
	_obj = call compile _obj;
	private _classname = _obj#0;
	private _count = _obj#1;
	private _customName = _obj#2;
	private _desc = _obj#3;
	private _rankperms = _obj#4;
	private _licensesperms = _obj#5;
	private _type = _obj#6;
	private _index = _obj#7;
	private _vars = [];

	private _id = ("STR_Common_Vehicle_Plate_Federal" call A3PL_Localize);
	private _color = "";
	private _material = "";
	private _inv = [];
	private _vinv = [];
	private _fuel = 0;
	private _damage = [];
	private _addons = [];
	private _water = 0;
	private _gasType = ("STR_Common_None" call A3PL_Localize);
	private _gasAmount = 0;
	private _gasType2 = ("STR_Common_None" call A3PL_Localize);
	private _gasAmount2 = 0;

	if (A3PL_OBJTYPE isNotEqualTo "items") then {
		_vars = _obj#6;
		_type = _obj#7;
		_index = _obj#8;

		{
			switch (_x#0) do
			{
				case ("plate"): { _id = _x#1; };
				case ("color"): { _color = _x#1; };
				case ("material"): { _material = _x#1; };
				case ("inv"): { _inv = _x#1; };
				case ("vinv"): { _vinv = _x#1; };
				case ("fuel"): { _fuel = _x#1; };
				case ("damage"): { _damage = _x#1; };
				case ("addons"): { _addons = _x#1; };
				case ("water"): { _water = _x#1; };
				case ("gasType"): { _gasType = _x#1; };
				case ("gasAmount"): { _gasAmount = _x#1; };
				case ("gasType2"): { _gasType2 = _x#1; };
				case ("gasAmount2"): { _gasAmount2 = _x#1; };
			};
		} forEach _vars;
	};

	private _pJob = player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];

	private _amount = 1;
	if (_type IN ["item","magazine"]) then
	{
		_control = _display displayCtrl 1604;
		_amount = floor(parseNumber (ctrlText _control));
	};
	if (_amount < 1) exitwith {[("STR_A3PL_Stock_EnterValidAmount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_type isEqualTo "item" && {!([_classname,"canPickup"] call A3PL_Config_GetItem)}) then {_amount = 1;};
	if ((A3PL_OBJTYPE isNotEqualTo "items") && ((_amount + _count) > 1)) exitWith {[("STR_A3PL_Stock_CarStockIsFull" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _itemName = ("STR_Common_Unknown" call A3PL_Localize);
	private _has = false;
	private _found = false;

	switch (_type) do {
		case ("aitem"): {
			if (_classname IN (player weaponAccessories primaryWeapon player)) then {
				_itemName = getText (configFile >> "CfgWeapons" >> _classname >> "displayName");
				player removePrimaryWeaponItem _classname;
				_has = true;
				_found = true;
			};
			if (_classname IN (handgunItems player) && !_found) then {
				_itemName = getText (configFile >> "CfgWeapons" >> _classname >> "displayName");
				player removeHandgunItem _classname;
				_has = true;
				_found = true;
			};
			if (_classname IN (assignedItems player) && !_found) then {
				_itemName = getText (configFile >> "CfgWeapons" >> _classname >> "displayName");
				player unassignItem _classname;
				player removeItem _classname;
				_has = true;
				_found = true;
			};
			if (_classname IN (items player) && !_found) then {
				_itemName = getText (configFile >> "CfgWeapons" >> _classname >> "displayName");
				player removeItem _classname;
				_has = true;
				_found = true;
			};
		};
		case ("item"): {
			if ([_classname,_amount] call A3PL_Inventory_Has) then {
				[_classname,-(_amount)] call A3PL_Inventory_Add;
				_has = true;
			} else {
				if (!([_classname,"canPickup"] call A3PL_Config_GetItem)) then {
					{
						if ((_x getVariable "class") isEqualTo _classname) exitwith
						{
							deleteVehicle _x;
							_has = true;
						};
					} foreach (player nearEntities [[([_classname,"class"] call A3PL_Config_GetItem)],20]);
				};
			};
			_itemName = [_classname,"name"] call A3PL_Config_GetItem;
		};
		case "uniform": {
            _itemName = getText (configFile >> "CfgWeapons" >> _classname >> "displayName");
			if ((uniform player) isEqualTo _classname) then {
				removeUniform player;
				_has = true;
			};
		};
		case "vest": {
			_itemName = getText (configFile >> "CfgWeapons" >> _classname >> "displayName");
            if ((vest player) isEqualTo _classname) then {
				removeVest player;
				_has = true;
			};
		};
		case "headgear": {
			_itemName = getText (configFile >> "CfgWeapons" >> _classname >> "displayName");
            if ((headgear player) isEqualTo _classname) then {
				removeHeadgear player;
				_has = true;
			};
		};
		case "backpack": {
			_itemName = getText (configFile >> "CfgVehicles" >> _classname >> "displayName");
            if ((backpack player) isEqualTo _classname) then {
				removeBackpackGlobal player;
				_has = true;
			};
		};
		case "goggles": {
			_itemName = getText (configFile >> "CfgGlasses" >> _classname >> "displayName");
            if ((goggles player) isEqualTo _classname) then {
				removeGoggles player;
				_has = true;
			};
		};
		case ("vehicle"): {
			private _vehicles = player nearEntities [["Car","Tank","Air","Plane","Ship"],20];
			if ((count _vehicles) < 1) exitwith {[("STR_A3PL_Stock_NoCarDetected" call A3PL_Localize),Color_Red] call A3PL_Notification;};

			private _fittingobjects = [];
			{
				_vehplate = _x getVariable ["owner",[]];
				if (_vehplate isNotEqualTo []) then {
					if ((_vehplate select 1) isEqualTo _id) then {
						_fittingobjects pushBack _x;
					};
				};
			} forEach _vehicles;
			
			private _vehicle = objNull;
			{
				if (((_pJob IN [("STR_Common_FIFR" call A3PL_Localize),("STR_Common_FISD" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) || ((_x getVariable ["owner",[]]) select 0) isEqualTo (player getVariable ["character_id",""])) && (typeOf _x) isEqualTo _classname) exitwith {
					_vehicle = _x;
				};
			} foreach _fittingobjects;
			if (isNull _vehicle) exitwith {[("STR_A3PL_Stock_OnlyOwnerCanAddToStock" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			
			_vars = [["plate",_id]];
		
			_Path = (getObjectTextures _vehicle)#0;
			_material = (getObjectMaterials _vehicle)#0;
			_PathFormat = format ["%1",_Path];
			_materialFormat = format ["%1",_material];

			if (isNil "_materialFormat") then {_materialFormat = ""};
			_PathFormat = [_Pathformat, "\", "?antislash?"] call CBA_fnc_replace;
			_materialFormat = [_materialFormat, "\", "?antislash?"] call CBA_fnc_replace;

			_vars pushBack ["color",_PathFormat];
			_vars pushBack ["material",_materialFormat];

			_vehItems = getItemCargo _vehicle;
			_vehMags = getMagazineCargo _vehicle;
			_vehBackpacks = getBackpackCargo _vehicle;
			_vehWeapons = getWeaponCargo _vehicle;

			_inv = [_vehItems,_vehMags,_vehBackpacks,_vehWeapons];
			if ((count (_vehItems select 0) isEqualTo 0) && (count (_vehMags select 0) isEqualTo 0) && (count (_vehBackpacks select 0) isEqualTo 0) && (count (_vehWeapons select 0) isEqualTo 0)) then {
				_inv = [];
			};
			_vars pushBack ["inv",_inv];

			_vinv = _vehicle getVariable["storage",[]];
			_vars pushBack ["vinv",_vinv];

			_fuel = fuel _vehicle;
			_vars pushBack ["fuel",_fuel];

			_damage = [];
			if(count(getAllHitPointsDamage _vehicle) isEqualTo 3) then {
				_damage = (getAllHitPointsDamage _vehicle)#2;
			};
			_vars pushBack ["damage",_damage];

			_upgrades = ["all",(typeOf _vehicle),""] call A3PL_Config_GetGarageUpgrade;
			_addons = [];
			{_addons pushBack ([_x select 0, _vehicle animationSourcePhase (_x select 0)]);} foreach _upgrades;
			if (count _addons isNotEqualTo 0) then {
				_vars pushBack ["addons",_addons];
			};

			_water = _vehicle getVariable ["water",0];
			if (_water > 0) then {
				_vars pushBack ["water",_water];
			};

			_gasType = _vehicle getVariable ["gasType",("STR_Common_None" call A3PL_Localize)];
			if (_gasType isNotEqualTo ("STR_Common_None" call A3PL_Localize)) then {
				_gasAmount = _vehicle getVariable ["gasAmount",0];
				_vars pushBack ["gasType",_gasType];
				_vars pushBack ["gasAmount",_gasAmount];
			};
			private _gasType2 = _vehicle getVariable ["gasType2",("STR_Common_None" call A3PL_Localize)];
			if (_gasType2 isNotEqualTo ("STR_Common_None" call A3PL_Localize)) then {
				private _gasAmount2 = _vehicle getVariable ["gasAmount2",0];
				_vars pushBack ["gasType2",_gasType2];
				_vars pushBack ["gasAmount2",_gasAmount2];
			};

			[_vehicle] remoteExec ["Server_Vehicle_Sell",2];

			_itemName = getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "displayName");
			_has = true;
		};
		case ("plane"): {
			private _vehicles = player nearEntities [["Car","Tank","Air","Plane","Ship"],20];
			if ((count _vehicles) < 1) exitwith {[("STR_A3PL_Stock_NoCarDetected" call A3PL_Localize),Color_Red] call A3PL_Notification;};

			private _fittingobjects = [];
			{
				_vehplate = _x getVariable ["owner",[]];
				if (_vehplate isNotEqualTo []) then {
					if ((_vehplate select 1) isEqualTo _id) then {
						_fittingobjects pushBack _x;
					};
				};
			} forEach _vehicles;
			
			private _vehicle = objNull;
			{
				if (((_pJob IN [("STR_Common_FIFR" call A3PL_Localize),("STR_Common_FISD" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) || ((_x getVariable ["owner",[]]) select 0) isEqualTo (player getVariable ["character_id",""])) && (typeOf _x) isEqualTo _classname) exitwith {
					_vehicle = _x;
				};
			} foreach _fittingobjects;
			if (isNull _vehicle) exitwith {[("STR_A3PL_Stock_OnlyOwnerCanAddToStock" call A3PL_Localize),Color_Red] call A3PL_Notification;};

			_vars = [["plate",_id]];
		
			_Path = (getObjectTextures _vehicle)#0;
			_material = (getObjectMaterials _vehicle)#0;
			_PathFormat = format ["%1",_Path];
			_materialFormat = format ["%1",_material];

			if (isNil "_materialFormat") then {_materialFormat = ""};
			_PathFormat = [_Pathformat, "\", "?antislash?"] call CBA_fnc_replace;
			_materialFormat = [_materialFormat, "\", "?antislash?"] call CBA_fnc_replace;

			_vars pushBack ["color",_PathFormat];
			_vars pushBack ["material",_materialFormat];

			_vehItems = getItemCargo _vehicle;
			_vehMags = getMagazineCargo _vehicle;
			_vehBackpacks = getBackpackCargo _vehicle;
			_vehWeapons = getWeaponCargo _vehicle;

			_inv = [_vehItems,_vehMags,_vehBackpacks,_vehWeapons];
			if ((count (_vehItems select 0) isEqualTo 0) && (count (_vehMags select 0) isEqualTo 0) && (count (_vehBackpacks select 0) isEqualTo 0) && (count (_vehWeapons select 0) isEqualTo 0)) then {
				_inv = [];
			};
			_vars pushBack ["inv",_inv];

			_vinv = _vehicle getVariable["storage",[]];
			_vars pushBack ["vinv",_vinv];

			_fuel = fuel _vehicle;
			_vars pushBack ["fuel",_fuel];

			_damage = [];
			if(count(getAllHitPointsDamage _vehicle) isEqualTo 3) then {
				_damage = (getAllHitPointsDamage _vehicle)#2;
			};
			_vars pushBack ["damage",_damage];

			[_vehicle] remoteExec ["Server_Vehicle_Sell",2];

			_itemName = getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "displayName");
			_has = true;
		};
		case "weapon": {
			_itemName = getText (configFile >> "CfgWeapons" >> _classname >> "displayName");
            _accs = ["","",""];
			{
				if (_x isEqualTo _classname) exitWith {
                    if (primaryWeapon player isEqualTo _classname) then {
                        if (primaryWeaponMagazine player isNotEqualTo []) then {player addMagazine (primaryWeaponMagazine player)#0;};
                    } else {
                        if (handgunMagazine player isNotEqualTo []) then {player addMagazine (handgunMagazine player)#0;};
                    };
					_accs = player weaponAccessories _classname;
                    {
                        if (_x isNotEqualTo "") then {player addItem _x}
                    } forEach _accs;
                    player removeWeaponGlobal _x;
                    _has = true;
				};
			} forEach ([handgunWeapon player] + [primaryWeapon player]);
            if (_has) exitWith {};
			{
				if (_x isEqualTo _classname) exitWith {
					_accs = [_classname] call A3PL_Lib_GetWeaponAccsCargo;
                    {
                        if (_x isNotEqualTo "") then {player addItem _x}
                    } forEach _accs;
                    player removeItemFromUniform _x;
                    _has = true;
				};
			} forEach uniformItems player;
             if (_has) exitWith {};
			{
				if (_x isEqualTo _classname) exitWith {
					_accs = [_classname] call A3PL_Lib_GetWeaponAccsCargo;
                    {
                        if (_x isNotEqualTo "") then {player addItem _x}
                    } forEach _accs;
                    player removeItemFromVest _x;
                    _has = true;
				};
			} forEach vestItems player;
             if (_has) exitWith {};
			{
				if (_x isEqualTo _classname) exitWith {
					_accs = [_classname] call A3PL_Lib_GetWeaponAccsCargo;
                    {
                        if (_x isNotEqualTo "") then {player addItem _x}
                    } forEach _accs;
                    player removeItemFromBackpack _x;
                    _has = true;
				};
			} forEach backpackItems player;
		};
		case ("magazine"): {
			private _MagCount = {_x isEqualTo _classname} count magazines player;
			if(_MagCount >= _amount) then {
				_has = true;
				for "_i" from 0 to _amount do {player removeMagazine _classname;};
			};
			_itemName = getText (configFile >> "CfgMagazines" >> _classname >> "displayName");
		};
	};
	if (!_has) exitwith {[("STR_A3PL_Stock_YouDoNotHaveThisObjectToAdd" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_count = _count + _amount;

	_control = _display displayCtrl 1600;
	A3PL_STOCKITEMS deleteAt (_index);

	if (A3PL_OBJTYPE isNotEqualTo "items") then {
		_control lbSetData [_selectedIndex, format ['["%1",%2,"%3","%4",%5,%6,%7,"%8",%9]', _classname, _count, _customName, _desc, _rankperms, _licensesperms, _vars, _type, _index]];
		A3PL_STOCKITEMS insert [_index,[[_classname,_count,_customName,_desc,_rankperms,_licensesperms,_vars,_type]]];
	} else {
		_control lbSetData [_selectedIndex, format ['["%1",%2,"%3","%4",%5,%6,"%7",%8]', _classname, _count, _customName, _desc, _rankperms, _licensesperms, _type, _index]];
		A3PL_STOCKITEMS insert [_index,[[_classname,_count,_customName,_desc,_rankperms,_licensesperms,_type]]];
	};
	
	[A3PL_OBJTYPE,A3PL_STOCKITEMS,A3PL_STOCKOBJ] remoteExec ["Server_Stock_UpdateItems",2];

	if (_customName isNotEqualTo "") then {
		private _replacedContent = "";
		_replacedContent = [_customName, '?z?', '"'] call CBA_fnc_replace;
		_replacedContent = [_replacedContent, '?y?', "'"] call CBA_fnc_replace;
		_replacedContent = [_replacedContent, '?x?', "\"] call CBA_fnc_replace;
		[format [("STR_A3PL_Stock_YouDeposited" call A3PL_Localize),_amount,_replacedContent,_itemName],Color_Green] call A3PL_Notification;
	} else {
		[format [("STR_A3PL_Stock_YouDeposited2" call A3PL_Localize),_amount,_itemName],Color_Green] call A3PL_Notification;
	};

	if (A3PL_OBJTYPE isNotEqualTo "items") then {
		[A3PL_STOCKOBJ, player getVariable ["name","John Doe"],_classname,format["+%1",_amount],_type,_id] remoteExec ["Server_Stock_InsertLog",2];
		[getPlayerUID player,(player getVariable ["character_id",""]),"Stock_ItemDeposited",[format ["Stock: %1 | Item: %2 | Plate: %3 | Amount: %4",A3PL_STOCKOBJ,_itemName,_id,_amount]]] remoteExec ["Server_Log_New",2];
	} else {
		[A3PL_STOCKOBJ, player getVariable ["name","John Doe"],_classname,format["+%1",_amount],_type] remoteExec ["Server_Stock_InsertLog",2];
		[getPlayerUID player,(player getVariable ["character_id",""]),"Stock_ItemDeposited",[format ["Stock: %1 | Item: %2 | Amount: %3",A3PL_STOCKOBJ,_itemName,_amount]]] remoteExec ["Server_Log_New",2];
	};
	[A3PL_STOCKOBJ] spawn A3PL_Stock_View_ItemSwitch;
}] call compile_Global;

["A3PL_Stock_View_ItemSwitch",{
	disableSerialization;
	_shop = param [0,""];

	private _pos = switch (player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) do {
		case ("STR_Common_FIFR" call A3PL_Localize): {fifr_table_1 modelToWorld [0,0,-0.5]};
		case ("STR_Common_FISD" call A3PL_Localize): {fisd_table modelToWorld [0,0,-0.5]};
		case ("STR_Common_DOJ" call A3PL_Localize): {doj_table modelToWorld [0,0,-0.5]};
		case ("STR_Common_GOV" call A3PL_Localize): {ecc_table modelToWorld [0,0,-0.5]};
		case ("STR_Common_Company" call A3PL_Localize): {company_table modelToWorld [0,0,-0.5]};
		default {company_table modelToWorld [0,0,-0.5]};
	};

	private _display = 0;
	if (A3PL_OBJTYPE isNotEqualTo "items") then {
		_display = findDisplay 1104;
	} else {
		_display = findDisplay 1103;
	};
	private _control = _display displayCtrl 1600;
	private _obj = _control lbData (lbCurSel _control);
	_obj = call compile _obj;
	private _classname = _obj#0;
	private _count = _obj#1;
	private _customName = _obj#2;
	private _desc = _obj#3;
	private _rankperms = _obj#4;
	private _licensesperms = _obj#5;
	private _type = _obj#6;
	private _vars = [];

	private _color = "#(argb,8,8,3)color(0,0,0,1.0,CO)";
	private _material = "";
	private _damage = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
	private _addons = [];
	private _gasAmount = 0;
	private _gasAmount2 = 0;

	if (A3PL_OBJTYPE isNotEqualTo "items") then {
		_vars = _obj#6;
		_type = _obj#7;

		{
			switch (_x#0) do
			{
				case ("color"): { _color = _x#1; };
				case ("material"): { _material = _x#1; };
				case ("damage"): { _damage = _x#1; };
				case ("addons"): { _addons = _x#1; };
			};
		} forEach _vars;

		_color = [_color, "?antislash?", "\"] call CBA_fnc_replace;
		_material = [_material, "?antislash?", "\"] call CBA_fnc_replace;
	};

	private _objtype = "item";
	switch (_type) do
	{
		case ("aitem"): { _objtype = "wh"; };
		case ("item"): { if (((_classname splitString "_") select 0) isEqualTo "furn") then {_objtype = "furn";}; };
		case ("backpack"): { _objtype = "backpack"; };
		case ("uniform"): { _objtype = "uniform"; };
		case ("vest"): { _objtype = "vest"; };
		case ("headgear"): { _objtype = "headgear"; };
		case ("vehicle"): { _objtype = "vh"; _pos = [12625.8,1707.52,2.4]};
		case ("plane"): { _objtype = "vh"; _pos = [12625.8,1707.52,2.4]};
		case ("weapon"): { _objtype = "wh"; };
		case ("weaponPrimary"): { _objtype = "wh"; };
		case ("magazine"): { _objtype = "wh"; };
		case ("goggles"): { _objtype = "goggles"; };
		case ("waitem"): { _objtype = "waitem"; };
	};

	private _itemObjectClass = "";
	if (_type isEqualTo "item") then {
		_itemObjectClass = [_classname,"class"] call A3PL_Config_GetItem;
	} else {
		_itemObjectClass = _classname;
	};

	_stockCtrl = _display displayCtrl 1605;
	_descCtrl = _display displayCtrl 1606;
	_withdrawBtn = _display displayCtrl 1602;
	_sellBtn = _display displayCtrl 1603;

	_stockCtrl ctrlSetStructuredText parseText format ["<t align='right'>%1</t>",_count];
	if (_desc isNotEqualTo "") then {
		private _replacedContent = "";
		_replacedContent = [_desc, '?z?', '"'] call CBA_fnc_replace;
		_replacedContent = [_replacedContent, '?y?', "'"] call CBA_fnc_replace;
		_replacedContent = [_replacedContent, '?x?', "\"] call CBA_fnc_replace;
		
		private _count = count _desc;
		private _size = 1;
		if (_count > 50 && _count < 71) then {_size = 0.9};
		if (_count > 70 && _count < 111) then {_size = 0.8};
		if (_count > 110 && _count < 126) then {_size = 0.7};
		if (_count > 125 && _count < 151) then {_size = 0.65};
		_descCtrl ctrlSetStructuredText parseText format ["<t align='right' size='%2'>%1</t>",_replacedContent,_size];
	} else {
		_descCtrl ctrlSetStructuredText parseText format [("STR_A3PL_Stock_NoDescription" call A3PL_Localize)];
	};

	if (!isNil "A3PL_SHOP_ITEMPREVIEW") then {deleteVehicle A3PL_SHOP_ITEMPREVIEW;};

	if(_objtype IN ["headgear","goggles","uniform","vest","backpack","waitem"]) then {
		A3PL_SHOP_ITEMPREVIEW = "C_man_p_beggar_F" createvehicleLocal [0,0,0];
		A3PL_SHOP_ITEMPREVIEW setPosASL [14321.1,15.9644,1017.32];
		A3PL_SHOP_ITEMPREVIEW enableSimulation false;

		A3PL_SHOP_ITEMPREVIEW setUnitLoadout (getUnitLoadout player);

		switch (_objtype) do {
			case("headgear"): {A3PL_SHOP_ITEMPREVIEW addHeadGear _classname;};
			case("goggles"): {A3PL_SHOP_ITEMPREVIEW addGoggles _classname;};
			case("uniform"): {A3PL_SHOP_ITEMPREVIEW addUniform _classname;};
			case("vest"): {A3PL_SHOP_ITEMPREVIEW addVest _classname;};
			case("backpack"): {A3PL_SHOP_ITEMPREVIEW addBackPack _classname;};
			case("waitem"): {removeAllAssignedItems A3PL_SHOP_ITEMPREVIEW;A3PL_SHOP_ITEMPREVIEW linkItem _classname;};
		};
		if (_objtype isNotEqualTo "waitem") then {_objtype = "clothing";};
	} else {
		switch (_objtype) do
		{
			case ("wh"):
			{
				A3PL_SHOP_ITEMPREVIEW = "groundWeaponHolder" createVehicleLocal (getpos Player);
				switch (_type) do
				{
					case ("weapon"): {A3PL_SHOP_ITEMPREVIEW addWeaponCargo [_classname,1];};
					case ("weaponPrimary"): {A3PL_SHOP_ITEMPREVIEW addWeaponCargo [_classname,1];};
					case ("magazine"): {A3PL_SHOP_ITEMPREVIEW addMagazineCargo [_classname,1];};
					case ("aitem"): {A3PL_SHOP_ITEMPREVIEW addItemCargo [_classname,1];};
					case ("weaponitem"): {A3PL_SHOP_ITEMPREVIEW addItemCargo [_classname,1];};
					case ("secweaponitem"): {A3PL_SHOP_ITEMPREVIEW addItemCargo [_classname,1];};
				};
			};
			case ("vh"):
			{
				A3PL_SHOP_ITEMPREVIEW = _itemObjectClass createVehicleLocal [_pos select 0,_pos select 1,(_pos select 2)+0.9];
				A3PL_SHOP_ITEMPREVIEW setObjectTexture [0,_color];
				A3PL_SHOP_ITEMPREVIEW setObjectMaterial [0,_material];
				if ((count _addons) > 0) then {
					{
						_animName = _x select 0;
						_animPhase = _x select 1;
						A3PL_SHOP_ITEMPREVIEW animatesource [_animName, _animPhase, true];
					} foreach _addons;
				};
				if((count _damage) > 0) then {
					_parts = getAllHitPointsDamage A3PL_SHOP_ITEMPREVIEW;
					for "_i" from 0 to ((count _damage) - 1) do {
						A3PL_SHOP_ITEMPREVIEW setHitPointDamage [format ["%1",((_parts select 0) select _i)],_damage select _i];
					};
				};
				A3PL_SHOP_ITEMPREVIEW allowDamage false;
			};
			case default
			{
				A3PL_SHOP_ITEMPREVIEW = _itemObjectClass createVehicleLocal [_pos select 0,_pos select 1,(_pos select 2)+0.9];
				A3PL_SHOP_ITEMPREVIEW allowDamage false;
			};
		};
	};

	if !(_objtype IN ["clothing","waitem"]) then {
		switch (_classname) do {
			case ("A3PL_Jaws"): { A3PL_SHOP_ITEMPREVIEW setposATL [_pos select 0,_pos select 1,(_pos select 2)+1.2]; };
			case default { A3PL_SHOP_ITEMPREVIEW setposATL [_pos select 0,_pos select 1,(_pos select 2)+0.9]; };
		};
	};

	switch (_objtype) do
	{
		case ("vh"):
		{
			A3PL_SHOP_CAMERA camSetTarget A3PL_SHOP_ITEMPREVIEW;
			A3PL_SHOP_CAMERA camSetRelPos [6,7,0.3];
			A3PL_SHOP_CAMERA camCommit 0;
		};
		case ("furn"):
		{
			A3PL_SHOP_ITEMPREVIEW enableSimulation false;
			A3PL_SHOP_CAMERA camSetTarget A3PL_SHOP_ITEMPREVIEW;
			A3PL_SHOP_CAMERA camSetRelPos [2,3,1];
			A3PL_SHOP_CAMERA camCommit 0;
		};
		case ("clothing"):
		{
			A3PL_SHOP_CAMERA camSetTarget A3PL_SHOP_ITEMPREVIEW;
			A3PL_SHOP_CAMERA camSetRelPos [2,3,1];
			A3PL_SHOP_CAMERA camCommit 0;
		};
		case ("waitem"):
		{
			A3PL_SHOP_CAMERA camSetTarget A3PL_SHOP_ITEMPREVIEW;
			A3PL_SHOP_CAMERA camSetRelPos [1,1,1.5];
			A3PL_SHOP_CAMERA camCommit 0;
		};
		case default
		{
			A3PL_SHOP_ITEMPREVIEW enableSimulation false;
			A3PL_SHOP_CAMERA camSetTarget A3PL_SHOP_ITEMPREVIEW;
			A3PL_SHOP_CAMERA camSetRelPos [-0.9,0.15,0.3];
			A3PL_SHOP_CAMERA camCommit 0;
		};
	};

	if (_type IN ["item","magazine"]) then
	{
		_control = _display displayCtrl 1604;
		_control ctrlSetText "1";
		_control ctrlSetFade 0;
		_control ctrlCommit 0;
		_control = _display displayCtrl 1000;
		_control ctrlSetFade 0;
		_control ctrlCommit 0;
	} else
	{
		_control = _display displayCtrl 1604;
		_control ctrlSetFade 1;
		_control ctrlCommit 0;
		_control = _display displayCtrl 1000;
		_control ctrlSetFade 1;
		_control ctrlCommit 0;
	};

	if (_type IN ["vehicle","plane"]) then
	{
		_control = _display displayCtrl 1607;
		lbClear _control;
		{
			_damage = ("STR_Common_No" call A3PL_Localize);
			if (_x#0 isEqualTo "damage") then {
				{
					
					if (_x > 0) exitWith {
						_damage = ("STR_Common_Yes" call A3PL_Localize);
					};
				} forEach _x#1;
			};
			if (_x#0 isEqualTo "gasAmount") then {_gasAmount = _x#1;};
			if (_x#0 isEqualTo "gasAmount2") then {_gasAmount2 = _x#1;};
		} forEach _vars;
		_control lbAdd format [("STR_A3PL_Stock_Vehicle" call A3PL_Localize),_classname];
		_control lbAdd format [("STR_A3PL_Stock_Damaged" call A3PL_Localize),_damage];
		{

			switch (_x#0) do {
				case ("plate"): {_control lbAdd format [("STR_A3PL_Stock_LicensePlate" call A3PL_Localize),_x#1];};
				case ("fuel"): {_control lbAdd format [("STR_A3PL_Stock_Gas" call A3PL_Localize),_x#1];};
				case ("water"): {_control lbAdd format [("STR_A3PL_Stock_Citern" call A3PL_Localize),_x#1];};
				case ("gasType"): {_control lbAdd format [("STR_A3PL_Stock_CiternContent" call A3PL_Localize),_gasAmount,_x#1];};
				case ("gasType2"): {_control lbAdd format [("STR_A3PL_Stock_CiternContent2" call A3PL_Localize),_gasAmount2,_x#1];};
			};
		} forEach _vars;
	};
}] call compile_Global;