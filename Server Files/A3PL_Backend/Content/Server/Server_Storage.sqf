/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["Server_Storage_VehicleVirtual",
{
	private _veh = param [0,objNull];
	private _var = _veh getVariable ["owner",nil];
	if(isNil '_var') exitWith {};
	private _storage = _veh getVariable["storage",[]];
	private _finalStorage = [];
	{
		if(!((_x select 0) IN ["seed_marijuana","marijuana","cocaine","shrooms","cannabis_bud","cannabis_bud_cured","cannabis_grinded_5g","weed_bag_5g","weed_bag_10g","weed_bag_25g","weed_bag_50g","weed_bag_100g","weed_5g","weed_10g","weed_15g","weed_20g","weed_25g","weed_30g","weed_35g","weed_40g","weed_45g","weed_50g","weed_55g","weed_60g","weed_65g","weed_70g","weed_75g","weed_80g","weed_85g","weed_90g","weed_95g","weed_100g","jug_moonshine","turtle","drill_bit","diamond_ill","diamond_emerald_ill","diamond_ruby_ill","diamond_sapphire_ill","diamond_alex_ill","diamond_aqua_ill","diamond_tourmaline_ill","v_lockpick","zipties","Gunpowder","keycard","coca_paste","cocaine_base","cocaine_hydrochloride","net","jug","jug_green","jug_green_moonshine","ring","ringset","bracelet","crown","necklace","golden_dildo","calcium_carbonate","potassium_permangate","ammonium_hydroxide","acetone","hydrocloric_acid","sulphuric_acid","cyanide_pills","weed_bag_5g","weed_bag_10g","weed_bag_25g","weed_bag_50g","weed_bag_100g","cannabis_plant_stage1","cannabis_plant_stage2","cannabis_plant_stage3","cannabis_plant_stage4","weed_grinded_empty","weed_grinded_5","weed_grinded_10","weed_grinded_15","weed_grinded_20","weed_grinded_25","weed_grinded_30","weed_grinded_35","weed_grinded_40","weed_grinded_45","weed_grinded_50","weed_grinded_55","weed_grinded_60","weed_grinded_65","weed_grinded_70","weed_grinded_75","weed_grinded_80","weed_grinded_85","weed_grinded_90","weed_grinded_95","weed_grinded_100","blunt"])) then {_finalStorage pushback _x;};
	} foreach _storage;
	private _storage = [_finalStorage] call Server_Database_Array;
	private _toQuery = format ["UPDATE players_objects SET vstorage = '%1' WHERE id = '%2'",_storage,(_var select 1)];
	[_toQuery,1] spawn Server_Database_Async;
}] call compile_Server;

["Server_Storage_Vehicle",
{
	private _veh = param [0,objNull];
	private _var = _veh getVariable ["owner",[]];
	if(count(_var) isEqualTo 0) exitWith {};
	private _id = _var select 1;
	private _vehItems = getItemCargo _veh;
	private _vehMags = getMagazineCargo _veh;
	private _vehBackpacks = getBackpackCargo _veh;
	private _oldWeapons = getWeaponCargo _veh;
	private _whitelist = ["A3FL_Shield","srifle_LRR_F","srifle_LRR_SOS_F","A3FL_PepperSpray","A3FL_PoliceBaton","A3PL_High_Pressure","A3PL_Jaws","A3PL_FireAxe","A3PL_FireExtinguisher","A3PL_Pickaxe","A3PL_Shovel","A3PL_Paintball_Marker","A3PL_Paintball_Marker_Camo","A3PL_Paintball_Marker_PinkCamo","A3PL_Paintball_Marker_DigitalBlue","A3PL_Paintball_Marker_Green","A3PL_Paintball_Marker_Purple","A3PL_Paintball_Marker_Red","A3PL_Paintball_Marker_Yellow","hgun_Pistol_Signal_F"];
	private _vehWeapons = [[],[]];
	{
		private _className = _x;
		private _cfgWeapons = configFile >> "CfgWeapons" >> _className;
		private _isActualWeapon = false;

		if (isClass _cfgWeapons) then {
			private _type = getNumber (_cfgWeapons >> "type");
			_isActualWeapon = _type in [1, 2, 4];
		};

		if (_isActualWeapon) then {
			if (_className IN _whitelist) then {
				(_vehWeapons select 0) pushback _className;
				(_vehWeapons select 1) pushback ((_oldWeapons select 1) select _foreachIndex);
			};
		} else {
			(_vehWeapons select 0) pushback _className;
			(_vehWeapons select 1) pushback ((_oldWeapons select 1) select _foreachIndex);
		};
	} foreach (_oldWeapons select 0);
	private _inventory = [_vehItems,_vehMags,_vehBackpacks,_vehWeapons];
	if ((count (_vehItems select 0) isEqualTo 0) && (count (_vehMags select 0) isEqualTo 0) && (count (_vehBackpacks select 0) isEqualTo 0) && (count (_vehWeapons select 0) isEqualTo 0)) then {
		_inventory = [];
	} else {
		_inventory = [_inventory] call Server_Database_Array;
	};
	private _query = format ["UPDATE players_objects SET istorage = '%2' WHERE id = '%1'",_id,_inventory];
	[_query,1] spawn Server_Database_Async;
}] call compile_Server;

