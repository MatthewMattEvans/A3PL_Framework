/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_SmartMarker_showToolTip", {
	_marker = _this select 0;
	_toolTipClass = _this select 1;

	if (smart_marker_settings_toolt_active) exitWith {
		[] call A3PL_SmartMarker_hideToolTip;
		smart_marker_settings_toolt_active = false;
	};

	smart_marker_settings_toolt_active = true;

	(uiNameSpace getVariable "map") ctrlMapCursor ["Track", "3DENSelectWidgetZ"];

	disableSerialization;

	_display = call BIS_fnc_displayMission;
	waitUntil {_display = call BIS_fnc_displayMission; !(isNull _display)};

	_position = (uiNameSpace getVariable "map") posWorldToScreen (getMarkerPos _marker);

	smart_marker_settings_toolt_ctrls = [];

	if (!(isNull (_display displayCtrl 1231))) then {
		ctrlDelete (_display displayCtrl 1231);
		ctrlDelete (_display displayCtrl 1232);
		ctrlDelete (_display displayCtrl 1233);
		ctrlDelete (_display displayCtrl 1234);
		ctrlDelete (_display displayCtrl 1235);
	};

	_titleBCK = _display ctrlCreate ["RscPicture", 1231];
	_textBCK = _display ctrlCreate ["RscPicture", 1232];
	_mrk_img = _display ctrlCreate ["RscPicture", 1233];
	_title2 =  _display ctrlCreate ["RscStructuredText", 1234];
	_text =  _display ctrlCreate ["RscStructuredText", 1235];
	{ smart_marker_settings_toolt_ctrls pushBack _x } forEach [_titleBCK,_textBCK,_title2, _text, _mrk_img];

	_XYPOS = _position;

	_titleBCK ctrlSetPosition [_XYPOS select 0, _XYPOS select 1,0.128864 * safezoneW,0.022 * safezoneH];
	_title2 ctrlSetPosition [_XYPOS select 0, _XYPOS select 1,0.128864 * safezoneW,0.022 * safezoneH];

	_textpos = [];

	_img = "";
	_title = "";
	_description = "";
	_color = [];

	if (typeName _toolTipClass isEqualTo "ARRAY") then {
		_title = _toolTipClass#0;
		_description = _toolTipClass#1;
		_img = _toolTipClass#2;
		_color = _toolTipClass#3;
	} else {
		_img = getText(_toolTipClass >> "img");
		_title = getText(_toolTipClass >> "title") call A3PL_LocalizeConfig;
		_description = getText(_toolTipClass >> "description") call A3PL_LocalizeConfig;
		_color = getArray(_toolTipClass >> "color");
	};

	switch (count _img) do
	{
		case 0:
		{
			_textpos = [_XYPOS select 0,(_XYPOS select 1) + 0.023 * safezoneH, 0.128864 * safezoneW, 0.187 * safezoneH]
		};

		default
		{
			_textpos = [_XYPOS select 0, (_XYPOS select 1) + 0.023 * safezoneH + (0.187 * safezoneH)/1.6,0.128864 * safezoneW,0.187 * safezoneH]
		};
	};

	_text ctrlSetPosition _textpos;
	_textBCK ctrlSetPosition _textpos;

	if (count _img > 0) then
	{
		_mrk_img ctrlSetPosition [_XYPOS select 0, (_XYPOS select 1) + 0.023 * safezoneH,0.128864 * safezoneW,(0.187 * safezoneH)/1.6];
		_mrk_img ctrlSetText _img;
	};

	_titleBCK ctrlSetText (_color call BIS_fnc_colorRGBAtoTexture);

	_textBCK ctrlSetText "a3\Ui_f\data\GUI\Rsc\RscDisplayInventory\gradient_gs.paa";
	_textBCK ctrlsetTextcolor [0, 0, 0, 0.6];

	_title2 ctrlSetStructuredText parseText format ["<t font='RobotoCondensed' shadow='1' color='#f7fae3' size='0.8' >%1</t>",_title];

	_text ctrlSetStructuredText parseText format ["<t font='RobotoCondensed' shadow='0' color='#d0d2c4' size='0.58' >%1</t><br/>", _description];

	if (count _img > 0) then
	{
		_mrk_img ctrlSetFade 0;
		_mrk_img ctrlCommit 0;
	};

	{
		_x ctrlSetFade 0;
		_x ctrlCommit 0;
	} foreach [_titleBCK,_textBCK,_title2,_text];
}] call compile_Global;

["A3PL_SmartMarker_hideToolTip", {
	(uiNameSpace getVariable "map") ctrlMapCursor ["Track", "Track"];

	{
		ctrlDelete _x;
	} foreach smart_marker_settings_toolt_ctrls;
	smart_marker_settings_toolt_ctrls = [];

	disableSerialization;

	_display = call BIS_fnc_displayMission;
	waitUntil {_display = call BIS_fnc_displayMission; !(isNull _display)};

	if (!(isNull (_display displayCtrl 1231))) then {
		ctrlDelete (_display displayCtrl 1231);
		ctrlDelete (_display displayCtrl 1232);
		ctrlDelete (_display displayCtrl 1233);
		ctrlDelete (_display displayCtrl 1234);
		ctrlDelete (_display displayCtrl 1235);
	};
}] call compile_Global;

