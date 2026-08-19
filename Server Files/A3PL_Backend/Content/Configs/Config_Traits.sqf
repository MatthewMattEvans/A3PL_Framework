/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/

// Configuration des traits
// Format: [name, description, picture, cost]
// Économie: 1 point = 1h de jeu (max joueur: ~233h)
// Tier 1 (5-8): Base | Tier 2 (10-15): Intermédiaire | Tier 3 (18-25): Avancé | Tier 4 (30-40): Puissant | Tier 5 (50+): Élite
Config_Traits = createHashMapFromArray
[
	// ==================== TRAITS DE COMBAT ====================
	["boxer", [
		"STR_A3PL_Trait_Boxer",
		"STR_A3PL_Trait_Boxer_Desc",
		"\A3PL_Common\Traits\boxer_co.paa",
		8
	]],
	["gunner", [
		"STR_A3PL_Trait_Gunner",
		"STR_A3PL_Trait_Gunner_Desc",
		"\A3PL_Common\Traits\gunner_co.paa",
		12
	]],
	["pain_trained", [
		"STR_A3PL_Trait_PainTrained",
		"STR_A3PL_Trait_PainTrained_Desc",
		"\A3PL_Common\Traits\pain_trained_co.paa",
		25
	]],
	["tactical_reload", [
		"STR_A3PL_Trait_TacticalReload",
		"STR_A3PL_Trait_TacticalReload_Desc",
		"\A3PL_Common\Traits\TODO.paa",
		18
	]],
	["steady_hands", [
		"STR_A3PL_Trait_SteadyHands",
		"STR_A3PL_Trait_SteadyHands_Desc",
		"\A3PL_Common\Traits\TODO.paa",
		20
	]],
	["adrenaline_junkie", [
		"STR_A3PL_Trait_AdrenalineJunkie",
		"STR_A3PL_Trait_AdrenalineJunkie_Desc",
		"\A3PL_Common\Traits\TODO.paa",
		35
	]],

	// ==================== TRAITS MÉDICAUX ====================
	["nurse", [
		"STR_A3PL_Trait_Nurse",
		"STR_A3PL_Trait_Nurse_Desc",
		"\A3PL_Common\Traits\nurse_co.paa",
		8
	]],
	["doctor", [
		"STR_A3PL_Trait_Doctor",
		"STR_A3PL_Trait_Doctor_Desc",
		"\A3PL_Common\Traits\doctor_co.paa",
		20
	]],
	["surgeon", [
		"STR_A3PL_Trait_Surgeon",
		"STR_A3PL_Trait_Surgeon_Desc",
		"\A3PL_Common\Traits\surgeon_co.paa",
		40
	]],

	// ==================== TRAITS MÉCANIQUES ====================
	["grease_monkey", [
		"STR_A3PL_Trait_GreaseMonkey",
		"STR_A3PL_Trait_GreaseMonkey_Desc",
		"\A3PL_Common\Traits\mechanic_co.paa",
		8
	]],
	["tinkerer", [
		"STR_A3PL_Trait_Tinkerer",
		"STR_A3PL_Trait_Tinkerer_Desc",
		"\A3PL_Common\Traits\tinkerer_co.paa",
		18
	]],
	["mechanic", [
		"STR_A3PL_Trait_Mechanic",
		"STR_A3PL_Trait_Mechanic_Desc",
		"\A3PL_Common\Traits\mechanic_co.paa",
		35
	]],
	["macgyver", [
		"STR_A3PL_Trait_MacGyver",
		"STR_A3PL_Trait_MacGyver_Desc",
		"\A3PL_Common\Traits\TODO.paa",
		50
	]],

	// ==================== TRAITS DE PRODUCTIVITÉ ====================
	["fisher", [
		"STR_A3PL_Trait_Fisher",
		"STR_A3PL_Trait_Fisher_Desc",
		"\A3PL_Common\Traits\hunter_co.paa",
		6
	]],
	["miner", [
		"STR_A3PL_Trait_Miner",
		"STR_A3PL_Trait_Miner_Desc",
		"\A3PL_Common\Traits\miner_co.paa",
		6
	]],
	["green_hand", [
		"STR_A3PL_Trait_GreenHand",
		"STR_A3PL_Trait_GreenHand_Desc",
		"\A3PL_Common\Traits\greenhand_co.paa",
		6
	]],
	["hunter", [
		"STR_A3PL_Trait_Hunter",
		"STR_A3PL_Trait_Hunter_Desc",
		"\A3PL_Common\Traits\hunter_co.paa",
		6
	]],
	["employee", [
		"STR_A3PL_Trait_Employee",
		"STR_A3PL_Trait_Employee_Desc",
		"\A3PL_Common\Traits\TODO.paa",
		5
	]],
	["petrol", [
		"STR_A3PL_Trait_Petrol",
		"STR_A3PL_Trait_Petrol_Desc",
		"\A3PL_Common\Traits\TODO.paa",
		6
	]],
	["lucky", [
		"STR_A3PL_Trait_Lucky",
		"STR_A3PL_Trait_Lucky_Desc",
		"\A3PL_Common\Traits\lucky_co.paa",
		15
	]],
	["negotiator", [
		"STR_A3PL_Trait_Negotiator",
		"STR_A3PL_Trait_Negotiator_Desc",
		"\A3PL_Common\Traits\TODO.paa",
		22
	]],
	["black_market", [
		"STR_A3PL_Trait_BlackMarket",
		"STR_A3PL_Trait_BlackMarket_Desc",
		"\A3PL_Common\Traits\TODO.paa",
		30
	]],

	// ==================== TRAITS DE FURTIVITÉ ====================
	["lockpick_handcuffs", [
		"STR_A3PL_Trait_LockpickHandcuffs",
		"STR_A3PL_Trait_LockpickHandcuffs_Desc",
		"\A3PL_Common\Traits\lockpick_handcuffs_co.paa",
		10
	]],
	["customs_officer", [
		"STR_A3PL_Trait_CustomsOfficer",
		"STR_A3PL_Trait_CustomsOfficer_Desc",
		"\A3PL_Common\Traits\lockpick_handcuffs_co.paa",
		12
	]],
	["lockpick_doors", [
		"STR_A3PL_Trait_LockpickDoors",
		"STR_A3PL_Trait_LockpickDoors_Desc",
		"\A3PL_Common\Traits\lockpick_door_co.paa",
		18
	]],
	["lockpick_vehicles", [
		"STR_A3PL_Trait_LockpickVehicles",
		"STR_A3PL_Trait_LockpickVehicles_Desc",
		"\A3PL_Common\Traits\lockpick_vehicle_co.paa",
		25
	]],
	["lockpick_cells", [
		"STR_A3PL_Trait_LockpickCells",
		"STR_A3PL_Trait_LockpickCells_Desc",
		"\A3PL_Common\Traits\TODO.paa",
		22
	]],
	["lockpick_ankle", [
		"STR_A3PL_Trait_LockpickAnkle",
		"STR_A3PL_Trait_LockpickAnkle_Desc",
		"\A3PL_Common\Traits\TODO.paa",
		15
	]],
	["keypad_bypass", [
		"STR_A3PL_Trait_KeypadBypass",
		"STR_A3PL_Trait_KeypadBypass_Desc",
		"\A3PL_Common\Traits\TODO.paa",
		28
	]],
	["pickpocket", [
		"STR_A3PL_Trait_Pickpocket",
		"STR_A3PL_Trait_Pickpocket_Desc",
		"\A3PL_Common\Traits\TODO.paa",
		15
	]],
	["hitman", [
		"STR_A3PL_Trait_Hitman",
		"STR_A3PL_Trait_Hitman_Desc",
		"\A3PL_Common\Traits\TODO.paa",
		55
	]],
	["quick_fingers", [
		"STR_A3PL_Trait_QuickFingers",
		"STR_A3PL_Trait_QuickFingers_Desc",
		"\A3PL_Common\Traits\TODO.paa",
		40
	]],

	// ==================== TRAITS DE CORPS ====================
	["resistance", [
		"STR_A3PL_Trait_Resistance",
		"STR_A3PL_Trait_Resistance_Desc",
		"\A3PL_Common\Traits\resistance_co.paa",
		12
	]],
	["back_steel", [
		"STR_A3PL_Trait_BackSteel",
		"STR_A3PL_Trait_BackSteel_Desc",
		"\A3PL_Common\Traits\TODO.paa",
		20
	]],
	["crash_survivor", [
		"STR_A3PL_Trait_CrashSurvivor",
		"STR_A3PL_Trait_CrashSurvivor_Desc",
		"\A3PL_Common\Traits\survivor_co.paa",
		25
	]],
	["efficient_metabolism", [
		"STR_A3PL_Trait_EfficientMetabolism",
		"STR_A3PL_Trait_EfficientMetabolism_Desc",
		"\A3PL_Common\Traits\metabolism_co.paa",
		30
	]],

	// ==================== OUTLAW ====================
	["shrooms", [
		"STR_A3PL_Trait_Shrooms",
		"STR_A3PL_Trait_Shrooms_Desc",
		"\A3PL_Common\Traits\TODO.paa",
		8
	]],
	["weed", [
		"STR_A3PL_Trait_Weed",
		"STR_A3PL_Trait_Weed_Desc",
		"\A3PL_Common\Traits\TODO.paa",
		10
	]],
	["cocaine", [
		"STR_A3PL_Trait_Cocaine",
		"STR_A3PL_Trait_Cocaine_Desc",
		"\A3PL_Common\Traits\TODO.paa",
		25
	]],
	["moonshine", [
		"STR_A3PL_Trait_Moonshine",
		"STR_A3PL_Trait_Moonshine_Desc",
		"\A3PL_Common\Traits\TODO.paa",
		15
	]],
	["drug_mule", [
		"STR_A3PL_Trait_DrugMule",
		"STR_A3PL_Trait_DrugMule_Desc",
		"\A3PL_Common\Traits\TODO.paa",
		35
	]],
	["high_tolerance", [
		"STR_A3PL_Trait_HighTolerance",
		"STR_A3PL_Trait_HighTolerance_Desc",
		"\A3PL_Common\Traits\TODO.paa",
		20
	]],

	// ==================== TRAITS NÉGATIFS (remboursent des points) ====================
	["old", [
		"STR_A3PL_Trait_Old",
		"STR_A3PL_Trait_Old_Desc",
		"\A3PL_Common\Traits\pain_trained_co.paa",
		15
	]],
	["wimp", [
		"STR_A3PL_Trait_Wimp",
		"STR_A3PL_Trait_Wimp_Desc",
		"\A3PL_Common\Traits\pain_trained_co.paa",
		10
	]]
];
publicVariable "Config_Traits";

