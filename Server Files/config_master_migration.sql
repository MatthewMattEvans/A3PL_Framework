-- ============================================================================
-- Migration Config_Master.sqf vers Database
-- ============================================================================

-- Création de la table
DROP TABLE IF EXISTS `config_master`;
CREATE TABLE `config_master` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `value` TEXT NOT NULL,
    `public` TINYINT(1) NOT NULL DEFAULT 1,
    `needs_compile` TINYINT(1) NOT NULL DEFAULT 0,
    `category` VARCHAR(50) DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- needs_compile=0 : valeurs simples (nombres, strings, arrays statiques) -> str _value dans format+compile
-- needs_compile=1 : expressions dynamiques (objets mission, fonctions, random, hashmaps) -> _value directement dans format+compile

-- ============================================================================
-- GENERAL SETTINGS
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Server_Name', '"arma3projectlife.com"', 1, 'general'),
('Server_Branch', '"main"', 1, 'general'),
('Paycheck_Amount_With_ServerName_in_SteamProfile', '1', 1, 'general'),
('Player_MaxWeight', '250', 1, 'general'),
('Hotbar_Blacklist', '["cash"]', 1, 'general'),
('Help', 'true', 1, 'general'),
('Help_Messages', '["STR_Config_Master_Astuce1","STR_Config_Master_Astuce2","STR_Config_Master_Astuce3","STR_Config_Master_Astuce4","STR_Config_Master_Astuce5","STR_Config_Master_Astuce6","STR_Config_Master_Astuce7","STR_Config_Master_Astuce8","STR_Config_Master_Astuce9","STR_Config_Master_Astuce10","STR_Config_Master_Astuce11","STR_Config_Master_Astuce12","STR_Config_Master_Astuce13","STR_Config_Master_Astuce14","STR_Config_Master_Astuce15","STR_Config_Master_Astuce16","STR_Config_Master_Astuce17","STR_Config_Master_Astuce18","STR_Config_Master_Astuce19","STR_Config_Master_Astuce20","STR_Config_Master_Astuce21","STR_Config_Master_Astuce22","STR_Config_Master_Astuce23","STR_Config_Master_Astuce24","STR_Config_Master_Astuce25","STR_Config_Master_Astuce26","STR_Config_Master_Astuce27","STR_Config_Master_Astuce28","STR_Config_Master_Astuce29","STR_Config_Master_Astuce30","STR_Config_Master_Astuce31","STR_Config_Master_Astuce32","STR_Config_Master_Astuce33","STR_Config_Master_Astuce34"]', 1, 'general');

-- ============================================================================
-- TEAMSPEAK
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Teamspeak_Protection', 'true', 1, 'teamspeak'),
('Teamspeak_Server_Name', '"Arma 3 Project Life - www.arma3projectlife.com"', 1, 'teamspeak'),
('Teamspeak_Whitelisted_Channels', '["TaskForceRadio"]', 1, 'teamspeak');

-- ============================================================================
-- EVENTS
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Snow_Update', 'false', 1, 'events'),
('Christmas', 'false', 1, 'events'),
('Christmas_Gift', '3', 1, 'events'),
('Christmas_Trade', '5', 1, 'events'),
('Halloween', 'false', 1, 'events'),
('Halloween_Caught_But_Have_Candy', '10', 1, 'events'),
('Halloween_Not_Caught_Reward', '25', 1, 'events'),
('Halloween_Guardian', 'true', 1, 'events'),
('Halloween_Guardian_Killed_Reward', '5', 1, 'events');

-- ============================================================================
-- ACTIVITIES & SYSTEMS
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Activity_Bowling', 'true', 1, 'activities'),
('Activate_Traits', 'true', 1, 'activities'),
('Lottery_Ticket_Price', '2500', 1, 'activities'),
('Sleep_System', 'false', 1, 'activities'),
('Pee_System', 'true', 1, 'activities'),
('PlayTime_Gain', 'true', 1, 'activities'),
('PlayTime_1Hour_Gain', '1000', 1, 'activities');

-- ============================================================================
-- LICENSES
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Invisible_Licenses', '["company","chimicalf","steelf","petrolf","goodsf","weaponf","foodf","carf","boatf","airf","clothingf","jewelryf","impound","custom","cinema","dmv","dojmdtadmin","govmdtadmin","fisdk9","fisdert","fisddtu","fisdhw","fisdmrtm","fisdcorr","fisdhandgun","fisdfullauto","fisdlesslethal","fisdfirstaid","fisdshotgun","fisdmdtadmin","fifrmarshal","fifrsar","fifrrt","fifrmdtadmin"]', 1, 'licenses');

-- ============================================================================
-- SHOPS
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Shops_FurnitureStore', '["Shop_Furniture","Shop_Furniture2","Shop_Perk_Furniture","Shop_BetterBuy"]', 1, 'shops'),
('Shops_Faction', '["Shop_DOC"]', 1, 'shops'),
('Shops_Sell_One_by_One', '["log","cocaine_brick"]', 1, 'shops'),
('Shops_Max_Stock', '500', 1, 'shops');

-- ============================================================================
-- VEHICLES & SEATBELT
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Seatbelt_Blacklist', '["K_Scooter_DarkBlue","C_Quadbike_01_F","A3PL_Kx","A3PL_Fatboy","A3PL_Knucklehead","A3PL_1100R"]', 1, 'vehicles'),
('RadioAnim_VestList', '["","A3PL_DutyBelt","A3PL_Rangemaster_belt_blk","A3PL_Ghostbusters_Belt","A3PL_Holster_1","V_LegStrapBag_black_F","V_LegStrapBag_coyote_F","V_LegStrapBag_olive_F","A3PL_Sheriff_Belt_Test","A3PL_Rangemaster_belt","G506_ERT_Vest","A3PL_Clean_Safety_Vest","A3PL_Clean_Safety_Vest_Orange","A3PL_DMV_Safety_Vest","A3PL_FakeNews_Safety","A3PL_VFD_IC_Vest","A3PL_VFD_Vest","A3PL_FIFR_RideAlong_Safety","A3PL_FIFR_Safety","A3PL_FIFR_Safety_Command","A3PL_FIFR_Safety_EMT","A3PL_FIFR_Safety_Fire","A3PL_FIFR_Safety_Lieutenant","A3PL_FIFR_Safety_Paramedic","A3PL_FISD_Safety_Traffic","A3PL_Waste_Manage_Vest"]', 1, 'vehicles'),
('RadioAnim_VestBeltList', '["A3FL_VestBelt","A3FL_VestBelt2","A3FL_FISD_VestBelt_White","A3FL_FISD_VestBelt_White2","A3FL_FISD_VestBelt","A3FL_FISD_VestBelt2","A3FL_FISD_CMD_VestBelt","A3FL_FISD_CMD_VestBelt2","A3FL_FISD_DTU_VestBelt","A3FL_FISD_DTU_VestBelt2","A3FL_FISD_ESU_VestBelt","A3FL_FISD_ESU_VestBelt2","A3FL_FISD_HWY_VestBelt","A3FL_FISD_HWY_VestBelt2","A3FL_FISD_K9_VestBelt","A3FL_FISD_K9_VestBelt2"]', 1, 'vehicles');

-- ============================================================================
-- BANK
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Bank_CommonAccount_Price', '1500', 1, 'bank'),
('Bank_SavingsAccount_Limit', '75000', 1, 'bank'),
('Bank_SavingsAccount_Price', '5000', 1, 'bank'),
('Bank_CertificateOfDeposit_Limit', '500000', 1, 'bank'),
('Bank_CertificateOfDeposit_Price', '150000', 1, 'bank'),
('Bank_AmericanExpressPrice_Standard', '650', 1, 'bank'),
('Bank_AmericanExpressPrice_Gold', '3250', 1, 'bank'),
('Bank_AmericanExpressPrice_Platinum', '6500', 1, 'bank'),
('Bank_AmericanExpressCost_Standard', '25', 1, 'bank'),
('Bank_AmericanExpressCost_Gold', '90', 1, 'bank'),
('Bank_AmericanExpressCost_Platinum', '150', 1, 'bank'),
('Bank_AmericanExpressLimit_Standard', '50000', 1, 'bank'),
('Bank_AmericanExpressLimit_Gold', '350000', 1, 'bank'),
('Bank_AmericanExpressLimit_Platinum', '9999999', 1, 'bank'),
('Bank_ATM_Max_Deposit', '25000', 1, 'bank'),
('Bank_ATM_Deposit_Timer', '1600', 1, 'bank');