["A3PL_SmartMarker_addMarker", {
	private ["_varName", "_systemMarker", "_typeClassName", "_toolTipPath", "_scales"];
	_systemMarker = [_this,0,"",[""]] call BIS_fnc_param;
	_typeClassName = [_this,1,"",[""]] call BIS_fnc_param;

	_varName = format["smt_mrks_%1", _systemMarker];

	if (_varName in smart_marker_markers_elements) exitWith {
		[_systemMarker, "show"] call A3PL_SmartMarker_showHideMarker;
	};

	_cfgSmartMarkers = (missionConfigFile >> "CfgSmartMarkers");
	_configMarkers = (_cfgSmartMarkers >> "ConfigMarkers");
	_typeCfg = (_configMarkers >> _typeClassName);


	if (!isClass(_typeCfg)) exitWith {
	};


	_toolTipPath = (_typeCfg >> "MarkerTooltip");
	_visible = true;
	_scales = getArray(_typeCfg >> "scales");

	_position = getMarkerPos _systemMarker;

	_markers = [];

	_lod = smart_marker_settings_lst_lod;
	_text = "";

	{
		private ["_class", "_varName2", "_sufix", "_className", "_marker"];
		_class = _x;
		_className = configName(_x);

		_sufix = getText(_class >> "sufix");

		_markerName = format["%1_%2", _systemMarker, _sufix];
		_marker = createMarkerLocal [_markerName, _position];

		_markers pushBack _marker;

		_varName2 = format["smt_mrks_%1", _marker];
		missionNamespace setVariable [_varName2, [_varName, _class]];

		if (_text == "" && _className == "MarkerText") then {
			_text = getText(_class >> "text") call A3PL_LocalizeConfig;
		};

		_type = [getArray(_class >> "type"), _lod] call A3PL_SmartMarker_findLodConfig;
		_size = [getArray(_class >> "size"), _lod] call A3PL_SmartMarker_findLodConfig;
		_color = [getArray(_class >> "color"), _lod] call A3PL_SmartMarker_findLodConfig;
		_alpha = [getArray(_class >> "alpha"), _lod] call A3PL_SmartMarker_findLodConfig;

		[_marker, _className, _type, _size, _color, _alpha, _text] call A3PL_SmartMarker_applyConfig;
	} forEach ("true" configClasses (_typeCfg >> "Sections"));

	_varParrent = [];

	missionNamespace setVariable [_varName, 
		[
			_markers,
			_toolTipPath,
			_visible,
			_scales,
			_varParrent
		]
	];

	smart_marker_markers_elements pushBack _varName;
}] call compile_Global;

["A3PL_SmartMarker_applyConfig", {
	private ["_marker", "_className", "_type", "_size", "_color", "_alpha", "_text"];
	_marker = [_this,0,"",[""]] call BIS_fnc_param;
	_className = [_this,1,"",[""]] call BIS_fnc_param;
	_type = [_this,2,"",[""]] call BIS_fnc_param;
	_size = [_this,3,[1, 1],[[]]] call BIS_fnc_param;
	_color = [_this,4,"",[""]] call BIS_fnc_param;
	_alpha = [_this,5,1,[0]] call BIS_fnc_param;
	_text = [_this,6,"",[""]] call BIS_fnc_param;

	switch (_className) do { 
		case "MarkerIconBackground" : {
			_marker setMarkerShapeLocal "ICON";
			_marker setMarkerTypeLocal _type;
			_marker setMarkerSizeLocal _size;
			_marker setMarkerColorLocal _color;
			_marker setMarkerAlphaLocal _alpha;
		};

		case "MarkerIcon" : {
			_marker setMarkerShapeLocal "ICON";
			_marker setMarkerTypeLocal _type;
			_marker setMarkerSizeLocal _size;
			_marker setMarkerColorLocal _color;
			_marker setMarkerAlphaLocal _alpha;
		};

		case "MarkerText" : {
			_marker setMarkerShapeLocal "ICON";
			_marker setMarkerTypeLocal "mil_box";
			_marker setMarkerSizeLocal [0,0];
			_marker setMarkerAlphaLocal _alpha;
			_marker setMarkerColorLocal _color;
			_marker setMarkerTextLocal "     " + _text;
		};

		default {}; 
	};
}] call compile_Global;

["A3PL_SmartMarker_findLodConfig", {
	private ["_configs", "_lod", "_nbOfConfig"];
	_configs = _this select 0;
	_lod = _this select 1;

	_nbOfConfig = count _configs;

	if (_nbOfConfig < (_lod + 1)) exitWith {
		_configs select 0;
	};

	_configs select _lod;
}] call compile_Global;

