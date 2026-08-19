/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["Server_Business_Buy", {
	params [
		["_player",objNull,[objNull]],
		["_business",objNull,[objNull]],
		["_name","",[""]],
		["_rentTime",1,[1]],
		["_rentCost",1,[1]],
		["_sign",objNull,[objNull]]
	];

	private _charID = (_player getVariable ["character_id",""]);
	if (isNull _player || {isNull _business}) exitwith {};
	_rentTime = _rentTime * 60;
	A3PL_Business_List = missionNameSpace getVariable ["A3PL_Business_List",[]];

	{
		if (_x#0 isEqualTo _business) exitwith {_taken = true};
		if (_x#1 isEqualTo _charID) exitwith {_taken = true};
	} foreach A3PL_Business_List;
	if (!isNil "_taken") exitwith {};

	private _cid = [_charID] call A3PL_Config_GetCompanyID;
	[_cid, -_rentcost, ""] remoteExec ["Server_Company_SetBank",2];
	[("STR_Common_FederalReserve" call A3PL_Localize),_rentcost] remoteExec ["Server_Government_AddBalance",2];

	private _marker = createMarker [format ["business%1",floor random 3000], _business];
	_marker setMarkerShape "ICON";
	_marker setMarkerType "A3FL_Markers_CompanyShop";
	_marker setMarkerText _name;

	A3PL_Business_List pushback [_business,_charID,diag_tickTime + _rentTime,_marker];
	_business setVariable ["bOwner",_charID,true];
	_business setVariable ["bName",_name,true];

	if (!isNull _sign) then {
		_sign setObjectTextureGlobal [0,"\A3PL_Objects\Street\business_sign\business_rented_co.paa"];
	};

	if ((_player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) isNotEqualTo ("STR_Common_Company" call A3PL_Localize)) then {[_player,("STR_Common_Company" call A3PL_Localize)] call Server_NPC_RequestJob;};
}] call compile_Server;

["Server_Business_Loop", {
	{
		private _business = _x#0;
		private _player = [_x#1] call A3PL_Lib_charIDToObject;
		if ((isNull _player) || {diag_tickTime > _x#2}) then {
			deleteMarker (_x#3);
			if((_player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) isEqualTo "business") then {[_player,("STR_Common_Job_Unemployed" call A3PL_Localize)] call Server_NPC_RequestJob;};
			_business setVariable ["bOwner",nil,true];
			_business setVariable ["bName",nil,true];
			private _signs = nearestObjects [_business, ["Land_A3PL_BusinessSign"], 20,true];
			if (count _signs > 0) then {
				_signs#0 setObjectTextureGlobal [0,"\A3PL_Objects\Street\business_sign\business_sale_co.paa"];
			};
			A3PL_Business_List deleteAt _forEachIndex;
		};
	} foreach (missionNameSpace getVariable ["A3PL_Business_List",[]]);
}] call compile_Server;

["Server_Business_Sellitem", {
	params [
		["_player",objNull,[objNull]],
		["_obj",objNull,[objNull]],
		["_name","",[""]],
		["_price",0,[0]]
	];

	if ((isNull _player) || {isNull _obj}) exitwith {};
	private _charID = _player getVariable["character_id",""];
	_obj setVariable ["bItem",[_price,_name,_charID],true];
}] call compile_Server;

["Server_Business_BuyItem", {
	params [
		["_buyer",objNull,[objNull]],
		["_obj",objNull,[objNull]]
	];

	private _buyercharID = _buyer getVariable["character_id",""];
	private _bItem = _obj getVariable ["bItem",nil];
	if (isNil "_bItem") exitwith {};
	private _price = _bItem select 0;
	private _ownercharID = _bItem select 2;
	private _ownerUID = ([format["SELECT uid FROM players WHERE charid = '%1'",_ownercharID],2] call Server_Database_Async)#0;
	private _ownerObj = [_ownercharID] call A3PL_Lib_charIDToObject;
	switch (true) do {
		case ((_obj isKindOf "car") || {_obj isKindOf "tank"} || {_obj isKindOf "plane"} || {_obj isKindOf "air"} || {_obj isKindOf "ship"} || (typeOf _obj IN ["A3FL_PalletLifter","A3FL_TransportContainer"])): {
			private _id = _obj getVariable ["owner",nil];
			private _isCustomPlate = _obj getVariable ["isCustomPlate",0];
			if (isNil "_id") exitwith {};
			private _id = _id select 1;
			if(_isCustomPlate isEqualTo 1) then {
				private _newID = [7] call Server_Housing_GenerateID;
				private _query = format ["UPDATE players_objects SET charid='%1', cid='0' WHERE id='%2'",_buyercharID,_id];
				[_query,1] spawn Server_Database_Async;
				private _query2 = format ["UPDATE players_objects SET id = '%2',numpchange='0',iscustomplate='0' WHERE id = '%1'",_id,_newID];
				[_query2,1] spawn Server_Database_Async;
				_obj setVariable ["owner",[_buyercharID,_newID],true];
				[_newID,_obj] call Server_Vehicle_Init_SetLicensePlate;
			} else {
				private _query = format ["UPDATE players_objects SET charid='%1', cid='0' WHERE id='%2'",_buyercharID,_id];
				_obj setVariable ["owner",[_buyercharID,_id],true];
				[_query,1] spawn Server_Database_Async;
			};
			[_obj] remoteExec ["A3PL_Vehicle_AddKey",_buyer];
			if !(isNull _ownerObj) then {[_obj,false] remoteExec ["A3PL_Vehicle_AddKey",_ownerObj]};
		};
		case (_obj isKindOf "Thing"): {
			_obj setVariable ["owner",_buyercharID,true];
		};
		case (!isNil {_obj getVariable ["class",nil]}): {
			_obj setVariable ["owner",[_id,_buyercharID],true];
		};
		default {
			_obj setVariable ["owner",_buyercharID,true];
		};
	};
	_obj setVariable ["bItem",nil,true];

	if (!isNil "_ownercharID") then {
		private _cid = [_ownercharID] call A3PL_Config_GetCompanyID;
		if (_cid isNotEqualTo 0) then {
			[_cid, _price, ""] remoteExec ["Server_Company_SetBank",2];
			if (!isNull _ownerObj) then { [0,_price] remoteExec ["A3PL_Business_BuyItemReceive",(owner _ownerObj)]; };
		} else {
			if (!isNull _ownerObj) then {
				private _bank = _ownerObj getVariable "player_bank";
				_ownerObj setVariable ["player_bank",_bank + _price, true];
			} else {
				private _query = format["SELECT bank FROM players WHERE charid = '%1'",_ownercharID];
				private _bank = ([_query, 2] call Server_Database_Async)#0;
				[format["UPDATE players SET bank='%1' WHERE charid ='%2'",_bank + _price, _ownercharID], 1] call Server_Database_Async;
			};
		};
	};
	[1] remoteExec ["A3PL_Business_BuyItemReceive",(owner _buyer)];
	[getPlayerUID _buyer,_buyercharID,"Shop_Rented_ItemBought",[format ["Item: %1 | Price: %2 | Bought From: %3",(typeOf _obj),_price,_ownercharID]]] call Server_Log_New;
	[_ownerUID,_ownercharID,"Shop_Rented_ItemSold",[format ["Item: %1 | Price: %2 | Sold To: %3",(typeOf _obj),_price, _buyercharID]]] call Server_Log_New;
}] call compile_Server;

["Server_Business_CheckRentTime", {
	params [
		["_businessObj",objNull,[objNull]],
		["_player",objNull,[objNull]]
	];

	private _businessList = missionNameSpace getVariable ["A3PL_Business_List",[]];
	private _businessToCheck = [];
	{
		[str (_x#0),Color_Blue] remoteExec ["A3PL_Notification",_player];
		[str _businessObj,Color_Blue] remoteExec ["A3PL_Notification",_player];
		if(str (_x#0) isEqualTo (str _buisinessObj)) then {["found",Color_Green] remoteExec ["A3PL_Notification",_player]; _businessToCheck = _x;};
	} foreach _businessList;
	if(_businessToCheck isEqualTo []) exitwith {};
	private _rentTime = (_businessList#_businessToCheck)#2;
	private _remainingTime = diag_tickTime - _rentTime;
	[format[("STR_Server_Business_TimeRemaining" call A3PL_Localize),str _remainingTime],Color_Blue] remoteExec ["A3PL_Notification",_player];
}] call compile_Server;
