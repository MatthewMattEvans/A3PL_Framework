/*
	defines_inventorynew.hpp
	Defines et constantes pour le nouveau systeme d'inventaire A3PL
	(Pas de classes UI - seulement des #define)
*/

#ifndef A3PL_INVENTORYNEW_DEFINES_HPP
#define A3PL_INVENTORYNEW_DEFINES_HPP

// ============================================================================
// INVENTORY IDCs - Display IDs and Control IDs
// ============================================================================

// Weapon slots (Arma 3)
#define WeaponNoSlot                              0
#define WeaponSlotPrimary                         1
#define WeaponSlotSecondary                       4
#define WeaponSlotHandGun                         2
#define WeaponSlotHandGunItem                     16
#define WeaponSlotItem                            256
#define WeaponSlotBinocular                       4096
#define WeaponHardMounted                         65536
#define WeaponSlotInventory                       131072

// Equipment slots
#define DEFAULT_SLOT                              0
#define MUZZLE_SLOT                               101
#define OPTICS_SLOT                               201
#define FLASHLIGHT_SLOT                           301
#define BIPOD_SLOT                                302
#define FIRSTAIDKIT_SLOT                          401
#define FINS_SLOT                                 501
#define BREATHINGBOMB_SLOT                        601
#define NVG_SLOT                                  602
#define GOGGLE_SLOT                               603
#define SCUBA_SLOT                                604
#define HEADGEAR_SLOT                             605
#define FACTOR_SLOT                               607
#define RADIO_SLOT                                611
#define HMD_SLOT                                  616
#define BINOCULAR_SLOT                            617
#define MEDIKIT_SLOT                              619
#define TOOLKIT_SLOT                              620
#define VEST_SLOT                                 701
#define UNIFORM_SLOT                              801
#define BACKPACK_SLOT                             901

// Cargo limits
#define LOAD_MAX_GLOVEBOX                         40
#define LOAD_MAX_MAILBOX                          120
#define LOAD_MAX_FURNACE_TOP                      200
#define LOAD_MAX_FURNACE_BOT                      200
#define LOAD_MAX_TRASHCAN                         200
#define LOAD_MAX_TRADE_TRADE                      500

// Main Inventory Dialog
#define INVENTORY_DISPLAY_NAME                    "A3PL_RscDisplayInventoryNew"
#define INVENTORY_DISPLAY_IDD                     6400

#define INVENTORY_SEARCH_TITLE_IDC                6401
#define INVENTORY_SEARCH_EDIT_IDC                 6402
#define INVENTORY_FILTERS_TITLE_IDC               6403
#define INVENTORY_FILTER_1_IMAGE_IDC              6404
#define INVENTORY_FILTER_1_BUTTON_IDC             6405
#define INVENTORY_FILTER_2_IMAGE_IDC              6406
#define INVENTORY_FILTER_2_BUTTON_IDC             6407
#define INVENTORY_FILTER_3_IMAGE_IDC              6408
#define INVENTORY_FILTER_3_BUTTON_IDC             6409
#define INVENTORY_FILTER_4_IMAGE_IDC              6410
#define INVENTORY_FILTER_4_BUTTON_IDC             6411
#define INVENTORY_FILTER_5_IMAGE_IDC              6474
#define INVENTORY_FILTER_5_BUTTON_IDC             6475
#define INVENTORY_FILTER_6_IMAGE_IDC              6476
#define INVENTORY_FILTER_6_BUTTON_IDC             6477
#define INVENTORY_FILTER_7_IMAGE_IDC              6478
#define INVENTORY_FILTER_7_BUTTON_IDC             6479
#define INVENTORY_TITLE_IDC                       6412
#define INVENTORY_LIST_IDC                        6413
#define INVENTORY_PROGRESS_BAR_IDC                6414
#define INVENTORY_PROGRESS_TITLE_IDC              6415
#define EQUIPMENT_TITLE_IDC                       6416

// Equipment slots IDCs
#define EQUIPMENT_SECONDARYWEAPON_BUTTON_IDC      6417
#define EQUIPMENT_PRIMARYWEAPON_BUTTON_IDC        6418
#define EQUIPMENT_HANDGUNWEAPON_BUTTON_IDC        6419
#define EQUIPMENT_BINOCULARS_BUTTON_IDC           6420
#define EQUIPMENT_COMPASS_BUTTON_IDC              6421
#define EQUIPMENT_HEADGEAR_BUTTON_IDC             6422
#define EQUIPMENT_WATCH_BUTTON_IDC                6423
#define EQUIPMENT_GOGGLES_BUTTON_IDC              6424
#define EQUIPMENT_VEST_BUTTON_IDC                 6425
#define EQUIPMENT_UNIFORM_BUTTON_IDC              6426
#define EQUIPMENT_BACKPACK_BUTTON_IDC             6427
#define EQUIPMENT_PRIMARYWEAPON_FLASHLIGHT_BUTTON_IDC   6428
#define EQUIPMENT_PRIMARYWEAPON_MAGAZINE_BUTTON_IDC     6429
#define EQUIPMENT_PRIMARYWEAPON_MUZZLE_BUTTON_IDC       6430
#define EQUIPMENT_PRIMARYWEAPON_OPTIC_BUTTON_IDC        6431
#define EQUIPMENT_SECONDARYWEAPON_FLASHLIGHT_BUTTON_IDC 6432
#define EQUIPMENT_SECONDARYWEAPON_MAGAZINE_BUTTON_IDC   6433
#define EQUIPMENT_SECONDARYWEAPON_MUZZLE_BUTTON_IDC     6434
#define EQUIPMENT_SECONDARYWEAPON_OPTIC_BUTTON_IDC      6435
#define EQUIPMENT_HANDGUNWEAPON_FLASHLIGHT_BUTTON_IDC   6436
#define EQUIPMENT_HANDGUNWEAPON_MAGAZINE_BUTTON_IDC     6437
#define EQUIPMENT_HANDGUNWEAPON_MUZZLE_BUTTON_IDC       6438
#define EQUIPMENT_HANDGUNWEAPON_OPTIC_BUTTON_IDC        6439
#define EQUIPMENT_MAP_BUTTON_IDC                        6440