-- ============================================================================
-- MEDICAL
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Medical_LogLimit', '12', 1, 'medical'),
('Medical_Max_BloodLevel', '5000', 1, 'medical'),
('Medical_Blood_PerBag', '2000', 1, 'medical'),
('Medical_DoubleTap_Blacklist_Weapons', '["A3FL_MP7_T_Ammo","A3FL_UMP_T_Ammo","A3FL_Benelli_T_Ammo","A3PL_M16_BallT","A3FL_Glock_T_Ammo","A3FL_PepperSpray_Ball","FireDamage"]', 1, 'medical'),
('Medical_NoHitDamage', '["A3FL_MP7_T_Ammo","A3FL_UMP_T_Ammo","A3FL_Benelli_T_Ammo","A3PL_M16_BallT","A3FL_Glock_T_Ammo","A3FL_PepperSpray_Ball","A3PL_PickAxe_Bullet","A3PL_Shovel_Bullet","A3PL_Fireaxe_Bullet","A3PL_Machete_Bullet","A3PL_Axe_Bullet","A3FL_BaseballBat_Bullet","A3FL_PoliceBaton_Bullet","A3FL_GolfDriver_Bullet","A3FL_Shield_Bullet","A3FL_DickStick_Bullet","A3FL_Crowbar_Bullet"]', 1, 'medical'),
('Medical_Masks_Protect_Peperspray', '["G_Balaclava_combat","A3PL_FD_Mask"]', 1, 'medical'),
('Medical_Ragdoll_Weapons_With_Bruise', '["A3FL_BaseballBat_Bullet","A3FL_PoliceBaton_Bullet","A3FL_GolfDriver_Bullet","A3FL_Shield_Bullet","A3FL_DickStick_Bullet","A3FL_Crowbar_Bullet"]', 1, 'medical'),
('Medical_Ragdoll_Weapons_With_Cut', '["A3PL_PickAxe_Bullet","A3PL_Shovel_Bullet","A3PL_Fireaxe_Bullet","A3PL_Machete_Bullet","A3PL_Axe_Bullet"]', 1, 'medical'),
('Medical_NoDamage_Or_Others', '["A3PL_M16_BallT","A3FL_Glock_T_Ammo","A3PL_Paintball_Bullet","A3FL_Benelli_T_Ammo","A3FL_MP7_T_Ammo","A3FL_UMP_T_Ammo"]', 1, 'medical'),
('Medical_FIFR_Number_To_Be_Trapped', '3', 1, 'medical'),
('Medical_SuicideVest_Classname', '"A3PL_SuicideVest"', 1, 'medical'),
('Medical_Number_FIFR_Minimum_To_Treat', '3', 1, 'medical'),
('Medical_NoDamage_Bullets', '["B_408_Ball","A3PL_TaserBullet","A3PL_Taser2_Ammo","A3FL_Mossberg_590K_Beanie","A3FL_M870_Beanbag","A3PL_Predator_Bullet","A3PL_Extinguisher_Water_Ball","A3PL_High_Pressure_Water_Ball","A3PL_Medium_Pressure_Water_Ball","A3PL_Low_Pressure_Water_Ball","A3PL_High_Pressure_Foam_Ball","A3PL_Medium_Pressure_Foam_Ball","A3PL_Low_Pressure_Foam_Ball","FYD_flash_ammo"]', 1, 'medical'),
('Medical_Ragdoll_Weapons', '["A3PL_TaserBullet","A3PL_Taser2_Ammo","A3FL_Mossberg_590K_Beanie","A3FL_M870_Beanbag"]', 1, 'medical'),
('Medical_Projectile_Damage_Classnames_1', '["B_9x21_Ball","A3PL_P226_Ammo","A3FL_Glock_Ammo","A3FL_Uzi_Ammo","A3FL_MP5K_Ammo"]', 1, 'medical'),
('Medical_Projectile_Damage_1', '0.1', 1, 'medical'),
('Medical_Projectile_Damage_Classnames_2', '["B_45ACP_Ball","A3FL_P227_Ammo","A3FL_Vector_Ammo","A3FL_Thompson_Ammo","A3FL_FNX45_Ammo","A3FL_UMP_Ammo"]', 1, 'medical'),
('Medical_Projectile_Damage_2', '0.2', 1, 'medical'),
('Medical_Projectile_Damage_Classnames_3', '["A3FL_DesertEagle_Ammo"]', 1, 'medical'),
('Medical_Projectile_Damage_3', '0.4', 1, 'medical'),
('Medical_Projectile_Damage_Classnames_4', '["A3PL_M16_Ball","A3FL_Python_Ammo"]', 1, 'medical'),
('Medical_Projectile_Damage_4', '0.3', 1, 'medical'),
('Medical_Projectile_Damage_Classnames_5', '["A3FL_ACR_Ammo"]', 1, 'medical'),
('Medical_Projectile_Damage_5', '0.35', 1, 'medical'),
('Medical_Projectile_Damage_Classnames_6', '["B_762x39_Ball_F"]', 1, 'medical'),
('Medical_Projectile_Damage_6', '0.35', 1, 'medical'),
('Medical_Projectile_Damage_Classnames_7', '["A3FL_Mossberg_590K_buck","A3FL_Mossberg_590K_Breach","A3FL_Benelli_Buck","A3FL_Benelli_Slug","A3FL_Benelli_Breach"]', 1, 'medical'),
('Medical_Projectile_Damage_7', '0.4', 1, 'medical'),
('Medical_9_Bullets', '["B_9x21_Ball","A3PL_P226_Ammo","red_9x19_Ball","A3FL_Glock_Ammo","A3FL_Uzi_Ammo","A3FL_MP5_Ammo"]', 1, 'medical'),
('Medical_45_Bullets', '["B_45ACP_Ball","B_45ACP_Ball_Green","A3FL_P227_Ammo","A3FL_Vector_Ammo","A3FL_Thompson_Ammo","A3FL_FNX45_Ammo","A3FL_UMP_Ammo"]', 1, 'medical'),
('Medical_357_Bullets', '["A3FL_Python_Ammo"]', 1, 'medical'),
('Medical_46_Bullets', '["A3FL_MP7_Ammo"]', 1, 'medical'),
('Medical_50_Bullets', '["A3FL_DesertEagle_Ammo"]', 1, 'medical'),
('Medical_556_Bullets', '["A3PL_M16_Ball","B_556x45_Ball","B_556x45_Ball_Tracer_Yellow","B_580x42_Ball_F"]', 1, 'medical'),
('Medical_570_Bullets', '["B_570x28_Ball"]', 1, 'medical'),
('Medical_65_Bullets', '["B_65x39_Caseless_yellow","B_65x39_Caseless_green","B_65x39_Caseless","B_65x39_Case_green"]', 1, 'medical'),
('Medical_68_Bullets', '["A3FL_ACR_Ammo"]', 1, 'medical'),
('Medical_762_Bullets', '["B_762x39_Ball_F","B_762x39_Ball_Green_F","B_762x51_Ball"]', 1, 'medical'),
('Medical_338_Bullets', '["B_338_Ball"]', 1, 'medical'),
('Medical_127_Bullets', '["B_127x108_Ball"]', 1, 'medical'),
('Medical_408_Bullets', '["B_408_Ball"]', 1, 'medical'),
('Medical_12_Bullets', '["A3FL_Mossberg_590K_buck","A3FL_Mossberg_590K_Breach","A3FL_Benelli_Buck","B_12Gauge_Pellets_Submunition","A3FL_M870_Buck"]', 1, 'medical'),
('Medical_12S_Bullets', '["B_12Gauge_Slug_NoCartridge","A3FL_Benelli_Breach","A3FL_Benelli_Slug","A3FL_M870_Slug"]', 1, 'medical'),
('Medical_3006_Bullets', '["A3PL_3006"]', 1, 'medical'),
('Medical_BloodLoss_With_9_Bullets', '3', 1, 'medical'),
('Medical_BloodLoss_With_45_Bullets', '2.6', 1, 'medical'),
('Medical_BloodLoss_With_357_Bullets', '2.7', 1, 'medical'),
('Medical_BloodLoss_With_46_Bullets', '2.6', 1, 'medical'),
('Medical_BloodLoss_With_50_Bullets', '1.5', 1, 'medical'),
('Medical_BloodLoss_With_556_Bullets', '1.8', 1, 'medical'),
('Medical_BloodLoss_With_68_Bullets', '2', 1, 'medical'),
('Medical_BloodLoss_With_762_Bullets', '2.1', 1, 'medical'),
('Medical_BloodLoss_With_12_Bullets', '1', 1, 'medical'),
('Medical_BloodLoss_DonSang', '1000', 1, 'medical'),
('Medical_Heal_Price', '750', 1, 'medical'),
('Medical_Illegal_Heal_Price', '1500', 1, 'medical'),
('Medical_Uniform_ToAdd_After_Death', '["A3PL_citizen2_Uniform","A3PL_citizen3_Uniform","A3PL_citizen4_Uniform","A3PL_citizen5_Uniform"]', 1, 'medical'),
('Medical_Female_Uniform_ToAdd_After_Death', '["woman1","woman2","woman3"]', 1, 'medical'),
('Medical_CPR_Timer', '30', 1, 'medical'),
('Medical_BloodBag_Cooldown', '3600', 1, 'medical'),
('Medical_Autograft_Cooldown', '3600', 1, 'medical');

-- ============================================================================
-- TWITTER / PHONE
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Twitter_AD_Price', '100', 1, 'phone'),
('Twitter_ADC_Price', '1000', 1, 'phone'),
('Twitter_ADF_Price', '500', 1, 'phone'),
('Twitter_DN_Price', '250', 1, 'phone'),
('Twitter_Emojis', '[[";)","iPhone_X_icon_cleinoeil"],["<3","iPhone_X_icon_coeur"],[":)","iPhone_X_icon_content"],[":fuck:","iPhone_X_icon_fuck"],[":hi:","iPhone_X_icon_hi"],[":o","iPhone_X_icon_o"],[":ok:","iPhone_X_icon_ok"],[">:(","iPhone_X_icon_pascontent"],[";(","iPhone_X_icon_pleure"],[":(","iPhone_X_icon_triste"],[":christ:","pepeChrist"],[":hands:","pepeHands"],[":k:","pepeOk"],[":pog:","pepePoggers"],[":sad:","pepeSad"],[":think:","pepeThink"],[":yikes:","pepeYikes"],[":kekw:","kekw"],[":rip:","rip"],[":eggplant:","eggplant"],[":popcorn:","PepePopcorn"],[":p","iPhone_X_icon_p"],[":huh:","smudge"],[":facepalm:","facepalm"],[":snow:","snowflake"],[":bell:","bell"],[":gingerbread:","gingerbread"],[":gift:","gift"]]', 1, 'phone'),
('Phone_Forfait1_Price', '50', 1, 'phone'),
('Phone_Forfait2_Price', '125', 1, 'phone'),
('Phone_Forfait3_Price', '320', 1, 'phone'),
('Phone_Forfait4_Price', '700', 1, 'phone'),
('Phone_Resiliation_Price', '999', 1, 'phone'),
('Phone_Send_News_Price', '50000', 1, 'phone'),
('Phone_FactoryApp_ToShow', '["STR_A3PL_Phone_ImportExport","STR_Common_FactoryName_Chimical","STR_Common_FactoryName_Steel","STR_Common_FactoryName_Petrol","STR_Common_FactoryName_Goods","STR_Common_FactoryName_Foods","STR_Common_FactoryName_Boats","STR_Common_FactoryName_Aircrafts","STR_Common_FactoryName_Vehicles","STR_Common_FactoryName_LegalWeapons","STR_Common_FactoryName_FactionWeapons","STR_Common_FactoryName_FactionVehicles","STR_Common_FactoryName_IllegalWeapons"]', 1, 'phone'),
('Phone_GasStationApp_Names', '["STR_Common_WeaponFactory","Northdale","Elk City","Beach Valley","Stoney Creek","Silverton","Deadwood","Blackwood"]', 1, 'phone'),
('Phone_Gang_Price', '15000', 1, 'phone');

-- ============================================================================
-- BUSINESS & COMPANY
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Business_Min_Rent_Time', '1', 1, 'business'),
('Business_Max_Rent_Time', '720', 1, 'business'),
('Business_Rent_Cost_Per_Minutes', '42', 1, 'business'),
('Business_Objects', '["Land_A3FL_Airport_Hangar","Land_A3PL_Showroom","Land_A3PL_Garage","land_smallshop_ded_smallshop_02_f","land_smallshop_ded_smallshop_01_f","Land_A3FL_Brick_Shop_1","Land_A3FL_Brick_Shop_2","Land_A3FL_Anton_Store"]', 1, 'business'),
('Company_Edit_Description_Price', '5000', 1, 'business'),
('Company_Shops', '["Land_EC_Warehouse","Land_A3PL_Kainnon_DMV","Land_Shop_DED_Shop_02_F","Land_Shop_DED_Shop_01_F","Land_buildingGunStore1","Land_buildingsNightclub2","Land_A3PL_Cinema","Land_A3FL_Anton_Store","Land_A3PL_Garage","land_smallshop_ded_smallshop_02_f","land_smallshop_ded_smallshop_01_f","Land_A3FL_Brick_Shop_1","Land_A3FL_Brick_Shop_2","Land_A3PL_Showroom","Land_A3PL_Gas_Station","Land_A3FL_Airport_Hangar","Land_EC_CompanyStore"]', 1, 'business'),
('Company_Shops_Price', '90000', 1, 'business'),
('Company_Shops_HuntWeapons', '["EC_Huntingrifle","A3PL_CZ550"]', 1, 'business'),
('Company_Shops_HuntMags', '["EC_10rnd_308","A3PL_5rnd_3006"]', 1, 'business'),
('Company_Taxes_Amount', '500', 1, 'business');