["A3PL_SmartMarker_hideParent", {
	_markerVar = [_this,0,"",[""]] call BIS_fnc_param;

	if (isNil {missionNamespace getVariable _markerVar}) exitWith {};

	_parentData = missionNamespace getVariable _markerVar;

	_visible = _parentData select 2;
	_childs = _parentData select 4;

	_needToHide = true;

	{
		_childData = (missionNamespace getVariable _x);

		_visibleChild = (_childData select 2);

		if (_visibleChild) then {
			_needToHide = false;
		};

	} forEach _childs;

	if (!_needToHide && _visible) exitWith {};

	if (_needToHide && _visible) then {
		_parentData set [2, false];
		missionNamespace setVariable [_markerVar, _parentData];
	};

	if (!_needToHide && !_visible) then {
		_parentData set [2, true];
		missionNamespace setVariable [_markerVar, _parentData];
	};

	[_markerVar] spawn A3PL_SmartMarker_updateMarker;
}] call compile_Global;

["A3PL_SmartMarker_Init", {
	waitUntil {!isNull ([] call BIS_fnc_displayMission)};
	waitUntil {markerIsConfig};

	uiNameSpace setvariable ["map", (findDisplay 12 displayCtrl 51)];

	smart_marker_ready = false;

	smart_marker_markers_elements = [];

	smart_marker_settings_current_mrk = false;
	smart_marker_settings_current_hide = false;
	smart_marker_settings_current = "";
	smart_marker_settings_currents = [];
	smart_marker_settings_lst_current_check = time;
	smart_marker_settings_lst_current_hide_check = time;

	smart_marker_settings_lst_scale = 1;
	smart_marker_settings_lst_scale_change = time;
	smart_marker_settings_lst_lod = 2;

	smart_marker_settings_toolt_active = false;
	smart_marker_settings_toolt_ctrls = [];

	smart_marker_settings_right_click = false;

	_cfgSmartMarkers = (missionConfigFile >> "CfgSmartMarkers");

	{
		[_x] call A3PL_SmartMarker_InitArea;
	} forEach ("true" configClasses (_cfgSmartMarkers >> "MarkersArea"));

	smart_marker_settings_clear_currents = {
		if (smart_marker_settings_current_mrk) then {
			smart_marker_settings_current_mrk = false;
			smart_marker_settings_current = "";
			smart_marker_settings_currents = [];
		};
	};

	(uiNameSpace getVariable "map") ctrlAddEventHandler [ "Draw", A3PL_SmartMarker_mapDraw];
	(uiNameSpace getVariable "map") ctrlAddEventHandler [ "MouseButtonUp", {["MouseButtonUp"] spawn A3PL_SmartMarker_mapHandleKey;}];
	(uiNameSpace getVariable "map") ctrlAddEventHandler [ "MouseButtonDown", {["MouseButtonDown"] spawn A3PL_SmartMarker_mapHandleKey;}];

	smart_marker_ready = true;
	smart_marker_gps_mode = false;

	[] spawn {
		while {true} do {
			uiSleep 0.2;
			if (!visibleMap) then {
				if (smart_marker_settings_toolt_active) then {
					smart_marker_settings_toolt_active = false;
					[] spawn A3PL_SmartMarker_hideToolTip;
				};

				if (visibleGPS && !smart_marker_gps_mode) then {
					smart_marker_gps_mode = true;
					[0.002] call A3PL_SmartMarker_mapScaleChange;
				};
			};
		};
	};
}] call compile_Global;

