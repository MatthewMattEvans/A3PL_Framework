/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["Server_ShopStock_Load",
{
	private _stocks = ["SELECT object,stock FROM shops ORDER BY id ASC", 2, true] call Server_Database_Async;
	{
		private _object = call compile (_x select 0);
		private _stock = call compile (_x select 1);
		_object setVariable ["stock",_stock,true];
	} foreach _stocks;
}] call compile_Server;

["Server_ShopStock_Save",
{
	{
		private _query = format ["UPDATE shops SET stock = '%1' WHERE object = '%2'",(_x getVariable ["stock",[]]),_x];
		[_query,1] spawn Server_Database_Async;
	} foreach Server_Shopstocks;
}] call compile_Server;
