/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3FL_Crack_PlacePot",
{
    // private _trailer = nearestObjects [getPos player,["Land_A3FL_Trailer","Land_A3FL_Trailer_2","Land_A3FL_Trailer_3","Land_A3FL_Trailer_4","Land_A3FL_Trailer_5","Land_A3FL_Trailer_6"],10];

	// if (count(_trailer) isEqualTo 0) exitWith {[("STR_Common_Mobilhome" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	// private _chid = ((_trailer#0) getVariable ["doorid",[[],""]])#1;
	// if (!(_chid IN (player getVariable "keys"))) exitWith {[("STR_Common_MobilhomeOwnership" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    private _stove = param [0,objNull];
	private _potCount = count (attachedobjects _stove);
	private _pot = Player_Item;
	if (_potCount >= 1) exitWith {[("STR_A3PL_Crack_PotLimit" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _moderns = ["A3FL_Modern_Range_White","A3FL_Modern_Range_Red","A3FL_Modern_Range_Black"];
	private _notModerns = ["A3FL_Range_Silver","A3FL_Range_Black","A3FL_Range_DarkGray"];
	if ((typeOf _stove) IN _moderns) exitWith {
		detach _pot;
		[false] call A3PL_Inventory_Drop;
		_pot attachTo [_stove,[-0.1,0,0.08],"cooktop"];
		[("STR_A3PL_Crack_PotPlaced" call A3PL_Localize),Color_Green] call A3PL_Notification;
	};
	if ((typeOf _stove) IN _notModerns) exitWith {
		detach _pot;
		[false] call A3PL_Inventory_Drop;
		_pot attachTo [_stove,[-0.1,0,0.06],"cooktop"];
		[("STR_A3PL_Crack_PotPlaced" call A3PL_Localize),Color_Green] call A3PL_Notification;
	};
}] call compile_Global;

["A3FL_Crack_AddItem",
{
	// if (!(call A3PL_Player_AntiSpam)) exitWith {};
    // private _trailer = nearestObjects [getPos player,["Land_A3FL_Trailer","Land_A3FL_Trailer_2","Land_A3FL_Trailer_3","Land_A3FL_Trailer_4","Land_A3FL_Trailer_5","Land_A3FL_Trailer_6"],10];

	// if (count(_trailer) isEqualTo 0) exitWith {[("STR_Common_Mobilhome" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	// private _chid = ((_trailer#0) getVariable ["doorid",[[],""]])#1;
	// if (!(_chid IN (player getVariable "keys"))) exitWith {[("STR_Common_MobilhomeOwnership" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    private _pot = param [0,objNull];
	private _item = Player_ItemClass;
	private _amount = Player_ItemAmount;

	if (_item isEqualTo "bakingsoda") then {
		_pot setVariable ["bakingsoda",_amount,true];
	};
	if (_item isEqualTo "cocaine_hydrochloride") then {
		_pot setVariable ["hydrochloride",_amount,true];
	};

	[Player_ItemClass,-_amount] call A3PL_Inventory_Add;
	[false] call A3PL_Inventory_PutBack;
	[format [("STR_A3PL_Crack_AddedItem" call A3PL_Localize),[_item,"name"] call A3PL_Config_GetItem],Color_Green] call A3PL_Notification;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Crack_AddItem",[format["Item added to the barrel: %1",([_item,"name"] call A3PL_Config_GetItem)]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

["A3FL_Crack_CheckContents",
{
	if (!(call A3PL_Player_AntiSpam)) exitWith {};
    // private _trailer = nearestObjects [getPos player,["Land_A3FL_Trailer","Land_A3FL_Trailer_2","Land_A3FL_Trailer_3","Land_A3FL_Trailer_4","Land_A3FL_Trailer_5","Land_A3FL_Trailer_6"],10];

	// if (count(_trailer) isEqualTo 0) exitWith {[("STR_Common_Mobilhome" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	// private _chid = ((_trailer#0) getVariable ["doorid",[[],""]])#1;
	// if (!(_chid IN (player getVariable "keys"))) exitWith {[("STR_Common_MobilhomeOwnership" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    private _pot = param [0,objNull];
	private _amtBakingSoda = _pot getVariable ["bakingSoda",0];
	private _amtHydrochloride = _pot getVariable ["hydrochloride",0];

	[format [("STR_A3PL_Crack_CheckContents" call A3PL_Localize),_amtBakingSoda,_amtHydrochloride],Color_Yellow] call A3PL_Notification;
}] call compile_Global;

["A3FL_Crack_Produce",
{
	//
}] call compile_Global;

["A3FL_Crack_Collect",
{
	//
}] call compile_Global;

["A3FL_Crack_Reset",
{
	if (!(call A3PL_Player_AntiSpam)) exitWith {};
    // private _trailer = nearestObjects [getPos player,["Land_A3FL_Trailer","Land_A3FL_Trailer_2","Land_A3FL_Trailer_3","Land_A3FL_Trailer_4","Land_A3FL_Trailer_5","Land_A3FL_Trailer_6"],10];

	// if (count(_trailer) isEqualTo 0) exitWith {[("STR_Common_Mobilhome" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	// private _chid = ((_trailer#0) getVariable ["doorid",[[],""]])#1;
	// if (!(_chid IN (player getVariable "keys"))) exitWith {[("STR_Common_MobilhomeOwnership" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    private _pot = param [0,objNull];
	private _forceReset = param [1,false];
	_pot setVariable ["bakingsoda",0,true];
	_pot setVariable ["hydrochloride",0,true];
	
	if (!_forceReset) then {
		[("STR_A3PL_Crack_PotRemoved" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};
}] call compile_Global;
