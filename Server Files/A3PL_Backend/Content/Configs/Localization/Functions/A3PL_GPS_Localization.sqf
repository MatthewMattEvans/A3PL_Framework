/*
    A3PL Localization - A3PL_GPS
*/

["A3PL_GPS_Localization", {
    Localization_Strings append [
    // Navigation HUD
    ["STR_A3PL_GPS_ArriveIn",
        "Arrivee dans %1",
        "Arriving in %1",
        "Ankunft in %1"
    ],
    ["STR_A3PL_GPS_TurnRight",
        "Tournez a droite dans %1",
        "Turn right in %1",
        "Rechts abbiegen in %1"
    ],
    ["STR_A3PL_GPS_TurnLeft",
        "Tournez a gauche dans %1",
        "Turn left in %1",
        "Links abbiegen in %1"
    ],
    ["STR_A3PL_GPS_Lost",
        "GPS perdu - Retournez sur la route",
        "GPS lost - Return to the road",
        "GPS verloren - Zurueck zur Strasse"
    ],
    ["STR_A3PL_GPS_Initializing",
        "Initialisation...",
        "Initializing...",
        "Initialisierung..."
    ],
    // Notifications
    ["STR_A3PL_GPS_NotLoaded",
        "Le GPS n'est pas encore charge, patientez...",
        "GPS is not loaded yet, please wait...",
        "GPS noch nicht geladen, bitte warten..."
    ],
    ["STR_A3PL_GPS_NoRoadNearDest",
        "Pas de route valide pres de la destination",
        "No valid road near destination",
        "Keine gueltige Strasse in der Naehe des Ziels"
    ],
    ["STR_A3PL_GPS_NoRoadNearPos",
        "Pas de route valide pres de votre position",
        "No valid road near your position",
        "Keine gueltige Strasse in Ihrer Naehe"
    ],
    ["STR_A3PL_GPS_Arrived",
        "Vous etes arrive a destination!",
        "You have arrived at your destination!",
        "Sie haben Ihr Ziel erreicht!"
    ],
    ["STR_A3PL_GPS_PathNotFound",
        "Chemin introuvable",
        "Path not found",
        "Weg nicht gefunden"
    ],
    ["STR_A3PL_GPS_StraightLine",
        "Aucun itineraire trouve - navigation directe activee",
        "No route found - direct navigation enabled",
        "Keine Route gefunden - Direktnavigation aktiviert"
    ],
    ["STR_A3PL_GPS_DirectNav",
        "Direction: destination - %1",
        "Heading to destination - %1",
        "Richtung: Ziel - %1"
    ],
    ["STR_A3PL_GPS_NoFuelStation",
        "Pas de station service a proximite",
        "No fuel station nearby",
        "Keine Tankstelle in der Naehe"
    ],
    ["STR_A3PL_GPS_NoTownNearby",
        "Pas de ville a proximite",
        "No town nearby",
        "Keine Stadt in der Naehe"
    ],
    ["STR_A3PL_GPS_Stopped",
        "Navigation GPS arretee",
        "GPS navigation stopped",
        "GPS-Navigation gestoppt"
    ],
    ["STR_A3PL_GPS_MapClickEnabled",
        "GPS: Clic-droit sur la carte pour naviguer",
        "GPS: Right-click on the map to navigate",
        "GPS: Rechtsklick auf die Karte zum Navigieren"
    ],
    ["STR_A3PL_GPS_MapClickDisabled",
        "GPS: Navigation par carte desactivee",
        "GPS: Map navigation disabled",
        "GPS: Kartennavigation deaktiviert"
    ],
    ["STR_A3PL_GPS_ErrorDialogNotFound",
        "Erreur: Dialog GPS introuvable",
        "Error: GPS dialog not found",
        "Fehler: GPS-Dialog nicht gefunden"
    ],
    ["STR_A3PL_GPS_ErrorNavDialogNotFound",
        "Erreur: Dialog Nav introuvable",
        "Error: Nav dialog not found",
        "Fehler: Nav-Dialog nicht gefunden"
    ],
    ["STR_A3PL_GPS_NoDestination",
        "Pas de destination en cours",
        "No current destination",
        "Kein aktuelles Ziel"
    ],
    ["STR_A3PL_GPS_RouteSaved",
        "Itineraire '%1' sauvegarde",
        "Route '%1' saved",
        "Route '%1' gespeichert"
    ],
    // QuickNav
    ["STR_A3PL_GPS_Loading",
        "Chargement...",
        "Loading...",
        "Laden..."
    ],
    ["STR_A3PL_GPS_Empty",
        "< Vide >",
        "< Empty >",
        "< Leer >"
    ],
    ["STR_A3PL_GPS_QuickNavFuel",
        "Station service",
        "Fuel station",
        "Tankstelle"
    ],
    ["STR_A3PL_GPS_QuickNavTown",
        "Ville proche",
        "Nearest town",
        "Naechste Stadt"
    ],
    // Dialog UI
    ["STR_A3PL_GPS_NavMapHeader",
        "<t size='1.2' align='center'>Cliquez sur la carte pour definir la destination</t>",
        "<t size='1.2' align='center'>Click on the map to set destination</t>",
        "<t size='1.2' align='center'>Klicken Sie auf die Karte um das Ziel zu setzen</t>"
    ],
    ["STR_A3PL_GPS_Close",
        "Fermer",
        "Close",
        "Schliessen"
    ]
    ];
}] call compile_Server;
