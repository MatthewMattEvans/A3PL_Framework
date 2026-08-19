/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Business_Buy",
{
	disableSerialization;
	private _business = param [0,player_objintersect];
	if (typeOf _business isEqualTo "Land_A3PL_BusinessSign") then
	{
		_business = (nearestObjects [_business,Business_Objects,50]) select 0;
	};
	if (isNull _business) exitwith {["System Error: _business isNull in Business_Buy (Unable to determine business object)"] call A3PL_Notification;};

	createDialog "Dialog_BusinessRent";
	private _display = findDisplay 57;
	private _control = _display displayCtrl 1900;
	_control ctrlAddEventHandler ["KeyUp",{call A3PL_Business_BuyText}];
	call A3PL_Business_BuyText;
}] call compile_Global;

["A3PL_Business_Rent",
{
	disableSerialization;
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private _sign = (nearestObjects [player,["Land_A3PL_BusinessSign"],10]) select 0;
	private _business = (nearestObjects [_sign,Business_Objects,50]) select 0;
	if (isNil "_business") exitwith {["System Error: cannot locate the business, please look at the sign"] call A3PL_Notification;};
	if (isNull _business) exitwith {["System Error: _business isNull in Business_Rent (Unable to determine business object)"] call A3PL_Notification;};
	private _display = findDisplay 57;
	private _control = _display displayCtrl 1400;
	private _name = ctrlText _control;

	if ((count _name) < 5) exitwith {[("STR_A3PL_Business_NameTooShort" call A3PL_Localize)] call A3PL_Notification;};
	if ((count _name) > 30) exitwith {[("STR_A3PL_Business_NameTooLong" call A3PL_Localize)] call A3PL_Notification;};

	_display = findDisplay 57;
	_sControl = _display displayCtrl 1900;
	_rentTime = round (parseNumber(ctrlText _sControl));
	if(_rentTime <= Business_Min_Rent_Time) exitWith {[("STR_A3PL_Business_RentTimeInvalid" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if(_rentTime > Business_Max_Rent_Time) exitWith {[format[("STR_A3PL_Business_RentTimeTooLong" call A3PL_Localize),Business_Max_Rent_Time],Color_Red] call A3PL_Notification;};
	_rentCost = _rentTime * Business_Rent_Cost_Per_Minutes;

	private _pCash = player getVariable ["player_cash",0];
	if (_pCash < _rentcost) exitwith {[format[("STR_A3PL_Business_RentCostInsufficient" call A3PL_Localize),_rentcost-_pCash],Color_Red] call A3PL_Notification};
	if (_business getVariable ["bOwner",""] != "") exitwith {[("STR_A3PL_Business_OwnerExists" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	[player,_business,_name,_rentTime,_rentCost,_sign] remoteExec ["Server_Business_Buy", 2];
	closeDialog 0;
	[("STR_A3PL_Business_RentSigned" call A3PL_Localize),Color_Yellow] call A3PL_Notification;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Shop_Rented",[format ["Location: %1 | Time: %2 | Cost: %3",(getPosATL _business),_rentTime,_rentCost]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

["A3PL_Business_BuyText",
{
	disableSerialization;
	private _display = findDisplay 57;
	private _sControl = _display displayCtrl 1900;
	private _control = _display displayCtrl 1400;
	private _name = ctrlText _control;
	private _rentTime = round (parseNumber(ctrlText _sControl));
	private _rentCost = _rentTime * Business_Rent_Cost_Per_Minutes;
	_control = _display displayCtrl 1100;
	if(_rentTime <= 0) exitWith {_control ctrlSetStructuredText parseText ("STR_A3PL_Business_RentTimeInvalid" call A3PL_Localize);};
	_control ctrlSetStructuredText parseText format [("STR_A3PL_Business_RentCost" call A3PL_Localize),_rentCost, _rentTime];
}] call compile_Global;

["A3PL_Business_Sell",
{
	disableSerialization;
	private ["_display","_control"];
	private _obj = param [0,cursorObject];
	if (isNull _obj) exitwith {["System Error: _business isNull in Business_Buy (Unable to determine business object)"] call A3PL_Notification;};
	private _owner = _obj getVariable ["owner",nil];
	if (isNil "_owner") exitwith {["System Error: This item isn't owned by anyone (missing owner setVar)",Color_Red] call A3PL_Notification; };
	if (_owner isEqualType []) then {
		_owner = _owner select 0;
	};
	if ((player getVariable ["character_id",""]) != _owner) exitwith {[("STR_A3PL_Business_SellItemNotOwned" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	createDialog "Dialog_ItemSale";
	_display = findDisplay 58;
	_control = _display displayCtrl 1600;
	_control buttonSetAction format ["['%1'] call A3PL_Business_SellItem;",_obj];
	_control = _display displayCtrl 1601;
	_control buttonSetAction format ["['%1'] call A3PL_Business_SellItemStop;",_obj];
}] call compile_Global;

["A3PL_Business_SellItem",
{
	disableSerialization;
	private _obj = param [0,objNull];
	if (_obj isEqualType "") then
	{
		{
			_check = format ["%1",_x];
			if (_check == _obj) exitwith
			{
				_obj = _x;
			};
		} foreach (nearestObjects [player, [], 20]);
	};
	if (_obj isEqualType "") exitwith {["System: Error occured in Business_SellItem, could not retrieve object",Color_Red] call A3PL_Notification;};
	private _bItem = _obj getVariable["bItem",nil];
	if !(isNil "_bItem") exitWith {[("STR_A3PL_Business_SellItemAlreadyListed" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _display = findDisplay 58;
	private _control = _display displayCtrl 1400;
	private _name = ctrlText _control;
	private _sControl = _display displayCtrl 1900;
	private _price = round (parseNumber(ctrlText _sControl));
	if (count _name < 3) exitwith {[("STR_A3PL_Business_DescriptionTooShort" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (count _name > 30) exitwith {[("STR_A3PL_Business_DescriptionTooLong" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_price < 1) exitWith {[("STR_A3PL_Business_InvalidPrice" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	[player,_obj,_name,_price] remoteExec ["Server_Business_Sellitem", 2];
	closeDialog 0;
	[("STR_A3PL_Business_SellItem" call A3PL_Localize),Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Business_SellItemStop",
{
	disableSerialization;
	private _obj = param [0,objNull];
	if (_obj isEqualType "") then
	{
		{
			_check = format ["%1",_x];
			if (_check == _obj) exitwith
			{
				_obj = _x;
			};
		} foreach (nearestObjects [player, [], 20]);
	};
	if (_obj isEqualType "") exitwith {["System: Error occured in Business_SellItem, could not retrieve object",Color_Red] call A3PL_Notification;};
	private _bItem = _obj getVariable ["bitem",nil];
	if (isNil "_bItem") exitwith {[("STR_A3PL_Business_ItemNotForSale" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((player getVariable ["character_id",""]) != (_bItem select 2)) exitwith {[("STR_A3PL_Business_NotItemSeller" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_obj setVariable ["bItem",nil,true];
	closeDialog 0;
	[("STR_A3PL_Business_SellItemStop" call A3PL_Localize),Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Business_BuyItemReceive",
{
	private _reply = param [0,-1];
	private _msg = switch (_reply) do {
		case (0): {[format [("STR_A3PL_Business_ItemSoldFor" call A3PL_Localize),(param [1,0])],Color_green];};
		case (1): {[("STR_A3PL_Business_ItemBought" call A3PL_Localize),Color_green];};
		default {["Error: Undefined _reply in _BuyItemReceive",Color_Red]};
	};
	_msg call A3PL_Notification;
}] call compile_Global;

["A3PL_Business_BuyItem",
{
	disableSerialization;
	private _obj = param [0,cursorobject];
	if (isNull _obj) exitwith {["System: Object is null in _BuyItem (Couldn't find item)",Color_Red] call A3PL_Notification;};
	private _bItem = _obj getVariable ["bitem",nil];
	if (isNil "_bItem") exitwith {["System: This item isn't being sold (missing setVar)",Color_Red] call A3PL_Notification;};
	createDialog "Dialog_ItemBuy";
	private _display = findDisplay 59;
	private _price = _bItem select 0;
	private _name = _bItem select 1;

	_control = _display displayCtrl 1100;
	_control ctrlSetStructuredText parseText format ["<t font='PuristaSemiBold' align='center'>%1</t>",_name];
	_control = _display displayCtrl 1101;
	_control ctrlSetStructuredText parseText format ["<t font='PuristaSemiBold' align='center'>$%1</t>",([_price, 1, 0, true] call CBA_fnc_formatNumber)];

	_control = _display displayCtrl 1601;
	_control ButtonSetAction format ["['%1'] call A3PL_Business_BuyItemBuy",_obj];
	_control = _display displayCtrl 1602;
	_control ButtonSetAction format ["['%1',true] call A3PL_Business_BuyItemBuy",_obj];
}] call compile_Global;

["A3PL_Business_BuyItemBuy",
{
	disableSerialization;
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private _obj = [(param [0,""])] call A3PL_Lib_vehStringToObj;
	if (_obj isEqualType "") exitwith {["System: Unable to determine object in _BuyItemBuy (report this)",Color_Red] call A3PL_Notification;};
	private _bItem = _obj getVariable ["bitem",nil];
	if (isNil "_bItem") exitwith {[("STR_A3PL_Business_ItemNotForSale" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _price = _bItem select 0;
	private _name = _bItem select 1;
	private _itemOwner = _bItem select 2;
	/* START HOW TO PAY */
    [_price,_obj] spawn {
		params["_price","_obj"];
		private _paymentResult = [_price] call A3PL_Bank_HowToPay;
   		waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
  		if (!(player getVariable "paymentResult")) exitWith {};
		[player,_obj] remoteExec ["Server_Business_BuyItem", 2];
		closeDialog 0;
	};
	/* END HOW TO PAY */
}] call compile_Global;
