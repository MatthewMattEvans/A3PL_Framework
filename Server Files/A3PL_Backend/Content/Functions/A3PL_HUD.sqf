/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_HUD_Init",
{
	disableSerialization;

	("A3PL_Hud" call BIS_fnc_rscLayer) cutRsc ["Dialog_HUD","PLAIN"];
	("A3PL_Hud_Overlay" call BIS_fnc_rscLayer) cutRsc ["Dialog_HUD_Overlay","PLAIN"];
	(uiNamespace getVariable "Dialog_HUD_Overlay") call A3PL_Dialog_Localize;

	private _display = uiNamespace getVariable "A3PL_HUDDisplay";
	_control = _display displayCtrl 9520;
	_control ctrlSetFade 1;
	_control ctrlCommit 0;
	_control = _display displayCtrl 9521;
	_control ctrlSetFade 1;
	_control ctrlCommit 0;

	A3PL_HUD_Text = "";

	call A3PL_Twitter_Init;
	[] spawn A3PL_HUD_GPS;
}] call compile_Global;

["A3PL_HUD_Message",
{
	disableSerialization;
	private _display = uiNamespace getVariable "A3PL_HUDDisplay";
	private _control = _display displayCtrl 1104;

	private _txt = param [0,""];
	private _color = param [1,Color_Red];
	private _silent = param [2,false];
	private _time = 10;

	private _text = format ["<t color='%1' font='RobotoCondensed' align='left'>%2</t><br />",_color,_txt];
	_control ctrlSetStructuredText parseText (A3PL_HUD_Text + _text);
	A3PL_HUD_Text = (A3PL_HUD_Text + _text);

	if ((_color == Color_Red) && !(_silent)) then {
		playsound "3DEN_notificationWarning";
	} else {
		if (!_silent) then {
			playsound "defaultNotification";
		};
	};

	[_time] spawn
	{
		private ["_time"];
		_time = param [0,10];
		uiSleep _time;
		call A3PL_HUD_Clear;
	};
}] call compile_Global;

["A3PL_HUD_Clear",
{
	disableSerialization;
	private _text = toArray A3PL_HUD_Text;
	{
		private _delete = false;
		if (_x == 60) then
		{
			_index = _forEachIndex;
			//look for <br />
			if ((_text select (_index+1) == 98) && (_text select (_index+2) == 114) && (_text select (_index+3) == 32) && (_text select (_index+4) == 47) && (_text select (_index+5) == 62)) exitwith
			{
				_text deleteRange [0,_index+6];
				private _display = uiNamespace getVariable "A3PL_HUDDisplay";
				private _control = _display displayCtrl 1104;
				_control ctrlSetStructuredText parseText (toString _text);
				A3PL_HUD_Text = (toString _text);
				_delete = true;
			};
		};
		if (_delete) exitwith {};
	} foreach _text;
}] call compile_Global;

