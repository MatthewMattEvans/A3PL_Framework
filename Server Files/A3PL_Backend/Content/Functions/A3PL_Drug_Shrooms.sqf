/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Shrooms_Pick",
{
	private _isPlanting = player getVariable["isPlanting",false];
	private _isHanging = player getVariable["isHanging",false];

	params[["_shroom",objNull]];
	if(_shroom getVariable["inUse",false]) exitWith {[("STR_A3PL_Shrooms_ShroomInUse" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_shroom setVariable["inUse",true,true];
	if (Player_ActionDoing) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[("STR_A3PL_Shrooms_Gathering" call A3PL_Localize),Shrooms_Gather_Timer] spawn A3PL_Lib_LoadAction;
	waitUntil{Player_ActionDoing};
	while {Player_ActionDoing} do {
		if !(player getVariable["A3PL_Medical_Alive",true]) exitWith {Player_ActionInterrupted = true;};
		if ((vehicle player) isNotEqualTo player) exitWith {Player_ActionInterrupted = true;};
		if (player getVariable ["Incapacitated",false]) exitwith {Player_ActionInterrupted = true;};
		if (animationstate player isNotEqualTo "AmovPercMstpSnonWnonDnon_AinvPercMstpSnonWnonDnon_Putdown") then {player playMoveNow 'AmovPercMstpSnonWnonDnon_AinvPercMstpSnonWnonDnon_Putdown';};
	};
	if(Player_ActionInterrupted) exitWith {_shroom setVariable["inUse",false,true];};

	// Check if player has the shrooms trait
	private _traits = player getVariable ["Player_Traits", []];
	private _hasShroomsTrait = "shrooms" in _traits;

	// Shrooms trait: double the harvest
	private _amount = Shrooms_Harvested;
	if (_hasShroomsTrait) then {
		_amount = _amount * 2;
	};

	//Item Add
	["shrooms",_amount] call A3PL_Inventory_Add;
	[format[("STR_A3PL_Shrooms_Gathered" call A3PL_Localize),_amount],Color_Green] call A3PL_Notification;

	//Police call
    private _chance = random 100;
	private _charID = (player getVariable ["character_id",""]);
    if(Shrooms_Call_Police_Chances < _chance) then {
        [("STR_Common_FISD" call A3PL_Localize),("STR_A3PL_Shrooms_SuspectActivity" call A3PL_Localize),getPos player,format[("STR_A3PL_Shrooms_IndividualSeen" call A3PL_Localize)],("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
        [getPlayerUID player,_charID,"Shrooms_Pick",[format["FISD warned"]]] remoteExec ["Server_Log_New",2];
		if(Shrooms_Call_Police_Chances < _chance) then {
        	sleep 15;
			[("STR_A3PL_Shrooms_Witnessed" call A3PL_Localize),Color_Red] call A3PL_Notification;
			[getPlayerUID player,_charID,"Shrooms_Pick",[format["Player notification sent"]]] remoteExec ["Server_Log_New",2];
    	};
    };

	["shrooms"] call PO_Achievement_Learn;
	[getPlayerUID player,_charID,"Shrooms_Pick",[format["Shrooms picking | Amount: %1 | Location: %2",Shrooms_Harvested,(getPosATL _shroom)]]] remoteExec ["Server_Log_New",2];
	deleteVehicle _shroom;
}] call compile_Global;
