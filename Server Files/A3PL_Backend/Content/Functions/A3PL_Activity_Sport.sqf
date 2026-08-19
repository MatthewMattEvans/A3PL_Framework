/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Sport_Init",
{
    Player_ScopeStability = 30;

	player enableStamina true;
	setStaminaScheme "Normal";
	player setAnimSpeedCoef Player_SportSpeed;
	player setCustomAimCoef Player_ScopeStability;

	while {true} do
	{
		if (Player_SportLevel < 1) then
		{
			Player_maxTimeTired = 30;
			Player_SportSpeed = 1;
			Player_ScopeStability = 1;
			player setVariable ["Player_maxTimeTired",Player_maxTimeTired,false];
			player setVariable ["Player_SportSpeed",Player_SportSpeed,false];
			player setVariable ["Player_ScopeStability",Player_ScopeStability,false];
		};
		if ((Player_SportLevel == 1) && ((Player_ScopeStability != 0.90) || (Player_SportSpeed != 1.05) || (Player_maxTimeTired != 35))) then
		{
			Player_maxTimeTired = 35;
			Player_ScopeStability = 0.90;
			Player_SportSpeed = 1.05;
			player setVariable ["Player_maxTimeTired",Player_maxTimeTired,false];
			player setVariable ["Player_SportSpeed",Player_SportSpeed,false];
			player setVariable ["Player_ScopeStability",Player_ScopeStability,false];
		};
		if ((Player_SportLevel == 2) && ((Player_ScopeStability != 0.75) || (Player_SportSpeed != 1.15) || (Player_maxTimeTired != 39))) then
		{
			Player_maxTimeTired = 39;
			Player_ScopeStability = 0.75;
			Player_SportSpeed = 1.15;
			player setVariable ["Player_maxTimeTired",Player_maxTimeTired,false];
			player setVariable ["Player_SportSpeed",Player_SportSpeed,false];
			player setVariable ["Player_ScopeStability",Player_ScopeStability,false];
		};
		if ((Player_SportLevel == 3) && ((Player_ScopeStability != 0.55) || (Player_SportSpeed != 1.27) || (Player_maxTimeTired != 44))) then
		{
			Player_maxTimeTired = 44;
			Player_ScopeStability = 0.55;
			Player_SportSpeed = 1.27;
			player setVariable ["Player_maxTimeTired",Player_maxTimeTired,false];
			player setVariable ["Player_SportSpeed",Player_SportSpeed,false];
			player setVariable ["Player_ScopeStability",Player_ScopeStability,false];
		};

		if (getStamina player < 5 && Player_maxTimeTired != 44) then
		{
			if (isnil "tired") then
			{
				tired = true;
				[("STR_A3PL_Activity_Sport_YouTired" call A3PL_Localize),Color_Yellow] call A3PL_Notification;
				Player_Thirst = Player_Thirst - 10;
			};
		};
		if (getStamina player > Player_maxTimeTired) then
		{
			player SetStamina Player_maxTimeTired;
		};
		if (getCustomAimCoef player != Player_ScopeStability) then
		{
			player setCustomAimCoef Player_ScopeStability;
		};
		if (getAnimSpeedCoef player != Player_SportSpeed) then
		{
			player setAnimSpeedCoef Player_SportSpeed;
		};
	};
}] call compile_Global;

