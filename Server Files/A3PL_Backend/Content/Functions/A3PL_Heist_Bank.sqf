/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_CCTV_Open",
{
	if (!isPipEnabled) then {[("STR_A3PL_Heist_Bank_ActivatePiP" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	disableSerialization;
	createDialog "Dialog_CCTV";
	params[
		["_position",[],[]],
		["_distance",3000,[0]]
	];
	private _display = findDisplay 27;
	A3PL_CCTV_ALL = nearestObjects [_position, ["A3PL_CCTV"],_distance];
	{
		private _control = _display displayCtrl _x;
		{
			private _index = _control lbAdd format [("STR_A3PL_Heist_Bank_CCTVCamera" call A3PL_Localize),_forEachIndex+1];
			_control lbSetData [_index,format ["%1",_x]];
		} foreach A3PL_CCTV_ALL;
		_control lbSetCurSel _forEachIndex;
		switch (_x) do
		{
			case 2100: {_control ctrlAddEventHandler ["LBSelChanged",{[1,param [1,0]] call A3PL_CCTV_SetCamera}];};
			case 2101: {_control ctrlAddEventHandler ["LBSelChanged",{[2,param [1,0]] call A3PL_CCTV_SetCamera}];};
			case 2102: {_control ctrlAddEventHandler ["LBSelChanged",{[3,param [1,0]] call A3PL_CCTV_SetCamera}];};
			case 2103: {_control ctrlAddEventHandler ["LBSelChanged",{[4,param [1,0]] call A3PL_CCTV_SetCamera}];};
		};
	} foreach [2100,2101,2102,2103];

	_control = _display displayCtrl 2500; _control ctrlAddEventHandler ["CheckBoxesSelChanged",{[4,param [0,ctrlNull],param [2,0]] call A3PL_CCTV_SetVision;}];
	_control = _display displayCtrl 2501; _control ctrlAddEventHandler ["CheckBoxesSelChanged",{[1,param [0,ctrlNull],param [2,0]] call A3PL_CCTV_SetVision;}];
	_control = _display displayCtrl 2502; _control ctrlAddEventHandler ["CheckBoxesSelChanged",{[2,param [0,ctrlNull],param [2,0]] call A3PL_CCTV_SetVision;}];

	A3PL_CCTV_CAMOBJ_1 = "camera" camCreate (getpos player);
	A3PL_CCTV_CAMOBJ_2 = "camera" camCreate (getpos player);
	A3PL_CCTV_CAMOBJ_3 = "camera" camCreate (getpos player);
	A3PL_CCTV_CAMOBJ_4 = "camera" camCreate (getpos player);
	[1,0] call A3PL_CCTV_SetCamera;
	[2,1] call A3PL_CCTV_SetCamera;
	[3,2] call A3PL_CCTV_SetCamera;
	[4,3] call A3PL_CCTV_SetCamera;

	{
		private _rsRef = format ["A3PL_CCTV_%1_RT",_forEachIndex+1];
		_x cameraEffect ["INTERNAL", "BACK", _rsRef];
		_rsRef setPiPEffect [4];
		_x camCommit 0;
	} foreach [A3PL_CCTV_CAMOBJ_1,A3PL_CCTV_CAMOBJ_2,A3PL_CCTV_CAMOBJ_3,A3PL_CCTV_CAMOBJ_4];

	waitUntil {sleep 0.1; isNull _display};
	{
		_x cameraEffect ['TERMINATE', 'BACK'];
		camDestroy _x;
	} foreach [A3PL_CCTV_CAMOBJ_1,A3PL_CCTV_CAMOBJ_2,A3PL_CCTV_CAMOBJ_3,A3PL_CCTV_CAMOBJ_4];
	A3PL_CCTV_ALL = nil;
}] call compile_Global;

["A3PL_CCTV_SetCamera",
{
	private _camNum = param [0,1];
	private _mapCam = A3PL_CCTV_ALL select (param [1,0]);
	private _camera = call compile format ["A3PL_CCTV_CAMOBJ_%1",_camNum];
	_camera attachto [_mapCam,(_mapCam selectionPosition "cam_pos")];
	_camera CamSetTarget (_mapCam modelToWorld (_mapCam selectionPosition "cam_dir"));
	_camera camCommit 0;
}] call compile_Global;

["A3PL_CCTV_SetVision",
{
	disableSerialization;
	private _mode = param [0,4];
	private _control = param [1,ctrlNull];
	private _checked = param [2,0];
	private _display = findDisplay 27;
	if (_checked isEqualTo 0) exitwith {};
	{
		private _rsRef = format ["A3PL_CCTV_%1_RT",_x];
		_rsRef setPiPEffect [_mode];
	} foreach [1,2,3,4];
	{
		private _ctrl = _display displayCtrl _x;
		if (_ctrl isNotEqualTo _control) then {_ctrl ctrlSetChecked false;};
	} foreach [2500,2501,2502];
}] call compile_Global;

["A3PL_BHeist_SetDrill",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	if (player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) exitWith {[("STR_Common_CantHeistOnDuty" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _bank = param [0,objNull];
	if (typeOf _bank != "Land_A3PL_Bank") exitwith {[("STR_A3PL_Heist_Bank_NotLookingAtVault" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _timer = false;
	if (!isNil {_bank getVariable ["timer",nil]}) then {
		if (((serverTime - (_bank getVariable ["timer",0]))) < Heist_Bank_Timer) then {_timer = true};
	};
	if (_timer) exitwith {[format [("STR_A3PL_Heist_Bank_AlreadyRobbedRecently" call A3PL_Localize),Heist_Bank_Timer - ((_bank getVariable ["timer",0]) - serverTime)],Color_Red] call A3PL_Notification;};
	if (_bank animationSourcePhase "door_bankvault" > 0) exitwith {[("STR_A3PL_Heist_Bank_VaultAlreadyOpen" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (backpack player != "A3PL_Backpack_Drill") exitwith {[("STR_A3PL_Heist_Bank_NoDrill" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _drill = "A3PL_Drill_Bank" createvehicle (getpos player);
	_drill setdir (getdir _bank)-90;
	_drill setpos (_bank modelToWorld [-5.05,4.38,-2.1]);
	removeBackpack player;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Robbery_Bank_PlaceDrill",[format ["Location: %1",(getPosATL _bank)]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

["A3PL_BHeist_PickupDrill",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private _drill = param [0,objNull];
	if (typeOf _drill != "A3PL_Drill_Bank") exitwith {[("STR_Common_NotLookingAtDrill" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (backpack player != "") exitwith {[("STR_A3PL_Heist_Bank_AlreadyHasBackpack" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	deleteVehicle _drill;
	player addBackpack "A3PL_Backpack_Drill";
}] call compile_Global;

["A3PL_BHeist_InstallBit",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	if (player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) exitWith {[("STR_A3PL_Heist_Bank_CantUseDrillOnDuty" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _drill = param [0,objNull];
	if (typeOf _drill != "A3PL_Drill_Bank") exitwith {[("STR_Common_NotLookingAtDrill" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_drill animationPhase "drill_bit" < 0.5) then {
		if (Player_ItemClass != "drill_bit") exitwith {[("STR_A3PL_Heist_Bank_NotHoldingDrill" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		[] call A3PL_Inventory_Clear;
		["drill_bit", -1] call A3PL_Inventory_Add;
		_drill animate ["drill_bit",1];
		[getPlayerUID player,(player getVariable ["character_id",""]),"Robbery_Bank_InstallDrillBit",[format ["Location: %1",(getPosATL _bank)]]] remoteExec ["Server_Log_New",2];
	} else {
		[("STR_A3PL_Heist_Bank_DrillBitRemoved" call A3PL_Localize),Color_Green] call A3PL_Notification;
		["drill_bit", 1] call A3PL_Inventory_Add;
		_drill animate ["drill_bit",0];
	};
}] call compile_Global;

["A3PL_BHeist_StartDrill",
{
	private ["_drill","_bank","_timeOut","_newDrillValue","_drillValue","_holder","_cops"];
	if (player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) exitWith {[("STR_Common_CantHeistOnDuty" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_drill = param [0,objNull];
	_fail = false;
	_faction = ("STR_Common_FISD" call A3PL_Localize);
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	_nearCity = text ((nearestLocations [player, ["NameCityCapital","NameCity","NameVillage"], 5000]) select 0);

	if ((count([("STR_Common_FISD" call A3PL_Localize)] call A3PL_Lib_FactionPlayers)) < Heist_Bank_Min_Cops) then {_fail=true;};
	if(_fail) exitWith {[format [("STR_A3PL_Heist_Bank_MinimumCopsRequired" call A3PL_Localize),Heist_Bank_Min_Cops,_faction],Color_Red] call A3PL_Notification;};
	
	if (typeOf _drill != "A3PL_Drill_Bank") exitwith {[("STR_Common_NotLookingAtDrill" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_drill animationPhase "drill_bit" < 1) exitwith {[("STR_Common_DrillBitNotInstalled" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_drill animationSourcePhase "drill_handle" > 0) exitwith {[("STR_Common_DrillAlreadyStarted" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_robTime = missionNamespace getVariable ["BankCooldown",serverTime-Heist_Bank_Cooldown];
	if((serverTime-_robTime) < Heist_Bank_Cooldown) exitWith {[("STR_A3PL_Heist_Bank_AlreadyRobbedRecently" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_bank = (nearestObjects [player, ["Land_A3PL_Bank"], 15]) select 0;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Robbery_Bank_Success",[format ["Location: %1",(getPosATL _bank)]]] remoteExec ["Server_Log_New",2];

	[("STR_Common_FISD" call A3PL_Localize),("STR_A3PL_Heist_Bank_BankHeist" call A3PL_Localize),getPos _drill,format[("STR_A3PL_Heist_Bank_BankHeistReported" call A3PL_Localize),_nearCity],("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
	[("STR_A3PL_Heist_Bank_BankHeist" call A3PL_Localize),format[("STR_A3PL_Heist_Bank_BankHeistReportedNews" call A3PL_Localize),_nearCity],("STR_Common_FishersNews" call A3PL_Localize)] remoteExec ["A3PL_Player_News",-2];

	missionNamespace setVariable ["BankCooldown",serverTime,true];
	playSound3D ["A3PL_Common\effects\bankalarm.ogg", _bank, true, _bank, 3, 1, 250];

	_drill animateSource ["drill_handle",1.25];
	playSound3D ["A3PL_Common\effects\bankdrill.ogg", _drill, true, _drill, 3, 1, 100];
	_timeOut = (getNumber (configFile >> "CfgVehicles" >> "A3PL_Drill_Bank" >> "animationSources" >> "drill_handle" >> "animPeriod"));
	_drillValue = 0;
	[("STR_Common_DrillInProgress" call A3PL_Localize),Color_Green] call A3PL_Notification;
	while {uiSleep 1; ((_drill animationSourcePhase "drill_handle") < 1)} do
	{
		_newDrillValue = _drill animationSourcePhase "drill_handle";
		if (_newDrillValue <= _drillValue) exitwith {};
		if (isNull _drill) exitwith {};
		_drillValue = _newDrillValue;
	};
	if (((_drill animationSourcePhase "drill_handle") < 1) OR (isNull _drill)) exitwith {[("STR_Common_DrillCancelled" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_bank animateSource ["door_bankvault",1];

	_bank setVariable ["timer",serverTime,true];
	uiSleep 1;
	deleteVehicle _drill;
	[("STR_Common_DrillFinished" call A3PL_Localize),Color_Green] call A3PL_Notification;
}] call compile_Global;


["A3PL_BHeist_OpenDeposit",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	if (player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) exitWith {[("STR_Common_CantHeistOnDuty" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _bank = param [0,objNull];
	private _name = param [1,""];
	private _depositNr = parseNumber ((_name splitString "_") select 1);
	if ((_bank animationSourcePhase "door_bankvault") < 0.95) exitwith {[("STR_A3PL_Heist_Bank_VaultClosedTryGlitch" call A3PL_Localize)] call A3PL_Notification;};
	if (Player_ActionDoing) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[("STR_Common_LockpickingInProgress" call A3PL_Localize),Heist_Bank_OpenDeposit_Timer] spawn A3PL_Lib_LoadActionQTE;
	waitUntil{Player_ActionDoing};
	player playMoveNow 'Acts_carFixingWheel';
	while {Player_ActionDoing} do {
		if (!(player getVariable["A3PL_Medical_Alive",true])) exitWith {Player_ActionInterrupted = true;};
		if ((vehicle player) != player) exitwith {Player_ActionInterrupted = true;};
		if (player getVariable ["Incapacitated",false]) exitwith {Player_ActionInterrupted = true;};
		if ((animationstate player) != "Acts_carFixingWheel") then {player playMoveNow 'Acts_carFixingWheel';};
	};
	[player, ""] remoteExec ["A3PL_Lib_SyncAnim",0];
	if(Player_ActionInterrupted) exitWith {[("STR_Common_LockpickingFailed" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if (_bank animationPhase _name <= (0.01)) then {
		private _random = random 100;
		private _cashSpawn = false;
		if (_random >= 65) then {_cashSpawn = true;};
		if(_cashSpawn) then {
			_cash = createVehicle ["A3PL_PileCash", position player, [], 0, "CAN_COLLIDE"];
			_cashOffset = [[-0.6,5.17,-1.4],[-0.6,5.17,-1.73],[-0.6,5.17,-2.05],[-0.6,5.17,-2.4],[-0.6,5.17,-2.7],[-0.6,4.7,-1.4],[-0.6,4.7,-1.73],[-0.6,4.7,-2.05],[-0.6,4.7,-2.4],[-0.6,4.7,-2.7],[-0.6,4.2,-1.4],[-0.6,4.2,-1.73],[-0.6,4.2,-2.05],[-0.6,4.2,-2.4],[-0.6,4.2,-2.7],[-0.6,3.72,-1.4],[-0.6,3.72,-1.73],[-0.6,3.72,-2.05],[-0.6,3.72,-2.4],[-0.6,3.72,-2.7]] select (_depositNr-1);
			_cash setpos (_bank modelToWorld _cashOffset);
		};
		_bank animate [_name,1];
		[getPlayerUID player,(player getVariable ["character_id",""]),"Robbery_Bank_DepositBoxOpen",[format ["Location: %1 | Deposit Box: %2 | Cash Spawned: %3",(getPosATL player),_name,_cashSpawn]]] remoteExec ["Server_Log_New",2];
	} else {
		[("STR_A3PL_Heist_Bank_VaultAlreadyOpened" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};
}] call compile_Global;

["A3PL_BHeist_CloseVault",
{
	private _bank = param [0,objNull];
	if (!((player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) IN Heist_Bank_Factions_Can_Secure)) exitwith {[("STR_A3PL_Heist_Bank_CantSecureVault" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((_bank animationSourcePhase "door_bankvault") < 0.95) exitwith {[("STR_A3PL_Heist_Bank_VaultAlreadySecured" call A3PL_Localize)] call A3PL_Notification;};
	_bank animateSource ["door_bankvault",0];
	for "_i" from 0 to 20 do {
		_bank animate [format ["deposit_%1",_i],0];
	};
	{deleteVehicle _x;} foreach (_bank nearEntities [["A3PL_PileCash"],20]);
}] call compile_Global;

["A3PL_BHeist_PickCash",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	if (player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) exitWith {[("STR_Common_CantHeistOnDuty" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private ["_cashPile","_container"];
	_cashPile = param [0,objNull];

	if (backpack player != "A3PL_Backpack_Money") exitwith {[("STR_A3PL_Heist_Bank_NotCarryingMoneyBag" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_container = backpackContainer player;

	if (((_container getVariable ["bankCash",0]) + Heist_Bank_Money_Per_Pile) > Heist_Bank_Max_Money_Per_Bag) exitwith {[("STR_A3PL_Heist_Bank_BagFull" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if (Player_ActionDoing) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[("STR_A3PL_Heist_Bank_FillingBag" call A3PL_Localize),Heist_Bank_PickCash_Timer] spawn A3PL_Lib_LoadActionQTE;
	waitUntil {sleep 0.1; Player_ActionCompleted};
	Player_ActionCompleted = false;

	if (backpack player != "A3PL_Backpack_Money") exitwith {[("STR_A3PL_Heist_Bank_NotCarryingMoneyBag" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_container = backpackContainer player;
	if (((_container getVariable ["bankCash",0]) + Heist_Bank_Money_Per_Pile) > Heist_Bank_Max_Money_Per_Bag) exitwith {[("STR_A3PL_Heist_Bank_BagFull" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (isNull _cashPile) exitwith {};

	private _bagAmount = _container getVariable["bankCash",0];
	[getPlayerUID player,(player getVariable ["character_id",""]),"Robbery_Bank_TakeMoney",[format ["Location: %1 | PrevBagAmount: %2 | Amount Taken: %3 | NewBagAmount: %4",(getPosATL player),_bagAmount,str(Heist_Bank_Money_Per_Pile),str(_bagAmount + Heist_Bank_Money_Per_Pile)]]] remoteExec ["Server_Log_New",2];
	deleteVehicle _cashPile;
	_container setVariable ["bankCash",(_bagAmount + Heist_Bank_Money_Per_Pile),true];
}] call compile_Global;

["A3PL_BHeist_ConvertCash",
{
	private _NPC = param [0,objNull];
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	if(Player_ActionDoing) exitWith {};
	if (backpack player != "A3PL_Backpack_Money") exitwith {[("STR_A3PL_Heist_Bank_NoMoneyBag" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _container = backpackContainer player;
	private _cash = _container getVariable ["bankCash",0];
	if (_cash < 1) exitwith {[("STR_A3PL_Heist_Bank_CantBlendDirtyMoney" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	[("STR_A3PL_Heist_Bank_Blending" call A3PL_Localize),Heist_Bank_ConvertCash_Timer] spawn A3PL_Lib_LoadActionQTE;
	waitUntil{Player_ActionDoing};
	while {Player_ActionDoing} do {
		if (!(player getVariable["A3PL_Medical_Alive",true])) exitWith {Player_ActionInterrupted = true;};
		if ((vehicle player) isNotEqualTo player) exitwith {Player_ActionInterrupted = true;};
		if ((player distance2D _NPC) > 20) exitwith {Player_ActionInterrupted = true;};
	};
	if(Player_ActionInterrupted) exitWith {[("STR_Common_ActionInterrupted" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	player setVariable ["player_cash",((player getVariable ["player_cash",0]) + _cash * A3PL_Event_CrimePayout),true];
	_container setVariable ["bankCash",nil,true];
	[getPlayerUID player,(player getVariable ["character_id",""]),"Money_Laundered",[format ["Location: %1 | Amount Laundered: %2",(getPosATL _NPC)],str(_cash * A3PL_Event_CrimePayout)]] remoteExec ["Server_Log_New",2];
	[format [("STR_A3PL_Heist_Bank_Blended" call A3PL_Localize),_cash],Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_BHeist_CheckCash",
{
	if (backpack player != "A3PL_Backpack_Money") exitwith {};
	private _container = backpackContainer player;
	[format [("STR_A3PL_Heist_Bank_MoneyBagContent" call A3PL_Localize),(_container getVariable ["bankCash",0])],Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_BHeist_Loop",
{
	private _dMoney = (backpackContainer player) getVariable ["bankCash", 0];
	private _newMoney = floor(_dMoney - (_dMoney * 0.1));

	if (_dMoney <= 0) exitWith {};
	
	if (_newMoney <= 0) exitWith {
		[("STR_A3PL_Heist_Bank_MoneyLostInWater" call A3PL_Localize),Color_Red] call A3PL_Notification;
		(backpackContainer player) setVariable ["bankCash", 0, true];
	};

	(backpackContainer player) setVariable ["bankCash", _newMoney, true];
	[format[("STR_A3PL_Heist_Bank_LosingMoneyInWater" call A3PL_Localize), _newMoney],Color_Yellow] call A3PL_Notification;
}] call compile_Global;
