/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["Server_Gear_CheckUser", {
	params [
		["_unit",objNull,[objNull]]
	];
	private _uid = getPlayerUID _unit;

	// Check if the user is registred on the website, and if he completed the questionnaire
	private _query = format ["SELECT discord_id,country_code,role_id FROM users WHERE steam_id = '%1'", _uid];
    private _return = [_query, 2, false, "Panel"] call Server_Database_Async;
	private _discordId = _return#0;
	private _countryCode = _return#1;
	private _roleId = _return#2;

	//private _exit = remoteExec ["A3PL_Lib_ExitGame",_unit];
	switch (true) do {
		case (_discordId isEqualTo ""): {
			[("Server_Gear_PleaseConnectYourDiscordToWebsite" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _unit];
			//_exit;
		};
		case (_countryCode isEqualTo ""): {
			[("Server_Gear_NotConnectedToWebsite" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _unit];
			//_exit;
		};
		case (_roleId isEqualTo ""): {
			[("Server_Gear_CitizenNope" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _unit];
			//_exit;
		};
	};

	// Check if the user has characters
	_query = format ["SELECT id, face, name, dob, gender, status, character_status FROM players_characters WHERE steamid = '%1'", _uid];
    _return = [_query, 2] call Server_Database_Async;
	
	if (count _return isEqualTo 0) exitWith {
		[("Server_Gear_DoNotHaveCharacter" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _unit];
		//_exit;
	};

	// Check the user's active character
	_query = format ["SELECT id, face, name, dob, gender, status, character_status, starter_vehicle FROM players_characters WHERE steamid = '%1' AND character_status = 'active'", _uid];
    _return = [_query, 2] call Server_Database_Async;

	if (count _return isEqualTo 0) exitWith {
		[("Server_Gear_DoNotHaveActiveCharacter" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _unit];
		//_exit;
	};

	// Check if the user's active character is in the players database
	private _activeID = _return#0;
	private _playersreturn = [];
	_query = format ["SELECT * FROM players WHERE charid = '%1'", _activeID];
	_playersreturn = [_query, 2] call Server_Database_Async;

	if (count _playersreturn isEqualTo 0) then {
		[_return, _unit] spawn Server_Gear_New;
		_unit setVariable["alreadySpawned",true,true];
		[_unit,[6548.25,7552.95,0]] call Server_Housing_AssignApt;
		[_unit] call Server_Housing_SetPosApt;
	} else {
		[_activeID, _unit] call Server_Gear_Load;
	};
}] call compile_Server;

["Server_Gear_New", {
	params [
		["_character",[],[[]]],
		["_unit",objNull,[objNull]]
	];

	private _characterId = _character#0;
	private _face = _character#1;
	private _name = _character#2;
	private _dob = _character#3;
	private _gender = _character#4;
	private _uid = getPlayerUID _unit;

	private _randomUniform = selectRandom NewPlayer_RandomUniforms;
	private _newLoadout = [[],[],[],[_randomUniform,[[["A3PL_Shovel","","","",[],[],""],1],[["A3PL_Pickaxe","","","",["A3PL_PickAxeMag",3000],[],""],1]]],[],[],"H_Beret_blk","",["Binocular","","","",[],[],""],["ItemMap","ItemGPS","a3pl_3310","ItemCompass","ItemWatch",""]];
	private _loadoutStr = [_newLoadout] call Server_Database_Array;
	private _startCash = NewPlayer_StartingMoney + round(random NewPlayer_StartingMoney_Random);
	[format ["INSERT INTO players (charid,uid,face,name,dob,gender,pasportdate,cash,loadout) VALUES ('%1','%2','%3','%4','%5','%6',NOW(),'%7','%8')",_characterId,_uid,_face,_name,_dob,_gender,_startCash,_loadoutStr],1] spawn Server_Database_Async;

	// Starter vehicle - chosen by the player during character creation
	private _starterVehicle = _character#7;
	if (!isNil "_starterVehicle" && {_starterVehicle isEqualType ""} && {_starterVehicle != ""}) then {
		private _starterColor = format ["#(argb,8,8,3)color(%1,%2,%3,1.0,CO)", random 1, random 1, random 1];
		[format ["INSERT INTO players_objects (id,type,class,charid,plystorage,color) VALUES ('%1','vehicle','%2','%3','1','%4')",([7] call Server_Housing_GenerateID),_starterVehicle,_characterId,_starterColor],1] spawn Server_Database_Async;
	};

	// Grant driver license to new players
	[format ["INSERT INTO licenses(charid,code,issuedate,issuedBy) VALUES ('%1','driver',NOW(),'System')",_characterId], 1] spawn Server_Database_Async;

	waitUntil {
		private _result = [format ["SELECT * FROM players WHERE charid = '%1'", _characterId], 2] call Server_Database_Async;
		_result isEqualType [] && {count _result > 0}
	};
	[_characterId,_unit,true] call Server_Gear_Load;
	[] remoteExec ["A3PL_Player_NewCharacter",_unit];
	[_unit,[6548.25,7552.95,0],true] call Server_Housing_AssignApt;
}] call compile_Server;

["Server_Gear_Load", {
	params [
		["_activeCharacter","",[""]],
		["_unit",objNull,[objNull]],
		["_newPlayer",false,[false]]
	];

	private _query = format ["SELECT id,face,name,dob,gender,pasportdate,cash,paycheck,faction,job,loadout,virtualinv,f_storage,ship,userkey,medstats,stats,sport,position,jail,adminLevel,adminPerms,adminWatch,perkday,numacc,bank,bankactive,savingsaccount,savingsaccountactive,certificateofdeposit,certificateofdepositactive,activecb,debt,limitcb,hotbar FROM players WHERE charid='%1'",_activeCharacter];
	private _return = [_query, 2] call Server_Database_Async;
	Server_Online_Players_charIDs pushBack _activeCharacter;
	publicVariable "Server_Online_Players_charIDs";

	// Send localization to client
	(owner _unit) publicVariableClient "Localization";

	// IDs
	_unit setVariable ["db_id",_return select 0,true];
	_unit setVariable ["character_id",_activeCharacter,true];

	// Face
	[_unit, (_return select 1)] remoteExec ["setFace", 0, _unit];

	// National informations
	_unit setVariable ["name",_return select 2,true];
	_unit setVariable ["dob",_return select 3,true];
	_unit setVariable ["gender",_return select 4,true];
	_unit setVariable ["date",_return select 5,true];

	// Faction & job
	_unit setVariable ["faction",_return select 8,true];
	_unit setVariable ["job",_return select 9,true];
	if(_return select 9 IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) then {[_activeCharacter,_return select 9] call Server_Log_Faction_ClockIn;};

	// Money
	_unit setVariable ["Player_Cash",_return select 6,true];
	[(_return select 7)] remoteExec ["A3PL_Player_SetPaycheck",_unit];
	_unit setVariable ["Player_NumAcc",_return select 24,true];
	_unit setVariable ["Player_Bank",_return select 25,true];
	private _bankActive = _return select 26;
	if (_bankActive isEqualTo 1) then {
		_unit setVariable ["Player_BankActive",true,true];
	} else {
		_unit setVariable ["Player_BankActive",false,true];
	};
	_unit setVariable ["Player_SavingsAccount",_return select 27,true];
	private _SavingsActive = _return select 28;
	if (_SavingsActive isEqualTo 1) then {
		_unit setVariable ["Player_SavingsAccountActive",true,true];
	} else {
		_unit setVariable ["Player_SavingsAccountActive",false,true];
	};
	_unit setVariable ["Player_CertificateOfDeposit",_return select 29,true];
	private _CODactive = _return select 30;
	if (_CODactive isEqualTo 1) then {
		_unit setVariable ["Player_CertificateOfDepositActive",true,true];
	} else {
		_unit setVariable ["Player_CertificateOfDepositActive",false,true];
	};
	_unit setVariable ["Player_ActiveCB",_return select 31,true];
	_unit setVariable ["Player_Debt",_return select 32,true];
	_unit setVariable ["Player_LimitCB",_return select 33,true];

	//[] remoteExec ["A3PL_Player_SetMarkers",_unit];

	// Inventories
	private _loadout = [(_return select 10)] call Server_Database_ToArray;
	_unit setUnitLoadout _loadout;
	private _virtinv = [(_return select 11)] call Server_Database_ToArray;
	private _facStorage = [(_return select 12)] call Server_Database_ToArray;
	_unit setVariable ["player_inventory",_virtinv,true];
	_unit setVariable ["player_fstorage",_facStorage,true];

	// Hotbar - stored as array with "empty" placeholder for empty slots
	private _hotbarRaw = _return select 34;
	private _hotbar = ["","","","","","","","","",""];
	if (!isNil "_hotbarRaw" && {_hotbarRaw isEqualType ""} && {_hotbarRaw != ""}) then {
		// Parse the array from string (Server_Database_ToArray returns the parsed result)
		private _parsed = [_hotbarRaw] call Server_Database_ToArray;
		if (_parsed isEqualType [] && {count _parsed == 10}) then {
			// Convert "empty" placeholders back to empty strings
			_hotbar = _parsed apply {if (_x == "empty") then {""} else {_x}};
		};
	};
	_unit setVariable ["player_hotbar",_hotbar,true];

	[] remoteExec ["A3PL_Hotbar_Init",_unit];

	[] remoteExec ["A3PL_Inventory_SetCurrent",_unit];

	private _ship = [(_return select 13)] call Server_Database_ToArray;
	_unit setVariable ["player_importing",_ship select 0,true];
	_unit setVariable ["player_exporting",_ship select 1,true];

	private _keys = [(_return select 14)] call Server_Database_ToArray;
	_unit setVariable["keys",_keys,true];

	// Stats
	private _medStat = [(_return select 15)] call Server_Database_ToArray;
	_unit setVariable ["A3PL_Wounds",_medStat select 0,true];
	_unit setVariable ["A3PL_Medical_Blood",_medStat select 1,true];
	private _stats = [(_return select 16)] call Server_Database_ToArray;
	_unit setVariable ["player_hunger",_stats select 0,true];
	_unit setVariable ["player_thirst",_stats select 1,true];
	_unit setVariable ["player_alcohol",_stats select 2,true];
	_unit setVariable ["player_drugs",_stats select 3,true];
	_unit setVariable ["player_pee",_stats select 4,true];
	_unit setVariable ["player_sleep",_stats select 5,true];
	private _sport = [(_return select 17)] call Server_Database_ToArray;
	_unit setVariable ["Player_SportLevel",_sport select 0,true];
	_unit setVariable ["Player_SportSpeed",_sport select 1,true];
	_unit setVariable ["Player_ScopeStability",_sport select 2,true];
	_unit setVariable ["Player_maxTimeTired",_sport select 3,true];

	//RemoteExec player stats
	[] remoteExec ["A3PL_Player_StatsSetup",_unit];

	//Position
	private _pos = call compile (_return select 18);
	if (isNil "_pos" || {count _pos != 3}) then {
		_pos = [0,0,0];
	};
	_unit setPosATL _pos;
	private _jailTime = _return select 19;
	if(_jailTime > 0) then {
		_unit setPosATL [4758.43,6167.78,0];
		_unit setVariable["alreadySpawned",true,true];
		[_jailTime, _unit] call Server_Police_JailPlayer;
	};

	if (_pos isNotEqualTo [0,0,0]) then {
		_unit setVariable["alreadySpawned",true,true];
	};

	// Miscellaneous 
	private _uid = getPlayerUID _unit;
	private _adminLevel = 0;
	private _adminPerms = [];
	private _charIDs = [format["SELECT charid FROM players WHERE uid='%1'", _uid], 2, true] call Server_Database_Async;
	{
		private _perms = ([format ["SELECT adminPerms, adminLevel FROM players WHERE charid='%1'",_x#0], 2, true] call Server_Database_Async)#0;
		if ((_perms#0 isNotEqualTo []) || (_perms#1) isNotEqualTo 0) exitWith {
			_adminLevel = _perms#1;
			_adminPerms = [(_perms#0)] call Server_Database_ToArray;
		};
	} forEach _charIDs;
	if(_adminLevel > 0) then {_unit setVariable ["dbVar_AdminLevel",_adminLevel,true];};
	if(_adminPerms isNotEqualTo []) then {_unit setVariable ["dbVar_AdminPerms",_adminPerms,true]};
	if((_return select 22) isEqualTo 1) then {_unit setVariable ["adminWatch",true,true];};

	// Get the highest perkday from all characters of this player
	private _perkday = 0;
	{
		private _charPerkday = ([format ["SELECT perkday FROM players WHERE charid='%1'",_x#0], 2, true] call Server_Database_Async)#0#0;
		if (_charPerkday > _perkday) then {
			_perkday = _charPerkday;
		};
	} forEach _charIDs;
	_unit setVariable ["Player_PerkDay",_perkday,true];

	// Get the highest hotbar_slots from all characters of this player
	private _hotbarSlots = 5;
	{
		private _charSlots = ([format ["SELECT hotbar_slots FROM players WHERE charid='%1'",_x#0], 2, true] call Server_Database_Async)#0#0;
		if (!isNil "_charSlots" && {_charSlots > _hotbarSlots}) then {
			_hotbarSlots = _charSlots;
		};
	} forEach _charIDs;
	_hotbarSlots = _hotbarSlots max 5 min 10;
	_unit setVariable ["Player_HotbarSlots", _hotbarSlots, true];

	private _ownsHouse = false;
	private _houseObj = objNull;
	private _houseObjects = [];
	{
		_houseVar = _x getVariable ["owner",[]];
		if (_activeCharacter IN (_houseVar)) then
		{
			_ownsHouse = true;
			_houseObj = _x;
			_houseObjects pushBack _x;
			_doorID = (_houseObj getVariable "doorid") select 1;
			if (!(_doorID IN _keys)) then {
				_allKeys = _unit getVariable["keys",[]];
				_allKeys pushBack _doorID;
				_unit setVariable ["keys",_allKeys,true];
			};
		};
	} foreach Server_HouseList;
	private _ownsWarehouse = false;
	private _warehouseObj = objNull;
	{
		_warehouseVar = _x getVariable ["owner",[]];
		if (_activeCharacter IN (_warehouseVar)) exitwith
		{
			_ownsWarehouse = true;
			_warehouseObj = _x;
			_doorID = (_warehouseObj getVariable "doorid") select 1;
			if (!(_doorID IN _keys)) then {
				_allKeys = _unit getVariable["keys",[]];
				_allKeys pushBack _doorID;
				_unit setVariable ["keys",_allKeys,true];
			};
		};
	} foreach Server_WarehouseList;
	private _ownsCrackhouse = false;
	private _crackhouseObj = objNull;
	{
		_crackhouseVar = _x getVariable ["owner",[]];
		if (_activeCharacter IN (_crackhouseVar)) exitwith
		{
			_ownsCrackhouse = true;
			_crackhouseObj = _x;
			_doorID = (_crackhouseObj getVariable "doorid") select 1;
			if (!(_doorID IN _keys)) then {
				_allKeys = _unit getVariable["keys",[]];
				_allKeys pushBack _doorID;
				_unit setVariable ["keys",_allKeys,true];
			};
		};
	} foreach Server_CrackhouseList;
	if (_ownsHouse) then {
		_unit setVariable ["house",_houseObj,true];
		_unit setVariable ["houses",_houseObjects,true];
	};
	if(_ownsWarehouse) then {
		_unit setVariable ["warehouse",_warehouseObj,true];
	};
	if(_ownsCrackhouse) then {
		_unit setVariable ["crackhouse",_crackhouseObj,true];
	};

	(owner _unit) publicVariableClient "A3PL_RetrievedInventory";

	//Load Gang System
	[_unit] call Server_Gang_Load;
	[_unit] call Server_DMV_LoadLicenses;
	[_unit] call Server_Traits_Load;

	//Load Bills
	[_unit] remoteExec ["Server_Company_LoadBills",2];

	//Load Vehicles
	private _vehKeys = missionNamespace getVariable [format ["%1_KEYS",_activeCharacter],[]];
	[_vehKeys] remoteExec["A3PL_Vehicle_SetAllKeys",_unit];
    [_unit] call Server_Vehicle_addKeysAfterLoad;

	// If the character is new, basic items are added
	if (_newPlayer) then {
		{
			[_unit,_x#0,_x#1] call Server_Inventory_Add;
		} forEach NewPlayer_StartingItems;

		[_unit,false] call Server_Gear_Save;
	};
}] call compile_Server;

["Server_Gear_Save", {
	params [
		["_unit",objNull,[objNull]],
		["_delete",false,[false]]
	];
	if !(_unit getVariable ["FinishedLoading",false]) exitWith {};
	private _loadout = [_unit] call A3PL_Lib_Loadout;
	private _pos = getPosATL _unit;

	if (_delete) then {deleteVehicle _unit;};

	private _charid = _unit getVariable ["character_id",0];

	private _job = _unit getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
	private _virtinv = _unit getVariable ["player_inventory",[]];
	private _hotbar = _unit getVariable ["player_hotbar",[]];
	private _ship = [_unit getVariable ["player_importing",[]],_unit getVariable ["player_exporting",[]]];
	private _medWounds = _unit getVariable ["A3PL_Wounds",[]];
	private _blood = _unit getVariable ["A3PL_Medical_Blood",5000];
	private _medStat = [_medWounds,_blood];
	private _hunger = _unit getVariable ["player_hunger",0];
	private _thirst = _unit getVariable ["player_thirst",0];
	private _alcohol = _unit getVariable ["player_alcohol",0];
	private _drugs = _unit getVariable ["player_drugs",[0,0,0]];
	private _pee = _unit getVariable ["player_pee",0];
	private _sleep = _unit getVariable ["player_sleep",0];
	private _stats = [_hunger,_thirst,_alcohol,_drugs,_pee,_sleep];
	private _sportLevel = _unit getVariable ["Player_SportLevel",0];
	private _sportSpeed = _unit getVariable ["Player_SportSpeed",0];
	private _scopeStability = _unit getVariable ["Player_ScopeStability",0];
	private _maxTimeTired = _unit getVariable ["Player_maxTimeTired",0];
	private _sport = [_sportLevel,_sportSpeed,_scopeStability,_maxTimeTired];
	private _cash = _unit getVariable "Player_Cash";
	private _bank = _unit getVariable ["Player_Bank",0];
	private _bankActive = _unit getVariable ["Player_BankActive",false];
	if (_bankActive) then {
		_bankActive = 1;
	} else {
		_bankActive = 0;
	};
	private _Savings = _unit getVariable ["Player_SavingsAccount",0];
	private _SavingsActive = _unit getVariable ["Player_SavingsAccountActive",false];
	if (_SavingsActive) then {
		_SavingsActive = 1;
	} else {
		_SavingsActive = 0;
	};
	private _COD = _unit getVariable ["Player_CertificateOfDeposit",0];
	private _CODActive = _unit getVariable ["Player_CertificateOfDepositActive",false];
	if (_CODActive) then {
		_CODActive = 1;
	} else {
		_CODActive = 0;
	};
	private _activecb = _unit getVariable "Player_ActiveCB";
	private _debt = _unit getVariable "Player_Debt";
	private _limitCB = _unit getVariable "Player_LimitCB";

	if (_pos inArea "A3FL_DebugSpawn") exitwith {};
	if (isNil "_cash") exitwith {diag_log format ["Error in Server_Gear_Save: _cash is nil for %1",name _unit];};

	private _query = format ["UPDATE players SET loadout='%2',position='%3',job='%4',virtualinv='%5',cash='%6',medstats='%7',ship='%8',bank='%9',bankactive='%10',savingsaccount='%11',savingsaccountactive='%12',certificateofdeposit='%13',certificateofdepositactive='%14',activecb='%15',debt='%16',limitcb='%17',stats='%18',sport='%19',hotbar='%20' WHERE charid ='%1'",
		_charid,
		[_loadout] call Server_Database_Array,
		_pos,
		_job,
		[_virtinv] call Server_Database_Array,
		_cash,
		_medStat,
		[_ship] call Server_Database_Array,
		_bank,
		_bankActive,
		_Savings,
		_SavingsActive,
		_COD,
		_CODActive,
		_activecb,
		_debt,
		_limitcb,
		_stats,
		_sport,
		[_hotbar apply {if (_x == "") then {"empty"} else {_x}}] call Server_Database_Array
	];
	[_query,1] spawn Server_Database_Async;
}] call compile_Server;

["Server_Gear_HandleDisconnect",
{
	addMissionEventHandler ["HandleDisconnect",
	{
		params ["_unit", "_id", "_uid", "_name"];
		if (isNull _unit) exitwith {};
		private _var = _unit getVariable ["name",nil];
		private _charID = _unit getVariable ["character_id",""];
		private _uid = getPlayerUID _unit;
		if (isNil "_var") exitwith {};
		private _job = _unit getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
		private _jobVeh = _unit getVariable ["jobVehicle",nil];
		private _staff = _unit getVariable["dbVar_AdminLevel",0];
		Server_Online_Players_charIDs deleteAt (Server_Online_Players_charIDs find _charID);
		if (_staff > 0 && {_staff isNotEqualTo 4}) then {[_uid] call Server_Log_ClockOut;};
		if (_job IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) then {[_charID] call Server_Log_Faction_ClockOut;};
		publicVariable "Server_Online_Players_charIDs";
		if (!isNil {_jobVeh}) then {[_jobVeh,_charID] spawn Server_Gear_JobVehicle;};

		[_unit,true] spawn Server_Gear_Save;
		[_unit,_charID] call Server_Housing_SaveKeys;
		private _apt = _unit getVariable "apt";
		if (!isNil "_apt") then {[_unit] call Server_Housing_UnAssignApt;};

		private _deleteAt = [];
		{
			if((_x getVariable ["owner",""]) isEqualTo _charID) then {
				ropeDestroy (_x getVariable ["rope",objNull]);
				deleteVehicle (_x getVariable ["net",objNull]);
				deleteVehicle _x;
				_deleteAt pushBack _forEachIndex;
			};
		} forEach Server_FishingBuoys;

		{
		  Server_FishingBuoys deleteAt _x;
		} forEach _deleteAt;

		{
			deleteVehicle _x;
		} forEach attachedObjects _unit;
		[_uid,_charID,"Player_Disconnect",[format ["A3 Name: %1 | Character Name: %2",name _unit,_unit getVariable ["name","unknown"]]]] call Server_Log_New;
	}];
}] call compile_Server;

["Server_Gear_JobVehicle",
{
	params [
		["_jobVeh",objNull,[objNull]],
		["_charID","",[""]]
	];
	sleep 300;
	private _player = [_charID] call A3PL_Lib_charIDToObject;
	if(isNull _player) exitwith {
		{deleteVehicle _x;} foreach (attachedObjects _jobVeh);
		deleteVehicle _jobVeh;
	};
}] call compile_Server;