["Server_Storage_ReturnVehicles",
{
	private _player = param [0,objNull];
	private _charID = param [1,"-1"];
	private _impound = param [2,0];
	private _type = param [3,"vehicle"];
	private _cid = param [4,0];
	if (_charID == "-1") then {_charID = (_player getVariable ["character_id",""]);};
	private _query = "";
	if(_cid isEqualTo 0) then {
		_query = format ["SELECT id,class,customName,fuel,insurance,gasType,gasAmount,gps FROM players_objects WHERE (type LIKE '%4%3%4' AND plystorage = '1') AND (charid = '%1' AND impounded='%2') ORDER BY customName",_charID,_impound,_type,"%"];
	} else {
		_query = format ["SELECT id,class,customName,fuel,insurance,gasType,gasAmount,gps FROM players_objects WHERE (type = '%2' AND plystorage = '1') AND (cid = '%3' AND impounded='%1') ORDER BY customName",_impound,_type,_cid];
	};
	private _objects = [_query, 2, true] call Server_Database_Async;
	private _returnArray = [];
	{
		private _id = _x select 0;
		private _class = _x select 1;
		private _customName = _x select 2;
		private _fuel = _x select 3;
		private _insurance = _x select 4;
		private _gasType = _x select 5;
		private _gasAmount = _x select 6;
		private _gps = _x select 7;
		if (isNil "_gps") then { _gps = 0; };
		_returnArray pushBack [_id,_class,_customName,_fuel,_insurance,_gasType,_gasAmount,_gps];
	} foreach _objects;

	[_returnArray] remoteExec ["A3PL_Storage_VehicleReceive",_player];
}] call compile_Server;

["Server_Storage_ChangeVehicleName",
{
	private _vehiclePlate = param [0,""];
	private _vehicleNewName = param [1,""];
	private _toQuery = format ["UPDATE players_objects SET customName = '%1' WHERE id = '%2'",_vehicleNewName,_vehiclePlate];
	[_toQuery,1] spawn Server_Database_Async;
}] call compile_Server;

["Server_Fuel_Vehicle",
{
	private _veh = param [0,objNull];
	private _var = _veh getVariable ["owner",[]];
	if(count(_var) isEqualTo 0) exitWith {};
	private _id = _var select 1;
	private _query = format ["UPDATE players_objects SET fuel = '%2' WHERE id = '%1'",_id,(fuel _veh)];
	[_query,1] spawn Server_Database_Async;
}] call compile_Server;

