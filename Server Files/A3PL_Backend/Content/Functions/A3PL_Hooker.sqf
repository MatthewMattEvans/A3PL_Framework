/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/

["A3PL_Hooker_Follow", {
	if (isNil "Player_Hooker" || {isNull Player_Hooker}) exitWith {
		diag_log "[A3PL_Hooker] Follow: Player_Hooker is nil or null";
	};
	
	private _hooker = Player_Hooker;
	private _owner = Player_Hooker_Owner;
	
	diag_log format["[A3PL_Hooker] Follow: Starting follow for %1, owner: %2", _hooker, _owner];
	
	_hooker setVariable ["A3PL_NPC_IsPatrolling", false, true];
	_hooker setVariable ["A3PL_NPC_PatrolPath", [], true];
	doStop _hooker;
	
	diag_log "[A3PL_Hooker] Follow: Calling Server_NPC_EnableHookerMove";
	[_hooker] remoteExec ["Server_NPC_EnableHookerMove", 2];
	
	uiSleep 0.8;
	
	diag_log format["[A3PL_Hooker] Follow: After sleep, MOVE enabled: %1", _hooker checkAIFeature "MOVE"];
	
	_hooker enableAI "MOVE";
	_hooker enableAI "FSM";
	_hooker enableSimulation true;
	_hooker setUnitPos "UP";
	_hooker setSpeedMode "LIMITED";
	_hooker forceSpeed 1.0;
	
	private _group = group _hooker;
	_group setBehaviour "CARELESS";
	_group setCombatMode "BLUE";
	_group setSpeedMode "LIMITED";
	
	[_group, owner _owner] remoteExec ["setGroupOwner", 2];
	
	uiSleep 0.2;
	
	_group setGroupOwner (owner _owner);
	
	private _targetPos = getPosATL _owner;
	[_hooker, _targetPos] remoteExec ["Server_NPC_HookerMoveTo", 2];
	_hooker doMove _targetPos;
	_hooker commandMove _targetPos;
	_hooker moveTo _targetPos;
	
	uiSleep 0.5;
	
	while {!isNull _hooker && {alive _hooker} && {!Player_Hooker_IsStopped} && {!Player_Hooker_IsArrested}} do {
		if (isNull _owner || {!alive _owner}) exitWith {
			[] call A3PL_Hooker_Release;
		};

		_hooker enableAI "MOVE";
		_hooker enableAI "FSM";
		_hooker enableSimulation true;
		_hooker setUnitPos "UP";
		_hooker forceSpeed 1.0;
		
		if (vehicle _owner != _owner) then {
			private _veh = vehicle _owner;
			
			if (vehicle _hooker == _hooker) then {
				_hooker assignAsCargo _veh;
				_hooker moveInCargo _veh;
				_hooker doMove (getPosATL _veh);
			};
		} else {
			if (vehicle _hooker != _hooker) then {
				private _vehHooker = vehicle _hooker;
				_hooker action ["Eject", _vehHooker];
				unassignVehicle _hooker;
				moveOut _hooker;
				_hooker leaveVehicle _vehHooker;
			};

			private _distance = _hooker distance _owner;
			private _targetPos = getPosATL _owner;
			
			if (_distance > 0.8) then {
				_hooker doMove _targetPos;
				_hooker commandMove _targetPos;
				_hooker moveTo _targetPos;
				[_hooker, _targetPos] remoteExec ["Server_NPC_HookerMoveTo", 2];
			} else {
				if (_distance < 0.3) then {
					doStop _hooker;
				};
			};
		};
		
		uiSleep 0.3;
	};
}] call compile_Global;