-- ============================================================================
-- BUILDINGS
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Buildings_Used_For_Address', '["Land_EC_Warehouse","Land_EC_CompanyStore","Land_buildingGunStore1","Land_A3PL_Paycheck","Land_FYD_Courthouse","Land_buildingsNightclub2","Land_A3PL_Museum","Land_jobcenter","Land_A3PL_Kainnon_Fedex","Land_A3PL_Kainnon_ERT","Land_A3PL_Kainnon_DMV","Land_A3FL_Better_Buy","Land_A3FL_DOC_Gate","Land_A3FL_Fishers_Jewelry","Land_A3PL_Motel","Land_A3PL_Showroom","Land_A3PL_Bank","Land_A3PL_Capital","Land_A3PL_Sheriffpd","Land_A3FL_SheriffPD","Land_Shop_DED_Shop_01_F","land_smallshop_ded_smallshop_01_f","land_market_ded_market_01_f","Land_Taco_DED_Taco_01_F","Land_A3PL_Gas_Station","Land_A3PL_Garage","Land_John_Hangar","Land_A3PL_CG_Station","land_a3pl_ch","Land_A3PL_Clinic","Land_A3PL_Firestation","Land_FYD_Firestation","Land_Home1g_DED_Home1g_01_F","Land_Home2b_DED_Home2b_01_F","Land_Home3r_DED_Home3r_01_F","Land_Home4w_DED_Home4w_01_F","Land_Home5y_DED_Home5y_01_F","Land_Home6b_DED_Home6b_01_F","Land_Mansion01","Land_A3PL_Ranch3","Land_A3PL_Ranch2","Land_A3PL_Ranch1","Land_A3PL_ModernHouse1","Land_A3PL_ModernHouse2","Land_A3PL_ModernHouse3","Land_A3PL_BostonHouse","Land_A3PL_Shed3","Land_A3PL_Shed4","Land_A3PL_Shed2","Land_John_House_Grey","Land_John_House_Blue","Land_John_House_Red","Land_John_House_Green","Land_A3FL_Warehouse","Land_A3FL_Airport_Hangar","Land_A3FL_Airport_Terminal","Land_A3FL_Barn","Land_A3FL_Brick_Shop_1","Land_A3FL_Brick_Shop_2","Land_A3FL_Office_Building","Land_A3FL_Mansion","Land_A3FL_House1_Cream","Land_A3FL_House1_Green","Land_A3FL_House1_Blue","Land_A3FL_House1_Brown","Land_A3FL_House1_Yellow","Land_A3FL_House2_Cream","Land_A3FL_House2_Green","Land_A3FL_House2_Blue","Land_A3FL_House2_Brown","Land_A3FL_House2_Yellow","Land_A3FL_House3_Cream","Land_A3FL_House3_Green","Land_A3FL_House3_Blue","Land_A3FL_House3_Brown","Land_A3FL_House3_Yellow","Land_A3FL_House4_Cream","Land_A3FL_House4_Green","Land_A3FL_House4_Blue","Land_A3FL_House4_Brown","Land_A3FL_House4_Yellow","Land_A3FL_Anton_Modern_Bungalow","Land_A3FL_Trailer","Land_A3FL_Trailer_2","Land_A3FL_Trailer_3","Land_A3FL_Trailer_4","Land_A3FL_Trailer_5","Land_A3FL_Trailer_6","Land_A3FL_Crackhouse","Land_FYD_PARRAS_BigModernHouse","Land_FYD_Parras_Modern_House","Land_FYD_Parras_Modern_House_02","Land_FYD_Parras_Modern_House_03","Land_FYD_Parras_Modern_House_04","Land_EC_SheriffHQ","Land_dp_mainFactory_F"]', 1, 'buildings'),
('Buildings_Hangar', '["Land_A3PL_Shed2","Land_A3PL_Shed3","Land_A3PL_Shed4","Land_A3PL_BostonHouse"]', 1, 'buildings'),
('Buildings_Trailer', '["Land_A3FL_Trailer","Land_A3FL_Trailer_2","Land_A3FL_Trailer_3","Land_A3FL_Trailer_4","Land_A3FL_Trailer_5","Land_A3FL_Trailer_6"]', 1, 'buildings'),
('Building_Plane', '["Land_A3FL_House2_Cream","Land_A3FL_House2_Green","Land_A3FL_House2_Blue","Land_A3FL_House2_Brown","Land_A3FL_House2_Yellow"]', 1, 'buildings'),
('Buildings_1Floor_1Garage', '["Land_A3PL_Ranch1","Land_A3PL_Ranch2","Land_A3PL_Ranch3","Land_Home4w_DED_Home4w_01_F","Land_Home1g_DED_Home1g_01_F","Land_Home2b_DED_Home2b_01_F","Land_Home5y_DED_Home5y_01_F"]', 1, 'buildings'),
('Buildings_1Floor', '["Land_John_House_Grey","Land_John_House_Blue","Land_John_House_Red","Land_John_House_Green","Land_A3FL_Anton_Modern_Bungalow"]', 1, 'buildings'),
('Buildings_1FloorLittle_L', '["Land_A3FL_House4_Cream","Land_A3FL_House4_Green","Land_A3FL_House4_Blue","Land_A3FL_House4_Brown","Land_A3FL_House4_Yellow"]', 1, 'buildings'),
('Buildings_1FloorBig_L', '["Land_A3FL_House3_Cream","Land_A3FL_House3_Green","Land_A3FL_House3_Blue","Land_A3FL_House3_Brown","Land_A3FL_House3_Yellow"]', 1, 'buildings'),
('Buildings_2Floors_1Garage', '["Land_Home3r_DED_Home3r_01_F","Land_Home6b_DED_Home6b_01_F"]', 1, 'buildings'),
('Buildings_2Floors', '["Land_A3FL_House1_Cream","Land_A3FL_House1_Green","Land_A3FL_House1_Blue","Land_A3FL_House1_Brown","Land_A3FL_House1_Yellow","Land_FYD_Parras_Modern_House_02","Land_FYD_Parras_Modern_House_03","Land_FYD_Parras_Modern_House_04"]', 1, 'buildings'),
('Buildings_Villas', '["Land_Mansion01","Land_A3PL_ModernHouse1","Land_A3PL_ModernHouse2","Land_A3PL_ModernHouse3","Land_FYD_Parras_Modern_House"]', 1, 'buildings'),
('Buildings_BigVillas', '["Land_A3FL_Mansion","Land_FYD_PARRAS_BigModernHouse"]', 1, 'buildings');

-- ============================================================================
-- HUNTING & HOUSING
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Hunting_Skin_Timer', '20', 1, 'hunting'),
('Housing_Sell_Coef', '0.75', 1, 'housing'),
('Housing_Max_Items_Planter', '["A3PL_Wheat","A3PL_Corn","A3FL_Cannabis_Plant","A3PL_Lettuce","A3PL_Coco_Plant","A3PL_Sugarcane_Plant","A3FL_Carrot_Grow","A3FL_Tobacco_Plant"]', 1, 'housing'),
('Seeds_List', '["seed_wheat","seed_marijuana","seed_corn","seed_lettuce","seed_coca","seed_sugar","seed_carrot","seed_tobacco"]', 1, 'housing'),
('Surface_To_Plant_Seeds', '"#cype_plowedfield"', 1, 'housing'),
('Plant_AddXP', '1', 1, 'housing');

-- ============================================================================
-- DMV
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('DMV_Car_Exam_Price', '1250', 1, 'dmv'),
('DMV_Motorcycle_Exam_Price', '1250', 1, 'dmv'),
('DMV_Truck_Exam_Price', '5000', 1, 'dmv');

-- ============================================================================
-- GREENHOUSE
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('GreenHouse_Max_Location_Time', '1800', 1, 'greenhouse'),
('GreenHouse_Price', '250', 1, 'greenhouse'),
('GreenHouse_Max_Plant', '40', 1, 'greenhouse'),
('Test_Soil_Time', '5', 1, 'greenhouse');

-- ============================================================================
-- FISHING
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Fishing_Max_Net_Deployed', '16', 1, 'fishing');

-- ============================================================================
-- RESOURCES
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Resources_Picking_Time', '2', 1, 'resources'),
('Resources_Sand_Marker', '["A3PL_Marker_Sand1","A3PL_Marker_Sand2"]', 1, 'resources'),
('Resources_Sand_DigTime_In_Area', '10', 1, 'resources'),
('Resources_Sand_DigTime_Not_In_Area', '26', 1, 'resources');

-- ============================================================================
-- IMPORT EXPORT
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('ImportExport_Crane', 'true', 1, 'importexport'),
('ImportExport_Price_Crane', '340', 1, 'importexport');

-- ============================================================================
-- JOBS
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Job_Freight_Value', '2100', 1, 'jobs'),
('Job_Freight_Detroy_Fees', '10000', 1, 'jobs'),
('Job_Freight_Detroy_Fees_Random', '9500', 1, 'jobs'),
('Job_Freight_Reward', '300', 1, 'jobs'),
('Job_Freight_Reward_Random', '200', 1, 'jobs'),
('Job_Roadworker_RepairTerrain_Reward', '20', 1, 'jobs'),
('Job_Roadworker_RentVehicle_Price', '11345', 1, 'jobs'),
('Job_SFP_Secured_Cooldown', '3600', 1, 'jobs'),
('Job_SFP_Secure_Cooldown', '7200', 1, 'jobs'),
('Job_SFP_SecureCD_Cooldown', '600', 1, 'jobs'),
('Job_SFP_SecurePort_Timer', '30', 1, 'jobs'),
('Job_SFP_SecureStore_Timer', '30', 1, 'jobs'),
('Job_SFP_Secure_Reward', '60', 1, 'jobs'),
('Job_ShipCaptain_LCM_Classname', '"A3FL_LCM"', 1, 'jobs'),
('Job_ShipCaptain_Price', '11316', 1, 'jobs'),
('Job_Trucking_Whitelisted_Cars', '["A3PL_F150","A3PL_F150_Marker","A3PL_Ram","EC_DodgeRam","A3PL_Silverado","A3PL_MailTruck","A3FL_T370","A3FL_T440","A3PL_Box_Trailer","A3FL_F150","A3FL_F150_ML","A3PL_Silverado_ML","A3PL_Ram_ML","A3PL_Car_Trailer","A3PL_Lowloader"]', 1, 'jobs'),
('Job_Trucking_Pay_F150', '4', 1, 'jobs'),
('Job_Trucking_Pay_F450', '4', 1, 'jobs'),
('Job_Trucking_Pay_Ram', '6', 1, 'jobs'),
('Job_Trucking_Pay_Silverado', '6', 1, 'jobs'),
('Job_Trucking_Pay_Mailtruck', '8', 1, 'jobs'),
('Job_Trucking_Pay_T370', '24', 1, 'jobs'),
('Job_Trucking_Pay_T440', '33', 1, 'jobs'),
('Job_Trucking_Pay_BoxTrailer', '57', 1, 'jobs'),
('Job_Trucking_Pay_CarTrailer', '12', 1, 'jobs'),
('Job_Trucking_Pay_LowLoader', '51', 1, 'jobs'),
('Job_Trucking_Reward', '80', 1, 'jobs'),
('Job_Trucking_Destroy_Fees', '1000', 1, 'jobs'),
('Job_BetterBuy_Furnitures', '["furn_Fridge_2door_2_Black","furn_Fridge_2door_2_Gray","furn_Fridge_2door_2_Silver","furn_Fridge_Retro_Black","furn_Fridge_Retro_Red","furn_Fridge_Retro_White","furn_Fridge_Single_Gray","furn_Fridge_Single_Silver","furn_Fridge_2door","furn_Fridge_3door","furn_Range_DarkGray","furn_Range_Black","furn_Range_Silver","furn_Modern_Range_Black","furn_Modern_Range_Red","furn_Modern_Range_White","furn_Television_Large","furn_Television_Medium","furn_Television_Small","furn_Modern_Dryer","furn_Modern_Washer","furn_Old_Dryer","furn_Old_Dryer_2","furn_Old_Washer","furn_WaterHeater"]', 1, 'jobs'),
('Job_BetterBuy_FurnituresTypeOf', '["A3FL_Fridge_2door_2_Black","A3FL_Fridge_2door_2_Gray","A3FL_Fridge_2door_2_Silver","A3FL_Fridge_Retro_Black","A3FL_Fridge_Retro_Red","A3FL_Fridge_Retro_White","A3FL_Fridge_Single_Gray","A3FL_Fridge_Single_Silver","A3FL_Fridge_2door","A3FL_Fridge_3door","A3FL_Range_DarkGray","A3FL_Range_Black","A3FL_Range_Silver","A3FL_Modern_Range_Black","A3FL_Modern_Range_Red","A3FL_Modern_Range_White","A3FL_Television_Large","A3FL_Television_Medium","A3FL_Television_Small","A3FL_Modern_Dryer","A3FL_Modern_Washer","A3FL_Old_Dryer","A3FL_Old_Dryer_2","A3FL_Old_Washer","A3FL_WaterHeater"]', 1, 'jobs'),
('Job_BetterBuy_NumberOf_Furnitures', '5', 1, 'jobs'),
('Job_BetterBuy_Random_NumberOf_Furnitures', '5', 1, 'jobs'),
('Job_BetterBuy_Reward', '50', 1, 'jobs'),
('Job_BetterBuy_Random_Reward', '80', 1, 'jobs'),
('Job_BetterBuy_Cooldown', '600', 1, 'jobs'),
('Job_BetterBuy_Vehicle_Classname', '"A3FL_T370"', 1, 'jobs'),
('Job_BetterBuy_Price', '9751', 1, 'jobs'),
('Job_Taxi_Vehicle_Classname', '"A3PL_CVPI_Taxi"', 1, 'jobs'),
('Job_Taxi_Price', '9751', 1, 'jobs'),
('Job_Delivery_Reward', '100', 1, 'jobs'),
('Job_Delivery_Locations', '[[[3036.68,5620.54,0.00144005],"STR_Config_Master_DeliveryItem_OxygenBottle","STR_Config_Master_ClinicSilverton"],[[3036.68,5620.54,0.00144005],"STR_Config_Master_DeliveryItem_Chair","STR_Config_Master_ClinicSilverton"],[[3036.68,5620.54,0.00144005],"STR_Config_Master_DeliveryItem_Desk","STR_Config_Master_ClinicSilverton"],[[3036.68,5620.54,0.00144005],"STR_Config_Master_DeliveryItem_Trophee","STR_Config_Master_ClinicSilverton"],[[3036.68,5620.54,0.00144005],"STR_Config_Master_DeliveryItem_Leaf","STR_Config_Master_ClinicSilverton"],[[3036.68,5620.54,0.00144005],"STR_Config_Master_DeliveryItem_Pen","STR_Config_Master_ClinicSilverton"],[[3036.68,5620.54,0.00144005],"STR_Config_Master_DeliveryItem_Book","STR_Config_Master_ClinicSilverton"],[[3036.68,5620.54,0.00144005],"STR_Config_Master_DeliveryItem_Badge","STR_Config_Master_ClinicSilverton"],[[3036.68,5620.54,0.00144005],"STR_Config_Master_DeliveryItem_MedicalSupplies","STR_Config_Master_ClinicSilverton"],[[2685.52,5510.61,0.00143909],"STR_Config_Master_DeliveryItem_Paycheck","STR_Config_Master_BankSilverton"],[[2685.52,5510.61,0.00143909],"STR_Config_Master_DeliveryItem_Pen","STR_Config_Master_BankSilverton"],[[2685.52,5510.61,0.00143909],"STR_Config_Master_DeliveryItem_Leaf","STR_Config_Master_BankSilverton"],[[2685.52,5510.61,0.00143909],"STR_Config_Master_DeliveryItem_CreditCard","STR_Config_Master_BankSilverton"],[[10168.7,8716.73,0.00143862],"STR_Config_Master_DeliveryItem_SellContract","STR_Config_Master_CarshopNorthdale"],[[10168.7,8716.73,0.00143862],"STR_Config_Master_DeliveryItem_CarKeys","STR_Config_Master_CarshopNorthdale"],[[10168.7,8716.73,0.00143862],"STR_Config_Master_DeliveryItem_Repairwrench","STR_Config_Master_CarshopNorthdale"],[[10234.2,8490.62,0],"STR_Config_Master_DeliveryItem_Repairwrench","STR_Config_Master_GASStationNorthdale"],[[10234.2,8490.62,0],"STR_Config_Master_DeliveryItem_Jerrycan","STR_Config_Master_GASStationNorthdale"],[[10234.2,8490.62,0],"STR_Config_Master_DeliveryItem_Desk2","STR_Config_Master_GASStationNorthdale"],[[10046.1,8466.96,0],"STR_Config_Master_DeliveryItem_Phone","STR_Config_Master_GeneralStoreNorthdale"],[[10046.1,8466.96,0],"STR_Config_Master_DeliveryItem_Pipe","STR_Config_Master_GeneralStoreNorthdale"],[[10046.1,8466.96,0],"STR_Config_Master_DeliveryItem_Adapter","STR_Config_Master_GeneralStoreNorthdale"],[[10025.3,7932.18,0.00143862],"STR_Config_Master_DeliveryItem_SIMCard","STR_Config_Master_PhoneDeadwood"],[[10025.3,7932.18,0.00143862],"STR_Config_Master_DeliveryItem_Tournevis","STR_Config_Master_PhoneDeadwood"],[[10025.3,7932.18,0.00143862],"STR_Config_Master_DeliveryItem_Computer","STR_Config_Master_PhoneDeadwood"],[[3467.7,5666.68,0],"STR_Config_Master_DeliveryItem_KartWheel","STR_Config_Master_CircuitSilverton"],[[8776.13,6411.65,0],"STR_Config_Master_DeliveryItem_Computer","STR_Config_Master_JewelrySpringfield"],[[3479.68,7482.68,0.00143886],"STR_Config_Master_DeliveryItem_Net","STR_Config_Master_FishStoney"],[[2452.64,5564.99,0.00143957],"STR_Config_Master_DeliveryItem_Tournevis","STR_Config_Master_FurnitureSilverton"],[[10025.8,7869.81,0.00143909],"STR_Config_Master_DeliveryItem_Computer","STR_Config_Master_ClothingDeadwood"],[[3541.34,5157.79,0],"STR_Config_Master_DeliveryItem_Trophee","STR_Config_Master_Paintball"]]', 1, 'jobs'),
('Job_Waste_Clear_Time', '600', 1, 'jobs'),
('Job_Waste_Reward', '100', 1, 'jobs'),
('Job_Waste_EmptyTruck_Reward', '20', 1, 'jobs'),
('Job_Waste_TrashMarkers', '["marker_job_garbageman","trash_bin_1","trash_bin_2","trash_bin_3","trash_bin_4","trash_bin_5","trash_bin_6","trash_bin_7","trash_bin_8","trash_bin_9","trash_bin_10","trash_bin_11","trash_bin_12","trash_bin_13","trash_bin_14","trash_bin_15","trash_bin_16","trash_bin_17","trash_bin_18","trash_bin_19","trash_bin_20","trash_bin_21","trash_bin_22","trash_bin_23","trash_bin_24","trash_bin_25","trash_bin_26","trash_bin_27","trash_bin_28","trash_bin_29","trash_bin_30","trash_bin_31","trash_bin_32","trash_bin_33","trash_bin_34","trash_bin_35","trash_bin_36","trash_bin_37","trash_bin_38","trash_bin_39","trash_bin_40","trash_bin_41","trash_bin_42","trash_bin_43","trash_bin_44","trash_bin_45","trash_bin_46","trash_bin_72","trash_bin_73","trash_bin_74","trash_bin_75","trash_bin_76","trash_bin_77","trash_bin_78"]', 1, 'jobs'),
('Job_Deliver_Markers', '["marker_job_mailman6"]', 1, 'jobs'),
('Job_Exterminator_Markers', '["marker_job_exterminator"]', 1, 'jobs'),
('Job_Security_Markers', '["marker_job_security"]', 1, 'jobs'),
('Job_Trucking_Markers', '["marker_job_trucking","marker_job_trucking2"]', 1, 'jobs'),
('Job_BetterBuy_Markers', '["marker_shop_betterbuy"]', 1, 'jobs'),
('Job_TaxiMan_Markers', '["marker_taxi"]', 1, 'jobs'),
('Job_Agricultor_Markers', '["marker_shop_farming"]', 1, 'jobs'),
('Job_Lumberjack_Markers', '["marker_job_lumberjack","marker_job_lumberjack2"]', 1, 'jobs'),
('Job_FerryCaptin_Markers', '["marker_job_ferrycaptain2","marker_job_ferrycaptain3","marker_job_ferrycaptain4"]', 1, 'jobs'),
('Job_Freight_Markers', '["marker_job_airfreight","marker_job_airfreight2"]', 1, 'jobs'),
('Job_Roadworker_Markers', '["marker_job_roadside2","marker_job_roadside3","marker_job_roadside4","marker_job_roadside5","marker_job_roadside6"]', 1, 'jobs'),
('Job_Wildcat_Map_Oil_Price', '1000', 1, 'jobs'),
('Job_Wildcat_Map_Rares_Price', '2500', 1, 'jobs'),
('Job_Wildcat_Map_Others_Price', '500', 1, 'jobs'),
('Job_Wildcat_Markers_onMap_Timer', '900', 1, 'jobs'),
('Job_Wildcat_Prospection_Timer', '5', 1, 'jobs'),
('Job_Oil_Rare_Interval', '5', 1, 'jobs'),
('Job_Oil_Rare_Chance', '15', 1, 'jobs'),
('Job_Exterminator_Reward', '50', 1, 'jobs');

