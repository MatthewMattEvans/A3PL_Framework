/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["Server_JobFarming_Plant",
{
    private _player = param [0,objNull];
    private _class = param [1,""];
    private _pos = param [2,[]];
    private _inPlanter = param [3,false];
	private _planter = param [4,objNull];

    if ((isNull _player) || {_class isEqualTo ""}) exitwith {};
    if !([_class,1,_player] call Server_Inventory_Has) exitwith {};
    [_player,_class,-1] call Server_Inventory_Add;
	private _plantClass =  switch (_class) do {
        case "seed_wheat": {"A3PL_Wheat"};
        case "seed_corn": {"A3PL_Corn"};
        case "seed_marijuana": {"A3FL_Cannabis_Plant"};
        case "seed_lettuce": {"A3PL_Lettuce"};
        case "seed_coca": {"A3PL_Coco_Plant"};
        case "seed_sugar": {"A3PL_Sugarcane_Plant"};
        case "seed_carrot": {"A3FL_Carrot_Grow"};
        case "seed_tobacco": {"A3FL_Tobacco_Plant"};
        default {""};
    };
    private _ATLChange =  if(_plantClass isEqualTo "seed_lettuce") then {-0.15} else {0};
    if (_plantClass isEqualTo "") exitwith {};
    private _plant = createVehicle [_plantClass,[_pos select 0,_pos select 1, (_pos select 2) + _ATLChange], [], 0, "CAN_COLLIDE"];
	if (_inPlanter) then {_plant attachTo [_planter]};
    _plant animateSource ["plant_growth",1];
    _plant allowDamage false;

	private _plantation = [position _plant] call A3FL_JobFarming_InPlantation;
	switch (true) do {
		case (!(_plantation isEqualTo 0) && (typeOf _plant) IN ["A3FL_Cannabis_Plant","A3PL_Coco_Plant","A3FL_Tobacco_Plant"]): { _plant animateSource ["plant_growth",1]; };
		case ((surfaceType getpos player) == "#cype_plowedfield" && (typeOf _plant) IN ["A3FL_Cannabis_Plant","A3PL_Coco_Plant","A3FL_Tobacco_Plant"]): { _plant animateSource ["plant_growth",1,0.5]; };
	};

    if((typeOf _plant) isEqualTo "A3FL_Cannabis_Plant") then {
    	if(!_inPlanter) then {_plant setVariable ["inField",true,true];};
		_player setVariable["isPlanting",true,true];
        private _lamp200w = count(player nearEntities [["A3PL_Cannabis_Lamp_200W"],2]);
        private _lamp500w = count(player nearEntities [["A3PL_Cannabis_Lamp_500W"],2]);
        private _lamp1000w = count(player nearEntities [["A3PL_Cannabis_Lamp_1000W"],2]);
        if (_lamp1000w > 0) exitWith {_plant animateSource ["plant_growth",1,1.75];};
        if (_lamp500w > 0) exitWith {_plant animateSource ["plant_growth",1,1.5];};
        if (_lamp200w > 0) exitWith {_plant animateSource ["plant_growth",1,1.25];};
    };
    if(!_inPlanter) then {
    	private _pos = getPos _player;
		private _dir = getDir _player;
		_player setPos [
			(_pos select 0) + (sin _dir * 0.75),
			(_pos select 1) + (cos _dir * 0.75),
			(_pos select 2)
		];
    };
	if (_inPlanter) exitWith {[7] remoteExec ["A3PL_JobFarming_PlantReceive",owner _player];};
    [0] remoteExec ["A3PL_JobFarming_PlantReceive",owner _player];
}] call compile_Server;

