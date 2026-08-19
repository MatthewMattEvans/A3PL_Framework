/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
#define COMPANYSHOPS_BUILDINGS ["Land_A3PL_Kainnon_DMV","Land_Shop_DED_Shop_01_F","Land_Shop_DED_Shop_02_F","Land_buildingGunStore1","Land_buildingsNightclub2","Land_A3PL_Cinema","Land_A3FL_Anton_Store","Land_A3PL_Garage","land_smallshop_ded_smallshop_02_f","land_smallshop_ded_smallshop_01_f","Land_A3FL_Brick_Shop_1","Land_A3FL_Brick_Shop_2","Land_A3PL_Showroom","Land_A3PL_Gas_Station","Land_A3FL_Airport_Hangar","Land_EC_CompanyStore","Land_A3FL_Anton_Store_Interior"]

["Server_CompanyShop_Update", {
	params [
		["_shop",objNull,[objNull]],
		["_stock",[],[[]]],
		["_mode",0,[0]]
	];

	private _var = "stock_selling";
	if (_mode isEqualTo 1) then {
		_var = "stock_buying";
	};
	_shop setVariable [_var,_stock,true];
	_stock = [_stock] call Server_Database_Array;
	_query = format ["UPDATE companies_shops SET %3='%2' WHERE location ='%1'", (getpos _shop), _stock, _var];
	[_query,1] call Server_Database_Async;
}] call compile_Server;

["Server_CompanyShop_InsertLog",{
	params [
		["_cid",0],
		["_location",[]],
		["_object",""],
		["_amount",0],
		["_price",""],
		["_type","item"]
	];
	
	[format ["INSERT INTO logs_companyshops (cid, location, object, amount, price, type) VALUES ('%1','%2','%3','%4','%5','%6')",_cid, _location, _object, _amount, _price, _type],1] spawn Server_Database_Async;
}] call compile_Server;

["Server_CompanyShop_GetLogs",{
	private _cid = param [0,objNull];
	private _pos = param [1,objNull];
	private _player = param [2,false];

	private _result = [format ["SELECT cid, location, object, amount, price, type, time FROM logs_companyshops WHERE location='%1' AND cid='%2'", _pos, _cid], 2, true] call Server_Database_Async;
	
	A3PL_LogsResponse = _result;
	A3PL_Responded = true;
	(owner _player) publicVariableClient "A3PL_Responded";
	(owner _player) publicVariableClient "A3PL_LogsResponse";
}] call compile_Server;