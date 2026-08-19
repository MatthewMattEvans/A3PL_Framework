/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
#include "\a3\editor_f\Data\Scripts\dikCodes.h"

["A3PL_EventHandlers_Setup",
{
	waitUntil {!isnull (findDisplay 46)};
	(findDisplay 46) displayAddEventHandler ["KeyDown", {_this call A3PL_EventHandlers_HandleDown;}];
	(findDisplay 46) displayAddEventHandler ["KeyUp", {_this call A3PL_EventHandlers_HandleUp;}];
	player addEventHandler ["InventoryOpened", {_this call A3PL_Prevent_Patdown_Cloning;}];

	[format["A3PL : %1","STR_A3PL_EventHandlers_General" call A3PL_Localize],"interaction_key", "STR_A3PL_EventHandlers_InteractionMenu" call A3PL_Localize,
	{
		if(!(player getVariable["A3PL_Medical_Alive",true])) exitWith {};
		if (!isNil "A3PL_Interaction_KeyDown") exitwith {};
		A3PL_Interaction_KeyDown = true;
		if(alive player) then {
			[player_objintersect] call A3PL_Interaction_loadInteraction;
		};
	},

	{
		if(player getVariable ["Incapacitated",false]) exitWith {};
		if (!isNil "A3PL_Interaction_KeyDown") then {
			A3PL_Interaction_KeyDown = Nil;
		};
		if (!isNull (findDisplay 1000)) then
		{
			(findDisplay 1000) closeDisplay 0;
		};
		true;
	}, [DIK_TAB, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_General" call A3PL_Localize],"action_key", "STR_A3PL_EventHandlers_Action" call A3PL_Localize,
	{
		call A3PL_Interaction_ActionKey;
	}, "", [DIK_SPACE, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_General" call A3PL_Localize],"phone_key", "STR_A3PL_EventHandlers_OpenPhone" call A3PL_Localize,
	{
		if(Player_ActionDoing) exitWith {};
		if((player getVariable["Zipped",false]) || (player getVariable["Cuffed",false])) exitWith{};
		player setVariable ["inventory_opened", nil, true];
		if (animationState player in ["A3PL_TakenHostage","A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitwith {["STR_Common_HandcuffedError" call A3PL_Localize,Color_Red] call A3PL_Notification;};
		private _radio = call TFAR_fnc_activeSwRadio;
		switch (true) do {
			case ([_radio,"a3pl_3310_1"] call TFAR_fnc_isSameRadio): {
                if (currentWeapon player isEqualTo "") then {
                    [] spawn A3PL_Phone_menuNokia;
                } else {
                    ["STR_Common_HandsFull" call A3PL_Localize,Color_Red] call A3PL_Notification;
                };
            };
			case ([_radio,"a3pl_iphone_1"] call TFAR_fnc_isSameRadio): {
				if (currentWeapon player isEqualTo "") then {
					[] spawn A3PL_Phone_menuiphone;
				} else {
					["STR_Common_HandsFull" call A3PL_Localize,Color_Red] call A3PL_Notification;
				};
			};
			case ([_radio,"a3pl_sonySD_1"] call TFAR_fnc_isSameRadio): {
                if (currentWeapon player isEqualTo "") then {
                    [] spawn A3PL_Phone_menuSony;
                } else {
                    ["STR_Common_HandsFull" call A3PL_Localize,Color_Red] call A3PL_Notification;
                };
            };
			case ([_radio,"a3pl_sonyFD_1"] call TFAR_fnc_isSameRadio): {
                if (currentWeapon player isEqualTo "") then {
                    [] spawn A3PL_Phone_menuSonyP;
                } else {
                    ["STR_Common_HandsFull" call A3PL_Localize,Color_Red] call A3PL_Notification;
                };
            };
			case ([_radio,"a3pl_sonyDOJ_1"] call TFAR_fnc_isSameRadio): {
                if (currentWeapon player isEqualTo "") then {
                    [] spawn A3PL_Phone_menuSonyDOJ;
                } else {
                    ["STR_Common_HandsFull" call A3PL_Localize,Color_Red] call A3PL_Notification;
                };
            };
		};
	}, "", [DIK_G, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_General" call A3PL_Localize],"cancel_key", "STR_A3PL_EventHandlers_CancelAction" call A3PL_Localize,
	{
		if ((vehicle player) isNotEqualTo player) exitWith {};
		if ((player getVariable["Zipped",false]) || {player getVariable["Cuffed",false]}) exitWith{};
		if (((animationState player) IN ["AinvPknlMstpSnonWnonDr_medic0","ainvpknlmstpsnonwnondnon_ainvpknlmstpsnonwnondnon_medic","amovpercmstpsraswpstdnon_ainvpknlmstpsnonwnondnon","amovpercmstpsraswpstdnon_ainvpknlmstpsnonwnondnon_end"]) && Player_LockView) exitWith{["STR_A3PL_EventHandlers_CancelActionFail" call A3PL_Localize,Color_Red] call A3PL_Notification;};
		if (Player_ActionDoing) then {Player_ActionInterrupted=true;};
		if (animationState player IN ["amovpknlmstpsraswpstdnon","amovpknlmstpsnonwnondnon","amovpknlmstpsraswrfldnon","amovppnemstpsraswrfldnon","amovppnemstpsraswpstdnon","amovppnemstpsoptwbindnon","amovpknlmstpsoptwbindnon","amovppnemstpsnonwnondnon","unconscious","unconsciousoutprone","unconsciousoutend"]) exitWith{};
		if ((animationState player) isEqualTo "amovpercmstpsnonwnondnon") then {
			player playAction "gesture_stop";
		} else {
			[player, ""] remoteExec ["A3PL_Lib_SyncAnim",0];
		};
	}, "", [DIK_P, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_General" call A3PL_Localize],"medical_menu", "STR_A3PL_EventHandlers_OpenMedicalMenu" call A3PL_Localize,
	{
		if (!isNull (findDisplay 73)) exitWith {(findDisplay 73) closeDisplay 0;};
		if (underwater(vehicle player)) exitWith {};
		[player] spawn A3PL_Medical_Open;
	}, "", [DIK_COMMA, [true, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_General" call A3PL_Localize],"e_inventory", "STR_A3PL_EventHandlers_OpenVirtualInventory" call A3PL_Localize,
	{
		if((player getVariable["Zipped",false]) || (player getVariable["Cuffed",false])) exitWith{};
		if (underwater(vehicle player)) exitWith {};
		if(vehicle player isEqualTo player) then {
			if (!isNull (findDisplay 1001)) exitWith {(findDisplay 1001) closeDisplay 0;};
			call A3PL_Inventory_Open;
		} else {
			_veh = vehicle player;
			if ((_veh getVariable["locked",true])) exitWith {["STR_A3PL_EventHandlers_OpenLockedVehicleInventory" call A3PL_Localize,Color_Red] call A3PL_Notification;};
			if(isNull _veh || {isNil '_veh'}) exitWith {};
			if([typeOf (_veh)] call A3PL_Config_HasStorage) then {
				[_veh] call A3PL_Vehicle_OpenStorage;
			};
		};
	}, "", [DIK_Y, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_General" call A3PL_Localize],"settingsmenu", "STR_A3PL_EventHandlers_OpenGlobalSettings" call A3PL_Localize,
	{
		[] spawn A3PL_Player_ParamMenu;
	}, "", [DIK_F7, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_General" call A3PL_Localize],"filesmanager", "STR_A3PL_EventHandlers_OpenFilesManager" call A3PL_Localize,
	{
		private _job = player getVariable ["job","STR_Common_Job_Unemployed" call A3PL_Localize];
		if (_job isEqualTo ("STR_Common_Company" call A3PL_Localize)) then {
			[] spawn A3PL_FilesManager_Computer;
		};
	}, "", [DIK_F6, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_General" call A3PL_Localize],"ear_plug", "STR_A3PL_EventHandlers_EarPlugs" call A3PL_Localize,
	{
		if (soundVolume isEqualTo 0) then {
			0 fadeSound 1;
		} else {
			0 fadeSound (soundVolume - 0.1);
		};
		private _vol = round(soundVolume * 100);
		[format["STR_A3PL_EventHandlers_EarPlugsVolume" call A3PL_Localize,_vol,'%'],Color_Yellow] call A3PL_Notification;
	}, "", [DIK_O, [true, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_General" call A3PL_Localize],"holster_gun", "STR_A3PL_EventHandlers_HolsterUnholster" call A3PL_Localize,
	{
		if((player getVariable["Zipped",false]) || (player getVariable["Cuffed",false])) exitWith{};
		if ((currentWeapon player) isNotEqualTo "") exitWith {
			A3PL_Holster = currentWeapon player;
			player action ["SwitchWeapon", player, player, -1];
			true;
		};
		if(A3PL_Holster isNotEqualTo "") exitWith {
			player selectWeapon A3PL_Holster;
			A3PL_Holster = "";
			true;
		};
	}, "", [DIK_H, [true, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_General" call A3PL_Localize],"anim_wheel", "STR_A3PL_EventHandlers_AnimationWheel" call A3PL_Localize,
	{
		if (!(player getVariable["A3PL_Medical_Alive",true]) || {player getVariable ["Cuffed",false]} || {player getVariable ["Zipped",false]}) exitWith {};
		if (!isNil "A3FL_Animation_KeyDown") exitwith {};
		if (vehicle player isNotEqualTo player) exitWith {};
		if (Player_ActionDoing) exitWith {};
		A3FL_Animation_KeyDown = true;
		if(alive player) then {
			[] call A3FL_Animations_loadAnimCats;
		};
	},
	{
		if(player getVariable ["Incapacitated",false] || player getVariable ["Cuffed",false]) exitWith {};
		if (!isNil "A3FL_Animation_KeyDown") then {
			A3FL_Animation_KeyDown = Nil;
		};
		if (!isNull (findDisplay 7000)) then
		{
			(findDisplay 7000) closeDisplay 0;
		};
		true;
	}, [DIK_H, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_General" call A3PL_Localize],"lockunlock_key", "STR_A3PL_EventHandlers_LockUnlockVehicle" call A3PL_Localize,
	{
		_veh = objNull;
		if((vehicle player) isEqualTo player) then {
			_veh = cursorTarget;
		} else {
			_veh = vehicle player;
		};
		if(isNull _veh) exitWith {};
		if(!(_veh IN A3PL_Player_Vehicles)) exitWith {};
		if((player distance _veh) > 10) exitWith {};
		if(_veh getVariable ["locked",true]) then {
			_veh setVariable ["locked",false,true];
			["STR_Common_VehicleUnlocked" call A3PL_Localize,Color_Green] call A3PL_Notification;
			playSound3D ["A3PL_Common\effects\carunlock.ogg", _veh, true, _veh, 3, 1, 30];
		} else {
			_veh setVariable ["locked",true,true];
			["STR_Common_VehicleLocked" call A3PL_Localize,Color_Red] call A3PL_Notification;
			playSound3D ["A3PL_Cars\Common\Sounds\A3PL_Car_Lock.ogg", _veh, true, _veh, 3, 1, 30];
		};
	}, "", [DIK_U, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Vehicles" call A3PL_Localize],"trunk_key", "STR_A3PL_EventHandlers_OpenCloseTrunk" call A3PL_Localize,
	{
		if ((player getVariable ["Cuffed",false]) || (player getVariable ["Zipped",false]) || ((animationState player) == "a3pl_takenhostage")) exitwith {["STR_Common_HandcuffedError" call A3PL_Localize,Color_Red] call A3PL_Notification;};
		private _veh = if((vehicle player) isNotEqualTo player) then {vehicle player} else {cursorTarget};
		if (isNull _veh || {isNil '_veh'}) exitWith {};
		private _typeOf = typeOf _veh;
		if (!(_veh isKindOf "Car") && {_typeOf isNotEqualTo "A3PL_EMS_Locker" && {_typeOf isNotEqualTo "A3FL_TransportContainer"}}) exitWith {};
		if ((player distance _veh > 5)) exitWith {};
		if ((_veh getVariable["locked",true]) && {_typeOf isNotEqualTo "A3PL_EMS_Locker"}) exitWith {["STR_A3PL_EventHandlers_UnlockVehicleTrunk" call A3PL_Localize,Color_Red] call A3PL_Notification;};
		if ((_typeOf isEqualTo "A3PL_EMS_Locker") && {_veh getVariable["owner",""] isNotEqualTo (player getVariable ["character_id",""])}) exitWith {};
		if ((_veh getVariable ["goFast", false]) isEqualTo true && {(player getVariable ["job", "STR_Common_Job_Unemployed" call A3PL_Localize]) isNotEqualTo ("STR_Common_FISD" call A3PL_Localize)}) exitWith {["STR_A3PL_EventHandlers_GoFastTrunk" call A3PL_Localize,Color_Red] call A3PL_Notification;};
		if ([_typeOf] call A3PL_Config_HasStorage) then {
			[_veh] call A3PL_Vehicle_OpenStorage;
		};
	}, "", [DIK_T, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Vehicles" call A3PL_Localize],"exit_vehicle", "STR_A3PL_EventHandlers_ExitVehicle" call A3PL_Localize,
	{
		private _veh = vehicle player;
		if !(_veh isKindOf "Car") exitWith {};
		if ((player getVariable ["Cuffed",false]) || (player getVariable ["Zipped",false]) || ((animationState player) == "a3pl_takenhostage")) exitwith {["STR_Common_HandcuffedError" call A3PL_Localize,Color_Red] call A3PL_Notification;};
		private _seatbelt = player getVariable ["SeatbeltOn",false];
		private _locked = (vehicle player) getVariable ["locked",true];
		if (_seatbelt) exitWith {["STR_Common_SeatbeltRemoveFirst" call A3PL_Localize,Color_Red] call A3PL_Notification;};
		if (_locked) exitWith {["STR_A3PL_EventHandlers_UnlockVehicleToExit" call A3PL_Localize,Color_Red] call A3PL_Notification;};
		if (((speed vehicle player) < 1) && (vehicle player getVariable ["EngineOn",0] isEqualTo 0)) then {
			player action ["GetOut", (vehicle player)];
			[] spawn {if ((player getVariable ["Cuffed",false]) || {player getVariable ["Zipped",false]}) then {sleep 1.5;player setVelocityModelSpace [0,3,1];[player,"a3pl_handsupkneelcuffed"] remoteExec ["A3PL_Lib_SyncAnim",-2];};};
		} else {
			player action ["eject", (vehicle player)];
			[] spawn {if ((player getVariable ["Cuffed",false]) || {player getVariable ["Zipped",false]}) then {sleep 1.5;player setVelocityModelSpace [0,3,1];[player,"a3pl_handsupkneelcuffed"] remoteExec ["A3PL_Lib_SyncAnim",-2];};};
		};
	}, "", [DIK_V, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Vehicles" call A3PL_Localize],"seat_belt", "STR_A3PL_EventHandlers_SeatbeltToggle" call A3PL_Localize,
	{
		if ((vehicle player isNotEqualTo player) && {player getVariable ["SeatbeltOn",false]} && {typeOf(vehicle player) isKindOf "Car"}) then {
			["STR_A3PL_EventHandlers_SeatbeltDetach" call A3PL_Localize,Color_Red] call A3PL_Notification;
			player setVariable ["SeatbeltOn",nil,true];
			playSound "unbuckle";
		} else {
			if ((vehicle player isNotEqualTo player) && {typeOf(vehicle player) isKindOf "Car"} && {!(typeOf (vehicle player) IN ["K_Scooter_DarkBlue","C_Quadbike_01_F","A3PL_Kx","A3PL_Fatboy","A3PL_Knucklehead","A3PL_1100R"])}) then {
				["STR_A3PL_EventHandlers_SeatbeltAttach" call A3PL_Localize,Color_Green] call A3PL_Notification;
				player setVariable ["SeatbeltOn",true,true];
				playSound "buckle";
			};
		};
		true;
	}, "", [DIK_B, [false, true, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Vehicles" call A3PL_Localize],"highbeams_key", "STR_A3PL_EventHandlers_HeadlightsToggle" call A3PL_Localize,
	{
		private _veh = vehicle player;
		if(!(_veh isKindOf "Car") && !((driver _veh) isEqualTo player)) exitWith {};
		if (_veh animationSourcePhase "High_Beam" < 0.5) then {
			_veh animateSource ["High_Beam",1];
		} else {
				_veh animateSource ["High_Beam",0];
		};
	}, "", [DIK_L, [true, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Vehicles" call A3PL_Localize],"enginekeep_key", "STR_A3PL_EventHandlers_KeepEngineRunning" call A3PL_Localize,
	{
		private _veh = vehicle player;
		if !(_veh isKindOf "Car") exitWith {};
		if((!((driver _veh) isEqualTo player)) || (vehicle player isEqualTo player)) exitWith {};
		if (_veh getVariable ["EngineOn",0] isEqualTo 0) then {
			_veh setVariable ["EngineOn",1,true];
			["STR_A3PL_EventHandlers_KeepEngineRunningON" call A3PL_Localize,Color_Green] call A3PL_Notification;
		} else {
			_veh setVariable ["EngineOn",0,true];
			["STR_A3PL_EventHandlers_KeepEngineRunningOFF" call A3PL_Localize,Color_Red] call A3PL_Notification;
		};
	}, "", [DIK_INSERT, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Vehicles" call A3PL_Localize],"enginelights_key", "STR_A3PL_EventHandlers_LightsToggle" call A3PL_Localize,
	{
		private _veh = vehicle player;
		if !(_veh isKindOf "Car") exitWith {};
		if((!((driver _veh) isEqualTo player)) || (vehicle player isEqualTo player)) exitWith {};
		if (isLightOn _veh) then {
			player action ["lightOff",_veh];
			_veh animateSource ["Head_Lights",0];

			private _trailerArray = nearestObjects [(_veh modelToWorld [0,-4,0]), ["A3PL_Trailer_Base"], 6.5];
			_trailerArray = _trailerArray select 0;
			if (!isNil "_trailerArray") then {_trailerArray animate ["Tail_Lights",0];};
		} else {
			player action ["lightOn",_veh];
			_veh animateSource ["Head_Lights",3000];
			private _trailerArray = nearestObjects [(_veh modelToWorld [0,-4,0]), ["A3PL_Trailer_Base"], 6.5];
			_trailerArray = _trailerArray select 0;
			if (!isNil "_trailerArray") then
			{
				_trailerArray animate ["Tail_Lights",1];
			};
		};
	}, "", [DIK_L, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Vehicles" call A3PL_Localize],"cruisectrl_key", "STR_A3PL_EventHandlers_CruiseControlToggle" call A3PL_Localize,
	{
		private _veh = vehicle player;
		if ((_veh isKindOf "Car") || (_veh isKindOf "Ship")) then {
			if((!((driver _veh) isEqualTo player)) || (vehicle player isEqualTo player)) exitWith {};
			private _currSpeed = speed _veh;
			_veh setCruiseControl [_currSpeed, true];
		};
	}, "", [DIK_C, [false, true, false]]] call CBA_fnc_addKeybind;
	
	[format["A3PL : %1","STR_A3PL_EventHandlers_Vehicles" call A3PL_Localize],"nvg_key", "STR_A3PL_EventHandlers_NVGToggle" call A3PL_Localize,
	{
		private _helis = ["A3PL_Jayhawk","A3FL_AS_365","A3FL_AS350_CIV","Heli_Medium01_H","Heli_Medium01_Luxury_H","Heli_Medium01_Medic_H","Heli_Medium01_Military_H","Heli_Medium01_Veteran_H","Heli_Medium01_Coastguard_H","A3FL_M_900_Base_F"];
		private _vehWhitelist = ["C_Plane_Civil_01_racing_F","C_Plane_Civil_01_F","A3PL_Cessna172","A3PL_Goose_Base","A3PL_Goose_USCG","A3FL_LCM","A3PL_Yacht","A3PL_RHIB","A3PL_Motorboat","A3PL_RBM","C_Scooter_Transport_01_F"];
		_vehWhitelist append _helis;
		private _veh = vehicle player;
		if (typeOf _veh IN _vehWhitelist) then {
			if(vehicle player isEqualTo player) exitWith {};
			if ((driver _veh isNotEqualTo player) && ((typeOf _veh IN _helis) && (currentPilot _veh isNotEqualTo player))) exitWith {};
			if (!(player getVariable["NVGsOn",false])) then {
				player action ["nvGoggles",player];
				["STR_A3PL_EventHandlers_NVGOn" call A3PL_Localize,Color_Yellow] call A3PL_Notification;
				player setVariable ["NVGsOn",true,true];
			} else {
				player action ["nvGogglesOff",player];
				["STR_A3PL_EventHandlers_NVGOff" call A3PL_Localize,Color_Yellow] call A3PL_Notification;
				player setVariable ["NVGsOn",nil,true];
			};
		};
	}, "", [DIK_N, [false, true, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Factions" call A3PL_Localize],"bargates_key", "STR_A3PL_EventHandlers_BarriersToggle" call A3PL_Localize,
	{
		if (player isEqualTo (vehicle player)) exitWith {};
		if (player isNotEqualTo (driver vehicle player)) exitWith {};
		call A3PL_Police_Bargate;
	}, "", [DIK_N, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Factions" call A3PL_Localize],"handonholster", "STR_A3PL_EventHandlers_HandsOnHolster" call A3PL_Localize,
	{
		private _job = player getVariable ["job","STR_Common_Job_Unemployed" call A3PL_Localize];
		if((vehicle player) isEqualTo player && (currentWeapon player isNotEqualTo "") && (_job IsEqualTo ("STR_Common_FISD" call A3PL_Localize)) && !(animationState player in ["A3PL_TakenHostage","A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"])) then {
			if((player getVariable["Zipped",false]) || (player getVariable["Cuffed",false]) || (player getVariable["isLockpicking",false])) exitWith{};
			if ((animationState player) != "Gesture_holster") then {
				[player, "Gesture_holster"] remoteExec ["A3PL_Lib_SyncAnim",0];
			} else {
				[player, ""] remoteExec ["A3PL_Lib_SyncAnim",0];
			};
			true;
		};
	}, "", [DIK_H, [false, true, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Factions" call A3PL_Localize],"openMDT", "STR_A3PL_EventHandlers_OpenMDT" call A3PL_Localize,
	{
		if (((player getVariable["job","STR_Common_Job_Unemployed" call A3PL_Localize]) IN ["STR_Common_FISD" call A3PL_Localize,"STR_Common_DOJ" call A3PL_Localize,"STR_Common_FIFR" call A3PL_Localize]) && {(typeOf(vehicle player) IN (Config_FISD_Vehs + Config_FIFR_Vehs)) || {(typeOf(vehicle player) IN ["A3FL_AS_365","A3PL_Jayhawk","Heli_Medium01_Medic_H","Heli_Medium01_Sheriff_H"])}}) then {
			if(typeOf (vehicle player) IN ["A3FL_T440_Water_Tanker","A3PL_Pierce_Pumper","A3PL_Pierce_Ladder","A3PL_Pierce_Heavy_Ladder","A3PL_Pierce_Rescue","A3PL_Jayhawk","A3FL_AS_365","A3PL_RBM","Heli_Medium01_Medic_H","Heli_Medium01_Sheriff_H"]) then {
				[vehicle player] call A3PL_Police_OpenMDT;
			} else {
				if (isNull (findDisplay 211) && {(((vehicle player) animationPhase "Laptop_Top") > 0.5) || {typeOf (vehicle player) isEqualTo "A3PL_RBM"}}) then {
					[vehicle player] call A3PL_Police_OpenMDT;
				};
			};
		};
	}, "", [DIK_K, [false, true, false]]] call CBA_fnc_addKeybind;

	/*[format["A3PL : %1","STR_A3PL_EventHandlers_Factions" call A3PL_Localize],"taserSwap", "STR_A3PL_EventHandlers_SwapWeapon" call A3PL_Localize,
	{
		if((vehicle player) isEqualTo player && (currentWeapon player isNotEqualTo "")&& !(animationState player in ["A3PL_TakenHostage","A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"])) then {
			if((player getVariable["Zipped",false]) || (player getVariable["Cuffed",false]) || (player getVariable["isLockpicking",false])) exitWith{};
			[] spawn A3PL_Lib_WeaponSwap;
			true;
		};
	}, "", [DIK_4, [false, true, false]]] call CBA_fnc_addKeybind;*/

	[format["A3PL : %1","STR_A3PL_EventHandlers_Factions" call A3PL_Localize],"megaphone", "STR_A3PL_EventHandlers_MegaphoneToggle" call A3PL_Localize,
	{
		if (vehicle player != player && {typeOf (vehicle player) in (Config_FISD_Vehs + Config_FIFR_Vehs)}) then {
			[] call A3PL_Vehicle_setVehSpeaker;
		};
	}, "", [DIK_Y, [false, true, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Factions" call A3PL_Localize],"siren_1", "STR_A3PL_EventHandlers_Code1" call A3PL_Localize,
	{
		if !(typeOf(vehicle player) IN (Config_FISD_Vehs + Config_FIFR_Vehs + Config_ML_Vehs)) exitWith {};
		[1] call A3PL_Vehicle_SirenHotkey;
		true;
	}, "", [DIK_1, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Factions" call A3PL_Localize],"siren_2", "STR_A3PL_EventHandlers_Code2" call A3PL_Localize,
	{
		if !(typeOf(vehicle player) IN (Config_FISD_Vehs + Config_FIFR_Vehs + Config_ML_Vehs)) exitWith {};
		[2] call A3PL_Vehicle_SirenHotkey;
		true;
	}, "", [DIK_2, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Factions" call A3PL_Localize],"siren_3", "STR_A3PL_EventHandlers_Code3" call A3PL_Localize,
	{
		if !(typeOf(vehicle player) IN (Config_FISD_Vehs + Config_FIFR_Vehs)) exitWith {};
		[3] call A3PL_Vehicle_SirenHotkey;
		true;
	}, "", [DIK_3, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Factions" call A3PL_Localize],"siren_4", "STR_A3PL_EventHandlers_SirenAux1" call A3PL_Localize,
	{
		if !(typeOf(vehicle player) IN (Config_FISD_Vehs + Config_FIFR_Vehs)) exitWith {};
		[4] call A3PL_Vehicle_SirenHotkey;
		true;
	}, "", [DIK_4, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Factions" call A3PL_Localize],"siren_5", "STR_A3PL_EventHandlers_SirenAux2" call A3PL_Localize,
	{
		if !(typeOf(vehicle player) IN (Config_FISD_Vehs + Config_FIFR_Vehs)) exitWith {};
		[5] call A3PL_Vehicle_SirenHotkey;
		A3PL_Manual_KeyDown = true;
		true;
	},
	{
		if !(typeOf(vehicle player) IN (Config_FISD_Vehs + Config_FIFR_Vehs)) exitWith {};
		[5] call A3PL_Vehicle_SirenHotkey;
		A3PL_Manual_KeyDown = false;
		true;
	}, [DIK_5, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Factions" call A3PL_Localize],"siren_6", "STR_A3PL_EventHandlers_SirenAux3" call A3PL_Localize,
	{
		if !(typeOf(vehicle player) IN (Config_FISD_Vehs + Config_FIFR_Vehs)) exitWith {};
		[6] call A3PL_Vehicle_SirenHotkey;
		A3PL_Manual_KeyDown = true;
		true;
	},
	{
		if !(typeOf(vehicle player) IN (Config_FISD_Vehs + Config_FIFR_Vehs)) exitWith {};
		[6] call A3PL_Vehicle_SirenHotkey;
		A3PL_Manual_KeyDown = false;
		true;
	},  [DIK_6, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Factions" call A3PL_Localize],"siren_7", "STR_A3PL_EventHandlers_SirenAux4" call A3PL_Localize,
	{
		if !(typeOf(vehicle player) IN (Config_FISD_Vehs + Config_FIFR_Vehs)) exitWith {};
		[7] call A3PL_Vehicle_SirenHotkey;
		A3PL_Manual_KeyDown = true;
		true;
	},
	{
		if !(typeOf(vehicle player) IN (Config_FISD_Vehs + Config_FIFR_Vehs)) exitWith {};
		[7] call A3PL_Vehicle_SirenHotkey;
		A3PL_Manual_KeyDown = false;
		true;
	},  [DIK_7, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Animations" call A3PL_Localize],"surrender", "STR_A3PL_EventHandlers_HandsBehindHead" call A3PL_Localize,
	{
		if((player getVariable["Zipped",false]) || (player getVariable["Cuffed",false])) exitWith{};
		if(((getPosATL player) select 2) > 1) exitWith {};
		if((speed player) > 0) exitWith {};
		if((vehicle player) isEqualTo player) then {[player,true] call A3PL_Police_Surrender;};
	}, "", [DIK_B, [true, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Combat" call A3PL_Localize],"tackle", "STR_A3PL_EventHandlers_Tackle" call A3PL_Localize,
	{
		if ((player getVariable["Zipped",false]) || (player getVariable["Cuffed",false]) || (player getVariable["dragging",false])) exitWith {};
		if (!isNull cursorObject && {cursorObject isKindOf "CAManBase"} && {isPlayer cursorObject} && {(cursorObject distance player) < 1.25} && {(speed cursorObject) < 1}) then {
			if (((animationState cursorObject) != "Incapacitated") && {currentWeapon player != ""} && {isNil "A3PL_Tackle"} && {isNil "A3PL_Tackled"}) then {
				[cursorObject] spawn A3PL_Player_Tackle;
			};
		};
	}, "", [DIK_G, [true, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Animations" call A3PL_Localize],"animation_1", "STR_A3PL_EventHandlers_Emote_Hi" call A3PL_Localize,
	{
		if((vehicle player) isEqualTo player && !(animationState player in ["A3PL_TakenHostage","A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) && !Player_ActionDoing && !(damage player > 0.4)) then {
			if((player getVariable["Zipped",false]) || (player getVariable["Cuffed",false]) || (player getVariable["isLockpicking",false])) exitWith{};
			player playAction "Gesture_wave";
			true;
		};
	}, "", [DIK_1, [false, false, true]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Animations" call A3PL_Localize],"animation_2", "STR_A3PL_EventHandlers_Emote_Finger" call A3PL_Localize,
	{
		if((vehicle player) isEqualTo player && !(animationState player in ["A3PL_TakenHostage","A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) && !Player_ActionDoing && !(damage player > 0.4)) then {
			if((player getVariable["Zipped",false]) || (player getVariable["Cuffed",false]) || (player getVariable["isLockpicking",false])) exitWith{};
			player playAction "Gesture_finger";
			true;
		};
	}, "", [DIK_2, [false, false, true]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Animations" call A3PL_Localize],"animation_3", "STR_A3PL_EventHandlers_Emote_ISeeYou" call A3PL_Localize,
	{
		if((vehicle player) isEqualTo player && !(animationState player in ["A3PL_TakenHostage","A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) && !Player_ActionDoing && !(damage player > 0.4)) then {
			if((player getVariable["Zipped",false]) || (player getVariable["Cuffed",false]) || (player getVariable["isLockpicking",false])) exitWith{};
			player playAction "Gesture_watching";
			true;
		};
	}, "", [DIK_3, [false, false, true]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Animations" call A3PL_Localize],"animation_4", "STR_A3PL_EventHandlers_Emote_Dance1" call A3PL_Localize,
	{
		if((vehicle player) isEqualTo player && !(animationState player in ["A3PL_TakenHostage","A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) && !Player_ActionDoing && !(damage player > 0.4)) then {
			if((player getVariable["Zipped",false]) || (player getVariable["Cuffed",false]) || (player getVariable["isLockpicking",false])) exitWith{};
			if ((animationState player) != "A3PL_Dance_House1") then {
				[player, "A3PL_Dance_House1"] remoteExec ["A3PL_Lib_SyncAnim",0];
			} else {
				[player, ""] remoteExec ["A3PL_Lib_SyncAnim",0];
			};
			true;
		};
	}, "", [DIK_4, [false, false, true]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Animations" call A3PL_Localize],"animation_5", "STR_A3PL_EventHandlers_Emote_Dance2" call A3PL_Localize,
	{
		if((vehicle player) isEqualTo player && !(animationState player in ["A3PL_TakenHostage","A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) && !Player_ActionDoing && !(damage player > 0.4)) then {
			if((player getVariable["Zipped",false]) || (player getVariable["Cuffed",false]) || (player getVariable["isLockpicking",false])) exitWith{};
			if ((animationState player) != "A3PL_Dance_Samba") then {
				[player, "A3PL_Dance_Samba"] remoteExec ["A3PL_Lib_SyncAnim",0];
			} else {
				[player, ""] remoteExec ["A3PL_Lib_SyncAnim",0];
			};
			true;
		};
	}, "", [DIK_5, [false, false, true]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Animations" call A3PL_Localize],"animation_6", "STR_A3PL_EventHandlers_Emote_Dab" call A3PL_Localize,
	{
		if((vehicle player) isEqualTo player && !(animationState player in ["A3PL_TakenHostage","A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) && !Player_ActionDoing && !(damage player > 0.4)) then {
			if((player getVariable["Zipped",false]) || (player getVariable["Cuffed",false]) || (player getVariable["isLockpicking",false])) exitWith{};
			player playAction "gesture_dab";
			true;
		};
	}, "", [DIK_6, [false, false, true]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Animations" call A3PL_Localize],"animation_7", "STR_A3PL_EventHandlers_Emote_NarutoRun" call A3PL_Localize,
	{
		if((vehicle player) isEqualTo player && !(animationState player in ["A3PL_TakenHostage","A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) && !Player_ActionDoing && !(damage player > 0.4)) then {
			if((player getVariable["Zipped",false]) || (player getVariable["Cuffed",false]) || (player getVariable["isLockpicking",false])) exitWith{};
			player playAction "Foski_StopNarutoRun";
			true;
		};
	}, "", [DIK_7, [false, false, true]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Animations" call A3PL_Localize],"animation_8", "STR_A3PL_EventHandlers_Emote_Dance3" call A3PL_Localize,
	{
		if((vehicle player) isEqualTo player && !(animationState player in ["A3PL_TakenHostage","A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) && !Player_ActionDoing && !(damage player > 0.4)) then {
			if((player getVariable["Zipped",false]) || (player getVariable["Cuffed",false]) || (player getVariable["isLockpicking",false])) exitWith{};
			if ((animationState player) != "Acts_Dance_01") then {
				[player, "Acts_Dance_01"] remoteExec ["A3PL_Lib_SyncAnim",0];
			} else {
				[player, ""] remoteExec ["A3PL_Lib_SyncAnim",0];
			};
			true;
		};
	}, "", [DIK_8, [false, false, true]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Animations" call A3PL_Localize],"animation_9", "STR_A3PL_EventHandlers_Emote_Dance4" call A3PL_Localize,
	{
		if((vehicle player) isEqualTo player && !(animationState player in ["A3PL_TakenHostage","A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) && !Player_ActionDoing && !(damage player > 0.4)) then {
			if((player getVariable["Zipped",false]) || (player getVariable["Cuffed",false]) || (player getVariable["isLockpicking",false])) exitWith{};
			if ((animationState player) != "Acts_Dance_02") then {
				[player, "Acts_Dance_02"] remoteExec ["A3PL_Lib_SyncAnim",0];
			} else {
				[player, ""] remoteExec ["A3PL_Lib_SyncAnim",0];
			};
			true;
		};
	}, "", [DIK_9, [false, false, true]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Combat" call A3PL_Localize],"punch_1", format["(%1) %2","STR_Common_Punch" call A3PL_Localize,"STR_A3PL_EventHandlers_Combat_LeftHeavyHook" call A3PL_Localize],
	{
		if((vehicle player) isEqualTo player && !(animationState player in ["A3PL_TakenHostage","A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) && !(damage player > 0.4)) then {
			if((player getVariable["Zipped",false]) || (player getVariable["Cuffed",false]) || (player getVariable["isLockpicking",false])) exitWith{};
			["A3FL_anim_Punch1",1] spawn A3PL_Lib_ThrowPunch;
			true;
		};
	}, "", [DIK_1, [true, false, false]]] call CBA_fnc_addKeybind;
	
	[format["A3PL : %1","STR_A3PL_EventHandlers_Combat" call A3PL_Localize],"punch_2", format["(%1) %2","STR_Common_Punch" call A3PL_Localize,"STR_A3PL_EventHandlers_Combat_RightLowJab" call A3PL_Localize],
	{
		if((vehicle player) isEqualTo player && !(animationState player in ["A3PL_TakenHostage","A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) && !(damage player > 0.4)) then {
			if((player getVariable["Zipped",false]) || (player getVariable["Cuffed",false]) || (player getVariable["isLockpicking",false])) exitWith{};
			["A3FL_anim_Punch2",2] spawn A3PL_Lib_ThrowPunch;
			true;
		};
	}, "", [DIK_2, [true, false, false]]] call CBA_fnc_addKeybind;
	
	[format["A3PL : %1","STR_A3PL_EventHandlers_Combat" call A3PL_Localize],"punch_3", format["(%1) %2","STR_Common_Punch" call A3PL_Localize,"STR_A3PL_EventHandlers_Combat_RightHeavyHook" call A3PL_Localize],
	{
		if((vehicle player) isEqualTo player && !(animationState player in ["A3PL_TakenHostage","A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) && !(damage player > 0.4)) then {
			if((player getVariable["Zipped",false]) || (player getVariable["Cuffed",false]) || (player getVariable["isLockpicking",false])) exitWith{};
			["A3FL_anim_Punch3",3] spawn A3PL_Lib_ThrowPunch;
			true;
		};
	}, "", [DIK_3, [true, false, false]]] call CBA_fnc_addKeybind;
	
	[format["A3PL : %1","STR_A3PL_EventHandlers_Combat" call A3PL_Localize],"punch_4", format["(%1) %2","STR_Common_Punch" call A3PL_Localize,"STR_A3PL_EventHandlers_Combat_RightUppercut" call A3PL_Localize],
	{
		if((vehicle player) isEqualTo player && !(animationState player in ["A3PL_TakenHostage","A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) && !(damage player > 0.4)) then {
			if((player getVariable["Zipped",false]) || (player getVariable["Cuffed",false]) || (player getVariable["isLockpicking",false])) exitWith{};
			["A3FL_anim_Punch4",4] spawn A3PL_Lib_ThrowPunch;
			true;
		};
	}, "", [DIK_4, [true, false, false]]] call CBA_fnc_addKeybind;
	
	[format["A3PL : %1","STR_A3PL_EventHandlers_Combat" call A3PL_Localize],"punch_5", format["(%1) %2","STR_Common_Punch" call A3PL_Localize,"STR_A3PL_EventHandlers_Combat_RightJab" call A3PL_Localize],
	{
		if((vehicle player) isEqualTo player && !(animationState player in ["A3PL_TakenHostage","A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) && !(damage player > 0.4)) then {
			if((player getVariable["Zipped",false]) || (player getVariable["Cuffed",false]) || (player getVariable["isLockpicking",false])) exitWith{};
			["MOCAP_Man_Act_Non_CivPace_Non_Punch_Hand_Right_Direct",5] spawn A3PL_Lib_ThrowPunch;
			true;
		};
	}, "", [DIK_5, [true, false, false]]] call CBA_fnc_addKeybind;
	
	[format["A3PL : %1","STR_A3PL_EventHandlers_Combat" call A3PL_Localize],"punch_6", format["(%1) %2","STR_Common_Punch" call A3PL_Localize,"STR_A3PL_EventHandlers_Combat_LeftJab" call A3PL_Localize],
	{
		if((vehicle player) isEqualTo player && !(animationState player in ["A3PL_TakenHostage","A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) && !(damage player > 0.4)) then {
			if((player getVariable["Zipped",false]) || (player getVariable["Cuffed",false]) || (player getVariable["isLockpicking",false])) exitWith{};
			["MOCAP_Man_Act_Non_CivPace_Non_Punch_Hand_Left_Direct",6] spawn A3PL_Lib_ThrowPunch;
			true;
		};
	}, "", [DIK_6, [true, false, false]]] call CBA_fnc_addKeybind;
	
	[format["A3PL : %1","STR_A3PL_EventHandlers_Combat" call A3PL_Localize],"kick_1", format["(%1) %2","STR_Common_Kick" call A3PL_Localize,"STR_A3PL_EventHandlers_Combat_LeftKick" call A3PL_Localize],
	{
		if((vehicle player) isEqualTo player && !(animationState player in ["A3PL_TakenHostage","A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) && !(damage player > 0.4)) then {
			if((player getVariable["Zipped",false]) || (player getVariable["Cuffed",false]) || (player getVariable["isLockpicking",false])) exitWith{};
			["MOCAP_Man_Act_Idle_Stay_CivPace_Non_Push_Kick_LeftLeg",7] spawn A3PL_Lib_ThrowPunch;
			true;
		};
	}, "", [DIK_7, [true, false, false]]] call CBA_fnc_addKeybind;
	
	[format["A3PL : %1","STR_A3PL_EventHandlers_Combat" call A3PL_Localize],"punch_lclick", "STR_A3PL_EventHandlers_Combat_RandomKick" call A3PL_Localize,{call A3FL_Lib_PunchRandom}, "", [240, [true, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Excavator" call A3PL_Localize],"exca_1", format["%1 %2", "STR_A3PL_EventHandlers_Excavator_RotateCabin" call A3PL_Localize,"STR_Common_Left" call A3PL_Localize],
	{
		[vehicle player] spawn {
			private _veh = _this#0;
			if (typeOf(_veh) isNotEqualTo "A3PL_MiniExcavator") exitWith {};
			A3PL_Exacvator_Control = true;
			while {A3PL_Exacvator_Control} do {
				_val = _veh animationSourcePhase "Cabin";
				_valu = _val + 0.01;
				if (_valu >= 6.3) then {_valu = 6.3};
				_veh animateSource ["Cabin",_valu];
				sleep 0.05;
			};
		};
		true;
	},
	{
		A3PL_Exacvator_Control = false;
		true;
	}, [DIK_NUMPAD4, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Excavator" call A3PL_Localize],"exca_2", format["%1 %2", "STR_A3PL_EventHandlers_Excavator_RotateCabin" call A3PL_Localize,"STR_Common_Right" call A3PL_Localize],
	{
		[vehicle player] spawn {
			private _veh = _this#0;
			if (typeOf(_veh) isNotEqualTo "A3PL_MiniExcavator") exitWith {};
			A3PL_Exacvator_Control = true;
			while {A3PL_Exacvator_Control} do {
				_val = _veh animationSourcePhase "Cabin";
				_valu = _val - 0.01;
				if (_valu <= -6.3) then {_valu = -6.3};
				_veh animateSource ["Cabin",_valu];
				sleep 0.05;
			};
		};
		true;
	},
	{
		A3PL_Exacvator_Control = false;
		true;
	}, [DIK_NUMPAD6, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Excavator" call A3PL_Localize],"exca_3", "STR_A3PL_EventHandlers_Excavator_RaiseArm" call A3PL_Localize,
	{
		[vehicle player] spawn {
			private _veh = _this#0;
			if (typeOf(_veh) isNotEqualTo "A3PL_MiniExcavator") exitWith {};
			A3PL_Exacvator_Control = true;
			while {A3PL_Exacvator_Control} do {
				_val = _veh animationSourcePhase "arm";
				_valu = _val + 0.01;
				if (_valu >= 1) then {_valu = 1};
				_veh animateSource ["arm",_valu];
				sleep 0.05;
			};
		};
		true;
	},
	{
		A3PL_Exacvator_Control = false;
		true;
	}, [DIK_NUMPAD8, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Excavator" call A3PL_Localize],"exca_4", "STR_A3PL_EventHandlers_Excavator_LowerArm" call A3PL_Localize,
	{
		[vehicle player] spawn {
			private _veh = _this#0;
			if (typeOf(_veh) isNotEqualTo "A3PL_MiniExcavator") exitWith {};
			A3PL_Exacvator_Control = true;
			while {A3PL_Exacvator_Control} do {
				_val = _veh animationSourcePhase "arm";
				_valu = _val - 0.01;
				if (_valu <= -1) then {_valu = -1};
				_veh animateSource ["arm",_valu];
				sleep 0.05;
			};
		};
		true;
	},
	{
		A3PL_Exacvator_Control = false;
		true;
	}, [DIK_NUMPAD2, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Excavator" call A3PL_Localize],"exca_5", "STR_A3PL_EventHandlers_Excavator_UnfoldArm" call A3PL_Localize,
	{
		[vehicle player] spawn {
			private _veh = _this#0;
			if (typeOf(_veh) isNotEqualTo "A3PL_MiniExcavator") exitWith {};
			A3PL_Exacvator_Control = true;
			while {A3PL_Exacvator_Control} do {
				_val = _veh animationSourcePhase "frontArm";
				_valu = _val + 0.01;
				if (_valu >= 1) then {_valu = 1};
				_veh animateSource ["frontArm",_valu];
				sleep 0.05;
			};
		};
		true;
	},
	{
		A3PL_Exacvator_Control = false;
		true;
	}, [DIK_NUMPAD9, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Excavator" call A3PL_Localize],"exca_6", "STR_A3PL_EventHandlers_Excavator_FoldArm" call A3PL_Localize,
	{
		[vehicle player] spawn {
			private _veh = _this#0;
			if (typeOf(_veh) isNotEqualTo "A3PL_MiniExcavator") exitWith {};
			A3PL_Exacvator_Control = true;
			while {A3PL_Exacvator_Control} do {
				_val = _veh animationSourcePhase "frontArm";
				_valu = _val - 0.01;
				if (_valu <= -1) then {_valu = -1};
				_veh animateSource ["frontArm",_valu];
				sleep 0.05;
			};
		};
		true;
	},
	{
		A3PL_Exacvator_Control = false;
		true;
	}, [DIK_NUMPAD3, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Excavator" call A3PL_Localize],"exca_7", "STR_A3PL_EventHandlers_Excavator_DeployAttachment" call A3PL_Localize,
	{
		[vehicle player] spawn {
			private _veh = _this#0;
			if (typeOf(_veh) isNotEqualTo "A3PL_MiniExcavator") exitWith {};
			A3PL_Exacvator_Control = true;
			while {A3PL_Exacvator_Control} do {
				_val = _veh animationSourcePhase "attachment";
				_valu = _val - 0.02;
				if (_valu >= 1) then {_valu = 1};
				_veh animateSource ["attachment",_valu];
				sleep 0.05;
			};
		};
		true;
	},
	{
		A3PL_Exacvator_Control = false;
		true;
	}, [DIK_NUMPAD1, [false, false, false]]] call CBA_fnc_addKeybind;

	[format["A3PL : %1","STR_A3PL_EventHandlers_Excavator" call A3PL_Localize],"exca_8", "STR_A3PL_EventHandlers_Excavator_RetractAttachment" call A3PL_Localize,
	{
		[vehicle player] spawn {
			private _veh = _this#0;
			if (typeOf(_veh) isNotEqualTo "A3PL_MiniExcavator") exitWith {};
			A3PL_Exacvator_Control = true;
			while {A3PL_Exacvator_Control} do {
				_val = _veh animationSourcePhase "attachment";
				_valu = _val + 0.02;
				if (_valu <= -1) then {_valu = -1};
				_veh animateSource ["attachment",_valu];
				sleep 0.05;
			};
		};
		true;
	},
	{
		A3PL_Exacvator_Control = false;
		true;
	}, [DIK_NUMPAD7, [false, false, false]]] call CBA_fnc_addKeybind;


	// Fired EVH
	player addEventHandler ["Fired",
	{
		private _weapon = param [1,""];
		private _ammo = param [4,""];
		if (_weapon IN ["A3PL_FireAxe","A3PL_Pickaxe","A3PL_Shovel","A3FL_BaseballBat","A3FL_BaseballBatGold","A3FL_PoliceBaton","A3FL_GolfDriver","A3PL_Scypthe","A3FL_DickStick","A3FL_DickStickGold","A3FL_Crowbar"]) then
		{
			player playAction "GestureSwing";
			if(((typeOf player_objintersect) isEqualTo "Land_A3FL_Fishers_Jewelry") && {player_nameintersect IN ["case_break_1","case_break_2","case_break_3","case_break_4","case_break_5","case_break_6","case_break_7","case_break_8","case_break_9"]}) exitWith {
				call A3PL_Jewelry_GlassDamage;
			};
			if(_weapon isEqualTo "A3PL_FireAxe") then {
				if (player inArea "LumberJack_Rectangle") then {
					if (_weapon isEqualTo "A3PL_FireAxe") then {call A3PL_Lumber_FireAxe;};
				} else {
					call A3PL_FD_HandleFireAxe;
				};
			};
		};
		if (_weapon isEqualTo "A3PL_Jaws") then {call A3PL_FD_HandleJaws;};
		if (_ammo IN PD_Breach_Weapons) then {call A3PL_Police_HandleBreach;};
		if (_weapon IN PD_Powder_Gun) then {
			[] spawn A3PL_Police_SetPowder;
			call A3PL_Police_DropCasing;

			private _pos = getPos player;
    		[_pos] call A3PL_Criminal_ShotNotification;
		};
	}];

	player addEventHandler ["FiredNear",
	{
		if(player getVariable ["pVar_RedNameOn",false]) exitWith {};
		private _distance = param [2,100];
		private _weaponClass = param [3,""];
		private _except = ["JD_Snowball","A3PL_FireExtinguisher","CMFlareLauncher","A3PL_Machinery_Bucket","A3PL_Machinery_Pickaxe","A3PL_Taser","A3PL_Taser2","A3PL_High_Pressure","A3PL_Scypthe","A3PL_FireAxe","A3PL_Pickaxe","A3PL_Shovel","A3PL_Jaws","A3PL_High_Pressure","A3PL_Scythe","A3PL_Paintball_Marker","A3PL_Paintball_Marker_Camo","A3PL_Paintball_Marker_PinkCamo","A3PL_Paintball_Marker_DigitalBlue","A3PL_Paintball_Marker_Green","A3PL_Paintball_Marker_Purple","A3PL_Paintball_Marker_Red","A3PL_Paintball_Marker_Yellow","A3FL_BaseballBat","A3FL_BaseballBatGold","A3FL_PoliceBaton","A3FL_GolfDriver","A3FL_PepperSpray","A3FL_Shield","A3FL_DickStick","A3FL_DickStickGold","A3FL_Crowbar","A3PL_High_Pressure_Ladder","EC_PBP_ID"];
		if(_distance <= 25 && (!(_weaponClass IN _except))) then {
			Player_LockView = true;
			Player_LockView_Time = time + (2 * 60);
		};
	}];

	player addEventHandler ["Take",
	{
		params ["_unit", "_container", "_itemClass"];

		[player,_itemClass,getPos player,serverTime] remoteExec ["Server_Inventory_PickupCheck",2];

		if (_itemClass isEqualTo "A3PL_High_Pressure_Holder") exitWith {
			player setAmmo ["A3PL_High_Pressure_Holder",0];
		};
		if (_itemClass IN ["A3PL_High_Pressure_Water_Mag","A3PL_Medium_Pressure_Water_Mag","A3PL_Low_Pressure_Water_Mag"]) exitWith {
			player removeMagazine _itemClass;
		};

		if (_itemClass == "A3PL_FD_Mask") exitWith {
			["STR_A3PL_EventHandlers_ObjectAddedToInventory" call A3PL_Localize,Color_Green] call A3PL_Notification;
			removeGoggles player;
			player removeItem "A3PL_FD_Mask";
			["fd_mask",1] call A3PL_Inventory_Add;
		};
		if (_itemClass isEqualTo "A3PL_Shovel") exitWith {
			player removeMagazines "A3PL_ShovelMag";
			player addMagazine "A3PL_ShovelMag";
		};
		if (_itemClass isEqualTo "A3PL_Pickaxe") exitWith {
			player removeMagazines "A3PL_PickAxeMag";
			player addMagazine "A3PL_PickAxeMag";
		};
		if (_itemClass isEqualTo "A3PL_Jaws") exitWith {
			player removeMagazines "A3PL_FireAxeMag";
			player addMagazine "A3PL_FireAxeMag";
		};
		if (_itemClass isEqualTo "A3PL_FireAxe") exitWith {
			player removeMagazines "A3PL_FireAxeMag";
			player addMagazine "A3PL_FireAxeMag";
		};
		if (_itemClass isEqualTo "A3PL_Scythe") exitWith {
			player removeMagazines "A3PL_ScytheMag";
			player addMagazine "A3PL_ScytheMag";
		};
		if (_itemClass isEqualTo "A3FL_GolfDriver") exitWith {
			player removeMagazines "A3FL_GolfDriverMag";
			player addMagazine "A3FL_GolfDriverMag";
		};
		if (_itemClass isEqualTo "A3FL_BaseballBat" || {_itemClass isEqualTo "A3FL_BaseballBatGold"}) exitWith {
			player removeMagazines "A3FL_BaseballBatMag";
			player addMagazine "A3FL_BaseballBatMag";
		};
		if (_itemClass isEqualTo "A3FL_PoliceBaton") exitWith {
			player removeMagazines "A3FL_PoliceBatonMag";
			player addMagazine "A3FL_PoliceBatonMag";
		};
		if (_itemClass isEqualTo "A3FL_DickStick") exitWith {
			player removeMagazines "A3FL_DickStick_Mag";
			player addMagazine "A3FL_DickStick_Mag";
		};
		if (_itemClass isEqualTo "A3FL_DickStickGold") exitWith {
			player removeMagazines "A3FL_DickStick_Mag";
			player addMagazine "A3FL_DickStick_Mag";
		};
		if (_itemClass isEqualTo "A3FL_Crowbar") exitWith {
			player removeMagazines "A3FL_Crowbar_Mag";
			player addMagazine "A3FL_Crowbar_Mag";
		};
		if (_itemClass IN ["U_B_Protagonist_VR","U_I_Protagonist_VR","U_O_Protagonist_VR"]) exitWith {
			_getDay = player getVariable ["Player_PerkDay",0];
			if (_getDay < 1) then {
				["STR_A3PL_EventHandlers_NoPremium" call A3PL_Localize,Color_Red] call A3PL_Notification;
				if ((uniform player) == _itemClass) then {removeUniform player;};
				player removeItem _itemClass;
			};
		};
		if (_itemClass IN ["U_B_Protagonist_VR"]) then {
			_getDay = player getVariable ["Player_PerkDay",0];
			if (_getDay < 1) then {
				if ((uniform player) == _itemClass) then {removeUniform player;};
				if ((headgear player) == _itemClass) then {removeHeadgear player;};
				if ((goggles player) == _itemClass) then {removeGoggles player;};
				if ((vest player) == _itemClass) then {removeVest player;};
				if ((backpack player) == _itemClass) then {removeBackpack player;};
				player removeItem _itemClass;
			};
		};
		private _containerTypeFound = false;
		private _charID = (player getVariable ["character_id",""]);
			if ((_container isKindOf "car") || (_container isKindOf "plane") || (_container isKindOf "helicopter") || (_container isKindOf "ship") || (_container isKindOf "air") || (_container isKindOf "tank")) then {
				[getPlayerUID player,_charID,"Inv_Physical_VehicleTake",[format ["Location: %1 | Item: %2 | Vehicle: %3 | Plate: %4",(getPosATL _container),_itemClass,(typeOf _container),(getPlateNumber _container)]]] remoteExec ["Server_Log_New",2];
				_containerTypeFound = true;
			};
			if ((typeOf _container) isEqualTo "Box_GEN_Equip_F") then {
				[getPlayerUID player,_charID,"Inv_Physical_WHorHouseTake",[format ["Location: %1 | Item: %2",(getPosATL _container),_itemClass]]] remoteExec ["Server_Log_New",2];
				_containerTypeFound = true;
			};
			if ((typeOf _container) isEqualTo "Land_MetalCase_01_large_F") then {
				[getPlayerUID player,_charID,"Inv_Physical_SubstationTake",[format ["Location: %1 | Item: %2",(getPosATL _container),_itemClass]]] remoteExec ["Server_Log_New",2];
				_containerTypeFound = true;
			};
			if ((typeOf _container) isEqualTo "Land_MetalCase_01_medium_F") then {
				[getPlayerUID player,_charID,"Inv_Physical_WHorHouseRobTake",[format ["Location: %1 | Item: %2",(getPosATL _container),_itemClass]]] remoteExec ["Server_Log_New",2];
				_containerTypeFound = true;
			};
			if ((typeOf _container) isEqualTo "C_IDAP_supplyCrate_F") then {
				[getPlayerUID player,_charID,"Inv_Physical_EvidenceLockerTake",[format ["Location: %1 | Item: %2",(getPosATL _container),_itemClass]]] remoteExec ["Server_Log_New",2];
				_containerTypeFound = true;
			};
			if ((typeOf _container) isEqualTo "B_supplyCrate_F") then {
				[getPlayerUID player,_charID,"Inv_Physical_ServerEventTake",[format ["Location: %1 | Item: %2",(getPosATL _container),_itemClass]]] remoteExec ["Server_Log_New",2];
				_containerTypeFound = true;
			};
			if ((typeOf _container) isEqualTo "GroundWeaponHolder") then {
				[getPlayerUID player,_charID,"Inv_Physical_GroundTake",[format ["Location: %1 | Item: %2",(getPosATL _container),_itemClass]]] remoteExec ["Server_Log_New",2];
				_containerTypeFound = true;
			};
			if (!_containerTypeFound) then {
				[getPlayerUID player,_charID,"Inv_Physical_Take",[format ["Location: %1 | Item: %2 | Container Type Unknown",(getPosATL _container),_itemClass]]] remoteExec ["Server_Log_New",2];
			};
	}];

	player addEventHandler ["Put",
	{
		params ["_unit", "_container", "_itemClass"];

		private _containerTypeFound = false;
		private _charID = (player getVariable ["character_id",""]);
		if ((_container isKindOf "car") || (_container isKindOf "plane") || (_container isKindOf "helicopter") || (_container isKindOf "ship") || (_container isKindOf "air") || (_container isKindOf "tank")) then {
			[getPlayerUID player,_charID,"Inv_Physical_VehiclePut",[format ["Location: %1 | Item: %2 | Vehicle: %3 | Plate: %4",(getPosATL _container),_itemClass,(typeOf _container),(getPlateNumber _container)]]] remoteExec ["Server_Log_New",2];
			_containerTypeFound = true;
		};
		if ((typeOf _container) isEqualTo "Box_GEN_Equip_F") then {
			[getPlayerUID player,_charID,"Inv_Physical_WHorHousePut",[format ["Location: %1 | Item: %2",(getPosATL _container),_itemClass]]] remoteExec ["Server_Log_New",2];
			_containerTypeFound = true;
		};
		if ((typeOf _container) isEqualTo "Land_MetalCase_01_large_F") then {
			[getPlayerUID player,_charID,"Inv_Physical_SubstationPut",[format ["Location: %1 | Item: %2",(getPosATL _container),_itemClass]]] remoteExec ["Server_Log_New",2];
			_containerTypeFound = true;
		};
		if ((typeOf _container) isEqualTo "Land_MetalCase_01_medium_F") then {
			[getPlayerUID player,_charID,"Inv_Physical_WHorHouseRobPut",[format ["Location: %1 | Item: %2",(getPosATL _container),_itemClass]]] remoteExec ["Server_Log_New",2];
			_containerTypeFound = true;
		};
		if ((typeOf _container) isEqualTo "C_IDAP_supplyCrate_F") then {
			[getPlayerUID player,_charID,"Inv_Physical_EvidenceLockerPut",[format ["Location: %1 | Item: %2",(getPosATL _container),_itemClass]]] remoteExec ["Server_Log_New",2];
			_containerTypeFound = true;
		};
		if ((typeOf _container) isEqualTo "B_supplyCrate_F") then {
			[getPlayerUID player,_charID,"Inv_Physical_ServerEventPut",[format ["Location: %1 | Item: %2",(getPosATL _container),_itemClass]]] remoteExec ["Server_Log_New",2];
			_containerTypeFound = true;
		};
		if ((typeOf _container) isEqualTo "GroundWeaponHolder") then {
			[getPlayerUID player,_charID,"Inv_Physical_GroundPut",[format ["Location: %1 | Item: %2",(getPosATL _container),_itemClass]]] remoteExec ["Server_Log_New",2];
			_containerTypeFound = true;
		};
		if (!_containerTypeFound) then {
			[getPlayerUID player,_charID,"Inv_Physical_Put",[format ["Location: %1 | Item: %2 | Container Type Unknown",(getPosATL _container),_itemClass]]] remoteExec ["Server_Log_New",2];
		};
	}];

	addMissionEventHandler ["Map", {
		params ["_mapIsOpened","_mapIsForced"];
		if (_mapIsOpened) then {
			//call A3PL_Player_OpenMap;
			[0] spawn A3PL_Storage_ShowGPS;
		} else {
			[1] spawn A3PL_Storage_ShowGPS;
		};

		mapAnimAdd [0, 0.1, player];
		mapAnimCommit;
	}];

	player addEventHandler ["Killed",{_this call A3PL_Medical_Killed;}];
	player addEventHandler ["Respawn", {_this call A3PL_Medical_Die;}];
	player addEventHandler ["HandleRating", {private _handler = 0;_handler;}];

	player addEventHandler ["GetInMan", {
		params ["_unit", "_role", "_vehicle", "_turret"];
		if(player getVariable ["SeatbeltOn",false]) then {
			player setVariable ["SeatbeltOn",nil,true];
		};
		if !(_vehicle isKIndOf "Car" && {typeOf _vehicle IN Seatbelt_Blacklist}) then {
			[] spawn A3FL_Loop_Seatbelt;
		};
		if(Player_ItemClass isNotEqualTo "") then {
			[true] call A3PL_Inventory_PutBack;
		};
		if !(isNull A3PL_PhoneObject) then {
			[] spawn {
				A3PL_PhoneObject hideObject true;
				sleep 2;
				_pos = (vehicle player) worldToModel (player modelToWorldVisual ((player selectionPosition "RightHandMiddle1") vectorAdd [0.02,0.01,0.15]));
				detach A3PL_PhoneObject;
				A3PL_PhoneObject attachTo [(vehicle player),_pos];
				A3PL_PhoneObject setVectorDirAndUp [[-0.21017,0.265195,-0.94101],[-0.949623,0.173499,0.260989]];
				A3PL_PhoneObject hideObject false;
			};
		};
	}];
	player addEventHandler ["GetOutMan", {
		params ["_unit"];
		_unit setVariable ["SeatbeltOn",nil,true];
		_unit setVariable ["NVGsOn",nil,true];
		_unit action ["nvGogglesOff",_unit];
		if(A3PL_Holster isNotEqualTo "") then {
			_unit action ["SwitchWeapon", _unit, _unit, -1];
			_unit switchMove "amovpercmstpsnonwnondnon";			
		};
		if(Player_ItemClass isNotEqualTo "") then {
			[true] call A3PL_Inventory_PutBack;
		};
		if !(isNull A3PL_PhoneObject) then {
			detach A3PL_PhoneObject;
			A3PL_PhoneObject attachTo [player, [0.02,0.01,0.15], "RightHandMiddle1"];
			A3PL_PhoneObject setVectorDirAndUp [[-0.21017,0.265195,-0.94101],[-0.949623,0.173499,0.260989]];
			[{player playActionNow "A3PL_Tel";}] call CBA_fnc_execNextFrame;
		};
	}];

	player addEventHandler ["HandleDamage",
	{
		params [
			["_unit",objNull,[objNull]],
			["_selection","",[""]],
			["_damage",0,[0]],
			["_source",objNull,[objNull]],
			["_projectile","",[""]],
			["_hitIndex",0,[0]],
			["_instigator",objNull,[objNull]]
		];
		private _noDamage = if (_selection isEqualTo "") then {damage _unit;} else {_unit getHit _selection;};
		private _adminMode = _unit getVariable ["pVar_RedNameOn",false];

		if(_projectile IN Medical_NoDamage_Bullets) then {_damage = 0;};
		if (!isNull _source && {!_adminMode}) then {
			if(_source isNotEqualTo _unit) then {
				if (_projectile IN Medical_Ragdoll_Weapons) then {
					if (alive _unit) then {
						if (!Player_Ragdoll) then {
							if !(isNull objectParent _unit) then {
								if (typeOf (vehicle _unit) IN ["B_Quadbike_01_F","C_Kart_01_F","K_Scooter_DarkBlue"] && {!((vehicle player) setVariable["trapped",false])}) then {
									_unit action ["Eject",vehicle _unit];
									[_unit,_source,_selection,_projectile] spawn A3PL_Medical_Tazed;
								};
							} else {
								[_unit,_source,_selection,_projectile] spawn A3PL_Medical_Tazed;
							};
						};
					};
				};
				if (_projectile isEqualTo "A3PL_Paintball_Bullet") then {
					if (isNil "A3PL_Medical_PaintBallHit") exitwith {};
					if ((player distance (getMarkerPos "marker_activities_paintball")) > 300) exitWith {};
					A3PL_Medical_PaintBallHit = true;
					player playaction "gesture_wave";
					sleep 0.6;
					A3PL_Medical_PaintBallHit = nil;
				};
			};
		};	
		if((_projectile isEqualTo "A3FL_PepperSpray_Ball") && {(_source isEqualTo _unit)}) then {_adminMode=true;};
		if (!_adminMode) then {
			if (_damage > 0) then {
				private _hit = _unit getVariable ["getHit",[]];
				_hit pushback [_selection,_damage,_projectile];
				_unit setVariable ["getHit",_hit,false];
				if (diag_tickTime <= ((missionNameSpace getVariable ["A3PL_HitTime",diag_ticktime-0.2]) + 0.1)) then {} else
				{
					A3PL_HitTime = diag_ticktime;
					[_unit] spawn A3PL_Medical_Hit;
					if((!isNull _instigator) && {!(_instigator isEqualTo _unit)}) then {
						_unit setVariable ["lastDamage",(_instigator getVariable["db_id","Unknown"]),true];
						[getPlayerUID _unit,(_unit getVariable ["character_id",""]),"Medical_Hit_Received",[format ["Shooter: %1 | Projectile: %2",_instigator getVariable["name","unknwon"],_projectile]]] remoteExec ["Server_Log_New",2];
						[getPlayerUID _unit,(_unit getVariable ["character_id",""]),"Medical_Hit_Sent",[format ["Target: %1 | Projectile: %2",_unit getVariable["name","unknwon"],_projectile]]] remoteExec ["Server_Log_New",2];
					};
				};
			};
		};
		_noDamage;
	}];

	player addEventHandler ["InventoryOpened",
	{
		params [
			["_unit", objNull, [objNull]],
			["_container", objNull, [objNull]],
			["_secContainer", objNull, [objNull]]
		];
		private _handle = false;
		{
			if(Player_ActionDoing) exitWith {
				["STR_A3PL_EventHandlers_CantOpenInventoryBusy" call A3PL_Localize,Color_Red] call A3PL_Notification;
				_handle = true;
			};
			if (_x isKindOf "Car" && {_x getVariable["locked",false]}) exitWith {
				["STR_A3PL_EventHandlers_VehicleLocked" call A3PL_Localize,Color_Red] call A3PL_Notification;
				_handle = true;
			};
			if ((player getVariable["Cuffed",false]) || {player getVariable["Zipped",false]}) exitWith {
				["STR_A3PL_EventHandlers_HandcuffedError" call A3PL_Localize,Color_Red] call A3PL_Notification;
				_handle = true;
			};
			if (_x IN [A3FL_Seize_Storage,evidence_box_elk,evidence_box_nd,evidence_box_svt]) exitWith {
				private _isLead = ["STR_Common_FISD" call A3PL_Localize] call A3PL_Government_isFactionLeader;
				private _isLocked = _x getVariable["locked",true];
				if(!_isLead && _isLocked) exitWith {
					["STR_A3PL_EventHandlers_StorageClosed" call A3PL_Localize,Color_Red] call A3PL_Notification;
					_handle = true;
				};
			};
			if ((typeOf _x isEqualTo "A3PL_EMS_Locker")) exitWith {
				if (_x animationSourcePhase "door_1" isNotEqualTo 1) then {
					private _owner = _x getVariable["owner",""];
					if(!((player getVariable ["character_id",""]) isEqualTo _owner)) exitWith {
						["STR_A3PL_EventHandlers_StorageClosed" call A3PL_Localize,Color_Red] call A3PL_Notification;
						_handle = true;
					};
				} else {
					["STR_A3PL_EventHandlers_StorageClosed" call A3PL_Localize,Color_Red] call A3PL_Notification;
					_handle = true;
				};
			};
			if (_x isKindOf "CAManBase" && {!alive _x}) exitWith {
				["STR_A3PL_EventHandlers_FriskCadaver" call A3PL_Localize,Color_Red] call A3PL_Notification;
				_handle = true;
			};
			if (_x isKindOf "Car" && {(count(nearestObjects[player, ["Land_A3PL_storage"], 10]) > 0)}) exitWith {
				["STR_A3PL_EventHandlers_MoveAwayFromGarage" call A3PL_Localize,Color_Red] call A3PL_Notification;
				_handle = true;
			};
			if (typeOf _x isEqualTo "Box_GEN_Equip_F") then {
				if (_x getVariable["StorageOpened",false]) then {
					if(count(nearestObjects[_x,["CAManBase"],2]) isEqualTo 1) then {
						_x setVariable["StorageOpened",false,true];
					};
					["STR_A3PL_EventHandlers_OnceAtATimeStorageAccess" call A3PL_Localize,Color_Red] call A3PL_Notification;
					_handle = true;
					break;
				} else {
					_x setVariable["StorageOpened",true,true];
				};
			};
		} forEach [_container,_secContainer];
		_handle;
	}];

	player addEventHandler ["InventoryClosed",
	{
		params [
			["_unit", objNull, [objNull]],
			["_container", objNull, [objNull]],
			["_secContainer", objNull, [objNull]]
		];
		private _handle = false;
		{
			if ((typeOf _x) isEqualTo "Box_GEN_Equip_F") exitWith {
				_x setVariable["StorageOpened",false,true];
				_handle = true;
			};
		} count [_container, _secContainer];
		_handle;
	}];
	call A3LL_EventHandlers_RadioAnim;
}] call compile_Global;

["A3LL_EventHandlers_RadioAnim",
{
	["A3FL_RadioAnimation", "OnTangent", {
		private _transmit = _this select 4;
		private _vest = vest player;
		private _vestList = RadioAnim_VestList;
		private _vestBelt = RadioAnim_VestBeltList;
		if((currentWeapon player) isNotEqualTo "") exitWith {};
		if (player getVariable["call_info",0] isNotEqualTo 0) exitWith {};
		if(_transmit) then {
			private _anim = switch(true) do {
				case (_vest IN _vestList): { "A3FL_RadioAnim_01" };
				case (_vest IN _vestBelt): { "A3FL_anim_VestBeltHold" };
				case (_vest isEqualTo "A3FL_DutyBelt4"): { "A3FL_anim_RadioHold3" };
				default { "A3FL_RadioAnim_02" };
			};
			player playAction _anim;
		} else {
			player playAction "GestureNod";
		};
	}, player] call TFAR_fnc_addEventHandler;
}] call compile_Global;

["A3PL_Prevent_Patdown_Cloning",
{
	if(player getVariable ["patdown",false]) then {
		["STR_Common_DuplicateAttempt" call A3PL_Localize,Color_Red] call A3PL_Notification;
		[getPlayerUID player,(player getVariable ["character_id",""]),"BugAttempt_PatdownDupe",[format ["Location: %1",(getPosATL player)]]] remoteExec ["Server_Log_New",2];
		true;
	};
}] call compile_Global;

["A3PL_EventHandlers_HandleDown",
{
	params["_ctrl", "_dikCode", "_shift", "_ctrlKey", "_alt"];

	if(isNil "A3PL_Manual_KeyDown") then {A3PL_Manual_KeyDown = false};

	private _CommandMode = actionKeys "tacticalView";
    if (_dikCode in _CommandMode) exitWith {
        true;
    };

	if (_dikCode isEqualTo 59) exitWith {
		if (pVar_AdminMenuGranted) exitWith {
			call A3PL_Admin_Open;
		};
	};
	if (_dikCode isEqualTo 60) exitWith {
		if (pVar_AdminMenuGranted) then {
			if (pVar_CursorTargetEnabled) then {
				pVar_CursorTargetEnabled = false;
			} else {
				[] spawn A3PL_Admin_CursorTarget;
			};
		};
	};
	if (_dikCode isEqualTo 61) exitWith {
		if (pVar_AdminMenuGranted) then {
			disableSerialization;
			["Initialize", [player, [], false, true, true, false, true, true, true, true]] call BIS_fnc_EGSpectator;
			[player,"EnterSpectate", format["Position: %1 | Job: %2", getPosATL player, player getVariable["job","STR_Common_Job_Unemployed" call A3PL_Localize]]] remoteExec ["Server_AdminLoginsert", 2];
			[player,true] remoteExec ["A3PL_Lib_HideObject", 2];
			pVar_MapTeleportReady = false;
			[] spawn {
				waitUntil {!isNull findDisplay 49};
				["Terminate"] call BIS_fnc_EGSpectator;
				[player,false] remoteExec ["A3PL_Lib_HideObject", 2];
				[player,"ExitSpectate", format["Position: %1 | Job: %2", getPosATL player, player getVariable["job","STR_Common_Job_Unemployed" call A3PL_Localize]]] remoteExec ["Server_AdminLoginsert", 2];
				(findDisplay 49) closeDisplay 1;
				waitUntil {isNull findDisplay 49};
			};
		};
	};
	if (_dikCode isEqualTo 62) exitWith {
		if !("STR_A3PL_Admin_Perm_Debug" call A3PL_Localize IN pVar_AdminPerms) exitWith {};
		call A3PL_Admin_OpenDebug;
	};

	if ((_dikCode isEqualTo 82) && pVar_CursorTargetEnabled && pVar_AdminMenuGranted ) exitWith {
		cursorTarget lock false;
		player action["GetInDriver",cursorTarget];
		cursorTarget lock true;
	true;
	};
	if ((_dikCode isEqualTo 79) && pVar_CursorTargetEnabled && pVar_AdminMenuGranted ) exitWith {
		[cursorTarget] spawn A3PL_Admin_AttachTo;
		true;
	};
	if ((_dikCode isEqualTo 80) && pVar_CursorTargetEnabled && pVar_AdminMenuGranted ) exitWith {
		{detach _x;} forEach attachedObjects player;
		true;
	};
	if ((_dikCode isEqualTo 81) && pVar_CursorTargetEnabled && pVar_AdminMenuGranted ) exitWith {
		[cursorTarget] remoteExec ["Server_Police_Impound",2];
		[player,"Cursor_AdminImpound", format["Target: %1 | Position: %2", typeOf cursorTarget, getPosATL player]] remoteExec ["Server_AdminLoginsert", 2];
		true;
	};
	if ((_dikCode isEqualTo 75) && pVar_CursorTargetEnabled && pVar_AdminMenuGranted ) exitWith {
		if((typeOf cursorTarget) IN ["A3PL_EMS_Locker","Box_NATO_Equip_F","B_supplyCrate_F","C_IDAP_supplyCrate_F","C_man_w_worker_F"]) exitWith {};
		if ((vehicle player) isEqualTo player) then {
			{deleteVehicle _x;} foreach (attachedObjects cursorTarget);
			deleteVehicle cursorTarget;
			[player,"Cursor_AdminDelete", format["Target: %1 | Position: %2", typeOf cursorTarget, getPosATL player]] remoteExec ["Server_AdminLoginsert", 2];
		} else {
			{deleteVehicle _x;} foreach (attachedObjects vehicle player);
			deleteVehicle vehicle player;
			[player,"Cursor_AdminDelete", format["Target: %1 | Position: %2", typeOf (vehicle player), getPosATL player]] remoteExec ["Server_AdminLoginsert", 2];
		};
		true;
	};
	if ((_dikCode isEqualTo 76) && pVar_CursorTargetEnabled && pVar_AdminMenuGranted ) exitWith {
		cursorTarget lock false;
		player action ["GetInCargo", cursorTarget];
		cursorTarget lock true;
		true;
	};
	if ((_dikCode isEqualTo 77) && pVar_CursorTargetEnabled && pVar_AdminMenuGranted ) exitWith {
		if ((vehicle player) isEqualTo player) then {
			private _car = cursorTarget;
			private _pass = crew _car;
			{_x action ["getOut", _car];} foreach _pass;
		} else {
			private _car = vehicle player;
			private _pass = crew _car;
			{_x action ["getOut", _car];} foreach _pass;
		};
		true;
	};
	if ((_dikCode isEqualTo 71) && pVar_CursorTargetEnabled && pVar_AdminMenuGranted ) exitWith {
		_target = cursorObject;
		[player,"Cursor_AdminHeal", format["Target: %1 | TargetPos: %2 | TargetBlood: %3", _target getVariable["name","unknown"], getPosATL _target, _target getVariable["A3PL_Medical_Blood",5000]]] remoteExec ["Server_AdminLoginsert", 2];
		_target setDamage 0;
		_target setVariable ["A3PL_Medical_Alive",true,true];
		_target setVariable ["A3PL_Wounds",[],true];
		_target setVariable ["A3PL_Medical_Blood",5000,true];
		true;
	};
	if ((_dikCode isEqualTo 72) && pVar_CursorTargetEnabled && pVar_AdminMenuGranted ) exitWith {
		[player,"Cursor_AdminRepair", format["Target: %1 | Position: %2", typeOf cursorTarget, getPosATL player]] remoteExec ["Server_AdminLoginsert", 2];
		if ((vehicle player) isEqualTo player) then {
			cursorTarget setdamage 0;
		} else {
			vehicle player setdamage 0;
		};
		true;
	};
	if ((_dikCode isEqualTo 73) && pVar_CursorTargetEnabled && pVar_AdminMenuGranted ) exitWith {
		[player,"Cursor_AdminRefuel", format["Target: %1 | Position: %2", typeOf cursorTarget, getPosATL player]] remoteExec ["Server_AdminLoginsert", 2];
		if ((vehicle player) isEqualTo player) then {
			cursorTarget setFuel 1;
		} else {
			vehicle player setFuel 1;
		};
		true;
	};
	false;
}] call compile_Global;