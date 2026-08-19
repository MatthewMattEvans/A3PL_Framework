/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/

["A3PL_Karts_Rent",
{
	if ((player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) == ("STR_Common_Vehicle_Plate_Karting" call A3PL_Localize)) exitwith {[("STR_A3PL_Activity_Karts_StopKartRenting" call A3PL_Localize),Color_red]; call A3PL_NPC_LeaveJob};
	if (!(player inArea "A3PL_Marker_SallySpeedway")) exitwith {[("STR_A3PL_Activity_Karts_TooLongFromKart" call A3PL_Localize)] call A3PL_Notification;};
	["karting"] call A3PL_NPC_TakeJob;
	["C_Kart_01_F",(getpos player),"KARTING","A3PL_Marker_SallySpeedway"] spawn A3PL_Lib_JobVehicle_Assign;
	[("STR_A3PL_Activity_Karts_YouRentKart" call A3PL_Localize),Color_Green] call A3PL_Notification;
    [getPlayerUID player,(player getVariable ["character_id",""]),"Vehicle_Kart_Rent","Karting Rental"] remoteExec ["Server_Log_New",2];
    ["karting"] call PO_Achievement_Learn;
}] call compile_Global;
