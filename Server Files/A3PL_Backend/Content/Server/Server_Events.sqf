/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["Server_Events_Random", {
	private _allEvents = [
		//[Server_Events_ShipWreck,{true}],
		[Server_Events_PlaneCrash,{true}]
	];
	if(!isNil "Server_Events_Current") exitWith {};

	_selected = selectRandom _allEvents;
	while {!(call (_selected select 1))} do {
		_selected = selectRandom _allEvents;
	};
	[] spawn (_selected select 0);
}] call compile_Server;

["Server_Events_Start", {
	params [["_eventName","",[""]]];

	Server_Events_Current = _eventName;
}] call compile_Server;

["Server_Events_End", {
	Server_Events_Current = nil;
}] call compile_Server;

["Server_Events_ShipWreck", {
	["Ship Wreck"] call Server_Events_Start;
	private _eventDuration = 15*60;
	private _wreckArray = ["Land_Boat_06_wreck_F","Land_Wreck_Traw2_F","Land_Wreck_Traw_F","Land_UWreck_FishingBoat_F"];
	private _propsArray = ["Land_Sack_F","Land_BarrelTrash_F","Land_Sacks_goods_F","Land_CratesWooden_F","Land_Cages_F","Land_GarbagePallet_F","Land_GarbageBarrel_01_F","Land_Pallets_F","Land_Garbage_square5_F","Land_CratesShabby_F","Land_CanisterPlastic_F","Land_Garbage_line_F","Land_WoodenBox_F","Land_Sacks_heap_F","Land_PaperBox_closed_F","Land_GarbageBags_F","Land_Pallets_F","Land_GarbageBags_F"];
	private _lootArray = ["diamond"];
	private _posArray = selectRandom [[11641.9,11825.5,0],[7551.55,10823.9,0],[506.756,9011.15,0],[1277.59,3179.49,0],[6526.55,4337.69,0],[9980.81,7063.11,0],[10721.6,3939.42,0],[6533.32,7144.09,0],[2688.38,11471.8,0],[3224.43,12612.7,0],[1677.94,11835.3,0]];
	private _eventObjects = [];

	private _marker = createMarker ["Server_Events_ShipWreck", _posArray];
	_marker setMarkerShape "ICON";
	_marker setMarkerType "A3FL_Markers_ShipwreckLegal";
	_marker setMarkerSize [0.7, 0.7];
	_marker setMarkerColor "Default";

	private _wreck = (selectRandom _wreckArray) createVehicle _posArray;
	_wreck allowDamage false;
	_wreck setDir (random 359);
	_eventObjects pushBack _wreck;

	private _boxPos = [(_posArray select 0) - random 15,(_posArray select 1) + random 10,_posArray select 2];
	private _itemBox = "B_supplyCrate_F" createVehicle _boxPos;
	_itemBox setVariable["locked",false,true];
	_itemBox setVariable["capacity",100000,true];
	_itemBox allowDamage false;
    _itemBox setDir (90);
    _eventObjects pushBack _itemBox;

	private _object1 = (selectRandom _propsArray) createVehicle ([getPosATL _wreck, 5, 20, 2, 0, 100, 0] call BIS_fnc_findSafePos);
	_object1 setDir (random 359);
	_eventObjects pushBack _object1;

	private _object2 = (selectRandom _propsArray) createVehicle ([getPosATL _wreck, 5, 20, 2, 0, 100, 0] call BIS_fnc_findSafePos);
	_object2 setDir (random 359);
	_eventObjects pushBack _object2;

	private _object3 = (selectRandom _propsArray) createVehicle ([getPosATL _wreck, 5, 20, 2, 0, 100, 0] call BIS_fnc_findSafePos);
	_object3 setDir (random 359);
	_eventObjects pushBack _object3;

	private _object4 = (selectRandom _propsArray) createVehicle ([getPosATL _wreck, 5, 20, 2, 0, 100, 0] call BIS_fnc_findSafePos);
	_object4 setDir (random 359);
	_eventObjects pushBack _object4;

	private _object5 = (selectRandom _propsArray) createVehicle ([getPosATL _wreck, 5, 20, 2, 0, 100, 0] call BIS_fnc_findSafePos);
	_object5 setDir (random 359);
	_eventObjects pushBack _object5;

	clearItemCargoGlobal _itemBox;
	clearMagazineCargoGlobal _itemBox;
	clearWeaponCargoGlobal _itemBox;
	clearBackpackCargoGlobal _itemBox;

	private _commonItems = [];
	private _rareItems = [];
	private _virtualItems = [];
	private _fisdCount = 1 + count([("STR_Common_FISD" call A3PL_Localize)] call A3PL_Lib_FactionPlayers);
	private _commonCount = 4 + round(_fisdCount / 2);
	private _rareCount = 2 + round(_fisdCount / 2);
	private _wreckMessage = "Fuckin moron";
	private _wreckType = floor(random 4);
	switch(_wreckType) do {
		case(0): {
			_wreckMessage = ("STR_Server_Events_ShipWreck_SOSDrug" call A3PL_Localize);
			_marker setMarkerText ("STR_Server_Events_ShipWreck_BoatWreck" call A3PL_Localize);
			_commonItems = [["seed_marijuana",10],["seed_coca",10],["coca",10],["jug",3],["sulphuric_acid",10],["calcium_carbonate",10],["potassium_permangate",10],["ammonium_hydroxide",10],["acetone",10],["hydrocloric_acid",10],["kerosene_jerrycan",3]];
			_rareItems = [["coca_paste",10],["cocaine_base",10],["cocaine_hydrochloride",10],["jug_moonshine",5],["weed_bag_100g",3],["weed_bag_50g",4],["weed_bag_25g",6]];
			_marker setMarkerType "A3FL_Markers_ShipwreckIllegal";
		};
		case(1): {
			_wreckMessage = ("STR_Server_Events_ShipWreck_SOSTreasure" call A3PL_Localize);
			_marker setMarkerText ("STR_Server_Events_ShipWreck_BoatWreck" call A3PL_Localize);
			_commonItems = [["crown",1],["ring",2],["ringset",2],["bracelet",2],["necklace",1],["golden_dildo",1]];
			_rareItems = [["diamond_ill",1],["diamond_emerald_ill",1],["diamond_ruby_ill",1],["diamond_sapphire_ill",1],["diamond_alex_ill",1],["diamond_aqua_ill",1],["diamond_tourmaline_ill",1]];
			_commonCount = 3 + round(_fisdCount / 2);
			_rareCount = 1 + round(_fisdCount / 2);
			_marker setMarkerType "A3FL_Markers_ShipwreckIllegal";
		};
		case(2): {
			_wreckMessage = ("STR_Server_Events_ShipWreck_SOSFurniture" call A3PL_Localize);
			_marker setMarkerText ("STR_Server_Events_ShipWreck_BoatWreck" call A3PL_Localize);
			_commonItems = [["jerrycan_empty",2],["jerrycan",1],["repairwrench",1],["coffee_cup_small",4],["coffee_cup_medium",3],["coffee_cup_large",2],["taco_cooked",3],["burger_full_cooked",3]];
			_rareItems = [["jerrycan",3],["repairwrench",10],["popcornbucket",1],["pizzabites",10],["soupcup",10],["cookies",10],["cereal",10],["meatpie",4],["coke",5]];
			_commonCount = 8 + round(_fisdCount / 2);
			_rareCount = 3 + round(_fisdCount / 2);
			_marker setMarkerType "A3FL_Markers_ShipwreckLegal";
		};
		case(3): {
			_wreckMessage = ("STR_Server_Events_ShipWreck_SOSResources" call A3PL_Localize);
			_marker setMarkerText ("STR_Server_Events_ShipWreck_BoatWreck" call A3PL_Localize);
			_commonItems = [["Aluminium_Ore",20],["Iron_Ore",20],["Coal_Ore",20],["Titanium_Ingot",1],["Aluminium_Ingot",5],["Iron_Ingot",5],["Coal_Ingot",5]];
			_rareItems = [["Aluminium_Ingot",10],["Iron_Ingot",10],["Coal_Ingot",10],["Titanium_Ingot",5],["Steel",15],["Aluminium",15],["Titanium",5]];
			_commonCount = 6 + round(_fisdCount / 2);
			_rareCount = 3 + round(_fisdCount / 2);
			_marker setMarkerType "A3FL_Markers_ShipwreckLegal";
		};
	};

	for "_i" from 0 to _commonCount do {
		_item = selectRandom _commonItems;
		_virtualItems = [_virtualItems, _item select 0, _item select 1, true] call BIS_fnc_addToPairs;
	};

	for "_i" from 0 to _rareCount do {
		_item = selectRandom _rareItems;
		_virtualItems = [_virtualItems, _item select 0, _item select 1, true] call BIS_fnc_addToPairs;
	};

	_itemBox setVariable["storage",_virtualItems,true];

	[_wreckMessage,Color_Yellow] remoteExec ["A3PL_Notification", -2];

    sleep _eventDuration;

	{deleteVehicle _x;} forEach _eventObjects;
	deleteMarker _marker;
	call Server_Events_End;
	[("STR_Server_Events_ShipWreck_BoatFound" call A3PL_Localize),Color_Yellow] remoteExec ["A3PL_Notification", -2];
}] call compile_Server;

