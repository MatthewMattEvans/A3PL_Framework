/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Lib_isRebooting",
{
	if (isNil "A3PL_soonReboot") exitWith {false};
	A3PL_soonReboot;
}] call compile_Global;

["A3PL_Lib_ExitGame",
{
	if (isDedicated) exitWith {};
	if (dialog) then {closeDialog 0};

	params [
		["_txt", "", [""]],
		["_time", 6, [6]]
	];

	disableUserInput true;
	player enableSimulation false;

	while {_time > 0} do {
		("initLayer" call BIS_fnc_rscLayer) cutText [format [("STR_A3PL_Lib_NotWhitelisted" call A3PL_Localize), _txt, _time, if (_time > 1) then {"s"} else {""}], "BLACK FADED", 1, true];
		_time = _time - 1;
		uiSleep 1;
	};

	disableUserInput false;
	"Bye" call BIS_fnc_endMission;
}] call compile_Global;

["PO_Lib_getNearLocation", {
	_pos = [_this,0,[],[[]]] call BIS_fnc_param;
	_withPronom = [_this,1,false,[false]] call BIS_fnc_param;
	_checkSucess = [_this,2,false,[false]] call BIS_fnc_param;

	if (count _pos != 3) exitWith {};

	_CfgPathZone = "";
	_distance = 999999;

	{
		_config = (configName _x);
			
		{
			_markerVarName = getText (_x >> "markerVarName");
			_zoneSize = getNumber (_x >> "zoneSize");

			if (_pos distance2D (getMarkerPos _markerVarName) < _distance) then {
				_distance = _pos distance2D (getMarkerPos _markerVarName);
				_CfgPathZone = _x;
			};
		} forEach ("true" configClasses (missionConfigFile >> "CfgLocations" >> _config));

	} forEach ("true" configClasses (missionConfigFile >> "CfgLocations"));


	if (_CfgPathZone isEqualTo "") exitWith {};

	_textReturn = "";
	_infoPos = "";

	_markerVarName = getText (_CfgPathZone >> "markerVarName");
	_zoneSize = getNumber (_CfgPathZone >> "zoneSize");
	_displayName = getText (_CfgPathZone >> "displayName");
	_displayPronom = getText (_CfgPathZone >> "displayPronom");
	_posMarker = (getMarkerPos _markerVarName);


	switch (true) do {
		case (_pos distance2D _posMarker <= _zoneSize) : {
			_textReturn = format["%1", _displayName];

			_atl = _pos select 2;

			if (_atl <= 50 && _checkSucess) then {
				[configName(_CfgPathZone)] spawn PO_Achievement_Learn;
				["exploration"] spawn PO_Achievement_Learn;
			};
		};

		case (surfaceIsWater _pos) : {
			_textReturn = format[("STR_A3PL_Lib_Large" call A3PL_Localize), _displayName, _displayPronom];
		};

		case (_pos distance2D _posMarker < (_zoneSize + 50)) : {
			_textReturn = format[("STR_A3PL_Lib_NearOf" call A3PL_Localize), _displayName, _displayPronom];
		};

		case (_pos distance2D _posMarker > (_zoneSize + 100)) : {

			_xMark = (_posMarker select 0);
			_yMark = (_posMarker select 1);

			_xPos = (_pos select 0);
			_yPos = (_pos select 1);

			_difx = abs (_xMark - _xPos);
			_dify = abs (_yMark - _yPos);

			switch (true) do {
				case (_yPos < _yMark && _difx <= 200) : {_infoPos = ("STR_A3PL_Lib_South" call A3PL_Localize);};
				case (_yPos > _yMark && _difx <= 200) : {_infoPos = ("STR_A3PL_Lib_North" call A3PL_Localize);};

				case (_dify <= 200 && _xPos > _xMark) : {_infoPos = ("STR_A3PL_Lib_East" call A3PL_Localize);};
				case (_dify <= 200 && _xPos < _xMark) : {_infoPos = ("STR_A3PL_Lib_West" call A3PL_Localize);};

				case (_yPos > _yMark && _xPos > _xMark) : {_infoPos = ("STR_A3PL_Lib_NorthEast" call A3PL_Localize);};
				case (_yPos > _yMark && _xPos < _xMark) : {_infoPos = ("STR_A3PL_Lib_NorthWest" call A3PL_Localize);};

				case (_yPos < _yMark && _xPos > _xMark) : {_infoPos = ("STR_A3PL_Lib_SouthEast" call A3PL_Localize);};
				case (_yPos < _yMark && _xPos < _xMark) : {_infoPos = ("STR_A3PL_Lib_SouthWest" call A3PL_Localize);};

				default {}; 
			};

			_textReturn = format["%3 %2 %1", _displayName, _displayPronom, _infoPos];
		};
	};

	_textReturn;
}] call compile_Global;

["A3PL_Lib_CloseInventoryDialog",
{
	private _t = 0;
	while {isNull (findDisplay 602)} do {
		_t = _t + 0.1;
		sleep 0.1;
		if (_t > 5) exitwith {};
	};
	player setVariable ["inventory_opened", nil, true];
	closeDialog 602;
	while{dialog} do {
		closeDialog 0;
	};
}] call compile_Global;

["A3PL_Lib_isNumber", {
	params [
		["_value","",[""]]
	];
	if (_value isEqualTo "") exitWith {false};

	_arr = toArray(_value);
	_return = true;
	{
		if (_x < 48 || _x > 57) exitWith {
			_return = false;
		};
	} forEach _arr;
	_return;
}] call compile_Global;

["A3PL_Lib_SetVariable", {
	params [
		"_space",
		["_name","",[""]],
		"_value",
		["_global",false,[false]]
	];
	if (_name isEqualTo "") exitWith {};
	_space setVariable [_name,_value,_global];
}] call compile_Global;

["A3PL_Lib_NumberText", {
	params [
		["_number",0,[0]],
		["_mod",3,[0]]
	];

	private _digits = _number call BIS_fnc_numberDigits;
	private _digitsCount = count _digits - 1;

	private _modBase = _digitsCount % _mod;
	private _numberText = "";
	{
		_numberText = _numberText + str _x;
		if (_foreachindex != _digitsCount && {((_foreachindex - _modBase) % (_mod)) isEqualTo 0}) then {_numberText = _numberText + ",";};
	} forEach _digits;
	_numberText
}] call compile_Global;

["A3PL_Lib_FactionPlayers",
{
	params[["_faction",("STR_Common_Job_Unemployed" call A3PL_Localize),[""]],["_returnID",false,[false]]];
	private _factionPeople = [];
	{
		if ((_x getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] isEqualTo _faction) && ([_faction,"rank", (_x getVariable ["character_id",""])] call A3PL_Config_GetFactionRankData isNotEqualTo "Corrections")) then {
			if (_returnID) then {
				_factionPeople pushback (owner _x);
			} else {
				_factionPeople pushback _x;
			};
		};
	} foreach allPlayers;
	_factionPeople;
}] call compile_Global;

