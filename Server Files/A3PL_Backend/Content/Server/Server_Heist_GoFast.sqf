/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/

["Server_Criminal_GoFastRobbery", {
	params [
		["_gofast",objNull,[objNull]],
		["_player",objNull,[objNull]]
	];

	private _cars = ["A3FL_BMW_M6","A3FL_Nissan_GTR_LW","EC_Performante","A3PL_911GT2","A3FL_Escalade","A3PL_Camaro","A3PL_Mustang"];
	private _vehicleClassname = selectRandom _cars;
	private _id = [7] call Server_Housing_GenerateID;
	private _randomColor = format["#(argb,8,8,3)color(%1,%2,%3,1.0,CO)",random 1, random 1, random 1];
	private _dir = (getDir _gofast) - 180;
	private _spawnPos = [[10140.1,7918.96,0.00142336],[10213.2,7947.64,0.5],[10262.7,8005.72,0.5],[10220.5,7884.89,0.5],[10107.5,7987.83,0.5],[10295.8,7879.12,0.5]];
	_spawnPos = selectRandom _spawnPos;
	private _veh = [_vehicleClassname,_spawnPos,_id,_player] call Server_Vehicle_Spawn;

	private _commonItems = [];
	private _rareItems = [];
	private _virtualItems = [];
	private _commonCount = 4;
	private _rareCount = 2;
	_commonItems = [["seed_marijuana",10],["seed_coca",10],["coca",2],["jug",1],["sulphuric_acid",1],["calcium_carbonate",1],["potassium_permangate",1],["ammonium_hydroxide",1],["acetone",1],["hydrocloric_acid",1]];
	_rareItems = [["coca_paste",1],["cocaine_base",1],["cocaine_hydrochloride",1],["jug_moonshine",1],["weed_bag_100g",1],["weed_bag_50g",1],["weed_bag_25g",1]];
			
	for "_i" from 0 to _commonCount do {
		_item = selectRandom _commonItems;
		_virtualItems = [_virtualItems, _item select 0, _item select 1, true] call BIS_fnc_addToPairs;
	};

	for "_i" from 0 to _rareCount do {
		_item = selectRandom _rareItems;
		_virtualItems = [_virtualItems, _item select 0, _item select 1, true] call BIS_fnc_addToPairs;
	};

	_veh setDir _dir;
	_veh setObjectTextureGlobal[0,_randomColor];
	_veh setVariable["StolenTime",serverTime,true];
	_veh setVariable["StolenCarDamage",0,true];
	_veh setVariable["storage",_virtualItems,true];
	_veh setVariable["goFast",true,true];
	
	Server_GoFast_Vehicles pushBack [_id,["Fishers Island Go Fast",1,_vehicleClassname,1,0,"00000"]];
	private _deliveryLocation = [getPos _gofast] call Server_Criminal_GoFastRobberyDeliveryLocation;
	[("Server_Heist_GoFast_VehicleHided" call A3PL_Localize),Color_Green] remoteExec ["A3PL_Notification",_player];
	[_deliveryLocation] remoteExec ["A3PL_Robberies_GoFastPos",_player];
	[getPlayerUID _player,(_player getVariable ["character_id",""]),"Robbery_GoFast_Success",[format ["Position: %1 | Vehicle: %2",(getPosATL _gofast),(typeOf _veh)]]] call Server_Log_New;
}] call compile_Server;

["Server_Criminal_GoFastRobberyDeliveryLocation", {
	params [["_curLocation",[0,0,0],[[0,0,0]]]];
	private _locations = [[3497.61,7547.56,0.00143743,229.337],[2988.57,5908.87,0.00143862,324.348],[4329.96,6952.29,0.00143623,275.024],[3429.76,6655.08,0.00120139,99.067]];
	private _returnPosition = [0,0,0];
	private _tempPosition = [];
	_tempPosition = selectRandom (_locations);
	_returnPosition = [_tempPosition#0,_tempPosition#1,_tempPosition#2];
	npc_gofast_robbery_end setPos _returnPosition;
	npc_gofast_robbery_end setDir (_tempPosition#3);
	_returnPosition;
}] call compile_Server;

["Server_Criminal_GoFastDelivered", {
	params [["_veh",objNull,[objNull]]];

	npc_gofast_robbery_end setPos [12628.07,1745.094,0];
	private _id = _veh getVariable["owner",["",""]];
	private _deleteIndex = -1;
	{
		if(_x#0 isEqualTo _id) exitwith {_deleteIndex = _foreachindex};
	} forEach Server_GoFast_Vehicles;
	[_veh] call Server_Vehicle_Despawn;
	if(_deleteIndex isEqualTo -1) exitWith {};
	Server_GoFast_Vehicles deleteAt _deleteIndex;
	publicVariable "Server_GoFast_Vehicles";
}] call compile_Server;
