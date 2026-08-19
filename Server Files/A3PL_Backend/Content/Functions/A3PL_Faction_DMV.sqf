/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
//[player,'driver',true] remoteExec ["Server_DMV_Add",2];

["A3PL_DMV_Open",
{
	disableSerialization;
	private ["_display","_control","_nearPlayers"];
	createDialog "Dialog_DMV";
	_display = findDisplay 21;
	_control = _display displayCtrl 1500;

	_nearPlayers = [];
	{
		if ((player distance _x) < 10 && (_x getVariable ["character_id",""]) != (player getVariable ["character_id",""])) then {_nearPlayers pushback _x};
	} foreach allPlayers;
	{
		_index = _control lbAdd (format ["%1",(_x getVariable ["name",(name _x)])]);
		_control lbSetData [_index,(_x getVariable ["character_id",""])];
	} foreach _nearPlayers;

	_control ctrlAddEventHandler ["LBSelChanged",{_this call A3PL_DMV_LBChanged;}];

	_control = _display displayCtrl 1600;
	_control ctrlAddEventHandler ["ButtonDown",{[1] call A3PL_DMV_Add;}];
	_control = _display displayCtrl 1601;
	_control ctrlAddEventHandler ["ButtonDown",{[0] call A3PL_DMV_Add;}];

	_control = _display displayCtrl 2100;
	_pJob = player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
	{
		private _license = _x;
		private _licenseData = _y;
		private _id = _x;
		private _name = _licenseData select 0;
		private _type = _licenseData select 1;
		private _canIssue = _licenseData select 2;
		private _canRevoke = _licenseData select 3;
		private _showCondition = if ((count _licenseData) > 5) then {_licenseData select 5} else {true};
		if ((call _showCondition) && ((_pJob IN _canIssue) || {_pJob IN _canRevoke})) then {
			if(_type) then {
				_index = _control lbAdd format[("STR_A3PL_DMV_CompanyLicense" call A3PL_Localize),_name];
				_control lbSetData [_index,_id];
				_control lbSetValue [_index, parseNumber _type];
			} else {
				_index = _control lbAdd format[("STR_A3PL_DMV_PersonalLicense" call A3PL_Localize),_name];
				_control lbSetData [_index,_id];
				_control lbSetValue [_index, parseNumber _type];
			};
		};
	} foreach Config_Licenses;
}] call compile_Global;

["A3PL_DMV_LBChanged",
{
	private ["_display","_control","_index"];
	_display = findDisplay 21;
	_control = param [0,ctrlNull];
	_index = param [1,-1];
	_player = [(_control lbData _index)] call A3PL_Lib_charIDToObject;
	if (_index < 0) exitwith {};
	if (isNull _player) exitwith {};

	_control = _display displayCtrl 1501;
	lbClear _control;
	{
		_control lbAdd format ["%1",([_x,0] call A3PL_Config_GetLicenseData)];
	} foreach (_player getVariable ["licenses",[]]);
}] call compile_Global;

["A3PL_DMV_SendConfirm",
{
	params [
		["_sendBackTo",objNull,[objNull]],
		["_target",objNull,[objNull]],
		["_license","",[""]],
		["_isCompany",false,[false]],
		["_action",-1,[-1]]
	];

	private _actionn = [format[("STR_A3PL_DMV_ConfirmationDialog" call A3PL_Localize)]] call A3PL_Lib_ConfirmationDialog;
	if (!isNil "_actionn" && {!_actionn}) exitWith {
		[("STR_A3PL_DMV_Declined" call A3PL_Localize),Color_Green] call A3PL_Notification;
		[false] remoteExec ["A3PL_DMV_Confirmed",_sendBackTo];
	};
	[true,_target,_license,_isCompany,_action] remoteExec ["A3PL_DMV_Confirmed",_sendBackTo];
}] call compile_Global;

