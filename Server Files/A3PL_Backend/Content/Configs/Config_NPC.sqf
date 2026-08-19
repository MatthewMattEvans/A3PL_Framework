/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
Config_NPC_Text =
[
	["mcfishers_initial","STR_NPC_WELCOMEMCF",["STR_NPC_WELCOMEMCF1","STR_NPC_WELCOMEMCF2"],["if (player getVariable 'job' == ('STR_Common_Job_McFisher' call A3PL_Localize)) exitwith {['mcfishers_already'] call A3PL_NPC_Start;}; ['mcfishers_work'] call A3PL_NPC_Start;",""]],
	["mcfishers_work","STR_NPC_MCFWORK",["STR_NPC_MCFWORK1","STR_NPC_MCFWORK2"],["[('STR_Common_Job_McFisher' call A3PL_Localize)] call A3PL_NPC_TakeJob;",""]],
	["mcfishers_already","STR_NPC_ALREADYWORKING",["STR_NPC_ALREADYWORKING1","STR_NPC_ALREADYWORKING2"],["","call A3PL_NPC_LeaveJob;"]],
	["mcfishers_accepted","STR_NPC_MCFACCEPTED",["STR_NPC_MCFACCEPTED1","STR_NPC_MCFACCEPTED2"],["['mcfishers_tutorial'] call A3PL_NPC_Start;",""]],
	["mcfishers_tutorial","STR_NPC_MCFTUTORIAL",["STR_NPC_MCFTUTORIAL1"],[""]],

	["tacohell_initial","STR_NPC_THINIT",["STR_NPC_THINIT1","STR_NPC_THINIT2"],["if (player getVariable 'job' == ('STR_Common_Job_TacoHell' call A3PL_Localize)) exitwith {['tacohell_already'] call A3PL_NPC_Start;}; ['tacohell_work'] call A3PL_NPC_Start;",""]],
	["tacohell_work","STR_NPC_THWORK",["STR_NPC_THWORK1","STR_NPC_THWORK2"],["[('STR_Common_Job_TacoHell' call A3PL_Localize)] call A3PL_NPC_TakeJob;",""]],
	["tacohell_already","STR_NPC_ALREADYWORKING",["STR_NPC_ALREADYWORKING1","STR_NPC_ALREADYWORKING2"],["","call A3PL_NPC_LeaveJob;"]],
	["tacohell_accepted","STR_NPC_THACCEPTED",["STR_NPC_THACCEPTED1","STR_NPC_THACCEPTED2"],["['tacohell_tutorial'] call A3PL_NPC_Start;",""]],
	["tacohell_tutorial","STR_NPC_THTUTORIAL",["STR_NPC_THTUTORIAL1"],[""]],

	["fisherman_initial","STR_NPC_HELLOWHOWHELP",["STR_NPC_FISHMANINIT2","STR_NPC_FISHMANINIT3"],["","['Shop_Fisherman'] call A3PL_Shop_open"]],
	["fisherman_work","STR_NPC_FISHMANWORK",["STR_NPC_FISHMANWORK1","STR_NPC_FISHMANWORK2"],["[('STR_Common_Job_Fisher' call A3PL_Localize)] call A3PL_NPC_TakeJob;",""]],
	["fisherman_already","STR_NPC_FISHMANALREADY",["STR_NPC_FISHMANALREADY1","STR_NPC_FISHMANALREADY2"],["","call A3PL_NPC_LeaveJob;"]],
	["fisherman_accepted","STR_NPC_FISHMANACCEPTED",["STR_NPC_FISHMANACCEPTED1","STR_NPC_FISHMANACCEPTED2"],["['fisherman_tutorial'] call A3PL_NPC_Start;",""]],
	["fisherman_tutorial","STR_NPC_FISHMANTUTORIAL",["STR_NPC_FISHMANTUTORIAL1"],[""]],

	["bank_initial","STR_NPC_BANKINIT",["STR_NPC_BANKINIT1","STR_NPC_BANKINIT2"],["if (Player_Paycheck < 1 ) then {['bank_paycheckrefuse'] call A3PL_NPC_Start;} else {['bank_paycheckaccepted'] call A3PL_NPC_Start;};","[] spawn A3PL_Bank_Dashboard;"]],
	["bank_paycheckrefuse","STR_NPC_BANKPCREF",["STR_NPC_BANKPCREF1"],[""]],
	["bank_paycheckaccepted","STR_NPC_BANKPCACC",["STR_NPC_BANKPCACC1","STR_NPC_BANKPCACC2"],["call A3PL_Player_PickupPaycheck;",""]],

	["fifr_initial","STR_NPC_FIFRINIT",["STR_NPC_FIFRINIT1","STR_NPC_FIFRINIT2","STR_NPC_FIFRINIT3"],["if (((player getvariable ['A3PL_Wounds',[]]) isEqualTo []) && ((player getvariable ['A3PL_Medical_Blood',5000]) isEqualTo 5000)) exitwith {['fifr_healdenied'] call A3PL_NPC_Start;}; ['fifr_heal'] call A3PL_NPC_Start;","if (player getVariable 'job' isEqualTo ('STR_Common_FIFR' call A3PL_Localize)) exitwith {['fifr_already'] call A3PL_NPC_Start;}; if (player getVariable 'faction' isEqualTo ('STR_Common_FIFR' call A3PL_Localize)) then {[('STR_Common_FIFR' call A3PL_Localize)] call A3PL_NPC_TakeJob;} else {['fifr_workdenied'] call A3PL_NPC_Start;};","['Shop_Clinic'] call A3PL_Shop_Open;"]],
	["fifr_healdenied","STR_NPC_FIFRHEALD",["STR_NPC_FIFRHEALD1"],[""]],
	["fifr_workdenied","STR_NPC_FIFRDEN",["STR_NPC_FIFRDEN1"],[""]],
	["fifr_already","STR_NPC_FIFRALREADY",["STR_NPC_FIFRALREADY1","STR_NPC_FIFRALREADY2"],["call A3PL_NPC_LeaveJob;",""]],
	["fifr_heal","STR_NPC_FIFRHEAL",["STR_NPC_FIFRHEAL1","STR_NPC_FIFRHEAL2"],["[] spawn A3PL_Medical_Heal;"]],

	["fifr_initialill","STR_NPC_FIFRINITILL",["STR_NPC_FIFRINITILL1"],["if ((str (player getvariable ['A3PL_Wounds',[]]) == '[]') && ((player getvariable ['A3PL_Medical_Blood',5000]) isEqualTo 5000)) exitwith {['fifr_healdeniedill'] call A3PL_NPC_Start;}; ['fifr_healill'] call A3PL_NPC_Start;"]],
	["fifr_healdeniedill","STR_NPC_FIFRHEALDILL",["STR_NPC_FIFRHEALD1ILL"],[""]],
	["fifr_healill","STR_NPC_FIFRHEALILL",["STR_NPC_FIFRHEALILL1","STR_NPC_FIFRHEALILL2"],["call A3PL_Medical_Heal_Ill;"]],

	["vehiclesell_initial","STR_NPC_VEHICLESELLINIT",["STR_NPC_VEHICLESELLINIT1","STR_NPC_VEHICLESELLINIT2"],["['vehiclesell_yes'] call A3PL_NPC_Start;","['vehiclesell_no'] call A3PL_NPC_Start;"]],
	["vehiclesell_no","STR_NPC_ENIGMENO",["STR_NPC_ENIGMEDSL"],[""]],
	["vehiclesell_yes","STR_NPC_VEHICLESELLYES",["STR_NPC_VEHICLESELLOFF"],["call A3PL_Chopshop_Chop;"]],

	["farmer_initial","STR_NPC_FARMINIT",["STR_NPC_FARMINIT1","STR_NPC_FARMINIT2"],["if ((player getVariable ['job',('STR_Common_Job_Unemployed' call A3PL_Localize)]) == ('STR_Common_Job_Agricultor' call A3PL_Localize)) exitwith {['farmer_already'] call A3PL_NPC_Start;}; ['farmer_work'] call A3PL_NPC_Start;",""]],
	["farmer_work","STR_NPC_FARMWORK",["STR_NPC_FARMWORK1","STR_NPC_FARMWORK2"],["[('STR_Common_Job_Agricultor' call A3PL_Localize)] call A3PL_NPC_TakeJob;",""]],
	["farmer_already","STR_NPC_FARMALR",["STR_NPC_STOPWORKINGHER","STR_NPC_LIKEJOBNVM"],["call A3PL_NPC_LeaveJob;",""]],
	["farmer_accepted","STR_NPC_FARMACC",["STR_NPC_FARMACC1","STR_NPC_FARMACC2"],["['farmer_howto'] call A3PL_NPC_Start;",""]],
	["farmer_howto","STR_NPC_FARMHOWTO",["STR_NPC_ALRIGHTTNX"],[""]],

	["oil_initial","STR_NPC_OILRECINIT",["STR_NPC_OILRECINIT1","STR_NPC_OILRECINIT2"],["if ((player getVariable ['job',('STR_Common_Job_Unemployed' call A3PL_Localize)]) == 'extracteur petrole') exitwith {['oil_already'] call A3PL_NPC_Start;}; ['oil_work'] call A3PL_NPC_Start;",""]],
	["oil_work","STR_NPC_OILRECWORK",["STR_NPC_OILRECWORK1","STR_NPC_OILRECWORK2"],["['extracteur petrole'] call A3PL_NPC_TakeJob;",""]],
	["oil_already","STR_NPC_OILRECALR",["STR_NPC_STOPWORKINGHER","STR_NPC_LIKEJOBNVM"],["call A3PL_NPC_LeaveJob;",""]],
	["oil_accepted","STR_NPC_OILRECACC",["STR_NPC_OILRECACC1","STR_NPC_OILRECACC2"],["['oil_howto'] call A3PL_NPC_Start;",""]],
	["oil_howto","STR_NPC_OILRECHOWTO",["STR_NPC_ALRIGHTTNX"],[""]],

	["dmv_initial","STR_NPC_DMV1",["STR_NPC_DriverLicense","STR_NPC_TruckingLicense","STR_NPC_MotorcycleLicense","STR_NPC_ThatsAll"],["['dmv_drivingteststart'] call A3PL_NPC_Start;","['dmv_cdlteststart'] call A3PL_NPC_Start;","['dmv_motorcycleteststart'] call A3PL_NPC_Start;",""]],
	["dmv_drivingteststart","STR_NPC_DrivingTestPrice",["STR_NPC_IAm","STR_NPC_NotReadyIwillComeBackLater"],["[] spawn A3PL_DMV_Car_Exam;",""]],
	["dmv_motorcycleteststart","STR_NPC_TruckingTestPrice",["STR_NPC_IAm","STR_NPC_NotReadyIwillComeBackLater"],["[] spawn A3PL_DMV_Motorcycle_Exam;",""]],
	["dmv_cdlteststart","STR_NPC_MotorcycleTestPrice",["STR_NPC_IAm","STR_NPC_NotReadyIwillComeBackLater"],["[] spawn A3PL_DMV_Truck_Exam;",""]],

	["verizon_initial","STR_NPC_HELLOHOWICANHELPYOU",["STR_NPC_WantToSeeSubscription"],["call A3PL_Phone_menuForfait;"]],

	["police_initial","STR_NPC_POLICEINIT",["STR_NPC_POLICEINIT1","STR_NPC_NVM"],["if (player getVariable 'job' isEqualTo ('STR_Common_FISD' call A3PL_Localize)) exitwith {['police_already'] call A3PL_NPC_Start;}; if (player getVariable 'faction' isEqualTo ('STR_Common_FISD' call A3PL_Localize)) then {[('STR_Common_FISD' call A3PL_Localize)] call A3PL_NPC_TakeJob;} else {['police_workdenied'] call A3PL_NPC_Start;};",""]],
	["police_workdenied","STR_NPC_POLICEDENIED",["STR_NPC_SORRYILEAVE"],[""]],
	["police_already","STR_NPC_ALREADY",["STR_NPC_ALREADY1","STR_NPC_ALREADY2"],["call A3PL_NPC_LeaveJob;",""]],
	["dispatch_initial","STR_NPC_WelcomeToDispatch",["STR_NPC_GoOnDuty","STR_NPC_NVM"],["if (player getVariable 'job' isEqualTo 'dispatch') exitwith {['dispatch_already'] call A3PL_NPC_Start;}; if (player getVariable 'faction' isEqualTo 'dispatch') then {['dispatch'] call A3PL_NPC_TakeJob;} else {['dispatch_workdenied'] call A3PL_NPC_Start;};",""]],
	["dispatch_workdenied","STR_NPC_YouDoNotWorkingHere",["STR_NPC_SORRYILEAVE"],[""]],
	["dispatch_already","STR_NPC_ALREADY",["STR_NPC_ALREADY1","STR_NPC_ALREADY2"],["call A3PL_NPC_LeaveJob;",""]],

	["doj_initial","STR_NPC_HELLOWHOWHELP",["STR_NPC_FAAINIT1","STR_NPC_DOJINIT2","STR_NPC_WantToConsultSMSHistory","STR_NPC_WantToLocateCall"],["['doj_howto'] call A3PL_NPC_Start;","if (player getVariable 'job' == ('STR_Common_DOJ' call A3PL_Localize)) exitwith {['doj_already'] call A3PL_NPC_Start;}; if (player getVariable 'faction' == ('STR_Common_DOJ' call A3PL_Localize)) then { ['doj_work'] call A3PL_NPC_Start; } else {['doj_workdenied'] call A3PL_NPC_Start;}","if (player getVariable 'job' == ('STR_Common_DOJ' call A3PL_Localize)) exitwith {[0] spawn A3PL_Phone_menuSMSSR;};","if (player getVariable 'job' == ('STR_Common_DOJ' call A3PL_Localize)) exitwith {[0] spawn A3PL_Phone_menuInspectTel;};"]],
	["doj_howto","STR_NPC_DOJHOWTO",["STR_NPC_AIGHTTNX"],[""]],
	["doj_already","STR_NPC_DOJALR",["STR_NPC_STOPWORKINGHER","STR_NPC_LIKEJOBNVM"],["call A3PL_NPC_LeaveJob;",""]],
	["doj_work","STR_NPC_DOJWORK",["STR_NPC_IMREADY","STR_NPC_BEBACKLATER"],["[('STR_Common_DOJ' call A3PL_Localize)] call A3PL_NPC_TakeJob;",""]],
	["doj_workdenied","STR_NPC_DOJDEN",["STR_NPC_SORRYILEAVE"],[""]],
	["doj_vehstart","STR_NPC_YouCanUseThisCar",["STR_NPC_Taurus","STR_NPC_Tahoe","STR_NPC_Focus","STR_NPC_Mustang"],["['A3FL_Taurus'] call A3PL_Lib_DOJRentCar;","['A3FL_Tahoe'] call A3PL_Lib_DOJRentCar;","['A3FL_Focus'] call A3PL_Lib_DOJRentCar;","['A3FL_Mustang15'] call A3PL_Lib_DOJRentCar;"]],

	["doc_initial","STR_NPC_HowCanIHelpYou",["STR_NPC_WantToAccesDOCShop"],["['Shop_DOC'] call A3PL_Shop_Open;"]],

	["roadside_service_initial","STR_NPC_DoYouWantAccessToTheRoadsideShop",["STR_NPC_IWantToAccessShop","STR_NPC_ThatsAll"],["if ((player getVariable ['job',('STR_Common_Job_Unemployed' call A3PL_Localize)]) IN [('STR_Common_Job_Roadworker' call A3PL_Localize),('STR_Common_Company' call A3PL_Localize)]) then {['roadside_service_supplies'] call A3PL_Shop_Open;} else {[('STR_NPC_YouNeedToBeOnDuty' call A3PL_Localize), Color_Red] call A3PL_Notification;};",""]],

	["port_initial","STR_NPC_PORTINIT",["STR_NPC_OPT1","STR_NPC_OPT2"],["[] spawn A3PL_Robberies_Port;",""]],
	["freight_initial","STR_NPC_HeyIamFreightManagerHowCanIHelpYou",["STR_NPC_WantToStartAMission","STR_NPC_WantToDeliverBoxes","STR_NPC_IDeliveredEverything"],["[player_objintersect] call A3PL_Freight_Start;","[player_objintersect] call A3PL_Freight_Unload;","[player_objintersect] call A3PL_Freight_End;"]],

	["ship_initial","STR_NPC_IAMCaptainHowCanIHelpYou",["STR_NPC_NeedToRentBoat","STR_NPC_OPT2"],["['ship_captain_rent'] call A3PL_NPC_Start;",""]],
	["ship_captain_accepted","STR_NPC_YoureNowWorkingForUsCaptain",["STR_NPC_ThanksIWillGoAHead","STR_NPC_NeedToRentBoat"],["","['ship_captain_rent'] call A3PL_NPC_Start;"]],
	["ship_captain_denied","STR_NPC_AlreadyWorkingAsCaptain",["STR_NPC_ThanksIWillGoAHead"],[""]],
	["ship_captain_rent","STR_NPC_WhatTypeOfBoatYouWantRent",["STR_NPC_BoatTransport","STR_NPC_ThatsAll"],["[player_objintersect,'A3FL_LCM',11316] call A3PL_JobShipCaptain_RentVehicle;",""]],

	["find_illtrader_initial","STR_NPC_IHaveInformationsForYou",["STR_NPC_IllTrader","STR_NPC_Moonshine","STR_NPC_Cocaine","STR_NPC_Mushrooms","STR_NPC_Weed"],["[30000,'illtrader'] call A3PL_Criminal_FindNPC;","[15000,'moonshine'] call A3PL_Criminal_FindNPC;","[25000,'cocaine'] call A3PL_Criminal_FindNPC;","[5000,'shrooms'] call A3PL_Criminal_FindNPC;","[20000,'weed'] call A3PL_Criminal_FindNPC;"]],

	["betterbuy_initial","STR_NPC_IAmBetterBuyManagerHowCanIHelpYou",["STR_NPC_INeedToRentACar","STR_NPC_IAmReadyToMoveFurniture","STR_NPC_OPT2"],["['betterbuy_rent'] call A3PL_NPC_Start;","['betterbuy_furniture'] call A3PL_NPC_Start;",""]],
	["betterbuy_accepted","STR_NPC_YoureNowWorkingForBetterBuy",["STR_NPC_ThanksIWillGoAHead","STR_NPC_INeedToRentACar","STR_NPC_IAmReadyToMoveFurniture"],["","['betterbuy_rent'] call A3PL_NPC_Start;","['betterbuy_furniture'] call A3PL_NPC_Start;"]],
	["betterbuy_denied","STR_NPC_YoureNowWorkingForBetterBuy",["STR_NPC_ThanksIWillGoAHead","STR_NPC_INeedToRentACar","STR_NPC_IAmReadyToMoveFurniture"],["","['betterbuy_rent'] call A3PL_NPC_Start;","['betterbuy_furniture'] call A3PL_NPC_Start;"]],
	["betterbuy_rent","STR_NPC_WhatTypeOfCar",["STR_NPC_KenworthT370","STR_NPC_Nothing"],["[player_objintersect,'A3FL_T370',9751] call A3PL_BetterBuy_RentVehicle;",""]],
	["betterbuy_furniture","STR_NPC_YoureNowReadyAreYouSureEverythingAReOkay",["STR_NPC_Letsgo","STR_NPC_YoureRightIWillComeBackLater"],["[player_objintersect] call A3PL_BetterBuy_JobFurniture;",""]],

	["company_initial","STR_NPC_HiHowCanIHelpYou",["STR_NPC_AccessToCompanyShop","STR_NPC_StartToWorkForCompany","STR_NPC_Nothink"],["call A3PL_CompanyShop_View_Open;","if ((player getVariable ['job',('STR_Common_Job_Unemployed' call A3PL_Localize)]) == ('STR_Common_Company' call A3PL_Localize)) exitwith {['company_denied'] call A3PL_NPC_Start;}; if (([(player getVariable ['character_id',''])] call A3PL_Config_GetCompanyID) <= 0) exitWith {['company_denied2'] call A3PL_NPC_Start;}; [('STR_Common_Company' call A3PL_Localize)] call A3PL_NPC_TakeJob; ['company_accepted'] call A3PL_NPC_Start;",""]],
	["company_accepted","STR_NPC_AlreadyOnDuty",["STR_NPC_ThanksIWillGoAHead"],[""]],
	["company_denied","STR_NPC_AlreadyOnDuty",["STR_NPC_ThanksIWillGoAHead","STR_NPC_GoOffDuty"],["","call A3PL_NPC_LeaveJob;"]],
	["company_denied2","STR_NPC_CantTakeYourDutyHere",["STR_NPC_ThanksIWillGoAHead"],[""]],

    ["police_blueprint_start","STR_NPC_WhatDoYouWantToBuy",["STR_NPC_FISDBlueprint","STR_NPC_MagsBlueprintFISD","STR_NPC_Nothink"],["call A3PL_Police_BlueprintBuy;","call A3PL_Police_BlueprintEquipmentBuy;",""]],

	["sport_start","STR_NPC_DoYouWantToStartSport",["STR_NPC_YesButForWhat","STR_NPC_NoThanks"],["['sport_chooselevel'] call A3PL_NPC_Start;","['sport_explain'] call A3PL_NPC_Start;",""]],
	["sport_explain","STR_NPC_SportExplaniation",["STR_NPC_LetsGo","STR_NPC_NoThanks"],["['sport_chooselevel'] call A3PL_NPC_Start;",""]],
	["sport_chooselevel","STR_NPC_WhatDoYouWantToDo",["STR_NPC_Sport1","STR_NPC_Sport2","STR_NPC_Sport3"],["call A3PL_Sport_Level1;","call A3PL_Sport_Level2;","call A3PL_Sport_Level3;"]],
	["sport_plus","STR_NPC_WhatDoYouWantToDo",["STR_NPC_Sport4","STR_NPC_Sport5"],["call A3PL_Sport_Level4;","call A3PL_Sport_Level5;"]],

    ["threat_start","STR_NPC_DoYouWantToEditThreatLevel",["STR_NPC_Yes","STR_NPC_NoThanks"],["['threat_chooselevel'] call A3PL_NPC_Start;",""]],
    ["threat_chooselevel","STR_NPC_ChooseLevel",["STR_NPC_Green","STR_NPC_Amber","STR_NPC_Red","STR_NPC_MartialLaw"],["missionNamespace setVariable['Server_ThreatLevel', 'green',true];","missionNamespace setVariable['Server_ThreatLevel', 'amber',true];","missionNamespace setVariable['Server_ThreatLevel', 'red',true];","missionNamespace setVariable['Server_ThreatLevel', 'martial',true];"]],

	["jobcenter_initial","STR_NPC_HiHowCanIHelpYou",["STR_NPC_Waste","STR_NPC_Deliver","STR_NPC_Exterminator","STR_NPC_SeeMore"],["['jobcenter_waste'] call A3PL_NPC_Start;","['jobcenter_deliver'] call A3PL_NPC_Start;","['jobcenter_exterminator'] call A3PL_NPC_Start;","['jobcenter_initial2'] call A3PL_NPC_Start;"]],
	["jobcenter_initial2","STR_NPC_HiHowCanIHelpYou",["STR_NPC_Trucking","STR_NPC_BetterBuy","STR_NPC_SecurityAgent","STR_NPC_SeeMore"],["['jobcenter_trucking'] call A3PL_NPC_Start;","['jobcenter_betterbuy'] call A3PL_NPC_Start;","['jobcenter_security'] call A3PL_NPC_Start;","['jobcenter_initial3'] call A3PL_NPC_Start;"]],
	["jobcenter_initial3","STR_NPC_HiHowCanIHelpYou",["STR_NPC_Taximan","STR_NPC_Fisherman","STR_NPC_Freight","STR_NPC_SeeMore"],["['jobcenter_taxi'] call A3PL_NPC_Start;","['jobcenter_roadworker'] call A3PL_NPC_Start;","['jobcenter_freight'] call A3PL_NPC_Start;","['jobcenter_initial4'] call A3PL_NPC_Start;"]],
	["jobcenter_initial4","STR_NPC_HiHowCanIHelpYou",["STR_NPC_Captain","STR_NPC_Lumberjack","STR_NPC_Farmer","STR_NPC_BackToStart"],["['jobcenter_shipcaptain'] call A3PL_NPC_Start;","['jobcenter_lumberjack'] call A3PL_NPC_Start;","['jobcenter_agricultor'] call A3PL_NPC_Start;","['jobcenter_initial'] call A3PL_NPC_Start;"]],
	["jobcenter_waste","STR_NPC_WasteDesc",["STR_NPC_StartTheJob","STR_NPC_QuitJob","STR_NPC_BackToStart"],["[('STR_Common_Job_Waste' call A3PL_Localize)] call A3PL_NPC_TakeJob;","call A3PL_NPC_LeaveJob;","['jobcenter_initial'] call A3PL_NPC_Start;"]],
	["jobcenter_deliver","STR_NPC_DeliverDesc",["STR_NPC_StartTheJob","STR_NPC_QuitJob","STR_NPC_BackToStart"],["[('STR_Common_Job_Deliver' call A3PL_Localize)] call A3PL_NPC_TakeJob;","call A3PL_NPC_LeaveJob;","['jobcenter_initial'] call A3PL_NPC_Start;"]],
	["jobcenter_exterminator","STR_NPC_ExterminatorDesc",["STR_NPC_StartTheJob","STR_NPC_QuitJob","STR_NPC_BackToStart"],["[('STR_Common_Job_Exterminator' call A3PL_Localize)] call A3PL_NPC_TakeJob;","call A3PL_NPC_LeaveJob;","['jobcenter_initial'] call A3PL_NPC_Start;"]],
	["jobcenter_security","STR_NPC_SecurityAgentDesc",["STR_NPC_StartTheJob","STR_NPC_QuitJob","STR_NPC_BackToStart"],["call A3PL_SFP_SignOn;","call A3PL_NPC_LeaveJob;","['jobcenter_initial'] call A3PL_NPC_Start;"]],
	["jobcenter_trucking","STR_NPC_TruckingDesc",["STR_NPC_StartTheJob","STR_NPC_QuitJob","STR_NPC_BackToStart"],["[('STR_Common_Job_Trucking' call A3PL_Localize)] call A3PL_NPC_TakeJob;","call A3PL_NPC_LeaveJob;","['jobcenter_initial'] call A3PL_NPC_Start;"]],
	["jobcenter_betterbuy","STR_NPC_BetterbuyDesc",["STR_NPC_StartTheJob","STR_NPC_QuitJob","STR_NPC_BackToStart"],["[('STR_Common_Job_BetterBuy' call A3PL_Localize)] call A3PL_NPC_TakeJob;","call A3PL_NPC_LeaveJob;","['jobcenter_initial'] call A3PL_NPC_Start;"]],
	["jobcenter_taxi","STR_NPC_TaxiDesc",["STR_NPC_StartTheJob","STR_NPC_QuitJob","STR_NPC_BackToStart"],["[('STR_Common_Job_Taxi' call A3PL_Localize)] call A3PL_NPC_TakeJob;","call A3PL_NPC_LeaveJob;","['jobcenter_initial'] call A3PL_NPC_Start;"]],
	["jobcenter_freight","STR_NPC_FreightDesc",["STR_NPC_StartTheJob","STR_NPC_QuitJob","STR_NPC_BackToStart"],["[('STR_Common_Job_Freight' call A3PL_Localize)] call A3PL_NPC_TakeJob;","call A3PL_NPC_LeaveJob;","['jobcenter_initial'] call A3PL_NPC_Start;"]],
	["jobcenter_roadworker","STR_NPC_FisherDesc",["STR_NPC_StartTheJob","STR_NPC_QuitJob","STR_NPC_BackToStart"],["[('STR_Common_Job_Fisher' call A3PL_Localize)] call A3PL_NPC_TakeJob;","call A3PL_NPC_LeaveJob;","['jobcenter_initial'] call A3PL_NPC_Start;"]],
	["jobcenter_shipcaptain","STR_NPC_CaptainDesc",["STR_NPC_StartTheJob","STR_NPC_QuitJob","STR_NPC_BackToStart"],["[('STR_Common_Job_Captain' call A3PL_Localize)] call A3PL_NPC_TakeJob;","call A3PL_NPC_LeaveJob;","['jobcenter_initial'] call A3PL_NPC_Start;"]],
	["jobcenter_lumberjack","STR_NPC_LumberjackDesc",["STR_NPC_StartTheJob","STR_NPC_QuitJob","STR_NPC_BackToStart"],["[('STR_Common_Job_Lumberjack' call A3PL_Localize)] call A3PL_NPC_TakeJob;","call A3PL_NPC_LeaveJob;","['jobcenter_initial'] call A3PL_NPC_Start;"]],
	["jobcenter_agricultor","STR_NPC_AgricultorDesc",["STR_NPC_StartTheJob","STR_NPC_QuitJob","STR_NPC_BackToStart"],["[('STR_Common_Job_Agricultor' call A3PL_Localize)] call A3PL_NPC_TakeJob;","call A3PL_NPC_LeaveJob;","['jobcenter_initial'] call A3PL_NPC_Start;"]]
	
];
publicVariable "Config_NPC_Text";


