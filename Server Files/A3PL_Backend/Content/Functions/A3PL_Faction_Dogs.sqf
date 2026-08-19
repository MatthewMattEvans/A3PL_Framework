/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Dogs_OpenMenu",
{
	if(!(isNull(player getVariable["Player_Dog",objNull]))) exitwith {[("STR_A3PL_Dogs_AlreadyHasDog" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	createDialog "Dialog_Kane9";
	private _display = findDisplay 93;
	_display call A3PL_Dialog_Localize;
	private _control = _display displayCtrl 1500;
	private _dogs = [["Locky","Alsatian_Sand_F"],["Kane","Alsatian_Black_F"],["Lilith","Alsatian_Sandblack_F"]];
	{
		_i = _control lbAdd (_x select 0);
		_control lbSetData [_i,(_x select 1)];
	} foreach _dogs;
	_control lbSetCurSel 0;
}] call compile_Global;

["A3PL_Dogs_BuyRequest",
{
	private _class = lbData [1500,(lbCurSel 1500)];
	[("STR_A3PL_Dogs_TakeDogFromCage" call A3PL_Localize),Color_Green] call A3PL_Notification;
	["woaf"] call PO_Achievement_Learn;
	[player,_class] remoteExec ["Server_Dogs_BuyRequest",2];
	closeDialog 0;
}] call compile_Global;

["A3PL_Dogs_ReturnDog",
{
	private _dog = (player getVariable ["Player_Dog", objNull]);
	if (isNull _dog) exitWith {[("STR_A3PL_Dogs_NoDogToReturn" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	deleteVehicle _dog;
	player setVariable ["Player_Dog", objNull];
	[("STR_A3PL_Dogs_ReturnedDog" call A3PL_Localize),Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Dogs_BuyReceive",
{
	private _class = param [0,"Alsatian_Sand_F"];
	private _dog = createAgent [_class, getPosATL player, [], 1, "CAN_COLLIDE"];
	_dog setposATL (getposATL player);
	_dog playMove "Dog_Sit";

	player setVariable["Player_Dog",_dog,false];
	_dog setVariable["Dog_Moving",false,true];
	_dog setVariable ["BIS_fnc_animalBehaviour_disable", true];
	[_dog] spawn {
		private _dog = param [0,objNull];
		private _doDrugsCheck = 0;
		private _moved = false;
		while {alive _dog} do
		{
			sleep 0.5;
			private _moving = _dog getVariable["Dog_Moving",false];
			if (!isNull objectParent player) then
			{
				if (!(attachedTo _dog == (vehicle player))) then
				{
					_attachPoint = [0,-0.2,-0.6];
					_dir = 0;
					switch (typeOf (vehicle player)) do
					{
						case ("A3PL_Tahoe_FD"): {_attachPoint = [0,0.2,-1.1]};
						case ("A3PL_Tahoe_PD"): {_attachPoint = [0,0.2,-1.1]};
						case ("A3PL_Tahoe_PD_Slicktop"): {_attachPoint = [0,0.2,-1.1]};
						case ("A3PL_CVPI_PD"): {_attachPoint = [0,-0.3,-1.1]};
						case ("A3PL_CVPI_PD_Slicktop"): {_attachPoint = [0,-0.3,-1.1]};
						case ("A3PL_Mustang_PD"): {_attachPoint = [0,0.2,-1.1]};
						case ("A3PL_Mustang_PD_Slicktop"): {_attachPoint = [0,0.2,-1.1]};
						case ("A3PL_Charger_PD"): {_attachPoint = [0,0.2,-1.2]};
						case ("A3PL_Charger_PD_Slicktop"): {_attachPoint = [0,0.2,-1.2]};
						case ("A3PL_Charger15_PD"): {_dir = -90; _attachPoint = [-0.4,-0.85,0.35]};
						case ("A3PL_Charger15_PD_ST"): {_dir = -90; _attachPoint = [-0.4,-0.85,0.35]};
						case ("A3PL_Silverado_PD"): {_attachPoint = [0,0.42,0.95]};
						case ("A3PL_Silverado_PD_ST"): {_attachPoint = [0,0.42,0.95]};
						case ("A3PL_RBM"): {_attachPoint = [0,0.2,-1.1]};
						case ("A3PL_Jayhawk"): {_attachPoint = [0,0.2,-1.1]};
						case ("A3FL_AS_365"): {_attachPoint = [0,2,-2]};
						case ("A3FL_Explorer_Platinum_PD_20"): {_attachPoint = [0,-1,-1.1]};
						case ("A3FL_Explorer_PD_K9_20"): {_attachPoint = [-0.25,0,-1.25]};
						case ("A3FL_Explorer_Platinum_PD_Slicktop_20"): {_attachPoint = [0,-1,-1.1]};
						case ("A3FL_Taurus_PD"): {_attachPoint = [0,0.45,-0.98]};
						case ("A3FL_Taurus_PD_ST"): {_attachPoint = [0,0.45,-0.98]};
						case ("A3FL_Mustang15_PD"): {_dir = 90; _attachPoint = [0.5,-0.4,0.5]};
						case ("A3FL_Mustang15_PD_ST"): {_dir = 90; _attachPoint = [0.5,-0.4,0.5]};
						case ("A3FL_Tahoe_PD"): {_attachPoint = [0,-1,-1.1]};
						case ("A3FL_Tahoe_PD_ST"): {_attachPoint = [0,-1,-1.1]};
						case ("A3FL_F150_PD"): {_attachPoint = [0,0.7,-1]};
						case ("A3FL_F150_PD_ST"): {_attachPoint = [0,0.7,-1]};
						case ("A3FL_CamaroZL1_PD"): {_attachPoint = [0,0.2,-1.1]};
						case ("A3FL_CamaroZL1_PD_ST"): {_attachPoint = [0,0.2,-1.1]};
						case ("A3PL_Challenger_Hellcat_PD_ST"): {_attachPoint = [0,0.2,-1.1]};
					};
					_dog attachto [vehicle player,_attachPoint];
					_dog setDir _dir;
					_dog playMoveNow "Dog_Sit";
				};
			} else {
				if(_moving) then {
					if (vehicle player == player) then {
						if (!isNull (attachedTo _dog)) then {detach _dog;};
					};
					if (((player distance _dog) > 5)) then {
						if((player distance _dog) > 20) then {
							_dog playMoveNow "Dog_Sprint";
						} else {
							_dog playMoveNow "Dog_Walk";
						};
						_moved = true;
						_dog moveTo (getpos player);
					} else {
						if(_moved) then {
							_dog playMoveNow "Dog_Stop";
							_moved = false;
						};
					};
				} else {
					if(_moved) then {
						_dog playMoveNow "Dog_Stop";
						_moved = false;
					};
				};

				_doDrugsCheck = _doDrugsCheck + 0.5;
				if (_doDrugsCheck >= 6) then
				{
					private ["_nearbyPlayers","_foundDrugs"];
					_doDrugsCheck = 0;
					_foundDrugs = false;

					_nearbyPlayers = [];
					{
						if ((_dog distance2D _x) < 5) then {_nearbyPlayers pushback _x;};
					} foreach allPlayers;
					{
						private ["_player"];
						_player = _x;
						{
							if ([_x,1,_player] call A3PL_Inventory_Has) exitwith {_foundDrugs = true;};
						} foreach Dogs_Illegal_Items;
					} foreach _nearbyPlayers;

					_nearestVehicle = (nearestObjects [player,["Car"],Dogs_Smell_Distance]) select 0;
					if(!(isNil "_nearestVehicle")) then {
						_storage = _nearestVehicle getVariable["storage",[]];
						{
							if(_x select 0 in Dogs_Illegal_Items) exitwith {_foundDrugs = true;};
						} foreach _storage;
					};
					if ((count (nearestObjects [_dog,Dogs_Illegal_3D_Items, Dogs_Smell_Distance])) > 0) then {_foundDrugs = true; };
					if (_foundDrugs) then { playSound3D ["A3PL_Common\effects\dogbark.ogg", _dog, false, getPosASL _dog, 7, 1, 50]; };
				};
			};
		};
	};
	[("STR_A3PL_Dogs_Following" call A3PL_Localize),Color_Green] call A3PL_Notification;
	[_dog] remoteExec ["Server_Dogs_HandleLocality", 2];
}] call compile_Global;
