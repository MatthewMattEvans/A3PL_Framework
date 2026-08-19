/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["Server_JobRoadWorker_Mark",
{
	private _veh = param [0,objNull];
	private _durationMinutes = param [1,0];
	if (isNull _veh) exitwith {};
	_veh setVariable ["impound",true,true];
	_veh setVariable ["impound_duration",_durationMinutes,true];
	private _roadcompany = [("STR_Common_Company" call A3PL_Localize),true] call A3PL_Lib_FactionPlayers;
	Server_JobRoadWorker_Marked pushback _veh;
	publicVariable "Server_JobRoadWorker_Marked";

	[_veh] remoteExec ["A3PL_JobRoadWorker_MarkResponse", _roadcompany];
}] call compile_Server;

["Server_JobRoadWorker_UnMark",
{
	private _veh = param [0,objNull];
	if (isNull _veh) exitwith {};
	_veh setVariable ["impound",nil,true];
	if (_veh IN Server_JobRoadWorker_Marked) then {
		Server_JobRoadWorker_Marked = Server_JobRoadWorker_Marked - [_veh];
		publicVariable "Server_JobRoadWorker_Marked";
	};
}] call compile_Server;

["Server_JobRoadWorker_Impound",
{
	private _veh = param [0,objNull];
	private _player = param [1,objNull];
	
	if (isNull _veh || isNull _player) exitWith {};
	if (!alive _veh) exitWith {
		[("STR_Server_Job_Roadworker_VehicleDestroyed" call A3PL_Localize),Color_Red] remoteExec ["A3PL_Notification",_player];
	};
	
	private _owner = _veh getVariable ["owner",[]];
	if (count _owner == 0) exitWith {
		[("STR_Server_Job_Roadworker_NoOwner" call A3PL_Localize),Color_Red] remoteExec ["A3PL_Notification",_player];
	};
	
	if ((_owner select 0) isEqualTo (_player getVariable ["character_id",""])) exitWith {
		[("STR_Server_Job_Roadworker_CantImpoundYourCar" call A3PL_Localize),Color_Red] remoteExec ["A3PL_Notification",_player];
	};
	
	if (!(_veh getVariable ["impound",false])) exitWith {
		[("STR_Server_Job_Roadworker_VehicleNotMarked" call A3PL_Localize),Color_Red] remoteExec ["A3PL_Notification",_player];
	};
	if (!(_veh IN Server_JobRoadWorker_Marked)) exitWith {
		[("STR_Server_Job_Roadworker_VehicleNotInList" call A3PL_Localize),Color_Red] remoteExec ["A3PL_Notification",_player];
	};
	
	private _vehPrice = [typeOF _veh] call A3PL_Config_GetVehicleMSRP;
	if (_vehPrice <= 0) exitWith {
		[("STR_Server_Job_Roadworker_InvalidVehicle" call A3PL_Localize),Color_Red] remoteExec ["A3PL_Notification",_player];
	};
	
	private _amount = if (_vehPrice < 160000) then {_vehPrice * 0.3} else {_vehPrice * 0.2};
	if (_amount < 10000) then {_amount = 10000;};
	private _cash = round (_amount * A3PL_Event_Paycheck);

	[format[("STR_Server_Job_Roadworker_BonusReceived" call A3PL_Localize),_cash],Color_Green] remoteExec ["A3PL_Notification",_player];
	[_player,"Player_Cash",((_player getVariable ["player_cash",0]) + _cash)] call Server_Core_ChangeVar;

	private _stockobj = _veh getVariable ["stockobj",nil];
	private _plate = _veh getVariable ["owner",[]];
	if !(isNil "_stockobj") then {
		private _vehicles = [format ["SELECT vehicles FROM stock WHERE classname='%1'",_stockobj], 2,true] call Server_Database_Async;
		_vehicles = _vehicles#0#0;
		private _vehicle = "";
		private _index = -1;
		{
			_index = _index + 1;
			private _vars = _x#6;
			private _selplate = "";
			{
				if (_x#0 isEqualTo "plate") then {
					_selplate = _x#1;
				};
			} forEach _vars;

			if (_selplate isEqualTo _plate#1) exitWith {
				_vehicle = _x;
			};
		} forEach _vehicles;

		_vehicle set [1,1];
		_vehicles set [_index,_vehicle];

		[_veh] call Server_Vehicle_Sell;
		["vehicles",_vehicles,_stockobj] call Server_Stock_UpdateItems;
	} else {
		[_veh] call Server_Police_Impound;
	};

	_veh setVariable ["impound",nil,true];
	_veh setVariable ["impound_duration",nil,true];
	if (_veh IN Server_JobRoadWorker_Marked) then {
		Server_JobRoadWorker_Marked = Server_JobRoadWorker_Marked - [_veh];
		publicVariable "Server_JobRoadWorker_Marked";
	};
}] call compile_Server;

["Server_JobRoadWorker_GetImpounded",
{
	private _player = param [0,objNull];
	if (isNull _player) exitWith {};
	private _query = "SELECT id,class,customName,fuel,impound_timestamp,impound_duration FROM players_objects WHERE plystorage = '1' AND impounded = '1'";
	private _objects = [_query, 2, true] call Server_Database_Async;
	private _returnArray = [];
	{
		private _id = _x select 0;
		private _class = _x select 1;
		private _customName = _x select 2;
		private _fuel = _x select 3;
		private _impoundTimestamp = _x select 4;
		private _impoundDuration = _x select 5;
		_returnArray pushBack [_id,_class,_customName,_fuel,_impoundTimestamp,_impoundDuration];
	} forEach _objects;
	[_returnArray] remoteExec ["A3PL_JobRoadWorker_ImpoundListReceive",_player];
}] call compile_Server;

