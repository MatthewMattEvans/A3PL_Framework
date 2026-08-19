/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/

["Server_Traits_AcquireTrait", {
	/*
		Called when a player attempts to acquire a trait
		Parameters:
			0: OBJECT - the player
			1: STRING - category name
			2: NUMBER - trait index in the category
			3: NUMBER - selection index (for multiple choices)
			4: STRING - trait name
	*/
	params [
		["_player", objNull, [objNull]],
		["_category", "", [""]],
		["_traitIndex", -1, [0]],
		["_selectedIndex", 0, [0]],
		["_traitName", "", [""]]
	];

	if (isNull _player || {_category isEqualTo ""} || {_traitIndex isEqualTo -1} || {_traitName isEqualTo ""}) exitWith {};

	private _categoryData = Config_TraitsCategories get _category;
	if (isNil "_categoryData") exitWith {};

	private _traitData = Config_Traits get _traitName;
	if (isNil "_traitData") exitWith {};

	private _categoryTraits = _categoryData#1;
	private _traitsProgression = _player getVariable ["Player_TraitsProgression", createHashMap];
	private _progression = _traitsProgression getOrDefault [_category, []];
	private _traits = _player getVariable ["Player_Traits", []];

	// Security checks
	// 1. Does the player have enough points?
	// Load playtime from DB
	private _charID = _player getVariable ["character_id", ""];
	private _playtimeQuery = format ["SELECT playtime FROM players WHERE charid='%1'", _charID];
	private _playtimeResult = [_playtimeQuery, 2] call Server_Database_Async;
	private _playerPlaytime = if (!isNil "_playtimeResult" && {count _playtimeResult > 0} && {_playtimeResult#0 > 0}) then {_playtimeResult#0} else {0};

	private _freePoints = floor(_playerPlaytime / 30); // PlayTime is in minutes in the DB

	{
		private _categoryName = _x;
		private _catData = Config_TraitsCategories get _categoryName;
		if (isNil "_catData") then {continue};

		private _catTraits = _catData#1;
		private _catProgression = _traitsProgression getOrDefault [_categoryName, []];

		{
			private _cost = 0;
			private _selIndex = _catProgression param [_forEachIndex, -1, [0]];
			if (_selIndex isNotEqualTo -1) then {
				private _tName = (_x#_selIndex);
				private _tData = Config_Traits get _tName;
				if !(isNil "_tData") then {
					_cost = _tData#3;
				};
			};
			_freePoints = _freePoints - _cost;
		} forEach _catTraits;
	} forEach (keys Config_TraitsCategories);

	private _traitCost = _traitData#3;
	if (_freePoints < _traitCost) exitWith {
		["STR_A3PL_Traits_NotEnoughPoints" call A3PL_Localize, Color_Red] remoteExecCall ["A3PL_Notification", _player];
	};

	// 2. The trait is not already acquired
	private _alreadyAcquired = _progression param [_traitIndex, -1, [0]];
	if (_alreadyAcquired isNotEqualTo -1) exitWith {
		["STR_A3PL_Traits_AlreadyAcquired" call A3PL_Localize, Color_Red] remoteExecCall ["A3PL_Notification", _player];
	};

	// 3. The prerequisite is met (except for the first trait)
	if (_traitIndex > 0) then {
		private _prevTraitIndex = _progression param [_traitIndex - 1, -1, [0]];
		if (_prevTraitIndex isEqualTo -1) exitWith {
			["STR_A3PL_Traits_RequiresPrevious" call A3PL_Localize, Color_Red] remoteExecCall ["A3PL_Notification", _player];
		};
	};

	// Acquire the trait
	_progression set [_traitIndex, _selectedIndex];
	_traitsProgression set [_category, _progression];
	_traits pushBackUnique _traitName;

	_player setVariable ["Player_TraitsProgression", _traitsProgression, true];
	_player setVariable ["Player_Traits", _traits, true];

	// Save to database
	[_player] call Server_Traits_Save;

	// Notify the player
	[_traitName] remoteExecCall ["A3PL_Traits_OnAcquired", _player];
}] call Compile_Server;

["Server_Traits_LoadPlayerTraits", {
	/*
		Loads a player's traits from the database
		Parameters:
			0: OBJECT - the player
			1: ARRAY - traits progression data from DB
			2: ARRAY - list of acquired traits from DB
	*/
	params [
		["_player", objNull, [objNull]],
		["_traitsProgressionData", createHashMap, [createHashMap]],
		["_traitsData", [], [[]]]
	];

	if (isNull _player) exitWith {};

	_player setVariable ["Player_TraitsProgression", _traitsProgressionData, true];
	_player setVariable ["Player_Traits", _traitsData, true];

	// Apply trait effects
	[] remoteExecCall ["A3PL_Traits_UpdateAttributes", _player];
}] call Compile_Server;

["Server_Traits_ResetPlayerTraits", {
	/*
		Resets all traits for a player (admin only)
		Parameters:
			0: OBJECT - the player to reset
	*/
	params [["_player", objNull, [objNull]]];

	if (isNull _player) exitWith {};

	_player setVariable ["Player_TraitsProgression", createHashMap, true];
	_player setVariable ["Player_Traits", [], true];

	[_player] call Server_Traits_Save;

	["STR_A3PL_Traits_Reset" call A3PL_Localize, Color_Yellow] remoteExecCall ["A3PL_Notification", _player];
	[] remoteExecCall ["A3PL_Traits_UpdateAttributes", _player];
}] call Compile_Server;

["Server_Traits_Load", {
	/*
		Loads a player's traits from the database
		Parameters:
			0: OBJECT - the player
	*/
	params [["_player", objNull, [objNull]]];
	if (isNull _player) exitWith {};

	private _charID = _player getVariable ["character_id", ""];
	if (_charID isEqualTo "") exitWith {};

	// Load traits from DB
	private _query = format ["SELECT category, trait_index, selected_index, trait_name FROM players_traits WHERE charid='%1'", _charID];
	private _result = [_query, 2, true] call Server_Database_Async;

	private _traitsProgression = createHashMap;
	private _traits = [];

	// Rebuild data from DB
	{
		_x params ["_category", "_traitIndex", "_selectedIndex", "_traitName"];

		// Add to progression
		private _categoryProgression = _traitsProgression getOrDefault [_category, []];

		// Fill missing indexes with -1 to avoid nil values
		for "_i" from (count _categoryProgression) to (_traitIndex - 1) do {
			_categoryProgression set [_i, -1];
		};

		_categoryProgression set [_traitIndex, _selectedIndex];
		_traitsProgression set [_category, _categoryProgression];

		// Add trait to list
		_traits pushBackUnique _traitName;
	} forEach _result;

	// Set variables on player
	_player setVariable ["Player_TraitsProgression", _traitsProgression, true];
	_player setVariable ["Player_Traits", _traits, true];

	// Apply trait effects
	[] remoteExecCall ["A3PL_Traits_UpdateAttributes", _player];
}] call Compile_Server;

["Server_Traits_Save", {
	/*
		Saves a player's traits to the database
		Parameters:
			0: OBJECT - the player
	*/
	params [["_player", objNull, [objNull]]];
	if (isNull _player) exitWith {};

	private _charID = _player getVariable ["character_id", ""];
	if (_charID isEqualTo "") exitWith {};

	private _traitsProgression = _player getVariable ["Player_TraitsProgression", createHashMap];

	// Delete old traits
	private _deleteQuery = format ["DELETE FROM players_traits WHERE charid='%1'", _charID];
	[_deleteQuery, 1] call Server_Database_Async;

	// Insert new traits
	{
		private _category = _x;
		private _categoryData = Config_TraitsCategories get _category;
		if (isNil "_categoryData") then {continue};

		private _categoryTraits = _categoryData#1;
		private _progression = _traitsProgression getOrDefault [_category, []];

		{
			private _selectedIndex = _progression param [_forEachIndex, -1, [0]];
			if (_selectedIndex isNotEqualTo -1) then {
				private _traitName = (_x#_selectedIndex);
				private _insertQuery = format [
					"INSERT INTO players_traits (charid, category, trait_index, selected_index, trait_name) VALUES ('%1', '%2', %3, %4, '%5')",
					_charID,
					_category,
					_forEachIndex,
					_selectedIndex,
					_traitName
				];
				[_insertQuery, 1] call Server_Database_Async;
			};
		} forEach _categoryTraits;
	} forEach (keys Config_TraitsCategories);
}] call Compile_Server;
