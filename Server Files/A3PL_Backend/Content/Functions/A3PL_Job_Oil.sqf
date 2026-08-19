/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_JobOil_PumpStart",
{
	private _pump = param [0,objNull];

	if (!local _pump) exitwith {[("STR_A3PL_Job_Oil_OnlyOwnerCanStart" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _pumpjacks = _pump nearEntities [["A3PL_Pumpjack"],3];
	private _holes = nearestObjects [_pump, ["A3PL_DrillHole"],3];
	if (count _holes < 1) exitwith {[("STR_A3PL_Job_Oil_NoHoleNear" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (count _pumpjacks > 1) exitwith {[("STR_A3PL_Job_Oil_ExtractorAlreadyOnHole" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _hole = _holes select 0;
	if (((_pump modelToWorld (_pump selectionPosition "holePosition")) distance _hole) > 0.2) exitwith {[("STR_A3PL_Job_Oil_PlaceExtractorOnHole" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_oil = [getpos _hole] call A3PL_JobWildcat_CheckForOil;
	_containsOil = _oil select 0;
	_oilLocation = _oil select 1;
	if (!_containsOil) exitwith {[("STR_A3PL_Job_Oil_NoPetrolInArea" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_oilAmount = [_oilLocation] call A3PL_JobWildcat_CheckAmountOil;
	if (_oilAmount <= 0) exitwith {[("STR_A3PL_Job_Oil_NoMorePetrolHere" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if ((_pump animationSourcePhase "drill") != 0) exitwith {[("STR_A3PL_Job_Oil_AlreadyStarted" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	[player,_pump] remoteExec ["Server_JobOil_PumpStart", 2];
}] call compile_Global;

["A3PL_JobOil_Pump_Animation",
{
	private _pump = param [0,objNull];
	while {(_pump getVariable ["pumping",false])} do
	{
		if (_pump animationSourcePhase "pump" < 0.5) then {
			_pump animateSource ["pump",1];
			waitUntil {_pump animationSourcePhase "pump" >= 0.98};
		} else {
			_pump animateSource ["pump",0,true];
			waitUntil {_pump animationSourcePhase "pump" < 0.1};
		};
	};
}] call compile_Global;
