/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["Server_Hunting_HandleLoop",
{
	["goat",[6538.92,6180.29,0],["Goat","Goat02","WildBoar","Sheep","Sheep02"],300,45] spawn Server_Hunting_Spawn;
	/*sleep 5;
	["wildboar",[6501.12,7496.88,0],["WildBoar"],230,15] spawn Server_Hunting_Spawn;
	sleep 5;
	["sheep",[8088.19,7370.35,0],["Sheep","Sheep02","Sheep03"],200,15] spawn Server_Hunting_Spawn;
	sleep 5;
	["cow",[4042.35,5049.09,0],["Cow01","Cow02","Cow03","Cow04","Cow05"],200,15] spawn Server_Hunting_Spawn;*/
}] call compile_Server;

["Server_Hunting_Spawn",
{
	private _siteVar = format ["A3PL_Animals_%1",(param [0,"def"])];
	private _sitePos = param [1,[]];
	private _animalList = param [2,[]];
	private _genDist = param [3,5];
	private _animalCount = param [4,5];
	private _radius = param [5,_genDist];
	private _dist = 10000;
	private _siteAnimals = missionNameSpace getVariable [_siteVar,[]];
	private _deleteAnimals = [];
	{
		if (isNull _x) then
		{
			_deleteAnimals = _deleteAnimals + [_x];
		};
	} foreach _siteAnimals;
	{
		_siteAnimals = _siteAnimals - [_x];
	} foreach _deleteAnimals;

	{
		_checkDist = (_x distance2D _sitePos);
		if (_checkDist < _dist) then {_dist = _checkDist};
	} forEach allPlayers;

	if (_dist < _genDist) then
	{
		_i = count _siteAnimals;
		while {_i < _animalCount} do
		{
			_animal = _animalList select (round ((random ((count _animalList) - 0.01)) - 0.499));
			_pos = [((_sitePos select 0) - _radius + random (_radius * 2)), ((_sitePos select 1) - _radius + random (_radius * 2)), 0];
			_unit = createAgent [_animal,_pos,[],0,"NONE"];
			_unit setDir (random 360);
			_siteAnimals = _siteAnimals + [_unit];
			_i = _i + 1;
			sleep 0.05;
		};
		missionNameSpace setVariable [_siteVar,_siteAnimals];
	} else  {
		{deleteVehicle _x} forEach _siteAnimals;
		missionNameSpace setVariable [_siteVar,[]];
	};
}] call compile_Server;
