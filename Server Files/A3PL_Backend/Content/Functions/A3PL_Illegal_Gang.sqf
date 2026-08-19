/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
/*["A3PL_Gang_SetData", {
	A3PL_Gang_Data = (_this select 0);
	[]call A3PL_Gang_Init;
}] call compile_Global;*/

["A3PL_Gang_Init", {
	private["_group"];
	private _data = param[0,[]];

	if (count _data isEqualTo 0) exitWith {};
	{
		_groupData = _x getVariable ["gang_data",nil];
		if (!isNil "_groupData") then {
			_groupID = _x getVariable ["gang_id",nil];
			if (isNil "_groupID") then {continue;};
			if ((_data#0) isEqualTo _groupID) exitWith {
				_group = _x;
			};
		};
	} forEach allGroups;

	if (!isNil "_group") then {
		[player] joinSilent _group;
		if ((_data#1) isEqualTo (player getVariable ["character_id",""])) then {
			_group selectLeader player;
		};
	} else {
		_group = group player;
		_group setVariable ["gang_data",_data,true];
	};
}] call compile_Global;

["A3PL_Gang_Create", {
    params [["_groupName","",[""]]];
    if (Gang_Approve_By_Staff == true) then {
        _license = ['gang',player] call A3PL_DMV_Check;
        if !_license exitwith {[("STR_A3PL_Illegal_Gang_YouMustApply" call A3PL_Localize),Color_Red] call A3PL_Notification;};
        [player, _groupName] remoteExec ["Server_Gang_Create",2];
    } else {
        [player, _groupName] remoteExec ["Server_Gang_Create",2];
    };
}] call compile_Global;

["A3PL_Gang_Invite", {
	params [["_invited","",[""]]];
	if(_invited isEqualTo "") exitWith {[("STR_A3PL_Illegal_Gang_ErrorDuringInvite" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _group = group player;
	private _gang = _group getVariable ["gang_data",nil];

	if(isNil '_gang') exitWith {};
	private _members =  _gang select 3;
	private _maxMembers = _gang select 5;

	if((player getVariable ["character_id",""]) != (_gang select 1)) exitWith {[("STR_A3PL_Illegal_Gang_OnlyLeaderCanInvite" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if((count _members) > _maxMembers) exitWith {[format [("STR_A3PL_Illegal_Gang_YouReachedGangLimit" call A3PL_Localize),_maxMembers],Color_Red] call A3PL_Notification;};

	private _target = [_invited] call A3PL_Lib_charIDToObject;
	if(isNull _target) exitWith {[("STR_A3PL_Illegal_Gang_ImpossibleToFindTargetTryAgain" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _hasGang = (group _target) getVariable["gang_data",nil];
	if(isNil '_hasGang') then {
		[_group, player] remoteExec ["A3PL_Gang_InviteReceived",_target];
		[("STR_A3PL_Illegal_Gang_YouSentGangInvite" call A3PL_Localize),Color_Green] call A3PL_Notification;
	} else {
		[("STR_A3PL_Illegal_Gang_PlayerInvitedToGang" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};
}] call compile_Global;

["A3PL_Gang_InviteReceived", {
	params [
		["_group",grpNull,[grpNull]],
		["_sender",objNull,[objNull]]
	];
	private _gang = _group getVariable ["gang_data",nil];

	if(isNil '_gang') exitWith {};
	private _groupName = _gang select 2;
	private _action = [format[("STR_A3PL_Illegal_Gang_YouHaveBeenInvitedToJoin" call A3PL_Localize),_groupName]] call A3PL_Lib_ConfirmationDialog;
	if (!isNil "_action" && {!_action}) exitWith {[format[("STR_A3PL_Illegal_Gang_DeclineGangInvite" call A3PL_Localize),player getVariable["name",""]], Color_red] remoteExec ["A3PL_Notification",_sender];};

	[player] joinSilent _group;
	[(player getVariable ["character_id",""]), _group] call A3PL_Gang_AddMember;
	[format[("STR_A3PL_Illegal_Gang_JoinedGang" call A3PL_Localize),player getVariable["name",""]], Color_green] remoteExec ["A3PL_Notification",_sender];
}] call compile_Global;

["A3PL_Gang_Created", {
	private _group = group player;
	private _gang = _group getVariable ["gang_data",nil];
	if(isNil '_gang') exitWith {};
	private _groupName = _gang select 2;
	[format [("STR_A3PL_Illegal_Gang_YouCreatedGang" call A3PL_Localize),_groupName],Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Gang_AddMember", {
	params [
		["_addcharID","",[""]],
		["_group",grpNull,[grpNull]]
	];
	private _gang = _group getVariable ["gang_data",nil];
	if(isNil '_gang') exitWith {};
	private _members = _gang select 3;
	_members pushBackUnique _addcharID;
	_gang set[3,_members];
	_group setVariable ["gang_data",_gang,true];
	[_group] remoteExec ["Server_Gang_SaveMembers",2];
}] call compile_Global;

["A3PL_Gang_RemoveMember", {
	params [
		["_removecharID","",[""]],
		["_kicked",false,[false]]
	];
	private _group = group player;
	private _gang = _group getVariable ["gang_data",nil];
	if(isNil '_gang') exitWith {};
	_members = _gang select 3;
	_members = _members - [_removecharID];
	_gang set[3,_members];
	_group setVariable ["gang_data",_gang,true];
	[_group] remoteExec ["Server_Gang_SaveMembers",2];
	if(_kicked) then {
		private _target = [_removecharID] call A3PL_Lib_charIDToObject;
		if(isNull _target) exitWith {[("STR_A3PL_Illegal_Gang_TargetNotConnectedToServer" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		[] remoteExec ["A3PL_Gang_Kicked",_target];
	};
}] call compile_Global;

["A3PL_Gang_Kicked", {
    [player] joinSilent (createGroup civilian);
    [("STR_A3PL_Illegal_Gang_YouHaveBeenKickedFromGang" call A3PL_Localize),Color_Red] call A3PL_Notification;
}] call compile_Global;

["A3PL_Gang_Leave", {
	private _group = group player;
	private _gang = _group getVariable ["gang_data",nil];
	if(isNil '_gang') exitWith {};

	if(((player getVariable ["character_id",""]) isEqualTo (_gang select 1))) exitWith {[("STR_A3PL_Illegal_Gang_LeaderCannotLeaveGang" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	[(player getVariable ["character_id",""])] call A3PL_Gang_RemoveMember;
	[player] joinSilent (createGroup civilian);

	[("STR_A3PL_Illegal_Gang_YouLeftGang" call A3PL_Localize),Color_Green] call A3PL_Notification;
	closeDialog 0;
}] call compile_Global;

["A3PL_Gang_Delete", {
	private _group = group player;
	private _gang = _group getVariable ["gang_data",nil];
	if(isNil '_gang') exitWith {};
	if(((player getVariable ["character_id",""]) != (_gang select 1))) exitWith {[("STR_A3PL_Illegal_Gang_OnlyLeaderCanRemove" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[_group,player] remoteExec ["Server_Gang_DeleteGang",2];
	closeDialog 0;
}] call compile_Global;

["A3PL_Gang_SetLead", {
	params [["_newcharID","",[""]]];
	private _group = group player;
	private _gang = _group getVariable ["gang_data",nil];
	if(isNil '_gang') exitWith {};

	if((player getVariable ["character_id",""]) != (_gang select 1)) exitWith {[("STR_A3PL_Illegal_Gang_OnlyCurrentLeaderCanAppointNew" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if((player getVariable ["character_id",""]) isEqualTo _newcharID) exitWith {[("STR_A3PL_Illegal_Gang_YouCantAppointYourself" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_gang set[1,_newcharID];
	_group setVariable["gang_data",_gang,true];

	[_group] remoteExec ["Server_Gang_SetLead",2];
	[format [("STR_A3PL_Illegal_Gang_YouAppointedNewLeader" call A3PL_Localize)],Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Gang_AddBank", {
	params [
		["_group",grpNull,[grpNull]],
		["_amount",0,[0]]
	];
	private _gang = _group getVariable ["gang_data",nil];
	if(isNil '_gang') exitWith {};
	private _currentBank = _gang select 4;
	_gang set[4,_currentBank + (_amount)];
	_group setVariable["gang_data",_gang,true];
	[_group] remoteExec ["Server_Gang_SaveBank",2];
}] call compile_Global;

["A3PL_Gang_Capture", {
	params [["_obj",objNull,[objNull]]];
	private _group = group player;
	private _charID = player getVariable ["character_id",""];
	private _cooldown = _obj getVariable ["CapturedTime",serverTime-Gang_Hideout_Cooldown];

	if((player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) IN [("STR_Common_FIFR" call A3PL_Localize),("STR_Common_FISD" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) exitWith {[("STR_A3PL_Illegal_Gang_YouCannotCaptureWhileOnDuty" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if((currentWeapon player) isEqualTo "") exitwith {[("STR_Common_NoWeaponEquipped" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if((currentWeapon player) IN Cant_Rob_With_This) exitwith {[("STR_A3PL_Illegal_Gang_YouCannotCaptureWithThisItem" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if(_obj getVariable ["CaptureInProgress",false]) exitWith {[("STR_A3PL_Illegal_Gang_SomeoneIsAlreadyCapturing" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_cooldown > (serverTime-Gang_Hideout_Cooldown)) exitWith {[("STR_A3PL_Illegal_Gang_ThisHideoutAlreadyCaptured" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_gang = _group getVariable["gang_data",nil];
	_gangName = _gang select 2;
	if(isNil '_gang') exitWith {[("STR_A3PL_Illegal_Gang_YouAreNotInAGang" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_gangID = _gang select 0;
	if((_obj getVariable["captured",-1]) isEqualTo _gangID) exitWith {[("STR_A3PL_Illegal_Gang_YourGangControlsHideout" call A3PL_Localize),Color_Red] call A3PL_Notification;};

    if ((Gang_Desactive_Hideout isEqualTo true) && (_obj IN Gang_Desactive_Hideout_Names)) exitWith {
        [("STR_A3PL_Illegal_Gang_ThisHideoutTemporarilyDisabled" call A3PL_Localize),Color_Red] call A3PL_Notification;
    };

	private _numOwnedHideouts = 1;
	{
		private _hideoutOwner = _x getVariable ["captured",-1];
		if (_hideoutOwner isEqualTo _gangID) then {
			_numOwnedHideouts = _numOwnedHideouts + 1;
		};
	} forEach Gang_All_Hideouts;

	_obj setVariable ["CaptureInProgress",true,true];

	_marker = [_obj,"ganghideout"] call A3PL_Lib_NearestMarker;

	if (Player_ActionDoing) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	Player_ActionCompleted = false;
	private _chance = random 100;
	if(_chance >= Gang_Hideout_ChanceNotifCops) then {
		[("STR_Common_FISD" call A3PL_Localize),"Capture Cachette",getPos player,format[("STR_A3PL_Illegal_Gang_HideoutCaptureReported" call A3PL_Localize)],("STR_Common_ReceiveDispatchCall" call A3PL_Localize)] remoteExec ["Server_Police_ReceiveDispatch",2];
	};
	[("STR_A3PL_Illegal_Gang_Capture" call A3PL_Localize),Gang_Hideout_Timer] spawn A3PL_Lib_LoadAction;
	waitUntil{Player_ActionDoing};
	while {Player_ActionDoing} do {
		if (Player_ActionInterrupted) exitWith {};
		if (!(player getVariable["A3PL_Medical_Alive",true])) exitWith {Player_ActionInterrupted = true;};
		if (!((vehicle player) isEqualTo player)) exitwith {Player_ActionInterrupted = true;};
		if ((player distance _obj) > 30) exitwith {Player_ActionInterrupted = true;};
		if (player getVariable ["Incapacitated",false]) exitwith {Player_ActionInterrupted = true;};
		if ((currentWeapon player) isEqualTo "") exitWith {Player_ActionInterrupted = true;};
		if (!(_charID IN Server_Online_Players_charIDs)) exitWith {Player_ActionInterrupted = true;};
	};
	Player_ActionDoing = false;
	if(Player_ActionInterrupted) exitWith {[("STR_Common_ActionInterrupted" call A3PL_Localize),Color_Red] call A3PL_Notification; _obj setVariable ["CaptureInProgress",false,true];};

	_obj setVariable["captured",_gangID,true];
	_obj setVariable["capturedName",_gangName,true];
	_obj setVariable["CapturedTime",serverTime,true];
	_obj setVariable ["CaptureInProgress",false,true];

	if(_chance >= Gang_Hideout_ChanceNotifGeneral) then {
		[format[("STR_A3PL_Illegal_Gang_GangCapturedHideout" call A3PL_Localize)], Color_Yellow] remoteExec ["A3PL_Notification",-2];
	};

	_marker setMarkerText format[("STR_A3PL_Illegal_Gang_HideoutCaptured" call A3PL_Localize)];
	_marker setMarkerType "A3FL_Markers_GangHideout";

	private _reward = Gang_Hideout_Reward * _numOwnedHideouts;
	[format[("STR_A3PL_Illegal_Gang_YourGangControlsXof6Hideouts" call A3PL_Localize),_numOwnedHideouts,_reward],Color_Green] call A3PL_Notification;

	[_group,_reward] call A3PL_Gang_AddBank;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Gang_HideoutCapture",[format ["Location: %1 | Reward: %2 | New balance: %3", (getPosATL _obj), _reward, (_gang select 4)]]] remoteExec ["Server_Log_New",2];
	[_obj] spawn A3PL_Gang_Keephideout;
}] call compile_Global;

["A3PL_Gang_Keephideout", {
	params [["_obj",objNull,[objNull]]];
	private _group = group player;
	private _gang = _group getVariable["gang_data",nil];
	private _gangID = _gang select 0;
	while {(_obj getVariable["captured",""]) isEqualTo _gangID} do {
		private _count = count(units group player inAreaArray[position _obj, 1000, 1000, 0, false]);
		if (_count < 1) then {
			private _timer = 5;
			for "_i" from 1 to _timer do{
				_count = count(units group player inAreaArray[position _obj, 1000, 1000, 0, false]);
				if (_count >= 1) exitWith {};
				[("STR_A3PL_Illegal_Gang_WarningLeavingHideout" call A3PL_Localize),Color_Yellow] remoteExec ["A3PL_Notification",_group];
				sleep 3;
			};
			if (_count < 1) exitWith {
				[("STR_A3PL_Illegal_Gang_YouAbandonedHideout" call A3PL_Localize),Color_Red] remoteExec ["A3PL_Notification",_group];
				[format[("STR_A3PL_Illegal_Gang_AGangLostHideout" call A3PL_Localize)], Color_Yellow] remoteExec ["A3PL_Notification",-2];
				_obj setVariable["captured",nil,true];
				_obj setVariable["capturedName",nil,true];
				_obj setVariable["CapturedTime",serverTime,true];
				_obj setVariable ["CaptureInProgress",false,true];
				private _marker = [_obj,"ganghideout"] call A3PL_Lib_NearestMarker;
				_marker setMarkerText "";
				_marker setMarkerType "A3FL_Markers_GangHideout";
				[getPlayerUID player,(player getVariable ["character_id",""]),"Gang_HideoutLost",[format ["Location: %1", (getPosATL _obj)]]] remoteExec ["Server_Log_New",2];
			};
		};
		sleep 15;
	};
}] call compile_Global;

["A3PL_Gang_CapturedPaycheck", {
	private _win = 0;
	private _group = group player;
	private _gang = _group getVariable["gang_data",nil];
	if(isNil '_gang') exitWith {};
	private _gangID = _gang select 0;

	{
		if((_x getVariable["captured",-1]) isEqualTo _gangID) then {_win = _win + Gang_Hideout_Paycheck;};
	} forEach Gang_All_Hideouts;
	if(_win isEqualTo 0) exitWith {};

	[format[("STR_A3PL_Illegal_Gang_YouWonMoneyForHoldingHideout" call A3PL_Localize),_win],Color_Green] call A3PL_Notification;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Gang_HideoutPaycheck",[format ["Reward: %1 | New bank: %2", _win, (_gang select 4)]]] remoteExec ["Server_Log_New",2];
	[_group,_win] call A3PL_Gang_AddBank;
}] call compile_Global;

["A3PL_Gang_GangTax", {
	params [["_shop",objNull,[objNull]]];
	private _gangHideout = objNull;

	if(_shop IN Gang_Hideout_1_Tax) then {
		_gangHideout = hideout_obj_1;
	};
	if(_shop IN Gang_Hideout_2_Tax) then {
		_gangHideout = hideout_obj_2;
	};
	if(_shop IN Gang_Hideout_3_Tax) then {
		_gangHideout = hideout_obj_3;
	};
	if(_shop IN Gang_Hideout_4_Tax) then {
		_gangHideout = hideout_obj_4;
	};
	if(_shop IN Gang_Hideout_5_Tax) then {
		_gangHideout = hideout_obj_5;
	};

	if(_shop IN Gang_Hideout_BodyDead) then {
		private _hideouts = nearestObjects [player, ["a3pl_bodydead"],30];
		private _nearestHideout = _hideouts#0;
		_gangHideout = _nearestHideout;
	};

	if(_gangHideout isEqualTo objNull) exitWith {};
	_gangID = _gangHideout getVariable ["captured",0];

	if(_gangID isEqualTo 0) exitWith {};

	_gangName = _gangHideout getVariable ["capturedName",""];
	_gangData = [_gangID,_gangName];
	_gangData;
}] call compile_Global;

["A3PL_Gang_Secure", {
	params [["_obj",objNull,[objNull]]];
	private _nilCheck = _obj getVariable ["captured",nil];
	private _faction = player getVariable["faction","citizen"];
	if(isNil "_nilCheck") exitWith{[("STR_A3PL_Illegal_Gang_ThisGangHideoutNotCaptured" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if(_obj getVariable ["CaptureInProgress",false]) exitWith {[("STR_A3PL_Illegal_Gang_SomeoneIsAlreadyCapturingThisHideout" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (Player_ActionDoing) exitwith {[("STR_A3PL_Illegal_Gang_YouAreAlreadyDoingAnAction" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if((_obj IN Gang_All_Hideouts) && (_faction != ("STR_Common_FISD" call A3PL_Localize))) exitWith {[("STR_A3PL_Illegal_Gang_ThisGangHideoutSecuredByFISD" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_capturedTime = _obj getVariable["CapturedTime",serverTime-1200];

	private _gangName = _obj getVariable["capturedName",""];
	_marker = [_obj,"ganghideout"] call A3PL_Lib_NearestMarker;
	[format[("STR_A3PL_Illegal_Gang_StartingToSecureHideout" call A3PL_Localize),(toUpperANSI _faction)], Color_Yellow] remoteExec ["A3PL_Notification",-2];
	Player_ActionCompleted = false;
	_obj setVariable ["CaptureInProgress",true,true];
	[("STR_A3PL_Illegal_Gang_SecuringHideout" call A3PL_Localize),Gang_Hideout_Secure_Timer] spawn A3PL_Lib_LoadAction;
	waitUntil{Player_ActionDoing};
	while {Player_ActionDoing} do {
		if (Player_ActionInterrupted) exitWith {Player_ActionInterrupted = true;};
		if (!(player getVariable["A3PL_Medical_Alive",true])) exitWith {Player_ActionInterrupted = true;};
		if (!(vehicle player isEqualTo player)) exitwith {Player_ActionInterrupted = true;};
		if (player getVariable ["Incapacitated",false]) exitwith {Player_ActionInterrupted = true;};
	};
	Player_ActionDoing = false;
	if (Player_ActionInterrupted) exitWith {[("STR_Common_ActionInterrupted" call A3PL_Localize),Color_Red] call A3PL_Notification;_obj setVariable ["CaptureInProgress",false,true];};

	_marker setMarkerText format[("STR_A3PL_Illegal_Gang_HideoutSecuredMarker" call A3PL_Localize)];
	_marker setMarkerType "A3FL_Markers_SDStation";

	_obj setVariable["captured",nil,true];
	_obj setVariable["capturedName",nil,true];
	_obj setVariable["CapturedTime",serverTime,true];
	_obj setVariable ["CaptureInProgress",false,true];

	[format[("STR_A3PL_Illegal_Gang_SucuccessfullySecuredHideout" call A3PL_Localize),(toUpperANSI _faction)], Color_blue] remoteExec ["A3PL_Notification",-2];
	[_faction] remoteExec ["Server_Gang_RewardFactions",2];
}] call compile_Global;

["A3FL_Gang_CollectTaxes", {
	params [["_shop",objNull,[objNull]]];

	private _group = group player;
	private _gang = _group getVariable ["gang_data",nil];
	if (isNil "_gang") exitWith {[("STR_A3PL_Illegal_Gang_YouAreNotInAGang" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _gangID = _gang#2;
	private _isGangControlled = [_shop] call A3PL_Gang_GangTax;
	if (isNil "_isGangControlled") exitWith {[("STR_A3PL_Illegal_Gang_ThisShopNotControlledByNearestGangHideout" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_gangID isNotEqualTo _isGangControlled#0) exitWith {[("STR_A3PL_Illegal_Gang_YourGangDoesNotControlThisShop" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _taxesToCollect = _shop getVariable ["gangTaxes",0];
	if (_taxesToCollect < 1) exitWith {[("STR_A3PL_Illegal_Gang_NoMoneyToCollectFromShop" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[_gangID,_taxesToCollect] remoteExec ["Server_Gang_UpdateGangBalance",2];
	[format [("STR_A3PL_Illegal_Gang_SomeoneFromYourGangCollectedProtectionTax" call A3PL_Localize),_taxesToCollect],Color_green] remoteExec ["A3PL_Notification",_group];
	_shop setVariable ["gangTaxes",nil,true];
}] call compile_Global;
