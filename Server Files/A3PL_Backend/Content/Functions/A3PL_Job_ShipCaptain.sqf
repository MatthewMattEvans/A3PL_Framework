/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_JobShipCaptain_RentVehicle",
{
	private _location = param [0,player_objintersect];
	private _class = param[1,Job_ShipCaptain_LCM_Classname];
	private _price = param[2,Job_ShipCaptain_Price];
	private _job = player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];

	if(_job != ("STR_Common_Job_Captain" call A3PL_Localize)) exitWith {[("STR_A3PL_Job_ShipCaptain_GoToJobCenter" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	/* START HOW TO PAY */
	player setVariable ["paymentResult",objNull];
	[_price] call A3PL_Bank_HowToPay;
	waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
	if (!(player getVariable "paymentResult")) exitWith {};
	/* END HOW TO PAY */
	[("STR_A3PL_Job_ShipCaptain_BoatAvailable" call A3PL_Localize),Color_Green] call A3PL_Notification;
	private _spawnLoc = switch(_location) do {
		case npc_ship_captain_1: {[3582.857,7678.292,2.5]};
		case npc_ship_captain_2: {[5794.51,7264.18,2.5]};
		case npc_ship_captain_3: {[2054.78,5204.74,2.5]};
		default {[2353.047,5479.137,0.766]};
	};
	[_class,_spawnLoc,("STR_Common_Job_Captain" call A3PL_Localize),_price] spawn A3PL_Lib_JobVehicle_Assign;
}] call compile_Global;
