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
	"",
	"STR_Intersect_NPCRepair",
	{call A3PL_Garage_NPCRepair;}
],
[
	"",
	"STR_Intersect_ConfigureShopMarker",
	{call A3PL_Company_ConfigShopMarker;}
],
[
    "",
   "STR_Intersect_AccessMDT",
    {
        private _job = player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
        if !(_job IN [("STR_Common_FISD" call A3PL_Localize)]) exitWith {[("STR_A3PL_QuickActions_NPC_OnlySDCanUseComputers" call A3PL_Localize), Color_Red] call A3PL_Notification;};
        if (isNull (findDisplay 211)) then {
            [player_objintersect] call A3PL_Police_OpenMDT;
        };
    }
],
[
	"",
	"STR_Intersect_AccessCriminalShop",
	{["Shop_CrimeBase"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Intersect_GasStationShop",
	{["Shop_Gas_Station"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Intersect_SportsStore",
	{["Shop_Big_Dicks_Sports"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Intersect_RobMover",
	{[player_objintersect,player_nameintersect] spawn A3PL_BetterBuy_Furniture;}
],
[
	"",
	"STR_Intersect_ReturnWorkVehicle",
	{[] call A3PL_Lib_JobVehicle_Return;}
],
[
	"",
	"STR_Intersect_DeliverStolenGoods",
	{[player_objintersect] spawn A3PL_BetterBuy_Deliver;}
],
[
	"",
	"STR_Intersect_DeliverStolenCar",
	{call A3PL_Robberies_DealershipDeliver;}
],
[
	"",
	"STR_Intersect_StartGoFast",
	{[player_objintersect] spawn A3PL_Robberies_GoFast;}
],
[
	"",
	"STR_Intersect_FinishGoFast",
	{call A3PL_Robberies_GoFastDeliver;}
],
[
	"",
	"STR_Intersect_DeliverFurniture",
	{[player_objintersect] spawn A3PL_BetterBuy_JobDeliver;}
],
[
	"",
	"STR_Intersect_MovingShop",
	{["Shop_BetterBuy"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Intersect_TalkIllegalTrader",
	{["Shop_Ill_Trader"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Intersect_TalkMoonshineDealer",
	{["Shop_Ill_Moonshine"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Intersect_TalkCocaineDealer",
	{["Shop_Ill_Cocaine"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Intersect_TalkMushroomDealer",
	{["Shop_Ill_Shrooms"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Intersect_RentTaxi",
	{[player_objintersect,'A3PL_CVPI_Taxi',9751] call A3PL_JobTaxi_RentVehicle;}
],
[
	"",
	"STR_Intersect_TalkWeedDealer",
	{["Shop_Ill_Weed"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Intersect_BoatStore",
	{["Shop_Boat_Safety"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Common_FactoryName_Steel",
	{
		private _isCorporate = [(player getVariable ["character_id",""])] call A3PL_Config_InCompany;
		private _hasLicense = [player,"steelf"] call A3PL_Company_HasLicense;
		private _job = player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
		if(!_isCorporate) exitWith {[("STR_Common_NotInCompany" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (_job isNotEqualTo ("STR_Common_Company" call A3PL_Localize)) exitWith {[("STR_A3PL_QuickActions_NPC_NotOnDutyToUseThisFactory" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (!_hasLicense) exitWith {[("STR_A3PL_QuickActions_NPC_CompanyNotAuthorizedToUseThisFactory" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		["STR_Common_FactoryName_Steel"] call A3PL_Factory_Open;
	}
],
[
	"",
	"STR_Intersect_FoodFactory",
	{
		private _isCorporate = [(player getVariable ["character_id",""])] call A3PL_Config_InCompany;
		private _hasLicense = [player,"foodf"] call A3PL_Company_HasLicense;
		private _job = player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
		if(!_isCorporate) exitWith {[("STR_Common_NotInCompany" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (_job isNotEqualTo ("STR_Common_Company" call A3PL_Localize)) exitWith {[("STR_A3PL_QuickActions_NPC_NotOnDutyToUseThisFactory" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (!_hasLicense) exitWith {[("STR_A3PL_QuickActions_NPC_CompanyNotAuthorizedToUseThisFactory" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		["STR_Common_FactoryName_Foods"] call A3PL_Factory_Open;
	}
],
[
	"",
	"STR_Intersect_TakeFakeIdentity",
	{call A3PL_Police_FakeID;}
],
[
	"",
	"STR_Common_FactoryName_Petrol",
	{
		private _isCorporate = [(player getVariable ["character_id",""])] call A3PL_Config_InCompany;
		private _hasLicense = [player,"petrolf"] call A3PL_Company_HasLicense;
		private _job = player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
		if(!_isCorporate) exitWith {[("STR_Common_NotInCompany" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (_job isNotEqualTo ("STR_Common_Company" call A3PL_Localize)) exitWith {[("STR_A3PL_QuickActions_NPC_NotOnDutyToUseThisFactory" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (!_hasLicense) exitWith {[("STR_A3PL_QuickActions_NPC_CompanyNotAuthorizedToUseThisFactory" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		["STR_Common_FactoryName_Petrol"] call A3PL_Factory_Open;
	}
],
[
	"",
	"STR_Intersect_SFPShop",
	{
		if((player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) isNotEqualTo "STR_Common_Job_SecurityAgent") exitWith {[("STR_A3PL_QuickActions_NPC_YoureNotWorkingForSS" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		["Shop_SFP"] call A3PL_Shop_Open;
	}
],
[
	"",
	"STR_Intersect_GoodsFactory",
	{
		private _isCorporate = [(player getVariable ["character_id",""])] call A3PL_Config_InCompany;
		private _hasLicense = [player,"goodsf"] call A3PL_Company_HasLicense;
		private _job = player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
		if(!_isCorporate) exitWith {[("STR_Common_NotInCompany" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (_job isNotEqualTo ("STR_Common_Company" call A3PL_Localize)) exitWith {[("STR_A3PL_QuickActions_NPC_NotOnDutyToUseThisFactory" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (!_hasLicense) exitWith {[("STR_A3PL_QuickActions_NPC_CompanyNotAuthorizedToUseThisFactory" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		["STR_Common_FactoryName_Goods"] call A3PL_Factory_Open;
	}
],
[
    "",
   "STR_Intersect_JewelryFactory",
    {
        private _isCorporate = [(player getVariable ["character_id",""])] call A3PL_Config_InCompany;
        private _hasLicense = [player,"jewelryf"] call A3PL_Company_HasLicense;
        private _job = player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
        if(!_isCorporate) exitWith {[("STR_Common_NotInCompany" call A3PL_Localize), Color_Red] call A3PL_Notification;};
        if (_job isNotEqualTo ("STR_Common_Company" call A3PL_Localize)) exitWith {[("STR_A3PL_QuickActions_NPC_NotOnDutyToUseThisFactory" call A3PL_Localize), Color_Red] call A3PL_Notification;};
        if (!_hasLicense) exitWith {[("STR_A3PL_QuickActions_NPC_CompanyNotAuthorizedToUseThisFactory" call A3PL_Localize), Color_Red] call A3PL_Notification;};
        ["STR_Common_FactoryName_Jewelry"] call A3PL_Factory_Open;
    }
],
[
	"",
	"STR_Intersect_FactionWeaponFactory",
	{
		private _isCorporate = [(player getVariable ["character_id",""])] call A3PL_Config_InCompany;
		private _hasLicense = [player,"weaponf"] call A3PL_Company_HasLicense;
		private _job = player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
		if(!_isCorporate) exitWith {[("STR_Common_NotInCompany" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (_job isNotEqualTo ("STR_Common_Company" call A3PL_Localize)) exitWith {[("STR_A3PL_QuickActions_NPC_NotOnDutyToUseThisFactory" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (!_hasLicense) exitWith {[("STR_A3PL_QuickActions_NPC_CompanyNotAuthorizedToUseThisFactory" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		["STR_Common_FactoryName_FactionWeapons"] call A3PL_Factory_Open;
	}
],
[
	"",
	"STR_Intersect_VehicleFactory",
	{
		private _isCorporate = [(player getVariable ["character_id",""])] call A3PL_Config_InCompany;
		private _hasLicense = [player,"carf"] call A3PL_Company_HasLicense;
		private _job = player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
		if(!_isCorporate) exitWith {[("STR_Common_NotInCompany" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (_job isNotEqualTo ("STR_Common_Company" call A3PL_Localize)) exitWith {[("STR_A3PL_QuickActions_NPC_NotOnDutyToUseThisFactory" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (!_hasLicense) exitWith {[("STR_A3PL_QuickActions_NPC_CompanyNotAuthorizedToUseThisFactory" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		["STR_Common_FactoryName_Vehicles"] call A3PL_Factory_Open;
	}
],
[
	"",
	"STR_Intersect_FactionVehicleFactory",
	{
		private _isCorporate = [(player getVariable ["character_id",""])] call A3PL_Config_InCompany;
		private _hasLicense = [player,"carf"] call A3PL_Company_HasLicense;
		private _job = player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
		if(!_isCorporate) exitWith {[("STR_Common_NotInCompany" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (_job isNotEqualTo ("STR_Common_Company" call A3PL_Localize)) exitWith {[("STR_A3PL_QuickActions_NPC_NotOnDutyToUseThisFactory" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (!_hasLicense) exitWith {[("STR_A3PL_QuickActions_NPC_CompanyNotAuthorizedToUseThisFactory" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		["STR_Common_FactoryName_FactionVehicles"] call A3PL_Factory_Open;
	}
],
[
	"",
	"STR_Common_MarineFactory",
	{
		private _isCorporate = [(player getVariable ["character_id",""])] call A3PL_Config_InCompany;
		private _hasLicense = [player,"boatf"] call A3PL_Company_HasLicense;
		private _job = player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
		if(!_isCorporate) exitWith {[("STR_Common_NotInCompany" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (_job isNotEqualTo ("STR_Common_Company" call A3PL_Localize)) exitWith {[("STR_A3PL_QuickActions_NPC_NotOnDutyToUseThisFactory" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (!_hasLicense) exitWith {[("STR_A3PL_QuickActions_NPC_CompanyNotAuthorizedToUseThisFactory" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		["STR_Common_FactoryName_Boats"] call A3PL_Factory_Open;
	}
],
[
	"",
	"STR_Intersect_AircraftFactory",
	{
		private _isCorporate = [(player getVariable ["character_id",""])] call A3PL_Config_InCompany;
		private _hasLicense = [player,"airf"] call A3PL_Company_HasLicense;
		private _job = player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
		if(!_isCorporate) exitWith {[("STR_Common_NotInCompany" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (_job isNotEqualTo ("STR_Common_Company" call A3PL_Localize)) exitWith {[("STR_A3PL_QuickActions_NPC_NotOnDutyToUseThisFactory" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (!_hasLicense) exitWith {[("STR_A3PL_QuickActions_NPC_CompanyNotAuthorizedToUseThisFactory" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		["STR_Common_FactoryName_Aircrafts"] call A3PL_Factory_Open;
	}
],
[
	"",
	"STR_Intersect_ChemicalFactory",
	{
		private _isCorporate = [(player getVariable ["character_id",""])] call A3PL_Config_InCompany;
		private _hasLicense = [player,"chimicalf"] call A3PL_Company_HasLicense;
		private _job = player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
		if(!_isCorporate) exitWith {[("STR_Common_NotInCompany" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (_job isNotEqualTo ("STR_Common_Company" call A3PL_Localize)) exitWith {[("STR_A3PL_QuickActions_NPC_NotOnDutyToUseThisFactory" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (!_hasLicense) exitWith {[("STR_A3PL_QuickActions_NPC_CompanyNotAuthorizedToUseThisFactory" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		["STR_Common_FactoryName_Chimical"] call A3PL_Factory_Open;
	}
],
[
	"",
	"STR_Common_WeaponFactory",
	{
		private _isCorporate = [(player getVariable ["character_id",""])] call A3PL_Config_InCompany;
		private _hasLicense = [player,"weaponf"] call A3PL_Company_HasLicense;
		private _job = player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
		if(!_isCorporate) exitWith {[("STR_Common_NotInCompany" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (_job isNotEqualTo ("STR_Common_Company" call A3PL_Localize)) exitWith {[("STR_A3PL_QuickActions_NPC_NotOnDutyToUseThisFactory" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (!_hasLicense) exitWith {[("STR_A3PL_QuickActions_NPC_CompanyNotAuthorizedToUseThisFactory" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		["STR_Common_FactoryName_LegalWeapons"] call A3PL_Factory_Open;
	}
],
[
	"",
	"STR_Intersect_IllegalWeaponFactory",
	{["STR_Common_FactoryName_IllegalWeapons"] call A3PL_Factory_Open;}
],
[
	"",
	"STR_Intersect_TalkToEmployee",
	{["company_initial"] call A3PL_NPC_Start;}
],
[
	"",
	"STR_Intersect_CreateCompany",
	{
		if (["company",player] call A3PL_DMV_Check) then {
			call A3PL_Company_CreateOpen;
		} else {
			[("STR_A3PL_QuickActions_NPC_YouNeedToDepositFilesToDOJToCreateCompany" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};
	}
],
[
	"",
	"STR_Intersect_CompanyManagement",
	{
		call A3PL_Company_ManageOpen;
	}
],
[
	"",
	"STR_Intersect_ModifyOpenClosedStatus",
	{
		[player] remoteExec ["Server_Company_UpdateShopMarker",2];
	}
],
[
	"",
	"STR_Intersect_ShopManagement",
	{
		call A3PL_CompanyShop_Man_Open;
	}
],
[
	"",
	"STR_Intersect_ResignFromCompany",
	{call A3PL_Company_Resign;}
],
[
	"",
	"STR_Intersect_Factory",
	{["company",(player_objintersect getVariable ["cid",0])] call A3PL_FactoryV2_Open;}
],
[
	"",
	"STR_Intersect_Factory2",
	{["company",[(player getVariable ["character_id",0])] call A3PL_Config_GetCompanyID] call A3PL_FactoryV2_Open;}
],
[
	"",
	"STR_Intersect_CompanyBankAccount",
	{call A3PL_Company_HistoryOpen;}
],
[
	"",
	"STR_Intersect_FISDManagement",
	{[("STR_Common_FISD" call A3PL_Localize)] call A3PL_Government_FactionSetup;}
],
[
	"",
	"STR_Intersect_DOJManagement",
	{[("STR_Common_DOJ" call A3PL_Localize)] call A3PL_Government_FactionSetup;}
],
[
	"",
	"STR_Intersect_GOVManagement",
	{[("STR_Common_GOV" call A3PL_Localize)] call A3PL_Government_FactionSetup;}
],
[
    "",
    "STR_Intersect_FactionManagement",
    {call A3PL_Government_OpenTreasury;}
],
[
	"",
	"STR_Intersect_AccessFactionAccount",
	{call A3PL_Government_Budget;}
],
[
	"",
	"STR_Intersect_TalkPortCaptain",
	{["port_initial"] call A3PL_NPC_Start;}
],
[
	"",
	"STR_Intersect_TalkTrainer",
	{["sport_start"] call A3PL_NPC_Start;}
],
[
	"",
	"STR_Intersect_FindNewJob",
	{["jobcenter_initial"] call A3PL_NPC_Start;}
],
[
	"",
	"STR_Intersect_QuitCurrentJob",
	{call A3PL_NPC_LeaveJob;}
],
[
	"",
	"STR_Intersect_StartExterminationMission",
	{call A3PL_Exterminator_Start;}
],
[
	"",
	"STR_Intersect_SellNearbyVehicle",
	{["vehiclesell_initial"] call A3PL_NPC_Start;}
],
[
	"A3PL_DogCage",
	"STR_Intersect_OpenK9Cage",
	{call A3PL_Dogs_OpenMenu;}
],
[
	"A3PL_DogCage",
	"STR_Intersect_DepositK9",
	{call A3PL_Dogs_ReturnDog;}
],
[
	"",
	"STR_Intersect_OpenImportExport",
	{ call A3PL_IE_Open;}
],
[
	"",
	"STR_Intersect_MoneyLaunderer",
	{[player_objintersect] spawn A3PL_BHeist_ConvertCash;}
],
[
	"",
	"STR_Intersect_PhotocopyBlueprint",
	{call A3PL_Criminal_Print;}
],
[
	"",
	"STR_Intersect_FindIllegalPosition",
	{["find_illtrader_initial"] call A3PL_NPC_Start;}
],
[
	"",
	"STR_Intersect_FurnitureStore",
	{["Shop_Furniture2"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Intersect_TakeControlOfShip",
	{[] spawn A3PL_Robberies_PirateShip;}
],
[
	"",
	"STR_Intersect_CaptureFlag",
	{[] spawn A3PL_Capture_Flag;}
],
[
	"",
	"STR_Intersect_PaintballShop",
	{["Shop_Paintball"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Intersect_MoonshineShop",
	{["Shop_Buckeye"] call A3PL_Shop_Open;}
],
// [
// 	"",
// 	"Moonshine Trader",
// 	{["Shop_Moonshine"] call A3PL_Shop_Open;}
// ],
[
	"",
	"STR_Intersect_LumberjackShop",
	{["Shop_Hemlock"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Intersect_ChemicalDealer",
	{["Shop_ChemicalSupplies"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Intersect_RemoveElectronicBracelet",
	{call A3PL_Criminal_RemoveTime;}
],
[
	"",
	"STR_Intersect_GarbageShop",
	{["Shop_WasteManagement"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Intersect_ExterminatorShop",
	{["Shop_ExterminatorJob"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Intersect_DeliverymanShop",
	{["Shop_DeliveryJob"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Intersect_StartPickupTour",
	{[] spawn A3PL_Waste_StartJob;}
],
[
	"",
	"STR_Intersect_StartDeliveryTour",
	{[player_objintersect] spawn A3PL_Delivery_StartJob;}
],
[
	"",
	"STR_Intersect_StartStopKartRental",
	{call A3PL_Karts_Rent;}
],
[
	"",
	"STR_Intersect_BuyIronMap",
	{[("STR_Common_Iron") call A3PL_Localize] call A3PL_JobWildCat_BuyMap;}
],
[
	"",
	"STR_Intersect_BuyCoalMap",
	{[("STR_Common_Coal") call A3PL_Localize] call A3PL_JobWildCat_BuyMap;}
],
[
	"",
	"STR_Intersect_BuyBauxiteMap",
	{[("STR_Common_Bauxite") call A3PL_Localize] call A3PL_JobWildCat_BuyMap;}
],
[
	"",
	"STR_Intersect_BuySulfurMap",
	{[("STR_Common_Soufre") call A3PL_Localize] call A3PL_JobWildCat_BuyMap;}
],
[
	"",
	"STR_Intersect_BuyOilMap",
	{[("STR_Common_Oil") call A3PL_Localize] call A3PL_JobWildCat_BuyMap;}
],
[
	"",
	"STR_Intersect_BuyRareResourcesMap",
	{[player_objintersect] call A3PL_JobWildcat_RareMaps;}
],
[
	"",
	"STR_Intersect_MiningShop",
	{["Shop_MiningMike"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Intersect_FurnitureStore2",
	{["Shop_Furniture"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Intersect_GeneralStore",
	{["Shop_General_Supplies"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Intersect_HardwareStore",
	{["Shop_Hardware"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Intersect_AgricultureStore",
	{["Shop_Seeds"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Intersect_EMSStorage",
	{
		[player_objintersect] call A3PL_Stock_View_AskOpen;
	}
],
[
	"",
	"STR_Intersect_ManageEMSStorage",
	{
		[player_objintersect] call A3PL_Stock_Man_AskOpen;
	}
],
[
	"",
	"STR_Intersect_FIFRStorage",
	{
		[player_objintersect] call A3PL_Stock_View_AskOpen;
	}
],
[
	"",
	"STR_Intersect_ManageFIFRStorage",
	{
		[player_objintersect] call A3PL_Stock_Man_AskOpen;
	}
],
[
	"",
	"STR_Intersect_AccessCompanyVehicleStock",
	{
		[player_objintersect] call A3PL_Stock_View_AskOpen;
	}
],
[
	"",
	"STR_Intersect_ManageCompanyVehicleStock",
	{
		[player_objintersect] call A3PL_Stock_Man_AskOpen;
	}
],
[
	"",
	"STR_Intersect_AccessCompanyWarehouseStock",
	{
		[player_objintersect] call A3PL_Stock_View_AskOpen;
	}
],
[
	"",
	"STR_Intersect_ManageCompanyWarehouseStock",
	{
		[player_objintersect] call A3PL_Stock_Man_AskOpen;
	}
],
[
	"",
	"STR_Intersect_FIFRVehicleStorage",
	{
		[player_objintersect] call A3PL_Stock_View_AskOpen;
	}
],
[
	"",
	"STR_Intersect_ManageFIFRVehicleStorage",
	{
		[player_objintersect] call A3PL_Stock_Man_AskOpen;
	}
],
[
	"",
	"STR_Intersect_DOJVehicleStorage",
	{
		[player_objintersect] call A3PL_Stock_View_AskOpen;
	}
],
[
	"",
	"STR_Intersect_ManageDOJVehicleStorage",
	{
		[player_objintersect] call A3PL_Stock_Man_AskOpen;
	}
],
[
	"",
	"STR_Intersect_GOVVehicleStorage",
	{
		[player_objintersect] call A3PL_Stock_View_AskOpen;
	}
],
[
	"",
	"STR_Intersect_ManageGOVVehicleStorage",
	{
		[player_objintersect] call A3PL_Stock_Man_AskOpen;
	}
],
[
	"",
	"STR_Intersect_Dealership",
	{
		["Shop_Vehicles"] call A3PL_Shop_Open;
	}
],
[
	"",
	"STR_Intersect_BuyFISDBlueprint",
	{
		["police_blueprint_start"] call A3PL_NPC_Start;
	}
],
[
	"",
	"STR_Intersect_BuyFIFRBlueprint",
	{
		call A3PL_FD_BlueprintBuy;
	}
],
[
	"",
	"STR_Intersect_FIFRManagement",
	{[("STR_Common_FIFR" call A3PL_Localize)] call A3PL_Government_FactionSetup;}
],
[
	"",
	"STR_Intersect_CCTVAccess",
	{[getPos player, 500] spawn A3PL_CCTV_Open;}
],
// [
// 	"",
// 	"Car Dealership",
// 	{["Shop_Vehicles_Supplies_Vendor"] call A3PL_Shop_Open;}
// ],
[
	"",
	"STR_Intersect_PrisonShop",
	{["Shop_Prison"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Intersect_FISDStorage",
	{[player_objintersect] call A3PL_Stock_View_AskOpen;}
],
[
	"",
	"STR_Intersect_ManageFISDStorage",
	{[player_objintersect] call A3PL_Stock_Man_AskOpen;}
],
[
	"",
	"STR_Intersect_FISDVehicleStorage",
	{[player_objintersect] call A3PL_Stock_View_AskOpen;}
],
[
	"",
	"STR_Intersect_ManageFISDVehicleStorage",
	{[player_objintersect] call A3PL_Stock_Man_AskOpen;}
],
[
	"",
	"STR_Intersect_DOJStorage",
	{[player_objintersect] call A3PL_Stock_View_AskOpen;}
],
[
	"",
	"STR_Intersect_ManageDOJStorage",
	{[player_objintersect] call A3PL_Stock_Man_AskOpen;}
],
[
	"",
	"STR_Intersect_GOVStorage",
	{[player_objintersect] call A3PL_Stock_View_AskOpen;}
],
[
	"",
	"STR_Intersect_ManageGOVStorage",
	{[player_objintersect] call A3PL_Stock_Man_AskOpen;}
],
[
	"",
	"STR_Intersect_FIFRAircraftStorage",
	{[player_objintersect] call A3PL_Stock_View_AskOpen;}
],
[
	"",
	"STR_Intersect_ManageFIFRAircraftStorage",
	{[player_objintersect] call A3PL_Stock_Man_AskOpen;}
],
[
	"",
	"STR_Intersect_FISDAircraftStorage",
	{[player_objintersect] call A3PL_Stock_View_AskOpen;}
],
[
	"",
	"STR_Intersect_ManageFISDAircraftStorage",
	{[player_objintersect] call A3PL_Stock_Man_AskOpen;}
],
// [
// 	"",
// 	"Talk to the Real Estate Agent",
// 	{["estate_initial"] call A3PL_NPC_Start;}
// ],
[
	"",
	"STR_Intersect_ShopMcFishers",
	{["Shop_McFishers"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Intersect_TalkMcFishersEmployee",
	{["mcfishers_initial"] call A3PL_NPC_Start;}
],
[
	"",
	"STR_Intersect_TalkShipCaptain",
	{["ship_initial"] call A3PL_NPC_Start;}
],
[
	"",
	"STR_Intersect_TacoHellShop",
	{["Shop_TacoHell"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Intersect_TakeMcFishersUniform",
	{["STR_Common_Job_McFisher"] call A3PL_NPC_ReqJobUniform;}
],
[
	"",
	"STR_Intersect_TalkTacoHellEmployee",
	{["tacohell_initial"] call A3PL_NPC_Start;}
],
[
	"",
	"STR_Intersect_TakeTacoHellUniform",
	{["STR_Common_Job_TacoHell"] call A3PL_NPC_ReqJobUniform;}
],
// [
// 	"",
// 	"Talk to the Road Worker",
// 	{["roadworker_initial"] call A3PL_NPC_Start;}
// ],
[
	"",
	"STR_Intersect_TalkFisherman",
	{["fisherman_initial"] call A3PL_NPC_Start;}
],
[
	"",
	"STR_Intersect_TalkSheriff",
	{
		["police_initial"] call A3PL_NPC_Start;
		if ("fisddtu" IN (player getVariable ["licenses",[]])) then {
			player setVariable["FakeIDAccess",true,false];
		};
	}
],
[
	"",
	"STR_Intersect_TalkSheriff",
	{
		[("STR_Common_GOV" call A3PL_Localize)] call A3PL_NPC_TakeJob;
	}
],
[
	"",
	"STR_Intersect_StopGOVService",
	{
		call A3PL_NPC_LeaveJob;
	}
],
[
	"",
	"STR_Intersect_StartCompanyService",
	{
		[("STR_Common_Company" call A3PL_Localize)] call A3PL_NPC_TakeJob;
	}
],
[
	"",
	"STR_Intersect_StopCompanyService",
	{
		call A3PL_NPC_LeaveJob;
	}
],
// [
// 	"",
// 	"Parler au Dispatcher",
// 	{
// 		["dispatch_initial"] call A3PL_NPC_Start;
// 	}
// ],
[
	"",
	"STR_Intersect_TalkMarshal",
	{["doc_initial"] call A3PL_NPC_Start;}
],
[
	"",
	"STR_Intersect_TalkDOJ",
	{["doj_initial"] call A3PL_NPC_Start;}
],
[
    "",
    "STR_Intersect_ModifyThreatLevel",
    {["threat_start"] call A3PL_NPC_Start;}
],
[
	"",
	"STR_Intersect_TalkDirtyDoctor",
	{["fifr_initialill"] call A3PL_NPC_Start;}
],
[
	"",
	"STR_Intersect_TalkMedic",
	{["fifr_initial"] call A3PL_NPC_Start;}
],
// [
// 	"",
// 	"Arsenal",
// 	{["Open",true] spawn BIS_fnc_arsenal;}
// ],
[
	"",
	"STR_Intersect_TalkBanker",
	{["bank_initial"] call A3PL_NPC_Start;}
],
[
	"",
	"STR_Intersect_TalkFreightPilot",
	{["freight_initial"] call A3PL_NPC_Start;}
],
[
    "",
    "STR_Intersect_PremiumPass",
    {
		_getDay = player getVariable ["Player_PerkDay",0];
		if (_getDay < 1) exitWith {[("STR_A3PL_QuickActions_NPC_YoureNotPremium" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		["Shop_Perk_Motorhead"] call A3PL_Shop_Open;
	}
],
[
	"",
	"STR_Intersect_TalkFarmer",
	{["farmer_initial"] call A3PL_NPC_Start;}
],
// [
// 	"",
// 	"Talk to the Oil Dealer",
// 	{["oilbarrel_initial"] call A3PL_NPC_Start;}
// ],
[
	"",
	"STR_Intersect_TalkDealer",
	{["Shop_DrugsDealer"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Intersect_SupermarketSilverton",
	{["Shop_Supermarket"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Intersect_SupermarketNorthdale",
	{["Shop_Supermarket"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Intersect_SupermarketBlackwood",
	{["Shop_Supermarket"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Intersect_TalkPhoneOperator",
	{["verizon_initial"] call A3PL_NPC_Start;}
],
[
	"",
	"STR_Intersect_SupermarketElkCity",
	{["Shop_Supermarket"] call A3PL_Shop_Open;}
],
// [
// 	"",
// 	"Talk to the DOJ Member",
// 	{["doj_initial"] call A3PL_NPC_Start;}
// ],
[
	"",
	"STR_Intersect_TalkDMVMember",
	{["dmv_initial"] call A3PL_NPC_Start;}
],
[
	"",
	"STR_Intersect_TalkHunter",
	{
		if (["hunt",player] call A3PL_DMV_Check) then {
			["Shop_Hunting_Supplies"] call A3PL_Shop_Open;
		} else {
			[("STR_A3PL_QuickActions_NPC_YouNeedHuntingLicense" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};
	}
],
[
	"",
	"STR_Intersect_TalkRoadService",
	{["roadside_service_initial"] call A3PL_NPC_Start;}
],
[
	"",
	"STR_Intersect_GemShop",
	{["Shop_GemStone"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Intersect_Jeweler",
	{["Shop_Jewelry"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Intersect_SecureJewelry",
	{call A3PL_Jewelry_FixCases;}
],
[
	"",
	"STR_Intersect_ChristmasShop",
	{
		if (Christmas) then {
			["Shop_Christmas","gift"] call A3PL_Shop_Open;
		};
	}
],
[
	"",
	"STR_Intersect_ExchangeHalloweenChristmas",
	{[] spawn A3FL_Christmas_CandyTrade;}
],

[
	"",
	"STR_Intersect_HalloweenShop",
	{
        if (Halloween) then {
			["Shop_Halloween","candy"] call A3PL_Shop_Open;
		};
    }
],
[
	"",
	"STR_Intersect_OpenRadar",
	{[] spawn A3PL_ATC_RadarStart;}
],
[
	"",
	"STR_Intersect_TakeATCRadio",
	{if ((backpack player) isNotEqualTo "TFAR_anprc155_coyote") then { player addBackpackGlobal "TFAR_anprc155_coyote";};}
],
[
	"",
	"STR_Intersect_SkinAnimal",
	{[player_objintersect] spawn A3PL_Hunting_Skin;}
],
[
	"",
	"STR_Intersect_RobStore",
	{[player_objintersect] spawn A3PL_Robberies_Store;}
],
[
	"",
	"STR_Intersect_SecureStore",
	{[player_objintersect,false] spawn A3PL_SFP_CheckIn;}
],
[
	"",
	"STR_Intersect_SecurePort",
	{[player_objintersect,true] spawn A3PL_SFP_CheckIn;}
],
[
	"",
	"STR_Intersect_QuestionRobbableStore",
	{[player_objintersect] spawn A3PL_Robberies_StoreQuestion;}
],
[
	"",
	"STR_Intersect_QuestionPortCaptain",
	{[player_objintersect] spawn A3PL_Robberies_PortQuestion;}
],
[
	"",
	"STR_Intersect_CriminalClothingFactory",
	{["STR_Common_FactoryName_IllegalClothings"] call A3PL_Factory_Open;}
],
[
	"",
	"STR_Intersect_AnalyzeEvidence",
	{[] spawn A3PL_Police_Analyze;}
],
[
	"",
	"STR_Intersect_BuyPlantationsInfo",
	{
		[] spawn {
			private _plantation = (Server_PlantationAreas select (floor (random (count Server_PlantationAreas))));
			private _areaLocation = text ((nearestLocations [getMarkerPos _plantation, ["NameCityCapital","NameCity","NameVillage"], 50000])#0);
			private _totalPrice = 15000;
			private _action = [("STR_A3PL_QuickActions_NPC_DoYouWantToBuyInformationsOnEmplacementPlant" call A3PL_Localize)] call A3PL_Lib_ConfirmationDialog;
			if (!isNil "_action" && {!_action}) exitWith {};
			if ((player getVariable ["player_cash",0]) >= _totalPrice) then {
				[format[("STR_A3PL_QuickActions_NPC_PlantationAt" call A3PL_Localize),_areaLocation],Color_Red] call A3PL_Notification;
				player setVariable ["player_cash",(player getVariable ["player_cash",0]) - _totalPrice,true];
			} else {
				[format[("STR_A3PL_QuickActions_NPC_YouDoNotHaveEnoughMoneyForThisInformation" call A3PL_Localize),_totalPrice-(player getVariable ["player_cash",0])],Color_Red] call A3PL_Notification;
			};
		};
	}
],
[
	"",
	"STR_Intersect_EmptySeizeChest",
	{[] spawn A3PL_Police_EmptyEvidence;}
],
[
	"",
	"STR_Intersect_TakeMovingMission",
	{["betterbuy_initial"] call A3PL_NPC_Start;}
],
[
	"",
	"STR_Intersect_RefuelAircraft",
	{[true] spawn A3PL_Hydrogen_Refuel;}
],
[
	"",
	"STR_Intersect_RefuelBoat",
	{[false] spawn A3PL_Hydrogen_Refuel;}
],
[
	"",
	"STR_Intersect_PublicFactory",
	{["civ"] call A3PL_FactoryV2_Open;}
],
[
	"",
	"STR_Intersect_ClothingStore",
	{["Shop_Clothing"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Intersect_WomenClothingStore",
	{["Shop_Clothing_Woman"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Intersect_CompanyClothingStore",
	{["Shop_Clothing_Company"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Intersect_HatStore",
	{["Shop_Clothing_Headgear"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Intersect_GlassesStore",
	{["Shop_Clothing_Goggles"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Intersect_JacketStore",
	{["Shop_Clothing_Vest"] call A3PL_Shop_Open;}
],
[
	"",
	"STR_Intersect_ParticipateInLottery",
	{[] spawn A3LL_Player_EnterLottery;}
],
[
	"",
	"STR_Intersect_TalkTrucker",
	{[player_objintersect] call A3FL_Trucking_Start;}
],
[
	"",
	"STR_Intersect_DeliverTruckCargo",
	{[player_objintersect] spawn A3FL_Trucking_Unload;}
],
[
	"",
	"STR_Intersect_InstallFakePlate",
	{[] spawn A3PL_Criminal_FakePlate;}
],
[
	"",
	"STR_Intersect_BuyFakeIdentity",
	{[] spawn A3PL_Criminal_FakeID;}
],
[
	"",
	"STR_Intersect_CollectGangTaxes",
	{[player_objintersect] call A3FL_Gang_CollectTaxes;}
],
[
	"",
	"STR_A3PL_Hooker_Stop",
	{
		if (isNull player_objintersect) exitWith {};
		if (!(player_objintersect getVariable ["A3PL_NPC_Hooker_Active", false])) exitWith {};
		if ((player_objintersect getVariable ["A3PL_NPC_Hooker_Owner", objNull]) != player) exitWith {};
		if (player_objintersect getVariable ["A3PL_Hooker_IsStopped", false]) exitWith {};
		if (player_objintersect getVariable ["A3PL_Hooker_IsArrested", false]) exitWith {};
		
		Player_Hooker = player_objintersect;
		Player_Hooker_Owner = player;
		Player_Hooker_IsStopped = false;
		call A3PL_Hooker_Stop;
	},
	{
		if (isNull player_objintersect) exitWith {false};
		(player_objintersect getVariable ["A3PL_NPC_Hooker_Active", false]) && 
		((player_objintersect getVariable ["A3PL_NPC_Hooker_Owner", objNull]) == player) &&
		{!(player_objintersect getVariable ["A3PL_Hooker_IsStopped", false])} && 
		{!(player_objintersect getVariable ["A3PL_Hooker_IsArrested", false])}
	}
],
[
	"",
	"STR_A3PL_Hooker_Resume",
	{
		if (isNull player_objintersect) exitWith {};
		if (!(player_objintersect getVariable ["A3PL_NPC_Hooker_Active", false])) exitWith {};
		if ((player_objintersect getVariable ["A3PL_NPC_Hooker_Owner", objNull]) != player) exitWith {};
		if (!(player_objintersect getVariable ["A3PL_Hooker_IsStopped", false])) exitWith {};
		if (player_objintersect getVariable ["A3PL_Hooker_IsArrested", false]) exitWith {};
		
		Player_Hooker = player_objintersect;
		Player_Hooker_Owner = player;
		Player_Hooker_IsStopped = true;
		call A3PL_Hooker_Resume;
	},
	{
		if (isNull player_objintersect) exitWith {false};
		(player_objintersect getVariable ["A3PL_NPC_Hooker_Active", false]) && 
		((player_objintersect getVariable ["A3PL_NPC_Hooker_Owner", objNull]) == player) &&
		{(player_objintersect getVariable ["A3PL_Hooker_IsStopped", false])} &&
		{!(player_objintersect getVariable ["A3PL_Hooker_IsArrested", false])}
	}
],
[
	"",
	"STR_A3PL_Hooker_StartWork",
	{
		if (isNull player_objintersect) exitWith {};
		if (!(player_objintersect getVariable ["A3PL_NPC_Hooker_Active", false])) exitWith {};
		if ((player_objintersect getVariable ["A3PL_NPC_Hooker_Owner", objNull]) != player) exitWith {};
		if (!(player_objintersect getVariable ["A3PL_Hooker_IsStopped", false])) exitWith {};
		if (player_objintersect getVariable ["A3PL_Hooker_IsArrested", false]) exitWith {};
		if (player_objintersect getVariable ["A3PL_Hooker_IsWorking", false]) exitWith {};
		if (isNull (player_objintersect getVariable ["A3PL_NPC_SexClient", objNull])) exitWith {};

		Player_Hooker = player_objintersect;
		Player_Hooker_Owner = player;
		call A3PL_Hooker_StartWork;
	},
	{
		if (isNull player_objintersect) exitWith {false};
		private _hooker = player_objintersect;
		private _sexClient = _hooker getVariable ["A3PL_NPC_SexClient", objNull];
		private _nearMotel = false;
		{
			if ((typeOf _x) == "Land_A3PL_Motel") then {
				if ((_hooker distance _x) < 50) then {
					_nearMotel = true;
				};
			};
		} forEach nearestObjects [_hooker, ["House"], 50];

		(_hooker getVariable ["A3PL_NPC_Hooker_Active", false]) &&
		{((_hooker getVariable ["A3PL_NPC_Hooker_Owner", objNull]) == player)} &&
		{(_hooker getVariable ["A3PL_Hooker_IsStopped", false])} &&
		{!(_hooker getVariable ["A3PL_Hooker_IsArrested", false])} &&
		{!(_hooker getVariable ["A3PL_Hooker_IsWorking", false])} &&
		{!isNull _sexClient} &&
		{(_hooker distance _sexClient) < 3} &&
		{_nearMotel}
	}
],
[
	"",
	"STR_A3PL_Hooker_Arrest",
	{
		if (isNull player_objintersect) exitWith {};
		if (!(player_objintersect getVariable ["A3PL_NPC_Hooker_Active", false])) exitWith {};
		if ((player getVariable ["job", ("STR_Common_Job_Unemployed" call A3PL_Localize)]) != ("STR_Common_FISD" call A3PL_Localize)) exitWith {};
		if (player_objintersect getVariable ["A3PL_Hooker_IsArrested", false]) exitWith {};
		
		Player_ObjIntersect = player_objintersect;
		call A3PL_Hooker_Arrest;
	},
	{
		if (isNull player_objintersect) exitWith {false};
		(player_objintersect getVariable ["A3PL_NPC_Hooker_Active", false]) && 
		{(player getVariable ["job", ("STR_Common_Job_Unemployed" call A3PL_Localize)]) == ("STR_Common_FISD" call A3PL_Localize)} && 
		{!(player_objintersect getVariable ["A3PL_Hooker_IsArrested", false])}
	}
],
[
	"",
	"STR_A3PL_Hooker_ReleaseAtStation",
	{
		if (isNull player_objintersect) exitWith {};
		if (!(player_objintersect getVariable ["A3PL_NPC_Hooker_Active", false])) exitWith {};
		if ((player getVariable ["job", ("STR_Common_Job_Unemployed" call A3PL_Localize)]) != ("STR_Common_FISD" call A3PL_Localize)) exitWith {};
		if (!(player_objintersect getVariable ["A3PL_Hooker_IsArrested", false])) exitWith {};
		
		Player_ObjIntersect = player_objintersect;
		call A3PL_Hooker_ReleaseAtStation;
	},
	{
		if (isNull player_objintersect) exitWith {false};
		(player_objintersect getVariable ["A3PL_NPC_Hooker_Active", false]) && 
		{(player getVariable ["job", ("STR_Common_Job_Unemployed" call A3PL_Localize)]) == ("STR_Common_FISD" call A3PL_Localize)} && 
		{(player_objintersect getVariable ["A3PL_Hooker_IsArrested", false])}
	}
],
[
	"",
	"STR_Intersect_SendHookerHome",
	{
		if (isNull player_objintersect) exitWith {};
		if (!(player_objintersect getVariable ["A3PL_NPC_Hooker_Active", false])) exitWith {};
		if ((player_objintersect getVariable ["A3PL_NPC_Hooker_Owner", objNull]) != player) exitWith {};
		[player_objintersect] call A3PL_Hooker_SendHome;
	},
	{
		if (isNull player_objintersect) exitWith {false};
		(player_objintersect getVariable ["A3PL_NPC_Hooker_Active", false]) && 
		((player_objintersect getVariable ["A3PL_NPC_Hooker_Owner", objNull]) == player)
	}
],
[
	"",
	"STR_A3PL_Hooker_Blowjob",
	{
		if (isNull player_objintersect) exitWith {};
		if (!(player_objintersect getVariable ["A3PL_NPC_Hooker_Active", false])) exitWith {};
		if ((player_objintersect getVariable ["A3PL_NPC_Hooker_Owner", objNull]) != player) exitWith {};
		if ((player_objintersect getVariable ["A3PL_NPC_Hooker_Mode", ""]) != "home") exitWith {};
		[player_objintersect] call A3PL_Hooker_Blowjob;
	},
	{
		if (isNull player_objintersect) exitWith {false};
		(player_objintersect getVariable ["A3PL_NPC_Hooker_Active", false]) && 
		((player_objintersect getVariable ["A3PL_NPC_Hooker_Owner", objNull]) == player) &&
		((player_objintersect getVariable ["A3PL_NPC_Hooker_Mode", ""]) == "home")
	}
],
[
	"",
	"STR_Intersect_TalkCustomNPC",
	{
		call A3PL_NPC_StartRandom;
	},
	{
		if (isNull player_objintersect) exitWith {false};
		!isNil {player_objintersect getVariable "A3PL_NPC_ID"} && 
		{!(player_objintersect getVariable ["A3PL_NPC_Hooker_Active", false])} && 
		{!(player_objintersect getVariable ["A3PL_NPC_SexClient_Active", false])}
	}
],
[
	"",
	"STR_A3PL_NPC_StopFollowing",
	{
		[] call A3PL_NPC_StopFollowing;
	},
	{
		!isNil "Player_NPC_SexClient" && {!isNull Player_NPC_SexClient} && {Player_NPC_SexClient == player_objintersect} && {!Player_NPC_SexClient_IsStopped} && {!Player_NPC_SexClient_IsArrested}
	}
],
[
	"",
	"STR_A3PL_NPC_ResumeFollowing",
	{
		[] spawn A3PL_NPC_ResumeFollowing;
	},
	{
		!isNil "Player_NPC_SexClient" && {!isNull Player_NPC_SexClient} && {Player_NPC_SexClient == player_objintersect} && {Player_NPC_SexClient_IsStopped} && {!Player_NPC_SexClient_IsArrested}
	}
],
[
	"",
	"STR_A3PL_NPC_Arrest",
	{
		[] call A3PL_NPC_Arrest;
	},
	{
		(player_objintersect getVariable ["A3PL_NPC_SexClient_Active", false]) && {(player getVariable ["job", ("STR_Common_Job_Unemployed" call A3PL_Localize)]) == ("STR_Common_FISD" call A3PL_Localize)} && {!(player_objintersect getVariable ["A3PL_NPC_IsArrested", false])}
	}
],
[
	"",
	"STR_A3PL_NPC_ReleaseAtStation",
	{
		[] call A3PL_NPC_ReleaseAtStation;
	},
	{
		(player_objintersect getVariable ["A3PL_NPC_SexClient_Active", false]) && {(player getVariable ["job", ("STR_Common_Job_Unemployed" call A3PL_Localize)]) == ("STR_Common_FISD" call A3PL_Localize)} && {(player_objintersect getVariable ["A3PL_NPC_IsArrested", false])}
	}
]