["A3PL_DMV_Confirmed",
{
	params [
		["_confirmed",true,[true]],
		["_target",objNull,[objNull]],
		["_license","",[""]],
		["_isCompany",false,[false]],
		["_action",-1,[-1]]
	];

	private _licenseIssued = false;

	if(_confirmed isEqualTo false) exitWith {[("STR_A3PL_DMV_Refused" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if(!_isCompany) then {
		[_target,_license,_action,player] remoteExec ["Server_DMV_Add",2];
		_licenseIssued = true;
		private _text = switch(_action) do {
			case 0: {[format [("STR_A3PL_DMV_RevokePersonalLicense" call A3PL_Localize),_target getVariable ["name",(name _target)],[_license,0] call A3PL_Config_GetLicenseData],Color_Green] call A3PL_Notification;};
			case 1: {[format [("STR_A3PL_DMV_GivePersonalLicense" call A3PL_Localize),_target getVariable ["name",(name _target)],[_license,0] call A3PL_Config_GetLicenseData],Color_Green] call A3PL_Notification;};
			case 2: {};
		};
	} else {
		private _cid = [(_target getVariable ["character_id",""])] call A3PL_Config_GetCompanyID;
		[_cid,_license,_action] remoteExec ["Server_Company_SetLicenses",2];
		_licenseIssued = true;
		private _text = switch(_action) do {
			case 0: {[format [("STR_A3PL_DMV_RevokeCompanyLicense" call A3PL_Localize),_target getVariable ["name",(name _target)],[_license,0] call A3PL_Config_GetLicenseData],Color_Green] call A3PL_Notification;};
			case 1: {[format [("STR_A3PL_DMV_GiveCompanyLicense" call A3PL_Localize),_target getVariable ["name",(name _target)],[_license,0] call A3PL_Config_GetLicenseData],Color_Green] call A3PL_Notification;};
			case 2: {}; 
		};
	};
	if(_action isEqualTo 1 && (_licenseIssued)) then {
		private _price = [_license,4] call A3PL_Config_GetLicenseData;
		if(_price > 0) then {
			private _phasAccount = [player,1] call A3PL_Bank_HasAccount;
			private _thasAccount = [_target,1] call A3PL_Bank_HasAccount;
			private _pBank = player getVariable["Player_Bank",0];
			private _tBank = _target getVariable["Player_Bank",0];
			private _job = player getVariable "job";
			private _priceReceive = _price;
			if (!_thasAccount) exitWith {[("STR_Common_NoBankAccount" call A3PL_Localize),Color_Red] remoteExec ["A3PL_Notification",_target]};
			if (!_phasAccount) exitWith {[("STR_Common_NoBankAccount" call A3PL_Localize),Color_Red] call "A3PL_Notification"};
			if (_tBank < _price) exitWith {[format[("STR_A3PL_DMV_NoMoney" call A3PL_Localize),_price-_tBank],Color_Red] remoteExec ["A3PL_Notification",_target]};
			if (_job isEqualTo ("STR_Common_FISD" call A3PL_Localize)) then {[("STR_Common_SheriffsDepartment" call A3PL_Localize),_priceReceive] remoteExec ["Server_Government_AddBalance",2];};
			if (_job isEqualTo ("STR_Common_FIFR" call A3PL_Localize)) then {[("STR_Common_FireDepartment" call A3PL_Localize),_priceReceive] remoteExec ["Server_Government_AddBalance",2];};
			if (_job isEqualTo ("STR_Common_DOJ" call A3PL_Localize)) then {[("STR_Common_DepartmentOfJustice" call A3PL_Localize),_priceReceive] remoteExec ["Server_Government_AddBalance",2];};
			if (_job isEqualTo ("STR_Common_GOV" call A3PL_Localize)) then {[("STR_Common_Government" call A3PL_Localize),_priceReceive] remoteExec ["Server_Government_AddBalance",2];};
			if !(_job IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) then {player setVariable["Player_Bank",_pBank+_priceReceive,true];};
			_target setVariable["Player_Bank",_tBank-_price,true];
			[format[("STR_A3PL_DMV_LicensePaid" call A3PL_Localize),_price,[_license,0] call A3PL_Config_GetLicenseData], Color_green] remoteExec["A3PL_Notification",_target];
			[format[("STR_A3PL_DMV_LicenseMoneyReceived" call A3PL_Localize),_priceReceive,[_license,0] call A3PL_Config_GetLicenseData],Color_Green] call A3PL_Notification;
			[getPlayerUID player,(player getVariable ["character_id",""]),"License_Add",[format ["License: %1 | Target: %2",_license,(_target getVariable["name","unknown"])]]] remoteExec ["Server_Log_New",2];
			[getPlayerUID _target,(_target getVariable ["character_id",""]),"License_Added",[format ["License: %1 | Added By: %2",_license,(player getVariable["name","unknown"])]]] remoteExec ["Server_Log_New",2];
		};
	};
}] call compile_Global;

["A3PL_DMV_Add", {
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private _action = param [0,1];
	private _display = findDisplay 21;
	private _control = _display displayCtrl 1500;
	private _index = lbCurSel _control;
	if (_index < 0) exitwith {[("STR_A3PL_DMV_NoOneSelected" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _target = [(_control lbData _index)] call A3PL_Lib_charIDToObject;
	if (isNull _target) exitwith {[("STR_A3PL_DMV_NoLicense" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _control = _display displayCtrl 2100;
	if ((lbCurSel _control) < 0) exitwith {[("STR_A3PL_DMV_NoLicenseSelected" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _isCompany = (_control lbValue (lbCurSel _control)) IsEqualTo 1;
	private _inCompany = [(_target getVariable ["character_id",""])] call A3PL_Config_InCompany;
	if (_isCompany && (!_inCompany)) exitWith {[("STR_A3PL_DMV_NotInCompany" call A3PL_Localize),Color_Red] call A3PL_Notification;};	

	private _license = _control lbData (lbCurSel _control);
	private _canIssue = _pJob IN ([_license,2] call A3PL_Config_GetLicenseData);
	private _canRevoke = _pJob IN ([_license,3] call A3PL_Config_GetLicenseData);
	private _pJob = player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
	
	if((_action IN [1,2]) && {!_canIssue}) exitWith {[("STR_A3PL_DMV_CantGiveLicense" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if((_action isEqualTo 0) && {!_canRevoke}) exitWith {[("STR_A3PL_DMV_CantRevokeLicense" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if(([_license,_target] call A3PL_DMV_Check) && (_action isEqualTo 1)) exitWith {[("STR_A3PL_DMV_AlreadyHasLicense" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if(_action isEqualTo 1) then {[player,_target,_license,_isCompany,_action] remoteExec ["A3PL_DMV_SendConfirm",_target];} else {[true,_target,_license,_isCompany,_action] call A3PL_DMV_Confirmed;};
}] call compile_Global;

["A3PL_DMV_Check", {
	private _license = param [0,"driver"];
	private _player = param [1,player];
	private _plicenses = _player getVariable ["licenses",[]];
	if (_license IN _plicenses) then {true;} else {false;};
}] call compile_Global;

["A3PL_DMV_StartTest",{
	params ["_testType","_license","_price"];
	if([_license] call A3PL_DMV_Check) exitWith {['Vous avez déjà cette licence',Color_Red] call A3PL_Notification;};
	/* START HOW TO PAY */
    private _paymentResult = [_price] spawn A3PL_Bank_HowToPay;
    waitUntil {_paymentResult isNotEqualTo objNull};
    if (!_paymentResult) exitWith {};
	/* END HOW TO PAY */
	[_testType] call A3PL_NPC_Start;
}] call compile_Global;

["A3PL_DMV_Car_Exam",{
	if(["driver"] call A3PL_DMV_Check) exitWith {[("STR_A3PL_DMV_AlreadyHaveDriverLicense" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (Player_License_Action) exitWith {[("STR_A3PL_DMV_AlreadyTakingDriverExam" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_price = DMV_Car_Exam_Price;

	private _action = [format[("STR_A3PL_DMV_ConfirmExamPrice" call A3PL_Localize),_price]] call A3PL_Lib_ConfirmationDialog;
	if(_action) then {
		private _spawnLoc = [6706.22,7558.52,0.00144196];
		private _posBlocked = (nearestObjects[_spawnLoc,["Car","Ship","Air","Tank"],5]) isNotEqualTo [];
		if(_posBlocked) exitWith {[("STR_A3PL_DMV_SpawnBlocked" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		/* START HOW TO PAY */
		[_price] call A3PL_Bank_HowToPay;
		waitUntil {(player getVariable["paymentResult", objNull]) isNotEqualTo objNull};
		if (!(player getVariable "paymentResult")) exitWith {};
		/* END HOW TO PAY */

		_vehicle = createVehicle ["A3PL_CRX", _spawnLoc, [], 0, "NONE"];
		_vehicle setObjectTextureGlobal [0, "\A3PL_Textures\CRX\CRX_DMV.paa"];
		[_vehicle, nil, ["Student_Driver",1]] call A3PL_Garage_InstallUpgrades;
		_vehicle allowDamage false;
		_vehicle setDir 193.062;
		_vehicle setVariable ["locked",false,true];
		_vehicle setFuelCargo 0;
		["DMV",_vehicle] remoteExec ["Server_Vehicle_Init_SetLicensePlate",2];
		_vehicle allowDamage true;

		_startPos = getPosATL player;
		Player_License_Action = true;

		_permis = true;
		_exit = false;
		_erreur = 0;
		_myerreur = 0;
		_etape1 = false;
		_etape2 = false;
		_etape3 = false;
		_etape4 = false;
		_etape5 = false;
		_etape6 = false;
		_etape7 = false;
		_etape8 = false;
		_etape9 = false;
		_etape10 = false;
		_etape11 = false;
		_etape12 = false;
		_etape13 = false;
		_etape14 = false;
		_etape15 = false;
		_etape16 = false;
		_etape17 = false;
		_etape18 = false;
		_etape19 = false;
		_etape20 = false;
		_etape21 = false;
		_etape22 = false;
		_etape23 = false;
		_etape24 = false;
		_etape25 = false;
		_passageTime = time;

		[("STR_A3PL_DMV_InstructorWaiting" call A3PL_Localize),Color_Green] call A3PL_Notification;

		for "_i" from 0 to 1 step 0 do {
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if (typeOf (vehicle player) isKindOf "A3PL_CRX") exitWith {_etape1 = true;};
			if (player distance _vehicle > 100) exitWith {_exit = true;};
			sleep 1;
		};
		if (_exit) exitWith {[("STR_A3PL_DMV_ExamFailed_InstructorLeft" call A3PL_Localize),Color_Red] call A3PL_Notification;deleteVehicle _vehicle;Player_License_Action = false;};

		waitUntil {sleep 0.3; _etape1;};
		["TD", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 1900], ("STR_A3PL_DMV_GPS_ExitParking" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 45 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_1") > 2400) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_1") < 10) exitWith {_etape2 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape2;};
		["TD", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 230], ("STR_A3PL_DMV_GPS_ContinueToTrafficLight" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 25 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_2") > 750) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_2") < 10) exitWith {_etape3 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape3;};
		["TD", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 250], ("STR_A3PL_DMV_GPS_GoStraight" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 45 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_3") > 1150) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_3") < 10) exitWith {_etape4 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape4;};
		["TD", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 620], ("STR_A3PL_DMV_GPS_ContinueStraight" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 45 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_4") > 1200) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_4") < 10) exitWith {_etape5 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape5;};
		["TD", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 700], ("STR_A3PL_DMV_GPS_ContinueStraightStayOnRoad" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 45 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_5") > 1120) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_5") < 10) exitWith {_etape6 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape6;};
		["G", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 620], ("STR_A3PL_DMV_GPS_TurnLeftContinueStraight" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 45 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_6") > 740) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_6") < 20) exitWith {_etape7 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape7;};
		["G", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 240], ("STR_A3PL_DMV_GPS_TurnLeftAtTrafficLight" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 45 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_7") > 780) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_7") < 20) exitWith {_etape8 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape8;};
		["TD", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 280], ("STR_A3PL_DMV_GPS_ContinueToStop" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 65 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_8") > 2440) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_8") < 20) exitWith {_etape9 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape9;};
		["G", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 2000], ("STR_A3PL_DMV_GPS_TurnLeftContinueStraight" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 85 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_9") > 1330) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_9") < 20) exitWith {_etape10 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape10;};
		["TD", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 5000], ("STR_A3PL_DMV_GPS_ContinueStraight" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 85 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_10") > 2700) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_10") < 20) exitWith {_etape11 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape11;};
		["RP", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 250], ("STR_A3PL_DMV_GPS_TurnLeftToFork" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 65 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_11") > 680) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_11") < 20) exitWith {_etape12 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape12;};
		["TD", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 3400], ("STR_A3PL_DMV_GPS_StayOnHighway" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 100 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_12") > 2300) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_12") < 20) exitWith {_etape13 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape13;};
		["D", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 300], ("STR_A3PL_DMV_GPS_PrepareToExitHighway" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 100 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_13") > 2420) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_13") < 20) exitWith {_etape14 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape14;};
		["G", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 3250], ("STR_A3PL_DMV_GPS_TurnLeftContinueStraight" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 85 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_14") > 2420) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_14") < 20) exitWith {_etape15 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape15;};
		["D", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 1500], ("STR_A3PL_DMV_GPS_TurnRightAtBranch" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 85 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_15") > 800) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_15") < 20) exitWith {_etape16 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape16;};
		["TD", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 1250], ("STR_A3PL_DMV_GPS_ContinueStraightStayOnRoad" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 85 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_16") > 550) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_16") < 20) exitWith {_etape17 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape17;};
		["G", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 300], ("STR_A3PL_DMV_GPS_TakeNextLeft" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 85 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_17") > 800) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_17") < 20) exitWith {_etape18 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape18;};
		["G", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 250], ("STR_A3PL_DMV_GPS_TurnLeftDirtRoad" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 45 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_18") > 250) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_18") < 20) exitWith {_etape19 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape19;};
		["D", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 50], ("STR_A3PL_DMV_GPS_TurnRightToStop" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 45 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_19") > 250) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_19") < 20) exitWith {_etape20 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape20;};
		["G", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 200], ("STR_A3PL_DMV_GPS_TurnLeftToStop" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 45 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_20") > 250) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_20") < 20) exitWith {_etape21 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape21;};
		["G", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 500], ("STR_A3PL_DMV_GPS_TakeNextLeft" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 45 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_21") > 250) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_21") < 20) exitWith {_etape22 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape22;};
		["TD", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 700], ("STR_A3PL_DMV_GPS_ContinueToEndOfRoad" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 45 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_22") > 450) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_22") < 20) exitWith {_etape23 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape23;};
		["D", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 150], ("STR_A3PL_DMV_GPS_TurnRight" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 25 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_23") > 150) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_23") < 20) exitWith {_etape24 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape24;};
		["TD", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 50], ("STR_A3PL_DMV_GPS_ParkHandicapSpot" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			if ((round speed (vehicle player) isEqualTo 0) && ((vehicle player) distance (getMarkerPos "dmv_examcar_end") < 15)) exitWith {_etape25 = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_end") > 150) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape25;};

		deleteVehicle _vehicle;

		[format[("STR_A3PL_DMV_ErrorCount" call A3PL_Localize),_erreur],Color_Orange] call A3PL_Notification;
		sleep 2;
		if (_erreur < 6) then {
			[("STR_A3PL_DMV_ExamPassed" call A3PL_Localize),Color_Green] call A3PL_Notification;
			[player,'driver',1,'DMV'] remoteExec ['Server_DMV_Add',2];
			Player_License_Action = false;
		} else {
			[("STR_A3PL_DMV_ExamFailed_TooManyErrors" call A3PL_Localize),Color_Red] call A3PL_Notification;
			Player_License_Action = false;
		};
	};
}] call compile_Global;

["A3PL_DMV_Motorcycle_Exam",{
	if(["motorcycle"] call A3PL_DMV_Check) exitWith {[("STR_A3PL_DMV_AlreadyHaveMotorcycleLicense" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (Player_License_Action) exitWith {[("STR_A3PL_DMV_AlreadyTakingMotorcycleExam" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_price = DMV_Motorcycle_Exam_Price;

	private _action = [format[("STR_A3PL_DMV_ConfirmExamPrice" call A3PL_Localize),_price]] call A3PL_Lib_ConfirmationDialog;
	if(_action) then {
		private _spawnLoc = [6705.754,7557.978,0];
		private _posBlocked = (nearestObjects[_spawnLoc,["Car","Ship","Air","Tank"],5]) isNotEqualTo [];
		if(_posBlocked) exitWith {[("STR_A3PL_DMV_SpawnBlockedMoto" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		/* START HOW TO PAY */
		[_price] call A3PL_Bank_HowToPay;
		waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
		if (!(player getVariable "paymentResult")) exitWith {};
		/* END HOW TO PAY */

		_vehicle = createVehicle ["K_Scooter_DarkBlue", _spawnLoc, [], 0, "NONE"];
		_vehicle allowDamage false;
		_vehicle setDir 193.062;
		_vehicle setVariable ["locked",false,true];
		_vehicle setFuelCargo 0;
		["DMV",_vehicle] remoteExec ["Server_Vehicle_Init_SetLicensePlate",2];
		_vehicle allowDamage true;

		_startPos = getPosATL player;
		Player_License_Action = true;

		_permis = true;
		_exit = false;
		_erreur = 0;
		_myerreur = 0;
		_etape1 = false;
		_etape2 = false;
		_etape3 = false;
		_etape4 = false;
		_etape5 = false;
		_etape6 = false;
		_etape7 = false;
		_etape8 = false;
		_etape9 = false;
		_etape10 = false;
		_etape11 = false;
		_etape12 = false;
		_etape13 = false;
		_etape14 = false;
		_etape15 = false;
		_etape16 = false;
		_etape17 = false;
		_etape18 = false;
		_etape19 = false;
		_etape20 = false;
		_etape21 = false;
		_etape22 = false;
		_etape23 = false;
		_etape24 = false;
		_etape25 = false;
		_passageTime = time;

		[("STR_A3PL_DMV_InstructorWaiting" call A3PL_Localize),Color_Green] call A3PL_Notification;

		for "_i" from 0 to 1 step 0 do {
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if (typeOf (vehicle player) isKindOf "K_Scooter_DarkBlue") exitWith {_etape1 = true;};
			if (player distance _vehicle > 100) exitWith {_exit = true;};
			sleep 1;
		};
		if (_exit) exitWith {[("STR_A3PL_DMV_ExamFailed_InstructorLeft" call A3PL_Localize),Color_Red] call A3PL_Notification;deleteVehicle _vehicle;Player_License_Action = false;};

		waitUntil {sleep 0.3; _etape1;};
		["TD", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 1900], ("STR_A3PL_DMV_GPS_ExitParking" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 45 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_1") > 2400) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_1") < 10) exitWith {_etape2 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape2;};
		["TD", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 230], ("STR_A3PL_DMV_GPS_ContinueToTrafficLight" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 25 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_2") > 750) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_2") < 10) exitWith {_etape3 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape3;};
		["TD", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 250], ("STR_A3PL_DMV_GPS_GoStraight" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 45 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_3") > 1150) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_3") < 10) exitWith {_etape4 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape4;};
		["TD", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 620], ("STR_A3PL_DMV_GPS_ContinueStraight" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 45 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_4") > 1200) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_4") < 10) exitWith {_etape5 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape5;};
		["TD", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 700], ("STR_A3PL_DMV_GPS_ContinueStraightStayOnRoad" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 45 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_5") > 1120) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_5") < 10) exitWith {_etape6 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape6;};
		["G", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 620], ("STR_A3PL_DMV_GPS_TurnLeftContinueStraight" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 45 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_6") > 740) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_6") < 20) exitWith {_etape7 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape7;};
		["G", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 240], ("STR_A3PL_DMV_GPS_TurnLeftAtTrafficLight" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 45 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_7") > 780) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_7") < 20) exitWith {_etape8 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape8;};
		["TD", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 280], ("STR_A3PL_DMV_GPS_ContinueToStop" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 65 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_8") > 2440) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_8") < 20) exitWith {_etape9 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape9;};
		["G", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 2000], ("STR_A3PL_DMV_GPS_TurnLeftContinueStraight" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 85 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_9") > 1330) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_9") < 20) exitWith {_etape10 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape10;};
		["TD", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 5000], ("STR_A3PL_DMV_GPS_ContinueStraight" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 85 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_10") > 2700) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_10") < 20) exitWith {_etape11 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape11;};
		["RP", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 250], ("STR_A3PL_DMV_GPS_TurnLeftToFork" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 65 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_11") > 680) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_11") < 20) exitWith {_etape12 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape12;};
		["TD", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 3400], ("STR_A3PL_DMV_GPS_StayOnHighway" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 100 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_12") > 2300) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_12") < 20) exitWith {_etape13 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape13;};
		["D", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 300], ("STR_A3PL_DMV_GPS_PrepareToExitHighway" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 100 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_13") > 2420) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_13") < 20) exitWith {_etape14 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape14;};
		["G", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 3250], ("STR_A3PL_DMV_GPS_TurnLeftContinueStraight" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 85 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_14") > 2420) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_14") < 20) exitWith {_etape15 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape15;};
		["D", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 1500], ("STR_A3PL_DMV_GPS_TurnRightAtBranch" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 85 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_15") > 800) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_15") < 20) exitWith {_etape16 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape16;};
		["TD", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 1250], ("STR_A3PL_DMV_GPS_ContinueStraightStayOnRoad" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 85 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_16") > 550) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_16") < 20) exitWith {_etape17 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape17;};
		["G", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 300], ("STR_A3PL_DMV_GPS_TakeNextLeft" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 85 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_17") > 800) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_17") < 20) exitWith {_etape18 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape18;};
		["G", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 250], ("STR_A3PL_DMV_GPS_TurnLeftDirtRoad" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 45 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_18") > 250) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_18") < 20) exitWith {_etape19 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape19;};
		["D", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 50], ("STR_A3PL_DMV_GPS_TurnRightToStop" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 45 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_19") > 250) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_19") < 20) exitWith {_etape20 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape20;};
		["G", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 200], ("STR_A3PL_DMV_GPS_TurnLeftToStop" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 45 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_20") > 250) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_20") < 20) exitWith {_etape21 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape21;};
		["G", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 500], ("STR_A3PL_DMV_GPS_TakeNextLeft" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 45 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_21") > 250) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_21") < 20) exitWith {_etape22 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape22;};
		["TD", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 700], ("STR_A3PL_DMV_GPS_ContinueToEndOfRoad" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 45 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_22") > 450) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_22") < 20) exitWith {_etape23 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape23;};
		["D", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 150], ("STR_A3PL_DMV_GPS_TurnRight" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 25 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_23") > 150) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_23") < 20) exitWith {_etape24 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape24;};
		["TD", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 50], ("STR_A3PL_DMV_GPS_ParkHandicapSpot" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			if ((round speed (vehicle player) isEqualTo 0) && ((vehicle player) distance (getMarkerPos "dmv_examcar_end") < 15)) exitWith {_etape25 = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_end") > 150) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape25;};

		deleteVehicle _vehicle;

		[format[("STR_A3PL_DMV_ErrorCount" call A3PL_Localize),_erreur],Color_Orange] call A3PL_Notification;
		sleep 2;
		if (_erreur < 6) then {
			[("STR_A3PL_DMV_ExamPassed" call A3PL_Localize),Color_Green] call A3PL_Notification;
			[player,'motorcycle',1,'DMV'] remoteExec ['Server_DMV_Add',2];
			Player_License_Action = false;
		} else {
			[("STR_A3PL_DMV_ExamFailed_TooManyErrors" call A3PL_Localize),Color_Red] call A3PL_Notification;
			Player_License_Action = false;
		};
	};
}] call compile_Global;

