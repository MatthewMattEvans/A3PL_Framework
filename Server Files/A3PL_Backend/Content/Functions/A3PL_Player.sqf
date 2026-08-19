/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
//variables that can be changed from client
['A3PL_Player_VariablesSetup',
{
	//call A3PL_Config_Master;
	call A3PL_Config_Inventory_Grid;
	
	Player_StartTutorial = profileNamespace getVariable ["Player_StartTutorial",0];
	if (!(typeName Player_StartTutorial == "SCALAR")) then {
		Player_StartTutorial = 0;
		Player_StartTutorial = profileNamespace setVariable ["Player_StartTutorial",0];
	};

	Player_SelectedMarkers = [];
	Player_ActionCompleted = true;
	Player_ActionDoing = false;
	Player_Item = objNull;
	Player_ItemClass = '';
	Player_Notifications = [];
    Player_TutorialNotifications = [];
	A3PL_FishingBuoy_Local = [];
	Player_AntiSpam = false;
	Player_AntiListboxSpam = false;
	Player_Lockview = false;
	Player_Ragdoll = false;
	Player_MapFilter = "ALL";
	A3PL_Punch = false;
	Player_CurBloodOverlay = 0;
	A3PL_Holster = "";

	// Hotbar variables
	Hotbar_SlotCount = 10;
	Hotbar_Data = ["", "", "", "", "", "", "", "", "", ""];
	Hotbar_UI_BaseIDC = 85000;
	Hotbar_UI_Visible = false;
	Hotbar_DragItem = "";
	Hotbar_DragFromSlot = -1;
	Hotbar_MenuItemClass = "";
	Hotbar_MenuEH = nil;

	Color_Yellow = '#E1BB00';
	Color_Amber = '#f0c300';
	Color_Brown = '#5b3c11';
	Color_White = '#ffffff';
	Color_Red = '#FD1703';
	Color_Green = '#17ED00';
	Color_LightGreen = '#81ED00';
	Color_Blue = '#001cf0';
	Color_Orange = '#ff9d00';
	Color_Pink = '#F20DF0';
	Color_Purple = '#AD0DF2';
	Color_LightBlue = '#00A7F0';
    Color_Black = '#000000';
	publicVariableServer "Color_Yellow";
	publicVariableServer "Color_Amber";
	publicVariableServer "Color_Brown";
	publicVariableServer "Color_White";
	publicVariableServer "Color_Red";
	publicVariableServer "Color_Green";
	publicVariableServer "Color_LightGreen";
	publicVariableServer "Color_Blue";
	publicVariableServer "Color_Orange";
	publicVariableServer "Color_Pink";
	publicVariableServer "Color_Purple";
	publicVariableServer "Color_LightBlue";
    publicVariableServer "Color_Black";

	A3PL_Player_Vehicles = [];

    if (Halloween) then {
        A3PL_Halloween_AngelModeEnabled = true;
        A3PL_Owns_Guardianscript = true;
    };

    if (Christmas) then {
        setTerrainGrid 50;
    } else {
		setTerrainGrid 25;
	};
	if ((Christmas) && !(Christmas_Mapping_Spawned)) then {
		call A3FL_Christmas_Mapping;
	};

	A3PL_TwitterChatLog = [];
	A3PL_TwitterChatPhone = [];
	A3PL_TwitterMsg_Array = [];
	A3PL_TwitterMsg_Counter = 0;
	A3PL_Message1_Twitter_active = false;
	A3PL_Message2_Twitter_active = false;
	A3PL_Message3_Twitter_active = false;
	A3PL_Message4_Twitter_active = false;
	A3PL_Player_Phone_NewTweet = false;
	A3PL_Uber_JobActive = false;
	A3PL_Uber_ActiveRequest = objNull;

	smart_marker_ready = false;
	
	A3PL_eventNotifQueue = [];
	A3PL_activeNotifControl = [];
	A3PL_eventNotifMessages = [];
	A3PL_notifProcessorRunning = false;
	A3PL_notifControlText = 30000;
	A3PL_notifControlStrip = 30001;

	A3PL_Phone_callnumber = "";
	A3PL_Phone_callAnonyme = false;
	A3PL_Phone_incall = false;
	A3PL_Phone_Ring = false;
	A3PL_Phone_trycall = false;
	A3PL_Phone_Avion = false;
	A3PL_Phone_Mute = false;
	A3PL_Phone_SMS = false;
	A3PL_Phone_Anonyme = false;
	A3PL_Phone_Historique = [];
	A3PL_Central = false;
	A3PL_PhoneObject = objNull;
	A3PL_Sony_Freq = 0;
	A3PL_Sony_FreqAdd = 0;
	A3PL_iPhone_Freq = 0;
	A3PL_inspectTelMarker = "";
	A3PL_inspectTeltime = time;
	iPhone_Mute = false;
	iPhone_Speackers = false;
	life_radio_connected = false;
	life_phone_connected = false;
	message1_smsactive = false;
	message2_smsactive = false;
	message3_smsactive = false;
	message4_smsactive = false;
    messagecallin_active = false;
    message1_copactive = false;
    message2_copactive = false;
    message3_copactive = false;
    message4_copactive = false;
	megaphone_speaking = false;
    airradio_speaking = false;

	Player_Hooker = nil;
	Player_Hooker_Owner = nil;
	Player_Hooker_IsStopped = false;
	Player_Hooker_IsArrested = false;
	Player_Hooker_ArrestedBy = nil;
	Player_Hooker_IsGeneratingMoney = false;
	Player_Hooker_MoneyGenerationLoop = nil;

	A3PL_Jobroadworker_MarkerList = [];
	Player_License_Action = false;
	Player_NameIntersect = "";
	Player_ObjIntersect = player;
	Player_selectedIntersect = 0;
	Player_ActionInterrupted = false;
	A3PL_Respawn_Time = 60 * 10;
	A3PL_HitchingVehicles = ["A3PL_Car_Base","A3PL_Truck_Base","A3FL_F450","A3FL_F150"];
	A3PL_BetterBuy = [];
	A3PL_Player_Golfing = false;
    Player_Muted = false;
	A3PL_Achievement = [];
	private _measurement = profileNamespace getVariable ["A3PL_MetricUnits",false];
	if(_measurement) then {setSystemOfUnits 1;} else {setSystemOfUnits 2;};
	TF_MAX_ASIP_FREQ = 130;
	player setVariable ["BIS_noCoreConversations", true];
}] call compile_Global;

