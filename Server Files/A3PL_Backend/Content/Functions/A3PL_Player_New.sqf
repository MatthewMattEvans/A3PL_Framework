/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Player_SpawnMenu",{
    disableSerialization;
    private _spawnList = [];
    private _houseObjects = player getVariable["houses",[]];
    private _warehouseObj = player getVariable["warehouse",objNull];
    private _crackhouseObj = player getVariable["crackhouse",objNull];
    private _faction = player getVariable["faction","citizen"];

    // Toutes les maisons du joueur
    {
        private _houseObj = _x;
        private _ATL = switch(typeOf _houseObj) do {
            case "Land_Home5y_DED_Home5y_01_F": {[(getPosATL _houseObj)#0 + 4,(getPosATL _houseObj)#1 + 4,(getPosATL _houseObj)#2]};
            case "Land_Mansion01": {[(getPosATL _houseObj)#0,(getPosATL _houseObj)#1 + 1,(getPosATL _houseObj)#2 + 1]};
            default {getPosATL _houseObj};
        };
        private _name = if(count _houseObjects > 1) then {format["%1 #%2",("STR_A3PL_Player_New_House" call A3PL_Localize),_forEachIndex + 1]} else {("STR_A3PL_Player_New_House" call A3PL_Localize)};
        _spawnList pushback [_name,_ATL,1];
    } forEach _houseObjects;

	if(!isNull _warehouseObj) then {_spawnList pushback [("STR_A3PL_Player_New_Warehouse" call A3PL_Localize),getPosATL _warehouseObj,2];};

    // Spawn faction
    if(_faction isEqualTo ("STR_Common_FIFR" call A3PL_Localize) && {!isNil "Spawn_FIFR"} && {!(Spawn_FIFR isEqualTo [0,0,0])}) then {
        _spawnList pushback [("STR_A3PL_Player_New_FIFR" call A3PL_Localize),Spawn_FIFR,3];
    };
    if(_faction isEqualTo ("STR_Common_FISD" call A3PL_Localize) && {!isNil "Spawn_FISD"} && {!(Spawn_FISD isEqualTo [0,0,0])}) then {
        _spawnList pushback [("STR_A3PL_Player_New_FISD" call A3PL_Localize),Spawn_FISD,3];
    };
    if(_faction isEqualTo ("STR_Common_DOJ" call A3PL_Localize) && {!isNil "Spawn_DOJ"} && {!(Spawn_DOJ isEqualTo [0,0,0])}) then {
        _spawnList pushback [("STR_A3PL_Player_New_DOJ" call A3PL_Localize),Spawn_DOJ,3];
    };

    _spawnList pushback [("STR_A3PL_Player_New_ElkCity" call A3PL_Localize),[6548.25,7552.95,0],0];

    createDialog "Dialog_SpawnMenu";

    private _display = findDisplay 130;
    noEscape = _display displayAddEventHandler ["KeyDown", "true;"];
    private _control = _display displayCtrl 1500;
    {
        _i = _control lbAdd (_x select 0);
        _control lbSetData[_i,str(_x select 1)];
        _control lbSetValue[_i,_x select 2];
    } forEach _spawnList;
    _control lbSetCurSel 0;
    _control ctrlAddEventHandler ["LBSelChanged","call A3PL_Player_SelectSpawnMap;"];
    private _mapControl = _display displayCtrl 1700;
    _mapControl ctrlMapAnimAdd [0, 0.03, ((_spawnList#0)#1)];
    ctrlMapAnimCommit _mapControl;
}] call compile_Global;

["A3PL_Player_SelectSpawn",{
    disableSerialization;
    if(!(call A3PL_Player_AntiSpam)) exitWith {};
    private _display = findDisplay 130;
    private _control = _display displayCtrl 1500;
    if((lbCurSel 1500) isEqualTo -1) exitWith {};
    private _spawnPos = call compile (_control lbData (lbCurSel 1500));
    private _spawnType = _control lbValue (lbCurSel 1500);
    private _spawnTypeName = "N/A";
    player enableSimulation true;
    closeDialog 0;
    cutText["","BLACK IN"];
    switch(_spawnType) do {
        case 0: {
            [player,_spawnPos] remoteExecCall ["Server_Housing_AssignApt",2];
            [player] remoteExecCall ["Server_Housing_SetPosApt",2];
            _spawnTypeName = ("STR_A3PL_Player_New_Apartment" call A3PL_Localize);
        };
        case 1: {
            player setPosATL _spawnPos;
            _spawnTypeName = ("STR_A3PL_Player_New_House" call A3PL_Localize);
        };
        case 2: {
            player setPosATL _spawnPos;
            _spawnTypeName = ("STR_A3PL_Player_New_Warehouse" call A3PL_Localize);
        };
        case 3: {
            player setPosATL _spawnPos;
            _spawnTypeName = player getVariable["faction","citizen"];
        };
    };
    player setVariable ["tf_voiceVolume", 1, true];
    _display displayRemoveEventHandler ["KeyDown", noEscape];
    [getPlayerUID player,(player getVariable ["character_id",""]),"Player_Spawn",[format ["Spawn Type: %1 | Location: %2",_spawnTypeName,_spawnPos]]] remoteExec ["Server_Log_New",2];
    [(player getVariable ["character_id",""])] remoteExec ["Server_Player_Lastseen",2];
}] call compile_Global;

["A3PL_Player_SelectSpawnMap",{
    disableSerialization;
    private _display = findDisplay 130;
    private _listControl = _display displayCtrl 1500;
    private _spawnPos = call compile (_listControl lbData (lbCurSel 1500));
    private _mapControl = _display displayCtrl 1700;
    _mapControl ctrlMapAnimAdd [1, 0.03, _spawnPos];
    ctrlMapAnimCommit _mapControl;
}] call compile_Global;

["A3PL_Player_NewCharacter",{
    [("STR_A3PL_Player_New_WelcomeToFishersIsland" call A3PL_Localize),Color_Green] call A3PL_Notification;

    private _gender = player getVariable ["gender","male"];
    if(_gender isEqualTo "female") then {
        player addUniform (["woman1","woman2","woman3"] select (round (random 2)));
    };

    player setVariable["new",true,true];
    Player_StartTutorial = 0;
    [] spawn A3PL_Player_NewPlayerTutorial;
}] call compile_Global;

["A3PL_Player_NewPlayerTutorial",
{
    if (Player_StartTutorial isEqualTo 0) then {
        private _action = [("STR_A3PL_Player_New_DoYouWantToFollowTheTutorial" call A3PL_Localize)] call A3PL_Lib_ConfirmationDialog;
	    if (!isNil "_action" && {!_action}) exitWith {[("STR_A3PL_Player_New_YouChoosedToNotFollow" call A3PL_Localize),Color_Red] call A3PL_Notification;Player_StartTutorial = 1;profileNamespace setVariable ["Player_StartTutorial",Player_StartTutorial];};
        
        sleep 2;
        [("STR_A3PL_Player_New_FollowAllTheSteps" call A3PL_Localize),-1,-1,4,1,0,789] spawn BIS_fnc_dynamicText;
        sleep 5;

        private _motel = nearestObject [player, "Land_A3PL_Motel"];
        private _AptNumber = player getVariable["aptNumber",1];
        Apt = format["door_%1",_AptNumber];
        private _interPos = _motel selectionPosition [Apt,"Memory"];
        pos = _motel modelToWorldVisual _interPos;
        MotelID = addMissionEventHandler ["Draw3D", {
            drawIcon3D [
                "\A3\ui_f\data\IGUI\Cfg\Actions\open_Door_ca.paa",
                [1,0,0,1],
                pos,
                1,
                1,
                0,
                ("STR_A3PL_Player_New_MainDoor" call A3PL_Localize),
                2,
                0.05,
                "RobotoCondensedBold",
                "center",
                true
            ];
        }];
        [("STR_A3PL_Player_New_Step1" call A3PL_Localize)] call A3PL_Notifications_Tutorial;
        waitUntil {player_nameintersect == Apt};
        sleep 1;
        removeMissionEventHandler ["Draw3D",MotelID];

        sleep 2;

        GarageID = addMissionEventHandler ["Draw3D", {
            private _storagebox = (nearestObjects [player, ["Land_A3PL_storage"], 1000]) select 0;
            private _pos = ASLtoAGL getPosASL _storagebox;
            drawIcon3D [
                "A3\ui_f\data\gui\rsc\rscdisplayarsenal\spacegarage_ca.paa",
                [1,0,0,1],
                _pos,
                1,
                1,
                0,
                ("STR_A3PL_Player_New_Garage" call A3PL_Localize),
                2,
                0.05,
                "RobotoCondensedBold",
                "center",
                true
            ];
        }];
        [("STR_A3PL_Player_New_Step2" call A3PL_Localize)] call A3PL_Notifications_Tutorial;
        waitUntil {count(nearestObjects [player, ["Land_A3PL_storage"], 10]) > 0;};
        sleep 1;
        removeMissionEventHandler ["Draw3D",GarageID];

        [("STR_A3PL_Player_New_Step3" call A3PL_Localize)] call A3PL_Notifications_Tutorial;
        waitUntil {
            private _vehicles = nearestObjects [player, ["Car"], 20];
            car = objNull;
            sleep 1;
            {
                private _owner = _x getVariable ["owner",[]];
                if ((_owner#0) isEqualTo (player getVariable ["character_id",""])) exitWith {
                    car = _x;
                };
            } forEach _vehicles;
            !isNull car;
        };

        private _doorPos = car selectionPosition ["door_lf","Memory"];
        pos = car modelToWorldVisual _doorPos;
        DoorID = addMissionEventHandler ["Draw3D", {
            drawIcon3D [
                "A3\ui_f\data\gui\cfg\keyframeanimation\iconkey_ca.paa",
                [1,0,0,1],
                pos,
                1,
                1,
                0,
                ("STR_A3PL_Player_New_Door" call A3PL_Localize),
                2,
                0.05,
                "RobotoCondensedBold",
                "center",
                true
            ];
        }];
        [("STR_A3PL_Player_New_Step4" call A3PL_Localize)] call A3PL_Notifications_Tutorial;
        waitUntil {player_nameintersect == "door_lf"};
        removeMissionEventHandler ["Draw3D",DoorID];
        waitUntil {!(vehicle player isEqualTo player)};

        sleep 1;

        private _ignitionPos = car selectionPosition ["ignition","Memory"];
        pos = car modelToWorldVisual _ignitionPos;
        IgnitionID = addMissionEventHandler ["Draw3D", {
            drawIcon3D [
                "\a3\ui_f\data\IGUI\RscIngameUI\RscUnitInfoAirRTDFull\igui_wlight_eng_ca.paa",
                [1,0,0,1],
                pos,
                1,
                1,
                0,
                ("STR_A3PL_Player_New_StartEngine" call A3PL_Localize),
                2,
                0.05,
                "RobotoCondensedBold",
                "center",
                true
            ];
        }];
        [("STR_A3PL_Player_New_Step5" call A3PL_Localize)] call A3PL_Notifications_Tutorial;
        waitUntil {isEngineOn vehicle player};
        sleep 1;
        removeMissionEventHandler ["Draw3D",IgnitionID];

        sleep 1;
        [("STR_A3PL_Player_New_Step6" call A3PL_Localize)] call A3PL_Notifications_Tutorial;
        waitUntil {player getVariable ["SeatbeltOn",false]};
        
        sleep 1;
        
        
        jobCenterMan = position npc_jobcenter;
        jobCenterID = addMissionEventHandler ["Draw3D", {
            drawIcon3D [
                "\A3\ui_f\data\IGUI\Cfg\Actions\talk_ca.paa",
                [1,0,0,1],
                jobCenterMan,
                1,
                1,
                0,
                format[("STR_A3PL_Player_New_JobCenter" call A3PL_Localize),floor(player distance jobCenterMan)],
                2,
                0.05,
                "RobotoCondensedBold",
                "center",
                true
            ];
        }];
        [("STR_A3PL_Player_New_Step7" call A3PL_Localize)] call A3PL_Notifications_Tutorial;
        waitUntil {(player inArea [jobCenterMan,25,25,0,false]);};
        sleep 1;
        ["STR_A3PL_Player_New_Step8"] call A3PL_Notifications_Tutorial;
        sleep 2;
        [("STR_A3PL_Player_New_Step9" call A3PL_Localize)] call A3PL_Notifications_Tutorial;
        waitUntil {player_nameintersect == "spine3"};
        sleep 1;
        removeMissionEventHandler ["Draw3D",jobCenterID];


        _job = player getvariable "job";
        waitUntil {((player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) IN [("STR_Common_Job_Waste" call A3PL_Localize),("STR_Common_Job_Deliver" call A3PL_Localize)])};
        sleep 2;


        if ((player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) IsEqualTo ("STR_Common_Job_Deliver" call A3PL_Localize)) then {
            private _NPC = npc_mailMan selectionPosition ["spine3","Memory"];
            pos = npc_mailMan modelToWorldVisual _NPC;
            StartID = addMissionEventHandler ["Draw3D", {
                drawIcon3D [
                    "\A3\ui_f\data\IGUI\Cfg\Actions\talk_ca.paa",
                    [1,0,0,1],
                    pos,
                    1,
                    1,
                    0,
                    ("STR_A3PL_Player_New_TalkToEmployee" call A3PL_Localize),
                    2,
                    0.05,
                    "RobotoCondensedBold",
                    "center",
                    true
                ];
            }];
            [("STR_A3PL_Player_New_Step10" call A3PL_Localize)] call A3PL_Notifications_Tutorial;
            sleep 6;
            waitUntil {player_nameintersect == "spine3"};
            sleep 1;
            removeMissionEventHandler ["Draw3D",StartID];
            waitUntil {
                private _jobVehicle = objNull;
                _jobVehicle = player getVariable["jobVehicle",objNull];
                !isNull (_jobVehicle);
            };
                
            jobVehicle = player getVariable["jobVehicle",objNull];
            private _doorPos = jobVehicle selectionPosition ["trunk","Memory"];
            pos = jobVehicle modelToWorldVisual _doorPos;
            TrunkID = addMissionEventHandler ["Draw3D", {
                drawIcon3D [
                    "A3\ui_f\data\gui\cfg\keyframeanimation\iconkey_ca.paa",
                    [1,0,0,1],
                    pos,
                    1,
                    1,
                    0,
                    ("STR_A3PL_Player_New_Trunk" call A3PL_Localize),
                    2,
                    0.05,
                    "RobotoCondensedBold",
                    "center",
                    true
                ];
            }];
            [("STR_A3PL_Player_New_Step11" call A3PL_Localize)] call A3PL_Notifications_Tutorial;

            waitUntil {player_nameintersect == "trunk"};
            removeMissionEventHandler ["Draw3D",TrunkID];
            sleep 2;

            private _box = (nearestObjects [player, ["A3PL_DeliveryBox"], 20])#0;
            private _boxPos = _box selectionPosition ["item_pickup","Memory"];
            Boxpos = _box modelToWorldVisual _boxPos;
            BoxID = addMissionEventHandler ["Draw3D", {
                drawIcon3D [
                    "\A3\ui_f\data\gui\cfg\Hints\doors_ca.paa",
                    [1,0,0,1],
                    Boxpos,
                    1,
                    1,
                    0,
                    ("STR_A3PL_Player_New_DeliveryBox" call A3PL_Localize),
                    2,
                    0.05,
                    "RobotoCondensedBold",
                    "center",
                    true
                ];
            }];
            [("STR_A3PL_Player_New_Step12" call A3PL_Localize)] call A3PL_Notifications_Tutorial;
            sleep 2;
            waitUntil {(inputAction "Action" > 0) && (player_nameintersect == "item_pickup")};
            removeMissionEventHandler ["Draw3D",BoxID];


            _label = _box getVariable ["label",[]];
            _address = _label select 2;
            delivery = _label select 0;
            DestID = addMissionEventHandler ["Draw3D", {
                drawIcon3D [
                    "A3\ui_f\data\igui\cfg\simpletasks\types\box_ca.paa",
                    [1,0,0,1],
                    delivery,
                    1,
                    1,
                    0,
                    ("STR_A3PL_Player_New_DeliveryPoint" call A3PL_Localize),
                    2,
                    0.05,
                    "RobotoCondensedBold",
                    "center",
                    true
                ];
            }];
            [format[("STR_A3PL_Player_New_Step13" call A3PL_Localize),_address]] call A3PL_Notifications_Tutorial;
            waitUntil {isEngineOn vehicle player};
            sleep 1;
            [format[("STR_A3PL_Player_New_Step14" call A3PL_Localize),_address]] call A3PL_Notifications_Tutorial;

            waitUntil {(player inArea [delivery,15,15,0,false]);};
            [
                ("STR_A3PL_Player_New_Step15" call A3PL_Localize),
                -1,
                -1,
                15,
                1,
                0,
                789
            ] spawn BIS_fnc_dynamicText;
            [("STR_A3PL_Player_New_Step15" call A3PL_Localize)] call A3PL_Notifications_Tutorial;

            sleep 3;
                
            private _boxPos = _box selectionPosition ["item_pickup","Memory"];
            Boxpos = _box modelToWorldVisual _boxPos;
            BoxID = addMissionEventHandler ["Draw3D", {
                drawIcon3D [
                    "\A3\ui_f\data\gui\cfg\Hints\doors_ca.paa",
                    [1,0,0,1],
                    Boxpos,
                    1,
                    1,
                    0,
                    ("STR_A3PL_Player_New_DeliveryBox" call A3PL_Localize),
                    2,
                    0.05,
                    "RobotoCondensedBold",
                    "center",
                    true
                ];
            }];
            [("STR_A3PL_Player_New_Step16" call A3PL_Localize)] call A3PL_Notifications_Tutorial;

            waitUntil {(inputAction "Action" > 0) && (player_nameintersect == "item_pickup")};
            removeMissionEventHandler ["Draw3D",BoxID];
            sleep 1;

            [("STR_A3PL_Player_New_Step17" call A3PL_Localize)] call A3PL_Notifications_Tutorial;

            waitUntil {(([player] call A3PL_Lib_AttachedAll) isEqualTo []) && ((player distance delivery) < 10);};
            removeMissionEventHandler ["Draw3D",DestID];
            sleep 3;

            [("STR_A3PL_Player_New_Step18" call A3PL_Localize)] call A3PL_Notifications_Tutorial;
            waitUntil {(Player_Paycheck > 999);};
            sleep 1;

            pos = npc_mailMan modelToWorldVisual _NPC;
            EndID = addMissionEventHandler ["Draw3D", {
                drawIcon3D [
                    "\A3\ui_f\data\IGUI\Cfg\Actions\talk_ca.paa",
                    [1,0,0,1],
                    pos,
                    1,
                    1,
                    0,
                    ("STR_A3PL_Player_New_TalkToEmployee" call A3PL_Localize),
                    2,
                    0.05,
                    "RobotoCondensedBold",
                    "center",
                    true
                ];
            }];
            [("STR_A3PL_Player_New_Step19" call A3PL_Localize)] call A3PL_Notifications_Tutorial;

            sleep 3;
            waitUntil {(player inArea [pos,50,50,0,false])};
            [("STR_A3PL_Player_New_Step20" call A3PL_Localize)] call A3PL_Notifications_Tutorial;
                
            waitUntil {player_nameintersect == "spine3"};
            sleep 1;
            removeMissionEventHandler ["Draw3D",EndID];
        };


        if ((player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) IsEqualTo ("STR_Common_Job_Waste" call A3PL_Localize)) then {
            private _NPC = NPC_WasteManagement selectionPosition ["spine3","Memory"];
            pos = NPC_WasteManagement modelToWorldVisual _NPC;
            StartID = addMissionEventHandler ["Draw3D", {
                drawIcon3D [
                    "\A3\ui_f\data\IGUI\Cfg\Actions\talk_ca.paa",
                    [1,0,0,1],
                    pos,
                    1,
                     1,
                    0,
                    ("STR_A3PL_Player_New_TalkToEmployee" call A3PL_Localize),
                    2,
                    0.05,
                    "RobotoCondensedBold",
                    "center",
                    true
                ];
            }];
            [("STR_A3PL_Player_New_Step21" call A3PL_Localize)] call A3PL_Notifications_Tutorial;
            waitUntil {player_nameintersect == "spine3"};
            sleep 1;
            removeMissionEventHandler ["Draw3D",StartID];
            waitUntil {
                private _jobVehicle = objNull;
                _jobVehicle = player getVariable["jobVehicle",objNull];
                !isNull (_jobVehicle);
            };
            jobVehicle = player getVariable["jobVehicle",objNull];
            private _doorPos = jobVehicle selectionPosition ["door_lf","Memory"];
            pos = jobVehicle modelToWorldVisual _doorPos;
            DoorWasteID = addMissionEventHandler ["Draw3D", {
                drawIcon3D [
                    "A3\ui_f\data\gui\cfg\keyframeanimation\iconkey_ca.paa",
                    [1,0,0,1],
                    pos,
                    1,
                    1,
                    0,
                    ("STR_A3PL_Player_New_Door" call A3PL_Localize),
                    2,
                    0.05,
                    "RobotoCondensedBold",
                    "center",
                    true
                ];
            }];
            [("STR_A3PL_Player_New_Step22" call A3PL_Localize)] call A3PL_Notifications_Tutorial;
            waitUntil {player_nameintersect == "door_lf"};
            removeMissionEventHandler ["Draw3D",DoorWasteID];
            waitUntil {!(jobVehicle getVariable["locked",true])};
            waitUntil {!(vehicle player isEqualTo player)};

            sleep 1;

            [("STR_A3PL_Player_New_Step23" call A3PL_Localize)] call A3PL_Notifications_Tutorial;

            waste = position bin_elk_8;
            WasteID = addMissionEventHandler ["Draw3D", {
                drawIcon3D [
                    "A3FL_Props\icons\trash_ca.paa",
                    [1,0,0,1],
                    waste,
                    1,
                    1,
                    0,
                    format[("STR_A3PL_Player_New_Trash" call A3PL_Localize),floor(player distance waste)],
                    2,
                    0.05,
                    "RobotoCondensedBold",
                    "center",
                    true
                ];
            }];
            waitUntil {(player inArea [waste,30,30,0,false]);};
            sleep 1;
            removeMissionEventHandler ["Draw3D",WasteID];

            [("STR_A3PL_Player_New_Step24" call A3PL_Localize)] call A3PL_Notifications_Tutorial;

            pickupBin = addMissionEventHandler ["Draw3D", {
                obj = (nearestObjects [player, ["A3PL_WheelieBin"], 10]) select 0;
                private _pickupPos = obj selectionPosition ["lid","Memory"];
                pos = obj modelToWorldVisual _pickupPos;
                drawIcon3D [
                    "A3FL_Props\icons\trash_ca.paa",
                    [1,0,0,1],
                    pos,
                    1,
                    1,
                    0,
                    ("STR_A3PL_Player_New_TakeTrash" call A3PL_Localize),
                    2,
                    0.05,
                    "RobotoCondensedBold",
                    "center",
                    true
                ];
            }];
            [("STR_A3PL_Player_New_Step25" call A3PL_Localize)] call A3PL_Notifications_Tutorial;
            waitUntil {(inputAction "Action" > 0) && (player_nameintersect == "lid")};
            sleep 1;
            removeMissionEventHandler ["Draw3D",pickupBin];

            [("STR_A3PL_Player_New_Step26" call A3PL_Localize)] call A3PL_Notifications_Tutorial;
            binController = addMissionEventHandler ["Draw3D", {
                private _binController = jobVehicle selectionPosition ["bin_controller1","Memory"];
                pos = jobVehicle modelToWorldVisual _binController;
                drawIcon3D [
                    "A3FL_Props\icons\trash_ca.paa",
                    [1,0,0,1],
                    pos,
                    1,
                    1,
                    0,
                    ("STR_A3PL_Player_New_EmptyTrash" call A3PL_Localize),
                    2,
                    0.05,
                    "RobotoCondensedBold",
                    "center",
                    true
                ];
            }];
            waitUntil {(inputAction "Action" > 0) && (player_nameintersect == "bin_controller1")};
            sleep 1;
            removeMissionEventHandler ["Draw3D",binController];

            dischargeBin = addMissionEventHandler ["Draw3D", {
                obj = (nearestObjects [player, ["A3PL_WheelieBin"], 10]) select 0;
                private _dischargeBin = obj selectionPosition ["lid","Memory"];
                pos = obj modelToWorldVisual _dischargeBin;
                drawIcon3D [
                    "A3FL_Props\icons\trash_ca.paa",
                    [1,0,0,1],
                    pos,
                    1,
                    1,
                    0,
                    ("STR_A3PL_Player_New_RemoveTrash" call A3PL_Localize),
                    2,
                    0.05,
                    "RobotoCondensedBold",
                    "center",
                    true
                ];
            }];
            [("STR_A3PL_Player_New_Step27" call A3PL_Localize)] call A3PL_Notifications_Tutorial;
            waitUntil {(inputAction "Action" > 0) && (player_nameintersect == "lid")};
            sleep 1;
            removeMissionEventHandler ["Draw3D",dischargeBin];

        
            [("STR_A3PL_Player_New_Step28" call A3PL_Localize)] call A3PL_Notifications_Tutorial;
            waitUntil {(Player_Paycheck > 999);};
            sleep 1;

            finalMission = addMissionEventHandler ["Draw3D", {
                drawIcon3D [
                    "A3FL_Props\icons\trash_ca.paa",
                    [1,0,0,1],
                    [6184.24,7625.72,0],
                    1,
                    1,
                    0,
                    ("STR_A3PL_Player_New_DischargePoint" call A3PL_Localize),
                    2,
                    0.05,
                    "RobotoCondensedBold",
                    "center",
                    true
                ];
            }];
            [("STR_A3PL_Player_New_Step29" call A3PL_Localize)] call A3PL_Notifications_Tutorial;
            waitUntil {(player inArea [[6184.24,7625.72,0],25,25,0,false]);};
            sleep 1;
            removeMissionEventHandler ["Draw3D",finalMission];

            dischargeTruck = addMissionEventHandler ["Draw3D", {
                private _dischargeTruck = jobVehicle selectionPosition ["bin_controller1","Memory"];
                pos = jobVehicle modelToWorldVisual _dischargeTruck;
                drawIcon3D [
                    "A3FL_Props\icons\trash_ca.paa",
                    [1,0,0,1],
                    pos,
                    1,
                    1,
                    0,
                    ("STR_A3PL_Player_New_EmptyTruck" call A3PL_Localize),
                    2,
                    0.05,
                    "RobotoCondensedBold",
                    "center",
                    true
                ];
            }];
            [("STR_A3PL_Player_New_Step30" call A3PL_Localize)] call A3PL_Notifications_Tutorial;
            waitUntil {player_nameintersect == "bin_controller1"};
            sleep 1;
            removeMissionEventHandler ["Draw3D",dischargeTruck];



            private _NPC = NPC_WasteManagement selectionPosition ["spine3","Memory"];
            pos = NPC_WasteManagement modelToWorldVisual _NPC;
            endID = addMissionEventHandler ["Draw3D", {
                drawIcon3D [
                    "\A3\ui_f\data\IGUI\Cfg\Actions\talk_ca.paa",
                    [1,0,0,1],
                    pos,
                    1,
                    1,
                    0,
                    ("STR_A3PL_Player_New_StopJob" call A3PL_Localize),
                    2,
                    0.05,
                    "RobotoCondensedBold",
                    "center",
                    true
                ];
            }];
            [("STR_A3PL_Player_New_Step31" call A3PL_Localize)] call A3PL_Notifications_Tutorial;
            waitUntil {player_nameintersect == "spine3"};
            sleep 1;
            removeMissionEventHandler ["Draw3D",endID];
        };

        jobCenterMan = position npc_jobcenter;
        jobCenterID = addMissionEventHandler ["Draw3D", {
            drawIcon3D [
                "\A3\ui_f\data\IGUI\Cfg\Actions\talk_ca.paa",
                [1,0,0,1],
                jobCenterMan,
                1,
                1,
                0,
                format[("STR_A3PL_Player_New_JobCenterPositioin" call A3PL_Localize),floor(player distance jobCenterMan)],
                2,
                0.05,
                "RobotoCondensedBold",
                "center",
                true
            ];
        }];
        [("STR_A3PL_Player_New_Step32" call A3PL_Localize)] call A3PL_Notifications_Tutorial;
        waitUntil {(player inArea [jobCenterMan,25,25,0,false]);};
        sleep 1;
        waitUntil {((player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) IsEqualTo ("STR_Common_Job_Unemployed" call A3PL_Localize))};
        sleep 1;
        removeMissionEventHandler ["Draw3D",jobCenterID];
        sleep 3;
       
        Player_Hunger = 30;
        player setVariable ["player_hunger",Player_Hunger,false];
        Player_Thirst = 30;
        player setVariable ["player_thirst",Player_Thirst,false];

        [("STR_A3PL_Player_New_Step33" call A3PL_Localize)] call A3PL_Notifications_Tutorial;
        waitUntil {((Player_Hunger > 30) || (Player_Thirst > 30))};

        Player_Hunger = 100;
        player setVariable ["player_hunger",Player_Hunger,false];
        Player_Thirst = 100;
        player setVariable ["player_thirst",Player_Thirst,false];

        sleep 10;

        bankNPC = position npc_bank_2;
        BankID = addMissionEventHandler ["Draw3D", {
            drawIcon3D [
                "A3FL_Props\icons\money_ca.paa",
                [1,0,0,1],
                bankNPC,
                1,
                1,
                0,
                format[("STR_A3PL_Player_New_Bank" call A3PL_Localize),floor(player distance bankNPC)],
                2,
                0.05,
                "RobotoCondensedBold",
                "center",
                true
            ];
        }];

        [("STR_A3PL_Player_New_Step34" call A3PL_Localize)] call A3PL_Notifications_Tutorial;
        waitUntil {(player inArea [bankNPC,20,20,0,false]);};
        sleep 1;
        removeMissionEventHandler ["Draw3D",BankID];

        [("STR_A3PL_Player_New_Step35" call A3PL_Localize)] call A3PL_Notifications_Tutorial;
        private _hasBankAccount = [player,1] call A3PL_Bank_HasAccount;
        private _currentMoney = player getVariable["Player_Bank",0];
        waitUntil {((_hasBankAccount) && (Player_Paycheck isEqualTo 0))};

        sleep 3;
        [("STR_A3PL_Player_New_Step36" call A3PL_Localize)] call A3PL_Notifications_Tutorial;
        sleep 10;
        [("STR_A3PL_Player_New_Step37" call A3PL_Localize)] call A3PL_Notifications_Tutorial;
        sleep 20;
        Player_StartTutorial = 1;
        profileNamespace setVariable ["Player_StartTutorial",Player_StartTutorial];
        player setVariable["new",false,true];
    };
}] call compile_Global;