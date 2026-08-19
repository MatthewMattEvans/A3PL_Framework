/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
devMode = true;
minifyFunctions = true;

//Antitheft shit, gross
ASAGNDJSN = true;
publicVariable "ASAGNDJSN";
SewuTL926P8Gnm9YUKYnDNhPtReUZ7 = true;
publicVariable "SewuTL926P8Gnm9YUKYnDNhPtReUZ7";

//sends string to rpt but makes it look pretty
compileLog = {
	params [["_msg", "", [""]]],
	private _tag = "A3PL:";
	private _length = 90;
	private _fillAmount = (floor((_length-(count _msg))/2))-(count _tag);
	if (_fillAmount < 0) then {_fillAmount = 0;};
	private _fill = "";
	for "_i" from 1 to _fillAmount do { _fill = _fill + "-" };
	private _bar = "";
	for "_i" from 1 to _length do { _bar = _bar + "-" };
	diag_log _bar;
	diag_log ([_fill, _tag, _msg, _fill] joinString " ");
	diag_log _bar;
};

codeToString = {
	params [
		["_functionName", "", [""]],
		["_code", {}, [{}]]
	];
	//Add script header
	[
		"private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'",
		_functionName,
		"'} else {_fnc_scriptName};private _fnc_scriptName = '",
		_functionName,
		"';scriptName _fnc_scriptName; ",
		(str(_code) select [1, (count(str(_code))-2)]) //Turn code block to string and removes brackets
	] joinString "";
};

compile_Global = {
	params [
		["_functionName", "", [""]],
		["_code", {}, [{}]]
	];

	_code = [_functionName, _code] call codeToString;

	if (devMode) then {
		call compile ([_functionName,"= compile", str _code, ";"] joinString " ");
	} else {
		call compile ([_functionName,"= compileFinal", str _code, ";"] joinString " ");
	};

	diag_log format ["A3PL: Compiled Global: %1", _functionName];
	_compileScriptsCount = _compileScriptsCount + 1;
	_totalCharCount = _totalCharCount + count _code;
	publicVariable _functionName;
};

compile_Server = {
	params [
		["_functionName", "", [""]],
		["_code", {}, [{}]]
	];

	_code = [_functionName, _code] call codeToString;

	if (devMode) then {
		call compile ([_functionName,"= compile", str _code, ";"] joinString " ");
	} else {
		call compile ([_functionName,"= compileFinal", str _code, ";"] joinString " ");
	};

	diag_log format ["A3PL: Compiled Server: %1", _functionName];
	_compileScriptsCount = _compileScriptsCount + 1;
	_totalCharCount = _totalCharCount + count _code;
};

[format["Arma Version: %1.%2",(productVersion#2)/100 toFixed 2,(productVersion#3)]] call compileLog;
[format["Arma Branch: %1",productVersion#4]] call compileLog;

["Starting Compiler"] call compileLog;
private _compileStartTime = diag_tickTime;
private _compileScriptsCount = 0;
private _totalCharCount = 0;

//execs each file
private _filesToRun = (addonFiles ["A3PL_Backend\", ".sqf"]);
_filesToRun sort true;
{
	if !("fn_compiler" in _x) then {
		[format ["Running - '%1'", _x]] call compileLog;
		call compileScript [_x];
	};
} forEach _filesToRun;

private _compileEndTime = diag_tickTime;
[format["Compiled %1 functions in (%2 seconds) - %3 Total Chars", _compileScriptsCount, (_compileEndTime - _compileStartTime), _totalCharCount]] call compileLog;

[] spawn {
	private _setupHandle = [] spawn Server_Setup_Init;

	if (isNil "_setupHandle") then {
		["A3PL ERROR: There was a problem spawning Server_Setup_Init"] call compileLog;
	} else {
		["Started Server_Setup_Init"] call compileLog;
		private _setupStartTime = diag_tickTime;
		waitUntil { scriptDone _setupHandle; };
		private _setupEndTime = diag_tickTime;
		[format["Finished Server_Setup_Init in (%1 seconds)", (_setupEndTime - _setupStartTime)]] call compileLog;
	};
};
