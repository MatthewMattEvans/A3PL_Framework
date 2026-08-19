/*
    POLARION
    Code written by non-profit organization "POLARION" (SIREN 930088620)
    @Copyright POLARION (https://www.polarion.fr)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : hello@polarion.fr
*/
// Config_Houses_List = [
// 	"Land_Home1g_DED_Home1g_01_F",
// 	"Land_Mansion01",
// 	"Land_A3PL_Ranch3",
// 	"Land_A3PL_Ranch2",
// 	"Land_A3PL_Ranch1",
// 	"Land_A3PL_ModernHouse1",
// 	"Land_A3PL_ModernHouse2",
// 	"Land_A3PL_ModernHouse3",
// 	"Land_A3PL_BostonHouse",
// 	"Land_A3PL_Shed3",
// 	"Land_A3PL_Shed4",
// 	"Land_A3PL_Shed2",
// 	"Land_John_House_Grey",
// 	"Land_John_House_Blue",
// 	"Land_John_House_Red",
// 	"Land_John_House_Green",
// 	"Land_A3FL_Mansion",
// 	"Land_A3FL_Office_Building",
// 	"Land_Home4w_DED_Home4w_01_F",
// 	"Land_Home3r_DED_Home3r_01_F",
// 	"Land_Home6b_DED_Home6b_01_F",
// 	"Land_Home5y_DED_Home5y_01_F",
// 	"Land_Home1g_DED_Home1g_01_F",
// 	"Land_Home2b_DED_Home2b_01_F",
// 	"Land_A3FL_House1_Cream",
// 	"Land_A3FL_House1_Green",
// 	"Land_A3FL_House1_Blue",
// 	"Land_A3FL_House1_Brown",
// 	"Land_A3FL_House1_Yellow",
// 	"Land_A3FL_House2_Cream",
// 	"Land_A3FL_House2_Green",
// 	"Land_A3FL_House2_Blue",
// 	"Land_A3FL_House2_Brown",
// 	"Land_A3FL_House2_Yellow",
// 	"Land_A3FL_House3_Cream",
// 	"Land_A3FL_House3_Green",
// 	"Land_A3FL_House3_Blue",
// 	"Land_A3FL_House3_Brown",
// 	"Land_A3FL_House3_Yellow",
// 	"Land_A3FL_House4_Cream",
// 	"Land_A3FL_House4_Green",
// 	"Land_A3FL_House4_Blue",
// 	"Land_A3FL_House4_Brown",
// 	"Land_A3FL_House4_Yellow",
// 	"Land_A3FL_Anton_Modern_Bungalow",
// 	"Land_A3FL_Trailer",
// 	"Land_A3FL_Trailer_2",
// 	"Land_A3FL_Trailer_3",
// 	"Land_A3FL_Trailer_4",
// 	"Land_A3FL_Trailer_5",
// 	"Land_A3FL_Trailer_6",
// 	"Land_FYD_PARRAS_BigModernHouse",
// 	"Land_FYD_Parras_Modern_House",
// 	"Land_FYD_Parras_Modern_House_02",
// 	"Land_FYD_Parras_Modern_House_03",
// 	"Land_FYD_Parras_Modern_House_04"
// ];
// publicVariable "Config_Houses_List";

// Config_Houses_Data = createHashMapFromArray [
// 	//Moonshine sheds
// 	["Land_A3PL_Shed2",[5000,50,167,5]],
// 	["Land_A3PL_Shed3",[6000,60,200,5]],
// 	["Land_A3PL_Shed4",[7000,70,233,5]],
// 	["Land_A3PL_BostonHouse",[10000,100,333,6]],

// 	//Trailer Homes
// 	["Land_A3FL_Trailer",[25000,250,833,7]],
// 	["Land_A3FL_Trailer_2",[25000,250,833,7]],
// 	["Land_A3FL_Trailer_3",[25000,250,833,7]],
// 	["Land_A3FL_Trailer_4",[25000,250,833,7]],
// 	["Land_A3FL_Trailer_5",[25000,250,833,7]],
// 	["Land_A3FL_Trailer_6",[25000,250,833,7]],

