/*
    POLARION
    Code written by non-profit organization "POLARION" (SIREN 930088620)
    @Copyright POLARION (https://www.polarion.fr)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : hello@polarion.fr
*/
// FOR ADMIN MENU
// Config_Vehicles_Admin = [
//     ["A3PL_Drill",["Trailer"]],
//     ["A3PL_Tanker",["Trailer"]],
//     ["A3PL_Small_Boat",["Trailer"]],
//     ["A3PL_Box",["Trailer"]],
//     ["Jonzie",["Ambulance"]],
//     ["A3PL_Pierce",["Pumper","Heavy_Ladder","Rescue"]],
//     ["A3PL_BMW",["X5","M3"]],
//     ["A3PL",["Silverado","Silverado_ML","Silverado_PD","Silverado_PD_ST","Silverado_FD","Silverado_FD_Brush","911GT2","Charger69","VetteZR1","Mailtruck","Gallardo","Cessna172","Lowloader","Mustang","Mustang_PD","Mustang_PD_Slicktop","F150","F150_Marker","Ram","Ram_ML","Wrangler","Charger","Charger15","Charger15_PD","Charger15_PD_ST","Charger15_FD","E350","Tahoe_FD","Tahoe_PD","Tahoe_PD_Slicktop","Tahoe","CVPI","CVPI_Rusty","CVPI_Taxi","CVPI_PD","CVPI_PD_Slicktop","CVPI_FD","Charger_PD","Charger_PD_Slicktop","P362","P362_TowTruck","P362_Garbage_Truck","Rover","Camaro","RBM","Motorboat","RHIB","Fuel_Van","MiniExcavator","CRX","Challenger_Hellcat","Car_Trailer","Yacht","Yacht_Pirate","Fatboy","1100R","Knucklehead","Kx","Goose_Base","Goose_USCG","Jayhawk","Ski_Base","Challenger_Hellcat_PD_ST"]],
//     ["A3FL_T440",["Gas_Tanker","Water_Tanker","Tow_Truck"]],
//     ["A3FL_Explorer",["Platinum_20","Platinum_PD_20","Platinum_PD_Slicktop_20","Platinum_FD_20","PD_K9_20"]]
//     ["A3FL",["AS_365","Nissan_GTR","Nissan_GTR_LW","Smart_Car","BMW_M6","BMW_M6_Tuned","Mercedes_Benz_AMG_C63","LCM","T370","T440","Focus","RS7","Yukon","Mustang15","Mustang15_PD","Mustang15_PD_ST","F12","Taurus","Taurus_PD","Taurus_PD_ST","Taurus_FD","Stretcher","Wheelchair","Tahoe","Tahoe_PD","Tahoe_PD_ST","Tahoe_FD","M_900_Base_F","Dawn","PalletLifter","TransportContainer","ElDorado","E350","E350_P","E350_PD","E350_PD_P","E350_ML","F150","F150_PD","F150_PD_ST","F150_FD","F150_ML","CamaroZL1","CamaroZL1_PD","CamaroZL1_PD_ST","Escalade","Escalade_PD_ST","370z","AS350_CIV","F450","G65","Supra","Suburban"]],
//     ["Heli_Medium01",["H","Luxury_H","Medic_H","Military_H","Veteran_H","Coastguard_H","Sheriff_H"]],
//     ["C",["Van_02_transport_F","Quadbike_01_F","Kart_01_F"]],
//     ["K",["Scooter_DarkBlue"]],
//     ["EC",["Performante","F450_Brush","Explorer19","Explorer19_PD","Explorer19_PD_ST","Explorer19_FD","Charger_Hellcat_20","Charger_Hellcat_20_FD","Charger_Hellcat_20_PD","Charger_Hellcat_20_PD_ST","Bearcat","E350_A","F150_A","DodgeRam","DodgeRam_Lowered","DodgeRam_PD","DodgeRam_PD_ST","DodgeRam_FD"]]
// ];
// publicVariable "Config_Vehicles_Admin";

// // Marker Lights
// Config_ML_Vehs = [
//     "A3PL_P362_TowTruck",
//     "A3FL_T440_Tow_Truck",
//     "A3FL_F150_ML",
//     "A3FL_E350_ML",
//     "A3PL_Ram_ML",
//     "A3PL_Silverado_ML"
// ];
// publicVariable "Config_ML_Vehs";

// // FISD 
// Config_FISD_Vehs = [
//     "A3PL_RBM",
//     "EC_DodgeRam_PD",
//     "EC_DodgeRam_PD_ST",
//     "EC_Explorer19_PD",
//     "EC_Explorer19_PD_ST",
//     "EC_Charger_Hellcat_20_PD",
//     "EC_Charger_Hellcat_20_PD_ST",
//     "EC_Bearcat",
//     "A3PL_CVPI_PD",
//     "A3PL_CVPI_PD_Slicktop",
//     "A3PL_Tahoe_PD",
//     "A3PL_Tahoe_PD_Slicktop",
//     "A3PL_Mustang_PD",
//     "A3PL_Mustang_PD_Slicktop",
//     "A3PL_Challenger_Hellcat_PD_ST",
//     "A3PL_Charger_PD",
//     "A3PL_Charger_PD_Slicktop",
//     "A3PL_Charger15_PD",
//     "A3PL_Charger15_PD_ST",
//     "A3PL_Charger15_FD",
//     "A3PL_Silverado_PD",
//     "A3FL_Taurus_PD",
//     "A3FL_Taurus_PD_ST",
//     "A3PL_Silverado_PD_ST",
//     "A3FL_Escalade_PD_ST",
//     "A3FL_Explorer_Platinum_PD_20",
//     "A3FL_Explorer_PD_K9_20",
//     "A3FL_Explorer_Platinum_PD_Slicktop_20",
//     "A3FL_Mustang15_PD",
//     "A3FL_Mustang15_PD_ST",
//     "A3FL_Tahoe_PD",
//     "A3FL_Tahoe_PD_ST",
//     "A3FL_E350_PD",
//     "A3FL_E350_PD_P",
//     "A3FL_CamaroZL1_PD",
//     "A3FL_CamaroZL1_PD_ST",
//     "A3FL_F150_PD",
//     "A3FL_F150_PD_ST"
// ];
// publicVariable "Config_FISD_Vehs";

