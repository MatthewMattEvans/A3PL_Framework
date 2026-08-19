/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3FL_Christmas_GetGift",
{
	if (Christmas) then {
        private _tree = param[0,objNull];
    	if(isNull _tree) exitWith {};
    	private _treeID = ((netId _tree) splitString ":") select 1;
    	private _usedList = missionNameSpace getVariable["ChristmasGifts",[]];
    	private _relate = format["%1_%2",_treeID,(player getVariable ["character_id",""])];
    	if(_relate IN _usedList) exitWith {[("STR_A3PL_Christmas_GiftAlreadyReceived" call A3PL_Localize),Color_Red] call A3PL_Notification;};

    	_usedList pushback _relate;
    	missionNameSpace setVariable["ChristmasGifts",_usedList,true];

    	["gift",Christmas_Gift] call A3PL_Inventory_Add;
		["christmas"] call PO_Achievement_Learn;
    	[format[("STR_A3PL_Christmas_GiftReceived" call A3PL_Localize),Christmas_Gift],Color_Green] call A3PL_Notification;
    };
}] call compile_Global;

["A3FL_Christmas_CandyTrade",
{
    if (Christmas) then {
    	private _candyAmount = ["candy"] call A3PL_Inventory_Return;
    	private _tradeValue = floor(_candyAmount/Christmas_Trade);
    	if (_candyAmount < Christmas_Trade) exitwith {[format[("STR_A3PL_Christmas_CandyTradeNeeded" call A3PL_Localize),Christmas_Trade],Color_Red] call A3PL_Notification;};
    	private _action = [format[("STR_A3PL_Christmas_CandyTradeMessage" call A3PL_Localize), _candyAmount, _tradeValue, Christmas_Trade]] call A3PL_Lib_ConfirmationDialog;
    	if (!isNil "_action" && {!_action}) exitWith {[("STR_A3PL_Christmas_CandyTradeCanceled" call A3PL_Localize),Color_Red] call A3PL_Notification;};
    	["candy", -(_tradeValue*Christmas_Trade)] call A3PL_Inventory_Add;
    	["gift", _tradeValue] call A3PL_Inventory_Add;
		["ratz"] call PO_Achievement_Learn;
    };
}] call compile_Global;

