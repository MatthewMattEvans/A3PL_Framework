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
	A3PL Web API Integration
	Permet la communication bidirectionnelle entre PHP et SQF via A3PL_Core.dll

	=== FONCTIONS DISPONIBLES ===

	Sans arguments:
	- Server_Core_GetStatus           : Statut du serveur (players, uptime, ready)
	- Server_Core_GetPlayers          : Liste des joueurs connectes
	- Server_Core_ReloadPersistentVars: Recharge les variables persistantes
	- Vehicle_GetAll                  : Liste de tous les vehicules
	- Company_ReloadBills             : Recharge les factures pour tous les joueurs

	Avec arguments (format pipe):
	- Server_Log_New                  : uid|character_id|type|message
	- Execute_Function                : function_name|arg1|arg2|arg3|...
	- Player_SendEmailNotification    : identifier|sender|subject|preview
	- Player_GetInfo                  : identifier (uid ou character_id)
	- Player_SendNotification         : identifier|message
	- Player_SendNotificationAll      : message
	- Player_SetBank                  : character_id|amount
	- Player_AddBank                  : character_id|amount
	- Player_RemoveBank               : character_id|amount
	- Player_ReloadAssets             : character_id|asset_type (vehicle/house)
	- Company_Create                  : uid|character_id|company_name|description
	- Company_SendBill                : company_id|amount|description|target_character_id
	- Company_SetBank                 : company_id|amount|description (description optionnel)
	- Company_AddBank                 : company_id|amount|description (description optionnel)
	- Company_RemoveBank              : company_id|amount|description (description optionnel)
	- Twitter_SendTweet               : character_id|author_name|message
	- Player_AddPerkdays              : uid|days (ajoute des jours premium, sync si en ligne)
	- Player_AddHotbarSlots           : character_id|slots (ajoute des slots hotbar, sync si en ligne)
	- Player_AddInventoryItem         : character_id|classname|amount (inventaire virtuel, amount negatif pour retirer)
	- Player_AddArmaItem              : character_id|classname|amount|action (inventaire vanilla, action = add/remove)

	Display Names (via config inheritance):
	- GetDisplayName                  : classname|type -> displayName d'un item
	- GetDisplayNames                 : classname1,classname2,...|type -> displayNames multiples (type principal, auto-fallback)
	  Types supportes: item, weapon, magazine, uniform, vest, headgear, backpack, goggles, aitem

	=== FORMAT DES ARGUMENTS ===
	Les arguments sont separes par des pipes "|"
	Exemple: Server_Log_New avec Arguments: "uid123|charABC|TEST|Mon message"
	Exemple: Company_AddBank avec Arguments: "5|50000|Vente de produits"
*/

// ============================================================================
// INITIALIZATION
// ============================================================================

["Server_API_Init", {
	if (!isDedicated) exitWith {};

	private _result = "A3PL_Core" callExtension "A3PL_API_Start";

	if (_result == "STARTED") then {
		diag_log "[A3PL API] Web API server started successfully on port 5080";
		A3PL_API_Initialized = true;
	} else {
		diag_log format ["[A3PL API] ERROR: Failed to start API server - %1", _result];
		A3PL_API_Initialized = false;
	};

	addMissionEventHandler ["ExtensionCallback", {
		params ["_name", "_function", "_data"];

		switch (_name) do {
			case "A3PL_API_CallBack_NewRequest": {
				[_function, _data] spawn Server_API_HandleRequest;
			};
			case "A3PL_API_CallBack_POST": {
				[_function, _data] call Server_API_HandlePostResponse;
			};
			case "A3PL_API_CallBack_GET": {
				[_function, _data] call Server_API_HandleGetResponse;
			};
			case "A3PL_API_CallBack_Error": {
				diag_log format ["[A3PL API] ERROR: Request %1 failed", _function];
			};
		};
	}];

	diag_log "[A3PL API] Event handlers configured";
}] call compile_Server;

// ============================================================================
// REQUEST HANDLER
// ============================================================================

