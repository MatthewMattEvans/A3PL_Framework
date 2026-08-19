/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
#define OREDMGDISS 0.55

["Server_JobWildcat_RandomizeOil",
{
	Server_JobWildCat_Oil = [];
	// Server_JobWildCat_Oil = [[[3488.800,12506.046,0],10000, 10000, false]];
	private _areas = ["FIMiningArea1","FIMiningArea2","FIMiningArea3","FIMiningArea4","FIMiningArea5","FIMiningArea6","FIMiningArea7","FIMiningArea8","FIMiningArea9","FIMiningArea10","FIMiningArea11","FIMiningArea12","FIMiningArea13","FIMiningArea14","FIMiningArea15","FIMiningArea16","FIMiningArea17","FIMiningArea18","FIMiningArea19","FIMiningArea20","FIMiningArea21","FIMiningArea22","FIMiningArea23","FIMiningArea24","FIMiningArea25","FIMiningArea26","FIMiningArea27","FIMiningArea28","FIMiningArea29","FIMiningArea30","FIMiningArea31"];
	
	for "_i" from 0 to 30 do
	{
		private _area = selectRandom _areas;
		private _randPos = [_area] call CBA_fnc_randPosArea;
		private _overWater = !(_randPos isFlatEmpty  [-1, -1, -1, -1, 2, false] isEqualTo []);
		while {_overWater} do {
			_randPos = [_area] call CBA_fnc_randPosArea;
			_overWater = !(_randPos isFlatEmpty  [-1, -1, -1, -1, 2, false] isEqualTo []);
		};
		_oilAmounts = [210,252,294,336,378,420,462,504];
		_r = floor random 8;
		_arr = [_randPos,(_oilAmounts select _r), (_oilAmounts select _r), false];
		Server_JobWildCat_Oil pushback _arr;
	};
	publicVariable "Server_JobWildCat_Oil";
}] call compile_Server;

