/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Hydrogen_SetPrice",
{
	disableSerialization;
	private _display = findDisplay 69;

	_station = nearestobjects [player,["Land_A3PL_Gas_Station"],30];
	if (count _station < 1) exitwith {[("STR_A3PL_GasStation_NoStationNearby" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_station = _station select 0;

	private _nearBy = nearestObjects [player, ["Land_A3PL_Gas_Station"], 20];
	if (count _nearBy < 1) exitwith {[("STR_A3PL_GasStation_NoStationNearby" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	A3PL_Company_Building = _nearBy select 0;
	private _charID = (player getVariable ["character_id",""]);
	private _cid = [_charID] call A3PL_Config_GetCompanyID;
	private _shopCid = A3PL_Company_Building getVariable["cid",0];
	if(!(_shopCid isEqualTo _cid)) exitWith {[("STR_Common_LocalNotOwnedByCompany" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_isCorporate = [_charID] call A3PL_Config_InCompany;
	if(!_isCorporate) exitWith {[("STR_Common_NotInCompany" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!((player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) == ("STR_Common_Company" call A3PL_Localize))) exitwith {[("STR_A3PL_GasStation_NotOnDuty" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _hasPerm = [_cid,"bank",_charID] call A3FL_Config_GetCompanyPermissions;
	private _isBoss = ([_charID] call A3PL_Config_IsCompanyBoss);
	if(!(_hasPerm) && !(_isBoss)) exitWith {[("STR_A3PL_GasStation_ModifyPricesDenied" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _newPrice = parseNumber (ctrlText (_display displayCtrl 1400));

	if (_newPrice < Gas_Min_Default_Gallon_Price) exitwith {[format[("STR_A3PL_GasStation_EnterGreaterPrice" call A3PL_Localize),Gas_Min_Default_Gallon_Price],Color_Red] call A3PL_Notification};
	if (_newPrice > Gas_Max_Default_Gallon_Price) exitwith {[format[("STR_A3PL_GasStation_EnterLowerPrice" call A3PL_Localize),Gas_Max_Default_Gallon_Price],Color_Red] call A3PL_Notification};

	(_display displayCtrl 1400) ctrlSetText format ["%1",_newPrice];
	_station setVariable ["gallonprice",_newPrice,true];
	private _gallonPrice = str (_newPrice);
	
	if ((_newPrice >= 1) && (_newPrice < 10)) then {
		_station setObjectTextureGlobal [50,format ["\A3PL_Cars\Common\Number_Plates\%1.paa",0]];
		_station setObjectTextureGlobal [52,format ["\A3PL_Cars\Common\Number_Plates\%1.paa",0]];
		_station setObjectTextureGlobal [51,format ["\A3PL_Cars\Common\Number_Plates\%1.paa",str(_gallonPrice)]];
	};
	
	if ((_newPrice >= 10) && (_newPrice < 100)) then {
		_station setObjectTextureGlobal [50,format ["\A3PL_Cars\Common\Number_Plates\%1.paa",0]];
		_station setObjectTextureGlobal [52,format ["\A3PL_Cars\Common\Number_Plates\%1.paa",(str(_gallonPrice) splitstring "") select 1]];
		_station setObjectTextureGlobal [51,format ["\A3PL_Cars\Common\Number_Plates\%1.paa",(str(_gallonPrice) splitstring "") select 2]];
	};

	if (_newPrice >= 100) then {
		_station setObjectTextureGlobal [50,format ["\A3PL_Cars\Common\Number_Plates\%1.paa",(str(_gallonPrice) splitstring "") select 1]];
		_station setObjectTextureGlobal [52,format ["\A3PL_Cars\Common\Number_Plates\%1.paa",(str(_gallonPrice) splitstring "") select 2]];
		_station setObjectTextureGlobal [51,format ["\A3PL_Cars\Common\Number_Plates\%1.paa",(str(_gallonPrice) splitstring "") select 3]];
	};
	
	[("STR_A3PL_GasStation_PricesUpdated" call A3PL_Localize),Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Hydrogen_Open",
{
	disableSerialization;
	private ["_display","_station","_gallons","_price"];
	_station = nearestobjects [player,["Land_A3PL_Gas_Station"],30];
	if (count _station < 1) exitwith {[("STR_A3PL_GasStation_NoStationNearby" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_station = _station select 0;

	private _nearBy = nearestObjects [player, ["Land_A3PL_Gas_Station"], 20];
	if (count _nearBy < 1) exitwith {[("STR_A3PL_GasStation_NoStationNearby" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	A3PL_Company_Building = _nearBy select 0;
	private _charID = (player getVariable ["character_id",""]);
	private _cid = [_charID] call A3PL_Config_GetCompanyID;
	private _shopCid = A3PL_Company_Building getVariable["cid",0];
	if(!(_shopCid isEqualTo _cid)) exitWith {[("STR_Common_LocalNotOwnedByCompany" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_isCorporate = [_charID] call A3PL_Config_InCompany;
	if(!_isCorporate) exitWith {[("STR_Common_NotInCompany" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!((player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) == ("STR_Common_Company" call A3PL_Localize))) exitwith {[("STR_A3PL_GasStation_NotOnDutyViewPrices" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _hasPerm = [_cid,"bank",_charID] call A3FL_Config_GetCompanyPermissions;
	private _isBoss = ([_charID] call A3PL_Config_IsCompanyBoss);
	if(!(_hasPerm) && !(_isBoss)) exitWith {[("STR_A3PL_GasStation_ViewPricesDenied" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	createDialog "Dialog_GasStation";

	_display = findDisplay 69;
	(_display displayCtrl 1400) ctrlSetText format ["%1",_station getVariable ["gallonprice",DEFGALLONPRICE]];

	_gallons = (_station getVariable ["pump1",[0,0]]) select 0;
	_price = (_station getVariable ["pump1",[0,0]]) select 1;
	(_display displayCtrl 1401) ctrlSetText format ["%1 Gallons",_gallons];
	(_display displayCtrl 1402) ctrlSetText format ["%1%2","$",_price];

	_gallons = (_station getVariable ["pump2",[0,0]]) select 0;
	_price = (_station getVariable ["pump2",[0,0]]) select 1;
	(_display displayCtrl 1403) ctrlSetText format ["%1 Gallons",_gallons];
	(_display displayCtrl 1404) ctrlSetText format ["%1%2","$",_price];

	_gallons = (_station getVariable ["pump3",[0,0]]) select 0;
	_price = (_station getVariable ["pump3",[0,0]]) select 1;
	(_display displayCtrl 1405) ctrlSetText format ["%1 Gallons",_gallons];
	(_display displayCtrl 1406) ctrlSetText format ["%1%2","$",_price];

	_gallons = (_station getVariable ["pump4",[0,0]]) select 0;
	_price = (_station getVariable ["pump4",[0,0]]) select 1;
	(_display displayCtrl 1407) ctrlSetText format ["%1 Gallons",_gallons];
	(_display displayCtrl 1408) ctrlSetText format ["%1%2","$",_price];

	(_display displayCtrl 1409) ctrlSetText format ["%1 gallons",(_station getVariable ["petrol",0])];
}] call compile_Global;

["A3PL_Hydrogen_Grab",
{
	private _intersect = param [0,objNull];
	if(typeOf _intersect == "Land_A3PL_Gas_Station") then {_intersect = (nearestObjects [player, ["A3PL_Gas_Hose"], 5] select 0);};
	if (!(typeOf _intersect IN ["A3PL_Gas_Hose","A3PL_GasHose"])) exitwith {[("STR_A3PL_GasStation_NotLookingAtHose" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((isPlayer attachedTo _intersect) && (!((attachedTo _intersect) isKindOf "Car"))) exitwith {[("STR_Common_HoseAlreadyHeld" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _attObjs = attachedObjects player;
	if (count _attObjs >= 1) exitWith {[("STR_A3PL_GasStation_CannotCarryTwoObjects" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _tank = nearestObjects [player, ["A3PL_Gas_Box"], 30];
	if (typeOf _intersect == "A3PL_GasHose") then {_tank = nearestObjects [player, ["A3PL_Tanker_Trailer","A3PL_Fuel_Van","A3FL_T440_Gas_Tanker"], 30];};
	if (count _tank == 0) exitwith {[("STR_A3PL_GasStation_NoContainerNearby" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_tank = _tank select 0;

	_intersect attachto [player, [0,0,0.2], 'RightHand'];
	if (typeOf _intersect == "A3PL_GasHose") then {_intersect setDir 180};
	uiSleep 1.5;
	[_tank,player] remoteExec ["A3PL_Lib_ChangeLocality", 2];
	[_intersect,player] remoteExec ["A3PL_Lib_ChangeLocality", 2];

	player_Item = _intersect;
	while {attachedTo _intersect == player} do {
		if (((typeOf _tank == "A3PL_Gas_Box") && (_intersect distance _tank > 5)) || (((typeOf _tank) IN ["A3PL_Tanker_Trailer","A3PL_Fuel_Van","A3FL_T440_Gas_Tanker"]) && (_intersect distance _tank > 28))) exitwith {detach _intersect;[("STR_A3PL_GasStation_DistanceHoseDropped" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		if (vehicle player isNotEqualTo player) exitwith {detach _intersect; [("STR_A3PL_GasStation_VehicleEnteredHoseDropped" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		uisleep 1;
	};
	player_Item = objNull;
}] call compile_Global;

["A3PL_Hydrogen_LoadTank",
{
	if (!(call A3PL_Player_AntiSpam)) exitWith {};
	private _barrel = param [0,objNull];
	private _gasType = param [1,"Petrol"];
	private _loadSuccess = true;

	private _tankers = (nearestObjects [player, ["A3PL_Tanker_Trailer","A3PL_Fuel_Van","A3FL_T440_Gas_Tanker"], 10]);
	if ((count _tankers) isEqualTo 0) exitWith {[("STR_A3PL_GasStation_NoTankerNearby" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _tanker = _tankers#0;
	private _barrels = nearestObjects [_barrel, ["A3PL_OilBarrel","A3PL_Kerosene"], 10];
	private _barrelsCntOil = count (nearestObjects [_barrel, ["A3PL_OilBarrel"],10]);
	private _barrelsCntKer = count (nearestObjects [_barrel, ["A3PL_Kerosene"],10]);
	private _barrelsCount = count(_barrels);
	if(_barrelsCount isEqualTo 0) exitWith {[("STR_A3PL_GasStation_NoBarrelsNearby" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((_barrelsCntOil > 0) && (_barrelsCntKer > 0)) exitWith {[("STR_A3PL_GasStation_MultipleBarrelTypesNearby" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _isTankerTrailer = (typeOf _tanker) isEqualTo "A3PL_Tanker_Trailer";

	if (_isTankerTrailer) then {
		private _cuve1Type = _tanker getVariable ["gasType", nil];
		private _cuve1Amt = _tanker getVariable ["gasAmount", 0];
		private _cuve2Type = _tanker getVariable ["gasType2", nil];
		private _cuve2Amt = _tanker getVariable ["gasAmount2", 0];
		private _cuveCapacity = 1200;
		private _totalAmt = _cuve1Amt + _cuve2Amt;

		if (_totalAmt >= 2400) exitWith {[("STR_A3PL_GasStation_TankerFull" call A3PL_Localize),Color_Red] call A3PL_Notification;};

		private _targetCuve = 0;
		if (isNil "_cuve1Type" || {_cuve1Type isEqualTo _gasType}) then {
			if (_cuve1Amt < _cuveCapacity) then {
				_targetCuve = 1;
			} else {
				if (isNil "_cuve2Type" || {_cuve2Type isEqualTo _gasType}) then {
					_targetCuve = 2;
				};
			};
		} else {
			if (isNil "_cuve2Type" || {_cuve2Type isEqualTo _gasType}) then {
				if (_cuve2Amt < _cuveCapacity) then {
					_targetCuve = 2;
				};
			};
		};

		if (_targetCuve isEqualTo 0) exitWith {[("STR_A3PL_GasStation_TankerFull" call A3PL_Localize),Color_Red] call A3PL_Notification;};

		private _typeVar = if (_targetCuve isEqualTo 1) then {"gasType"} else {"gasType2"};
		private _amtVar = if (_targetCuve isEqualTo 1) then {"gasAmount"} else {"gasAmount2"};

		_tanker setVariable [_typeVar, _gasType, true];

		private _exit = false;
		{
			private _currentAmt = _tanker getVariable [_amtVar, 0];
			if ((_currentAmt + 60) > _cuveCapacity) exitWith {
				if (_targetCuve isEqualTo 1) then {
					private _c2Type = _tanker getVariable ["gasType2", nil];
					if ((isNil "_c2Type" || {_c2Type isEqualTo _gasType}) && {(_tanker getVariable ["gasAmount2", 0]) + 60 <= _cuveCapacity}) then {
						_tanker setVariable ["gasType2", _gasType, true];
						private _c2Amt = _tanker getVariable ["gasAmount2", 0];
						deleteVehicle _x;
						_tanker setVariable ["gasAmount2", _c2Amt + 60, true];
					} else {
						[("STR_A3PL_GasStation_TankerAlmostFull" call A3PL_Localize),Color_Red] call A3PL_Notification;
						_exit = true;
					};
				} else {
					[("STR_A3PL_GasStation_TankerAlmostFull" call A3PL_Localize),Color_Red] call A3PL_Notification;
					_exit = true;
				};
			};
			if (_exit) exitWith {};
			deleteVehicle _x;
			_tanker setVariable [_amtVar, _currentAmt + 60, true];
		} forEach _barrels;
		if (_exit) exitWith {};
		private _c1Amt = _tanker getVariable ["gasAmount", 0];
		private _c2Amt = _tanker getVariable ["gasAmount2", 0];
		private _c1Type = _tanker getVariable ["gasType", nil];
		private _c2Type = _tanker getVariable ["gasType2", nil];
		private _msg = "";
		if (_c1Amt > 0 && {!isNil "_c1Type"}) then {_msg = format ["Cuve 1: %1G de %2", _c1Amt, _c1Type];};
		if (_c2Amt > 0 && {!isNil "_c2Type"}) then {
			if (_msg isNotEqualTo "") then {_msg = _msg + " | ";};
			_msg = _msg + format ["Cuve 2: %1G de %2", _c2Amt, _c2Type];
		};
		[_msg, Color_Green] call A3PL_Notification;
	} else {
		private _tankerContents = _tanker getVariable ["gasType", nil];
		private _tankerContentsAmt = _tanker getVariable ["gasAmount",0];
		private _tankerCapacity = switch(typeOf _tanker) do {
			case "A3PL_Fuel_Van": {1020};
			case "A3FL_T440_Gas_Tanker": {2040};
			default {1020};
		};

		if (_tankerContentsAmt >= _tankerCapacity) exitWith {[("STR_A3PL_GasStation_TankerFull" call A3PL_Localize),Color_Red] call A3PL_Notification;};

		if (_gasType isEqualTo "Petrol") then {
			if ((_tankerContents isEqualTo "Kerosene") && (_tankerContentsAmt isNotEqualTo 0)) exitWith {[("STR_A3PL_GasStation_KeroseneInTanker" call A3PL_Localize),Color_Red] call A3PL_Notification;_loadSuccess = false;};
			_tanker setVariable ["gasType","Petrol",true];
		};
		if (_gasType isEqualTo "Kerosene") then {
			if ((_tankerContents isEqualTo "Petrol") && (_tankerContentsAmt isNotEqualTo 0)) exitWith {[("STR_A3PL_GasStation_PetrolInTanker" call A3PL_Localize),Color_Red] call A3PL_Notification;_loadSuccess = false;};
			_tanker setVariable ["gasType","Kerosene",true];
		};
		if (_loadSuccess) then {
			private _exit = false;
			{
				_tankerContentsAmt = _tanker getVariable ["gasAmount",0];
				if ((_tankerContentsAmt + 60) >= _tankerCapacity) exitWith {[("STR_A3PL_GasStation_TankerAlmostFull" call A3PL_Localize),Color_Red] call A3PL_Notification; _exit = true;};
				deleteVehicle _x;
				_tanker setVariable ["gasAmount",_tankerContentsAmt + 60,true];
			} forEach _barrels;
			if (_exit) exitWith {};
			_tankerContents = _tanker getVariable ["gasType", nil];
			_tankerContentsAmt = _tanker getVariable ["gasAmount",0];
			[format [("STR_A3PL_GasStation_TankerContents" call A3PL_Localize),_tankerContentsAmt,_tankerContents],Color_Green] call A3PL_Notification;
		};
	};
}] call compile_Global;

["A3PL_Hydrogen_Connect", {
	private ["_hose","_tank","_dir","_setdir"];
	private _intersect = param [0,objNull];
	private _attached = [] call A3PL_Lib_Attached;
	if (count _attached isEqualTo 0) exitwith {[("STR_A3PL_GasStation_NotHoldingHose" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _hose = _attached#0;
	if (!(typeOf _hose IN ["A3PL_Gas_Hose","A3PL_GasHose"])) exitwith {[("STR_A3PL_GasStation_NotHoldingHose" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((typeOf _intersect isEqualTo "A3PL_JerryCan") && (typeOf _hose isEqualTo "A3PL_GasHose")) exitWith {[("STR_A3PL_GasStation_StationNeededToRefuelGasCan" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _tanks = nearestObjects [player, ["A3PL_Gas_Box"], 30];
	private _tank = _tanks#0;

	if ((typeOf _intersect == "Land_A3PL_Gas_Station") && (player_nameintersect IN ["hoseback1","hoseback2","hoseback3","hoseback4"])) exitwith
	{
		detach _hose;
		switch (player_nameintersect) do
		{
			case ("hoseback1"): {_hose attachTo [_tank,[-0.012,-0.012,-1.35]];};
			case ("hoseback2"): {_hose attachTo [_tank,[-0.012,0.87,-1.35]]; _hose setDir 180;};
			case ("hoseback3"): {_hose attachTo [_tank,[-0.012,-0.012,-1.35]];};
			case ("hoseback4"): {_hose attachTo [_tank,[-0.012,0.87,-1.35]]; _hose setDir 180;};
		};
		player_Item = objNull;
	};

	if (!(_intersect isKindOf "All")) exitwith {[("STR_A3PL_GasStation_NotInteractingWithVehicle" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_classname = typeOf player_objintersect;
	_vector = [[0.320857,-0.0197785,-0.946921],[0.946907,0.0282805,0.320261]];
	_attachTo = [0.1,0,0];
	_maxlength = 10;
	_setdir = 270;

	if ((typeOf _hose) isEqualTo "A3PL_Gas_Hose") then
	{
		switch (true) do
		{
			case (_classname IN ["A3PL_P362","A3PL_P362_TowTruck","A3PL_P362_Garbage_Truck"]): {_vector = [[-0.584987,0.000326949,-0.811043],[0.811043,-0.000109344,-0.584987]];_attachTo = [-0.08,0,0.05];};
			case (_classname IN ["A3PL_Rover"]): {_vector = [[-0.213246,-0.0863852,-0.973172],[-0.976888,0.0338489,0.211056]];_attachTo = [-0.1,0,-0.04];};
			case (_classname IN ["A3PL_BMW_M3"]): {_vector = [[-0.213246,-0.0863852,-0.973172],[-0.976888,0.0338489,0.211056]];_attachTo = [-0.04,0,-0.04];};
			case (_classname IN ["A3PL_911GT2"]): {_vector = [[-0.584987,0.000326949,-0.811043],[0.811043,-0.000109344,-0.584987]];_attachTo = [-0.07,0,0.04];};
			case (_classname IN ["A3PL_RBM"]): {_vector = [[-0.213246,-0.0863852,-0.973172],[-0.976888,0.0338489,0.211056]];_attachTo = [0.1,0,0];};
			case (_classname isEqualTo "A3PL_JerryCan"): {_vector = [[-0.213246,-0.0863852,-0.973172],[-0.976888,0.0338489,0.211056]];_attachTo = [0.3,0,0.2];};
			case (_classname IN ["A3FL_CamaroZL1","A3FL_CamaroZL1_PD","A3FL_CamaroZL1_PD_ST","A3FL_370Z","A3FL_Taurus","A3FL_Taurus_PD","A3FL_Taurus_PD_ST","A3FL_Taurus_FD"]): {_vector = [[-0.213246,-0.0863852,-0.973172],[-0.976888,0.0338489,0.211056]];_attachTo = [0.04,0,0.04];};
			case (_classname IN ["A3FL_Mercedes_Benz_AMG_C63","A3FL_Nissan_GTR","A3FL_Nissan_GTR_LW"]): {_vector = [[-0.213246,-0.0863852,-0.973172],[-0.976888,0.0338489,0.211056]];_attachTo = [0.04,0,0];};
			case (_classname IN ["A3FL_Dawn","A3FL_BMW_M6","A3FL_BMW_M6_Tuned","A3FL_Smart_Car","A3FL_Focus","A3FL_RS7","A3FL_F12"]): {_vector = [[-0.213246,-0.0863852,-0.973172],[-0.976888,0.0338489,0.211056]];_attachTo = [0.06,0,-0.04];};
			case (_classname isEqualTo "A3FL_Supra"): {_vector = [[-0.21,-0.08,-0.97],[-0.97,0.03,0.21]];_attachTo = [0.08,0.04,-0.08];};
			case (_classname isEqualTo "A3FL_ElDorado"): {_vector = [[0,1,-1.5], [0,0,1]];_attachTo = [0,-0.08,-0.06];};
			case (_classname isEqualTo "A3PL_MiniExcavator"): {_vector = [[-11,1,-7], [0,0,0.5]];_attachTo = [0.02,0,-0.06];};
			case (_classname IN ["A3FL_G65"]): {_vector = [[-0.213246,-0.0863852,-0.973172],[-0.976888,0.0338489,0.211056]];_attachTo = [0.1,-0.02,-0.05];};
			default {_vector = [[0.320857,-0.0197785,-0.946921],[0.946907,0.0282805,0.320261]];_attachTo = [-0.1,0,0];_maxlength = 7;};
		};

		_hose attachTo [_intersect,_attachTo,"gasTank"];
		sleep 0.2;
		_hose setVectorDirAndUp _vector;

		while {attachedTo _hose isEqualTo _intersect} do
		{
			sleep 0.1;
			if ((_hose distance _tank) > _maxlength) exitwith
			{
				detach _hose;
				_intersect setDamage 0.9;
			};
		};
	};

	if ((typeOf _hose) isEqualTo "A3PL_GasHose") then
	{
		_maxlength = 30;
		switch (true) do
		{
			case (_classname IN ["A3PL_RBM"]): {_attachTo = [0.1,0,0];};
			case (_classname IN ["Heli_Medium01_H","Heli_Medium01_Luxury_H","Heli_Medium01_Military_H","Heli_Medium01_Veteran_H","Heli_Medium01_Coastguard_H","Heli_Medium01_Sheriff_H","Heli_Medium01_Medic_H"]): {_attachTo = [0.1,0,0];};
			case (_classname IN ["A3PL_Cessna172","A3PL_Goose_Base","A3PL_Goose_Radar","A3PL_Goose_USCG"]): {_attachTo = [0,0,-0.07];_vector = [[0.0389273,-0.110648,-0.993097],[0.0389949,-0.992925,0.112158]];};
			case (_classname IN ["A3PL_RHIB","A3PL_Yacht"]): {_attachTo = [0,-0.1,0];};
			case (_classname IN ["A3FL_AS_365","A3FL_AS350_CIV"]): {_attachTo = [0.2,0,0];};
			case (_classname IN ["A3PL_Jayhawk"]): {_attachTo = [0.23,-0.08,-0.05]; _vector = [[5,-1,0],[0,0,1]];};
			case (_classname IN ["A3PL_Motorboat"]): {_attachTo = [0,0,0.07];_vector = [[0,-0.110648,0.993097],[0,-0.992925,-0.112158]];};
			case (_classname IN ["A3FL_CamaroZL1","A3FL_CamaroZL1_PD","A3FL_CamaroZL1_PD_ST","A3FL_370Z","A3FL_Taurus","A3FL_Taurus_PD","A3FL_Taurus_PD_ST","A3FL_Taurus_FD","A3FL_Mercedes_Benz_AMG_C63","A3FL_Nissan_GTR","A3FL_Nissan_GTR_LW","A3FL_BMW_M6","A3FL_BMW_M6_Tuned","A3FL_Smart_Car","A3FL_Focus","A3FL_RS7","A3FL_F12","A3FL_Dawn"]): {_vector = [[0.5,0,0.15],[-1,0,0]];};
			case (_classname IN ["A3FL_T440_Tow_Truck","A3FL_T440","A3FL_T440_Gas_Tanker","A3FL_T440_Water_Tanker"]): {_attachTo = [-0.07,0,0.1];_vector = [[-1,0,1],[0,1,0]]};
			case (_classname isEqualTo "A3PL_MiniExcavator"): {_vector = [[6,1,0], [0,0,0.5]];_attachTo = [0.08,0,0.01];};
			case (_classname IN ["A3PL_Charger15","A3PL_Charger15_PD","A3PL_Charger15_PD_ST","A3PL_Charger15_FD","EC_Charger_Hellcat_20","EC_Charger_Hellcat_20_PD","EC_Charger_Hellcat_20_PD_ST","EC_Charger_Hellcat_20_FD"]): {_vector = [[-6,1,0], [0,0,0.01]];_attachTo = [-0.15,0,0];};
			case (_classname IN ["A3FL_Explorer_Platinum_20","A3FL_Explorer_Platinum_PD_Slicktop_20","A3FL_Explorer_Platinum_FD_20","A3FL_Explorer_Platinum_PD_20","A3FL_Explorer_PD_K9_20","A3PL_CVPI","A3PL_CVPI_Taxi","A3PL_CVPI_PD","A3PL_CVPI_PD_Slicktop","A3PL_CVPI_Rusty","A3PL_Silverado","A3PL_Silverado_PD","A3PL_Silverado_PD_ST","A3PL_Silverado_FD","A3FL_Tahoe","A3FL_Tahoe_PD","A3FL_Tahoe_PD_ST","A3FL_Tahoe_FD","EC_Explorer19_PD","EC_Explorer19_PD_ST","EC_Explorer19_FD","EC_Explorer19"]): {_vector = [[-11,1,0], [0,0,0.01]];_attachTo = [-0.05,0,0];};
			case (_classname IN ["A3FL_Mustang15","A3FL_Mustang15_PD","A3FL_Mustang15_PD_ST","A3FL_Yukon","A3FL_E350","A3FL_E350_P","A3FL_E350_PD","A3FL_E350_PD_P","A3FL_E350_ML"]): {_vector = [[-15,1,0], [0,0,0.01]];_attachTo = [-0.08,0,0];};
			case (_classname IN ["A3FL_ElDorado"]): {_attachTo = [0,-0.05,0]; _vector = [[0,-1,0],[0,0,1]];};
			case (_classname IN ["A3FL_F150","A3FL_F150_ML","A3FL_F150_PD","A3FL_F150_PD_ST","A3FL_F150_FD"]): {_attachTo = [-0.08,0,-0.02]; _vector = [[-1,0,0],[0,0,1]];};
			case (_classname IN ["A3FL_Escalade","A3PL_Suburban"]): {_attachTo = [-0.08,-0.01,0]; _vector = [[-1,0,0],[0,0,1]];};
			case (_classname IN ["A3FL_T370"]): {_attachTo = [-0.08,0,0.05]; _vector = [[-1,0,0],[0,0,1]];};
			case (_classname IN ["Jonzie_Ambulance"]): {_attachTo = [-0.03,0,-0.02]; _vector = [[-1,0,0],[0,0,1]];};
			case (_classname IN ["A3PL_E350","A3PL_Pierce_Heavy_Ladder","A3PL_Pierce_Pumper","K_Scooter_DarkBlue","A3PL_MailTruck"]): {_attachTo = [-0.08,0,0.02]; _vector = [[-1,0,0],[0,0,1]];};
			case (_classname IN ["A3PL_P362","A3PL_Tahoe","A3PL_Tahoe_FD","A3PL_Tahoe_PD","A3PL_Tahoe_PD_Slicktop","A3PL_Charger","A3PL_Charger_PD","A3PL_Charger_PD_Slicktop","A3PL_Wrangler","A3PL_VetteZR1"]): {_attachTo = [-0.11,0,0]; _vector = [[-1,0,0],[0,0,1]];};
			case (_classname IN ["A3PL_P362_TowTruck"]): {_attachTo = [-0.15,0,-0.05]; _vector = [[-1,0,0],[0,0,1]];};
			case (_classname IN ["A3PL_Mustang","A3PL_Mustang_PD","A3PL_Mustang_PD_Slicktop"]): {_attachTo = [-0.08,0,0]; _vector = [[-1,0,0],[0,0,1]];};
			case (_classname IN ["A3PL_BMW_M3"]): {_attachTo = [-0.01,0,0]; _vector = [[1,0,0],[0,8,-1]];};
			case (_classname IN ["A3PL_Rover"]): {_attachTo = [-0.05,0,0]; _vector = [[1,0,0],[0,0,1]];};
			case (_classname IN ["A3PL_Ram","A3PL_Ram_ML"]): {_attachTo = [-0.1,0,0]; _vector = [[-1,0,0],[0,0,1]];};
			case (_classname IN ["A3PL_Gallardo"]): {_attachTo = [-0.1,0,0.05]; _vector = [[-1,0,0],[0,0,1]];};
			case (_classname IN ["A3PL_F150","A3PL_F150_Marker"]): {_attachTo = [-0.1,0,0]; _vector = [[-1,0,0],[0,0,1]];};
			case (_classname IN ["A3PL_P362_Garbage_Truck"]): {_attachTo = [-0.15,-0.01,-0.03]; _vector = [[-1,0,0],[0,0,1]];};
			case (_classname IN ["A3PL_Fuel_Van"]): {_attachTo = [-0.15,-0.01,0.02]; _vector = [[-1,0,0],[0,0,1]];};
			case (_classname IN ["A3PL_Camaro","A3PL_BMW_X5"]): {_attachTo = [-0.1,-0.03,0.02]; _vector = [[-1,0,0],[0,0,1]];};
			case (_classname IN ["A3PL_Silverado","A3PL_Silverado_ML","A3PL_Silverado_PD","A3PL_Silverado_PD_ST","A3PL_Silverado_FD"]): {_attachTo = [-0.1,0,0.02]; _vector = [[-1,0,0],[0,0,1]];};
			case (_classname IN ["A3PL_Silverado_FD_Brush"]): {_attachTo = [-0.05,0,-0.02]; _vector = [[-1,0,0],[0,0,1]];};
			case (_classname IN ["A3PL_CRX"]): {_attachTo = [-0.09,0,0]; _vector = [[-1,0,0],[0,0,1]];};
			case (_classname IN ["A3PL_Charger69"]): {_attachTo = [-0.08,0,0.07]; _vector = [[-1,0,0.8],[0,0,1]];};
			case (_classname IN ["A3PL_Challenger_Hellcat","A3PL_Challenger_Hellcat_PD_ST"]): {_attachTo = [-0.08,0,0.03]; _vector = [[-1,0,0.3],[0,0,1]];};
			case (_classname IN ["A3PL_911GT2"]): {_attachTo = [-0.08,0,0.06]; _vector = [[-1,0,0.6],[0,0,1]];};
			case (_classname IN ["A3PL_Kx","A3PL_Knucklehead"]): {_attachTo = [-0.1,0,0.07]; _vector = [[-1,0,0.6],[0,0,1]];};
			case (_classname IN ["A3PL_Fatboy"]): {_attachTo = [-0.1,0,0.08]; _vector = [[-1,0,1],[0,0,1]];};
			case (_classname IN ["A3PL_1100R"]): {_attachTo = [-0.08,0,0.12]; _vector = [[-1,0,1.3],[0,0,1]];};
			case (_classname IN ["A3PL_Pierce_Rescue"]): {_attachTo = [-0.08,0,0]; _vector = [[-1,0,0],[0,0,1]];};
			case (_classname IN ["C_Quadbike_01_F"]): {_attachTo = [-0.11,0,0.1]; _vector = [[-1,0,0.6],[0,0,1]];};
			case (_classname IN ["C_Kart_01_F"]): {_attachTo = [-0.1,0,0.1]; _vector = [[-0.6,0,0.6],[0,0,1]];};
			case (_classname isEqualTo "A3PL_JerryCan"): {_vector = [[-0.213246,-0.0863852,-0.973172],[-0.976888,0.0338489,0.211056]];_attachTo = [0.3,0,0.2];};
			default {_attachTo = [0.1,0,0];};
		};
		_hose attachTo [_intersect,_attachTo,"gasTank"];
		sleep 0.2;
		_hose setVectorDirAndUp _vector;
	};
}] call compile_Global;

["A3PL_Hydrogen_SetNumbers",
{
	private _station = param [0,objNull];
	private _pumpNumber = param [1,1];
	private _gallons = param [2,0];
	private _price = param [3,0];
	private _priceCount = (str _price) splitString "";
	private _gallonsCount = (str _gallons) splitString "";
	private _priceFormat = switch (count _priceCount) do {
		case (1): {format ["0000000%1",_price]};
		case (2): {format ["000000%1",_price]};
		case (3): {format ["00000%1",_price]};
		case (4): {format ["0000%1",_price]};
		case (5): {format ["000%1",_price]};
	};
	private _gallonsFormat = switch (count _gallonsCount) do {
		case (1): {format ["0000000%1",_gallons]};
		case (2): {format ["000000%1",_gallons]};
		case (3): {format ["00000%1",_gallons]};
		case (4): {format ["0000%1",_gallons]};
		case (5): {format ["000%1",_gallons]};
	};
	private _startSel = 2 + ((_pumpNumber - 1) * 16);
	for "_i" from 0 to 7 do {
		_station setObjectTextureGlobal [_startSel,format ["\A3PL_Common\HydrogenNumbers\%1.paa",_priceFormat select [_i,1]]];
		_startSel = _startSel + 1;
	};
	private _startSel = 10 + ((_pumpNumber - 1) * 16);
	for "_i" from 0 to 7 do {
		_station setObjectTextureGlobal [_startSel,format ["\A3PL_Common\HydrogenNumbers\%1.paa",_gallonsFormat select [_i,1]]];
		_startSel = _startSel + 1;
	};
}] call compile_Global;

["A3PL_Hydrogen_SwitchFuel",
{
	private _intersect = param [0,objNull];
	private _vehicle = attachedTo _intersect;
	if (isNil "CBA_fnc_formatNumber") exitwith {["CBA is inactive (check your mods or contact support)",Color_Red] call A3PL_Notification;};
	if (!(typeOf _intersect IN ["A3PL_Gas_Hose","A3PL_GasHose"])) exitwith {[("STR_A3PL_GasStation_NotInteractingWithHose" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((typeOf _intersect) isEqualTo "A3PL_Gas_Hose") then
	{
		private _stationTank = nearestObjects [player, ["A3PL_Gas_Box"], 30];
		if (count _stationTank == 0) exitwith {[("STR_A3PL_GasStation_NoTankerNearby" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		_stationTank = _stationTank select 0;

		if (_intersect animationPhase "gasTurn" > 0) exitwith
		{
			_intersect animate ["gasTurn",0];
			{
				if((typeOf _x) == "#dynamicsound") then {
					deleteVehicle _x;
				};
			} foreach nearestObjects [_stationTank,[],5];
		};

		_vehicle = attachedTo _intersect;
		if((typeOf _vehicle) isEqualTo "A3PL_JerryCan") exitWith {[_intersect] call A3PL_Hydrogen_FuelJerry;};
		if ((isNull _vehicle) or (!(_vehicle isKindOf "Car"))) exitwith {[("STR_A3PL_GasStation_HoseNotAttachedToVehicle" call A3PL_Localize),Color_Red] call A3PL_Notification;};

		if (!local _vehicle) then {[_vehicle,player] remoteExec["A3PL_Lib_ChangeLocality",2];};

		private _station = nearestObjects [_stationTank,["Land_A3PL_Gas_Station"],10];
		if (count _station < 1) exitwith {[("STR_A3PL_GasStation_NoStationNearby" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		_station = _station select 0;
		if (!(_station getVariable ["pumpEnabled",true])) exitwith {
			[("STR_A3PL_GasStation_PumpBlocked" call A3PL_Localize),Color_Red] call A3PL_Notification;
		};
		if ((_station getVariable ["petrol",0]) <= 0) exitwith {[("STR_A3PL_GasStation_NoFuel" call A3PL_Localize),Color_Red] call A3PL_Notification;};

		private _gallonPrice = _station getVariable ["gallonprice",6];
		private _fuelCapacity = getNumber (configFile >> "CfgVehicles" >> typeOf _vehicle >> "fuelCapacity");
		if (_fuelCapacity <= 0) then {_fuelCapacity = 350;};
		private _gallonsNeeded = (1 - fuel _vehicle) * _fuelCapacity;
		private _stationFuel = _station getVariable ["petrol",0];
		private _maxGallons = _gallonsNeeded min _stationFuel;
		private _maxPrice = round(_gallonPrice * _maxGallons);

		if (_maxPrice <= 0) exitWith {[("STR_A3PL_GasStation_VehicleAlreadyFull" call A3PL_Localize),Color_Red] call A3PL_Notification;};

		player setVariable ["paymentResult",objNull];
		[_maxPrice] call A3PL_Bank_HowToPay;
		waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
		if (!(player getVariable "paymentResult")) exitWith {};

		createSoundSource ["A3PL_GasPump",getpos _stationTank, [], 0];

		_intersect animate ["gasTurn",1];

		_i = 0;
		waitUntil {sleep 0.1; _i = _i + 0.1; if (_i > 5) exitwith {true}; (_intersect animationPhase "gasTurn" > 0)};

		private _totalGallons = 0;
		private _myPrice = 0;
		while {(_intersect animationPhase "gasTurn" > 0) && (attachedTo _intersect == _vehicle) && ((_station getVariable ["petrol",0]) > 0)} do
		{
			private _gallons = 0.3;
			_totalGallons = _totalGallons + _gallons;
			_myPrice = round(_gallonPrice * _totalGallons);

			if (_myPrice > _maxPrice) exitWith {};

			[_station,1,round (_totalGallons),_myPrice] call A3PL_Hydrogen_SetNumbers;
			[_station,2,round (_totalGallons),_myPrice] call A3PL_Hydrogen_SetNumbers;
			[_station,3,round (_totalGallons),_myPrice] call A3PL_Hydrogen_SetNumbers;

			_vehicle setFuel ((fuel _vehicle) + (_gallons / _fuelCapacity));
			if ((fuel _vehicle) >= 1) exitwith {};
			private _newGas = (_station getVariable ["petrol",0]) - _gallons;
			if (_newGas < 0) then {_newGas = 0;};
			_station setVariable ["petrol",_newGas,true];
			sleep 1;
		};

		private _refund = _maxPrice - _myPrice;
		if (_refund > 0) then {
			[player, _refund] remoteExec ["Server_Fuel_Refund", 2];
		};

		if ((_station getVariable ["petrol",0]) <= 0) then {[("STR_A3PL_GasStation_NoFuel" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		[format [("STR_A3PL_GasStation_RefuelingStopped" call A3PL_Localize),_myPrice],Color_Green] call A3PL_Notification;
		_station setVariable [format ["pump%1",1],[[_totalGallons,1,2] call CBA_fnc_formatNumber,[_myPrice,1,2] call CBA_fnc_formatNumber],true];

		[_myPrice,_station] remoteExec ["Server_Fuel_Credit", 2];

		_intersect animate ["gasTurn",0];
		{
			if((typeOf _x) == "#dynamicsound") then {
				deleteVehicle _x;
			};
		} foreach nearestObjects [_stationTank,[],5];
	};
	if ((typeOf _intersect) isEqualTo "A3PL_GasHose") then
	{
		private _tank = nearestObjects [player, ["A3PL_Tanker_Trailer","A3PL_Fuel_Van","A3FL_T440_Gas_Tanker"], 30];
		if (count _tank isEqualTo 0) exitwith {[("STR_A3PL_GasStation_NoTankerNearby" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		_tank = _tank select 0;

		private _tankContents = _tank getVariable ["gasType", nil];
		private _tankContentsAmt = _tank getVariable ["gasAmount",0];

		private _fuelRequired = "";
		if(typeOf _vehicle IN ["A3PL_Cessna172","A3PL_Goose_Base","A3PL_Goose_USCG","A3PL_Jayhawk","A3FL_AS_365","A3FL_AS350_CIV","Heli_Medium01_H","Heli_Medium01_Luxury_H","Heli_Medium01_Medic_H","Heli_Medium01_Military_H","Heli_Medium01_Veteran_H","Heli_Medium01_Coastguard_H","A3FL_M_900_Base_F","A3FL_LCM","A3PL_Yacht","A3PL_RHIB","A3PL_Motorboat","A3PL_RBM"]) then {
			_fuelRequired = "Kerosene";
		} else {
			_fuelRequired = "Petrol";
		};

		if (_tankContents isNotEqualTo _fuelRequired) exitWith {[("STR_A3PL_GasStation_WrongFuelType" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		if ((isNull _vehicle)) exitwith {[("STR_A3PL_GasStation_HoseNotAttachedToVehicle" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		if (!local _vehicle) then {[_vehicle,player] remoteExec["A3PL_Lib_ChangeLocality",2];};

		if (_intersect animationPhase "gasTurn" > 0) exitWith {
			_intersect animate ["gasTurn",0];
			{
				if ((typeOf _x) == "#dynamicsound") then {
					deleteVehicle _x;
				};
			} forEach nearestObjects [_tank,[],5];
		};

		if (_tankContentsAmt <= 0) exitWith {[("STR_A3PL_GasStation_NoFuelContainer" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		
		createSoundSource ["A3PL_GasPump",getpos _tank, [], 0];

		_intersect animate ["gasTurn",1];
		_i = 0;
		waitUntil {sleep 0.1; _i = _i + 0.1; if (_i > 5) exitWith {true}; (_intersect animationPhase "gasTurn" > 0)};
		private _totalGallons = 0;
		while {(_intersect animationPhase "gasTurn" > 0) && (attachedTo _intersect == _vehicle) && ((_tank getVariable ["gasAmount",0]) > 0)} do
		{
			private _gallons = 0.3;
			_totalGallons = _totalGallons + _gallons;
			_vehicle setFuel ((fuel _vehicle) + (_totalGallons / 350));
			if ((fuel _vehicle) >= 1) exitWith {};
			private _newGas = (_tank getVariable ["gasAmount",0]) - _gallons;
			if (_newGas < 0) then {_newGas = 0;};
			_tank setVariable ["gasAmount",_newGas,true];
			uiSleep 1;
		};
		if ((_tank getVariable ["gasAmount",0]) <= 0) then {[("STR_A3PL_GasStation_NoFuelContainer" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		[format [("STR_A3PL_GasStation_RefuelingStoppedWithRemaining" call A3PL_Localize),(_tank getVariable ["gasAmount",0])],Color_Green] call A3PL_Notification;
		
		_intersect animate ["gasTurn",0];
		{
			if((typeOf _x) == "#dynamicsound") then {
				deleteVehicle _x;
			};
		} foreach nearestObjects [_tank,[],5];
	};
}] call compile_Global;

["A3PL_Hydrogen_FuelJerry", {
	private _intersect = param [0,objNull];
	if (isNil "CBA_fnc_formatNumber") exitwith {["CBA is inactive (check your mods or contact support)",Color_Red] call A3PL_Notification;};
	if (typeOf _intersect isNotEqualTo "A3PL_Gas_Hose") exitwith {[("STR_A3PL_GasStation_NotInteractingWithFuelHose" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _tank = nearestObjects [player, ["A3PL_Gas_Box"], 30];
	if (count _tank == 0) exitwith {[("STR_A3PL_GasStation_NoContainerNearby" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_tank = _tank select 0;

	if (_intersect animationPhase "gasTurn" > 0) exitwith
	{
		_intersect animate ["gasTurn",0];
		{
			_type = format["%1",typeOf _x];
			if(_type isEqualTo "#dynamicsound") then {
				deleteVehicle _x;
			};
		} foreach nearestObjects [_tank,[],5];
	};

	private _jerry = attachedTo _intersect;
	if((_jerry getVariable["class",""]) isEqualTo "jerrycan") exitwith {[("STR_A3PL_GasStation_FuelCanFull" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if((_jerry getVariable["amount",0]) > 1) exitWith {[("STR_A3PL_GasStation_CantRefuelMultipleGasCans" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _station = nearestObjects [_tank,["Land_A3PL_Gas_Station"],10];
	if ((count _station) < 1) exitwith {[("STR_A3PL_GasStation_NoStationNearby" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_station = _station select 0;
	if (!(_station getVariable ["pumpEnabled",true])) exitwith {
		[("STR_A3PL_GasStation_PumpBlocked" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};
	if ((_station getVariable ["petrol",0]) <= 0) exitwith {[("STR_A3PL_GasStation_NoFuel" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _sOcharID = _station getVariable ["bOwner","0"];
	private _isOwner = (_sOcharID isEqualTo (player getVariable ["character_id",""]));

	private _gallonPrice = _station getVariable ["gallonprice",DEFGALLONPRICE];
	private _jerryCapacity = 5;
	private _stationFuel = _station getVariable ["petrol",0];
	private _maxGallons = _jerryCapacity min _stationFuel;
	private _maxPrice = round(_gallonPrice * _maxGallons);

	if (!_isOwner && _maxPrice > 0) then {
		player setVariable ["paymentResult",objNull];
		[_maxPrice] call A3PL_Bank_HowToPay;
		waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
		if (!(player getVariable "paymentResult")) exitWith {};
	};

	createSoundSource ["A3PL_GasPump",getpos _tank, [], 0];

	_intersect animate ["gasTurn",1];
	private _i = 0;
	waitUntil {sleep 0.1; _i = _i + 0.1; if (_i > 5) exitwith {true}; (_intersect animationPhase "gasTurn" > 0)};

	private _myPrice = 0;
	private _totalGallons = 0;
	private _full = false;
	while {(_intersect animationPhase "gasTurn" > 0) && ((attachedTo _intersect) isEqualTo _jerry) && ((_station getVariable ["petrol",0]) > 0)} do
	{
		_gallons = 0.2;
		_totalGallons = _totalGallons + _gallons;
		_myPrice = round(_gallonPrice * _totalGallons);

		if (!_isOwner && _myPrice > _maxPrice) exitWith {};

		[_station,1,round(_totalGallons),_myPrice] call A3PL_Hydrogen_SetNumbers;
		[_station,2,round(_totalGallons),_myPrice] call A3PL_Hydrogen_SetNumbers;
		[_station,3,round(_totalGallons),_myPrice] call A3PL_Hydrogen_SetNumbers;
		if (_totalGallons >= _jerryCapacity) exitwith {_full = true;};
		_newgas = (_station getVariable ["petrol",0]) - _gallons;
		if (_newGas < 0) then {_newGas = 0;};
		_station setVariable ["petrol",_newGas,true];
		sleep 1;
	};
	// Set jerrycan as full if any fuel was added
	if(_totalGallons > 0) then {_jerry setVariable["class","jerrycan",true];};

	if (!_isOwner) then {
		private _refund = _maxPrice - _myPrice;
		if (_refund > 0) then {
			[player, _refund] remoteExec ["Server_Fuel_Refund", 2];
		};
		[_myPrice,_station] remoteExec ["Server_Fuel_Credit", 2];
	};

	if ((_station getVariable ["petrol",0]) <= 0) then {[("STR_A3PL_GasStation_NoFuel" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[format [("STR_A3PL_GasStation_RefuelingStopped" call A3PL_Localize),_myPrice],Color_Green] call A3PL_Notification;
	_station setVariable [format ["pump%1",1],[[_totalGallons,1,2] call CBA_fnc_formatNumber,[_myPrice,1,2] call CBA_fnc_formatNumber],true];

	_intersect animate ["gasTurn",0];
	{
		_type = format["%1",typeOf _x];
		if(_type isEqualTo "#dynamicsound") then {
			deleteVehicle _x;
		};
	} foreach nearestObjects [_tank,[],5];
}] call compile_Global;

["A3PL_Hydrogen_StorageSwitch",
{
	private _station = param [0,objNull];

	if (_station animationSourcePhase "hoseSwitch" > 0) exitwith {_station animateSource ["hoseSwitch",0]};

	private _adapter = nearestObjects [(_station modelToWorld [-3.76154,3.51953,-2.05121]), ["A3PL_FD_HoseEnd1_Float"], 1];
	_adapter = _adapter select 0;
	if (isNil "_adapter") exitwith {[("STR_A3PL_GasStation_NoAdapterConnected" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _end = attachedObjects _adapter;
	_end = _end select 0;
	if (isNil "_end") exitwith {[("STR_A3PL_GasStation_NoHoseConnectedToAdapter" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _source = [_end] call A3PL_FD_FindSource;
	if (isNull _source) exitwith {[("STR_A3PL_GasStation_NoContainerNearby" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _gasAmtVar = "gasAmount";
	private _gasTypeVar = "gasType";

	if ((typeOf _source) isEqualTo "A3PL_Tanker_Trailer") then {
		private _otherEnd = [_end] call A3PL_FD_FindOtherEnd;
		if (!isNull _otherEnd) then {
			private _outletNames = ["outlet_1","outlet_2","outlet_3","outlet_4"];
			private _closestOutlet = "";
			private _closestDist = 1;
			{
				private _selPos = _source modelToWorld (_source selectionPosition [_x, "memory"]);
				private _dist = _otherEnd distance _selPos;
				if (_dist < _closestDist) then {
					_closestDist = _dist;
					_closestOutlet = _x;
				};
			} forEach _outletNames;

			if (_closestOutlet IN ["outlet_3","outlet_4"]) then {
				_gasAmtVar = "gasAmount2";
				_gasTypeVar = "gasType2";
			};
		};
	};

	_exit = false;
	if(typeOf _source IN ["A3PL_Tanker_Trailer","A3PL_Fuel_Van","A3FL_T440_Gas_Tanker"]) then {
		private _gasType = _source getVariable[_gasTypeVar, nil];
		if(isNil "_gasType") exitWith {_exit = true;};
		if(_gasType == "Kerosene") exitWith {_exit = true;};
	};
	if(_exit) exitWith {[("STR_A3PL_GasStation_WrongFuelTypeForStation" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((_source getVariable [_gasAmtVar,0]) <= 0) exitwith {[("STR_A3PL_GasStation_SourceEmpty" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((_station getVariable ["petrol",0]) >= 1020) exitWith {[("STR_A3PL_GasStation_AlreadyFull" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_station animateSource ["hoseSwitch",1];
	private _i = 0;
	waitUntil {sleep 0.1; _i = _i + 0.1; if (_i > 5) exitwith {true}; (_station animationSourcePhase "hoseSwitch" > 0)};
	[("STR_A3PL_GasStation_TransferInProgress" call A3PL_Localize),Color_Green] call A3PL_Notification;
	private _earnings = 0;
	while {((_source getVariable [_gasAmtVar,0]) > 0) && (!isNull _source) && (_station animationSourcePhase "hoseSwitch" > 0) && ((_station getVariable ["petrol",0]) < 1000)} do
	{
		private _amount = 10;
		if ((_source getVariable [_gasAmtVar,0]) < _amount) then {_amount = _source getVariable [_gasAmtVar,0]};
		private _newSource = (_source getVariable [_gasAmtVar,0]) - _amount; if (_newSource < 0) then {_newSource = 0;};
		private _newStorage = (_station getVariable ["petrol",0]) + _amount; if (_newStorage < 0) then {_newStorage = 0;};
		_source setVariable [_gasAmtVar,_newSource,true];
		_station setVariable ["petrol",_newStorage,true];
		_earnings = _earnings + 10;
		uiSleep 2;
		_source = [_end] call A3PL_FD_FindSource;
	};
	player setVariable["Player_Cash",(player getVariable["Player_Cash",0]) + _earnings,true];
	[("STR_A3PL_GasStation_PumpingStopped" call A3PL_Localize),Color_Green] call A3PL_Notification;
	[format [("STR_A3PL_GasStation_EarnedMoneyForRefuel" call A3PL_Localize),_earnings],Color_Green] call A3PL_Notification;
	_station animateSource ["hoseSwitch",0];
}] call compile_Global;

["A3PL_Hydrogen_LockUnlock",
{
	_station = nearestobjects [player,["Land_A3PL_Gas_Station"],30];
	if (count _station < 1) exitwith {[("STR_A3PL_GasStation_NoStationNearby" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_station = _station select 0;

	private _nearBy = nearestObjects [player, ["Land_A3PL_Gas_Station"], 20];
	if (count _nearBy < 1) exitwith {[("STR_A3PL_GasStation_NoStationNearby" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	A3PL_Company_Building = _nearBy select 0;
	private _cid = [(player getVariable ["character_id",""])] call A3PL_Config_GetCompanyID;
	private _shopCid = A3PL_Company_Building getVariable["cid",0];
	if(!(_shopCid isEqualTo _cid)) exitWith {[("STR_Common_LocalNotOwnedByCompany" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!((player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) == ("STR_Common_Company" call A3PL_Localize))) exitwith {[("STR_A3PL_GasStation_NotOnDutyBlockStation" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if (!(_station getVariable ["pumpEnabled",true])) exitwith {
		_station setVariable ["pumpEnabled",true,true];
		[("STR_A3PL_GasStation_Unblocked" call A3PL_Localize),Color_Green] call A3PL_Notification;
	};
	if (_station getVariable ["pumpEnabled",true]) exitwith {
		_station setVariable ["pumpEnabled",false,true];
		[("STR_A3PL_GasStation_Blocked" call A3PL_Localize),Color_Green] call A3PL_Notification;
	};
}] call compile_Global;

["A3PL_Hydrogen_CheckCash",
{
	private _station = nearestobjects [player,["Land_A3PL_Gas_Station"],30];
	if (count _station < 1) exitwith {[("STR_A3PL_GasStation_NoStationNearby" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_station = _station select 0;
	
	private _nearBy = nearestObjects [player, ["Land_A3PL_Gas_Station"], 20];
	if (count _nearBy < 1) exitwith {[("STR_A3PL_GasStation_NoStationNearby" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	A3PL_Company_Building = _nearBy select 0;
	private _charID = (player getVariable ["character_id",""]);
	private _cid = [_charID] call A3PL_Config_GetCompanyID;
	private _shopCid = A3PL_Company_Building getVariable["cid",0];
	if(!(_shopCid isEqualTo _cid)) exitWith {[("STR_Common_LocalNotOwnedByCompany" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _isCorporate = [_charID] call A3PL_Config_InCompany;
	if(!_isCorporate) exitWith {[("STR_Common_NotInCompany" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!((player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) == ("STR_Common_Company" call A3PL_Localize))) exitwith {[("STR_A3PL_GasStation_NotOnDutyViewCashRegister" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _hasPerm = [_cid,"bank",_charID] call A3FL_Config_GetCompanyPermissions;
	private _isBoss = ([_charID] call A3PL_Config_IsCompanyBoss);
	if(!(_hasPerm) && !(_isBoss)) exitWith {[("STR_A3PL_GasStation_ViewCashRegisterDenied" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	
	[format [("STR_A3PL_GasStation_CurrentRevenue" call A3PL_Localize),_station getVariable ["bCash","0"]],Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Hydrogen_TakeCash",
{
	private _station = nearestobjects [player,["Land_A3PL_Gas_Station"],30];
	if (count _station < 1) exitwith {[("STR_A3PL_GasStation_NoStationNearby" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_station = _station select 0;
	
	private _nearBy = nearestObjects [player, ["Land_A3PL_Gas_Station"], 20];
	if (count _nearBy < 1) exitwith {[("STR_A3PL_GasStation_NoStationNearby" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	A3PL_Company_Building = _nearBy select 0;
	private _charID = (player getVariable ["character_id",""]);
	private _cid = [_charID] call A3PL_Config_GetCompanyID;
	private _shopCid = A3PL_Company_Building getVariable["cid",0];
	if(!(_shopCid isEqualTo _cid)) exitWith {[("STR_Common_LocalNotOwnedByCompany" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _isCorporate = [_charID] call A3PL_Config_InCompany;
	if(!_isCorporate) exitWith {[("STR_Common_NotInCompany" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!((player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) == ("STR_Common_Company" call A3PL_Localize))) exitwith {[("STR_A3PL_GasStation_NotOnDutyTakeCash" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _hasPerm = [_cid,"bank",_charID] call A3FL_Config_GetCompanyPermissions;
	private _isBoss = ([_charID] call A3PL_Config_IsCompanyBoss);
	if(!(_hasPerm) && !(_isBoss)) exitWith {[("STR_A3PL_GasStation_TakeCashDenied" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	
	player playMove 'AmovPercMstpSnonWnonDnon_AinvPercMstpSnonWnonDnon_Putdown';
	[player,_station] remoteExec ["Server_Fuel_TakeCash", 2];
}] call compile_Global;

["A3PL_Hydrogen_Refuel", {
	params[["_aircraft",true,[true]]];
	if !([] call A3PL_Player_AntiSpam) exitWith {};
	if (Player_ActionDoing) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _types = if(_aircraft) then {["Air","Plane"]} else {["Ship"]};
	private _nearest = nearestObjects[player, _types, 20];
	if(count(_nearest) isEqualTo 0) exitWith {[("STR_A3PL_GasStation_NoVehicleNearby" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _vehicle = _nearest#0;
	private _currentFuel = fuel _vehicle;
	if(_currentFuel isEqualTo 1) exitWith {[("STR_A3PL_GasStation_PlaneTanksAlreadyFull" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _pricePerGal = if(_aircraft) then {15} else {8};
	private _refuelNeeded = (1 - fuel _vehicle) * getNumber (configFile >> "CfgVehicles" >> typeOf _vehicle >> "fuelCapacity");
	if (typeOf _vehicle isEqualTo "A3FL_LCM") then {_refuelNeeded = (1 - fuel _vehicle) * 42};
	private _finalCost = _refuelNeeded * _pricePerGal;
	/* START HOW TO PAY */
	player setVariable ["paymentResult",objNull];
	[_finalcost] call A3PL_Bank_HowToPay;
	waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
	if (!(player getVariable "paymentResult")) exitWith {};
	/* END HOW TO PAY */
	[("STR_A3PL_GasStation_Refueling" call A3PL_Localize),_refuelNeeded/Gas_Refuel_Time] spawn A3PL_Lib_LoadAction;
	waitUntil{Player_ActionDoing};
	while {Player_ActionDoing} do {
		if ((player distance2D _vehicle) > 25) exitwith {Player_ActionInterrupted = true};
		if !(player getVariable["A3PL_Medical_Alive",true]) exitWith {Player_ActionInterrupted = true;};
		if (player getVariable["Incapacitated",false]) exitwith {Player_ActionInterrupted = true;};
	};
	if(Player_ActionInterrupted) exitWith {[("STR_A3PL_GasStation_RefuelingCanceled" call A3PL_Localize),Color_Red] call A3PL_Notification;};

		[_vehicle,player] remoteExec["A3PL_Lib_ChangeLocality",2];
	_vehicle setFuel 1;
		[format[("STR_A3PL_GasStation_RefuelingSuccess" call A3PL_Localize),[_finalCost, 1, 0, true] call CBA_fnc_formatNumber],Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3FL_Hydrogen_GetFuel",
{
    private ["_return","_fuelStations"];
    private _station = param [0,"Undefined"];
    private _search = param [1,"None"];

    switch(_station) do {
        case ("STR_Common_WeaponFactory"): { _return = FuelStations select 0; };
        case ("Northdale"): { _return = FuelStations select 1; };
        case ("Elk City"): { _return = FuelStations select 2; };
        case ("Beach Valley"): { _return = FuelStations select 3; };
        case ("Stoney Creek"): { _return = FuelStations select 4; };
        case ("Silverton"): { _return = FuelStations select 5; };
        case ("Deadwood"): { _return = FuelStations select 6; };
        case ("Blackwood"): { _return = FuelStations select 7; };
    };
	if (_search isEqualTo "cost") then {
		_return = _return getVariable ["gallonprice",45];
	} else {
		_return = _return getVariable ["petrol",0];
    };
    _return;
}] call compile_Global;

["A3FL_Hydrogen_ClearTank",
{
	private _tanker = param [0,objNull];
	private _action = [("STR_A3PL_GasStation_EmptyTanker" call A3PL_Localize)] call A3PL_Lib_ConfirmationDialog;
	if (!isNil "_action" && {!_action}) exitWith {[("STR_A3PL_GasStation_EmptyTankerCancel" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_tanker setVariable ["gasAmount",0,true];
	_tanker setVariable ["gasType", nil];
	if ((typeOf _tanker) isEqualTo "A3PL_Tanker_Trailer") then {
		_tanker setVariable ["gasAmount2",0,true];
		_tanker setVariable ["gasType2", nil];
	};
	[("STR_A3PL_GasStation_EmptyTankerSuccess" call A3PL_Localize),Color_Yellow] call A3PL_Notification;
}] call compile_Global;
