/*
    POLARION
    Code written by non-profit organization "POLARION" (SIREN 930088620)
    @Copyright POLARION (https://www.polarion.fr)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : hello@polarion.fr
*/
//class, display name, isCompany, canIssue (job), canRevoke (job), price, condition
// Config_Licenses = createHashMapFromArray
// [
// 	["gang",["AG",false,["fbi"],[],0,{true}]],

// 	["driver",["Permis de conduire",false,["entreprise"],["fisd","doj"],0,{true}]],
// 	["cdl",["Permis de conduire commercial",false,["entreprise"],["fisd","doj"],0,{true}]],
// 	["motorcycle",["Permis moto",false,["entreprise"],["fisd","doj"],0,{true}]],

// 	["cpr",["Certification RCP",false,["fifr"],["fifr"],0,{true}]],
// 	["med",["Premiers secours",false,["fifr"],["fifr"],0,{true}]],
// 	["vfd",["Volunteer Firefighter",false,["fifr"],["fifr"],0,{["fifr","rank", (player getVariable ["character_id",""])] call A3PL_Config_GetFactionRankData IN ["Battalion Chief","Assistant Chief","Chief"]}]],
// 	["tmd",["Transport de matières dangereuses",false,["fifr"],["fifr"],0,{"fifrmarshal" IN (player getVariable ["licenses",[]])}]],
// 	["tmdc",["Transport de matières dangereuses Entreprise",true,["fifr"],["fifr"],0,{"fifrmarshal" IN (player getVariable ["licenses",[]])}]],
// 	["mdph",["Certificat d'autisme",false,["fifr"],["fifr"],0,{true}]],

// 	["atc",["Volunteer ATC",false,["doj"],["doj"],0,{true}]],
// 	["boat",["Permis bateau standard",false,["doj"],["doj"],0,{true}]],
// 	["cboat",["Permis bateau commercial",true,["doj"],["doj"],0,{true}]],
// 	["gboat",["Permis bateau gouvernemental",false,["doj"],["doj"],0,{true}]],
// 	["rppl",["Licence de pilote rotatif privé",false,["doj"],["doj"],0,{true}]],
// 	["rcpl",["Licence de pilote rotatif commercial",true,["doj"],["doj"],0,{true}]],
// 	["fwppl",["Licence de pilote privé à voilure fixe",false,["doj"],["doj"],0,{true}]],
// 	["fwcpl",["Licence de pilote commercial à voilure fixe",true,["doj"],["doj"],0,{true}]],
// 	["gpl",["Licence de pilote du gouvernement",false,["doj"],["doj"],0,{true}]],
// 	["pfish",["Permis de pêche privé",false,["doj"],["doj"],0,{true}]],
// 	["sfish",["Permis de pêche sportive",false,["doj"],["doj"],0,{true}]],
// 	["cfish",["Permis de pêche commerciale",true,["doj"],["doj"],0,{true}]],

// 	["hunt",["Permis de chasse",false,["fisd"],["fisd"],0,{true}]],
// 	["ptl",["Permis remorque",false,["doj"],["doj"],0,{true}]],
// 	["ccp",["Concealed Carry Permit (CCP)",false,["fisd"],["fisd"],0,{true}]],
// 	["fsc",["FireArm Safety Certificate (FSC)",false,["fisd"],["fisd"],0,{true}]],
// 	["ocp",["Open Carry Permit (OCP)",false,["fisd"],["fisd"],0,{true}]],
// 	["fiba",["FIBA",false,["doj"],["doj"],0,{true}]],
// 	["sfp",["SFP",false,["doj"],["doj"],0,{true}]],
// 	["bond",["Certification Bond",false,["doj"],["doj"],0,{true}]],

// 	["company",["Certificat de création d'entreprise",false,["gov"],["gov"],0,{true}]],
// 	["chimicalf",["Accès usine chimique",true,["gov"],["gov"],0,{true}]],
// 	["steelf",["Accès aciérie",true,["gov"],["gov"],0,{true}]],
// 	["petrolf",["Accès raffinerie de pétrole",true,["gov"],["gov"],0,{true}]],
// 	["goodsf",["Accès usine de marchandises",true,["gov"],["gov"],0,{true}]],
// 	["weaponf",["Accès usine d'armes",true,["gov"],["gov"],0,{true}]],
// 	["foodf",["Accès usine alimentaire",true,["gov"],["gov"],0,{true}]],
// 	["carf",["Accès usine de véhicules",true,["gov"],["gov"],0,{true}]],
// 	["boatf",["Accès usine marine",true,["gov"],["gov"],0,{true}]],
// 	["airf",["Accès usine aéronefs",true,["gov"],["gov"],0,{true}]],
// 	["clothingf",["Accès usine de vêtements",true,["gov"],["gov"],0,{true}]],
//     ["jewelryf",["Accès usine de bijoux",true,["gov"],["gov"],0,{true}]],
//     ["impound",["Accès fourrière",true,["gov"],["gov"],0,{true}]],
// 	["custom",["Accès ateliers",true,["gov"],["gov"],0,{true}]],
// 	["cinema",["Accès cinéma",true,["gov"],["gov"],0,{true}]],
// 	["dmv",["DMV",true,["gov"],["gov"],0,{true}]],

