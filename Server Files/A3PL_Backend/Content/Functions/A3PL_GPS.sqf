/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com

    GPS Navigation System - Full adaptation from A3GPS by [Utopia] Amaury
    Integration for A3PL Framework
    Version: 1.1 A3PL
*/

// ============================================================================
// SECTION 1: GLOBAL VARIABLES AND INITIALIZATION
// ============================================================================

["A3PL_GPS_Init",
{
    // GPS DISABLED - No UI available yet. Remove this block to re-enable GPS.
    diag_log "A3PL: GPS - System is DISABLED (no UI). Skipping initialization.";
    A3PL_GPS_InitDone = false;
    A3PL_GPS_CoreInitDone = false;
    if (true) exitWith {};

    if (!isNil "A3PL_GPS_InitStarted" && {A3PL_GPS_InitStarted}) exitWith { diag_log "A3PL: GPS - Already initialized, skipping"; };
    A3PL_GPS_InitStarted = true;
    A3PL_GPS_CurrentThread = scriptNull;
    A3PL_GPS_CurrentGoal = [0,0,0];
    A3PL_GPS_InitDone = false;
    A3PL_GPS_CoreInitDone = false;
    A3PL_GPS_DrawPoints = [];
    A3PL_GPS_AllRoads = [];
    A3PL_GPS_QuickNavOptions = [];
    A3PL_GPS_IconsPath = "A3PL_GPS\icons\";

    A3PL_GPS_AllCrossRoadsWithWeight = [] call A3PL_GPS_HashTable_Create;
    A3PL_GPS_RoadsWithConnected = [] call A3PL_GPS_HashTable_Create;
    A3PL_GPS_FakeNodes = [] call A3PL_GPS_HashTable_Create;

    diag_log "A3PL: GPS System - Initialization started";

    [] call A3PL_GPS_RefreshCache;
    [] spawn A3PL_GPS_MapRoutes;

    [] spawn {
        waitUntil {A3PL_GPS_CoreInitDone};

        ["STR_A3PL_GPS_QuickNavFuel" call A3PL_Localize, {
            private _fuelStations = nearestObjects [player, ["Land_A3PL_Gas_Station"], 15000];
            if (_fuelStations isNotEqualTo []) then {
                [getPosATL (_fuelStations select 0)] spawn A3PL_GPS_Navigate;
            };
        }] call A3PL_GPS_AddQuickNavOption;

        ["STR_A3PL_GPS_QuickNavTown" call A3PL_Localize, {
            private _town = [getPosATL player, 10000, ["NameCity","NameVillage","NameCityCapital","NameLocal"]] call A3PL_GPS_NearestLocation;
            if (!isNull _town) then {
                [locationPosition _town] spawn A3PL_GPS_Navigate;
            };
        }] call A3PL_GPS_AddQuickNavOption;

        waitUntil { !isNull findDisplay 46 };
        (findDisplay 46) displayAddEventHandler ["KeyDown", A3PL_GPS_HandleQuickNavActions];
        ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["Draw", A3PL_GPS_DrawPath];

        A3PL_GPS_InitDone = true;
        diag_log "A3PL: GPS System - Fully initialized";
    };
}] call compile_Global;

// ============================================================================
// SECTION 2: HASH MAP FUNCTIONS (native Arma 3 HashMap)
// ============================================================================

["A3PL_GPS_HashTable_Create",
{
    createHashMap
}] call compile_Global;

["A3PL_GPS_HashTable_Find",
{
    params ["_map","_key"];
    _map getOrDefault [_key, nil]
}] call compile_Global;

["A3PL_GPS_HashTable_Set",
{
    params ["_map","_key","_val"];
    _map set [_key, _val];
}] call compile_Global;

["A3PL_GPS_HashTable_Exists",
{
    params ["_map","_key"];
    _key in _map
}] call compile_Global;

["A3PL_GPS_HashTable_DeleteNameSpaces",
{
    // No-op with native HashMaps, garbage collected automatically
}] call compile_Global;

// ============================================================================
// SECTION 3: PRIORITY QUEUE FUNCTIONS
// ============================================================================

["A3PL_GPS_PQ_Insert",
{
    params ["_queue","_priority","_counter","_element"];
    _queue pushBack [_priority, _counter, _element];
    _queue sort true;
}] call compile_Global;

["A3PL_GPS_PQ_Get",
{
    params ["_queue"];
    (_queue deleteAt 0) select 2
}] call compile_Global;

// ============================================================================
// SECTION 4: SETTINGS FUNCTIONS
// ============================================================================

["A3PL_GPS_RefreshCache",
{
    private _saved = profileNamespace getVariable "A3PL_GPS_Saved";
    if (isNil "_saved") then { profileNamespace setVariable ["A3PL_GPS_Saved", []]; }
    else { if !(_saved isEqualType []) then { profileNamespace setVariable ["A3PL_GPS_Saved", []]; }; };

    if (isNil {profileNamespace getVariable "A3PL_GPS_Settings"}) then {
        profileNamespace setVariable ["A3PL_GPS_Settings", []];
    };

    private _settings = profileNamespace getVariable "A3PL_GPS_Settings";

    // Migrate old keybinds (TAB was quicknav_open, now it's F6)
    private _curOpen = [_settings, "quicknav_open_key"] call bis_fnc_getFromPairs;
    if (!isNil "_curOpen" && {_curOpen isEqualTo [15]}) then {
        [_settings, "quicknav_open_key", [64]] call bis_fnc_setToPairs;
    };

    {
        _x params ["_name", "_defaultValue"];
        private _value = [_settings, _name] call bis_fnc_getFromPairs;
        if (isNil "_value") then { [_settings, _name, _defaultValue] call bis_fnc_setToPairs; }
        else { if !(_value isEqualType _defaultValue) then { [_settings, _name, _defaultValue] call bis_fnc_setToPairs; }; };
    } forEach [
        ["marker_color", [1, 0.5, 0, 1]],
        ["lang", "fr"],
        ["metric", "mi"],
        ["menu_open_key", [63]],
        ["quicknav_open_key", [64]],
        ["quicknav_switch_key", [54]],
        ["quicknav_execute_key", [28]]
    ];
    saveProfileNamespace;
}] call compile_Global;

["A3PL_GPS_GetSetting",
{
    params [["_setting", "", [""]], ["_default", nil]];
    private _settings = profileNamespace getVariable ["A3PL_GPS_Settings", []];
    private _value = [_settings, _setting] call bis_fnc_getFromPairs;
    if (isNil "_value") then { if (!isNil "_default") then { _default } else { nil } } else { _value }
}] call compile_Global;

["A3PL_GPS_SetSetting",
{
    params ["_setting", "_value"];
    private _settings = profileNamespace getVariable ["A3PL_GPS_Settings", []];
    [_settings, _setting, _value] call bis_fnc_setToPairs;
    saveProfileNamespace;
}] call compile_Global;

// ============================================================================
// SECTION 5: UTILITY FUNCTIONS
// ============================================================================

["A3PL_GPS_PointLineDist",
{
    params ["_point", "_start", "_end"];
    private _n = _end vectorDiff _start;
    private _pa = _start vectorDiff _point;
    private _c = _n vectorMultiply ((_pa vectorDotProduct _n) / (_n vectorDotProduct _n));
    private _d = _pa vectorDiff _c;
    sqrt (_d vectorDotProduct _d)
}] call compile_Global;

["A3PL_GPS_DistanceStr",
{
    params [["_distance", 0, ["", 0]], ["_decimals", 1, [0]], ["_metricSystem", "km"]];
    private _metricUnit = "m";
    if (_metricSystem == "mi") then {
        if (_distance * 0.6213712 > 1000) then { _distance = (_distance * 0.6213712) / 1000; _metricUnit = "mi"; };
    } else {
        if (_distance > 1000) then { _distance = _distance / 1000; _metricUnit = "km"; };
    };
    format ["%1 %2", _distance toFixed _decimals, _metricUnit]
}] call compile_Global;

