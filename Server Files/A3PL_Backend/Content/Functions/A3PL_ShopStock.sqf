/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_ShopStock_Add",
{
	private ["_shop","_index","_stockVar","_amount","_newStock"];
	_shop = param [0,objNull];
	_index = param [1,0];
	_amount = param [2,1];
	
	_stockVar = _shop getVariable ["stock",[]];
	
	//see what the new value would be, DO NOT GO ABOVE 500 STOCK!!!
	_newStock = (_stockVar select _index)+_amount;
	if (_newStock >= Shops_Max_Stock) then {_newStock = Shops_Max_Stock;};
	
	//set the new stock variable
	_stockVar set [_index,_newStock];
	_shop setVariable ["stock",_stockVar,true];
}] call compile_Global;

["A3PL_ShopStock_Decrease",
{
	private ["_shop","_index","_stockVar","_amount"];
	_shop = param [0,objNull];
	_index = param [1,0];
	_amount = param [2,1];
	
	_stockVar = _shop getVariable ["stock",[]];
	_stockVar set [_index,(_stockVar select _index)-_amount];
	_shop setVariable ["stock",_stockVar,true];
}] call compile_Global;
