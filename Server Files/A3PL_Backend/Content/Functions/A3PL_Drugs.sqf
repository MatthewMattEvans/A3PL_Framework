/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Alcohol_Add",
{
	private _add = param [0,0];
	Player_Alcohol = Player_Alcohol + (_add);
	if(Player_Alcohol > 0) then {player setVariable["alcohol",true,true];};
	player setVariable ["player_alcohol",Player_Alcohol,false];
}] call compile_Global;

['A3PL_Alcohol_Verify',
{
	if (Player_Alcohol > 100) exitWith {Player_Alcohol = 100;};
	if (Player_Alcohol < 0) exitWith {Player_Alcohol = 0;};
	player setVariable ["player_alcohol",Player_Alcohol,false];
}] call compile_Global;

["A3PL_Alcohol_Loop",
{
	private _CurrentAlcool = Player_Alcohol;
	private _totalDrugs = 0;
	{
		_totalDrugs = _totalDrugs + _x;
	} foreach Player_Drugs;

	if(_totalDrugs > 0) exitWith {};

	//Do not loop if not drunk!
	if((_CurrentAlcool <= 0) || !(player getVariable["A3PL_Player_Alive",true])) exitWith {call A3PL_Alcohol_ResetEffects;};

	// Trait high_tolerance - reduces negative effects by 50%
	private _traits = player getVariable ["Player_Traits", []];
	private _effectMultiplier = 1.0;
	if ("high_tolerance" in _traits) then {
		_effectMultiplier = 0.5;
	};

	//Alcohol Effect
	//Just a little cam shake, it's for me.
    if (Alcohol_CamShake_Effects) then {
    	resetCamShake;
    	enableCamShake true;
    	addCamShake [((_CurrentAlcool)*0.3*_effectMultiplier), 100, 2];
    };

	//Adjusting animations speed for my little drunky mate
    if (Alcohol_Speed_Effects) then {
	   player setAnimSpeedCoef (1-(_CurrentAlcool/100*_effectMultiplier));
    };

	//Visual Effects
    if (Alcohol_Visual_Effects) then {
    	if(_CurrentAlcool >= 15) then {
    		"ChromAberration" ppEffectEnable true;
    		"ChromAberration" ppEffectAdjust [(_CurrentAlcool/1000*_effectMultiplier), (_CurrentAlcool/1000*_effectMultiplier), true];
    		"ChromAberration" ppEffectCommit 0;
    	};
    	if(_CurrentAlcool > 30) then {
    		"RadialBlur" ppEffectEnable true;
    		"RadialBlur" ppEffectAdjust [0.01*_effectMultiplier, 0.01*_effectMultiplier, 0.06*_effectMultiplier, 0.06*_effectMultiplier];	//Make it variate with alcohol level
    		"RadialBlur" ppEffectCommit 0;
    	};
    };

	//Too drunk bro! you fell like a dumbass being fucked in the ass!
    if (Alcohol_Fall_Effects) then {
    	_randomFall = random(100);
    	if(_randomFall < (_CurrentAlcool*_effectMultiplier)) then {
    		if((speed player) > 3) then {
    			call A3PL_Lib_Ragdoll;
    		};
    	};
    };

	//Decrese alcohol level
	if(Player_Alcohol <= 0) exitWith {};
	Player_Alcohol = Player_Alcohol - 5;
	[] call A3PL_Alcohol_Verify;
}] call compile_Global;

["A3PL_Alcohol_ResetEffects",
{
	resetCamShake;
	enableCamShake false;
	player setVariable["alcohol",false,true];
	if(!pVar_FastAnimationOn) then {player setAnimSpeedCoef 1;};
	"ChromAberration" ppEffectEnable false;
	"RadialBlur" ppEffectEnable false;
	call A3PL_Alcohol_Verify;
}] call compile_Global;