["A3PL_GPS_MidPoint",
{
    params ["_pos1", "_pos2"];
    [((_pos1 select 0) + (_pos2 select 0)) / 2, ((_pos1 select 1) + (_pos2 select 1)) / 2, (((_pos1 select 2) + (_pos2 select 2)) / 2)]
}] call compile_Global;

["A3PL_GPS_NearestRoadInArray",
{
    params [["_pos", [0,0,0]], ["_rad", 50], ["_list", []]];
    private _roads = (_pos nearRoads _rad) select {_x in _list};
    private _max = -log 0;
    private _nearest = objNull;
    { private _dist = _x distanceSqr _pos; if (_dist < _max) then {_max = _dist; _nearest = _x}; } count _roads;
    _nearest
}] call compile_Global;

["A3PL_GPS_NearestLocation",
{
    params [["_position", objNull, [[], objNull]], ["_radius", 1000, [0]], ["_types", ["NameCity", "NameVillage", "NameCityCapital", "NameLocal"], [[]]]];
    private _locations = nearestLocations [_position, _types, _radius];
    if (_locations isEqualTo []) exitWith {locationNull};
    [_locations, _position] call bis_fnc_nearestPosition
}] call compile_Global;

["A3PL_GPS_GetRoadDir",
{
    params [["_road", objNull, [objNull]], ["_otherRoad", objNull, [objNull]]];
    if !(isNull _otherRoad) exitWith { _road getDir _otherRoad };
    private _connectedRoads = roadsConnectedTo _road;
    if (count _connectedRoads == 0) exitWith {0};
    if (count _connectedRoads >= 1) then {
        private _roadID = parseNumber str _road;
        private _friendlyRoads = _connectedRoads select {(parseNumber str _x) in [_roadID + 1, _roadID - 1]};
        if (_friendlyRoads isEqualTo []) then { _friendlyRoads = _connectedRoads; };
        _road getDir (_friendlyRoads select 0);
    };
}] call compile_Global;

["A3PL_GPS_IsHighway",
{
    params [["_road", objNull, [objNull]]];
    private _direction = [_road] call A3PL_GPS_GetRoadDir;
    private _roadPos = getPosATL _road;
    private _vectorDir = [sin (_direction + 90), cos (_direction + 90), 0];
    private _pos1 = _roadPos vectorAdd (_vectorDir vectorMultiply 6);
    _vectorDir = _vectorDir vectorMultiply -1;
    private _pos2 = _roadPos vectorAdd (_vectorDir vectorMultiply 6);
    isOnRoad _pos1 && isOnRoad _pos2
}] call compile_Global;

// ============================================================================
// SECTION 6: ROAD NETWORK MAPPING
// ============================================================================

["A3PL_GPS_GetAllRoads",
{
    // Try loading pre-computed data from mission folder first
    private _dataPath = format ["A3PL_GPS\data\%1\AllRoads.sqf", worldName];
    private _fileContent = loadFile _dataPath;
    if (_fileContent != "") then {
        private _parsed = parseSimpleArray _fileContent;
        if (!isNil "_parsed" && {!(_parsed isEqualTo [])}) then {
            diag_log format ["A3PL: GPS - Loaded %1 pre-computed roads for %2", count _parsed, worldName];
            _parsed apply {
                private _road = (_x nearRoads 0.1) param [0, objNull];
                if (isNull _road) then { [_x, 20] call bis_fnc_nearestRoad } else { _road }
            }
        } else { [] };
    } else {
        // Fallback: compute roads dynamically by scanning the map in grid sectors
        diag_log format ["A3PL: GPS - No pre-computed data for %1, scanning map dynamically...", worldName];
        private _allRoadsFound = [];
        private _gridSize = 500;
        private _halfGrid = _gridSize / 2;
        for "_x" from _halfGrid to worldSize step _gridSize do {
            for "_y" from _halfGrid to worldSize step _gridSize do {
                _allRoadsFound append ([_x, _y, 0] nearRoads (_gridSize * 0.75));
            };
        };
        _allRoadsFound = _allRoadsFound arrayIntersect _allRoadsFound;
        diag_log format ["A3PL: GPS - Found %1 roads dynamically for %2", count _allRoadsFound, worldName];
        _allRoadsFound
    }
}] call compile_Global;

["A3PL_GPS_RoadsConnectedTo",
{
    params [["_road", objNull, [objNull]]];
    private _result = [A3PL_GPS_RoadsWithConnected, str _road] call A3PL_GPS_HashTable_Find;
    if (isNil "_result") then {
        // Road not in indexed set - use native command and register it
        _result = roadsConnectedTo _road;
        private _near = getPosATL _road nearRoads 15;
        { if (count (roadsConnectedTo _x) < 3) then { _result pushBackUnique _x; }; } forEach ((_near - _result) - [_road]);
        [A3PL_GPS_RoadsWithConnected, str _road, _result] call A3PL_GPS_HashTable_Set;
    };
    _result
}] call compile_Global;

["A3PL_GPS_MapNodeValues",
{
    params ["_crossRoad", "_linkedTo", ["_exceptions", [], [[]]]];
    private _linkedCrossRoads = [];
    private _crossRoad_isHighWay = [_crossRoad] call A3PL_GPS_IsHighway;
    {
        private _currRoad = _x; private _segmentValue = 0; private _previous = _crossRoad;
        for "_i" from 0 to 1 step 0 do {
            private _connected = [_currRoad] call A3PL_GPS_RoadsConnectedTo;
            if (isNil "_connected") exitWith {};
            private _countConnected = count _connected;
            _segmentValue = _segmentValue + (_previous distance2D _currRoad);
            if (_countConnected > 2 || _currRoad in _exceptions || _countConnected isEqualTo 1) exitWith {
                private _currRoad_isHighWay = [_currRoad] call A3PL_GPS_IsHighway;
                if (_currRoad_isHighWay && _crossRoad_isHighWay) then { _segmentValue = (_segmentValue / 3); };
                _linkedCrossRoads pushBack [_currRoad, _segmentValue];
            };
            private _old = _currRoad;
            _currRoad = (_connected select { !(_x isEqualTo _previous) }) param [0, _old];
            _previous = _old;
            if (_currRoad isEqualTo _old) exitWith {};
        };
        false
    } count _linkedTo;
    [A3PL_GPS_AllCrossRoadsWithWeight, str _crossRoad, _linkedCrossRoads] call A3PL_GPS_HashTable_Set;
    _linkedCrossRoads
}] call compile_Global;