// Equipment pictures IDCs
#define EQUIPMENT_HANDGUNWEAPON_PICTURE_IDC             6441
#define EQUIPMENT_BINOCULARS_PICTURE_IDC                6442
#define EQUIPMENT_COMPASS_PICTURE_IDC                   6443
#define EQUIPMENT_MAP_PICTURE_IDC                       6444
#define EQUIPMENT_WATCH_PICTURE_IDC                     6445
#define EQUIPMENT_PRIMARYWEAPON_PICTURE_IDC             6446
#define EQUIPMENT_SECONDARYWEAPON_PICTURE_IDC           6447
#define EQUIPMENT_PRIMARYWEAPON_FLASHLIGHT_PICTURE_IDC  6448
#define EQUIPMENT_SECONDARYWEAPON_FLASHLIGHT_PICTURE_IDC 6449
#define EQUIPMENT_HANDGUNWEAPON_FLASHLIGHT_PICTURE_IDC  6450
#define EQUIPMENT_HANDGUNWEAPON_MAGAZINE_PICTURE_IDC    6451
#define EQUIPMENT_SECONDARYWEAPON_MAGAZINE_PICTURE_IDC  6452
#define EQUIPMENT_PRIMARYWEAPON_MAGAZINE_PICTURE_IDC    6453
#define EQUIPMENT_SECONDARYWEAPON_MUZZLE_PICTURE_IDC    6454
#define EQUIPMENT_PRIMARYWEAPON_MUZZLE_PICTURE_IDC      6455
#define EQUIPMENT_HANDGUNWEAPON_MUZZLE_PICTURE_IDC      6456
#define EQUIPMENT_HANDGUNWEAPON_OPTIC_PICTURE_IDC       6457
#define EQUIPMENT_SECONDARYWEAPON_OPTIC_PICTURE_IDC     6458
#define EQUIPMENT_PRIMARYWEAPON_OPTIC_PICTURE_IDC       6459
#define EQUIPMENT_UNIFORM_PICTURE_IDC                   6460
#define EQUIPMENT_BACKPACK_PICTURE_IDC                  6461
#define EQUIPMENT_VEST_PICTURE_IDC                      6462
#define EQUIPMENT_HEADGEAR_PICTURE_IDC                  6463
#define EQUIPMENT_GOGGLES_PICTURE_IDC                   6464

// Character body parts IDCs
#define CHARACTER_ARMS_IDC                              6465
#define CHARACTER_BODY_IDC                              6466
#define CHARACTER_HANDS_IDC                             6467
#define CHARACTER_HEAD_IDC                              6468
#define CHARACTER_LEGS_IDC                              6469
#define CHARACTER_HUNGER_BACKGROUND_IDC                 6470
#define CHARACTER_HEALTH_BACKGROUND_IDC                 6471
#define CHARACTER_THIRST_BACKGROUND_IDC                 6472
#define CHARACTER_STATUSES_IDC                          6473

// Player info IDCs (playtime, premium)
#define INVENTORY_PLAYTIME_IDC                          6485
#define INVENTORY_PREMIUM_IDC                           6486

// Grid Inventory System IDCs
#define INVENTORY_GRID_GROUP_IDC                        6480
#define INVENTORY_GRID_SCROLL_IDC                       6481
#define INVENTORY_GRID_DRAG_PICTURE_IDC                 6482
#define INVENTORY_GRID_TOOLTIP_IDC                      6483
#define INVENTORY_GRID_ROTATE_BUTTON_IDC                6484
// IDCs dynamiques pour les cases de grille: 6500-6999
#define INVENTORY_GRID_CELL_BASE_IDC                    6600
// IDCs dynamiques pour les items: 7000-7499
#define INVENTORY_GRID_ITEM_BASE_IDC                    7000

// Transfer Dialog
#define TRANSFER_DISPLAY_NAME                     "A3PL_RscDisplayTransferNew"
#define TRANSFER_DISPLAY_IDD                      6500

#define TRANSFER_TARGET_PROGRESSBAR_IDC           6517
#define TRANSFER_TARGET_PROGRESS_INFO_IDC         6519
#define TRANSFER_TARGET_INVENTORY_LIST_IDC        6503
#define TRANSFER_TARGET_HEADER_IDC                6514
#define TRANSFER_PLAYER_HEADER_IDC                6515
#define TRANSFER_PLAYER_PROGRESSBAR_IDC           6518
#define TRANSFER_PLAYER_PROGRESS_INFO_IDC         6520
#define TRANSFER_PLAYER_INVENTORY_LIST_IDC        6505
#define TRANSFER_TOOLTIP_IDC                      6507

#endif // A3PL_INVENTORYNEW_DEFINES_HPP
