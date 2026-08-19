/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3FL_Animations_loadAnimCats", {
    disableSerialization;
    closeDialog 0;
    createDialog "Dialog_AnimationsCat_Menu";
    (findDisplay 7000) call A3PL_Dialog_Localize;

    ctrlSetText[7001,("STR_A3PL_Animations_Dance" call A3PL_Localize)];
    ctrlSetText[7002,("STR_A3PL_Animations_Exercise" call A3PL_Localize)];
    ctrlSetText[7003,("STR_A3PL_Animations_Static" call A3PL_Localize)];
    ctrlSetText[7004,("STR_A3PL_Animations_Gesture" call A3PL_Localize)];
    ctrlSetText[7005,("STR_A3PL_Animations_Actions" call A3PL_Localize)];
    ctrlSetText[7007,("STR_A3PL_Animations_StopAnim" call A3PL_Localize)];
}] call compile_Global;

["A3FL_Animations_loadAnimations", {
    params [["_category","",[""]]];

    A3FL_Animation_actionList = [];
    A3FL_Animation_overflowList = [];
    A3FL_Animation_Current = [];
    A3FL_Animation_Current append Config_Animations;
    
    {
        private _cat = _x#0;
        private _title = _x#1;
        private _type = _x#2;
        private _animation = _x#3;
        private _wait = _x#4;
        if (_cat isEqualTo _category) then {
            if (count A3FL_Animation_actionList >= 6) then {
                A3FL_Animation_overflowList pushBack [_title,_animation,_type,_wait];
            } else {
                A3FL_Animation_actionList pushBack [_title,_animation,_type,_wait];
            };
        };
    } forEach A3FL_Animation_Current;

    A3FL_Animation_Current = [];

    if(count A3FL_Animation_overflowList > 0) then {
        if(count A3FL_Animation_overflowList < 1) then {
            A3FL_Animation_actionList pushBack [(A3FL_Animation_overflowList select 0 select 0),(A3FL_Animation_overflowList select 0 select 1)];
        };
    };

    if(count A3FL_Animation_actionList < 1) exitWith {};

    closeDialog 0;
    createDialog "Dialog_Animations_Menu";
    (findDisplay 6900) call A3PL_Dialog_Localize;

    buttonSetAction [7100, "[0] spawn A3FL_Animations_animButtonPressed;"];
    buttonSetAction [7101, "[1] spawn A3FL_Animations_animButtonPressed;"];
    buttonSetAction [7102, "[2] spawn A3FL_Animations_animButtonPressed;"];
    buttonSetAction [7103, "[3] spawn A3FL_Animations_animButtonPressed;"];
    buttonSetAction [7104, "[4] spawn A3FL_Animations_animButtonPressed;"];
    buttonSetAction [7105, "[5] spawn A3FL_Animations_animButtonPressed;"];
    buttonSetAction [7106, "[6] spawn A3FL_Animations_animButtonPressed;"];
    if (count A3FL_Animation_actionList >= 6) then {
        buttonSetAction [7107, "[] call A3FL_Animations_loadMoreOptions;"];
        ctrlSetText[6909,("STR_A3PL_Animations_MoreOptions" call A3PL_Localize)];
    };

    private _idd = 6901;

    {
		if (_idd isEqualTo 6907) exitWith {_idd = _idd + 1;};
		if (_idd isEqualTo 6909) exitWith {_idd = _idd + 1;};
        ctrlSetText[_idd,(_x select 0) call A3PL_Localize];
        _idd = _idd + 1;
    } forEach A3FL_Animation_actionList;
}] call compile_Global;

["A3FL_Animations_loadMoreOptions", {
    closeDialog 0;
    createDialog "Dialog_Animations_Menu";
    (findDisplay 6900) call A3PL_Dialog_Localize;

    buttonSetAction [7100, "[0] spawn A3FL_Animations_animButtonPressed;"];
    buttonSetAction [7101, "[1] spawn A3FL_Animations_animButtonPressed;"];
    buttonSetAction [7102, "[2] spawn A3FL_Animations_animButtonPressed;"];
    buttonSetAction [7103, "[3] spawn A3FL_Animations_animButtonPressed;"];
    buttonSetAction [7104, "[4] spawn A3FL_Animations_animButtonPressed;"];
    buttonSetAction [7105, "[5] spawn A3FL_Animations_animButtonPressed;"];
    buttonSetAction [7106, "[6] spawn A3FL_Animations_animButtonPressed;"];
    buttonSetAction [7107, "[7] spawn A3FL_Animations_animButtonPressed;"];

    A3FL_Animation_actionList = [];

    private _idd = 6901;

    {
        ctrlSetText[_idd,(_x select 0) call A3PL_Localize];
        _idd = _idd + 1;
        A3FL_Animation_actionList pushBack _x;
    } forEach A3FL_Animation_overflowList;
}] call compile_Global;

