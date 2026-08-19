/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/

["Server_Keypad_Init",
{
	// Variable globale pour stocker tous les codes keypad (clé = objectId)
	Keypad_GlobalCodes = createHashMap;
	publicVariable "Keypad_GlobalCodes";
}] call compile_Server;

["Server_Keypad_LoadAll",
{
	// Charger tous les codes keypad depuis la base de données au démarrage
	private _query = "SELECT object_id, building, interaction, position_x, position_y, position_z FROM keypad_codes";
	private _result = [_query, 2, true] call Server_Database_Async;
	
	Keypad_GlobalCodes = createHashMap;
	
	diag_log format ["[Keypad] Loading keypad codes, result count: %1", count _result];
	
	{
		private _row = _x;
		if (_row isEqualType []) then {
			private _objectId = "";
			private _building = "";
			private _interaction = "";
			private _posX = 0;
			private _posY = 0;
			private _posZ = 0;
			
			// Extraire les valeurs en gérant les types (string ou number)
			if (count _row > 0) then {
				_objectId = if (_row select 0 isEqualType "") then {_row select 0} else {str (_row select 0)};
			};
			if (count _row > 1) then {
				_building = if (_row select 1 isEqualType "") then {_row select 1} else {str (_row select 1)};
			};
			if (count _row > 2) then {
				_interaction = if (_row select 2 isEqualType "") then {_row select 2} else {str (_row select 2)};
			};
			if (count _row > 3) then {
				_posX = if (_row select 3 isEqualType 0) then {_row select 3} else {parseNumber (str (_row select 3))};
			};
			if (count _row > 4) then {
				_posY = if (_row select 4 isEqualType 0) then {_row select 4} else {parseNumber (str (_row select 4))};
			};
			if (count _row > 5) then {
				_posZ = if (_row select 5 isEqualType 0) then {_row select 5} else {parseNumber (str (_row select 5))};
			};
			
			// Créer une clé unique (priorité à l'objectId, sinon utiliser building_interaction_pos)
			private _key = "";
			if (_objectId != "" && _objectId != "NULL" && _objectId != "null") then {
				_key = _objectId;
			} else {
				if (_building != "" && _building != "NULL" && _building != "null" && _interaction != "" && _interaction != "NULL" && _interaction != "null") then {
					if (_posX != 0 || _posY != 0 || _posZ != 0) then {
						_key = format ["%1_%2_%3_%4_%5", _building, _interaction, round(_posX), round(_posY), round(_posZ)];
					} else {
						_key = format ["%1_%2_0_0_0", _building, _interaction];
					};
				};
			};
			
			if (_key != "") then {
				Keypad_GlobalCodes set [_key, true];
				diag_log format ["[Keypad] Added key: %1", _key];
			} else {
				diag_log format ["[Keypad] Skipped row (invalid data): objectId=%1, building=%2, interaction=%3, pos=[%4,%5,%6]", _objectId, _building, _interaction, _posX, _posY, _posZ];
			};
		};
	} forEach _result;
	
	publicVariable "Keypad_GlobalCodes";
	diag_log format ["[Keypad] Loaded %1 keypad codes into cache", count Keypad_GlobalCodes];
}] call compile_Server;

