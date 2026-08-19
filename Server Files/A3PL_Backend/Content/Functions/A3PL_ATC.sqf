/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_ATC_Transponder", {
	private _veh = vehicle player;
	createDialog "Dialog_Transponder";
	A3PL_ATC_TransponderSel = 0;

	private _squawk = format ["%1",_veh getVariable ["squawk",1200]];
	private _newSquawk = toArray _squawk;
	{
		_idc = 1202 + _forEachIndex;
		ctrlSetText [_idc, format ["\A3PL_Common\GUI\transponder\%1.paa",((toString _newSquawk) select [_forEachIndex,1])]];
	} foreach _newSquawk;

	private _mode = _veh getVariable ["transponder","STBY"];
	private _pic = switch (_mode) do
	{
		case "C": {"ALT.paa"};
		case "STBY": {"STBY.paa"};
		case "IDENT": {"IDENT.paa"};
	};
	 ctrlSetText [1201,format ["\A3PL_Common\GUI\transponder\%1",_pic]];
}] call compile_Global;

["A3PL_ATC_TransponderSquawk", {
	params [["_selectedNumber",0,[0]]];

	private _veh = vehicle player;
	private _squawk = format ["%1",_veh getVariable ["squawk",1200]];
	private _newSquawk = toArray _squawk;
	_newSquawk set [A3PL_ATC_TransponderSel,(48+_selectedNumber)];
	_veh setVariable ["squawk",(toString _newSquawk),true];

	{
		private _idc = 1202 + _forEachIndex;
		ctrlSetText [_idc, format ["\A3PL_Common\GUI\transponder\%1.paa",((toString _newSquawk) select [_forEachIndex,1])]];
	} foreach _newSquawk;

	A3PL_ATC_TransponderSel = A3PL_ATC_TransponderSel + 1;
	if (A3PL_ATC_TransponderSel > 3) then {A3PL_ATC_TransponderSel = 0;};
}] call compile_Global;

["A3PL_ATC_TransponderMode", {
	params [["_mode","STBY",[""]]];

	private _veh = vehicle player;
	private _pic = switch (_mode) do
	{
		case "C": {"ALT.paa"};
		case "STBY": {"STBY.paa"};
		case "IDENT": {"IDENT.paa"};
	};
	ctrlSetText [1201,format ["\A3PL_Common\GUI\transponder\%1",_pic]];
	_veh setVariable ["transponder",_mode,true];
}] call compile_Global;

//Get flight level of an aircraft
["A3PL_ATC_GetFL", {
	params [["_veh",objNull,[objNull]]];

	private _feet = ((getposASL _veh select 2) * 3.2808399);
	private _fl = format ["%1",floor (_feet / 100)];
	if (count _fl isEqualTo 1) then {
		_fl = format ["00%1",_fl];
	} else {
		if (count _fl isEqualTo 2) then {
			_fl = format ["0%1",_fl];
		};
	};
	_fl;
}] call compile_Global;

//COMPILE BLOCK FUNCTIONS WARNING, COPY OF THIS NEEDS TO BE IN fn_PreInit.sqf
["A3PL_ATC_GetInAircraft", {
	params [["_veh",objNull,[objNull]]];

	A3PL_ATC_IsListeningATC = false;
	while {player IN _veh} do {
		private _active = call TFAR_fnc_activeLRRadio;
		if (!isNil "_active" && (_active select 1 IN ["driver_radio_settings","gunner_radio_settings"])) then {
			//Sync gunner seat to driver seat LR frequency
			if (player != driver _veh) then {
				if (([_veh,"gunner_radio_settings"] call TFAR_fnc_getLrFrequency) != ([_veh,"driver_radio_settings"] call TFAR_fnc_getLrFrequency)) then {
					[[_veh, "driver_radio_settings"],[_veh, "gunner_radio_settings"]] call TFAR_fnc_CopySettings;
				};
			};

			private _frequency = (parseNumber ((call TFAR_fnc_ActiveLrRadio) call TFAR_fnc_getLrFrequency)) == 127; //check if we are on ATIS
			
			//if we are on ATIS then do the following
			if (_frequency) then {
				//Get ATC text
				private ["_atcText"];

				if (isNil "A3PL_ATC_ATISTEXT") then {
					_atcText = ("STR_A3PL_ATC_NoATISAvailable" call A3PL_Localize);
				} else {
					_atcText = A3PL_ATC_ATISTEXT;
				};
				[format [("STR_A3PL_ATC_ATIS" call A3PL_Localize),_atcText],Color_Green] call A3PL_Notification;
			};
		};
		uiSleep 5;
	};
}] call compile_Global;

