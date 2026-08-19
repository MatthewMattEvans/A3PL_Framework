/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
#define FACTIONSLIST [[("STR_Common_Job_Unemployed" call A3PL_Localize),"citizen",("STR_Common_Job_Unemployed" call A3PL_Localize)],[("STR_Common_FISD" call A3PL_Localize),("STR_Common_FISD" call A3PL_Localize),("STR_Common_FISD" call A3PL_Localize)],[("STR_Common_FIFR" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize)],[("STR_Common_DOJ" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize)],[("STR_Common_GOV" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)],["FBI (DEV)","fbi","fbi"],[("STR_Common_Company" call A3PL_Localize),"citizen",("STR_Common_Company" call A3PL_Localize)]]
#define TAGSLIST [["Tag Civil",["#B5B5B5","#ed7202","\A3PL_Common\icons\citizen.paa"]],["Tag Exécutif",["#B5B5B5","#8410ff","\A3PL_Common\icons\executive.paa"]],["Tag Superviseur Exécutif",["#B5B5B5","#5ab2ff","\A3PL_Common\icons\exec_supervisor.paa"]],["Tag Développeur",["#B5B5B5","#FFFFFF","\A3PL_Common\icons\creator.paa"]],["Tag Chef",["#B5B5B5","#2f9baa","\A3PL_Common\icons\chief.paa"]],["Tag Lead Chef",["#B5B5B5","#0567a4","\A3PL_Common\icons\leadchief.paa"]],["Tag Sous-Directeur",["#B5B5B5","#ff6d29","\A3PL_Common\icons\subdirector.paa"]],["Tag Directeur",["#B5B5B5","#cece08","\A3PL_Common\icons\director.paa"]]]
#define ADMIN_OBJECTS [["Business Sign","Land_A3PL_BusinessSign"],["Estate Sign","Land_A3PL_EstateSign"],["Estate Sign (Rented)","Land_A3PL_EstateSignRented"],["Fire Hydrant","Land_A3PL_FireHydrant"],["Portable Light","Land_PortableLight_double_F"],["Pipes","Land_Pipes_large_F"],["Tribune","Land_Tribune_F"],["Ramp","Land_RampConcrete_F"],["Crash Barrier","Land_Crash_barrier_F"],["Stairs","Land_GH_Stairs_F"],["Road Cone","RoadCone_L_F"],["Road Barrier","RoadBarrier_F"],["Crane","Land_Crane_F"],["Bunker","Land_BagBunker_Small_F"],["Finish Gate","Land_FinishGate_01_wide_F"],["Podium","Land_WinnersPodium_01_F"],["Concrete Block","BlockConcrete_F"],["Dirt Hump","Dirthump_3_F"],["Target","TargetBootcampHuman_F"],["Amphitheater","Land_Amphitheater_F"],["Garbage","Land_GarbageBags_F"],["Tyre Barrier","TyreBarrier_01_black_F"],["Tyre Barrier 6x","Land_TyreBarrier_01_line_x6_F"],["White Flag","Flag_White_F"],["Green Flag","Flag_Green_F"],["Red Flag","Flag_Red_F"],["Blue Flag","Flag_Blue_F"],["Party Tent","Land_PartyTent_01_F"],["Body Bag","Land_Bodybag_01_white_F"],["Dueling Target","Land_Target_Dueling_01_F"],["Large Carport","Land_Shed_Big_F"],["Small StartFinish Gate","Land_FinishGate_01_narrow_F"],["Large StartFinish Gate","Land_FinishGate_01_wide_F"],["Pipes","Land_Pipes_small_F"],["Solar Panel","Land_SolarPanel_3_F"],["Sandbag Fence","Land_BagFence_Long_F"],["Sandbag Round","Land_BagFence_Round_F"],["Sandbag Short Fence","Land_BagFence_Short_F"],["Buoy","Land_BuoyBig_F"],["Speakers","Land_Loudspeakers_F"],["Bench 1","Land_Bench_01_F"],["Bench 2","Land_Bench_02_F"],["Plastic Table","Land_TablePlastic_01_F"],["Small Road Barrier","RoadBarrier_small_F"],["Small Tape Sign","TapeSign_F"],["Tiny Right Arrow Sign","ArrowMarker_R_F"],["Tiny Left Arrow Sign","ArrowMarker_L_F"],["Short Left Arrow Sign","ArrowDesk_L_F"],["Short Right Arrow Sign","ArrowDesk_R_F"],["Small Plastic Barrier","Land_PlasticBarrier_01_line_x2_F"],["Tiny Plastic Barrier","PlasticBarrier_01_red_F"],["Small Gas Tank","Land_GasTank_01_blue_F"],["Tall Skinny Gas Tank","Land_GasTank_02_F"],["Cube Cargo Container","Land_Cargo10_red_F"],["Large Containment Area","ContainmentArea_02_sand_f"],["Wooden Crate Bench","Land_WoodenCounter_01_F"],["Cinder Blocks","Land_WoodenPlanks_01_F"],["Stack of Wooden Planks","Land_WoodenPlanks_01_F"],["No Entry Military Sign","Land_SignM_WarningMilitaryArea_english_F"],["Covered Patio","Land_i_Addon_03_V1_F"],["Small SandBag Bunker","Land_BagBunker_Small_F"],["Sandbag Barrier","Land_BagFence_Long_F"],["Hesco Barrier","Land_HBarrier_3_F"],["Hesco Corridor","Land_HBarrierWall_corridor_F"],["Hesco Corner","Land_HBarrierWall_corner_F"],["Hesco Tall Barrier","Land_HBarrierWall4_F"],["Wooden Obstacle Bridge","Land_Obstacle_Bridge_F"],["Wooden Wall","Land_Shoot_House_Wall_Long_Stand_F"],["Wooden Tunnel","Land_Shoot_House_Tunnel_Stand_F"],["Short Concrete Barrier","Land_CncBarrier_stripes_F"],["Short Concrete Barrier 2","Land_Concrete_SmallWall_4m_F"],["Fire Escape Stairs","Land_FireEscape_01_tall_F"],["Control Tower","Land_Airport_01_controlTower_F"],["Pallet of Bricks","Land_Bricks_V1_F"],["Broken Pallet of Bricks","Land_Bricks_V2_F"],["Large Scaffolding","Land_Scaffolding_F"],["Hesco Tower","Land_HBarrierTower_F"]]
#define CALLPRESETS [["Spawn dans l'océan","Spawn dans l'océan"], ["Demande de remboursement","A effectué un remboursement"], ["Problème véhicule","A corrigé un problème de garage"], ["Cas général","A corrigé un problème de retards"], ["Garage cassé","A corrigé un garage cassé"]]

["A3PL_Admin_Check", {
	pVar_AdminMenuGranted = false;
	pVar_AdminTwitter = false;
	pVar_MapTeleportReady = false;
	pVar_MapPlayerMarkersOn = false;
	pVar_MapVehicleMarkersOn = false;
	pVar_RessourcesMarkersOn = false;
	pVar_FastAnimationOn = false;

	pVar_AdminLevel = player getVariable ["dbVar_AdminLevel",0];
	pVar_AdminPerms = player getVariable ["dbVar_AdminPerms",[]];
	player setVariable ["dbVar_AdminPerms",nil,true];

	if (pVar_AdminLevel isEqualTo 0) exitwith {};
	if (pVar_AdminLevel isNotEqualTo 4) then {[player] remoteExec ["Server_Log_ClockIn",2];};
	pVar_CursorTargetEnabled = false;
	pVar_AdminTwitter = true;
	pVar_AdminMenuGranted = true;
	showChat false;
}] call compile_Global;