["Server_JobWildcat_ResetOil",
{
	if (!isNil "Server_JobWildCat_Oil" && Server_JobWildCat_Oil isEqualType []) then {
		{
			if(_x isEqualType [] && count _x >= 2) then {
				_x set [2,(_x#1)];
				_x set [3,false];
			};
		} forEach Server_JobWildCat_Oil;
		publicVariable "Server_JobWildCat_Oil";
	};
}] call compile_Server;

["Server_JobWildcat_RandomizeRes",
{
	Server_JobWildCat_Res = [];
	{
		private _areasMain = ["FIMiningArea1","FIMiningArea2","FIMiningArea3","FIMiningArea4","FIMiningArea5","FIMiningArea6","FIMiningArea7","FIMiningArea8","FIMiningArea9","FIMiningArea10","FIMiningArea11","FIMiningArea12","FIMiningArea13","FIMiningArea14","FIMiningArea15","FIMiningArea16","FIMiningArea17","FIMiningArea18","FIMiningArea19","FIMiningArea20","FIMiningArea21","FIMiningArea22","FIMiningArea23","FIMiningArea24","FIMiningArea25","FIMiningArea26","FIMiningArea27","FIMiningArea28","FIMiningArea29","FIMiningArea30","FIMiningArea31"];
		//private _areasNorth = ["NIMiningArea1","NIMiningArea2","NIMiningArea3","NIMiningArea4","NIMiningArea5","NIMiningArea6","NIMiningArea7"];
		private _newAreas = [];
		private _newArea = "";
		private _name = _x select 0;
		private _areas = _x select 1;
		private _ores = _x select 2;
		for "_i" from 0 to _areas do {
			private _island = _x select 5;	
			// if(_island isEqualTo "All") then {
			// 	_newAreas = _areasMain;
			// 	_newAreas append _areasNorth;
			// 	_newArea = selectRandom _newAreas;
			// };

			if (_island isEqualTo "FIMiningArea") then {
				_newAreas = _areasMain;
				_newArea = selectRandom _newAreas;
			};

			// if (_island isEqualTo "NIMiningArea") then {
			// 	_newAreas = _areasNorth;
			// 	_newArea = selectRandom _newAreas;
			// };

			private _randPos = [_newArea] call CBA_fnc_randPosArea;
			private _overWater = !(_randPos isFlatEmpty  [-1, -1, -1, -1, 2, false] isEqualTo []);
			while {_overWater} do {
				_randPos = [_newArea] call CBA_fnc_randPosArea;
				_overWater = !(_randPos isFlatEmpty  [-1, -1, -1, -1, 2, false] isEqualTo []);
			};
			private _arr = [_name,_randPos,_ores,_ores, false];
			Server_JobWildCat_Res pushback _arr;
		};
	} foreach Config_Resources_Ores;
	publicVariable "Server_JobWildCat_Res";
}] call compile_Server;

["Server_JobWildcat_ResetOre",
{
	if (!isNil "Server_JobWildCat_Res" && Server_JobWildCat_Res isEqualType []) then {
		{
			if(_x isEqualType [] && count _x >= 3) then {
				_x set [3,(_x#2)];
				_x set [4,false];
			};
		} forEach Server_JobWildCat_Res;
		publicVariable "Server_JobWildCat_Res";
	};
}] call compile_Server;

["Server_JobWildCat_SpawnRes",
{
	private _player = param [0,objNull];
	private _foundOre = param [1,""];
	private _oreLocation = param [2,0];
	private _objClass = "A3PL_Resource_Ore_Coal";
	switch (_foundOre) do {
		case ("STR_Common_Iron" call A3PL_Localize): {_objClass = "A3PL_Resource_Ore_Iron";};
		case ("STR_Common_Coal" call A3PL_Localize): {_objClass = "A3PL_Resource_Ore_Coal";};
		case ("STR_Common_Bauxite" call A3PL_Localize): {_objClass = "A3PL_Resource_Ore_Bauxite";};
		case ("STR_Common_Soufre" call A3PL_Localize): {_objClass = "A3PL_Resource_Ore_Sulphur";};
		case ("STR_Common_Sapphires" call A3PL_Localize): {_objClass = "A3PL_Resource_Ore_Sapphire";};
		case ("STR_Common_Vivianite" call A3PL_Localize): {_objClass = "A3PL_Resource_Ore_Vivianite";};
		case ("STR_Common_Emeralds" call A3PL_Localize): {_objClass = "A3PL_Resource_Ore_Emerald";};
		case ("STR_Common_Gold" call A3PL_Localize): {_objClass = "A3PL_Resource_Ore_Gold";};
		case ("STR_Common_Amethysts" call A3PL_Localize): {_objClass = "A3PL_Resource_Ore_Amethyst";};
	};

	private _indexOre = -1;
	{
		if ((_oreLocation isEqualTo _x#1) && (_foundOre isEqualTo _x#0)) exitWith {_indexOre = _forEachIndex};
	}forEach Server_JobWildCat_Res;

	if (_indexOre isEqualTo -1) exitWith {};

	private _activeOreData = Server_JobWildCat_Res#_indexOre;
	private _oreLefts = _activeOreData#3;

	if (_oreLefts <= 0) exitWith {};

	private _obj = createVehicle [_objClass,_player, [], 0, "CAN_COLLIDE"];
	_obj setVariable ["oreClass",_foundOre,false];
	_obj setVariable ["oreIndex", _indexOre, false];

	{
		if ((_x select 0) isEqualTo _foundOre) exitwith {
			_obj setVariable ["smallOreItemClass",_x select 3,false];
			_obj setVariable ["smallOreAmount",_x select 4,false];
		};
	} foreach Config_Resources_Ores;

	_obj addEventHandler ["HandleDamage", {
		private _obj = param [0,objNull];
		private _sel = param [1,""];
		private _dmg = param [2,0];
		private _player = param [3,objNull];
		private _ins = param [6,objNull];
		private _wep = currentWeapon _ins;
		private _newDmg = _dmg;
		private _oldDmg = _obj getVariable ["dmg",0];
		private _giveEach = _obj getVariable ["smallOreAmount",1];
		private _prevDamage = _obj getVariable [format ["%1_dmg",_sel],0];

		private _indexOre = _obj getVariable ["oreIndex",-1];

		if (_indexOre isEqualTo -1) exitWith {};

		private _activeOreData = Server_JobWildCat_Res#_indexOre;
		private _oreAmount = _activeOreData#3;

		if ((typeOf (vehicle _ins)) isEqualTo "A3PL_MiniExcavator") then {_wep = (vehicle _ins) currentWeaponTurret [0];};
		if (((_dmg >= 0.55) && (_sel == "hitpickaxe")) || (_oreAmount <= 0)) exitwith {

			if (_oreAmount <= 0) then {
				private _oreClass = _obj getVariable ["oreClass",""];
				[format[("Server_Job_Wildcat_SpawnRes_NoMoreResources" call A3PL_Localize), _oreClass], Color_Red] remoteExec ["A3PL_Notification",_player];
			};

			deleteVehicle _obj;
		};
		if ((_dmg >= (_oldDmg + (0.55 / _giveEach))) && (_sel == "hitpickaxe") && (_wep IN ["A3PL_Machinery_Pickaxe","A3PL_Pickaxe"])) then
		{
			private _random = random 100;
			if (_random < 5) then {
				private _random = random 100;
				private _itemClass = "diamond_tourmaline";
				switch (true) do {
					case (_random < 1): {_itemClass = "diamond";};
					case (_random < 4): {_itemClass = "diamond_emerald";};
					case (_random < 9): {_itemClass = "diamond_ruby";};
					case (_random < 19): {_itemClass = "diamond_sapphire";};
					case (_random < 30): {_itemClass = "diamond_alex";};
					case (_random < 50): {_itemClass = "diamond_aqua";};
				};
				if (([[[_itemClass,1]],_ins] call Server_Inventory_TotalWeight) > 250) exitwith {[("STR_Common_NotEnoughSpace" call A3PL_Localize),Color_Red] remoteExec ["A3PL_Notification",(owner _ins)];_newDmg = _prevDamage;_dmg=0;};
				[_ins,_itemClass,1,false] call Server_Inventory_Add;

				[("Server_Job_Wildcat_YouFindRareOres" call A3PL_Localize), Color_Green] remoteExec ["A3PL_Notification", (owner _ins)];
			} else {
				_itemClass = _obj getVariable ["smallOreItemClass","ore_metal"];

				// Check if player has the miner trait
				private _traits = _ins getVariable ["Player_Traits", []];
				private _hasMinerTrait = "miner" in _traits;
				private _luckyBonus = [_traits] call A3PL_Traits_GetLuckyBonus;

				private _amount = 1 * A3PL_Event_DblHarvest;

				// Miner trait: 50% chance to double the yield (+ lucky bonus, or lucky alone: 15%)
				private _chance = if (_hasMinerTrait) then {50 + _luckyBonus} else {_luckyBonus};
				if (_chance > 0 && {random 100 < _chance}) then {
					_amount = 2 * A3PL_Event_DblHarvest;
				};

				if (([[[_itemClass,_amount]],_ins] call Server_Inventory_TotalWeight) > 250) exitwith {[("STR_Common_NotEnoughSpace" call A3PL_Localize),Color_Red] remoteExec ["A3PL_Notification",(owner _ins)];_newDmg = _prevDamage;_dmg=0;};
				[_ins,_itemClass,_amount,false] call Server_Inventory_Add;

				_oreAmount = _oreAmount -1;
				_activeOreData set [3,_oreAmount];
				Server_JobWildCat_Res set [_indexOre,_activeOreData];
				publicVariable "Server_JobWildCat_Res";

				[format[("Server_Job_Wildcat_YouGatheredOres" call A3PL_Localize),_amount], Color_Green] remoteExec ["A3PL_Notification", (owner _ins)];
			};
			_obj setVariable ["dmg",_dmg,false];
			if (_oreAmount <= 0) then {deleteVehicle _obj;};
		};

		if ((_sel == "hitshovel") && (!(_wep IN ["A3PL_Machinery_Bucket","A3PL_Shovel"]))) then {_newDmg = _prevDamage;};
		if ((_sel == "hitpickaxe") && (!(_wep IN ["A3PL_Machinery_Pickaxe","A3PL_Pickaxe"]))) then { _newDmg = _prevDamage;};
		_obj setVariable [format ["%1_dmg",_sel],_newdmg,false];
		_newDmg;
	}];

	private _pos = getPos _player;
	private _dir = getDir _player;
	_player setPos [
		(_pos select 0) + (sin _dir * 1.5),
		(_pos select 1) + (cos _dir * 1.5),
		(_pos select 2)
	];
}] call compile_Server;
