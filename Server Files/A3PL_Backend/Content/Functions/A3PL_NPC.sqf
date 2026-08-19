/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_NPC_Start",
{
	disableSerialization;
	private _idNPC = param [0,""];
	private _npcText = nil;
	private _npcOptions = [];
	private _npcActions = [];
	{
		if ((_x#0) == _idNPC) exitwith
		{
			_npcText = _x#1;
			_npcOptions = _x#2;
			_npcActions = _x#3;
		};
	} foreach Config_NPC_Text;
	if (isNil "_npcText") exitwith {};

	createDialog "Dialog_NPC";
	private _display = findDisplay 27;

	A3PL_NPC_Cam = "camera" camCreate (getpos player);
	A3PL_NPC_Cam attachto [player,[0,0.37,1.6]];
	A3PL_NPC_Cam CamSetTarget (ASLToAGL (eyePos player));
	A3PL_NPC_Cam cameraEffect ["INTERNAL", "BACK", "A3PL_NPC_RT"];
	A3PL_NPC_Cam camCommit 0;

	private _ctrl = _display displayCtrl 1100;
	
	private _finalText = if (!isNil "A3PL_NPC_FormattedText" && _idNPC find "_request_amount" >= 0) then {
		A3PL_NPC_FormattedText
	} else {
		_npcText call A3PL_Localize
	};

	_ctrl ctrlSetStructuredText parseText(_finalText);

	private _yCoor = 0.593518;
	{
		_ctrl = _display ctrlCreate ["RscButton",-1];
		_ctrl ctrlSetPosition [0.296823 * safezoneW + safezoneX,(_yCoor * safezoneH + safezoneY),0.407344 * safezoneW,0.022 * safezoneH];
		_ctrl ctrlSetText (_x call A3PL_Localize);
		_ctrl buttonSetAction format ["[] spawn {%1};",("closeDialog 0; sleep 0.01;" + (_npcActions#_forEachIndex))];
		_ctrl ctrlCommit 0;
		_yCoor = _yCoor + 0.022;
	} foreach _npcOptions;
}] call compile_Global;

["A3PL_NPC_Start_Custom",
{
	disableSerialization;
	private _customText = param [0,""];
	if (_customText isEqualTo "") exitWith {};
	
	createDialog "Dialog_NPC";
	private _display = findDisplay 27;
	
	A3PL_NPC_Cam = "camera" camCreate (getpos player);
	A3PL_NPC_Cam attachto [player,[0,0.37,1.6]];
	A3PL_NPC_Cam CamSetTarget (ASLToAGL (eyePos player));
	A3PL_NPC_Cam cameraEffect ["INTERNAL", "BACK", "A3PL_NPC_RT"];
	A3PL_NPC_Cam camCommit 0;
	
	private _ctrl = _display displayCtrl 1100;
	_ctrl ctrlSetStructuredText parseText(_customText);
}] call compile_Global;

["A3PL_NPC_Street_Start",
{
	disableSerialization;
	private _dialogID = param [0, ""];
	private _npc = param [1, objNull];
	
	if (isNull _npc) then {
		_npc = if (!isNil "A3PL_NPC_CurrentNPC" && !isNull A3PL_NPC_CurrentNPC) then {A3PL_NPC_CurrentNPC} else {player_objintersect};
	};
	
	if (!isNull _npc) then {
		A3PL_NPC_CurrentNPC = _npc;
	};
	
	if (_dialogID isEqualTo "" || isNull _npc) exitWith {};
	
	private _dialogConfig = nil;
	{
		if ((_x#0) == _dialogID) exitWith {
			_dialogConfig = _x;
		};
	} foreach Config_NPC_Street_Dialogs;
	
	if (isNil "_dialogConfig") exitWith {};
	
	private _textKey = (_dialogConfig#1) call A3PL_Localize;
	private _options = _dialogConfig#2;
	private _nextDialogs = _dialogConfig#3;
	private _initFunction = _dialogConfig#4;
	private _type = _dialogConfig#5;
	private _markUsedOnRefusal = _dialogConfig#6;
	
	if (_initFunction != "" && isNil {_npc getVariable format["A3PL_NPC_%1Initialized", _dialogID]}) then {
		call compile (_initFunction);
		_npc setVariable [format["A3PL_NPC_%1Initialized", _dialogID], true, false];
	};
	
	private _npcText = "";
	switch (_type) do {
		case "quantity_amount": {
			if (_dialogID == "weed") then {
				private _weedItem = _npc getVariable ["A3PL_NPC_WeedItem", "weed_bag_5g"];
				private _pricePerUnit = _npc getVariable ["A3PL_NPC_WeedPricePerUnit", 0];
				if (_pricePerUnit == 0) then {
					switch (_weedItem) do {
						case "weed_bag_5g": { _pricePerUnit = NPC_Weed_Price_weed_bag_5g; };
						case "weed_bag_10g": { _pricePerUnit = NPC_Weed_Price_weed_bag_10g; };
						case "weed_bag_25g": { _pricePerUnit = NPC_Weed_Price_weed_bag_25g; };
						case "weed_bag_50g": { _pricePerUnit = NPC_Weed_Price_weed_bag_50g; };
						case "weed_bag_100g": { _pricePerUnit = NPC_Weed_Price_weed_bag_100g; };
					};
				};
				private _maxQuantity = [_npc, "weed", player] call A3PL_NPC_CalculateQuantity;
				private _weedItemName = [_weedItem, "name"] call A3PL_Config_GetItem;
				_npcText = format[_textKey, _maxQuantity, _weedItemName, _pricePerUnit];
			} else {
				if (_dialogID == "cocaine") then {
					private _cocaineItem = _npc getVariable ["A3PL_NPC_CocaineItem", "cocaine"];
					private _pricePerUnit = switch (_cocaineItem) do {
						case "cocaine": { NPC_Cocaine_Price_cocaine };
						case "cocaine_brick": { NPC_Cocaine_Price_cocainebrick };
						default { NPC_Cocaine_Price_cocaine };
					};
					private _maxQuantity = [_npc, "cocaine", player] call A3PL_NPC_CalculateQuantity;
					private _cocaineItemName = [_cocaineItem, "name"] call A3PL_Config_GetItem;
					_npcText = format[_textKey, _maxQuantity, _cocaineItemName, _pricePerUnit];
				} else {
					if (_dialogID == "moonshine") then {
						private _moonshineItem = _npc getVariable ["A3PL_NPC_MoonshineItem", "jug_moonshine"];
						private _pricePerUnit = _npc getVariable ["A3PL_NPC_MoonshinePricePerUnit", 0];
						if (_pricePerUnit == 0) then {
							_pricePerUnit = NPC_Moonshine_Price_jug_moonshine;
						};
						private _maxQuantity = [_npc, "moonshine", player] call A3PL_NPC_CalculateQuantity;
						private _moonshineItemName = [_moonshineItem, "name"] call A3PL_Config_GetItem;
						_npcText = format[_textKey, _maxQuantity, _moonshineItemName, _pricePerUnit];
					} else {
						if (_dialogID == "shrooms") then {
							private _shroomsItem = _npc getVariable ["A3PL_NPC_ShroomsItem", "shrooms"];
							private _pricePerUnit = NPC_Shrooms_Price_shrooms;
							private _maxQuantity = [_npc, "shrooms", player] call A3PL_NPC_CalculateQuantity;
							private _shroomsItemName = [_shroomsItem, "name"] call A3PL_Config_GetItem;
							_npcText = format[_textKey, _maxQuantity, _shroomsItemName, _pricePerUnit];
						} else {
							private _quantityVar = format["A3PL_NPC_%1Quantity", _dialogID];
							private _amountVar = format["A3PL_NPC_%1Amount", _dialogID];
							private _quantity = _npc getVariable [_quantityVar, 1];
							private _amount = _npc getVariable [_amountVar, 1000];
							_npcText = format[_textKey, _quantity, _amount];
						};
					};
				};
			};
		};
		case "amount": {
			private _amountVar = format["A3PL_NPC_%1Amount", _dialogID];
			private _amount = _npc getVariable [_amountVar, 1000];
			_npcText = format[_textKey, _amount];
		};
		default {
			_npcText = _textKey;
		};
	};
	
	private _npcActions = [];
	{
		private _nextDialog = _x;
		if (_nextDialog == "") then {
			_npcActions pushBack "";
		} else {
			if (_nextDialog find "_accept" >= 0 || _nextDialog find "_yes" >= 0) then {
				private _actionType = _nextDialog;
				_npcActions pushBack format["['%1'] call A3PL_NPC_Street_Action;", _actionType];
			} else {
				if (_nextDialog == "leave_ok") then {
					_npcActions pushBack format["[A3PL_NPC_CurrentNPC, '%1'] call A3PL_NPC_MarkDialogUsed;", _markUsedOnRefusal];
				} else {
					if (_nextDialog == "hooker_work_action") then {
						_npcActions pushBack "[] call A3PL_Hooker_WorkForMe;";
					} else {
						if (_nextDialog == "hooker_home_action") then {
							_npcActions pushBack "[] call A3PL_Hooker_GoHome;";
						} else {
					if (_nextDialog == "hooker_car_action") then {
						_npcActions pushBack "[] call A3PL_Hooker_InCar;";
					} else {
						if (_nextDialog == "sex_yes") then {
							_npcActions pushBack "['sex_yes'] call A3PL_NPC_Street_Action;";
						} else {
							private _markUsed = "";
							if (_nextDialog find "_no" >= 0 && _markUsedOnRefusal != "") then {
								_markUsed = format["[A3PL_NPC_CurrentNPC, '%1'] call A3PL_NPC_MarkDialogUsed; A3PL_NPC_CurrentNPC setVariable ['A3PL_NPC_CooldownEnd', serverTime + 1800, true]; ", _markUsedOnRefusal];
							};
							_npcActions pushBack format["%1['%2', A3PL_NPC_CurrentNPC] call A3PL_NPC_Street_Start;", _markUsed, _nextDialog];
						};
					};
						};
					};
				};
			};
		};
	} foreach _nextDialogs;
	
	private _npcOptions = _options;
	
	if (_npcText isEqualTo "") exitWith {};
	
	createDialog "Dialog_NPC";
	private _display = findDisplay 27;
	
	A3PL_NPC_Cam = "camera" camCreate (getpos player);
	A3PL_NPC_Cam attachto [player,[0,0.37,1.6]];
	A3PL_NPC_Cam CamSetTarget (ASLToAGL (eyePos player));
	A3PL_NPC_Cam cameraEffect ["INTERNAL", "BACK", "A3PL_NPC_RT"];
	A3PL_NPC_Cam camCommit 0;
	
	private _ctrl = _display displayCtrl 1100;
	private _npcName = name _npc;
	private _npcConfigID = _npc getVariable ["A3PL_NPC_ID_Config", _npc getVariable ["A3PL_NPC_ID", ""]];
	private _charID = player getVariable ["character_id", ""];
	
	private _reputationText = "";
	if (_charID != "" && _npcConfigID != "") then {

		private _repVar = format["A3PL_NPC_Rep_%1_%2", _charID, _npcConfigID];
		private _reputation = player getVariable [_repVar, 0];
		diag_log format["[A3PL_NPC_Start] Reading reputation for %1: %2 (var: %3)", _npcConfigID, _reputation, _repVar];

		if (_reputation == 0 && !(player getVariable [format["A3PL_NPC_Rep_Loading_%1_%2", _charID, _npcConfigID], false])) then {
			player setVariable [format["A3PL_NPC_Rep_Loading_%1_%2", _charID, _npcConfigID], true, false];
			diag_log format["[A3PL_NPC_Start] Reputation is 0, requesting from server for %1", _npcConfigID];
			[(player getVariable ["character_id", ""]), _npcConfigID, player, _npcName] remoteExec ["Server_NPC_GetReputation", 2];
		};

		_reputationText = format[("STR_A3PL_NPC_ReputationDisplay" call A3PL_Localize), _reputation];
	};

	A3PL_NPC_CurrentText = _npcText;
	_ctrl ctrlSetStructuredText parseText(_npcText + _reputationText);
	
	private _yCoor = 0.566;
	{
		_ctrl = _display ctrlCreate ["RscButton",-1];
		_ctrl ctrlSetPosition [0.453594 * safezoneW + safezoneX,(_yCoor * safezoneH + safezoneY),0.221719 * safezoneW,0.022 * safezoneH];
		_ctrl ctrlSetText (_x call A3PL_Localize);
		_ctrl buttonSetAction format ["[] spawn {%1};",("closeDialog 0; sleep 0.01;" + (_npcActions#_forEachIndex))];
		_ctrl ctrlCommit 0;
		_yCoor = _yCoor + 0.022;
	} foreach _npcOptions;

	private _playerFaction = player getVariable ["faction", ""];
	private _isFISD = (_playerFaction == ("STR_Common_FISD" call A3PL_Localize));
	private _isDrugRequest = (_dialogID in ["cocaine", "weed", "moonshine", "shrooms"]);
	
	if (_isFISD && _isDrugRequest) then {
		_ctrl = _display ctrlCreate ["RscButton",-1];
		_ctrl ctrlSetPosition [0.453594 * safezoneW + safezoneX,(_yCoor * safezoneH + safezoneY),0.221719 * safezoneW,0.022 * safezoneH];
		_ctrl ctrlSetText ("STR_NPC_AskInfo" call A3PL_Localize);
		_ctrl buttonSetAction format ["[] spawn {closeDialog 0; sleep 0.01; ['%1', A3PL_NPC_CurrentNPC] call A3PL_NPC_Street_AskInfo;};", _dialogID];
		_ctrl ctrlCommit 0;
	};
}] call compile_Global;

["A3PL_NPC_SetReputation",
{
	private _reputation = param [0, 0];
	private _charID = param [1, ""];
	private _npcConfigID = param [2, ""];

	diag_log format["[A3PL_NPC_SetReputation] Setting reputation: %1 for charID: %2, npcID: %3", _reputation, _charID, _npcConfigID];

	if (_charID != "" && _npcConfigID != "") then {
		private _repVar = format["A3PL_NPC_Rep_%1_%2", _charID, _npcConfigID];
		player setVariable [_repVar, _reputation, false];
		player setVariable [format["A3PL_NPC_Rep_Loading_%1_%2", _charID, _npcConfigID], false, false];
		diag_log format["[A3PL_NPC_SetReputation] Variable %1 set to %2", _repVar, player getVariable [_repVar, -999]];

		if (!isNull A3PL_NPC_CurrentNPC) then {
			private _currentNPCConfigID = A3PL_NPC_CurrentNPC getVariable ["A3PL_NPC_ID_Config", A3PL_NPC_CurrentNPC getVariable ["A3PL_NPC_ID", ""]];
			if (_currentNPCConfigID == _npcConfigID) then {
				private _display = findDisplay 27;
				if (!isNull _display && !isNil "A3PL_NPC_CurrentText") then {
					private _ctrl = _display displayCtrl 1100;
					private _reputationText = format[("STR_A3PL_NPC_ReputationDisplay" call A3PL_Localize), _reputation];
					_ctrl ctrlSetStructuredText parseText(A3PL_NPC_CurrentText + _reputationText);
				};
			};
		};
	};
}] call compile_Global;

["A3PL_NPC_Street_AskInfo",
{
	private _dialogID = param [0, ""];
	private _npc = param [1, objNull];
	
	if (isNull _npc) exitWith {};
	
	private _playerFaction = player getVariable ["job", ""];
	if (_playerFaction != ("STR_Common_FISD" call A3PL_Localize)) exitWith {
		[("STR_A3PL_NPC_NotFISD" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	
	private _drugSeller = _npc getVariable ["A3PL_NPC_DrugSeller", ""];
	if (_drugSeller == "") exitWith {
		[("STR_A3PL_NPC_NoInfoAvailable" call A3PL_Localize), Color_Yellow] call A3PL_Notification;
	};
	
	private _chance = NPC_Info_Chance;
	if (isNil "_chance") then { _chance = 30; };
	
	private _randomChance = random 100;
	
	if (_randomChance <= _chance) then {
		private _drugType = _npc getVariable ["A3PL_NPC_DrugSold", ""];
		private _drugTypeName = "";
		switch (_drugType) do {
			case "cocaine": { _drugTypeName = ("STR_NPC_Cocaine" call A3PL_Localize); };
			case "weed": { _drugTypeName = ("STR_NPC_Weed" call A3PL_Localize); };
			case "moonshine": { _drugTypeName = ("STR_NPC_Moonshine" call A3PL_Localize); };
		};
		
		private _firstName = "";
		if (_drugSeller != "") then {
			private _nameParts = _drugSeller splitString " ";
			if (count _nameParts > 0) then {
				_firstName = _nameParts select 0;
			} else {
				_firstName = _drugSeller;
			};
		};
		
		[format[("STR_A3PL_NPC_InfoGiven" call A3PL_Localize), _firstName, _drugTypeName], Color_Green] call A3PL_Notification;
	} else {
		[("STR_A3PL_NPC_InfoRefused" call A3PL_Localize), Color_Yellow] call A3PL_Notification;
	};
}] call compile_Global;

["A3PL_NPC_Street_Action",
{
	private _actionType = param [0, ""];
	private _npc = if (!isNil "A3PL_NPC_CurrentNPC" && !isNull A3PL_NPC_CurrentNPC) then {A3PL_NPC_CurrentNPC} else {player_objintersect};
	
	if (isNull _npc) exitWith {};
	
	switch (_actionType) do {
		case "sex_yes": {
			private _dialogID = "npc_sex_request";
			[_npc, _dialogID] call A3PL_NPC_MarkDialogUsed;
			_npc setVariable ["A3PL_NPC_CooldownEnd", serverTime + 1800, true];
			[_npc] call A3PL_NPC_FollowPlayer;
		};
		case "cocaine_yes": {
			private _cocaineItem = _npc getVariable ["A3PL_NPC_CocaineItem", "cocaine"];
			private _maxQuantity = _npc getVariable ["A3PL_NPC_cocaineMaxQuantity", 1];
			// Vérifier si le joueur a au moins 1 item
			if (!([_cocaineItem, 1] call A3PL_Inventory_Has)) exitWith {
				private _itemName = [_cocaineItem, "name"] call A3PL_Config_GetItem;
				private _errorText = format[("STR_A3PL_NPC_NoDrugDialog" call A3PL_Localize), _itemName];
				[_errorText] call A3PL_NPC_Start_Custom;
			};
			// Calculer combien le joueur a (jusqu'au max)
			private _playerHas = [_cocaineItem] call A3PL_Inventory_Return;
			private _quantity = _playerHas min _maxQuantity;
			_npc setVariable ["A3PL_NPC_cocaineSellQuantity", _quantity, true];
			["cocaine_accept"] call A3PL_NPC_Street_Action;
		};
		case "cocaine_accept": {
			private _cocaineItem = _npc getVariable ["A3PL_NPC_CocaineItem", "cocaine"];
			private _quantity = _npc getVariable ["A3PL_NPC_cocaineSellQuantity", 1];
			private _pricePerUnit = switch (_cocaineItem) do {
				case "cocaine": { NPC_Cocaine_Price_cocaine };
				case "cocaine_brick": { NPC_Cocaine_Price_cocainebrick };
				default { NPC_Cocaine_Price_cocaine };
			};
			private _totalAmount = _quantity * _pricePerUnit;
			private _dialogID = "npc_cocaine_request";
			[_npc, _dialogID] call A3PL_NPC_MarkDialogUsed;
			_npc setVariable ["A3PL_NPC_cocaineMaxQuantity", -1, true];
			_npc setVariable ["A3PL_NPC_cocaineSellQuantity", -1, true];
			_npc setVariable ["A3PL_NPC_CooldownEnd", serverTime + 1800, true];
			[player, _cocaineItem, -(_quantity)] remoteExec ["Server_Inventory_Add", 2];
			[player, 'Player_Cash', (player getVariable ["Player_Cash", 0]) + _totalAmount] remoteExec ['Server_Core_ChangeVar', 2];
			private _playerGoggles = goggles player;
			private _isMasked = false;
			if (_playerGoggles != "") then {
				if (!isNil "GogglesList") then {
					_isMasked = _playerGoggles in GogglesList;
				};
			};
			if (_isMasked) then {
				_npc setVariable ["A3PL_NPC_DrugSeller", "", true];
			} else {
				_npc setVariable ["A3PL_NPC_DrugSeller", (player getVariable ["name","unknown"]), true];
			};
			_npc setVariable ["A3PL_NPC_DrugSold", "cocaine", true];
			private _npcConfigID = _npc getVariable ["A3PL_NPC_ID_Config", _npc getVariable ["A3PL_NPC_ID", ""]];
			[(player getVariable ["character_id", ""]), _npcConfigID, NPC_Reputation_ReputationPerSale, player] remoteExec ["Server_NPC_AddReputation", 2];
			private _itemName = [_cocaineItem, "name"] call A3PL_Config_GetItem;
			private _successText = format[("STR_A3PL_NPC_SaleSuccess" call A3PL_Localize), _totalAmount, NPC_Reputation_ReputationPerSale];
			[_successText] call A3PL_NPC_Start_Custom;
			[format[("STR_A3PL_NPC_CocaineSold" call A3PL_Localize), _quantity, _itemName, _totalAmount], Color_Green] call A3PL_Notification;
		};
		case "weed_yes": {
			private _weedItem = _npc getVariable ["A3PL_NPC_WeedItem", "weed_bag_5g"];
			private _maxQuantity = _npc getVariable ["A3PL_NPC_weedMaxQuantity", 1];
			// Vérifier si le joueur a au moins 1 item
			if (!([_weedItem, 1] call A3PL_Inventory_Has)) exitWith {
				private _itemName = [_weedItem, "name"] call A3PL_Config_GetItem;
				private _errorText = format[("STR_A3PL_NPC_NoDrugDialog" call A3PL_Localize), _itemName];
				[_errorText] call A3PL_NPC_Start_Custom;
			};
			// Calculer combien le joueur a (jusqu'au max)
			private _playerHas = [_weedItem] call A3PL_Inventory_Return;
			private _quantity = _playerHas min _maxQuantity;
			_npc setVariable ["A3PL_NPC_weedSellQuantity", _quantity, true];
			["weed_accept"] call A3PL_NPC_Street_Action;
		};
		case "weed_accept": {
			private _weedItem = _npc getVariable ["A3PL_NPC_WeedItem", "weed_bag_5g"];
			private _quantity = _npc getVariable ["A3PL_NPC_weedSellQuantity", 1];
			private _pricePerUnit = 0;
			switch (_weedItem) do {
				case "weed_bag_5g": { _pricePerUnit = NPC_Weed_Price_weed_bag_5g; };
				case "weed_bag_10g": { _pricePerUnit = NPC_Weed_Price_weed_bag_10g; };
				case "weed_bag_25g": { _pricePerUnit = NPC_Weed_Price_weed_bag_25g; };
				case "weed_bag_50g": { _pricePerUnit = NPC_Weed_Price_weed_bag_50g; };
				case "weed_bag_100g": { _pricePerUnit = NPC_Weed_Price_weed_bag_100g; };
			};
			private _totalAmount = _quantity * _pricePerUnit;
			private _dialogID = "npc_weed_request";
			[_npc, _dialogID] call A3PL_NPC_MarkDialogUsed;
			_npc setVariable ["A3PL_NPC_CooldownEnd", serverTime + 1800, true];
			[player, _weedItem, -(_quantity)] remoteExec ["Server_Inventory_Add", 2];
			[player, 'Player_Cash', (player getVariable ["Player_Cash", 0]) + _totalAmount] remoteExec ['Server_Core_ChangeVar', 2];
			private _playerGoggles = goggles player;
			private _isMasked = false;
			if (_playerGoggles != "") then {
				if (!isNil "GogglesList") then {
					_isMasked = _playerGoggles in GogglesList;
				};
			};
			if (_isMasked) then {
				_npc setVariable ["A3PL_NPC_DrugSeller", "", true];
			} else {
				_npc setVariable ["A3PL_NPC_DrugSeller", (player getVariable ["name","unknown"]), true];
			};
			_npc setVariable ["A3PL_NPC_DrugSold", "weed", true];
			_npc setVariable ["A3PL_NPC_weedMaxQuantity", -1, true];
			_npc setVariable ["A3PL_NPC_weedSellQuantity", -1, true];
			private _npcConfigID = _npc getVariable ["A3PL_NPC_ID_Config", _npc getVariable ["A3PL_NPC_ID", ""]];
			[(player getVariable ["character_id", ""]), _npcConfigID, NPC_Reputation_ReputationPerSale, player] remoteExec ["Server_NPC_AddReputation", 2];
			private _itemName = [_weedItem, "name"] call A3PL_Config_GetItem;
			private _successText = format[("STR_A3PL_NPC_SaleSuccess" call A3PL_Localize), _totalAmount, NPC_Reputation_ReputationPerSale];
			[_successText] call A3PL_NPC_Start_Custom;
			[format[("STR_A3PL_NPC_WeedSoldItem" call A3PL_Localize), _quantity, _itemName, _totalAmount], Color_Green] call A3PL_Notification;
		};
		case "moonshine_yes": {
			private _moonshineItem = _npc getVariable ["A3PL_NPC_MoonshineItem", "jug_moonshine"];
			private _maxQuantity = _npc getVariable ["A3PL_NPC_moonshineMaxQuantity", 1];
			// Vérifier si le joueur a au moins 1 item
			if (!([_moonshineItem, 1] call A3PL_Inventory_Has)) exitWith {
				private _itemName = [_moonshineItem, "name"] call A3PL_Config_GetItem;
				private _errorText = format[("STR_A3PL_NPC_NoDrugDialog" call A3PL_Localize), _itemName];
				[_errorText] call A3PL_NPC_Start_Custom;
			};
			// Calculer combien le joueur a (jusqu'au max)
			private _playerHas = [_moonshineItem] call A3PL_Inventory_Return;
			private _quantity = _playerHas min _maxQuantity;
			_npc setVariable ["A3PL_NPC_moonshineSellQuantity", _quantity, true];
			["moonshine_accept"] call A3PL_NPC_Street_Action;
		};
		case "moonshine_accept": {
			private _moonshineItem = _npc getVariable ["A3PL_NPC_MoonshineItem", "jug_moonshine"];
			private _quantity = _npc getVariable ["A3PL_NPC_moonshineSellQuantity", 1];
			private _pricePerUnit = NPC_Moonshine_Price_jug_moonshine;
			private _totalAmount = _quantity * _pricePerUnit;
			private _dialogID = "npc_moonshine_request";
			[_npc, _dialogID] call A3PL_NPC_MarkDialogUsed;
			_npc setVariable ["A3PL_NPC_CooldownEnd", serverTime + 1800, true];
			[player, _moonshineItem, -(_quantity)] remoteExec ["Server_Inventory_Add", 2];
			[player, 'Player_Cash', (player getVariable ["Player_Cash", 0]) + _totalAmount] remoteExec ['Server_Core_ChangeVar', 2];
			private _playerGoggles = goggles player;
			private _isMasked = false;
			if (_playerGoggles != "") then {
				if (!isNil "GogglesList") then {
					_isMasked = _playerGoggles in GogglesList;
				};
			};
			if (_isMasked) then {
				_npc setVariable ["A3PL_NPC_DrugSeller", "", true];
			} else {
				_npc setVariable ["A3PL_NPC_DrugSeller", (player getVariable ["name","unknown"]), true];
			};
			_npc setVariable ["A3PL_NPC_DrugSold", "moonshine", true];
			_npc setVariable ["A3PL_NPC_moonshineMaxQuantity", -1, true];
			_npc setVariable ["A3PL_NPC_moonshineSellQuantity", -1, true];
			private _npcConfigID = _npc getVariable ["A3PL_NPC_ID_Config", _npc getVariable ["A3PL_NPC_ID", ""]];
			[(player getVariable ["character_id", ""]), _npcConfigID, NPC_Reputation_ReputationPerSale, player] remoteExec ["Server_NPC_AddReputation", 2];
			private _itemName = [_moonshineItem, "name"] call A3PL_Config_GetItem;
			private _successText = format[("STR_A3PL_NPC_SaleSuccess" call A3PL_Localize), _totalAmount, NPC_Reputation_ReputationPerSale];
			[_successText] call A3PL_NPC_Start_Custom;
			[format[("STR_A3PL_NPC_MoonshineSold" call A3PL_Localize), _quantity, _itemName, _totalAmount], Color_Green] call A3PL_Notification;
		};
		case "shrooms_yes": {
			private _shroomsItem = _npc getVariable ["A3PL_NPC_ShroomsItem", "shrooms"];
			private _maxQuantity = _npc getVariable ["A3PL_NPC_shroomsMaxQuantity", 1];
			// Vérifier si le joueur a au moins 1 item
			if (!([_shroomsItem, 1] call A3PL_Inventory_Has)) exitWith {
				private _itemName = [_shroomsItem, "name"] call A3PL_Config_GetItem;
				private _errorText = format[("STR_A3PL_NPC_NoDrugDialog" call A3PL_Localize), _itemName];
				[_errorText] call A3PL_NPC_Start_Custom;
			};
			// Calculer combien le joueur a (jusqu'au max)
			private _playerHas = [_shroomsItem] call A3PL_Inventory_Return;
			private _quantity = _playerHas min _maxQuantity;
			_npc setVariable ["A3PL_NPC_shroomsSellQuantity", _quantity, true];
			["shrooms_accept"] call A3PL_NPC_Street_Action;
		};
		case "shrooms_accept": {
			private _shroomsItem = _npc getVariable ["A3PL_NPC_ShroomsItem", "shrooms"];
			private _quantity = _npc getVariable ["A3PL_NPC_shroomsSellQuantity", 1];
			private _pricePerUnit = NPC_Shrooms_Price_shrooms;
			private _totalAmount = _quantity * _pricePerUnit;
			private _dialogID = "npc_shrooms_request";
			[_npc, _dialogID] call A3PL_NPC_MarkDialogUsed;
			_npc setVariable ["A3PL_NPC_CooldownEnd", serverTime + 1800, true];
			[player, _shroomsItem, -(_quantity)] remoteExec ["Server_Inventory_Add", 2];
			[player, 'Player_Cash', (player getVariable ["Player_Cash", 0]) + _totalAmount] remoteExec ['Server_Core_ChangeVar', 2];
			private _playerGoggles = goggles player;
			private _isMasked = false;
			if (_playerGoggles != "") then {
				if (!isNil "GogglesList") then {
					_isMasked = _playerGoggles in GogglesList;
				};
			};
			if (_isMasked) then {
				_npc setVariable ["A3PL_NPC_DrugSeller", "", true];
			} else {
				_npc setVariable ["A3PL_NPC_DrugSeller", (player getVariable ["name","unknown"]), true];
			};
			_npc setVariable ["A3PL_NPC_DrugSold", "shrooms", true];
			_npc setVariable ["A3PL_NPC_shroomsMaxQuantity", -1, true];
			_npc setVariable ["A3PL_NPC_shroomsSellQuantity", -1, true];
			private _npcConfigID = _npc getVariable ["A3PL_NPC_ID_Config", _npc getVariable ["A3PL_NPC_ID", ""]];
			[(player getVariable ["character_id", ""]), _npcConfigID, NPC_Reputation_ReputationPerSale, player] remoteExec ["Server_NPC_AddReputation", 2];
			private _itemName = [_shroomsItem, "name"] call A3PL_Config_GetItem;
			private _successText = format[("STR_A3PL_NPC_SaleSuccess" call A3PL_Localize), _totalAmount, NPC_Reputation_ReputationPerSale];
			[_successText] call A3PL_NPC_Start_Custom;
			[format[("STR_A3PL_NPC_ShroomsSold" call A3PL_Localize), _quantity, _itemName, _totalAmount], Color_Green] call A3PL_Notification;
		};
		case "money_yes": {
			private _amount = _npc getVariable ["A3PL_NPC_MoneyAmount", 1000];
			private _currentMoney = player getVariable ["Player_Cash", 0];
			if (_currentMoney < _amount) exitWith {
				private _errorText = format[("STR_A3PL_NPC_NotEnoughMoneyDialog" call A3PL_Localize), _amount];
				[_errorText] call A3PL_NPC_Start_Custom;
			};
			["money_accept"] call A3PL_NPC_Street_Action;
		};
		case "money_accept": {
			private _amount = _npc getVariable ["A3PL_NPC_MoneyAmount", 1000];
			private _dialogID = "npc_money_request";
			[_npc, _dialogID] call A3PL_NPC_MarkDialogUsed;
			_npc setVariable ["A3PL_NPC_CooldownEnd", serverTime + 1800, true];
			private _currentMoney = player getVariable ["Player_Cash", 0];
			[player, 'Player_Cash', _currentMoney - _amount] remoteExec ['Server_Core_ChangeVar', 2];
			private _successText = format[("STR_A3PL_NPC_MoneyGivenDialog" call A3PL_Localize), _amount];
			[_successText] call A3PL_NPC_Start_Custom;
			[format[("STR_A3PL_NPC_MoneyGiven" call A3PL_Localize), _amount], Color_Yellow] call A3PL_Notification;
		};
	};
}] call compile_Global;

["A3PL_NPC_FollowPlayer",
{
	private _npc = param [0, objNull];
	if (isNull _npc) exitWith {};
	
	if (!isNil "Player_NPC_SexClient" && {!isNull Player_NPC_SexClient}) exitWith {
		[("STR_A3PL_NPC_AlreadyHaveOne" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	
	private _npcType = typeOf _npc;
	private _npcName = name _npc;
	private _npcVoice = speaker _npc;
	private _npcUniform = uniform _npc;
	private _npcHeadgear = headgear _npc;
	private _npcGoggles = goggles _npc;
	private _npcVest = vest _npc;
	private _npcBackpack = backpack _npc;
	private _npcID = _npc getVariable ["A3PL_NPC_ID_Config", ""];
	
	[_npc] call A3PL_NPC_Delete;
	
	uiSleep 0.5;
	
	private _group = createGroup [civilian, true];
	private _sexClient = _group createUnit [_npcType, getPosATL player, [], 5, "NONE"];
	
	if (isNull _sexClient) exitWith {
		[("STR_A3PL_NPC_CreationFailed" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	
	_sexClient setName _npcName;
	if (_npcVoice != "") then {_sexClient setSpeaker _npcVoice;};
	if (_npcUniform != "") then {_sexClient forceAddUniform _npcUniform;};
	if (_npcHeadgear != "") then {_sexClient addHeadgear _npcHeadgear;};
	if (_npcGoggles != "") then {_sexClient addGoggles _npcGoggles;};
	if (_npcVest != "") then {_sexClient addVest _npcVest;};
	if (_npcBackpack != "") then {_sexClient addBackpack _npcBackpack;};
	
	_sexClient setVariable ["A3PL_NPC_SexClient_Active", true, true];
	_sexClient setVariable ["A3PL_NPC_FollowingPlayer", player, true];
	_sexClient setVariable ["A3PL_NPC_IsStopped", false, true];
	_sexClient setVariable ["A3PL_NPC_IsArrested", false, true];
	_sexClient setVariable ["A3PL_NPC_ArrestedBy", nil, true];
	_sexClient setVariable ["A3PL_NPC_ID_Config", _npcID, true];
	_sexClient allowDamage false;
	_sexClient disableAI "FSM";
	_sexClient disableAI "AUTOTARGET";
	_sexClient disableAI "TARGET";
	_sexClient setBehaviour "CARELESS";
	_sexClient setCombatMode "BLUE";
	
	Player_NPC_SexClient = _sexClient;
	Player_NPC_SexClient_Owner = player;
	Player_NPC_SexClient_IsStopped = false;
	Player_NPC_SexClient_IsArrested = false;
	
	[] spawn A3PL_NPC_SexClient_Follow;
	
	[("STR_A3PL_NPC_StartedFollowing" call A3PL_Localize), Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_NPC_SexClient_Follow",
{
	if (isNil "Player_NPC_SexClient" || {isNull Player_NPC_SexClient}) exitWith {};
	
	private _sexClient = Player_NPC_SexClient;
	private _owner = Player_NPC_SexClient_Owner;
	
	_sexClient setVariable ["A3PL_NPC_IsPatrolling", false, true];
	_sexClient setVariable ["A3PL_NPC_PatrolPath", [], true];
	doStop _sexClient;
	
	[_sexClient] remoteExec ["Server_NPC_EnableHookerMove", 2];
	
	uiSleep 0.8;
	
	_sexClient enableAI "MOVE";
	_sexClient enableAI "FSM";
	_sexClient enableSimulation true;
	_sexClient setUnitPos "UP";
	_sexClient setSpeedMode "LIMITED";
	_sexClient forceSpeed 1.0;
	
	private _group = group _sexClient;
	_group setBehaviour "CARELESS";
	_group setCombatMode "BLUE";
	_group setSpeedMode "LIMITED";
	
	[_group, owner _owner] remoteExec ["setGroupOwner", 2];
	
	uiSleep 0.2;
	
	_group setGroupOwner (owner _owner);
	
	private _targetPos = getPosATL _owner;
	[_sexClient, _targetPos] remoteExec ["Server_NPC_HookerMoveTo", 2];
	_sexClient doMove _targetPos;
	_sexClient commandMove _targetPos;
	_sexClient moveTo _targetPos;
	
	uiSleep 0.5;
	
	while {!isNull _sexClient && {alive _sexClient} && {!Player_NPC_SexClient_IsStopped} && {!Player_NPC_SexClient_IsArrested} && {(_sexClient getVariable ["A3PL_NPC_FollowingPlayer", objNull]) == _owner}} do {
		if (isNull _owner || {!alive _owner}) exitWith {
			[] spawn A3PL_NPC_SexClient_Release;
		};
		
		_sexClient enableAI "MOVE";
		_sexClient enableAI "FSM";
		_sexClient enableSimulation true;
		_sexClient setUnitPos "UP";
		_sexClient forceSpeed 1.0;
		
		if (vehicle _owner != _owner) then {
			private _veh = vehicle _owner;
			
			if (vehicle _sexClient == _sexClient) then {
				_sexClient assignAsCargo _veh;
				_sexClient moveInCargo _veh;
				_sexClient doMove (getPosATL _veh);
			};
		} else {
			if (vehicle _sexClient != _sexClient) then {
				_sexClient action ["Eject", vehicle _sexClient];
			};
			
			private _distance = _sexClient distance _owner;
			_targetPos = getPosATL _owner;
			
			private _nearMotel = false;
			{
				if ((typeOf _x) == "Land_A3PL_Motel") then {
					if ((_sexClient distance _x) < 50) then {
						_nearMotel = true;
					};
				};
			} forEach nearestObjects [_sexClient, ["House"], 50];
			
			if (_nearMotel) then {
				private _nearHooker = objNull;
				{
					if (_x getVariable ["A3PL_NPC_Hooker_Active", false]) then {
						if ((_sexClient distance _x) < 3) then {
							_nearHooker = _x;
						};
					};
				} forEach nearestObjects [_sexClient, ["Man"], 5];
				
				if (!isNull _nearHooker) then {
					doStop _sexClient;

					private _alreadyLinked = _nearHooker getVariable ["A3PL_NPC_SexClient", objNull];
					if (isNull _alreadyLinked) then {
						_nearHooker setVariable ["A3PL_NPC_SexClient", _sexClient, true];
						[("STR_A3PL_NPC_SexClientReady" call A3PL_Localize), Color_Green] call A3PL_Notification;
					};
				} else {
					if (_distance > 0.8) then {
						_sexClient doMove _targetPos;
						_sexClient commandMove _targetPos;
						_sexClient moveTo _targetPos;
						[_sexClient, _targetPos] remoteExec ["Server_NPC_HookerMoveTo", 2];
					} else {
						if (_distance < 0.3) then {
							doStop _sexClient;
						};
					};
				};
			} else {
				if (_distance > 0.8) then {
					_sexClient doMove _targetPos;
					_sexClient commandMove _targetPos;
					_sexClient moveTo _targetPos;
					[_sexClient, _targetPos] remoteExec ["Server_NPC_HookerMoveTo", 2];
				} else {
					if (_distance < 0.3) then {
						doStop _sexClient;
					};
				};
			};
		};
		
		uiSleep 0.3;
	};
}] call compile_Global;

["A3PL_NPC_SexClient_Release",
{
	if (isNil "Player_NPC_SexClient" || {isNull Player_NPC_SexClient}) exitWith {};
	
	private _sexClient = Player_NPC_SexClient;
	private _npcID = _sexClient getVariable ["A3PL_NPC_ID_Config", ""];
	
	if (vehicle _sexClient != _sexClient) then {
		_sexClient action ["Eject", vehicle _sexClient];
		uiSleep 0.5;
		while {vehicle _sexClient != _sexClient && !isNull _sexClient && alive _sexClient} do {
			uiSleep 0.1;
		};
	};
	
	[_sexClient] call A3PL_NPC_Delete;
	
	Player_NPC_SexClient = nil;
	Player_NPC_SexClient_Owner = nil;
	Player_NPC_SexClient_IsStopped = false;
	Player_NPC_SexClient_IsArrested = false;
	
	if (_npcID != "") then {
		uiSleep 0.5;
		[_npcID] call A3PL_NPC_Create;
	};
}] call compile_Global;

["A3PL_NPC_StopFollowing",
{
	if (isNil "Player_NPC_SexClient" || {isNull Player_NPC_SexClient}) exitWith {
		[("STR_A3PL_NPC_NoSexClient" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	
	if (Player_NPC_SexClient_IsStopped) exitWith {
		[("STR_A3PL_NPC_AlreadyStopped" call A3PL_Localize), Color_Orange] call A3PL_Notification;
	};
	
	Player_NPC_SexClient_IsStopped = true;
	Player_NPC_SexClient setVariable ["A3PL_NPC_IsStopped", true, true];
	doStop Player_NPC_SexClient;
	
	[("STR_A3PL_NPC_Stopped" call A3PL_Localize), Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_NPC_ResumeFollowing",
{
	if (isNil "Player_NPC_SexClient" || {isNull Player_NPC_SexClient}) exitWith {
		[("STR_A3PL_NPC_NoSexClient" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	
	if (!Player_NPC_SexClient_IsStopped) exitWith {
		[("STR_A3PL_NPC_NotStopped" call A3PL_Localize), Color_Orange] call A3PL_Notification;
	};
	
	Player_NPC_SexClient_IsStopped = false;

	private _sexClient = Player_NPC_SexClient;
	_sexClient setVariable ["A3PL_NPC_IsStopped", false, true];

	// Désactiver le mode travail de la hooker si elle travaillait avec ce client
	if (!isNil "Player_Hooker" && {!isNull Player_Hooker}) then {
		private _linkedClient = Player_Hooker getVariable ["A3PL_NPC_SexClient", objNull];
		if (_linkedClient == _sexClient) then {
			Player_Hooker setVariable ["A3PL_Hooker_IsWorking", false, true];
			Player_Hooker setVariable ["A3PL_NPC_SexClient", nil, true];
		};
	};

	[_sexClient] remoteExec ["Server_NPC_EnableHookerMove", 2];
	
	uiSleep 0.2;
	_sexClient enableAI "MOVE";
	_sexClient enableAI "FSM";
	_sexClient enableSimulation true;
	_sexClient setUnitPos "UP";
	_sexClient forceSpeed 1.5;
	
	private _group = group _sexClient;
	_group setBehaviour "CARELESS";
	_group setCombatMode "BLUE";
	_group setSpeedMode "LIMITED";
	_group setGroupOwner (owner player);
	
	[("STR_A3PL_NPC_Resumed" call A3PL_Localize), Color_Green] call A3PL_Notification;

	[] spawn A3PL_NPC_SexClient_Follow;
}] call compile_Global;

["A3PL_NPC_Arrest",
{
	private _sexClient = Player_ObjIntersect;
	
	if (isNull _sexClient) exitWith {};
	
	if (!(_sexClient getVariable ["A3PL_NPC_SexClient_Active", false])) exitWith {
		[("STR_A3PL_NPC_NotASexClient" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	
	private _job = player getVariable ["job", ""];
	if (_job != ("STR_Common_FISD" call A3PL_Localize)) exitWith {
		[("STR_A3PL_NPC_NotFISD" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	
	if (_sexClient getVariable ["A3PL_NPC_IsArrested", false]) exitWith {
		[("STR_A3PL_NPC_AlreadyArrested" call A3PL_Localize), Color_Orange] call A3PL_Notification;
	};
	
	_sexClient setVariable ["A3PL_NPC_IsArrested", true, true];
	_sexClient setVariable ["A3PL_NPC_ArrestedBy", player, true];
	
	if (!isNil "Player_NPC_SexClient" && {Player_NPC_SexClient == _sexClient}) then {
		Player_NPC_SexClient_IsArrested = true;
		Player_NPC_SexClient_IsStopped = true;
	};
	
	private _owner = _sexClient getVariable ["A3PL_NPC_FollowingPlayer", objNull];
	if (!isNull _owner && {_owner != player}) then {
		[("STR_A3PL_NPC_ArrestedByFISD" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _owner];
	};
	
	[_sexClient, player] spawn {
		params ["_sexClient", "_fisd"];
		
		if (isNull _sexClient || {isNull _fisd}) exitWith {};
		
		while {alive _sexClient && {_sexClient getVariable ["A3PL_NPC_IsArrested", false]}} do {
			if (vehicle _fisd != _fisd) then {
				private _veh = vehicle _fisd;
				if (vehicle _sexClient == _sexClient) then {
					_sexClient assignAsCargo _veh;
					_sexClient moveInCargo _veh;
				};
			} else {
				if (vehicle _sexClient != _sexClient) then {
					_sexClient action ["Eject", vehicle _sexClient];
				};
				
				private _distance = _sexClient distance _fisd;
				if (_distance > 5) then {
					_sexClient doMove (getPosATL _fisd);
				} else {
					doStop _sexClient;
				};
			};
			
			uiSleep 1;
		};
	};
	
	[("STR_A3PL_NPC_Arrested" call A3PL_Localize), Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_NPC_ReleaseAtStation",
{
	private _sexClient = Player_ObjIntersect;
	
	if (isNull _sexClient) exitWith {};
	
	if (!(_sexClient getVariable ["A3PL_NPC_SexClient_Active", false])) exitWith {
		[("STR_A3PL_NPC_NotASexClient" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	
	private _job = player getVariable ["job", ""];
	if (_job != ("STR_Common_FISD" call A3PL_Localize)) exitWith {
		[("STR_A3PL_NPC_NotFISD" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	
	if (!(_sexClient getVariable ["A3PL_NPC_IsArrested", false])) exitWith {
		[("STR_A3PL_NPC_NotArrested" call A3PL_Localize), Color_Orange] call A3PL_Notification;
	};
	
	private _nearStation = false;
	{
		if ((typeOf _x) IN ["Land_Police_Headquarter", "Land_A3FL_SheriffPD", "Land_EC_SheriffHQ", "Land_A3PL_Sheriffpd"]) then {
			if ((player distance _x) < 30) then {
				_nearStation = true;
			};
		};
	} forEach nearestObjects [player, ["House"], 30];
	
	if (!_nearStation) exitWith {
		[("STR_A3PL_NPC_NotNearStation" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	
	[_sexClient] spawn A3PL_NPC_SexClient_Release;

	[("STR_A3PL_NPC_ReleasedAtStation" call A3PL_Localize), Color_Green] call A3PL_Notification;
}] call compile_Global;

// Fonction pour marquer un dialogue comme utilisé
["A3PL_NPC_MarkDialogUsed",
{
	private _npc = param [0, objNull];
	private _dialogID = param [1, ""];
	if (isNull _npc || _dialogID isEqualTo "") exitWith {};
	
	// Récupérer la liste des dialogues utilisés
	private _usedDialogs = _npc getVariable ["A3PL_NPC_UsedDialogs", []];
	
	// Ajouter le dialogue à la liste s'il n'y est pas déjà
	if (!(_dialogID in _usedDialogs)) then {
		_usedDialogs pushBack _dialogID;
		_npc setVariable ["A3PL_NPC_UsedDialogs", _usedDialogs, true];
	};
}] call compile_Global;

// Fonction pour ouvrir un dialogue aléatoire pour les NPCs créés dynamiquement (nouveau système)
["A3PL_NPC_StartRandom",
{
	private _npc = player_objintersect;
	if (isNull _npc) exitWith {};
	
	A3PL_NPC_CurrentNPC = _npc;
	
	private _npcID = _npc getVariable ["A3PL_NPC_ID_Config", ""];
	private _isHooker = (_npcID find "hooker_" == 0);
	
	if (_isHooker) exitWith {
		["hooker_initial", _npc] call A3PL_NPC_Street_Start;
	};
	
	private _cooldownEnd = _npc getVariable ["A3PL_NPC_CooldownEnd", -1];
	if (_cooldownEnd > 0 && serverTime < _cooldownEnd) exitWith {
		private _npcConfigID = _npc getVariable ["A3PL_NPC_ID_Config", _npc getVariable ["A3PL_NPC_ID", ""]];
		private _charID = player getVariable ["character_id", ""];
		private _reputation = 0;
		if (_charID != "" && _npcConfigID != "") then {
			private _repVar = format["A3PL_NPC_Rep_%1_%2", _charID, _npcConfigID];
			_reputation = player getVariable [_repVar, 0];
			diag_log format["[A3PL_NPC_Street_Start Cooldown] Reading reputation: %1 from %2", _reputation, _repVar];
		};
		private _refusalText = format[("STR_NPC_LeaveRequestWithRep" call A3PL_Localize), _reputation];
		[_refusalText] call A3PL_NPC_Start_Custom;
	};
	
	private _assignedDialog = _npc getVariable ["A3PL_NPC_AssignedDialog", ""];
	
	// Si le NPC a déjà un dialogue assigné, l'utiliser
	if (_assignedDialog != "") then {
		// Vérifier si ce dialogue a déjà été utilisé (accepté ou refusé)
		private _usedDialogs = _npc getVariable ["A3PL_NPC_UsedDialogs", []];
		if (_assignedDialog in _usedDialogs) then {
			private _npcConfigID = _npc getVariable ["A3PL_NPC_ID_Config", _npc getVariable ["A3PL_NPC_ID", ""]];
			private _charID = player getVariable ["character_id", ""];
			private _reputation = 0;
			if (_charID != "" && _npcConfigID != "") then {
				private _repVar = format["A3PL_NPC_Rep_%1_%2", _charID, _npcConfigID];
				_reputation = player getVariable [_repVar, 0];
			};
			private _refusalText = format[("STR_NPC_LeaveRequestWithRep" call A3PL_Localize), _reputation];
			[_refusalText] call A3PL_NPC_Start_Custom;
		} else {
			// Sinon, ouvrir le dialogue assigné avec le nouveau système
			[_assignedDialog, _npc] call A3PL_NPC_Street_Start;
		};
	} else {
		// Si le NPC n'a pas encore de dialogue assigné, en assigner un de manière permanente
		private _allDialogs = [
			"cocaine",
			"weed",
			"moonshine",
			"shrooms",
			"money",
			"sex_request",
			"leave"
		];

		// Sélectionner un dialogue aléatoire parmi tous les dialogues disponibles
		private _randomDialog = _allDialogs select (floor (random (count _allDialogs)));

		// Assigner ce dialogue de manière permanente au NPC
		_npc setVariable ["A3PL_NPC_AssignedDialog", _randomDialog, true];

		// Initialiser les valeurs si nécessaire
		switch (_randomDialog) do {
			case "cocaine": { call A3PL_NPC_CocaineRequest_Init; };
			case "weed": { call A3PL_NPC_WeedRequest_Init; };
			case "moonshine": { call A3PL_NPC_MoonshineRequest_Init; };
			case "shrooms": { call A3PL_NPC_ShroomsRequest_Init; };
			case "money": { call A3PL_NPC_MoneyRequest_Init; };
		};
		
		// Ouvrir le dialogue assigné avec le nouveau système
		[_randomDialog, _npc] call A3PL_NPC_Street_Start;
	};
}] call compile_Global;

["A3PL_NPC_TakeJob",
{
	private _job = param [0,""];
	private _notify = param[1,true];
	if (_job isEqualTo "") exitwith {};
	[player,_job,_notify] remoteExec ["Server_NPC_RequestJob", 2];
}] call compile_Global;

["A3PL_NPC_ReqJobUniform",
{
	private _req = param[0,("STR_Common_Job_Unemployed" call A3PL_Localize)];
	_req = [_req] call A3PL_Localize;
	private _job = player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
	if (_req isEqualTo _job) then {
		switch (_job) do {
			case ("STR_Common_Job_McFisher" call A3PL_Localize): { player adduniform "A3PL_mcFishers_Uniform_uniform"; player addheadgear "A3PL_mcFishers_cap"; };
			case ("STR_Common_Job_TacoHell" call A3PL_Localize): { player adduniform "A3PL_TacoHell_Uniform_Uniform"; player addheadgear "A3PL_TacoHell_cap"; };
		};
	} else {
		[("STR_A3PL_NPC_YouAreNotWorkingHere" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};
}] call compile_Global;

["A3PL_NPC_LeaveJob",
{
	private _job = player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
	if (_job IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) then {[(player getVariable ["character_id",""])] remoteExec ["Server_Log_Faction_ClockOut",2];};
	[player,("STR_Common_Job_Unemployed" call A3PL_Localize)] remoteExec ["Server_NPC_RequestJob", 2];
	private _jobVeh = player getVariable ["jobVehicle",objNull];
	if (!isNull _jobVeh) then {deleteVehicle _jobVeh;};
}] call compile_Global;

["A3PL_NPC_TakeJobResponse",
{
	private _response = param [0,-1];
	private _job = param [1,""];
	private _notify = param [2,true];
	private _text = nil;
	private _charID = player getVariable ["character_id",""];
	if (_response isEqualTo -1) exitwith {}; 

	switch (_response) do {
		case 1: {_text = format [("STR_A3PL_NPC_YouAreNow" call A3PL_Localize),toUpperANSI(_job)]};
	};

	switch (_job) do
	{
		case ("STR_Common_Job_McFisher" call A3PL_Localize): {["mcfishers_accepted"] call A3PL_NPC_Start;};
		case ("STR_Common_Job_TacoHell" call A3PL_Localize): {["tacohell_accepted"] call A3PL_NPC_Start;};
		case ("STR_Common_Job_Deliver" call A3PL_Localize): {["mailman_accepted"] call A3PL_NPC_Start;};
		case ("STR_Common_Job_Waste" call A3PL_Localize): {_notify=false;};
		case ("STR_Common_FISD" call A3PL_Localize): {
			private _name = player getVariable["name",""];
			private _rank = [("STR_Common_FISD" call A3PL_Localize),"rank", _charID] call A3PL_Config_GetFactionRankData;
			_text = format[("STR_A3PL_NPC_OnDuty" call A3PL_Localize),_name,_rank];
			[_charID,("STR_Common_FISD" call A3PL_Localize)] remoteExec ["Server_Log_Faction_ClockIn",2];
		};
		case ("STR_Common_DOJ" call A3PL_Localize): {
			private _name = player getVariable["name",""];
			private _rank = [("STR_Common_DOJ" call A3PL_Localize),"rank", _charID] call A3PL_Config_GetFactionRankData;
			_text = format[("STR_A3PL_NPC_OnDuty" call A3PL_Localize),_name,_rank];
			[_charID,("STR_Common_DOJ" call A3PL_Localize)] remoteExec ["Server_Log_Faction_ClockIn",2];
		};
		case ("STR_Common_GOV" call A3PL_Localize): {
			private _name = player getVariable["name",""];
			private _rank = [("STR_Common_GOV" call A3PL_Localize),"rank", _charID] call A3PL_Config_GetFactionRankData;
			_text = format[("STR_A3PL_NPC_OnDuty" call A3PL_Localize),_name,_rank];
			[_charID,("STR_Common_GOV" call A3PL_Localize)] remoteExec ["Server_Log_Faction_ClockIn",2];
		};
		case ("STR_Common_FIFR" call A3PL_Localize): {
			private _name = player getVariable["name",""];
			private _rank = [("STR_Common_FIFR" call A3PL_Localize),"rank", _charID] call A3PL_Config_GetFactionRankData;
			_text = format[("STR_A3PL_NPC_OnDuty" call A3PL_Localize),_name,_rank];
			[_charID,("STR_Common_FIFR" call A3PL_Localize)] remoteExec ["Server_Log_Faction_ClockIn",2];
		};
	};
	if ((!isNil "_text") && _notify) exitwith {[_text,Color_Green] call A3PL_Notification;};
}] call compile_Global;

["A3PL_NPC_Create",
{
	private _npcID = param [0,""];
	private _customPos = param [1,[]];
	
	if (_npcID isEqualTo "") exitWith {
		[("STR_A3PL_NPC_Create_NoID" call A3PL_Localize), Color_Red] call A3PL_Notification;
		objNull;
	};
	
	if (isDedicated) then {
		[_npcID, _customPos] call Server_NPC_Create;
	} else {
		[_npcID, _customPos] remoteExec ["Server_NPC_Create", 2];
		objNull;
	};
}] call compile_Global;

["A3PL_NPC_GetDialog",
{
	private _npc = param [0, objNull];
	private _dialogType = param [1, ""];
	
	if (isNull _npc || _dialogType isEqualTo "") exitWith {""};
	
	private _identity = _npc getVariable ["identity", ""];
	if (_identity isEqualTo "") exitWith {""};
	
	private _dialog = "";
	
	// Chercher le type de dialogue dans la config
	{
		if ((_x#0) == _dialogType) then {
			private _identityDialogs = _x#1;
			{
				if ((_x#0) == _identity) then {
					private _dialogs = _x#1;
					if (count _dialogs > 0) then {
						// Retourner un dialogue aléatoire pour cette identité
						_dialog = _dialogs select (floor (random (count _dialogs)));
					};
				};
			} forEach _identityDialogs;
		};
	} forEach Config_NPC_Dialogs;
	
	_dialog
}] call compile_Global;

["A3PL_NPC_Patrol",
{
	private _npc = param [0, objNull];
	private _path = param [1, []];
	
	if (isNull _npc || count _path == 0) exitWith {};

	_npc allowDamage false;
	_npc setUnitPos "UP";
	_npc forceSpeed 1.5;

	// Désactiver le pathfinding automatique pour un mouvement plus direct
	_npc disableAI "AUTOCOMBAT";
	_npc disableAI "TARGET";
	_npc disableAI "AUTOTARGET";
	_npc disableAI "COVER";
	_npc disableAI "SUPPRESSION";
	_npc disableAI "PATH";
	_npc setBehaviour "CARELESS";
	_npc setSpeedMode "LIMITED";
	_npc forceFollowRoad false;
	
	_npc setVariable ["A3PL_NPC_PatrolPath", _path, false];
	_npc setVariable ["A3PL_NPC_PatrolIndex", 0, false];
	_npc setVariable ["A3PL_NPC_PatrolDirection", 1, false]; // 1 = forward, -1 = backward
	_npc setVariable ["A3PL_NPC_IsPatrolling", true, false];
	_npc setVariable ["A3PL_NPC_IsStopped", false, false];
	_npc setVariable ["A3PL_NPC_GreetedPlayers", [], false];
	
	while {!isNull _npc && alive _npc && (_npc getVariable ["A3PL_NPC_IsPatrolling", false])} do {
		private _currentPath = _npc getVariable ["A3PL_NPC_PatrolPath", []];
		private _currentIndex = _npc getVariable ["A3PL_NPC_PatrolIndex", 0];
		
		if (count _currentPath == 0) exitWith {};
		
		// Vérifier si un joueur est proche (moins de 5 mètres)
		private _playerNearby = false;
		private _nearestPlayer = objNull;
		private _nearestDistance = 5;
		private _greetedPlayers = _npc getVariable ["A3PL_NPC_GreetedPlayers", []];
		
		{
			if (!isNull _x && alive _x) then {
				private _distance = _npc distance _x;
				if (_distance < 5 && _distance < _nearestDistance) then {
					_playerNearby = true;
					_nearestPlayer = _x;
					_nearestDistance = _distance;
					
					// Si le joueur n'a pas encore été salué, dire le greeting
					if (!(_x in _greetedPlayers)) then {
						private _greetingDialog = [_npc, "greeting"] call A3PL_NPC_GetDialog;
						if (_greetingDialog != "") then {
							// Faire l'animation de salutation
							_npc playAction "Gesture_wave";
							
							// Utiliser say3D pour que tout le monde autour entende (rayon de 50 mètres)
							[_npc, _greetingDialog] remoteExec ["say3D", 0];
							
							_greetedPlayers pushBack _x;
							_npc setVariable ["A3PL_NPC_GreetedPlayers", _greetedPlayers, false];
						};
					};
				} else {
					// Si le joueur s'éloigne, le retirer de la liste des joueurs salués
					if (_x in _greetedPlayers && _distance >= 10) then {
						_greetedPlayers = _greetedPlayers - [_x];
						_npc setVariable ["A3PL_NPC_GreetedPlayers", _greetedPlayers, false];
					};
				};
			};
		} forEach allPlayers;
		
		// Si un joueur est proche, arrêter le NPC et le regarder
		if (_playerNearby) then {
			if (!(_npc getVariable ["A3PL_NPC_IsStopped", false])) then {
				doStop _npc;
				_npc setVariable ["A3PL_NPC_IsStopped", true, false];
			};
			
			// Faire tourner seulement la tête du NPC vers le joueur le plus proche (pas le corps)
			if (!isNull _nearestPlayer) then {
				_npc doWatch _nearestPlayer;
			};
			
			// Attendre et vérifier à nouveau
			uiSleep 1;
		} else {
			// Si le NPC était arrêté et qu'aucun joueur n'est proche, reprendre la patrouille
			if (_npc getVariable ["A3PL_NPC_IsStopped", false]) then {
				_npc setVariable ["A3PL_NPC_IsStopped", false, false];
			};
			
			// Obtenir la position actuelle du chemin
			private _targetPosRaw = _currentPath select _currentIndex;
			private _targetPos = [];
			if (count _targetPosRaw >= 3) then {
				_targetPos = [_targetPosRaw select 0, _targetPosRaw select 1, _targetPosRaw select 2];
			} else {
				_targetPos = _targetPosRaw;
			};
			
			// Vérifier si le NPC est proche de la position cible (dans un rayon de 3 mètres)
			if (_npc distance _targetPos < 3) then {
				// Récupérer la direction actuelle (1 = forward, -1 = backward)
				private _direction = _npc getVariable ["A3PL_NPC_PatrolDirection", 1];

				// Passer au point suivant selon la direction
				_currentIndex = _currentIndex + _direction;

				// Si on a atteint la fin du chemin, inverser la direction
				if (_currentIndex >= count _currentPath) then {
					_direction = -1;
					_currentIndex = (count _currentPath) - 2; // Avant-dernier point (on vient du dernier)
					if (_currentIndex < 0) then { _currentIndex = 0; };
					_npc setVariable ["A3PL_NPC_PatrolDirection", _direction, false];
				};

				// Si on a atteint le début du chemin, inverser la direction
				if (_currentIndex < 0) then {
					_direction = 1;
					_currentIndex = 1; // Deuxième point (on vient du premier)
					if (_currentIndex >= count _currentPath) then { _currentIndex = 0; };
					_npc setVariable ["A3PL_NPC_PatrolDirection", _direction, false];
				};

				_npc setVariable ["A3PL_NPC_PatrolIndex", _currentIndex, false];
				_targetPosRaw = _currentPath select _currentIndex;
				if (count _targetPosRaw >= 3) then {
					_targetPos = [_targetPosRaw select 0, _targetPosRaw select 1, _targetPosRaw select 2];
				} else {
					_targetPos = _targetPosRaw;
				};
			};
			
			// Faire bouger le NPC vers la position cible (utiliser plusieurs commandes pour forcer un mouvement direct)
			_npc doMove _targetPos;
			_npc moveTo _targetPos;
			_npc setDestination [_targetPos, "LEADER DIRECT", true];

			// Attendre un peu avant de vérifier à nouveau
			uiSleep 1;
		};
	};
}] call compile_Global;

// Version avec waypoints pour un mouvement plus direct
["A3PL_NPC_PatrolWaypoint",
{
	private _npc = param [0, objNull];
	private _path = param [1, []];

	if (isNull _npc || count _path == 0) exitWith {};

	_npc allowDamage false;
	_npc setUnitPos "UP";
	_npc setBehaviour "CARELESS";
	_npc setSpeedMode "LIMITED";
	_npc disableAI "AUTOCOMBAT";
	_npc disableAI "TARGET";
	_npc disableAI "AUTOTARGET";
	_npc disableAI "COVER";
	_npc disableAI "SUPPRESSION";
	_npc forceFollowRoad false;

	_npc setVariable ["A3PL_NPC_PatrolPath", _path, false];
	_npc setVariable ["A3PL_NPC_IsPatrolling", true, false];
	_npc setVariable ["A3PL_NPC_IsStopped", false, false];
	_npc setVariable ["A3PL_NPC_GreetedPlayers", [], false];
	_npc setVariable ["A3PL_NPC_PatrolDirection", 1, false];

	private _grp = group _npc;

	// Fonction pour créer les waypoints
	private _fnc_createWaypoints = {
		params ["_grp", "_pathPoints", "_reverse"];

		// Supprimer tous les waypoints existants
		while {count waypoints _grp > 0} do {
			deleteWaypoint [_grp, 0];
		};

		private _positions = +_pathPoints;
		if (_reverse) then { reverse _positions; };

		{
			private _pos = [];
			if (count _x >= 3) then {
				_pos = [_x select 0, _x select 1, _x select 2];
			} else {
				_pos = _x;
			};

			private _wp = _grp addWaypoint [_pos, 0];
			_wp setWaypointType "MOVE";
			_wp setWaypointBehaviour "CARELESS";
			_wp setWaypointSpeed "LIMITED";
			_wp setWaypointCompletionRadius 2;
		} forEach _positions;
	};

	// Stocker la fonction dans une variable pour l'utiliser dans la boucle
	_npc setVariable ["A3PL_NPC_CreateWaypointsFnc", _fnc_createWaypoints, false];

	// Créer les waypoints initiaux (aller)
	[_grp, _path, false] call _fnc_createWaypoints;

	// Boucle de surveillance pour les joueurs et le changement de direction
	while {!isNull _npc && alive _npc && (_npc getVariable ["A3PL_NPC_IsPatrolling", false])} do {
		private _currentPath = _npc getVariable ["A3PL_NPC_PatrolPath", []];
		private _greetedPlayers = _npc getVariable ["A3PL_NPC_GreetedPlayers", []];
		private _createWpFnc = _npc getVariable ["A3PL_NPC_CreateWaypointsFnc", {}];

		// Vérifier si un joueur est proche (moins de 5 mètres)
		private _playerNearby = false;
		private _nearestPlayer = objNull;
		private _nearestDistance = 5;

		{
			if (!isNull _x && alive _x) then {
				private _distance = _npc distance _x;
				if (_distance < 5 && _distance < _nearestDistance) then {
					_playerNearby = true;
					_nearestPlayer = _x;
					_nearestDistance = _distance;

					// Si le joueur n'a pas encore été salué
					if (!(_x in _greetedPlayers)) then {
						private _greetingDialog = [_npc, "greeting"] call A3PL_NPC_GetDialog;
						if (_greetingDialog != "") then {
							_npc playAction "Gesture_wave";
							[_npc, _greetingDialog] remoteExec ["say3D", 0];
							_greetedPlayers pushBack _x;
							_npc setVariable ["A3PL_NPC_GreetedPlayers", _greetedPlayers, false];
						};
					};
				} else {
					if (_x in _greetedPlayers && _distance >= 10) then {
						_greetedPlayers = _greetedPlayers - [_x];
						_npc setVariable ["A3PL_NPC_GreetedPlayers", _greetedPlayers, false];
					};
				};
			};
		} forEach allPlayers;

		// Arrêter/reprendre selon la proximité des joueurs
		if (_playerNearby) then {
			if (!(_npc getVariable ["A3PL_NPC_IsStopped", false])) then {
				_npc disableAI "MOVE";
				_npc setVariable ["A3PL_NPC_IsStopped", true, false];
			};
			if (!isNull _nearestPlayer) then {
				_npc doWatch _nearestPlayer;
			};
		} else {
			if (_npc getVariable ["A3PL_NPC_IsStopped", false]) then {
				_npc enableAI "MOVE";
				_npc setVariable ["A3PL_NPC_IsStopped", false, false];
			};
		};

		// Vérifier si on a atteint le dernier waypoint
		private _currentWP = currentWaypoint _grp;
		private _totalWP = count waypoints _grp;

		if (_currentWP >= _totalWP && _totalWP > 0) then {
			// Inverser la direction
			private _direction = _npc getVariable ["A3PL_NPC_PatrolDirection", 1];
			_direction = _direction * -1;
			_npc setVariable ["A3PL_NPC_PatrolDirection", _direction, false];

			// Recréer les waypoints dans l'autre sens
			[_grp, _currentPath, (_direction == -1)] call _createWpFnc;
		};

		uiSleep 1;
	};
}] call compile_Global;

["A3PL_NPC_Delete",
{
	private _param = param [0, objNull];
	
	// Si c'est un objet NPC directement
	if (typeName _param == "OBJECT") then {
		if (isNull _param) exitWith {
			[("STR_A3PL_NPC_Delete_InvalidObject" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};
		
		if (!alive _param) exitWith {
			[("STR_A3PL_NPC_Delete_AlreadyDead" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};
		
		// Arrêter la patrouille si elle est active
		_param setVariable ["A3PL_NPC_IsPatrolling", false, false];
		doStop _param;
		
		// Supprimer le groupe associé
		private _group = group _param;
		if (!isNull _group) then {
			// Supprimer toutes les unités du groupe
			private _units = units _group;
			{
				if (!isNull _x && alive _x) then {
					deleteVehicle _x;
				};
			} forEach _units;
			deleteGroup _group;
		} else {
			// Si pas de groupe, supprimer directement l'unité
			deleteVehicle _param;
		};
		
		[("STR_A3PL_NPC_Delete_Success" call A3PL_Localize), Color_Green] call A3PL_Notification;
	} else {
		// Si c'est un ID de NPC (string)
		if (typeName _param != "STRING" || _param isEqualTo "") exitWith {
			[("STR_A3PL_NPC_Delete_InvalidID" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};
		
		private _npcID = _param;
		private _found = false;
		private _deletedCount = 0;
		private _npcsToDelete = [];
		
		// Chercher tous les NPCs avec cet ID
		{
			if (!isNull _x && alive _x) then {
				private _npcStoredID = _x getVariable ["A3PL_NPC_ID", ""];
				if (_npcStoredID == _npcID) then {
					// Arrêter la patrouille si elle est active
					_x setVariable ["A3PL_NPC_IsPatrolling", false, false];
					doStop _x;
					_npcsToDelete pushBack _x;
					_found = true;
				};
			};
		} forEach allUnits;
		
		// Supprimer tous les NPCs trouvés
		{
			private _npc = _x;
			if (!isNull _npc && alive _npc) then {
				private _group = group _npc;
				if (!isNull _group) then {
					// Supprimer toutes les unités du groupe
					private _units = units _group;
					{
						if (!isNull _x && alive _x) then {
							deleteVehicle _x;
						};
					} forEach _units;
					deleteGroup _group;
				} else {
					deleteVehicle _npc;
				};
				_deletedCount = _deletedCount + 1;
			};
		} forEach _npcsToDelete;
		
		if (_found) then {
			[format[("STR_A3PL_NPC_Delete_SuccessMultiple" call A3PL_Localize), _deletedCount], Color_Green] call A3PL_Notification;
		} else {
			[format[("STR_A3PL_NPC_Delete_NotFound" call A3PL_Localize), _npcID], Color_Red] call A3PL_Notification;
		};
	};
}] call compile_Global;

["A3PL_NPC_DeleteAll",
{
	private _deletedCount = 0;
	private _npcsToDelete = [];
	
	// Chercher tous les NPCs créés avec notre système
	{
		if (!isNull _x && alive _x) then {
			private _npcStoredID = _x getVariable ["A3PL_NPC_ID", ""];
			if (_npcStoredID != "") then {
				// Arrêter la patrouille si elle est active
				_x setVariable ["A3PL_NPC_IsPatrolling", false, false];
				doStop _x;
				_npcsToDelete pushBack _x;
			};
		};
	} forEach allUnits;
	
	// Supprimer tous les NPCs trouvés
	{
		private _npc = _x;
		if (!isNull _npc && alive _npc) then {
			private _group = group _npc;
			if (!isNull _group) then {
				// Supprimer toutes les unités du groupe
				private _units = units _group;
				{
					if (!isNull _x && alive _x) then {
						deleteVehicle _x;
					};
				} forEach _units;
				deleteGroup _group;
			} else {
				deleteVehicle _npc;
			};
			_deletedCount = _deletedCount + 1;
		};
	} forEach _npcsToDelete;
	
	if (_deletedCount > 0) then {
		[format[("STR_A3PL_NPC_DeleteAll_Success" call A3PL_Localize), _deletedCount], Color_Green] call A3PL_Notification;
	} else {
		[("STR_A3PL_NPC_DeleteAll_None" call A3PL_Localize), Color_Yellow] call A3PL_Notification;
	};
}] call compile_Global;


// Fonction pour calculer la quantité selon la réputation du joueur
// Retourne la quantité maximale que le NPC accepte d'acheter selon la réputation
["A3PL_NPC_CalculateQuantity",
{
	private _npc = param [0, objNull];
	private _drugType = param [1, ""];
	private _player = param [2, objNull];

	if (isNull _npc || isNull _player) exitWith {1};

	private _quantityVar = format["A3PL_NPC_%1MaxQuantity", _drugType];
	private _storedQuantity = _npc getVariable [_quantityVar, -1];

	if (_storedQuantity != -1) exitWith { _storedQuantity };

	private _npcConfigID = _npc getVariable ["A3PL_NPC_ID_Config", _npc getVariable ["A3PL_NPC_ID", ""]];
	private _charID = _player getVariable ["character_id", ""];
	private _reputation = 0;

	if (_charID != "" && _npcConfigID != "") then {
		private _repVar = format["A3PL_NPC_Rep_%1_%2", _charID, _npcConfigID];
		_reputation = _player getVariable [_repVar, 0];

		if (_reputation == 0 && !(_player getVariable [format["A3PL_NPC_Rep_Loading_%1_%2", _charID, _npcConfigID], false])) then {
			_player setVariable [format["A3PL_NPC_Rep_Loading_%1_%2", _charID, _npcConfigID], true, false];
			private _npcName = name _npc;
			[_charID, _npcConfigID, _player, _npcName] remoteExec ["Server_NPC_GetReputation", 2];
		};
	};

	private _maxQuantity = 1;
	switch (_drugType) do {
		case "cocaine": {
			_maxQuantity = NPC_Reputation_MaxQuantity_Cocaine_Level1;
			if (_reputation >= NPC_Reputation_Threshold_4) then {
				_maxQuantity = NPC_Reputation_MaxQuantity_Cocaine_Level4;
			} else {
				if (_reputation >= NPC_Reputation_Threshold_3) then {
					_maxQuantity = NPC_Reputation_MaxQuantity_Cocaine_Level3;
				} else {
					if (_reputation >= NPC_Reputation_Threshold_2) then {
						_maxQuantity = NPC_Reputation_MaxQuantity_Cocaine_Level2;
					};
				};
			};
		};
		case "weed": {
			_maxQuantity = NPC_Reputation_MaxQuantity_Weed_Level1;
			if (_reputation >= NPC_Reputation_Threshold_4) then {
				_maxQuantity = NPC_Reputation_MaxQuantity_Weed_Level4;
			} else {
				if (_reputation >= NPC_Reputation_Threshold_3) then {
					_maxQuantity = NPC_Reputation_MaxQuantity_Weed_Level3;
				} else {
					if (_reputation >= NPC_Reputation_Threshold_2) then {
						_maxQuantity = NPC_Reputation_MaxQuantity_Weed_Level2;
					};
				};
			};
		};
		case "moonshine": {
			_maxQuantity = NPC_Reputation_MaxQuantity_Moonshine_Level1;
			if (_reputation >= NPC_Reputation_Threshold_4) then {
				_maxQuantity = NPC_Reputation_MaxQuantity_Moonshine_Level4;
			} else {
				if (_reputation >= NPC_Reputation_Threshold_3) then {
					_maxQuantity = NPC_Reputation_MaxQuantity_Moonshine_Level3;
				} else {
					if (_reputation >= NPC_Reputation_Threshold_2) then {
						_maxQuantity = NPC_Reputation_MaxQuantity_Moonshine_Level2;
					};
				};
			};
		};
		case "shrooms": {
			_maxQuantity = NPC_Reputation_MaxQuantity_Shrooms_Level1;
			if (_reputation >= NPC_Reputation_Threshold_4) then {
				_maxQuantity = NPC_Reputation_MaxQuantity_Shrooms_Level4;
			} else {
				if (_reputation >= NPC_Reputation_Threshold_3) then {
					_maxQuantity = NPC_Reputation_MaxQuantity_Shrooms_Level3;
				} else {
					if (_reputation >= NPC_Reputation_Threshold_2) then {
						_maxQuantity = NPC_Reputation_MaxQuantity_Shrooms_Level2;
					};
				};
			};
		};
	};

	_npc setVariable [_quantityVar, _maxQuantity, true];
	_maxQuantity
}] call compile_Global;

// Fonction pour initialiser la demande de cocaine (génère uniquement l'item)
["A3PL_NPC_CocaineRequest_Init",
{
	private _npc = player_objintersect;
	if (isNull _npc) exitWith {};
	
	// Liste des items de cocaine disponibles
	private _cocaineItems = ["cocaine", "cocaine_brick"];
	// Sélectionner un item aléatoire
	private _selectedItem = _cocaineItems select (floor (random (count _cocaineItems)));
	
	// Stocker uniquement l'item sur le NPC (la quantité sera calculée dynamiquement)
	_npc setVariable ["A3PL_NPC_CocaineItem", _selectedItem, true];
}] call compile_Global;


// Fonction pour initialiser la demande de weed (génère uniquement l'item)
["A3PL_NPC_WeedRequest_Init",
{
	private _npc = player_objintersect;
	if (isNull _npc) exitWith {};
	
	// Liste des items de weed disponibles
	private _weedItems = ["weed_bag_5g", "weed_bag_10g", "weed_bag_25g", "weed_bag_50g", "weed_bag_100g"];
	// Sélectionner un item aléatoire
	private _selectedItem = _weedItems select (floor (random (count _weedItems)));
	
	// Stocker uniquement l'item sur le NPC (la quantité sera calculée dynamiquement)
	_npc setVariable ["A3PL_NPC_WeedItem", _selectedItem, true];
	
	// Stocker le prix par unité pour éviter de le recalculer
	private _pricePerUnit = 0;
	switch (_selectedItem) do {
		case "weed_bag_5g": { _pricePerUnit = NPC_Weed_Price_weed_bag_5g; };
		case "weed_bag_10g": { _pricePerUnit = NPC_Weed_Price_weed_bag_10g; };
		case "weed_bag_25g": { _pricePerUnit = NPC_Weed_Price_weed_bag_25g; };
		case "weed_bag_50g": { _pricePerUnit = NPC_Weed_Price_weed_bag_50g; };
		case "weed_bag_100g": { _pricePerUnit = NPC_Weed_Price_weed_bag_100g; };
	};
	_npc setVariable ["A3PL_NPC_WeedPricePerUnit", _pricePerUnit, true];
}] call compile_Global;


// Fonction pour initialiser la demande de moonshine (génère uniquement l'item)
["A3PL_NPC_MoonshineRequest_Init",
{
	private _npc = player_objintersect;
	if (isNull _npc) exitWith {};

	// Liste des items de moonshine disponibles
	private _moonshineItems = ["jug_moonshine"];
	// Sélectionner un item aléatoire
	private _selectedItem = _moonshineItems select (floor (random (count _moonshineItems)));

	// Stocker uniquement l'item sur le NPC (la quantité sera calculée dynamiquement)
	_npc setVariable ["A3PL_NPC_MoonshineItem", _selectedItem, true];
	_npc setVariable ["A3PL_NPC_MoonshinePricePerUnit", NPC_Moonshine_Price_jug_moonshine, true];
}] call compile_Global;


// Fonction pour initialiser la demande de shrooms (génère uniquement l'item)
["A3PL_NPC_ShroomsRequest_Init",
{
	private _npc = player_objintersect;
	if (isNull _npc) exitWith {};

	// Stocker l'item sur le NPC (la quantité sera calculée dynamiquement)
	_npc setVariable ["A3PL_NPC_ShroomsItem", "shrooms", true];
	_npc setVariable ["A3PL_NPC_ShroomsPricePerUnit", NPC_Shrooms_Price_shrooms, true];
}] call compile_Global;


// Fonction pour initialiser la demande d'argent (génère le montant)
["A3PL_NPC_MoneyRequest_Init",
{
	private _npc = player_objintersect;
	if (isNull _npc) exitWith {};
	
	// Somme aléatoire entre 200 et 4200
	private _amount = 200 + floor(random(4000));
	// Stocker la variable sur le NPC avec synchronisation
	_npc setVariable ["A3PL_NPC_MoneyAmount", _amount, true];
	
	// Stocker aussi dans une variable globale
	A3PL_NPC_CurrentMoneyAmount = _amount;
	
	// Formater le texte directement et le stocker
	private _npcText = ("STR_NPC_MoneyRequest" call A3PL_Localize);
	A3PL_NPC_FormattedText = format[_npcText, _amount];
}] call compile_Global;

// Fonction pour gérer la demande d'argent
["A3PL_NPC_MoneyRequest_Accept",
{
	private _npc = player_objintersect;
	if (isNull _npc) exitWith {};
	
	// Marquer le dialogue comme utilisé
	[_npc, "npc_money_request"] call A3PL_NPC_MarkDialogUsed;
	
	// Récupérer le montant stocké dans le NPC (généré lors de la demande)
	private _amount = _npc getVariable ["A3PL_NPC_MoneyAmount", 1000];
	
	// Vérifier si le joueur a assez d'argent
	private _currentMoney = player getVariable ["Player_Cash", 0];
	if (_currentMoney < _amount) exitWith {
		[format[("STR_A3PL_NPC_NotEnoughMoney" call A3PL_Localize), _amount], Color_Red] call A3PL_Notification;
	};
	
	// Retirer l'argent du joueur
	[player, 'Player_Cash', _currentMoney - _amount] remoteExec ['Server_Core_ChangeVar', 2];
	
	[format[("STR_A3PL_NPC_MoneyGiven" call A3PL_Localize), _amount], Color_Yellow] call A3PL_Notification;
}] call compile_Global;

