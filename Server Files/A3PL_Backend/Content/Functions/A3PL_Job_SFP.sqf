/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_SFP_SignOn",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {}; 
	if (!(["sfp",player] call A3PL_DMV_Check)) exitwith {[("STR_A3PL_Job_SFP_YouDoNotHaveTheSFPLicense" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	[("STR_Common_Job_SecurityAgent" call A3PL_Localize)] call A3PL_NPC_TakeJob;
	[("STR_A3PL_Job_SFP_NowWorkingForSFP" call A3PL_Localize),Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_SFP_CheckIn",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	private _shop = param[0,objNull];
	private _isPort = param[1,false];
	private _isBeingSecured = _shop getVariable ["securing",false];
	private _secured = _shop getVariable ["secured",serverTime-Job_SFP_Secured_Cooldown];
	private _cooldown = _shop getVariable ["SecureCooldown",serverTime-Job_SFP_Secure_Cooldown];
	private _pCooldown = player getVariable ["SecureCD",serverTime-Job_SFP_SecureCD_Cooldown];
	private _exit = false;

	if (_isBeingSecured) exitWith {[("STR_A3PL_Job_SFP_AlreadySecured" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_pCooldown > (serverTime-Job_SFP_SecureCD_Cooldown)) exitWith {[("STR_A3PL_Job_SFP_YouAlreadySecuredAShopOrPort" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_cooldown > (serverTime-Job_SFP_Secure_Cooldown)) exitWith {[("STR_A3PL_Job_SFP_AlreadySecured60MnAgo" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) exitWith {[("STR_A3PL_Job_SFP_CantSecureInService" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_shop setVariable["securing",true,true];
	[getPlayerUID player,(player getVariable ["character_id",""]),"SFP_Secure_Start",[format ["Shop: %1 | Position: %2",_shop,(getPosATL _shop)]]] remoteExec ["Server_Log_New",2];
	if (_isPort) then {
		[("STR_A3PL_Job_SFP_Secure" call A3PL_Localize),Job_SFP_SecurePort_Timer] spawn A3PL_Lib_LoadAction;
		waitUntil{Player_ActionDoing};
		while {Player_ActionDoing} do {
			if ((player distance _shop) > 20) exitWith {Player_ActionInterrupted = true;};
			if (!(player getVariable["A3PL_Medical_Alive",true])) exitWith {Player_ActionInterrupted = true;};
			if (vehicle player isNotEqualTo player) exitwith {Player_ActionInterrupted = true;};
			if (player getVariable ["Incapacitated",false]) exitwith {Player_ActionInterrupted = true;};
		};
		_shop setVariable["securing",false,true];
		if(Player_ActionInterrupted) exitWith {
			[("STR_A3PL_Job_SFP_SecureCancelled" call A3PL_Localize),Color_Red] call A3PL_Notification;
			_exit = true;
		};
	} else {
		[("STR_A3PL_Job_SFP_Secure" call A3PL_Localize),Job_SFP_SecureStore_Timer] spawn A3PL_Lib_LoadAction;
		waitUntil{Player_ActionDoing};
		while {Player_ActionDoing} do {
			if ((player distance _shop) > 20) exitWith {Player_ActionInterrupted = true;};
			if !(player getVariable["A3PL_Medical_Alive",true]) exitWith {Player_ActionInterrupted = true;};
			if (vehicle player isNotEqualTo player) exitwith {Player_ActionInterrupted = true;};
			if (player getVariable ["Incapacitated",false]) exitwith {Player_ActionInterrupted = true;};
		};
		_shop setVariable["securing",false,true];
		if(Player_ActionInterrupted) exitWith {
			[("STR_A3PL_Job_SFP_SecureCancelled" call A3PL_Localize),Color_Red] call A3PL_Notification;
			_exit = true;
		};
	};
	if(_exit) exitWith {
		[getPlayerUID player,(player getVariable ["character_id",""]),"SFP_Secure_Cancel",[format ["Shop: %1 | Position: %2",_shop,(getPosATL _shop)]]] remoteExec ["Server_Log_New",2];
	};

	[getPlayerUID player,(player getVariable ["character_id",""]),"SFP_Secure_Success",[format ["Shop: %1 | Position: %2",_shop,(getPosATL _shop)]]] remoteExec ["Server_Log_New",2];
	player setVariable ["SecuredCD",serverTime,true];
	_shop setVariable ["SecureCooldown",serverTime,true];
	_shop setVariable ["secured",serverTime,true];

	// Check if player has the employee trait
	private _traits = player getVariable ["Player_Traits", []];
	private _hasEmployeeTrait = "employee" in _traits;

	// Employee trait: 25% salary bonus
	private _reward = Job_SFP_Secure_Reward;
	if (_hasEmployeeTrait) then {
		_reward = _reward * 1.25;
	};

	[format[("STR_A3PL_Job_SFP_PlaceSecured" call A3PL_Localize),_reward],Color_Green] call A3PL_Notification;
	player setVariable ["player_cash",(player getVariable ["player_cash",0]) + _reward,true];
}] call compile_Global;