["A3PL_SmartMarker_InitArea", {
	private ["_area", "_child", "_parent", "_parentValue", "_childs", "_varName", "_side", "_visible"];
	_area = _this select 0;
	_child = [_this,1,false,[false]] call BIS_fnc_param;
	_parent = [_this,2,"",[""]] call BIS_fnc_param;

	_cfgSmartMarkers = (missionConfigFile >> "CfgSmartMarkers");

	_text = getText(_area >> "text") call A3PL_LocalizeConfig;
	_systemMarker = getText(_area >> "systemMarker");
	_typeClass = getText(_area >> "typeClass");

	_typeCfg = (_cfgSmartMarkers >> "ConfigMarkers" >> _typeClass);

	if (!isClass(_typeCfg)) exitWith {};

	_toolTipPath = (_area >> "MarkerTooltip");

	if (!isClass(_toolTipPath)) then {
		_toolTipPath = (_typeCfg >> "MarkerTooltip");
	};

	_visible = (getNumber(_area >> "visible") == 1);

	_pfaction = player getVariable ["faction","citizen"];
	_pJob = player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
	_factions = getArray(_area >> "visibleFaction");
	_jobs = getArray(_area >> "visibleJob");
	if (_pfaction IN _factions || _pJob IN _jobs) then {
		_visible = true;
	};

	_scales = getArray(_area >> "scales");
	if (count _scales != 2) then {
		_scales = getArray(_typeCfg >> "scales");
	};

	_position = getMarkerPos _systemMarker;

	_varName = format["smt_mrks_%1", _systemMarker];

	if (_child) then {
		_parentValue = (missionNamespace getVariable _parent);

		_childs = _parentValue select 4;
		_childs pushBack _varName;

		_parentValue set [4, _childs];
		missionNamespace setVariable [_parent, _parentValue];
	};

	_markers = [];

	_lod = 2;

	{
		_class = _x;
		_className = configName(_x);

		_sufix = getText(_class >> "sufix");

		_markerName = format["%1_%2", _systemMarker, _sufix];
		_marker = createMarkerLocal [_markerName, _position];

		_markers pushBack _marker;

		_varName2 = format["smt_mrks_%1", _marker];
		missionNamespace setVariable [_varName2, [_varName, _class]];

		if (_text == "" && _className == "MarkerText") then {
			_text = getText(_class >> "text") call A3PL_LocalizeConfig;
		};

		_type = [getArray(_class >> "type"), _lod] call A3PL_SmartMarker_findLodConfig;
		_size = [getArray(_class >> "size"), _lod] call A3PL_SmartMarker_findLodConfig;
		_alpha = [getArray(_class >> "alpha"), _lod] call A3PL_SmartMarker_findLodConfig;
		_color = [getArray(_class >> "color"), _lod] call A3PL_SmartMarker_findLodConfig;

		[_marker, _className, _type, _size, _color, _alpha, _text] call A3PL_SmartMarker_applyConfig;

		if (!_visible) then {
			_marker setMarkerAlphaLocal 0;
		};

		if (_child) then {
			_marker setMarkerAlphaLocal 0;
		};
	} forEach ("true" configClasses (_typeCfg >> "Sections"));

	_varParrent = [];

	if (_child) then {
		_varParrent = _parent;
	};

	missionNamespace setVariable [_varName, 
		[
			_markers,
			_toolTipPath,
			_visible,
			_scales,
			_varParrent
		]
	];

	smart_marker_markers_elements pushBack _varName;

	if (!_child) then {
		{
			[_x, true, _varName] call A3PL_SmartMarker_InitArea;
		} forEach ("true" configClasses (_area >> "Childs"));
	};
}] call compile_Global;

["A3PL_SmartMarker_Refresh", {
    private ["_playerFaction", "_playerJob", "_updateMarker"];

    _playerFaction = player getVariable ["faction", "citizen"];
    _playerJob = player getVariable ["job", ("STR_Common_Job_Unemployed" call A3PL_Localize)];

    diag_log format ["A3PL_SmartMarker_Refresh - Player Faction: %1, Job: %2", _playerFaction, _playerJob];

    _updateMarker = {
        params ["_markerVar"];
        private ["_markerData", "_visible", "_markers", "_parentVar"];

        _markerData = missionNamespace getVariable [_markerVar, []];
        
        diag_log format ["Processing marker: %1, Data: %2", _markerVar, _markerData];
        
        if (count _markerData >= 5) then {
            _markers = _markerData select 0;
            _visible = _markerData select 2;
            _parentVar = _markerData select 4;

            diag_log format ["Marker %1 - Initial visibility: %2, Parent: %3, Parent Type: %4", _markerVar, _visible, _parentVar, typeName _parentVar];

            if (typeName _parentVar == "STRING" && {_parentVar != ""}) then {
                _parentData = missionNamespace getVariable [_parentVar, []];
                if (typeName _parentData == "ARRAY" && {count _parentData >= 3}) then {
                    _visible = _visible && (_parentData select 2);
                    diag_log format ["Marker %1 - Parent visibility applied: %2", _markerVar, _visible];
                };
            };

            _cfgSmartMarkers = missionConfigFile >> "CfgSmartMarkers" >> "MarkersArea";
            _systemMarker = _markerVar select [9];
            {
                if (getText(_x >> "systemMarker") isEqualTo _systemMarker) exitWith {
                    _factions = getArray(_x >> "visibleFaction");
                    _jobs = getArray(_x >> "visibleJob");
                    _visible = _visible && ((_playerFaction in _factions) || (_playerJob in _jobs));
                    diag_log format ["Marker %1 - Faction/Job check: Factions %2, Jobs %3, New visibility %4", _markerVar, _factions, _jobs, _visible];
                };
            } forEach ("true" configClasses _cfgSmartMarkers);

            {
                _x setMarkerAlphaLocal (if (_visible) then {1} else {0});
                diag_log format ["Setting marker %1 alpha to %2", _x, if (_visible) then {1} else {0}];
            } forEach _markers;

            _markerData set [2, _visible];
            missionNamespace setVariable [_markerVar, _markerData];
        } else {
            diag_log format ["Invalid marker data for %1", _markerVar];
        };
    };

    {
        [_x] call _updateMarker;
    } forEach smart_marker_markers_elements;

    diag_log "A3PL_SmartMarker_Refresh completed";
}] call compile_Global;

