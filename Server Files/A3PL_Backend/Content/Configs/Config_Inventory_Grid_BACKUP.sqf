/*
    Config_Inventory_Grid.sqf
    Configuration du systeme d'inventaire en grille

    Chaque conteneur (uniforme, gilet, sac) a une grille configurable
    Chaque item occupe un nombre de cases configurable (largeur x hauteur)
*/

["A3PL_Config_Inventory_Grid", {

    // ========================================================================
    // CONFIGURATION DES GRILLES PAR CONTENEUR
    // Format: [classname, [colonnes, lignes]]
    // ========================================================================

    Inventory_Grid_Containers = createHashMapFromArray [
        ["_default_uniform", [8, 2]],
        ["_default_vest", [8, 4]],
        ["_default_backpack", [8, 5]]
    ];

    // ========================================================================
    // CONFIGURATION DES TAILLES D'ITEMS
    // Format: [classname, [largeur, hauteur, maxStack]]
    // maxStack = nombre maximum d'items stackables sur une case (0 = pas de stack)
    // ========================================================================

    Inventory_Grid_Items = createHashMapFromArray [
        ["hgun_Pistol_heavy_01_F", [2, 2, 1]],
        ["hgun_Pistol_heavy_01_green_F", [2, 2, 1]],
        ["A3FL_Camera", [2, 2, 1]],
        ["A3PL_Golf_Club", [2, 2, 1]],
        ["A3PL_Taser", [2, 2, 1]],
        ["hgun_ACPC2_F", [2, 2, 1]],
        ["EC_PBP_ID", [2, 2, 1]],
        ["A3FL_Beretta92", [2, 2, 1]],
        ["A3PL_High_Pressure", [2, 2, 1]],
        ["A3FL_Python", [2, 2, 1]],
        ["A3FL_DesertEagle", [2, 2, 1]],
        ["A3PL_FireExtinguisher", [2, 2, 1]],
        ["A3FL_FiveSeven_Black", [2, 2, 1]],
        ["A3FL_FiveSeven_Pink", [2, 2, 1]],
        ["A3FL_FiveSeven", [2, 2, 1]],
        ["A3FL_FNX45", [2, 2, 1]],
        ["A3FL_Glock17", [2, 2, 1]],
        ["A3FL_Glock17_Tan", [2, 2, 1]],
        ["A3FL_Glock17S", [2, 2, 1]],
        ["A3FL_Glock17_T", [2, 2, 1]],
        ["A3FL_Glock18", [2, 2, 1]],
        ["A3FL_Glock26", [2, 2, 1]],
        ["A3FL_PythonGold", [2, 2, 1]],
        ["A3FL_DesertEagleGold", [2, 2, 1]],
        ["EC_HM1", [2, 2, 1]],
        ["A3PL_Jaws", [2, 2, 1]],
        ["A3FL_Uzi", [2, 2, 1]],
        ["hgun_P07_F", [2, 2, 1]],
        ["hgun_P07_khk_F", [2, 2, 1]],
        ["hgun_P07_blk_F", [2, 2, 1]],
        ["A3FL_PepperSpray", [2, 2, 1]],
        ["hgun_Pistol_Signal_F", [2, 2, 1]],
        ["hgun_Pistol_01_F", [2, 2, 1]],
        ["A3PL_Predator", [2, 2, 1]],
        ["hgun_Rook40_F", [2, 2, 1]],
        ["A3PL_Shovel", [2, 2, 1]],
        ["A3PL_P226", [2, 2, 1]],
        ["A3PL_P227", [2, 2, 1]],
        ["A3PL_P320", [2, 2, 1]],
        ["hgun_esd_01_F", [2, 2, 1]],
        ["A3PL_Taser2", [2, 2, 1]],
        ["EC_TEC9", [2, 2, 1]],
        ["hgun_Pistol_heavy_02_F", [2, 2, 1]],
        ["A3PL_Paintball_Marker", [3, 2, 1]],
        ["A3PL_Paintball_Marker_Camo", [3, 2, 1]],
        ["A3PL_Paintball_Marker_DigitalBlue", [3, 2, 1]],
        ["A3PL_Paintball_Marker_Green", [3, 2, 1]],
        ["A3PL_Paintball_Marker_PinkCamo", [3, 2, 1]],
        ["A3PL_Paintball_Marker_Purple", [3, 2, 1]],
        ["A3PL_Paintball_Marker_Red", [3, 2, 1]],
        ["A3PL_Paintball_Marker_Yellow", [3, 2, 1]],
        ["A3FL_AK110", [3, 2, 1]],
        ["A3FL_AK110_Gold", [3, 2, 1]],
        ["A3FL_BaseballBat", [3, 2, 1]],
        ["A3FL_Benelli", [3, 2, 1]],
        ["EC_MP9", [3, 2, 1]],
        ["A3PL_Machinery_Bucket", [3, 2, 1]],
        ["A3PL_M16", [3, 2, 1]],
        ["A3PL_M16_Training", [3, 2, 1]],
        ["A3FL_M4", [3, 2, 1]],
        ["A3FL_Thompson", [3, 2, 1]],
        ["A3FL_Crowbar", [3, 2, 1]],
        ["A3PL_CZ550", [3, 2, 1]],
        ["A3FL_MK18", [3, 2, 1]],
        ["A3FL_DickStick", [3, 2, 1]],
        ["A3FL_Shield_FIMS", [3, 2, 1]],
        ["A3PL_FireAxe", [3, 2, 1]],
        ["A3FL_Shield", [3, 2, 1]],
        ["EC_DD", [3, 2, 1]],
        ["A3FL_DickStickGold", [3, 2, 1]],
        ["A3FL_BaseballBatGold", [3, 2, 1]],
        ["A3FL_GolfDriver", [3, 2, 1]],
        ["A3FL_MP5K", [3, 2, 1]],
        ["A3FL_MP7", [3, 2, 1]],
        ["A3FL_UMP", [3, 2, 1]],
        ["A3PL_Machinery_Pickaxe", [3, 2, 1]],
        ["A3FL_Vector", [3, 2, 1]],
        ["A3FL_ACR", [3, 2, 1]],
        ["A3FL_Mossberg_590K", [3, 2, 1]],
        ["A3PL_Pickaxe", [3, 2, 1]],
        ["A3FL_PoliceBaton", [3, 2, 1]],
        ["SMG_05_F", [3, 2, 1]],
        ["A3FL_M870", [3, 2, 1]],
        ["EC_Huntingrifle", [3, 2, 1]],
        ["A3PL_Scypthe", [3, 2, 1]],

        ["med_bandage", [1, 1, 100]],
        ["med_icepack", [1, 1, 100]],
        ["med_splint", [1, 1, 100]],
        ["med_painkillers", [1, 1, 100]],
        ["med_narcan", [1, 1, 100]],
        ["med_autograftkit", [1, 1, 100]],
        ["med_autograft", [1, 1, 100]],
        ["med_cast", [1, 1, 100]],
        ["med_endotracheal", [1, 1, 100]],
        ["med_eyewash", [1, 1, 100]],
        ["med_kit", [1, 1, 100]],
        ["med_oxygenmask", [1, 1, 100]],
        ["med_antistress", [1, 1, 100]],
        ["meds_bloodbag", [1, 1, 100]],
        ["meds_bloodbagempty", [1, 1, 100]],

        ["weed_grinded_100", [1, 1, 25]],
        ["weed_bag_100g", [1, 1, 25]],
        ["weed_grinded_95", [1, 1, 25]],
        ["weed_grinded_90", [1, 1, 25]],
        ["weed_grinded_85", [1, 1, 25]],
        ["weed_grinded_80", [1, 1, 25]],
        ["weed_grinded_75", [1, 1, 25]],
        ["weed_grinded_70", [1, 1, 25]],
        ["weed_grinded_65", [1, 1, 25]],
        ["weed_grinded_60", [1, 1, 25]],
        ["weed_grinded_55", [1, 1, 25]],
        ["weed_grinded_50", [1, 1, 30]],
        ["weed_bag_50g", [1, 1, 30]],
        ["weed_grinded_45", [1, 1, 30]],
        ["weed_grinded_40", [1, 1, 30]],
        ["weed_grinded_35", [1, 1, 30]],
        ["weed_grinded_30", [1, 1, 30]],
        ["weed_grinded_25", [1, 1, 30]],
        ["weed_bag_25g", [1, 1, 30]],
        ["weed_grinded_20", [1, 1, 30]],
        ["weed_grinded_15", [1, 1, 30]],
        ["weed_grinded_10", [1, 1, 30]],
        ["weed_bag_10g", [1, 1, 30]],
        ["weed_grinded_5", [1, 1, 30]],
        ["weed_bag_5g", [1, 1, 30]],
        ["cocaine", [1, 1, 30]],
        ["cannabis_plant", [1, 1, 40]],
        ["cannabis_plant_stage1", [1, 1, 40]],
        ["cannabis_plant_stage2", [1, 1, 40]],
        ["cannabis_plant_stage3", [1, 1, 40]],
        ["cannabis_plant_stage4", [1, 1, 40]],
        ["seed_coca", [1, 1, 50]],
        ["seed_corn", [1, 1, 50]],
        ["seed_lettuce", [1, 1, 50]],
        ["seed_marijuana", [1, 1, 50]],
        ["seed_tobacco", [1, 1, 50]],
        ["seed_sugar", [1, 1, 50]],
        ["seed_wheat", [1, 1, 50]],
        ["seed_carrot", [1, 1, 50]],
        ["cannabis_bud", [1, 1, 50]],
        ["empty_ziplock", [1, 1, 50]],
        ["weed_grinded_empty", [1, 1, 50]],
        ["apple", [1, 1, 50]],
        ["banana", [1, 1, 50]],
        ["carrot", [1, 1, 50]],
        ["coca", [1, 1, 50]],
        ["corn", [1, 1, 50]],
        ["lettuce", [1, 1, 50]],
        ["tobacco", [1, 1, 50]],
        ["sugarcane", [1, 1, 50]],
        ["wheat", [1, 1, 50]],
        ["gold_ore", [1, 1, 40]],
        ["emerald_ore", [1, 1, 40]],
        ["coal_ore", [1, 1, 40]],
        ["amethyst_ore", [1, 1, 40]],
        ["aluminium_ore", [1, 1, 40]],
        ["vivianite_ore", [1, 1, 40]],
        ["titanium_ore", [1, 1, 40]],
        ["sulphur_ore", [1, 1, 40]],
        ["sapphire_ore", [1, 1, 40]],
        ["iron_ore", [1, 1, 40]],
        ["aluminium_ingot", [1, 1, 30]],
        ["amethyst_ingot", [1, 1, 30]],
        ["coal_ingot", [1, 1, 30]],
        ["emerald_ingot", [1, 1, 30]],
        ["gold_ingot", [1, 1, 30]],
        ["iron_ingot", [1, 1, 30]],
        ["sapphire_ingot", [1, 1, 30]],
        ["titanium_ingot", [1, 1, 30]],
        ["vivianite_ingot", [1, 1, 30]],
        ["sulphur_powder", [1, 1, 35]],
        ["diamond", [1, 1, 30]],
        ["diamond_ill", [1, 1, 30]],
        ["diamond_alex", [1, 1, 30]],
        ["diamond_alex_ill", [1, 1, 30]],
        ["diamond_aqua_ill", [1, 1, 30]],
        ["diamond_emerald", [1, 1, 30]],
        ["diamond_emerald_ill", [1, 1, 30]],
        ["diamond_ruby", [1, 1, 30]],
        ["diamond_ruby_ill", [1, 1, 30]],
        ["diamond_sapphire", [1, 1, 30]],
        ["diamond_sapphire_ill", [1, 1, 30]],
        ["diamond_tourmaline", [1, 1, 30]],
        ["diamond_tourmaline_ill", [1, 1, 30]],
        ["diamond_emerald_ill", [1, 1, 30]],
        ["diamond_ruby", [1, 1, 30]],
        ["diamond_ruby_ill", [1, 1, 30]],

        ["cash", [1, 1, 999999999]],
        ["_default", [1, 1, 15]]
    ];

    // ========================================================================
    // DESCRIPTIONS PERSONNALISEES DES ITEMS
    // Format: [classname, "description"]
    // Si pas de description, le tooltip n'affiche pas de ligne description
    // ========================================================================

    Inventory_Grid_Descriptions = createHashMapFromArray [
   
    ];

    // ========================================================================
    // CONSTANTES DE LA GRILLE UI
    // ========================================================================

    // Taille maximale de la grille visible (en cases)
    Inventory_Grid_MaxVisibleCols = 8;
    Inventory_Grid_MaxVisibleRows = 6;

    // Taille d'une case en pixels (relative a safezone)
    // Largeur grille = 0.216563 safezoneW, scrollbar = 0.012, espace disponible = 0.204563
    // Avec 8 cols et espacement 0.001: (0.204563 - 7*0.001) / 8 = 0.0247 par case
    Inventory_Grid_CellWidth = 0.0247;   // En ratio de safezoneW
    Inventory_Grid_CellHeight = 0.044;   // En ratio de safezoneH (pour cases carrees visuellement)

    // Espacement entre les cases
    Inventory_Grid_CellSpacing = 0.001;

    // Couleurs de la grille
    Inventory_Grid_CellColorEmpty = [0.1, 0.1, 0.1, 0.6];      // Case vide
    Inventory_Grid_CellColorHover = [0.3, 0.3, 0.3, 0.8];      // Survol
    Inventory_Grid_CellColorValid = [0.1, 0.5, 0.1, 0.8];      // Placement valide
    Inventory_Grid_CellColorInvalid = [0.5, 0.1, 0.1, 0.8];    // Placement invalide
    Inventory_Grid_CellColorOccupied = [0.2, 0.2, 0.2, 0.8];   // Case occupee

    // ========================================================================
    // CONFIGURATION DE LA GRILLE INVENTAIRE VIRTUEL
    // ========================================================================

    // Taille de grille pour joueurs standards (non-premium) sans sac à dos
    Inventory_Grid_Virtual_Default = [8, 5];

    // Taille de grille supplémentaire si le joueur porte un sac à dos
    Inventory_Grid_Virtual_Backpack = [8, 4];
    Inventory_Grid_Virtual_Backpack_With_Trait = [8, 7];

    // Taille de grille supplémentaire pour joueurs Premium
    Inventory_Grid_Virtual_Premium = [8, 5];

    // ========================================================================
    // FILTRES D'INVENTAIRE
    // Format: [filterName, [iconDefault, iconFocus, condition, tooltip, itemsCode, fromCode, loadCode, isVirtual, isKeys, isLicenses]]
    // ========================================================================

    Inventory_Filters = createHashMapFromArray [
        ["all", [
            "\A3PL_Common\GUI\inventory\UI_icons\ui_all_gs_32.paa",
            "\A3PL_Common\GUI\inventory\UI_icons\ui_all_gs_32_w.paa",
            {true},
            "STR_A3PL_Inventory_FilterAll",
            {(uniformItems player) + (vestItems player) + (backpackItems player)},
            {nil},
            {player call A3PL_InventoryNew_GetUnitContainerLoad},
            false, false, false
        ]],
        ["uniform", [
            "\A3PL_Common\GUI\inventory\UI_icons\ui_uniform_gs_32.paa",
            "\A3PL_Common\GUI\inventory\UI_icons\ui_uniform_gs_32_w.paa",
            {!((uniform player) isEqualTo "")},
            "STR_A3PL_Inventory_FilterUniform",
            {uniformItems player},
            {uniform player},
            {loadUniform player},
            false, false, false
        ]],
        ["backpack", [
            "\A3PL_Common\GUI\inventory\UI_icons\ui_backpack_gs_32.paa",
            "\A3PL_Common\GUI\inventory\UI_icons\ui_backpack_gs_32_w.paa",
            {!((backpack player) isEqualTo "")},
            "STR_A3PL_Inventory_FilterBackpack",
            {backpackItems player},
            {backpack player},
            {loadBackpack player},
            false, false, false
        ]],
        ["vest", [
            "\A3PL_Common\GUI\inventory\UI_icons\ui_vest_gs_32.paa",
            "\A3PL_Common\GUI\inventory\UI_icons\ui_vest_gs_32_w.paa",
            {!((vest player) isEqualTo "")},
            "STR_A3PL_Inventory_FilterVest",
            {vestItems player},
            {vest player},
            {loadVest player},
            false, false, false
        ]],
        ["virtual", [
            "\A3PL_Common\GUI\inventory\UI_icons\ui_rsc_gs_32.paa",
            "\A3PL_Common\GUI\inventory\UI_icons\ui_rsc_gs_32_w.paa",
            {true},
            "STR_A3PL_Inventory_FilterItems",
            {[] call A3PL_InventoryNew_GetVirtualItems},
            {"virtual"},
            {[] call A3PL_InventoryNew_GetVirtualLoad},
            true, false, false
        ]],
        ["keys", [
            "\A3PL_Common\GUI\inventory\UI_icons\ui_rsc_keys_32.paa",
            "\A3PL_Common\GUI\inventory\UI_icons\ui_rsc_keys_32_w.paa",
            {true},
            "STR_A3PL_Inventory_FilterKeys",
            {[] call A3PL_InventoryNew_GetKeysItems},
            {"keys"},
            {0},
            false, true, false
        ]],
        ["licenses", [
            "\A3PL_Common\GUI\inventory\UI_icons\ui_rsc_licenses_32.paa",
            "\A3PL_Common\GUI\inventory\UI_icons\ui_rsc_licenses_32_w.paa",
            {true},
            "STR_A3PL_Inventory_FilterLicenses",
            {[] call A3PL_InventoryNew_GetLicensesItems},
            {"licenses"},
            {0},
            false, false, true
        ]]
    ];

    // Ordre des filtres dans l'UI
    Inventory_FiltersOrder = ["all", "uniform", "backpack", "vest", "virtual", "keys", "licenses"];

    // ========================================================================
    // CONFIGURATION DES SLOTS D'EQUIPEMENT
    // Format: [slotName, [code, icon, tooltip, descShort, buttonIDC, imageIDC]]
    // ========================================================================

    Inventory_Equipment = createHashMapFromArray [
        ["uniform", [
            {uniform player},
            "\A3PL_Common\GUI\inventory\ui_uniform_gs.paa",
            "STR_A3PL_Inventory_SlotUniform",
            "STR_A3PL_Inventory_EquipUniform",
            6426, 6460
        ]],
        ["backpack", [
            {backpack player},
            "\A3PL_Common\GUI\inventory\ui_backpack_gs.paa",
            "STR_A3PL_Inventory_SlotBackpack",
            "STR_A3PL_Inventory_EquipBackpack",
            6427, 6461
        ]],
        ["vest", [
            {vest player},
            "\A3PL_Common\GUI\inventory\ui_vest_gs.paa",
            "STR_A3PL_Inventory_SlotVest",
            "STR_A3PL_Inventory_EquipVest",
            6425, 6462
        ]],
        ["headgear", [
            {headgear player},
            "\A3PL_Common\GUI\inventory\ui_headgear_gs.paa",
            "STR_A3PL_Inventory_SlotHeadgear",
            "STR_A3PL_Inventory_EquipHeadgear",
            6422, 6463
        ]],
        ["goggles", [
            {goggles player},
            "\A3PL_Common\GUI\inventory\ui_goggles_gs.paa",
            "STR_A3PL_Inventory_SlotGoggles",
            "STR_A3PL_Inventory_EquipGoggles",
            6424, 6464
        ]],
        ["binoculars", [
            {binocular player},
            "\A3PL_Common\GUI\inventory\ui_binoculars_gs.paa",
            "STR_A3PL_Inventory_SlotBinoculars",
            "STR_A3PL_Inventory_EquipBinoculars",
            6420, 6442
        ]],
        ["compass", [
            {if ("ItemCompass" in (assignedItems player)) then {"ItemCompass"} else {""}},
            "\A3PL_Common\GUI\inventory\ui_compass_gs.paa",
            "STR_A3PL_Inventory_SlotCompass",
            "STR_A3PL_Inventory_SlotCompass",
            6421, 6443
        ]],
        ["map", [
            {if ("ItemMap" in (assignedItems player)) then {"ItemMap"} else {""}},
            "\A3PL_Common\GUI\inventory\ui_map_gs.paa",
            "STR_A3PL_Inventory_SlotMap",
            "STR_A3PL_Inventory_SlotMap",
            6440, 6444
        ]],
        ["watch", [
            {if ("ItemWatch" in (assignedItems player)) then {"ItemWatch"} else {""}},
            "\A3PL_Common\GUI\inventory\ui_watch_gs.paa",
            "STR_A3PL_Inventory_SlotWatch",
            "STR_A3PL_Inventory_SlotWatch",
            6423, 6445
        ]],
        ["primaryweapon", [
            {primaryWeapon player},
            "\A3PL_Common\GUI\inventory\ui_primary_gs.paa",
            "STR_A3PL_Inventory_SlotPrimaryWeapon",
            "STR_A3PL_Inventory_EquipPrimaryWeapon",
            6418, 6446
        ]],
        ["secondaryweapon", [
            {secondaryWeapon player},
            "\A3PL_Common\GUI\inventory\ui_secondary_gs.paa",
            "STR_A3PL_Inventory_SlotSecondaryWeapon",
            "STR_A3PL_Inventory_EquipSecondaryWeapon",
            6417, 6447
        ]],
        ["handgunweapon", [
            {handgunWeapon player},
            "\A3PL_Common\GUI\inventory\ui_handgun_gs.paa",
            "STR_A3PL_Inventory_SlotHandgun",
            "STR_A3PL_Inventory_EquipHandgun",
            6419, 6441
        ]],
        ["primaryweapon_flashlight", [
            {(primaryWeaponItems player)#1},
            "\A3PL_Common\GUI\inventory\ui_flashlight_gs.paa",
            "STR_A3PL_Inventory_SlotWeaponFlashlight",
            "STR_A3PL_Inventory_WeaponFlashlight",
            6428, 6448
        ]],
        ["secondaryweapon_flashlight", [
            {(secondaryWeaponItems player)#1},
            "\A3PL_Common\GUI\inventory\ui_flashlight_gs.paa",
            "STR_A3PL_Inventory_SlotWeaponFlashlight",
            "STR_A3PL_Inventory_WeaponFlashlight",
            6432, 6449
        ]],
        ["handgunweapon_flashlight", [
            {(handgunItems player)#1},
            "\A3PL_Common\GUI\inventory\ui_flashlight_gs.paa",
            "STR_A3PL_Inventory_SlotWeaponFlashlight",
            "STR_A3PL_Inventory_WeaponFlashlight",
            6436, 6450
        ]],
        ["handgunweapon_magazine", [
            {if ((handgunMagazine player) isEqualTo []) then {""} else {(handgunMagazine player)#0}},
            "\A3PL_Common\GUI\inventory\ui_magazine_gs.paa",
            "STR_A3PL_Inventory_SlotWeaponMagazine",
            "STR_A3PL_Inventory_WeaponMagazine",
            6437, 6451
        ]],
        ["secondaryweapon_magazine", [
            {if ((secondaryWeaponMagazine player) isEqualTo []) then {""} else {(secondaryWeaponMagazine player)#0}},
            "\A3PL_Common\GUI\inventory\ui_magazine_gs.paa",
            "STR_A3PL_Inventory_SlotWeaponMagazine",
            "STR_A3PL_Inventory_WeaponMagazine",
            6433, 6452
        ]],
        ["primaryweapon_magazine", [
            {if ((primaryWeaponMagazine player) isEqualTo []) then {""} else {(primaryWeaponMagazine player)#0}},
            "\A3PL_Common\GUI\inventory\ui_magazine_gs.paa",
            "STR_A3PL_Inventory_SlotWeaponMagazine",
            "STR_A3PL_Inventory_WeaponMagazine",
            6429, 6453
        ]],
        ["secondaryweapon_muzzle", [
            {(secondaryWeaponItems player)#0},
            "\A3PL_Common\GUI\inventory\ui_muzzle_gs.paa",
            "STR_A3PL_Inventory_SlotWeaponMuzzle",
            "STR_A3PL_Inventory_WeaponMuzzle",
            6434, 6454
        ]],
        ["primaryweapon_muzzle", [
            {(primaryWeaponItems player)#0},
            "\A3PL_Common\GUI\inventory\ui_muzzle_gs.paa",
            "STR_A3PL_Inventory_SlotWeaponMuzzle",
            "STR_A3PL_Inventory_WeaponMuzzle",
            6430, 6455
        ]],
        ["handgunweapon_muzzle", [
            {(handgunItems player)#0},
            "\A3PL_Common\GUI\inventory\ui_muzzle_gs.paa",
            "STR_A3PL_Inventory_SlotWeaponMuzzle",
            "STR_A3PL_Inventory_WeaponMuzzle",
            6438, 6456
        ]],
        ["handgunweapon_optic", [
            {(handgunItems player)#2},
            "\A3PL_Common\GUI\inventory\ui_optic_gs.paa",
            "STR_A3PL_Inventory_SlotWeaponOptic",
            "STR_A3PL_Inventory_WeaponOptic",
            6439, 6457
        ]],
        ["secondaryweapon_optic", [
            {(secondaryWeaponItems player)#2},
            "\A3PL_Common\GUI\inventory\ui_optic_gs.paa",
            "STR_A3PL_Inventory_SlotWeaponOptic",
            "STR_A3PL_Inventory_WeaponOptic",
            6435, 6458
        ]],
        ["primaryweapon_optic", [
            {(primaryWeaponItems player)#2},
            "\A3PL_Common\GUI\inventory\ui_optic_gs.paa",
            "STR_A3PL_Inventory_SlotWeaponOptic",
            "STR_A3PL_Inventory_WeaponOptic",
            6431, 6459
        ]]
    ];

    // ========================================================================
    // ACTIONS SUR LES ITEMS PHYSIQUES (CfgInventoryActions)
    // Format: [actionName, [condition, text, code, subActions]]
    // subActions: [] ou [[subName, condition, text, code], ...]
    // ========================================================================

    Inventory_ItemActions = createHashMapFromArray [
        ["gearUp", [
            {_item call A3PL_InventoryNew_CanEquipItem},
            ("STR_A3PL_Inventory_Equip"),
            {params ["_item", "_count", "_from"]; [_item, _from] call A3PL_InventoryNew_EquipItemFromInventory},
            []
        ]],
        ["transfert", [
            {_filterName != "all"},
            ("STR_A3PL_Inventory_TransferTo"),
            {},
            [
                ["toBackpack", {(player canAddItemToBackpack [_item, 1]) && {_filterName != "backpack"}}, "STR_A3PL_Inventory_FilterBackpack", {params ["_item", "_count", "_from"]; [_item, _count, _from, backpack player] call A3PL_InventoryNew_TransfertItemTo}],
                ["toVest", {(player canAddItemToVest [_item, 1]) && {_filterName != "vest"}}, "STR_A3PL_Inventory_FilterVest", {params ["_item", "_count", "_from"]; [_item, _count, _from, vest player] call A3PL_InventoryNew_TransfertItemTo}],
                ["toUniform", {(player canAddItemToUniform [_item, 1]) && {_filterName != "uniform"}}, "STR_A3PL_Inventory_FilterUniform", {params ["_item", "_count", "_from"]; [_item, _count, _from, uniform player] call A3PL_InventoryNew_TransfertItemTo}]
            ]
        ]],
        ["drop_single", [
            {(_count isEqualTo 1) && {(vehicle player) isKindOf "Man"}},
            ("STR_A3PL_Inventory_Drop"),
            {params ["_item", "_count", "_from"]; [_item, 1, _from] call A3PL_InventoryNew_DropItem},
            []
        ]],
        ["drop_multiple", [
            {(_count > 1) && {(vehicle player) isKindOf "Man"}},
            ("STR_A3PL_Inventory_Drop"),
            {},
            [
                ["one", {true}, "STR_A3PL_Inventory_DropOne", {params ["_item", "_count", "_from"]; [_item, 1, _from] call A3PL_InventoryNew_DropItem}],
                ["all", {true}, "STR_A3PL_Inventory_DropAll", {params ["_item", "_count", "_from"]; [_item, _count, _from] call A3PL_InventoryNew_DropItem}],
                ["amount", {true}, "STR_A3PL_Inventory_DropAmount", {
                    params ["_item", "_count", "_from"];
                    private _displayName = getText(configFile >> "CfgWeapons" >> _item >> "displayName");
                    if (_displayName isEqualTo "") then {_displayName = getText(configFile >> "CfgMagazines" >> _item >> "displayName")};
                    if (_displayName isEqualTo "") then {_displayName = getText(configFile >> "CfgGlasses" >> _item >> "displayName")};
                    if (_displayName isEqualTo "") then {_displayName = _item};
                    ["STR_A3PL_Inventory_DropAmountTitle" call A3PL_Localize, format ["STR_A3PL_Inventory_DropAmountPrompt" call A3PL_Localize, _displayName, _count], _count, {
                        params ["_amount", "_item", "_count", "_from"];
                        [_item, _amount, _from] call A3PL_InventoryNew_DropItem;
                    }, true, _from] call A3PL_InventoryNew_InputAmount;
                }]
            ]
        ]],
        ["hotbar", [
            {[_item] call A3PL_Hotbar_CanAssign},
            "STR_A3PL_Inventory_AssignToHotbar",
            {},
            [
                ["slot1", {true}, "STR_A3PL_Inventory_Slot1", {params ["_item"]; [0, _item] call A3PL_Hotbar_SetSlot}],
                ["slot2", {true}, "STR_A3PL_Inventory_Slot2", {params ["_item"]; [1, _item] call A3PL_Hotbar_SetSlot}],
                ["slot3", {true}, "STR_A3PL_Inventory_Slot3", {params ["_item"]; [2, _item] call A3PL_Hotbar_SetSlot}],
                ["slot4", {true}, "STR_A3PL_Inventory_Slot4", {params ["_item"]; [3, _item] call A3PL_Hotbar_SetSlot}],
                ["slot5", {true}, "STR_A3PL_Inventory_Slot5", {params ["_item"]; [4, _item] call A3PL_Hotbar_SetSlot}],
                ["slot6", {(player getVariable ["Player_PerkDay", 0]) > 0}, "STR_A3PL_Inventory_Slot6Premium", {params ["_item"]; [5, _item] call A3PL_Hotbar_SetSlot}],
                ["slot7", {(player getVariable ["Player_PerkDay", 0]) > 0}, "STR_A3PL_Inventory_Slot7Premium", {params ["_item"]; [6, _item] call A3PL_Hotbar_SetSlot}],
                ["slot8", {(player getVariable ["Player_PerkDay", 0]) > 0}, "STR_A3PL_Inventory_Slot8Premium", {params ["_item"]; [7, _item] call A3PL_Hotbar_SetSlot}],
                ["slot9", {(player getVariable ["Player_PerkDay", 0]) > 0}, "STR_A3PL_Inventory_Slot9Premium", {params ["_item"]; [8, _item] call A3PL_Hotbar_SetSlot}],
                ["slot0", {(player getVariable ["Player_PerkDay", 0]) > 0}, "STR_A3PL_Inventory_Slot0Premium", {params ["_item"]; [9, _item] call A3PL_Hotbar_SetSlot}]
            ]
        ]]
    ];

    // Ordre des actions dans le menu contextuel
    Inventory_ItemActionsOrder = ["gearUp", "transfert", "drop_single", "drop_multiple", "hotbar"];

    // ========================================================================
    // ACTIONS SUR LES ITEMS VIRTUELS (CfgVirtualItemActions)
    // ========================================================================

    Inventory_VirtualItemActions = createHashMapFromArray [
        ["use_single", [
            {([_item, "canUse"] call A3PL_Config_GetItem) && {_count isEqualTo 1}},
            "STR_A3PL_Inventory_Use",
            {params ["_item"]; (findDisplay 6400) closeDisplay 0; [_item] call A3PL_Inventory_Use},
            []
        ]],
        ["use_multiple", [
            {([_item, "canUse"] call A3PL_Config_GetItem) && {_count > 1}},
            "STR_A3PL_Inventory_Use",
            {},
            [
                ["one", {true}, "STR_A3PL_Inventory_UseOne", {params ["_item"]; (findDisplay 6400) closeDisplay 0; [_item, false, 1] call A3PL_Inventory_Use}],
                ["all", {true}, "STR_A3PL_Inventory_UseAll", {params ["_item", "_count"]; (findDisplay 6400) closeDisplay 0; [_item, false, _count] call A3PL_Inventory_Use}],
                ["amount", {true}, "STR_A3PL_Inventory_UseAmount", {
                    params ["_item", "_count"];
                    private _displayName = [_item, "displayName"] call A3PL_Config_GetItem;
                    ["STR_A3PL_Inventory_UseAmountTitle" call A3PL_Localize, format ["STR_A3PL_Inventory_UseAmountPrompt" call A3PL_Localize, _displayName, _count], _count, {
                        params ["_amount", "_item"];
                        (findDisplay 6400) closeDisplay 0;
                        [_item, false, _amount] call A3PL_Inventory_Use;
                    }, true] call A3PL_InventoryNew_InputAmount;
                }]
            ]
        ]],
        ["drop_single", [
            {([_item, "canDrop"] call A3PL_Config_GetItem) && {_count isEqualTo 1} && {(vehicle player) isKindOf "Man"}},
            "STR_A3PL_Inventory_Drop",
            {params ["_item"]; (findDisplay 6400) closeDisplay 0; Player_ItemClass = _item; [_item] call A3PL_Inventory_Use; [true, 1] call A3PL_Inventory_Drop},
            []
        ]],
        ["drop_multiple", [
            {([_item, "canDrop"] call A3PL_Config_GetItem) && {_count > 1} && {(vehicle player) isKindOf "Man"}},
            "STR_A3PL_Inventory_Drop",
            {},
            [
                ["one", {true}, "STR_A3PL_Inventory_DropOne", {params ["_item"]; (findDisplay 6400) closeDisplay 0; Player_ItemClass = _item; [_item] call A3PL_Inventory_Use; [true, 1] call A3PL_Inventory_Drop}],
                ["all", {true}, "STR_A3PL_Inventory_DropAll", {params ["_item", "_count"]; (findDisplay 6400) closeDisplay 0; Player_ItemClass = _item; [_item, true, _count] call A3PL_Inventory_Use; [true, _count] call A3PL_Inventory_Drop}],
                ["amount", {true}, "STR_A3PL_Inventory_DropAmount", {
                    params ["_item", "_count"];
                    private _displayName = [_item, "displayName"] call A3PL_Config_GetItem;
                    ["STR_A3PL_Inventory_DropAmountTitle" call A3PL_Localize, format ["STR_A3PL_Inventory_DropAmountPrompt" call A3PL_Localize, _displayName, _count], _count, {
                        params ["_amount", "_item"];
                        Player_ItemClass = _item;
                        [_item, true, _amount] call A3PL_Inventory_Use;
                        [true, _amount] call A3PL_Inventory_Drop;
                    }, true] call A3PL_InventoryNew_InputAmount;
                }]
            ]
        ]],
        ["give", [
            {([_item, "canGive"] call A3PL_Config_GetItem) && {(count ((position player) nearEntities ["CAManBase", 3] select {isPlayer _x && _x != player && alive _x})) > 0}},
            "STR_A3PL_Inventory_Give",
            {},
            [
                ["one", {true}, "STR_A3PL_Inventory_GiveOne", {params ["_item"]; [_item, 1] call A3PL_Inventory_Give}],
                ["all", {_count > 1}, "STR_A3PL_Inventory_GiveAll", {params ["_item", "_count"]; [_item, _count] call A3PL_Inventory_Give}],
                ["amount", {_count > 1}, "STR_A3PL_Inventory_GiveAmount", {
                    params ["_item", "_count"];
                    private _displayName = [_item, "displayName"] call A3PL_Config_GetItem;
                    ["STR_A3PL_Inventory_GiveAmountTitle" call A3PL_Localize, format ["STR_A3PL_Inventory_GiveAmountPrompt" call A3PL_Localize, _displayName, _count], _count, {
                        params ["_amount", "_item"];
                        [_item, _amount] call A3PL_Inventory_Give;
                    }, false] call A3PL_InventoryNew_InputAmount;
                }]
            ]
        ]],
        ["hotbar", [
            {!(_item isEqualTo "cash")},
            "STR_A3PL_Inventory_AssignToHotbar",
            {},
            [
                ["slot1", {true}, "STR_A3PL_Inventory_Slot1", {params ["_item"]; [0, _item] call A3PL_Hotbar_SetSlot}],
                ["slot2", {true}, "STR_A3PL_Inventory_Slot2", {params ["_item"]; [1, _item] call A3PL_Hotbar_SetSlot}],
                ["slot3", {true}, "STR_A3PL_Inventory_Slot3", {params ["_item"]; [2, _item] call A3PL_Hotbar_SetSlot}],
                ["slot4", {true}, "STR_A3PL_Inventory_Slot4", {params ["_item"]; [3, _item] call A3PL_Hotbar_SetSlot}],
                ["slot5", {true}, "STR_A3PL_Inventory_Slot5", {params ["_item"]; [4, _item] call A3PL_Hotbar_SetSlot}],
                ["slot6", {(player getVariable ["Player_PerkDay", 0]) > 0}, "STR_A3PL_Inventory_Slot6Premium", {params ["_item"]; [5, _item] call A3PL_Hotbar_SetSlot}],
                ["slot7", {(player getVariable ["Player_PerkDay", 0]) > 0}, "STR_A3PL_Inventory_Slot7Premium", {params ["_item"]; [6, _item] call A3PL_Hotbar_SetSlot}],
                ["slot8", {(player getVariable ["Player_PerkDay", 0]) > 0}, "STR_A3PL_Inventory_Slot8Premium", {params ["_item"]; [7, _item] call A3PL_Hotbar_SetSlot}],
                ["slot9", {(player getVariable ["Player_PerkDay", 0]) > 0}, "STR_A3PL_Inventory_Slot9Premium", {params ["_item"]; [8, _item] call A3PL_Hotbar_SetSlot}],
                ["slot0", {(player getVariable ["Player_PerkDay", 0]) > 0}, "STR_A3PL_Inventory_Slot0Premium", {params ["_item"]; [9, _item] call A3PL_Hotbar_SetSlot}]
            ]
        ]]
    ];

    Inventory_VirtualItemActionsOrder = ["use_single", "use_multiple", "drop_single", "drop_multiple", "give", "hotbar"];

    // ========================================================================
    // ACTIONS SUR LES CLES (CfgKeyActions)
    // ========================================================================

    Inventory_KeyActions = createHashMapFromArray [
        ["use", [
            {true},
            "STR_A3PL_Inventory_TakeInHand",
            {params ["_item"]; (findDisplay 6400) closeDisplay 0; [_item] call A3PL_Housing_DropKey},
            []
        ]]
    ];

    Inventory_KeyActionsOrder = ["use"];

    // ========================================================================
    // ACTIONS SUR LES LICENCES (CfgLicenseActions)
    // ========================================================================

    Inventory_LicenseActions = createHashMapFromArray [];
    Inventory_LicenseActionsOrder = [];

    // ========================================================================
    // ACTIONS SUR LE CASH (CfgCashActions)
    // ========================================================================

    Inventory_CashActions = createHashMapFromArray [
        ["drop", [
            {(vehicle player) isKindOf "Man"},
            "STR_A3PL_Inventory_Drop",
            {},
            [
                ["one", {true}, "STR_A3PL_Inventory_DropOne$", {(findDisplay 6400) closeDisplay 0; [1] call A3PL_Inventory_DropCash}],
                ["all", {true}, "STR_A3PL_Inventory_DropAll", {params ["_item", "_count"]; (findDisplay 6400) closeDisplay 0; [_count] call A3PL_Inventory_DropCash}],
                ["amount", {true}, "STR_A3PL_Inventory_DropAmount", {
                    params ["_item", "_count"];
                    ["STR_A3PL_Inventory_DropCashTitle" call A3PL_Localize, format ["STR_A3PL_Inventory_DropCashPrompt" call A3PL_Localize, _count], _count, {
                        params ["_amount"];
                        [_amount] call A3PL_Inventory_DropCash;
                    }, true] call A3PL_InventoryNew_InputAmount;
                }]
            ]
        ]],
        ["give", [
            {!(isNull (player getVariable ["yourTarget", objNull]))},
            "STR_A3PL_Inventory_Give",
            {},
            [
                ["one", {true}, "STR_A3PL_Inventory_GiveOne$", {["cash", 1] call A3PL_Inventory_Give}],
                ["all", {true}, "STR_A3PL_Inventory_GiveAll", {params ["_item", "_count"]; ["cash", _count] call A3PL_Inventory_Give}],
                ["amount", {true}, "STR_A3PL_Inventory_GiveAmount", {
                    params ["_item", "_count"];
                    ["STR_A3PL_Inventory_GiveCashTitle" call A3PL_Localize, format ["STR_A3PL_Inventory_GiveCashPrompt" call A3PL_Localize, _count], _count, {
                        params ["_amount"];
                        ["cash", _amount] call A3PL_Inventory_Give;
                    }, false] call A3PL_InventoryNew_InputAmount;
                }]
            ]
        ]]
    ];

    Inventory_CashActionsOrder = ["drop", "give"];

    // ========================================================================
    // ACTIONS SUR L'EQUIPEMENT (CfgEquipmentActions)
    // ========================================================================

    Inventory_EquipmentActions = createHashMapFromArray [
        ["drop", [
            {(vehicle player) isKindOf "Man"},
            "STR_A3PL_Inventory_Drop",
            {params ["_item"]; [_item] call A3PL_InventoryNew_DropEquipment},
            []
        ]],
        ["transfert", [
            {player canAdd _item},
            "STR_A3PL_Inventory_Unequip",
            {params ["_item"]; [_item] call A3PL_InventoryNew_UnequipToInventory},
            []
        ]],
        ["hotbar", [
            {[_item] call A3PL_Hotbar_CanAssign},
            "STR_A3PL_Inventory_AssignToHotbar",
            {},
            [
                ["slot1", {true}, "STR_A3PL_Inventory_Slot1", {params ["_item"]; [0, _item] call A3PL_Hotbar_SetSlot}],
                ["slot2", {true}, "STR_A3PL_Inventory_Slot2", {params ["_item"]; [1, _item] call A3PL_Hotbar_SetSlot}],
                ["slot3", {true}, "STR_A3PL_Inventory_Slot3", {params ["_item"]; [2, _item] call A3PL_Hotbar_SetSlot}],
                ["slot4", {true}, "STR_A3PL_Inventory_Slot4", {params ["_item"]; [3, _item] call A3PL_Hotbar_SetSlot}],
                ["slot5", {true}, "STR_A3PL_Inventory_Slot5", {params ["_item"]; [4, _item] call A3PL_Hotbar_SetSlot}],
                ["slot6", {(player getVariable ["Player_PerkDay", 0]) > 0}, "STR_A3PL_Inventory_Slot6Premium", {params ["_item"]; [5, _item] call A3PL_Hotbar_SetSlot}],
                ["slot7", {(player getVariable ["Player_PerkDay", 0]) > 0}, "STR_A3PL_Inventory_Slot7Premium", {params ["_item"]; [6, _item] call A3PL_Hotbar_SetSlot}],
                ["slot8", {(player getVariable ["Player_PerkDay", 0]) > 0}, "STR_A3PL_Inventory_Slot8Premium", {params ["_item"]; [7, _item] call A3PL_Hotbar_SetSlot}],
                ["slot9", {(player getVariable ["Player_PerkDay", 0]) > 0}, "STR_A3PL_Inventory_Slot9Premium", {params ["_item"]; [8, _item] call A3PL_Hotbar_SetSlot}],
                ["slot0", {(player getVariable ["Player_PerkDay", 0]) > 0}, "STR_A3PL_Inventory_Slot0Premium", {params ["_item"]; [9, _item] call A3PL_Hotbar_SetSlot}]
            ]
        ]]
    ];

    Inventory_EquipmentActionsOrder = ["drop", "transfert", "hotbar"];

}] call compile_Global;
