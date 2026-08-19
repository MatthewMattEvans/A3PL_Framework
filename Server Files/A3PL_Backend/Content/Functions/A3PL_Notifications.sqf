/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
['A3PL_Notification',
{
	private ['_msg', '_color', '_silent', '_configName', '_title', '_final', '_i'];

	_msg = param [0,""];
	_color = param [1,Color_Red];
	_silent = param [2,false];

	switch (_color) do {
		case (Color_Red): {
			_configName = "Error";
		};
		case (Color_Green): {
			_configName = "Successful";
		};
		case (Color_Orange): {
			_configName = "Warning";
		};
		default {
			_configName = "InfoWithSound";
		};
	};

	[_configName,_msg] spawn A3PL_Notification_New;
}] call compile_Global;

['A3PL_Notification_Show', {
	params [
		["_title","Information",[""]],
		["_text","",[""]],
		["_stripColor",[0.043,0.486,0.769,1],[]],
		["_sound","FD_Timer_F",[""]]
	];

	if (_text isEqualTo "") exitWith {};
	if (_text in A3PL_eventNotifMessages) exitWith {};

	// Ajouter à la queue FIFO
	A3PL_eventNotifMessages pushBack _text;
	A3PL_eventNotifQueue pushBack [_title, _text, _stripColor, _sound];

	// Démarrer le processeur de queue s'il n'est pas déjà actif
	if (isNil "A3PL_notifProcessorRunning" || {!A3PL_notifProcessorRunning}) then {
		[] spawn A3PL_Notification_ProcessQueue;
	};
}] call compile_Global;

