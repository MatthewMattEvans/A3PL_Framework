/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["Server_Phone_buyForfait", {
	params [
		["_charID","",[""]],
		["_mode",-1,[0]],
		["_unit",objNull,[objNull]]
	];
	if(_charID isEqualTo "" OR {_mode isEqualTo -1} OR {isNull _unit}) exitWith {};
	
	private _metod = 0;
	private _time = 0;

	private _queryResult = [format["SELECT offre, time FROM phone WHERE playerid='%1'",_charID],2] call Server_Database_Async;
	
	if (count(_queryResult) isEqualTo 0) then {
		_metod = 2;
	} else {
		_metod = 1;
		_time = _queryResult select 1;
	};
	
	private "_query";
	switch (_metod) do {
		case 1 : {
			switch (_mode) do {
				case 1 : {
					_time = _time + (60 * 24);
				};
				case 2 : {
					_time = _time + (60 * 24) * 3;
				};
				case 3 : {
					_time = _time + (60 * 24) * 7;
				};
				case 4 : {
					_time = _time + (60 * 24) * 14;
				};
			};
			_query = format["UPDATE phone SET offre='1', time='%1' WHERE playerid='%2'",_time,_charID];
		};
		case 2 : {
			switch (_mode) do {
				case 1 : {
					_time = (60 * 24);
				};
				case 2 : {
					_time = (60 * 24) * 3;
				};
				case 3 : {
					_time = (60 * 24) * 7;
				};
				case 4 : {
					_time = (60 * 24) * 14;
				};
			};
			_query = format["INSERT INTO phone (playerid, offre, time, contacts) VALUES ('%1', '1', '%2','""[]""')",_charID,_time];
			[_charID,_unit] spawn Server_Phone_createPhoneNumber;
		};
	};
	
	[_query,1] call Server_Database_Async;
	
	[_time] remoteExecCall ["A3PL_Phone_updateForfait",_unit];
}] call compile_Server;

["Server_Phone_countDownForfait", {
	for "_i" from 0 to 1 step 0 do {
		{
			private _number = _x getVariable ["phoneNumber",""];
			if !(_number isEqualTo "") then {
				private _result = [format["SELECT time FROM phone WHERE number='%1'",_number],2] call Server_Database_Async;
				if !(_result isEqualTo []) then {
					[_result select 0] remoteExecCall ["A3PL_Phone_updateForfait",_x];
				};
			};
		} forEach playableUnits;
	};
}] call compile_Server;

["Server_Phone_getForfait", {
	params [["_unit",objNull,[objNull]]];
	private _charID = (_unit getVariable ["character_id",""]);
	private _query = format ["SELECT time FROM phone WHERE playerid='%1'",_charID];
	private _result = [_query,2] call Server_Database_Async;
	if (_result isEqualTo []) then {
		_result = -1;
	} else {
		if (_result#0 > 0) then {
			_result = _result#0;
		} else {
			_result = -1;
		};
	};
	[_result] remoteExec ["A3PL_Phone_receiveForfait",_unit];
}] call compile_Server;

["Server_Phone_getPhoneNumber", {
	params [["_unit",objNull,[objNull]]];
	private _charID = (_unit getVariable ["character_id",""]);
	private _query = format ["SELECT number FROM phone WHERE playerid='%1'",_charID];
	private _result = [_query,2] call Server_Database_Async;
	private _finalResult = "";
    if (count _result > 0) then {
        _finalResult = _result#0;
    } else {
        _finalResult = "";  
    };
	[_finalResult] remoteExec ["A3PL_Phone_receivePhoneNumber",_unit];
}] call compile_Server;

["Server_Phone_getContacts", {
    params [["_unit", objNull, [objNull]]];
    private _charID = (_unit getVariable ["character_id",""]);
    private _query = format ["SELECT contacts FROM phone WHERE playerid='%1'", _charID];
    private _result = [_query, 2] call Server_Database_Async;
    private _finalResult = [];

    if (count _result > 0) then {
        private _rawContacts = _result select 0;
        private _fixedContacts = _rawContacts;
        _fixedContacts = toArray _fixedContacts;
        {
            if (_x == 96) then { 
                _fixedContacts set [_forEachIndex, 34];
            };
        } forEach _fixedContacts;
        _fixedContacts = toString _fixedContacts;
        _finalResult = call compile _fixedContacts;
    } else {
        _finalResult = [];
    };
    [_finalResult] remoteExec ["A3PL_Phone_receiveContacts", _unit];
}] call compile_Server;

