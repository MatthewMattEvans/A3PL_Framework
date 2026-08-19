/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
['A3PL_FD_SetFireTruckNumber',
{
	params [
		["_veh",objNull,[objNull]],
		["_callsign","",[""]],
		["_startIndex",0]
	];
	private _truckClass = typeOf _veh;
	private _Number1 = 0;
	private _TruckNumber = _startIndex + ({typeOf _x isEqualTo _truckClass} count vehicles);

	while {_TruckNumber > 9} do {_TruckNumber = _TruckNumber - 10; _Number1 = _Number1 + 1;};

	_veh setObjectTextureGlobal [8, format ["\A3PL_FD\textures\Truck_Numbers\%1.paa", _Number1]];
	_veh setObjectTextureGlobal [9, format ["\A3PL_FD\textures\Truck_Numbers\%1.paa", _TruckNumber]];

	_veh setVariable["CAD_Faction", ("STR_Common_FIFR" call A3PL_Localize),true];
	_veh setVariable["CAD_Squad", format["%1-%2%3",_callsign,_Number1,_TruckNumber],true];
}] call compile_Global;

["A3PL_FD_HandleJaws",
{
	private _pJob = player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
	if((!(_pJob isEqualTo ("STR_Common_FIFR" call A3PL_Localize))) && (!(_pJob isEqualTo ("STR_Common_FISD" call A3PL_Localize)))) exitWith {};
	private _intersect = missionNameSpace getVariable ["player_objintersect",objNull];
	private _nameIntersect = missionNameSpace getVariable ["player_nameintersect",""];

	if ((typeOf _intersect) isEqualTo "C_IDAP_supplyCrate_F") exitWith {};
	if ((player distance (_intersect modelToWorld (_intersect selectionPosition _nameIntersect)) < 2) && (_nameIntersect IN ["glass2","door_lf","door_lf2","door_lf3","door_lf4","door_lf5","door_lf6"])) exitwith
	{
		if ((round random 10) > 4) then {
			[("STR_A3PL_FD_JawsOfLifeUsed" call A3PL_Localize),Color_Green] call A3PL_Notification;
			moveOut (driver _intersect);
			_intersect setVariable ["locked",false,true];
			_intersect setVariable ["trapped",false,true];
		} else {
			[("STR_A3PL_FD_JawsOfLifeFailed" call A3PL_Localize),Color_Red] call A3PL_Notification;
		};
	};
	if ((player distance (_intersect modelToWorld (_intersect selectionPosition _nameIntersect)) < 2) && (_nameIntersect IN ["glass3","glass4","glass5","door_lb","door_rb","door_rf","door_lb2","door_lb3","door_lb4","door_lb5","door_lb6","door_rb2","door_rb3","door_rb4","door_rb5","door_rb6","door_rf2","door_rf3","door_rf4","door_rf5","door_rf6"])) exitwith
	{
		if ((round random 10) > 4) then {
			[("STR_A3PL_FD_JawsOfLifePassengersUsed" call A3PL_Localize),Color_Green] call A3PL_Notification;
			{
				moveOut _x;
			} foreach (crew _intersect);
			_intersect setVariable ["locked",false,true];
			_intersect setVariable ["trapped",false,true];
		} else {
			[("STR_A3PL_FD_JawsOfLifeFailed" call A3PL_Localize),Color_Red] call A3PL_Notification;
		};
	};
	if ((player distance (_intersect modelToWorld (_intersect selectionPosition _nameIntersect)) < 10)) exitwith
	{
		if ((round random 10) > 4) then {
			[("STR_A3PL_FD_JawsOfLifePassengersUsed" call A3PL_Localize),Color_Green] call A3PL_Notification;
			{
				moveOut _x;
			} foreach (crew _intersect);
			_intersect setVariable ["locked",false,true];
			_intersect setVariable ["trapped",false,true];
		} else {
			[("STR_A3PL_FD_JawsOfLifeFailed" call A3PL_Localize),Color_Red] call A3PL_Notification;
		};
	};
}] call compile_Global;

["A3PL_FD_HandleFireAxe",
{
	private _whitelist = [("STR_Common_FIFR" call A3PL_Localize),("STR_Common_FISD" call A3PL_Localize)];
	private _pJob = player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
	if(!(_pJob IN _whitelist)) exitWith {};
	private _intersect = missionNameSpace getVariable ["player_objintersect",objNull];
	private _nameIntersect = missionNameSpace getVariable ["player_nameintersect",""];
	if ((player distance (_intersect modelToWorld (_intersect selectionPosition _nameIntersect)) < 2) && (_nameIntersect IN ["door_bankvault","door_1","door_2","door_3","door_4","door_5","door_6","door_7","door_8","door_9","door_10","door_11","door_12","door_13","door_14","door_15","door_16","door_17","door_18","door_19","door_20","door_21","door_22","door_23","door_24","door_25","door_26","door_27","door_28","door_29","door_30","door_31","door_32","door_33","door_34","door_35","door_36","door_37","door_38","door_39","door_40","door_41","door_42","door_43","door_44","door_45","door_46","door_47","door_48","door_49","door_50","storagedoor1","storagedoor2","storagedoor3","sdstoragedoor3","sdstoragedoor6","door_1_button","door_2_button","door_3_button","door_4_button","door_5_button","door_6_button","door_7_button","door_8_button","door_9_button","door_10_button","door_11_button","door_12_button","door_13_button","door_14_button","door_15_button","door_16_button","door_17_button","door_18_button","door_19_button","door_20_button","door_21_button","door_22_button","door_23_button","door_24_button","door_25_button","door_26_button","door_27_button","door_28_button","door_29_button","door_30_button","door_1_button2","door_2_button2","door_3_button2","door_4_button2","door_5_button2","door_6_button2","door_7_button2","door_8_button2","door_9_button2","door_10_button2","door_11_button2","door_12_button2","door_13_button2","door_14_button2","door_15_button2","door_16_button2","door_17_button2","door_18_button2","door_19_button2","door_20_button2","door_21_button2","door_22_button2","door_23_button2","door_24_button2","door_25_button2","door_26_button2","door_27_button2","door_28_button2","door_29_button2","door_30_button2","door_8_button1","door_8_button2"])) then
	{
		if (_nameIntersect IN ["door_1_button","door_2_button","door_3_button","door_4_button","door_5_button","door_6_button","door_7_button","door_8_button","door_9_button","door_10_button","door_11_button","door_12_button","door_13_button","door_14_button","door_15_button","door_16_button","door_17_button","door_18_button","door_19_button","door_20_button","door_21_button","door_22_button","door_23_button","door_24_button","door_25_button","door_26_button","door_27_button","door_28_button","door_29_button","door_30_button","door_1_button2","door_2_button2","door_3_button2","door_4_button2","door_5_button2","door_6_button2","door_7_button2","door_8_button2","door_9_button2","door_10_button2","door_11_button2","door_12_button2","door_13_button2","door_14_button2","door_15_button2","door_16_button2","door_17_button2","door_18_button2","door_19_button2","door_20_button2","door_21_button2","door_22_button2","door_23_button2","door_24_button2","door_25_button2","door_26_button2","door_27_button2","door_28_button2","door_29_button2","door_30_button2","door_8_button1","door_8_button2"]) then {[] call A3PL_Intersect_HandleDoors;};
		private _var = format ["damage_%1",_nameintersect];
		if (((_intersect getVariable [_var,0]) + 0.2) > 1) exitwith
		{
			_intersect animate [_nameIntersect,1];
			_intersect setvariable [_var,0,false];
			if (_nameIntersect in ["storagedoor1","storagedoor2","storagedoor3"]) then {[] spawn {_intersect = cursorobject;_intersect animateSource ["storagedoor",1];sleep 60;_intersect animateSource ["storagedoor",0];};};
			if (_nameIntersect == "door_bankvault") then {[] spawn {_intersect = cursorobject;_intersect animateSource ["door_bankvault",1];sleep 20;_intersect animateSource ["door_bankvault",0];};};
			if (_nameIntersect == "sdstoragedoor3") then {[] spawn {_intersect = cursorobject;_intersect animateSource ["StorageDoor",1];sleep 60;_intersect animateSource ["StorageDoor",0];};};
			if (_nameIntersect == "sdstoragedoor6") then {[] spawn {_intersect = cursorobject;_intersect animateSource ["StorageDoor2",1];sleep 60;_intersect animateSource ["StorageDoor2",0];};};
		};
		_intersect setVariable [_var,(_intersect getVariable [_var,0]) + 0.2,false]; //local variable cause why global it, 5 hits to destroy door
	};
}] call compile_Global;

