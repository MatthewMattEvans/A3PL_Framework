/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
['Server_Uber_AddDriver',
{
    params[["_user",objNull,[objNull]]];
    private _curJob = _user getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
    if(!(_user in A3PL_Uber_Drivers)) then {
        A3PL_Uber_Drivers pushBack _user;
    };
    [_user,("STR_Common_Job_Uber" call A3PL_Localize)] call Server_NPC_RequestJob;
}] call compile_Server;

['Server_Uber_FlushDrivers',
{
    {
        if (isNull _x) then {A3PL_Uber_Drivers deleteAt _forEachIndex;};
    } forEach A3PL_Uber_Drivers;
}] call compile_Server;

['Server_Uber_RemoveDriver',
{
    params[["_user",objNull,[objNull]]];
    if(_user in A3PL_Uber_Drivers) then {
        private _id = A3PL_Uber_Drivers find _user;
        A3PL_Uber_Drivers deleteAt _id;
    };
    [_user,("STR_Common_Job_Unemployed" call A3PL_Localize)] call Server_NPC_RequestJob;
}] call compile_Server;

['Server_Uber_RequestDriver',
{
    private ["_user"];
    params[["_user",objNull,[objNull]]];

    call Server_Uber_flushDrivers;
    if(count A3PL_Uber_Drivers < 1) then {
        [("STR_Server_Job_Uber_NoUberAvailable" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _user];
    } else {
        [("STR_Server_Job_Uber_YouAskForUber" call A3PL_Localize), Color_Green] remoteExec ["A3PL_Notification", _user];
        {
            [_user] remoteExec ["A3PL_Uber_RecieveRequest", _x];
        } forEach A3PL_Uber_Drivers;
    };
}] call compile_Server;
