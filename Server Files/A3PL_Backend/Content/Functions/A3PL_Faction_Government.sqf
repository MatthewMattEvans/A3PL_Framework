/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Government_OpenTreasury", {
    disableSerialization;
    if (!([("STR_Common_DOJ" call A3PL_Localize)] call A3PL_Government_isFactionLeader) || !([("STR_Common_GOV" call A3PL_Localize)] call A3PL_Government_isFactionLeader)) exitwith {[("STR_A3PL_Government_AccessDenied" call A3PL_Localize), Color_Red] call A3PL_Notification;};

    createDialog "Dialog_Treasury";
    private _display = findDisplay 109;
    private _totalBalance = 0;

    _control = _display displayCtrl 2100;
    {
        if (!((_x select 0) IN [])) then {
            private ["_balanceName","_balanceAmount"];
            _balanceName = _x select 0;
            _balanceAmount = _x select 1;
            _control lbAdd _balanceName;
            _totalBalance = _totalBalance + _balanceAmount;
        };
    } foreach (missionNameSpace getVariable ["Config_Government_Balances",[]]);
    _control ctrlAddEventhandler ["LBSelChanged",
    {
        private ["_control","_display","_balance","_balanceAmount"];
        _display = findDisplay 109;
        _control = param [0,ctrlNull];
        _balance = _control lbText (lbCurSel _control);
        _balanceAmount = 0;
        {
            if (_x select 0 == _balance) exitwith {_balanceAmount = _x select 1;};
        } foreach (missionNameSpace getVariable ["Config_Government_Balances",[]]);
        _control = _display displayCtrl 1400;
        _control ctrlSetText (format ["$%1",([_balanceAmount, 1, 0, true] call CBA_fnc_formatNumber)]);
    }];

    _control = _display displayCtrl 1402;
    _control ctrlSetText format ["$%1",([_totalBalance, 1, 0, true] call CBA_fnc_formatNumber)];

    _control = _display displayCtrl 2101;
    {
        _control lbAdd (_x select 0);
    } foreach (missionNameSpace getVariable ["Config_Government_Taxes",[]]);

    _control ctrlAddEventHandler ["LBSelChanged",
    {
        private _display = findDisplay 109;
        private _control = param [0,ctrlNull];
        private _taxSelected = _control lbText (lbCurSel _control);
        private _taxRate = 0;
        {
            if (_x select 0 isEqualTo _taxSelected) exitwith {_taxRate = _x select 1;};
        } foreach (missionNameSpace getVariable ["Config_Government_Taxes",[]]);
        _control = _display displayCtrl 1403;
        _control ctrlSetText format ["%1%2",_taxRate*100,"%"];
    }];

    _control = _display displayCtrl 2102;
    {
        if ((_x select 0) IN [("STR_Common_FireDepartment" call A3PL_Localize),("STR_Common_SheriffsDepartment" call A3PL_Localize),("STR_Common_DepartmentOfJustice" call A3PL_Localize),("STR_Common_Government" call A3PL_Localize),("STR_Common_FederalReserve" call A3PL_Localize)]) then {
            private _balanceName = format ["%1 ($%2)",(_x select 0),([(_x select 1), 1, 0, true] call CBA_fnc_formatNumber)];
            private _index = _control lbAdd _balanceName;
            _control lbSetData [_index,_x select 0];
        };
    } foreach (missionNameSpace getVariable ["Config_Government_Balances",[]]);

    _control = _display displayCtrl 2103;
    {
        private _lawi = _forEachIndex + 1;
        _control lbAdd format [("STR_A3PL_Government_Decree" call A3PL_Localize),_lawi];
    } foreach (missionNameSpace getVariable ["Config_Government_Laws",[]]);

    _control ctrlAddEventHandler ["LBSelChanged",
    {
        private _display = findDisplay 109;
        private _control = param [0,ctrlNull];
        private _law = Config_Government_Laws select (lbCurSel _control);
        private _control = _display displayCtrl 1000;
        _control ctrlSetText _law;
        _control = _display displayCtrl 1401;
        _control ctrlSetStructuredText parseText _law;
    }];
}] call compile_Global;

["A3PL_Government_FactionBalance",{
    private _balance = param [0,""];
    private _balanceAmount = 0;
    {
        if ((_x select 0) isEqualTo _balance) exitwith {_balanceAmount = _x select 1;};
    } foreach (missionNameSpace getVariable ["Config_Government_Balances",[]]);
    _balanceAmount;
}] call compile_Global;

