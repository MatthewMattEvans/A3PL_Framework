/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Twitter_Init", {
	for "_i" from 0 to 7 do {
		A3PL_TwitterMsg_Array set [_i, ["", -1]];
	};
	[] spawn {
		if (isDedicated) exitWith {};
		waitUntil {!isNull (findDisplay 46)};
		736713 cutRsc ["Dialog_HUD_Twitter", "PLAIN"];
		waitUntil {!isNil "A3PL_Twitter_MsgDisplay"};
		call A3PL_Twitter_MsgDisplay;
	};
}] call compile_Global;

["A3PL_Twitter_Send", {
	private _assignedItems = assignedItems player;
	private _msg = ctrlText 682583;
	{
		if ((_x find "a3pl_sony") >= 0) then {
			_msg = ctrlText 45179;
		}
	} forEach _assignedItems;
	
	if (count _msg < 1) exitwith {};
	if (count _msg > 280) exitwith { [("STR_A3PL_Twitter_CharactersMax" call A3PL_Localize),Color_Red] call A3PL_Notification; };
	if (!(profilenamespace getVariable ["A3PL_Twitter_Enabled",true])) exitwith {[("STR_A3PL_Twitter_isDeactivated" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	closedialog 0;

	private _twitterTag = player getVariable["twitterTag",["#FFFFFF","#FFFFFF","\A3PL_Common\icons\citizen.paa"]];
	private _msgcolor = _twitterTag#0;
	private _namecolor = _twitterTag#1;
	private _namepicture = _twitterTag#2;
	private _name = player getvariable ["name",(name player)];

	if (_namepicture isEqualTo "\A3PL_Common\icons\citizen.paa") then {
		switch (player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) do {
			case ("STR_Common_FIFR" call A3PL_Localize): {_namepicture = "\A3PL_Common\icons\fire.paa"; _namecolor = "#FFFFFF";};
			case ("STR_Common_FISD" call A3PL_Localize): {_namepicture = "\A3PL_Common\icons\faction_sheriff.paa"; _namecolor = "#FFFFFF";};
			case ("STR_Common_DOJ" call A3PL_Localize): {_namepicture = "\A3PL_Common\icons\faction_doj.paa"; _namecolor = "#FFFFFF";};
			case ("STR_Common_GOV" call A3PL_Localize): {_namepicture = "\A3PL_Common\icons\faction_ecc.paa"; _namecolor = "#FFFFFF";};
		};
	};

	private _messageTo = "";
	private _toDatabase = "";
	private _isCommand = false;
	private _failReason = "";
	private _tweetSuccess = false;
	private _splitted = _msg splitString " ";
	private _tweetCD = player getVariable ["lastTweet",serverTime - 15];

	private _firstMsg = toLowerANSI (_splitted#0);
	if ((_firstMsg find "/") isNotEqualTo -1) then {_isCommand = true;};

	if !(_isCommand) then {
		if (pVar_AdminTwitter) then {_tweetCD = 0;};
		if ((serverTime - _tweetCD) < 15) exitWith {_failReason = ("STR_A3PL_Twitter_YouNeedToWait" call A3PL_Localize);};
		player setVariable ["lastTweet",serverTime,true];
		_toDatabase = "logs_twitter";
		_tweetSuccess = true;
	};

	if (_tweetSuccess) exitWith {
		[_msg,_msgColor,_namePicture,_name,_nameColor,_messageTo] remoteExec ["A3PL_Twitter_NewMsg",-2];
		[(player getVariable ["character_id",""]),_msg,_msgcolor,_namepicture,_name,_namecolor,_toDatabase] remoteExec ["Server_Twitter_HandleMsg",2];
	};

	private _pBank = player getVariable ["player_bank",0];
	private _pcharID = (player getVariable ["character_id",""]);
	private _playerid = player getVariable ["db_id",-1];
	switch (_firstMsg) do {
		case "/a": {
			_messageTo = ["admin",["admin",player,player getvariable ["name",(name player)],(time + 300)]];
			_name = format [("STR_A3PL_Twitter_Help" call A3PL_Localize),_name,_playerid];
			_namecolor = "#FFFFFF";
			_msgcolor = "#FFFFFF";
			_toDatabase = "logs_twitter_helps";
			_tweetSuccess = true;
		};
		case "/r": {
			if !(pVar_AdminTwitter) exitWith {[("STR_A3PL_Twitter_OnlyAdminCanUseThisCommand" call A3PL_Localize),"#a3ffc1","",("STR_A3PL_Twitter_Commands" call A3PL_Localize),"#42f47d",""] spawn A3PL_Twitter_NewMsg;};
			_nameColor = "#FFFFFF";
			_msgColor = "#FFFFFF";
			_namePicture = "";
			private _found = false;
			private _person = [];
			private _index = -1;
			private _nameSearch = toLowerANSI ([_splitted#1,_splitted#2] joinString " ");
			{
				_nameCheck = toLowerANSI (_x#2);
				if (_nameCheck isEqualTo _nameSearch) exitWith {
					_found = true;
					_person = _x;
					_index = _forEachIndex;
				};
			} forEach A3PL_Twitter_ReplyArr;

			if (!_found) exitwith {[("STR_A3PL_Twitter_ThisPersonDontContactYou" call A3PL_Localize),"#a3ffc1","",("STR_A3PL_Twitter_Commands" call A3PL_Localize),"#42f47d",""] spawn A3PL_Twitter_NewMsg;};
			{if (_person#1 isEqualTo _x) exitwith {_found = false;};} foreach allplayers;
			if (_found) exitwith {
				[("STR_A3PL_Twitter_ThisPersonIsNotAvailable" call A3PL_Localize),"#a3ffc1","",("STR_A3PL_Twitter_Commands" call A3PL_Localize),"#42f47d",""] spawn A3PL_Twitter_NewMsg;
				A3PL_Twitter_ReplyArr deleteAt _index;
			};
			_messageTo = ["reply",_person];
			_name = format [("STR_A3PL_Twitter_AnswerFromTo" call A3PL_Localize),_name,(_person#2)];
			_toDatabase = "logs_twitter_helps";
			_tweetSuccess = true;
		};
		case "/h": {
			[("STR_A3PL_Twitter_CommandsDescription" call A3PL_Localize),"#a3ffc1","",("STR_A3PL_Twitter_Commands" call A3PL_Localize),"#42f47d",""] spawn A3PL_Twitter_NewMsg;
		};
		case "/ad": {
			if (_pBank < Twitter_AD_Price) exitWith {_failReason = ("STR_A3PL_Twitter_YouDontHaveMoney" call A3PL_Localize);};
			_name = format ["%1",_name];
			if !(isNil "A3PL_Phone_Number") then {_name = format ["%1 [%2]",_name,A3PL_Phone_Number];};
			_nameColor = "#FFFFFF";
			_msgColor = "#FFFFFF";
			[("STR_Common_FederalReserve" call A3PL_Localize),Twitter_AD_Price] remoteExec ["Server_Government_AddBalance",2];
			_toDatabase = "logs_twitter";
			_tweetSuccess  = true;
		};
		case "/adc": {
			if !([_pcharID] call A3PL_Config_InCompany) exitWith {_failReason = ("STR_Common_NotInCompany" call A3PL_Localize);};
			private _cID = [_pcharID] call A3PL_Config_GetCompanyID;
			private _hasPerm = [_cID,"twitter",_pcharID] call A3FL_Config_GetCompanyPermissions;
			private _isBoss = [_pcharID] call A3PL_Config_IsCompanyBoss;
			if ((!_hasPerm) || (!_isBoss)) exitWith {_failReason = ("STR_A3PL_Twitter_YouDoNotHavePermission" call A3PL_Localize);};
			private _cName = [_cID,"name"] call A3PL_Config_GetCompanyData;
			_name = format ["%1",_cName];
			if !(isNil "A3PL_Phone_Number") then {_name = format ["%1 [%2]",_name,A3PL_Phone_Number];};
			_nameColor = "#FFFFFF";
			_msgColor = "#FFFFFF";
			_namePicture = "\A3PL_Common\icons\citizen.paa";
			[_cID, -Twitter_ADC_Price, ("STR_A3PL_Twitter_Adversiting" call A3PL_Localize)] remoteExec ["Server_Company_SetBank",2];
			[("STR_Common_FederalReserve" call A3PL_Localize),Twitter_ADC_Price] remoteExec ["Server_Government_AddBalance",2];
			_toDatabase = "logs_twitter";
			_tweetSuccess = true;
		};
		case "/adf": {
			private _fName = "";
			private _pJob = player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
			if !(_pJob IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) exitWith {_failReason = ("STR_A3PL_Twitter_YoureNotInFaction" call A3PL_Localize);};
			switch (_pJob) do {
				case ("STR_Common_FIFR" call A3PL_Localize): {_fName = ("STR_Common_FireDepartment" call A3PL_Localize);_namepicture = "\A3PL_Common\icons\fire.paa"; _namecolor = "#FFFFFF";_msgcolor = "#FFFFFF";[("STR_Common_FireDepartment" call A3PL_Localize),-Twitter_ADF_Price] remoteExec ["Server_Government_AddBalance",2];};
				case ("STR_Common_FISD" call A3PL_Localize): {_fName = ("STR_Common_SheriffsDepartment" call A3PL_Localize);_namepicture = "\A3PL_Common\icons\faction_sheriff.paa"; _namecolor = "#FFFFFF";_msgcolor = "#FFFFFF";[("STR_Common_SheriffsDepartment" call A3PL_Localize),-Twitter_ADF_Price] remoteExec ["Server_Government_AddBalance",2];};
				case ("STR_Common_DOJ" call A3PL_Localize): {_fName = ("STR_Common_DepartmentOfJustice" call A3PL_Localize);_namepicture = "\A3PL_Common\icons\faction_doj.paa"; _namecolor = "#FFFFFF";_msgcolor = "#FFFFFF";[("STR_Common_DepartmentOfJustice" call A3PL_Localize),-Twitter_ADF_Price] remoteExec ["Server_Government_AddBalance",2];};
				case ("STR_Common_GOV" call A3PL_Localize): {_fName = ("STR_Common_Government" call A3PL_Localize);_namepicture = "\A3PL_Common\icons\faction_doj.paa"; _namecolor = "#FFFFFF";_msgcolor = "#FFFFFF";[("STR_Common_Government" call A3PL_Localize),-Twitter_ADF_Price] remoteExec ["Server_Government_AddBalance",2];};
				default {};
		 	};
			_name = format [("STR_A3PL_Twitter_PSA" call A3PL_Localize),_fName];
			[("STR_Common_FederalReserve" call A3PL_Localize),Twitter_ADF_Price] remoteExec ["Server_Government_AddBalance",2];
			_toDatabase = "logs_twitter";
			_tweetSuccess = true;
		};
		case "/dn": {
			if (_pBank < Twitter_DN_Price) exitWith {_failReason = ("STR_A3PL_Twitter_YouDontHaveMoney" call A3PL_Localize);};
				_name = format [("STR_A3PL_Twitter_Darknet" call A3PL_Localize),A3PL_Phone_Number];
				_messageTo = ["darknet",["darknet",player,player getvariable ["name",(name player)],(time + 300)]];
				_nameColor = "#FFFFFF";
				_msgColor = "#FFFFFF";
				_toDatabase = "logs_twitter_darknet";
				_tweetSuccess = true;
				player setVariable ["player_bank",(_pBank - Twitter_DN_Price),true];
		};
		default {_failReason = ("STR_A3PL_Twitter_Guide" call A3PL_Localize);};
	};

	if (_failReason isNotEqualTo "") exitWith {
		private _exitMsg = switch (_failReason) do {
			case ("STR_A3PL_Twitter_YouNeedToHavePhoneNumber" call A3PL_Localize): {("STR_A3PL_Twitter_YouNeedToHavePhoneNumberToTweet" call A3PL_Localize);};
			case ("STR_A3PL_Twitter_YouNeedToHavePhone" call A3PL_Localize): {("STR_A3PL_Twitter_YouNeedToHavePhoneToTweet" call A3PL_Localize)};
			case ("STR_A3PL_Twitter_NeedToWait" call A3PL_Localize): {("STR_A3PL_Twitter_NeedToWait15MnTOSendNewTweet" call A3PL_Localize)};
			case ("STR_A3PL_Twitter_Guide" call A3PL_Localize): {"Commande inconnue! Utilisez /h pour avoir de l'aide";};
			case ("STR_A3PL_Twitter_YouDontHaveMoney" call A3PL_Localize): {("STR_A3PL_Twitter_DontHaveMoneyDesc" call A3PL_Localize);};
			case ("STR_Common_NotInCompany" call A3PL_Localize): {("STR_Common_NotInCompany" call A3PL_Localize);};
			case ("STR_A3PL_Twitter_YouDoNotHavePermission" call A3PL_Localize): {("STR_A3PL_Twitter_YouDoNotHavePermission" call A3PL_Localize);};
			case ("STR_A3PL_Twitter_YoureNotInFaction" call A3PL_Localize): {("STR_A3PL_Twitter_YoureNotInFaction" call A3PL_Localize);};
			default {"";};
		};
		[_exitMsg,Color_Red] call A3PL_Notification;
	};

	if (_tweetSuccess) then {
		_splitted deleteAt 0;
		_msg = _splitted joinString " ";
		[_msg,_msgColor,_namePicture,_name,_nameColor,_messageTo] remoteExec ["A3PL_Twitter_NewMsg",-2];
	};
	if (_toDatabase isNotEqualTo "") then {
		[(player getVariable ["character_id",""]),_msg,_msgcolor,_namepicture,_name,_namecolor,_toDatabase] remoteExec ["Server_Twitter_HandleMsg", 2];
	};
}] call compile_Global;

["A3PL_Twitter_Emojis", {
	params [["_msg","",[""]]];
	private _binds = Twitter_Emojis;

	for "_i" from 0 to (count _binds)-1 do {
		private _toFind = _binds#_i#0;
		private _replaceBy = format["<img size='1' color='#FFFFFF' image='A3PL_Common\GUI\phone\smileys\%1.paa'/>",_binds#_i#1];
		private _numberFind = _msg find _toFind;
		while {_numberFind isNotEqualTo -1} do {
			private _numberFind = _msg find _toFind;
			if (_numberFind isEqualTo -1) exitWith {};
			_splitMessage = _msg splitString "";
			_splitMessage deleteRange [(_numberFind +1), count(_toFind) -1];
			_splitMessage set [_numberFind, _replaceBy];
			_msg = _splitMessage joinString "";
		};
	};
	_msg;
}] call compile_Global;

["A3PL_Twitter_NewMsg", {
	params [
		["_msg","",[""]],
		["_msgColor","",[""]],
		["_namePicture","",[""]],
		["_name","",[""]],
		["_nameColor","",[""]],
		["_msgTo","",["",[]]]
	];
	disableSerialization;

	if (isDedicated) exitWith {};
	if (isNil "A3PL_TwitterMsg_Array") exitWith {};
	if (!(profilenamespace getVariable ["A3PL_Twitter_Enabled",true])) exitwith {};

	private _msgduration = 20;
	private _maxmsg = (8 - 1);

	private _cancelAction = true;
	if (_msgTo isEqualType []) then {
		switch (_msgTo#0) do {
			case "admin": {
				if (pVar_AdminTwitter) then {_cancelAction = false;playSound "HintExpand";};
				A3PL_Twitter_ReplyArr = (missionNameSpace getVariable ["A3PL_Twitter_ReplyArr",[]]) + [(_msgTo#1)];
			};
			case "darknet": {
				if !(player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) then {_cancelAction = false;};
				A3PL_Twitter_ReplyArr = (missionNameSpace getVariable ["A3PL_Twitter_ReplyArr",[]]) + [(_msgTo select 1)];
			};
			case "reply": {
				if (player isEqualTo _msgTo#1#1) then {_cancelAction = false;};
				if ((_msgTo#1#0 isEqualTo "admin") && pVar_AdminTwitter) then {_cancelAction = false;};
			};
		};
	};

	if ((_msgTo isEqualType "") && (_msgTo isEqualTo "")) then {_cancelAction = false;};

	if (_cancelAction) exitwith {};

	_msg = [_msg] call A3FL_Twitter_StripChars;
	_msg = [_msg] call A3PL_Twitter_Emojis;
	private _logo = "";
	private _nametext = "";
	private _logname = "";
	private _logchat = "";
	private _messagelog = _msg;


	if (_namePicture isNotEqualTo "") then {
		_logo = format ["<t size='0.5'><img image='%1' /> </t>",_namePicture];
	};

	if (_name isNotEqualTo "") then {
		_nametext = format ["<t color='%1'>%2: </t>",_nameColor,_name];
		_logname = format ["%1",_name];
	};

	if ((_msgColor find "#") isNotEqualTo 0) then {
		switch (_msgColor) do {
			case "red": {_msgColor = "#FF0000";};
			case "green": {_msgColor = "#00DB07";};
			default {_msgColor = "#FFFFFF";};
		};
	};

	_messageinfo = format ["<t color='%1'>%2</t>",_msgColor,_msg];

	if ((count _logname) isEqualTo 0) then {
		_logchat = format ["%1",_messagelog];
	} else {
		_logchat = format ["%1: %2",_logname,_messagelog];
	};

	A3PL_TwitterChatLog = A3PL_TwitterChatLog + [[_namePicture,_logchat]];
	A3PL_TwitterChatPhone = A3PL_TwitterChatPhone + [[_name,_messagelog,_nameColor]];
	while {count A3PL_TwitterChatLog > 50} do {
		A3PL_TwitterChatLog set [0,"delete"];
		A3PL_TwitterChatLog = A3PL_TwitterChatLog - ["delete"];
	};

	[format["<t color='%1'>%2</t>",_nameColor,_name],_messageinfo] spawn A3PL_Notifications_doTwitter;
	A3PL_Player_Phone_NewTweet = true;
}] call compile_Global;

["A3PL_Twitter_MsgDisplay", {
	if (isDedicated) exitWith {};
	if (isNil "A3PL_TwitterMsg_Array") exitWith {};
	disableSerialization;

	private _block = "";
	for "_i" from 0 to 7 do
	{
		private _text = (A3PL_TwitterMsg_Array#_i)#0;
		if (_text isNotEqualTo "") then {
			_block = format["%1%2<br/>",_block,_text];
		};
	};
	((uiNamespace getVariable ["Dialog_HUD_Twitter", displayNull]) displayCtrl 100) ctrlSetStructuredText parseText _block;
}] call compile_Global;

["A3FL_Twitter_StripChars", {
	params [["_msg","",[""]]];
	private _return = _msg;
	if ((_return find "&") isNotEqualTo -1) then {_return = _msg regexReplace ["&"," "];};
	_return = _return regexReplace ["<(?=([A-Za-z0-24-9]))","\ "];
	_return;
}] call compile_Global;