/*
    Format de configuration pour créer un NPC:
    [
        "ID_NPC",                    // Identifiant unique du NPC
        "C_man_w_worker_F",          // Type/Classname du NPC (ex: "C_man_1", "C_man_w_worker_F", "C_man_p_beggar_F", etc.)
        [x, y, z] ou [x, y, z, dir], // Position de spawn [x, y, z] ou [x, y, z, direction] (direction en degrés, optionnel)
        "Nom du NPC",                // Nom affiché
        "Male01ENG",                 // Voix (speaker) - ex: "Male01ENG", "Male02ENG", "Male03ENG", "Female01ENG", etc.
        "U_C_Poloshirt_blue",       // Uniforme (uniform) - "" pour aucun
        "H_Cap_blk",                // Headgear (casquette/chapeau) - "" pour aucun
        "G_Spectacles",              // Goggles (lunettes) - "" pour aucun
        "",                          // Vest (gilet) - "" pour aucun
        "",                          // Backpack (sac à dos) - "" pour aucun
        [],                          // Items additionnels dans l'inventaire - format: [["item", "nom_item", quantité], ["weapon", "nom_arme", 1], ["magazine", "nom_mag", quantité], ...]
        [],                          // Chemin de patrouille (optionnel) - Tableau de positions [[x1, y1, z1], [x2, y2, z2], ...]. Si vide, le NPC reste statique. Si rempli, le NPC bougera en boucle sur ce chemin.
        [heure_debut, heure_fin],    // Tranche horaire (optionnel) - [heure_debut, heure_fin] en heures (0-23). Exemple: [3, 6] pour apparaître entre 3h et 6h. Si omis ou [], le NPC apparaît toujours.
        1                            // Spawn automatique (optionnel) - 1 = spawn automatique au démarrage du serveur, 0 = spawn manuel uniquement. Par défaut: 0
    ]
    
    UTILISATION:
    Pour créer un NPC, utilisez la fonction: ["ID_NPC"] call A3PL_NPC_Create;
    Pour créer un NPC à une position personnalisée: ["ID_NPC", [x, y, z]] call A3PL_NPC_Create;
    La fonction retourne l'objet NPC créé.
    
    Pour créer un NPC qui patrouille, ajoutez un tableau de positions dans le paramètre 11 de la config.
    Pour créer un NPC avec une tranche horaire, ajoutez [heure_debut, heure_fin] dans le paramètre 12 de la config.
    Pour créer un NPC qui spawn automatiquement au démarrage, mettez 1 dans le paramètre 13 de la config.
*/