["Server_Events_PlaneCrash", {
	["Plane Crash"] call Server_Events_Start;
	[("STR_Server_Events_PlaneCrash_EngineIssue" call A3PL_Localize),Color_Yellow] remoteExec ["A3PL_Notification", -2];
	private _eventDuration = 15*60; 
	private _posArray = [[7431.11,8293.28,70],[4108.52,5361.53,70],[7678.41,7939.51,70]];
	private _plane = createVehicle ["C_Plane_Civil_01_F", (selectRandom _posArray), [], 0, "CAN_COLLIDE"];
	private _randir = floor random [1, 100, 260];
	_plane setDir (_randir);
	private _vel = velocity _plane;
	private _dir = direction _plane;
	private _speed = 100;
	_plane setVelocity [(_vel select 0) + (sin _dir * _speed),(_vel select 1) + (cos _dir * _speed),(_vel select 2)];

	private _group = createGroup [civilian, true];
	private _pilot = _group createUnit ["C_Nikos_aged", [0,0,0], [], 0, "CAN_COLLIDE"];
	_pilot setskill 1;
	_pilot moveInDriver _plane;

	sleep 5;
	_plane setDamage 0.85;
	_plane setHitPointDamage["hitEngine", 1];

	private _marker = createMarker ["planecrash", position (_plane)];
	_marker setMarkerShape "ICON";
	_marker setMarkerSize [0.7, 0.7];
	_marker setMarkerType "A3FL_Markers_PlaneDistress";
	_marker setMarkerText ("STR_Server_Events_PlaneCrash_Distress" call A3PL_Localize);
	_marker setMarkerColor "Default";

	while{alive _pilot} do {
		_marker setMarkerPos (position _plane);
		sleep 2;
	};

	deleteVehicle _pilot;
	_crashPos = getPos _plane;
	private _planeWreck = createVehicle ["Land_HistoricalPlaneWreck_01_F", _plane, [], 0, "CAN_COLLIDE"];
	private _onWater = !(_crashPos isFlatEmpty [-1, -1, -1, -1, 2, false] isEqualTo []);
	private _boxPos = [(_crashPos select 0) - random 15,(_crashPos select 1) + random 10,_crashPos select 2];
	private _itemBox = "B_supplyCrate_F" createVehicle _boxPos;
	_itemBox setVariable["locked",false,true];
	_itemBox setVariable["capacity",100000,true];
	_itemBox allowDamage false;
    _itemBox setDir (90);
	deleteVehicle _plane;

	private _fifr = [("STR_Common_FIFR" call A3PL_Localize)] call A3PL_Lib_FactionPlayers;
	if((count _fifr) >= 3 && !_onWater) then {
		_marker setMarkerType "A3FL_Markers_Fire";
		[("STR_Server_Events_PlaneCrash_Fire" call A3PL_Localize),Color_Red,("STR_Common_FIFR" call A3PL_Localize),3] spawn A3PL_Lib_JobMessage;
		["A3PL_Common\effects\firecall.ogg",150,2,10] spawn A3PL_FD_FireStationAlarm;
		[getposATL (_planeWreck)] spawn Server_Fire_StartFire;
    };

	private _fisdCount = count([("STR_Common_FISD" call A3PL_Localize)] call A3PL_Lib_FactionPlayers);
	private _commonCount = 4 + (floor(_fisdCount / 2));
	private _rareCount = 2 + (floor(_fisdCount / 2));
	private _weaponCount = 1 + (floor(_fisdCount / 3));
	private _rareWeaponCount = 0 + (floor(_fisdCount / 3));
	private _wreckMessage = "Fuckin moron";
	private _alertMessage = "";
	private _virtualItems = [];
	private _physicalItems = [];
	private _weapons = [];
	private _mags = [];
	private _rareWeapons = [];
	private _rareMags = [];
	private _commonItems = [];
	private _rareItems = [];

	if (_onWater) then {
		private _wreckType = floor (random 3);
		switch(_wreckType) do {
			case(0): {
				_alertMessage = ("STR_Server_Events_PlaneCrash_SOSDrug" call A3PL_Localize);
				_wreckMessage = ("STR_Server_Events_PlaneCrash_Crash" call A3PL_Localize);
				_commonItems = [["seed_marijuana",10],["seed_coca",10],["coca",10],["jug",3],["sulphuric_acid",10],["calcium_carbonate",10],["potassium_permangate",10],["ammonium_hydroxide",10],["acetone",10],["hydrocloric_acid",10],["kerosene_jerrycan",3]];
				_rareItems = [["coca_paste",10],["cocaine_base",10],["cocaine_hydrochloride",10],["jug_moonshine",5],["weed_bag_100g",3],["weed_bag_50g",4],["weed_bag_25g",6]];
				_commonCount = 4 + round(_fisdCount / 2);
				_rareCount = 2 + round(_fisdCount / 2);
				_marker setMarkerType "A3FL_Markers_PlanewreckLegal";

				for "_i" from 0 to _commonCount do {
					_item = selectRandom _commonItems;
					_virtualItems = [_virtualItems, _item select 0, _item select 1, true] call BIS_fnc_addToPairs;
				};

				for "_i" from 0 to _rareCount do {
					_item = selectRandom _rareItems;
					_virtualItems = [_virtualItems, _item select 0, _item select 1, true] call BIS_fnc_addToPairs;
				};
			};
			case(1): {
				_alertMessage = ("STR_Server_Events_PlaneCrash_SOSResources" call A3PL_Localize);
				_wreckMessage = ("STR_Server_Events_PlaneCrash_Crash" call A3PL_Localize);
				_commonItems = [["Aluminium_Ore",20],["Iron_Ore",20],["Coal_Ore",20],["Titanium_Ingot",1],["Aluminium_Ingot",5],["Iron_Ingot",5],["Coal_Ingot",5]];
				_rareItems = [["Aluminium_Ingot",10],["Iron_Ingot",10],["Coal_Ingot",10],["Titanium_Ingot",5],["Steel",15],["Aluminium",15],["Titanium",5]];
				_commonCount = 6 + round(_fisdCount / 2);
				_rareCount = 3 + round(_fisdCount / 2);
				_marker setMarkerType "A3FL_Markers_PlanewreckLegal";

				for "_i" from 0 to _commonCount do {
					_item = selectRandom _commonItems;
					_virtualItems = [_virtualItems, _item select 0, _item select 1, true] call BIS_fnc_addToPairs;
				};

				for "_i" from 0 to _rareCount do {
					_item = selectRandom _rareItems;
					_virtualItems = [_virtualItems, _item select 0, _item select 1, true] call BIS_fnc_addToPairs;
				};
			};
			case(2): {
				_alertMessage = ("STR_Server_Events_PlaneCrash_SOSTreasure" call A3PL_Localize);
				_wreckMessage = ("STR_Server_Events_PlaneCrash_Crash" call A3PL_Localize);
				_commonItems = [["diamond_tourmaline",1],["diamond_aqua",1],["diamond_alex",1],["diamond_sapphire",1],["diamond_ruby",1],["diamond_emerald",1],["diamond",1]];
				_rareItems = [["diamond_tourmaline",4],["diamond_aqua",4],["diamond_alex",4],["diamond_sapphire",4],["diamond_ruby",4],["diamond_emerald",4],["diamond",4],["dildo",1]];
				_commonCount = 6 + round(_fisdCount / 2);
				_rareCount = 3 + round(_fisdCount / 2);
				_marker setMarkerType "A3FL_Markers_PlanewreckLegal";

				for "_i" from 0 to _commonCount do {
					_item = selectRandom _commonItems;
					_virtualItems = [_virtualItems, _item select 0, _item select 1, true] call BIS_fnc_addToPairs;
				};

				for "_i" from 0 to _rareCount do {
					_item = selectRandom _rareItems;
					_virtualItems = [_virtualItems, _item select 0, _item select 1, true] call BIS_fnc_addToPairs;
				};
			};
		};
	} else {
		private _wreckType = floor (random 3);
		switch(_wreckType) do {
			case(0): {
				_alertMessage = ("STR_Server_Events_PlaneCrash_SOSWeapons" call A3PL_Localize);
				_wreckMessage = ("STR_Server_Events_PlaneCrash_Crash" call A3PL_Localize);
				_weapons = [["hgun_P07_blk_F",1],["hgun_Pistol_heavy_01_F",1],["hgun_Pistol_01_F",1],["hgun_Rook40_F",1],["hgun_Pistol_heavy_02_F",1],["A3PL_P226",1],["A3FL_P227",1],["A3FL_Beretta92",1],["A3FL_DesertEagle",1],["A3FL_Glock17_Tan",1],["A3FL_Glock17S",1]];
				_mags = [["16Rnd_9x21_Mag",4],["11Rnd_45ACP_Mag",4],["10Rnd_9x21_Mag",4],["16Rnd_9x21_Mag",4],["6Rnd_45ACP_Cylinder",4],["A3PL_P226_Mag",4],["A3FL_P227_Mag",4],["A3FL_Beretta92_Mag",4],["A3FL_DesertEagle_Mag",4],["A3FL_Glock17_Mag",4]];
				_rareWeapons = [["A3FL_UMP",1],["A3FL_Vector",1],["A3FL_M4",1],["A3FL_AK110",1],["A3FL_Uzi",1],["A3FL_MP5K",1],["A3FL_Benelli",1],["A3FL_M870",1],["A3FL_MP7",1],["A3FL_MK18",1]];
				_rareMags = [["A3FL_UMP_Mag",2],["A3FL_Vector_Mag",2],["A3PL_M16_Mag",2],["30Rnd_762x39_Mag_F",2],["A3FL_Uzi_Mag",2],["A3FL_MP5K_Mag",2],["A3FL_Benelli_Buck",2],["A3FL_Benelli_Slug",2],["A3FL_M870_Buck",2],["A3FL_MP7_Mag",2]];
				_physicalItems = [["optic_Arco_blk_F","optic_ERCO_blk_F"]];
				_marker setMarkerType "A3FL_Markers_PlanewreckLegal";

				for "_i" from 0 to _weaponCount do {
					_weaponChance = floor (random 9);
					_gun = _weapons select _weaponChance;
					_physicalItems pushBack _gun;
					_mag = _mags select _weaponChance;
					_physicalItems pushBack _mag;
				};
				for "_i" from 0 to _rareWeaponCount do {
					_rareWeaponChance = floor (random 6);
					_gun = _rareWeapons select _rareWeaponChance;
					_physicalItems pushBack _gun;
					_mag = _rareMags select _rareWeaponChance;
					_physicalItems pushBack _mag;
				};
			};
			case(1): {
				_alertMessage = ("STR_Server_Events_PlaneCrash_SOSContreband" call A3PL_Localize);
				_wreckMessage = ("STR_Server_Events_PlaneCrash_Crash" call A3PL_Localize);
				_physicalItems = [["A3FL_Backpack_Money",2],["A3FL_Backpack_Drill",1]];
				_commonItems = [["zipties",1],["keycard",1],["v_lockpick",1]];
				_rareItems = [["drill_bit",1],["dildo",1],["golden_dildo",1],["usb_stick",1],["blueprint_fifr",1],["blueprint_fisd",1],["blueprinteq_fisd",1]];
				_commonCount = 3 + round(_fisdCount / 3);
				_rareCount = 1 + round(_fisdCount / 3);
				_marker setMarkerType "A3FL_Markers_PlanewreckLegal";

				for "_i" from 0 to _commonCount do {
					_item = selectRandom _commonItems;
					_virtualItems = [_virtualItems, _item select 0, _item select 1, true] call BIS_fnc_addToPairs;
				};

				for "_i" from 0 to _rareCount do {
					_item = selectRandom _rareItems;
					_virtualItems = [_virtualItems, _item select 0, _item select 1, true] call BIS_fnc_addToPairs;
				};

			};
			case(2): {
				_alertMessage = ("STR_Server_Events_PlaneCrash_SOSResources2" call A3PL_Localize);
				_wreckMessage = ("STR_Server_Events_PlaneCrash_Crash" call A3PL_Localize);
				_commonItems = [["Aluminium_Ore",20],["Iron_Ore",20],["Coal_Ore",20],["Titanium_Ingot",1],["Aluminium_Ingot",5],["Iron_Ingot",5],["Coal_Ingot",5]];
				_rareItems = [["Aluminium_Ingot",10],["Iron_Ingot",10],["Coal_Ingot",10],["Titanium_Ingot",5],["Steel",15],["Aluminium",15],["Titanium",5]];
				_commonCount = 6 + round(_fisdCount / 3);
				_rareCount = 3 + round(_fisdCount / 3);
				_marker setMarkerType "A3FL_Markers_PlanewreckLegal";

				for "_i" from 0 to _commonCount do {
					_item = selectRandom _commonItems;
					_virtualItems = [_virtualItems, _item select 0, _item select 1, true] call BIS_fnc_addToPairs;
				};

				for "_i" from 0 to _rareCount do {
					_item = selectRandom _rareItems;
					_virtualItems = [_virtualItems, _item select 0, _item select 1, true] call BIS_fnc_addToPairs;
				};
			};
		};
	};

	_marker setMarkerText _wreckMessage;
	_marker setMarkerPos _crashPos;
	_marker setMarkerColor "Default";
	[_alertMessage,Color_Yellow] remoteExec ["A3PL_Notification", -2];

    clearItemCargoGlobal _itemBox;
	clearMagazineCargoGlobal _itemBox;
	clearWeaponCargoGlobal _itemBox;
	clearBackpackCargoGlobal _itemBox;

	_itemBox setVariable["storage",_virtualItems,true];
	{_itemBox addItemCargoGlobal _x} foreach _physicalItems;

    sleep _eventDuration;
    deleteVehicle _planeWreck;
    deleteVehicle _itemBox;
	deleteMarker _marker;
	call Server_Events_End;
	[("STR_Server_Events_PlaneCrash_Found" call A3PL_Localize),Color_Yellow] remoteExec ["A3PL_Notification", -2];
}] call compile_Server;

