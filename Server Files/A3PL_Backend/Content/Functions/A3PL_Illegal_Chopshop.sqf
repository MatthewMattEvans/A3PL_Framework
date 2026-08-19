/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Chopshop_Chop",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private _cars = nearestObjects [player, ["Car","Plane","Air"], 20];
	private _car = _cars select 0;
	private _id = (_car getVariable ["owner",0]) select 1;

	if (_id IN Garage_Default_Plate) exitWith {[("STR_A3PL_Chopshop_CantSellThisCar" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((count _cars) < 1) exitWith {[("STR_A3PL_Chopshop_NotUnlocked" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((typeOf _car) isEqualTo "A3PL_CVPI_Rusty") exitWith {[("STR_A3PL_Chopshop_CantSellThisCar2" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	[_car,player] remoteExec ["Server_Chopshop_Chop",2];
}] call compile_Global;
