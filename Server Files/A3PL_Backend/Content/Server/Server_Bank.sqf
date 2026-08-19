/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/

["Server_Bank_BuyBankAccount", {
	private["_mode","_unit","_exit","_charID","_query","_nb","_nbdb","_count"];
	_mode = _this select 0;
	_unit = _this select 1;
	_exit = false;
	_query = "";

	private _charID = _unit getVariable["character_id",""];

	switch (_mode) do {
		case 0 : {
			_nb = random[10000000, 50000000, 99999999];
			_nbdb = [_nb] call CBA_fnc_formatNumber;
			_count = ([format["SELECT COUNT(*) FROM players WHERE numacc='%1'",_nbdb],2] call Server_Database_Async) select 0;
			if (_count > 0) exitWith {_exit = true;};
			_query = format["UPDATE players SET numacc='%2', bankactive='1' WHERE charid='%1'",_charID,_nbdb];
			_unit setVariable["Player_NumAcc",_nb,true];

		};
		case 1 : {_query = format["UPDATE players SET savingsaccountactive='1' WHERE charid='%1'",_charID];};
		case 2 : {_query = format["UPDATE players SET certificateofdepositactive='1' WHERE charid='%1'",_charID];};
	};
	if (_exit) exitWith {[_mode,_unit] call Server_Bank_BuyBankAccount;};

	[_query,1] call Server_Database_Async;

	[3] remoteExecCall ["A3PL_Bank_updateCompteBancaire",_unit];
}] call compile_Server;

["Server_Bank_cbParametre", {
	private["_unit","_mode"];
	_unit = _this select 0;
	_mode = _this select 1;

	private _charID = _unit getVariable["character_id",""];

	[format["UPDATE players SET activecb='%2' WHERE charid='%1'",_charID,_mode],1] call Server_Database_Async;
}] call compile_Server;

["Server_Bank_transferExtCompteBancaire", {
	private["_tcharID","_xcharID","_tBank","_numacc","_number","_raison","_query","_result","_unit","_mycharID","_unitcible","_exit"];
	_numacc = _this select 0;
	_unit = _this select 1;
	_number = _this select 2;
	_exit = false;
	_raison = 0;

	_query = format["SELECT charid, bank FROM players WHERE numacc='%1'",_numacc];
	_result = [_query,2] call Server_Database_Async;

	_mycharID = _unit getVariable["character_id",""];

	if ((count _result) > 0) then {

		_tcharID = _result select 0;
		_tBank = _result select 1;
		if (_tcharID isEqualTo _mycharID) exitWith {_exit = true; _raison = 1;};
		_tBank = _tBank + _number;
		[format["UPDATE players SET bank='%1' WHERE charid='%2'",_tBank,_tcharID],1] call Server_Database_Async;
		[_numacc,_number] remoteExecCall ["A3PL_Bank_afterTransferCompteBancaire",_unit];
	} else {
		_exit = true;
	};
	if (_exit) exitWith {[_raison] remoteExecCall ["A3PL_Bank_badTransferCompteBancaire",_unit];};

	_exit = false;
	{
		_xcharID = _x getVariable["character_id",""];
		if (_xcharID isEqualTo _tcharID) exitWith {
		_unitcible = _x;
		_exit = true;
		};
	} forEach playableUnits;
	if (!_exit) exitWith {};

	_mynumacc = ([format["SELECT numacc FROM players WHERE charid='%1'",_mycharID],2] call Server_Database_Async) select 0;
	[_number,_mynumacc] remoteExecCall ["A3PL_Bank_infoTransferCompteBancaire",_unitcible];
}] call compile_Server;

["Server_Bank_updateLimitCB", {
	params [["_value",0,[0]],["_unit",objNull,[objNull]]];
	private _value = [_value] call Server_Database_NumberSafe;
	private _charID = _unit getVariable["character_id",""];
	private _query = format["UPDATE players SET limitcb='%1' WHERE charid='%2'",_value,_charID];
	if(_query isEqualTo "") exitWith {};
	[_query,1] call Server_Database_Async;
}] call compile_Server;

["Server_Bank_getLimitCB", {
	params [["_unit",objNull,[objNull]]];
	private _charID = _unit getVariable["character_id",""];
	private _query = format ["SELECT limitcb FROM players WHERE charid='%1'",_charID];
	private _result = [_query,2] call Server_Database_Async;
	private _limitCB = 0;
	if (count _result > 0) then {
		_limitCB = _result select 0;
		if (!(_limitCB isEqualType 0)) then {_limitCB = 0;};
	};
	_unit setVariable ["Player_LimitCB",_limitCB,true];
}] call compile_Server;