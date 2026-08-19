/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["Server_Shrooms_Loop", {
	{
		private _plantation = _x;
		private _plantationPos = _x#1;

		private _nearShrooms = _plantationPos nearEntities [["A3FL_Mushroom"],175];
		private _nearPlayerCount = count (_plantationPos nearEntities ["C_man_1",175]);
		private _nearPl = _plantationPos nearEntities ["C_man_1",175];
		private _shroomCount = count (_nearShrooms);
		private _maxShrooms = 30;
		if (_plantation#0 isEqualTo "Plantation_18") then {
			_nearPlayerCount = _nearPlayerCount - 1;
		};
		if ((_nearPlayerCount < 1) && (_shroomCount > 0)) then {
			{
				deleteVehicle _x;
			} forEach _nearShrooms;
		} else {
			if ((_nearPlayerCount > 0) && (_shroomCount < _maxShrooms)) then {
				private _amtToSpawn = 6 + (round random 4);
				for "_i" from 1 to _amtToSpawn do {
					private _currentCount = count (_plantationPos nearEntities [["A3FL_Mushroom"],175]);
					if (_currentCount >= _maxShrooms) exitWith {};
					private _randPos = [[[_x#1, 140]],[]] call BIS_fnc_randomPos;
					private _shroom = createVehicle ["A3FL_Mushroom", _randPos, [], 0, "CAN_COLLIDE"];
					_shroom enableSimulationGlobal false;
					_shroom setVariable ["class","shrooms",true];
					_shroom setDir (random 360);
				};
			};
		};
	} forEach Server_Plantations;
}] call compile_Server;
