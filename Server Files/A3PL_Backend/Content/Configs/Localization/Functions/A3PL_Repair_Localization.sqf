/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/

["A3PL_Repair_Localization", {
	Localization_Strings append [
		// UI Dialog strings
		["STR_UI_Repair_MenuTitle",
		    "Réparation du véhicule",
		    "Vehicle Repair",
		    "Fahrzeugreparatur"
		],
		["STR_UI_Repair_ShowDamagedParts",
		    "Afficher uniquement les pièces endommagées",
		    "Show only damaged parts",
		    "Nur beschädigte Teile anzeigen"
		],
		["STR_UI_Repair_ButtonRepair",
		    "Réparer",
		    "Repair",
		    "Reparieren"
		],
		["STR_A3PL_Repair_Action_Repair",
		    "Réparer",
		    "Repair",
		    "Reparieren"
		],
		["STR_A3PL_Repair_Action_Maintain",
		    "Faire l'entretien",
		    "Maintain",
		    "Pflegen"
		],
		["STR_A3PL_Repair_UI_Part",
		    "Partie",
		    "Part",
		    "Teil"
		],
		["STR_A3PL_Repair_UI_State",
		    "État",
		    "State",
		    "Zustand"
		],
		["STR_A3PL_Repair_UI_Tool",
		    "Outil",
		    "Tool",
		    "Werkzeug"
		],
		["STR_A3PL_Repair_UI_Item",
		    "Objet",
		    "Item",
		    "Artikel"
		],
		["STR_A3PL_Repair_UI_Empty",
		    "Vide",
		    "Empty",
		    "Leer"
		],
		["STR_A3PL_Repair_UI_ShowDamagedParts",
		    "Afficher les pièces endommagées",
		    "Show damaged parts",
		    "Beschädigte Teile anzeigen"
		],
		["STR_A3PL_Repair_Progress_Repairing",
		    "Réparation : %1",
		    "Repairing: %1",
		    "Reparieren: %1"
		],
		["STR_A3PL_Repair_Message_Repaired",
		    "<t color='#0174DF'>%1</t> réparé à <t color='%2'>%3</t>%4.",
		    "<t color='#0174DF'>%1</t> repaired to <t color='%2'>%3</t>%4.",
		    "<t color='#0174DF'>%1</t> wurde zu <t color='%2'>%3</t>%4 repariert."
		],
		["STR_A3PL_Repair_Message_MaxRepair",
		    "L'état actuel de <t color='#0174DF'>%1</t> est de <t color='%2'>%3</t>%4 et ne peut être réparé qu'à <t color='%5'>%6</t>%4.",
		    "Current state of <t color='#0174DF'>%1</t> is <t color='%2'>%3</t>%4 and can only be repaired to <t color='%5'>%6</t>%4.",
		    "Der aktuelle Status von <t color='#0174DF'>%1</t> ist <t color='%2'>%3</t>%4 und kann nur bis <t color='%5'>%6</t>%4 repariert werden."
		],
		["STR_A3PL_Repair_Message_Information",
		    "<t align='left'><img image='%1'/></t><t align='center'>Informations</t>",
		    "<t align='left'><img image='%1'/></t><t align='center'>Informations</t>",
		    "<t align='left'><img image='%1'/></t><t align='center'>Informationen</t>"
		],
		["STR_A3PL_Repair_Message_State",
		    "<t align='left'>Etat</t><t align='right' color='%5'>%1%2</t><br/>",
		    "<t align='left'>State</t><t align='right' color='%5'>%1%2</t><br/>",
		    "<t align='left'>Staat</t><t align='right' color='%5'>%1%2</t><br/>"
		],
		["STR_A3PL_Repair_Message_Tool",
		    "<t align='left'>Outil</t><t align='right' color='%6'>%3</t><br/>",
		    "<t align='left'>Tool</t><t align='right' color='%6'>%3</t><br/>",
		    "<t align='left'>Werkzeug</t><t align='right' color='%6'>%3</t><br/>"
		],
		["STR_A3PL_Repair_Message_Item",
		    "<t align='left'>Pièce</t><t align='right' color='%7'>%4</t><br/>",
		    "<t align='left'>Item</t><t align='right' color='%7'>%4</t><br/>",
		    "<t align='left'>Item</t><t align='right' color='%7'>%4</t><br/>"
		],
		["STR_A3PL_Repair_Message_Allowed",
		    "<t align='left'>Réparation possible</t><t align='right' color='%8'>%9%2</t>",
		    "<t align='left'>Repair</t><t align='right' color='%8'>%9%2</t>",
		    "<t align='left'>Reparieren</t><t align='right' color='%8'>%9%2</t>"
		],
		["STR_A3PL_Repair_Error_NoTarget",
		    "Aucune cible.",
		    "No target.",
		    "Kein Ziel."
		],
		["STR_A3PL_Repair_Error_InvalidTarget",
		    "Cible invalide.",
		    "Invalid target.",
		    "Ungültiges Ziel."
		],
		["STR_A3PL_Repair_Error_VehicleSpeed",
		    "Le moteur du véhicule doit être arrêté.",
		    "Vehicle engine must be stopped.",
		    "Der Fahrzeugmotor muss abgestellt sein."
		],
		["STR_A3PL_Repair_Error_NoTool",
		    "Vous n'avez pas l'outil requis (<t color='#8cff9b'>%1</t>) pour effectuer cette réparation.",
		    "You don't have the appropriate tool (<t color='#8cff9b'>%1</t>) to perform this reparation.",
		    "Sie verfügen nicht über das entsprechende Werkzeug (<t color='#8cff9b'>%1</t>), um diese Reparatur durchzuführen."
		],
		["STR_A3PL_Repair_Error_NoItem",
		    "Vous n'avez pas l'objet requis.",
		    "You do not have the required item.",
		    "Sie haben den benötigten Artikel nicht."
		],
		["STR_A3PL_Repair_Error_Occurs",
		    "Une erreur est survenue.",
		    "An error has occurred.",
		    "Es ist ein Fehler aufgetreten."
		],
		["STR_A3PL_Repair_HitPoint_Body",
		    "Carrosserie",
		    "Hull",
		    "Rumpf"
		],
		["STR_A3PL_Repair_HitPoint_Glass",
		    "Vitre",
		    "Window",
		    "Fenster"
		],
		["STR_A3PL_Repair_HitPoint_Engine",
		    "Moteur",
		    "Motor",
		    "Motor"
		],
		["STR_A3PL_Repair_HitPoint_WheelL01",
		    "Roue gauche 1",
		    "Left wheel 1",
		    "Linkes Rad 1"
		],
		["STR_A3PL_Repair_HitPoint_WheelL02",
		    "Roue gauche 2",
		    "Left wheel 2",
		    "Linkes Rad 2"
		],
		["STR_A3PL_Repair_HitPoint_WheelL03",
		    "Roue gauche 3",
		    "Left wheel 3",
		    "Linkes Rad 3"
		],
		["STR_A3PL_Repair_HitPoint_WheelL04",
		    "Roue gauche 4",
		    "Left wheel 4",
		    "Linkes Rad 4"
		],
		["STR_A3PL_Repair_HitPoint_WheelR01",
		    "Roue droite 1",
		    "Right wheel 1",
		    "Rechtes Rad 1"
		],
		["STR_A3PL_Repair_HitPoint_WheelR02",
		    "Roue droite 2",
		    "Right wheel 2",
		    "Rechtes Rad 2"
		],
		["STR_A3PL_Repair_HitPoint_WheelR03",
		    "Roue droite 3",
		    "Right wheel 3",
		    "Rechtes Rad 3"
		],
		["STR_A3PL_Repair_HitPoint_WheelR04",
		    "Roue droite 4",
		    "Right wheel 4",
		    "Rechtes Rad 4"
		],
		["STR_A3PL_Repair_HitPoint_WheelF",
		    "Roue avant",
		    "Front wheel",
		    "Vorderrad"
		],
		["STR_A3PL_Repair_HitPoint_WheelB",
		    "Roue arrière",
		    "Rear wheel",
		    "Hinterrad"
		],
		["STR_A3PL_Repair_HitPoint_MainRotor",
		    "Rotor principal",
		    "Main Rotor",
		    "Hauptrotor"
		],
		["STR_A3PL_Repair_HitPoint_SubRotor",
		    "Rotor secondaire",
		    "Secondary rotor",
		    "Sekundärrotor"
		],
		["STR_A3PL_Repair_HitPoint_Fuel",
		    "Réservoir",
		    "Tank",
		    "Tank"
		],
		["STR_A3PL_Repair_HitPoint_TrackL",
		    "Chenille gauche",
		    "Left track",
		    "Linkes Gleis"
		],
		["STR_A3PL_Repair_HitPoint_TrackR",
		    "Chenille droite",
		    "Right track",
		    "Richtige Spur"
		],
		["STR_A3PL_Repair_HitPoint_Turret",
		    "Tourelle",
		    "Turret",
		    "Turm"
		],
		["STR_A3PL_Repair_HitPoint_Gun",
		    "Armement",
		    "armament",
		    "Rüstung"
		],
		["STR_A3PL_Repair_HitPoint_Ammo",
		    "Soute à munitions",
		    "Munition dump",
		    "Munitionslager"
		],
		["STR_A3PL_Repair_HitPoint_Hull",
		    "Coque",
		    "Hull",
		    "Rumpf"
		],
		["STR_A3PL_Repair_HitPoint_Avionics",
		    "Avionique",
		    "Avionics",
		    "Avionik"
		],
		["STR_A3PL_Repair_HitPoint_Missiles",
		    "Missiles",
		    "Missiles",
		    "Raketen"
		],
		["STR_A3PL_Repair_HitPoint_Winch",
		    "Treuil",
		    "Winch",
		    "Winde"
		],
		["STR_A3PL_Repair_HitPoint_Transmission",
		    "Transmission",
		    "Transmission",
		    "Übertragung"
		],
		["STR_A3PL_Repair_HitPoint_Light",
		    "Phare",
		    "Light",
		    "Licht"
		],
		["STR_A3PL_Repair_HitPoint_Hydraulics",
		    "Suspension",
		    "Hydraulics",
		    "Hydraulik"
		],
		["STR_A3PL_Repair_HitPoint_Gear",
		    "Trains d'attérrissage",
		    "Gear",
		    "Gang"
		],
		["STR_A3PL_Repair_HitPoint_StabilizerL",
		    "Stabilisateur gauche",
		    "Left stabilizer",
		    "Linker Stabilisator"
		],
		["STR_A3PL_Repair_HitPoint_StabilizerR",
		    "Stabilisateur droit",
		    "Right stabilizer",
		    "Rechter Stabilisator"
		],
		["STR_A3PL_Repair_HitPoint_Stabilizer",
		    "Stabilisateur",
		    "Stabilizer",
		    "Stabilisator"
		],
		["STR_A3PL_Repair_HitPoint_Tail",
		    "Queue",
		    "Tail",
		    "Schwanz"
		],
		["STR_A3PL_Repair_HitPoint_PitotTube",
		    "Tube de Pitot",
		    "Pitot tube",
		    "Staurohr"
		],
		["STR_A3PL_Repair_HitPoint_StaticPort",
		    "Instruments",
		    "Instruments",
		    "Instrumente"
		],
		["STR_A3PL_Repair_HitPoint_Starter",
		    "Boite de démarrage",
		    "Starter",
		    "Anlasser"
		],
		["STR_A3PL_Repair_UI_Method",
		    "Méthode",
		    "Method",
		    "Methode"
		],
		["STR_A3PL_Repair_Method_Mechanic",
		    "Mécanicien",
		    "Mechanic",
		    "Mechaniker"
		],
		["STR_A3PL_Repair_Method_Tinkerer",
		    "Bricoleur",
		    "Tinkerer",
		    "Tüftler"
		],
		["STR_A3PL_Repair_Method_GreaseMonkey",
		    "Grease Monkey",
		    "Grease Monkey",
		    "Grease Monkey"
		],
		["STR_A3PL_Repair_Method_Basic",
		    "Réparation de base",
		    "Basic repair",
		    "Grundreparatur"
		],
		["STR_A3PL_Repair_Method_None",
		    "Impossible",
		    "Not possible",
		    "Nicht möglich"
		],
		["STR_A3PL_Repair_Method_Company",
		    "Employé d'atelier",
		    "Workshop Employee",
		    "Werkstattmitarbeiter"
		],
		["STR_A3PL_Repair_Trait_Mechanic",
		    "Mécanicien (100%)",
		    "Mechanic (100%)",
		    "Mechaniker (100%)"
		],
		["STR_A3PL_Repair_Trait_Tinkerer",
		    "Bricoleur (50%)",
		    "Tinkerer (50%)",
		    "Tüftler (50%)"
		],
		["STR_A3PL_Repair_Trait_GreaseMonkey",
		    "Grease Monkey (40%)",
		    "Grease Monkey (40%)",
		    "Grease Monkey (40%)"
		],
		["STR_A3PL_Repair_Trait_None",
		    "Aucun trait",
		    "No trait",
		    "Kein Merkmal"
		],
		["STR_A3PL_Repair_Workshop_Required",
		    "⚠ Atelier requis",
		    "⚠ Workshop required",
		    "⚠ Werkstatt erforderlich"
		],
		["STR_A3PL_Repair_Workshop_Inside",
		    "✓ Dans un atelier",
		    "✓ Inside workshop",
		    "✓ In der Werkstatt"
		],
		["STR_A3PL_Repair_Error_NeedWorkshop",
		    "Cette pièce ne peut être installée que dans un atelier.",
		    "This part can only be installed in a workshop.",
		    "Dieses Teil kann nur in einer Werkstatt installiert werden."
		],
		["STR_A3PL_Repair_Error_TinkererCantUsePart",
		    "Votre compétence Bricoleur ne permet pas d'utiliser cette pièce.",
		    "Your Tinkerer skill cannot use this part.",
		    "Ihre Tüftler-Fähigkeit kann dieses Teil nicht verwenden."
		],
		["STR_A3PL_Repair_Error_NeedMechanicOrTinkerer",
		    "Vous avez besoin de la compétence Mécanicien ou Bricoleur pour utiliser des pièces.",
		    "You need the Mechanic or Tinkerer skill to use parts.",
		    "Sie benötigen die Fähigkeit Mechaniker oder Tüftler, um Teile zu verwenden."
		],
		["STR_A3PL_Repair_Error_NeedCompanyOrSkill",
		    "Seuls les employés d'atelier ou les joueurs avec la compétence Mécanicien/Bricoleur peuvent réparer cette pièce.",
		    "Only workshop employees or players with Mechanic/Tinkerer skill can repair this part.",
		    "Nur Werkstattmitarbeiter oder Spieler mit Mechaniker/Tüftler-Fähigkeit können dieses Teil reparieren."
		],
		["STR_A3PL_Repair_Message_RepairedWithMethod",
		    "<t color='#0174DF'>%1</t> réparé à <t color='%2'>%3</t>%4 (%5).",
		    "<t color='#0174DF'>%1</t> repaired to <t color='%2'>%3</t>%4 (%5).",
		    "<t color='#0174DF'>%1</t> wurde zu <t color='%2'>%3</t>%4 repariert (%5)."
		],
		["STR_A3PL_Repair_MacGyvering",
		    "Réparation de fortune en cours...",
		    "MacGyvering in progress...",
		    "MacGyvering läuft..."
		],
		["STR_A3PL_Repair_MacGyverSuccess",
		    "Réparation de fortune effectuée ! Le véhicule tiendra 10 minutes.",
		    "Emergency repair done! Vehicle will hold for 10 minutes.",
		    "Notreparatur durchgeführt! Fahrzeug hält 10 Minuten."
		],
		["STR_A3PL_Repair_AlreadyMacGyvered",
		    "Ce véhicule a déjà été réparé de fortune.",
		    "This vehicle has already been MacGyvered.",
		    "Dieses Fahrzeug wurde bereits MacGyvered."
		],
		["STR_A3PL_Repair_NoHitPoints",
		    "Impossible de récupérer les données du véhicule.",
		    "Unable to retrieve vehicle data.",
		    "Fahrzeugdaten konnten nicht abgerufen werden."
		],
		["STR_A3PL_Trait_MacGyver_Required",
		    "Vous avez besoin de la compétence MacGyver pour cette action.",
		    "You need the MacGyver skill for this action.",
		    "Sie benötigen die MacGyver-Fähigkeit für diese Aktion."
		],
		["STR_A3PL_Repair_Warning_NoSkillForPart",
		    "Vous n'avez pas les compétences pour utiliser cette pièce. Réparation de base effectuée sans consommer la pièce.",
		    "You don't have the skills to use this part. Basic repair done without consuming the part.",
		    "Sie haben nicht die Fähigkeiten, um dieses Teil zu verwenden. Grundreparatur ohne Verbrauch des Teils."
		],
		["STR_A3PL_Repair_Warning_NoSkillShort",
		    "Pièce non utilisée (skill requis)",
		    "Part not used (skill required)",
		    "Teil nicht verwendet (Skill erforderlich)"
		],
		["STR_A3PL_Repair_Error_NoPart",
		    "Vous avez besoin d'une pièce de rechange pour effectuer cette réparation.",
		    "You need a spare part to perform this repair.",
		    "Sie benötigen ein Ersatzteil, um diese Reparatur durchzuführen."
		]
	];
}] call Compile_Global;
