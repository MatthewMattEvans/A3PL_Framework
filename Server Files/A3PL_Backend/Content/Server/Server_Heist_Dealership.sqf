/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["Server_Criminal_DealershipRobbery", {
	params [
		["_dealership",objNull,[objNull]],
		["_player",objNull,[objNull]]
	];

	private _cars = ["A3FL_Tahoe","A3FL_Explorer_Platinum_20","A3FL_BMW_M6","A3FL_Nissan_GTR_LW"];
	private _vehicleClassname = selectRandom _cars;
	private _id = [7] call Server_Housing_GenerateID;
	private _randomColor = format["#(argb,8,8,3)color(%1,%2,%3,1.0,CO)",random 1, random 1, random 1];
	private _dir = (getDir _dealership) - 180;
	private _spawnPos = _dealership modelToWorld [-6,-1,-3];
	private _veh = [_vehicleClassname,_spawnPos,_id,_player] call Server_Vehicle_Spawn;
	_veh setDir _dir;
	_veh setObjectTextureGlobal[0,_randomColor];
	_veh setVariable["DealershipStolen",true,true];
	_veh setVariable["StolenTime",serverTime,true];
	_veh setVariable["StolenCarDamage",0,true];
	Server_Dealership_Vehicles pushBack [_id,["Fishers Island Car Dealership",1,_vehicleClassname,1,0,"00000"]];
	private _deliveryLocation = [getPos _dealership] call Server_Criminal_DealershipRobberyDeliveryLocation;
	[("Server_Heist_Dealership_VirusUploaded" call A3PL_Localize),Color_Green] remoteExec ["A3PL_Notification",_player];
	[_deliveryLocation] remoteExec ["A3PL_Robberies_DealershipPos",_player];
	[getPlayerUID _player,(_player getVariable ["character_id",""]),"Robbery_Dealership_Success",[format ["Position: %1 | Vehicle: %2",(getPosATL _dealership),(typeOf _veh)]]] call Server_Log_New;
}] call compile_Server;

["Server_Criminal_DealershipRobberyDeliveryLocation", {
	params [["_curLocation",[0,0,0],[[0,0,0]]]];
	private _locations = [
		["Elk City",[[2458.51,5531.76,0.00143719,217.233],[3324.55,7500.55,0.00143194,184.63],[11836,9234.49,0.00142682,219.885]]],
		["Northdale",[[2458.51,5531.76,0.00143719,217.233],[3324.55,7500.55,0.00143194,184.63],[7075.47,6404.68,0.00144053,289.57]]],
		["Silverton",[[6274.19,7375.77,0.00143862,308.215],[9961.99,8658.16,0.00143862,88.551],[6380.26,7982.9,0.00147438,133.375],[11836,9234.49,0.00142682,219.885]]],
		["Stoney Creek",[[6274.19,7375.77,0.00143862,308.215],[9961.99,8658.16,0.00143862,88.551],[6380.26,7982.9,0.00147438,133.375]]],
		["Jamestown",[[6274.19,7375.77,0.00143862,308.215],[2458.51,5531.76,0.00143719,217.233],[3324.55,7500.55,0.00143194,184.63]]],
		["Deadwood",[[6274.19,7375.77,0.00143862,308.215],[2458.51,5531.76,0.00143719,217.233],[3324.55,7500.55,0.00143194,184.63]]]
	];
	private _returnPosition = [0,0,0];
	private _tempPosition = [];
	private _nearCity = text ((nearestLocations [_curLocation, ["NameCityCapital","NameCity","NameVillage"], 2500])#0);
	{
		if(_nearCity isEqualTo _x#0) exitwith {
			_tempPosition = selectRandom (_x#1);
			_returnPosition = [_tempPosition#0,_tempPosition#1,_tempPosition#2];
			npc_dealership_robbery setPos _returnPosition;
			npc_dealership_robbery setDir (_tempPosition#3);
		};
	} forEach _locations;
	_returnPosition;
}] call compile_Server;

["Server_Criminal_StolenCarDelivered", {
	params [["_veh",objNull,[objNull]]];

	npc_dealership_robbery setPos [12628.5,1747.77,0.0014205];
	private _id = _veh getVariable["owner",["",""]];
	private _deleteIndex = -1;
	{
		if(_x#0 isEqualTo _id) exitwith {_deleteIndex = _foreachindex};
	} forEach Server_Dealership_Vehicles;
	[_veh] call Server_Vehicle_Despawn;
	if(_deleteIndex isEqualTo -1) exitWith {};
	Server_Dealership_Vehicles deleteAt _deleteIndex;
	publicVariable "Server_Dealership_Vehicles";
}] call compile_Server;