// Processeur de queue - un seul thread qui traite toutes les notifications séquentiellement
['A3PL_Notification_ProcessQueue', {
	if (!isNil "A3PL_notifProcessorRunning" && {A3PL_notifProcessorRunning}) exitWith {};
	A3PL_notifProcessorRunning = true;

	disableSerialization;

	while {count A3PL_eventNotifQueue > 0} do {
		private _notifData = A3PL_eventNotifQueue deleteAt 0;
		if (isNil "_notifData") then { continue };

		private _title = _notifData select 0;
		private _text = _notifData select 1;
		private _stripColor = _notifData select 2;
		private _sound = _notifData select 3;

		// Vérifier que le display existe
		private _display = findDisplay 46;
		if (isNull _display) then {
			// Attendre jusqu'à 5 secondes que le display soit disponible
			private _timeout = diag_tickTime + 5;
			waitUntil {!isNull (findDisplay 46) || diag_tickTime > _timeout};
			_display = findDisplay 46;
		};

		// Si toujours pas de display, abandonner cette notification et continuer
		if (isNull _display) then {
			A3PL_eventNotifMessages = A3PL_eventNotifMessages - [_text];
			continue;
		};

		// Décaler les notifications existantes vers le bas
		{
			private _ctrlText = _display displayCtrl (_x select 0);
			private _ctrlStrip = _display displayCtrl (_x select 1);

			if (!isNull _ctrlText && !isNull _ctrlStrip) then {
				private _posText = ctrlPosition _ctrlText;
				private _posStrip = ctrlPosition _ctrlStrip;
				private _height = (ctrlTextHeight _ctrlText) + 0.01;

				_posText set [1, (_posText select 1) + _height + 0.025];
				_posStrip set [1, (_posStrip select 1) + _height + 0.025];

				_ctrlText ctrlSetPosition _posText;
				_ctrlStrip ctrlSetPosition _posStrip;

				_ctrlText ctrlCommit 0.2;
				_ctrlStrip ctrlCommit 0.2;
			};
		} forEach A3PL_activeNotifControl;

		uiSleep 0.2;

		// Créer les nouveaux contrôles
		private _ctrlText = _display ctrlCreate ["RscStructuredText", A3PL_notifControlText];
		private _ctrlStrip = _display ctrlCreate ["RscText", A3PL_notifControlStrip];

		if (isNull _ctrlText || isNull _ctrlStrip) then {
			A3PL_eventNotifMessages = A3PL_eventNotifMessages - [_text];
			continue;
		};

		_ctrlStrip ctrlSetBackgroundColor _stripColor;
		_ctrlText ctrlSetBackgroundColor [-1,-1,-1,0.8];

		_ctrlText ctrlSetStructuredText parseText format ["<t size='0.8' font='PuristaLight'>%1</t><br/><t size='0.8' font='PuristaLight' color='#c4c4c4'>%2</t><br/>", _title, _text];

		_ctrlStrip ctrlSetPosition [-0.16618509 * safezoneW + safezoneX, 0.291 * safezoneH + safezoneY, 0.003 * safezoneW, 0 * safezoneH];
		_ctrlText ctrlSetPosition [-0.17031 * safezoneW + safezoneX, 0.291 * safezoneH + safezoneY, 0.180469 * safezoneW, 0 * safezoneH];
		_ctrlText ctrlCommit 0;
		_ctrlStrip ctrlCommit 0;

		_ctrlText ctrlSetPosition [0.01 * safezoneW + safezoneX, (ctrlPosition _ctrlText) select 1, (ctrlPosition _ctrlText) select 2, ctrlTextHeight _ctrlText + 0.01];
		_ctrlText ctrlCommit 0.7;

		_ctrlStrip ctrlSetPosition [0.0055 * safezoneW + safezoneX, (ctrlPosition _ctrlStrip) select 1, (ctrlPosition _ctrlStrip) select 2, ctrlTextHeight _ctrlText + 0.01];
		_ctrlStrip ctrlCommit 0.7;

		// Spawn pour le fade-out de cette notification
		[A3PL_notifControlText, A3PL_notifControlStrip, _text] spawn {
			disableSerialization;
			params ["_idcText", "_idcStrip", "_notifText"];

			private _ctrlText = (findDisplay 46) displayCtrl _idcText;
			private _ctrlStrip = (findDisplay 46) displayCtrl _idcStrip;

			uiSleep 7;

			if (!isNull _ctrlText) then {
				_ctrlText ctrlSetFade 1;
				_ctrlText ctrlCommit 1;
			};
			if (!isNull _ctrlStrip) then {
				_ctrlStrip ctrlSetFade 1;
				_ctrlStrip ctrlCommit 1;
			};

			uiSleep 0.5;

			if (!isNull _ctrlText) then { ctrlDelete _ctrlText };
			if (!isNull _ctrlStrip) then { ctrlDelete _ctrlStrip };

			A3PL_activeNotifControl = A3PL_activeNotifControl - [[_idcText, _idcStrip]];
			A3PL_eventNotifMessages = A3PL_eventNotifMessages - [_notifText];

			if (count A3PL_activeNotifControl isEqualTo 0) then {
				A3PL_notifControlText = 30000;
				A3PL_notifControlStrip = 30001;
			};
		};

		A3PL_activeNotifControl pushBack [A3PL_notifControlText, A3PL_notifControlStrip];
		A3PL_notifControlText = A3PL_notifControlText + 10;
		A3PL_notifControlStrip = A3PL_notifControlStrip + 10;

		if (count A3PL_activeNotifControl <= 2) then {
			if (_sound != "") then { playSound _sound };
		};

		// Délai entre les notifications pour éviter la surcharge
		uiSleep 0.7;
	};

	A3PL_notifProcessorRunning = false;
}] call compile_Global;

//["configName",format["description %1",_var],"titre"] call A3PL_Notification_New;
//["configName",format["description %1",_amount]] remoteExec ["A3PL_Notification_New",_player];
['A3PL_Notification_New', {
	_configName = [_this,0,"",[""]] call BIS_fnc_param;
	_description = [_this,1,"",[""]] call BIS_fnc_param;
	_title = [_this,2,"",[""]] call BIS_fnc_param;

	_cfgNotification = (missionConfigFile >> "CfgNotification");
	_cfgCurrent = (_cfgNotification >> "Patterns" >> _configName);

	if (!isClass(_cfgCurrent)) exitWith {
		diag_log format["Error: Config %1 of CfgNotification >> Patterns is not exist.", _configName];
	};


	_color = getArray(_cfgCurrent >> "color");
	_sound = getText(_cfgCurrent >> "sound");
	_defaultTitle = getText(_cfgCurrent >> "defaultTitle") call A3PL_LocalizeConfig;

	if (_title == "") then {
		_title = _defaultTitle;
	};

	[_title, _description, _color, _sound] spawn A3PL_Notification_Show;
}] call compile_Global;

