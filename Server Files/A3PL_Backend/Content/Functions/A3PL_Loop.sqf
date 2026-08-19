/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
['A3PL_Loop_Setup', {
	if (Help) then {["itemAdd", ["Loop_HelpMessages", {call A3PL_Loop_HelpMessages;}, 900, 'seconds']] call BIS_fnc_loop;};
	["itemAdd", ["Loop_Paycheck", {call A3PL_Loop_Paycheck;}, 1200, 'seconds']] call BIS_fnc_loop;
	["itemAdd", ["Loop_Taxes", {call A3PL_Loop_Taxes;}, 3600, 'seconds',{!isNil {player getVariable ["house",nil]} || {!isNil {player getVariable ["warehouse",nil]}}}, {isNil {player getVariable ["house",nil]} && {isNil {player getVariable ["warehouse",nil]}}}]] call BIS_fnc_loop;
	["itemAdd", ["Loop_Taxes_Companies", {call A3PL_Loop_Taxes_Companies;}, 3600, 'seconds',{}]] call BIS_fnc_loop;
    ["itemAdd", ["Loop_HUD", {call A3PL_HUD_Loop;}, 1, 'seconds']] call BIS_fnc_loop;
	// Check if player has the efficient_metabolism trait
	private _traits = player getVariable ["Player_Traits", []];
	private _hasEfficientMetabolismTrait = "efficient_metabolism" in _traits;
	// Efficient_metabolism trait: increase loop duration from 290s to 435s (50% longer)
	private _saturationLoopDuration = 290;
	if (_hasEfficientMetabolismTrait) then {
		_saturationLoopDuration = 435;
	};
	["itemAdd", ["Loop_Saturation", {call A3PL_Loop_Hunger;call A3PL_Loop_Thirst;call A3PL_Loop_Pee;call A3PL_Loop_Sleep;}, _saturationLoopDuration, 'seconds']] call BIS_fnc_loop;
	["itemAdd", ["Loop_SyncStats", {call A3PL_Player_SyncStatsToServer;}, 300, 'seconds']] call BIS_fnc_loop;
	["itemAdd", ["Loop_NameTags", {[] spawn A3PL_Player_NameTags;}, 1, 'seconds']] call BIS_fnc_loop;
	["itemAdd", ["Loop_BusinessTags", {[] spawn A3PL_Player_BusinessTags;}, 5, 'seconds']] call BIS_fnc_loop;
	["itemAdd", ["Loop_RoadworkerMarkers", {[] spawn A3PL_JobRoadWorker_MarkerLoop;}, 15, 'seconds'],{ (player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) == ("STR_Common_Company" call A3PL_Localize) }, { (player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) != ("STR_Common_Company" call A3PL_Localize)}] call BIS_fnc_loop;
	["itemAdd", ["Loop_Medical", {[] spawn A3PL_Medical_Loop;}, 1, 'seconds',{ ((player getVariable ["A3PL_Wounds",[]]) isNotEqualTo []) || (player getVariable ["bloodOverlay",false]) },{ ((player getVariable ["A3PL_Wounds",[]]) isEqualTo []) && !(player getVariable ["bloodOverlay",false]) }]] call BIS_fnc_loop;
	["itemAdd", ["Loop_GPS", {call A3PL_Police_GPS;}, 4, 'seconds',{ player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize)] }, { !((player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize)]))}]] call BIS_fnc_loop;
	["itemAdd", ["Loop_Drugs", {[] spawn A3PL_Drugs_Loop;}, 30, 'seconds',{ player getVariable ["drugs",false] },{ !(player getVariable["drugs",false]) }]] call BIS_fnc_loop;
	["itemAdd", ["Loop_Alcohol", {[] spawn A3PL_Alcohol_Loop;}, 30, 'seconds',{ player getVariable ["alcohol",false] },{ !(player getVariable["alcohol",false]) }]] call BIS_fnc_loop;
	["itemAdd", ["Loop_JailMarkers", {call A3PL_Prison_Markers;}, 30, 'seconds',{ (player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) isEqualTo ("STR_Common_FISD" call A3PL_Localize) },{ ((player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) isNotEqualTo ("STR_Common_FISD" call A3PL_Localize)) && isNil "A3PL_Inmates_Markers" }]] call BIS_fnc_loop;
	["itemAdd", ["Loop_MoneyBagWater", {call A3PL_BHeist_Loop;}, 10, 'seconds',{backpack player isEqualTo "A3PL_Backpack_Money" && surfaceIsWater position player && (((getPosASLW player)#2) <= -2)}, {!(backpack player isEqualTo "A3PL_Backpack_Money" || surfaceIsWater position player || (((getPosASLW player)#2) <= -2))}]] call BIS_fnc_loop;
	["itemAdd", ["Loop_BetterBuyDelete", {call A3PL_Loop_BetterBuyDelete;}, 30, 'seconds',{(player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) isEqualTo ("STR_Common_Job_BetterBuy" call A3PL_Localize)},{((player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) isNotEqualTo ("STR_Common_Job_BetterBuy" call A3PL_Localize)) && (A3PL_BetterBuy isEqualTo [])}]] call BIS_fnc_loop;
	["itemAdd", ["Loop_Blindfold", {[] spawn A3PL_Loop_Blindfold;}, 5, 'seconds',{(player getVariable["Blindfolded",false])},{sleep 2; (isNil "Player_Blinded")}]] call BIS_fnc_loop;
	["itemAdd", ["Loop_RoadSigns", {call A3PL_Loop_RoadSigns;}, 5, 'seconds']] call BIS_fnc_loop;
	["itemAdd", ["Loop_getNearLocation", {[position player, false, true] call PO_Lib_getNearLocation;}, 5, 'seconds']] call BIS_fnc_loop;
	["itemAdd", ["Loop_PlayTime", {call A3PL_Loop_Playtime;}, 60, 'seconds']] call BIS_fnc_loop;
	["itemAdd", ["Loop_AmericanExpressCosts", {call A3PL_Bank_AmericanExpressCosts;}, 3600, 'seconds']] call BIS_fnc_loop;
	["itemAdd", ["Loop_SixthSense", {call A3PL_Loop_SixthSense;}, 10, 'seconds', {"sixth_sense" in (player getVariable ["Player_Traits", []])}, {!("sixth_sense" in (player getVariable ["Player_Traits", []]))}]] call BIS_fnc_loop;
	["itemAdd", ["Loop_AdrenalineCheck", {call A3PL_Loop_AdrenalineCheck;}, 2, 'seconds', {"adrenaline_junkie" in (player getVariable ["Player_Traits", []])}, {!("adrenaline_junkie" in (player getVariable ["Player_Traits", []]))}]] call BIS_fnc_loop;
	if (Halloween) then {["itemAdd", ["Hw_angel_loop", {[] spawn A3PL_Halloween_Randomiser;}, 30, 'seconds']] call BIS_fnc_loop;};
    if (Teamspeak_Protection) then {["itemAdd", ["Loop_TaskForceRadio", {call A3FL_Loop_TaskForceRadioCheck;}, 10, 'seconds']] call BIS_fnc_loop;};
}] call compile_Global;


["A3PL_Loop_HelpMessages",
{
	notification =
	{
		[ format["<t size='0.75' color='#Fffaf0'>%1</t>",_this], 0,1,20,8,2,3] spawn bis_fnc_dynamicText;
	};

	_selection = Help_Messages call bis_fnc_selectrandom;
	Help_Messages = Help_Messages - [_selection];
	(_selection call A3PL_Localize) call notification;
}] call compile_Global;

["A3PL_Loop_Playtime",
{
	Player_PlayTime = Player_PlayTime + 1;
	[player,Player_PlayTime] remoteExec ["Server_Player_SavePlayTime",2];
	if (PlayTime_Gain) then {
		if (Player_PlayTime isEqualTo 60) then {
			[format[("STR_A3PL_Loop_FirstHourOnTheServer" call A3PL_Localize),PlayTime_1Hour_Gain],Color_Green] call A3PL_Notification;
			private _playerCash = player getVariable["Player_Cash",0];
			player setvariable ["Player_Cash",_playerCash+PlayTime_1Hour_Gain,true];
		};
	};
}] call compile_Global;

["A3FL_Loop_TaskForceRadioChannel", {
    [("STR_A3PL_Loop_NotOnTFAR" call A3PL_Localize),Color_Red] call A3PL_Notification;
    uiSleep 45;
    if !((call TFAR_fnc_getTeamSpeakChannelName) in Teamspeak_Whitelisted_Channels) then {
        ["Teamspeak", false, true] call BIS_fnc_endMission;
    };
}] call compile_Global;

["A3FL_Loop_TaskForceRadioServer", {
    [("STR_A3PL_Loop_NotOnTS3" call A3PL_Localize),Color_Red] call A3PL_Notification;
    uiSleep 45;
    [("STR_A3PL_Loop_NotOnTS3WillBeDisconnected" call A3PL_Localize),Color_Red] call A3PL_Notification;
    uiSleep 2;
	call A3FL_Kick;
}] call compile_Global;

["A3FL_Kick", {
	private _getbypass = player getVariable ["A3PL_Bypass_TFAR",false];
    if (!_getbypass) exitWith {
		if !([Teamspeak_Server_Name, call TFAR_fnc_getTeamSpeakServerName] call BIS_fnc_inString) then {
			["Teamspeak", false, true] call BIS_fnc_endMission;
		};
	};
}] call compile_Global;

["A3FL_Loop_TaskForceRadioCheck", {
    private _getbypass = player getVariable ["A3PL_Bypass_TFAR",false];
    if ((pVar_AdminLevel < 7) && (!_getbypass) && !(getPlayerUID player IN ["76561198170351694","76561198147147468"])) exitwith { // if ((pVar_AdminLevel < 7) or !_adminMode) exitwith {
		if (([Teamspeak_Server_Name, (call TFAR_fnc_getTeamSpeakServerName)] call BIS_fnc_inString) && {call TFAR_fnc_isTeamSpeakPluginEnabled}) then {
            if !((call TFAR_fnc_getTeamSpeakChannelName) in Teamspeak_Whitelisted_Channels) then {
                [] spawn A3FL_Loop_TaskForceRadioChannel;
        };
		} else {
			[] spawn A3FL_Loop_TaskForceRadioServer;
		};
	};
}] call compile_Global;

["A3FL_Loop_LockView", {
	if (isDedicated) exitWith {};
	["A3FL_Loop_LockView", "onEachFrame", {
		if(Player_LockView) then {
		if((cameraView isEqualTo "EXTERNAL") && ((vehicle player) isEqualTo player)) then {player switchCamera "INTERNAL";};
		if(Player_LockView_Time <= time) then {Player_LockView = false;};
	};
	}] call BIS_fnc_addStackedEventHandler;
}] call compile_Global;

["A3PL_Loop_RoadSigns",
{
	disableSerialization;
	if(isNil "A3PL_Last_Road") then {A3PL_Last_Road = "";};
	if(isNil "A3PL_Last_RoadID") then {A3PL_Last_RoadID = 0;};

	private _roadObject = str(roadAt(vehicle player));
	private _roadID = parseNumber((_roadObject splitString ":") select 0);
	private _title = "";

	if(A3PL_Last_RoadID != _roadID) then {
		A3PL_Last_RoadID = _roadID;
		{
			_a = _x select 0;
			_b = _x select 1;

			if(_a < _b) then {
				if((_roadID >= _a) && {_roadID <= _b}) exitWith {
					_title = _x select 2;
				};
			} else {
				if((_roadID >= _b) && {_roadID <= _a}) exitWith {
					_title = _x select 2;
				};
			};
		} forEach Server_Addresses_Roads;
		if !(_title isEqualTo "") then {
			if(_title != A3PL_Last_Road) then {
				A3PL_Last_Road = _title;
				[] spawn {
					disableSerialization;
					private _road = A3PL_Last_Road;
					private _display = uiNamespace getVariable ["A3PL_HUDDisplay",nil];
					if(isNil "_display") exitWith {};
					private _ctrl = _display displayCtrl 9520;
					private _ctrlBack = _display displayCtrl 9521;

					_ctrl ctrlSetStructuredText parseText format ["<t font='PuristaMedium' align='center' size='2' >%1</t>",_road];
					_ctrl ctrlSetFade 0;
					_ctrl ctrlCommit 0.5;
					_ctrlBack ctrlSetFade 0;
					_ctrlBack ctrlCommit 0.5;

					sleep 3;
					if(_road != A3PL_Last_Road) exitWith {};

					_ctrl ctrlSetFade 1;
					_ctrl ctrlCommit 0.5;
					_ctrlBack ctrlSetFade 1;
					_ctrlBack ctrlCommit 0.5;
				};
			};
		};
	};
}] call compile_Global;

["A3PL_Loop_Taxes_Companies",
{
    private _charID = (player getVariable ["character_id",""]);
    private _isCorporate = [_charID] call A3PL_Config_InCompany;
    private _cid = [_charID] call A3PL_Config_GetCompanyID;
    private _isBoss = ([_charID] call A3PL_Config_IsCompanyBoss);
    if (!_isCorporate) exitWith {};
    if (!_isBoss) exitWith {};
    if(isNil "Company_Taxes") then {Company_Taxes=0;};

    private _notification = "";
    private _totalTaxes = 0;

    _totalTaxes = _totalTaxes + Company_Taxes_Amount;
    if(_notification isNotEqualTo "") then {_notification=format["%1<br/>",_notification]};
    _notification = format[("STR_A3PL_Loop_CompanyTaxes" call A3PL_Localize),_notification,[Company_Taxes_Amount, 1, 0, true] call CBA_fnc_formatNumber];

    Company_Taxes = Company_Taxes + _totalTaxes;

    [_cid, -(_totalTaxes), ("STR_A3PL_Loop_CompanyTaxe" call A3PL_Localize)] remoteExec ["Server_Company_SetBank",2];
    [("STR_Common_FederalReserve" call A3PL_Localize),_totalTaxes] remoteExec ["Server_Government_AddBalance",2];
    [format [("STR_A3PL_Loop_CompanyTaxesWithdrawed" call A3PL_Localize),_notification,[_totalTaxes, 1, 0, true] call CBA_fnc_formatNumber],Color_Orange] call A3PL_Notification;
}] call compile_Global;

["A3PL_Loop_Taxes",
{
	private _house = player getVariable ["house",nil];
	private _warehouse = player getVariable["warehouse",nil];
	private _crackhouse = player getVariable["crackhouse",nil];
	if(isNil "_house" && {isNil "_warehouse"} && {isNil "_crackhouse"}) exitWith {};
	if(isNil "Player_Taxes") then {Player_Taxes=0;};

	private _charID = (player getVariable ["character_id",""]);
	private _notification = "";
	private _totalTaxes = 0;
	if(!isNil "_house") then {
		private _houseRoommates = _house getVariable ["owner",[]];
		private _housingTaxes = [_house,1] call A3PL_Housing_GetData;
		if(_charID IN _houseRoommates) then {_housingTaxes = round(_housingTaxes/(count(_houseRoommates)));};
		_totalTaxes = _totalTaxes + _housingTaxes;
		if(_notification isNotEqualTo "") then {_notification=format["%1<br/>",_notification]};
		_notification = format[("STR_A3PL_Loop_HouseTaxe" call A3PL_Localize),_notification,[_housingTaxes, 1, 0, true] call CBA_fnc_formatNumber];
	};
	if(!isNil "_warehouse") then {
		private _warehouseRoommates = _warehouse getVariable ["owner",[]];
		private _warehouseTaxes = [_warehouse,1] call A3PL_Warehouses_GetData;
		private _isBoss = ([_charID] call A3PL_Config_IsCompanyBoss);
		if(_isBoss) then {
			[("STR_A3PL_Loop_WarehouseTaxePaidByGov" call A3PL_Localize),Color_red] call A3PL_Notification
		} else {
			if(_charID IN _warehouseRoommates) then {_warehouseTaxes = round(_warehouseTaxes/(count(_warehouseRoommates)));};
			_totalTaxes = _totalTaxes + _warehouseTaxes;
			if(_notification isNotEqualTo "") then {_notification=format["%1<br/>",_notification]};
			_notification = format[("STR_A3PL_Loop_WarehouseTaxe" call A3PL_Localize),_notification,[_warehouseTaxes, 1, 0, true] call CBA_fnc_formatNumber];
		};
	};
	if(!isNil "_crackhouse") then {
		private _crackhouseRoommates = _crackhouse getVariable ["owner",[]];
		private _crackhouseTaxes = [_crackhouse,1] call A3PL_Crackhouses_GetData;
		if(_charID IN _crackhouseRoommates) then {_crackhouseTaxes = round(_crackhouseTaxes/(count(_crackhouseRoommates)));};
		_totalTaxes = _totalTaxes + _crackhouseTaxes;
		if(_notification isNotEqualTo "") then {_notification=format["%1<br/>",_notification]};
		_notification = format[("STR_A3PL_Loop_CrackhouseTaxe" call A3PL_Localize),_notification,[_crackhouseTaxes, 1, 0, true] call CBA_fnc_formatNumber];
	};

	Player_Taxes = Player_Taxes + _totalTaxes;

	private _hasBankAccount = [player,1] call A3PL_Bank_HasAccount;
	if (!_hasBankAccount) exitwith {
		[("STR_A3PL_Loop_DoNotHaveMoneyToPayTax" call A3PL_Localize),Color_Red] call A3PL_Notification;
		private _debts = player getVariable["Player_Debt",0];
		player setVariable["Player_Debt",_debts-_totalTaxes];
	};
	private _playerBank = player getVariable["Player_Bank",0];
	player setVariable["Player_Bank",_playerBank-_totalTaxes,true];
	[("STR_Common_FederalReserve" call A3PL_Localize),_totalTaxes] remoteExec ["Server_Government_AddBalance",2];
	[format [("STR_A3PL_Loop_TaxPaid" call A3PL_Localize),_notification,[_totalTaxes, 1, 0, true] call CBA_fnc_formatNumber],Color_Orange] call A3PL_Notification;
}] call compile_Global;

["A3PL_Loop_Paycheck",
{
	if(!(player getVariable["A3PL_Medical_Alive",true])) exitWith {};
    private _job = player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
    private _factionJobs = [("STR_Common_FIFR" call A3PL_Localize),("STR_Common_FISD" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)];
    private _payAmount = [_job] call A3PL_Config_GetPaycheckPay;
    private _done = false;

    call A3PL_Gang_CapturedPaycheck;
    if(_job IN _factionJobs) then {
        _done = true;
        _payAmount = call A3PL_Government_FactionPay;
    } else {
        private _inCompany = [(player getVariable ["character_id",""])] call A3PL_Config_InCompany;
        if(_inCompany && {_job isEqualTo ("STR_Common_Company" call A3PL_Localize)}) then {
			_pName = player getVariable["name","John Doe"];
			_cid = [(player getVariable ["character_id",""])] call A3PL_Config_GetCompanyID;
            _done = true;
            _payAmount = call A3PL_Company_Paycheck;
			[_cid, _payAmount, format[("STR_A3PL_Loop_Salary" call A3PL_Localize),_pName,_payAmount]] remoteExec ["Server_Company_AddLog",2];
        };
    };

    if (!_done) then {
        private _nameCheck = (tolower profileNameSteam) find Server_Name;
        if (_nameCheck != -1) then {
            _payAmount = (_payAmount * A3PL_Event_Paycheck) + Paycheck_Amount_With_ServerName_in_SteamProfile;
        } else {
            _payAmount = _payAmount * A3PL_Event_Paycheck;
        };
    };
    if (_payAmount isEqualTo 0) then {} else {[format[("STR_A3PL_Loop_PaycheckReceived" call A3PL_Localize),_payAmount], Color_green] call A3PL_Notification;};

    if(isNil "Player_Paycheck") then {Player_Paycheck = _payAmount;} else {Player_Paycheck = Player_Paycheck + _payAmount;};
    [player, Player_Paycheck] remoteExec ["Server_Player_UpdatePaycheck",2];
    Player_PayCheckTime = 0;

	call A3PL_Bank_CollectDebts;
}] call compile_Global;

["A3PL_Loop_Hunger",
{
	private _amount = round(random(3));
	if(player getVariable ["pVar_RedNameOn",false]) exitWith {};

	if (player_ItemClass isEqualTo "popcornbucket") exitwith {
		Player_Item attachTo [player,[0,0,0],"RightHand"];
		player playActionNow "gesture_eat";
	};

	Player_Hunger = Player_Hunger - _amount;
	if ((Player_Hunger >= 45) && (Player_Hunger <= 50) && (isNil "A3PL_HungerWarning1") && (!(player getVariable ["Incapacitated",false]))) then {
		A3PL_HungerWarning1 = true;
	};

	if ((Player_Hunger >= 15) && (Player_Hunger <= 20) && (isNil "A3PL_HungerWarning2") && (!(player getVariable ["Incapacitated",false]))) then {
		A3PL_HungerWarning2 = true;
	};

	if ((Player_Hunger >= 5) && (Player_Hunger <= 10) && (isNil "A3PL_HungerWarning3") && (!(player getVariable ["Incapacitated",false]))) then {
		A3PL_HungerWarning3 = true;
	};

	call A3PL_Lib_VerifyHunger;
	player setVariable ["player_hunger",Player_Hunger,false];

	if (Player_Hunger <= 0) then {
		private ["_effect"];
		player setVariable ["player_hunger",Player_Hunger,false];
		A3PL_HungerWarning3 = Nil;
		A3PL_HungerWarning1 = Nil;

		if (!isNil "A3PL_HungerEmpty") exitwith {};
		[] spawn {
			A3PL_HungerEmpty = true;
			_effect = ["DynamicBlur",[2]] call A3PL_Lib_PPEffect;
			while {Player_Hunger <= 0} do {
				uiSleep 1;
				player setStamina 0;
			};
			A3PL_HungerEmpty = nil;
			_effect ppEffectEnable false;
			ppEffectDestroy _effect;
		};
	};
}] call compile_Global;

["A3PL_Loop_Thirst",
{
	private _amount = round(random(4));
	if(player getVariable ["pVar_RedNameOn",false]) exitWith {};

	Player_Thirst = Player_Thirst - _amount;
	call A3PL_Lib_VerifyThirst;

	if ((Player_Thirst >= 45) && (Player_Thirst <= 50) && (isNil "A3PL_ThirstWarning1") && (!(player getVariable ["Incapacitated",false]))) then {
		A3PL_ThirstWarning1 = true;
	};

	if ((Player_Thirst >= 15) && (Player_Thirst <= 20) && (isNil "A3PL_ThirstWarning2") && (!(player getVariable ["Incapacitated",false]))) then {
		A3PL_ThirstWarning2 = true;
	};

	if ((Player_Thirst >= 5) && (Player_Thirst <= 10) && (isNil "A3PL_ThirstWarning3") && (!(player getVariable ["Incapacitated",false]))) then {
		A3PL_ThirstWarning3 = true;
	};

	if (Player_Thirst <= 0) then {
		private ["_effect"];
		player setVariable ["player_thirst",Player_Thirst,false];
		A3PL_ThirstWarning3 = Nil;
		A3PL_ThirstWarning1 = Nil;

		if (!isNil "A3PL_ThirstEmpty") exitwith {};
		[] spawn {
			A3PL_ThirstEmpty = true;
			_effect = ["DynamicBlur",[2]] call A3PL_Lib_PPEffect;
			while {Player_Thirst <= 0} do {
				uiSleep 1;
				player setStamina 0;
			};
			A3PL_ThirstEmpty = nil;
			_effect ppEffectEnable false;
			ppEffectDestroy _effect;
		};
	};
}] call compile_Global;

["A3PL_Loop_Pee",
{
	if (Pee_System == false) exitWith {};
	
	private _amount = round(random(2));
	if(player getVariable ["pVar_RedNameOn",false]) exitWith {};

	Player_Pee = Player_Pee - _amount;
	if ((Player_Pee >= 45) && (Player_Pee <= 50) && (isNil "A3PL_PeeWarning1") && (!(player getVariable ["Incapacitated",false]))) then {
		A3PL_PeeWarning1 = true;
	};

	if ((Player_Pee >= 15) && (Player_Pee <= 20) && (isNil "A3PL_PeeWarning2") && (!(player getVariable ["Incapacitated",false]))) then {
		A3PL_PeeWarning2 = true;
	};

	if ((Player_Pee >= 5) && (Player_Pee <= 10) && (isNil "A3PL_PeeWarning3") && (!(player getVariable ["Incapacitated",false]))) then {
		A3PL_PeeWarning3 = true;
	};

	call A3PL_Lib_VerifyPee;
	player setVariable ["player_pee",Player_Pee,false];

	if (Player_Pee <= 0) then {
		private ["_effect"];
		player setVariable ["player_pee",Player_Pee,false];
		A3PL_PeeWarning3 = Nil;
		A3PL_PeeWarning1 = Nil;

		if (!isNil "A3PL_PeeEmpty") exitwith {};
		[] spawn {
			A3PL_PeeEmpty = true;
			_effect = ["DynamicBlur",[2]] call A3PL_Lib_PPEffect;
			while {Player_Pee <= 0} do {
				uiSleep 1;
				player setStamina 0;
			};
			A3PL_PeeEmpty = nil;
			_effect ppEffectEnable false;
			ppEffectDestroy _effect;
		};
	};
}] call compile_Global;

["A3PL_Loop_Sleep",
{
	if (Sleep_System == false) exitWith {};

	private _amount = round(random(4));
	if(player getVariable ["pVar_RedNameOn",false]) exitWith {};

	Player_Sleep = Player_Sleep - _amount;
	if ((Player_Sleep >= 45) && (Player_Sleep <= 50) && (isNil "A3PL_SleepWarning1") && (!(player getVariable ["Incapacitated",false]))) then {
		A3PL_SleepWarning1 = true;
	};

	if ((Player_Sleep >= 15) && (Player_Sleep <= 20) && (isNil "A3PL_SleepWarning2") && (!(player getVariable ["Incapacitated",false]))) then {
		A3PL_SleepWarning2 = true;
	};

	if ((Player_Sleep >= 5) && (Player_Sleep <= 10) && (isNil "A3PL_SleepWarning3") && (!(player getVariable ["Incapacitated",false]))) then {
		A3PL_SleepWarning3 = true;
	};

	call A3PL_Lib_VerifySleep;
	player setVariable ["player_sleep",Player_Sleep,false];

	if (Player_Sleep <= 0) then {
		private ["_effect"];
		player setVariable ["player_sleep",Player_Sleep,false];
		A3PL_SleepWarning3 = Nil;
		A3PL_SleepWarning1 = Nil;

		if (!isNil "A3PL_SleepEmpty") exitwith {};
		[] spawn {
			A3PL_SleepEmpty = true;
			while {Player_Sleep <= 0} do {
				private _called = "";
				private _format = format[("STR_A3PL_Loop_Somnoler" call A3PL_Localize)];
				playSound ["A3PL_Common\effects\sleep.ogg",player, false, getPosASL player, 0.5, 1, 2];
				cutText[_format, "BLACK FADED", 0.5, false, true, false];
				sleep 2;
				cutText["", "BLACK IN", 0.5];
				sleep 2;
			};
			A3PL_SleepEmpty = nil;
			_effect ppEffectEnable false;
			ppEffectDestroy _effect;
		};
	};
}] call compile_Global;

["A3PL_Loop_BetterBuyDelete",
{
    {
        if((player distance2D _x) > 100) then {
            A3PL_BetterBuy deleteAt (A3PL_BetterBuy find _x);
            deleteVehicle _x;
            [("STR_A3PL_Loop_TooFarOfFurniture" call A3PL_Localize),Color_Red] call A3PL_Notification;
        };
    } forEach A3PL_BetterBuy;
}] call compile_Global;

["A3PL_Loop_Blindfold",
{
	if(!isNil "Player_Blinded") exitWith {};
	Player_Blinded = true;
	Player_LockView = true;
	"layer_blindfold" cutRSC["RscBlindfold","PLAIN"];
	waitUntil {sleep 1; !((goggles player) IN ["G_Blindfold_01_black_F","G_Blindfold_01_white_F"])};
	Player_Blinded = nil;
	Player_LockView = false;
	"layer_blindfold" cutRSC["RscTitleDisplayEmpty","PLAIN"];
	player setVariable["Blindfolded",nil,true];
}] call compile_Global;

["A3FL_Loop_Seatbelt",
{
	if(!isNil "SeatbeltSound") exitWith {};
	if(player getVariable["SeatbeltOn",false]) exitWith {};
	SeatbeltSound = true;
	while {sleep 15; vehicle player isNotEqualTo player && {typeOf vehicle player isKindOf "Car" && {!(typeOf vehicle player IN Seatbelt_Blacklist)}} && {(speed(vehicle player) > 2)} && {(speed(vehicle player) < 50)} && {!(player getVariable["SeatbeltOn",false])}} do {
		playSound "seatbelt";
	};
	SeatbeltSound = nil;
}] call compile_Global;

["A3PL_Loop_SixthSense", {
	/*
		Sixth Sense trait - Detects nearby police (FISD job)
	*/
	private _traits = player getVariable ["Player_Traits", []];
	if !("sixth_sense" in _traits) exitWith {};

	private _nearCops = [];
	private _fisdJob = ("STR_Common_FISD" call A3PL_Localize);

	{
		if ((alive _x) && {(_x getVariable ["job", ""]) isEqualTo _fisdJob} && {_x distance player < 500}) then {
			_nearCops pushBack _x;
		};
	} forEach allPlayers;

	if (count _nearCops > 0) then {
		private _closest = _nearCops select 0;
		private _closestDist = _closest distance player;

		{
			private _dist = _x distance player;
			if (_dist < _closestDist) then {
				_closest = _x;
				_closestDist = _dist;
			};
		} forEach _nearCops;

		private _distance = floor(_closestDist);

		if (isNil "A3PL_SixthSense_LastNotif" || {time - A3PL_SixthSense_LastNotif > 10}) then {
			[format[("STR_A3PL_Trait_SixthSense_Alert" call A3PL_Localize), _distance], Color_Orange] call A3PL_Notification;
			A3PL_SixthSense_LastNotif = time;
		};
	};
}] call compile_Global;

["A3PL_Loop_AdrenalineCheck", {
	/*
		Adrenaline Junkie trait - Activates when HP < 30%
		Gives +20% speed and -20% damage received for 60 seconds
	*/
	private _traits = player getVariable ["Player_Traits", []];
	if !("adrenaline_junkie" in _traits) exitWith {};

	private _damage = damage player;
	private _isActive = player getVariable ["A3PL_Adrenaline_Active", false];
	private _lastActivation = player getVariable ["A3PL_Adrenaline_LastActivation", 0];

	if (_damage > 0.7 && !_isActive && {time - _lastActivation > 120}) then {
		player setVariable ["A3PL_Adrenaline_Active", true];
		player setVariable ["A3PL_Adrenaline_LastActivation", time];

		[("STR_A3PL_Trait_Adrenaline_Activated" call A3PL_Localize), Color_Yellow] call A3PL_Notification;

		player setAnimSpeedCoef 1.2;

		"DynamicBlur" ppEffectEnable true;
		"DynamicBlur" ppEffectAdjust [0.3];
		"DynamicBlur" ppEffectCommit 0.5;

		"ColorCorrections" ppEffectEnable true;
		"ColorCorrections" ppEffectAdjust [1, 1.2, 0, [0, 0, 0, 0], [1, 0.8, 0.6, 1], [0.5, 0.5, 0.5, 0]];
		"ColorCorrections" ppEffectCommit 0.5;

		[{
			player setVariable ["A3PL_Adrenaline_Active", false];
			player setAnimSpeedCoef 1.0;
			"DynamicBlur" ppEffectEnable false;
			"ColorCorrections" ppEffectEnable false;
			[("STR_A3PL_Trait_Adrenaline_Ended" call A3PL_Localize), Color_Red] call A3PL_Notification;
		}, [], 20] call CBA_fnc_waitAndExecute;
	};
}] call compile_Global;
