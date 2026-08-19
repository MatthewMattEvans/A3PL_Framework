/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Intersect_ConditionCalc", {
	params [["_intersect",nil,[""]]];

	private _intersectMap = Config_IntersectMap;
	private _intersectData = _intersectMap get _intersect;
	private _toShow = [];

	{
		if (call (_x#2)) then {
			_toShow pushback _x;
		};
	} foreach _intersectData;
	_toShow;
}] call compile_Global;

["A3PL_Intersect_Spikes", {
	private _vehicle = vehicle player;
	private _spiked = _vehicle getVariable ["spiked",false];
	if (_spiked) exitWith {};
	private _spike = ((_vehicle nearEntities ["A3FL_Stinger",3]) select 0);
	_vehicle setVariable ["spiked",true,true];
	[_vehicle,_spike] remoteExec ["A3PL_Police_SpikeHit",_vehicle];
}] call compile_Global;

//To-Dev : ["A3PL_Intersect_Lines", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
["A3PL_Intersect_Lines", {
	if (isDedicated) exitwith {};
	["A3PL_Intersect_Lines", "onEachFrame", {
		private _exit = false;
		private _veh = vehicle player;
		if(_veh isNotEqualTo player) then {
			if(count(_veh nearEntities ["A3FL_Stinger",3]) > 0) then {
			    call A3PL_Intersect_Spikes;
			};
			if(speed _veh > 800) exitWith {_exit=true;};
		};
		if(_exit) exitWith {};

		private _interColor = [1,1,1,1];

		// Verifier GroundWeaponHolder en priorite avec cursorObject (plus rapide que cursorTarget)
		private _cur = cursorObject;
		if ((!isNull _cur) && {(player distance _cur) < 4} && {"GroundWeaponHolder" isEqualTo (typeOf _cur)}) exitWith {
			Player_ObjIntersect = _cur;
			if (Player_NameIntersect isNotEqualTo "GroundWeaponHolder") then {Player_selectedIntersect = 0;};
			Player_NameIntersect = "GroundWeaponHolder";

			private _posAGL = getPosATL _cur;
			private _config = "GroundWeaponHolder" call A3PL_Intersect_ConditionCalc;
			private _countConfig = (count _config) - 1;
			if (_countConfig < 0) exitWith {};
			if (Player_selectedIntersect > _countConfig) then {
				Player_selectedIntersect = _countConfig;
			};

			private _configSel = _config#Player_selectedIntersect;
			private _name = format ["→ %1 ←",((_configSel#0) call A3PL_Localize)];
			drawIcon3D [_configSel#1, _interColor, _posAGL, 1, 1, 0, _name, 2, 0.06, "PuristaBold"];

			if (_countConfig > Player_selectedIntersect) then {
				_posAGL = [_posAGL#0, _posAGL#1, (_posAGL#2) - 0.3];
				_configSel = _config#(Player_selectedIntersect + 1);
				drawIcon3D ["", _interColor, _posAGL, 0, 0, 0, ((_configSel#0) call A3PL_Localize), 1, 0.036, "PuristaSemiBold", "center", false, 0, 0.045];
			};
			if (Player_selectedIntersect > 0) then {
				_posAGL = [_posAGL#0, _posAGL#1, (_posAGL#2) + 0.3];
				_configSel = _config#(Player_selectedIntersect - 1);
				drawIcon3D ["", _interColor, _posAGL, 0, 0, 0, ((_configSel#0) call A3PL_Localize), 1, 0.036, "PuristaSemiBold", "center", false, 0, 0.045];
			};
		};

		private _lod = if(_veh isKindOf "Car" || {cursorObject isKindOf "Car"}) then {"VIEW"} else {"FIRE"};
		private _begPos = positionCameraToWorld [0,0,0];
		private _begPosASL = AGLToASL _begPos;
		private _endPos = positionCameraToWorld [0,0,5];
		private _endPosASL = AGLToASL _endPos;
		private _ins = lineIntersectsSurfaces [_begPosASL, _endPosASL, player, driver(vehicle player), true, 1, _lod, "NONE"];

		if (_ins isEqualTo []) exitWith {};
		_ins#0 params ["_pos", "_norm", "_obj", "_parent"];

		if (isNull _obj) exitwith {
			private _cur = cursorTarget;
			if ((!isNull cursorTarget) && {(player distance _cur) < 4}) exitwith {
				Player_ObjIntersect = cursorTarget;
				Player_NameIntersect = "";
				if ("GroundWeaponHolder" isEqualTo (typeOf _cur)) then {
					drawIcon3D ["\a3\ui_f\data\gui\cfg\Hints\gear_ca.paa", _interColor, getPosATL _cur, 1, 1, 0,("STR_A3PL_Intersect_Equipment" call A3PL_Localize), 2, 0.06, "PuristaBold"];
				};
			};
			Player_ObjIntersect = player;
			Player_NameIntersect = "";
		};

		if (!(getModelInfo _parent#2) && ((player distance _obj) < 5)) exitWith {
			Player_NameIntersect = "";
			Player_ObjIntersect = _obj;
			{
				if (_x#0 == (typeOf _obj)) then {
					_realPos = if(surfaceIsWater position _obj) then {getPosASLVisual _obj} else {getPosATLVisual _obj};
					drawIcon3D [_x#2, _interColor, _realPos, 1, 1, 0, ((_x#1) call A3PL_Localize), 2, 0.06, "PuristaBold"];
				};
			} foreach Config_Intersect_NoName;
		};
		if(!(getModelInfo _parent#2)) exitWith {};

		private _lod = if(_parent isKindOf "Car") then {"VIEW"} else {"FIRE"};
		private _ins2 = [_parent, _lod] intersect [_begPos, _endPos];
		if (_ins2 isEqualTo []) exitWith {
			Player_NameIntersect = "";
			Player_ObjIntersect = _veh;
		};

		_ins2#0 params ["_name", "_dist"];
		private _selPos = _obj selectionPosition [_name,"Memory"];
		if (_selPos isEqualTo [0,0,0] && {["door", _name] call BIS_fnc_inString}) exitwith {
			Player_NameIntersect = "";
			Player_ObjIntersect = _obj;
		};
		if (Player_NameIntersect isNotEqualTo _name) then {Player_selectedIntersect = 0;};

		Player_NameIntersect = _name;
		Player_ObjIntersect = _obj;

		private _posAGL = _obj modelToWorldVisual _selPos;
		private _config = _name call A3PL_Intersect_ConditionCalc;
		private _countConfig = (count _config) - 1;
		if (_countConfig < 0) exitWith {};
		if (Player_selectedIntersect > _countConfig) then {
			Player_selectedIntersect = _countConfig;
		};

		private _configSel = _config#Player_selectedIntersect;
		private _name = format ["→ %1 ←",((_configSel#0) call A3PL_Localize)];
		drawIcon3D [_configSel#1, _interColor, _posAGL, 1, 1, 0,_name, 2, 0.06, "PuristaBold"];

		if (_countConfig > Player_selectedIntersect) then {
			_posAGL = [_posAGL#0,_posAGL#1, (_posAGL#2) - ((_begPosASL distance _posAGL) / 50)];
			_configSel = _config#(Player_selectedIntersect + 1);
			drawIcon3D ["", _interColor, _posAGL, 0, 0, 0,((_configSel#0) call A3PL_Localize), 1, 0.036, "PuristaSemiBold","center",false,0,0.045];
		};
		if (Player_selectedIntersect > 0) then {
			_posAGL = [_posAGL#0,_posAGL#1, (_posAGL#2) + ((_begPosASL distance _posAGL) / 35)];
			_configSel = _config#(Player_selectedIntersect - 1);
			drawIcon3D ["", _interColor, _posAGL, 0, 0, 0,((_configSel#0) call A3PL_Localize), 1, 0.036, "PuristaSemiBold","center",false,0,-0.045];
		};
	}] call BIS_fnc_addStackedEventHandler;
}] call compile_Global;

['A3PL_Intersect_HandleDoors', {
	private _obj = Player_ObjIntersect;
	private _name = Player_NameIntersect;
	private _typeOf = typeOf _obj;
	private _canSee = call A3PL_Intersect_CanSee;
	private _isKeypadOpen = false;
	private _hasKeypad = false;
	
	if (!isNil "Player_KeypadOpen" && {Player_KeypadOpen}) then {
		_isKeypadOpen = true;
	};
	
	private _keypadVarName = format ["keypad_%1", _name];
	if (!isNil {_obj getVariable _keypadVarName} && {_obj getVariable _keypadVarName}) then {
		_hasKeypad = true;
	};

	if (!_canSee && {_typeOf isEqualTo "Land_A3PL_Prison"}) exitwith {["STR_A3PL_Intersect_CantDoThis" call A3PL_Localize,Color_Red] call A3PL_Notification;};	
	if (_typeOf isEqualTo "Land_A3FL_Fishers_Jewelry") exitwith {[_obj,_name] call A3PL_Jewelry_HandleDoor;};
	if (_typeOf isEqualTo "Land_A3PL_Prison") exitwith {[_obj,_name] call A3PL_Prison_HandleDoor;};
	if (_typeOf isEqualTo "Land_A3FL_DOC_Gate") exitwith {[_obj,_name] call A3PL_PrisonGate_HandleDoor;};
	if (_typeOf isEqualTo "Land_A3FL_DOC_Warehouse") exitwith {[_obj,_name] call A3PL_Prison_HandleWarehouse;};
	if (_typeOf IN ["Land_A3FL_DOC_Wall_Tower","Land_A3FL_DOC_Wall_Tower_Corner"]) exitwith {[_obj,_name] call A3PL_PrisonTower_HandleDoor;};
	if ((_typeOf isEqualTo "Land_A3FL_Better_Buy") && {_name IN ["door_5_button","door_5_button2"]}) exitwith {[_obj,"Door_5",false] call A3PL_Lib_ToggleAnimation;};
	if (_typeOf isEqualTo "Land_EC_PersonGate") exitWith {
		[_obj,"gate",false] call A3PL_Lib_ToggleAnimation;
		if (_isKeypadOpen) then {
			[_obj, "gate"] spawn {
				params ["_obj", "_doorName"];
				uiSleep 5;
				private _animPhase = _obj animationPhase _doorName;
				if (_animPhase > 0.5) then {
					[_obj, _doorName, false] call A3PL_Lib_ToggleAnimation;
				};
			};
		};
	};
	if ((_typeOf isEqualTo "Land_A3PL_ATCTower") && {!(["atc"] call A3PL_DMV_Check)}) exitWith {["STR_A3PL_Intersect_OnlyATC" call A3PL_Localize,Color_Red] call A3PL_Notification;};

	private _split = _name splitstring "_";

	if (_typeOf isEqualTo "Land_EC_DoubleVehicleGate") exitWith {
		private _gateName = "";
		if (((_split#1) find "entrance") isNotEqualTo -1) then {
			_gateName = "gate_right";
			[_obj,"gate_right",false] call A3PL_Lib_ToggleAnimation;
			if ((_obj animationPhase "gate_right" <= 0.5) && (_obj animationPhase "gate_right" >= 0)) then {
				[_obj] spawn {
					private _obj = _this select 0;
					uiSleep 15;
					_obj setObjectTextureGlobal[3,"\EC_Buildings2\Gates\Data\led_off_co.paa"];
					_obj setObjectTextureGlobal[2,"\EC_Buildings2\Gates\Data\led_green_co.paa"];
				};
			} else {
				[_obj] spawn {
					private _obj = _this select 0;
					_obj setObjectTextureGlobal[3,"\EC_Buildings2\Gates\Data\led_red_co.paa"];
					_obj setObjectTextureGlobal[2,"\EC_Buildings2\Gates\Data\led_off_co.paa"];
				};
			};
		} else {
			_gateName = "gate_left";
			[_obj,"gate_left",false] call A3PL_Lib_ToggleAnimation;
			if ((_obj animationPhase "gate_left" <= 0.5) && (_obj animationPhase "gate_left" >= 0)) then {
				[_obj] spawn {
					private _obj = _this select 0;
					uiSleep 15;
					_obj setObjectTextureGlobal[5,"\EC_Buildings2\Gates\Data\led_off_co.paa"];
					_obj setObjectTextureGlobal[4,"\EC_Buildings2\Gates\Data\led_green_co.paa"];		
				};
			} else {
				[_obj] spawn {
					private _obj = _this select 0;
					_obj setObjectTextureGlobal[5,"\EC_Buildings2\Gates\Data\led_red_co.paa"];
					_obj setObjectTextureGlobal[4,"\EC_Buildings2\Gates\Data\led_off_co.paa"];
				};
			};
		};
		if (_isKeypadOpen && _gateName != "") then {
			[_obj, _gateName] spawn {
				params ["_obj", "_doorName"];
				uiSleep 15;
				private _animPhase = _obj animationPhase _doorName;
				if (_animPhase > 0.5) then {
					[_obj, _doorName, false] call A3PL_Lib_ToggleAnimation;
				};
			};
		};
	};

	if ((((_split#0) find "garagedoor") isNotEqualTo -1) || (((_split#0) find "hangardoor") isNotEqualTo -1)) exitwith
	{
		if (_typeOf IN ["Land_Home1g_DED_Home1g_01_F","Land_Home2b_DED_Home2b_01_F","Land_Home3r_DED_Home3r_01_F","Land_Home4w_DED_Home4w_01_F","Land_Home5y_DED_Home5y_01_F","Land_Home6b_DED_Home6b_01_F","Land_A3PL_Greenhouse","Land_A3PL_Ranch3","Land_A3PL_Ranch2","Land_A3PL_Ranch1"]) exitwith
		{
			if (isNil {_obj getVariable "unlocked"}) exitwith
			{
				_format = "STR_A3PL_Intersect_GarageClosed" call A3PL_Localize;
				[_format,Color_Red] call A3PL_Notification;
			};
			if (count _split > 2) then {
				[_obj,(_split#0),false] call A3PL_Lib_ToggleAnimation;
			} else {
				[_obj,(_split#0)] call A3PL_Lib_ToggleAnimation;
			};
		};
		_canUse = true;
		switch (_typeOf) do
		{
			case ("Land_A3PL_Firestation"): {
				if (!((player getVariable ["faction","citizen"]) IN ["STR_Common_FIFR" call A3PL_Localize]) && !(["fifrvfd",player] call A3PL_DMV_Check)) exitwith {
					_canUse = false;
				};
			};
			case ("Land_FYD_Firestation"): {
				if (!((player getVariable ["faction","citizen"]) IN ["STR_Common_FIFR" call A3PL_Localize]) && !(["fifrvfd",player] call A3PL_DMV_Check)) exitwith {
					_canUse = false;
				};
			};
		};
		if (!_canUse) exitwith {["STR_A3PL_Intersect_CantUseThisDoorButton" call A3PL_Localize] call A3PL_Notification;};
		[_obj,(_split#0)] call A3PL_Lib_ToggleAnimation;
		if (_typeOf isEqualTo "Land_FYD_Firestation") then {
			[] spawn {
				private _obj = Player_ObjIntersect;
				private _name = Player_NameIntersect;
				private _split = _name splitstring "_";
				[_obj,"alarm"] call A3PL_Lib_ToggleAnimation;
				if ((_obj animationSourcePhase (_split#0) < 0.5) && (_obj animationSourcePhase (_split#0) > 0)) then {[position _obj] remoteExecCall ["Server_TrafficLight_FD"];};
				waitUntil {
					_obj animationSourcePhase (_split#0) == 0 || _obj animationSourcePhase (_split#0) == 1;
				};
				[_obj,"alarm"] call A3PL_Lib_ToggleAnimation;
			};			
		};
	};

	if ((_split#0) == "door") then
	{
		private _canUse = true;
		switch (_typeOf) do
		{
			case ("Land_Police_Headquarter"): { if ((_name IN ["door_26","door_27","door_28"]) && !((player getVariable ["job","STR_Common_Job_Unemployed" call A3PL_Localize]) IN ["STR_Common_FISD" call A3PL_Localize])) exitwith {_canUse = false}; };
			case ("Land_A3FL_SheriffPD"): { if ((_name IN ["door_10","door_11","door_12","door_15"]) && !((player getVariable ["job","STR_Common_Job_Unemployed" call A3PL_Localize]) IN ["STR_Common_FISD" call A3PL_Localize])) exitwith {_canUse = false}; };
            case ("Land_EC_SheriffHQ"): { if ((_name IN ["door_18","door_17","door_16","door_15","door_14","door_34","door_35","door_5","door_6","door_3","door_4","door_7","door_8","door_2","door_1","door_12","door_13","door_11","door_10","door_9","door_19","door_36","door_37","door_38","door_39"]) && !((player getVariable ["job","STR_Common_Job_Unemployed" call A3PL_Localize]) IN ["STR_Common_FISD" call A3PL_Localize])) exitwith {_canUse = false}; };
			case ("Land_A3PL_Sheriffpd"): { if ((_name IN ["door_3","door_4","door_11","door_18","door_19","door_20","garagedoor_button"]) && !((player getVariable ["job","STR_Common_Job_Unemployed" call A3PL_Localize]) IN ["STR_Common_FISD" call A3PL_Localize])) exitwith {_canUse = false}; };
			case ("Land_A3PL_Clinic"): { if ((_name IN ["door_3","door_4","door_5","door_6","door_7","door_8","door_9","door_10","door_11"]) && !((player getVariable ["job","STR_Common_Job_Unemployed" call A3PL_Localize]) IN ["STR_Common_FIFR" call A3PL_Localize]) && !(["fifrvfd",player] call A3PL_DMV_Check)) exitwith {_canUse = false}; };
			case ("Land_A3PL_Prison"): { if (((_name find "button") != -1) && !((player getVariable ["job","STR_Common_Job_Unemployed" call A3PL_Localize]) IN ["STR_Common_FISD" call A3PL_Localize])) exitwith {_canUse = false}; };
			case ("Land_FYD_Courthouse"): { if ((_name IN ["door_25","door_32","door_33","door_34","door_18","door_20","door_30"]) && !((player getVariable ["job","STR_Common_Job_Unemployed" call A3PL_Localize]) IN ["STR_Common_DOJ" call A3PL_Localize,"STR_Common_FISD" call A3PL_Localize])) exitwith {_canUse = false}; };
			case ("Land_A3PL_Firestation"): {
				if (!((player getVariable ["faction","citizen"]) IN ["STR_Common_FIFR" call A3PL_Localize]) && !(["fifrvfd",player] call A3PL_DMV_Check)) exitwith {
					_canUse = false;
				};
			};
			case ("Land_FYD_Firestation"): {
				if ((_name IN ["door_3","door_4","door_5","door_6","door_7","door_8","door_9","door_10","door_11","door_12","door_13","door_14","door_15","garagedoor1_button","garagedoor2_button","garagedoor2_2_button","garagedoor3_button"]) && !((player getVariable ["job","STR_Common_Job_Unemployed" call A3PL_Localize]) IN ["STR_Common_FIFR" call A3PL_Localize]) && !(["fifrvfd",player] call A3PL_DMV_Check)) exitwith {_canUse = false};
				};
		};
		if (!_canUse) exitwith {["STR_A3PL_Intersect_CantUseThisDoorButton" call A3PL_Localize] call A3PL_Notification;};

		if ((_typeOf IN ["Land_A3PL_Motel","Land_A3PL_Greenhouse"]) || {_typeOf IN Config_Houses_List} || {_typeOf IN Config_Warehouses_List} || {_typeOf IN Config_Crackhouses_List}) exitwith
		{
			switch (true) do
			{
				case (_typeOf isEqualTo "Land_A3PL_Motel"):
				{
					if (_name IN ["door_9","door_10","door_11","door_12","door_13","door_14","door_15","door_16"]) then
					{
						private _animName = format ["%1_%2",(_split select 0),(_split select 1)];
						private _animPhase = _obj animationPhase _animName;
						if (_hasKeypad && !_isKeypadOpen && _animPhase < 0.5) exitwith {["STR_A3PL_Intersect_DoorClosed" call A3PL_Localize,Color_Red] call A3PL_Notification;};
						if (!_isKeypadOpen) then {
							if ((_obj getVariable ["Door_1_locked",true])) exitwith {["STR_A3PL_Intersect_DoorClosed" call A3PL_Localize,Color_Red] call A3PL_Notification;};
							if ((_obj getVariable ["Door_2_locked",true])) exitwith {["STR_A3PL_Intersect_DoorClosed" call A3PL_Localize,Color_Red] call A3PL_Notification;};
							if ((_obj getVariable ["Door_3_locked",true])) exitwith {["STR_A3PL_Intersect_DoorClosed" call A3PL_Localize,Color_Red] call A3PL_Notification;};
							if ((_obj getVariable ["Door_4_locked",true])) exitwith {["STR_A3PL_Intersect_DoorClosed" call A3PL_Localize,Color_Red] call A3PL_Notification;};
							if ((_obj getVariable ["Door_5_locked",true])) exitwith {["STR_A3PL_Intersect_DoorClosed" call A3PL_Localize,Color_Red] call A3PL_Notification;};
							if ((_obj getVariable ["Door_6_locked",true])) exitwith {["STR_A3PL_Intersect_DoorClosed" call A3PL_Localize,Color_Red] call A3PL_Notification;};
							if ((_obj getVariable ["Door_7_locked",true])) exitwith {["STR_A3PL_Intersect_DoorClosed" call A3PL_Localize,Color_Red] call A3PL_Notification;};
							if ((_obj getVariable ["Door_8_locked",true])) exitwith {["STR_A3PL_Intersect_DoorClosed" call A3PL_Localize,Color_Red] call A3PL_Notification;};
						};
						[_obj,format ["%1_%2",(_split select 0),(_split select 1)],false] call A3PL_Lib_ToggleAnimation;
					} else
					{
						[_obj,format ["%1_%2",(_split select 0),(_split select 1)],false] call A3PL_Lib_ToggleAnimation;
					};
				};

				case (_typeOf IN ["Land_A3FL_Office_Building"]):
				{
					if (_name IN ["door_1","door_2","door_3","door_4"]) then
					{
						private _animName = format ["%1_%2",(_split select 0),(_split select 1)];
						private _animPhase = _obj animationPhase _animName;
						if (_hasKeypad && !_isKeypadOpen && _animPhase < 0.5) exitwith
						{
							_format = "STR_A3PL_Intersect_DoorClosed" call A3PL_Localize;
							[_format,Color_Red] call A3PL_Notification;
						};
						if (!_isKeypadOpen && isNil {_obj getVariable "unlocked"} && _animPhase < 0.5) exitwith
						{
							_format = "STR_A3PL_Intersect_DoorClosed" call A3PL_Localize;
							[_format,Color_Red] call A3PL_Notification;
						};

						[_obj,format ["%1_%2",(_split select 0),(_split select 1)],false] call A3PL_Lib_ToggleAnimation;
					} else
					{
						[_obj,format ["%1_%2",(_split select 0),(_split select 1)],false] call A3PL_Lib_ToggleAnimation;
					};
				};

				case (_typeOf isEqualTo "Land_A3PL_ModernHouse3"):
				{
					if (_name IN ["door_1","door_2","door_3","door_16","door_17","door_18"]) then
					{
						private _animName = format ["%1_%2",(_split select 0),(_split select 1)];
						private _animPhase = _obj animationPhase _animName;
						if (_hasKeypad && !_isKeypadOpen && _animPhase < 0.5) exitwith
						{
							_format = "STR_A3PL_Intersect_DoorClosed" call A3PL_Localize;
							[_format,Color_Red] call A3PL_Notification;
						};
						if (!_isKeypadOpen && isNil {_obj getVariable "unlocked"} && _animPhase < 0.5) exitwith
						{
							_format = "STR_A3PL_Intersect_DoorClosed" call A3PL_Localize;
							[_format,Color_Red] call A3PL_Notification;
						};

						[_obj,format ["%1_%2",(_split select 0),(_split select 1)],false] call A3PL_Lib_ToggleAnimation;
					} else
					{
						[_obj,format ["%1_%2",(_split select 0),(_split select 1)],false] call A3PL_Lib_ToggleAnimation;
					};
				};

				case (_typeOf IN ["Land_A3FL_House1_Cream","Land_A3FL_House1_Green","Land_A3FL_House1_Blue","Land_A3FL_House1_Brown","Land_A3FL_House1_Yellow","Land_A3FL_House3_Cream","Land_A3FL_House3_Green","Land_A3FL_House3_Blue","Land_A3FL_House3_Brown","Land_A3FL_House3_Yellow"]):
				{
					if (_name IN ["door_1","door_2","door_3","door_4","door_5"]) then
					{
						private _animName = format ["%1_%2",(_split select 0),(_split select 1)];
						private _animPhase = _obj animationPhase _animName;
						if (_hasKeypad && !_isKeypadOpen && _animPhase < 0.5) exitwith
						{
							_format = "STR_A3PL_Intersect_DoorClosed" call A3PL_Localize;
							[_format,Color_Red] call A3PL_Notification;
						};
						if (!_isKeypadOpen && isNil {_obj getVariable "unlocked"} && _animPhase < 0.5) exitwith
						{
							_format = "STR_A3PL_Intersect_DoorClosed" call A3PL_Localize;
							[_format,Color_Red] call A3PL_Notification;
						};
						[_obj,format ["%1_%2",(_split select 0),(_split select 1)],false] call A3PL_Lib_ToggleAnimation;
					} else {
						[_obj,format ["%1_%2",(_split select 0),(_split select 1)],false] call A3PL_Lib_ToggleAnimation;
					};
				};

				case (_typeOf IN ["Land_A3FL_Trailer","Land_A3FL_Trailer_2","Land_A3FL_Trailer_3","Land_A3FL_Trailer_4","Land_A3FL_Trailer_5","Land_A3FL_Trailer_6","Land_John_House_Grey","Land_John_House_Blue","Land_John_House_Red","Land_John_House_Green"]):
				{
					if (_name IN ["door_1","door_5"]) then
					{
						private _animName = format ["%1_%2",(_split select 0),(_split select 1)];
						private _animPhase = _obj animationPhase _animName;
						if (_hasKeypad && !_isKeypadOpen && _animPhase < 0.5) exitwith
						{
							_format = "STR_A3PL_Intersect_DoorClosed" call A3PL_Localize;
							[_format,Color_Red] call A3PL_Notification;
						};
						if (!_isKeypadOpen && isNil {_obj getVariable "unlocked"} && _animPhase < 0.5) exitwith
						{
							_format = "STR_A3PL_Intersect_DoorClosed" call A3PL_Localize;
							[_format,Color_Red] call A3PL_Notification;
						};
						[_obj,format ["%1_%2",(_split select 0),(_split select 1)],false] call A3PL_Lib_ToggleAnimation;
					} else {
						[_obj,format ["%1_%2",(_split select 0),(_split select 1)],false] call A3PL_Lib_ToggleAnimation;
					};
				};

				case (_typeOf isEqualTo "Land_A3FL_Anton_Modern_Bungalow"):
				{
					if (_name IN ["door_1","door_2","door_3","door_4"]) then
					{
						private _animName = format ["%1_%2",(_split select 0),(_split select 1)];
						private _animPhase = _obj animationPhase _animName;
						if (_hasKeypad && !_isKeypadOpen && _animPhase < 0.5) exitwith
						{
							_format = "STR_A3PL_Intersect_DoorClosed" call A3PL_Localize;
							[_format,Color_Red] call A3PL_Notification;
						};
						if (!_isKeypadOpen && isNil {_obj getVariable "unlocked"} && _animPhase < 0.5) exitwith
						{
							_format = "STR_A3PL_Intersect_DoorClosed" call A3PL_Localize;
							[_format,Color_Red] call A3PL_Notification;
						};

						[_obj,format ["%1_%2",(_split select 0),(_split select 1)],false] call A3PL_Lib_ToggleAnimation;
					} else
					{
						[_obj,format ["%1_%2",(_split select 0),(_split select 1)],false] call A3PL_Lib_ToggleAnimation;
					};
				};

				case (_typeOf isEqualTo "Land_Mansion01"):
				{
					if (_name IN ["door_8","door_1","door_9","door_2","door_3"]) then
					{
						private _animName = format ["%1_%2",(_split select 0),(_split select 1)];
						private _animPhase = _obj animationPhase _animName;
						if (_hasKeypad && !_isKeypadOpen && _animPhase < 0.5) exitwith
						{
							_format = "STR_A3PL_Intersect_DoorClosed" call A3PL_Localize;
							[_format,Color_Red] call A3PL_Notification;
						};
						if (!_isKeypadOpen && isNil {_obj getVariable "unlocked"} && _animPhase < 0.5) exitwith
						{
							_format = "STR_A3PL_Intersect_DoorClosed" call A3PL_Localize;
							[_format,Color_Red] call A3PL_Notification;
						};

						[_obj,format ["%1_%2",(_split select 0),(_split select 1)],false] call A3PL_Lib_ToggleAnimation;
					} else
					{
						[_obj,format ["%1_%2",(_split select 0),(_split select 1)],false] call A3PL_Lib_ToggleAnimation;
					};
				};

				case (_typeOf IN ["Land_A3PL_Ranch3","Land_A3PL_Ranch2","Land_A3PL_Ranch1","Land_A3PL_Greenhouse","Land_A3PL_BostonHouse","Land_A3PL_ModernHouse3","Land_A3PL_Shed2","Land_A3PL_Shed3","Land_A3PL_Shed4"]):
				{
					if (_name IN ["door_1","door_2","door_5"]) then
					{
						private _animName = format ["%1_%2",(_split select 0),(_split select 1)];
						private _animPhase = _obj animationPhase _animName;
						if (_hasKeypad && !_isKeypadOpen && _animPhase < 0.5) exitwith
						{
							_format = "STR_A3PL_Intersect_DoorClosed" call A3PL_Localize;
							[_format,Color_Red] call A3PL_Notification;
						};
						if (!_isKeypadOpen && isNil {_obj getVariable "unlocked"} && _animPhase < 0.5) exitwith
						{
							_format = "STR_A3PL_Intersect_DoorClosed" call A3PL_Localize;
							[_format,Color_Red] call A3PL_Notification;
						};
						[_obj,format ["%1_%2",(_split select 0),(_split select 1)],false] call A3PL_Lib_ToggleAnimation;
					} else
					{
						[_obj,format ["%1_%2",(_split select 0),(_split select 1)],false] call A3PL_Lib_ToggleAnimation;
					};
				};

				case (_typeOf IN ["Land_A3PL_ModernHouse1"]): {
					if (_name IN ["door_1","door_2","door_3","door_4","door_5"]) then {
						private _animName = format ["%1_%2",(_split select 0),(_split select 1)];
						private _animPhase = _obj animationPhase _animName;
						if (_hasKeypad && !_isKeypadOpen && _animPhase < 0.5) exitwith
						{
							_format = "STR_A3PL_Intersect_DoorClosed" call A3PL_Localize;
							[_format,Color_Red] call A3PL_Notification;
						};
						if (!_isKeypadOpen && isNil {_obj getVariable "unlocked"} && _animPhase < 0.5) exitwith
						{
							_format = "STR_A3PL_Intersect_DoorClosed" call A3PL_Localize;
							[_format,Color_Red] call A3PL_Notification;
						};
						[_obj,format ["%1_%2",(_split select 0),(_split select 1)],false] call A3PL_Lib_ToggleAnimation;
					} else {
						[_obj,format ["%1_%2",(_split select 0),(_split select 1)],false] call A3PL_Lib_ToggleAnimation;
					};
				};
				case (_typeOf IN ["Land_John_Hangar"]):
				{
					if (_name IN ["door_1","door_2"]) then
					{
						private _animName = format ["%1_%2",(_split select 0),(_split select 1)];
						private _animPhase = _obj animationPhase _animName;
						if (_hasKeypad && !_isKeypadOpen && _animPhase < 0.5) exitwith
						{
							_format = "STR_A3PL_Intersect_DoorClosed" call A3PL_Localize;
							[_format,Color_Red] call A3PL_Notification;
						};
						if (!_isKeypadOpen && isNil {_obj getVariable "unlocked"} && _animPhase < 0.5) exitwith
						{
							_format = "STR_A3PL_Intersect_DoorClosed" call A3PL_Localize;
							[_format,Color_Red] call A3PL_Notification;
						};

						[_obj,format ["%1_%2",(_split select 0),(_split select 1)],false] call A3PL_Lib_ToggleAnimation;
					} else
					{
						[_obj,format ["%1_%2",(_split select 0),(_split select 1)],false] call A3PL_Lib_ToggleAnimation;
					};
				};

				case (_typeOf IN ["Land_FYD_Parras_Modern_House_02"]):
				{
					if (_name IN ["door_1","door_12"]) then
					{
						private _animName = format ["%1_%2",(_split select 0),(_split select 1)];
						private _animPhase = _obj animationPhase _animName;
						if (_hasKeypad && !_isKeypadOpen && _animPhase < 0.5) exitwith
						{
							_format = "STR_A3PL_Intersect_DoorClosed" call A3PL_Localize;
							[_format,Color_Red] call A3PL_Notification;
						};
						if (!_isKeypadOpen && isNil {_obj getVariable "unlocked"} && _animPhase < 0.5) exitwith
						{
							_format = "STR_A3PL_Intersect_DoorClosed" call A3PL_Localize;
							[_format,Color_Red] call A3PL_Notification;
						};

						[_obj,format ["%1_%2",(_split select 0),(_split select 1)],false] call A3PL_Lib_ToggleAnimation;
					} else
					{
						[_obj,format ["%1_%2",(_split select 0),(_split select 1)],false] call A3PL_Lib_ToggleAnimation;
					};
				};

				case (_typeOf IN ["Land_FYD_Parras_Modern_House_03"]):
				{
					if (_name IN ["door_1","door_2","door_7","door_8","door_9","door_10"]) then
					{
						private _animName = format ["%1_%2",(_split select 0),(_split select 1)];
						private _animPhase = _obj animationPhase _animName;
						if (_hasKeypad && !_isKeypadOpen && _animPhase < 0.5) exitwith
						{
							_format = "STR_A3PL_Intersect_DoorClosed" call A3PL_Localize;
							[_format,Color_Red] call A3PL_Notification;
						};
						if (!_isKeypadOpen && isNil {_obj getVariable "unlocked"} && _animPhase < 0.5) exitwith
						{
							_format = "STR_A3PL_Intersect_DoorClosed" call A3PL_Localize;
							[_format,Color_Red] call A3PL_Notification;
						};

						[_obj,format ["%1_%2",(_split select 0),(_split select 1)],false] call A3PL_Lib_ToggleAnimation;
					} else
					{
						[_obj,format ["%1_%2",(_split select 0),(_split select 1)],false] call A3PL_Lib_ToggleAnimation;
					};
				};


				case (_typeOf IN ["Land_FYD_Parras_Modern_House"]):
				{
					if (_name IN ["door_1","door_2","door_7"]) then
					{
						private _animName = format ["%1_%2",(_split select 0),(_split select 1)];
						private _animPhase = _obj animationPhase _animName;
						if (_hasKeypad && !_isKeypadOpen && _animPhase < 0.5) exitwith
						{
							_format = "STR_A3PL_Intersect_DoorClosed" call A3PL_Localize;
							[_format,Color_Red] call A3PL_Notification;
						};
						if (!_isKeypadOpen && isNil {_obj getVariable "unlocked"} && _animPhase < 0.5) exitwith
						{
							_format = "STR_A3PL_Intersect_DoorClosed" call A3PL_Localize;
							[_format,Color_Red] call A3PL_Notification;
						};

						[_obj,format ["%1_%2",(_split select 0),(_split select 1)],false] call A3PL_Lib_ToggleAnimation;
					} else
					{
						[_obj,format ["%1_%2",(_split select 0),(_split select 1)],false] call A3PL_Lib_ToggleAnimation;
					};
				};

				case (_typeOf IN ["Land_FYD_PARRAS_BigModernHouse"]):
				{
					if (_name IN ["door_1","door_2","door_3","door_4","door_5","door_6"]) then
					{
						private _animName = format ["%1_%2",(_split select 0),(_split select 1)];
						private _animPhase = _obj animationPhase _animName;
						if (_hasKeypad && !_isKeypadOpen && _animPhase < 0.5) exitwith
						{
							_format = "STR_A3PL_Intersect_DoorClosed" call A3PL_Localize;
							[_format,Color_Red] call A3PL_Notification;
						};
						if (!_isKeypadOpen && isNil {_obj getVariable "unlocked"} && _animPhase < 0.5) exitwith
						{
							_format = "STR_A3PL_Intersect_DoorClosed" call A3PL_Localize;
							[_format,Color_Red] call A3PL_Notification;
						};

						[_obj,format ["%1_%2",(_split select 0),(_split select 1)],false] call A3PL_Lib_ToggleAnimation;
					} else
					{
						[_obj,format ["%1_%2",(_split select 0),(_split select 1)],false] call A3PL_Lib_ToggleAnimation;
					};
				};

				case (_typeOf IN Config_Houses_List):
				{
					if (_name IN ["door_1","door_2","door_3"]) then
					{
						private _animName = format ["%1_%2",(_split select 0),(_split select 1)];
						private _animPhase = _obj animationPhase _animName;
						if (_hasKeypad && !_isKeypadOpen && _animPhase < 0.5) exitwith
						{
							_format = "STR_A3PL_Intersect_DoorClosed" call A3PL_Localize;
							[_format,Color_Red] call A3PL_Notification;
						};
						if (!_isKeypadOpen && isNil {_obj getVariable "unlocked"} && _animPhase < 0.5) exitwith
						{
							_format = "STR_A3PL_Intersect_DoorClosed" call A3PL_Localize;
							[_format,Color_Red] call A3PL_Notification;
						};

						[_obj,format ["%1_%2",(_split select 0),(_split select 1)],false] call A3PL_Lib_ToggleAnimation;
					} else
					{
						[_obj,format ["%1_%2",(_split select 0),(_split select 1)],false] call A3PL_Lib_ToggleAnimation;
					};
				};

				case (_typeOf isEqualTo "Land_A3FL_Warehouse"):
				{
					if (_name IN ["door_1","door_2","door_3","door_5","door_6","door_7","door_8"]) then
					{
						private _animName = format ["%1_%2",(_split select 0),(_split select 1)];
						private _animPhase = _obj animationPhase _animName;
						if (_hasKeypad && !_isKeypadOpen && _animPhase < 0.5) exitwith
						{
							_format = "STR_A3PL_Intersect_DoorClosed" call A3PL_Localize;
							[_format,Color_Red] call A3PL_Notification;
						};
						if (!_isKeypadOpen && isNil {_obj getVariable "unlocked"} && _animPhase < 0.5) exitwith
						{
							_format = "STR_A3PL_Intersect_DoorClosed" call A3PL_Localize;
							[_format,Color_Red] call A3PL_Notification;
						};

						[_obj,format ["%1_%2",(_split select 0),(_split select 1)],false] call A3PL_Lib_ToggleAnimation;
					} else
					{
						[_obj,format ["%1_%2",(_split select 0),(_split select 1)],false] call A3PL_Lib_ToggleAnimation;
					};
				};

				case (_typeOf isEqualTo "Land_A3FL_Crackhouse"):
				{
					if (_name IN ["door_1"]) then
					{
						private _animName = format ["%1_%2",(_split select 0),(_split select 1)];
						private _animPhase = _obj animationPhase _animName;
						if (_hasKeypad && !_isKeypadOpen && _animPhase < 0.5) exitwith
						{
							_format = "STR_A3PL_Intersect_DoorClosed" call A3PL_Localize;
							[_format,Color_Red] call A3PL_Notification;
						};
						if (!_isKeypadOpen && isNil {_obj getVariable "unlocked"} && _animPhase < 0.5) exitwith
						{
							_format = "STR_A3PL_Intersect_DoorClosed" call A3PL_Localize;
							[_format,Color_Red] call A3PL_Notification;
						};

						[_obj,format ["%1_%2",(_split select 0),(_split select 1)],false] call A3PL_Lib_ToggleAnimation;
					} else
					{
						[_obj,format ["%1_%2",(_split select 0),(_split select 1)],false] call A3PL_Lib_ToggleAnimation;
					};
				};

				case (_typeOf isEqualTo "Land_"):
				{
					if (_name IN ["door_1","door_2"]) then
					{
						private _animName = format ["%1_%2",(_split select 0),(_split select 1)];
						private _animPhase = _obj animationPhase _animName;
						if (_hasKeypad && !_isKeypadOpen && _animPhase < 0.5) exitwith
						{
							_format = "STR_A3PL_Intersect_DoorClosed" call A3PL_Localize;
							[_format,Color_Red] call A3PL_Notification;
						};
						if (!_isKeypadOpen && isNil {_obj getVariable "unlocked"} && _animPhase < 0.5) exitwith
						{
							_format = "STR_A3PL_Intersect_DoorClosed" call A3PL_Localize;
							[_format,Color_Red] call A3PL_Notification;
						};
						[_obj,format ["%1_%2",(_split select 0),(_split select 1)],false] call A3PL_Lib_ToggleAnimation;
					} else
					{
						[_obj,format ["%1_%2",(_split select 0),(_split select 1)],false] call A3PL_Lib_ToggleAnimation;
					};
				};				
			};
		};
		if (_typeOf isEqualTo "A3FL_TransportContainer") exitwith {
			[_obj,format ["%1_%2",_split#0,_split#1],true] call A3PL_Lib_ToggleAnimation;
		};
		[_obj,format ["%1_%2",_split#0,_split#1],false] call A3PL_Lib_ToggleAnimation;
		if ((_name IN ["door_1_button","door_1_button2","door_2_button","door_2_button2","door_3_button","door_3_button2","door_4_button","door_4_button2","door_5_button","door_5_button2","door_6_button","door_6_button2","door_7_button","door_7_button2","door_8_button","door_8_button2","door_9_button","door_9_button2","door_10_button","door_10_button2","door_13_button","door_13_button2","door_14_button","door_14_button2","door_18_button","door_18_button2","door_20_button","door_20_button2","door_20_button2"]) && (_typeOf IN ["Land_A3PL_Sheriffpd","Land_A3FL_SheriffPD"])) then
		{
			_doorN = (parseNumber (_split select 1)) + 1;
			[_obj,format ["%1_%2",(_split select 0),_doorN],false] call A3PL_Lib_ToggleAnimation;
		};
		if ((_name IN ["door_1_button","door_1_button2","door_2_button","door_2_button2","door_6_button","door_6_button2","door_7_button","door_7_button2","door_29_button","door_29_button2"]) && (_typeOf isEqualTo "Land_Police_Headquarter")) then
		{
			[_obj,format ["%1_%2_1",_split#0,_split#1],false] call A3PL_Lib_ToggleAnimation;
			[_obj,format ["%1_%2_2",_split#0,_split#1],false] call A3PL_Lib_ToggleAnimation;
		};
		if ((_name IN ["door_1_1","door_1_2","door_7_1","door_7_2"]) && (_typeOf isEqualTo "Land_Police_Headquarter")) then
		{
			[_obj,format ["%1_%2_%3",_split#0,_split#1,_split#2],false] call A3PL_Lib_ToggleAnimation;
		};
		if(_name IN ["door_29_button","door_29_button2"] && (_typeOf isEqualTo "Land_Police_Headquarter")) then {
			[_obj,format ["%1_%2",_split#0,_split#1],true] call A3PL_Lib_ToggleAnimation;
		};
	};
	
	if (_isKeypadOpen) then {
		[_obj, _name, _split] spawn {
			params ["_obj", "_doorName", "_split"];
			uiSleep 3;
			
			private _animName = format ["%1_%2",(_split select 0),(_split select 1)];
			private _animPhase = _obj animationPhase _animName;
			if (_animPhase > 0.5) then {
				[_obj, _animName, false] call A3PL_Lib_ToggleAnimation;
			};
		};
	};
}] call compile_Global;

['A3PL_Intersect_CanSee', {
	private _begPosASL = AGLToASL (positionCameraToWorld [0,0,0]);
	private _checkPos = (Player_ObjIntersect modelToWorld (Player_ObjIntersect selectionPosition Player_NameIntersect)) vectorDiff (getCameraViewDirection player vectorMultiply 0.25);
	[false,true] select ([player, "FIRE"] checkVisibility [_begPosASL, AGLtoASL _checkPos] isEqualTo 1);
}] call compile_Global;

/*['A3FL_Intersect', {
	private _object = [vehicle player,cursorObject] select (isNull objectParent player);
	private _hasSkeleton = getModelInfo _object select 2;

	private _Config = (missionConfigFile >> "Config_Intersect" >> typeOf _object);
	if (!isClass _Config || {!_hasSkeleton}) exitWith {};
	if (_object selectionNames "Memory" isEqualTo []) exitWith {};
	//Trialing DIFF METHOD FOR INTERSECT.

}] call compile_Global;*/