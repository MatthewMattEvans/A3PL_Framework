/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3FL_Debug_Init", {
	[] spawn {
		scriptName "A3FL_DebugInfoLoop";
		private _debugMenu = findDisplay 155;
		private _infoCtrl = _debugMenu displayCtrl 34;
		while {!(isNull findDisplay 155)} do {
			_infoCtrl ctrlSetStructuredText parseText format ["
				<t size='0.7' color='#a6a6a6'>FPS: </t><t size='0.7'>%1</t><br/>
				<t size='0.7' color='#a6a6a6'>serverTime: </t><t size='0.7'>%2</t><br/>
				<t size='0.7' color='#a6a6a6'>ActiveScripts: </t><t size='0.7'>%4</t><br/>
				<t size='0.7' color='#a6a6a6'>ResLods: </t><t size='0.7'>%5</t><br/>
				<t size='0.7' color='#a6a6a6'>Player_ObjIntersect: </t><t size='0.7'>%6</t><br/>
				<t size='0.7' color='#a6a6a6'>typeOf Target: </t><t size='0.7'>%7</t><br/>
				<t size='0.7' color='#a6a6a6'>Target: </t><t size='0.7'>%3</t><br/>
				",
				round diag_fps,
				round serverTime,
				getModelInfo cursorObject,
				diag_activeScripts,
				{_x select 1 in "0123456789"} count (allLODs ((getModelInfo cursorObject) select 1)),
				Player_ObjIntersect,
				typeOf cursorObject
			];
			uiSleep 0.15;
		};
	};
	[] spawn {
		scriptName "A3FL_DebugWatchLoop";
		private _debugMenu = findDisplay 155;
		private _watch1Ctrl = _debugMenu displayCtrl 11;
		private _watch2Ctrl = _debugMenu displayCtrl 12;
		private _watch3Ctrl = _debugMenu displayCtrl 13;
		private _watch1ReturnCtrl = _debugMenu displayCtrl 21;
		private _watch2ReturnCtrl = _debugMenu displayCtrl 22;
		private _watch3ReturnCtrl = _debugMenu displayCtrl 23;
		private _codeCtrl = _debugMenu displayCtrl 51;
		
		_watch1Ctrl ctrlSetText (profileNamespace getVariable ["A3FL_Debug_Watch1", ""]);
		_watch2Ctrl ctrlSetText (profileNamespace getVariable ["A3FL_Debug_Watch2", ""]);
		_watch3Ctrl ctrlSetText (profileNamespace getVariable ["A3FL_Debug_Watch3", ""]);
		_codeCtrl ctrlSetText (profileNamespace getVariable ["A3FL_Debug_Expression", ""]);
	
		while {!(isNull findDisplay 155)} do {
			if (ctrlText _watch1Ctrl isEqualTo "") then {
				_watch1ReturnCtrl ctrlSetText ""
			} else {
				_watch1ReturnCtrl ctrlSetText str (call compile (ctrlText _watch1Ctrl));
			};
			if (ctrlText _watch2Ctrl isEqualTo "") then {
				_watch2ReturnCtrl ctrlSetText ""
			} else {
				_watch2ReturnCtrl ctrlSetText str (call compile (ctrlText _watch2Ctrl));
			};
			if (ctrlText _watch3Ctrl isEqualTo "") then {
				_watch3ReturnCtrl ctrlSetText ""
			} else {
				_watch3ReturnCtrl ctrlSetText str (call compile (ctrlText _watch3Ctrl));
			};
			uiSleep 0.01;
		};
	};

	private _debugMenu = findDisplay 155;
	private _clearCtrl = _debugMenu displayCtrl 160;
	private _prevCtrl = _debugMenu displayCtrl 141;
	private _nextCtrl = _debugMenu displayCtrl 142;
	private _watch1Ctrl = _debugMenu displayCtrl 11;
	private _watch2Ctrl = _debugMenu displayCtrl 12;
	private _watch3Ctrl = _debugMenu displayCtrl 13;
	private _codeCtrl = _debugMenu displayCtrl 51;

	uiNamespace setVariable ["A3FL_DebugExpressionIndex", -1];
	call A3FL_Debug_UpdateHistoryButtons;

	_codeCtrl ctrlAddEventHandler ["KeyDown", {call A3FL_Debug_SaveFields}];
	_watch1Ctrl ctrlAddEventHandler ["KeyDown", {call A3FL_Debug_SaveFields}];
	_watch2Ctrl ctrlAddEventHandler ["KeyDown", {call A3FL_Debug_SaveFields}];
	_watch3Ctrl ctrlAddEventHandler ["KeyDown", {call A3FL_Debug_SaveFields}];
	
	_clearCtrl ctrlAddEventHandler ["ButtonClick", {
		((findDisplay 155) displayCtrl 51) ctrlSetText "";
		uiNamespace setVariable ["A3FL_DebugExpressionIndex", 0];
	}];
	
	_prevCtrl ctrlAddEventHandler ["ButtonClick", {
		private _debugMenu = findDisplay 155;
		private _codeCtrl = _debugMenu displayCtrl 51;
		private _debugHistory = ([] + (profileNamespace getVariable ["A3FL_Debug_ExpressionHistory",[]]));
		private _curIndex = uiNamespace getVariable ["A3FL_DebugExpressionIndex", 0];
		if (_curIndex > (count _debugHistory - 1)) exitWith {
			reverse _debugHistory;
			_codeCtrl ctrlSetText (_debugHistory select _curIndex);
		};
		
		_curIndex = _curIndex + 1;
		reverse _debugHistory;
		_codeCtrl ctrlSetText (_debugHistory select _curIndex);

		if (_curIndex == count _debugHistory) then {
			_curIndex = _curIndex - 1;
		};

		uiNamespace setVariable ["A3FL_DebugExpressionIndex", _curIndex];
		call A3FL_Debug_UpdateHistoryButtons;
	}];

	_nextCtrl ctrlAddEventHandler ["ButtonClick", {
		private _debugMenu = findDisplay 155;
		private _codeCtrl = _debugMenu displayCtrl 51;
		private _debugHistory = ([] + (profileNamespace getVariable ["A3FL_Debug_ExpressionHistory",[]]));
		private _curIndex = uiNamespace getVariable ["A3FL_DebugExpressionIndex", 0];
		if (_curIndex == 0) exitWith {};
		_curIndex = _curIndex - 1;
		uiNamespace setVariable ["A3FL_DebugExpressionIndex", _curIndex];

		reverse _debugHistory;
		_codeCtrl ctrlSetText (_debugHistory select _curIndex);
		call A3FL_Debug_UpdateHistoryButtons;
	}];
}] call compile_Global;

