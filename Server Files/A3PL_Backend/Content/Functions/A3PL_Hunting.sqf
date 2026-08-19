/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Hunting_Skin",
{
	private _animal = param [0,objNull];
	if (isNull _animal) exitwith {};
	private _type = typeOf _animal;
	if (Player_ActionDoing) exitwith {[("STR_Common_ActionAlreadyInProgress" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_animal getVariable ["skinning",false]) exitwith {[("STR_A3PL_Hunting_AlreadySkinned" call A3PL_Localize)] call A3PL_Notification;};
	_animal setVariable ["skinning",true,true];

	[("STR_A3PL_Hunting_Skinning" call A3PL_Localize),Hunting_Skin_Timer] spawn A3PL_Lib_LoadAction;
	waitUntil{Player_ActionDoing};
	player playMoveNow 'ainvpknlmstpsnonwnondnon_medic_1';
	while {Player_ActionDoing} do {
		if ((player distance2D _animal) > 5) exitwith {Player_ActionInterrupted = true};
		if (!(player getVariable["A3PL_Medical_Alive",true])) exitWith {Player_ActionInterrupted = true;};
		if ((vehicle player) != player) exitwith {Player_ActionInterrupted = true;};
		if (player getVariable ["Incapacitated",false]) exitwith {Player_ActionInterrupted = true;};
		if ((animationstate player) != "ainvpknlmstpsnonwnondnon_medic_1") then {player playMoveNow 'ainvpknlmstpsnonwnondnon_medic_1';};
	};
	[player, ""] remoteExec ["A3PL_Lib_SyncAnim",0];
	if(Player_ActionInterrupted) exitWith {[("STR_Common_ActionInterrupted" call A3PL_Localize),Color_Red] call A3PL_Notification;_animal setVariable ["skinning",nil,true];};

	private _meatItem = "meat_sheep";
	private _animalType = "Unknown";
	switch (true) do
	{
		case (_type IN ["Goat","Goat02","Goat03"]): { _meatItem = "meat_goat"; _animalType = "goat"; };
		case (_type IN ["WildBoar"]): { _meatItem = "meat_boar"; _animalType = "wildboar"; };
		case (_type IN ["Sheep","Sheep02","Sheep03"]): { _meatItem = "meat_sheep"; _animalType = "sheep";};
		case (_type IN ["Cow01","Cow02","Cow03","Cow04","Cow05"]): { _meatItem = "meat_cow"; _animalType = "cow";};
	};

	// Check if player has the hunter trait
	private _traits = player getVariable ["Player_Traits", []];
	private _hasHunterTrait = "hunter" in _traits;
	private _luckyBonus = [_traits] call A3PL_Traits_GetLuckyBonus;

	private _amount = 1;

	// Hunter trait: 50% chance to double the yield (+ lucky bonus, or lucky alone: 15%)
	private _chance = if (_hasHunterTrait) then {50 + _luckyBonus} else {_luckyBonus};
	if (_chance > 0 && {random 100 < _chance}) then {
		_amount = _amount * 2 * A3PL_Event_DblHarvest;
	} else {
		_amount = _amount * A3PL_Event_DblHarvest;
	};

	[_meatItem,_amount] call A3PL_Inventory_Add;
	[format [("STR_A3PL_Hunting_YouSkinned" call A3PL_Localize),_animalType,_amount,[_meatItem,"name"] call A3PL_Config_GetItem],Color_Green] call A3PL_Notification;
	deleteVehicle _animal;
}] call compile_Global;

["A3PL_Hunting_Tag",
{
	private ["_newClass","_tagClass"];
	private _meat = param [0,objNull];
	private _class = _meat getVariable ["class","unknown"];
	private _amount = _meat getVariable ["amount",1];
	switch (_class) do
	{
		case ("meat_goat"): {_newClass = "meat_goat_tag"; _tagClass = "tag_meat";};
		case ("meat_sheep"): {_newClass = "meat_sheep_tag"; _tagClass = "tag_meat";};
		case ("meat_boar"): {_newClass = "meat_boar_tag"; _tagClass = "tag_meat";};
		case ("meat_cow"): {_newClass = "meat_cow_tag"; _tagClass = "tag_meat";};

		case ("mullet"): {_newClass = "mullet_tag"; _tagClass = "tag_fish";};
		case ("shark_2lb"): {_newClass = "shark_2lb_tag"; _tagClass = "tag_shark";};
		case ("shark_4lb"): {_newClass = "shark_4lb_tag"; _tagClass = "tag_shark";};
		case ("shark_5lb"): {_newClass = "shark_5lb_tag"; _tagClass = "tag_shark";};
		case ("shark_7lb"): {_newClass = "shark_7lb_tag"; _tagClass = "tag_shark";};
		case ("shark_10lb"): {_newClass = "shark_10lb_tag"; _tagClass = "tag_shark";};
	};
	if (isNil "_tagClass") exitwith {[("STR_A3PL_Hunting_NoEtiquette" call A3PL_Localize),Color_Red] call A3PL_Notification};
	if (!([_tagClass,_amount] call A3PL_Inventory_Has)) exitwith {[("STR_A3PL_Hunting_NoEtiquette" call A3PL_Localize),Color_Red] call A3PL_Notification};
	if (isNil "_newClass") exitwith {[("STR_A3PL_Hunting_AlreadyEtiqueted" call A3PL_Localize)] call A3PL_Notification;};
	_meat setVariable ["class",_newClass,true];
	[_tagClass,-_amount] call A3PL_Inventory_Add;
	[false] call A3PL_Inventory_PutBack;
	[format[("STR_A3PL_Hunting_YouEttiqueted" call A3PL_Localize),_amount],Color_Green] call A3PL_Notification;
}] call compile_Global;