["A3PL_DMV_Truck_Exam",{
	if(["cdl"] call A3PL_DMV_Check) exitWith {[("STR_A3PL_DMV_AlreadyHaveTruckLicense" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (Player_License_Action) exitWith {[("STR_A3PL_DMV_AlreadyTakingTruckExam" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_price = DMV_Truck_Exam_Price;

	private _action = [format[("STR_A3PL_DMV_ConfirmExamPrice" call A3PL_Localize),_price]] call A3PL_Lib_ConfirmationDialog;
	if(_action) then {
		private _spawnLoc = [6705.706,7551.542,0];
		private _posBlocked = (nearestObjects[_spawnLoc,["Car","Ship","Air","Tank"],5]) isNotEqualTo [];
		if(_posBlocked) exitWith {[("STR_A3PL_DMV_SpawnBlocked" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		/* START HOW TO PAY */
		[_price] call A3PL_Bank_HowToPay;
		waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
		if (!(player getVariable "paymentResult")) exitWith {};
		/* END HOW TO PAY */

		_vehicle = createVehicle ["A3FL_T370", _spawnLoc, [], 0, "NONE"];
		_vehicle allowDamage false;
		_vehicle setDir 193.062;
		_vehicle setVariable ["locked",false,true];
		_vehicle setFuelCargo 0;
		["DMV",_vehicle] remoteExec ["Server_Vehicle_Init_SetLicensePlate",2];
		_vehicle allowDamage true;

		_startPos = getPosATL player;
		Player_License_Action = true;

		_permis = true;
		_exit = false;
		_erreur = 0;
		_myerreur = 0;
		_etape1 = false;
		_etape2 = false;
		_etape3 = false;
		_etape4 = false;
		_etape5 = false;
		_etape6 = false;
		_etape7 = false;
		_etape8 = false;
		_etape9 = false;
		_etape10 = false;
		_etape11 = false;
		_etape12 = false;
		_etape13 = false;
		_etape14 = false;
		_etape15 = false;
		_etape16 = false;
		_etape17 = false;
		_etape18 = false;
		_etape19 = false;
		_etape20 = false;
		_etape21 = false;
		_etape22 = false;
		_etape23 = false;
		_etape24 = false;
		_etape25 = false;
		_passageTime = time;

		[("STR_A3PL_DMV_InstructorWaiting" call A3PL_Localize),Color_Green] call A3PL_Notification;

		for "_i" from 0 to 1 step 0 do {
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if (typeOf (vehicle player) isKindOf "A3FL_T370") exitWith {_etape1 = true;};
			if (player distance _vehicle > 100) exitWith {_exit = true;};
			sleep 1;
		};
		if (_exit) exitWith {[("STR_A3PL_DMV_ExamFailed_InstructorLeft" call A3PL_Localize),Color_Red] call A3PL_Notification;deleteVehicle _vehicle;Player_License_Action = false;};

		waitUntil {sleep 0.3; _etape1;};
		["TD", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 1900], ("STR_A3PL_DMV_GPS_ExitParking" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 45 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_1") > 2400) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_1") < 10) exitWith {_etape2 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape2;};
		["TD", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 230], ("STR_A3PL_DMV_GPS_ContinueToTrafficLight" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 25 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_2") > 750) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_2") < 10) exitWith {_etape3 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape3;};
		["TD", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 250], ("STR_A3PL_DMV_GPS_GoStraight" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 45 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_3") > 1150) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_3") < 10) exitWith {_etape4 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape4;};
		["TD", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 620], ("STR_A3PL_DMV_GPS_ContinueStraight" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 45 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_4") > 1200) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_4") < 10) exitWith {_etape5 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape5;};
		["TD", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 700], ("STR_A3PL_DMV_GPS_ContinueStraightStayOnRoad" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 45 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_5") > 1120) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_5") < 10) exitWith {_etape6 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape6;};
		["G", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 620], ("STR_A3PL_DMV_GPS_TurnLeftContinueStraight" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 45 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_6") > 740) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_6") < 20) exitWith {_etape7 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape7;};
		["G", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 240], ("STR_A3PL_DMV_GPS_TurnLeftAtTrafficLight" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 45 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_7") > 780) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_7") < 20) exitWith {_etape8 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape8;};
		["TD", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 280], ("STR_A3PL_DMV_GPS_ContinueToStop" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 65 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_8") > 2440) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_8") < 20) exitWith {_etape9 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape9;};
		["G", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 2000], ("STR_A3PL_DMV_GPS_TurnLeftContinueStraight" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 85 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_9") > 1330) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_9") < 20) exitWith {_etape10 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape10;};
		["TD", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 5000], ("STR_A3PL_DMV_GPS_ContinueStraight" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 85 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_10") > 2700) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_10") < 20) exitWith {_etape11 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape11;};
		["RP", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 250], ("STR_A3PL_DMV_GPS_TurnLeftToFork" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 65 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_11") > 680) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_11") < 20) exitWith {_etape12 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape12;};
		["TD", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 3400], ("STR_A3PL_DMV_GPS_StayOnHighway" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 100 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_12") > 2300) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_12") < 20) exitWith {_etape13 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape13;};
		["D", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 300], ("STR_A3PL_DMV_GPS_PrepareToExitHighway" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 100 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_13") > 2420) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_13") < 20) exitWith {_etape14 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape14;};
		["G", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 3250], ("STR_A3PL_DMV_GPS_TurnLeftContinueStraight" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 85 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_14") > 2420) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_14") < 20) exitWith {_etape15 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape15;};
		["D", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 1500], ("STR_A3PL_DMV_GPS_TurnRightAtBranch" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 85 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_15") > 800) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_15") < 20) exitWith {_etape16 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape16;};
		["TD", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 1250], ("STR_A3PL_DMV_GPS_ContinueStraightStayOnRoad" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 85 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_16") > 550) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_16") < 20) exitWith {_etape17 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape17;};
		["G", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 300], ("STR_A3PL_DMV_GPS_TakeNextLeft" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 85 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_17") > 800) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_17") < 20) exitWith {_etape18 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape18;};
		["G", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 250], ("STR_A3PL_DMV_GPS_TurnLeftDirtRoad" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 45 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_18") > 250) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_18") < 20) exitWith {_etape19 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape19;};
		["D", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 50], ("STR_A3PL_DMV_GPS_TurnRightToStop" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 45 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_19") > 250) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_19") < 20) exitWith {_etape20 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape20;};
		["G", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 200], ("STR_A3PL_DMV_GPS_TurnLeftToStop" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 45 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_20") > 250) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_20") < 20) exitWith {_etape21 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape21;};
		["G", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 500], ("STR_A3PL_DMV_GPS_TakeNextLeft" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 45 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_21") > 250) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_21") < 20) exitWith {_etape22 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape22;};
		["TD", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 700], ("STR_A3PL_DMV_GPS_ContinueToEndOfRoad" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 45 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_22") > 450) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_22") < 20) exitWith {_etape23 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape23;};
		["D", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 150], ("STR_A3PL_DMV_GPS_TurnRight" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_myerreur = _erreur;
		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			_speed = (round speed (vehicle player)*0.62);
			if (round _speed > 25 && _erreur isEqualTo _myerreur) then {_erreur = _erreur + 1; [("STR_A3PL_DMV_Speeding" call A3PL_Localize),Color_Orange] call A3PL_Notification;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_23") > 150) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_23") < 20) exitWith {_etape24 = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape24;};
		["TD", format[("STR_A3PL_DMV_GPS_Feet" call A3PL_Localize), 50], ("STR_A3PL_DMV_GPS_ParkHandicapSpot" call A3PL_Localize)] spawn A3PL_Notifications_doGPS;

		_passageTime = time;
		for "_i" from 0 to 1 step 0 do {
			if ((round speed (vehicle player) isEqualTo 0) && ((vehicle player) distance (getMarkerPos "dmv_examcar_end") < 15)) exitWith {_etape25 = true;};
			if ((vehicle player) distance (getMarkerPos "dmv_examcar_end") > 150) exitWith {_exit = true;};
			if (time - _passageTime > 300) exitWith {_exit = true;};
			sleep 0.5;
		};
		if (_exit) exitWith {Player_License_Action = false; player allowDamage false; [] spawn {sleep 5; player allowDamage true;}; deleteVehicle _vehicle; player setPosATL _startPos; [("STR_A3PL_DMV_TooFarAway" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		waitUntil {sleep 0.3; _etape25;};

		deleteVehicle _vehicle;

		[format[("STR_A3PL_DMV_ErrorCount" call A3PL_Localize),_erreur],Color_Orange] call A3PL_Notification;
		sleep 2;
		if (_erreur < 6) then {
			[("STR_A3PL_DMV_ExamPassed" call A3PL_Localize),Color_Green] call A3PL_Notification;
			[player,'cdl',1,'DMV'] remoteExec ['Server_DMV_Add',2];
			Player_License_Action = false;
		} else {
			[("STR_A3PL_DMV_ExamFailed_TooManyErrors" call A3PL_Localize),Color_Red] call A3PL_Notification;
			Player_License_Action = false;
		};
	};
}] call compile_Global;