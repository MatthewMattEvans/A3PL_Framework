/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["Server_JobOil_PumpStart",
{
	private _player = param [0,objNull];
	private _pump = param [1,objNull];
	private _fail = false;
	if ((isNull _player) OR (isNull _pump)) exitwith {};

	private _oil = [getpos _pump] call A3PL_JobWildcat_CheckForOil;
	private _containsOil = _oil select 0;
	private _oilLocation = _oil select 1;
	if (!_containsOil) exitwith {};

	if ((_pump animationSourcePhase "drill") != 0) exitwith {[("Server_Job_Oil_PumpjackAlreadyStarted" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];};
	if (_pump getVariable ["pumping",false]) exitwith {[("Server_Job_Oil_PumpjackAlreadyStarted" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];};
	_pump setVariable ["pumping",true,true];
	[_pump] remoteExec ["A3PL_JobOil_Pump_Animation", -2];
	while {(_pump getVariable ["pumping",false])} do
	{
		private _oilAmount = [_oilLocation] call A3PL_JobWildcat_CheckAmountOil;
		if (_oilAmount <= 0) exitwith {[("Server_Job_Oil_NoMoreOil" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];};

		//private _allBarrels = _pump nearEntities [["A3PL_OilBarrel"],20];
		//private _attachedObjects = [_pump] call A3PL_Lib_AttachedAll;
		//private _attachedBarrels = _attachedObjects select {typeOf _x isEqualTo "A3PL_OilBarrel"};
		//private _barrelCount = count _allBarrels - count _attachedBarrels;

		private _pumpjacks = _pump nearEntities [["A3PL_PumpJack"],2];
		private _holes = nearestObjects [_pump,["A3PL_DrillHole"],3];
		if (count _holes < 1) exitwith {[("Server_Job_Oil_NoMoreHole" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];};
		private _hole = _holes select 0;
		if (count _pumpjacks > 1) exitwith {[("Server_Job_Oil_PumpjackAlreadyHere" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];};
		if (((_pump modelToWorld (_pump selectionPosition "holePosition")) distance _hole) > 0.2) exitwith {[("Server_Job_Oil_PumpjackPlacingError" call A3PL_Localize), Color_Red] remoteExec ["A3PL_Notification", _player];};
		//if (_barrelCount > 8) exitWith {["Vous devez retirer les barils autour de l'extracteur pour pouvoir continuer", Color_Red] remoteExec ["A3PL_Notification", _player];};
		_pump setVariable ["crudeOil",(_pump getVariable ["crudeOil",0]) + 1,false];
		if ((_pump getVariable ["crudeOil",0]) >= 42) then {
			private _barrelCount = (_pump getVariable ["barrelCount", 0]) + 1;
			_pump setVariable ["barrelCount", _barrelCount, false];
			private _isRare = (_barrelCount mod Job_Oil_Rare_Interval == 0) && {random 100 < Job_Oil_Rare_Chance};

			private _barrelClass = if (_isRare) then {"A3PL_PremiumOilBarrel"} else {"A3PL_OilBarrel"};
			private _itemClass = if (_isRare) then {"Premium_Crude_Oil"} else {"Crude_Oil"};

			private _barrel = createVehicle [_barrelClass,(getpos _pump), [], 0, "None"];
			_barrel setVariable ["class",_itemClass,true];
			if (_isRare) then {
				[("Server_Job_Oil_RareOil" call A3PL_Localize), Color_Green] remoteExec ["A3PL_Notification", _player];
			};
			private _cid = (_player getVariable ["character_id",""]) call A3PL_Config_GetCompanyID;
			if (_cid isNotEqualTo "" && _cid != 0) then {
				_barrel setVariable ["cid",_cid,true];
			};
			_barrel setVariable ["owner",(_player getVariable ["character_id",""]),true];

			// Check if player has the petrol trait
			private _traits = _player getVariable ["Player_Traits", []];
			private _hasPetrolTrait = "petrol" in _traits;
			private _luckyBonus = [_traits] call A3PL_Traits_GetLuckyBonus;

			// Petrol trait: 15% chance to not deduct gallons when a barrel appears (+ lucky bonus, or lucky alone: 15%)
			private _deductGallons = true;
			private _chance = if (_hasPetrolTrait) then {15 + _luckyBonus} else {_luckyBonus};
			if (_chance > 0 && {random 100 < _chance}) then {
				_deductGallons = false;
			};

			if (_deductGallons) then {
				{
					if ((_x select 0) isEqualTo _oilLocation) exitwith {
						_x set [2,(_x#2) - 42];
						Server_JobWildCat_Oil set [_forEachIndex,_x];
						publicVariable "Server_JobWildCat_Oil";
					};
				} foreach Server_JobWildCat_Oil;
			};
			_pump setVariable ["crudeOil",nil,false];
		};
		sleep 0.26;
	};
	_pump setVariable ["pumping",nil,true];
	_pump animateSource ["pump",0,true];
}] call compile_Server;