["A3PL_Sport_Level1",
{
    if (isnil "msgsportend") then {msgsportend = 0;};
    if (msgsportend == 1) exitwith {[("STR_A3PL_Activity_Sport_AlreadyinSport" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    if (Player_SportLevel != 0) exitwith {[("STR_A3PL_Activity_Sport_Level0Required" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    msgsportend = 1;

    _distance = floor (200 + (random 250));
    _last_notification_distance = _distance; 

    [format[("STR_A3PL_Activity_Sport_NeedToRun" call A3PL_Localize),_distance],Color_Orange] call A3PL_Notification;
    sleep 5;

    while {_distance > 0 && alive player && vehicle player == player} do
    {
        _pos1 = (getPosATL (vehicle player));
        sleep 0.7;
        _pos2 = (getPosATL (vehicle player));
        _verifier_distance = _pos1 distance _pos2;
        _speed = speed player;
        _position_de_depart = position player;
        if ((_verifier_distance > 0.2) && (player distance _position_de_depart < 60) && (_speed > 7)) then
        {
            _distance = _distance - 1;
            
            if (_distance <= _last_notification_distance - 25 || _distance <= 0) then {
                [format[("STR_A3PL_Activity_Sport_NeedToRun" call A3PL_Localize),_distance],Color_Orange] call A3PL_Notification;
                _last_notification_distance = _distance;
            };
        };
        if (_speed < 7) then {[("STR_A3PL_Activity_Sport_YoureNotRunning" call A3PL_Localize),Color_Red] call A3PL_Notification; waituntil {sleep 1; speed player > 0};};
        if (player distance _position_de_depart > 60) then {[("STR_A3PL_Activity_Sport_YouAreNotInSportCenter" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    };
    if (!alive player) exitwith {};
    if (vehicle player != player) exitwith {msgsportend = 0;[("STR_A3PL_Activity_Sport_YouCheated" call A3PL_Localize),Color_Red] call A3PL_Notification;};

    sleep 1;
    msgsportend = 0;

    ["sport1"] call PO_Achievement_Learn;
    [("STR_A3PL_Activity_Sport_Level1Validated" call A3PL_Localize),Color_Green] call A3PL_Notification;
    Player_SportLevel = Player_SportLevel + 1;
    player setVariable ["Player_SportLevel",Player_SportLevel,false];
    [getPlayerUID player,(player getVariable ["character_id",""]),"Activities_Sport","Passage Level 1 Sport"] remoteExec ["Server_Log_New",2];
    call A3PL_Sport_Init;
}] call compile_Global;

["A3PL_Sport_Level2",
{
    if (isnil "msgsportend") then {msgsportend = 0;};
    if (msgsportend == 1) exitwith {[("STR_A3PL_Activity_Sport_AlreadyinSport" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    if (Player_SportLevel != 1) exitwith {[("STR_A3PL_Activity_Sport_Level1Required" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    msgsportend = 1;

    _distance = floor (300 + (random 250));
    _last_notification_distance = _distance; 

    [format[("STR_A3PL_Activity_Sport_NeedToRun" call A3PL_Localize),_distance],Color_Orange] call A3PL_Notification;
    sleep 5;

    while {_distance > 0 && alive player && vehicle player == player} do
    {
        _pos1 = (getPosATL (vehicle player));
        sleep 0.7;
        _pos2 = (getPosATL (vehicle player));
        _verifier_distance = _pos1 distance _pos2;
        _speed = speed player;
        _position_de_depart = position player;
        if ((_verifier_distance > 0.2) && (player distance _position_de_depart < 60) && (_speed > 7)) then
        {
            _distance = _distance - 1;
            if (_distance <= _last_notification_distance - 25 || _distance <= 0) then {
                [format[("STR_A3PL_Activity_Sport_NeedToRun" call A3PL_Localize),_distance],Color_Orange] call A3PL_Notification;
                _last_notification_distance = _distance;
            };
        };
        if (_speed < 7) then {[("STR_A3PL_Activity_Sport_YoureNotRunning" call A3PL_Localize),Color_Red] call A3PL_Notification; waituntil {sleep 1; speed player > 0};};
        if (player distance _position_de_depart > 60) exitWith {[("STR_A3PL_Activity_Sport_YouAreNotInSportCenter" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    };
    if (!alive player) exitwith {};
    if (vehicle player != player) exitwith {msgsportend = 0;[("STR_A3PL_Activity_Sport_YouCheated" call A3PL_Localize),Color_Red] call A3PL_Notification;};

    sleep 1;
    msgsportend = 0;

    ["sport2"] call PO_Achievement_Learn;
    [("STR_A3PL_Activity_Sport_Level2Validated" call A3PL_Localize),Color_Green] call A3PL_Notification;
    Player_SportLevel = Player_SportLevel + 1;
    player setVariable ["Player_SportLevel",Player_SportLevel,false];
    [getPlayerUID player,(player getVariable ["character_id",""]),"Activities_Sport","Passage Level 2 Sport"] remoteExec ["Server_Log_New",2];
    call A3PL_Sport_Init;
}] call compile_Global;

["A3PL_Sport_Level3",
{
    if (isnil "msgsportend") then {msgsportend = 0;};
    if (msgsportend == 1) exitwith {[("STR_A3PL_Activity_Sport_AlreadyinSport" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    if (Player_SportLevel != 2) exitwith {[("STR_A3PL_Activity_Sport_Level2Required" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    msgsportend = 1;

    _distance = floor (400 + (random 250));
    _last_notification_distance = _distance; // Stocke la dernière distance notifiée

    [format[("STR_A3PL_Activity_Sport_NeedToRun" call A3PL_Localize),_distance],Color_Orange] call A3PL_Notification;
    sleep 5;

    while {_distance > 0 && alive player && vehicle player == player} do
    {
        _pos1 = (getPosATL (vehicle player));
        sleep 0.7;
        _pos2 = (getPosATL (vehicle player));
        _verifier_distance = _pos1 distance _pos2;
        _speed = speed player;
        _position_de_depart = position player;
        if ((_verifier_distance > 0.2) && (player distance _position_de_depart < 60) && (_speed > 7)) then
        {
            _distance = _distance - 1;

            // Affiche la notification tous les 25 mètres
            if (_distance <= _last_notification_distance - 25 || _distance <= 0) then {
                [format[("STR_A3PL_Activity_Sport_NeedToRun" call A3PL_Localize),_distance],Color_Orange] call A3PL_Notification;
                _last_notification_distance = _distance;
            };
        };
        if (_speed < 7) then {[("STR_A3PL_Activity_Sport_YoureNotRunning" call A3PL_Localize),Color_Red] call A3PL_Notification; waituntil {sleep 1; speed player > 0};};
        if (player distance _position_de_depart > 60) then {[("STR_A3PL_Activity_Sport_YouAreNotInSportCenter" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    };
    if (!alive player) exitwith {};
    if (vehicle player != player) exitwith {msgsportend = 0;[("STR_A3PL_Activity_Sport_YouCheated" call A3PL_Localize),Color_Red] call A3PL_Notification;};

    sleep 1;
    msgsportend = 0;

    ["sport3"] call PO_Achievement_Learn;
    ["sportall"] call PO_Achievement_Learn;
    [("STR_A3PL_Activity_Sport_Level3Validated" call A3PL_Localize),Color_Green] call A3PL_Notification;
    Player_SportLevel = Player_SportLevel + 1;
    player setVariable ["Player_SportLevel",Player_SportLevel,false];
    [getPlayerUID player,(player getVariable ["character_id",""]),"Activities_Sport","Passage Level 3 Sport"] remoteExec ["Server_Log_New",2];
    call A3PL_Sport_Init;
}] call compile_Global;