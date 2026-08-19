/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Keypad_Open",
{
	disableSerialization;
	params [
		["_objectId", "", [""]],
		["_mode", "", [""]],
		["_callback", "", [""]],
		["_object", objNull, [objNull]],
		["_interaction", "", [""]],
		["_building", "", [""]]
	];
	
	if (!isNull (findDisplay 697356)) exitWith {};
	
	private _finalObjectId = _objectId;
	private _interactionPos = [];
	
	if (!isNull _object && _interaction != "" && _building != "") then {
		private _selPos = _object selectionPosition [_interaction, "Memory"];
		if (_selPos isEqualTo [0,0,0] || count _selPos < 3) then {
			_selPos = _object selectionPosition _interaction;
		};
		if (_selPos isEqualTo [0,0,0] || count _selPos < 3) then {
			_selPos = [0, 0, 0];
		};
		
		// Obtenir la position mondiale de l'objet pour créer un ID unique
		private _worldPos = getPosWorld _object;
		private _worldPosX = round((_worldPos select 0) * 10);
		private _worldPosY = round((_worldPos select 1) * 10);
		private _worldPosZ = round((_worldPos select 2) * 10);
		
		if (count _selPos >= 3) then {
			_interactionPos = [_selPos select 0, _selPos select 1, _selPos select 2];
			_finalObjectId = format ["%1_%2_%3_%4_%5_%6_%7_%8", _building, _interaction, round((_selPos select 0) * 100), round((_selPos select 1) * 100), round((_selPos select 2) * 100), _worldPosX, _worldPosY, _worldPosZ];
		} else {
			_interactionPos = [0, 0, 0];
			_finalObjectId = format ["%1_%2_0_0_0_%3_%4_%5", _building, _interaction, _worldPosX, _worldPosY, _worldPosZ];
		};
	};
	
	createDialog "Dialog_Keypad";
	private _display = findDisplay 697356;
	if (isNull _display) exitWith {};
	
	_display setVariable ["A3PL_Keypad_ObjectId", _finalObjectId];
	_display setVariable ["A3PL_Keypad_Mode", _mode];
	_display setVariable ["A3PL_Keypad_Callback", _callback];
	_display setVariable ["A3PL_Keypad_Code", ""];
	_display setVariable ["A3PL_Keypad_FirstCode", ""];
	_display setVariable ["A3PL_Keypad_CodeExists", false];
	_display setVariable ["A3PL_Keypad_SettingCode", false];
	_display setVariable ["A3PL_Keypad_ChangingCode", false];
	_display setVariable ["A3PL_Keypad_OldCodeVerified", false];
	_display setVariable ["A3PL_Keypad_NewCode", ""];
	_display setVariable ["A3PL_Keypad_ConfirmingNewCode", false];
	_display setVariable ["A3PL_Keypad_HashPressCount", 0];
	_display setVariable ["A3PL_Keypad_LastHashTime", 0];
	_display setVariable ["A3PL_Keypad_NotificationShown", false];
	_display setVariable ["A3PL_Keypad_ConfirmNotificationShown", false];
	_display setVariable ["A3PL_Keypad_Object", _object];
	_display setVariable ["A3PL_Keypad_Interaction", _interaction];
	_display setVariable ["A3PL_Keypad_Building", _building];
	_display setVariable ["A3PL_Keypad_InteractionPos", _interactionPos];
	
	private _fadedControls = [1201, 1202, 1203, 1204, 1205, 1206, 1207, 1208, 1209, 1210, 1211, 1212];
	{
		private _ctrl = _display displayCtrl _x;
		_ctrl ctrlShow false;
		_ctrl ctrlCommit 0;
	} forEach _fadedControls;
	
	[_finalObjectId, _object, _interaction, _building, _interactionPos, _mode] spawn {
		params ["_finalObjectId", "_object", "_interaction", "_building", "_interactionPos", "_requestedMode"];
		uiSleep 0.1;
		[player, _finalObjectId, _object, _interaction, _building, _interactionPos, _requestedMode] remoteExec ["Server_Keypad_CheckExists", 2];
	};
	
	private _buttonIds = [1600, 1601, 1602, 1603, 1604, 1605, 1606, 1607, 1608, 1609, 1610, 1611];
	private _buttonValues = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "#", "*"];
	
	{
		private _buttonId = _x;
		private _buttonValue = _buttonValues select _forEachIndex;
		private _fadedId = 1201 + _forEachIndex;
		
		private _button = _display displayCtrl _buttonId;
		_button ctrlSetText "";
		_button ctrlSetBackgroundColor [0, 0, 0, 0];
		
		_button buttonSetAction format ["[%1, '%2', %3] call A3PL_Keypad_ButtonPress;", _buttonId, _buttonValue, _fadedId];
		
		_button ctrlAddEventHandler ["MouseEnter", {
			params ["_control"];
			private _display = ctrlParent _control;
			private _fadedId = _display getVariable [format ["A3PL_Keypad_Faded_%1", ctrlIDC _control], -1];
			if (_fadedId >= 0) then {
				private _fadedCtrl = _display displayCtrl _fadedId;
				_fadedCtrl ctrlShow true;
				_fadedCtrl ctrlCommit 0;
			};
		}];
		
		_button ctrlAddEventHandler ["MouseExit", {
			params ["_control"];
			private _display = ctrlParent _control;
			private _fadedId = _display getVariable [format ["A3PL_Keypad_Faded_%1", ctrlIDC _control], -1];
			if (_fadedId >= 0) then {
				private _fadedCtrl = _display displayCtrl _fadedId;
				_fadedCtrl ctrlShow false;
				_fadedCtrl ctrlCommit 0;
			};
		}];
		
		_display setVariable [format ["A3PL_Keypad_Faded_%1", _buttonId], _fadedId];
	} forEach _buttonIds;
}] call compile_Global;

