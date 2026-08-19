/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Items_Thirst",
{
	private _classname = Player_ItemClass;
	private _quality = [_classname,0] call A3PL_Config_GetThirst;
	private _alcohol = [_classname,1] call A3PL_Config_GetThirst;
	private _coffeeTime = [_classname,2] call A3PL_Config_GetThirst;
	private _pee = [_classname,3] call A3PL_Config_GetThirst;
	private _sleep = [_classname,4] call A3PL_Config_GetThirst;
	if (Player_ItemClass isEqualTo "") exitwith {[("STR_A3PL_Items_DrinkErrorClass" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!isNil "Player_isDrinking") exitwith {[("STR_A3PL_Items_AlreadyDrinkSomething" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	Player_isDrinking = true;

	[_classname, -1] call A3PL_Inventory_Add;
	if(_classname isEqualTo "waterbottle") then {["waterbottlempty", 1] call A3PL_Inventory_Add;};

	player playAction "Gesture_drink";
	Player_Item attachTo [player, [-0.03,0,0.1], 'LeftHand'];
	sleep 3;
	Player_Item setVectorDirAndUp [[0,0,-1],[0,-1,0]];
	sleep 3;
	Player_Item setVectorDirAndUp [[0,1,0],[0,0,1]];
	sleep 4.5;

	if (_coffeeTime > 0) then {
		if (!(player getVariable ["UsingCoffee", false])) then {
			player setVariable ["UsingCoffee", true, false];
			[_coffeeTime] spawn {
				[format[("STR_A3PL_Items_YouDrinkedCoffee" call A3PL_Localize), (_this select 0)],Color_Green] call A3PL_Notification;
				player setAnimSpeedCoef 1.2;
				sleep ((_this select 0) * 60);
				[("STR_A3PL_Items_NoCafeineSoon" call A3PL_Localize),Color_Amber] call A3PL_Notification;
				player setAnimSpeedCoef 0.7;
				sleep 180;
				[("STR_A3PL_Items_EnergyBackToNormal" call A3PL_Localize),Color_Green] call A3PL_Notification;
				player setAnimSpeedCoef 1;
				player setVariable ["UsingCoffee", false, false];
			};
		} else {
			[("STR_A3PL_Items_NoImpactForThisCoffee" call A3PL_Localize),Color_Amber] call A3PL_Notification;
		};
	};

	if(_alcohol) then {
		[_quality] call A3PL_Alcohol_Add;
		if (_pee > 0) then {[_pee] call A3PL_Items_PeeAdd;};
		if ((_sleep > 0) && (Sleep_System == true)) then {[_sleep] call A3PL_Items_SleepAdd;};
	} else {
		Player_Thirst = Player_Thirst + _quality;
		call A3PL_Lib_VerifyThirst;
		player setVariable ["player_thirst",Player_Thirst,false];
		if((_classname isEqualTo "waterbottle") && (Player_Alcohol > 0)) then {
			[-5] call A3PL_Alcohol_Add;
			call A3PL_Alcohol_Verify;
		};
		if (Player_Thirst > 50) then { A3PL_ThirstWarning1 = Nil; };
		if (Player_Thirst > 20) then { A3PL_ThirstWarning2 = Nil; };
		if (Player_Thirst > 10) then { A3PL_ThirstWarning3 = Nil; };
		if (_pee > 0) then {[_pee] call A3PL_Items_PeeAdd;};
		if ((_sleep > 0) && (Sleep_System == true)) then {[_sleep] call A3PL_Items_SleepAdd;};
		[format[("STR_A3PL_Items_YoUDrinked" call A3PL_Localize), [_classname, "name"] call A3PL_Config_GetItem, _quality,"%"],Color_Green] call A3PL_Notification;
	};

	Player_ItemAmount = Player_ItemAmount - 1;
	if(Player_ItemAmount isEqualTo 0) then{[] call A3PL_Inventory_Clear;};

	Player_isDrinking = nil;
}] call compile_Global;

["A3PL_Items_PeeAdd",
{
	if (Pee_System == false) exitWith {};
	private _add = param [0,0];
	Player_Pee = Player_Pee - (_add);
	player setVariable ["player_pee",Player_Pee,false];
}] call compile_Global;

["A3PL_Items_SleepAdd",
{
	if (Sleep_System == false) exitWith {};
	private _add = param [0,0];
	Player_Sleep = Player_Sleep + _add;
	player setVariable ["player_sleep",Player_Sleep,false];
}] call compile_Global;

["A3PL_Items_Food",
{
	private _classname = Player_ItemClass;
	private _quality = [_classname,0] call A3PL_Config_GetFood;
	private _drug = [_classname,1] call A3PL_Config_GetFood;
	private _sleep = [_classname,2] call A3PL_Config_GetFood;
	if (Player_ItemClass isEqualTo "") exitwith {[("STR_A3PL_Items_EatErrorClass" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!isNil "Player_isEating") exitwith {[("STR_A3PL_Items_AlreadyEatSomething" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!([_classname,1] call A3PL_Inventory_Has)) exitwith {[("STR_A3PL_Items_AreYouTryingToEatSomethingYouDoesntHave" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	Player_isEating = true;
	player playActionNow "gesture_eat";
	[_classname, -1] call A3PL_Inventory_Add;

	if(_drug) then {
		[_classname,_quality] call A3PL_Drugs_Add;
		if ((_sleep > 0) && (Sleep_System == true)) then {[_sleep] call A3PL_Items_SleepAdd;};
	} else {
		Player_Hunger = Player_Hunger + _quality;
		call A3PL_Lib_VerifyHunger;
		player setVariable ["player_hunger",Player_Hunger,false];
		if ((_sleep > 0) && (Sleep_System == true)) then {[_sleep] call A3PL_Items_SleepAdd;};
		if (_quality > 0) then {
			[format[("STR_A3PL_Items_YouEated" call A3PL_Localize), [_classname, "name"] call A3PL_Config_GetItem, _quality,"%"],Color_Green] call A3PL_Notification;
		};
		if (Player_Hunger > 50) then {A3PL_HungerWarning1 = Nil;};
		if (Player_Hunger > 20) then {A3PL_HungerWarning2 = Nil;};
		if (Player_Hunger > 10) then {A3PL_HungerWarning3 = Nil;};
	};

	[] spawn {
		sleep 3;
		Player_ItemAmount = Player_ItemAmount - 1;
		if(Player_ItemAmount isEqualTo 0) then{[] call A3PL_Inventory_Clear;};
		Player_isEating = Nil;
	};
}] call compile_Global;

["A3PL_Items_IgniteRocket",
{
	private ["_rocket","_color"];

	_rocket = param [0,objNull];
	if ((isPlayer (attachedTo _rocket)) && (!((attachedTo _rocket) isKindOf "Car"))) exitwith {[("STR_A3PL_Items_SomeoneTakeThisFirework" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!local _rocket) exitwith {[("STR_A3PL_Items_LOcalErrorFireworks" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((_rocket animationSourcePhase "fuse") > 0) exitwith {};
	_color = _rocket getVariable ["class","rocket_blue"];

	_rocket setVariable ["inUse",true,true];

	_rocket animateSource ["fuse",2];
	uiSleep 4;

	[_rocket,_color] remoteExec ["A3PL_Items_RemoteRocket", -2];
	_rocket setVelocity [(-20 + (random 40)),(-20 + (random 40)),(50 + random 50)];

	uiSleep 3;
	deleteVehicle _rocket;
}] call compile_Global;

["A3PL_Items_RemoteRocket",
{
	private ["_rocket","_color","_pos","_i","_r","_g","_b","_s1","_sparks"];

	_rocket = param [0,objNull];
	_color = param [1,"rocket_blue"];

	//wait until the rocket is deleted, upon deletion we will do our fireworks :D
	_i = 0;
	_pos = getPos _rocket;
	waitUntil {_i = _i + 1; if (_i > 100) exitwith {true}; if (!isNull _rocket) then {_pos = getpos _rocket;}; sleep 0.1; isNull _rocket};
	if (_i > 100) exitwith {};

	_sparks = [];

	for "_ii" from 0 to 15 do
	{
		_s = "#particlesource" createVehicleLocal _pos;
		_sparks pushback _s;
	};

	_r = 0;
	_g = 0;
	_b = 1;

	switch (_color) do
	{
		case "rocket_blue": {_r = 0.02; _g = 0; _b =1};
		case "rocket_red": {_r = 1; _g = 0; _b = 0.02};
		case "rocket_green": {_r = 0.02; _g = 1; _b = 0};
		case "rocket_yellow": {_r = 0.95; _g = 0.95; _b = 0.05};
	};

	//lightpoint
	_lP = "#lightpoint" createVehiclelocal _pos;
	_lP setLightBrightness 30;
	_lP setLightDayLight true;
	_lP setLightAmbient [_r,_g,_b];
	_lP setLightColor [_r,_g,_b];

	//sound
	_logic = "Logic" createVehiclelocal _pos;
	_logic say3D [selectRandom ["firework1","firework2","firework3"], 1500, 1];

	{
		_vel = [(-10 + random 20),(-10 + random 20),(-10 + random 20)];
		_x setParticleCircle [0, [0, 0, 30]];
		_x setParticleRandom [0.5, [0, 0, 0], [0, 0, 0], 0, 0.5, [_r,_g,_b, 1], 1, 0];
		_x setParticleParams [["\A3\data_f\cl_exp", 1, 0, 1], "", "Billboard", 1, 2, [0, 0, 0], _vel, 0, 70, 0, 0, [0.5,1], [[_r,_g,_b, 1],[_r,_g,_b, 0.5]], [0.08], 1, 0, "", "",_x];
		_x setDropInterval 0.01;
	} foreach _sparks;

	uisleep 1;

	//main
	_pS = "#particlesource" createVehicleLocal [(_pos select 0),(_pos select 1),((_pos select 2) + random 10)];
	_xx = selectRandom [-7,7];
	_yy = selectRandom [-5,7];
	_zz = selectRandom [-8,5];
	_pS setParticleCircle [0, [_xx, _yy, _zz]];
	_pS setParticleRandom [0, [0, 0, 0], [_xx, _yy, _zz], 0, 0.5, [_r,_g,_b, 1], 1, 0];
	_pS setParticleParams [["\A3\data_f\cl_exp", 1, 0, 1], "", "Billboard", 1, 1.5, [0, 0, 0], [_xx, _yy, _zz], 0, 50, 0, 0, [0.5,1], [[_r, _g,_b, 1],[_r, _g, _b, 0.5]], [0.08], 1, 0, "", "",_pS];
	_pS setDropInterval 0.0005;


	uiSleep 1;
	deleteVehicle _pS;
	{
		deleteVehicle _x;
	} foreach _sparks;

	uiSleep 3;
	deleteVehicle _lP;
	deleteVehicle _logic;
}] call compile_Global;

["A3PL_Items_FillBottle",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private _classname = Player_ItemClass;
	private _amount = Player_ItemAmount;
	if(_classname != "waterbottlempty") exitwith {[("STR_A3PL_Items_NoBottleHands" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!([_classname,_amount] call A3PL_Inventory_Has)) exitwith {[("STR_A3PL_Items_NoBottleHands" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[_classname, -_amount] call A3PL_Inventory_Add;
	["waterbottle", _amount] call A3PL_Inventory_Add;
	[false] call A3PL_Inventory_PutBack;
}] call compile_Global;

["A3PL_Items_ThrowPopcornClient",
{
	if (!(player_itemclass == "popcornbucket")) exitwith {[("STR_A3PL_Items_NoPopcorn" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _remoteExecuteList = [];
	{
		if (player distance _x < 25) then
		{
			_remoteExecuteList pushback _x;
		};
	} foreach allPlayers;

	[[player],"A3PL_Items_ThrowPopcorn",_remoteExecuteList,false] call BIS_fnc_MP;
	player playaction "Gesture_throw";
}] call compile_Global;

["A3PL_Items_ThrowPopcorn",
{
	if (isDedicated) exitwith {};
	private ["_playerVelocity","_playerDir","_player","_popcorn"];

	_player = param [0,objNull];
	if ((isNull _player) OR (!isPlayer _player)) exitwith {};

	_popcorn = [];
	for "_i" from 0 to 15 do
	{
		_v = "A3PL_Popcorn" createVehicleLocal (getPos _player);
		_v attachTo [_player,[0,0,0],"RightHand"];
		_popcorn pushback _v;
	};

	_playerVelocity = velocity _player;
	_playerDir = eyeDirection _player;
	_playerDir = (_playerDir select 0) atan2 (_playerDir select 1);
	{
		_dir = (_playerDir-20) + random 40;
		detach _x;
		_x setVelocity [((_playerVelocity select 0) + (sin _dir * 5)), ((_playerVelocity select 1) + (cos _dir * 5)), ((_playerVelocity select 2) + (2+random 3))];
	} foreach _popcorn;

	uiSleep 5;
	{
		deleteVehicle _x;
	} foreach _popcorn;
}] call compile_Global;

["A3PL_Items_GrabPopcorn",
{
	if (["popcornbucket",1] call A3PL_Inventory_Has) then
	{
		[("STR_A3PL_Items_YoUAlreadyHavePopcorn" call A3PL_Localize),Color_Red] call A3PL_Notification;
	} else
	{
		[[player,"popcornbucket",1],"Server_Inventory_Add",false] call Bis_fnc_MP;
		[("STR_A3PL_Items_YouTakedPopcorn" call A3PL_Localize),Color_Green] call A3PL_Notification;
	};
}] call compile_Global;

["A3PL_Items_Cigs",
{
    private _classname = Player_ItemClass;
    private _nvItem = "cigs_morley_cig0_nv"; 
    private _hungerModifier = 1; 
    private _lighterItem = "cigs_lighter"; 

    if (_classname isEqualTo "") exitWith {
        [("STR_A3PL_Items_CigaretsError" call A3PL_Localize), Color_Red] call A3PL_Notification;
    };

    if (!isNil "Player_isUsingItem") exitWith {
        [("STR_A3PL_Items_AlreadyUsingThis" call A3PL_Localize), Color_Red] call A3PL_Notification;
    };

    if (!([_lighterItem, 1] call A3PL_Inventory_Has)) exitWith {
        [("STR_A3PL_Items_NeedsLIght" call A3PL_Localize), Color_Red] call A3PL_Notification;
    };

    if (_nvItem in assignedItems player) then {
        [("STR_A3PL_Items_YouStartCigarets" call A3PL_Localize),Color_Green] call A3PL_Notification;
        [player] call cigs_core_fnc_useLighter;
        [player] call cigs_core_fnc_start_smoking; 

        _hungerModifier = 0.5;
        Player_Hunger = Player_Hunger * _hungerModifier;
        player setVariable ["player_hunger", Player_Hunger,false];
        call A3PL_Lib_VerifyHunger;

        return;
    };

    if (!([_classname, 1] call A3PL_Inventory_Has)) exitWith {
        [("STR_A3PL_Items_DontHaveCigs" call A3PL_Localize), Color_Red] call A3PL_Notification;
    };

    Player_isUsingItem = true;

    [_classname, -1] call A3PL_Inventory_Add;
    player unassignItem "NVGoggles";        
    player addItem _nvItem;              
    player assignItem _nvItem;              

    [("STR_A3PL_Items_CigsEquiped" call A3PL_Localize),Color_Green] call A3PL_Notification;
    [player] call cigs_core_fnc_start_smoking;
	[player] call cigs_core_fnc_useLighter; 

    [] spawn {
        while {true} do {
            sleep 10; 
			private _nvItem = "cigs_morley_cig0_nv";
            if (_nvItem in assignedItems player) then {
                _hungerModifier = 0.5; 
                Player_Hunger = Player_Hunger * _hungerModifier;
                player setVariable ["player_hunger", Player_Hunger,false];
                call A3PL_Lib_VerifyHunger;
            } else {
                break; 
            };
        };
    };

    [] spawn {
        sleep 3;
        [false] call A3PL_Inventory_PutBack; 
        Player_isUsingItem = nil;        
    };
}] call compile_Global;