-- ============================================================================
-- ALCOHOL
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Alcohol_Visual_Effects', 'true', 1, 'alcohol'),
('Alcohol_CamShake_Effects', 'true', 1, 'alcohol'),
('Alcohol_Speed_Effects', 'true', 1, 'alcohol'),
('Alcohol_Fall_Effects', 'true', 1, 'alcohol');

-- ============================================================================
-- FIRE DEPARTMENT
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('FD_Fire_Hydrant_Inspection_Reward', '3000', 1, 'fd'),
('FD_Set_Alarm_Reward', '250', 1, 'fd'),
('FD_Check_Alarm_Deffect_Reward', '600', 1, 'fd'),
('FD_Check_Alarm_Work_Reward', '300', 1, 'fd'),
('FD_Time_To_Repair_Alarm', '30', 1, 'fd'),
('FD_Repair_Alarm_Reward', '5000', 1, 'fd'),
('FD_Members_Needed_To_Start_Fire', '3', 1, 'fd');

-- ============================================================================
-- GOVERNMENT
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('GOV_Faction_Min_Pay', '1', 1, 'gov'),
('GOV_Faction_Max_Pay', '10000', 1, 'gov'),
('GOV_Faction_Blueprint_Price', '2500', 1, 'gov'),
('GOV_Faction_EQ_Blueprint_Price', '80', 1, 'gov'),
('Threat_Level', 'true', 1, 'gov');

-- ============================================================================
-- WEAPONS
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Handguns_Swap_List', '["hgun_P07_F","hgun_P07_khk_F","hgun_P07_blk_F","hgun_Rook40_F","hgun_Pistol_heavy_01_F","hgun_ACPC2_F","hgun_Pistol_01_F","hgun_Pistol_heavy_02_F","A3FL_Glock17","A3FL_Glock18","A3FL_Glock26","A3PL_P226","A3FL_P227","A3ER_P320","A3FL_Beretta92","A3FL_DesertEagle","A3FL_DesertEagleGold","A3FL_Python","A3FL_PythonGold","A3FL_FNX45"]', 1, 'weapons'),
('Taser_Swap_List', '["A3PL_Taser","A3PL_Taser2"]', 1, 'weapons');

-- ============================================================================
-- POLICE DEPARTMENT
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('PD_Reach_For_Firearm_Timer', '10', 1, 'pd'),
('PD_Reach_For_Firearm_ChanceAlert', '70', 1, 'pd'),
('PD_Reach_For_Firearm_ChanceSuccess', '80', 1, 'pd'),
('PD_Time_To_Frisk', '4', 1, 'pd'),
('PD_Time_To_Patdown', '8', 1, 'pd'),
('PD_Impound_Bypass', '["A3PL_EMS_Locker","A3PL_P362_TowTruck","A3PL_Pierce_Ladder","A3PL_Pierce_Heavy_Ladder","A3PL_Pierce_Pumper","A3PL_Pierce_Rescue","A3PL_Box_Trailer"]', 1, 'pd'),
('PD_Check_Powder', '1800', 1, 'pd'),
('PD_Analyze_Timer', '90', 1, 'pd'),
('PD_Evidences_Members_Required', '5', 1, 'pd'),
('PD_Evidences_Time_To_Unload', '600', 1, 'pd'),
('PD_Evidences_Reward', '200000', 1, 'pd'),
('PD_Remove_Fake_Plate_Time', '45', 1, 'pd'),
('PD_Powder_Gun', '["hgun_P07_F","hgun_P07_khk_F","hgun_P07_blk_F","hgun_Pistol_heavy_01_F","hgun_ACPC2_F","hgun_Pistol_01_F","hgun_Rook40_F","A3FL_Glock17","A3FL_Glock26","A3FL_Glock18","A3PL_P226","A3FL_P227","A3FL_Beretta92","A3FL_DesertEagle","A3FL_DesertEagleGold","SMG_01_F","SMG_02_F","SMG_05_F","A3FL_Mossberg_590k","arifle_AKM_F","A3FL_AK110","A3PL_M16","A3FL_M4","A3FL_UMP","A3FL_Vector","A3FL_MP5K","A3FL_Uzi","A3FL_Thompson","A3FL_ACR","A3FL_MP7","A3FL_Benelli","A3FL_M870","A3FL_FNX45"]', 1, 'pd'),
('PD_Breach_Weapons', '["A3FL_Mossberg_590K_Breach","A3FL_M870_Breach","EC_DD_Bullet"]', 1, 'pd'),
('Dogs_Smell_Distance', '10', 1, 'pd'),
('Dogs_Illegal_Items', '["seed_marijuana","marijuana","cocaine","shrooms","cannabis_bud","cannabis_bud_cured","cannabis_grinded_5g","weed_bag_5g","weed_bag_10g","weed_bag_25g","weed_bag_50g","weed_bag_100g","weed_5g","weed_10g","weed_15g","weed_20g","weed_25g","weed_30g","weed_35g","weed_40g","weed_45g","weed_50g","weed_55g","weed_60g","weed_65g","weed_70g","weed_75g","weed_80g","weed_85g","weed_90g","weed_95g","weed_100g","jug_moonshine","turtle","coca_paste","cocaine_base","cocaine_hydrochloride","acetone","calcium_carbonate","potassium_permangate","ammonium_hydroxide","weed_bag_5g","weed_bag_10g","weed_bag_25g","weed_bag_50g","weed_bag_100g"]', 1, 'pd'),
('Dogs_Illegal_3D_Items', '["A3FL_Cannabis_Plant","A3FL_Cannabis_Plant_Hanging_Stage1","A3FL_Cannabis_Plant_Hanging_Stage2","A3FL_Cannabis_Plant_Hanging_Stage3","A3FL_Cannabis_Plant_Hanging_Stage4","A3PL_Cannabis_Bud","A3PL_MarijuanaBag","A3PL_PowderedMilk","A3PL_TacticalBacon","A3PL_Marijuana","A3PL_Seed_Marijuana","A3PL_Gunpowder","A3FL_DrugBag"]', 1, 'pd');