["A3PL_Keypad_ButtonPress",
{
	params [["_buttonId", 0], ["_value", ""], ["_fadedId", 0]];
	
	private _display = findDisplay 697356;
	if (isNull _display) exitWith {};
	
	private _currentCode = _display getVariable ["A3PL_Keypad_Code", ""];
	private _codeExists = _display getVariable ["A3PL_Keypad_CodeExists", false];
	private _changingCode = _display getVariable ["A3PL_Keypad_ChangingCode", false];
	
	if (_value == "*") then {
		// Si le code est vide et qu'un code existe, activer le mode changement de code
		if (_currentCode == "" && _codeExists && !_changingCode) then {
			_display setVariable ["A3PL_Keypad_ChangingCode", true];
			[("STR_A3PL_Keypad_EnterCurrentCode" call A3PL_Localize), Color_Orange] call A3PL_Notification;
		} else {
			// Sinon, effacer le dernier caractère
			if (count _currentCode > 0) then {
				_currentCode = _currentCode select [0, count _currentCode - 1];
				_display setVariable ["A3PL_Keypad_Code", _currentCode];
				[] call A3PL_Keypad_UpdateDisplay;
			};
		};
	} else {
		if (_value == "#") then {
			// Vérifier si on doit supprimer le keypad (3 "#" consécutifs)
			private _hashPressCount = _display getVariable ["A3PL_Keypad_HashPressCount", 0];
			private _lastHashTime = _display getVariable ["A3PL_Keypad_LastHashTime", 0];
			private _currentTime = diag_tickTime;
			
			// Si le code est vide et qu'un code existe, vérifier les appuis consécutifs
			if (_currentCode == "" && _codeExists && !_changingCode) then {
				// Si moins de 2 secondes se sont écoulées depuis le dernier "#"
				if (_currentTime - _lastHashTime < 2) then {
					_hashPressCount = _hashPressCount + 1;
					_display setVariable ["A3PL_Keypad_HashPressCount", _hashPressCount];
					_display setVariable ["A3PL_Keypad_LastHashTime", _currentTime];
					
					if (_hashPressCount >= 3) then {
						// Supprimer le keypad
						private _object = _display getVariable ["A3PL_Keypad_Object", objNull];
						private _interaction = _display getVariable ["A3PL_Keypad_Interaction", ""];
						private _building = _display getVariable ["A3PL_Keypad_Building", ""];
						private _interactionPos = _display getVariable ["A3PL_Keypad_InteractionPos", []];
						private _objectId = _display getVariable ["A3PL_Keypad_ObjectId", ""];
						
						[player, _objectId, _object, _interaction, _building, _interactionPos] remoteExec ["Server_Keypad_Delete", 2];
						closeDialog 0;
					} else {
						[format[("STR_A3PL_Keypad_PressHashToDelete" call A3PL_Localize), 3 - _hashPressCount], Color_Orange] call A3PL_Notification;
					};
				} else {
					// Trop de temps écoulé, réinitialiser le compteur
					_display setVariable ["A3PL_Keypad_HashPressCount", 1];
					_display setVariable ["A3PL_Keypad_LastHashTime", _currentTime];
					[format[("STR_A3PL_Keypad_PressHashToDelete" call A3PL_Localize), 2], Color_Orange] call A3PL_Notification;
				};
			} else {
				// Réinitialiser le compteur si on n'est pas dans les conditions
				_display setVariable ["A3PL_Keypad_HashPressCount", 0];
				_display setVariable ["A3PL_Keypad_LastHashTime", 0];
				[] call A3PL_Keypad_Submit;
			};
		} else {
			// Réinitialiser le compteur de "#" si on appuie sur autre chose
			_display setVariable ["A3PL_Keypad_HashPressCount", 0];
			_display setVariable ["A3PL_Keypad_LastHashTime", 0];
			if (count _currentCode >= 4) exitWith {};
			_currentCode = _currentCode + _value;
			_display setVariable ["A3PL_Keypad_Code", _currentCode];
			[] call A3PL_Keypad_UpdateDisplay;
		};
	};
}] call compile_Global;

