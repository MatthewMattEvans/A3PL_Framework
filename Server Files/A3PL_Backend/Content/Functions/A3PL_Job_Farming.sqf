/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_JobFarming_SearchSeeds",
{
	private _isCorporate = [(player getVariable ["character_id",""])] call A3PL_Config_InCompany;
	private _hasLicense = [player,"foodf"] call A3PL_Company_HasLicense;
	private _job = player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
	if(!_isCorporate) exitWith {[("STR_Common_NotInCompany" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_job isNotEqualTo ("STR_Common_Company" call A3PL_Localize)) exitWith {[("STR_A3PL_Job_Farming_NeedToBeOnDutyCompany" call A3PL_Localize), Color_Red] call A3PL_Notification;};
	if (!_hasLicense) exitWith {[("STR_A3PL_Job_Farming_CompanyNotAuthorized" call A3PL_Localize),Color_Red] call A3PL_Notification;};


	private _timeLeft = missionNameSpace getVariable ["A3PL_JobFarming_SeedTimer",(diag_ticktime-5)];
	if (_timeLeft > diag_ticktime) exitwith {[format [("STR_A3PL_Job_Farming_WaitBeforeSearch" call A3PL_Localize),round(_timeLeft-diag_ticktime)],Color_Red] call A3PL_Notification;};
	missionNameSpace setVariable ["A3PL_JobFarming_SeedTimer",(diag_ticktime + (1 + random 3))];

	player playMove 'AmovPercMstpSnonWnonDnon_AinvPercMstpSnonWnonDnon_Putdown';

	private _random = round (random 100);
	private _found = "";
	switch (true) do {
		case (_random > 40): {[("STR_A3PL_Job_Farming_NothingFound" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		case (_random >= 0): {
			private _seed = selectRandom ["seed_wheat","seed_corn","seed_lettuce","seed_coca","seed_sugar","seed_carrot"];
			[format [("STR_A3PL_Job_Farming_YouFound" call A3PL_Localize),([_seed,"name"] call A3PL_Config_GetItem)],Color_Green] call A3PL_Notification;
			[_seed,1] call A3PL_Inventory_Add;
		};
	};
}] call compile_Global;

["A3PL_JobFarming_Plant", {
	private _class = player_itemClass;
	if (!(_class IN  Seeds_List)) exitwith {[("STR_A3PL_Job_Farming_NoSeedToPlant" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if(!(call A3PL_Player_AntiSpam)) exitWith {};

	private _posATL = getPosATL player;
	private _plantation = [position player] call A3FL_JobFarming_InPlantation;
	if ((_plantation isEqualTo 0) && ((surfaceType getpos player) isNotEqualTo Surface_To_Plant_Seeds)) exitwith {[("STR_A3PL_Job_Farming_NotInFarm" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _nearPlants = nearestObjects [player,Housing_Max_Items_Planter,1];
	if(count(_nearPlants) > 0) exitWith {[("STR_A3PL_Job_Farming_YouCantPlantOnAnotherSeed" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _nearByPlants = nearestObjects [player,Housing_Max_Items_Planter,100];
	if(count(_nearByPlants) > 250) exitWith {[("STR_A3PL_Job_Farming_TooMuchPlant" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	player playMove 'AmovPercMstpSnonWnonDnon_AinvPercMstpSnonWnonDnon_Putdown';
	[player,_class,_posATL] remoteExec ["Server_JobFarming_Plant",2];
}] call compile_Global;

["A3PL_JobFarming_Harvest",
{
	private _plant = param [0,objNull];
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	if ((isNull player) or (isNull _plant)) exitwith {};
	if ((_plant animationSourcePhase "plant_growth") < 1) exitwith {[("STR_A3PL_Job_Farming_NotReadyToBeGathered" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	player playMove 'AmovPercMstpSnonWnonDnon_AinvPercMstpSnonWnonDnon_Putdown';
	[player,_plant] remoteExec ["Server_JobFarming_Harvest",2];
}] call compile_Global;

["A3PL_JobFarming_PlantReceive",
{
	private _r = param [0,-1];
	private _msg = switch (_r) do {
		case -1: {[("STR_A3PL_Job_Farming_ErrorPlantSeed" call A3PL_Localize),Color_red];};
		case 0: {[("STR_A3PL_Job_Farming_YouPlantSeed" call A3PL_Localize),Color_green];};
		case 1: {[("STR_A3PL_Job_Farming_AlreadyOwned" call A3PL_Localize),Color_red];};
		case 2: {[("STR_A3PL_Job_Farming_AlreadyHaveOne" call A3PL_Localize),Color_red];};
		case 3: {[format [("STR_A3PL_Job_Farming_YouRent" call A3PL_Localize),param [1,"Error"]],Color_green];};
		case 4: {[("STR_A3PL_Job_Farming_NotCultived" call A3PL_Localize),Color_red];};
		case 5: {[format [("STR_A3PL_Job_Farming_YouGathered" call A3PL_Localize),param [2,1],([param [1,""], 'name'] call A3PL_Config_GetItem)],Color_green];};
		case 6: {[("STR_A3PL_Job_Farming_ErrorAddObjectInventory" call A3PL_Localize),Color_red];};
		case 7: {[("STR_A3PL_Job_Farming_YouPlantSeedInPot" call A3PL_Localize),Color_green];};
	};
	if(!isNil 'Player_ItemAmount') then {
		Player_ItemAmount = Player_ItemAmount - 1;
		if((Player_ItemAmount isEqualTo 0) && (_r IN [0,7])) then{[] call A3PL_Inventory_Clear;};
	};
	_msg call A3PL_Notification;
}] call compile_Global;

["A3PL_JobFarming_BuyGreenhouse",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private _greenHouse = param [0,objNull];
	if (isNull _greenHouse) exitwith {["Couldn't determine greenhouse",Color_Red] call A3PL_Notification;};
	private _timeLeft = serverTime - (_greenHouse getVariable ["buyTime",serverTime]);
	if ((_timeLeft < GreenHouse_Max_Location_Time) && (_timeLeft != 0)) exitwith { [format [("STR_A3PL_Job_Farming_AlreadyRented" call A3PL_Localize),(GreenHouse_Max_Location_Time - _timeLeft)/60],Color_Red] call A3PL_Notification;};
	player setVariable ["paymentResult",objNull];
	[GreenHouse_Price] call A3PL_Bank_HowToPay;
	[_greenHouse] spawn {
		params["_greenHouse"];
		waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
		if (!(player getVariable "paymentResult")) exitWith {};
		_greenHouse setVariable ["buyTime",serverTime,true];
	[player,_greenHouse,"",false,"greenhouse"] remoteExec ["Server_Housing_CreateKey", 2];
	[format[("STR_A3PL_Job_Farming_YouRentThisFor" call A3PL_Localize),GreenHouse_Price],Color_Green] call A3PL_Notification;
	};
}] call compile_Global;

["A3PL_JobFarming_GreenHousePlant",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private _greenHouse = param [0,objNull];
	if (isNull _greenHouse) exitwith {["Couldn't determine greenhouse",Color_Red] call A3PL_Notification;};
	private _class = player_itemClass;
	if (_class isEqualTo "seed_marijuana") exitWith {[("STR_A3PL_Job_Farming_CantPlantSeedHere" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _timeLeft = serverTime - (_greenHouse getVariable ["buyTime",serverTime]);
	if (_timeLeft > GreenHouse_Max_Location_Time) exitwith {[("STR_A3PL_Job_Farming_RentExpired" call A3PL_Localize)] call A3PL_Notification;};
	private _amountPlants = count (nearestObjects [player,["A3PL_Wheat","A3PL_Corn","A3FL_Cannabis_Plant","A3PL_Lettuce","A3PL_Coco_Plant","A3PL_Sugarcane_Plant","A3FL_Carrot_Grow","A3FL_Tobacco_Plant"],10]);
	if (_amountPlants >= GreenHouse_Max_Plant) exitwith {[format[("STR_A3PL_Job_Farming_TooMuchSeed" call A3PL_Localize),GreenHouse_Max_Plant],Color_Red] call A3PL_Notification};
	private _interDist = [_greenHouse, "FIRE"] intersect [positionCameraToWorld [0,0,0],positionCameraToWorld [0,0,1000]];
	if (count _interDist < 1) exitwith {["Unable to determine where to place the seed",Color_Red] call A3PL_Notification;};
	private _dist = (_interDist select 0) select 1;
	private _begPosASL = AGLToASL positionCameraToWorld [0,0,0];
	private _endPosASL = AGLToASL positionCameraToWorld [0,0,1000];
	private _posATL = ASLToATL (_begPosASL vectorAdd ((_begPosASL vectorFromTo _endPosASL) vectorMultiply _dist));
	[player,_class,_posATL,true] remoteExec ["Server_JobFarming_Plant",2];
}] call compile_Global;

["A3PL_JobFarming_PlanterPlant",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private _planter = param [0,objNull];
	if (isNull _planter) exitwith {["Couldn't determine planter",Color_Red] call A3PL_Notification;};
	private _class = player_itemClass;

	//private _crackhouse = nearestObjects [getPos player,["Land_A3FL_Crackhouse"],10];
	//private _chid = ((_crackhouse#0) getVariable ["doorid",0])#1;
	
	// if (_class isEqualTo "seed_marijuana") then {
	// 	if (count(_crackhouse) isEqualTo 0) exitWith {[("STR_A3PL_Job_Farming_NeedToBeInCrackhouse" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	// 	if (!(_chid IN (player getVariable "keys"))) exitWith {[("STR_A3PL_Job_Farming_CrackhouseNotToYou" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	// };
	private _nearByPlants = nearestObjects [player,Housing_Max_Items_Planter,3];
	if(count(_nearByPlants) >= 4) exitWith {[("STR_A3PL_Job_Farming_TooMuchSeedHereGather" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _interDist = [_planter, "FIRE"] intersect [positionCameraToWorld [0,0,0],positionCameraToWorld [0,0,1000]];
	if (count _interDist < 1) exitwith {["Unable to determine where to place the seed",Color_Red] call A3PL_Notification;};
	private _dist = (_interDist#0)#1;
	private _begPosASL = AGLToASL positionCameraToWorld [0,0,0];
	private _endPosASL = AGLToASL positionCameraToWorld [0,0,1000];
	private _posATL = ASLToATL (_begPosASL vectorAdd ((_begPosASL vectorFromTo _endPosASL) vectorMultiply _dist));
	[player,_class,_posATL,true,_planter] remoteExec ["Server_JobFarming_Plant",2];
}] call compile_Global;

["A3FL_JobFarming_TestSoil",
{
	if(Player_ActionDoing) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	[("STR_A3PL_Job_Farming_Test" call A3PL_Localize),Test_Soil_Time] spawn A3PL_Lib_LoadAction;
	waitUntil{Player_ActionDoing};
	[player,"Acts_TerminalOpen"] remoteExec ["A3PL_Lib_SyncAnim",0];
	while {Player_ActionDoing} do {
		if (!(player getVariable["A3PL_Medical_Alive",true])) exitWith {Player_ActionInterrupted=true;};
		if ((vehicle player) isNotEqualTo player) exitwith {Player_ActionInterrupted=true;};
		if (player getVariable ["Incapacitated",false]) exitwith {Player_ActionInterrupted=true;};
	};
	if(Player_ActionInterrupted) exitWith {[("STR_A3PL_Job_Farming_ActionCancelled" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	[player,""] remoteExec ["A3PL_Lib_SyncAnim",0];

	private _plantation = [position player] call A3FL_JobFarming_InPlantation;

	if (_plantation isEqualTo 0) then {
    	[("STR_A3PL_Job_Farming_NotAPlant" call A3PL_Localize),Color_Red] call A3PL_Notification;
	} else {
    	[format[("STR_A3PL_Job_Farming_PlantFound" call A3PL_Localize),_plantation#2],Color_Yellow] call A3PL_Notification;
	};
}] call compile_Global;

["A3FL_JobFarming_InPlantation",
{
	params [["_position",[0,0,0],[[]],3]];
    private _return = 0;
    {
        if ((_position distance _x#1) <= 150) exitWith {
            _return = _x;
        };
    } forEach Server_Plantations;
    _return;
}] call compile_Global;
