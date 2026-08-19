/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/

["A3PL_Robberies_Evidence", {
	params [["_storage",objNull,[objNull]]];

	private _timer = false;
	if (!isNil {_storage getVariable ["timer",nil]}) then {
		if (((serverTime - (_storage getVariable ["timer",0]))) < Heist_Evidence_Timer) then {_timer = true};
	};
	if (player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) exitWith {[("STR_Common_CantHeistOnDuty" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_timer) exitwith {[format [("STR_A3PL_Heist_Evidence_Cooldown" call A3PL_Localize),Heist_Evidence_Timer - ((_bank getVariable ["timer",0]) - serverTime)],Color_Red] call A3PL_Notification;};
	if (vehicle player isNotEqualTo player) exitwith {[("STR_A3PL_Heist_Evidence_CantLockpickInVehicle" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (Player_ActionDoing) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _fisd = [("STR_Common_FISD" call A3PL_Localize)] call A3PL_Lib_FactionPlayers;
	if ((count _fisd) < Heist_Evidence_Min_Cops) exitwith {[format[("STR_A3PL_Heist_Evidence_NotEnoughCops" call A3PL_Localize),Heist_Evidence_Min_Cops],Color_Red] call A3PL_Notification;};

	private _pickingTime = Heist_Evidence_Lockpicking_Time;

	[("STR_A3PL_Heist_Evidence_DOCAttacked" call A3PL_Localize),("STR_A3PL_Heist_Evidence_NewsMessage" call A3PL_Localize),("STR_Common_FishersNews" call A3PL_Localize)] remoteExec ["A3PL_Player_News",-2];

	[("STR_A3PL_Heist_Evidence_LockpickingEvidenceLocker" call A3PL_Localize),_pickingTime] spawn A3PL_Lib_LoadActionQTE;
	[("STR_Common_FISD" call A3PL_Localize),("STR_A3PL_Heist_Evidence_Alarm" call A3PL_Localize),getPos A3FL_Seize_Storage,("STR_A3PL_Heist_Evidence_AlarmTriggered" call A3PL_Localize),("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
	[getPlayerUID player,(player getVariable ["character_id",""]),"Robbery_DOC_Start",[format ["Position: %1",(getPosATL _storage)]]] remoteExec ["Server_Log_New",2];
	if((random 100) >= Heist_Evidence_ChancesToActive_Lockdown) then {playSound3D ["A3PL_Common\effects\lockdown.ogg", objNull, false, [4783.52,6294.25,12], 3, 1, 1800];};
	waitUntil{Player_ActionDoing};
	while {Player_ActionDoing} do {
		if ((player distance2D _storage) > 5) exitWith {Player_ActionInterrupted = true;};
		if ((vehicle player) isNotEqualTo player) exitwith {Player_ActionInterrupted = true;};
		if !(player_itemClass isEqualTo "v_lockpick") exitwith {Player_ActionInterrupted = true;};
		if !(["v_lockpick",1] call A3PL_Inventory_Has) exitwith {Player_ActionInterrupted = true;};
	};
	player switchMove "";
	if(Player_ActionInterrupted) exitWith {
		[("STR_Common_LockpickingFailed" call A3PL_Localize),Color_Red] call A3PL_Notification;
		[getPlayerUID player,(player getVariable ["character_id",""]),"Robbery_DOC_Cancel",[format ["Position: %1",getPosATL _storage]]] remoteExec ["Server_Log_New",2];
	};

	[player_item] call A3PL_Inventory_Clear;
	[player,"v_lockpick",-1] remoteExec ["Server_Inventory_Add",2];

	private _chance = random 100;
	private _pickingChance = 40;
	if(_chance < _pickingChance) then {
		_storage setVariable["locked",false,true];
		_storage setVariable ["timer",serverTime,true];
		[("STR_A3PL_Heist_Evidence_Success" call A3PL_Localize),Color_Green] call A3PL_Notification;
		[getPlayerUID player,(player getVariable ["character_id",""]),"Robbery_DOC_Success",[format ["Position: %1",getPosATL _storage]]] remoteExec ["Server_Log_New",2];
	} else {
		[("STR_Common_LockpickingFailed" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};
}] call compile_Global;