-- ============================================================================
-- PRISON
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('PD_Prison_Max_Time', '300', 1, 'prison'),
('PD_Prison_Need_To_Be_Release_By_Player', '2', 1, 'prison'),
('PD_Prison_FactionRequired_Keycard', '3', 1, 'prison'),
('PD_Prison_FactionRequired_LockpickCell', '3', 1, 'prison'),
('PD_Prison_Time_To_LockpickCell', '25', 1, 'prison'),
('PD_Prison_Time_To_SearchTrash', '30', 1, 'prison'),
('PD_Prison_FactionRequired_To_DigOut', '3', 1, 'prison'),
('PD_Prison_Time_To_DigOut', '30', 1, 'prison'),
('Remove_AnkleMonitor_Price', '10000', 1, 'prison'),
('Manufacturing_Plate_Time', '40', 1, 'prison'),
('Manufacturing_Plate_Reward', '500', 1, 'prison'),
('Active_GoodBehavior', 'true', 1, 'prison');

-- ============================================================================
-- FACTORY
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Factory_BlackList', '["seed_marijuana","marijuana","cocaine","shrooms","cannabis_bud","cannabis_bud_cured","cannabis_grinded_5g","weed_bag_5g","weed_bag_10g","weed_bag_25g","weed_bag_50g","weed_bag_100g","weed_5g","weed_10g","weed_15g","weed_20g","weed_25g","weed_30g","weed_35g","weed_40g","weed_45g","weed_50g","weed_55g","weed_60g","weed_65g","weed_70g","weed_75g","weed_80g","weed_85g","weed_90g","weed_95g","weed_100g","jug_moonshine","turtle","drill_bit","diamond_ill","diamond_emerald_ill","diamond_ruby_ill","diamond_sapphire_ill","diamond_alex_ill","diamond_aqua_ill","diamond_tourmaline_ill","v_lockpick","zipties","keycard","weed_bag_5g","weed_bag_10g","weed_bag_25g","weed_bag_50g","weed_bag_100g","cannabis_plant","cannabis_plant_stage1","cannabis_plant_stage2","cannabis_plant_stage3","cannabis_plant_stage4"]', 1, 'factory'),
('Factory_Foods_AllowItems', '["meat_firstprice_tranched","meat_pork_tranched","meat_agneau_tranched","meat_beef_tranched","carrot","tacoshell","lettuce","salad","apple","corn","burger_bun","cereal","fish_cooked","bread","applecookies","taco_cooked","burger_cooked","cookies","burger_full_cooked","lamington","soupcup","meatpie","sausages","pizzabites","fish_raw","burger_raw","fish_burned","burger_burnt","taco_raw","burger_full_raw","taco_burned","burger_full_burnt","coca","aluminium_ingot","sugarcane","plastic","wheat","bucket_full","meat_boar","meat_boar_tag","meat_cow","meat_cow_tag","meat_goat","meat_goat_tag","meat_scraps","meat_sheep","meat_sheep_tag","applejuice","donut_plain","donut_choc","donut_pink","sandwich_hamcheese","sandwich_veggie","waterbottle","waterbottleempty","coffee","coffee_cup_large","coffee_cup_medium","coffee_cup_small","candycane"]', 1, 'factory'),
('Factory_Goods_BlackList', '["crude_oil","scale","fan","grinder","planter","lamp_200w","lamp_500w","lamp_1000w","pavilion","workbench","cocaine_barrel","weed_rack"]', 1, 'factory');

-- ============================================================================
-- GARAGE
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Garage_LicensesPlate_Price', '20000', 1, 'garage'),
('Garage_Default_Plate', '["STR_Common_Job_Waste","STR_Common_Job_Deliver","STR_Common_Job_Exterminator","STR_Common_Vehicle_Plate_Karting","STR_Common_Vehicle_Plate_Federal","STR_Common_Job_Roadworker","STR_Common_Job_Taxi"]', 1, 'garage'),
('Garage_Material_Price', '5000', 1, 'garage'),
('Garage_Repair_Price', '100', 1, 'garage'),
('Garage_RepairAll_Price', '500', 1, 'garage'),
('Garage_Color_Price', '2000', 1, 'garage'),
('Garage_Color_PriceForFaction', '0', 1, 'garage');

-- ============================================================================
-- GAS
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Gas_Min_Default_Gallon_Price', '25', 1, 'gas'),
('Gas_Max_Default_Gallon_Price', '100', 1, 'gas'),
('Gas_Refuel_Time', '10', 1, 'gas');

-- ============================================================================
-- PLAYER / ILLEGAL
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Player_illegalItems', '["seed_marijuana","marijuana","cocaine","shrooms","cannabis_bud","cannabis_bud_cured","cannabis_grinded_5g","weed_bag_5g","weed_bag_10g","weed_bag_25g","weed_bag_50g","weed_bag_100g","weed_5g","weed_10g","weed_15g","weed_20g","weed_25g","weed_30g","weed_35g","weed_40g","weed_45g","weed_50g","weed_55g","weed_60g","weed_65g","weed_70g","weed_75g","weed_80g","weed_85g","weed_90g","weed_95g","weed_100g","jug_moonshine","turtle","drill_bit","diamond_ill","diamond_emerald_ill","diamond_ruby_ill","diamond_sapphire_ill","diamond_alex_ill","diamond_aqua_ill","diamond_tourmaline_ill","v_lockpick","zipties","Gunpowder","keycard","coca_paste","cocaine_base","cocaine_hydrochloride","net","jug","jug_green","jug_green_moonshine","ring","ringset","bracelet","crown","necklace","golden_dildo","calcium_carbonate","potassium_permangate","ammonium_hydroxide","acetone","hydrocloric_acid","sulphuric_acid","cyanide_pills","weed_bag_5g","weed_bag_10g","weed_bag_25g","weed_bag_50g","weed_bag_100g","cannabis_plant_stage1","cannabis_plant_stage2","cannabis_plant_stage3","cannabis_plant_stage4","weed_grinded_empty","weed_grinded_5","weed_grinded_10","weed_grinded_15","weed_grinded_20","weed_grinded_25","weed_grinded_30","weed_grinded_35","weed_grinded_40","weed_grinded_45","weed_grinded_50","weed_grinded_55","weed_grinded_60","weed_grinded_65","weed_grinded_70","weed_grinded_75","weed_grinded_80","weed_grinded_85","weed_grinded_90","weed_grinded_95","weed_grinded_100","blunt"]', 1, 'illegal'),
('Player_IllegalPhysicalItems', '["cocaine_brick","distillery","distillery_hose","planter","scale","grinder","cocaine_barrel","fan","weed_rack"]', 1, 'illegal'),
('Illegals_Markers', '[]', 1, 'illegal');

-- ============================================================================
-- LOCKPICKING
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Car_Lockpicking_Time', '60', 1, 'lockpicking'),
('Car_Lockpicking_Chance', '20', 1, 'lockpicking'),
('Car_Lockpicking_Coef', '1.25', 1, 'lockpicking'),
('Car_Lockpicking_Failed_addXP', '5', 1, 'lockpicking'),
('Car_Lockpicking_Success_addXP', '15', 1, 'lockpicking'),
('Handcuffs_Lockpicking_Skill_Required', '10', 1, 'lockpicking'),
('Handcuffs_Lockpicking_Time', '30', 1, 'lockpicking'),
('Handcuffs_Lockpicking_Chance', '20', 1, 'lockpicking'),
('Handcuffs_Lockpicking_Coef', '1.25', 1, 'lockpicking'),
('Handcuffs_Lockpicking_Failed_addXP', '10', 1, 'lockpicking'),
('Handcuffs_Lockpicking_Success_addXP', '30', 1, 'lockpicking'),
('AnkleMonitor_Lockpicking_Skill_Required', '20', 1, 'lockpicking'),
('AnkleMonitor_Lockpicking_Time', '45', 1, 'lockpicking'),
('AnkleMonitor_Lockpicking_Chance', '20', 1, 'lockpicking'),
('AnkleMonitor_Lockpicking_Coef', '1.25', 1, 'lockpicking'),
('AnkleMonitor_Lockpicking_Failed_addXP', '15', 1, 'lockpicking'),
('AnkleMonitor_Lockpicking_Success_addXP', '45', 1, 'lockpicking'),
('Keypad_Bypass_Time', '20', 1, 'lockpicking'),
('Keypad_Bypass_Alert_Chance', '40', 1, 'lockpicking');

-- ============================================================================
-- CRIMINAL
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('FindNPC_Default_Price', '15000', 1, 'criminal'),
('FakePlate_Install_Price', '25000', 1, 'criminal'),
('FakeID_Create_Price', '30000', 1, 'criminal'),
('CopyBlueprint_Price', '30000', 1, 'criminal'),
('Pimp_Price', '5100', 1, 'criminal');

-- ============================================================================
-- GANG
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Gang_Approve_By_Staff', 'true', 1, 'gang'),
('Gang_Desactive_Hideout', 'true', 1, 'gang'),
('Gang_Hideout_Cooldown', '600', 1, 'gang'),
('Gang_Hideout_Timer', '90', 1, 'gang'),
('Gang_Hideout_Reward', '25000', 1, 'gang'),
('Gang_Hideout_Paycheck', '4500', 1, 'gang'),
('Gang_Hideout_Secure_Timer', '120', 1, 'gang'),
('Gang_Hideout_ChanceNotifCops', '40', 1, 'gang'),
('Gang_Hideout_ChanceNotifGeneral', '40', 1, 'gang');

-- ============================================================================
-- APPEARANCE
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('HeadgearsList', '["H_Shemag_olive","H_Shemag_tan","H_Shemag_khk","A3PL_RacingHelmet_1","A3PL_RacingHelmet_2","A3PL_RacingHelmet_3","A3PL_RacingHelmet_4","A3PL_RacingHelmet_5","A3PL_RacingHelmet_6","A3PL_RacingHelmet_7","A3PL_RacingHelmet_8","A3PL_RacingHelmet_9","A3PL_RacingHelmet_10","A3PL_RacingHelmet_11","A3PL_Hoosier_Racing_Helmet","A3PL_SN_Race_Helmet","H_ShemagOpen_khk","H_ShemagOpen_tan","H_Shemag_olive_hs","A3PL_Horse_Mask","A3FL_Monkey_Brown"]', 1, 'appearance'),
('GogglesList', '["A3PL_Deadpool_Mask","A3PL_IronMan_Mask","A3PL_Anon_mask","G_Balaclava_blk","G_Balaclava_combat","G_Balaclava_TI_G_tna_F","G_Balaclava_lowprofile","G_Balaclava_oli","G_Balaclava_TI_tna_F","G_Balaclava_TI_G_blk_F","G_Balaclava_TI_blk_F","A3PL_Skull_Mask","A3PL_Watchdogs_Mask","G_Bandanna_aviator","G_Bandanna_blue_aviator","G_Bandanna_orange_aviator","G_Bandanna_pink_aviator","G_Bandanna_red_aviator","G_Bandanna_maroon_aviator","G_Bandanna_white_aviator","G_Bandanna_yellow_aviator","G_Bandanna_black_aviator","G_Bandanna_beast","G_Bandanna_blk","G_Bandanna_oli","G_Bandanna_shades","G_Bandanna_khk","G_Bandanna_tan","G_Bandanna_sport","G_AirPurifyingRespirator_01_F"]', 1, 'appearance'),
('Cant_Rob_With_This', '["","A3FL_PepperSpray","A3FL_GolfDriver","A3FL_BaseballBat","A3FL_BaseballBatGold","Rangefinder","hgun_Pistol_Signal_F","A3PL_FireAxe","A3PL_Shovel","A3PL_Pickaxe","A3PL_Golf_Club","A3PL_Jaws","A3PL_High_Pressure","A3PL_Medium_Pressure","A3PL_Low_Pressure","A3PL_Taser","A3PL_FireExtinguisher","A3PL_Paintball_Marker","A3PL_Paintball_Marker_Camo","A3PL_Paintball_Marker_PinkCamo","A3PL_Paintball_Marker_DigitalBlue","A3PL_Paintball_Marker_Green","A3PL_Paintball_Marker_Purple","A3PL_Paintball_Marker_Red","A3PL_Paintball_Marker_Yellow","A3PL_Predator","EC_PBP_ID"]', 1, 'appearance');

