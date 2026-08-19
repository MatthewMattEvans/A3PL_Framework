/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Locker_Rent",
{
	private _locker = _this select 0;
	private _action = [format[("STR_A3PL_Locker_BuyConfirmationDialog" call A3PL_Localize)]] call A3PL_Lib_ConfirmationDialog;
	if (!isNil "_action" && {!_action}) exitWith {[("STR_A3PL_Locker_BuyCanceled" call A3PL_Localize),Color_Green] call A3PL_Notification;};
	[_locker, player] remoteExec ["Server_Locker_Insert", 2];
}] call compile_Global;

["A3PL_Locker_Sell",
{
	private _locker = _this select 0;
	private _action = [format[("STR_A3PL_Locker_SellConfirmationDialog" call A3PL_Localize)]] call A3PL_Lib_ConfirmationDialog;
	if (!isNil "_action" && {!_action}) exitWith {[("STR_A3PL_Locker_SellCanceled" call A3PL_Localize),Color_Green] call A3PL_Notification;};
	[_locker, player] remoteExec ["Server_Locker_Sell", 2];
}] call compile_Global;