["A3FL_Debug_UpdateHistoryButtons", {
	private _prevCtrl = _debugMenu displayCtrl 141;
	private _nextCtrl = _debugMenu displayCtrl 142;
	private _countHistory = count ([] + (profileNamespace getVariable ["A3FL_Debug_ExpressionHistory",[]]));
	private _index = uiNamespace getVariable ["A3FL_DebugExpressionIndex", 0];
	if (_index <= 0) then {
		_nextCtrl ctrlEnable false;
	} else {
		_nextCtrl ctrlEnable true;
	};
	if (_index >= (_countHistory - 1)) then {
		_prevCtrl ctrlEnable false;
	} else {
		_prevCtrl ctrlEnable true;
	};
	(_debugMenu displayCtrl 52) ctrlSetText str _index;
}] call compile_Global;

["A3FL_Debug_SaveFields", {
	private _debugMenu = findDisplay 155;
	private _watch1Ctrl = _debugMenu displayCtrl 11;
	private _watch2Ctrl = _debugMenu displayCtrl 12;
	private _watch3Ctrl = _debugMenu displayCtrl 13;
	private _codeCtrl = _debugMenu displayCtrl 51;
	profileNamespace setVariable ["A3FL_Debug_Watch1",ctrlText _watch1Ctrl];
	profileNamespace setVariable ["A3FL_Debug_Watch2",ctrlText _watch2Ctrl];	
	profileNamespace setVariable ["A3FL_Debug_Watch3",ctrlText _watch3Ctrl];
	profileNamespace setVariable ["A3FL_Debug_Expression",ctrlText _codeCtrl];
}] call compile_Global;

