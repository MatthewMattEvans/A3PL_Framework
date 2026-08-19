/*
    Code written by NORTHBRIDGE INTERACTIVE
    58, RUE DE MONCEAU, 75008 PARIS, FRANCE
    SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/

// ═══════════════════════════════════════════════════════════════════════════════
// LOAD LANGUAGE FROM DATABASE (SERVER)
// Table: config_lang (columns: id, lang_code)
// ═══════════════════════════════════════════════════════════════════════════════
["A3PL_Localization_LoadLang", {
    private _result = ["SELECT lang_code FROM config_lang WHERE id = 1 LIMIT 1", 2] call Server_Database_Async;
    if (count _result > 0) then {
        private _lang = _result select 0;
        if (_lang in ["FR", "EN", "DE"]) then {
            Server_Lang = _lang;
            publicVariable "Server_Lang";
            diag_log format ["[A3PL] Language loaded from database: %1", Server_Lang];
        } else {
            Server_Lang = "EN";
            publicVariable "Server_Lang";
            diag_log format ["[A3PL] Invalid language in database (%1), defaulting to EN", _lang];
        };
    } else {
        Server_Lang = "EN";
        publicVariable "Server_Lang";
        diag_log "[A3PL] No language found in database, defaulting to EN";
    };
}] call compile_Server;

["A3PL_Localization_Init", {
    // Load language from database
    call A3PL_Localization_LoadLang;
    Localization_Languages = ["FR", "EN", "DE"];
    Localization_Strings = [];

    private _locFuncs = [
        "A3PL_ATC_Localization",
        "A3PL_Achievement_Localization",
        "A3PL_Activity_Sport_Localization",
        "A3PL_Admin_Localization",
        "A3PL_Animations_Localization",
        "A3PL_Bank_Localization",
        "A3PL_Bowling_Localization",
        "A3PL_Business_Localization",
        "A3PL_Combine_Localization",
        "A3PL_CompanyShop_Localization",
        "A3PL_Company_Localization",
        "A3PL_Config_Localization",
        "A3PL_Drug_Cocaine_Localization",
        "A3PL_Drug_Crack_Localization",
        "A3PL_Drug_Explosives_Localization",
        "A3PL_Drug_Moonshine_Localization",
        "A3PL_Drug_Shrooms_Localization",
        "A3PL_Drug_Weed_Localization",
        "A3PL_Drugs_Localization",
        "A3PL_EventHandlers_Localization",
        "A3PL_Event_Christmas_Localization",
        "A3PL_Event_Halloween_Localization",
        "A3PL_Faction_DMV_Localization",
        "A3PL_Faction_Dogs_Localization",
        "A3PL_Faction_FD_Localization",
        "A3PL_GPS_Localization",
        "A3PL_Faction_Fire_Localization",
        "A3PL_Faction_Government_Localization",
        "A3PL_Faction_Locker_Localization",
        "A3PL_Faction_Police_Localization",
        "A3PL_Faction_Prison_Localization",
        "A3PL_Factory_Localization",
        "A3PL_FilesManager_Localization",
        "A3PL_Garage_Localization",
        "A3PL_Gas_Station_Localization",
        "A3PL_HUD_Localization",
        "A3PL_Heist_Bank_Localization",
        "A3PL_Heist_Dealership_Localization",
        "A3PL_Heist_Evidence_Localization",
        "A3PL_Heist_GoFast_Localization",
        "A3PL_Heist_Houses_Localization",
        "A3PL_Heist_Jewelry_Localization",
        "A3PL_Heist_PirateShip_Localization",
        "A3PL_Heist_Port_Localization",
        "A3PL_Heist_Store_Localization",
        "A3PL_Hooker_Localization",
        "A3PL_Hotbar_Localization",
        "A3PL_Housing_Localization",
        "A3PL_Repair_Localization",
        "A3PL_Hunting_Localization",
        "A3PL_IE_Localization",
        "A3PL_Illegal_Chopshop_Localization",
        "A3PL_Illegal_Crackhouses_Localization",
        "A3PL_Illegal_Criminal_Localization",
        "A3PL_Illegal_Gang_Localization",
        "A3PL_Interaction_Localization",
        "A3PL_Intersect_Localization",
        "A3PL_Inventory_Localization",
        "A3PL_Items_Localization",
        "A3PL_Job_BetterBuy_Localization",
        "A3PL_Job_Delivery_Localization",
        "A3PL_Job_Exterminator_Localization",
        "A3PL_Job_Farming_Localization",
        "A3PL_Job_Fisherman_Localization",
        "A3PL_Job_Freight_Localization",
        "A3PL_Job_Lumber_Localization",
        "A3PL_Job_Oil_Localization",
        "A3PL_Job_Roadworker_Localization",
        "A3PL_Job_SFP_Localization",
        "A3PL_Job_ShipCaptain_Localization",
        "A3PL_Job_Taxi_Localization",
        "A3PL_Job_Trucking_Localization",
        "A3PL_Job_Uber_Localization",
        "A3PL_Job_Waste_Localization",
        "A3PL_Job_Wildcat_Localization",
        "A3PL_Keypad_Localization",
        "A3PL_Lib_Localization",
        "A3PL_Loading_Localization",
        "A3PL_Loop_Localization",
        "A3PL_Medical_Localization",
        "A3PL_NPC_Localization",
        "A3PL_Notifications_Localization",
        "A3PL_Phone_Localization",
        "A3PL_Placeables_Localization",
        "A3PL_Player_Localization",
        "A3PL_Player_New_Localization",
        "A3PL_QuickActions_Buildings_Localization",
        "A3PL_QuickActions_NPC_Localization",
        "A3PL_QuickActions_Objects_Localization",
        "A3PL_QuickActions_Vehicles_Localization",
        "A3PL_Resources_Localization",
        "A3PL_Shop_Localization",
        "A3PL_Stock_Localization",
        "A3PL_Storage_Localization",
        "A3PL_FactoryV2_Localization",
        "A3PL_Twitter_Localization",
        "A3PL_VehicleInit_Localization",
        "A3PL_Vehicle_Localization",
        "A3PL_Warehouses_Localization",
        "A3PL_Weather_Localization",
        "Common_Localization",
        "Config_Animations_Localization",
        "Config_Interactions_Localization",
        "Config_Intersect_Localization",
        "Config_Master_Localization",
        "Config_NPC_Localization",
        "Config_Traits_Localization",
        "Mission_Localization",
        "Server_Business_Localization",
        "Server_ChopShop_Localization",
        "Server_Company_Localization",
        "Server_Core_Localization",
        "Server_Crackhouses_Localization",
        "Server_Criminal_Localization",
        "Server_DMV_Localization",
        "Server_Dog_Localization",
        "Server_Events_Localization",
        "Server_Factory_Localization",
        "Server_Fuel_Localization",
        "Server_Gang_Localization",
        "Server_Gear_Localization",
        "Server_Heist_Dealership_Localization",
        "Server_Heist_GoFast_Localization",
        "Server_Housing_Localization",
        "Server_Job_Oil_Localization",
        "Server_Job_Roadworker_Localization",
        "Server_Job_Uber_Localization",
        "Server_Job_Wildcat_Localization",
        "Server_Locker_Localization",
        "Server_FactoryV2_Localization",
        "Server_Phone_Localization",
        "Server_Police_Localization",
        "Server_Warehouses_Localization",
        "UI_ATC_Localization",
        "UI_Admin_Localization",
        "UI_AnimationWheel_Localization",
        "UI_Bagweed_Localization",
        "UI_BowlingRegister_Localization",
        "UI_CAD_Localization",
        "UI_CombineItems_Localization",
        "UI_Common_Localization",
        "UI_CreateTicket_Localization",
        "UI_DeveloperDebug_Localization",
        "UI_ExecutiveMenu_Localization",
        "UI_Factory_Localization",
        "UI_Repair_Localization",
        "UI_FilesManager_Localization",
        "UI_HUD_LoadAction_Localization",
        "UI_InspectTel_Localization",
        "UI_Inventory_Localization",
        "UI_ImpoundMark_Localization",
        "UI_JailPlayer_Localization",
        "UI_Kane9_Localization",
        "UI_Medical_Localization",
        "UI_Patdown_Localization",
        "UI_ReceiveTicket_Localization",
        "UI_SetName_Localization",
        "UI_Settings_Localization",
        "UI_UberAccept_Localization",
        "UI_iPhone_Localization"
    ];

    diag_log format ["[A3PL] Calling %1 localization functions", count _locFuncs];
    {
        private _func = missionNamespace getVariable [_x, nil];
        if (!isNil "_func") then {
            call _func;
        };
    } forEach _locFuncs;
    diag_log format ["[A3PL] Localization_Strings filled with %1 entries", count Localization_Strings];
}] call compile_Server;

// ═══════════════════════════════════════════════════════════════════════════════
// HASHMAP CONSTRUCTION
// Called after loading translation files
// ═══════════════════════════════════════════════════════════════════════════════
["A3PL_Localization_Build", {
    private _langIndex = (Localization_Languages find Server_Lang) + 1;
    if (_langIndex == 0) then { _langIndex = 1; };
    Localization = createHashMap;
    {
        Localization set [_x # 0, _x # _langIndex];
    } forEach Localization_Strings;
    Localization_Strings = nil;
    publicVariable "Localization";
    diag_log format ["[A3PL] Localization loaded: %1 keys, Language: %2", count (keys Localization), Server_Lang];
}] call compile_Server;

// ═══════════════════════════════════════════════════════════════════════════════
// TRANSLATION FUNCTION (GLOBAL)
// Usage: "STR_Common_Yes" call A3PL_Localize
// Also handles arrays: ["STR_Template", "STR_Param"] -> format with translated values
// ═══════════════════════════════════════════════════════════════════════════════
["A3PL_Localize", {
    if (isNil "_this") exitWith { _this };
    if (isNil "Localization") exitWith { _this };

    // Handle array format: ["STR_Template", "STR_Param1", "STR_Param2", ...]
    if (_this isEqualType []) exitWith {
        if (count _this == 0) exitWith { "" };
        private _template = (_this#0) call A3PL_Localize;
        private _params = _this select [1, count _this - 1];
        private _translatedParams = _params apply { _x call A3PL_Localize };
        format ([_template] + _translatedParams)
    };

    // Handle string
    if (!(_this isEqualType "")) exitWith { _this };
    Localization getOrDefault [_this, _this]
}] call compile_Global;

// ═══════════════════════════════════════════════════════════════════════════════
// CONFIG TRANSLATION FUNCTION (GLOBAL)
// Usage: To translate text retrieved from a .hpp config that starts with STR_
//        "STR_Mission_Config_SmartMarkers_Springfield" call A3PL_LocalizeConfig
// ═══════════════════════════════════════════════════════════════════════════════
["A3PL_LocalizeConfig", {
    // Enlever le $ au debut si present (pour les configs .hpp qui utilisent $STR_)
    private _str = if (_this select [0, 1] == "$") then {_this select [1]} else {_this};

    if (_str select [0, 4] == "STR_") exitWith {
        private _result = _str call A3PL_Localize;
        _result
    };
    _this
}] call compile_Global;

// ═══════════════════════════════════════════════════════════════════════════════
// DIALOG LOCALIZATION FUNCTION (GLOBAL)
// Usage: Call after createDialog to translate all controls
//        findDisplay 12345 call A3PL_Dialog_Localize;
// ═══════════════════════════════════════════════════════════════════════════════
["A3PL_Dialog_Localize", {
    params [["_display", displayNull, [displayNull]]];
    if (isNull _display) exitWith {};
    if (isNil "Localization") exitWith {};

    private _allControls = allControls _display;
    {
        private _ctrl = _x;
        private _text = ctrlText _ctrl;
        private _idc = ctrlIDC _ctrl;
        private _type = ctrlType _ctrl;

        if (_text select [0, 4] == "STR_") then {
            private _translated = _text call A3PL_Localize;
            if (_type == 13) then {
                _ctrl ctrlSetStructuredText parseText _translated;
            } else {
                _ctrl ctrlSetText _translated;
            };
        };

        private _tooltip = ctrlTooltip _ctrl;
        if (_tooltip select [0, 4] == "STR_") then {
            private _translated = _tooltip call A3PL_Localize;
            _ctrl ctrlSetTooltip _translated;
        };
    } forEach _allControls;
}] call compile_Global;