//Player_Drugs = [shrooms,cocaine,weed]
["A3PL_Drugs_Add",
{
	private _type = param [0,"unknown"];
	private _add = param [1,0];
	private _index = -1;
	switch(true) do {
		case(_type isEqualTo "shrooms"): {
			_index = 0;
		};
		case(_type isEqualTo "cocaine"): {
			_index = 1;
		};
		case(_type IN ["weed_bag_5g","weed_bag_10g","weed_bag_25g","weed_bag_50g","weed_bag_100g"]): {
			_index = 2;
		};
	};

	if(_index < 0) exitwith {};

	private _new = (Player_Drugs select _index) + (_add);
	player setVariable["drugs",true,true];
	Player_Drugs set[_index, _new];
	player setVariable ["player_drugs",Player_Drugs,false];
}] call compile_Global;

["A3PL_Drugs_Loop",
{
	private _totalDrugs = 0;
	{
		_totalDrugs = _totalDrugs + _x;
	} foreach Player_Drugs;

	if((_totalDrugs <= 0) || !(player getVariable["A3PL_Player_Alive",true])) exitWith {call A3PL_Drugs_ResetEffects;};

	// Trait high_tolerance - reduces negative effects by 50%
	private _traits = player getVariable ["Player_Traits", []];
	private _effectMultiplier = 1.0;
	if ("high_tolerance" in _traits) then {
		_effectMultiplier = 0.5;
	};

	//Incapacitated from too much drugs!
	if (_totalDrugs >= 250) exitWith {
		player setVariable ["player_drugs",[0,0,0],false];
		Player_Drugs = [0,0,0];
		[player, "left upper arm", "drug_overdose"] call A3PL_Medical_ApplyWound;
		player setDamage 1;
	};

	// Shrooms
	if((Player_Drugs select 0) > 0) then {
		_shrooms = Player_Drugs select 0;

		//Effects - on total drug level for now - SAME AS ALCOHOL FOR NOW
        if (Shrooms_CamShake_Effects) then {
    		resetCamShake;
    		enableCamShake true;
    		addCamShake [((_totalDrugs)*0.6*_effectMultiplier), 100, 2];
        };

		// "colorCorrections" ppEffectEnable true;
		// "colorCorrections" ppEffectAdjust [0.5, 0.5, 0, [(random 10),(random 10),(random 10),0.2], [1,1,5,2], [(random 5),(random 5),(random 5),(random 5)]];
		// "colorCorrections" ppEffectCommit 40;
		player setStamina 100;

		//Adjusting animations speed
		//player setAnimSpeedCoef (1+(_totalDrugs/200));

		//Visual Effects
        if (Shrooms_Visual_Effects) then {
    		if(_shrooms >= 15) then {
    			// "ChromAberration" ppEffectEnable true;
    			// "ChromAberration" ppEffectAdjust [(_totalDrugs/800), (_totalDrugs/800), true];
    			// "ChromAberration" ppEffectCommit 30;
    		};
    		if(_shrooms > 30) then {
    			// "RadialBlur" ppEffectEnable true;
    			// "RadialBlur" ppEffectAdjust [0.01, 0.01, 0.06, 0.06];	//Make it variate with alcohol level
    			// "RadialBlur" ppEffectCommit 30;
    			player enableStamina false;
    		};
        };
	};

	// Cocaine
	if((Player_Drugs select 1) > 0) then {
		_coke = Player_Drugs select 1;

        if (Cocaine_CamShake_Effects) then {
    		resetCamShake;
    		enableCamShake true;
    		addCamShake [((_coke)*0.6*_effectMultiplier), 100, 2];
        };

		// "colorCorrections" ppEffectEnable true;
		// "colorCorrections" ppEffectAdjust [0.5, 0.5, 0, [(random 10),(random 10),(random 10),0.2], [1,1,5,2], [(random 5),(random 5),(random 5),(random 5)]];
		// "colorCorrections" ppEffectCommit 40;
		player setAnimSpeedCoef 1.2;

		//Adjusting animations speed
		//player setAnimSpeedCoef (1+(_totalDrugs/200));

		//Visual Effects
        if (Cocaine_Visual_Effects) then {
    		if(_coke >= 15) then {
    			// "colorCorrections" ppEffectEnable true;
    			// "colorCorrections" ppEffectAdjust [(_coke/800), (_coke/800), true];
    			// "colorCorrections" ppEffectCommit 30;
    			player setStamina 100;
    		};
    		if(_coke > 30) then {
    			// "colorCorrections" ppEffectEnable true;
    			// "colorCorrections" ppEffectAdjust [0.01, 0.01, 0.06, 0.06];	//Make it variate with alcohol level
    			// "colorCorrections" ppEffectCommit 30;
    			player setStamina 150;
    		};
        };
	};

	// Weed
	if((Player_Drugs select 2) > 0) then {
		_weed = (Player_Drugs select 2);

		// "dynamicBlur" ppEffectEnable true;
		// "dynamicBlur" ppEffectAdjust [0.25];
		// "dynamicBlur" ppEffectCommit 1;

		//Adjusting animations speed
		player setAnimSpeedCoef 0.7;

		//Visual Effects
        if (Weed_Visual_Effects) then {
    		if(_weed > 50) then {
    			// "dynamicBlur" ppEffectEnable true;
    			// "dynamicBlur" ppEffectAdjust [0.75];	//Make it variate with alcohol level
    			// "dynamicBlur" ppEffectCommit 1;
    			player setAnimSpeedCoef 0.5;
    			_bloodLevel = player getVariable["A3PL_Medical_Blood",5000];
    			if(_bloodLevel < 5000) then {
    				[player,[200]] call A3PL_Medical_ApplyVar;
    			};
    		};
        };
	};

	//Decrease Drug level
	{
		if(_x > 0) then {
			Player_Drugs set[_forEachIndex, (_x - 1)];
		};
	} foreach Player_Drugs;
	player setVariable ["player_drugs",Player_Drugs,false];
}] call compile_Global;