["A3PL_GPS_MapRoutes",
{
    diag_log "A3PL: GPS - MapRoutes initialization started";
    private _start = diag_tickTime;
    A3PL_GPS_AllRoads = [] call A3PL_GPS_GetAllRoads;
    diag_log format ["A3PL: GPS - Got %1 roads in %2s", count A3PL_GPS_AllRoads, round (diag_tickTime - _start)];
    private _gps_allRoadsWithInter = [];
    A3PL_GPS_AllCrossRoadsWithWeight = [] call A3PL_GPS_HashTable_Create;
    A3PL_GPS_RoadsWithConnected = [] call A3PL_GPS_HashTable_Create;
    _gps_allRoadsWithInter = A3PL_GPS_AllRoads apply {
        private _road = _x; private _near = getPosATL _road nearRoads 15; private _connected = roadsConnectedTo _road;
        if (count _connected > 1) then {
            { if (count (roadsConnectedTo _x) < 3) then {
                private _rID = str _x; _connected pushBack _x;
                if ([A3PL_GPS_RoadsWithConnected, _rID] call A3PL_GPS_HashTable_Exists) then { ([A3PL_GPS_RoadsWithConnected, _rID] call A3PL_GPS_HashTable_Find) pushBack _road; }
                else { [A3PL_GPS_RoadsWithConnected, _rID, [_road]] call A3PL_GPS_HashTable_Set; };
            }; } foreach ((_near - _connected) - [_road]);
        };
        private _currentConnected = [A3PL_GPS_RoadsWithConnected, str _road] call A3PL_GPS_HashTable_Find;
        if (isNil "_currentConnected") then { [A3PL_GPS_RoadsWithConnected, str _road, _connected] call A3PL_GPS_HashTable_Set; }
        else { _currentConnected append _connected; };
        [_road, _connected]
    };
    { private _connected = [A3PL_GPS_RoadsWithConnected, str (_x select 0)] call A3PL_GPS_HashTable_Find;
      if (!isNil "_connected" && {count _connected > 2}) then { _x call A3PL_GPS_MapNodeValues; }; false } count _gps_allRoadsWithInter;
    diag_log format ["A3PL: GPS - MapRoutes done in %1s", round (diag_tickTime - _start)];
    [] call A3PL_GPS_MapBridges;
    [] call A3PL_GPS_ConnectComponents;
    A3PL_GPS_CoreInitDone = true;
}] call compile_Global;

["A3PL_GPS_MapBridges",
{
    private _mapCenter = [worldSize / 2, worldSize / 2, 0];
    private _bridgeModels = ["a3fl_bridge.p3d", "a3fl_bridge2.p3d"];
    private _allBridges = nearestTerrainObjects [_mapCenter, [], worldSize, false];
    _allBridges = _allBridges select { toLower ((getModelInfo _x) select 0) in _bridgeModels };
    if (_allBridges isEqualTo []) exitWith { diag_log "A3PL: GPS - No bridges found on map"; };
    diag_log format ["A3PL: GPS - Found %1 bridge objects, grouping into clusters...", count _allBridges];

    private _usedArr = _allBridges apply { false };
    private _clusters = [];
    {
        if (_usedArr select _forEachIndex) then { continue };
        _usedArr set [_forEachIndex, true];
        private _cluster = [_x];
        private _queue = [_x];
        while {count _queue > 0} do {
            private _current = _queue deleteAt 0;
            for "_j" from 0 to (count _allBridges - 1) do {
                if !(_usedArr select _j) then {
                    if ((_allBridges select _j) distance2D _current < 80) then {
                        _cluster pushBack (_allBridges select _j);
                        _queue pushBack (_allBridges select _j);
                        _usedArr set [_j, true];
                    };
                };
            };
        };
        _clusters pushBack _cluster;
    } forEach _allBridges;

    diag_log format ["A3PL: GPS - %1 bridge clusters found", count _clusters];

    private _fn_findGraphRoad = {
        params ["_pos", "_radius"];
        private _roads = _pos nearRoads _radius;
        private _result = objNull;
        { if ((str _x) in A3PL_GPS_AllCrossRoadsWithWeight) exitWith { _result = _x; }; } forEach _roads;
        if (isNull _result) then {
            { if (count (roadsConnectedTo _x) > 1) exitWith { _result = _x; }; } forEach _roads;
        };
        if (isNull _result && count _roads > 0) then { _result = _roads select 0; };
        _result
    };

    private _bridgeConnections = 0;
    {
        private _cluster = _x;
        private _clusterIdx = _forEachIndex;

        private _dir = getDir (_cluster select 0);
        private _sinDir = sin _dir;
        private _cosDir = cos _dir;
        private _refPos = getPosATL (_cluster select 0);

        private _maxProj = -1e9; private _minProj = 1e9;
        private _maxBridge = _cluster select 0;
        private _minBridge = _cluster select 0;
        {
            private _pos = getPosATL _x;
            private _proj = ((_pos select 0) - (_refPos select 0)) * _sinDir + ((_pos select 1) - (_refPos select 1)) * _cosDir;
            if (_proj > _maxProj) then { _maxProj = _proj; _maxBridge = _x; };
            if (_proj < _minProj) then { _minProj = _proj; _minBridge = _x; };
        } forEach _cluster;

        private _bb1 = boundingBoxReal _maxBridge;
        private _bb2 = boundingBoxReal _minBridge;
        private _searchEnd1 = _maxBridge modelToWorld [0, ((_bb1 select 1) select 1) + 50, 0];
        private _searchEnd2 = _minBridge modelToWorld [0, ((_bb2 select 0) select 1) - 50, 0];

        private _road1 = [_searchEnd1, 200] call bis_fnc_nearestRoad;
        private _road2 = [_searchEnd2, 200] call bis_fnc_nearestRoad;
        if (_road1 isEqualTo _road2) then {
            _road1 = [_searchEnd1, 200] call _fn_findGraphRoad;
            _road2 = [_searchEnd2, 200] call _fn_findGraphRoad;
        };

        if (!isNull _road1 && {!isNull _road2} && {!(_road1 isEqualTo _road2)}) then {
            [_road1] call A3PL_GPS_InsertFakeNode;
            [_road2] call A3PL_GPS_InsertFakeNode;

            private _weight = _road1 distance _road2;

            private _neighbors1 = [A3PL_GPS_AllCrossRoadsWithWeight, str _road1] call A3PL_GPS_HashTable_Find;
            if (isNil "_neighbors1") then { _neighbors1 = []; };
            _neighbors1 pushBack [_road2, _weight];
            [A3PL_GPS_AllCrossRoadsWithWeight, str _road1, _neighbors1] call A3PL_GPS_HashTable_Set;

            private _neighbors2 = [A3PL_GPS_AllCrossRoadsWithWeight, str _road2] call A3PL_GPS_HashTable_Find;
            if (isNil "_neighbors2") then { _neighbors2 = []; };
            _neighbors2 pushBack [_road1, _weight];
            [A3PL_GPS_AllCrossRoadsWithWeight, str _road2, _neighbors2] call A3PL_GPS_HashTable_Set;

            _bridgeConnections = _bridgeConnections + 1;
            diag_log format ["A3PL: GPS - Bridge cluster #%1 (%2 segments) connected: %3 <-> %4 (weight: %5m)", _clusterIdx, count _cluster, _road1, _road2, round _weight];
        } else {
            diag_log format ["A3PL: GPS - Bridge cluster #%1 (%2 segments) at %3 FAILED (road1: %4, road2: %5, same: %6)", _clusterIdx, count _cluster, _refPos, !isNull _road1, !isNull _road2, _road1 isEqualTo _road2];
        };
    } forEach _clusters;

    diag_log format ["A3PL: GPS - Bridge mapping done: %1/%2 clusters connected", _bridgeConnections, count _clusters];
}] call compile_Global;