["Server_Keypad_Process",
{
	params [
		["_player", objNull, [objNull]],
		["_objectId", "", [""]],
		["_code", "", [""]],
		["_mode", "check", ["check", "set"]],
		["_callback", "", [""]],
		["_object", objNull, [objNull]],
		["_interaction", "", [""]],
		["_building", "", [""]],
		["_interactionPos", [], [[]]]
	];
	
	if (isNull _player) exitWith {};
	
	if (_objectId isEqualTo "" || _code isEqualTo "") exitWith {
		[("STR_A3PL_Keypad_InvalidParams" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
	};
	
	// Utiliser directement l'objectId qui contient maintenant la position mondiale
	private _whereClause = format ["object_id = '%1'", _objectId];
	
	if (_mode == "check") then {
		private _query = format ["SELECT code FROM keypad_codes WHERE %1", _whereClause];
		private _result = [_query, 2] call Server_Database_Async;
		
		if (count _result > 0) then {
			private _firstRow = _result select 0;
			private _storedCode = "";
			if (_firstRow isEqualType []) then {
				if (count _firstRow > 0) then {
					_storedCode = _firstRow select 0;
				};
			} else {
				_storedCode = _firstRow;
			};
			
			if (_storedCode != "" && _code == _storedCode) then {
				if (_callback != "") then {
					[] remoteExec [_callback, _player];
				};
				[] remoteExec ["A3PL_Keypad_OnCodeCorrect", _player];
			} else {
				[] remoteExec ["A3PL_Keypad_OnCodeIncorrect", _player];
			};
		} else {
			[("STR_A3PL_Keypad_NoCodeSet" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
			[] remoteExec ["A3PL_Keypad_OnCodeIncorrect", _player];
		};
	} else {
		if (_mode == "change") then {
			private _charId = _player getVariable ["character_id", ""];
			private _hasPermission = false;
			
			// Récupérer le charid qui a défini le code
			private _query = format ["SELECT charid FROM keypad_codes WHERE %1", _whereClause];
			private _result = [_query, 2] call Server_Database_Async;
			
			if (count _result == 0) then {
				[("STR_A3PL_Keypad_NoCodeSet" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
				[] remoteExec ["A3PL_Keypad_OnCodeIncorrect", _player];
			} else {
				private _originalCharId = "";
				private _firstRow = _result select 0;
				if (_firstRow isEqualType []) then {
					if (count _firstRow > 0) then {
						_originalCharId = _firstRow select 0;
					};
				} else {
					_originalCharId = _firstRow;
				};
				
				// Vérification des permissions pour les bâtiments de faction
				if (_building != "" && !isNull _object) then {
					private _requiredFaction = "";
					{
						if (_building IN (_x select 1)) exitWith {
							_requiredFaction = _x select 0;
						};
					} forEach Keypad_FactionBuildings;
					
					if (_requiredFaction != "") then {
						// Bâtiment de faction - n'importe quel leader peut changer
						private _isLeader = [_requiredFaction, _player] call A3PL_Government_isFactionLeader;
						if (_isLeader) then {
							_hasPermission = true;
						} else {
							private _factionName = switch (_requiredFaction) do {
								case ("STR_Common_FISD" call A3PL_Localize): {("STR_Common_FISD" call A3PL_Localize)};
								case ("STR_Common_FIFR" call A3PL_Localize): {("STR_Common_FIFR" call A3PL_Localize)};
								case ("STR_Common_DOJ" call A3PL_Localize): {("STR_Common_DOJ" call A3PL_Localize)};
								case ("STR_Common_GOV" call A3PL_Localize): {("STR_Common_GOV" call A3PL_Localize)};
								default {_requiredFaction};
							};
							[format[("STR_A3PL_Keypad_NeedFactionLead" call A3PL_Localize), _factionName], Color_Red] remoteExec ["A3PL_Notification", _player];
							[] remoteExec ["A3PL_Keypad_OnCodeIncorrect", _player];
						};
					} else {
						// Bâtiment classique - seul le charid original peut changer
						if (_originalCharId == _charId) then {
							_hasPermission = true;
						} else {
							[("STR_A3PL_Keypad_OnlyOriginalOwnerCanChange" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
							[] remoteExec ["A3PL_Keypad_OnCodeIncorrect", _player];
						};
					};
				} else {
					// Pas de bâtiment défini - seul le charid original peut changer
					if (_originalCharId == _charId) then {
						_hasPermission = true;
					} else {
						[("STR_A3PL_Keypad_OnlyOriginalOwnerCanChange" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
						[] remoteExec ["A3PL_Keypad_OnCodeIncorrect", _player];
					};
				};
				
				if (_hasPermission) then {
					// L'objectId contient déjà toutes les informations nécessaires (position mondiale incluse)
					private _finalObjectId = _objectId;
					
					// Mettre à jour le code
					private _updateQuery = format ["UPDATE keypad_codes SET code = '%1', charid = '%2' WHERE %3", _code, _charId, _whereClause];
					diag_log format ["[Keypad] CHANGE query: %1", _updateQuery];
					[_updateQuery, 1] spawn Server_Database_Async;
					
					// Mettre à jour le cache global
					if (_finalObjectId != "") then {
						Keypad_GlobalCodes set [_finalObjectId, true];
						publicVariable "Keypad_GlobalCodes";
					};
					
					// Mettre à jour la variable sur l'objet (synchronisé avec tous les clients)
					if (!isNull _object && _interaction != "") then {
						private _varName = format ["keypad_%1", _interaction];
						_object setVariable [_varName, true, true];
						
						// Verrouiller la porte si un keypad est défini
						_object setVariable ["locked", true, true];
					};
					
					[] remoteExec ["A3PL_Keypad_OnCodeSet", _player];
					
					if (_callback != "") then {
						[] remoteExec [_callback, _player];
					};
					[("STR_A3PL_Keypad_CodeChanged" call A3PL_Localize), Color_Green] remoteExec ["A3PL_Notification", _player];
				};
			};
		} else {
			if (_mode == "set") then {
				private _charId = _player getVariable ["character_id", ""];
				private _hasPermission = false;
				
				// Vérification des permissions pour les bâtiments de faction
				if (_building != "" && !isNull _object) then {
					private _requiredFaction = "";
					{
						if (_building IN (_x select 1)) exitWith {
							_requiredFaction = _x select 0;
						};
					} forEach Keypad_FactionBuildings;
					
					if (_requiredFaction != "") then {
						// Bâtiment de faction - vérifier si le joueur est lead
						private _isLeader = [_requiredFaction, _player] call A3PL_Government_isFactionLeader;
						if (_isLeader) then {
							_hasPermission = true;
						} else {
							private _factionName = switch (_requiredFaction) do {
								case ("STR_Common_FISD" call A3PL_Localize): {("STR_Common_FISD" call A3PL_Localize)};
								case ("STR_Common_FIFR" call A3PL_Localize): {("STR_Common_FIFR" call A3PL_Localize)};
								case ("STR_Common_DOJ" call A3PL_Localize): {("STR_Common_DOJ" call A3PL_Localize)};
								case ("STR_Common_GOV" call A3PL_Localize): {("STR_Common_GOV" call A3PL_Localize)};
								default {_requiredFaction};
							};
							[format[("STR_A3PL_Keypad_NeedFactionLead" call A3PL_Localize), _factionName], Color_Red] remoteExec ["A3PL_Notification", _player];
							[] remoteExec ["A3PL_Keypad_OnCodeIncorrect", _player];
						};
					} else {
						// Bâtiment classique - vérifier la propriété
						// Vérifier si c'est un shop/warehouse d'entreprise
						private _companyName = _object getVariable ["companyName", ""];
						if (_companyName != "") then {
							// C'est un shop/warehouse d'entreprise
							private _query = format ["SELECT id FROM companies WHERE name = '%1' AND disabled = '0'", _companyName];
							private _result = [_query, 2] call Server_Database_Async;
							
							if (count _result > 0) then {
								private _companyId = _result select 0 select 0;
								private _hasPerm = [_companyId, "shop", _charId] call A3FL_Config_GetCompanyPermissions;
								if (_hasPerm) then {
									_hasPermission = true;
								} else {
									[("STR_A3PL_Keypad_NeedCompanyPermission" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
									[] remoteExec ["A3PL_Keypad_OnCodeIncorrect", _player];
								};
							} else {
								[("STR_A3PL_Keypad_CompanyNotFound" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
								[] remoteExec ["A3PL_Keypad_OnCodeIncorrect", _player];
							};
						} else {
							// Bâtiment personnel (maison, warehouse, crackhouse)
							private _owners = _object getVariable ["owner", []];
							if (count _owners > 0) then {
								// Le premier élément du array est le propriétaire principal
								if ((_owners select 0) isEqualTo _charId) then {
									_hasPermission = true;
								} else {
									[("STR_A3PL_Keypad_NeedBuildingOwner" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
									[] remoteExec ["A3PL_Keypad_OnCodeIncorrect", _player];
								};
							} else {
								// Pas de propriétaire défini - refuser l'accès pour les bâtiments
								[("STR_A3PL_Keypad_NeedBuildingOwner" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
								[] remoteExec ["A3PL_Keypad_OnCodeIncorrect", _player];
							};
						};
					};
				} else {
					// Pas de bâtiment défini - refuser l'accès par défaut (sécurité)
					// Seulement permettre si c'est vraiment un objet simple (pas un bâtiment)
					// Pour l'instant, on refuse pour être sûr
					[("STR_A3PL_Keypad_NeedBuildingOwner" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
					[] remoteExec ["A3PL_Keypad_OnCodeIncorrect", _player];
				};
				
				if (_hasPermission) then {
					// L'objectId contient déjà toutes les informations nécessaires (position mondiale incluse)
					private _finalObjectId = _objectId;
					
					private _query = format ["SELECT id FROM keypad_codes WHERE %1", _whereClause];
					private _result = [_query, 2] call Server_Database_Async;
					
					if (count _result > 0) then {
						private _updateQuery = format ["UPDATE keypad_codes SET code = '%1', charid = '%2' WHERE %3", _code, _charId, _whereClause];
						diag_log format ["[Keypad] UPDATE query: %1", _updateQuery];
						[_updateQuery, 1] spawn Server_Database_Async;
					} else {
						// Extraire les informations pour la compatibilité avec la base de données
						private _posX = 0;
						private _posY = 0;
						private _posZ = 0;
						if (!isNull _object && _interaction != "" && _building != "" && count _interactionPos == 3) then {
							_posX = round((_interactionPos select 0) * 100);
							_posY = round((_interactionPos select 1) * 100);
							_posZ = round((_interactionPos select 2) * 100);
						};
						
						// Obtenir la position mondiale pour la sauvegarder aussi
						private _worldPosX = 0;
						private _worldPosY = 0;
						private _worldPosZ = 0;
						if (!isNull _object) then {
							private _worldPos = getPosWorld _object;
							_worldPosX = round((_worldPos select 0) * 10);
							_worldPosY = round((_worldPos select 1) * 10);
							_worldPosZ = round((_worldPos select 2) * 10);
						};
						
						if (!isNull _object && _interaction != "" && _building != "") then {
							private _insertQuery = format ["INSERT INTO keypad_codes (object_id, code, building, interaction, position_x, position_y, position_z, charid) VALUES ('%1', '%2', '%3', '%4', %5, %6, %7, '%8')", _objectId, _code, _building, _interaction, _posX, _posY, _posZ, _charId];
							diag_log format ["[Keypad] INSERT query: %1", _insertQuery];
							[_insertQuery, 1] spawn Server_Database_Async;
						} else {
							private _insertQuery = format ["INSERT INTO keypad_codes (object_id, code, charid) VALUES ('%1', '%2', '%3')", _objectId, _code, _charId];
							diag_log format ["[Keypad] INSERT query (simple): %1", _insertQuery];
							[_insertQuery, 1] spawn Server_Database_Async;
						};
					};
					
					// Mettre à jour le cache global
					if (_finalObjectId != "") then {
						Keypad_GlobalCodes set [_finalObjectId, true];
						publicVariable "Keypad_GlobalCodes";
					};
					
					// Retirer l'item keypad de l'inventaire après avoir défini le code
					[_player, "keypad", -1] call Server_Inventory_Add;
					
					// Mettre à jour la variable sur l'objet (synchronisé avec tous les clients)
					if (!isNull _object && _interaction != "") then {
						private _varName = format ["keypad_%1", _interaction];
						_object setVariable [_varName, true, true];
						
						// Verrouiller la porte si un keypad est défini
						_object setVariable ["locked", true, true];
					};
					
					[] remoteExec ["A3PL_Keypad_OnCodeSet", _player];
					
					if (_callback != "") then {
						[] remoteExec [_callback, _player];
					};
				};
			};
		};
	};
}] call compile_Server;

["Server_Keypad_CheckExists",
{
	params [
		["_player", objNull, [objNull]],
		["_objectId", "", [""]],
		["_object", objNull, [objNull]],
		["_interaction", "", [""]],
		["_building", "", [""]],
		["_interactionPos", [], [[]]],
		["_requestedMode", "", [""]]
	];
	
	if (isNull _player) exitWith {};
	if (_objectId isEqualTo "") exitWith {};
	
	// Utiliser directement l'objectId qui contient maintenant la position mondiale
	private _whereClause = format ["object_id = '%1'", _objectId];
	
	private _query = format ["SELECT id FROM keypad_codes WHERE %1", _whereClause];
	private _result = [_query, 2] call Server_Database_Async;
	
	private _codeExists = count _result > 0;
	private _finalMode = _requestedMode;
	
	if (_requestedMode == "") then {
		if (_codeExists) then {
			_finalMode = "check";
		} else {
			_finalMode = "set";
		};
	};
	
	// L'objectId contient déjà toutes les informations nécessaires (position mondiale incluse)
	private _finalObjectId = _objectId;
	
	[_codeExists, _finalMode, _finalObjectId, _building, _interaction, _object] remoteExec ["A3PL_Keypad_ReceiveCodeExists", _player];
}] call compile_Server;

["Server_Keypad_Delete",
{
	params [
		["_player", objNull, [objNull]],
		["_objectId", "", [""]],
		["_object", objNull, [objNull]],
		["_interaction", "", [""]],
		["_building", "", [""]],
		["_interactionPos", [], [[]]]
	];
	
	if (isNull _player) exitWith {};
	
	// Utiliser directement l'objectId qui contient maintenant la position mondiale
	private _whereClause = format ["object_id = '%1'", _objectId];
	
	private _charId = _player getVariable ["character_id", ""];
	private _hasPermission = false;
	
	// Récupérer le charid qui a défini le code
	private _query = format ["SELECT charid FROM keypad_codes WHERE %1", _whereClause];
	private _result = [_query, 2] call Server_Database_Async;
	
	if (count _result == 0) then {
		[("STR_A3PL_Keypad_NoCodeSet" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
	} else {
		private _originalCharId = "";
		private _firstRow = _result select 0;
		if (_firstRow isEqualType []) then {
			if (count _firstRow > 0) then {
				_originalCharId = _firstRow select 0;
			};
		} else {
			_originalCharId = _firstRow;
		};
		
		// Vérification des permissions pour les bâtiments de faction
		if (_building != "" && !isNull _object) then {
			private _requiredFaction = "";
			{
				if (_building IN (_x select 1)) exitWith {
					_requiredFaction = _x select 0;
				};
			} forEach Keypad_FactionBuildings;
			
			if (_requiredFaction != "") then {
				// Bâtiment de faction - n'importe quel leader peut supprimer
				private _isLeader = [_requiredFaction, _player] call A3PL_Government_isFactionLeader;
				if (_isLeader) then {
					_hasPermission = true;
				} else {
					private _factionName = switch (_requiredFaction) do {
						case ("STR_Common_FISD" call A3PL_Localize): {("STR_Common_FISD" call A3PL_Localize)};
						case ("STR_Common_FIFR" call A3PL_Localize): {("STR_Common_FIFR" call A3PL_Localize)};
						case ("STR_Common_DOJ" call A3PL_Localize): {("STR_Common_DOJ" call A3PL_Localize)};
						case ("STR_Common_GOV" call A3PL_Localize): {("STR_Common_GOV" call A3PL_Localize)};
						default {_requiredFaction};
					};
					[format[("STR_A3PL_Keypad_NeedFactionLead" call A3PL_Localize), _factionName], Color_Red] remoteExec ["A3PL_Notification", _player];
				};
			} else {
				// Bâtiment classique - seul le charid original peut supprimer
				if (_originalCharId == _charId) then {
					_hasPermission = true;
				} else {
					[("STR_A3PL_Keypad_OnlyOriginalOwnerCanDelete" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
				};
			};
		} else {
			// Pas de bâtiment défini - seul le charid original peut supprimer
			if (_originalCharId == _charId) then {
				_hasPermission = true;
			} else {
				[("STR_A3PL_Keypad_OnlyOriginalOwnerCanDelete" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
			};
		};
		
		if (_hasPermission) then {
			// L'objectId contient déjà toutes les informations nécessaires (position mondiale incluse)
			private _finalObjectId = _objectId;
			
			// Supprimer le code de la base de données
			private _deleteQuery = format ["DELETE FROM keypad_codes WHERE %1", _whereClause];
			diag_log format ["[Keypad] DELETE query: %1", _deleteQuery];
			[_deleteQuery, 1] spawn Server_Database_Async;
			
			// Mettre à jour le cache global
			if (_finalObjectId != "") then {
				Keypad_GlobalCodes deleteAt _finalObjectId;
				publicVariable "Keypad_GlobalCodes";
			};
			
			// Mettre à jour la variable sur l'objet (synchronisé avec tous les clients)
			if (!isNull _object && _interaction != "") then {
				private _varName = format ["keypad_%1", _interaction];
				_object setVariable [_varName, false, true];
				
				// Vérifier s'il reste d'autres keypads sur cet objet
				private _hasOtherKeypads = false;
				{
					if (_x find "keypad_" == 0) then {
						private _keypadVar = _object getVariable [_x, nil];
						if (!isNil "_keypadVar" && _keypadVar) then {
							_hasOtherKeypads = true;
						};
					};
				} forEach (allVariables _object);
				
				// Déverrouiller la porte seulement s'il n'y a plus de keypads
				if (!_hasOtherKeypads) then {
					_object setVariable ["locked", false, true];
				};
			};
			
			// Donner l'item "keypad" au joueur
			[_player, "keypad", 1] remoteExec ["Server_Inventory_Add", 2];
			
			[("STR_A3PL_Keypad_Deleted" call A3PL_Localize), Color_Green] remoteExec ["A3PL_Notification", _player];
		};
	};
}] call compile_Server;