["A3FL_Christmas_Mapping",
{
    if (Christmas) then {	
		params [["_layerWhiteList",[],[[]]],["_layerBlacklist",[],[[]]],["_posCenter",[0,0,0],[[]]],["_dir",0,[0]],["_idBlacklist",[],[[]]]];
		private _allWhitelisted = _layerWhiteList isEqualTo [];
		private _layerRoot = (_allWhitelisted || {true in _layerWhiteList}) && {!(true in _layerBlackList)};
		private _objects = [];
		private _objectIDs = [];

		npc_christmas setPos [6660.734,7511.899,0];
		npc_christmas setDir 273.854;
		private _marker = createMarkerLocal ["marker_christmas_npc", getPos(npc_christmas)];
		_marker setMarkerShapeLocal "ICON";
		_marker setMarkerSizeLocal [0.6,0.6];
		_marker setMarkerTypeLocal "A3FL_Markers_Cemetary";
		_marker setMarkerTextLocal ("STR_A3PL_Christmas_ShopMarker" call A3PL_Localize);

		private _item2 = objNull;
		if (_layerRoot) then {
			_item2 = createVehicle ["A3FL_Christmas_Tree",[6536.02,7570.41,0.147426],[],0,"CAN_COLLIDE"];
			_this = _item2;
			_objects pushback _this;
			_objectIDs pushback 4564561230460456;
			_this setPosWorld [6536.02,7570.41,8.91986];
			_this setVectorDirAndUp [[0.172621,0.984988,0],[0,0,1]];
		};

		private _item4 = objNull;
		if (_layerRoot) then {
			_item4 = createVehicle ["A3FL_Christmas_Tree",[10220.9,8543.2,0.0123487],[],0,"CAN_COLLIDE"];
			_this = _item4;
			_objects pushback _this;
			_objectIDs pushback 1305604604;
			_this setPosWorld [10220.9,8543.2,6.33347];
			_this setVectorDirAndUp [[-0.00520829,0.999986,0],[0,0,1]];
		};

		private _item5 = objNull;
		if (_layerRoot) then {
			_item5 = createVehicle ["A3FL_Christmas_Tree",[2685.92,5504.62,0.0137224],[],0,"CAN_COLLIDE"];
			_this = _item5;
			_objects pushback _this;
			_objectIDs pushback 45678964562;
			_this setPosWorld [2685.92,5504.62,8.73187];
			_this setVectorDirAndUp [[0.804495,-0.593959,0],[0,0,1]];
		};

		private _item6 = objNull;
		if (_layerRoot) then {
			_item6 = createVehicle ["A3FL_Christmas_Tree",[3425.3,7488.78,0.0211468],[],0,"CAN_COLLIDE"];
			_this = _item6;
			_objects pushback _this;
			_objectIDs pushback 7894565464213;
			_this setPosWorld [3425.3,7488.78,4.43052];
			_this setVectorDirAndUp [[0.986642,-0.162902,0],[0,0,1]];
		};

		private _item7 = objNull;
		if (_layerRoot) then {
			_item7 = createVehicle ["A3FL_Christmas_Tree",[8773.77,6407.02,0.100156],[],0,"CAN_COLLIDE"];
			_this = _item7;
			_objects pushback _this;
			_objectIDs pushback 879456213;
			_this setPosWorld [8773.77,6407.02,7.20128];
			_this setVectorDirAndUp [[-0.999999,0.00134088,0],[0,0,1]];
		};

		private _item8 = objNull;
		if (_layerRoot) then {
			_item8 = createVehicle ["A3FL_Christmas_Tree",[4765.56,6158.48,0.000695467],[],0,"CAN_COLLIDE"];
			_this = _item8;
			_objects pushback _this;
			_objectIDs pushback 7894364332;
			_this setPosWorld [4765.56,6158.48,3.78182];
			_this setVectorDirAndUp [[-0.946584,0.322457,0],[0,0,1]];
		};

		private _item23 = objNull;
		if (_layerRoot) then {
			_item23 = createVehicle ["A3FL_ice",[10214.1,8621.38,0.274175],[],0,"CAN_COLLIDE"];
			_this = _item23;
			_objects pushback _this;
			_objectIDs pushback 135645456;
			_this setPosWorld [10214.1,8621.38,-0.466212];
			_this setVectorDirAndUp [[0.997598,0.0692715,0],[0,0,1]];
		};

		private _item24 = objNull;
		if (_layerRoot) then {
			_item24 = createVehicle ["A3FL_ice",[10211.3,8661.27,0.688711],[],0,"CAN_COLLIDE"];
			_this = _item24;
			_objects pushback _this;
			_objectIDs pushback 123123546456;
			_this setPosWorld [10211.3,8661.27,-0.466212];
			_this setVectorDirAndUp [[0.997598,0.0692715,0],[0,0,1]];
		};

		private _item25 = objNull;
		if (_layerRoot) then {
			_item25 = createVehicle ["A3FL_ice",[10173.9,8626.14,2.16212],[],0,"CAN_COLLIDE"];
			_this = _item25;
			_objects pushback _this;
			_objectIDs pushback 456456456;
			_this setPosWorld [10173.9,8626.14,-0.466212];
			_this setVectorDirAndUp [[0.997598,0.0692715,0],[0,0,1]];
		};

		private _item26 = objNull;
		if (_layerRoot) then {
			_item26 = createVehicle ["A3FL_ice",[10171.1,8666,3.46084],[],0,"CAN_COLLIDE"];
			_this = _item26;
			_objects pushback _this;
			_objectIDs pushback 45645645646;
			_this setPosWorld [10171.1,8666,-0.466212];
			_this setVectorDirAndUp [[0.997598,0.0692715,0],[0,0,1]];
		};

		private _item27 = objNull;
		if (_layerRoot) then {
			_item27 = createVehicle ["A3FL_ice",[10134.3,8623.8,2.18323],[],0,"CAN_COLLIDE"];
			_this = _item27;
			_objects pushback _this;
			_objectIDs pushback 123123132456;
			_this setPosWorld [10134.3,8623.8,-0.466212];
			_this setVectorDirAndUp [[0.997598,0.0692715,0],[0,0,1]];
		};

		private _item28 = objNull;
		if (_layerRoot) then {
			_item28 = createVehicle ["A3FL_ice",[10131.6,8663.66,4.21691],[],0,"CAN_COLLIDE"];
			_this = _item28;
			_objects pushback _this;
			_objectIDs pushback 5644564654213456;
			_this setPosWorld [10131.6,8663.66,-0.466212];
			_this setVectorDirAndUp [[0.997598,0.0692715,0],[0,0,1]];
		};

		private _item29 = objNull;
		if (_layerRoot) then {
			_item29 = createVehicle ["A3FL_ice",[10091.8,8664.21,2.83708],[],0,"CAN_COLLIDE"];
			_this = _item29;
			_objects pushback _this;
			_objectIDs pushback 98776456453;
			_this setPosWorld [10091.8,8664.21,-0.466212];
			_this setVectorDirAndUp [[0.997598,0.0692715,0],[0,0,1]];
		};

		private _item30 = objNull;
		if (_layerRoot) then {
			_item30 = createVehicle ["A3FL_ice",[10094.6,8624.35,2.44016],[],0,"CAN_COLLIDE"];
			_this = _item30;
			_objects pushback _this;
			_objectIDs pushback 6879318793217;
			_this setPosWorld [10094.6,8624.35,-0.466212];
			_this setVectorDirAndUp [[0.997598,0.0692715,0],[0,0,1]];
		};

		private _item31 = objNull;
		if (_layerRoot) then {
			_item31 = createVehicle ["A3FL_ice",[10052.9,8664.48,2.06396],[],0,"CAN_COLLIDE"];
			_this = _item31;
			_objects pushback _this;
			_objectIDs pushback 31132456546456;
			_this setPosWorld [10052.9,8664.48,-0.466212];
			_this setVectorDirAndUp [[0.997598,0.0692715,0],[0,0,1]];
		};

		private _item32 = objNull;
		if (_layerRoot) then {
			_item32 = createVehicle ["A3FL_ice",[10057.1,8626.19,0],[],0,"CAN_COLLIDE"];
			_this = _item32;
			_objects pushback _this;
			_objectIDs pushback 3574865132146546;
			_this setPosWorld [10057.1,8626.19,-0.46237];
			_this setVectorDirAndUp [[0.997598,0.0692715,0],[0,0,1]];
		};

		Christmas_Mapping_Spawned = true;
    };
}] call compile_Global;