["A3PL_Lib_AllFactionPlayers",
{
	params[["_factions",[("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)],[[]]],["_returnID",false,[false]]];
	private _factionPeople = [];
	{
		if ((_x getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] IN _factions)) then {
			if (_returnID) then {
				_factionPeople pushback (owner _x);
			} else {
				_factionPeople pushback _x;
			};
		};
	} foreach allPlayers;
	_factionPeople;
}] call compile_Global;

["A3PL_Lib_UIDToObject",
{
	params[["_uid","",[""]]];
	private _player = objNull;
	{
		if ((getPlayerUID _x) isEqualTo _uid) exitwith {_player = _x;};
	} foreach allPlayers;
	_player
}] call compile_Global;

["A3PL_Lib_charIDToObject",
{
	params[["_charID","",[""]]];
	private _player = objNull;
	{
		if ((_x getVariable ["character_id",""]) isEqualTo _charID) exitwith {_player = _x;};
	} foreach allPlayers;
	_player
}] call compile_Global;

['A3LL_Lib_Eject', {
	params[["_vehicle",objNull,[objNull]]];

	if (_vehicle isEqualTo player) exitWith {};
	if !(_vehicle isKindOf "Car") exitWith {};
	if (_vehicle getVariable ["trapped",false]) exitWith {};

	moveOut player;

	sleep 0.1;

	Player_Ragdoll = true;

	private _rag = "Land_Can_V3_F" createVehicleLocal [0,0,0];
	_rag setMass 1e10;
	_rag attachTo [player, [0,0,0], "Spine3"];
	private _vel = velocity _vehicle;
	private _dir = direction _vehicle;
	private _speed = 100;
	_rag setVelocity [
		(_vel select 0) + (sin _dir * _speed),
		(_vel select 1) + (cos _dir * _speed),
		(_vel select 2)
	];
	player setDir _dir;
	player allowDamage false;
	detach _rag;
	_rag spawn {
		deleteVehicle _this;
		player allowDamage true;
	};

	[("STR_A3PL_Lib_EjectedFromYourCar" call A3PL_Localize),Color_Blue] call A3PL_Notification;

	sleep 3;

	Player_Ragdoll = false;

	waitUntil {animationState player isEqualTo "amovppnemstpsnonwnondnon"};
	if(player getVariable["Cuffed",false] || {player getVariable["Zipped",false]}) then {
		[player, "A3PL_HandsupKneelKicked"] remoteExec ["A3PL_Lib_SyncAnim",-2];
	};
}] call compile_Global;

['A3PL_Lib_Ragdoll', {
	private _shouldDropWeapon = param [0,true];
	if ((vehicle player) isNotEqualTo player) exitWith {};

	Player_Ragdoll = true;

	private _rag = "Land_Can_V3_F" createVehicleLocal [0,0,0];
	_rag setMass 1e10;
	_rag attachTo [player, [0,0,0], "Spine3"];
	_rag setVelocity [0,0,6];
	player allowDamage false;
	detach _rag;
	_rag spawn {
		deleteVehicle _this;
		player allowDamage true;
	};
	sleep 3;

	Player_Ragdoll = false;
	if(_shouldDropWeapon) then {
		private _weapon = currentWeapon player;
		if(_weapon isNotEqualTo "") then {
			private _accs = player weaponAccessories (currentWeapon player);
			player removeWeapon _weapon;
			if(isTouchingGround player) then {
				_dir = getDir player;
				_droppedWeap = createVehicle ["groundweaponHolder",(ASLToAGL getPosASL player) vectorAdd [-cos ( -25 + _dir) * 1.4,sin (-25 + _dir) * 1.4,0], [], 0, "CAN_COLLIDE"];
				_droppedWeap addWeaponWithAttachmentsCargoGlobal [[_weapon, _accs select 0, _accs select 1, _accs select 2, [], [], ""], 1];
				_droppedWeap setDir (190 + _dir);
			};
		};
	};

	waitUntil {animationState player isEqualTo "amovppnemstpsnonwnondnon"};
	if(player getVariable["Cuffed",false] || {player getVariable["Zipped",false]}) then {
		[player, "A3PL_HandsupKneelKicked"] remoteExec ["A3PL_Lib_SyncAnim",-2];
	};
}] call compile_Global;

['A3LL_Lib_Ragdoll_Tazer', {
	private _shouldDropWeapon = param [0,true];
	if ((vehicle player) isNotEqualTo player) exitWith {};

	Player_Ragdoll = true;

	private _rag = "Land_Can_V3_F" createVehicleLocal [0,0,0];
	_rag setMass 1e10;
	_rag attachTo [player, [0,0,0], "Spine3"];
	_rag setVelocity [0,0,6];
	player allowDamage false;
	detach _rag;
	_rag spawn {
		deleteVehicle _this;
		player allowDamage true;
			player setHit ["legs", 0.5];
			sleep 30;
			player setHit ["legs", 0];
	};
	sleep 3;

	Player_Ragdoll = false;
	if(_shouldDropWeapon) then {
		private _weapon = currentWeapon player;
		if(_weapon isNotEqualTo "") then {
			private _accs = player weaponAccessories (currentWeapon player);
			player removeWeapon _weapon;
			if(isTouchingGround player) then {
				_dir = getDir player;
				_droppedWeap = createVehicle ["groundweaponHolder",(ASLToAGL getPosASL player) vectorAdd [-cos ( -25 + _dir) * 1.4,sin (-25 + _dir) * 1.4,0], [], 0, "CAN_COLLIDE"];
				_droppedWeap addWeaponWithAttachmentsCargoGlobal [[_weapon, _accs select 0, _accs select 1, _accs select 2, [], [], ""], 1];
				_droppedWeap setDir (190 + _dir);
			};
		};
	};

	waitUntil {animationState player isEqualTo "amovppnemstpsnonwnondnon"};
	if(player getVariable["Cuffed",false] || {player getVariable["Zipped",false]}) then {
		[player, "A3PL_HandsupKneelKicked"] remoteExec ["A3PL_Lib_SyncAnim",-2];
	};
}] call compile_Global;

["A3PL_Lib_ChangeLocality",
{
	params [
		["_targetObj",objNull,[objNull,""]],
		["_newOwner",objNull,[objNull,""]]
	];
	if (_newOwner isEqualType "") then {_newOwner = objectFromNetId _newOwner;};
	if (_targetObj isEqualType "") then {_targetObj = objectFromNetId _targetObj;};
	_targetObj setOwner (owner _newOwner);
}] call compile_Global;

['A3PL_Lib_VerifyHunger', {
	if (Player_Hunger > 100) exitWith {Player_Hunger = 100;};
	if (Player_Hunger < 0) exitWith {Player_Hunger = 0;};
	player setVariable ["player_hunger",Player_Hunger,false];
}] call compile_Global;

['A3PL_Lib_VerifyThirst', {
	if (Player_Thirst > 100) exitWith {Player_Thirst = 100;};
	if (Player_Thirst < 0) exitWith {Player_Thirst = 0;};
	player setVariable ["player_thirst",Player_Thirst,false];
}] call compile_Global;

['A3PL_Lib_VerifyPee', {
	if (Pee_System == false) exitWith {};
	if (Player_Pee > 100) exitWith {Player_Pee = 100;};
	if (Player_Pee < 0) exitWith {Player_Pee = 0;};
	player setVariable ["player_pee",Player_Pee,false];
}] call compile_Global;

['A3PL_Lib_VerifySleep', {
	if (Sleep_System == false) exitWith {};
	if (Player_Sleep > 100) exitWith {Player_Sleep = 100;};
	if (Player_Sleep < 0) exitWith {Player_Sleep = 0;};
	player setVariable ["player_sleep",Player_Sleep,false];
}] call compile_Global;

["A3PL_Lib_SyncAnim",
{
	if (isDedicated) exitwith {};
	params[["_player",player,[objNull]],["_anim","",[""]],["_type",0]];
	switch(_type) do {
		case 0: {_player switchMove _anim;};
		case 1: {_player playMoveNow _anim;};
	};
}] call compile_Global;

['A3PL_Lib_Gesture',
{
	if (isDedicated) exitwith {};
	params[["_anim","gesture_stop",[""]],["_player",player,[objNull]]];
	_player playActionNow _anim;
	if (_player getVariable["Cuffed",false]) then {_player playActionNow "gesture_restrain";};
}] call compile_Global;

['A3PL_Lib_Sit',
{
	params[["_obj",objNull,[objNull]],["_name","",[""]]];
	if ((isNull _obj) OR (_name isEqualTo "")) exitwith {};
	private _visible = if ((typeOf _obj) IN ["Land_A3PL_Prison","Land_A3FL_DOC_Wall_Tower","Land_A3FL_DOC_Gate","Land_A3PL_Clinic","Land_A3FL_SheriffPD","Land_EC_SheriffHQ","Land_FYD_Firestation"]) then {call A3PL_Intersect_CanSee} else {true};
	if (!_visible) exitWith {[("STR_A3PL_Lib_CantSitLayIfNotVisible" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if (animationState player IN ["hubsittingchairb_idle1","hubsittingchairb_idle2","hubsittingchairb_idle3","incapacitated"]) exitwith {
		if (player getVariable["Cuffed",false] || {player getVariable["Zipped",false]}) exitWith {};
		[player,""] remoteExec ["A3PL_Lib_SyncAnim", -2];
	};

	if (animationState player isEqualTo "a3pl_bed") exitWith {
		[player,"amovppnemstpsnonwnondnon"] remoteExec ["A3PL_Lib_SyncAnim", -2];
	};

	private _objPos = (_obj modelToWorld (_obj selectionPosition _name));
	if (_obj IN ["Land_FYD_Courthouse","Land_A3PL_CH"]) then {
		switch (_obj) do {
			case "Land_FYD_Courthouse": {
				player setPos [(_objPos#0),(_objPos#1 - 0.2),(_objPos#2 - 1)];
			};
			case "Land_A3PL_CH": {
				player setPos [(_objPos#0 - 0.4),(_objPos#1),(_objPos#2 - 1)];
			};
		};
	} else {
		if (_name IN ["bed_1","bed_2","bed_3","bed_4","bed_5","bed_6","bed_7","bed_8","bed_9","bed_10","bed_11","bed_12","bed_13","bed_14"]) then {
			player setPos [((_objPos#0) + 0.1),(_objPos#1),(_objPos#2)];
		} else {
			player setPos [((_objPos#0) + 0.1),(_objPos#1),(_objPos#2 - 1)];
		};
	};
	player setDir (([(_obj modelToWorld (_obj selectionPosition _name)),(_obj modelToWorld (_obj selectionPosition format ["%1_dir",_name]))] call A3PL_Lib_RelDir));
	if (_name IN ["bed_1","bed_2","bed_3","bed_4","bed_5","bed_6","bed_7","bed_8","bed_9","bed_10","bed_11","bed_12","bed_13","bed_14"]) then {
		[player,"A3PL_Bed"] remoteExec ["A3PL_Lib_SyncAnim", -2];
	} else {
		private _r = round random 2;
		private _anim = switch (_r) do {
			case 1: {"hubsittingchairb_idle2"};
			case 2: {"hubsittingchairb_idle3"};
			default {"hubsittingchairb_idle1"};
		};
		[player,_anim] remoteExec ["A3PL_Lib_SyncAnim", -2];
		if((typeOf _obj isEqualTo "Land_A3FL_Fishers_Barbershop") && {_name IN ["seat_5","seat_6"]}) then {["Shop_Barber"] call A3PL_Shop_Open;};
	};
}] call compile_Global;

["A3PL_Lib_RelDir",
{
	private _orig = param [0,[0,0,0]];
	private _dest = param [1,[0,0,0]];
	_dir = ((((_dest select 0) - (_orig select 0)) atan2 ((_dest select 1) - (_orig select 1))) + 360) % 360;
	_dir;
}] call compile_Global;

['A3PL_Lib_MoveInPass', {
	params[
		["_veh",player,[objNull]],
		["_detain",true],
		["_index",-1]
	];
	player setVariable ["dragged",false,true];
	_veh lock 1;
	if(_index isEqualTo -1) then {player moveInCargo _veh;} else {player moveInCargo [_veh,_index];};
	_veh lock 2;
	if (_detain) then {
		[_veh] spawn {
			waituntil {vehicle player isEqualTo player};
			sleep 0.5;
			player setVelocityModelSpace [0,3,1];
		};
	};
}] call compile_Global;

["A3PL_Lib_AttachedAll",
{
	private _obj = param [0,player];
	private _attachedObjects = attachedobjects _obj;
	_attachedObjects = _attachedObjects - [objNull];
	_attachedObjects;
}] call compile_Global;

["A3PL_Lib_Attached",
{
	params[["_player",player]];
	private _attachedObjects = attachedobjects _player;
	private _return = [];
	{
		if (isNull _x) then {
			_attachedObjects = _attachedObjects - [_x];
		};
		if(typeOf _x isEqualTo "#particlesource" || typeOf _x isEqualTo "EmptyDetector") then {
			_attachedObjects = _attachedObjects - [_x];
		};
	} foreach _attachedobjects;
	if (count _attachedObjects > 1) then {
		{
			if (_forEachIndex isNotEqualTo 0) then {
				detach _x;
			};
		} foreach _attachedObjects;
	};
	if (count _attachedObjects isEqualTo 0) exitwith {_return;};
	_return = [_attachedObjects#0];
	_return;
}] call compile_Global;

["A3PL_Lib_AttachedFirst",
{
	private _attached = [] call A3PL_Lib_Attached;
	if (count _attached isEqualTo 0) exitwith {objNull;};
	_attached#0;
}] call compile_Global;

['A3PL_lib_CheckIfFurniture',
{
	params[["_obj",objNull,[objNull]]];
	private _modelname = typeOf _obj;
	private _furnitureArray = [];
	if (isNil "_modelName") exitwith {};

	{
		private _item = _x;
		private _data = _y;
		_furnitureArray pushback (_y#2);
	} foreach Config_ItemMap;
	_furnitureArray pushback "A3PL_Crate";
	_furnitureArray pushback "A3PL_Clothing";
	_furnitureArray pushback "C_IDAP_supplyCrate_F";
	if (_modelName IN _furnitureArray) exitwith {true;};
	false;
}] call compile_Global;

['A3PL_Lib_checkCollision',
{
	private ["_obj","_bb","_car","_e1","_e2","_posStart","_posEnd","_intersect"];
	_obj = _this select 0;

	_bb = boundingBoxReal _obj;
	_e1 = _bb select 0;
	_e2 = _bb select 1;

	_posStart = _e1;
	_posEnd = [_e2 select 0,_e1 select 1,_e1 select 2];
	_intersect = lineIntersectsWith [AGLTOASL (_obj modelToWorld _posStart),AGLTOASL (_obj modelToWorld _posEnd ),_obj,objNull,true];
	if (count _intersect > 0) exitwith
	{
		_intersect;
	};

	_posStart = [_e1 select 0,_e2 select 1,_e1 select 2];
	_posEnd = [_e1 select 0,_e2 select 1,_e1 select 2];
	_intersect = lineIntersectsWith [AGLTOASL (_obj modelToWorld _posStart),AGLTOASL (_obj modelToWorld _posEnd ),_obj,objNull,true];
	if (count _intersect > 0) exitwith
	{
		_intersect;
	};


	_posStart = [_e1 select 0,_e1 select 1,_e2 select 2];
	_posEnd = [_e1 select 0,_e2 select 1,_e2 select 2];
	_intersect = lineIntersectsWith [AGLTOASL (_obj modelToWorld _posStart),AGLTOASL (_obj modelToWorld _posEnd ),_obj,objNull,true];
	if (count _intersect > 0) exitwith
	{
		_intersect;
	};

	_posStart = [_e1 select 0,_e2 select 1,_e2 select 2];
	_posEnd = _e2;
	_intersect = lineIntersectsWith [AGLTOASL (_obj modelToWorld _posStart),AGLTOASL (_obj modelToWorld _posEnd ),_obj,objNull,true];
	if (count _intersect > 0) exitwith
	{
		_intersect;
	};

	_intersect = lineIntersectsWith [AGLTOASL (_obj modelToWorld _e1),AGLTOASL (_obj modelToWorld _e2),_obj,objNull,true];
	if (count _intersect > 0) exitwith
	{
		_intersect;
	};

	_intersect = lineIntersectsWith [AGLTOASL (_obj modelToWorld _e2),AGLTOASL (_obj modelToWorld _e1),_obj,objNull,true];
	if (count _intersect > 0) exitwith
	{
		_intersect;
	};
	_return = [];
	_return;
}] call compile_Global;

["A3PL_Lib_NearestMarker",
{
	params[["_objPos",[],[[],objNull]],["_filter",""]];
	private _nearm = "";
	private _nearest = 100;
	if(_objPos isEqualType objNull) then {_objPos=getPos _objPos;};
	{
		private ["_d","_fil"];
		if(_x isNotEqualTo "myGPS") then {
			_d = _objPos distance (getMarkerPos _x);
			_fil = [_filter, str(_x)] call BIS_fnc_inString;
			if (_fil && {_d < _nearest}) then {
				_nearest = _d;
				_nearm = _x;
			};
		};
	} foreach (allMapMarkers);
	_nearm;
}] call compile_Global;

["A3PL_Lib_ToggleAnimation",
{
	params[["_obj",objNull,[objNull]],["_animationName","",[""]],["_animateSource",true],["_forceOnOff",-1]];
	if (_animateSource) then {
		if (_forceOnOff isNotEqualTo -1) exitwith {_obj animateSource [_animationName,_forceOnOff];};
		if (_obj animationSourcePhase _animationName < 0.5) then {
			_obj animateSource [_animationName,1];
		} else {
			_obj animateSource [_animationName,0];
		};
	} else {
		if (_forceOnOff isNotEqualTo -1) exitwith {_obj animate [_animationName,_forceOnOff];};
		if (_obj animationPhase _animationName < 0.5) then {
			_obj animate [_animationName,1];
		} else {
			_obj animate [_animationName,0];
		};
	};
}] call compile_Global;

["A3PL_Lib_SwitchLight",
{
	params[["_obj",objNull,[objNull]],["_name","",[""]]];
	private _animName = _name splitString "_";
	if (count _animName < 2) exitwith {};
	_animName = format ["%1_%2",_animName#0,_animName#1];
	[_obj,_animName,false] call A3PL_Lib_ToggleAnimation;
}] call compile_Global;

["A3PL_Lib_FindAttached",
{
	params[["_obj",objNull,[objNull]]];
	private _otherObj = objNull;
	if (!isNull attachedTo _obj) exitwith {attachedTo _obj;};
	{_otherObj = _x;} foreach (attachedObjects _obj);
	_otherObj;
}] call compile_Global;

["A3PL_Lib_vehStringToObj",
{
	params[["_veh","",[""]]];
	private _return = objNull;
	{
		if (str _x isEqualTo _veh) exitwith {_return = _x;};
	} foreach (nearestObjects [player, [], 20]);
	_return;
}] call compile_Global;

["A3PL_Lib_HideObject",
{
	private _object = param [0,objNull];
	private _hide = param [1,true];
	if (isServer) then {
		_object hideObjectGlobal _hide;
	} else {
		_object hideObject _hide;
	};
}] call compile_Global;

["A3PL_Lib_PPEffect",
{
	private _effect = param [0,"DynamicBlur"];
	private _value = param [1,[]];
	private _priority = switch (_effect) do {
		case ("DynamicBlur"): {400;};
		case ("FilmGrain"): {2000;};
		default{400};
	};
	while {
		_effect = ppEffectCreate ["DynamicBlur", _priority];
		_effect < 0
	} do { _priority = _priority + 1;};
	_effect ppEffectEnable true;
	_effect ppEffectAdjust _value;
	_effect ppEffectCommit 0;
	_effect;
}] call compile_Global;

["A3PL_Lib_LoadAction",
{
	disableSerialization;
	params[["_text",""],["_actionTime",5]];
	private _time = 0;

	("A3PL_Hud_LoadAction" call BIS_fnc_rscLayer) cutRsc ["Dialog_HUD_LoadAction","PLAIN"];
	private _display = uiNamespace getVariable "Dialog_HUD_LoadAction";
	_display call A3PL_Dialog_Localize;
	Player_ActionDoing = true;
	_refreshSpeed = _actionTime / 100;

	private _control = _display displayCtrl 351;
	_control ctrlSetStructuredText parseText format ["<t align='center'>%1</t>",_text];
	_control = _display displayCtrl 350;
	_control progressSetPosition 0;
	_control = _display displayCtrl 352;
	_control ctrlSetStructuredText parseText "<t size='1.8' font='RobotoCondensed' align='center' color='#B8B8B8'>0%</t>";

	private _controlPosition = _display displayCtrl 350;
	while {_time < _actionTime} do
	{
		_percent = _time / _actionTime;
		_control ctrlSetStructuredText parseText format ["<t size='1.8' font='RobotoCondensed' align='center' color='#B8B8B8'>%2%1</t>","%",round(_percent*100)];
		_controlPosition progressSetPosition _percent;
		sleep _refreshSpeed;
		_time = _time + _refreshSpeed;
		if(Player_ActionInterrupted) exitWith {};
		if(!(player getVariable["A3PL_Medical_Alive",true])) exitWith {};
		if (!(vehicle player isEqualTo player)) exitwith {};
		if (player getVariable ["Incapacitated",false]) exitwith {};
		if (!alive player) exitwith {};
	};

	Player_ActionCompleted = true;
	Player_ActionDoing = false;

	("A3PL_Hud_LoadAction" call BIS_fnc_rscLayer) cutFadeOut 1;

	uiSleep 2.5;
	Player_ActionInterrupted = false;
}] call compile_Global;

["A3PL_Lib_LoadActionQTE", {
	disableSerialization;
	params[["_text",""],["_actionTime",5]];
	private _time = 0;
	private _baseActionTime = _actionTime;

	("A3PL_Hud_LoadAction" call BIS_fnc_rscLayer) cutRsc ["Dialog_HUD_LoadAction","PLAIN"];
	private _display = uiNamespace getVariable "Dialog_HUD_LoadAction";
	_display call A3PL_Dialog_Localize;
	Player_ActionDoing = true;
	_refreshSpeed = _actionTime / 100;

	private _control = _display displayCtrl 351;
	_control ctrlSetStructuredText parseText format ["<t align='center'>%1</t>",_text];
	_control = _display displayCtrl 350;
	_control progressSetPosition 0;
	_control = _display displayCtrl 352;
	_control ctrlSetStructuredText parseText "<t size='1.8' font='RobotoCondensed' align='center' color='#B8B8B8'>0%</t>";

	private _controlPosition = _display displayCtrl 350;
	private _controlPercent = _display displayCtrl 352;
	private _controlText = _display displayCtrl 351;
	
	private _progressBarPos = ctrlPosition _controlPosition;
	private _progressBarX = _progressBarPos select 0;
	private _progressBarY = _progressBarPos select 1;
	private _progressBarW = _progressBarPos select 2;
	private _progressBarH = _progressBarPos select 3;
	
	private _qteMessageCtrl = _display ctrlCreate ["RscStructuredText", 355];
	_qteMessageCtrl ctrlSetPosition [
		_progressBarX,
		_progressBarY - 0.05 * safezoneH,
		_progressBarW,
		0.04 * safezoneH
	];
	_qteMessageCtrl ctrlSetBackgroundColor [0, 0, 0, 0];
	_qteMessageCtrl ctrlSetStructuredText parseText "";
	_qteMessageCtrl ctrlCommit 0;
	
	private _qteActive = false;
	private _qteStartTime = 0;
	private _qteWindow = 0;
	private _qteNextTime = random [2, _actionTime / 3, _actionTime * 0.8];
	private _qteKeyDown = false;
	private _qteEventHandler = -1;
	private _qteZoneCtrl = controlNull;
	private _qteMarkerCtrl = controlNull;
	private _qteFailures = 0;
	
	_qteEventHandler = (findDisplay 46) displayAddEventHandler ["KeyDown", {
		params ["_display", "_key", "_shift", "_ctrl", "_alt"];
		if (_key == 57) then {
			missionNamespace setVariable ["A3PL_QTE_SpacePressed", true];
			true
		} else {
			false
		};
	}];

	while {_time < _actionTime} do {
		if (!_qteActive && _time >= _qteNextTime) then {
			_qteActive = true;
			_qteStartTime = _time;
			_qteWindow = 0.3 + random 0.3;
			missionNamespace setVariable ["A3PL_QTE_SpacePressed", false];
			playSound ["A3PL_Common\skill_sounds\skill_check_notification.ogg", 1];
			
			[("STR_A3PL_Lib_SkillCheck_PressSpace" call A3PL_Localize),Color_Orange] call A3PL_Notification;

			_percent = _time / _actionTime;
			private _qteZoneStart = _percent;
			private _qteZoneEnd = (_time + _qteWindow) / _actionTime;
			if (_qteZoneEnd > 1) then { _qteZoneEnd = 1; };
			
			_qteZoneCtrl = _display ctrlCreate ["RscText", 353];
			_qteZoneCtrl ctrlSetPosition [
				_progressBarX + (_qteZoneStart * _progressBarW),
				_progressBarY,
				(_qteZoneEnd - _qteZoneStart) * _progressBarW,
				_progressBarH
			];
			_qteZoneCtrl ctrlSetBackgroundColor [0.4, 0.15, 0.05, 0.5];
			_qteZoneCtrl ctrlSetText "";
			_qteZoneCtrl ctrlCommit 0;
			
			_qteMarkerCtrl = _display ctrlCreate ["RscText", 354];
			_qteMarkerCtrl ctrlSetPosition [
				_progressBarX + (_qteZoneStart * _progressBarW) - 0.005 * safezoneW,
				_progressBarY - 0.01 * safezoneH,
				0.01 * safezoneW,
				0.02 * safezoneH
			];
			_qteMarkerCtrl ctrlSetBackgroundColor [0.7, 0.7, 0.7, 1];
			_qteMarkerCtrl ctrlCommit 0;
		};
		
		if (_qteActive) then {
			if (missionNamespace getVariable ["A3PL_QTE_SpacePressed", false]) then {
				playSound ["A3PL_Common\skill_sounds\skill_check_success.ogg", 1];
				if (!isNull _qteZoneCtrl) then { ctrlDelete _qteZoneCtrl; };
				if (!isNull _qteMarkerCtrl) then { ctrlDelete _qteMarkerCtrl; };
				_qteMessageCtrl ctrlSetFade 0;
				_qteMessageCtrl ctrlSetStructuredText parseText ("STR_A3PL_Lib_SkillCheck_QTESuccess" call A3PL_Localize);
				_qteMessageCtrl ctrlCommit 0;
				[_qteMessageCtrl] spawn {
					params ["_ctrl"];
					uiSleep 1.5;
					_ctrl ctrlSetFade 1;
					_ctrl ctrlCommit 0.5;
					uiSleep 0.5;
					_ctrl ctrlSetStructuredText parseText "";
					_ctrl ctrlSetFade 0;
					_ctrl ctrlCommit 0;
				};
				_qteActive = false;
				missionNamespace setVariable ["A3PL_QTE_SpacePressed", false];
				_qteNextTime = _time + random [2, (_actionTime - _time) / 3, (_actionTime - _time) * 0.8];
			} else {
				private _qteElapsed = _time - _qteStartTime;
				if (_qteElapsed >= _qteWindow) then {
					_qteFailures = _qteFailures + 1;
					playSound ["A3PL_Common\skill_sounds\skill_check_failed.ogg", 1];
					if (!isNull _qteZoneCtrl) then { ctrlDelete _qteZoneCtrl; };
					if (!isNull _qteMarkerCtrl) then { ctrlDelete _qteMarkerCtrl; };
					
					if (_qteFailures > 2) then {
						Player_ActionInterrupted = true;
						_qteMessageCtrl ctrlSetFade 0;
						_qteMessageCtrl ctrlSetStructuredText parseText ("STR_A3PL_Lib_SkillCheck_QTEFailedEnd" call A3PL_Localize);
						_qteMessageCtrl ctrlCommit 0;
						[_qteMessageCtrl] spawn {
							params ["_ctrl"];
							uiSleep 2;
							_ctrl ctrlSetFade 1;
							_ctrl ctrlCommit 0.5;
							uiSleep 0.5;
						};
					} else {
						_actionTime = _actionTime + 2;
						_qteMessageCtrl ctrlSetFade 0;
						_qteMessageCtrl ctrlSetStructuredText parseText format [("STR_A3PL_Lib_SkillCheck_QTEFailedWarning" call A3PL_Localize), _qteFailures];
						_qteMessageCtrl ctrlCommit 0;
						[_qteMessageCtrl] spawn {
							params ["_ctrl"];
							uiSleep 1.5;
							_ctrl ctrlSetFade 1;
							_ctrl ctrlCommit 0.5;
							uiSleep 0.5;
							_ctrl ctrlSetStructuredText parseText "";
							_ctrl ctrlSetFade 0;
							_ctrl ctrlCommit 0;
						};
						_qteActive = false;
						missionNamespace setVariable ["A3PL_QTE_SpacePressed", false];
						_qteNextTime = _time + random [2, (_actionTime - _time) / 3, (_actionTime - _time) * 0.8];
					};
				};
			};
		};
		
		_percent = _time / _actionTime;
		_controlPercent ctrlSetStructuredText parseText format ["<t size='1.8' font='RobotoCondensed' align='center' color='%1'>%2%%</t>", if (_qteActive) then {"#FFD700"} else {"#B8B8B8"}, round(_percent*100)];
		_controlPosition progressSetPosition _percent;
		sleep _refreshSpeed;
		_time = _time + _refreshSpeed;
		
		if(Player_ActionInterrupted) exitWith {};
		if(!(player getVariable["A3PL_Medical_Alive",true])) exitWith {};
		if (!(vehicle player isEqualTo player)) exitwith {};
		if (player getVariable ["Incapacitated",false]) exitwith {};
		if (!alive player) exitwith {};
	};
	
	if (!isNull _qteZoneCtrl) then { ctrlDelete _qteZoneCtrl; };
	if (!isNull _qteMarkerCtrl) then { ctrlDelete _qteMarkerCtrl; };
	if (!isNull _qteMessageCtrl) then { ctrlDelete _qteMessageCtrl; };

	if (_qteEventHandler >= 0) then {
		(findDisplay 46) displayRemoveEventHandler ["KeyDown", _qteEventHandler];
	};

	Player_ActionCompleted = true;
	Player_ActionDoing = false;

	("A3PL_Hud_LoadAction" call BIS_fnc_rscLayer) cutFadeOut 1;

	uiSleep 2.5;
	Player_ActionInterrupted = false;
}] call compile_Global;

["A3PL_Lib_JobVehicle_Assign", {
	params [
		["_class","",[""]],
		["_pos",[],[[]]],
		["_job","",[""]],
		["_cost",0,[0]]
	];

	[_class,_pos,toUpperANSI _job,player] remoteExec ["Server_Vehicle_Spawn", 2];

	private _t = 0;
	waituntil {sleep 0.5; _t = _t + 0.5; if (_t > 5) exitwith {true;}; !isNull (player getVariable ["jobVehicle",objNull]);};
	if (isNull (player getVariable ["jobVehicle",objNull])) exitwith
	{
		[("STR_A3PL_Lib_ErrorRetakeTheJob" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};

	private _veh = player getVariable ["jobVehicle",objNull];
	if ((_job isEqualTo ("STR_Common_Job_BetterBuy" call A3PL_Localize)) && {_class isEqualTo "A3PL_P362_TowTruck"}) then {
		private _jobSkins = ["A3PL_Textures\JobVehicles\betterbuy\BestbuyTowlvl1.paa","A3PL_Textures\JobVehicles\betterbuy\BestbuyTowlvl2.paa","A3PL_Textures\JobVehicles\betterbuy\BestbuyTowlvl3.paa"];
		_veh setObjectTextureGlobal [0, (selectRandom _jobSkins)];
	};
	if ((_job isEqualTo ("STR_Common_Job_Roadworker" call A3PL_Localize)) && {_class isEqualTo "A3PL_P362_TowTruck"}) then {
		private _jobSkins = ["A3PL_Textures\JobVehicles\roadside\RoadsideLvl1.paa","A3PL_Textures\JobVehicles\roadside\RoadsideLvl2.paa","A3PL_Textures\JobVehicles\roadside\RoadsideLvl3.paa"];
		_veh setObjectTextureGlobal [0, (selectRandom _jobSkins)];
	};

	_veh setVariable ["rentCost",_cost,true];
	_veh setVariable ["rentedBy",(player getVariable["name","Unknown"]),true];

	[getPlayerUID player,(player getVariable ["character_id",""]),"rent_car_added",[format ["Cost: %1 | Class: %2 | Job: %3 | Position: %4",_cost,_class,_job,_pos]]] remoteExec ["Server_Log_New",2];

	private _job = toLowerANSI(_job);
	while {(player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) isEqualTo _job} do
	{
		if (isNull _veh) exitwith {true;};
		if ((damage _veh) >= 1) exitwith {[("STR_A3PL_Lib_VehicleDestroyed" call A3PL_Localize),Color_Red] call A3PL_Notification; true;};
		if ((player distance2D _veh) > 500) exitwith {[("STR_A3PL_Lib_TooFarVehicleJob" call A3PL_Localize),Color_Red] call A3PL_Notification; true;};
		sleep 300;
	};
	{deleteVehicle _x;} foreach (attachedObjects _veh);
	deleteVehicle _veh;
	player setVariable ["jobVehicle",nil,true];
	[getPlayerUID player,(player getVariable ["character_id",""]),"rent_car_removed",[format ["Cost: %1 | Class: %2 | Job: %3 | Position: %4",_cost,_class,_job,_pos]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

["A3PL_Lib_DOJRentCar",
{
	private _class = param [0,""];
	private _id = ("STR_Common_DOJ" call A3PL_Localize);
	private _pid = player getVariable["db_id",-1];
	private _pos = [6156.38,7325.12,0.00143862];
	private _dojCar = player getVariable["dojVehicle",objNull];
	if !(isNull _dojCar) exitwith {[("STR_A3PL_Lib_AlreadyHaveDOJCar" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_pid isEqualTo -1) exitwith {};
	private _id =  {
		if (_pid < 10) exitwith {format["DOJ000%1",_pid];};
		if (_pid < 100) exitwith {format["DOJ00%1",_pid];};
		if (_pid < 1000) exitwith {format["DOJ0%1",_pid];};
		format["DOJ%1",_pid];
	};
	private _pBank = player getVariable["bank",0];
	player setVariable["bank",_pBank - 1500,true];

	[_class,_pos,call _id,player,true] remoteExec ["Server_Vehicle_Spawn", 2];
}] call compile_Global;

["A3PL_Lib_JobVehicle_Return",
{
	private _veh = player getVariable ["jobVehicle",objNull];
	if (isNull _veh) exitWith{[("STR_A3PL_Lib_DoNotHaveVehicleJob" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if ((player distance2D _veh) > 50) exitWith {[("STR_A3PL_Lib_TooFarToBeRestituate" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _cost = _veh getVariable["rentCost",0];
	if (_cost isNotEqualTo 0) then {
		private _returnPay = round(_cost / 2);
		private _pCash = player getVariable["Player_Cash",0];
		player setVariable["Player_Cash",_pCash+_returnPay,true];
	};

	[("STR_A3PL_Lib_GetVehicleJobBack" call A3PL_Localize),Color_Green] call A3PL_Notification;
	{deleteVehicle _x;} foreach (attachedObjects _veh);
	deleteVehicle _veh;
	player setVariable ["jobVehicle",nil,true];
}] call compile_Global;

["A3PL_Lib_hasPerk",
{
	params [["_perk","",[""]]];
	if (_perk IN (player getVariable ["perks",[]])) then {true;} else {false;};
}] call compile_Global;

["A3PL_Lib_GetHeading",
{
	params [["_direction",getDir player,[0]]];
	private _heading = [("STR_A3PL_Lib_Heading_N" call A3PL_Localize), ("STR_A3PL_Lib_Heading_NNE" call A3PL_Localize), ("STR_A3PL_Lib_Heading_NE" call A3PL_Localize), ("STR_A3PL_Lib_Heading_ENE" call A3PL_Localize), ("STR_A3PL_Lib_Heading_E" call A3PL_Localize), ("STR_A3PL_Lib_Heading_ESE" call A3PL_Localize), ("STR_A3PL_Lib_Heading_SE" call A3PL_Localize), ("STR_A3PL_Lib_Heading_SSE" call A3PL_Localize), ("STR_A3PL_Lib_Heading_S" call A3PL_Localize), ("STR_A3PL_Lib_Heading_SSO" call A3PL_Localize), ("STR_A3PL_Lib_Heading_SO" call A3PL_Localize), ("STR_A3PL_Lib_Heading_OSO" call A3PL_Localize), ("STR_A3PL_Lib_Heading_O" call A3PL_Localize), ("STR_A3PL_Lib_Heading_ONO" call A3PL_Localize), ("STR_A3PL_Lib_Heading_NO" call A3PL_Localize), ("STR_A3PL_Lib_Heading_NNO" call A3PL_Localize), ("STR_A3PL_Lib_Heading_N" call A3PL_Localize)] select (round (_direction / 22.5));
	_heading;
}] call compile_Global;

["A3PL_Lib_JobMessage",{
	private _msg = param [0,("STR_A3PL_Lib_NoMessageDefined" call A3PL_Localize)];
	private _colour = param [1,"blue"];
	private _job = param [2,""];
	private _count = param [3,1];
	private _jobMembers = [_job] call A3PL_Lib_FactionPlayers;
	for [{_i = 0}, {_i < _count},{_i = _i + 1}] do {
		[_msg, _colour] remoteExec ["A3PL_Notification",_jobMembers];
		sleep 1;
	};
}] call compile_Global;

["A3PL_Lib_JobMessageAll",{
	private _msg = param [0,("STR_A3PL_Lib_NoMessageDefined" call A3PL_Localize)];
	private _colour = param [1,"blue"];
	private _count = param [2,1];
	private _jobMembers = [] call A3PL_Lib_AllFactionPlayers;
	for [{_i = 0}, {_i < _count},{_i = _i + 1}] do {
		[_msg, _colour] remoteExec ["A3PL_Notification",_jobMembers];
		sleep 1;
	};
}] call compile_Global;

["A3PL_Lib_CreateMarker", {
	private _location = param [0,position player];
	private _msg = param [1,("STR_A3PL_Lib_NoMessageDefined" call A3PL_Localize)];
	private _colour = param [2,"Default"];
	private _type = param [3,"mil_warning"];
	private _delTime = param [4,180];

	_marker = createMarkerLocal [format["marker_%1",floor (random 5000)],_location];
	_marker setMarkerShapeLocal "ICON";
	_marker setMarkerColorLocal _colour;
	_marker setMarkerTypeLocal _type;
	_marker setMarkerTextLocal format [_msg];
	_marker setMarkerSizeLocal [0.8, 0.8];

	sleep _delTime;
	deleteMarkerLocal _marker;
}] call compile_Global;

["A3PL_Lib_GetWeaponAccsCargo",
{
	params [["_class","",[""]]];
	private _array = weaponsItems player;
	private _return = ["","",""];
	{
		if(_x#0 isEqualTo _class) exitWith {
			_return = [_x#1,_x#2,_x#3];
		};
	} forEach _array;
	_return;
}] call compile_Global;

["A3PL_Lib_ThrowPunch", {
	private _anim = param [0,"A3FL_anim_PunchRandom"];
	private _animIndex = param [1,1];
	private _target = cursorObject;
	private _hitSuccess = false;
	private _hitAnim = "";
	private _hitStrength = floor (random 2);
	private _currStamina = getStamina player;
	private _adminMode = _target getVariable ["pVar_RedNameOn",false];
	private _unconscious = !(_target getVariable["A3PL_Medical_Alive",true]);

	if (_currStamina < 12) exitWith {};
	if (A3PL_Punch) exitWith {};
	if (animationState player IN ["A3FL_anim_Receive1a","A3FL_anim_Receive1b","A3FL_anim_Receive4","A3FL_anim_Receive3c","A3FL_anim_Knockout1In","A3FL_anim_Knockout1End","A3FL_anim_Receive3b","A3FL_anim_Receive2a","A3FL_anim_Receive3a","A3FL_anim_Receive2b","A3FL_anim_Knockout2In","A3FL_anim_Knockout2End"]) exitWith {};
	if (_adminMode) exitWith {};
	if (_unconscious) exitWith {};
	if ((player getVariable["Cuffed",false]) || (player getVariable["Cuffed",false])) exitWith {};
	if ((_target getVariable["Cuffed",false]) || (_target getVariable["Cuffed",false])) exitWith {};
	A3PL_Punch = true;
	if ((isPlayer _target) && (player distance2D _target < 1.75)) then {
		_hitSuccess = true;
		if (_hitStrength isEqualTo 1) then {
			player setStamina (_currStamina - 8);
		} else {
			player setStamina (_currStamina - 4);
		};
	} else {
		player setStamina (_currStamina - 12);
		A3PL_Punch = false;
	};

	if (_animIndex isEqualTo 7) then {
		player playAction _anim;
	} else {
		[player,_anim] remoteExec ["A3PL_Lib_SyncAnim",-2];
	};

	if (_hitSuccess) then {
		player playAction _anim;
		private _bruiseChance = random 100;

		// Check if player has the boxer trait
		private _traits = player getVariable ["Player_Traits", []];
		private _hasBoxerTrait = "boxer" in _traits;

		// Check if target has the pain_trained trait
		private _targetTraits = _target getVariable ["Player_Traits", []];
		private _hasPainTrainedTrait = "pain_trained" in _targetTraits;

		// Boxer trait: higher chance to deal damage (75 -> 50, meaning 50% chance instead of 25%)
		// Pain_trained trait: lower chance to receive damage (75 -> 90, meaning 10% chance instead of 25%)
		private _damageThreshold = 75;
		if (_hasBoxerTrait) then {
			_damageThreshold = 50;
		};
		if (_hasPainTrainedTrait) then {
			_damageThreshold = _damageThreshold + 15;
		};

		switch (_animIndex) do {
			case (1): {
				if (_hitStrength isEqualTo 1) then {
					_hitAnim = "A3FL_anim_Receive1a";
					uiSleep 0.6;
					if (_bruiseChance >= _damageThreshold) then {
						[_target,"head",selectRandom ["bone_broken","wound_minor","wound_major"]] call A3PL_Medical_ApplyWound;
						[_target,"head","concussion"] call A3PL_Medical_ApplyWound;
					};
				} else {
					_hitAnim = "A3FL_anim_Receive1b";
					uiSleep 0.6;
					if (_bruiseChance >= _damageThreshold) then {
						[_target,"head","bruise"] call A3PL_Medical_ApplyWound;
					};
				};
			};
			case (2): {
				if (_hitStrength isEqualTo 1) then {
					_hitAnim = "A3FL_anim_Receive4";
					uiSleep 0.2;
					if (_bruiseChance >= _damageThreshold) then {
						[_target,selectRandom ["chest","torso","pelvis"],selectRandom ["bone_broken","wound_minor","wound_major"]] call A3PL_Medical_ApplyWound;
					};
				} else {
					_hitAnim = "A3FL_anim_Receive4";
					uiSleep 0.2;
					if (_bruiseChance >= _damageThreshold) then {
						[_target,selectRandom ["chest","torso","pelvis"],"bruise"] call A3PL_Medical_ApplyWound;
					};
				};
			};
			case (3): {
				if (_hitStrength isEqualTo 1) then {
					_hitAnim = "A3FL_anim_Receive3c";
					uiSleep 0.4;
					if (_bruiseChance >= _damageThreshold) then {
						[_target,"head",selectRandom ["bone_broken","wound_minor","wound_major"]] call A3PL_Medical_ApplyWound;
						[_target,"head","concussion"] call A3PL_Medical_ApplyWound;
					};
				} else {
					_hitAnim = "A3FL_anim_Receive3c";
					uiSleep 0.4;
					if (_bruiseChance >= _damageThreshold) then {
						[_target,"head","bruise"] call A3PL_Medical_ApplyWound;
					};
				};
			};
			case (4): {
				if (_hitStrength isEqualTo 1) then {
					uiSleep 0.4;
					[_target,"A3FL_anim_Knockout1In"] remoteExec ["A3PL_Lib_SyncAnim",-2];
					uiSleep 2.5;
					_hitAnim = "A3FL_anim_Knockout1End";
					if (_bruiseChance >= _damageThreshold) then {
						[_target,"head",selectRandom ["bone_broken","wound_minor","wound_major"]] call A3PL_Medical_ApplyWound;
						[_target,"head","concussion"] call A3PL_Medical_ApplyWound;
					};
				} else {
					_hitAnim = "A3FL_anim_Receive3b";
					uiSleep 0.4;
					if (_bruiseChance >= _damageThreshold) then {
						[_target,"head","bruise"] call A3PL_Medical_ApplyWound;
					};
				};
			};
			case (5): {
				if (_hitStrength isEqualTo 1) then {
					_hitAnim = "A3FL_anim_Receive2a";
					uiSleep 0.3;
					if (_bruiseChance >= _damageThreshold) then {
						[_target,"head",selectRandom ["bone_broken","wound_minor","wound_major"]] call A3PL_Medical_ApplyWound;
						[_target,"head","concussion"] call A3PL_Medical_ApplyWound;
					};
				} else {
					_hitAnim = "A3FL_anim_Receive3a";
					uiSleep 0.3;
					if (_bruiseChance >= _damageThreshold) then {
						[_target,"head","bruise"] call A3PL_Medical_ApplyWound;
					};
				};
			};
			case (6): {
				if (_hitStrength isEqualTo 1) then {
					_hitAnim = "A3FL_anim_Receive2a";
					uiSleep 0.3;
					if (_bruiseChance >= _damageThreshold) then {
						[_target,"head",selectRandom ["bone_broken","wound_minor","wound_major"]] call A3PL_Medical_ApplyWound;
						[_target,"head","concussion"] call A3PL_Medical_ApplyWound;
					};
				} else {
					_hitAnim = "A3FL_anim_Receive2b";
					uiSleep 0.3;
					if (_bruiseChance >= _damageThreshold) then {
						[_target,"head","bruise"] call A3PL_Medical_ApplyWound;
					};
				};
			};
			case (7): {
				if (_hitStrength isEqualTo 1) then {
					uiSleep 0.3;
					[_target,"A3FL_anim_Knockout2In"] remoteExec ["A3PL_Lib_SyncAnim",-2];
					uiSleep 2;
					_hitAnim = "A3FL_anim_Knockout2End";
					if (_bruiseChance >= _damageThreshold) then {
						[_target,selectRandom ["chest","torso","pelvis"],selectRandom ["bone_broken","wound_minor","wound_major"]] call A3PL_Medical_ApplyWound;
					};
				} else {
					_hitAnim = "A3FL_anim_Receive4";
					uiSleep 0.5;
					if (_bruiseChance >= _damageThreshold) then {
						[_target,selectRandom ["chest","torso","pelvis"],"bruise"] call A3PL_Medical_ApplyWound;
					};
				};
			};
		};

		[_target,_hitAnim] remoteExec ["A3PL_Lib_SyncAnim",-2];
		uiSleep 1.5;
		A3PL_Punch = false;
	};
}] call compile_Global;

["A3FL_Lib_PunchRandom",
{
	if (dialog) exitwith {};
	if ((player getVariable["Zipped",false]) || {player getVariable["Cuffed",false]}) exitWith{};
    if (vehicle player isNotEqualTo player || {currentWeapon player isNotEqualTo ""}) exitWith {};
    private _animArray = [["A3FL_anim_Punch1",1],["A3FL_anim_Punch2",2],["A3FL_anim_Punch3",3],["A3FL_anim_Punch4",4],["MOCAP_Man_Act_Idle_Stay_CivPace_Non_Push_Kick_LeftLeg",7]];
    private _anim = selectRandom _animArray;
    _anim spawn A3PL_Lib_ThrowPunch;
}] call compile_Global;

["A3PL_Lib_WeaponSwap",
{
	// Protection anti-spam pour eviter la duplication d'armes
	if (!isNil "Player_WeaponSwapping" && {Player_WeaponSwapping}) exitWith {};
	Player_WeaponSwapping = true;

	private _currWeapon = currentWeapon player;
	private _curAtt = handgunItems player;
	private _cargoWeap = weaponsItemsCargo (uniformContainer player);
	if (_currWeapon isEqualTo "") exitWith {Player_WeaponSwapping = false;};
	private _lookArray = if(_currWeapon IN Taser_Swap_List) then {Handguns_Swap_List} else {if(_currWeapon IN Handguns_Swap_List) then {Taser_Swap_List} else {[]}};
	if(_lookArray isEqualTo []) exitwith {Player_WeaponSwapping = false;};

	[player,"amovpercmstpsnonwnondnon",1] remoteExec ["A3PL_Lib_SyncAnim",0];
	sleep 1.5;

	private _currMag = currentMagazine player;
	private _addMag = [];
	if (_currMag isNotEqualTo "") then {
		_currMagDetail = (currentMagazineDetail player) splitString "([]/:)";
		_addMag = [_currMag,parseNumber(_currMagDetail#1)];
	};
	private _pocketWeapon = "";
	{
		if ([player,_x] call BIS_fnc_hasItem) exitWith {_pocketWeapon = _x};
	} forEach _lookArray;
	if (_pocketWeapon isEqualTo "") exitWith {Player_WeaponSwapping = false;};

	{
		if(_pocketWeapon isEqualTo _x#0) exitwith {_pocketWeapon = _x;};
	} forEach _cargoWeap;

	player removeWeapon _currWeapon;
	(uniformContainer player) addWeaponWithAttachmentsCargoGlobal [[_currWeapon, _curAtt#0, _curAtt#1, _curAtt#2, _addMag, [], ""], 1];

	player removeItem _pocketWeapon#0;
	player addMagazine _pocketWeapon#4;
	player addWeapon _pocketWeapon#0;
	player addHandgunItem _pocketWeapon#2;
	player selectWeapon _pocketWeapon#0;

	Player_WeaponSwapping = false;
}] call compile_Global;

["A3PL_Lib_CanInteract",
{
	private _player = param[0,objNull];
	private _return = true;
	if (_player getVariable ["Cuffed",false]) then {_return = false;};
	if (_player getVariable ["Zipped",false]) then {_return = false;};
	if ((animationState _player) == "a3pl_takenhostage") then {_return = false;};

	_return;
}] call compile_Global;

["A3PL_Lib_MapArea",
{
	params["_position","_label","_mrkType","_duration"];
	private _markers = [];

	_marker = createMarkerLocal [format["MapArea_%1",floor (random 5000)],_position];
	_marker setMarkerShapeLocal "ELLIPSE";
	_marker setMarkerSizeLocal [300,300];
	_marker setMarkerColorLocal "ColorRed";
	_marker setMarkerTypeLocal "Mil_dot";
	_marker setMarkerAlphaLocal 0.7;
	_markers pushback _marker;
	_marker = createMarkerLocal [format["MapArea_%1",floor (random 5000)],_position];
	_marker setMarkerShapeLocal "ICON";
	_marker setMarkerTypeLocal _mrkType;
	_marker setMarkerTextLocal _label;
	_marker setMarkerSizeLocal [0.6,0.6];
	_markers pushback _marker;

	sleep _duration;
	{deleteMarkerLocal _x;} foreach _markers;
}] call compile_Global;

["A3PL_Lib_ConfirmationDialog",
{
	params[["_msg",""]];
	createDialog "Dialog_Confirmation";
	private _display = findDisplay 94;
	private _control = _display displayCtrl 1100;
	_control ctrlSetStructuredText parseText format ["<t size='1.1'>%1</t>",_msg];

	private _ctrlButtonOK = _display displayCtrl 1101;
	private _ctrlButtonCancel = _display displayCtrl 1102;

	uinamespace setvariable ["A3FL_ConfirmationResult",nil];
	_ctrlButtonOK ctrlseteventhandler ["buttonclick","uinamespace setvariable ['A3FL_ConfirmationResult',true]; true"];
	_ctrlButtonCancel ctrlseteventhandler ["buttonclick","uinamespace setvariable ['A3FL_ConfirmationResult',false]; true"];
	_display displayaddeventhandler ["unload","uinamespace setvariable ['A3FL_ConfirmationResult',false];"];
	private _ehKeyDown = _display displayaddeventhandler ["keydown","if ((_this select 1) == 1) then {uinamespace setvariable ['A3FL_ConfirmationResult',false]; true} else {false}"];

	waituntil {!isnil {uinamespace getvariable "A3FL_ConfirmationResult"}};

	_display displayremoveeventhandler ["keydown",_ehKeyDown];
	_display closedisplay 2;

	private _status = uinamespace getVariable "A3FL_ConfirmationResult";
	uinamespace setvariable ["A3FL_ConfirmationResult",nil];
	_status
}] call compile_Global;

["A3PL_Lib_Loadout",
{
	params ["_unit"];
	private _loadout = getUnitLoadout _unit;
	private _specialItems = _loadout#9;
	private _radio = _specialItems#2;
	if(_radio isEqualTo "") exitwith {_loadout};
	private _radioClass = configFile >> "CfgWeapons" >> _radio;
	if ((isClass _radioClass) && {isNumber (_radioClass >> "tf_radio")}) then {
		_specialItems set[2, getText(_radioClass >> "tf_parent")];
		_loadout set[9, _specialItems];
	};
	_loadout;
}] call compile_Global;