["A3PL_Player_StatsSetup",
{

	diag_log "A3PL_Player_StatsSetup called";

	diag_log "Loading achievement variables";

	[player] remoteExec ["Server_Achievement_Get", 2];

	diag_log "Initializing playtime variables";

	// Playtime
	[player] remoteExec ["Server_Player_LoadPlayTime",2];

	diag_log "Initializing phone variables";

	// Phone
	[player] remoteExec ["Server_Phone_getForfait",2];
	[player] remoteExec ["Server_Phone_getPhoneNumber",2];
	[player] remoteExec ["Server_Phone_getContacts",2];

	private _loadedNotes = profileNamespace getVariable [format["A3FL_Notes_%1",(player getVariable "character_id")], nil];
	if (isNil "_loadedNotes") then {
		A3FL_Notes = [];
		profileNamespace setVariable [format["A3FL_Notes_%1",(player getVariable "character_id")], A3FL_Notes];
		saveProfileNamespace;
	} else {
		A3FL_Notes = _loadedNotes;
	};
	private _loadedNotesSD = profileNamespace getVariable [format["A3FL_NotesSD_%1",(player getVariable "character_id")], nil];
	if (isNil "_loadedNotesSD") then {
		A3FL_NotesSD = [];
		profileNamespace setVariable [format["A3FL_NotesSD_%1",(player getVariable "character_id")], A3FL_NotesSD];
		saveProfileNamespace;
	} else {
		A3FL_NotesSD = _loadedNotes;
	};
	private _loadedNotesFD = profileNamespace getVariable [format["A3FL_NotesFD_%1",(player getVariable "character_id")], nil];
	if (isNil "_loadedNotesFD") then {
		A3FL_NotesFD = [];
		profileNamespace setVariable [format["A3FL_NotesFD_%1",(player getVariable "character_id")], A3FL_NotesFD];
		saveProfileNamespace;
	} else {
		A3FL_NotesFD = _loadedNotes;
	};
	private _loadedNotesDOJ = profileNamespace getVariable [format["A3FL_NotesDOJ_%1",(player getVariable "character_id")], nil];
	if (isNil "_loadedNotesDOJ") then {
		A3FL_NotesDOJ = [];
		profileNamespace setVariable [format["A3FL_NotesDOJ_%1",(player getVariable "character_id")], A3FL_NotesDOJ];
		saveProfileNamespace;
	} else {
		A3FL_NotesDOJ = _loadedNotes;
	};

	diag_log "Initializing survival variables";

	Player_payCheckTime = 0;
	Player_Hunger = player getVariable ["player_hunger",100];
	if (!(typeName Player_Hunger == "SCALAR")) then {
		Player_Hunger = 100;
		Player_Hunger = player setVariable ["player_hunger",100,false];
	};
	Player_Thirst = player getVariable ["player_thirst",100];
	if (!(typeName Player_Thirst == "SCALAR")) then {
		Player_Thirst = 100;
		Player_Thirst = player setVariable ["player_thirst",100,false];
	};
	Player_Alcohol = player getVariable ["player_alcohol",0];
	if (!(typeName Player_Alcohol == "SCALAR")) then {
		Player_Alcohol = 0;
		Player_Alcohol = player setVariable ["player_alcohol",0,false];
	};
	Player_Pee = player getVariable ["player_pee",100];
	if (!(typeName Player_Pee == "SCALAR")) then {
		Player_Pee = 100;
		Player_Pee = player setVariable ["player_pee",100,false];
	};
	Player_Sleep = player getVariable ["player_sleep",100];
	if (!(typeName Player_Sleep == "SCALAR")) then {
		Player_Sleep = 100;
		Player_Sleep = player setVariable ["player_sleep",100,false];
	};
	Player_Drugs = player getVariable ["player_drugs",[0,0,0]];
	if (!(Player_Drugs isEqualType [])) then {
		Player_Drugs = [0,0,0];
		Player_Drugs = player setVariable ["player_drugs",[0,0,0],false];
	} else {
		private _totalDrugs = 0;
		{
			_totalDrugs = _totalDrugs + _x;
		} foreach Player_Drugs;
		if(_totalDrugs > 0) then {player setVariable["drugs",true,true];};
	};

	diag_log "Initializing sport variables";

	Player_SportSpeed = player getVariable ["Player_SportSpeed",1];
	if (!(typeName Player_SportSpeed == "SCALAR")) then {
		Player_SportSpeed = 1;
		Player_SportSpeed = player setVariable ["Player_SportSpeed",1,false];
	};
	Player_ScopeStability = player getVariable ["Player_ScopeStability",1];
	if (!(typeName Player_ScopeStability == "SCALAR")) then {
		Player_ScopeStability = 1;
		Player_ScopeStability = player setVariable ["Player_ScopeStability",1,false];
	};
	Player_SportLevel = player getVariable ["Player_SportLevel",0];
	if (!(typeName Player_SportLevel == "SCALAR")) then {
		Player_SportLevel = 0;
		Player_SportLevel = player setVariable ["Player_SportLevel",0,false];
	};
	Player_maxTimeTired = player getVariable ["Player_maxTimeTired",30];
	if (!(typeName Player_maxTimeTired == "SCALAR")) then {
		Player_maxTimeTired = 30;
		Player_maxTimeTired = player setVariable ["Player_maxTimeTired",30,false];
	};

	//Sport
	call A3PL_Sport_Init;
}] call compile_Global;

["A3PL_Player_AntiSpam",
{
	if(Player_AntiSpam) exitWith {
		[("STR_Common_AntiSpam" call A3PL_Localize),Color_Red] call A3PL_Notification;
		false
	};
	Player_AntiSpam = true;
	[] spawn {
		sleep 0.75;
		Player_AntiSpam = false;
	};
	true
}] call compile_Global;

["A3PL_Player_SyncStatsToServer",
{
	// Send all player stats to server for synchronization
	[
		player,
		Player_Hunger,
		Player_Thirst,
		Player_Alcohol,
		Player_Drugs,
		Player_Pee,
		Player_Sleep,
		Player_SportLevel,
		Player_SportSpeed,
		Player_ScopeStability,
		Player_maxTimeTired
	] remoteExec ["Server_Player_SyncStats", 2];
}] call compile_Global;

["A3PL_Player_AntiSpamLong",
{
	if(Player_AntiSpam) exitWith {
		[("STR_Common_AntiSpam" call A3PL_Localize),Color_Red] call A3PL_Notification;
		false
	};
	Player_AntiSpam = true;
	[] spawn {
		sleep 2;
		Player_AntiSpam = false;
	};
	true
}] call compile_Global;

["A3PL_Player_AntiListboxSpam",
{
	if(Player_AntiListboxSpam) exitWith {false};
	Player_AntiListboxSpam = true;
	[] spawn {
		uiSleep 0.02;
		Player_AntiListboxSpam = false;
	};
	true
}] call compile_Global;

