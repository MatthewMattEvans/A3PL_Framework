/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["Server_Police_Impound",
{
	private _veh = param [0,objNull];
	if (isNull _veh) exitwith {};
	private _var = _veh getVariable ["owner",nil];
	private _durationMinutes = _veh getVariable ["impound_duration",0];
	if (!isNil "_var") then {
		private _id = _var select 1;
		private _query = format ["UPDATE players_objects SET plystorage = '1',impounded='1',fuel='%2',spawn='0',pos='[]',dir='[]',impound_timestamp=UNIX_TIMESTAMP(),impound_duration='%3' WHERE id = '%1'",_id,(fuel _veh),_durationMinutes];
		[_query,1] spawn Server_Database_Async;
	};
	[_veh] call Server_Vehicle_Despawn;
	if (!isNil "_id") then {
		private _player = [(_var select 0)] call A3PL_Lib_charIDToObject;
		if (!isNull _player) then {[("STR_Server_Police_Impound_NeedToPay" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification",(owner _player)];};
	};
}] call compile_Server;

['Server_Police_Database',
{
	private _player = _this select 0;
	private _name = _this select 1;
	private _call = _this select 2;
	switch (_call) do {
		case "lookup": {
			private _query = format ["SELECT
			(SELECT gender FROM players WHERE name = '%1') AS gender,
			(SELECT dob FROM players WHERE name = '%1') AS DOB,
			(SELECT COUNT(Actiontype) FROM policedatabase WHERE Actiontype='warrant' AND charid = (SELECT charid FROM players WHERE name='%1')) AS warrantAmount,
			(SELECT COUNT(Actiontype) FROM policedatabase WHERE Actiontype='arrest' AND charid = (SELECT charid FROM players WHERE name='%1')) AS arrestAmount,
			(SELECT COUNT(Actiontype) FROM policedatabase WHERE Actiontype='ticket' AND charid = (SELECT charid FROM players WHERE name='%1')) AS ticketAmount,
			(SELECT COUNT(Actiontype) FROM policedatabase WHERE Actiontype='warning' AND charid = (SELECT charid FROM players WHERE name='%1')) AS warningAmount,
			(SELECT COUNT(Actiontype) FROM policedatabase WHERE Actiontype='report' AND charid = (SELECT charid FROM players WHERE name='%1')) AS reportAmount,
			(SELECT DATE_FORMAT(pasportDate, '%2m/%2d/%2Y') FROM players WHERE name = '%1') AS pasportDate,
			(SELECT bank FROM players WHERE name = '%1') AS bank,
			(SELECT info FROM policedatabase WHERE ActionType='caution' AND charid = (SELECT charid FROM players WHERE name='%1')) AS cautionRes,
			(SELECT faction FROM players WHERE name = '%1') AS faction
			FROM players
			WHERE charid = (SELECT charid FROM players WHERE name='%1')
			LIMIT 1", _name, '%'];

			private _return = [_query, 2] call Server_Database_Async;
			if(count(_return) > 0) then {
				private _charid = ([format ["SELECT charid FROM players WHERE name='%1'", _name], 2] call Server_Database_Async)#0;
				private _query = format ["SELECT name FROM companies WHERE employees LIKE '%2%1%2'", _charid, "%"];
				private _company = [_query, 2] call Server_Database_Async;
				if(count(_company) isEqualTo 0) then {
					_return pushBack "none";
				} else {
					_return pushBack(_company select 0);
				};
				_query = format ["SELECT code, DATE_FORMAT(issuedate, '%2m/%2d/%2Y'), lastrenew, issuedBy FROM licenses WHERE charid = '%3'", _name, '%', _charid];
				private _licenses = [_query, 2, true] call Server_Database_Async;
				_return pushBack _licenses;
			};
			[_name,_call,_return] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
		};

		case "lookupvehicles": {
			private _query = format ["SELECT id,class,stolen,insurance FROM players_objects WHERE (charid = (SELECT charid FROM players WHERE name='%1')) AND NOT type='object' AND cid = '0'",_name];
			private _return = [_query, 2,true] call Server_Database_Async;
			[_name,_call,_return] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
		};

		case "lookupcvehicles": {
			private _query = format ["SELECT id,class,stolen,insurance FROM players_objects WHERE (cid = (SELECT id FROM companies WHERE name='%1'))",_name];
			private _return = [_query, 2,true] call Server_Database_Async;
			[_name,_call,_return] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
		};

		case "lookuplicense": {
			private _query = format ["SELECT name, (SELECT stolen FROM players_objects WHERE id='%1') AS stolen, (SELECT class FROM players_objects WHERE id = '%1') AS class, (SELECT insurance FROM players_objects WHERE id = '%1') AS insured, (SELECT cid FROM players_objects WHERE id='%1') AS cid, (SELECT charid FROM players_objects WHERE id = '%1') AS pid FROM players WHERE charid = (SELECT charid FROM players_objects WHERE id='%1')",_name];
			private _return = [_query, 2] call Server_Database_Async;

			if(count (_return) == 0) then {
				{
					if((_x select 0) isEqualTo _name) exitWith {
						_return = _x select 1;
					};
				} forEach Server_Dealership_Vehicles;
			};

			if(count (_return) > 0) then {
				_return pushBack _name;
				private _licenseType = "driver";
				private _licenseWarning = "<br/>";
				if((_return select 2) IN ["A3PL_P362","A3PL_P362_TowTruck","A3FL_T370"]) then {_licenseType = "cdl";};
				if((_return select 2) IN ["A3PL_Kx","A3PL_Fatboy","A3PL_Knucklehead","A3PL_1100R"]) then {_licenseType = "motorcycle";};
				private _query = format ["SELECT id FROM licenses WHERE charid = (SELECT charid FROM players WHERE charid = '%1') AND CODE LIKE '%2'",(_return select 5),_licenseType];
				private _lreturn = [_query, 2] call Server_Database_Async;
				if((count (_lreturn)) isEqualTo 0) then {
					_licenseWarning = format[("STR_Server_Police_Database_NoOne" call A3PL_Localize),[_licenseType,0] call A3PL_Config_GetLicenseData];
				};
				private _query = format["SELECT info FROM policedatabase WHERE ActionType='caution' AND charid = '%1'",(_return select 5)];
				private _cquery = [_query, 2] call Server_Database_Async;
				if((count _cquery) > 0) then {
					_licenseWarning = format[("STR_Server_Police_Database_Warning" call A3PL_Localize),_licenseWarning,_cquery select 0];
				};
				_return pushBack _licenseWarning;

				if(!((_return select 4) isEqualTo 0)) then {
					private _query = format ["SELECT name FROM companies WHERE id = '%1'",(_return select 4)];
					private _creturn = [_query, 2] call Server_Database_Async;
					_return pushBack (_creturn select 0);
				};
				[_name,_call,_return] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
			} else {
				[_name,_call,[_name]] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
			};
		};

		case "lookupcompany": {
			private _query = format ["SELECT name, description, (SELECT name FROM players WHERE charid=(SELECT boss FROM companies WHERE name='%1')) AS boss, bank, licenses FROM companies WHERE name = '%1'",_name];
			private _return = [_query, 2] call Server_Database_Async;
			_return set[4, [_return#4] call Server_Database_ToArray];
			[_name,_call,_return] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
		};

		case "lookupcompvehicles": {
			private _return = [];
			[_name,_call,_return] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
		};

		case "lookupaddress": {
			private _querycharID = format["SELECT charid FROM players WHERE name='%1'",_name];
			private _charID = ([_querycharID, 2] call Server_Database_Async) select 0;
			private _query = format ["SELECT location FROM houses WHERE charids LIKE '%1%2%1'","%",_charID];
			private _return = [([_query, 2] call Server_Database_Async) select 0];
			_return pushBack _name;
			[_name,_call,_return] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
		};

		case "lookupwarehouse": {
			private _querycharID = format["SELECT charid FROM players WHERE name='%1'",_name];
			private _charID = ([_querycharID, 2] call Server_Database_Async) select 0;
			private _query = format ["SELECT location FROM warehouses WHERE charids LIKE '%1%2%1'","%",_charID];
			private _return = [([_query, 2] call Server_Database_Async) select 0];
			_return pushBack _name;
			[_name,_call,_return] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
		};

		case "markstolen": {
			private _query = format ["SELECT id,stolen FROM players_objects WHERE id = '%1'",_name];
			private _return = [_query, 2] call Server_Database_Async;
			if(_return select 1 != 0) exitWith {
				private _output = format[("STR_Server_Police_Database_MarkedStolen" call A3PL_Localize),_name];
				[_name,_call,_output] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
			};

			if(count _return > 0) exitWith {
				private _id = _return select 0;
				private _query = format ["UPDATE players_objects set stolen='1' WHERE ID='%1'",_id];
				[_query, 1] call Server_Database_Async;
				private _output = format[("STR_Server_Police_Database_YouMarkedStoken" call A3PL_Localize),_name];
				[_name,_call,_output] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
			};
			private _output = ("STR_Server_Police_Database_PlateDoesNotExist" call A3PL_Localize);
			[_name,_call,_output] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
		};

		case "markfound": {
			private _query = format ["SELECT id,stolen FROM players_objects WHERE id = '%1'",_name];
			private _return = [_query, 2] call Server_Database_Async;
			if(_return select 1 != 1) exitWith {
				private _output = format[("STR_Server_Police_Database_NotStolen" call A3PL_Localize),_name];
				[_name,_call,_output] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
			};
			if(count _return > 0) exitWith {
				private _id = _return select 0;
				private _query = format ["UPDATE players_objects set stolen='0' WHERE ID='%1'",_id];
				[_query, 1] call Server_Database_Async;
				private _output = format[("STR_Server_Police_Database_MarkedFinded" call A3PL_Localize),_name];
				[_name,_call,_output] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
			};
			private _output = ("STR_Server_Police_Database_PlateDoesNotExist" call A3PL_Localize);
			[_name,_call,_output] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
		};

		case "warrantlist": {
			private _query = format ["SELECT title,time,issuedby FROM policedatabase WHERE (charid = (SELECT charid FROM players WHERE name='%1')) AND (actiontype='warrant')",_name];
			private _return = [_query, 2, true] call Server_Database_Async;
			[_name,_call,_return] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
		};

		case "warrantinfo": {
			private _query = format ["SELECT time,issuedby,info FROM policedatabase WHERE charid = (SELECT charid FROM players WHERE name = '%1') AND actiontype='warrant' LIMIT 1 OFFSET %2",_name,(_this select 3)];
			private _return = [_query, 2] call Server_Database_Async;
			[_name,_call,_return] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
		};

		case "removewarrant": {
			private _query = format ["SELECT ID FROM policedatabase WHERE charid = (SELECT charid FROM players WHERE name = '%1') AND actiontype='warrant' LIMIT 1 OFFSET %2",_name,(_this select 3)];
			private _return = [_query, 2] call Server_Database_Async;
			if(count _return > 0) exitWith {
				private _id = _return select 0;
				private _query = format ["CALL DeleteWarrants(%1)",_id];
				[_query, 1] call Server_Database_Async;
				private _output = format[("STR_Server_Police_Database_WarrantRemoved" call A3PL_Localize),_name];
				[_name,_call,_output] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
			};
			private _output = ("STR_Server_Police_Database_InvalidID" call A3PL_Localize);
			[_name,_call,_output] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
		};

		case "ticketlist": {
			private _query = format ["SELECT time,info,issuedby,amount FROM policedatabase WHERE (charid = (SELECT charid FROM players WHERE name='%1')) AND (actiontype='ticket')",_name];
			private _return = [_query, 2,true] call Server_Database_Async;
			[_name,_call,_return] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
		};

		case "arrestlist": {
			private _query = format ["SELECT time,info,issuedby,amount FROM policedatabase WHERE (charid = (SELECT charid FROM players WHERE name='%1')) AND (actiontype='arrest')",_name];
			private _return = [_query, 2,true] call Server_Database_Async;
			[_name,_call,_return] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
		};
		case "removearrest": {
			_time = _name#1;
			_name = _name#0;
			private _query = format ["SELECT id FROM policedatabase WHERE (charid = (SELECT charid FROM players WHERE name='%1')) AND (actiontype='arrest') AND time = '%2'",_name,_time];
			private _return = [_query, 2] call Server_Database_Async;
			if(count(_return) isEqualTo 0) exitWith {[_name,_call,("STR_Server_Police_Database_ArrestNotFound" call A3PL_Localize)] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];};
			[format ["DELETE FROM policedatabase WHERE (charid = (SELECT charid FROM players WHERE name='%1')) AND (actiontype='arrest') AND time = '%2'",_name,_time], 1] call Server_Database_Async;
			[_name,_call,("STR_Server_Police_Database_ArrestRemovedFromFiles" call A3PL_Localize)] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
		};

		case "warninglist": {
			private _query = format ["SELECT time,info,issuedby FROM policedatabase WHERE (charid = (SELECT charid FROM players WHERE name='%1')) AND (actiontype='warning')",_name];
			private _return = [_query, 2,true] call Server_Database_Async;
			[_name,_call,_return] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
		};

		case "insertwarrant": {
			private _title = _name select 1;
			private _info = _name select 2;
			private _issuedBy = _name select 3;
			private _name = _name select 0;
			private _query = format ["SELECT charid FROM players WHERE name='%1'",_name];
			private _return = [_query, 2, true] call Server_Database_Async;
			if(count _return < 1) then {
				[_name,_call,("STR_Server_Police_Database_InvalidCitizenName" call A3PL_Localize)] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
			} else {
				private _charid = (_return select 0) select 0;
				private _query = format ["INSERT INTO policedatabase (charid, ActionType, Info, Title, IssuedBy, Time) VALUES ('%1', 'warrant', '%2', '%3', '%4', NOW())",_charid,_info,_title,_issuedBy];
				[_query,1] call Server_Database_Async;
				[_name,_call,format[("STR_Server_Police_Database_YouInsered" call A3PL_Localize),_name]] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
			};
		};

		case "insertticket": {
			private _amount = _name select 1;
			private _info = _name select 2;
			private _issuedBy = _name select 3;
			private _name = _name select 0;
			private _query = format ["SELECT charid FROM players WHERE name='%1'",_name];
			private _return = [_query, 2, true] call Server_Database_Async;
			if(count _return < 1) then {
				[_name,_call,("STR_Server_Police_Database_InvalidCitizenName" call A3PL_Localize)] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
			} else {
				private _charid = (_return select 0) select 0;
				private _query = format ["INSERT INTO policedatabase (charid, ActionType, Info, Amount, IssuedBy, Time) VALUES ('%1', 'ticket', '%2', '%3', '%4', NOW())",_charid,_info,_amount,_issuedBy];
				[_query, 1] call Server_Database_Async;
				[_name,_call,format[("STR_Server_Police_Database_InsertTicket" call A3PL_Localize),_name]] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
			};
		};

		case "insertwarning": {
			private _title = _name select 1;
			private _info = _name select 2;
			private _issuedBy = _name select 3;
			private _name = _name select 0;
			private _query = format ["SELECT charid FROM players WHERE name='%1'",_name];
			private _return = [_query, 2, true] call Server_Database_Async;
			if(count _return < 1) then {
				[_name,_call,("STR_Server_Police_Database_InvalidCitizenName" call A3PL_Localize)] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
			} else {
				private _charid = (_return select 0) select 0;
				private _query = format ["INSERT INTO policedatabase (charid, ActionType, Info, Title, IssuedBy, Time) VALUES ('%1', 'warning', '%2', '%3', '%4', NOW())",_charid,_info,_title,_issuedBy,_name];
				[_query,1] call Server_Database_Async;
				[_name,_call,format[("STR_Server_Police_Database_InsertWarning" call A3PL_Localize),_name]] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
			};
		};

		case "insertreport": {
			private _title = _name select 1;
			private _info = _name select 2;
			private _issuedBy = _name select 3;
			private _name = _name select 0;
			private _query = format ["SELECT charid FROM players WHERE name='%1'",_name];
			private _return = [_query, 2, true] call Server_Database_Async;
			if(count _return < 1) then {
				[_name,_call,("STR_Server_Police_Database_InvalidCitizenName" call A3PL_Localize)] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
			} else {
				private _charid = (_return select 0) select 0;
				private _query = format ["INSERT INTO policedatabase (charid, ActionType, Info, Title, IssuedBy, Time) VALUES ('%1', 'report', '%2', '%3', '%4', NOW())",_charid,_info,_title,_issuedBy,_name];
				[_query, 1] call Server_Database_Async;
				[_name,_call,format[("STR_Server_Police_Database_InsertReport" call A3PL_Localize),_name]] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
			};
		};

		case "insertarrest": {
			private _time = _name select 1;
			private _info = _name select 2;
			private _issuedBy = _name select 3;
			private _name = _name select 0;
			private _query = format ["SELECT charid FROM players WHERE name='%1'",_name];
			private _return = [_query, 2, true] call Server_Database_Async;
			if(count _return < 1) then {
				[_name,_call,("STR_Server_Police_Database_InvalidCitizenName" call A3PL_Localize)] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
			} else {
				private _charid = (_return select 0) select 0;
				private _query = format ["INSERT INTO policedatabase (charid, ActionType, Info, Amount, IssuedBy, Time) VALUES ('%1', 'arrest', '%2', '%3', '%4', NOW())",_charid,_info,_time,_issuedBy,_name];
				[_query, 1] call Server_Database_Async;
				[_name,_call,format[("STR_Server_Police_Database_InsertArrest" call A3PL_Localize),_name]] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
			};
		};

		case "revokelicense": {
			private _pname = _name select 0;
			private _license = _name select 1;
			private _query = format ["SELECT charid FROM players WHERE name='%1'",_pname];
			private _return = [_query, 2] call Server_Database_Async;
			if((count _return) isNotEqualTo 1) then {
				[_pname,_call,format[("STR_Server_Police_Database_CantFind" call A3PL_Localize),_pname]] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
			} else {
				private _charID = _return#0;
				private _target = [_charID] call A3PL_Lib_charIDToObject;
				if(isNull _target) then {
					[format ["DELETE FROM licenses WHERE charid ='%1' AND code = '%2'",_charID, _license], 1] call Server_Database_Async;
				} else {
					[_target,_license,0,_player] remoteExec ["Server_DMV_Add",2];
				};
				[_pname,_call,format[("STR_Server_Police_Database_LicenseRevoked" call A3PL_Localize),_pname]] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
			};
		};

		case "renewlicense": {
			private _pname = _name select 0;
			private _license = _name select 1;
			private _query = format ["SELECT charid, bank FROM players WHERE name='%1'",_pname];
			private _return = [_query, 2, true] call Server_Database_Async;
			if((count _return) < 1) then {
				[_pname,_call,format[("STR_Server_Police_Database_CantFind" call A3PL_Localize),_name]] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
			} else {
				private _charid = (_return select 0) select 0;
				private _target = [_charid] call A3PL_Lib_charIDToObject;
				private _price = ([_license,4] call A3PL_Config_GetLicenseData) * 0.5;

				private _hasLicense = [format["SELECT id FROM licenses WHERE charid='%1' && code='%2'",_charid,_license], 2, true] call Server_Database_Async;
				if(count _hasLicense isEqualTo 0) exitwith {
					[_pname,_call,format[("STR_Server_Police_Database_CitizenDontHave" call A3PL_Localize),_pname,_license]] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
				};
				if(_price > 0) then {
					_hasBankAccount = (_player getVariable ["Player_BankActive",0]) isnotEqualTo 0;
					if (!_hasBankAccount) exitWith {[("STR_Server_Police_Database_NoBankAccount" call A3PL_Localize),Color_Green] remoteExec["A3PL_Notification",_player];};
					private _priceReceive = _price * 0.4;
					private _pbank = _player getVariable["Player_Bank",0];
					_player setVariable["Player_Bank",_pbank+_priceReceive,true];
					[format[("STR_Server_Police_Database_YouReceivedForRenew" call A3PL_Localize),_priceReceive,[_license,0] call A3PL_Config_GetLicenseData],Color_Green] remoteExec["A3PL_Notification",_player];
					[getPlayerUID _player,(_player getVariable ["character_id",""]),"License_Renew",[format ["License: %1  | Target: %2",_license,_pname]]] call Server_Log_New;
				};
				if(isNull _target) then {
					private _tbank = (_return select 0) select 1;
					[format ["UPDATE players SET bank='%1' WHERE charid ='%2'",(_tbank-_price), _charid], 1] call Server_Database_Async;
					[format ["UPDATE licenses SET lastrenew = NOW(), issuedBy = '%3' WHERE charid ='%1' AND code = '%2'",_charid, _license,_player getVariable["name","unknown"]], 1] call Server_Database_Async;
				} else {
					if(_price > 0) then {
						_hasBankAccount = (_target getVariable ["Player_BankActive",0]) isnotEqualTo 0;
						if (!_hasBankAccount) exitWith {[("STR_Server_Police_Database_NoBankAccount" call A3PL_Localize),Color_Green] remoteExec["A3PL_Notification",_target];};
						_tbank = _target getVariable["Player_Bank",0];
						_target setVariable["Player_Bank",_tbank-_price,true];
					};
					[_target,_license,2,_player] remoteExec ["Server_DMV_Add",2];
				};
				[_pname,_call,format[("STR_Server_Police_Database_LicenseRenewed" call A3PL_Localize),_pname]] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
			};
		};

		case "viewlicense": {
			private _query = format ["SELECT p.name FROM players p, licenses l WHERE l.code = '%1' AND l.charid = p.charid",_name];
			private _return = [_query, 2, true] call Server_Database_Async;
			private _list = [];
			{
				_list pushback (_x#0);
			} foreach _return;
			[_name,_call,_list] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
		};

		case "darknet": {
			private _query = "SELECT name,chatmessage FROM logs_twitter_darknet ORDER BY id DESC LIMIT 10";
			private _return = [_query, 2,true] call Server_Database_Async;
			[_name,_call,_return] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
		};

		case "setcaution": {
			private _issuedBy = _name select 0;
			private _targetName = _name select 1;
			private _cautionDesc = _name select 2;

			private _query = format ["SELECT charid FROM players WHERE name='%1'", _targetName];
			private _return = [_query, 2, true] call Server_Database_Async;

			if (count _return < 1) then {
				[_targetName, _call, ("STR_Server_Police_Database_InvalidCitizenName" call A3PL_Localize)] remoteExec ["A3PL_Police_DatabaseEnterReceive", (owner _player)];
			} else {
				private _charid = (_return select 0) select 0;

				private _query = format ["SELECT charid FROM policedatabase WHERE ActionType='caution' AND charid='%1'", _charid];
				private _return = [_query, 2] call Server_Database_Async;

				if (count _return >= 1) exitWith {[_targetName, _call, ("STR_Server_Police_Database_PleaseRemoveCUrrentWarning" call A3PL_Localize)] remoteExec ["A3PL_Police_DatabaseEnterReceive", (owner _player)];};

				private _query = format ["INSERT INTO policedatabase (charid, ActionType, Info, Amount, IssuedBy, Time) VALUES ('%1', 'caution', '%2', '0', '%3', NOW())",_charid, _cautionDesc, _issuedBy];
				[_query, 1] call Server_Database_Async;

				[_targetName, _call, ("STR_Server_Police_Database_WarningUpdated" call A3PL_Localize)] remoteExec ["A3PL_Police_DatabaseEnterReceive", (owner _player)];
			};
		};

		case "clearcautions": {
			private _targetName = _name select 0;

			private _query = format ["SELECT charid FROM players WHERE name='%1'", _targetName];
			private _return = [_query, 2, true] call Server_Database_Async;

			if (count _return < 1) then {
				[_targetName, _call,("STR_Server_Police_Database_InvalidCitizenName" call A3PL_Localize)] remoteExec ["A3PL_Police_DatabaseEnterReceive", (owner _player)];
			} else {
				private _charid = (_return select 0) select 0;

				private _query = format ["SELECT charid FROM policedatabase WHERE ActionType='caution' AND charid='%1'", _charid];
				private _return = [_query, 2] call Server_Database_Async;

				if (count _return < 1) exitWith {[_targetName, _call, ("STR_Server_Police_Database_ThereIsNotWarningForThisCitizen" call A3PL_Localize)] remoteExec ["A3PL_Police_DatabaseEnterReceive", (owner _player)];};

				private _query = format ["DELETE FROM policedatabase WHERE (charid = (SELECT charid FROM players WHERE name='%1')) AND (actiontype='caution')",_targetName];
				[_query, 1] call Server_Database_Async;

				[_targetName, _call, ("STR_Server_Police_Database_WarningRemoved" call A3PL_Localize)] remoteExec ["A3PL_Police_DatabaseEnterReceive", (owner _player)];
			};
		};

		case "bololist": {
			private _query = format ["SELECT id, info, time, issuedby FROM policedatabase WHERE (actiontype='bolo')"];
			private _return = [_query, 2,true] call Server_Database_Async;
			[_name,_call,_return] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
		};

		case "insertbolo": {
			private _issuedBy = _name select 0;
			private _boloDesc = _name select 1;

			private _query = format ["SELECT charid FROM players WHERE name='%1'", _issuedBy];
			private _return = [_query, 2, true] call Server_Database_Async;
			private _charid = (_return select 0) select 0;

			private _query = format ["INSERT INTO policedatabase (charid, ActionType, Info, Amount, IssuedBy, Time) VALUES ('%1', 'bolo', '%2', '0', '%3', NOW())", _charid, _boloDesc, _issuedBy];
			[_query, 1] call Server_Database_Async;

			[_name, _call, ("STR_Server_Police_Database_InsertBolo" call A3PL_Localize)] remoteExec ["A3PL_Police_DatabaseEnterReceive", (owner _player)];
		};

		case "removebolo": {
			private _boloID = _name select 0;

			private _query = format ["SELECT id FROM policedatabase WHERE id='%1' AND ActionType='bolo'", _boloID];
			private _return = [_query, 2, true] call Server_Database_Async;

			if (count _return < 1) exitWith {[_name, _call, ("STR_Server_Police_Database_InvalidBoloID" call A3PL_Localize)] remoteExec ["A3PL_Police_DatabaseEnterReceive", (owner _player)];};

			private _query = format ["DELETE FROM policedatabase WHERE (ActionType='bolo') AND (id='%1')", _boloID];
			[_query, 1] call Server_Database_Async;

			[_name, _call, ("STR_Server_Police_Database_BoloRemoved" call A3PL_Localize)] remoteExec ["A3PL_Police_DatabaseEnterReceive", (owner _player)];
		};

		case "stolenvehicles": {
			private _query = format ["SELECT players_objects.charid, players_objects.id, players_objects.class, players.name FROM players_objects INNER JOIN players on players.charid = players_objects.charid WHERE NOT players_objects.type = 'object' AND players_objects.stolen = '1'"];
			private _return = [_query, 2, true] call Server_Database_Async;
			[_name,_call,_return] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
		};
		case "lookpatient": {
			private _query = format ["SELECT gender, dob, name, pasportdate FROM players WHERE name='%1'", _name];
			private _return = [_query, 2] call Server_Database_Async;
			[_name,_call,_return] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
		};
		case "lookhistory": {
			private _query = format ["SELECT * FROM firedatabase WHERE Patient = '%1'", _name];
			private _return = [_query, 2,true] call Server_Database_Async;
			[_name,_call,_return] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
		};
		case "addhistory": {
			private _pname = _name#0;
			private _place = _name#1;
			private _info = _name#2;
			private _issuedBy = _name#3;
			private _info = [_info] call Server_Database_EsapeString;
			// Check if the name exists in database -> REMOVED to allow adding history to fake names
			// private _query = format ["SELECT charid FROM players WHERE name = '%1'", _pname];
			// private _return = [_query, 2,true] call Server_Database_Async;
			// if((count _return) isEqualTo 0) exitWith {[_name,_call,format["Impossible de trouver patient %1 dans la base de données",_pname]] remoteExec ["A3PL_FD_DatabaseEnterReceive",(owner _player)];};
			private _query = format ["INSERT INTO firedatabase (Patient, Place, Informations, IssuedBy, Time) VALUES ('%1', '%2', '%3', '%4', NOW())",_pname,_place,_info,_issuedBy];
			private _return = [_query, 2,true] call Server_Database_Async;
			[_name,_call,format[("STR_Server_Police_Database_MedicalEntry" call A3PL_Localize),_pname]] remoteExec ["A3PL_Police_DatabaseEnterReceive",(owner _player)];
		};
	};
	[getPlayerUID _player,(_player getVariable ["character_id",""]),"MDT_Entry",[format ["Type: %1  | Data: %2",_call,_name]]] call Server_Log_New;
}] call compile_Server;

["Server_Police_PayTicket",
{
	private _ticketAmount = param [0,1];
	private _civ = param [1,objNull];
	private _cop = param [2,objNull];
	if ((isNull _civ) OR (isNull _cop)) exitwith {};

	_civ setVariable ["player_bank",(_civ getVariable ["player_bank",0]) - _ticketAmount, true];

    //private _ticketAmountDivide = 0;
	//_ticketAmountDivide = _ticketAmount / 2;
	[("STR_Common_SheriffsDepartment" call A3PL_Localize),_ticketAmount] remoteExec ["Server_Government_AddBalance",2];
}] call compile_Server;

["Server_Police_JailPlayer",
{
	params[["_time",0,[0]],["_target",objNull,[objNull]]];
	private _charID = (_target getVariable ["character_id",""]);
	private _exit = false;
	if(_time < 0) exitWith {};
	{
		if ((_x select 0) == _target) exitwith
		{
			Server_Jailed_Players set [_forEachIndex,[_x select 0,_x select 1,_time]];
			_target setVariable ["jailtime",_time,true];
			_exit = true;
		};
	} foreach Server_Jailed_Players;
	if (_exit) exitwith {};
	Server_Jailed_Players pushBack [_target,_charID,_time];
	private _query = format ["UPDATE players SET jail=%1 WHERE charid = '%2'",_time,_charID];
	[_query, 1] call Server_Database_Async;

	_target	setVariable["jail_mark",true,true];
	_target setVariable ["jailtime",_time,true];
	_target setVariable ["jailed",true,true];
}] call compile_Server;

["Server_Police_JailLoop",
{
	{
		private _target = _x select 0;
		private _charID = _x select 1;
		private _time = _x select 2;
		private _pObject = [_charID] call A3PL_Lib_charIDToObject;
		if(!isNull _pObject) then {_target = _pObject;};
		if(isNull _target) exitWith {
			private _query = format ["UPDATE players SET jail=%1 WHERE charid = '%2'",_time,_charID];
			[_query, 1] call Server_Database_Async;
			Server_Jailed_Players deleteAt _forEachIndex;
		};
		if(_time <= 1) exitWith {
			_target setVariable ["jailtime",0,true];
			_target setVariable ["jailed",false,true];
			[] remoteExec ["A3PL_Police_ReleasePlayer",_target];
			Server_Jailed_Players deleteAt _forEachIndex;
			private _query = format ["UPDATE players SET jail=%1 WHERE charid = '%2'",0,_charID];
			[_query, 1] call Server_Database_Async;
		};
		_target setVariable ["jailtime",(_time-1),true];
		Server_Jailed_Players set [_forEachIndex, [_target,_charID,(_time-1)]];
	} forEach Server_Jailed_Players;
}] call compile_Server;

["Server_Police_SeizureLoad",
{
	private _evidenceBoxes = [[A3FL_Seize_Storage,Server_SeizureStorage],[evidence_box_elk,Server_SeizureB1],[evidence_box_nd,Server_SeizureB2],[evidence_box_svt,Server_SeizureB3]];
	{
		private _storage = _x#0;
		private _var = _x#1;
		private _aitems = _var#0;
		private _mags = _var#1;
		private _backpacks = _var#2;
		private _weapons = _var#3;
		private _virtual = _var#4;
		for "_i" from 0 to ((count (_aitems#0)) - 1) do {
			_storage addItemCargoGlobal [((_aitems#0)#_i), ((_aitems#1)#_i)];
		};
		for "_i" from 0 to ((count (_mags#0)) - 1) do {
			_storage addMagazineCargoGlobal [((_mags#0)#_i), ((_mags#1)#_i)];
		};
		for "_i" from 0 to ((count (_backpacks#0)) - 1) do {
			_storage addBackpackCargoGlobal [((_backpacks#0)#_i), ((_backpacks#1)#_i)];
		};
		for "_i" from 0 to ((count (_weapons#0)) - 1) do {
			_storage addWeaponCargoGlobal [((_weapons#0)#_i), ((_weapons#1)#_i)];
		};
		_storage setVariable["storage",_virtual,true];
		_storage setVariable["capacity",10000,true];
	} forEach _evidenceBoxes;
}] call compile_Server;

["Server_Police_SeizureSave",
{
	private _evidenceBoxes = [[A3FL_Seize_Storage,'Server_SeizureStorage'],[evidence_box_elk,'Server_SeizureB1'],[evidence_box_nd,'Server_SeizureB2'],[evidence_box_svt,'Server_SeizureB3']];
	{
		private _storage = _x#0;
		private _aitems = getItemCargo _storage;
		private _mags = getMagazineCargo _storage;
		private _backpacks = getBackpackCargo _storage;
		private _weapons = getWeaponCargo _storage;
		private _virtual = _storage getVariable["storage", []];
		private _inventory = [_aitems,_mags,_backpacks,_weapons,_virtual];
		private _inventory = [_inventory] call Server_Database_Array;
		private _query = format ["UPDATE persistent_vars SET value='%2' WHERE var = '%1'",_x#1,_inventory];
		[_query,1] spawn Server_Database_Async;
	} forEach _evidenceBoxes;
}] call compile_Server;

["Server_Police_ReceiveDispatch",
{
	params[
		["_callFaction",""],
		["_callTitle",""],
		["_callLocation",[]],
		["_callInfo",""],
		["_callNotification",""]
	];
	private _factionCount = count([_callFaction] call A3PL_Lib_FactionPlayers);
	if(_factionCount isEqualTo 0) exitWith {};
	private _estTime = "extDB3" callExtension "9:UTC_TIME:-5";
	private _timeArray = (parseSimpleArray (_estTime))#1;
	private _timeFormat = format["%1/%2/%3 %4:%5 EST",_timeArray#1,_timeArray#2,_timeArray#0,_timeArray#3,_timeArray#4];
	private _compileCallInfo = format[("STR_Server_Police_ReceiveDispatchInfo" call A3PL_Localize),_callInfo,_timeFormat];
	Server_Police_DispatchCount = Server_Police_DispatchCount + 1;
	[format["%1: %2",_callNotification,_callTitle],Color_Blue,_callFaction,1] spawn A3PL_Lib_JobMessage;
	Server_Police_Dispatch pushback [_callFaction,_callTitle,_callLocation,_compileCallInfo,[],Server_Police_DispatchCount];
	publicVariable "Server_Police_Dispatch";
}] call compile_Server;

["Server_Police_AttachDispatch",
{
	params [
		["_index",0],
		["_veh",objNull],
		["_detach",false],
		["_player",objNull]
	];
	private _curData = Server_Police_Dispatch#_index;
	private _error = false;
	if(_detach) then {
		if !(_veh IN (_curData#4)) exitwith {_error = true;};
		_curData#4 deleteAt (_curData#4 find _veh);
	} else {
		if(_veh IN (_curData#4)) exitwith {_error = true;};
		_curData#4 pushback _veh;
	};
	Server_Police_Dispatch set[_index,_curData];
	if(_error) exitWith {};
	publicVariable "Server_Police_Dispatch";

	if(!isNull _player) then {[(_veh getVariable["CAD_Faction",""])] remoteExecCall ["A3PL_Police_GetCalls",_player];};
}] call compile_Server;

["Server_Police_ResolveDispatch",
{
	params[["_index",0],["_veh",objNull],["_player",objNull]];
	private _vehicles = (Server_Police_Dispatch#_index)#4;
	{
		_x setVariable["CAD_Call",nil,true];
		_x setVariable["CAD_Status",("STR_Server_Police_Dispatch_Available" call A3PL_Localize),true];
	} forEach _vehicles;
	Server_Police_Dispatch deleteAt _index;
	publicVariable "Server_Police_Dispatch";
	if(!isNull _player) then {[(_veh getVariable["CAD_Faction",""])] remoteExecCall ["A3PL_Police_GetCalls",_player];};
}] call compile_Server;