-- ============================================================================
-- HEIST - BETTER BUY
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Heist_BetterBuy_Cooldown', '1800', 1, 'heist'),
('Heist_BetterBuy_Min_Cops', '3', 1, 'heist'),
('Heist_BetterBuy_Time', '100', 1, 'heist'),
('Heist_BetterBuy_Reward', '18000', 1, 'heist'),
('Heist_BetterBuy_Random_Reward', '16000', 1, 'heist'),
('Heist_BetterBuy_Furniture_Cooldown', '3600', 1, 'heist'),
('Heist_BetterBuy_Furniture_Min_Cops', '4', 1, 'heist'),
('Heist_BetterBuy_Furniture_Time', '60', 1, 'heist'),
('Heist_BetterBuy_DeliveryLocation', '[["STR_Config_Master_CriminalBase",[7635,8552.24,0.00143862],317.5],["STR_Config_Master_NorthdaleAirport",[10708.8,8913.78,0.00143909],129.808],["STR_Config_Master_SilvertonAirport",[2597.63,5309.84,0.00143909],39.6191],["STR_Config_Master_IE",[3632.15,7558.32,0.0013895],92.6029]]', 1, 'heist'),
('Heist_BetterBuy_Deliver_Reward', '300', 1, 'heist'),
('Heist_BetterBuy_Deliver_Random_Reward', '1000', 1, 'heist');

-- ============================================================================
-- HEIST - BANK
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Heist_Bank_Timer', '600', 1, 'heist'),
('Heist_Bank_Min_Cops', '4', 1, 'heist'),
('Heist_Bank_Cooldown', '7200', 1, 'heist'),
('Heist_Bank_OpenDeposit_Timer', '60', 1, 'heist'),
('Heist_Bank_Money_Per_Pile', '180000', 1, 'heist'),
('Heist_Bank_Max_Money_Per_Bag', '600000', 1, 'heist'),
('Heist_Bank_PickCash_Timer', '10', 1, 'heist'),
('Heist_Bank_ConvertCash_Timer', '180', 1, 'heist');

-- ============================================================================
-- HEIST - PORT
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Heist_Port_Weapons_Type1', '["A3PL_M16","A3FL_M4","arifle_AKM_F","A3FL_AK110","A3FL_MK18","A3FL_ACR"]', 1, 'heist'),
('Heist_Port_Weapons_Type1_Duration', '100', 1, 'heist'),
('Heist_Port_Weapons_Type2', '["A3FL_Mossberg_590K","A3FL_M870","A3FL_Benelli"]', 1, 'heist'),
('Heist_Port_Weapons_Type2_Duration', '150', 1, 'heist'),
('Heist_Port_Weapons_Type3', '["SMG_05_F","SMG_02_F","SMG_01_F","A3FL_UMP","A3FL_Vector","A3FL_Thompson","A3FL_MP5K","A3FL_MP7","A3FL_Uzi"]', 1, 'heist'),
('Heist_Port_Weapons_Type3_Duration', '200', 1, 'heist'),
('Heist_Port_Weapons_Type4', '["A3FL_GolfDriver","A3FL_BaseballBat","A3FL_BaseballBatGold","A3FL_PoliceBaton","A3PL_FireAxe","A3PL_Shovel","A3PL_Pickaxe","A3PL_Golf_Club","A3FL_DickStick","A3FL_DickStickGold"]', 1, 'heist'),
('Heist_Port_Weapons_Type4_Duration', '270', 1, 'heist'),
('Heist_Port_Weapons_Default_Duration', '270', 1, 'heist'),
('Heist_Port_Cooldown', '1800', 1, 'heist'),
('Heist_Port_Rob_Cooldown', '900', 1, 'heist'),
('Heist_Port_Min_Cops', '2', 1, 'heist'),
('Heist_Port_Reduction_Shooting', '2', 1, 'heist'),
('Heist_Port_Minimum_Level_Speaking', '5', 1, 'heist'),
('Heist_Port_Reduction_Speak_Cooldown', '0.5', 1, 'heist'),
('Heist_Port_Questions_Reward', '1000', 1, 'heist'),
('Heist_Port_Weapons_Reward', '[]', 1, 'heist'),
('Heist_Port_Magazines_Reward', '[]', 1, 'heist'),
('Heist_Port_BonusWeapons_Cops_Superior_Or_Egal_3_Reward', '[]', 1, 'heist'),
('Heist_Port_BonusWeapons_Cops_Superior_Or_Egal_5_Reward', '[]', 1, 'heist'),
('Heist_Port_BonusMagazines_Cops_Superior_Or_Egal_5_Reward', '[]', 1, 'heist');

-- ============================================================================
-- HEIST - EVIDENCE
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Heist_Evidence_Timer', '1800', 1, 'heist'),
('Heist_Evidence_Min_Cops', '5', 1, 'heist'),
('Heist_Evidence_LockpickingSkill_Required', '5', 1, 'heist'),
('Heist_Evidence_Lockpicking_Time', '90', 1, 'heist'),
('Heist_Evidence_ChancesToActive_Lockdown', '40', 1, 'heist'),
('Heist_Evidence_Lockpicking_Success_AddXP', '75', 1, 'heist'),
('Heist_Evidence_Lockpicking_Failed_AddXP', '25', 1, 'heist');

-- ============================================================================
-- HEIST - PIRATE SHIP
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Heist_PirateShip_Min_Cops', '3', 1, 'heist'),
('Heist_PirateShip_Cooldown', '7200', 1, 'heist'),
('Heist_PirateShip_Timer', '480', 1, 'heist'),
('Heist_PirateShip_CaptureFlag_Timer', '60', 1, 'heist'),
('Heist_PirateShip_Money_Reward', '85000', 1, 'heist'),
('Heist_PirateShip_Money_Random_Reward', '15000', 1, 'heist'),
('Heist_PirateShip_Money_Random_With_Cops_Reward', '950', 1, 'heist'),
('Heist_PirateShip_Items_Reward', '[["weed_bag_100g",8],["shrooms",8],["cocaine",13]]', 1, 'heist');

-- ============================================================================
-- HEIST - DEALERSHIP & GOFAST
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Heist_DealerShip_Cooldown', '3600', 1, 'heist'),
('Heist_DealerShip_Min_Cops', '4', 1, 'heist'),
('Heist_DealerShip_Timer', '150', 1, 'heist'),
('Heist_DealerShip_Coefficient_1', '0.4', 1, 'heist'),
('Heist_DealerShip_Coefficient_2', '0.14', 1, 'heist'),
('Heist_DealerShip_StolenTimer', '2700', 1, 'heist'),
('Heist_GoFast_Cooldown', '3600', 1, 'heist'),
('Heist_GoFast_Min_Cops', '4', 1, 'heist'),
('Heist_GoFast_Timer', '10', 1, 'heist'),
('Heist_GoFast_Coefficient_1', '0.6', 1, 'heist'),
('Heist_GoFast_Coefficient_2', '0.16', 1, 'heist'),
('Heist_GoFast_StolenTimer', '2700', 1, 'heist');

-- ============================================================================
-- HEIST - STORE
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Heist_Store_Type1', '["A3PL_M16","A3FL_M4","arifle_AKM_F","A3FL_AK110","A3FL_MK18"]', 1, 'heist'),
('Heist_Store_Type1_Duration', '100', 1, 'heist'),
('Heist_Store_Type2', '["A3FL_Mossberg_590K"]', 1, 'heist'),
('Heist_Store_Type2_Duration', '150', 1, 'heist'),
('Heist_Store_Type3', '["SMG_05_F","SMG_02_F","SMG_01_F","A3FL_UMP","A3FL_Vector","A3FL_MP7","A3FL_Python","A3FL_PythonGold","A3FL_DesertEagle","A3FL_DesertEagleGold","A3FL_Uzi","A3FL_MP5K","A3FL_Thompson"]', 1, 'heist'),
('Heist_Store_Type3_Duration', '200', 1, 'heist'),
('Heist_Store_Type4', '[]', 1, 'heist'),
('Heist_Store_Type4_Duration', '270', 1, 'heist'),
('Heist_Store_Default_Duration', '270', 1, 'heist'),
('Heist_Store_Cooldown', '300', 1, 'heist'),
('Heist_Store_Cooldown_Secure', '1800', 1, 'heist'),
('Heist_Store_Min_Cops', '2', 1, 'heist'),
('Heist_Store_Money_Reward', '12500', 1, 'heist'),
('Heist_Store_GasStation_Money_Random_Reward', '14500', 1, 'heist'),
('Heist_Store_McFishers_Money_Random_Reward', '12500', 1, 'heist'),
('Heist_Store_TacoHell_Money_Random_Reward', '12500', 1, 'heist'),
('Heist_Store_Store_Money_Random_Reward', '2000', 1, 'heist'),
('Heist_Store_Store_Questions_Near_Buildings', '["Land_A3PL_Gas_Station","Land_Coffee_DED_Coffee_01_F","Land_Coffee_DED_Coffee_02_F","Land_Taco_DED_Taco_01_F","land_market_ded_market_01_f"]', 1, 'heist'),
('Heist_Store_Cops_Reward', '1000', 1, 'heist'),
('Heist_Store_Reduction_Shooting', '2', 1, 'heist'),
('Heist_Store_Minimum_Level_Speaking', '5', 1, 'heist'),
('Heist_Store_Reduction_Speak_Cooldown', '0.5', 1, 'heist');

-- ============================================================================
-- HEIST - JEWELRY
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Heist_Jewelry_Timer', '7200', 1, 'heist'),
('Heist_Jewelry_Min_Cops_ToDrill', '4', 1, 'heist'),
('Heist_Jewelry_Cooldown', '7200', 1, 'heist'),
('Heist_Jewelry_Items_Safe', '["diamond_ill","diamond_emerald_ill","diamond_ruby_ill","diamond_sapphire_ill","diamond_alex_ill","diamond_aqua_ill","diamond_tourmaline_ill"]', 1, 'heist'),
('Heist_Jewelry_Min_Cops_GlassDamage', '2', 1, 'heist'),
('Heist_Jewelry_TimeToRob_Glass1', '25', 1, 'heist'),
('Heist_Jewelry_TimeToRob_Glass2', '25', 1, 'heist'),
('Heist_Jewelry_TimeToRob_Glass3', '25', 1, 'heist'),
('Heist_Jewelry_TimeToRob_Glass4', '20', 1, 'heist'),
('Heist_Jewelry_TimeToRob_Glass5', '15', 1, 'heist'),
('Heist_Jewelry_TimeToRob_Glass6', '30', 1, 'heist'),
('Heist_Jewelry_TimeToRob_Glass7', '30', 1, 'heist'),
('Heist_Jewelry_TimeToRob_Glass8', '30', 1, 'heist'),
('Heist_Jewelry_TimeToRob_Glass9', '30', 1, 'heist'),
('Heist_Jewelry_Items_Glass1', '[["ringset",4],["ring",2],["bracelet",2]]', 1, 'heist'),
('Heist_Jewelry_Items_Glass2', '[["ringset",4],["ring",2],["bracelet",2]]', 1, 'heist'),
('Heist_Jewelry_Items_Glass3', '[["ringset",4],["ring",2],["bracelet",2]]', 1, 'heist'),
('Heist_Jewelry_Items_Glass4', '[["crown",1]]', 1, 'heist'),
('Heist_Jewelry_Items_Glass5', '[["necklace",1]]', 1, 'heist'),
('Heist_Jewelry_Items_Glass6', '[["golden_dildo",1]]', 1, 'heist'),
('Heist_Jewelry_Items_Glass7', '[["ringset",9],["ring",6],["bracelet",4]]', 1, 'heist'),
('Heist_Jewelry_Items_Glass8', '[["ringset",9],["ring",6],["bracelet",4]]', 1, 'heist'),
('Heist_Jewelry_Items_Glass9', '[["ringset",9],["ring",6],["bracelet",4]]', 1, 'heist');