["A3PL_GPS_ConnectComponents",
{
    // BFS through the road graph to find disconnected components
    private _graphRoads = A3PL_GPS_AllRoads select { (str _x) in A3PL_GPS_AllCrossRoadsWithWeight };
    if (count _graphRoads < 2) exitWith {};

    private _visited = createHashMap;
    private _components = [];
    {
        private _key = str _x;
        if !(_key in _visited) then {
            private _component = [_x];
            private _queue = [_x];
            _visited set [_key, true];
            while {count _queue > 0} do {
                private _current = _queue deleteAt 0;
                private _neighbors = A3PL_GPS_AllCrossRoadsWithWeight getOrDefault [str _current, []];
                { _x params ["_nRoad"];
                    private _nKey = str _nRoad;
                    if !(_nKey in _visited) then {
                        _visited set [_nKey, true];
                        _component pushBack _nRoad;
                        _queue pushBack _nRoad;
                    };
                } forEach _neighbors;
            };
            _components pushBack _component;
        };
    } forEach _graphRoads;

    if (count _components <= 1) exitWith { diag_log "A3PL: GPS - Road network is fully connected (1 component)"; };

    // Sort by size descending (largest = main road network)
    _components = [_components, [], { count _x }, "DESCEND"] call BIS_fnc_sortBy;
    diag_log format ["A3PL: GPS - Found %1 disconnected components (main: %2 nodes)", count _components, count (_components select 0)];

    // Build spatial lookup for main component
    private _mainSet = createHashMap;
    { _mainSet set [str _x, true]; } forEach (_components select 0);

    // Connect each smaller component to the main network
    private _connectCount = 0;
    {
        private _otherComp = _x;
        private _compIdx = _forEachIndex + 1;
        private _minDist = 1e9;
        private _bestMain = objNull;
        private _bestOther = objNull;

        // For each road in smaller component, use nearRoads to find nearby main-component roads
        {
            private _otherRoad = _x;
            private _nearby = (getPosATL _otherRoad) nearRoads 1000;
            {
                if ((str _x) in _mainSet) then {
                    private _d = _x distance2D _otherRoad;
                    if (_d < _minDist) then { _minDist = _d; _bestMain = _x; _bestOther = _otherRoad; };
                };
            } forEach _nearby;
        } forEach _otherComp;

        // Fallback: brute force if nearRoads didn't find anything within 1000m
        if (isNull _bestMain) then {
            {
                private _otherRoad = _x;
                { private _d = _x distance2D _otherRoad;
                    if (_d < _minDist) then { _minDist = _d; _bestMain = _x; _bestOther = _otherRoad; };
                } forEach (_components select 0);
            } forEach _otherComp;
        };

        if (!isNull _bestMain && {!isNull _bestOther}) then {
            private _weight = _bestMain distance _bestOther;

            private _n1 = A3PL_GPS_AllCrossRoadsWithWeight getOrDefault [str _bestMain, []];
            _n1 pushBack [_bestOther, _weight];
            A3PL_GPS_AllCrossRoadsWithWeight set [str _bestMain, _n1];

            private _n2 = A3PL_GPS_AllCrossRoadsWithWeight getOrDefault [str _bestOther, []];
            _n2 pushBack [_bestMain, _weight];
            A3PL_GPS_AllCrossRoadsWithWeight set [str _bestOther, _n2];

            // Merge into main set for subsequent components
            { _mainSet set [str _x, true]; } forEach _otherComp;

            _connectCount = _connectCount + 1;
            diag_log format ["A3PL: GPS - Component #%1 (%2 nodes) connected to main (gap: %3m)", _compIdx, count _otherComp, round _minDist];
        } else {
            diag_log format ["A3PL: GPS - Component #%1 (%2 nodes) FAILED to connect", _compIdx, count _otherComp];
        };
    } forEach (_components select [1, count _components]);

    diag_log format ["A3PL: GPS - Component connection done: %1 gaps bridged", _connectCount];
}] call compile_Global;

// ============================================================================
// SECTION 7: A* PATHFINDING
// ============================================================================

["A3PL_GPS_AStar",
{
    params ["_startRoute", "_goalRoute", "_namespace", ["_weightFunction", {_goalRoute distance _next}]];
    private _frontier = []; private _counter = 0; private _current = [];
    private _came_from = [] call A3PL_GPS_HashTable_Create;
    private _cost_so_far = [] call A3PL_GPS_HashTable_Create;
    [_came_from, str _startRoute, objNull] call A3PL_GPS_HashTable_Set;
    [_frontier, 0, _counter, _startRoute] call A3PL_GPS_PQ_Insert;
    [_cost_so_far, str _startRoute, 0] call A3PL_GPS_HashTable_Set;
    for "_i" from 0 to 1 step 0 do {
        if (_frontier isEqualTo []) exitWith {};
        _current = [_frontier] call A3PL_GPS_PQ_Get;
        if (_current isEqualTo _goalRoute) exitWith {};
        { _x params ["_next", "_cost"];
          private _new_cost = ([_cost_so_far, str _current] call A3PL_GPS_HashTable_Find) + _cost;
          if (!([_cost_so_far, str _next] call A3PL_GPS_HashTable_Exists)) then {
              _counter = _counter + 1;
              [_cost_so_far, str _next, _new_cost] call A3PL_GPS_HashTable_Set;
              private _priority = _new_cost + (call _weightFunction);
              [_frontier, _priority, _counter, _next] call A3PL_GPS_PQ_Insert;
              [_came_from, str _next, _current] call A3PL_GPS_HashTable_Set;
          } else {
              if (_new_cost < ([_cost_so_far, str _next] call A3PL_GPS_HashTable_Find)) then {
                  _counter = _counter + 1; [_cost_so_far, str _next, _new_cost] call A3PL_GPS_HashTable_Set;
                  private _priority = _new_cost + (call _weightFunction);
                  [_frontier, _priority, _counter, _next] call A3PL_GPS_PQ_Insert;
                  [_came_from, str _next, _current] call A3PL_GPS_HashTable_Set;
              };
          };
        } foreach ([_namespace, str _current] call A3PL_GPS_HashTable_Find);
    };
    _came_from
}] call compile_Global;

["A3PL_GPS_RDP",
{
    params ["_pointList", ["_epsilon", 30, [0]]];
    if (count _pointList < 3) exitWith {_pointList};
    private _dmax = 0; private _index = 0; private _end = count _pointList - 1;
    for "_i" from 1 to _end step 1 do {
        private _d = [_pointList select _i, _pointList select 0, _pointList select _end] call A3PL_GPS_PointLineDist;
        if (_d > _dmax) then { _index = _i; _dmax = _d; };
    };
    if (_dmax > _epsilon) then {
        private _recResults1 = [_pointList select [0, _index + 1], _epsilon] call A3PL_GPS_RDP;
        private _recResults2 = [_pointList select [_index, _end], _epsilon] call A3PL_GPS_RDP;
        (_recResults1 select [0, count _recResults1 - 1]) + _recResults2
    } else { [_pointList select 0, _pointList select _end] }
}] call compile_Global;

// ============================================================================
// SECTION 8: PATH GENERATION
// ============================================================================

["A3PL_GPS_InsertFakeNode",
{
    params [["_road", objNull, [objNull]]];
    if (count ([_road] call A3PL_GPS_RoadsConnectedTo) > 2) exitWith {};
    [A3PL_GPS_FakeNodes, str _road, _road] call A3PL_GPS_HashTable_Set;
    private _nodes = values A3PL_GPS_FakeNodes;
    private _res = [_road, [_road] call A3PL_GPS_RoadsConnectedTo, _nodes] call A3PL_GPS_MapNodeValues;
    { [_x select 0, [_x select 0] call A3PL_GPS_RoadsConnectedTo, _nodes] call A3PL_GPS_MapNodeValues; } foreach _res;
}] call compile_Global;

["A3PL_GPS_GenerateNodePath",
{
    params [["_startRoute", objNull, [objNull]], ["_goalRoute", objNull, [objNull]]];
    private _came_from = [_startRoute, _goalRoute, A3PL_GPS_AllCrossRoadsWithWeight] call A3PL_GPS_AStar;
    if (_came_from isEqualTo []) then { throw "PATH_NOT_FOUND" };
    private _current = _goalRoute; private _path = [];
    while {_current != _startRoute} do {
        _path pushBack _current;
        _current = [_came_from, str _current] call A3PL_GPS_HashTable_Find;
        if (isNil "_current") then { throw "PATH_NOT_FOUND" };
    };
    _path pushBack _startRoute; reverse _path;
    _path
}] call compile_Global;

