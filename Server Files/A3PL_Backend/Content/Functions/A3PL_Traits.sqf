/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/

// IDD and IDC for Traits menu
#define TRAITS_DISPLAY_IDD 87000
#define TRAITS_TREE_IDC 87001
#define TRAITS_DESCRIPTION_GROUP_IDC 87002
#define TRAITS_DESCRIPTION_IDC 87003
#define TRAITS_ACQUIRE_IDC 87004
#define CHARACTER_PLAYTIME_IDC 87006
#define CHARACTER_POINTS_IDC 87007
#define CHARACTER_ACQUIRE_IDC 87008

["A3PL_Traits_GetFreePoints", {
	/*
		Calculates the number of available trait points
		Returns: number of available points (NUMBER)
	*/
	if (isNil "Config_TraitsCategories") exitWith {0};

	private _points = floor(Player_PlayTime / 30); // 2 points per hour (PlayTime is in minutes)

	private _traitsProgression = player getVariable ["Player_TraitsProgression", createHashMap];

	{
		private _categoryName = _x;
		private _categoryData = Config_TraitsCategories get _categoryName;
		if (isNil "_categoryData") then {continue};

		private _categoryTraits = _categoryData#1;
		private _progression = _traitsProgression getOrDefault [_categoryName, []];

		{
			private _cost = 0;
			private _selectedIndex = _progression param [_forEachIndex, -1, [0]];
			if (_selectedIndex isNotEqualTo -1) then {
				private _traitName = (_x#_selectedIndex);
				private _traitData = Config_Traits get _traitName;
				if !(isNil "_traitData") then {
					_cost = _traitData#3;
				};
			};
			_points = _points - _cost;
		} forEach _categoryTraits;
	} forEach (keys Config_TraitsCategories);

	_points;
}] call Compile_Global;

["A3PL_Traits_Has", {
	/*
		Checks if the player has a specific trait
		Parameters:
			0: STRING - trait name to check
		Returns: BOOL - true if the player has the trait
	*/
	params [["_trait", "", [""]]];

	if (_trait isEqualTo "") exitWith {false};

	private _traits = player getVariable ["Player_Traits", []];
	_trait in _traits;
}] call Compile_Global;

["A3PL_Traits_OnAcquire", {
	/*
		Called when the player clicks the Acquire button
		Parameters:
			0: NUMBER - trait index in the choice list (for multiple choices)
	*/
	params [["_selectedIndex", 0, [0]]];

	private _display = findDisplay TRAITS_DISPLAY_IDD;
	if (isNull _display) exitWith {};

	private _treeCtrl = _display displayCtrl TRAITS_TREE_IDC;
	private _sel = tvCurSel _treeCtrl;
	private _data = _treeCtrl tvData _sel;
	if (_data isEqualTo "") exitWith {};

	// Find the category and trait index
	private _category = "";
	private _traitIndex = -1;

	{
		private _categoryName = _x;
		private _categoryData = Config_TraitsCategories get _categoryName;
		if (isNil "_categoryData") then {continue};

		private _categoryTraits = _categoryData#1;
		private _foundIndex = _categoryTraits findIf {_data in _x};

		if (_foundIndex isNotEqualTo -1) exitWith {
			_category = _categoryName;
			_traitIndex = _foundIndex;
		};
	} forEach (keys Config_TraitsCategories);

	if (_category isEqualTo "") exitWith {};

	private _traitData = Config_Traits get _data;
	if (isNil "_traitData") exitWith {};

	// Confirmation
	if ([
		format [
			"STR_A3PL_Traits_AcquireConfirm" call A3PL_Localize,
			_traitData#0 call A3PL_Localize
		],
		"STR_A3PL_Traits_Confirmation" call A3PL_Localize,
		"STR_A3PL_Traits_Validate" call A3PL_Localize,
		"STR_A3PL_Traits_Cancel" call A3PL_Localize
	] call BIS_fnc_guiMessage) then {
		// Send to server to validate and save
		[player, _category, _traitIndex, _selectedIndex, _data] remoteExecCall ["Server_Traits_AcquireTrait", 2];
	};
}] call Compile_Global;

["A3PL_Traits_OnTreeSelChanged", {
	/*
		Called when the tree selection changes
		Parameters:
			0: CONTROL - the tree control
			1: ARRAY - selection path
	*/
	params ["_control", "_selectionPath"];

	private _display = findDisplay TRAITS_DISPLAY_IDD;
	if (isNull _display) exitWith {};

	private _buttonCtrl = _display displayCtrl TRAITS_ACQUIRE_IDC;
	private _groupCtrl = _display displayCtrl TRAITS_DESCRIPTION_GROUP_IDC;
	private _acquireCtrl = _display displayCtrl CHARACTER_ACQUIRE_IDC;

	private _data = _control tvData _selectionPath;
	if (_data isEqualTo "") exitWith {
		_buttonCtrl ctrlShow false;
		_groupCtrl ctrlShow false;
		_acquireCtrl ctrlShow false;
	};

	_groupCtrl ctrlShow true;
	_buttonCtrl ctrlShow true;
	_buttonCtrl ctrlEnable false;
	_acquireCtrl ctrlShow true;
	_acquireCtrl ctrlEnable false;

	private _traitData = Config_Traits get _data;
	if (isNil "_traitData") exitWith {};

	// Find the category and prerequisites
	private _category = "";
	private _traitIndex = -1;

	{
		private _categoryName = _x;
		private _categoryData = Config_TraitsCategories get _categoryName;
		if (isNil "_categoryData") then {continue};

		private _categoryTraits = _categoryData#1;
		private _foundIndex = _categoryTraits findIf {_data in _x};

		if (_foundIndex isNotEqualTo -1) exitWith {
			_category = _categoryName;
			_traitIndex = _foundIndex;
		};
	} forEach (keys Config_TraitsCategories);

	if (_category isEqualTo "") exitWith {};

	private _categoryData = Config_TraitsCategories get _category;
	private _categoryTraits = _categoryData#1;
	private _traitsProgression = player getVariable ["Player_TraitsProgression", createHashMap];
	private _progression = _traitsProgression getOrDefault [_category, []];
	private _subIndex = (_categoryTraits#_traitIndex) find _data;
	private _firstTraitIndex = _progression param [0, -1, [0]];
	private _selectedTraitIndex = _progression param [_traitIndex, -1, [0]];
	private _prevTraitIndex = _progression param [_traitIndex - 1, -1, [0]];
	private _freePoints = [] call A3PL_Traits_GetFreePoints;
	private _hasEnoughPoints = _freePoints >= (_traitData#3);

	// Enable the button if conditions are met
	private _canAcquire = _hasEnoughPoints && {
		((_traitIndex isEqualTo 0) && {_firstTraitIndex isEqualTo -1})
		|| {
			(_traitIndex > 0)
			&& {_selectedTraitIndex isEqualTo -1}
			&& {_prevTraitIndex isNotEqualTo -1}
		}
	};
	_buttonCtrl ctrlEnable _canAcquire;
	_acquireCtrl ctrlEnable _canAcquire;

	// Build the prerequisites list
	private _needs = "";
	private _exclusive = "";

	{
		if (_data in _x) exitWith {
			if (count(_x) > 1) then {
				{
					if ((_forEachIndex isNotEqualTo 0) && {_forEachIndex isNotEqualTo (count(_x) - 2)}) then {
						_exclusive = _exclusive + format [" %1 ", toLower ("STR_A3PL_Traits_And" call A3PL_Localize)];
					};
					private _otherTraitData = Config_Traits get _x;
					if !(isNil "_otherTraitData") then {
						_exclusive = _exclusive + (_otherTraitData#0 call A3PL_Localize);
					};
				} forEach (_x - [_data]);
			};
		};

		if (_needs isNotEqualTo "") then {
			_needs = _needs + ", ";
		};

		private _hasReached = _progression param [_forEachIndex, -1, [0]];

		{
			if ((_forEachIndex isNotEqualTo 0) && {_forEachIndex isNotEqualTo (count(_x) - 1)}) then {
				_needs = _needs + format [" %1 ", toLower ("STR_A3PL_Traits_Or" call A3PL_Localize)];
			};

			private _color = "#CB2323";
			if (_forEachIndex isEqualTo _hasReached) then {
				_color = "#0A8B0A";
			} else {
				if (_hasReached isNotEqualTo -1) then {
					_color = "#FFFFFF";
				};
			};

			private _reqTraitData = Config_Traits get _x;
			if !(isNil "_reqTraitData") then {
				_needs = _needs + format ["<t color='%2'>%1</t>", _reqTraitData#0 call A3PL_Localize, _color];
			};
		} forEach _x;
	} forEach _categoryTraits;

	if (_needs isNotEqualTo "") then {
		_needs = (format ["<img image='\A3PL_Common\Traits\use_ca.paa' /> %1:<br />", "STR_A3PL_Traits_Required" call A3PL_Localize]) + _needs + "<br />";
	};
	if (_exclusive isNotEqualTo "") then {
		if (_needs isNotEqualTo "") then {
			_needs = _needs + "<br />";
		};
		_exclusive = (format ["<img image='\A3PL_Common\Traits\danger_ca.paa' /> %1:<br />", "STR_A3PL_Traits_Locked" call A3PL_Localize]) + _exclusive;
	};

	private _textCtrl = _display displayCtrl TRAITS_DESCRIPTION_IDC;
	private _costColor = "#0A8B0A";
	if !_hasEnoughPoints then {
		_costColor = "#CB2323";
	};

	_textCtrl ctrlSetStructuredText parseText format [
		"<br />"
		+ "<t size='1.4' align='center'>"
		+ "<img size='3' image='%1' /><br />"
		+ "%2<br />"
		+ "<t size='1' color='#D56F1F'>%4</t><br /><br />"
		+ "</t>"
		+ "<t size='1.1'>"
		+ "%3<br /><br />"
		+ "<t color='%8'>%10: %7 %9</t><br /><br />"
		+ "%5%6"
		+ "</t>",
		_traitData#2,
		_traitData#0 call A3PL_Localize,
		_traitData#1 call A3PL_Localize,
		_categoryData#0 call A3PL_Localize,
		_needs,
		_exclusive,
		_traitData#3,
		_costColor,
		toLower ("STR_A3PL_Traits_Points" call A3PL_Localize),
		toLower ("STR_A3PL_Traits_Cost" call A3PL_Localize)
	];

	(ctrlPosition _textCtrl) params ["_posX","_posY","_width"];

	_textCtrl ctrlSetPosition [_posX, _posY, _width, (ctrlTextHeight _textCtrl) + 0.05];
	_textCtrl ctrlCommit 0;

	_buttonCtrl buttonSetAction format ["[%1] spawn A3PL_Traits_OnAcquire;", _subIndex];
	_acquireCtrl buttonSetAction format ["[%1] spawn A3PL_Traits_OnAcquire;", _subIndex];
}] call Compile_Global;

["A3PL_Traits_Open", {
	if !(Activate_Traits) exitWith {
		["STR_A3PL_Traits_Disabled" call A3PL_Localize, Color_Red] call A3PL_Notification;
	};

	if (isNil "Config_TraitsCategories") exitWith {
		["STR_A3PL_Traits_NotLoaded" call A3PL_Localize, Color_Red] call A3PL_Notification;
	};

	if (
		dialog
		|| {!(alive player)}
		|| {visibleMap}
	) exitWith {};

	createDialog "RscDisplayTraits";

	private _display = findDisplay TRAITS_DISPLAY_IDD;
	if (isNull _display) exitWith {};

	_display call A3PL_Dialog_Localize;

	[] call A3PL_Traits_UpdateUserTree;

	private _groupCtrl = _display displayCtrl TRAITS_DESCRIPTION_GROUP_IDC;
	private _buttonCtrl = _display displayCtrl TRAITS_ACQUIRE_IDC;

	_buttonCtrl ctrlShow false;
	_groupCtrl ctrlShow false;

	private _playtimeCtrl = _display displayCtrl CHARACTER_PLAYTIME_IDC;
	private _pointsCtrl = _display displayCtrl CHARACTER_POINTS_IDC;
	private _acquireCtrl = _display displayCtrl CHARACTER_ACQUIRE_IDC;

	_acquireCtrl ctrlShow false;

	[_display, _playtimeCtrl, _pointsCtrl, _acquireCtrl] spawn {
		params ["_display", "_playtimeCtrl", "_pointsCtrl", "_acquireCtrl"];

		while {!(isNull _display)} do {
			private _points = [] call A3PL_Traits_GetFreePoints;
			private _playtime = if (isNil "Player_PlayTime") then {0} else {Player_PlayTime};
			private _totalPoints = floor(_playtime / 30);

			private _timeString = "";
			if (_playtime > 0) then {
				private _months = floor(_playtime / (60 * 24 * 30));
				private _days = floor((_playtime % (60 * 24 * 30)) / (60 * 24));
				private _hours = floor((_playtime % (60 * 24)) / 60);
				private _minutes = _playtime % 60;

				if (_months > 0) then {
					_timeString = format["%1 %2 ", _months, "STR_A3PL_Traits_Months" call A3PL_Localize];
				};
				if (_days > 0) then {
					_timeString = _timeString + format["%1%2 ", _days, "STR_A3PL_Traits_Days" call A3PL_Localize];
				};
				if (_hours > 0) then {
					_timeString = _timeString + format["%1%2 ", _hours, "STR_A3PL_Traits_Hours" call A3PL_Localize];
				};
				if (_minutes > 0) then {
					_timeString = _timeString + format["%1%2", _minutes, "STR_A3PL_Traits_Minutes" call A3PL_Localize];
				};
			} else {
				_timeString = format["0%1", "STR_A3PL_Traits_Minutes" call A3PL_Localize];
			};

			_playtimeCtrl ctrlSetStructuredText parseText format [
				"<t align='center'>%1</t>",
				_timeString
			];

			_pointsCtrl ctrlSetStructuredText parseText format [
				"<t align='center'><t color='#0A8B0A'>%1</t></t>",
				_points,
				_totalPoints - _points,
				toLower ("STR_A3PL_Traits_Assigned" call A3PL_Localize)
			];

			uiSleep 1;
		};
	};
}] call Compile_Global;

["A3PL_Traits_UpdateAttributes", {
	/*
		Updates the player's attributes based on their traits
	*/
	private _traits = player getVariable ["Player_Traits", []];

	// Reset base penalties
	private _aimPenalties = 6;
	private _recoilPenalties = 2.5;

	if ("gunner" in _traits) then {
		_aimPenalties = _aimPenalties - 3;
		_recoilPenalties = _recoilPenalties - 2;
	};

	// Trait steady_hands - reduces weapon sway by 40%
	if ("steady_hands" in _traits) then {
		_aimPenalties = _aimPenalties - 2.4;
	};

	player setCustomAimCoef (1 + _aimPenalties);

	private _recoilPenalties = 2.5;

	if ("gunner" in _traits) then {
		_recoilPenalties = _recoilPenalties - 2;
	};

	player setUnitRecoilCoefficient (1 + _recoilPenalties);

	// Trait tactical_reload - reduces reload time by 25%
	if ("tactical_reload" in _traits) then {
		player removeAllEventHandlers "Reloaded";
		player addEventHandler ["Reloaded", {
			params ["_unit", "_weapon", "_muzzle"];
			_unit setWeaponReloadingTime [_unit, _muzzle, 0.75];
		}];
	};

	// Trait old - prevents sprinting
	player allowSprint !("old" in _traits);
}] call Compile_Global;

["A3PL_Traits_UpdateUserTree", {
	/*
		Updates the traits tree in the menu
	*/
	private _display = findDisplay TRAITS_DISPLAY_IDD;
	if (isNull _display) exitWith {};

	private _treeCtrl = _display displayCtrl TRAITS_TREE_IDC;
	if (isNull _treeCtrl) exitWith {
		systemChat "ERROR: Tree control not found!";
	};

	if (isNil "Config_TraitsCategories") exitWith {
		systemChat "ERROR: Config_TraitsCategories is nil!";
	};

	if (isNil "Config_Traits") exitWith {
		systemChat "ERROR: Config_Traits is nil!";
	};

	private _freePoints = [] call A3PL_Traits_GetFreePoints;

	tvClear _treeCtrl;

	private _categoriesKeys = keys Config_TraitsCategories;
	systemChat format ["DEBUG: Found %1 categories", count _categoriesKeys];

	{
		private _categoryName = _x;
		private _categoryData = Config_TraitsCategories get _categoryName;
		if (isNil "_categoryData") then {continue};

		private _index = _treeCtrl tvAdd [[], _categoryData#0 call A3PL_Localize];
		private _categoryTraits = _categoryData#1;
		private _traitsProgression = player getVariable ["Player_TraitsProgression", createHashMap];
		private _generalProgression = _traitsProgression getOrDefault [_categoryName, []];

		{
			private _currentIndex = _forEachIndex;
			private _prevTraitProgression = _generalProgression param [_currentIndex - 1, -1, [0]];
			private _traitProgression = _generalProgression param [_currentIndex, -1, [0]];

			if (count(_x) isEqualTo 1) then {
				// Single trait
				private _traitName = _x#0;
				private _traitData = Config_Traits get _traitName;
				if (isNil "_traitData") then {continue};

				private _childIndex = _treeCtrl tvAdd [[_index], _traitData#0 call A3PL_Localize];

				_treeCtrl tvSetPicture [[_index, _childIndex], _traitData#2];
				if (_traitProgression isEqualTo -1) then {
					if ((_traitData#3 > _freePoints) || {(_prevTraitProgression isEqualTo -1) && {_currentIndex > 0}}) then {
						_treeCtrl tvSetColor [[_index, _childIndex], [0.796, 0.137, 0.137, 1]];
					} else {
						_treeCtrl tvSetColor [[_index, _childIndex], [0.302, 0.639, 0.98, 1]];
						_treeCtrl tvSetPictureRight [[_index, _childIndex], "\A3PL_Common\Traits\use_ca.paa"];
					};
				} else {
					_treeCtrl tvSetColor [[_index, _childIndex], [0.039, 0.545, 0.039, 1]];
				};
				_treeCtrl tvSetData [[_index, _childIndex], _traitName];
			} else {
				// Multiple choice
				private _childIndex = _treeCtrl tvAdd [[_index], format ["%1 %2", "STR_A3PL_Traits_Choice" call A3PL_Localize, _forEachIndex + 1]];
				private _childCanAcquire = false;

				{
					private _traitName = _x;
					private _traitData = Config_Traits get _traitName;
					if (isNil "_traitData") then {continue};

					private _childSubIndex = _treeCtrl tvAdd [[_index, _childIndex], _traitData#0 call A3PL_Localize];

					_treeCtrl tvSetPicture [[_index, _childIndex, _childSubIndex], _traitData#2];
					if (_traitProgression isEqualTo _forEachIndex) then {
						_treeCtrl tvSetColor [[_index, _childIndex, _childSubIndex], [0.039, 0.545, 0.039, 1]];
					} else {
						if (_traitProgression isEqualTo -1) then {
							if ((_traitData#3 > _freePoints) || {(_prevTraitProgression isEqualTo -1) && {_currentIndex > 0}}) then {
								_treeCtrl tvSetColor [[_index, _childIndex, _childSubIndex], [0.796, 0.137, 0.137, 1]];
							} else {
								_treeCtrl tvSetColor [[_index, _childIndex, _childSubIndex], [0.302, 0.639, 0.98, 1]];
								_treeCtrl tvSetPictureRight [[_index, _childIndex, _childSubIndex], "\A3PL_Common\Traits\use_ca.paa"];
								_childCanAcquire = true;
							};
						};
					};
					_treeCtrl tvSetData [[_index, _childIndex, _childSubIndex], _traitName];
				} forEach _x;

				if (_traitProgression isEqualTo -1) then {
					if (!_childCanAcquire || {(_prevTraitProgression isEqualTo -1) && {_currentIndex > 0}}) then {
						_treeCtrl tvSetColor [[_index, _childIndex], [0.796, 0.137, 0.137, 1]];
					} else {
						_treeCtrl tvSetColor [[_index, _childIndex], [0.302, 0.639, 0.98, 1]];
					};
				};
			};
		} forEach _categoryTraits;
	} forEach (keys Config_TraitsCategories);
}] call Compile_Global;

["A3PL_Traits_OnAcquired", {
	/*
		Called when a trait has been successfully acquired (from the server)
		Parameters:
			0: STRING - trait name
	*/
	params [["_traitName", "", [""]]];

	if (_traitName isEqualTo "") exitWith {};

	private _traitData = Config_Traits get _traitName;
	if (isNil "_traitData") exitWith {};

	playSound "\A3PL_Common\Traits\success_win.ogg";

	("A3PL_Layer_Notification" call BIS_fnc_rscLayer) cutText [
		format [
			"<t font='PuristaBold' size='3'>%2 - <t color='#FFBF00'>%1</t></t>",
			_traitData#0 call A3PL_Localize,
			"STR_A3PL_Traits_NewTraitAcquired" call A3PL_Localize
		],
		"PLAIN",
		1,
		true,
		true
	];
	("A3PL_Layer_Notification" call BIS_fnc_rscLayer) cutFadeOut 10;

	private _display = findDisplay TRAITS_DISPLAY_IDD;
	if !(isNull _display) then {
		private _treeCtrl = _display displayCtrl TRAITS_TREE_IDC;
		private _sel = tvCurSel _treeCtrl;
		_treeCtrl tvSetCurSel [-1];
		_treeCtrl tvSetCurSel _sel;

		[] call A3PL_Traits_UpdateUserTree;
	};

	[] call A3PL_Traits_UpdateAttributes;
}] call Compile_Global;

["A3PL_Traits_GetLuckyBonus", {
	/*
		Returns the lucky bonus to add to chance rolls
		Parameters:
			0: ARRAY - player traits (optional, will fetch from player if not provided)
		Returns: NUMBER - bonus percentage (0 or 15)
	*/
	params [["_traits", [], [[]]]];

	if (count _traits isEqualTo 0) then {
		_traits = player getVariable ["Player_Traits", []];
	};

	private _return = 0;
	if ("lucky" in _traits) then {_return = 15};
	_return;
}] call Compile_Global;