["Server_Phone_createPhoneNumber", {
	params [
		["_charID","",[""]],
		["_unit",objNull,[objNull]]
	];
	
	_prefix = selectRandom ["555"];
	private _nbf = _prefix + format["%1%2%3%4%5%6%7", floor(random 10), floor(random 10), floor(random 10), floor(random 10), floor(random 10), floor(random 10), floor(random 10)];
	
	private _count = ([format["SELECT COUNT(*) FROM phone WHERE number='%1'",_nbf],2] call Server_Database_Async) select 0;
	
	if(_count isEqualTo 0) then {
		private _query = format["UPDATE phone SET number='%1' WHERE playerid='%2'",_nbf,_charID];
		[_query,1] call Server_Database_Async;
		_unit setVariable ["phoneNumber",_nbf];
		[_nbf] remoteExecCall ["A3PL_Phone_setPhoneNumber",_unit];
	} else {
		[_charID,_unit] spawn Server_Phone_createPhoneNumber;
	};
}] call compile_Server;

["Server_Phone_getMSGFromNumber", {
	params [
		["_number","",[""]]
	];
	if (_number isEqualTo "") exitWith {};
	
	private _query = format["SELECT expediteur, destinataire, message, insert_time FROM phone_sms WHERE destinataire='%1' AND anonyme = '0' OR expediteur='%1' AND anonyme = '0'",_number];
	private _queryResult = [_query,2,true] call Server_Database_Async;
	
	if (count(_queryResult) isEqualTo 0) then {
		_queryResult = [[]];
	} else {
		{
			_x set[2, toString(_x select 2)];
		} forEach _queryResult;
	};
	
	[2, _number, _queryResult] remoteExec ["A3PL_Phone_menuSMSSR", remoteExecutedOwner];
}] call compile_Server;

["Server_Phone_getUnitFromNumber", {
	params [
		["_texte","",[""]]
	];
	if (_texte isEqualTo "") exitWith {};
	
	A3PL_InspectTelTarget = playableUnits param [playableUnits findIf {(_x getVariable ["phoneNumber",""]) isEqualTo _texte}, objNull];
	(remoteExecutedOwner) publicVariableClient "A3PL_InspectTelTarget";
	A3PL_InspectTelTarget = "";
}] call compile_Server;

["Server_Phone_getUnitFromNumberSR", {
	params [
		["_number","",[""]]
	];
	if (_number isEqualTo "") exitWith {};
	
	private _query = format["SELECT expediteur, destinataire, position, insert_time FROM phone_call WHERE destinataire='%1' AND anonyme = '0' OR expediteur='%1' AND anonyme = '0'",_number];
	private _queryResult = [_query,2,true] call Server_Database_Async;
	
	if (count(_queryResult) isEqualTo 0) then {
		_queryResult = [[]];
	} else {
		{
			_x set[2, call compile format["%1", _x select 2]];
		} forEach _queryResult;
	};
	
	private _target = playableUnits param [playableUnits findIf {(_x getVariable ["phoneNumber",""]) isEqualTo _number}, objNull];
	
	[2, _queryResult, _number, _target] remoteExecCall ["A3PL_Phone_menuInspectTel", remoteExecutedOwner];
}] call compile_Server;

["Server_Phone_removeForfait", {
	params[
		["_charID","",[""]],
		["_unit",objNull,[objNull]]
	];
	if(_charID isEqualTo "" OR {isNull _unit}) exitWith {};
	
	[format["UPDATE phone SET offre='0' WHERE playerid='%1'",_charID],1] call Server_Database_Async;
	
	uiSleep 0.25;
	
	["CALL deleteOldForfait",1] call Server_Database_Async;
}] call compile_Server;