Config_NPC_Spawn = 
[
    [
        "npc_dyn_elk_1",
        "C_man_w_worker_F",
        [6601.1,7454.63,0,100.479],
        "John Doe",
        "Male01ENG",
        "U_C_Poloshirt_blue",
        "H_Cap_blk",
        "G_Spectacles",
        "",
        "",
        [],
        [
            [6636.93,7447.34,0.111447],
            [6653.55,7531.96,0.112066],
            [6650.27,7532.73,0.11622],
            [6646.64,7533.44,0.106427],
			[6641.88,7534.41,0.110487],
			[6637.28,7535.39,0.110901],
			[6631.82,7536.54,0.110705],
			[6625.09,7537.95,0.110726],
			[6617.82,7539.45,0.110128],
			[6610.79,7540.9,0.111051],
			[6603.47,7542.42,0.098928],
			[6594.94,7544.14,0.107827],
			[6588.38,7545.46,0.119728],
			[6582.48,7546.62,0.00140095],
			[6576.13,7547.87,0.106328],
			[6576.8,7552.65,0.00134516],
			[6577.61,7559.09,0.125442],
			[6571.37,7560.26,0.145627],
			[6565.24,7561.35,0.00143147],
			[6558.34,7562.59,0.119672],
			[6551.59,7563.86,0.129185],
			[6545.26,7565.03,0.13541],
			[6536.38,7566.72,0.133721],
			[6531.06,7567.66,0.123972],
			[6525.38,7567.93,0.00143623],
			[6518.18,7568.96,0.0014348],
			[6511.37,7570.01,0.110507],
			[6503.59,7571.25,0.096529],
			[6495.47,7572.55,0.116929],
			[6486.9,7573.81,0.115138],
			[6477.69,7575.13,0.111871],
			[6468.11,7576.44,0.111166],
			[6457.79,7577.9,0.11152],
			[6448.97,7579.24,0.00144053],
			[6439.77,7580.5,0.00143671],
			[6431.15,7581.63,0.115469],
			[6422.45,7582.81,0.116145],
			[6411.98,7584.22,0.111697],
			[6404.91,7585.15,0.109475],
			[6399.61,7585.99,0.112101],
			[6398.69,7580.16,0.00144672],
			[6398.08,7575.91,0.118233],
			[6391.47,7576.85,0.00144005],
			[6385.15,7577.88,0.112147],
			[6377.22,7579.26,0.108683],
			[6368.22,7580.86,0.112174],
			[6359.41,7582.4,0.112176],
			[6350.87,7583.82,0.113507],
			[6343.35,7584.75,0.00143862],
			[6336.98,7585.54,0.00143909],
			[6328.81,7586.08,0.111432],
			[6320.54,7586.3,0.119248],
			[6313.31,7586.02,0.0934248],
			[6305.22,7585.39,0.0989842],
			[6296.59,7584.28,0.111384],
			[6285.32,7582.26,0.111398],
			[6272.87,7579.04,0.108976],
			[6259.53,7574.18,0.108809],
			[6246.97,7568.35,0.111442],
			[6235.94,7561.71,0.111886],
			[6226.16,7555.01,0.111375],
			[6217.81,7548.54,0.111301],
			[6211.93,7543.49,0.111245],
			[6207.11,7538.7,0.00143766],
			[6202.68,7534.18,0.00143814],
			[6197.41,7528.74,0.00143862],
			[6192.39,7523.53,0.00143766],
			[6187.93,7518.45,0.00143576],
			[6184.26,7513.81,0.0317216],
			[6179.1,7507.89,0.124582],
			[6172.63,7500.46,0.136254],
			[6167.01,7493.13,0.160125],
			[6162.55,7487.04,0.151611],
			[6156.98,7479.35,0.108851],
			[6151.52,7481.12,0.0014348],
			[6145.52,7482.97,0.0814471],
			[6140.22,7475.35,0.100072],
			[6134.38,7468.74,0.106773],
			[6127.44,7460.83,0.105836],
			[6121.67,7453.99,0.106586],
			[6114.02,7444.89,0.107909],
			[6106.14,7435.34,0.106811],
			[6099.57,7427.36,0.111285],
			[6093.6,7431.61,0.0108328],
			[6086.49,7436.09,0.113643],
			[6080.88,7438.3,0.116847],
			[6074.76,7440.05,0.114544],
			[6071.91,7440.55,0.115527],
			[6072.03,7444.72,0.00143719]
        ],
        [],
        1 
    ],

	[
        "npc_dyn_elk_2",
        "C_man_w_worker_F",
        [5942.34,7321.98,0,80.2854],
        "John Doe",
        "Male01ENG",
        "U_C_Poloshirt_blue",
        "H_Cap_blk",
        "G_Spectacles",
        "",
        "",
        [],
        [
            [5947.57,7323.23,0.0949464],
			[5947.19,7326.42,0.0959778],
			[5946.93,7330.18,0.0925856],
			[5947.63,7333.86,0.084229],
			[5948.75,7337.97,0.0737863],
			[5951.03,7342.25,0.077775],
			[5954.19,7345.44,0.0881653],
			[5958.11,7347.5,0.108416],
			[5963.34,7348.99,0.114355],
			[5968.96,7349.66,0.143762],
			[5974.19,7349.54,0.149639],
			[5979.47,7348.68,0.160543],
			[5984.66,7346.82,0.177062],
			[5989.38,7344.46,0.182019],
			[5993.55,7341.98,0.181955],
			[5998.32,7339.24,0.186769],
			[6003.05,7336.5,0.190032],
			[6007.55,7333.88,0.035459],
			[6012.5,7331,0.185299],
			[6016.18,7328.42,0.185594],
			[6020.28,7325.73,0.193069],
			[6024.21,7323.57,0.0281034],
			[6028.58,7321.16,0.190252],
			[6033.36,7318.45,0.182239],
			[6037.62,7315.98,0.182284],
			[6042.24,7313.3,0.182265],
			[6047.25,7310.41,0.182265],
			[6050.55,7308.81,0.180675],
			[6051.27,7313.92,0.151835],
			[6051.56,7319.43,0.0987606],
			[6051.01,7324.17,0.0964108],
			[6050.18,7329.83,0.0939097],
			[6049.46,7335.46,0.0953608],
			[6049.41,7341.07,0.091763],
			[6049.92,7346.25,0.0904074],
			[6051.08,7351,0.0872364],
			[6052.2,7353.93,0.0975771],
			[6053.58,7358.32,0.00143862],
			[6055.83,7362.8,0.0809937],
			[6058.55,7367.42,0.0910125],
			[6061.77,7372.42,0.102956],
			[6064.59,7376.92,0.102386],
			[6067.8,7382.13,0.102851],
			[6070.84,7387.49,0.107343],
			[6073.79,7392.85,0.107196],
			[6077.19,7398.43,0.104967],
			[6080.88,7403.89,0.106542],
			[6084.76,7409,0.108262],
			[6088.31,7413.4,0.107383],
			[6091.32,7416.79,0.106901],
			[6094.09,7414.64,0.00143909],
			[6097.22,7412.21,0.00143957],
			[6099.99,7410.06,0.110872],
			[6103.13,7414.02,0.109954],
			[6106.91,7418.6,0.110875],
			[6110.24,7422.67,0.113352],
			[6113.52,7426.72,0.109293],
			[6117.22,7431.21,0.109759],
			[6120.66,7435.35,0.111292],
			[6124.12,7439.48,0.11166],
			[6127.34,7443.32,0.109062],
			[6129.75,7446.32,0.0402203],
			[6133.23,7444.19,0.00143862],
			[6137.8,7440.77,0.00143957],
			[6143.52,7436.94,0.00143862],
			[6149.46,7434.52,0.00143862],
			[6156.32,7433.31,0.00144577],
			[6163.01,7433.86,0.00145483],
			[6167.81,7435.13,0.00144243]

        ],
        [],
        1 
    ],

	[
        "npc_dyn_silverton_1", 
        "C_man_w_worker_F",
        [2853.84,5619.66,0.00143909,0], 
        "John Doe",
        "Male01ENG",
        "U_C_Poloshirt_blue",
        "H_Cap_blk",
        "G_Spectacles",
        "",
        "",
        [],
        [
            [2862.72,5623.67,0.00144768],
            [2868.92,5629.4,0.001441],
            [2874.06,5625.86,0.112561],
            [2876.31,5614.74,0.0908318],
            [2879.17,5604.29,0.110464],
            [2875.27,5597.82,0.107998],
            [2863.79,5593.17,0.116172],
            [2851.71,5589.58,0.231647],
            [2833.97,5582.69,0.0749655],
            [2823.72,5578.55,0.13593],
            [2817.73,5572.48,0.112509],
            [2820.23,5564.57,0.0805864],
            [2810.33,5558.94,0.0992708],
            [2809.08,5549.63,0.110202],
            [2813.5,5537.09,0.102596],
            [2817.18,5525.91,0.0956702],
            [2820.82,5515.33,0.0956035],
            [2824.06,5505.87,0.110865],
            [2829.32,5491.82,0.109544],
            [2833.42,5482.52,0.109289],
            [2849.48,5482.56,0.107297],
            [2863.24,5489.59,0.103534],
            [2874.99,5494.86,0.0893893],
            [2883.66,5499.02,0.100458],
            [2886.38,5508.9,0.0327373],
            [2890.32,5513.39,0.0323091]
        ],
        [],
        1 
    ],

	[
        "npc_dyn_stoneycreek_1",
        "C_man_w_worker_F",
        [3528.66,7642.81,0.00137925,0], 
        "John Doe",
        "Male01ENG",
        "U_C_Poloshirt_blue",
        "H_Cap_blk",
        "G_Spectacles",
        "",
        "",
        [],
        [
            [3532.49,7637.16,0.00138402],
            [3535.81,7629.24,0.00141001],
            [3531.81,7618.27,0.00143886],
            [3532.76,7604.31,0.128597],
            [3531.48,7592.95,0.119847],
            [3530.14,7583.43,0.119847],
            [3528.95,7574.3,0.120156],
            [3527.43,7561.58,0.120265],
            [3527.6,7553.64,0.124532],
            [3526.14,7541.35,0.13294],
            [3524.79,7526.85,0.120344],
            [3539.81,7524.61,0.00143886],
            [3552.25,7523.47,0.114616],
            [3568.35,7522.24,0.108879],
            [3569.3,7510.63,0.00143886],
            [3568.11,7501.37,0.00143886],
            [3567.36,7492.71,0.00143886],
            [3559.63,7490.66,0.00143886],
            [3550.79,7489.2,0.976909]
        ],
        [],
        1 
    ],

	 [
        "npc_dyn_springfield_1",
        "C_man_w_worker_F",
        [8717.7,6520.14,0.111334], 
        "John Doe",
        "Male01ENG",
        "U_C_Poloshirt_blue",
        "H_Cap_blk",
        "G_Spectacles",
        "",
        "",
        [],
        [
            [8706.88,6523.46,0.111606],
            [8696.39,6512.33,0.111606],
            [8695.74,6497.71,0.111606],
            [8695.98,6485.65,0.111606],
            [8695.78,6475.09,0.111606],
            [8695.86,6463.06,0.111606],
            [8695.86,6441.38,0.111427],
            [8695.58,6427.98,0.111427],
            [8714.81,6428.06,0.111606],
            [8729.99,6427.55,0.111606],
            [8749.66,6427.37,0.111606],
            [8770.1,6427.67,0.111606],
            [8788.23,6426.65,0.111426],
            [8787.87,6413.92,0.111606],
            [8788.08,6394.51,0.110431],
            [8783.47,6386.86,0.108478],
            [8774.41,6386.48,0.10927],
            [8770.01,6381.5,0.121432]
        ],
        [],
        1 
    ],

	[
        "npc_dyn_northdale_airport_1", 
        "C_man_w_worker_F",
       [11321.9,8800.74,0.00132751],
        "John Doe",
        "Male01ENG",
        "U_C_Poloshirt_blue",
        "H_Cap_blk",
        "G_Spectacles",
        "",
        "",
        [],
        [
            [11321.8,8790.44,0.00141907],
            [11321.5,8778.5,0.00139999],
            [11321.5,8763.93,0.00140381],
            [11321.7,8749.07,0.00130844],
            [11321.8,8731.47,0.00146866],
            [11321.7,8719.41,0.00143814],
            [11321.4,8708.92,0.00147629],
            [11321.7,8694.09,0.00144005],
            [11320.3,8676.53,0.00131035],
            [11318,8660.3,0.00130463]
        ],
        [],
        1 
    ],
	
	[
        "hooker_elk_1",
        "C_man_w_worker_F",
        [6141.41,7477.08,0,111.792],
        "Crystal",
        "Male01ENG",
        "A3PL_Bikinigirl_Uniform",
        "",
        "",
        "",
        "",
        [],
        [],
        [22,6],
        1 
	],

	[
        "hooker_elk_2",
        "C_man_w_worker_F",
        [6171.08,7631.99,0,202.852],
        "Crystal",
        "Male01ENG",
        "A3PL_Bikinigirl_Uniform",
        "",
        "",
        "",
        "",
        [],
        [],
        [22,6],
        1 
	],

	[
        "hooker_elk_3",
        "C_man_w_worker_F",
        [6025.14,7309.67,0,31.2082],
        "Crystal",
        "Male01ENG",
        "A3PL_Bikinigirl_Uniform",
        "",
        "",
        "",
        "",
        [],
        [],
        [22,6],
        1 
	],

	[
        "hooker_blackwood_1",
        "C_man_w_worker_F",
        [6929.7,6432.99,0,358.224],
        "Crystal",
        "Male01ENG",
        "A3PL_Bikinigirl_Uniform",
        "",
        "",
        "",
        "",
        [],
        [],
        [22,6],
        1 
	],

	[
        "hooker_blackwood_2",
        "C_man_w_worker_F",
        [7027.54,6466.04,0,285.142],
        "Crystal",
        "Male01ENG",
        "A3PL_Bikinigirl_Uniform",
        "",
        "",
        "",
        "",
        [],
        [],
        [22,6],
        1 
	],

	[
        "hooker_springfield_1",
        "C_man_w_worker_F",
        [8786.71,6371.41,0,90.4153],
        "Crystal",
        "Male01ENG",
        "A3PL_Bikinigirl_Uniform",
        "",
        "",
        "",
        "",
        [],
        [],
        [22,6],
        1 
	],

	[
        "hooker_springfield_2",
        "C_man_w_worker_F",
        [8961.87,6437.69,0,301.782],
        "Crystal",
        "Male01ENG",
        "A3PL_Bikinigirl_Uniform",
        "",
        "",
        "",
        "",
        [],
        [],
        [22,6],
        1 
	],

	[
        "hooker_stoney_1",
        "C_man_w_worker_F",
        [3415.25,7570.9,0,96.7281],
        "Crystal",
        "Male01ENG",
        "A3PL_Bikinigirl_Uniform",
        "",
        "",
        "",
        "",
        [],
        [],
        [22,6],
        1 
	],

	[
        "hooker_stoney_2",
        "C_man_w_worker_F",
        [3540.19,7489.18,1.04344,273.896],
        "Crystal",
        "Male01ENG",
        "A3PL_Bikinigirl_Uniform",
        "",
        "",
        "",
        "",
        [],
        [],
        [22,6],
        1 
	],

	[
        "hooker_steelmill",
        "C_man_w_worker_F",
        [4301.46,6768.23,0,162.664],
        "Crystal",
        "Male01ENG",
        "A3PL_Bikinigirl_Uniform",
        "",
        "",
        "",
        "",
        [],
        [],
        [22,6],
        1 
	]
];
publicVariable "Config_NPC_Spawn";

