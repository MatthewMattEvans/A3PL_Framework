/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
// Get road segment : diag_log str(ASLToAGL getPosASL player);
//hint str(player_objintersect getVariable["Building_Address","zizi"]);
["Server_Addresses_Setup", {
	// Récupération des villes depuis la base de données
	private _citiesQuery = "SELECT pos_x, pos_y, pos_z, radius, name FROM addresses WHERE type = 'city'";
	private _citiesResult = [_citiesQuery, 2, true] call Server_Database_Async;
	
	Server_Addresses_Cities = [];
	{
		private _pos = [_x#0, _x#1, _x#2];
		private _radius = _x#3;
		private _name = _x#4;
		Server_Addresses_Cities pushBack [_pos, _radius, _name];
	} forEach _citiesResult;
	
	// Récupération des routes depuis la base de données
	private _roadsQuery = "SELECT start_x, start_y, start_z, end_x, end_y, end_z, name FROM addresses WHERE type = 'road'";
	private _roadsResult = [_roadsQuery, 2, true] call Server_Database_Async;
	
	private _Server_Roads_Data = [];
	{
		private _startPos = [_x#0, _x#1, _x#2];
		private _endPos = [_x#3, _x#4, _x#5];
		private _name = _x#6;
		_Server_Roads_Data pushBack [_startPos, _endPos, _name];
	} forEach _roadsResult;

	Server_Addresses_Roads = [];
	{
		private _a = _x#0;
		private _b = _x#1;
		private _name = _x#2;
		private _roadObject = roadAt _a;
		if(!isNull _roadObject) then {
			private _aID = parseNumber ((str (_roadObject) splitString ":")#0);
			private _roadObject = roadAt _b;
			if(!isNull _roadObject) then {
				private _bID = parseNumber ((str(_roadObject) splitString ":")#0);
				Server_Addresses_Roads pushBack [_aID,_bID,_name];
			} else {
				diag_log format["Server_Addresses_Setup: Impossible de trouver la route à la position %1", _b];
			}
		} else {
			diag_log format["Server_Addresses_Setup: Impossible de trouver la route à la position %1", _a];
		};
	} forEach _Server_Roads_Data;
	publicVariable "Server_Addresses_Roads";

	private _buildingsArray = ["land_market_ded_market_05_f","Land_A3FL_Anton_Store","Land_A3FL_Anton_Store_Interior","Land_A3FL_Anton_Store_Clothing","Land_A3FL_Fishers_Barbershop","Land_A3FL_Better_Buy","Land_A3FL_DOC_Gate","Land_A3FL_Fishers_Jewelry","Land_A3PL_Motel","Land_A3PL_Showroom","Land_A3PL_Bank","Land_A3PL_Capital","Land_A3PL_Sheriffpd","Land_A3FL_SheriffPD","Land_Shop_DED_Shop_01_F","land_smallshop_ded_smallshop_01_f","land_market_ded_market_01_f","land_market_ded_market_01_SEP","Land_Taco_DED_Taco_01_F","Land_A3PL_Gas_Station","Land_A3PL_Garage","Land_John_Hangar","Land_A3PL_CG_Station","land_a3pl_ch","Land_A3PL_Clinic","Land_A3PL_Firestation","Land_FYD_Firestation","Land_Home1g_DED_Home1g_01_F","Land_Home2b_DED_Home2b_01_F","Land_Home3r_DED_Home3r_01_F","Land_Home4w_DED_Home4w_01_F","Land_Home5y_DED_Home5y_01_F","Land_Home6b_DED_Home6b_01_F","Land_Mansion01","Land_A3PL_Ranch3","Land_A3PL_Ranch2","Land_A3PL_Ranch1","Land_A3PL_ModernHouse1","Land_A3PL_ModernHouse2","Land_A3PL_ModernHouse3","Land_A3PL_BostonHouse","Land_A3PL_Shed3","Land_A3PL_Shed4","Land_A3PL_Shed2","Land_John_House_Grey","Land_John_House_Blue","Land_John_House_Red","Land_John_House_Green","Land_A3FL_Warehouse","Land_A3FL_Airport_Terminal","Land_A3FL_Barn","Land_A3FL_Brick_Shop_1","Land_A3FL_Brick_Shop_2","Land_A3FL_Office_Building","Land_A3FL_Mansion","Land_A3FL_House1_Cream","Land_A3FL_House1_Green","Land_A3FL_House1_Blue","Land_A3FL_House1_Brown","Land_A3FL_House1_Yellow","Land_A3FL_House2_Cream","Land_A3FL_House2_Green","Land_A3FL_House2_Blue","Land_A3FL_House2_Brown","Land_A3FL_House2_Yellow","Land_A3FL_House3_Cream","Land_A3FL_House3_Green","Land_A3FL_House3_Blue","Land_A3FL_House3_Brown","Land_A3FL_House3_Yellow","Land_A3FL_House4_Cream","Land_A3FL_House4_Green","Land_A3FL_House4_Blue","Land_A3FL_House4_Brown","Land_A3FL_House4_Yellow","Land_A3FL_Anton_Modern_Bungalow","Land_A3FL_Trailer","Land_A3FL_Trailer_2","Land_A3FL_Trailer_3","Land_A3FL_Trailer_4","Land_A3FL_Trailer_5","Land_A3FL_Trailer_6","Land_A3FL_Crackhouse","Land_FYD_PARRAS_BigModernHouse","Land_FYD_Parras_Modern_House","Land_FYD_Parras_Modern_House_02","Land_FYD_Parras_Modern_House_03","Land_FYD_Parras_Modern_House_04","Land_EC_SheriffHQ"];
	private _buildings = nearestObjects [[worldSize/2,worldSize/2,0],_buildingsArray, 500000];
	{
		private _number = [_x,"number"] call Server_Addresses_GetAddress;
		private _road = [_x,"road"] call Server_Addresses_GetAddress;
		private _city = [_x,"city"] call Server_Addresses_GetAddress;
		private _address = format["%1 %2, %3", _number, _road, _city];
		_x setVariable["Building_Address",_address,true];
	} forEach _buildings;
}] call compile_Server;

["Server_Addresses_GetAddress", {
	params [
		["_building",objNull,[objNull]],
		["_search","",[""]]
	];

	private _return = "";
	if (_search isEqualTo "number") then {
		private _foundHash = false;
		private _foundColon = false;
		private _objectID = [];
		private _characterArray = toArray(str _building);
		{
			if (_x == 58) then {
				_foundColon = true;
			};
			if (_foundHash && (_x != 32) && !_foundColon) then {
				_objectID = _objectID + [_x];
			};
			if (_x == 35) then {
				_foundHash = true;
			};
		} forEach _characterArray;
		_return = format["%1%2",_objectID#0,_objectID#1,_objectID#2];
		_return = parseNumber(_return);
	};
	if (_search isEqualTo "road") then {
		private _road = ("STR_Common_UnknownAddress" call A3PL_Localize);
		private _nearestRoad = _building nearRoads 250;
		if(count(_nearestRoad) isEqualTo 0) exitWith {_road;};
		_nearestRoad = _nearestRoad#((count _nearestRoad)-1);
		private _roadObject = str(_nearestRoad);
		private _roadID = parseNumber((_roadObject splitString ":")#0);
		if(isNil "_roadID") exitWith {_road;};
		{
			private _a = _x#0;
			private _b = _x#1;
			if(_a < _b) then {
				if((_roadID >= _a) && {_roadID <= _b}) exitWith {
					_road = _x#2;
				};
			} else {
				if((_roadID >= _b) && {_roadID <= _a}) exitWith {
					_road = _x#2;
				};
			};
		} forEach Server_Addresses_Roads;
		_return = _road;
	};
	if (_search isEqualTo "city") then {
		private _city = "Suffolk County";
		{
			if(_building distance (_x#0) < (_x#1)) exitWith {_city = _x#2;};
		} forEach Server_Addresses_Cities;
		_return = _city;
	};
	_return;
}] call compile_Server;
