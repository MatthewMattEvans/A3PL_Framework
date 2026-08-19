/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Combine_Open",
{
	disableSerialization;
	private ["_display","_control"];
	createDialog "Dialog_CombineItems";
	_display = findDisplay 9;
	_display call A3PL_Dialog_Localize;
	_control = _display displayCtrl 1500;
	_items = param [0,["burger_full_cooked","taco_cooked"]]; 

	{
		private ["_name","_index"];
		_name = [_x,"name"] call A3PL_Config_GetItem;
		_index = _control lbAdd _name;
		_control lbSetData [_index,_x];
	} foreach _items;

	_control ctrlAddEventHandler ["LBSelChanged",
	{
		private ["_selectedIndex","_class","_required","_output","_control"];
		_selectedIndex = param [1,-1];
		_control = param [0,ctrlNull];
		if (_selectedIndex < 0) exitwith {}; 
		_class = _control lbData (lbCurSel _control);

		_required = [];
		{
			if ((_x select 0) == _class) exitwith {_required = _x select 1; _output = _x select 2;};
		} foreach Config_CombineItems;
		if (count _required < 1) exitwith {};

		A3PL_Combine_ItemSelected = _class;
		A3PL_Combine_ItemRequired = _required;

		_control = (findDisplay 9) displayCtrl 1501;
		lbClear _control;
		{
			private ["_index"];
			_index = _control lbAdd ([_x,"name"] call A3PL_Config_GetItem);
			_control lbSetData [_index,_x];

			if ([_x] call A3PL_Inventory_Has) then
			{
				_control lbSetColor [_index,[0, 1, 0, 1]];
			} else
			{
				_control lbSetColor [_index,[1, 0, 0, 1]];
			};
		} foreach _required;
	}];

	_control = _display displayCtrl 1600;
	_control ctrlAddEventHandler ["ButtonDown",
	{
		[] call A3PL_Combine_Create;
	}];
}] call compile_Global;

["A3PL_Combine_Create",
{
	disableSerialization;
	if(!([] call A3PL_Player_AntiSpam)) exitWith {};

	private ["_creating","_required","_haveItems","_amount","_output"];
	_creating = A3PL_Combine_ItemSelected;
	_required = A3PL_Combine_ItemRequired;

	_control = ctrlText ((findDisplay 9) displayCtrl 1400);
	_amount = parseNumber _control;
	if (_amount < 1) exitwith {[("STR_Common_InvalidAmount" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_haveItems = true;
	{
		if (!([_x,_amount] call A3PL_Inventory_Has)) exitwith {_haveItems = false};
	} foreach _required;
	if (!_haveItems) exitwith {[("STR_A3PL_Combine_NoItems" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if (([[_creating,_amount]] call A3PL_Inventory_TotalWeight) > Player_MaxWeight) exitwith {
		[("STR_Common_NotEnoughSpace" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};

	{
		[_x,-(_amount)] call A3PL_Inventory_Add;
	} foreach _required;

	_output = 0;
	{
		if ((_x select 0) == _creating) exitwith {_output = _x select 2};
	} foreach Config_CombineItems;
	if (_output < 1) exitwith {["System Error: Unable to set _output in A3PL_Combine_Create"] call A3PL_Notification;};

	["combine"] call PO_Achievement_Learn;
	[_creating,_amount] call A3PL_Inventory_Add;
	[format [("STR_A3PL_Combine_Success" call A3PL_Localize),([_creating,"name"] call A3PL_Config_GetItem),_amount],"green"] call A3PL_Notification;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Combine_Success",format["Fabrication: %1 | Montant: %2",_creating,_amount]] remoteExec ["Server_Log_New",2];
}] call compile_Global;