["A3FL_Animations_animButtonPressed", {
    params[["_value",0,[0]]];

    if(_value > ((count A3FL_Animation_actionList)-1)) exitWith {};
    private _anim = A3FL_Animation_actionList select _value select 1;
    private _type = A3FL_Animation_actionList select _value select 2;
    private _sleep = A3FL_Animation_actionList select _value select 3;

    closeDialog 0;

	if (_anim isEqualTo "A3FL_anim_JumpingJackStart") exitWith {
		[player,_anim] remoteExec ["A3PL_Lib_SyncAnim",0];
		sleep 0.83;
        [player,"A3FL_anim_JumpingJack"] remoteExec ["A3PL_Lib_SyncAnim",0];
	};

    if(_anim isEqualTo "Acts_AidlPercMstpSlowWrflDnon_pissing") then {
        [player] remoteExec ["A3FL_Animations_Piss",-2];
    };

	switch(_type) do {
		case "switchMove": {
            if (_sleep isNotEqualTo 0) then {
                [player,_anim] remoteExec ["A3PL_Lib_SyncAnim",0]; 
                sleep _sleep; 
                [player,""] remoteExec ["A3PL_Lib_SyncAnim",0];
            } else {
                [player,_anim] remoteExec ["A3PL_Lib_SyncAnim",0];
            };
        };
		case "playGesture": {
            if (_sleep isNotEqualTo 0) then {
                [player,_anim,1] remoteExec ["A3PL_Lib_SyncAnim",0]; 
                sleep _sleep; 
                [player,""] remoteExec ["A3PL_Lib_SyncAnim",0];
            } else {
                [player,_anim,1] remoteExec ["A3PL_Lib_SyncAnim",0];
            };
        };
        case "playAction": {
            if (_sleep isNotEqualTo 0) then {
                player playAction _anim; 
                sleep _sleep; 
                [player,""] remoteExec ["A3PL_Lib_SyncAnim",0];
            } else {
                player playAction _anim;
            };
        };
        case "playMove": {
            if (_sleep isNotEqualTo 0) then {
                player playMove _anim; 
                sleep _sleep; 
                [player,""] remoteExec ["A3PL_Lib_SyncAnim",0];
            } else {
                player playMove _anim;
            };
        };
    };
}] call compile_Global;

["A3FL_Animations_Stop", {
    closeDialog 0;
    private _currentAnim = animationState player;
    if (_currentAnim isEqualTo "amovpercmstpsnonwnondnon") then {
        player playAction "gesture_stop";
    } else {
        [player, ""] remoteExec ["A3PL_Lib_SyncAnim",0];
    };
}] call compile_Global;

