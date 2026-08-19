/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/

Config_Repair = createHashMapFromArray [
	["HitFuel", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_Fuel"],
		["tool", "repairwrench"],
		["item", "fueltank"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitFuel.paa"],
		["time", 8]
	]],
	["HitFuelTank", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_Fuel"],
		["tool", "repairwrench"],
		["item", "fueltank"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitFuel.paa"],
		["time", 8]
	]],
	["HitEngine", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_Engine"],
		["tool", "repairwrench"],
		["item", "engine"],
		["select", "engine"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitEngine.paa"],
		["time", 17],
		["workshopOnly", true]
	]],
	["HitEngine1", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_Engine"],
		["tool", "repairwrench"],
		["item", "engine"],
		["select", "engine"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitEngine.paa"],
		["time", 17],
		["workshopOnly", true]
	]],
	["HitEngine2", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_Engine"],
		["tool", "repairwrench"],
		["item", "engine"],
		["select", "engine"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitEngine.paa"],
		["time", 17],
		["workshopOnly", true]
	]],
	["HitEngine3", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_Engine"],
		["tool", "repairwrench"],
		["item", "engine"],
		["select", "engine"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitEngine.paa"],
		["time", 17],
		["workshopOnly", true]
	]],
	["HitBody", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_Body"],
		["tool", "repairwrench"],
		["item", "chassis"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitBody.paa"],
		["time", 15],
		["workshopOnly", true]
	]],
	["HitLFWheel", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_WheelL01"],
		["tool", "repairwrench"],
		["item", "tyres"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitLFWheel.paa"],
		["time", 8],
		["select", "wheel_1_1_damper"]
	]],
	["HitLF2Wheel", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_WheelL02"],
		["tool", "repairwrench"],
		["item", "tyres"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitLFWheel.paa"],
		["time", 8],
		["select", "wheel_1_2_damper"]
	]],
	["HitLMWheel", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_WheelL03"],
		["tool", "repairwrench"],
		["item", "tyres"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitLFWheel.paa"],
		["time", 8],
		["select", "wheel_1_3_damper"]
	]],
	["HitLBWheel", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_WheelL04"],
		["tool", "repairwrench"],
		["item", "tyres"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitLFWheel.paa"],
		["time", 8],
		["select", "wheel_1_4_damper"]
	]],
	["HitRFWheel", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_WheelR01"],
		["tool", "repairwrench"],
		["item", "tyres"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitLFWheel.paa"],
		["time", 8],
		["select", "wheel_2_1_damper"]
	]],
	["HitRF2Wheel", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_WheelR02"],
		["tool", "repairwrench"],
		["item", "tyres"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitLFWheel.paa"],
		["time", 8],
		["select", "wheel_2_2_damper"]
	]],
	["HitRMWheel", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_WheelR03"],
		["tool", "repairwrench"],
		["item", "tyres"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitLFWheel.paa"],
		["time", 8],
		["select", "wheel_2_3_damper"]
	]],
	["HitRBWheel", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_WheelR04"],
		["tool", "repairwrench"],
		["item", "tyres"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitLFWheel.paa"],
		["time", 8],
		["select", "wheel_2_4_damper"]
	]],
	["HitFWheel", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_WheelF"],
		["tool", "repairwrench"],
		["item", "tyres"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitLFWheel.paa"],
		["time", 8]
	]],
	["HitBWheel", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_WheelB"],
		["tool", "repairwrench"],
		["item", "tyres"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitLFWheel.paa"],
		["time", 8]
	]],
	["HitGlass1", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_Glass"],
		["tool", "repairwrench"],
		["item", "windows"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitGlass1.paa"],
		["time", 7]
	]],
	["HitGlass2", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_Glass"],
		["tool", "repairwrench"],
		["item", "windows"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitGlass1.paa"],
		["time", 7]
	]],
	["HitGlass3", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_Glass"],
		["tool", "repairwrench"],
		["item", "windows"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitGlass1.paa"],
		["time", 7]
	]],
	["HitGlass4", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_Glass"],
		["tool", "repairwrench"],
		["item", "windows"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitGlass1.paa"],
		["time", 7]
	]],
	["HitGlass5", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_Glass"],
		["tool", "repairwrench"],
		["item", "windows"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitGlass1.paa"],
		["time", 7]
	]],
	["HitGlass6", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_Glass"],
		["tool", "repairwrench"],
		["item", "windows"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitGlass1.paa"],
		["time", 7]
	]],
	["HitGlass7", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_Glass"],
		["tool", "repairwrench"],
		["item", "windows"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitGlass1.paa"],
		["time", 7]
	]],
	["HitGlass8", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_Glass"],
		["tool", "repairwrench"],
		["item", "windows"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitGlass1.paa"],
		["time", 7]
	]],
	["HitGlass9", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_Glass"],
		["tool", "repairwrench"],
		["item", "windows"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitGlass1.paa"],
		["time", 7]
	]],
	["HitGlass10", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_Glass"],
		["tool", "repairwrench"],
		["item", "windows"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitGlass1.paa"],
		["time", 7]
	]],
	["HitRGlass", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_Glass"],
		["tool", "repairwrench"],
		["item", "windows"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitGlass1.paa"],
		["time", 7]
	]],
	["HitLGlass", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_Glass"],
		["tool", "repairwrench"],
		["item", "windows"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitGlass1.paa"],
		["time", 7]
	]],
	["HitHull", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_Hull"],
		["tool", "repairwrench"],
		["item", "chassis"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitHull.paa"],
		["time", 14],
		["workshopOnly", true]
	]],
	["HitAvionics", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_Avionics"],
		["tool", "repairwrench"],
		["item", "trans"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitAvionics.paa"],
		["time", 13],
		["workshopOnly", true]
	]],
	["HitHRotor", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_MainRotor"],
		["tool", "repairwrench"],
		["item", "brakerotors"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitRotor.paa"],
		["time", 21]
	]],
	["HitVRotor", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_SubRotor"],
		["tool", "repairwrench"],
		["item", "brakerotors"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitRotor.paa"],
		["time", 21]
	]],
	["HitWinch", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_Winch"],
		["tool", "repairwrench"],
		["item", "chassis"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitWinch.paa"],
		["time", 11]
	]],
	["HitTransmission", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_Transmission"],
		["tool", "repairwrench"],
		["item", "trans"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitTransmission.paa"],
		["time", 9],
		["workshopOnly", true]
	]],
	["HitLight", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_Light"],
		["tool", "repairwrench"],
		["item", "windows"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitLight.paa"],
		["time", 7]
	]],
	["HitHydraulics", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_Hydraulics"],
		["tool", "repairwrench"],
		["item", "trans"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitHydraulics.paa"],
		["time", 11],
		["workshopOnly", true]
	]],
	["HitGear", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_Gear"],
		["tool", "repairwrench"],
		["item", "chassis"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitGear.paa"],
		["time", 11],
		["workshopOnly", true]
	]],
	["HitHStabilizerL1", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_StabilizerL"],
		["tool", "repairwrench"],
		["item", "brakerotors"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitHStabilizerL1.paa"],
		["time", 13]
	]],
	["HitHStabilizerR1", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_StabilizerR"],
		["tool", "repairwrench"],
		["item", "brakerotors"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitHStabilizerL1.paa"],
		["time", 13]
	]],
	["HitVStabilizer1", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_Stabilizer"],
		["tool", "repairwrench"],
		["item", "brakerotors"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitHStabilizerL1.paa"],
		["time", 13]
	]],
	["HitTail", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_Tail"],
		["tool", "repairwrench"],
		["item", "chassis"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitTail.paa"],
		["time", 11],
		["workshopOnly", true]
	]],
	["HitPitotTube", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_PitotTube"],
		["tool", "repairwrench"],
		["item", "driveshaft"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitPitotTube.paa"],
		["time", 10]
	]],
	["HitStaticPort", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_StaticPort"],
		["tool", "repairwrench"],
		["item", "driveshaft"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitStaticPort.paa"],
		["time", 11]
	]],
	["HitStarter1", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_Starter"],
		["tool", "repairwrench"],
		["item", "engine"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitStarter1.paa"],
		["time", 9]
	]],
	["HitStarter2", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_Starter"],
		["tool", "repairwrench"],
		["item", "engine"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitStarter1.paa"],
		["time", 9]
	]],
	["HitStarter3", createHashMapFromArray [
		["name", "STR_A3PL_Repair_HitPoint_Starter"],
		["tool", "repairwrench"],
		["item", "engine"],
		["picture", "\PO_UI\Data\VehicleHitPoints\HitStarter1.paa"],
		["time", 9]
	]]
];

publicVariable "Config_Repair";
