/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Shop_Open",
{
	private ["_shop","_display","_currency","_control","_pos","_posConfig","_cam"];
	_shop = param [0,""];
	_currency = param [1,"player_cash"];
	_npc = param [2, cursorobject];

	disableSerialization;
	if(player getVariable ["inventory_opened",false]) exitwith {
		[getPlayerUID player,(player getVariable ["character_id",""]),"InventoryShopCloningAttempt",[]] remoteExec ["Server_Log_New",2];
		['STR_A3PL_Shop_TryReopenShop' call A3PL_Localize,Color_Red] call A3PL_Notification;
	};
	if (!(player_itemClass isEqualTo "")) exitwith {
		[getPlayerUID player,(player getVariable ["character_id",""]),"InventoryShopOpenWithItemAttempt",[]] remoteExec ["Server_Log_New",2];
		['STR_A3PL_Shop_RemoveThatYouHaveInYourHands' call A3PL_Localize,Color_Red] call A3PL_Notification;
	};

	_posConfig = [_shop,"pos"] call A3PL_Config_GetShop;
	if (typeName _posConfig isEqualTo "CODE") then {_pos = call _posConfig;};
	if (typeName _posConfig isEqualTo "OBJECT") then {_pos = getposASL _posConfig;};

	createDialog "Dialog_Shop";
	_display = findDisplay 20;

	_allItems = [_shop] call A3PL_Config_GetShop;
	_control = _display displayCtrl 1500;
	{
		private ["_itemType", "_itemClass", "_itemBuy", "_itemSell", "_itemName", "_itemCondition", "_i"];
		_itemType = _x select 0;
		_itemClass = _x select 1;
		_itemBuy = _x select 2;
		_itemSell = _x select 3;
		_itemCondition = _x select 4;
		_itempicture = [_x select 1, "picture"] call A3PL_Config_GetItem;
		

		_itemName = switch (_itemType) do {
			case "item": { [_itemClass, "name"] call A3PL_Config_GetItem; };
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

		if (call _itemCondition) then {
			if ([_itemClass, "canPickup"] call A3PL_Config_GetItem) then {
				_amount = [_itemClass] call A3PL_Inventory_Return;
				if (_amount > 0) then {
					_i = _control lbAdd format [("STR_A3PL_Shop_Inv" call A3PL_Localize), _itemName, _amount];
				} else {
					_i = _control lbAdd _itemName;
				};
				_control lbSetPicture [_i,_itempicture];
			} else {
				if (_itemType in ["vehicle", "plane"]) then {
					_objects = player nearEntities [[_itemClass], 10];
					if ((count _objects) > 0) then {
						_i = _control lbAdd format [("STR_A3PL_Shop_Near" call A3PL_Localize), _itemName, (count _objects)];
					} else {
						_i = _control lbAdd _itemName;
					};
				} else {
					_i = _control lbAdd _itemName;
				};
			};
			_itemData = format ['["%1", "%2", %3, %4, %5]', _itemType, _itemClass, _itemBuy, _itemSell, _forEachIndex];
			_control lbSetData [_i, _itemData];
		};
	} foreach _allItems;

	_control = _display displayCtrl 1602;
	_control ctrlAddEventHandler ["ButtonDown",format ["['%1','%2'] call A3PL_Shop_Buy;",_shop,_currency]];
	_control = _display displayCtrl 1603;
	_control ctrlAddEventHandler ["ButtonDown",format ["['%1','%2'] call A3PL_Shop_Sell;",_shop,_currency]];
	_control = _display displayCtrl 1500;
	_control ctrlAddEventHandler ["LBSelChanged",format ["['%1', '%2'] spawn A3PL_Shop_ItemSwitch;",_shop, _currency]];

	A3PL_SHOP_CAMERA = "camera" camCreate (ASLToAGL eyePos _npc);
	A3PL_SHOP_CAMERA camSetRelPos [0,0,0];
	A3PL_SHOP_CAMERA cameraEffect ["internal", "BACK"];
	A3PL_SHOP_CAMERA camCommit 0;
	showCinemaBorder false;

	A3PL_SHOP_NPC = _npc;

	_control = _display displayCtrl 1500;
	_control lbSetCurSel 0;

	[A3PL_SHOP_CAMERA] spawn
	{
		disableSerialization;
		_display = findDisplay 20;
		waitUntil { isNull _display };
		deleteVehicle A3PL_SHOP_ITEMPREVIEW;
		{deleteVehicle _x;} foreach _this;
		A3PL_SHOP_ITEMPREVIEW = nil;
		player cameraEffect ["terminate", "BACK"];
	};

	_control = _display displayCtrl 1900;
	_control sliderSetRange [-180, 180];
	_control sliderSetPosition 0;
	_control ctrlAddEventHandler ["SliderPosChanged",
	{
		A3PL_SHOP_ITEMPREVIEW setDir (param [1,180]);
	}];
}] call compile_Global;