// Configuration des catégories de traits
// Format: [name, [[trait1, trait2], [trait3], ...]]
Config_TraitsCategories = createHashMapFromArray
[
	["carefulness", [
		"STR_A3PL_TraitCategory_Carefulness",
		[
			["nurse", "grease_monkey"],
			["doctor", "tinkerer"],
			["surgeon", "mechanic"],
			["macgyver"]
		]
	]],
	["combativeness", [
		"STR_A3PL_TraitCategory_Combativeness",
		[
			["boxer"],
			["gunner"],
			["tactical_reload", "steady_hands"],
			["pain_trained"],
			["adrenaline_junkie"]
		]
	]],
	["productivity", [
		"STR_A3PL_TraitCategory_Productivity",
		[
			["fisher", "miner","petrol","green_hand","hunter","employee"],
			["lucky"],
			["negotiator", "black_market"]
		]
	]],
	["stealth", [
		"STR_A3PL_TraitCategory_Stealth",
		[
			["lockpick_handcuffs", "customs_officer"],
			["pickpocket","keypad_bypass"],
			["lockpick_ankle"],
			["lockpick_doors"],
			["lockpick_cells"],
			["lockpick_vehicles"],
			["quick_fingers"],
			["hitman"]
		]
	]],
	["body", [
		"STR_A3PL_TraitCategory_Body",
		[
			["resistance"],
			["back_steel"],
			["crash_survivor"],
			["efficient_metabolism"]
		]
	]],
	["outlaw", [
		"STR_A3PL_TraitCategory_Outlaw",
		[
			["shrooms"],
			["weed"],
			["moonshine"],
			["cocaine"],
			["drug_mule", "high_tolerance"]
		]
	]]
];
publicVariable "Config_TraitsCategories";