// 	//One-story without garage
// 	["Land_John_House_Grey",[35000,350,1167,7]],
// 	["Land_John_House_Blue",[35000,350,1167,7]],
// 	["Land_John_House_Red",[35000,350,1167,7]],
// 	["Land_John_House_Green",[35000,350,1167,7]],

// 	//One-story with garage
// 	["Land_A3PL_Ranch1",[40000,400,1333,8]],
// 	["Land_A3PL_Ranch2",[40000,400,1333,8]],
// 	["Land_A3PL_Ranch3",[40000,400,1333,8]],

// 	["Land_Home4w_DED_Home4w_01_F",[55000,550,1833,8]],
// 	["Land_Home1g_DED_Home1g_01_F",[55000,550,1833,8]],
// 	["Land_Home2b_DED_Home2b_01_F",[50000,500,1667,8]],
// 	["Land_Home5y_DED_Home5y_01_F",[50000,500,1667,8]],

// 	//One-story ranch
// 	["Land_A3FL_House2_Cream",[42000,420,1400,9]],
// 	["Land_A3FL_House2_Green",[42000,420,1400,9]],
// 	["Land_A3FL_House2_Blue",[42000,420,1400,9]],
// 	["Land_A3FL_House2_Brown",[42000,420,1400,9]],
// 	["Land_A3FL_House2_Yellow",[42000,420,1400,9]],

// 	//One-story Small L-Shape
// 	["Land_A3FL_House4_Cream",[52500,525,1750,10]],
// 	["Land_A3FL_House4_Green",[52500,525,1750,10]],
// 	["Land_A3FL_House4_Blue",[52500,525,1750,10]],
// 	["Land_A3FL_House4_Brown",[52500,525,1750,10]],
// 	["Land_A3FL_House4_Yellow",[52500,525,1750,10]],

// 	//One-story Big L-Shape
// 	["Land_A3FL_House3_Cream",[53000,530,700,12]],
// 	["Land_A3FL_House3_Green",[53000,530,700,12]],
// 	["Land_A3FL_House3_Blue",[53000,530,700,12]],
// 	["Land_A3FL_House3_Brown",[53000,530,700,12]],
// 	["Land_A3FL_House3_Yellow",[53000,530,700,12]],

// 	//Two-Story with garage
// 	["Land_Home3r_DED_Home3r_01_F",[106000,636,1663,13]],
// 	["Land_Home6b_DED_Home6b_01_F",[106000,636,1663,13]],

// 	//Two-story without garage
// 	["Land_A3FL_House1_Cream",[175000,1050,3241,15]],
// 	["Land_A3FL_House1_Green",[175000,1050,3241,15]],
// 	["Land_A3FL_House1_Blue",[175000,1050,3241,15]],
// 	["Land_A3FL_House1_Brown",[175000,1050,3241,15]],
// 	["Land_A3FL_House1_Yellow",[175000,1050,3241,15]],

// 	//One-story without garage
// 	["Land_A3FL_Anton_Modern_Bungalow",[250000,1125,3571,20]],

// 	//Mansions
// 	["Land_Mansion01",[350000,1295,3889,25]],
// 	["Land_A3PL_ModernHouse1",[500000,1850,5000,25]],
// 	["Land_A3PL_ModernHouse2",[400000,1480,4000,25]],
// 	["Land_A3PL_ModernHouse3",[450000,1665,4500,25]],

// 	//BIG Mansions
// 	["Land_A3FL_Mansion",[550000,2035,5500,27]],
// 	["Land_A3FL_Office_Building",[850000,3145,7083,30]],
// 	["Land_FYD_Parras_Modern_House",[700000,2590,5833,30]],
// 	["Land_FYD_Parras_Modern_House_02",[650000,2405,5417,30]],
// 	["Land_FYD_Parras_Modern_House_03",[100000,600,1852,30]],

// 	//Supra Mega Big Mansion
// 	["Land_FYD_PARRAS_BigModernHouse",[2500000,7500,10417,30]]
// ];
// publicVariable "Config_Houses_Data";

/*
	Winston - Use this to check house types:
	tmp = (nearestObjects [getPos player,["Land_A3PL_Ranch3"],20000000]) select 0;
	player setPos (getPos tmp);
*/
 