["Server_JobFarming_Harvest",
{
	private _player = param [0,objNull];
	private _plant = param [1,objNull];
	private _itemClass = "";
	private _seedItem = "";
	private _amount = 0;
	private _seedAmount = 1;

	// Check if player has the green_hand trait
	private _traits = _player getVariable ["Player_Traits", []];
	private _hasGreenHandTrait = "green_hand" in _traits;
	private _luckyBonus = [_traits] call A3PL_Traits_GetLuckyBonus;

	if (_plant getVariable ["inuse",false]) exitwith {};
	_plant setVariable ["inuse",true,false];

	switch (typeOf _plant) do
	{
		case "A3PL_Wheat": {_amount = 10; _itemClass = "wheat"; _seedItem = "seed_wheat";};
		case "A3PL_Corn": {_amount = 2; _itemClass = "corn"; _seedItem = "seed_corn";};
		case "A3PL_Lettuce": {_amount = 4; _itemClass = "lettuce"; _seedItem = "seed_lettuce";};
		case "A3PL_Coco_Plant": {_amount = 2; _itemClass = "coca"; _seedItem = "seed_coca";};
		case "A3PL_Sugarcane_Plant": {_amount = 2; _itemClass = "sugarcane"; _seedItem = "seed_sugar";};
		case "A3FL_Cannabis_Plant":{_amount = 1; _itemClass = "cannabis_plant_stage1"; _seedItem = "seed_marijuana";};
		case "A3FL_Carrot_Grow":{_amount = 2; _itemClass = "carrot"; _seedItem = "seed_carrot";};
		case "A3FL_Tobacco_Plant":{_amount = 1; _itemClass = "tobacco"; _seedItem = "seed_tobacco";};
	};

	if (_itemClass isEqualTo "") exitwith {};
	if (_itemClass isEqualTo "cannabis_plant_stage1") then {_player setVariable["isPlanting",false,true];};
	if (([[[_itemClass,_amount]],_player] call Server_Inventory_TotalWeight) > 600) exitWith {[6] remoteExec ["A3PL_JobFarming_PlantReceive",owner _player];_plant setVariable ["inuse",false,false];};

	deleteVehicle _plant;

	// Green_hand trait: 50% chance to double the yield (+ lucky bonus, or lucky alone: 15%)
	private _chance = if (_hasGreenHandTrait) then {50 + _luckyBonus} else {_luckyBonus};
	if (_chance > 0 && {random 100 < _chance}) then {
		_amount = _amount * 2 * A3PL_Event_DblHarvest;
	} else {
		_amount = _amount * A3PL_Event_DblHarvest;
	};

	[_itemClass,_amount] remoteExec ["A3PL_Inventory_Add", (owner _player)];
	[5,_itemClass,_amount] remoteExec ["A3PL_JobFarming_PlantReceive",owner _player];

	// Green_hand trait: Always get seeds back when harvesting
	if((typeOf _plant) IN ["A3PL_Wheat","A3PL_Corn","A3PL_Lettuce","A3PL_Coco_Plant","A3PL_Sugarcane_Plant","A3FL_Carrot_Grow","A3FL_Tobacco_Plant"]) then {
		if (_hasGreenHandTrait) then {
			// With trait: always get 1-3 seeds
			_seedAmount = round(random [1, 2, 3]);
			[_seedItem, _seedAmount] remoteExec ["A3PL_Inventory_Add", (owner _player)];
		} else {
			// Without trait: 35% chance to get 1 seed
			private _chance = random(100);
			if(_chance < 35) then {
				[_seedItem, 1] remoteExec ["A3PL_Inventory_Add", (owner _player)];
			};
		};
	};
}] call compile_Server;

/*["Server_JobFarming_DrugDealerPos",
{
	private _object = DrugDealerHouse;
	private _npc = npc_drugsdealer;
	private _table = DrugDealerRelative1;
	private _areas = ["Area_DrugDealer","Area_DrugDealer1","Area_DrugDealer2","Area_DrugDealer3"];
	private _area = _areas select (floor (random (count _areas)));
	private _pos = [_area] call CBA_fnc_randPosArea;
	private _pos = _pos findEmptyPosition [0, 25,(typeOf _object)];
	if (count _pos == 0) exitwith {call Server_JobFarming_DrugDealerPos};
	if ((count (_pos nearRoads 50)) > 0) exitwith {call Server_JobFarming_DrugDealerPos};
	_object setDir (floor (random 360));
	_object setpos _pos;
	_npc setDir (getDir _object + 90);
	_npc setpos (_object modelToWorld [-4,-0.2,-0.4]);
	_table setDir (getDir _object);
	_table setpos (_object modelToWorld [-3,-0.2,-0.4]);
}] call compile_Server;*/

["Server_JobFarming_PlantationSetup",
{
	Server_Plantations = [];
	Server_MainPlantations = [
		["Plantation_1",[4119.01,5441.61,0.00146484]],
		["Plantation_2",[6636.19,6099.91,0.00143862]],
		["Plantation_3",[7626.6,6728.07,0.00143909]],
		["Plantation_4",[7477.16,6145.37,0.00143862]],
		["Plantation_5",[8632.4,6784.99,0.00126839]],
		["Plantation_6",[8143.38,7369.6,0.00143862]],
		["Plantation_7",[7450.97,8244.06,0.00143862]],
		["Plantation_8",[8612.26,8184.36,0.00143242]],
		["Plantation_9",[10522.9,7752.17,0.00143051]],
		["Plantation_10",[3966.23,4990.49,0.00143862]],
		["Plantation_11",[5289.52,6051.15,0.00144768]],
		["Plantation_12",[10710.6,8680.97,0.00143719]],
		["Plantation_13",[5781.59,6758.84,0.00152683]],
		["Plantation_14",[4024.36,6849.65,0.00133514]],
		["Plantation_15",[5002.43,5503.88,0.00145626]],
		["Plantation_16",[3181.65,5234.88,0.00143886]],
		["Plantation_17",[9482.77,7885.41,0.00141335]],
		["Plantation_18",[6436.06,6738.99,0.00144243]],
		["Plantation_19",[8029.05,6354.39,0.00143862]],
		["Plantation_20",[11125.7,8769.6,0.0015564]]
	];

	Server_PlantationAreas = [];
	for "_i" from 0 to 4 do {
		private _count = (Server_MainPlantations select (floor (random (count Server_MainPlantations))));
		private _randomSoil = round(random [1, 5, 10]);
		private _countArray = [_count#0,_count#1,_randomSoil];
		Server_Plantations pushBack _countArray;
		Server_PlantationAreas pushback _countArray#0;
		if(_count IN Server_Plantations) then {
			private _find = Server_Plantations find _count;
			Server_Plantations deleteAt _find;
			_count = (Server_MainPlantations select (floor (random (count Server_MainPlantations))));
			Server_Plantations pushBack _count;
		};
	};

	publicVariable "Server_Plantations";
	publicVariable "Server_PlantationAreas";

	//diag_log "Server_Plantations";
	//diag_log Server_Plantations;
}] call compile_Server;
