/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/

// Initialiser le système FactoryV2 au démarrage du serveur
["Server_FactoryV2_Init", {
	// Charger tous les crafts actifs depuis la base de données
	[] call Server_FactoryV2_LoadActiveCrafts;

	// Les loops sont gérées dans Server_Setup via BIS_fnc_loop

	diag_log "[FactoryV2] System initialized";
}] call compile_Server;

// Helper: Obtenir l'owner ID d'un joueur (company ou civil)
// Retourne [ownerType, ownerID] où ownerType = "company" ou "player"
["Server_FactoryV2_GetOwnerInfo", {
	params [["_player", objNull]];

	if (isNull _player) exitWith {["", 0]};

	private _charID = _player getVariable ["character_id", ""];
	if (_charID isEqualTo "") exitWith {["", 0]};

	// Vérifier si le joueur appartient à une entreprise
	private _cid = [_charID] call A3PL_Config_GetCompanyID;

	if (_cid > 0) then {
		// Le joueur est membre d'une entreprise
		["company", _cid]
	} else {
		// Le joueur est civil - utiliser son character_id
		["player", _charID]
	}
}] call compile_Server;

// Helper: Vérifier si un craft/licence est accessible aux civils
["Server_FactoryV2_IsCivilianAccessible", {
	params [["_itemID", ""], ["_isLicense", false]];

	private _itemIDStr = if (_itemID isEqualType "") then {_itemID} else {str _itemID};

	if (_isLicense) then {
		private _licenseData = Config_FactoryV2_Licenses getOrDefault [_itemIDStr, []];
		if (count _licenseData >= 4) then {
			(_licenseData select 3) isEqualTo 1
		} else {
			false
		}
	} else {
		private _craftData = Config_FactoryV2_Crafts getOrDefault [_itemIDStr, []];
		if (count _craftData >= 10) then {
			(_craftData select 9) isEqualTo 1
		} else {
			false
		}
	}
}] call compile_Server;

// Helper: Obtenir les frais de craft pour civils
["Server_FactoryV2_GetCraftFee", {
	params [["_craftID", ""]];

	private _craftIDStr = if (_craftID isEqualType "") then {_craftID} else {str _craftID};
	private _craftData = Config_FactoryV2_Crafts getOrDefault [_craftIDStr, []];

	if (count _craftData >= 11) then {
		private _fee = _craftData select 10;
		if (_fee isEqualType "") then {parseNumber _fee} else {_fee}
	} else {
		0
	}
}] call compile_Server;

// Helper: Vérifier si une entreprise a accès à un secteur d'activité
// Retourne true si: les secteurs requis sont vides OU l'entreprise possède AU MOINS UN des secteurs requis
["Server_FactoryV2_HasSectorAccess", {
	params [["_ownerType", ""], ["_ownerID", ""], ["_requiredSectors", []]];

	// Si pas de secteurs requis (array vide ou nil), accès autorisé
	if (isNil "_requiredSectors") exitWith {true};
	if !(_requiredSectors isEqualType []) exitWith {true};
	if (count _requiredSectors == 0) exitWith {true};

	// Les civils n'ont pas de secteur, ils n'ont accès qu'aux crafts sans restriction de secteur
	if (_ownerType isEqualTo "player") exitWith {false};

	// Récupérer les secteurs de l'entreprise
	private _ownerIDNum = if (_ownerID isEqualType "") then {parseNumber _ownerID} else {_ownerID};
	private _companySectors = [_ownerIDNum, "sector"] call A3PL_Config_GetCompanyData;

	if (isNil "_companySectors") then {_companySectors = [];};
	if !(_companySectors isEqualType []) then {_companySectors = [];};

	// Normaliser en lowercase pour la comparaison
	private _companySectorsLower = _companySectors apply {toLower _x};
	private _requiredSectorsLower = _requiredSectors apply {toLower _x};

	// Vérifier si AU MOINS UN des secteurs requis est dans la liste des secteurs de l'entreprise
	private _hasAccess = false;
	{
		if (_x in _companySectorsLower) exitWith {_hasAccess = true;};
	} forEach _requiredSectorsLower;

	_hasAccess
}] call compile_Server;

// Charger les crafts actifs depuis la base de données
// Structure: [id, owner_type, owner_id, craft_id, amount, created_at, duration, required_items, end_time]
["Server_FactoryV2_LoadActiveCrafts", {
	diag_log "[FactoryV2 SERVER] LoadActiveCrafts - Starting...";

	private _query = ["SELECT id, owner_type, owner_id, craft_id, amount, created_at, duration, required_items, end_time, IFNULL(npc,'') as npc FROM factoryv2_crafts WHERE status = 'active'", 2, true] call Server_Database_Async;

	diag_log format ["[FactoryV2 SERVER] LoadActiveCrafts - Raw query result type: %1, value: %2", typeName _query, _query];

	if (isNil "_query") then {
		diag_log "[FactoryV2 SERVER] LoadActiveCrafts - Query is nil!";
		_query = [];
	};
	if !(_query isEqualType []) then {
		diag_log format ["[FactoryV2 SERVER] LoadActiveCrafts - Query is not array, type: %1", typeName _query];
		_query = [];
	};

	diag_log format ["[FactoryV2 SERVER] LoadActiveCrafts - Query returned %1 rows", count _query];

	Server_FactoryV2_ActiveCrafts = [];
	{
		diag_log format ["[FactoryV2 SERVER] LoadActiveCrafts - Processing row %1: %2", _forEachIndex, _x];

		if !(_x isEqualType []) then {
			diag_log format ["[FactoryV2 SERVER] LoadActiveCrafts - Row %1 is not array, skipping", _forEachIndex];
			continue;
		};
		if (count _x < 9) then {
			diag_log format ["[FactoryV2 SERVER] LoadActiveCrafts - Row %1 has %2 elements (need 9), skipping", _forEachIndex, count _x];
			continue;
		};

		private _craftDBID = _x select 0;
		private _ownerType = _x select 1;
		private _ownerIDRaw = _x select 2;
		private _ownerID = if (_ownerIDRaw isEqualType "") then {_ownerIDRaw} else {str _ownerIDRaw};
		private _craftID = _x select 3;
		private _amount = _x select 4;
		private _createdAtRaw = _x select 5;
		private _duration = _x select 6;

		private _requiredItems = [_x select 7] call Server_Database_ToArray;
		if (isNil "_requiredItems") then {_requiredItems = [];};
		if !(_requiredItems isEqualType []) then {_requiredItems = [];};

		private _endTimeRaw = _x select 8;
		private _npcVarNameCraft = if (count _x > 9) then {_x select 9} else {""};
		if (isNil "_npcVarNameCraft") then {_npcVarNameCraft = "";};
		if !(_npcVarNameCraft isEqualType "") then {_npcVarNameCraft = "";};

		private _createdAt = _createdAtRaw;
		private _endTime = _endTimeRaw;
		if (_createdAtRaw isEqualType [] && {count _createdAtRaw >= 6}) then {
			_createdAt = format ["%1-%2-%3 %4:%5:%6",
				_createdAtRaw select 0,
				_createdAtRaw select 1,
				_createdAtRaw select 2,
				_createdAtRaw select 3,
				_createdAtRaw select 4,
				_createdAtRaw select 5
			];
		};
		if (_endTimeRaw isEqualType [] && {count _endTimeRaw >= 6}) then {
			_endTime = format ["%1-%2-%3 %4:%5:%6",
				_endTimeRaw select 0,
				_endTimeRaw select 1,
				_endTimeRaw select 2,
				_endTimeRaw select 3,
				_endTimeRaw select 4,
				_endTimeRaw select 5
			];
		};

		Server_FactoryV2_ActiveCrafts pushBack [
			_craftDBID,
			_ownerType,
			_ownerID,
			_craftID,
			_amount,
			_createdAt,
			_duration,
			_requiredItems,
			_endTime,
			_npcVarNameCraft
		];

		diag_log format ["[FactoryV2 SERVER] Loaded craft ID %1 (OwnerType: %2, OwnerID: %3, CraftID: %4, end_time: %5, npc: %6)", _craftDBID, _ownerType, _ownerID, _craftID, _endTime, _npcVarNameCraft];

	} foreach _query;

	diag_log format ["[FactoryV2 SERVER] LoadActiveCrafts completed - Total crafts in memory: %1", count Server_FactoryV2_ActiveCrafts];

}] call compile_Server;

// Traiter les crafts actifs
// Structure mémoire: [craftDBID, ownerType, ownerID, craftID, amount, createdAt, duration, requiredItems, endTime]
["Server_FactoryV2_ProcessCrafts", {
	private _dbExpiredCrafts = ["SELECT id, owner_type, owner_id, craft_id FROM factoryv2_crafts WHERE status = 'active' AND end_time <= NOW()", 2, true] call Server_Database_Async;
	if (!isNil "_dbExpiredCrafts" && {_dbExpiredCrafts isEqualType [] && {count _dbExpiredCrafts > 0}}) then {
		{
			private _dbCraftID = _x select 0;
			private _dbOwnerType = _x select 1;
			private _dbOwnerID = _x select 2;
			private _dbCraftDataID = _x select 3;
			if (_dbCraftID isEqualType "") then {_dbCraftID = parseNumber _dbCraftID;};
			if (_dbOwnerID isEqualType 0) then {_dbOwnerID = str _dbOwnerID;};
			if (_dbCraftDataID isEqualType 0) then {_dbCraftDataID = str _dbCraftDataID;};

			private _existsInMemory = false;
			{
				private _memOwnerType = _x select 1;
				private _memOwnerID = if ((_x select 2) isEqualType 0) then {str (_x select 2)} else {_x select 2};
				private _memCraftID = if ((_x select 3) isEqualType 0) then {str (_x select 3)} else {_x select 3};

				if (_memOwnerType isEqualTo _dbOwnerType &&
					{_memOwnerID isEqualTo _dbOwnerID} &&
					{_memCraftID isEqualTo _dbCraftDataID}) exitWith {
					_existsInMemory = true;
				};
			} forEach Server_FactoryV2_ActiveCrafts;

			if (!_existsInMemory) then {
				diag_log format ["[FactoryV2] ProcessCrafts - Expired craft %1 not in memory, finalizing from DB", _dbCraftID];
				[_dbCraftID] call Server_FactoryV2_FinalizeCraftFromDB;
			};
		} forEach _dbExpiredCrafts;
	};

	if (count Server_FactoryV2_ActiveCrafts == 0) exitWith {};

	private _craftsToFinalize = [];

	{
		private _craftDBID = _x select 0;
		private _endTimeRaw = _x select 8;

		private _endYear = 0;
		private _endMonth = 0;
		private _endDay = 0;
		private _endHour = 0;
		private _endMin = 0;
		private _endSec = 0;

		if (_endTimeRaw isEqualType []) then {
			if (count _endTimeRaw >= 6) then {
				_endYear = _endTimeRaw select 0;
				_endMonth = _endTimeRaw select 1;
				_endDay = _endTimeRaw select 2;
				_endHour = _endTimeRaw select 3;
				_endMin = _endTimeRaw select 4;
				_endSec = _endTimeRaw select 5;
			};
		} else {
			private _parts = _endTimeRaw splitString "- :";
			if (count _parts >= 6) then {
				_endYear = parseNumber (_parts select 0);
				_endMonth = parseNumber (_parts select 1);
				_endDay = parseNumber (_parts select 2);
				_endHour = parseNumber (_parts select 3);
				_endMin = parseNumber (_parts select 4);
				_endSec = parseNumber (_parts select 5);
			};
		};

		if (_endYear > 0) then {
			private _now = systemTimeUTC;
			private _nowYear = _now select 0;
			private _nowMonth = _now select 1;
			private _nowDay = _now select 2;
			private _nowHour = _now select 3;
			private _nowMin = _now select 4;
			private _nowSec = round (_now select 5);

			private _isFinished = false;

			if (_nowYear > _endYear) then {_isFinished = true};
			if (_nowYear == _endYear && _nowMonth > _endMonth) then {_isFinished = true};
			if (_nowYear == _endYear && _nowMonth == _endMonth && _nowDay > _endDay) then {_isFinished = true};
			if (_nowYear == _endYear && _nowMonth == _endMonth && _nowDay == _endDay && _nowHour > _endHour) then {_isFinished = true};
			if (_nowYear == _endYear && _nowMonth == _endMonth && _nowDay == _endDay && _nowHour == _endHour && _nowMin > _endMin) then {_isFinished = true};
			if (_nowYear == _endYear && _nowMonth == _endMonth && _nowDay == _endDay && _nowHour == _endHour && _nowMin == _endMin && _nowSec >= _endSec) then {_isFinished = true};

			if (_isFinished) then {
				_craftsToFinalize pushBack _craftDBID;
			};
		};
	} forEach Server_FactoryV2_ActiveCrafts;

	{
		[_x] call Server_FactoryV2_FinalizeCraft;
	} forEach _craftsToFinalize;
}] call compile_Server;

// Finaliser un craft directement depuis la DB (pour les crafts pas en mémoire)
// Finaliser un craft depuis la DB uniquement (utilisé après restart serveur quand la mémoire est vide)
["Server_FactoryV2_FinalizeCraftFromDB", {
	private _craftDBID = param [0, 0];
	if (_craftDBID == 0) exitWith {};

	private _craftQuery = [format [
		"SELECT owner_type, owner_id, craft_id, amount, IFNULL(npc,'') as npc FROM factoryv2_crafts WHERE id = '%1' AND status = 'active'",
		_craftDBID
	], 2, true] call Server_Database_Async;

	if (isNil "_craftQuery" || {count _craftQuery == 0}) exitWith {
		diag_log format ["[FactoryV2] FinalizeCraftFromDB - Craft %1 not found or already completed", _craftDBID];
	};

	private _row = _craftQuery select 0;
	private _ownerType = _row select 0;
	private _ownerID = _row select 1;
	private _craftID = _row select 2;
	private _amount = _row select 3;
	private _craftNpcVarName = if (count _row > 4) then {_row select 4} else {""};
	if (isNil "_craftNpcVarName") then {_craftNpcVarName = "";};
	if !(_craftNpcVarName isEqualType "") then {_craftNpcVarName = "";};

	if (_ownerID isEqualType "") then {} else {_ownerID = str _ownerID;};
	if (_craftID isEqualType "") then {_craftID = parseNumber _craftID;};
	if (_amount isEqualType "") then {_amount = parseNumber _amount;};

	private _craftData = Config_FactoryV2_Crafts getOrDefault [str _craftID, []];
	if (count _craftData == 0) exitWith {
		diag_log format ["[FactoryV2] FinalizeCraftFromDB - Craft config not found for ID %1", _craftID];
	};

	private _classname = _craftData select 5;
	private _classType = _craftData select 6;
	private _craftName = _craftData select 0;
	private _outputAmount = _craftData select 7;
	if (isNil "_outputAmount" || {typeName _outputAmount != "SCALAR"}) then {_outputAmount = 1;};

	private _finalAmount = _outputAmount * _amount;

	private _storageClassname = _craftName;
	if (_classType isEqualTo "item") then {
		_storageClassname = _classname;
	};

	[format ["UPDATE factoryv2_crafts SET status = 'completed', completed_time = NOW() WHERE id = '%1'", _craftDBID], 2, true] call Server_Database_Async;

	private _npcObjResolved = if (_craftNpcVarName != "") then {missionNamespace getVariable [_craftNpcVarName, objNull]} else {objNull};
	[_ownerType, _ownerID, [_storageClassname, _finalAmount], objNull, false, objNull, _npcObjResolved] call Server_FactoryV2_AddToStorage;

	diag_log format ["[FactoryV2] FinalizeCraftFromDB - Craft %1 finalized (Owner: %2/%3, Output: %4 x%5, NPC: %6)", _craftDBID, _ownerType, _ownerID, _storageClassname, _finalAmount, _craftNpcVarName];

	{
		if (isPlayer _x) then {
			private _playerCharID = _x getVariable ["character_id", ""];
			private _shouldNotify = false;

			if (_ownerType isEqualTo "company") then {
				private _playerCID = [_playerCharID] call A3PL_Config_GetCompanyID;
				if (_playerCID isEqualTo (parseNumber _ownerID)) then {_shouldNotify = true;};
			} else {
				if (_playerCharID isEqualTo _ownerID) then {_shouldNotify = true;};
			};

			if (_shouldNotify) then {
				[_classname, _classType, _finalAmount] remoteExec ["A3PL_FactoryV2_CraftCompletedNotify", _x];
				[_ownerType, _ownerID, _x] call Server_FactoryV2_GetActiveCrafts;
			};
		};
	} forEach allPlayers;
}] call compile_Server;

