/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Storage_CarRetrieveButton",
{
	disableSerialization;
	private ["_display","_control","_intersect","_spawnPos","_dir","_exit","_pCash","_pBank","_hasAccount"];
	_display = findDisplay 145;
	_control = _display displayCtrl 1500;
	_intersect = player_objintersect;

	if(!(call A3PL_Player_AntiSpam)) exitWith {};

	if ((isNil "player_objintersect") || (player_objintersect isEqualTo player)) then {
		_intersect = cursorObject;
	} else {
		_intersect = player_objIntersect;
	};
	if (isNull _intersect) exitwith {closeDialog 0; [("STR_A3PL_Storage_YouNotLookingTheStorage" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_intersect animationPhase "StorageDoor1" > 0.1) exitwith {closeDialog 0; [("STR_A3PL_Storage_GarageAlreadyInUse" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if((lbCurSel _control) < 0) exitWith {};
	if(A3PL_Storage_ReturnArray isEqualTo []) exitWith {[("STR_A3PL_Storage_ErrorLoadingVehicle" call A3PL_Localize),Color_Red] call A3PL_Notification;closeDialog 0;};
	_array = (A3PL_Storage_ReturnArray select (lbCurSel _control));
	_id = _array select 0;
	_class = _array select 1;

	_spawnPos = _intersect getVariable ["positionSpawn",nil];
	_exit = false;
	if ((_intersect isKindOf "Land_Home1g_DED_Home1g_01_F") OR (typeOf _intersect IN ["Land_A3PL_Ranch1","Land_A3PL_Ranch2","Land_A3PL_Ranch3","Land_A3PL_Sheriffpd","Land_A3PL_Firestation","Land_A3PL_Showroom","Land_A3PL_Garage"])) then
	{
		_dir = getDir _intersect;
		switch (typeOf _intersect) do
		{
			case ("Land_Home1g_DED_Home1g_01_F"): {_spawnPos = _intersect modelToWorld [4.2,1.5,-3.2];_spawnPos = [_spawnPos select 0,_spawnPos select 1,_spawnPos select 2,_dir];};
			case ("Land_Home2b_DED_Home2b_01_F"): {_spawnPos = _intersect modelToWorld [-4.42236,-1.39868,-3.26778];_spawnPos = [_spawnPos select 0,_spawnPos select 1,_spawnPos select 2,_dir];};
			case ("Land_Home3r_DED_Home3r_01_F"): {_spawnPos = _intersect modelToWorld [-3,-1,-4];_spawnPos = [_spawnPos select 0,_spawnPos select 1,_spawnPos select 2,_dir];};
			case ("Land_Home4w_DED_Home4w_01_F"): {_spawnPos = _intersect modelToWorld [4.3,-1,-3];_spawnPos = [_spawnPos select 0,_spawnPos select 1,_spawnPos select 2,_dir];};
			case ("Land_Home5y_DED_Home5y_01_F"): {_spawnPos = _intersect modelToWorld [4.3,-1,-3];_spawnPos = [_spawnPos select 0,_spawnPos select 1,_spawnPos select 2,_dir];};
			case ("Land_Home6b_DED_Home6b_01_F"): {_spawnPos = _intersect modelToWorld [3,-1,-4];_spawnPos = [_spawnPos select 0,_spawnPos select 1,_spawnPos select 2,_dir];};
			case ("Land_A3PL_Ranch1"): {_spawnPos = _intersect modelToWorld [1,6.5,-2]; _dir = _dir - 90;_spawnPos = [_spawnPos select 0,_spawnPos select 1,_spawnPos select 2,_dir];};
			case ("Land_A3PL_Ranch2"): {_spawnPos = _intersect modelToWorld [1,6.5,-2]; _dir = _dir - 90;_spawnPos = [_spawnPos select 0,_spawnPos select 1,_spawnPos select 2,_dir];};
			case ("Land_A3PL_Ranch3"): {_spawnPos = _intersect modelToWorld [1,6.5,-2]; _dir = _dir - 90;_spawnPos = [_spawnPos select 0,_spawnPos select 1,_spawnPos select 2,_dir];};
			case ("Land_A3PL_Firestation"): {
				_pJob = player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
				if((["fifrvfd",player] call A3PL_DMV_Check) || (_pJob isEqualTo ("STR_Common_FIFR" call A3PL_Localize))) then {
					_offset = [-11,-15.5,-7.5];
					if (player_NameIntersect isEqualTo "garagedoor2_button") then {_offset = [-4.8,-15.5,-7.5];};
					_spawnPos = _intersect modelToWorld _offset;
					_dir = _dir - 180;
					_spawnPos = [_spawnPos select 0,_spawnPos select 1,_spawnPos select 2,_dir];
				} else {
					_exit = true;
				};
			};
			case ("Land_A3PL_Showroom"): {_spawnPos = _intersect modelToWorld [-6,-1,-3]; _dir = _dir - 180;_spawnPos = [_spawnPos select 0,_spawnPos select 1,_spawnPos select 2,_dir];};
			case ("Land_A3PL_Garage"): {_spawnPos = _intersect modelToWorld [0.85,0,-3]; _spawnPos = [_spawnPos select 0,_spawnPos select 1,_spawnPos select 2,_dir];};
			case ("Land_A3PL_Sheriffpd"):
			{
				if (player_NameIntersect == "sdstoragedoor3") then {
					_spawnPos = _intersect modelToWorld [-2.2,0.1,-5.5];
					_intersect animateSource ["StorageDoor",1];
				};
				if (player_NameIntersect == "sdstoragedoor6") then {
					_spawnPos = _intersect modelToWorld [-2.2,3.8,-5.5];
					_intersect animateSource ["StorageDoor2",1];
				};
				_dir = _dir + 90;
				_spawnPos = [_spawnPos select 0,_spawnPos select 1,((_spawnPos select 2)+0),_dir];
			};
			_spawnPos = [_spawnPos select 0,_spawnPos select 1,_spawnPos select 2,_dir];
		};
	};
	if(_exit) exitWith {[("STR_A3PL_Storage_YoureNotAuthorizedToUseThisGarage" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!isNil "_spawnPos") then
	{
		_type = _intersect getVariable ["type","vehicle"];
		if(_type isEqualTo "vehicle") then {[_class,player,_id,_spawnPos] remoteExec ["Server_Storage_RetrieveVehicle", 2];};
		if (_type isEqualTo "plane") then {[_class,player,_id,_spawnPos] remoteExec ["Server_Storage_RetrieveVehicle", 2];};
		if (_type == "impound") then {
			_vehPrice = [_class] call A3PL_Config_GetVehicleMSRP;
			_price = 0;
			if (_VehPrice < 150000) then{
				_price = _vehPrice * 0.05;
			}
			else {
				_price = _vehPrice * 0.02;
			};
			_hasAccount = [player,1] call A3PL_Bank_HasAccount;
			_pBank = player getVariable ["player_bank",0];
			if (!_hasAccount) exitWith {[("STR_Common_NoBankAccount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			if (_price > _pBank) exitWith {[format[("STR_A3PL_Storage_YouNeedMoneyOnYourBankAccountToPayImpoundFees" call A3PL_Localize),_price-_pBank],Color_Red] call A3PL_Notification;};
			player setVariable ["player_bank",_pBank-_price,true];
			[format[("STR_A3PL_Storage_YouPaidImpoundFees" call A3PL_Localize),_price],Color_Red] call A3PL_Notification;
			[_class,player,_id,_spawnPos] remoteExec ["Server_Storage_RetrieveVehicle", 2];
		};
		if(_type == "airimpound") then {
			_vehPrice = [_class] call A3PL_Config_GetVehicleMSRP;
			_price = 0;
			if (_VehPrice < 150000) then{
				_price = _vehPrice * 0.05;
			}
			else {
				_price = _vehPrice * 0.02;
			};
			_hasAccount = [player,1] call A3PL_Bank_HasAccount;
			_pBank = player getVariable ["player_bank",0];
			if (!_hasAccount) exitWith {[("STR_Common_NoBankAccount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			if (_price > _pBank) exitWith {[format[("STR_A3PL_Storage_YouNeedMoneyOnYourBankAccountToPayImpoundFees" call A3PL_Localize),_price-_pBank],Color_Red] call A3PL_Notification;};
			player setVariable ["player_bank",_pBank-_price,true];
			[format[("STR_A3PL_Storage_YouPaidImpoundFees" call A3PL_Localize),_price],Color_Red] call A3PL_Notification;
			[_class,player,_id,_spawnPos] remoteExec ["Server_Storage_RetrieveVehicle", 2];
		};
		if(_type == "chopshop") then {
			_vehPrice = [_class] call A3PL_Config_GetVehicleMSRP;
			_price = 0;
			if (_VehPrice < 150000) then{
				_price = _vehPrice * 0.07;
			}
			else {
				_price = _vehPrice * 0.04;
			};
			_pCash = player getVariable ["player_cash",0];
			if (_price > _pCash) exitWith {[format[("STR_A3PL_Storage_YouNeedMoneyOnYourBankAccountToPayImpoundFees" call A3PL_Localize),_price-_pCash],Color_Red] call A3PL_Notification;};
			player setVariable ["player_cash",_pCash-_price,true];
			[_class,player,_id,_spawnPos] remoteExec ["Server_Storage_RetrieveVehicle", 2];
			[format[("STR_A3PL_Storage_YouPaidImpoundFees" call A3PL_Localize),_price],Color_Red] call A3PL_Notification;
		};
	} else {
		if((typeOf _intersect) isEqualTo "") then {
			_nearFreePos = [(getpos player), 5, 50, 0, 0] call BIS_fnc_findSafePos;
			[_class,player,_id,_nearFreePos] remoteExec ["Server_Storage_RetrieveVehicle", 2];
		} else {
			[_class,player,_id,_intersect] remoteExec ["Server_Storage_RetrieveVehicle", 2];
		};
	};
	closeDialog 0;
}] call compile_Global;

["A3PL_Storage_CarStoreButton",
{
	private _toCompany = param [0,0];
	private _intersect = player_objIntersect;
	if (isNull _intersect) exitwith {};
	private _types = ["Car","Ship","Tank","Truck","Plane","Helicopter","Air","A3FL_PalletLifter","A3FL_TransportContainer"];
	private _near = _intersect nearEntities [_types,30];

	if(((typeOf _intersect) isEqualTo "Land_A3PL_Firestation") && (!((player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) isEqualTo ("STR_Common_FIFR" call A3PL_Localize)) && !(["fifrvfd",player] call A3PL_DMV_Check))) exitWith {[("STR_A3PL_Storage_OnlyFDandVFDCanUseThisGarage" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if ((count _near) isEqualTo 0) exitwith {[7] call A3PL_Storage_CarStoreResponse;};
	if (typeOf (_near#0) IN ["A3PL_FD_HoseEnd1","A3PL_FD_HoseEnd2"]) exitwith {[7] call A3PL_Storage_CarStoreResponse;};

	private _companyError = false;
	if(_toCompany isEqualTo 0) then {
		private _charID = (player getVariable ["character_id",""]);
		private _cid = [_charID] call A3PL_Config_GetCompanyID;
		private _hasPerm = [_cid,"transfer",_charID] call A3FL_Config_GetCompanyPermissions;
		private _isBoss = [_charID] call A3PL_Config_IsCompanyBoss;
		if(!(_hasPerm) && !(_isBoss)) exitWith {
			_companyError = true;
			[("STR_A3PL_Storage_YouDoNotHavePermissionToTransferInYourCompany" call A3PL_Localize),Color_Red] call A3PL_Notification;
		};
	};
	if(_companyError) exitWith {};

	if (typeOf _intersect IN ["Land_A3PL_storage"]) then {
		[player,_intersect,_toCompany] remoteExec ["Server_Storage_StoreVehicle",2];
	} else {
		private _cars = nearestObjects [player, ["Car","Ship","Air","Tank","Truck","A3FL_PalletLifter","A3FL_TransportContainer"], 30];
		private _blacklist = [("STR_Common_Job_Waste" call A3PL_Localize),("STR_Common_Job_Deliver" call A3PL_Localize),("STR_Common_Job_Exterminator" call A3PL_Localize),("STR_Common_Vehicle_Plate_Karting" call A3PL_Localize),("STR_Common_Vehicle_Plate_Federal" call A3PL_Localize),("STR_Common_Job_Roadworker" call A3PL_Localize),("STR_Common_Job_BetterBuy" call A3PL_Localize),("STR_Common_Job_Captain" call A3PL_Localize),("STR_Common_Job_Taxi" call A3PL_Localize)];
		if((count _cars) isEqualTo 0) exitWith {[("STR_A3PL_Storage_NoCarAround" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		private _car = _cars#0;
		private _ownerVar = _car getVariable ["owner",["",""]];
		if(_car getVariable["DealershipStolen",false]) exitWith {[("STR_A3PL_Storage_ThisIsStolenCar" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		if (_ownerVar#0 isNotEqualTo (player getVariable ["character_id",""])) exitWith {[("STR_A3PL_Storage_YouCantStoreVehicleThatYoureNotTheOwner" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		if (_ownerVar#1 IN _blacklist) exitWith {[("STR_A3PL_Storage_YouCantStoreVehicleThatYoureNotTheOwner" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		private _stockobj = _car getVariable["stockobj",nil];
		if !(isNil "_stockobj") exitWith {[10] call A3PL_Storage_CarStoreResponse;};
		private _atttachedObjects = attachedObjects _car;
		private _countAttached = count(_attachedObjects);
		if ((_countAttached > 0 || (_countAttached isEqualTo 1 && (count(_attachedObjects#0) isEqualTo 0)))) exitWith {[("STR_A3PL_Storage_ErrorCreateTicket" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		[_car,player,_toCompany] remoteExec ["Server_Storage_SaveLargeVehicles",2];
	};
}] call compile_Global;

["A3PL_Storage_CarRetrieveResponse",
{
	private _return = param [0,1];
	private _text = "";
	switch (_return) do
	{
		case 1: {_text = [("STR_A3PL_Storage_GarageAlreadyInUse" call A3PL_Localize),Color_red]};
		case 2: {_text = [("STR_A3PL_Storage_YouHave30SecToGetYourCarOUT" call A3PL_Localize),Color_green]};
		case 3: {_text = [("STR_A3PL_Storage_YourCarHasBeenStored" call A3PL_Localize),Color_red]};
		case 4: {_text = [("STR_A3PL_Storage_YouGetYourVehicleOut" call A3PL_Localize),Color_green]};
	};
	_text call A3PL_Notification;
}] call compile_Global;

["A3PL_Storage_CarStoreResponse",
{
	private _return = param [0,1];
	private _text = "";
	switch (_return) do
	{
		case 1: {_text = [("STR_A3PL_Storage_GarageAlreadyInUse" call A3PL_Localize),Color_red]};
		case 2: {_text = [("STR_A3PL_Storage_PlaceYourCarInside" call A3PL_Localize),Color_green]};
		case 3: {_text = [("STR_A3PL_Storage_VehicleWillBeStoredWhenDoorClosed" call A3PL_Localize),Color_red]};
		case 4: {_text = [("STR_A3PL_Storage_NotPossibleToStoreCar" call A3PL_Localize),Color_red]};
		case 5: {_text = [("STR_A3PL_Storage_VehicleEnPanne" call A3PL_Localize),Color_red]};
		case 6: {_text = [("STR_A3PL_Storage_ErrorStorageNoCarOwnerByPlayer" call A3PL_Localize),Color_red]};
		case 7: {_text = [("STR_A3PL_Storage_NoVehicleAroundNoPossibleToStore" call A3PL_Localize),Color_red]};
		case 8: {_text = [("STR_A3PL_Storage_NearestCarWillBeStored" call A3PL_Localize),Color_green]};
		case 9: {_text = [("STR_A3PL_Storage_CarStored" call A3PL_Localize),Color_green]};
		case 10: {_text = [("STR_A3PL_Storage_VehicleCantBeStoredInYourPersonnalGarage" call A3PL_Localize),Color_red]};
	};
	_text call A3PL_Notification;
}] call compile_Global;

["A3PL_Storage_OpenCarStorage", {
	if(player_objintersect getVariable ["inUse",false]) exitWith {[("STR_A3PL_Storage_GarageAlreadyInUse" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _company = param[0,false];
	private _exit = false;
	if (_company) then {
		private _charID = (player getVariable ["character_id",""]);
		private _cid = [_charID] call A3PL_Config_GetCompanyID;
		private _hasPerm = [_cid,"garage",_charID] call A3FL_Config_GetCompanyPermissions;
		private _isBoss = ([_charID] call A3PL_Config_IsCompanyBoss);
		if(!(_hasPerm) && !(_isBoss)) exitWith {_exit = true;};
	};

	if (_exit) exitWith {[("STR_A3PL_Storage_YouDontHavePermissionToAccessGarageOfYourCompany" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	createDialog "dialog_PlayerGarage";
	private _type = player_objintersect getVariable ["type","vehicle"];
	if (!(player_objintersect IN Impounds_Lots)) then {
		player_objintersect setVariable ["inUse",true,true];
	};

	[] spawn {
		private _garage = player_objintersect;
		waitUntil {uiSleep 0.1; isNull findDisplay 145};
		sleep 2;
		_garage setVariable ["inUse",false,true];
	};

	if (player_objintersect IN Impounds_Lots) exitWith {
		if (Impound_NewSystem isEqualTo 1) then {
			closeDialog 0;
			["Impound lot managed by tow truck operators only.",Color_Red] call A3PL_Notification;
		} else {
			[player,"-1",1] remoteExec ["Server_Storage_ReturnVehicles", 2];
		};
	};
	if (player_objintersect IN Impounds_Air) exitWith {
		if (Impound_NewSystem isEqualTo 1) then {
			closeDialog 0;
			["Impound lot managed by tow truck operators only.",Color_Red] call A3PL_Notification;
		} else {
			[player,"-1",1,"plane"] remoteExec ["Server_Storage_ReturnVehicles", 2];
		};
	};
	if (player_objintersect isEqualTo Shop_Chopshop_Retrieve_1) exitWith {
		[player,"-1",2,""] remoteExec ["Server_Storage_ReturnVehicles", 2];
	};
	if(_company) exitWith {
		private _cid = [(player getVariable ["character_id",""])] call A3PL_Config_GetCompanyID;
		[player,"-1",0,_type,_cid] remoteExec ["Server_Storage_ReturnVehicles", 2];
	};
	[player,"-1",0,_type] remoteExec ["Server_Storage_ReturnVehicles", 2];
}] call compile_Global;

["A3PL_Storage_VehicleReceive", {
	disableSerialization;
	private _returnArray = param [0,[]];
	private _display = findDisplay 145;
	private _control = _display displayCtrl 1500;

	{
		_x pushBack (format ["%1",getText (configFile >> "CfgVehicles" >> _x#1 >> "displayName")]);

		private _vehicleGas = format ["%1%2",round((_x#3)*100),"%"];
		private _vehiclePlate = toUpperANSI (_x#0);
		private _vehicleInsurance = _x#4;
		private _vehicleGasType = _x#5;
		private _vehicleGasAmount = _x#6;
		private _vehicleGPS = _x#7;
		private _vehicleCustomName = _x#2;
		private _vehicleData = format ["%1!%2!%3!%4!%5!%6!%7!%8!%9",_x#8,_vehiclePlate,_vehicleGas,_vehicleInsurance,_x#1,_vehicleGasType,_vehicleGasAmount,_vehicleGPS,_vehicleCustomName];

		if ((_x select 2) isEqualTo "noCustomName") then {
			_i = lbAdd [1500, (format ["%1",getText (configFile >> "CfgVehicles" >> _x#1 >> "displayName")])];
			lbSetData [1500,_i,_vehicleData];
		} else {
			_i = _control lbAdd (format ["%1",_x#2]);
			lbSetData [1500,_i,_vehicleData];
		};
	} foreach _returnArray;
	A3PL_Storage_ReturnArray = _returnArray;
	_control ctrlAddEventHandler ["LBSelChanged","call A3PL_Storage_VehicleInfo;"];
}] call compile_Global;

["A3PL_Storage_VehicleInfo", {
	private _display = findDisplay 145;
	private _selectedIndex = lbCurSel 1500;
	private _selectedData = lbData [1500, _selectedIndex];
	private _dataSplit = _selectedData splitString "!";
	private _vehicleType = _dataSplit#0;
	private _vehiclePlate = _dataSplit#1;
	private _vehicleGas = _dataSplit#2;
	private _vehicleInsurance = _dataSplit#3;
	private _vehicleClass = _dataSplit#4;
	private _vehicleGasTypeRetrieve = _dataSplit#5;
	private _vehicleGasAmountRetrieve = _dataSplit#6;
	private _vehicleGPSRetrieve = _dataSplit#7;
	private _vehicleCustomName = if (count _dataSplit > 8) then {_dataSplit#8} else {"noCustomName"};
	private _control = _display displayCtrl 1501;

	if (_vehicleCustomName isNotEqualTo "noCustomName") then {
		(_display displayCtrl 1502) ctrlSetText _vehicleCustomName;
	} else {
		(_display displayCtrl 1502) ctrlSetText "";
	};
	
	private _vehicleInsured = ("STR_UI_Common_Yes" call A3PL_Localize);
	if(_vehicleInsurance isEqualTo "0") then {
		_vehicleInsured = ("STR_UI_Common_No" call A3PL_Localize);
	};
	
	private _vehicleGasType = ("STR_Common_None" call A3PL_Localize);
	if(_vehicleGasTypeRetrieve isEqualTo "Petrol") then {
		_vehicleGasType = ("STR_A3PL_Storage_Petrol" call A3PL_Localize);
	};
	if(_vehicleGasTypeRetrieve isEqualTo "Kerosene") then {
		_vehicleGasType = ("STR_A3PL_Storage_Kerozene" call A3PL_Localize);
	};
	
	private _vehicleGasAmount = ("STR_A3PL_Storage_Full" call A3PL_Localize);
	if(_vehicleGasAmountRetrieve isEqualTo "0") then {
		_vehicleGasAmount = ("STR_A3PL_Storage_Empty" call A3PL_Localize);
	} else {
		_vehicleGasAmount = _vehicleGasAmountRetrieve;
	};
	
	private _vehicleGPS = ("STR_UI_Common_Yes" call A3PL_Localize);
	if(_vehicleGPSRetrieve isEqualTo "0") then {
		_vehicleGPS = ("STR_UI_Common_No" call A3PL_Localize);
	};

	private _startingText = [("STR_A3PL_Storage_Type" call A3PL_Localize),("STR_A3PL_Storage_LicensePlate" call A3PL_Localize),("STR_A3PL_Storage_Gas" call A3PL_Localize),("STR_A3PL_Storage_Insurance" call A3PL_Localize),("STR_A3PL_Storage_Citern" call A3PL_Localize),("STR_A3PL_Storage_CiternContent" call A3PL_Localize),("STR_A3PL_Storage_GPS" call A3PL_Localize)];
	private _followingText = [_vehicleType,_vehiclePlate,_vehicleGas,_vehicleInsured,_vehicleGasType,_vehicleGasAmount,_vehicleGPS];

	if (_vehicleInsured isEqualTo ("STR_UI_Common_No" call A3PL_Localize)) then {
		_vehPrice = [_vehicleClass] call A3PL_Config_GetVehicleMSRP;
		_cost = round(_vehPrice * 0.35);
		_startingText pushBack ("STR_A3PL_Storage_InsurancePrice" call A3PL_Localize);
		_followingText pushBack format["$%1",_cost];
	};

	if (_vehicleGPS isEqualTo ("STR_UI_Common_No" call A3PL_Localize)) then {
		_vehPrice = [_vehicleClass] call A3PL_Config_GetVehicleMSRP;
		_cost = round(_vehPrice * 0.15);
		_startingText pushBack ("STR_A3PL_Storage_GPSPrice" call A3PL_Localize);
		_followingText pushBack format["$%1",_cost];
	};

	lbClear 1501;
	{
		lbAdd [1501, format ["%1 %2", _startingText select _forEachIndex,_followingText select _forEachIndex]];
	} forEach _followingText;
}] call compile_Global;

["A3PL_Storage_ChangeVehicleName", {
	private _display = findDisplay 145;
	private _control = _display displayCtrl 1500;
	private _selectedIndex = lbCurSel 1500;
	private _selectedData = lbData [1500, _selectedIndex];
	private _dataSplit = _selectedData splitString "!";
	private _vehiclePlateUpper = _dataSplit select 1;
	private _vehiclePlateLower = toLowerANSI _vehiclePlateUpper;
	private _vehicleNewName = ctrlText 1401;
	private _allowedCharacters = [" ","0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
	private _validCharacters = true;

	if ((count _vehicleNewName) < 1) exitWith {[("STR_A3PL_Storage_GiveAName" call A3PL_Localize),Color_Yellow] call A3PL_Notification;};
	if ((count _vehicleNewName) > 35) exitWith {[("STR_A3PL_Storage_35CharMax" call A3PL_Localize),Color_Yellow] call A3PL_Notification;};

	for "_i" from 0 to ((count _vehicleNewName) - 1) do
	{
		private ["_checking"];
		_checking = _vehicleNewName select [_i,1];
		if (!(_checking IN _allowedCharacters)) exitwith {_validCharacters = false;};
	};

	if (!(_validCharacters)) exitWith {[("STR_A3PL_Storage_NameCanContainOnlyLettersSpaceAndNumbers" call A3PL_Localize),Color_Yellow] call A3PL_Notification;};
	[_vehiclePlateLower,_vehicleNewName] remoteExec ["Server_Storage_ChangeVehicleName",2];

	closeDialog 0;
}] call compile_Global;

["A3PL_Storage_Insure", {
	disableSerialization;
	private _selectedIndex = lbCurSel 1500;
	private _selectedData = lbData [1500, _selectedIndex];
	private _dataSplit = _selectedData splitString "!";
	private _vehiclePlateUpper = _dataSplit#1;
	private _vehicleInsurance = _dataSplit#3;
	private _vehicleClass = _dataSplit#4;

	if (_vehicleInsurance isEqualTo "1") exitwith {[("STR_A3PL_Storage_CarAlreadyInsured" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _vehiclePlateLower = toLowerANSI _vehiclePlateUpper;
	private _vehPrice = [_vehicleClass] call A3PL_Config_GetVehicleMSRP;
	private _cost = round(_vehPrice * 0.35);
	private _pBank = player getVariable["player_bank",0];

	private _action = [format[("STR_A3PL_Storage_InsuranceCostDesc" call A3PL_Localize),getText (configFile >> "CfgVehicles" >> _vehicleClass >> "displayName"),_cost]] call A3PL_Lib_ConfirmationDialog;
	if (!isNil "_action" && {!_action}) exitWith {[("STR_A3PL_Storage_YouDecidedToNotInsureYourCar" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if (_cost > _pBank) exitwith {[format [("STR_A3PL_Storage_YouDoNotHaveMoneyOnYourAccount" call A3PL_Localize)]] call A3PL_Notification;};
	player setVariable ["Player_Bank",_pBank - _cost,true];

	[format [("STR_A3PL_Storage_YouInsured" call A3PL_Localize), getText (configFile >> "CfgVehicles" >> _vehicleClass >> "displayName"), _cost],Color_Green] call A3PL_Notification;
	[_vehiclePlateLower] remoteExec ["Server_Vehicle_Insure",2];
}] call compile_Global;

["A3PL_Storage_GPS", {
	disableSerialization;
	private _selectedIndex = lbCurSel 1500;
	private _selectedData = lbData [1500, _selectedIndex];
	private _dataSplit = _selectedData splitString "!";
	private _vehiclePlateUpper = _dataSplit#1;
	private _vehicleGPS = _dataSplit#7;
	private _vehicleClass = _dataSplit#4;

	if (_vehicleGPS isEqualTo "1") exitwith {[("STR_A3PL_Storage_VehicleAlreadyPuced" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _vehiclePlateLower = toLowerANSI _vehiclePlateUpper;
	private _vehPrice = [_vehicleClass] call A3PL_Config_GetVehicleMSRP;
	private _cost = round(_vehPrice * 0.15);
	private _pBank = player getVariable["player_bank",0];

	private _action = [format[("STR_A3PL_Storage_GPSPriceDesc" call A3PL_Localize),getText (configFile >> "CfgVehicles" >> _vehicleClass >> "displayName"),_cost]] call A3PL_Lib_ConfirmationDialog;
	if (!isNil "_action" && {!_action}) exitWith {[("STR_A3PL_Storage_YouDecidedToNotPuceYourCar" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if (_cost > _pBank) exitwith {[format [("STR_A3PL_Storage_YouDoNotHaveMoneyOnYourAccount" call A3PL_Localize)]] call A3PL_Notification;};
	player setVariable ["Player_Bank",_pBank - _cost,true];

	[format [("STR_A3PL_Storage_YouPuced" call A3PL_Localize), getText (configFile >> "CfgVehicles" >> _vehicleClass >> "displayName"), _cost],Color_Green] call A3PL_Notification;
	[_vehiclePlateLower] remoteExec ["Server_Vehicle_GPS",2];

	[getPlayerUID player,(player getVariable ["character_id",""]),"Vehicle_InstallGPS",[format ["Vehicle: %1 | Plate: %2",_vehicleClass,_vehiclePlateUpper]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

["A3PL_Storage_ShowGPS", {
	private _mode = _this select 0;

	if (isNil "A3PL_GPS") then {
        A3PL_GPS = [];
    };

	A3PL_PlayerGPS_Markers = [];
	[player] remoteExec ["Server_Vehicle_GetGPS", 2];

	if (_mode == 0) then {
		// Hide hotbar while map is open
		Hotbar_MapHidden = true;
		if (Hotbar_UI_Visible) then { [] call A3PL_Hotbar_DestroyUI; };

		while {isNil "A3PL_GPS" || {count A3PL_GPS == 0}} do {
            sleep 0.1;
        };
		while {visibleMap} do
		{
			if (count A3PL_GPS > 0) then {
				{
					private _vehicle = _x;
					private _ownerData = _vehicle getVariable ["owner", ["",""]];
					if (_ownerData#1 IN A3PL_GPS) then {
						private _markerName = format ["vehicleMarker_%1", _ownerData#1];

						if (!isNil {_markerName}) then {
							deleteMarkerLocal _markerName;
						};

						if (damage _vehicle isNotEqualTo 1) then {
							_markerName = createMarkerLocal [_markerName, getPos _vehicle];
							_markerName setMarkerShapeLocal "ICON";
							_markerName setMarkerTypeLocal "mil_dot";
							_markerName setMarkerColorLocal "ColorBlue";
							_markerName setMarkerTextLocal format [("STR_A3PL_Storage_GPSMarker" call A3PL_Localize), _ownerData#1];

							A3PL_PlayerGPS_Markers pushBack _markerName;
						};
					};
				} forEach ((allMissionObjects "LandVehicle"));
			},
			sleep 120;
		};
	} else {
		{
			deleteMarkerLocal _x;
		} forEach A3PL_PlayerGPS_Markers;

		// Restore hotbar when map closes (if player has it enabled)
		Hotbar_MapHidden = false;
		private _isShowGPS = profileNameSpace getVariable ["A3PL_ShowGPS", true];
		if (_isShowGPS && !Hotbar_UI_Visible && !isNull (findDisplay 46)) then { [] call A3PL_Hotbar_CreateUI; };
	};
}] call compile_Global;