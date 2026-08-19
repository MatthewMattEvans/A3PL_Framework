/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
#define HOUSESLIST ["Land_Home1g_DED_Home1g_01_F","Land_Home2b_DED_Home2b_01_F","Land_Home3r_DED_Home3r_01_F","Land_Home4w_DED_Home4w_01_F","Land_Home5y_DED_Home5y_01_F","Land_Home6b_DED_Home6b_01_F","Land_Mansion01","Land_A3PL_Ranch3","Land_A3PL_Ranch2","Land_A3PL_Ranch1","Land_A3PL_ModernHouse1","Land_A3PL_ModernHouse2","Land_A3PL_ModernHouse3","Land_A3PL_BostonHouse","Land_A3PL_Shed3","Land_A3PL_Shed4","Land_A3PL_Shed2","Land_John_House_Grey","Land_John_House_Blue","Land_John_House_Red","Land_John_House_Green","Land_A3FL_Mansion","Land_A3FL_Office_Building","Land_A3FL_House1_Cream","Land_A3FL_House1_Green","Land_A3FL_House1_Blue","Land_A3FL_House1_Brown","Land_A3FL_House1_Yellow","Land_A3FL_House2_Cream","Land_A3FL_House2_Green","Land_A3FL_House2_Blue","Land_A3FL_House2_Brown","Land_A3FL_House2_Yellow","Land_A3FL_House3_Cream","Land_A3FL_House3_Green","Land_A3FL_House3_Blue","Land_A3FL_House3_Brown","Land_A3FL_House3_Yellow","Land_A3FL_House4_Cream","Land_A3FL_House4_Green","Land_A3FL_House4_Blue","Land_A3FL_House4_Brown","Land_A3FL_House4_Yellow","Land_A3FL_Anton_Modern_Bungalow","Land_A3FL_Trailer","Land_A3FL_Trailer_2","Land_A3FL_Trailer_3","Land_A3FL_Trailer_4","Land_A3FL_Trailer_5","Land_A3FL_Trailer_6","Land_FYD_PARRAS_BigModernHouse","Land_FYD_Parras_Modern_House","Land_FYD_Parras_Modern_House_02","Land_FYD_Parras_Modern_House_03","Land_FYD_Parras_Modern_House_04"]