["Server_JobRoadWorker_ReleaseVehicle",
{
	private _player = param [0,objNull];
	private _vehicleId = param [1,""];
	private _class = param [2,""];
	private _payEarly = param [3,false];
	if (isNull _player || _vehicleId isEqualTo "") exitWith {};

	private _db = [format ["SELECT impound_timestamp,impound_duration,charid FROM players_objects WHERE id = '%1' AND impounded = '1'",_vehicleId], 2, false] call Server_Database_Async;
	if (count _db < 2) exitWith {
		[("STR_Server_Job_Roadworker_ImpoundNotFound" call A3PL_Localize),Color_Red] remoteExec ["A3PL_Notification",_player];
	};
	private _impoundTimestamp = _db select 0;
	private _impoundDuration = _db select 1;
	private _ownerCid = _db select 2;
	private _nowQuery = ["SELECT UNIX_TIMESTAMP()", 2, false] call Server_Database_Async;
	private _now = _nowQuery select 0;
	private _elapsedMinutes = (_now - _impoundTimestamp) / 60;
	private _remainingMinutes = _impoundDuration - _elapsedMinutes;

	if (_remainingMinutes > 0 && !_payEarly) exitWith {
		[format [("STR_Server_Job_Roadworker_StillImpounded" call A3PL_Localize),round _remainingMinutes],Color_Red] remoteExec ["A3PL_Notification",_player];
	};

	if (_remainingMinutes > 0 && _payEarly) exitWith {
		private _vehPrice = [_class] call A3PL_Config_GetVehicleMSRP;
		private _remainingDays = (_remainingMinutes / 1440) max 0.01;
		private _dailyPercent = Impound_DailyPercent / 100;
		private _maxPercent = Impound_MaxPercent / 100;
		private _percent = (_dailyPercent * _remainingDays) min _maxPercent;
		private _cost = round (_vehPrice * _percent);
		private _playerCash = _player getVariable ["player_cash",0];
		private _playerBank = _player getVariable ["player_bank",0];
		private _totalFunds = _playerCash + _playerBank;
		if (_totalFunds < _cost) exitWith {
			[format [("STR_Server_Job_Roadworker_NotEnoughMoney" call A3PL_Localize),_cost],Color_Red] remoteExec ["A3PL_Notification",_player];
		};
		if (_playerBank >= _cost) then {
			[_player,"player_bank",_playerBank - _cost] call Server_Core_ChangeVar;
		} else {
			private _remainder = _cost - _playerBank;
			[_player,"player_bank",0] call Server_Core_ChangeVar;
			[_player,"Player_Cash",_playerCash - _remainder] call Server_Core_ChangeVar;
		};
		[format [("STR_Server_Job_Roadworker_PaidEarlyRelease" call A3PL_Localize),_cost],Color_Green] remoteExec ["A3PL_Notification",_player];
		[_player,_vehicleId,_class,_ownerCid] call Server_JobRoadWorker_SpawnImpounded;
		[("STR_Server_Job_Roadworker_VehicleReleased" call A3PL_Localize),Color_Green] remoteExec ["A3PL_Notification",_player];
	};

	[_player,_vehicleId,_class,_ownerCid] call Server_JobRoadWorker_SpawnImpounded;
	["Vehicle released from impound",Color_Green] remoteExec ["A3PL_Notification",_player];
}] call compile_Server;

["Server_JobRoadWorker_SpawnImpounded",
{
	private _player = param [0,objNull];
	private _vehicleId = param [1,""];
	private _class = param [2,""];
	private _ownerCid = param [3,""];

	[format ["UPDATE players_objects SET plystorage = '0',impounded='0',spawn='1',impound_timestamp=0,impound_duration=0 WHERE id = '%1'",_vehicleId],1] spawn Server_Database_Async;

	diag_log format ["[Impound] Release %1 | ownerCid=%2 | roadworker=%3",_vehicleId,_ownerCid,_player getVariable ["character_id",""]];

	private _owner = [_ownerCid] call A3PL_Lib_charIDToObject;
	private _keyRecipient = if (!isNull _owner) then {_owner} else {objNull};

	diag_log format ["[Impound] Owner found: %1 | keyRecipient: %2",!isNull _owner,_keyRecipient];

	private _nearBuildings = nearestObjects [getPosATL _player, ["Land_A3PL_Impound"], 30];
	private _spawnPos = [];
	if (count _nearBuildings > 0) then {
		_spawnPos = (_nearBuildings select 0) modelToWorld [0.391113,0.787537,-1.50864];
	} else {
		_spawnPos = (getPosATL _player) findEmptyPosition [3,50,_class];
		if (count _spawnPos isEqualTo 0) then {_spawnPos = getPosATL _player;};
	};

	diag_log format ["[Impound] SpawnPos: %1 | nearBuilding: %2",_spawnPos,count _nearBuildings > 0];

	[_class,_player,_vehicleId,_spawnPos,_keyRecipient] call Server_Storage_RetrieveVehicle;

	private _veh = objNull;
	{
		private _ow = _x getVariable ["owner",[]];
		if (count _ow >= 2 && {(_ow select 1) isEqualTo _vehicleId}) exitWith {_veh = _x;};
	} forEach vehicles;
	if (!isNull _veh) then {
		_veh setVariable ["owner",[_ownerCid,_vehicleId],true];
		diag_log format ["[Impound] Fixed owner on vehicle %1",_vehicleId];
	} else {
		diag_log format ["[Impound] WARNING: Could not find spawned vehicle %1",_vehicleId];
	};
}] call compile_Server;