["Server_Storage_RetrieveVehiclePos",
{
	private _class = param [0,""];
	private _player = param [1,objNull];
	private _id = param [2,-1];
	private _storage = param [3,[]];
	private _keyRecipient = param [4,_player];
	private _dir = nil;
	if (count _storage > 3) then {
		_dir = _storage select 3;
		_storage = [_storage select 0,_storage select 1,_storage select 2];
	};

	private _ebayCheck = [format ["SELECT onEbay FROM players_objects WHERE id = '%1'", _id], 2, false] call Server_Database_Async;
	if ((count _ebayCheck) > 0 && {(_ebayCheck select 0) isEqualTo 1}) exitWith {
		[("STR_A3PL_Storage_VehicleOnEbay" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
	};

	[format ["UPDATE players_objects SET plystorage = '0',impounded='0',spawn='1' WHERE id = '%1'",_id],1] spawn Server_Database_Async;
	private _db = [format ["SELECT fuel,color,numpchange,iscustomplate,material,istorage,tuning,damage,insurance,vstorage,cid,gasType,gasAmount,gps,vars FROM players_objects WHERE id = '%1'",_id], 2, false] call Server_Database_Async;
	private _suppressKeys = !(_keyRecipient isEqualTo _player);
	private _veh = [_class,_storage,_id,_player,false,false,_suppressKeys] call Server_Vehicle_Spawn;

	if(!isNil "_dir") then {_veh setDir _dir;};
	if (_veh isKindOf "Ship") then {
		_veh setpos _storage;
	} else {
		_veh setPosATL _storage;
	};
	if (_veh isKindOf "helicopter") then {
		_veh setOwner (owner _player);
	};

	if ((count _db) != 0) then {
		if(_db#0 < 0.1 && {_veh isKindOf "Ship"}) then {
			_veh setFuel 0.1;
		} else {
			_veh setFuel (_db select 0);
		};

		private _texture = (_db select 1);
		private _splitted = _texture splitString "";
		if((_splitted select 0) isEqualTo '[') then {_texture = [_texture] call Server_Database_ToArray;};
		if(_texture isEqualType []) then {
			{
				_veh setObjectTextureGlobal[_foreachIndex,_x];
			} foreach _texture;
		} else {
			if(!(_texture isEqualTo "<null>")) then {
				_veh setObjectTextureGlobal [0,_texture];
			};
		};
		

		if((_db select 4) != "<null>") then {
			_veh setObjectMaterialGlobal [0,(_db select 4)];
		};
		_veh setVariable["numPChange",(_db select 2),true];
		_veh setVariable["isCustomPlate",(_db select 3),true];
		if((_db select 8) isEqualTo 1) then {
			_veh setVariable["insurance",true,true];
		} else {
			_veh setVariable["insurance",false,true];
		};

		private _iInventory = [(_db select 5)] call Server_Database_ToArray;
		if ((count _iInventory) > 0) then {
			_items = _iInventory select 0;
			_mags = _iInventory select 1;
			_backpacks = _iInventory select 2;
			_weapons = _iInventory select 3;

			clearItemCargoGlobal _veh;
			clearMagazineCargo _veh;
			clearWeaponCargoGlobal _veh;
			clearBackpackCargoGlobal _veh;
			for "_i" from 0 to ((count (_items select 0)) - 1) do {
				_veh addItemCargoGlobal [((_items select 0) select _i), ((_items select 1) select _i)];
			};
			for "_i" from 0 to ((count (_mags select 0)) - 1) do {
				_veh addMagazineCargoGlobal [((_mags select 0) select _i), ((_mags select 1) select _i)];
			};
			for "_i" from 0 to ((count (_backpacks select 0)) - 1) do {
				_veh addBackpackCargoGlobal [((_backpacks select 0) select _i), ((_backpacks select 1) select _i)];
			};
			for "_i" from 0 to ((count (_weapons select 0)) - 1) do {
				_veh addWeaponCargoGlobal [((_weapons select 0) select _i), ((_weapons select 1) select _i)];
    		};
		};
		private _virtualInventory = [(_db select 9)] call Server_Database_ToArray;
		_veh setVariable["storage",_virtualInventory,true];
		_veh setVariable["cid",(_db select 10),true];
		_veh setVariable["gasType",(_db select 11),true];
		_veh setVariable["gasAmount",(_db select 12),true];
		_veh setVariable["gps",(_db select 13),true];

		if (count _db > 14 && {!isNil {_db select 14}}) then {
			private _storedVars = [(_db select 14)] call Server_Database_ToArray;
			{
				switch (_x#0) do {
					case "gasType2": { _veh setVariable ["gasType2",(_x#1),true]; };
					case "gasAmount2": { _veh setVariable ["gasAmount2",(_x#1),true]; };
				};
			} forEach _storedVars;
		};

		private _addons = [(_db select 6)] call Server_Database_ToArray;
		if ((count _addons) > 0) then {
			{
				_animName = _x select 0;
				_animPhase = _x select 1;
				_veh animatesource [_animName, _animPhase, true];
			} foreach _addons;
		};
		private _damage = [(_db select 7)] call Server_Database_ToArray;
		if((count _damage) > 0) then {
			_parts = getAllHitPointsDamage _veh;
			for "_i" from 0 to ((count _damage) - 1) do {
				_veh setHitPointDamage [format ["%1",((_parts select 0) select _i)],_damage select _i];
			};
		};
	};
	[getPlayerUID _player,(_player getVariable ["character_id",""]),"Garage_Retrieve",[format ["Class: %1  | Plate: %2",_class,_id]]] call Server_Log_New;
	if (!isNull _keyRecipient) then {
		[_veh] remoteExec ["A3PL_Vehicle_AddKey",_keyRecipient];
	};
	[4] remoteExec ["A3PL_Storage_CarRetrieveResponse",_player];
}] call compile_Server;

["Server_Storage_RetrieveVehicle",
{
	private _class = param [0,""];
	private _player = param [1,objNull];
	private _id = param [2,-1];
	private _storage = param [3,[]];
	private _keyRecipient = param [4,_player];
	private _whitelistTrailer = ["A3PL_Ski_Base"];
	if (_storage isEqualType []) exitwith {
		[_class,_player,_id,_storage,_keyRecipient] call Server_Storage_RetrieveVehiclePos;
	};

	if (_storage animationPhase "StorageDoor1" > 0.1) exitwith
	{
		[1] remoteExec ["A3PL_Storage_CarRetrieveResponse",_player];
	};

	private _ebayCheck = [format ["SELECT onEbay FROM players_objects WHERE id = '%1'", _id], 2, false] call Server_Database_Async;
	if ((count _ebayCheck) > 0 && {(_ebayCheck select 0) isEqualTo 1}) exitWith {
		[("STR_A3PL_Storage_VehicleOnEbay" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
	};

	_query = format ["SELECT fuel,color,numpchange,iscustomplate,material,istorage,tuning,damage,insurance,vstorage,cid,gasType,gasAmount,gps,vars FROM players_objects WHERE id = '%1'",_id];
	_db = [_query, 2, false] call Server_Database_Async;

	_query = format ["UPDATE players_objects SET plystorage = '0',impounded = '0', spawn='1', pos='[]', dir='[]' WHERE id = '%1'",_id];
	[_query,1] spawn Server_Database_Async;

	[2] remoteExec ["A3PL_Storage_CarRetrieveResponse",_player];

	private _spawnDir = getDir _storage;
	private _storagePos = (getPosATL _storage);
	_storagePos set[2, (_storagePos#2)+0.75];

	_veh = [_class,[12626.2,1710,0.5],_id,_player] call Server_Vehicle_Spawn;
	_veh setDir _spawnDir;
	_veh setPosATL _storagePos;
	if ((count _db) isNotEqualTo 0) then
	{
		if(_db#0 < 0.1 && {_veh isKindOf "Ship"}) then {
			_veh setFuel 0.1;
		} else {
			_veh setFuel (_db select 0);
		};
		
		if((_db select 1) != "<null>") then {
			_veh setObjectTextureGlobal [0,(_db select 1)];
		};
		if((_db select 4) != "<null>") then {
			_veh setObjectMaterialGlobal [0,(_db select 4)];
		};
		_veh setVariable["numPChange",(_db select 2),true];
		_veh setVariable["isCustomPlate",(_db select 3),true];
		if((_db select 8) isEqualTo 1) then {
			_veh setVariable["insurance",true,true];
		} else {
			_veh setVariable["insurance",false,true];
		};

		_iInventory = [(_db select 5)] call Server_Database_ToArray;
		if ((count _iInventory) > 0) then {
			_items = _iInventory select 0;
			_mags = _iInventory select 1;
			_backpacks = _iInventory select 2;
			_weapons = _iInventory select 3;

			clearItemCargoGlobal _veh;
			clearMagazineCargo _veh;
			clearWeaponCargoGlobal _veh;
			clearBackpackCargoGlobal _veh;
			for "_i" from 0 to ((count (_items select 0)) - 1) do {
				_veh addItemCargoGlobal [((_items select 0) select _i), ((_items select 1) select _i)];
			};
			for "_i" from 0 to ((count (_mags select 0)) - 1) do {
				_veh addMagazineCargoGlobal [((_mags select 0) select _i), ((_mags select 1) select _i)];
			};
			for "_i" from 0 to ((count (_backpacks select 0)) - 1) do {
				_veh addBackpackCargoGlobal [((_backpacks select 0) select _i), ((_backpacks select 1) select _i)];
			};
			for "_i" from 0 to ((count (_weapons select 0)) - 1) do {
				_veh addWeaponCargoGlobal [((_weapons select 0) select _i), ((_weapons select 1) select _i)];
    		};
		};
		_virtualInventory = [(_db select 9)] call Server_Database_ToArray;
		_veh setVariable["storage",_virtualInventory,true];
		_veh setVariable["cid",(_db select 10),true];
		_veh setVariable["gasType",(_db select 11),true];
		_veh setVariable["gasAmount",(_db select 12),true];
		_veh setVariable["gps",(_db select 13),true];

		if (count _db > 14 && {!isNil {_db select 14}}) then {
			private _storedVars = [(_db select 14)] call Server_Database_ToArray;
			{
				switch (_x#0) do {
					case "gasType2": { _veh setVariable ["gasType2",(_x#1),true]; };
					case "gasAmount2": { _veh setVariable ["gasAmount2",(_x#1),true]; };
				};
			} forEach _storedVars;
		};

		_addons = [(_db select 6)] call Server_Database_ToArray;
		if ((count _addons) > 0) then {
			{
				_animName = _x select 0;
				_animPhase = _x select 1;
				_veh animatesource [_animName, _animPhase, true];
			} foreach _addons;
		};
		_damage = [(_db select 7)] call Server_Database_ToArray;
		if((count _damage) > 0) then {
			_parts = getAllHitPointsDamage _veh;
			for "_i" from 0 to ((count _damage) - 1) do {
				_veh setHitPointDamage [format ["%1",((_parts select 0) select _i)],_damage select _i];
			};
		};
	};

	if ((_veh isKindOf "ship") && (!(typeOf _veh IN _whitelistTrailer))) then
	{
		_trailer = createVehicle ["A3PL_BoatTrailer_Normal", (getPos _veh), [], 0, 'CAN_COLLIDE'];
		_trailer allowDamage false;
		_veh attachTo [_trailer,[0,0,1.5]];
		_trailer setDir (getDir _storage);
		_trailer setPos (getPos _storage);
		[_veh,_trailer,_player] spawn {
			_veh = param [0,objNull];
			_trailer = param [1,objNull];
			_player = param [2,objNull];
			sleep 1.5;
			_veh setOwner (owner _player);
		};
	};
	[getPlayerUID _player,(_player getVariable ["character_id",""]),"Garage_Retrieve",[format ["Class: %1  | Plate: %2",_class,_id]]] call Server_Log_New;
	if (!isNull _keyRecipient) then {
		[_veh] remoteExec ["A3PL_Vehicle_AddKey",_keyRecipient];
	};
	_storage animateSource ["storagedoor",1];
	[_player,_storage,_veh,_id] spawn
	{
		private _player = param [0,ObjNull];
		private _storage = param [1,ObjNull];
		private _veh = param [2,ObjNull];
		private _id = param [3,""];
		private _t = 0;
		while {(_veh distance _storage) < 8} do
		{
			sleep 1;
			_t = _t + 1;
			if (isNull _veh) exitwith {};
			if (_t > 40 && !(_player getVariable["new",false])) exitwith {
				[3] remoteExec ["A3PL_Storage_CarRetrieveResponse",_player];
				[format ["UPDATE players_objects SET plystorage = '1', spawn='0', impounded='0', pos='[]', dir='[]' WHERE id = '%1'",_id],1] spawn Server_Database_Async;
				Server_Storage_ListVehicles - [_veh];
				[_veh,false] remoteExec ["A3PL_Vehicle_AddKey",_player];
				[_veh] call Server_Vehicle_Despawn;
			};
		};
		_storage animateSource ["storagedoor",0];
	};
}] call compile_Server;

["Server_Storage_StoreVehicle_Pos",
{
	private _player = param [0,ObjNull];
	private _storage = param [1,ObjNull];
	private _toCompany = param [2,0];
	private _charID = (_player getVariable ["character_id",""]);
	private _near = _player nearEntities [["Car","Ship","Air","Tank","A3FL_PalletLifter"],25];
	private _blacklist = [("STR_Common_Job_Waste" call A3PL_Localize),("STR_Common_Job_Deliver" call A3PL_Localize),("STR_Common_Job_Exterminator" call A3PL_Localize),("STR_Common_Vehicle_Plate_Karting" call A3PL_Localize),("STR_Common_Job_Roadworker" call A3PL_Localize),("STR_Common_Job_Captain" call A3PL_Localize),("STR_Common_Job_BetterBuy" call A3PL_Localize),("STR_Common_Job_Taxi" call A3PL_Localize),("STR_Common_Vehicle_Plate_Federal" call A3PL_Localize)];
	if ((count _near) isEqualTo 0) exitwith {[7] remoteExec ["A3PL_Storage_CarStoreResponse",_player];};

	{
		_var = _x getVariable ["owner",nil];
		if (!isNil "_var") then {
			if (((_var#0) isEqualTo _charID) && {!(_var#1 IN _blacklist)}) exitwith {
				_playerCar = _x;
			};
		};
	} foreach _near;
	if (isNil "_playerCar") exitwith {[6] remoteExec ["A3PL_Storage_CarStoreResponse",_player];};
	

	[_playerCar,_storage,_player,_toCompany] spawn
	{
		private _playerCar = param [0,objNull];
		private _storage = param [1,objNull];
		private _player = param [2,objNull];
		private _toCompany = param[3,0];
		private _class = typeOf _playerCar;
		private _playerPos = getPosATL _player;
		private _t = 0;
		private _fail = false;
		private _class = typeOf _playerCar;
		private _cid = _playerCar getVariable["cid",0];
		private _gasType = _playerCar getVariable ["gasType",""];
		private _gasAmount = _playerCar getVariable ["gasAmount",0];
		private _gasType2 = _playerCar getVariable ["gasType2",""];
		private _gasAmount2 = _playerCar getVariable ["gasAmount2",0];
		private _gps = _playerCar getVariable ["gps",0];
		if(_toCompany isEqualTo 1) then {_cid = [(_player getVariable ["character_id",""])] call A3PL_Config_GetCompanyID;};
		if(_toCompany isEqualTo 2) then {_cid = 0;};
		while {(_playerCar distance _player > 5) OR (_player IN _playerCar)} do
		{
			_t = _t + 1;
			sleep 1;
			if (isNull _playerCar) exitwith {
				_fail = true;
				[5] remoteExec ["A3PL_Storage_CarStoreResponse",_player];
			};
			if (_t > 119) exitwith {
				[4] remoteExec ["A3PL_Storage_CarStoreResponse",_player];
				_fail = true;
			};
		};
		if (!_fail) then {
			[4] remoteExec ["A3PL_Storage_CarStoreResponse",_player];
		};
		if (!_fail) then
		{
			private _var = _playerCar getVariable ["owner",""];
			private _id = _var select 1;
			private _Path = (getObjectTextures _playerCar) select 0;
			private _Pathformat = format ["%1",_Path];
			private _material = (getObjectMaterials _playerCar) select 0;
			private _materialFormat = format ["%1",_material];
			private _Texture = [_Pathformat, "\", "\\"] call CBA_fnc_replace;
			private _materialLocation = [_materialFormat, "\", "\\"] call CBA_fnc_replace;
			private _damage = [];
			if(count(getAllHitPointsDamage _playerCar) isEqualTo 3) then {
				_damage = [(getAllHitPointsDamage _playerCar) select 2] call Server_Database_Array;
			};
			private _storeVars = [];
			if (_gasType2 != "" && _gasAmount2 > 0) then {
				_storeVars pushBack ["gasType2",_gasType2];
				_storeVars pushBack ["gasAmount2",_gasAmount2];
			};
			private _query = format ["UPDATE players_objects SET plystorage = '1',fuel='%2',color='%3',material='%4', damage='%5', cid='%6', gasType='%7', gasAmount='%8', gps='%9', vars='%10', spawn='0', pos='[]', dir='[]', impounded='0' WHERE id = '%1'",_id,(fuel _playerCar),_Texture,_materialLocation,_damage,_cid,_gasType,_gasAmount,_gps,[_storeVars] call Server_Database_Array];
			[_query,1] spawn Server_Database_Async;
			Server_Storage_ListVehicles - [_playerCar];
			[_playerCar,false] remoteExec ["A3PL_Vehicle_AddKey",_player];
			[_playerCar] call Server_Vehicle_Despawn;
			[getPlayerUID _player,(_player getVariable ["character_id",""]),"Garage_StorePos",[format ["Class: %1  | Plate: %2 | Pos: %3",_class,_id,_playerPos]]] call Server_Log_New;
		};
	};
}] call compile_Server;

["Server_Storage_StoreVehicle",
{
	private _player = param [0,ObjNull];
	private _storage = param [1,ObjNull];
	private _toCompany = param [2,0];
	private _charID = (_player getVariable ["character_id",""]);
	if (_storage animationPhase "StorageDoor1" > 0.1) exitwith {[1] remoteExec ["A3PL_Storage_CarStoreResponse",_player];};
	private _near = _storage nearEntities [["Car","Ship","Air","A3FL_PalletLifter"],9];
	private _blacklist = [("STR_Common_Job_Waste" call A3PL_Localize),("STR_Common_Job_Deliver" call A3PL_Localize),("STR_Common_Job_Exterminator" call A3PL_Localize),("STR_Common_Vehicle_Plate_Karting" call A3PL_Localize),("STR_Common_Job_Roadworker" call A3PL_Localize),("STR_Common_Job_Captain" call A3PL_Localize),("STR_Common_Job_BetterBuy" call A3PL_Localize),("STR_Common_Job_Taxi" call A3PL_Localize),("STR_Common_Vehicle_Plate_Federal" call A3PL_Localize)];
	private _playerCar = nil;
	if ((count _near) isEqualTo 0) exitwith {[7] remoteExec ["A3PL_Storage_CarStoreResponse",_player];};

	{
		_var = _x getVariable ["owner",["",""]];
		if (((_var#0) isEqualTo _charID) && {!(_var#1 IN _blacklist)}) exitwith {
			_playerCar = _x;
		};
	} foreach _near;
	if (isNil "_playerCar") exitwith {[6] remoteExec ["A3PL_Storage_CarStoreResponse",_player];};
	if (_playerCar getVariable["DealershipStolen",false]) exitWith {[6] remoteExec ["A3PL_Storage_CarStoreResponse",_player];};
	private _stockobj = _playerCar getVariable["stockobj",nil];
	if !(isNil "_stockobj") exitWith {[10] remoteExec ["A3PL_Storage_CarStoreResponse",_player];};

	_storage animateSource ["storagedoor",1];

	[2] remoteExec ["A3PL_Storage_CarStoreResponse",_player];
	[_playerCar,_storage,_player,_toCompany] spawn
	{
		private _playerCar = param [0,objNull];
		private _storage = param [1,objNull];
		private _player = param [2,objNull];
		private _toCompany = param[3,0];
		private _t = 0;
		private _fail = false;
		private _class = typeOf _playerCar;
		private _cid = _playerCar getVariable["cid",0];
		private _gasType = _playerCar getVariable ["gasType",""];
		if (isNil "_gasType" || {_gasType == ""}) then {
			_gasType = ("STR_Common_None" call A3PL_Localize);
		};
		private _gasAmount = _playerCar getVariable ["gasAmount",0];
		private _gasType2 = _playerCar getVariable ["gasType2",""];
		private _gasAmount2 = _playerCar getVariable ["gasAmount2",0];
		private _gps = _playerCar getVariable ["gps",0];
		if(_toCompany isEqualTo 1) then {_cid = [(_player getVariable ["character_id",""])] call A3PL_Config_GetCompanyID;};
		if(_toCompany isEqualTo 2) then {_cid = 0;};
		while {(_playerCar distance _storage > 3) OR ((_player IN _playerCar) OR ((_player distance _storage) < 4.8))} do
		{
			_t = _t + 1;
			sleep 1;
			if (isNull _playerCar) exitwith
			{
				_fail = true;
				[5] remoteExec ["A3PL_Storage_CarStoreResponse",_player];
			};
			if (_t > 119) exitwith
			{				
				[4] remoteExec ["A3PL_Storage_CarStoreResponse",_player];
				_fail = true;
			};
		};

		if (!_fail) then {
			[3] remoteExec ["A3PL_Storage_CarStoreResponse",_player];
		};

		_storage animateSource ["storagedoor",0];

		sleep 10;
		if (!_fail) then
		{
			private _var = _playerCar getVariable ["owner",[]];
			private _id = _var select 1;
			private _Path = (getObjectTextures _playerCar) select 0;
			private _material = (getObjectMaterials _playerCar) select 0;
			private _Pathformat = format ["%1",_Path];
			private _materialFormat = format ["%1",_material];
			private _Texture = [_Pathformat, "\", "\\"] call CBA_fnc_replace;
			private _materialLocation = [_materialFormat, "\", "\\"] call CBA_fnc_replace;
			private _damage = [];
			if(count(getAllHitPointsDamage _playerCar) isEqualTo 3) then {
				_damage = [(getAllHitPointsDamage _playerCar) select 2] call Server_Database_Array;
			};
			private _ownerData = _playerCar getVariable ["owner", ["",""]];
			private _markerName = format ["vehicleMarker_%1", _ownerData#1];
			[_markerName] remoteExec ["deleteMarkerLocal", _player];

			private _storeVars2 = [];
			if (_gasType2 != "" && _gasAmount2 > 0) then {
				_storeVars2 pushBack ["gasType2",_gasType2];
				_storeVars2 pushBack ["gasAmount2",_gasAmount2];
			};
			_query = format ["UPDATE players_objects SET plystorage = '1',impounded='0',spawn='0',fuel='%2',color='%3',material='%4',damage='%5',cid='%6',gasType='%7',gasAmount='%8',gps='%9',vars='%10',pos='[]',dir='[]' WHERE id = '%1'",_id,(fuel _playerCar),_Texture,_materialLocation,_damage,_cid,_gasType,_gasAmount,_gps,[_storeVars2] call Server_Database_Array];
			[_query,1] spawn Server_Database_Async;
			Server_Storage_ListVehicles - [_playerCar];
			[_playercar,false] remoteExec ["A3PL_Vehicle_AddKey",_player];
			[_playercar] call Server_Storage_VehicleVirtual;
			[_playerCar] call Server_Storage_Vehicle;
			[_playercar] call Server_Vehicle_Despawn;
			[getPlayerUID _player,(_player getVariable ["character_id",""]),"Garage_Store",[format ["Class: %1  | Plate: %2",_class,_id]]] call Server_Log_New;
		};
	};
}] call compile_Server;

["Server_Storage_SaveLargeVehicles",
{
	private _playerCar = param [0,objNull];
	private _player = param [1,objNull];
	private _toCompany = param [2,0];
	private _class = typeOf _playerCar;
	if (isNull _playerCar) exitwith {};

	[_playerCar] call Server_Storage_VehicleVirtual;

	private _var = _playerCar getVariable ["owner",nil];
	private _id = _var select 1;
	private _Path = (getObjectTextures _playerCar) select 0;
	private _material = (getObjectMaterials _playerCar) select 0;
	private _damage = [];
	if(count(getAllHitPointsDamage _playerCar) isEqualTo 3) then {_damage = [(getAllHitPointsDamage _playerCar) select 2] call Server_Database_Array;};
	private _Pathformat = format ["%1",_Path];
	private _materialFormat = format ["%1",_material];
	private _Texture = [_Pathformat, "\", "\\"] call CBA_fnc_replace;
	private _materialLocation = [_materialFormat, "\", "\\"] call CBA_fnc_replace;
	private _cid = _playerCar getVariable["cid",0];
	private _gasType = _playerCar getVariable ["gasType",""];
	private _gasAmount = _playerCar getVariable ["gasAmount",0];
	private _gasType2 = _playerCar getVariable ["gasType2",""];
	private _gasAmount2 = _playerCar getVariable ["gasAmount2",0];
	private _gps = _playerCar getVariable ["gps",0];
	if(_toCompany isEqualTo 1) then {_cid = [(_player getVariable ["character_id",""])] call A3PL_Config_GetCompanyID;};
	if(_toCompany isEqualTo 2) then {_cid = 0;};
	private _storeVars3 = [];
	if (_gasType2 != "" && _gasAmount2 > 0) then {
		_storeVars3 pushBack ["gasType2",_gasType2];
		_storeVars3 pushBack ["gasAmount2",_gasAmount2];
	};
	_query = format ["UPDATE players_objects SET plystorage = '1',fuel='%2',color='%3',material='%4',damage='%5',cid='%6',gasType='%7',gasAmount='%8',gps='%9',vars='%10', spawn='0', impounded='0', pos='[]', dir='[]' WHERE id = '%1'",_id,(fuel _playerCar),_Texture,_materialLocation,_damage,_cid,_gasType,_gasAmount,_gps,[_storeVars3] call Server_Database_Array];
	[_query,1] spawn Server_Database_Async;
	[_playerCar] call Server_Vehicle_Despawn;
	[getPlayerUID _player,(_player getVariable ["character_id",""]),"Garage_StoreLargeVehicle",[format ["Class: %1  | Plate: %2",_class,_id]]] call Server_Log_New;
}] call compile_Server;