["A3PL_GPS_GeneratePathHelpers",
{
    params [["_path", [], [[]]]];
    private _fullPath = [];
    { scopeName "path"; private _road = _x; private _next = _path select (_forEachIndex + 1); private _linked = [_road] call A3PL_GPS_RoadsConnectedTo;
      if (isNil "_next") exitWith { _fullPath pushBack _road; };
      { private _passedBy = [_road]; private _currRoad = _x; private _previous = _road;
        for "_i" from 0 to 1 step 0 do {
            private _connected = [_currRoad] call A3PL_GPS_RoadsConnectedTo;
            _passedBy pushBack _currRoad;
            if (_currRoad isEqualTo _next) then { _passedBy deleteAt (count _passedBy - 1); _fullPath append _passedBy; breakTo "path"; };
            if (count _connected > 2) exitWith {};
            private _old = _currRoad;
            { if !(_x isEqualTo _previous) exitWith { _previous = _currRoad; _currRoad = _x; }; } forEach _connected;
            if (_currRoad isEqualTo _old) exitWith {};
        };
      } forEach _linked;
    } forEach _path;
    _fullPath
}] call compile_Global;

// ============================================================================
// SECTION 9: GPS CONTROL
// ============================================================================

["A3PL_GPS_DeletePathHelpers", { A3PL_GPS_DrawPoints = []; }] call compile_Global;

["A3PL_GPS_Kill",
{
    terminate A3PL_GPS_CurrentThread;
    [] call A3PL_GPS_DeletePathHelpers;
    [] call A3PL_GPS_HashTable_DeleteNameSpaces;
    A3PL_GPS_CurrentGoal = nil;
    [] call A3PL_GPS_CloseHUD;
}] call compile_Global;

// ============================================================================
// SECTION 10: HUD FUNCTIONS
// ============================================================================

["A3PL_GPS_SetInfo",
{
    disableSerialization;
    params ["_status", ["_img", "", [""]], ["_goalText", "", [""]]];
    private _hudDisplay = uiNamespace getVariable ["A3PL_GPS_HUD", displayNull];
    if (isNull _hudDisplay) exitWith {};
    private _text = _hudDisplay displayCtrl 1000;
    private _goalDistance = _hudDisplay displayCtrl 1002;
    if (_status != "") then { _text ctrlSetStructuredText parseText _status; };
    if (_goalText != "") then { _goalDistance ctrlSetStructuredText parseText _goalText; };
}] call compile_Global;

["A3PL_GPS_OpenHUD",
{
    disableSerialization;
    if !(isNull (uiNamespace getVariable ["A3PL_GPS_HUD", displayNull])) exitWith {};
    "A3PL_GPS_HUD_Layer" cutRsc ["A3PL_GPS_HUD", "PLAIN", 1, false];
    private _hudDisplay = uiNamespace getVariable ["A3PL_GPS_HUD", displayNull];
    if (isNull _hudDisplay) exitWith { diag_log "A3PL: GPS - Failed to open HUD"; };
    private _map = _hudDisplay displayCtrl 2201;
    if (!isNull _map) then {
        _map mapCenterOnCamera true;
        _map ctrlAddEventHandler ["Draw", { (_this select 0) drawIcon [getText (configFile/"CfgVehicles"/typeOf vehicle player/"Icon"), [1,1,1,1], visiblePosition vehicle player, 24, 24, 0]; }];
        _map ctrlAddEventHandler ["Draw", {[_this select 0, true] call A3PL_GPS_DrawPath}];
    };
}] call compile_Global;

["A3PL_GPS_CloseHUD",
{
    disableSerialization;
    private _hudDisplay = uiNamespace getVariable ["A3PL_GPS_HUD", displayNull];
    if (!isNull _hudDisplay) then { { private _pos = ctrlPosition _x; _x ctrlSetPosition [_pos select 0, _pos select 1, 0, _pos select 3]; _x ctrlCommit 0.5; } foreach allControls _hudDisplay; };
    "A3PL_GPS_HUD_Layer" cutText ["", "PLAIN"];
    uiNamespace setVariable ["A3PL_GPS_HUD", displayNull];
}] call compile_Global;

["A3PL_GPS_DrawPath",
{
    params ["_ctrl", ["_isHUD", false, [false]]];
    private _color = ["marker_color"] call A3PL_GPS_GetSetting;
    if (isNil "_color") then { _color = [1, 0.5, 0, 1]; };
    private _colorTexture = _color call bis_fnc_colorRGBATOTexture;
    private _dir = getDir player;
    private _toDraw = missionNamespace getVariable ["A3PL_GPS_DrawPoints", []];
    if (_toDraw isEqualTo []) exitWith {};
    private _lastRoad = _toDraw select (count _toDraw - 1);
    private _scale = ctrlMapScale _ctrl;
    private _lookingAT = [_ctrl ctrlMapScreenToWorld [0.5, 0.5], getPosATL player] select _isHUD;
    _toDraw = _toDraw select { _x distance _lookingAT <= (_scale * 10000) };
    { private _previous = _toDraw param [_forEachIndex - 1, _toDraw select _forEachIndex]; private _next = _toDraw select (_forEachIndex + 1);
      if (_x isEqualTo _lastRoad) exitWith { _ctrl drawIcon ["\A3\ui_f\data\Map\Markers\Military\flag_CA.paa", _color, _x, 32, 32, 0, "", 1, 0.03, "TahomaB", "right"]; };
      if (isNil "_next") exitWith {};
      private _x_connected = [_x] call A3PL_GPS_RoadsConnectedTo;
      if (!isNil "_x_connected") then {
          if (_previous in _x_connected && _next in _x_connected) then {
              _ctrl drawRectangle [[getPosATL _previous, getPosATL _x] call A3PL_GPS_MidPoint, 4.5, (_previous distance _x) / 1.75, [_previous getDir _x, (_previous getDir _x) - _dir] select _isHUD, _color, _colorTexture];
              _ctrl drawRectangle [[getPosATL _x, getPosATL _next] call A3PL_GPS_MidPoint, 4.5, (_next distance _x) / 1.75, [_x getDir _next, (_x getDir _next) - _dir] select _isHUD, _color, _colorTexture];
          };
      };
    } foreach _toDraw;
}] call compile_Global;

// ============================================================================
// SECTION 11: TRACKING
// ============================================================================