['A3PL_Notifications_Tutorial', {
    private ['_msg', '_color', '_title', '_final', '_i'];

    _msg = param [0,""];
    _color = param [1,Color_Red];

    _i = 0;
    _title = ("STR_A3PL_Notifications_Tutorials" call A3PL_Localize);
    _final = "";
    Player_TutorialNotifications = [[_msg,_color]] + Player_TutorialNotifications;

    {
        if(_i <= 1) then {
            _final = format["<br /><br /><t size='1.2' align='center' color='%2'>%1<br/>____________</t>", (_x select 0), (_x select 1)] + _final;

            _i = _i + 1;
        };
    } forEach Player_TutorialNotifications;

    hint parseText (_title + _final);
    if((count(Player_TutorialNotifications)) > 1) then {
        Player_TutorialNotifications deleteAt 2;
    };
}] call compile_Global;

['A3PL_Notifications_doCallIn', {
	disableSerialization;

    if(isNil "messagecallin_active") exitWith {};

    if !(alive player) exitWith {};

    for "_i" from 0 to 1 step 0 do {
        if(!messagecallin_active) exitwith {
            11 cutRsc ["RSC_DOCALLPOPUP","PLAIN"];
            private _POPUPCLASS1 = uiNameSpace getVariable ["RSC_DOCALLPOPUP",displayNull];
            messagecallin_active = true;
            private _POPUP = _POPUPCLASS1 displayCtrl 13451;
            _POPUP ctrlSetStructuredText parseText "<img size='2.8' image='\A3PL_Common\GUI\newphone\ALF_CallIn.paa'/>";
            uiSleep 6;
            messagecallin_active = false;
        };
        uiSleep 0.05;
    };
}] call compile_Global;

