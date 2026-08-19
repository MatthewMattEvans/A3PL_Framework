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
#define RANY 0
#include "\z\tfar\addons\handhelds\script_component.hpp"

// ═══════════════════════════════════════════════════════════════════════════════
// RADIO FREQUENCY OFFSET BY LANGUAGE
// Permet d'avoir des fréquences différentes par serveur pour éviter les interférences TFAR
// FR = offset 0, EN = offset 100, DE = offset 200
// ═══════════════════════════════════════════════════════════════════════════════
["A3PL_Radio_GetFrequencyOffset", {
    if (isNil "Server_Lang") exitWith {0};
    switch (Server_Lang) do {
        case "FR": {100};
        case "EN": {0};
        case "DE": {200};
        default {0};
    };
}] call compile_Global;

["A3PL_Phone_buyForfait", {
	params[
		["_tel",-1,[0]],
		["_mode",-1,[0]]
	];
	if(_tel isEqualTo -1 OR {_mode isEqualTo -1}) exitWith {};
	
	private _charID = (player getVariable ["character_id",""]);
	private _price = 0;
	private _offre = "";
	private _hasAccount = [player,1] call A3PL_Bank_HasAccount;
	private _currentMoney = player getVariable["Player_Bank",0];

	switch (_tel) do {
		case 1 : {
			switch (_mode) do {
				case 1 : {_price = Phone_Forfait1_Price;};
				case 2 : {_price = Phone_Forfait2_Price;};
				case 3 : {_price = Phone_Forfait3_Price;};
				case 4 : {_price = Phone_Forfait4_Price;};
			};

			private _action = [format[("STR_A3PL_Phone_DoYouReallyWantToBuyThisSubscription" call A3PL_Localize),_price]] call A3PL_Lib_ConfirmationDialog;
			if (!isNil "_action" && {!_action}) exitWith {[("STR_A3PL_Phone_YouDontWantBuy" call A3PL_Localize),Color_Green] call A3PL_Notification;};
			if (!_hasAccount) exitWith {[("STR_Common_NoBankAccount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			if (_currentMoney < _price) exitWith {[("STR_A3PL_Phone_YouDontHaveThisAmountInYourBankAccount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			player setVariable["Player_Bank",_currentMoney-_price,true];
			[_charID,_mode,player] remoteExecCall ["Server_Phone_buyForfait"];
			[("STR_A3PL_Phone_YouUpdatedYourSubscription" call A3PL_Localize),Color_Green] call A3PL_Notification;
		};
		case 2 : {
			private _getDay = player getVariable["Player_Perkday",0];
			if (_getDay < 1) exitWith {[("STR_A3PL_Phone_PremiumOnly" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			private _action = [format[("STR_A3PL_Phone_DoYouReallyWantToRemoveYourSubscription" call A3PL_Localize)]] call A3PL_Lib_ConfirmationDialog;
			if (!isNil "_action" && {!_action}) exitWith {[("STR_A3PL_Phone_YouDecidedToNotRemoveYourSubscription" call A3PL_Localize),Color_Green] call A3PL_Notification;};
			_price = Phone_Resiliation_Price;
			if (!_hasAccount) exitWith {[("STR_Common_NoBankAccount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			if (_currentMoney < _price) exitWith {[("STR_A3PL_Phone_YouDontHaveThisAmountInYourBankAccount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			player setVariable["Player_Bank",_currentMoney-_price,true];
			A3PL_Forfait = -1;
			[_charID,player] remoteExec ["Server_Phone_removeForfait"];
			[("STR_A3PL_Phone_YoURemovedYourSubscription" call A3PL_Localize),Color_Green] call A3PL_Notification;
		};
	};
}] call compile_Global;

["A3PL_Phone_menuForfait", {
	createDialog "Dialog_Forfait";
	disableSerialization;

	private _display = findDisplay 15000;
	private _monAboTexte = _display displayCtrl 15001;
	private _resilier = _display displayCtrl 15006;

	private _color = "";
	private _monAbo = "";

	private _temps = A3PL_Forfait;

	if(_temps isEqualTo -1) then {
		_color = "#E74C3C";
		_monAbo = ("STR_Common_None" call A3PL_Localize);
		_monAboTexte ctrlSetStructuredText parseText format["<t color='%1'>%2</t>",_color,_monAbo];
		_resilier ctrlShow false;
	} else {
		if(_temps > 0) then {
			_temps = _temps / 60;
			_temps = floor(_temps);
			_color = "#27AE60";
			_monAboTexte ctrlSetStructuredText parseText format[("STR_A3PL_Phone_Hours" call A3PL_Localize),_color,_temps];
		} else {
			_color = "#E74C3C";
			_monAboTexte ctrlSetStructuredText parseText format[("STR_A3PL_Phone_Epuised" call A3PL_Localize),_color];
		};
	};
}] call compile_Global;

["A3PL_Phone_receptionSmsPhone", {
	private["_anonyme","_nameExpediteur","_numberExpediteur","_msg"];
	_anonyme = _this select 0;
	_numberExpediteur = _this select 1;
	_msg = _this select 2;

	_nameExpediteur = ("STR_Common_Unknown" call A3PL_Localize);
	{
		if ((_x select 1) isEqualTo _numberExpediteur) then {_nameExpediteur = _x select 0;};
	} forEach life_contacts;
	if (_anonyme isEqualTo 1) then {_nameExpediteur = ("STR_A3PL_Phone_Anonym" call A3PL_Localize); _numberExpediteur = "**********";};

	private _radios = player call TFAR_fnc_radiosList;
	if(count _radios > 0) then {
		if([(call TFAR_fnc_activeSwRadio),"a3pl_iphone_1"] call TFAR_fnc_isSameRadio) then {
			[format["%1 - %2",_nameExpediteur,_numberExpediteur],_msg] spawn A3PL_Notifications_doSMS;
		};
		if !(A3PL_Phone_Mute) then {
			[] spawn {
				if([(call TFAR_fnc_activeSwRadio),"a3pl_3310_1"] call TFAR_fnc_isSameRadio) then {
					_Ring = createSoundSource ['A3PL_Nokia_SMS', [0,0,0], [], 0];
					_Ring attachTo [player, [0,0,0]];
					uiSleep 1;
					deleteVehicle _Ring;
				};
				if([(call TFAR_fnc_activeSwRadio),"a3pl_iphone_1"] call TFAR_fnc_isSameRadio) then {
					_Ring = createSoundSource ['A3PL_iPhone_SMS', [0,0,0], [], 0];
					_Ring attachTo [player, [0,0,0]];
					uiSleep 0.5;
					deleteVehicle _Ring;
				};
				if([(call TFAR_fnc_activeSwRadio),"a3pl_sonySD_1"] call TFAR_fnc_isSameRadio) then {
					_Ring = createSoundSource ['A3PL_Sony_SMS', [0,0,0], [], 0];
					_Ring attachTo [player, [0,0,0]];
					uiSleep 1;
					deleteVehicle _Ring;
				};
				if([(call TFAR_fnc_activeSwRadio),"a3pl_sonyFD_1"] call TFAR_fnc_isSameRadio) then {
					_Ring = createSoundSource ['A3PL_Sony_SMS', [0,0,0], [], 0];
					_Ring attachTo [player, [0,0,0]];
					uiSleep 1;
					deleteVehicle _Ring;
				};
			};
		} else {
			[] spawn {
				_Ring = createSoundSource ['A3PL_SMS_Vibreur', [0,0,0], [], 0];
				_Ring attachTo [player, [0,0,0]];
				uiSleep 0.5;
				deleteVehicle _Ring;
			};
		};
		A3PL_Phone_SMS = true;
	};
}] call compile_Global;

["A3PL_Phone_setPhoneNumber", {
	params[
		["_number","",[""]]
	];
	if(_number isEqualTo "") exitWith {};

	A3PL_Phone_Number = _number;
}] call compile_Global;

["A3PL_Phone_receiveForfait", {
	params ["_result"];
    A3PL_Forfait = _result;
}] call compile_Global;

["A3PL_Phone_receivePhoneNumber", {
	params ["_result"];
    A3PL_Phone_Number = _result;
	player setVariable ["phoneNumber",_result,true];
}] call compile_Global;

["A3PL_Phone_receiveContacts", {
	params ["_result"];
    life_contacts = _result;
}] call compile_Global;

["A3PL_Phone_updateForfait", {
	params[
		["_time",-1,[0]]
	];
	if(_time isEqualTo -1) exitWith {};
	
	A3PL_Forfait = _time;
}] call compile_Global;

["A3PL_Phone_callDisablePhone", {
	if(A3PL_Phone_Avion) then {
		A3PL_Phone_Avion = false;
	} else {
		A3PL_Phone_Avion = true;
	};
	
	playSound "nokia_bip";
}] call compile_Global;

["A3PL_Phone_callForceEnd", {
	private _myRadio = _this select 0;
	private _myFrequence = _this select 1;
	private _myRadioCode = _this select 2;
	private _myRadioSetting = _this select 3;

	A3PL_Phone_inCall = false;
	A3PL_Phone_tryCall = false;
	A3PL_Phone_Ring = false;

	player setVariable ["callFrequence",0];

	iPhone_Mute = false;
	iPhone_Speackers = false;

	A3PL_Central = false;

	A3PL_Phone_CallNumber = "";

	player setVariable ["tf_unable_to_use_radio",true];

	player setVariable ["call_info",0,true];

	[_radio, _channel, _currentFrequency, false] call TFAR_fnc_doSRTransmitEnd;
	TF_tangent_sw_pressed = false;

	[_myRadio, 1, (player getVariable ["character_id",""])] call TFAR_fnc_SetChannelFrequency;
	[_myRadio, 2, (player getVariable ["character_id",""])] call TFAR_fnc_SetChannelFrequency;

	if !(isNull A3PL_PhoneObject) then {
		detach A3PL_PhoneObject;
		deleteVehicle A3PL_PhoneObject;
		A3PL_PhoneObject = objNull;
		player playActionNow "gestureNod";
		[{player playActionNow "gestureNod";}] call CBA_fnc_execNextFrame;
	};
}] call compile_Global;

["A3PL_Phone_callInProgress", {
	params [
		["_callID",0,[0]],
		["_central",false,[false]]
	];
	
	A3PL_Phone_Ring = false;

	deleteVehicle Ring;

	A3PL_Phone_tryCall = false;
	life_phone_connected = true;
	
	player setVariable ["callFrequence",_callID];
	
	A3PL_Phone_inCall = true;
	player setVariable ["tf_unable_to_use_radio",true];

	if(_central) then {
		A3PL_Central = true;
	};
	
	if !(isNull A3PL_PhoneObject) then {
		switch (true) do {
			case ([(call TFAR_fnc_activeSwRadio),"a3pl_3310_1"] call TFAR_fnc_isSameRadio): {
				player playActionNow "A3PL_Tel";
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
			case ([(call TFAR_fnc_activeSwRadio),"a3pl_iphone_1"] call TFAR_fnc_isSameRadio): {
				player playActionNow "A3PL_Tel";
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
		};
	};
	
	if !(isNull (findDisplay 20000)) then {
		uiNamespace setVariable ['nokiamenu',0];
		[] call A3PL_Phone_menuNokia;
	};
	if !(isNull (findDisplay 56400)) then {
		uiNamespace setVariable ['iphonemenu',0];
		[] call A3PL_Phone_menuiPhone;
	};
	if !(isNull (findDisplay 32999)) then {
		uiNamespace setVariable ['sony',0];
		[] call A3PL_Phone_menuSony;
	};
	if !(isNull (findDisplay 38999)) then {
		uiNamespace setVariable ['sonyp',0];
		[] call A3PL_Phone_menuSonyP;
	};
	if !(isNull (findDisplay 58999)) then {
		uiNamespace setVariable ['sonydoj',0];
		[] call A3PL_Phone_menuSonyDOJ; 
	};
	
	private _radio = call TFAR_fnc_activeSwRadio;
	[_radio, 0] call TFAR_fnc_setSwChannel;
	[_radio, 1, _callID] call TFAR_fnc_SetChannelFrequency;

	if !(a3pl_sony_FreqAdd isEqualTo 0) then {
		[_radio, 2, (player getVariable ["character_id",""])] call TFAR_fnc_SetChannelFrequency;
	};

	private _radio = call TFAR_fnc_activeSwRadio;
	private _channel = _radio call TFAR_fnc_getSwChannel;
	private _currentFrequency = [_radio, _channel + 1] call TFAR_fnc_getChannelFrequency;

	private _hasObject = false;
	{
		private _obj = _x splitString "_";
		if ((((_obj#1) find "iphone") isNotEqualTo -1) || (((_obj#1) find "3310") isNotEqualTo -1)) then {_hasObject = true};
	} forEach assignedItems player;

	private _myRadio = call TFAR_fnc_activeSwRadio;
	private _myFrequence = call TFAR_fnc_currentSWFrequency;
	private _myRadioCode = _myRadio call TFAR_fnc_getSwRadioCode;
	private _myRadioSetting = call TFAR_fnc_getTransmittingDistanceMultiplicator;

	while {A3PL_Phone_inCall} do {
		if (_hasObject) then {
			player playActionNow "A3PL_Tel";
		};

		if !(iPhone_Mute) then {
			[_radio, 1, _callID] call TFAR_fnc_SetChannelFrequency;
			[_radio, _channel, _currentFrequency, false] call TFAR_fnc_doSRTransmit;
			TF_tangent_sw_pressed = true;
			[(call TFAR_fnc_ActiveSWRadio), 2] call TFAR_fnc_setSwStereo;
		};
		if !(player getVariable ["A3PL_Medical_Alive",true]) exitWith {[_myRadio,_myFrequence,_myRadioCode,_myRadioSetting] call A3PL_Phone_callForceEnd;};
		uiSleep 0.1;
	};


	[] spawn A3PL_Phone_callTime;
	
	if(_myRadio call TFAR_fnc_getSwSpeakers) then {
		[_myRadio] call TFAR_fnc_setSwSpeakers;
	};
	[_myRadio,5] call TFAR_fnc_setSwVolume;
	
	for "_i" from 0 to 1 step 0 do {
		if !(A3PL_Phone_inCall) exitWith {};
		if !(player getVariable ["A3PL_Medical_Alive",true]) exitWith {[_myRadio,_myFrequence,_myRadioCode,_myRadioSetting] call A3PL_Phone_callForceEnd;};
		if !([(call TFAR_fnc_activeSwRadio),_myRadio] call TFAR_fnc_isSameRadio) exitWith {[_myRadio,_myFrequence,_myRadioCode,_myRadioSetting] call A3PL_Phone_callForceEnd;};
		private _radios = player call TFAR_fnc_radiosList;
		if(count _radios < 1) exitWith {[_myRadio,_myFrequence,_myRadioCode,_myRadioSetting] call A3PL_Phone_callForceEnd;};
		if !(currentWeapon player isEqualTo "") then {
			player action ["SwitchWeapon", player, player, 100];
			player switchCamera cameraView;
			player playActionNow "A3PL_Tel";
		};
		uiSleep 0.1;
	};
}] call compile_Global;

["A3PL_Phone_callSetSpeaker", {
	[call TFAR_fnc_ActiveSWRadio] call TFAR_fnc_setSwSpeakers;
	playSound "nokia_bip";
}] call compile_Global;

["A3PL_Phone_callSetVolume", {
	private["_mode","_volume"];
	_mode = _this select 0;

	switch (_mode) do {
		case "UP" : {
			_volume = (call TFAR_fnc_ActiveSwRadio) call TFAR_fnc_getSwVolume;
			_volume = _volume + 1;
			if(_volume > 10) then { _volume = 10;};
			[(call TFAR_fnc_ActiveSWRadio), _volume] call TFAR_fnc_setSwVolume;
		};
		case "DOWN" : {
			_volume = (call TFAR_fnc_ActiveSwRadio) call TFAR_fnc_getSwVolume;
			_volume = _volume - 1;
			if(_volume < 1) then { _volume = 1; };
			[(call TFAR_fnc_ActiveSWRadio), _volume] call TFAR_fnc_setSwVolume;
		};
	};

	playSound "nokia_bip";
}] call compile_Global;

["A3PL_Phone_callTime", {
	disableSerialization;
	private _sec = 0;
	for "_i" from 0 to 1 step 0 do {
		if(!A3PL_Phone_inCall) exitWith {};
		private _alive = player getVariable["A3PL_Medical_Alive",true];
		if !(_alive) exitwith {};
		_sec = _sec + 1;
		if !(isNull (findDisplay 20000)) then {
			((findDisplay 20000) displayCtrl 200043) ctrlSetStructuredText parseText format["<t align='right' font='NokiaCellphoneFC' shadow='0' color='#000000' size='.6'>%1</t>",[_sec,"MM:SS"] call BIS_fnc_secondsToString];
		};
		if !(isNull (findDisplay 56400)) then {
			((findDisplay 56400) displayCtrl 564043) ctrlSetStructuredText parseText format["<t align='center' font='HelveticaLTLight' shadow='0' color='#ffffff' size='.85'>%1</t>",[_sec,"MM:SS"] call BIS_fnc_secondsToString];
		};
		if !(isNull (findDisplay 32999)) then {
			((findDisplay 32999) displayCtrl 33021) ctrlSetStructuredText parseText format["<t align='right' style='1' font='HelveticaLTLight' shadow='0' color='#000000' size='2.5'>%1</t>",[_sec,"MM:SS"] call BIS_fnc_secondsToString];
		};
		if !(isNull (findDisplay 38999)) then {
			((findDisplay 38999) displayCtrl 39021) ctrlSetStructuredText parseText format["<t align='right' style='1' font='HelveticaLTLight' shadow='0' color='#000000' size='2.5'>%1</t>",[_sec,"MM:SS"] call BIS_fnc_secondsToString];
		};
		uiSleep 1;
	};
}] call compile_Global;

["A3PL_Phone_endCall", {
	if !(A3PL_Phone_inCall) exitWith {};

	A3PL_Phone_inCall = false;
	A3PL_Phone_tryCall = false;
	A3PL_Phone_Ring = false;
	life_phone_connected = false;

	player setVariable ["callFrequence",0];

	iPhone_Mute = false;
	iPhone_Speackers = false;

	A3PL_Phone_CallNumber = "";

	player setVariable ["call_info",0,true];

	if(A3PL_Central) then {
		player setVariable ["central_id",0,true];
		A3PL_Central = false;
	};

	[(call TFAR_fnc_ActiveSWRadio), 0] call TFAR_fnc_setSwStereo;
	private _radio = call TFAR_fnc_activeSwRadio;
	private _channel = _radio call TFAR_fnc_getSwChannel;
	private _currentFrequency = [_radio, _channel + 1] call TFAR_fnc_getChannelFrequency;

	[_radio, _channel, _currentFrequency, false] call TFAR_fnc_doSRTransmitEnd;
	TF_tangent_sw_pressed = false;

	

	if(life_radio_connected) then {
		player setVariable ["tf_unable_to_use_radio", false];
		private _freqOffset = call A3PL_Radio_GetFrequencyOffset;
		if !(A3PL_iPhone_Freq isEqualTo 0) then {
			[(call TFAR_fnc_activeSwRadio),1,A3PL_iPhone_Freq + _freqOffset] call TFAR_fnc_SetChannelFrequency;
		};
		if !(a3pl_sony_Freq isEqualTo 0) then {
			[(call TFAR_fnc_activeSwRadio),1,a3pl_sony_Freq + _freqOffset] call TFAR_fnc_SetChannelFrequency;
		};
		if !(a3pl_sony_FreqAdd isEqualTo 0) then {

			private _settings = (call TFAR_fnc_activeSwRadio) call TFAR_fnc_getSwSettings;
			_settings set [TFAR_ADDITIONAL_CHANNEL_OFFSET, 1];
			[(call TFAR_fnc_activeSwRadio), _settings] call TFAR_fnc_setSwSettings;

			[(call TFAR_fnc_activeSwRadio),2,a3pl_sony_FreqAdd + _freqOffset] call TFAR_fnc_SetChannelFrequency;
		};
	} else {
		player setVariable ["tf_unable_to_use_radio", true];
		[(call TFAR_fnc_activeSwRadio), 1, (player getVariable ["character_id",""])] call TFAR_fnc_SetChannelFrequency;
		[(call TFAR_fnc_activeSwRadio), 2, (player getVariable ["character_id",""])] call TFAR_fnc_SetChannelFrequency;
	};

	if !(isNull A3PL_PhoneObject) then {
		detach A3PL_PhoneObject;
		deleteVehicle A3PL_PhoneObject;
		A3PL_PhoneObject = objNull;
		player playActionNow "gestureNod";
		[{player playActionNow "gestureNod";}] call CBA_fnc_execNextFrame;
	};

	if !(isNull (findDisplay 20000)) then {
		uiNamespace setVariable ['nokiamenu',0];
		[] call A3PL_Phone_menuNokia;
		playSound "nokia_end";
	};
	if !(isNull (findDisplay 56400)) then {
		uiNamespace setVariable ['iphonemenu',0];
		[] call A3PL_Phone_menuiPhone;
	};
	if !(isNull (findDisplay 32999)) then {
		uiNamespace setVariable ['sony',0];
		[] call A3PL_Phone_menuSony; 
	};
	if !(isNull (findDisplay 38999)) then {
		uiNamespace setVariable ['sonyp',0];
		[] call A3PL_Phone_menuSonyP; 
	}; 
	if !(isNull (findDisplay 58999)) then {
		uiNamespace setVariable ['sonydoj',0];
		[] call A3PL_Phone_menuSonyDOJ; 
	}; 
}] call compile_Global;

["A3PL_Phone_resetCall", {

	A3PL_Phone_inCall = false;
	A3PL_Phone_tryCall = false;
	A3PL_Phone_Ring = false;

	deleteVehicle Ring;

	player setVariable ["callFrequence",0];

	iPhone_Mute = false;
	iPhone_Speackers = false;
	life_phone_connected = false;

	A3PL_Central = false;

	A3PL_Phone_CallNumber = "";

	player setVariable ["call_info",0,true];

	if(life_radio_connected) then {
		player setVariable ["tf_unable_to_use_radio", false];
		private _freqOffset = call A3PL_Radio_GetFrequencyOffset;
		if !(A3PL_iPhone_Freq isEqualTo 0) then {
			[(call TFAR_fnc_activeSwRadio),1,A3PL_iPhone_Freq + _freqOffset] call TFAR_fnc_SetChannelFrequency;
		};
		if !(a3pl_sony_Freq isEqualTo 0) then {
			[(call TFAR_fnc_activeSwRadio),1,a3pl_sony_Freq + _freqOffset] call TFAR_fnc_SetChannelFrequency;
		};
		if !(a3pl_sony_FreqAdd isEqualTo 0) then {
			private _settings = (call TFAR_fnc_activeSwRadio) call TFAR_fnc_getSwSettings;
			_settings set [TFAR_ADDITIONAL_CHANNEL_OFFSET, 1];
			[(call TFAR_fnc_activeSwRadio), _settings] call TFAR_fnc_setSwSettings;

			[(call TFAR_fnc_activeSwRadio),2,a3pl_sony_FreqAdd + _freqOffset] call TFAR_fnc_SetChannelFrequency;
		};
	} else {
		player setVariable ["tf_unable_to_use_radio", true];
		[(call TFAR_fnc_activeSwRadio), 1, (player getVariable ["character_id",""])] call TFAR_fnc_SetChannelFrequency;
		[(call TFAR_fnc_activeSwRadio), 2, (player getVariable ["character_id",""])] call TFAR_fnc_SetChannelFrequency;
	};

	if !(isNull (findDisplay 20000)) then {
		uiNamespace setVariable ['nokiamenu',0];
		[] call A3PL_Phone_menuNokia;
		playSound "nokia_end";
	};
	if !(isNull (findDisplay 56400)) then {
		uiNamespace setVariable ['iphonemenu',0];
		[] call A3PL_Phone_menuiPhone;
	};
	if !(isNull (findDisplay 32999)) then {
		uiNamespace setVariable ['sony',0];
		[] call A3PL_Phone_menuSony;
	};
	if !(isNull (findDisplay 38999)) then {
		uiNamespace setVariable ['sonyp',0];
		[] call A3PL_Phone_menuSonyP;
	};
	if !(isNull (findDisplay 58999)) then {
		uiNamespace setVariable ['sonydoj',0];
		[] call A3PL_Phone_menuSonyDOJ; 
	};

	if !(isNull A3PL_PhoneObject) then {
		detach A3PL_PhoneObject;
		deleteVehicle A3PL_PhoneObject;
		A3PL_PhoneObject = objNull;
		player playActionNow "gestureNod";
		[{player playActionNow "gestureNod";}] call CBA_fnc_execNextFrame;
	};
}] call compile_Global;

["A3PL_Phone_ringPlayer", {
	params [
		["_anonyme",false,[false]],
		["_hisNumber","",[""]]
	];
	if(_hisNumber isEqualTo "") exitWith {player setVariable ["call_info",0];};
	private _radios = player call TFAR_fnc_radiosList;
	if(count _radios isEqualTo 0) exitWith {player setVariable ["call_info",0];};
	
	if(A3PL_Phone_inCall OR {A3PL_Phone_Ring} OR {A3PL_Phone_tryCall}) exitwith {};
	
	if (A3PL_Phone_Avion) exitWith {player setVariable ["call_info",0];};

	A3PL_Phone_Ring = true;
	A3PL_Phone_CallNumber = _hisNumber;
	A3PL_Phone_CallAnonyme = _anonyme;
	
	[] spawn A3PL_Notifications_doCallIn;
	
	if !(isNull (findDisplay 20000)) then {
		uiNamespace setVariable ['nokiamenu',0];
		[] call A3PL_Phone_menuNokia;
	};
	if !(isNull (findDisplay 56400)) then {
		uiNamespace setVariable ['iphonemenu',0];
		[] call A3PL_Phone_menuiPhone;
	};
	if !(isNull (findDisplay 32999)) then {
		uiNamespace setVariable ['sony',0];
		[] call A3PL_Phone_menuSony; 
	};
	if !(isNull (findDisplay 38999)) then {
		uiNamespace setVariable ['sonyp',0];
		[] call A3PL_Phone_menuSonyP; 
	};
	if !(isNull (findDisplay 58999)) then {
		uiNamespace setVariable ['sonydoj',0];
		[] call A3PL_Phone_menuSonyDOJ; 
	};
	
	private _hour = date select 3;
	private _min = date select 4;
	if(_min >= 0 && _min <= 9) then {_min = format["0%1", _min];};
	private _time = format["%1:%2",_hour,_min];
	private _data = [_time,A3PL_Phone_CallAnonyme,1,A3PL_Phone_CallNumber];
	A3PL_Phone_Historique pushBack _data;

	private _myRadio = call TFAR_fnc_activeSwRadio;
	private _alive = player getVariable["A3PL_Medical_Alive",true];
	private _sleep = "";
	Ring = "";
	
	for "_i" from 0 to 5 step 1 do {
		if !(A3PL_Phone_Ring) exitWith {};
		if !(_alive) exitWith {};
	
		private _radios = player call TFAR_fnc_radiosList;
		if(count _radios < 1) exitWith {};
		if !([(call TFAR_fnc_activeSwRadio),_myRadio] call TFAR_fnc_isSameRadio) exitWith {};
	
		if !(A3PL_Phone_Mute) then {
			if([(call TFAR_fnc_activeSwRadio),"a3pl_3310_1"] call TFAR_fnc_isSameRadio) then {
				Ring = createSoundSource ['A3PL_Nokia_Ring', [0,0,0], [], 0];
				Ring attachTo [player, [0,0,0]];
				_sleep = 2.55;
			};
			if([(call TFAR_fnc_activeSwRadio),"a3pl_iphone_1"] call TFAR_fnc_isSameRadio) then {
				private _pRing = profileNamespace getVariable [format["iPhone_Ring_%1",(player getVariable "character_id")],1];
				Ring = call compile format["createSoundSource ['A3PL_iPhoneRing%1', [0,0,0], [], 0]",_pRing];
				Ring attachTo [player, [0,0,0]];
				_sleep = 5;
			};
			if([(call TFAR_fnc_activeSwRadio),"a3pl_sonySD_1"] call TFAR_fnc_isSameRadio) then {
				Ring = createSoundSource ['A3PL_Sony_Ring', [0,0,0], [], 0];
				Ring attachTo [player, [0,0,0]];
				_sleep = 5;
			};
			if([(call TFAR_fnc_activeSwRadio),"a3pl_sonyFD_1"] call TFAR_fnc_isSameRadio) then {
				Ring = createSoundSource ['A3PL_Sony_Ring', [0,0,0], [], 0];
				Ring attachTo [player, [0,0,0]];
				_sleep = 5;
			};
			if([(call TFAR_fnc_activeSwRadio),"a3pl_sonyDOJ_1"] call TFAR_fnc_isSameRadio) then {
				Ring = createSoundSource ['A3PL_Sony_Ring', [0,0,0], [], 0];
				Ring attachTo [player, [0,0,0]];
				_sleep = 5;
			};
		} else {
			private _pRing = profileNamespace getVariable [format["iPhone_Ring_%1",(player getVariable "character_id")],1];
			Ring = createSoundSource ['A3PL_Ring_Vibreur', [0,0,0], [], 0];
			Ring attachTo [player, [0,0,0]];
			_sleep = 5;
		};
		uiSleep _sleep;
		deleteVehicle Ring;
	};
	if(A3PL_Phone_Ring) exitWith {[] call A3PL_Phone_resetcall;};
}] call compile_Global;

["A3PL_Phone_menuSMSSR", {
	private ["_listeHistorique","_txtControl"];
	params [
		["_mode",-1,[0]],
		["_histtexte","",[""]],
		["_msgs",[],[[]]]
	];
	disableSerialization;

	if (_mode isEqualTo -1) exitWith {};

	private _display = findDisplay 754721;
	if !(isNull _display) then {
		_listeHistorique = _display displayCtrl 754722;
		_txtControl = _display displayCtrl 754724;
	};

	switch (_mode) do {
		case 0: {
			if (!(createDialog "A3PL_SR_SMS_Tel")) exitWith {};
			(findDisplay 56411) call A3PL_Dialog_Localize;
			lbClear 754722;
			A3PL_InspectTelHistorique = [];
		};

		case 1: {
			if (count _histtexte < 10 || {count _histtexte > 10}) exitWith {lbClear 754722;A3PL_InspectTelHistorique = [];lbSetCurSel [754722, -1];_txtControl ctrlShow false;};
			if !([_histtexte] call TON_fnc_isnumber) exitWith {lbClear 754722;A3PL_InspectTelHistorique = [];lbSetCurSel [754722, -1];_txtControl ctrlShow false;};

			lbClear 754722;
			[_histtexte] remoteExecCall ["Server_Phone_getMSGFromNumber"];
		};
		
		case 2: {
			if !(count(_msgs) > 0) exitWith {[("STR_A3PL_Phone_NoHistoryAvailable" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			
			A3PL_inspectTeltime = time;
			if !((_msgs select 0) isEqualTo []) then {
				{
					private _numberExp = _x select 0;
					private _numberDest = _x select 1;
					private _msg = format["%1", _x select 2];
					private _date = _x select 3;
					
					if (_numberExp isEqualTo _histtexte) then {
						private _index = _listeHistorique lbAdd format["%1",_numberDest];
						_listeHistorique lbSetPicture [_index,"\A3PL_Common\GUI\newphone\out.paa"];
					} else {
						private _index = _listeHistorique lbAdd format["%1",_numberExp];
						_listeHistorique lbSetPicture [_index,"\A3PL_Common\GUI\newphone\in.paa"];
					};
					_listeHistorique lbSetdata [(lbSize _listeHistorique)-1, str([_msg,_date])];
				} forEach _msgs;
			} else {
				private _index = _listeHistorique lbAdd ("STR_A3PL_Phone_NoHistory" call A3PL_Localize);
				_listeHistorique lbSetData [_index,str([("STR_A3PL_Phone_NoHistory" call A3PL_Localize),""])];
			};
		};

		case 3: {
			disableSerialization;
			private _msg = call compile format["%1",lbData[754722,lbCurSel (754722)]];
			
			if((_msg select 0) isEqualTo ("STR_A3PL_Phone_NoHistory" call A3PL_Localize)) then {
				_txtControl ctrlSetStructuredText parseText format[("STR_A3PL_Phone_YouDoNotHaveMessageStylizediPhone" call A3PL_Localize)];
			} else {
				_txtControl ctrlSetStructuredText parseText format ["<t color='#FFFFFF' font='HelveticaLTLight' size='1'>%3/%2/%1 %4:%5 - </t><t shadow='0' color='#FFFFFF' font='HelveticaLTLight' size='1'>%6</t>", (_msg select 1) select 0, (_msg select 1) select 1, (_msg select 1) select 2, (_msg select 1) select 3, (_msg select 1) select 4, (_msg select 0)];
			};
		};
	};
}] call compile_Global;

["A3PL_Phone_menuInspectTel", {
	private ["_listeHistorique","_mapControl"];
	params [
		["_mode",-1,[0]],
		["_msgs",[],[[]]],
		["_text","",[""]]
	];
	disableSerialization;

	if (_mode isEqualTo -1) exitWith {};

	private _display = findDisplay 754720;
	if !(isNull _display) then {
		_listeHistorique = _display displayCtrl 754722;
		_mapControl = _display displayCtrl 754721;
	};

	_hasTel = {
		_return = false;
		{
			if (((assignedItems A3PL_InspectTelTarget) select 3) find _x > -1) exitWith {
				_return = true;
			};
		} forEach ["a3pl_3310","a3pl_iphone","a3pl_sonySD","a3pl_sonyFD"];
		_return
	};

	switch (_mode) do {
		case 0: {
			if ((time - A3PL_InspectTelTime) < 30) exitWith{[("STR_A3PL_Phone_PleaseWait" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			if (!(createDialog "A3PL_Inspect_Tel")) exitWith {};
			(findDisplay 56412) call A3PL_Dialog_Localize;
			lbClear 754722;
			A3PL_InspectTelTarget = objNull;
			A3PL_InspectTelHistorique = [];
		};

		case 1: {
			private _text = ctrlText 754723;
			if (count _text < 10 || {count _text > 10}) exitWith {lbClear 754722;A3PL_InspectTelTarget = objNull;A3PL_InspectTelHistorique = [];if !(A3PL_InspectTelMarker isEqualTo "") then {deleteMarkerLocal A3PL_InspectTelMarker;};A3PL_InspectTelMarker = "";lbSetCurSel [754722, -1];_mapControl ctrlShow false;};
			if !([_text] call A3PL_Lib_isNumber) exitWith {lbClear 754722;A3PL_InspectTelTarget = objNull;A3PL_InspectTelHistorique = [];if !(A3PL_InspectTelMarker isEqualTo "") then {deleteMarkerLocal A3PL_InspectTelMarker;};A3PL_InspectTelMarker = "";lbSetCurSel [754722, -1];_mapControl ctrlShow false;};

			[_text] remoteExecCall ["Server_Phone_getUnitFromNumberSR"];
		};

		case 2: {
			A3PL_InspectTelTime = time;
			A3PL_InspectTelTarget = _this select 3;
			
			lbClear _listeHistorique;
			if !((_msgs select 0) isEqualTo []) then {
				{
					private _numberExp = _x select 0;
					private _numberDest = _x select 1;
					private _position = format["%1", _x select 2];
					private _date = _x select 3;
					
					if (_numberExp isEqualTo _text) then {
						private _index = _listeHistorique lbAdd format["%3/%2 %4:%5 %1", _numberDest, _date select 1, _date select 2, _date select 3, _date select 4];
						_listeHistorique lbSetPicture [_index,"\A3PL_Common\GUI\newphone\out.paa"];
					} else {
						private _index = _listeHistorique lbAdd format["%3/%2 %4:%5 %1", _numberExp, _date select 1, _date select 2, _date select 3, _date select 4];
						_listeHistorique lbSetPicture [_index,"\A3PL_Common\GUI\newphone\in.paa"];
					};
					_listeHistorique lbSetdata [(lbSize _listeHistorique)-1, str([_position,_date])];
				} forEach _msgs;
			} else {
				private _index = _listeHistorique lbAdd ("STR_A3PL_Phone_NoHistory" call A3PL_Localize);
				_listeHistorique lbSetData [_index,str([])];
			};

			if (isNull A3PL_InspectTelTarget) exitWith {[("STR_A3PL_Phone_LocationFailed" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			if (!(call _hasTel) || (A3PL_InspectTelTarget getVariable ["TelephoneOff",false])) exitWith {[("STR_A3PL_Phone_LocationFailed" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			
			[3] spawn A3PL_Phone_menuInspectTel;
		};

		case 3: {
			if !(lbCurSel(754722) isEqualTo -1) then {
				private _data = call compile format["%1",lbData[754722, lbCurSel(754722)]];
				if (_data isEqualTo []) exitWith {};
				
				_mapControl ctrlShow true;
				
				private _pos =  call compile format["%1",(_data select 0)] getPos [([100,275] call BIS_fnc_randomInt), random 360];
				if (A3PL_InspectTelMarker isEqualTo "") then {
					A3PL_InspectTelMarker = createMarkerLocal [format["%1_marker",A3PL_InspectTelTarget],_pos];
					A3PL_InspectTelMarker setMarkerShapeLocal "ELLIPSE";
					A3PL_InspectTelMarker setMarkerSizeLocal [550, 550];
					A3PL_InspectTelMarker setMarkerColorLocal "ColorGreen";
					A3PL_InspectTelMarker setMarkerAlphaLocal 0.75;
				} else {
					A3PL_InspectTelMarker setMarkerPosLocal _pos;
				};
				_mapControl ctrlMapAnimAdd [1.5,0.08,_pos];
				ctrlMapAnimCommit _mapControl;	
				
			} else {
			
				if (isNull A3PL_InspectTelTarget) exitWith {};
				if (!(call _hasTel) || (A3PL_InspectTelTarget getVariable ["TelephoneOff",false])) exitWith {_mapControl ctrlShow false; [("STR_A3PL_Phone_LocationFailed" call A3PL_Localize),Color_Red] call A3PL_Notification;};
				_target = A3PL_InspectTelTarget;
				_mapControl ctrlShow true;
				_pos = A3PL_InspectTelTarget getPos [([100,275] call BIS_fnc_randomInt), random 360];
				if (A3PL_InspectTelMarker isEqualTo "") then {
					A3PL_InspectTelMarker = createMarkerLocal [format["%1_marker",A3PL_InspectTelTarget],_pos];
					A3PL_InspectTelMarker setMarkerShapeLocal "ELLIPSE";
					A3PL_InspectTelMarker setMarkerSizeLocal [450, 450];
					A3PL_InspectTelMarker setMarkerColorLocal "ColorGreen";
					A3PL_InspectTelMarker setMarkerAlphaLocal 0.75;
				} else {
					A3PL_InspectTelMarker setMarkerPosLocal _pos;
				};
				_mapControl ctrlMapAnimAdd [1.5,0.08,_pos];
				ctrlMapAnimCommit _mapControl;

				for "_i" from 0 to 1 step 0 do { 
					_time = time;
					waitUntil {(time - _time) > 30 || {isNull A3PL_InspectTelTarget} || {!(_target isEqualTo A3PL_InspectTelTarget)} || {!(call _hasTel)} || {A3PL_InspectTelTarget getVariable ["TelephoneOff",false]}};
					
					if (!(call _hasTel) || {A3PL_InspectTelTarget getVariable ["TelephoneOff",false]} || {isNull A3PL_InspectTelTarget} || {!(_target isEqualTo A3PL_InspectTelTarget)}) then {
						_mapControl ctrlShow false;
						deleteMarkerLocal A3PL_InspectTelMarker;
						A3PL_InspectTelMarker = "";
					} else {
						_mapControl ctrlShow true;
						_pos = A3PL_InspectTelTarget getPos [([100,275] call BIS_fnc_randomInt), random 360];
						A3PL_InspectTelMarker setMarkerPosLocal _pos;
						_mapControl ctrlMapAnimAdd [1.5,0.08,_pos];
						ctrlMapAnimCommit _mapControl;
					};
					if (isNull A3PL_InspectTelTarget || {!(_target isEqualTo A3PL_InspectTelTarget)}) exitwith {};
				};
			};
		};
	};
}] call compile_Global;

["A3PL_Phone_appNote",
{
	disableSerialization;

	uiNamespace setVariable ['iphonemenu',21]; [] call A3PL_Phone_menuiPhone;

	private _notesName = param [0,"N/A"];
	private _display = findDisplay 56400;
	{
		private["_textBox","_control"];
		if (_notesName IN (_x select 0)) then {_textBox = _x select 1;};
		_control = _display displayCtrl 682610;
		_control ctrlSetText _notesName;

		_control = _display displayCtrl 682611;
		_control ctrlSetText _textBox;
	} forEach A3FL_Notes;
}] call compile_Global;

["A3PL_Phone_deleteNote",
{
	private _noteName = param[0,""];
	if (_noteName isEqualTo "") exitWith {["Someone was retarded and didn't call the function properly",Color_Red] call A3PL_Notification;};
	{
		if ((_x select 0) isEqualTo _noteName) exitWith {A3FL_Notes deleteAt _forEachIndex; closeDialog 0;};
	} forEach A3FL_Notes;
	profileNamespace setVariable [format["A3FL_Notes_%1",(player getVariable "character_id")], A3FL_Notes];
    saveProfileNamespace;

	[format[("STR_A3PL_Phone_YouRemovedTheNote" call A3PL_Localize),_noteName],Color_Yellow] call A3PL_Notification;
}] call compile_Global;

["A3PL_Phone_appSaveNote",
{
	disableSerialization;
	private ["_exists","_notes"];
	private _display = findDisplay 56400;
	private _control = _display displayCtrl 682610;
	private _newName = ctrlText 682610;
	private _newText = ctrlText 682611;
	private _notes = A3FL_Notes;
	_exists = false;
	{
		if ((_x select 0) isEqualTo _newName) then {A3FL_Notes deleteAt _forEachIndex;} else {A3FL_Notes deleteAt _forEachIndex;};
	} forEach A3FL_Notes;

	_notes pushBack [_newName,_newText];
	A3FL_Notes = [_notes,[],{_x select 0},"ASCEND"] call BIS_fnc_sortBy;
	profileNamespace setVariable [format["A3FL_Notes_%1",(player getVariable "character_id")], A3FL_Notes];
    saveProfileNamespace;
	[format[("STR_A3PL_Phone_YouSaved" call A3PL_Localize),_newName],Color_Green] call A3PL_Notification;
	closeDialog 0;
}] call compile_Global;

["A3PL_Phone_appGiveNote",
{
	disableSerialization;
	private _note = A3FL_CurrentNote;
	private _note = _note select 0;
	private _noteName = _note select 0;
	private _noteText = _note select 1;
	private _display = findDisplay 56400;
	private _control = _display displayCtrl 682617;
	if ((_control lbData (lbCurSel _control)) isEqualTo "") exitWith {[("STR_A3PL_Phone_YouNeedToSelectSomeone" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _targetcharID = _control lbData (lbCurSel _control);
	private _target = [_targetcharID] call A3PL_Lib_charIDToObject;
	[_noteName,_noteText] remoteExec ["A3PL_Phone_ReceiveNote",_target];
	[format[("STR_A3PL_Phone_YouGiveTo" call A3PL_Localize),_noteName],Color_Yellow] call A3PL_Notification;
	A3FL_CurrentNote = [];
	closeDialog 0;
}] call compile_Global;

["A3PL_Phone_ReceiveNote",
{
	disableSerialization;
	private _noteName = param[0,""];
	private _noteText = param[1,""];

	if(_noteName isEqualTo "") exitWith {};
	if(_noteText isEqualTo "") exitWith {};

	A3FL_Notes pushBack [_noteName, _noteText];
	[format[("STR_A3PL_Phone_YouReceived" call A3PL_Localize),_noteName],Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Phone_appCreateNote",
{
	private _display = findDisplay 56400;
	private _control = _display displayCtrl 682618;
	private _newName = ctrlText 682618;
	private _newText = ctrlText 682619;
	private _notes = A3FL_Notes;
	private _exists = false;

	if (_newName isEqualTo "") exitWith {[("STR_A3PL_Phone_EmptyName" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	{
		if (_newName IN (_x select 0)) exitWith {_exists = true; [("STR_A3PL_Phone_NameOfThisNoteAlreadyExist" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	} forEach A3FL_Notes;

	if (_exists) exitWith {};

	_notes pushback [_newName, _newText];
	A3FL_Notes = [_notes,[],{_x select 0},"ASCEND"] call BIS_fnc_sortBy;
	profileNamespace setVariable [format["A3FL_Notes_%1",(player getVariable "character_id")], A3FL_Notes];
    saveProfileNamespace;
	[format[("STR_A3PL_Phone_YouCreated" call A3PL_Localize),_newName],Color_Yellow] call A3PL_Notification;
	closeDialog 0;
}] call compile_Global;

["A3PL_Phone_SonyFD_appNote",
{
	disableSerialization;

	uiNamespace setVariable ['sonyp',17]; [] call A3PL_Phone_menuSonyP;

	private _notesName = param [0,"N/A"];
	private _display = findDisplay 38999;
	{
		private["_textBox","_control"];
		if (_notesName IN (_x select 0)) then {_textBox = _x select 1;};
		_control = _display displayCtrl 45172;
		_control ctrlSetText _notesName;

		_control = _display displayCtrl 45173;
		_control ctrlSetText _textBox;
	} forEach A3FL_NotesFD;
}] call compile_Global;

["A3PL_Phone_SonyFD_deleteNote",
{
	private _noteName = param[0,""];
	if (_noteName isEqualTo "") exitWith {["Someone was retarded and didnt call the function properly",Color_Red] call A3PL_Notification;};
	{
		if ((_x select 0) isEqualTo _noteName) exitWith {A3FL_NotesFD deleteAt _forEachIndex; closeDialog 0;};
	} forEach A3FL_NotesFD;
	profileNamespace setVariable [format["A3FL_NotesFD_%1",(player getVariable "character_id")], A3FL_Notes];
    saveProfileNamespace;
	[format[("STR_A3PL_Phone_YouRemovedTheNote" call A3PL_Localize),_noteName],Color_Yellow] call A3PL_Notification;
}] call compile_Global;

["A3PL_Phone_SonyFD_appSaveNote",
{
	disableSerialization;
	private ["_exists","_notes"];
	private _display = findDisplay 38999;
	private _control = _display displayCtrl 45172;
	private _newName = ctrlText 45172;
	private _newText = ctrlText 45173;
	private _notes = A3FL_NotesFD;
	_exists = false;
	{
		if ((_x select 0) isEqualTo _newName) then {A3FL_NotesFD deleteAt _forEachIndex;} else {A3FL_NotesFD deleteAt _forEachIndex;};
	} forEach A3FL_NotesFD;

	_notes pushBack [_newName,_newText];
	A3FL_NotesFD = [_notes,[],{_x select 0},"ASCEND"] call BIS_fnc_sortBy;
	profileNamespace setVariable [format["A3FL_NotesFD_%1",(player getVariable "character_id")], A3FL_NotesFD];
    saveProfileNamespace; 
	[format[("STR_A3PL_Phone_YouSaved" call A3PL_Localize),_newName],Color_Green] call A3PL_Notification;
	closeDialog 0;
}] call compile_Global;

["A3PL_Phone_SonyFD_appGiveNote",
{
	disableSerialization;
	private _note = A3FL_CurrentNoteFD;
	private _note = _note select 0;
	private _noteName = _note select 0;
	private _noteText = _note select 1;
	private _display = findDisplay 38999;
	private _control = _display displayCtrl 45170;
	if ((_control lbData (lbCurSel _control)) isEqualTo "") exitWith {[("STR_A3PL_Phone_YouNeedToSelectSomeone" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _targetcharID = _control lbData (lbCurSel _control);
	private _target = [_targetcharID] call A3PL_Lib_charIDToObject;
	[_noteName,_noteText] remoteExec ["A3PL_Phone_SonyFD_ReceiveNote",_target];
	[format[("STR_A3PL_Phone_YouGiveTo" call A3PL_Localize),_noteName],Color_Yellow] call A3PL_Notification;
	A3FL_CurrentNoteFD = [];
	closeDialog 0;
}] call compile_Global;

["A3PL_Phone_SonyFD_ReceiveNote",
{
	disableSerialization;
	private _noteName = param[0,""];
	private _noteText = param[1,""];

	if(_noteName isEqualTo "") exitWith {};
	if(_noteText isEqualTo "") exitWith {};

	A3FL_NotesFD pushBack [_noteName, _noteText];
	[format[("STR_A3PL_Phone_YouReceived" call A3PL_Localize),_noteName],Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Phone_SonyFD_appCreateNote",
{
	private _display = findDisplay 38999;
	private _control = _display displayCtrl 45168;
	private _newName = ctrlText 45168;
	private _newText = ctrlText 45169;
	private _notes = A3FL_NotesFD;
	private _exists = false;

	if (_newName isEqualTo "") exitWith {[("STR_A3PL_Phone_EmptyName" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	{
		if (_newName IN (_x select 0)) exitWith {_exists = true; [("STR_A3PL_Phone_NameOfThisNoteAlreadyExist" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	} forEach A3FL_NotesFD;

	if (_exists) exitWith {};

	_notes pushback [_newName, _newText];
	A3FL_NotesFD = [_notes,[],{_x select 0},"ASCEND"] call BIS_fnc_sortBy;
	profileNamespace setVariable [format["A3FL_NotesFD_%1",(player getVariable "character_id")], A3FL_NotesFD];
    saveProfileNamespace;
	[format[("STR_A3PL_Phone_YouCreated" call A3PL_Localize),_newName],Color_Yellow] call A3PL_Notification;
	closeDialog 0;
}] call compile_Global;

["A3PL_Phone_SonySD_appNote",
{
	disableSerialization;

	uiNamespace setVariable ['sony',17]; [] call A3PL_Phone_menuSony;

	private _notesName = param [0,"N/A"];
	private _display = findDisplay 32999;
	{
		private["_textBox","_control"];
		if (_notesName IN (_x select 0)) then {_textBox = _x select 1;};
		_control = _display displayCtrl 45172;
		_control ctrlSetText _notesName;

		_control = _display displayCtrl 45173;
		_control ctrlSetText _textBox;
	} forEach A3FL_NotesSD;
}] call compile_Global;

["A3PL_Phone_SonySD_deleteNote",
{
	private _noteName = param[0,""];
	if (_noteName isEqualTo "") exitWith {["Someone was retarded and didnt call the function properly",Color_Red] call A3PL_Notification;};
	{
		if ((_x select 0) isEqualTo _noteName) exitWith {A3FL_NotesSD deleteAt _forEachIndex; closeDialog 0;};
	} forEach A3FL_NotesSD;
	profileNamespace setVariable [format["A3FL_NotesSD_%1",(player getVariable "character_id")], A3FL_NotesSD];
    saveProfileNamespace;
	[format[("STR_A3PL_Phone_YouRemovedTheNote" call A3PL_Localize),_noteName],Color_Yellow] call A3PL_Notification;
}] call compile_Global;

["A3PL_Phone_SonySD_appSaveNote",
{
	disableSerialization;
	private ["_exists","_notes"];
	private _display = findDisplay 32999;
	private _control = _display displayCtrl 45172;
	private _newName = ctrlText 45172;
	private _newText = ctrlText 45173;
	private _notes = A3FL_NotesSD;
	_exists = false;
	{
		if ((_x select 0) isEqualTo _newName) then {A3FL_NotesSD deleteAt _forEachIndex;} else {A3FL_NotesSD deleteAt _forEachIndex;};
	} forEach A3FL_NotesSD;

	_notes pushBack [_newName,_newText];
	A3FL_NotesSD = [_notes,[],{_x select 0},"ASCEND"] call BIS_fnc_sortBy;
	profileNamespace setVariable [format["A3FL_NotesSD_%1",(player getVariable "character_id")], A3FL_NotesSD];
    saveProfileNamespace;
	[format[("STR_A3PL_Phone_YouSaved" call A3PL_Localize),_newName],Color_Green] call A3PL_Notification;
	closeDialog 0;
}] call compile_Global;

["A3PL_Phone_SonySD_appGiveNote",
{
	disableSerialization;
	private _note = A3FL_CurrentNoteSD;
	private _note = _note select 0;
	private _noteName = _note select 0;
	private _noteText = _note select 1;
	private _display = findDisplay 32999;
	private _control = _display displayCtrl 45170;
	if ((_control lbData (lbCurSel _control)) isEqualTo "") exitWith {[("STR_A3PL_Phone_YouNeedToSelectSomeone" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _targetcharID = _control lbData (lbCurSel _control);
	private _target = [_targetcharID] call A3PL_Lib_charIDToObject;
	[_noteName,_noteText] remoteExec ["A3PL_Phone_SonySD_ReceiveNote",_target];
	[format[("STR_A3PL_Phone_YouGiveTo" call A3PL_Localize),_noteName],Color_Yellow] call A3PL_Notification;
	A3FL_CurrentNoteSD = [];
	closeDialog 0;
}] call compile_Global;

["A3PL_Phone_SonySD_ReceiveNote",
{
	disableSerialization;
	private _noteName = param[0,""];
	private _noteText = param[1,""];

	if(_noteName isEqualTo "") exitWith {};
	if(_noteText isEqualTo "") exitWith {};

	A3FL_NotesSD pushBack [_noteName, _noteText];
	[format[("STR_A3PL_Phone_YouReceived" call A3PL_Localize),_noteName],Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Phone_SonySD_appCreateNote",
{
	private _display = findDisplay 32999;
	private _control = _display displayCtrl 45168;
	private _newName = ctrlText 45168;
	private _newText = ctrlText 45169;
	private _notes = A3FL_NotesSD;
	private _exists = false;

	if (_newName isEqualTo "") exitWith {[("STR_A3PL_Phone_EmptyName" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	{
		if (_newName IN (_x select 0)) exitWith {_exists = true; [("STR_A3PL_Phone_NameOfThisNoteAlreadyExist" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	} forEach A3FL_NotesSD;

	if (_exists) exitWith {};

	_notes pushback [_newName, _newText];
	A3FL_NotesSD = [_notes,[],{_x select 0},"ASCEND"] call BIS_fnc_sortBy;
	profileNamespace setVariable [format["A3FL_NotesSD_%1",(player getVariable "character_id")], A3FL_NotesSD];
    saveProfileNamespace;
	[format[("STR_A3PL_Phone_YouCreated" call A3PL_Localize),_newName],Color_Yellow] call A3PL_Notification;
	closeDialog 0;
}] call compile_Global;

["A3PL_Phone_SonyDOJ_appNote",
{
	disableSerialization;

	uiNamespace setVariable ['sonyp',17]; [] call A3PL_Phone_menuSonyP;

	private _notesName = param [0,"N/A"];
	private _display = findDisplay 58999;
	{
		private["_textBox","_control"];
		if (_notesName IN (_x select 0)) then {_textBox = _x select 1;};
		_control = _display displayCtrl 45172;
		_control ctrlSetText _notesName;

		_control = _display displayCtrl 45173;
		_control ctrlSetText _textBox;
	} forEach A3FL_NotesDOJ;
}] call compile_Global;

["A3PL_Phone_SonyDOJ_deleteNote",
{
	private _noteName = param[0,""];
	if (_noteName isEqualTo "") exitWith {["Someone was retarded and didnt call the function properly",Color_Red] call A3PL_Notification;};
	{
		if ((_x select 0) isEqualTo _noteName) exitWith {A3FL_NotesDOJ deleteAt _forEachIndex; closeDialog 0;};
	} forEach A3FL_NotesDOJ;
	profileNamespace setVariable [format["A3FL_NotesDOJ_%1",(player getVariable "character_id")], A3FL_NotesDOJ];
    saveProfileNamespace;
	[format[("STR_A3PL_Phone_YouRemovedTheNote" call A3PL_Localize),_noteName],Color_Yellow] call A3PL_Notification;
}] call compile_Global;

["A3PL_Phone_SonyDOJ_appSaveNote",
{
	disableSerialization;
	private ["_exists","_notes"];
	private _display = findDisplay 58999;
	private _control = _display displayCtrl 45172;
	private _newName = ctrlText 45172;
	private _newText = ctrlText 45173;
	private _notes = A3FL_NotesDOJ;
	_exists = false;
	{
		if ((_x select 0) isEqualTo _newName) then {A3FL_NotesDOJ deleteAt _forEachIndex;} else {A3FL_NotesDOJ deleteAt _forEachIndex;};
	} forEach A3FL_NotesDOJ;

	_notes pushBack [_newName,_newText];
	A3FL_NotesDOJ = [_notes,[],{_x select 0},"ASCEND"] call BIS_fnc_sortBy;
	profileNamespace setVariable [format["A3FL_NotesDOJ_%1",(player getVariable "character_id")], A3FL_NotesDOJ];
    saveProfileNamespace;
	[format[("STR_A3PL_Phone_YouSaved" call A3PL_Localize),_newName],Color_Green] call A3PL_Notification;
	closeDialog 0;
}] call compile_Global;

["A3PL_Phone_SonyDOJ_appGiveNote",
{
	disableSerialization;
	private _note = A3FL_CurrentNoteDOJ;
	private _note = _note select 0;
	private _noteName = _note select 0;
	private _noteText = _note select 1;
	private _display = findDisplay 58999;
	private _control = _display displayCtrl 45170;
	if ((_control lbData (lbCurSel _control)) isEqualTo "") exitWith {[("STR_A3PL_Phone_YouNeedToSelectSomeone" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _targetcharID = _control lbData (lbCurSel _control);
	private _target = [_targetcharID] call A3PL_Lib_charIDToObject;
	[_noteName,_noteText] remoteExec ["A3PL_Phone_SonyDOJ_ReceiveNote",_target];
	[format[("STR_A3PL_Phone_YouGiveTo" call A3PL_Localize),_noteName],Color_Yellow] call A3PL_Notification;
	A3FL_CurrentNoteDOJ = [];
	closeDialog 0;
}] call compile_Global;

["A3PL_Phone_SonyDOJ_ReceiveNote",
{
	disableSerialization;
	private _noteName = param[0,""];
	private _noteText = param[1,""];

	if(_noteName isEqualTo "") exitWith {};
	if(_noteText isEqualTo "") exitWith {};

	A3FL_NotesDOJ pushBack [_noteName, _noteText];
	[format[("STR_A3PL_Phone_YouReceived" call A3PL_Localize),_noteName],Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Phone_SonyDOJ_appCreateNote",
{
	private _display = findDisplay 58999;
	private _control = _display displayCtrl 45168;
	private _newName = ctrlText 45168;
	private _newText = ctrlText 45169;
	private _notes = A3FL_NotesDOJ;
	private _exists = false;

	if (_newName isEqualTo "") exitWith {[("STR_A3PL_Phone_EmptyName" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	{
		if (_newName IN (_x select 0)) exitWith {_exists = true; [("STR_A3PL_Phone_NameOfThisNoteAlreadyExist" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	} forEach A3FL_NotesDOJ;

	if (_exists) exitWith {};

	_notes pushback [_newName, _newText];
	A3FL_NotesDOJ = [_notes,[],{_x select 0},"ASCEND"] call BIS_fnc_sortBy;
	profileNamespace setVariable [format["A3FL_NotesDOJ_%1",(player getVariable "character_id")], A3FL_NotesDOJ];
    saveProfileNamespace;
	[format[("STR_A3PL_Phone_YouCreated" call A3PL_Localize),_newName],Color_Yellow] call A3PL_Notification;
	closeDialog 0;
}] call compile_Global;

["A3PL_Phone_bankSend",
{
	private["_display","_pBank"];
	disableSerialization;
	_display = findDisplay 56400;
	_pBank = player getVariable["Player_Bank",0];
	_cooldown = player getVariable["transferCooldown",nil];
	if(!isNil '_cooldown') exitWith {[("STR_A3PL_Phone_NeedToWait10MnToTransfer" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_control = _display displayCtrl 682571;
	_amount = round(parseNumber(ctrlText _control));
	if(_amount < 1) then {[("STR_A3PL_Phone_EnterValidAmount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if(_amount > _pBank) exitWith {[("STR_A3PL_Phone_YouDontHaveThisAmountInYourBankAccount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if(_amount > 250000) exitWith {[("STR_A3PL_Phone_YouCantTransferMoreThan250k" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_control = _display displayCtrl 682575;
	_sendTo = _control lbData (lbCurSel _control);

	if(_sendTo isEqualTo "") exitWith {[("STR_A3PL_Phone_YouNeedToSelectSomeone" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_sendToCompile = call compile _sendTo;

	if((_sendToCompile getVariable["name","unknown"]) isEqualTo "unknown") exitWith {["Could not complete transfer, please try again",Color_Red] call A3PL_Notification;};

	[getPlayerUID player,(player getVariable ["character_id",""]),"Phone_Bank_TransferSent",[format ["Sent To: %1 | Amount: %2 | PrevBalance: %3 | NewBalance: %4",(_sendToCompile getVariable ["name","unknown"]),_amount,(player getVariable ["player_bank",""]),((player getVariable ["player_bank",""])-_amount)]]] remoteExec ["Server_Log_New",2];
	[getPlayerUID _sendToCompile,(_sendToCompile getVariable ["character_id",""]),"Phone_Bank_TransferReceive",[format ["Received From: %1 | Amount: %2 | PrevBalance: %3 | NewBalance: %4",(player getVariable ["name","unknown"]),_amount,(_sendToCompile getVariable ["player_bank",""]),((_sendToCompile getVariable ["player_bank",""])+_amount)]]] remoteExec ["Server_Log_New",2];
	[player, 'Player_Bank', ((player getVariable 'Player_Bank') - _amount)] remoteExec ["Server_Core_ChangeVar",2];
	[format[("STR_A3PL_Phone_MoneyTransferDoneBasic" call A3PL_Localize), [_amount, 1, 0, true] call CBA_fnc_formatNumber, (_sendToCompile getVariable ["name","unknown"])],Color_Green] call A3PL_Notification;
	[_sendToCompile, 'Player_Bank', ((_sendToCompile getVariable 'Player_Bank') + _amount)] remoteExec ["Server_Core_ChangeVar",2];
	[format[("STR_A3PL_Phone_YouReceivedTransfer" call A3PL_Localize),_amount], Color_green] remoteExec ["A3PL_Notification",_sendToCompile];

	player setVariable["transferCooldown",true,false];
	[] spawn {
		sleep 600;
		player setVariable["transferCooldown",nil,false];
	};
}] call compile_Global;

["A3PL_Phone_onMegaphonePressed",
{
	if (player getVariable ["Cuffed",false] or player getVariable ["Zipped",false]) exitWith{};
	if !(typeOf (vehicle player) in (Config_FISD_Vehs + Config_FIFR_Vehs)) exitWith {};

	private _freq = (vehicle player) getVariable ["Megaphone",0];
	if (_freq isEqualTo 0) exitWith {[("STR_A3PL_Phone_MegaphoneNotActivated" call A3PL_Localize),Color_Red] spawn A3PL_Notification;};
	if (A3PL_Phone_inCall OR {A3PL_Phone_tryCall}) exitWith {[("STR_A3PL_Phone_YouCanCallAndUseMegaphoneAtSameTime" call A3PL_Localize),Color_Red] spawn A3PL_Notification;};

	private _freq = (vehicle player) getVariable ["Megaphone",0];
	[
		"", 
		format[
			"TANGENT_LR	PRESSED	%1%2	%3	%4	%5", 
			_freq, "_bluefor",
			10000  * (call TFAR_fnc_getTransmittingDistanceMultiplicator),
			"airborne",
			"a3pl_megaphone"
		]
	] call TFAR_fnc_processTangent;

	megaphone_speaking = true;

	[] spawn {
		for "_i" from 0 to 1 step 0 do {
			if !(megaphone_speaking) exitWith {};
			if((vehicle player) isEqualTo player) exitWith {[] call A3PL_Phone_onMegaphoneReleased;};
			if(!alive player) exitWith {[] call A3PL_Phone_onMegaphoneReleased;};
			sleep 0.2;
		};
	};
}] call compile_Global;

["A3PL_Phone_onMegaphoneReleased",
{
	if !(megaphone_speaking) exitWith {};

	private _freq = (vehicle player) getVariable ["Megaphone",0];

	[
		"",
		format [
			"TANGENT_LR	RELEASED	%1%2	%3	%4",
			_freq,
			"_bluefor",
			10000 * (call TFAR_fnc_getTransmittingDistanceMultiplicator), 
			"airborne"
		]
	] call TFAR_fnc_processTangent;

	megaphone_speaking = false;
}] call compile_Global;