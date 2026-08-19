/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
#define CONTROL_DATA(ctrl) (lbData[ctrl,lbCurSel ctrl])
#define EQUAL(condition1,condition2) condition1 isEqualTo condition2
#include "\z\tfar\addons\handhelds\script_component.hpp"

["A3PL_Phone_addContactNokia", {
	private["_display","_contactName","_contactNumber","_contact","_name","_number","_contactsList"];
	disableSerialization;
	_display = findDisplay 20000;
	_contactsList = _display displayCtrl 20011;
	_contactName = ctrlText 20015;
	_contactNumber = ctrlText 20016;

	if(_contactNumber isEqualTo "") exitWith {[("STR_A3PL_Phone_EmptyPhoneNumber" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if(_contactName isEqualTo "") exitWith {[("STR_A3PL_Phone_EmptyName" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_length = count (toArray(_contactName));
	_length2 = count (toArray(_contactNumber));
	_chrByte = toArray (_contactName);
	_chrByte2 = toArray (_contactNumber);
	_allowed = toArray("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789é_ ");
	_allowed2 = toArray("0123456789");
	if(_length > 20) exitWith {[("STR_A3PL_Phone_20CharMax" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if((_length2 != 10) && (!(_contactNumber IN ["911"]))) exitWith {[("STR_A3PL_Phone_10CharMax" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_badChar = false;
	_invalidChar = "";
	{if(!(_x in _allowed)) exitWith {_badChar = true; _invalidChar = _x;};} forEach _chrByte;
	{if(!(_x in _allowed2)) exitWith {_badChar = true; _invalidChar = _x};} forEach _chrByte2;
	if(_badChar) exitWith {[format[("STR_A3PL_Phone_CharNotAuthorizedSpecify" call A3PL_Localize),_invalidChar],Color_Red] call A3PL_Notification;};

	if(_contactNumber isEqualTo A3PL_Phone_Number) exitWith {[("STR_A3PL_Phone_YouCantCallYou" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_exit = false;

	if(count life_contacts > 0) then {
		{
			if ((_x select 1) isEqualTo _contactNumber) exitWith {_exit = true;};
		} forEach life_contacts;
	};
	if(_exit) exitWith {[("STR_A3PL_Phone_YouAlreadyHaveThisNumberInYourContacts" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_contact = [_contactName,_contactNumber];
	life_contacts pushBack _contact;

	lbClear _contactsList;
	{
		_name = _x select 0;
		_number = _x select 1;
		_contactsList lbAdd format["%1 - %2",_name,_number];
		_contactsList lbSetData [(lbSize _contactsList)-1,str(_x)];
	} forEach life_contacts;

	[life_contacts, (player getVariable ["character_id",""])] remoteExecCall ["Server_Phone_updateContactsPhone"];
}] call compile_Global;

["A3PL_Phone_callContactNokia", {
	if((lbCurSel 20011) isEqualTo -1) exitWith {[("STR_A3PL_Phone_YouNeedToSelectSomeone" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _cible = lbData[20011,lbCurSel (20011)];
	_cible = call compile format["%1", _cible];

	if(A3PL_Forfait isEqualTo 0) exitWith {[("STR_A3PL_Phone_SubscriptionFinished" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	player playActionNow "A3PL_Tel";
	//A3PL_PhoneObject = "A3PL_3310_Object" createVehicle [0,0,1000];
	if !(isNull A3PL_PhoneObject) then {
		//[A3PL_PhoneObject,false] remoteExecCall ["enableSimulationGlobal",2];
		[] spawn {
			uiSleep 0.3;
			if (vehicle player isEqualTo player) then {
				A3PL_PhoneObject attachTo [player, [0.02,0.01,0.15], "RightHandMiddle1"];
				A3PL_PhoneObject setVectorDirAndUp [[-0.21017,0.265195,-0.94101],[-0.949623,0.173499,0.260989]];
			} else {
				A3PL_PhoneObject attachTo [(vehicle player),((vehicle player) worldToModel (player modelToWorldVisual ((player selectionPosition "RightHandMiddle1") vectorAdd [0.02,0.01,0.15])))];
				A3PL_PhoneObject setVectorDirAndUp [[-0.21017,0.265195,-0.94101],[-0.949623,0.173499,0.260989]];
			};
		};
	};

	A3PL_Phone_tryCall = true;
	life_radio_connected = false;
	A3PL_Phone_CallNumber = _cible select 1;

	[A3PL_Phone_Anonyme,A3PL_Phone_Number,_cible select 1,player] remoteExec ["Server_Phone_callSystem"];

	private _hour = date select 3;
	private _min = date select 4;
	if(_min >= 0 && _min <= 9) then {_min = format["0%1", _min];};
	private _time = format["%1:%2",_hour,_min];
	private _data = [_time,false,0,_cible select 1];
	A3PL_Phone_Historique pushBack _data;

	player setVariable ["tf_unable_to_use_radio", true];

	if !(isNull (findDisplay 20000)) then {
		uiNamespace setVariable ['nokiamenu',0];
		[] call A3PL_Phone_menuNokia;
	};

	private _myRadio = call TFAR_fnc_activeSwRadio;

	for "_i" from 0 to 5 step 1 do {
		if !(A3PL_Phone_tryCall) exitWith {};
		private _alive = player getVariable["A3PL_Medical_Alive",true];
		if !(_alive) exitWith {};

		private _radios = player call TFAR_fnc_radiosList;
		if(count _radios < 1) exitWith {};
		if !([(call TFAR_fnc_activeSwRadio),_myRadio] call TFAR_fnc_isSameRadio) exitWith {};
		if ((([_myRadio,"a3pl_iphone_1"] call TFAR_fnc_isSameRadio) || {([_myRadio,"a3pl_3310_1"] call TFAR_fnc_isSameRadio)}) && {!(currentWeapon player isEqualTo "")}) exitWith {};

		playSound "phone_call";
		sleep 5;
	};
	if(A3PL_Phone_tryCall) then {[] call A3PL_Phone_resetcall;};
}] call compile_Global;

["A3PL_Phone_callCustomNokia", {
	private _numbercalling = ctrlText 200182;
	if(_numbercalling isEqualTo "") exitWith {[("STR_A3PL_Phone_EmptyPhoneNumber" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _length = count (toArray(_numbercalling));
	private _chrByte = toArray (_numbercalling);
	private _allowed = toArray("0123456789");
	if(_length > 10) exitWith {[("STR_A3PL_Phone_10CharMax" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _badChar = false;
	private _invalidChar = "";
	{if(!(_x in _allowed)) exitWith {_badChar = true; _invalidChar = _x;};} forEach _chrByte;
	if(_badChar) exitWith {[format[("STR_A3PL_Phone_CharNotAuthorizedSpecify" call A3PL_Localize),_invalidChar],Color_Red] call A3PL_Notification;};
	if !(currentWeapon player isEqualTo "") exitWith {[("STR_Common_HandsFull" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if (_numbercalling isEqualTo A3PL_Phone_Number) exitWith {[("STR_A3PL_Phone_YouCantCallYou" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if(_length < 10 && {!(_numbercalling in ["911"])}) exitWith {[("STR_A3PL_Phone_10CharMax" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if((A3PL_Forfait isEqualTo 0) && {!(_numbercalling in ["911","912","913"])}) exitWith {[("STR_A3PL_Phone_SubscriptionFinished" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if (_numbercalling in ["911"]) then {
		createDialog "A3PL_CallCenterChoice_Dialog";
		disableSerialization;

		private _display = findDisplay 458764;
		private _text = _display displayCtrl 1400;
		private _buttonSD = _display displayCtrl 1600;
		private _buttonFD = _display displayCtrl 1601;
		private _buttonDOJ = _display displayCtrl 1602;

		player setVariable ["callchoice",0,true];

		_text ctrlSetText format[("STR_A3PL_Phone_YouCalledThe911" call A3PL_Localize)];

		_buttonSD buttonSetAction "player setVariable ['callchoice',1,true];";
		_buttonFD buttonSetAction "player setVariable ['callchoice',2,true];";
		_buttonDOJ buttonSetAction "player setVariable ['callchoice',3,true];";


		private _startTime = time;
		waitUntil {
			((player getvariable "callchoice") isEqualTo 1) ||
			((player getvariable "callchoice") isEqualTo 2) ||
			((player getvariable "callchoice") isEqualTo 3) ||
			isNull _display || 
			(time - _startTime) > 19
		};

		if ((isNull _display) || ((time - _startTime) > 19)) then {
			player setVariable ['callchoice',1,true];
			[("STR_A3PL_Phone_WithoutChoice911" call A3PL_Localize), Color_Orange] call A3PL_Notification;
		};

		switch (player getVariable "callchoice") do {
			case 1: {
				closeDialog 0;
				player setVariable ["callchoice", 0, true];
				_numbercalling = "911";
			};
			case 2: {
				closeDialog 0;
				player setVariable ["callchoice", 0, true];
				_numbercalling = "912";
			};
			case 3: {
				closeDialog 0;
				player setVariable ["callchoice", 0, true];
				_numbercalling = "913";
			};
			default {
				closeDialog 0;
				player setVariable ["callchoice",0,true];
				[] call A3PL_Phone_endCall;
			};
		};
	};

	player playActionNow "A3PL_Tel";
	//A3PL_PhoneObject = "A3PL_3310_Object" createVehicle [0,0,1000];
	if !(isNull A3PL_PhoneObject) then {
		//[A3PL_PhoneObject,false] remoteExecCall ["enableSimulationGlobal",2];
		[] spawn {
			uiSleep 0.3;
			if (vehicle player isEqualTo player) then {
				A3PL_PhoneObject attachTo [player, [0.02,0.01,0.15], "RightHandMiddle1"];
				A3PL_PhoneObject setVectorDirAndUp [[-0.21017,0.265195,-0.94101],[-0.949623,0.173499,0.260989]];
			} else {
				A3PL_PhoneObject attachTo [(vehicle player),((vehicle player) worldToModel (player modelToWorldVisual ((player selectionPosition "RightHandMiddle1") vectorAdd [0.02,0.01,0.15])))];
				A3PL_PhoneObject setVectorDirAndUp [[-0.21017,0.265195,-0.94101],[-0.949623,0.173499,0.260989]];
			};
		};
	};

	A3PL_Phone_tryCall = true;
	life_radio_connected = false;
	A3PL_Phone_CallNumber = _numbercalling;

	[A3PL_Phone_Anonyme,A3PL_Phone_Number,_numbercalling,player] remoteExec ["Server_Phone_callSystem"];

	private _hour = date select 3;
	private _min = date select 4;
	if(_min >= 0 && _min <= 9) then {_min = format["0%1", _min];};
	private _time = format["%1:%2",_hour,_min];
	private _data = [_time,false,0,_numbercalling];
	A3PL_Phone_Historique pushBack _data;

	player setVariable ["tf_unable_to_use_radio", true];

	if !(isNull (findDisplay 20000)) then {
		uiNamespace setVariable ['nokiamenu',0];
		[] call A3PL_Phone_menuNokia;
	};

	private _myRadio = call TFAR_fnc_activeSwRadio;

	private _boucle = 5;
	if(_numbercalling in ["911","912","913"]) then {
		_boucle = 60;
	};

	for "_i" from 0 to _boucle step 1 do {
		if !(A3PL_Phone_tryCall) exitWith {};
		private _alive = player getVariable["A3PL_Medical_Alive",true];
		if !(_alive) exitWith {};

		private _radios = player call TFAR_fnc_radiosList;
		if(count _radios < 1) exitWith {};
		if !([(call TFAR_fnc_activeSwRadio),_myRadio] call TFAR_fnc_isSameRadio) exitWith {};
		if ((([_myRadio,"a3pl_iphone_1"] call TFAR_fnc_isSameRadio) || {([_myRadio,"a3pl_3310_1"] call TFAR_fnc_isSameRadio)}) && {!(currentWeapon player isEqualTo "")}) exitWith {};

		playSound "phone_call";
		sleep 5;
	};
	if(A3PL_Phone_tryCall) then {[] call A3PL_Phone_resetcall;};
}] call compile_Global;

["A3PL_Phone_callRecentNokia", {
	if((lbCurSel 20028) isEqualTo -1) exitWith {[("STR_A3PL_Phone_YouNeedToSelectSomeone" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _cible = lbData[20028,lbCurSel (20028)];
	if(_cible isEqualTo ("STR_A3PL_Phone_NoHistory" call A3PL_Localize)) exitWith {};
	_cible = call compile format["%1", _cible];

	private _anonyme = _cible select 1;
	private _number = _cible select 3;
	if(_anonyme) exitWith {[("STR_A3PL_Phone_YouCanCallAnAnonymeNumber" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if !(currentWeapon player isEqualTo "") exitWith {[("STR_Common_HandsFull" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if((A3PL_Forfait isEqualTo 0) && {!(_numbercalling in ["911","912","913"])}) exitWith {[("STR_A3PL_Phone_SubscriptionFinished" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	player playActionNow "A3PL_Tel";
	//A3PL_PhoneObject = "A3PL_3310_Object" createVehicle [0,0,1000];
	if !(isNull A3PL_PhoneObject) then {
		//[A3PL_PhoneObject,false] remoteExecCall ["enableSimulationGlobal",2];
		[] spawn {
			uiSleep 0.3;
			if (vehicle player isEqualTo player) then {
				A3PL_PhoneObject attachTo [player, [0.02,0.01,0.15], "RightHandMiddle1"];
				A3PL_PhoneObject setVectorDirAndUp [[-0.21017,0.265195,-0.94101],[-0.949623,0.173499,0.260989]];
			} else {
				A3PL_PhoneObject attachTo [(vehicle player),((vehicle player) worldToModel (player modelToWorldVisual ((player selectionPosition "RightHandMiddle1") vectorAdd [0.02,0.01,0.15])))];
				A3PL_PhoneObject setVectorDirAndUp [[-0.21017,0.265195,-0.94101],[-0.949623,0.173499,0.260989]];
			};
		};
	};

	A3PL_Phone_tryCall = true;
	life_radio_connected = false;
	A3PL_Phone_CallNumber = _number;

	[A3PL_Phone_Anonyme,A3PL_Phone_Number,_number,player] remoteExec ["Server_Phone_callSystem"];

	private _hour = date select 3;
	private _min = date select 4;
	if(_min >= 0 && _min <= 9) then {_min = format["0%1", _min];};
	private _time = format["%1:%2",_hour,_min];
	private _data = [_time,false,0,_number];
	A3PL_Phone_Historique pushBack _data;

	player setVariable ["tf_unable_to_use_radio", true];

	if !(isNull (findDisplay 20000)) then {
		uiNamespace setVariable ['nokiamenu',0];
		[] call A3PL_Phone_menuNokia;
	};

	private _myRadio = call TFAR_fnc_activeSwRadio;

	for "_i" from 0 to 5 step 1 do {
		if !(A3PL_Phone_tryCall) exitWith {};
		private _alive = player getVariable["A3PL_Medical_Alive",true];
		if !(_alive) exitWith {};

		private _radios = player call TFAR_fnc_radiosList;
		if(count _radios < 1) exitWith {};
		if !([(call TFAR_fnc_activeSwRadio),_myRadio] call TFAR_fnc_isSameRadio) exitWith {};
		if ((([_myRadio,"a3pl_iphone_1"] call TFAR_fnc_isSameRadio) || {([_myRadio,"a3pl_3310_1"] call TFAR_fnc_isSameRadio)}) && {!(currentWeapon player isEqualTo "")}) exitWith {};

		playSound "phone_call";
		sleep 5;
	};
	if(A3PL_Phone_tryCall) then {[] call A3PL_Phone_resetcall;};
}] call compile_Global;

["A3PL_Phone_deleteContactNokia", {
	private["_dialog","_contact","_name","_number","_list"];
	disableSerialization;
	if(EQUAL((lbCurSel 20011),-1)) exitWith {[("STR_A3PL_Phone_YouNeedToSelectSomeone" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_dialog = findDisplay 20000;
	_list = _dialog displayCtrl 20011;
	_contact = lbValue [20011, (lbCurSel 20011)];
	life_contacts deleteAt _contact;

	lbClear _list;
	{
		_name = _x select 0;
		_number = _x select 1;
		_list lbAdd format["%1 - %2",_name,_number];
		_list lbSetData [(lbSize _list)-1,str(_x)];
		_list lbSetValue [(lbSize _list)-1,_forEachIndex];
	} forEach life_contacts;

	[life_contacts, (player getVariable ["character_id",""])] remoteExecCall ["Server_Phone_updateContactsPhone"];
}] call compile_Global;

["A3PL_Phone_deleteSmsNokia", {
	disableSerialization;
	if((lbCurSel 20021) isEqualTo -1) exitWith {[("STR_A3PL_Phone_YouNeedToSelectSomeone" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _delButton = ((findDisplay 20000) displayCtrl 20024);
	_delButton ctrlShow false;

	private _data = CONTROL_DATA(20021);
	_data = call compile format["%1", _data];

	private _id = _data select 4;
	private _destinataire = A3PL_Phone_Number;

	[_id,player,_destinataire] remoteExec ["Server_Phone_deleteSmsNokia"];
}] call compile_Global;

["A3PL_Phone_lbChangedSmsNokia", {
	private["_text","_data","_delButton","_replyButton","_msg"];
	disableSerialization;
	_text = ((findDisplay 20000) displayCtrl 20022);
	_data = lbData[20021,lbCurSel (20021)];
	_replyButton = ((findDisplay 20000) displayCtrl 20023);
	if(_data isEqualTo ("STR_A3PL_Phone_YouDoNotHaveMessage" call A3PL_Localize)) then {
		_text ctrlSetStructuredText parseText  format[("STR_A3PL_Phone_YouDoNotHaveMessageStylized" call A3PL_Localize)];
	} else {
		_data = call compile _data;
		private _number = _data select 0;
		private _name = _data select 1;
		_msg = _data select 2;
		private _anonyme = _data select 3;
		if(_anonyme isEqualTo "1") then {_number = "**********"; _name = ("STR_A3PL_Phone_Anonym" call A3PL_Localize);};
		_text ctrlSetStructuredText parseText format ["<t shadow='0' font='NokiaCellphoneFC' color='#000000' size='.45'>%2 - %3 : %1</t>", _msg,_name,_number];
		_replyButton ctrlShow true;
		_replyButton buttonSetAction "[] spawn A3PL_Phone_replySmsNokia;";
	};
}] call compile_Global;


["A3PL_Phone_replySmsNokia", {
	disableSerialization;
	if(EQUAL((lbCurSel 20021),-1)) exitWith {[("STR_A3PL_Phone_YouNeedToSelectSomeone" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _data = CONTROL_DATA(20021);
	_data = call compile format["%1", _data];
	private _numero = _data select 0;
	private _name = _data select 1;
	private _anonyme = _data select 3;
	if(_anonyme isEqualTo "1") exitWith {[("STR_A3PL_Phone_YouCanContactAnAnonymeNumber" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _display = findDisplay 20000;
	private _menu1sim = _display displayCtrl 200011;
	private _menu1nosim = _display displayCtrl 200012;
	private _menu1incall = _display displayCtrl 200013;
	private _menu1ring = _display displayCtrl 200014;
	private _menu1try = _display displayCtrl 200015;
	private _datenokia = _display displayCtrl 20001;
	private _menu1smsbtn = _display displayCtrl 20002;
	private _menu1contactsbtn = _display displayCtrl 20003;
	private _menu1name = _display displayCtrl 200041;
	private _menu1num = _display displayCtrl 200042;
	private _menu1Time = _display displayCtrl 200043;
	private _menu1decrocher = _display displayCtrl 20004;
	private _menu1refuser = _display displayCtrl 20005;
	private _menu1raccrocher = _display displayCtrl 20006;
	private _menu1quit = _display displayCtrl 200061;
	private _menu1up = _display displayCtrl 200062;
	private _menu1down = _display displayCtrl 200063;

	private _menu2pic = _display displayCtrl 20010;
	private _menu2contactslist = _display displayCtrl 20011;
	private _menu2appeler = _display displayCtrl 20012;
	private _menu2sms = _display displayCtrl 20013;
	private _menu2supprimer = _display displayCtrl 20014;
	private _menu2nameedit = _display displayCtrl 20015;
	private _menu2numedit = _display displayCtrl 20016;
	private _menu2ajouter = _display displayCtrl 20017;
	private _menu2retour = _display displayCtrl 200171;

	private _menu3pic = _display displayCtrl 20018;
	private _menu3smsname = _display displayCtrl 200181;
	private _menu3numedit = _display displayCtrl 200182;
	private _menu3smsedit = _display displayCtrl 20019;
	private _menu3smsbtn = _display displayCtrl 20020;
	private _menu3retour = _display displayCtrl 200201;

	private _menu4pic = _display displayCtrl 200211;
	private _menu4smslist = _display displayCtrl 20021;
	private _menu4smsview = _display displayCtrl 20022;
	private _menu4repondre = _display displayCtrl 20023;
	private _menu4supprimer = _display displayCtrl 20024;
	private _menu4newsms = _display displayCtrl 20025;
	private _menu4retour = _display displayCtrl 20026;

	private _menu1phone = _display displayCtrl 200016;
	private _menu1phonetbn = _display displayCtrl 200031;

	private _menurecents = _display displayCtrl 20027;
	private _menurecentlist = _display displayCtrl 20028;

	_menu1up ctrlShow false;
	_menu1down ctrlShow false;
	_menu1incall ctrlShow false;
	_menu1sim ctrlShow false;
	_menu1nosim ctrlShow false;
	_menu1ring ctrlShow false;
	_menu1try ctrlShow false;
	_menu1smsbtn ctrlShow false;
	_menu1contactsbtn ctrlShow false;
	_menu1decrocher ctrlShow false;
	_menu1refuser ctrlShow false;
	_menu1raccrocher ctrlShow false;
	_menu1quit ctrlShow false;
	_menu2pic ctrlShow false;
	_menu2contactslist ctrlShow false;
	_menu2appeler ctrlShow false;
	_menu2sms ctrlShow false;
	_menu2supprimer ctrlShow false;
	_menu2nameedit ctrlShow false;
	_menu2numedit ctrlShow false;
	_menu2ajouter ctrlShow false;
	_menu3smsname ctrlShow true;
	_menu3smsedit ctrlShow true;
	_menu3smsbtn ctrlShow true;
	_menu3numedit ctrlShow false;
	_menu4smslist ctrlShow false;
	_menu4smsview ctrlShow false;
	_menu4repondre ctrlShow false;
	_menu4supprimer ctrlShow false;
	_menu4newsms ctrlShow false;
	_menu4pic ctrlShow false;
	_menu3pic ctrlShow true;
	_menu2retour ctrlShow true;
	_menu3retour ctrlShow false;
	_menu4retour ctrlShow false;
	_menu1name ctrlShow false;
	_menu1num ctrlShow false;
	_menu1Time ctrlShow false;
	_menu1phone ctrlShow false;
	_menu1phonetbn ctrlShow false;
	_menurecents ctrlShow false;
	_menurecentlist ctrlShow false;

	_menu3smsname ctrlSetStructuredText parseText format["<t align='right' font='NokiaCellphoneFC' shadow='0' color='#000000' size='.45'>%1 (%2)</t>",_name,_numero];

	A3PL_pInact_Number = _numero;
	_menu3smsbtn buttonSetAction "[A3PL_pInact_Number] spawn A3PL_Phone_sendSmsNokia; closeDialog 0;";
}] call compile_Global;

["A3PL_Phone_sendNewSmsNokia", {
	private["_number","_msg"];
	_number = ctrlText 200182;
	_msg = ctrlText 20019;
	if(_msg isEqualTo "") exitWith {[("STR_A3PL_Phone_YouCantSendEmptyMessage" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if(_number isEqualTo "") exitWith {[("STR_A3PL_Phone_EmptyName" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _length = count (toArray(_msg));
	private _length2 = count (toArray(_number));
	private _chrByte = toArray (_msg);
	private _chrByte2 = toArray (_number);
	private _allowed = toArray("0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.,'-/[]éàç€!?;:êè)(=+&<>*$ ");
	private _allowed2 = toArray("0123456789");
	if(_length > 150) exitWith {[("STR_A3PL_Phone_150CharMax" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if !(_length2 isEqualTo 10) exitWith {[("STR_A3PL_Phone_10CharMax" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _badChar = false;
	private _invalidChar = "";
	{if(!(_x in _allowed)) exitWith {_badChar = true; _invalidChar = _x;};} forEach _chrByte;
	{if(!(_x in _allowed2)) exitWith {_badChar = true; _invalidChar = _x;};} forEach _chrByte2;
	if(_badChar) exitWith {[format[("STR_A3PL_Phone_CharNotAuthorizedSpecify" call A3PL_Localize),_invalidChar],Color_Red] call A3PL_Notification;};
	if(A3PL_Forfait isEqualTo 0) exitWith {[("STR_A3PL_Phone_SubscriptionFinished" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if !(A3PL_Phone_Mute) then {
		playSound "message_sent";
	} else {
		playSound "message_sent";
	};

	[0,A3PL_Phone_Number,_number,_msg] remoteExecCall ["Server_Phone_sendSmsPhone"];
}] call compile_Global;

["A3PL_Phone_sendSmsNokia", {
	private["_number","_display"];
	_number = _this select 0;
	disableSerialization;
	_datamsg = ctrlText 20019;
	if(_datamsg isEqualTo "") exitWith {[("STR_A3PL_Phone_YouCantSendEmptyMessage" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_length = count (toArray(_datamsg));
	_chrByte = toArray (_datamsg);
	_allowed = toArray("0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.,'-/[]éàç€!?;:êè)(=+&<>*$ ");
	if(_length > 150) exitWith {[("STR_A3PL_Phone_150CharMax" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_badChar = false;
	{if(!(_x in _allowed)) exitWith {_badChar = true;};} forEach _chrByte;
	if(_badChar) exitWith {[format[("STR_A3PL_Phone_CharNotAuthorizedSpecify" call A3PL_Localize),_invalidChar],Color_Red] call A3PL_Notification;};
	if(A3PL_Forfait isEqualTo 0) exitWith {[("STR_A3PL_Phone_SubscriptionFinished" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if !(A3PL_Phone_Mute) then {
		playSound "message_sent";
	} else {
		playSound "message_sent";
	};

	[0,A3PL_Phone_Number,_number,_datamsg] remoteExecCall ["Server_Phone_sendSmsPhone"];
}] call compile_Global;

["A3PL_Phone_setViberNokia", {
	if(!A3PL_Phone_Mute) then {
		A3PL_Phone_Mute = true;
	} else {
		A3PL_Phone_Mute = false;
	};
	playSound3D ["\A3PL_Common\GUI\newphone\sounds\nokia_bip.ogg", player];
}] call compile_Global;

["A3PL_Phone_smsContactNokia", {
	if(EQUAL((lbCurSel 20011),-1)) exitWith {[("STR_A3PL_Phone_YouNeedToSelectSomeone" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	disableSerialization;
	private _display = findDisplay 20000;
	private _menu1sim = _display displayCtrl 200011;
	private _menu1nosim = _display displayCtrl 200012;
	private _menu1incall = _display displayCtrl 200013;
	private _menu1ring = _display displayCtrl 200014;
	private _datenokia = _display displayCtrl 20001;
	private _menu1smsbtn = _display displayCtrl 20002;
	private _menu1contactsbtn = _display displayCtrl 20003;
	private _menu1name = _display displayCtrl 200041;
	private _menu1num = _display displayCtrl 200042;
	private _menu1Time = _display displayCtrl 200043;
	private _menu1decrocher = _display displayCtrl 20004;
	private _menu1refuser = _display displayCtrl 20005;
	private _menu1raccrocher = _display displayCtrl 20006;
	private _menu1quit = _display displayCtrl 200061;
	private _menu1up = _display displayCtrl 200062;
	private _menu1down = _display displayCtrl 200063;
	private _menu1phone = _display displayCtrl 200016;
	private _menu1phonetbn = _display displayCtrl 200031;

	private _menu2pic = _display displayCtrl 20010;
	private _menu2contactslist = _display displayCtrl 20011;
	private _menu2appeler = _display displayCtrl 20012;
	private _menu2sms = _display displayCtrl 20013;
	private _menu2supprimer = _display displayCtrl 20014;
	private _menu2nameedit = _display displayCtrl 20015;
	private _menu2numedit = _display displayCtrl 20016;
	private _menu2ajouter = _display displayCtrl 20017;
	private _menu2retour = _display displayCtrl 200171;

	private _menu3pic = _display displayCtrl 20018;
	private _menu3smsname = _display displayCtrl 200181;
	private _menu3numedit = _display displayCtrl 200182;
	private _menu3smsedit = _display displayCtrl 20019;
	private _menu3smsbtn = _display displayCtrl 20020;
	private _menu3retour = _display displayCtrl 200201;

	private _menu4pic = _display displayCtrl 200211;
	private _menu4smslist = _display displayCtrl 20021;
	private _menu4smsview = _display displayCtrl 20022;
	private _menu4repondre = _display displayCtrl 20023;
	private _menu4supprimer = _display displayCtrl 20024;
	private _menu4newsms = _display displayCtrl 20025;
	private _menu4retour = _display displayCtrl 20026;
	private _menurecents = _display displayCtrl 20027;
	private _menurecentlist = _display displayCtrl 20028;

	private _dataname = CONTROL_DATA(20011);
	_dataname = call compile format["%1", _dataname];

	_menu1up ctrlShow false;
	_menu1down ctrlShow false;
	_menu1incall ctrlShow false;
	_menu1sim ctrlShow false;
	_menu1nosim ctrlShow false;
	_menu1ring ctrlShow false;
	_menu1smsbtn ctrlShow false;
	_menu1contactsbtn ctrlShow false;
	_menu1decrocher ctrlShow false;
	_menu1refuser ctrlShow false;
	_menu1raccrocher ctrlShow false;
	_menu1quit ctrlShow false;
	_menu2pic ctrlShow false;
	_menu2contactslist ctrlShow false;
	_menu2appeler ctrlShow false;
	_menu2sms ctrlShow false;
	_menu2supprimer ctrlShow false;
	_menu2nameedit ctrlShow false;
	_menu2numedit ctrlShow false;
	_menu2ajouter ctrlShow false;
	_menu3smsname ctrlShow true;
	_menu3smsedit ctrlShow true;
	_menu3smsbtn ctrlShow true;
	_menu3numedit ctrlShow false;
	_menu4smslist ctrlShow false;
	_menu4smsview ctrlShow false;
	_menu4repondre ctrlShow false;
	_menu4supprimer ctrlShow false;
	_menu4newsms ctrlShow false;
	_menu4pic ctrlShow false;
	_menu3pic ctrlShow true;
	_menu2retour ctrlShow false;
	_menu3retour ctrlShow true;
	_menu4retour ctrlShow false;
	_menu1name ctrlShow false;
	_menu1num ctrlShow false;
	_menu1Time ctrlShow false;
	_menu1phone ctrlShow false;
	_menu1phonetbn ctrlShow false;
	_menurecents ctrlShow false;
	_menurecentlist ctrlShow false;

	private _name = _dataname select 0;
	_numero = _dataname select 1;
	_menu3smsname ctrlSetStructuredText parseText format["<t align='right' font='NokiaCellphoneFC' shadow='0' color='#000000' size='.5'>%1</t>",_name];

	A3PL_pInact_Number = _numero;
	_menu3smsbtn buttonSetAction "[A3PL_pInact_Number] spawn A3PL_Phone_sendSmsNokia; uiNamespace setVariable ['nokiamenu',1]; [] call A3PL_Phone_menuNokia;";
}] call compile_Global;

["A3PL_Phone_SmsNokia", {
	disableSerialization;
	private _display = findDisplay 20000;
	private _menu1sim = _display displayCtrl 200011;
	private _menu1nosim = _display displayCtrl 200012;
	private _menu1incall = _display displayCtrl 200013;
	private _menu1ring = _display displayCtrl 200014;
	private _menu1try = _display displayCtrl 200015;
	private _datenokia = _display displayCtrl 20001;
	private _menu1smsbtn = _display displayCtrl 20002;
	private _menu1contactsbtn = _display displayCtrl 20003;
	private _menu1name = _display displayCtrl 200041;
	private _menu1num = _display displayCtrl 200042;
	private _menu1decrocher = _display displayCtrl 20004;
	private _menu1refuser = _display displayCtrl 20005;
	private _menu1raccrocher = _display displayCtrl 20006;
	private _menu1quit = _display displayCtrl 200061;
	private _menu1up = _display displayCtrl 200062;
	private _menu1down = _display displayCtrl 200063;

	private _menu2pic = _display displayCtrl 20010;
	private _menu2contactslist = _display displayCtrl 20011;
	private _menu2appeler = _display displayCtrl 20012;
	private _menu2sms = _display displayCtrl 20013;
	private _menu2supprimer = _display displayCtrl 20014;
	private _menu2nameedit = _display displayCtrl 20015;
	private _menu2numedit = _display displayCtrl 20016;
	private _menu2ajouter = _display displayCtrl 20017;
	private _menu2retour = _display displayCtrl 200171;

	private _menu3pic = _display displayCtrl 20018;
	private _menu3smsname = _display displayCtrl 200181;
	private _menu3numedit = _display displayCtrl 200182;
	private _menu3smsedit = _display displayCtrl 20019;
	private _menu3smsbtn = _display displayCtrl 20020;
	private _menu3retour = _display displayCtrl 200201;

	private _menu4pic = _display displayCtrl 200211;
	private _menu4smslist = _display displayCtrl 20021;
	private _menu4smsview = _display displayCtrl 20022;
	private _menu4repondre = _display displayCtrl 20023;
	private _menu4supprimer = _display displayCtrl 20024;
	private _menu4newsms = _display displayCtrl 20025;
	private _menu4retour = _display displayCtrl 20026;
	private _menu1phone = _display displayCtrl 200016;
	private _menu1phonetbn = _display displayCtrl 200031;
	private _menurecents = _display displayCtrl 20027;
	private _menurecentlist = _display displayCtrl 20028;

	_menu1up ctrlShow false;
	_menu1down ctrlShow false;
	_menu1incall ctrlShow false;
	_menu1sim ctrlShow false;
	_menu1nosim ctrlShow false;
	_menu1ring ctrlShow false;
	_menu1try ctrlShow false;
	_menu1smsbtn ctrlShow false;
	_menu1contactsbtn ctrlShow false;
	_menu1decrocher ctrlShow false;
	_menu1refuser ctrlShow false;
	_menu1raccrocher ctrlShow false;
	_menu1quit ctrlShow false;
	_menu2pic ctrlShow false;
	_menu2contactslist ctrlShow false;
	_menu2appeler ctrlShow false;
	_menu2sms ctrlShow false;
	_menu2supprimer ctrlShow false;
	_menu2nameedit ctrlShow false;
	_menu2numedit ctrlShow false;
	_menu2ajouter ctrlShow false;
	_menu3smsname ctrlShow false;
	_menu3smsedit ctrlShow true;
	_menu3smsbtn ctrlShow true;
	_menu3numedit ctrlShow true;
	_menu4smslist ctrlShow false;
	_menu4smsview ctrlShow false;
	_menu4repondre ctrlShow false;
	_menu4supprimer ctrlShow false;
	_menu4newsms ctrlShow false;
	_menu4pic ctrlShow false;
	_menu3pic ctrlShow true;
	_menu2retour ctrlShow true;
	_menu3retour ctrlShow false;
	_menu4retour ctrlShow false;
	_menu1name ctrlShow false;
	_menu1num ctrlShow false;
	_menu1phone ctrlShow false;
	_menu1phonetbn ctrlShow false;
	_menurecents ctrlShow false;
	_menurecentlist ctrlShow false;

	_menu3smsbtn buttonSetAction "[] spawn A3PL_Phone_sendNewSmsNokia; closeDialog 0;";
}] call compile_Global;

["A3PL_Phone_smsRecentNokia", {
	private["_data"];
	disableSerialization;
	if(EQUAL((lbCurSel 20028),-1)) exitWith {[("STR_A3PL_Phone_150CharMax" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_data = CONTROL_DATA(20028);
	if(_data isEqualTo ("STR_A3PL_Phone_NoHistory" call A3PL_Localize)) exitWith {};
	_data = call compile format["%1", _data];
	private _anonyme = _data select 1;
	private _numero = _data select 3;
	private _length = count (toArray(_numero));
	if(_length < 10) exitWith {[("STR_A3PL_Phone_10CharMax" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if(_anonyme isEqualTo 1) exitWith {[("STR_A3PL_Phone_YouCanContactAnAnonymeNumber" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _display = findDisplay 20000;
	private _menu1sim = _display displayCtrl 200011;
	private _menu1nosim = _display displayCtrl 200012;
	private _menu1incall = _display displayCtrl 200013;
	private _menu1ring = _display displayCtrl 200014;
	private _menu1try = _display displayCtrl 200015;
	private _datenokia = _display displayCtrl 20001;
	private _menu1smsbtn = _display displayCtrl 20002;
	private _menu1contactsbtn = _display displayCtrl 20003;
	private _menu1name = _display displayCtrl 200041;
	private _menu1num = _display displayCtrl 200042;
	private _menu1Time = _display displayCtrl 200043;
	private _menu1decrocher = _display displayCtrl 20004;
	private _menu1refuser = _display displayCtrl 20005;
	private _menu1raccrocher = _display displayCtrl 20006;
	private _menu1quit = _display displayCtrl 200061;
	private _menu1up = _display displayCtrl 200062;
	private _menu1down = _display displayCtrl 200063;

	private _menu2pic = _display displayCtrl 20010;
	private _menu2contactslist = _display displayCtrl 20011;
	private _menu2appeler = _display displayCtrl 20012;
	private _menu2sms = _display displayCtrl 20013;
	private _menu2supprimer = _display displayCtrl 20014;
	private _menu2nameedit = _display displayCtrl 20015;
	private _menu2numedit = _display displayCtrl 20016;
	private _menu2ajouter = _display displayCtrl 20017;
	private _menu2retour = _display displayCtrl 200171;

	private _menu3pic = _display displayCtrl 20018;
	private _menu3smsname = _display displayCtrl 200181;
	private _menu3numedit = _display displayCtrl 200182;
	private _menu3smsedit = _display displayCtrl 20019;
	private _menu3smsbtn = _display displayCtrl 20020;
	private _menu3retour = _display displayCtrl 200201;

	private _menu4pic = _display displayCtrl 200211;
	private _menu4smslist = _display displayCtrl 20021;
	private _menu4smsview = _display displayCtrl 20022;
	private _menu4repondre = _display displayCtrl 20023;
	private _menu4supprimer = _display displayCtrl 20024;
	private _menu4newsms = _display displayCtrl 20025;
	private _menu4retour = _display displayCtrl 20026;

	private _menu1phone = _display displayCtrl 200016;
	private _menu1phonetbn = _display displayCtrl 200031;

	private _menurecents = _display displayCtrl 20027;
	private _menurecentlist = _display displayCtrl 20028;

	_menu1up ctrlShow false;
	_menu1down ctrlShow false;
	_menu1incall ctrlShow false;
	_menu1sim ctrlShow false;
	_menu1nosim ctrlShow false;
	_menu1ring ctrlShow false;
	_menu1try ctrlShow false;
	_menu1smsbtn ctrlShow false;
	_menu1contactsbtn ctrlShow false;
	_menu1decrocher ctrlShow false;
	_menu1refuser ctrlShow false;
	_menu1raccrocher ctrlShow false;
	_menu1quit ctrlShow false;
	_menu2pic ctrlShow false;
	_menu2contactslist ctrlShow false;
	_menu2appeler ctrlShow false;
	_menu2sms ctrlShow false;
	_menu2supprimer ctrlShow false;
	_menu2nameedit ctrlShow false;
	_menu2numedit ctrlShow false;
	_menu2ajouter ctrlShow false;
	_menu3smsname ctrlShow true;
	_menu3smsedit ctrlShow true;
	_menu3smsbtn ctrlShow true;
	_menu3numedit ctrlShow false;
	_menu4smslist ctrlShow false;
	_menu4smsview ctrlShow false;
	_menu4repondre ctrlShow false;
	_menu4supprimer ctrlShow false;
	_menu4newsms ctrlShow false;
	_menu4pic ctrlShow false;
	_menu3pic ctrlShow true;
	_menu2retour ctrlShow true;
	_menu3retour ctrlShow false;
	_menu4retour ctrlShow false;
	_menu1name ctrlShow false;
	_menu1num ctrlShow false;
	_menu1Time ctrlShow false;
	_menu1phone ctrlShow false;
	_menu1phonetbn ctrlShow false;
	_menurecents ctrlShow false;
	_menurecentlist ctrlShow false;

	private _name = ("STR_Common_Unknown" call A3PL_Localize);
	if (count life_contacts > 0) then {
		{
			if ((_x select 1) isEqualTo _numero) then {
				_name = _x select 0;
			};
		} forEach life_contacts;
	};
	_menu3smsname ctrlSetStructuredText parseText format["<t align='right' font='NokiaCellphoneFC' shadow='0' color='#000000' size='.45'>%1 (%2)</t>",_name,_numero];

	A3PL_pInact_Number = _numero;
	_menu3smsbtn buttonSetAction "[A3PL_pInact_Number] spawn A3PL_Phone_sendSmsNokia; closeDialog 0;";
}] call compile_Global;

["A3PL_Phone_updateSmsNokia", {
	private _data = _this select 0;

	disableSerialization;
	waitUntil {sleep 0.1; !isNull (findDisplay 20000)};
	private _playerList = ((findDisplay 20000) displayCtrl 20021);
	private _replyButton = ((findDisplay 20000) displayCtrl 20023);
	_replyButton ctrlShow false;

	lbClear _playerList;
	if(count _data < 1) then
	{
		_playerList lbAdd format[("STR_A3PL_Phone_EmptyBox" call A3PL_Localize)];
		_playerList lbSetdata [(lbSize _playerList)-1, ("STR_A3PL_Phone_YouDoNotHaveMessage" call A3PL_Localize)];
	}
	else
	{
		{
			private _anonyme = _x select 0;
			private _number = _x select 1;
			private _msg = _x select 2;
			private _id = _x select 3;
			private _name = ("STR_Common_Unknown" call A3PL_Localize);
			if (count life_contacts > 0) then {
				{
					if (_x select 1 isEqualTo _number) exitWith {
						_name = _x select 0;
					};
				} foreach life_contacts;
			};
			private _infoToPass = format["[""%1"",""%2"",""%3"",""%4"",""%5""]",_number,_name,_msg,_anonyme,_id];
			if(_anonyme isEqualTo 1) then {_name = ("STR_A3PL_Phone_Anonym" call A3PL_Localize); _number = "**********";};
			_playerList lbAdd format["%1 - %2",_name,_number];
			_playerList lbSetdata [(lbSize _playerList)-1, _infoToPass];
		} foreach _data;
		private _delButton = ((findDisplay 20000) displayCtrl 20024);
		_delButton ctrlShow true;
		_delButton buttonSetAction "[] spawn A3PL_Phone_deleteSmsNokia;";
	};
	((findDisplay 20000) displayCtrl 20021) lbSetCurSel 0;
}] call compile_Global;

["A3PL_Phone_menuNokia", {
	private["_display"];
	if(!dialog) then {
	createDialog "A3PL_NokiaMenu_Dialog";
	};
	disableSerialization;
	_display = findDisplay 20000;
	_display call A3PL_Dialog_Localize;
	private _menu1sim = _display displayCtrl 200011;
	private _menu1nosim = _display displayCtrl 200012;
	private _menu1incall = _display displayCtrl 200013;
	private _menu1ring = _display displayCtrl 200014;
	private _menu1try = _display displayCtrl 200015;
	private _menu1phone = _display displayCtrl 200016;
	private _datenokia = _display displayCtrl 20001;
	private _menu1smsbtn = _display displayCtrl 20002;
	private _menu1contactsbtn = _display displayCtrl 20003;
	private _menu1phonetbn = _display displayCtrl 200031;
	private _menu1name = _display displayCtrl 200041;
	private _menu1num = _display displayCtrl 200042;
	private _menu1Time = _display displayCtrl 200043;
	private _menu1decrocher = _display displayCtrl 20004;
	private _menu1refuser = _display displayCtrl 20005;
	private _menu1raccrocher = _display displayCtrl 20006;
	private _menu1quit = _display displayCtrl 200061;
	private _menu1up = _display displayCtrl 200062;
	private _menu1down = _display displayCtrl 200063;

	private _menu2pic = _display displayCtrl 20010;
	private _menu2contactslist = _display displayCtrl 20011;
	private _menu2appeler = _display displayCtrl 20012;
	private _menu2sms = _display displayCtrl 20013;
	private _menu2supprimer = _display displayCtrl 20014;
	private _menu2nameedit = _display displayCtrl 20015;
	private _menu2numedit = _display displayCtrl 20016;
	private _menu2ajouter = _display displayCtrl 20017;
	private _menu2retour = _display displayCtrl 200171;

	private _menu3pic = _display displayCtrl 20018;
	private _menu3smsname = _display displayCtrl 200181;
	private _menu3numedit = _display displayCtrl 200182;
	private _menu3smsedit = _display displayCtrl 20019;
	private _menu3smsbtn = _display displayCtrl 20020;
	private _menu3retour = _display displayCtrl 200201;

	private _menu4pic = _display displayCtrl 200211;
	private _menu4smslist = _display displayCtrl 20021;
	private _menu4smsview = _display displayCtrl 20022;
	private _menu4repondre = _display displayCtrl 20023;
	private _menu4supprimer = _display displayCtrl 20024;
	private _menu4newsms = _display displayCtrl 20025;
	private _menu4retour = _display displayCtrl 20026;
	private _menurecents = _display displayCtrl 20027;
	private _menurecentlist = _display displayCtrl 20028;

	private _date = date;
	private _hour = _date select 3;
	private _min = _date select 4;
	if(_min >= 0 && _min <= 9) then {_min = format["0%1", _min];};
	_datenokia ctrlShow true;
	_datenokia ctrlSetStructuredText parseText format["<t align='right' font='NokiaCellphoneFC' shadow='0' color='#000000' size='.45'>%1:%2</t>", _hour,_min];

	if(A3PL_Phone_Anonyme) then {
		A3PL_Phone_Anonyme = false;
	};

	private _menu = uiNamespace getVariable "nokiamenu";
	switch (_menu) do {
		case 0 : {
			_menu2pic ctrlShow false;
			_menu2contactslist ctrlShow false;
			_menu2appeler ctrlShow false;
			_menu2sms ctrlShow false;
			_menu2supprimer ctrlShow false;
			_menu2nameedit ctrlShow false;
			_menu2numedit ctrlShow false;
			_menu2ajouter ctrlShow false;
			_menu3smsname ctrlShow false;
			_menu3smsedit ctrlShow false;
			_menu3smsbtn ctrlShow false;
			_menu3numedit ctrlShow false;
			_menu4smslist ctrlShow false;
			_menu4smsview ctrlShow false;
			_menu4repondre ctrlShow false;
			_menu4supprimer ctrlShow false;
			_menu4newsms ctrlShow false;
			_menu3pic ctrlShow false;
			_menu2retour ctrlShow false;
			_menu3retour ctrlShow false;
			_menu4retour ctrlShow false;
			_menu4pic ctrlShow false;
			_menu1quit ctrlShow true;
			_menu1Time ctrlShow false;
			_menu1phone ctrlShow false;
			_menu1phonetbn ctrlShow false;
			_menurecents ctrlShow false;
			_menurecentlist ctrlShow false;
			_menu1up ctrlShow false;
			_menu1down ctrlShow false;

			if (A3PL_Phone_inCall) then {
				_menu1incall ctrlShow true;
				_menu1sim ctrlShow false;
				_menu1nosim ctrlShow false;
				_menu1ring ctrlShow false;
				_menu1smsbtn ctrlShow false;
				_menu1contactsbtn ctrlShow false;
				_menu1decrocher ctrlShow false;
				_menu1refuser ctrlShow false;
				_menu1raccrocher ctrlShow true;
				_menu1name ctrlShow true;
				_menu1num ctrlShow true;
				_menu1try ctrlShow false;
				_menu1up ctrlShow true;
				_menu1down ctrlShow true;
				_menu1Time ctrlShow true;
				_menu1quit ctrlShow false;

				_hisName = ("STR_Common_Unknown" call A3PL_Localize);
				_hisNumber = A3PL_Phone_CallNumber;
				_hisAnonyme = A3PL_Phone_CallAnonyme;
				if (count life_contacts > 0) then {
					{
						if ((_x select 1) isEqualTo _hisNumber) exitWith {
							_hisName = _x select 0;
						};
					} forEach life_contacts;
				};
				if(_hisNumber isEqualTo "911") then {_hisName = ("STR_Common_SheriffsDepartment" call A3PL_Localize)} else {if(_hisAnonyme) then {_hisName = ("STR_A3PL_Phone_Anonym" call A3PL_Localize); _hisNumber = "**********"};};
				if(_hisNumber isEqualTo "912") then {_hisName = ("STR_Common_FireDepartment" call A3PL_Localize)} else {if(_hisAnonyme) then {_hisName = ("STR_A3PL_Phone_Anonym" call A3PL_Localize); _hisNumber = "**********"};};
				if(_hisNumber isEqualTo "913") then {_hisName = ("STR_Common_DepartmentOfJustice" call A3PL_Localize)} else {if(_hisAnonyme) then {_hisName = ("STR_A3PL_Phone_Anonym" call A3PL_Localize); _hisNumber = "**********"};};
				_menu1name ctrlSetStructuredText parseText format["<t align='right' font='NokiaCellphoneFC' shadow='0' color='#000000' size='.6'>%1</t>", _hisName];
				_menu1num ctrlSetStructuredText parseText format["<t align='right' font='NokiaCellphoneFC' shadow='0' color='#000000' size='.6'>%1</t>", _hisNumber];
				_menu1up buttonSetAction "[""UP""] spawn A3PL_Phone_callSetVolume;";
				_menu1down buttonSetAction "[""DOWN""] spawn A3PL_Phone_callSetVolume;";
				_menu1raccrocher buttonSetAction "[] call A3PL_Phone_endCall;";
			} else {
			if (A3PL_Phone_Ring) then {
					_menu1incall ctrlShow false;
					_menu1sim ctrlShow false;
					_menu1nosim ctrlShow false;
					_menu1ring ctrlShow true;
					_menu1smsbtn ctrlShow false;
					_menu1contactsbtn ctrlShow false;
					_menu1decrocher ctrlShow true;
					_menu1refuser ctrlShow true;
					_menu1raccrocher ctrlShow false;
					_menu1name ctrlShow true;
					_menu1num ctrlShow true;
					_menu1try ctrlShow false;
					_menu1Time ctrlShow false;

					_hisName = ("STR_Common_Unknown" call A3PL_Localize);
					_hisNumber = A3PL_Phone_CallNumber;
					_hisAnonyme = A3PL_Phone_CallAnonyme;
					if (count life_contacts > 0) then {
						{
							if ((_x select 1) isEqualTo _hisNumber) exitWith {
								_hisName = _x select 0;
							};
						} forEach life_contacts;
					};
					if(_hisAnonyme) then {_hisName = ("STR_A3PL_Phone_Anonym" call A3PL_Localize); _hisNumber = "**********"};
					_menu1name ctrlSetStructuredText parseText format["<t align='right' font='NokiaCellphoneFC' shadow='0' color='#000000' size='.6'>%1</t>", _hisName];
					_menu1num ctrlSetStructuredText parseText format["<t align='right' font='NokiaCellphoneFC' shadow='0' color='#000000' size='.6'>%1</t>", _hisNumber];
					_menu1decrocher buttonSetAction "player setVariable [""call_info"",2,true];";
					_menu1refuser buttonSetAction "[] call A3PL_Phone_resetCall;";
				} else {
					if(A3PL_Phone_tryCall) then {
						_menu1incall ctrlShow false;
						_menu1sim ctrlShow false;
						_menu1nosim ctrlShow false;
						_menu1ring ctrlShow false;
						_menu1try ctrlShow true;
						_menu1smsbtn ctrlShow false;
						_menu1contactsbtn ctrlShow false;
						_menu1decrocher ctrlShow false;
						_menu1refuser ctrlShow true;
						_menu1raccrocher ctrlShow false;
						_menu1name ctrlShow true;
						_menu1num ctrlShow true;
						_menu1Time ctrlShow false;

						_hisName = ("STR_Common_Unknown" call A3PL_Localize);
						_hisNumber = A3PL_Phone_CallNumber;
						if (count life_contacts > 0) then {
							{
								if ((_x select 1) isEqualTo _hisNumber) exitWith {
									_hisName = _x select 0;
								};
							} forEach life_contacts;
						};
						if(_hisNumber isEqualTo "911") then {_hisName = ("STR_Common_SheriffsDepartment" call A3PL_Localize)};
						if(_hisNumber isEqualTo "912") then {_hisName = ("STR_Common_FireDepartment" call A3PL_Localize)};
						if(_hisNumber isEqualTo "913") then {_hisName = ("STR_Common_DepartmentOfJustice" call A3PL_Localize)};
						_menu1name ctrlSetStructuredText parseText format["<t align='right' font='NokiaCellphoneFC' shadow='0' color='#000000' size='.6'>%1</t>", _hisName];
						_menu1num ctrlSetStructuredText parseText format["<t align='right' font='NokiaCellphoneFC' shadow='0' color='#000000' size='.6'>%1</t>", _hisNumber];
						_menu1refuser buttonSetAction "[] call A3PL_Phone_resetCall;";
					} else {
						if(A3PL_Forfait isEqualTo -1) then {
							_menu1incall ctrlShow false;
							_menu1try ctrlShow false;
							_menu1sim ctrlShow false;
							_menu1nosim ctrlShow true;
							_menu1ring ctrlShow false;
							_menu1smsbtn ctrlShow false;
							_menu1contactsbtn ctrlShow false;
							_menu1decrocher ctrlShow false;
							_menu1refuser ctrlShow false;
							_menu1raccrocher ctrlShow false;
							_menu1name ctrlShow false;
							_menu1num ctrlShow false;
							_menu1Time ctrlShow false;
						} else {
								_menu1incall ctrlShow false;
								_menu1try ctrlShow false;
								_menu1sim ctrlShow true;
								_menu1nosim ctrlShow false;
								_menu1ring ctrlShow false;
								_menu1smsbtn ctrlShow true;
								_menu1contactsbtn ctrlShow true;
								_menu1decrocher ctrlShow false;
								_menu1refuser ctrlShow false;
								_menu1raccrocher ctrlShow false;
								_menu1name ctrlShow false;
								_menu1num ctrlShow false;
								_menu1Time ctrlShow false;
								_menu1phonetbn ctrlShow true;
								_menu1up ctrlShow true;
								_menu1up buttonSetAction "[] spawn A3PL_Phone_setViberNokia;";
						};
					};
				};
			};
		};
		case 1 : {
			_menu1incall ctrlShow false;
			_menu1sim ctrlShow false;
			_menu1nosim ctrlShow false;
			_menu1ring ctrlShow false;
			_menu1try ctrlShow false;
			_menu1smsbtn ctrlShow false;
			_menu1contactsbtn ctrlShow false;
			_menu1decrocher ctrlShow false;
			_menu1refuser ctrlShow false;
			_menu1raccrocher ctrlShow false;
			_menu3smsname ctrlShow false;
			_menu3smsedit ctrlShow false;
			_menu3smsbtn ctrlShow false;
			_menu3numedit ctrlShow false;
			_menu4smslist ctrlShow false;
			_menu4smsview ctrlShow false;
			_menu4repondre ctrlShow false;
			_menu4supprimer ctrlShow false;
			_menu4newsms ctrlShow false;
			_menu4pic ctrlShow false;
			_menu3pic ctrlShow false;
			_menu2pic ctrlShow true;
			_menu2contactslist ctrlShow true;
			_menu2appeler ctrlShow true;
			_menu2sms ctrlShow true;
			_menu2supprimer ctrlShow true;
			_menu2nameedit ctrlShow true;
			_menu2numedit ctrlShow true;
			_menu2ajouter ctrlShow true;
			_menu2retour ctrlShow true;
			_menu3retour ctrlShow false;
			_menu4retour ctrlShow false;
			_menu1name ctrlShow false;
			_menu1num ctrlShow false;
			_menu1quit ctrlShow false;
			_menu1Time ctrlShow false;
			_menu1phone ctrlShow false;
			_menu1phonetbn ctrlShow false;
			_menurecents ctrlShow false;
			_menurecentlist ctrlShow false;
			_menu1up ctrlShow false;
			_menu1down ctrlShow false;

			lbClear _menu2contactslist;
			if (count life_contacts > 0) then {
				{
					_name = _x select 0;
					_number = _x select 1;
					_menu2contactslist lbAdd format["%1 - %2",_name,_number];
					_menu2contactslist lbSetData [(lbSize _menu2contactslist)-1,str(_x)];
					_menu2contactslist lbSetValue [(lbSize _menu2contactslist)-1,_forEachIndex];
				} forEach life_contacts;
				lbSort _menu2contactslist;
			};
			_menu2appeler buttonSetAction "[] spawn A3PL_Phone_callContactNokia;";

		};
		case 2 : {
			_menu1incall ctrlShow false;
			_menu1sim ctrlShow false;
			_menu1nosim ctrlShow false;
			_menu1ring ctrlShow false;
			_menu1try ctrlShow false;
			_menu1smsbtn ctrlShow false;
			_menu1contactsbtn ctrlShow false;
			_menu1decrocher ctrlShow false;
			_menu1refuser ctrlShow false;
			_menu1raccrocher ctrlShow false;
			_menu1quit ctrlShow false;
			_menu2pic ctrlShow false;
			_menu2contactslist ctrlShow false;
			_menu2appeler ctrlShow false;
			_menu2sms ctrlShow false;
			_menu2supprimer ctrlShow false;
			_menu2nameedit ctrlShow false;
			_menu2numedit ctrlShow false;
			_menu2ajouter ctrlShow false;
			_menu3smsname ctrlShow false;
			_menu3smsedit ctrlShow false;
			_menu3smsbtn ctrlShow false;
			_menu3numedit ctrlShow false;
			_menu4smslist ctrlShow true;
			_menu4smsview ctrlShow true;
			_menu4repondre ctrlShow false;
			_menu4supprimer ctrlShow false;
			_menu4newsms ctrlShow true;
			_menu4pic ctrlShow true;
			_menu3pic ctrlShow false;
			_menu2retour ctrlShow false;
			_menu3retour ctrlShow false;
			_menu4retour ctrlShow true;
			_menu1name ctrlShow false;
			_menu1num ctrlShow false;
			_menu1Time ctrlShow false;
			_menu1phone ctrlShow false;
			_menu1phonetbn ctrlShow false;
			_menurecents ctrlShow false;
			_menurecentlist ctrlShow false;
			_menu1up ctrlShow false;
			_menu1down ctrlShow false;
			[A3PL_Phone_Number,player] remoteExecCall ["Server_Phone_loadSmsNokia"];
			_menu4newsms buttonSetAction "[] call A3PL_Phone_smsNokia;";
			_menu4retour buttonSetAction "uiNamespace setVariable ['nokiamenu',0]; [] call A3PL_Phone_menuNokia;";
			A3PL_Phone_SMS = false;
		};
		case 3 : {
			_menu1incall ctrlShow false;
			_menu1sim ctrlShow false;
			_menu1nosim ctrlShow false;
			_menu1ring ctrlShow false;
			_menu1try ctrlShow false;
			_menu1smsbtn ctrlShow false;
			_menu1contactsbtn ctrlShow false;
			_menu1decrocher ctrlShow true;
			_menu1refuser ctrlShow true;
			_menu1raccrocher ctrlShow false;
			_menu1quit ctrlShow false;
			_menu2pic ctrlShow false;
			_menu2contactslist ctrlShow false;
			_menu2appeler ctrlShow false;
			_menu2sms ctrlShow false;
			_menu2supprimer ctrlShow false;
			_menu2nameedit ctrlShow false;
			_menu2numedit ctrlShow false;
			_menu2ajouter ctrlShow false;
			_menu3smsname ctrlShow false;
			_menu3smsedit ctrlShow false;
			_menu3smsbtn ctrlShow false;
			_menu3numedit ctrlShow true;
			_menu4smslist ctrlShow false;
			_menu4smsview ctrlShow false;
			_menu4repondre ctrlShow false;
			_menu4supprimer ctrlShow false;
			_menu4newsms ctrlShow false;
			_menu4pic ctrlShow false;
			_menu3pic ctrlShow false;
			_menu2retour ctrlShow true;
			_menu3retour ctrlShow false;
			_menu4retour ctrlShow false;
			_menu1name ctrlShow false;
			_menu1num ctrlShow true;
			_menu1Time ctrlShow false;
			_menu1phone ctrlShow true;
			_menu1phonetbn ctrlShow false;
			_menurecents ctrlShow false;
			_menurecentlist ctrlShow false;
			_menu1up ctrlShow true;
			_menu1down ctrlShow false;

			_menu1decrocher buttonSetAction "[] spawn A3PL_Phone_callCustomNokia;";
			_menu1refuser buttonSetAction "[] spawn A3PL_Phone_callDisablePhone;";
			_menu1num ctrlSetStructuredText parseText format[("STR_A3PL_Phone_MyPhoneNumber" call A3PL_Localize),A3PL_Phone_Number];
			_menu1up buttonSetAction "uiNamespace setVariable ['nokiamenu',4]; [] call A3PL_Phone_menuNokia;";
		};

		case 4 : {
			_menu1incall ctrlShow false;
			_menu1sim ctrlShow false;
			_menu1nosim ctrlShow false;
			_menu1ring ctrlShow false;
			_menu1try ctrlShow false;
			_menu1smsbtn ctrlShow false;
			_menu1contactsbtn ctrlShow false;
			_menu1decrocher ctrlShow false;
			_menu1refuser ctrlShow false;
			_menu1raccrocher ctrlShow false;
			_menu3smsname ctrlShow false;
			_menu3smsedit ctrlShow false;
			_menu3smsbtn ctrlShow false;
			_menu3numedit ctrlShow false;
			_menu4smslist ctrlShow false;
			_menu4smsview ctrlShow false;
			_menu4repondre ctrlShow true;
			_menu4supprimer ctrlShow true;
			_menu4newsms ctrlShow true;
			_menu4pic ctrlShow false;
			_menu3pic ctrlShow false;
			_menu2pic ctrlShow false;
			_menu2contactslist ctrlShow false;
			_menu2appeler ctrlShow false;
			_menu2sms ctrlShow false;
			_menu2supprimer ctrlShow false;
			_menu2nameedit ctrlShow false;
			_menu2numedit ctrlShow false;
			_menu2ajouter ctrlShow false;
			_menu2retour ctrlShow false;
			_menu3retour ctrlShow false;
			_menu4retour ctrlShow false;
			_menu1name ctrlShow false;
			_menu1num ctrlShow false;
			_menu1quit ctrlShow false;
			_menu1Time ctrlShow false;
			_menu1phone ctrlShow false;
			_menu1phonetbn ctrlShow false;
			_menurecents ctrlShow true;
			_menurecentlist ctrlShow true;
			_menu1up ctrlShow false;
			_menu1down ctrlShow true;

			lbClear _menurecentlist;
			if (count A3PL_Phone_Historique > 0) then {
				{
					private _time = _x select 0;
					private _anonyme = _x select 1;
					private _type = _x select 2;
					private _number = _x select 3;
					private _hisName = ("STR_Common_Unknown" call A3PL_Localize);
					if(_anonyme) then {_hisName = ("STR_A3PL_Phone_Anonym" call A3PL_Localize); _number = "**********"};
					if (count life_contacts > 0) then {
						{
							if ((_x select 1) isEqualTo _number) exitWith {
								_hisName = _x select 0;
							};
						} forEach life_contacts;
					};
					if(_number isEqualTo "911") then {_hisName = ("STR_Common_SheriffsDepartment" call A3PL_Localize)};
					if(_number isEqualTo "912") then {_hisName = ("STR_Common_FireDepartment" call A3PL_Localize)};
					if(_number isEqualTo "913") then {_hisName = ("STR_Common_DepartmentOfJustice" call A3PL_Localize)};
					_menurecentlist lbAdd format["[%1] - %2 (%3)",_time,_hisName,_number];
					if (_type isEqualTo 0) then {
						_menurecentlist lbSetPicture [(lbSize _menurecentlist)-1,"\A3PL_Common\GUI\newphone\out.paa"]; 
					} else {
						_menurecentlist lbSetPicture [(lbSize _menurecentlist)-1,"\A3PL_Common\GUI\newphone\in.paa"];
					};
					_menurecentlist lbSetData [(lbSize _menurecentlist)-1,str(_x)];
				} forEach A3PL_Phone_Historique;
			} else {
				_menurecentlist lbAdd ("STR_A3PL_Phone_NoHistory" call A3PL_Localize);
				_menurecentlist lbSetData [(lbSize _menurecentlist)-1,("STR_A3PL_Phone_NoHistory" call A3PL_Localize)];
			};
			((findDisplay 20000) displayCtrl 20028) lbSetCurSel 0;
			_menu4repondre buttonSetAction "[] spawn A3PL_Phone_callRecentNokia;";
			_menu4newsms buttonSetAction "[] spawn A3PL_Phone_smsRecentNokia;";
			_menu4supprimer buttonSetAction "A3PL_Phone_Historique = []; [] call A3PL_Phone_menuNokia;";
			_menu1down buttonSetAction "uiNamespace setVariable ['nokiamenu',3]; [] call A3PL_Phone_menuNokia;";
		};
	};

	[] spawn {
		if ((isNull A3PL_PhoneObject) && !A3PL_Phone_inCall && !A3PL_Phone_tryCall) then {
			player playActionNow "A3PL_LookAt";
			A3PL_PhoneObject = "A3PL_3310_Object" createVehicle [0,0,1000];
			[A3PL_PhoneObject,false] remoteExecCall ["enableSimulationGlobal",2];
			uiSleep 0.3;
			if (vehicle player isEqualTo player) then {
				A3PL_PhoneObject attachTo [player, [-0.06,-0.05,0.01], "RightHandMiddle1"];     
				A3PL_PhoneObject setVectorDirAndUp [[0.1, -1.9, -0.8],[-0.25, -0.5, 0.5]]; 
			};
			
			waitUntil {(isNull findDisplay 20000) || A3PL_Phone_inCall || A3PL_Phone_tryCall};

			if (!A3PL_Phone_inCall && !A3PL_Phone_tryCall) then {
				detach A3PL_PhoneObject;
				deleteVehicle A3PL_PhoneObject;
				A3PL_PhoneObject = objNull;
				player playActionNow "gestureNod";
				[{player playActionNow "gestureNod";}] call CBA_fnc_execNextFrame;
			};
		};
	};
}] call compile_Global;