["A3PL_Shop_Buy",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private ["_taxed","_display","_control","_shop","_currency","_spawnpos","_price","_item","_itemBuy","_itemType","_itemClass","_itemName","_amount","_totalPrice","_stockCheck","_index","_furnStores","_isGangControlled"];
	_shop = param [0,""];
	_shopObject = cursorobject;
	_currency = param [1,"player_cash"];
	_display = findDisplay 20;
	_spawnpos = [_shop,"spawnpos"] call A3PL_Config_GetShop;
	_taxedAmount = 0;

	_furnStores = Shops_FurnitureStore;
	_isGangControlled = [_shopObject] call A3PL_Gang_GangTax;

	_control = _display displayCtrl 1500;
	_index = lbCurSel _control;
	_item = _control lbData (_index);
	_item = call compile _item;
	_itemType = _item select 0;
	_itemClass = _item select 1;
	_itemBuy = _item select 2;

	private _itemIndex = _item select 4;

	_amount = 1;
	if (_itemType IN ["item","magazine"]) then
	{
		_control = _display displayCtrl 1400;
		_amount = floor(parseNumber (ctrlText _control));
	};
	if (_amount < 1) exitwith {[("STR_A3PL_Shop_EnterValidAmount" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_stockCheck = true;
	if (_shop IN Config_Shops_StockSystem) then
	{
		if (isNull _shopObject) exitwith {_stockCheck = false};
		if (((_shopObject getVariable ["stock",[]]) select _itemIndex) < _amount) then {_stockCheck = false;};
	};
	if (!_stockCheck) exitwith {[("STR_A3PL_Shop_NoStockAvailableToBuyThisItem" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_totalPrice = round(_itemBuy*_amount);
	_taxed = [_shop] call A3PL_Config_isTaxed;
	if(_taxed) then {
		_taxName = [_shop, "tax"] call A3PL_Config_GetTaxSeting;
		_taxedAmount = floor(_totalPrice*([_taxName] call A3PL_Config_GetTaxes));
	};

	_moneyCheck = false;
	switch (_currency) do
	{
		case ("candy"):
		{
			if (["candy",_totalprice] call A3PL_Inventory_Has) then {_moneyCheck = true;} else {
				[format[("STR_A3PL_Shop_YouNeedCandyToBuyThis" call A3PL_Localize),_totalprice-(["candy"] call A3PL_Inventory_Return)],Color_Red] call A3PL_Notification;
			};
		};
		case ("gift"):
		{
			if (["gift",_totalprice] call A3PL_Inventory_Has) then {_moneyCheck = true;} else {
				[format[("STR_A3PL_Shop_YouNeedGiftToBuyThis" call A3PL_Localize),_totalprice-(["gift"] call A3PL_Inventory_Return)],Color_Red] call A3PL_Notification;
			};
		};
		default {_moneyCheck = true};
	};
	if (!_moneyCheck) exitwith {};

	if (_shop IN Config_Shops_StockSystem) then
	{
		[_shopObject,_itemIndex,_amount] call A3PL_ShopStock_Decrease;
	};

	if ((_shop IN _furnStores) && (_amount > 1)) exitWith {[("STR_A3PL_Shop_YouCanOnlyBuy1FurnitureATime" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_itemName = ("STR_Common_Unknown" call A3PL_Localize);
	_canTake = true;

	if(!(isNil "_isGangControlled")) then {
		private _group = group player;
		private _gang = _group getVariable ["gang_data",nil];
		private _shopOwnedByGang = false;
		if (!(isNil '_gang')) then {
			private _gangOfPlayer = _gang#2;
			private _gangOfShop = _isGangControlled#1;
			if (_gangOfPlayer isEqualTo _gangOfShop) then {_shopOwnedByGang = true;};
		};
		if (!_shopOwnedByGang) then {
			private _shopGangTaxes = _shopObject getVariable ["gangTaxes",0];
			_shopObject setVariable ["gangTaxes",_shopGangTaxes + _taxedAmount,true];
			[(_isGangControlled select 0),round(_taxedAmount),"purchased"] remoteExec ["Server_Gang_NotifyPurchase",2];
		};
	};

	private _weaponHolder = createVehicle ["GroundWeaponHolder", getposATL player, [], 0, "CAN_COLLIDE"];

	switch (_itemType) do
	{
		case ("item"):
		{
			if ([_itemClass,"canPickup"] call A3PL_Config_GetItem) then
			{
				if(([[_itemClass,_amount]] call A3PL_Inventory_TotalWeight) <= Player_MaxWeight && ([_itemClass, _amount] call A3PL_InventoryNew_CanAddItem)) then {
					/* START HOW TO PAY */
					if (!(_currency in ["candy","gift","dirty_cash"])) then {
						
						[_totalPrice + _taxedAmount] call A3PL_Bank_HowToPay;
						[_itemClass,_amount] spawn {
							params["_itemClass","_amount"];
							waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
							if (!(player getVariable "paymentResult")) exitWith {};
							[_itemClass,_amount] call A3PL_Inventory_Add;
						};
					};
					/* END HOW TO PAY */
				} else {
					_canTake = false;
				};
			} else {
				/* START HOW TO PAY */
					if (!(_currency in ["candy","gift","dirty_cash"])) then {
						
						[_totalPrice + _taxedAmount] call A3PL_Bank_HowToPay;
						[_veh,_itemClass] spawn {
							params["_veh","_itemClass"];
							waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
							if (!(player getVariable "paymentResult")) exitWith {};
							private _veh = createVehicle [([_itemClass,"class"] call A3PL_Config_GetItem), getposATL player, [], 0, "CAN_COLLIDE"];
							if (!([_itemClass,"simulation"] call A3PL_Config_GetItem)) then	{[_veh] remoteExec ["Server_Vehicle_EnableSimulation",2];};
							_veh setVariable ["class",_itemClass,true];
							_veh setVariable ["owner",(player getVariable ["character_id",""]),true];
							private _pJob = player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
							if (_pJob IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) then {
								_veh setVariable ["job",_pJob,true];
							};
							[_veh,player] remoteExec ["A3PL_Lib_ChangeLocality", 2];
						};
					};
					/* END HOW TO PAY */
			};
			_itemName = [_itemClass,"name"] call A3PL_Config_GetItem;
		};
		case ("backpack"):
		{
			/* START HOW TO PAY */
			if (!(_currency in ["candy","gift","dirty_cash"])) then {
				[_totalPrice + _taxedAmount] call A3PL_Bank_HowToPay;
				[_itemClass] spawn {
					params["_itemClass"];
					waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
					if (!(player getVariable "paymentResult")) exitWith {};
					player addBackPack _itemClass;
				};
			};
			/* END HOW TO PAY */
						
			_itemName = getText (configFile >> "CfgVehicles" >> _itemClass >> "displayName");
		};
		case ("uniform"): 
		{
			private _itemInUniform = uniformItems player;
			private _weaponItems = weaponsItems (uniformContainer player);
			{
				private _itemClass = _x#0;
				_itemInUniform = _itemInUniform - [_itemClass];
			} forEach _weaponItems;

			if (!(_currency in ["candy","gift","dirty_cash"])) then {
				[_totalPrice + _taxedAmount] call A3PL_Bank_HowToPay;
				[_itemClass, _itemInUniform, _weaponItems] spawn {
					params["_itemClass", "_itemInUniform", "_weaponItems"];
					waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
					if (!(player getVariable "paymentResult")) exitWith {};
					player addUniform _itemClass;
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
				};
			};

			_itemName = getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName");
		};
		case ("vest"): 
		{
			private _vestItems = vestItems player;
			private _weaponItems = weaponsItems (vestContainer player);
			{
				private _itemClass = _x#0;
				_vestItems = _vestItems - [_itemClass];
			} forEach _weaponItems;

			if (!(_currency in ["candy","gift","dirty_cash"])) then {
				[_totalPrice + _taxedAmount] call A3PL_Bank_HowToPay;
				[_itemClass, _vestItems, _weaponItems] spawn {
					params["_itemClass", "_vestItems", "_weaponItems"];
					waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
					if (!(player getVariable "paymentResult")) exitWith {};
					player addVest _itemClass;

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
				};
			};
			
			_itemName = getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName");
		};
		case ("headgear"): 
		{
			/* START HOW TO PAY */
			if (!(_currency in ["candy","gift","dirty_cash"])) then {
				[_totalPrice + _taxedAmount] call A3PL_Bank_HowToPay;
				[_itemClass] spawn {
					params["_itemClass"];
					waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
					if (!(player getVariable "paymentResult")) exitWith {};
					player addHeadgear _itemClass;
				};
			};
			/* END HOW TO PAY */

			_itemName = getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName");
		};
		case ("aitem"): 
		{
			/* START HOW TO PAY */
			if (!(_currency in ["candy","gift","dirty_cash"])) then {
				[_totalPrice + _taxedAmount] call A3PL_Bank_HowToPay;
				[_itemClass] spawn {
					params["_itemClass"];
					waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
					if (!(player getVariable "paymentResult")) exitWith {};
					player addItem _itemClass;
				};
			};
			/* END HOW TO PAY */

			_itemName = getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName");
		};
		case ("vehicle"): 
		{
			/* START HOW TO PAY */
			if (!(_currency in ["candy","gift","dirty_cash"])) then {
				[_totalPrice + _taxedAmount] call A3PL_Bank_HowToPay;
				[_itemClass,_spawnpos] spawn {
					params["_itemClass","_spawnpos"];
					waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
					if (!(player getVariable "paymentResult")) exitWith {};
					[player,[_itemClass,1],"","car",_spawnpos] remoteExec ["Server_Factory_Create", 2];
				};
			};
			/* END HOW TO PAY */
			
			_itemName = getText (configFile >> "CfgVehicles" >> _itemClass >> "displayName");
		};
		case ("plane"): 
		{
			/* START HOW TO PAY */
			if (!(_currency in ["candy","gift","dirty_cash"])) then {
				[_totalPrice + _taxedAmount] call A3PL_Bank_HowToPay;
				[_itemClass,_spawnpos] spawn {
					params["_itemClass","_spawnpos"];
					waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
					if (!(player getVariable "paymentResult")) exitWith {};
					[player,[_itemClass,1],"","plane",_spawnpos] remoteExec ["Server_Factory_Create", 2];
				};
			};
			/* END HOW TO PAY */
			
			_itemName = getText (configFile >> "CfgVehicles" >> _itemClass >> "displayName");
		};
		case ("weapon"): 
		{
			/* START HOW TO PAY */
			if (!(_currency in ["candy","gift","dirty_cash"])) then {
				[_totalPrice + _taxedAmount] call A3PL_Bank_HowToPay;
				[_itemClass] spawn {
					params["_itemClass"];
					waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
					if (!(player getVariable "paymentResult")) exitWith {};
					player addItem _itemClass;
					[_itemClass] call A3PL_InventoryNew_HandleMeleeWeaponMagazine;
				};
			};
			/* END HOW TO PAY */
			
			_itemName = getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName");
		};
		case ("weaponPrimary"): 
		{
			/* START HOW TO PAY */
			if (!(_currency in ["candy","gift","dirty_cash"])) then {
				[_totalPrice + _taxedAmount] call A3PL_Bank_HowToPay;
				[_itemClass] spawn {
					params["_itemClass"];
					waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
					if (!(player getVariable "paymentResult")) exitWith {};
					player addWeapon _itemClass;
					[_itemClass] call A3PL_InventoryNew_HandleMeleeWeaponMagazine;
				};
			};
			/* END HOW TO PAY */
			
			_itemName = getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName");
		};
		case ("magazine"): 
		{
			/* START HOW TO PAY */
			if (!(_currency in ["candy","gift","dirty_cash"])) then {
				[_totalPrice + _taxedAmount] call A3PL_Bank_HowToPay;
				[_itemClass,_amount] spawn {
					params["_itemClass","_amount"];
					waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
					if (!(player getVariable "paymentResult")) exitWith {};
					player addMagazines [_itemClass,_amount];
				};
			};
			/* END HOW TO PAY */
			
			_itemName = getText (configFile >> "CfgMagazines" >> _itemClass >> "displayName");
		};
		case ("goggles"): 
		{
			/* START HOW TO PAY */
			if (!(_currency in ["candy","gift","dirty_cash"])) then {
				[_totalPrice + _taxedAmount] call A3PL_Bank_HowToPay;
				[_itemClass] spawn {
					params["_itemClass"];
					waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
					if (!(player getVariable "paymentResult")) exitWith {};
					player addGoggles _itemClass;
				};
			};
			/* END HOW TO PAY */
			
			_itemName = getText (configFile >> "CfgGlasses" >> _itemClass >> "displayName");
		};
		case ("waitem"): 
		{
			/* START HOW TO PAY */
			if (!(_currency in ["candy","gift","dirty_cash"])) then {
				[_totalPrice + _taxedAmount] call A3PL_Bank_HowToPay;
				[_itemClass] spawn {
					params["_itemClass"];
					waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
					if (!(player getVariable "paymentResult")) exitWith {};
					player linkItem _itemClass;
				};
			};
			/* END HOW TO PAY */
			
			_itemName = getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName");
		};
	};
	if(!_canTake) exitWith {[("STR_Common_NotEnoughSpace" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	switch (_currency) do
	{
		case ("candy"):
		{
			["candy",-(_totalPrice)] call A3PL_Inventory_Add;
			[format [("STR_A3PL_Shop_BuyWithCandy" call A3PL_Localize),_itemName,_totalPrice,(["candy"] call A3PL_Inventory_Return),_amount],Color_Green] call A3PL_Notification;
		};
		case ("gift"):
		{
			["gift",-(_totalPrice)] call A3PL_Inventory_Add;
			[format [("STR_A3PL_Shop_BuyGift" call A3PL_Localize),_itemName,_totalPrice,(["gift"] call A3PL_Inventory_Return),_amount],Color_Green] call A3PL_Notification;
		};
		case ("dirty_cash"):
		{
			["dirty_cash",-(_totalPrice)] call A3PL_Inventory_Add;
			[format [("STR_A3PL_Shop_BuyDirtyCash" call A3PL_Localize),_itemName,_totalPrice,(["dirty_cash"] call A3PL_Inventory_Return)-_totalPrice,_amount],Color_Green] call A3PL_Notification;
		};
	};

	[_shop, _currency] spawn A3PL_Shop_ItemSwitch;

	if (_taxed) then {
		private _taxBudget = [_shop, "budget"] call A3PL_Config_GetTaxSeting;
		[format [("STR_A3PL_Shop_TaxFees" call A3PL_Localize), [_taxedAmount, 1, 0, true] call CBA_fnc_formatNumber, _taxName],Color_Orange] call A3PL_Notification;
		if (isNil "_isGangControlled") then {
			[_taxBudget,_taxedAmount] remoteExec ["Server_Government_AddBalance",2];
		};
	};
	[getPlayerUID player,(player getVariable ["character_id",""]),"Shop_NPC_ItemBought",[format ["Shop: %1 | Item: %2 | Amount: %3 | Cost: %4",_shop,_itemName,_amount,(_totalPrice + _taxedAmount)]]] remoteExec ["Server_Log_New",2];

	if (_shop IN Shops_Faction) then {
		[player,_shop,_itemName,_amount,_totalPrice] remoteExec ["Server_Log_FactionExpense",2];
	};
}] call compile_Global;

["A3PL_Shop_Sell",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private _shop = param [0,""];
	private _currency = param [1,"player_cash"];
	private _shopObject = cursorobject;
	private _taxedAmount = 0;

	private _display = findDisplay 20;
	private _control = _display displayCtrl 1500;
	private _index = lbCurSel _control;
	private _item = _control lbData (_index);
	_item = call compile _item;
	private _itemType = _item select 0;
	private _itemClass = _item select 1;
	private _itemSell = _item select 3;

	private _pJob = player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];

	private _itemIndex = _item select 4;

	private _amount = 1;
	if (_itemType IN ["item","magazine"]) then
	{
		_control = _display displayCtrl 1400;
		_amount = floor(parseNumber (ctrlText _control));
	};
	if (_amount < 1) exitwith {[("STR_A3PL_Shop_EnterValidAmount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if(_itemClass IN Shops_Sell_One_by_One && _amount > 1) exitwith {[("STR_A3PL_Shop_YouOnlyCanSellOneByOne" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _isAbove = false;
	if (_shop IN Config_Shops_StockSystem) then
	{
		private ["_stockVar","_newStock"];
		_stockVar = cursorobject getVariable ["stock",[]];
		_newStock = (_stockVar select _itemIndex)+_amount;
		if (_newStock > Shops_Max_Stock) then {_isAbove = true;};
	};
	if (_isAbove) exitwith
	{
		[format[("STR_A3PL_Shop_NoMoreStockNeeded" call A3PL_Localize),Shops_Max_Stock],Color_Red] call A3PL_Notification;
	};

	if (_itemClass isEqualTo "net") exitwith {[("STR_A3PL_Shop_CantSellNet" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_itemClass isEqualTo "bucket_empty") exitwith {[("STR_A3PL_Shop_CantSellEmptyBucket" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _itemName = ("STR_Common_Unknown" call A3PL_Localize);
	private _has = false;
	switch (_itemType) do {
		case ("item"): {
			if ([_itemClass,_amount] call A3PL_Inventory_Has) then {
				[_itemClass,-(_amount)] call A3PL_Inventory_Add;
				_has = true;
			} else {
				if (!([_itemClass,"canPickup"] call A3PL_Config_GetItem)) then {
					{
						if ((_x getVariable "class") isEqualTo _itemClass) exitwith
						{
							deleteVehicle _x;
							_has = true;
						};
					} foreach (player nearEntities [[([_itemClass,"class"] call A3PL_Config_GetItem)],20]);
				};
			};
			_itemName = [_itemClass,"name"] call A3PL_Config_GetItem;
		};
		case ("backpack"): {
			if ((backpack player) isEqualTo _itemClass) then {
				removeBackpack player;
				_itemName = getText (configFile >> "CfgVehicles" >> _itemClass >> "displayName");
				_has = true;
			};
		};
		case ("vehicle"): {
			private _vehicles = player nearEntities [["Car","Tank","Air","Plane","Ship"],20];
			private _vehicle = objNull;
			if ((count _vehicles) < 1) exitwith {[("STR_A3PL_Shop_MoveItNearestStore" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			{
				if (((typeOf _x) == _itemClass) && {(_pJob IN [("STR_Common_FIFR" call A3PL_Localize),("STR_Common_FISD" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) || ((_x getVariable ["owner",[]]) select 0) isEqualTo (player getVariable ["character_id",""])}) exitwith {
					_vehicle = _x;
				};
			} foreach _vehicles;
			if (isNull _vehicle) exitwith {[("STR_A3PL_Shop_MoveItNearestOnlyOwnerCanSell" call A3PL_Localize),Color_Red] call A3PL_Notification;};
            private _job = player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
            private _countItems = count ItemCargo _vehicle;
            if ((_job isEqualTo ("STR_Common_FISD" call A3PL_Localize)) && (_countItems > 0)) exitwith {[("STR_A3PL_Shop_EmptyInventoryBeforeSelling" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			[_vehicle] remoteExec ["Server_Vehicle_Sell",2];
			_itemName = getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "displayName");
			_has = true;
		};
		case ("plane"): {
			private _vehicles = player nearEntities [["Car","Tank","Air","Plane","Ship"],20];
			private _vehicle = objNull;
			if (count _vehicles < 1) exitwith {[("STR_A3PL_Shop_MoveItNearestOnlyOwnerCanSell" call A3PL_Localize)] call A3PL_Notification;};
			{
				if (((_pJob IN [("STR_Common_FIFR" call A3PL_Localize),("STR_Common_FISD" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) || ((_x getVariable ["owner",[]]) select 0) isEqualTo (player getVariable ["character_id",""])) && (typeOf _x) isEqualTo _itemClass) exitwith {
					_vehicle = _x;
				};
			} foreach _vehicles;
			if (isNull _vehicle) exitwith {[("STR_A3PL_Shop_MoveItNearestOnlyOwnerCanSell" call A3PL_Localize)] call A3PL_Notification;};
			[_vehicle] remoteExec ["Server_Vehicle_Sell",2];
			_itemName = getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "displayName");
			_has = true;
		};
		case ("weapon"): {
			if (_itemClass IN (weapons player)) then
			{
				if(_itemClass isEqualTo (handgunWeapon player)) then {
					player removeWeapon _itemClass;
				} else {
					player removeItem _itemClass;
				};
				_itemName = getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName");
				_has = true;
			};
		};
		case ("weaponPrimary"): {
			if (_itemClass IN (weapons player)) then
			{
				_itemName = getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName");
				player removeWeapon _itemClass;
				_has = true;
			};
		};
		case ("magazine"): {
			private _MagCount = {_x isEqualTo _itemClass} count magazines player;
			if(_MagCount >= _amount) then {
				_has = true;
				for "_i" from 0 to _amount do {player removeMagazine _itemClass;};
			};
			_itemName = getText (configFile >> "CfgMagazines" >> _itemClass >> "displayName");
		};
        case ("aitem"): {
            if (_itemClass IN (player weaponAccessories primaryWeapon player)) then
            {
                _itemName = getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName");
                player removePrimaryWeaponItem _itemClass;
                _has = true;
            };
            if (_itemClass IN (handgunItems player)) then
            {
                _itemName = getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName");
                player removeHandgunItem _itemClass;
                _has = true;
            };
        };
	};
	if (!_has) exitwith {[("STR_A3PL_Shop_YouDoNotHaveThisToSell" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_shop IN Config_Shops_StockSystem) then {
		[cursorobject,_itemIndex,_amount] call A3PL_ShopStock_Add;
	};

	private _totalPrice = 0;

	switch (_currency) do
	{
		case ("candy"): {
			["candy",_itemSell] call A3PL_Inventory_Add;
			[format [("STR_A3PL_Shop_SellCandy" call A3PL_Localize),_itemName,_itemSell,(["candy"] call A3PL_Inventory_Return)],Color_Green] call A3PL_Notification;
		};
		case ("gift"): {
			["gift",_itemSell] call A3PL_Inventory_Add;
			[format [("STR_A3PL_Shop_SellGift" call A3PL_Localize),_itemName,_itemSell,(["gift"] call A3PL_Inventory_Return)],Color_Green] call A3PL_Notification;
		};
		case ("dirty_cash"): {
			["dirty_cash",(_itemSell*_amount)] call A3PL_Inventory_Add;
			[format [("STR_A3PL_Shop_SellDirtyCash" call A3PL_Localize),_itemName,(_itemSell*_amount),(["dirty_cash"] call A3PL_Inventory_Return)+(_itemSell*_amount),_amount],Color_Green] call A3PL_Notification;
		};
		default {
			_totalPrice = round(_itemSell*_amount);

			// Trait negotiator/black_market - +5% sell price
			private _traits = player getVariable ["Player_Traits", []];
			private _illegalShops = ["Shop_CrimeBase","Shop_DrugsDealer","Shop_Gang","Shop_Ill_Cocaine","Shop_Ill_Moonshine","Shop_Ill_Shrooms","Shop_Ill_Trader","Shop_Ill_Weed"];
			private _isIllegalShop = _shop in _illegalShops;

			if ("negotiator" in _traits && !_isIllegalShop) then {
				_totalPrice = round(_totalPrice * 1.05);
			};
			if ("black_market" in _traits && _isIllegalShop) then {
				_totalPrice = round(_totalPrice * 1.05);
			};

			private _taxed = [_shop] call A3PL_Config_isTaxed;
			if (_taxed) then {
				private _taxName = [_shop, "tax"] call A3PL_Config_GetTaxSeting;
				private _taxDecimal = [_taxName] call A3PL_Config_GetTaxes;
				_taxedAmount = floor(_totalPrice * _taxDecimal);
			};
			private _isGangControlled = [_shopObject] call A3PL_Gang_GangTax;
			if(!(isNil "_isGangControlled")) then {
				private _group = group player;
				private _gang = _group getVariable ["gang_data",nil];
				private _shopOwnedByGang = false;
				if (!(isNil '_gang')) then {
					private _gangOfPlayer = _gang#2;
					private _gangOfShop = _isGangControlled#1;
					if (_gangOfPlayer isEqualTo _gangOfShop) then {_shopOwnedByGang = true;};
				};
				if (!_shopOwnedByGang && _taxed) then {
					private _shopGangTaxes = _shopObject getVariable ["gangTaxes",0];
					_shopObject setVariable ["gangTaxes",_shopGangTaxes + _taxedAmount,true];
					[(_isGangControlled select 0),round(_taxedAmount),"sold"] remoteExec ["Server_Gang_NotifyPurchase",2];
				};
			};
			if(_taxed) then {
				private _taxBudget = [_shop, "budget"] call A3PL_Config_GetTaxSeting;

				player setVariable [_currency,((player getVariable [_currency,0]) + _totalPrice - _taxedAmount),true];
				[format [("STR_A3PL_Shop_SellTaxFees" call A3PL_Localize), _itemName, [(_totalPrice - _taxedAmount), 1, 0, true] call CBA_fnc_formatNumber, _amount, _taxDecimal*100, [_taxedAmount, 1, 0, true] call CBA_fnc_formatNumber, "%"],Color_Green] call A3PL_Notification;
				if (isNil "_isGangControlled") then {
					[_taxBudget,_taxedAmount] remoteExec ["Server_Government_AddBalance",2];
				};
				[getPlayerUID player,(player getVariable ["character_id",""]),"Shop_NPC_ItemSold",[format ["Shop: %1 | Item: %2 | Amount: %3 | Profits: %4",_shop,_itemName,_amount,(_totalPrice - _taxedAmount)]]] remoteExec ["Server_Log_New",2];
			} else {
				player setVariable [_currency,((player getVariable [_currency,0]) + _totalPrice),true];
				[format [("STR_A3PL_Shop_Sell" call A3PL_Localize), _itemName, [_totalPrice, 1, 0, true] call CBA_fnc_formatNumber, _amount],Color_Green] call A3PL_Notification;
				[getPlayerUID player,(player getVariable ["character_id",""]),"Shop_NPC_ItemSold",[format ["Shop: %1 | Item: %2 | Amount: %3 | Profits: %4",_shop,_itemName,_amount,_totalPrice]]] remoteExec ["Server_Log_New",2];
			};
		};
	};

	[_shop, _currency] spawn A3PL_Shop_ItemSwitch;
}] call compile_Global;

["A3PL_Shop_ItemSwitch",
{
	disableSerialization;
	private ["_display","_shop","_index","_item","_itemType","_itemClass","_itemName","_ItemBuy","_itemSell","_pos","_posConfig","_itemObjectClass","_weaponHolder"];
	_shop = param [0,""];
	_currencyType = param [1,'player_cash'];

	_shopObject = A3PL_SHOP_NPC;
	
	_posConfig = [_shop,"pos"] call A3PL_Config_GetShop;
	if (typeName _posConfig isEqualTo "CODE") then {_pos = call _posConfig;};
	if (typeName _posConfig isEqualTo "OBJECT") then {_pos = getposASL _posConfig;};

	_display = findDisplay 20;
	_control = _display displayCtrl 1500;
	_index = lbCurSel _control;
	_item = _control lbData (_index);
	_item = call compile _item;
	_itemType = _item select 0;
	_itemClass = _item select 1;
	_itemBuy = _item select 2;
	_itemSell = _item select 3;

	private _itemIndex = _item#4;

	_isGangControlled = [_shopObject] call A3PL_Gang_GangTax;
	if(!(isNil "_isGangControlled")) then {
		private _group = group player;
		private _gang = _group getVariable ["gang_data",nil];
		private _shopOwnedByGang = false;
		if (!(isNil '_gang')) then {
			private _gangOfPlayer = _gang#2;
			private _gangOfShop = _isGangControlled#1;
			if (_gangOfPlayer isEqualTo _gangOfShop) then {_shopOwnedByGang = true;};
		};
		if (!_shopOwnedByGang) then {
			_itemSell = _itemSell - (_itemSell / 100 * 5);
			_itemBuy = _itemBuy + (_itemBuy / 100 * 5);
		};
	};

	_type = "item";
	switch (_itemType) do
	{
		case ("aitem"): { _itemName = getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName"); _itemObjectClass = _itemClass; _type = "wh"; };
		case ("item"):
		{
			_itemName = [_itemClass,"name"] call A3PL_Config_GetItem;
			_itemObjectClass = [_itemClass,"class"] call A3PL_Config_GetItem;
			if (((_itemClass splitString "_") select 0) isEqualTo "furn") then {_type = "furn";};
		};
		case ("backpack"): { _itemName = getText (configFile >> "CfgVehicles" >> _itemClass >> "displayName"); _itemObjectClass = _itemClass; _type = "backpack"; };
		case ("uniform"): { _itemName = getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName"); _itemObjectClass = _itemClass; _type = "uniform"; };
		case ("vest"): { _itemName = getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName"); _itemObjectClass = _itemClass; _type = "vest"; };
		case ("headgear"): { _itemName = getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName"); _itemObjectClass = _itemClass; _type = "headgear"; };
		case ("vehicle"): { _itemName = getText (configFile >> "CfgVehicles" >> _itemClass >> "displayName"); _itemObjectClass = _itemClass; _type = "vh"; };
		case ("plane"): { _itemName = getText (configFile >> "CfgVehicles" >> _itemClass >> "displayName"); _itemObjectClass = _itemClass; _type = "vh"; };
		case ("weapon"): { _itemName = getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName"); _itemObjectClass = _itemClass; _type = "wh"; };
		case ("weaponPrimary"): { _itemName = getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName"); _itemObjectClass = _itemClass; _type = "wh"; };
		case ("magazine"): { _itemName = getText (configFile >> "CfgMagazines" >> _itemClass >> "displayName"); _itemObjectClass = _itemClass; _type = "wh"; };
		case ("goggles"): { _itemName = getText (configFile >> "CfgGlasses" >> _itemClass >> "displayName"); _itemObjectClass = _itemClass; _type = "goggles"; };
		case ("waitem"): { _itemName = getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName"); _itemObjectClass = _itemClass; _type = "waitem"; };
	};

	_stockCtrl = _display displayCtrl 1102;
	_priceBCtrl = _display displayCtrl 1100;
	_priceSCtrl = _display displayCtrl 1101;
	_buyBtn = _display displayCtrl 1602;
	_sellBtn = _display displayCtrl 1603;

	if (_shop IN Config_Shops_StockSystem) then {
		private ["_stockVar","_newStock"];
		_stockVar = _shopObject getVariable ["stock",[]];
		if((count _stockVar) isEqualTo 0) exitwith {closeDialog 0;['STR_A3PL_Shop_ErrorStockNotProperlyDefined' call A3PL_Localize,Color_Red] call A3PL_Notification;};
		_stock = (_stockVar select _itemIndex);
		_stockCtrl ctrlSetStructuredText parseText format ["<t align='right'>%1</t>",_stock];
	} else {
		_stockCtrl ctrlSetStructuredText parseText format [("STR_A3PL_Shop_Illimited" call A3PL_Localize)];
	};

	_currency = switch(_currencyType) do {
		case("gift"): {("STR_A3PL_Shop_GiftX" call A3PL_Localize)};
		case("candy"): {("STR_A3PL_Shop_CandyX" call A3PL_Localize)};
		default {"$"};
	};

	if(_itemBuy >= 0) then {
		if(_itemBuy isEqualTo 0) then {
			_priceBCtrl ctrlSetStructuredText parseText format [("STR_A3PL_Shop_Free" call A3PL_Localize)];
		} else {
			_priceBCtrl ctrlSetStructuredText parseText format ["<t align='right'>%1%2</t>",_currency, [_itemBuy, 1, 0, true] call CBA_fnc_formatNumber];
		};
		_buyBtn ctrlEnable true;
	} else {
		_priceBCtrl ctrlSetStructuredText parseText format [("STR_A3PL_Shop_NotBuyeable" call A3PL_Localize)];
		_buyBtn ctrlEnable false;
	};

	if(_itemSell >= 0) then {
		_priceSCtrl ctrlSetStructuredText parseText format ["<t align='right'>%1%2</t>",_currency, [_itemSell, 1, 0, true] call CBA_fnc_formatNumber];
		_sellBtn ctrlEnable true;
	} else {
		_priceSCtrl ctrlSetStructuredText parseText format [("STR_A3PL_Shop_NotSelleable" call A3PL_Localize)];
		_sellBtn ctrlEnable false;
	};

	if (!isNil "A3PL_SHOP_ITEMPREVIEW") then {deleteVehicle A3PL_SHOP_ITEMPREVIEW;};

	if(_type IN ["headgear","goggles","uniform","vest","backpack","waitem"]) then {
		A3PL_SHOP_ITEMPREVIEW = "C_man_p_beggar_F" createvehicleLocal [0,0,0];
		A3PL_SHOP_ITEMPREVIEW setPosASL [14321.1,15.9644,1017.32];
		A3PL_SHOP_ITEMPREVIEW enableSimulation false;

		A3PL_SHOP_ITEMPREVIEW setUnitLoadout (getUnitLoadout player);

		switch (_type) do {
			case("headgear"): {A3PL_SHOP_ITEMPREVIEW addHeadGear _itemClass;};
			case("goggles"): {A3PL_SHOP_ITEMPREVIEW addGoggles _itemClass;};
			case("uniform"): {A3PL_SHOP_ITEMPREVIEW addUniform _itemClass;};
			case("vest"): {A3PL_SHOP_ITEMPREVIEW addVest _itemClass;};
			case("backpack"): {A3PL_SHOP_ITEMPREVIEW addBackPack _itemClass;};
			case("waitem"): {removeAllAssignedItems A3PL_SHOP_ITEMPREVIEW;A3PL_SHOP_ITEMPREVIEW linkItem _itemClass;};
		};
		if (_type isNotEqualTo "waitem") then {_type = "clothing";};
	} else {
		switch (_type) do
		{
			case ("wh"):
			{
				A3PL_SHOP_ITEMPREVIEW = "groundWeaponHolder" createVehicleLocal (getpos Player);
				switch (_itemType) do
				{
					case ("weapon"): {A3PL_SHOP_ITEMPREVIEW addWeaponCargo [_itemClass,1];};
					case ("weaponPrimary"): {A3PL_SHOP_ITEMPREVIEW addWeaponCargo [_itemClass,1];};
					case ("magazine"): {A3PL_SHOP_ITEMPREVIEW addMagazineCargo [_itemClass,1];};
					case ("aitem"): {A3PL_SHOP_ITEMPREVIEW addItemCargo [_itemClass,1];};
					case ("weaponitem"): {A3PL_SHOP_ITEMPREVIEW addItemCargo [_itemClass,1];};
					case ("secweaponitem"): {A3PL_SHOP_ITEMPREVIEW addItemCargo [_itemClass,1];};
				};
			};
			case default
			{
				A3PL_SHOP_ITEMPREVIEW = _itemObjectClass createVehicleLocal [_pos select 0,_pos select 1,(_pos select 2)+0.9];
				A3PL_SHOP_ITEMPREVIEW allowDamage false;
			};
		};
	};

	if !(_type IN ["clothing","waitem"]) then {
		switch (_itemClass) do {
			case ("A3PL_Jaws"): { A3PL_SHOP_ITEMPREVIEW setposATL [_pos select 0,_pos select 1,(_pos select 2)+1.2]; };
			case default { A3PL_SHOP_ITEMPREVIEW setposATL [_pos select 0,_pos select 1,(_pos select 2)+0.9]; };
		};
		if ((typeName _posConfig) isEqualTo "OBJECT") then { A3PL_SHOP_ITEMPREVIEW setDir (getDir _posConfig); };
	};

	switch (_type) do
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

	if (_itemType IN ["item","magazine"]) then
	{
		_control = _display displayCtrl 1400;
		_control ctrlSetText "1";
		_control ctrlSetFade 0;
		_control ctrlCommit 0;
		_control = _display displayCtrl 1000;
		_control ctrlSetFade 0;
		_control ctrlCommit 0;
	} else
	{
		_control = _display displayCtrl 1400;
		_control ctrlSetFade 1;
		_control ctrlCommit 0;
		_control = _display displayCtrl 1000;
		_control ctrlSetFade 1;
		_control ctrlCommit 0;
	};
}] call compile_Global;
