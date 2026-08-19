/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/

["A3PL_Robberies_Dealership", {
	params [["_dealership",objNull,[objNull]]];

	private _fisd = [("STR_Common_FISD" call A3PL_Localize)] call A3PL_Lib_FactionPlayers;
	private _cooldown = missionNamespace getVariable ["DealershipRob",serverTime-Heist_DealerShip_Cooldown];
	if (player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) exitWith {[("STR_Common_CantHeistOnDuty" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if(count(_fisd) < Heist_DealerShip_Min_Cops) exitwith {[format[("STR_A3PL_Heist_Dealership_NotEnoughCops" call A3PL_Localize),Heist_DealerShip_Min_Cops],Color_Red] call A3PL_Notification;};
	if (Player_ActionDoing) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if((serverTime-_cooldown) < Heist_DealerShip_Cooldown) exitWith {[("STR_A3PL_Heist_Dealership_AlreadyRobbed" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	missionNamespace setVariable ["DealershipRob",serverTime,true];
	[player_item] call A3PL_Inventory_Clear;
	[player,"usb_stick",-1] remoteExec ["Server_Inventory_Add",2];
	[getPlayerUID player,(player getVariable ["character_id",""]),"Robbery_Dealership_Start",[format ["Position: %1",(getPosATL _dealership)]]] remoteExec ["Server_Log_New",2];

	private _namePos = [getPos _dealership] call A3PL_Housing_PosAddress;
	[_dealership,("STR_Common_AlarmTriggered" call A3PL_Localize),"ColorWhite","A3FL_Markers_911Call"] remoteExec ["A3PL_Lib_CreateMarker",_fisd];
	[getPos _dealership] remoteExec ["A3PL_GPS_NavigateToPosition",_fisd];
	[("STR_Common_FISD" call A3PL_Localize),("STR_A3PL_Heist_Dealership_Robbery" call A3PL_Localize),getPos _dealership,format[("STR_A3PL_Heist_Dealership_RobberyReported" call A3PL_Localize),_namePos],("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];

	[_dealership] spawn {
		private _dealership = param [0,objNull];
		[("STR_A3PL_Heist_Dealership_VirusUploading" call A3PL_Localize),Heist_DealerShip_Timer] spawn A3PL_Lib_LoadActionQTE;
		waitUntil{Player_ActionDoing};
		while {Player_ActionDoing} do {
			if ((player distance2D _dealership) > 15) exitWith {[("STR_A3PL_Heist_Dealership_TooFarFromComputer" call A3PL_Localize),Color_Red] call A3PL_Notification; Player_ActionInterrupted = true;};
			if ((vehicle player) isNotEqualTo player) exitwith {Player_ActionInterrupted = true;};
			if (player getVariable ["Incapacitated",false]) exitwith {Player_ActionInterrupted = true;};
		};
		if(Player_ActionInterrupted) exitWith {
			[("STR_A3PL_Heist_Dealership_VirusUploadCanceled" call A3PL_Localize),Color_Red] call A3PL_Notification;
			[getPlayerUID player,(player getVariable ["character_id",""]),"Robbery_Dealership_Cancel",[format ["Position: %1",(getPosATL _dealership)]]] remoteExec ["Server_Log_New",2];
		};

		[_dealership, player] remoteExec ["Server_Criminal_DealershipRobbery",2];
	};
}] call compile_Global;

["A3PL_Robberies_DealershipPos", {
	params [["_location",[0,0,0],[[]]]];

	deleteMarkerLocal "dealerhsiprob_marker";
	private _marker = createMarkerLocal ["dealerhsiprob_marker",_location];
	_marker setMarkerTextLocal "Livraison des véhicules";
	_marker setMarkerColorLocal "ColorRed";
	_marker setMarkerTypeLocal "mil_warning";
	[_location] spawn A3PL_GPS_Navigate;
}] call compile_Global;

["A3PL_Robberies_DealershipDeliver", {
	private _nearbyCars = nearestObjects[player,["Car"],15];
	private _stolenCar = objNull;
	{
		if(_x getVariable["DealershipStolen",false]) exitwith {_stolenCar = _x;};
	} forEach _nearbyCars;
	if(isNull _stolenCar) exitwith {[("STR_A3PL_Heist_Dealership_NoStolenCarsNearby" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _typeOf = typeOf _stolenCar;
	private _carValue = [_typeOf] call A3PL_Config_GetVehicleMSRP;
	private _stolenTime = _stolenCar getVariable["StolenTime",0];
	private _receiveValue = if((serverTime-_stolenTime) > Heist_DealerShip_StolenTimer) then {_carValue * Heist_DealerShip_Coefficient_2} else {_carValue * Heist_DealerShip_Coefficient_1};

	private _pCash = player getVariable["Player_Cash",0];
	player setVariable["Player_Cash",_pCash+_receiveValue,true];

	[format[("STR_A3PL_Heist_Dealership_VehicleDelivered" call A3PL_Localize),[_receiveValue, 1, 0, true] call CBA_fnc_formatNumber],Color_Green] call A3PL_Notification;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Robbery_Dealership_Deliver",[format ["Vehicle: %1 | Time Taken: %2 seconds | CashReward: %3",_typeOf,_stolenTime,_receiveValue]]] remoteExec ["Server_Log_New",2];
	[_stolenCar] remoteExecCall ["Server_Criminal_StolenCarDelivered",2];
	deleteMarkerLocal "dealerhsiprob_marker";
}] call compile_Global;