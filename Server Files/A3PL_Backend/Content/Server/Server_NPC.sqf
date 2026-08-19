/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["Server_NPC_RequestJob", {
	params[["_player",ObjNull,[ObjNull]],["_job",("STR_Common_Job_Unemployed" call A3PL_Localize),[""]],["_notify",true,[true]]];
	private _oldJob = _player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
	if (isNull _player) exitwith {};
	_player setVariable ["job",_job,true];
	[getPlayerUID _player,(_player getVariable ["character_id",""]),"ChangeJob",[format ["Old Job: %1 | New Job: %2",_oldJob,_job]]] call Server_Log_New;
	[1,_job,_notify] remoteExec ["A3PL_NPC_TakeJobResponse",_player];
	//[] remoteExec ["A3PL_Player_SetMarkers", _player];
	if (_oldJob IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) then {[(_player getVariable ["character_id",""])] call Server_Log_Faction_ClockOut;};
}] call compile_Server;

["Server_NPC_Create",
{
	private _npcID = param [0,""];
	private _customPos = param [1,[]];
	
	if (_npcID isEqualTo "") exitWith {
		objNull;
	};
	
	private _npcConfig = nil;
	{
		if ((_x#0) == _npcID) exitWith {
			_npcConfig = _x;
		};
	} foreach Config_NPC_Spawn;
	
	if (isNil "_npcConfig") exitWith {
		objNull;
	};
	
	private _npcType = _npcConfig#1;
	private _npcPosConfig = _npcConfig#2;
	private _npcPos = if (count _customPos > 0) then {_customPos} else {_npcPosConfig};
	private _npcName = _npcConfig#3;
	private _npcVoice = _npcConfig#4;
	private _npcUniform = _npcConfig#5;
	private _npcHeadgear = _npcConfig#6;
	private _npcGoggles = _npcConfig#7;
	private _npcVest = _npcConfig#8;
	private _npcBackpack = _npcConfig#9;
	private _npcItems = _npcConfig#10;
	private _npcPath = if (count _npcConfig > 11) then {_npcConfig#11} else {[]};
	private _npcTimeWindow = if (count _npcConfig > 12) then {_npcConfig#12} else {[]};
	private _autoSpawn = if (count _npcConfig > 13) then {_npcConfig#13} else {0};
	
	private _isInTimeWindow = true;
	if (count _npcTimeWindow == 2) then {
		private _currentTime = date select 3; 
		private _startHour = _npcTimeWindow select 0;
		private _endHour = _npcTimeWindow select 1;
		
		if (_startHour <= _endHour) then {
			_isInTimeWindow = (_currentTime >= _startHour && _currentTime < _endHour);
		} else {
			_isInTimeWindow = (_currentTime >= _startHour || _currentTime < _endHour);
		};
	};
	
	private _spawnPos = [];
	private _spawnDir = 0;
	if (count _npcPos >= 3) then {
		_spawnPos = [_npcPos#0, _npcPos#1, _npcPos#2];
		if (count _npcPos >= 4) then {
			_spawnDir = _npcPos#3;
		};
	} else {
		_spawnPos = _npcPos;
	};
	
	private _group = createGroup [civilian, true];
	private _npc = _group createUnit [_npcType, _spawnPos, [], 0, "NONE"];
	
	if (isNull _npc) exitWith {
		objNull;
	};
	
	_group setGroupOwner 2;
	
	_npc setName _npcName;
	
	if (_npcVoice != "") then {
		_npc setSpeaker _npcVoice;
	};
	
	if (_npcUniform != "") then {
		_npc forceAddUniform _npcUniform;
	};
	
	if (_npcHeadgear != "") then {
		_npc addHeadgear _npcHeadgear;
	};
	
	if (_npcGoggles != "") then {
		_npc addGoggles _npcGoggles;
	};
	
	if (_npcVest != "") then {
		_npc addVest _npcVest;
	};
	
	if (_npcBackpack != "") then {
		_npc addBackpack _npcBackpack;
	};
	
	{
		private _itemType = _x#0;
		private _itemName = _x#1;
		private _itemQuantity = _x#2;
		
		for "_i" from 1 to _itemQuantity do {
			switch (_itemType) do {
				case "item": {_npc addItem _itemName;};
				case "weapon": {_npc addWeapon _itemName;};
				case "magazine": {_npc addMagazine _itemName;};
			};
		};
	} foreach _npcItems;
	
	if (_spawnDir > 0) then {
		_npc setDir _spawnDir;
	};
	
	_npc disableAI "FSM";
	_npc disableAI "AUTOTARGET";
	_npc disableAI "TARGET";
	_npc setBehaviour "CARELESS";
	_npc setCombatMode "BLUE";
	_npc allowDamage false;
	
	_npc setVariable ["A3PL_NPC_ID", _npcID, true];
	_npc setVariable ["A3PL_NPC_ID_Config", _npcID, true];
	
	if (count _npcTimeWindow == 2 && !_isInTimeWindow) then {
		[_npc, _npcID, _npcTimeWindow] spawn {
			params ["_npc", "_npcID", "_npcTimeWindow"];
			sleep 1;
			private _currentTime = date select 3;
			private _startHour = _npcTimeWindow select 0;
			private _endHour = _npcTimeWindow select 1;
			private _stillOutOfWindow = false;
			
			if (_startHour <= _endHour) then {
				_stillOutOfWindow = !(_currentTime >= _startHour && _currentTime < _endHour);
			} else {
				_stillOutOfWindow = !(_currentTime >= _startHour || _currentTime < _endHour);
			};
			
			if (_stillOutOfWindow && alive _npc) then {
				_npc hideObjectGlobal true;
				_npc enableSimulationGlobal false;
			};
		};
	};
	
	if (count Config_NPC_Identities > 0) then {
		private _randomIdentity = Config_NPC_Identities select (floor (random (count Config_NPC_Identities)));
		_npc setVariable ["identity", _randomIdentity, true];
	};
	
	if (count _npcTimeWindow == 2) then {
		_npc setVariable ["A3PL_NPC_TimeWindow", _npcTimeWindow, true];
	};
	
	if (count _npcPath > 0) then {
		_npc setVariable ["A3PL_NPC_PatrolPath", _npcPath, true];
		if (_isInTimeWindow) then {
			_npc allowDamage false;
			_npc enableAI "MOVE";
			_npc setSpeedMode "LIMITED";
			_npc setUnitPos "UP";
			_npc forceSpeed 1.5;
			[_npc, _npcPath] spawn A3PL_NPC_PatrolWaypoint;
		} else {
			_npc disableAI "MOVE";
		};
	} else {
		_npc disableAI "MOVE";
	};
	
	_npc
}] call compile_Server;

["Server_NPC_CheckTimeWindow",
{
	private _npc = param [0, objNull];
	
	if (isNull _npc) exitWith {false};
	
	if (_npc getVariable ["A3PL_NPC_Hooker_Active", false]) exitWith {true};
	
	private _timeWindow = _npc getVariable ["A3PL_NPC_TimeWindow", []];
	
	if (count _timeWindow != 2) exitWith {true};
	
	private _currentTime = date select 3;
	private _startHour = _timeWindow select 0;
	private _endHour = _timeWindow select 1;
	
	private _result = false;
	
	if (_startHour <= _endHour) then {
		_result = (_currentTime >= _startHour && _currentTime < _endHour);
	} else {
		_result = (_currentTime >= _startHour || _currentTime < _endHour);
	};
	
	_result;
}] call compile_Server;

["Server_NPC_UpdateTimeWindowVisibility",
{
	private _npc = param [0, objNull];
	
	if (isNull _npc) exitWith {};
	
	private _shouldBeVisible = [_npc] call Server_NPC_CheckTimeWindow;
	private _isCurrentlyVisible = !(isObjectHidden _npc);
	private _npcPath = _npc getVariable ["A3PL_NPC_PatrolPath", []];
	private _npcID = _npc getVariable ["A3PL_NPC_ID_Config", ""];
	private _currentTime = date select 3;
	private _timeWindow = _npc getVariable ["A3PL_NPC_TimeWindow", []];
	
	if (_shouldBeVisible && !_isCurrentlyVisible) then {
		if (!alive _npc) then {
			diag_log format["[A3PL_NPC] ERROR: NPC %1 is not alive, cannot make visible", _npcID];
		} else {
			_npc hideObjectGlobal false;
			_npc enableSimulationGlobal true;
			
			_npc setVariable ["A3PL_NPC_Visible", true, true];
			
			private _npcConfig = [];
			{
				if ((_x select 0) == _npcID) exitWith {
					_npcConfig = _x;
				};
			} forEach Config_NPC_Spawn;
			
			if (count _npcConfig > 2) then {
				private _spawnPos = _npcConfig select 2;
				if (count _spawnPos >= 3) then {
					private _pos = [_spawnPos select 0, _spawnPos select 1, _spawnPos select 2];
					_npc setPosATL _pos;
					if (count _spawnPos >= 4) then {
						_npc setDir (_spawnPos select 3);
					};
				};
			};
			
			private _isHiddenAfter = isObjectHidden _npc;
			private _simEnabledAfter = simulationEnabled _npc;
			private _npcPos = getPosATL _npc;
			
		
			_npc allowDamage false;
			
			if (count _npcPath > 0) then {
				_npc enableAI "MOVE";
				_npc setSpeedMode "LIMITED";
				_npc setUnitPos "UP";
				_npc forceSpeed 1.5;
				[_npc, _npcPath] spawn A3PL_NPC_PatrolWaypoint;
			} else {
				_npc disableAI "MOVE";
			};
		};
	};
	
	if (!_shouldBeVisible && _isCurrentlyVisible) then {
		_npc hideObjectGlobal true;
		_npc enableSimulationGlobal false;
		_npc setVariable ["A3PL_NPC_IsPatrolling", false, false];
		doStop _npc;
		_npc disableAI "MOVE";
	};
}] call compile_Server;

["Server_NPC_UpdateTimeWindows",
{
	private _currentTime = date select 3;
	private _updatedCount = 0;
	{
		if (!isNull _x && alive _x) then {
			private _npcID = _x getVariable ["A3PL_NPC_ID_Config", ""];
			if (_npcID != "") then {
				[_x] call Server_NPC_UpdateTimeWindowVisibility;
				_updatedCount = _updatedCount + 1;
			};
		};
	} forEach allUnits;
	
}] call compile_Server;

["Server_NPC_LoadAutoSpawn",
{
	{
		private _npcConfig = _x;
		private _npcID = _npcConfig#0;
		private _autoSpawn = if (count _npcConfig > 13) then {_npcConfig#13} else {0};
		
		if (_autoSpawn == 1) then {
			private _npc = [_npcID] call Server_NPC_Create;
			if (!isNull _npc) then {
				[_npc] call Server_NPC_UpdateTimeWindowVisibility;
				private _isVisible = !(isObjectHidden _npc);
			};
		};
	} forEach Config_NPC_Spawn;
}] call compile_Server;

["Server_NPC_EnableMove",
{
	private _npc = param [0, objNull];
	if (isNull _npc) exitWith {};
	_npc enableAI "MOVE";
}] call compile_Server;

["Server_NPC_EnableSimulation",
{
	private _npc = param [0, objNull];
	if (isNull _npc) exitWith {};
	_npc enableSimulationGlobal true;
}] call compile_Server;

["Server_NPC_EnableHookerMove",
{
	private _npc = param [0, objNull];
	diag_log format["[Server_NPC] EnableHookerMove called with NPC: %1", _npc];
	if (isNull _npc) exitWith {};
	
	_npc setVariable ["A3PL_NPC_IsPatrolling", false, true];
	_npc setVariable ["A3PL_NPC_PatrolPath", [], true];
	doStop _npc;
	
	_npc enableAI "MOVE";
	_npc enableAI "FSM";
	_npc enableSimulationGlobal true;
	_npc setUnitPos "UP";
	_npc setSpeedMode "LIMITED";
	_npc forceSpeed -1;
	
	private _group = group _npc;
	_group setBehaviour "CARELESS";
	_group setCombatMode "BLUE";
	_group setSpeedMode "LIMITED";
	
}] call compile_Server;

["Server_NPC_HookerMoveTo",
{
	private _npc = param [0, objNull];
	private _targetPos = param [1, []];
	
	if (isNull _npc || count _targetPos < 3) exitWith {};
	
	_npc doMove _targetPos;
	_npc commandMove _targetPos;
	_npc moveTo _targetPos;
	
}] call compile_Server;

["Server_NPC_AddReputation",
{
	private _charID = param [0, ""];
	private _npcConfigID = param [1, ""];
	private _amount = param [2, 0];
	private _player = param [3, objNull];
	
	if (_charID == "" || _npcConfigID == "" || isNull _player) exitWith {};
	
	private _query = format ["INSERT INTO npc_reputation (charid, npc_name, reputation) VALUES ('%1', '%2', %3) ON DUPLICATE KEY UPDATE reputation = reputation + %3", _charID, _npcConfigID, _amount];
	[_query, 1] spawn Server_Database_Async;
	
	private _getRepQuery = format ["SELECT reputation FROM npc_reputation WHERE charid='%1' AND npc_name='%2'", _charID, _npcConfigID];
	private _result = [_getRepQuery, 2] call Server_Database_Async;

	private _newReputation = 0;
	if (count _result > 0) then {
		_newReputation = (_result select 0) select 0;
	};

	[_newReputation, _charID, _npcConfigID] remoteExec ["A3PL_NPC_SetReputation", _player];
}] call compile_Server;

["Server_NPC_GetReputation",
{
	private _charID = param [0, ""];
	private _npcConfigID = param [1, ""];
	private _player = param [2, objNull];
	private _npcName = param [3, ""];
	
	if (_charID == "" || _npcConfigID == "" || isNull _player) exitWith {};
	
	private _reputation = 0;
	
	private _query = format ["SELECT reputation FROM npc_reputation WHERE charid='%1' AND npc_name='%2'", _charID, _npcConfigID];
	private _result = [_query, 2] call Server_Database_Async;

	if (count _result > 0) then {
		_reputation = (_result select 0) select 0;
	} else {
		if (_npcName != "") then {
			_query = format ["SELECT reputation FROM npc_reputation WHERE charid='%1' AND npc_name='%2'", _charID, _npcName];
			_result = [_query, 2] call Server_Database_Async;


			if (count _result > 0) then {
				_reputation = (_result select 0) select 0;
				private _migrateQuery = format ["UPDATE npc_reputation SET npc_name='%1' WHERE charid='%2' AND npc_name='%3'", _npcConfigID, _charID, _npcName];
				[_migrateQuery, 1] spawn Server_Database_Async;
			};
		};
	};
	
	[_reputation, _charID, _npcConfigID] remoteExec ["A3PL_NPC_SetReputation", _player];
}] call compile_Server;