["A3PL_Hud_IDCard",
{
	params [
		["_target",objNull,[objNull]],
		["_faction","citizen"],
		["_isFake",false]
	];
	disableSerialization;

	private _fullName = if(_isFake) then {_target getVariable["fakeName",""]} else {_target getVariable ["name","Error"]};
	private _charID = _target getVariable ["character_id",""];
	private _fname = (_fullName splitString " ")#0;
	private _lname = (_fullName splitString " ")#1;

	if(_faction isEqualTo "citizen") exitwith {
		("A3PL_Hud_IDCard" call BIS_fnc_rscLayer) cutRsc ["Dialog_HUD_IDCard","PLAIN"];
		private _display = uiNamespace getVariable "A3PL_HUD_IDCard";
		private _licenses = _target getVariable ["licenses",[]];
		private _displayLicenses = "";
		if(_licenses isNotEqualTo []) then {
			{
				if (!(_x in Invisible_Licenses)) then {
					_displayLicenses = format ["%1<br/>%2", _displayLicenses, [_x, 0] call A3PL_Config_GetLicenseData];
				};
			} foreach _licenses;
		} else {
			_displayLicenses = ("STR_A3PL_HUD_NoLicenses" call A3PL_Localize);
		};
		(_display displayCtrl 1000) ctrlSetStructuredText parseText format["<t font='PuristaMedium' align='left' size='1' color='#000000'>%1</t>", _target getVariable ["db_id","0"]];
		(_display displayCtrl 1001) ctrlSetStructuredText parseText format["<t font='PuristaMedium' align='left' size='1' color='#000000'>%1</t>", _fname];
		(_display displayCtrl 1002) ctrlSetStructuredText parseText format["<t font='PuristaMedium' align='left' size='1' color='#000000'>%1</t>", _lname];
		(_display displayCtrl 1003) ctrlSetStructuredText parseText format["<t font='PuristaMedium' align='left' size='0.7' color='#000000'>%1</t>", _target getVariable ["dob",("STR_Common_Unknown" call A3PL_Localize)]];
		(_display displayCtrl 1004) ctrlSetStructuredText parseText format["<t font='PuristaMedium' align='left' size='1' color='#000000'>%1</t>", _target getVariable ["gender",("STR_Common_Unknown" call A3PL_Localize)]];
		(_display displayCtrl 1005) ctrlSetStructuredText parseText format["<t font='PuristaMedium' align='left' size='1' color='#000000'>%1</t>", _target getVariable ["date",("STR_Common_Unknown" call A3PL_Localize)]];
		(_display displayCtrl 1006) ctrlSetStructuredText parseText format["<t font='PuristaMedium' align='left' size='0.5' color='#000000'>%1</t>", _displayLicenses];
		[format[("STR_A3PL_HUD_LicenseList" call A3PL_Localize),_displayLicenses],Color_Green] call A3PL_Notification;
		uiSleep 8;
		("A3PL_Hud_IDCard" call BIS_fnc_rscLayer) cutFadeOut 1;
	};
	if(_faction isEqualTo "company") exitwith {
		("A3FL_Hud_CompanyCard" call BIS_fnc_rscLayer) cutRsc ["Dialog_HUD_CompanyCard","PLAIN"];
		private _display = uiNamespace getVariable "A3FL_HUD_CompanyCard";
		private _cid = [_charID] call A3PL_Config_GetCompanyID;
		private _cName = [_cid, "name"] call A3PL_Config_GetCompanyData;
		private _cdLicenses = [_cid, "licenses"] call A3PL_Config_GetCompanyData;
		private _cRank = [_cid, "rank", _charID] call A3FL_Config_GetCompanyRankData;
		private _cLicenses = "";
		if(_cdLicenses isNotEqualTo []) then {
			{
				_cLicenses = format ["%2<br/>%1",_cLicenses, [_x,0] call A3PL_Config_GetLicenseData];
			} foreach _cdLicenses;
		} else {
			_cLicenses = ("STR_A3PL_HUD_NoLicenses" call A3PL_Localize);
		};
		(_display displayCtrl 999) ctrlSetText "\A3PL_Common\GUI\Cards\Card_Company.paa";
		(_display displayCtrl 1000) ctrlSetStructuredText parseText format["<t font='PuristaMedium' align='left' size='1' color='#000000'>%1</t>", _target getVariable ["db_id","Error"]];
		(_display displayCtrl 1001) ctrlSetStructuredText parseText format["<t font='PuristaMedium' align='left' size='1' color='#000000'>%1</t>", _fname];
		(_display displayCtrl 1002) ctrlSetStructuredText parseText format["<t font='PuristaMedium' align='left' size='1' color='#000000'>%1</t>", _lname];
		(_display displayCtrl 1003) ctrlSetStructuredText parseText format["<t font='PuristaMedium' align='left' size='1' color='#000000'>%1</t>", _cName];
		(_display displayCtrl 1004) ctrlSetStructuredText parseText format["<t font='PuristaMedium' align='left' size='1' color='#000000'>%1</t>", _cRank];
		(_display displayCtrl 1005) ctrlSetStructuredText parseText format["<t font='PuristaMedium' align='left' size='0.5' color='#000000'>%1</t>", _cLicenses];
		[format[("STR_A3PL_HUD_LicenseList" call A3PL_Localize),_cLicenses],Color_Green] call A3PL_Notification;
		uiSleep 15;
		("A3FL_Hud_CompanyCard" call BIS_fnc_rscLayer) cutFadeOut 1;
	};

	("A3PL_Hud_FactionCard" call BIS_fnc_rscLayer) cutRsc ["Dialog_HUD_FactionCard","PLAIN"];
	private _display = uiNamespace getVariable "A3PL_HUD_FactionCard";
	private _cardImage = format["\A3PL_Common\GUI\Cards\Card_%1.paa",_faction];
	private _rank = [_faction,"rank", _charID] call A3PL_Config_GetFactionRankData;

	(_display displayCtrl 999) ctrlSetText _cardImage;
	(_display displayCtrl 1000) ctrlSetStructuredText parseText format["<t font='PuristaMedium' align='left' size='1' color='#000000'>%1</t>", _target getVariable ["db_id","Error"]];
	(_display displayCtrl 1001) ctrlSetStructuredText parseText format["<t font='PuristaMedium' align='left' size='1' color='#000000'>%1</t>", _fname];
	(_display displayCtrl 1002) ctrlSetStructuredText parseText format["<t font='PuristaMedium' align='left' size='1' color='#000000'>%1</t>", _lname];
	(_display displayCtrl 1003) ctrlSetStructuredText parseText format["<t font='PuristaMedium' align='left' size='1' color='#000000'>%1</t>", toUpper _faction];
	(_display displayCtrl 1004) ctrlSetStructuredText parseText format["<t font='PuristaMedium' align='left' size='1' color='#000000'>%1</t>", _rank];

	uiSleep 8;
	("A3PL_Hud_FactionCard" call BIS_fnc_rscLayer) cutFadeOut 1;
}] call compile_Global;