["A3PL_FD_ConnectAdapter",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private _hydrant = param [0,objNull];
	private _pos = [];
	private _dir = -180;
	if (!((typeOf _hydrant) IN ["Land_A3PL_FireHydrant","Land_A3PL_Gas_Station"])) exitwith {[("STR_A3PL_FD_NotNearFireHydrant" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (((count (attachedObjects _hydrant)) > 0) && (typeOf _hydrant == "Land_A3PL_FireHydrant")) exitwith {[("STR_A3PL_FD_AdapterAlreadyConnected" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (player_itemClass != "FD_adapter") exitwith {[("STR_A3PL_FD_AdapterNotFound" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	switch (typeOf _hydrant) do {
		case ("Land_A3PL_FireHydrant"): {_pos = [-0.005,0.15,-0.076]; _dir = -180; _hydrant animateSource ["cap_hide",1];};
		case ("Land_A3PL_Gas_Station"): {_pos = [-3.72154,3.51953,-2.1]; _dir = -90;};
	};

	private _adapter = createVehicle ["A3PL_FD_HoseEnd1_Float",_hydrant modelToWorld _pos, [], 0, "CAN_COLLIDE"];
	_adapter setDir (getDir _hydrant + _dir);

	[player,_adapter,"FD_adapter"] remoteExec ["Server_Inventory_Drop", 2];
	deleteVehicle Player_Item;
	Player_Item = objNull;
	Player_ItemClass = "";
	call A3PL_FD_ConnectAnimation;
}] call compile_Global;

["A3PL_FD_WrenchRotate",
{
	private _wrench = param [0,objNull];
	if (_wrench animationSourcePhase "WrenchRotation" < 0.5) then {
		_wrench animateSource ["WrenchRotation",1];
	} else {
		_wrench animateSource ["WrenchRotation",0];
	};
	call A3PL_FD_ConnectAnimation;
}] call compile_Global;

["A3PL_FD_ConnectWrench",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private _hydrant = param [0,objNull];
	if (!(_hydrant isKindOf "Land_A3PL_FireHydrant")) exitwith {[("STR_A3PL_FD_NotNearFireHydrant2" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _newWrench = createVehicle ["A3PL_FD_HydrantWrench_F",_hydrant modelToWorld [0,-0.25,0.445], [], 0, "CAN_COLLIDE"];
	_newWrench setDir (getDir _hydrant);

	[player,_newWrench,"FD_hydrantwrench"] remoteExec ["Server_Inventory_Drop", 2];
	deleteVehicle Player_Item;
	Player_Item = objNull;
	Player_ItemClass = "";
	call A3PL_FD_ConnectAnimation;
}] call compile_Global;

["A3PL_FD_ConnectHose",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private _end = param [0,objNull];
	if (!(_end isKindOf "A3PL_FD_HoseEnd1_Float")) exitwith {[("STR_A3PL_FD_NotInteractingWithAdapterOnHydrant" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!((attachedTo _end) isKindOf "Land_A3PL_FireHydrant")) exitwith {[("STR_A3PL_FD_NotNearFireHydrant2" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((count (ropes _end)) > 0) exitwith {[("STR_A3PL_FD_HoseAlreadyConnected" call A3PL_Localize),Color_Red] call A3PL_Notification;};
}] call compile_Global;

["A3PL_FD_ConnectHoseAdapter",
{
	private ["_end","_endName","_myAdapter","_TOEnd","_TOmyAdapter","_dirOffset","_attachOffset","_memOffset","_animate","_otherEnd"];
	_end = param [0,objNull];
	_endName = param [1,""];

	if(!(call A3PL_Player_AntiSpam)) exitWith {};

	_myAdapter = [] call A3PL_Lib_AttachedFirst;
	_otherEnd = [_myAdapter] call A3PL_FD_FindOtherEnd;

	if (_otherEnd isEqualTo _end) exitwith {};

	_TOEnd = typeOf _end;
	_TOmyAdapter = typeOf _myAdapter;

	if (!(_TOEnd IN ["A3PL_FD_HoseEnd1_Float","A3PL_FD_HoseEnd1","A3PL_FD_HoseEnd2","A3PL_FD_yAdapter","A3PL_Pierce_Heavy_Ladder","A3PL_Pierce_Pumper","A3PL_Tanker_Trailer","A3PL_Fuel_Van","A3PL_Silverado_FD_Brush","EC_F450_Brush","A3FL_T440_Gas_Tanker","A3FL_T440_Water_Tanker"])) exitwith {[("STR_A3PL_FD_NoAdapterNoHose" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!(_TOmyAdapter IN ["A3PL_FD_HoseEnd1","A3PL_FD_HoseEnd2"])) exitwith {[("STR_A3PL_FD_NotRightAdapter" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((_TOmyAdapter isEqualTo "A3PL_FD_HoseEnd1") && _TOEnd isEqualTo "A3PL_FD_HoseEnd1_Float") exitwith {[("STR_A3PL_FD_HoseWrongSide1" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((_TOmyAdapter isEqualTo "A3PL_FD_HoseEnd1") && _TOEnd isEqualTo "A3PL_FD_HoseEnd1") exitwith {[("STR_A3PL_FD_HoseWrongSide1" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((_TOmyAdapter isEqualTo "A3PL_FD_HoseEnd2") && _TOEnd isEqualTo "A3PL_FD_HoseEnd2") exitwith {[("STR_A3PL_FD_HoseWrongSide2" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((_TOmyAdapter isEqualTo "A3PL_FD_HoseEnd2") && _endName isEqualTo "fd_yadapter_in") exitwith {[("STR_A3PL_FD_HoseToYAdapterWrongSide" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((_TOmyAdapter isEqualTo "A3PL_FD_HoseEnd1") && _endName isEqualTo "fd_yadapter_out1") exitwith {[("STR_A3PL_FD_HoseToYAdapterWrongSide2" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((_TOmyAdapter isEqualTo "A3PL_FD_HoseEnd1") && _endName isEqualTo "fd_yadapter_out2") exitwith {[("STR_A3PL_FD_HoseToYAdapterWrongSide2" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((_TOmyAdapter isEqualTo "A3PL_FD_HoseEnd1") && _endName isEqualTo "fd_yadapter_out2") exitwith {[("STR_A3PL_FD_HoseToYAdapterWrongSide2" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((_TOmyAdapter isEqualTo "A3PL_FD_HoseEnd2") && _endName IN ["inlet_ds"]) exitwith {[("STR_A3PL_FD_HoseWrongSide3" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	switch (_endName) do {
		case ("fd_yadapter_in"): {_dirOffset = -90; _attachOffset = [-0.15,0,0]; _end setVariable ["inlet",_myAdapter,true]};
		case ("fd_yadapter_out1"): {_dirOffset = 115; _attachOffset = [0.07,-0.10,0];};
		case ("fd_yadapter_out2"): {_dirOffset = 60; _attachOffset = [0.07,0.10,0];};
		case ("inlet_r"): {_dirOffset = -180; _attachOffset = [0,0,0]; _memOffset = "inlet_r"; _animate = "Inlet_R_Cap";};
		case ("inlet_ds"): {_dirOffset = -90; _attachOffset = [0,0,0]; _memOffset = "inlet_ds"; _animate = "Inlet_DS_Cap";};
		case ("inlet_bt"): {_dirOffset = 180; _attachOffset = [0,0.03,0]; _memOffset = "inlet_bt"; _animate = "inlet_bt_cap";};
		case ("outlet_ps"): {_dirOffset = 90; _attachOffset = [0.05,0,0]; _memOffset = "outlet_ps"; _animate = "Outlet_PS_Cap";};
		case ("outlet_ds"): {_dirOffset = -90; _attachOffset = [-0.05,0,0]; _memOffset = "outlet_ds"; _animate = "Outlet_DS_Cap";};

		case ("outlet_1"): {_dirOffset = 90; _attachOffset = [0,0,0]; _memOffset = "outlet_1"; _animate = "outlet_1_cap";};
		case ("outlet_2"): {_dirOffset = 90; _attachOffset = [0,0,0]; _memOffset = "outlet_2"; _animate = "outlet_2_cap";};
		case ("outlet_3"): {_dirOffset = 90; _attachOffset = [0,0,0]; _memOffset = "outlet_3"; _animate = "outlet_3_cap";};
		case ("outlet_4"): {_dirOffset = 90; _attachOffset = [0.12,0,0]; _memOffset = "outlet_4"; _animate = "outlet_4_cap";};

		case ("outlet_bt_1"): {_dirOffset = 180; _attachOffset = [0,0,0]; _memOffset = "outlet_bt_1"; _animate = "outlet_bt_1_cap";};
		case ("outlet_bt_2"): {_dirOffset = 180; _attachOffset = [0,0,0]; _memOffset = "outlet_bt_2"; _animate = "outlet_bt_2_cap";};
		case default {_dirOffset = -180; _attachOffset = [0,-0.04,0];};
	};
	switch (_TOEnd) do {
		case ("A3PL_Fuel_Van"): {_dirOffset = 180; _attachOffset = [0,0,0]; _memOffset = "outlet_1"; _animate = "outlet_1_cap";};
	};
	_dir = getDir _end + _dirOffset;

	if (!isNil "_memOffset") then {
		_myAdapter attachTo [_end,_attachOffset,_memOffset];
	} else {
		_myAdapter attachTo [_end,_attachOffset];
	};
	if (!isNil "_animate") then { _end animate [_animate,1]; };

	_myAdapter setDir (_dir + (360 - (getDir _end)));
	call A3PL_FD_ConnectAnimation;
}] call compile_Global;

["A3PL_FD_ConnectAnimation",
{
	player playmove "Acts_carFixingWheel";
	[] spawn {
		uiSleep 4;
		player switchmove "";
	};
}] call compile_Global;

["A3PL_FD_FindHose",
{
	private _obj = param [0,objNull];
	private _hose = objNull;
	private _ropes = ropes _obj;
	if ((count _ropes) isEqualTo 0) then {
		_obj = ropeAttachedTo _obj;
		_ropes = ropes _obj;
		if (count _ropes != 0) then {
			_hose = _ropes#0;
		};
	} else {
		_hose = _ropes#0;
	};
	_hose;
}] call compile_Global;

//find other end of rope
["A3PL_FD_FindOtherEnd",
{
	private _end = param [0,objNull];
	private _oEnd = objNull;
	private _oEnd = ropeAttachedTo _end;
	if ((isNull _oEnd) OR (_oEnd isEqualTo _end)) then {
		private _ropeAttached = ropeAttachedObjects _end;
		if (count _ropeAttached != 0) then {
			_oEnd = _ropeAttached#0;
		};
	};
	_oEnd;
}] call compile_Global;

//this can find an adapter based on memory point, returns string of memory point (discharge/inlet) it is attached to, or just returns the end if we need
["A3PL_FD_FindAdapterCap",
{
	private ["_found"];
	private _end = param [0,objNull];
	private _veh = param [1,objNull];
	private _memToFindEnd = param [2,""];
	if (isNull _veh) exitwith {"";};

	if (_memToFindEnd isNotEqualTo "") exitwith
	{
		private ["_selectionPosition","_foundEnd"];
		_foundEnd = objNull;
		_selectionPosition = _veh modelToWorld (_veh selectionPosition [_memToFindEnd,"memory"]);
		{
			if ((typeOf _x IN ["A3PL_FD_HoseEnd1","A3PL_FD_HoseEnd2"]) && ((_selectionPosition distance _x) < 0.1)) exitwith
			{
				_foundEnd = _x;
			};
		} foreach (attachedObjects _veh);
		_foundEnd;
	};

	private _selectionNames = ["inlet_r","inlet_ds","inlet_ps","outlet_ds","outlet_ps","outlet_1","outlet_2","outlet_3","outlet_4","inlet_bt","outlet_bt_1","outlet_bt_2"];
	{
		_selectionPosition = _veh modelToWorld (_veh selectionPosition [_x,"memory"]);
		if ((_end distance _selectionPosition) < 0.1) exitwith {
			_found = _x;
		};
	} foreach _selectionNames;

	if (isNil "_found") exitwith {"";};
	private _foundCap = switch (_found) do
	{
		case ("inlet_r"): {"inlet_r_cap"};
		case ("inlet_ds"): {"inlet_ds_cap"};
		case ("inlet_ps"): {"inlet_ps_cap"};
		case ("inlet_bt"): {"inlet_bt_cap"};
		case ("outlet_ds"): {"outlet_ds_cap"};
		case ("outlet_ps"): {"outlet_ps_cap"};
		case ("outlet_1"): {"outlet_1_cap"};
		case ("outlet_2"): {"outlet_2_cap"};
		case ("outlet_3"): {"outlet_3_cap"};
		case ("outlet_4"): {"outlet_4_cap"};
		case ("outlet_bt_1"): {"outlet_bt_1_cap"};
		case ("outlet_bt_2"): {"outlet_bt_2_cap"};
	};
	_foundCap;
}] call compile_Global;

["A3PL_FD_GrabHose",
{
	params[
		["_end",objNull,[objNull]]
	];
	private _nozzleClass = "A3PL_High_Pressure";

	if (!(call A3PL_Player_AntiSpam)) exitWith {};
	if (!isNull Player_Item) exitwith {[("STR_Common_HandsFull" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!(typeOf _end IN ["A3PL_FD_HoseEnd1","A3PL_FD_HoseEnd2"])) exitwith {["Interaction error (report this)",Color_Red] call A3PL_Notification;};
	if (isPlayer (attachedTo _end)) exitwith {[("STR_Common_HoseAlreadyHeld" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _otherEnd = [_end] call A3PL_FD_FindOtherEnd;
	if (!local _end) then {[netID _end,netID player] remoteExec ["A3PL_Lib_ChangeLocality", 2];};
	if (!local _otherEnd && {!isNull _otherend}) then {[netID _otherEnd,netID player] remoteExec ["A3PL_Lib_ChangeLocality", 2];};

	if (isPlayer (attachedTo _otherEnd)) exitwith {[("STR_Common_HoseAlreadyHeld" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _attachedTo = attachedTo _end;
	if (typeOf _attachedTo == "A3PL_FD_yAdapter") then
	{
		if (_end isEqualTo _attachedTo getVariable ["inlet",objNull]) then
		{
			_attachedTo setVariable ["inlet",objNull,true];
		};
	};

    private _connectedMem = [_end,(attachedTo _end)] call A3PL_FD_FindAdapterCap;
	if (_connectedMem isNotEqualTo "") then {(attachedTo _end) animate [_connectedMem,0]};

	_end attachTo [player,[0,0,0],"RightHand"];
	Player_Item = _end;

	private _hose = [_end] call A3PL_FD_FindHose;
	private _ropeLength = ropeLength _hose - 2.25;

	missionNamespace setVariable ["A3PL_FD_FiredCount",0];
	A3PL_FD_PlayerFiredIndex = player addEventHandler ["Fired",{[(param [0,objNull])] call A3PL_FD_WaterFiredEH;}];
	while {(attachedTo _end isEqualTo player) && {!isNull _end}} do
	{
		if (vehicle player isNotEqualTo player) exitwith {detach _end};
		if ((_end distance _otherEnd) > _ropeLength) exitwith {detach _end; [("STR_A3PL_FD_HoseDropped" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		if (currentWeapon player == "A3PL_High_Pressure") then
		{
			private ["_hasMag","_shouldMag","_bullets","_shouldBullets","_source"];
			_hasMag = (handgunMagazine player) select 0;
			if (isNil "_hasMag") then {_hasMag = ""};

			private _source = [_end] call A3PL_FD_FindSource;
			private _pressure = "low";
			private _shouldMag = "A3PL_Low_Pressure_Water_Mag";
			if (typeOf _source IN ["A3PL_Pierce_Pumper","A3FL_T440_Water_Tanker","A3PL_Silverado_FD_Brush","EC_F450_Brush"]) then
			{
				_pressure = _source getVariable["pressure","low"];
				_shouldMag =  switch (_pressure) do
				{
					case "high": {"A3PL_High_Pressure_Water_Mag"};
					case "medium": {"A3PL_Medium_Pressure_Water_Mag"};
					case "low": {"A3PL_Low_Pressure_Water_Mag"};
				};
			};
			if (_hasMag isNotEqualTo _shouldMag) then
			{
				player addMagazine _shouldMag;
				player addWeapon _nozzleClass;
			};
			private _bullets = player ammo _nozzleClass;
			private _shouldBullets = 0;
			if (!isNull _source) then
			{
				_shouldBullets = if (typeOf _source IN ["A3PL_Pierce_Pumper","A3FL_T440_Water_Tanker","A3PL_Silverado_FD_Brush","EC_F450_Brush"]) then {[_source,[_end,true] call A3PL_FD_FindSource] call A3PL_FD_SourceAmount} else {[_source] call A3PL_FD_SourceAmount};
				if (((_bullets - _shouldBullets > 10) OR (_bullets - _shouldBullets < -10)) OR (_shouldBullets isEqualTo 0 && {_bullets isNotEqualTo 0})) then
				{
					player setAmmo [_nozzleClass,_shouldBullets];
				};
			} else {
				if (_bullets isNotEqualTo 0) then {
					player setAmmo [_nozzleClass,0];
				};
			};
		};
		sleep 0.1;
	};
	player removeEventHandler ["Fired",A3PL_FD_PlayerFiredIndex];
	A3PL_FD_PlayerFiredIndex = nil;
	player setAmmo [_nozzleClass,0];
	player setvariable ["pressure",nil,false];
	Player_Item = objNull;
}] call compile_Global;

["A3PL_FD_WaterFiredEH",
{
	private _veh = param [0,objNull];

	if ((_veh isEqualTo player) && {currentWeapon player isNotEqualTo "A3PL_High_Pressure"}) exitwith {};

	private _inlet = [] call A3PL_Lib_AttachedFirst;
	if ((isNull _inlet) OR (!(typeOf _inlet IN ["A3PL_FD_HoseEnd1","A3PL_FD_HoseEnd2"]))) exitwith {};

	private _source = [_inlet] call A3PL_FD_FindSource;
	if(isNull _source) exitWith {};
	if(typeOf _source isEqualTo "Land_A3PL_FireHydrant") then {
		if((_source getVariable["needInspection",false])) then {
			_source setVariable["needInspection",nil,true];
			[("STR_A3PL_FD_HydrantInspected" call A3PL_Localize),Color_Green] call A3PL_Notification;
			[("STR_Common_FireDepartment" call A3PL_Localize),FD_Fire_Hydrant_Inspection_Reward] remoteExec ["Server_Government_AddBalance",2];
		};
	};

	if (!(typeOf _source IN ["A3PL_Pierce_Pumper","A3FL_T440_Water_Tanker","A3PL_Silverado_FD_Brush","EC_F450_Brush"])) exitwith {};

	private _firedCount = (missionNamespace getVariable ["A3PL_FD_FiredCount",0]) + 1;
	private _truckCapacity = switch(typeOf _source) do {
		case "A3PL_Pierce_Pumper": {1800};
		case "A3FL_T440_Water_Tanker": {5000};
		case "A3PL_Silverado_FD_Brush": {800};
        case "EC_F450_Brush": {800};
		default {0};
	};
	if (_firedCount >= 10) then
	{
		private _water = _source getVariable ["water",0];
		private _pressure = _source getVariable["pressure","low"];
		private _loose = switch(_pressure) do {
			case "high": {20};
			case "medium": {10};
			case "low": {5};
			default {5};
		};
		_new = _water - _loose;
		if(_new < 0) then {_new = 0;};
		_source setVariable ["water",_new,true];
		_source animate ["Water_Gauge1",_new / _truckCapacity];
		_firedCount = 0;
	};
	missionNamespace setVariable ["A3PL_FD_FiredCount",_firedCount];
}] call compile_Global;

["A3PL_FD_LadderHeavyLoop",
{
	private ["_veh","_sourceAmount","_inlet","_ammoWaterGun","_setZero","_otherEnd"];
	_veh = param [0,objNull];
	if ((typeOf _veh) isNotEqualTo "A3PL_Pierce_Heavy_Ladder") exitwith {};

	_filling = _veh getVariable["A3PL_FD_LadderHeavyLoopRunning",false];
	if (_filling) exitwith {};
	_veh setVariable["A3PL_FD_LadderHeavyLoopRunning",true,true];

	_i = 0;
	waitUntil {sleep 0.1; _i = _i + 0.1; if (_i > 3) exitwith {_veh animate ["ft_pump_switch",0,true]}; _veh animationPhase "ft_pump_switch" > 0};
	while {(_veh animationPhase "ft_pump_switch" > 0)} do
	{
		_end = [objNull,_veh,"inlet_r"] call A3PL_FD_FindAdapterCap;
		if (!isNull _end) then
		{
			_source = [_end] call A3PL_FD_FindSource;
			if (!isNull _source) then
			{
				_sourceAmount = [_source,_end] call A3PL_FD_SourceAmount;
				if (_sourceAmount >= 5) then
				{
					if (_veh animationPhase "ft_pump_switch" > 0.9) then
					{
						_water = _veh getVariable ["water",0];
						if (_water < 1200) then
						{
							_veh setVariable ["water",_water + 50,true];
							_veh setAmmo ["A3PL_High_Pressure_Ladder", _water + 50];
							if ((typeOf _source) isEqualTo "A3PL_Pierce_Pumper") then
							{
								_source setVariable ["water",_sourceAmount - 50,true];
								_source animate ["Water_Gauge1",(_sourceAmount - 50) / 1800];
							};
							if ((typeOf _source) isEqualTo "A3FL_T440_Water_Tanker") then
							{
								_source setVariable ["water",_sourceAmount - 50,true];
								_source animate ["Water_Gauge1",(_sourceAmount - 50) / 5000];
							};
						};						
					};
				};
			} else {
				_veh setVariable["water",0,true];
			};
		} else {
			_veh setVariable["water",0,true];
		};
		sleep 1;
	};
	_veh setVariable["A3PL_FD_LadderHeavyLoopRunning",nil,true];
}] call compile_Global;

["A3PL_FD_LadderHeavyFired",
{
	private _veh = param [0,objNull];
	private _waterLevel = _veh getVariable["water",0];
	private _ammoWaterGun = player ammo "A3PL_High_Pressure";
	private _newWaterLevel = (_waterLevel-10);
	if(_newWaterLevel < 0) then {_newWaterLevel = 0;};
	_veh setVariable["water",_newWaterLevel,true];
	if(_newWaterLevel isEqualTo 0) exitWith {_veh setAmmo ["A3PL_High_Pressure_Ladder", 0];};
}] call compile_Global;

["A3PL_FD_RollHose",
{
	private _end = param [0,objNull];
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	if (!(typeOf _end IN ["A3PL_FD_HoseEnd1","A3PL_FD_HoseEnd2","A3PL_GasHose"])) exitwith {[("STR_A3PL_FD_NotInteractingWithAdapter" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _ropes = ropes _end;
	private _hose = [_end] call A3PL_FD_FindHose;

	deleteVehicle (ropeAttachedTo _end);
	{
		deleteVehicle _x;
	} foreach (ropeAttachedObjects _end);

	deleteVehicle _end;
	["fd_hose",1] call A3PL_Inventory_Add;
	[("STR_A3PL_FD_HoseWrapped" call A3PL_Localize),Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_FD_DeployHose",
{
	private ["_adapter1","_adapter2","_rope"];
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	if (Player_ItemClass != "FD_Hose") exitwith {[("STR_A3PL_FD_NotHoldingHose" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_lengths = param [0,objNull];
	[player,objNull,Player_ItemClass] remoteExec ["Server_Inventory_Drop", 2];

	deleteVehicle Player_Item;
	Player_Item = objNull;
	Player_ItemClass = "";

	_adapter2 = createVehicle ["A3PL_FD_HoseEnd1",(player modelToWorld [0,8,0.5]), [], 0, "CAN_COLLIDE"];
	_adapter1 = createVehicle ["A3PL_FD_HoseEnd2",(player modelToWorld [0,0,0.5]), [], 0, "CAN_COLLIDE"];
	_adapter2 allowDamage false;_adapter1 allowDamage false;
	_rope = ropeCreate [_adapter1, [0,0.03,0.00], _adapter2, [0,0.03,0.00], _lengths];
}] call compile_Global;

["A3PL_FD_GasDeployHose",
{
	private ["_adapter1","_adapter2","_rope"];
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	if (Player_ItemClass != "FD_Hose") exitwith {[("STR_A3PL_FD_NotHoldingHose" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[player,objNull,Player_ItemClass] remoteExec ["Server_Inventory_Drop", 2];

	deleteVehicle Player_Item;
	Player_Item = objNull;
	Player_ItemClass = "";

	_adapter2 = createVehicle ["A3PL_GasHose",(player modelToWorld [0,5,0.5]), [], 0, "CAN_COLLIDE"];
	_adapter1 = createVehicle ["A3PL_FD_HoseEnd1",(player modelToWorld [0,0,0.5]), [], 0, "CAN_COLLIDE"];
	_adapter2 allowDamage false;_adapter1 allowDamage false;

	_rope = ropeCreate [_adapter1, [0,0.03,0.00], _adapter2, [0,0.14,0.00], 20];
}] call compile_Global;

//This function can loop through all ropes and its attached objects until it finds the other end (we then check if it's a valid water source once found)
["A3PL_FD_FindSource",
{
	private ["_end","_latestObject","_source","_otherEnd","_adapter","_hydrants","_hydrant","_m"];
	_end = param [0,objNull];
	_getAdapter = param [1,false];
	_latestObject = _end;
	_source = objNull;

	while {!isNull _latestObject} do
	{
		_m = true;
		_otherEnd = [_latestObject] call A3PL_FD_FindOtherEnd;
		if (isNull _otherEnd) exitwith {};
		_attachedTo = [_otherEnd] call A3PL_Lib_FindAttached;

		if ((typeOf _attachedTo) == "A3PL_FD_HoseEnd1_Float") exitwith
		{
			private ["_hydrants","_adapter","_hydrant"];
			_latestObject = objNull;
			_adapter = _attachedTo;
			if (isNull _adapter) exitwith {};
			_hydrants = nearestObjects [_adapter, ["Land_A3PL_FireHydrant"], 1];
			if (count _hydrants < 1) exitwith {};
			_hydrant = _hydrants select 0;
			if (typeOf _hydrant == "Land_A3PL_FireHydrant") then
			{
				_latestObject = _hydrant;
			};
		};
		if ((typeOf _attachedTo) IN ["A3PL_Pierce_Pumper","A3PL_Tanker_Trailer","A3PL_Fuel_Van","A3PL_Silverado_FD_Brush","EC_F450_Brush","A3FL_T440_Gas_Tanker","A3FL_T440_Water_Tanker"]) exitwith {
			_latestObject = _attachedTo;
		};
		if ((typeOf _attachedTo) == "A3PL_FD_yAdapter") then
		{
			_otherEnd = (attachedTo _otherEnd) getVariable ["inlet",objNull];
			_m = false;
		};
		if ((typeOf _attachedTo) IN ["A3PL_FD_HoseEnd1","A3PL_FD_HoseEnd2"]) then
		{
			_otherEnd = _attachedTo;
		} else {
			if (_m) then {
				_otherEnd = objNull;
			};
		};
		_latestObject = _otherEnd;
	};

	if (_getAdapter) exitwith {_otherEnd};
	if (typeOf _latestObject in ["Land_A3PL_FireHydrant","A3PL_Pierce_Pumper","A3PL_Tanker_Trailer","A3PL_Silverado_FD_Brush","EC_F450_Brush","A3PL_Fuel_Van","A3FL_T440_Gas_Tanker","A3FL_T440_Water_Tanker"]) then {
		_source = _latestObject;
	} else {
		_source = objNull;
	};
	_source;
}] call compile_Global;

["A3PL_FD_SourceAmount",
{
	private _amount = 0;
	private _source = param [0,objNull];
	private _end = param [1,objNull];
	if (isNull _source) exitwith {_amount;};
	switch (typeOf _source) do {
		case "Land_A3PL_FireHydrant": {
			private _wrench = nearestObjects [_source, ["A3PL_FD_HydrantWrench_F"], 1];
			if (count(_wrench) isNotEqualTo 0) then
			{
				if (_wrench#0 animationSourcePhase "WrenchRotation" > 0.5) then
				{
					_amount = 1000;
				};
			};
		};
		case "A3FL_T440_Water_Tanker": {_amount = _source getVariable ["water",0];};
		case "A3PL_Pierce_Pumper": {
			if (_source animationPhase "ft_lever_7" < 0.5) exitwith {};
			_line = [_end,_source] call A3PL_FD_FindAdapterCap;
			if (_line == "outlet_ds_cap" && (_source animationPhase "ft_lever_10" > 0.5)) then
			{
				_amount = _source getVariable ["water",0];
			};
			if (_line == "outlet_ps_cap" && (_source animationPhase "ft_lever_1" > 0.5)) then
			{
				_amount = _source getVariable ["water",0];
			};
		};
		case "A3PL_Silverado_FD_Brush": {
			if (_source animationPhase "ft_pump_switch" < 0.5) exitwith {};
			_line = [_end,_source] call A3PL_FD_FindAdapterCap;
			if (_line == "outlet_bt_1_cap" && (_source animationPhase "bt_lever_3" > 0.5)) then
			{
				_amount = _source getVariable ["water",0];
			};
			if (_line == "outlet_bt_2_cap" && (_source animationPhase "bt_lever_2" > 0.5)) then
			{
				_amount = _source getVariable ["water",0];
			};
		};
        case "EC_F450_Brush": {
            if (_source animationPhase "ft_pump_switch" < 0.5) exitwith {};
            _line = [_end,_source] call A3PL_FD_FindAdapterCap;
			if (_line == "outlet_ds_cap" && (_source animationPhase "bt_lever_2" > 0.5)) then
			{
				_amount = _source getVariable ["water",0];
			};
			if (_line == "outlet_ps_cap" && (_source animationPhase "bt_lever_2" > 0.5)) then
			{
				_amount = _source getVariable ["water",0];
			};
        };
		default {_amount = 0;};
	};
	_amount;
}] call compile_Global;

["A3PL_FD_ChangeTruckPressure",
{
	private _engine = _this select 0;
	private _currentPressure = _engine getvariable ["pressure","high"];
	private _newPressure = switch (_currentPressure) do {
		case ("high"): {"medium"}; //medium
		case ("medium"): {"low"}; //low
		case ("low"): {"high"}; //high
		default {"low"};
	};
	private _pressureText = switch (_newPressure) do {
		case ("high"): {("STR_A3PL_FD_PressureHigh" call A3PL_Localize)};
		case ("medium"): {("STR_A3PL_FD_PressureMedium" call A3PL_Localize)};
		case ("low"): {("STR_A3PL_FD_PressureLow" call A3PL_Localize)};
		default {("STR_A3PL_FD_PressureLow" call A3PL_Localize)};
	};
	[format[("STR_A3PL_FD_WaterPressureChanged" call A3PL_Localize),_pressureText],Color_Red] call A3PL_Notification;
	_engine setvariable ["pressure",_newPressure,false];
}] call compile_Global;

["A3PL_FD_EngineLoop",
{
	private ["_veh","_end","_water","_source","_sourceAmount","_i"];
	_veh = param [0,objNull];

	_filling = _veh getVariable["A3PL_FD_EngineLoopRunning",false];
	if (_filling) exitwith {};
	_veh setVariable["A3PL_FD_EngineLoopRunning",true,true];

	_i = 0;
	waitUntil {sleep 0.1; _i = _i + 0.1; if (_i > 3) exitwith {_veh animate ["ft_lever_8",0,true]}; _veh animationPhase "ft_lever_8" > 0};
	while {(_veh animationPhase "ft_lever_8" > 0)} do
	{
		_end = [objNull,_veh,"inlet_ds"] call A3PL_FD_FindAdapterCap;
		if (!isNull _end) then
		{
			_source = [_end] call A3PL_FD_FindSource;
			if (!isNull _source) then
			{
				_sourceAmount = [_source] call A3PL_FD_SourceAmount;
				if (_sourceAmount > 0) then
				{
					if (_veh animationPhase "ft_lever_8" > 0.9 && _veh animationPhase "ft_lever_11" > 0.9 && _veh animationPhase "FT_Pump_Switch" > 0.9) then
					{
						_water = _veh getVariable ["water",0];
						_sWater = _source getVariable ["water",0];
						if (_water < 1800) then
						{
							_veh setVariable ["water",_water + 10,true];
							_veh animate ["Water_Gauge1",(_water + 10) / 1800];
						};
						if (typeOf _source isEqualTo "A3PL_Pierce_Pumper") then
						{
							_source setVariable ["water",_sWater - 10,true];
							_source animate ["Water_Gauge1",(_sWater - 10) / 1800];
						};
						if (typeOf _source isEqualTo "A3FL_T440_Water_Tanker") then
						{
							_source setVariable ["water",_sWater - 10,true];
							_source animate ["Water_Gauge1",(_sWater - 10) / 5000];
						};
						if (typeOf _source isEqualTo "A3PL_Silverado_FD_Brush") then
						{
							_source setVariable ["water",_sWater - 10,true];
							_source animate ["Water_Gauge1",(_sWater - 10) / 800];
						};
                        if (typeOf _source isEqualTo "EC_F450_Brush") then
                        {
                            _source setVariable ["water",_sWater - 10,true];
                            _source animate ["Water_Gauge1",(_sWater - 10) / 800];
                        };
					};
				};
			};
		};
		sleep 1;
	};
	_veh setVariable["A3PL_FD_EngineLoopRunning",nil,true];
}] call compile_Global;

["A3PL_FD_BrushLoop",
{
	private ["_veh","_end","_water","_source","_sourceAmount","_i"];
	_veh = param [0,objNull];

	_filling = _veh getVariable["A3PL_FD_BrushLoopRunning",false];
	if (_filling) exitwith {};
	_veh setVariable["A3PL_FD_BrushLoopRunning",true,true];

	_i = 0;
	waitUntil {sleep 0.1; _i = _i + 0.1; if (_i > 3) exitwith {_veh animate ["bt_lever_1",0,true]}; _veh animationPhase "bt_lever_1" > 0;};
	while {(_veh animationPhase "bt_lever_1" > 0)} do
	{
		_end = [objNull,_veh,"inlet_bt"] call A3PL_FD_FindAdapterCap;
		if (!isNull _end) then
		{
			_source = [_end] call A3PL_FD_FindSource;
			if (!isNull _source) then
			{
				_sourceAmount = [_source] call A3PL_FD_SourceAmount;
				if (_sourceAmount >= 5) then
				{
					if (_veh animationPhase "bt_lever_1" > 0.9 && _veh animationPhase "ft_pump_switch" > 0.9) then {
						_water = _veh getVariable ["water",0];
						_sWater = _source getVariable ["water",0];
						if (_water < 800) then
						{
							_veh setVariable ["water",_water + 10,true];
							_veh animate ["Water_Gauge1",(_water + 10) / 800];
						};
						if (typeOf _source isEqualTo "A3PL_Pierce_Pumper") then
						{
							_source setVariable ["water",_sWater - 10,true];
							_source animate ["Water_Gauge1",(_sWater - 10) / 1800];
						};
						if (typeOf _source isEqualTo "A3FL_T440_Water_Tanker") then
						{
							_source setVariable ["water",_sWater - 10,true];
							_source animate ["Water_Gauge1",(_sWater - 10) / 5000];
						};
						if (typeOf _source isEqualTo "A3PL_Silverado_FD_Brush") then
						{
							_source setVariable ["water",_sWater - 10,true];
							_source animate ["Water_Gauge1",(_sWater - 10) / 800];
						};
                        if (typeOf _source isEqualTo "EC_F450_Brush") then
                        {
                            _source setVariable ["water",_sWater - 10,true];
                            _source animate ["Water_Gauge1",(_sWater - 10) / 800];
                        };
					};
				};
			};
		};
		sleep 1;
	};
	_veh setVariable["A3PL_FD_BrushLoopRunning",nil,true];
}] call compile_Global;

["A3PL_FD_TankerLoop",
{
	private ["_end","_water","_source"];
	private _veh = param [0,objNull];
	private _sourceAmount = 0;

	if (_veh getVariable["A3PL_FD_TankerLoopRunning",false]) exitwith {};
	_veh setVariable["A3PL_FD_TankerLoopRunning",true,true];

	sleep 3;
	while {(_veh animationPhase "FT_Pump_Switch" > 0)} do
	{
		_end = [objNull,_veh,"inlet_ds"] call A3PL_FD_FindAdapterCap;
		if(isNull _end) then {_end = [objNull,_veh,"inlet_ds"] call A3PL_FD_FindAdapterCap;};
		if (!isNull _end) then
		{
			_source = [_end] call A3PL_FD_FindSource;
			if (!isNull _source) then
			{
				_sourceAmount = [_source] call A3PL_FD_SourceAmount;
				if (_sourceAmount > 0) then
				{
					_water = _veh getVariable ["water",0];
					_sWater = _source getVariable ["water",0];
					if (_water < 5000) then
					{
						_veh setVariable ["water",_water + 25,true];
						_veh animate ["Water_Gauge1",(_water + 25) / 5000];
					};
					if (typeOf _source isEqualTo "A3PL_Pierce_Pumper") then
					{
						_source setVariable ["water",_sWater - 25,true];
						_source animate ["Water_Gauge1",(_sWater - 25) / 1800];
					};
					if (typeOf _source isEqualTo "A3FL_T440_Water_Tanker") then
					{
						_source setVariable ["water",_sWater - 25,true];
						_source animate ["Water_Gauge1",(_sWater - 25) / 5000];
					};
					if (typeOf _source isEqualTo "A3PL_Silverado_FD_Brush") then
					{
						_source setVariable ["water",_sWater - 25,true];
						_source animate ["Water_Gauge1",(_sWater - 25) / 800];
					};
                    if (typeOf _source isEqualTo "EC_F450_Brush") then
                    {
                        _source setVariable ["water",_sWater - 25,true];
                        _source animate ["Water_Gauge1",(_sWater - 25) / 800];
                    };
				};
			};
		};
		sleep 1;
	};
	_veh setVariable["A3PL_FD_TankerLoopRunning",nil,true];
}] call compile_Global;

["A3PL_FD_MaskOff",
{
	if (goggles player != "A3PL_FD_Mask") exitwith {[("STR_A3PL_FD_NotWearingOxygenMask" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	removegoggles player;
	["fd_mask",1] call A3PL_Inventory_Add;
	[("STR_A3PL_FD_OxygenMaskRemoved" call A3PL_Localize),Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_FD_MaskOn", {
	private _mask = missionNamespace getVariable ["player_item",objNull];

	if (player_itemClass isNotEqualTo "fd_mask") exitwith {[("STR_A3PL_FD_NoMask" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	["fd_mask",-1] call A3PL_Inventory_Add;

	removegoggles player;
	if !(isNull _mask) then {
		_mask attachto [player,[-0.12,-0.15,-0.73],"RightHand"];
		player playaction "gesture_maskon";
	};
	[_mask] spawn
	{
		disableSerialization;
		private ["_mask","_overlay","_currentOverlay"];
		_mask = param [0,objNull];

		uiSleep 2.5;
		if !(isNull _mask) then {
			deleteVehicle _mask;
		};
		player_item = objNull;
		player_itemClass = "";
		player addgoggles "A3PL_FD_Mask";
		["\A3PL_Common\HUD\mask\mask_normal.paa",0,0] call A3PL_HUD_SetOverlay;

		player setvariable ["Overlay_Dirt",0,false];
		_overlay = "\A3PL_Common\HUD\mask\mask_normal.paa";
		_currentOverlay = "\A3PL_Common\HUD\mask\mask_normal.paa";
		while {goggles player == "A3PL_FD_Mask"} do
		{
			uiSleep 2;
			_dirtLevel = player getVariable ["Overlay_Dirt",0];
			if (_dirtLevel < 100) then {_overlay = "\A3PL_Common\HUD\mask\mask_normal.paa";};
			if (_dirtLevel >= 100) then { _overlay = "\A3PL_Common\HUD\mask\mask_dirt1.paa"; };
			if (_dirtLevel >= 150) then { _overlay = "\A3PL_Common\HUD\mask\mask_dirt2.paa"; };
			player setvariable ["Overlay_Dirt",_dirtLevel + 1,false];
			if (_currentOverlay != _overlay) then
			{
				_currentOverlay = _overlay;
				[_overlay,0,0] call A3PL_HUD_SetOverlay;
			};
		};
		["",0,0] call A3PL_HUD_SetOverlay;
	};
}] call compile_Global;

["A3PL_FD_SwipeMask",
{
	player playaction "gesture_headswipe";
	player setvariable ["Overlay_Dirt",0,false];
}] call compile_Global;

["A3PL_FD_FireAlarm",
{
	if(!(call A3PL_Player_AntiSpam) && !isDedicated) exitWith {};
	private _building = param [0,objNull];
	private _namePos = [getPos _building] call A3PL_Housing_PosAddress;
	private _fifr = [("STR_Common_FIFR" call A3PL_Localize)] call A3PL_Lib_FactionPlayers;
	private _fisd = [("STR_Common_FISD" call A3PL_Localize)] call A3PL_Lib_FactionPlayers;
	_building setVariable["FireAlarm",true,true];	
	if (((round random 100) > 85) && (_building getVariable["FireAlarmCanBroke",true])) then {
		_building setVariable["FireAlarmBroke",true,true];
		[("STR_A3PL_FD_FireAlarmBroken" call A3PL_Localize),Color_Red] call A3PL_Notification;
	} else {
		[_building,"A3PL_Common\effects\firealarm.ogg", 30, 250, 4] spawn A3PL_FD_AlarmLoop;
		[("STR_A3PL_FD_AlarmTriggered" call A3PL_Localize),Color_Green] call A3PL_Notification;
		[("STR_Common_FIFR" call A3PL_Localize),("STR_A3PL_FD_FireAlarm" call A3PL_Localize),getPos _building,format[("STR_A3PL_FD_AlarmTriggeredAt" call A3PL_Localize),_namePos],("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
		[("STR_Common_FISD" call A3PL_Localize),("STR_A3PL_FD_FireAlarm" call A3PL_Localize),getPos _building,format[("STR_A3PL_FD_AlarmTriggeredAt" call A3PL_Localize),_namePos],("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
		[position _building, format[" %1",("STR_A3PL_FD_FireAlarm" call A3PL_Localize)],"Default","A3FL_Markers_Fire",300] remoteExec ["A3PL_Lib_CreateMarker",_fifr];
		[position _building, format[" %1",("STR_A3PL_FD_FireAlarm" call A3PL_Localize)],"Default","A3FL_Markers_Fire",300] remoteExec ["A3PL_Lib_CreateMarker",_fisd];
		[position _building] remoteExec ["A3PL_GPS_NavigateToPosition",_fifr];
		[position _building] remoteExec ["A3PL_GPS_NavigateToPosition",_fisd];
		["A3PL_Common\effects\firecall.ogg",150,2,10] spawn A3PL_FD_FireStationAlarm;
		sleep 300;
	};
}] call compile_Global;

["A3PL_FD_AlarmLoop",
{
	private _building = param [0,objNull];
	private _alarm = param [1,""];
	private _loop = param [2,30];
	private _dist = param [3,200];
	private _sound = param [4,5];
	private _sleep = switch(_alarm) do {
		case "A3PL_Common\effects\firealarm.ogg": {3.4};
		case "A3PL_Common\effects\airalarm.ogg": {0};
		case "A3PL_Common\effects\firecall.ogg": {4.17};
		default {0};
	};
	for "_i" from 0 to _loop do {
		playSound3D [_alarm, _building, false, getPosASL _building, _sound, 1, _dist];
		sleep _sleep;
	};
}] call compile_Global;

["A3PL_FD_SetFireAlarm",
{
	private _building = param [0,objNull];
	if(_building getVariable ["FireAlarmBroke",false]) exitWith {[("STR_A3PL_FD_AlarmBroken" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if(_building getVariable ["FireAlarm",false]) then {
		_building setVariable["FireAlarm",false,true];
		playSound3D ["A3PL_Common\effects\firealarm.ogg", _building, false, getPosASL _building, 5, 1, 200];
		[("STR_Common_FireDepartment" call A3PL_Localize),FD_Set_Alarm_Reward] remoteExec ["Server_Government_AddBalance",2];
	} else {
		[("STR_A3PL_FD_AlarmAlreadyTriggered" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};
}] call compile_Global;

["A3PL_FD_CheckFireAlarm",
{
	private _building = param [0,objNull];
	if (((round random 100) > 85) && (_building getVariable["FireAlarmCanBroke",true])) then {
		_building setVariable["FireAlarmBroke",true,true];
		[("STR_A3PL_FD_FireAlarmBroken" call A3PL_Localize),Color_Red] call A3PL_Notification;
		[("STR_Common_FireDepartment" call A3PL_Localize),FD_Check_Alarm_Deffect_Reward] remoteExec ["Server_Government_AddBalance",2];
	} else {
		playSound3D ["A3PL_Common\effects\firealarm.ogg", _building, false, getPosASL _building, 2, 1, 100];
		_building setVariable["FireAlarmCanBroke",false,true];
		[("STR_A3PL_FD_AlarmWorking" call A3PL_Localize),Color_Green] call A3PL_Notification;
		[("STR_Common_FireDepartment" call A3PL_Localize),FD_Check_Alarm_Work_Reward] remoteExec ["Server_Government_AddBalance",2];
	};
}] call compile_Global;

["A3PL_FD_RepairFireAlarm",
{
	private _building = param [0,objNull];
	if(_building getVariable ["FireAlarmBroke",false]) then {
		if (Player_ActionDoing) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		[("STR_A3PL_FD_AlarmRepairing" call A3PL_Localize),FD_Time_To_Repair_Alarm] spawn A3PL_Lib_LoadAction;
		waitUntil{Player_ActionDoing};
		player playMoveNow 'Acts_carFixingWheel';
		while { Player_ActionDoing } do {
			if !(player getVariable["A3PL_Medical_Alive",true]) exitWith {Player_ActionInterrupted=true;};
			if ((vehicle player) isNotEqualTo player) exitwith {Player_ActionInterrupted=true;};
			if ((animationstate player) != "Acts_carFixingWheel") then {player playMoveNow 'Acts_carFixingWheel';};
		};
		if(Player_ActionInterrupted) exitWith {[("STR_Common_ActionInterrupted" call A3PL_Localize),Color_Red] call A3PL_Notification;};

		_building setVariable["FireAlarmBroke",false,true];
		_building setVariable["FireAlarmCanBroke",false,true];
		[("STR_Common_FireDepartment" call A3PL_Localize),FD_Repair_Alarm_Reward] remoteExec ["Server_Government_AddBalance",2];
		[("STR_A3PL_FD_AlarmRepaired" call A3PL_Localize),Color_Green] call A3PL_Notification;
	} else {
		[("STR_A3PL_FD_AlarmNotBroken" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};
}] call compile_Global;

["A3PL_FD_FireStationAlarm",
{
	private _alarm = param [0,"A3PL_Common\effects\firecall.ogg"];
	private _distance = param [1,100];
	private _loop = param [2,0];
	private _sound = param [3,5];
	{
		[_x,_alarm,_loop,_distance,_sound] spawn A3PL_FD_AlarmLoop;
	} foreach nearestObjects[[worldSize/2,worldSize/2,0], ["Land_A3PL_Firestation","Land_FYD_Firestation"], 5000000];
}] call compile_Global;

['A3PL_FD_ShowHydrant',{
	private _FireHydrants = nearestobjects [player,["Land_A3PL_FireHydrant"], 800];
	private _markersList = [];
	{
		_var = ((str(_x)splitString " :") select 1) splitString "";
		_hydrantID = format["%1%2",_var#1, _var#2];
		_marker = createMarkerLocal [format ["firehydrant_%1",_hydrantID], (getpos _x)];
		_marker setMarkerShapeLocal "ICON";
		_marker setMarkerTypeLocal "A3FL_Markers_Hydrant";
		_marker setMarkerTextLocal format[("STR_A3PL_FD_Hydrant" call A3PL_Localize),_hydrantID];
		_marker setMarkerColorLocal "Default";
		_marker setMarkerSizeLocal [0.7, 0.7];
		_marker setMarkerAlphaLocal 1;

		_markersList pushBack (_marker);
	} forEach _FireHydrants;
	uiSleep 120;
	{deleteMarkerLocal _x;} forEach _markersList;
}] call compile_Global;

["A3PL_FD_ThrowHose", {
	private _obj = Player_Item;
	private _itemClass = Player_ItemClass;
	if (isNull _obj) exitwith {[("STR_A3PL_FD_NoItemToThrow" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!isNil "Player_isEating") exitwith {[("STR_A3PL_FD_NoActionWhileEating" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	player playaction "Gesture_throw";
	uiSleep 0.5;

	detach _obj;
	private _playerVelocity = velocity player;
	private _playerDir = direction player;

	_obj setVelocity [((_playerVelocity select 0) + (sin _playerDir * 7)), ((_playerVelocity select 1) + (cos _playerDir * 7)), ((_playerVelocity select 2) + 7)];
	[player,_obj,_itemClass] remoteExec ["Server_Inventory_Drop", 2];

	Player_Item = objNull;
	Player_ItemClass = '';
}] call compile_Global;

["A3PL_FD_Beeper", {
	private _message = _this#0;
	private _mode = _this#1;
	private _dest = _this#2;
	switch (_mode) do {
		case 0 : {
			{
				if(["fifrvfd",_x] call A3PL_DMV_Check) then {
					[format[("STR_A3PL_FD_VFDBeeper" call A3PL_Localize),_message],Color_red,true] remoteExec ["A3PL_Notification",_x];
					[format[("STR_A3PL_FD_VFDBeeper" call A3PL_Localize),_message],Color_red,true] remoteExec ["A3PL_Notification",_x];
					[format[("STR_A3PL_FD_VFDBeeper" call A3PL_Localize),_message],Color_red,true] remoteExec ["A3PL_Notification",_x];
					_beeper = createSoundSource ["A3PL_Beeper", [0,0,0], [], 0];
					_beeper attachTo [_x, [0,0,0]];
					uiSleep 2;
					deleteVehicle _beeper;
				};
			} forEach allPlayers;
		};
		case 1 : {
			{
				if(((_x getVariable ["name","unknown"]) isEqualto _dest) && ((_x getVariable ["faction","citizen"]) isEqualTo ("STR_Common_FIFR" call A3PL_Localize))) then {
					[format[("STR_A3PL_FD_FIFRBeeper" call A3PL_Localize),_message],Color_red,true] remoteExec ["A3PL_Notification",_x];
					[format[("STR_A3PL_FD_FIFRBeeper" call A3PL_Localize),_message],Color_red,true] remoteExec ["A3PL_Notification",_x];
					[format[("STR_A3PL_FD_FIFRBeeper" call A3PL_Localize),_message],Color_red,true] remoteExec ["A3PL_Notification",_x];
					_beeper = createSoundSource ["A3PL_Beeper", [0,0,0], [], 0];
					_beeper attachTo [_x, [0,0,0]];
					uiSleep 2;
					deleteVehicle _beeper;
				};
			} forEach allPlayers;
		};
		case 2 : {
			{
				if((_x getVariable ["faction","citizen"]) isEqualTo ("STR_Common_FIFR" call A3PL_Localize)) then {
					[format[("STR_A3PL_FD_FIFRBeeper" call A3PL_Localize),_message],Color_red,true] remoteExec ["A3PL_Notification",_x];
					[format[("STR_A3PL_FD_FIFRBeeper" call A3PL_Localize),_message],Color_red,true] remoteExec ["A3PL_Notification",_x];
					[format[("STR_A3PL_FD_FIFRBeeper" call A3PL_Localize),_message],Color_red,true] remoteExec ["A3PL_Notification",_x];
					_beeper = createSoundSource ["A3PL_Beeper", [0,0,0], [], 0];
					_beeper attachTo [_x, [0,0,0]];
					uiSleep 2;
					deleteVehicle _beeper;
				};
			} forEach allPlayers;
		};
		case 3 : {
			[_message,0,""] spawn A3PL_FD_Beeper;
			[_message,2,""] spawn A3PL_FD_Beeper;
		};
	};
}] call compile_Global;

["A3PL_FD_ControlLadder", {
	keysEVH =
	{
		_key = _this select 1;
		_return = false;
		switch _key do
		{
			case 201:
			{
				_val = vehicle player animationSourcePhase "ladder_extend";
				_valu = _val + 0.00625;
				if (_valu >= 1) then {_valu = 1};
				vehicle player animateSource ["ladder_extend",_valu];
				_return = true;
			};
			case 209:
			{
				_val = vehicle player animationSourcePhase "ladder_extend";
				_valu = _val - 0.00625;
				if (_valu <= 0) then {_valu = 0};
				vehicle player animateSource ["ladder_extend",_valu];
				_return = true;
			};
		};
		_return;
	};
	waituntil {!isNull findDisplay 46};
	_keysEVH = (findDisplay 46) DisplayAddEventHandler ["keydown","_this call keysEVH"];
	waitUntil {(vehicle player) isEqualTo player};
	(findDisplay 46) displayremoveeventhandler ["keydown",_keysEVH];
}] call compile_Global;

["A3PL_FD_ResetLadder", {
	private _vehicle = vehicle player;
	player action ["eject", (_vehicle)];
	sleep 1;
	_vehicle animateSource ["ladder_extend", 0, 0.03];
	waitUntil {(_vehicle animationSourcePhase "ladder_extend") == 0};
	private _unit = group player createUnit ["B_soldier_F", [12630.4,1695.34,0.00143886], [], 0, "FORM"]; 
	[_unit,true] remoteExec ["A3PL_Lib_HideObject", 2];
	sleep 0.5; 
	_unit moveInTurret [_vehicle, [0]];
	sleep 0.5;
	private _relpos = _vehicle getRelPos [100, 0]; 
	_unit doWatch _relpos; 
	private _startTime = time;
	waitUntil {sleep 1; ((deg(_vehicle animationPhase "ladder_lift") < 1) && ((deg(_vehicle animationSourcePhase "Turntable_Spin") < 1) && (deg(_vehicle animationPhase "Turntable_Spin") > -1))) || (time - _startTime) >= 50};
	sleep 1;  
	unassignVehicle _unit; 
	deleteVehicle _unit; 
}] call compile_Global;

["A3PL_FD_BlueprintBuy",
{
	[] spawn {
		private _action = [format[("STR_A3PL_FD_FIFRBlueprint" call A3PL_Localize),GOV_Faction_Blueprint_Price]] call A3PL_Lib_ConfirmationDialog;
		if (!isNil "_action" && {!_action}) exitWith {};

		private _factionBalance = [player] call A3PL_Government_MyFactionBalance;
		if(_factionBalance < GOV_Faction_Blueprint_Price) exitwith {[("STR_A3PL_FD_BlueprintNoMoney" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		[_factionBalance,-GOV_Faction_Blueprint_Price,"",("STR_Common_BlueprintPurchase" call A3PL_Localize)] remoteExec ["Server_Government_AddBalance",2];

		["blueprint_fifr",1] call A3PL_Inventory_Add;
	};
}] call compile_Global;