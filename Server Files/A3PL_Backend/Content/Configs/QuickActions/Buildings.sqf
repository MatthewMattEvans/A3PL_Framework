/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
[
	"Land_A3PL_BarGate",
	"STR_Intersect_OpenCloseBarrier",
	{
		private _bargate = player_objintersect;
		private _anim = (player_nameintersect splitstring "_") select 1;
		private _canUse = [getPos _bargate] call A3PL_Config_CanUseBargate;
		if(["keycard"] call A3PL_Inventory_Has) then {_canUse = true;};
		if (!_canUse) exitwith {
			[("STR_A3PL_QuickActions_Buildings_YourJobDontAllowYouToOpenThisDoor" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};
		if (_bargate animationSourcePhase _anim < 0.5) then {
			_bargate animateSource [_anim,1];
		} else {
			_bargate animateSource [_anim,0];
		};
	}
],
[
	"Land_A3PL_Bargate_Left",
	"STR_Intersect_OpenCloseBarrier",
	{
		private _bargate = player_objintersect;
		private _anim = (player_nameintersect splitstring "_") select 1;
		private _canUse = [getPos _bargate] call A3PL_Config_CanUseBargate;
		if(["keycard"] call A3PL_Inventory_Has) then {_canUse = true;};
		if (!_canUse) exitwith {
			[("STR_A3PL_QuickActions_Buildings_YourJobDontAllowYouToOpenThisDoor" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};
		if (_bargate animationSourcePhase _anim < 0.5) then {
			_bargate animateSource [_anim,1];
		} else {
			_bargate animateSource [_anim,0];
		};
	}
],
[
	"Land_A3PL_Bargate_Right",
	"STR_Intersect_OpenCloseBarrier",
	{
		private _bargate = player_objintersect;
		private _anim = (player_nameintersect splitstring "_") select 1;
		private _canUse = [getPos _bargate] call A3PL_Config_CanUseBargate;
		if(["keycard"] call A3PL_Inventory_Has) then {_canUse = true;};
		if (!_canUse) exitwith {
			[("STR_A3PL_QuickActions_Buildings_YourJobDontAllowYouToOpenThisDoor" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};
		if (_bargate animationSourcePhase _anim < 0.5) then {
			_bargate animateSource [_anim,1];
		} else {
			_bargate animateSource [_anim,0];
		};
	}
],
[
	"Land_A3PL_Gas_Station",
	"STR_Intersect_UseCashRegister",
	{call A3PL_Hydrogen_CheckCash;}
],
[
	"Land_A3PL_Gas_Station",
	"STR_Intersect_TakeCashRegisterMoney",
	{call A3PL_Hydrogen_TakeCash;}
],
[
	"",
	"STR_Intersect_CheckFireAlarm",
	{
		private _visible = [] call A3PL_Intersect_CanSee;
		if (_visible) then {
			[player_objintersect] spawn A3PL_FD_CheckFireAlarm;
		} else {
			[("STR_A3PL_QuickActions_Buildings_YouCantActiveAlarmIfItsNotVisible" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};
	}
],
[
	"",
	"STR_Intersect_TriggerFireAlarm",
	{[player_objintersect] spawn A3PL_FD_FireAlarm;}
],
[
	"",
	"STR_Intersect_ReactivateFireAlarm",
	{[player_objintersect] spawn A3PL_FD_SetFireAlarm;}
],
[
	"",
	"STR_Intersect_RepairFireAlarm",
	{[player_objintersect] spawn A3PL_FD_RepairFireAlarm;}
],
[
	"",
	"STR_Intersect_SpawnVehicleInGarage",
	{[] call A3PL_Storage_OpenCarStorage;}
],
[
	"",
	"STR_Intersect_GarageVehicle",
	{[] call A3PL_Storage_OpenCarStorage;} 
],
[
	"",
	"STR_Intersect_VehicleTow",
	{[] call A3PL_Storage_OpenCarStorage;}
],
[
	"",
	"STR_Intersect_AirTow",
	{[] call A3PL_Storage_OpenCarStorage;}
],
[
	"",
	"STR_Intersect_VehicleRecover",
	{[] call A3PL_Storage_OpenCarStorage;} 
],
[
	"",
	"STR_Intersect_AirGarage",
	{[] call A3PL_Storage_OpenCarStorage;}
],
// [
// 	"",
// 	"Accéder Garage Entreprise",
// 	{[true] call A3PL_Storage_OpenCarStorage;}
// ],
// [
// 	"",
// 	"Transférer vers Garage Entreprise",
// 	{[1] call A3PL_Storage_CarStoreButton;}
// ],
// [
// 	"",
// 	"Transférer vers Garage Personnel",
// 	{[2] call A3PL_Storage_CarStoreButton;}
// ],
[
	"",
	"STR_Intersect_StoreVehicle",
	{[player_objintersect] call A3PL_Storage_CarStoreButton;}
],
// [
// 	"A3PL_CarInfo",
// 	"Store Aircraft",
// 	{["plane"] call A3PL_Storage_CarStoreButton;}
// ],
// [
// 	"",
// 	"Storing Objects",
// 	{call A3PL_Storage_OpenObjectStorage;}
// ],
// [
// 	"",
// 	"Store Object",
// 	{call A3PL_Storage_ObjectStoreButton;}
// ],
[
	"A3PL_CarInfo",
	"STR_Intersect_TowClosestVehicle",
	{call A3PL_JobRoadWorker_Impound;}
],
[
	"A3PL_CarInfo",
	"STR_Config_Interactions_ImpoundList",
	{call A3PL_JobRoadWorker_OpenImpoundList;}
],
// [
// 	"land_a3pl_sheriffpd",
// 	"Open / Close Garage Door",
// 	{
// 		private _intersect = player_objintersect;
// 		private _nameintersect = player_nameintersect;
// 		if (_nameintersect IN ["door_1_1","door_1_2","door_1_3"]) exitwith {
// 			if (_intersect animationSourcePhase "garage1" < 0.1) then {
// 				_intersect animateSource ["garage1",1];
// 			} else {
// 				_intersect animateSource ["garage1",0];
// 			};
// 		};
// 		if (_nameintersect IN ["door_2_1","door_2_2","door_2_3"]) exitwith {
// 			if (_intersect animationSourcePhase "garage2" < 0.1) then {
// 				_intersect animateSource ["garage2",1];
// 			} else {
// 				_intersect animateSource ["garage2",0];
// 			};
// 		};
// 	}
// ],
// [
// 	"land_a3fl_sheriffpd",
// 	"Use SD Button",
// 	{
// 		private _name = player_nameintersect;
// 		private _inter = player_objintersect;
// 		switch (_name) do {
// 			case "door3_button": {_anim = ["door_3","door_4"]};
//             case "door3_button2": {_anim = ["door_3","door_4"]};
//             case "door5_button": {_anim = ["door_5","door_6"]};
//             case "door5_button2": {_anim = ["door_5","door_6"]};
//             case "door7_button": {_anim = ["door_7","door_8"]};
//             case "door7_button2": {_anim = ["door_7","door_8"]};
//             case "door15_button": {_anim = ["door_15"]};
//             case "door15_button2": {_anim = ["door_15"]};
//             case "door13_button": {_anim = ["door_13","door_14"]};
//             case "door13_button2": {_anim = ["door_13","door_14"]};
// 		};
// 		if (_anim isEqualType []) exitwith {
// 			{
// 				if (_inter animationPhase _x < 0.1) then {
// 					_inter animate [_x,1];
// 				} else {
// 					_inter animate [_x,0];
// 				};
// 			} foreach _anim;
// 		};
// 		if (_inter animationPhase _anim < 0.1) then {
// 			_inter animate [_anim,1];
// 		} else {
// 			_inter animate [_anim,0];
// 		};
// 	}
// ],
// [
// 	"land_a3pl_sheriffpd",
// 	"Use SD Button",
// 	{
// 		private _name = player_nameintersect;
// 		private _inter = player_objintersect;
// 		switch (_name) do {
// 			case "garageDoor_button": {_anim = "garage"};
// 			case "garageDoor_button2": {_anim = "garage"};
// 			case "door3_button": {_anim = ["door3","door4"]};
// 			case "door3_button2": {_anim = ["door3","door4"]};
// 			case "door5_button": {_anim = ["door5","door6"]};
// 			case "door5_button2": {_anim = ["door5","door6"]};
// 			case "door7_button": {_anim = ["door7","door8"]};
// 			case "door7_button2": {_anim = ["door7","door8"]};
// 			case "door9_button": {_anim = ["door9","door10"]};
// 			case "door9_button2": {_anim = ["door9","door10"]};
// 			case "door11_button": {_anim = "door11"};
// 			case "door11_button2": {_anim = "door11"};
// 		};
// 		if (_anim isEqualType []) exitwith {
// 			{
// 				if (_inter animationPhase _x < 0.1) then {
// 					_inter animate [_x,1];
// 				} else {
// 					_inter animate [_x,0];
// 				};
// 			} foreach _anim;
// 		};
// 		if (_inter animationPhase _anim < 0.1) then {
// 			_inter animate [_anim,1];
// 		} else {
// 			_inter animate [_anim,0];
// 		};
// 	}
// ],
[
	"",
	"STR_Intersect_OpenCloseCellDoor",
	{
		private _name = player_nameintersect;
		private _inter = player_objintersect;
		if (_inter animationPhase _name < 0.1) then {
			_inter animate [_name,1];
		} else {
			_inter animate [_name,0];
		};
	}
],
[
	"",
	"STR_Common_SitDown",
	{[player_objintersect,player_nameintersect] call A3PL_Lib_Sit;}
],
[
	"",
	"STR_Intersect_LieDown",
	{[player_objintersect,player_nameintersect] call A3PL_Lib_Sit;}
],
[
	"",
	"STR_Intersect_Sleep",
	{[player_objintersect,player_nameintersect] call A3PL_Lib_Sit;call A3PL_Player_Sleep;}
],
[
	"",
	"STR_Intersect_GetUp",
	{
		if((player getVariable["Zipped",false]) || (player getVariable["Cuffed",false])) exitWith {[player,"a3pl_handsupkneelcuffed"] remoteExec ["A3PL_Lib_SyncAnim", -2];};
		[player,"amovppnemstpsnonwnondnon"] remoteExec ["A3PL_Lib_SyncAnim", -2];
	}
],
[
	"",
	"STR_Intersect_HackDealer",
	{[player_objintersect] spawn A3PL_Robberies_Dealership;}
],
[
	"Land_A3PL_Bank",
	"STR_Intersect_InstallDrill",
	{[player_objintersect] call A3PL_BHeist_SetDrill;}
],
[
	"Land_A3FL_Fishers_Jewelry",
	"STR_Intersect_InstallDrill",
	{[player_objintersect] call A3PL_Jewelry_SetDrill;}
],
[
	"Land_A3PL_Bank",
	"STR_Intersect_OpenIndividualChest",
	{[player_objintersect,player_nameintersect] spawn A3PL_BHeist_OpenDeposit;}
],
[
	"Land_A3PL_Bank",
	"STR_Intersect_SecureVaultDoor",
	{[player_objintersect,player_nameintersect] call A3PL_BHeist_CloseVault;}
],
[
	"Land_A3FL_Fishers_Jewelry",
	"STR_Intersect_SecureVaultDoor",
	{[player_objintersect,player_nameintersect] call A3PL_Jewelry_CloseVault;}
],
[
	"Land_A3FL_Fishers_Jewelry",
	"STR_Intersect_ToggleSafe",
	{
		_building = player_objIntersect;
		if(_building animationPhase "Vault_Door" > 0.95) then {
			_building animate ["Vault_Door",0];
		} else {
			_building animate ["Vault_Door",1];
		};
	}
],
[
	"Land_A3FL_Fishers_Jewelry",
	"STR_Intersect_BreakWindow",
	{[("STR_A3PL_QuickActions_Buildings_HitWindowsWithMeleeWeapon" call A3PL_Localize), Color_Orange] call A3PL_Notification;}
],
[
	"Land_A3FL_Fishers_Jewelry",
	"STR_Intersect_StealJewel",
	{[player_objintersect,player_nameintersect] spawn A3PL_Jewelry_PickJewelry;}
],
[
	"Land_A3FL_Better_Buy",
	"STR_Intersect_Lockpick",
	{[player_objintersect,player_nameintersect] spawn A3PL_BetterBuy_Cash;}
],
[
	"Land_A3PL_Garage",
	"STR_Intersect_CustomizeVehicle",
	{
		[player_objintersect] spawn A3PL_Garage_Open;
	}
],

[
	"Land_A3PL_Gas_Station",
	"STR_Intersect_UseStationManagement",
	{call A3PL_Hydrogen_Open;}
],
[
	"Land_A3PL_Gas_Station",
	"STR_Intersect_UseFuelPump",
	{call A3PL_Hydrogen_LockUnlock;}
],
// [
// 	"Land_A3PL_Gas_Station",
// 	"Check Rent Time Remaining",
// 	{[player_objintersect, player] remoteExec ["Server_Business_CheckRentTime",2];}
// ],
[
	"",
	"STR_Intersect_LockpickDoor",
	{[player_objintersect] call A3PL_HouseRobbery_Rob;}
],
[
	"",
	"STR_Intersect_SecureHouse",
	{[player_objintersect] call A3PL_HouseRobbery_Secure;}
],
[
	"",
	"STR_Intersect_RepairStoreAlarm",
	{[player_objintersect] call A3PL_Robberies_StoreRepair;}
],
[
	"Land_A3PL_Mailbox",
	"STR_Intersect_OpenCloseMailbox",
	{
		private _obj = player_objintersect;
		if (_obj animationPhase "door_mailbox" < 0.5) then {
			_obj animate ["door_mailbox",1];
		} else {
			_obj animate ["door_mailbox",0];
		};
	}
],
[
    "",
    "STR_Intersect_LightsOn",
    {[player_objintersect,player_nameintersect] call A3PL_Lib_SwitchLight;}
],
[
	"Land_A3PL_Impound",
	"STR_Intersect_OpenCloseFence",
	{
		_impound = player_objintersect;
		if (_impound animationSourcePhase "GarageDoor" < 0.5) then {
			_impound animateSource ["GarageDoor",1];
		} else {
			_impound animateSource ["GarageDoor",0];
		};
	}
],
[
	"",
	"STR_Intersect_UseDoorButton",
	{[player_objintersect,player_nameIntersect] call A3PL_Intersect_HandleDoors;}
],
[
	"Land_A3PL_Prison",
	"STR_Intersect_OpenCell" + str 1,
	{[player_objintersect,player_nameIntersect] call A3PL_Prison_HandleDoor;}
],
[
	"Land_A3PL_Prison",
	"STR_Intersect_OpenCell" + str 2,
	{[player_objintersect,player_nameIntersect] call A3PL_Prison_HandleDoor;}
],
[
	"Land_A3PL_Prison",
	"STR_Intersect_OpenCell" + str 3,
	{[player_objintersect,player_nameIntersect] call A3PL_Prison_HandleDoor;}
],
[
	"Land_A3PL_Prison",
	"STR_Intersect_OpenCell" + str 4,
	{[player_objintersect,player_nameIntersect] call A3PL_Prison_HandleDoor;}
],
[
	"Land_A3PL_Prison",
	"STR_Intersect_OpenCell" + str 5,
	{[player_objintersect,player_nameIntersect] call A3PL_Prison_HandleDoor;}
],
[
	"Land_A3PL_Prison",
	"STR_Intersect_OpenCell" + str 6,
	{[player_objintersect,player_nameIntersect] call A3PL_Prison_HandleDoor;}
],
[
	"Land_A3PL_Prison",
	"STR_Intersect_OpenCell" + str 7,
	{[player_objintersect,player_nameIntersect] call A3PL_Prison_HandleDoor;}
],
[
	"Land_A3PL_Prison",
	"STR_Intersect_OpenCell" + str 8,
	{[player_objintersect,player_nameIntersect] call A3PL_Prison_HandleDoor;}
],
[
	"Land_A3PL_Prison",
	"STR_Intersect_OpenCell" + str 9,
	{[player_objintersect,player_nameIntersect] call A3PL_Prison_HandleDoor;}
],
[
	"Land_A3PL_Prison",
	"STR_Intersect_OpenCell" + str 10,
	{[player_objintersect,player_nameIntersect] call A3PL_Prison_HandleDoor;}
],
[
	"Land_A3PL_Prison",
	"STR_Intersect_OpenCell" + str 11,
	{[player_objintersect,player_nameIntersect] call A3PL_Prison_HandleDoor;}
],
[
	"Land_A3PL_Prison",
	"STR_Intersect_OpenCell" + str 12,
	{[player_objintersect,player_nameIntersect] call A3PL_Prison_HandleDoor;}
],
[
	"Land_A3PL_Prison",
	"STR_Intersect_OpenCell" + str 13,
	{[player_objintersect,player_nameIntersect] call A3PL_Prison_HandleDoor;}
],
[
	"Land_A3PL_Prison",
	"STR_Intersect_OpenCell" + str 14,
	{[player_objintersect,player_nameIntersect] call A3PL_Prison_HandleDoor;}
],
[
	"Land_A3PL_Prison",
	"STR_Intersect_OpenMainCell" + str 1,
	{[player_objintersect,player_nameIntersect] call A3PL_Prison_HandleDoor;}
],
[
	"Land_A3PL_Prison",
	"STR_Intersect_OpenMainCell" + str 2,
	{[player_objintersect,player_nameIntersect] call A3PL_Prison_HandleDoor;}
],
[
	"Land_A3PL_Prison",
	"STR_Intersect_OpenDoorKitchen",
	{[player_objintersect,player_nameIntersect] call A3PL_Prison_HandleDoor;}
],
[
	"Land_A3PL_Prison",
	"STR_Intersect_OpenGarage",
	{[player_objintersect,player_nameIntersect] call A3PL_Prison_HandleDoor;}
],
[
	"Land_A3PL_Prison",
	"STR_Intersect_EmergencyProcedure",
	{[player_objintersect,player_nameIntersect] call A3PL_Prison_HandleDoor;}
],
[
	"Land_A3FL_DOC_Gate",
	"STR_Intersect_EmergencyProcedure",
	{[player_objintersect,player_nameIntersect] call A3PL_PrisonGate_HandleDoor;}
],
[
	"Land_A3FL_DOC_Gate",
	"STR_Intersect_OpenDoor" + str 1,
	{[player_objintersect,player_nameIntersect] call A3PL_PrisonGate_HandleDoor;}
],
[
	"Land_A3FL_DOC_Gate",
	"STR_Intersect_OpenDoor" + str 2,
	{[player_objintersect,player_nameIntersect] call A3PL_PrisonGate_HandleDoor;}
],
[
	"Land_A3FL_DOC_Gate",
	"STR_Intersect_OpenDoor" + str 3,
	{[player_objintersect,player_nameIntersect] call A3PL_PrisonGate_HandleDoor;}
],
[
	"Land_A3FL_DOC_Gate",
	"STR_Intersect_OpenDoor" + str 4,
	{[player_objintersect,player_nameIntersect] call A3PL_PrisonGate_HandleDoor;}
],
[
	"Land_A3FL_DOC_Gate",
	"STR_Intersect_OpenDoor" + str 5,
	{[player_objintersect,player_nameIntersect] call A3PL_PrisonGate_HandleDoor;}
],
[
	"Land_A3FL_DOC_Gate",
	"STR_Intersect_OpenDoor" + str 6,
	{[player_objintersect,player_nameIntersect] call A3PL_PrisonGate_HandleDoor;}
],
[
	"Land_A3FL_DOC_Gate",
	"STR_Intersect_OpenDoor" + str 7,
	{[player_objintersect,player_nameIntersect] call A3PL_PrisonGate_HandleDoor;}
],
[
	"Land_A3FL_DOC_Gate",
	"STR_Intersect_OpenDoor" + str 8,
	{[player_objintersect,player_nameIntersect] call A3PL_PrisonGate_HandleDoor;}
],
[
	"Land_A3FL_DOC_Gate",
	"STR_Intersect_OpenDoor" + str 9,
	{[player_objintersect,player_nameIntersect] call A3PL_PrisonGate_HandleDoor;}
],
[
	"Land_A3FL_DOC_Gate",
	"STR_Intersect_OpenDoor" + str 9,
	{[player_objintersect,player_nameIntersect] call A3PL_PrisonGate_HandleDoor;}
],
[
	"Land_A3FL_DOC_Gate",
	"STR_Intersect_OpenDoor" + str 10,
	{[player_objintersect,player_nameIntersect] call A3PL_PrisonGate_HandleDoor;}
],
[
	"Land_A3FL_DOC_Gate",
	"STR_Intersect_OpenGateFront",
	{[player_objintersect,player_nameIntersect] call A3PL_PrisonGate_HandleDoor;}
],
[
	"Land_A3FL_DOC_Gate",
	"STR_Intersect_OpenGateRear",
	{[player_objintersect,player_nameIntersect] call A3PL_PrisonGate_HandleDoor;}
],
// [
// 	"Land_A3PL_CH",
// 	"Open / Close Hall Accused",
// 	{call A3PL_Intersect_HandleDoors;}
// ],
// [
// 	"Land_A3PL_CH",
// 	"Open / Close Hall Accused",
// 	{call A3PL_Intersect_HandleDoors;}
// ],
[
	"",
	"STR_Intersect_LockUnlockDoor2",
	{
		private ["_keyid","_obj","_locked","_format","_keyCheck","_name","_getVarName"];
		_obj = Player_ObjIntersect;
		_name = player_nameintersect;
		if (isNil "Player_Item") exitwith {	_format = format["STR_A3PL_QuickActions_Buildings_YouDoNotHaveKeysInYourHands"]; [_format call A3PL_Localize, Color_Red] call A3PL_Notification; };
		if (isNull Player_Item) exitwith { _format = format["STR_A3PL_QuickActions_Buildings_YouDoNotHaveKeysInYourHands"]; [_format call A3PL_Localize, Color_Red] call A3PL_Notification; };
		_keyID = Player_Item getVariable "keyID";
		if (isNil "_keyID") exitwith {_format = format["STR_A3PL_QuickActions_Buildings_YouCantOpenDoorWithThisObject"]; [_format call A3PL_Localize, Color_Red] call A3PL_Notification;};
		_keyCheck = false;
		if (typeOf _obj == "Land_A3PL_Motel") then {
			_keyCheck = [_obj,_keyID,_name] call A3PL_Housing_CheckOwn;
		} else {
			_keyCheck = [_obj,_keyID] call A3PL_Housing_CheckOwn;
		};
		if (_keyCheck) then {
			_getVarName = "unlocked";
			if (typeOf _obj == "Land_A3PL_Motel") exitwith {
				_getVarName = format ["%1_locked",_name];
				if ((_obj getVariable [_getVarName,true])) then {
					_obj setVariable [_getVarName,false,true];
					player playAction "gesture_key";
					_format = format["STR_A3PL_QuickActions_Buildings_YouUnlockTheDoor"]; [_format call A3PL_Localize, Color_Green] call A3PL_Notification;
				}else{
					_obj setVariable [_getVarName,true,true];
					player playAction "gesture_key";
					_format = format["STR_A3PL_QuickActions_Buildings_YouLockTheDoor"]; [_format call A3PL_Localize, Color_Red] call A3PL_Notification;
				};
			};
			_locked = _obj getVariable [_getVarName,nil];
			if (isNil "_locked") then {
				_obj setVariable [_getVarName,true,true];
				_format = format["STR_A3PL_QuickActions_Buildings_YouUnlockTheDoor"]; [_format call A3PL_Localize, Color_Green] call A3PL_Notification;
			} else {
				_obj setVariable [_getVarName,Nil,true];
				_format = format["STR_A3PL_QuickActions_Buildings_YouLockTheDoor"]; [_format call A3PL_Localize, Color_Red] call A3PL_Notification;
			};
			player playAction "gesture_key";
		} else {
			_format = format["STR_A3PL_QuickActions_Buildings_ThisKeyCantOpenThisDoor"]; [_format call A3PL_Localize, Color_Red] call A3PL_Notification;
		};
	}
],
// [
// 	"Land_A3PL_GreenhouseSign",
// 	"Rent Greenhouse",
// 	{[player_objIntersect] call A3PL_JobFarming_Rent;}
// ],
// [
// 	"Land_A3PL_BusinessSign",
// 	"Louer Business",
// 	{[player_objIntersect] call A3PL_Business_Buy;}
// ],
[
	"Land_A3PL_BusinessSign",
	"STR_Intersect_BuyBusiness",
	{call A3PL_Company_OpenBuyShop;}
],
[
	"Land_A3PL_BusinessSign",
	"STR_Intersect_SellBusiness",
	{call A3PL_Company_OpenSellShop;}
],
[
	"Land_A3PL_BusinessSign",
	"STR_Intersect_BuyWarehouse",
	{[player_objIntersect] call A3PL_Warehouses_OpenBuyMenu;}
],
[
	"Land_A3PL_BusinessSign",
	"STR_Intersect_SellWarehouse",
	{[player_objIntersect] call A3PL_Warehouses_SellOpen;}
],
[
	"Land_A3PL_BusinessSign",
	"STR_Intersect_BuyCrackhouse",
	{[player_objIntersect] call A3PL_Crackhouses_OpenBuyMenu;}
],
[
	"Land_A3PL_BusinessSign",
	"STR_Intersect_SellCrackhouse",
	{[player_objIntersect] call A3PL_Crackhouses_SellOpen;}
],
[
	"Land_A3PL_BusinessSign",
	"STR_Intersect_ManageRoommates",
	{[player] remoteExec ["Server_Warehouses_GetRoommates", 2];}
],
[
	"Land_A3PL_BusinessSign",
	"STR_Intersect_QuitColocation",
	{[] call A3PL_Warehouses_LeaveWarehouse;}
],
[
	"Land_A3PL_EstateSign",
	"STR_Intersect_BuyHouse",
	{
		[player_objIntersect] call A3PL_Housing_OpenBuyMenu;
	}
],
[
	"Land_A3PL_EstateSign",
	"STR_Intersect_SellHouse",
	{[player_objintersect] call A3PL_RealEstates_Open;}
],
[
	"Land_A3PL_EstateSign",
	"STR_Intersect_ManageRoommates",
	{[player] remoteExec ["Server_Housing_GetRoommates", 2];}
],
[
	"Land_A3PL_EstateSign",
	"STR_Intersect_QuitColocation",
	{[] call A3PL_Housing_LeaveHouse;}
],
[
	"Land_A3PL_Showroom",
	"STR_Intersect_OpenDealerDoors",
	{
		private _obj = player_objintersect;
		private _name = player_nameIntersect;
		if ((isNull _obj) or (_name == "")) exitwith {[("STR_A3PL_QuickActions_Buildings_YouCantCloseDealerDoors" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (!(typeOf _obj == "Land_A3PL_Showroom")) exitwith {[("STR_A3PL_QuickActions_Buildings_YoureNotLookingTheDealer" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (_name == "garage1_open") then {
			_obj animateSource ["garage2",1];
		} else {
			_obj animateSource ["garage1",1];
		};
	}
],
[
	"Land_A3PL_Showroom",
	"STR_Intersect_CloseDealerDoors",
	{
		private _obj = player_objintersect;
		private _name = player_nameIntersect;
		if ((isNull _obj) or (_name == "")) exitwith {[("STR_A3PL_QuickActions_Buildings_YouCantCloseDealerDoors" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (!(typeOf _obj == "Land_A3PL_Showroom")) exitwith {[("STR_A3PL_QuickActions_Buildings_YoureNotLookingTheDealer" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (_name == "garage1_close") then {
			_obj animateSource ["garage2",0];
		} else {
			_obj animateSource ["garage1",0];
		};
	}
],
[
	"Land_A3PL_Garage",
	"STR_Intersect_UseVehicleElevator",
	{[player_objintersect] spawn A3PL_JobMechanic_UseLift;}
],
[
	"",
	"STR_Intersect_Knock",
	{playSound3D ["A3PL_Common\effects\knockdoor.ogg", player, true, getPosASL player, 3, 1, 10];}
],
[
	"",
	"STR_Intersect_LockpickCell",
	{[player_nameintersect, player_objIntersect] spawn A3PL_Prison_LockpickCell;}
],
[
	"",
	"STR_Intersect_BarricadeWindow" + str 1,
	{
		private _obj = player_objintersect;
		if (Player_ItemClass == "woodpl") then {
			_obj animateSource ["barricade1_unhide",1];
			[player,"woodpl",-1] remoteExec ["Server_Inventory_Add",2];
			[] call A3PL_Inventory_Clear;
		} else {
			[("STR_A3PL_QuickActions_Buildings_YouNeedWoodenPl" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};
	}
],
[
	"",
	"STR_Intersect_BarricadeWindow" + str 2,
	{
		private _obj = player_objintersect;
		if (Player_ItemClass == "woodpl") then {
			_obj animateSource ["barricade2_unhide",1];
			[player,"woodpl",-1] remoteExec ["Server_Inventory_Add",2];
			[] call A3PL_Inventory_Clear;
		} else {
			[("STR_A3PL_QuickActions_Buildings_YouNeedWoodenPl" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};
	}
],
[
	"",
	"STR_Intersect_BarricadeWindow" + str 3,
	{
		private _obj = player_objintersect;
		if (Player_ItemClass == "woodpl") then {
			_obj animateSource ["barricade3_unhide",1];
			[player,"woodpl",-1] remoteExec ["Server_Inventory_Add",2];
			[] call A3PL_Inventory_Clear;
		} else {
			[("STR_A3PL_QuickActions_Buildings_YouNeedWoodenPl" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};
	}
],
[
	"",
	"STR_Intersect_BarricadeWindow" + str 4,
	{
		private _obj = player_objintersect;
		if (Player_ItemClass == "woodpl") then {
			_obj animateSource ["barricade4_unhide",1];
			[player,"woodpl",-1] remoteExec ["Server_Inventory_Add",2];
			[] call A3PL_Inventory_Clear;
		} else {
			[("STR_A3PL_QuickActions_Buildings_YouNeedWoodenPl" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};
	}
],
[
	"",
	"STR_Intersect_BarricadeWindow" + str 5,
	{
		private _obj = player_objintersect;
		if (Player_ItemClass == "woodpl") then {
			_obj animateSource ["barricade5_unhide",1];
			[player,"woodpl",-1] remoteExec ["Server_Inventory_Add",2];
			[] call A3PL_Inventory_Clear;
		} else {
			[("STR_A3PL_QuickActions_Buildings_YouNeedWoodenPl" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};
	}
],
[
	"",
	"STR_Intersect_BarricadeWindow" + str 6,
	{
		private _obj = player_objintersect;
		if (Player_ItemClass == "woodpl") then {
			_obj animateSource ["barricade6_unhide",1];
			[player,"woodpl",-1] remoteExec ["Server_Inventory_Add",2];
			[] call A3PL_Inventory_Clear;
		} else {
			[("STR_A3PL_QuickActions_Buildings_YouNeedWoodenPl" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};
	}
],
[
	"",
	"STR_Intersect_BarricadeWindow" + str 7,
	{
		private _obj = player_objintersect;
		if (Player_ItemClass == "woodpl") then {
			_obj animateSource ["barricade7_unhide",1];
			[player,"woodpl",-1] remoteExec ["Server_Inventory_Add",2];
			[] call A3PL_Inventory_Clear;
		} else {
			[("STR_A3PL_QuickActions_Buildings_YouNeedWoodenPl" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};
	}
],
[
	"",
	"STR_Intersect_BarricadeWindow" + str 8,
	{
		private _obj = player_objintersect;
		if (Player_ItemClass == "woodpl") then {
			_obj animateSource ["barricade8_unhide",1];
			[player,"woodpl",-1] remoteExec ["Server_Inventory_Add",2];
			[] call A3PL_Inventory_Clear;
		} else {
			[("STR_A3PL_QuickActions_Buildings_YouNeedWoodenPl" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};
	}
],
[
	"",
	"STR_Intersect_BarricadeDoorTop",
	{
		private _obj = player_objintersect;
		if (Player_ItemClass == "woodpl") then {
			_obj animateSource ["barricade9_unhide",1];
			[player,"woodpl",-1] remoteExec ["Server_Inventory_Add",2];
			[] call A3PL_Inventory_Clear;
		} else {
			[("STR_A3PL_QuickActions_Buildings_YouNeedWoodenPl" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};
	}
],
[
	"",
	"STR_Intersect_BarricadeDoorBottom",
	{
		private _obj = player_objintersect;
		if (Player_ItemClass == "woodpl") then {
			_obj animateSource ["barricade10_unhide",1];
			[player,"woodpl",-1] remoteExec ["Server_Inventory_Add",2];
			[] call A3PL_Inventory_Clear;
		} else {
			[("STR_A3PL_QuickActions_Buildings_YouNeedWoodenPl" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};
	}
],
[
	"",
	"STR_Intersect_UnBarricadeWindow" + str 1,
	{
		private _obj = player_objintersect;
		_obj animateSource ["barricade1_unhide",0];
		[player,"woodpl",1] remoteExec ["Server_Inventory_Add",2];
		[] call A3PL_Inventory_Clear;
	}
],
[
	"",
	"STR_Intersect_UnBarricadeWindow" + str 2,
	{
		private _obj = player_objintersect;
		_obj animateSource ["barricade2_unhide",0];
		[player,"woodpl",1] remoteExec ["Server_Inventory_Add",2];
		[] call A3PL_Inventory_Clear;
	}
],
[
	"",
	"STR_Intersect_UnBarricadeWindow" + str 3,
	{
		private _obj = player_objintersect;
		_obj animateSource ["barricade3_unhide",0];
		[player,"woodpl",1] remoteExec ["Server_Inventory_Add",2];
		[] call A3PL_Inventory_Clear;
	}
],
[
	"",
	"STR_Intersect_UnBarricadeWindow" + str 4,
	{
		private _obj = player_objintersect;
		_obj animateSource ["barricade4_unhide",0];
		[player,"woodpl",1] remoteExec ["Server_Inventory_Add",2];
		[] call A3PL_Inventory_Clear;
	}
],
[
	"",
	"STR_Intersect_UnBarricadeWindow" + str 5,
	{
		private _obj = player_objintersect;
		_obj animateSource ["barricade5_unhide",0];
		[player,"woodpl",1] remoteExec ["Server_Inventory_Add",2];
		[] call A3PL_Inventory_Clear;
	}
],
[
	"",
	"STR_Intersect_UnBarricadeWindow" + str 6,
	{
		private _obj = player_objintersect;
		_obj animateSource ["barricade6_unhide",0];
		[player,"woodpl",1] remoteExec ["Server_Inventory_Add",2];
		[] call A3PL_Inventory_Clear;
	}
],
[
	"",
	"STR_Intersect_UnBarricadeWindow" + str 7,
	{
		private _obj = player_objintersect;
		_obj animateSource ["barricade7_unhide",0];
		[player,"woodpl",1] remoteExec ["Server_Inventory_Add",2];
		[] call A3PL_Inventory_Clear;
	}
],
[
	"",
	"STR_Intersect_UnBarricadeWindow" + str 8,
	{
		private _obj = player_objintersect;
		_obj animateSource ["barricade8_unhide",0];
		[player,"woodpl",1] remoteExec ["Server_Inventory_Add",2];
		[] call A3PL_Inventory_Clear;
	}
],
[
	"",
	"STR_Intersect_UnBarricadeDoorTop",
	{
		private _obj = player_objintersect;
		_obj animateSource ["barricade9_unhide",0];
		[player,"woodpl",1] remoteExec ["Server_Inventory_Add",2];
		[] call A3PL_Inventory_Clear;
	}
],
[
	"",
	"STR_Intersect_UnBarricadeDoorBottom",
	{
		private _obj = player_objintersect;
		_obj animateSource ["barricade10_unhide",0];
		[player,"woodpl",1] remoteExec ["Server_Inventory_Add",2];
		[] call A3PL_Inventory_Clear;
	}
],
[
	"",
	"STR_Intersect_ToggleBlinds",
	{
		private _obj = player_objintersect;
		if (_obj animationPhase "windows_blind_unhide" == 0) then {
			_obj animateSource ["windows_blind_unhide",1];
		} else {
			_obj animateSource ["windows_blind_unhide",0];
		};
	}
],
[
	"Land_KarmaLanes",
	"STR_Intersect_ViewScores",
	{
		if (Activity_Bowling) then {
			call A3PL_Bowling_BScoreOpen;
		} else {
			[("STR_A3PL_QuickActions_Buildings_BowlingNotActivated" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};
	}
],
[
	"Land_KarmaLanes",
	"STR_Intersect_Bowling",
	{
		if (Activity_Bowling) then {
			call A3PL_Bowling_BOpen;
		} else {
			[("STR_A3PL_QuickActions_Buildings_BowlingNotActivated" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};
	}
],
[
	"",
	"STR_Intersect_UseKeypad",
	{
		[Player_ObjIntersect, Player_NameIntersect] call A3PL_Keypad_OpenFromInteraction;
	}
],
[
	"",
	"STR_Intersect_HackKeypad",
	{
		player setVariable ["player_hacking",true,true];
		[Player_ObjIntersect, Player_NameIntersect] call A3PL_Keypad_OpenFromInteraction;
	}
]