['A3PL_Notifications_do911Call', {
	disableSerialization;
    params[
        ["_title","",[""]],
        ["_message","",[""]]
    ];
    if !(alive player) exitWith {};
    if (_title isEqualTo "" OR {_message isEqualTo ""}) exitWith {};
    if (isNil "message1_copactive" OR {isNil "message2_copactive"} OR {isNil "message3_copactive"} OR {isNil "message4_copactive"}) exitWith {};

    for "_i" from 0 to 1 step 0 do {
        if(!message1_copactive) exitwith {
            21 cutRsc ["RSC_DOMEDCALL1","PLAIN"];
            private _POPUPCLASS1 = uiNameSpace getVariable ["RSC_DOMEDCALL1",displayNull];
            message1_copactive = true;
            private _POPUP = _POPUPCLASS1 displayCtrl 1693311;
            private _POPUP2 = _POPUPCLASS1 displayCtrl 169331;
            _POPUP ctrlSetStructuredText parseText format["<t color='#ffffff'><t size='0.9'>%1</t><br/><t size='1'>%2</t>",_title, _message];
            uisleep 6;
            private _blah = 20;
            while{_blah > 0} do {
                private _pos = ctrlPosition _POPUP;
                private _pos2 = ctrlPosition _POPUP2;
                _POPUP ctrlSetPosition [_pos select 0, (_pos select 1) + 0.1, _pos select 2, _pos select 3];
                _POPUP2 ctrlSetPosition [_pos2 select 0, (_pos2 select 1) + 0.1, _pos2 select 2, _pos2 select 3];
                _POPUP ctrlCommit 0;
                _POPUP2 ctrlCommit 0;
                uisleep 0.05;
                _blah = _blah - 1;
            };
            message1_copactive = false;
        };

        if(!message2_copactive) exitwith {
            22 cutRsc ["RSC_DOMEDCALL2","PLAIN"];
            private _POPUPCLASS2 = uiNameSpace getVariable ["RSC_DOMEDCALL2",displayNull];
            message2_copactive = true;
            private _POPUP = _POPUPCLASS2 displayCtrl 1693321;
            private _POPUP2 = _POPUPCLASS2 displayCtrl 169332;
            _POPUP ctrlSetStructuredText parseText format["<t color='#ffffff'><t size='0.9'>%1</t><br/><t size='1'>%2</t>",_title, _message];
            uisleep 6;
            private _blah = 20;
            while{_blah > 0} do {
                private _pos = ctrlPosition _POPUP;
                private _pos2 = ctrlPosition _POPUP2;
                _POPUP ctrlSetPosition [_pos select 0, (_pos select 1) + 0.1, _pos select 2, _pos select 3];
                _POPUP2 ctrlSetPosition [_pos2 select 0, (_pos2 select 1) + 0.1, _pos2 select 2, _pos2 select 3];
                _POPUP ctrlCommit 0;
                _POPUP2 ctrlCommit 0;
                uisleep 0.05;
                _blah = _blah - 1;
            };
            message2_copactive = false;
        };

        if(!message3_copactive) exitwith {
            23 cutRsc ["RSC_DOMEDCALL3","PLAIN"];
            private _POPUPCLASS3 = uiNameSpace getVariable ["RSC_DOMEDCALL3",displayNull];
            message3_copactive = true;
            private _POPUP = _POPUPCLASS3 displayCtrl 1693331;
            private _POPUP2 = _POPUPCLASS3 displayCtrl 169333;
            _POPUP ctrlSetStructuredText parseText format["<t color='#ffffff'><t size='0.9'>%1</t><br/><t size='1'>%2</t>",_title, _message];
            uisleep 6;
            private _blah = 20;
            while{_blah > 0} do {
                private _pos = ctrlPosition _POPUP;
                private _pos2 = ctrlPosition _POPUP2;
                _POPUP ctrlSetPosition [_pos select 0, (_pos select 1) + 0.1, _pos select 2, _pos select 3];
                _POPUP2 ctrlSetPosition [_pos2 select 0, (_pos2 select 1) + 0.1, _pos2 select 2, _pos2 select 3];
                _POPUP ctrlCommit 0;
                _POPUP2 ctrlCommit 0;
                uisleep 0.05;
                _blah = _blah - 1;
            };
            message3_copactive = false;
        };
        if(!message4_copactive) exitwith {
            24 cutRsc ["RSC_DOMEDCALL4","PLAIN"];
            private _POPUPCLASS4 = uiNameSpace getVariable ["RSC_DOMEDCALL4",displayNull];
            message4_copactive = true;
            private _POPUP = _POPUPCLASS4 displayCtrl 1693341;
            private _POPUP2 = _POPUPCLASS4 displayCtrl 169334;
            _POPUP ctrlSetStructuredText parseText format["<t color='#ffffff'><t size='0.9'>%1</t><br/><t size='1'>%2</t>",_title, _message];
            uisleep 6;
            private _blah = 20;
            while{_blah > 0} do {
                private _pos = ctrlPosition _POPUP;
                private _pos2 = ctrlPosition _POPUP2;
                _POPUP ctrlSetPosition [_pos select 0, (_pos select 1) + 0.1, _pos select 2, _pos select 3];
                _POPUP2 ctrlSetPosition [_pos2 select 0, (_pos2 select 1) + 0.1, _pos2 select 2, _pos2 select 3];
                _POPUP ctrlCommit 0;
                _POPUP2 ctrlCommit 0;
                uisleep 0.05;
                _blah = _blah - 1;
            };
            message4_copactive = false;
        };
        uisleep 0.05;
    };
}] call compile_Global;

