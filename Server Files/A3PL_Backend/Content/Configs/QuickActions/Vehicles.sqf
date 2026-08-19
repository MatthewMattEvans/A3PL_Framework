/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
[
	"A3FL_Stretcher",
	"STR_Intersect_PushStretcher",
	{[player_objintersect] call A3PL_Inventory_Pickup;}
],

[
	"A3FL_Wheelchair",
	"STR_Intersect_PushWheelchair",
	{[player_objintersect] call A3PL_Inventory_Pickup;}
],
[
	"A3FL_Stretcher",
	"STR_Intersect_LowerRaiseStretcher",
	{
		private _veh = player_objintersect;
		if(_veh animationSourcePhase "Legs" isEqualTo 0) then {
			_veh animateSource["Legs",1];
		} else {
			_veh animateSource["Legs",0];
		};
	}
],
[
	"",
	"STR_Intersect_LoadStretcher",
	{[player_objintersect] call A3PL_Vehicle_LoadStretcher;}
],
[
	"",
	"STR_Intersect_UnloadStretcher",
	{[player_objintersect] call A3PL_Vehicle_LoadStretcher;}
],
[
	"A3PL_Pierce_Rescue",
	"STR_Intersect_RotateTruckLadder",
	{
		private _veh = player_objintersect;
		if(_veh animationSourcePhase "Ladder_Rotate" isEqualTo 0) then {
			_veh animateSource["Ladder_Rotate",2];
		} else {
			_veh animateSource["Ladder_Rotate",0];
		};
	}
],
[
	"A3PL_Pierce_Rescue",
	"STR_Intersect_ClimbTruckLadder",
	{
		private _veh = player_objintersect;
		player setPos (_veh modelToWorld [0,-5,1]);
		player setDir (getDir _veh);
	}
],
[
	"A3PL_Pierce_Rescue",
	"STR_Intersect_ExpandRetractSpotlight",
	{
		private _veh = player_objintersect;
		if(_veh animationSourcePhase "Top_Spot_Rotate" isEqualTo 0) then {
			_veh animateSource["Top_Spot_Rotate",6];
		} else {
			_veh animateSource["Top_Spot_Rotate",0];
			_veh animateSource["Top_Lights",0];
		};
	}
],
[
	"A3PL_Pierce_Rescue",
	"STR_Intersect_SwitchSpotlight2",
	{
		private _veh = player_objintersect;
		if(_veh animationSourcePhase "Top_Lights" isEqualTo 0) then {
			_veh animateSource["Top_Lights",1];
		} else {
			_veh animateSource["Top_Lights",0];
		};
	}
],
[
	"A3PL_Pierce_Rescue",
	"STR_Intersect_TakeSceneLight1",
	{
		private _veh = player_objintersect;
		if(_veh animationPhase "scene_light_1" isEqualTo 0) then {
			_veh animate["scene_light_1",1];
			private _light = createVehicle ["A3PL_SceneLight", [0,0,0], [], 0, "CAN_COLLIDE"];
			_light setVariable["owner",(player getVariable ["character_id",""]),true];
			_light setVariable["class","scene_light",true];
			player action ["lightOn",_light];
			_light setPos (player modelToWorld [0,1,0]);
			_light setDir(getDir player);
			[_light] call A3PL_Inventory_Pickup;
		};
	}
],
[
	"A3PL_Pierce_Rescue",
	"STR_Intersect_TakeSceneLight2",
	{
		private _veh = player_objintersect;
		if(_veh animationPhase "scene_light_2" isEqualTo 0) then {
			_veh animate["scene_light_2",1];
			private _light = createVehicle ["A3PL_SceneLight", [0,0,0], [], 0, "CAN_COLLIDE"];
			_light setVariable["owner",(player getVariable ["character_id",""]),true];
			_light setVariable["class","scene_light",true];
			player action ["lightOn",_light];
			_light setPos (player modelToWorld [0,1,0]);
			_light setDir(getDir player);
			[_light] call A3PL_Inventory_Pickup;
		};
	}
],
[
	"A3PL_Pierce_Rescue",
	"STR_Intersect_PutSceneLight1",
	{
		private _veh = player_objintersect;
		if(_veh animationPhase "scene_light_1" isEqualTo 1) then {
			private _nearLights = nearestObjects [player, ["A3PL_SceneLight"], 10];
			if(count(_nearLights) isEqualTo 0) exitWith {[("STR_A3PL_QuickActions_Vehicles_NoLightNear" call A3PL_Localize), Color_Red] call A3PL_Notification;};
			deleteVehicle (_nearLights select 0);
			_veh animate["scene_light_1",0];
		};
	}
],
[
	"A3PL_Pierce_Rescue",
	"STR_Intersect_PutSceneLight2",
	{
		private _veh = player_objintersect;
		if(_veh animationPhase "scene_light_2" isEqualTo 1) then {
			private _nearLights = nearestObjects [player, ["A3PL_SceneLight"], 10];
			if(count(_nearLights) isEqualTo 0) exitWith {[("STR_A3PL_QuickActions_Vehicles_NoLightNear" call A3PL_Localize), Color_Red] call A3PL_Notification;};
			deleteVehicle (_nearLights select 0);
			_veh animate["scene_light_2",0];
		};
	}
],