["A3PL_Admin_Open", {
	disableSerialization;
	if(isNull (findDisplay 98)) exitWith {
		createDialog "Dialog_ExecutiveMenu";
		private _display = findDisplay 98;
		_display call A3PL_Dialog_Localize;

		private _control = _display displayCtrl 1500;
		A3PL_Admin_PlayerList = [];
		{
			private _color = if (_x getVariable ["adminWatch",false]) then {[1,0,0,1]} else {[_x] call A3PL_Admin_Color;};
			private _name = _x getVariable["name",name _x];
			lbAdd [1500, format ["%1",_name]];
			lbSetColor [1500,_forEachIndex,_color];
			A3PL_Admin_PlayerList pushBack _x;
		} foreach allPlayers;
		_control ctrlAddEventHandler ["LBSelChanged","call A3PL_Admin_PlayerInfoList;"];
		_control lbSetCurSel count(A3PL_Admin_PlayerList)-1;

		_control = _display displayCtrl 1400;
		_control ctrlAddEventHandler ["KeyUp",{call A3PL_Admin_SearchPlayerList;}];
		call A3PL_Admin_PlayerInfoList;

		_control = _display displayCtrl 2100;
		private ["_i"];
		{
			_i = lbAdd [2100,_x];
			lbSetValue [2100,_i,1];
		} foreach ["Objects", "AdminVehicles"];
		{
			_i = lbAdd [2100, (_x#0) call A3PL_LocalizeConfig];
			lbSetValue [2100,_i,0];
			lbSetData [2100,_i,_x#0];
		} foreach Config_Factories;
		{
			_i = lbAdd [2100,_x];
			lbSetValue [2100,_i,2];
		} foreach ["Shop_Clothing", "Shop_Barber", "Shop_Furniture", "Shop_Furniture2","Shop_Perk_Furniture","Shop_Perk_ThingsPerk","Shop_Halloween","Shop_Christmas"];

		_control ctrlAddEventHandler ["lbSelChanged",{call A3PL_Admin_FillFactoryList;}];
		_control = _display displayCtrl 1401;
		_control ctrlAddEventHandler ["KeyUp", {call A3PL_Admin_SearchFactoryList;}];

		private _inventories = [("STR_A3PL_Admin_Factory_PlayerInventory" call A3PL_Localize),("STR_Common_FactoryName_Chimical" call A3PL_Localize),("STR_Common_FactoryName_Steel" call A3PL_Localize),("STR_Common_FactoryName_Petrol" call A3PL_Localize),("STR_Common_FactoryName_Goods" call A3PL_Localize),("STR_Common_FactoryName_Foods" call A3PL_Localize),("STR_Common_FactoryName_Vehicles" call A3PL_Localize),("STR_Common_FactoryName_Boats" call A3PL_Localize),("STR_Common_FactoryName_Aircrafts" call A3PL_Localize),"Usine Vetements",("STR_Common_FactoryName_IllegalClothings" call A3PL_Localize),"Usine Vetements Entreprises","Usine Vestes","Usine Chapeaux","Usine Lunettes",("STR_Common_FactoryName_LegalWeapons" call A3PL_Localize),("STR_Common_FactoryName_IllegalWeapons" call A3PL_Localize)];
		{lbAdd [2101,_x];} foreach _inventories;
		(_display displayCtrl 2101) ctrlAddEventHandler ["lbSelChanged","call A3PL_Admin_PlayerInventoryFill;"];

		if("Faction" IN pVar_AdminPerms) then {
			{lbAdd [2103, _x#0];} foreach FACTIONSLIST;
			(_display displayCtrl 2103) ctrlAddEventHandler ["lbSelChanged","call A3PL_Admin_SetFaction;"];
		};

		private _control = _display displayCtrl 1504;
		private _fullList = [
			[("STR_A3PL_Admin_Perm_Twitter" call A3PL_Localize),!pVar_AdminTwitter],
			[("STR_A3PL_Admin_Perm_FixGarage" call A3PL_Localize),false],
			[("STR_A3PL_Admin_Perm_CreateFire" call A3PL_Localize),false],
			[("STR_A3PL_Admin_Perm_PauseFire" call A3PL_Localize),!Server_FireLooping],
			[("STR_A3PL_Admin_Perm_DeletFire" call A3PL_Localize),false],
			[("STR_A3PL_Admin_Perm_FastAnimations" call A3PL_Localize),pVar_FastAnimationOn],
			[("STR_A3PL_Admin_Perm_SelfFood" call A3PL_Localize),false],
			[("STR_A3PL_Admin_Perm_VehiclesMarkers" call A3PL_Localize),pVar_MapVehicleMarkersOn],
			[("STR_A3PL_Admin_Perm_PlayersMarkers" call A3PL_Localize),pVar_MapPlayerMarkersOn],
			[("STR_A3PL_Admin_Perm_DoubleEXP" call A3PL_Localize),(A3PL_Event_DblXP) isEqualTo 2],
			[("STR_A3PL_Admin_Perm_DoubleGathering" call A3PL_Localize),(A3PL_Event_DblHarvest) isEqualTo 2],
			[("STR_A3PL_Admin_Perm_Salary15" call A3PL_Localize),(A3PL_Event_Paycheck) isEqualTo 1.5],
			[("STR_A3PL_Admin_Perm_Criminal15" call A3PL_Localize),(A3PL_Event_CrimePayout) isEqualTo 1.5],
			[("STR_A3PL_Admin_Perm_PlayersStats" call A3PL_Localize),false],
			[("STR_A3PL_Admin_Perm_ResourcesMarkers" call A3PL_Localize), pVar_RessourcesMarkersOn],
			[("STR_A3PL_Admin_Perm_Camera" call A3PL_Localize),false],
			[("STR_A3PL_Admin_Perm_Invisible" call A3PL_Localize),(player getVariable ["admin_invisible",false])],
			[("STR_A3PL_Admin_Perm_Lightning" call A3PL_Localize),false],
			[("STR_A3PL_Admin_Perm_Tornado" call A3PL_Localize),false],
			[("STR_A3PL_Admin_Perm_VirtualArsenal" call A3PL_Localize),false]
		];

		dVar_AdminToolsList = [];
		{
			private _toolName = _x#0;
			private _toolColor = _x#1;
			if(_toolName IN pVar_AdminPerms) then {
				dVar_AdminToolsList pushBack _x;
				lbAdd [1504,_toolName];
				if (_x#1) then {
					lbSetColor [1504, _forEachIndex, [0.90588235294,0.49411764705,0.14901960784,1]];
				};
			};
		} foreach _fullList;
		_control ctrlAddEventHandler ["LBDblClick","call A3PL_Admin_SelectedTool;"];

		_control = _display displayCtrl 1015;
		if (player getVariable ["pVar_RedNameOn",false]) then {_control ctrlSetTextColor [0.90588235294,0.49411764705,0.14901960784,1];};
		_control = _display displayCtrl 1016;
		if (pVar_MapTeleportReady) then {_control ctrlSetTextColor [0.90588235294,0.49411764705,0.14901960784,1];};
		_control = _display displayCtrl 1017;
		if (player getVariable ["pVar_NoclipOn",false]) then {_control ctrlSetTextColor [0.90588235294,0.49411764705,0.14901960784,1];};
	};
}] call compile_Global;

["A3PL_Admin_Title", {
	params[["_player",objNull,[objNull]]];
	switch(_player getVariable["dbVar_AdminLevel",0]) do {
		case 0: {""};
		case 1: {("STR_A3PL_Admin_Title_ExecutiveTraining" call A3PL_Localize)};
		case 2: {("STR_A3PL_Admin_Title_Executive" call A3PL_Localize)};
		case 3: {("STR_A3PL_Admin_Title_ExecutiveSupervisor" call A3PL_Localize);};
		case 4: {("STR_A3PL_Admin_Title_Developer" call A3PL_Localize)};
		case 5: {("STR_A3PL_Admin_Title_Chief" call A3PL_Localize)};
		case 6: {("STR_A3PL_Admin_Title_LeadChief" call A3PL_Localize)};
		case 7: {("STR_A3PL_Admin_Title_SubDirector" call A3PL_Localize)};
		case 8: {("STR_A3PL_Admin_Title_Director" call A3PL_Localize)};
		case 9: {("STR_A3PL_Admin_Title_NBI" call A3PL_Localize)};
	};
}] call compile_Global;

["A3PL_Admin_Color", {
	params [
		["_player",objNull,[objNull]],
		["_hex",false,[false]]
	];

	private _color = switch(_player getVariable["dbVar_AdminLevel",0]) do {
		default {[[1,1,1,1],"#FFFFFF"]};
		case 1: {[[1,0.898,0.6,1],"#FFE599"]};
		case 2: {[[0.160784,0,0.541177,1],"#9C27AF"]};
		case 3: {[[0.224,0.588,0.722,1],"#3996b8"]};
		case 5: {[[0.118,0.569,1,1],"#1e91ff"]};
		case 6: {[[0.122,0.282,0.459,1],"#1f4875"]};
		case 7: {[[0.98,0.549,0.043,1],"#fa8c0b"]};
		case 8: {[[0.98,0.816,0.043,1],"#fad00b"]};
		case 9: {[[0.831,0.686,0.216,1],"#D4AF37"]};
	};
	if(_hex) then {_color#1} else {_color#0};
}] call compile_Global;

["A3PL_Admin_PlayerInfoList", {
	private _display = findDisplay 98;
	private _selectedIndex = lbCurSel 1500;
	private _control = _display displayCtrl 1503;
	private _selectedPlayer = (A3PL_Admin_PlayerList#_selectedIndex);
	private _playerInfoArray = [
		[("STR_A3PL_Admin_PlayerInfo_ID" call A3PL_Localize), [_selectedPlayer getVariable["db_id",-1],3]],
		[("STR_A3PL_Admin_PlayerInfo_Teamspeak" call A3PL_Localize), ["A3PL_CurrentNameTFAR",0]],
		[("STR_A3PL_Admin_PlayerInfo_Name" call A3PL_Localize), ["name",0]],
		[("STR_A3PL_Admin_PlayerInfo_A3" call A3PL_Localize), [name _selectedPlayer,3]],
		[("STR_A3PL_Admin_PlayerInfo_Cash" call A3PL_Localize), ["Player_Cash",1]],
		[("STR_A3PL_Admin_PlayerInfo_Bank" call A3PL_Localize), ["Player_Bank",1]],
		[("STR_A3PL_Admin_PlayerInfo_SA" call A3PL_Localize), ["Player_SavingsAccount",1]],
		[("STR_A3PL_Admin_PlayerInfo_COD" call A3PL_Localize), ["Player_CertificateOfDeposit",1]],
		[("STR_A3PL_Admin_PlayerInfo_CBActive" call A3PL_Localize), ["Player_ActiveCB",1]],
		[("STR_A3PL_Admin_PlayerInfo_Faction" call A3PL_Localize), ["faction",0]],
		[("STR_A3PL_Admin_PlayerInfo_Job" call A3PL_Localize), ["job",0]],
		[("STR_A3PL_Admin_PlayerInfo_Alive" call A3PL_Localize), ["A3PL_Medical_Alive",6]],
		[("STR_A3PL_Admin_PlayerInfo_Blood" call A3PL_Localize), ["A3PL_Medical_Blood",0]],
		[("STR_A3PL_Admin_PlayerInfo_Wounds" call A3PL_Localize), ["A3PL_Wounds",4]],
		[("STR_A3PL_Admin_PlayerInfo_Handcuffed" call A3PL_Localize), ["Cuffed",2]],
		[("STR_A3PL_Admin_PlayerInfo_Zipped" call A3PL_Localize), ["Zipped",2]],
		[("STR_A3PL_Admin_PlayerInfo_Prison" call A3PL_Localize), ["Jailed",5]],
		[("STR_A3PL_Admin_PlayerInfo_SportLevel" call A3PL_Localize), [_selectedPlayer getVariable["Player_SportLevel",0],3]],
		[("STR_A3PL_Admin_PlayerInfo_Speed" call A3PL_Localize), [_selectedPlayer getVariable["Player_SportSpeed",1],3]],
		[("STR_A3PL_Admin_PlayerInfo_Stability" call A3PL_Localize), [_selectedPlayer getVariable["Player_ScopeStability",1],3]],
		[("STR_A3PL_Admin_PlayerInfo_Stamina" call A3PL_Localize), [getStamina _selectedPlayer,3]]
	];
	lbClear 1503;
	{
		private _text = _x#0;
		private _data = _x#1;
		switch(_data#1) do {
			case 0: {lbAdd [1503, format ["%1 %2", _text, _selectedPlayer getVariable [_data#0,("STR_Common_Undefined" call A3PL_Localize)]]];};
			case 1: {lbAdd [1503, format ["%1 %2", _text,(_selectedPlayer getVariable [_data#0,-1]) call CBA_fnc_formatNumber]];};
			case 2: {
				if((_selectedPlayer getVariable [_data#0,false])) then {
					lbAdd [1503, format ["%1 %2", _text, ("STR_Common_Yes" call A3PL_Localize)]];
				} else {
					lbAdd [1503, format ["%1 %2", _text, ("STR_Common_No" call A3PL_Localize)]];
				};
			};
			case 3: {lbAdd [1503, format ["%1 %2", _text, _data#0]];};
			case 4: {
				if((_selectedPlayer getVariable [_data#0,[]]) isEqualTo []) then {
					lbAdd [1503, format ["%1 %2", _text, ("STR_Common_No" call A3PL_Localize)]];
				} else {
					lbAdd [1503, format ["%1 %2", _text, ("STR_Common_Yes" call A3PL_Localize)]];
				};
			};
			case 5: {
				if (_selectedPlayer getVariable["jailed",false]) then {
					lbAdd [1503, format ["%1 %2 %3", _text, _selectedPlayer getVariable["jailtime",0], ("STR_Common_Minuts" call A3PL_Localize)]];
				} else {
					lbAdd [1503, format ["%1 %2", _text, ("STR_Common_No" call A3PL_Localize)]];
				};
			};
			case 6: {
				if (_selectedPlayer getVariable["A3PL_Medical_Alive",true]) then {
					lbAdd [1503, format ["%1 %2", _text, ("STR_Common_Yes" call A3PL_Localize)]];
				} else {
					lbAdd [1503, format ["%1 %2 %3", _text, _selectedPlayer getVariable["TimeRemaining",600], ("STR_Common_Seconds" call A3PL_Localize)]];
				};
			};
		};
	} forEach _playerInfoArray;
}] call compile_Global;

["A3PL_Admin_PlayerInventoryFill", {
	private _selectedPlayer = (A3PL_Admin_PlayerList#(lbCurSel 1500));
	private _selectedInventory = lbText [2101,lbCurSel 2101];
	lbClear 1502;
	if (_selectedInventory isEqualTo ("STR_A3PL_Admin_Factory_PlayerInventory" call A3PL_Localize)) then {
		{
			private _i = lbAdd [1502,format ["%1 (%2)",[_x#0,"name"] call A3PL_Config_GetItem,(_x#1)]];
			lbSetData [1502, _i, _x#0];
			lbSetValue [1502, _i, _x#1];
		} forEach (_selectedPlayer getVariable ["player_inventory",[]]);
	} else {
		{
			private _i = lbAdd [1502,format ["%1 (%2)",_x#0,_x#1]];
			lbSetData [1502, _i, _x#0];
			lbSetValue [1502, _i, _x#1];
		} forEach ([_selectedInventory,_selectedPlayer] call A3PL_Factory_GetStorage);
	};
}] call compile_Global;

["A3PL_Admin_SetTwitterTag", {
	private _selectedTag = lbCurSel 2102;
	player setVariable["twitterTag",(TAGSLIST#_selectedTag)#1, true];
	[player,"TwitterTagSet", format["Selected: %1", (TAGSLIST#_selectedTag)#0]] remoteExec ["Server_AdminLoginsert", 2];
}] call compile_Global;

["A3PL_Admin_SetFaction", {
	if !("Faction" IN pVar_AdminPerms) exitWith {[("STR_A3PL_Admin_YouDontHavePermission" call A3PL_Localize)] call A3PL_Notification;};
	private _selectedTag = lbCurSel 2103;
	private _target = lbCurSel 1500;
	if(_target < 0) exitWith {};
	_target = (A3PL_Admin_PlayerList#_target);
	private _curJob = _target getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
	if (_curJob IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) then {[(_target getVariable ["character_id",""])] remoteExec ["Server_Log_Faction_ClockOut",2];};
	_target setVariable["faction",(FACTIONSLIST#_selectedTag)#1,true];
	_target setVariable["job",(FACTIONSLIST#_selectedTag)#2,true];
	if((FACTIONSLIST#_selectedTag)#2 isNotEqualTo ("STR_Common_Job_Unemployed" call A3PL_Localize)) then {[(_target getVariable ["character_id",""]),(FACTIONSLIST#_selectedTag)#2] remoteExec ["Server_Log_Faction_ClockIn",2];};
	//call A3PL_Player_SetMarkers;
}] call compile_Global;

["A3PL_Admin_SelectedTool", {
	private _selectedIndex = lbCurSel 1504;
	switch (dVar_AdminToolsList#_selectedIndex#0) do {
		case ("STR_A3PL_Admin_Perm_Twitter" call A3PL_Localize): {call A3PL_Admin_TwitterToggle};
		case ("STR_A3PL_Admin_Perm_FixGarage" call A3PL_Localize): {call A3PL_Admin_FixGarage};
		case ("STR_A3PL_Admin_Perm_CreateFire" call A3PL_Localize): {call A3PL_Admin_CreateFire};
		case ("STR_A3PL_Admin_Perm_PauseFire" call A3PL_Localize): {call A3PL_Admin_PauseFire};
		case ("STR_A3PL_Admin_Perm_DeletFire" call A3PL_Localize): {call A3PL_Admin_RemoveFire};
		case ("STR_A3PL_Admin_Perm_FastAnimations" call A3PL_Localize): {call A3PL_Admin_FastAnimation};
		case ("STR_A3PL_Admin_Perm_SelfFood" call A3PL_Localize): {call A3PL_Admin_SelfFeed};
		case ("STR_A3PL_Admin_Perm_VehiclesMarkers" call A3PL_Localize): {call A3PL_Admin_VehicleMarkers};

		case ("STR_A3PL_Admin_Perm_PlayersMarkers" call A3PL_Localize): {call A3PL_Admin_MapMarkers;};
		case ("STR_A3PL_Admin_Perm_DoubleEXP" call A3PL_Localize): {["A3PL_Event_DblXP"] call A3FL_Admin_ToggleEvent;};
		case ("STR_A3PL_Admin_Perm_DoubleGathering" call A3PL_Localize): {["A3PL_Event_DblHarvest"] call A3FL_Admin_ToggleEvent;};
		case ("STR_A3PL_Admin_Perm_Salary15" call A3PL_Localize): {["A3PL_Event_Paycheck"] call A3FL_Admin_ToggleEvent;};
		case ("STR_A3PL_Admin_Perm_Criminal15" call A3PL_Localize): {["A3PL_Event_CrimePayout"] call A3FL_Admin_ToggleEvent;};

		case ("STR_A3PL_Admin_Perm_PlayersStats" call A3PL_Localize): {call A3PL_Admin_ViewStats;};
		case ("STR_A3PL_Admin_Perm_ResourcesMarkers" call A3PL_Localize): {call A3PL_Admin_RessourcesMarkers;};
		case ("STR_A3PL_Admin_Perm_Camera" call A3PL_Localize): {closeDialog 0;["Init"] call BIS_fnc_camera;};
		case ("STR_A3PL_Admin_Perm_Invisible" call A3PL_Localize): {call A3PL_Admin_Invisible};
		case ("STR_A3PL_Admin_Perm_Lightning" call A3PL_Localize): {call A3PL_Admin_Lightning;};
		case ("STR_A3PL_Admin_Perm_Tornado" call A3PL_Localize): {[] spawn A3PL_Admin_ExtremeWeather;};
		case ("STR_A3PL_Admin_Perm_VirtualArsenal" call A3PL_Localize): {closeDialog 0;["Open",true] spawn BIS_fnc_arsenal;};
	};
}] call compile_Global;

["A3PL_Admin_ExtremeWeather", {
	if(a3fl_tornado isEqualTo "start") exitWith {
		[("STR_A3PL_Admin_UnactivateTornado" call A3PL_Localize),Color_Yellow] call A3PL_Notification;
		a3fl_tornado = "stop";
		publicVariable "a3fl_tornado";
	};
	private _action = [("STR_A3PL_Admin_ActiveTornado_Confirm" call A3PL_Localize)] call A3PL_Lib_ConfirmationDialog;
	if (!isNil "_action" && {!_action}) exitWith {};
	[("STR_A3PL_Admin_ActiveTornado" call A3PL_Localize),Color_Yellow] call A3PL_Notification;
	[] remoteExec ["A3FL_Weather_Tornado",2];
}] call compile_Global;

["A3PL_Admin_SaveServer", {
	if ((pVar_AdminLevel < 7) && !(getPlayerUID player IN ["76561198170351694","76561198147147468"])) exitwith {[("STR_A3PL_Admin_YouDontHavePermission" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	[] remoteExec ["Server_ShopStock_Save",2];
	["SAVE STOCK OK 1/8",Color_Yellow] call A3PL_Notification;
	[] remoteExec ["Server_Locker_Save",2];
	["SAVE LOCKERS OK 2/8",Color_Yellow] call A3PL_Notification;
	[] remoteExec ["Server_Police_SeizureSave",2];
	["SAVE SEIZURES OK 3/8",Color_Yellow] call A3PL_Notification;
	[] remoteExec ["Server_Fuel_Save",2];
	["SAVE GAS STATIONS OK 4/8",Color_Yellow] call A3PL_Notification;
    [false] remoteExec ["Server_Vehicle_Save",2];
	["SAVE VEHICLES OK 5/8",Color_Yellow] call A3PL_Notification;
	[false] remoteExec ["Server_Housing_SaveItems",2];
	["SAVE HOUSES OK 6/8",Color_Yellow] call A3PL_Notification;
	[false] remoteExec ["Server_Warehouses_SaveItems",2];
	["SAVE WAREHOUSES OK 7/8",Color_Yellow] call A3PL_Notification;
	[false] remoteExec ["Server_Crackhouses_SaveItems",2];
	["SAVE CRACKHOUSES OK 8/8",Color_Yellow] call A3PL_Notification;

	["SAVE FINISHED",Color_Yellow] call A3PL_Notification;
}] call compile_Global;

["A3PL_Admin_FixGarage", {
	private _target = player_objIntersect;
	_target setVariable ["inUse",false,true];
	if((typeOf _target) isEqualTo "Land_A3PL_storage") then {
		_target animateSource ["storagedoor",0];
	};
}] call compile_Global;

["A3PL_Admin_FillFactoryList", {
	private _display = findDisplay 98;
	private _control = _display displayCtrl 2100;
	private _curSel = lbCurSel _control;
	private _selectedFactoryText = _control lbText _curSel;
	private _selectedFactoryData = _control lbData _curSel;
	private _selectedFactory = if (_selectedFactoryData != "") then { _selectedFactoryData } else { _selectedFactoryText };
	private _selectedType = _control lbValue _curSel;
	private ["_i"];
	_control = _display displayCtrl 1501;
	lbClear _control;
	if (_selectedFactoryText isEqualTo "Objects" || _selectedFactoryText isEqualTo "AdminVehicles") then {
		if (_selectedFactoryText isEqualTo "AdminVehicles") exitWith {
			{
				private _first_X = _x;
				{

					private _class = format ["%1_%2",_first_X#0,_x];
					private _name = getText(configFile >> "CfgVehicles" >> _class >> "displayName");
					_i = lbAdd [1501,_name];
					lbSetData [1501,_i,_class];
				} foreach (_x#1);
			} forEach Config_Vehicles_Admin;
		};

		if (_selectedFactoryText isEqualTo "Objects") exitWith {
			{
				_i = lbAdd [1501,_x#0];
				lbSetData [1501,_i,_x#1];
			} forEach ADMIN_OBJECTS;
		};
	} else {
		if(_selectedType isEqualTo 0) then {
			{
				private _id = _x#0;
				private _itemClass = _x#1;
				private _itemType = _x#2;
				private _name = [_itemClass,_itemType,"name"] call A3PL_Factory_Inheritance;
				_i = lbAdd [1501,_name];
				lbSetData [1501,_i,_id];
			} forEach (["all",_selectedFactory] call A3PL_Config_GetFactory);
		} else {
			{
				private _itemType = _x select 0;
				private _itemClass = _x select 1;
				private _itemName = switch (_itemType) do
				{
					case ("item"):{[_itemClass,"name"] call A3PL_Config_GetItem;};
					case ("aitem"): { getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName");};
					case ("backpack"): { getText (configFile >> "CfgVehicles" >> _itemClass >> "displayName");};
					case ("uniform"): { getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName");};
					case ("vest"): { getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName");};
					case ("headgear"): { getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName");};
					case ("vehicle"): { getText (configFile >> "CfgVehicles" >> _itemClass >> "displayName");};
					case ("plane"): { getText (configFile >> "CfgVehicles" >> _itemClass >> "displayName");};
					case ("weapon"): { getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName");};
					case ("weaponPrimary"): { getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName");};
					case ("magazine"): { getText (configFile >> "CfgMagazines" >> _itemClass >> "displayName");};
					case ("goggles"): { getText (configFile >> "CfgGlasses" >> _itemClass >> "displayName");};
					case ("waitem"): { getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName");};
				};
				_i = lbAdd [1501,_itemName];
				lbSetData [1501,_i,_itemClass];
			} forEach ([_selectedFactory] call A3PL_Config_GetShop);
		};
	};
	_control ctrlAddEventHandler ["lbSelChanged",{_selectedAsset = lbData [1501,(lbCurSel 1501)];}];
}] call compile_Global;

["A3PL_Admin_CursorTarget", {
    ("Dialog_HUD_AdminCursor" call BIS_fnc_rscLayer) cutRsc ["Dialog_HUD_AdminCursor", "PLAIN"];
    (uiNamespace getVariable "Dialog_HUD_AdminCursor") call A3PL_Dialog_Localize;
    pVar_CursorTargetEnabled = true;
    ((uiNamespace getVariable "Dialog_HUD_AdminCursor") displayCtrl 2414) ctrlSetStructuredText (parseText format[("STR_A3PL_Admin_NumpadControl" call A3PL_Localize)]);

    while {pVar_CursorTargetEnabled} do {
        uiSleep 0.1;
        private _cursText = "N/A";
        if (!(isNull cursorTarget)) then {
            _cursText = typeOf cursorTarget;
        };
        if ((typeOf cursorObject) isEqualTo "C_man_w_worker_F") then {
            _cursText = cursorObject;
        };
        if (isPlayer cursorTarget) then {
            _cursText = (driver cursorTarget) getVariable ["name",""];
        };
		if (_cursText isEqualTo "") then {
			_cursText = "N/A";
		};
        ((uiNamespace getVariable "Dialog_HUD_AdminCursor") displayCtrl 1000) ctrlSetStructuredText (parseText format[("STR_A3PL_Admin_Cursor" call A3PL_Localize),(_cursText)]);
    };
    ("Dialog_HUD_AdminCursor" call BIS_fnc_rscLayer) cutFadeOut 1;
}] call compile_Global;

["A3PL_Admin_AttachTo", {
	params[["_veh",objNull,[objNull]]];
	if(isNull _veh) then {_veh = cursorObject;};
	if(isNull _veh) exitWith {};
	_veh attachTo [player];
	attachKeyDown =
	{
		private _key = (_this#0)#1;
		private _veh = [_this#1] call A3PL_Lib_vehStringToObj;
		private _VecNormal = [0,0,1];
		private _dir = _veh getVariable["AdminAttached_Dir",0];
		private _height = _veh getVariable["AdminAttached_Height",0];
		private _relPosition = player worldToModel ASLToAGL getPosASL _veh;
		private _return = false;
		switch _key do
		{
			case 201: {
				_height = _height + 1;
				_veh setVariable["AdminAttached_Height",_height];

				_return = true;
			};
			case 209: {
				_height = _height - 1;
				_veh setVariable["AdminAttached_Height",_height];
				_return = true;
			};
			case 199: {
				_dir = _dir + -4;
				if(_dir >= 360) then {_dir = _dir - 360;};
				if(_dir < 0) then {_dir = _dir + 360;};
				_veh setVariable["AdminAttached_Dir",_dir];
				_return = true;
			};
			case 207: {
				_dir = _dir + 4;
				if(_dir >= 360) then {_dir = _dir - 360;};
				if(_dir < 0) then {_dir = _dir + 360;};
				_veh setVariable["AdminAttached_Dir",_dir];
				_return = true;
			};
		};
		if(_return) then {
			_veh attachTo [player, [_relPosition#0,_relPosition#1,_height]];
			_VecDir = [-cos _dir, sin _dir, 0] vectorCrossProduct _VecNormal;
			_veh setVectorDirAndUp [_VecDir, _VecNormal];
		};
		_return;
	};
	waituntil {!isNull findDisplay 46};
	private _attachKeyDown = (findDisplay 46) DisplayAddEventHandler ["keydown",format["[_this,'%1'] call attachKeyDown",_veh]];
	waitUntil {!(_veh IN (attachedObjects player)) || (isNull _veh)};
	(findDisplay 46) displayremoveeventhandler ["keydown",_attachKeyDown];
}] call compile_Global;

["A3PL_Admin_SearchPlayerList", {
	private _display = findDisplay 98;
	private _text = ctrlText 1400;
	lbClear 1500;
	A3PL_Admin_PlayerList = [];
	{
		private _name = _x getVariable["name",name _x];
		private _color = if (_x getVariable ["adminWatch",false]) then {[1,0,0,1]} else {[_x] call A3PL_Admin_Color;};
		if ([_text, _name] call BIS_fnc_inString) then {
			lbAdd [1500, format ["%1",_name]];
			lbSetColor [1500,_forEachIndex,_color];
			A3PL_Admin_PlayerList pushBack _x;
		};
	} foreach allPlayers;
}] call compile_Global;

["A3PL_Admin_SearchFactoryList", {
	private _display = findDisplay 98;
	private _text = ctrlText 1401;
	private _control = _display displayCtrl 2100;
	private _curSel = lbCurSel _control;
	private _selectedFactoryText = _control lbText _curSel;
	private _selectedFactoryData = _control lbData _curSel;
	private _selectedFactory = if (_selectedFactoryData != "") then { _selectedFactoryData } else { _selectedFactoryText };
	private _selectedType = _control lbValue _curSel;
	private ["_name"];
	_control = _display displayCtrl 1501;
	lbClear _control;
	if (_selectedFactoryText isEqualTo "Objects") exitWith {
		{
			_name = _x#0;
			if ([_text, _name] call BIS_fnc_inString) then {
				private _i = lbAdd [1501,_name];
				lbSetData [1501,_i,(_x#1)];
			};
		} foreach ADMIN_OBJECTS;
	};
	if (_selectedFactoryText isEqualTo "AdminVehicles") exitWith {
		{
			private _first_X = _x;
			{
				private _class = format ["%1_%2",_first_X#0,_x];
				_name = getText(configFile >> "CfgVehicles" >> _class >> "displayName");
				if ([_text, _name] call BIS_fnc_inString) then {
					private _i = lbAdd [1501,_name];
					lbSetData [1501,_i,_class];
				};
			} foreach (_x#1);
		} foreach Config_Vehicles_Admin;
	};
	if(_selectedType isEqualTo 0) then {
		private _recipes = ["all",_selectedFactory] call A3PL_Config_GetFactory;
		{
			private _id = _x#0;
			private _itemClass = _x#1;
			private _itemType = _x#2;
			_name = [_itemClass,_itemType,"name"] call A3PL_Factory_Inheritance;
			if ([_text, _name] call BIS_fnc_inString) then {
				private _index = _control lbAdd _name;
				_control lbSetData [_index,_id];
			};
		} foreach _recipes;
	} else {
		{
			private _itemType = _x select 0;
			private _itemClass = _x select 1;
			private _itemName = switch (_itemType) do
			{
				case ("item"):{[_itemClass,"name"] call A3PL_Config_GetItem;};
				case ("aitem"): { getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName");};
				case ("backpack"): { getText (configFile >> "CfgVehicles" >> _itemClass >> "displayName");};
				case ("uniform"): { getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName");};
				case ("vest"): { getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName");};
				case ("headgear"): { getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName");};
				case ("vehicle"): { getText (configFile >> "CfgVehicles" >> _itemClass >> "displayName");};
				case ("plane"): { getText (configFile >> "CfgVehicles" >> _itemClass >> "displayName");};
				case ("weapon"): { getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName");};
				case ("weaponPrimary"): { getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName");};
				case ("magazine"): { getText (configFile >> "CfgMagazines" >> _itemClass >> "displayName");};
				case ("goggles"): { getText (configFile >> "CfgGlasses" >> _itemClass >> "displayName");};
				case ("waitem"): { getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName");};
			};
			if ([_text, _itemName] call BIS_fnc_inString) then {
				private _i = lbAdd [1501,_itemName];
				lbSetData [1501,_i,_itemClass];
			};
		} forEach ([_selectedFactory] call A3PL_Config_GetShop);
	};
}] call compile_Global;

["A3PL_Admin_AddToFactory", {
	private _display = findDisplay 98;
	private _curSel = lbCurSel 2100;
	private _selectedFactoryText = lbText [2100,_curSel];
	private _selectedFactoryData = lbData [2100,_curSel];
	private _selectedFactory = if (_selectedFactoryData != "") then { _selectedFactoryData } else { _selectedFactoryText };
	private _selectedType = lbValue [2100,_curSel];
	if(_selectedType isEqualTo 2) exitWith {};
	private _itemType = "";
	if (_selectedFactory isEqualTo "") exitwith {[("STR_A3PL_Admin_YouDoNotSelectedFactory" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_selectedFactory IN ["Admin Tools"]) exitwith {[("STR_A3PL_Admin_YouCantAddThisToThisFactory" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _selectedAsset = lbData [1501,(lbCurSel 1501)];
	if ((lbCurSel 1501) < 0) exitwith {[("STR_A3PL_Admin_YouDoNotSelectedAnything" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _selectedPlayer = A3PL_Admin_PlayerList#(lbCurSel 1500);
	private _control = _display displayCtrl 1403;
	private _amount = parseNumber (ctrlText _control);
	if (_amount < 1) exitwith {[("STR_Common_InvalidAmount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _isFactory = ((_selectedAsset splitString "_")#0) isEqualTo "f";
	if (_isFactory) then {_itemType = [_selectedAsset,_selectedFactory,"type"] call A3PL_Config_GetFactory;};
	if (_isFactory && (_itemType isEqualTo "item")) then {_selectedAsset = [_selectedAsset,_selectedFactory,"class"] call A3PL_Config_GetFactory;};
	[_selectedPlayer,_selectedFactory,[_selectedAsset,_amount],false] remoteExec ["Server_Factory_Add", 2];
	private _itemName = lbText [1501,(lbCurSel 1501)];
	[format[("STR_A3PL_Admin_YouAddedInTheFactory" call A3PL_Localize),_amount,_itemName,_selectedFactoryText,_selectedPlayer getVariable ["name",("STR_Common_Undefined" call A3PL_Localize)]],Color_Green] call A3PL_Notification;
	[player,"AddToFactory", format["Target: %1 | Item: %2 | Amount: %3 | From: %4", _selectedPlayer getVariable["name","unknown"], _selectedAsset, _amount, _selectedFactoryText]] remoteExec ["Server_AdminLoginsert", 2];
}] call compile_Global;

["A3PL_Admin_BypassTFAR", {
    private ["_display","_control","_type","_player","_recipe"];
    _display = findDisplay 98;

    if (pVar_AdminLevel < 3 && !(getPlayerUID player IN ["76561198170351694","76561198147147468"])) exitwith {[("STR_A3PL_Admin_YouDontHavePermission" call A3PL_Localize),Color_Red] call A3PL_Notification;};

    private _selectedPlayer = A3PL_Admin_PlayerList#(lbCurSel 1500);

    private _getbypass = _selectedPlayer getVariable ["A3PL_Bypass_TFAR",false];

    if !_getbypass then {
        _selectedPlayer setVariable ["A3PL_Bypass_TFAR",true,true];
        [format[("STR_A3PL_Admin_YouAuthorizePlayerToBypassTFAR" call A3PL_Localize),_selectedPlayer getVariable ["name",("STR_Common_Undefined" call A3PL_Localize)]],Color_Green] call A3PL_Notification;
        [format[("STR_A3PL_Admin_BypassTFARAuthorizedByStaff" call A3PL_Localize)],Color_Yellow] remoteExec ["A3PL_Notification", _selectedPlayer];
        [player,"BypassTFAR_On", format["Target: %1", _selectedPlayer getVariable["name","unknown"]]] remoteExec ["Server_AdminLoginsert", 2];
    } else {
        _selectedPlayer setVariable ["A3PL_Bypass_TFAR",false,true];
        [format[("STR_A3PL_Admin_UnauthorizeTFARBypass" call A3PL_Localize),_selectedPlayer getVariable ["name",("STR_Common_Unknown" call A3PL_Localize)]],Color_Orange] call A3PL_Notification;
        [format[("STR_A3PL_Admin_BypassTFARUnauthorizedByStaff" call A3PL_Localize)],Color_Red] remoteExec ["A3PL_Notification", _selectedPlayer];
        [player,"BypassTFAR_Off", format["Target: %1", _selectedPlayer getVariable["name","unknown"]]] remoteExec ["Server_AdminLoginsert", 2];
    };
}] call compile_Global;

["A3PL_Admin_AddToPlayer", {
	private ["_display","_control","_type","_player","_recipe"];
	_display = findDisplay 98;

	private _curSel = lbCurSel 2100;
	private _selectedFactoryText = lbText [2100,_curSel];
	private _selectedFactoryData = lbData [2100,_curSel];
	private _selectedFactory = if (_selectedFactoryData != "") then { _selectedFactoryData } else { _selectedFactoryText };
	private _selectedType = lbValue [2100,_curSel];
	if (_selectedFactoryText isEqualTo "") exitwith {[("STR_A3PL_Admin_NoFactorySelected" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _selectedAsset = lbData [1501,(lbCurSel 1501)];

	if ((lbCurSel 1501) < 0) exitwith {[("STR_A3PL_Admin_YouDoNotSelectedAnything" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _selectedPlayer = A3PL_Admin_PlayerList#(lbCurSel 1500);

	if (_selectedFactoryText isEqualTo "Objects") exitWith {
		private _obj = objNull;
		private _playerPos = getPos _selectedPlayer;
		if(_selectedAsset isEqualTo "Land_A3PL_EstateSignRented") then {
			_obj = createvehicle ["Land_A3PL_EstateSign",_playerPos, [], 0, "CAN_COLLIDE"];
			_obj setObjectTextureGlobal [0,"\A3PL_Objects\Street\estate_sign\house_rented_co.paa"];
		} else {
			_obj = createvehicle [_selectedAsset,_playerPos, [], 0, "CAN_COLLIDE"];
		};
		_obj setVariable["owner",("STR_Common_Vehicle_Plate_Federal" call A3PL_Localize),true];
		[player,"objects",[format ["Object Spawn: %1 AT %2",_selectedAsset,_playerPos]]] remoteExec ["Server_AdminLoginsert", 2];
	};

	if (_selectedFactoryText isEqualTo "AdminVehicles") exitWith {
		private _pos = getPosATL player;
		private _dir = getDir player;
		private _spawnPos = [(_pos#0 + (sin _dir * 3)), (_pos#1 + (cos _dir * 3)), _pos#2];
		[_selectedAsset,_spawnPos,("STR_Common_Vehicle_Plate_Federal" call A3PL_Localize),player] remoteExec ["Server_Vehicle_Spawn",2];
		[player,"vehicles",[format ["VehicleSpawn: %1 AT %2",_selectedAsset,_spawnPos]]] remoteExec ["Server_AdminLoginsert", 2];
	};

	_control = _display displayCtrl 1403;
	private _amount = parseNumber (ctrlText _control);
	private _itemName = lbText [1501,(lbCurSel 1501)];
	if (_amount < 1) exitwith {[("STR_Common_InvalidAmount" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if(_selectedType isEqualTo 0) then {
		[_selectedPlayer,[_selectedAsset,_amount],_selectedFactory] remoteExec ["Server_Factory_Create", 2];
	} else {
		private _shopData = [_selectedFactory] call A3PL_Config_GetShop;
		_type = "";
		{
			if (_x#1 isEqualTo _selectedAsset) exitwith {_type = _x#0;};
		} foreach _shopData;
		if (_type isEqualTo "") exitwith {};
		switch(_type) do {
			case "waitem": {
				private _weaponHolder = createVehicle ["GroundWeaponHolder", getposATL player, [], 0, "CAN_COLLIDE"];
				_weaponHolder addItemCargoGlobal [_selectedAsset,_amount];
			};
			case "aitem": {
				private _weaponHolder = createVehicle ["GroundWeaponHolder", getposATL player, [], 0, "CAN_COLLIDE"];
				_weaponHolder addItemCargoGlobal [_selectedAsset,_amount];
			};
			case "item": {
				if ([_selectedAsset,"canPickup"] call A3PL_Config_GetItem) then {
					[_selectedAsset,_amount] call A3PL_Inventory_Add;
				} else {
					private _veh = createVehicle [([_selectedAsset,"class"] call A3PL_Config_GetItem), getposATL player, [], 0, "CAN_COLLIDE"];
					if (!([_selectedAsset,"simulation"] call A3PL_Config_GetItem)) then	{[_veh] remoteExec ["Server_Vehicle_EnableSimulation",2];};
					_veh setVariable ["class",_selectedAsset,true];
					_veh setVariable ["owner",(player getVariable ["character_id",""]),true];
					[_veh,player] remoteExec ["A3PL_Lib_ChangeLocality", 2];
				};
			};
			case "weapon": {
				private _weaponHolder = createVehicle ["GroundWeaponHolder", getposATL player, [], 0, "CAN_COLLIDE"];
				_weaponHolder addWeaponCargoGlobal [_selectedAsset,_amount];
			};
			case "weaponPrimary": {
				private _weaponHolder = createVehicle ["GroundWeaponHolder", getposATL player, [], 0, "CAN_COLLIDE"];
				_weaponHolder addWeaponCargoGlobal [_selectedAsset,_amount];
			};
			case "magazine": {
				private _weaponHolder = createVehicle ["GroundWeaponHolder", getposATL player, [], 0, "CAN_COLLIDE"];
				_weaponHolder addMagazineCargoGlobal [_selectedAsset,_amount];
			};
			case "headgear": {
				private _weaponHolder = createVehicle ["GroundWeaponHolder", getposATL player, [], 0, "CAN_COLLIDE"];
				_weaponHolder addItemCargoGlobal [_selectedAsset,_amount];
			};
			case "goggles": {
				private _weaponHolder = createVehicle ["GroundWeaponHolder", getposATL player, [], 0, "CAN_COLLIDE"];
				_weaponHolder addItemCargoGlobal [_selectedAsset,_amount];
			};
			case "uniform": {
				private _weaponHolder = createVehicle ["GroundWeaponHolder", getposATL player, [], 0, "CAN_COLLIDE"];
				_weaponHolder addItemCargoGlobal [_selectedAsset,_amount];
			};
			case "backpack": {
				private _weaponHolder = createVehicle ["GroundWeaponHolder", getposATL player, [], 0, "CAN_COLLIDE"];
				_weaponHolder addBackpackCargoGlobal [_selectedAsset,_amount];
			};
		};
	};
	[format[("STR_A3PL_Admin_YouAddedInTheInventoryPlayer" call A3PL_Localize),_amount,_itemName,_selectedFactory,_selectedPlayer getVariable ["name",("STR_Common_Unknown" call A3PL_Localize)]],Color_Green] call A3PL_Notification;
	[player,"AddToPlayer", format["Target: %1 | Item: %2 | Amount: %3 | From: %4", _selectedPlayer getVariable["name","unknown"], _selectedAsset, _amount, _selectedFactory]] remoteExec ["Server_AdminLoginsert", 2];
}] call compile_Global;

["A3PL_Admin_AddToHouse", {
	params[["_propertyType","house",[""]]];

	private _display = findDisplay 98;
	private _selectedFactory = lbText [2100,(lbCurSel 2100)];
	if (_selectedFactory isEqualTo "") exitwith {[("STR_A3PL_Admin_NoFactorySelected" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_selectedFactory IN ["AdminVehicles","Objects"]) exitWith {};
	private _selectedAsset = lbData [1501,(lbCurSel 1501)];
	private _selectedType = lbValue [2100,(lbCurSel 2100)];

	if ((lbCurSel 1501) < 0) exitwith {[("STR_A3PL_Admin_YouDoNotSelectedAnything" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _selectedPlayer = A3PL_Admin_PlayerList#(lbCurSel 1500);

	private _control = _display displayCtrl 1403;
	private _amount = parseNumber (ctrlText _control);
	if (_amount < 1) exitwith {[("STR_Common_InvalidAmount" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _property = _selectedPlayer getVariable[_propertyType,objNull];
	if(isNull _property) exitWith {[format[("STR_A3PL_Admin_ThisPlayerDoesntHave" call A3PL_Localize),_propertyType],Color_Red] call A3PL_Notification;};

	private _box = _property getVariable["box_object",objNull];
	if(isNull _box) exitwith {[format[("STR_A3PL_Admin_StorageNeedToBeAround" call A3PL_Localize),_propertyType],Color_Red] call A3PL_Notification;};

	private _itemType = "";
	if(_selectedType isEqualTo 0) then {
		_itemType = [_selectedAsset,_selectedFactory,"type"] call A3PL_Config_GetFactory;
		_selectedAsset = [_selectedAsset,_selectedFactory,"class"] call A3PL_Config_GetFactory;
	} else {
		private _shopData = [_selectedFactory] call A3PL_Config_GetShop;
		private _tmpType = "";
		{
			if (_x#1 isEqualTo _selectedAsset) exitwith {_tmpType = _x#0;};
		} foreach _shopData;
		_tmpType;
	};
	if(_itemType IN ["vehicle","plane",""]) exitwith {};
	switch(_itemType) do {
		case "waitem": {_box addItemCargoGlobal [_selectedAsset,_amount];};
		case "aitem": {_box addItemCargoGlobal [_selectedAsset,_amount];};
		case "item": {
			if ([_selectedAsset,"canPickup"] call A3PL_Config_GetItem || {_propertyType isEqualTo "warehouse"} || {_propertyType isEqualTo "crackhouse"}) then {
				private _storage = _box getVariable["storage",[]];
				_storage = [_storage, _selectedAsset, _amount, true] call BIS_fnc_addToPairs;
				_box setVariable["storage",_storage,true];
			} else {
				[("STR_A3PL_Admin_ThisObjectCantBeStoreInStorage" call A3PL_Localize),Color_Red] call A3PL_Notification;
			};
		};
		case "weapon": {_box addWeaponCargoGlobal [_selectedAsset,_amount];};
		case "weaponPrimary": {_box addWeaponCargoGlobal [_selectedAsset,_amount];};
		case "magazine": {_box addMagazineCargoGlobal [_selectedAsset,_amount];};
		case "headgear": {_box addItemCargoGlobal [_selectedAsset,_amount];};
		case "goggles": {_box addItemCargoGlobal [_selectedAsset,_amount];};
		case "uniform": {_box addItemCargoGlobal [_selectedAsset,_amount];};
		case "backpack": {_box addBackpackCargoGlobal [_selectedAsset,_amount];};
	};
}] call compile_Global;

["A3PL_Admin_RemoveItem", {
	private _selectedInventory = lbText [2101,lbCurSel 2101];
	if(_selectedInventory isEqualTo "") exitWith {};

	private _selectedPlayerIndex = lbCurSel 1500;
	private _selectedPlayer = (A3PL_Admin_PlayerList#_selectedPlayerIndex);
	private _playerInventories = _selectedPlayer getVariable ["player_fstorage",[]];

	private _selectedItem = lbData [1502,lbCurSel 1502];
	if(_selectedItem isEqualTo "") exitWith {};

	private _display = findDisplay 98;
	private _control = _display displayCtrl 1403;
	private _amount = parseNumber (ctrlText _control);
	if (_amount < 1) exitwith {[("STR_Common_InvalidAmount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _selectedItemAmount = lbValue [1502,lbCurSel 1502];
	if (_amount > _selectedItemAmount) exitWith{[("STR_A3PL_Admin_ThisAmountCantBeDeleted" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if (_selectedInventory isEqualTo "Player") then {
		[_selectedItem,-(_amount)] remoteExec ["A3PL_Inventory_Add",_selectedPlayer];
		[format[("STR_A3PL_Admin_YouDeletedFromPlayerInventory" call A3PL_Localize),_amount,[_selectedItem,"name"] call A3PL_Config_GetItem,_selectedPlayer getVariable["name","unknown"]]] call A3PL_Notification;
	} else {
		[_selectedPlayer,_selectedInventory,[_selectedItem,-(_amount)],false] remoteExec ["Server_Factory_Add", 2];
		[format[("STR_A3PL_Admin_YouDeletedFromFactoryInventory" call A3PL_Localize),_amount,[_selectedItem,"name"] call A3PL_Config_GetItem,_selectedPlayer getVariable["name","unknown"],_selectedInventory]] call A3PL_Notification;
	};

	[player,"RemoveItem", format["Target: %1 | Item: %2 | Amount: %3", _selectedPlayer getVariable["name","unknown"], _selectedItem, _amount]] remoteExec ["Server_AdminLoginsert", 2];
}] call compile_Global;

["A3PL_Admin_HealPlayer", {
	private _target = (A3PL_Admin_PlayerList#(lbCurSel 1500));
	if !(_target getVariable["A3PL_Medical_Alive",true]) then {closeDialog 0;};
	_target setVariable ["A3PL_Medical_Alive",true,true];
	_target setVariable ["A3PL_Wounds",[],true];
	_target setVariable ["A3PL_Medical_Blood",5000,true];
	_target setDamage 0;
	[] remoteExec ["A3LL_EventHandlers_RadioAnim",_target];
	[player,"AdminHeal", format["Target: %1 | AdminPos: %2 | TargetPos: %3", _target getVariable["name","unknown"], getPosATL player, getPosATL _target]] remoteExec ["Server_AdminLoginsert", 2];
}] call compile_Global;

["A3PL_Admin_Noclip", {
	private _display = findDisplay 98;
	private _control = _display displayCtrl 1017;
	private["_config", "_keyForward", "_keyLeft", "_keyBackward", "_keyRight", "_keyUp", "_keyDown"];

	A3PL_Admin_fly_forward =
	{
		if ((vehicle player) isKindOf "Man") then
		{
			_vel = velocity player;
			_dir = direction player;
			player setVelocity [(_vel select 0) + (sin _dir * 0.4), (_vel select 1) + (cos _dir * 0.4), 0.4];
		};
	};
	A3PL_Admin_fly_left =
	{
		if ((vehicle player) isKindOf "Man") then
		{
			player setdir ((getdir player) - 2);
		};
	};
	A3PL_Admin_fly_right =
	{
		if ((vehicle player) isKindOf "Man") then
		{
			player setdir ((getdir player) + 2);
		};
	};
	A3PL_Admin_fly_backward =
	{
		if ((vehicle player) isKindOf "Man") then
		{
			_vel = velocity player;
			_dir = direction player;
			player setVelocity [(_vel select 0) - (sin _dir * 0.4), (_vel select 1) - (cos _dir * 0.4), 0.4];
		};
	};
	A3PL_Admin_fly_up =
	{
		if ((vehicle player) isKindOf "Man") then
		{
			_vel = velocity player;
			player setVelocity [(_vel select 0), (_vel select 1), 6];
		};
	};
	A3PL_Admin_fly_down =
	{
		if ((vehicle player) isKindOf "Man") then
		{
			player setVelocity [0,0,-4];
		};
	};
	if (!("ItemMap" in (assignedItems player))) then
	{
		if ((uniform player) isEqualTo "") then {
			player forceAddUniform "U_C_Man_casual_4_F";
		};
		player addItem "ItemMap";
		player assignItem "ItemMap";
	};

	if (player getVariable ["pVar_NoclipOn",false]) then {
		call A3PL_Admin_VehicleMarkers;
		call A3PL_Admin_MapMarkers;
		player setVariable ["pVar_NoclipOn",false,true];
		player setVariable ["pVar_RedNameOn",false,true];
		player enableStamina true;
		[player, false] remoteExecCall ["hideObjectGlobal", 2];
		onMapSingleClick "";
		if ((player getVariable ["tf_voiceVolume", 0]) isEqualTo 0) then {
			player setVariable ["tf_voiceVolume", 1, true];
		};
		(findDisplay 46) displayRemoveEventHandler ["KeyDown", keyForward];
		(findDisplay 46) displayRemoveEventHandler ["KeyDown", keyLeft];
		(findDisplay 46) displayRemoveEventHandler ["KeyDown", keyBackward];
		(findDisplay 46) displayRemoveEventHandler ["KeyDown", keyRight];
		(findDisplay 46) displayRemoveEventHandler ["KeyDown", keyUp];
		(findDisplay 46) displayRemoveEventHandler ["KeyDown", keyDown];
		[player,"Noclip_Off", format["Position: %1", getPosATL player]] remoteExec ["Server_AdminLoginsert", 2];
	} else {
		call A3PL_Admin_VehicleMarkers;
		call A3PL_Admin_MapMarkers;
		player setDamage 0;
		player setVariable ["pVar_NoclipOn",true,true];
		player setVariable ["pVar_RedNameOn",true,true];
		player setVariable ["A3PL_Wounds",[],true];
		player setVariable ["A3PL_Medical_Blood",5000,true];
		player enableStamina false;
		Player_LockView = false;
		keyForward = (findDisplay 46) displayAddEventHandler ["KeyDown","if ((_this select 1) in (actionKeys 'MoveForward')) then {call A3PL_Admin_fly_forward}"];
		keyLeft = (findDisplay 46) displayAddEventHandler ["KeyDown","if ((_this select 1) in (actionKeys 'MoveLeft')) then {call A3PL_Admin_fly_left}"];
		keyBackward = (findDisplay 46) displayAddEventHandler ["KeyDown","if ((_this select 1) in (actionKeys 'MoveBack')) then {call A3PL_Admin_fly_backward}"];
		keyRight = (findDisplay 46) displayAddEventHandler ["KeyDown","if ((_this select 1) in (actionKeys 'MoveRight')) then {call A3PL_Admin_fly_right}"];
		keyUp = (findDisplay 46) displayAddEventHandler ["KeyDown","if ((_this select 1) in (actionKeys 'MoveUp')) then {call A3PL_Admin_fly_up}"];
		keyDown = (findDisplay 46) displayAddEventHandler ["KeyDown","if ((_this select 1) in (actionKeys 'MoveDown')) then {call A3PL_Admin_fly_down}"];
		[player, true] remoteExecCall ["hideObjectGlobal", 2];
    	onMapSingleClick "(vehicle player) setPos _pos";
		if ((player getVariable ["tf_voiceVolume", 0]) > 0) then {
        player setVariable ["tf_voiceVolume", 0, true];
    	};
		[player,"Noclip_On", format["Position: %1", getPosATL player]] remoteExec ["Server_AdminLoginsert", 2];
	};

	private _color = if (player getVariable ["pVar_NoClipOn",false]) then {[0.90588235294,0.49411764705,0.14901960784,1];} else {[1, 1, 1, 1];};
	_control ctrlSetTextColor _color;

	while {player getVariable ["pVar_NoclipOn",false]} do
	{
		_eventHandler = addMissionEventHandler ["Draw3D",

		{
			{
				if (!(isNull _x) && (isPlayer _x) && (_x != player) && ((_x getVariable ["name", ""]) != "") && ((player distance _x) <= 300)) then
				{
					drawIcon3D [
						"",
						[0.22,0.525,0.592,1],
						_x modelToWorld [0, 0.1, 2.1],
						0,
						0,
						0,
						_x getVariable "name",
						2,
						0.04,
						"RobotoCondensedBold",
						"center",
						false
					];
				};
			} forEach allPlayers;
		}];

		_currentPlayerCount = count allPlayers;
		waitUntil {((_currentPlayerCount != (count allPlayers)) || !(player getVariable ["pVar_NoclipOn",false]))};

		removeMissionEventHandler ["Draw3D", _eventHandler];

		uiSleep 1;
	};
}] call compile_Global;

["A3PL_Admin_Freeze", {
	private _selectedPlayer = (A3PL_Admin_PlayerList#(lbCurSel 1500));
	if((_selectedPlayer isEqualTo player) || ((getPlayerUID _selectedPlayer) IN ["76561198170351694","76561198147147468"]) || ((_selectedPlayer getVariable["dbVar_AdminLevel",0]) >= 7)) exitWith {};
	[] remoteExec ["A3PL_Admin_UserInputCheck",_selectedPlayer];
	[player,"AdminFreezeToggle", format["Target: %1", _selectedPlayer getVariable["name","unknown"]]] remoteExec ["Server_AdminLoginsert", 2];
}] call compile_Global;

["A3PL_Admin_PlayerMute", {
    private _selectedPlayer = (A3PL_Admin_PlayerList#(lbCurSel 1500));
    if(_selectedPlayer isEqualTo player) exitWith {};

    if (_selectedPlayer getVariable["Player_Muted",true]) then {
        _player setVariable ["tf_voiceVolume",1,true];
        _player setVariable ["A3PL_Muted",false,true];
        [format[("STR_A3PL_Admin_YouUnmuted" call A3PL_Localize),_selectedPlayer getVariable ["name",("STR_Common_Unknown" call A3PL_Localize)]],Color_Green] call A3PL_Notification;
        [format[("STR_A3PL_Admin_StaffUnmutedYou" call A3PL_Localize)],Color_Yellow] remoteExec ["A3PL_Notification", _selectedPlayer];
    } else {
        _player setVariable ["tf_voiceVolume",0,true];
        _player setVariable ["A3PL_Muted",true,true];
        [format[("STR_A3PL_Admin_YouMuted" call A3PL_Localize),_selectedPlayer getVariable ["name",("STR_Common_Unknown" call A3PL_Localize)]],Color_Green] call A3PL_Notification;
        [format[("STR_A3PL_Admin_StaffMutedYou" call A3PL_Localize)],Color_Yellow] remoteExec ["A3PL_Notification", _selectedPlayer];
    };
    [player,"AdminMuteToggle", format["Target: %1", _selectedPlayer getVariable["name","unknown"]]] remoteExec ["Server_AdminLoginsert", 2];
}] call compile_Global;

["A3PL_Admin_UserInputCheck", {
	if (!userInputDisabled) then {disableUserInput true;} else {disableUserInput false;};
}] call compile_Global;

["A3PL_Admin_RedName", {
	private _display = findDisplay 98;
	private _control = _display displayCtrl 1015;
	private _color = [1, 1, 1, 1];
	if (player getVariable ["pVar_RedNameOn",false]) then {
		player setVariable ["pVar_RedNameOn",false,true];
		player enableStamina true;
		[player,"AdminMode_Off", format["Position: %1", getPosATL player]] remoteExec ["Server_AdminLoginsert", 2];
	} else {
		player setDamage 0;
		player setVariable ["pVar_RedNameOn",true,true];
		player setVariable ["A3PL_Wounds",[],true];
		player setVariable ["A3PL_Medical_Blood",5000,true];
		player enableStamina false;
		Player_LockView = false;
		_color = [0.90588235294,0.49411764705,0.14901960784,1];
		[player,"AdminMode_On", format["Position: %1", getPosATL player]] remoteExec ["Server_AdminLoginsert", 2];
	};

	_control ctrlSetTextColor _color;

	while {player getVariable ["pVar_RedNameOn",false]} do
	{
		_eventHandler = addMissionEventHandler ["Draw3D",

		{
			{
				if (!(isNull _x) && (isPlayer _x) && (_x != player) && ((_x getVariable ["name", ""]) != "") && ((player distance _x) <= 300)) then
				{
					drawIcon3D [
						"",
						[0.22,0.525,0.592,1],
						_x modelToWorld [0, 0.1, 2.1],
						0,
						0,
						0,
						_x getVariable "name",
						2,
						0.04,
						"RobotoCondensedBold",
						"center",
						false
					];
				};
			} forEach allPlayers;
		}];

		_currentPlayerCount = count allPlayers;
		waitUntil {((_currentPlayerCount != (count allPlayers)) || !(player getVariable ["pVar_RedNameOn",false]))};

		removeMissionEventHandler ["Draw3D", _eventHandler];

		uiSleep 1;
	};
}] call compile_Global;

["A3PL_Admin_FastAnimation", {
	if (pVar_FastAnimationOn) then {
		player setAnimSpeedCoef 1;
		pVar_FastAnimationOn = false;
		lbSetColor [1504, 5, [1,1,1,1]];
	} else {
		player setAnimSpeedCoef 2.5;
		pVar_FastAnimationOn = true;
		lbSetColor [1504, 5, [0.90588235294,0.49411764705,0.14901960784,1]];
	};
}] call compile_Global;

["A3PL_Admin_SelfFeed", {
	Player_Hunger = 100;
	Player_Thirst = 100;
	Player_Alcohol = 0;
	player setVariable ["player_hunger",Player_Hunger,false];
	player setVariable ["player_thirst",Player_Thirst,false];
	player setVariable ["player_alcohol",Player_Alcohol,false];
	if (Pee_System == true) then {
		Player_Pee = 100;
		player setVariable ["player_pee",Player_Pee,false];
	};
	if (Sleep_System == true) then {
		Player_Sleep = 100;
		player setVariable ["player_sleep",Player_Sleep,false];
	};
	[player,"AdminFeed"] remoteExec ["Server_AdminLoginsert", 2];
}] call compile_Global;

["A3PL_Admin_TwitterToggle", {
	if(pVar_AdminTwitter) then {
		pVar_AdminTwitter = false;
		[("STR_A3PL_Admin_TwitterMuted" call A3PL_Localize),Color_Green] call A3PL_Notification;
		[player,"AdminTwitter_Off"] remoteExec ["Server_AdminLoginsert", 2];
	} else {
		pVar_AdminTwitter = true;
		[("STR_A3PL_Admin_TwitterUnmuted" call A3PL_Localize),Color_Green] call A3PL_Notification;
		[player,"AdminTwitter_On"] remoteExec ["Server_AdminLoginsert", 2];
	};
}] call compile_Global;

["A3PL_Admin_TeleportTo", {
	if !("STR_A3PL_Admin_Perm_Teleportation" call A3PL_Localize IN pVar_AdminPerms) exitWith {[("STR_A3PL_Admin_YouDontHavePermission" call A3PL_Localize)] call A3PL_Notification;};
	private _display = findDisplay 98;
	if(isNull _display) exitWith {};
	private _id = lbCurSel 1500;
	if(_id < 0) exitWith {};
	private _target = (A3PL_Admin_PlayerList#_id);
	if(vehicle _target isEqualTo _target) then {
		player setPosATL (getPosATL _target);
		[player,"TeleportTo", format ["Target: %1(%2) | From: %3 | To: %4",_target getVariable ["name","Undefined"],(_target getVariable ["character_id",""]),(getPosATL player),(getPosATL _target)]] remoteExec ["Server_AdminLoginsert", 2];
	} else {
		private _veh = vehicle _target;
		private _value = getNumber (configFile >> "CfgVehicles" >> typeOf _veh >> "transportSoldier");
		private _freeseats = count (fullCrew _veh);
		if (_freeseats >= _value) exitwith {
			player setPosATL (getPosATL _target);
			[player,"TeleportTo", format ["Target: %1(%2) | From: %3 | To: %4",_target getVariable ["name","Undefined"],(_target getVariable ["character_id",""]),(getPosATL player),(getPosATL _target)]] remoteExec ["Server_AdminLoginsert", 2];
		};
		player moveInAny _veh;
		[player,"TeleportTo_InVehicle", format ["Target: %1(%2) | From: %3 | To: %4 (%5)",_target getVariable ["name","Undefined"],(_target getVariable ["character_id",""]),(getPosATL player),(getPosATL _target), typeOf _veh]] remoteExec ["Server_AdminLoginsert", 2];
	};
}] call compile_Global;

["A3PL_Admin_TeleportToMe", {
	if !("STR_A3PL_Admin_Perm_Teleportation" call A3PL_Localize IN pVar_AdminPerms) exitWith {[("STR_A3PL_Admin_YouDontHavePermission" call A3PL_Localize)] call A3PL_Notification;};
	private _display = findDisplay 98;
	if(isNull _display) exitWith {};
	private _id = lbCurSel 1500;
	if(_id < 0) exitWith {};
	private _target = A3PL_Admin_PlayerList#_id;
	if(vehicle _target isNotEqualTo _target) then {_target action ["GetOut",vehicle _target];};
	waitUntil{vehicle _target isEqualTo _target};
	_target setPosATL (getPosATL player);
	[player,"TeleportToMe", format ["Target: %1(%2) | From: %3 | To: %4",_target getVariable ["name","Undefined"],(_target getVariable ["character_id",""]),(getPosATL _target),(getPosATL player)]] remoteExec ["Server_AdminLoginsert", 2];
}] call compile_Global;

["A3PL_Admin_MapTeleport", {
	if (!(call A3PL_Player_AntiSpam)) exitWith {};
	if ("STR_A3PL_Admin_Perm_Teleportation" call A3PL_Localize IN pVar_AdminPerms) then {
		if(pVar_MapTeleportReady) then {
			private _display = findDisplay 98;
			private _control = _display displayCtrl 1016;
			_control ctrlSetTextColor [1,1,1,1];
			pVar_MapTeleportReady = false;
			onMapSingleClick "";
		} else {
			closeDialog 0;
			pVar_MapTeleportReady = true;
			onMapSingleClick "_currentPos = getPosATL player;
			(vehicle player) setPosATL _pos;
			[player,""TeleportMap"",[format [""From: %1 | To: %2"",_currentPos,_pos]]] remoteExec [""Server_AdminLoginsert"", 2];
			onMapSingleClick """";
			openMap false;
			pVar_MapTeleportReady = false;";
			openMap true;
			private _warning = findDisplay 46 ctrlCreate ["RscStructuredText", 9965];
			_warning ctrlSetPosition [0.4 * safezoneW + safezoneX,0.84 * safezoneH + safezoneY,0.2 * safezoneW,0.05 * safezoneH];
			_warning ctrlSetStructuredText parseText ("STR_A3PL_Admin_TeleportActivated" call A3PL_Localize);
			_warning ctrlCommit 0;
			waitUntil {sleep 1; !pVar_MapTeleportReady};
			ctrlDelete _warning;
		};
	} else {
		[("STR_A3PL_Admin_YouDontHavePermission" call A3PL_Localize)] call A3PL_Notification;
	};
}] call compile_Global;

["A3PL_Admin_GlobalMessage", {
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private _display = findDisplay 69;
	private _message = ctrlText 1402;
	if(_message isEqualTo "") exitWith {[("STR_A3PL_Admin_EnterMessage" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[format[("STR_A3PL_Admin_GlobalMessage" call A3PL_Localize),_message],"purple"] remoteExec ["A3PL_Notification", -2];
	[player,"GlobalMessage", format["Message: %1",_message]] remoteExec ["Server_AdminLoginsert",2];
}] call compile_Global;

["A3PL_Admin_DirectMessage", {
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private _display = findDisplay 69;
	private _message = ctrlText 1402;
	private _selectedIndex = lbCurSel 1500;
	private _target = (A3PL_Admin_PlayerList#_selectedIndex);
	private _thisAdmin = player getVariable ["name",""];
	if(_message isEqualTo "") exitWith {[("STR_A3PL_Admin_EnterMessage" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[format[("STR_A3PL_Admin_AdminMessageFrom" call A3PL_Localize),_thisAdmin,_message],"purple"] remoteExec ["A3PL_Notification", _target];
	[player,"DirectMessage", format["SentTo: %1 | Message: %2",_target getVariable ["name","unknown"], _message]] remoteExec ["Server_AdminLoginsert",2];
}] call compile_Global;

["A3PL_Admin_VehicleMarkers", {
	if(pVar_MapVehicleMarkersOn) then {
		pVar_MapVehicleMarkersOn = false;
		A3PL_Admin_VehMarkersEnabled = false;
		lbSetColor [1504, 7, [1,1,1,1]];
	} else {
		pVar_MapVehicleMarkersOn = true;
		lbSetColor [1504, 7, [0.90588235294,0.49411764705,0.14901960784,1]];
		A3PL_Admin_VehMarkersEnabled = true;
		[] spawn {
			private _vehMarkers = [];
			private _blacklist = ["A3PL_EMS_Locker","A3PL_WheelieBin","A3PL_DogCage","A3PL_Gas_Hose","A3PL_Gas_Box","Land_CampingTable_small_f","A3PL_MobileCrane","Box_NATO_Equip_F","B_supplyCrate_F","Land_ToolTrolley_02_F","A3FL_Stretcher"];
			while {A3PL_Admin_VehMarkersEnabled} do {
				sleep 0.5;
				if(visibleMap) then {
					{
						if(!((typeOf _x) IN _blacklist)) then {
							private _marker = createMarkerLocal [format["%1_marker",_x],visiblePosition _x];
							_marker setMarkerColorLocal "ColorBlue";
							_marker setMarkerTypeLocal "Mil_dot";
							_marker setMarkerSizeLocal [0.5, 0.5];
							_marker setMarkerAlphaLocal 1;
							if((_x isKindOf "Car") || {_x isKindOf "Ship"} || {_x isKindOf "Tank"} || {_x isKindOf "Air"}|| {_x isKindOf "Plane"}) then {
								_lp = _x getvariable ["owner",nil];
								if(isNil "_lp") then {
									_marker setMarkerTextLocal format[" %1", getText (configFile >> "CfgVehicles" >> typeOf _x >> "displayName")];
								} else {
									if(_lp isEqualType []) then {
										_marker setMarkerTextLocal format[" %1 (%2)", getText (configFile >> "CfgVehicles" >> typeOf _x >> "displayName"), _lp#1];
									} else {
										_marker setMarkerTextLocal format[" %1 (%2)", getText (configFile >> "CfgVehicles" >> typeOf _x >> "displayName"), _lp];
									};
								};
							} else {
								_marker setMarkerTextLocal format[" %1", getText (configFile >> "CfgVehicles" >> typeOf _x >> "displayName")];
							};
							_vehMarkers pushBack [_marker,_x];
						};
					} foreach (player nearEntities [["Car", "Ship", "Tank", "Air", "Plane", "Thing"], 50000]);

					while {visibleMap} do {
						{
							private _marker = _x#0;
							private _veh = _x#1;
							if(!isNil "_veh") then
							{
								if(!isNull _veh) then
								{
								    _marker setMarkerPosLocal (visiblePosition _veh);
								};
							};
						} foreach _vehMarkers;
						if(!visibleMap) exitWith {};
						sleep 0.02;
					};
					{deleteMarkerLocal (_x#0);} foreach _vehMarkers;
					_vehMarkers = [];
				};
			};
		};
	};
	if(A3PL_Admin_VehMarkersEnabled) then {
		[player,"VehicleMarkers_On", format["Position: %1 | Job: %2",getPosATL player, player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]]] remoteExec ["Server_AdminLoginsert",2];
	} else {
		[player,"VehicleMarkers_Off", format["Position: %1 | Job: %2",getPosATL player, player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]]] remoteExec ["Server_AdminLoginsert",2];
	};
}] call compile_Global;

["A3PL_Admin_MapMarkers", {
	if(pVar_MapPlayerMarkersOn) then
	{
		pVar_MapPlayerMarkersOn = false;
		A3PL_Admin_MapMarkersEnabled = false;
		lbSetColor [1504, 8, [1,1,1,1]];
	} else {
		pVar_MapPlayerMarkersOn = true;
		lbSetColor [1504, 8, [0.90588235294,0.49411764705,0.14901960784,1]];
		A3PL_Admin_MapMarkersEnabled = true;
		[] spawn {
			private _playerMarkers = [];
			while {A3PL_Admin_MapMarkersEnabled} do {
				sleep 0.5;
				if(visibleMap) then {
					{
						private _marker = createMarkerLocal [format["%1_marker",_x],visiblePosition _x];
						_marker setMarkerColorLocal "ColorYellow";
						_marker setMarkerTypeLocal "Mil_dot";
						_marker setMarkerSizeLocal [0.5, 0.5];
						_marker setMarkerAlphaLocal 1;
						_marker setMarkerTextLocal format[" (%1) %2", _x getVariable["name","ERROR"], name _x];
						_playerMarkers pushBack [_marker,_x];
					} foreach (allPlayers - [player]);

					while {visibleMap} do {
						{
							private["_marker","_unit"];
							_marker = _x#0;
							_unit = _x#1;
							if(!isNil "_unit") then {
								if(!isNull _unit) then {
								    _marker setMarkerPosLocal (visiblePosition _unit);
								};
							};
						} foreach _playerMarkers;
						if(!visibleMap) exitWith {};
						sleep 0.02;
					};
					{deleteMarkerLocal (_x#0);} foreach _playerMarkers;
					_playerMarkers = [];
				};
			};
		};
	};
	if(A3PL_Admin_MapMarkersEnabled) then {
		[player,"PlayerMarkers_On", format["Position: %1 | Job: %2",getPosATL player, player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]]] remoteExec ["Server_AdminLoginsert",2];
	} else {
		[player,"PlayerMarkers_Off", format["Position: %1 | Job: %2",getPosATL player, player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]]] remoteExec ["Server_AdminLoginsert",2];
	};
}] call compile_Global;

["A3PL_Admin_RessourcesMarkers", {
	if(pVar_RessourcesMarkersOn) then {
		pVar_RessourcesMarkersOn = false;
		A3PL_Admin_RessourcesMarkersEnabled = false;
		lbSetColor [1504, 14, [1,1,1,1]];
	} else {
		pVar_RessourcesMarkersOn = true;
		lbSetColor [1504, 14, [0.90588235294,0.49411764705,0.14901960784,1]];
		A3PL_Admin_RessourcesMarkersEnabled = true;
		[] spawn {
			private _markers = [];
			while {A3PL_Admin_RessourcesMarkersEnabled} do {
				uiSleep 0.5;
				if(visibleMap) then {
					{
						private _pos =( _x#0);
						private _amount = (_x#1);
						private _id = floor (random 5000);
						private _marker = createMarkerLocal [format["%1_marker",_id],_pos];
						_marker setMarkerShapeLocal "ELLIPSE";
						_marker setMarkerSizeLocal [100,100];
						_marker setMarkerColorLocal "ColorBlue";
						_marker setMarkerTypeLocal "Mil_dot";
						_marker setMarkerAlphaLocal 0.5;
						_markers pushBack _marker;

						_id = floor (random 5000);
						_marker = createMarkerLocal [format["%1_marker",_id],_pos];
						_marker setMarkerShapeLocal "ICON";
						_marker setMarkerColorLocal "ColorBlue";
						_marker setMarkerTypeLocal "Mil_dot";
						_marker setMarkerTextLocal format [("STR_A3PL_Admin_PetrolMap" call A3PL_Localize),_amount];
						_markers pushBack _marker;
					} foreach Server_JobWildCat_Oil;

					{
						private _pos = (_x#1);
						private _name = (_x#0);
						private _amount = (_x#3);
						private _id = floor (random 5000);
						private _marker = createMarkerLocal [format["%1_marker",_id],_pos];
						_marker setMarkerShapeLocal "ELLIPSE";
						_marker setMarkerSizeLocal [100,100];
						_marker setMarkerColorLocal "ColorYellow";
						_marker setMarkerTypeLocal "Mil_dot";
						_marker setMarkerAlphaLocal 0.85;
						_markers pushBack _marker;

						_id = floor (random 5000);
						_marker = createMarkerLocal [format["%1_marker",_id],_pos];
						_marker setMarkerShapeLocal "ICON";
						_marker setMarkerColorLocal "ColorYellow";
						_marker setMarkerTypeLocal "Mil_dot";
						_marker setMarkerTextLocal format [("STR_A3PL_Admin_ResourceStill" call A3PL_Localize),_name,_amount];
						_markers pushBack _marker;
					} foreach Server_JobWildCat_Res;

					waitUntil{!visibleMap};

					{deleteMarkerLocal _x;} foreach _markers;
					_markers = [];
				};
			};
		};
	};
}] call compile_Global;

["A3PL_Admin_ViewStats", {
	private _fMembers = [] call A3PL_Lib_AllFactionPlayers;
	private _message = ("STR_A3PL_Admin_ThereIs" call A3PL_Localize);
	_message = _message + format[("STR_A3PL_Admin_PlayersConnected" call A3PL_Localize), count(AllPlayers)];
	_message = _message + format["<br/>%1 %2", count([("STR_Common_FISD" call A3PL_Localize)] call A3PL_Lib_FactionPlayers), ("STR_Common_FISD" call A3PL_Localize)];
	_message = _message + format["<br/>%1 %2", count([("STR_Common_FIFR" call A3PL_Localize)] call A3PL_Lib_FactionPlayers), ("STR_Common_FIFR" call A3PL_Localize)];
	_message = _message + format["<br/>%1 %2", count([("STR_Common_DOJ" call A3PL_Localize)] call A3PL_Lib_FactionPlayers), ("STR_Common_DOJ" call A3PL_Localize)];
	_message = _message + format["<br/>%1 %2", count([("STR_Common_GOV" call A3PL_Localize)] call A3PL_Lib_FactionPlayers), ("STR_Common_GOV" call A3PL_Localize)];
	_message = _message + format["<br/>%1 %2", ((count(AllPlayers)) - (count _fMembers)), ("STR_Common_Job_Unemployed" call A3PL_Localize)];
	[_message,Color_Pink] call A3PL_Notification;
}] call compile_Global;

["A3PL_Admin_CreateFire", {
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private _pos = getPosATL player;
	private _dir = getDir player;
	[[(_pos#0 + (sin _dir * 3)), (_pos#1 + (cos _dir * 3)), _pos#2],true] call A3PL_Fire_StartFire;
	[player,"FireCreated", format["Position: %1",_pos]] remoteExec ["Server_AdminLoginsert",2];
}] call compile_Global;

["A3PL_Admin_PauseFire", {
	if (Server_FireLooping) then {
		lbSetColor [1504, 3, [0.90588235294,0.49411764705,0.14901960784,1]];
		[player,"FirePaused"] remoteExec ["Server_AdminLoginsert",2];
	} else {
		lbSetColor [1504, 3, [1,1,1,1]];
		[player,"FireUnPaused"] remoteExec ["Server_AdminLoginsert",2];
	};
	[] remoteExec ["Server_Fire_PauseFire", 2];
}] call compile_Global;

["A3PL_Admin_RemoveFire", {
	[] remoteExec ["Server_Fire_RemoveFires", 2];
	[player,"AdminFireRemoved"] remoteExec ["Server_AdminLoginsert",2];
}] call compile_Global;

["A3PL_Admin_Invisible", {
	if(player getVariable ["admin_invisible",false]) then {
		[player,false] remoteExec ["A3PL_Lib_HideObject", 2];
		player setVariable ["admin_invisible",false,true];
		lbSetColor [1504, 16, [0.90588235294,0.49411764705,0.14901960784,1]];
		[player,"Invisible_off", format["Position: %1", getPosATL player]] remoteExec ["Server_AdminLoginsert", 2];
	} else {
		[player,true] remoteExec ["A3PL_Lib_HideObject", 2];
		player setVariable ["admin_invisible",true,true];
		lbSetColor [1504, 16, [1,1,1,1]];
		[player,"Invisible_on", format["Position: %1", getPosATL player]] remoteExec ["Server_AdminLoginsert", 2];
	};
}] call compile_Global;

["A3PL_Admin_OpenDebug", {
	disableSerialization;
	createDialog "Dialog_DeveloperDebug";
	(findDisplay 155) call A3PL_Dialog_Localize;

	call A3PL_Debug_DropDownList;
	(findDisplay 155) displayAddEventHandler ["Unload","profileNamespace setVariable ['A3PL_Debug_Main',ctrlText 1400]"];
	ctrlSetText [1400,profileNamespace getVariable ["A3PL_Debug_Main",("STR_A3PL_Admin_NothingAtTheMoment" call A3PL_Localize)]];
}] call compile_Global;

["A3PL_Admin_TakeGear", {
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private _mode = param [0,false];
	if(_mode isEqualTo 2 && {pVar_AdminLevel isEqualTo 1}) exitwith {[("STR_A3PL_Admin_YouDontHavePermission" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _fedGear = switch(player getVariable["dbVar_AdminLevel",0]) do {
		default {[[],[],[],["A3PL_FBI_Survival_Black_Uniform",[]],["A3PL_FBI_Trainee",[]],["A3PL_LR",[]],"A3PL_FBI_Ballcap3","G_Diving",["Rangefinder","","","",[],[],""],["ItemMap","ItemGPS","a3pl_iphone","ItemCompass","ItemWatch","A3FL_Earpiece_Blk"]]};
		case 2: {[[],[],[],["A3PL_FBI_Survival_Black_Uniform",[]],["A3PL_FBI_Executive",[]],["A3PL_LR",[]],"A3PL_FBI_Ballcap3","G_Diving",["Rangefinder","","","",[],[],""],["ItemMap","ItemGPS","a3pl_iphone","ItemCompass","ItemWatch","A3FL_Earpiece_Blk"]]};
		case 3: {[[],[],[],["A3PL_FBI_Survival_White_Uniform",[]],["A3PL_FBI_Supervisor",[]],["A3PL_LR",[]],"A3PL_FBI_Ballcap3","G_Diving",["Rangefinder","","","",[],[],""],["ItemMap","ItemGPS","a3pl_iphone","ItemCompass","ItemWatch","A3FL_Earpiece_Blk"]]};
		case 5: {[[],[],[],["A3PL_FBI_Survival_White_Uniform",[]],["A3PL_FBI_Chief",[]],["A3PL_LR",[]],"A3PL_FBI_Ballcap3","G_Diving",["Rangefinder","","","",[],[],""],["ItemMap","ItemGPS","a3pl_iphone","ItemCompass","ItemWatch","A3FL_Earpiece_Blk"]]};
		case 6: {[[],[],[],["A3PL_FBI_Survival_White_Uniform",[]],["A3PL_FBI_LeadChief",[]],["A3PL_LR",[]],"A3PL_FBI_Ballcap3","G_Diving",["Rangefinder","","","",[],[],""],["ItemMap","ItemGPS","a3pl_iphone","ItemCompass","ItemWatch","A3FL_Earpiece_Blk"]]};
		case 7: {[[],[],[],["A3PL_FBI_Survival_White_Uniform",[]],["A3PL_FBI_SubDirector",[]],["A3PL_LR",[]],"A3PL_FBI_Ballcap3","G_Diving",["Rangefinder","","","",[],[],""],["ItemMap","ItemGPS","a3pl_iphone","ItemCompass","ItemWatch","A3FL_Earpiece_Blk"]]};
		case 8: {[[],[],[],["A3PL_FBI_Survival_White_Uniform",[]],["A3PL_FBI_Director",[]],["A3PL_LR",[]],"A3PL_FBI_Ballcap3","G_Diving",["Rangefinder","","","",[],[],""],["ItemMap","ItemGPS","a3pl_iphone","ItemCompass","ItemWatch","A3FL_Earpiece_Blk"]]};
		case 9: {[[],[],[],["A3PL_FBI_Survival_White_Uniform",[]],["A3PL_FBI_NBI",[]],["A3PL_LR",[]],"A3PL_FBI_Ballcap3","G_Diving",["Rangefinder","","","",[],[],""],["ItemMap","ItemGPS","a3pl_iphone","ItemCompass","ItemWatch","A3FL_Earpiece_Blk"]]};
	};
	private _fifrGear = [[],[],[],["A3PL_FIFR_Basic_FF_Uniform",[]],[],["A3PL_LR",[]],"A3PL_FIFR_Cap_Navy_Hat","",[],["ItemMap","ItemGPS","a3pl_iphone","ItemCompass","TFAR_microdagr","A3FL_Earpiece_Blk"]];
	private _prevGear = profileNamespace getVariable [format["A3FL_PrevGear_%1",(player getVariable "character_id")],nil];
	if((backpack player) isEqualTo "A3PL_LR") then {A3PL_Admin_PrevRadio = (call TFAR_fnc_activeLrRadio) call TFAR_fnc_getLrSettings;};

	private _modeString = switch(_mode) do {
		case 0: {
			_prevGear = [player] call A3PL_Lib_Loadout;
			profileNamespace setVariable [format["A3FL_PrevGear_%1",(player getVariable "character_id")],_prevGear];
			player setUnitLoadout _fedGear;
			player setVariable ["pVar_RedNameOn",true,true];
			("STR_A3PL_Admin_FBIGear" call A3PL_Localize);
		};
		case 1: {
			if(!isNil "_prevGear") then {
				player setUnitLoadout _prevGear;
				player setVariable ["pVar_RedNameOn",false,true];
				if((player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) isEqualTo ("STR_Common_FIFR" call A3PL_Localize)) then {[player] remoteExec ["Server_Admin_WasFedFIFR",2];};
			} else {
				["Il n'y a pas d'équipement précédemment sauvegardé",Color_Pink] call A3PL_Notification;
			};
			("STR_A3PL_Admin_SavedGear" call A3PL_Localize);
		};
		case 2: {
			_prevGear = [player] call A3PL_Lib_Loadout;
			profileNamespace setVariable [format["A3FL_PrevGear_%1",(player getVariable "character_id")],_prevGear];
			player setUnitLoadout _fifrGear;
			player setVariable ["faction",("STR_Common_FIFR" call A3PL_Localize),true];
			player setVariable ["job",("STR_Common_FIFR" call A3PL_Localize),true];
			("STR_A3PL_Admin_FDGear" call A3PL_Localize);
		};
	};
	if(((backpack player) isEqualTo "A3PL_LR") && {!isNil "A3PL_Admin_PrevRadio"}) then {[(call TFAR_fnc_activeLrRadio), A3PL_Admin_PrevRadio] call TFAR_fnc_setLrSettings;};
	[player,"GearSwitch",format ["GearSelected: %1 | Position: %2",_modeString, getPosATL player]] remoteExec ["Server_AdminLoginsert",2];
}] call compile_Global;

["A3PL_Admin_AdminIsland", {
	private _display = findDisplay 98;
	private _control = _display displayCtrl 1015;
	private _prevPos = getPosATL player;
	_control ctrlSetTextColor [0.90588235294,0.49411764705,0.14901960784,1];
	(vehicle player) setPos [12626.7,1711.21,0.00143886];
	if !(player getVariable ["pVar_RedNameOn",false]) then {
		player setDamage 0;
		player setVariable ["pVar_RedNameOn",true,true];
		player setVariable ["A3PL_Wounds",[],true];
		player setVariable ["A3PL_Medical_Blood",5000,true];
		player enableStamina false;
	};
	[player,"Teleport_AdminIsland",format ["PreviousPos: %1",_prevPos]] remoteExec ["Server_AdminLoginsert",2];
}] call compile_Global;

["A3PL_Admin_Lightning", {
	disableSerialization;
	private _display = findDisplay 98;
	private _selectedTag = lbCurSel 2103;
	private _target = lbCurSel 1500;
	if(_target < 0) exitWith {};
	_target = (A3PL_Admin_PlayerList#_target);
	private _tempTarget = createSimpleObject ["Land_HelipadEmpty_F", getPosASL _target];
	[_tempTarget, nil, true] spawn BIS_fnc_moduleLightning;
}] call compile_Global;

["A3PL_Admin_CallLogger", {
	disableSerialization;
	closeDialog 0;
	createDialog "Dialog_ExecutiveCallLogger";
	private _display = findDisplay 99;
	_display call A3PL_Dialog_Localize;
	private _control = _display displayCtrl 2100;
	{
		_control lbAdd (_x getVariable ["name","unknown"]);
	} forEach AllPlayers;
	private _control = _display displayCtrl 2101;
	{
		_control lbAdd format ["%1",_x#0];
	} foreach CALLPRESETS;
	_control ctrlAddEventHandler ["LBSelChanged",{ctrlSetText [1401,(CALLPRESETS#(_this#1))#1];}];
}] call compile_Global;

["A3PL_Admin_LogCall", {
	if(!(call A3PL_Player_AntiSpamLong)) exitWith {};
	disableSerialization;
	private _execName = player getVariable ["name","unknown"];
	private _target = lbText [2100,lbCurSel 2100];
	private _details = ctrlText 1401;
	[_execName,_target,_details] remoteExec ["Server_Log_ExecCall",2];
	closeDialog 0;
}] call compile_Global;

["A3FL_Admin_ToggleEvent", {
	params["_eventVar"];

	private _getEventData = switch(_eventVar) do {
		case "A3PL_Event_DblXP": {
			if(missionNamespace getVariable[_eventVar,1] isEqualTo 1) then {[("STR_A3PL_Admin_DoubleEXPStart" call A3PL_Localize),2,8]} else {[("STR_A3PL_Admin_DoubleEXPEnd" call A3PL_Localize),1,8]};
		};
		case "A3PL_Event_DblHarvest": {
			if(missionNamespace getVariable[_eventVar,1] isEqualTo 1) then {[("STR_A3PL_Admin_DoubleGatherStart" call A3PL_Localize),2,9]} else {[("STR_A3PL_Admin_DoubleGatherEnd" call A3PL_Localize),1,9]};
		};
		case "A3PL_Event_Paycheck": {
			if(missionNamespace getVariable[_eventVar,1] isEqualTo 1) then {[("STR_A3PL_Admin_15SalaryStart" call A3PL_Localize),1.5,10]} else {[("STR_A3PL_Admin_15SalaryEnd" call A3PL_Localize),1,10]};
		};
		case "A3PL_Event_CrimePayout": {
			if(missionNamespace getVariable[_eventVar,1] isEqualTo 1) then {[("STR_A3PL_Admin_15CriminalStart" call A3PL_Localize),1.5,11]} else {[("STR_A3PL_Admin_15CriminalEnd" call A3PL_Localize),1,11]};
		};
	};

	if (missionNamespace getVariable[_eventVar,1] isEqualTo 1) then {
		lbSetColor [1504,_getEventData#2,[0.90588235294,0.49411764705,0.14901960784,1]];
	} else {
		lbSetColor [1504,_getEventData#2, [1,1,1,1]];
	};

	[_eventVar,_getEventData] remoteExec ["Server_Admin_ToggleEvent",2];
}] call compile_Global;
