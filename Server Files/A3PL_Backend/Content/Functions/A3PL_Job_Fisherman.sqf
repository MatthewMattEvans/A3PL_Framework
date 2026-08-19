/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_JobFisherman_DeployNet",
{
	private ["_overwater","_a"];
	if (!((vehicle player) isEqualTo player)) exitwith {[("STR_A3PL_Job_Fisherman_ErrorInCar" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_overwater = !(position player isFlatEmpty  [-1, -1, -1, -1, 2, false] isEqualTo []);
	if (!(_overwater)) exitwith {[("STR_A3PL_Job_Fisherman_ErrorNotInWater" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_newArray = [];
	{
		if(!isNull _x) then {_newArray pushBack _x;};
	} forEach A3PL_FishingBuoy_Local;
	A3PL_FishingBuoy_Local = _newArray;
	if(count A3PL_FishingBuoy_Local >= Fishing_Max_Net_Deployed) exitWith {[format[("STR_A3PL_Job_Fisherman_NetsDeployed" call A3PL_Localize),Fishing_Max_Net_Deployed],Color_Red] call A3PL_Notification;};
	if(!(call A3PL_Player_AntiSpam)) exitWith {};

	A3PL_FishingBuoy_Local pushBack player_objIntersect;
	[player,player_objIntersect] remoteExec ["Server_JobFisherman_DeployNet", 2];
}] call compile_Global;

["A3PL_JobFisherman_RetrieveNet",
{
	private ["_fishes","_buoy"];
	params[["_buoy",objNull,[objNull]]];

	if (isNull _buoy) exitwith {};

	_fishstate = _buoy getVariable ["fishstate",-1];
	if (_fishstate < 0) exitwith {
		[("STR_A3PL_Job_Fisherman_YouCantTakeThisNet" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};

	if (_fishstate < 50) exitwith {
		_message = format[("STR_A3PL_Job_Fisherman_NetNotFull" call A3PL_Localize),(_fishstate * 2),"%"];
		[_message,Color_Red] call A3PL_Notification;
	};

	if(_buoy getVariable ["used",false]) exitWith {
		[("STR_A3PL_Job_Fisherman_BuoyUsed" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};

	if(!(call A3PL_Player_AntiSpam)) exitWith {};

	_buoy setVariable ["used",true,true];
	[player,_buoy] remoteExec ["Server_JobFisherman_GrabNet",2];
}] call compile_Global;

["A3PL_JobFisherman_DeployNetSuccess",
{
	[4] call A3PL_JobFisherman_DeployNetResponse;
}] call compile_Global;

["A3PL_JobFisherman_DeployNetResponse",
{
	private _r = param [0,1];
	switch _r do
	{
		case 0: {[("STR_A3PL_Job_Fisherman_NoBucket" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		case 1: {[("STR_A3PL_Job_Fisherman_ErrorRetrievingNet" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		case 2: {[("STR_A3PL_Job_Fisherman_NoNet" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		case 3: {[("STR_A3PL_Job_Fisherman_TakedNet1" call A3PL_Localize),Color_Green] call A3PL_Notification;};
		case 4: {[("STR_A3PL_Job_Fisherman_YouDeployedNet" call A3PL_Localize),Color_Green] call A3PL_Notification;};
		case 5: {[("STR_A3PL_Job_Fisherman_TakedNet2" call A3PL_Localize),Color_Green] call A3PL_Notification;};
		case 6: {[("STR_A3PL_Job_Fisherman_TakedNet3" call A3PL_Localize),Color_Green] call A3PL_Notification;};
		case 7: {[("STR_A3PL_Job_Fisherman_TakedNet4" call A3PL_Localize),Color_Green] call A3PL_Notification;};
		case 8: {[("STR_A3PL_Job_Fisherman_TakedNet5" call A3PL_Localize),Color_Green] call A3PL_Notification;};
		case 9: {[("STR_A3PL_Job_Fisherman_TakedNet6" call A3PL_Localize),Color_Green] call A3PL_Notification;};
	};
}] call compile_Global;

["A3PL_JobFisherman_Bait",
{
	private ["_buoy","_bait"];
	_buoy = param [0,objNull];
	_bait = "none";

	if (!(["mullet",1] call A3PL_Inventory_Has)) exitwith {[("STR_A3PL_Job_Fisherman_NoMullet" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	switch (true) do
	{
		case ((player inArea "A3PL_Marker_Fish3") OR (player inArea "A3PL_Marker_Fish6") OR (player inArea "A3PL_Marker_Fish7")): {_bait = "shark"};
		case (player inArea "A3PL_Marker_Fish5"): {_bait = "turtle"};
	};

	if (_bait == "none") exitwith {[("STR_A3PL_Job_Fisherman_BaitCantBeUsed" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if ((_buoy getVariable ["bait","none"]) == "none") then
	{
		["mullet",-1] call A3PL_Inventory_Add;
		_buoy setVariable ["bait",_bait,true];
		[("STR_A3PL_Job_Fisherman_BaitThisNet" call A3PL_Localize),Color_Green] call A3PL_Notification;
	} else
	{
		[("STR_A3PL_Job_Fisherman_AlreadyBait" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};
}] call compile_Global;
