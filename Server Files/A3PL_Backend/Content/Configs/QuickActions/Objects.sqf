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
	"STR_Intersect_TakeGift",
	{[player_objIntersect] call A3FL_Christmas_GetGift;}
],
[
	"A3PL_Distillery",
	"STR_Intersect_InstallPipe",
	{[player_objIntersect] call A3PL_Moonshine_InstallHose;}
],
[
	"A3FL_PlasticBarrel",
	"STR_Intersect_AddCocaineIngredient",
	{[player_objIntersect] spawn A3PL_Cocaine_AddItem;}
],
[
	"A3FL_ExplosiveBarrel",
	"STR_Intersect_AddExplosiveIngredient",
	{[player_objIntersect] spawn A3FL_Explosives_AddItem;}
],
[
	"A3FL_ExplosiveBarrel",
	"STR_Intersect_ProduceSyntheticRubber",
	{[player_objIntersect,1] spawn A3FL_Explosives_Produce;}
],
[
	"A3FL_ExplosiveBarrel",
	"STR_Intersect_ProduceExplosiveMix",
	{[player_objIntersect,2] spawn A3FL_Explosives_Produce;}
],
[
	"A3FL_ExplosiveBarrel",
	"STR_Intersect_ProduceC4",
	{[player_objIntersect,3] spawn A3FL_Explosives_Produce;}
],
[
	"A3FL_ExplosiveBarrel",
	"STR_Intersect_CollectProduction",
	{[player_objIntersect] call A3FL_Explosives_Collect;}
],
[
	"A3PL_Distillery",
	"STR_Intersect_EmptyBarrel",
	{[player_objIntersect] call A3FL_Explosives_Reset;}
],
[
	"A3FL_PlasticBarrel",
	"STR_Intersect_SeeCocaineBarrelContents",
	{[player_objIntersect] call A3PL_Cocaine_CheckContents;}
],
[
	"A3FL_PlasticBarrel",
	"STR_Intersect_ProduceCocainePaste",
	{[player_objIntersect,1] spawn A3PL_Cocaine_Produce;}
],
[
	"A3FL_PlasticBarrel",
	"STR_Intersect_ProduceCocaineBase",
	{[player_objIntersect,2] spawn A3PL_Cocaine_Produce;}
],
[
	"A3FL_PlasticBarrel",
	"STR_Intersect_ProduceCocaineHydrochloride",
	{[player_objIntersect,3] spawn A3PL_Cocaine_Produce;}
],
[
	"A3FL_PlasticBarrel",
	"STR_Intersect_CollectProduction",
	{[player_objIntersect] call A3PL_Cocaine_Collect;}
],
[
	"A3FL_PlasticBarrel",
	"STR_Intersect_EmptyBarrel",
	{[player_objIntersect] call A3PL_Cocaine_Reset;}
],
[
	"A3PL_Scale",
	"STR_Intersect_ProduceCocaineBrick",
	{[player_objintersect] spawn A3PL_Cocaine_CreateBrick;}
],
[
	"A3PL_Scale",
	"STR_Intersect_BreakCocaineBrick",
	{[player_objintersect] spawn A3PL_Cocaine_BreakDownBrick;}
],
[
	"A3FL_Bullet_Casings",
	"STR_Intersect_PickupEvidence",
	{deleteVehicle player_objintersect; ['bulletcasing',1] call A3PL_Inventory_Add;}
],
[
	"A3FL_Bullet_Casings",
	"STR_Intersect_PackEvidence",
	{[player_objintersect] call A3PL_Police_BagEvidence;}
],
[
	"",
	"STR_Intersect_UseEyewashStation",
	{[player,"head","pepper_spray"] call A3PL_Medical_RemoveWound;}
],
[
	"",
	"STR_Intersect_FillBottle",
	{call A3PL_Items_FillBottle;}
],
[
	"",
	"STR_Intersect_StealVaultMoney",
	{[player_objIntersect] spawn A3PL_BHeist_PickCash;}
],
[
	"",
	"STR_Intersect_CaptureGangHideout",
	{[player_objIntersect] spawn A3PL_Gang_Capture;}
],
[
	"",
	"STR_Intersect_SecureGangHideout",
	{[player_objIntersect] spawn A3PL_Gang_Secure;}
],
[
	"",
	"STR_Intersect_SeizeItem",
	{[player_objintersect] call A3PL_Police_SeizeVirtualItems;}
],
[
	"",
	"STR_Intersect_SeizePhysical",
	{[player_objintersect] spawn A3PL_Police_SeizePhysicalItems;}
],
[
	"",
	"STR_Intersect_HideoutShop",
	{
		_obj = player_objIntersect;
		_group = group player;
		_gang = _group getVariable ["gang_data",nil];
		if(isNil "_gang") exitwith {[("STR_A3PL_QuickActions_Objects_YoureNotInAGang" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_gangID = _gang select 0;
		if((_obj getVariable["captured",-1]) isEqualTo _gangID) then {
			["Shop_Gang"] call A3PL_Shop_Open;
		} else {
			[("STR_A3PL_QuickActions_Objects_GangNotOwnThisHideout" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};
	}
],
[
	"A3PL_Distillery_Hose",
	"STR_Intersect_ConnectJugToHose",
	{[player_objIntersect] call A3PL_Moonshine_InstallJug;}
],
[
	"A3PL_Distillery",
	"STR_Intersect_StartDistillery",
	{[player_objIntersect] spawn A3PL_Moonshine_Start;}
],
[
	"A3PL_Distillery",
	"STR_Intersect_CheckDistilleryStatus",
	{[player_objIntersect] call A3PL_Moonshine_CheckStatus;}
],
[
	"A3PL_Distillery",
	"STR_Intersect_AddIngredient",
	{[player_objIntersect] call A3PL_Moonshine_AddItem;}
],
[
	"",
	"STR_Intersect_ATM",
	{[player_objIntersect] spawn A3PL_Bank_ATM;}
],
[
	"A3PL_Mixer",
	"STR_Intersect_GrindWheatToMalta",
	{["malt",player_objIntersect] spawn A3PL_Moonshine_Grind;}
],
[
	"A3PL_Mixer",
	"STR_Intersect_GrindWheatToYeast",
	{["yeast",player_objIntersect] spawn A3PL_Moonshine_Grind;}
],
[
	"A3PL_Mixer",
	"STR_Intersect_GrindCornToCornFlour",
	{["cornmeal",player_objIntersect] spawn A3PL_Moonshine_Grind;}
],
[
	"A3PL_Mixer",
	"STR_Intersect_BudMarijuana",
	{[player_objIntersect] call A3FL_Weed_Grind;}
],
[
	"A3PL_Mixer",
	"STR_Intersect_CollectGroundMarijuana",
	{[player_objIntersect] spawn A3FL_Weed_GrindCollect;}
],
[
	"A3PL_Mixer",
	"STR_Intersect_CheckGrinder",
	{[player_objIntersect] call A3FL_Weed_CheckGrinder;}
],
[
	"A3PL_Scale",
	"STR_Intersect_PackMarijuanaBuds",
	{[player_objintersect] call A3FL_Weed_BagOpen;}
],
[
	"A3PL_Scale",
	"STR_Intersect_CutMarijuanaPlant",
	{[player_objintersect] call A3FL_Weed_TrimPlant;}
],
[
	"A3PL_Scale",
	"STR_Intersect_RollBlunt",
	{[player_objintersect] spawn A3FL_Weed_RollBlunt;}
],
// [
// 	"A3FL_Mushroom",
// 	"Harvest Mushrooms",
// 	{[player_objintersect] spawn A3PL_Shrooms_Pick;}
// ],
[
    "Land_MetalCase_01_large_F",
    "",
    {
    	private _storage = player_objintersect;
		if (_storage IN [evidence_box_elk,evidence_box_nd,evidence_box_svt]) then {
			private _isLead = [("STR_Common_FISD" call A3PL_Localize)] call A3PL_Government_isFactionLeader;
			private _isLocked = _storage getVariable["locked",true];
			if(!_isLead && _isLocked) then {
				[("STR_A3PL_QuickActions_Objects_StorageClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;
			} else {
				[_storage] call A3PL_Housing_VirtualOpen;
			};
		} else {
			[_storage] call A3PL_Housing_VirtualOpen;
		};
    }
],
[
	"Land_MetalCase_01_medium_F",
	"",
	{[player_objintersect] call A3PL_Housing_VirtualOpen;}
],
[
    "Box_GEN_Equip_F",
    "",
    {[player_objintersect] call A3PL_Housing_VirtualOpen;}
],
[
	"B_supplyCrate_F",
	"",
	{
		_sotrage = player_objintersect;
		_isLocked = _sotrage getVariable["locked",true];
		if(_isLocked) then {
			[("STR_A3PL_QuickActions_Objects_StorageClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;
		} else {
			[player_objintersect] call A3PL_Housing_VirtualOpen;
		};
    }
],
[
	"C_IDAP_supplyCrate_F",
	"",
	{
		private _sotrage = player_objintersect;
		private _isLead = [("STR_Common_FISD" call A3PL_Localize)] call A3PL_Government_isFactionLeader;
		private _isLocked = _sotrage getVariable["locked",true];
		if(!_isLead && _isLocked) then {
			[("STR_A3PL_QuickActions_Objects_StorageClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;
		} else {
			[player_objintersect] call A3PL_Housing_VirtualOpen;
		};
    }
],
[
	"Land_GarbageBin_03_F",
	"",
	{[] spawn A3PL_Prison_SearchTrash;}
],
[
	"A3FL_Toolbox",
	"STR_Intersect_Work",
	{[] spawn A3PL_Criminal_Work;}
],
[
	"A3PL_RoadCone",
	"STR_Intersect_StackCone",
	{[player_objintersect] call A3PL_Placeables_StackCone;}
],
[
	"A3PL_RoadCone_x10",
	"STR_Intersect_StackCone",
	{[player_objintersect] call A3PL_Placeables_StackCone;}
],
[
	"A3PL_CarInfo",
	"STR_Intersect_VehicleInfo",
	{[(format ["%1",player_objIntersect])] call A3PL_Shop_Open;}
],
[
	"A3PL_CarInfo",
	"STR_Intersect_AirWorkshop",
	{[player_objintersect] spawn A3PL_Garage_Open;}
],
// [
// 	"",
// 	"Buy Furniture",
// 	{[(format ["%1",player_objIntersect])] call A3PL_Shop_Open;}
// ],
// [
// 	"A3PL_Net",
// 	"Buy / Sell Net",
// 	{[(format ["%1",player_objIntersect])] call A3PL_Shop_Open;}
// ],
// [
// 	"A3PL_Bucket",
// 	"Buy / Sell Bucket",
// 	{[(format ["%1",player_objIntersect])] call A3PL_Shop_Open;}
// ],
// [
// 	"A3PL_Crate",
// 	"To buy to sell",
// 	{[(format ["%1",player_objIntersect])] call A3PL_Shop_Open;}
// ],
// [
// 	"A3PL_Seed_Marijuana",
// 	"Buy/Sell Marijuana Seeds",
// 	{[(format ["%1",player_objIntersect])] call A3PL_Shop_Open;}
// ],
// [
// 	"A3PL_Seed_Lettuce",
// 	"Buy/Sell Lettuce Seeds",
// 	{[(format ["%1",player_objIntersect])] call A3PL_Shop_Open;}
// ],
// [
// 	"A3PL_MarijuanaBag",
// 	"Buy/Sell Weed Bag",
// 	{[(format ["%1",player_objIntersect])] call A3PL_Shop_Open;}
// ],
// [
// 	"A3PL_Seed_Wheat",
// 	"Buy/Sell Wheat Seeds",
// 	{[(format ["%1",player_objIntersect])] call A3PL_Shop_Open;}
// ],
// [
// 	"A3PL_Seed_Corn",
// 	"Buy/Sell Corn Seeds",
// 	{[(format ["%1",player_objIntersect])] call A3PL_Shop_Open;}
// ],
[
	"",
	"STR_Intersect_PlaceBurger",
	{
		if (isNull Player_Item) exitwith {[("STR_A3PL_QuickActions_Objects_NothingToPlaceInYourHands" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		private _class = Player_ItemClass;
		if (!(_class IN ["burger_raw","burger_burnt","burger_cooked","fish_raw","fish_cooked","fish_burned"])) exitwith {[("STR_A3PL_QuickActions_Objects_YouCanOnlyPlaceBurgersAndFish" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (!isNull Player_Item) exitwith
		{
			private _playerItem = Player_Item;
			call A3PL_Placeables_QuickAction;
			if (isNull (attachedTo _playerItem)) exitwith {};
			if ((typeOf(attachedTo _playerItem)) IN ["A3PL_Mcfisher_Grill"]) exitwith {[_playerItem] call A3PL_JobMcfisher_CookBurger;};
		};
	}
],
[
	"RoadCone_F",
	"",
	{
		if (Player_NameIntersect != "") exitwith {};
		call A3PL_Placeables_QuickAction;
	}
],
[
	"PipeFence_01_m_gate_v2_F",
	"",
	{hint "WORK IN PROGRESS";}
],
// [
// 	"",
// 	"Grab Furniture",
// 	{
// 		if (!isNull player_item) exitwith {[("Vous avez déjà quelque chose dans vos mains" call A3PL_Localize), Color_Red] call A3PL_Notification;};
// 		call A3PL_Placeables_QuickAction;
// 	}
// ],
[
	"C_man_1",
	"",
	{
		_attachedObjects = [] call A3PL_Lib_Attached;
		if ((count _attachedObjects) == 0) exitwith {};
		_attachedObject = _attachedObjects select 0;
		if (((typeOf _attachedObject) IN Config_Placeables) OR (_attachedObject isKindOf "A3PL_Furniture_Base")) then
		{
			if(_attachedObject isKindOf "A3PL_Furniture_Base") then {
				if(isOnRoad player) then {
					[("STR_A3PL_QuickActions_Objects_YouCantPlaceObjectOnRoad" call A3PL_Localize), Color_Red] call A3PL_Notification;
				} else {
					call A3PL_Placeables_QuickAction;
				};
			} else {
				call A3PL_Placeables_QuickAction;
			};
		};
	}
],
[
	"",
	"STR_Intersect_Place",
	{
		if (!isNull Player_Item) exitwith {call A3PL_Placeables_QuickAction;};
		if(typeOf player_Item isEqualTo "A3PL_Gas_Hose") exitwith {[("STR_A3PL_QuickActions_Objects_YouCantPlaceExtractor" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		private _attached = [] call A3PL_Lib_Attached;
		if (count _attached == 0) exitwith {};
		if ((typeOf (_attached select 0)) IN Config_Placeables) then {call A3PL_Placeables_QuickAction;};
	}
],
// [
// 	"",
// 	"Gear",
// 	{
// 		if (Player_NameIntersect isNotEqualTo "") exitwith {};
// 		call A3PL_Placeables_QuickAction;
// 	}
// ],
[
	"A3PL_PileCash",
	"STR_Intersect_StealVaultMoney",
	{[player_objintersect] spawn A3PL_BHeist_PickCash;}
],
[
	"A3PL_Drill_Bank",
	"STR_Intersect_InstallDrillBit",
	{[player_objintersect] call A3PL_BHeist_InstallBit;}
],
[
	"A3PL_Drill_Bank",
	"STR_Intersect_UninstallDrill",
	{[player_objintersect] call A3PL_BHeist_PickupDrill;}
],
[
	"A3PL_Drill_Bank",
	"STR_Intersect_StartDrill",
	{
		if((count(nearestObjects [player, ["Land_A3PL_Bank"],15])) > 0) then {
			[player_objintersect] spawn A3PL_BHeist_StartDrill;
		} else {
			[player_objintersect] spawn A3PL_Jewelry_StartDrill;
		};
	}
],
[
	"",
	"STR_Intersect_OpenMedicalMenu",
	{[player_objintersect] spawn A3PL_Medical_Open;}
],
[
	"",
	"STR_Intersect_BloodDraw",
	{[player_objintersect] spawn A3PL_Medical_BloodBag;}
],
[
	"",
	"STR_Intersect_TakeSkinSample",
	{[player_objintersect] spawn A3PL_Medical_Autograft;}
],
[
	"",
	"STR_Intersect_PerformCPR",
	{[player_objintersect] spawn A3PL_Medical_ChestCompressions;}
],
[
	"",
	"STR_Intersect_DragCorpse",
	{[player_objintersect] spawn A3PL_Medical_DragBody;}
],
[
	"",
	"STR_Intersect_TakePackage",
	{[player_objintersect] call A3PL_Delivery_Pickup;}
],
[
	"A3PL_DeliveryBox",
	"STR_Intersect_CheckDeliveryAddress",
	{[player_objintersect] call A3PL_Delivery_Label;}
],
[
	"",
	"STR_Intersect_Pickup",
	{[player_objintersect] call A3PL_Inventory_Pickup;}
],
[
	"",
	"STR_Intersect_Look",
	{[player_objintersect] call A3PL_Factory_CrateCheck;}
],
[
	"",
	"STR_Intersect_Collect",
	{[player_objintersect] call A3PL_Factory_CrateCollect;}
],
[
	"",
	"STR_Intersect_BuyItem",
	{[player_objintersect] call A3PL_Business_BuyItem;}
],
[
	"",
	"STR_Intersect_SellItem",
	{[player_objintersect] call A3PL_Business_Sell;}
],
[
	"A3PL_Crate",
	"STR_Intersect_LoadCargo",
	{[player_objintersect] call A3PL_Freight_Load;}
],
[
	"A3PL_Crate",
	"STR_Intersect_CheckCargo",
	{[player_objintersect] call A3FL_Trucking_CheckCargo;}
],
[
	"A3PL_OilBarrel",
	"STR_Intersect_LadderFillTank",
	{[player_objintersect,"Petrol"] call A3PL_Hydrogen_LoadTank;}
],
[
	"A3PL_Kerosene",
	"STR_Intersect_LoadKeroseneIntoTank",
	{[player_objintersect,"Kerosene"] call A3PL_Hydrogen_LoadTank;}
],
[
	"",
	"STR_Intersect_TakeInHands",
	{[player_objintersect,true] call A3PL_Inventory_Pickup;}
],
[
	"",
	"STR_Intersect_HarvestPlant",
	{[player_objintersect] call A3PL_JobFarming_Harvest;}
],
[
	"",
	"STR_Intersect_HarvestMarijuana",
	{[player_objintersect] call A3PL_JobFarming_Harvest;}
],
[
	"",
	"STR_Intersect_TakeKey",
	{call A3PL_Housing_PickupKey;}
],
[
	"A3PL_FishingBuoy",
	"STR_Intersect_TakeNet",
	{[player_objintersect] call A3PL_JobFisherman_RetrieveNet;}
],
[
	"",
	"STR_Intersect_ATM",
	{[] spawn A3PL_Bank_ATM;}
],
[
	"A3PL_FishingBuoy",
	"STR_Intersect_DeployNet",
	{call A3PL_JobFisherman_DeployNet;}
],
[
	"A3PL_FishingBuoy",
	"STR_Intersect_PlaceBait",
	{[player_objintersect] call A3PL_JobFisherman_Bait;}
],
[
	"A3PL_Planter2",
	"STR_Intersect_PlantSeed",
	{[player_objintersect] call A3PL_JobFarming_PlanterPlant;}
],
[
	"Land_A3PL_Greenhouse",
	"STR_Intersect_PlantSeed",
	{[player_objintersect] call A3PL_JobFarming_GreenHousePlant;}
],
[
	"A3PL_GasHose",
	"STR_Intersect_TakeGasPump",
	{[player_objintersect] spawn A3PL_Hydrogen_Grab;}
],
[
	"A3PL_Gas_Hose",
	"STR_Intersect_TakeGasPump",
	{[player_objintersect] spawn A3PL_Hydrogen_Grab;}
],
[
	"Land_A3PL_Gas_Station",
	"STR_Intersect_TakeGasPump",
	{[player_objintersect] spawn A3PL_Hydrogen_Grab;}
],
[
	"Land_A3PL_Gas_Station",
	"STR_Intersect_PutGasPump",
	{[player_objintersect] spawn A3PL_Hydrogen_Connect;}
],
[
	"A3PL_Gas_Hose",
	"STR_Intersect_UseFuelPumpToggle",
	{[player_objintersect] spawn A3PL_Hydrogen_SwitchFuel;}
],
[
	"A3PL_GasHose",
	"STR_Intersect_UseFuelPumpToggle",
	{[player_objintersect] spawn A3PL_Hydrogen_SwitchFuel;}
],
[
	"A3PL_Rocket",
	"STR_Intersect_UseFireworks",
	{[player_objintersect] spawn A3PL_Items_IgniteRocket;}
],

[
	"A3PL_FD_HoseEnd1_Float",
	"STR_Intersect_ConnectRolledHose",
	{[player_objintersect] call A3PL_FD_ConnectHose;}
],
[
	"Land_A3PL_FireHydrant",
	"STR_Intersect_ConnectHoseToTank",
	{[player_objintersect] call A3PL_FD_ConnectAdapter;}
],
[
	"Land_A3PL_Gas_Station",
	"STR_Intersect_ConnectHoseToTank",
	{[player_objintersect] call A3PL_FD_ConnectAdapter;}
],
[
	"Land_A3PL_Gas_Station",
	"STR_Intersect_UseStorageToggle",
	{[player_objintersect] spawn A3PL_Hydrogen_StorageSwitch}
],
[
	"Land_A3PL_FireHydrant",
	"STR_Intersect_ConnectFireHydrantKey",
	{[player_objintersect] call A3PL_FD_ConnectWrench;}
],
[
	"",
	"STR_Intersect_HoldHose",
	{[player_objintersect] spawn A3PL_FD_GrabHose;}
],
[
	"",
	"STR_Intersect_ConnectHoseToAdapter",
	{[player_objintersect] call A3PL_FD_ConnectHoseAdapter;}
],
[
	"",
	"STR_Intersect_WrapHose",
	{[player_objintersect] call A3PL_FD_RollHose;}
],
[
	"A3PL_FD_yAdapter",
	"STR_Intersect_ConnectHoseToArrival",
	{[player_objintersect,player_nameintersect] call A3PL_FD_ConnectHoseAdapter;}
],
[
	"A3PL_FD_yAdapter",
	"STR_Intersect_ConnectHoseExit",
	{[player_objintersect,player_nameintersect] call A3PL_FD_ConnectHoseAdapter;}
],
[
	"A3PL_Tanker_Trailer",
	"STR_Intersect_ConnectHoseToCitern",
	{[player_objintersect,player_nameintersect] call A3PL_FD_ConnectHoseAdapter;}
],
[
	"A3FL_T440_Gas_Tanker",
	"STR_Intersect_ConnectHoseToCitern",
	{[player_objintersect,player_nameintersect] call A3PL_FD_ConnectHoseAdapter;}
],
[
	"A3PL_FD_HydrantWrench_F",
	"STR_Intersect_OpenHydrant",
	{[player_objintersect] call A3PL_FD_WrenchRotate;}
],
[
	"A3PL_FD_HydrantWrench_F",
	"STR_Intersect_CloseHydrant",
	{[player_objintersect] call A3PL_FD_WrenchRotate;}
],
[
	"",
	"STR_Intersect_CuffUncuff",
	{
		if(!(call A3PL_Player_AntiSpam)) exitWith {};
		if (player_objintersect getVariable ["Cuffed",false]) exitWith {[player_objintersect,player] call A3PL_Police_Uncuff;};
		if (Player_ItemClass isEqualTo "handcuffs") then {
			[player_objintersect,player] call A3PL_Police_Cuff;
		} else {
			[("STR_A3PL_QuickActions_Objects_YouNeedHandcuffsToDoThisAction" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};
	}
],
[
	"",
	"STR_Common_LockpickHandcuffs",
	{
		if(!(call A3PL_Player_AntiSpam)) exitWith {};
		[player_objintersect,0] spawn A3PL_Criminal_PickHandcuffs;
	}
],
[
	"",
	"STR_Intersect_ZipTieUntie",
	{
		if(!(call A3PL_Player_AntiSpam)) exitWith {};
		if (player_objintersect getVariable ["Zipped",false]) exitWith {[player_objintersect] call A3PL_Criminal_Unzip;};
		if (Player_ItemClass == "zipties") then {
			[player_objintersect,player] call A3PL_Criminal_Ziptie;
		} else {
			[("STR_A3PL_QuickActions_Objects_YouNeedHandcuffsToDoThisAction" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};
	}
],
[
	"",
	"STR_Intersect_GiveFine",
	{[player_objintersect] call A3PL_Police_GiveTicket;}
],
[
	"",
	"STR_Common_Kick",
	{[player_objintersect] call A3PL_Police_CuffKick;}
],
[
	"",
	"STR_Intersect_Search",
	{[player_objintersect] spawn A3PL_Police_PatDown;}
],
[
	"",
	"STR_Intersect_PatDown",
	{[player_objintersect] spawn A3FL_Police_Frisk;}
],
[
	"",
	"STR_Intersect_EscortSuspect",
	{[player_objintersect] call A3PL_Police_Drag;}
],
[
	"",
	"STR_Intersect_StandUp",
	{[] remoteExec ["A3PL_Police_Stand",player_objintersect];}
],
[
	"",
	"STR_Intersect_PutDown",
	{[] remoteExec ["A3PL_Police_Putdown",player_objintersect];}
],
[
	"",
	"STR_Intersect_Escort",
	{[player_objintersect] call A3PL_Criminal_Drag;}
],
[
	"",
	"STR_Intersect_EscortIndividual",
	{[player_objintersect] call A3PL_Police_WaterDrag;}
],
[
	"",
	"STR_Common_EjectPassenger",
	{[player_objintersect] call A3PL_Police_unDetain;}
],
[
	"",
	"STR_Intersect_EjectSuspects",
	{[player_objintersect,false] call A3PL_Police_unDetain;}
],
[
	"",
	"STR_Common_DetainSuspects",
	{[Player_ObjIntersect] call A3PL_Police_Detain;}
],
[
	"",
	"STR_Intersect_LabelMeat",
	{[player_objintersect] call A3PL_Hunting_Tag;}
],
[
	"A3FL_Weed_Rack",
	"STR_Intersect_SuspendPlantToDry",
	{[player_objintersect,player_item] call A3FL_Weed_HangPlant;}
],
[
	"",
	"STR_Intersect_PlacePan",
	{[player_objintersect,player_item] call A3FL_Crack_PlacePot;}
],
[
	"A3PL_Fan",
	"STR_Intersect_ToggleFan",
	{
		private _fan = player_objintersect;
		if ((_fan animationSourcePhase "BladesOn") isEqualTo 0) then {
			_fan animateSource ["BladesOn",1];
			[("STR_A3PL_QuickActions_Objects_YouStartFan" call A3PL_Localize), Color_Green] call A3PL_Notification;
		} else {
			_fan animateSource ["BladesOn",0];
			[("STR_A3PL_QuickActions_Objects_YouStoppedFan" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};
	}
],
[
	"",
	"STR_Intersect_ToggleLamp",
	{
		private _lamp = player_objintersect;
		if ((_lamp animationSourcePhase "light") isEqualTo 0) then {
			_lamp animateSource ["light",1];
		} else {
			_lamp animateSource ["light",0];
		};
	}
],
// [
// 	"Land_A3PL_Cinema",
// 	"Prendre Popcorn",
// 	{
// 		call A3PL_Items_GrabPopcorn;
// 	}
// ],
// [
// 	"",
// 	"STR_Common_TakeBall",
// 	{
// 		[player_objintersect] call A3PL_Bowling_PickupBall;
// 	}
// ],
// [
// 	"Land_A3PL_Cinema",
// 	"Utiliser Ordinateur Cinema",
// 	{
// 		private _isCorporate = [(player getVariable ["character_id",""])] call A3PL_Config_InCompany;
// 		private _hasLicense = [player,"cinema"] call A3PL_Company_HasLicense;
// 		private _job = player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
// 		if(!_isCorporate) exitWith {[("STR_Common_NotInCompany" call A3PL_Localize), Color_Red] call A3PL_Notification;};
// 		if (_job isNotEqualTo ("STR_Common_Company" call A3PL_Localize)) exitWith {[("Vous devez avoir pris votre service dans votre entreprise afin d'accéder à ce cinéma" call A3PL_Localize), Color_Red] call A3PL_Notification;};
// 		if (!_hasLicense) exitWith {[("Votre entreprise ne possède pas les autorisations nécessaires afin d'accéder à ce cinéma" call A3PL_Localize), Color_Red] call A3PL_Notification;};
// 		[player_objintersect] call A3PL_Youtube_OpenComputer;
// 	}
// ],
[
	"",
	"STR_Intersect_GrabWeapon",
	{
		if(!(call A3PL_Player_AntiSpam)) exitWith {};
		[player_objintersect,player] spawn A3PL_Police_ReachForFirearm;
	}
],
[
	"GroundWeaponHolder",
	"STR_A3PL_Intersect_Equipment",
	{
		[Player_ObjIntersect, "", "STR_A3PL_Intersect_Equipment" call A3PL_Localize, [true, true, false, false], ["", ""]] spawn A3PL_InventoryNew_TransferMenuOpen;
	}
],
[
	"GroundWeaponHolder",
	"STR_Intersect_TakeInHand",
	{
		[Player_ObjIntersect] call A3PL_Placeables_Pickup;
	}
]