["A3PL_Hooker_Stop", {
	if (isNil "Player_Hooker" || {isNull Player_Hooker}) exitWith {
		[("STR_A3PL_Hooker_NoHooker" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	
	if (Player_Hooker_IsStopped) exitWith {
		[("STR_A3PL_Hooker_AlreadyStopped" call A3PL_Localize), Color_Orange] call A3PL_Notification;
	};
	
	Player_Hooker_IsStopped = true;
	Player_Hooker setVariable ["A3PL_Hooker_IsStopped", true, true];
	doStop Player_Hooker;
	
	[("STR_A3PL_Hooker_Stopped" call A3PL_Localize), Color_Orange] call A3PL_Notification;
}] call compile_Global;

["A3PL_Hooker_Resume", {
	if (isNil "Player_Hooker" || {isNull Player_Hooker}) exitWith {
		[("STR_A3PL_Hooker_NoHooker" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	
	if (!Player_Hooker_IsStopped) exitWith {
		[("STR_A3PL_Hooker_NotStopped" call A3PL_Localize), Color_Orange] call A3PL_Notification;
	};
	
	Player_Hooker_IsStopped = false;
	Player_Hooker setVariable ["A3PL_Hooker_IsStopped", false, true];

	// Arrêter le mode travail et délier le sex client
	if (Player_Hooker getVariable ["A3PL_Hooker_IsWorking", false]) then {
		Player_Hooker setVariable ["A3PL_Hooker_IsWorking", false, true];
	};
	Player_Hooker setVariable ["A3PL_NPC_SexClient", nil, true];

	// Arrêter la génération d'argent
	if (!isNil "Player_Hooker_IsGeneratingMoney" && {Player_Hooker_IsGeneratingMoney}) then {
		if (!isNil "Player_Hooker_MoneyGenerationLoop") then {
			terminate Player_Hooker_MoneyGenerationLoop;
		};
		Player_Hooker_IsGeneratingMoney = false;
	};

	// Reprendre le suivi
	[] spawn A3PL_Hooker_Follow;
	
	[("STR_A3PL_Hooker_Resumed" call A3PL_Localize), Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Hooker_StartMoneyGeneration", {
	if (Player_Hooker_IsGeneratingMoney) exitWith {};
	
	Player_Hooker_IsGeneratingMoney = true;
	Player_Hooker_MoneyGenerationLoop = [] spawn {
		while {Player_Hooker_IsGeneratingMoney && {!isNil "Player_Hooker"} && {!isNull Player_Hooker} && {alive Player_Hooker} && {Player_Hooker_IsStopped} && {!Player_Hooker_IsArrested}} do {
			// Vérifier si le joueur est toujours près de la hooker (20m)
			private _distance = player distance Player_Hooker;
			if (_distance > Hooker_MoneyRadius) exitWith {
				Player_Hooker_IsGeneratingMoney = false;
				[("STR_A3PL_Hooker_TooFarAway" call A3PL_Localize), Color_Orange] call A3PL_Notification;
			};
			
			// Vérifier si on est toujours près d'un motel
			private _nearMotel = false;
			{
				if ((typeOf _x) == "Land_A3PL_Motel") then {
					if ((player distance _x) < Hooker_MotelRadius) then {
						_nearMotel = true;
					};
				};
			} forEach nearestObjects [player, ["House"], Hooker_MotelRadius];
			
			if (!_nearMotel) exitWith {
				Player_Hooker_IsGeneratingMoney = false;
				[("STR_A3PL_Hooker_NotNearMotel" call A3PL_Localize), Color_Orange] call A3PL_Notification;
			};
			
			// Vérifier si le NPC client est toujours à proximité (3m)
			private _sexClient = Player_Hooker getVariable ["A3PL_NPC_SexClient", objNull];
			if (!isNull _sexClient) then {
				private _clientDistance = Player_Hooker distance _sexClient;
				if (_clientDistance > 3 || !alive _sexClient) exitWith {
					Player_Hooker_IsGeneratingMoney = false;
					Player_Hooker setVariable ["A3PL_NPC_SexClient", nil, true];
					[("STR_A3PL_NPC_SexClientLeft" call A3PL_Localize), Color_Orange] call A3PL_Notification;
				};
				
				private _playerDistance = player distance _sexClient;
				if (_playerDistance > 5) exitWith {
					Player_Hooker_IsGeneratingMoney = false;
					Player_Hooker setVariable ["A3PL_NPC_SexClient", nil, true];
					[("STR_A3PL_NPC_SexPlayerTooFar" call A3PL_Localize), Color_Orange] call A3PL_Notification;
				};
			};
			
			// 3% de chance que le FISD soit prévenu
			if ((random 100) < Hooker_ChancesToCallPolice) then {
				private _namePos = [getPos player] call A3PL_Housing_PosAddress;
				[("STR_Common_FISD" call A3PL_Localize),("STR_A3PL_Hooker_DispatchTitle" call A3PL_Localize),getPos player,format[("STR_A3PL_Hooker_DispatchMessage" call A3PL_Localize),_namePos],("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
			};
			
			// Générer l'argent (50$ par minute = 50$ toutes les 60 secondes)
			uiSleep 60;
			
			if (Player_Hooker_IsGeneratingMoney && {!isNil "Player_Hooker"} && {!isNull Player_Hooker} && {alive Player_Hooker}) then {
				private _currentMoney = player getVariable ["Player_Cash", 0];
				player setVariable ["Player_Cash", _currentMoney + Hooker_MoneyPerMinute, true];
				[format[("STR_A3PL_Hooker_MoneyEarned" call A3PL_Localize), Hooker_MoneyPerMinute], Color_Green] call A3PL_Notification;
			};
		};
		
		Player_Hooker_IsGeneratingMoney = false;
	};
}] call compile_Global;

["A3PL_Hooker_StartWork", {
	private _hooker = Player_Hooker;

	if (isNull _hooker) exitWith {
		[("STR_A3PL_Hooker_NoHooker" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};

	if (!(_hooker getVariable ["A3PL_NPC_Hooker_Active", false])) exitWith {
		[("STR_A3PL_Hooker_NotAHooker" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};

	if ((_hooker getVariable ["A3PL_NPC_Hooker_Owner", objNull]) != player) exitWith {
		[("STR_A3PL_Hooker_NotYourHooker" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};

	if (_hooker getVariable ["A3PL_Hooker_IsWorking", false]) exitWith {
		[("STR_A3PL_Hooker_AlreadyWorking" call A3PL_Localize), Color_Orange] call A3PL_Notification;
	};

	private _sexClient = _hooker getVariable ["A3PL_NPC_SexClient", objNull];
	if (isNull _sexClient) exitWith {
		[("STR_A3PL_Hooker_NoSexClient" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};

	if ((_hooker distance _sexClient) > 3) exitWith {
		[("STR_A3PL_Hooker_SexClientTooFar" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};

	_hooker setVariable ["A3PL_Hooker_IsWorking", true, true];

	[("STR_A3PL_Hooker_WorkStarted" call A3PL_Localize), Color_Green] call A3PL_Notification;

	[_hooker, _sexClient] spawn {
		params ["_hooker", "_sexClient"];

		private _paymentCount = 0;
		private _maxPayments = 6;

		while {_paymentCount < _maxPayments && {!isNull _hooker} && {alive _hooker} && {!isNull _sexClient} && {alive _sexClient} && {(_hooker getVariable ["A3PL_Hooker_IsWorking", false])}} do {
			private _clientDistance = _hooker distance _sexClient;
			if (_clientDistance > 3) exitWith {
				_hooker setVariable ["A3PL_Hooker_IsWorking", false, true];
				[("STR_A3PL_Hooker_SexClientLeft" call A3PL_Localize), Color_Orange] call A3PL_Notification;
			};

			private _playerDistance = player distance _hooker;
			if (_playerDistance > Hooker_MoneyRadius) exitWith {
				_hooker setVariable ["A3PL_Hooker_IsWorking", false, true];
				[("STR_A3PL_Hooker_TooFarAway" call A3PL_Localize), Color_Orange] call A3PL_Notification;
			};

			if ((random 100) < Hooker_ChancesToCallPolice) then {
				private _namePos = [getPos player] call A3PL_Housing_PosAddress;
				[("STR_Common_FISD" call A3PL_Localize),("STR_A3PL_Hooker_DispatchTitle" call A3PL_Localize),getPos player,format[("STR_A3PL_Hooker_DispatchMessage" call A3PL_Localize),_namePos],("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
			};

			uiSleep 60;

			if (!isNull _hooker && {alive _hooker} && {(_hooker getVariable ["A3PL_Hooker_IsWorking", false])}) then {
				_paymentCount = _paymentCount + 1;
				private _currentMoney = player getVariable ["Player_Cash", 0];
				player setVariable ["Player_Cash", _currentMoney + Hooker_MoneyPerMinute, true];
				[format[("STR_A3PL_Hooker_MoneyEarned" call A3PL_Localize), Hooker_MoneyPerMinute] + format [" (%1/%2)", _paymentCount, _maxPayments], Color_Green] call A3PL_Notification;
			};
		};

		_hooker setVariable ["A3PL_Hooker_IsWorking", false, true];

		if (_paymentCount >= _maxPayments) then {
			if (!isNull _sexClient && {alive _sexClient}) then {
				_hooker setVariable ["A3PL_NPC_SexClient", nil, true];

				if (!isNil "Player_NPC_SexClient" && {Player_NPC_SexClient == _sexClient}) then {
					[_sexClient] spawn A3PL_NPC_SexClient_Release;
				} else {
					[_sexClient] call A3PL_NPC_Delete;
					private _npcID = _sexClient getVariable ["A3PL_NPC_ID_Config", ""];
					if (_npcID != "") then {
						uiSleep 0.5;
						[_npcID] call A3PL_NPC_Create;
					};
				};

				[("STR_A3PL_Hooker_WorkFinished" call A3PL_Localize), Color_Green] call A3PL_Notification;
			};
		};
	};
}] call compile_Global;

["A3PL_Hooker_Arrest", {
	private _hooker = Player_ObjIntersect;
	
	if (isNull _hooker) exitWith {};
	
	// Vérifier si c'est une hooker NPC
	if (!(_hooker getVariable ["A3PL_NPC_Hooker_Active", false])) exitWith {
		[("STR_A3PL_Hooker_NotAHooker" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	
	// Vérifier si le joueur est FISD
	private _job = player getVariable ["job", ""];
	if (_job != ("STR_Common_FISD" call A3PL_Localize)) exitWith {
		[("STR_A3PL_Hooker_NotFISD" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	
	// Vérifier si la hooker est déjà arrêtée
	if (_hooker getVariable ["A3PL_Hooker_IsArrested", false]) exitWith {
		[("STR_A3PL_Hooker_AlreadyArrested" call A3PL_Localize), Color_Orange] call A3PL_Notification;
	};
	
	// Arrêter la hooker
	_hooker setVariable ["A3PL_Hooker_IsArrested", true, true];
	_hooker setVariable ["A3PL_Hooker_ArrestedBy", player, true];
	
	// Si c'est la hooker du joueur actuel
	private _owner = _hooker getVariable ["A3PL_NPC_Hooker_Owner", objNull];
	if (!isNull _owner) then {
		// Notifier le propriétaire
		[("STR_A3PL_Hooker_ArrestedByFISD" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _owner];
		
		// Si c'est le joueur actuel qui possède la hooker
		if (_owner == player) then {
			Player_Hooker_IsArrested = true;
			Player_Hooker_ArrestedBy = player;
			
			// Arrêter la génération d'argent
			if (Player_Hooker_IsGeneratingMoney) then {
				terminate Player_Hooker_MoneyGenerationLoop;
				Player_Hooker_IsGeneratingMoney = false;
			};
			
			// Arrêter le suivi
			Player_Hooker_IsStopped = true;
		};
	};
	
	// Faire suivre le FISD
	[_hooker, player] spawn {
		params ["_hooker", "_fisd"];
		
		if (isNull _hooker || {isNull _fisd}) exitWith {};
		
		while {alive _hooker && {_hooker getVariable ["A3PL_Hooker_IsArrested", false]}} do {
			if (vehicle _fisd != _fisd) then {
				private _veh = vehicle _fisd;
				if (vehicle _hooker == _hooker) then {
					_hooker assignAsCargo _veh;
					_hooker moveInCargo _veh;
				};
			} else {
				if (vehicle _hooker != _hooker) then {
					_hooker action ["Eject", vehicle _hooker];
				};
				
				private _distance = _hooker distance _fisd;
				if (_distance > 5) then {
					_hooker doMove (getPosATL _fisd);
				} else {
					doStop _hooker;
				};
			};
			
			uiSleep 1;
		};
	};
	
	[("STR_A3PL_Hooker_Arrested" call A3PL_Localize), Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Hooker_Release", {
	if (isNil "Player_Hooker" || {isNull Player_Hooker}) exitWith {};
	
	// Supprimer la hooker
	deleteVehicle Player_Hooker;
	
	// Réinitialiser les variables
	Player_Hooker = nil;
	Player_Hooker_Owner = nil;
	Player_Hooker_IsStopped = false;
	Player_Hooker_IsArrested = false;
	Player_Hooker_ArrestedBy = nil;
	Player_Hooker_IsGeneratingMoney = false;
	
	if (!isNil "Player_Hooker_MoneyGenerationLoop") then {
		terminate Player_Hooker_MoneyGenerationLoop;
		Player_Hooker_MoneyGenerationLoop = nil;
	};
}] call compile_Global;

["A3PL_Hooker_ReleaseAtStation", {
	private _hooker = Player_ObjIntersect;
	
	if (isNull _hooker) exitWith {};
	
	// Vérifier si c'est une hooker NPC
	if (!(_hooker getVariable ["A3PL_NPC_Hooker_Active", false])) exitWith {
		[("STR_A3PL_Hooker_NotAHooker" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	
	// Vérifier si le joueur est FISD
	private _job = player getVariable ["job", ""];
	if (_job != ("STR_Common_FISD" call A3PL_Localize)) exitWith {
		[("STR_A3PL_Hooker_NotFISD" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	
	// Vérifier si la hooker est arrêtée
	if (!(_hooker getVariable ["A3PL_Hooker_IsArrested", false])) exitWith {
		[("STR_A3PL_Hooker_NotArrested" call A3PL_Localize), Color_Orange] call A3PL_Notification;
	};
	
	// Vérifier si on est près d'un poste FISD
	private _nearStation = false;
	{
		if ((typeOf _x) IN ["Land_Police_Headquarter", "Land_A3FL_SheriffPD", "Land_EC_SheriffHQ", "Land_A3PL_Sheriffpd"]) then {
			if ((player distance _x) < 30) then {
				_nearStation = true;
			};
		};
	} forEach nearestObjects [player, ["House"], 30];
	
	if (!_nearStation) exitWith {
		[("STR_A3PL_Hooker_NotNearStation" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	
	// Récupérer le propriétaire avant d'envoyer chez elle
	private _owner = _hooker getVariable ["A3PL_NPC_Hooker_Owner", objNull];
	
	// Envoyer la hooker chez elle
	[_hooker] call A3PL_Hooker_SendHome;
	
	[("STR_A3PL_Hooker_ReleasedAtStation" call A3PL_Localize), Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Hooker_WorkForMe",
{
	private _npc = if (!isNil "A3PL_NPC_CurrentNPC" && !isNull A3PL_NPC_CurrentNPC) then {A3PL_NPC_CurrentNPC} else {player_objintersect};
	
	if (isNull _npc) exitWith {};
	
	if (!isNil "Player_Hooker" && {!isNull Player_Hooker}) exitWith {
		[("STR_A3PL_Hooker_AlreadyHaveOne" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	
	private _fisdCount = count ([("STR_Common_FISD" call A3PL_Localize)] call A3PL_Lib_FactionPlayers);
	
	private _currentMoney = player getVariable ["Player_Cash", 0];
	if (_currentMoney < Hooker_Price) exitWith {
		[format[("STR_A3PL_Hooker_NotEnoughMoney" call A3PL_Localize), Hooker_Price], Color_Red] call A3PL_Notification;
	};
	
	private _npcType = typeOf _npc;
	private _npcName = name _npc;
	private _npcVoice = speaker _npc;
	private _npcUniform = uniform _npc;
	private _npcHeadgear = headgear _npc;
	private _npcGoggles = goggles _npc;
	private _npcVest = vest _npc;
	private _npcBackpack = backpack _npc;
	
	[_npc] call A3PL_NPC_Delete;
	
	uiSleep 0.5;
	
	private _group = createGroup [civilian, true];
	private _hooker = _group createUnit [_npcType, getPosATL player, [], 5, "NONE"];
	
	if (isNull _hooker) exitWith {
		[("STR_A3PL_Hooker_CreationFailed" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	
	_hooker setName _npcName;
	
	if (_npcVoice != "") then {
		_hooker setSpeaker _npcVoice;
	};
	
	if (_npcUniform != "") then {
		_hooker forceAddUniform _npcUniform;
	};
	
	if (_npcHeadgear != "") then {
		_hooker addHeadgear _npcHeadgear;
	};
	
	if (_npcGoggles != "") then {
		_hooker addGoggles _npcGoggles;
	};
	
	if (_npcVest != "") then {
		_hooker addVest _npcVest;
	};
	
	if (_npcBackpack != "") then {
		_hooker addBackpack _npcBackpack;
	};
	
	private _npcID = _npc getVariable ["A3PL_NPC_ID_Config", ""];
	
	_hooker setVariable ["A3PL_NPC_Hooker_Active", true, true];
	_hooker setVariable ["A3PL_NPC_Hooker_Mode", "work", true];
	_hooker setVariable ["A3PL_NPC_Hooker_Owner", player, true];
	_hooker setVariable ["A3PL_NPC_ID_Config", _npcID, true];
	_hooker setVariable ["A3PL_Hooker_Owner", player, true];
	_hooker setVariable ["A3PL_Hooker_IsStopped", false, true];
	_hooker setVariable ["A3PL_Hooker_IsArrested", false, true];
	_hooker setVariable ["A3PL_Hooker_ArrestedBy", nil, true];
	_hooker allowDamage false;
	_hooker disableAI "FSM";
	_hooker disableAI "AUTOTARGET";
	_hooker disableAI "TARGET";
	_hooker setBehaviour "CARELESS";
	_hooker setCombatMode "BLUE";
	
	player setVariable ["Player_Cash", _currentMoney - Hooker_Price, true];
	
	Player_Hooker = _hooker;
	Player_Hooker_Owner = player;
	Player_Hooker_IsStopped = false;
	Player_Hooker_IsArrested = false;
	
	[] spawn A3PL_Hooker_Follow;
	
	[format[("STR_A3PL_Hooker_Bought" call A3PL_Localize), Hooker_Price], Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Hooker_GoHome",
{
	private _npc = if (!isNil "A3PL_NPC_CurrentNPC" && !isNull A3PL_NPC_CurrentNPC) then {A3PL_NPC_CurrentNPC} else {player_objintersect};
	
	if (isNull _npc) exitWith {};
	
	if (!isNil "Player_Hooker" && {!isNull Player_Hooker}) exitWith {
		[("STR_A3PL_Hooker_AlreadyHaveOne" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	
	private _npcType = typeOf _npc;
	private _npcName = name _npc;
	private _npcVoice = speaker _npc;
	private _npcUniform = uniform _npc;
	private _npcHeadgear = headgear _npc;
	private _npcGoggles = goggles _npc;
	private _npcVest = vest _npc;
	private _npcBackpack = backpack _npc;
	private _npcID = _npc getVariable ["A3PL_NPC_ID_Config", ""];
	
	[_npc] call A3PL_NPC_Delete;
	
	uiSleep 0.5;
	
	private _group = createGroup [civilian, true];
	private _hooker = _group createUnit [_npcType, getPosATL player, [], 5, "NONE"];
	
	if (isNull _hooker) exitWith {
		[("STR_A3PL_Hooker_CreationFailed" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	
	_hooker setName _npcName;
	
	if (_npcVoice != "") then {
		_hooker setSpeaker _npcVoice;
	};
	
	if (_npcUniform != "") then {
		_hooker forceAddUniform _npcUniform;
	};
	
	if (_npcHeadgear != "") then {
		_hooker addHeadgear _npcHeadgear;
	};
	
	if (_npcGoggles != "") then {
		_hooker addGoggles _npcGoggles;
	};
	
	if (_npcVest != "") then {
		_hooker addVest _npcVest;
	};
	
	if (_npcBackpack != "") then {
		_hooker addBackpack _npcBackpack;
	};
	
	_hooker setVariable ["A3PL_NPC_Hooker_Active", true, true];
	_hooker setVariable ["A3PL_NPC_Hooker_Mode", "home", true];
	_hooker setVariable ["A3PL_NPC_Hooker_Owner", player, true];
	_hooker setVariable ["A3PL_NPC_ID_Config", _npcID, true];
	_hooker setVariable ["A3PL_Hooker_Owner", player, true];
	_hooker setVariable ["A3PL_Hooker_IsStopped", false, true];
	_hooker setVariable ["A3PL_Hooker_IsArrested", false, true];
	_hooker setVariable ["A3PL_Hooker_ArrestedBy", nil, true];
	_hooker allowDamage false;
	_hooker disableAI "FSM";
	_hooker disableAI "AUTOTARGET";
	_hooker disableAI "TARGET";
	_hooker setBehaviour "CARELESS";
	_hooker setCombatMode "BLUE";
	
	Player_Hooker = _hooker;
	Player_Hooker_Owner = player;
	Player_Hooker_IsStopped = false;
	Player_Hooker_IsArrested = false;
	
	[] spawn A3PL_Hooker_Follow;
	
	[("STR_A3PL_NPC_Hooker_GoHomeStarted" call A3PL_Localize), Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Hooker_InCar",
{
	private _npc = if (!isNil "A3PL_NPC_CurrentNPC" && !isNull A3PL_NPC_CurrentNPC) then {A3PL_NPC_CurrentNPC} else {player_objintersect};
	
	if (isNull _npc) exitWith {};
	
	if (!isNil "Player_Hooker" && {!isNull Player_Hooker}) exitWith {
		[("STR_A3PL_Hooker_AlreadyHaveOne" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	
	private _nearVehicles = nearestObjects [player, ["Car", "Truck", "Motorcycle"], 10];
	if (count _nearVehicles == 0) exitWith {
		[("STR_A3PL_NPC_Hooker_NoVehicleNearby" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	
	private _hookerPoints = Config_NPC_Hooker_CarPoints;
	
	if (isNil "_hookerPoints" || count _hookerPoints == 0) exitWith {
		[("STR_A3PL_NPC_Hooker_NoCarPoints" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	
	private _npcType = typeOf _npc;
	private _npcName = name _npc;
	private _npcVoice = speaker _npc;
	private _npcUniform = uniform _npc;
	private _npcHeadgear = headgear _npc;
	private _npcGoggles = goggles _npc;
	private _npcVest = vest _npc;
	private _npcBackpack = backpack _npc;
	private _npcID = _npc getVariable ["A3PL_NPC_ID_Config", ""];
	
	[_npc] call A3PL_NPC_Delete;
	
	uiSleep 0.5;
	
	private _group = createGroup [civilian, true];
	private _hooker = _group createUnit [_npcType, getPosATL player, [], 5, "NONE"];
	
	if (isNull _hooker) exitWith {
		[("STR_A3PL_Hooker_CreationFailed" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	
	_hooker setName _npcName;
	
	if (_npcVoice != "") then {
		_hooker setSpeaker _npcVoice;
	};
	
	if (_npcUniform != "") then {
		_hooker forceAddUniform _npcUniform;
	};
	
	if (_npcHeadgear != "") then {
		_hooker addHeadgear _npcHeadgear;
	};
	
	if (_npcGoggles != "") then {
		_hooker addGoggles _npcGoggles;
	};
	
	if (_npcVest != "") then {
		_hooker addVest _npcVest;
	};
	
	if (_npcBackpack != "") then {
		_hooker addBackpack _npcBackpack;
	};
	
	_hooker setVariable ["A3PL_NPC_Hooker_Active", true, true];
	_hooker setVariable ["A3PL_NPC_Hooker_Mode", "car", true];
	_hooker setVariable ["A3PL_NPC_Hooker_Owner", player, true];
	_hooker setVariable ["A3PL_NPC_ID_Config", _npcID, true];
	_hooker setVariable ["A3PL_Hooker_Owner", player, true];
	_hooker setVariable ["A3PL_Hooker_IsStopped", false, true];
	_hooker setVariable ["A3PL_Hooker_IsArrested", false, true];
	_hooker setVariable ["A3PL_Hooker_ArrestedBy", nil, true];
	_hooker allowDamage false;
	_hooker disableAI "FSM";
	_hooker disableAI "AUTOTARGET";
	_hooker disableAI "TARGET";
	_hooker setBehaviour "CARELESS";
	_hooker setCombatMode "BLUE";
	
	Player_Hooker = _hooker;
	Player_Hooker_Owner = player;
	Player_Hooker_IsStopped = false;
	Player_Hooker_IsArrested = false;
	
	private _markerName = format["hooker_car_%1_%2", time, random 10000];
	private _randomIndex = floor (random (count _hookerPoints));
	private _targetPoint = _hookerPoints select _randomIndex;
	
	private _marker = createMarker [_markerName, _targetPoint];
	_marker setMarkerType "hd_dot";
	_marker setMarkerColor "ColorPink";
	_marker setMarkerText ("STR_A3PL_NPC_Hooker_Destination" call A3PL_Localize);
	_marker setMarkerSize [0.8, 0.8];
	
	_hooker setVariable ["A3PL_NPC_Hooker_CarTarget", _targetPoint, true];
	_hooker setVariable ["A3PL_NPC_Hooker_CarMarker", _markerName, true];
	
	uiSleep 0.2;
	
	[] spawn A3PL_Hooker_Follow;
	
	[_hooker, player, _targetPoint, _markerName] spawn {
		params ["_npc", "_owner", "_targetPoint", "_markerName"];
		private _waitingForEngineOff = false;
		private _vehicle = objNull;
		
		while {!isNull _npc && alive _npc && (_npc getVariable ["A3PL_NPC_Hooker_Active", false]) && (_npc getVariable ["A3PL_NPC_Hooker_Mode", ""]) == "car"} do {
			if (isNull _owner || !alive _owner) exitWith {
				deleteMarker _markerName;
				[_npc] call A3PL_Hooker_SendHome;
			};
			
			if (Player_Hooker_IsStopped || Player_Hooker_IsArrested) exitWith {
				deleteMarker _markerName;
				[_npc] call A3PL_Hooker_SendHome;
			};
			
			private _currentVehicle = vehicle _owner;
			
			if (_currentVehicle != _owner) then {
				if (isNull _vehicle) then {
					_vehicle = _currentVehicle;
					[("STR_A3PL_NPC_Hooker_InCarStarted" call A3PL_Localize), Color_Green] call A3PL_Notification;
				} else {
					if (_currentVehicle != _vehicle) then {
						deleteMarker _markerName;
						[_npc] call A3PL_Hooker_SendHome;
						break;
					};
				};
				
				if (!_waitingForEngineOff) then {
					private _distanceToPoint = _vehicle distance _targetPoint;
					
					if (_distanceToPoint < 20) then {
						deleteMarker _markerName;
						_waitingForEngineOff = true;
						[("STR_A3PL_NPC_Hooker_TurnOffEngine" call A3PL_Localize), Color_Yellow] call A3PL_Notification;
						
						while {_waitingForEngineOff && isEngineOn _vehicle && !isNull _npc && alive _npc && (_npc getVariable ["A3PL_NPC_Hooker_Active", false]) && (_npc getVariable ["A3PL_NPC_Hooker_Mode", ""]) == "car"} do {
							if (isNull _owner || !alive _owner || vehicle _owner != _vehicle) exitWith {
								_waitingForEngineOff = false;
								[_npc] call A3PL_Hooker_SendHome;
							};
							uiSleep 0.5;
						};
						
						if (_waitingForEngineOff && !isEngineOn _vehicle) then {
							_waitingForEngineOff = false;
							
							[_npc, _vehicle] spawn {
								params ["_npc", "_vehicle"];
								
								disableUserInput true;
								cameraEffectEnableHUD true;
								cutText ["", "BLACK OUT", 0.5];
								
								uiSleep 0.5;
								
								private _headPos = _npc selectionPosition "head";
								private _worldHeadPos = _npc modelToWorld _headPos;
								
								playSound3D ["A3PL_Common\sounds\blowjob.ogg", _npc, false, _worldHeadPos, 1, 1, 0];
								
								uiSleep 10;
								
								cutText ["", "BLACK IN", 0.5];
								disableUserInput false;
								
								[("STR_A3PL_Hooker_BlowjobFinished" call A3PL_Localize), Color_Green] call A3PL_Notification;
								
								[_npc] call A3PL_Hooker_SendHome;
							};
							
							break;
						};
					};
				};
			} else {
				if (!isNull _vehicle) then {
					deleteMarker _markerName;
					[_npc] call A3PL_Hooker_SendHome;
					break;
				};
			};
			
			uiSleep 1;
		};
		
		deleteMarker _markerName;
	};
}] call compile_Global;

["A3PL_Hooker_SendHome",
{
	private _npc = param [0, objNull];
	
	if (isNull _npc) exitWith {};
	
	if (!(_npc getVariable ["A3PL_NPC_Hooker_Active", false])) exitWith {};
	
	private _npcID = _npc getVariable ["A3PL_NPC_ID_Config", ""];
	if (_npcID == "") exitWith {
		[("STR_A3PL_NPC_Hooker_NoID" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	
	if (!isNil "Player_Hooker" && {Player_Hooker == _npc}) then {
		Player_Hooker_IsStopped = true;
		Player_Hooker_IsArrested = false;
		Player_Hooker_ArrestedBy = nil;
		Player_Hooker_IsGeneratingMoney = false;
		if (!isNil "Player_Hooker_MoneyGenerationLoop") then {
			terminate Player_Hooker_MoneyGenerationLoop;
			Player_Hooker_MoneyGenerationLoop = nil;
		};
		Player_Hooker = nil;
		Player_Hooker_Owner = nil;
	};
	
	if (vehicle _npc != _npc) then {
		_npc action ["Eject", vehicle _npc];
		uiSleep 0.5;
		while {vehicle _npc != _npc && !isNull _npc && alive _npc} do {
			uiSleep 0.1;
		};
	};
	
	[_npc] call A3PL_NPC_Delete;
	
	uiSleep 0.5;
	
	[_npcID] call A3PL_NPC_Create;
	
	[("STR_A3PL_NPC_Hooker_SentHome" call A3PL_Localize), Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Hooker_Blowjob",
{
	private _npc = param [0, objNull];
	if (isNull _npc) exitWith {};
	
	if ((_npc getVariable ["A3PL_NPC_Hooker_Mode", ""]) != "home") exitWith {};
	if ((_npc getVariable ["A3PL_NPC_Hooker_Owner", objNull]) != player) exitWith {};
	
	[_npc] spawn {
		private _npc = param [0, objNull];
		if (isNull _npc) exitWith {};
		
		private _headPos = _npc selectionPosition "head";
		private _worldHeadPos = _npc modelToWorld _headPos;
		
		disableUserInput true;
		cameraEffectEnableHUD true;
		cutText ["", "BLACK IN", 0.5];
		
		private _cam = "camera" camCreate (getPos player);
		_cam camSetTarget _worldHeadPos;
		_cam camSetPos [(_worldHeadPos select 0) - 0.3, (_worldHeadPos select 1) - 0.1, (_worldHeadPos select 2) + 0.1];
		_cam camSetFov 0.3;
		_cam camCommit 0;
		_cam cameraEffect ["INTERNAL", "BACK"];
		
		playSound3D ["A3PL_Common\sounds\blowjob.ogg", _npc, false, _worldHeadPos, 1, 1, 0];
		
		uiSleep 10;
		
		_cam camCommit 1;
		uiSleep 1;
		
		_cam cameraEffect ["TERMINATE", "BACK"];
		camDestroy _cam;
		cutText ["", "BLACK IN", 0.5];
		disableUserInput false;
		
		[("STR_A3PL_Hooker_BlowjobFinished" call A3PL_Localize), Color_Green] call A3PL_Notification;
		
		[_npc] call A3PL_Hooker_SendHome;
	};
}] call compile_Global;

