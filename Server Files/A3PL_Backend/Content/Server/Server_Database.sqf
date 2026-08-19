/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
['Server_Database_NumberSafe', {
	params [
		["_nmb",0,[0]]
	];

	private "_return";
	if !(_nmb isEqualTo (floor _nmb)) then {
		private _decimals = 6;
		private _nmbstr = str _nmb;
		private _index = _nmbstr find ".";
		if (_index > -1) then {
			_decimals = count (_nmbstr select [_index]);
		};
		_return =_nmb toFixed 6;
	} else {
		_return = _nmb toFixed 0;
	};

	_return
}] call compile_Server;

['Server_Database_ToArray', {
  	private _array = param [0,""];
	
	if(_array isEqualTo "") exitWith {[]};
	if(_array isEqualType 0) then {_array = str _array;};
	_array = toArray(_array);

	for "_i" from 0 to (count _array)-1 do
	{
		_sel = _array select _i;
		if(_sel == 96) then
		{
			_array set[_i,39];
		};
	};

	_array = toString(_array);
	_array = call compile format["%1", _array];
	_array;
}] call compile_Server;

['Server_Database_Array',
{
	private["_array"];
	_array = param [0,[]];
	_array = str _array;
	_array = toArray(_array);

	for "_i" from 0 to (count _array)-1 do
	{
		_sel = _array select _i;
		if((_i != 0 && _i != ((count _array)-1))) then
		{
			if(_sel == 34) then
			{
				_array set[_i,96];
			};
		};
	};

	toString(_array);
}] call compile_Server;

['Server_Database_mresArray',
{
	params [
		["_array",[],[[]]]
	];
	_array = toArray(str _array);
	private _count = (count _array) - 1;
	
	for "_i" from 0 to _count do {
		_sel = _array select _i;
		if (!(_i isEqualTo 0) && {!(_i isEqualTo _count)} && {_sel isEqualTo 34}) then {
			_array set[_i,96];
		};
	};
	
	str(toString(_array));
}] call compile_Server;

['Server_Database_Setup', {
	private ['_return', '_result', '_randomNumber', '_extDBCustomID', '_dbKey'];
  params [
    ["_database","",[""]],
    ["_protocol","",[""]],
    ["_protocolOptions","",[""]]
  ];
	_return = false;

	// Create unique key for each database
	_dbKey = format["extDBCustomID_%1", _database];

	if ( isNil {uiNamespace getVariable _dbKey} ) then {
		// extDB Version (only check once)
		if ( isNil {uiNamespace getVariable "extDB3_Initialized"} ) then {
			_result = "extDB3" callExtension "9:VERSION";
			diag_log format ["extDB3: Version: %1", _result];
			if(_result == "") exitWith {diag_log "extDB3: Failed to Load"; false};
			uiNamespace setVariable ["extDB3_Initialized", true];
		};

		// extDB Connect to Database
		_result = call compile ("extDB3" callExtension format["9:ADD_DATABASE:%1", _database]);

		if (_result select 0 isEqualTo 0) exitWith {
				diag_log format ["extDB3: Error Database %2: %1", _result, _database];
				false
		};

		diag_log format ["extDB3: Connected to Database: %1", _database];

		// Generate Randomized Protocol Name
		_randomNumber = round(random(999999));
		_extDBCustomID = str(_randomNumber);

		// extDB Load Protocol
		_result = call compile ("extDB3" callExtension format["9:ADD_DATABASE_PROTOCOL:%1:%2:%3:%4", _database, _protocol, _extDBCustomID, _protocolOptions]);

		if ((_result select 0) isEqualTo 0) exitWith {
				diag_log format ["extDB3: Error Database Setup %3: %1 %2", _result, _database, _protocol];
				false
		};

		diag_log format ["extDB3: Initialized %1 Protocol for %2", _protocol, _database];

		// Save Randomized ID for this specific database
		uiNamespace setVariable [_dbKey, _extDBCustomID];

		// Maintain backward compatibility - set main database ID
		if (_database isEqualTo "Database") then {
			extDBCustomID = compileFinal _extDBCustomID;
			uiNamespace setVariable ["extDBCustomID", _extDBCustomID];
		};

		_return = true;
	} else {
		diag_log format ["extDB3: Database %1 Already Setup", _database];
		_return = true;
	};
	_return
}] call compile_Server;

//COMPILE BLOCK FUNCTION!!!
['Server_Database_Async', {
	private["_queryResult","_key","_return","_loop","_dbID"];
	params [["_queryStmt","",[""]],["_mode",1,[0]],["_multiarr",false,[false]],["_database","Database",[""]]];

	// Get the correct database ID
	if (_database isEqualTo "Database") then {
		_dbID = call extDBCustomID; // Backward compatibility
	} else {
		private _dbKey = format["extDBCustomID_%1", _database];
		private _storedID = uiNamespace getVariable _dbKey;
		if (isNil "_storedID") exitWith {
			diag_log format ["extDB3: Database %1 not initialized", _database];
			[]
		};
		_dbID = _storedID;
	};

	_key = "extDB3" callExtension format["%1:%2:%3", _mode, _dbID, _queryStmt];

	if(_mode isEqualTo 1) exitWith {true};

	_key = call compile format["%1",_key];
	_key = _key select 1;

	_queryResult = "";
	_loop = true;
	while{_loop} do {
		_queryResult = "extDB3" callExtension format["4:%1", _key];
		if (_queryResult isEqualTo "[5]") then {
			// extDB3 returned that result is Multi-Part Message
			_queryResult = "";
			while{true} do {
				_pipe = "extDB3" callExtension format["5:%1", _key];
				if(_pipe == "") exitWith {_loop = false};
				_queryResult = _queryResult + _pipe;
			};
		} else {
			if (_queryResult isEqualTo "[3]") then {
				//diag_log format ["extDB3: uiSleep [4]: %1", diag_tickTime];
				//uiSleep 0.1;
			} else {
				_loop = false;
			};
		};
	};

	_queryResult = call compile _queryResult;

	if((_queryResult select 0) isEqualTo 0) exitWith {diag_log format ["extDB3: Protocol Error on %2: %1", _queryResult, _database]; []};
	_return = _queryResult select 1;

	if(!_multiarr && count _return > 0) then {
		_return = _return select 0;
	};

	_return;
}] call compile_Server;

['Server_Database_EsapeString', {
  private _string = param [0,"",[""]];
	private _filter = ["'","/","`",":","|",";",",","{","}","-","<",">","&"];
	private _string = toArray _string;
	private _del = [];
	{
		if (_x in _filter) then {_del pushback _forEachIndex;};
	} forEach _string;
	{
		_string deleteAt (_x - _forEachIndex);
	} foreach _del;
	toString _string;
}] call compile_Server;


// [[123,123]] call Server_Database_ArrayToSqlIN
// returns: "(123,123)"
//COMPILE BLOCK FUNCTIONS WARNING!!
["Server_Database_ArrayToSqlIN",
{
	private ["_return","_input","_return"];
	_input = param [0,""];
	_input = call compile (format ["%1",_input]);

	_return = toArray (format ["%1",_input]);
	_input = toArray (format ["%1",_input]);

	{
		if (_x == 91) then
		{
			_return set [_forEachIndex,40];
		};
		if (_x == 93) then
		{
			_return set [_forEachIndex,41];
		};
	} foreach _input;
	_return = toString _return;
	_return;
}] call compile_Server;
