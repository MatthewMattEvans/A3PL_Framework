/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Jewelry_SetDrill",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	if (player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) exitWith {[("STR_Common_CantHeistOnDuty" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _store = param [0,objNull];
	private _timer = false;
	if (!isNil {_store getVariable ["timer",nil]}) then {
		if (((serverTime - (_store getVariable ["timer",0]))) < Heist_Jewelry_Timer) then {_timer = true};
	};
	if (_timer) exitwith {[format [("STR_A3PL_Heist_Jewelry_Cooldown" call A3PL_Localize),Heist_Jewelry_Timer - ((_store getVariable ["timer",0]) - serverTime)],Color_Red] call A3PL_Notification;};
	if (_store animationSourcePhase "Vault_Door" > 0) exitwith {[("STR_A3PL_Heist_Jewelry_VaultAlreadyOpened" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (backpack player != "A3PL_Backpack_Drill") exitwith {[("STR_A3PL_Heist_Jewelry_NoDrill" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _lockPos = (_store modelToWorld (_store selectionPosition ["Vault_Lock","Memory"]));
	private _drill = "A3PL_Drill_Bank" createvehicle (getpos player);
	_drill setpos [(_lockPos select 0),(_lockPos select 1) - 0.2,(_lockPos select 2) - 0.23]; 
	_drill setdir (getdir _store) - 90;

	removeBackpack player;
}] call compile_Global;

["A3PL_Jewelry_CloseVault",
{
	private _store = param [0,objNull];
	private _factions = [("STR_Common_FISD" call A3PL_Localize)];
	if (!((player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) IN _factions)) exitwith {[("STR_A3PL_Heist_Jewelry_SecureVaultOnlyCops" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((_store animationSourcePhase "Vault_Door") < 0.95) exitwith {[("STR_A3PL_Heist_Jewelry_CloseVaultBeforeSecure" call A3PL_Localize)] call A3PL_Notification;};

	[_store,"Vault_Handle",false] call A3PL_Lib_ToggleAnimation;
	_store setVariable ["CanOpenSafe",false,true];

	{deleteVehicle _x;} foreach (_store nearEntities [["A3PL_PileCash"],20]);
}] call compile_Global;

["A3PL_Jewelry_StartDrill",
{
	private _drill = param [0,player_objintersect];
	private _nearCity = text ((nearestLocations [player, ["NameCityCapital","NameCity","NameVillage"], 5000]) select 0);
	
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	if (player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) exitWith {[("STR_Common_CantHeistOnDuty" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((count([("STR_Common_FISD" call A3PL_Localize)] call A3PL_Lib_FactionPlayers)) < Heist_Jewelry_Min_Cops_ToDrill) exitwith {[format [("STR_A3PL_Heist_Jewelry_MinCopsToRob" call A3PL_Localize),Heist_Jewelry_Min_Cops_ToDrill],Color_Red] call A3PL_Notification;};
	if (typeOf _drill != "A3PL_Drill_Bank") exitwith {[("STR_Common_NotLookingAtDrill" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_drill animationPhase "drill_bit" < 1) exitwith {[("STR_Common_DrillBitNotInstalled" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_drill animationSourcePhase "drill_handle" > 0) exitwith {[("STR_Common_DrillAlreadyStarted" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_robTime = missionNamespace getVariable ["JewelryCooldown",0];
	if(_robTime >= (diag_Ticktime-Heist_Jewelry_Cooldown)) exitWith {[("STR_A3PL_Heist_Jewelry_Cooldown" call A3PL_Localize),Color_Red] call A3PL_Notification;};


	private _store = (nearestObjects [player, ["Land_A3FL_Fishers_Jewelry"], 15]) select 0;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Robbery_JewelryVault_Start",[format ["Position: %1",(getPosATL _store)]]] remoteExec ["Server_Log_New",2];

	[("STR_Common_FISD" call A3PL_Localize),("STR_A3PL_Heist_Jewelry_Heist" call A3PL_Localize),getPos _drill,format[("STR_A3PL_Heist_Jewelry_HeistReported" call A3PL_Localize),_nearCity],("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];

	[("STR_A3PL_Heist_Jewelry_Heist" call A3PL_Localize),format[("STR_A3PL_Heist_Jewelry_HeistReportedNews" call A3PL_Localize),_nearCity],("STR_Common_FishersNews" call A3PL_Localize)] remoteExec ["A3PL_Player_News",-2];

	missionNamespace setVariable ["JewelryCooldown",diag_Ticktime,true];
	playSound3D ["A3PL_Common\effects\bankalarm.ogg", _store, true, _store, 3, 1, 250];

	_drill animateSource ["drill_handle",1,0.5];
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
	if (((_drill animationSourcePhase "drill_handle") < 1) OR (isNull _drill)) exitwith {
		[("STR_Common_DrillCancelled" call A3PL_Localize),Color_Red] call A3PL_Notification;
		[getPlayerUID player,(player getVariable ["character_id",""]),"Robbery_JewelryVault_Cancel",[format ["Position: %1",(getPosATL _store)]]] remoteExec ["Server_Log_New",2];
	};

	_store setVariable ["CanOpenSafe",true,true];
	_store setVariable ["timer",serverTime,true];
	sleep 1;
	deleteVehicle _drill;
	[("STR_Common_DrillFinished" call A3PL_Localize),Color_Green] call A3PL_Notification;
	[_store,player] call A3PL_Jewelry_LoadSafe;
}] call compile_Global;

["A3PL_Jewelry_LoadSafe",
{
	private _store = param [0,objNull];
	private _player = param [1,objNull];
	private _itemList = Heist_Jewelry_Items_Safe;
	private _rewardList = [];
	for "_i" from 1 to 10 do {
		_point = format["safe_item_%1",_i];
		_class = selectRandom _itemList;
		_rewardList pushBack _item;
		_item = createVehicle [(([_class,"class"]) call A3PL_Config_GetItem), position player, [], 0, "CAN_COLLIDE"];
		_item setpos (_store modelToWorld (_store selectionPosition _point));
		_item enableSimulation false;
		_item setVariable ["class",_class,true];
	};
	private _weaponHolder = createVehicle ["GroundWeaponHolder", getposATL player, [], 0, "CAN_COLLIDE"]; 
	_weaponHolder addItemCargoGlobal ["A3PL_Crown",1];
	[getPlayerUID _player,(_player getVariable ["character_id",""]),"Robbery_JewelryVault_Success",[format ["Position: %1 | Reward: %2",(getPosATL _store),str(_rewardList)]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

["A3PL_Jewelry_GlassDamage",
{
	private _intersect = missionNameSpace getVariable ["player_objintersect",objNull];
	private _nameIntersect = missionNameSpace getVariable ["player_nameintersect",""];
	private _cops = [("STR_Common_FISD" call A3PL_Localize)] call A3PL_Lib_FactionPlayers;
	if (player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) exitWith {[("STR_Common_CantHeistOnDuty" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if(count(_cops) < Heist_Jewelry_Min_Cops_GlassDamage) exitWith {[("STR_A3PL_Heist_Jewelry_NotEnoughCopsToBreakGlass" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (player distance (_intersect modelToWorld (_intersect selectionPosition _nameIntersect)) < 2) then {
		private _var = format ["damage_%1",_nameintersect];
		private _damage = (_intersect getVariable [_var,0]);
		_intersect setVariable [_var,_damage + 0.2,false];
		if (_damage > 1) exitwith {
			[_intersect,_nameIntersect] spawn A3PL_Jewelry_BreakGlass;
		};
	};
}] call compile_Global;

["A3PL_Jewelry_BreakGlass", {
	private _object = param [0,player_objIntersect];
	private _name = param [1,player_nameIntersect];
	private _cops = [("STR_Common_FISD" call A3PL_Localize)] call A3PL_Lib_FactionPlayers;
	private _glassPos = _object modelToWorldVisual (_object selectionPosition [_name,"Memory"]);
	if (player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) exitWith {[("STR_Common_CantHeistOnDuty" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	playSound3D ["A3\Sounds_F\arsenal\sfx\bullet_hits\glass_07.wss", player, true, getPosASL player, 4, 1, 20];
	_object animate [_name,1];
	//[_glassPos] call A3PL_Jewelry_LeaveBlood; -> BloodSplash is non existant
	sleep 1;
	playSound3D ["A3PL_Common\effects\burglaralarm.ogg", _object, false, _glassPos, 1, 1, 300];

	private _namePos = [getPos _object] call A3PL_Housing_PosAddress;
	[_object,("STR_Common_AlarmTriggered" call A3PL_Localize),"ColorWhite","A3FL_Markers_911Call"] remoteExec ["A3PL_Lib_CreateMarker",_cops];
	[getPos _object] remoteExec ["A3PL_GPS_NavigateToPosition",_cops];
	[("STR_Common_FISD" call A3PL_Localize),("STR_A3PL_Heist_Jewelry_ArmedRobbery" call A3PL_Localize),getPos _object,format[("STR_A3PL_Heist_Jewelry_ArmedRobberyReported" call A3PL_Localize),_namePos],("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];

	[getPlayerUID player,(player getVariable ["character_id",""]),"Robbery_JewelryCase_Break",[format ["Case: %1",_name]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

["A3PL_Jewelry_LeaveBlood",
{
	private _pointPos = param[0,[]];
	private _chance = random 100;
	private _pos = [_pointPos#0,_pointPos#1,(_pointPos#2)+0.1];
	private _blood = createVehicle ["A3FL_BloodSplash", [0,0,0], [], 0, "NONE"];
	_blood setPos _pos;
	_blood setVariable["dna", (player getVariable ["character_id",""]), true];
	[("STR_A3PL_Heist_Jewelry_BloodOnGlass" call A3PL_Localize),Color_Red] call A3PL_Notification;
	[player,"right lower arm","cut"] call A3PL_Medical_ApplyWound;
}] call compile_Global;


["A3PL_Jewelry_PickJewelry",
{
	private _object = param [0,player_objIntersect];
	private _name = param [1,player_nameIntersect];
	private _time = 10;
	private _items = [];

	if (player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) exitWith {[("STR_Common_CantHeistOnDuty" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (Player_ActionDoing) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_object getVariable[_name,false]) exitWith {[("STR_A3PL_Heist_Jewelry_AlreadyCollecting" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_object setVariable[_name,true,true];
	switch(_name) do {
		case("jewlery_case_1"): {
			_time = Heist_Jewelry_TimeToRob_Glass1;
			_items = Heist_Jewelry_Items_Glass1;
		};
		case("jewlery_case_2"): {
			_time = Heist_Jewelry_TimeToRob_Glass2;
			_items = Heist_Jewelry_Items_Glass2;
		};
		case("jewlery_case_3"): {
			_time = Heist_Jewelry_TimeToRob_Glass3;
			_items = Heist_Jewelry_Items_Glass3;
		};
		case("jewlery_case_4"): {
			_time = Heist_Jewelry_TimeToRob_Glass4;
			_items = Heist_Jewelry_Items_Glass4;
		};
		case("jewlery_case_5"): {
			_time = Heist_Jewelry_TimeToRob_Glass5;
			_items = Heist_Jewelry_Items_Glass5;
		};
		case("jewlery_case_6"): {
			_time = Heist_Jewelry_TimeToRob_Glass6;
			_items = Heist_Jewelry_Items_Glass6;
		};
		case("jewlery_case_7"): {
			_time = Heist_Jewelry_TimeToRob_Glass7;
			_items = Heist_Jewelry_Items_Glass7;
		};
		case("jewlery_case_8"): {
			_time = Heist_Jewelry_TimeToRob_Glass8;
			_items = Heist_Jewelry_Items_Glass8;
		};
		case("jewlery_case_9"): {
			_time = Heist_Jewelry_TimeToRob_Glass9;
			_items = Heist_Jewelry_Items_Glass9;
		};
	};

	if (currentWeapon player != "") then {
		A3PL_Holster = currentWeapon player;
		player action ["SwitchWeapon", player, player, 100];
		player switchCamera cameraView;
	};

	[("STR_A3PL_Heist_Jewelry_StealingJewelry" call A3PL_Localize),_time] spawn A3PL_Lib_LoadActionQTE;
	waitUntil{Player_ActionDoing};
	while {Player_ActionDoing} do {
		if ((player distance2D (_object modelToWorldVisual (_object selectionPosition [_name,"Memory"]))) > 3) exitwith {Player_ActionInterrupted = true};
		if (!(player getVariable["A3PL_Medical_Alive",true])) exitWith {Player_ActionInterrupted = true;};
		if (player getVariable ["Incapacitated",false]) exitwith {Player_ActionInterrupted = true;};
		if ((animationState player) isEqualTo "amovpercmstpsnonwnondnon") then {[player,"AmovPercMstpSnonWnonDnon_AinvPercMstpSnonWnonDnon_Putdown"] remoteExec ["A3PL_Lib_SyncAnim",0];};
	};
	[player, ""] remoteExec ["A3PL_Lib_SyncAnim",0];
	if(Player_ActionInterrupted) exitWith {[("STR_Common_ActionInterrupted" call A3PL_Localize),Color_Red] call A3PL_Notification;_object setVariable[_name,nil,true];};

	{
		private _class = _x select 0;
		private _amount = _x select 1;
		[_class,_amount] call A3PL_Inventory_Add;
	} foreach _items;
	_object animate [_name,1];
	_object setVariable[_name,nil,true];
	[getPlayerUID player,(player getVariable ["character_id",""]),"Robbery_JewelryCase_Looted",[format ["Case: %1 | Items: %2",_name,str(_items)]]] remoteExec ["Server_Log_New",2];
	[("STR_A3PL_Heist_Jewelry_Robbed" call A3PL_Localize),Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Jewelry_HandleDoor",
{
	private _store = param [0,objNull];
	private _name = param [1,""];
	if (_name IN ["door_1","door_2"]) exitwith {[_store,_name,false] call A3PL_Lib_ToggleAnimation;};
	if (!(player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] IN [("STR_Common_FISD" call A3PL_Localize)]) && !(["keycard",1] call A3PL_Inventory_Has)) exitwith {[("STR_A3PL_Heist_Jewelry_CannotUseButton" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_name IN ["jewelry_3_button","jewelry_3_button2","jewelry_4_button","jewelry_4_button2","jewelry_5_button","jewelry_5_button2"]) exitwith {
		private _anim = switch (_name) do
		{
			case "jewelry_3_button": {[_store,"door_3",false] call A3PL_Lib_ToggleAnimation;};
			case "jewelry_3_button2": {[_store,"door_3",false] call A3PL_Lib_ToggleAnimation;};
			case "jewelry_4_button": {[_store,"door_4",false] call A3PL_Lib_ToggleAnimation;};
			case "jewelry_4_button2": {[_store,"door_4",false] call A3PL_Lib_ToggleAnimation;};
			case "jewelry_5_button": {
				[_store,"door_5",false] call A3PL_Lib_ToggleAnimation;
				[_store,"door_6",false] call A3PL_Lib_ToggleAnimation;
			};
			case "jewelry_5_button2": {
				[_store,"door_5",false] call A3PL_Lib_ToggleAnimation;
				[_store,"door_6",false] call A3PL_Lib_ToggleAnimation;
			};
		};
	};
}] call compile_Global;

["A3PL_Jewelry_FixCases",
{
	private _stores = nearestObjects[player, ["Land_A3FL_Fishers_Jewelry"], 30];
	if(count _stores isEqualTo 0) exitWith {["Error cannot find the jewelry store",Color_Red] call A3PL_Notification;};
	private _store = _stores#0;
	_store animate ['case_break_1',0];
	_store animate ['case_break_2',0];
	_store animate ['case_break_3',0];
	_store animate ['case_break_4',0];
	_store animate ['case_break_5',0];
	_store animate ['case_break_6',0];
	_store animate ['case_break_7',0];
	_store animate ['case_break_8',0];
	_store animate ['case_break_9',0];
	_store animate ['jewlery_case_1',0];
	_store animate ['jewlery_case_2',0];
	_store animate ['jewlery_case_3',0];
	_store animate ['jewlery_case_4',0];
	_store animate ['jewlery_case_5',0];
	_store animate ['jewlery_case_6',0];
	_store animate ['jewlery_case_7',0];
	_store animate ['jewlery_case_8',0];
	_store animate ['jewlery_case_9',0];
}] call compile_Global;
