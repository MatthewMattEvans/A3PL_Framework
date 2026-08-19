/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["Server_Lumber_TreeRespawn",
{
	private _treeCount = count(nearestObjects [(getMarkerPos "LumberJack_Rectangle"), ["Land_A3PL_Tree3"],190]);
	for "_i" from 1 to (50 - _treeCount) do {
		private _randPos = ["LumberJack_Rectangle"] call CBA_fnc_randPosArea;
		private _tree = createVehicle ["Land_A3PL_Tree3", _randPos, [], 0, "CAN_COLLIDE"];
		_tree setDir (random 360);
	};
}] call compile_Server;
