/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["Server_DMV_Add", {
	params [
		["_target",objNull,[objNull]],
		["_license","driver",["driver"]],
		["_action",1,[1]],
		["_author",objNull,[objNull]]
	];

	private _uid = getPlayerUID _target;
	private _charID = _target getVariable ["character_id",""];
	private _licenses = _target getVariable ["licenses",[]];
	switch(_action) do {
		case 0: {
			if (_license IN _licenses) then {
				_licenses = _licenses - [_license];
				_target setVariable ["licenses",_licenses,true];
				[format[("STR_Server_DMV_RevokedLicense" call A3PL_Localize),[_license,0] call A3PL_Config_GetLicenseData], Color_Red] remoteExec ["A3PL_Notification",_target];
				[_uid,_charID,"License_Revoked",[format ["License: %1 | Revoked By: %2",_license,(_author getVariable["name","unknown"])]]] call Server_Log_New;
				[(getPlayerUID _author),(_author getVariable ["character_id",""]),"License_Revoke",[format ["License: %1 | Target: %2",_license,(_target getVariable["name","unknown"])]]] call Server_Log_New;
				[format ["DELETE FROM licenses WHERE charid ='%1' AND code = '%2'",_charID, _license], 1] call Server_Database_Async;
			};
		};
		case 1: {
			if (!(_license IN _licenses)) then {
				_licenses pushback _license;
				_target setVariable ["licenses",_licenses,true];
				[format[("STR_Server_DMV_YouReceived" call A3PL_Localize),[_license,0] call A3PL_Config_GetLicenseData], Color_Green] remoteExec ["A3PL_Notification",_target];
				[_uid,_charID,"License_Added",[format ["License: %1 | Added By: %2",_license,(_author getVariable["name","unknown"])]]] call Server_Log_New;
				[(getPlayerUID _author),(_author getVariable ["character_id",""]),"License_Add",[format ["License: %1 | Target: %2",_license,(_target getVariable["name","unknown"])]]] call Server_Log_New;
				_authorStr = if(typeName _author isEqualTo "STRING") then {_author} else {_author getVariable["name","unknown"]};
				[format ["INSERT INTO licenses(charid,code,issuedate,issuedBy) VALUES ('%1','%2',NOW(),'%3')",_charID, _license, _authorStr], 1] call Server_Database_Async;
			};
		};
		case 2: {
			[_uid,_charID,"License_Renewed",[format ["License: %1 | Renewed By: %2",_license,(_author getVariable["name","unknown"])]]] call Server_Log_New;
			[(getPlayerUID _author),(_author getVariable ["character_id",""]),"License_Renew",[format ["License: %1 | Target: %2",_license,(_target getVariable["name","unknown"])]]] call Server_Log_New;
			[format ["UPDATE licenses SET lastrenew = NOW(), issuedBy = '%3' WHERE charid ='%1' AND code = '%2'",_charID, _license, _author getVariable["name","unknown"]], 1] call Server_Database_Async;
		};
	};
}] call compile_Server;

["Server_DMV_LoadLicenses", {
	params [["_unit",objNull,[objNull]]];

	private _charID = _unit getVariable["character_id",""];
	private _query = [format["SELECT code FROM licenses WHERE charid = '%1' AND status = '1'",_charID], 2,true] call Server_Database_Async;
	private _licenses = [];
	{_licenses pushback (_x#0);} foreach _query;
	_unit setVariable["licenses",_licenses,true];
}] call compile_Server;