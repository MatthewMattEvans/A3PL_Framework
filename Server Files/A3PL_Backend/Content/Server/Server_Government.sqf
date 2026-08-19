/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["Server_Government_FactionSetupInfo",
{
	private _leader = param [0,objNull];
	private _faction = param [1,""];
	private _players = [format ["SELECT name, charid FROM players WHERE faction='%1'",_faction], 2,true] call Server_Database_Async;
	_players sort true;
	private _allRanks = missionNameSpace getVariable ["Server_Government_FactionRanks",[]];
	private _ranks = [];
	{
		if (_x#0 isEqualTo _faction) exitwith {_ranks = _x#1;};
	} foreach _allRanks;
	[_faction,_players,_ranks] remoteExec ["A3PL_Government_FactionSetupReceive", (owner _leader)];
}] call compile_Server;

["Server_Government_SetTax",
{
    private _taxChanged = param [0,""];
    private _taxRate = param [1,0];
    private _oldRate = 0;
    private _success = false;
    {
        if ((_x select 0) isEqualTo _taxChanged) exitwith {
            _oldRate = _x select 1;
            Config_Government_Taxes set [_forEachIndex,[(_x select 0),_taxRate]];
            _success = true;
        };
    } foreach (missionNameSpace getVariable ["Config_Government_Taxes",[]]);
    if (!_success) exitwith {};
    publicVariable "Config_Government_Taxes";
    [_taxChanged,_oldRate,_taxRate] remoteExec ["A3PL_Government_NewTax", -2];
    ["Config_Government_Taxes",true] call Server_Core_SavePersistentVar;
}] call compile_Server;

["Server_Government_SetRank",
{
	private _faction = param [0,""];
	private _person = param [1,""];
	private _rank = param [2,""];
	private _ranks = [_faction,"ranks"] call A3PL_Config_GetRanks;
	private _index = _ranks#1;
	private _ranks = _ranks#0;
	{
		private _rankx = _x#0;
		private _persons = _x#1;
		if (_person IN _persons) then {
			_persons = _persons - [_person];
			_ranks set [_forEachIndex,[_x#0,_persons,_x#2]];
		};
		if (_rankx isEqualTo _rank) then {_persons pushback _person;};
	} foreach _ranks;
	Server_Government_FactionRanks set [_index,[_faction,_ranks]];
	publicVariable "Server_Government_FactionRanks";
	["Server_Government_FactionRanks",true] call Server_Core_SavePersistentVar;
}] call compile_Server;

["Server_Government_ChangeLaw",
{
    private _lawDo = param [0,0];
    private _lawIndex = param [1,0];
    private _newLaw = param [2,""];
    switch (_lawdo) do {
        case (-1):{Config_Government_Laws deleteAt _lawIndex;};
        case (0):{Config_Government_Laws set [_lawIndex,_newLaw];};
        case (1):{_lawIndex = count Config_Government_Laws;Config_Government_Laws pushback _newLaw;};
    };
    publicVariable "Config_Government_Laws";
    ["Config_Government_Laws",true] call Server_Core_SavePersistentVar;
    [_lawIndex] remoteExec ["A3PL_Government_NewLaw", -2];
}] call compile_Server;

["Server_Government_UnsetRank",
{
	private _faction = param [0,""];
	private _person = param [1,""];
	private _ranks = [_faction,"ranks"] call A3PL_Config_GetRanks;
	private _index = _ranks select 1;
	private _ranks = _ranks select 0;
	{
		private _persons = _x select 1;
		if (_person IN _persons) then {
			_persons = _persons - [_person];
			_ranks set [_forEachIndex,[(_x select 0),_persons,(_x select 2)]];
		};
	} foreach _ranks;
	Server_Government_FactionRanks set [_index,[_faction,_ranks]];
	publicVariable "Server_Government_FactionRanks";
	["Server_Government_FactionRanks",true] call Server_Core_SavePersistentVar;
}] call compile_Server;

["Server_Government_AddRank",
{
	private _faction = param [0,""];
	private _rank = param [1,""];
	private _exist = false;
	private _ranks = [_faction,"ranks"] call A3PL_Config_GetRanks;
	private _index = _ranks#1;
	private _ranks = _ranks#0;
	{
		if (_x#0 isEqualTo _rank) exitwith {_exist = true;};
	} foreach _ranks;
	if (_exist) exitwith {};
	_ranks pushback [_rank,[],0];
	Server_Government_FactionRanks set [_index,[_faction,_ranks]];
	publicVariable "Server_Government_FactionRanks";
	["Server_Government_FactionRanks",true] call Server_Core_SavePersistentVar;
}] call compile_Server;

["Server_Government_RemoveRank",
{
	private _faction = param [0,""];
	private _rank = param [1,""];
	private _ranks = [_faction,"ranks"] call A3PL_Config_GetRanks;
	private _index = _ranks select 1;
	private _ranks = _ranks select 0;
	{
		if ((_x select 0) isEqualTo _rank) exitwith {_ranks deleteAt _forEachIndex;};
	} foreach _ranks;
	Server_Government_FactionRanks set [_index,[_faction,_ranks]];
	publicVariable "Server_Government_FactionRanks";
	["Server_Government_FactionRanks",true] call Server_Core_SavePersistentVar;
}] call compile_Server;

["Server_Government_SetPay",
{
	private _faction = param [0,""];
	private _rank = param [1,""];
	private _pay = param [2,0];
	private _ranks = [_faction,"ranks"] call A3PL_Config_GetRanks;
	private _index = _ranks#1;
	private _ranks = _ranks#0;
	{
		if (_x#0 isEqualTo _rank) then {_ranks set[_forEachIndex,[_x#0,_x#1,_pay]]};
	} foreach _ranks;
	publicVariable "Server_Government_FactionRanks";
	["Server_Government_FactionRanks",true] call Server_Core_SavePersistentVar;
}] call compile_Server;

/*["Server_Government_BudgetTransfer",{
	private _budgets = [
		[("STR_Common_SheriffsDepartment" call A3PL_Localize),0.03],
		[("STR_Common_FireDepartment" call A3PL_Localize),0.03],
		["US Coast Guard",0.03],
		[("STR_Common_DepartmentOfJustice" call A3PL_Localize),0.01]
	];
	private _fedReserve = [("STR_Common_FederalReserve" call A3PL_Localize)] call A3PL_Government_FactionBalance;
	{
		private _budgetS = _x select 0;
		private _part = _x select 1;
		private _budgetM = [_budgetS] call A3PL_Government_FactionBalance;

		private _add = _fedReserve * _part;
		if((_budgetM < 3000000) || (_fedReserve < _add)) then {
			_fedReserve = _fedReserve - _add;
			[_budgetS, _add] remoteExec ["Server_Government_AddBalance",2];
			[("STR_Common_FederalReserve" call A3PL_Localize), -_add] remoteExec ["Server_Government_AddBalance",2];
		};
		if(_fedReserve isEqualTo 0) exitWith {};
	} forEach _budgets;
}] call compile_Server;*/

["Server_Government_AddBalance",
{
	private _addBalance = param [0,""];
	private _amount = param [1,0];
	private _takeBalance = param [2,""];
	private _description = param [3,""];
	{
		if ((_x select 0) isEqualTo _takeBalance) then
		{
			if ((_x select 1) < _amount) exitwith {_fail = true;};
			Config_Government_Balances set [_forEachIndex,[_x select 0,(_x select 1) - _amount]];
		};
		if (!isNil "_fail") exitwith {};
		if ((_x select 0) isEqualTo _addBalance) then {
			_newAmount = (_x select 1) + _amount;
			if (_newAmount < 0) then {_newAmount = 0;};
			Config_Government_Balances set [_forEachIndex,[_x select 0,_newAmount]];
		};
	} foreach (missionNameSpace getVariable ["Config_Government_Balances",[]]);

	publicVariable "Config_Government_Balances";
	["Config_Government_Balances",true] call Server_Core_SavePersistentVar;

	if((_addBalance IN [("STR_Common_FireDepartment" call A3PL_Localize),("STR_Common_SheriffsDepartment" call A3PL_Localize),("STR_Common_DepartmentOfJustice" call A3PL_Localize),("STR_Common_Government" call A3PL_Localize)]) && (_description != "")) then {
		private _query = format ["INSERT INTO logs_factions_budget(faction, amount, description, date_log) VALUES('%1','%2','%3', NOW())",_addBalance, _amount, _description];
		[_query,1] spawn Server_Database_Async;
	};
}] call compile_Server;