/*
	Patrol Boat Interactions
*/
[
	"A3PL_Patrol",
	"STR_Intersect_LockUnlockPatrol",
	{
		private _veh = player_objintersect;
		if(_veh getVariable["locked",true]) then {
			_veh setVariable["locked",false,true];
		} else {
			_veh setVariable["locked",true,true];
		};
	}
],
[
	"A3PL_Patrol",
	"STR_Intersect_DriveBoat",
	{player moveInDriver player_objintersect;}
],
[
	"A3PL_Patrol",
	"STR_Intersect_CargoBoat",
	{player moveInCargo player_objintersect;}
],
// [
// 	"A3PL_Patrol",
// 	"Controler Extincteur",
// 	{player moveInCommander player_objintersect;}
// ],
// [
// 	"A3PL_Jayhawk",
// 	"Board Helicopter (Seat)",
// 	{
// 		[player_objintersect] spawn {
// 			private _veh = _this select 0;
// 			_veh animate ["door3",1];
// 			uiSleep 0.5;
// 			_veh lock 1;
// 			moveOut player;
// 			_value = getNumber (configFile >> "CfgVehicles" >> (typeOf _veh) >> "transportSoldier");_list = fullCrew [_veh, "cargo"];_freeseats = count _list;if (_freeseats >= _value) exitwith {};
// 			player action ["GetInCargo", _veh];
// 			_veh lock 2;
// 		};
// 	}
// ],
[
	"A3PL_Jayhawk",
	"Hélicoptère Board (Coté)",
	{
		[player_objintersect] spawn {
			private _veh = _this select 0;
			_veh lock 1;
			moveOut player;
			player action ["GetInTurret", _veh,[1]];
			_veh lock 2;
		};
	}
],
[
	"A3PL_Jayhawk",
	"STR_Intersect_Battery",
	{
		private _veh = player_objintersect;
		if (_veh animationPhase "Battery" < 0.5) exitwith {
			_veh animate ["battery",1];
			playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
		};
		_veh animate ["battery",0];
		playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
	}
],
[
	"A3PL_Jayhawk",
	"STR_Intersect_UseAPUGenerator",
	{
		private _veh = player_objintersect;
		if (_veh animationPhase "gen1" < 0.5) exitwith {
			if (_veh animationPhase "battery" < 0.5) exitwith {[("STR_A3PL_QuickActions_Vehicles_BatteryOff" call A3PL_Localize), Color_Red] call A3PL_Notification;};
			if (_veh animationPhase "ecs" < 0.5) exitwith {[("STR_A3PL_QuickActions_Vehicles_ECSNotOnAPUBoost" call A3PL_Localize), Color_Red] call A3PL_Notification;};
			if (_veh animationPhase "fuelpump" > 0.5) exitwith {[("STR_A3PL_QuickActions_Vehicles_FuelPumpNotOnAPUBoost" call A3PL_Localize), Color_Red] call A3PL_Notification;};
			if (_veh animationPhase "apucontrol" < 0.5) exitwith {[("STR_A3PL_QuickActions_Vehicles_APUControlNotOnAPUBoost" call A3PL_Localize), Color_Red] call A3PL_Notification;};
			_veh animate ["gen1",1];
			playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
		};
		_veh animate ["gen1",0];
		playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
	}
],
[
	"A3PL_Jayhawk",
	"STR_Intersect_UseGeneratorNumber" + str 1,
	{
		private _veh = player_objintersect;
		if (_veh animationPhase "gen2" < 0.5) exitwith {
			_veh animate ["gen2",1];
			playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
		};
		_veh animate ["gen2",0];
		playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
	}
],
[
	"A3PL_Jayhawk",
	"STR_Intersect_UseGeneratorNumber" + str 2,
	{
		private _veh = player_objintersect;
		if (_veh animationPhase "gen3" < 0.5) exitwith {
			_veh animate ["gen3",1];
			playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
		};
		_veh animate ["gen3",0];
		playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
	}
],
[
	"A3PL_Jayhawk",
	"STR_Intersect_UseECS",
	{
		private _veh = player_objintersect;
		if (_veh animationPhase "ecs" < 0.5) exitwith {
			_veh animate ["ecs",1];
			playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
		};
		_veh animate ["ecs",0];
		playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
	}
],
[
	"A3PL_Jayhawk",
	"STR_Intersect_FuelPump",
	{
		private _veh = player_objintersect;
		if (_veh animationPhase "fuelpump" < 0.5) exitwith {
			_veh animate ["fuelpump",1];
			playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
		};
		_veh animate ["fuelpump",0];
		playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
	}
],
[
	"A3PL_Jayhawk",
	"STR_Intersect_APUControl",
	{
		private _veh = player_objintersect;
		if (_veh animationPhase "apucontrol" < 0.5) exitwith {
			_veh animate ["apucontrol",1];
			playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
		};
		_veh animate ["apucontrol",0];
		playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
	}
],
[
	"A3PL_Jayhawk",
	"STR_Intersect_StartSwitch2",
	{
		private _veh = player_objintersect;
		if (_veh animationPhase "ignition_Switch" > 0.5) exitwith {
			_veh animate ["ignition_Switch",0];
			_veh engineOn false;
			playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
		};
		if (_veh animationPhase "ignition_Switch" < 0.5) exitwith {
			if (_veh animationPhase "battery" < 0.5) exitwith {[("STR_A3PL_QuickActions_Vehicles_BatteryOff" call A3PL_Localize), Color_Red] call A3PL_Notification;};
			if (_veh animationPhase "ecs" > 0.5) exitwith {[("STR_A3PL_QuickActions_Vehicles_ECSNotOnEngine" call A3PL_Localize), Color_Red] call A3PL_Notification;};
			if (_veh animationPhase "fuelpump" < 0.5) exitwith {[("STR_A3PL_QuickActions_Vehicles_FuelPumpNoOnFuelPrime" call A3PL_Localize), Color_Red] call A3PL_Notification;};
			if (_veh animationPhase "apucontrol" < 0.5) exitwith {[("STR_A3PL_QuickActions_Vehicles_APUControlNotOnAPUBoost" call A3PL_Localize), Color_Red] call A3PL_Notification;};
			if (_veh animationPhase "gen1" < 0.5) exitwith {[("STR_A3PL_QuickActions_Vehicles_APUisOff" call A3PL_Localize), Color_Red] call A3PL_Notification;};
			if (_veh animationPhase "ctail" > 0.5) exitwith {[("STR_A3PL_QuickActions_Vehicles_HeliNotDeplied" call A3PL_Localize), Color_Red] call A3PL_Notification;};
			if (_veh animationPhase "gen2" < 0.5) exitwith {[("STR_A3PL_QuickActions_Vehicles_Generator2NotOnON" call A3PL_Localize), Color_Red] call A3PL_Notification;};
			if (_veh animationPhase "gen3" < 0.5) exitwith {[("STR_A3PL_QuickActions_Vehicles_Generator3NotOnON" call A3PL_Localize), Color_Red] call A3PL_Notification;};
			_veh animate ["gen1",0];
			_veh animate ["ignition_Switch",1];
			[_veh] spawn {
				private ['_veh'];
				_veh = _this select 0;
				sleep 1;
				_veh engineOn true;
			};
			playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
		};
		_veh animate ["ignition_Switch",0];
		playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
	}
],
[
	"A3FL_AS350_CIV",
	"STR_Intersect_BatteryEPU",
	{
		private _veh = player_objintersect;
		if (_veh animationSourcePhase "bat_epu" < 0.9) then {
			 _veh animateSource ["bat_epu",1];
			 playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
		} else {
			_veh animateSource ["bat_epu",0];
			playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
		};
	}
],
[
	"A3FL_AS350_CIV",
	"STR_Intersect_DCTBAT",
	{
		private _veh = player_objintersect;
		if (_veh animationPhase "dct_bat" > 0.5) exitwith {
			_veh animate ["dct_bat",0];
		};
		if (_veh animationPhase "dct_bat" < 0.5) exitwith {
			if (_veh animationPhase "bat_epu" < 0.5) exitwith {[("STR_A3PL_QuickActions_Vehicles_BATEPUOff" call A3PL_Localize), Color_Red] call A3PL_Notification;};
			_veh animate ["dct_bat",1];
			playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
		};
		_veh animate ["dct_bat",0];
		playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
	}
],
[
	"A3FL_AS350_CIV",
	"STR_Intersect_Avionic",
	{
		private _veh = player_objintersect;
		if (_veh animationPhase "avionic" > 0.5) exitwith {
			_veh animate ["avionic",0];
		};
		if (_veh animationPhase "avionic" < 0.5) exitwith {
			if (_veh animationPhase "dct_bat" < 0.5) exitwith {[("STR_A3PL_QuickActions_Vehicles_DCTBATOff" call A3PL_Localize), Color_Red] call A3PL_Notification;};
			_veh animate ["avionic",1];
			playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
		};
		_veh animate ["avionic",0];
		playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
	}
],
[
	"A3FL_AS350_CIV",
	"STR_Intersect_UseGenerator",
	{
		private _veh = player_objintersect;
		if (_veh animationPhase "gene" > 0.5) exitwith {
			_veh animate ["gene",0];
		};
		if (_veh animationPhase "gene" < 0.5) exitwith {
			if (_veh animationPhase "avionic" < 0.5) exitwith {[("STR_A3PL_QuickActions_Vehicles_AvionicOff" call A3PL_Localize), Color_Red] call A3PL_Notification;};
			_veh animate ["gene",1];
			playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
		};
		_veh animate ["gene",0];
		playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
	}
],
[
	"A3FL_AS350_CIV",
	"STR_Intersect_Start",
	{
		private _veh = player_objintersect;
		if (_veh animationPhase "ignition" > 0.5) exitwith {
			_veh animate ["ignition",0];
		};
		if (_veh animationPhase "ignition" < 0.5) exitwith {
			if (_veh animationPhase "gene" < 0.5) exitwith {[("STR_A3PL_QuickActions_Vehicles_GeneratorOff" call A3PL_Localize), Color_Red] call A3PL_Notification;};
			if (_veh animationPhase "avionic" < 0.5) exitwith {[("STR_A3PL_QuickActions_Vehicles_AvionicOff" call A3PL_Localize), Color_Red] call A3PL_Notification;};
			if (_veh animationPhase "dct_bat" < 0.5) exitwith {[("STR_A3PL_QuickActions_Vehicles_DCTBATOff" call A3PL_Localize), Color_Red] call A3PL_Notification;};
			if (_veh animationPhase "bat_epu" < 0.5) exitwith {[("STR_A3PL_QuickActions_Vehicles_BATEPUOff" call A3PL_Localize), Color_Red] call A3PL_Notification;};
			_veh animate ["ignition",1];
			[_veh] spawn {
				private ['_veh'];
				_veh = _this select 0;
				sleep 1;
				_veh engineOn true;
			};
			playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
		};
		_veh animate ["ignition",0];
		playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
	}
],
[
	"A3FL_AS350_CIV",
	"STR_Intersect_Lights",
	{
		private _veh = player_objintersect;
		if (isLightOn _veh) then {
			player action ["lightOff",_veh];
			[("STR_A3PL_QuickActions_Vehicles_LightsTurnedOff" call A3PL_Localize), Color_Red] call A3PL_Notification;
			_veh animateSource ["Head_Lights",0];
			_veh animate ["lightswitch",0];

			private _trailerArray = nearestObjects [(_veh modelToWorld [0,-4,0]), ["A3PL_Trailer_Base"], 6.5];
			_trailerArray = _trailerArray select 0;
			if (!isNil "_trailerArray") then {_trailerArray animate ["Tail_Lights",0];};
		} else {
			player action ["lightOn",_veh];
			[("STR_A3PL_QuickActions_Vehicles_LightsTurnedOn" call A3PL_Localize), Color_Green] call A3PL_Notification;
			_veh animateSource ["Head_Lights",3000];
			_veh animate ["lightswitch",1];
			private _trailerArray = nearestObjects [(_veh modelToWorld [0,-4,0]), ["A3PL_Trailer_Base"], 6.5];
			_trailerArray = _trailerArray select 0;
			if (!isNil "_trailerArray") then
			{
				_trailerArray animate ["Tail_Lights",1];
			};
		};
	}
],
[
	"",
	"STR_Intersect_ToggleFloats",
	{
		private _veh = player_objintersect;
		if (_veh animationSourcePhase "Batteries" < 0.9) exitwith {[("STR_A3PL_QuickActions_Vehicles_BatteryOff" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (_veh animationSourcePhase "Floats" < 0.5) then {
			 _veh animateSource ["Floats",1];
		} else {
			_veh animateSource ["Floats",0];
		};
	}
],
[
	"",
	"STR_Intersect_ToggleFuelpump",
	{
		private _veh = player_objintersect;
		if (_veh animationSourcePhase "Batteries" < 0.9) exitwith {[("STR_A3PL_QuickActions_Vehicles_BatteryOff" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (_veh animationSourcePhase "Fuelpump" < 0.5) then {
			 _veh animateSource ["Fuelpump",1];
		} else {
			_veh animateSource ["Fuelpump",0];
		};
	}
],
[
	"",
	"STR_Intersect_ToggleBattery",
	{
		private _veh = player_objintersect;
		if (_veh animationSourcePhase "Batteries" < 0.9) then {
			 _veh animateSource ["Batteries",1];
		} else {
			_veh animateSource ["Batteries",0];
		};
	}
],
[
	"",
	"STR_Intersect_AdjustFlapsInferior",
	{
		private _veh = player_objintersect;
		if (_veh animationSourcePhase "Batteries" < 0.9) exitwith {[("STR_A3PL_QuickActions_Vehicles_BatteryOff" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (_veh animationSourcePhase "Flaps" < 0.5) then {
			 _veh animateSource ["Flaps",0.5];
			 player action ["flapsDown",_veh];
		} else {
			if (_veh animationSourcePhase "Flaps" == 0.5) then {
				_veh animateSource ["Flaps",1];
				player action ["flapsDown",_veh];
			};
		};
	}
],
[
	"",
	"STR_Intersect_AdjustFlapsSuperior",
	{
		_veh = player_objintersect;
		if (_veh animationSourcePhase "Batteries" < 0.9) exitwith {[("STR_A3PL_QuickActions_Vehicles_BatteryOff" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (_veh animationSourcePhase "Flaps" > 0.5) then {
			 _veh animateSource ["Flaps",0.5];
			 player action ["flapsUp",_veh];
		} else {
			if (_veh animationSourcePhase "Flaps" == 0.5) then {
				_veh animateSource ["Flaps",0];
				player action ["flapsUp",_veh];
			};
		};
	}
],
[
	"",
	"STR_Intersect_GeneratorSwitch",
	{
		private _veh = player_objintersect;
		if (_veh animationSourcePhase "Batteries" < 0.9) exitwith {[("STR_A3PL_QuickActions_Vehicles_BatteryOff" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (_veh animationSourcePhase "Generator" < 0.5) then {
			 _veh animateSource ["Generator",1];
		} else {
			_veh animateSource ["Generator",0];
		};
	}
],
[
	"",
	"STR_Intersect_StartSwitch",
	{
		private _veh = player_objintersect;
		if (_veh animationSourcePhase "Batteries" < 0.9) exitwith {[("STR_A3PL_QuickActions_Vehicles_BatteryOff" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (_veh animationSourcePhase "Generator" < 0.9 && (_veh isKindOf "A3PL_Goose_Base")) exitwith {[("STR_A3PL_QuickActions_Vehicles_GeneratorOff" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (_veh animationSourcePhase "Fuelpump" < 0.9) exitwith {[("STR_A3PL_QuickActions_Vehicles_FuelPumpOff" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (_veh animationSourcePhase "Ignition" < 0.9) then {
			if (!(_veh getVariable ["clearance",false])) exitwith {[("STR_A3PL_QuickActions_Vehicles_NoATCClearance" call A3PL_Localize), Color_Red] call A3PL_Notification;};
			[] spawn {
				private _veh = player_objintersect;
				_veh animateSource ["Ignition",1];
				uiSleep 0.5;
				_veh engineOn true;
			};
		} else {
			_veh animateSource ["Ignition",0];
			_veh engineOn false;
		};
	}
],
[
	"",
	"STR_Intersect_StartSwitch",
	{
		private _veh = player_objintersect;
		if (!(_veh isKindOf "A3PL_Goose_Base")) exitwith {};
		if (_veh animationSourcePhase "goose_bat" < 0.9) exitwith {[("STR_A3PL_QuickActions_Vehicles_BatteryOff" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (_veh animationSourcePhase "goose_gen" < 0.9) exitwith {[("STR_A3PL_QuickActions_Vehicles_GeneratorOff" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (_veh animationSourcePhase "goose_fuelpump" < 0.9) exitwith {[("STR_A3PL_QuickActions_Vehicles_FuelPumpOff" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (_veh animationSourcePhase "goose_ign" == 0.5) then {
			private _lEngRPM1 = _veh animationPhase "rotorL";
			uiSleep 0.1;
			if (_lEngRPM1 == (_veh animationPhase "rotorL")) then {
				_leftEngineOn = false;
			} else {
				_leftEngineOn = true;
			};
			if (_leftEngineOn) then {
				_veh animate ["rotorL",(_veh animationPhase "rotorL")];
				_veh animateSource ["goose_ign",0];
			} else {
				if (!isEngineOn _veh) exitwith {[("STR_A3PL_QuickActions_Vehicles_StatupRightEngineFirst" call A3PL_Localize), Color_Red] call A3PL_Notification;};
				_veh animateSource ["goose_ign",0];
				_veh animate ["rotorL",10000];
			};
			_t = 0;
			waituntil {sleep 1; _t = _t + 1; if (_t > 4) exitwith{}; _veh animationSourcePhase "goose_ign" == 0};
			_veh animateSource ["goose_ign",0.5];
		};
	}
],
[
	"",
	"STR_Intersect_ToggleLadder",
	{[player_objintersect,"ladder",false] call A3PL_Lib_ToggleAnimation;}
],
[
	"",
	"STR_Intersect_MoveLadder",
	{[player_objintersect] spawn A3PL_Pickup_Ladder;}
],
[
	"",
	"STR_Intersect_ClimbLadder" + str 1,
	{
		private _visible = [] call A3PL_Intersect_CanSee;
		if (_visible) then {
			player action ["ladderUp", player_objIntersect, 0, 0];
		} else {
			[("STR_A3PL_QuickActions_Vehicles_YouCantClimbWall" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};
	}
],
[
	"",
	"STR_Intersect_ClimbLadder" + str 2,
	{
		private _visible = [] call A3PL_Intersect_CanSee;
		if (_visible) then {
			player action ["ladderUp", player_objIntersect, 1, 0];
		} else {
			[("STR_A3PL_QuickActions_Vehicles_YouCantClimbWall" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};
	}
],
[
	"",
	"STR_Intersect_ClimbLadder" + str 3,
	{
		private _visible = [] call A3PL_Intersect_CanSee;
		if (_visible) then {
			player action ["ladderUp", player_objIntersect, 2, 0];
		} else {
			[("STR_A3PL_QuickActions_Vehicles_YouCantClimbWall" call A3PL_Localize), Color_Red] call A3PL_Notification;
		}
	}
],
[
	"",
	"STR_Intersect_ClimbLadder" + str 4,
	{
		private _visible = [] call A3PL_Intersect_CanSee;
		if (_visible) then {
			player action ["ladderUp", player_objIntersect, 3, 0];
		} else {
			[("STR_A3PL_QuickActions_Vehicles_YouCantClimbWall" call A3PL_Localize), Color_Red] call A3PL_Notification;
		}
	}
],
[
	"",
	"STR_Intersect_ClimbLadder" + str 5,
	{
		private _visible = [] call A3PL_Intersect_CanSee;
		if (_visible) then {
			player action ["ladderUp", player_objIntersect, 4, 0];
		} else {
			[("STR_A3PL_QuickActions_Vehicles_YouCantClimbWall" call A3PL_Localize), Color_Red] call A3PL_Notification;
		}
	}
],
[
	"",
	"STR_Intersect_ClimbLadderDown" + str 1,
	{
		private _visible = [] call A3PL_Intersect_CanSee;
		if (_visible) then {
			player action ["ladderUp", player_objIntersect, 0, 1];
		} else {
			[("STR_A3PL_QuickActions_Vehicles_YouCantDownWall" call A3PL_Localize), Color_Red] call A3PL_Notification;
		}
	}
],

[
	"",
	"STR_Intersect_ClimbLadderDown" + str 2,
	{
		private _visible = [] call A3PL_Intersect_CanSee;
		if (_visible) then {
			player action ["ladderUp", player_objIntersect, 1, 1];
		} else {
			[("STR_A3PL_QuickActions_Vehicles_YouCantDownWall" call A3PL_Localize), Color_Red] call A3PL_Notification;
		}
	}
],
[
	"",
	"STR_Intersect_ClimbLadderDown" + str 3,
	{
		private _visible = [] call A3PL_Intersect_CanSee;
		if (_visible) then {
			player action ["ladderUp", player_objIntersect, 2, 1];
		} else {
			[("STR_A3PL_QuickActions_Vehicles_YouCantDownWall" call A3PL_Localize), Color_Red] call A3PL_Notification;
		}
	}
],
[
	"",
	"STR_Intersect_ClimbLadderDown" + str 4,
	{
		private _visible = [] call A3PL_Intersect_CanSee;
		if (_visible) then {
			player action ["ladderUp", player_objIntersect, 3, 1];
		} else {
			[("STR_A3PL_QuickActions_Vehicles_YouCantDownWall" call A3PL_Localize), Color_Red] call A3PL_Notification;
		}
	}
],
[
	"",
	"STR_Intersect_ClimbLadderDown" + str 5,
	{
		private _visible = [] call A3PL_Intersect_CanSee;
		if (_visible) then {
			player action ["ladderUp", player_objIntersect, 4, 1];
		} else {
			[("STR_A3PL_QuickActions_Vehicles_YouCantDownWall" call A3PL_Localize), Color_Red] call A3PL_Notification;
		}
	}
],
[
	"",
	"STR_Intersect_Collision_Lights",
	{
		private _veh = player_objIntersect;
		private _collisionLightOn = _veh getVariable ["collisionLightOn",false];
		if (_collisionLightOn) then {
			player action ["CollisionLightOff", _veh];
			_veh animateSource ["collision_lights",0];
			_veh setVariable ["collisionLightOn",false,true];
			[("STR_A3PL_QuickActions_Vehicles_CollisionsLightsTurnedOff" call A3PL_Localize), Color_Red] call A3PL_Notification;
		} else {
			player action ["CollisionLightOn", _veh];
			_veh animateSource ["collision_lights",1];
			_veh setVariable ["collisionLightOn",true,true];
			[("STR_A3PL_QuickActions_Vehicles_CollisionsLightsTurnedOn" call A3PL_Localize), Color_Green] call A3PL_Notification;
		};
	}
],
[
    "",
    "STR_Intersect_Ramp",
    {
        private _veh = player_objintersect;
        if ((_veh animationSourcePhase "truck_flatbed") < 0.3) then {
            [_veh,0] spawn A3PL_Vehicle_TowTruck_Ramp_down;
        } else {
			[_veh,-0.230112] spawn A3PL_Vehicle_TowTruck_Ramp_up;
        };
    }
],
[
    "",
    "STR_Intersect_ToggleRearSpotlight",
    {
		private _veh = player_objintersect;
		if (_veh animationPhase "Spotlights" < 0.5) then {
			_veh animate ["Spotlight_Switch",1];_veh animate ["Spotlights",1];
			if (_veh animationSourcePhase "Head_Lights" < 0.5) then{player action ["lightOn",_veh];};
		} else {
			_veh animate ["Spotlight_Switch",0];_veh animate ["Spotlights",0];
			if (_veh animationSourcePhase "Head_Lights" < 0.5) then{player action ["lightOff",_veh];};
		};
    }
],
[
    "",
    "STR_Intersect_EnterEngineer",
    {
		private _veh = player_objIntersect;
		_veh lock 0;
		player action ["getInCargo", _veh, 0];
		_veh lock 2;
    }
],
[
    "",
    "STR_Intersect_EnterCaptain",
    {
		private _veh = player_objIntersect;
		_veh lock 0;
		player action ["getInTurret", _veh, [1]];
		_veh lock 2;
    }
],
[
    "",
    "STR_Intersect_EnterGunner2",
    {
		private _veh = player_objIntersect;
		_veh lock 0;
		player action ["getInTurret", _veh, [0]];
		_veh lock 2;
    }
],
[
    "",
    "STR_Intersect_EnterGunnerFront",
    {
    	private _veh = player_objIntersect;
		_veh lock 0;
		player action ["getInTurret", _veh, [2]];
		_veh lock 2;
    }
],
[
	"",
	"STR_Intersect_SwitchPlatformLeft",
	{
		private _veh = player_objIntersect;
		if (_veh animationPhase "Platform_1" isEqualTo 0) then {
			_veh animate ["Platform_1",1];
		} else {
			_veh animate ["Platform_1",0];
		};
	}
],
[
	"",
	"STR_Intersect_SwitchPlatformRight",
	{
		private _veh = player_objIntersect;
		if (_veh animationPhase "Platform_2" isEqualTo 0) then {
			_veh animate ["Platform_2",1];
		} else{
			_veh animate ["Platform_2",0];
		};
	}
],
[
	"",
	"STR_Intersect_TakeLifeBuoyLeft",
	{
		[] spawn {
			private _veh = player_objIntersect;
			if (_veh animationPhase "Lifebuoy_1" isEqualTo 0) then
			{
				_veh animate ["Lifebuoy_1",1];
				["Lifebuoy",1] call A3PL_Inventory_add;
				["Lifebuoy"] call A3PL_Inventory_Use;
				sleep 2;
				private _Lifebuoy = Player_Item;
				_Lifebuoy setVariable ["locked",false,true];
				private _rope = ropeCreate [_veh, "Lifebuoy_1_point", _Lifebuoy, [0.00587467,0.55251,0.329934], 15];
				_veh setVariable ["Left_rope",_rope,true];
			};
		};
	}
],
[
	"",
	"STR_Intersect_PutLifeBuoyLeft2",
	{
		private _veh = player_objIntersect;
		if (_veh animationPhase "Lifebuoy_1" == 1 && player_itemClass == "Lifebuoy") then
		{
			[false] call A3PL_Inventory_PutBack;
			["Lifebuoy",-1] call A3PL_Inventory_add;
			_veh animate ["Lifebuoy_1",0];
			private _rope = _veh getVariable "Left_rope";
			ropeDestroy _rope;
		};
	}
],
[
	"",
	"STR_Intersect_TakeLifeBuoyRight",
	{
		[] spawn {
			private _veh = player_objIntersect;
			if (_veh animationPhase "Lifebuoy_2" == 0) then
			{
				_veh animate ["Lifebuoy_2",1];
				["Lifebuoy",1] call A3PL_Inventory_add;
				["Lifebuoy"] call A3PL_Inventory_Use;
				sleep 2;
				private _Lifebuoy = Player_Item;
				private _rope = ropeCreate [_veh, "Lifebuoy_2_point", _Lifebuoy, [0.00587467,0.55251,0.329934], 15];
				_Lifebuoy setVariable ["locked",false,true];
				_veh setVariable ["Right_rope",_rope,true];
			};
		};
	}
],
[
	"",
	"STR_Intersect_PutLifeBuoyRight2",
	{
		private _veh = player_objIntersect;
		if (((_veh animationPhase "Lifebuoy_2") isEqualTo 1) && (player_itemClass isEqualTo "Lifebuoy")) then {
			[false] call A3PL_Inventory_PutBack;
			["Lifebuoy",-1] call A3PL_Inventory_add;
			_veh animate ["Lifebuoy_2",0];
			private _rope = _veh getVariable "Right_rope";
			ropeDestroy _rope;
		};
	}
],
[
    "",
    "STR_Intersect_BackProjectors",
    {
        private _veh = vehicle player;
        if (_veh animationPhase "Ambo_Switch_7" < 0.5) then {
            _veh animate ["Ambo_Switch_7",1];_veh animate ["R_Floodlights",1];
        } else {
            _veh animate ["Ambo_Switch_7",0];_veh animate ["R_Floodlights",0];
        };
    }
],
[
    "",
    "STR_Intersect_InteriorLights",
    {
        private _veh = vehicle player;
        if (_veh animationPhase "Ambo_Switch_10" < 0.5) then {
            _veh animate ["Ambo_Switch_10",1];_veh animate ["Interior_Lights",1];
        } else {
            _veh animate ["Ambo_Switch_10",0];_veh animate ["Interior_Lights",0];
        };
    }
],
[
    "",
    "STR_Intersect_UseStretcher",
    {
        private _veh = player_objIntersect;
        if (_veh animationSourcePhase "Stretcher" isEqualTo 0) then {
       		_veh animateSource ["Stretcher", 21];
       	} else {
       		_veh animateSource ["Stretcher", 0];
       	};
    }
],
[
    "",
    "STR_Intersect_PutStretcher",
    {
		private _veh = player_objIntersect;
		private _ambo = nearestObjects[player, ["A3PL_E350","jonzie_ambulance"],5];
		if(count _ambo == 0) exitwith {};
		_ambo = _ambo select 0;
		_ambo animateSource ["Stretcher", 0];
		deleteVehicle _veh;
    }
],
[
	"",
	"STR_Intersect_TakeLadder",
	{
		private _veh = player_objIntersect;
		if (_veh animationPhase "Ladder" isEqualTo 0) then {
			_veh animate ["Ladder",1];
			private _Ladder = createVehicle ["A3PL_Ladder", position player, [], 0, "NONE"];
			_Ladder setVariable ["class","Ladder",true];
			[_Ladder] spawn A3PL_Pickup_Ladder;
		};
	}
],
[
	"",
	"STR_Intersect_PutLadder",
	{
		private _veh = player_objIntersect;
		private _Ladder = nearestObject [player, "A3PL_Ladder"];
		if ((_veh animationPhase "Ladder") isEqualTo 1) then	{
			detach _Ladder;
			deleteVehicle _Ladder;
			_veh animate ["Ladder",0];
		};
	}
],
[
	"",
	"STR_Intersect_TakeHose" + str 1,
	{
		private _veh = player_objIntersect;
		if (_veh animationPhase "Hose_1" < 0.99) then {
			private _val = _veh animationPhase "Hose_1";
			private _valu = _val + 0.25;
			if (_valu >= 1) then {_valu = 1};
			_veh animate ["Hose_1",_valu];
			["FD_Hose",1] call A3PL_Inventory_add;
			["FD_Hose"] call A3PL_Inventory_Use;
		};
	}
],
[
	"",
	"STR_Intersect_TakeHose" + str 2,
	{
		private _veh = player_objIntersect;
		if (_veh animationPhase "Hose_2" < 0.99) then {
			private _val = _veh animationPhase "Hose_2";
			private _valu = _val + 0.25;
			if (_valu >= 1) then {_valu = 1};
			_veh animate ["Hose_2",_valu];
			["FD_Hose",1] call A3PL_Inventory_add;
			["FD_Hose"] call A3PL_Inventory_Use;
		};
	}
],
[
	"",
	"STR_Intersect_TakeHose" + str 3,
	{
		private _veh = player_objIntersect;
		if (_veh animationPhase "Hose_3" < 0.99) then
		{
			private _val = _veh animationPhase "Hose_3";
			private _valu = _val + 0.25;
			if (_valu >= 1) then {_valu = 1};
			_veh animate ["Hose_3",_valu];
			["FD_Hose",1] call A3PL_Inventory_add;
			["FD_Hose"] call A3PL_Inventory_Use;
		};
	}
],
[
	"",
	"STR_Intersect_TakeHose" + str 4,
	{
		private _veh = player_objIntersect;
		if (_veh animationPhase "Hose_4" < 0.99) then {
			private _val = _veh animationPhase "Hose_4";
			private _valu = _val + 0.25;
			if (_valu >= 1) then {_valu = 1};
			_veh animate ["Hose_4",_valu];
			["FD_Hose",1] call A3PL_Inventory_add;
			["FD_Hose"] call A3PL_Inventory_Use;
		};
	}
],
[
	"",
	"STR_Intersect_TakeHose" + str 5,
	{
		private _veh = player_objIntersect;
		if (_veh animationPhase "Hose_5" < 0.99) then
		{
			private _val = _veh animationPhase "Hose_5";
			private _valu = _val + 0.25;
			if (_valu >= 1) then {_valu = 1};
			_veh animate ["Hose_5",_valu];
			["FD_Hose",1] call A3PL_Inventory_add;
			["FD_Hose"] call A3PL_Inventory_Use;
		};
	}
],
[
	"",
	"STR_Intersect_PutHose" + str 1,
	{
		private _veh = player_objIntersect;
		if (player_itemClass == "FD_Hose") then {
			[false] call A3PL_Inventory_PutBack;
			["FD_Hose",-1] call A3PL_Inventory_add;
			private _val = _veh animationPhase "Hose_1";
			private _valu = _val - 0.25;
			if (_valu <= 0) then {_valu = 0};
			_veh animate ["Hose_1",_valu];
		};
	}
],
[
	"",
	"STR_Intersect_PutHose" + str 2,
	{
		private _veh = player_objIntersect;
		if (player_itemClass == "FD_Hose") then
		{
			[false] call A3PL_Inventory_PutBack;
			["FD_Hose",-1] call A3PL_Inventory_add;
			private _val = _veh animationPhase "Hose_2";
			private _valu = _val - 0.25;
			if (_valu <= 0) then {_valu = 0};
			_veh animate ["Hose_2",_valu];
		};
	}
],
[
	"",
	"STR_Intersect_PutHose" + str 3,
	{
		private _veh = player_objIntersect;
		if (player_itemClass == "FD_Hose") then {
			[false] call A3PL_Inventory_PutBack;
			["FD_Hose",-1] call A3PL_Inventory_add;
			private _val = _veh animationPhase "Hose_3";
			private _valu = _val - 0.25;
			if (_valu <= 0) then {_valu = 0};
			_veh animate ["Hose_3",_valu];
		};
	}
],
[
	"",
	"STR_Intersect_PutHose" + str 4,
	{
		private _veh = player_objIntersect;
		if (player_itemClass == "FD_Hose") then
		{
			[false] call A3PL_Inventory_PutBack;
			["FD_Hose",-1] call A3PL_Inventory_add;
			private _val = _veh animationPhase "Hose_4";
			private _valu = _val - 0.25;
			if (_valu <= 0) then {_valu = 0};
			_veh animate ["Hose_4",_valu];
		};
	}
],
[
	"",
	"STR_Intersect_PutHose" + str 5,
	{
		private _veh = player_objIntersect;
		if (player_itemClass == "FD_Hose") then
		{
			[false] call A3PL_Inventory_PutBack;
			["FD_Hose",-1] call A3PL_Inventory_add;
			private _val = _veh animationPhase "Hose_5";
			private _valu = _val - 0.25;
			if (_valu <= 0) then {_valu = 0};
			_veh animate ["Hose_5",_valu];
		};
	}
],
[
	"",
	"STR_Intersect_ToggleLIDController",
	{
		private _veh = player_objIntersect;
		if (_veh animationPhase "Controller_Cover" == 0) then {
			_veh animate ["Controller_Cover",1];
		} else {
			_veh animate ["Controller_Cover",0];
		};
	}
],
[
	"",
	"STR_Intersect_LadderStabilizerDSFront",
	{
		private _veh = vehicle player;
		if (_veh animationPhase "Outrigger_1" == 0) then {
			_veh animate ["Outrigger_1",1];_veh animate ["Outrigger_1_1_Flash",1];_veh animate ["Outrigger_1_2_Flash",1];_veh animate ["FT_Switch_1",1];
		} else {
			_veh animate ["Outrigger_1",0];_veh animate ["Outrigger_1_1_Flash",0];_veh animate ["Outrigger_1_2_Flash",0];_veh animate ["FT_Switch_1",0];
		};
	}
],
[
	"",
	"STR_Intersect_LadderStabilizerDSRear",
	{
		private _veh = vehicle player;
		if (_veh animationPhase "Outrigger_2" == 0) then {
			_veh animate ["Outrigger_2",1];_veh animate ["Outrigger_2_1_Flash",1];_veh animate ["Outrigger_2_2_Flash",1];_veh animate ["FT_Switch_2",1];
		} else {
			_veh animate ["Outrigger_2",0];_veh animate ["Outrigger_2_1_Flash",0];_veh animate ["Outrigger_2_2_Flash",0];_veh animate ["FT_Switch_2",0];
		};
	}
],
[
	"",
	"STR_Intersect_LadderStabilizerPSFront",
	{
		private _veh = vehicle player;
		if (_veh animationPhase "Outrigger_3" == 0) then {
			_veh animate ["Outrigger_3",1];_veh animate ["Outrigger_3_1_Flash",1];_veh animate ["Outrigger_3_2_Flash",1];_veh animate ["FT_Switch_3",1];
		} else {
			_veh animate ["Outrigger_3",0];_veh animate ["Outrigger_3_1_Flash",0];_veh animate ["Outrigger_3_2_Flash",0];_veh animate ["FT_Switch_3",0];
		};
	}
],
[
	"",
	"STR_Intersect_LadderStabilizerPSRear",
	{
		private _veh = vehicle player;
		if (_veh animationPhase "Outrigger_4" == 0) then {
			_veh animate ["Outrigger_4",1];_veh animate ["Outrigger_4_1_Flash",1];_veh animate ["Outrigger_4_2_Flash",1];_veh animate ["FT_Switch_4",1];
		} else {
			_veh animate ["Outrigger_4",0];_veh animate ["Outrigger_4_1_Flash",0];_veh animate ["Outrigger_4_2_Flash",0];_veh animate ["FT_Switch_4",0];
		};
	}
],
[
	"",
	"STR_Intersect_LadderRiseLowerDS",
	{
		private _veh = vehicle player;
		if (_veh animationPhase "OutriggerFoot_1" isEqualTo 0) then {
			_veh animate ["OutriggerFoot_1",1];_veh animate ["OutriggerFoot_2",1];_veh animate ["FT_Switch_5",1];
		} else {
			_veh animate ["OutriggerFoot_1",0];_veh animate ["OutriggerFoot_2",0];_veh animate ["FT_Switch_5",0];
		};
	}
],
[
	"",
	"STR_Intersect_LadderRiseLowerPS",
	{
		private _veh = vehicle player;
		if (_veh animationPhase "OutriggerFoot_3" isEqualTo 0) then {
			_veh animate ["OutriggerFoot_3",1];_veh animate ["OutriggerFoot_4",1];_veh animate ["FT_Switch_6",1];
		} else {
			_veh animate ["OutriggerFoot_3",0];_veh animate ["OutriggerFoot_4",0];_veh animate ["FT_Switch_6",0];
		};
	}
],
[
	"",
	"STR_Intersect_PSFloodlights",
	{
		private _veh = vehicle player;
		if (_veh animationPhase "PS_Floodlights" isEqualTo 0) then {
			_veh animate ["FT_Switch_9",1];_veh animate ["PS_Floodlights",1];
		} else {
			_veh animate ["FT_Switch_9",0];_veh animate ["PS_Floodlights",0];
		};
		if (_veh animationPhase "ft_switch_9" < 0.5) then {
			_veh animate ["ft_switch_9",1];_veh animate ["driver_floodlight",1];
			_veh setHit ["light_s",1];
		} else {
			_veh animate ["ft_switch_9",0];_veh animate ["driver_floodlight",0];
			_veh setHit ["light_s",0];
		};
	}
],
[
	"",
	"STR_Intersect_DSFloodlights",
	{
		private _veh = vehicle player;
		if (_veh animationPhase "DS_Floodlights" isEqualTo 0) then {
			_veh animate ["FT_Switch_8",1];_veh animate ["DS_Floodlights",1];
		} else {
			_veh animate ["FT_Switch_8",0];_veh animate ["DS_Floodlights",0];
		};
		if (_veh animationPhase "ft_switch_8" < 0.5) then {
			_veh animate ["ft_switch_8",1];_veh animate ["passenger_floodlight",1];
			_veh setHit ["light_s2",1];
		} else {
			_veh animate ["ft_switch_8",0];_veh animate ["passenger_floodlight",0];
			_veh setHit ["light_s2",0];
		};
	}
],
[
	"",
	"STR_Intersect_PerimeterLight",
	{
		private _veh = vehicle player;
		if (_veh animationPhase "FT_Switch_10" isEqualTo 0) then {
			_veh animate ["FT_Switch_10",1];_veh animate ["DS_Floodlights",1];_veh animate ["PS_Floodlights",1];_veh animate ["FT_Switch_8",0];_veh animate ["FT_Switch_9",0];
		} else {
			_veh animate ["FT_Switch_10",0];_veh animate ["DS_Floodlights",0];_veh animate ["PS_Floodlights",0];
		};
	}
],
[
	"",
	"STR_Intersect_LadderLight",
	{
		private _veh = vehicle player;
		if (_veh animationPhase "Ladder_Spotlight" isEqualTo 0) then {
			_veh animate ["FT_Switch_11",1];_veh animate ["Ladder_Spotlight",1];
		} else {
			_veh animate ["FT_Switch_11",0];_veh animate ["Ladder_Spotlight",0];
		};
	}
],
[
	"",
	"STR_Intersect_LadderCamera",
	{
		private _veh = vehicle player;
		if (_veh animationPhase "Ladder_Cam" isEqualTo 0) then {
			_veh animate ["FT_Switch_12",1];_veh animate ["Ladder_Cam",1];_veh animate ["Reverse_Cam",0];
		} else {
			_veh animate ["FT_Switch_12",0];_veh animate ["Ladder_Cam",0];
		};
	}
],
[
    "",
    "STR_Intersect_EnterLadderOperator",
    {
        private _veh = player_objIntersect;
		_veh lock 0;
		player action ["getInTurret", _veh, [0]];
		_veh lock 2;
    }
],
[
	"",
	"STR_Intersect_ToggleLadderSupport",
	{
		private _veh = player_objIntersect;
		if ((_veh animationSourcePhase "Ladder_Holder") isEqualTo 0) then{
			_veh animateSource  ["Ladder_Holder", 1];
		} else {
			_veh animateSource  ["Ladder_Holder", 0];
		};
	}
],
[
	"",
	"STR_Intersect_UsePump",
	{
		private _veh = player_objIntersect;
		if (!(_veh isKindOf "Car")) exitwith {};
		if (_veh animationPhase "FT_Pump_Switch" isEqualTo 0) then {
			_veh animate ["FT_Pump_Switch", 1];
			_PumpSound = createSoundSource ["A3PL_FT_Pump", getpos _veh, [], 0];
			_PumpSound attachTo [_veh, [0, 0, 0], "FT_Pump_Switch"];
			_veh setVariable ["PumpSound",_PumpSound,true];
			[_veh] spawn A3PL_FD_LadderHeavyLoop;
			if(typeOf _veh isEqualTo "A3FL_T440_Water_Tanker") then {[_veh] spawn A3PL_FD_TankerLoop;};
		} else {
			_veh animate ["FT_Pump_Switch", 0];
			_PumpSound = _veh getVariable "PumpSound";
			deleteVehicle _PumpSound;
		};
	}
],
[
	"A3PL_Pierce_Pumper",
	"STR_Intersect_OpenCloseExit",
	{
		private _veh = player_objintersect;
		private _animName = player_nameintersect;
		if (_animName isEqualTo "") exitwith {};
		if (_animName == "ft_lever_8" && (_veh animationPhase "ft_lever_8" < 0.5)) then {
			[_veh] spawn A3PL_FD_EngineLoop;
		};
		[_veh,_animName,false] call A3PL_Lib_ToggleAnimation;
	}
],
[
	"A3PL_Silverado_FD_Brush",
	"STR_Intersect_OpenCloseExit",
	{
		private _veh = player_objintersect;
		private _animName = player_nameintersect;
		if (_animName isEqualTo "") exitwith {};
		if (((_animName == "bt_lever_1") && (_veh animationPhase "bt_lever_1" < 0.5))) then {
			[_veh] spawn A3PL_FD_BrushLoop;
		};
		[_veh,_animName,false] call A3PL_Lib_ToggleAnimation;
	}
],
[
    "EC_F450_Brush",
    "STR_Intersect_OpenCloseExit",
    {
        private _veh = player_objintersect;
        private _animName = player_nameintersect;
        if (_animName isEqualTo "") exitwith {};
        if (((_animName == "bt_lever_1") && (_veh animationPhase "bt_lever_1" < 0.5))) then {
            [_veh] spawn A3PL_FD_BrushLoop;
        };
        [_veh,_animName,false] call A3PL_Lib_ToggleAnimation;
    }
],
[
	"",
	"STR_Intersect_OpenCloseEntrance",
	{
		private _veh = player_objintersect;
		private _animName = player_nameintersect;

		if(_animName isEqualTo "") exitWith {};
		if((typeOf _veh) isEqualTo "A3PL_Pierce_Pumper") then {
			if (_animName isEqualTo "ft_lever_8" && (_veh animationPhase "ft_lever_8" < 0.5)) then {
				[_veh] spawn A3PL_FD_EngineLoop;
			};
		};
		if((typeOf _veh) IN ["A3PL_Silverado_FD_Brush","EC_F450_Brush"]) then {
			if (((_animName isEqualTo "bt_lever_1") && (_veh animationPhase "bt_lever_1" < 0.5))) then {
				[_veh] spawn A3PL_FD_BrushLoop;
			};
		};
		[_veh,_animName,false] call A3PL_Lib_ToggleAnimation;
	}
],
[
	"A3PL_Pierce_Heavy_Ladder",
	"STR_Intersect_ConnectHoseBalanceIn",
	{[player_objintersect,player_nameintersect] call A3PL_FD_ConnectHoseAdapter;}
],
[
	"",
	"STR_Intersect_ConnectHoseToEngine",
	{[player_objintersect,player_nameintersect] call A3PL_FD_ConnectHoseAdapter;}
],
[
	"",
	"STR_Intersect_ConnectHoseToDrain",
	{[player_objintersect,player_nameintersect] call A3PL_FD_ConnectHoseAdapter;}
],
[
    "",
    "STR_Intersect_ChangePriceAvailability",
    {
		private _veh = player_objintersect;
		if ((_veh animationSourcePhase "Fair_Available") < 0.5) then {
			_veh animateSource ["Fair_Available",1];
		} else {
			_veh animateSource ["Fair_Available",0];
		};
    }
],
[
	"",
	"STR_Intersect_StartFair",
	{[player_objIntersect] call A3PL_JobTaxi_FareStart;}
],
[
	"",
	"STR_Intersect_Pause",
	{[player_objIntersect] call A3PL_JobTaxi_FarePause;}
],
[
	"",
	"STR_Intersect_StopFair",
	{[player_objIntersect] call A3PL_JobTaxi_FarePause;}
],
[
	"",
	"STR_Intersect_ResetFair",
	{[player_objIntersect] call A3PL_JobTaxi_FareReset;}
],
// [
// 	"",
// 	"Enter as Co-Driver",
// 	{
// 		[player_objIntersect] spawn {
// 			params [["_veh",objNull,[objNull]]];
// 			_veh animateDoor ["Door_RF", 1];
// 			sleep 0.4;
// 			player moveInGunner _veh;
// 			_veh animateDoor ["Door_RF", 0];
// 		};
// 	}
// ],
[
    "A3PL_P362",
    "STR_Intersect_PneumaticSuspension",
    {
        private _veh = player_objintersect;
        if (_veh animationSourcePhase "ASC" < 0.8) then {
            _veh animate ["ASC_Switch",1];
			_veh animateSource ["ASC",1];
			_veh setCenterOfMass [[0.00631652,0.1,-1.03015],8];
			_veh setMass [35000,8];
        } else {
            _veh animate ["ASC_Switch",0];
			_veh animateSource ["ASC",0];
			_veh setMass [13000,8];
			_veh setCenterOfMass [[0.00631652,-0.28197,-1.03015],8];
        };
    }
],
[
    "",
    "STR_Intersect_LightPathRight",
    {
        private _veh = player_objintersect;
        if (_veh animationPhase "PD_Switch_9" < 0.5) then {
            _veh animate ["PD_Switch_9",1];
			_veh animate ["DS_Floodlights",1];
        } else {
            _veh animate ["PD_Switch_9",0];
			_veh animate ["DS_Floodlights",0];
        };
    }
],
[
    "",
    "STR_Intersect_LightPathLeft",
    {
        private _veh = player_objintersect;
        if (_veh animationPhase "PD_Switch_10" < 0.5) then {
            _veh animate ["PD_Switch_10",1];_veh animate ["PS_Floodlights",1];
        } else {
            _veh animate ["PD_Switch_10",0];_veh animate ["PS_Floodlights",0];
        };
    }
],
[
    "",
    "STR_Intersect_SwitchSpotlight2",
    {
        private _veh = player_objintersect;
        if (_veh animationSourcePhase "Spotlight" < 0.5 && _veh animationPhase "Spotlight_Addon" > 0.5) then {
            _veh animateSource ["Spotlight",1];
			if (_veh animationSourcePhase "Head_Lights" < 0.5) then{player action ["lightOn",_veh];};
        } else {
            _veh animateSource ["Spotlight",0];
			if (_veh animationSourcePhase "Head_Lights" < 0.5) then{player action ["lightOff",_veh];};
        };

    }
],
[
    "",
    "STR_Intersect_ToggleRadar",
    {
        private _veh = player_objintersect;
        if (_veh animationPhase "Radar_Master" < 0.5) then {
            _veh animate ["Radar_Master",1];
			if ((_veh animationPhase "Radar_Front" < 0.5) && (_veh animationPhase "Radar_Rear" < 0.5)) then {_veh animate ["Radar_Front",1];};
        } else {
            _veh animate ["Radar_Master",0];
        };
    }
],
[
    "",
    "STR_Intersect_RadarBack",
    {
        private _veh = player_objintersect;
		if (_veh animationPhase "Radar_Rear" < 0.5) then {
            _veh animate ["Radar_Rear",1];
			_veh animate ["Radar_Front",0];
			if (player == driver _veh) then {
				_veh setVariable ["forward",false,false];
			} else {
				_veh setVariable ["forward",false,true];
			};
        };
    }
],
[
    "",
    "STR_Intersect_RadarFront",
    {
        _veh = player_objintersect;
		if (_veh animationPhase "Radar_Front" < 0.5) then {
            _veh animate ["Radar_Front",1];
			_veh animate ["Radar_Rear",0];
			if (player == driver _veh) then {
				_veh setVariable ["forward",true,false];
			} else {
				_veh setVariable ["forward",true,true];
			};
        };
    }
],
[
	"",
	"STR_Intersect_ResetLockFast",
	{
		private _veh = vehicle player;
		if (player == driver _veh) then {
			_veh setVariable ["lockfast",nil,false];
			_veh setVariable ["locktarget",nil,false];
			[_veh,"lockfast",0] call A3PL_Police_RadarSet;
			[_veh,"locktarget",0] call A3PL_Police_RadarSet;
		} else {
			_veh setVariable ["lockfast",nil,true];
			_veh setVariable ["locktarget",nil,true];
			[_veh,"lockfast",0] call A3PL_Police_RadarSet;
			[_veh,"locktarget",0] call A3PL_Police_RadarSet;
		};
	}
],
[
    "",
    "STR_Intersect_ToggleComputer",
    {
        private _veh = player_objintersect;
        if (_veh animationPhase "Laptop_Top" < 0.5) then {
            _veh animateSource ["Laptop_Top",1];
        } else {
            _veh animateSource ["Laptop_Top",0];
        };
    }
],
[
    "",
    "STR_Intersect_ComputerAccess",
    {
		private _job = player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
		if((typeOf player_objintersect) IN ["Land_A3FL_DOC_Gate","land_a3pl_ch"]) then {
			if !(_job IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize)]) exitWith {[("STR_A3PL_QuickActions_Vehicles_OnlyFactionsCanUseComputers" call A3PL_Localize), Color_Red] call A3PL_Notification;};
			if (isNull (findDisplay 211)) then {
				[player_objintersect] call A3PL_Police_OpenMDT;
			};
		} else {
			if (isNull (findDisplay 211)) then {
				[vehicle player] call A3PL_Police_OpenMDT;
			};
		};
    }
],
[
    "",
    "STR_Intersect_DriveAccess",
    {
		private _job = player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
		if !(_job IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize)]) exitWith {[("STR_A3PL_QuickActions_Vehicles_OnlyFactionsCanUseDrive" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		[] spawn A3PL_FilesManager_Computer;
    }
],
[
    "",
    "STR_Intersect_RotateComputer",
    {
        _veh = player_objintersect;
        if (_veh animationPhase "Laptop" < 0.5) then {
            _veh animate ["Laptop",1];
        } else {
            _veh animate ["Laptop",0];
        };
    }
],
[
    "",
	"STR_Intersect_RoadLights",
    {
        private _veh = player_objintersect;
        if (_veh animationSourcePhase "High_Beam" == 0) then {
            _veh animate ["High_Beam_Switch",1];_veh animateSource ["High_Beam",1];
        } else {
            _veh animate ["High_Beam_Switch",0];_veh animateSource ["High_Beam",0];
        };
    }
],
[
	"",
	"STR_Intersect_CameraReverse",
	{
		private _veh = player_objintersect;
		if (_veh animationPhase "Reverse_Cam" == 0) then {
			_veh animate ["Reverse_Cam",1];
		} else {
			_veh animate ["Reverse_Cam",0];
		};
	}
],
[
    "",
    "STR_Intersect_UseSiren",
    {
        private _veh = player_objintersect;
        if (_veh animationPhase "FT_Switch_33" < 0.5) then  {
            [5] call A3PL_Vehicle_SirenHotkey;
        } else {
            [5] call A3PL_Vehicle_SirenHotkey;
						[_veh] call A3PL_Vehicle_SoundSourceClear;
        };
    }
],
[
    "",
    "STR_Intersect_ElectricSiren",
    {
        private _veh = player_objintersect;
        if (_veh animationPhase "FT_Switch_34" < 0.5) then {
            [6] call A3PL_Vehicle_SirenHotkey;
        } else {
            [6] call A3PL_Vehicle_SirenHotkey;
			[_veh] call A3PL_Vehicle_SoundSourceClear;
        };
    }
],
[
    "",
    "STR_Intersect_ElectricSiren",
    {
        private _veh = player_objintersect;
        if (_veh animationPhase "FT_Switch_35" < 0.5) then {
            [7] call A3PL_Vehicle_SirenHotkey;
        } else {
            [7] call A3PL_Vehicle_SirenHotkey;
			[_veh] call A3PL_Vehicle_SoundSourceClear;
        };
    }
],
[
    "",
    "STR_Intersect_UseSirenInstructions",
    {
        private _veh = player_objintersect;
        if (_veh animationPhase "FT_Switch_36" < 0.5) then {
            [8] call A3PL_Vehicle_SirenHotkey;
        } else {
            [8] call A3PL_Vehicle_SirenHotkey;
			[_veh] call A3PL_Vehicle_SoundSourceClear;
        };
    }
],
[
    "",
    "STR_Intersect_UseT3Yelp",
    {
        private _veh = player_objintersect;
        if (_veh animationPhase "FT_Switch_37" < 0.5) then {
            [9] call A3PL_Vehicle_SirenHotkey;
        } else {
            [9] call A3PL_Vehicle_SirenHotkey;
			[_veh] call A3PL_Vehicle_SoundSourceClear;
        };
    }
],
[
    "",
    "STR_Intersect_UseGeneral",
    {[2] call A3PL_Vehicle_SirenHotkey;}
],
[
    "",
    "STR_Intersect_SwitchLightbar",
    {
       private _veh = player_objintersect;
        if (_veh animationSourcePhase "lightbar" < 0.5) then {
            [2] call A3PL_Vehicle_SirenHotkey;
        } else {
            [1] call A3PL_Vehicle_SirenHotkey;
        };
    }
],
[
    "",
    "STR_Intersect_SwitchDirectional",
    {
		private _veh = player_objintersect;
		if (_veh animationPhase "Directional_Switch" < 0.5) then {
		    _veh animate ["Directional_Switch",1];_veh animate ["Directional",1];if (_veh animationPhase "Directional_Control_Noob" == 0) then{_veh animate ["Directional_L",1];};if (_veh animationPhase "Directional_Control_Noob" == 17.5) then{_veh animate ["Directional",0];_veh animate ["Directional_S",0];_veh animate ["Directional_F",1];};
		} else {
		    _veh animate ["Directional_Switch",0];
		    if (_veh animationPhase "Directional_Control_Noob" == 17.5) then {
		    	_veh animate ["Directional_S",0];
		    	_veh animate ["Directional_F",0];
			};
			_veh animate ["Directional",0];
		};
    }
],
[
    "",
    "STR_Intersect_ToggleDirectionController",
    {
        private _veh = player_objintersect;
        if (_veh animationPhase "Directional_Control_Noob" == 0) then {
            _veh animate ["Directional_Control_Noob",6.5];_veh animate ["Directional_L",0];_veh animate ["Directional_R",1];
        };
        if (_veh animationPhase "Directional_Control_Noob" == 6.5) then {
            _veh animate ["Directional_Control_Noob",12];_veh animate ["Directional_R",0];_veh animate ["Directional_S",1];
        };
        if (_veh animationPhase "Directional_Control_Noob" == 12) then {
            _veh animate ["Directional_Control_Noob",17.5];_veh animate ["Directional_S",0];if (_veh animationPhase "Directional_Switch" == 1) then {_veh animate ["Directional_F",1];_veh animate ["Directional",0];};
        };
        if (_veh animationPhase "Directional_Control_Noob" == 17.5) then {
            _veh animate ["Directional_Control_Noob",0];_veh animate ["Directional_F",0];_veh animate ["Directional_L",1];if (_veh animationPhase "Directional_Switch" == 1) then{_veh animate ["Directional",1];};
        };
    }
],
[
    "",
    "STR_Intersect_MasterSiren",
    {
        private _veh = player_objintersect;
        if (_veh animationPhase "Siren_Control_Switch" < 0.5) then {
            _veh animate ["Siren_Control_Switch",1];
			[3] call A3PL_Vehicle_SirenHotkey;
        } else {
            _veh animate ["Siren_Control_Switch",0];
			[_veh] call A3PL_Vehicle_SoundSourceClear;
        };
        if (_veh animationPhase "sirenswitch_1" < 0.5) then {
            _veh animate ["sirenswitch_1",1];
			[3] call A3PL_Vehicle_SirenHotkey;
        } else {
            _veh animate ["sirenswitch_1",0];
			[_veh] call A3PL_Vehicle_SoundSourceClear;
        };
    }
],
[
    "",
    "STR_Intersect_ControlSiren",
    {[4] call A3PL_Vehicle_SirenHotkey;}
],
[
    "",
    "STR_Intersect_ToggleStorage" + str 1,
    {
        private _veh = player_objintersect;
        if (_veh animationSourcePhase "Cargo_Door_1" < 0.5) then {
            _veh animateSource ["Cargo_Door_1",1];
        } else {
            _veh animateSource ["Cargo_Door_1",0];
        };
    }
],
[
    "",
    "STR_Intersect_ToggleStorage" + str 2,
    {
       	private _veh = player_objIntersect;
        if (_veh animationSourcePhase "Cargo_Door_2" < 0.5) then {
            _veh animateSource ["Cargo_Door_2",1];
        } else {
            _veh animateSource ["Cargo_Door_2",0];
        };
    }
],
[
    "",
    "STR_Intersect_ToggleStorage" + str 3,
    {
        private _veh = player_objIntersect;
        if (_veh animationSourcePhase "Cargo_Door_3" < 0.5) then {
            _veh animateSource ["Cargo_Door_3",1];
        } else {
            _veh animateSource ["Cargo_Door_3",0];
        };
    }
],
[
    "",
    "STR_Intersect_ToggleStorage" + str 4,
    {
        private _veh = player_objIntersect;
        if (_veh animationSourcePhase "Cargo_Door_4" < 0.5) then {
            _veh animateSource ["Cargo_Door_4",1];
        } else {
            _veh animateSource ["Cargo_Door_4",0];
        };
    }
],
[
    "",
    "STR_Intersect_ToggleStorage" + str 5,
    {
        private _veh = player_objIntersect;
        if (_veh animationSourcePhase "Cargo_Door_5" < 0.5) then {
            _veh animateSource ["Cargo_Door_5",1];
        } else {
            _veh animateSource ["Cargo_Door_5",0];
        };
    }
],
[
    "",
    "STR_Intersect_ToggleStorage" + str 6,
    {
        private _veh = player_objIntersect;
        if (_veh animationSourcePhase "Cargo_Door_6" < 0.5) then {
            _veh animateSource ["Cargo_Door_6",1];
        } else {
            _veh animateSource ["Cargo_Door_6",0];
        };
    }
],
[
    "",
    "STR_Intersect_ToggleStorage" + str 7,
    {
        private _veh = player_objIntersect;
        if (_veh animationSourcePhase "Cargo_Door_7" < 0.5) then {
            _veh animateSource ["Cargo_Door_7",1];
        } else {
            _veh animateSource ["Cargo_Door_7",0];
        };
    }
],
[
    "",
    "STR_Intersect_ToggleStorage" + str 8,
    {
        private _veh = player_objIntersect;
        if (_veh animationSourcePhase "Cargo_Door_8" < 0.5) then {
            _veh animateSource ["Cargo_Door_8",1];
        } else {
            _veh animateSource ["Cargo_Door_8",0];
        };
    }
],
[
    "",
    "STR_Intersect_ToggleStorage" + str 9,
    {
        private _veh = player_objIntersect;
        if (_veh animationSourcePhase "Cargo_Door_9" < 0.5) then {
            _veh animateSource ["Cargo_Door_9",1];
        } else {
            _veh animateSource ["Cargo_Door_9",0];
        };
    }
],
[
    "",
    "STR_Intersect_ToggleStorage" + str 10,
    {
        private _veh = player_objIntersect;
        if (_veh animationSourcePhase "Cargo_Door_10" < 0.5) then {
            _veh animateSource ["Cargo_Door_10",1];
        } else {
            _veh animateSource ["Cargo_Door_10",0];
        };
    }
],
[
    "",
    "STR_Intersect_ToggleStorage" + str 11,
    {
        private _veh = player_objIntersect;
        if (_veh animationSourcePhase "Cargo_Door_11" < 0.5) then {
            _veh animateSource ["Cargo_Door_11",1];
        } else {
            _veh animateSource ["Cargo_Door_11",0];
        };
    }
],
[
    "",
    "STR_Intersect_ToggleStorage" + str 12,
    {
        private _veh = player_objIntersect;
        if (_veh animationSourcePhase "Cargo_Door_12" < 0.5) then {
            _veh animateSource ["Cargo_Door_12",1];
        } else {
            _veh animateSource ["Cargo_Door_12",0];
        };
    }
],
[
    "",
    "STR_Intersect_ToggleStorage" + str 13,
    {
        private _veh = player_objIntersect;
        if (_veh animationSourcePhase "Cargo_Door_13" < 0.5) then {
            _veh animateSource ["Cargo_Door_13",1];
        } else {
            _veh animateSource ["Cargo_Door_13",0];
        };
    }
],
[
    "",
    "STR_Intersect_ToggleStorage" + str 14,
    {
        private _veh = player_objIntersect;
        if (_veh animationSourcePhase "Cargo_Door_14" < 0.5) then {
            _veh animateSource ["Cargo_Door_14",1];
        } else {
            _veh animateSource ["Cargo_Door_14",0];
        };
    }
],
[
    "",
    "STR_Intersect_ToggleStorage" + str 15,
    {
        private _veh = player_objIntersect;
        if (_veh animationSourcePhase "Cargo_Door_15" < 0.5) then {
            _veh animateSource ["Cargo_Door_15",1];
        } else {
            _veh animateSource ["Cargo_Door_15",0];
        };
    }
],
[
    "",
    "STR_Intersect_ToggleStorage" + str 16,
    {
        private _veh = player_objIntersect;
        if (_veh animationSourcePhase "Cargo_Door_16" < 0.5) then {
            _veh animateSource ["Cargo_Door_16",1];
        } else {
            _veh animateSource ["Cargo_Door_16",0];
        };
    }
],
[
    "",
    "STR_Intersect_ToggleStorage" + str 17,
    {
        private _veh = player_objIntersect;
        if (_veh animationSourcePhase "Cargo_Door_17" < 0.5) then {
            _veh animateSource ["Cargo_Door_17",1];
        } else {
            _veh animateSource ["Cargo_Door_17",0];
        };
    }
],
[
    "",
    "STR_Intersect_ToggleStorage" + str 18,
    {
        private _veh = player_objIntersect;
        if (_veh animationSourcePhase "Cargo_Door_18" < 0.5) then {
            _veh animateSource ["Cargo_Door_18",1];
        } else {
            _veh animateSource ["Cargo_Door_18",0];
        };
    }
],
[
    "",
    "STR_Intersect_ToggleStorage" + str 19,
    {
        private _veh = player_objIntersect;
        if (_veh animationSourcePhase "Cargo_Door_19" < 0.5) then {
            _veh animateSource ["Cargo_Door_19",1];
        } else {
            _veh animateSource ["Cargo_Door_19",0];
        };
    }
],
[
    "",
    "STR_Intersect_ToggleStorage" + str 20,
    {
        private _veh = player_objIntersect;
        if (_veh animationSourcePhase "Cargo_Door_20" < 0.5) then {
            _veh animateSource ["Cargo_Door_20",1];
        } else {
            _veh animateSource ["Cargo_Door_20",0];
        };
    }
],
[
    "",
    "STR_Intersect_CloseOpen",
    {
        private _veh = player_objIntersect;
        if (_veh animationSourcePhase player_nameintersect == 0) then {
            _veh animateDoor [player_nameintersect, 1];
        } else {
            _veh animateDoor [player_nameintersect, 0];
        };
    }
],
[
    "",
    "STR_Intersect_OpenCloseLocker",
    {
    	[] spawn {
    		private _obj = Player_ObjIntersect;
			private _name = Player_NameIntersect;
			private _split = _name splitstring "_";
			private _animationName = (_split select 0);
			if ((_obj animationSourcePhase _animationName) < 0.5) then {
				[_obj,true,true] remoteExec ["Server_Vehicle_EnableSimulation", 2];
				sleep 1.2;
				_obj animateSource [_animationName,1];
				_obj setVariable ["locked",false,true];
			} else {
				_obj animateSource [_animationName,0];
				_obj setVariable ["locked",true,true];
				waitUntil{(_obj animationSourcePhase _animationName) isEqualTo 0};
				[_obj,false,true] remoteExec ["Server_Vehicle_EnableSimulation", 2];
			};
    	};
	}
],
// [
//     "",
//     "Store",
//     {
// 		if (!isNull Player_Item) exitwith {
// 			call A3PL_Placeables_QuickAction;
// 		};
// 		private _attached = [] call A3PL_Lib_Attached;
// 		if (count _attached == 0) exitwith {};
// 		if ((typeOf (_attached select 0)) IN Config_Placeables) then {
// 			call A3PL_Placeables_QuickAction;
// 		};
//     }
// ],
[
    "",
    "STR_Intersect_BuyLocker",
    {[player_objintersect] spawn A3PL_Locker_Rent;}
],
[
	"",
	"STR_Intersect_SellLocker",
	{[player_objintersect] spawn A3PL_Locker_Sell;}
],
[
	"A3PL_MailTruck",
	"STR_Intersect_OpenDeliveryTrunk",
	{
		private _veh = player_objintersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_VehicleLocked" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (_veh animationSourcePhase "mailtruck_trunk" < 0.5) then	{
			_veh animateSource ["mailtruck_trunk",1];
		} else {
			_veh animateSource ["mailtruck_trunk",0];
		};
	}
],
[
	"",
	"STR_Intersect_ToggleDrill",
	{
		private _drill = player_objintersect;
		private _a = _drill animationSourcePhase "drill_arm_position";

		if (typeOf _drill isEqualTo "A3PL_Drill_Trailer") then {
			if (_a > 0) exitwith {
				if (_drill animationSourcePhase "drill" > 0) exitwith {[("STR_A3PL_QuickActions_Vehicles_RetractDrill" call A3PL_Localize), Color_Red] call A3PL_Notification;};
				_drill animateSource ["drill_arm_position",0];
			};
			_drill animateSource ["drill_arm_position",1];
		} else {

		};
	}
],
[
	"",
	"STR_Intersect_StartStopDrill",
	{[player_objintersect] spawn A3PL_JobWildcat_Drill;}
],
[
	"A3PL_Pumpjack",
	"STR_Intersect_StartPumpjack",
	{[player_objintersect] call A3PL_JobOil_PumpStart;}
],

[
	"",
	"STR_Intersect_RefuelGasCan",
	{[player_objintersect] spawn A3PL_Hydrogen_Connect;}
],
[
	"",
	"STR_Intersect_PlacePump",
	{[player_objintersect] spawn A3PL_Hydrogen_Connect;}
],
[
	"",
	"STR_Intersect_RiseLowerRamp",
	{[player_objintersect] call A3PL_Vehicle_TrailerRamp;}
],
[
	"A3PL_Ski_Base",
	"STR_Intersect_TakeSki",
	{
		if (!isNull player_item) exitwith {[("STR_A3PL_QuickActions_Vehicles_YouCanTakeThisObject" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		call A3PL_Placeables_QuickAction;
	}
],
[
	"A3PL_Ski_Base",
	"STR_Intersect_ToggleRope",
	{
		private _ski = player_objintersect;
		if (!(_ski isKindOf "A3PL_Ski_Base")) exitwith {[("STR_A3PL_QuickActions_Vehicles_LookingForASki" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (!(isNull (ropeAttachedTo _ski))) exitwith {
			{ropeDestroy _x;} foreach (ropes (ropeAttachedTo _ski));
			[("STR_A3PL_QuickActions_Vehicles_RopeDettached" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};
		private _boat = nearestObjects [_ski, ["A3PL_Motorboat","A3PL_RHIB","A3PL_RBM"], 20];
		_boat = _boat - [_ski];
		if (count _boat < 1) exitwith {[("STR_A3PL_QuickActions_Vehicles_NoBoatProximity" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_boat = _boat select 0;
		if (!(isNull attachedTo _boat)) exitwith {
			[("STR_A3PL_QuickActions_Vehicles_CantAttachRopeToBoat" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};
		if (_boat == _ski) exitwith {[("System Error: Unable to attach a rope" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if ((ropeAttachedTo _boat) == _ski) exitwith {[("System Error: Unable to attach a rope" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		private _rope = ropeCreate [_boat, [0, -2.2, -0.5], _ski, "rope", 15];
		if (isNull _rope) exitwith {[("An error occurred while trying to create a rope" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		[("STR_A3PL_QuickActions_Vehicles_RopeAttached" call A3PL_Localize), Color_Green] call A3PL_Notification;
	}
],
[
	"",
	"STR_Common_EnterDriver",
	{
		private _veh = player_objintersect;
		private _anim = player_nameIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {
			[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};
        //if (_veh isKindOf "Car") then {_veh call A3PL_Vehicle_Init_A3PL_Engine;};
        private _factionVehicles = ["A3PL_Tahoe_PD","A3PL_Tahoe_PD_Slicktop","A3PL_CVPI_PD_Slicktop","A3PL_CVPI_PD","A3PL_Mustang_PD","A3PL_Mustang_PD_Slicktop","A3PL_Charger_PD","A3PL_Charger_PD_Slicktop","A3PL_Silverado_PD","A3PL_Silverado_PD_ST","A3PL_Charger15_PD","A3PL_Charger15_PD_ST","A3PL_Charger15_FD","A3FL_Explorer_Platinum_PD_20","A3FL_Explorer_PD_K9_20","A3FL_Explorer_Platinum_PD_Slicktop_20","A3FL_Explorer_Platinum_FD_20","A3FL_Mustang15_PD","A3FL_Mustang15_PD_ST","A3PL_VetteZR1_PD","A3FL_Taurus_PD","A3FL_Taurus_PD_ST","A3FL_Taurus_FD","A3FL_Tahoe_PD","A3FL_Tahoe_PD_ST","A3FL_Tahoe_FD","A3FL_E350_PD","A3FL_E350_PD_P","A3FL_CamaroZL1_PD","A3FL_CamaroZL1_PD_ST","A3FL_F150_PD","A3FL_F150_PD_ST","A3PL_Challenger_Hellcat_PD_ST","A3FL_F150_FD"];
        if (typeOf _veh IN _factionVehicles) then {_veh call A3PL_Vehicle_Init_FactionVeh;};
		[_veh,_anim] spawn {
			private _veh = _this select 0;
			private _anim = _this select 1;
			_veh lock 1;
			player action ["GetInDriver", _veh];
			switch (true) do {
				case (_veh isKindOf "helicopter"): {
					_veh animate [_anim,1];
					sleep 2;
					_veh animate [_anim,0];
				};
				case (_veh isKindOf "car"): {
					sleep 0.8;
					_veh animate [_anim,1];
					sleep 1;
					_veh animate [_anim,0];
				};
			};
			_veh lock 2;
		};
	}
],
[
	"",
	"STR_Intersect_LockUnlockDoor",
	{
		private _locked = player_objintersect getVariable ["locked",true];
		if (_locked) then {
			player_objintersect setVariable ["locked",false,true];
			[("STR_Common_VehicleUnlocked" call A3PL_Localize), Color_Green] call A3PL_Notification;
		} else {
			player_objintersect setVariable ["locked",true,true];
			[("STR_Common_VehicleLocked" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};
	}
],
[
	"",
	"STR_Intersect_RepairVehicle",
	{
		if (isNull player_objintersect) exitwith {};
		[player_objintersect] spawn A3PL_Vehicle_RepairOpen;
	}
],
[
	"",
	"STR_Intersect_ResetScooter",
	{
		private _intersect = player_objintersect;
		if (isNull _intersect) exitwith {};
		_pos = getPos _intersect;
		_intersect setPos [_pos select 0,_pos select 1,_pos select 2];
	}
],
[
	"",
	"STR_Common_EnterCopilot",
	{
		private _veh = player_objintersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {
			[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};
		player moveInTurret [_veh,[0]];
	}
],
[
	"",
	"STR_Common_EnterPassenger",
	{
		if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		private _veh = player_objintersect;
		private _anim = player_nameIntersect;
		private _typeOf = typeOf _veh;
		private _value = getNumber (configFile >> "CfgVehicles" >> _typeOf >> "transportSoldier");
		private _list = fullCrew [_veh, "cargo"];
		private _freeseats = count (_list);
		if (_freeseats >= _value) exitwith {[("This vehicle is full" call A3PL_Localize), Color_Red] call A3PL_Notification;};

		[_veh,_anim] spawn {
			private _veh = _this#0;
			private _anim = _this#1;
			_veh animate [_anim,1];
			if(typeOf _veh isEqualTo "A3FL_M_900_Base_F") then {
				if(_anim isEqualTo "door_rb") then {
					player action ["GetInCargo", _veh,0];
				} else {
					player action ["GetInCargo", _veh,1];
				};
			};
			if (typeOf _veh IN ["A3PL_Cessna172","A3PL_Goose_USCG","A3PL_Goose_Base"]) then {
				player moveInCargo _veh;
			} else {
				private _allSeats = fullCrew [_veh,"cargo",true];
				private _trySeat = switch (_anim) do {
					case "door_lb": {2};
					case "door_rf": {0};
					case "door_rb": {1};
					case "scooter_passenger": {1};
				};
				if ((typeOf _veh) isEqualTo "A3PL_Suburban") then {
					_trySeat = _trySeat + 1;
				};
				private _newSeat = 0;
				if (_allSeats#_trySeat#0 isEqualTo objNull) then {
					_newSeat = _trySeat;
				} else {
					_newSeat = -1;
				};
				if (_newSeat isEqualTo -1) then {
					player moveInCargo _veh;
				} else {
					player moveInCargo [_veh,_newSeat];
				};
			};
			sleep 1;
			if (_veh isKindOf "helicopter") then {sleep 2;};
			_veh animate [_anim,0];
		};
		_veh lock 2;
	}
],
[
	"",
	"STR_Common_ExitVehicle",
	{
		private _veh = player_objintersect;
		private _anim = player_nameintersect;
		private _seatbelt = player getVariable ["SeatbeltOn",false];
		if (_seatbelt) exitWith {[("STR_Common_SeatbeltRemoveFirst" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		[_veh,_anim] spawn
		{
			private _veh = _this select 0;
			private _anim = _this select 1;
			_veh animate [_anim,1];
			sleep 1;
			if (_veh isKindOf "helicopter") then {
				if (_anim == "door3") exitwith {};
				sleep 2;
			};
			_veh animate [_anim,0];
		};
		_veh lock 1;
		player leaveVehicle _veh;
		unassignVehicle player;
		if (((speed vehicle player) < 1) && (vehicle player getVariable ["EngineOn",0] isEqualTo 0)) then {
			player action ["GetOut", (vehicle player)];
			[]spawn {if (player getVariable ["Cuffed",false]) then {sleep 1.5;player setVelocityModelSpace [0,3,1];[player,"a3pl_handsupkneelcuffed"] remoteExec ["A3PL_Lib_SyncAnim",-2];};};
		} else {
			player action ["eject", (vehicle player)];
			[]spawn {if (player getVariable ["Cuffed",false]) then {sleep 1.5;player setVelocityModelSpace [0,3,1];[player,"a3pl_handsupkneelcuffed"] remoteExec ["A3PL_Lib_SyncAnim",-2];};};
		};
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_Start",
	{
		private _veh = player_objintersect;
		if (isEngineOn _veh) exitwith {
			_veh engineOn false;
			player action ["lightOff", _veh];
			[("STR_A3PL_QuickActions_Vehicles_EngineOff" call A3PL_Localize), Color_Red] call A3PL_Notification;
		};
		_veh setVariable ["Ignition",true,false];
		_veh engineOn true;
		[_veh] spawn {
			private _veh = _this select 0;
			sleep 0.1;
			(_veh) setVariable ["Ignition",nil,false];
			[("STR_A3PL_QuickActions_Vehicles_EngineOn" call A3PL_Localize), Color_Green] call A3PL_Notification;
		};
	}
],
[
	"",
	"STR_Intersect_ToggleSiren",
	{
		private _veh = player_objintersect;
		private _atc = attachedObjects _veh;
		private _sirenObj = _veh getVariable "sirenObj";
		if (isNil "_sirenObj") then {
			private _sirenObj = createSoundSource ["A3PL_PoliceSiren", getpos _veh, [], 0];
			_sirenObj attachTo [_veh,[0,0,0]];
			_veh setVariable ["sirenObj",_sirenObj,true];
		} else {
			detach _sirenObj;
			deleteVehicle _sirenObj;
			_veh setVariable ["sirenObj",Nil,true];
			{
				_type = format["%1",typeOf _x];
				if(_type == "#dynamicsound") then {deleteVehicle _x;};
			} foreach nearestObjects [_veh,[],10];
		};
	}
],
[
	"",
	"STR_Intersect_ToggleManual" + str 1,
	{
		private _veh = player_objintersect;
		private _atc = attachedObjects _veh;
		private _sirenObj = _veh getVariable "manualObj";
		if (isNil "_sirenObj") then {
			_sirenObj = createSoundSource ["A3PL_PoliceSirenM1", getpos _veh, [], 0];
			_sirenObj attachTo [_veh,[0,0,0]];
			_veh setVariable ["manualObj",_sirenObj,true];
		} else {
			detach _sirenObj;
			deleteVehicle _sirenObj;
			_veh setVariable ["manualObj",Nil,true];
		};
	}
],
[
	"",
	"STR_Intersect_ToggleManual" + str 2,
	{
		private _veh = player_objintersect;
		private _atc = attachedObjects _veh;
		private _sirenObj = _veh getVariable "manualObj";
		if (isNil "_sirenObj") then {
			_sirenObj = createSoundSource ["A3PL_PoliceSirenM2", getpos _veh, [], 0];
			_sirenObj attachTo [_veh,[0,0,0]];
			_veh setVariable ["manualObj",_sirenObj,true];
		} else {
			detach _sirenObj;
			deleteVehicle _sirenObj;
			_veh setVariable ["manualObj",Nil,true];
		};
	}
],
[
	"",
	"STR_Intersect_ToggleManual" + str 3,
	{
		private _veh = player_objintersect;
		private _atc = attachedObjects _veh;
		private _sirenObj = _veh getVariable "manualObj";
		if (isNil "_sirenObj") then {
			_sirenObj = createSoundSource ["A3PL_PoliceSirenM3", getpos _veh, [], 0];
			_sirenObj attachTo [_veh,[0,0,0]];
			_veh setVariable ["manualObj",_sirenObj,true];
		} else {
			detach _sirenObj;
			deleteVehicle _sirenObj;
			_veh setVariable ["manualObj",Nil,true];
		};
	}
],
[
	"",
	"STR_Intersect_Lights",
	{
		private _veh = player_objintersect;
		if (isLightOn _veh) then {
			player action ["lightOff",_veh];
			[("STR_A3PL_QuickActions_Vehicles_LightsTurnedOff" call A3PL_Localize), Color_Red] call A3PL_Notification;
			_veh animateSource ["Head_Lights",0];

			private _trailerArray = nearestObjects [(_veh modelToWorld [0,-4,0]), ["A3PL_Trailer_Base"], 6.5];
			_trailerArray = _trailerArray select 0;
			if (!isNil "_trailerArray") then {_trailerArray animate ["Tail_Lights",0];};
		} else {
			player action ["lightOn",_veh];
			[("STR_A3PL_QuickActions_Vehicles_LightsTurnedOn" call A3PL_Localize), Color_Green] call A3PL_Notification;
			_veh animateSource ["Head_Lights",3000];
			private _trailerArray = nearestObjects [(_veh modelToWorld [0,-4,0]), ["A3PL_Trailer_Base"], 6.5];
			_trailerArray = _trailerArray select 0;
			if (!isNil "_trailerArray") then
			{
				_trailerArray animate ["Tail_Lights",1];
			};
		};
	}
],
[
	"",
	"STR_Intersect_OpenCloseTrunk",
	{
		private _veh = player_objintersect;
		if (_veh animationSourcePhase "trunk" < 0.5) then {
			_veh animateSource ["trunk",1];
		} else {
			_veh animateSource ["trunk",0];
		};
	}
],
[
	"",
	"STR_Intersect_AttachTrailer",
	{
		private _f = false;
		if (typeOf player_objintersect == "A3PL_DrillTrailer_Default") then {
			if (((player_objintersect animationSourcePhase "drill") > 0) OR ((player_objintersect animationSourcePhase "drill_arm_position") > 0)) then {
				_f = true;
			};
		};
		if (_f) exitwith {[("STR_A3PL_QuickActions_Vehicles_RetractDrill" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		[player_objIntersect] call A3PL_Vehicle_Trailer_Hitch;
	}
],
// [
// 	"",
// 	"Climb on Yacht",
// 	{player setPos (player_objintersect modelToWorld (player_objintersect selectionPosition "climbYacht"));}
// ],
[
	"",
	"STR_Intersect_DetachTrailer",
	{[player_objintersect] call A3PL_Vehicle_Trailer_Unhitch;}
],
[
	"",
	"STR_Intersect_OpenCloseTrailerDoor",
	{
		private _veh = player_objIntersect;
		if (_veh animationPhase "door" < 0.1) then {
			[_veh] spawn {
				private _veh = _this select 0;
				_veh animate ["door_lock",1];
				sleep 1.9;
				_veh animate ["Door",1];
			};
		} else {
			[_veh] spawn {
				private _veh = _this select 0;
				_veh animate ["Door",0];
				sleep 1.9;
				_veh animate ["door_lock",0];
			};
		};
	}
],
[
	"",
	"STR_Intersect_RiseLowerRamp",
	{
		private _veh = player_objIntersect;
		if (_veh animationPhase "ramp1" < 0.1) then {
			[_veh] spawn {
				private _veh = _this select 0;
				_veh animate ["ramp1",1];
				sleep 1.9;
				_veh animate ["ramp2",1];
			};
		} else {
			[_veh] spawn {
				private _veh = _this select 0;
				_veh animate ["ramp2",0];
				sleep 1.9;
				_veh animate ["ramp1",0];
			};
		};
	}
],
[
	"",
	"STR_Intersect_UnloadVehicle",
	{[player_Objintersect] spawn A3PL_Vehicle_TowTruck_Unloadcar;}
],
[
	"",
	"STR_Intersect_LoadVehicle",
	{[player_objIntersect] spawn A3PL_Vehicle_TowTruck_Loadcar;}
],
[
	"",
	"STR_Intersect_EnterGunner" + str 1,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInTurret", _veh, [0]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_EnterGunner" + str 2,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInTurret", _veh, [1]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_EnterGunner" + str 3,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInTurret", _veh, [2]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_EnterGunner" + str 4,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInTurret", _veh, [3]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_EnterGunner" + str 5,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInTurret", _veh, [4]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_EnterGunner" + str 6,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInTurret", _veh, [5]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_EnterGunner" + str 7,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInTurret", _veh, [6]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_EnterGunner" + str 8,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInTurret", _veh, [7]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_EnterGunner" + str 9,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInTurret", _veh, [8]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_EnterGunner" + str 10,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInTurret", _veh, [9]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_EnterGunner" + str 11,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInTurret", _veh, [10]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_EnterGunner" + str 12,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInTurret", _veh, [11]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_EnterGunner" + str 13,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInTurret", _veh, [12]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_EnterGunner" + str 14,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInTurret", _veh, [13]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_EnterGunner" + str 15,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInTurret", _veh, [14]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_EnterGunner" + str 16,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInTurret", _veh, [15]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_EnterGunner" + str 17,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInTurret", _veh, [16]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_EnterGunner" + str 18,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInTurret", _veh, [17]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_EnterGunner" + str 19,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInTurret", _veh, [18]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_EnterGunner" + str 20,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInTurret", _veh, [19]];
		_veh lock 2;
	}
],

[
	"",
	"STR_Intersect_SitInSeat" + str 1,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 0];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 2,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 1];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 3,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 2];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 4,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 3];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 5,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 4];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 6,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 5];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 7,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 6];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 8,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 7];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 9,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 8];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 10,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 9];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 11,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 10];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 12,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 11];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 13,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 12];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 14,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 13];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 15,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 14];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 16,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 15];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 17,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 16];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 18,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 17];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 19,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 18];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 20,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 19];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 21,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 20];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 22,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 21];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 23,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 22];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 24,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 23];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 25,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 24];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 26,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 25];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 27,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 26];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 28,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 27];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 29,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 28];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 30,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 29];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 31,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 30];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 32,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 31];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 33,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 32];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 34,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 33];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 35,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 34];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 36,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 35];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 37,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 36];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 38,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 37];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 39,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 38];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 40,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 39];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 41,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 40];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 42,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 41];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 43,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 42];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 44,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 43];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 45,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 44];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 46,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 45];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 47,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 46];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 48,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 47];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 49,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 48];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_SitInSeat" + str 50,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["getInCargo", _veh, 49];
		_veh lock 2;
	}
],

[
	"",
	"STR_Intersect_MoveToDriver",
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		private _driver = driver _veh;
		if (!(isNull _driver)) exitWith {};
		_veh lock 1;
		player action ["moveToDriver", _veh];
		_veh lock 2;
	}
],



[
	"",
	"STR_Intersect_MoveToGunner" + str 1,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["MoveToTurret", _veh, [0]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToGunner" + str 2,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["MoveToTurret", _veh, [1]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToGunner" + str 3,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["MoveToTurret", _veh, [2]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToGunner" + str 4,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["MoveToTurret", _veh, [3]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToGunner" + str 5,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["MoveToTurret", _veh, [4]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToGunner" + str 6,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["MoveToTurret", _veh, [5]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToGunner" + str 7,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["MoveToTurret", _veh, [6]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToGunner" + str 8,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["MoveToTurret", _veh, [7]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToGunner" + str 9,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["MoveToTurret", _veh, [8]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToGunner" + str 10,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["MoveToTurret", _veh, [9]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToGunner" + str 11,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["MoveToTurret", _veh, [10]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToGunner" + str 12,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["MoveToTurret", _veh, [11]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToGunner" + str 13,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["MoveToTurret", _veh, [12]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToGunner" + str 14,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["MoveToTurret", _veh, [13]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToGunner" + str 15,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["MoveToTurret", _veh, [14]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToGunner" + str 16,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["MoveToTurret", _veh, [15]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToGunner" + str 17,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["MoveToTurret", _veh, [16]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToGunner" + str 18,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["MoveToTurret", _veh, [17]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToGunner" + str 19,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["MoveToTurret", _veh, [18]];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToGunner" + str 20,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["MoveToTurret", _veh, [19]];
		_veh lock 2;
	}
],

[
	"",
	"STR_Intersect_MoveToCoPilot",
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 0];
		_veh lock 2;
	}
],

[
	"",
	"STR_Intersect_MoveToSeat" + str 1,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 0];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 2,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 1];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 3,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 2];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 4,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 3];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 5,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 4];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 6,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 5];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 7,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 6];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 8,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 7];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 9,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 8];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 10,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 9];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 11,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 10];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 12,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 11];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 13,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 12];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 14,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 13];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 15,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 14];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 16,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 15];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 17,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 16];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 18,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 17];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 19,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 18];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 20,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 19];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 21,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 20];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 22,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 21];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 23,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 22];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 24,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 23];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 25,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 24];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 26,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 25];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 27,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 26];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 28,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 27];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 29,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 28];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 30,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 29];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 31,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 30];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 32,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 31];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 33,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 32];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 34,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 33];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 35,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 34];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 36,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 35];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 37,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 36];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 38,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 37];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 39,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 38];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 40,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 39];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 41,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 40];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 42,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 41];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 43,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 42];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 44,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 43];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 45,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 44];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 46,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 45];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 47,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 46];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 48,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 47];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 49,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 48];
		_veh lock 2;
	}
],
[
	"",
	"STR_Intersect_MoveToSeat" + str 50,
	{
		private _veh = player_objIntersect;
		if(_veh getVariable ["locked",true]) exitWith {[("STR_A3PL_QuickActions_Vehicles_DoorClosed" call A3PL_Localize), Color_Red] call A3PL_Notification;};if (animationState player IN ["A3PL_HandsupToKneel","A3PL_HandsupKneelGetCuffed","A3PL_Cuff","A3PL_HandsupKneelCuffed","A3PL_HandsupKneelKicked","A3PL_CuffKickDown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","A3PL_HandsupKneel"]) exitWith {[("STR_A3PL_QuickActions_Vehicles_YouCantEnterInCarWhenHandcuffed" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		_veh lock 1;
		player action ["moveToCargo", _veh, 49];
		_veh lock 2;
	}
],
[
	"A3PL_Jayhawk",
	"STR_Intersect_FoldUnfoldJayhawk",
	{
		private _veh = player_objIntersect;
		if ((_veh animationSourcePhase "Jayhawk_Fold") > 0.5) exitwith {
			_veh animateSource ["Jayhawk_Fold",0];
			_veh animate ["RotorManual",0];
		};
		if ((_veh animationSourcePhase "Jayhawk_Fold") < 0.5) exitwith {
			[_veh] spawn {
				private _veh = _this select 0;
				_veh animate ["RotorManual",1-(_veh animationPhase "rotor")];
				sleep 2;
				_veh animateSource ["Jayhawk_Fold",1];
			};
		};
	}
],
[
    "",
    "STR_Intersect_CockpitLights",
    {
		private _veh = player_objIntersect;
        private _delete = false;
        private _d = objNull;
		if(_veh animationSourcePhase "Cockpit_Lights" > 0.5)then {
        	_veh animateSource ["Cockpit_Lights",0];
			if (!(player == (vehicle player turretUnit [0]))) then {
				if(isnull (_veh turretUnit [0]))then {
					_delete=true;
					_d = createAgent ["VirtualMan_F", [0,0,0], [], 0, "FORM"];
					_d moveInTurret [_veh,[0]];
				};
			};
        	(_veh turretUnit [0]) action ["searchlightOff",  _veh];
        	if(_delete)then{moveout _d; deleteVehicle _d;};
        } else {
        	_veh animateSource ["Cockpit_Lights",1];
        	if(isnull (_veh turretUnit [0]))then {
        		_delete=true;
        		_d = createAgent ["VirtualMan_F", [0,0,0], [], 0, "FORM"];
        		_d moveInTurret [_veh,[0]];
        	};
        	(_veh turretUnit [0]) action ["searchlightOn",  _veh];
        	if(_delete)then{moveout _d; deleteVehicle _d;};
        };
    }
],
[
    "",
    "STR_Intersect_BulldozerToggle",
    {
        private _veh = player_objIntersect;
        if (_veh animationSourcePhase "groundShov" < 0.5) then {
            _veh animateSource ["groundShov",1];
        } else {
            _veh animateSource ["groundShov",-0.5];
        };
    }
],
[
    "",
    "STR_Intersect_RemovePiece",
    {
		[] spawn {
			_veh = player_objintersect;
			_posveh = _veh selectionPosition "Turret1_pos";
			_pos = _veh modeltoworld _posveh;
			if(!(call A3PL_Player_AntiSpam)) exitWith {};
			if ((_veh animationPhase "Bucket") > 0.5) exitWith {
				_Bucket = "A3PL_MiniExcavator_Bucket" createvehicle [0,0,0];
				[player,_veh,_Bucket] remoteExec ["Server_Vehicle_AtegoHandle", 2];
				_veh removeMagazineTurret  ["A3PL_BucketMag",[0]];
				_veh removeWeaponTurret ["A3PL_Machinery_Bucket",[0,0]];
				_veh removeMagazineTurret  ["A3PL_JackhammerMag",[0]];
				_veh removeWeaponTurret ["A3PL_Machinery_Pickaxe",[0,0]];
				_veh setVariable ["attachedTool", "nothing"];
				uiSleep 0.1;
				_Bucket setVariable ["class","ME_Bucket",true];
				_Bucket setVariable ["owner",(player getVariable ["character_id",""]),true];
				_veh animate ["Bucket",0];
				_Bucket attachTo [_veh, [(_posveh select 0),(_posveh select 1),(_posveh select 2)-0.6]];
				detach _Bucket;
				uiSleep 0.1;
				_veh animate ["Attachment",0];
			};
			if ((_veh animationPhase "Jackhammer") > 0.5) exitWith {
				_Bucket = "A3PL_MiniExcavator_Jackhammer" createvehicle [0,0,0];
				[player,_veh,_Bucket] remoteExec ["Server_Vehicle_AtegoHandle", 2];
				_veh setVariable ["attachedTool", "nothing"];
				_veh removeMagazineTurret  ["A3PL_BucketMag",[0]];
				_veh removeWeaponTurret ["A3PL_Machinery_Bucket",[0,0]];
				_veh removeMagazineTurret  ["A3PL_JackhammerMag",[0]];
				_veh removeWeaponTurret ["A3PL_Machinery_Pickaxe",[0,0]];
				uiSleep 0.1;
				_Bucket setVariable ["class","ME_Jackhammer",true];
				_Bucket setVariable ["owner",(player getVariable ["character_id",""]),true];
				_veh animate ["Jackhammer",0];
				_Bucket attachTo [_veh, _posveh];
				detach _Bucket;
				uiSleep 0.1;
				_veh animate ["Attachment",0];
			};
			if ((_veh animationPhase "Claw") > 0.5) exitWith {
				_Bucket = "A3PL_MiniExcavator_Claw" createvehicle [0,0,0];
				[player,_veh,_Bucket] remoteExec ["Server_Vehicle_AtegoHandle", 2];
				_veh setVariable ["attachedTool", "nothing"];
				uiSleep 0.1;
				_Bucket setVariable ["class","ME_Claw",true];
				_Bucket setVariable ["owner",(player getVariable ["character_id",""]),true];
				_veh animate ["Claw",0];
				_Bucket attachTo [_veh, _posveh];
				detach _Bucket;
				uiSleep 0.1;
				_veh animate ["Attachment",0];
			};
		};
    }
],
[
    "",
    "STR_Intersect_PlaceBucket",
    {
        private _veh = player_objIntersect;
        if (_veh animationPhase "Attachment" < 0.5) then {
            _veh animate ["Bucket",1];
			_veh animate ["Attachment",1];
			_veh setVariable ["attachedTool", "bucket"];
			[Player_ItemClass,-1] call A3PL_Inventory_Add;
			[false] call A3PL_Inventory_PutBack;
        };
    }
],
// [
//     "A3PL_MiniExcavator",
//     "Connect Claw",
//     {
//         private _veh = player_objIntersect;
// 		if (_veh animationPhase "Attachment" < 0.5) then {
//             _veh animate ["Claw",1];
// 			_veh animate ["Attachment",1];
// 			_veh setVariable ["attachedTool", "claw"];
// 			[Player_ItemClass,-1] call A3PL_Inventory_Add;
// 			[false] call A3PL_Inventory_PutBack;
//         };
//     }
// ],
[
    "",
    "STR_Intersect_PlaceJackhammer",
    {
        private _veh = player_objIntersect;
        if (_veh animationPhase "Attachment" < 0.5) then {
            _veh animate ["Jackhammer",1];
			_veh animate ["Attachment",1];
			_veh setVariable ["attachedTool", "jackhammer"];
			[Player_ItemClass,-1] call A3PL_Inventory_Add;
			[false] call A3PL_Inventory_PutBack;
        };
    }
],
[
    "",
    "STR_Intersect_SwitchSpotlight",
    {
        private _veh = player_objIntersect;
        if (_veh animationSourcePhase "Spotlight" < 0.5) then {
            _veh animateSource ["Spotlight",1];
			if (_veh animationSourcePhase "Head_Lights" < 0.5) then{player action ["lightOn",_veh];};
        } else {
            _veh animateSource ["Spotlight",0];
			if (_veh animationSourcePhase "Head_Lights" < 0.5) then{player action ["lightOff",_veh];};
        };
    }
],
[
	"",
	"STR_Intersect_ToggleRotorBrakes",
	{
		private _veh = player_objIntersect;
		if ((!("inspect_hitengine1" IN (player_objIntersect getVariable "Inspection")))or(!("inspect_hitengine2" IN (player_objIntersect getVariable "Inspection")))or(!("inspect_hithrotor1" IN (player_objIntersect getVariable "Inspection")))or(!("inspect_hithrotor2" IN (player_objIntersect getVariable "Inspection")))or(!("inspect_hithrotor3" IN (player_objIntersect getVariable "Inspection")))or(!("inspect_hithrotor4" IN (player_objIntersect getVariable "Inspection")))or(!("inspect_hitvrotor1" IN (player_objIntersect getVariable "Inspection")))or(!("inspect_hitvrotor2" IN (player_objIntersect getVariable "Inspection")))or(!("inspect_hitvrotor3" IN (player_objIntersect getVariable "Inspection")))or(!("inspect_hittransmission1" IN (player_objIntersect getVariable "Inspection")))or(!("inspect_hitfuel1" IN (player_objIntersect getVariable "Inspection")))or(!("inspect_hitgear1" IN (player_objIntersect getVariable "Inspection")))or(!("inspect_hitgear2" IN (player_objIntersect getVariable "Inspection")))or(!("inspect_hitgear3" IN (player_objIntersect getVariable "Inspection")))or(!("inspect_hitgear4" IN (player_objIntersect getVariable "Inspection")))or(!("inspect_hithstabilizerl11" IN (player_objIntersect getVariable "Inspection")))or(!("inspect_hithstabilizerr11" IN (player_objIntersect getVariable "Inspection")))or(!("inspect_hitlight1" IN (player_objIntersect getVariable "Inspection")))or(!("inspect_hitpitottube1" IN (player_objIntersect getVariable "Inspection")))or(!("inspect_hitpitottube2" IN (player_objIntersect getVariable "Inspection")))or(!("inspect_hitstaticport1" IN (player_objIntersect getVariable "Inspection")))or(!("inspect_hitstaticport2" IN (player_objIntersect getVariable "Inspection")))or(!("inspect_hitvstabilizer11" IN (player_objIntersect getVariable "Inspection")))or(!("inspect_intake1" IN (player_objIntersect getVariable "Inspection")))or(!("inspect_intake2" IN (player_objIntersect getVariable "Inspection")))) exitwith {[("STR_A3PL_QuickActions_Vehicles_YouNeedToFinishExteriorCheck" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (_veh animationPhase "switch_rotor_brake" < 0.5) then {_veh animate ["switch_rotor_brake",1];[("STR_A3PL_QuickActions_Vehicles_RotorBrakeDisengaged" call A3PL_Localize), Color_Green] call A3PL_Notification;} else {_veh animate ["switch_rotor_brake",0];[("STR_A3PL_QuickActions_Vehicles_RotorBrakeEngaged" call A3PL_Localize), Color_Red] call A3PL_Notification;};
	}
],
[
	"",
	"STR_Intersect_ToggleBatteries",
	{
		private _veh = player_objIntersect;
		if (_veh animationPhase "switch_rotor_brake" < 0.5) exitwith {[("STR_A3PL_QuickActions_Vehicles_ContactCFIForInstructions" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (_veh animationSourcePhase "Batteries" < 0.5) then {_veh animateSource ["Batteries",1];[("STR_A3PL_QuickActions_Vehicles_BatteryOn" call A3PL_Localize), Color_Green] call A3PL_Notification;} else {_veh animateSource ["Batteries",0];[("STR_A3PL_QuickActions_Vehicles_BatteryOff" call A3PL_Localize), Color_Red] call A3PL_Notification;sleep 0.5;_veh animate ["Switch_Radio_Atc",1];[("STR_A3PL_QuickActions_Vehicles_ATCRadioOff" call A3PL_Localize), Color_Red] call A3PL_Notification;};
	}
],
[
	"",
	"STR_Intersect_ToggleATCRadio",
	{
		private _veh = player_objIntersect;
		if (_veh animationSourcePhase "Batteries" < 0.5) exitwith {_veh animate ["Switch_Radio_Atc",0];[("STR_A3PL_QuickActions_Vehicles_ContactCFIForInstructions" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (_veh animationPhase "Switch_Radio_Atc" < 0.5) then {
			_veh animate ["Switch_Radio_Atc",1];
			if ((player getVariable "job") IN [("STR_Common_FIFR" call A3PL_Localize),("STR_Common_FISD" call A3PL_Localize)]) then {_veh setVariable ["clearance",true,true];};
			TF_lr_dialog_radio = player call TFAR_fnc_VehicleLR;
			TF_lr_dialog_radio call TFAR_fnc_setActiveLrRadio;
			call TFAR_fnc_onLrDialogOpen;
		};
		if (_veh animationPhase "Switch_Radio_Atc" > 0.5) then {
			TF_lr_dialog_radio = player call TFAR_fnc_VehicleLR;
			TF_lr_dialog_radio call TFAR_fnc_setActiveLrRadio;
			call TFAR_fnc_onLrDialogOpen;
		};
	}
],
[
	"",
	"STR_Intersect_ClosedGasMotor1",
	{
		private _veh = player_objIntersect;
		if (_veh animationPhase "Switch_Radio_Atc" < 0.5) exitwith {[("STR_A3PL_QuickActions_Vehicles_ContactCFIForInstructions" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (!(_veh getVariable ["clearance",false])) exitwith {[("STR_A3PL_QuickActions_Vehicles_NoATCClearance" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (_veh animationPhase "switch_throttle" < 0.5) then {_veh animate ["switch_throttle",1];[("STR_A3PL_QuickActions_Vehicles_ThrottleClosedEngine1" call A3PL_Localize), Color_Green] call A3PL_Notification;} else {_veh animate ["switch_throttle",0];[("STR_A3PL_QuickActions_Vehicles_ThrottleOpenEngine1" call A3PL_Localize), Color_Red] call A3PL_Notification;};
	}
],
[
	"",
	"STR_Intersect_ToggleStarter1",
	{
		private _veh = player_objIntersect;
		if (_veh animationPhase "switch_throttle" < 0.5) exitwith {[("STR_A3PL_QuickActions_Vehicles_ContactCFIForInstructions" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (!(_veh getVariable ["clearance",false])) exitwith {[("STR_A3PL_QuickActions_Vehicles_NoATCClearance" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (_veh animationPhase "switch_starter" < 0.5) then {_veh animate ["switch_starter",1];[("STR_A3PL_QuickActions_Vehicles_StarterEngagedEngine1" call A3PL_Localize), Color_Green] call A3PL_Notification;} else {_veh engineOn false;_veh animate ["switch_starter",0];[("STR_A3PL_QuickActions_Vehicles_StarterDisengagedEngine1" call A3PL_Localize), Color_Red] call A3PL_Notification;};
	}
],
[
	"",
	"STR_Intersect_ClosedGasMotor2",
	{
		private _veh = player_objIntersect;
		if (_veh animationPhase "switch_starter" < 0.5) exitwith {[("STR_A3PL_QuickActions_Vehicles_ContactCFIForInstructions" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (!(_veh getVariable ["clearance",false])) exitwith {[("STR_A3PL_QuickActions_Vehicles_NoATCClearance" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		if (_veh animationPhase "switch_throttle2" < 0.5) then {_veh animate ["switch_throttle2",1];_veh animatesource ["throttleRTD1",0];[("STR_A3PL_QuickActions_Vehicles_ThrottleClosedEngine2" call A3PL_Localize), Color_Green] call A3PL_Notification;} else {_veh animate ["switch_throttle2",0];[("STR_A3PL_QuickActions_Vehicles_ThrottleOpenEngine2" call A3PL_Localize), Color_Red] call A3PL_Notification;};
	}
],
[
	"",
	"STR_Intersect_ToggleStarter2",
	{
		[] spawn {
			private _veh = player_objIntersect;
			if ((_veh animationPhase "switch_throttle2" < 0.5)or(player_objintersect animationSourcePhase "Inspect_Panel2_1" > 0.5)or(player_objintersect animationSourcePhase "Inspect_Panel1_1" > 0.5)) exitwith {[("STR_A3PL_QuickActions_Vehicles_ContactCFIForInstructions" call A3PL_Localize), Color_Red] call A3PL_Notification;};
			if (!(_veh getVariable ["clearance",false])) exitwith {[("STR_A3PL_QuickActions_Vehicles_NoATCClearance" call A3PL_Localize), Color_Red] call A3PL_Notification;};
			if (_veh animationPhase "switch_throttle2" > 0.5) then {
				[("Starter Engaged (Engine 2)" call A3PL_Localize), Color_Green] call A3PL_Notification;
				_veh animate ["switch_starter",2];
				sleep 1;
				_veh engineOn true;
				sleep 32;
				_veh animate ["switch_starter",0];
				[("STR_A3PL_QuickActions_Vehicles_StarterDisengagedEngine2" call A3PL_Localize), Color_Orange] call A3PL_Notification;
				sleep 0.5;
				[("STR_A3PL_QuickActions_Vehicles_StarterDisengagedEngine1" call A3PL_Localize), Color_Orange] call A3PL_Notification;
				sleep 0.5;
				_veh animate ["switch_throttle",0];
				[("STR_A3PL_QuickActions_Vehicles_ThrottleOpenEngine1" call A3PL_Localize), Color_Orange] call A3PL_Notification;
				sleep 0.5;
				_veh animate ["switch_throttle2",0];
				[("STR_A3PL_QuickActions_Vehicles_ThrottleOpenEngine2" call A3PL_Localize), Color_Orange] call A3PL_Notification;
			}
			else
			{_veh engineOn false;_veh animate ["switch_starter",1];[("STR_A3PL_QuickActions_Vehicles_StarterDisengagedEngine2" call A3PL_Localize), Color_Red] call A3PL_Notification;};
		};
	}
],
[
	"",
	"STR_Intersect_InspectEngine" + str 1,
	{
		private _veh = player_objIntersect;
		if (_veh animationSourcePhase "Inspect_Panel1_1" < 0.5) exitwith {};
		private _Inspection = _veh getVariable "Inspection";
		_Inspection pushBack "inspect_hitengine1";
		_veh setVariable ["Inspection",_Inspection,true];
		[("STR_A3PL_QuickActions_Vehicles_Engine1Completed" call A3PL_Localize), Color_Green] call A3PL_Notification;
	}
],
[
	"",
	"STR_Intersect_InspectEngine" + str 2,
	{
		private _veh = player_objIntersect;
		if (_veh animationSourcePhase "Inspect_Panel2_1" < 0.5) exitwith {};
		private _Inspection = _veh getVariable "Inspection";
		_Inspection pushBack "inspect_hitengine2";
		_veh setVariable ["Inspection",_Inspection,true];
		[("STR_A3PL_QuickActions_Vehicles_Engine2Completed" call A3PL_Localize), Color_Green] call A3PL_Notification;
	}
],
[
	"",
	"STR_Intersect_InspectMainRotor" + str 1,
	{
		private _veh = player_objIntersect;
		private _Inspection = _veh getVariable "Inspection";
		_Inspection pushBack "inspect_hithrotor1";
		_veh setVariable ["Inspection",_Inspection,true];
		[("STR_A3PL_QuickActions_Vehicles_Rotor1Completed" call A3PL_Localize), Color_Green] call A3PL_Notification;
	}
],
[
	"",
	"STR_Intersect_InspectMainRotor" + str 2,
	{
		private _veh = player_objIntersect;
		private _Inspection = _veh getVariable "Inspection";
		_Inspection pushBack "inspect_hithrotor2";
		_veh setVariable ["Inspection",_Inspection,true];
		[("STR_A3PL_QuickActions_Vehicles_Rotor2Completed" call A3PL_Localize), Color_Green] call A3PL_Notification;
	}
],
[
	"",
	"STR_Intersect_InspectMainRotor" + str 3,
	{
		private _veh = player_objIntersect;
		private _Inspection = _veh getVariable "Inspection";
		_Inspection pushBack "inspect_hithrotor3";
		_veh setVariable ["Inspection",_Inspection,true];
		[("STR_A3PL_QuickActions_Vehicles_Rotor3Completed" call A3PL_Localize), Color_Green] call A3PL_Notification;
	}
],
[
	"",
	"STR_Intersect_InspectMainRotor" + str 4,
	{
		private _veh = player_objIntersect;
		private _Inspection = _veh getVariable "Inspection";
		_Inspection pushBack "inspect_hithrotor4";
		_veh setVariable ["Inspection",_Inspection,true];
		[("STR_A3PL_QuickActions_Vehicles_Rotor4Completed" call A3PL_Localize), Color_Green] call A3PL_Notification;
	}
],
[
	"",
	"STR_Intersect_InspectRotorTailHash1",
	{
		private _veh = player_objIntersect;
		private _Inspection = _veh getVariable "Inspection";
		_Inspection pushBack "inspect_hitvrotor1";
		_veh setVariable ["Inspection",_Inspection,true];
		[("STR_A3PL_QuickActions_Vehicles_VerticalRotor1Completed" call A3PL_Localize), Color_Green] call A3PL_Notification;
	}
],
[
	"",
	"STR_Intersect_InspectRotorTailHash2",
	{
		private _veh = player_objIntersect;
		private _Inspection = _veh getVariable "Inspection";
		_Inspection pushBack "inspect_hitvrotor2";
		_veh setVariable ["Inspection",_Inspection,true];
		[("STR_A3PL_QuickActions_Vehicles_VerticalRotor2Completed" call A3PL_Localize), Color_Green] call A3PL_Notification;
	}
],
[
	"",
	"STR_Intersect_InspectRotorTailHub",
	{
		private _veh = player_objIntersect;
		private _Inspection = _veh getVariable "Inspection";
		_Inspection pushBack "inspect_hitvrotor3";
		_veh setVariable ["Inspection",_Inspection,true];
		[("STR_A3PL_QuickActions_Vehicles_VerticalRotorHubCompleted" call A3PL_Localize), Color_Green] call A3PL_Notification;
	}
],
[
	"",
	"STR_Intersect_InspectTransmission",
	{
		private _veh = player_objIntersect;
		private _Inspection = _veh getVariable "Inspection";
		_Inspection pushBack "inspect_hittransmission1";
		_veh setVariable ["Inspection",_Inspection,true];
		[("STR_A3PL_QuickActions_Vehicles_TransmissionCompleted" call A3PL_Localize), Color_Green] call A3PL_Notification;
	}
],
[
	"",
	"STR_Intersect_InspectFuel",
	{
		private _veh = player_objIntersect;
		private _Inspection = _veh getVariable "Inspection";
		_Inspection pushBack "inspect_hitfuel1";
		_veh setVariable ["Inspection",_Inspection,true];
		[("STR_A3PL_QuickActions_Vehicles_FuelIntakeCompleted" call A3PL_Localize), Color_Green] call A3PL_Notification;
	}
],
[
	"",
	"STR_Intersect_InspectSkate" + str 1,
	{
		private _veh = player_objIntersect;
		private _Inspection = _veh getVariable "Inspection";
		_Inspection pushBack "inspect_hitgear1";
		_veh setVariable ["Inspection",_Inspection,true];
		[("STR_A3PL_QuickActions_Vehicles_Skate1Completed" call A3PL_Localize), Color_Green] call A3PL_Notification;
	}
],
[
	"",
	"STR_Intersect_InspectSkate" + str 2,
	{
		private _veh = player_objIntersect;
		private _Inspection = _veh getVariable "Inspection";
		_Inspection pushBack "inspect_hitgear2";
		_veh setVariable ["Inspection",_Inspection,true];
		[("STR_A3PL_QuickActions_Vehicles_Skate2Completed" call A3PL_Localize), Color_Green] call A3PL_Notification;
	}
],
[
	"",
	"STR_Intersect_InspectSkate" + str 3,
	{
		private _veh = player_objIntersect;
		private _Inspection = _veh getVariable "Inspection";
		_Inspection pushBack "inspect_hitgear3";
		_veh setVariable ["Inspection",_Inspection,true];
		[("STR_A3PL_QuickActions_Vehicles_Skate3Completed" call A3PL_Localize), Color_Green] call A3PL_Notification;
	}
],
[
	"",
	"STR_Intersect_InspectSkate" + str 4,
	{
		private _veh = player_objIntersect;
		private _Inspection = _veh getVariable "Inspection";
		_Inspection pushBack "inspect_hitgear4";
		_veh setVariable ["Inspection",_Inspection,true];
		[("STR_A3PL_QuickActions_Vehicles_Skate4Completed" call A3PL_Localize), Color_Green] call A3PL_Notification;
	}
],
[
	"",
	"STR_Intersect_InspectHorizontalStabilizer" + str 1,
	{
		private _veh = player_objIntersect;
		private _Inspection = _veh getVariable "Inspection";
		_Inspection pushBack "inspect_hithstabilizerl11";
		_veh setVariable ["Inspection",_Inspection,true];
		[("STR_A3PL_QuickActions_Vehicles_HorizontalStabilizer1Completed" call A3PL_Localize), Color_Green] call A3PL_Notification;
	}
],
[
	"",
	"STR_Intersect_InspectHorizontalStabilizer" + str 2,
	{
		private _veh = player_objIntersect;
		private _Inspection = _veh getVariable "Inspection";
		_Inspection pushBack "inspect_hithstabilizerr11";
		_veh setVariable ["Inspection",_Inspection,true];
		[("STR_A3PL_QuickActions_Vehicles_HorizontalStabilizer2Completed" call A3PL_Localize), Color_Green] call A3PL_Notification;
	}
],
[
	"",
	"STR_Intersect_InspectLandingLight",
	{
		private _veh = player_objIntersect;
		private _Inspection = _veh getVariable "Inspection";
		_Inspection pushBack "inspect_hitlight1";
		_veh setVariable ["Inspection",_Inspection,true];
		[("STR_A3PL_QuickActions_Vehicles_LandingLightCompleted" call A3PL_Localize), Color_Green] call A3PL_Notification;
	}
],
[
	"",
	"STR_Intersect_InspectPilotTube" + str 1,
	{
		private _veh = player_objIntersect;
		private _Inspection = _veh getVariable "Inspection";
		_Inspection pushBack "inspect_hitpitottube1";
		_veh setVariable ["Inspection",_Inspection,true];
		[("STR_A3PL_QuickActions_Vehicles_PilotTube1Completed" call A3PL_Localize), Color_Green] call A3PL_Notification;
	}
],
[
	"",
	"STR_Intersect_InspectPilotTube" + str 2,
	{
		private _veh = player_objIntersect;
		private _Inspection = _veh getVariable "Inspection";
		_Inspection pushBack "inspect_hitpitottube2";
		_veh setVariable ["Inspection",_Inspection,true];
		[("STR_A3PL_QuickActions_Vehicles_PilotTube2Completed" call A3PL_Localize), Color_Green] call A3PL_Notification;
	}
],
[
	"",
	"STR_Intersect_InspectStaticPort" + str 1,
	{
		private _veh = player_objIntersect;
		private _Inspection = _veh getVariable "Inspection";
		_Inspection pushBack "inspect_hitstaticport1";
		_veh setVariable ["Inspection",_Inspection,true];
		[("STR_A3PL_QuickActions_Vehicles_StaticPort1Completed" call A3PL_Localize), Color_Green] call A3PL_Notification;
	}
],
[
	"",
	"STR_Intersect_InspectStaticPort" + str 2,
	{
		private _veh = player_objIntersect;
		private _Inspection = _veh getVariable "Inspection";
		_Inspection pushBack "inspect_hitstaticport2";
		_veh setVariable ["Inspection",_Inspection,true];
		[("STR_A3PL_QuickActions_Vehicles_StaticPort2Completed" call A3PL_Localize), Color_Green] call A3PL_Notification;
	}
],
[
	"",
	"STR_Intersect_InspectVerticalStabilizer",
	{
		private _veh = player_objIntersect;
		private _Inspection = _veh getVariable "Inspection";
		_Inspection pushBack "inspect_hitvstabilizer11";
		_veh setVariable ["Inspection",_Inspection,true];
		[("STR_A3PL_QuickActions_Vehicles_VerticalStabilizerCompleted" call A3PL_Localize), Color_Green] call A3PL_Notification;
	}
],
[
	"",
	"STR_Intersect_InspectIntake" + str 1,
	{
		private _veh = player_objIntersect;
		private _Inspection = _veh getVariable "Inspection";
		_Inspection pushBack "inspect_intake1";
		_veh setVariable ["Inspection",_Inspection,true];
		[("STR_A3PL_QuickActions_Vehicles_Intake1Completed" call A3PL_Localize), Color_Green] call A3PL_Notification;
	}
],
[
	"",
	"STR_Intersect_InspectIntake" + str 2,
	{
		private _veh = player_objIntersect;
		private _Inspection = _veh getVariable "Inspection";
		_Inspection pushBack "inspect_intake2";
		_veh setVariable ["Inspection",_Inspection,true];
		[("STR_A3PL_QuickActions_Vehicles_Intake2Completed" call A3PL_Localize), Color_Green] call A3PL_Notification;
	}
],

[
	"",
	"STR_Intersect_BonnetToggleLeft",
	{
        private _veh = player_objIntersect;
        if (_veh animationSourcePhase "Inspect_Panel1_1" < 0.5) then {
            _veh animateSource ["Inspect_Panel1_1",1];
        } else {
            _veh animateSource ["Inspect_Panel1_1",0];
        };
    }
],
[
	"",
	"STR_Intersect_BonnetToggleRight",
	{
        private _veh = player_objIntersect;
        if (_veh animationSourcePhase "Inspect_Panel2_1" < 0.5) then {
            _veh animateSource ["Inspect_Panel2_1",1];
        } else {
            _veh animateSource ["Inspect_Panel2_1",0];
        };
    }
],
[
    "",
    "STR_Intersect_RotatePlate",
    {
        private _veh = player_objIntersect;
        if (_veh animationSourcePhase "LPlate" < 0.5) then {
            _veh animateSource ["LPlate",1];
        } else {
			_veh animateSource ["LPlate",0];
        };
    }
],
[
	"",
	"STR_Intersect_UseGasCanister",
	{[player_objintersect] spawn A3PL_Vehicle_Jerrycan;}
],
// [
// 	"",
// 	"Raise / Lower Anchor",
// 	{[player_objintersect] spawn A3PL_Vehicle_Anchor;}
// ],
[
	"A3PL_WheelieBin",
	"STR_Intersect_TakeTrash",
	{[player_objintersect] call A3PL_Inventory_Pickup;}
],
[
	"A3PL_WheelieBin",
	"STR_Intersect_LoadTrash",
	{[player_objintersect] call A3PL_Waste_LoadBin;}
],
[
	"A3PL_P362_Garbage_Truck",
	"STR_Intersect_UnloadTrash",
	{[player_objintersect,player_nameintersect] call A3PL_Waste_UnloadBin;}
],
[
	"A3PL_P362_Garbage_Truck",
	"STR_Intersect_EmptyTrashTruck",
	{[player_objIntersect] call A3PL_Waste_EmptyTruck;}
],
[
	"",
	"STR_Intersect_LiftTrashLeft",
	{
		private _veh = player_objIntersect;
		if (_veh animationSourcePhase "Bin1" < 0.5) then {[_veh,"bin1"] call A3PL_Waste_FlipBin;};
	}
],
[
	"",
	"STR_Intersect_LowerTrashLeft",
	{
		private _veh = player_objIntersect;
		if (_veh animationSourcePhase "Bin1" > 0.5) then{_veh animateSource ["Bin1", 0.1];};
	}
],
[
	"",
	"STR_Intersect_LiftTrashRight",
	{
		private _veh = player_objIntersect;
		if (_veh animationSourcePhase "Bin2" < 0.5) then {[_veh,"bin2"] call A3PL_Waste_FlipBin;};
	}
],
[
	"",
	"STR_Intersect_LowerTrashRight",
	{
		private _veh = player_objIntersect;
		if (_veh animationSourcePhase "Bin2" > 0.5) then {_veh animateSource ["Bin2", 0.1];};
	}
],
[
	"",
	"STR_Intersect_DownUpVehicleRamp",
	{[player_objintersect] call A3PL_Vehicle_TrailerAttachObjects;}
],
[
	"",
	"STR_Intersect_SwitchMooringLine",
	{call A3PL_Vehicle_Mooring;}
],
// [
//     "",
//     "Toggle Hitch",
//     {
//         private _veh = player_objIntersect;
//         if (_veh animationSourcePhase "Hitch_Fold" < 0.5) then {
//             _veh animateSource ["Hitch_Fold",1];
//         } else {
//             _veh animateSource ["Hitch_Fold",0];
//         };
//     }
// ],
[
	"C_Van_02_transport_F",
	"STR_Intersect_DriverDoor",
	{
		private _veh = player_objintersect;
		private _name = Player_NameIntersect;
		if (_name != "door1") exitwith {};
		if (_veh animationSourcePhase "Door_1_source" == 0) then {
			_veh animateDoor ["Door_1_source", 1];
		} else {
			_veh animateDoor ["Door_1_source", 0];
		};
	}
],
[
	"C_Van_02_transport_F",
	"STR_Intersect_PassengerDoor",
	{
		private _veh = player_objintersect;
		private _name = Player_NameIntersect;
		if (_name != "door2") exitwith {};
		if (_veh animationSourcePhase "Door_2_source" < 0.5) then {
			_veh animateDoor ["Door_2_source", 1];
		} else {
			_veh animateDoor ["Door_2_source", 0];
		};
	}
],
[
	"C_Van_02_transport_F",
	"STR_Intersect_SideDoor",
	{
		private _veh = player_objintersect;
		private _name = Player_NameIntersect;
		if (_name != "door3") exitwith {};
		if (_veh animationSourcePhase "Door_3_source" < 0.5) then {
			_veh animateDoor ["Door_3_source", 1];
		} else {
			_veh animateDoor ["Door_3_source", 0];
		};
	}
],
[
	"A3FL_AS_365",
	"STR_Intersect_Battery",
	{
		private _veh = player_objintersect;
		if (_veh animationPhase "Battery" < 0.5) exitwith {
			_veh animate ["battery",1];
			playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
		};
		_veh animate ["battery",0];
		playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
	}
],
[
	"A3FL_AS_365",
	"STR_Intersect_UseAPUGenerator",
	{
		private _veh = player_objintersect;
		if (_veh animationPhase "gen1" < 0.5) exitwith {
			if (_veh animationPhase "battery" < 0.5) exitwith {[("STR_A3PL_QuickActions_Vehicles_BatteryOff" call A3PL_Localize), Color_Red] call A3PL_Notification;};
			if (_veh animationPhase "ecs" < 0.5) exitwith {[("STR_A3PL_QuickActions_Vehicles_ECSNotOnAPUBoost" call A3PL_Localize), Color_Red] call A3PL_Notification;};
			if (_veh animationPhase "fuelpump" > 0.5) exitwith {[("STR_A3PL_QuickActions_Vehicles_FuelPumpNotOnAPUBoost" call A3PL_Localize), Color_Red] call A3PL_Notification;};
			if (_veh animationPhase "apucontrol" < 0.5) exitwith {[("STR_A3PL_QuickActions_Vehicles_APUControlNotOnAPUBoost" call A3PL_Localize), Color_Red] call A3PL_Notification;};
			_veh animate ["gen1",1];
			playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
		};
		_veh animate ["gen1",0];
		playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
	}
],
[
	"A3FL_AS_365",
	"STR_Intersect_UseGeneratorNumber" + str 1,
	{
		private _veh = player_objintersect;
		if (_veh animationPhase "gen2" < 0.5) exitwith {
			_veh animate ["gen2",1];
			playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
		};
		_veh animate ["gen2",0];
		playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
	}
],
[
	"A3FL_AS_365",
	"STR_Intersect_UseGeneratorNumber" + str 2,
	{
		private _veh = player_objintersect;
		if (_veh animationPhase "gen3" < 0.5) exitwith {
			_veh animate ["gen3",1];
			playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
		};
		_veh animate ["gen3",0];
		playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
	}
],
[
	"A3FL_AS_365",
	"STR_Intersect_UseECS",
	{
		private _veh = player_objintersect;
		if (_veh animationPhase "ecs" < 0.5) exitwith {
			_veh animate ["ecs",1];
			playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
		};
		_veh animate ["ecs",0];
		playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
	}
],
[
	"A3FL_AS_365",
	"STR_Intersect_FuelPump",
	{
		private _veh = player_objintersect;
		if (_veh animationPhase "fuelpump" < 0.5) exitwith {
			_veh animate ["fuelpump",1];
			playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
		};
		_veh animate ["fuelpump",0];
		playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
	}
],
[
	"A3FL_AS_365",
	"STR_Intersect_APUControl",
	{
		private _veh = player_objintersect;
		if (_veh animationPhase "apucontrol" < 0.5) exitwith {
			_veh animate ["apucontrol",1];
			playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
		};
		_veh animate ["apucontrol",0];
		playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
	}
],
[
	"A3FL_AS_365",
	"STR_Intersect_StartSwitch2",
	{
		private _veh = player_objintersect;
		if (_veh animationPhase "ignition_Switch" > 0.5) exitwith {
			_veh animate ["ignition_Switch",0];
			_veh engineOn false;
			playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
		};
		if (_veh animationPhase "ignition_Switch" < 0.5) exitwith {
			if (_veh animationPhase "battery" < 0.5) exitwith {[("STR_A3PL_QuickActions_Vehicles_BatteryOff" call A3PL_Localize), Color_Red] call A3PL_Notification;};
			if (_veh animationPhase "ecs" > 0.5) exitwith {[("STR_A3PL_QuickActions_Vehicles_ECSNotOnEngine" call A3PL_Localize), Color_Red] call A3PL_Notification;};
			if (_veh animationPhase "fuelpump" < 0.5) exitwith {[("STR_A3PL_QuickActions_Vehicles_FuelPumpNoOnFuelPrime" call A3PL_Localize), Color_Red] call A3PL_Notification;};
			if (_veh animationPhase "apucontrol" < 0.5) exitwith {[("STR_A3PL_QuickActions_Vehicles_APUControlNotOnAPUBoost" call A3PL_Localize), Color_Red] call A3PL_Notification;};
			if (_veh animationPhase "gen1" < 0.5) exitwith {[("STR_A3PL_QuickActions_Vehicles_APUisOff" call A3PL_Localize), Color_Red] call A3PL_Notification;};
			if (_veh animationPhase "gen2" < 0.5) exitwith {[("STR_A3PL_QuickActions_Vehicles_Generator2NotOnON" call A3PL_Localize), Color_Red] call A3PL_Notification;};
			if (_veh animationPhase "gen3" < 0.5) exitwith {[("STR_A3PL_QuickActions_Vehicles_Generator3NotOnON" call A3PL_Localize), Color_Red] call A3PL_Notification;};
			_veh animate ["gen1",0];
			_veh animate ["ignition_Switch",1];
			[_veh] spawn {
				private ['_veh'];
				_veh = _this select 0;
				sleep 1;
				_veh engineOn true;
			};
			playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
		};
		_veh animate ["ignition_Switch",0];
		playSound3D ["a3\ui_f\data\Sound\CfgCutscenes\repair.wss", player];
	}
],
[
	"",
	"STR_Intersect_RemoveFakePlate",
	{
		[Player_ObjIntersect] spawn A3FL_Police_RemoveFakePlate;
	}
],
[
	"FYD_Parras_Drill",
	"STR_Intersect_ToggleStabilizers",
	{
		private _veh = player_objintersect;
		if (typeOf _veh isNotEqualTo "FYD_Parras_Drill") exitwith {};
		if (_veh animationPhase "stabilisateur_stick" == 0) then {
			_veh animate ["stabilisateur_stick",8];
		} else {
			_veh animate ["stabilisateur_stick",0];
		};
	}
]