Config_NPC_Hooker_CarPoints = [
    [6383.34,7971.77,0],
    [10022.5,7793.37,0],
    [6949.55,7122.64,0],
    [5511.86,5915.99,0],
    [6451.62,5518.01,0],
    [4743.75,6007.78,0],
    [4089.43,6290.54,0],
    [4327.2,6951.83,0],
    [3529.89,7486.41,0],
    [3820.66,6202.56,0]
];
publicVariable "Config_NPC_Hooker_CarPoints";

/*
    Configuration des identités et dialogues pour les NPCs
    
    Format:
    Config_NPC_Identities = [
        "IdentityName1",
        "IdentityName2",
        "IdentityName3"
    ];
    
    Config_NPC_Dialogs = [
        [
            "DialogType",           // Type de dialogue (ex: "refusal", "greeting", etc.)
            [
                ["Identity1", ["dialog1", "dialog2"]],  // Dialogues pour Identity1
                ["Identity2", ["dialog1", "dialog2"]]   // Dialogues pour Identity2
            ]
        ]
    ];
*/

// Liste des identités disponibles
Config_NPC_Identities = [
    "Ian",
    "Alex",
    "Sean"
];
publicVariable "Config_NPC_Identities";

// Configuration des dialogues par type et par identité
Config_NPC_Dialogs = [
    [
        "refusal",
        [
            ["Ian", ["refusal_1_ian", "refusal_2_ian"]],
            ["Alex", ["refusal_1_alex", "refusal_2_alex"]],
            ["Sean", ["refusal_1_sean", "refusal_2_sean"]]
        ]
    ],
    [
        "greeting",
        [
            ["Alex", ["greeting_3_alex"]],
            ["Ian", ["greeting_3_ian"]],
            ["Sean", ["greeting_3_sean"]]
        ]
    ],
    [
        "completion",
        [
            ["Alex", ["completion_1_alex"]],
            ["Ian", ["completion_1_ian"]],
            ["Sean", ["completion_1_sean"]]
        ]
    ],
    [
        "confirmation",
        [
            ["Sean", ["confirmation_2_sean"]],
            ["Alex", ["confirmation_2_alex"]],
            ["Ian", ["confirmation_2_ian"]]
        ]
    ],
    [
        "listen",
        [
            ["Alex", ["greeting_5_alex"]],
            ["Ian", ["greeting_5_ian"]],
            ["Sean", ["greeting_5_sean"]]
        ]
    ],
    [
        "shout",
        [
            ["Alex", ["shouting_1_alex", "shouting_3_alex"]],
            ["Ian", ["shouting_3_ian"]],
            ["Sean", ["shouting_2_sean", "shouting_3_sean"]]
        ]
    ],
    [
        "misc",
        [
            ["Alex", ["miscellaneous_13_alex", "miscellaneous_15_alex", "miscellaneous_18_alex"]],
            ["Ian", ["miscellaneous_13_ian", "miscellaneous_14_ian", "miscellaneous_15_ian", "miscellaneous_18_ian"]],
            ["Sean", ["miscellaneous_13_sean", "miscellaneous_14_sean", "miscellaneous_15_sean", "miscellaneous_17_sean", "miscellaneous_18_sean"]]
        ]
    ]
];
publicVariable "Config_NPC_Dialogs";

