/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Resources_StartDigging",
{
	private ["_inMarker","_eBucket","_s","_sBucket","_pos","_digProgress","_t"];
	_inMarker = false;
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	if(player getVariable "Digging") exitWith{[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	{if ((getpos player) inArea _x) exitwith {_inMarker = true};} foreach Resources_Sand_Marker;

	private _onBeach = surfaceType getPos player isEqualTo "#cype_beach";
	if ((!_inMarker) && (!_onBeach)) exitwith {[("STR_A3PL_Resources_NoSandInThisArea" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (currentWeapon player != "A3PL_Shovel") exitwith {[("STR_A3PL_Resources_YouNeedShovel" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if (Player_ActionDoing) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	player setVariable ["Digging",true,true];
	[player,"A3PL_Shovel_Dig"] remoteExec ["A3PL_Lib_SyncAnim", 0];

	private _digTime = if (_inMarker) then {Resources_Sand_DigTime_In_Area} else {Resources_Sand_DigTime_Not_In_Area};
	[("STR_A3PL_Resources_DigTime" call A3PL_Localize),(_digTime / A3PL_Event_DblHarvest)] spawn A3PL_Lib_LoadAction;
	waitUntil{Player_ActionDoing};
	while {Player_ActionDoing} do {
		if (!(player getVariable["A3PL_Medical_Alive",true])) exitWith {Player_ActionInterrupted = true;};
		if (vehicle player isNotEqualTo player) exitWith {Player_ActionInterrupted = true;};
		if (player getVariable ["Incapacitated",false]) exitwith {Player_ActionInterrupted = true;};
	};

	[player,""] remoteExec ["A3PL_Lib_SyncAnim", 0];
	player setVariable ["Digging",false,true];
	if(Player_ActionInterrupted) exitWith {[("STR_A3PL_Resources_GatheringCancelled" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_eBucket = objNull;
	{
		if ((_x getvariable ["class",""]) isEqualTo "bucket_empty") exitwith {_eBucket = _x;};
	} foreach (player nearEntities [["A3PL_Bucket"],5]);

	if (isNull _eBucket) exitwith {[("STR_A3PL_Resources_NoEmptyBucket" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_pos = getPos _eBucket;
	deleteVehicle _eBucket;

	_sBucket = createVehicle ["A3PL_BucketSand",_pos, [], 0, "CAN_COLLIDE"];
	_sBucket setVariable ["class","sand",true];
}] call compile_Global;

["A3PL_Resources_StartClawing",
{
	private ["_inMarker","_eBucket","_s","_sBucket","_pos","_digProgress","_t"];
	_inMarker = false;
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	if(player getVariable "Digging") exitWith{[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	{if ((getpos player) inArea _x) exitwith {_inMarker = true};} foreach ["A3PL_Marker_Sand1","A3PL_Marker_Sand2"];

	private _veh = vehicle player;
	private _attachedTool = _veh getVariable ["attachedTool","nothing"];

	if (!_inMarker) exitwith {[("STR_A3PL_Resources_NoSandInThisArea" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!((typeOf _veh) isEqualTo "A3PL_MiniExcavator")) exitwith {[("STR_A3PL_Resources_YouNeedToBeIntoExcavator" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!( _attachedTool isEqualTo "bucket")) exitwith {[("STR_A3PL_Resources_NeedToHaveBucketAttached" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	
	if (Player_ActionDoing) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	player setVariable ["Digging",true,true];

	[("STR_A3PL_Resources_DigsTime" call A3PL_Localize),(3 / A3PL_Event_DblHarvest),true] spawn A3PL_Lib_LoadAction;
	waitUntil{Player_ActionDoing};
	while {Player_ActionDoing} do {
		if (!(player getVariable["A3PL_Medical_Alive",true])) exitWith {Player_ActionInterrupted = true;};
		if (!((typeOf (vehicle player)) isEqualTo "A3PL_MiniExcavator")) exitWith {Player_ActionInterrupted = true;};
		if (player getVariable ["Incapacitated",false]) exitwith {Player_ActionInterrupted = true;};
	};
	player setVariable ["Digging",false,true];
	if(Player_ActionInterrupted) exitWith {[("STR_A3PL_Resources_DiggingCancelled" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_eBucket = objNull;
	_eeBucket = objNull;
	{
		if ((_x getvariable ["class",""]) isEqualTo "bucket_empty") exitwith {_eBucket = _x;};
	} foreach (player nearEntities [["A3PL_Bucket"],15]);
	{
		if (((_x getvariable ["class",""]) isEqualTo "bucket_empty") && !(_x isEqualTo _eBucket)) exitwith {_eeBucket = _x;};
	} foreach (player nearEntities [["A3PL_Bucket"],15]);

	if (isNull _eBucket) exitwith {[("STR_A3PL_Resources_NoEmptyBucket15m" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (isNull _eeBucket) then {[("STR_A3PL_Resources_YouFilledOneBucket" call A3PL_Localize),Color_Yellow] call A3PL_Notification;};

	_pos = getPos _eBucket;
	deleteVehicle _eBucket;
	_pos2 = getPos _eeBucket;
	deleteVehicle _eeBucket;

	_pos set [2, _pos#2 + 0.02];
	_pos2 set [2, _pos#2 + 0.02];

	_sBucket = createVehicle ["A3PL_BucketSand",_pos, [], 0, "CAN_COLLIDE"];
	_sBucket setVariable ["class","sand",true];
	_sBucket enableSimulation false;
	_ssBucket = createVehicle ["A3PL_BucketSand",_pos2, [], 0, "CAN_COLLIDE"];
	_ssBucket setVariable ["class","sand",true];
	_ssBucket enableSimulation false;
	sleep 0.12;
	_sBucket enableSimulation true;
	sleep 0.12;
	_ssBucket enableSimulation true;
}] call compile_Global;

["A3PL_Resources_DigOre",
{
	private ["_veh","_dmg"];
	_veh = param [0,objNull];
	_dmg = _veh getHitPointDamage "HitShovel";
	if (currentWeapon player != "A3PL_Shovel") exitwith {[("STR_A3PL_Resources_YouNeedShovel" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_dmg < 1) then
	{
		_veh setHitPointDamage ["HitShovel",_dmg + 0.1];
	};
}] call compile_Global;

["A3PL_Resources_Picking",
{
	private _apple = param [0,objNull];
	if (!(vehicle player isEqualTo player)) exitwith {[("STR_A3PL_Resources_YouCanDoThisInACar" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (Player_ActionDoing) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[("STR_A3PL_Resources_Picking" call A3PL_Localize),Resources_Picking_Time] spawn A3PL_Lib_LoadAction;
	waitUntil{Player_ActionDoing};
	[player,"AmovPercMstpSnonWnonDnon_AinvPercMstpSnonWnonDnon_Putdown"] remoteExec ["A3PL_Lib_SyncAnim",0];
	while {Player_ActionDoing} do {
		if ((player distance2D _apple) > 8) exitwith {Player_ActionInterrupted = true};
		if (!(player getVariable["A3PL_Medical_Alive",true])) exitWith {Player_ActionInterrupted = true;};
		if ((vehicle player) != player) exitwith {Player_ActionInterrupted = true;};
		if (player getVariable ["Incapacitated",false]) exitwith {Player_ActionInterrupted = true;};
		if ((animationState player) isEqualTo "amovpercmstpsnonwnondnon") then {[player,"AmovPercMstpSnonWnonDnon_AinvPercMstpSnonWnonDnon_Putdown"] remoteExec ["A3PL_Lib_SyncAnim",0];};
	};
	[player, ""] remoteExec ["A3PL_Lib_SyncAnim",0];
	if(Player_ActionInterrupted) exitWith {[("STR_A3PL_Resources_PickingCancelled" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if (!isNull _apple) then {
		[player, _apple, 1] remoteExecCall ["Server_Inventory_Pickup", 2];
	};
}] call compile_Global;