['A3PL_Notifications_doSMS', {
	disableSerialization;
	params ["_title", "_message"];

	if !(alive player) exitWith {};

	for "_i" from 0 to 1 step 0 do {
		if(!message1_smsactive) exitwith {
			21 cutRsc ["RSC_DOSMS1","PLAIN"];
			_POPUPCLASS1 = uiNameSpace getVariable ["RSC_DOSMS1",displayNull];
			message1_smsactive = true;
			_POPUP = _POPUPCLASS1 displayCtrl 1333311;
			_POPUP2 = _POPUPCLASS1 displayCtrl 133331;
			_POPUP ctrlSetStructuredText parseText format["<t color='#ffffff'><t size='0.9'>%1</t><br/><t size='1'>%2</t>",_title, _message];
			sleep 6;
			_blah = 20;
			while{_blah > 0} do {
				_pos = ctrlPosition _POPUP;
				_pos2 = ctrlPosition _POPUP2;
				_POPUP ctrlSetPosition [_pos select 0, (_pos select 1) + 0.1, _pos select 2, _pos select 3];
				_POPUP2 ctrlSetPosition [_pos2 select 0, (_pos2 select 1) + 0.1, _pos2 select 2, _pos2 select 3];
				_POPUP ctrlCommit 0;
				_POPUP2 ctrlCommit 0;
				uisleep 0.05;
				_blah = _blah - 1;
			};
			message1_smsactive = false;
		};

		if(!message2_smsactive) exitwith {
			22 cutRsc ["RSC_DOSMS2","PLAIN"];
			_POPUPCLASS2 = uiNameSpace getVariable ["RSC_DOSMS2",displayNull];
			message2_smsactive = true;
			_POPUP = _POPUPCLASS2 displayCtrl 1333321;
			_POPUP2 = _POPUPCLASS2 displayCtrl 133332;
			_POPUP ctrlSetStructuredText parseText format["<t color='#ffffff'><t size='0.9'>%1</t><br/><t size='1'>%2</t>",_title, _message];
			sleep 6;
			_blah = 20;
			while{_blah > 0} do {
				_pos = ctrlPosition _POPUP;
				_pos2 = ctrlPosition _POPUP2;
				_POPUP ctrlSetPosition [_pos select 0, (_pos select 1) + 0.1, _pos select 2, _pos select 3];
				_POPUP2 ctrlSetPosition [_pos2 select 0, (_pos2 select 1) + 0.1, _pos2 select 2, _pos2 select 3];
				_POPUP ctrlCommit 0;
				_POPUP2 ctrlCommit 0;
				uisleep 0.05;
				_blah = _blah - 1;
			};
			message2_smsactive = false;
		};

		if(!message3_smsactive) exitwith {
			23 cutRsc ["RSC_DOSMS3","PLAIN"];
			_POPUPCLASS3 = uiNameSpace getVariable ["RSC_DOSMS3",displayNull];
			message3_smsactive = true;
			_POPUP = _POPUPCLASS3 displayCtrl 1333331;
			_POPUP2 = _POPUPCLASS3 displayCtrl 133333;
			_POPUP ctrlSetStructuredText parseText format["<t color='#ffffff'><t size='0.9'>%1</t><br/><t size='1'>%2</t>",_title, _message];
			sleep 6;
			_blah = 20;
			while{_blah > 0} do {
				_pos = ctrlPosition _POPUP;
				_pos2 = ctrlPosition _POPUP2;
				_POPUP ctrlSetPosition [_pos select 0, (_pos select 1) + 0.1, _pos select 2, _pos select 3];
				_POPUP2 ctrlSetPosition [_pos2 select 0, (_pos2 select 1) + 0.1, _pos2 select 2, _pos2 select 3];
				_POPUP ctrlCommit 0;
				_POPUP2 ctrlCommit 0;
				uisleep 0.05;
				_blah = _blah - 1;
			};
			message3_smsactive = false;
		};
		if(!message4_smsactive) exitwith {
			24 cutRsc ["RSC_DOSMS4","PLAIN"];
			_POPUPCLASS4 = uiNameSpace getVariable ["RSC_DOSMS4",displayNull];
			message4_smsactive = true;
			_POPUP = _POPUPCLASS4 displayCtrl 1333341;
			_POPUP2 = _POPUPCLASS4 displayCtrl 133334;
			_POPUP ctrlSetStructuredText parseText format["<t color='#ffffff'><t size='0.9'>%1</t><br/><t size='1'>%2</t>",_title, _message];
			sleep 6;
			_blah = 20;
			while{_blah > 0} do {
				_pos = ctrlPosition _POPUP;
				_pos2 = ctrlPosition _POPUP2;
				_POPUP ctrlSetPosition [_pos select 0, (_pos select 1) + 0.1, _pos select 2, _pos select 3];
				_POPUP2 ctrlSetPosition [_pos2 select 0, (_pos2 select 1) + 0.1, _pos2 select 2, _pos2 select 3];
				_POPUP ctrlCommit 0;
				_POPUP2 ctrlCommit 0;
				uisleep 0.05;
				_blah = _blah - 1;
			};
			message4_smsactive = false;
		};
		sleep 0.05;
	};
}] call compile_Global;