-- ============================================================================
-- HEIST - HOUSE
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Heist_House_Cooldown', '3600', 1, 'heist'),
('Heist_House_Warehouse_Cooldown', '3600', 1, 'heist'),
('Heist_House_Crackhouse_Cooldown', '3600', 1, 'heist'),
('Heist_House_Rob_Cooldown', '600', 1, 'heist'),
('Heist_House_Rob_Warehouse_Cooldown', '600', 1, 'heist'),
('Heist_House_Rob_Crackhouse_Cooldown', '600', 1, 'heist'),
('Heist_House_Time_To_Rob', '120', 1, 'heist'),
('Heist_House_Min_Cops', '3', 1, 'heist'),
('Heist_House_Buildings_Type_Shed', '["Land_A3PL_BostonHouse","Land_A3PL_Shed3","Land_A3PL_Shed4","Land_A3PL_Shed2"]', 1, 'heist'),
('Heist_House_ChanceSilentAlarm_Shed', '90', 1, 'heist'),
('Heist_House_Buildings_Type_Trailer', '["Land_A3FL_Trailer","Land_A3FL_Trailer_2","Land_A3FL_Trailer_3","Land_A3FL_Trailer_4","Land_A3FL_Trailer_5","Land_A3FL_Trailer_6"]', 1, 'heist'),
('Heist_House_ChanceSilentAlarm_Trailer', '85', 1, 'heist'),
('Heist_House_Buildings_Type_SingleStory', '["Land_John_House_Grey","Land_John_House_Blue","Land_John_House_Red","Land_John_House_Green","Land_A3PL_Ranch3","Land_A3PL_Ranch2","Land_A3PL_Ranch1","Land_Home4w_DED_Home4w_01_F","Land_Home1g_DED_Home1g_01_F","Land_Home2b_DED_Home2b_01_F","Land_Home5y_DED_Home5y_01_F","Land_A3FL_House2_Cream","Land_A3FL_House2_Green","Land_A3FL_House2_Blue","Land_A3FL_House2_Brown","Land_A3FL_House2_Yellow","Land_A3FL_House3_Cream","Land_A3FL_House3_Green","Land_A3FL_House3_Blue","Land_A3FL_House3_Brown","Land_A3FL_House3_Yellow","Land_A3FL_House4_Cream","Land_A3FL_House4_Green","Land_A3FL_House4_Blue","Land_A3FL_House4_Brown","Land_A3FL_House4_Yellow"]', 1, 'heist'),
('Heist_House_ChanceSilentAlarm_SingleStory', '75', 1, 'heist'),
('Heist_House_Buildings_Type_TwoStory', '["Land_Home3r_DED_Home3r_01_F","Land_Home6b_DED_Home6b_01_F","Land_A3FL_House1_Cream","Land_A3FL_House1_Green","Land_A3FL_House1_Blue","Land_A3FL_House1_Brown","Land_A3FL_House1_Yellow"]', 1, 'heist'),
('Heist_House_ChanceSilentAlarm_TwoStory', '60', 1, 'heist'),
('Heist_House_Buildings_Type_SmallMansion', '["Land_A3FL_Anton_Modern_Bungalow","Land_A3PL_ModernHouse1","Land_A3PL_ModernHouse2","Land_A3PL_ModernHouse3","Land_Mansion01"]', 1, 'heist'),
('Heist_House_ChanceSilentAlarm_SmallMansion', '40', 1, 'heist'),
('Heist_House_Buildings_Type_BigMansion', '["Land_A3FL_Office_Building","Land_A3FL_Mansion","Land_FYD_PARRAS_BigModernHouse","Land_FYD_Parras_Modern_House","Land_FYD_Parras_Modern_House_02","Land_FYD_Parras_Modern_House_03","Land_FYD_Parras_Modern_House_04"]', 1, 'heist'),
('Heist_House_ChanceSilentAlarm_BigMansion', '30', 1, 'heist'),
('Heist_House_Buildings_Type_Warehouse', '["Land_John_Hangar","Land_A3FL_Warehouse"]', 1, 'heist'),
('Heist_House_ChanceSilentAlarm_Warehouse', '25', 1, 'heist'),
('Heist_House_Buildings_Type_Crackhouse', '["Land_A3FL_Crackhouse"]', 1, 'heist'),
('Heist_House_ChanceSilentAlarm_Crackhouse', '25', 1, 'heist'),
('Heist_House_LockpickingSkill_Required_House', '15', 1, 'heist'),
('Heist_House_LockpickingSkill_Required_Warehouse', '25', 1, 'heist'),
('Heist_House_LockpickingSkill_Required_Crackhouse', '30', 1, 'heist'),
('Heist_House_Lockpick_Chance', '20', 1, 'heist'),
('Heist_House_Lockpick_Coef', '1.25', 1, 'heist'),
('Heist_House_Lockpick_Failed_AddXP_Warehouse', '20', 1, 'heist'),
('Heist_House_Lockpick_Failed_AddXP_Others', '15', 1, 'heist'),
('Heist_House_Lockpick_Success_AddXP_Warehouse', '60', 1, 'heist'),
('Heist_House_Lockpick_Success_AddXP_Others', '45', 1, 'heist'),
('Heist_House_Reward_basicItems_Shed', '[[\"coke\",5],[\"apple\",5],[\"beer\",5],[\"jerrycan\",2],[\"repairwrench\",3],[\"bread\",5]]', 1, 'heist'),
('Heist_House_Reward_valuableItems_Shed', '[[\"coffee_cup_large\",3],[\"burger_full_cooked\",3],[\"shrooms\",4]]', 1, 'heist'),
('Heist_House_Reward_rareItems_Shed', '[[\"meatpie\",10],[\"cookies\",15],[\"lamington\",15],[\"sausages\",15],[\"shark_5lb_tag\",5],[\"mullet\",15],[\"turtle\",5]]', 1, 'heist'),
('Heist_House_Reward_basicItems_Trailer', '[[\"coke\",8],[\"apple\",8],[\"beer\",8],[\"jerrycan\",4],[\"repairwrench\",5],[\"bread\",7]]', 1, 'heist'),
('Heist_House_Reward_valuableItems_Trailer', '[[\"coffee_cup_large\",6],[\"burger_full_cooked\",6],[\"shrooms\",8]]', 1, 'heist'),
('Heist_House_Reward_rareItems_Trailer', '[[\"meatpie\",15],[\"cookies\",20],[\"lamington\",20],[\"sausages\",20],[\"shark_7lb_tag\",8],[\"mullet\",20],[\"turtle\",8]]', 1, 'heist'),
('Heist_House_Reward_basicItems_SingleStory', '[[\"coke\",8],[\"apple\",8],[\"beer\",8],[\"jerrycan\",4],[\"repairwrench\",5],[\"bread\",7]]', 1, 'heist'),
('Heist_House_Reward_valuableItems_SingleStory', '[[\"coffee_cup_small\",4],[\"burger_full_cooked\",6],[\"shrooms\",8]]', 1, 'heist'),
('Heist_House_Reward_rareItems_SingleStory', '[[\"dildo\",1],[\"seed_marijuana\",20],[\"seed_coca\",20],[\"cannabis_bud\",20],[\"cannabis_grinded_5g\",15],[\"weed_bag_100g\",1]]', 1, 'heist'),
('Heist_House_Reward_Random_Weapons_SingleStory', '[[\"A3PL_Shovel\",1],[\"A3FL_GolfDriver\",1],[\"A3FL_BaseballBat\",1],[\"A3PL_Pickaxe\",1],[\"A3FL_PoliceBaton\",1]]', 1, 'heist'),
('Heist_House_Reward_basicItems_TwoStory', '[[\"jerrycan\",4],[\"repairwrench\",5],[\"cereal\",10],[\"pizzabites\",10],[\"lamington\",10],[\"waterbottle\",2],[\"coffee_cup_small\",5]]', 1, 'heist'),
('Heist_House_Reward_valuableItems_TwoStory', '[[\"coca\",15],[\"calcium_carbonate\",10],[\"kerosene_jerrycan\",3],[\"sulphuric_acid\",10],[\"acetone\",10],[\"coca_paste\",5],[\"weed_bag_100g\",3],[\"turtle\",2]]', 1, 'heist'),
('Heist_House_Reward_Random_Weapons_TwoStory', '[[\"hgun_Pistol_heavy_01_F\",1],[\"hgun_ACPC2_F\",1],[\"A3FL_Beretta92\",1],[\"A3FL_DesertEagle\",1],[\"A3FL_Glock17\",1],[\"hgun_P07_blk_F\",1],[\"hgun_Pistol_01_F\",1],[\"hgun_Rook40_F\",1],[\"A3PL_P226\",1],[\"A3FL_P227\",1],[\"hgun_Pistol_heavy_02_F\",1]]', 1, 'heist'),
('Heist_House_Reward_basicItems_SmallMansion', '[[\"coffee_cup_medium\",5],[\"jerrycan\",5],[\"repairwrench\",6],[\"cereal\",15],[\"pizzabites\",15],[\"lamington\",15],[\"taco_cooked\",6],[\"burger_full_cooked\",6],[\"waterbottle\",3]]', 1, 'heist'),
('Heist_House_Reward_valuableItems_SmallMansion', '[[\"coca_paste\",15],[\"potassium_permangate\",10],[\"cocaine_base\",5],[\"weed_bag_100g\",5],[\"turtle\",4]]', 1, 'heist'),
('Heist_House_Reward_Random_Weapons_SmallMansion', '[[\"hgun_Pistol_heavy_01_F\",1],[\"hgun_ACPC2_F\",1],[\"A3FL_Beretta92\",1],[\"A3FL_DesertEagle\",1],[\"A3FL_Glock17\",1],[\"hgun_P07_blk_F\",1],[\"hgun_Pistol_01_F\",1],[\"hgun_Rook40_F\",1],[\"A3PL_P226\",1],[\"A3FL_P227\",1],[\"hgun_Pistol_heavy_02_F\",1]]', 1, 'heist'),
('Heist_House_Reward_basicItems_BigMansion', '[[\"coffee_cup_large\",5],[\"meatpie\",10],[\"taco_cooked\",15],[\"burger_full_cooked\",15],[\"waterbottle\",10],[\"jerrycan\",4],[\"repairwrench\",5]]', 1, 'heist'),
('Heist_House_Reward_valuableItems_BigMansion', '[[\"cocaine_base\",15],[\"ammonium_hydroxide\",10],[\"acetone\",10],[\"hydrocloric_acid\",10],[\"cocaine_hydrochloride\",5],[\"turtle\",6]]', 1, 'heist'),
('Heist_House_Reward_Random_Weapons_BigMansion', '[[\"hgun_Pistol_heavy_01_F\",1],[\"hgun_ACPC2_F\",1],[\"A3FL_Beretta92\",1],[\"A3FL_DesertEagle\",1],[\"A3FL_Glock17\",1],[\"hgun_P07_blk_F\",1],[\"hgun_Pistol_01_F\",1],[\"hgun_Rook40_F\",1],[\"A3PL_P226\",1],[\"A3FL_P227\",1],[\"hgun_Pistol_heavy_02_F\",1]]', 1, 'heist'),
('Heist_House_Reward_basicItems_Warehouse', '[[\"dildo\",1],[\"steel\",120],[\"aluminium\",120],[\"titanium\",90],[\"sand\",15],[\"jerrycan\",7],[\"repairwrench\",5]]', 1, 'heist'),
('Heist_House_Reward_valuableItems_Warehouse', '[[\"zipties\",3],[\"jug_moonshine\",6],[\"steel\",240],[\"aluminium\",240],[\"titanium\",120]]', 1, 'heist'),
('Heist_House_Reward_rareItems_Warehouse', '[[\"weed_bag_100g\",4],[\"v_lockpick\",5],[\"cocaine_hydrochloride\",8],[\"steel\",480],[\"aluminium\",480],[\"titanium\",360]]', 1, 'heist'),
('Heist_House_Reward_basicItems_Crackhouse', '[[\"dildo\",1]]', 1, 'heist'),
('Heist_House_Reward_valuableItems_Crackhouse', '[[\"jug_moonshine\",6],[\"cocaine_base\",15],[\"coca_paste\",15],[\"potassium_permangate\",10],[\"cocaine_base\",5],[\"weed_bag_100g\",5],[\"turtle\",4]]', 1, 'heist'),
('Heist_House_Reward_rareItems_Crackhouse', '[[\"cocaine_hydrochloride\",8],[\"cannabis_bud\",20],[\"cannabis_grinded_5g\",15],[\"weed_bag_100g\",1]]', 1, 'heist');

-- ============================================================================
-- DRUGS - COCAINE
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Cocaine_Produce_Timer', '30', 1, 'drugs'),
('Cocaine_Produce_Timer_Random', '10', 1, 'drugs'),
('Cocaine_Hydrochloride_Needed_To_Make_Brick', '10', 1, 'drugs'),
('Cocaine_Distance_Dealer', '200', 1, 'drugs'),
('Cocaine_Brick_Fabrication_Timer', '75', 1, 'drugs'),
('Cocaine_BreakDown_Brick_Timer', '60', 1, 'drugs'),
('Cocaine_Bag_Count', '9', 1, 'drugs'),
('Cocaine_Bag_Count_Random', '5', 1, 'drugs'),
('Cocaine_CamShake_Effects', 'true', 1, 'drugs'),
('Cocaine_Visual_Effects', 'true', 1, 'drugs');

-- ============================================================================
-- DRUGS - EXPLOSIVES
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Explosives_Explosion_AddItem_Chances', '50', 1, 'drugs'),
('Explosives_FireRescue_Needed_To_Create_Fire_When_AddItem', '5', 1, 'drugs'),
('Explosives_Explosion_Produce_Chances', '25', 1, 'drugs'),
('Explosives_FireRescue_Needed_To_Create_Fire_When_Produce', '5', 1, 'drugs');

