/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/

["PO_Achievement_Learn", {
	_achievement = [_this,0,"",[""]] call BIS_fnc_param;

	if (isNil "A3PL_Achievement") then {
        A3PL_Achievement = [];
    };

	_cfgAchievement = Config_Achievement;

	if (([_achievement] call PO_Achievement_Has)) exitWith {};

	_achievementData = _cfgAchievement get _achievement;
    _displayname = _achievementData#0;
    _description = _achievementData#1;
    _xp = _achievementData#2;
	_need = _achievementData#3;

	_can = true;

	if ((count _need) > 0) then {
		{
			if (!(_x in A3PL_Achievement)) exitWith {
				_can = false;
			};
		} forEach _need;
	};

	if (!_can) exitWith {};

	A3PL_Achievement pushBack _achievement;

	[player, A3PL_Achievement] remoteExec ["Server_Achievement_Update",2];

	_displayname = format[("STR_A3PL_Achievement_SuccessUnlocked" call A3PL_Localize), _displayname];

	[format["%1",_description], Color_Blue] call A3PL_Notification;
}] call compile_Global;

["PO_Achievement_Has", {
	_achievement = [_this,0,"",[""]] call BIS_fnc_param;

	_has = false;

	if (_achievement in A3PL_Achievement) then {
		_has = true;
	};

	_has;
}] call compile_Global;

["PO_Achievement_Get", {
	A3PL_Achievement = [];

	if(isNil "_this") exitWith {};
	{
		A3PL_Achievement pushBack _x;
	} forEach _this;
}] call compile_Global;

["PO_Achievement_Menu", {
	disableSerialization;

	createDialog "A3PL_Achievements";

	_display = findDisplay 2060;
	_group = _display displayCtrl 2061;

	_pos = 0;

	{
		_achievementData = Config_Achievement get _x;
        if (!isNil "_achievementData") then {
			_controlStrip = _display ctrlCreate ["RscText", -1, _group];
			_controlBack = _display ctrlCreate ["RscText", -1, _group];

			_controlIcon = _display ctrlCreate ["RscStructuredText", -1, _group];
			_controlText = _display ctrlCreate ["RscStructuredText", -1, _group];

			_controlStrip ctrlSetPosition [0, _pos, 0.01, 0.1];
			_controlBack ctrlSetPosition [0.01, _pos, 0.99, 0.1];

			_controlIcon ctrlSetPosition [0.02, _pos, 0.11, 0.1];
			_controlText ctrlSetPosition [0.11, _pos, 0.89, 0.1];

			_displayName = _achievementData#0;
            _icon = _achievementData#4;
            _description = _achievementData#1;

			if (_icon != "") then {
				_controlIcon ctrlSetStructuredText parseText format["<img image='%1' size='2.5'></img><br/>",_icon];
			};

			_controlText ctrlSetStructuredText parseText format ["<t size='0.8' font='PuristaBold'>%1</t><br/><t size='0.8' font='PuristaLight' color='#c4c4c4'>%2</t><br/>", _displayName, _description];

			_controlStrip ctrlSetBackgroundColor [0.043,0.486,0.769,1];
			_controlBack ctrlSetBackgroundColor [-1,-1,-1,0.8];

			_controlBack ctrlCommit 0;
			_controlStrip ctrlCommit 0;
			_controlIcon ctrlCommit 0;
			_controlText ctrlCommit 0;

			_pos = _pos + 0.11;
		};
	} forEach A3PL_Achievement;

	{
		_achievementData = Config_Achievement get _x;
        if (!isNil "_achievementData" && !(_x in A3PL_Achievement)) then {
			_controlStrip = _display ctrlCreate ["RscText", -1, _group];
			_controlBack = _display ctrlCreate ["RscText", -1, _group];

			_controlIcon = _display ctrlCreate ["RscStructuredText", -1, _group];
			_controlText = _display ctrlCreate ["RscStructuredText", -1, _group];

			_controlStrip ctrlSetPosition [0, _pos, 0.01, 0.1];
			_controlBack ctrlSetPosition [0.01, _pos, 0.99, 0.1];

			_controlIcon ctrlSetPosition [0.02, _pos, 0.11, 0.1];
			_controlText ctrlSetPosition [0.11, _pos, 0.89, 0.1];

			_displayName = _achievementData#0;
            _icon = _achievementData#4;
			_description = ("STR_A3PL_Achievement_Locked" call A3PL_Localize);

			_color = [0.714,0.714,0.714,1];

			_controlText ctrlSetStructuredText parseText format ["<t size='0.8' font='PuristaBold'>%1</t><br/><t size='0.8' font='PuristaLight' color='#c4c4c4'>%2</t><br/>", _displayName, _description];

			_controlStrip ctrlSetBackgroundColor _color;
			_controlBack ctrlSetBackgroundColor [-1,-1,-1,0.8];



			_controlBack ctrlCommit 0;
			_controlStrip ctrlCommit 0;
			_controlIcon ctrlCommit 0;
			_controlText ctrlCommit 0;

			_pos = _pos + 0.11;
		};
	} forEach (keys Config_Achievement);
}] call compile_Global;