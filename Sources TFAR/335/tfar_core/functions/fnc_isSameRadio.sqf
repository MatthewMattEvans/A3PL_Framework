#include "script_component.hpp"

/*
  Name: TFAR_fnc_isSameRadio

  Author: Garth de Wet (L-H)
    Checks whether the two passed radios have the same prototype radio

  Arguments:
    0: radio classname <STRING>
    1: radio classname <STRING>

  Return Value:
    same parent radio <BOOL>

  Example:
    if([(call TFAR_fnc_activeSwRadio), "TFAR_fadak"] call TFAR_fnc_isSameRadio) then {
        hint "same parent radio";
    };

  Public: Yes
*/

params ["_radio1", "_radio2"];

if !(_radio1 call TFAR_fnc_isPrototypeRadio) then {
    _radio1 = configName (inheritsFrom (configFile >> "CfgWeapons" >> _radio1));
};
if !(_radio2 call TFAR_fnc_isPrototypeRadio) then {
    _radio2 = configName (inheritsFrom (configFile >> "CfgWeapons" >> _radio2));
};
if (_radio1 in ["a3pl_3310_1","a3pl_iphone_1","a3pl_sonySD_1","a3pl_sonyFD_1","a3pl_sonyDOJ_1"]) then {
  private _temp = _radio1 splitString "_";
  _radio1 = (_temp select 0) + "_" + (_temp select 1);
};
if ((_radio1 find "a3pl_3310") > -1 || {(_radio1 find "a3pl_iphone") > -1} || {(_radio1 find "a3pl_sonySD") > -1} || {(_radio1 find "a3pl_sonyFD") > -1} || {(_radio1 find "a3pl_sonyDOJ") > -1}) then {
  private _temp = _radio1 splitString "_";
  _radio1 = (_temp select 0) + "_" + (_temp select 1);
};
if (_radio2 in ["a3pl_3310_1","a3pl_iphone_1","a3pl_sonySD_1","a3pl_sonyFD_1","a3pl_sonyDOJ_1"]) then {
  private _temp = _radio2 splitString "_";
  _radio2 = (_temp select 0) + "_" + (_temp select 1);
};

(_radio2 == _radio1)