// Finaliser un craft terminé
// Structure mémoire: [craftDBID, ownerType, ownerID, craftID, amount, createdAt, duration, requiredItems, endTime]
["Server_FactoryV2_FinalizeCraft", {
	private _craftDBID = param [0, 0];

	private _craftIndex = -1;
	{
		if ((_x select 0) isEqualTo _craftDBID) exitWith {_craftIndex = _forEachIndex;};
	} foreach Server_FactoryV2_ActiveCrafts;

	if (_craftIndex < 0) exitWith {};

	private _craft = Server_FactoryV2_ActiveCrafts select _craftIndex;
	private _ownerType = _craft select 1;
	private _ownerID = _craft select 2;
	private _craftID = _craft select 3;
	private _amount = _craft select 4;
	private _craftNpcVarName = if (count _craft > 9) then {_craft select 9} else {""};

	Server_FactoryV2_ActiveCrafts deleteAt _craftIndex;

	private _craftData = Config_FactoryV2_Crafts getOrDefault [str _craftID, []];
	if (count _craftData == 0) exitWith {};

	private _classname = _craftData select 5;
	private _classType = _craftData select 6;
	private _craftName = _craftData select 0;
	private _outputAmount = _craftData select 7;
	if (isNil "_outputAmount" || {typeName _outputAmount != "SCALAR"}) then {_outputAmount = 1;};

	private _finalAmount = _outputAmount * _amount;

	private _storageClassname = _craftName;
	if (_classType isEqualTo "item") then {
		_storageClassname = _classname;
	};

	private _ownerIDStr = if (_ownerID isEqualType 0) then {str _ownerID} else {_ownerID};

	[format [
		"UPDATE factoryv2_crafts SET status = 'completed', completed_time = UTC_TIMESTAMP() WHERE owner_type = '%1' AND owner_id = '%2' AND craft_id = '%3' AND status = 'active' LIMIT 1",
		_ownerType, _ownerIDStr, _craftID
	], 2, true] call Server_Database_Async;

	private _npcObjResolved = if (_craftNpcVarName != "") then {missionNamespace getVariable [_craftNpcVarName, objNull]} else {objNull};
	[_ownerType, _ownerID, [_storageClassname, _finalAmount], objNull, false, objNull, _npcObjResolved] call Server_FactoryV2_AddToStorage;

	diag_log format ["[FactoryV2] FinalizeCraft - Craft %1 completed (Owner: %2/%3, Output: %4 x%5, NPC: %6)", _craftDBID, _ownerType, _ownerID, _storageClassname, _finalAmount, _craftNpcVarName];

	{
		if (isPlayer _x) then {
			private _playerCharID = _x getVariable ["character_id", ""];
			private _shouldNotify = false;

			if (_ownerType isEqualTo "company") then {
				private _playerCID = [_playerCharID] call A3PL_Config_GetCompanyID;
				if (_playerCID isEqualTo _ownerID) then {_shouldNotify = true;};
			} else {
				if (_playerCharID isEqualTo _ownerID) then {_shouldNotify = true;};
			};

			if (_shouldNotify) then {
				[_classname, _classType, _finalAmount] remoteExec ["A3PL_FactoryV2_CraftCompletedNotify", _x];
				[_ownerType, _ownerID, _x] call Server_FactoryV2_GetActiveCrafts;
			};
		};
	} foreach allPlayers;

}] call compile_Server;

// Charger les données de l'usine
// Params: [ownerType, ownerID, player] ou [cid, player] pour rétro-compatibilité
["Server_FactoryV2_LoadData", {
	private _ownerType = param [0, ""];
	private _ownerID = param [1, ""];
	private _player = param [2, objNull];
	private _npcObj = param [3, objNull];

	// Rétro-compatibilité: si premier param est un nombre, c'est un CID
	if (_ownerType isEqualType 0) then {
		private _cid = _ownerType;
		_player = _ownerID;
		_ownerType = "company";
		_ownerID = _cid;
	};

	if (_ownerType isEqualTo "" || _ownerID isEqualTo "" || isNull _player) exitWith {};

	// Vérifier si l'usine existe, sinon la créer
	private _query = [format ["SELECT id FROM factoryv2_factories WHERE owner_type = '%1' AND owner_id = '%2'", _ownerType, _ownerID], 2] call Server_Database_Async;
	if (count _query == 0) then {
		// Créer l'usine avec les valeurs par défaut
		// Civils commencent avec 1 slot, entreprises aussi
		private _insertQuery = format [
			"INSERT INTO factoryv2_factories (owner_type, owner_id, slots, speed_multiplier, efficiency, max_storage) VALUES ('%1', '%2', 1, 1.0, 0, 1000)",
			_ownerType, _ownerID
		];
		[_insertQuery, 1] call Server_Database_Async;
	};

	// Charger les crafts actifs pour ce propriétaire
	[_ownerType, _ownerID, _player] call Server_FactoryV2_GetActiveCrafts;
}] call compile_Server;

// Obtenir les données de l'usine
// Params: [ownerType, ownerID] ou [cid] pour rétro-compatibilité
// Retourne: [slots, speed_multiplier, efficiency, max_storage]
["Server_FactoryV2_GetFactoryData", {
	private _ownerType = param [0, ""];
	private _ownerID = param [1, ""];

	// Rétro-compatibilité: si premier param est un nombre, c'est un CID
	if (_ownerType isEqualType 0) then {
		private _cid = _ownerType;
		_ownerType = "company";
		_ownerID = _cid;
	};

	private _ownerIDStr = if (_ownerID isEqualType "") then {_ownerID} else {str _ownerID};

	private _query = [format [
		"SELECT slots, speed_multiplier, efficiency, max_storage FROM factoryv2_factories WHERE owner_type = '%1' AND owner_id = '%2'",
		_ownerType, _ownerIDStr
	], 2] call Server_Database_Async;

	private _result = [1, 1.0, 0, 1000];

	if (!isNil "_query" && {_query isEqualType [] && {count _query > 0}}) then {
		private _row = _query select 0;
		if (_row isEqualType []) then {
			_result = _row;
		} else {
			// Si _query est directement les valeurs (pas un tableau de tableaux)
			_result = _query;
		};
	};

	_result
}] call compile_Server;

// Obtenir les crafts actifs
// Params: [ownerType, ownerID, player] ou [cid, player] pour rétro-compatibilité
// Structure mémoire: [craftDBID, ownerType, ownerID, craftID, amount, createdAt, duration, requiredItems, endTime]
// Envoie au client: [craftDBID, craftName, endTimeUnix, duration, amount, craftClass, craftType]
["Server_FactoryV2_GetActiveCrafts", {
	private _ownerType = param [0, ""];
	private _ownerID = param [1, ""];
	private _player = param [2, objNull];

	if (_ownerType isEqualType 0) then {
		private _cid = _ownerType;
		_player = _ownerID;
		_ownerType = "company";
		_ownerID = _cid;
	};

	private _factoryData = [_ownerType, _ownerID] call Server_FactoryV2_GetFactoryData;
	private _totalSlots = _factoryData select 0;
	private _ownerIDStr = if (_ownerID isEqualType 0) then {str _ownerID} else {_ownerID};

	private _dbCrafts = [format [
		"SELECT id, craft_id, amount, duration, GREATEST(0, TIMESTAMPDIFF(SECOND, NOW(), end_time)) as seconds_remaining FROM factoryv2_crafts WHERE owner_type = '%1' AND owner_id = '%2' AND status = 'active'",
		_ownerType, _ownerIDStr
	], 2, true] call Server_Database_Async;

	private _activeCrafts = [];
	if (!isNil "_dbCrafts" && {_dbCrafts isEqualType []}) then {
		{
			private _craftDBID = _x select 0;
			private _craftID = _x select 1;
			private _amount = _x select 2;
			private _duration = _x select 3;
			private _secondsRemaining = _x select 4;

			if (_duration isEqualType "") then {
				_duration = parseNumber _duration;
			};
			if (_secondsRemaining isEqualType "") then {
				_secondsRemaining = parseNumber _secondsRemaining;
			};

			private _craftData = Config_FactoryV2_Crafts getOrDefault [str _craftID, []];
			private _craftName = if (count _craftData > 0) then {_craftData select 0} else {"Unknown"};
			private _craftClass = if (count _craftData > 5) then {_craftData select 5} else {""};
			private _craftType = if (count _craftData > 6) then {_craftData select 6} else {"item"};

			_activeCrafts pushBack [
				_craftDBID,
				_craftName,
				_secondsRemaining, 
				_duration,        
				_amount,
				_craftClass,
				_craftType
			];
		} forEach _dbCrafts;
	};

	[_activeCrafts, _totalSlots] remoteExec ["A3PL_FactoryV2_ReceiveActiveCrafts", _player];
}] call compile_Server;

// Obtenir les crafts disponibles
// Params: [ownerType, ownerID, player, npcObj] ou [cid, player] pour rétro-compatibilité
["Server_FactoryV2_GetAvailableCrafts", {
	private _ownerType = param [0, ""];
	private _ownerID = param [1, ""];
	private _player = param [2, objNull];
	private _npcObj = param [3, objNull];

	if (_ownerType isEqualType 0) then {
		private _cid = _ownerType;
		_player = _ownerID;
		_ownerType = "company";
		_ownerID = _cid;
	};

	private _isCivilian = _ownerType isEqualTo "player";
	private _ownerIDStr = if (_ownerID isEqualType "") then {_ownerID} else {str _ownerID};

	private _companyLicenses = [];
	private _ownedLicenseIDs = [];
	if (!_isCivilian) then {
		_companyLicenses = [_ownerID, "licenses"] call A3PL_Config_GetCompanyData;
		if (isNil "_companyLicenses") then {_companyLicenses = [];};
		if !(_companyLicenses isEqualType []) then {_companyLicenses = [];};
	} else {
		private _civilLicensesQuery = [format ["SELECT license_id FROM factoryv2_owned_licenses WHERE owner_type = 'player' AND owner_id = '%1'", _ownerIDStr], 2, true] call Server_Database_Async;
		if (isNil "_civilLicensesQuery") then {_civilLicensesQuery = [];};
		if !(_civilLicensesQuery isEqualType []) then {_civilLicensesQuery = [];};
		{
			if !(_x isEqualType []) then {continue;};
			if (count _x < 1) then {continue;};
			private _licID = _x select 0;
			_ownedLicenseIDs pushBack (if (_licID isEqualType "") then {_licID} else {str _licID});
		} forEach _civilLicensesQuery;
	};

	private _ownedCraftsQuery = [format ["SELECT craft_id FROM factoryv2_owned_crafts WHERE owner_type = '%1' AND owner_id = '%2'", _ownerType, _ownerIDStr], 2, true] call Server_Database_Async;
	if (isNil "_ownedCraftsQuery") then {_ownedCraftsQuery = [];};
	private _ownedCrafts = [];
	{
		if !(_x isEqualType []) then {continue;};
		if (count _x < 1) then {continue;};
		private _rawID = _x select 0;
		_ownedCrafts pushBack (if (_rawID isEqualType "") then {_rawID} else {str _rawID});
	} foreach _ownedCraftsQuery;

	private _sharedCraftsQuery = [format ["SELECT craft_id FROM factoryv2_shares WHERE target_type = '%1' AND target_id = '%2' AND status = 'active'", _ownerType, _ownerIDStr], 2, true] call Server_Database_Async;
	if (isNil "_sharedCraftsQuery") then {_sharedCraftsQuery = [];};
	if !(_sharedCraftsQuery isEqualType []) then {_sharedCraftsQuery = [];};
	private _sharedCrafts = [];
	{
		if !(_x isEqualType []) then {continue;};
		if (count _x < 1) then {continue;};
		private _rawID = _x select 0;
		private _craftIDStr = if (_rawID isEqualType "") then {_rawID} else {str _rawID};
		if !(_craftIDStr in _ownedCrafts) then {
			_sharedCrafts pushBack _craftIDStr;
		};
	} foreach _sharedCraftsQuery;

	private _licenses = [];
	{
		private _licenseID = _x;
		private _data = _y;
		private _licenseName = _data select 0;
		private _licensePrice = _data select 1;
		private _previewPos = _data select 2;
		private _isCivilianLicense = if (count _data >= 4) then {(_data select 3) isEqualTo 1} else {false};
		private _licenseSectors = if (count _data > 4) then {_data select 4} else {[]};
		if (isNil "_licenseSectors") then {_licenseSectors = [];};
		if !(_licenseSectors isEqualType []) then {_licenseSectors = [];};

		if (_isCivilian && !_isCivilianLicense) then {continue;};

		if (FactoryV2_RestrictByNPC) then {
			private _licenseNpcs = if (count _data > 5) then {_data select 5} else {[]};
			if (count _licenseNpcs > 0) then {
				private _npcMatch = false;
				{ if ((missionNamespace getVariable [_x, objNull]) isEqualTo _npcObj) exitWith {_npcMatch = true;} } forEach _licenseNpcs;
				if (!_npcMatch) then {continue;};
			};
		};

		private _hasSectorAccess = [_ownerType, _ownerID, _licenseSectors] call Server_FactoryV2_HasSectorAccess;
		if (!_hasSectorAccess) then {continue;};

		private _hasLicense = false;
		private _licenseIDStr = if (_licenseID isEqualType "") then {_licenseID} else {str _licenseID};
		if (!_isCivilian) then {
			_hasLicense = (format["factoryv2_license_%1", _licenseIDStr]) in _companyLicenses;
		} else {
			_hasLicense = _licenseIDStr in _ownedLicenseIDs;
		};

		_licenses pushBack [
			_licenseID,
			_licenseName,
			_licensePrice,
			_hasLicense,
			_previewPos
		];
	} forEach Config_FactoryV2_Licenses;

	private _crafts = [];
	{
		private _craftID = _x;
		private _data = _y;
		private _craftName = _data select 0;
		private _craftPrice = _data select 1;
		private _requiredItems = _data select 2;
		private _baseDuration = _data select 3;
		private _licenseID = _data select 4;
		private _classname = _data select 5;
		private _classType = _data select 6;
		private _isCivilianCraft = if (count _data >= 10) then {(_data select 9) isEqualTo 1} else {false};
		private _craftFee = if (count _data >= 11) then {_data select 10} else {0};

		private _hasCraft = _craftID in _ownedCrafts;
		private _isShared = _craftID in _sharedCrafts;

		if (_isCivilian && !_isCivilianCraft && !_isShared) then {continue;};

		if (FactoryV2_RestrictByNPC && {_licenseID != "" && _licenseID != "0"}) then {
			private _licenseIDStr = if (_licenseID isEqualType "") then {_licenseID} else {str _licenseID};
			private _licData = Config_FactoryV2_Licenses getOrDefault [_licenseIDStr, []];
			if (count _licData > 5) then {
				private _licNpcs = _licData select 5;
				if (count _licNpcs > 0) then {
					private _npcMatch = false;
					{ if ((missionNamespace getVariable [_x, objNull]) isEqualTo _npcObj) exitWith {_npcMatch = true;} } forEach _licNpcs;
					if (!_npcMatch) then {continue;};
				};
			};
		};

		private _craftSectors = if (count _data > 11) then {_data select 11} else {[]};
		if (isNil "_craftSectors") then {_craftSectors = [];};
		if !(_craftSectors isEqualType []) then {_craftSectors = [];};
		private _hasSectorAccess = [_ownerType, _ownerID, _craftSectors] call Server_FactoryV2_HasSectorAccess;
		if (!_hasSectorAccess && !_isShared) then {continue;};

		if (!_hasCraft && !_isShared && !_isCivilian && _licenseID != "" && _licenseID != "0") then {
			if ((format["factoryv2_license_%1", _licenseID]) in _companyLicenses) then {
				_hasCraft = true;
			};
		};

		_crafts pushBack [
			_craftID,
			_craftName,
			_craftPrice,
			_hasCraft || _isShared,
			_licenseID,
			_requiredItems,
			_baseDuration,
			_classname,
			_classType,
			_craftFee,
			_isShared
		];
	} forEach Config_FactoryV2_Crafts;

	[_crafts, _licenses, _isCivilian] remoteExec ["A3PL_FactoryV2_ReceiveAvailableCrafts", _player];
}] call compile_Server;