["Server_Events_FireEvents", {
	params [["_forceEvent","",[""]]];

	private _FIFR = [("STR_Common_FIFR" call A3PL_Localize)] call A3PL_Lib_FactionPlayers;
	private _FISD = [("STR_Common_FISD" call A3PL_Localize)] call A3PL_Lib_FactionPlayers;
	private _FRCount = count(_FIFR);
	private _SDCount = count (_FISD);
	private _eventTypes = ["TrashCanFire"];
	if(_FRCount < 1) exitWith {};
	if(_FRCount >= 2) then {_eventTypes append ["JewelryFake","BetterBuyFake","McFishersFire","HydrantInspection","CommercialFakeAlarm"]};
	if(_FRCount >= 3) then {_eventTypes append ["JewelryReal","BetterBuyReal","AirCrashFire","BankFireReal","TownHallFireReal","ForestFireReal"]};
	if(_FRCount >= 4) then {_eventTypes append ["CourthouseFireFake","CourthouseFireReal"]};
	if((_FRCount >= 5) && (_SDCount > 0)) then {_eventTypes append ["PrisonFireFake","PrisonFireReal"]};
	private _selectedType = if(_forceEvent isEqualTo "") then {selectRandom _eventTypes} else {_forceEvent};
	switch(_selectedType) do {
		case 'JewelryFake': {
			private _jewelryStore = nearestObject [[8769.08,6412.3,0.000155449], "Land_A3FL_Fishers_Jewelry"];
			[_jewelryStore] call A3PL_FD_FireAlarm;
			_jewelryStore setVariable["FireAlarmBroke",true,true];
		};
		case 'JewelryReal': {
			private _jewelryStore = nearestObject [[8769.08,6412.3,0.000155449], "Land_A3FL_Fishers_Jewelry"];
			private _fireOffsets = [
				[3,-2,1.1], [3,5,1.1], [2,9,1.1], [-4,10,1.1], [-2.5,11.5,1.1], [-9,5.5,1.1], [-9,-2,1.1], [-7,1,1.1], [-6,5,1.1], [-1,6,1.1], [2,1,1.1],
				[2,1,-2.6], [3,2.5,-2.6], [2,5,-2.6], [2,5,-2.6], [-5,-2.2,-2.6], [-3.5,-2.2,-2.6], [-3.8,-5,-2.6], [-1.5,-5.8,-2.6], [-9,-2,-2.6], [-8,0,-2.6], [-7,1,-2.6], [-9,2,-2.6], [-7,3,-2.6], [-7,5,-2.6], [-9.5,6.2,-2.6], [-5,6.2,-2.6], [-1,6.8,-2.6], [0,6,-2.6], [-2.2,4,-2.6], [-3.33,2,-2.6], [0,-3,-2.6],
				[-2,10,-2.6], [-4,9,-2.6], [-4,11,-2.6], [0.5,11,-2.6], [0.5,9.5,-2.6], [2,8.8,-2.6], [3.9,10,-2.6]
			];
			{
				[(_jewelryStore modelToWorld _x), 0, true, true] spawn Server_Fire_StartFire;
				sleep 0.05;
			} foreach _fireOffsets;
			[_jewelryStore] call A3PL_FD_FireAlarm;
		};
		case 'BetterBuyFake': {
			private _betterBuy = nearestObject [[6987.72,6334.42,-0.000424385], "Land_A3FL_Better_Buy"];
			[_betterBuy] call A3PL_FD_FireAlarm;
			_betterBuy setVariable["FireAlarmBroke",true,true];
		};
		case 'BetterBuyReal': {
			private _betterBuy = nearestObject [[6987.72,6334.42,-0.000424385], "Land_A3FL_Better_Buy"];
			private _fireOffsets = [
				[0,3,0], [5,1.8,0], [10,1,0], [11,-3,0], [13,-8,0], [15,-9.5,0], [17,-8,0], [16.2,-6,0], [17.4,-2,0], [17.8,2,0], [14,2.3,0], [9,-9,0], [4,-9,0], [2,-3,0], [-4,-4,0], [-1,-8,0], [-10,-6,0], [-12,-5,0], [-11,-2,0], [-9,2,0], [-4,3,0], [-15,3,0], [-13,-10,0], [-18,-3.5,0], [-18,-8,0],
				[-18,-10,6.3], [-16,-8,6.3], [-10,-5,6.3], [-17,4,6.3], [-15,1,6.3], [-11,0,6.3], [-8,2,6.3], [-6,5,6.3], [-2,14,6.3], [-3,9,6.3], [4,12,6.3], [8,14,6.3], [11,12,6.3], [14.5,11,6.3], [17.8,12,6.3], [14,15,6.3], [7,10,6.3], [1,10,6.3], [-1,7,6.3], [10,7,6.3], [15,6,6.3], [18,3,6.3], [16,-2,6.3], [14,-6,6.3], [10,-4,6.3], [9,1,6.3], [7,3,6.3], [12,3,6.3],
				[4,6.5,6.3], [4,-1,6.3], [5,-7,6.3], [0,-8,6.3], [-4,-10,6.3], [-7.5,-9,6.3], [-5,-4,6.3], [-3,-2,6.3], [-1,0,6.3], [1,-4,6.3]
			];
			{
				[(_betterBuy modelToWorld _x), 0, true] spawn Server_Fire_StartFire;
				sleep 0.05;
			} foreach _fireOffsets;
			[_betterBuy] call A3PL_FD_FireAlarm;
		};
		case 'CommercialFakeAlarm': {
			private _buildings = nearestObjects [[worldSize/2,worldSize/2,0],["Land_A3FL_Fishers_Barbershop","land_market_ded_market_05_f","Land_A3PL_Garage","Land_A3PL_PostOffice","Land_A3PL_Gas_Station","Land_Coffee_DED_Coffee_01_F","Land_Coffee_DED_Coffee_02_F","Land_A3PL_Bank","Land_A3PL_CH"], 50000];
			private _building = selectRandom _buildings;
			[_building] call A3PL_FD_FireAlarm;
			_building setVariable["FireAlarmBroke",true,true];
		};
		case 'McFishersFire': {
			private _mcArray = nearestObjects [[worldSize/2,worldSize/2,0],["land_market_ded_market_01_SEP"], 50000];
			private _mcFishers = selectRandom _mcArray;
			private _fireOffsets = [
				[0,-3,-2.85], [0,-2.4,-2.85], [-1.3,-7.3,-2.85], [-0.85,-7.3,-2.85], [-4.75,-2,-2.85], [-4.75,-2.6,-2.85], [-2,2.2,-2.85], [-2,1.6,-2.85]
			];
			{
				[(_mcFishers modelToWorld _x), 0, true] spawn Server_Fire_StartFire;
				sleep 0.05;
			} foreach _fireOffsets;
			private _address = [getPos _mcFishers] call A3PL_Housing_PosAddress;
			[_mcFishers] call A3PL_FD_FireAlarm;
		};
		case 'HydrantInspection': {
			private _inspectAreas = [[8840.74,6431.02,0],[6135.41,7365.35,0],[4758.95,6107.65,0],[2578.53,5519.15,0],[3475.63,7532.62,0]];
			private _selectedArea = selectRandom _inspectAreas;
			private _hydrants = nearestObjects [_selectedArea, ["Land_A3PL_FireHydrant"], 800];
			private _inspectAmount = 2 + round(random 8);
			private _city = text ((nearestLocations [_selectedArea, ["NameCityCapital","NameCity","NameVillage"], 5000])#0);
			{
				if(_forEachIndex >= _inspectAmount) exitWith {};
				[position _x, "Inspection bouche d'incendie","ColorWhite","A3FL_Markers_Hydrant",1200] remoteExec ["A3PL_Lib_CreateMarker",_FIFR];
				_x setVariable["needInspection",true,true];
			} forEach _hydrants;
			[format[("STR_Server_Events_Fire_InspectionRequested" call A3PL_Localize),_city],Color_Red,("STR_Common_FIFR" call A3PL_Localize),3] spawn A3PL_Lib_JobMessage;
		};
		case 'AirCrashFire': {
			private _posArray = [
				["Silverton Airport", [2556.23,5187.06,0.00143862], [[2200.98,5306.86,0.00143909],[2190.55,5228.87,0.00143909],[2281.99,5171.25,0.00143909],[2280.16,5089.71,0.00145483],[2370.66,5044.84,0.00143909],[3039.03,5057.85,0.00155973],[2661.44,5195.69,0.00143909]]],
				["Northdale Airfield", [10714.1,8910.54,0.110755], [[10904,8827.93,0.00143909],[10935.9,8785.87,0.00143862],[10976.5,8809.47,0.00143909],[10591.4,9148.75,0.00143909],[10533.6,9078.73,0.00141239]]]
			];
			private _selectedField = selectRandom _posArray;
			private _location = selectRandom (_selectedField#2);
			private _classnames = ["Land_Wreck_Plane_Transport_01_F","Land_HistoricalPlaneWreck_03_F"];
			private _random = 4 + round(random 4);
			private _wreck = (selectRandom _classnames) createVehicle _location;
			_wreck setDir (random 359);
			_wreck setVariable["TimeCreated",serverTime];
			A3FL_FireEvent_Wreck = _wreck;
			for "_i" from 0 to _random do {
				_pos = [(_location#0) + (-5 + (random 10)),(_location#1) + (-5 + (random 10)), 0];
				[_pos, windDir, true] spawn Server_Fire_StartFire;
			};
			[("STR_Common_FIFR" call A3PL_Localize),("STR_Server_Events_PlaneCrash_Crash" call A3PL_Localize),_selectedField#1,format[("STR_Server_Events_Fire_CrashReported" call A3PL_Localize),_selectedField#0],("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
		};
		case 'VehicleFire': {};		
		case 'GasLeak': {
			private _gasStation = selectRandom FuelStations;
		};
		case 'BankFireReal': {
			private _bankArray = nearestObjects [[worldSize/2,worldSize/2,0],["Land_A3PL_Bank"], 50000];
			private _bank = selectRandom _bankArray;
			private _fireOffsets = [
				[6.8,5.8,-2.9], [4.5,-6.3,-2.9], [4.1,3.3,-2.9], [3.1,-0.6,-2.9], [5.7,-3.3,-2.9], [1.1,-3.2,-2.9], [-2.4,-4.7,-2.9], [-6.8,-2.8,-2.9], [-6.1,0.3,-2.9], [-6.1,4.7,-2.9], [-2.0,7.5,-2.9],
				[2.9,-1.7,0.5], [-4.5,-0.7,0.5], [-4.8,5.8,0.5], [2.2,6.6,0.5],
				[4.5,-6.7,1.9]
			];
			{
				[(_bank modelToWorld _x), 0, true] spawn Server_Fire_StartFire;
				sleep 0.05;
			} foreach _fireOffsets;
			private _address = [getPos _bank] call A3PL_Housing_PosAddress;
			[_bank] call A3PL_FD_FireAlarm;
		};
		case 'TownHallFireReal': {
			private _thArray = nearestObjects [[worldSize/2,worldSize/2,0],["Land_A3PL_CH"], 50000];
			private _townhall = selectRandom _thArray;
			private _fireOffsets = [
				[3.7,-3.4,-3.8], [0.3,-1.0,-3.8], [1.0,4.0,-3.8], [-4.9,5.9,-3.8], [-4.5,0.8,-3.8], [-6.0,2.0,-3.8], [4.4,6.4,-3.8], [6.5,6.7,-2.3],
				[1.4,6.5,-0.35], [4.1,1.5,-0.35], [5.3,-5.4,-0.35], [9.2,-4.5,-0.35], [9.35,-7.2,-0.35], [5.35,-7.55,-0.35], [-3.1,6.1,-0.35], [-6.3,3.6,-0.35], [-2.7,1.6,-0.35], [-7.45,-0.32,-0.35], [-5.5,-5.1,-0.35],
				[-7.8,-4.9,2.9], [-2.3,0.7,2.9], [3.9,-2.4,2.9], [10.2,-6.71,2.9], [9.6,4.3,2.9], [-2.3,5.7,2.9], [3.9,0.8,2.9]
			];
			{
				[(_townhall modelToWorld _x), 0, true] spawn Server_Fire_StartFire;
				sleep 0.05;
			} foreach _fireOffsets;
			private _address = [getPos _townhall] call A3PL_Housing_PosAddress;
			[_townhall] call A3PL_FD_FireAlarm;
		};
		case 'CourthouseFireFake': {
			private _chArray = nearestObjects [[worldSize/2,worldSize/2,0],["Land_FYD_Courthouse"], 50000];
			private _courthouse = selectRandom _chArray;
			[_courthouse] call A3PL_FD_FireAlarm;
			_courthouse setVariable["FireAlarmBroke",true,true];
		};
		case 'CourthouseFireReal': {
			private _chArray = nearestObjects [[worldSize/2,worldSize/2,0],["Land_FYD_Courthouse"], 50000];
			private _courthouse = selectRandom _chArray;
			private _fireOffsets = [
				[0.1,-17.1,0.7], [-3.3,-11.1,0.7], [1.1,-6.3,0.7], [4.2,0.0,0.7], [-0.1,0.1,0.7], [-5.2,3.0,0.7], [-1.3,8.6,0.7], [4.6,8.6,0.7], [6.3,2.6,0.7], [10.6,0.2,0.7], [12.2,-4.9,0.7], [17.3,-4.0,0.7], [20.2,-1.9,0.7], [11.9,1.5,0.7], [15.7,2.0,0.7], [18.7,3.5,0.7], [11.3,6.4,0.7], [15.6,7.7,0.7], [19.5,11.9,0.7], [15.0,13.5,0.7], [10.7,14.2,0.7], [5.5,13.6,0.7], [-0.5,18.0,0.5], [-5.9,20.7,0.5], [-10.8,16.2,0.5], [-11.5,21.3,0.5], [-16.4,21.5,0.5], [-19.6,15.8,0.5], [3.9,18.3,0.7], [-1.3,3.6,2.2],
				[5.6,23.2,3.1], [5.1,16.7,5.4], [3.0,13.8,5.4], [-0.1,18.5,5.4], [-3.0,20.3,5.4], [-4.0,13.7,5.4], [-9.3,14.5,5.4], [-16.1,13.3,5.4], [-18.8,17.1,5.4], [-16.1,21.6,5.4], [-20.6,22.0,5.4], [-22.5,11.0,5.4], [-17.0,9.1,5.4], [-18.5,4.6,5.4], [-20.3,-2.0,5.4], [-16.3,-5.1,5.4], [-13.6,1.4,5.4], [-8.7,6.7,5.4], [-8.8,-0.1,5.4], [-9.2,-7.0,7.6], [-9.3,-1.5,9.7], [-11.9,6.2,9.7], [-12.3,-2.4,9.7], [-4.3,4.4,5.4], [-0.5,8.7,5.4], [4.9,5.1,5.4], [3.9,-3.0,5.4], [2.0,1.6,4.4], [9.6,2.4,5.4], [14.7,-0.6,5.4], [19.7,-3.1,5.4], [20.2,3.8,5.4], [23.5,2.6,5.9], [13.2,6.9,5.4], [9.5,-5.7,5.4], [9.0,7.7,5.4], [8.1,-4.7,7.0], [9.1,-1.0,9.7], [8.2,5.3,9.7], [12.5,8.7,9.7], [8.5,13.8,5.4], [15.7,14.4,5.4], [22.4,13.7,5.4], [20.1,17.6,5.4], [16.8,21.4,5.4], [11.6,17.4,5.4],
				[6.1,20.9,7.2], [3.6,19.9,9.2], [6.7,18.3,10.3], [4.1,22.9,12.4], [4.6,17.3,14.8], [5.1,12.6,15.7], [0.3,11.0,16.2], [-6.7,16.0,16.2], [-13.1,12.6,16.2], [-16.3,3.7,16.2], [-13.3,-6.2,16.2], [-0.5,-2.5,18.8], [2.2,-11.5,18.8], [8.1,-0.1,16.1], [17.1,-3.3,16.2], [20.8,5.6,16.2], [17.6,15.5,16.2]
			];
			Server_FireLooping = false;
			publicVariable "Server_FireLooping";
			{
				[(_courthouse modelToWorld _x), 0, true] spawn Server_Fire_StartFire;
				sleep 0.05;
			} foreach _fireOffsets;
			private _address = [getPos _courthouse] call A3PL_Housing_PosAddress;
			[_courthouse] call A3PL_FD_FireAlarm;
			waitUntil {Server_TerrainFires isEqualTo []};
			Server_FireLooping = true;
			publicVariable "Server_FireLooping";
		};
		case 'ForestFireReal': {
			private _frArray = [[3989.81,5380.87,0.0],[6311.83,6424.08,0.0],[8437.31,6982.17,0.0],[8277.73,8166.2,0.0],[7452.87,8321.52,0.0],[9421.3,7884.48,0.0],[10438.3,8848.33,0.0]];
			private _forestPos = selectRandom _frArray;
			private _radius = 20;
			private _maxPositions = 10;
			private _foundPositions = [];
			private _attempts = 0;

			while {count _foundPositions < _maxPositions && _attempts < 50} do {
				private _randomPos = _forestPos getPos [random _radius, random 360];

				if (surfaceIsWater _randomPos) then { continue; };
				
				if !(_randomPos in _foundPositions) then {
					_foundPositions pushBack [_randomPos#0, _randomPos#1, 0.0];
				};

				_attempts = _attempts + 1;
			};
			{
				[_x, 0, true] spawn Server_Fire_StartFire;
				sleep 0.05;
			} foreach _foundPositions;
			private _address = [_forestPos] call A3PL_Housing_PosAddress;
			[_forestPos,("STR_Server_Events_Fire_ForestDeclared" call A3PL_Localize),"ColorWhite","A3FL_Markers_Fire",1200] remoteExec ["A3PL_Lib_CreateMarker",_FIFR];
		};
		case 'PrisonFireFake': {
			private _prgateArray = nearestObjects [[worldSize/2,worldSize/2,0],["Land_A3FL_DOC_Gate"], 50000];
			private _prisongate = selectRandom _prgateArray;
			private _clinicgate = nearestObject [getPosATL _prisongate,"Land_A3PL_Clinic"];
			private _docwarehouse = nearestObject [getPosATL _clinicgate,"Land_A3FL_DOC_Warehouse"];
			private _prison = nearestObject [getPosATL _docwarehouse,"Land_A3PL_Prison"];
			[_prisongate] call A3PL_FD_FireAlarm;
			_prisongate setVariable["FireAlarmBroke",true,true];
			[_clinicgate] call A3PL_FD_FireAlarm;
			_clinicgate setVariable["FireAlarmBroke",true,true];
			[_docwarehouse] call A3PL_FD_FireAlarm;
			_docwarehouse setVariable["FireAlarmBroke",true,true];
			[_prison] call A3PL_FD_FireAlarm;
			_prison setVariable["FireAlarmBroke",true,true];
		};
		case 'PrisonFireReal': {
			private _prgateArray = nearestObjects [[worldSize/2,worldSize/2,0],["Land_A3FL_DOC_Gate"], 50000];
			private _prisongate = selectRandom _prgateArray;
			private _fireOffsets = [
				[-0.3,-8.4,3.2], [4.4,-6.1,3.2], [7.9,-6.0,3.4], [1.1,-3.4,4.3], [0.8,1.5,4.3], [-1.5,6.8,3.2], [2.2,8.7,3.2], [6.9,6.2,3.4], [0.3,8.7,0.6], [6.2,9.4,0.6], [-0.2,6.4,0.6], [-1.0,-9.0,0.6], [1.7,-5.3,0.6], [6.5,-6.0,0.6], [5.7,-9.6,0.6], [-3.0,-6.8,2.3], [5.9,6.0,0.6]
			];
			Server_FireLooping = false;
			publicVariable "Server_FireLooping";
			{
				[(_prisongate modelToWorld _x), 0, true] spawn Server_Fire_StartFire;
				sleep 0.05;
			} foreach _fireOffsets;
			private _clinicgate = nearestObject [getPosATL _prisongate,"Land_A3PL_Clinic"];
			_fireOffsets = [
				[-5.1,-6.0,-2.2], [-6.2,-2,-2.2], [0.6,-5.3,-2.2], [-1.5,-1.3,-2.2], [-5.9,1.0,-2.2], [-5.2,3.9,-2.2], [-1.8,0.9,-2.2], [1.6,-2.0,-2.2], [4.5,-1.1,-2.2], [4.1,2.8,-2.2], [6.5,-4.7,-2.2], [3.8,-6.5,-2.2]
			];
			{
				[(_clinicgate modelToWorld _x), 0, true] spawn Server_Fire_StartFire;
				sleep 0.05;
			} foreach _fireOffsets;
			private _docwarehouse = nearestObject [getPosATL _clinicgate,"Land_A3FL_DOC_Warehouse"];
			_fireOffsets = [
				[1.9,-9.7,0.0], [-3.7,-3.4,0.0], [1.6,-1.7,0.0], [-1.7,1.8,0.0], [-4.8,5.0,0.0], [2.1,9.1,0.0], [5.9,8.8,0.0], [3.9,5.0,0.0], [5.6,-6.4,0.0], [-1.5,-9.2,0.0]
			];
			{
				[(_docwarehouse modelToWorld _x), 0, true] spawn Server_Fire_StartFire;
				sleep 0.05;
			} foreach _fireOffsets;
			private _prison = nearestObject [getPosATL _docwarehouse,"Land_A3PL_Prison"];
			_fireOffsets = [
				[1.8,-0.2,0.0], [-1.4,0.1,0.0], [-5.3,0.8,0.0], [4.6,0.2,0.0], [4.8,3.7,0.0], [1.1,4.7,0.0], [-4.2,3.9,0.0], [-10.0,4.1,0.0], [-11.8,8.9,0.0], [-9.4,9.0,0.0], [-4.2,9.4,0.0], [-0.5,8.2,0.0], [3.5,9.0,0.0], [6.9,6.6,0.0], [6.4,2.9,0.0], [8.3,-0.3,0.0], [10.3,3.5,0.0], [10.2,6.8,0.0], [11.2,10.5,0.0], [12.1,6.8,0.0], [12.0,3.2,0.0], [12.8,-0.5,0.0], [11.5,14.5,0.0], [9.3,22.2,0.0], [2.8,20.3,0.0], [-2.0,16.4,0.0], [-7.2,18.3,0.0], [-8.6,24.6,0.0], [-12.3,27.2,0.0], [10.0,18.1,0.0], [14.3,25.7,0.0], [6.0,12.9,0.0], [1.7,13.3,0.0], [7.1,9.6,0.0], [4.2,16.1,0.0], [15.1,9.1,0.0], [17.3,5.1,0.0], [14.4,4.5,0.0], [4.1,24.2,0.0], [-3.3,21.0,0.0],
				[-7.8,8.4,0.8], [-9.8,10.5,2.9], [-12.3,7.6,3.0], [-9.5,4.8,3.0], [-5.6,4.3,3.0], [-5.3,7.9,3.0], [-2.7,10.4,3.0], [-4.0,3.9,3.0], [0.3,3.8,3.0], [-0.4,7.4,3.0], [3.7,9.3,3.0], [3.7,4.4,3.0], [-11.8,13.5,3.0], [-11.4,19.6,3.0], [-11.9,26.0,3.0], [-8.2,28.4,3.0], [-1.6,28.1,3.0], [6.3,28.3,3.0]
			];
			{
				[(_prison modelToWorld _x), 0, true] spawn Server_Fire_StartFire;
				sleep 0.05;
			} foreach _fireOffsets;
			private _prtowerArray = nearestObjects [getPosATL _prison,["Land_A3FL_DOC_Wall_Tower","Land_A3FL_DOC_Wall_Tower_Corner"], 50000];
			private _selectedTowers = [];
			for "_i" from 0 to 4 do {
				_selectedTowers pushBack (selectRandom _prtowerArray);
			};
			_fireOffsets = [
				[-1.0,-0.9,0.0], [0.7,0.3,3.9], [-0.3,-1.0,6.3], [-2.4,1.6,6.3], [2.2,-2.2,6.3]
			];
			{
				_tower = _x;
				{
					[(_tower modelToWorld _x), 0, true] spawn Server_Fire_StartFire;
					sleep 0.05;
				} foreach _fireOffsets;
			} forEach _selectedTowers;
			
			private _address = [getPos _courthouse] call A3PL_Housing_PosAddress;
			[_prisongate] call A3PL_FD_FireAlarm;
			[_clinicgate] call A3PL_FD_FireAlarm;
			[_docwarehouse] call A3PL_FD_FireAlarm;
			[_prison] call A3PL_FD_FireAlarm;
			waitUntil {Server_TerrainFires isEqualTo []};
			Server_FireLooping = true;
			publicVariable "Server_FireLooping";
		};
		case 'TrashCanFire': {
			private _trashCans = nearestObjects [[worldSize/2,worldSize/2,0],["A3PL_WheelieBin"], 50000];
			if (count _trashCans < 1) exitWith {};
			private _trashCan = selectRandom _trashCans;
			private _pos = getPosATL _trashCan;
			Server_FireLooping = false;
			publicVariable "Server_FireLooping";
			[_pos, 0, true, true] spawn Server_Fire_StartFire;
			private _address = [_pos] call A3PL_Housing_PosAddress;
			[format[("STR_Server_Events_Fire_TrashCanFire" call A3PL_Localize),_address],Color_Red,("STR_Common_FIFR" call A3PL_Localize),3] spawn A3PL_Lib_JobMessage;
			[position _trashCan, format[" %1",("STR_Server_Events_Fire_TrashCanFireMarker" call A3PL_Localize)],"Default","A3FL_Markers_Fire",600] remoteExec ["A3PL_Lib_CreateMarker",_FIFR];
			[position _trashCan] remoteExec ["A3PL_GPS_NavigateToPosition",_FIFR];
			["A3PL_Common\effects\firecall.ogg",150,2,10] spawn A3PL_FD_FireStationAlarm;
			
			waitUntil {Server_TerrainFires isEqualTo []};
			
			Server_FireLooping = true;
			publicVariable "Server_FireLooping";
		};
	};
}] call compile_Server;

["Server_Events_FISDEvents", {
	params [["_forceEvent","",[""]]];

	private _FISD = [("STR_Common_FISD" call A3PL_Localize)] call A3PL_Lib_FactionPlayers;
	private _SDCount = count(_FISD);
	private _eventTypes = ["StoreRobberyFake","PortRobberyFake"];
	if (_SDCount < 2) exitWith {};
	//if (_SDCount >= 3) then {_eventTypes append ["HouseRobberyFake"]};
	//if (_SDCount >= 4) then {_eventTypes append ["DealershipRobberyFake"]};
	//if (_SDCount >= 5) then {_eventTypes append ["BankRobberyFake"]};
	private _selectedEvent = if(_forceEvent isEqualTo "") then {selectRandom _eventTypes} else {_forceEvent};
	switch(_selectedEvent) do {
		case 'StoreRobberyFake': {
			private _storeNPCs = [npc_mcfisher,npc_mcfisher_1,npc_mcfisher_2,npc_mcfisher_3,npc_mcfisher_5,npc_mcfisher_6,npc_tacohell_1,npc_tacohell_3,Robbable_Shop_1,Robbable_Shop_2,Robbable_Shop_4,Robbable_Shop_6,Robbable_Shop_7,Robbable_Shop_8,Robbable_Shop_9,Robbable_Shop_10,npc_fuel_1,npc_fuel_3,npc_fuel_4,npc_fuel_6,npc_fuel_8,npc_fuel_9,npc_fuel_10,npc_fuel_7];
			private _selectedNPC = selectRandom _storeNPCs;
			private _nearBuilding = (nearestObjects [getpos _selectedNPC,["Land_A3PL_Gas_Station","Land_Coffee_DED_Coffee_01_F","Land_Coffee_DED_Coffee_02_F","Land_Taco_DED_Taco_01_F","land_market_ded_market_01_f"], 50])#0;
			_selectedNPC setVariable["falseAlarm","notStarted",true];
			private _namePos = [getPos _nearBuilding] call A3PL_Housing_PosAddress;
			[_nearBuilding,("STR_Common_AlarmTriggered" call A3PL_Localize),"ColorWhite","A3FL_Markers_911Call"] remoteExec ["A3PL_Lib_CreateMarker",_FISD];
			[("STR_Common_FISD" call A3PL_Localize),("STR_Server_Events_SD_Heist" call A3PL_Localize),getPos _nearBuilding,format[("STR_Server_Events_SD_HeistInProgress" call A3PL_Localize),_namePos],("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
		};
		case 'PortRobberyFake': {
			private _portNPCs = [npc_port_1,npc_port_2,npc_port_3,npc_port_4,npc_port_5,npc_port_7,npc_port_8];
			private _selectedNPC = selectRandom _portNPCs;
			_selectedNPC setVariable["falseAlarm","notStarted",true];
			private _namePos = switch(_selectedNPC) do {
				case npc_port_1: {("STR_Server_Events_NPCPort1" call A3PL_Localize)};
				case npc_port_2: {("STR_Common_FactoryName_Steel" call A3PL_Localize)};
				case npc_port_3: {("STR_Server_Events_NPCPort3" call A3PL_Localize)};
				case npc_port_4: {("STR_Common_WeaponFactory" call A3PL_Localize)};
				case npc_port_5: {("STR_Common_MarineFactory" call A3PL_Localize)};
				case npc_port_7: {("STR_Server_Events_NPCPort7" call A3PL_Localize)};
				case npc_port_8: {("STR_Server_Events_NPCPort8" call A3PL_Localize)};
				default {("STR_Common_UnknownLocation" call A3PL_Localize)};
			};
			[("STR_Common_FISD" call A3PL_Localize),("STR_Server_Events_HeistPort" call A3PL_Localize),getPos player,format[("STR_Server_Events_HeistPortReported" call A3PL_Localize),_namePos],("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
		};
		/* TODO:
		case 'HouseRobberyFake': {
			private _housesShed = ["Land_A3PL_BostonHouse","Land_A3PL_Shed3","Land_A3PL_Shed4","Land_A3PL_Shed2"];
			private _housesTrailer = ["Land_A3FL_Trailer","Land_A3FL_Trailer_2","Land_A3FL_Trailer_3","Land_A3FL_Trailer_4","Land_A3FL_Trailer_5","Land_A3FL_Trailer_6"];
			private _housesSingleStory = ["Land_John_House_Grey","Land_John_House_Blue","Land_John_House_Red","Land_John_House_Green","Land_A3PL_Ranch3","Land_A3PL_Ranch2","Land_A3PL_Ranch1","Land_Home4w_DED_Home4w_01_F","Land_Home1g_DED_Home1g_01_F","Land_Home2b_DED_Home2b_01_F","Land_Home5y_DED_Home5y_01_F","Land_A3FL_House2_Cream","Land_A3FL_House2_Green","Land_A3FL_House2_Blue","Land_A3FL_House2_Brown","Land_A3FL_House2_Yellow","Land_A3FL_House3_Cream","Land_A3FL_House3_Green","Land_A3FL_House3_Blue","Land_A3FL_House3_Brown","Land_A3FL_House3_Yellow","Land_A3FL_House4_Cream","Land_A3FL_House4_Green","Land_A3FL_House4_Blue","Land_A3FL_House4_Brown","Land_A3FL_House4_Yellow"];
			private _housesTwoStory = ["Land_Home3r_DED_Home3r_01_F","Land_Home6b_DED_Home6b_01_F","Land_A3FL_House1_Cream","Land_A3FL_House1_Green","Land_A3FL_House1_Blue","Land_A3FL_House1_Brown","Land_A3FL_House1_Yellow"];
			private _housesSmallMansion = ["Land_A3FL_Anton_Modern_Bungalow","Land_A3PL_ModernHouse1","Land_A3PL_ModernHouse2","Land_A3PL_ModernHouse3","Land_Mansion01"];
			private _housesBigMansion = ["Land_A3FL_Office_Building","Land_A3FL_Mansion"];
			private _housesWarehouse = ["Land_John_Hangar","Land_A3FL_Warehouse"];
		};
		case 'DealershopRobberyFake': {
		};
		case 'BankRobberyFake': {
		};
		case 'PirateShipRobberyFake': {
		};*/
	};
}] call compile_Server;

/*["Server_Events_CreateZombies", {
	params [
		["_zombieAmount",1,[1]],
		["_position",[],[[]]],
		["_forceType",-1,[-1]]
	];

	if(isNil "A3FL_Events_Zombies") then {A3FL_Events_Zombies = [];east setFriend [civilian, 0];};

	private _zombieLoadout = [
		["Zombie", [["A3PL_Scypthe","","","",["A3PL_FireaxeMag",999998],[],""],[],[],["A3PL_Zombie_Uniform",[["A3PL_FireaxeMag",3,999999]]],[],["",[]],"","",[],["ItemMap","ItemGPS","A3PL_Cellphone_2","ItemCompass","TFAR_microdagr",""]], 1.7],
		["Fireman Zombie", [["A3PL_FireAxe","","","",["A3PL_FireaxeMag",999999],[],""],[],[],["A3PL_Zombie_Uniform",[["A3PL_FireaxeMag",3,999999]]],["A3PL_FD_Oxygen",[]],["A3PL_LR",[]],"A3PL_FD_Helmet_Old_Base","",[],["ItemMap","ItemGPS","A3PL_Cellphone_1","ItemCompass","ItemWatch",""]], 1.9],
		["Sheriff Zombie", [[],[],["A3FL_Glock17","","","",["A3FL_Glock17_Mag",17],[],""],["A3PL_Zombie_Uniform",[["A3FL_Glock17_Mag",19,17]]],["A3PL_DutyBelt",[]],["A3PL_LR",[]],"A3FL_FISDFORMAL_Hat","",[],["ItemMap","ItemGPS","A3PL_Cellphone_1","ItemCompass","ItemWatch",""]], 1.5]
	];
	if(_forceType isNotEqualTo -1) then {_zombieLoadout = [_zombieLoadout#_forceType];};

	for "_i" from 0 to _zombieAmount do {
		private _grp = createGroup [east, true];
		private _unit = _grp createUnit ["O_G_Soldier_F", _position, [], 0, "FORM"];
		private _rnd = selectRandom _zombieLoadout;
		_unit setVariable ["ZombieClass",_rnd#0,true];
		if(_rnd#0 isEqualTo "Zombie") then {_rnd#1 set[0, [selectRandom["A3PL_Scypthe","A3FL_BaseballBat","A3FL_DickStick","A3FL_GolfDriver"],"","","",["A3PL_FireaxeMag",999998],[],""]];};
		_unit setUnitLoadout _rnd#1;
		_unit setAnimSpeedCoef _rnd#2;
		_grp setCombatBehaviour "COMBAT";
		_unit setUnitPos "UP";
		_unit addEventHandler ["HandleRating", {private _handler = 0;_handler;}];
		[_unit,_rnd#0] spawn Server_Events_ZombieLoop;
		A3FL_Events_Zombies pushback _unit;
	};
}] call compile_Server;

["Server_Events_ZombieLoop", {
	params [
		["_unit",objNull,[objNull]],
		["_type","Zombie",["Zombie"]]
	];

	private _isMelee = (_type IN ["Zombie","Fireman Zombie"]);
	diag_log _type;
	diag_log _isMelee;
	private _target = objNull;
	private _medArray = ["left lower leg","right upper leg","left lower leg","pelvis","left upper leg","right upper leg","left upper leg","right lower leg","left lower leg","left upper leg","head","right upper leg","right lower leg","head","head","right lower leg"];
	while{alive _unit} do {
		if((isNull _target) || {!(_target getVariable["A3PL_Medical_Alive",true])} || {((_target distance2D _unit) > 60)}) then {
			{
				if((isPlayer _x) && {(_x getVariable["A3PL_Medical_Alive",true])} && {!(_x getVariable["pVar_RedNameOn",false])}) exitWith {
					_target = _x;
				};
			} foreach nearestObjects [_unit,["C_man_1"],40];
			if(!isNull _target) then {
				_unit doMove (position _target);
				_unit knowsAbout _target;
				sleep 1;
			} else {
				sleep 8;
			};
		} else {
			_unit doMove (position _target);
			_unit reveal _target;
			if(_isMelee && {(_target distance2D _unit) < 3}) then {
				_unit playAction "GestureSwing";
				if !(_target getVariable["pVar_RedNameOn",false]) then {[_target,selectRandom _medArray,"cut"] call A3PL_Medical_ApplyWound;};
				sleep 2;
			} else {
				_unit doFire _target;
				sleep 1;
			}
			
		};
	};
}] call compile_Server;*/