['A3PL_Notifications_doTwitter', {
	disableSerialization;
	params ["_title", "_message"];

	if !(alive player) exitWith {};

	for "_i" from 0 to 1 step 0 do {
		if(!A3PL_Message1_Twitter_active) exitwith {
			21 cutRsc ["RSC_DOTWITTER1","PLAIN"];
			_POPUPCLASS1 = uiNameSpace getVariable ["RSC_DOTWITTER1",displayNull];
			A3PL_Message1_Twitter_active = true;
			_POPUP = _POPUPCLASS1 displayCtrl 1433311;
			_POPUP2 = _POPUPCLASS1 displayCtrl 143331;
			_POPUP ctrlSetStructuredText parseText format["<t color='#ffffff'><t size='0.9'>%1</t><br/><t size='1'>%2</t>",_title, _message];
			uiSleep 6;
			_blah = 20;
			while{_blah > 0} do {
				_pos = ctrlPosition _POPUP;
				_pos2 = ctrlPosition _POPUP2;
				_POPUP ctrlSetPosition [_pos select 0, (_pos select 1) + 0.1, _pos select 2, _pos select 3];
				_POPUP2 ctrlSetPosition [_pos2 select 0, (_pos2 select 1) + 0.1, _pos2 select 2, _pos2 select 3];
				_POPUP ctrlCommit 0;
				_POPUP2 ctrlCommit 0;
				uiSleep 0.05;
				_blah = _blah - 1;
			};
			A3PL_Message1_Twitter_active = false;
		};

		if(!A3PL_Message2_Twitter_active) exitwith {
			22 cutRsc ["RSC_DOTWITTER2","PLAIN"];
			_POPUPCLASS2 = uiNameSpace getVariable ["RSC_DOTWITTER2",displayNull];
			A3PL_Message2_Twitter_active = true;
			_POPUP = _POPUPCLASS2 displayCtrl 1433321;
			_POPUP2 = _POPUPCLASS2 displayCtrl 153332;
			_POPUP ctrlSetStructuredText parseText format["<t color='#ffffff'><t size='0.9'>%1</t><br/><t size='1'>%2</t>",_title, _message];
			uiSleep 15;
			_blah = 20;
			while{_blah > 0} do {
				_pos = ctrlPosition _POPUP;
				_pos2 = ctrlPosition _POPUP2;
				_POPUP ctrlSetPosition [_pos select 0, (_pos select 1) + 0.1, _pos select 2, _pos select 3];
				_POPUP2 ctrlSetPosition [_pos2 select 0, (_pos2 select 1) + 0.1, _pos2 select 2, _pos2 select 3];
				_POPUP ctrlCommit 0;
				_POPUP2 ctrlCommit 0;
				uisleep 0.05;
				_blah = _blah - 1;
			};
			A3PL_Message2_Twitter_active = false;
		};

		if(!A3PL_Message3_Twitter_active) exitwith {
			23 cutRsc ["RSC_DOTWITTER3","PLAIN"];
			_POPUPCLASS3 = uiNameSpace getVariable ["RSC_DOTWITTER3",displayNull];
			A3PL_Message3_Twitter_active = true;
			_POPUP = _POPUPCLASS3 displayCtrl 1633331;
			_POPUP2 = _POPUPCLASS3 displayCtrl 173333;
			_POPUP ctrlSetStructuredText parseText format["<t color='#ffffff'><t size='0.9'>%1</t><br/><t size='1'>%2</t>",_title, _message];
			uiSleep 15;
			_blah = 20;
			while{_blah > 0} do {
				_pos = ctrlPosition _POPUP;
				_pos2 = ctrlPosition _POPUP2;
				_POPUP ctrlSetPosition [_pos select 0, (_pos select 1) + 0.1, _pos select 2, _pos select 3];
				_POPUP2 ctrlSetPosition [_pos2 select 0, (_pos2 select 1) + 0.1, _pos2 select 2, _pos2 select 3];
				_POPUP ctrlCommit 0;
				_POPUP2 ctrlCommit 0;
				uisleep 0.05;
				_blah = _blah - 1;
			};
			A3PL_Message3_Twitter_active = false;
		};
		if(!A3PL_Message4_Twitter_active) exitwith {
			24 cutRsc ["RSC_DOTWITTER4","PLAIN"];
			_POPUPCLASS4 = uiNameSpace getVariable ["RSC_DOTWITTER4",displayNull];
			A3PL_Message4_Twitter_active = true;
			_POPUP = _POPUPCLASS4 displayCtrl 1833341;
			_POPUP2 = _POPUPCLASS4 displayCtrl 193334;
			_POPUP ctrlSetStructuredText parseText format["<t color='#ffffff'><t size='0.9'>%1</t><br/><t size='1'>%2</t>",_title, _message];
			uiSleep 15;
			_blah = 20;
			while{_blah > 0} do {
				_pos = ctrlPosition _POPUP;
				_pos2 = ctrlPosition _POPUP2;
				_POPUP ctrlSetPosition [_pos select 0, (_pos select 1) + 0.1, _pos select 2, _pos select 3];
				_POPUP2 ctrlSetPosition [_pos2 select 0, (_pos2 select 1) + 0.1, _pos2 select 2, _pos2 select 3];
				_POPUP ctrlCommit 0;
				_POPUP2 ctrlCommit 0;
				uisleep 0.05;
				_blah = _blah - 1;
			};
			A3PL_Message4_Twitter_active = false;
		};
		uiSleep 0.05;
	};
}] call compile_Global;