// 	["dojmdtadmin",["DOJ MDT Admin",false,["doj"],["doj"],0,{["fisd","rank", (player getVariable ["character_id",""])] call A3PL_Config_GetFactionRankData IN ["Chief Judge"]}]],
// 	["govmdtadmin",["GOV MDT Admin",false,["gov"],["gov"],0,{["fisd","rank", (player getVariable ["character_id",""])] call A3PL_Config_GetFactionRankData IN ["Mayor"]}]],

// 	["fisdk9",["FISD K-9",false,["fisd"],["fisd"],0,{["fisd","rank", (player getVariable ["character_id",""])] call A3PL_Config_GetFactionRankData IN ["Sheriff"]}]],
// 	["fisdert",["FISD ERT",false,["fisd"],["fisd"],0,{["fisd","rank", (player getVariable ["character_id",""])] call A3PL_Config_GetFactionRankData IN ["Sheriff"]}]],
// 	["fisddtu",["FISD Detective",false,["fisd"],["fisd"],0,{["fisd","rank", (player getVariable ["character_id",""])] call A3PL_Config_GetFactionRankData IN ["Sheriff"]}]],
// 	["fisdhw",["FISD Highway Enforcement",false,["fisd"],["fisd"],0,{["fisd","rank", (player getVariable ["character_id",""])] call A3PL_Config_GetFactionRankData IN ["Sheriff"]}]],
// 	["fisdmrtm",["FISD Maritime and Aviation Unit",false,["fisd"],["fisd"],0,{["fisd","rank", (player getVariable ["character_id",""])] call A3PL_Config_GetFactionRankData IN ["Sheriff"]}]],
// 	["fisdcorr",["FISD Corrections",false,["fisd"],["fisd"],0,{["fisd","rank", (player getVariable ["character_id",""])] call A3PL_Config_GetFactionRankData IN ["Sheriff"]}]],
// 	["fisdhandgun",["FISD Handgun Certification",false,["fisd"],["fisd"],0,{["fisd","rank", (player getVariable ["character_id",""])] call A3PL_Config_GetFactionRankData IN ["Sheriff","Undersheriff","Captain","Lieutenant"]}]],
// 	["fisdfullauto",["FISD Full Automatic Weapon Certification",false,["fisd"],["fisd"],0,{["fisd","rank", (player getVariable ["character_id",""])] call A3PL_Config_GetFactionRankData IN ["Sheriff"]}]],
// 	["fisdlesslethal",["FISD Less Lethal Certification",false,["fisd"],["fisd"],0,{["fisd","rank", (player getVariable ["character_id",""])] call A3PL_Config_GetFactionRankData IN ["Sheriff","Undersheriff","Captain","Lieutenant"]}]],
// 	["fisdfirstaid",["FISD First Aid Certification",false,["fisd"],["fisd"],0,{["fisd","rank", (player getVariable ["character_id",""])] call A3PL_Config_GetFactionRankData IN ["Sheriff"]}]],
// 	["fisdshotgun",["FISD Shotgun Certification",false,["fisd"],["fisd"],0,{["fisd","rank", (player getVariable ["character_id",""])] call A3PL_Config_GetFactionRankData IN ["Sheriff"]}]],
// 	["fisdmdtadmin",["FISD MDT Admin",false,["fisd"],["fisd"],0,{["fisd","rank", (player getVariable ["character_id",""])] call A3PL_Config_GetFactionRankData IN ["Sheriff"]}]],

// 	["fifrmarshal",["FIFR Fire Marshal",false,["fifr"],["fifr"],0,{["fifr","rank", (player getVariable ["character_id",""])] call A3PL_Config_GetFactionRankData IN ["Battalion Chief","Assistant Chief","Chief"]}]],
// 	["fifrsar",["FIFR Search and Rescue",false,["fifr"],["fifr"],0,{["fifr","rank", (player getVariable ["character_id",""])] call A3PL_Config_GetFactionRankData IN ["Battalion Chief","Assistant Chief","Chief"]}]],
// 	["fifrrt",["FIFR Recruitment and Training",false,["fifr"],["fifr"],0,{["fifr","rank", (player getVariable ["character_id",""])] call A3PL_Config_GetFactionRankData IN ["Battalion Chief","Assistant Chief","Chief"]}]],
// 	["fifrmdtadmin",["FIFR MDT Admin",false,["fifr"],["fifr"],0,{["fifr","rank", (player getVariable ["character_id",""])] call A3PL_Config_GetFactionRankData IN ["Battalion Chief","Assistant Chief","Chief"]}]]
// ];
// publicVariable "Config_Licenses";