["A3PL_Keypad_UpdateDisplay",
{
	private _display = findDisplay 697356;
	if (isNull _display) exitWith {};
	
	private _code = _display getVariable ["A3PL_Keypad_Code", ""];
	private _textCtrl = _display displayCtrl 1000;
	private _codeExists = _display getVariable ["A3PL_Keypad_CodeExists", false];
	private _mode = _display getVariable ["A3PL_Keypad_Mode", "check"];
	private _settingCode = _display getVariable ["A3PL_Keypad_SettingCode", false];
	private _firstCode = _display getVariable ["A3PL_Keypad_FirstCode", ""];
	private _notificationShown = _display getVariable ["A3PL_Keypad_NotificationShown", false];
	private _confirmNotificationShown = _display getVariable ["A3PL_Keypad_ConfirmNotificationShown", false];
	
	if (!_codeExists && _mode == "set" && !_settingCode && !_notificationShown) then {
		[("STR_A3PL_Keypad_NoCodeSetEnterTwice" call A3PL_Localize), Color_Orange] call A3PL_Notification;
		_display setVariable ["A3PL_Keypad_NotificationShown", true];
	} else {
		if (!_codeExists && _mode == "set" && _settingCode && _firstCode != "" && !_confirmNotificationShown) then {
			[("STR_A3PL_Keypad_ConfirmCode" call A3PL_Localize), Color_Orange] call A3PL_Notification;
			_display setVariable ["A3PL_Keypad_ConfirmNotificationShown", true];
		};
	};
}] call compile_Global;