// Config_FISD_Hel = [
//     "Heli_Medium01_Sheriff_H",
//     "A3PL_Jayhawk",
//     "A3FL_AS_365"
// ];
// publicVariable "Config_FISD_Hel";

// // FIFR
// Config_FIFR_Vehs = [
//     "EC_DodgeRam_FD",
//     "EC_E350_A",
//     "EC_F150_A",
//     "EC_F450_Brush",
//     "EC_Explorer19_FD",
//     "EC_Charger_Hellcat_20_FD",
//     "A3PL_Ladder",
//     "Jonzie_Ambulance",
//     "A3PL_CVPI_FD",
//     "A3PL_Pierce_Ladder",
//     "A3PL_Pierce_Heavy_Ladder",
//     "A3PL_Tahoe_FD",
//     "A3PL_Charger15_FD",
//     "A3PL_Pierce_Pumper",
//     "A3PL_E350",
//     "A3PL_Pierce_Rescue",
//     "A3FL_Taurus_FD",
//     "A3PL_Silverado_FD",
//     "A3PL_Silverado_FD_Brush",
//     "A3FL_Explorer_Platinum_FD_20",
//     "A3FL_Tahoe_FD",
//     "A3FL_T440_Water_Tanker",
//     "A3FL_F150_FD"
// ];
// publicVariable "Config_FIFR_Vehs";

// Config_FIFR_Hel = [
//     "Heli_Medium01_Medic_H",
//     "A3FL_AS_365"
// ];
// publicVariable "Config_FIFR_Hel";

// // DOJ
// Config_DOJ_Vehs = [
//     "A3FL_Taurus",
//     "A3FL_Tahoe",
//     "A3PL_Silverado",
//     "A3PL_Ram",
//     "A3FL_Mustang15",
//     "A3FL_Focus",
//     "A3FL_F150",
//     "A3PL_F150",
//     "A3FL_E350_P",
//     "A3FL_E350"
// ];
// publicVariable "Config_DOJ_Vehs";

// // SLICKTOPS CARS
// Config_Slicktop_Vehs = [
//     "A3PL_Tahoe_PD_Slicktop",
//     "A3PL_CVPI_PD_Slicktop",
//     "A3PL_Mustang_PD_Slicktop",
//     "A3PL_Charger_PD_Slicktop",
//     "A3PL_VetteZR1_PD",
//     "A3PL_Charger15_PD_ST",
//     "A3FL_Mustang15_PD_ST",
//     "A3FL_Taurus_PD_ST",
//     "A3PL_Silverado_PD_ST",
//     "A3FL_Explorer_Platinum_PD_Slicktop_20",
//     "A3FL_Tahoe_PD_ST",
//     "A3FL_CamaroZL1_PD_ST",
//     "A3FL_F150_PD_ST",
//     "A3PL_Challenger_Hellcat_PD_ST",
//     "EC_Explorer19_PD_ST",
//     "EC_Charger_Hellcat_20_PD_ST",
//     "EC_DodgeRam_PD_ST",
//     "EC_Bearcat",
//     "A3PL_RBM"
// ];
// publicVariable "Config_Slicktop_Vehs";

// // CARS WITH LIGHTBAR
// Config_Lightbar_Vehs = [
//     "A3PL_Tahoe_PD",
//     "A3PL_CVPI_PD",
//     "A3PL_Mustang_PD",
//     "A3PL_Charger_PD",
//     "A3PL_Silverado_PD",
//     "A3PL_Charger15_PD",
//     "A3PL_Charger15_FD",
//     "A3FL_Mustang15_PD",
//     "A3FL_Taurus_PD",
//     "A3FL_Taurus_FD",
//     "A3FL_Explorer_Platinum_PD_20",
//     "A3FL_Explorer_PD_K9_20",
//     "A3FL_Explorer_Platinum_FD_20",
//     "A3FL_Tahoe_PD",
//     "A3FL_Tahoe_FD",
//     "A3FL_E350_PD",
//     "A3FL_E350_PD_P",
//     "A3FL_CamaroZL1_PD",
//     "A3FL_F150_PD",
//     "A3PL_Silverado_FD",
//     "EC_E350_A",
//     "EC_F150_A",
//     "EC_F450_Brush",
//     "EC_Explorer19_PD",
//     "EC_Explorer19_FD",
//     "EC_Charger_Hellcat_20_FD",
//     "EC_Charger_Hellcat_20_PD",
//     "EC_DodgeRam_FD",
//     "EC_DodgeRam_PD"
// ];
// publicVariable "Config_Lightbar_Vehs";

// // MOTORBOAT (for Ankle)
// Config_Motorboat = [
//     "A3PL_Motorboat",
//     "A3PL_Motorboat_Rescue",
//     "A3PL_Motorboat_Police",
//     "A3PL_RHIB",
//     "A3PL_Yacht",
//     "A3PL_Yacht_Pirate",
//     "A3PL_RBM",
//     "A3PL_Container_Ship",
//     "A3PL_Patrol",
//     "A3FL_LCM",
//     "C_Scooter_Transport_01_F"
// ];
// publicVariable "Config_Motorboat";