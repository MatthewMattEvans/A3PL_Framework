/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
//distance from center that oil can be found from
#define OILDISTANCE 100
//distance from center where a resource can be found
#define RESDISTANCE 120

["A3PL_JobWildCat_BuyMap",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private ["_mapType","_markers","_resArray","_exactLocation","_pos","_timeLeft"];
	_mapType = param [0,""];
	_markers = [];

	_timeLeft = missionNameSpace getVariable ["A3PL_JobWildcat_MapTimer",(diag_ticktime-2)];
	if (_timeLeft > diag_ticktime) exitwith {[format [("STR_A3PL_Job_Wildcat_WaitBeforeBuyAnotherMap" call A3PL_Localize),round(_timeLeft-diag_ticktime)],Color_Red] call A3PL_Notification;};

	switch (_mapType) do
	{
		case ("STR_Common_Oil" call A3PL_Localize):
		{
			if ((player getVariable ["Player_cash",0]) < Job_Wildcat_Map_Oil_Price) exitwith {[("STR_A3PL_Job_Wildcat_NotEnoughMoneyToBuyThisMap" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			
			private _availableLocations = [];
			{
				if (!(_x#3)) then {
					_availableLocations pushback [_x, _forEachIndex];
				};
			}forEach Server_JobWildCat_Oil;

			if (_availableLocations isEqualTo []) exitWith {
				[("STR_A3PL_Job_Wildcat_NoMorePetrolArea" call A3PL_Localize),Color_Red] call A3PL_Notification;
			};

			private _selectRandom = selectRandom _availableLocations;
			private _activeLocation = _selectRandom#0;
			private _index = _selectRandom#1;
			_activeLocation set [3,true];
			Server_JobWildCat_Oil set [_index,_activeLocation];
			publicVariable "Server_JobWildCat_Oil";

			_exactLocation = _activeLocation#0;

			player setVariable ["Player_cash",(player getVariable ["Player_Cash",0]) - Job_Wildcat_Map_Oil_Price,true];

			_marker = createMarkerLocal [format["%1_marker",floor (random 5000)],_exactLocation];
			_marker setMarkerShapeLocal "ELLIPSE";
			_marker setMarkerSizeLocal [OILDISTANCE,OILDISTANCE];
			_marker setMarkerColorLocal "ColorGreen";
			_marker setMarkerTypeLocal "Mil_dot";
			_marker setMarkerAlphaLocal 0.5;
			_markers pushback _marker;

			_marker = createMarkerLocal [format["%1_marker",floor (random 5000)],_exactLocation];
			_marker setMarkerShapeLocal "ICON";
			_marker setMarkerTypeLocal "A3FL_Markers_OilDrilling";
			_marker setMarkerTextLocal format [("STR_A3PL_Job_Wildcat_PetrolInThisArea" call A3PL_Localize)];
			_markers pushback _marker;
			
			private _playerMaps = player getVariable ["A3PL_JobWildcat_Maps", []];
			private _expireTime = diag_tickTime + Job_Wildcat_Markers_onMap_Timer;
			private _mapData = [_mapType, _exactLocation, OILDISTANCE, _expireTime];
			_playerMaps pushBack _mapData;
			player setVariable ["A3PL_JobWildcat_Maps", _playerMaps, true];
		};
		default {
			if ((player getVariable ["player_cash",0]) < Job_Wildcat_Map_Others_Price) exitwith {[("STR_A3PL_Job_Wildcat_NotEnoughMoneyToBuyThisMap" call A3PL_Localize),Color_Red] call A3PL_Notification;};

			private _availableLocations = [];
			{
				if (((_x#0) isEqualTo _mapType) && !(_x#4)) then {
					_availableLocations pushback [_x, _forEachIndex];
				};
			}forEach Server_JobWildCat_Res;

			if (_availableLocations isEqualTo []) exitWith {
				[format[("STR_A3PL_Job_Wildcat_NoMoreArea" call A3PL_Localize), _mapType],Color_Red] call A3PL_Notification;
			};

			player setVariable ["player_cash",(player getVariable ["player_cash",0]) - Job_Wildcat_Map_Others_Price,true];

			private _selectRandom = selectRandom _availableLocations;
			private _activeLocation = _selectRandom#0;
			private _index = _selectRandom#1;
			_activeLocation set [4,true];
			Server_JobWildCat_Res set [_index,_activeLocation];
			publicVariable "Server_JobWildCat_Res";

			_exactLocation = _activeLocation#1;

			_marker = createMarkerLocal [format["%1_marker",floor (random 5000)],_exactLocation];
			_marker setMarkerShapeLocal "ELLIPSE";
			_marker setMarkerSizeLocal [RESDISTANCE,RESDISTANCE];
			_marker setMarkerColorLocal "ColorGreen";
			_marker setMarkerTypeLocal "Mil_dot";
			_marker setMarkerAlphaLocal 0.5;
			_markers pushback _marker;

			_marker = createMarkerLocal [format["%1_marker",floor (random 5000)],_exactLocation];
			_marker setMarkerShapeLocal "ICON";
			_marker setMarkerTypeLocal "A3FL_Markers_ResourceMarker2";
			_marker setMarkerTextLocal format [("STR_A3PL_Job_Wildcat_ResourceInThisArea" call A3PL_Localize),toUpperANSI _mapType];
			_markers pushback _marker;
			
			private _playerMaps = player getVariable ["A3PL_JobWildcat_Maps", []];
			private _expireTime = diag_tickTime + Job_Wildcat_Markers_onMap_Timer;
			private _mapData = [_mapType, _exactLocation, RESDISTANCE, _expireTime];
			_playerMaps pushBack _mapData;
			player setVariable ["A3PL_JobWildcat_Maps", _playerMaps, true];
		};
	};

	if ((count _markers) isEqualTo 0) exitwith {};
	missionNameSpace setVariable ["A3PL_JobWildcat_MapTimer",(diag_ticktime + 300)];
	[_markers] spawn {
		private _markers = param [0,[]];
		sleep Job_Wildcat_Markers_onMap_Timer;
		{deleteMarkerLocal _x;} foreach _markers;
	};
	[format [("STR_A3PL_Job_Wildcat_YouBoughtAMap" call A3PL_Localize),_maptype],Color_Green] call A3PL_Notification;
	if (!isNil "_exactLocation") then { [_exactLocation] spawn A3PL_GPS_Navigate; };
}] call compile_Global;

["A3PL_JobWildCat_ShareMap", {
	params [["_targetPlayer", objNull, [objNull]]];
	
	if (isNull _targetPlayer) exitWith {};
	if (!isPlayer _targetPlayer) exitWith {};
	if (player distance _targetPlayer > 5) exitWith {
		[("STR_A3PL_Job_Wildcat_PlayerTooFar" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	
	private _playerMaps = player getVariable ["A3PL_JobWildcat_Maps", []];
	
	private _validMaps = [];
	{
		if (count _x >= 4) then {
			private _expireTime = _x select 3;
			if (diag_tickTime < _expireTime) then {
				_validMaps pushBack _x;
			};
		};
	} forEach _playerMaps;
	
	if (count _validMaps != count _playerMaps) then {
		player setVariable ["A3PL_JobWildcat_Maps", _validMaps, true];
	};
	
	if (count _validMaps == 0) exitWith {
		[("STR_A3PL_Job_Wildcat_NoMapsToShare" call A3PL_Localize), Color_Red] call A3PL_Notification;
	};
	
	private _mapToShare = _validMaps select 0;
	private _mapType = _mapToShare select 0;
	private _exactLocation = _mapToShare select 1;
	private _distance = _mapToShare select 2;
	
	[_mapType, _exactLocation, _distance] remoteExec ["A3PL_JobWildCat_ReceiveSharedMap", _targetPlayer];
	
	private _targetName = _targetPlayer getVariable ["name", "Unknown"];
	[format[("STR_A3PL_Job_Wildcat_MapShared" call A3PL_Localize), _mapType], Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_JobWildCat_ReceiveSharedMap", {
	params [["_mapType", ""], ["_exactLocation", [0,0,0]], ["_distance", 100]];
	
	if (_mapType isEqualTo "" || _exactLocation isEqualTo [0,0,0]) exitWith {};
	
	private _markers = [];
	
	if (_mapType == ("STR_Common_Oil" call A3PL_Localize)) then {
		_marker = createMarkerLocal [format["%1_marker",floor (random 5000)],_exactLocation];
		_marker setMarkerShapeLocal "ELLIPSE";
		_marker setMarkerSizeLocal [_distance, _distance];
		_marker setMarkerColorLocal "ColorGreen";
		_marker setMarkerTypeLocal "Mil_dot";
		_marker setMarkerAlphaLocal 0.5;
		_markers pushback _marker;
		
		_marker = createMarkerLocal [format["%1_marker",floor (random 5000)],_exactLocation];
		_marker setMarkerShapeLocal "ICON";
		_marker setMarkerTypeLocal "A3FL_Markers_OilDrilling";
		_marker setMarkerTextLocal format [("STR_A3PL_Job_Wildcat_PetrolInThisArea" call A3PL_Localize)];
		_markers pushback _marker;
	} else {
		_marker = createMarkerLocal [format["%1_marker",floor (random 5000)],_exactLocation];
		_marker setMarkerShapeLocal "ELLIPSE";
		_marker setMarkerSizeLocal [_distance, _distance];
		_marker setMarkerColorLocal "ColorGreen";
		_marker setMarkerTypeLocal "Mil_dot";
		_marker setMarkerAlphaLocal 0.5;
		_markers pushback _marker;
		
		_marker = createMarkerLocal [format["%1_marker",floor (random 5000)],_exactLocation];
		_marker setMarkerShapeLocal "ICON";
		_marker setMarkerTypeLocal "A3FL_Markers_ResourceMarker2";
		_marker setMarkerTextLocal format [("STR_A3PL_Job_Wildcat_ResourceInThisArea" call A3PL_Localize),toUpperANSI _mapType];
		_markers pushback _marker;
	};
	
	[_markers] spawn {
		private _markers = param [0,[]];
		sleep Job_Wildcat_Markers_onMap_Timer;
		{deleteMarkerLocal _x;} foreach _markers;
	};
	
	[format[("STR_A3PL_Job_Wildcat_MapReceived" call A3PL_Localize), _mapType], Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_JobWildCat_ProspectOpen",
{
	disableSerialization;
	createDialog "Dialog_Prospect";
	private _display = findDisplay 131;
	private _control = _display displayCtrl 2100;

	{
		_control lbAdd (_x select 0);
	} foreach Config_Resources_Ores;
	_control lbAdd ("STR_A3PL_Job_Wildcat_Petrol" call A3PL_Localize);

	private _prospectSave = profileNamespace getVariable ["A3PL_Mining_Prospect",0];
	_control lbSetCurSel _prospectSave;

	_control = _display displayCtrl 1601;
	_control buttonSetAction
	"
		[(lbText [2100,(lbCurSel 2100)])] call A3PL_JobWildcat_ProspectInit;
		profileNamespace setVariable ['A3PL_Mining_Prospect',(lbCurSel 2100)];
		closeDialog 0;
	";
}] call compile_Global;

["A3PL_JobWildcat_ProspectInit",
{
	params[["_prospectFor",("STR_A3PL_Job_Wildcat_Petrol" call A3PL_Localize)]];
	switch (_prospectFor) do {
		case ("STR_A3PL_Job_Wildcat_Petrol" call A3PL_Localize):
		{
			private _checkOil = [getPos player] call A3PL_JobWildcat_CheckForOil;
			private _haveOil = _checkOil#0;
			private _oilLocation = _checkOil#1;
			if (!_haveOil) exitwith {[0] spawn A3PL_JobWildCat_Prospect;};
			[true,("STR_A3PL_Job_Wildcat_Petrol" call A3PL_Localize), _oilLocation] spawn A3PL_JobWildCat_Prospect;
		};
		default {
			private _checkOres = [_prospectFor] call A3PL_JobWildcat_CheckForRes;
			private _haveRes = _checkOres#0;
			private _resLocation = _checkOres#1;
			if (!_haveRes) exitwith {[false,_prospectFor] spawn A3PL_JobWildCat_Prospect;};
			[true,_prospectFor, _resLocation] spawn A3PL_JobWildCat_Prospect;
		};
	};
}] call compile_Global;

["A3PL_JobWildCat_Prospect",
{
	params[
		["_hasProspect",false],
		["_prospectFor",("STR_A3PL_Job_Wildcat_Petrol" call A3PL_Localize)],
		["_location", [0,0,0]]
	];
	if (Player_ActionDoing) exitwith {[("STR_A3PL_Job_Wildcat_YouAlreadyProspect" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	[("STR_A3PL_Job_Wildcat_Prospect" call A3PL_Localize),Job_Wildcat_Prospection_Timer] spawn A3PL_Lib_LoadAction;
	waitUntil{Player_ActionDoing};
	[player,"Acts_TerminalOpen"] remoteExec ["A3PL_Lib_SyncAnim",0];
	while {Player_ActionDoing} do {
		if (!(player getVariable["A3PL_Medical_Alive",true])) exitWith {Player_ActionInterrupted=true;};
		if ((vehicle player) != player) exitwith {Player_ActionInterrupted=true;};
		if (player getVariable ["Incapacitated",false]) exitwith {Player_ActionInterrupted=true;};
	};
	if(Player_ActionInterrupted) exitWith {[("STR_Common_ActionInterrupted" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	[player,""] remoteExec ["A3PL_Lib_SyncAnim",0];

	if((_hasProspect isEqualTo true) && (_prospectFor isEqualTo ("STR_A3PL_Job_Wildcat_Petrol" call A3PL_Localize))) exitwith {
		[format[("STR_A3PL_Job_Wildcat_YouFoundPetrol" call A3PL_Localize),[getPos player] call A3PL_JobWildcat_CheckAmountOil],Color_Green] call A3PL_Notification;
	};
	if((_hasProspect isEqualTo 0) && (_prospectFor isEqualTo ("STR_A3PL_Job_Wildcat_Petrol" call A3PL_Localize))) exitwith {
		[("STR_A3PL_Job_Wildcat_NoPetrolHere" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};

	_listOres = [];
	{
		_listOres pushback (_x#0);
	} foreach Config_Resources_Ores;

	if (_hasProspect && {_prospectFor IN _listOres}) then {

		private _numberLeft = [_prospectFor] call A3PL_JobWildcat_CheckAmountRes;
		if (_numberLeft <= 0) exitWith {
			[format[("STR_A3PL_Job_Wildcat_NoResourceHere" call A3PL_Localize),toLower(_prospectFor)],Color_Red] call A3PL_Notification;
		};

		[player,_prospectFor,_location] remoteExec ['Server_JobWildCat_SpawnRes', 2];
	} else {
		[format[("STR_A3PL_Job_Wildcat_NoResourceInThisArea" call A3PL_Localize),toLower(_prospectFor)],Color_Red] call A3PL_Notification;
	};
}] call compile_Global;

["A3PL_JobWildcat_CheckForOil",
{
	private ["_pos", "_oil","_oilLocation"];
	_pos = param [0,[0,0,0]];
	_oil = false;
	{
		if (_pos inArea [_x#0, OILDISTANCE, OILDISTANCE, 0, false]) exitwith {
			_oil = true;
			_oilLocation = _x#0;
		};
	} foreach Server_JobWildCat_Oil;

	_return = [false,[0,0,0]];
	if (_oil) then
	{
		_return = [true,_oilLocation];
	};

	_return;
}] call compile_Global;

["A3PL_JobWildcat_CheckForRes",
{
	private ["_res","_return","_resType","_resLocation"];
	_resType = param [0,""];

	_res = false;
	{
		if ((player inArea [_x#1, RESDISTANCE, RESDISTANCE, 0, false]) && (_x#0 == _resType)) exitwith {
			_res = true;
			_resLocation = _x#1;
		};
	} foreach Server_JobWildCat_Res;

	_return = [false,[0,0,0]];
	if (_res) then {
		_return = [true,_resLocation];
	};
	_return;
}] call compile_Global;

["A3PL_JobWildcat_CheckAmountOil",
{
	private _pos = param [0,[0,0,0]];
	private _return = 0;
	{
		if (_pos inArea [_x#0, OILDISTANCE, OILDISTANCE, 0, false]) exitwith {
			_return = _x#2;
		};
	} foreach Server_JobWildCat_Oil;

	_return;
}] call compile_Global;

["A3PL_JobWildcat_CheckAmountRes",
{
	params[
		["_resType",""]
	];

	private _return = 0;
	{
		if ((getPos player) inArea [_x#1, RESDISTANCE, RESDISTANCE, 0, false]) exitwith {
			_return = _x#3;
		};
	} foreach Server_JobWildCat_Res;

	_return;
}] call compile_Global;

["A3PL_JobWildcat_Drill",
{
	private ["_s","_pump","_drilling","_a"];
	_pump = param [0,objNull];

	if ((_pump animationPhase "Pin") > 0) exitwith {[("STR_A3PL_Job_Wildcat_CantUseWhenTrailerAttached" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if ((_pump animationSourcePhase "drill_arm_position") != 1) exitwith {[("STR_A3PL_Job_Wildcat_NotExtended" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_a = _pump animationSourcePhase "drill";
	uisleep 0.2;
	if (_a != _pump animationSourcePhase "drill") exitwith {[("STR_A3PL_Job_Wildcat_AlreadyInMovement" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if (_pump animationSourcePhase "drill" > 0) exitwith {_pump animateSource ["drill",0]; [("STR_A3PL_Job_Wildcat_AlreadyOut" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	[("STR_A3PL_Job_Wildcat_DrillStarted" call A3PL_Localize),Color_Green] call A3PL_Notification;
	_drilling = true;
	_pump animateSource ["drill",1];
	_s = false;
	_pos = getpos _pump;
	while {_drilling} do {
		if ((_pos distance (getpos _pump)) > 1) exitwith {_pump animateSource ["drill",0,true]; [("STR_A3PL_Job_Wildcat_DrillCancelled" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		if (_pump animationSourcePhase "drill" == 1) exitwith {_s = true};
		if (isNull _pump) exitwith {};
		uiSleep 1;
	};
	if (_s) then {
		[("STR_A3PL_Job_Wildcat_HoleSuccess" call A3PL_Localize),Color_Green] call A3PL_Notification;
		_hole = createVehicle ["A3PL_Drillhole",_pump modelToWorld [0,-1.8,-1.1], [], 0, "CAN_COLLIDE"]; //[0,-1.1,0]
	} else {
		[("STR_A3PL_Job_Wildcat_DrillCancelled2" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};
}] call compile_Global;

["A3PL_JobWildcat_RareMaps",
{
	params[
		["_npc",objNull,[objNull]]
	];

	_timeLeft = missionNameSpace getVariable ["A3PL_JobWildcat_MapTimer",(diag_ticktime-2)];
	if (_timeLeft > diag_ticktime) exitwith {[format [("STR_A3PL_Job_Wildcat_WaitBeforeBuyAnotherMap" call A3PL_Localize),round(_timeLeft-diag_ticktime)],Color_Red] call A3PL_Notification;};

	private _chance = random 100;
	private _mapType = ("STR_A3PL_Job_Wildcat_Saphir" call A3PL_Localize);
	private _island = "FIMiningArea";
	if(_npc IN [npc_miningmike,npc_miningjake]) then {
		if ((_chance >= 0) && (_chance <= 30)) then {
			_mapType = ("STR_A3PL_Job_Wildcat_Vivianite" call A3PL_Localize);
		};
		if((_chance >= 31) && (_chance <= 60)) then {
			_mapType = ("STR_A3PL_Job_Wildcat_Saphir" call A3PL_Localize);
		};
		if ((_chance >= 61) && (_chance <= 75)) then {
			_mapType = ("STR_A3PL_Job_Wildcat_Emeraude" call A3PL_Localize);
		};
		if ((_chance >= 76) && (_chance <= 85)) then {
			_mapType = ("STR_A3PL_Job_Wildcat_Or" call A3PL_Localize);
		};
		if ((_chance >= 86) && (_chance <= 100)) then {
			_maptype = ("STR_A3PL_Job_Wildcat_Amethyste" call A3PL_Localize);
		};
	} else {};
	if(_maptype isEqualTo "") exitWith {["Error loading the map type",Color_Red] call A3PL_Notification;};

	if ((player getVariable ["Player_cash",0]) < Job_Wildcat_Map_Rares_Price) exitwith {
		[("STR_A3PL_Job_Wildcat_NotEnoughMoneyToBuyThisMap" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};

	private _possibleLocations = [];
	{
		if (((_x#1) inArea _island) && ((_x#0) isEqualTo _mapType) && !(_x#4)) then {
			_possibleLocations pushback [_x, _forEachIndex];
		};
	}forEach Server_JobWildCat_Res;

	if(_possibleLocations isEqualTo []) exitWith {
		[format[("STR_A3PL_Job_Wildcat_NoMoreArea" call A3PL_Localize), _mapType],Color_Red] call A3PL_Notification;
	};

	player setVariable ["Player_cash",(player getVariable ["Player_Cash",0]) - Job_Wildcat_Map_Rares_Price,true];

	private _selectRandom = selectRandom _possibleLocations;
	private _activeLocation = _selectRandom#0;
	private _index = _selectRandom#1;
	_activeLocation set [4,true];
	Server_JobWildCat_Oil set [_index,_activeLocation];
	publicVariable "Server_JobWildCat_Oil";

	private _exactLocation = _activeLocation#1;

	private _markers = [];

	_marker = createMarkerLocal [format["%1_marker",floor (random 5000)],_exactLocation];
	_marker setMarkerShapeLocal "ELLIPSE";
	_marker setMarkerSizeLocal [RESDISTANCE,RESDISTANCE];
	_marker setMarkerColorLocal "ColorGreen";
	_marker setMarkerTypeLocal "Mil_dot";
	_marker setMarkerAlphaLocal 0.5;
	_markers pushback _marker;

	_marker = createMarkerLocal [format["%1_marker",floor (random 5000)],_exactLocation];
	_marker setMarkerShapeLocal "ICON";
	_marker setMarkerColorLocal "Default";
	_marker setMarkerTypeLocal "A3FL_Markers_ResourceMarker2";
	_marker setMarkerTextLocal format [("STR_A3PL_Job_Wildcat_ResourceInThisArea" call A3PL_Localize),toUpperANSI _mapType];
	_markers pushback _marker;
	
	private _playerMaps = player getVariable ["A3PL_JobWildcat_Maps", []];
	private _expireTime = diag_tickTime + Job_Wildcat_Markers_onMap_Timer;
	private _mapData = [_mapType, _exactLocation, RESDISTANCE, _expireTime];
	_playerMaps pushBack _mapData;
	player setVariable ["A3PL_JobWildcat_Maps", _playerMaps, true];
	
	if ((count _markers) isEqualTo 0) exitwith {};
	missionNameSpace setVariable ["A3PL_JobWildcat_MapTimer",(diag_ticktime + 300)];
	[_markers] spawn {
		private _markers = param [0,[]];
		sleep Job_Wildcat_Markers_onMap_Timer;
		{deleteMarkerLocal _x;} foreach _markers;
	};
	[format [("STR_A3PL_Job_Wildcat_YouBoughtAMap" call A3PL_Localize),_maptype],Color_Green] call A3PL_Notification;
}] call compile_Global;