["A3PL_SmartMarker_mapDraw", {
	if (!visibleMap) exitWith {
		[] call smart_marker_settings_clear_currents;
		if (smart_marker_settings_toolt_active) then {
			smart_marker_settings_toolt_active = false;
			[] spawn A3PL_SmartMarker_hideToolTip;
		};
	};

	_currentScale = ctrlMapScale (uiNameSpace getVariable "map");
	_scaleChanged = false;
	if (_currentScale != smart_marker_settings_lst_scale) then {
		_scaleChanged = true;
		[_currentScale] call A3PL_SmartMarker_mapScaleChange;
	};

	if (smart_marker_gps_mode) then {
		smart_marker_gps_mode = false;
	};

	if (smart_marker_settings_right_click) exitWith {
		[] call smart_marker_settings_clear_currents;
		if (smart_marker_settings_toolt_active) then {
			smart_marker_settings_toolt_active = false;
			[] spawn A3PL_SmartMarker_hideToolTip;
		};
	};

	_mouseOver = ctrlMapMouseOver (uiNameSpace getVariable "map");

	if (count _mouseOver == 0) exitWith {
		[] call smart_marker_settings_clear_currents;
		if (smart_marker_settings_toolt_active) then {
			smart_marker_settings_toolt_active = false;
			[] spawn A3PL_SmartMarker_hideToolTip;
		};
	};

	if ((_mouseOver select 0) != "marker") exitWith {
		[] call smart_marker_settings_clear_currents;
		if (smart_marker_settings_toolt_active) then {
			smart_marker_settings_toolt_active = false;
			[] spawn A3PL_SmartMarker_hideToolTip;
		};
	};

	_markerName = (_mouseOver select 1);

	if (_scaleChanged) then {
		if (_markerName in smart_marker_settings_currents) then {
			smart_marker_settings_lst_current_check = time;
			_markerAlpha = markerAlpha (smart_marker_settings_currents select 1);
			if (_markerAlpha == 0) then {
				if (smart_marker_settings_toolt_active) then {
					smart_marker_settings_toolt_active = false;
					[] spawn A3PL_SmartMarker_hideToolTip;
				};

				smart_marker_settings_current_hide = true;
			};
		};
	};

	if (smart_marker_settings_current_hide && _scaleChanged) then {
		if (_markerName in smart_marker_settings_currents) then {
			smart_marker_settings_lst_current_hide_check = time;
			_markerAlpha = markerAlpha (smart_marker_settings_currents select 1);
			if (_markerAlpha != 0) then {
				[] call smart_marker_settings_clear_currents;
				smart_marker_settings_current_hide = false;
			};
		};
	};


	if (smart_marker_settings_current == _markerName) exitWith {};
	smart_marker_settings_current_mrk = true;
	smart_marker_settings_current = _markerName;

	if (_markerName in smart_marker_settings_currents) exitWith {};

	private ["_varName", "_dataMarker", "_parentData", "_parentVar"];

	_varName = format["smt_mrks_%1", _markerName];
	if (isNil {missionNamespace getVariable _varName}) exitWith {
		if (smart_marker_settings_toolt_active) then {
			smart_marker_settings_toolt_active = false;
			[] spawn A3PL_SmartMarker_hideToolTip;
		};
	};

	smart_marker_settings_currents = [];
	smart_marker_settings_currents pushBack _markerName;

	_dataMarker = missionNamespace getVariable _varName;
	_parentData = _dataMarker;

	if (count _dataMarker == 2) then {
		_parentVar = _dataMarker select 0;
		_parentData = missionNamespace getVariable _parentVar;
	};

	_markers = _parentData select 0;
	_toolTipClass = _parentData select 1;

	smart_marker_settings_currents = smart_marker_settings_currents + _markers;

	_marker = _markers select 0;

	if (markerAlpha _marker == 0) exitWith {
		smart_marker_settings_current_hide = true;
	};

	smart_marker_settings_current_hide = false;

	if (typeName _toolTipClass != "CONFIG" && typeName _toolTipClass != "ARRAY") exitWith {};
	if (typeName _toolTipClass isEqualTo "CONFIG" && {!isClass(_toolTipClass)}) exitWith {};

	[_marker, _toolTipClass] spawn A3PL_SmartMarker_showToolTip;
}] call compile_Global;

["A3PL_SmartMarker_mapHandleKey", {
	_key = [_this,0,"",[""]] call BIS_fnc_param;

	if (_key == "MouseButtonDown") then {
		smart_marker_settings_right_click = true;
	} else {
		smart_marker_settings_right_click = false;
	};
}] call compile_Global;

