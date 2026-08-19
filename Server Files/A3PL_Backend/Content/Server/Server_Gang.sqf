/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["Server_Gang_Load", {
	params [["_player",objNull,[objNull]]];

	private _req = format["SELECT id, owner, name, members, bank, maxmembers FROM gangs WHERE active='1' AND members LIKE '%2%1%2'",(_player getVariable ["character_id",""]),'%'];
	private _gang = [_req, 2] call Server_Database_Async;
	if(count(_gang) > 0) then {
		_gang = [_gang select 0, _gang select 1, _gang select 2, [_gang select 3] call Server_Database_ToArray, _gang select 4, _gang select 5];
		//[_gang] remoteExec ["A3PL_Gang_SetData",_player];
		[_gang] remoteExec ["A3PL_Gang_Init",_player];
	};
}] call compile_Server;

["Server_Gang_Create", {
	params [
		["_owner",objNull,[objNull]],
		["_gangName","",[""]]
	];

	private _charID = (_owner getVariable ["character_id",""]);
	private _group = group _owner;
	private _gangName = [_gangName] call Server_Database_EsapeString;
	private _query = format ["SELECT id FROM gangs WHERE name='%1' AND active='1'",_gangName];
	private _queryResult = [_query,2] call Server_Database_Async;

	if (!(count _queryResult isEqualTo 0)) exitWith {[format[("STR_Server_Gang_Created" call A3PL_Localize),_gangName], Color_Red] remoteExec ["A3PL_Notification",_owner];};

	private _gangMembers = [_charID];
	private _query = format ["INSERT INTO gangs(owner, name, members) VALUES('%1','%2','%3')",_charID,_gangName,_gangMembers];
	[_query,1] call Server_Database_Async;

	sleep 1;

	[_owner] call Server_Gang_Load;
	[_group] remoteExecCall ["A3PL_Gang_Created",_owner];
}] call compile_Server;

["Server_Gang_SaveMembers", {
	params [["_group",grpNull,[grpNull]]];

	private _gang = _group getVariable ["gang_data",nil];
	if(isNil '_gang') exitWith {};
	private _groupID = _gang select 0;
	private _members = _gang select 3;
	[format ["UPDATE gangs SET members='%1' WHERE id='%2'",_members,_groupID], 1] call Server_Database_Async;
}] call compile_Server;

["Server_Gang_SaveBank", {
	params [["_group",grpNull,[grpNull]]];

	private _gang = _group getVariable ["gang_data",nil];
	if(isNil '_gang') exitWith {};
	private _groupID = _gang select 0;
	private _bank = _gang select 4;
	[format ["UPDATE gangs SET bank='%1' WHERE id='%2'",_bank,_groupID], 1] call Server_Database_Async;
}] call compile_Server;

["Server_Gang_DeleteGang", {
	params [
		["_group",grpNull,[grpNull]],
		["_player",objNull,[objNull]]
	];

	private _gang = _group getVariable["gang_data",nil];
	if(isNil '_gang') exitWith {};
	private _groupID = _gang select 0;
	deleteGroup _group;
	[format["DELETE FROM gangs WHERE id = '%1'",_groupID], 1] call Server_Database_Async;
	[("STR_Server_Gang_YouDeletedYourGang" call A3PL_Localize), Color_Green] remoteExec ["A3PL_Notification",_player];
}] call compile_Server;

["Server_Gang_SetLead", {
	params [["_group",grpNull,[grpNull]]];

	private _gang = _group getVariable ["gang_data",nil];
	if(isNil '_gang') exitWith {};
	private _groupID = _gang select 0;
	private _owner = _gang select 1;
	[format ["UPDATE gangs SET owner='%1' WHERE id='%2'",_owner,_groupID], 1] call Server_Database_Async;
	private _owner = [_owner] call A3PL_Lib_charIDToObject;
	[format[("STR_Server_Gang_YouAreNowLeader" call A3PL_Localize)], Color_Green] remoteExec ["A3PL_Notification",_owner];
}] call compile_Server;

["Server_Gang_UpdateGangBalance", {
	params [
		["_gangID",0,[0]],
		["_amount",0,[0]]
	];

	private _gangObj = grpNull;

	{
		private _gang = _x getVariable ["gang_data",nil];
		if(!isNil '_gang') then {
			private _groupID = _gang select 0;
			if(_groupID isEqualTo _gangID) exitWith {
				_prevBal = _gang select 4;
				_gang set[4,(_prevBal + _amount)];
				_gangObj = _x;
				_x setVariable["gang_data",_gang,true];
			};
		};			
	} forEach allGroups;

	[_gangObj] spawn Server_Gang_SaveBank;

}] call compile_Server;

["Server_Gang_NotifyPurchase", {
	params [
		["_gangID",0,[0]],
		["_amount",0,[0]],
		["_type","purchased",["purchased"]]
	];

	private _group = grpNull;

	{
			private _gang = _x getVariable ["gang_data",nil];
			if(!isNil '_gang') then {
				private _groupID = _gang select 0;
				if(_groupID isEqualTo _gangID) exitWith {
					_group = _x;
				};
			};
	} forEach allGroups;

	[format[("STR_Server_Gang_SomeoneBoughtYourProtection" call A3PL_Localize),_type,_amount],Color_Green] remoteExec ["A3PL_Notification",_group];
}] call compile_Server;

["Server_Gang_RewardFactions", {
	params [["_faction",("STR_Common_FISD" call A3PL_Localize),[("STR_Common_FISD" call A3PL_Localize)]]];

	private _amount = 50000;
	{
		[("STR_Common_SheriffsDepartment" call A3PL_Localize),_amount] remoteExec ["Server_Government_AddBalance",2];
		[format[("STR_Server_Gang_HideoutCaptured" call A3PL_Localize),_amount],Color_Green] remoteExec ["A3PL_Notification",_x];
	} foreach ([_faction] call A3PL_Lib_FactionPlayers);
}] call compile_Server;

["Server_Gang_ManageSetup", {
	params [
		["_id",-1,[-1]],
		["_player",objNull,[objNull]]
	];

	private _query = [format ["SELECT members FROM gangs WHERE id='%1'",_id], 2] call Server_Database_Async;
	if(count(_query) isEqualTo 0) exitWith {};
	private _members = [_query select 0] call Server_Database_ToArray;
	private _compileMembers = [];
	{
		private _name = ([format ["SELECT name FROM players WHERE charid='%1'",_x], 2] call Server_Database_Async) select 0;
		_compileMembers pushback ([_name, _x]);
	} foreach _members;
	[_compileMembers] remoteExec ["A3PL_Phone_gangMngmtReceived",(owner _player)];
}] call compile_Server;