['A3PL_Notifications_doEmail', {
	disableSerialization;
	params [
		["_sender", "", [""]],
		["_subject", "", [""]],
		["_preview", "", [""]]
	];

	if !(alive player) exitWith {};
	if (_sender isEqualTo "" || {_subject isEqualTo ""}) exitWith {};

	// Initialize email notification variables if needed
	if (isNil "A3PL_Message1_Email_active") then { A3PL_Message1_Email_active = false; };
	if (isNil "A3PL_Message2_Email_active") then { A3PL_Message2_Email_active = false; };
	if (isNil "A3PL_Message3_Email_active") then { A3PL_Message3_Email_active = false; };
	if (isNil "A3PL_Message4_Email_active") then { A3PL_Message4_Email_active = false; };

	// Format the display text
	private _displayText = if (_preview isEqualTo "") then {
		format ["<t color='#ffffff'><t size='0.85' font='PuristaBold'>%1</t><br/><t size='0.9'>%2</t>", _sender, _subject]
	} else {
		format ["<t color='#ffffff'><t size='0.85' font='PuristaBold'>%1</t><br/><t size='0.9'>%2</t><br/><t size='0.8' color='#a0a0a0'>%3</t>", _sender, _subject, _preview]
	};

	for "_i" from 0 to 1 step 0 do {
		if(!A3PL_Message1_Email_active) exitwith {
			25 cutRsc ["RSC_DOEMAIL1","PLAIN"];
			private _POPUPCLASS1 = uiNameSpace getVariable ["RSC_DOEMAIL1",displayNull];
			A3PL_Message1_Email_active = true;
			private _POPUP = _POPUPCLASS1 displayCtrl 1633311;
			private _POPUP2 = _POPUPCLASS1 displayCtrl 163331;
			_POPUP ctrlSetStructuredText parseText _displayText;
			playSound "FD_Timer_F";
			uiSleep 8;
			private _blah = 20;
			while{_blah > 0} do {
				private _pos = ctrlPosition _POPUP;
				private _pos2 = ctrlPosition _POPUP2;
				_POPUP ctrlSetPosition [_pos select 0, (_pos select 1) + 0.1, _pos select 2, _pos select 3];
				_POPUP2 ctrlSetPosition [_pos2 select 0, (_pos2 select 1) + 0.1, _pos2 select 2, _pos2 select 3];
				_POPUP ctrlCommit 0;
				_POPUP2 ctrlCommit 0;
				uiSleep 0.05;
				_blah = _blah - 1;
			};
			A3PL_Message1_Email_active = false;
		};

		if(!A3PL_Message2_Email_active) exitwith {
			26 cutRsc ["RSC_DOEMAIL2","PLAIN"];
			private _POPUPCLASS2 = uiNameSpace getVariable ["RSC_DOEMAIL2",displayNull];
			A3PL_Message2_Email_active = true;
			private _POPUP = _POPUPCLASS2 displayCtrl 1633321;
			private _POPUP2 = _POPUPCLASS2 displayCtrl 163332;
			_POPUP ctrlSetStructuredText parseText _displayText;
			uiSleep 8;
			private _blah = 20;
			while{_blah > 0} do {
				private _pos = ctrlPosition _POPUP;
				private _pos2 = ctrlPosition _POPUP2;
				_POPUP ctrlSetPosition [_pos select 0, (_pos select 1) + 0.1, _pos select 2, _pos select 3];
				_POPUP2 ctrlSetPosition [_pos2 select 0, (_pos2 select 1) + 0.1, _pos2 select 2, _pos2 select 3];
				_POPUP ctrlCommit 0;
				_POPUP2 ctrlCommit 0;
				uiSleep 0.05;
				_blah = _blah - 1;
			};
			A3PL_Message2_Email_active = false;
		};

		if(!A3PL_Message3_Email_active) exitwith {
			27 cutRsc ["RSC_DOEMAIL3","PLAIN"];
			private _POPUPCLASS3 = uiNameSpace getVariable ["RSC_DOEMAIL3",displayNull];
			A3PL_Message3_Email_active = true;
			private _POPUP = _POPUPCLASS3 displayCtrl 1633331;
			private _POPUP2 = _POPUPCLASS3 displayCtrl 163333;
			_POPUP ctrlSetStructuredText parseText _displayText;
			uiSleep 8;
			private _blah = 20;
			while{_blah > 0} do {
				private _pos = ctrlPosition _POPUP;
				private _pos2 = ctrlPosition _POPUP2;
				_POPUP ctrlSetPosition [_pos select 0, (_pos select 1) + 0.1, _pos select 2, _pos select 3];
				_POPUP2 ctrlSetPosition [_pos2 select 0, (_pos2 select 1) + 0.1, _pos2 select 2, _pos2 select 3];
				_POPUP ctrlCommit 0;
				_POPUP2 ctrlCommit 0;
				uiSleep 0.05;
				_blah = _blah - 1;
			};
			A3PL_Message3_Email_active = false;
		};

		if(!A3PL_Message4_Email_active) exitwith {
			28 cutRsc ["RSC_DOEMAIL4","PLAIN"];
			private _POPUPCLASS4 = uiNameSpace getVariable ["RSC_DOEMAIL4",displayNull];
			A3PL_Message4_Email_active = true;
			private _POPUP = _POPUPCLASS4 displayCtrl 1633341;
			private _POPUP2 = _POPUPCLASS4 displayCtrl 163334;
			_POPUP ctrlSetStructuredText parseText _displayText;
			uiSleep 8;
			private _blah = 20;
			while{_blah > 0} do {
				private _pos = ctrlPosition _POPUP;
				private _pos2 = ctrlPosition _POPUP2;
				_POPUP ctrlSetPosition [_pos select 0, (_pos select 1) + 0.1, _pos select 2, _pos select 3];
				_POPUP2 ctrlSetPosition [_pos2 select 0, (_pos2 select 1) + 0.1, _pos2 select 2, _pos2 select 3];
				_POPUP ctrlCommit 0;
				_POPUP2 ctrlCommit 0;
				uiSleep 0.05;
				_blah = _blah - 1;
			};
			A3PL_Message4_Email_active = false;
		};
		uiSleep 0.05;
	};
}] call compile_Global;