["Server_Housing_SaveItems",
{
	private _delete = param [0,false];
	{
		private _house = _x;
		private _items = nearestObjects [_house, [],30];
		private _itemsToSave = [];
		{
			if (typeOf _x IN ["A3PL_WheelieBin"]) exitWith {};
			if (!isNil {_x getVariable "class"} && ((nearestObjects[_x, HOUSESLIST, 30])#0 isEqualTo _house)) then {
				_itemsToSave pushback _x;
			};
		} foreach _items;
		private _pItems = [];
		{
			_pItems pushback [(typeOf _x),(_x getVariable "class"),getPosASL _x,getDir _x];
			if (_delete) then {deleteVehicle _x; _house setVariable ["furn_loaded",false,true];};
		} foreach _itemsToSave;
		private _myItems = str(_pItems);
		private _query = format ["UPDATE houses SET pitems='%1' WHERE location ='%2'",_myItems,(getpos _house)];
		[_query,1] spawn Server_Database_Async;
	} foreach Server_HouseList;
}] call compile_Server;

["Server_Housing_LockUnlockFurnitures",
{
	private _player = param [0,objNull];
	private _house = param [1,objNull];
	private _items = nearestObjects [_house, [],30];
	private _itemsToLock = [];
	{
		if (typeOf _x IN ["A3PL_WheelieBin"]) exitWith {};
		if (!isNil {_x getVariable "class"} && ((nearestObjects[_x, HOUSESLIST, 30])#0 isEqualTo _house)) then {
			_itemsToLock pushback _x;
		};
	} foreach _items;
	private _lockStatus = !(_itemsToLock#0 getVariable ["locked",false]);
	diag_log _player;
	diag_log _house;
	{
		_x setVariable ["locked",_lockStatus,true];
	} foreach _itemsToLock;
	if (_lockStatus) then {
		_lockStatus = 1;
		["STR_A3PL_Placeables_FurnituresLocked" call A3PL_Localize, Color_Green] remoteExec ["A3PL_Notification", _player];
	} else {
		["STR_A3PL_Placeables_FurnituresUnlocked" call A3PL_Localize, Color_Green] remoteExec ["A3PL_Notification", _player];
		_lockStatus = 0;
	};
	private _query = format ["UPDATE houses SET itemslocked='%1' WHERE location ='%2'",_lockStatus,(getpos _house)];
	[_query,1] spawn Server_Database_Async;
}] call compile_Server;

["Server_Housing_LoadItems",
{
	{
		private _house = _x;
		if (_house getVariable ["furn_loaded",false]) then {continue; diag_log "Furniture already spawned";};
		_house setVariable ["furn_loaded",true,true];

		private _query = format ["SELECT pitems, itemslocked FROM houses WHERE location = '%1'", (getpos _house)];
		private _result = [_query, 2] call Server_Database_Async;
		private _pItems = _result select 0;
		private _itemsLocked = _result select 1;

		private _locked = false;
		if (!isNil "_itemsLocked" && (_itemsLocked) isEqualTo 1) then { _locked = true; };

		private _allOwners = _house getVariable ["owner",[]];
		private _objects = [];
		{
			private _classname = _x#0;
			private _class = _x#1;
			private _pos = _x#2;
			private _dir = _x#3;
			private _obj = createVehicle [_classname, _pos, [], 0, "CAN_COLLIDE"];
			if (!([_class,"simulation"] call A3PL_Config_GetItem)) then {[_obj] call Server_Housing_LoadItemsSimulation;};
			_obj setDir _dir;
			_obj setPosASL _pos;
			_obj setVariable ["owner",_allOwners,true];
			_obj setVariable ["class",_class,true];
			_obj setVariable ["locked",_locked,true];
		} foreach _pItems;
	} foreach Server_HouseList;
}] call compile_Server;

["Server_Housing_LoadItemsSimulation",
{
	private _object = param [0,[]];
	_object enableSimulationGlobal false;
}] call compile_Server;

["Server_Housing_LoadBox",
{
    private _player = param [0,objNull];
    private _house = param [1,objNull];
     if (isNull _house || isNull _player) exitWith {
        diag_log "ERROR: Server_Housing_LoadBox - Invalid house or player";
    };
    if (!isNil {_house getVariable "box_spawned"}) exitWith {};
    
    _house setVariable ["box_spawned", true, false];
    _house setVariable ["box_loading", true, false];
    
    private _pos = getposATL _player;
    _pos = [_pos select 0, _pos select 1, ((_pos select 2) + 0.25)];
    
    private _items = [[],[],[]];
    private _vItems = [[],[],[]];
    
    if (isDedicated) then {
        private _dbResult = [format ["SELECT items FROM houses WHERE location = '%1'", (getpos _house)], 2, true] call Server_Database_Async;
        if (!isNil "_dbResult" && (count _dbResult) > 0) then {
            _items = _dbResult;
        } else {
            diag_log format ["WARNING: No items found for house at %1", getpos _house];
            _items = [[[], [], [], []]];
        };
    } else {
        _items = [[[], [], [], []]];
    };
    
    if (isDedicated) then {
        private _dbVResult = [format ["SELECT vitems FROM houses WHERE location = '%1'", (getpos _house)], 2, true] call Server_Database_Async;
        if (!isNil "_dbVResult" && (count _dbVResult) > 0) then {
            _vItems = _dbVResult;
        } else {
            _vItems = [["[]"]];
        };
    } else {
        _vItems = [["[]"]];
    };
    
    private _box = createVehicle ["Box_GEN_Equip_F", _pos, [], 0, "CAN_COLLIDE"];
    if (isNull _box) exitWith {
        diag_log "ERROR: Failed to create storage box";
        _house setVariable ["box_spawned", nil, false];
        _house setVariable ["box_loading", nil, false];
    };
    

    _box allowDamage false;
    _box enableSimulation false;
    
    
    clearItemCargoGlobal _box;
    clearWeaponCargoGlobal _box;
    clearMagazineCargoGlobal _box;
    clearBackpackCargoGlobal _box;
    
    
    private _cargoData = ((_items select 0) select 0);
    
    if (!isNil "_cargoData") then {
        private _weapons = if (count _cargoData > 0) then {_cargoData select 0} else {[]};
        private _magazines = if (count _cargoData > 1) then {_cargoData select 1} else {[]};
        private _actualItems = if (count _cargoData > 2) then {_cargoData select 2} else {[]};
        private _backpacks = if (count _cargoData > 3) then {_cargoData select 3} else {[]};
        
        {if (typeName _x == "STRING" && _x != "") then {_box addWeaponCargoGlobal [_x, 1]}} foreach _weapons;
        {if (typeName _x == "STRING" && _x != "") then {_box addMagazineCargoGlobal [_x, 1]}} foreach _magazines;
        {if (typeName _x == "STRING" && _x != "") then {_box addItemCargoGlobal [_x, 1]}} foreach _actualItems;
        {if (typeName _x == "STRING" && _x != "") then {_box addBackpackCargoGlobal [_x, 1]}} foreach _backpacks;
    };
    
    private _virtualStorage = [];
    if (!isNil "_vItems" && count _vItems > 0) then {
        private _vData = (_vItems select 0) select 0;
        if (typeName _vData == "STRING" && _vData != "") then {
            _virtualStorage = call compile _vData;
        };
    };
    _box setVariable ["storage", _virtualStorage, true];
    
    private _sCapacity = [_house, 2] call A3PL_Housing_GetData;
    if (isNil "_sCapacity") then {_sCapacity = 10000};
    _box setVariable ["capacity", _sCapacity, true];
    
    _house setVariable ["box_object", _box, true];
    _house setVariable ["box_loading", nil, false];
    _box allowDamage false;
    _box setPosATL _pos;
    
}] call compile_Server;

["Server_Housing_SaveBox",
{
    private _house = param [0, objNull];
    private _box = param [1, objNull];
    
    if (isNull _house || isNull _box) exitWith {
        diag_log "ERROR: Server_Housing_SaveBox - Invalid house or box";
    };
    if (!isNil {_house getVariable "box_saving"}) exitWith {
        diag_log "WARNING: Box save already in progress";
    };
    
    _house setVariable ["box_saving", true, false];
    
    private _pos = getpos _house;
    
    
    private _weapons = weaponCargo _box;
    private _magazines = magazineCargo _box;
    private _aitems = itemCargo _box;
    private _backpacks = backpackCargo _box;
    
    {
        private _idx = _forEachIndex;
        private _item = _x;
        
        if (["a3pl_iphone", _item] call BIS_fnc_inString) then {
            _aitems set [_idx, "a3pl_iphone_1"];
        };
        if (["a3pl_3310", _item] call BIS_fnc_inString) then {
            _aitems set [_idx, "a3pl_3310_1"];
        };
        if (["a3pl_sonySD", _item] call BIS_fnc_inString) then {
            _aitems set [_idx, "a3pl_sonySD_1"];
        };
        if (["a3pl_sonyFD", _item] call BIS_fnc_inString) then {
            _aitems set [_idx, "a3pl_sonyFD_1"];
        };
    } foreach _aitems;
    
    private _items = [_weapons, _magazines, _aitems, _backpacks];
    private _itemsStr = str _items;
    private _virtualStorage = _box getVariable ["storage", []];
    private _storageStr = str _virtualStorage;
    
    if ((count _items) > 0 && _itemsStr != "") then {
        if (isDedicated) then {
            private _query = format ["UPDATE houses SET items='%1', vitems='%2' WHERE location='%3'", 
                _itemsStr, 
                _storageStr, 
                _pos];
            
            [_query, 1] spawn {
                private _q = _this;
                private _result = _q call Server_Database_Async;
                if (isNil "_result") then {
                    diag_log "ERROR: Failed to save house storage to database";
                };
            };
        };
    } else {
        diag_log "WARNING: No items to save";
    };
    
    sleep 0.5;
    
    _house setVariable ["box_object", nil, true];
    _house setVariable ["box_spawned", nil, false];
 
    if (!isNull _box) then {
        _box allowDamage true;
        deleteVehicle _box;
    };
    
    _house setVariable ["box_saving", nil, false];
    
}] call compile_Server;

["Server_Housing_Initialize",
{
	private ["_houses","_query","_return","_charids","_pos","_doorID","_near","_signs"];
	_houses = ["SELECT charids, location, doorid FROM houses", 2, true] call Server_Database_Async;
	{
		private ["_pos","_charids","_doorid"];
		_charids = [(_x select 0)] call Server_Database_ToArray;
		_pos = call compile (_x select 1);
		_doorid = _x select 2;

		_near = nearestObjects [_pos,HOUSESLIST,10];
		if ((count _near) isEqualTo 0) then {
			_query = format ["CALL RemovedHouse('%1');",_pos];
			[_query,1] spawn Server_Database_Async;
		} else {
			_near = _near select 0;
    		// if (_pos isNotEqualTo (getpos _near)) then
			// {
			// 	_query = format ["UPDATE houses SET location='%1', classname = '%3' WHERE location ='%2'",(getpos _near),_pos, (typeOf _near)];
			// 	[_query,1] spawn Server_Database_Async;
			// };
			_signs = nearestObjects [_pos, ["Land_A3PL_EstateSign"],25];
			if (count _signs > 0) then
			{
			    (_signs select 0) setObjectTextureGlobal [0,"\A3PL_Objects\Street\estate_sign\house_rented_co.paa"];
			    (_signs select 0) setVariable["roommates",_charids,true];
			};

			_near setVariable ["doorID",[_charids,_doorid],true];
			_near setVariable ["owner",_charids, true];
			if (!(_near IN Server_HouseList)) then {
			Server_HouseList pushback _near;
			};
		};
	} foreach _houses;
}] call compile_Server;

["Server_Housing_AssignHouse",
{
	private _object = param [0,objNull];
	private _player = param [1,objNull];
	private _takeMoney = param [2,true];
	private _price = param [3,0];
	private _charID = (_player getVariable ["character_id",""]);

	_object setVariable ["owner",[_charID],true];

	if (_takeMoney) then {
		_player setVariable ["player_bank",((_player getVariable ["player_bank",0]) - _price),true];
	};
	
	private _keyID = [_player,_object,"",false,"house"] call Server_Housing_CreateKey;
	if (!(_object IN Server_HouseList)) then {
		Server_HouseList pushback _object;
	};

	private _pos = getpos _object;
	private _charID = [[_charID]] call Server_Database_Array;
	private _insert = format ["INSERT INTO houses (charids,classname,location,doorid,items,pitems) VALUES ('%1','%2','%3','%4','[[],[],[]]','[]') ON DUPLICATE KEY UPDATE doorID='%4'",_charID,typeOf _object,_pos,_keyID];
	[_insert,1] spawn Server_Database_Async;

	_player setVariable ["house",_object,true];
	private _var = _player getVariable ["apt",nil];
	if (!isNil "_var") then
	{
		[_player] call Server_Housing_UnAssignApt;
		_player setVariable ["apt",Nil,true];
		_player setVariable ["aptnumber",Nil,true];
	};

	_signs = nearestObjects [_object, ["Land_A3PL_EstateSign"], 20];
	if (count _signs > 0) then {
		(_signs select 0) setObjectTextureGlobal [0,"\A3PL_Objects\Street\estate_sign\house_rented_co.paa"];
	};
}] call compile_Server;

["Server_Housing_SetPosApt",
{
	private _player = param [0,objNull];
	private _apt = _player getVariable ["apt",nil];
	private _aptNumber = _player getVariable ["aptNumber",nil];
	if ((isNil "_apt") OR (isNil "_aptnumber")) exitwith {};
	private _posApts = [[0.0732422,8.21582],[0.723145,2.35547],[0.729004,-2.39551],[1.8501,-8.38477],[1.23389,8.32764],[1.61963,2.26953],[1.50342,-2.50537],[1.67139,-8.31201]];
	private _posAptsATL = [0.231,0.231,0.231,0.231,3.00974,3.00974,3.00974,3.00974];

	_player allowDamage false;

	private _posAptATL = _apt modelToWorld (_posApts#(_aptNumber-1));
	_player setposATL [(_posAptATL#0),(_posAptATL#1),(_posAptsATL#(_aptNumber-1))];

	_player allowDamage true;
}] call compile_Server;

["Server_Housing_AssignApt",
{
	params[["_player",objNull],["_spawnPos",[6548.25,7552.95,0]],["_moveTo",false]];
	private ["_objToAssign"];
	private _list = nearestObjects [_spawnPos, ["Land_A3PL_Motel"], 5000];
	{
		private ["_assigned"];
		_assigned = _x getVariable ["Server_AptAssigned",[]];
		if (count _assigned < 8) exitwith {_objToAssign = _x;};
	} foreach _list;
	if (isNil "_objToAssign") exitwith {diag_log "Error assigning apartment to player: None available"};

	private _var = _objToAssign getVariable ["Server_AptAssigned",[]];
	private _cannotAssign = [];

	{
		_cannotAssign pushback (_x#0);
	} foreach _var;

	private _AptToAssign = 1;
	while {_AptToAssign IN _cannotAssign} do {
		_AptToAssign = _AptToAssign + 1;
	};

	_var pushBack [_AptToAssign,_player];
	_objToAssign setVariable ["Server_AptAssigned",_var,false];
	_player setVariable ["apt",_objToAssign,true];
	_player setVariable ["aptNumber",_AptToAssign,true];
	[_objToAssign,_AptToAssign] remoteExec ["A3PL_Housing_AptAssignedMsg",_player];

	private _doorName = format ["door_%1",_AptToAssign];
	[_player,_objToAssign,_doorName,false,"motel"] call Server_Housing_CreateKey;
	_objToAssign setVariable [(format ["Door_%1_locked",_AptToAssign]),false,true];
	if(_moveTo) then {[_player] call Server_Housing_SetPosApt;};
}] call compile_Server;

["Server_Housing_UnAssignApt",
{
	private ["_var","_obj","_var1"];
	params[["_player",objNull]];
	private _apt = _player getVariable ["apt",nil];
	if(isNil "_apt") exitwith {};
	private _var = _apt getVariable ["Server_AptAssigned",[]];
	{
		if ((_x#1) isEqualTo _player) exitwith {
			_var deleteAt _forEachIndex;
			_apt setVariable ["Server_AptAssigned",_var,false];
		};
	} foreach _var;
}] call compile_Server;

["Server_Housing_PickupKey",
{
	private ["_object","_keyID","_keys"];
	_object = _this select 0;
	if (isNull _object) exitwith {};
	_player = _this select 1;

	if (_object getVariable ["inuse",false]) exitwith {};
	_object setVariable ["inuse",true,false];
	deleteVehicle _object;

	_keyID = _object getVariable "keyID";
	if (isNil "_keyID") exitwith {};
	_keys = _player getVariable "keys";

	_keys pushBack _keyID;
	_player setvariable ["keys",_keys,true];
}] call compile_Server;

["Server_Housing_dropKey",
{
	private ["_object","_keyID","_keys"];
	_object = _this select 0;
	if (isNull _object) exitwith {};
	_player = _this select 1;
	_keys = _player getVariable "keys";
	_keyID = _object getVariable "keyID";
	{
		if (_x == _keyID) exitwith
		{
			_keys deleteAt _forEachIndex;
		};
	} foreach _keys;
	_player setVariable ["keys",_keys,true];
}] call compile_Server;

["Server_Housing_CreateKey",
{
	private ["_obj","_keys","_player","_id","_name"];
	_player = param [0,objNull];
	_charID = (_player getVariable ["character_id",""]);
	_obj = param [1,objNull];
	_door = param [2,objNull];
	_saveKey = param [3,true];
	_id = "";
	_name = param [4,""];


	if (!(_obj isKindOf "house")) exitwith {};

	if (_name == "motel") then
	{
		private ["_var"];
		_name = _this select 2;
		_var = _obj getVariable ["doorID",[]];
		_keyNames = ["door_1","door_2","door_3","door_4","door_5","door_6","door_7","door_8"];
		_playerKeys = _player getVariable ["keys",[]];

		{
			if(_x IN _keyNames) then {
				_playerKeys deleteAt _forEachIndex;
			};
		} forEach _playerKeys;

		_id = _door;
		_var pushback [[_charID],_door,_name];

		_obj setVariable ["doorID",_var,true];
		_player setVariable["keys",_playerKeys,true];
	};

	if(_name == "warehouse") then {
	_id = [8] call Server_Housing_GenerateID;
	_obj setVariable ["doorID",[_charID,_id],true];
	};

	if(_name == "crackhouse") then {
	_id = [9] call Server_Housing_GenerateID;
	_obj setVariable ["doorID",[_charID,_id],true];
	};

	if(_name == "house") then {
	_id = [5] call Server_Housing_GenerateID;
	_obj setVariable ["doorID",[_charID,_id],true];
	};

	if(_name == "greenhouse") then {
		_id = [4] call Server_Housing_GenerateID;
		_obj setVariable ["doorID",[_charID,_id],true];
	};


	_keys = _player getVariable ["keys",[]];
	_keys pushback _id;
	_player setVariable ["keys",_keys,true];

	if (_name == "house") then
	{
		if (_saveKey) then
		{
			_query = format ["UPDATE houses SET doorid='%1' WHERE location ='%2'",_id,(getpos _obj)];
			[_query,1] spawn Server_Database_Async;
		};
		[_player] call Server_Housing_SaveKeys;
	};
	if (_name == "warehouse") then
	{
		if (_saveKey) then
		{
			_query = format ["UPDATE warehouses SET doorid='%1' WHERE location ='%2'",_id,(getpos _obj)];
			[_query,1] spawn Server_Database_Async;
		};
		[_player] call Server_Housing_SaveKeys;
	};
	if (_name == "crackhouse") then
	{
		if (_saveKey) then
		{
			_query = format ["UPDATE crackhouses SET doorid='%1' WHERE location ='%2'",_id,(getpos _obj)];
			[_query,1] spawn Server_Database_Async;
		};
		[_player] call Server_Housing_SaveKeys;
	};
	_id;
}] call compile_Server;

['Server_Housing_SaveKeys',
{
	private ["_charID","_player","_keys"];
	_player = param [0,objNull];
	_charID = param [1,(_player getVariable ["character_id",""])];
	_keys = _player getVariable "keys";

	if (isNil "_keys") exitwith {};
	_query = format ["UPDATE players SET userkey='%1' WHERE charid ='%2'",([_keys] call Server_Database_Array),_charID];
	[_query,1] spawn Server_Database_Async;
}] call compile_Server;


["Server_Housing_GenerateID",
{
	private ['_r','_return','_digits'];
	_digits = _this select 0;

	_r = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"];
	_return = [];
	for "_i" from 1 to _digits do
	{
		_return pushback (_r select (floor (random (count _r - 1))));
	};
	_return = _return joinString "";
	_return;
}] call compile_Server;

["Server_Housing_Sold",
{
	params [
		["_pos",[0,0,0],[[]]],
		["_clientPart",0,[0]],
		["_sign",objNull,[objNull]],
		["_house",objNull,[objNull]]
	];
	
	_charIDs = _house getVariable ["owner",[]];
	_charID = _charIDs select 0;

	{
		if((_x getVariable ["character_id",""]) isEqualTo _charID) then {
			_hasBankAccount = (_x getVariable ["Player_BankActive",0]) isnotEqualTo 0;
			if (!_hasBankAccount) exitWith {[("Server_Housing_DoNotHaveBankAccount" call A3PL_Localize),Color_Green] remoteExec["A3PL_Notification",_x];};
		};
	} forEach allPlayers;
	
	_sign setVariable["houseSelling",false,true];
	_sign setObjectTextureGlobal [0,"\A3PL_Objects\Street\estate_sign\house_sale_co.paa"];

	_id = (_house getVariable ["doorid",[]]) select 1;
	_query = format ["DELETE FROM houses WHERE location ='%1'",getPos(_house)];
	[_query,1] spawn Server_Database_Async;


	_house setVariable ["owner",nil,true];
	_house setVariable ["doorid",nil,true];

	_furnitures = nearestObjects [_pos, ["Thing"],100];
	{if((_x getVariable "owner") isEqualTo _charID) then {deleteVehicle _x;};} foreach _furnitures;

	{
		if((_x getVariable ["character_id",""]) isEqualTo _charID) then {
			_pBank = _x getVariable["Player_Bank",0];
			_keys = _x getVariable["keys",[]];
			_x setVariable["Player_Bank",_pBank + _clientPart,true];
			_x setVariable ["house",nil,true];
			_x setVariable ["keys",_keys - [_id],true];
			[format[("Server_Housing_YouSellHouse" call A3PL_Localize),_clientPart], Color_Green] remoteExec ["A3PL_Notification",_x];
		};
	} foreach allPlayers;
	if(count(_charIDs) > 1) then {
		for "_i" from 1 to count(_charIDs)-1 do {
			private ["_roommate","_keys"];
			_roomate = [_x] call A3PL_Lib_charIDToObject;
			_keys = _roomate getVariable["keys",[]];
			_roomate setVariable ["house",nil,true];
			_roomate setVariable ["keys",_keys - [_id],true];
		};
	};
}] call compile_Server;

["Server_Housing_AddMember",
{
	_owner = param [0,objNull];
	_new = param [1,objNull];
	_house = param [2,objNull];

	_actuals = _house getVariable "owner";

	if((_actuals find (_new getVariable ["character_id",""])) != -1) exitWith {};

	_actuals pushback(_new getVariable ["character_id",""]);
	_house setVariable["owner", _actuals,true];

	_actuals = [_actuals] call Server_Database_Array;
	_query = format ["UPDATE houses SET charids='%1' WHERE location ='%2'",_actuals,(getpos _house)];
	[_query,1] spawn Server_Database_Async;

	//Give new member key and set var
	_new setVariable ["house",_house,true];
	_var = _new getVariable ["apt",nil];
	if (!isNil "_var") then
	{
		//unassign appartment, just in case
		[_new] call Server_Housing_UnAssignApt;
		//Nil apt variable, just in case
		_new setVariable ["apt",nil,true];
		_new setVariable ["aptnumber",nil,true];
	};
	_keysid = (_house getVariable ["doorID",[]]) select 1;
	_keys = _new getVariable ["keys",[]];
	_keys pushBack _keysid;

	_new setVariable ["keys",_keys,true];

	[("Server_Housing_YouAreNowRoomate" call A3PL_Localize),Color_Green] remoteExec ["A3PL_Notification",owner _new];
	[_house] remoteExec ["A3PL_Housing_SetMarker",_new];
}] call compile_Server;

["Server_Housing_RemoveMember",
{
	_old = param [0,objNull];
	_house = param [1,objNull];
	_charID = _old getVariable ["character_id",""];
	_allMembers = _house getVariable "owner";
	if((_allMembers find _charID) != -1) then {
		_allMembers deleteAt (_allMembers find _charID);
		_house setVariable["owner", _allMembers,true];

		_allMembers = [_allMembers] call Server_Database_Array;
		_query = format ["UPDATE houses SET charids='%1' WHERE location ='%2'", _allMembers, (getpos _house)];
		[_query,1] spawn Server_Database_Async;

		[_old] call Server_Housing_AssignApt;

		_keys = _old getVariable ["keys",[]];
		_id = (_house getVariable "doorid") select 1;
		_old setVariable ["keys",_keys - [_id],true];
		_old setVariable ["house",nil,true];
		[("Server_Housing_YoureNotRoomateAnymore" call A3PL_Localize),Color_Yellow] remoteExec ["A3PL_Notification",owner _old];
	};
}] call compile_Server;

["Server_Housing_RemoveOfflineKey",
{
	params[
		["_removalID", "", [""]],
		["_houseID", "", [""]]
	];

	private _query = format ["SELECT userkey FROM players WHERE charid='%1'", _removalID];
	private _result = [_query, 2] call Server_Database_Async;

	private _keys = [(([(_result select 0)] call Server_Database_ToArray) - [_houseID])] call Server_Database_Array;

	private _query = format ["UPDATE players SET userkey='%1' WHERE charid='%2'", _keys, _removalID];
	[_query, 1] call Server_Database_Async;
}] call compile_Server;

["Server_Housing_RemoveMemberOffline",
{
	params[
		["_player", objNull, [objNull]],
		["_removedRoommate", "", [""]]
	];

	private _house = _player getVariable ["house", objNull];
	private _members = _house getVariable ["owner", []];

	// If the removed roommate is actually a member of the house
	if ((_members find _removedRoommate) != -1) then {
		// Remove from members array
		_members deleteAt (_members find _removedRoommate);
		_house setVariable ["owner", _members, true];

		// Prepare members array for query
		_members = [_members] call Server_Database_Array;

		// Update in database
		_query = format ["UPDATE houses SET charids='%1' WHERE location='%2'", _members, (getpos _house)];
		[_query, 1] call Server_Database_Async;

		// Remove house key from player
		private _houseID = ((_house getVariable ["doorid", []]) select 1);
		[_removedRoommate, _houseID] call Server_Housing_RemoveOfflineKey;

		[("Server_Housing_YouKickedRoomate" call A3PL_Localize), Color_Green] remoteExec ["A3PL_Notification", (owner _player)];
	} else {
		["There was an error removing an offline roommate, please try again.", Color_Red] remoteExec ["A3PL_Notification", (owner _player)];
	};
}] call compile_Server;

["Server_Housing_GetRoommates",
{
	//private _player = param[0, objNull];
	//private _house = param[1, objNull];

	params[
		["_player", objNull, [objNull]]
	];

	private _house = _player getVariable ["house", objNull];

	// If the player does not have a house
	if (isNull _house) exitWith {
		[("Server_Housing_YouDontHaveHouse" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", (owner _player)];
	};

	// Get the owner array, e.g. ["steamid64_1","steamid64_2",...]
	private _charIDs = _house getVariable ["owner", []];

	// Only the house owner can use this
	if (!((_player getVariable ["character_id",""]) isEqualTo (_charIDs select 0))) exitWith {
		[("Server_Housing_OnlyOwnerCanRemoveRoommate" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", (owner _player)];
	};

	private _names = [];

	// Loop through each CharID and pull their name from the DB
	{
		private _query = format ["SELECT name FROM players WHERE charid = '%1'", _x];
		private _result = [_query, 2] call Server_Database_Async;
		_names pushBack ([_x, _result select 0]);
	} foreach _charIDs;

	// Send the names and IDs back to the client so we can pull up the display
	[_names] remoteExec ["A3PL_Housing_RemoveRoommateReceive", (owner _player)];
}] call compile_Server;
