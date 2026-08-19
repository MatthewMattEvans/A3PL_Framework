/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/

['A3PL_Company_CreateOpen', {
	disableSerialization;
	private _isCorporate = [(player getVariable ["character_id",""])] call A3PL_Config_InCompany;
	if(_isCorporate) exitWith {[("STR_A3PL_Company_AlreadyInCompany" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	createDialog "Dialog_Company_Create";
	[getPlayerUID player,(player getVariable ["character_id",""]),"Company_Create_OpenMenu","Company creation menu open"] remoteExec ["Server_Log_New",2];
}] call compile_Global;

['A3PL_Company_Create', {
	disableSerialization;
	private _display = findDisplay 136;
	private _name = ctrlText (_display displayCtrl 1400);
	private _desc = ctrlText (_display displayCtrl 1401);
	
	// Liste des caractères autorisés (lettres, chiffres et espaces uniquement)
	private _allowedChars = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"," "];
	
	// Liste noire des caractères spéciaux dangereux pour SQL et sécurité (double vérification)
	private _forbiddenChars = ["'","\","&","<",">",";","=","%","$","#","@","*","+","(",")","[","]","{","}","|","\\","/","`","~","^","-","_",".",",","!","?","€","£","¥"];
	
	private _validName = true;
	private _validDesc = true;
	private _invalidCharName = "";
	private _invalidCharDesc = "";

	closeDialog 0;

	// Vérification du nom : caractères autorisés uniquement
	for "_i" from 0 to ((count _name) - 1) do
	{
		private _test = _name select [_i,1];
		if (!(_test IN _allowedChars)) exitWith {
			_validName = false;
			_invalidCharName = _test;
		};
		// Vérification supplémentaire : caractères interdits
		if (_test IN _forbiddenChars) exitWith {
			_validName = false;
			_invalidCharName = _test;
		};
	};

	// Vérification de la description : caractères autorisés uniquement
	for "_i" from 0 to ((count _desc) - 1) do
	{
		private _test2 = _desc select [_i,1];
		if (!(_test2 IN _allowedChars)) exitWith {
			_validDesc = false;
			_invalidCharDesc = _test2;
		};
		// Vérification supplémentaire : caractères interdits
		if (_test2 IN _forbiddenChars) exitWith {
			_validDesc = false;
			_invalidCharDesc = _test2;
		};
	};

	// Messages d'erreur spécifiques
	if (!(_validName)) exitWith {
		if (_invalidCharName IN _forbiddenChars) then {
			[format[("STR_A3PL_Company_ForbiddenCharInName" call A3PL_Localize),_invalidCharName],Color_Red] call A3PL_Notification;
		} else {
			[("STR_A3PL_Company_UnauthorizedCharsInName" call A3PL_Localize),Color_Red] call A3PL_Notification;
		};
	};
	
	if (!(_validDesc)) exitWith {
		if (_invalidCharDesc IN _forbiddenChars) then {
			[format[("STR_A3PL_Company_ForbiddenCharInDescription" call A3PL_Localize),_invalidCharDesc],Color_Red] call A3PL_Notification;
		} else {
			[("STR_A3PL_Company_UnauthorizedCharsInDescription" call A3PL_Localize),Color_Red] call A3PL_Notification;
		};
	};

	[format [("STR_A3PL_Company_CreationSuccess" call A3PL_Localize),_name],Color_Green] call A3PL_Notification;
	["company_create"] call PO_Achievement_Learn;
	[(player getVariable ["character_id",""]), _name, _desc] remoteExec ["Server_Company_Create",2];
	[getPlayerUID player,(player getVariable ["character_id",""]),"Company_Creation",[format["New company: %1 | Description: %2",_name,_desc]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

['A3PL_Company_HiringConfirmation', {
	private _cid = param [0,-1];
	private _sender = param [1,objNull];
	private _exit = false;
	private _action = [format[("STR_A3PL_Company_Invitation" call A3PL_Localize)]] call A3PL_Lib_ConfirmationDialog;
	if (!isNil "_action" && {!_action}) exitWith {_exit = true;};
	if(_exit) exitWith{[format[("STR_A3PL_Company_Refusal" call A3PL_Localize),player getVariable["name",""]], Color_Red] remoteExec ["A3PL_Notification",_sender];};
	[_cid,player] remoteExec ["Server_Company_Recruit",2];
	[format[("STR_A3PL_Company_JoinSuccess" call A3PL_Localize),player getVariable["name",""]], Color_Green] remoteExec ["A3PL_Notification",_sender];
	[getPlayerUID player,(player getVariable ["character_id",""]),"Company_Hiring",[format["Company: %1 | Recruited by: %2",_cid,_sender]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

['A3PL_Company_HasLicense', {
	private _player = param [0,objNull];
	private _license = param[1,""];
	if (isNull _player) exitWith {false;};
	private _cid = [(_player getVariable ["character_id",""])] call A3PL_Config_GetCompanyID;
	if (_cid isEqualTo 0) exitWith {false;};
	private _cLicenses = [_cid, "licenses"] call A3PL_Config_GetCompanyData;
	if(_license IN _cLicenses) then {true;} else {false;};
}] call compile_Global;

['A3PL_Company_ManageOpen', {
	disableSerialization;
	if((player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) isNotEqualTo ("STR_Common_Company" call A3PL_Localize)) exitWith {[("STR_A3PL_Company_NotOnDuty" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _charID = (player getVariable ["character_id",""]);
	private _isCorporate = [_charID] call A3PL_Config_InCompany;
	if(!_isCorporate) exitWith {[("STR_Common_NotInCompany" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _cid = [_charID] call A3PL_Config_GetCompanyID;
	private _hasPermRank = [_cid,"ranks",_charID] call A3FL_Config_GetCompanyPermissions;
	private _hasPermBank = [_cid,"bank",_charID] call A3FL_Config_GetCompanyPermissions;
	private _isBoss = ([_charID] call A3PL_Config_IsCompanyBoss);
	if(!(_hasPermRank) && !(_hasPermBank) && !(_isBoss)) exitWith {[("STR_A3PL_Company_ManageDenied" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _cid = [_charID] call A3PL_Config_GetCompanyID;
	private _companyBudget = [_cid, "bank"] call A3PL_Config_GetCompanyData;

	createDialog "Dialog_Company_Manage";
	private _display = findDisplay 137;
	_display displayAddEventHandler ["Unload",{A3FL_COMPANYPLIST = nil;}];

	private _control = _display displayCtrl 1100;
	_control ctrlSetStructuredText parseText format["<t align='left' size='1.2'>$%1</t>",[_companyBudget, 1, 0, true] call CBA_fnc_formatNumber];

	_control = _display displayCtrl 5474;
	_control ctrlAddEventHandler ["LBSelChanged","call A3FL_Company_UpdateRanks;"];

	[_cid, player] remoteExec ["Server_Company_ManageSetup",2];
	[getPlayerUID player,_charID,"Company_Manage_OpenMenu","Management menu opened"] remoteExec ["Server_Log_New",2];
}] call compile_Global;

['A3PL_Company_ManageReceive', {
	private ["_display"];
	private _desc = param [0,("STR_Server_Company_NoDescription" call A3PL_Localize)];
	private _empList = param [1,[]];
	private _cid = [(player getVariable ["character_id",""])] call A3PL_Config_GetCompanyID;
	private _ranks = [_cid, "ranks"] call A3PL_Config_GetCompanyData;
	private _permList = [("STR_Server_Company_TransferFromToGarage" call A3PL_Localize),("STR_Server_Company_ManageRanks" call A3PL_Localize),("STR_Server_Company_ManageLocal" call A3PL_Localize),("STR_Server_Company_HireFire" call A3PL_Localize),("STR_Server_Company_Garage" call A3PL_Localize),("STR_Server_Company_Bank" call A3PL_Localize),("STR_Server_Company_Twitter" call A3PL_Localize),("STR_Server_Company_FilesManager" call A3PL_Localize),("STR_Server_Company_InternalStock" call A3PL_Localize),("STR_Server_Company_ManageInternalStock" call A3PL_Localize)];
	A3FL_COMPANYPLIST = _empList;
	_empList sort true;

	_display = findDisplay 137;

	//Employees list
	_control = _display displayCtrl 1500;
	{
		_control lbAdd format ["%1",_x select 0];
		_control lbSetData [(lbSize _control)-1, _x select 1];
		_control lbSetValue [(lbSize _control)-1, _x select 2];
	} foreach _empList;

	//Desc set
	_control = _display displayCtrl 1402;
	_control ctrlSetText format ["%1",_desc];

	//SAME AS ATM MENU
	//creates list of players online - for transfer option
	{
		_pname = _x getVariable ["name","unknown"];
		_index = lbAdd [5472, format["%1",  _pname]];
		lbSetData [5472, _index, str _x];
	} forEach (playableUnits);

	//Add companies to the list
	{
		if((_x select 0) != _cid) then {
			_index = lbAdd [5472, format["(E) %1", _x select 1]];
			lbSetData [5472, _index, str(_x select 0)];
		};
	} forEach Server_Companies;

	//Ranks list
	_control = _display displayCtrl 5474;
	lbClear _control;
	{
		private _name = _x select 0;
		private _pay = _x select 2;
		private _index = _control lbAdd format ["%1 - $%2",_name,([_pay, 1, 0, true] call CBA_fnc_formatNumber)];
		_control lbSetData [_index,_name];
	} foreach _ranks;

	//Permission list
	_control = _display displayCtrl 5475;
	lbClear _control;
	{
		private _perm = _x;
		private _index = _control lbAdd format ["%1",_perm];
		_control lbSetData [_index,_perm];
	} foreach _permList;
}] call compile_Global;

['A3FL_Company_UpdateRanks',
{
	disableSerialization;
	private ["_config","_hire","_shop","_bank","_cRanks","_garage","_transfer","_twitter","_filesmanager","_stockaccess","_stockmanage"];
	private _display = findDisplay 137;
	private _cid = [(player getVariable ["character_id",""])] call A3PL_Config_GetCompanyID;
	private _ranks = [_cid, "ranks"] call A3PL_Config_GetCompanyData;
	private _pay = 0;
	private _control = _display displayCtrl 5474;
	private _rank = _control lbData (lbCurSel _control);
	private _control = _display displayCtrl 5472;
	if (count(_control lbData 0) > 0) then {
		{
			if ((_x#0) isEqualTo _cid) exitWith {_config = _x#7};
		} forEach Server_Companies;

		{
			if ((_x#0) isEqualTo _rank) exitWith {
				_hire = _x#3;
				_shop = _x#4;
				_bank = _x#5;
				_cRanks = _x#6;
				_garage = _x#7;
				_transfer = _x#8;
				_twitter = _x#9;
				_filesmanager = _x#10;
				_stockaccess = _x#11;
				_stockmanage = _x#12;
			};
		} forEach _config;
		if (_transfer isEqualTo true) then {lbSetColor [5475, 0, [0,0.7,0,1]]} else {lbSetColor [5475, 0, [1,0,0,1]]};
		if (_cRanks isEqualTo true) then {lbSetColor [5475, 1, [0,0.7,0,1]]} else {lbSetColor [5475, 1, [1,0,0,1]]};
		if (_shop isEqualTo true) then {lbSetColor [5475, 2, [0,0.7,0,1]]} else {lbSetColor [5475, 2, [1,0,0,1]]};
		if (_hire isEqualTo true) then {lbSetColor [5475, 3, [0,0.7,0,1]]} else {lbSetColor [5475, 3, [1,0,0,1]]};
		if (_garage isEqualTo true) then {lbSetColor [5475, 4, [0,0.7,0,1]]} else {lbSetColor [5475, 4, [1,0,0,1]]};
		if (_bank isEqualTo true) then {lbSetColor [5475, 5, [0,0.7,0,1]]} else {lbSetColor [5475, 5, [1,0,0,1]]};
		if (_twitter isEqualTo true) then {lbSetColor [5475, 6, [0,0.7,0,1]]} else {lbSetColor [5475, 6, [1,0,0,1]]};
		if (_filesmanager isEqualTo true) then {lbSetColor [5475, 7, [0,0.7,0,1]]} else {lbSetColor [5475, 7, [1,0,0,1]]};
		if (_stockaccess isEqualTo true) then {lbSetColor [5475, 8, [0,0.7,0,1]]} else {lbSetColor [5475, 8, [1,0,0,1]]};
		if (_stockmanage isEqualTo true) then {lbSetColor [5475, 9, [0,0.7,0,1]]} else {lbSetColor [5475, 9, [1,0,0,1]]};
	};
	private _control = _display displayCtrl 5473;
	lbClear _control;
	{
		if ((_x select 0) isEqualTo _rank) then
		{
			_pay = _x select 2;
			{
				private _charID = _x;
				private _name = format ["John Doe (%1)",_charID];
				{
					if ((_x select 1) isEqualTo _charID) then {
						_name = _x select 0;
					};
				} forEach A3FL_COMPANYPLIST;
				_control lbAdd _name;
			} forEach (_x select 1);
		};
	} forEach _ranks;
	_control = _display displayCtrl 1401;
	_control ctrlSetText str(_pay);
}] call compile_Global;

['A3PL_Company_DescEdit', {
	private _display = findDisplay 137;
	private _newDesc = ctrlText (_display displayCtrl 1402);
	private _charID = (player getVariable ["character_id",""]);
	private _cid = [_charID] call A3PL_Config_GetCompanyID;
	private _cBank = [_cid, "bank"] call A3PL_Config_GetCompanyData;
	private _isBoss = ([_charID] call A3PL_Config_IsCompanyBoss);
	if(Company_Edit_Description_Price > _cBank) exitWith {[("STR_A3PL_Company_DescriptionChangeCost" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!_isBoss) exitWith {[("STR_A3PL_Company_DescriptionChangeOnlyOwner" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[_cid, -Company_Edit_Description_Price, ("STR_A3PL_Company_DescriptionChange" call A3PL_Localize)] remoteExec ["Server_Company_SetBank",2];
	closeDialog 0;
	[_cid, _newDesc] remoteExec ["Server_Company_SetDesc",2];
	[getPlayerUID player,_charID,"Company_Description_Edit",[format["Company: %1 | New description: %2",_cid,_newDesc]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

['A3PL_Company_Fire', {
	private ["_display","_control","_tcharID"];
	_display = findDisplay 137;

	_control = _display displayCtrl 1500;
	_charID = (player getVariable ["character_id",""]);
	_tcharID = _control lbData (lbCurSel _control);
	_cid = [_charID] call A3PL_Config_GetCompanyID;
	_boss = [_cid, "boss"] call A3PL_Config_GetCompanyData;
	if (lbCurSel _control < 0) exitwith {[("STR_A3PL_Company_SelectTarget" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if(_tcharID isEqualTo _boss) exitWith {
		[("STR_A3PL_Company_CantFireCEO" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};

	private _hasPerm = [_cid,"hire",_charID] call A3FL_Config_GetCompanyPermissions;
	private _isBoss = ([_charID] call A3PL_Config_IsCompanyBoss);
	if(!(_hasPerm) && !(_isBoss)) exitWith {[("STR_A3PL_Company_ManageEmployeesDenied" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	closeDialog 0;
	[_cid, _tcharID] remoteExec ["Server_Company_Fire",2];
	[getPlayerUID player,_charID,"Company_Fire",[format["Company: %1 | Fired player: %2",_cid,_tcharID]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

['A3PL_Company_SetPay', {
	private ["_display","_control","_charID"];
	_display = findDisplay 137;
	_newPay = parseNumber(ctrlText (_display displayCtrl 1401));
	if(_newPay<0) exitWith {[("STR_Common_InvalidValue" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_control = _display displayCtrl 1500;
	_charID = (player getVariable ["character_id",""]);
	_control = _display displayCtrl 5474;
	_rank = _control lbData (lbCurSel _control);
	_cid = [_charID] call A3PL_Config_GetCompanyID;

	private _hasPerm = [_cid,"ranks",_charID] call A3FL_Config_GetCompanyPermissions;
	private _isBoss = ([_charID] call A3PL_Config_IsCompanyBoss);
	if(!(_hasPerm) && !(_isBoss)) exitWith {[("STR_A3PL_Company_ManageRanksDenied" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	closeDialog 0;
	[_cid, player, _newPay, _rank] remoteExec ["Server_Company_SetPay",2];
	[getPlayerUID player,_charID,"Company_Set_Pay",[format["Company: %1 | New salary: %2 for rank: %3",_cid,_newPay,_rank]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

['A3FL_Company_AddRank', {
	private _display = findDisplay 137;
	private _control = _display displayCtrl 1708;
	private _charID = (player getVariable ["character_id",""]);
	private _cid = [_charID] call A3PL_Config_GetCompanyID;
	private _rank = ctrlText _control;
	if ((count _rank < 3) OR (count _rank > 30)) exitwith {[("STR_Common_InvalidValue" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _hasPerm = [_cid,"ranks",_charID] call A3FL_Config_GetCompanyPermissions;
	private _isBoss = ([_charID] call A3PL_Config_IsCompanyBoss);
	if(!(_hasPerm) && !(_isBoss)) exitWith {[("STR_A3PL_Company_ManageRanksDenied" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[_cid,player,_rank] remoteExec ["Server_Company_AddRank", 2];
	private _control = _display displayCtrl 5474;
	private _index = _control lbAdd format ["%1 - $0.00",_rank];
	_control lbSetData [_index,_rank];
	[getPlayerUID player,_charID,"Company_Add_Rank",[format["Company: %1 | Rank created: %2",_cid,_rank]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

['A3FL_Company_DeleteRank', {
	private _display = findDisplay 137;
	private _charID = (player getVariable ["character_id",""]);
	private _cid = [_charID] call A3PL_Config_GetCompanyID;
	private _control = _display displayCtrl 5474;
	if (lbCurSel _control < 0) exitwith {[("STR_A3PL_Company_SelectRank" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _rank = _control lbData (lbCurSel _control);

	private _hasPerm = [_cid,"ranks",_charID] call A3FL_Config_GetCompanyPermissions;
	private _isBoss = ([_charID] call A3PL_Config_IsCompanyBoss);
	if(!(_hasPerm) && !(_isBoss)) exitWith {[("STR_A3PL_Company_ManageRanksDenied" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[_cid,player,_rank] remoteExec ["Server_Company_RemoveRank", 2];
	private _control = _display displayCtrl 5474;
	_control lbDelete (lbCurSel _control);
	call A3FL_Company_UpdateRanks;
	[getPlayerUID player,_charID,"Company_Delete_Rank",[format["Company: %1 | Rank deleted: %2",_cid,_rank]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

['A3FL_Company_SetRank', {
	private _display = findDisplay 137;
	private _charID = (player getVariable ["character_id",""]);
	private _cid = [_charID] call A3PL_Config_GetCompanyID;
	private _control = _display displayCtrl 1500;
	if (lbCurSel _control < 0) exitwith {[("STR_A3PL_Company_SelectTarget" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _person = _control lbData (lbCurSel _control);
	private _personName = _control lbText (lbCurSel _control);
	private _control = _display displayCtrl 5474;
	if (lbCurSel _control < 0) exitwith {[("STR_A3PL_Company_SelectRank" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _rank = _control lbData (lbCurSel _control);

	private _hasPerm = [_cid,"ranks",_charID] call A3FL_Config_GetCompanyPermissions;
	private _isBoss = ([_charID] call A3PL_Config_IsCompanyBoss);
	if(!(_hasPerm) && !(_isBoss)) exitWith {[("STR_A3PL_Company_ManageRanksDenied" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[_cid,player,_rank,_person,_personName] remoteExec ["Server_Company_SetRank", 2];
	call A3FL_Company_UpdateRanks;
	[getPlayerUID player,_charID,"Company_Set_Rank",[format["Company: %1 | Grade: %2 donné au Player: %3",_cid,_rank,_personName]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

['A3FL_Company_SetPerm', {
	private _display = findDisplay 137;
	private _charID = (player getVariable ["character_id",""]);
	private _cid = [_charID] call A3PL_Config_GetCompanyID;
	private _control = _display displayCtrl 5474;
	if (lbCurSel _control < 0) exitwith {[("STR_A3PL_Company_SelectRank" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _person = _control lbData (lbCurSel _control);
	private _personName = _control lbText (lbCurSel _control);
	private _control = _display displayCtrl 5475;
	if (lbCurSel _control < 0) exitwith {[("STR_A3PL_Company_SelectPermission" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _perm = _control lbData (lbCurSel _control);

	private _control = _display displayCtrl 5474;
	private _rank = _control lbData (lbCurSel _control);

	private _hasPerm = [_cid,"ranks",_charID] call A3FL_Config_GetCompanyPermissions;
	private _isBoss = ([_charID] call A3PL_Config_IsCompanyBoss);
	if(!(_hasPerm) && !(_isBoss)) exitWith {[("STR_A3PL_Company_ManageRanksDenied" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[_cid,_rank,_perm,player,true] remoteExec ["Server_Company_SetPerm", 2];
	call A3FL_Company_UpdateRanks;
	[getPlayerUID player,_charID,"Company_Set_Perm",[format["Company: %1 | Permission: %2 given to rank: %3",_cid,_perm,_rank]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

['A3FL_Company_UnsetPerm', {
	private _display = findDisplay 137;
	private _charID = (player getVariable ["character_id",""]);
	private _cid = [_charID] call A3PL_Config_GetCompanyID;
	private _control = _display displayCtrl 5474;
	if (lbCurSel _control < 0) exitwith {[("STR_A3PL_Company_SelectRank" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _person = _control lbData (lbCurSel _control);
	private _personName = _control lbText (lbCurSel _control);
	private _control = _display displayCtrl 5475;
	if (lbCurSel _control < 0) exitwith {[("STR_A3PL_Company_SelectPermission" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _perm = _control lbData (lbCurSel _control);

	private _control = _display displayCtrl 5474;
	private _rank = _control lbData (lbCurSel _control);

	private _hasPerm = [_cid,"ranks",_charID] call A3FL_Config_GetCompanyPermissions;
	private _isBoss = ([_charID] call A3PL_Config_IsCompanyBoss);
	if(!(_hasPerm) && !(_isBoss)) exitWith {[("STR_A3PL_Company_ManageRanksDenied" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[_cid,_rank,_perm,player,false] remoteExec ["Server_Company_SetPerm", 2];
	call A3FL_Company_UpdateRanks;
	[getPlayerUID player,_charID,"Company_UnSet_Perm",[format["Company: %1 | Permission: %2 withdrawn from rank: %3",_cid,_perm,_rank]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

['A3PL_Company_Transfer', {

	_amount = round(parseNumber(ctrlText 5372));
	_companyTransfer = false;
	if(["(E)", lbText [5472, (lbCurSel 5472)]] call BIS_fnc_inString) then {_companyTransfer = true;} else {_companyTransfer = false;};

	if (((lbCurSel 5472) == -1) || (_amount <= 0)) exitWith {[("STR_A3PL_Company_TransferError" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _charID = (player getVariable ["character_id",""]);
	private _cid = [_charID] call A3PL_Config_GetCompanyID;
	private _hasPerm = [_cid,"bank",_charID] call A3FL_Config_GetCompanyPermissions;
	private _isBoss = ([_charID] call A3PL_Config_IsCompanyBoss);
	private _format = "";
	if(!(_hasPerm) && !(_isBoss)) exitWith {[("STR_Common_BankAccessDenied" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_cBank = [_cid, "bank"] call A3PL_Config_GetCompanyData;
	_cName = [_cid, "name"] call A3PL_Config_GetCompanyData;
	if (_amount > _cBank) exitWith {[("STR_A3PL_Company_NotEnoughFunds" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if(_companyTransfer) then {
		_targetCID = parseNumber(lbData [5472, (lbCurSel 5472)]);
		_cTName = [_targetCID] call A3PL_Config_GetCompanyData;

		[_targetCID, _amount, format[("STR_A3PL_Company_TransferFrom" call A3PL_Localize),_cName]] remoteExec ["Server_Company_SetBank",2];
		[_cid, -_amount, format[("STR_A3PL_Company_TransferTo" call A3PL_Localize),_cTName]] remoteExec ["Server_Company_SetBank",2];

		[getPlayerUID player,_charID,"Company_Transfer",[format["Company: %1 | Amount: %2 | To company: %3",_cid,_amount,_targetCID]]] remoteExec ["Server_Log_New",2];

		_format = format[("STR_A3PL_Company_TransferToCompanySuccess" call A3PL_Localize), [_amount, 1, 0, true] call CBA_fnc_formatNumber,_cTName];
	} else {
		_sendTo = lbData [5472, (lbCurSel 5472)];
		_sendToCompile = call compile _sendTo;
		private _hasAccount = [_sendTo,1] call A3PL_Bank_HasAccount;
		if (!hasAccount) exitWith {[("STR_A3PL_Company_TargetNoBankAccount" call A3PL_Localize),Color_Red] call A3PL_Notification};
		_format = format[("STR_A3PL_Company_TransferToPlayerSuccess" call A3PL_Localize), [_amount, 1, 0, true] call CBA_fnc_formatNumber, (name _sendToCompile)];
		[format[("STR_A3PL_Company_TransferToPlayerReceive" call A3PL_Localize),_amount,_cName], Color_green] remoteExec ["A3PL_Notification",_sendTo];
		[_sendToCompile, 'Player_Bank', ((_sendToCompile getVariable 'Player_Bank') + _amount)] remoteExec ["Server_Core_ChangeVar",2];
		[_cid, -_amount, format[("STR_A3PL_Company_TransferTo" call A3PL_Localize),name _sendToCompile]] remoteExec ["Server_Company_SetBank",2];
		[getPlayerUID player,_charID,"Company_Transfer",[format["Company: %1 | Amount: %2 | To Player: %3",_cid,_amount,_sendTo]]] remoteExec ["Server_Log_New",2];
	};
	[_format,Color_Green] call A3PL_Notification;
	closeDialog 0;
}] call compile_Global;

['A3PL_Company_HistoryOpen', {
	private ["_display","_control","_charID","_isCorporate","_cid","_hasPerm","_isBoss"];
	disableSerialization;
	_charID = (player getVariable ["character_id",""]);
	_isCorporate = [_charID] call A3PL_Config_InCompany;
	if(!_isCorporate) exitWith {[("STR_Common_NotInCompany" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	
	_cid = [_charID] call A3PL_Config_GetCompanyID;
	_hasPerm = [_cid,"bank",_charID] call A3FL_Config_GetCompanyPermissions;
	_isBoss = ([_charID] call A3PL_Config_IsCompanyBoss);
	if(!(_hasPerm) && !(_isBoss)) exitWith {[("STR_A3PL_Company_ManageTransactionsDenied" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	createDialog "Dialog_Company_History";
	[_cid,player] remoteExec ["Server_Company_HistorySetup",2];
	[getPlayerUID player,_charID,"Company_History_Open",["Transactions history menu opened"]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

['A3PL_Company_HistoryReceive', {
	_history = param [0,[]];

	_display = findDisplay 138;
	_control = _display displayCtrl 1500;

	if(count _history isEqualTo 0) then
	{
		_control lbAdd ("STR_A3PL_Company_ManageTransactionsEmpty" call A3PL_Localize);
	}
	else
	{
		{
			if((_x select 0) > 0) then
			{
				_control lbAdd format["%3 | $%1 (%2)", _x select 0, _x select 1, _x select 2];
				_control lbSetColor [_forEachIndex, [0,0.8,0.1,1]];
			}
			else
			{
				_control lbAdd format["%3 | $%1 (%2)", _x select 0, _x select 1, _x select 2];
				_control lbSetColor [_forEachIndex, [0.8,0,0.1,1]];
			};
		} foreach _history;
	};
}] call compile_Global;

['A3PL_Company_Paycheck', {
	private _charID = (player getVariable ["character_id",""]);
	private _cid = [_charID] call A3PL_Config_GetCompanyID;
	private _payAmount = [_cid, "pay", _charID] call A3FL_Config_GetCompanyRankData;
	private _companyBudget = [_cid, "bank"] call A3PL_Config_GetCompanyData;
	if(_companyBudget < _payAmount) then {_payAmount = 0;};
	[_cid, -_payAmount, ""] remoteExec ["Server_Company_SetBank",2];
	if (_payAmount isEqualTo 0) then {
        [("STR_A3PL_Company_NotEnoughMoneyPayroll" call A3PL_Localize),Color_Red] call A3PL_Notification;
		[getPlayerUID player,_charID,"Company_Paycheck_NoMoney",[format["Company: %1 | Company bank: %2 | Unpaid amount: %3",_cid,_companyBudget,_payAmount]]] remoteExec ["Server_Log_New",2];
	} else {
		[format[("STR_A3PL_Company_Paycheck_Sent" call A3PL_Localize),_payAmount],Color_Green] call A3PL_Notification;
		[getPlayerUID player,_charID,"Company_Paycheck_Success",[format["Company: %1 | Company bank: %2 | Paid amount: %3",_cid,_companyBudget,_payAmount]]] remoteExec ["Server_Log_New",2];
	};
	_payAmount;
}] call compile_Global;

['A3PL_Company_Resign', {
	private _charID = (player getVariable ["character_id",""]);
	private _cid = [_charID] call A3PL_Config_GetCompanyID;
	[("STR_A3PL_Company_Resigned" call A3PL_Localize),Color_Green] call A3PL_Notification;
	[_cid, _charID, false] remoteExec ["Server_Company_Fire",2];
	[getPlayerUID player,_charID,"Company_Resign",[format["Resignation from company %1",_cid]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

/*
	COMPANY SHOPS BELLOW
*/

['A3PL_Company_OpenBuyShop', {
	private _nearBy = nearestObjects [player, Company_Shops, 20];
	if (count _nearBy < 1) exitwith {[("STR_A3PL_Company_NoNearbyBusiness" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	A3PL_Company_BuyObject = _nearBy select 0;

	createDialog "Dialog_CompanyShop_Buy";
	private _display = findDisplay 130;
	private _control = _display displayCtrl 1100;
	_control ctrlSetText format ["$%1",[Company_Shops_Price, 1, 2, true] call CBA_fnc_formatNumber];
	[getPlayerUID player,(player getVariable ["character_id",""]),"Company_OpenBuyShop_Menu",["Company shop - buy menu opened"]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

['A3PL_Company_BuyShop', {
	private _cid = [(player getVariable ["character_id",""])] call A3PL_Config_GetCompanyID;
	private _cBudget = [_cid, "bank"] call A3PL_Config_GetCompanyData;

	if(_cBudget < Company_Shops_Price) exitWith {[format[("STR_A3PL_Company_BuyShop_NotEnoughFunds" call A3PL_Localize),[Company_Shops_Price, 1, 2, true] call CBA_fnc_formatNumber],Color_Red] call A3PL_Notification;};

	[_cid, -(Company_Shops_Price), ("STR_A3PL_Company_Local_Buy" call A3PL_Localize)] remoteExec ["Server_Company_SetBank",2];
	[("STR_Common_FederalReserve" call A3PL_Localize),Company_Shops_Price] remoteExec ["Server_Government_AddBalance",2];
	[A3PL_Company_BuyObject,player,_cid] remoteExec ["Server_Company_BuyShop",2];
	closeDialog 0;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Company_Buy_Shop",[format["Company: %1 | Local bought for: %2",_cid,Company_Shops_Price]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

['A3PL_Company_OpenSellShop', {
	private _nearBy = nearestObjects [player, Company_Shops, 20];
	if (count _nearBy < 1) exitwith {[("STR_A3PL_Company_NoNearbyBusiness" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	A3PL_Company_BuyObject = _nearBy select 0;

	private _cid = [(player getVariable ["character_id",""])] call A3PL_Config_GetCompanyID;
	private _shopCid = A3PL_Company_BuyObject getVariable["cid",0];
	if(!(_shopCid isEqualTo _cid)) exitWith {[("STR_Common_LocalNotOwnedByCompany" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	createDialog "Dialog_CompanyShop_Sell";
	private _display = findDisplay 130;
	private _control = _display displayCtrl 1100;
	_control ctrlSetText format ["$%1",[(Company_Shops_Price*0.7), 1, 2, true] call CBA_fnc_formatNumber];
	[getPlayerUID player,(player getVariable ["character_id",""]),"Company_OpenSellShop_OpenMenu",["Shop sell menu opened"]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

['A3PL_Company_SellShop', {
	private _cid = [(player getVariable ["character_id",""])] call A3PL_Config_GetCompanyID;
	private _cBudget = [_cid, "bank"] call A3PL_Config_GetCompanyData;
	private _shopCid = A3PL_Company_BuyObject getVariable["cid",0];
	if(!(_shopCid isEqualTo _cid)) exitWith {[("STR_Common_LocalNotOwnedByCompany" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[_cid, +(Company_Shops_Price*0.7), ("STR_A3PL_Company_Local_Sold" call A3PL_Localize)] remoteExec ["Server_Company_SetBank",2];
	[A3PL_Company_BuyObject,player] remoteExec ["Server_Company_SellShop",2];
	closeDialog 0;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Company_SellShop",[format["Company: %1 | ShopCID: %2 | Company bank: %3 | Sold for: %4",_cid,_shopCid,_cBudget,(Company_Shops_Price*0.7)]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

/* COMPANY BILLS */

["A3PL_Company_SendBill",{
	params[
		["_target",objNull,[objNull]],
		["_amount",0,[0]],
		["_desc","",[""]]
	];
	if(_target isEqualTo "") exitWith {};

	private _cid = [(player getVariable ["character_id",""])] call A3PL_Config_GetCompanyID;
	[_cid, _amount, _desc, _target] remoteExec ["Server_Company_SendBill",2];
	private _amount = [_amount, 1, 0, true] call CBA_fnc_formatNumber;
	[format[("STR_A3PL_Company_Invoice_Sent" call A3PL_Localize),_amount],Color_Green] call A3PL_Notification;
	closeDialog 0;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Company_SendBill",[format ["Company: %1 | Amount: %2 | Description: %3 | Player: %4",_cid,_amount,_desc,_target]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

["A3PL_Company_ReceiveBill",{
	private _amount = param [0,0];
	_amount = [_amount, 1, 0, true] call CBA_fnc_formatNumber;
	[format[("STR_A3PL_Company_Invoice_Received" call A3PL_Localize),_amount],Color_Green] call A3PL_Notification;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Company_ReceiveBill",[format ["Amount: %1",_amount]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

["A3PL_Company_BillPay",{
	disableSerialization;
	_display = findDisplay 139;
	_control = _display displayCtrl 1500;
	_isPaid = _control lbValue (lbCurSel _control);
	if(_isPaid isEqualTo 1) exitWith {[("STR_A3PL_Company_Invoice_AlreadyPaid" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_control = _display displayCtrl 1001;
	_amount = parseNumber (ctrlText _control);

	private _result = [_amount] call A3PL_Bank_handleCB;
	if (!_result) exitWith {};

	_control = _display displayCtrl 1500;
	_bid = parseNumber(_control lbData (lbCurSel _control));

	[_bid,_amount,player] remoteExec ["Server_Company_PayBill"];
	closeDialog 0;
	_amount = [_amount, 1, 0, true] call CBA_fnc_formatNumber;
	["company_paybill"] call PO_Achievement_Learn;
	[format[("STR_A3PL_Company_Invoice_Paid" call A3PL_Localize),_amount],Color_Green] call A3PL_Notification;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Company_BillPay",[format ["Amount paid: %1",_amount]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

["A3PL_Company_BillDataReceive",{
	_billId = param [0,-1];
	_billAmount = param [1,0];
	_billDesc = param [2,""];
	_billComp = param [3,""];

	if(_billId isEqualTo -1) exitWith {};

	disableSerialization;
	_display = findDisplay 139;

	_control = _display displayCtrl 1000;
	_control ctrlSetText format ["%1",_billComp];

	_control = _display displayCtrl 1001;
	_control ctrlSetText format ["%1",_billAmount];

	_control = _display displayCtrl 1100;
	_control ctrlSetStructuredText parseText format["<t align='left' size='1.2'>%1</t>",_billDesc];
}] call compile_Global;

["A3PL_Company_BillPayCompany",{
	disableSerialization;
	_display = findDisplay 139;
	_control = _display displayCtrl 1500;
	_isPaid = _control lbValue (lbCurSel _control);
	if(_isPaid isEqualTo 1) exitWith {[("STR_A3PL_Company_Invoice_AlreadyPaid" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_control = _display displayCtrl 1001;
	_amount = parseNumber (ctrlText _control);

	_cid = [(player getVariable ["character_id",""])] call A3PL_Config_GetCompanyID;
	_companyBudget = [_cid, "bank"] call A3PL_Config_GetCompanyData;
	if(_companyBudget < _amount) exitwith {
		[format[("STR_A3PL_Company_Invoice_CompanyNotEnoughFunds" call A3PL_Localize),_amount-_companyBudget],Color_Red] call A3PL_Notification;
	};

	[_cid, -_amount, ("STR_A3PL_Company_Invoice_Payment" call A3PL_Localize)] remoteExec ["Server_Company_SetBank",2];

	_control = _display displayCtrl 1500;
	_bid = parseNumber(_control lbData (lbCurSel _control));

	[_bid,_amount,player] remoteExec ["Server_Company_PayBill"];
	closeDialog 0;
	_amount = [_amount, 1, 0, true] call CBA_fnc_formatNumber;
	[format[("STR_A3PL_Company_Invoice_CompanyPaid" call A3PL_Localize),_amount],Color_Green] call A3PL_Notification;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Company_BillPay",[format ["Company: %1 | From: %2 | Amount paid: %3",_cid,_bid,_amount]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

["A3PL_Company_BillsMenu",{
	private ["_display","_control","_isCorporate","_target"];
	disableSerialization;

	createDialog "Dialog_CompanyBillList";
	_display = findDisplay 139;

	_control = _display displayCtrl 1600;
	_control buttonSetAction "call A3PL_Company_BillPay;";

	_control = _display displayCtrl 1601;
	_control buttonSetAction "closeDialog 0;";

	_control = _display displayCtrl 1201;
	_control ctrlShow false;
	_control = _display displayCtrl 1602;
	_control ctrlShow false;

	if(([(player getVariable ["character_id",""])] call A3PL_Config_IsCompanyBoss)) then {
		_control = _display displayCtrl 1603;
		_control buttonSetAction "call A3PL_Company_BillPayCompany;";
	} else {
		_control = _display displayCtrl 1202;
		_control ctrlShow false;
		_control = _display displayCtrl 1603;
		_control ctrlShow false;
	};

	_control = _display displayCtrl 1500;
	{
		_index = _control lbAdd format["#%1", _forEachIndex];
		_control lbSetData [_index,str(_x select 0)];
		_control lbSetValue [_index,(_x select 5)];
		if((_x select 5) isEqualTo 0) then {
			_control lbSetColor [_index, [0.8,0,0.1,1]];
		} else {
			_control lbSetColor [_index, [0,0.8,0.1,1]];
		};
	} foreach (player getVariable["player_bills",[]]);

	_control ctrlAddEventHandler ["LBSelChanged",{
		_display = findDisplay 139;
		_control = _display displayCtrl 1500;
		[parseNumber(_control lbData (lbCurSel _control)), player] remoteExec ["Server_Company_LoadBillData",2];
	}];

	[getPlayerUID player,(player getVariable ["character_id",""]),"Company_BillsMenu_OpenMenu",["Invoice menu opened"]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

["A3PL_Company_ConfigShopMarker", {
	if !([player getVariable ["character_id",""]] call A3PL_Config_IsCompanyBoss) exitWith {
		[("STR_Server_Company_OnlyBoss" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};

	if (isNil "CompanyShop_AvailableIcons") exitWith {
		[("STR_Common_DataNotLoaded" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	private _availableIcons = CompanyShop_AvailableIcons;

	createDialog "Dialog_CompanyShop_MarkerConfig";
	private _display = findDisplay 141;

	private _iconList = _display displayCtrl 1410;
	private _descEdit = _display displayCtrl 1411;

	{
		private _idx = _iconList lbAdd (_x#1);
		_iconList lbSetData [_idx, _x#0];
	} forEach _availableIcons;
	_iconList lbSetCurSel 0;

	private _nearShops = nearestObjects [player, ["Land_A3PL_Kainnon_DMV","Land_Shop_DED_Shop_01_F","Land_Shop_DED_Shop_02_F","Land_buildingGunStore1","Land_buildingsNightclub2","Land_A3PL_Cinema","Land_A3FL_Anton_Store","Land_A3PL_Garage","land_smallshop_ded_smallshop_02_f","land_smallshop_ded_smallshop_01_f","Land_A3FL_Brick_Shop_1","Land_A3FL_Brick_Shop_2","Land_A3PL_Showroom","Land_A3PL_Gas_Station","Land_A3FL_Airport_Hangar","Land_EC_CompanyStore","Land_A3FL_Anton_Store_Interior","Land_EC_Warehouse"], 20];
	{
		if (!isNil {_x getVariable "companyName"}) exitWith {
			private _curIcon = _x getVariable ["markerIcon", "A3FL_Markers_CompanyShopClosed"];
			private _curDesc = _x getVariable ["markerDescription", ""];
			_descEdit ctrlSetText _curDesc;
			{
				if ((_availableIcons#_forEachIndex#0) isEqualTo _curIcon) exitWith {
					_iconList lbSetCurSel _forEachIndex;
				};
			} forEach _availableIcons;
		};
	} forEach _nearShops;
}] call compile_Global;

["A3PL_Company_ConfigShopMarker_Confirm", {
	disableSerialization;
	private _display = findDisplay 141;
	if (isNull _display) exitWith {};

	private _iconList = _display displayCtrl 1410;
	private _descEdit = _display displayCtrl 1411;

	private _selectedIcon = _iconList lbData (lbCurSel _iconList);
	if (isNil "_selectedIcon" || {_selectedIcon isEqualTo ""}) then { _selectedIcon = "A3FL_Markers_CompanyShopClosed"; };

	private _description = "";
	if (!isNull _descEdit) then { _description = ctrlText _descEdit; };
	if (isNil "_description") then { _description = ""; };

	diag_log format["[ShopMarkerConfig] CLIENT - _descEdit isNull: %1, ctrlText raw: '%2', _description: '%3', typeName: %4", isNull _descEdit, ctrlText _descEdit, _description, typeName _description];

	private _dataToSend = [player, _selectedIcon, _description];
	diag_log format["[ShopMarkerConfig] CLIENT - sending: [player, '%1', '%2'], array count: %3", _selectedIcon, _description, count _dataToSend];

	closeDialog 0;

	_dataToSend remoteExec ["Server_Company_UpdateShopMarkerConfig", 2];
}] call compile_Global;