// Obtenir les crafts possédés pour la page Factory (arbre de gauche)
// Params: [ownerType, ownerID, player, npcObj] ou [cid, player] pour rétro-compatibilité
["Server_FactoryV2_GetOwnedCraftsForFactory", {
	private _ownerType = param [0, ""];
	private _ownerID = param [1, ""];
	private _player = param [2, objNull];
	private _npcObj = param [3, objNull];

	if (_ownerType isEqualType 0) then {
		private _cid = _ownerType;
		_player = _ownerID;
		_ownerType = "company";
		_ownerID = _cid;
	};

	private _isCivilian = _ownerType isEqualTo "player";

	private _companyLicenses = [];
	private _ownedLicenseIDs = [];
	if (!_isCivilian) then {
		_companyLicenses = [_ownerID, "licenses"] call A3PL_Config_GetCompanyData;
		if (isNil "_companyLicenses") then {_companyLicenses = [];};
		if !(_companyLicenses isEqualType []) then {_companyLicenses = [];};
	} else {
		private _ownerIDStr = if (_ownerID isEqualType "") then {_ownerID} else {str _ownerID};
		private _civilLicensesQuery = [format ["SELECT license_id FROM factoryv2_owned_licenses WHERE owner_type = 'player' AND owner_id = '%1'", _ownerIDStr], 2, true] call Server_Database_Async;
		if (isNil "_civilLicensesQuery") then {_civilLicensesQuery = [];};
		if !(_civilLicensesQuery isEqualType []) then {_civilLicensesQuery = [];};
		{
			if !(_x isEqualType []) then {continue;};
			if (count _x < 1) then {continue;};
			private _licID = _x select 0;
			_ownedLicenseIDs pushBack (if (_licID isEqualType "") then {_licID} else {str _licID});
		} forEach _civilLicensesQuery;
	};

	private _ownerIDStr = if (_ownerID isEqualType "") then {_ownerID} else {str _ownerID};
	private _ownedCraftsQuery = [format ["SELECT craft_id FROM factoryv2_owned_crafts WHERE owner_type = '%1' AND owner_id = '%2'", _ownerType, _ownerIDStr], 2, true] call Server_Database_Async;
	if (isNil "_ownedCraftsQuery") then {_ownedCraftsQuery = [];};
	if !(_ownedCraftsQuery isEqualType []) then {_ownedCraftsQuery = [];};
	private _ownedCrafts = [];
	{
		if !(_x isEqualType []) then {continue;};
		if (count _x < 1) then {continue;};
		private _rawID = _x select 0;
		_ownedCrafts pushBack (if (_rawID isEqualType "") then {_rawID} else {str _rawID});
	} foreach _ownedCraftsQuery;

	private _sharedCraftsQuery = [format ["SELECT craft_id FROM factoryv2_shares WHERE target_type = '%1' AND target_id = '%2' AND status = 'active'", _ownerType, _ownerIDStr], 2, true] call Server_Database_Async;
	if (isNil "_sharedCraftsQuery") then {_sharedCraftsQuery = [];};
	if !(_sharedCraftsQuery isEqualType []) then {_sharedCraftsQuery = [];};
	private _sharedCrafts = [];
	{
		if !(_x isEqualType []) then {continue;};
		if (count _x < 1) then {continue;};
		private _rawID = _x select 0;
		private _craftIDStr = if (_rawID isEqualType "") then {_rawID} else {str _rawID};
		if !(_craftIDStr in _ownedCrafts) then {
			_sharedCrafts pushBack _craftIDStr;
		};
	} foreach _sharedCraftsQuery;

	private _licenses = [];
	{
		private _licenseID = _x;
		private _data = _y;
		private _licenseName = _data select 0;
		private _previewPos = _data select 2;
		private _isCivilianLicense = if (count _data >= 4) then {(_data select 3) isEqualTo 1} else {false};

		if (_isCivilian && !_isCivilianLicense) then {continue;};

		if (FactoryV2_RestrictByNPC) then {
			private _licenseNpcs = if (count _data > 5) then {_data select 5} else {[]};
			if (count _licenseNpcs > 0) then {
				private _npcMatch = false;
				{ if ((missionNamespace getVariable [_x, objNull]) isEqualTo _npcObj) exitWith {_npcMatch = true;} } forEach _licenseNpcs;
				if (!_npcMatch) then {continue;};
			};
		};

		private _licenseSectors = if (count _data > 4) then {_data select 4} else {[]};
		if (isNil "_licenseSectors") then {_licenseSectors = [];};
		if !(_licenseSectors isEqualType []) then {_licenseSectors = [];};
		private _hasSectorAccess = [_ownerType, _ownerID, _licenseSectors] call Server_FactoryV2_HasSectorAccess;
		if (!_hasSectorAccess) then {continue;};

		private _hasLicense = false;
		private _licenseIDStr = if (_licenseID isEqualType "") then {_licenseID} else {str _licenseID};
		if (!_isCivilian) then {
			_hasLicense = (format["factoryv2_license_%1", _licenseIDStr]) in _companyLicenses;
		} else {
			_hasLicense = _licenseIDStr in _ownedLicenseIDs;
		};

		if (_hasLicense) then {
			_licenses pushBack [_licenseID, _licenseName, _hasLicense, _previewPos];
		};
	} forEach Config_FactoryV2_Licenses;

	private _crafts = [];
	{
		private _craftID = _x;
		private _data = _y;
		private _craftName = _data select 0;
		private _requiredItems = _data select 2;
		private _licenseID = _data select 4;
		private _classname = _data select 5;
		private _classType = _data select 6;
		private _outputAmount = _data select 7;
		private _description = _data select 8;
		private _isCivilianCraft = if (count _data >= 10) then {(_data select 9) isEqualTo 1} else {false};
		private _craftFee = if (count _data >= 11) then {_data select 10} else {0};

		private _hasCraft = _craftID in _ownedCrafts;
		private _isShared = _craftID in _sharedCrafts;

		if (_isCivilian && !_isCivilianCraft && !_isShared) then {continue;};

		if (FactoryV2_RestrictByNPC && {_licenseID != "" && _licenseID != "0"}) then {
			private _licenseIDStr = if (_licenseID isEqualType "") then {_licenseID} else {str _licenseID};
			private _licData = Config_FactoryV2_Licenses getOrDefault [_licenseIDStr, []];
			if (count _licData > 5) then {
				private _licNpcs = _licData select 5;
				if (count _licNpcs > 0) then {
					private _npcMatch = false;
					{ if ((missionNamespace getVariable [_x, objNull]) isEqualTo _npcObj) exitWith {_npcMatch = true;} } forEach _licNpcs;
					if (!_npcMatch) then {continue;};
				};
			};
		};

		private _craftSectors = if (count _data > 11) then {_data select 11} else {[]};
		if (isNil "_craftSectors") then {_craftSectors = [];};
		if !(_craftSectors isEqualType []) then {_craftSectors = [];};
		private _hasSectorAccess = [_ownerType, _ownerID, _craftSectors] call Server_FactoryV2_HasSectorAccess;
		if (!_hasSectorAccess && !_isShared) then {continue;};

		if (!_hasCraft && !_isShared && !_isCivilian && {_licenseID != "" && _licenseID != "0"}) then {
			if ((format["factoryv2_license_%1", _licenseID]) in _companyLicenses) then {
				_hasCraft = true;
			};
		};

		if (_hasCraft || _isShared) then {
			_crafts pushBack [_craftID, _craftName, true, _licenseID, _classname, _classType, _outputAmount, _description, _requiredItems, _craftFee, _isShared];
		};
	} forEach Config_FactoryV2_Crafts;

	[_crafts, _licenses, _isCivilian] remoteExec ["A3PL_FactoryV2_ReceiveOwnedCraftsForFactory", _player];
}] call compile_Server;