["A3PL_SmartMarker_mapScaleApply", {
	private ["_marker", "_lod", "_varName", "_data"];
	_marker = _this select 0;
	_lod = _this select 1;

	_varName = format["smt_mrks_%1", _marker];

	_data = missionNamespace getVariable _varName;
	if (isNil "_data") exitWith {};
	_sectionClass = (_data select 1);
	if (isNil "_sectionClass" || {typeName _sectionClass != "CONFIG"}) exitWith {};

	_currAlpha = markerAlpha _marker;
	_currColor = markerColor _marker;

	_suffix = getText(_sectionClass >> "sufix");

	_type = [getArray(_sectionClass >> "type"), _lod] call A3PL_SmartMarker_findLodConfig;
	_color = [getArray(_sectionClass >> "color"), _lod] call A3PL_SmartMarker_findLodConfig;
	_alpha = [getArray(_sectionClass >> "alpha"), _lod] call A3PL_SmartMarker_findLodConfig;

	switch (true) do {
		case (_suffix == "text") : {
			if (!(_currAlpha isEqualTo _alpha)) then {
				_marker setMarkerAlphaLocal _alpha;
			};

			if (!(_currColor isEqualTo _color)) then {
				_marker setMarkerColorLocal _color;
			};
		};
		case (_suffix == "back" || (_suffix == "icon")): {
			_size = [getArray(_sectionClass >> "size"), _lod] call A3PL_SmartMarker_findLodConfig;

			_currType = markerType _marker;
			_currSize = markerSize _marker;

			if (!(_currAlpha isEqualTo _alpha)) then {
				_marker setMarkerAlphaLocal _alpha;
			};

			if (!(_currColor isEqualTo _color)) then {
				_marker setMarkerColorLocal _color;
			};

			if (!(_currSize isEqualTo _size)) then {
				_marker setMarkerSizeLocal _size;
			};

			if (!(_currType isEqualTo _type)) then {
				_marker setMarkerTypeLocal _type;
			};

			if (!(_currSize isEqualTo _size)) then {
				_marker setMarkerSizeLocal _size;
			};
		};
	};
}] call compile_Global;

["A3PL_SmartMarker_mapScaleChange", {
	private ["_lod"];
	_newScale = [_this,0,1,[0]] call BIS_fnc_param;
	_lastScale = smart_marker_settings_lst_scale;

	if (time < (smart_marker_settings_lst_scale_change + 0.1)) exitWith {};

	_lod = 0;

	switch (true) do
	{
		case (_newScale >= 0 && _newScale < 0.0347353): { _lod = 0 };
		case (_newScale >= 0 && _newScale < 0.431711): { _lod = 1 };
		case (_newScale >= 0.431711 && _newScale <= 1): { _lod = 2 };
	};

	{
		_varName = _x;

		if (isNil {missionNamespace getVariable _varName}) then {
			diag_log format["Error Nil: %1", _varName];
		};

		_varValue = missionNamespace getVariable _varName;

		_markers = (_varValue select 0);
		_visible = (_varValue select 2);
		_visibleScales = (_varValue select 3);

		if (_visible) then {

			_needToHide = false;

			_minScale = _visibleScales select 0;
			_maxScale = _visibleScales select 1;

			if (_newScale < _minScale || _newScale > _maxScale) then {
				_needToHide = true;
			};

			{
				_marker = _x;
				_alpha = markerAlpha _marker;

				if (_needToHide && _alpha != 0) then {
					_marker setMarkerAlphaLocal 0;
				};

				if (!_needToHide) then {
					if (_alpha == 0 || smart_marker_settings_lst_lod != _lod) then {
						[_x, _lod] spawn A3PL_SmartMarker_mapScaleApply;
					};
				};
			} forEach _markers;
		};

	} forEach smart_marker_markers_elements;

	smart_marker_settings_lst_scale = _newScale;
	smart_marker_settings_lst_scale_change = time;
	smart_marker_settings_lst_lod = _lod;
}] call compile_Global;

["A3PL_SmartMarker_showParent", {
	private ["_markerVar", "_parentData", "_visible"];
	_markerVar = [_this,0,"",[""]] call BIS_fnc_param;

	if (isNil {missionNamespace getVariable _markerVar}) exitWith {};

	_parentData = missionNamespace getVariable _markerVar;

	_visible = _parentData select 2;

	if (_visible) exitWith {};

	_parentData set [2, true];
	missionNamespace setVariable [_markerVar, _parentData];

	[_markerVar] spawn A3PL_SmartMarker_updateMarker;
}] call compile_Global;

["A3PL_SmartMarker_updateMarker", {
	private ["_markerVar", "_dataMarker", "_markers", "_visible"];
	_markerVar = [_this,0,"",[""]] call BIS_fnc_param;

	if (isNil {missionNamespace getVariable _markerVar}) exitWith {};

	_dataMarker = missionNamespace getVariable _markerVar;

	_markers = _dataMarker select 0;
	_visible = _dataMarker select 2;

	if (_visible) then {
		_needToHide = false;
		
		_visibleScales = _dataMarker select 3;

		_minScale = _visibleScales select 0;
		_maxScale = _visibleScales select 1;

		if (smart_marker_settings_lst_scale < _minScale || smart_marker_settings_lst_scale > _maxScale) then {
			_needToHide = true;
		};

		{
			private ["_marker"];

			_marker = _x;
			_alpha = markerAlpha _marker;

			if (_needToHide && _alpha != 0) then {
				_marker setMarkerAlphaLocal 0;
			};

			if (!_needToHide) then {
				[_x, smart_marker_settings_lst_lod] spawn A3PL_SmartMarker_mapScaleApply;
			};
		} forEach _markers;
	};

	if (!_visible) then {
		{
			_x setMarkerAlphaLocal 0;
		} forEach _markers;
	};
}] call compile_Global;