["A3PL_ATC_GetType", {
	params [["_veh",objNull,[objNull]]];

	switch (true) do {
		case (_veh isKindOf "A3PL_Goose_Base"): {"G21"};
		case (_veh isKindOf "A3PL_Jayhawk"): {"H60"};
		case (_veh isKindOf "A3FL_AS_365"): {"MH65"};
		case (_veh isKindOf "A3FL_AS350_CIV"): {"H125"};
		default {("STR_Common_Unknown" call A3PL_Localize)};
	};
}] call compile_Global;

["A3PL_ATC_ATISPreview", {
	private _atcText = ctrlText 1407;
	[format [("STR_A3PL_ATC_ATIS" call A3PL_Localize),_atcText],Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_ATC_SetAircraftInfo", {
	params [["_veh",objNull,[objNull]]];

	disableSerialization;

	if (_veh isEqualType "") then {
		{
			if ((format ["%1",_x]) == _veh) exitwith {
				_veh = _x;
			};
		} foreach vehicles;
	};

	if (_veh isEqualType "") exitwith {["ATC System: Error occured trying to retrieve object name",Color_Red] call A3PL_Notification;};

	A3PL_ATC_VAR_Selected = _veh;

	private _transponder = _veh getVariable ["transponder","STBY"];

	switch (_transponder) do {
		case "STBY": {
			ctrlSetText [1400, [_veh] call A3PL_ATC_GetType]; //type
			ctrlSetText [1401, _veh getVariable ["callsign",("STR_A3PL_ATC_CallsignUNDEF" call A3PL_Localize)]]; //callsign
			ctrlSetText [1402, format ["%1",(_veh getVariable ["squawk",1200])]]; //squawk
			ctrlSetText [1403, _transponder]; //transponder
			ctrlSetText [1404, ""]; //heading
			ctrlSetText [1405, ""]; //ias
			ctrlSetText [1406, ""]; //alt
		};
		default {
			ctrlSetText [1400, [_veh] call A3PL_ATC_GetType]; //type
			ctrlSetText [1401, _veh getVariable ["callsign",("STR_A3PL_ATC_CallsignUNDEF" call A3PL_Localize)]]; //callsign
			ctrlSetText [1402, format ["%1",(_veh getVariable ["squawk",1200])]]; //squawk
			ctrlSetText [1403, _transponder]; //transponder
			ctrlSetText [1404, format [("STR_A3PL_ATC_TrueHeading" call A3PL_Localize),floor (getDir _veh)]]; //heading
			ctrlSetText [1405, format [("STR_A3PL_ATC_Knots" call A3PL_Localize),floor (speed _veh * 0.539956803)]]; //ias
			ctrlSetText [1406, format [("STR_A3PL_ATC_FlightLevel" call A3PL_Localize),[_veh] call A3PL_ATC_GetFL]]; //alt
		};
	};

	//Set the Clearance
	private _display = findDisplay 91;
	private _control = _display displayCtrl 2500;

	if (_veh getVariable ["clearance",false]) then {
		_control ctrlSetChecked true;
	} else {
		_control ctrlSetChecked false;
	};
}] call compile_Global;

["A3PL_ATC_RadarRange", {
	params [["_increase",true,[true]]];

	if (_increase) then {
		A3PL_ATC_VAR_Radius = A3PL_ATC_VAR_Radius + 100;
	} else {
		A3PL_ATC_VAR_Radius = A3PL_ATC_VAR_Radius - 100;
	};

	if (A3PL_ATC_VAR_Radius < 100) then {
		A3PL_ATC_VAR_Radius = 0;
	};

	if (A3PL_ATC_VAR_Radius > 20000) then {
		A3PL_ATC_VAR_Radius = 20000;
	};

	ctrlSetText [1011, format [("STR_A3PL_ATC_RadarRadius" call A3PL_Localize),A3PL_ATC_VAR_Radius,[(A3PL_ATC_VAR_Radius*0.000539957),1] call BIS_fnc_cutDecimals]];
}] call compile_Global;

["A3PL_ATC_Transfer", {
	disableSerialization;
	if (isNull A3PL_ATC_VAR_Selected) exitwith {[("STR_A3PL_ATC_AircraftNotSelected" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _display = findDisplay 91;
	private _control = _display displayCtrl 2500;

	A3PL_ATC_VAR_Selected setVariable ["callsign",ctrlText 1401,true];
	A3PL_ATC_VAR_Selected setVariable ["clearance",(ctrlChecked _control),true];
}] call compile_Global;

["A3PL_ATC_RadarStart", {
	disableSerialization;

	createDialog "Dialog_ATC";
	(findDisplay 91) call A3PL_Dialog_Localize;
	buttonSetAction [1601, "[true] call A3PL_ATC_RadarRange;"];
	buttonSetAction [1600, "[false] call A3PL_ATC_RadarRange;"];
	buttonSetAction [1603, "call A3PL_ATC_ATISPreview;"];
	buttonSetAction [1604, "A3PL_ATC_ATISTEXT = ctrlText 1407; publicVariable 'A3PL_ATC_ATISTEXT';"];
	buttonSetAction [1602, "call A3PL_ATC_Transfer"];

	if (!isNil "A3PL_ATC_ATISTEXT") then
	{
		ctrlSetText [1407,A3PL_ATC_ATISTEXT];
	} else
	{
		ctrlSetText [1407,("STR_A3PL_ATC_NoATISAvailable" call A3PL_Localize)];
	};

	private _display = findDisplay 91;
	private _control = _display displayCtrl 1100;

	//airport description
	_control ctrlSetStructuredText parseText
	format
	[
		("STR_A3PL_ATC_Info" call A3PL_Localize),
		windDir,
		gusts,
		overcast,
		overcastForecast,
		rain,
		fog,
		fogForecast,
		(nextWeatherChange / 60),
		lightnings,
		windStr
	];

	//Define outer radius
	A3PL_ATC_VAR_Radius = 200;
	//define selected aircraft
	A3PL_ATC_VAR_Selected = objNull;
	//Defines controls that we will manage later on
	A3PL_ATC_Var_Controls = [];


	private _tPassed = 1.1; //variable we will use to get a list of aircraft at time intervals, nearestobjects can be intensive at higher radar radius

	private _planes = [];

	//define the blips we will remove
	private _prevPlanes = nearestObjects [player,["Plane","Helicopter"],A3PL_ATC_Var_Radius];
	{
		private _altitude = ((getPosASL (_x)) select 2);
		private _mode = _x getVariable ["transponder","STBY"];
		if((_altitude < 50) && !(_mode isEqualTo "IDENT")) then {
			_prevPlanes deleteAt _forEachIndex;
		};
	} foreach _prevPlanes;
	while {!isNull _display} do
	{
		//get aircraft list from player origin based on set Radius
		if (_tPassed > 1) then {
			_planes = nearestObjects [player,["Plane","Helicopter"],A3PL_ATC_Var_Radius];
			{
				private _altitude = ((getPosASL (_x)) select 2);
				private _mode = _x getVariable ["transponder","STBY"];
				if((_altitude < 50) && !(_mode isEqualTo "IDENT")) then {
					_planes deleteAt _forEachIndex;
				};
			} foreach _planes;
			_tPassed = 0;
		};

		//Move our radar thingy
		_control = _display displayCtrl 1201;
		private _aControl = ((ctrlAngle _control) select 0) + 2;
		if (_aControl >= 360) then {_aControl = 0};
		_control ctrlSetAngle [_aControl,0.5,0.5];

		{
			if ((!(_x IN _planes)) OR ((_x getVariable ["transponder","STBY"]) == "OFF")) then
			{
				{
					ctrlDelete _x;
				} foreach (_x getVariable ["controls",[]]);
			};
		} foreach _prevPlanes;

		_prevPlanes = _planes;

		{

			private _plane = _x;
			//check if our radar thingy is near a plane and the transponder isn't off
			private _aCheck = ((_plane getDir player) - (getDir player)) + 180;
			if (_aCheck >= 360) then {_aCheck = _acheck - 360; };
			if (_aCheck < 0) then {_aCheck = _acheck + 360;};
			if ((_aControl > (_aCheck - 1)) && (_aControl < (_aCheck + 1)) && ((_plane getVariable ["transponder","STBY"]) != "OFF")) then
			{
				player say "Beep_Target";

				//delete our prev controls for this plane
				{
					private ["_x"];
					if (_x IN (_plane getVariable ["controls",[]])) then
					{
						ctrlDelete _x;
					};
				} foreach A3PL_ATC_Var_Controls;

				//refresh stats if select
				if (_plane == A3PL_ATC_VAR_Selected) then
				{
					[_plane] call A3PL_ATC_SetAircraftInfo;
				};

				//reset _v
				private _v = [];

				/*
					X = xcircle + (r * cosine(angle))
					Y = ycircle + (r * sine(angle))
				*/

				private _dirBlip = ((_plane getDir player) - (getDir player)) + 90;

				_control = _display ctrlCreate ["RscPicture", -1];
				_v pushback _control;

				A3PL_ATC_Var_Controls pushback _control;

				if (_plane isKindOf "helicopter") then {
					_control ctrlSetText "\A3PL_Common\GUI\ATC\atc_triangle.paa";
				} else {
					_control ctrlSetText "\A3PL_Common\GUI\ATC\atc_square.paa";
				};

				//No fucking clue what I did but it works
				private _xC = ((((player distance2D _plane) * cos(_dirBlip))) / (A3PL_ATC_VAR_Radius * 2.8)) / 2;
				private _yC = ((((player distance2D _plane) * sin(_dirBlip))) / (A3PL_ATC_VAR_Radius * 2.8));


				_control ctrlSetPosition [((_xC + 0.495365) * safezoneW + safezoneX),((_yC + 0.501741) * safezoneH + safezoneY),(0.01 * safezoneW),(0.0177778 * safezoneH)];
				_control ctrlCommit 0;

				//direction
				_control = _display ctrlCreate ["RscPicture", -1];
				_v pushback _control;
				A3PL_ATC_Var_Controls pushback _control;
				_control ctrlSetText "\A3PL_Common\GUI\ATC\atc_direction.paa";
				_control ctrlSetPosition [((_xC + 0.470104) * safezoneW + safezoneX),((_yC + 0.460104) * safezoneH + safezoneY),(0.06 * safezoneW),(0.106667 * safezoneH)];
				_control ctrlCommit 0;
				_control ctrlSetAngle [(getDir _plane - getDir player),0.5,0.5];

				//Lets take care of what happends when you press the aircraft *blip*
				_control = _display ctrlCreate ["RscButton", -1];
				_v pushback _control;
				A3PL_ATC_Var_Controls pushback _control;
				_control ctrlSetPosition [((_xC + 0.495365) * safezoneW + safezoneX),((_yC + 0.501741) * safezoneH + safezoneY),(0.01 * safezoneW),(0.0177778 * safezoneH)];
				_control ctrlSetFade 1;
				_control ctrlCommit 0;
				_control buttonSetAction format ["['%1'] call A3PL_ATC_SetAircraftInfo;",_plane];

				//now lets take care of the structured info :)
				_control = _display ctrlCreate ["RscStructuredText", -1];
				_v pushback _control;
				A3PL_ATC_Var_Controls pushback _control;
				_control ctrlSetPosition [((_xC + 0.410104) * safezoneW + safezoneX),((_yC + 0.520104) * safezoneH + safezoneY),(0.2 * safezoneW),(0.1 * safezoneH)];

				private _mode = _plane getVariable ["transponder","STBY"];
				private _atcStruc = "";

				switch (_mode) do
				{
					case "STBY":
					{
						_atcStruc =
						format
						[
							("STR_A3PL_ATC_STBY" call A3PL_Localize),
							[_plane] call A3PL_ATC_GetType,
							_plane getVariable ["callsign","UNDEF"],
							_plane getVariable ["Squawk",1200]
						];
					};
					case "IDENT":
					{
						_atcStruc =
						format
						[
							("STR_A3PL_ATC_IDENT" call A3PL_Localize),
							[_plane] call A3PL_ATC_GetType,
							_plane getVariable ["callsign","UNDEF"],
							_plane getVariable ["Squawk",1200],
							floor (getDir _plane),
							[_plane] call A3PL_ATC_GetFL,
							floor (speed _plane * 0.539956803)
						];
					};
					case "C":
					{
						_atcStruc =
						format
						[
							("STR_A3PL_ATC_C" call A3PL_Localize),
							[_plane] call A3PL_ATC_GetType,
							_plane getVariable ["callsign","UNDEF"],
							_plane getVariable ["Squawk",1200],
							floor (getDir _plane),
							[_plane] call A3PL_ATC_GetFL,
							floor (speed _plane * 0.539956803)
						];
					};
				};
				_control ctrlSetStructuredText parseText _atcStruc;
				_control ctrlCommit 0;

				_plane setVariable ["controls",_v,false];
			};
		} foreach _planes;
		_tPassed = _tPassed + 0.01;
		uiSleep 0.01;
	};
}] call compile_Global;