['A3PL_Notifications_doGPS', {
	disableSerialization;
	params[
		["_image","",[""]],
		["_distance","",[""]],
		["_texte","",[""]]
	];
	if(_image isEqualTo "" OR {_distance isEqualTo ""} OR {_texte isEqualTo ""}) exitWith {};

	private _png = "";
	switch (_image) do {
		case "D" : {_png = "\A3PL_Common\GUI\player_hud\d.paa"};
		case "DT" : {_png = "\A3PL_Common\GUI\player_hud\dt.paa"};
		case "G" : {_png = "\A3PL_Common\GUI\player_hud\g.paa"};
		case "RP" : {_png = "\A3PL_Common\GUI\player_hud\rp.paa"};
		case "TD" : {_png = "\A3PL_Common\GUI\player_hud\td.paa"};
	};

	1 cutRsc ["RSC_DOGPS","PLAIN"];
	private _POPUPCLASS1 = uiNameSpace getVariable ["RSC_DOGPS",displayNull];
	private _POPUP = _POPUPCLASS1 displayCtrl 13450;
	_POPUP ctrlSetStructuredText parseText format["<img align='center' size='7' image='%1'/><br/><t align='center' shadow='1' size='4'>%2</t><br/><t align='center' shadow='1' size='1.2'>%3</t>",_png ,_distance ,_texte];
}] call compile_Global;