//creates an array which drawText will use to draw player tags on the screen, we dont want to run complicated scripts onEachFrame
["A3PL_Player_NameTags",
{
	private _players = player nearEntities [["C_man_1"],4];
	private _players = _players - [player];
	private _tags = [];
	private _isAdmin = player getVariable["pVar_RedNameOn",false];
	if !(profilenamespace getVariable ["Player_EnableID",true]) exitWith {A3PL_Player_TagsArray = [];};
	{
		private["_charID","_saved","_savedName","_hasMaskCheck","_cansee","_id","_name"];
		if (simulationEnabled _x) then
		{
			if(_isAdmin) then {
				_name = format["%1",_x getVariable ["db_id",-1]];
				_tags pushback [_x,_name];
			} else {
				_charID = (_x getVariable ["character_id",""]);
				_saved = profileNamespace getVariable [format["A3FL_NameTags_%1",(player getVariable "character_id")],[]];
				_savedName = "";
				{
					if((_x#0) isEqualTo _charID) exitWith {
						_savedName = _x#1;
					}
				} forEach _saved;

				_hasMaskCheck = if((goggles _x IN GogglesList) || {headgear _x IN HeadgearsList}) then {true} else {false};
				_cansee = (([objNull, "VIEW"] checkVisibility [eyePos player, eyePos _x]) > 0) && {!isObjectHidden _x};
				if (_cansee) then
				{
					_id = _x getVariable ["db_id",-1];
					if(!(_savedName isEqualTo "") && !_hasMaskCheck) then {
						_name = format["%1 - %2",_id, _savedName];
						_tags pushback [_x,_name];
					} else {
						_name = format[("STR_A3PL_Player_TagUnknown" call A3PL_Localize),_id];
						_tags pushback [_x,_name];
					};
				};
			};
		};
	} foreach _players;
	A3PL_Player_TagsArray = _tags;
}] call compile_Global;

//gets nearest businesses, and business items
["A3PL_Player_BusinessTags",
{
	private _bus = player nearEntities [["Land_A3PL_Showroom","Land_A3PL_Cinema","Land_A3PL_Gas_Station","Land_A3PL_Garage","land_smallshop_ded_smallshop_01_f","land_smallshop_ded_smallshop_02_f","Land_A3FL_Brick_Shop_1","Land_A3FL_Brick_Shop_2"],50];
	private _items = nearestObjects [position player, [], 10];
	private _tags = [];
	private _iTags = [];
	{
		_bName = _x getVariable ["bName",""];
		if (_bName isNotEqualTo "") then
		{
			private _pos = switch (typeOf _x) do {
				case "Land_A3PL_Showroom": {_x modelToWorld [10,0,0]};
				case "land_smallshop_ded_smallshop_02_f": {_x modelToWorld [8,0,0]};
				case "land_smallshop_ded_smallshop_01_f": {_x modelToWorld [8,0,0]};
				case "Land_A3PL_Garage": {_x modelToWorld [6,2,-1]};
				case "Land_A3PL_Gas_Station": {_x modelToWorld [-3.5,-0.65,-1]};
				case "Land_A3FL_Brick_Shop_1": {_x modelToWorld [8,0,0]};
				case "Land_A3FL_Brick_Shop_2": {_x modelToWorld [8,0,0]};
				default {_x modelToWorld [0,0,0]};
			};
			_tags pushback [_pos,_bName];
		};
	} foreach _bus;

	{
		_bItem = _x getVariable ["bItem",[]];
		if (count _bItem isNotEqualTo 0) then
		{
			private ["_icon"];
			_icon = if (_x isKindOf "Car") then {"\A3\ui_f\data\map\VehicleIcons\iconcar_ca.paa"} else {"\A3\ui_f\data\map\VehicleIcons\iconcratewpns_ca.paa"};
			_iTags pushback [_x modelToWorld [0,0,0.75],format ["%2 - $%1",_bItem#0,_bItem#1],_icon];
		};
	} foreach _items;

	A3PL_Player_bTagsArray = _tags;
	A3PL_Player_biTagsArray = _iTags;
}] call compile_Global;

//["A3PL_DrawText", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
["A3PL_Player_DrawText",
{
	["A3PL_DrawText", "onEachFrame",
	{
		{
			_p = _x#0;
			_pos = visiblePositionASL _p;
			_pos set [2, ((_p modelToWorld [0,0,0])#2) + 2];
			if (_p getVariable ["pVar_RedNameOn",false]) then {
				drawIcon3D ["", [_p] call A3PL_Admin_Color,_pos, 0.2, 0.2, 45,format [("STR_A3PL_Player_OOC" call A3PL_Localize),(_p getvariable["name",name _p]), [_p] call A3PL_Admin_Title], 1, 0.03, "EtelkaNarrowMediumPro"];
			} else {
				drawIcon3D ["", [1, 1, 1, 1],_pos, 0.2, 0.2, 45, _x#1, 1, 0.03, "EtelkaNarrowMediumPro"];
			};
		} foreach (missionNameSpace getVariable ["A3PL_Player_TagsArray",[]]);

		{
			drawIcon3D ["\a3\ui_f\data\IGUI\Cfg\Actions\open_door_ca.paa", [1, 1, 1, 1],_x#0, 0.5, 0.5, 45, _x#1, 1, 0.03, "EtelkaNarrowMediumPro"];
		} foreach (missionNameSpace getVariable ["A3PL_Player_bTagsArray",[]]);

		{
			drawIcon3D [_x select 2, [1, 1, 1, 1],_x#0, 0.5, 0.5, 45, _x#1, 1, 0.03, "EtelkaNarrowMediumPro"];
		} foreach (missionNameSpace getVariable ["A3PL_Player_biTagsArray",[]]);
	}] call BIS_fnc_addStackedEventHandler;
}] call compile_Global;

//First function that loads when player joins
['A3PL_Player_Initialize', {
	private ["_myVersion"];
	//#include "\x\cba\addons\ui_helper\script_dikCodes.hpp"

	[clientOwner, getPlayerUID player] remoteExec ["A3FL_Debug_RegisterClientOwner", 2];

	if ((getNumber (configFile >> "CfgPatches" >> "A3PL_Common" >> "requiredVersion")) < (missionNameSpace getVariable ["Server_ModVersion",0])) exitwith
	{
		[] spawn {
			titleText ["Veuillez télécharger la dernière version des addons", "BLACK"];
			uiSleep 5;
			player setVariable ["A3PL_Outdated",1,true];
		};
	};

    //Christmas
    if (Christmas) then {
	   enableEnvironment [true, false]; //removes rain sounds for snow
    };

	inGameUISetEventHandler ["PrevAction", "if (Player_selectedIntersect > 0) then {Player_selectedIntersect = Player_selectedIntersect - 1;}; true"];
	inGameUISetEventHandler ["NextAction", "Player_selectedIntersect = Player_selectedIntersect + 1; true"];
	inGameUISetEventHandler ["Action", "true;"]; //block scroll option
	showHUD [true,false,false,false,false,false,false,true,false]; //hide scroll option
	player addAction ["", {}];

	//Setup normal variables
	call A3PL_Player_VariablesSetup;

	//Start loading process
	[] spawn A3PL_Loading_Start;

	//Bowling
	if (Activity_Bowling) then {call A3PL_Bowling_Init;};

	//Initialise the HUD
	call A3PL_HUD_Init;

	//Setup loops
	call A3PL_Loop_Setup;

	//Setup Eventhandlers
	[] spawn A3PL_EventHandlers_Setup;

	//Setup intersection oneachframe, used for interaction menu
	call A3PL_Intersect_Lines;

	//Setup keypad event handler
	[] call A3PL_Keypad_Init;

	//Setup lockview loop
	call A3FL_Loop_LockView;

	//setup name tags
	call A3PL_Player_DrawText;

	//setup housing
	[] spawn A3PL_Housing_Init;

	//setup warehouses
	[] spawn A3PL_Warehouses_Init;

	//setup crackhouses
	[] spawn A3PL_Crackhouses_Init;

	//Escape menu edition
	[] spawn A3PL_Player_EscapeControls;

	//GPS Navigation System - DISABLED
	[] spawn A3PL_GPS_Init;

	call A3PL_Player_CheckDebugVariables;

	if (Player_StartTutorial isEqualTo 0) then {
		[] spawn A3PL_Player_NewPlayerTutorial;
	};

	[getPlayerUID player,(player getVariable ["character_id",""]),"Player_Connect",[format ["A3 Name: %1 | Character Name: %2",(name player),(player getVariable ["name","unknown"])]]] remoteExec ["Server_Log_New",2];

	private _hours = date select 3;
	private _minuts = date select 4;
	if (_hours < 10) then {_hours = format["0%1", _hours];};
	if (_minuts < 10) then {_minuts = format["0%1", _minuts];};
	[
		[
			[("STR_A3PL_Player_MapName" call A3PL_Localize), "<t align = 'center' size = '1'>%1</t><br/>"], ["", ""],
			[(format["%1 %2 %3",(date select 2),switch (date select 1) do{case 1: {("STR_A3PL_Player_January" call A3PL_Localize)};case 2: {("STR_A3PL_Player_February" call A3PL_Localize)};case 3: {("STR_A3PL_Player_March" call A3PL_Localize)};case 4: {("STR_A3PL_Player_April" call A3PL_Localize)};case 5: {("STR_A3PL_Player_May" call A3PL_Localize)};case 6: {("STR_A3PL_Player_June" call A3PL_Localize)};case 7: {("STR_A3PL_Player_Jully" call A3PL_Localize)};case 8: {("STR_A3PL_Player_August" call A3PL_Localize)};case 9: {("STR_A3PL_Player_September" call A3PL_Localize)};case 10: {("STR_A3PL_Player_October" call A3PL_Localize)};case 11: {("STR_A3PL_Player_November" call A3PL_Localize)};case 12: {("STR_A3PL_Player_December" call A3PL_Localize)};},(date select 0)]), "<t align = 'center' size = '0.7'>%1</t><br/>"], ["", ""],
			[(format["%1:%2", _hours, _minuts]), "<t align = 'center' size = '0.7'>%1</t>"],["", ""], ["", ""]
		]
	] spawn BIS_fnc_typeText;
}] call compile_Global;

["A3PL_Player_HasCash", {
	private _amount = param [0, 0, [0]];
	private _cash = player getVariable ["Player_Cash",0];
	if (_cash >= _amount) exitWith {true};
	false
}] call compile_Global;

["A3PL_Player_SetPaycheck",
{
	private _paycheckSaved = param [0,0];
	Player_Paycheck = _paycheckSaved;
}] call compile_Global;

["A3PL_Player_PickupPaycheck", {
	private _paycheckAmount = Player_Paycheck;
	if (Player_Paycheck < 1) exitWith {[("STR_A3PL_Player_NoPaycheck" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_hasBankAccount = [player,1] call A3PL_Bank_HasAccount;
	private _pCash = player getVariable["Player_Cash",0];
	[getPlayerUID player,(player getVariable ["character_id",""]),"Paycheck_Collect",[format ["PrevBank: %1 | Collected: %2 | NewBank: %3",_pCash,_paycheckAmount,(_pCash + _paycheckAmount)]]] remoteExec ["Server_Log_New",2];
	Player_Paycheck = 0;
	[player, 'Player_Cash', (_pCash + _paycheckAmount)] remoteExec ['Server_Core_ChangeVar', 2];
	[player, Player_Paycheck] remoteExec ["Server_Player_UpdatePaycheck",2];
	[format[("STR_A3PL_Player_YouSignedYourPaycheck" call A3PL_Localize), [_paycheckAmount, 1, 0, true] call CBA_fnc_formatNumber],Color_Green] call A3PL_Notification;
}] call compile_Global;

//retrieve a player tag
["A3PL_Player_GetNameTag",
{
	private _player = param [0,objNull];
	private _charID = (_player getVariable ["character_id",""]);
	private _saved = profileNamespace getVariable [format["A3FL_NameTags_%1",(player getVariable "character_id")],[]];
	private _name = ("STR_Common_Unknown" call A3PL_Localize);
	private _goggles = GogglesList;
	private _headgear = HeadgearsList;
	private _hasMaskCheck = if((goggles _player IN _goggles) || {headgear _player IN _headgear}) then {true} else {false};
	if (_hasMaskCheck) exitwith {_name};
	{
		if((_x#0) isEqualTo _charID) exitWith {
			_name = _x#1;
		};
	} forEach _saved;
	_name;
}] call compile_Global;

["A3PL_Player_OpenNametag", {
	private _player = param [0,objNull];
	private _charID = (_player getVariable ["character_id",""]);

	A3PL_Nametag_charID = _charID;
	private _saved = profileNamespace getVariable [format["A3FL_NameTags_%1",(player getVariable "character_id")],[]];
	private _name = "";

	{
		_sCharID = _x select 0;
		_sName = _x select 1;
		if(_sCharID == _charID) exitWith {
			_name = _sName;
		};
	} forEach _saved;

	createDialog "Dialog_Nametag";
	(findDisplay 5 displayCtrl 1600) ctrlSetText ("STR_UI_SetName_Save" call A3PL_Localize);
	ctrlSetText [1400, _name];
}] call compile_Global;

["A3PL_Player_SaveNametag", {
	_saved = profileNamespace getVariable [format["A3FL_NameTags_%1",(player getVariable "character_id")],[]];
	_name = ctrlText 1400;

	_id = -1;
	{
		_sCharID = _x select 0;
		if(_sCharID == A3PL_Nametag_charID) exitWith {
			_id = _forEachIndex;
		};
	} forEach _saved;

	if(_id > -1) then {
		_saved set [_id,[A3PL_Nametag_charID,_name]];
	} else {
		_saved pushBack [A3PL_Nametag_charID,_name];
	};
	profileNamespace setVariable [format["A3FL_NameTags_%1",(player getVariable "character_id")],_saved];
	closeDialog 0;
}] call compile_Global;

//hostage, spawn this
["A3PL_Player_TakeHostage",
{
	private _target = param [0,objNull];

	if (!(_target IN allPlayers)) exitwith {[("STR_A3PL_Player_YouAreNotLookingRealPerson" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((handgunWeapon player isEqualTo "") OR ((handgunWeapon player) IN Cant_Rob_With_This)) exitwith {[("STR_A3PL_Player_YouNeedAWeapon" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!isNil "A3PL_EnableHostage") exitwith {[("STR_A3PL_Player_YouAlreadyTakeSomeoneInHostage" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if ((_target distance2D player) > 3) exitwith {[("STR_A3PL_Player_ToFarToTakeThisPersonInHostage" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	player selectWeapon handgunWeapon player;

	A3PL_EnableHostage = true;
	A3PL_HostageMode = "hostage";
	A3PL_HostageTarget = _target;
	A3PL_HostageReloading = false;
	player setVariable["takingHostage",true,true];
	_target setVariable["takenHostage",true,true];
	player forceWalk true;

	{detach _x;} foreach (attachedObjects _target);

	_ehFired = player addEventHandler ["Fired",
	{
		if ((A3PL_HostageMode isEqualTo "hostage")) exitwith {
			if ((!isNull A3PL_HostageTarget) && ((handgunWeapon player) != "A3PL_Taser")) then {
				detach A3PL_HostageTarget;
				A3PL_HostageTarget setDamage 1;
				[A3PL_HostageTarget,"head","shrapnel"] call A3PL_Medical_ApplyWound;
				A3PL_HostageTarget setVariable ["A3PL_Medical_Blood",0,true];
			};
			A3PL_EnableHostage = false;
		};
	}];
	_ehReload = (findDisplay 46) displayAddEventHandler ["KeyDown",
	{
		if ((_this select 1) in actionKeys "ReloadMagazine") then {
			[] spawn {
				A3PL_HostageReloading = true;
				sleep 3.5;
				if (!isNil "A3PL_HostageReloading") then {A3PL_HostageReloading = false};
			};
			false;
		};
	}];

	player playAction "gesture_takehostage";
	[_target,"A3PL_TakenHostage"] remoteExec ["A3PL_Lib_SyncAnim",-2];
	_target attachto [player,[-0.05,0.2,-0.02]];

	_target setVariable ["tf_unable_to_use_radio", true];
	while {A3PL_EnableHostage} do
	{
		if ((A3PL_HostageMode isEqualTo "hostage") && !A3PL_HostageReloading) then { player playAction "gesture_takehostageloop"; };
		if ((A3PL_HostageMode isEqualTo "shoot") && !A3PL_HostageReloading) then { player playAction "gesture_takehostageshootloop"; };
		if(!(player getVariable["A3PL_Medical_Alive",true])) exitWith {};
		if(!(A3PL_HostageTarget getVariable["A3PL_Medical_Alive",true])) exitWith {};
		if(isNull A3PL_HostageTarget) exitWith {};
		sleep 0.5;
	};
	_target setVariable ["tf_unable_to_use_radio", false];
	player forceWalk false;
	player playAction "gesture_stop";
	player removeEventHandler ["Fired",_ehFired];
	(findDisplay 46) displayRemoveEventHandler ["KeyDown",_ehReload];
	A3PL_EnableHostage = nil; 
	A3PL_HostageMode = nil;
	A3PL_HostageTarget = nil; 
	A3PL_HostageReloading = nil;

	if((_target getVariable["A3PL_Medical_Alive",true]) && (player getVariable["A3PL_Medical_Alive",true])) then
	{
		[_target,"A3PL_ReleasedHostage"] remoteExec ["A3PL_Lib_SyncAnim",-2];
		[player,"A3PL_ReleaseHostage"] remoteExec ["A3PL_Lib_SyncAnim",-2];
		sleep 3;
		detach _target;
		[_target,""] remoteExec ["A3PL_Lib_SyncAnim",-2];
		[player,""] remoteExec ["A3PL_Lib_SyncAnim",-2];
	} else {
		if(player getVariable["A3PL_Medical_Alive",true]) then {[player,""] remoteExec ["A3PL_Lib_SyncAnim",-2];};
		if(_target getVariable["A3PL_Medical_Alive",true]) then {[_target,""] remoteExec ["A3PL_Lib_SyncAnim",-2];};
		detach _target;
	};
	player setVariable["takingHostage",nil,true];
}] call compile_Global;

["A3PL_Player_SetMarkers",
{
	private _job = player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
	private _faction = player getVariable ["faction","citizen"];
	private _array = Job_Waste_TrashMarkers;
	if((_job isEqualTo ("STR_Common_Job_Waste" call A3PL_Localize)) && {Player_MapFilter isEqualTo "ALL"}) then {
		{_x setMarkerAlphaLocal 1;} forEach _array;
	} else {
		{_x setMarkerAlphaLocal 0;} forEach _array;
	};
	private _array = Job_Deliver_Markers;
	if((_job isEqualTo ("STR_Common_Job_Deliver" call A3PL_Localize)) && {Player_MapFilter isEqualTo "ALL"}) then {
		{_x setMarkerAlphaLocal 1;} forEach _array;
	} else {
		{_x setMarkerAlphaLocal 0;} forEach _array;
	};
	private _array = Job_Security_Markers;
	if((_job isEqualTo ("STR_Common_Job_SecurityAgent" call A3PL_Localize)) && {Player_MapFilter isEqualTo "ALL"}) then {
		{_x setMarkerAlphaLocal 1;} forEach _array;
	} else {
		{_x setMarkerAlphaLocal 0;} forEach _array;
	};
	private _array = Job_Exterminator_Markers;
	if((_job isEqualTo ("STR_Common_Job_Exterminator" call A3PL_Localize)) && {Player_MapFilter isEqualTo "ALL"}) then {
		{_x setMarkerAlphaLocal 1;} forEach _array;
	} else {
		{_x setMarkerAlphaLocal 0;} forEach _array;
	};
	private _array = Job_Trucking_Markers;
	if((_job isEqualTo ("STR_Common_Job_Trucking" call A3PL_Localize)) && {Player_MapFilter isEqualTo "ALL"}) then {
		{_x setMarkerAlphaLocal 1;} forEach _array;
	} else {
		{_x setMarkerAlphaLocal 0;} forEach _array;
	};
	private _array = Job_BetterBuy_Markers;
	if((_job isEqualTo ("STR_Common_Job_BetterBuy" call A3PL_Localize)) && {Player_MapFilter isEqualTo "ALL"}) then {
		{_x setMarkerAlphaLocal 1;} forEach _array;
	} else {
		{_x setMarkerAlphaLocal 0;} forEach _array;
	};
	private _array = Job_TaxiMan_Markers;
	if((_job isEqualTo ("STR_Common_Job_Taxi" call A3PL_Localize)) && {Player_MapFilter isEqualTo "ALL"}) then {
		{_x setMarkerAlphaLocal 1;} forEach _array;
	} else {
		{_x setMarkerAlphaLocal 0;} forEach _array;
	};
	private _array = Job_Freight_Markers;
	if((_job isEqualTo ("STR_Common_Job_Freight" call A3PL_Localize)) && {Player_MapFilter isEqualTo "ALL"}) then {
		{_x setMarkerAlphaLocal 1;} forEach _array;
	} else {
		{_x setMarkerAlphaLocal 0;} forEach _array;
	};
	private _array = Job_FerryCaptin_Markers;
	if((_job isEqualTo ("STR_Common_Job_Captain" call A3PL_Localize)) && {Player_MapFilter isEqualTo "ALL"}) then {
		{_x setMarkerAlphaLocal 1;} forEach _array;
	} else {
		{_x setMarkerAlphaLocal 0;} forEach _array;
	};
	private _array = Job_Roadworker_Markers;
	if((_job isEqualTo ("STR_Common_Job_Roadworker" call A3PL_Localize)) && {Player_MapFilter isEqualTo "ALL"}) then {
		{_x setMarkerAlphaLocal 1;} forEach _array;
	} else {
		{_x setMarkerAlphaLocal 0;} forEach _array;
	};
	private _array = Job_Lumberjack_Markers;
	if((_job isEqualTo ("STR_Common_Job_Lumberjack" call A3PL_Localize)) && {Player_MapFilter isEqualTo "ALL"}) then {
		{_x setMarkerAlphaLocal 1;} forEach _array;
	} else {
		{_x setMarkerAlphaLocal 0;} forEach _array;
	};
	private _array = Job_Agricultor_Markers;
	if((_job isEqualTo ("STR_Common_Job_Agricultor" call A3PL_Localize)) && {Player_MapFilter isEqualTo "ALL"}) then {
		{_x setMarkerAlphaLocal 1;} forEach _array;
	} else {
		{_x setMarkerAlphaLocal 0;} forEach _array;
	};
	_array = Illegals_Markers;
	if(_faction IN [("STR_Common_FIFR" call A3PL_Localize),("STR_Common_FISD" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) then {
		{_x setMarkerAlphaLocal 0;} forEach _array;
	} else {
		if (Player_MapFilter IN ["ALL",("STR_A3PL_Player_IllegalActivities" call A3PL_Localize)]) then {
			{_x setMarkerAlphaLocal 0;} forEach _array;
		};
	};
	_array = ["Area_PirateYacht_1","Area_PirateYacht_2","A3PL_Marker_Hunting_1","A3PL_Marker_Hunting","A3PL_Marker_Hunting_3","A3PL_Marker_Hunting_2","A3PL_Marker_Fish4","A3PL_Marker_Fish3","A3PL_Marker_SallySpeedway","FIMiningArea","CemeteryArea","Area_DrugDealer9","Area_DrugDealer8","Area_DrugDealer7","Area_DrugDealer6","Area_DrugDealer5","Area_DrugDealer3","Area_DrugDealer2","Area_DrugDealer1","Area_DrugDealer","Area_DrugDealer10","Area_DrugDealer11","Area_DrugDealer12","Area_DrugDealer13","Area_DrugDealer14","A3PL_Markers_Fish6","A3PL_Markers_Fish1","LumberJack_Rectangle","A3PL_Marker_Sand1","A3PL_Marker_Sand2","A3PL_Marker_Fish1","A3PL_Marker_Fish2","A3PL_Marker_Fish8","A3PL_Marker_Fish7","A3PL_Marker_Fish6","A3PL_Marker_Fish5","Picking_Apple_1"];
	if(_faction != "fbi") then {
		{_x setMarkerAlphaLocal 0;} forEach _array;
	} else {
		{_x setMarkerAlphaLocal 1;} forEach _array;
	};
	if !(_job IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize)]) then {
		if (!isNil "A3PL_Police_GPSmarkers") then {
			{deleteMarkerLocal _x;} foreach A3PL_Police_GPSmarkers;
			A3PL_Police_GPSmarkers = nil;
		};
	};
	_array = ["Plantation_1","Plantation_2","Plantation_3","Plantation_4","Plantation_5","Plantation_6","Plantation_7","Plantation_8","Plantation_9","Plantation_10","Plantation_11",
		"Plantation_12","Plantation_13","Plantation_14","Plantation_15","Plantation_16","Plantation_17","Plantation_18","Plantation_19","Plantation_20"];
		{_x setMarkerAlphaLocal 0;} forEach _array;
    if((_faction isEqualTo "fbi") && {Player_MapFilter isEqualTo "ALL"}) then {
        {
            _marker = createMarkerLocal [format["Marker_%1",_x#0],_x#1];
            _marker setMarkerShapeLocal "ICON";
            _marker setMarkerTypeLocal "Mil_dot";
            _marker setMarkerTextLocal format[("STR_A3PL_Player_Plant" call A3PL_Localize)];
            _marker setMarkerSizeLocal [0.6,0.6];
            _x#0 setMarkerAlphaLocal 0.7;
        } forEach Server_Plantations;
        {format["Marker_%1",_x] setMarkerAlphaLocal 1;} forEach _array;
	} else {
		{format["Marker_%1",_x] setMarkerAlphaLocal 0;} forEach _array;
	};
}] call compile_Global;

["A3PL_Player_EscapeControls",
{
	for "_i" from 0 to 1 step 0 do {
		waitUntil {!isNull (findDisplay 49)};
		private["_abortButton", "_respawnButton", "_manuelButton", "_display"];
		disableSerialization;
		_display = (findDisplay 49);
		_abortButton = _display displayCtrl 104;
		_abortButton ctrlEnable false;
		_manuelButton = _display displayCtrl 122;
		_manuelButton ctrlEnable false;
		_manuelButton ctrlShow false;
		_respawnButton = _display displayCtrl 1010;
		_respawnButton ctrlEnable false;
		_respawnButton ctrlShow false;
		if((player getVariable["Zipped",false]) || (player getVariable["Cuffed",false])) then {
			_abortButton ctrlSetText ("STR_A3PL_Player_YouCantDisconnect" call A3PL_Localize);
		} else {
			[_abortButton, _display] spawn {
				_timeStamp = time + 15;
				waitUntil {
					(_this select 0) ctrlSetText format[("STR_A3PL_Player_Wait" call A3PL_Localize), ([(_timeStamp - time), "SS.MS"] call BIS_fnc_secondsToString)];
					(_this select 0) ctrlCommit 0;
					round(_timeStamp - time) <= 0 || isNull (_this select 1)
				};
				if (!(isNull (_this select 1))) then {
					if (alive player) then	{
						(_this select 0) ctrlSetText ("STR_A3PL_Player_YouCanDisconnect" call A3PL_Localize);
						(_this select 0) ctrlCommit 0;
						(_this select 0) ctrlEnable true;
					} else {
						(_this select 0) ctrlSetText ("STR_A3PL_Player_ImpossibleNow" call A3PL_Localize);
						(_this select 0) ctrlCommit 0;
					};
				};
			};
		};
		[] call A3PL_Player_SyncStatsToServer;
		sleep 0.5; 
		[player,false] remoteExec ["Server_Gear_Save", 2];
		waitUntil {isNull (findDisplay 49) || {!alive player}};
		if (!isNull (findDisplay 49) && {!alive player}) then {
			(findDisplay 49) closeDisplay 2;
		};
	};
}] call compile_Global;

["A3PL_Player_Whitelist", {
	params [["_charID","",[""]],["_faction","",[""]]];
	if(_faction isNotEqualTo "citizen") then {
		[format[("STR_A3PL_Player_YouHiredBy" call A3PL_Localize),toUpper _faction],Color_green] spawn A3PL_Notification;
	} else {
		[format[("STR_A3PL_Player_YoUFired" call A3PL_Localize)],Color_green] spawn A3PL_Notification;
		[("STR_Common_Job_Unemployed" call A3PL_Localize)] call A3PL_NPC_TakeJob;
	};
	player setVariable["faction",_faction,true];
	[_charID, _faction] remoteExec ["Server_Player_Whitelist",2];
}] call compile_Global;

["A3PL_Player_News",
{
	params [
		["_header","",[""]],
		["_line",[""]],
		["_sender","",[""]]
	];

	30 cutRsc ["FishersNews","plain"];
	_display = uiNamespace getVariable "FishersNews";
	_textHeader = _display displayCtrl 3001;
	_textHeader ctrlSetStructuredText parseText format [("STR_A3PL_Player_DiffusedBy" call A3PL_Localize),_header,_sender];
	_textHeader ctrlCommit 0;

	_textLine = _display displayCtrl 3002;
	_textLine ctrlSetStructuredText parseText format ["                         %1                         %1                         %1                         %1                         %1                         %1                         %1",_line];
	_textLine ctrlCommit 0;
	_textLinePos = ctrlPosition _textLine;
	_textLinePos set [0,-100];
	_textLine ctrlSetPosition _textLinePos;
	_textLine ctrlCommit 1500;

	_textClock = _display displayctrl 3003;
	_textClock ctrlSetText ([daytime,"HH:MM"] call bis_fnc_timetostring);
	_textClock ctrlCommit 0;

	uiSleep 30;
	30 cutText ["","plain"];
}] call compile_Global;

["A3PL_Player_CheckDebugVariables",{
	private _var = profileNamespace getVariable ["rscdebugconsole_expression",""];
	if(_var == "") exitWith {};
	profileNamespace setVariable ["rscdebugconsole_expression",""];
	[getPlayerUID player,(player getVariable ["character_id",""]),"Debug_SetVariables",[format ["Vars: %1",str(_var)]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

["A3PL_Player_Tackle",
{
	private _target = param [0,objNull];
	private _weapon = currentWeapon player;
	private _job = player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
	if(_job IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) exitWith {};
	if (_weapon IN Cant_Rob_With_This) exitwith {};
	if ((!isPlayer _target) || {isNull _target}) exitWith {};
	A3PL_Tackle = true;
	[player,"AwopPercMstpSgthWrflDnon_End2"] remoteExec ["A3PL_Lib_SyncAnim",0];
	sleep 0.08;
	[] remoteExec ["A3PL_Player_Tackled",_target];
	sleep 3;
	A3PL_Tackle = nil;
}] call compile_Global;

["A3PL_Player_Tackled",
{
	private _adminMode = player getVariable ["pVar_RedNameOn",false];
	if(_adminMode) exitWith {};
	if(!isNil "A3PL_Tackled") exitWith {};
	A3PL_Tackled = true;
	player playMoveNow "Incapacitated";
	disableUserInput true;
	private _obj = "Land_ClutterCutter_small_F" createVehicle ASLTOATL(visiblePositionASL player);
	_obj setPosATL ASLToATL(visiblePositionASL player);
	player attachTo [_obj,[0,0,0]];
	if (!([player,"head","concussion"] call A3PL_Medical_HasWound)) then {[player,"head","concussion"] call A3PL_Medical_ApplyWound;};
	sleep 15;
	[player,""] remoteExec ["A3PL_Lib_SyncAnim",0];
	player switchMove "AidlPpneMstpSnonWnonDnon_AI";
	disableUserInput false;
	detach player;
	deleteVehicle _obj;
	A3PL_Tackled = nil;
}] call compile_Global;

//https://community.bistudio.com/wiki/magazinesAmmoFull
["A3PL_Player_RepackMags",
{
	if (Player_ActionDoing) exitwith {[("STR_A3PL_Player_YouCantRepackMags" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _allMags = magazinesAmmoFull player;
	if((count _allMags) isEqualTo 0) exitWith {[("STR_A3PL_Player_YouDoNotHaveMags" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _toRepack = [];
	private _magLocations = [];
	{
		if !(_x#2) then {
			[_toRepack, _x#0, _x#1,false] call BIS_fnc_addToPairs;
			_magLocations pushback _x#4;
		};
	} forEach _allMags;
	if(_toRepack isEqualTo []) exitWith {[("STR_A3PL_Player_AllOfYourMagsAreFull" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _finalPack = [];
	private _ammoCnt = 0;
	{
		_ammoCnt = getNumber (configfile >> "CfgMagazines" >> _x#0 >> "count");
		_bullets = _x#1;
		for "_i" from 0 to (_x#1/_ammoCnt) do {
			if(_bullets < _ammoCnt) then {
				_finalPack pushback [_x#0,_bullets,_magLocations#_i];
			} else {
				_finalPack pushback [_x#0,_ammoCnt,_magLocations#_i];
			};
			_bullets = _bullets - _ammoCnt;
			if(_bullets <= 0) exitWith {};
		};
	} forEach _toRepack;

	if !(currentWeapon player isEqualTo "") then {
		A3PL_Holster = currentWeapon player;
		player action ["SwitchWeapon", player, player, 100];
		player switchCamera cameraView;
	};

	player playMoveNow 'AmovPercMstpSnonWnonDnon_AinvPercMstpSnonWnonDnon';
	[("STR_A3PL_Player_Repacks" call A3PL_Localize),8] spawn A3PL_Lib_LoadAction;
	waitUntil{Player_ActionDoing};
	while {Player_ActionDoing} do {
		if (!(player getVariable["A3PL_Medical_Alive",true])) exitWith {Player_ActionInterrupted = true;};
		if ((vehicle player) isNotEqualTo player) exitwith {Player_ActionInterrupted = true;};
		if (player getVariable ["Incapacitated",false]) exitwith {Player_ActionInterrupted = true;};
		if !((animationState player) IN ["ainvpercmstpsnonwnondnon","amovpercmstpsnonwnondnon_ainvpercmstpsnonwnondnon"]) then {player playMoveNow 'AmovPercMstpSnonWnonDnon_AinvPercMstpSnonWnonDnon';};
	};
	if((vehicle player) isEqualTo player) then {player playActionNow "Stand";};
	if(Player_ActionInterrupted) exitWith {[("STR_A3PL_Player_RepackCancelled" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	{
		player removeMagazines _x#0;
	} forEach _finalPack;
	{
		switch (_x#2) do {
			case "Uniform": {(uniformContainer player) addMagazineAmmoCargo [_x#0, 1, _x#1];};
			case "Vest": {(vestContainer player) addMagazineAmmoCargo [_x#0, 1, _x#1];};
			case "Backpack": {(backpackContainer player) addMagazineAmmoCargo [_x#0, 1, _x#1];};
		};
	} forEach _finalPack;
	[("STR_A3PL_Player_YouRepacked" call A3PL_Localize),Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Player_OpenMap",
{
	disableSerialization;
	private ["_listbox"];
	private _map = findDisplay 12;
	private _findBackground = _map displayCtrl 1570;
	private _findListbox = _map displayCtrl 1569;
	if(isNull _findBackground) then {
		_background = _map ctrlCreate ["RscPicture", 1570];
		_background ctrlSetPosition [-0.2931 * safezoneW + safezoneX,0.1592 * safezoneH + safezoneY,0.799219 * safezoneW,0.824 * safezoneH];
		_background ctrlSetText "\A3PL_Common\GUI\A3PL_MapFilter.paa";
		_background ctrlCommit 0;
	};
	if (isNull _findListbox) then {
		_listbox = _map ctrlCreate ["RscCheckListBox", 1569];
		_listbox ctrlSetPosition [0.004 * safezoneW + safezoneX, 0.816 * safezoneH + safezoneY, 0.203 * safezoneW, 0.1565 * safezoneH];
		_listbox ctrlSetBackgroundColor [0,0,0,0];
		_listbox ctrlCommit 0;
		_listbox ctrlAddEventHandler ["LBSelChanged",{[(_this#0)] call A3PL_Player_SelectFilter;}];
	} else {
		_listbox = _map displayCtrl 1569;
	};

	lbClear _listbox;
	_listbox lbAdd ("STR_A3PL_Player_ShowEverything" call A3PL_Localize);
	_listbox lbSetValue[(lbSize _listbox)-1,-1];
	_listbox lbSetData[(lbSize _listbox)-1,"ALL"];

	if(Player_SelectedMarkers isEqualTo []) then {
		_listbox lbSetPictureRight[0, "\A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_checked_ca.paa"];
	} else {
		_listbox lbSetPictureRight[0, "\A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_unchecked_ca.paa"];
	};
	{
		_listbox lbAdd _x#0;
		_listbox lbSetValue[(lbSize _listbox)-1,_forEachIndex];
		_listbox lbSetData[(lbSize _listbox)-1,str(_x#1)];
		if (_forEachIndex isEqualTo 1) then {continue;};
		if ((_x#0) IN Player_SelectedMarkers) then {
			_listbox lbSetPictureRight[(lbSize _listbox)-1, "\A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_checked_ca.paa"];
		} else {
			_listbox lbSetPictureRight[(lbSize _listbox)-1, "\A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_unchecked_ca.paa"];
		};
	} forEach getArray(missionConfigFile >> "A3PL_mapAreas" >> "filters");
}] call compile_Global;

["A3PL_Player_SelectFilter", {
	private _map = findDisplay 12;
	private _filterList = _map displayCtrl 1569;
	private _curSel = lbCurSel _filterList;
	if(_curSel IN [-1,2]) exitWith {};

	private _mapMarkers = [];
	private _allFilters =  getArray(missionConfigFile >> "A3PL_mapAreas" >> "filters");
	private _disallowedMapMarkers = getArray(missionConfigFile >> "A3PL_mapAreas" >> "exclude");
	private _filterName = if(_curSel isEqualTo 0) then {"Tout montrer"} else {(_allFilters select (_filterList lbValue _curSel))#0};
	{
		if((markerType _x) isNotEqualTo "Empty" && {!(_x IN _disallowedMapMarkers)}) then {_mapMarkers pushBack _x;};
	} forEach allMapMarkers;
	private	_MustSeeMarkers = _mapMarkers - Server_StartMarkers;

	if(_curSel isEqualTo 0) then {
		{_x setMarkerAlphaLocal 1;} forEach _mapMarkers;
		Player_SelectedMarkers = [];
		_filterList lbSetPictureRight [0, "\A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_checked_ca.paa"];
	} else {
		_filterList lbSetPictureRight [0, "\A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_unchecked_ca.paa"];
		if (_curSel isEqualTo 1) then {
			Player_SelectedMarkers = [_filterName];
		} else {
			if (_filterName IN Player_SelectedMarkers) then {
				Player_SelectedMarkers = Player_SelectedMarkers - [_filterName];
			} else {
				Player_SelectedMarkers pushBackUnique _filterName;
			};
		};
		_filterDataMarkers = [];
		{
			if (_x#0 IN Player_SelectedMarkers) then {_filterDataMarkers append _x#1};
		} forEach _allFilters;
		{
			if !(_x IN _filterDataMarkers) then {_x setMarkerAlphaLocal 0;} else {_x setMarkerAlphaLocal 1;};
		} forEach _mapMarkers;
	};
	{_x setMarkerAlphaLocal 1;} foreach _MustSeeMarkers;
	call A3PL_Player_SetMarkers;

	if(!isNull _filterList) then {
		for "_i" from 1 to (lbSize _filterList)-1 do {
			if (_i isEqualTo 2) then {continue;};
			if ((_filterList lbText _i) IN Player_SelectedMarkers) then {
				_filterList lbSetPictureRight [_i, "\A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_checked_ca.paa"];
			} else {
				_filterList lbSetPictureRight [_i, "\A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_unchecked_ca.paa"];
			};
		};
	};
}] call compile_Global;

["A3LL_Player_EnterLottery",
{
	private _action = [format[("STR_A3PL_Player_ReallyWantToBuyTicket" call A3PL_Localize), Lottery_Ticket_Price]] call A3PL_Lib_ConfirmationDialog;
	if(!isNil "_action" && {!_action}) exitWith {[("STR_A3PL_Player_YouDeciedNotBuyTicket" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if(player IN Server_LotteryEntries) exitWith {[("STR_A3PL_Player_AlreadyHaveATicket" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[Lottery_Ticket_Price] call A3PL_Bank_HowToPay;
	[] spawn {
		waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
		if (!(player getVariable "paymentResult")) exitWith {};
		[("STR_A3PL_Player_YouBoughtTicketForNextLottery" call A3PL_Localize),Color_Green] call A3PL_Notification;
		Server_LotteryEntries pushBack player;
		publicVariableServer "Server_LotteryEntries";
	};
}] call compile_Global;

["A3PL_Player_Pee",
{
	if (Pee_System == false) exitWith {};

	player spawn {
		[player, "Acts_AidlPercMstpSlowWrflDnon_pissing"] remoteExec ["A3PL_Lib_SyncAnim",-2];
		playSound3D ["A3PL_Common\effects\pee.ogg",player, false, getPosASL player, 1, 1, 3];
		_dir = getDir player;
		_stream = "#particlesource" createVehicleLocal [0,0,0];
		_stream setParticleRandom [0,[0.004,0.004,0.004],[0.01,0.01,0.01],30,0.01,[0,0,0,0],1,0.02,360];
		_stream setDropInterval 0.001;
		_stream attachTo [player,[0.1,0.15,-0.10],"Pelvis"] ;
		for "_i" from 0 to 1 step 0.01 do {
			_stream setParticleParams [["\a3\data_f\ParticleEffects\Universal\Universal.p3d",16,12,8],"","BillBoard",1,3,[0,0,0],[sin (_dir) * _i,cos (_dir) * _i,0],0,1.5,1,0.1,[0.02,0.02,0.1],[[0.8,0.7,0.2,0.1],[0.8,0.7,0.2,0.1],[0.8,0.7,0.2,0]],[1],1,0,"","",_stream,0,true,0.1,[[0.8,0.7,0.2,0]]] ;
			sleep 0.02;
		};
		sleep 1;
		for "_i" from 1 to 0.4 step -0.01 do {
			_stream setParticleParams [["\a3\data_f\ParticleEffects\Universal\Universal.p3d",16,12,8],"","BillBoard",1,3,[0,0,0],[sin (_dir) * _i,cos (_dir) * _i,0],0,1.5,1,0.1,[0.02,0.02,0.1],[[0.8,0.7,0.2,0.1],[0.8,0.7,0.2,0.1],[0.8,0.7,0.2,0]],[1],1,0,"","",_stream,0,true,0.1,[[0.8,0.7,0.2,0]]] ;
			sleep 0.02;
		};
		for "_i" from 0.4 to 0.8 step 0.02 do {
			_stream setParticleParams [["\a3\data_f\ParticleEffects\Universal\Universal.p3d",16,12,8],"","BillBoard",1,3,[0,0,0],[sin (_dir) * _i,cos (_dir) * _i,0],0,1.5,1,0.1,[0.02,0.02,0.1],[[0.8,0.7,0.2,0.1],[0.8,0.7,0.2,0.1],[0.8,0.7,0.2,0]],[1],1,0,"","",_stream,0,true,0.1,[[0.8,0.7,0.2,0]]] ;
			sleep 0.02;
		};
		deleteVehicle _stream;
	};
	Player_Pee = 100;
	player setVariable ["player_pee",Player_Pee,false];
}] call compile_Global;

["A3PL_Player_Sleep",
{
	if (Sleep_System == false) exitWith {};
	player spawn {
		private _called = "";
		private _format = format[("STR_A3PL_Player_YouSleeping" call A3PL_Localize)];
		playSound ["A3PL_Common\effects\sleep.ogg",player, false, getPosASL player, 0.5, 1, 2];
		cutText[format["%1 %2",_format,_called],"BLACK FADED", 600, false, true, false];
		sleep 5;
		cutText[format["%1 %2",_format,_called],"BLACK IN", -1, false, true, false];
	};
	cutText["","BLACK IN"];
	if (Pee_System == true) then {Player_Pee = Player_Pee - 20;};
	Player_Sleep = 100;
	player setVariable ["player_sleep",Player_Sleep,false];
}] call compile_Global;

["A3PL_Player_receivePlayTime", {
	params ["_result"];
    Player_PlayTime = _result;
}] call compile_Global;

["A3PL_Player_ParamMenu", {
	createDialog "Dialog_Param";
	(findDisplay 984210) call A3PL_Dialog_Localize;

	[
		["A3PL_Twitter_Enabled", 1002],
		["Player_EnableID", 1005],
		["A3PL_ShowGPS", 1012],
		["A3PL_MetricUnits", 1014]
	] apply {
		private _variable = profileNamespace getVariable [_x select 0, false];
		private _idc = _x select 1;
		((findDisplay 984210) displayCtrl _idc) ctrlSetText (if (_variable) then {("STR_A3PL_Player_Activated" call A3PL_Localize)} else {("STR_A3PL_Player_Deactivated" call A3PL_Localize)});
		((findDisplay 984210) displayCtrl _idc) ctrlSetTextColor (if (_variable) then {[0,1,0,1]} else {[1,0,0,1]});
	};
}] call compile_Global;

["A3PL_Player_ParamToggle", {
	params ["_buttonIdc"];

	private _variableName = switch (_buttonIdc) do {
		case 1600: {"A3PL_Twitter_Enabled"};
		case 1601: {"Player_EnableID"};
		case 1605: {"A3PL_ShowGPS"};
		case 1606: {"A3PL_MetricUnits"};
		default {""};
	};

	if (_variableName != "") then {
		private _currentValue = profileNamespace getVariable [_variableName, false];
		private _newValue = !_currentValue;
		profileNamespace setVariable [_variableName, _newValue];
		saveProfileNamespace;

		private _textIdc = switch (_buttonIdc) do {
			case 1600: {1002};
			case 1601: {1005};
			case 1605: {1012};
			case 1606: {1014};
			default {-1};
		};

		if (_textIdc != -1) then {
			((findDisplay 984210) displayCtrl _textIdc) ctrlSetText (if (_newValue) then {("STR_A3PL_Player_Activated" call A3PL_Localize)} else {("STR_A3PL_Player_Deactivated" call A3PL_Localize)});
			((findDisplay 984210) displayCtrl _textIdc) ctrlSetTextColor (if (_newValue) then {[0,1,0,1]} else {[1,0,0,1]});
		};
	};
}] call compile_Global;