["A3PL_Government_AddBalance",
{
    disableSerialization;
    if(!(call A3PL_Player_AntiSpam)) exitWith {};
    private _display = findDisplay 109;
    private _control = _display displayCtrl 2100;
    if (lbCurSel _control < 0) exitwith {[("STR_A3PL_Government_NoBudgetSelected" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    private _selectedBalance = _control lbText (lbCurSel _control);
    private _selectedBalanceAmount = 0;
    {
        if ((_x select 0) isEqualTo _selectedBalance) exitwith {_selectedBalanceAmount = _x select 1;};
    } foreach (missionNameSpace getVariable ["Config_Government_Balances",[]]);
    _control = _display displayCtrl 2102;
    if (lbCurSel _control < 0) exitwith {[("STR_A3PL_Government_NoTargetSelected" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    _transferTo = _control lbData (lbCurSel _control);
    _control = _display displayCtrl 1404;
    _amount = parseNumber (ctrlText _control);
    if (_amount < 1) exitwith {[("STR_NewGovernment_ValidAmnt" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    if (_amount > _selectedBalanceAmount) exitwith {[("STR_A3PL_Government_TransferLimitExceeded" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    [_transferTo,_amount,_selectedBalance] remoteExec ["Server_Government_AddBalance", 2];
}] call compile_Global;

["A3PL_Government_SetTax",
{
    disableSerialization;
    private _display = findDisplay 109;
    private _control = _display displayCtrl 1403;
    private _fail = false;
    private _rate = (ctrlText _control) splitString "%";
    if (count _rate == 0) then {_f = true};
    private _rate = parseNumber (_rate select 0);
    if (isnil "_rate") exitwith {[("STR_NewGovernment_ValidAmnt" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    if ((_rate > 100) OR (_rate < 0)) then {_fail = true};
    if (_fail) exitwith {[("STR_A3PL_Government_TaxRateSet" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    private _control = _display displayCtrl 2101;
    if (lbCurSel _control < 0) exitwith {[("STR_A3PL_Government_NoTaxSelected" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    private _taxChanged = _control lbText (lbCurSel _control);
    [_taxChanged,((parseNumber (((ctrlText 1403) splitString "%") select 0))/100)] remoteExec ["Server_Government_SetTax", 2];
}] call compile_Global;

["A3PL_Government_NewTax",
{
    private ["_msg","_taxChanged","_oldTaxRate","_newTaxRate"];

    _taxChanged = param [0,""];
    _oldTaxRate = (param [1,0])*100;
    _newTaxRate = (param [2,0])*100;

    _msg = format [("STR_A3PL_Government_TaxRateChanged" call A3PL_Localize),_taxChanged,_newTaxRate,_oldTaxRate,"%"];
    [_msg, Color_Green] remoteExec ["A3PL_Notification", -2];
}] call compile_Global;

["A3PL_Government_NewLaw",
{
    private _lawIndex = (param [0,0]) + 1;
    [format [("STR_A3PL_Government_NewLaw" call A3PL_Localize),_lawIndex],Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Government_SetLaw",
{
    disableSerialization;
    private _display = findDisplay 109;
    private _control = _display displayCtrl 2103;
    private _selectedLaw = lbCurSel _control;
    private _lawText = ctrlText (_display displayCtrl 1401);
    if (_selectedLaw isEqualTo -1) exitwith {[("STR_A3PL_Government_NoLawSelected" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    if ((count _lawText < 3) OR (count _lawText > 120)) exitwith {[("STR_A3PL_Government_InvalidLength" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    [0,_selectedLaw,_lawText] remoteExec ["Server_Government_ChangeLaw", 2];
}] call compile_Global;

["A3PL_Government_AddLaw",
{
    disableSerialization;
    private _display = findDisplay 109;
    private _control = _display displayCtrl 2103;
    private _lawText = ctrlText (_display displayCtrl 1401);
    if ((count _lawText < 3) OR (count _lawText > 120)) exitwith {[("STR_A3PL_Government_InvalidLength" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    [1,0,_lawText] remoteExec ["Server_Government_ChangeLaw", 2];
}] call compile_Global;

["A3PL_Government_RemoveLaw",
{
    disableSerialization;
    private _display = findDisplay 109;
    private _control = _display displayCtrl 2103;
    private _selectedLaw = lbCurSel _control;
    if (_selectedLaw isEqualTo -1) exitwith {[("STR_A3PL_Government_NoLawSelected" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    [-1,_selectedLaw] remoteExec ["Server_Government_ChangeLaw", 2];
}] call compile_Global;

["A3PL_Government_isFactionLeader",
{
	params[["_faction","", [""]],["_player",player, [objNull]]];
	private _isLeader = false;
	private _charID = (_player getVariable ["character_id",""]);
	private _uid = getPlayerUID _player;
	private _admins = ["76561198170351694","76561198147147468"]; // Kainnon & Matthew
	if(_uid IN _admins) exitWith {true;};
	{
		if (_x#0 isEqualTo _faction) exitwith {
			if (_charID IN (_x#1)) then {_isLeader = true;};
		};
	} foreach (missionNameSpace getVariable ["Config_Government_FactionLead",[]]);
	_isLeader;
}] call compile_Global;

["A3PL_Government_FactionSetup",
{
	params[["_faction","", [""]]];
	if (_faction isEqualTo "") exitwith {["Error; No faction specified",Color_Red] call A3PL_Notification;};
	[player,_faction] remoteExec ["Server_Government_FactionSetupInfo", 2];
}] call compile_Global;

["A3PL_Government_FactionSetupReceive",
{
	params[
		["_faction","",[""]],
		["_members",[],[[]]],
		["_ranks",[],[[]]]
	];
	disableSerialization;

	A3PL_GOVEDITFACTION = _faction;
	A3PL_GOVRANKS = [] + _ranks;
	A3PL_GOVPLIST = [] + _members;

	createDialog "Dialog_FactionSetup";
	private _display = findDisplay 111;
	_display displayAddEventHandler ["Unload",{A3PL_GOVEDITFACTION = nil; A3PL_GOVRANKS = nil; A3PL_GOVPLIST = nil;}];

	private _control = _display displayCtrl 1501;
	{
		private _index = _control lbAdd _x#0;
		_control lbSetData [_index,_x#1];
	} foreach _members;

	private _control = _display displayCtrl 1502;
	{
		private _index = _control lbAdd _x#0;
		_control lbSetData [_index,_x#0];
	} foreach _ranks;
	_control ctrlAddEventHandler ["LBSelChanged","call A3PL_Government_UpdateRanks;"];
}] call compile_Global;

["A3PL_Government_UpdateRanks",
{
	disableSerialization;
	private _display = findDisplay 111;
	private _control = _display displayCtrl 1502;
	private _rank = _control lbData (lbCurSel _control);
	private _control = _display displayCtrl 1500;
	lbClear _control;
	private _pay = 0;
	{
		if (_x#0 isEqualTo _rank) then
		{
			_pay = _x#2;
			{
				private _charID = _x;
				private _name = format ["Unknown (%1)",_charID];
				{
					if (_x#1 isEqualTo _charID) then {
						_name = _x#0;
					};
				} foreach A3PL_GOVPLIST;
				_control lbAdd _name;
			} foreach _x#1;
		};
	} foreach (A3PL_GOVRANKS);
	_control = _display displayCtrl 1400;
	_control ctrlSetText _rank;
	_control = _display displayCtrl 1401;
	_control ctrlSetText str(_pay);
}] call compile_Global;

["A3PL_Government_SetRank",
{
	disableSerialization;
	private _display = findDisplay 111;
	private _faction = missionNameSpace getVariable ["A3PL_GOVEDITFACTION",""];
	if (_faction isEqualTo "") exitwith {["Error, unable to determine the faction!",Color_Red] call A3PL_Notification;};
	private _control = _display displayCtrl 1501;
	if (lbCurSel _control < 0) exitwith {[("STR_A3PL_Government_NoTargetSelected" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _person = _control lbData (lbCurSel _control);
	private _personName = _control lbText (lbCurSel _control);
	private _control = _display displayCtrl 1502;
	if (lbCurSel _control < 0) exitwith {[("STR_A3PL_Government_NoRankSelected" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _rank = _control lbData (lbCurSel _control);

	[_faction,_person,_rank] remoteExec ["Server_Government_SetRank", 2];
	{
		private _rankx = _x select 0;
		private _persons = _x select 1;
		if (_person IN _persons) then {
			_persons = _persons - [_person];
			A3PL_GOVRANKS set [_forEachIndex,[(_x select 0),_persons,(_x select 2)]];
		};
		if (_rankx isEqualTo _rank) then {
			_persons pushback _person;
		};
	} foreach A3PL_GOVRANKS;
	call A3PL_Government_UpdateRanks;
}] call compile_Global;

["A3PL_Government_Fire",
{
	disableSerialization;
	private _display = findDisplay 111;
	private _faction = missionNameSpace getVariable ["A3PL_GOVEDITFACTION",""];
	if (_faction isEqualTo "") exitwith {["Error, unable to determine the faction!",Color_Red] call A3PL_Notification;};
	private _control = _display displayCtrl 1501;
	if (lbCurSel _control < 0) exitwith {[("STR_A3PL_Government_NoTargetSelected" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _person = _control lbData (lbCurSel _control);

	[_faction,_person] remoteExec ["Server_Government_UnsetRank", 2];
	[_person, "citizen"] remoteExec ["Server_Player_Whitelist",2];

	{
		private _persons = _x select 1;
		if (_person IN _persons) then {
			_persons = _persons - [_person];
			A3PL_GOVRANKS set [_forEachIndex,[(_x select 0),_persons,(_x select 2)]];
		};
	} foreach A3PL_GOVRANKS;
	call A3PL_Government_UpdateRanks;

	private _unit = [_person] call A3PL_Lib_charIDToObject;
	if(!isNull _unit) then {
		[("STR_A3PL_Government_FiredFromInstitution" call A3PL_Localize),Color_Red] remoteExec ["A3PL_Notification",_unit];
		_unit setVariable["faction","citizen",true];
		_unit setVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize),true];
		[_unit,("STR_Common_Job_Unemployed" call A3PL_Localize)] remoteExecCall ["Server_NPC_RequestJob",2];
	};
}] call compile_Global;

["A3PL_Government_AddRank",
{
	disableSerialization;
	private _display = findDisplay 111;
	private _faction = missionNameSpace getVariable ["A3PL_GOVEDITFACTION",""];
	if (_faction isEqualTo "") exitwith {["System: Error determining the faction you are editing",Color_Red] call A3PL_Notification;};
	private _control = _display displayCtrl 1400;
	private _rank = ctrlText _control;
	private _exist = false;
	{
		if ((_x select 0) isEqualTo _rank) exitwith {_exist = true;};
	} foreach A3PL_GOVRANKS;
	if (_exist) exitwith {[("STR_A3PL_Government_RankAlreadyExists" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((count _rank < 3) OR (count _rank > 30)) exitwith {[("STR_A3PL_Government_InvalidName" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	[_faction,_rank] remoteExec ["Server_Government_AddRank", 2];
	private _control = _display displayCtrl 1502;
	private _index = _control lbAdd format ["%1 - $0",_rank];
	_control lbSetData [_index,_rank];
	A3PL_GOVRANKS pushback [_rank,[],0];
}] call compile_Global;

["A3PL_Government_RemoveRank",
{
	disableSerialization;
	private _display = findDisplay 111;
	private _faction = missionNameSpace getVariable ["A3PL_GOVEDITFACTION",""];
	if (_faction isEqualTo "") exitwith {["System: Error determining the faction you are editing",Color_Red] call A3PL_Notification;};
	private _control = _display displayCtrl 1502;
	if (lbCurSel _control < 0) exitwith {[("STR_A3PL_Government_NoRankSelected" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _rank = _control lbData (lbCurSel _control);
	[_faction,_rank] remoteExec ["Server_Government_RemoveRank", 2];
	private _control = _display displayCtrl 1502;
	_control lbDelete (lbCurSel _control);
}] call compile_Global;

["A3PL_Government_SetPay",
{
	disableSerialization;
	private _display = findDisplay 111;
	private _faction = missionNameSpace getVariable ["A3PL_GOVEDITFACTION",""];
	if (_faction isEqualTo "") exitwith {["System: Error determining the faction you are editing",Color_Red] call A3PL_Notification;};
	private _control = _display displayCtrl 1401;
	private _pay = floor(parseNumber (ctrlText _control));
	if ((_pay < GOV_Faction_Min_Pay) || {_pay > GOV_Faction_Max_Pay}) exitwith {[format [("STR_A3PL_Government_WrongSalaryRange" call A3PL_Localize),GOV_Faction_Min_Pay,GOV_Faction_Max_Pay],Color_Red] call A3PL_Notification;};
	private _control = _display displayCtrl 1502;
	if (lbCurSel _control < 0) exitwith {[("STR_A3PL_Government_NoRankSelected" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _rank = _control lbData (lbCurSel _control);
	[_faction,_rank,_pay] remoteExec ["Server_Government_SetPay", 2];

	{
		if (_x#0 isEqualTo _rank) then {
			A3PL_GOVRANKS set [_forEachIndex,[_x#0,_x#1,_pay]];
		};
	} foreach (missionNameSpace getVariable ["A3PL_GOVRANKS",[]]);
	lbClear _control;
	{
		private _index = _control lbAdd _x#0;
		_control lbSetData [_index,_x#0];
	} foreach (missionNameSpace getVariable ["A3PL_GOVRANKS",[]]);
}] call compile_Global;

["A3PL_Government_MyFactionBalance",
{
	private _player = param [0,player];
	private _justName = param [1,false];
	private _faction = _player getVariable ["faction","citizen"];
	private _balance = [_faction] call A3PL_Config_GetBalance;
	if (_justName) exitwith {_balance;};
	_balanceAmount = 0;
	{
		if ((_x select 0) == _balance) exitwith {_balanceAmount = _x select 1;};
	} foreach (missionNameSpace getVariable ["Config_Government_Balances",[]]);
	_balanceAmount;
}] call compile_Global;

["A3PL_Government_FactionPay",
{
	private _job = player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
	private _factionBalance = [player] call A3PL_Government_MyFactionBalance;
	private _charID = (player getVariable ["character_id",""]);
	private _rankName = [_job,"rank", _charID] call A3PL_Config_GetFactionRankData;
	private _payAmount = [_job,"pay", _charID] call A3PL_Config_GetFactionRankData;
	if(_factionBalance < _payAmount) then {_payAmount = 0;};
	_balance = [_job] call A3PL_Config_GetBalance;
	[_balance, -_payAmount] remoteExec ["Server_Government_AddBalance",2];
	if (_payAmount isEqualTo 0) then {
        [("STR_A3PL_Government_FactionInsufficientFunds" call A3PL_Localize),Color_Red] call A3PL_Notification;
	} else {
		[format[("STR_A3PL_Government_PaycheckReceived" call A3PL_Localize),_rankName,(_payAmount * A3PL_Event_Paycheck)],Color_Green] call A3PL_Notification;
	};
	_payAmount;
}] call compile_Global;

["A3PL_Government_Budget",
{
	disableSerialization;
	createDialog "Dialog_Budget_Manage";
	private _display = findDisplay 140;
	private _balance = [player getVariable["faction","citizen"]] call A3PL_Config_GetBalance;
	private _balanceAmount = 0;
	{
		if ((_x select 0) isEqualTo _balance) exitwith {_balanceAmount = _x select 1;};
	} foreach (missionNameSpace getVariable ["Config_Government_Balances",[]]);
	private _control = _display displayCtrl 1201;
	_control ctrlSetStructuredText parseText format ["$%1",[_balanceAmount, 1, 0, true] call CBA_fnc_formatNumber];
}] call compile_Global;

["A3PL_Government_BudgetAdd",
{
	private _display = findDisplay 140;
	private _control = _display displayCtrl 1202;
	private _value = parseNumber (ctrlText _control);
	private _hasAccount = [player,1] call A3PL_Bank_HasAccount;
	if (_value < 1) exitwith {[("STR_Common_InvalidAmount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!_hasAccount) exitwith {[("STR_Common_NoBankAccount" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_pBank = player getVariable["Player_Bank",0];
	_balance = [player getVariable["faction","citizen"]] call A3PL_Config_GetBalance;
	if(_pBank < _value) exitwith {[("STR_A3PL_Government_InsufficientFundsOnBankAccount" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	player setVariable["Player_Bank",(_pBank-_value),true];
	[_balance,_value, "", format[("STR_A3PL_Government_Transfer" call A3PL_Localize),player getVariable ["name",("STR_Common_Unknown" call A3PL_Localize)]]] remoteExec ["Server_Government_AddBalance",2];
	[format [("STR_A3PL_Government_TransferSucceded" call A3PL_Localize),Color_Red]] call A3PL_Notification;
	closeDialog 0;
}] call compile_Global;

["A3PL_Government_BudgetWithdraw",
{
	private _display = findDisplay 140;
	private _control = _display displayCtrl 1202;
	private _value = parseNumber (ctrlText _control);
	if (_value < 1) exitwith {[("STR_Common_InvalidAmount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!_hasAccount) exitwith {[("STR_Common_NoBankAccount" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_pBank = player getVariable["Player_Bank",0];
	private _balance = [player getVariable["faction","citizen"]] call A3PL_Config_GetBalance;
	private _balanceAmount = 0;
	{
		if ((_x select 0) isEqualTo _balance) exitwith {_balanceAmount = _x select 1;};
	} foreach (missionNameSpace getVariable ["Config_Government_Balances",[]]);

	if(_balanceAmount < _value) exitwith {[("STR_A3PL_Government_InsufficientFundsOnInstitutionBalance" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	player setVariable["Player_Bank",(_pBank+_value),true];
	[_balance,-_value, "", format[("STR_A3PL_Government_Withdrawal" call A3PL_Localize),player getVariable ["name",("STR_Common_Unknown" call A3PL_Localize)]]] remoteExec ["Server_Government_AddBalance",2];
	[format [("STR_A3PL_Government_WithdrawalSucceded" call A3PL_Localize),Color_Red]] call A3PL_Notification;
	closeDialog 0;
}] call compile_Global;