-- ============================================================================
-- DRUGS - MOONSHINE
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Moonshine_Grind_Timer', '20', 1, 'drugs'),
('Moonshine_Transformation_Timer', '120', 1, 'drugs');

-- ============================================================================
-- DRUGS - SHROOMS
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Shrooms_Level_Max', '13', 1, 'drugs'),
('Shrooms_Gather_Timer', '3', 1, 'drugs'),
('Shrooms_Harvested', '1', 1, 'drugs'),
('Shrooms_AddXP', '1', 1, 'drugs'),
('Shrooms_Call_Police_Chances', '99', 1, 'drugs'),
('Shrooms_CamShake_Effects', 'true', 1, 'drugs'),
('Shrooms_Visual_Effects', 'true', 1, 'drugs');

-- ============================================================================
-- DRUGS - WEED
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Weed_HangPlant_AddXP', '3', 1, 'drugs'),
('Weed_Time_To_Dry_With_Fan', '480', 1, 'drugs'),
('Weed_Time_To_Dry_Without_Fan', '600', 1, 'drugs'),
('Weed_Dry_AddXP', '1', 1, 'drugs'),
('Weed_TrimPlant_AddXP', '2', 1, 'drugs'),
('Weed_Put_in_Bag_AddXP', '5', 1, 'drugs'),
('Weed_Visual_Effects', 'true', 1, 'drugs');

-- ============================================================================
-- HOOKER SYSTEM
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Activate_Hooker_System', 'true', 1, 'hooker'),
('Hooker_Price', '2500', 1, 'hooker'),
('Hooker_MoneyPerMinute', '500', 1, 'hooker'),
('Hooker_MoneyRadius', '20', 1, 'hooker'),
('Hooker_MotelRadius', '50', 1, 'hooker'),
('Hooker_CopRequired', '2', 1, 'hooker'),
('Hooker_ChancesToCallPolice', '3', 1, 'hooker');

-- ============================================================================
-- NPC PRICES
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('NPC_Weed_Price_weed_bag_5g', '140', 1, 'npc'),
('NPC_Weed_Price_weed_bag_10g', '255', 1, 'npc'),
('NPC_Weed_Price_weed_bag_25g', '638', 1, 'npc'),
('NPC_Weed_Price_weed_bag_50g', '1275', 1, 'npc'),
('NPC_Weed_Price_weed_bag_100g', '2550', 1, 'npc'),
('NPC_Cocaine_Price_cocaine', '2125', 1, 'npc'),
('NPC_Cocaine_Price_cocainebrick', '21250', 1, 'npc'),
('NPC_Moonshine_Price_jug_moonshine', '2652', 1, 'npc'),
('NPC_Shrooms_Price_shrooms', '309', 1, 'npc'),
('NPC_Reputation_ReputationPerSale', '10', 1, 'npc'),
('NPC_Reputation_Threshold_1', '50', 1, 'npc'),
('NPC_Reputation_Threshold_2', '100', 1, 'npc'),
('NPC_Reputation_Threshold_3', '200', 1, 'npc'),
('NPC_Reputation_Threshold_4', '201', 1, 'npc'),
('NPC_Reputation_MaxQuantity_Cocaine_Level1', '5', 1, 'npc'),
('NPC_Reputation_MaxQuantity_Cocaine_Level2', '10', 1, 'npc'),
('NPC_Reputation_MaxQuantity_Cocaine_Level3', '20', 1, 'npc'),
('NPC_Reputation_MaxQuantity_Cocaine_Level4', '40', 1, 'npc'),
('NPC_Reputation_MaxQuantity_Weed_Level1', '12', 1, 'npc'),
('NPC_Reputation_MaxQuantity_Weed_Level2', '24', 1, 'npc'),
('NPC_Reputation_MaxQuantity_Weed_Level3', '48', 1, 'npc'),
('NPC_Reputation_MaxQuantity_Weed_Level4', '96', 1, 'npc'),
('NPC_Reputation_MaxQuantity_Moonshine_Level1', '25', 1, 'npc'),
('NPC_Reputation_MaxQuantity_Moonshine_Level2', '50', 1, 'npc'),
('NPC_Reputation_MaxQuantity_Moonshine_Level3', '100', 1, 'npc'),
('NPC_Reputation_MaxQuantity_Moonshine_Level4', '200', 1, 'npc'),
('NPC_Reputation_MaxQuantity_Shrooms_Level1', '50', 1, 'npc'),
('NPC_Reputation_MaxQuantity_Shrooms_Level2', '100', 1, 'npc'),
('NPC_Reputation_MaxQuantity_Shrooms_Level3', '200', 1, 'npc'),
('NPC_Reputation_MaxQuantity_Shrooms_Level4', '400', 1, 'npc'),
('NPC_Info_Chance', '30', 1, 'npc');

-- ============================================================================
-- REPAIR
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Config_Repair_Workshop_Only', '["engine","chassis","trans","windows"]', 1, 'repair'),
('Config_Repair_Tinkerer_Parts', '["tyres","fueltank","brakerotors","driveshaft"]', 1, 'repair');

-- ============================================================================
-- RAID
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `category`) VALUES
('Raid_Alert_Chance', '0.25', 1, 'raid');

-- ============================================================================
-- VARIABLES DYNAMIQUES (objets mission, fonctions, random, hashmaps)
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `needs_compile`, `category`) VALUES
-- Objets de mission (wrappés dans "" pour que extDB3 les retourne comme string intact)
('Impounds_Lots', '"[Shop_ImpoundRetrieve,Shop_ImpoundRetrieve_1,Shop_ImpoundRetrieve_2,Shop_ImpoundRetrieve_3,Shop_ImpoundRetrieve_6,Shop_ImpoundRetrieve_7]"', 1, 1, 'impound'),
('Impounds_Air', '"[Shop_ImpoundRetrieve_4,Shop_ImpoundRetrieve_9]"', 1, 1, 'impound'),
('Impound_NewSystem', '0', 1, 0, 'impound'),
('Impound_DailyPercent', '10', 1, 0, 'impound'),
('Impound_MaxPercent', '70', 1, 0, 'impound'),
('Gang_Desactive_Hideout_Names', '"[hideout_obj_4]"', 1, 1, 'gang'),
('Gang_All_Hideouts', '"[hideout_obj_1,hideout_obj_2,hideout_obj_3,hideout_obj_4,hideout_obj_5]"', 1, 1, 'gang'),
('Gang_Hideout_1_Tax', '"[npc_fuel_1,NPC_general_1,npc_supermarket_1,Robbable_Shop_1,npc_perkfurniture_1,npc_perkfurniture_2,npc_roadworker]"', 1, 1, 'gang'),
('Gang_Hideout_2_Tax', '"[npc_roadworker_3,npc_fuel_9,NPC_general_3,Robbable_Shop_2,npc_supermarket_2,npc_furniture_5,npc_furniture_6,npc_furniture_7,npc_fuel_8]"', 1, 1, 'gang'),
('Gang_Hideout_3_Tax', '"[npc_barbershop_1,npc_roadworker_1,npc_fuel_6,npc_hunting,npc_illegal_eq,npc_perkfurniture_6,npc_perkfurniture_3,Robbable_Shop_9,NPC_general_5,npc_supermarket_4]"', 1, 1, 'gang'),
('Gang_Hideout_4_Tax', '"[npc_chemicaldealer]"', 1, 1, 'gang'),
('Gang_Hideout_5_Tax', '"[npc_fuel_10,Robbable_Shop_8,npc_clothingshop,npc_barbershop]"', 1, 1, 'gang'),
('Gang_Hideout_BodyDead', '"[npc_ill_trader,npc_ill_moonshine,npc_ill_cocaine,npc_ill_shrooms,npc_ill_weed]"', 1, 1, 'gang'),
('Job_Trucking_Destinations', '"[npc_import,npc_furniture_6,npc_perkfurniture_1,npc_mailman_silverton,npc_mailman_beachV,npc_hardware_1,npc_mailman_stoney,npc_perkfurniture_6,npc_mailman,npc_mailman_northdale,NPC_general_3,npc_fonderie]"', 1, 1, 'jobs'),
('Job_BetterBuy_DeliveryLocation', '"[[""STR_Config_Master_IE"",npc_import],[""STR_Config_Master_FurnitureShopNorthdale"",npc_furniture_6],[""STR_Config_Master_FurnitureShopSilverton"",npc_perkfurniture_1]]"', 1, 1, 'jobs'),
-- Appels de fonction (quotes internes echappees avec "")
('Heist_Store_Faction_Required', '"(""STR_Common_FISD"" call A3PL_Localize)"', 1, 1, 'heist'),
('Heist_Bank_Factions_Can_Secure', '"[""STR_Common_FISD"" call A3PL_Localize]"', 1, 1, 'heist'),
('Heist_Store_Cops_Account_Reward', '"[""STR_Common_SheriffsDepartment"" call A3PL_Localize]"', 1, 1, 'heist'),
-- Calculs avec random (quotes internes echappees avec "")
('Heist_Port_Items_Reward', '"[[""item"",""cash"",3000 + round(random(2500))],[""item"",""shark_2lb"",5],[""item"",""shark_2lb"",5],[""item"",""turtle"",5],[""item"",""bucket_full"",10]]"', 1, 1, 'heist'),
('Heist_Port_BonusItems_Cops_Superior_Or_Egal_3_Reward', '"[[""item"",""cash"",5000 + round(random(2500))],[""item"",""shark_2lb"",8],[""item"",""shark_2lb"",8],[""item"",""turtle"",8],[""item"",""bucket_full"",15]]"', 1, 1, 'heist'),
('Heist_Port_BonusItems_Cops_Superior_Or_Egal_5_Reward', '"[[""item"",""cash"",7000 + round(random(2500))],[""item"",""shark_2lb"",10],[""item"",""shark_2lb"",10],[""item"",""turtle"",10],[""item"",""bucket_full"",20]]"', 1, 1, 'heist'),
('Heist_Port_BonusItems_Cops_Superior_Or_Egal_7_Reward', '"[[""item"",""cash"",8000 + round(random(2500))],[""item"",""shark_2lb"",12],[""item"",""shark_2lb"",12],[""item"",""turtle"",120],[""item"",""bucket_full"",25]]"', 1, 1, 'heist'),
-- Hashmap (quotes internes echappees avec "")
('Config_ToolMagazines', '"createHashMapFromArray [[""A3PL_JawsOfLife"",""A3PL_FireaxeMag""],[""A3PL_Fireaxe"",""A3PL_FireaxeMag""],[""A3PL_Shovel"",""A3PL_ShovelMag""],[""A3PL_Extinguisher"",""A3PL_Extinguisher_Water_Mag""],[""A3PL_Golf_Club"",""A3PL_GolfMag""],[""EC_DD"",""EC_DDMag""],[""A3FL_BaseballBat"",""A3FL_BaseballBatMag""],[""A3FL_Crowbar"",""A3FL_Crowbar_Mag""],[""A3PL_Machinery_Pickaxe"",""A3PL_JackhammerMag""],[""A3PL_Pickaxe"",""A3PL_PickAxeMag""],[""A3FL_PoliceBaton"",""A3FL_PoliceBatonMag""]]"', 1, 1, 'tools');

-- ============================================================================
-- COMPANY SHOP MARKERS
-- ============================================================================
INSERT INTO `config_master` (`name`, `value`, `public`, `needs_compile`, `category`) VALUES
('CompanyShop_AvailableIcons', '"[[""A3FL_Markers_CompanyShopClosed"",""Default Shop""],[""A3FL_Markers_CompanyShopOpened"",""Open Shop""],[""hd_service"",""Service""],[""hd_fuel"",""Fuel Station""],[""loc_Transmitter"",""Electronics""],[""hd_food"",""Food""],[""loc_Hospital"",""Medical""],[""n_art"",""Industry""],[""hd_destroy"",""Auto/Repair""],[""loc_move"",""General""],[""mil_marker"",""Military Store""],[""hd_pickup"",""Pickup/Delivery""],[""loc_Ruin"",""Misc""]]"', 1, 1, 'company');

-- ============================================================================
-- IMPOUND SYSTEM V2 - Migration
-- ============================================================================
ALTER TABLE `players_objects` ADD COLUMN `impound_timestamp` INT UNSIGNED DEFAULT 0;
ALTER TABLE `players_objects` ADD COLUMN `impound_duration` INT UNSIGNED DEFAULT 0;
