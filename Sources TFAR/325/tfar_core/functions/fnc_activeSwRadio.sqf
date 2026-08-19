#include "script_component.hpp"

/*
  Name: TFAR_fnc_activeSwRadio

  Author: NKey
    returns the active SR radio

  Arguments:
    None

  Return Value:
    active SR radio <STRING>

  Example:
    call TFAR_fnc_activeSwRadio;

  Public: Yes
*/

private _result = nil;
{
  if (_x call TFAR_fnc_isRadio) exitWith {_result = _x};
	if ((_x find "a3pl_3310") > -1) exitWith {_result = _x};
	if ((_x find "a3pl_iphone") > -1) exitWith {_result = _x};
	if ((_x find "a3pl_sonySD") > -1) exitWith {_result = _x};
	if ((_x find "a3pl_sonyFD") > -1) exitWith {_result = _x};
	if ((_x find "a3pl_sonyDOJ") > -1) exitWith {_result = _x};
    true;
} count (assignedItems TFAR_currentUnit);
if (isNil "_result") then {_result = ""};
_result
