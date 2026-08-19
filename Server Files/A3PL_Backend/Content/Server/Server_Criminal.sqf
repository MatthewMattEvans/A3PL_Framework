/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["Server_Criminal_RemoveJail", {
	params [["_player",objNull,[objNull]]];

	private _query = format ["UPDATE players SET jail='0' WHERE charid = '%1'", (_player getVariable ["character_id",""])];
	private _return = [_query, 1] call Server_Database_Async;
	{
		if((_x select 0) isEqualTo _player) exitwith {
			Server_Jailed_Players deleteAt _forEachIndex;
		};
	} foreach Server_Jailed_Players;
}] call compile_Server;

["Server_Criminal_TurtlesMove", {
	private _markerArea = "A3PL_Marker_Fish5";
	private _markerLabel = "marker_illegal_turtles";
	private _locations = [[6878,12890],[1406,2095],[7326,3808],[1421,13334]];
	private _currentLocation = missionNamespace getVariable ["TurtleAreaLocation",0];
	private _nextLocation = selectRandom _locations;
	if((_nextLocation find _locations) isEqualTo _currentLocation) exitWith {[] spawn Server_Criminal_TurtlesMove;};
	_markerArea setMarkerPos _nextLocation;
	_markerLabel setMarkerPos _nextLocation;
	missionNamespace setVariable ["TurtleAreaLocation",(_locations find _nextLocation)];
	//[] remoteExec["A3PL_Player_SetMarkers",-2];
}] call compile_Server;

["Server_Criminal_MoveNPCs", {
	private _npcs = [npc_ill_trader,npc_ill_moonshine,npc_ill_cocaine,npc_ill_shrooms,npc_ill_weed];
	private _usedHideout = [];
	{
		private _selectedHideout = selectRandom IllegalNPC_Hideout;
		while{(_selectedHideout#0) IN _usedHideout} do {
			_selectedHideout = selectRandom IllegalNPC_Hideout;
		};
		_usedHideout pushback (_selectedHideout#0);
		_newPosition = selectRandom (_selectedHideout#1);
		_x setPosASL [_newPosition#0,_newPosition#1,_newPosition#2];
		_x setDir (_newPosition#3);
	} foreach _npcs;
}] call compile_Server;

["Server_Criminal_IllPlate", {
	params [
		["_veh",objNull,[objNull]],
		["_player",objNull,[objNull]]
	];

	private _platesArray = [format["SELECT o.id FROM players_objects o, players p WHERE p.charid <> '%1' AND o.charid = p.charid AND p.lastseen + INTERVAL 20 DAY > NOW() LIMIT 150",(_player getVariable ["character_id",""])], 2, true] call Server_Database_Async;
	private _newLP = (selectRandom _platesArray)#0;
	private _playerCash = _player getVariable ["player_cash",0];

	if(_playerCash < 25000) exitWith {[("STR_Server_Criminal_NotEnoughMoney" call A3PL_Localize),Color_Red] remoteExec["A3PL_Notification",_player];};

	[_newLP,_veh] call Server_Vehicle_Init_SetLicensePlate;
	_veh setVariable ["numPChange",1,true];
	_veh setVariable ["isCustomPlate",1,true];
	_veh setVariable ["isFakePlate",true,true];

	_player setVariable ["player_cash",_playerCash - 25000,true];
	[("STR_Server_Criminal_FakePlateInstalled" call A3PL_Localize),Color_Green] remoteExec["A3PL_Notification",_player];
}] call compile_Server;

["Server_Criminal_initNPCs", {
	{
		private _posArray = (_x#1);
		private _npc = call compile format["%1", (_x#0)];
		_npc setPosASL [_posArray#0, _posArray#1, _posArray#2];
		_npc setDir _posArray#3;

		{
			_x setMarkerPos [_posArray#1, _posArray#2];
		}forEach (_x#2);
	}forEach IllegalNPC;
}] call compile_Server;