["A3PL_GPS_Tracking",
{
    private _path = +(_this select 0); private _fullPath = +(_this select 1); private _goal = _this select 2;
    _path = [_path apply {getPosATL _x}] call A3PL_GPS_RDP;
    _path = _path apply {[_x, 1] call bis_fnc_nearestRoad};
    _path deleteAt 0;
    private _fn_findNextNode = { params ["_path", "_fullPath"];
        private _nearestRoadInFullPath = [getPosATL player, 30, _fullPath] call A3PL_GPS_NearestRoadInArray;
        if (isNull _nearestRoadInFullPath) exitWith {objNull};
        private _nextPathRange = _fullPath select [_fullPath find _nearestRoadInFullPath, count _fullPath];
        A3PL_GPS_DrawPoints = _nextPathRange;
        (_nextPathRange select {_x in _path}) param [0, objNull]
    };
    private _return = true;
    try {
        while {vehicle player distance _goal > 15} do { scopeName "tracking_loop";
            private _metric = ["metric"] call A3PL_GPS_GetSetting; if (isNil "_metric") then { _metric = "mi"; };
            private _next_node = [_path, _fullPath] call _fn_findNextNode;
            if !(isNull _next_node) then {
                private _next_node_index_fullPath = _fullPath find _next_node;
                if (_next_node_index_fullPath >= (count _fullPath - 2)) exitWith {
                    [format ["STR_A3PL_GPS_ArriveIn" call A3PL_Localize, [vehicle player distance _goal, 1, _metric] call A3PL_GPS_DistanceStr], "", [vehicle player distance _goal, 2] call A3PL_GPS_DistanceStr] call A3PL_GPS_SetInfo;
                };
                private _next_node_previous = if (_next_node_index_fullPath < 2) then {_fullPath select 0} else {_fullPath select (_next_node_index_fullPath - 2)};
                private _next_node_next = _fullPath select (_next_node_index_fullPath + 2);
                private _vector_1 = getPosASL _next_node vectorFromTo getPosASL _next_node_next;
                private _vector_2 = getPosASL _next_node_previous vectorFromTo getPosASL _next_node;
                private _diff = (_vector_1 # 0)*(_vector_2 # 1)-(_vector_1 # 1)*(_vector_2 # 0);
                private _distanceToNode = vehicle player distance _next_node;
                if (_diff > 0.3) then {
                    [format ["STR_A3PL_GPS_TurnRight" call A3PL_Localize, [_distanceToNode, 2, _metric] call A3PL_GPS_DistanceStr], "", [vehicle player distance _goal, 1, _metric] call A3PL_GPS_DistanceStr] call A3PL_GPS_SetInfo;
                } else { if (_diff < -0.3) then {
                    [format ["STR_A3PL_GPS_TurnLeft" call A3PL_Localize, [_distanceToNode, 2, _metric] call A3PL_GPS_DistanceStr], "", [vehicle player distance _goal, 1, _metric] call A3PL_GPS_DistanceStr] call A3PL_GPS_SetInfo;
                } else { _path deleteAt (_path find _next_node); breakTo "tracking_loop"; }; };
                uiSleep 0.5;
            } else {
                if (isOnRoad vehicle player) then { throw "RECALCULATE_PATH"; };
                ["STR_A3PL_GPS_Lost" call A3PL_Localize, "", [vehicle player distance _goal, 1, _metric] call A3PL_GPS_DistanceStr] call A3PL_GPS_SetInfo;
            };
        };
    } catch { _return = false; };
    _return
}] call compile_Global;

// ============================================================================
// SECTION 12: MAIN NAVIGATION
// ============================================================================

["A3PL_GPS_Navigate",
{
    params [["_position", [], [[], objNull, locationNull, grpNull, ""]]];
    _position = _position call bis_fnc_position;
    private _startRoute = [getPosATL vehicle player, 1000] call bis_fnc_nearestRoad;
    private _endRoute = [_position, 1000] call bis_fnc_nearestRoad;
    if (!A3PL_GPS_CoreInitDone) exitWith {};
    if (isNull _endRoute) exitWith { ["STR_A3PL_GPS_NoRoadNearDest" call A3PL_Localize, Color_Red] call A3PL_Notification; };
    if (isNull _startRoute) exitWith { ["STR_A3PL_GPS_NoRoadNearPos" call A3PL_Localize, Color_Red] call A3PL_Notification; };
    [] call A3PL_GPS_Kill;
    A3PL_GPS_CurrentThread = _thisScript;
    ["STR_A3PL_GPS_Initializing" call A3PL_Localize, "", ""] call A3PL_GPS_SetInfo;
    [] call A3PL_GPS_DeletePathHelpers;
    [_startRoute] call A3PL_GPS_InsertFakeNode;
    [_endRoute] call A3PL_GPS_InsertFakeNode;
    try {
        A3PL_GPS_CurrentGoal = getPosATL _endRoute;
        waitUntil {
            _startRoute = [getPosATL vehicle player, 1000] call bis_fnc_nearestRoad;
            [_startRoute] call A3PL_GPS_InsertFakeNode;
            [] call A3PL_GPS_DeletePathHelpers;
            private _path = [_startRoute, _endRoute] call A3PL_GPS_GenerateNodePath;
            private _fullPath = [_path] call A3PL_GPS_GeneratePathHelpers;
            [] call A3PL_GPS_OpenHUD;
            [_path, _fullPath, _endRoute] call A3PL_GPS_Tracking
        };
        ["STR_A3PL_GPS_Arrived" call A3PL_Localize, Color_Green] call A3PL_Notification;
        [] call A3PL_GPS_CloseHUD; [] call A3PL_GPS_DeletePathHelpers;
        A3PL_GPS_CurrentGoal = nil;
    } catch {
        switch _exception do {
            case "PATH_NOT_FOUND": {
                [] call A3PL_GPS_DeletePathHelpers;
                diag_log format ["A3PL: GPS - PATH_NOT_FOUND, falling back to straight-line navigation to %1", _position];
                ["STR_A3PL_GPS_StraightLine" call A3PL_Localize, Color_Yellow] call A3PL_Notification;
                // Fallback: straight-line navigation with distance tracking
                A3PL_GPS_DrawPoints = [_endRoute];
                [] call A3PL_GPS_OpenHUD;
                private _metric = ["metric"] call A3PL_GPS_GetSetting; if (isNil "_metric") then { _metric = "mi"; };
                while {vehicle player distance _position > 15} do {
                    private _dist = vehicle player distance _position;
                    [format ["STR_A3PL_GPS_DirectNav" call A3PL_Localize, [_dist, 1, _metric] call A3PL_GPS_DistanceStr], "", [_dist, 2] call A3PL_GPS_DistanceStr] call A3PL_GPS_SetInfo;
                    uiSleep 0.5;
                };
                ["STR_A3PL_GPS_Arrived" call A3PL_Localize, Color_Green] call A3PL_Notification;
                [] call A3PL_GPS_CloseHUD; [] call A3PL_GPS_DeletePathHelpers;
                A3PL_GPS_CurrentGoal = nil;
            };
            default { diag_log format ["A3PL: GPS - Exception: %1", _exception]; };
        };
    };
    [] call A3PL_GPS_HashTable_DeleteNameSpaces;
}] call compile_Global;

// ============================================================================
// SECTION 13: QUICK NAVIGATION
// ============================================================================

["A3PL_GPS_AddQuickNavOption",
{
    params [["_text", "", [""]], ["_code", {}, [{}, ""]]];
    if (_text isEqualTo "") exitWith { false };
    if (_code isEqualType "") then { _code = compile _code; };
    (A3PL_GPS_QuickNavOptions pushBackUnique [_text, _code]) != -1
}] call compile_Global;

["A3PL_GPS_QuickNavCreate",
{
    disableSerialization;
    private _hudDisplay = uiNamespace getVariable ["A3PL_GPS_QuickNav", displayNull];
    if !(isNull _hudDisplay) exitWith { "A3PL_GPS_QuickNav_Layer" cutText ["", "PLAIN"]; true };
    "A3PL_GPS_QuickNav_Layer" cutRsc ["A3PL_GPS_QuickNav", "PLAIN", 1, false];
    _hudDisplay = uiNamespace getVariable ["A3PL_GPS_QuickNav", displayNull];
    if (isNull _hudDisplay) exitWith { false };
    // Restore all controls stored during LoadQuickNav (includes dynamic buttons)
    private _animCtrls = _hudDisplay getVariable ["animControls", []];
    { _x ctrlSetPosition (_x getVariable "originalPos"); _x ctrlCommit 0.2; } forEach _animCtrls;
    true
}] call compile_Global;

["A3PL_GPS_LoadQuickNav",
{
    params ["_disp"]; disableSerialization;
    uiNamespace setVariable ["A3PL_GPS_QuickNav", _disp];
    private _templateBtn = _disp displayCtrl 1600;
    private _options = A3PL_GPS_QuickNavOptions;

    if (!A3PL_GPS_CoreInitDone) exitWith {
        _templateBtn ctrlSetText ("STR_A3PL_GPS_Loading" call A3PL_Localize); _templateBtn ctrlEnable false;
        private _ac = allControls _disp; _disp setVariable ["animControls", _ac];
        { private _pos = ctrlPosition _x; _x setVariable ["originalPos", _pos]; _x ctrlSetPosition [_pos select 0, _pos select 1, 0, _pos select 3]; _x ctrlCommit 0; } forEach _ac;
    };

    if (_options isEqualTo []) exitWith {
        _templateBtn ctrlSetText ("STR_A3PL_GPS_Empty" call A3PL_Localize); _templateBtn ctrlEnable false;
        private _ac = allControls _disp; _disp setVariable ["animControls", _ac];
        { private _pos = ctrlPosition _x; _x setVariable ["originalPos", _pos]; _x ctrlSetPosition [_pos select 0, _pos select 1, 0, _pos select 3]; _x ctrlCommit 0; } forEach _ac;
    };

    // Get template button position as base
    private _tPos = ctrlPosition _templateBtn;
    _tPos params ["_bx", "_by", "_bw", "_bh"];
    private _gap = 0.004 * safezoneH;
    private _buttons = [];

    // Create one button per option
    {
        _x params ["_text", "_code"];
        private _btn = if (_forEachIndex == 0) then { _templateBtn } else {
            _disp ctrlCreate ["RscButton", 1600 + _forEachIndex]
        };
        _btn ctrlSetPosition [_bx, _by + (_bh + _gap) * _forEachIndex, _bw, _bh];
        _btn ctrlCommit 0;
        _btn ctrlSetText _text;
        _btn ctrlEnable true;
        _btn ctrlSetBackgroundColor [0, 0, 0, 0.5];
        _btn setVariable ["optIndex", _forEachIndex];
        _btn ctrlAddEventHandler ["ButtonClick", {
            params ["_ctrl"];
            private _d = ctrlParent _ctrl;
            private _idx = _ctrl getVariable "optIndex";
            private _opts = _d getVariable ["options", []];
            if (_idx >= 0 && {_idx < count _opts}) then {
                "A3PL_GPS_QuickNav_Layer" cutText ["", "PLAIN"];
                [] spawn ((_opts select _idx) select 1);
            };
        }];
        _buttons pushBack _btn;
    } forEach _options;

    // Highlight first option
    if (count _buttons > 0) then { (_buttons select 0) ctrlSetBackgroundColor [0.3, 0.5, 0.8, 0.8]; };

    _disp setVariable ["options", _options];
    _disp setVariable ["selOpt", 0];
    _disp setVariable ["buttons", _buttons];

    // Build list of ALL controls for slide-in animation (static + dynamic)
    private _animCtrls = allControls _disp;
    { if !(_x in _animCtrls) then { _animCtrls pushBack _x; }; } forEach _buttons;
    _disp setVariable ["animControls", _animCtrls];

    // Slide-in animation: collapse all to width 0
    { private _pos = ctrlPosition _x; _x setVariable ["originalPos", _pos]; _x ctrlSetPosition [_pos select 0, _pos select 1, 0, _pos select 3]; _x ctrlCommit 0; } forEach _animCtrls;
}] call compile_Global;

["A3PL_GPS_QuickNavNextOption",
{
    disableSerialization;
    private _hudDisplay = uiNamespace getVariable ["A3PL_GPS_QuickNav", displayNull];
    if !(isNull _hudDisplay) exitWith {
        private _buttons = _hudDisplay getVariable ["buttons", []];
        private _options = _hudDisplay getVariable ["options", []];
        if (_options isEqualTo [] || {_buttons isEqualTo []}) exitWith { false };

        // Remove highlight from current
        private _oldIdx = _hudDisplay getVariable ["selOpt", 0];
        if (_oldIdx >= 0 && {_oldIdx < count _buttons}) then {
            (_buttons select _oldIdx) ctrlSetBackgroundColor [0, 0, 0, 0.5];
        };

        // Advance
        private _newIdx = _oldIdx + 1;
        if (_newIdx >= count _options) then { _newIdx = 0; };
        _hudDisplay setVariable ["selOpt", _newIdx];

        // Highlight new
        if (_newIdx >= 0 && {_newIdx < count _buttons}) then {
            (_buttons select _newIdx) ctrlSetBackgroundColor [0.3, 0.5, 0.8, 0.8];
        };
        true
    };
    false
}] call compile_Global;

["A3PL_GPS_QuickNavExecuteCurrentOption",
{
    disableSerialization;
    private _hudDisplay = uiNamespace getVariable ["A3PL_GPS_QuickNav", displayNull];
    if !(isNull _hudDisplay) exitWith {
        private _options = _hudDisplay getVariable ["options", []];
        private _idx = _hudDisplay getVariable ["selOpt", -1];
        if (_options isEqualTo [] || _idx == -1) exitWith { false };
        "A3PL_GPS_QuickNav_Layer" cutText ["", "PLAIN"];
        [] spawn ((_options select _idx) select 1);
        true
    };
    false
}] call compile_Global;

["A3PL_GPS_HandleQuickNavActions",
{
    // GPS DISABLED - exit silently
    if (!A3PL_GPS_CoreInitDone) exitWith {false};
    disableSerialization;
    params ["", "_key", "_shift", "_ctrl", "_alt"];
    private _handled = false;
    if (dialog) exitWith {_handled};
    private _menuKeys = ["menu_open_key"] call A3PL_GPS_GetSetting; if (isNil "_menuKeys") then { _menuKeys = [63]; };
    private _openKeys = ["quicknav_open_key"] call A3PL_GPS_GetSetting; if (isNil "_openKeys") then { _openKeys = [64]; };
    private _switchKeys = ["quicknav_switch_key"] call A3PL_GPS_GetSetting; if (isNil "_switchKeys") then { _switchKeys = [54]; };
    private _execKeys = ["quicknav_execute_key"] call A3PL_GPS_GetSetting; if (isNil "_execKeys") then { _execKeys = [28]; };
    _handled = switch (true) do {
        case (_key in _menuKeys): { call A3PL_GPS_OpenMenu; true };
        case (_key in _openKeys): { call A3PL_GPS_QuickNavCreate };
        case (_key in _switchKeys): { call A3PL_GPS_QuickNavNextOption };
        case (_key in _execKeys): { call A3PL_GPS_QuickNavExecuteCurrentOption };
        default { false };
    };
    _handled
}] call compile_Global;

// ============================================================================
// SECTION 14: CONVENIENCE FUNCTIONS
// ============================================================================

["A3PL_GPS_NavigateToPosition", { params [["_pos", [0,0,0], [[], objNull]]]; [_pos] spawn A3PL_GPS_Navigate; }] call compile_Global;

["A3PL_GPS_NavigateToNearestFuelStation",
{
    private _fuelStations = nearestObjects [player, ["Land_A3PL_Gas_Station"], 15000];
    if (_fuelStations isEqualTo []) exitWith { ["STR_A3PL_GPS_NoFuelStation" call A3PL_Localize, Color_Red] call A3PL_Notification; };
    [getPosATL (_fuelStations select 0)] spawn A3PL_GPS_Navigate;
}] call compile_Global;

["A3PL_GPS_NavigateToNearestTown",
{
    private _towns = nearestLocations [getPosATL player, ["NameCity", "NameVillage", "NameCityCapital", "NameLocal"], 10000];
    if (_towns isEqualTo []) exitWith { ["STR_A3PL_GPS_NoTownNearby" call A3PL_Localize, Color_Red] call A3PL_Notification; };
    [locationPosition (_towns select 0)] spawn A3PL_GPS_Navigate;
}] call compile_Global;

["A3PL_GPS_Stop", { [] call A3PL_GPS_Kill; ["STR_A3PL_GPS_Stopped" call A3PL_Localize, Color_Yellow] call A3PL_Notification; }] call compile_Global;

["A3PL_GPS_EnableMapClick",
{
    if (isNil "A3PL_GPS_MapClickEH") then {
        A3PL_GPS_MapClickEH = ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["MouseButtonClick", {
            params ["_ctrl", "_button", "_xPos", "_yPos"];
            if (_button == 1) then { [_ctrl ctrlMapScreenToWorld [_xPos, _yPos]] spawn A3PL_GPS_Navigate; };
        }];
        ["STR_A3PL_GPS_MapClickEnabled" call A3PL_Localize, Color_Green] call A3PL_Notification;
    };
}] call compile_Global;

["A3PL_GPS_DisableMapClick",
{
    if (!isNil "A3PL_GPS_MapClickEH") then {
        ((findDisplay 12) displayCtrl 51) ctrlRemoveEventHandler ["MouseButtonClick", A3PL_GPS_MapClickEH];
        A3PL_GPS_MapClickEH = nil;
        ["STR_A3PL_GPS_MapClickDisabled" call A3PL_Localize, Color_Yellow] call A3PL_Notification;
    };
}] call compile_Global;

// ============================================================================
// SECTION 15: GPS MENU SYSTEM
// ============================================================================

["A3PL_GPS_OpenMenu",
{
    // GPS DISABLED - exit silently
    if (!A3PL_GPS_CoreInitDone) exitWith {};
    disableSerialization;
    if (!isNull findDisplay 369852) exitWith {};
    createDialog "A3PL_GPS_Menu";
    private _display = findDisplay 369852;
    if (isNull _display) exitWith { ["STR_A3PL_GPS_ErrorDialogNotFound" call A3PL_Localize, Color_Red] call A3PL_Notification; };

    // Load saved routes
    private _savedList = _display displayCtrl 1500;
    private _saved = profileNamespace getVariable ["A3PL_GPS_Saved", []];
    {
        _x params ["_name", "_pos"];
        private _idx = _savedList lbAdd _name;
        _savedList lbSetData [_idx, str _pos];
    } forEach _saved;

    // === Button handlers ===

    // Navigate (open map)
    (_display displayCtrl 2400) ctrlAddEventHandler ["ButtonClick", {
        (findDisplay 369852) closeDisplay 0;
        [] call A3PL_GPS_OpenNavMap;
    }];

    // Map click toggle
    (_display displayCtrl 2401) ctrlAddEventHandler ["ButtonClick", {
        if (isNil "A3PL_GPS_MapClickEH") then {
            [] call A3PL_GPS_EnableMapClick;
        } else {
            [] call A3PL_GPS_DisableMapClick;
        };
        (findDisplay 369852) closeDisplay 0;
    }];

    // Nearest fuel
    (_display displayCtrl 2402) ctrlAddEventHandler ["ButtonClick", {
        (findDisplay 369852) closeDisplay 0;
        [] call A3PL_GPS_NavigateToNearestFuelStation;
    }];

    // Nearest town
    (_display displayCtrl 2403) ctrlAddEventHandler ["ButtonClick", {
        (findDisplay 369852) closeDisplay 0;
        [] call A3PL_GPS_NavigateToNearestTown;
    }];

    // Open HUD
    (_display displayCtrl 2404) ctrlAddEventHandler ["ButtonClick", {
        [] call A3PL_GPS_OpenHUD;
    }];

    // Stop navigation
    (_display displayCtrl 2405) ctrlAddEventHandler ["ButtonClick", {
        [] call A3PL_GPS_Stop;
    }];

    // Load saved route
    (_display displayCtrl 2407) ctrlAddEventHandler ["ButtonClick", {
        disableSerialization;
        private _list = (findDisplay 369852) displayCtrl 1500;
        private _sel = lbCurSel _list;
        if (_sel < 0) exitWith {};
        private _posStr = _list lbData _sel;
        if (_posStr == "") exitWith {};
        (findDisplay 369852) closeDisplay 0;
        [parseSimpleArray _posStr] spawn A3PL_GPS_Navigate;
    }];

    // Delete saved route
    (_display displayCtrl 2408) ctrlAddEventHandler ["ButtonClick", {
        disableSerialization;
        private _list = (findDisplay 369852) displayCtrl 1500;
        private _sel = lbCurSel _list;
        if (_sel < 0) exitWith {};
        _list lbDelete _sel;
        private _saved = profileNamespace getVariable ["A3PL_GPS_Saved", []];
        _saved deleteAt _sel;
        profileNamespace setVariable ["A3PL_GPS_Saved", _saved];
    }];

    // Save current route
    (_display displayCtrl 2410) ctrlAddEventHandler ["ButtonClick", {
        disableSerialization;
        [] call A3PL_GPS_SaveCurrentRoute;
        // Refresh saved list
        private _list = (findDisplay 369852) displayCtrl 1500;
        lbClear _list;
        private _saved = profileNamespace getVariable ["A3PL_GPS_Saved", []];
        {
            _x params ["_name", "_pos"];
            private _idx = _list lbAdd _name;
            _list lbSetData [_idx, str _pos];
        } forEach _saved;
    }];

    // Close
    (_display displayCtrl 2409) ctrlAddEventHandler ["ButtonClick", {
        (findDisplay 369852) closeDisplay 0;
    }];
}] call compile_Global;

["A3PL_GPS_OpenNavMap",
{
    disableSerialization;
    if (!isNull findDisplay 369856) exitWith {};
    createDialog "A3PL_GPS_NavMap";
    private _display = findDisplay 369856;
    if (isNull _display) exitWith { ["STR_A3PL_GPS_ErrorNavDialogNotFound" call A3PL_Localize, Color_Red] call A3PL_Notification; };

    _display call A3PL_Dialog_Localize;

    private _map = _display displayCtrl 2201;

    // Draw player icon on map
    _map ctrlAddEventHandler ["Draw", {
        params ["_map"];
        private _veh = vehicle player;
        _map drawIcon [
            getText (configFile >> "CfgVehicles" >> typeOf _veh >> "Icon"),
            [0.3, 0.5, 1, 1],
            visiblePosition _veh,
            24, 24,
            direction _veh,
            name player
        ];
        // Draw current route if any
        if (!isNil "A3PL_GPS_DrawPoints" && {count A3PL_GPS_DrawPoints > 1}) then {
            private _color = [0.1, 0.8, 0.1, 0.8];
            for "_i" from 0 to (count A3PL_GPS_DrawPoints - 2) do {
                _map drawLine [A3PL_GPS_DrawPoints select _i, A3PL_GPS_DrawPoints select (_i + 1), _color];
            };
        };
    }];

    // Click on map = navigate
    _map ctrlAddEventHandler ["MouseButtonClick", {
        params ["_control", "_btn", "_xCoord", "_yCoord"];
        if (_btn == 0) then {
            private _pos = _control ctrlMapScreenToWorld [_xCoord, _yCoord];
            (findDisplay 369856) closeDisplay 0;
            [_pos] spawn A3PL_GPS_Navigate;
        };
    }];

    // Close button
    (_display displayCtrl 1600) ctrlAddEventHandler ["ButtonClick", {
        (findDisplay 369856) closeDisplay 0;
    }];
}] call compile_Global;

["A3PL_GPS_SaveCurrentRoute",
{
    if (isNil "A3PL_GPS_CurrentGoal") exitWith { ["STR_A3PL_GPS_NoDestination" call A3PL_Localize, Color_Red] call A3PL_Notification; };
    private _saved = profileNamespace getVariable ["A3PL_GPS_Saved", []];
    private _nearLoc = nearestLocations [A3PL_GPS_CurrentGoal, ["NameCity", "NameVillage", "NameCityCapital", "NameLocal"], 2000];
    private _name = if (count _nearLoc > 0) then { text (_nearLoc select 0) } else { format ["Position %1", mapGridPosition A3PL_GPS_CurrentGoal] };
    _saved pushBack [_name, A3PL_GPS_CurrentGoal];
    profileNamespace setVariable ["A3PL_GPS_Saved", _saved];
    [format ["STR_A3PL_GPS_RouteSaved" call A3PL_Localize, _name], Color_Green] call A3PL_Notification;
}] call compile_Global;