["A3FL_Debug_Exec", {
	params [["_mode", "", [""]]];
	private _debugMenu = findDisplay 155;
	private _codeCtrl = _debugMenu displayCtrl 51;
	private _codeReturnCtrl = _debugMenu displayCtrl 52;
	private _code = ctrlText _codeCtrl;

	uiNamespace setVariable ["A3FL_DebugExpressionIndex", 0];
	private _debugHistory = profileNamespace getVariable ["A3FL_Debug_ExpressionHistory",[]];
	if (_debugHistory isEqualTo [] || {!(_debugHistory select (count _debugHistory - 1) isEqualTo _code)}) then {
		_debugHistory pushBack _code;
	};
	if (count _debugHistory > 21) then {
		_debugHistory deleteAt 0;
	};
	profileNamespace setVariable ["A3FL_Debug_ExpressionHistory",_debugHistory];

	switch (_mode) do {
		case "clients": {
			[_code] remoteExecCall ["A3FL_Debug_RemoteExecClients"];
			_codeReturnCtrl ctrlSetText str (call compile _code);
			[player,"DebugExecuted",[format ["Debug: %1 Type: Clients",_code]]] remoteExec ["Server_AdminLoginsert", 2];
		};
		case "global": {
			[_code] remoteExecCall ["A3FL_Debug_RemoteExecGlobal"];
			_codeReturnCtrl ctrlSetText str (call compile _code);
			[player,"DebugExecuted",[format ["Debug: %1 Type: Global",_code]]] remoteExec ["Server_AdminLoginsert", 2];
		};
		case "server": {
			[_code, _codeReturnCtrl] spawn {
				params [
					["_code", "", [""]],
					["_codeReturnCtrl", controlNull, [controlNull]]
				];
				scriptName "ServerExecReturnWait";
				private _execId = hashValue time;
				[_execId, _code] remoteExecCall ["A3FL_Debug_RemoteExecServer", 2];
				[player,"DebugExecuted",[format ["Debug: %1 Type: Server",_code]]] remoteExec ["Server_AdminLoginsert", 2];
				waitUntil {(missionNamespace getVariable ["A3FL_Debug_ServerReturn", ["",""]] select 0 isEqualTo _execId);};
				if !(isNull findDisplay 155) then {
					_codeReturnCtrl ctrlSetText str (A3FL_Debug_ServerReturn select 1);
				};
			};
		};
		default { 
			_codeReturnCtrl ctrlSetText str (call compile _code);
			[player,"DebugExecuted",[format ["Debug: %1 Type: Local",_code]]] remoteExec ["Server_AdminLoginsert", 2];
		};
	};
}] call compile_Global;

["A3FL_Debug_RemoteExecServer", {
	params [
		["_execId", "", [""]],
		["_code", "", [""]]
	];
	diag_log (["A3FL: A3FL_Debug_RemoteExecServer - Caller:",(A3FL_ClientOwnerTable get remoteExecutedOwner),"Code:",(compile _code)] joinString " ");
	A3FL_Debug_ServerReturn = [_execId, call compile _code];
	remoteExecutedOwner publicVariableClient "A3FL_Debug_ServerReturn";
}] call compile_Server;

["A3FL_Debug_RemoteExecClients", {
	params [["_code", "", [""]]];
	diag_log (["A3FL: A3FL_Debug_RemoteExecClients - Caller:",(A3FL_ClientOwnerTable get remoteExecutedOwner),"Code:",(compile _code)] joinString " ");
	if (isServer || (remoteExecutedOwner isEqualTo clientOwner)) exitWith {};
	call compile _code;
}] call compile_Global;

["A3FL_Debug_RemoteExecGlobal", {
	params [["_code", "", [""]]];
	diag_log (["A3FL: A3FL_Debug_RemoteExecGlobal - Caller:",(A3FL_ClientOwnerTable get remoteExecutedOwner),"Code:",(compile _code)] joinString " ");
	if (remoteExecutedOwner isEqualTo clientOwner) exitWith {};
	call compile _code;
}] call compile_Global;

["A3FL_Debug_RegisterClientOwner", {
	params [
		["_machineID", 0, [0]],
		["_uid", "", [""]]
	];
	if !(isRemoteExecuted) exitWith {};
	if (isNil "A3FL_ClientOwnerTable") then {
		A3FL_ClientOwnerTable = createHashMapFromArray [[_machineID,_uid]];
	} else {
		A3FL_ClientOwnerTable set [_machineID,_uid];
	};
	publicVariable "A3FL_ClientOwnerTable";
}] call compile_Global;