["A3PL_SmartMarker_showHideMarker", {
	private ["_marker", "_action", "_varName", "_dataMarker", "_parentData", "_parentVar", "_visible"];
	_marker = [_this,0,"",[""]] call BIS_fnc_param;
	_action = [_this,1,"",[""]] call BIS_fnc_param;

	_varName = format["smt_mrks_%1", _marker];
	if (isNil {missionNamespace getVariable _varName}) exitWith {};

	_dataMarker = missionNamespace getVariable _varName;
	_parentData = _dataMarker;

	_parentVar = _varName;
	if (count _dataMarker == 2) then {
		_parentVar = _dataMarker select 0;
		_parentData = missionNamespace getVariable _parentVar;
	};

	_visible = _parentData select 2;

	if (_visible && _action == "show") exitWith {};
	if (!_visible && _action == "hide") exitWith {};

	_changeVisible = true;

	if (_action == "show") then {
		_changeVisible = true;
	};

	if (_action == "hide") then {
		_changeVisible = false;
	};

	_parentData set [2, _changeVisible];
	missionNamespace setVariable [_parentVar, _parentData];

	[_parentVar] spawn A3PL_SmartMarker_updateMarker;

	_isParent = false;
	_hasChilds = false;

	_parentInfo = _parentData select 4;

	if (typeName _parentInfo == "ARRAY") then {
		_isParent = true;
	};

	if (_isParent && _hasChilds) exitWith {/* Impossible */};
	if (_isParent && !_hasChilds) exitWith {};

	if (!_isParent) then {
		if (_action == "show") then {
			[_parentInfo] call A3PL_SmartMarker_showParent;
		};

		if (_action == "hide") then {
			[_parentInfo] call A3PL_SmartMarker_hideParent;
		};
	};
}] call compile_Global;

["A3PL_SmartMarker_mapMarker", {
	{
		_markerRec = getText(_x >> "marker");
		_dispo = getArray(_x >> "markersPos");
		_settings = getArray(_x >> "settings");
		_displayName = getText(_x >> "displayName");

		if (count _dispo > 0) then {
			_selectMarker = _dispo select floor random count _dispo;
			_marker = createMarker [_markerRec, markerPos _selectMarker];
		};
	} forEach ("true" configClasses (missionConfigFile >> "CfgMarkers"));
	markerIsConfig = true;
	publicVariable "markerIsConfig";
}] call compile_Global;

/* ============================================
   DYNAMIC SMART MARKERS - COMPANY SHOPS
   ============================================ */

["A3PL_SmartMarker_addCompanyShop", {
	params [
		["_systemMarker","",[""]],
		["_position",[0,0,0],[[]]],
		["_icon","A3FL_Markers_CompanyShopClosed",[""]],
		["_companyName","",[""]],
		["_description","",[""]],
		["_isOpen",0,[0]],
		["_isWarehouse",false,[false]]
	];

	if (isNil "_description") then { _description = ""; };

	if (_systemMarker isEqualTo "") exitWith {};
	if (!smart_marker_ready) exitWith {};

	private _varName = format["smt_mrks_%1", _systemMarker];

	if (_varName in smart_marker_markers_elements) exitWith {
		[_systemMarker, _position, _icon, _companyName, _description, _isOpen, _isWarehouse] call A3PL_SmartMarker_updateCompanyShop;
	};

	if (_position isEqualTo [0,0,0]) then {
		_position = getMarkerPos _systemMarker;
	};
	if (_position isEqualTo [0,0,0]) exitWith {};

	private _markers = [];

	private _bgColor = if (_isWarehouse) then {"ColorWhite"} else {if (_isOpen isEqualTo 1) then {"ColorGreen"} else {"ColorRed"}};
	private _iconColor = "ColorWhite";
	private _textColor = if (_isWarehouse) then {"ColorWhite"} else {if (_isOpen isEqualTo 1) then {"ColorGreen"} else {"ColorRed"}};

	// Background
	private _markerBack = createMarkerLocal [format["%1_back", _systemMarker], _position];
	_markerBack setMarkerShapeLocal "ICON";
	_markerBack setMarkerTypeLocal "n_unknown";
	_markerBack setMarkerSizeLocal [0.7, 0.7];
	_markerBack setMarkerColorLocal _bgColor;
	_markerBack setMarkerAlphaLocal 1;
	_markers pushBack _markerBack;

	// Icon
	private _markerIcon = createMarkerLocal [format["%1_icon", _systemMarker], _position];
	_markerIcon setMarkerShapeLocal "ICON";
	_markerIcon setMarkerTypeLocal _icon;
	_markerIcon setMarkerSizeLocal [0.7, 0.7];
	_markerIcon setMarkerColorLocal _iconColor;
	_markerIcon setMarkerAlphaLocal 1;
	_markers pushBack _markerIcon;

	// Text
	private _displayText = if (_isWarehouse) then {
		format["%1 %2", ("STR_Server_Company_WarehouseOf" call A3PL_Localize), _companyName]
	} else {
		private _statusText = if (_isOpen isEqualTo 1) then {("STR_Server_Company_Open" call A3PL_Localize)} else {("STR_Server_Company_Close" call A3PL_Localize)};
		format["[%1] %2", _statusText, _companyName]
	};
	private _markerText = createMarkerLocal [format["%1_text", _systemMarker], _position];
	_markerText setMarkerShapeLocal "ICON";
	_markerText setMarkerTypeLocal "mil_box";
	_markerText setMarkerSizeLocal [0,0];
	_markerText setMarkerColorLocal _textColor;
	_markerText setMarkerAlphaLocal 1;
	_markerText setMarkerTextLocal ("     " + _displayText);
	_markers pushBack _markerText;

	// Register sub-markers for mouse hover detection
	{
		private _subVarName = format["smt_mrks_%1", _x];
		missionNamespace setVariable [_subVarName, [_varName, nil]];
	} forEach _markers;

	// Tooltip data [title, description, img, color]
	private _tooltipData = [_companyName, _description, "", [0.345,0.345,0.345,0.6]];

	missionNamespace setVariable [_varName, [
		_markers,
		_tooltipData,
		true,
		[0, 1],
		[]
	]];

	smart_marker_markers_elements pushBack _varName;
}] call compile_Global;