// Fonction unifiée d'achat (craft ou licence)
// Si isLicense = true, on achète une licence et on ajoute TOUS les crafts de cette licence
// Si isLicense = false, on achète un craft individuel
// Supporte les civils (owner_type = "player") et entreprises (owner_type = "company")
["Server_FactoryV2_Buy", {
	params [["_ownerType", ""], ["_ownerID", ""], ["_itemID", 0], ["_isLicense", false], ["_player", objNull], ["_npcObj", objNull]];

	if (_ownerType isEqualType 0) then {
		private _cid = _ownerType;
		_ownerID = _ownerType;
		_itemID = _ownerID;   
		_isLicense = _itemID; 
		_player = _isLicense; 
		_ownerType = "company";
		_ownerID = _cid;
		_itemID = param [1, 0];
		_isLicense = param [2, false];
		_player = param [3, objNull];
	};

	if (_ownerType isEqualTo "" || _ownerID isEqualTo "" || _ownerID isEqualTo 0 || _itemID isEqualTo 0) exitWith {};

	private _isCivilian = _ownerType isEqualTo "player";
	private _ownerIDStr = if (_ownerID isEqualType "") then {_ownerID} else {str _ownerID};

	private _itemIDStr = str _itemID;
	private _price = 0;
	private _itemName = "";
	private _success = true;

	if (_isLicense) then {

		if (_isCivilian) then {
			private _isCivilianAccessible = [_itemID, true] call Server_FactoryV2_IsCivilianAccessible;
			if (!_isCivilianAccessible) then {
				[("STR_Server_FactoryV2_NotAvailableCivilian" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
				_success = false;
			};
		};

		if (!_success) exitWith {};

		private _alreadyOwned = false;
		if (_isCivilian) then {
			private _checkQuery = [format ["SELECT id FROM factoryv2_owned_licenses WHERE owner_type = 'player' AND owner_id = '%1' AND license_id = '%2'", _ownerIDStr, _itemID], 2] call Server_Database_Async;
			if (count _checkQuery > 0) then {_alreadyOwned = true;};
		} else {
			private _companyLicenses = [_ownerID, "licenses"] call A3PL_Config_GetCompanyData;
			if (isNil "_companyLicenses") then {_companyLicenses = [];};
			if ((format["factoryv2_license_%1", _itemID]) in _companyLicenses) then {_alreadyOwned = true;};
		};

		if (_alreadyOwned) then {
			[("STR_Server_FactoryV2_AlreadyOwned" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
			_success = false;
		};

		if (!_success) exitWith {};

		private _licenseData = Config_FactoryV2_Licenses getOrDefault [_itemIDStr, []];
		if (count _licenseData == 0) then {
			[("STR_Server_FactoryV2_LicenseNotFound" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
			_success = false;
		};

		if (!_success) exitWith {};

		private _licenseSectors = if (count _licenseData > 4) then {_licenseData select 4} else {[]};
		if (isNil "_licenseSectors") then {_licenseSectors = [];};
		if !(_licenseSectors isEqualType []) then {_licenseSectors = [];};
		private _hasSectorAccess = [_ownerType, _ownerID, _licenseSectors] call Server_FactoryV2_HasSectorAccess;
		if (!_hasSectorAccess) then {
			[format[("STR_Server_FactoryV2_SectorRestricted" call A3PL_Localize), _licenseSectors joinString ", "], Color_Red] remoteExec ["A3PL_Notification", _player];
			_success = false;
		};

		if (!_success) exitWith {};

		_itemName = _licenseData select 0;
		_price = _licenseData select 1;
		if (_price isEqualType "") then {_price = parseNumber _price;};

		private _availableFunds = 0;
		if (_isCivilian) then {
			_availableFunds = _player getVariable ["player_bank", 0];
		} else {
			_availableFunds = [_ownerID, "bank"] call A3PL_Config_GetCompanyData;
			if (isNil "_availableFunds") then {_availableFunds = 0;};
		};

		if (_availableFunds < _price) then {
			[format[("STR_Server_FactoryV2_InsufficientFunds" call A3PL_Localize), _price - _availableFunds], Color_Red] remoteExec ["A3PL_Notification", _player];
			_success = false;
		};

		if (!_success) exitWith {};

		if (_isCivilian) then {
			_player setVariable ["player_bank", _availableFunds - _price, true];
		} else {
			[_ownerID, -_price, format[("STR_Server_FactoryV2_BankLicensePurchase" call A3PL_Localize), _itemName]] call Server_Company_SetBank;
		};

		if (_isCivilian) then {
			[format ["INSERT INTO factoryv2_owned_licenses (owner_type, owner_id, license_id) VALUES ('player', '%1', '%2')", _ownerIDStr, _itemID], 1] call Server_Database_Async;
		} else {
			[_ownerID, format["factoryv2_license_%1", _itemID], 1] call Server_Company_SetLicenses;
		};

		{
			private _craftID = _x;
			private _craftData = _y;
			private _craftLicenseID = _craftData select 4;
			private _craftLicenseIDStr = if (_craftLicenseID isEqualType "") then {_craftLicenseID} else {str _craftLicenseID};

			private _craftIsCivilian = if (count _craftData >= 10) then {(_craftData select 9) isEqualTo 1} else {false};
			if (_isCivilian && !_craftIsCivilian) then {continue;};

			if (_craftLicenseIDStr isEqualTo _itemIDStr) then {
				private _checkQuery = [format ["SELECT id FROM factoryv2_owned_crafts WHERE owner_type = '%1' AND owner_id = '%2' AND craft_id = '%3'", _ownerType, _ownerIDStr, _craftID], 2] call Server_Database_Async;
				if (count _checkQuery == 0) then {
					private _insertQuery = format ["INSERT INTO factoryv2_owned_crafts (owner_type, owner_id, craft_id) VALUES ('%1', '%2', '%3')", _ownerType, _ownerIDStr, _craftID];
					[_insertQuery, 1] call Server_Database_Async;
					diag_log format ["[FactoryV2] Added craft %1 to owned_crafts for %2/%3", _craftID, _ownerType, _ownerIDStr];
				};
			};
		} forEach Config_FactoryV2_Crafts;

		[format[("STR_Server_FactoryV2_LicensePurchased" call A3PL_Localize), _price], Color_Green] remoteExec ["A3PL_Notification", _player];

	} else {

		if (_isCivilian) then {
			private _isCivilianAccessible = [_itemID, false] call Server_FactoryV2_IsCivilianAccessible;
			if (!_isCivilianAccessible) then {
				[("STR_Server_FactoryV2_NotAvailableCivilian" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
				_success = false;
			};
		};

		if (!_success) exitWith {};

		private _checkQuery = [format ["SELECT id FROM factoryv2_owned_crafts WHERE owner_type = '%1' AND owner_id = '%2' AND craft_id = '%3'", _ownerType, _ownerIDStr, _itemID], 2] call Server_Database_Async;
		if (count _checkQuery > 0) then {
			[("STR_Server_FactoryV2_AlreadyOwned" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
			_success = false;
		};

		if (!_success) exitWith {};

		private _craftData = Config_FactoryV2_Crafts getOrDefault [_itemIDStr, []];
		if (count _craftData == 0) then {
			[("STR_Server_FactoryV2_CraftNotFound" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
			_success = false;
		};

		if (!_success) exitWith {};

		private _craftSectors = if (count _craftData > 11) then {_craftData select 11} else {[]};
		if (isNil "_craftSectors") then {_craftSectors = [];};
		if !(_craftSectors isEqualType []) then {_craftSectors = [];};
		private _hasSectorAccess = [_ownerType, _ownerID, _craftSectors] call Server_FactoryV2_HasSectorAccess;
		if (!_hasSectorAccess) then {
			[format[("STR_Server_FactoryV2_SectorRestricted" call A3PL_Localize), _craftSectors joinString ", "], Color_Red] remoteExec ["A3PL_Notification", _player];
			_success = false;
		};

		if (!_success) exitWith {};

		_itemName = _craftData select 0;
		_price = _craftData select 1;
		if (_price isEqualType "") then {_price = parseNumber _price;};

		private _availableFunds = 0;
		if (_isCivilian) then {
			_availableFunds = _player getVariable ["player_bank", 0];
		} else {
			_availableFunds = [_ownerID, "bank"] call A3PL_Config_GetCompanyData;
			if (isNil "_availableFunds") then {_availableFunds = 0;};
		};

		if (_availableFunds < _price) then {
			[format[("STR_Server_FactoryV2_InsufficientFunds" call A3PL_Localize), _price - _availableFunds], Color_Red] remoteExec ["A3PL_Notification", _player];
			_success = false;
		};

		if (!_success) exitWith {};

		if (_isCivilian) then {
			_player setVariable ["player_bank", _availableFunds - _price, true];
		} else {
			[_ownerID, -_price, format[("STR_Server_FactoryV2_BankCraftPurchase" call A3PL_Localize), _itemName]] call Server_Company_SetBank;
		};

		private _insertQuery = format ["INSERT INTO factoryv2_owned_crafts (owner_type, owner_id, craft_id) VALUES ('%1', '%2', '%3')", _ownerType, _ownerIDStr, _itemID];
		[_insertQuery, 1] call Server_Database_Async;

		[format[("STR_Server_FactoryV2_CraftPurchased" call A3PL_Localize), _price], Color_Green] remoteExec ["A3PL_Notification", _player];

		if (!_isCivilian) then {
			private _craftLicenseID = _craftData select 4;
			private _craftLicenseIDStr = if (_craftLicenseID isEqualType "") then {_craftLicenseID} else {str _craftLicenseID};

			if (_craftLicenseIDStr != "" && _craftLicenseIDStr != "0") then {
				private _licenseCrafts = [];
				{
					private _craftIDKey = _x;
					private _data = _y;
					private _licenseID = _data select 4;
					private _licenseIDStr = if (_licenseID isEqualType "") then {_licenseID} else {str _licenseID};
					if (_licenseIDStr isEqualTo _craftLicenseIDStr) then {
						_licenseCrafts pushBack _craftIDKey;
					};
				} forEach Config_FactoryV2_Crafts;

				private _ownedCraftsQuery = [format ["SELECT craft_id FROM factoryv2_owned_crafts WHERE owner_type = '%1' AND owner_id = '%2'", _ownerType, _ownerIDStr], 2, true] call Server_Database_Async;
				if (isNil "_ownedCraftsQuery") then {_ownedCraftsQuery = [];};
				private _ownedCrafts = [];
				{
					private _rawID = _x select 0;
					_ownedCrafts pushBack (if (_rawID isEqualType "") then {_rawID} else {str _rawID});
				} foreach _ownedCraftsQuery;

				private _justBoughtStr = if (_itemID isEqualType "") then {_itemID} else {str _itemID};
				if !(_justBoughtStr in _ownedCrafts) then {
					_ownedCrafts pushBack _justBoughtStr;
				};

				private _allOwned = true;
				{
					if !(_x in _ownedCrafts) exitWith {_allOwned = false;};
				} forEach _licenseCrafts;

				if (_allOwned && count _licenseCrafts > 0) then {
					private _companyLicenses = [_ownerID, "licenses"] call A3PL_Config_GetCompanyData;
					if (isNil "_companyLicenses") then {_companyLicenses = [];};

					if !((format["factoryv2_license_%1", _craftLicenseIDStr]) in _companyLicenses) then {
						[_ownerID, format["factoryv2_license_%1", _craftLicenseIDStr], 1] call Server_Company_SetLicenses;

						private _licenseData = Config_FactoryV2_Licenses getOrDefault [_craftLicenseIDStr, []];
						private _licenseName = if (count _licenseData > 0) then {_licenseData select 0} else {"Unknown"};

						[format[("STR_Server_FactoryV2_LicenseGranted" call A3PL_Localize), _licenseName], Color_Green] remoteExec ["A3PL_Notification", _player];
					};
				};
			};
		};
	};

	if (!_success) exitWith {};

	private _ownedCraftsQuery = [format ["SELECT craft_id FROM factoryv2_owned_crafts WHERE owner_type = '%1' AND owner_id = '%2'", _ownerType, _ownerIDStr], 2, true] call Server_Database_Async;
	if (isNil "_ownedCraftsQuery") then {_ownedCraftsQuery = [];};
	private _ownedCrafts = [];
	{
		private _rawID = _x select 0;
		_ownedCrafts pushBack (if (_rawID isEqualType "") then {_rawID} else {str _rawID});
	} foreach _ownedCraftsQuery;

	if (!_isLicense) then {
		private _justBoughtStr = if (_itemID isEqualType "") then {_itemID} else {str _itemID};
		if !(_justBoughtStr in _ownedCrafts) then {
			_ownedCrafts pushBack _justBoughtStr;
		};
	};

	if (_isLicense) then {
		{
			private _craftID = _x;
			private _craftData = _y;
			private _craftLicenseID = _craftData select 4;
			private _craftLicenseIDStr = if (_craftLicenseID isEqualType "") then {_craftLicenseID} else {str _craftLicenseID};
			private _craftIsCivilian = if (count _craftData >= 10) then {(_craftData select 9) isEqualTo 1} else {false};

			if (_isCivilian && !_craftIsCivilian) then {continue;};

			if (_craftLicenseIDStr isEqualTo _itemIDStr) then {
				if !(_craftID in _ownedCrafts) then {
					_ownedCrafts pushBack _craftID;
				};
			};
		} forEach Config_FactoryV2_Crafts;
	};

	private _companyLicenses = [];
	private _ownedLicenseIDs = [];
	if (!_isCivilian) then {
		_companyLicenses = [_ownerID, "licenses"] call A3PL_Config_GetCompanyData;
		if (isNil "_companyLicenses") then {_companyLicenses = [];};
		if !(_companyLicenses isEqualType []) then {_companyLicenses = [];};

		diag_log format ["[FactoryV2] Company licenses from cache: %1", _companyLicenses];

		if (_isLicense) then {
			private _newLicenseStr = format["factoryv2_license_%1", _itemID];
			diag_log format ["[FactoryV2] Adding new license to list: %1", _newLicenseStr];
			if !(_newLicenseStr in _companyLicenses) then {
				_companyLicenses pushBack _newLicenseStr;
			};
			diag_log format ["[FactoryV2] Company licenses after add: %1", _companyLicenses];
		};

		{
			if (_x find "factoryv2_license_" == 0) then {
				private _licID = _x select [count "factoryv2_license_"];
				_ownedLicenseIDs pushBack _licID;
			};
		} forEach _companyLicenses;
	} else {
		private _civilLicensesQuery = [format ["SELECT license_id FROM factoryv2_owned_licenses WHERE owner_type = 'player' AND owner_id = '%1'", _ownerIDStr], 2, true] call Server_Database_Async;
		if (isNil "_civilLicensesQuery") then {_civilLicensesQuery = [];};
		if !(_civilLicensesQuery isEqualType []) then {_civilLicensesQuery = [];};

		diag_log format ["[FactoryV2] Civil licenses query result: %1", _civilLicensesQuery];

		{
			if !(_x isEqualType []) then {continue;};
			if (count _x < 1) then {continue;};
			private _licID = _x select 0;
			private _licIDStr = if (_licID isEqualType "") then {_licID} else {str _licID};
			_ownedLicenseIDs pushBack _licIDStr;
			diag_log format ["[FactoryV2] Added license ID to owned: %1", _licIDStr];
		} forEach _civilLicensesQuery;

		if (_isLicense) then {
			private _justBoughtLicStr = if (_itemID isEqualType "") then {_itemID} else {str _itemID};
			if !(_justBoughtLicStr in _ownedLicenseIDs) then {
				_ownedLicenseIDs pushBack _justBoughtLicStr;
				diag_log format ["[FactoryV2] Added just bought license: %1", _justBoughtLicStr];
			};
		};

		diag_log format ["[FactoryV2] Final ownedLicenseIDs: %1", _ownedLicenseIDs];
	};

	private _licenses = [];
	{
		private _licenseID = _x;
		private _data = _y;
		private _licenseName = _data select 0;
		private _licensePrice = _data select 1;
		private _previewPos = _data select 2;
		private _isCivilianLicense = if (count _data >= 4) then {(_data select 3) isEqualTo 1} else {false};

		if (_isCivilian && !_isCivilianLicense) then {continue;};

		if (FactoryV2_RestrictByNPC) then {
			private _licenseNpcs = if (count _data > 5) then {_data select 5} else {[]};
			if (count _licenseNpcs > 0) then {
				private _npcMatch = false;
				{ if ((missionNamespace getVariable [_x, objNull]) isEqualTo _npcObj) exitWith {_npcMatch = true;} } forEach _licenseNpcs;
				if (!_npcMatch) then {continue;};
			};
		};

		private _hasLicense = false;
		private _licenseIDStr = if (_licenseID isEqualType "") then {_licenseID} else {str _licenseID};
		if (!_isCivilian) then {
			_hasLicense = (format["factoryv2_license_%1", _licenseIDStr]) in _companyLicenses;
		} else {
			_hasLicense = _licenseIDStr in _ownedLicenseIDs;
			diag_log format ["[FactoryV2] Checking license %1 (str: %2) in ownedLicenseIDs %3 = %4", _licenseID, _licenseIDStr, _ownedLicenseIDs, _hasLicense];
		};

		_licenses pushBack [
			_licenseID,
			_licenseName,
			_licensePrice,
			_hasLicense,
			_previewPos
		];
	} forEach Config_FactoryV2_Licenses;

	private _crafts = [];
	{
		private _craftID = _x;
		private _data = _y;
		private _craftName = _data select 0;
		private _craftPrice = _data select 1;
		private _requiredItems = _data select 2;
		private _baseDuration = _data select 3;
		private _licenseID = _data select 4;
		private _classname = _data select 5;
		private _classType = _data select 6;
		private _isCivilianCraft = if (count _data >= 10) then {(_data select 9) isEqualTo 1} else {false};
		private _craftFee = if (count _data >= 11) then {_data select 10} else {0};

		if (_isCivilian && !_isCivilianCraft) then {continue;};

		if (FactoryV2_RestrictByNPC && {_licenseID != "" && _licenseID != "0"}) then {
			private _licenseIDStr = if (_licenseID isEqualType "") then {_licenseID} else {str _licenseID};
			private _licData = Config_FactoryV2_Licenses getOrDefault [_licenseIDStr, []];
			if (count _licData > 5) then {
				private _licNpcs = _licData select 5;
				if (count _licNpcs > 0) then {
					private _npcMatch = false;
					{ if ((missionNamespace getVariable [_x, objNull]) isEqualTo _npcObj) exitWith {_npcMatch = true;} } forEach _licNpcs;
					if (!_npcMatch) then {continue;};
				};
			};
		};

		private _hasCraft = _craftID in _ownedCrafts;
		if (!_hasCraft && !_isCivilian && _licenseID != "" && _licenseID != "0") then {
			if ((format["factoryv2_license_%1", _licenseID]) in _companyLicenses) then {
				_hasCraft = true;
			};
		};

		_crafts pushBack [
			_craftID,
			_craftName,
			_craftPrice,
			_hasCraft,
			_licenseID,
			_requiredItems,
			_baseDuration,
			_classname,
			_classType,
			_craftFee
		];
	} forEach Config_FactoryV2_Crafts;

	[_crafts, _licenses, _isCivilian] remoteExec ["A3PL_FactoryV2_ReceiveAvailableCrafts", _player];

	private _factoryLicenses = [];
	{
		private _licenseID = _x select 0;
		private _licenseName = _x select 1;
		private _hasLicense = _x select 3;
		private _previewPos = _x select 4;

		if (_hasLicense || _isCivilian) then {
			_factoryLicenses pushBack [_licenseID, _licenseName, _hasLicense, _previewPos];
		};
	} forEach _licenses;

	private _factoryCrafts = [];
	private _sharedCraftIDs = [];

	private _sharedCraftsQuery = [format ["SELECT craft_id FROM factoryv2_shares WHERE target_type = '%1' AND target_id = '%2' AND status = 'active'", _ownerType, _ownerIDStr], 2, true] call Server_Database_Async;
	if (!isNil "_sharedCraftsQuery") then {
		{
			_sharedCraftIDs pushBack (str (_x select 0));
		} forEach _sharedCraftsQuery;
	};
	diag_log format ["[FactoryV2] Buy - Shared craft IDs: %1", _sharedCraftIDs];

	{
		private _craftID = _x select 0;
		private _craftName = _x select 1;
		private _hasCraft = _x select 3;
		private _licenseID = _x select 4;
		private _requiredItems = _x select 5;
		private _baseDuration = _x select 6;
		private _classname = _x select 7;
		private _classType = _x select 8;
		private _craftFee = _x select 9;

		private _craftData = Config_FactoryV2_Crafts getOrDefault [_craftID, []];
		private _outputAmount = if (count _craftData >= 8) then {_craftData select 7} else {1};
		private _description = if (count _craftData >= 9) then {_craftData select 8} else {""};

		private _isShared = _craftID in _sharedCraftIDs;

		if (_hasCraft || _isShared) then {
			_factoryCrafts pushBack [_craftID, _craftName, true, _licenseID, _classname, _classType, _outputAmount, _description, _requiredItems, _craftFee, _isShared];
		};
	} forEach _crafts;

	[_factoryCrafts, _factoryLicenses, _isCivilian] remoteExec ["A3PL_FactoryV2_ReceiveOwnedCraftsForFactory", _player];
}] call compile_Server;

// Lancer un craft
// Supporte owner_type/owner_id pour civils et entreprises
// Les civils paient des frais à chaque craft
["Server_FactoryV2_StartCraft", {
	params [["_ownerType", ""], ["_ownerID", ""], ["_craftID", 0], ["_amount", 1], ["_player", objNull], ["_npcObj", objNull]];

	if (_ownerType isEqualType 0) then {
		private _cid = _ownerType;
		_craftID = _ownerID;
		_amount = _craftID;
		_player = _amount;
		_ownerType = "company";
		_ownerID = _cid;
		_craftID = param [1, 0];
		_amount = param [2, 1];
		_player = param [3, objNull];
	};

	if (_ownerType isEqualTo "" || _ownerID isEqualTo "" || _ownerID isEqualTo 0 || _craftID isEqualTo 0 || _amount < 1 || isNull _player) exitWith {};

	private _isCivilian = _ownerType isEqualTo "player";
	private _ownerIDStr = if (_ownerID isEqualType "") then {_ownerID} else {str _ownerID};

	private _craftData = Config_FactoryV2_Crafts getOrDefault [str _craftID, []];
	if (count _craftData == 0) exitWith {
		[("STR_Server_FactoryV2_CraftNotFound" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
	};

	private _requiredItems = _craftData select 2;
	private _baseDuration = _craftData select 3;
	private _licenseID = _craftData select 4;

	private _success = true;
	private _hasCraft = false;
	private _isSharedCraft = false;

	private _sharedCheck = [format ["SELECT id FROM factoryv2_shares WHERE target_type = '%1' AND target_id = '%2' AND craft_id = '%3' AND status = 'active'", _ownerType, _ownerIDStr, _craftID], 2] call Server_Database_Async;
	diag_log format ["[FactoryV2] StartCraft - sharedCheck query for type=%1, id=%2, craft=%3: %4", _ownerType, _ownerIDStr, _craftID, _sharedCheck];
	if (!isNil "_sharedCheck" && {count _sharedCheck > 0}) then {
		_isSharedCraft = true;
		_hasCraft = true;
		diag_log format ["[FactoryV2] StartCraft - Craft partagé trouvé! isSharedCraft=%1, hasCraft=%2", _isSharedCraft, _hasCraft];
	};

	if (_isCivilian && !_isSharedCraft) then {
		private _isCivilianAccessible = [_craftID, false] call Server_FactoryV2_IsCivilianAccessible;
		if (!_isCivilianAccessible) then {
			[("STR_Server_FactoryV2_NotAvailableCivilian" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
			_success = false;
		};
	};

	if (!_success) exitWith {};

	// Vérification du secteur d'activité (sauf pour les crafts partagés)
	if (!_isSharedCraft) then {
		private _craftSectors = if (count _craftData > 11) then {_craftData select 11} else {[]};
		if (isNil "_craftSectors") then {_craftSectors = [];};
		if !(_craftSectors isEqualType []) then {_craftSectors = [];};
		private _hasSectorAccess = [_ownerType, _ownerID, _craftSectors] call Server_FactoryV2_HasSectorAccess;
		if (!_hasSectorAccess) then {
			[format[("STR_Server_FactoryV2_SectorRestricted" call A3PL_Localize), _craftSectors joinString ", "], Color_Red] remoteExec ["A3PL_Notification", _player];
			_success = false;
		};
	};

	if (!_success) exitWith {};

	if (!_hasCraft) then {
		if (_isCivilian) then {
			private _checkQuery = [format ["SELECT id FROM factoryv2_owned_crafts WHERE owner_type = 'player' AND owner_id = '%1' AND craft_id = '%2'", _ownerIDStr, _craftID], 2] call Server_Database_Async;
			if (!isNil "_checkQuery" && {count _checkQuery > 0}) then {_hasCraft = true;};

			if (!_hasCraft && {_licenseID != "" && _licenseID != "0"}) then {
				private _licenseCheck = [format ["SELECT id FROM factoryv2_owned_licenses WHERE owner_type = 'player' AND owner_id = '%1' AND license_id = '%2'", _ownerIDStr, _licenseID], 2] call Server_Database_Async;
				if (!isNil "_licenseCheck" && {count _licenseCheck > 0}) then {_hasCraft = true;};
			};
		} else {
			private _checkQuery = [format ["SELECT id FROM factoryv2_owned_crafts WHERE owner_type = 'company' AND owner_id = '%1' AND craft_id = '%2'", _ownerIDStr, _craftID], 2] call Server_Database_Async;
			if (!isNil "_checkQuery" && {count _checkQuery > 0}) then {_hasCraft = true;};

			if (!_hasCraft && {_licenseID != "" && _licenseID != "0"}) then {
				private _companyLicenses = [_ownerID, "licenses"] call A3PL_Config_GetCompanyData;
				if (isNil "_companyLicenses") then {_companyLicenses = [];};
				if (format["factoryv2_license_%1", _licenseID] in _companyLicenses) then {
					_hasCraft = true;
				};
			};
		};
	};

	if (!_hasCraft) exitWith {
		[("STR_Server_FactoryV2_NoCraftAccess" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
	};

	private _craftFee = 0;
	private _shareOwnerID = "";
	private _shareOwnerType = "";

	if (_isSharedCraft) then {
		private _shareDataRaw = [format ["SELECT share_type, price, owner_type, owner_id FROM factoryv2_shares WHERE target_type = '%1' AND target_id = '%2' AND craft_id = '%3' AND status = 'active'", _ownerType, _ownerIDStr, _craftID], 2, true] call Server_Database_Async;
		diag_log format ["[FactoryV2] ShareDataRaw: %1", _shareDataRaw];
		if (!isNil "_shareDataRaw" && {count _shareDataRaw > 0}) then {
			private _shareData = _shareDataRaw select 0;
			diag_log format ["[FactoryV2] ShareData row: %1", _shareData];
			private _priceType = _shareData select 0;
			private _craftPriceRaw = _shareData select 1;
			private _craftPrice = if (_craftPriceRaw isEqualType "") then {parseNumber _craftPriceRaw} else {_craftPriceRaw};
			_shareOwnerType = _shareData select 2;
			private _shareOwnerIDRaw = _shareData select 3;
			_shareOwnerID = if (_shareOwnerIDRaw isEqualType "") then {_shareOwnerIDRaw} else {str _shareOwnerIDRaw};
			diag_log format ["[FactoryV2] Parsed - priceType: %1, craftPrice: %2, shareOwnerType: %3, shareOwnerID: %4", _priceType, _craftPrice, _shareOwnerType, _shareOwnerID];

			if (_priceType isEqualTo "craft" && {_craftPrice > 0}) then {
				_craftFee = _craftPrice * _amount;
				diag_log format ["[FactoryV2] CraftFee calculated: %1", _craftFee];
			};
		};
	} else {
		if (_isCivilian) then {
			_craftFee = [_craftID] call Server_FactoryV2_GetCraftFee;
			_craftFee = _craftFee * _amount;
		};
	};

	if (_craftFee > 0) then {
		if (_isCivilian) then {
			private _playerBank = _player getVariable ["player_bank", 0];
			if (_playerBank < _craftFee) then {
				[format[("STR_Server_FactoryV2_InsufficientFundsForCraft" call A3PL_Localize), _craftFee - _playerBank], Color_Red] remoteExec ["A3PL_Notification", _player];
				_success = false;
			};
		} else {
			private _companyBank = [_ownerID, "bank"] call A3PL_Config_GetCompanyData;
			if (isNil "_companyBank") then {_companyBank = 0;};
			if (_companyBank < _craftFee) then {
				[format[("STR_Server_FactoryV2_InsufficientFundsForCraft" call A3PL_Localize), _craftFee - _companyBank], Color_Red] remoteExec ["A3PL_Notification", _player];
				_success = false;
			};
		};
	};

	if (!_success) exitWith {};

	private _factoryData = [_ownerType, _ownerID] call Server_FactoryV2_GetFactoryData;
	private _slots = _factoryData select 0;
	private _speedMultiplier = _factoryData select 1;
	private _efficiency = if (count _factoryData > 2) then {_factoryData select 2} else {0};
	private _maxStorage = if (count _factoryData > 3) then {_factoryData select 3} else {1000};

	private _activeSlots = 0;
	{
		private _craftOwnerType = _x select 1;
		private _craftOwnerID = _x select 2;
		if (_craftOwnerType isEqualTo _ownerType && {str _craftOwnerID isEqualTo _ownerIDStr}) then {
			_activeSlots = _activeSlots + 1;
		};
	} foreach Server_FactoryV2_ActiveCrafts;

	if (_activeSlots >= _slots) exitWith {
		[format[("STR_Server_FactoryV2_NoSlotsAvailable" call A3PL_Localize), _slots], Color_Red] remoteExec ["A3PL_Notification", _player];
	};

	private _npcVarName = [_npcObj] call Server_FactoryV2_GetNpcVarName;
	private _storageRaw = [format ["SELECT items FROM factoryv2_storage WHERE owner_type = '%1' AND owner_id = '%2' AND npc = '%3'", _ownerType, _ownerIDStr, _npcVarName], 2, true] call Server_Database_Async;

	private _storage = [];
	if (!isNil "_storageRaw" && {_storageRaw isEqualType [] && {count _storageRaw > 0}}) then {
		private _itemsRaw = _storageRaw select 0 select 0;
		if (_itemsRaw isEqualType "") then {
			_storage = [_itemsRaw] call Server_Database_ToArray;
		};
		if (_itemsRaw isEqualType []) then {
			_storage = _itemsRaw;
		};
	};
	if (isNil "_storage") then {_storage = [];};
	if !(_storage isEqualType []) then {_storage = [];};

	private _hasAllItems = true;
	{
		private _itemID = toLower (_x select 0);
		private _requiredAmount = (_x select 1) * _amount;

		private _availableAmount = 0;
		{
			if ((toLower (_x select 0)) isEqualTo _itemID) then {
				_availableAmount = _x select 1;
			};
		} foreach _storage;

		if (_availableAmount < _requiredAmount) then {
			_hasAllItems = false;
		};
	} foreach _requiredItems;

	if (!_hasAllItems) exitWith {
		[("STR_Server_FactoryV2_InsufficientMaterials" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
	};

	if (_craftFee > 0) then {
		if (_isCivilian) then {
			private _playerBank = _player getVariable ["player_bank", 0];
			_player setVariable ["player_bank", _playerBank - _craftFee, true];
		} else {
			[_ownerID, -_craftFee, format[("STR_Server_FactoryV2_SharedCraftFee" call A3PL_Localize), _craftFee]] call Server_Company_SetBank;
		};
		[format[("STR_Server_FactoryV2_CraftFeeCharged" call A3PL_Localize), _craftFee], Color_Yellow] remoteExec ["A3PL_Notification", _player];

		if (_isSharedCraft && {_shareOwnerID != ""}) then {
			diag_log format ["[FactoryV2] Crediting share owner - Type: %1, ID: %2, Amount: %3", _shareOwnerType, _shareOwnerID, _craftFee];
			if (_shareOwnerType isEqualTo "company") then {
				private _companyIDNum = parseNumber _shareOwnerID;
				if (_companyIDNum > 0) then {
					diag_log format ["[FactoryV2] Calling Server_Company_SetBank with CID: %1, Amount: %2", _companyIDNum, _craftFee];
					[_companyIDNum, _craftFee, format[("STR_Server_FactoryV2_SharedCraftRevenue" call A3PL_Localize), _craftFee]] call Server_Company_SetBank;
				} else {
					diag_log format ["[FactoryV2] ERROR - Invalid company ID parsed: %1 from string '%2'", _companyIDNum, _shareOwnerID];
				};
			} else {
				diag_log format ["[FactoryV2] Crediting player via DB - CharID: %1, Amount: %2", _shareOwnerID, _craftFee];
				[format ["UPDATE players SET bank = bank + %1 WHERE character_id = '%2'", _craftFee, _shareOwnerID], 1] call Server_Database_Async;
			};
		} else {
			diag_log format ["[FactoryV2] NOT crediting - isSharedCraft: %1, shareOwnerID: '%2'", _isSharedCraft, _shareOwnerID];
		};
	};

	private _totalSaved = 0;
	{
		private _itemID = toLower (_x select 0);
		private _baseRequired = (_x select 1) * _amount;
		private _actualRequired = _baseRequired;

		if (_efficiency > 0) then {
			private _saved = 0;
			for "_i" from 1 to _baseRequired do {
				if ((random 100) < _efficiency) then {
					_saved = _saved + 1;
				};
			};
			_saved = _saved min (_baseRequired - 1);
			_actualRequired = _baseRequired - _saved;
			_totalSaved = _totalSaved + _saved;
		};

		_storage = [_storage, _itemID, -_actualRequired, true] call BIS_fnc_addToPairs;
		{
			if ((_x select 1) < 1) then {
				_storage deleteAt _forEachIndex;
			};
		} foreach _storage;
	} foreach _requiredItems;

	if (_totalSaved > 0) then {
		[format[("STR_Server_FactoryV2_EfficiencySaved" call A3PL_Localize), _totalSaved], Color_Green] remoteExec ["A3PL_Notification", _player];
	};

	private _storageArray = [_storage] call Server_Database_Array;
	[format ["UPDATE factoryv2_storage SET items = '%1' WHERE owner_type = '%2' AND owner_id = '%3' AND npc = '%4'", _storageArray, _ownerType, _ownerIDStr, _npcVarName], 1] call Server_Database_Async;

	private _duration = (_baseDuration * _amount) / _speedMultiplier;
	private _durationInt = round _duration;
	private _requiredItemsArray = [_requiredItems] call Server_Database_Array;

	[format [
		"INSERT INTO factoryv2_crafts (owner_type, owner_id, craft_id, amount, created_at, duration, end_time, required_items, status, npc) VALUES ('%1', '%2', '%3', '%4', NOW(), '%5', DATE_ADD(NOW(), INTERVAL %6 SECOND), '%7', 'active', '%8')",
		_ownerType, _ownerIDStr, _craftID, _amount, _durationInt, _durationInt, _requiredItemsArray, _npcVarName
	], 1] call Server_Database_Async;

	private _lastIDQuery = ["SELECT LAST_INSERT_ID() as id", 2, true] call Server_Database_Async;
	private _realDBID = 0;
	if (!isNil "_lastIDQuery" && {_lastIDQuery isEqualType [] && {count _lastIDQuery > 0}}) then {
		private _row = _lastIDQuery select 0;
		if (_row isEqualType [] && {count _row > 0}) then {
			_realDBID = _row select 0;
			if (_realDBID isEqualType "") then {_realDBID = parseNumber _realDBID;};
		};
	};

	if (_realDBID == 0) then {
		_realDBID = round (random 900000) + 100000;
		diag_log format ["[FactoryV2] WARNING - Could not get LAST_INSERT_ID, using tempID: %1", _realDBID];
	};

	private _now = systemTimeUTC;
	private _createdAt = format ["%1-%2-%3 %4:%5:%6",
		_now select 0,
		[_now select 1, 2] call BIS_fnc_numberText,
		[_now select 2, 2] call BIS_fnc_numberText,
		[_now select 3, 2] call BIS_fnc_numberText,
		[_now select 4, 2] call BIS_fnc_numberText,
		[_now select 5, 2] call BIS_fnc_numberText
	];

	private _endSeconds = (_now select 5) + _durationInt;
	private _endMinutes = _now select 4;
	private _endHours = _now select 3;
	private _endDays = _now select 2;
	private _endMonths = _now select 1;
	private _endYears = _now select 0;

	while {_endSeconds >= 60} do {
		_endSeconds = _endSeconds - 60;
		_endMinutes = _endMinutes + 1;
	};
	while {_endMinutes >= 60} do {
		_endMinutes = _endMinutes - 60;
		_endHours = _endHours + 1;
	};
	while {_endHours >= 24} do {
		_endHours = _endHours - 24;
		_endDays = _endDays + 1;
	};

	private _endTime = format ["%1-%2-%3 %4:%5:%6",
		_endYears,
		[_endMonths, 2] call BIS_fnc_numberText,
		[_endDays, 2] call BIS_fnc_numberText,
		[_endHours, 2] call BIS_fnc_numberText,
		[_endMinutes, 2] call BIS_fnc_numberText,
		[round _endSeconds, 2] call BIS_fnc_numberText
	];

	Server_FactoryV2_ActiveCrafts pushBack [
		_realDBID,
		_ownerType,
		_ownerIDStr,
		_craftID,
		_amount,
		_createdAt,
		_durationInt,
		_requiredItems,
		_endTime,
		_npcVarName
	];

	diag_log format ["[FactoryV2] Craft ajouté en mémoire - DBID: %1, OwnerType: %2, OwnerID: %3, CraftID: %4, EndTime: %5", _realDBID, _ownerType, _ownerID, _craftID, _endTime];

	[("STR_Server_FactoryV2_CraftStarted" call A3PL_Localize), Color_Green] remoteExec ["A3PL_Notification", _player];

	[_ownerType, _ownerID, _player] call Server_FactoryV2_GetActiveCrafts;
	[_ownerType, _ownerID, _player] call Server_FactoryV2_GetStorage;
}] call compile_Server;

// Helper: Résoudre le nom de variable NPC depuis un objet
// Retourne "" si pas de restriction NPC ou objet null
["Server_FactoryV2_GetNpcVarName", {
	params [["_npcObj", objNull]];
	diag_log format ["[FactoryV2] GetNpcVarName - _npcObj=%1, isNull=%2, RestrictByNPC=%3", _npcObj, isNull _npcObj, FactoryV2_RestrictByNPC];
	if (isNull _npcObj) exitWith {""};
	if (FactoryV2_RestrictByNPC) then {
		private _varName = "";
		{
			private _licenseNpcs = if (count _y > 5) then {_y select 5} else {[]};
			{
				private _resolved = missionNamespace getVariable [_x, objNull];
				diag_log format ["[FactoryV2] GetNpcVarName - '%1' resolved=%2, _npcObj=%3, match=%4", _x, _resolved, _npcObj, _resolved isEqualTo _npcObj];
				if (_resolved isEqualTo _npcObj) exitWith {_varName = _x;};
			} forEach _licenseNpcs;
			if (_varName != "") exitWith {};
		} forEach Config_FactoryV2_Licenses;
		diag_log format ["[FactoryV2] GetNpcVarName - RESULT='%1'", _varName];
		_varName
	} else {
		""
	}
}] call compile_Server;

// Obtenir le stockage - Retourne [items, currentStorage, maxStorage]
// Si _player est fourni, envoie aussi les données au client
// Supporte owner_type/owner_id pour civils et entreprises
["Server_FactoryV2_GetStorage", {
	private _ownerType = param [0, ""];
	private _ownerID = param [1, ""];
	private _player = param [2, objNull];
	private _npcObj = param [3, objNull];

	if (_ownerType isEqualType 0) then {
		private _cid = _ownerType;
		_player = _ownerID;
		_ownerType = "company";
		_ownerID = _cid;
	};

	if (_ownerType isEqualTo "" || _ownerID isEqualTo "" || _ownerID isEqualTo 0) exitWith {[[], 0, 1000]};

	private _ownerIDStr = if (_ownerID isEqualType "") then {_ownerID} else {str _ownerID};
	private _npcVarName = [_npcObj] call Server_FactoryV2_GetNpcVarName;

	private _factoryData = [_ownerType, _ownerID] call Server_FactoryV2_GetFactoryData;
	private _maxStorage = _factoryData select 3;

	private _storageRaw = [format [
		"SELECT items, current_storage FROM factoryv2_storage WHERE owner_type = '%1' AND owner_id = '%2' AND npc = '%3'",
		_ownerType, _ownerIDStr, _npcVarName
	], 2, true] call Server_Database_Async;

	private _storage = [];
	private _currentStorage = 0;

	if (!isNil "_storageRaw" && {_storageRaw isEqualType [] && {count _storageRaw > 0}}) then {
		private _row = _storageRaw select 0;
		private _itemsRaw = _row select 0;

		if (_itemsRaw isEqualType "") then {
			_storage = [_itemsRaw] call Server_Database_ToArray;
		} else {
			if (_itemsRaw isEqualType []) then {_storage = _itemsRaw;};
		};
		if (isNil "_storage") then {_storage = [];};
		if !(_storage isEqualType []) then {_storage = [];};

		_currentStorage = _row select 1;
	} else {
		[format ["INSERT INTO factoryv2_storage (owner_type, owner_id, items, current_storage, max_storage, npc) VALUES ('%1', '%2', '[]', 0, '%3', '%4')", _ownerType, _ownerIDStr, _maxStorage, _npcVarName], 1] call Server_Database_Async;
	};

	if (!isNull _player) then {
		[_storage, _maxStorage, _currentStorage] remoteExec ["A3PL_FactoryV2_ReceiveStorage", _player];
	};

	[_storage, _currentStorage, _maxStorage]
}] call compile_Server;

// Ajouter au stockage - Adapté de Server_Factory_Add
// Gère: inventaire, cash, objets physiques (véhicules ramassés, etc.)
// Supporte owner_type/owner_id pour civils et entreprises
["Server_FactoryV2_AddToStorage", {
	params [
		["_ownerType", ""],
		["_ownerID", ""],
		["_item", ["", 1]],
		["_player", objNull],
		["_move", true],
		["_objOrNetId", objNull],
		["_npcObj", objNull]
	];

	if (_ownerType isEqualType 0) then {
		private _cid = _ownerType;
		_item = _ownerID;
		_player = _item;
		_move = _player;
		_objOrNetId = _move;
		_ownerType = "company";
		_ownerID = _cid;
		_item = param [1, ["", 1]];
		_player = param [2, objNull];
		_move = param [3, true];
		_objOrNetId = param [4, objNull];
	};

	private _obj = objNull;
	if (_objOrNetId isEqualType "") then {
		_obj = objectFromNetId _objOrNetId;
	} else {
		_obj = _objOrNetId;
	};

	private _id = _item select 0;
	private _amount = _item select 1;
	if !((_item isEqualType []) && (count _item) >= 2) exitWith {
		diag_log format ["[FactoryV2] Server_FactoryV2_AddToStorage called with malformed _item: %1", _item];
	};

	_id = toLower _id;

	if (_ownerType isEqualTo "" || _ownerID isEqualTo "" || _ownerID isEqualTo 0 || _id isEqualTo "") exitWith {};

	private _ownerIDStr = if (_ownerID isEqualType "") then {_ownerID} else {str _ownerID};
	private _fail = false;

	if (_move) then {
		if (!isNull _obj) then {
			deleteVehicle _obj;
		} else {
			diag_log format ["ID: %1 | Amount: %2 | Player: %3", _id, _amount, _player];
			private _has = [_id, _amount, _player] call Server_Inventory_Has;
			if (!_has) exitWith {_fail = true;};

			if (_id isEqualTo "cash") exitWith {
				_player setVariable ["player_cash", ((_player getVariable ["player_cash", 0]) - _amount), true];
			};

			private _inventory = _player getVariable ["player_inventory", []];
			_inventory = [_inventory, _id, -_amount, true] call BIS_fnc_addToPairs;
			{
				if ((_x select 1) < 1) then {_inventory deleteAt _forEachIndex;};
			} forEach _inventory;
			_player setVariable ["player_inventory", _inventory, true];
			[_player] call Server_Inventory_Verify;
		};
	};

	if (_fail) exitWith {
		[("STR_Server_FactoryV2_NoItem" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
	};

	private _npcVarName = [_npcObj] call Server_FactoryV2_GetNpcVarName;
	private _storageData = [_ownerType, _ownerID, objNull, _npcObj] call Server_FactoryV2_GetStorage;
	private _storage = _storageData select 0;
	private _currentStorage = _storageData select 1;
	private _maxStorage = _storageData select 2;

	private _itemWeight = 1;
	if (!isNil "Config_ItemMap" && {Config_ItemMap getOrDefault [_id, []] isNotEqualTo []}) then {
		_itemWeight = [_id, "weight"] call A3PL_Config_GetItem;
		if (isNil "_itemWeight" || {typeName _itemWeight != "SCALAR"}) then { _itemWeight = 1; };
	};
	private _newStorage = _currentStorage + (_itemWeight * _amount);

	if (_newStorage > _maxStorage && !isNull _player) then {
		[format[("STR_Server_FactoryV2_StorageFull" call A3PL_Localize), _maxStorage], Color_Red] remoteExec ["A3PL_Notification", _player];
	};

	_storage = [_storage, _id, _amount, true] call BIS_fnc_addToPairs;

	private _storageArray = [_storage] call Server_Database_Array;
	[format ["UPDATE factoryv2_storage SET items = '%1', current_storage = '%2' WHERE owner_type = '%3' AND owner_id = '%4' AND npc = '%5'", _storageArray, _newStorage, _ownerType, _ownerIDStr, _npcVarName], 1] call Server_Database_Async;

	if (!isNull _player) then {
		[format[("STR_Server_FactoryV2_ItemAdded" call A3PL_Localize), _amount], Color_Green] remoteExec ["A3PL_Notification", _player];
		[_storage, _maxStorage, _newStorage] remoteExec ["A3PL_FactoryV2_ReceiveStorage", _player];
	};

	private _newTotal = 0;
	{if ((_x select 0) isEqualTo _id) exitWith {_newTotal = _x select 1;};} forEach _storage;
	if (!isNull _player) then {
		[getPlayerUID _player, (_player getVariable ["character_id", ""]), "FactoryV2_Add", [format ["OwnerType: %1 | OwnerID: %2 | Item: %3 | Amount: %4 | NewTotal: %5", _ownerType, _ownerIDStr, _id, _amount, _newTotal]]] call Server_Log_New;
	};
}] call compile_Server;

// Retirer du stockage et créer l'objet - Adapté de Server_Factory_Collect + Server_Factory_Create
// Gère: items pickupables, véhicules, vêtements, armes, etc.
// Supporte owner_type/owner_id pour civils et entreprises
["Server_FactoryV2_AddToInventory", {
	params [["_ownerType", ""], ["_ownerID", ""], ["_item", ["", 1]], ["_player", objNull], ["_move", true], ["_objOrNetId", objNull], ["_npcObj", objNull]];

	if (_ownerType isEqualType 0) then {
		private _cid = _ownerType;
		_item = _ownerID;
		_player = _item;
		_ownerType = "company";
		_ownerID = _cid;
		_item = param [1, ["", 1]];
		_player = param [2, objNull];
	};

	private _id = toLower (_item select 0);
	private _amount = _item select 1;

	if (_ownerType isEqualTo "" || _ownerID isEqualTo "" || _ownerID isEqualTo 0 || _id isEqualTo "" || _amount < 1 || isNull _player) exitWith {};

	private _ownerIDStr = if (_ownerID isEqualType "") then {_ownerID} else {str _ownerID};

	private _storageData = [_ownerType, _ownerID, objNull, _npcObj] call Server_FactoryV2_GetStorage;
	private _storage = _storageData select 0;
	private _maxStorage = _storageData select 2;

	if (count _storage == 0) exitWith {
		[("STR_Server_FactoryV2_NoStorage" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
	};

	private _availableAmount = 0;
	{if ((toLower (_x select 0)) isEqualTo _id) then {_availableAmount = _x select 1;};} forEach _storage;

	if (_availableAmount < _amount) exitWith {
		[format[("STR_Server_FactoryV2_InsufficientItems" call A3PL_Localize), _availableAmount], Color_Red] remoteExec ["A3PL_Notification", _player];
	};

	private _classType = "item";
	private _realClass = _id;

	private _parts = _id splitString "_";
	if (count _parts > 0 && {(toLower (_parts#0)) isEqualTo "f"}) then {
		private _craftData = [_id] call A3PL_FactoryV2_GetCraftData;
		if (count _craftData >= 2) then {
			_realClass = _craftData select 0;
			_classType = _craftData select 1;
		};
	};

	switch (_classType) do {

		case "car";
		case "plane";
		case "heli";
		case "vehicle": {
			private _pos = (getPos _player) findEmptyPosition [3, 65, _realClass];
			private _lp = [_player, _realClass, "vehicle", true] call Server_Vehicle_Buy;
			if !(_realClass in ["A3FL_LCM", "A3PL_RHIB", "A3PL_Motorboat", "A3PL_Yacht", "C_Scooter_Transport_01_F", "A3PL_RBM"]) then {
				_pos = [_pos select 0, _pos select 1, (_pos select 2) + 0.5];
				private _veh = [_realClass, _pos, _lp, _player] call Server_Vehicle_Spawn;
				_veh setDir 90;
				[_veh, _player] remoteExec ["A3PL_Lib_ChangeLocality", 2];
			};
		};

		case "item": {
			private _canPickup = [_realClass, "canPickup"] call A3PL_Config_GetItem;
			if (isNil "_canPickup") then {_canPickup = true;};

			if (_canPickup) then {
				if !([_realClass, _amount] call A3PL_InventoryNew_CanAddItem) exitWith {
					["STR_A3PL_Inventory_NotEnoughGridSpace" call A3PL_Localize, Color_Red] call A3PL_Notification;
				};
				[_player, _realClass, _amount, false] call Server_Inventory_Add;
			} else {
				if (_amount > 1) exitWith {
					[("STR_Server_Factory_OnlyOneItem" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
					[_ownerType, _ownerID, [_id, _amount], _player, false, objNull, _npcObj] call Server_FactoryV2_AddToStorage;
				};
				private _objClass = [_realClass, "class"] call A3PL_Config_GetItem;
				private _obj = createVehicle [_objClass, (getPos _player), [], 0, "CAN_COLLIDE"];
				_obj setVariable ["owner", (_player getVariable ["character_id", ""]), true];
				_obj setVariable ["class", _realClass, true];
				[_obj, _player] remoteExec ["A3PL_Lib_ChangeLocality", 2];
				_obj setVariable ["factory_owner_type", _ownerType, true];
				_obj setVariable ["factory_owner_id", _ownerIDStr, true];
			};
		};

		case "weapon";
		case "magazine";
		case "mag";
		case "aitem";
		case "weaponitem";
		case "secweaponitem";
		case "vest";
		case "uniform";
		case "goggles";
		case "headgear";
		case "backpack": {
			private _obj = objNull;
			if (_classType isEqualTo "uniform") then {
				_obj = createVehicle ["A3PL_Clothing", (getPosATL _player), [], 0, "CAN_COLLIDE"];
			} else {
				_obj = createVehicle ["A3PL_Crate", (getPosATL _player), [], 0, "CAN_COLLIDE"];
			};
			_obj setVariable ["owner", (_player getVariable ["character_id", ""]), true];
			_obj setVariable ["class", "ainv", true];
			_obj setVariable ["ainv", [_classType, _realClass, _amount], true];
			_obj setVariable ["factory_owner_type", _ownerType, true];
			_obj setVariable ["factory_owner_id", _ownerIDStr, true];
		};

		default {
			[_player, _realClass, _amount, false] call Server_Inventory_Add;
		};
	};

	_storage = [_storage, _id, -_amount, true] call BIS_fnc_addToPairs;
	{if ((_x select 1) < 1) then {_storage deleteAt _forEachIndex;};} forEach _storage;

	private _itemWeight = 1;
	if (_classType isEqualTo "item") then {
		_itemWeight = [_realClass, "weight"] call A3PL_Config_GetItem;
		if (isNil "_itemWeight") then {_itemWeight = 1;};
	};

	private _currentStorage = _storageData select 1;
	private _newStorage = (_currentStorage - (_itemWeight * _amount)) max 0;

	private _npcVarName = [_npcObj] call Server_FactoryV2_GetNpcVarName;
	private _storageArray = [_storage] call Server_Database_Array;
	[format ["UPDATE factoryv2_storage SET items = '%1', current_storage = '%2' WHERE owner_type = '%3' AND owner_id = '%4' AND npc = '%5'", _storageArray, _newStorage, _ownerType, _ownerIDStr, _npcVarName], 1] call Server_Database_Async;

	[format[("STR_Server_FactoryV2_ItemRemoved" call A3PL_Localize), _amount], Color_Green] remoteExec ["A3PL_Notification", _player];
	[_storage, _maxStorage, _newStorage] remoteExec ["A3PL_FactoryV2_ReceiveStorage", _player];

	[getPlayerUID _player, (_player getVariable ["character_id", ""]), "FactoryV2_Collect", [format ["OwnerType: %1 | OwnerID: %2 | Item: %3 | Amount: %4", _ownerType, _ownerIDStr, _id, _amount]]] call Server_Log_New;
}] call compile_Server;

// Obtenir les upgrades
// Params: [ownerType, ownerID, player] ou [cid, player] pour rétro-compatibilité
["Server_FactoryV2_GetUpgrades", {
	private _ownerType = param [0, ""];
	private _ownerID = param [1, ""];
	private _player = param [2, objNull];

	// Rétro-compatibilité: si premier param est un nombre, c'est un CID
	if (_ownerType isEqualType 0) then {
		private _cid = _ownerType;
		_player = _ownerID;
		_ownerType = "company";
		_ownerID = _cid;
	};

	if (_ownerType isEqualTo "" || _ownerID isEqualTo "" || _ownerID isEqualTo 0) exitWith {};

	private _ownerIDStr = if (_ownerID isEqualType "") then {_ownerID} else {str _ownerID};

	private _ownedUpgradesQuery = [format [
		"SELECT upgrade_id FROM factoryv2_owned_upgrades WHERE owner_type = '%1' AND owner_id = '%2'",
		_ownerType, _ownerIDStr
	], 2, true] call Server_Database_Async;
	private _ownedUpgrades = [];
	{
		private _rawID = _x select 0;
		_ownedUpgrades pushBack (if (_rawID isEqualType "") then {_rawID} else {str _rawID});
	} foreach _ownedUpgradesQuery;

	private _upgrades = [];
	{
		private _upgradeID = _x;
		private _data = _y;
		private _upgradeName = _data select 0;
		private _upgradePrice = _data select 1;
		private _upgradeType = _data select 2;
		private _upgradeValue = _data select 3;
		private _hasUpgrade = _upgradeID in _ownedUpgrades;

		_upgrades pushBack [_upgradeID, _upgradeName, _upgradePrice, _upgradeType, _upgradeValue, _hasUpgrade];
	} forEach Config_FactoryV2_Upgrades;

	private _factoryStats = [_ownerType, _ownerID] call Server_FactoryV2_GetFactoryData;

	[_upgrades, _factoryStats] remoteExec ["A3PL_FactoryV2_ReceiveUpgrades", _player];
}] call compile_Server;

// Acheter un upgrade
// Params: [ownerType, ownerID, upgradeID, player] ou [cid, upgradeID, player] pour rétro-compatibilité
["Server_FactoryV2_BuyUpgrade", {
	private _ownerType = param [0, ""];
	private _ownerID = param [1, ""];
	private _upgradeID = param [2, 0];
	private _player = param [3, objNull];

	// Rétro-compatibilité: si premier param est un nombre, c'est un CID
	if (_ownerType isEqualType 0) then {
		private _cid = _ownerType;
		_upgradeID = _ownerID;
		_player = param [2, objNull];
		_ownerType = "company";
		_ownerID = _cid;
	};

	private _isCivilian = _ownerType isEqualTo "player";
	private _ownerIDStr = if (_ownerID isEqualType "") then {_ownerID} else {str _ownerID};

	diag_log format ["[FactoryV2] Server_FactoryV2_BuyUpgrade called - OwnerType: %1, OwnerID: %2, UpgradeID: %3 (type: %4), Player: %5", _ownerType, _ownerID, _upgradeID, typeName _upgradeID, _player];

	if (_ownerType isEqualTo "" || _ownerID isEqualTo "" || _ownerID isEqualTo 0 || (_upgradeID isEqualTo 0 && {_upgradeID isEqualType 0})) exitWith {
		diag_log format ["[FactoryV2] Invalid params - OwnerType: %1, OwnerID: %2, UpgradeID: %3", _ownerType, _ownerID, _upgradeID];
	};

	private _upgradeIDForDB = if (_upgradeID isEqualType 0) then {str _upgradeID} else {_upgradeID};
	private _upgradeIDForConfig = if (_upgradeID isEqualType "") then {_upgradeID} else {str _upgradeID};

	diag_log format ["[FactoryV2] UpgradeID for DB: %1, for Config: %2", _upgradeIDForDB, _upgradeIDForConfig];

	private _checkQuery = [format [
		"SELECT id FROM factoryv2_owned_upgrades WHERE owner_type = '%1' AND owner_id = '%2' AND upgrade_id = '%3'",
		_ownerType, _ownerIDStr, _upgradeIDForDB
	], 2] call Server_Database_Async;

	diag_log format ["[FactoryV2] Check query result: %1", _checkQuery];

	if (count _checkQuery > 0) exitWith {
		diag_log "[FactoryV2] Upgrade already owned";
		[("STR_Server_FactoryV2_UpgradeAlreadyOwned" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
	};

	private _upgradeData = Config_FactoryV2_Upgrades getOrDefault [_upgradeIDForConfig, []];
	diag_log format ["[FactoryV2] Upgrade data from config with key '%1': %2", _upgradeIDForConfig, _upgradeData];

	if (count _upgradeData == 0) exitWith {
		diag_log "[FactoryV2] Upgrade not found in config";
		[("STR_Server_FactoryV2_UpgradeNotFound" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
	};

	private _upgradeName = _upgradeData select 0;
	private _price = _upgradeData select 1;
	private _upgradeType = _upgradeData select 2;
	private _upgradeValue = _upgradeData select 3;

	diag_log format ["[FactoryV2] Upgrade details - Name: %1, Price: %2, Type: %3, Value: %4", _upgradeName, _price, _upgradeType, _upgradeValue];

	// Vérifier les fonds selon le type de propriétaire
	private _availableFunds = 0;
	if (_isCivilian) then {
		_availableFunds = _player getVariable ["player_bank", 0];
	} else {
		_availableFunds = [_ownerID, "bank"] call A3PL_Config_GetCompanyData;
		if (isNil "_availableFunds") then {_availableFunds = 0;};
	};

	diag_log format ["[FactoryV2] Available funds: %1", _availableFunds];

	if (_availableFunds < _price) exitWith {
		diag_log format ["[FactoryV2] Insufficient funds - Available: %1, Price: %2", _availableFunds, _price];
		[format[("STR_Server_FactoryV2_InsufficientFunds" call A3PL_Localize), _price - _availableFunds], Color_Red] remoteExec ["A3PL_Notification", _player];
	};

	// Débiter selon le type de propriétaire
	diag_log "[FactoryV2] Debiting funds";
	if (_isCivilian) then {
		_player setVariable ["player_bank", _availableFunds - _price, true];
	} else {
		[_ownerID, -_price, format[("STR_Server_FactoryV2_BankUpgradePurchase" call A3PL_Localize), _upgradeName]] call Server_Company_SetBank;
	};

	diag_log "[FactoryV2] Inserting upgrade into database";
	private _insertQuery = format [
		"INSERT INTO factoryv2_owned_upgrades (owner_type, owner_id, upgrade_id) VALUES ('%1', '%2', '%3')",
		_ownerType, _ownerIDStr, _upgradeIDForDB
	];
	[_insertQuery, 2] call Server_Database_Async;
	diag_log format ["[FactoryV2] Insert query: %1", _insertQuery];

	// Valeurs par défaut
	private _slots = 1;
	private _speed = 1.0;
	private _efficiency = 0;
	private _maxStorage = 1000;
	private _ownedUpgradesQuery = [];

	private _baseStatsQuery = [format [
		"SELECT slots, speed_multiplier, efficiency, max_storage FROM factoryv2_factories WHERE owner_type = '%1' AND owner_id = '%2'",
		_ownerType, _ownerIDStr
	], 2] call Server_Database_Async;

	if (count _baseStatsQuery > 0) then {
		private _currentSlots = _baseStatsQuery select 0;
		_slots = _currentSlots;

		_ownedUpgradesQuery = [format [
			"SELECT upgrade_id FROM factoryv2_owned_upgrades WHERE owner_type = '%1' AND owner_id = '%2'",
			_ownerType, _ownerIDStr
		], 2, true] call Server_Database_Async;
		if (isNil "_ownedUpgradesQuery") then {_ownedUpgradesQuery = [];};

		diag_log format ["[FactoryV2] Recalculating all upgrades - Owned count: %1", count _ownedUpgradesQuery];

		{
			private _ownedUpgradeID = if ((_x select 0) isEqualType "") then {_x select 0} else {str (_x select 0)};
			private _ownedUpgradeData = Config_FactoryV2_Upgrades getOrDefault [_ownedUpgradeID, []];

			if (count _ownedUpgradeData > 0) then {
				private _upType = _ownedUpgradeData select 2;
				private _upValue = _ownedUpgradeData select 3;

				switch (_upType) do {
					case "slots": { _slots = _slots + _upValue; };
					case "speed": { _speed = _speed + _upValue; };
					case "efficiency": { _efficiency = _efficiency + _upValue; };
					case "storage": { _maxStorage = _maxStorage + _upValue; };
				};
			};
		} forEach _ownedUpgradesQuery;

		private _updateQuery = format [
			"UPDATE factoryv2_factories SET slots = '%1', speed_multiplier = '%2', efficiency = '%3', max_storage = '%4' WHERE owner_type = '%5' AND owner_id = '%6'",
			_slots, _speed, _efficiency, _maxStorage, _ownerType, _ownerIDStr
		];
		diag_log format ["[FactoryV2] Executing UPDATE query: %1", _updateQuery];
		diag_log format ["[FactoryV2] Updated stats - Slots: %1, Speed: %2, Efficiency: %3, Storage: %4", _slots, _speed, _efficiency, _maxStorage];
		[_updateQuery, 1] call Server_Database_Async;
	};

	diag_log "[FactoryV2] Upgrade purchase completed successfully";
	[format[("STR_Server_FactoryV2_UpgradePurchased" call A3PL_Localize), _price], Color_Green] remoteExec ["A3PL_Notification", _player];

	// Construire et envoyer directement les données mises à jour (évite les problèmes de timing DB)
	diag_log "[FactoryV2] Building and sending updated upgrades data";

	// Collecter les IDs des upgrades possédés (incluant celui qu'on vient d'acheter)
	private _ownedUpgradeIDs = [_upgradeIDForConfig];
	{
		private _ownedID = if ((_x select 0) isEqualType "") then {_x select 0} else {str (_x select 0)};
		if !(_ownedID in _ownedUpgradeIDs) then {
			_ownedUpgradeIDs pushBack _ownedID;
		};
	} forEach _ownedUpgradesQuery;

	// Construire la liste des upgrades avec leur statut
	private _upgrades = [];
	{
		private _upID = _x;
		private _upData = _y;
		private _upName = _upData select 0;
		private _upPrice = _upData select 1;
		private _upType = _upData select 2;
		private _upValue = _upData select 3;
		private _hasUpgrade = _upID in _ownedUpgradeIDs;

		_upgrades pushBack [_upID, _upName, _upPrice, _upType, _upValue, _hasUpgrade];
	} forEach Config_FactoryV2_Upgrades;

	// Envoyer les stats mises à jour
	private _factoryStats = [_slots, _speed, _efficiency, _maxStorage];

	[_upgrades, _factoryStats] remoteExec ["A3PL_FactoryV2_ReceiveUpgrades", _player];
}] call compile_Server;

// Obtenir les crafts partageables (uniquement pour les entreprises)
["Server_FactoryV2_GetShareableCrafts", {
	private _cid = param [0, 0];
	private _player = param [1, objNull];

	if (_cid isEqualTo 0) exitWith {};

	private _cidStr = str _cid;

	private _craftsQuery = [format [
		"SELECT craft_id FROM factoryv2_owned_crafts WHERE owner_type = 'company' AND owner_id = '%1'",
		_cidStr
	], 2, true] call Server_Database_Async;
	if (isNil "_craftsQuery") then {_craftsQuery = [];};

	private _crafts = [];
	{
		if !(_x isEqualType []) then {continue;};
		private _craftID = _x select 0;
		private _craftIDStr = if (_craftID isEqualType "") then {_craftID} else {str _craftID};

		private _craftData = Config_FactoryV2_Crafts getOrDefault [_craftIDStr, []];
		if (count _craftData > 0) then {
			private _craftName = _craftData select 0;
			private _classname = if (count _craftData > 5) then {_craftData select 5} else {""};
			private _classType = if (count _craftData > 6) then {_craftData select 6} else {"item"};
			_crafts pushBack [_craftID, _craftName, _classname, _classType];
		};
	} foreach _craftsQuery;

	[_crafts] remoteExec ["A3PL_FactoryV2_ReceiveShareableCrafts", _player];
}] call compile_Server;

// Rechercher une cible pour le partage
["Server_FactoryV2_SearchShareTarget", {
	private _ownerType = param [0, ""];
	private _ownerID = param [1, ""];
	private _searchText = param [2, ""];
	private _player = param [3, objNull];

	if (_ownerType isEqualTo "" || _ownerID isEqualTo "" || _searchText isEqualTo "") exitWith {};
	
	private _results = [];
	
	private _playerQuery = [format [
		"SELECT charid, name FROM players WHERE name LIKE '%%%1%%' LIMIT 10",
		_searchText
	], 2, true] call Server_Database_Async;
	
	{
		_results pushBack ["player", _x select 1, _x select 0];
	} foreach _playerQuery;
	
	private _companyQuery = [format [
		"SELECT id, name FROM companies WHERE name LIKE '%%%1%%' AND disabled = '0' LIMIT 10",
		_searchText
	], 2, true] call Server_Database_Async;
	
	{
		_results pushBack ["company", _x select 1, _x select 0];
	} foreach _companyQuery;
	
	[_results] remoteExec ["A3PL_FactoryV2_ReceiveSearchResults", _player];
}] call compile_Server;

// Obtenir les partages existants pour un craft
["Server_FactoryV2_GetCraftShares", {
	params [["_ownerType", ""], ["_ownerID", ""], ["_craftID", 0], ["_player", objNull]];

	if (_ownerType isEqualTo "" || _ownerID isEqualTo "" || _craftID isEqualTo 0) exitWith {};

	private _ownerIDStr = if (_ownerID isEqualType "") then {_ownerID} else {str _ownerID};

	private _sharesQuery = [format [
		"SELECT s.id, s.target_type, s.target_id, s.share_type, s.price, s.status FROM factoryv2_shares s WHERE s.owner_type = '%1' AND s.owner_id = '%2' AND s.craft_id = '%3' AND s.status IN ('active', 'pending')",
		_ownerType, _ownerIDStr, _craftID
	], 2, true] call Server_Database_Async;
	if (isNil "_sharesQuery") then {_sharesQuery = [];};

	private _shares = [];
	{
		private _shareID = _x select 0;
		private _targetType = _x select 1;
		private _targetID = _x select 2;
		private _shareType = _x select 3;
		private _price = _x select 4;
		private _status = _x select 5;

		private _targetName = "Inconnu";
		if (_targetType isEqualTo "player") then {
			private _playerQuery = [format ["SELECT name FROM players WHERE charid = '%1'", _targetID], 2, true] call Server_Database_Async;
			if (!isNil "_playerQuery" && {count _playerQuery > 0}) then {
				_targetName = (_playerQuery select 0) select 0;
			};
		} else {
			private _companyQuery = [format ["SELECT name FROM companies WHERE id = '%1'", _targetID], 2, true] call Server_Database_Async;
			if (!isNil "_companyQuery" && {count _companyQuery > 0}) then {
				_targetName = (_companyQuery select 0) select 0;
			};
		};

		_shares pushBack [_shareID, _targetType, _targetName, _targetID, _shareType, _price, _status];
	} foreach _sharesQuery;

	[_shares] remoteExec ["A3PL_FactoryV2_ReceiveCraftShares", _player];
}] call compile_Server;

// Récupérer les infos d'un partage existant pour une cible spécifique
["Server_FactoryV2_GetShareInfo", {
	params [["_ownerType", ""], ["_ownerID", ""], ["_craftID", 0], ["_targetType", ""], ["_targetID", ""], ["_player", objNull]];

	if (_ownerType isEqualTo "" || _ownerID isEqualTo "" || _craftID isEqualTo 0 || _targetType isEqualTo "" || _targetID isEqualTo "") exitWith {
		[false, "", 0] remoteExec ["A3PL_FactoryV2_ReceiveShareInfo", _player];
	};

	private _ownerIDStr = if (_ownerID isEqualType "") then {_ownerID} else {str _ownerID};
	private _targetIDStr = if (_targetID isEqualType "") then {_targetID} else {str _targetID};

	private _shareQuery = [format [
		"SELECT share_type, price FROM factoryv2_shares WHERE owner_type = '%1' AND owner_id = '%2' AND craft_id = '%3' AND target_type = '%4' AND target_id = '%5' AND status IN ('active', 'pending')",
		_ownerType, _ownerIDStr, _craftID, _targetType, _targetIDStr
	], 2] call Server_Database_Async;

	if (isNil "_shareQuery" || {count _shareQuery < 2}) then {
		[false, "", 0] remoteExec ["A3PL_FactoryV2_ReceiveShareInfo", _player];
	} else {
		private _shareType = _shareQuery select 0;
		private _price = _shareQuery select 1;
		[true, _shareType, _price] remoteExec ["A3PL_FactoryV2_ReceiveShareInfo", _player];
	};
}] call compile_Server;

// Partager un craft
["Server_FactoryV2_ShareCraft", {
	params [["_ownerType", ""], ["_ownerID", ""], ["_craftID", 0], ["_targetType", ""], ["_targetID", ""], ["_shareType", "craft"], ["_price", 0], ["_player", objNull]];

	diag_log format ["[FactoryV2] ShareCraft called - ownerType=%1, ownerID=%2, craftID=%3, targetType=%4, targetID=%5, shareType=%6, price=%7", _ownerType, _ownerID, _craftID, _targetType, _targetID, _shareType, _price];

	private _targetIDStr = if (_targetID isEqualType "") then {_targetID} else {str _targetID};
	private _ownerIDStr = if (_ownerID isEqualType "") then {_ownerID} else {str _ownerID};

	diag_log format ["[FactoryV2] ShareCraft - targetIDStr=%1, ownerIDStr=%2", _targetIDStr, _ownerIDStr];

	if (_ownerType isEqualTo "" || _ownerIDStr isEqualTo "" || _craftID isEqualTo 0 || _targetType isEqualTo "" || _targetIDStr isEqualTo "" || _targetIDStr isEqualTo "0" || _price <= 0) exitWith {
		diag_log format ["[FactoryV2] ShareCraft validation failed - ownerType=%1, ownerID=%2, craftID=%3, targetType=%4, targetID=%5, price=%6", _ownerType, _ownerIDStr, _craftID, _targetType, _targetIDStr, _price];
	};

	diag_log "[FactoryV2] ShareCraft - Validation passed";

	if (_ownerType isEqualTo "company" && _targetType isEqualTo "company" && _ownerIDStr isEqualTo _targetIDStr) exitWith {
		diag_log "[FactoryV2] ShareCraft - Cannot share to own company";
		[("STR_Server_FactoryV2_CannotShareToOwnCompany" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
	};

	private _checkQuery = [format [
		"SELECT id FROM factoryv2_owned_crafts WHERE owner_type = '%1' AND owner_id = '%2' AND craft_id = '%3'",
		_ownerType, _ownerIDStr, _craftID
	], 2] call Server_Database_Async;

	diag_log format ["[FactoryV2] ShareCraft - checkQuery result: %1", _checkQuery];

	if (isNil "_checkQuery" || {count _checkQuery == 0}) exitWith {
		diag_log "[FactoryV2] ShareCraft - Owner does not have this craft";
		[("STR_Server_FactoryV2_NoCraftAccess" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
	};

	private _existingShare = [format [
		"SELECT id FROM factoryv2_shares WHERE owner_type = '%1' AND owner_id = '%2' AND craft_id = '%3' AND target_type = '%4' AND target_id = '%5' AND status IN ('active', 'pending')",
		_ownerType, _ownerIDStr, _craftID, _targetType, _targetIDStr
	], 2] call Server_Database_Async;

	diag_log format ["[FactoryV2] ShareCraft - existingShare result: %1", _existingShare];

	if (!isNil "_existingShare" && {count _existingShare > 0}) exitWith {
		diag_log "[FactoryV2] ShareCraft - Share already exists";
		[("STR_Server_FactoryV2_ShareAlreadyExists" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
	};

	private _targetPlayer = objNull;
	if (_targetType isEqualTo "player") then {
		diag_log format ["[FactoryV2] ShareCraft - Looking for player with character_id=%1 among %2 players", _targetIDStr, count allPlayers];
		{
			private _charID = _x getVariable ["character_id", ""];
			if (_charID isEqualTo _targetIDStr) exitWith {
				_targetPlayer = _x;
				diag_log format ["[FactoryV2] ShareCraft - Found target player: %1", name _x];
			};
		} forEach allPlayers;
	} else {
		private _bossQuery = [format ["SELECT boss FROM companies WHERE id = '%1'", _targetIDStr], 2] call Server_Database_Async;
		diag_log format ["[FactoryV2] ShareCraft - bossQuery result: %1", _bossQuery];
		if (!isNil "_bossQuery" && {count _bossQuery > 0}) then {
			private _bossCharID = _bossQuery select 0;
			private _bossCharIDStr = if (_bossCharID isEqualType "") then {_bossCharID} else {str _bossCharID};
			diag_log format ["[FactoryV2] ShareCraft - Looking for boss with character_id=%1", _bossCharIDStr];
			{
				if ((_x getVariable ["character_id", ""]) isEqualTo _bossCharIDStr) exitWith {
					_targetPlayer = _x;
					diag_log format ["[FactoryV2] ShareCraft - Found boss player: %1", name _x];
				};
			} forEach allPlayers;
		};
	};

	if (isNull _targetPlayer) exitWith {
		diag_log "[FactoryV2] ShareCraft - Target not online, share refused";
		private _errorMsg = if (_targetType isEqualTo "player") then {
			"STR_Server_FactoryV2_TargetPlayerNotOnline" call A3PL_Localize
		} else {
			"STR_Server_FactoryV2_TargetBossNotOnline" call A3PL_Localize
		};
		[_errorMsg, Color_Red] remoteExec ["A3PL_Notification", _player];
	};

	private _craftName = "Craft";
	private _craftData = Config_FactoryV2_Crafts getOrDefault [str _craftID, []];
	if (count _craftData > 0) then {
		_craftName = _craftData select 0;
	};
	diag_log format ["[FactoryV2] ShareCraft - craftName=%1", _craftName];

	private _ownerName = "Inconnu";
	if (_ownerType isEqualTo "company") then {
		private _companyQuery = [format ["SELECT name FROM companies WHERE id = '%1'", _ownerIDStr], 2] call Server_Database_Async;
		diag_log format ["[FactoryV2] ShareCraft - companyQuery result: %1", _companyQuery];
		if (!isNil "_companyQuery" && {count _companyQuery > 0}) then {
			_ownerName = _companyQuery select 0;
		};
	} else {
		private _playerQuery = [format ["SELECT name FROM players WHERE charid = '%1'", _ownerIDStr], 2] call Server_Database_Async;
		diag_log format ["[FactoryV2] ShareCraft - playerQuery result: %1", _playerQuery];
		if (!isNil "_playerQuery" && {count _playerQuery > 0}) then {
			_ownerName = _playerQuery select 0;
		};
	};
	diag_log format ["[FactoryV2] ShareCraft - ownerName=%1", _ownerName];

	private _insertQuery = format [
		"INSERT INTO factoryv2_shares (owner_type, owner_id, craft_id, target_type, target_id, share_type, price, status, created_at) VALUES ('%1', '%2', '%3', '%4', '%5', '%6', '%7', 'pending', NOW())",
		_ownerType, _ownerIDStr, _craftID, _targetType, _targetIDStr, _shareType, _price
	];
	diag_log format ["[FactoryV2] ShareCraft - Running INSERT: %1", _insertQuery];
	[_insertQuery, 1] call Server_Database_Async;

	uiSleep 0.1;

	private _shareIDQuery = [format [
		"SELECT id FROM factoryv2_shares WHERE owner_type = '%1' AND owner_id = '%2' AND craft_id = '%3' AND target_type = '%4' AND target_id = '%5' AND status = 'pending' ORDER BY id DESC LIMIT 1",
		_ownerType, _ownerIDStr, _craftID, _targetType, _targetIDStr
	], 2] call Server_Database_Async;

	diag_log format ["[FactoryV2] ShareCraft - shareIDQuery result: %1", _shareIDQuery];

	if (isNil "_shareIDQuery" || {count _shareIDQuery == 0}) exitWith {
		diag_log format ["[FactoryV2] ShareCraft ERROR - No share found after insert"];
		[("STR_Server_FactoryV2_Error" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
	};

	private _shareID = _shareIDQuery select 0;
	diag_log format ["[FactoryV2] ShareCraft - Share created with ID: %1", _shareID];

	diag_log format ["[FactoryV2] ShareCraft - Sending share request to player: %1", name _targetPlayer];
	[_shareID, _ownerName, _craftID, _shareType, _price] remoteExec ["A3PL_FactoryV2_ReceiveShareRequest", _targetPlayer];

	diag_log "[FactoryV2] ShareCraft - Sending success notification";
	[("STR_Server_FactoryV2_ShareRequestSent" call A3PL_Localize), Color_Green] remoteExec ["A3PL_Notification", _player];

	[_ownerType, _ownerID, _craftID, _player] call Server_FactoryV2_GetCraftShares;
}] call compile_Server;

// Répondre à une demande de partage
["Server_FactoryV2_RespondToShare", {
	params [["_shareID", 0], ["_accepted", false], ["_player", objNull]];

	if (_shareID isEqualTo 0) exitWith {};

	private _shareQuery = [format [
		"SELECT owner_type, owner_id, craft_id, target_type, target_id FROM factoryv2_shares WHERE id = '%1' AND status = 'pending'",
		_shareID
	], 2] call Server_Database_Async;

	if (isNil "_shareQuery" || {count _shareQuery < 5}) exitWith {
		[("STR_Server_FactoryV2_ShareNotFound" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
	};

	private _ownerType = _shareQuery select 0;
	private _ownerID = _shareQuery select 1;
	private _targetType = _shareQuery select 3;
	private _targetID = _shareQuery select 4;

	private _ownerIDStr = if (_ownerID isEqualType "") then {_ownerID} else {str _ownerID};
	private _targetIDStr = if (_targetID isEqualType "") then {_targetID} else {str _targetID};

	private _playerCharID = _player getVariable ["character_id", ""];
	private _canRespond = false;

	if (_targetType isEqualTo "player") then {
		_canRespond = _playerCharID isEqualTo _targetIDStr;
	} else {
		private _bossQuery = [format ["SELECT boss FROM companies WHERE id = '%1'", _targetIDStr], 2] call Server_Database_Async;
		if (!isNil "_bossQuery" && {count _bossQuery > 0}) then {
			private _bossCharID = _bossQuery select 0;
			private _bossCharIDStr = if (_bossCharID isEqualType "") then {_bossCharID} else {str _bossCharID};
			_canRespond = _playerCharID isEqualTo _bossCharIDStr;
		};
	};

	if (!_canRespond) exitWith {
		[("STR_Server_FactoryV2_NotAuthorized" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
	};

	if (_accepted) then {
		private _updateQuery = format ["UPDATE factoryv2_shares SET status = 'active' WHERE id = '%1'", _shareID];
		[_updateQuery, 1] call Server_Database_Async;
		[("STR_Server_FactoryV2_ShareAccepted" call A3PL_Localize), Color_Green] remoteExec ["A3PL_Notification", _player];

		private _ownerPlayer = objNull;
		if (_ownerType isEqualTo "player") then {
			{
				if ((_x getVariable ["character_id", ""]) isEqualTo _ownerIDStr) exitWith {
					_ownerPlayer = _x;
				};
			} forEach allPlayers;
		} else {
			private _bossQuery = [format ["SELECT boss FROM companies WHERE id = '%1'", _ownerIDStr], 2] call Server_Database_Async;
			if (!isNil "_bossQuery" && {count _bossQuery > 0}) then {
				private _bossCharID = _bossQuery select 0;
				private _bossCharIDStr = if (_bossCharID isEqualType "") then {_bossCharID} else {str _bossCharID};
				{
					if ((_x getVariable ["character_id", ""]) isEqualTo _bossCharIDStr) exitWith {
						_ownerPlayer = _x;
					};
				} forEach allPlayers;
			};
		};
		if (!isNull _ownerPlayer) then {
			[("STR_Server_FactoryV2_YourShareWasAccepted" call A3PL_Localize), Color_Green] remoteExec ["A3PL_Notification", _ownerPlayer];
		};
	} else {
		private _updateQuery = format ["UPDATE factoryv2_shares SET status = 'rejected' WHERE id = '%1'", _shareID];
		[_updateQuery, 1] call Server_Database_Async;
		[("STR_Server_FactoryV2_ShareRejected" call A3PL_Localize), Color_Yellow] remoteExec ["A3PL_Notification", _player];

		private _ownerPlayer = objNull;
		if (_ownerType isEqualTo "player") then {
			{
				if ((_x getVariable ["character_id", ""]) isEqualTo _ownerIDStr) exitWith {
					_ownerPlayer = _x;
				};
			} forEach allPlayers;
		} else {
			private _bossQuery = [format ["SELECT boss FROM companies WHERE id = '%1'", _ownerIDStr], 2] call Server_Database_Async;
			if (!isNil "_bossQuery" && {count _bossQuery > 0}) then {
				private _bossCharID = _bossQuery select 0;
				private _bossCharIDStr = if (_bossCharID isEqualType "") then {_bossCharID} else {str _bossCharID};
				{
					if ((_x getVariable ["character_id", ""]) isEqualTo _bossCharIDStr) exitWith {
						_ownerPlayer = _x;
					};
				} forEach allPlayers;
			};
		};
		if (!isNull _ownerPlayer) then {
			[("STR_Server_FactoryV2_YourShareWasRejected" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _ownerPlayer];
		};
	};
}] call compile_Server;

// Retirer un partage
["Server_FactoryV2_RemoveShare", {
	params [["_ownerType", ""], ["_ownerID", ""], ["_shareID", 0], ["_craftID", 0], ["_player", objNull]];

	if (_ownerType isEqualTo "" || _ownerID isEqualTo "" || _shareID isEqualTo 0) exitWith {};

	private _ownerIDStr = if (_ownerID isEqualType "") then {_ownerID} else {str _ownerID};

	private _checkQuery = [format [
		"SELECT id, craft_id FROM factoryv2_shares WHERE id = '%1' AND owner_type = '%2' AND owner_id = '%3' AND status IN ('active', 'pending')",
		_shareID, _ownerType, _ownerIDStr
	], 2] call Server_Database_Async;

	if (isNil "_checkQuery" || {count _checkQuery < 2}) exitWith {
		[("STR_Server_FactoryV2_ShareNotFound" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
	};

	private _craftIDFromDB = _checkQuery select 1;
	if (_craftIDFromDB isEqualType "") then {_craftIDFromDB = parseNumber _craftIDFromDB;};

	private _deleteQuery = format [
		"UPDATE factoryv2_shares SET status = 'removed' WHERE id = '%1'",
		_shareID
	];
	[_deleteQuery, 1] call Server_Database_Async;

	[("STR_Server_FactoryV2_ShareRemoved" call A3PL_Localize), Color_Green] remoteExec ["A3PL_Notification", _player];

	private _finalCraftID = if (_craftID > 0) then {_craftID} else {_craftIDFromDB};
	if (_finalCraftID > 0) then {
		[_ownerType, _ownerID, _finalCraftID, _player] call Server_FactoryV2_GetCraftShares;
	};
}] call compile_Server;

// Traiter les abonnements (exécuté à 6h00 UTC)
["Server_FactoryV2_ProcessSubscriptions", {
	diag_log "[FactoryV2] ProcessSubscriptions - Starting daily subscription processing at 6:00 UTC";

	private _subscriptionsQuery = ["SELECT id, owner_type, owner_id, target_type, target_id, price, craft_id FROM factoryv2_shares WHERE share_type = 'subscription' AND status = 'active'", 2, true] call Server_Database_Async;
	if (isNil "_subscriptionsQuery") then {_subscriptionsQuery = [];};

	diag_log format ["[FactoryV2] ProcessSubscriptions - Found %1 active subscriptions", count _subscriptionsQuery];

	{
		private _shareID = _x select 0;
		private _ownerType = _x select 1;
		private _ownerID = _x select 2;
		private _targetType = _x select 3;
		private _targetID = _x select 4;
		private _price = _x select 5;
		private _craftID = _x select 6;
		if (_price isEqualType "") then {_price = parseNumber _price;};
		if (_craftID isEqualType "") then {_craftID = parseNumber _craftID;};
		if (_ownerID isEqualType "") then {} else {_ownerID = str _ownerID;};
		if (_targetID isEqualType "") then {} else {_targetID = str _targetID;};

		diag_log format ["[FactoryV2] Processing subscription %1 - Owner: %2/%3, Target: %4/%5, Price: %6", _shareID, _ownerType, _ownerID, _targetType, _targetID, _price];

		private _paymentSuccess = false;

		if (_targetType isEqualTo "player") then {
			private _onlinePlayer = objNull;
			{
				if ((_x getVariable ["character_id", ""]) isEqualTo _targetID) exitWith {
					_onlinePlayer = _x;
				};
			} foreach allPlayers;

			if (!isNull _onlinePlayer) then {
				private _playerBank = _onlinePlayer getVariable ["player_bank", 0];

				if (_playerBank >= _price) then {
					private _newBank = _playerBank - _price;
					_onlinePlayer setVariable ["player_bank", _newBank, true];
					[format[("STR_Server_FactoryV2_SubscriptionPaid" call A3PL_Localize), _price], Color_Yellow] remoteExec ["A3PL_Notification", _onlinePlayer];
					_paymentSuccess = true;
					diag_log format ["[FactoryV2] Subscription %1 paid (online) - Player %2 debited $%3", _shareID, _targetID, _price];
				} else {
					[("STR_Server_FactoryV2_SubscriptionRevoked" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _onlinePlayer];
					diag_log format ["[FactoryV2] Subscription %1 revoked - Online player %2 insufficient funds ($%3 < $%4)", _shareID, _targetID, _playerBank, _price];
				};
			} else {
				private _playerQuery = [format ["SELECT charid, bank FROM players WHERE charid = '%1'", _targetID], 2, true] call Server_Database_Async;

				if (!isNil "_playerQuery" && {count _playerQuery > 0}) then {
					private _playerBank = _playerQuery select 0 select 1;
					if (_playerBank isEqualType "") then {_playerBank = parseNumber _playerBank;};

					if (_playerBank >= _price) then {
						private _newBank = _playerBank - _price;
						[format ["UPDATE players SET bank='%1' WHERE charid='%2'", _newBank, _targetID], 1] call Server_Database_Async;
						_paymentSuccess = true;
						diag_log format ["[FactoryV2] Subscription %1 paid (offline) - Player %2 debited $%3", _shareID, _targetID, _price];
					} else {
						diag_log format ["[FactoryV2] Subscription %1 revoked - Offline player %2 insufficient funds ($%3 < $%4)", _shareID, _targetID, _playerBank, _price];
					};
				};
			};

			if (_paymentSuccess) then {
				if (_ownerType isEqualTo "company") then {
					[parseNumber _ownerID, _price, format[("STR_Server_FactoryV2_BankSubscription" call A3PL_Localize), _shareID]] call Server_Company_SetBank;
				} else {
					private _ownerOnline = objNull;
					{
						if ((_x getVariable ["character_id", ""]) isEqualTo _ownerID) exitWith {
							_ownerOnline = _x;
						};
					} foreach allPlayers;

					if (!isNull _ownerOnline) then {
						private _ownerBank = _ownerOnline getVariable ["player_bank", 0];
						_ownerOnline setVariable ["player_bank", _ownerBank + _price, true];
					} else {
						[format ["UPDATE players SET bank = bank + %1 WHERE charid = '%2'", _price, _ownerID], 1] call Server_Database_Async;
					};
				};
			};
		} else {
			private _companyBank = [parseNumber _targetID, "bank"] call A3PL_Config_GetCompanyData;
			if (isNil "_companyBank") then {_companyBank = 0;};
			if (_companyBank isEqualType "") then {_companyBank = parseNumber _companyBank;};

			if (_companyBank >= _price) then {
				[parseNumber _targetID, -_price, format[("STR_Server_FactoryV2_BankSubscription" call A3PL_Localize), _shareID]] call Server_Company_SetBank;
				_paymentSuccess = true;

				if (_ownerType isEqualTo "company") then {
					[parseNumber _ownerID, _price, format[("STR_Server_FactoryV2_BankSubscription" call A3PL_Localize), _shareID]] call Server_Company_SetBank;
				} else {
					private _ownerOnline = objNull;
					{
						if ((_x getVariable ["character_id", ""]) isEqualTo _ownerID) exitWith {
							_ownerOnline = _x;
						};
					} foreach allPlayers;

					if (!isNull _ownerOnline) then {
						private _ownerBank = _ownerOnline getVariable ["player_bank", 0];
						_ownerOnline setVariable ["player_bank", _ownerBank + _price, true];
					} else {
						[format ["UPDATE players SET bank = bank + %1 WHERE charid = '%2'", _price, _ownerID], 1] call Server_Database_Async;
					};
				};

				diag_log format ["[FactoryV2] Subscription %1 paid - Company %2 debited $%3 to %4/%5", _shareID, _targetID, _price, _ownerType, _ownerID];
			} else {
				diag_log format ["[FactoryV2] Subscription %1 revoked - Company %2 insufficient funds ($%3 < $%4)", _shareID, _targetID, _companyBank, _price];
			};
		};

		if (!_paymentSuccess) then {
			[_ownerType, _ownerID, _shareID, _craftID, objNull] call Server_FactoryV2_RemoveShare;
			diag_log format ["[FactoryV2] Share %1 revoked due to insufficient funds", _shareID];
		};
	} foreach _subscriptionsQuery;

	diag_log "[FactoryV2] ProcessSubscriptions - Completed";
}] call compile_Server;

// Acheter un slot supplémentaire
// Params: [ownerType, ownerID, player] ou [cid, player] pour rétro-compatibilité
["Server_FactoryV2_BuySlot", {
	private _ownerType = param [0, ""];
	private _ownerID = param [1, ""];
	private _player = param [2, objNull];

	if (_ownerType isEqualType 0) then {
		private _cid = _ownerType;
		_player = _ownerID;
		_ownerType = "company";
		_ownerID = _cid;
	};

	if (_ownerType isEqualTo "" || _ownerID isEqualTo "" || _ownerID isEqualTo 0) exitWith {};

	private _isCivilian = _ownerType isEqualTo "player";
	private _ownerIDStr = if (_ownerID isEqualType "") then {_ownerID} else {str _ownerID};

	private _slotPrice = 50000;
	private _maxSlots = 8;

	private _factoryQuery = [format [
		"SELECT slots FROM factoryv2_factories WHERE owner_type = '%1' AND owner_id = '%2'",
		_ownerType, _ownerIDStr
	], 2] call Server_Database_Async;

	if (count _factoryQuery == 0) exitWith {
		[("STR_Server_FactoryV2_NoFactory" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
	};

	private _currentSlots = _factoryQuery select 0;

	if (_currentSlots >= _maxSlots) exitWith {
		[("STR_Server_FactoryV2_MaxSlotsReached" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
	};

	private _availableFunds = 0;
	if (_isCivilian) then {
		_availableFunds = _player getVariable ["player_bank", 0];
	} else {
		_availableFunds = [_ownerID, "bank"] call A3PL_Config_GetCompanyData;
		if (isNil "_availableFunds") then {_availableFunds = 0;};
	};

	if (_availableFunds < _slotPrice) exitWith {
		[format[("STR_Server_FactoryV2_InsufficientFunds" call A3PL_Localize), _slotPrice - _availableFunds], Color_Red] remoteExec ["A3PL_Notification", _player];
	};

	if (_isCivilian) then {
		_player setVariable ["player_bank", _availableFunds - _slotPrice, true];
	} else {
		[_ownerID, -_slotPrice, format[("STR_Server_FactoryV2_BankSlotPurchase" call A3PL_Localize), _currentSlots + 1]] call Server_Company_SetBank;
	};

	private _newSlots = _currentSlots + 1;
	private _updateQuery = format [
		"UPDATE factoryv2_factories SET slots = '%1' WHERE owner_type = '%2' AND owner_id = '%3'",
		_newSlots, _ownerType, _ownerIDStr
	];
	[_updateQuery, 1] call Server_Database_Async;

	[format[("STR_Server_FactoryV2_SlotPurchased" call A3PL_Localize), _newSlots], Color_Green] remoteExec ["A3PL_Notification", _player];

	// Construire et envoyer directement les données mises à jour (évite les problèmes de timing DB)
	// Récupérer les upgrades possédés
	private _ownedUpgradesQuery = [format [
		"SELECT upgrade_id FROM factoryv2_owned_upgrades WHERE owner_type = '%1' AND owner_id = '%2'",
		_ownerType, _ownerIDStr
	], 2, true] call Server_Database_Async;
	if (isNil "_ownedUpgradesQuery") then {_ownedUpgradesQuery = [];};

	private _ownedUpgradeIDs = [];
	{
		private _ownedID = if ((_x select 0) isEqualType "") then {_x select 0} else {str (_x select 0)};
		_ownedUpgradeIDs pushBack _ownedID;
	} forEach _ownedUpgradesQuery;

	// Calculer les stats avec les upgrades
	private _speed = 1.0;
	private _efficiency = 0;
	private _maxStorage = 1000;

	{
		private _ownedUpgradeData = Config_FactoryV2_Upgrades getOrDefault [_x, []];
		if (count _ownedUpgradeData > 0) then {
			private _upgradeType = _ownedUpgradeData select 2;
			private _upgradeValue = _ownedUpgradeData select 3;
			switch (_upgradeType) do {
				case "speed": { _speed = _speed + _upgradeValue; };
				case "efficiency": { _efficiency = _efficiency + _upgradeValue; };
				case "storage": { _maxStorage = _maxStorage + _upgradeValue; };
			};
		};
	} forEach _ownedUpgradeIDs;

	// Construire la liste des upgrades
	private _upgrades = [];
	{
		private _upID = _x;
		private _upData = _y;
		private _upName = _upData select 0;
		private _upPrice = _upData select 1;
		private _upType = _upData select 2;
		private _upValue = _upData select 3;
		private _hasUpgrade = _upID in _ownedUpgradeIDs;

		_upgrades pushBack [_upID, _upName, _upPrice, _upType, _upValue, _hasUpgrade];
	} forEach Config_FactoryV2_Upgrades;

	// Envoyer avec le nouveau nombre de slots
	private _factoryStats = [_newSlots, _speed, _efficiency, _maxStorage];

	[_upgrades, _factoryStats] remoteExec ["A3PL_FactoryV2_ReceiveUpgrades", _player];
}] call compile_Server;