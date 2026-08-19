/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
['A3PL_Loading_Start',
{
	[] spawn {
		disableSerialization;

		disableUserInput true;
		player allowDamage false;
		player setVariable ["tf_voiceVolume", 0, true];

		/*if (!isServer) then
		{
			["A3PL_Common\ogv\logo_base_animated.ogv"] call BIS_fnc_titlecard;
			uiSleep 6;
		};*/

		cutText["","BLACK OUT"];

		createDialog "Dialog_Loading";
		private _display = findDisplay 15;

		uiSleep 1.5;

		_control = (_display displayCtrl 10360);
		_format = "<t size='1' align='center' color='#B8B8B8'>0%</t>";
		_control ctrlSetStructuredText (parseText _format);

		uiSleep 0.5;

		_control = (_display displayCtrl 10359);
		_format = ("STR_A3PL_Loading_LoadingPlayerData" call A3PL_Localize);
		_control ctrlSetStructuredText (parseText _format);

		_control = (_display displayCtrl 11059);
		_control progressSetPosition 0.5;

		uiSleep 1.5;

		noEscape = _display displayAddEventHandler ["KeyDown", "if ((_this select 1) == 1) then {true}"];

		call A3PL_Loading_Request;
	};
}] call compile_Global;

["A3PL_Loading_Request",
{
	[] spawn {
		private ["_waiting","_display","_control", '_format',"_pos"];
		disableSerialization;

		_display = findDisplay 15;

		_control = (_display displayCtrl 10359);
		_format = ("STR_A3PL_Loading_InitializeServerFunction" call A3PL_Localize);
		_control ctrlSetStructuredText (parseText _format);

		_control = (_display displayCtrl 11059);
		_control progressSetPosition 0.3;

		_control = (_display displayCtrl 10360);
		_format = "<t size='2' align='center' color='#B8B8B8'>30%</t>";
		_control ctrlSetStructuredText (parseText _format);

		uiSleep 1.5;

		waitUntil {uiSleep 0.5; player == player};
		_pos = getpos player;

		[player] remoteExec ["Server_Gear_CheckUser", 2];

		_control = (_display displayCtrl 10359);
		_format = ("STR_A3PL_Loading_InitializePlayerEquipement" call A3PL_Localize);
		_control ctrlSetStructuredText (parseText _format);

		_waiting = 0;
		while {isNil "A3PL_RetrievedInventory"} do
		{
			uiSleep 1;
			_waiting = _waiting + 2;
			if (_waiting > 10) then
			{
				[player] remoteExec ["Server_Gear_CheckUser", 2];
				_waiting = 0;
			};
		};

		player setVariable ["Zipped",false,true];
		player setVariable ["picking",false,true];
		player setVariable ["working",false,true];
		player setVariable ["DoubleTapped",false,true];

		_control = (_display displayCtrl 11059);
		_control progressSetPosition 0.4;

		_control = (_display displayCtrl 10360);
		_format = "<t size='2' align='center' color='#B8B8B8'>40%</t>";
		_control ctrlSetStructuredText (parseText _format);

		uiSleep 1.5;

		_control = (_display displayCtrl 10359);
		_format = ("STR_A3PL_Loading_HouseInitialization" call A3PL_Localize);
		_control ctrlSetStructuredText (parseText _format);

		_control = (_display displayCtrl 11059);
		_control progressSetPosition 0.5;

		uiSleep 1.5;

		_control = (_display displayCtrl 10360);
		_format = "<t size='2' align='center' color='#B8B8B8'>50%</t>";
		_control ctrlSetStructuredText (parseText _format);

		_control = (_display displayCtrl 10359);
		_format = ("STR_A3PL_Loading_PlayerVarsInitialization" call A3PL_Localize);
		_control ctrlSetStructuredText (parseText _format);

		uiSleep 1.5;

		_format = ("STR_A3PL_Loading_PlayerVehiclesInitialization" call A3PL_Localize);
		_control ctrlSetStructuredText (parseText _format);

		A3PL_Vehicle_HandleInitU = toArray (format ["%1",A3PL_Vehicle_HandleInitU]);
		A3PL_Vehicle_HandleInitU deleteAt 0;
		A3PL_Vehicle_HandleInitU deleteAt ((count A3PL_Vehicle_HandleInitU) - 1);
		A3PL_Vehicle_HandleInitU = toString A3PL_Vehicle_HandleInitU;
		A3PL_HandleVehicleInit = compileFinal A3PL_Vehicle_HandleInitU;

		_control = (_display displayCtrl 11059);
		_control progressSetPosition 0.9;

		uiSleep 1.5;

		_control = (_display displayCtrl 10360);
		_format = "<t size='2' align='center' color='#B8B8B8'>70%</t>";
		_control ctrlSetStructuredText (parseText _format);

		_control = (_display displayCtrl 10359);
		_format = ("STR_A3PL_Loading_PlayerVehiclesInitializationFinished" call A3PL_Localize);
		_control ctrlSetStructuredText (parseText _format);

		uiSleep 1.5;

		_control = (_display displayCtrl 10360);
		_format = "<t size='2' align='center' color='#B8B8B8'>80%</t>";
		_control ctrlSetStructuredText (parseText _format);

		_control = (_display displayCtrl 10359);
		_format = ("STR_A3PL_Loading_MedicalStatsInitialization" call A3PL_Localize);
		_control ctrlSetStructuredText (parseText _format);

		uiSleep 1.5;

		_control = (_display displayCtrl 11059);
		_control progressSetPosition 1;

		_control = (_display displayCtrl 10360);
		_format = "<t size='2' align='center' color='#B8B8B8'>100%</t>";
		_control ctrlSetStructuredText (parseText _format);

		uiSleep 1.5;

		_control = (_display displayCtrl 10359);
		_format = ("STR_A3PL_Loading_PlayerInitialized" call A3PL_Localize);
		_control ctrlSetStructuredText (parseText _format);

		uiSleep 1.5;

		closeDialog 0;

		if((player getVariable["alreadySpawned",false])) then {
			cutText["","BLACK IN"];
			player enableSimulation true;
		} else {
			call A3PL_Player_SpawnMenu;
			[] spawn A3PL_Player_NewPlayerTutorial;
		};

		player setVariable ["tf_voiceVolume", 1, true];
		call A3PL_Admin_Check;

		player setvariable ["FinishedLoading",true,true];
		_display displayRemoveEventHandler ["KeyDown", noEscape];
		
		showChat false;
		disableUserInput false;
		sleep 60;
		player allowDamage true;

		[] spawn A3PL_SmartMarker_Init;
		[] spawn A3PL_SmartMarker_InitCompanyShops;
	};
}] call compile_Global;
