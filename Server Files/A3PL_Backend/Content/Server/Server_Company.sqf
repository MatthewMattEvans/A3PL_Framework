/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
#define COMPANYSHOPS_BUILDINGS ["Land_A3PL_Kainnon_DMV","Land_Shop_DED_Shop_01_F","Land_Shop_DED_Shop_02_F","Land_buildingGunStore1","Land_buildingsNightclub2","Land_A3PL_Cinema","Land_A3FL_Anton_Store","Land_A3PL_Garage","land_smallshop_ded_smallshop_02_f","land_smallshop_ded_smallshop_01_f","Land_A3FL_Brick_Shop_1","Land_A3FL_Brick_Shop_2","Land_A3PL_Showroom","Land_A3PL_Gas_Station","Land_A3FL_Airport_Hangar","Land_EC_CompanyStore","Land_A3FL_Anton_Store_Interior"]

["Server_Company_LoadAll", {
	private _companies = ["SELECT id, name, boss, employees, bank, licenses, ranks, IFNULL(sector,'[]') as sector FROM companies WHERE disabled = '0'", 2,true] call Server_Database_Async;
	Server_Companies = [];
	{
		private _sectors = [_x#7] call Server_Database_ToArray;
		if (isNil "_sectors") then {_sectors = [];};
		if !(_sectors isEqualType []) then {_sectors = [];};
		Server_Companies pushback [_x#0, _x#1, _x#2, [_x#3] call Server_Database_ToArray, _x#4, [_x#5] call Server_Database_ToArray, false, [_x#6] call Server_Database_ToArray, _sectors];
	} foreach _companies;
	publicVariable "Server_Companies";
}] call compile_Server;

["Server_Company_Create", {
	params [
		["_charID","",[""]],
		["_name","",[""]],
		["_desc","",[""]]
	];

	private _employees = [[_charID, 0]];
	private _employees = [_employees] call Server_Database_Array;
	private _name = [_name] call Server_Database_EsapeString;
	private _desc = [_desc] call Server_Database_EsapeString;
	private _query = format ["INSERT INTO companies(name, description, boss, employees) VALUES ('%1','%2','%3','%4')",_name, _desc, _charID, _employees];
	[_query, 1] call Server_Database_Async;
	[] spawn {
		sleep 3;
		call Server_Company_LoadAll;
	};
}] call compile_Server;

/*
	Ranks
	[RankName,charID,Pay,Hire/Fire,RankMgmt,ShopMgmt,CompanyBank,CompanyGarage,TansferTo/fromGarage]
	[["",[],0,false,false,false,false,false]]
*/
["Server_Company_SetPay", {
	params [
		["_id",-1,[-1]],
		["_player",objNull,[objNull]],
		["_pay",0,[0]],
		["_rank","",[""]]
	];

	private _ranks = [_id, "ranks"] call A3PL_Config_GetCompanyData;
	{
		if(_x#0 isEqualTo _rank) exitWith {
			_ranks set[_forEachIndex,[_x#0, _x#1, _pay, _x#3, _x#4, _x#5, _x#6, _x#7, _x#8, _x#9, _x#10]];
		};
	} foreach _ranks;
	{
		if(_x#0 isEqualTo _id) exitWith {
			Server_Companies set[_forEachIndex,[_x#0, _x#1, _x#2, _x#3, _x#4, _x#5, _x#6, _ranks]];
		};
	} foreach Server_Companies;
	publicVariable "Server_Companies";
	_ranks = [_ranks] call Server_Database_Array;
	_query = format ["UPDATE companies SET ranks = '%1' WHERE id = '%2'",_ranks, _id];
	[_query, 1] call Server_Database_Async;
	[format[("STR_Server_Company_PaycheckUpdated" call A3PL_Localize),_rank,_pay], Color_Green] remoteExec ["A3PL_Notification",_player];
}] call compile_Server;

["Server_Company_AddRank", {
	params [
		["_id",-1,[-1]],
		["_player",objNull,[objNull]],
		["_newRank","",[""]]
	];

	private _ranks = [_id, "ranks"] call A3PL_Config_GetCompanyData;
	private _normalizedRanks = [];
	{
		if(_x isEqualType []) then {
			private _rankName = if(count _x > 0) then {_x select 0} else {""};
			private _charIDs = if(count _x > 1 && (_x select 1) isEqualType []) then {_x select 1} else {[]};
			private _pay = if(count _x > 2 && (_x select 2) isEqualType 0) then {_x select 2} else {0};
			private _hire = if(count _x > 3) then {private _val = _x select 3; if(_val isEqualType "" && {_val isEqualTo "<null>"}) then {false} else {if(_val isEqualType false) then {_val} else {false}}} else {false};
			private _shop = if(count _x > 4) then {private _val = _x select 4; if(_val isEqualType "" && {_val isEqualTo "<null>"}) then {false} else {if(_val isEqualType false) then {_val} else {false}}} else {false};
			private _bank = if(count _x > 5) then {private _val = _x select 5; if(_val isEqualType "" && {_val isEqualTo "<null>"}) then {false} else {if(_val isEqualType false) then {_val} else {false}}} else {false};
			private _ranksPerm = if(count _x > 6) then {private _val = _x select 6; if(_val isEqualType "" && {_val isEqualTo "<null>"}) then {false} else {if(_val isEqualType false) then {_val} else {false}}} else {false};
			private _garage = if(count _x > 7) then {private _val = _x select 7; if(_val isEqualType "" && {_val isEqualTo "<null>"}) then {false} else {if(_val isEqualType false) then {_val} else {false}}} else {false};
			private _transfer = if(count _x > 8) then {private _val = _x select 8; if(_val isEqualType "" && {_val isEqualTo "<null>"}) then {false} else {if(_val isEqualType false) then {_val} else {false}}} else {false};
			private _twitter = if(count _x > 9) then {private _val = _x select 9; if(_val isEqualType "" && {_val isEqualTo "<null>"}) then {false} else {if(_val isEqualType false) then {_val} else {false}}} else {false};
			private _filesmanager = if(count _x > 10) then {private _val = _x select 10; if(_val isEqualType "" && {_val isEqualTo "<null>"}) then {false} else {if(_val isEqualType false) then {_val} else {false}}} else {false};
			private _stockaccess = if(count _x > 11) then {private _val = _x select 11; if(_val isEqualType "" && {_val isEqualTo "<null>"}) then {false} else {if(_val isEqualType false) then {_val} else {false}}} else {false};
			private _stockmanage = if(count _x > 12) then {private _val = _x select 12; if(_val isEqualType "" && {_val isEqualTo "<null>"}) then {false} else {if(_val isEqualType false) then {_val} else {false}}} else {false};
			_normalizedRanks pushBack [_rankName, _charIDs, _pay, _hire, _shop, _bank, _ranksPerm, _garage, _transfer, _twitter, _filesmanager, _stockaccess, _stockmanage];
		};
	} foreach _ranks;
	_ranks = _normalizedRanks;
	
	private _exist = false;
	{
		if ((_x select 0) isEqualTo _newRank) exitwith {_exist = true;};
	} foreach _ranks;
	if(_exist) exitWith {};

	_ranks pushBack [_newRank,[],0,false,false,false,false,false,false,false,false,false,false];
	{
		if(_x#0 isEqualTo _id) exitWith {
			Server_Companies set[_forEachIndex,[_x#0, _x#1, _x#2, _x#3, _x#4, _x#5, _x#6, _ranks]];
		};
	} foreach Server_Companies;
	publicVariable "Server_Companies";

	private _query = format ["UPDATE companies SET ranks = '%1' WHERE id = '%2'",[_ranks] call Server_Database_Array, _id];
	[_query, 1] call Server_Database_Async;
	[format[("STR_Server_Company_RankCreated" call A3PL_Localize),_newRank], Color_Green] remoteExec ["A3PL_Notification",_player];
}] call compile_Server;

["Server_Company_RemoveRank", {
	params [
		["_id",-1,[-1]],
		["_player",objNull,[objNull]],
		["_rank","",[""]]
	];

	private _ranks = [_id, "ranks"] call A3PL_Config_GetCompanyData;
	{
		if(_x#0 isEqualTo _rank) exitWith {_ranks deleteAt _forEachIndex;};
	} foreach _ranks;

	{
		if(_x#0 isEqualTo _id) exitWith {
			Server_Companies set[_forEachIndex,[_x#0, _x#1, _x#2, _x#3, _x#4, _x#5, _x#6, _ranks]];
		};
	} foreach Server_Companies;
	publicVariable "Server_Companies";

	private _query = format ["UPDATE companies SET ranks = '%1' WHERE id = '%2'",[_ranks] call Server_Database_Array, _id];
	[_query, 1] call Server_Database_Async;
	[format[("STR_Server_Company_RankRemoved" call A3PL_Localize),_rank], Color_Green] remoteExec ["A3PL_Notification",_player];
}] call compile_Server;

["Server_Company_SetRank", {
	params [
		["_id",-1,[-1]],
		["_player",objNull,[objNull]],
		["_rank","",[""]],
		["_person","",[""]],
		["_personname","",[""]]
	];

	private _ranks = [_id, "ranks"] call A3PL_Config_GetCompanyData;
	{
		private _rankx = _x#0;
		private _persons = _x#1;
		if (_person IN _persons) then {
			_persons = _persons - [_person];
			_ranks set [_forEachIndex,[_x#0, _persons, _x#2, _x#3, _x#4, _x#5, _x#6, _x#7, _x#8, _x#9, _x#10]];
		};
		if (_rankx isEqualTo _rank) then {_persons pushback _person;};
	} foreach _ranks;
	{
		if(_x#0 isEqualTo _id) exitWith {
			Server_Companies set[_forEachIndex,[_x#0, _x#1, _x#2, _x#3, _x#4, _x#5, _x#6, _ranks]];
		};
	} foreach Server_Companies;
	publicVariable "Server_Companies";

	private _query = format ["UPDATE companies SET ranks = '%1' WHERE id = '%2'",[_ranks] call Server_Database_Array, _id];
	[_query, 1] call Server_Database_Async;
	[format[("STR_Server_Company_RankChange" call A3PL_Localize),_personName,_rank], Color_Green] remoteExec ["A3PL_Notification",_player];
}] call compile_Server;

["Server_Company_SetPerm", {
	params [
		["_id",-1,[-1]],
		["_rank","",[""]],
		["_perm","",[""]],
		["_player",objNull,[objNull]],
		["_setPerm",false,[false]]
	];
	
	private _ranks = [_id, "ranks"] call A3PL_Config_GetCompanyData;
	private _permID = switch(_perm) do {
		case ("STR_Server_Company_TransferFromToGarage" call A3PL_Localize): {"transfer"};
		case ("STR_Server_Company_ManageRanks" call A3PL_Localize): {"ranks"};
		case ("STR_Server_Company_ManageLocal" call A3PL_Localize): {"shop"};
		case ("STR_Server_Company_HireFire" call A3PL_Localize): {"hire"};
		case ("STR_Server_Company_Garage" call A3PL_Localize): {"garage"};
		case ("STR_Server_Company_Bank" call A3PL_Localize): {"bank"};
		case ("STR_Server_Company_Twitter" call A3PL_Localize): {"twitter"};
		case ("STR_Server_Company_FilesManager" call A3PL_Localize): {"filesmanager"};
		case ("STR_Server_Company_InternalStock" call A3PL_Localize): {"stockaccess"};
		case ("STR_Server_Company_ManageInternalStock" call A3PL_Localize): {"stockmanage"};
	};
	{
		if(_x isEqualType []) then {
			private _rankName = if(count _x > 0) then {_x select 0} else {""};
			private _charIDs = if(count _x > 1 && (_x select 1) isEqualType []) then {_x select 1} else {[]};
			private _pay = if(count _x > 2 && (_x select 2) isEqualType 0) then {_x select 2} else {0};
			private _hire = false;
			private _shop = false;
			private _bank = false;
			private _ranksPerm = false;
			private _garage = false;
			private _transfer = false;
			private _twitter = false;
			private _filesmanager = false;
			private _stockaccess = false;
			private _stockmanage = false;
			
			if(count _x > 3) then {
				private _val = _x select 3;
				if(_val isEqualType "" && {_val isEqualTo "<null>"}) then {_hire = false;} else {
					if(_val isEqualType false) then {_hire = _val;} else {_hire = false;};
				};
			};
			if(count _x > 4) then {
				private _val = _x select 4;
				if(_val isEqualType "" && {_val isEqualTo "<null>"}) then {_shop = false;} else {
					if(_val isEqualType false) then {_shop = _val;} else {_shop = false;};
				};
			};
			if(count _x > 5) then {
				private _val = _x select 5;
				if(_val isEqualType "" && {_val isEqualTo "<null>"}) then {_bank = false;} else {
					if(_val isEqualType false) then {_bank = _val;} else {_bank = false;};
				};
			};
			if(count _x > 6) then {
				private _val = _x select 6;
				if(_val isEqualType "" && {_val isEqualTo "<null>"}) then {_ranksPerm = false;} else {
					if(_val isEqualType false) then {_ranksPerm = _val;} else {_ranksPerm = false;};
				};
			};
			if(count _x > 7) then {
				private _val = _x select 7;
				if(_val isEqualType "" && {_val isEqualTo "<null>"}) then {_garage = false;} else {
					if(_val isEqualType false) then {_garage = _val;} else {_garage = false;};
				};
			};
			if(count _x > 8) then {
				private _val = _x select 8;
				if(_val isEqualType "" && {_val isEqualTo "<null>"}) then {_transfer = false;} else {
					if(_val isEqualType false) then {_transfer = _val;} else {_transfer = false;};
				};
			};
			if(count _x > 9) then {
				private _val = _x select 9;
				if(_val isEqualType "" && {_val isEqualTo "<null>"}) then {_twitter = false;} else {
					if(_val isEqualType false) then {_twitter = _val;} else {_twitter = false;};
				};
			};
			if(count _x > 10) then {
				private _val = _x select 10;
				if(_val isEqualType "" && {_val isEqualTo "<null>"}) then {_filesmanager = false;} else {
					if(_val isEqualType false) then {_filesmanager = _val;} else {_filesmanager = false;};
				};
			};
			if(count _x > 11) then {
				private _val = _x select 11;
				if(_val isEqualType "" && {_val isEqualTo "<null>"}) then {_stockaccess = false;} else {
					if(_val isEqualType false) then {_stockaccess = _val;} else {_stockaccess = false;};
				};
			};
			if(count _x > 12) then {
				private _val = _x select 12;
				if(_val isEqualType "" && {_val isEqualTo "<null>"}) then {_stockmanage = false;} else {
					if(_val isEqualType false) then {_stockmanage = _val;} else {_stockmanage = false;};
				};
			};
			
			if(_rankName isEqualTo _rank) then {
				switch (_permID) do {
					case "hire": {_hire = _setPerm;};
					case "shop": {_shop = _setPerm;};
					case "bank": {_bank = _setPerm;};
					case "ranks": {_ranksPerm = _setPerm;};
					case "garage": {_garage = _setPerm;};
					case "transfer": {_transfer = _setPerm;};
					case "twitter": {_twitter = _setPerm;};
					case "filesmanager": {_filesmanager = _setPerm;};
					case "stockaccess": {_stockaccess = _setPerm;};
					case "stockmanage": {_stockmanage = _setPerm;};
				};
				_ranks set[_forEachIndex,[_rankName, _charIDs, _pay, _hire, _shop, _bank, _ranksPerm, _garage, _transfer, _twitter, _filesmanager, _stockaccess, _stockmanage]];
			};
		};
	} forEach _ranks;
	{
		if((_x#0) isEqualTo _id) exitWith {
			Server_Companies set[_forEachIndex,[_x#0, _x#1, _x#2, _x#3, _x#4, _x#5, _x#6, _ranks]];
		};
	} foreach Server_Companies;
	publicVariable "Server_Companies";

	private _query = format ["UPDATE companies SET ranks = '%1' WHERE id = '%2'",[_ranks] call Server_Database_Array, _id];
	[_query, 1] call Server_Database_Async;
	[format[("STR_Server_Company_PermissionsUpdated" call A3PL_Localize),_rank,_perm,_setPerm], Color_Green] remoteExec ["A3PL_Notification",_player];
}] call compile_Server;

["Server_Company_SetDesc", {
	params [
		["_id",-1,[-1]],
		["_desc","",[""]]
	];

	private _query = format ["UPDATE companies SET description = '%1' WHERE id = '%2'",_desc, _id];
	[_query, 1] call Server_Database_Async;
}] call compile_Server;

["Server_Company_SetBank", {
	params [
		["_id",-1,[-1]],
		["_change",-1,[-1]],
		["_extData",("STR_Server_Company_UnknownProvenence" call A3PL_Localize),[""]]
	];

	private _query = format ["SELECT bank FROM companies WHERE id = '%1'",_id];
	private _currentBank = [_query, 2] call Server_Database_Async;
	private _newBank = _currentBank#0 + _change;
	private _query = format ["UPDATE companies SET bank = '%1' WHERE id = '%2'",[_newBank, 1, 0, false] call CBA_fnc_formatNumber, _id];
	[_query, 1] call Server_Database_Async;
	{
		if(_x#0 isEqualTo _id) exitWith {
			Server_Companies set[_forEachIndex,[_x#0, _x#1, _x#2, _x#3, _newBank, _x#5, _x#6, _x#7]];
		};
	} foreach Server_Companies;
	publicVariable "Server_Companies";
	if(_extData isNotEqualTo "") then {[_id,_change,_extData] call Server_Company_AddLog;};
}] call compile_Server;

["Server_Company_SetLicenses", {
	params [
		["_id",-1,[-1]],
		["_license","",[""]],
		["_add",1,[1]]
	];

	private _query = format ["SELECT licenses FROM companies WHERE id = '%1'",_id];
	private _return = [_query, 2] call Server_Database_Async;
	private _licenses = [_return#0] call Server_Database_ToArray;
	if (_add isEqualTo 1) then {
		if (!(_license IN _licenses)) then {_licenses pushback _license;};
	} else {
		if (_license IN _licenses) then {_licenses = _licenses - [_license];};
	};
	private _query = format ["UPDATE companies SET licenses = '%1' WHERE id = '%2'",[_licenses] call Server_Database_Array, _id];
	[_query, 1] call Server_Database_Async;
	{
		if(_x#0 isEqualTo _id) exitWith {
			Server_Companies set[_forEachIndex,[_x#0, _x#1, _x#2, _x#3, _x#4, _licenses, _x#6, _x#7]];
		};
	} foreach Server_Companies;
	publicVariable "Server_Companies";
}] call compile_Server;

["Server_Company_Recruit", {
	params [
		["_id",-1,[-1]],
		["_player",objNull,[objNull]]
	];

	private _charID = (_player getVariable ["character_id",""]);
	private _query = format ["SELECT employees FROM companies WHERE id = '%1'",_id];
	private _actual = [_query, 2] call Server_Database_Async;
	private _actual = [(_actual select 0)] call Server_Database_ToArray;
	_actual pushback [_charID,0];
	private _new = [_actual] call Server_Database_Array;
	private _query = format ["UPDATE companies SET employees = '%1' WHERE id = '%2'",_actual, _id];
	[_query, 1] call Server_Database_Async;
	{
		if(_id isEqualTo (_x select 0)) exitWith {
			Server_Companies set[_forEachIndex,[_x select 0, _x select 1, _x select 2, _actual, _x select 4, _x select 5, _x select 6, _x select 7]];
		};
	} foreach Server_Companies;
	publicVariable "Server_Companies";

	_cName = [_id, "name"] call A3PL_Config_GetCompanyData;
	[format[("STR_Server_Company_YouveBeenHired" call A3PL_Localize),_cName], Color_Green] remoteExec ["A3PL_Notification",_player];
}] call compile_Server;

["Server_Company_Fire", {
	params [
		["_id",-1,[-1]],
		["_charID","",[""]],
		["_fired",true,[true]]
	];

	private _player = [_charID] call A3PL_Lib_charIDToObject;
	private _ranks = [_id, "ranks"] call A3PL_Config_GetCompanyData;
	private _query = format ["SELECT employees FROM companies WHERE id = '%1'",_id];
	private _employeesReturn = [_query, 2] call Server_Database_Async;
	private _employees = [_employeesReturn#0] call Server_Database_ToArray;

	{
		if(_x#0 isEqualTo _charID) exitWith {_employees deleteAt _forEachIndex;};
	} foreach _employees;

	{
		private _persons = _x#1;
		if (_charID IN _persons) then {
			_persons = _persons - [_charID];
			_ranks set [_forEachIndex,[_x#0, _persons, _x#2, _x#3, _x#4, _x#5, _x#6, _x#7, _x#8, _x#9, _x#10]];
		};
	} foreach _ranks;
	{
		if(_x#0 isEqualTo _id) exitWith {
			Server_Companies set[_forEachIndex,[_x#0, _x#1, _x#2, _employees, _x#4, _x#5, _x#6, _ranks]];
		};
	} foreach Server_Companies;
	publicVariable "Server_Companies";

	private _query = format ["UPDATE companies SET employees = '%1',ranks = '%2' WHERE id = '%3'",_employees, [_ranks] call Server_Database_Array, _id];
	[_query, 1] call Server_Database_Async;

	if(_fired) then {
		private _cName = [_id, "name"] call A3PL_Config_GetCompanyData;
		[format[("STR_Server_Company_YouveBeenFired" call A3PL_Localize),_cName], Color_Red] remoteExec ["A3PL_Notification",_player];
	};
}] call compile_Server;

["Server_Company_ManageSetup", {
	params [
		["_id",-1,[-1]],
		["_player",objNull,[objNull]]
	];

	private _desc = [format ["SELECT description FROM companies WHERE id='%1'",_id], 2] call Server_Database_Async;
	private _desc = _desc#0;
	private _companyEmployees = [_id, "employees"] call A3PL_Config_GetCompanyData;
	private _ranks = [_id, "ranks"] call A3PL_Config_GetCompanyData;
	private _empList = [];
	{
		private _name = ([format ["SELECT name FROM players WHERE charid='%1'",_x#0], 2] call Server_Database_Async)#0;
		_empList pushback [_name, _x#0, _x#1];
	} foreach _companyEmployees;
	[_desc,_empList,_ranks] remoteExec ["A3PL_Company_ManageReceive",(owner _player)];
}] call compile_Server;

["Server_Company_AddLog", {
	params [
		["_id",-1,[-1]],
		["_change",0,[0]],
		["_extData","",[""]]
	];

	private _query = format ["INSERT INTO logs_companies(cid, value, description, date_transaction) VALUES ('%1','%2','%3', NOW())",_id, _change, _extData];
	[_query, 1] call Server_Database_Async;
}] call compile_Server;

["Server_Company_HistorySetup", {
	params [
		["_id",-1,[-1]],
		["_player",objNull,[objNull]]
	];
	private _query = format ["SELECT value, description, date_transaction FROM logs_companies WHERE cid='%1'",_id];
	private _logs = [_query, 2, true] call Server_Database_Async;
	[_logs] remoteExec ["A3PL_Company_HistoryReceive",(owner _player)];
}] call compile_Server;

["Server_Company_BuyShop", {
	params [
		["_shop",objNull,[objNull]],
		["_player",objNull,[objNull]],
		["_cid",0,[0]]
	];

	private _buildingType = typeOf _shop;
	private _isWarehouse = !(_buildingType IN COMPANYSHOPS_BUILDINGS);
	private _cName = [_cid, "name"] call A3PL_Config_GetCompanyData;
	private _confirmWarehouse = if (_isWarehouse) then {1} else {0};

	private _query = format [
		"INSERT INTO companies_shops(cid, location, stock_buying, stock_selling, pitems, isOpen, isLocked, isWarehouse) VALUES('%1', '%2', '[]', '[]', '[]', 0, 1, %3)",
		_cid, getPos _shop, _confirmWarehouse
	];
	[_query, 1] call Server_Database_Async;

	private _message = if (_isWarehouse) then {
		("STR_Server_Company_YouBoughtWarehouse" call A3PL_Localize)
	} else {
		("STR_Server_Company_YouBoughtShop" call A3PL_Localize)
	};
	[_message, Color_Green] remoteExec ["A3PL_Notification", _player];
	
	private _signs = nearestObjects [getPos _shop, ["Land_A3PL_BusinessSign"], 25,true];
	if (count _signs > 0) then {
		_signs#0 setObjectTextureGlobal [0,"\A3PL_Objects\Street\business_sign\business_rented_co.paa"];
	};

	switch (_buildingType) do {
		case "Land_EC_Warehouse": { _shop setObjectTextureGlobal [0, "\EC_Buildings2\Data\Ads_sold.paa"]; };
		case "Land_EC_CompanyStore": { _shop setObjectTextureGlobal [0, "\EC_Buildings2\Shops\CornerStore\Data\Company_Store_Single_Sold.paa"]; };
	};

	_shop setVariable ["cid", _cid, true];
	_shop setVariable ["companyName", _cName, true];
	_shop setVariable ["stock_buying", [], true];
	_shop setVariable ["stock_selling", [], true];
	_shop setVariable ["furn_loaded", false, true];
	_shop setVariable ["position", getPos _shop, true];
	_shop setVariable ["isWarehouse", _confirmWarehouse, true];
	_shop setVariable ["isOpen", 0, true];
	_shop setVariable ["isLocked", 1, true];

	private _markerId = format ["company_%1_%2_%3", if (_isWarehouse) then {"warehouse"} else {"shop"}, _cid, _shop];
	private _defaultIcon = if (_isWarehouse) then {"A3FL_Markers_OwnedWarehouse"} else {"A3FL_Markers_CompanyShopClosed"};
	_shop setVariable ["markerID",_markerId, true];
	_shop setVariable ["markerIcon",_defaultIcon, true];
	_shop setVariable ["markerDescription","", true];

	private _shopPos = getPos _shop;
	private _isOpenNum = if (_isWarehouse) then {1} else {0};
	private _shopData = [_markerId, _shopPos, _defaultIcon, _cName, "", _isOpenNum, _isWarehouse];
	if (isNil "Server_CompanyShopMarkers") then { Server_CompanyShopMarkers = []; };
	Server_CompanyShopMarkers pushBack _shopData;
	publicVariable "Server_CompanyShopMarkers";
	[_markerId, _shopPos, _defaultIcon, _cName, "", _isOpenNum, _isWarehouse] remoteExec ["A3PL_SmartMarker_addCompanyShop", -2];

	private _doorConfig = switch (_buildingType) do {
		case "Land_A3PL_Cinema": {["Door_3_Locked", "Door_4_Locked", "Door_5_Locked", "Door_6_Locked"]};
		case "Land_buildingsNightclub2": {["Door_3_Locked"]};
		case "Land_A3PL_Kainnon_DMV": {["Door_5_Locked", "Door_6_Locked", "Door_7_Locked"]};
		case "Land_buildingGunStore1": {["Door_3_Locked", "Door_4_Locked"]};
		case "Land_A3PL_Showroom": {["Door_3_Locked", "Door_4_Locked"]};
		case "Land_EC_Warehouse": {["Door_1_Locked", "Door_2_Locked"]};
		default {[]};
	};
	{
		_shop setVariable [_x, true, true];
	} forEach _doorConfig;
	_shop setVariable ["isLocked", 1, true];
	_shop setVariable ["locked", true, true];

	private _npcPrefixes = if (_isWarehouse) then {["companycar_", "companywarehouse_", "companyfactory_"]} else {["company_"]};
	private _assignedNPCs = [];
	private _assignedNPCNames = [];

	{
		private _npcPrefix = _x;
		private _availableNPCs = allUnits select {
			private _varName = _x call BIS_fnc_objectVar;
			(_varName select [0, count _npcPrefix] == _npcPrefix)
			&& !(_x getVariable ["npc_teleported", false])
			&& !(_varName in assignedNPCsList);
		};

		if (count _availableNPCs > 0) then {
			private _companyNPC = _availableNPCs select floor random (count _availableNPCs);
			private _npcToAssign = _companyNPC call BIS_fnc_objectVar;
			_assignedNPCs pushBack _companyNPC;
			_assignedNPCNames pushBack _npcToAssign;
			assignedNPCsList pushBack [_npcToAssign];

			private _npcType = if (_npcPrefix == "companycar_") then {"vehicles"} else {"items"};
			if (_isWarehouse && _npcPrefix != "companyfactory_") then {
				private _query = format ["INSERT INTO stock(classname, type, service, items, vehicles) VALUES('%1', '%2', '%3', '[]', '[]')", _npcToAssign, _npcType, _cid];
				[_query, 1] spawn Server_Database_Async;
			};
		} else {
			["Erreur avec le spawn du NPC, rapportez ce bug!", Color_Red] remoteExec ["A3PL_Notification", _player];
		};
	} forEach _npcPrefixes;

	if (count _assignedNPCs > 0) then {
		private _query = format ["UPDATE companies_shops SET npc='%1' WHERE location='%2'", str _assignedNPCNames, getPos _shop];
		[_query, 1] spawn Server_Database_Async;
		publicVariable "assignedNPCsList";

		private _npcPositions = [
			["Land_EC_Warehouse", [[0, [-4.1, -9.5, 0]], [-90, [14, -8.5, 0]], [180, [7, -21.5, 0]]]],
			["Land_A3PL_Gas_Station", [[180, [-6.6, 1.35, -2.4]]]],
			["Land_A3PL_Cinema", [[0, [0, 3.5, -2.6]]]],
			["Land_buildingsNightclub2", [[-90, [5.7, -13.5, -6.2]]]],
			["Land_A3PL_Kainnon_DMV", [[180, [-1.5, -0.2, -2.35]]]],
			["Land_buildingGunStore1", [[180, [2.35, 5.5, -2.72]]]],
			["land_smallshop_ded_smallshop_01_f", [[85, [1.1,-3.9,-1.93]]]],
			["land_smallshop_ded_smallshop_02_f", [[85, [1.1,-3.9,-1.93]]]],
			["Land_A3FL_Anton_Store_Interior", [[85, [-3,-4.5,-0.45]]]],
			["Land_EC_CompanyStore", [[-90, [4,1,0]]]],
			["Land_A3PL_Showroom", [[85, [1,0,-3.35]]]],
			["Land_A3PL_Garage", [[-12, [1.5,-3.59,-2.5]]]],
			["Land_A3FL_Airport_Hangar", [[-90, [14.9,2,-2.68]]]],
			["Land_A3FL_Brick_Shop_1", [[83, [-0.3,0.1,-3.1]]]],
			["Land_A3FL_Brick_Shop_2", [[83, [0.5,0.1,-3.15]]]],
			["Land_Shop_DED_Shop_01_F", [[178, [0,6.7,-6.3]]]],
			["Land_Shop_DED_Shop_02_F", [[178, [0,6.7,-6.3]]]]
		];
		
		{
			private _companyNPC = _assignedNPCs select _forEachIndex;
			if (!isNull _companyNPC) then {
				private _npcPosData = [];
				{
					if (_buildingType isEqualTo (_x select 0)) then {
						_npcPosData = _x select 1;
					};
				} forEach _npcPositions;
				
				if (count _npcPosData > _forEachIndex) then {
					private _localDir = _npcPosData select _forEachIndex select 0;
					private _localPos = _npcPosData select _forEachIndex select 1;

					_companyNPC setVariable ["npc_initialPos", getPos _companyNPC, true];
					private _worldPos = _shop modelToWorld _localPos;
					_companyNPC setPos _worldPos;
					_companyNPC setDir (getDir _shop + _localDir);
					_companyNPC setVariable ["npc_teleported", true, true];

					private _npcVarName = _companyNPC call BIS_fnc_objectVar;
					if (_npcVarName select [0, 15] isEqualTo "companyfactory_") then {
						_companyNPC setVariable ["cid", _cid, true];
					};
				};
			};
		} forEach _assignedNPCs;
	};

	[_shop] call Server_Company_SpawnRepairNPC;

}] call compile_Server;

["Server_Company_SpawnRepairNPC", {
	params [
		["_shop",objNull,[objNull]]
	];
	diag_log format ["[RepairNPC] Called with shop=%1 | type=%2 | isNull=%3",_shop,typeOf _shop,isNull _shop];
	if (isNull _shop) exitWith {diag_log "[RepairNPC] EXITING: shop is null";};
	if (typeOf _shop isNotEqualTo "Land_A3PL_Garage") exitWith {diag_log format ["[RepairNPC] EXITING: type is %1, not Land_A3PL_Garage",typeOf _shop];};

	private _localPos = [0.435059,-3.18756,-2.51541];
	private _localDir = 0;
	private _worldPos = _shop modelToWorld _localPos;

	private _group = createGroup [civilian, true];
	private _npc = _group createUnit ["C_man_w_worker_F", _worldPos, [], 0, "NONE"];
	if (isNull _npc) exitWith {diag_log "[RepairNPC] EXITING: createUnit returned null";};
	diag_log format ["[RepairNPC] NPC created: %1 at pos %2",_npc,_worldPos];

	_group setGroupOwner 2;
	_npc setPos _worldPos;
	_npc setDir (getDir _shop + _localDir);

	_npc setName "Mechanic";
	_npc forceAddUniform "U_C_WorkerCoveralls";
	_npc addHeadgear "H_Cap_red";

	_npc disableAI "FSM";
	_npc disableAI "AUTOTARGET";
	_npc disableAI "TARGET";
	_npc disableAI "MOVE";
	_npc setBehaviour "CARELESS";
	_npc setCombatMode "BLUE";
	_npc allowDamage false;
	_npc switchMove "Acts_CivilListening_1";
	_npc enableSimulationGlobal false;

	_npc setVariable ["isRepairNPC", true, true];
	_npc setVariable ["parentGarage", _shop, true];
	_shop setVariable ["repairNPC", _npc, true];

	_npc
}] call compile_Server;

["Server_Company_SellShop", {
	params [
		["_shop",objNull,[objNull]],
		["_player",objNull,[objNull]]
	];

	private _cid = _shop getVariable ["cid",nil];
	if(isNil "_cid") exitWith {};
	private _query = format ["DELETE FROM companies_shops WHERE location ='%1'", getPos _shop];
	[_query,1] spawn Server_Database_Async;

	private _buildingType = typeOf _shop;
	private _isWarehouse = _buildingType isEqualTo "Land_EC_Warehouse";

	private _message = if (_isWarehouse) then {
		("STR_Server_Company_YouSoldYourWarehouse" call A3PL_Localize)
	} else {
		("STR_Server_Company_YouSoldYourShop" call A3PL_Localize)
	};
	[_message, Color_Green] remoteExec ["A3PL_Notification", _player];

	{
		_shop setVariable [_x, nil, true];
	} forEach ["id", "cid", "stock_buying", "stock_selling", "isOpen", "markerID", "companyName", "position", "isLocked", "isWarehouse", "markerIcon", "markerDescription"];

	private _doorConfig = switch (_buildingType) do {
		case "Land_A3PL_Cinema": {["Door_3_Locked", "Door_4_Locked", "Door_5_Locked", "Door_6_Locked"]};
		case "Land_buildingsNightclub2": {["Door_3_Locked"]};
		case "Land_A3PL_Kainnon_DMV": {["Door_5_Locked", "Door_6_Locked", "Door_7_Locked"]};
		case "Land_buildingGunStore1": {["Door_3_Locked", "Door_4_Locked"]};
		case "Land_A3PL_Showroom": {["Door_3_Locked", "Door_4_Locked"]};
		case "Land_EC_Warehouse": {["Door_1_Locked", "Door_2_Locked"]};
		default {[]};
	};
	{
		_shop setVariable [_x, false, true];
	} forEach _doorConfig;
	_shop setVariable ["isLocked", 0, true];
	_shop setVariable ["locked", false, true];

	private _markerId = format ["company_%1_%2_%3", if (_isWarehouse) then {"warehouse"} else {"shop"}, _cid, _shop];

	[_markerId] remoteExec ["A3PL_SmartMarker_removeCompanyShop", -2];
	Server_CompanyShopMarkers = Server_CompanyShopMarkers select {(_x#0) isNotEqualTo _markerId};
	publicVariable "Server_CompanyShopMarkers";

	private _signs = nearestObjects [_shop, ["Land_A3PL_BusinessSign"], 25,true];
	if (count _signs > 0) then {
		_signs#0 setObjectTextureGlobal [0,"\A3PL_Objects\Street\business_sign\business_sale_co.paa"];
	};
	switch (_buildingType) do {
		case "Land_EC_Warehouse": { _shop setObjectTextureGlobal [0, "\EC_Buildings2\Data\Ads_For_Sale.paa"]; };
		case "Land_EC_CompanyStore": { _shop setObjectTextureGlobal [0, "\EC_Buildings2\Shops\CornerStore\Data\Company_Store_Single_For_Sale.paa"]; };
	};

	private _npcList = allUnits select {
		private _varName = _x call BIS_fnc_objectVar;
		(
			(_varName select [0,8] == "company_") ||
			(_varName select [0,11] == "companycar_") ||
			(_varName select [0,17] == "companywarehouse_") ||
			(_varName select [0,15] == "companyfactory_")
		)
		&& { (_x distance _shop) < 20 } 
		&& { !isNil { _x getVariable "npc_initialPos" } };
	};

	if (count _npcList > 0) then {
		{
			if (!isNull _x) then {
				private _initialPos = _x getVariable ["npc_initialPos", getPos _x];
				_x setPos _initialPos;
				_x setVariable ["npc_teleported", false, true];

				private _npcVar = _x call BIS_fnc_objectVar;
				private _index = -1;

				{
					if (_npcVar in _x) then {
						_index = _forEachIndex;
					};
				} forEach assignedNPCsList;

				if (_index != -1) then {
					assignedNPCsList deleteAt _index;
				};

				publicVariable "assignedNPCsList";

				if (_isWarehouse) then {
					private _query = format ["DELETE FROM stock WHERE classname ='%1'", _npcVar];
					[_query, 1] spawn Server_Database_Async;
				};
			};
		} forEach _npcList;
	};

	private _repairNPC = _shop getVariable ["repairNPC", objNull];
	if (!isNull _repairNPC) then {
		deleteVehicle _repairNPC;
		_shop setVariable ["repairNPC", nil, true];
	};
}] call compile_Server;

/* HOW TO GET MODELTOWORLD POSITION AND DIR 
	_offset = [0,0,0];
	_direction = 0;
	_npc = company_7;

	_buildingDir = getDir cursorObject;
	_npcDir = _buildingDir + _direction;
	_npc setDir _npcDir;

	_worldPos = cursorObject modelToWorld _offset;
	_npc setPos _worldPos;
*/

["Server_Company_LoadShop", {
	Server_CompanyShopMarkers = [];

    private _assignedNPCs = ["SELECT npc FROM companies_shops WHERE npc IS NOT NULL AND npc != ''", 2, true] call Server_Database_Async;
	assignedNPCsList = _assignedNPCs apply {
		private _npcData = _x#0;
		if (typename _npcData == "STRING") then {
			_npcData = call compile _npcData;
		};
		_npcData
	};
	if (typename assignedNPCsList != "ARRAY") then { assignedNPCsList = [assignedNPCsList]; };
	publicVariable "assignedNPCsList";

    private _shops = ["SELECT companies_shops.cid, companies_shops.location, REPLACE(companies_shops.stock_buying, CHAR(96), CHAR(39)) as stock_buying, REPLACE(companies_shops.stock_selling, CHAR(96), CHAR(39)) as stock_selling, companies.name, companies_shops.isOpen, companies_shops.isLocked, companies_shops.npc, companies_shops.isWarehouse, companies.Texture_ECWarehouse, companies.Texture_ECCompanyStore, companies_shops.marker_icon, companies_shops.marker_description, companies.Texture_GasStation_0, companies.Texture_GasStation_1 FROM companies_shops, companies WHERE companies_shops.cid = companies.id", 2, true] call Server_Database_Async;
    {
        private _cid = _x#0;
        private _pos = call compile (_x#1);
        private _stock_buying = if(_x#2 isEqualType []) then {_x#2} else {[_x#2] call Server_Database_ToArray};
		private _stock_selling = if(_x#3 isEqualType []) then {_x#3} else {[_x#3] call Server_Database_ToArray};
        private _company = _x#4;
        private _isOpen = _x#5;
        private _isLocked = _x#6;
        private _npcDefined = [];
        if(_x#7 != "" && !isNil {_x#7}) then {
            _npcDefined = call compile (_x#7);
        };
		private _isWarehouse = _x#8;
		private _textureWarehouse = _x#9;
		private _textureCompanyStore = _x#10;
		private _markerIcon = if (count _x > 11 && {_x#11 != "" && !isNil {_x#11}}) then {_x#11} else {"A3FL_Markers_CompanyShopClosed"};
		private _markerDescription = if (count _x > 12 && {_x#12 != "" && !isNil {_x#12}}) then {_x#12} else {""};
		private _textureGasStation0 = if (count _x > 13 && {_x#13 != "" && !isNil {_x#13}}) then {_x#13} else {""};
		private _textureGasStation1 = if (count _x > 14 && {_x#14 != "" && !isNil {_x#14}}) then {_x#14} else {""};

        private _near = nearestObjects [_pos, COMPANYSHOPS_BUILDINGS, 10,true];
		private _nearWarehouse = nearestObjects [_pos, ["Land_EC_Warehouse"], 10,true];

		private _nearObjects = nearestObjects [_pos, COMPANYSHOPS_BUILDINGS + ["Land_EC_Warehouse"], 10, true];
        
		if ((count _nearObjects) > 0) then {
			private _shop = _nearObjects#0;
            private _buildingType = typeOf _shop;

            if (_pos isNotEqualTo (getPos _shop)) then {
                private _query = format ["UPDATE companies_shops SET location='%1' WHERE location='%2'", getPos _shop, _pos];
                [_query, 1] spawn Server_Database_Async;
            };
			
			private _signs = nearestObjects [_pos, ["Land_A3PL_BusinessSign"], 25, true];
            if (count _signs > 0) then {
                _signs#0 setObjectTextureGlobal [0,"\A3PL_Objects\Street\business_sign\business_rented_co.paa"];
            };
			if (_buildingType IN ["Land_EC_Warehouse"]) then {
				if (_textureWarehouse != "" && !isNil "_textureWarehouse") then {
					_shop setObjectTextureGlobal [0, _textureWarehouse];
				} else {
					_shop setObjectTextureGlobal [0, "\EC_Buildings2\Data\Ads_sold.paa"];
				};
			};
			if (_buildingType IN ["Land_EC_CompanyStore"]) then {
				if (_textureCompanyStore != "" && !isNil "_textureCompanyStore") then {
					_shop setObjectTextureGlobal [0, _textureCompanyStore];
				} else {
					_shop setObjectTextureGlobal [0, "\EC_Buildings2\Shops\CornerStore\Data\Company_Store_Single_Sold.paa"];
				};
			};
			if (_buildingType IN ["Land_A3PL_Gas_Station"]) then {
				if (_textureGasStation0 != "") then {
					_shop setObjectTextureGlobal [0, _textureGasStation0];
				};
				if (_textureGasStation1 != "") then {
					_shop setObjectTextureGlobal [1, _textureGasStation1];
				};
			};

			_shop setVariable ["cid",_cid, true];
			_shop setVariable ["companyName",_company, true];
			_shop setVariable ["stock_buying",_stock_buying, true];
			_shop setVariable ["stock_selling",_stock_selling, true];
			_shop setVariable ["furn_loaded", false, true];
			_shop setVariable ["position", _pos, true];
			_shop setVariable ["isWarehouse", 0, true];
			_shop setVariable ["isOpen", _isOpen, true];

			private _markerId = format ["company_%1_%2_%3", if (_isWarehouse isEqualTo 1) then {"warehouse"} else {"shop"}, _cid, _shop];
			_shop setVariable ["markerID",_markerId, true];
			_shop setVariable ["markerIcon",_markerIcon, true];
			_shop setVariable ["markerDescription",_markerDescription, true];

			if (_isWarehouse isEqualTo 1) then {
				Server_CompanyShopMarkers pushBack [_markerId, getPos _shop, _markerIcon, _company, _markerDescription, 1, true];
			} else {
				private _shopIcon = if (_isOpen isEqualTo 1) then {_markerIcon} else {"A3FL_Markers_CompanyShopClosed"};
				Server_CompanyShopMarkers pushBack [_markerId, getPos _shop, _shopIcon, _company, _markerDescription, _isOpen, false];
			};
			
            [_shop, _cid] call Server_Company_LoadItems;

			private _lockedDoors = switch (_buildingType) do {
                case "Land_A3PL_Cinema": {["Door_3_Locked", "Door_4_Locked", "Door_5_Locked", "Door_6_Locked"]};
                case "Land_buildingsNightclub2": {["Door_3_Locked"]};
                case "Land_A3PL_Kainnon_DMV": {["Door_5_Locked", "Door_6_Locked", "Door_7_Locked"]};
                case "Land_buildingGunStore1": {["Door_3_Locked", "Door_4_Locked"]};
                case "Land_A3PL_Showroom": {["Door_3_Locked", "Door_4_Locked"]};
                case "Land_EC_Warehouse": {["Door_1_Locked", "Door_2_Locked"]};
                default {[]};
            };
            {
			    _shop setVariable [_x, if(_isLocked isEqualTo 1)then{true}else{false}, true];
            } forEach _lockedDoors;
			if (_isLocked isEqualTo 1) then {
				_shop setVariable ["locked", true, true];
				_shop setVariable ["isLocked", 1, true];
			} else {
				_shop setVariable ["locked", false, true];
				_shop setVariable ["isLocked", 0, true];
			};

			if (!isNil "_npcDefined" && {count _npcDefined > 0}) then {
                private _npcPositions = [
                    ["Land_EC_Warehouse", [[0, [-4.1, -9.5, 0]], [-90, [14, -8.5, 0]], [180, [7, -21.5, 0]]]],
                    ["Land_A3PL_Gas_Station", [[180, [-6.6, 1.35, -2.4]]]],
                    ["Land_A3PL_Cinema", [[0, [0, 3.5, -2.6]]]],
                    ["Land_buildingsNightclub2", [[-90, [5.7, -13.5, -6.2]]]],
                    ["Land_A3PL_Kainnon_DMV", [[180, [-1.5, -0.2, -2.35]]]],
                    ["Land_buildingGunStore1", [[180, [2.35, 5.5, -2.72]]]],
                    ["land_smallshop_ded_smallshop_01_f", [[85, [1.1,-3.9,-1.93]]]],
                    ["land_smallshop_ded_smallshop_02_f", [[85, [1.1,-3.9,-1.93]]]],
                    ["Land_A3FL_Anton_Store_Interior", [[85, [-3,-4.5,-0.45]]]],
                    ["Land_EC_CompanyStore", [[-90, [4,1,0]]]],
                    ["Land_A3PL_Showroom", [[85, [1,0,-3.35]]]],
                    ["Land_A3PL_Garage", [[-12, [1.5,-3.59,-2.5]]]],
                    ["Land_A3FL_Airport_Hangar", [[-90, [14.9,2,-2.68]]]],
                    ["Land_A3FL_Brick_Shop_1", [[83, [-0.3,0.1,-3.1]]]],
                    ["Land_A3FL_Brick_Shop_2", [[83, [0.5,0.1,-3.15]]]],
                    ["Land_Shop_DED_Shop_01_F", [[178, [0,6.7,-6.3]]]],
                    ["Land_Shop_DED_Shop_02_F", [[178, [0,6.7,-6.3]]]]
                ];

                private _existingNPCs = allUnits select {(_x call BIS_fnc_objectVar) in _npcDefined};
                private _npcIndex = 0;

                {
                    if (_buildingType isEqualTo (_x select 0)) then {
                        private _positions = _x select 1;
                        {
                            if (_npcIndex < count _existingNPCs) then {
                                private _npc = _existingNPCs select _npcIndex;
                                private _localDir = _x select 0;
                                private _localPos = _x select 1;

                                _npc setVariable ["npc_initialPos", getPos _npc, true];
                                private _worldPos = _shop modelToWorld _localPos;
                                _npc setPos _worldPos;
                                _npc setDir (getDir _shop + _localDir);
                                _npc setVariable ["npc_teleported", true, true];
                                assignedNPCsList pushBack (_npc call BIS_fnc_objectVar);

                                private _npcVarName = _npc call BIS_fnc_objectVar;
                                if (_npcVarName select [0, 15] isEqualTo "companyfactory_") then {
                                    _npc setVariable ["cid", _cid, true];
                                };

                                _npcIndex = _npcIndex + 1;
                            };
                        } forEach _positions;
                    };
                } forEach _npcPositions;
            };

            diag_log format ["[RepairNPC] Init loop - about to call SpawnRepairNPC for shop=%1 type=%2 cid=%3",_shop,typeOf _shop,_cid];
            [_shop] call Server_Company_SpawnRepairNPC;
        };
    } foreach _shops;

	publicVariable "Server_CompanyShopMarkers";
}] call compile_Server;

["Server_Company_UpdateShopMarker", {
	params ["_player"];

	private _nearBy = nearestObjects [_player, COMPANYSHOPS_BUILDINGS, 20];
	private _cidPlayer = [(_player getVariable ["character_id",""])] call A3PL_Config_GetCompanyID;

	private _closestShop = objNull;
	private _closestDistance = 20;

	{
		private _cidShop = _x getVariable ["cid", -1];
		if (_cidShop isEqualTo _cidPlayer) then {
			private _distance = _player distance2D _x;
			if (_distance < _closestDistance) then {
				_closestShop = _x;
				_closestDistance = _distance;
			};
		};
	} forEach _nearBy;

	if (isNull _closestShop) exitWith {
		[("STR_Server_Company_NoBuildingProximity" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
	};

	private _markerID = _closestShop getVariable "markerID";
	private _cName = _closestShop getVariable "companyName";
	private _isOpen = _closestShop getVariable ["isOpen", 0];
	private _cidShop = _closestShop getVariable ["cid", -1];

	private _hasPerm = [_cidShop, "shop", (_player getVariable ["character_id",""])] call A3FL_Config_GetCompanyPermissions;
	private _isBoss = ([(_player getVariable ["character_id",""])] call A3PL_Config_IsCompanyBoss);

	if (!(_hasPerm || _isBoss)) exitWith {
		[("STR_Server_Company_CantChangeState" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
	};
	if (_cidPlayer != _cidShop) exitWith {};

	private _newState = if (_isOpen isEqualTo 1) then { 0 } else { 1 };

	private _query = format ["UPDATE companies_shops SET isOpen = %1 WHERE location = '%2'", _newState, getPos _closestShop];
	[_query, 1] call Server_Database_Async;

	_closestShop setVariable ["isOpen", _newState, true];

	// Update smart marker on all clients
	private _icon = _closestShop getVariable ["markerIcon", "A3FL_Markers_CompanyShopClosed"];
	private _description = _closestShop getVariable ["markerDescription", ""];
	private _shopIcon = if (_newState isEqualTo 1) then {_icon} else {"A3FL_Markers_CompanyShopClosed"};
	[_markerID, getPos _closestShop, _shopIcon, _cName, _description, _newState, false] remoteExec ["A3PL_SmartMarker_updateCompanyShop", -2];

	// Update broadcast array
	{
		if ((_x#0) isEqualTo _markerID) exitWith {
			Server_CompanyShopMarkers set [_forEachIndex, [_markerID, getPos _closestShop, _shopIcon, _cName, _description, _newState, false]];
		};
	} forEach Server_CompanyShopMarkers;
	publicVariable "Server_CompanyShopMarkers";

	private _message = format [("STR_Server_Company_ShopMarked" call A3PL_Localize), if (_newState isEqualTo 1) then {("STR_Server_Company_Open" call A3PL_Localize)} else {("STR_Server_Company_Close" call A3PL_Localize)}];
	[_message, Color_Green] remoteExec ["A3PL_Notification", _player];
}] call compile_Server;

["Server_Company_UpdateShopMarkerConfig", {
	params [
		["_player",objNull,[objNull]],
		["_newIcon","A3FL_Markers_CompanyShopClosed",[""]],
		["_newDescription","",[""]
	]];

	if (isNil "_newDescription" || {typeName _newDescription != "STRING"}) then { _newDescription = ""; };
	if (isNil "_newIcon" || {typeName _newIcon != "STRING"}) then { _newIcon = "A3FL_Markers_CompanyShopClosed"; };

	private _nearBy = nearestObjects [_player, COMPANYSHOPS_BUILDINGS + ["Land_EC_Warehouse"], 20];
	private _cidPlayer = [(_player getVariable ["character_id",""])] call A3PL_Config_GetCompanyID;

	private _closestShop = objNull;
	private _closestDistance = 20;

	{
		private _cidShop = _x getVariable ["cid", -1];
		if (_cidShop isEqualTo _cidPlayer) then {
			private _distance = _player distance2D _x;
			if (_distance < _closestDistance) then {
				_closestShop = _x;
				_closestDistance = _distance;
			};
		};
	} forEach _nearBy;

	if (isNull _closestShop) exitWith {
		[("STR_Server_Company_NoBuildingProximity" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
	};

	private _isBoss = ([(_player getVariable ["character_id",""])] call A3PL_Config_IsCompanyBoss);
	if (!_isBoss) exitWith {
		[("STR_Server_Company_OnlyBoss" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
	};

	private _markerID = _closestShop getVariable "markerID";
	private _cName = _closestShop getVariable "companyName";
	private _isOpen = _closestShop getVariable ["isOpen", 0];
	private _buildingType = typeOf _closestShop;
	private _isWarehouse = (_buildingType isEqualTo "Land_EC_Warehouse");

	// Sanitize user input
	_newDescription = _newDescription select [0, 255];
	_newDescription = (_newDescription splitString "'" ) joinString "";

	// Save to DB
	private _query = format ["UPDATE companies_shops SET marker_icon = '%1', marker_description = '%2' WHERE location = '%3'", _newIcon, _newDescription, getPos _closestShop];
	[_query, 1] call Server_Database_Async;

	// Update shop variables
	_closestShop setVariable ["markerIcon", _newIcon, true];
	_closestShop setVariable ["markerDescription", _newDescription, true];

	// Update smart marker on all clients
	private _shopIcon = if (_isWarehouse) then {_newIcon} else {if (_isOpen isEqualTo 1) then {_newIcon} else {"A3FL_Markers_CompanyShopClosed"}};
	[_markerID, getPos _closestShop, _shopIcon, _cName, _newDescription, _isOpen, _isWarehouse] remoteExec ["A3PL_SmartMarker_updateCompanyShop", -2];

	// Update broadcast array
	{
		if ((_x#0) isEqualTo _markerID) exitWith {
			Server_CompanyShopMarkers set [_forEachIndex, [_markerID, getPos _closestShop, _shopIcon, _cName, _newDescription, _isOpen, _isWarehouse]];
		};
	} forEach Server_CompanyShopMarkers;
	publicVariable "Server_CompanyShopMarkers";

	[("STR_Server_Company_MarkerConfigUpdated" call A3PL_Localize), Color_Green] remoteExec ["A3PL_Notification", _player];
}] call compile_Server;

["Server_Company_UpdateShopLocked", {
	params ["_player", "_shop"];

	private _cidPlayer = [(_player getVariable ["character_id",""])] call A3PL_Config_GetCompanyID;
	private _cidShop = _shop getVariable ["cid", -1];
	private _isLocked = _shop getVariable ["isLocked", 1];

	private _hasPerm = [_cidShop, "shop", (_player getVariable ["character_id",""])] call A3FL_Config_GetCompanyPermissions;
	private _isBoss = [(_player getVariable ["character_id",""])] call A3PL_Config_IsCompanyBoss;
	if (!(_hasPerm || _isBoss)) exitWith {
		[("STR_Server_Company_CantOpenCloseDoor" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];
	};

	if (_cidPlayer != _cidShop) exitWith {};

	private _buildingType = typeOf _shop;
	private _doorsToLock = [];
	private _isWarehouse = (_buildingType isEqualTo "Land_EC_Warehouse");

	switch (_buildingType) do {
		case "Land_A3PL_Cinema": { _doorsToLock = ["Door_3_Locked", "Door_4_Locked", "Door_5_Locked", "Door_6_Locked"]; };
		case "Land_buildingsNightclub2": { _doorsToLock = ["Door_3_Locked"]; };
		case "Land_A3PL_Kainnon_DMV": { _doorsToLock = ["Door_5_Locked", "Door_6_Locked", "Door_7_Locked"]; };
		case "Land_buildingGunStore1": { _doorsToLock = ["Door_3_Locked", "Door_4_Locked"]; };
		case "Land_A3PL_Showroom": { _doorsToLock = ["Door_3_Locked", "Door_4_Locked"]; };
		case "Land_EC_Warehouse": { _doorsToLock = ["Door_1_Locked", "Door_2_Locked"]; };
		default { _doorsToLock = []; };
	};

	private _newLockState = if (_isLocked isEqualTo 0) then { 1 } else { 0 };
	private _newLockStateBool = if (_isLocked isEqualTo 0) then { true } else { false };

	if (_newLockState isEqualTo 1) then {
		_shop setVariable ["locked", true, true];
		_shop setVariable ["isLocked", 1, true];
	} else {
		_shop setVariable ["locked", false, true];
		_shop setVariable ["isLocked", 0, true];
	};

	{
		_shop setVariable [_x, _newLockStateBool, true];
	} forEach _doorsToLock;

	private _query = format ["UPDATE companies_shops SET isLocked = %1 WHERE location = '%2'", _newLockState, getPos _shop];
	[_query, 1] spawn Server_Database_Async;

	private _message = if (_newLockState isEqualTo 1) then {
		if (_isWarehouse) then { ("STR_Server_Company_YouCloseYourWarehouse" call A3PL_Localize) } else { ("STR_Server_Company_YouCloseYourShop" call A3PL_Localize) }
	} else {
		if (_isWarehouse) then { ("STR_Server_Company_YouOpenedYourWarehouse" call A3PL_Localize) } else { ("STR_Server_Company_YouOpenedYourShop" call A3PL_Localize) }
	};
	[_message, Color_Green] remoteExec ["A3PL_Notification", _player];
}] call compile_Server;

["Server_Company_SaveItems",
{
	private _companyBuilding = param [0,objNull];
	private _cid = param [1, 0];
	private _delete = param [2,false];
	private _furnLimit = 15;
	private _items = nearestObjects [_companyBuilding, [],30];

	private _itemsToSave = [];
	{
		if (!isNil {_x getVariable "class"}) then {
			if (typeOf _x IN ["A3PL_WheelieBin"]) exitWith {};
			if (count(_itemsToSave) < _furnLimit && ((nearestObjects[_x, ["Land_A3PL_Kainnon_DMV","Land_Shop_DED_Shop_01_F","Land_Shop_DED_Shop_02_F","Land_buildingGunStore1","Land_buildingsNightclub2","Land_A3PL_Cinema","Land_A3FL_Anton_Store","Land_A3PL_Garage","land_smallshop_ded_smallshop_02_f","land_smallshop_ded_smallshop_01_f","Land_A3FL_Brick_Shop_1","Land_A3FL_Brick_Shop_2","Land_A3PL_Showroom","Land_A3PL_Gas_Station","Land_A3FL_Airport_Hangar","Land_EC_CompanyStore","Land_EC_Warehouse"], 30])#0 isEqualTo _companyBuilding)) then {
				_itemsToSave pushback _x;
			};
		};
	} foreach _items;
	diag_log format[" items to save %1", _itemsToSave];
	private _pItems = [];
	{
		_pItems pushback [(typeOf _x),(_x getVariable "class"),getPosASL _x,getDir _x];
		if (_delete) then {deleteVehicle _x;};
	} foreach _itemsToSave;
	diag_log format[" pItems on save %1", _pItems];
	private _myItems = str(_pItems);
	private _query = format ["UPDATE companies_shops SET pitems='%1' WHERE location = '%2'", _myItems, getPos _companyBuilding];
	[_query,1] spawn Server_Database_Async;
}] call compile_Server;

["Server_Company_LoadItems",
{
	private _companyBuilding = param [0,objNull];
	private _cid = param [1, 0];

	if (_companyBuilding getVariable ["furn_loaded",false]) exitwith {};
	_companyBuilding setVariable ["furn_loaded",true,true];

	private _query = format ["SELECT pitems FROM companies_shops WHERE location = '%1'",(getpos _companyBuilding)];
	private _pItems = [_query, 2] call Server_Database_Async;

	private _employeecharIDS = [_cid, "employees"] call A3PL_Config_GetCompanyData;
	private _charIDFormated = [];
	{
		_charIDFormated pushback _x#0;
	} forEach _employeecharIDS;

	private _objects = [];
	{
		private _classname = _x#0;
		private _class = _x#1;
		private _pos = _x#2;
		private _dir = _x#3;
		private _obj = createVehicle [_classname, _pos, [], 0, "CAN_COLLIDE"];
		if (!([_class,"simulation"] call A3PL_Config_GetItem)) then {[_obj] call Server_Housing_LoadItemsSimulation;};
		_obj setDir _dir;
		_obj setPosASL _pos;
		_obj setVariable ["owner",_charIDFormated,true];
		_obj setVariable ["class",_class,true];
	} foreach _pItems#0;
}] call compile_Server;

["Server_Company_Save",{
	private _shops = ["SELECT cid, location FROM companies_shops", 2, true] call Server_Database_Async;
	{
		private _cid = _x#0;
		private _pos = call compile (_x#1);

		private _near = nearestObjects [_pos, ["Land_EC_Warehouse","Land_A3PL_Kainnon_DMV","Land_Shop_DED_Shop_01_F","Land_Shop_DED_Shop_02_F","Land_buildingGunStore1","Land_buildingsNightclub2","Land_A3PL_Cinema","Land_A3FL_Anton_Store","Land_A3PL_Garage","land_smallshop_ded_smallshop_02_f","land_smallshop_ded_smallshop_01_f","Land_A3FL_Brick_Shop_1","Land_A3FL_Brick_Shop_2","Land_A3PL_Showroom","Land_A3PL_Gas_Station","Land_A3FL_Airport_Hangar","Land_EC_CompanyStore"], 10,true];
		if ((count _near) > 0) then {
			private _shop = _near#0;
	    	if (_pos isNotEqualTo (getPos _shop)) then {
				_query = format ["UPDATE companies_shops SET location='%1' WHERE location ='%2'", getPos _shop, _pos];
				[_query,1] spawn Server_Database_Async;
			};
			[_shop, _cid, true] call Server_Company_SaveItems;
		} else {
			diag_log format["Lost Shop: %1", _pos];
		};
	} foreach _shops;
	publicVariable "Server_StartMarkers";
}]call compile_Server;

/* COMPANY BILLS */

["Server_Company_LoadcBillPhone",{
	private _player = param [0,objNull];
	private _cid = [(_player getVariable ["character_id",""])] call A3PL_Config_GetCompanyID;
	private _query = format ["SELECT companies_bills.cid, companies_bills.amount, companies_bills.description, players.name, companies_bills.active FROM companies_bills, players WHERE players.charid = companies_bills.recipient_id AND companies_bills.cid = '%1'",_cid];
	private _result = [_query, 2, true] call Server_Database_Async;
	_player setVariable ["A3PL_Phone_BillsList_Result", _result, true];
}] call compile_Server;

["Server_Company_SendBill",{
	private _cid = param [0,-1];
	private _amount = param [1,0];
	private _desc = param [2,("STR_Server_Company_NoDescription" call A3PL_Localize)];
	private _target = param [3,objNull];
	private _targetcharID = (_target getVariable ["character_id",""]);
	private _active = 0;
	private _query = format ["INSERT INTO companies_bills(cid, recipient_id, description, amount, active, date_bill) VALUES ('%1','%2','%3','%4','%5', NOW())",_cid, _targetcharID, _desc, _amount,_active];
	[_query, 1] call Server_Database_Async;
	[_amount] remoteExec ["A3PL_Company_ReceiveBill",_target];
	[_target] remoteExec ["Server_Company_LoadBills",2];
}] call compile_Server;

["Server_Company_LoadBillData",{
	private _id = param [0,-1];
	private _target = param [1,objNull];
	private _query = format ["SELECT description, amount, cid FROM companies_bills WHERE id='%1'",_id];
	private _billData = [_query, 2] call Server_Database_Async;
	private _query = format ["SELECT name FROM companies WHERE id='%1'",_billData select 2];
	private _companyName = [_query, 2] call Server_Database_Async;
	private _companyName = _companyName select 0;
	[_id, _billData select 1, _billData select 0, _companyName] remoteExec ["A3PL_Company_BillDataReceive",_target];
}] call compile_Server;

["Server_Company_LoadBills",{
	private _target = param [0,objNull];
	private _query = format ["SELECT * FROM companies_bills WHERE recipient_id='%1' AND active = '0'",(_target getVariable ["character_id",""])];
	private _bills = [_query, 2, true] call Server_Database_Async;
	_target setVariable["player_bills", _bills,true];
}] call compile_Server;

["Server_Company_PayBill",{
	private _id = param [0,-1];
	private _amount = param [1,0];
	private _player = param [2,objNull];
	private _query = format ["UPDATE companies_bills SET active = '1' WHERE id = '%1'", _id];
	[_query, 1] call Server_Database_Async;

	private _query = format ["SELECT cid FROM companies_bills WHERE id='%1'",_id];
	private _companyID = ([_query, 2] call Server_Database_Async) select 0;
	[_companyID, _amount, format["Facture %1",name _player]] remoteExec ["Server_Company_SetBank",2];

	sleep 2;
	[_player] remoteExec ["Server_Company_LoadBills",2];
}] call compile_Server;