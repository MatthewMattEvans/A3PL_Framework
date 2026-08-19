/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["Server_Dogs_BuyRequest", {
	params [
		["_player",objNull,[objNull]],
		["_class","",[""]]
	];

	private _pcash = _player getVariable["Player_Cash",0];
	private _price = 500;
	if(_pcash < _price) exitwith {[("STR_Server_Dog_DoNotHaveEnoughMoney" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification",_player];};
	[_player,"Player_Cash",(_pcash - _price)] call Server_Core_ChangeVar;
	[("STR_Common_SheriffsDepartment" call A3PL_Localize),_price] remoteExec ["Server_Government_AddBalance",2];
	[_class] remoteExec ["A3PL_Dogs_BuyReceive",(owner _player)];
}] call compile_Server;

["Server_Dogs_HandleLocality", {
	params [["_dog",objNull,[objNull]]];

	if (isNull _dog) exitwith {};
	_dog addEventHandler ["Local", {
		private _dog = _this select 0;
		private _local = _this select 1;
		if (_local) then {deleteVehicle _dog};
	}];
}] call compile_Server;