["Server_Phone_sendSmsPhone", {
	private _anonyme = _this select 0;
	private _numberExpediteur = _this select 1;
	private _numberCible = _this select 2;
	private _msg = _this select 3;
	if(isNil "_anonyme" OR {isNil "_numberExpediteur"} OR {isNil "_numberCible"} OR {isNil "_msg"}) exitWith {};

	private _length = count (toArray(_numberCible));
	if !(_length isEqualTo 10) exitWith {};
	private _queryresult = [format["SELECT number FROM phone WHERE number='%1'",_numberCible],2] call Server_Database_Async;
	if((count _queryresult) isEqualTo 0) exitWith {};

	private _msgbin = toArray _msg;
	[format["INSERT INTO phone_sms (anonyme, expediteur, destinataire, message) VALUES('%1','%2','%3','%4')",_anonyme,_numberExpediteur,_numberCible,_msgbin],1] call Server_Database_Async;

	{
		private _numberunit = _x getVariable ["phoneNumber",""];
		if(_numberunit isEqualTo _numberCible && {!(isNull _x)}) exitWith {
			[_anonyme,_numberExpediteur,_msg] remoteExecCall ["A3PL_Phone_receptionSmsPhone",_x];
		};
	} forEach playableUnits;
}] call compile_Server;

["Server_Phone_updateContactsPhone", {
	params [
		["_contacts",[],[[]]],
		["_charID","",[""]]
	];
	if (_charID isEqualTo "") exitWith {};
	
	_contacts = [_contacts] call Server_Database_mresArray;

	[format["UPDATE phone SET contacts='%1' WHERE playerid='%2'",_contacts,_charID],1] call Server_Database_Async;
}] call compile_Server;

