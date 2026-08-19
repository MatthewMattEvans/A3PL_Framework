/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["Server_Chopshop_Chop", {
	params [
		["_veh",objNull,[objNull]],
		["_player",objNull,[objNull]]
	];

	if (isNull _veh) exitwith {};
	private _vehMSRP = [typeOf _veh] call A3PL_Config_GetVehicleMSRP;
	if ((typeof _veh IN (Config_FISD_Vehs + Config_FIFR_Vehs)) || (typeOf _veh IN ["Heli_Medium01_Coastguard_H","A3PL_Jayhawk","A3PL_Goose_USCG","A3FL_AS_365"])) then {_vehMSRP = _vehMSRP * 2};
	private _charID = (_player getVariable ["character_id",""]);
	private _pUID = getPlayerUID _player;
	private _vehinfo = _veh getVariable "owner";
	private _vehOwnerUID = [format ["SELECT uid FROM players WHERE charid='%1'",_vehinfo#0],2] call Server_Database_Async;
	if (_charID == _vehinfo#0) exitWith {[_pUID,_charID,"Vehicle_Scrap_Exploit",[format ["Vehicle: %1 | Plate: %2",(typeOf _veh),_vehinfo#1]]] call Server_Log_New; [format [("STR_Server_ChopShop_ExploitNotAllowed" call A3PL_Localize), _player getVariable "name"], Color_Red] remoteExec ["A3PL_Notification",_player];};
	private _amount = if (_vehMSRP < 150000) then {(_vehMSRP * 0.1) * A3PL_Event_CrimePayout} else {(_vehMSRP * 0.08) * A3PL_Event_CrimePayout};
	[_player, 'Player_Cash', ((_player getVariable 'Player_Cash') + _amount)] remoteExec ["Server_Core_ChangeVar",2];
	[format[("STR_Server_ChopShop_YouReceivedMoney" call A3PL_Localize),_amount], Color_Green] remoteExec ["A3PL_Notification",_player];

	private _var = _veh getVariable ["owner",nil];
	private _isInsured = _veh getVariable ["insurance",false];
	private _id = _var select 1;
	private _stockobj = _veh getVariable ["stockobj",nil];
	if (!isNil "_var") then {
		[_vehOwnerUID,_vehinfo#0,"Vehicle_Scrapped",[format ["Vehicle: %1 | Plate: %2 | Insured: %3 | Scrapped By: %4 (%5)",(typeOf _veh),_vehinfo#1,_isInsured,_charID,_pUID]]] call Server_Log_New;
		[_pUID,_charID,"Vehicle_Scrap",[format ["Vehicle: %1 | Plate: %2 | Insured: %3 | Owned By: %4 | Cost: %5",(typeOf _veh),_vehinfo#1,_isInsured,_vehinfo#0,_amount]]] call Server_Log_New;
		if(_isInsured) then {
			private _query = format ["UPDATE players_objects SET plystorage = '1',impounded='2',spawn='0' WHERE id = '%1'",_id];
			[_query,1] spawn Server_Database_Async;
		} else {
			if !(isNil "_stockobj") then {
				private _vehicles = [format ["SELECT vehicles FROM stock WHERE classname='%1'",_stockobj], 2,true] call Server_Database_Async;
				_vehicles = _vehicles#0#0;
				private _vehicle = "";
				private _index = -1;
				{
					_index = _index + 1;
					private _vars = _x#6;
					private _selplate = "";
					{
						if (_x#0 isEqualTo "plate") then {
							_selplate = _x#1;
						};
					} forEach _vars;

					if (_selplate isEqualTo _vehinfo#1) exitWith {
						_vehicle = _x;
					};
				} forEach _vehicles;

				_vehicle set [1,1];
				_vehicles set [_index,_vehicle];

				[_veh] call Server_Vehicle_Sell;
				["vehicles",_vehicles,_stockobj] call Server_Stock_UpdateItems;
			} else {
				private _query = format ["DELETE FROM players_objects WHERE id = '%1'",_id];
				[_query,1] spawn Server_Database_Async;
			};
		};
	};
	[_veh] call Server_Vehicle_Despawn;
}] call compile_Server;
