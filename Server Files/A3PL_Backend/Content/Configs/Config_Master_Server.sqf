/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Config_Master_Server", {
    Keypad_FactionBuildings = [
        [("STR_Common_FISD" call A3PL_Localize), [
            "Land_EC_DoubleVehicleGate",
            "Land_EC_PersonGate",
            "Land_Garage",
            "Land_Police_Headquarter",
            "Land_A3PL_Academy",
            "Land_A3FL_SheriffPD",
            "Land_A3PL_Sheriffpd",
            "Land_A3FL_DOC_Gate",
            "Land_A3FL_DOC_Warehouse",
            "Land_A3PL_Prison",
            "Land_A3FL_DOC_Wall_Tower",
            "Land_A3FL_DOC_Wall_Tower_Corner"
        ]],
        [("STR_Common_FIFR" call A3PL_Localize), [
            "Land_A3PL_Clinic",
            "Land_A3PL_Firestation",
            "Land_FYD_Firestation"
        ]],
        [("STR_Common_DOJ" call A3PL_Localize), [
            "Land_FYD_Courthouse"
        ]],
        [("STR_Common_GOV" call A3PL_Localize), [
            "land_a3pl_ch"
        ]]
    ];
    publicVariable "Keypad_FactionBuildings";
}] call compile_Server;