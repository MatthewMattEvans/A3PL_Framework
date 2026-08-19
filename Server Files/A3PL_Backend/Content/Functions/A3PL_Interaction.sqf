/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Interaction_loadInteraction",
{
	if !(canSuspend) exitWith {
		_this spawn A3PL_Interaction_loadInteraction;
	};

	disableSerialization;

	params[["_target",objNull,[objNull]]];

	A3PL_Interaction_actionList = [];
	A3PL_Interaction_overflowList = [];
	A3PL_Interaction_Current = [];

	A3PL_Interaction_selected = -1;

	A3PL_Interaction_Current append A3PL_Interaction_Self;
	
	if (Player_ItemClass isNotEqualTo "") then {
		A3PL_Interaction_Current append A3PL_Interaction_Items;
	};

	if (isPlayer cursorTarget) then {
		A3PL_Interaction_Current append A3PL_Interaction_Players;
	};

	if (cursorTarget isKindOf "House" || {cursorObject isKindOf "House"}) then {
		A3PL_Interaction_Current append A3PL_Interaction_Building;
	};

	if ((vehicle player) isnotequalto player) then {
		A3PL_Interaction_Current append A3PL_Interaction_VehIn;
	};

	if ((cursorTarget isKindOf "car") || (cursorTarget isKindOf "plane") || (cursorTarget isKindOf "helicopter") || (cursorObject isKindOf "ship") || (cursorTarget isKindOf "air") || (cursorTarget isKindOf "tank")) then {
		A3PL_Interaction_Current append A3PL_Interaction_VehOut;
	};

	if (!(isNull cursorObject)) then {
		A3PL_Interaction_Current append A3PL_Interaction_Other;
	};
	
	{
		_title = _x#0;
		_action = _x#1;
		_condition = _x#2;
		if ((call _condition)) then {
			if (count A3PL_Interaction_actionList >= 7) then {
				A3PL_Interaction_overflowList pushBack [_title,_action];
			} else {
				A3PL_Interaction_actionList pushBack [_title,_action];
			};
		};
	} forEach A3PL_Interaction_Current;

	A3PL_Interaction_Current = [];
	_otherOptions = false;

	if(count A3PL_Interaction_overflowList > 0) then {
		if(count A3PL_Interaction_overflowList < 2) then {
			A3PL_Interaction_actionList pushBack [(A3PL_Interaction_overflowList select 0 select 0),(A3PL_Interaction_overflowList select 0 select 1)];
		} else {
			_otherOptions = true;
			A3PL_Interaction_actionList pushBack ["STR_A3PL_Interaction_More" call A3PL_Localize,{}];
		};
	};

	if(count A3PL_Interaction_actionList < 1) exitWith {};

	closeDialog 0;
	createDialog "Dialog_Interaction_Menu";

	waitUntil {!(isNull (findDisplay 1000))};

	if((vehicle player) isKindOf "Plane") then {(vehicle player) setAirplaneThrottle (airplaneThrottle (vehicle player))};

	_idd = 1001;
	{
		ctrlSetText[_idd,(_x select 0) call A3PL_Localize];
		_idd = _idd + 1;
	} forEach A3PL_Interaction_actionList;

	[] spawn A3PL_Interaction_checkRelease;

	if (_otherOptions) then {
		private _ctrl = ((findDisplay 1000) displayCtrl 1008);
		_ctrl ctrlSetTextColor [1, 0.545, 0, 1];
	};

}] call compile_Global;

["A3PL_Interaction_loadMoreInteractions",
{
	if !((A3PL_Interaction_actionList#7)#0 isEqualTo ("STR_A3PL_Interaction_More" call A3PL_Localize)) exitWith {};

	A3PL_Interaction_actionList = [];
	_idd = 1001;

	for "_i" from 0 to 7 do {
		ctrlSetText[_idd,""];
		_idd = _idd + 1;
	};

	private _ctrl = ((findDisplay 1000) displayCtrl 1008);
	_ctrl ctrlSetTextColor [1, 1, 1, 1];

	_idd = 1001;

	{
		ctrlSetText[_idd,(_x select 0) call A3PL_Localize];
		_idd = _idd + 1;
		A3PL_Interaction_actionList pushBack _x;
	} forEach A3PL_Interaction_overflowList;

	buttonSetAction[7007,""];
}] call compile_Global;

//Quick actions located in config\QuickActions
['A3PL_Interaction_ActionKey',
{
	private _interObj = Player_ObjIntersect;
	private _attachedObjects = [] call A3PL_Lib_Attached;
	private _classObj = typeOf _interObj;
	if (player distance (Player_ObjIntersect modelToWorld (Player_ObjIntersect selectionPosition Player_NameIntersect)) >= 5) exitwith {};
	if (isNull Player_Item && {(count (_attachedObjects) > 0)}) exitwith
	{
		_interObj = ([] call A3PL_Lib_Attached)#0;
		if (([_interObj] call A3PL_lib_CheckIfFurniture) && {_interObj IN _attachedObjects}) exitwith {call A3PL_Placeables_QuickAction;};
		if (typeOf _interObj IN Config_Placeables) exitwith {call A3PL_Placeables_QuickAction;};
	};
	private _config = (Player_NameIntersect call A3PL_Intersect_ConditionCalc);
	private _action = {};
	private _interNameRaw =  if ((count _config) isEqualTo 0 || Player_selectedIntersect >= count _config) then {""} else {(_config#Player_selectedIntersect)#0};
	private _interName = if (_interNameRaw isEqualType []) then {
		if (count _interNameRaw >= 2) then {
			private _base = _interNameRaw#0;
			private _param = _interNameRaw#1;
			private _num = if (_param select [0, 11] == "STR_Common_") then {
				_param select [11]
			} else {
				_param
			};
			_base + _num
		} else {
			if (count _interNameRaw > 0) then { _interNameRaw#0 } else { "" }
		}
	} else {
		_interNameRaw
	};
	{
		private _checkClass = if(_x#0 isEqualTo "") then {false} else {true};
		if (_interName isEqualTo _x#1 && !_checkClass) exitWith {_action = _x#2};
		if (_interName isEqualTo _x#1 && _checkClass && {_classObj isEqualTo _x#0}) exitWith {_action = _x#2};
	} forEach Config_QuickActions;
	call _action;
}] call compile_Global;

["A3PL_Interaction_MouseEnter", {
	params [
		["_value", -1, [-1]],
		["_idc", 0, [0]],
		["_action", "", [""]]
	];

	A3PL_Interaction_selected = _value;
	ctrlSetText[_idc, _action];
}] call compile_Global;

["A3PL_Interaction_MouseExit", {
	params [
		["_idc", 0, [0]],
		["_action", "", [""]]
	];

	A3PL_Interaction_selected = -1;
	ctrlSetText[_idc, _action];
}] call compile_Global;

["A3PL_Interaction_checkRelease", {
	if !(canSuspend) exitWith {
		_this spawn A3PL_Interaction_checkRelease;
	};

	waitUntil {isNull (findDisplay 1000)};
	if (A3PL_Interaction_selected isEqualTo -1) exitWith {};
	if(A3PL_Interaction_selected > ((count A3PL_Interaction_actionList)-1)) exitWith {};
	_action = (A3PL_Interaction_actionList#A3PL_Interaction_selected)#1;
	call _action;
}] call compile_Global;