["A3PL_Keypad_Submit",
{
	private _display = findDisplay 697356;
	if (isNull _display) exitWith {};
	
	private _code = _display getVariable ["A3PL_Keypad_Code", ""];
	private _objectId = _display getVariable ["A3PL_Keypad_ObjectId", ""];
	private _mode = _display getVariable ["A3PL_Keypad_Mode", "check"];
	private _callback = _display getVariable ["A3PL_Keypad_Callback", ""];
	private _codeExists = _display getVariable ["A3PL_Keypad_CodeExists", false];
	private _settingCode = _display getVariable ["A3PL_Keypad_SettingCode", false];
	private _firstCode = _display getVariable ["A3PL_Keypad_FirstCode", ""];
	private _changingCode = _display getVariable ["A3PL_Keypad_ChangingCode", false];
	private _oldCodeVerified = _display getVariable ["A3PL_Keypad_OldCodeVerified", false];
	private _newCode = _display getVariable ["A3PL_Keypad_NewCode", ""];
	private _confirmingNewCode = _display getVariable ["A3PL_Keypad_ConfirmingNewCode", false];
	private _object = _display getVariable ["A3PL_Keypad_Object", objNull];
	private _interaction = _display getVariable ["A3PL_Keypad_Interaction", ""];
	private _building = _display getVariable ["A3PL_Keypad_Building", ""];
	private _interactionPos = _display getVariable ["A3PL_Keypad_InteractionPos", []];
	
	if (_code isEqualTo "") exitWith {
		[("STR_A3PL_Keypad_EnterCode" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	
	if (count _code != 4) exitWith {
		[("STR_A3PL_Keypad_CodeMustBe4Digits" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	
	// Gestion du changement de code
	if (_changingCode && !_oldCodeVerified) then {
		// Vérifier l'ancien code
		[player, _objectId, _code, "check", "", _object, _interaction, _building, _interactionPos] remoteExec ["Server_Keypad_Process", 2];
		// Le serveur appellera A3PL_Keypad_OnOldCodeVerified si correct
	} else {
		if (_changingCode && _oldCodeVerified && !_confirmingNewCode) then {
			// Première saisie du nouveau code
			_display setVariable ["A3PL_Keypad_NewCode", _code];
			_display setVariable ["A3PL_Keypad_ConfirmingNewCode", true];
			_display setVariable ["A3PL_Keypad_Code", ""];
			[("STR_A3PL_Keypad_ConfirmNewCode" call A3PL_Localize), Color_Orange] call A3PL_Notification;
			[] call A3PL_Keypad_UpdateDisplay;
		} else {
			if (_changingCode && _oldCodeVerified && _confirmingNewCode) then {
				// Confirmation du nouveau code
				if (_code != _newCode) then {
					[("STR_A3PL_Keypad_CodesDoNotMatch" call A3PL_Localize), Color_Red] call A3PL_Notification;
					_display setVariable ["A3PL_Keypad_Code", ""];
					_display setVariable ["A3PL_Keypad_NewCode", ""];
					_display setVariable ["A3PL_Keypad_ConfirmingNewCode", false];
					[] call A3PL_Keypad_UpdateDisplay;
				} else {
					// Envoyer le changement de code au serveur
					[player, _objectId, _code, "change", _callback, _object, _interaction, _building, _interactionPos] remoteExec ["Server_Keypad_Process", 2];
				};
			} else {
				// Logique normale (set ou check)
				if (!_codeExists && _mode == "set" && !_settingCode) then {
					// Vérifier si le joueur a l'item "keypad" dans la main
					if (!(Player_ItemClass isEqualTo "keypad")) exitWith {
						[("STR_A3PL_Keypad_NeedKeypadItem" call A3PL_Localize), Color_Red] call A3PL_Notification;
					};
					_display setVariable ["A3PL_Keypad_FirstCode", _code];
					_display setVariable ["A3PL_Keypad_SettingCode", true];
					_display setVariable ["A3PL_Keypad_Code", ""];
					[] call A3PL_Keypad_UpdateDisplay;
				} else {
					if (!_codeExists && _mode == "set" && _settingCode) then {
						// Vérifier si le joueur a toujours l'item "keypad" dans la main
						if (!(Player_ItemClass isEqualTo "keypad")) exitWith {
							[("STR_A3PL_Keypad_NeedKeypadItem" call A3PL_Localize), Color_Red] call A3PL_Notification;
							_display setVariable ["A3PL_Keypad_Code", ""];
							_display setVariable ["A3PL_Keypad_FirstCode", ""];
							_display setVariable ["A3PL_Keypad_SettingCode", false];
							[] call A3PL_Keypad_UpdateDisplay;
						};
						if (_code != _firstCode) then {
							[("STR_A3PL_Keypad_CodesDoNotMatch" call A3PL_Localize), Color_Red] call A3PL_Notification;
							_display setVariable ["A3PL_Keypad_Code", ""];
							_display setVariable ["A3PL_Keypad_FirstCode", ""];
							_display setVariable ["A3PL_Keypad_SettingCode", false];
							[] call A3PL_Keypad_UpdateDisplay;
						} else {
							[player, _objectId, _code, _mode, _callback, _object, _interaction, _building, _interactionPos] remoteExec ["Server_Keypad_Process", 2];
						};
					} else {
						[player, _objectId, _code, _mode, _callback, _object, _interaction, _building, _interactionPos] remoteExec ["Server_Keypad_Process", 2];
						if (_mode == "check") then {
						} else {
							closeDialog 0;
						};
					};
				};
			};
		};
	};
}] call compile_Global;

["A3PL_Keypad_ReceiveCodeExists",
{
	params [["_codeExists", false], ["_mode", "check", [""]], ["_objectId", ""], ["_building", ""], ["_interaction", ""], ["_object", objNull, [objNull]]];
	
	// Mettre à jour la variable sur l'objet (synchronisé avec tous les clients)
	if (!isNull _object && _interaction != "") then {
		private _varName = format ["keypad_%1", _interaction];
		_object setVariable [_varName, _codeExists, true];
	};
	
	[_codeExists, _mode] spawn {
		params ["_codeExists", "_mode"];
		private _display = findDisplay 697356;
		private _maxWait = 10;
		private _waited = 0;
		
		while {isNull _display && _waited < _maxWait} do {
			uiSleep 0.1;
			_display = findDisplay 697356;
			_waited = _waited + 0.1;
		};
		
		if (isNull _display) exitWith {};
		
		_display setVariable ["A3PL_Keypad_CodeExists", _codeExists];
		_display setVariable ["A3PL_Keypad_Mode", _mode];
	};
}] call compile_Global;

["A3PL_Keypad_OnCodeSet",
{
	private _display = findDisplay 697356;
	if (isNull _display) exitWith {};

	// Retirer l'item keypad de la main après avoir défini le code
	if (Player_ItemClass isEqualTo "keypad") then {
		[] call A3PL_Inventory_Clear;
	};

	[("STR_A3PL_Keypad_CodeSetSuccess" call A3PL_Localize), Color_Green] call A3PL_Notification;

	closeDialog 0;
}] call compile_Global;

["A3PL_Keypad_OnCodeCorrect",
{
	playSound "Orange_PeriodSwitch_Notification";
	
	[] spawn {
		private _display = findDisplay 697356;
		private _maxWait = 10;
		private _waited = 0;
		
		while {isNull _display && _waited < _maxWait} do {
			uiSleep 0.1;
			_display = findDisplay 697356;
			_waited = _waited + 0.1;
		};
		
		if (isNull _display) exitWith {};

		// Vérifier si on est en mode changement de code
		private _changingCode = _display getVariable ["A3PL_Keypad_ChangingCode", false];
		if (_changingCode) then {
			// On est en train de changer le code, l'ancien code est correct
			_display setVariable ["A3PL_Keypad_OldCodeVerified", true];
			_display setVariable ["A3PL_Keypad_Code", ""];
			[("STR_A3PL_Keypad_EnterNewCode" call A3PL_Localize), Color_Green] call A3PL_Notification;
			[] call A3PL_Keypad_UpdateDisplay;
		} else {
			// Mode normal, ouvrir la porte
			closeDialog 0;
			
			// Récupérer l'objet et l'interaction pour ouvrir la porte
			private _object = _display getVariable ["A3PL_Keypad_Object", objNull];
			private _interaction = _display getVariable ["A3PL_Keypad_Interaction", ""];
			
			if (!isNull _object && _interaction != "") then {
				// Ouvrir la porte automatiquement
				[_object, _interaction] call A3PL_Keypad_OpenDoor;
			};
		};
	};
}] call compile_Global;

["A3PL_Keypad_OnCodeIncorrect",
{
	playSound "addItemFailed";
	
	[] spawn {
		private _display = findDisplay 697356;
		private _maxWait = 10;
		private _waited = 0;
		
		while {isNull _display && _waited < _maxWait} do {
			uiSleep 0.1;
			_display = findDisplay 697356;
			_waited = _waited + 0.1;
		};
		
		if (isNull _display) exitWith {};
		
		_display setVariable ["A3PL_Keypad_Code", ""];
		[] call A3PL_Keypad_UpdateDisplay;
	};
}] call compile_Global;

["A3PL_Keypad_OpenFromInteraction",
{
	params [
		["_object", objNull, [objNull]],
		["_interaction", "", [""]],
		["_mode", "", [""]],
		["_callback", "", [""]]
	];

	if (isNull _object) exitWith {
		[("STR_A3PL_Keypad_InvalidObject" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};

	if (_interaction isEqualTo "") exitWith {
		[("STR_A3PL_Keypad_InvalidInteraction" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};

	private _building = typeOf _object;

	// Vérifier si le joueur peut bypass le code avec une keycard
	private _playerJob = player getVariable ["job", ("STR_Common_Job_Unemployed" call A3PL_Localize)];
	private _hasKeycard = ["keycard", 1] call A3PL_Inventory_Has;
	private _doorOpened = false;

	// Check if player has the keypad_bypass trait
	private _traits = player getVariable ["Player_Traits", []];
	private _hasKeypadBypassTrait = "keypad_bypass" in _traits;
	private _hacking = player getVariable ["player_hacking",false];

	// Keypad_bypass trait: bypass keypad code with action and police alert chance
	if (_hasKeypadBypassTrait && !_doorOpened && _hacking) then {
		if (Player_ActionDoing) exitWith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize), Color_Red] call A3PL_Notification;};

		[_object, _interaction] spawn {
			params ["_object", "_interaction"];

			// Chance to alert police (configurable)
			private _alertChance = Keypad_Bypass_Alert_Chance;
			if ((random 100) < _alertChance) then {
				private _namePos = [getPos _object] call A3PL_Housing_PosAddress;
				private _fisd = [("STR_Common_FISD" call A3PL_Localize)] call A3PL_Lib_FactionPlayers;
				[_object, ("STR_A3PL_Keypad_SuspiciousActivity" call A3PL_Localize), "ColorWhite", "A3FL_Markers_911Call"] remoteExec ["A3PL_Lib_CreateMarker", _fisd];
				[("STR_Common_FISD" call A3PL_Localize), ("STR_A3PL_Keypad_SuspiciousActivity" call A3PL_Localize), getPos _object, format[("STR_A3PL_Keypad_SuspiciousActivityReported" call A3PL_Localize), _namePos], ("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch", 2];
			};

			// Start bypass action with QTE
			[("STR_A3PL_Keypad_BypassingKeypad" call A3PL_Localize), Keypad_Bypass_Time] spawn A3PL_Lib_LoadActionQTE;
			waitUntil {Player_ActionDoing};
			while {Player_ActionDoing} do {
				private _interPos = _object selectionPosition player_nameIntersect;
       			private _pos = _object modelToWorldVisual _interPos;
				if ((player distance2D _pos) > 5) exitWith {[("STR_A3PL_Keypad_TooFarFromKeypad" call A3PL_Localize), Color_Red] call A3PL_Notification; Player_ActionInterrupted = true;};
				if ((vehicle player) isNotEqualTo player) exitWith {Player_ActionInterrupted = true;};
				if (player getVariable ["Incapacitated", false]) exitWith {Player_ActionInterrupted = true;};
			};
			if (Player_ActionInterrupted) exitWith {
				[("STR_A3PL_Keypad_BypassCanceled" call A3PL_Localize), Color_Red] call A3PL_Notification;
				player setVariable ["player_hacking", nil, true];
			};

			// Success - open the door
			[_object, _interaction] call A3PL_Keypad_OpenDoor;
			player setVariable ["player_hacking", nil, true];
			[("STR_A3PL_Keypad_BypassSuccess" call A3PL_Localize), Color_Green] call A3PL_Notification;
		};
		_doorOpened = true;
	};

	if (_hasKeycard && !isNil "Keypad_FactionBuildings" && !_doorOpened) then {
		// Vérifier si le bâtiment appartient à une faction
		private _buildingFaction = "";
		{
			private _factionKey = _x select 0;
			private _factionBuildings = _x select 1;
			if (_building IN _factionBuildings) exitWith {
				_buildingFaction = _factionKey;
			};
		} forEach Keypad_FactionBuildings;
		
		if (_buildingFaction != "") then {
			// Vérifier si le job du joueur correspond à la faction du bâtiment
			private _factionJob = "";
			switch (_buildingFaction) do {
				case ("STR_Common_FISD" call A3PL_Localize): { _factionJob = ("STR_Common_FISD" call A3PL_Localize); };
				case ("STR_Common_FIFR" call A3PL_Localize): { _factionJob = ("STR_Common_FIFR" call A3PL_Localize); };
				case ("STR_Common_DOJ" call A3PL_Localize): { _factionJob = ("STR_Common_DOJ" call A3PL_Localize); };
				case ("STR_Common_GOV" call A3PL_Localize): { _factionJob = ("STR_Common_GOV" call A3PL_Localize); };
			};
			[_object, _interaction] call A3PL_Keypad_OpenDoor;
			_doorOpened = true;
		};
	};
	
	// Sinon, ouvrir le dialog du keypad normalement
	if (!_doorOpened) then {
		["", _mode, _callback, _object, _interaction, _building] call A3PL_Keypad_Open;
	};
}] call compile_Global;

["A3PL_Keypad_OpenDoor",
{
	params [
		["_object", objNull, [objNull]],
		["_interaction", "", [""]]
	];
	
	if (isNull _object || _interaction == "") exitWith {};
	
	private _oldObj = Player_ObjIntersect;
	private _oldName = Player_NameIntersect;
	Player_ObjIntersect = _object;
	Player_NameIntersect = _interaction;
	
	Player_KeypadOpen = true;
	
	call A3PL_Intersect_HandleDoors;
	
	Player_ObjIntersect = _oldObj;
	Player_NameIntersect = _oldName;
	
	[] spawn {
		uiSleep 4;
		Player_KeypadOpen = false;
	};
}] call compile_Global;

["A3PL_Keypad_CanUse",
{
	private _object = Player_ObjIntersect;
	private _interaction = Player_NameIntersect;
	
	if (isNull _object || _interaction == "") exitWith {false};
	
	private _building = typeOf _object;
	private _selPos = _object selectionPosition [_interaction, "Memory"];
	if (_selPos isEqualTo [0,0,0] || count _selPos < 3) then {
		_selPos = _object selectionPosition _interaction;
	};
	if (_selPos isEqualTo [0,0,0] || count _selPos < 3) then {
		_selPos = [0, 0, 0];
	};
	
	// Obtenir la position mondiale de l'objet pour créer un ID unique
	private _worldPos = getPosWorld _object;
	private _worldPosX = round((_worldPos select 0) * 10);
	private _worldPosY = round((_worldPos select 1) * 10);
	private _worldPosZ = round((_worldPos select 2) * 10);
	
	private _objectId = "";
	if (count _selPos >= 3) then {
		_objectId = format ["%1_%2_%3_%4_%5_%6_%7_%8", _building, _interaction, round((_selPos select 0) * 100), round((_selPos select 1) * 100), round((_selPos select 2) * 100), _worldPosX, _worldPosY, _worldPosZ];
	} else {
		_objectId = format ["%1_%2_0_0_0_%3_%4_%5", _building, _interaction, _worldPosX, _worldPosY, _worldPosZ];
	};
	
	private _codeExists = false;
	if (isNil "Keypad_GlobalCodes") exitWith {
		private _hasKeypad = Player_ItemClass isEqualTo "keypad";
		_hasKeypad
	};
	
	_codeExists = Keypad_GlobalCodes getOrDefault [_objectId, false];
	
	if (!_codeExists && count _selPos >= 3) then {
		private _objectIdAlt = format ["%1_%2_0_0_0_%3_%4_%5", _building, _interaction, _worldPosX, _worldPosY, _worldPosZ];
		_codeExists = Keypad_GlobalCodes getOrDefault [_objectIdAlt, false];
	};
	
	private _hasKeypad = Player_ItemClass isEqualTo "keypad";
	
	
	if (_codeExists) exitWith {true};
	if (_hasKeypad) exitWith {true};
	false
}] call compile_Global;

// Event handler pour synchroniser Keypad_FactionBuildings depuis le serveur
["A3PL_Keypad_InitEventHandler", {
	"Keypad_FactionBuildings" addPublicVariableEventHandler {
		params ["_varName", "_newValue"];
		Keypad_FactionBuildings = _newValue;
	};
}] call compile_Global;

["A3PL_Keypad_Init", {
	if (isNil "A3PL_Keypad_EventHandlerInitialized") then {
		A3PL_Keypad_EventHandlerInitialized = true;
		[] call A3PL_Keypad_InitEventHandler;
	};
}] call compile_Global;