["Server_Phone_callSystem", {
	params [
		["_Anonyme",false,[false]],
		["_playerNumber","",[""]],
		["_cibleNumber","",[""]],
		["_unit",objNull,[objNull]]
	];
	
	if(_playerNumber isEqualTo "" OR {_cibleNumber isEqualTo ""} OR {isNull _unit}) exitWith {};
	
	[format["INSERT INTO phone_call (anonyme, expediteur, destinataire, position) VALUES('%1','%2','%3','%4')",parseNumber(_Anonyme),_playerNumber,_cibleNumber,str(getPos _unit)],1] call Server_Database_Async;
	
	//CENTRAL D'APPEL
	if(_cibleNumber isEqualTo "911") exitWith {
		[("STR_Common_FISD" call A3PL_Localize),("STR_Server_Phone_CallSystem_911Call" call A3PL_Localize),getPos _unit,format[("STR_Server_Phone_CallSystem_TryToCall911" call A3PL_Localize),_playerNumber],("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
		[_unit,_playerNumber,_Anonyme,_cibleNumber] spawn Server_Phone_centralSystem;
	};

	if(_cibleNumber isEqualTo "912") exitWith {
		[("STR_Common_FIFR" call A3PL_Localize),("STR_Server_Phone_CallSystem_911Call" call A3PL_Localize),getPos _unit,format[("STR_Server_Phone_CallSystem_TryToCall911" call A3PL_Localize),_playerNumber],("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
		[_unit,_playerNumber,_Anonyme,_cibleNumber] spawn Server_Phone_centralSystem;
	};

	if(_cibleNumber isEqualTo "913") exitWith {
		[("STR_Common_DOJ" call A3PL_Localize),("STR_Server_Phone_CallSystem_911Call" call A3PL_Localize),getPos _unit,format[("STR_Server_Phone_CallSystem_TryToCall911" call A3PL_Localize),_playerNumber],("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
		[_unit,_playerNumber,_Anonyme,_cibleNumber] spawn Server_Phone_centralSystem;
	};
	
	//On cherche le joueur qu'on appel
	private _cible = playableUnits param [playableUnits findIf {(_x getVariable ["phoneNumber",""]) isEqualTo _cibleNumber}, objNull];
	if(isNull _cible) exitWith {};

	//On vérifie si la personne est capable de recevoir un appel.
	if !(_cible getVariable ["call_info",0] isEqualTo 0) exitWith {}; //Plus tard: Exit sur un ajout dans l'historique.
	
	//On parametre les variables
	_unit setVariable ["call_info",2,true]; //Lancement de l'appel
	_cible setVariable ["call_info",1,true]; //Recoit l'appel
	
	//On envoit l'appel a la cible.
	[_Anonyme,_playerNumber] remoteExec ["A3PL_Phone_ringPlayer",_cible];
	
	for "_i" from 0 to 1 step 0 do {
		if(isNull _unit OR {isNull _cible}) exitWith {};
		if(_unit getVariable ["call_info",0] isEqualTo 0) exitWith {};
		if(_cible getVariable ["call_info",0] isEqualTo 0) exitWith {};
		if((_cible getVariable ["call_info",0]) isEqualTo (_unit getVariable ["call_info",0])) exitWith {
			//On lance l'appel
			[_unit,_cible] spawn Server_Phone_inCallSystem;
		};
		uiSleep 0.01;
	};
}] call compile_Server;

["Server_Phone_centralSystem", {
	params [
		["_unit",objNull,[objNull]],
		["_playerNumber","",[""]],
		["_Anonyme",false,[false]],
		["_cible","",[""]]
	];
	if(isNull _unit OR {_playerNumber isEqualTo ""}) exitWith {};
		
	_unit setVariable ["call_info",1,true]; //En attente dans le central
	
	private _callID = random[10000000,50000000,99999999]; //ID de l'appel (frequence TFAR)
	_unit setVariable [format["central_%1_data",_cible],[_callID,_Anonyme,_playerNumber,_unit],true]; //data central
	
	private _attente = 0;
	for "_i" from 0 to 1 step 0 do {
		if(isNull _unit) exitWith {};
		if(_unit getVariable ["call_info",0] isEqualTo 0) exitWith {}; //Il a annulé l'appel.
		if(_unit getVariable ["call_info",0] isEqualTo 1) then { //En attente.
			_attente = _attente + 0.025;
			_unit setVariable ["central_time",floor(_attente),true]; //On set le temps d'attente avant prise en charge.
		};
		uiSleep 0.01;
	};
	
	//L'hote a annuler l'appel ou est déconnecté.
	if(isNull _unit OR {_unit getVariable ["call_info",0] isEqualTo 0}) then {
		//On reset les variables liées au central d'appel.
		if !(isNull _unit) then {
			_unit setVariable [format["central_%1_data",_cible],[],true];
			_unit setVariable ["central_time",0,true];
		};
		private _units = playableUnits select {_x getVariable ["central_id",0] isEqualTo _callID};
		if(count(_units) > 0) then {
			// On ferme à toutes les personnes qui sont sur l'appel.
			[] remoteExecCall ["A3PL_Phone_endCall",_units];
		};
	};
}] call compile_Server;

["Server_Phone_inCallSystem", {
	params [
		["_player1",objNull,[objNull]],
		["_player2",objNull,[objNull]]
	];
	if(isNull _player1 OR {isNull _player2}) exitWith {};
	
	//Start call
	private _callID = random[10000000,50000000,99999999];
	[_callID] remoteExec ["A3PL_Phone_callInProgress",_player1];
	[_callID] remoteExec ["A3PL_Phone_callInProgress",_player2];
	
	for "_i" from 0 to 1 step 0 do {
		if(isNull _player1 OR {isNull _player2}) exitWith {};
		if(_player1 getVariable ["call_info",0] isEqualTo 0) exitWith {};
		if(_player2 getVariable ["call_info",0] isEqualTo 0) exitWith {};
		uiSleep 0.01;
	};
	
	if(isNull _player1 OR {_player1 getVariable ["call_info",0] isEqualTo 0}) exitWith {
		if !(isNull _player2) then {
			[] remoteExecCall ["A3PL_Phone_endCall",_player2];
		};
	};
	if(isNull _player2 OR {_player2 getVariable ["call_info",0] isEqualTo 0}) exitWith {
		if !(isNull _player1) then {
			[] remoteExecCall ["A3PL_Phone_endCall",_player1];
		};
	};
}] call compile_Server;

["Server_Phone_joinCentral", {
	params [
		["_caller",objNull,[objNull]],
		["_unit",objNull,[objNull]],
		["_callID",0,[0]],
		["_central","",[""]]
	];
	if(isNull _caller OR {isNull _unit} OR {_central isEqualTo ""}) exitWith {};
	
	//L'appel a déjà été annulé.
	if(_caller getVariable ["call_info",0] isEqualTo 0) exitWith {}; //Texte: Appel n'est plus actif.
	if(count(_caller getVariable [format["central_%1_data",_central],[]]) isEqualTo 0) exitWith {}; //Texte: Appel n'est plus actif.
	
	//L'appel est en cours, on fait rejoindre la fréquence.
	if(_caller getVariable ["call_info",0] isEqualTo 2) exitWith {
		_unit setVariable ["call_info",2,true];
		_unit setVariable ["central_id",_callID,true];
		[_callID,true] remoteExec ["A3PL_Phone_callInProgress",_unit];
	};
	
	//L'appel est en attente, on lance la communication.
	if(_caller getVariable ["call_info",0] isEqualTo 1) exitWith {
		//On lance l'appel du joueur.
		_caller setVariable ["call_info",2,true];
		[_callID] remoteExec ["A3PL_Phone_callInProgress",_caller];
	
		//On lance l'appel du Gendarme/Pompier.
		_unit setVariable ["call_info",2,true];
		_unit setVariable ["central_id",_callID,true];
		[_callID,true] remoteExec ["A3PL_Phone_callInProgress",_unit];
	};
}] call compile_Server;



/////////////////////////////
/// iPhone
/////////////////////////////



["Server_Phone_deleteSmsiPhone", {
	private _id = _this select 0;
	private _unit = _this select 1;
	private _destinataire = _this select 2;

	private _query = format["UPDATE phone_sms SET active='0' WHERE id='%1'",_id];
	[_query,1] call Server_Database_Async;
	uiSleep 0.3;
	_query = format["SELECT anonyme, expediteur, message, id FROM phone_sms WHERE destinataire='%1' AND active='1'",_destinataire];
	private _queryResult = [_query,2,true] call Server_Database_Async;

	if(count (_queryResult) isEqualTo 0) then {
		_queryResult = [];
	} else {
		_queryResult = _queryResult;
		{
			_x set[2,toString(_x select 2)];
		} forEach _queryResult;
	};
	[_queryResult] remoteExec ["A3PL_Phone_updateSmsiPhone",_unit];
}] call compile_Server;

["Server_Phone_loadSmsiPhone", {
	private _mynumber = _this select 0;
	private _unit = _this select 1;

	private _query = format["SELECT anonyme, expediteur, message, id FROM phone_sms WHERE destinataire='%1' AND active='1'",_mynumber];
	private _queryResult = [_query,2,true] call Server_Database_Async;

	if(count (_queryResult) isEqualTo 0) then {
		_queryResult = [];
	} else {
		_queryResult = _queryResult;
		{
			_x set[2,toString(_x select 2)];
		} forEach _queryResult;
	};
	[_queryResult] remoteExec ["A3PL_Phone_updateSmsiPhone",_unit];
}] call compile_Server;




/////////////////////////////
/// Nokia
/////////////////////////////



["Server_Phone_deleteSmsNokia", {
	private _id = _this select 0;
	private _unit = _this select 1;
	private _destinataire = _this select 2;

	private _query = format["UPDATE phone_sms SET active='0' WHERE id='%1'",_id];
	[_query,1] call Server_Database_Async;
	uiSleep 0.3;
	_query = format["SELECT anonyme, expediteur, message, id FROM phone_sms WHERE destinataire='%1' AND active='1'",_destinataire];
	private _queryResult = [_query,2,true] call Server_Database_Async;

	if(count (_queryResult) isEqualTo 0) then {
		_queryResult = [];
	} else {
		_queryResult = _queryResult;
		{
			_x set[2,toString(_x select 2)];
		} forEach _queryResult;
	};

	[_queryResult] remoteExec ["A3PL_Phone_updateSmsNokia",_unit];
}] call compile_Server;

["Server_Phone_loadSmsNokia", {
	private _mynumber = _this select 0;
	private _unit = _this select 1;

	private _query = format["SELECT anonyme, expediteur, message, id FROM phone_sms WHERE destinataire='%1' AND active='1'",_mynumber];
	private _queryResult = [_query,2,true] call Server_Database_Async;

	if(count (_queryResult) isEqualTo 0) then {
		_queryResult = [];
	} else {
		_queryResult = _queryResult;
		{
			_x set[2,toString(_x select 2)];
		} forEach _queryResult;
	};

	[_queryResult] remoteExec ["A3PL_Phone_updateSmsNokia",_unit];
}] call compile_Server;




/////////////////////////////
/// Sony
/////////////////////////////




["Server_Phone_deleteSmsSony", {
	private _id = _this select 0;
	private _unit = _this select 1;
	private _destinataire = _this select 2;

	private _query = format["UPDATE phone_sms SET active='0' WHERE id='%1'",_id];
	[_query,1] call Server_Database_Async;
	uiSleep 0.3;
	_query = format["SELECT anonyme, expediteur, message, id FROM phone_sms WHERE destinataire='%1' AND active='1'",_destinataire];
	private _queryResult = [_query,2,true] call Server_Database_Async;

	if(count (_queryResult) isEqualTo 0) then {
		_queryResult = [];
	} else {
		_queryResult = _queryResult;
		{
			_x set[2,toString(_x select 2)];
		} forEach _queryResult;
	};
	[_queryResult] remoteExec ["A3PL_Phone_updateSmsSony",_unit];
}] call compile_Server;

["Server_Phone_loadCopCentral", {
	params [
		["_cop",objNull,[objNull]]
	];
	if(isNull _cop) exitWith {};

	private _data1 = [];
	{
		if(count(_x getVariable ["central_911_data",[]]) > 0 && {_x getVariable ["call_info",0] isEqualTo 1}) then {
			_data1 pushBack [_x getVariable ["central_911_data",[]],_x getVariable ["central_time",0]];
		};
	} forEach playableUnits;

	private _data2 = [];
	{
		if(count(_x getVariable ["central_911_data",[]]) > 0 && {_x getVariable ["call_info",0] isEqualTo 2}) then {
			private _callID = (_x getVariable ["central_911_data",[]]) select 0;
			private _count = {_x getVariable ["central_id",0] isEqualTo _callID} count playableUnits;
			_data2 pushBack [_x getVariable ["central_911_data",[]],_count];
		};
	} forEach playableUnits;

	[_data1,_data2] remoteExecCall ["A3PL_Phone_SonyLoadCentral",_cop];
}] call compile_Server;

["Server_Phone_loadSmsSony", {
	private _mynumber = _this select 0;
	private _unit = _this select 1;

	private _query = format["SELECT anonyme, expediteur, message, id FROM phone_sms WHERE destinataire='%1' AND active='1'",_mynumber];
	private _queryResult = [_query,2,true] call Server_Database_Async;

	if(count (_queryResult) isEqualTo 0) then {
		_queryResult = [];
	} else {
		_queryResult = _queryResult;
		{
			_x set[2,toString(_x select 2)];
		} forEach _queryResult;
	};
	[_queryResult] remoteExec ["A3PL_Phone_updateSmsSony",_unit];
}] call compile_Server;





/////////////////////////////
/// SonyP
/////////////////////////////




["Server_Phone_deleteSmsSonyP", {
	private _id = _this select 0;
	private _unit = _this select 1;
	private _destinataire = _this select 2;

	private _query = format["UPDATE phone_sms SET active='0' WHERE id='%1'",_id];
	[_query,1] call Server_Database_Async;
	uiSleep 0.3;
	_query = format["SELECT anonyme, expediteur, message, id FROM phone_sms WHERE destinataire='%1' AND active='1'",_destinataire];
	private _queryResult = [_query,2,true] call Server_Database_Async;

	if(count (_queryResult) isEqualTo 0) then {
		_queryResult = [];
	} else {
		_queryResult = _queryResult;
		{
			_x set[2,toString(_x select 2)];
		} forEach _queryResult;
	};
	[_queryResult] remoteExec ["A3PL_Phone_updateSmsSonyP",_unit];
}] call compile_Server;

["Server_Phone_loadMedCentral", {
	params [
		["_med",objNull,[objNull]]
	];
	if(isNull _med) exitWith {};

	private _data1 = [];
	{
		if(count(_x getVariable ["central_912_data",[]]) > 0 && {_x getVariable ["call_info",0] isEqualTo 1}) then {
			_data1 pushBack [_x getVariable ["central_912_data",[]],_x getVariable ["central_time",0]];
		};
	} forEach playableUnits;

	private _data2 = [];
	{
		if(count(_x getVariable ["central_912_data",[]]) > 0 && {_x getVariable ["call_info",0] isEqualTo 2}) then {
			private _callID = (_x getVariable ["central_912_data",[]]) select 0;
			private _count = {_x getVariable ["central_id",0] isEqualTo _callID} count playableUnits;
			_data2 pushBack [_x getVariable ["central_912_data",[]],_count];
		};
	} forEach playableUnits;

	[_data1,_data2] remoteExecCall ["A3PL_Phone_SonyPLoadCentral",_med];
}] call compile_Server;

["Server_Phone_loadSmsSonyP", {
	private _mynumber = _this select 0;
	private _unit = _this select 1;

	private _query = format["SELECT anonyme, expediteur, message, id FROM phone_sms WHERE destinataire='%1' AND active='1'",_mynumber];
	private _queryResult = [_query,2,true] call Server_Database_Async;

	if(count (_queryResult) isEqualTo 0) then {
		_queryResult = [];
	} else {
		_queryResult = _queryResult;
		{
			_x set[2,toString(_x select 2)];
		} forEach _queryResult;
	};
	[_queryResult] remoteExec ["A3PL_Phone_updateSmsSonyP",_unit];
}] call compile_Server;




/////////////////////////////
/// SonyDOJ
/////////////////////////////




["Server_Phone_deleteSmsSonyDOJ", {
	private _id = _this select 0;
	private _unit = _this select 1;
	private _destinataire = _this select 2;

	private _query = format["UPDATE phone_sms SET active='0' WHERE id='%1'",_id];
	[_query,1] call Server_Database_Async;
	uiSleep 0.3;
	_query = format["SELECT anonyme, expediteur, message, id FROM phone_sms WHERE destinataire='%1' AND active='1'",_destinataire];
	private _queryResult = [_query,2,true] call Server_Database_Async;

	if(count (_queryResult) isEqualTo 0) then {
		_queryResult = [];
	} else {
		_queryResult = _queryResult;
		{
			_x set[2,toString(_x select 2)];
		} forEach _queryResult;
	};
	[_queryResult] remoteExec ["A3PL_Phone_updateSmsSonyDOJ",_unit];
}] call compile_Server;

["Server_Phone_loadDOJCentral", {
	params [
		["_med",objNull,[objNull]]
	];
	if(isNull _med) exitWith {};

	private _data1 = [];
	{
		if(count(_x getVariable ["central_913_data",[]]) > 0 && {_x getVariable ["call_info",0] isEqualTo 1}) then {
			_data1 pushBack [_x getVariable ["central_913_data",[]],_x getVariable ["central_time",0]];
		};
	} forEach playableUnits;

	private _data2 = [];
	{
		if(count(_x getVariable ["central_913_data",[]]) > 0 && {_x getVariable ["call_info",0] isEqualTo 2}) then {
			private _callID = (_x getVariable ["central_913_data",[]]) select 0;
			private _count = {_x getVariable ["central_id",0] isEqualTo _callID} count playableUnits;
			_data2 pushBack [_x getVariable ["central_913_data",[]],_count];
		};
	} forEach playableUnits;

	[_data1,_data2] remoteExecCall ["A3PL_Phone_SonyDOJLoadCentral",_med];
}] call compile_Server;

["Server_Phone_loadSmsSonyDOJ", {
	private _mynumber = _this select 0;
	private _unit = _this select 1;

	private _query = format["SELECT anonyme, expediteur, message, id FROM phone_sms WHERE destinataire='%1' AND active='1'",_mynumber];
	private _queryResult = [_query,2,true] call Server_Database_Async;

	if(count (_queryResult) isEqualTo 0) then {
		_queryResult = [];
	} else {
		_queryResult = _queryResult;
		{
			_x set[2,toString(_x select 2)];
		} forEach _queryResult;
	};
	[_queryResult] remoteExec ["A3PL_Phone_updateSmsSonyDOJ",_unit];
}] call compile_Server;



/////////////////////////////
/// Fish Jobs
/////////////////////////////




["Server_Phone_FishJobs_Init",
{
	private _DatabasePhoneFishJobs = ["SELECT * FROM phone_fishjobs WHERE active = 1 AND time > 0", 2, true] call Server_Database_Async;
	Server_Phone_FishJobs = [];
	{
		private _id = _x#0;
		private _title = _x#1;
		private _description = _x#2;
		private _phone = _x#3;
		private _email = _x#4;
		private _time = _x#5;
		private _active = _x#6;
		Server_Phone_FishJobs pushBack [_id,_title,_description,_phone,_email,_time,_active];
	} forEach _DatabasePhoneFishJobs;
	publicVariable "Server_Phone_FishJobs";
}] call compile_Server;

["Server_Phone_FishJobs_Update",
{
    ["UPDATE phone_fishjobs SET time = time - 1 WHERE active = 1 AND time > 0", 1] call Server_Database_Async;
    ["UPDATE phone_fishjobs SET active = 0 WHERE time = 0", 1] call Server_Database_Async;
    [] spawn Server_Phone_FishJobs_Init;
}] call compile_Server;

["Server_Phone_FishJobs_Create",
{
	params ["_title", "_description", "_phone", "_email", "_time"];

	private _query = format [
        "INSERT INTO phone_fishjobs (title, description, phone, email, time, active) VALUES ('%1', '%2', '%3', '%4', %5, 1)",
        _title, _description, _phone, _email, _time
    ];
    [_query, 1] call Server_Database_Async;

	[] spawn Server_Phone_FishJobs_Init;
}] call compile_Server;