["A3PL_SmartMarker_updateCompanyShop", {
	params [
		["_systemMarker","",[""]],
		["_position",[0,0,0],[[]]],
		["_icon","A3FL_Markers_CompanyShopClosed",[""]],
		["_companyName","",[""]],
		["_description","",[""]],
		["_isOpen",0,[0]],
		["_isWarehouse",false,[false]]
	];

	if (isNil "_description") then { _description = ""; };

	private _varName = format["smt_mrks_%1", _systemMarker];
	if !(_varName in smart_marker_markers_elements) exitWith {
		[_systemMarker, _position, _icon, _companyName, _description, _isOpen, _isWarehouse] call A3PL_SmartMarker_addCompanyShop;
	};

	private _data = missionNamespace getVariable [_varName, []];
	if (count _data < 5) exitWith {};

	private _markers = _data select 0;

	private _bgColor = if (_isWarehouse) then {"ColorWhite"} else {if (_isOpen isEqualTo 1) then {"ColorGreen"} else {"ColorRed"}};
	private _textColor = if (_isWarehouse) then {"ColorWhite"} else {if (_isOpen isEqualTo 1) then {"ColorGreen"} else {"ColorRed"}};

	// Update background color
	if (count _markers > 0) then {
		(_markers#0) setMarkerColorLocal _bgColor;
	};

	// Update icon type
	if (count _markers > 1) then {
		(_markers#1) setMarkerTypeLocal _icon;
	};

	// Update text
	if (count _markers > 2) then {
		private _displayText = if (_isWarehouse) then {
			format["%1 %2", ("STR_Server_Company_WarehouseOf" call A3PL_Localize), _companyName]
		} else {
			private _statusText = if (_isOpen isEqualTo 1) then {("STR_Server_Company_Open" call A3PL_Localize)} else {("STR_Server_Company_Close" call A3PL_Localize)};
			format["[%1] %2", _statusText, _companyName]
		};
		(_markers#2) setMarkerColorLocal _textColor;
		(_markers#2) setMarkerTextLocal ("     " + _displayText);
	};

	// Update tooltip
	_data set [1, [_companyName, _description, "", [0.345,0.345,0.345,0.6]]];
	missionNamespace setVariable [_varName, _data];
}] call compile_Global;

["A3PL_SmartMarker_removeCompanyShop", {
	params [["_systemMarker","",[""]]] ;

	private _varName = format["smt_mrks_%1", _systemMarker];
	if !(_varName in smart_marker_markers_elements) exitWith {};

	private _data = missionNamespace getVariable [_varName, []];
	if (count _data < 1) exitWith {};

	{
		private _subVarName = format["smt_mrks_%1", _x];
		missionNamespace setVariable [_subVarName, nil];
		deleteMarkerLocal _x;
	} forEach (_data select 0);

	missionNamespace setVariable [_varName, nil];
	smart_marker_markers_elements = smart_marker_markers_elements - [_varName];
}] call compile_Global;

["A3PL_SmartMarker_InitCompanyShops", {
	waitUntil {smart_marker_ready};
	waitUntil {!isNil "Server_CompanyShopMarkers"};

	{
		_x params ["_markerId", "_pos", "_icon", "_companyName", "_description", "_isOpen", "_isWarehouse"];
		[_markerId, _pos, _icon, _companyName, _description, _isOpen, _isWarehouse] call A3PL_SmartMarker_addCompanyShop;
	} forEach Server_CompanyShopMarkers;
}] call compile_Global;