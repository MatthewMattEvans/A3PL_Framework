/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Moonshine_Grind", {
	params [
		["_output","",[""]],
		["_mixer",objNull,[objNull]]
	];
	
    // private _trailer = nearestObjects [getPos player,["Land_A3FL_Trailer","Land_A3FL_Trailer_2","Land_A3FL_Trailer_3","Land_A3FL_Trailer_4","Land_A3FL_Trailer_5","Land_A3FL_Trailer_6"],10];

	// if (count(_trailer) isEqualTo 0) exitWith {[("STR_Common_Mobilhome" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	// private _chid = ((_trailer#0) getVariable ["doorid",[[],""]])#1;
	// if (!(_chid IN (player getVariable "keys"))) exitWith {[("STR_Common_MobilhomeOwnership" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _input = objNull;
	private _nearby = nearestObjects [_mixer,["A3PL_Sack","A3PL_CornCob"],5];

	switch (_output) do {
		case ("malt"): {
			{
				if (_x getVariable ["class",""] isEqualTo "wheat") exitWith {_input = _x;};
			} forEach _nearby;
		};
		case ("yeast"): {
			{
				if (_x getVariable ["class",""] isEqualTo "wheat") exitWith {_input = _x;};
			} forEach _nearby;
		};
		case ("cornmeal"): {
			{
				if (_x getVariable ["class",""] isEqualTo "corn") exitWith {_input = _x;};
			} forEach _nearby;
		};
	};

	if (isNull _input) exitWith {[("STR_A3PL_Moonshine_NothingToGrind" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (Player_ActionDoing) exitWith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (Player_ItemClass isNotEqualTo "") exitWith {[("STR_A3PL_Moonshine_DropItems" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	[format [("STR_A3PL_Moonshine_Grinding" call A3PL_Localize),_output],Moonshine_Grind_Timer] spawn A3PL_Lib_LoadAction;
	_input setVariable ["inUse",true,true];
	waitUntil{Player_ActionDoing};
	while {Player_ActionDoing} do {
		if (!(player getVariable["A3PL_Medical_Alive",true])) exitWith {Player_ActionInterrupted = true;};
		if ((vehicle player) isNotEqualTo player) exitWith {Player_ActionInterrupted = true;};
		if (player getVariable ["Incapacitated",false]) exitwith {Player_ActionInterrupted = true;};
		if ((player distance2D _mixer) > 15) exitwith {Player_ActionInterrupted = true;};
	};
	if (Player_ActionInterrupted) exitWith {
		[("STR_A3PL_Moonshine_GrindingInterrupted" call A3PL_Localize),Color_Red] call A3PL_Notification;
		_input setVariable ["inUse",nil,true];
	};

	private _grindOutput = createVehicle [format["A3PL_Grainsack_%1",_output],getPosATL _input, [], 0, "CAN_COLLIDE"];
	deleteVehicle _input;
	_grindOutput setVariable ["owner",(player getVariable ["character_id",""]),true];
	_grindOutput setVariable ["class",_output,true];

	[getPlayerUID player,(player getVariable ["character_id",""]),"Moonshine_Grind",[format["Grinding: %1",_output]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

["A3PL_Moonshine_InstallHose", {
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
    // private _trailer = nearestObjects [getPos player,["Land_A3FL_Trailer","Land_A3FL_Trailer_2","Land_A3FL_Trailer_3","Land_A3FL_Trailer_4","Land_A3FL_Trailer_5","Land_A3FL_Trailer_6"],10];

	// if (count(_trailer) isEqualTo 0) exitWith {[("STR_Common_Mobilhome" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	// private _chid = ((_trailer#0) getVariable ["doorid",[[],""]])#1;
	// if (!(_chid IN (player getVariable "keys"))) exitWith {[("STR_Common_MobilhomeOwnership" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    params [["_distillery",objNull,[objNull]]];

	private _hoses = _distillery nearEntities [["A3PL_Distillery_Hose"],5];
	if ((count _hoses) < 1) exitWith {[("STR_A3PL_Moonshine_HoseNotFound" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _hose = _hoses#0;
	if (Player_ItemClass isNotEqualTo "") exitWith {[("STR_A3PL_Moonshine_DropItems" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_hose attachTo [_distillery,[-0.53,0.48,-0.3]];
	[getPlayerUID player,(player getVariable ["character_id",""]),"Moonshine_InstallHose",["Hose connected to distillery"]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

["A3PL_Moonshine_InstallJug", {
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
    // private _trailer = nearestObjects [getPos player,["Land_A3FL_Trailer","Land_A3FL_Trailer_2","Land_A3FL_Trailer_3","Land_A3FL_Trailer_4","Land_A3FL_Trailer_5","Land_A3FL_Trailer_6"],10];

	// if (count(_trailer) isEqualTo 0) exitWith {[("STR_Common_Mobilhome" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	// private _chid = ((_trailer#0) getVariable ["doorid",[[],""]])#1;
	// if (!(_chid IN (player getVariable "keys"))) exitWith {[("STR_Common_MobilhomeOwnership" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    params [["_hose",objNull,[objNull]]];

	private _jugs = _hose nearEntities [["A3PL_Jug","A3PL_Jug_Green"],5];
	if ((count _jugs) < 1) exitwith {[("STR_A3PL_Moonshine_JugNotFound" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _jug = _jugs#0;
	if (Player_ItemClass isNotEqualTo "") exitWith {[("STR_A3PL_Moonshine_DropItems" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_jug attachTo [_hose,[-0.2,-0.17,-0.57]];
	[getPlayerUID player,(player getVariable ["character_id",""]),"Moonshine_InstallJug",["Jug connected to distillery hose"]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

["A3PL_Moonshine_AddItem", {
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
    // private _trailer = nearestObjects [getPos player,["Land_A3FL_Trailer","Land_A3FL_Trailer_2","Land_A3FL_Trailer_3","Land_A3FL_Trailer_4","Land_A3FL_Trailer_5","Land_A3FL_Trailer_6"],10];

	// if (count(_trailer) isEqualTo 0) exitWith {[("STR_Common_Mobilhome" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	// private _chid = ((_trailer#0) getVariable ["doorid",[[],""]])#1;
	// if (!(_chid IN (player getVariable "keys"))) exitWith {[("STR_Common_MobilhomeOwnership" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    params [["_distillery",objNull,[objNull]]];
	private _nearby = _distillery nearEntities [["A3PL_Grainsack_Malt","A3PL_Grainsack_Yeast","A3PL_Grainsack_CornMeal"],5];

	if (count _nearby < 1) exitwith {[("STR_A3PL_Moonshine_IngredientsNotFound" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _itemToAdd = _nearby#0;
	private _itemClass = _itemToAdd getVariable ["class",""];
	private _distilleryItems = _distillery getVariable ["items",[]];
	if (_itemClass IN _distilleryItems) exitWith {[format [("STR_A3PL_Moonshine_AlreadyInDistillery" call A3PL_Localize),_itemClass],Color_Red] call A3PL_Notification;};

	deleteVehicle _itemToAdd;
	_distilleryItems pushBack _itemClass;
	_distillery setVariable ["items",_distilleryItems,true];
	[format [("STR_A3PL_Moonshine_AddedItem" call A3PL_Localize),_itemClass],Color_Green] call A3PL_Notification;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Moonshine_AddItem",[format["Item added: %1 | Total items: %2",_itemClass,_distilleryItems]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

["A3PL_Moonshine_CheckStatus", {
	params [["_distillery",objNull,[objNull]]];
	if (!(_distillery getVariable ["running",false])) exitwith {[("STR_A3PL_Moonshine_NotRunning" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[format [("STR_A3PL_Moonshine_TimeLeft" call A3PL_Localize),(_distillery getVariable ["timeleft",180])],Color_Green] call A3PL_Notification;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Moonshine_CheckStatus",[format["Seconds remaining: %1",(_distillery getVariable ["timeleft",180])]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

["A3PL_Moonshine_Start", {
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
    // private _trailer = nearestObjects [getPos player,["Land_A3FL_Trailer","Land_A3FL_Trailer_2","Land_A3FL_Trailer_3","Land_A3FL_Trailer_4","Land_A3FL_Trailer_5","Land_A3FL_Trailer_6"],10];

	// if (count(_trailer) isEqualTo 0) exitWith {[("STR_Common_Mobilhome" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	// private _chid = ((_trailer#0) getVariable ["doorid",[[],""]])#1;
	// if (!(_chid IN (player getVariable "keys"))) exitWith {[("STR_Common_MobilhomeOwnership" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    params [["_distillery",objNull,[objNull]]];

	if (_distillery getVariable ["running",false]) exitwith {[("STR_A3PL_Moonshine_AlreadyProducing" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _distilleryItems = _distillery getVariable ["items",[]];
	if (!("malt" IN _distilleryItems)) exitWith {[("STR_A3PL_Moonshine_NeedMalt" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!("yeast" IN _distilleryItems)) exitWith {[("STR_A3PL_Moonshine_NeedYeast" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!("cornmeal" IN _distilleryItems)) exitWith {[("STR_A3PL_Moonshine_NeedCornmeal" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if ((count ([_distillery] call A3PL_Lib_AttachedAll)) < 1) exitWith {[("STR_A3PL_Moonshine_NeedHose" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _hose = ([_distillery] call A3PL_Lib_AttachedAll)#0;
	if ((count ([_hose] call A3PL_Lib_AttachedAll)) < 1) exitWith {[("STR_A3PL_Moonshine_NeedJug" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _jug = ([_hose] call A3PL_Lib_AttachedAll)#0;

	_distillery setVariable ["running",true,true];
	private _distilleryPos = getPos _distillery;
	private _sound = createSoundSource ["A3PL_Boiling", _distilleryPos, [], 0];

	private _timeLeft = Moonshine_Transformation_Timer;
	_distillery setVariable ["timeLeft",_timeLeft,true];
	private _success = false;

	while {(_timeLeft > 0) && (_distillery getVariable ["running",false])} do {
		if (_distilleryPos isNotEqualTo (getPos _distillery)) then {
			_distilleryPos = getPos _distillery;
			_sound setPos _distilleryPos;
		};
		if ((count ([_distillery] call A3PL_Lib_AttachedAll))< 1) exitwith {[("STR_A3PL_Moonshine_HoseRemoved" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		if ((count ([_hose] call A3PL_Lib_AttachedAll)) < 1) exitwith {[("STR_A3PL_Moonshine_JugRemoved" call A3PL_Localize),Color_Red] call A3PL_Notification;};

		_timeLeft = _timeLeft - 1;
		_distillery setVariable ["timeLeft",_timeLeft,true];
		if (_timeLeft < 1) exitWith {_success = true;};
		uiSleep 1;
	};

	_distillery setVariable ["running",nil,true];
	deleteVehicle _sound;
	private _charID = (player getVariable ["character_id",""]);
	if (!_success) exitWith {
		[("STR_A3PL_Moonshine_ProductionFailed" call A3PL_Localize),Color_Red] call A3PL_Notification;
		[getPlayerUID player,_charID,"Moonshine_Start",[format["Production failed"]]] remoteExec ["Server_Log_New",2];
	};

	private _traits = player getVariable ["Player_Traits", []];
	private _hasMoonshineTrait = "moonshine" in _traits;
	private _luckyBonus = ([_traits] call A3PL_Traits_GetLuckyBonus) / 100;
	private _chance = if (_hasMoonshineTrait) then {0.35 + _luckyBonus} else {_luckyBonus};
	if (_chance > 0 && {(random 1) < _chance}) then {
		private _ingredients = ["malt","yeast","cornmeal"];
		private _savedItem = selectRandom _ingredients;
		_distillery setVariable ["items",[_savedItem],true];
		private _savedItemName = [_savedItem,"name"] call A3PL_Config_GetItem;
		[format [("STR_A3PL_Moonshine_IngredientSaved" call A3PL_Localize),_savedItemName],Color_Green] call A3PL_Notification;
	} else {
		_distillery setVariable ["items",nil,true];
	};
	private _position = getPosATL _jug;
	deleteVehicle _jug;
	private _newJug = createVehicle ["A3PL_Jug_Corked",_position,[],0,"CAN_COLLIDE"];
	_newJug setVariable ["owner",_charID,true];
	_newJug setVariable ["class","jug_moonshine",true];
	["moonshine"] call PO_Achievement_Learn;
	[("STR_A3PL_Moonshine_ProductionFinished" call A3PL_Localize),Color_Green] call A3PL_Notification;
	[getPlayerUID player,_charID,"Moonshine_Start",["Moonshine Production successful | Amount: 1"]] remoteExec ["Server_Log_New",2];
}] call compile_Global;
