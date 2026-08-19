/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
['A3PL_Uber_AcceptRequest', {
    closeDialog 0;
    A3PL_Uber_JobActive = true;
    A3PL_Uber_CurrentJobPlayer = A3PL_Uber_ActiveRequest;

    deleteMarkerLocal "uber";

    private _marker = createMarkerLocal ["uber", A3PL_Uber_CurrentJobPlayer];
    _marker setMarkerShapeLocal "ICON";
    _marker setMarkerTypeLocal "mil_warning";
    _marker setMarkerTextLocal format [("STR_A3PL_Job_Uber_Asked" call A3PL_Localize)];
    _marker setMarkerColorLocal "ColorRed";
    [getPosATL A3PL_Uber_CurrentJobPlayer] spawn A3PL_GPS_Navigate;

    [("STR_A3PL_Job_Uber_PlayerMarkedOnMap" call A3PL_Localize),Color_Green] call A3PL_Notification;
    [("STR_A3PL_Job_Uber_YouCanStopTheJob" call A3PL_Localize),Color_Green] call A3PL_Notification;
    [("STR_A3PL_Job_Uber_UberAcceptedYourRequest" call A3PL_Localize), Color_green] remoteExec ["A3PL_Notification",A3PL_Uber_CurrentJobPlayer];
}] call compile_Global;

['A3PL_Uber_AddDriver', {
    [player] remoteExec ["Server_Uber_addDriver", 2];
}] call compile_Global;

['A3PL_Uber_EndJob', {
    A3PL_Uber_JobActive = false;
    deleteMarkerLocal "uber";
    A3PL_Uber_CurrentJobPlayer = nil;
}] call compile_Global;

['A3PL_Uber_RecieveRequest', {
    if (A3PL_Uber_JobActive) exitWith {};
    params[["_customer",objNull,[objNull]]];

    A3PL_Uber_ActiveRequest = _customer;

    closeDialog 0;
    createDialog "Dialog_UberAccept";
    (findDisplay 61) call A3PL_Dialog_Localize;
}] call compile_Global;

['A3PL_Uber_RemoveDriver', {
    if ((player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) isNotEqualTo ("STR_Common_Job_Uber" call A3PL_Localize)) exitwith {[("STR_A3PL_Job_Uber_YoureNotUber" call A3PL_Localize),Color_Red] call A3PL_Notification;};

    [player] remoteExec ["Server_Uber_removeDriver", 2];

    if (A3PL_Uber_JobActive) then {call A3PL_Uber_EndJob;};
}] call compile_Global;

['A3PL_Uber_RequestDriver', {
    [player] remoteExec ["Server_Uber_requestDriver",2];
    [("STR_A3PL_Job_Uber_Asked" call A3PL_Localize),Color_Red] call A3PL_Notification;
}] call compile_Global;
