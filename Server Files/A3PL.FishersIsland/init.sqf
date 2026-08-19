/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
enableSaving [false,false];
showChat false;

if(isDedicated) exitWith {
    [] spawn {
        waitUntil{uiSleep 0.05; (!isNil "A3PL_ServerLoaded")};
        waitUntil{uiSleep 0.05; A3PL_ServerLoaded};
        Ship_BlackMarket enableSimulationGlobal true;
        Ship_BlackMarket animate["Door_1",1,true]; 
        Ship_BlackMarket animate["Door_2",1,true];
        Ship_BlackMarket animate["Door_3",1,true];
        Ship_BlackMarket animate["Door_4",1,true];
        Ship_BlackMarket animate["Door_5",1,true];
        Ship_BlackMarket animate["Door_6",1,true];
        Ship_BlackMarket animate["Door_7",1,true];
        Ship_BlackMarket animate["Door_8",1,true];
        Ship_BlackMarket allowDamage false; 
        Ship_BlackMarket setFuel 0;
        sleep 60;
        Ship_BlackMarket enableSimulationGlobal false;
    };
    missionNamespace setVariable ["A3FL_FactionsLR_Code","JENGBjSRuHwrEdkD"];
    missionNamespace setVariable ["A3FL_TrucksLR_Code","BHusZfSVUtEjqrCM"];
    missionNamespace setVariable ["A3FL_AirLR_Code","mbcBaFpUxBRGzZsz"];
    missionNamespace setVariable ["A3FL_Phones_Code","DdENsVnpYykHmUqb"];
};
waitUntil{!(isNull player)};

player enableSimulation false;
[] spawn {
	waitUntil{uiSleep 0.05; (!isNil "A3PL_ServerLoaded")};
	waitUntil{uiSleep 0.05; A3PL_ServerLoaded};

	Player_Loaded = false;

	waitUntil {uiSleep 0.05; ((vehicle player) isEqualTo player)};
	waitUntil {uiSleep 0.05; !isNil "A3PL_Player_Initialize"};
    
	call A3PL_Player_Initialize;
};