["A3PL_Drugs_ResetEffects",
{
	Player_Drugs = [0,0,0];
	player setVariable["drugs",false,true];
	resetCamShake;
	enableCamShake false;
	if(!pVar_FastAnimationOn) then {player setAnimSpeedCoef 1;};
	"colorCorrections" ppEffectEnable false;
	"ChromAberration" ppEffectEnable false;
	"RadialBlur" ppEffectEnable false;
	"filmGrain" ppEffectEnable false;
	"dynamicBlur" ppEffectEnable false;
}] call compile_Global;

["A3PL_Drugs_DrugTest",
{
	private _target = param [0,objNull];
	[player] remoteExec ["A3PL_Drugs_DrugTestReturn",_target];
	[player_item] call A3PL_Inventory_Clear;
	[player,"drug_kit",-1] remoteExec ["Server_Inventory_Add",2];
}] call compile_Global;

["A3PL_Drugs_DrugTestReturn",
{
	private _cop = param [0,objNull];
	private _drugLevel = Player_Drugs;
	private _job = _cop getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
	if(_job isEqualTo ("STR_Common_FIFR" call A3PL_Localize)) then {
		_shrooms = _drugLevel select 0;
		_coke = _drugLevel select 1;
		_weed = _drugLevel select 2;
		[format[("STR_A3PL_Drugs_TestResultsFIFR" call A3PL_Localize),_coke,_weed,_shrooms],Color_blue] remoteExec ["A3PL_Notification",_cop];
	} else {
		_totalDrugs = 0;
		{_totalDrugs = _totalDrugs + _x;} foreach _drugLevel;
		if(_totalDrugs > 0) then {[("STR_A3PL_Drugs_TestResultPositiveFISD" call A3PL_Localize),Color_blue] remoteExec ["A3PL_Notification",_cop];};
		if(_totalDrugs == 0) then {[("STR_A3PL_Drugs_TestResultNegativeFISD" call A3PL_Localize),Color_blue] remoteExec ["A3PL_Notification",_cop];};
	};
}] call compile_Global;
