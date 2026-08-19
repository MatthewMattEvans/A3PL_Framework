/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Fire_StartFire",
{
	private _position = param [0,[]];
	private _admin = param [1,false];
	private _dir = windDir;
	[_position,_dir,_admin] remoteExec ["Server_Fire_StartFire", 2];
}] call compile_Global;

["A3PL_Fire_Matches",
{
	if (player_itemClass != "matches") exitwith {[("STR_A3PL_Fire_NoMatches" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _fifr = [("STR_Common_FIFR" call A3PL_Localize)] call A3PL_Lib_FactionPlayers;
	if ((count(_fifr)) < FD_Members_Needed_To_Start_Fire) exitwith {[format[("STR_A3PL_Fire_NotEnoughFD" call A3PL_Localize),FD_Members_Needed_To_Start_Fire],Color_Red] call A3PL_Notification;};
	private _fisd = [("STR_Common_FISD" call A3PL_Localize)] call A3PL_Lib_FactionPlayers;
	if ((count _fisd) < SD_Members_Needed_To_Start_Fire) exitWith {[format[("STR_A3PL_Fire_NotEnoughFISD" call A3PL_Localize),SD_Members_Needed_To_Start_Fire],Color_Red] call A3PL_Notification;};

	private _matches = Player_Item;
	[player_itemClass,-1] call A3PL_Inventory_Add;
	Player_Item = objNull;
	Player_ItemClass = '';
	deleteVehicle _matches;

	private _pos = getPos player;
	private _dir = getDir player;
	private _firePos = [
		(_pos select 0) + (sin _dir * 1.5),
		(_pos select 1) + (cos _dir * 1.5),
		(_pos select 2)
	];

	["pyromane"] call PO_Achievement_Learn;

	[_firePos] call A3PL_Fire_StartFire;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Fire_Started",[format ["Location: %1",(getPosATL player)]]] remoteExec ["Server_Log_New",2];

    [("STR_Common_FIFR" call A3PL_Localize),("STR_A3PL_Fire_CriminalFire" call A3PL_Localize),getPos player,format[("STR_A3PL_Fire_CriminalFire_Reported" call A3PL_Localize)],("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
    [("STR_Common_FISD" call A3PL_Localize),("STR_A3PL_Fire_CriminalFire" call A3PL_Localize),getPos player,format[("STR_A3PL_Fire_CriminalFire_Reported" call A3PL_Localize)],("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
    [("STR_A3PL_Fire_CriminalFire_VFDCall" call A3PL_Localize)] call A3PL_FD_CallVFD;

    ["A3PL_Common\effects\firecall.ogg",150,2,10] spawn A3PL_FD_FireStationAlarm;
	
	private _marker = createMarker [format ["fire_%1",random 4000], position player];
	_marker setMarkerShape "ICON";
	_marker setMarkerType "A3FL_Markers_Fire";
	_marker setMarkerText ("STR_A3PL_Fire_FireMarker" call A3PL_Localize);
	_marker setMarkerColor "Default";
	
	uiSleep 600;
	deleteMarker _marker;
}] call compile_Global;