["A3PL_HUD_Loop",
{
	disableSerialization;

	private _display = uiNamespace getVariable ["A3PL_HUDDisplay",displayNull];
	private _isHudEnabled = profileNameSpace getVariable ["A3PL_HUD_Enabled",true];
	private _isStatsEnabled = profileNameSpace getVariable ["A3PL_HUD_Stats",true];
	private _isNameEnabled = profileNameSpace getVariable ["A3PL_HUD_Name",true];
	private _vehicle = vehicle player;
	private _name = player getVariable ["name",("STR_Common_Unknown" call A3PL_Localize)];
	private _job = player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];

	if (isNull _display && {_isHudEnabled}) then {
		("A3PL_Hud" call BIS_fnc_rscLayer) cutRsc ["Dialog_HUD","PLAIN"];
		_display = uiNamespace getVariable ["A3PL_HUDDisplay",displayNull];
	};
	if (!isNull _display && {!_isHudEnabled}) then {
		("A3PL_Hud" call BIS_fnc_rscLayer) cutRsc ["Dialog_HUD","PLAIN"];
		uiNameSpace setVariable ["A3PL_HUDDisplay",nil];
	};
	if (isNull _display) exitwith {};

	private _control = _display displayCtrl 1000;
	private _controlShown = ctrlShown _control;
	if(player getVariable ["jailed",false]) then {
		_control ctrlSetText format[("STR_A3PL_HUD_TimeRemaining" call A3PL_Localize),(player getVariable ["jailtime",0])];
		if(!_controlShown) then {_control ctrlShow true;};
	} else {
		if(_controlShown) then {_control ctrlShow false;};
	};

    _playerhunger = Player_Hunger;
    _playerthirst = Player_Thirst;
	if (Pee_System == true) then {
    	_playerpee = Player_Pee;
	};
	if (Sleep_System == true) then {
    	_playersleep = Player_Sleep;
	};
    _playeralcohol = Player_Alcohol;
    _magcolor = "#FFFFFF";
    _ammocolor = "#FFFFFF";
    _ammotext = parseText format[""];
    _amountmagtext = parseText format[""];
    _weaponname = parseText format[""];
    _hudinfo = weaponState player;
    _curweapon = _hudinfo select 0;
    _curmagazine = _hudinfo select 4;
    _className = _hudinfo select 3;
    _gunmodeold = _hudinfo select 2;
    _gunmode = "";

    if ((_gunmodeold isEqualTo "single") or (_gunmodeold isEqualTo "FullAuto") or (_gunmodeold isEqualTo "Burst") or (_gunmodeold isEqualTo "manual")) then {
        _gunmode = _gunmodeold;
        if (_gunmodeold isEqualTo "single") then {_gunmode = ("STR_A3PL_HUD_Single" call A3PL_Localize)};
        if (_gunmodeold isEqualTo "FullAuto") then {_gunmode = ("STR_A3PL_HUD_FullAuto" call A3PL_Localize)};
        if (_gunmodeold isEqualTo "Burst") then {_gunmode = ("STR_A3PL_HUD_Burst" call A3PL_Localize)};
        if (_gunmodeold isEqualTo "manual") then {_gunmode = ("STR_A3PL_HUD_Manual" call A3PL_Localize)};
    };
    _magforpic = "";
    if (_curweapon != "") then {
        _magforpic = (getArray (configFile >> "CfgWeapons" >> _curweapon >> "magazines")) select 0;
    };
    _picture = "";
    _picture = getText (configFile >> "CfgMagazines" >> _magforpic >> "picture");
    _noweaponsarray = ["","","","",0];
    _nothing = _noweaponsarray select 0;
    if (_nothing isEqualTo _curweapon) then {} else {
        _zeroing = currentZeroing player;

        _magazineClass = currentMagazine player;
        _weaponname = getText (configFile >> "CfgWeapons" >> _curweapon >> "displayName");
        _maxammo = getNumber(configFile >> "CfgMagazines" >> _magazineClass >> "count") ;
        _prcentammo = 0;
        if (_curmagazine isEqualTo 0) then {
            _prcentammo = 0;
        } else {
            _prcentammo = (_curmagazine / _maxammo) * 100;
        };
        _amountmag = {_x isEqualTo (currentmagazine player)} count magazines player;
        if (_amountmag isEqualTo 0) then {
            _amountmagtext = parseText format[("STR_A3PL_HUD_NoMoreMags" call A3PL_Localize)];
            _magcolor = "#FFFFFF";
        } else {
            if (_amountmag isEqualTo 1) then {
                _amountmagtext = parseText format[("STR_A3PL_HUD_MagRemaining" call A3PL_Localize), _amountmag];
                        _magcolor = "#FFFFFF";
            } else {
                if (_amountmag > 1) then {
                    _amountmagtext = parseText format[("STR_A3PL_HUD_MagsRemaining" call A3PL_Localize), _amountmag];
                    _magcolor = "#FFFFFF";
                };
            };
        };
        if (_prcentammo isEqualTo 0) then {
            _ammotext = parseText format[("STR_A3PL_HUD_NoMoreBullet" call A3PL_Localize)];
            _ammocolor = "#FFFFFF";
        } else {
            if (_prcentammo < 20) then {
                _ammotext = parseText format[("STR_A3PL_HUD_MagSoonEmpty" call A3PL_Localize)];
                _ammocolor = "#FFFFFF";
            } else {
                if (_prcentammo < 40) then {
                    _ammotext = parseText format[("STR_A3PL_HUD_BulletSoonEmpty" call A3PL_Localize)];
                    _ammocolor = "#FFFFFF";
                } else {
                    if (_prcentammo < 60) then {
                        _ammotext = parseText format[("STR_A3PL_HUD_MidMag" call A3PL_Localize)];
                        _ammocolor = "#FFFFFF";
                    } else {
                        if (_prcentammo < 80) then {
                            _ammotext = parseText format[("STR_A3PL_HUD_Bulletok" call A3PL_Localize)];
                            _ammocolor = "#FFFFFF";
                        } else {
                            if (_prcentammo < 100) then {
                                _ammotext = parseText format[("STR_A3PL_HUD_LotOfBullet" call A3PL_Localize)];
                                _ammocolor = "#FFFFFF";
                            } else {
                                if (_prcentammo isEqualTo 100) then {
                                    _ammotext = parseText format[("STR_A3PL_HUD_MagFull" call A3PL_Localize)];
                                    _ammocolor = "#FFFFFF";
                                };
                            };
                        };
                    };
                };
            };
        };
    };

    private _ctrl = 1200; 
    private _status = [
        [_vehicle isNotEqualTo player && {typeOf _vehicle isKindOf "Car" && {!(typeOf _vehicle IN Seatbelt_Blacklist)}} && !(player getVariable["SeatbeltOn",false]),"\A3PL_Common\HUD\seatbeltoff.paa"],
        [_vehicle isNotEqualTo player && {typeOf _vehicle isKindOf "Car" && {!(typeOf _vehicle IN Seatbelt_Blacklist)}} && (player getVariable["SeatbeltOn",false]),"\A3PL_Common\HUD\seatbelton.paa"],
        [_vehicle isNotEqualTo player && {typeOf _vehicle isKindOf "Car" && {(getCruiseControl _vehicle)#1}},"\A3PL_Common\HUD\cruise.paa"],
        [player getVariable["Cuffed",false] || player getVariable["Zipped",false],"\A3PL_Common\HUD\handcuffs.paa"],
        [_playeralcohol > 0,"\A3PL_Common\HUD\alcool.paa"],
        [(_playerhunger > 30) && ( _playerhunger <= 50),"\A3PL_Common\HUD\hungerlow.paa"],
        [(_playerhunger > 20) &&( _playerhunger <= 30),"\A3PL_Common\HUD\hungermed.paa"],
        [_playerhunger <= 20,"\A3PL_Common\HUD\hungerhigh.paa"],
        [(_playerpee > 30) && (_playerpee <= 50) && (Pee_System == true),"\A3PL_Common\HUD\peelow.paa"],
        [(_playerpee > 20) && (_playerpee <= 30) && (Pee_System == true),"\A3PL_Common\HUD\peemed.paa"],
        [(_playerpee <= 20) && (Pee_System == true),"\A3PL_Common\HUD\peehigh.paa"],
        [(_playersleep > 30) && (_playersleep <= 50) && (Sleep_System == true),"\A3PL_Common\HUD\sleeplow.paa"],
        [(_playersleep > 20) && (_playersleep <= 30) && (Sleep_System == true),"\A3PL_Common\HUD\sleepmed.paa"],
        [(_playersleep <= 20) && (Sleep_System == true),"\A3PL_Common\HUD\sleephigh.paa"],
        [(_playerthirst > 30) && (_playerthirst <= 50),"\A3PL_Common\HUD\thirstlow.paa"],
        [(_playerthirst > 20) &&(_playerthirst <= 30),"\A3PL_Common\HUD\thirstmed.paa"],
        [_playerthirst <= 20,"\A3PL_Common\HUD\thirsthigh.paa"],
		[(A3PL_Phone_inCall == true),"\A3PL_Common\GUI\newphone\InCall.paa"],
        [(A3PL_Phone_Avion == true),"\A3PL_Common\GUI\newphone\CallOff.paa"],
        [(A3PL_Phone_Mute == true),"\A3PL_Common\GUI\newphone\ViberMode.paa"],
        [(A3PL_Phone_SMS == true),"\A3PL_Common\GUI\newphone\NewSms.paa"],
        [(A3PL_Phone_Anonyme == true),"\A3PL_Common\GUI\newphone\anonyme.paa"]
    ];

    {
        _condition = _x#0;
        _statuspic = _x#1;
        if (_condition) then {
            (_display displayCtrl _ctrl) ctrlSetText _statuspic;
            (_display displayCtrl _ctrl) ctrlShow true;
            _ctrl = _ctrl + 1;
        };
    } forEach _status;

    for "_i" from _ctrl to 1209 do {
        (_display displayCtrl _i) ctrlShow false;
    };

    _ammohudtext = parseText format ["<t font='EtelkaNarrowMediumPro' color='%1' size='0.9' align='left'>%2</t>",_ammocolor, _ammotext];
    _maghudtext = parseText format ["<t font='EtelkaNarrowMediumPro' color='%1' size='1' align='left'>%2</t>", _magcolor, _amountmagtext];
    _gunmodetext = parseText format ["<t font='EtelkaNarrowMediumPro' color='#FFFFFF' size='1' align='center'>%1</t>", _gunmode];
    _weapontexthud = parseText format ["<t font='EtelkaNarrowMediumPro' color='#FFFFFF' size='1' align='left'>%1</t>", _weaponname];
    (_display displayCtrl 16418) ctrlSetText _picture;
    (_display displayCtrl 16422) ctrlSetStructuredText _ammohudtext;
    (_display displayCtrl 16419) ctrlSetStructuredText _gunmodetext;
    (_display displayCtrl 16421) ctrlSetStructuredText _maghudtext;
    (_display displayCtrl 16420) ctrlSetStructuredText _weapontexthud;

	private _nameControl = _display displayCtrl 1600;
	private _displayName = if (player getVariable ["pVar_RedNameOn",false]) then {format ["<t font='PuristaBold' align='left' color='%1'>%2</t>",[player,true] call A3PL_Admin_Color,toUpperANSI _name]} else {format ["<t font='PuristaBold' align='left'>%1</t>",toUpperANSI _name]};
	_nameControl ctrlSetStructuredText parseText _displayName;

	private _jobControl = _display displayCtrl 1601;
	private _displayJob = if(_job IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) then {[_job,"rank", (player getVariable ["character_id",""])] call A3PL_Config_GetFactionRankData} else {_job};
	_jobControl ctrlSetStructuredText parseText format["<t font='PuristaMedium' align='left'>%1</t>",toUpperANSI (_displayJob)];

	private _setFade = parseNumber (!_isNameEnabled);
	{
		private ["_ctrl"];
		_ctrl = _display displayCtrl _x;
		_ctrl ctrlSetFade _setFade;
		_ctrl ctrlCommit 0;
	} forEach [1500,1600,1601];
    
    private _setFade = parseNumber (!_isStatsEnabled);
    {
        private ["_ctrl"];
		_ctrl = _display displayCtrl _x;
		_ctrl ctrlSetFade _setFade;
		_ctrl ctrlCommit 0;
    } forEach [1200,1201,1202,1203,1204];

    if (Threat_Level) then {
		private _ctrl_threatLevelPicture = _display displayCtrl 16576;
		private _ctrl_threatLevelText = _display displayCtrl 16577;

		switch (Server_ThreatLevel) do {
			case "green" : { 
				_ctrl_threatLevelText ctrlSetStructuredText parseText format[("STR_A3PL_HUD_Green" call A3PL_Localize)]; 
			};
			case "amber" : {  
				_ctrl_threatLevelText ctrlSetStructuredText parseText format[("STR_A3PL_HUD_Amber" call A3PL_Localize)]; 
			};
			case "red" : {  
				_ctrl_threatLevelText ctrlSetStructuredText parseText format[("STR_A3PL_HUD_Red" call A3PL_Localize)]; 
			};
			case "martial" : {  
				_ctrl_threatLevelText ctrlSetStructuredText parseText format[("STR_A3PL_HUD_MartialLaw" call A3PL_Localize)]; 
			};
			default {  
				_ctrl_threatLevelText ctrlSetStructuredText parseText format[("STR_A3PL_HUD_Error" call A3PL_Localize)]; 
			};
		};
	};
}] call compile_Global;

["A3PL_HUD_SetOverlay",
{
	disableSerialization;
	params[["_path",""],["_order",0],["_opacity",1]];
	private _idc = (uiNamespace getVariable "A3PL_Hud_Overlay") displayCtrl (1200+_order);
	_idc ctrlSetText _path;
	_idc ctrlSetFade _opacity;
	_idc ctrlCommit 0;
}] call compile_Global;

["A3PL_HUD_GPS", {
	if (isNull (uiNameSpace getVariable ["Dialog_Hud_GPS", displayNull])) then {
		disableSerialization;
		("A3FL_GPS" call BIS_fnc_rscLayer) cutRsc ["Dialog_Hud_GPS", "PLAIN"];

		private _display = uiNameSpace getVariable ["Dialog_Hud_GPS", displayNull];
		private _ctrl_gps_map = _display displayCtrl 23539;
		private _ctrl_gps_azimut = _display displayCtrl 23542;
		private _ctrl_gps_altitude = _display displayCtrl 23543;
		private _ctrl_gps_position = _display displayCtrl 23544;

        private _display2 = uiNameSpace getVariable ["A3PL_HUDDisplay", displayNull];
        private _ctrl_gps_frame = _display2 displayCtrl 1500;
        private _ctrl_gps_name = _display2 displayCtrl 1600;
        private _ctrl_gps_job = _display2 displayCtrl 1601;

		createMarkerLocal ["myGPS", getPos player];
		"myGPS" setMarkerShapeLocal "ICON";
		"myGPS" setMarkerTypeLocal "A3PL_GPS";
		"myGPS" setMarkerColorLocal "ColorOrange";
		"myGPS" setMarkerSizeLocal [0.7, 0.7];

		while {!isNull _display} do {
			private _vehicle = vehicle player;
			private _hasGPS = "ItemGPS" IN (assignedItems player);
			private _isShown = uiNameSpace setVariable ["Dialog_GPS_Visible", true];
			if (!_hasGPS || {visibleMap || {!(profilenamespace getVariable ["A3PL_ShowGPS",true])}}) then {
				_ctrl_gps_map ctrlShow false;
                _ctrl_gps_azimut ctrlShow false;
                _ctrl_gps_position ctrlShow false;
                _ctrl_gps_altitude ctrlShow false;
                _ctrl_gps_frame ctrlShow false;
                _ctrl_gps_name ctrlShow false;
                _ctrl_gps_job ctrlShow false;
			} else {
				_ctrl_gps_map ctrlShow true;
                _ctrl_gps_azimut ctrlShow true;
                _ctrl_gps_position ctrlShow true;
                _ctrl_gps_altitude ctrlShow true;
                _ctrl_gps_frame ctrlShow true;
                _ctrl_gps_name ctrlShow true;
                _ctrl_gps_job ctrlShow true;
			};

			if (_hasGPS) then {
				"myGPS" setMarkerAlphaLocal 1;
				"myGPS" setMarkerPosLocal (getPos _vehicle);
				"myGPS" setMarkerDirLocal floor((getDir _vehicle) - 40);
			} else {
				"myGPS" setMarkerAlphaLocal 0;
			};
			if (profilenamespace getVariable ["A3PL_ShowGPS",true] && {!visibleMap}) then {
				_ctrl_gps_azimut ctrlSetStructuredText parseText format["<t size='0.6' font='PuristaLight' color='#ffffff' align='center'>%1</t>",call A3PL_Lib_GetHeading];
				_ctrl_gps_altitude ctrlSetStructuredText parseText format["<t size='0.6' font='PuristaLight' color='#ffffff' align='center'>%1</t>",round((getPosASL _vehicle)#2)];
				_ctrl_gps_position ctrlSetStructuredText parseText format["<t size='0.6' font='PuristaLight' color='#ffffff' align='center'>%1</t>",(mapGridPosition player)];
				if (_vehicle isEqualTo player) then {
					_ctrl_gps_map ctrlMapAnimAdd [0, 0.05, player];
				} else {
					_ctrl_gps_map ctrlMapAnimAdd [0, 0.15, (vehicle player)];
				};
				ctrlMapAnimCommit _ctrl_gps_map;
			};
			sleep 0.0001;
		};
	};
}] call compile_Global;