["Server_API_HandleRequest", {
	params ["_requestId", "_data"];

	private _params = parseSimpleArray _data;
	_params params ["_method", "_function", "_argsStr", "_toArray"];

	diag_log format ["[A3PL API] Request #%1: %2(%3)", _requestId, _function, _argsStr];

	private _response = switch (_function) do {

		// === FONCTIONS SANS ARGUMENTS ===

		case "Server_Core_GetStatus": {
			[
				["success", true],
				["players_online", count allPlayers],
				["server_ready", A3PL_server_isReady],
				["uptime", serverTime]
			]
		};

		case "Server_Core_GetPlayers": {
			private _playerList = allPlayers apply {
				[
					["uid", getPlayerUID _x],
					["name", name _x],
					["character_id", _x getVariable ["character_id", ""]],
					["job", _x getVariable ["job", ""]],
					["position", getPosATL _x]
				]
			};
			[["success", true], ["players", _playerList], ["count", count allPlayers]]
		};

		case "Server_Core_ReloadPersistentVars": {
			private _count = [] call Server_API_ReloadPersistentVars;
			[["success", true], ["message", "Variables rechargees"], ["count", _count]]
		};

		case "Vehicle_GetAll": {
			private _vehicles = (allMissionObjects "Car" + allMissionObjects "Air" + allMissionObjects "Ship") apply {
				[
					["id", str _x],
					["class", typeOf _x],
					["position", getPosATL _x],
					["owner", _x getVariable ["owner", ""]],
					["fuel", fuel _x],
					["damage", damage _x]
				]
			};
			[["success", true], ["vehicles", _vehicles], ["count", count _vehicles]]
		};

		// === FONCTIONS AVEC ARGUMENTS (format pipe) ===

		// Format: identifier (uid OU character_id)
		case "Player_GetInfo": {
			private _identifier = _argsStr;
			private _player = objNull;
			{
				if (getPlayerUID _x == _identifier) exitWith { _player = _x; };
				if ((_x getVariable ["character_id", ""]) == _identifier) exitWith { _player = _x; };
			} forEach allPlayers;

			if (isNull _player) then {
				[["success", false], ["error", "Joueur non trouve"]]
			} else {
				[
					["success", true],
					["uid", getPlayerUID _player],
					["name", name _player],
					["character_id", _player getVariable ["character_id", ""]],
					["job", _player getVariable ["job", ""]],
					["money", _player getVariable ["Player_Cash", 0]],
					["bank", _player getVariable ["Player_Bank", 0]],
					["position", getPosATL _player]
				]
			}
		};

		// Format: identifier|message (identifier = uid ou character_id)
		case "Player_SendNotification": {
			private _parts = _argsStr splitString "|";
			if (count _parts >= 2) then {
				private _identifier = _parts select 0;
				private _message = _parts select 1;

				private _player = objNull;
				{
					if (getPlayerUID _x == _identifier) exitWith { _player = _x; };
					if ((_x getVariable ["character_id", ""]) == _identifier) exitWith { _player = _x; };
				} forEach allPlayers;

				if (isNull _player) then {
					[["success", false], ["error", "Joueur non trouve"]]
				} else {
					[_message, [1,1,1,1]] remoteExec ["A3PL_Notification", _player];
					[["success", true], ["message", "Notification envoyee"]]
				}
			} else {
				[["success", false], ["error", "Format: identifier|message"]]
			}
		};

		// Format: message
		case "Player_SendNotificationAll": {
			private _message = _argsStr;
			if (_message != "") then {
				[_message, [1,1,0,1]] remoteExec ["A3PL_Notification", -2];
				[["success", true], ["message", "Notification envoyee a tous"], ["count", count allPlayers]]
			} else {
				[["success", false], ["error", "Message vide"]]
			}
		};

		// Format: identifier|sender|subject|preview (preview is optional)
		// Sends an email notification popup to a specific player
		case "Player_SendEmailNotification": {
			private _parts = _argsStr splitString "|";
			if (count _parts >= 3) then {
				private _identifier = _parts select 0;
				private _sender = _parts select 1;
				private _subject = _parts select 2;
				private _preview = if (count _parts >= 4) then { _parts select 3 } else { "" };

				private _player = objNull;
				{
					if (getPlayerUID _x == _identifier) exitWith { _player = _x; };
					if ((_x getVariable ["character_id", ""]) == _identifier) exitWith { _player = _x; };
				} forEach allPlayers;

				if (isNull _player) then {
					[["success", false], ["error", "Joueur non trouve"]]
				} else {
					[_sender, _subject, _preview] remoteExec ["A3PL_Notifications_doEmail", _player];
					[["success", true], ["message", "Email notification envoyee"]]
				}
			} else {
				[["success", false], ["error", "Format: identifier|sender|subject|preview (preview optionnel)"]]
			}
		};

		// Format: uid|character_id|type|message
		case "Server_Log_New": {
			private _parts = _argsStr splitString "|";
			if (count _parts >= 4) then {
				private _uid = _parts select 0;
				private _charId = _parts select 1;
				private _type = _parts select 2;
				private _message = _parts select 3;

				[_uid, _charId, _type, [_message]] call Server_Log_New;
				diag_log format ["[A3PL API] Log: %1 - %2", _type, _message];
				[["success", true], ["message", "Log created"]]
			} else {
				[["success", false], ["error", "Format: uid|character_id|type|message"]]
			}
		};

		// Format: function_name|arg1|arg2|arg3|...
		case "Execute_Function": {
			private _parts = _argsStr splitString "|";

			if (count _parts < 1) then {
				[["success", false], ["error", "Format: function_name|arg1|arg2|..."]]
			} else {
				private _fnc = _parts select 0;
				private _fncArgs = if (count _parts > 1) then {
					_parts select [1, count _parts - 1]
				} else {
					[]
				};

				private _code = missionNamespace getVariable [_fnc, nil];
				if (isNil "_code") then {
					[["success", false], ["error", format ["Fonction %1 non trouvee", _fnc]]]
				} else {
					private _result = _fncArgs call _code;
					diag_log format ["[A3PL API] %1(%2) -> %3", _fnc, _fncArgs, _result];
					[["success", true], ["function", _fnc], ["result", _result]]
				}
			}
		};

		// === PLAYER BANK OPERATIONS ===

		// Format: character_id|amount
		// Sets player bank if online, returns success with online status
		case "Player_SetBank": {
			private _parts = _argsStr splitString "|";
			if (count _parts >= 2) then {
				private _charId = _parts select 0;
				private _amount = parseNumber (_parts select 1);

				private _player = objNull;
				{
					if ((_x getVariable ["character_id", ""]) == _charId) exitWith { _player = _x; };
				} forEach allPlayers;

				if (isNull _player) then {
					[["success", true], ["online", false], ["message", "Joueur hors ligne - DB only"]]
				} else {
					_player setVariable ["Player_Bank", _amount, true];
					[["success", true], ["online", true], ["message", "Bank mise a jour"], ["new_balance", _amount]]
				}
			} else {
				[["success", false], ["error", "Format: character_id|amount"]]
			}
		};

		// Format: character_id|amount (adds to current bank)
		case "Player_AddBank": {
			private _parts = _argsStr splitString "|";
			if (count _parts >= 2) then {
				private _charId = _parts select 0;
				private _amount = parseNumber (_parts select 1);

				private _player = objNull;
				{
					if ((_x getVariable ["character_id", ""]) == _charId) exitWith { _player = _x; };
				} forEach allPlayers;

				if (isNull _player) then {
					[["success", true], ["online", false], ["message", "Joueur hors ligne - DB only"]]
				} else {
					private _current = _player getVariable ["Player_Bank", 0];
					private _new = _current + _amount;
					_player setVariable ["Player_Bank", _new, true];
					[["success", true], ["online", true], ["old_balance", _current], ["new_balance", _new]]
				}
			} else {
				[["success", false], ["error", "Format: character_id|amount"]]
			}
		};

		// Format: character_id|amount (removes from current bank)
		case "Player_RemoveBank": {
			private _parts = _argsStr splitString "|";
			if (count _parts >= 2) then {
				private _charId = _parts select 0;
				private _amount = parseNumber (_parts select 1);

				private _player = objNull;
				{
					if ((_x getVariable ["character_id", ""]) == _charId) exitWith { _player = _x; };
				} forEach allPlayers;

				if (isNull _player) then {
					[["success", true], ["online", false], ["message", "Joueur hors ligne - DB only"]]
				} else {
					private _current = _player getVariable ["Player_Bank", 0];
					private _new = _current - _amount;
					if (_new < 0) then { _new = 0; };
					_player setVariable ["Player_Bank", _new, true];
					[["success", true], ["online", true], ["old_balance", _current], ["new_balance", _new]]
				}
			} else {
				[["success", false], ["error", "Format: character_id|amount"]]
			}
		};

		// === COMPANY OPERATIONS ===

		// Format: uid|character_id|company_name|description
		// Creates a new company with the character as owner
		case "Company_Create": {
			private _parts = _argsStr splitString "|";
			if (count _parts >= 4) then {
				private _uid = _parts select 0;
				private _charId = _parts select 1;
				private _name = _parts select 2;
				private _description = _parts select 3;

				// Call the server function to create the company
				[_charId, _name, _description] call Server_Company_Create;

				// Log the creation
				[_uid, _charId, "Company_Creation_API", [format["New company: %1 | Description: %2", _name, _description]]] call Server_Log_New;

				[["success", true], ["message", "Entreprise creee"], ["owner", _charId], ["name", _name]]
			} else {
				[["success", false], ["error", "Format: uid|character_id|company_name|description"]]
			}
		};

		// Format: company_id|amount|description|target_character_id
		// Sends a bill from company to player
		case "Company_SendBill": {
			private _parts = _argsStr splitString "|";
			if (count _parts >= 4) then {
				private _cid = parseNumber (_parts select 0);
				private _amount = parseNumber (_parts select 1);
				private _desc = _parts select 2;
				private _targetCharId = _parts select 3;

				// Find target player
				private _target = objNull;
				{
					if ((_x getVariable ["character_id", ""]) == _targetCharId) exitWith { _target = _x; };
				} forEach allPlayers;

				if (isNull _target) then {
					[["success", true], ["online", false], ["message", "Destinataire hors ligne - facture en DB"]]
				} else {
					[_cid, _amount, _desc, _target] remoteExec ["Server_Company_SendBill", 2];
					[["success", true], ["online", true], ["message", "Facture envoyee"]]
				}
			} else {
				[["success", false], ["error", "Format: company_id|amount|description|target_character_id"]]
			}
		};

		// Reload company bills for all online players
		case "Company_ReloadBills": {
			{
				[_x] remoteExec ["Server_Company_LoadBills", 2];
			} forEach allPlayers;
			[["success", true], ["message", "Bills reloaded"], ["players_notified", count allPlayers]]
		};

		// Format: company_id|amount|description
		// Sets company bank to a specific amount
		case "Company_SetBank": {
			private _parts = _argsStr splitString "|";
			if (count _parts >= 2) then {
				private _companyId = parseNumber (_parts select 0);
				private _amount = parseNumber (_parts select 1);
				private _description = if (count _parts >= 3) then { _parts select 2 } else { "API - Set Bank" };

				// Find company in Server_Companies
				private _found = false;
				private _oldBank = 0;
				{
					if ((_x#0) isEqualTo _companyId) exitWith {
						_found = true;
						_oldBank = _x#4;
					};
				} forEach Server_Companies;

				if (!_found) then {
					[["success", false], ["error", "Entreprise non trouvee"]]
				} else {
					// Calculate change to reach target amount
					private _change = _amount - _oldBank;
					[_companyId, _change, _description] call Server_Company_SetBank;
					[["success", true], ["company_id", _companyId], ["old_balance", _oldBank], ["new_balance", _amount]]
				}
			} else {
				[["success", false], ["error", "Format: company_id|amount|description (description optionnel)"]]
			}
		};

		// Format: company_id|amount|description
		// Adds money to company bank
		case "Company_AddBank": {
			private _parts = _argsStr splitString "|";
			if (count _parts >= 2) then {
				private _companyId = parseNumber (_parts select 0);
				private _amount = parseNumber (_parts select 1);
				private _description = if (count _parts >= 3) then { _parts select 2 } else { "API - Add Bank" };

				// Find company in Server_Companies
				private _found = false;
				private _oldBank = 0;
				{
					if ((_x#0) isEqualTo _companyId) exitWith {
						_found = true;
						_oldBank = _x#4;
					};
				} forEach Server_Companies;

				if (!_found) then {
					[["success", false], ["error", "Entreprise non trouvee"]]
				} else {
					[_companyId, _amount, _description] call Server_Company_SetBank;
					[["success", true], ["company_id", _companyId], ["old_balance", _oldBank], ["added", _amount], ["new_balance", _oldBank + _amount]]
				}
			} else {
				[["success", false], ["error", "Format: company_id|amount|description (description optionnel)"]]
			}
		};

		// Format: company_id|amount|description
		// Removes money from company bank
		case "Company_RemoveBank": {
			private _parts = _argsStr splitString "|";
			if (count _parts >= 2) then {
				private _companyId = parseNumber (_parts select 0);
				private _amount = parseNumber (_parts select 1);
				private _description = if (count _parts >= 3) then { _parts select 2 } else { "API - Remove Bank" };

				// Find company in Server_Companies
				private _found = false;
				private _oldBank = 0;
				{
					if ((_x#0) isEqualTo _companyId) exitWith {
						_found = true;
						_oldBank = _x#4;
					};
				} forEach Server_Companies;

				if (!_found) then {
					[["success", false], ["error", "Entreprise non trouvee"]]
				} else {
					private _newBalance = _oldBank - _amount;
					if (_newBalance < 0) then { _newBalance = 0; _amount = _oldBank; };
					[_companyId, -_amount, _description] call Server_Company_SetBank;
					[["success", true], ["company_id", _companyId], ["old_balance", _oldBank], ["removed", _amount], ["new_balance", _newBalance]]
				}
			} else {
				[["success", false], ["error", "Format: company_id|amount|description (description optionnel)"]]
			}
		};

		// === TWITTER OPERATIONS ===

		// Format: character_id|author_name|message
		// Sends tweet via A3PL_Twitter_NewMsg (client) + Server_Twitter_HandleMsg (DB)
		case "Twitter_SendTweet": {
			private _parts = _argsStr splitString "|";
			if (count _parts >= 3) then {
				private _charId = _parts select 0;
				private _author = _parts select 1;
				private _message = _parts select 2;

				// A3PL_Twitter_NewMsg args: [_msg, _msgColor, _namePicture, _name, _nameColor, _messageTo]
				private _msgColor = "#FFFFFF";
				private _namePicture = "\A3PL_Common\icons\citizen.paa";
				private _nameColor = "#FFFFFF";
				private _messageTo = "";

				// Send to all clients
				[_message, _msgColor, _namePicture, _author, _nameColor, _messageTo] remoteExec ["A3PL_Twitter_NewMsg", -2];

				// Save to database via Server_Twitter_HandleMsg
				// Args: [_characterID, _msg, _msgcolor, _namepicture, _name, _namecolor, _toDatabase]
				[_charId, _message, _msgColor, _namePicture, _author, _nameColor, "logs_twitter"] remoteExec ["Server_Twitter_HandleMsg", 2];

				[["success", true], ["message", "Tweet envoye"], ["count", count allPlayers]]
			} else {
				[["success", false], ["error", "Format: character_id|author_name|message"]]
			}
		};

		// === PLAYER ASSET RELOAD ===

		// Format: character_id|asset_type (vehicle/house)
		// Reload player assets after eBay purchase
		case "Player_ReloadAssets": {
			private _parts = _argsStr splitString "|";
			if (count _parts >= 2) then {
				private _charId = _parts select 0;
				private _assetType = _parts select 1;

				private _player = objNull;
				{
					if ((_x getVariable ["character_id", ""]) == _charId) exitWith { _player = _x; };
				} forEach allPlayers;

				if (isNull _player) then {
					[["success", true], ["online", false], ["message", "Joueur hors ligne"]]
				} else {
					if (_assetType == "vehicle") then {
						[] remoteExec ["Player_LoadVehicles", _player];
					};
					if (_assetType == "house") then {
						[] remoteExec ["Player_LoadHouses", _player];
					};
					[["success", true], ["online", true], ["message", format ["Assets %1 recharges", _assetType]]]
				}
			} else {
				[["success", false], ["error", "Format: character_id|asset_type"]]
			}
		};

		// === DISPLAY NAMES (via config inheritance) ===

		// Format: classname|type (type = item/weapon/magazine/uniform/vest/headgear/backpack/goggles/aitem)
		// Returns display name for an item using A3PL_FactoryV2_Inheritance
		case "GetDisplayName": {
			private _parts = _argsStr splitString "|";
			if (count _parts >= 2) then {
				private _classname = _parts select 0;
				private _type = _parts select 1;
				private _displayName = [_classname, _type, "name"] call A3PL_FactoryV2_Inheritance;
				[["success", true], ["classname", _classname], ["type", _type], ["displayName", _displayName]]
			} else {
				[["success", false], ["error", "Format: classname|type"]]
			}
		};

		// Format: classname1,classname2,classname3,...|type
		// Returns display names for multiple items as flat key-value pairs
		// If type is not found, tries other types automatically
		// Response format: [[success,true],[classname1,displayName1],[classname2,displayName2],...]
		case "GetDisplayNames": {
			private _parts = _argsStr splitString "|";
			if (count _parts >= 2) then {
				private _classnamesStr = _parts select 0;
				private _primaryType = _parts select 1;
				private _classnames = _classnamesStr splitString ",";
				private _types = ["item", "", "weapon", "magazine", "uniform", "vest", "headgear", "backpack", "goggles", "aitem"];

				// Put primary type first in the list
				_types = [_primaryType] + (_types - [_primaryType]);

				private _results = [["success", true], ["count", count _classnames]];

				{
					private _classname = _x;
					private _displayName = _classname; // Default to classname

					// Try each type until we find a valid display name
					{
						private _tryName = [_classname, _x, "name"] call A3PL_FactoryV2_Inheritance;
						if (!isNil "_tryName" && {_tryName != "" && _tryName != _classname}) exitWith {
							_displayName = _tryName;
						};
					} forEach _types;

					_results pushBack [_classname, _displayName];
				} forEach _classnames;

				_results
			} else {
				[["success", false], ["error", "Format: classname1,classname2,...|type"]]
			}
		};

		// === PREMIUM / PERKDAY ===

		// Format: uid|days
		// Syncs perkday variable for an online player after PHP has already updated the DB.
		// If offline, returns online=false (PHP handles DB update independently).
		case "Player_AddPerkdays": {
			private _parts = _argsStr splitString "|";
			if (count _parts >= 2) then {
				private _uid = _parts select 0;
				private _days = parseNumber (_parts select 1);

				if (_days <= 0) exitWith {
					[["success", false], ["error", "Days must be > 0"]]
				};

				// Find the player unit by UID
				private _player = objNull;
				{
					if (getPlayerUID _x == _uid) exitWith { _player = _x; };
				} forEach allPlayers;

				if (isNull _player) then {
					[["success", true], ["online", false], ["message", "Joueur hors ligne - DB only"]]
				} else {
					// DB was already updated by PHP — read back the max perkday to sync the variable
					private _charIDs = [format ["SELECT id FROM players_characters WHERE steamid='%1' AND character_status='active'", _uid], 2, true] call Server_Database_Async;

					private _perkday = 0;
					{
						private _charPerkday = ([format ["SELECT perkday FROM players WHERE charid='%1'", _x select 0], 2, true] call Server_Database_Async) select 0 select 0;
						if (_charPerkday > _perkday) then { _perkday = _charPerkday; };
					} forEach _charIDs;

					_player setVariable ["Player_PerkDay", _perkday, true];

					diag_log format ["[A3PL API] Player_AddPerkdays: uid=%1 +%2 days -> perkday=%3 (synced)", _uid, _days, _perkday];
					[["success", true], ["online", true], ["message", "Perkday synchronise"], ["new_perkday", _perkday]]
				}
			} else {
				[["success", false], ["error", "Format: uid|days"]]
			}
		};

		// Format: uid|days
		// Syncs perkday variable for an online player after PHP has already updated the DB (subtracted days).
		// If offline, returns online=false (PHP handles DB update independently).
		case "Player_RemovePerkdays": {
			private _parts = _argsStr splitString "|";
			if (count _parts >= 2) then {
				private _uid = _parts select 0;
				private _days = parseNumber (_parts select 1);

				if (_days <= 0) exitWith {
					[["success", false], ["error", "Days must be > 0"]]
				};

				// Find the player unit by UID
				private _player = objNull;
				{
					if (getPlayerUID _x == _uid) exitWith { _player = _x; };
				} forEach allPlayers;

				if (isNull _player) then {
					[["success", true], ["online", false], ["message", "Joueur hors ligne - DB only"]]
				} else {
					// DB was already updated by PHP — read back the max perkday to sync the variable
					private _charIDs = [format ["SELECT id FROM players_characters WHERE steamid='%1' AND character_status='active'", _uid], 2, true] call Server_Database_Async;

					private _perkday = 0;
					{
						private _charPerkday = ([format ["SELECT perkday FROM players WHERE charid='%1'", _x select 0], 2, true] call Server_Database_Async) select 0 select 0;
						if (_charPerkday > _perkday) then { _perkday = _charPerkday; };
					} forEach _charIDs;

					_player setVariable ["Player_PerkDay", _perkday, true];

					diag_log format ["[A3PL API] Player_RemovePerkdays: uid=%1 -%2 days -> perkday=%3 (synced)", _uid, _days, _perkday];
					[["success", true], ["online", true], ["message", "Perkday synchronise"], ["new_perkday", _perkday]]
				}
			} else {
				[["success", false], ["error", "Format: uid|days"]]
			}
		};

		// === HOTBAR SLOTS ===

		// Format: character_id|slots
		// Adds purchased hotbar slots to a character. PHP updates DB, this syncs the in-game variable.
		// slots = number of slots to ADD (e.g. 1, 2, 3). Total is capped at 10.
		case "Player_AddHotbarSlots": {
			private _parts = _argsStr splitString "|";
			if (count _parts >= 2) then {
				private _charId = _parts select 0;
				private _slots = parseNumber (_parts select 1);

				if (_slots <= 0) exitWith {
					[["success", false], ["error", "Slots must be > 0"]]
				};

				private _player = objNull;
				{
					if ((_x getVariable ["character_id", ""]) == _charId) exitWith { _player = _x; };
				} forEach allPlayers;

				if (isNull _player) then {
					[["success", true], ["online", false], ["message", "Joueur hors ligne - DB only"]]
				} else {
					// Read back from DB to get the updated value
					private _dbSlots = ([format ["SELECT hotbar_slots FROM players WHERE charid='%1'", _charId], 2, true] call Server_Database_Async) select 0 select 0;
					if (isNil "_dbSlots" || {!(_dbSlots isEqualType 0)}) then { _dbSlots = 5; };
					_dbSlots = _dbSlots max 5 min 10;

					_player setVariable ["Player_HotbarSlots", _dbSlots, true];
					[] remoteExec ["A3PL_Hotbar_UpdateUI", _player];

					diag_log format ["[A3PL API] Player_AddHotbarSlots: charId=%1 +%2 -> %3 (synced)", _charId, _slots, _dbSlots];
					[["success", true], ["online", true], ["message", "Hotbar slots synchronises"], ["new_slots", _dbSlots]]
				}
			} else {
				[["success", false], ["error", "Format: character_id|slots"]]
			}
		};

		// === INVENTORY OPERATIONS ===

		// Format: character_id|classname|amount
		// Adds (positive) or removes (negative) a virtual item from player inventory
		case "Player_AddInventoryItem": {
			private _parts = _argsStr splitString "|";
			if (count _parts >= 3) then {
				private _charId = _parts select 0;
				private _class = _parts select 1;
				private _amount = parseNumber (_parts select 2);

				if (_amount == 0) exitWith {
					[["success", false], ["error", "Amount must be non-zero"]]
				};

				private _player = objNull;
				{
					if ((_x getVariable ["character_id", ""]) == _charId) exitWith { _player = _x; };
				} forEach allPlayers;

				if (isNull _player) then {
					[["success", false], ["error", "Joueur non connecte"]]
				} else {
					[_player, _class, _amount] call Server_Inventory_Add;
					private _newAmount = [(_player getVariable ["Player_Inventory", []]), _class, 0] call BIS_fnc_getFromPairs;
					[["success", true], ["online", true], ["classname", _class], ["amount_changed", _amount], ["new_amount", _newAmount]]
				}
			} else {
				[["success", false], ["error", "Format: character_id|classname|amount"]]
			}
		};

		// Format: character_id|classname|amount|action
		// Adds or removes a physical Arma item from the player's vanilla inventory
		// action = add/remove
		// Supports items, weapons, magazines, backpacks
		case "Player_AddArmaItem": {
			private _parts = _argsStr splitString "|";
			if (count _parts >= 4) then {
				private _charId = _parts select 0;
				private _class = _parts select 1;
				private _amount = parseNumber (_parts select 2);
				private _action = toLower (_parts select 3);

				if (_amount <= 0) exitWith {
					[["success", false], ["error", "Amount must be > 0"]]
				};

				if !(_action in ["add", "remove"]) exitWith {
					[["success", false], ["error", "Action must be 'add' or 'remove'"]]
				};

				private _player = objNull;
				{
					if ((_x getVariable ["character_id", ""]) == _charId) exitWith { _player = _x; };
				} forEach allPlayers;

				if (isNull _player) then {
					[["success", false], ["error", "Joueur non connecte"]]
				} else {
					private _done = 0;
					for "_i" from 1 to _amount do {
						if (_action == "add") then {
							_player addItem _class;
							_done = _done + 1;
						} else {
							if (_class in items _player) then {
								_player removeItem _class;
								_done = _done + 1;
							} else {
								if (_class in weapons _player) then {
									_player removeWeapon _class;
									_done = _done + 1;
								} else {
									if (_class in magazines _player) then {
										_player removeMagazine _class;
										_done = _done + 1;
									} else {
										if (backpack _player == _class) then {
											removeBackpack _player;
											_done = _done + 1;
										};
									};
								};
							};
						};
					};
					[["success", true], ["online", true], ["classname", _class], ["action", _action], ["requested", _amount], ["processed", _done]]
				}
			} else {
				[["success", false], ["error", "Format: character_id|classname|amount|action"]]
			}
		};

		// === DEFAULT ===

		default {
			diag_log format ["[A3PL API] Unknown function: %1", _function];
			[["success", false], ["error", format ["Fonction inconnue: %1", _function]]]
		};
	};

	"A3PL_Core" callExtension ["A3PL_API_SendResult", [_requestId, str _response]];
}] call compile_Server;

// ============================================================================
// CALLBACKS (SQF -> PHP)
// ============================================================================

["Server_API_HandlePostResponse", {
	params ["_requestId", "_data"];
	diag_log format ["[A3PL API] POST Response %1: %2", _requestId, _data];
	missionNamespace setVariable [format ["A3PL_API_Response_%1", _requestId], parseSimpleArray _data];
}] call compile_Server;

["Server_API_HandleGetResponse", {
	params ["_requestId", "_data"];
	diag_log format ["[A3PL API] GET Response %1: %2", _requestId, _data];
	missionNamespace setVariable [format ["A3PL_API_Response_%1", _requestId], parseSimpleArray _data];
}] call compile_Server;

// ============================================================================
// UTILITY FUNCTIONS
// ============================================================================

["Server_API_ReloadPersistentVars", {
	if (!isDedicated) exitWith {0};

	diag_log "[A3PL API] Reloading persistent variables...";

	private _pVars = ["SELECT * FROM persistent_vars", 2, true] call Server_Database_Async;
	private _count = 0;

	{
		private _varName = _x select 0;
		private _value = [(_x select 1)] call Server_Database_ToArray;
		private _public = (_x select 2) isEqualTo 1;

		call compile format ['%1 = %2;', _varName, _value];

		if (_public) then { publicVariable _varName; };
		_count = _count + 1;
	} forEach _pVars;

	diag_log format ["[A3PL API] Reloaded %1 variables", _count];
	_count
}] call compile_Server;

["Server_API_Stop", {
	if (!isDedicated) exitWith {};
	private _result = "A3PL_Core" callExtension "A3PL_API_Stop";
	diag_log format ["[A3PL API] Stopped: %1", _result];
	A3PL_API_Initialized = false;
}] call compile_Server;

["Server_API_GetStatus", {
	"A3PL_Core" callExtension "A3PL_API_GetServerStatus"
}] call compile_Server;

// ============================================================================
// OUTGOING REQUESTS (SQF -> PHP)
// ============================================================================

["Server_API_SendPOST", {
	params [["_host",""],["_port","80"],["_function",""],["_arguments","{}"],["_requestId",""]];

	if (_requestId == "") then {
		_requestId = format ["POST_%1_%2", serverTime, floor random 10000];
	};

	"A3PL_Core" callExtension ["A3PL_API_POSTRequest", [_host, _port, _function, _arguments, _requestId]];
	diag_log format ["[A3PL API] POST -> %1:%2 (%3)", _host, _port, _function];
	_requestId
}] call compile_Server;

["Server_API_SendGET", {
	params [["_host",""],["_port","80"],["_function",""],["_arguments","{}"],["_requestId",""]];

	if (_requestId == "") then {
		_requestId = format ["GET_%1_%2", serverTime, floor random 10000];
	};

	"A3PL_Core" callExtension ["A3PL_API_GETRequest", [_host, _port, _function, _arguments, _requestId]];
	diag_log format ["[A3PL API] GET -> %1:%2 (%3)", _host, _port, _function];
	_requestId
}] call compile_Server;
