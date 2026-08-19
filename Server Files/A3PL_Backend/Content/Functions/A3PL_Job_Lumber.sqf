/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Lumber_FireAxe",
{
	private _tree = cursorObject;
	if (typeOf _tree != "Land_A3PL_Tree3") exitwith {};
	if ((player distance2D _tree) > 6) exitwith {[("STR_A3PL_Job_Lumber_TooFar" call A3PL_Localize)] call A3PL_Notification;};
	private _hp = _tree getVariable ["hp",5];
	_hp = _hp - 5;
	if (_hp <= 0) then {
		private _nearVeh = _tree nearEntities [["Car","Tank"],20];
		{_x allowDamage false;} foreach _nearVeh;
		_tree setDamage 1;
		[_tree] spawn
		{
			private _tree = param [0,objNull];
			private _pos = getPos _tree;
			sleep 3;
			for "_i" from 0 to (round random 4) do {
				private _log = createVehicle ["A3PL_WoodenLog", _pos, [], 3, "CAN_COLLIDE"];
				_log setVariable ["class","log",true];
				_log setVariable ["owner",(player getVariable ["character_id",""]),true];
			};
			deleteVehicle _tree;
			{_x allowDamage true;} foreach _nearVeh;
		};		
	} else {
		_tree setVariable ["hp",_hp,true];
	};
}] call compile_Global;
