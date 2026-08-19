/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/

// Shop Management
["A3PL_CompanyShop_Man_Open",{
	private _nearBy = nearestObjects [player, Company_Shops, 20];
	private _charID = (player getVariable ["character_id",""]);
    private _cidPlayer = [_charID] call A3PL_Config_GetCompanyID;

    private _closestShop = objNull;
    private _closestDistance = 20;

    {
        private _cidShop = _x getVariable ["cid", -1];
        if (_cidShop != -1 && _cidShop isEqualTo _cidPlayer) then {
            private _distance = player distance2D _x;
            if (_distance < _closestDistance) then {
                _closestShop = _x;
                _closestDistance = _distance;
            };
        };
    } forEach _nearBy;
	
    if (isNil "_closestShop") exitWith {
        [("STR_A3PL_CompanyShop_NoNearbyBuilding" call A3PL_Localize), Color_Red] call A3PL_Notification;
    };
    private _owner = (([_charID] call A3PL_Config_GetCompanyID) isEqualTo (_closestShop getVariable["cid",-1]));
	private _cid = [_charID] call A3PL_Config_GetCompanyID;
	private _hasPerm = [_cid,"shop",_charID] call A3FL_Config_GetCompanyPermissions;
	private _isBoss = ([_charID] call A3PL_Config_IsCompanyBoss);
	if(!(_hasPerm) && !(_isBoss)) exitWith {[("STR_A3PL_CompanyShop_ManageShopDenied" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!(_owner)) exitWith {[("STR_A3PL_CompanyShop_OwnerCheck" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	A3PL_Company_Building = _closestShop;
	if(A3PL_Company_Building getVariable["inUse",false]) exitWith {[("STR_A3PL_CompanyShop_AlreadyInUse" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	A3PL_Company_Building setVariable["inUse",true,true];
    createDialog "Dialog_CompanyShop_Management";
    call A3PL_CompanyShop_Man_RefreshShopStock;
    private _display = findDisplay 130;
    [getPlayerUID player,_charID,"CompanyShop_OpenManager",[format ["Company: %1 | Owner: %2",_cid,_owner]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

['A3PL_CompanyShop_Man_RefreshShopStock', {
    private _display = findDisplay 130;
    private _control = _display displayCtrl 1301;
    private _vinventory = player getVariable ["player_inventory", []];
    private _items = assignedItems player + items player;
    private _weps = weapons player;
    if ("Binocular" IN _items) then {_items = _items - ["Binocular"]};
    private _mags = magazines player;
    if (currentMagazine player != "") then {_mags pushback (currentMagazine player);};
    lbClear _control;

    // Items
    private _itemCount = createHashMap;
    {
        private _itemName = _x;
        if (isNil {_itemCount get _itemName}) then {
            _itemCount set [_itemName, 0];
        };
        _itemCount set [_itemName, (_itemCount get _itemName) + 1];
    } foreach _items;
   
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
            _displayName = "Unknown name";
        };
        private _index = _control lbAdd format ["(%1x) %2", (_itemCount get _x), _displayName];
        private _info = format["%1,%2,%3", "aitem", _x, (_itemCount get _x)];
        _control lbSetData [_index, _info];
        _control lbSetValue [_index, 0];
    } forEach (keys _itemCount);

    // Headgear
    private _headgear = headgear player;
    if (!(_headgear isEqualTo "")) then {
        private _headgearName = getText (configFile >> "CfgWeapons" >> _headgear >> "displayName");
        _index = _control lbAdd format ["(1x) %1", _headgearName];
        private _info = format["%1,%2,%3", "headgear", _headgear, 1];
        _control lbSetData [_index, _info];
        _control lbSetValue [_index, 3];
    };

    // Uniform
    private _uniform = uniform player;
    if (!(_uniform isEqualTo "")) then {
        private _uniformName = getText (configFile >> "CfgWeapons" >> _uniform >> "displayName");
        _index = _control lbAdd format ["(1x) %1", _uniformName];
        private _info = format["%1,%2,%3", "uniform", _uniform, 1];
        _control lbSetData [_index, _info];
        _control lbSetValue [_index, 1];
    };

    // Vest
    private _vest = vest player;
    if (!(_vest isEqualTo "")) then {
        private _vestName = getText (configFile >> "CfgWeapons" >> _vest >> "displayName");
        _index = _control lbAdd format ["(1x) %1", _vestName];
        private _info = format["%1,%2,%3", "vest", _vest, 1];
        _control lbSetData [_index, _info];
        _control lbSetValue [_index, 2];
    };

    // Backpack
    private _backpack = backpack player;
    if (!(_backpack isEqualTo "")) then {
        private _backpackName = getText (configFile >> "CfgVehicles" >> _backpack >> "displayName");
        _index = _control lbAdd format ["(1x) %1", _backpackName];
        private _info = format["%1,%2,%3", "backpack", _backpack, 1];
        _control lbSetData [_index, _info];
        _control lbSetValue [_index, 0];
    };

    // Weapons
    private _weaponCount = createHashMap;
    {
        private _wepName = _x;
        if (isNil {_weaponCount get _wepName}) then {
            _weaponCount set [_wepName, 0];
        };
        _weaponCount set [_wepName, (_weaponCount get _wepName) + 1];
    } foreach _weps;

    {
        _index = _control lbAdd format ["(%1x) %2", (_weaponCount get _x), getText (configFile >> "CfgWeapons" >> _x >> "displayName")];
        private _info = format["%1,%2,%3", "weapon", _x, (_weaponCount get _x)];
        _control lbSetData [_index, _info];
        _control lbSetValue [_index, 0];
    } forEach (keys _weaponCount);

    // Magazines
    private _magCount = createHashMap;
    {
        private _magName = _x;
        if (isNil {_magCount get _magName}) then {
            _magCount set [_magName, 0];
        };
        _magCount set [_magName, (_magCount get _magName) + 1];
    } foreach _mags;

    {
        _index = _control lbAdd format ["(%1x) %2", (_magCount get _x), getText (configFile >> "CfgMagazines" >> _x >> "displayName")];
        private _info = format["%1,%2,%3", "magazine", _x, (_magCount get _x)];
        _control lbSetData [_index, _info];
        _control lbSetValue [_index, 0];
    } forEach (keys _magCount);

    // Virtual inventory
	{
		private _id = _x select 0;
		private _amount = _x select 1;
		private _infoString = format["%1,%2,%3","item",_id,_amount];
		private _i = _control lbAdd format ["(%2x) %1",([_id,"name"] call A3PL_Config_GetItem),_amount];
		_control lbSetData [_i,_infoString];
		private _itempicture = [_id, "picture"] call A3PL_Config_GetItem;
		_control lbSetPicture [_i,_itempicture];
	} foreach _vinventory;

    // Nearest objects
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

    _control ctrlAddEventHandler ["LBSelChanged","(_display displayCtrl 1309) lbSetCurSel -1; (_display displayCtrl 1304) lbSetCurSel -1;"];

    private _stock_selling = A3PL_Company_Building getVariable["stock_selling",[]];
    private _stock_buying = A3PL_Company_Building getVariable["stock_buying",[]];
    private _control = _display displayCtrl 1309;
    lbClear _control;

    {
		private ["_name"];
		private _type = (_x select 0);
		private _class = (_x select 1);
		private _amount = (_x select 2);
		private _price = (_x select 3);
        private _itempicture = [_x select 1, "picture"] call A3PL_Config_GetItem;
		private _infoString = format["%1,%2,%3,%4",_type,_class,_amount,_price];
		if (_type isEqualTo "aitem") then {
			if (isClass (configFile >> "CfgWeapons" >> _class)) then {
				_name = getText (configFile >> "CfgWeapons" >> _class >> "displayName");
			} else {
				if (isClass (configFile >> "CfgGlasses" >> _class)) then {
					_name = getText (configFile >> "CfgGlasses" >> _class >> "displayName");
				} else {
					if (isClass (configFile >> "CfgMagazines" >> _class)) then {
						_name = getText (configFile >> "CfgMagazines" >> _class >> "displayName");
					} else {
						_name = _class;
					};
				};
			};
		};
		if (_type isEqualTo "headgear") then {_name = getText (configFile >> "CfgWeapons" >> _class >> "displayName");};
		if (_type isEqualTo "uniform") then {_name = getText (configFile >> "CfgWeapons" >> _class >> "displayName");};
		if (_type isEqualTo "vest") then {_name = getText (configFile >> "CfgWeapons" >> _class >> "displayName");};
		if (_type isEqualTo "goggles") then {_name = getText (configFile >> "CfgGlasses" >> _class >> "displayName");};
		if (_type isEqualTo "magazine") then {_name = getText (configFile >> "CfgMagazines" >> _class >> "displayName");};
		if (_type isEqualTo "backpack") then {_name = getText (configFile >> "CfgVehicles" >> _class >> "displayName");};
		if (_type isEqualTo "vehicle") then {_name = getText (configFile >> "CfgVehicles" >> _class >> "displayName");};
		if (_type isEqualTo "weapon") then {_name = getText (configFile >> "CfgWeapons" >> _class >> "displayName");};
		if (_type isEqualTo "item") then {_name = [_class,"name"] call A3PL_Config_GetItem;};

		private _i = _control lbAdd format ["(%2x) %1",_name,_amount];
		_control lbSetData [_i,format ["%1",_infoString]];
		if (_type isEqualTo "item") then {
			_control lbSetPicture [_i,_itempicture];
		};
	} forEach _stock_selling;
    _control ctrlAddEventHandler ["LBSelChanged","[0] spawn A3PL_CompanyShop_Man_ShopSelect;"];

    private _control = _display displayCtrl 1304;
    lbClear _control;

    {
		private ["_name"];
		private _type = (_x select 0);
		private _class = (_x select 1);
		private _amount = (_x select 2);
		private _price = (_x select 3);
        private _limit = (_x select 4);
        private _itempicture = [_x select 1, "picture"] call A3PL_Config_GetItem;
		private _infoString = format["%1,%2,%3,%4,%5",_type,_class,_amount,_price,_limit];
		if (_type isEqualTo "aitem") then {
			if (isClass (configFile >> "CfgWeapons" >> _class)) then {
				_name = getText (configFile >> "CfgWeapons" >> _class >> "displayName");
			} else {
				if (isClass (configFile >> "CfgGlasses" >> _class)) then {
					_name = getText (configFile >> "CfgGlasses" >> _class >> "displayName");
				} else {
					if (isClass (configFile >> "CfgMagazines" >> _class)) then {
						_name = getText (configFile >> "CfgMagazines" >> _class >> "displayName");
					} else {
						_name = _class;
					};
				};
			};
		};
		if (_type isEqualTo "headgear") then {_name = getText (configFile >> "CfgWeapons" >> _class >> "displayName");};
		if (_type isEqualTo "uniform") then {_name = getText (configFile >> "CfgWeapons" >> _class >> "displayName");};
		if (_type isEqualTo "vest") then {_name = getText (configFile >> "CfgWeapons" >> _class >> "displayName");};
		if (_type isEqualTo "goggles") then {_name = getText (configFile >> "CfgGlasses" >> _class >> "displayName");};
		if (_type isEqualTo "magazine") then {_name = getText (configFile >> "CfgMagazines" >> _class >> "displayName");};
		if (_type isEqualTo "backpack") then {_name = getText (configFile >> "CfgVehicles" >> _class >> "displayName");};
		if (_type isEqualTo "vehicle") then {_name = getText (configFile >> "CfgVehicles" >> _class >> "displayName");};
		if (_type isEqualTo "weapon") then {_name = getText (configFile >> "CfgWeapons" >> _class >> "displayName");};
		if (_type isEqualTo "item") then {_name = [_class,"name"] call A3PL_Config_GetItem;};

		private _i = _control lbAdd format ["(%2x) %1",_name,_amount];
		_control lbSetData [_i,format ["%1",_infoString]];
		if (_type isEqualTo "item") then {
			_control lbSetPicture [_i,_itempicture];
		};
	} forEach _stock_buying;
    _control ctrlAddEventHandler ["LBSelChanged","[1] spawn A3PL_CompanyShop_Man_ShopSelect;"];
}] call compile_Global;

['A3PL_CompanyShop_Man_ShopSelect', {
	private _display = findDisplay 130;
    private _mode = param [0,0];
    private _control = _display displayCtrl 1309;
    if (_mode isEqualTo 1) then {
        _control = _display displayCtrl 1304;
    };
    (_display displayCtrl 1301) lbSetCurSel -1;
    
	private _itemData = (_control lbData (lbCurSel _control)) splitString ",";
	if(count(_itemData) < 3) exitWith {};
	private _amount = parseNumber(_itemData select 2);
	private _price = parseNumber(_itemData select 3);
    if (count _itemData > 4) then {
        (_display displayCtrl 1309) lbSetCurSel -1;
    } else {
        (_display displayCtrl 1304) lbSetCurSel -1;
    };


	_control = _display displayCtrl 1306;
	_control ctrlSetText format["%1",[_price, 1, 0, true] call CBA_fnc_formatNumber];
    if (_mode isEqualTo 1) then {
        _limit = parseNumber(_itemData select 4);
        _control = _display displayCtrl 1303;
        _control ctrlSetText format["%1",_limit];
    };

	private _cid = A3PL_Company_Building getVariable ["cid", ""];

	A3PL_LogsResponse = [];
	A3PL_Responded = false;
	[_cid, getPos A3PL_Company_Building, player] remoteExec ["Server_CompanyShop_GetLogs",2];

	waitUntil { A3PL_Responded };

	reverse A3PL_LogsResponse;

	_control = _display displayCtrl 1305;
	lbClear _control;

	{
		private _object = _x#2;
		private _amount = _x#3;
		private _price = _x#4;
		private _type = _x#5;
		private _time = _x#6;

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

		if (_object isEqualTo (_itemData#1)) then {
			if (_mode isEqualTo 1) then {
				if (_amount > 0) then {
					_text = format ["+%1 %2 | -%3 | %4/%5/%6 at %7:%8", _amount, _itemName, _price, _time#2, _time#1, _time#0, _time#3, _time#4];
					
					_i = _control lbAdd _text;
					lbSetColor [1305, _i, [0,0.7,0,1]];
				};
			} else {
				if (_amount < 0) then {
					_text = format ["%1 %2 | +%3 | %4/%5/%6 at %7:%8", _amount, _itemName, _price, _time#2, _time#1, _time#0, _time#3, _time#4];

					_i = _control lbAdd _text;
					lbSetColor [1305, _i, [1,0,0,1]];
				};
			};
		};
	} forEach A3PL_LogsResponse;
}] call compile_Global;

['A3PL_CompanyShop_Man_Put', {
    private ["_mode","_display","_control","_itemData","_type","_class","_stock","_addPrice","_exit","_limit","_text","_cid","_cName"];
    _mode = param [0,0];
    if(!(call A3PL_Player_AntiSpam)) exitWith {};
	_display = findDisplay 130;
    _control = _display displayCtrl 1301;
    if ((lbCurSel _control) < 0) exitwith {[("STR_A3PL_CompanyShop_SelectAnItem" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    _itemData = _control lbData (lbCurSel _control);

    _control = _display displayCtrl 1306;
	_addPrice = floor(parseNumber (ctrlText _control));
	if(_addPrice < 0) exitWith {[("STR_A3PL_CompanyShop_EnterValidAmount" call A3PL_Localize),Color_Red] call A3PL_Notification;};

    _exit = false;
    if (_mode isEqualTo 1) then {
        _control = _display displayCtrl 1303;
        _limit = floor(parseNumber (ctrlText _control));
        if !(_limit > 0) exitWith {[("STR_A3PL_CompanyShop_EnterValidLimit" call A3PL_Localize),Color_Red] call A3PL_Notification; _exit = true;};
    };

    if (_exit) exitWith {};

    _itemData = _itemData splitString ",";
	if(count(_itemData) < 3) exitWith {["Error while loading item info, please try again!",Color_Red] call A3PL_Notification;};

    _type = _itemData select 0;
	_class = _itemData select 1;

    _stock = A3PL_Company_Building getVariable ["stock_selling",[]];
    if (_mode isEqualTo 1) then {
        _stock = A3PL_Company_Building getVariable ["stock_buying",[]];
    };

    
    {
        if (_class IN _x) exitWith {
            _text = ("STR_A3PL_CompanyShop_Selling" call A3PL_Localize);
            if (_mode isEqualTo 1) then {
                _text = ("STR_A3PL_CompanyShop_Buying" call A3PL_Localize);
            };
            [format[("STR_A3PL_CompanyShop_ItemAlreadyInList" call A3PL_Localize),_text],Color_Red] call A3PL_Notification;
            _exit = true;
        };
    } forEach _stock;

    if (_exit) exitWith {};
    
    if (_mode isEqualTo 0) then {_stock pushBack [_type,_class,0,_addPrice]} else {_stock pushBack [_type,_class,0,_addPrice,_limit];};
    [A3PL_Company_Building,_stock,_mode] remoteExec ["Server_CompanyShop_Update",2];
    sleep 0.2;
    _control lbSetCurSel -1;
    [] call A3PL_CompanyShop_Man_RefreshShopStock;

    _cid = A3PL_Company_Building getVariable ["cid", ""];
	_cName = [_cid, "name"] call A3PL_Config_GetCompanyData;
	[getPlayerUID player,(player getVariable ["character_id",""]),"CompanyShop_Put",[format ["Company: %1 | Item: %2",(_cName),(_class)]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

['A3PL_CompanyShop_Man_Remove', {
    private ["_mode","_display","_control","_itemData","_type","_class","_amount","_stock","_newstock","_cid","_cName"];
    _mode = param [0,0];
    if(!(call A3PL_Player_AntiSpam)) exitWith {};
	_display = findDisplay 130;
    _control = _display displayCtrl 1309;
    _stock = A3PL_Company_Building getVariable ["stock_selling",[]];
    if (_mode isEqualTo 1) then {
        _stock = A3PL_Company_Building getVariable ["stock_buying",[]];
        _control = _display displayCtrl 1304;
    };
    if ((lbCurSel _control) < 0) exitwith {[("STR_A3PL_CompanyShop_SelectAnItem" call A3PL_Localize),Color_Red] call A3PL_Notification;};

    _itemData = (_control lbData (lbCurSel _control)) splitString ",";
    if(count(_itemData) < 3) exitWith {["Error while loading item info, please try again!",Color_Red] call A3PL_Notification;};
    _type = _itemData select 0;
	_class = _itemData select 1;
    _amount = parseNumber(_itemData select 2);
    if (_amount > 0) exitWith {[("STR_A3PL_CompanyShop_ItemRemoveInStock" call A3PL_Localize),Color_Red] call A3PL_Notification;};

    _newstock = [];
	{
		if(_x#1 isEqualTo _class) then {
			continue;
		} else {
			if (_mode isEqualTo 0) then {_newstock pushback [_x#0,_x#1,_x#2,_x#3]} else {_newstock pushback [_x#0,_x#1,_x#2,_x#3,_x#4];};
		};
	} foreach _stock;

	[A3PL_Company_Building,_newstock,_mode] remoteExec ["Server_CompanyShop_Update",2];
    sleep 0.2;
    _control lbSetCurSel -1;
    [] call A3PL_CompanyShop_Man_RefreshShopStock;

    _cid = A3PL_Company_Building getVariable ["cid", ""];
	_cName = [_cid, "name"] call A3PL_Config_GetCompanyData;
	[getPlayerUID player,(player getVariable ["character_id",""]),"CompanyShop_Remove",[format ["Company: %1 | Item: %2",(_cName),(_class)]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

['A3PL_CompanyShop_Man_Deposit', {
    private ["_display","_control","_control1","_itemData","_addAmount","_addPrice","_type","_class","_amount","_stock","_stockMaxAmt","_stockCount","_amt","_accs","_found","_cid","_cName"];
    if(!(call A3PL_Player_AntiSpam)) exitWith {};
	_display = findDisplay 130;
	_control = _display displayCtrl 1301;
	if ((lbCurSel _control) < 0) exitwith {[("STR_A3PL_CompanyShop_SelectItemFromInventory" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_itemData = _control lbData (lbCurSel _control);

    _control = _display displayCtrl 1306;
	_addPrice = floor(parseNumber (ctrlText _control));
	if(_addPrice < 0) exitWith {[("STR_A3PL_CompanyShop_EnterValidAmount" call A3PL_Localize),Color_Red] call A3PL_Notification;};

    _itemData = _itemData splitString ",";
	if(count(_itemData) < 3) exitWith {["Error while loading item info, please try again!",Color_Red] call A3PL_Notification;};
	_type = _itemData select 0;

    _control1 = _display displayCtrl 1308;
    if (_type IN ["item","magazine"]) then {
	    _addAmount = floor(parseNumber (ctrlText _control1));
    } else {
        _addAmount = 1;
        _control1 ctrlSetText "";
    };
    if(_addAmount < 0) exitWith {[("STR_A3PL_CompanyShop_EnterValidAmount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_class = _itemData select 1;
	_amount = parseNumber(_itemData select 2);

    _stock = A3PL_Company_Building getVariable ["stock_selling",[]];
    _found = false;
    {
        if (_x#1 isEqualTo _class) exitWith {
            _found = true;
        };
    } forEach _stock;
    if (!_found) exitWith {[("STR_A3PL_CompanyShop_ItemNotInSellingList" call A3PL_Localize), Color_Red] call A3PL_Notification;};

    if(_addAmount > _amount) exitWith {[("STR_A3PL_CompanyShop_InsufficientItemAmount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    _stockMaxAmt = 5000;
	_stockCount = 0;
	{
		_amt = _x#2;
		_stockCount = _stockCount + _amt;
	} forEach _stock;
	if ((_stockCount + _addAmount) > _stockMaxAmt) exitWith {[("STR_A3PL_CompanyShop_MaxStockReached" call A3PL_Localize),Color_Red] call A3PL_Notification;};

    switch(_type) do {
		case "aitem": {
			if (_class IN (assignedItems player)) then
			{
				player unAssignItem _class;
			};
			player removeItem _class;
		};
		case "uniform": {
			removeUniform player;
		};
		case "vest": {
			removeVest player;
		};
		case "headgear": {
			removeHeadgear player;
		};
		case "backpack": {
			removeBackpackGlobal player;
		};
		case "goggles": {
			removeGoggles player;
		};
		case "magazine": {
			for "_i" from 0 to (_addAmount - 1) do {
				if (_class IN (assignedItems player)) then {
					player unAssignItem _class;
				};
				player removeItem _class;
			};
		};
		case "weapon": {
			_accs = ["","",""];
			{
				if (_x isEqualTo _class) exitWith {
					player removeWeaponGlobal _x;
					_accs = player weaponAccessories _class;
				};
			} forEach weapons player;
			{
				if (_x isEqualTo _class) exitWith {
					player removeItemFromUniform _x;
					_accs = [_class] call A3PL_Lib_GetWeaponAccsCargo;
				};
			} forEach uniformItems player;
			{
				if (_x isEqualTo _class) exitWith {
					player removeItemFromVest _x;
					_accs = [_class] call A3PL_Lib_GetWeaponAccsCargo;
				};
			} forEach vestItems player;
			{
				if (_x isEqualTo _class) exitWith {
					player removeItemFromBackpack _x;
					_accs = [_class] call A3PL_Lib_GetWeaponAccsCargo;
				};
			} forEach backpackItems player;
		};
		case "item": {
			if(count(_itemData) isEqualTo 4) then {
				_objString = _itemData select 3;
				_splitted = _objString splitString "_";
				if ((_splitted select 0) isEqualTo "OBJ") then
				{
					private _typeOf = toArray _objString;
					_typeOf deleteAt 0;_typeOf deleteAt 0;_typeOf deleteAt 0;_typeOf deleteAt 0;
					_typeOf = toString _typeOf;
					private _veh = [_typeOf] call A3PL_Lib_vehStringToObj;
					deleteVehicle _veh;
				};
			};
			[_class,-(_addAmount)] call A3PL_Inventory_Add;
		};
	};

    {
        if(_x#1 isEqualTo _class) then {
            _x set [2,(_x#2 + _addAmount)];
        };
    } foreach _stock;

    [A3PL_Company_Building,_stock] remoteExec ["Server_CompanyShop_Update",2];
    sleep 0.2;
    _control lbSetCurSel -1;
    [] call A3PL_CompanyShop_Man_RefreshShopStock;

    _cid = A3PL_Company_Building getVariable ["cid", ""];
	_cName = [_cid, "name"] call A3PL_Config_GetCompanyData;
	[getPlayerUID player,(player getVariable ["character_id",""]),"CompanyShop_Deposit",[format ["Company: %1 | Item: %2 | Amount: %3",(_cName),(_class),(_addAmount)]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

['A3PL_CompanyShop_Man_Withdraw', {
    private ["_display","_control","_control1","_itemData","_type","_class","_amount","_takeAmount","_canTake","_weaponHolder","_stock","_itemName","_veh","_cid","_cName"];
    _mode = param [0,0];
    if(!(call A3PL_Player_AntiSpam)) exitWith {};
	_display = findDisplay 130;
	_control = _display displayCtrl 1309;
    if (_mode isEqualTo 1) then {
        _control = _display displayCtrl 1304;
    };
	if ((lbCurSel _control) < 0) exitwith {[("STR_A3PL_CompanyShop_SelectAnItem" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_itemData = (_control lbData (lbCurSel _control)) splitString ",";
    _control1 = _display displayCtrl 1307;
    if (_mode isEqualTo 1) then {
        _control1 = _display displayCtrl 1302;
    };
	_takeAmount = floor(parseNumber (ctrlText _control1));
	if(_takeAmount < 0) exitWith {[("STR_A3PL_CompanyShop_EnterValidAmount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if(count(_itemData) < 3) exitWith {["Error while loading item info, please try again!",Color_Red] call A3PL_Notification;};
	_type = _itemData select 0;
    if !(_type IN ["item","magazine"]) then {
        _takeAmount = 1;
    };
	_class = _itemData select 1;
	_amount = parseNumber(_itemData select 2);
	if(_takeAmount > _amount) exitWith {[("STR_A3PL_CompanyShop_InsufficientItemAmountTake" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    _canTake = true;
    _weaponHolder = createVehicle ["GroundWeaponHolder", getposATL player, [], 0, "CAN_COLLIDE"];
	switch(_type) do {
		case "aitem": {
            _itemName = getText (configFile >> "CfgWeapons" >> _class >> "displayName");
			for "_i" from 1 to _takeAmount do {player addItem _class;};
		};
		case "uniform":
		{
			_itemName = getText (configFile >> "CfgWeapons" >> _class >> "displayName");
            _weaponHolder addItemCargoGlobal [_class,_takeAmount];
		};
		case "vest":
		{
			_itemName = getText (configFile >> "CfgWeapons" >> _class >> "displayName");
            _weaponHolder addItemCargoGlobal [_class,_takeAmount];
		};
		case "headgear":
		{
			_itemName = getText (configFile >> "CfgWeapons" >> _class >> "displayName");
            _weaponHolder addItemCargoGlobal [_class,_takeAmount];
		};
		case "backpack": {
			_itemName = getText (configFile >> "CfgVehicles" >> _class >> "displayName");
            _weaponHolder addItemCargoGlobal [_class,_takeAmount];
		};
		case "goggles": {
			_itemName = getText (configFile >> "CfgGlasses" >> _class >> "displayName");
            _weaponHolder addItemCargoGlobal [_class,_takeAmount];
		};
		case "magazine": {
			_itemName = getText (configFile >> "CfgMagazines" >> _class >> "displayName");
            _weaponHolder addMagazineCargoGlobal [_class,_takeAmount];
		};
		case "weapon": {
			_itemName = getText (configFile >> "CfgWeapons" >> _class >> "displayName");
            _weaponHolder addWeaponCargoGlobal [_class,_takeAmount];
		};
		case "item": {
			_itemName = [_class,"name"] call A3PL_Config_GetItem;
            if ([_class,"canPickup"] call A3PL_Config_GetItem) then {
				if((([[_class,_takeAmount]] call A3PL_Inventory_TotalWeight) <= Player_MaxWeight) && ([_class, _takeAmount] call A3PL_InventoryNew_CanAddItem)) then {
					[_class,_takeAmount] call A3PL_Inventory_Add;
				} else {
					_canTake = false;
				};
			} else {
				_veh = createVehicle [([_class,"class"] call A3PL_Config_GetItem), getposATL player, [], 0, "CAN_COLLIDE"];
				if (!([_class,"simulation"] call A3PL_Config_GetItem)) then {[_veh] remoteExec ["Server_Vehicle_EnableSimulation",2];};
				_veh setVariable ["class",_class,true];
				_veh setVariable ["owner",(player getVariable ["character_id",""]),true];
				private _pJob = player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
				if (_pJob IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) then {
					_veh setVariable ["job",_pJob,true];
				};
			};
		};
	};
	if(!_canTake) exitWith {[("STR_Common_NotEnoughSpace" call A3PL_Localize),Color_Red] call A3PL_Notification;};

    _stock = A3PL_Company_Building getVariable ["stock_selling",[]];
    if (_mode isEqualTo 1) then {
        _stock = A3PL_Company_Building getVariable ["stock_buying",[]];
    };

    {
        if(_x#1 isEqualTo _class) then {
            _x set [2,(_x#2 - _takeAmount)];
        };
    } foreach _stock;

    [A3PL_Company_Building,_stock,_mode] remoteExec ["Server_CompanyShop_Update",2];
    sleep 0.2;
    _control lbSetCurSel -1;
    [] call A3PL_CompanyShop_Man_RefreshShopStock;

	_cid = A3PL_Company_Building getVariable ["cid", ""];
	_cName = [_cid, "name"] call A3PL_Config_GetCompanyData;
	[getPlayerUID player,(player getVariable ["character_id",""]),"CompanyShop_Withdraw",[format ["Company: %1 | Item: %2 | Amount: %3",(_cName),(_class),(_takeAmount)]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

['A3PL_CompanyShop_UpdatePrice', {
	private ["_display","_control","_control1","_mode","_itemData","_class","_price","_control","_newPrice","_cid","_cName"];
    if(!(call A3PL_Player_AntiSpam)) exitWith {};
    _display = findDisplay 130;
	_control = _display displayCtrl 1309;
    _mode = 0;
    if ((lbCurSel _control) < 0) then {_control = _display displayCtrl 1304; _mode = 1;};
    if ((lbCurSel _control) < 0) exitwith {[("STR_A3PL_CompanyShop_SelectAnItem" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_itemData = (_control lbData (lbCurSel _control)) splitString ",";
	if (count(_itemData) < 3) exitWith {["Error while loading item info, please try again!",Color_Red] call A3PL_Notification;};
	_class = _itemData select 1;
	_price = parseNumber(_itemData select 3);

	_control1 = _display displayCtrl 1306;
	_newPrice = floor(parseNumber (ctrlText _control1));
	if (_newPrice < 0) exitWith {[("STR_A3PL_CompanyShop_EnterValidAmount" call A3PL_Localize),Color_Red] call A3PL_Notification;};

    _stock = A3PL_Company_Building getVariable ["stock_selling",[]];
    if (_mode isEqualTo 1) then {
        _stock = A3PL_Company_Building getVariable ["stock_buying",[]];
    };
    {
        if(_x#1 isEqualTo _class) then {
            _x set [3,_newPrice];
        };
    } foreach _stock;

    [A3PL_Company_Building,_stock,_mode] remoteExec ["Server_CompanyShop_Update",2];
    sleep 0.2;
    _control lbSetCurSel -1;
    [] call A3PL_CompanyShop_Man_RefreshShopStock;

	_cid = A3PL_Company_Building getVariable ["cid", ""];
    _cName = [_cid, "name"] call A3PL_Config_GetCompanyData;
	[getPlayerUID player,(player getVariable ["character_id",""]),"CompanyShop_UpdatePrice",[format ["Company: %1 | Price: %2 | Item: %3",_cName,_price,_class]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

['A3PL_CompanyShop_Man_SetLimit', {
    if(!(call A3PL_Player_AntiSpam)) exitWith {};
    _display = findDisplay 130;
    _control = _display displayCtrl 1304;
    if ((lbCurSel _control) < 0) exitwith {[("STR_A3PL_CompanyShop_SelectAnItem" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    _itemData = (_control lbData (lbCurSel _control)) splitString ",";
	if (count(_itemData) < 4) exitWith {["Error while loading item info, please try again!",Color_Red] call A3PL_Notification;};
	_class = _itemData select 1;
	_limit = parseNumber(_itemData select 4);

    _control1 = _display displayCtrl 1303;
	_newLimit = floor(parseNumber (ctrlText _control1));
    if (_newLimit == 0) exitWith {[("STR_A3PL_CompanyShop_EnterValidLimit_Hint" call A3PL_Localize),Color_Red] call A3PL_Notification;};

     _stock = A3PL_Company_Building getVariable ["stock_buying",[]];
     {
        if(_x#1 isEqualTo _class) then {
            _x set [4,_newLimit];
        };
    } foreach _stock;

    [A3PL_Company_Building,_stock,1] remoteExec ["Server_CompanyShop_Update",2];
    sleep 0.2;
    _control lbSetCurSel -1;
    [] call A3PL_CompanyShop_Man_RefreshShopStock;

	_cid = A3PL_Company_Building getVariable ["cid", ""];
    _cName = [_cid, "name"] call A3PL_Config_GetCompanyData;
	[getPlayerUID player,(player getVariable ["character_id",""]),"CompanyShop_UpdateLimit",[format ["Company: %1 | Limit: %2 | Item: %3",_cName,_limit,_class]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

// Shop access
['A3PL_CompanyShop_View_Open', {
	private _nearBy = nearestObjects [player, Company_Shops, 20];
	if (count _nearBy < 1) exitwith {[("STR_A3PL_CompanyShop_NoNearbyBuilding" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	A3PL_Company_Building = _nearBy select 0;

	if(A3PL_Company_Building getVariable["inUse",false]) exitWith {[("STR_A3PL_CompanyShop_AlreadyInUse" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	A3PL_Company_Building setVariable["inUse",true,true];

	createDialog "Dialog_CompanyShop_Customer";
	private _display = findDisplay 130;
	private _control = _display displayCtrl 1301;
	private _cid = A3PL_Company_Building getVariable["cid",-1];
	private _cName = [_cid, "name"] call A3PL_Config_GetCompanyData;
	_control ctrlSetStructuredText parseText format["<t size='1.5'>%1</t>",_cName];
	[] call A3PL_CompanyShop_View_RefreshShopStock;

	[getPlayerUID player,(player getVariable ["character_id",""]),"CompanyShop_OpenViewer",[format ["Company: %1",_cName]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

['A3PL_CompanyShop_View_RefreshShopStock', {
    private ["_display","_control","_stock_buying","_stock_selling","_type","_class","_amount","_price","_limit","_infoString","_itempicture","_name","_i"];
    _display = findDisplay 130;

	_control = _display displayCtrl 1307;
    lbClear _control;

    _stock_buying = A3PL_Company_Building getVariable["stock_buying",[]];
    if(_stock_buying isEqualTo []) then {
        private _emptyIndex = _control lbAdd ("STR_A3PL_CompanyShop_Empty" call A3PL_Localize);
        _control lbSetColor [_emptyIndex, [0.5, 0.5, 0.5, 1]];
        _control lbSetSelectColor [_emptyIndex, [0.5, 0.5, 0.5, 1]];
    } else {
        {
			_type = (_x select 0);
			_class = (_x select 1);
			_amount = (_x select 2);
			_price = (_x select 3);
            _limit = (_x select 4);
			_infoString = format["%1,%2,%3,%4,%5",_type,_class,_amount,_price,_limit];
			_itempicture = [_x select 1, "picture"] call A3PL_Config_GetItem;
			_name = switch(_type) do {
				case "aitem": {
					if (isClass (configFile >> "CfgWeapons" >> _class)) then {
						getText (configFile >> "CfgWeapons" >> _class >> "displayName");
					} else {
						if (isClass (configFile >> "CfgGlasses" >> _class)) then {
							getText (configFile >> "CfgGlasses" >> _class >> "displayName");
						} else {
							if (isClass (configFile >> "CfgMagazines" >> _class)) then {
								getText (configFile >> "CfgMagazines" >> _class >> "displayName");
							} else {
								_class;
							};
						};
					};
				};
				case "uniform": {getText (configFile >> "CfgWeapons" >> _class >> "displayName")};
				case "vest": {getText (configFile >> "CfgWeapons" >> _class >> "displayName")};
				case "headgear": {getText (configFile >> "CfgWeapons" >> _class >> "displayName")};
				case "goggles": {getText (configFile >> "CfgGlasses" >> _class >> "displayName")};
				case "magazine": {getText (configFile >> "CfgMagazines" >> _class >> "displayName")};
				case "backpack": {getText (configFile >> "CfgVehicles" >> _class >> "displayName")};
				case "vehicle": {getText (configFile >> "CfgVehicles" >> _class >> "displayName")};
				case "plane": {getText (configFile >> "CfgVehicles" >> _class >> "displayName")};
				case "weapon": {getText (configFile >> "CfgWeapons" >> _class >> "displayName")};
				case "item": {[_class,"item","name"] call A3PL_Factory_Inheritance;};
			};
			if ((_type isEqualTo "item") && ([_class,1] call A3PL_Inventory_Has)) then {
				_invHas = [_class] call A3PL_Inventory_Return;
				_i = _control lbAdd format [("STR_A3PL_Shop_Inv2" call A3PL_Localize),_name,_invHas];
			} else {
				_i = _control lbAdd format ["%1",_name];
			};
			
			_control lbSetData [_i,format ["%1",_infoString]];
			if (_type isEqualTo "item") then {
				_control lbSetPicture [_i,_itempicture];
			};
		} forEach _stock_buying;
    };

    _control ctrlAddEventHandler ["LBSelChanged","[1] call A3PL_CompanyShop_View_ShopSelect;"];

    _control = _display displayCtrl 1306;
    lbClear _control;

    _stock_selling = A3PL_Company_Building getVariable["stock_selling",[]];
    if(_stock_selling isEqualTo []) then {
        private _emptyIndex = _control lbAdd ("STR_A3PL_CompanyShop_Empty" call A3PL_Localize);
        _control lbSetColor [_emptyIndex, [0.5, 0.5, 0.5, 1]];
        _control lbSetSelectColor [_emptyIndex, [0.5, 0.5, 0.5, 1]];
    } else {
        {
			_type = (_x select 0);
			_class = (_x select 1);
			_amount = (_x select 2);
			_price = (_x select 3);
            _limit = (_x select 4);
			_infoString = format["%1,%2,%3,%4",_type,_class,_amount,_price];
			_itempicture = [_x select 1, "picture"] call A3PL_Config_GetItem;
			_name = switch(_type) do {
				case "aitem": {
					if (isClass (configFile >> "CfgWeapons" >> _class)) then {
						getText (configFile >> "CfgWeapons" >> _class >> "displayName");
					} else {
						if (isClass (configFile >> "CfgGlasses" >> _class)) then {
							getText (configFile >> "CfgGlasses" >> _class >> "displayName");
						} else {
							if (isClass (configFile >> "CfgMagazines" >> _class)) then {
								getText (configFile >> "CfgMagazines" >> _class >> "displayName");
							} else {
								_class;
							};
						};
					};
				};
				case "uniform": {getText (configFile >> "CfgWeapons" >> _class >> "displayName")};
				case "vest": {getText (configFile >> "CfgWeapons" >> _class >> "displayName")};
				case "headgear": {getText (configFile >> "CfgWeapons" >> _class >> "displayName")};
				case "goggles": {getText (configFile >> "CfgGlasses" >> _class >> "displayName")};
				case "magazine": {getText (configFile >> "CfgMagazines" >> _class >> "displayName")};
				case "backpack": {getText (configFile >> "CfgVehicles" >> _class >> "displayName")};
				case "vehicle": {getText (configFile >> "CfgVehicles" >> _class >> "displayName")};
				case "plane": {getText (configFile >> "CfgVehicles" >> _class >> "displayName")};
				case "weapon": {getText (configFile >> "CfgWeapons" >> _class >> "displayName")};
				case "item": {[_class,"item","name"] call A3PL_Factory_Inheritance;};
			};
			if ((_type isEqualTo "item") && ([_class,1] call A3PL_Inventory_Has)) then {
				_invHas = [_class] call A3PL_Inventory_Return;
				_i = _control lbAdd format [("STR_A3PL_Shop_Inv2" call A3PL_Localize),_name,_invHas];
			} else {
				_i = _control lbAdd format ["%1",_name];
			};
			_control lbSetData [_i,format ["%1",_infoString]];
			if (_type isEqualTo "item") then {
				_control lbSetPicture [_i,_itempicture];
			};
		} forEach _stock_selling;
    };

    _control ctrlAddEventHandler ["LBSelChanged","[0] call A3PL_CompanyShop_View_ShopSelect;"];

    A3PL_SHOP_CAMERA = "camera" camCreate (ASLToAGL eyePos cursorObject);
	A3PL_SHOP_CAMERA camSetRelPos [0,0,0];
	A3PL_SHOP_CAMERA cameraEffect ["internal", "BACK"];
	A3PL_SHOP_CAMERA camCommit 0;
	showCinemaBorder false;

    _control = _display displayCtrl 1306;
    _control lbSetCurSel 0;

    [A3PL_SHOP_CAMERA] spawn
	{
		private _display = findDisplay 130;
		disableSerialization;
		waitUntil { isNull _display };
		if (!isNil "A3PL_SHOP_ITEMPREVIEW") then {
			if (!isNull A3PL_SHOP_ITEMPREVIEW) then {
				deleteVehicle A3PL_SHOP_ITEMPREVIEW;
			};
		};
		{deleteVehicle _x;} foreach _this;
		A3PL_SHOP_ITEMPREVIEW = nil;
		player cameraEffect ["terminate", "BACK"];
	};

    _control = _display displayCtrl 1601;
	_control sliderSetRange [-180, 180];
	_control sliderSetPosition 0;
	_control ctrlAddEventHandler ["SliderPosChanged",
	{
		if (!isNil "A3PL_SHOP_ITEMPREVIEW") then {
			if (!isNull A3PL_SHOP_ITEMPREVIEW) then {
				A3PL_SHOP_ITEMPREVIEW setDir (param [1,180]);
			};
		};
	}];
}] call compile_Global;

['A3PL_CompanyShop_View_ShopSelect', {
	private ["_display","_mode","_control","_itemData","_type","_classname","_amount","_price","_limit","_editamount","_setamount","_pos","_objtype","_itemObjectClass"];
    _display = findDisplay 130;
    _mode = param [0,0];
    _control = _display displayCtrl 1306;
    if (_mode isEqualTo 1) then {
        _control = _display displayCtrl 1307;
    }; 
    
	_itemData = (_control lbData (lbCurSel _control)) splitString ",";
	if(count(_itemData) < 3) exitWith {};
    _type = _itemData select 0;
    _classname = _itemData select 1;
    _amount = parseNumber(_itemData select 2);
	_price = parseNumber(_itemData select 3);

	_control = _display displayCtrl 1308;
    if (_mode isEqualTo 1) then {
        _control = _display displayCtrl 1302;
    };
	_control ctrlSetText format["%1",_amount];

    _control = _display displayCtrl 1310;
    _editamount = _display displayCtrl 1309;
    if (_mode isEqualTo 1) then {
        _control = _display displayCtrl 1305;
        _editamount = _display displayCtrl 1304;
    };
    _setamount = floor(parseNumber (ctrlText _editamount));

    _control ctrlSetText format["$%1",([(_price * _setamount), 1, 0, true] call CBA_fnc_formatNumber)];

    if (_mode isEqualTo 1) then {
        _limit = parseNumber(_itemData select 4);
        _control = _display displayCtrl 1303;
        _control ctrlSetText format["%1",_limit];
    };

    _pos = company_table modelToWorld [0,0,-0.5];

    if (!isNil "A3PL_SHOP_ITEMPREVIEW") then {deleteVehicle A3PL_SHOP_ITEMPREVIEW;};

    switch (_type) do
	{
		case ("aitem"): { _objtype = "wh"; };
		case ("item"): { if (((_classname splitString "_") select 0) isEqualTo "furn") then {_objtype = "furn";} else {_objtype = _type;}; };
		case ("backpack"): { _objtype = "backpack"; };
		case ("uniform"): { _objtype = "uniform"; };
		case ("vest"): { _objtype = "vest"; };
		case ("headgear"): { _objtype = "headgear"; };
		case ("weapon"): { _objtype = "wh"; };
		case ("weaponPrimary"): { _objtype = "wh"; };
		case ("magazine"): { _objtype = "wh"; };
		case ("goggles"): { _objtype = "goggles"; };
		case ("waitem"): { _objtype = "waitem"; };
	};

	if (_type isEqualTo "item") then {
		_itemObjectClass = [_classname,"class"] call A3PL_Config_GetItem;
	} else {
		_itemObjectClass = _classname;
	};

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

	if (_mode isEqualTo 1) then {
		((findDisplay 130) displayCtrl 1306) lbSetCurSel -1;
	} else {
		((findDisplay 130) displayCtrl 1307) lbSetCurSel -1;
	};
}] call compile_Global;

["A3PL_CompanyShop_View_Buy",{
	private ["_display","_control","_control1","_itemData","_type","_class","_amount","_takeAmount","_tax","_totalTax","_itemInUniform","_weaponItems","_price","_itemName","_stock","_vestItems","_canTake","_weaponHolder","_veh","_cid","_cName","_exit"];
    if(!(call A3PL_Player_AntiSpam)) exitWith {};

	_display = findDisplay 130;
	_control = _display displayCtrl 1306;
	_itemData = (_control lbData (lbCurSel _control)) splitString ",";
	if(count(_itemData) < 3) exitWith {};
    _type = _itemData select 0;
    _class = _itemData select 1;
    _amount = parseNumber(_itemData select 2);
	_price = parseNumber(_itemData select 3);
	_takeAmount = 1;
	if (_type IN ["item","magazine"]) then
	{
		_control1 = _display displayCtrl 1309;
		_takeAmount = floor(parseNumber (ctrlText _control1));
	};

    _tax = 1.05;
    _price = _price * _takeAmount;
    _totalTax = ceil (_price * _tax);

	if (_amount < 1) exitwith {[("STR_A3PL_CompanyShop_EnterValidAmount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_takeAmount > _amount) exitwith {[("STR_A3PL_CompanyShop_InsufficientItemStock" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_itemName = "UNKNOWN";
    _exit = false;
	_canTake = true;
	switch(_type) do {
		case "aitem": {
            _itemName = getText (configFile >> "CfgWeapons" >> _class >> "displayName");
            [_totalTax] call A3PL_Bank_HowToPay;
            waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
            if (!(player getVariable "paymentResult")) exitWith {_exit = true;};
			for "_i" from 1 to _takeAmount do {player addItem _class;};
		};
        case "waitem": {
            _itemName = getText (configFile >> "CfgWeapons" >> _class >> "displayName");
            [_totalTax] call A3PL_Bank_HowToPay;
            waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
            if (!(player getVariable "paymentResult")) exitWith {_exit = true;};
			for "_i" from 1 to _takeAmount do {player addItem _class;};
		};
		case "uniform":
		{
			_itemName = getText (configFile >> "CfgWeapons" >> _class >> "displayName");
            [_totalTax] call A3PL_Bank_HowToPay;
            waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
            if (!(player getVariable "paymentResult")) exitWith {_exit = true;};
            (createVehicle ["GroundWeaponHolder", getposATL player, [], 0, "CAN_COLLIDE"]) addItemCargoGlobal [_class,_takeAmount];
		};
		case "vest":
		{
			_itemName = getText (configFile >> "CfgWeapons" >> _class >> "displayName");
            [_totalTax] call A3PL_Bank_HowToPay;
            waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
            if (!(player getVariable "paymentResult")) exitWith {_exit = true;};
            (createVehicle ["GroundWeaponHolder", getposATL player, [], 0, "CAN_COLLIDE"]) addItemCargoGlobal [_class,_takeAmount];
		};
		case "headgear":
		{
			_itemName = getText (configFile >> "CfgWeapons" >> _class >> "displayName");
            [_totalTax] call A3PL_Bank_HowToPay;
            waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
            if (!(player getVariable "paymentResult")) exitWith {_exit = true;};
            (createVehicle ["GroundWeaponHolder", getposATL player, [], 0, "CAN_COLLIDE"]) addItemCargoGlobal [_class,_takeAmount];
		};
		case "backpack": {
			_itemName = getText (configFile >> "CfgVehicles" >> _class >> "displayName");
            [_totalTax] call A3PL_Bank_HowToPay;
            waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
            if (!(player getVariable "paymentResult")) exitWith {_exit = true;};
            (createVehicle ["GroundWeaponHolder", getposATL player, [], 0, "CAN_COLLIDE"]) addItemCargoGlobal [_class,_takeAmount];
		};
		case "goggles": {
			_itemName = getText (configFile >> "CfgGlasses" >> _class >> "displayName");
            [_totalTax] call A3PL_Bank_HowToPay;
            waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
            if (!(player getVariable "paymentResult")) exitWith {_exit = true;};
            (createVehicle ["GroundWeaponHolder", getposATL player, [], 0, "CAN_COLLIDE"]) addItemCargoGlobal [_class,_takeAmount];
		};
		case "magazine": {
			_itemName = getText (configFile >> "CfgMagazines" >> _class >> "displayName");
            if !(["fsc",player] call A3PL_DMV_Check) exitWith {[("STR_A3PL_CompanyShop_NoFSCAmmo" call A3PL_Localize),Color_Red] call A3PL_Notification; _exit = true};
            [_totalTax] call A3PL_Bank_HowToPay;
            waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
            if (!(player getVariable "paymentResult")) exitWith {_exit = true;};
           player addMagazines [_class,_takeAmount];
		};
		case "weapon": {
			_itemName = getText (configFile >> "CfgWeapons" >> _class >> "displayName");
            if !(["fsc",player] call A3PL_DMV_Check) exitWith {[("STR_A3PL_CompanyShop_NoFSCWeapon" call A3PL_Localize),Color_Red] call A3PL_Notification; _exit = true};
            [_totalTax] call A3PL_Bank_HowToPay;
            waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
            if (!(player getVariable "paymentResult")) exitWith {_exit = true;};
            (createVehicle ["GroundWeaponHolder", getposATL player, [], 0, "CAN_COLLIDE"]) addWeaponCargoGlobal [_class,_takeAmount];
		};
		case "item": {
			_itemName = [_class,"name"] call A3PL_Config_GetItem;
            if ([_class,"canPickup"] call A3PL_Config_GetItem) then {
				if((([[_class,_takeAmount]] call A3PL_Inventory_TotalWeight) <= Player_MaxWeight) && ([_class, _takeAmount] call A3PL_InventoryNew_CanAddItem)) then {
                    [_totalTax] call A3PL_Bank_HowToPay;
                    waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
                    if (!(player getVariable "paymentResult")) exitWith {_exit = true;};
					[_class,_takeAmount] call A3PL_Inventory_Add;
				} else {
					_canTake = false;
				};
			} else {
				[_totalTax] call A3PL_Bank_HowToPay;
                waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
                if (!(player getVariable "paymentResult")) exitWith {_exit = true;};
                _veh = createVehicle [([_class,"class"] call A3PL_Config_GetItem), getposATL player, [], 0, "CAN_COLLIDE"];
				if (!([_class,"simulation"] call A3PL_Config_GetItem)) then {[_veh] remoteExec ["Server_Vehicle_EnableSimulation",2];};
				_veh setVariable ["class",_class,true];
				_veh setVariable ["owner",(player getVariable ["character_id",""]),true];
				private _pJob = player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
				if (_pJob IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) then {
					_veh setVariable ["job",_pJob,true];
				};
			};
		};
	};
	if(!_canTake) exitWith {[("STR_Common_NotEnoughSpace" call A3PL_Localize),Color_Red] call A3PL_Notification;};

    if (_exit) exitWith {};

    _stock = A3PL_Company_Building getVariable ["stock_selling",[]];
    {
        if(_x#1 isEqualTo _class) then {
            _x set [2,(_x#2 - _takeAmount)];
        };
    } foreach _stock;

    [A3PL_Company_Building,_stock,0] remoteExec ["Server_CompanyShop_Update",2];
    sleep 0.2;
    _control lbSetCurSel -1;
    [] call A3PL_CompanyShop_View_RefreshShopStock;

    
    _cid = A3PL_Company_Building getVariable ["cid", ""];
    _cName = [_cid, "name"] call A3PL_Config_GetCompanyData;
    
    ["company_shop"] call PO_Achievement_Learn;
    [format[("STR_A3PL_CompanyShop_PurchaseSuccess" call A3PL_Localize),_takeAmount,_itemName,_totalTax],Color_Green] call A3PL_Notification;
    [_cid, _price, format[("STR_A3PL_CompanyShop_ShopSale" call A3PL_Localize),_takeAmount,_itemName,(_price/_takeAmount)]] remoteExec ["Server_Company_SetBank",2];
	[_cid, getPos A3PL_Company_Building, _class, format["-%1",_takeAmount], _price, _type] remoteExec ["Server_CompanyShop_InsertLog",2];
	[("STR_Common_FederalReserve" call A3PL_Localize),(_totalTax-_price)] remoteExec ["Server_Government_AddBalance",2];

	[getPlayerUID player,(player getVariable ["character_id",""]),"CompanyShop_Buy",[format ["Company: %1 | Item: %2 | Amount: %3",(_cName),(_class),(_takeAmount)]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

['A3PL_CompanyShop_View_Sell', {
    private ["_display","_control","_control1","_itemData","_type","_class","_amount","_addAmount","_tax","_price","_limit","_pCash","_cid","_cBank","_pItems","_groupedItems","_index","_pos","_currentCount","_exit","_itemName","_accs","_found","_amt","_objString","_splitted","_typeOf","_veh","_stock","_totalTax","_cName"];
    if(!(call A3PL_Player_AntiSpam)) exitWith {};
	_display = findDisplay 130;
	_control = _display displayCtrl 1307;
	if ((lbCurSel _control) < 0) exitwith {[("STR_A3PL_CompanyShop_SelectAnItem" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_itemData = _control lbData (lbCurSel _control);

    _pCash = player getVariable ["player_cash",0];

    _cid = A3PL_Company_Building getVariable ["cid", ""];
    _cBank = [_cid, "bank"] call A3PL_Config_GetCompanyData;

    _pItems = assignedItems player + items player + magazines player;
    if ("Binocular" IN _pItems) then {_pItems = _pItems - ["Binocular"]};
    if ("Rangefinder" IN _pItems) then {_pItems = _pItems - ["Rangefinder"]};

    {
        if (_x isNotEqualTo "") then {
            _pItems pushBack _x;
        };
    } forEach ([handgunWeapon player] + [primaryWeapon player]);

    if (primaryWeaponMagazine player isNotEqualTo []) then {_pItems pushback (primaryWeaponMagazine player)#0;};
    if (handgunMagazine player isNotEqualTo []) then {_pItems pushback (handgunMagazine player)#0;};

    _groupedItems = [];
    { 
        _index = [_groupedItems, _x] call BIS_fnc_findNestedElement; 
        if (_index isEqualTo []) then { 
            _groupedItems pushBack [_x, 1]; 
        } else { 
            _pos = _index select 0; 
            _currentCount = (_groupedItems select _pos) select 1; 
            _groupedItems set [_pos, [_x, _currentCount + 1]]; 
        }; 
    } forEach _pItems;

    {
        if !(_x isEqualTo "") then {
            _groupedItems pushBack [_x,1];
        };
    } forEach ([uniform player] + [vest player] + [headgear player] + [goggles player] + [backpack player]);

    _tax = 0.95;

    _itemData = _itemData splitString ",";
	if(count(_itemData) < 3) exitWith {["Error while loading item info, please try again!",Color_Red] call A3PL_Notification;};
	_type = _itemData select 0;
    _control1 = _display displayCtrl 1304;
    if (_type IN ["item","magazine"]) then {
	    _addAmount = floor(parseNumber (ctrlText _control1));
    } else {
        _addAmount = 1;
        _control1 ctrlSetText "";
    };
    if(_addAmount < 0) exitWith {[("STR_A3PL_CompanyShop_EnterValidAmount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_class = _itemData select 1;
	_amount = parseNumber(_itemData select 2);
    _price = parseNumber(_itemData select 3);
    _limit = parseNumber(_itemData select 4);

    if ((_addAmount + _amount) > _limit) exitWith {[("STR_A3PL_CompanyShop_TooManyItems" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    if ((_addAmount * _price) > _cBank) exitWith {[("STR_A3PL_CompanyShop_InsufficientFunds" call A3PL_Localize),Color_Red] call A3PL_Notification;};

    _exit = false;
    if (_type isEqualTo "item") then {
        if (!([_class,_addAmount] call A3PL_Inventory_Has)) exitWith {[("STR_A3PL_CompanyShop_ItemNotInInventory" call A3PL_Localize),Color_Red] call A3PL_Notification; _exit = true;};
    } else {
        _found = false;
        {
            if (_class IN _x) then {
                _found = true;
                _amt = _x select 1;
            };
        } forEach _groupedItems;

        if !(_found) exitWith {[("STR_A3PL_CompanyShop_ItemNotInInventory" call A3PL_Localize),Color_Red] call A3PL_Notification; _exit = true;};
        if (_amt < _addAmount) exitWith {[("STR_A3PL_CompanyShop_NotEnoughItemInInventory" call A3PL_Localize),Color_Red] call A3PL_Notification; _exit = true;};
    };

    if (_exit) exitWith {};

    switch(_type) do {
		case "aitem": {
			_itemName = getText (configFile >> "CfgWeapons" >> _class >> "displayName");
            if (_class IN (assignedItems player)) then
			{
				player unAssignItem _class;
			};
			player removeItem _class;
		};
		case "uniform": {
            _itemName = getText (configFile >> "CfgWeapons" >> _class >> "displayName");
			if ((uniform player) isEqualTo _class) then {
				removeUniform player;
			};
		};
		case "vest": {
			_itemName = getText (configFile >> "CfgWeapons" >> _class >> "displayName");
            if ((vest player) isEqualTo _class) then {
				removeVest player;
			};
		};
		case "headgear": {
			_itemName = getText (configFile >> "CfgWeapons" >> _class >> "displayName");
            if ((headgear player) isEqualTo _class) then {
				removeHeadgear player;
			};
		};
		case "backpack": {
			_itemName = getText (configFile >> "CfgVehicles" >> _class >> "displayName");
            if ((backpack player) isEqualTo _class) then {
				removeBackpackGlobal player;
			};
		};
		case "goggles": {
			_itemName = getText (configFile >> "CfgGlasses" >> _class >> "displayName");
            if ((goggles player) isEqualTo _class) then {
				removeGoggles player;
			};
		};
		case "magazine": {
			_itemName = getText (configFile >> "CfgMagazines" >> _class >> "displayName");
            for "_i" from 0 to (_addAmount - 1) do {
				if (_class IN (assignedItems player)) then {
					player unAssignItem _class;
				};
				player removeItem _class;
			};
		};
		case "weapon": {
			_itemName = getText (configFile >> "CfgWeapons" >> _class >> "displayName");
            _found = false;
            _accs = ["","",""];
			{
				if (_x isEqualTo _class) exitWith {
                    if (primaryWeapon player isEqualTo _class) then {
                        if (primaryWeaponMagazine player isNotEqualTo []) then {player addMagazine (primaryWeaponMagazine player)#0;};
                    } else {
                        if (handgunMagazine player isNotEqualTo []) then {player addMagazine (handgunMagazine player)#0;};
                    };
					_accs = player weaponAccessories _class;
                    {
                        if (_x isNotEqualTo "") then {player addItem _x}
                    } forEach _accs;
                    player removeWeaponGlobal _x;
                    _found = true;
				};
			} forEach ([handgunWeapon player] + [primaryWeapon player]);
            if (_found) exitWith {};
			{
				if (_x isEqualTo _class) exitWith {
					_accs = [_class] call A3PL_Lib_GetWeaponAccsCargo;
                    {
                        if (_x isNotEqualTo "") then {player addItem _x}
                    } forEach _accs;
                    player removeItemFromUniform _x;
                    _found = true;
				};
			} forEach uniformItems player;
             if (_found) exitWith {};
			{
				if (_x isEqualTo _class) exitWith {
					_accs = [_class] call A3PL_Lib_GetWeaponAccsCargo;
                    {
                        if (_x isNotEqualTo "") then {player addItem _x}
                    } forEach _accs;
                    player removeItemFromVest _x;
                    _found = true;
				};
			} forEach vestItems player;
             if (_found) exitWith {};
			{
				if (_x isEqualTo _class) exitWith {
					_accs = [_class] call A3PL_Lib_GetWeaponAccsCargo;
                    {
                        if (_x isNotEqualTo "") then {player addItem _x}
                    } forEach _accs;
                    player removeItemFromBackpack _x;
                    _found = true;
				};
			} forEach backpackItems player;
		};
		case "item": {
			_itemName = [_class,"name"] call A3PL_Config_GetItem;
            if(count(_itemData) isEqualTo 4) then {
				_objString = _itemData select 3;
				_splitted = _objString splitString "_";
				if ((_splitted select 0) isEqualTo "OBJ") then
				{
					_typeOf = toArray _objString;
					_typeOf deleteAt 0;_typeOf deleteAt 0;_typeOf deleteAt 0;_typeOf deleteAt 0;
					_typeOf = toString _typeOf;
					_veh = [_typeOf] call A3PL_Lib_vehStringToObj;
					deleteVehicle _veh;
				};
			};
			[_class,-(_addAmount)] call A3PL_Inventory_Add;
		};
	};

    _stock = A3PL_Company_Building getVariable ["stock_buying",[]];
    {
        if(_x#1 isEqualTo _class) then {
            _x set [2,(_x#2 + _addAmount)];
        };
    } foreach _stock;

    [A3PL_Company_Building,_stock,1] remoteExec ["Server_CompanyShop_Update",2];
    sleep 0.2;
    _control lbSetCurSel -1;
    [] call A3PL_CompanyShop_View_RefreshShopStock;

    ["company_shop"] call PO_Achievement_Learn;

    _totalTax = floor ((_price * _addAmount) * _tax);
    player setVariable ["player_cash",(_pCash + _totalTax),true];
    
    [format[("STR_A3PL_CompanyShop_SellSuccess" call A3PL_Localize),_addAmount,_itemName,_totalTax],Color_Green] call A3PL_Notification;
    [_cid, -(_price * _addAmount), format[("STR_A3PL_CompanyShop_ShopPurchase" call A3PL_Localize),_addAmount,_itemName,_price]] remoteExec ["Server_Company_SetBank",2];
	[_cid, getPos A3PL_Company_Building, _class, format["+%1",_addAmount], (_price * _addAmount), _type] remoteExec ["Server_CompanyShop_InsertLog",2];
	[("STR_Common_FederalReserve" call A3PL_Localize),((_price * _addAmount) - _totalTax)] remoteExec ["Server_Government_AddBalance",2];
    
	_cName = [_cid, "name"] call A3PL_Config_GetCompanyData;
	[getPlayerUID player,(player getVariable ["character_id",""]),"CompanyShop_Deposit",[format ["Company: %1 | Item: %2 | Amount: %3",(_cName),(_class),(_addAmount)]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;