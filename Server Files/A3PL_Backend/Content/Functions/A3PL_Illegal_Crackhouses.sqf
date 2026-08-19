/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Crackhouses_OpenBuyMenu",
{
	disableSerialization;
	private _obj = param [0,objNull];
	if (isNull _obj) exitwith {};
	private _crackhouses = nearestObjects [player, Config_Crackhouses_List, 20];
	if (count _crackhouses < 1) exitwith {[("STR_A3PL_Illegal_Crackhouses_ErrorFindHouse" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_group = group player;
	_gang = _group getVariable ["gang_data",nil];
	A3PL_Crackhouses_Object = _crackhouses select 0;
	private _price = [A3PL_Crackhouses_Object,0] call A3PL_Crackhouses_GetData;
 	createDialog "Dialog_CrackhouseBuy";
	private _display = findDisplay 75;
	private _control = _display displayCtrl 1000;
	_control ctrlSetText format ["%1",[_price, 1, 2, true] call CBA_fnc_formatNumber];
}] call compile_Global;

["A3PL_Crackhouses_Buy",
{
	private _crackhouses = nearestObjects [player, Config_Crackhouses_List, 20];
	private _pCash = player getVariable ["player_cash",0];
	if (count _crackhouses < 1) exitwith {[("STR_A3PL_Illegal_Crackhouses_ErrorFindHouse" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	A3PL_Crackhouses_Object = _crackhouses select 0;
	private _price = [A3PL_Crackhouses_Object,0] call A3PL_Crackhouses_GetData;
	private _level = [A3PL_Crackhouses_Object,3] call A3PL_Crackhouses_GetData;
	if (_price > _pCash) exitWith {[("STR_A3PL_Illegal_Crackhouses_NotEnoughCash" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!isNil {A3PL_Crackhouses_Object getVariable ["doorid",nil]}) exitwith {[("STR_A3PL_Illegal_Crackhouses_AlreadyOwnedBySomeone" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!isNil {player getVariable ["crackhouse",nil]}) exitwith {[("STR_A3PL_Illegal_Crackhouses_AlreadyHasCrackhouse" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	
	[A3PL_Crackhouses_Object,player,true,_price] remoteExec ["Server_Crackhouses_Assign", 2];
	closeDialog 0;
	_namePos = [getPos A3PL_Crackhouses_Object] call A3PL_Housing_PosAddress;
	[format [("STR_A3PL_Illegal_Crackhouses_YouBoughtFor" call A3PL_Localize),_price,_namePos],Color_Green] call A3PL_Notification;
	[("STR_Common_FederalReserve" call A3PL_Localize),_price] remoteExec ["Server_Government_AddBalance",2];
	[A3PL_Crackhouses_Object] spawn
	{
		private _crackhouse = param [0,objNull];
		private _marker = createMarkerLocal [format["crackhouse_%1",round (random 1000)],visiblePosition _crackhouse];
		_marker setMarkerTypeLocal "A3FL_Markers_OwnedWarehouse";
		_marker setMarkerSizeLocal [0.7, 0.7];
		_marker setMarkerAlphaLocal 1;
		_marker setMarkerColorLocal "Default";
		_marker setMarkerTextLocal (format [("STR_A3PL_Illegal_Crackhouses_Marker" call A3PL_Localize),toUpperANSI((_crackhouse getVariable ["doorid",["1",("STR_Common_Unknown" call A3PL_Localize)]]) select 1)]);
	};
	[getPlayerUID player,(player getVariable ["character_id",""]),(player getVariable ["character_id",""]),"Crackhouse_Bought",[format ["Price: %1 | Location: %2",_price,getPosATL A3PL_Crackhouses_Object]]] remoteExec ["Server_Log_New",2];
	A3PL_Crackhouses_Object = nil;
}] call compile_Global;

["A3PL_Crackhouses_Init",
{
	private ["_keys","_doorID","_keyID","_buildings","_marker","_text","_apt","_aptNumber"];
	waituntil {sleep 1; _keys = player getVariable "keys"; !isNil "_keys"};
	_keys = ["crackhouse"] call A3PL_Housing_keyFilter;
	_buildings = nearestObjects [[5000,5000,0], Config_Crackhouses_List, 5000];
	{
		_doorID = _x getVariable "doorID";
		if (!isNil "_doorID") then
		{
			if ((_doorID select 1) IN _keys) then
			{
				_marker = createMarkerLocal [format["crackhouse_%1",round (random 1000)],visiblePosition _x];
				_marker setMarkerTypeLocal "A3FL_Markers_OwnedWarehouse";
				_marker setMarkerSizeLocal [0.7, 0.7];
				_marker setMarkerAlphaLocal 1;
				_marker setMarkerColorLocal "Default";
				_marker setMarkerTextLocal (format [("STR_A3PL_Illegal_Crackhouses_Marker" call A3PL_Localize),toUpperANSI(_doorID select 1)]);
			};
		};
	} foreach _buildings;
}] call compile_Global;

["A3PL_Crackhouses_SetMarker",
{
	private _crackhouse = param [0,objNull];
	private _marker = createMarkerLocal [format["crackhouse_%1",round (random 1000)],visiblePosition _crackhouse];
	_marker setMarkerTypeLocal "A3FL_Markers_OwnedWarehouse";
	_marker setMarkerSizeLocal [0.7, 0.7];
	_marker setMarkerAlphaLocal 1;
	_marker setMarkerColorLocal "Default";
	_marker setMarkerTextLocal (format [("STR_A3PL_Illegal_Crackhouses_Marker" call A3PL_Localize),toUpperANSI((_crackhouse getVariable ["doorid",["1",("STR_Common_Unknown" call A3PL_Localize)]]) select 1)]);
}] call compile_Global;

["A3PL_Crackhouses_GetData",
{
	private _wh = param [0,objNull];
	private _dataIndex = param [1,0];
	private _whMap = Config_Crackhouses_Data;
	private _whData = _whMap get (typeOf _wh);
	private _return = _whData#_dataIndex;
	_return;
}] call compile_Global;

["A3PL_Crackhouses_SellOpen",
{
	disableSerialization;
	private _sign = param[0,objNull];
	if(isNull _sign) exitWith {};
	private _near = nearestObjects [player, Config_Crackhouses_List, 30,true];
	if(count(_near) isEqualTo 0) exitWith {[("STR_A3PL_Illegal_Crackhouses_NoNear" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _crackhouse = _near select 0;
	private _owners = _crackhouse getVariable ["owner",[]];
	if(count _owners isEqualTo 0) exitwith {};
	private _owner = _owners select 0;
	if((player getVariable ["character_id",""]) isEqualTo _owner) then {
		createDialog "Dialog_EstateSell";
		private _display = findDisplay 67;
		private _price = ([_crackhouse,0] call A3PL_Crackhouses_GetData) * 0.75;
		private _control = _display displayCtrl 1100;
		_control ctrlSetStructuredText parseText format ["<t align='left'>$%1</t>",[_price, 1, 0, true] call CBA_fnc_formatNumber];
		buttonSetAction [100, "call A3PL_Crackhouses_Sell;"];		
	} else {
		[("STR_A3PL_Illegal_Crackhouses_OnlyOwnerCanSell" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};
}] call compile_Global;

["A3PL_Crackhouses_Sell",
{
	closeDialog 0;
	private _sign = (nearestObjects [player, ["Land_A3PL_BusinessSign"], 10,true]) select 0;
	private _crackhouse = (nearestObjects [player, Config_Crackhouses_List, 30,true]) select 0;
	private _whPrice = ([_crackhouse,0] call A3PL_Crackhouses_GetData) * 0.75;
	[getPos player,_whPrice, _sign, _crackhouse] remoteExec ["Server_Crackhouses_Sold",2];
	private _marker = [getPos _crackhouse, "crackhouse"] call A3PL_Lib_NearestMarker;
	deleteMarkerLocal _marker;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Crackhouse_Sold",[format ["Price: %1 | Location: %2",_whPrice,(getPosATL _crackhouse)]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

["A3PL_Crackhouse_Raid",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private _buildings = nearestObjects [player, Config_Crackhouses_List, 10];
	if (count _buildings isEqualTo 0) exitWith {[("STR_A3PL_Housing_RaidNoBuilding" call A3PL_Localize), Color_Red] call A3PL_Notification;};
	private _crackhouse = _buildings#0;

	private _action = [("STR_A3PL_Housing_RaidConfirm" call A3PL_Localize)] call A3PL_Lib_ConfirmationDialog;
	if (!isNil "_action" && {!_action}) exitWith {};

	if (Player_ActionDoing) exitWith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[("STR_A3PL_Housing_RaidProgress" call A3PL_Localize), 30] spawn A3PL_Lib_LoadActionQTE;
	waitUntil{Player_ActionDoing};
	while {Player_ActionDoing} do {
		if (!(player getVariable["A3PL_Medical_Alive",true])) exitWith {Player_ActionInterrupted = true;};
		if ((vehicle player) != player) exitWith {Player_ActionInterrupted = true;};
		if (player getVariable ["Incapacitated",false]) exitWith {Player_ActionInterrupted = true;};
	};
	if(Player_ActionInterrupted) exitWith {};

	if (random 1 < Raid_Alert_Chance) then {
		private _owners = _crackhouse getVariable ["owner",[]];
		{
			private _ownerPlayer = [_x] call A3PL_Lib_charIDToObject;
			if (!isNull _ownerPlayer) then {
				[("STR_A3PL_Housing_RaidAlert" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _ownerPlayer];
			};
		} forEach _owners;
	};

	[player, _crackhouse] remoteExec ["Server_Crackhouses_LoadBox", 2];
	[("STR_A3PL_Housing_RaidComplete" call A3PL_Localize), Color_Green] call A3PL_Notification;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Crackhouse_Raid",[format ["Crackhouse: %1 | Location: %2",typeOf _crackhouse,getPosATL _crackhouse]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;