// Configuration des dialogues pour les NPCs de rue
// Format: ["dialog_id", "text_key", [options], [next_dialogs], "init_function", "type", "mark_used_on_refusal"]
// type: "simple" = pas de valeurs dynamiques, "quantity_amount" = quantité + montant, "amount" = seulement montant
// mark_used_on_refusal: ID du dialogue à marquer comme utilisé si le joueur refuse (pour les dialogues de refus)

Config_NPC_Street_Dialogs = [
	["hooker_initial", "STR_NPC_Hooker_WhatDoYouWant", ["STR_NPC_Hooker_WorkForMe", "STR_NPC_Hooker_GoHome", "STR_NPC_Hooker_InCar"], 
		["hooker_work_action", "hooker_home_action", "hooker_car_action"], "", "simple", ""],
	
	["cocaine", "STR_NPC_CocaineRequest", ["STR_NPC_Yes", "STR_NPC_No", "STR_NPC_ComeBackLater"],
		["cocaine_yes", "cocaine_no", ""], "A3PL_NPC_CocaineRequest_Init", "quantity_amount", "npc_cocaine_request"],

	["weed", "STR_NPC_WeedRequest", ["STR_NPC_Yes", "STR_NPC_No", "STR_NPC_ComeBackLater"],
		["weed_yes", "weed_no", ""], "A3PL_NPC_WeedRequest_Init", "quantity_amount", "npc_weed_request"],

	["moonshine", "STR_NPC_MoonshineRequest", ["STR_NPC_Yes", "STR_NPC_No", "STR_NPC_ComeBackLater"],
		["moonshine_yes", "moonshine_no", ""], "A3PL_NPC_MoonshineRequest_Init", "quantity_amount", "npc_moonshine_request"],

	["shrooms", "STR_NPC_ShroomsRequest", ["STR_NPC_Yes", "STR_NPC_No", "STR_NPC_ComeBackLater"],
		["shrooms_yes", "shrooms_no", ""], "A3PL_NPC_ShroomsRequest_Init", "quantity_amount", "npc_shrooms_request"],

	["money", "STR_NPC_MoneyRequest", ["STR_NPC_Yes", "STR_NPC_No"], 
		["money_yes", "money_no"], "A3PL_NPC_MoneyRequest_Init", "amount", "npc_money_request"],
	
	["leave", "STR_NPC_LeaveRequest", ["STR_NPC_OK"], 
		["leave_ok"], "", "simple", "npc_leave_request"],
	
	["sex_request", "STR_NPC_SexRequest", ["STR_NPC_Yes", "STR_NPC_No"], 
		["sex_yes", "sex_no"], "", "simple", "npc_sex_request"],
	
	["cocaine_yes", "", [], 
		["cocaine_yes"], "", "simple", ""],
	["cocaine_no", "STR_NPC_CocaineNo", ["STR_NPC_Understood"], 
		[""], "", "simple", ""],
	
	["weed_yes", "", [], 
		["weed_yes"], "", "simple", ""],
	["weed_no", "STR_NPC_WeedNo", ["STR_NPC_Understood"], 
		[""], "", "simple", ""],
	
	["moonshine_yes", "", [],
		["moonshine_yes"], "", "simple", ""],
	["moonshine_no", "STR_NPC_MoonshineNo", ["STR_NPC_Understood"],
		[""], "", "simple", ""],

	["shrooms_yes", "", [],
		["shrooms_yes"], "", "simple", ""],
	["shrooms_no", "STR_NPC_ShroomsNo", ["STR_NPC_Understood"],
		[""], "", "simple", ""],

	["money_yes", "", [], 
		["money_yes"], "", "simple", ""],
	["money_no", "STR_NPC_MoneyNo", ["STR_NPC_Understood"], 
		[""], "", "simple", ""],
	
	["leave_ok", "", [], 
		[""], "", "simple", ""]
];
publicVariable "Config_NPC_Street_Dialogs";