["A3FL_Animations_Piss", {
    params[["_player",objNull,[objNull]]];

    sleep 3.7;
    
    private _PS1 = "#particlesource" createVehicle [0,0,0]; 
    _PS1 setParticleRandom [0,[0.004,0.004,0.004],[0.01,0.01,0.01],30,0.01,[0,0,0,0],1,0.02,360]; 
    _PS1 setDropInterval 0.001; 
    _PS1 attachTo [_player,[0.1,0.15,-0.10],"Pelvis"] ; 
 
    for "_i" from 0 to 1 step 0.01 do { 
        _PS1 setParticleParams [["\a3\data_f\ParticleEffects\Universal\Universal.p3d",16,12,8],"","BillBoard",1,3,[0,0,0],[sin (getDir _player) * _i,cos (getDir _player) * _i,0],0,1.5,1,0.1,[0.02,0.02,0.1],[[0.8,0.7,0.2,0.1],[0.8,0.7,0.2,0.1],[0.8,0.7,0.2,0]],[1],1,0,"","",_PS1,0,true,0.1,[[0.8,0.7,0.2,0]]]; 
        sleep 0.02; 
    }; 
    for "_i" from 1 to 0.4 step -0.01 do { 
        _PS1 setParticleParams [["\a3\data_f\ParticleEffects\Universal\Universal.p3d",16,12,8],"","BillBoard",1,3,[0,0,0],[sin (getDir _player) * _i,cos (getDir _player) * _i,0],0,1.5,1,0.1,[0.02,0.02,0.1],[[0.8,0.7,0.2,0.1],[0.8,0.7,0.2,0.1],[0.8,0.7,0.2,0]],[1],1,0,"","",_PS1,0,true,0.1,[[0.8,0.7,0.2,0]]]; 
        sleep 0.02; 
    }; 
    for "_i" from 0.4 to 0.5 step 0.02 do { 
        _PS1 setParticleParams [["\a3\data_f\ParticleEffects\Universal\Universal.p3d",16,12,8],"","BillBoard",1,3,[0,0,0],[sin (getDir _player) * _i,cos (getDir _player) * _i,0],0,1.5,1,0.1,[0.02,0.02,0.1],[[0.8,0.7,0.2,0.1],[0.8,0.7,0.2,0.1],[0.8,0.7,0.2,0]],[1],1,0,"","",_PS1,0,true,0.1,[[0.8,0.7,0.2,0]]]; 
        sleep 0.02; 
    }; 
    for "_i" from 0.5 to 0.2 step -0.01 do { 
        _PS1 setParticleParams [["\a3\data_f\ParticleEffects\Universal\Universal.p3d",16,12,8],"","BillBoard",1,3,[0,0,0],[sin (getDir _player) * _i,cos (getDir _player) * _i,0],0,1.5,1,0.1,[0.02,0.02,0.1],[[0.8,0.7,0.2,0.1],[0.8,0.7,0.2,0.1],[0.8,0.7,0.2,0]],[1],1,0,"","",_PS1,0,true,0.1,[[0.8,0.7,0.2,0]]]; 
        sleep 0.02; 
    }; 
    for "_i" from 0.2 to 0.3 step 0.02 do { 
        _PS1 setParticleParams [["\a3\data_f\ParticleEffects\Universal\Universal.p3d",16,12,8],"","BillBoard",1,3,[0,0,0],[sin (getDir _player) * _i,cos (getDir _player) * _i,0],0,1.5,1,0.1,[0.02,0.02,0.1],[[0.8,0.7,0.2,0.1],[0.8,0.7,0.2,0.1],[0.8,0.7,0.2,0]],[1],1,0,"","",_PS1,0,true,0.1,[[0.8,0.7,0.2,0]]]; 
        sleep 0.02; 
    }; 
    for "_i" from 0.3 to 0.1 step -0.01 do { 
        _PS1 setParticleParams [["\a3\data_f\ParticleEffects\Universal\Universal.p3d",16,12,8],"","BillBoard",1,3,[0,0,0],[sin (getDir _player) * _i,cos (getDir _player) * _i,0],0,1.5,1,0.1,[0.02,0.02,0.1],[[0.8,0.7,0.2,0.1],[0.8,0.7,0.2,0.1],[0.8,0.7,0.2,0]],[1],1,0,"","",_PS1,0,true,0.1,[[0.8,0.7,0.2,0]]]; 
        sleep 0.02; 
    }; 
    for "_i" from 0.1 to 0 step -0.01 do { 
        _PS1 setParticleParams [["\a3\data_f\ParticleEffects\Universal\Universal.p3d",16,12,8],"","BillBoard",1,3,[0,0,0],[sin (getDir _player) * _i,cos (getDir _player) * _i,0],0,1.5,1,0.1,[0.02,0.02,0.1],[[0.8,0.7,0.2,_i],[0.8,0.7,0.2,_i],[0.8,0.7,0.2,0]],[1],1,0,"","",_PS1,0,true,0.1,[[0.8,0.7,0.2,0]]]; 
        sleep 0.02; 
    }; 

    sleep 6;

    detach _ps1; 
    deleteVehicle _PS1;
}] call compile_Global;
