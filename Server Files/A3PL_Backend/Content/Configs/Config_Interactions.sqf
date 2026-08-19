/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
A3PL_Interaction_Self =
[
	["STR_Config_Interactions_Inventory",
		{call A3PL_Inventory_Open;},
		{(!isPlayer cursorObject) && (Player_ItemClass isEqualTo "") && (!(player getVariable ["Cuffed",false]) && !(player getVariable ["Zipped",false])) && ((animationState player) != "a3pl_takenhostage") && !(underwater(vehicle player))}
	],
	["STR_Config_Interactions_SearchSeeds",
		{call A3PL_JobFarming_SearchSeeds;},
		{((surfaceType getpos player) == "#cype_plowedfield") && (Player_ItemClass isEqualTo "") && (!(player getVariable ["Cuffed",false])) && (!(player getVariable ["Zipped",false])) && ((vehicle player) isEqualTo player) && (("green_hand" in (player getVariable ["Player_Traits", []])) || (([player getVariable ["character_id",""]] call A3PL_Config_InCompany) && ((player getVariable ["job", ("STR_Common_Job_Unemployed" call A3PL_Localize)]) isEqualTo ("STR_Common_Company" call A3PL_Localize)) && ([player, "foodf"] call A3PL_Company_HasLicense)))}
	],
	["STR_Config_Interactions_Sell",
		{[cursorTarget] call A3PL_Business_Sell;},
		{(getObjectType cursorObject isEqualTo 8) && ((player getVariable ["character_id",""]) IN (cursorObject getVariable "owner") || ([player getVariable ["character_id",""]] call A3PL_Config_GetCompanyID) isEqualTo (cursorObject getVariable ["cid",0]))}
	],
	["STR_Config_Interactions_Buy",
		{[cursorTarget] call A3PL_Business_BuyItem;},
		{(cursorTarget isKindOf "All") && (!isNil {cursorTarget getVariable ["bitem",nil]})}
	],
	["STR_Config_Interactions_PlaceCone",
		{call A3PL_Placeables_PlaceCone;},
		{(typeOf (([] call A3PL_Lib_Attached) select 0)) isEqualTo "A3PL_RoadCone_x10"}
	],
	["STR_Config_Interactions_Urinate",
		{call A3PL_Player_Pee;},
		{(Pee_System == true) && (Player_Pee < 100) && (Player_ItemClass isEqualTo "") && (!(underwater(vehicle player))) && ((vehicle player) isEqualTo player) && (!(player getVariable ["Cuffed",false]) && !(player getVariable ["Zipped",false]))}
	],
	["STR_Config_Interactions_ExplodeVest",
		{call A3PL_Criminal_SuicideVest;},
		{(vest player) isEqualTo "A3PL_SuicideVest"}
	],
	["STR_Config_Interactions_Fabrication",
		{[] spawn A3PL_Combine_Open;},
		{!(surfaceIsWater position player) && (vehicle player == player) && (Player_ItemClass isEqualTo "")}
	],
	["STR_Config_Interactions_Traits",
		{[] call A3PL_Traits_Open;},
		{Activate_Traits && {!(surfaceIsWater position player)} && {vehicle player == player} && {Player_ItemClass isEqualTo ""}}
	],
	["STR_Config_Interactions_MedicalMenu",
		{[player] spawn A3PL_Medical_Open;},
		{(!isPlayer cursorObject) && (Player_ItemClass isEqualTo "") && !(underwater(vehicle player))}
	],
	["STR_Config_Interactions_PanicButton",
		{[] spawn A3PL_Police_Panic;},
		{(!isPlayer cursorObject) && ((player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) && {!(player getVariable ["panicActive",false])} && {!(player getVariable ["Cuffed",false])} && {!(player getVariable ["Zipped",false])}}
	],
	["STR_Config_Interactions_ReleaseHostage",
		{A3PL_EnableHostage = false;},
		{!isNil "A3PL_EnableHostage"}
	],
	["STR_Config_Interactions_WeaponForward",
		{A3PL_HostageMode = "shoot"},
		{
			if ((isNil "A3PL_EnableHostage") || (isNil "A3PL_HostageMode")) exitWith {false};
			if !(A3PL_HostageMode isEqualTo "hostage") exitWith {false};
			true;
		}
	],
	["STR_Config_Interactions_WeaponToHostage",
		{A3PL_HostageMode = "hostage"},
		{
			if ((isNil "A3PL_EnableHostage") || (isNil "A3PL_HostageMode")) exitWith {false};
			if !(A3PL_HostageMode isEqualTo "shoot") exitWith {false};
			true;
		}
	],
	["STR_Config_Interactions_Prospect",
		{call A3PL_JobWildCat_ProspectOpen},
		{!(isPlayer cursorObject) && (Player_ItemClass isEqualTo "") && ((vehicle player) isEqualTo player) && ((surfaceType getpos player) IN ["#cype_grass","#cype_forest","#cype_soil","#cype_beach","#GtdMud","#GtdDirt","#cype_beach"])&& (!(isOnRoad player)) && (!(player getVariable ["Cuffed",false])) && (!(player getVariable ["Zipped",false]))}
	],
	["STR_Config_Interactions_TestSoil",
		{[] spawn A3FL_JobFarming_TestSoil},
		{!(isPlayer cursorObject) && (Player_ItemClass isEqualTo "") && ((vehicle player) isEqualTo player) && ((surfaceType getpos player) IN ["#cype_grass","#cype_forest","#cype_soil","#cype_beach","#GtdMud","#GtdDirt","#cype_beach"])&& (!(isOnRoad player)) && (!(player getVariable ["Cuffed",false])) && (!(player getVariable ["Zipped",false])) && !(surfaceIsWater position player)}
	],
	["STR_Config_Interactions_HandsUp",
		{[player,true] call A3PL_Police_Surrender;},
		{(!isPlayer cursorObject) && (((vehicle player) isEqualTo player)) && (!(player getVariable ["Cuffed",false]) && !(player getVariable ["Zipped",false]))}
	],
	["STR_Config_Interactions_StopAnimation",
		{[player,true] call A3PL_Police_Surrender;},
		{((animationState player IN ["a3pl_idletohandsup","a3pl_kneeltohandsup"]) && (vehicle player isEqualTo player))}
	],
	["STR_Config_Interactions_Kneel",
		{[player,false] call A3PL_Police_Surrender;},
		{((animationState player IN ["a3pl_idletohandsup","a3pl_kneeltohandsup"]) && (vehicle player isEqualTo player))}
	],
	["STR_Config_Interactions_StandUp",
		{[player,true] call A3PL_Police_Surrender;},
		{((animationState player IN ["a3pl_handsuptokneel"]) && (vehicle player isEqualTo player))}
	],
	["STR_Config_Interactions_DeployParachute",
		{player action ["openParachute"];},
		{((backpack player) isKindOf "B_Parachute") && {!(player getVariable ["Cuffed",false])} && {!(player getVariable ["Zipped",false])}}
	],
	["STR_Config_Interactions_DigSand",
		{[] spawn A3PL_Resources_StartDigging;},
		{currentWeapon player isEqualTo "A3PL_Shovel" && ((vehicle player) isEqualTo player) && {(((getpos player) inArea "A3PL_Marker_Sand1")) || {(((getpos player) inArea "A3PL_Marker_Sand2"))} || ((surfaceType getPos player) isEqualTo "#cype_beach")}}
	],
	["STR_Config_Interactions_DigOutDOC",
		{[] spawn A3PL_Prison_DigOut;},
		{currentWeapon player isEqualTo "A3PL_Shovel" && ((vehicle player) isEqualTo player) && ((getpos player) inArea "A3PL_Marker_DOC_Escape")}
	],
	["STR_Config_Interactions_CheckMoney",
		{call A3PL_BHeist_CheckCash;},
		{((backpack player) isEqualTo "A3PL_Backpack_Money") && {!(player getVariable ["Cuffed",false])} && {!(player getVariable ["Zipped",false])}}
	],
	["STR_Config_Interactions_LockUnlockFurnitures",
		{
			if(!(call A3PL_Player_AntiSpam)) exitWith {};
			private _house = (player getVariable ["house",objNull]);
			[player,_house] remoteExec ["Server_Housing_LockUnlockFurnitures", 2];
		},
		{(player distance (player getVariable ["house",objNull]) < 8) && (vehicle player isEqualTo player)}
	],
	["STR_Config_Interactions_LockUnlockFurnitures",
		{
			if(!(call A3PL_Player_AntiSpam)) exitWith {};
			private _warehouse = (player getVariable ["warehouse",objNull]);
			[player,_warehouse] remoteExec ["Server_Warehouses_LockUnlockFurnitures", 2];
		},
		{(player distance (player getVariable ["warehouse",objNull]) < 8) && (vehicle player isEqualTo player)}
	],
	["STR_Config_Interactions_HouseStorage",
		{
			if(!(call A3PL_Player_AntiSpam)) exitWith {};
			private _house = (player getVariable ["house",objNull]);
			private _cd = _house getVariable ["storage_cooldown",0];
			if (serverTime < _cd) exitWith {[format[("STR_Config_Interactions_StorageCooldown" call A3PL_Localize),ceil(_cd - serverTime)],Color_Red] call A3PL_Notification;};
			[player,_house] remoteExec ["Server_Housing_LoadBox", 2];
		},
		{(player distance (player getVariable ["house",objNull]) < 8) && !(player distance (nearestObject [player, "Box_GEN_Equip_F"]) < 8) && (vehicle player isEqualTo player)}
	],
	["STR_Config_Interactions_StoreStorage",
		{
			if(!(call A3PL_Player_AntiSpam)) exitWith {};
			private _house = (player getVariable ["house",objNull]);
			private _box = nearestObjects [player, ["Box_GEN_Equip_F"], 10];
			if (count _box < 1) exitwith {["STR_Common_CannotFindStorage" call A3PL_Localize, Color_Red] call A3PL_Notification;};
			_box = _box select 0;
			if (_box getVariable ["inuse",false]) exitwith {["STR_Common_StorageInUse" call A3PL_Localize, Color_Red] call A3PL_Notification;};
			_house setVariable ["storage_cooldown",serverTime + 10,true];
			[_house,_box] remoteExec ["Server_Housing_SaveBox", 2];
		},
		{(player distance (nearestObject [player, "Box_GEN_Equip_F"]) < 10) && (player distance (player getVariable ["house",objNull]) < 10) }
	],
	["STR_Config_Interactions_WarehouseStorage",
		{
			if(!(call A3PL_Player_AntiSpam)) exitWith {};
			private _warehouse = (player getVariable ["warehouse",objNull]);
			private _cd = _warehouse getVariable ["storage_cooldown",0];
			if (serverTime < _cd) exitWith {[format[("STR_Config_Interactions_StorageCooldown" call A3PL_Localize),ceil(_cd - serverTime)],Color_Red] call A3PL_Notification;};
			[player,_warehouse] remoteExec ["Server_Warehouses_LoadBox", 2];
		},
		{(player distance (player getVariable ["warehouse",objNull]) < 10) && !(player distance (nearestObject [player, "Box_GEN_Equip_F"]) < 20) && (vehicle player isEqualTo player)}
	],
	["STR_Config_Interactions_StoreStorage",
		{
			if(!(call A3PL_Player_AntiSpam)) exitWith {};
			private _warehouse = (player getVariable ["warehouse",objNull]);
			private _box = nearestObjects [player, ["Box_GEN_Equip_F"], 20];
			if (count _box < 1) exitwith {["STR_Common_CannotFindStorage" call A3PL_Localize, Color_Red] call A3PL_Notification;};
			_box = _box select 0;
			if (_box getVariable ["inuse",false]) exitwith {["STR_Common_StorageInUseExclamation" call A3PL_Localize, Color_Red] call A3PL_Notification;};
			_warehouse setVariable ["storage_cooldown",serverTime + 10,true];
			[_warehouse,_box] remoteExec ["Server_Warehouses_SaveBox", 2];
		},
		{(player distance (player getVariable ["warehouse",objNull]) < 10) && (player distance (nearestObject [player, "Box_GEN_Equip_F"]) < 20)}
	],
	["STR_Config_Interactions_CrackhouseStorage",
		{
			if(!(call A3PL_Player_AntiSpam)) exitWith {};
			private _crackhouse = (player getVariable ["crackhouse",objNull]);
			private _cd = _crackhouse getVariable ["storage_cooldown",0];
			if (serverTime < _cd) exitWith {[format[("STR_Config_Interactions_StorageCooldown" call A3PL_Localize),ceil(_cd - serverTime)],Color_Red] call A3PL_Notification;};
			[player,_crackhouse] remoteExec ["Server_Crackhouses_LoadBox", 2];
		},
		{(player distance (player getVariable ["crackhouse",objNull]) < 10) && !(player distance (nearestObject [player, "Box_GEN_Equip_F"]) < 20) && (vehicle player isEqualTo player)}
	],
	["STR_Config_Interactions_StoreStorage",
		{
			if(!(call A3PL_Player_AntiSpam)) exitWith {};
			private _crackhouse = (player getVariable ["crackhouse",objNull]);
			private _box = nearestObjects [player, ["Box_GEN_Equip_F"], 20];
			if (count _box < 1) exitwith {["STR_Common_CannotFindStorage" call A3PL_Localize, Color_Red] call A3PL_Notification;};
			_box = _box select 0;
			if (_box getVariable ["inuse",false]) exitwith {["STR_Common_StorageInUseExclamation" call A3PL_Localize, Color_Red] call A3PL_Notification;};
			_crackhouse setVariable ["storage_cooldown",serverTime + 10,true];
			[_crackhouse,_box] remoteExec ["Server_Crackhouses_SaveBox", 2];
		},
		{(player distance (player getVariable ["crackhouse",objNull]) < 10) && (player distance (nearestObject [player, "Box_GEN_Equip_F"]) < 20)}
	],
	["STR_Config_Interactions_RaidHouseStorage",
		{
			[] spawn A3PL_Housing_Raid;
		},
		{((player getVariable ["job",""]) isEqualTo ("STR_Common_FISD" call A3PL_Localize)) && {(count (nearestObjects [player, Config_Houses_List, 10]) > 0)} && {!(player distance (nearestObject [player, "Box_GEN_Equip_F"]) < 20)} && {(vehicle player isEqualTo player)}}
	],
	["STR_Config_Interactions_RaidWarehouseStorage",
		{
			[] spawn A3PL_Warehouse_Raid;
		},
		{((player getVariable ["job",""]) isEqualTo ("STR_Common_FISD" call A3PL_Localize)) && {(count (nearestObjects [player, Config_Warehouses_List, 10]) > 0)} && {!(player distance (nearestObject [player, "Box_GEN_Equip_F"]) < 20)} && {(vehicle player isEqualTo player)}}
	],
	["STR_Config_Interactions_RaidCrackhouseStorage",
		{
			[] spawn A3PL_Crackhouse_Raid;
		},
		{((player getVariable ["job",""]) isEqualTo ("STR_Common_FISD" call A3PL_Localize)) && {(count (nearestObjects [player, Config_Crackhouses_List, 10]) > 0)} && {!(player distance (nearestObject [player, "Box_GEN_Equip_F"]) < 20)} && {(vehicle player isEqualTo player)}}
	],
	["STR_Config_Interactions_K9ComeToMe",
		{
			private _dog = player getVariable["Player_Dog",objNull];
			if(isNull _dog) exitWith {};
			_dog setPos (getPos player);
		},
		{!(isNull(player getVariable["Player_Dog",objNull]))}
	],
	["STR_Config_Interactions_K9FollowMe",
		{
			private _dog = player getVariable["Player_Dog",objNull];
			if(isNull _dog) exitWith {};
			_dog setVariable["Dog_Moving",true,true];
		},
		{!(isNull(player getVariable["Player_Dog",objNull]))}
	],
	["STR_Config_Interactions_K9WaitHere",
		{
			private _dog = player getVariable["Player_Dog",objNull];
			if(isNull _dog) exitWith {};
			_dog setVariable["Dog_Moving",false,true];
		},
		{!(isNull(player getVariable["Player_Dog",objNull]))}
	],
	["STR_Config_Interactions_Suicide",
		{[] spawn A3PL_Prison_Suicide;},
		{(Player_ItemClass isEqualTo "cyanide_pills")}
	],
	["STR_Config_Interactions_RepackMags",
		{[] spawn A3PL_Player_RepackMags;},
		{((magazines player) isNotEqualTo []) && {(vehicle player) isEqualTo player} && {!isPlayer cursorObject} && (!(player getVariable ["Cuffed",false])) && (!(player getVariable ["Zipped",false]))}
	],
	["STR_Config_Interactions_StandUp",
		{
			if(player getVariable["Cuffed",false] || {player getVariable["Zipped",false]}) then {
				[player,"a3pl_handsupkneelcuffed"] remoteExec ["A3PL_Lib_SyncAnim", -2];
			} else {
				[player,""] remoteExec ["A3PL_Lib_SyncAnim", -2];
			};
		},
		{animationState player IN ["hubsittingchairb_idle1","hubsittingchairb_idle2","hubsittingchairb_idle3","a3pl_bed"]}
	],
	["STR_Config_Interactions_CleanBlood",
		{
			[] spawn {
				Player_CurBloodOverlay = 0.9;
				Player_WipedBlood = true;
				["\A3PL_Common\GUI\medical\overlay_blood.paa",1,Player_CurBloodOverlay] call A3PL_HUD_SetOverlay;
				sleep 8;
				Player_WipedBlood = nil;
			};
		},
		{((player getVariable ["A3PL_Medical_Blood",5000]) isNotEqualTo 5000)}
	],
	["STR_Config_Interactions_StopEscorting",
		{player setVariable["escorting",nil]},
		{(player getVariable["escorting",false])}
	],
	["STR_Config_Interactions_StopDragging",
		{player setVariable["dragging",nil,true];},
		{(player getVariable["dragging",false])}
	],
	["STR_Config_Interactions_RemoveMask",
		{call A3PL_FD_MaskOff;},
		{(goggles player) == "A3PL_FD_Mask"}
	],
	["STR_Config_Interactions_CleanMask",
		{call A3PL_FD_SwipeMask;},
		{(goggles player) == "A3PL_FD_Mask"}
	],
	["STR_Config_Interactions_DropHose",
		{detach ([] call A3PL_Lib_AttachedFirst);},
		{(typeof ([] call A3PL_Lib_AttachedFirst)) IN ["A3PL_FD_HoseEnd1","A3PL_FD_HoseEnd2","A3PL_GasHose"]}
	],
	["STR_Config_Interactions_ThrowHose",
		{[([] call A3PL_Lib_AttachedFirst)] spawn A3PL_FD_ThrowHose;},
		{(typeof ([] call A3PL_Lib_AttachedFirst)) IN ["A3PL_FD_HoseEnd1","A3PL_FD_HoseEnd2","A3PL_GasHose"]}
	],
	["STR_Config_Interactions_MoveBox",
		{
			[A3FL_Seize_Storage,player] remoteExec ["A3PL_Lib_ChangeLocality", 2];
			[A3FL_Seize_Storage] call A3PL_Placeables_Pickup;
		},
		{((typeOf player_objintersect) isEqualTo "C_IDAP_supplyCrate_F") && {[("STR_Common_FISD" call A3PL_Localize)] call A3PL_Government_isFactionLeader}}
	],
	["STR_Config_Interactions_DeliverPackage",
		{call A3PL_Delivery_Deliver;},
		{private _found = false; {if ((typeOf _x) isEqualTo "A3PL_DeliveryBox") exitwith {_found = true; true;}} foreach ([player] call A3PL_Lib_AttachedAll); _found;}
	],
	["STR_Config_Interactions_ThrowPopcorn",
		{call A3PL_Items_ThrowPopcornClient;},
		{(player_itemclass == "popcornbucket" && (vehicle player == player))}
	],
	["STR_Common_TakeBall",
		{[player_objintersect] call A3PL_Bowling_PickupBall;},
		{(typeOf player_objintersect) isEqualTo "A3PL_Ball"}
	],
	["STR_Config_Interactions_ThrowBall",
		{[(([] call A3PL_Lib_Attached) select 0)] call A3PL_Bowling_ThrowBall;},
		{(typeOf (([] call A3PL_Lib_Attached) select 0)) isEqualTo "A3PL_Ball"}
	],
	["STR_Config_Interactions_DropBall",
		{detach (([] call A3PL_Lib_Attached) select 0);},
		{(typeOf (([] call A3PL_Lib_Attached) select 0)) isEqualTo "A3PL_Ball"}
	],
	["STR_Config_Interactions_ControlLadder",
		{[] spawn A3PL_FD_ControlLadder},
		{(typeOf (vehicle player)) isEqualTo "A3PL_Pierce_Heavy_Ladder" && gunner (vehicle player) isEqualTo player}
	],
	["STR_Config_Interactions_EndShift",
		{[] spawn A3PL_FD_ResetLadder},
		{(typeOf (vehicle player)) isEqualTo "A3PL_Pierce_Heavy_Ladder" && gunner (vehicle player) isEqualTo player}
	],
	["STR_Common_LockpickHandcuffs",
		{[player,1] spawn A3PL_Criminal_PickHandcuffs;},
		{((animationState player IN ["a3pl_handsuptokneel", "a3pl_handsupkneelgetcuffed", "a3pl_cuff", "a3pl_handsupkneelcuffed", "a3pl_handsupkneelkicked", "a3pl_cuffkickdown", "a3pl_idletohandsup", "a3pl_kneeltohandsup", "a3pl_handsuptokneel", "a3pl_handsupkneel"]) && (vehicle player isEqualTo player) && (["v_lockpick",1] call A3PL_Inventory_Has) && ("lockpick_handcuffs" in (player getVariable ["Player_Traits", []])))}
	]
];
publicVariable "A3PL_Interaction_Self";

A3PL_Interaction_Players =
[
	["STR_Config_Interactions_SetName",
		{[cursorObject] call A3PL_Player_OpenNametag;},
		{(vehicle player == player) && {(isPlayer cursorObject)} && {(player distance cursorObject < 5)} && {(profilenamespace getVariable ["Player_EnableID",true])}}
	],
	["STR_Config_Interactions_RecruitInstitution",
		{
			private _name = cursorObject getVariable "name";
			[(cursorObject getVariable ["character_id",""]), (player getVariable["faction","citizen"])] remoteExec ["A3PL_Player_Whitelist",cursorObject];
			[format[("STR_Common_RecruitedInstitution" call A3PL_Localize),_name],Color_Green] call A3PL_Notification;
		},
		{
			(isPlayer cursorObject) && {(cursorObject getVariable["faction","citizen"] isEqualTo "citizen")} && {((player getVariable["faction","citizen"]) IN [("STR_Common_FIFR" call A3PL_Localize),("STR_Common_FISD" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)])} && {([(player getVariable["faction","citizen"])] call A3PL_Government_isFactionLeader)}
		}
	],
	["STR_Config_Interactions_RecruitCompany",
		{
			private _target = cursorObject;
			private _charID = player getVariable ["character_id",""];
			private _cid = [_charID] call A3PL_Config_GetCompanyID;
			private _hasPerm = [_cid,"hire",_charID] call A3FL_Config_GetCompanyPermissions;
			private _isBoss = ([_charID] call A3PL_Config_IsCompanyBoss);
			if(!(_hasPerm) && !(_isBoss)) exitWith {["STR_Common_InsufficientPermissions" call A3PL_Localize, Color_Red] call A3PL_Notification;};
			[_cid, player] remoteExec ["A3PL_Company_HiringConfirmation",_target];
			[format[("STR_Common_InvitedToCompany" call A3PL_Localize),(_target getVariable ["name","John Doe"])],Color_Green] call A3PL_Notification;
		},
		{(isPlayer cursorObject) && {!([cursorObject getVariable ["character_id",""]] call A3PL_Config_InCompany)}}
	],
	["STR_Config_Interactions_ShareMap",
		{[cursorObject] call A3PL_JobWildCat_ShareMap;},
		{
			(isPlayer cursorObject) && 
			{(player distance cursorObject < 5)} && 
			{
				private _playerMaps = player getVariable ["A3PL_JobWildcat_Maps", []];
				private _validMaps = [];
				{
					if (count _x >= 4) then {
						private _expireTime = _x select 3;
						if (diag_tickTime < _expireTime) then {
							_validMaps pushBack _x;
						};
					};
				} forEach _playerMaps;
				(count _validMaps) > 0
			}
		}
	],
	["STR_Config_Interactions_NewRoommateHouse",
		{
			private _house = (nearestObjects [getPos player, Config_Houses_List, 10,true]) select 0;
			private _charIDs = _house getVariable ["owner",[]];
			if(count _charIDs isEqualTo 0) exitwith {["STR_Common_HouseNoOwner" call A3PL_Localize, Color_Red] call A3PL_Notification;};
			_charID = _charIDs select 0;
			if((player getVariable ["character_id",""]) isEqualTo _charID) then {
				[player, cursorObject, _house] remoteExec ["Server_Housing_AddMember",2];
				private _namePos = [getPos _house] call A3PL_Housing_PosAddress;
				[format[("STR_Common_AddedRoommate" call A3PL_Localize),_namePos],Color_Green] call A3PL_Notification;
			} else {
				["STR_Common_OnlyOwnerCanAddRoommate" call A3PL_Localize, Color_Red] call A3PL_Notification;
			};
		},
		{
			private _house = nearestObjects [getPos player, Config_Houses_List, 10,true];
			private _var = cursorObject getVariable "house";
			if(((count _house) > 0) && (isPlayer cursorObject) && (isNil "_var")) then {true;} else {false;};
		}
	],
	["STR_Config_Interactions_NewRoommateWarehouse",
		{
			private _warehouse = (nearestObjects [getPos player, Config_Warehouses_List, 10,true]) select 0;
			private _charIDs = _warehouse getVariable ["owner",[]];
			if(count _charIDs isEqualTo 0) exitwith {["STR_Common_WarehouseNoOwner" call A3PL_Localize, Color_Red] call A3PL_Notification;};
			_charID = _charIDs select 0;
			if((player getVariable ["character_id",""]) isEqualTo _charID) then {
				[player, cursorObject, _warehouse] remoteExec ["Server_Warehouses_AddMember",2];
				private _namePos = [getPos _warehouse] call A3PL_Housing_PosAddress;
				[format[("STR_Common_AddedRoommate" call A3PL_Localize),_namePos],Color_Green] call A3PL_Notification;
			} else {
				["STR_Common_OnlyOwnerCanAddWarehouseRoommate" call A3PL_Localize, Color_Red] call A3PL_Notification;
			};
		},
		{
			private _warehouse = nearestObjects [getPos player, Config_Warehouses_List, 10,true];
			private _var = cursorObject getVariable "warehouse";
			if(((count _warehouse) > 0) && (isPlayer cursorObject) && (isNil "_var")) then {true;} else {false;};
		}
	],
	["STR_Config_Interactions_NewRoommateCrackhouse",
		{
			private _crackhouse = (nearestObjects [getPos player, Config_Crackhouses_List, 10,true]) select 0;
			private _charIDs = _crackhouse getVariable ["owner",[]];
			if(count _charIDs isEqualTo 0) exitwith {["STR_Common_CrackhouseNoOwner" call A3PL_Localize, Color_Red] call A3PL_Notification;};
			_charID = _charIDs select 0;
			if((player getVariable ["character_id",""]) isEqualTo _charID) then {
				[player, cursorObject, _crackhouse] remoteExec ["Server_Crackhouses_AddMember",2];
				private _namePos = [getPos _crackhouse] call A3PL_Housing_PosAddress;
				[format[("STR_Common_AddedRoommate" call A3PL_Localize),_namePos],Color_Green] call A3PL_Notification;
			} else {
				["STR_Common_OnlyOwnerCanAddCrackhouseRoommate" call A3PL_Localize, Color_Red] call A3PL_Notification;
			};
		},
		{
			private _crackhouse = nearestObjects [getPos player, Config_Crackhouses_List, 10,true];
			private _var = cursorObject getVariable "crackhouse";
			if(((count _crackhouse) > 0) && (isPlayer cursorObject) && (isNil "_var")) then {true;} else {false;};
		}
	],
	["STR_Config_Interactions_RemoveRoommateHouse",
		{
			private _house = (nearestObjects [getPos player, Config_Houses_List, 10,true]) select 0;
			private _charIDs = _house getVariable ["owner",[]];
			if(count _charIDs isEqualTo 0) exitwith {["STR_Common_HouseNoOwner" call A3PL_Localize, Color_Red] call A3PL_Notification;};
			_charID = _charIDs select 0;
			if((player getVariable ["character_id",""]) isEqualTo _charID) then {
				private _namePos = [getPos _house] call A3PL_Housing_PosAddress;
				[cursorObject, _house] remoteExec ["Server_Housing_RemoveMember",2];
				[format[("STR_Common_RemovedRoommate" call A3PL_Localize),_namePos],Color_Green] call A3PL_Notification;
			} else {
				["STR_Common_OnlyOwnerCanRemoveRoommate" call A3PL_Localize, Color_Red] call A3PL_Notification;
			};
		},
		{private _house = player nearEntities [Config_Houses_List,10]; if(((count _house) > 0) && (isPlayer cursorObject)) exitWith {true;};}
	],
	["STR_Config_Interactions_RemoveRoommateWarehouse",
		{
			private _warehouse = (nearestObjects [getPos player, Config_Warehouses_List, 10,true]) select 0;
			private _charIDs = _warehouse getVariable ["owner",[]];
			if(count _charIDs isEqualTo 0) exitwith {["STR_Common_WarehouseNoOwner" call A3PL_Localize, Color_Red] call A3PL_Notification;};
			_charID = _charIDs select 0;
			if((player getVariable ["character_id",""]) isEqualTo _charID) then {
				private _namePos = [getPos _warehouse] call A3PL_Housing_PosAddress;
				[cursorObject, _warehouse] remoteExec ["Server_Warehouses_RemoveMember",2];
				[format[("STR_Common_RemovedRoommate" call A3PL_Localize),_namePos],Color_Green] call A3PL_Notification;
			} else {
				["STR_Common_OnlyOwnerCanRemoveRoommate" call A3PL_Localize, Color_Red] call A3PL_Notification;
			};
		},
		{private _warehouse = player nearEntities [Config_Warehouses_List,10]; if(((count _warehouse) > 0) && (isPlayer cursorObject)) exitWith {true;};}
	],
	["STR_Config_Interactions_RemoveRoommateCrackhouse",
		{
			private _crackhouse = (nearestObjects [getPos player, Config_Crackhouses_List, 10,true]) select 0;
			private _charIDs = _crackhouse getVariable ["owner",[]];
			if(count _charIDs isEqualTo 0) exitwith {["STR_Common_CrackhouseNoOwner" call A3PL_Localize, Color_Red] call A3PL_Notification;};
			_charID = _charIDs select 0;
			if((player getVariable ["character_id",""]) isEqualTo _charID) then {
				private _namePos = [getPos _crackhouse] call A3PL_Housing_PosAddress;
				[cursorObject, _crackhouse] remoteExec ["Server_Crackhouses_RemoveMember",2];
				[format[("STR_Common_RemovedRoommate" call A3PL_Localize),_namePos],Color_Green] call A3PL_Notification;
			} else {
				["STR_Common_OnlyOwnerCanRemoveCrackhouseRoommate" call A3PL_Localize, Color_Red] call A3PL_Notification;
			};
		},
		{private _crackhouse = player nearEntities [Config_Crackhouses_List,10]; if(((count _crackhouse) > 0) && (isPlayer cursorObject)) exitWith {true;};}
	],
	["STR_Config_Interactions_CheckPapers",
		{[cursorObject] remoteExec ["A3PL_Hud_IDCard",player];},
		{(cursorobject isKindOf "Man") && {!(cursorobject getVariable["A3PL_Medical_Alive", true])}}
	],
	["STR_Config_Interactions_LicenseMenu",
		{call A3PL_DMV_Open;},
		{(vehicle player isEqualTo player) && {isPlayer cursorObject} && {((player getVariable ["job", ("STR_Common_Job_Unemployed" call A3PL_Localize)]) IN [("STR_Common_FIFR" call A3PL_Localize), ("STR_Common_DOJ" call A3PL_Localize), ("STR_Common_FISD" call A3PL_Localize), "fbi", ("STR_Common_GOV" call A3PL_Localize)]) || (((player getVariable ["job", ("STR_Common_Job_Unemployed" call A3PL_Localize)]) isEqualTo ("STR_Common_Company" call A3PL_Localize)) && ([player,"dmv"] call A3PL_Company_HasLicense))}}
	],
	["STR_Config_Interactions_TakeHostage",
		{[cursorobject] spawn A3PL_Player_TakeHostage;},
		{(cursorobject getVariable ["A3PL_Medical_Alive",true]) && (!(player getVariable ["Cuffed",false])) && (!(player getVariable ["Zipped",false])) && (isNil "A3PL_EnableHostage") && (isPlayer cursorObject) && (player distance cursorobject < 2) && (([cursorobject, player] call BIS_fnc_relativeDirTo) < 220) && (([cursorobject, player] call BIS_fnc_relativeDirTo) > 130) && !(cursorObject getVariable["takingHostage",false]) && !(cursorObject getVariable ["pVar_RedNameOn",false]) && ((currentWeapon player) isNotEqualTo "")}
	],
	["STR_Config_Interactions_ShowIdentity",
		{if(!(call A3PL_Player_AntiSpam)) exitWith {}; [player] remoteExec ["A3PL_Hud_IDCard",cursorObject];},
		{(cursorobject getVariable ["A3PL_Medical_Alive",true]) && (isPlayer cursorObject) && (player distance cursorObject < 3)}
	],
	["STR_Config_Interactions_ShowFakeIdentity",
		{if(!(call A3PL_Player_AntiSpam)) exitWith {}; [player,"citizen",true] remoteExec ["A3PL_Hud_IDCard",cursorObject];},
		{(cursorobject getVariable ["A3PL_Medical_Alive",true]) && (isPlayer cursorObject) && (player distance cursorObject < 3) && {!isNil {player getVariable"fakeName"}}}
	],
	["STR_Config_Interactions_ShowFISDBadge",
		{if(!(call A3PL_Player_AntiSpam)) exitWith {}; [player,("STR_Common_FISD" call A3PL_Localize)] remoteExec ["A3PL_Hud_IDCard",cursorObject];},
		{(cursorobject getVariable ["A3PL_Medical_Alive",true]) && ((player getVariable["faction","citizen"]) isEqualTo ("STR_Common_FISD" call A3PL_Localize)) && (isPlayer cursorObject) && (player distance cursorObject < 3)}
	],
	["STR_Config_Interactions_ShowFIFRBadge",
		{if(!(call A3PL_Player_AntiSpam)) exitWith {}; [player,("STR_Common_FIFR" call A3PL_Localize)] remoteExec ["A3PL_Hud_IDCard",cursorObject];},
		{(cursorobject getVariable ["A3PL_Medical_Alive",true]) && ((player getVariable["faction","citizen"]) isEqualTo ("STR_Common_FIFR" call A3PL_Localize)) && (isPlayer cursorObject) && (player distance cursorObject < 3)}
	],
	["STR_Config_Interactions_ShowDOJBadge",
		{if(!(call A3PL_Player_AntiSpam)) exitWith {}; [player,("STR_Common_DOJ" call A3PL_Localize)] remoteExec ["A3PL_Hud_IDCard",cursorObject];},
		{(cursorobject getVariable ["A3PL_Medical_Alive",true]) && ((player getVariable["faction","citizen"]) isEqualTo ("STR_Common_DOJ" call A3PL_Localize)) && (isPlayer cursorObject) && (player distance cursorObject < 3)}
	],
	["STR_Config_Interactions_ShowGOVBadge",
		{if(!(call A3PL_Player_AntiSpam)) exitWith {}; [player,("STR_Common_GOV" call A3PL_Localize)] remoteExec ["A3PL_Hud_IDCard",cursorObject];},
		{(cursorobject getVariable ["A3PL_Medical_Alive",true]) && ((player getVariable["faction","citizen"]) isEqualTo ("STR_Common_GOV" call A3PL_Localize)) && (isPlayer cursorObject) && (player distance cursorObject < 3)}
	],
	["STR_Config_Interactions_ShowCompanyBadge",
		{if(!(call A3PL_Player_AntiSpam)) exitWith {}; [player,"company"] remoteExec ["A3PL_Hud_IDCard",cursorObject];},
		{(cursorobject getVariable ["A3PL_Medical_Alive",true]) && ([player getVariable ["character_id",""]] call A3PL_Config_InCompany) && ((player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) isEqualTo ("STR_Common_Company" call A3PL_Localize)) && (isPlayer cursorObject) && (player distance cursorObject < 3)}
	],
	["STR_Config_Interactions_ShowMirandaRights",
		{if(!(call A3PL_Player_AntiSpam)) exitWith {}; [] remoteExec ["A3PL_Police_MirandaCard",cursorObject];},
		{(cursorobject getVariable ["A3PL_Medical_Alive",true]) && ((player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize)]) && (isPlayer cursorObject) && (player distance cursorObject < 3)}
	],
	["STR_Config_Interactions_TakeIdentity",
		{
			private _target = cursorObject;
			if(!isNil {_target getVariable "fakeName"}) then {[cursorObject,"citizen",true] spawn A3PL_Hud_IDCard;} else {[cursorObject] spawn A3PL_Hud_IDCard;};
		},
		{(isPlayer cursorObject) && (player distance cursorObject < 3) && animationState cursorObject IN ["a3pl_handsuptokneel","a3pl_handsupkneelgetcuffed","a3pl_cuff","a3pl_handsupkneelcuffed","a3pl_handsupkneelkicked","a3pl_cuffkickdown","a3pl_idletohandsup","a3pl_kneeltohandsup","a3pl_handsuptokneel","a3pl_handsupkneel"]}
	],
	["STR_Config_Interactions_Imprison",
		{[cursorObject] call A3PL_Police_StartJailPlayer},
		{(vehicle player isEqualTo player) && (isPlayer cursorObject) && ((player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) IN [("STR_Common_FISD" call A3PL_Localize)]) && (count(nearestObjects [player, ["Land_A3PL_Prison"],50]) > 0)}
	],
	["STR_Config_Interactions_WriteFine",
		{call A3PL_Police_OpenTicketMenu;},
		{(vehicle player isEqualTo player) && (isPlayer cursorObject) && ((player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) IN [("STR_Common_FISD" call A3PL_Localize)]) && (player_itemclass isEqualTo "") || {player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] isEqualTo ("STR_Common_FIFR" call A3PL_Localize) && ("fifrmarshal" IN (player getVariable ["licenses",[]]))}}
	],
	["STR_Config_Interactions_PutAnkleBracelet",
		{
			private _charID = cursorObject getVariable ["character_id",""];
			Server_Jail_Markers_charIDs pushBack _charID;
			publicVariable "Server_Jail_Markers_charIDs";
			["Server_Jail_Markers_charIDs",true] remoteExec ["Server_Core_SavePersistentVar"];
			["STR_Common_AnkleBraceletAdded", Color_Red] remoteExec ["A3PL_Notification",cursorObject];
			[format[("STR_Common_AnkleBraceletAddedSuccess" call A3PL_Localize),cursorObject getVariable["name","unknown"]], Color_green] call A3PL_Notification;
		},
		{((vehicle player) isEqualTo player) && (player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] isEqualTo ("STR_Common_FISD" call A3PL_Localize)) && (isPlayer cursorObject) && !((cursorObject getVariable ["character_id",""]) IN Server_Jail_Markers_charIDs)}
	],
	["STR_Config_Interactions_RemoveAnkleBracelet",
		{
			private _charID = cursorObject getVariable ["character_id",""];
			Server_Jail_Markers_charIDs deleteAt (Server_Jail_Markers_charIDs find _charID);
			publicVariable "Server_Jail_Markers_charIDs";
			["Server_Jail_Markers_charIDs",true] remoteExec ["Server_Core_SavePersistentVar"];
			["STR_Common_AnkleBraceletRemoved", Color_Red] remoteExec ["A3PL_Notification",cursorObject];
			[format[("STR_Common_AnkleBraceletRemovedSuccess" call A3PL_Localize),cursorObject getVariable["name","unknown"]], Color_green] call A3PL_Notification;
		},
		{((vehicle player) isEqualTo player) && (player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] isEqualTo ("STR_Common_FISD" call A3PL_Localize)) && (isPlayer cursorObject) && ((cursorObject getVariable ["character_id",""]) IN Server_Jail_Markers_charIDs)}
	],
	["STR_Config_Interactions_RemovePrisonSentence",
		{
			private _target = cursorObject;
			_target setVariable ["jail_mark",false,true];
			_target setVariable ["jailed",false,true];
			_target setVariable ["jailtime",nil,true];
			[_target] remoteExec ["Server_Criminal_RemoveJail",2];
		},
		{((vehicle player) isEqualTo player) && (player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] isEqualTo ("STR_Common_FISD" call A3PL_Localize)) && (isPlayer cursorObject) && ((cursorObject getVariable ["character_id",""]) IN Server_Jail_Markers_charIDs)}
	],
	["STR_Config_Interactions_PickAnkleBracelet",
		{
			[cursorObject] spawn A3FL_Criminal_PickAnkleMonitor;
		},
		{((vehicle player) isEqualTo player) && (player_Itemclass isEqualTo "v_lockpick") && (isPlayer cursorObject) && ((cursorObject getVariable ["character_id",""]) IN Server_Jail_Markers_charIDs) && ("lockpick_ankle" in (player getVariable ["Player_Traits", []]))}
	],
	["STR_Config_Interactions_Breathalyzer",
		{[cursorObject] call A3PL_Police_Breathalizer;},
		{(player_ItemClass isEqualTo "breathalizer") && {isPlayer cursorObject}}
	],
	["STR_Config_Interactions_DrugTest",
		{[cursorObject] call A3PL_Drugs_DrugTest;},
		{(player_ItemClass isEqualTo "drug_kit") && {isPlayer cursorObject}}
	],
	["STR_Config_Interactions_PowderTest",
		{[cursorObject] call A3PL_Police_CheckPowder;},
		{(player_ItemClass isEqualTo "powdertestkit") && {isPlayer cursorObject}}
	],
	["STR_Config_Interactions_Blindfold",
		{
			private _target = cursorObject;
			if ([player, "G_Blindfold_01_black_F"] call BIS_fnc_hasItem) exitWith {
				player removeItem "G_Blindfold_01_black_F";
				_target addGoggles "G_Blindfold_01_black_F";
				_target setVariable["Blindfolded",true,true];
			};
			if ([player, "G_Blindfold_01_white_F"] call BIS_fnc_hasItem) exitWith {
				player removeItem "G_Blindfold_01_white_F";
				_target addGoggles "G_Blindfold_01_white_F";
				_target setVariable["Blindfolded",true,true];
			};
		},
		{(!(player getVariable["Zipped",false])) && (!(player getVariable["Cuffed",false])) && (([player, "G_Blindfold_01_black_F"] call BIS_fnc_hasItem) || ([player, "G_Blindfold_01_white_F"] call BIS_fnc_hasItem)) && (!(cursorObject getVariable["Blindfolded",false])) && ((cursorObject getVariable["Zipped",false]) || (cursorObject getVariable["Cuffed",false]))}
	],
	["STR_Config_Interactions_RemoveBlindfold",
		{
			private _target = cursorObject;
			private _goggles = goggles _target;
			private _blindfolds = ["G_Blindfold_01_black_F","G_Blindfold_01_white_F"];
			if (_goggles IN _blindfolds) then {
				removeGoggles _target;
				player addItem _goggles;
				_target setVariable["Blindfolded",false,true];
			};
		},
		{(cursorObject getVariable["Blindfolded",false]) && (!(player getVariable["Zipped",false])) && (!(player getVariable["Cuffed",false]))}
	]
];
publicVariable "A3PL_Interaction_Players";

A3PL_Interaction_VehIn =
[
	["STR_Config_Interactions_ToggleRHIBLight",
		{
			_lightObj = (vehicle player) getVariable["rhib_light",objNull];
			if(isNull(_lightObj)) then {
				_lightObj = createVehicle ["A3PL_Camping_Light", [0,0,0], [], 0, 'CAN_COLLIDE'];
				_lightObj attachTo [(vehicle player), [0.08,-0.65,0.7]];
				(vehicle player) setVariable["rhib_light",_lightObj,true];
				["Camper_Light",-1] call A3PL_Inventory_Add;
			} else {
				["Camper_Light",1] call A3PL_Inventory_Add;
				deleteVehicle(_lightObj);
			};
		},
		{(typeOf (vehicle player) isEqualTo "A3PL_RHIB") && {((["Camper_Light",1] call A3PL_Inventory_Has) || {!isNull((vehicle player) getVariable["rhib_light",objNull])})}}
	],
	["STR_Config_Interactions_FarmSand",
		{[] spawn A3PL_Resources_StartClawing;},
		{(vehicle player) currentWeaponTurret [0] isEqualTo "A3PL_Machinery_Bucket" && (typeOf (vehicle player)) isEqualTo "A3PL_MiniExcavator" && {(((getpos player) inArea "A3PL_Marker_Sand1")) || {(((getpos player) inArea "A3PL_Marker_Sand2"))}}}
	],
	["STR_Config_Interactions_ExitCrane",
		{player action ["eject",vehicle player];},
		{((typeOf (vehicle player)) isEqualTo "A3PL_MobileCrane")}
	],
	["STR_Config_Interactions_ResetCrane",
		{call A3PL_IE_CraneReset;},
		{((typeOf (vehicle player)) isEqualTo "A3PL_MobileCrane")}
	],
	["STR_Config_Interactions_CraneControls",
		{
			["STR_Config_Interactions_CraneControlsArrows" call A3PL_Localize, Color_Yellow] call A3PL_Notification;
			["STR_Config_Interactions_CraneControlsPageUpDown" call A3PL_Localize, Color_Yellow] call A3PL_Notification;
			["STR_Config_Interactions_CraneControlsHomeEnd" call A3PL_Localize, Color_Yellow] call A3PL_Notification;
			["STR_Config_Interactions_CraneControlsDelIns" call A3PL_Localize, Color_Yellow] call A3PL_Notification;
			["STR_Config_Interactions_CraneControlsCommaPoint" call A3PL_Localize, Color_Yellow] call A3PL_Notification;
			["STR_Config_Interactions_CraneControlsSpace" call A3PL_Localize, Color_Yellow] call A3PL_Notification;
		},
		{(typeOf vehicle player) isEqualTo "A3PL_MobileCrane"}
	],
	["STR_Config_Interactions_ConfigTaxiFare",
		{call A3PL_JobTaxi_SetupFare;},
		{(typeOf (vehicle player) isEqualTo "A3PL_CVPI_Taxi") && ((driver (vehicle player)) isEqualTo player)}
	],
	["STR_Config_Interactions_VehicleInventory",
		{
			private _veh = vehicle player;
			if([typeOf(_veh)] call A3PL_Config_HasStorage) then {[_veh] call A3PL_Vehicle_OpenStorage;};
		},
		{((vehicle player) isNotEqualTo player) && ([typeOf(vehicle player)] call A3PL_Config_HasStorage) && (!(player getVariable ["Cuffed",false]) && !(player getVariable ["Zipped",false])) && (Player_ItemClass isEqualTo "") && {!(vehicle player getVariable ["locked",true])}}
	],
	["STR_Config_Interactions_Lock",
		{
			(vehicle player) setVariable ["locked",true,true];
			["STR_Common_VehicleLocked" call A3PL_Localize, Color_Red] call A3PL_Notification;
			playSound3D ["A3PL_Cars\Common\Sounds\A3PL_Car_Lock.ogg", (vehicle player), true, (vehicle player), 3, 1, 30];
		},
		{(!isNull objectParent player) && {(vehicle player) IN A3PL_Player_Vehicles} && {!(vehicle player getVariable ["locked",true])}}
	],
	["STR_Config_Interactions_Unlock",
		{
			(vehicle player) setVariable ["locked",false,true];
			["STR_Common_VehicleUnlocked" call A3PL_Localize, Color_Green] call A3PL_Notification;
			playSound3D ["A3PL_Common\effects\carunlock.ogg", (vehicle player), true, (vehicle player), 3, 1, 30];
		},
		{(!isNull objectParent player) && {(vehicle player getVariable ["locked",true])}  && (!(player getVariable ["Cuffed",false]) && !(player getVariable ["Zipped",false]))}
	],
	["STR_Config_Interactions_ExitBoat",
		{
			private _veh = vehicle player;
			_veh lock 1;
			player action ["getOut",_veh];
			_veh lock 2;
		},
		{((vehicle player) isKindOf "Ship") && (!(player getVariable ["Cuffed",false]) && !(player getVariable ["Zipped",false]))}
	],
	["STR_Config_Interactions_EnterHelicopter",
		{
			[] spawn {
				private _veh = vehicle player;
				private _heli = (vehicle player) getVariable ["vehicle",objNull];
				private _crew = crew _heli;
				private _available = true;
				if (isNull _heli) exitwith {["STR_Common_HelicopterNotFound" call A3PL_Localize, Color_Red] call A3PL_Notification;};
				{if ((_heli getCargoIndex _x) isEqualTo 6) exitwith {_available = false;};} foreach (crew _heli);
				if (!_available) exitwith {["STR_Common_CannotEnterHelicopterBasket" call A3PL_Localize, Color_Red] call A3PL_Notification;};
				_veh lock 0;
				player action ["GetOut", _veh];
				sleep 1.5;
				_veh lock 0;
				player moveInCargo [_heli, 6];
			};
		},
		{(("A3PL_RescueBasket" isEqualTo (typeOf (vehicle player))))}
	],
	["STR_Config_Interactions_ToggleStaticFlight",
		{
			private _veh = vehicle player;
			if (isAutoHoverOn _veh) then {
				player action ["autoHoverCancel", _veh];
			} else {
				player action ["autoHover", _veh];
			};
		},
		{(((vehicle player) isKindOf "Helicopter")) && (((player isEqualTo (vehicle player turretUnit [0]))) OR (player isEqualTo (driver vehicle player)))}
	],
	["STR_Config_Interactions_Transponder",
		{call A3PL_ATC_Transponder;},
		{(((vehicle player) isKindOf "Air")) && (((player isEqualTo (vehicle player turretUnit [0]))) OR (player isEqualTo (driver vehicle player)))}
	],
	["STR_Config_Interactions_ToggleLockControls",
		{
			private _veh = vehicle player;
			if (!isCopilotEnabled _veh) then {
				_veh enableCopilot true;
				player action ["UnlockVehicleControl", _veh];
				["STR_Common_ControlsUnlocked" call A3PL_Localize, Color_Green] call A3PL_Notification;
			} else {
				_veh enableCopilot false;
				player action ["SuspendVehicleControl", _veh];
				player action ["LockVehicleControl", _veh];
				["STR_Common_ControlsLocked" call A3PL_Localize, Color_Green] call A3PL_Notification;
			};
		},
		{(((vehicle player) isKindOf "Air") && (player isEqualTo (driver (vehicle player))))}
	],
	["STR_Config_Interactions_TakeControl",
		{player action ["TakeVehicleControl", (vehicle player)];},
		{(((vehicle player) isKindOf "Air") && (player isEqualTo (vehicle player turretUnit [0])) && (isCopilotEnabled vehicle player))}
	],
	["STR_Config_Interactions_ReleaseControl",
		{player action ["SuspendVehicleControl", (vehicle player)];},
		{(((vehicle player) isKindOf "Air") && (player isEqualTo (vehicle player turretUnit [0])) && (isCopilotEnabled vehicle player))}
	],
	["STR_Config_Interactions_ResetVelocity",
		{(vehicle player) setVelocity [0,0,0];},
		{(local (vehicle player)) && ((vehicle player) isKindOf "Plane") && ((speed vehicle player) < 10)}
	],
	["STR_Common_ExitVehicle",
		{
			private _seatbelt = player getVariable ["SeatbeltOn",false];
			if (_seatbelt) exitWith {["STR_Common_MustRemoveSeatbelt" call A3PL_Localize, Color_Red] call A3PL_Notification;};
			if (((speed vehicle player) < 1) && (vehicle player getVariable ["EngineOn",0] isEqualTo 0)) then {
				player action ["GetOut", (vehicle player)];
				[] spawn {if ((player getVariable ["Cuffed",false]) || {player getVariable ["Zipped",false]}) then {sleep 1.5;player setVelocityModelSpace [0,3,1];[player,"a3pl_handsupkneelcuffed"] remoteExec ["A3PL_Lib_SyncAnim",-2];};};
			} else {
				player action ["eject", (vehicle player)];
				[] spawn {if ((player getVariable ["Cuffed",false]) || {player getVariable ["Zipped",false]}) then {sleep 1.5;player setVelocityModelSpace [0,3,1];[player,"a3pl_handsupkneelcuffed"] remoteExec ["A3PL_Lib_SyncAnim",-2];};};
			};
		},
		{((vehicle player) isNotEqualTo player) && (!(vehicle player getVariable ["locked",true])) && (!(vehicle player getVariable ["trapped",false])) && {!(player getVariable ["Cuffed",false]) && {!(player getVariable ["Zipped",false])}} && (!((vehicle player) isKindOf "Ship"))}
	],
	["STR_Config_Interactions_ExitStretcher",
		{
			player action ["GetOut", (vehicle player)];
			if ((player getVariable ["Cuffed",false]) || {player getVariable ["Zipped",false]}) then {
				[] spawn {sleep 1.5;player setVelocityModelSpace [0,3,1];[player,"a3pl_handsupkneelcuffed"] remoteExec ["A3PL_Lib_SyncAnim",-2];};
			};
		},
		{(typeOf(vehicle player) isEqualTo "A3FL_Strecther")}
	],
	["STR_Config_Interactions_PushForward",
		{
			private _veh = vehicle player;
			private _vel = velocity _veh;
			private _dir = direction _veh;
			private _speed = 5;
			if((_veh getHit "hitengine") == 1) exitWith {["STR_Common_CannotPushDamagedPlane" call A3PL_Localize, Color_Red] call A3PL_Notification;};
			_veh setVelocity [
				(_vel select 0) + (sin _dir * _speed),
				(_vel select 1) + (cos _dir * _speed),
				(_vel select 2)
			];
		},
		{((vehicle player) isKindOf "Plane") && (local (vehicle player))}
	],
	["STR_Config_Interactions_PushBackward",
		{
			private _veh = vehicle player;
			private _vel = velocity _veh;
			private _dir = direction _veh;
			private _speed = -5;
			if(_veh getHit "hitengine" == 1) exitWith {["STR_Common_CannotPushDamagedPlane" call A3PL_Localize, Color_Red] call A3PL_Notification;};
			_veh setVelocity [
				(_vel select 0) + (sin _dir * _speed),
				(_vel select 1) + (cos _dir * _speed),
				(_vel select 2)
			];
		},
		{((vehicle player) isKindOf "Plane") && (local (vehicle player))}
	],
	["STR_Config_Interactions_ToggleSpotlight",
		{
			private _veh = vehicle player;
			if (_veh animationSourcePhase "Spotlight" < 0.5) then {
				_veh animateSource ["Spotlight",1];
				if (_veh animationSourcePhase "Head_Lights" < 0.5) then{player action ["lightOn",_veh];};
			} else {
				_veh animateSource ["Spotlight",0];
				if (_veh animationSourcePhase "Head_Lights" < 0.5) then{player action ["lightOff",_veh];};
			};
		},
		{(typeOf (vehicle player) IN ["A3PL_Jayhawk","A3FL_AS_365","Heli_Medium01_Medic_H","Heli_Medium01_Sheriff_H"]) && (player isEqualTo ((vehicle player) turretUnit [0]))}
	],
	["STR_Config_Interactions_ToggleRescueBasket",
		{
			private _veh = vehicle player;
   			private _basket = _veh getVariable ["basket",objNull];
    		private _isOut = !isNull _basket || {_veh animationPhase "Basket" > 0.5};
    		if(_isOut) then {
        		if ((count (crew _basket)) > 0) exitwith {["STR_Config_Interactions_CannotRescueBasketWithOccupants" call A3PL_Localize, Color_Red] call A3PL_Notification;};
        		{ropeDestroy _x;} foreach (ropes _veh);
        		deleteVehicle _basket;
        		_veh animate ["Basket",0];
    		} else {
        		_veh animate ["Basket",1];

        		private _basket = "A3PL_RescueBasket" createVehicle [0,0,0];
        		_basket allowdamage false;
        		_basket setVariable ["locked",false,true];
        		_basket setVariable ["vehicle",_veh,true];
        		_veh setVariable ["basket",_basket,true];
        		[_basket,_veh] remoteExec ["A3PL_Lib_ChangeLocality", 2];
        		_basket setPos (_veh modelToWorld [4,2,-1]);
        		ropeCreate [_veh, "rope", _basket, [-0.3, 0.2, 0.25], 3];
   			 };
		},
		{((typeOf (vehicle player) isEqualTo "A3PL_Jayhawk") && ((player isEqualTo ((vehicle player) turretUnit [0])) OR (player isEqualTo ((vehicle player) turretUnit [1])) OR (player == (driver vehicle player))) && ((speed vehicle player) < 30))}
	],
	["STR_Config_Interactions_IncreaseRopeLength",
		{
			private _veh = vehicle player;
			if ((typeOf _veh) != "A3PL_Jayhawk") exitwith {};
			if ((count (ropes _veh)) < 1) exitwith {};
			ropeUnwind [(ropes _veh) select 0,2,(ropeLength ((ropes _veh) select 0)) + 15];
		},
		{((typeOf (vehicle player) isEqualTo "A3PL_Jayhawk") && (local vehicle player) && ((player isEqualTo ((vehicle player) turretUnit [0])) OR (player isEqualTo ((vehicle player) turretUnit [1])) OR (player == (driver vehicle player)))) && (vehicle player animationPhase "Basket" > 0.5)}
	],
	["STR_Config_Interactions_DecreaseRopeLength",
		{
			private _veh = vehicle player;
			if (typeOf _veh != "A3PL_Jayhawk") exitwith {};
			if ((count (ropes _veh)) < 1) exitwith {};
			ropeUnwind [(ropes _veh) select 0,2,(ropeLength ((ropes _veh) select 0)) - 15];
		},
		{((typeOf (vehicle player) isEqualTo "A3PL_Jayhawk") && (local vehicle player) && ((player isEqualTo ((vehicle player) turretUnit [0])) OR (player isEqualTo ((vehicle player) turretUnit [1])) OR (player == (driver vehicle player)))) && (vehicle player animationPhase "Basket" > 0.5)}
	],
	["STR_Config_Interactions_ToggleHighBeam",
		{
			private _veh = vehicle player;
			if (_veh animationSourcePhase "High_Beam" < 0.5) then {
				_veh animateSource ["High_Beam",1];
			} else {
				_veh animateSource ["High_Beam",0];
			};
		},
		{(vehicle player) isKindOf "Car" && (driver (vehicle player)) isEqualTo player}
	],
	["STR_Config_Interactions_ToggleAnchor",
		{[(vehicle player)] spawn A3PL_Vehicle_Anchor;},
		{((typeOf vehicle player) IN Config_Motorboat) && (!(vehicle player getVariable ["locked",true]))&& ((speed vehicle player) < 5)}
	],
	/*["Ouvrir MDT",
		{
			if(typeOf (vehicle player) IN ["A3FL_T440_Water_Tanker","A3PL_Pierce_Pumper","A3PL_Pierce_Ladder","A3PL_Pierce_Heavy_Ladder","A3PL_Pierce_Rescue","A3PL_Jayhawk","A3FL_AS_365","A3PL_RBM","Heli_Medium01_Medic_H","Heli_Medium01_Sheriff_H"]) then {
				[vehicle player] call A3PL_Police_OpenMDT;
			} else {
				if (isNull (findDisplay 211) && {(((vehicle player) animationPhase "Laptop_Top") > 0.5) || {typeOf (vehicle player) isEqualTo "A3PL_RBM"}}) then {
					[vehicle player] call A3PL_Police_OpenMDT;
				};
			};
		},
		{((player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize)]) && (((typeOf(vehicle player)) IN Config_FISD_Vehs) || ((typeOf(vehicle player)) IN Config_FIFR_Vehs))}
	],*/
	["STR_Config_Interactions_ResetRadar",
		{
			private _veh = vehicle player;
			if (player isEqualTo (driver _veh)) then {
				_veh setVariable ["lockfast",nil,false];
				_veh setVariable ["locktarget",nil,false];
				[_veh,"lockfast",0] call A3PL_Police_RadarSet;
				[_veh,"locktarget",0] call A3PL_Police_RadarSet;
			} else {
				_veh setVariable ["lockfast",nil,true];
				_veh setVariable ["locktarget",nil,true];
				[_veh,"lockfast",0] call A3PL_Police_RadarSet;
				[_veh,"locktarget",0] call A3PL_Police_RadarSet;
			};
		},
		{(typeOf (vehicle player) IN Config_FISD_Vehs) && {(player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] IN [("STR_Common_FISD" call A3PL_Localize)])}}
	],
	["STR_Config_Interactions_OpenDoor",
		{(vehicle player) animateDoor["Door_LB2",1];},
		{((typeOf (vehicle player)) isEqualTo "A3FL_AS_365") && {(player isEqualTo ((vehicle player) turretUnit [2]))}  && {((vehicle player) animationSourcePhase "Door_LB2") isEqualTo 0}}
	],
	["STR_Config_Interactions_CloseDoor",
		{(vehicle player) animateDoor["Door_LB2",0];},
		{((typeOf (vehicle player)) isEqualTo "A3FL_AS_365") && {(player isEqualTo ((vehicle player) turretUnit [2]))}  && {((vehicle player) animationSourcePhase "Door_LB2") isEqualTo 1}}
	],
	["STR_Config_Interactions_OpenDoor",
		{(vehicle player) animateDoor["Door_RB2",1];},
		{((typeOf (vehicle player)) isEqualTo "A3FL_AS_365") && {(player isEqualTo ((vehicle player) turretUnit [1]))} && {((vehicle player) animationSourcePhase "Door_RB2") isEqualTo 0}}
	],
	["STR_Config_Interactions_CloseDoor",
		{(vehicle player) animateDoor["Door_RB2",0];},
		{((typeOf (vehicle player)) isEqualTo "A3FL_AS_365") && {(player isEqualTo ((vehicle player) turretUnit [1]))} && {((vehicle player) animationSourcePhase "Door_RB2") isEqualTo 1}}
	],
	["STR_Config_Interactions_ToggleSideDoor",
		{
			private _veh = vehicle player;
			if ((_veh doorPhase "door_rb") isEqualTo 0) then {
				_veh animateDoor ["door_rb",1];
			} else {
				_veh animateDoor ["door_rb",0];
			};
		},
		{((typeOf (vehicle player)) isEqualTo "A3PL_Jayhawk") && (!(vehicle player getVariable ["locked",true])) && (((vehicle player) getCargoIndex player) isNotEqualTo -1)}
	],
	["STR_Config_Interactions_ChangeSeat",
		{player action ["MoveToCargo",(vehicle player),1]},
		{((typeOf (vehicle player)) isEqualTo "A3PL_Jayhawk") && (!(vehicle player getVariable ["locked",true])) && (((vehicle player) getCargoIndex player) isEqualTo 0) && ((vehicle player emptyPositions "cargo") > 0)}
	],
	["STR_Config_Interactions_ChangeGunner",
		{player action ["MoveToTurret", (vehicle player), [1]];},
		{((typeOf (vehicle player)) isEqualTo "A3PL_Jayhawk") && (!(vehicle player getVariable ["locked",true])) && (((vehicle player) getCargoIndex player) isEqualTo 2) && ((vehicle player emptyPositions "cargo") > 0)}
	],
	["STR_Config_Interactions_Sleep",
		{call A3PL_Player_Sleep;},
		{(Sleep_System == true) && (Player_Sleep < 100)}
	]
];
publicVariable "A3PL_Interaction_VehIn";

A3PL_Interaction_VehOut =
[
	["STR_Config_Interactions_CheckSeatbelt",
		{[cursorTarget] call A3FL_Police_CheckSeatBelt;},
		{
			(player distance cursorTarget <= 10) && !(isNull driver cursorTarget) && {((player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) IN [("STR_Common_FISD" call A3PL_Localize)])}
		}
	],
	["STR_Config_Interactions_ChangePressure",
		{[cursorTarget] call A3PL_FD_ChangeTruckPressure;},
		{(typeOf cursorTarget) IN ["A3PL_Pierce_Pumper","A3PL_Silverado_FD_Brush","EC_F450_Brush"]}
	],
	["STR_Config_Interactions_ChangeSquad",
		{[player_objintersect] call A3PL_Police_OpenSquadNb;},
		{
			((typeOf player_objintersect) IN ["A3FL_T440_Water_Tanker","Jonzie_Ambulance","A3PL_CVPI_PD","A3PL_Pierce_Ladder","A3PL_Pierce_Heavy_Ladder","A3PL_Tahoe_PD","A3PL_Pierce_Pumper","A3PL_Silverado_PD","A3PL_E350","A3PL_Pierce_Rescue","A3PL_Silverado_FD_Brush","EC_F450_Brush"]) && (player distance cursorTarget < 5) && ((player getVariable["faction","citizen"]) isEqualTo ("STR_Common_FIFR" call A3PL_Localize))
		}
	],
	["STR_Config_Interactions_MarkImpound",
		{call A3PL_Police_Impound;},
		{
			(vehicle player isEqualTo player) && {(cursorTarget isKindOf "Car") || (cursorTarget isKindOf "Tank")}  && (player distance cursorTarget < 6) && {((player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) IN [("STR_Common_FIFR" call A3PL_Localize),("STR_Common_FISD" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) || (player getVariable ["pVar_RedNameOn",false])}
		}
	],
	["STR_Config_Interactions_Climb",
		{
			_veh = cursorTarget;
			player setPos(_veh modelToWorld [0,-5,1]);
			player setDir(getDir _veh);
		},
		{((typeOf cursorTarget) isEqualTo "A3PL_Pierce_Rescue") && {((player distance (cursorTarget modeltoworld [0,-5.5,-1])) < 3)} && {(cursorTarget animationPhase "Ladder_Rotate" == 1)}}
	],
	["STR_Config_Interactions_FlipVehicle",
		{[cursorTarget] spawn A3PL_Vehicle_Unflip;},
		{(player distance cursorTarget < 5) && ((cursorTarget isKindOf "Car") || (cursorTarget isKindOf "Tank")) && {((vehicle player) isEqualTo player)} && {!(player getVariable ["Cuffed",false])} && {!(player getVariable ["Zipped",false])}}
	],
	["STR_Config_Interactions_CheckVIN",
		{
			private _id = (player_objintersect getVariable ["owner",[]]) select 1;
			[format[("STR_Common_RegistrationNumber" call A3PL_Localize),toUpper(_id)],Color_Green] call A3PL_Notification;
		},
		{((player_objintersect isKindOf "Ship") || (player_objintersect isKindOf "Plane") || (player_objintersect isKindOf "Air") || (player_objintersect isKindOf "Tank")) && {((player_objintersect distance player) < 6)} && {((player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) isEqualTo ("STR_Common_FISD" call A3PL_Localize))}}
	],
	["STR_Config_Interactions_CheckVIN",
		{
			private _id = (player_objintersect getVariable ["owner",[]]) select 1;
			[format[("STR_Common_RegistrationNumber" call A3PL_Localize),toUpper(_id)],Color_Green] call A3PL_Notification;
		},
		{(player_objintersect isKindOf "Tank") && {((player_objintersect distance player) < 6)} && {((player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) IN [("STR_Common_FISD" call A3PL_Localize)])}}
	],
	["STR_Config_Interactions_PickVehicle",
		{
			private _intersect = cursorTarget;
			if (isNull _intersect) exitwith {};
			if ((typeOf _intersect) IN ["A3PL_Cutter","B_supplyCrate_F","C_IDAP_supplyCrate_F","A3PL_EMS_Locker","A3FL_Stretcher"]) exitWith {["STR_Common_CannotPickThisObject", Color_red] call A3PL_Notification;};
			[_intersect] spawn A3PL_Criminal_PickCar;
		},
		{((vehicle player) isEqualTo player) && {(player distance cursorTarget < 9)} && {(player_ItemClass isEqualTo "v_lockpick")} && (cursorTarget isNotEqualTo A3FL_Seize_Storage) && ("lockpick_vehicles" in (player getVariable ["Player_Traits", []]))}
	],
	["STR_Config_Interactions_EnterCrane",
		{player moveInDriver cursorTarget;},
		{((typeOf cursorTarget) isEqualTo "A3PL_MobileCrane") && (player distance cursorTarget < 30) && ((count (crew cursorTarget)) == 0)}
	],
	["STR_Config_Interactions_VehicleInventory",
		{
			private _veh = player_objintersect;
			if([typeOf(_veh)] call A3PL_Config_HasStorage) then {[_veh] call A3PL_Vehicle_OpenStorage;};
		},
		{((vehicle player) isEqualTo player) && (player distance cursorTarget < 5) && {!isNil "player_objintersect"} && {player_objintersect IN A3PL_Player_Vehicles} && {!(player_objintersect getVariable ["locked",false]) && ([typeOf(player_objintersect)] call A3PL_Config_HasStorage)}}
	],
	["STR_Config_Interactions_CheckTankContent",
		{
			private _tanker = cursorTarget;
			private _gasType = _tanker getVariable["gasType", nil];
			private _gasAmount = _tanker getVariable["gasAmount",0];

			if ((typeOf _tanker) isEqualTo "A3PL_Tanker_Trailer") then {
				private _gasType2 = _tanker getVariable["gasType2", nil];
				private _gasAmount2 = _tanker getVariable["gasAmount2",0];
				private _msg = "";
				if (!isNil "_gasType" && {_gasAmount > 0}) then {
					_msg = format [("STR_Config_Interactions_TankContents" call A3PL_Localize), 1, _gasAmount, _gasType];
				} else {
					_msg = format [("STR_Config_Interactions_TankEmpty" call A3PL_Localize), 1];
				};
				if (!isNil "_gasType2" && {_gasAmount2 > 0}) then {
					_msg = _msg + " | " + format [("STR_Config_Interactions_TankContents" call A3PL_Localize), 2, _gasAmount2, _gasType2];
				} else {
					_msg = _msg + " | " + format [("STR_Config_Interactions_TankEmpty" call A3PL_Localize), 2];
				};
				[_msg, Color_Green] call A3PL_Notification;
			} else {
				if(isNil "_gasType") exitWith {["STR_Common_TankEmpty" call A3PL_Localize, Color_Yellow] call A3PL_Notification;};
				if (_gasAmount isEqualTo 0) exitWith {_tanker setVariable ["gasType", nil];};
				[format[("STR_A3PL_GasStation_TankerContents" call A3PL_Localize),_gasAmount,_gasType],Color_Green] call A3PL_Notification;
			};
		},
		{((typeOf cursorTarget) IN ["A3PL_Tanker_Trailer","A3PL_Fuel_Van","A3FL_T440_Gas_Tanker"])}
	],
	["STR_Config_Interactions_EmptyTank",
		{
			private _tanker = cursorTarget;
			private _gasType = _tanker getVariable ["gasType", nil];
			private _gasType2 = _tanker getVariable ["gasType2", nil];
			if (isNil "_gasType" && {isNil "_gasType2"}) exitWith {["STR_Common_TankAlreadyEmpty" call A3PL_Localize, Color_Yellow] call A3PL_Notification;};
			[_tanker] spawn A3FL_Hydrogen_ClearTank;
		},
		{((typeOf cursorTarget) IN ["A3PL_Tanker_Trailer","A3PL_Fuel_Van","A3FL_T440_Gas_Tanker"]) && (vehicle player isEqualTo player) && (player distance cursorTarget < 10) && {(simulationEnabled cursorTarget)} && {!isNil "player_objintersect"} && {cursorTarget IN A3PL_Player_Vehicles} && (((cursorTarget getVariable["gasAmount",0]) isNotEqualTo 0) || {(cursorTarget getVariable["gasAmount2",0]) isNotEqualTo 0})}
	],
	["STR_Config_Interactions_ImpoundSpecialVehicles",
		{call A3PL_Police_Impound;},
		{(vehicle player isEqualTo player) && ((cursorTarget isKindOf "Ship") || (cursorTarget isKindOf "Plane") || (cursorTarget isKindOf "Air")) && ((player getvariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) isEqualTo ("STR_Common_FISD" call A3PL_Localize)) && !(typeOf cursorTarget isEqualTo "A3PL_Yacht_Pirate")}
	],
	["STR_Config_Interactions_Lock",
		{
			cursorTarget setVariable ["locked",true,true];
			["STR_Common_VehicleLocked" call A3PL_Localize, Color_Red] call A3PL_Notification;
			playSound3D ["A3PL_Cars\Common\Sounds\A3PL_Car_Lock.ogg", cursorTarget, true, cursorTarget, 3, 1, 30];
		},
		{(vehicle player isEqualTo player) && (player distance cursorTarget < 10) && {(simulationEnabled cursorTarget)} && {!isNil "player_objintersect"} && {cursorTarget IN A3PL_Player_Vehicles} && {!(cursorTarget getVariable ["locked",true])}}
	],
	["STR_Config_Interactions_Unlock",
		{
			cursorTarget setVariable ["locked",false,true];
			["STR_Common_VehicleUnlocked" call A3PL_Localize, Color_Green] call A3PL_Notification;
			playSound3D ["A3PL_Common\effects\carunlock.ogg", cursorTarget, true, cursorTarget, 3, 1, 30];
		},
		{(vehicle player isEqualTo player) && (simulationEnabled cursorTarget) && ((player distance cursorTarget) < 10) && (cursorTarget IN A3PL_Player_Vehicles) && (cursorTarget getVariable ["locked",true])}
	],
	["STR_Config_Interactions_AttachBoatToTrailer",
		{[cursorTarget] call A3PL_Vehicle_TrailerAttach;},
		{(((vehicle player) isEqualTo player) && (cursorTarget distance player < 5)) && {(simulationEnabled cursorTarget)} && {(typeOf cursorTarget == "A3PL_Small_Boat_Trailer")}}
	],
	["STR_Config_Interactions_DetachBoat",
		{
			_Boat = ((attachedObjects cursorTarget) select 0);
			_Trailer = cursorTarget;
			[_Boat] remoteExec ["Server_Vehicle_TrailerDetach", 2];
		},
		{(((vehicle player) isEqualTo player) && (cursorTarget distance player < 5))&& (!(((attachedObjects cursorTarget) select 0) getVariable ["locked",true]))}
	],
	["STR_Config_Interactions_DetachBoat",
		{
			if (!(cursorTarget isKindOf "Ship")) exitwith {};
			[cursorTarget] remoteExec ["Server_Vehicle_TrailerDetach", 2];
		},
		{(((vehicle player) isEqualTo player) && (cursorTarget distance player < 5)) && ({(typeOf (attachedTo cursorTarget)) IN ["A3PL_Boat_Trailer","A3PL_Small_Boat_Trailer"]})&& (!(cursorTarget getVariable ["locked",true]))}
	],
	["STR_Config_Interactions_BoardYacht",
		{
			private _veh = player_objintersect;
			if (!(_veh isKindOf "A3PL_Yacht")) exitwith {};
			player setpos (_veh modeltoworld [-1,-25,-5]);
		},
		{((vehicle player) isEqualTo player) && (player_objintersect isKindOf "A3PL_Yacht") && ((player distance (player_objintersect modeltoworld [-1,-25,-5])) < 10)}
	],
	["STR_Config_Interactions_BoardRBM",
		{
			private _veh = cursorTarget;
			if (!(_veh isKindOf "A3PL_RBM")) exitwith {};
			player setpos (_veh modeltoworld [0,-4.16406,0]);
		},
		{((vehicle player) isEqualTo player) && (cursorTarget isKindOf "A3PL_RBM") && ((cursorTarget distance player) < 10)}
	],
	["STR_Config_Interactions_BoardCutter",
		{
			private _veh = cursorObject;
			if (!(_veh isKindOf "A3PL_Cutter")) exitwith {};
			player setpos (_veh modeltoworld [0,-32,-11]);
		},
		{((vehicle player) isEqualTo player) && (cursorObject isKindOf "A3PL_Cutter") && (((cursorObject modeltoworld [4,-40,-10]) distance player) < 10)}
	],
	["STR_Config_Interactions_BoardLCM",
		{
			private _veh = cursorTarget;
			if (!(_veh isKindOf "A3FL_LCM")) exitwith {};
			player setpos (_veh modeltoworld [0,0,0]);
		},
		{((vehicle player) isEqualTo player) && (cursorTarget isKindOf "A3FL_LCM") && ((cursorTarget distance player) < 10)}
	],
	["STR_Common_DetainSuspects",
		{
			if (!(player_objintersect isKindOf "Car")) exitwith {};
			[player_objintersect] call A3PL_Police_Detain;
		},
		{((vehicle player) isEqualTo player) && (((player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) IN [("STR_Common_FISD" call A3PL_Localize)]) && (player_objintersect isKindOf "Car") && (((player distance player_objintersect) < 6)))}
	],
	["STR_Common_EjectPassenger",
		{[player_objintersect] call A3PL_Police_unDetain;},
		{((player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) IN [("STR_Common_FISD" call A3PL_Localize)]) && ((player_objintersect) isKindOf "Car") && (((player distance player_objintersect) < 6)) && ((vehicle player) isEqualTo player)}
	],
	["STR_Config_Interactions_EnterBoat",
		{
			private _veh = cursorTarget;
			if (_veh getVariable ["locked",false]) exitwith {["STR_Config_Interactions_CannotEnterLockedBoat" call A3PL_Localize, Color_Red] call A3PL_Notification;};
			_veh lock 1;
			player moveInCargo _veh;
			_veh lock 2;
		},
		{(cursorTarget isKindOf "Ship") && (player distance cursorTarget < 5) && (!(player_objintersect getVariable ["locked",false]))}
	],
	["STR_Config_Interactions_EnterPilot",
		{
			private _veh = cursorTarget;
			if (_veh getVariable ["locked",false]) exitwith {["STR_Config_Interactions_CannotEnterLockedVehicle" call A3PL_Localize, Color_Red] call A3PL_Notification;};
			_veh lock 1;
			player action ["getInDriver", _veh];
			_veh lock 2;
		},
		{(cursorTarget isKindOf "Plane") && (player distance cursorTarget < 5) && (!(player_objintersect getVariable ["locked",false]))}
	],
	["STR_Common_EnterCopilot",
		{
			private _veh = cursorTarget;
			if (_veh getVariable ["locked",false]) exitwith {["STR_Config_Interactions_CannotEnterLockedVehicle" call A3PL_Localize, Color_Red] call A3PL_Notification;};
			_veh lock 1;
			player moveInTurret [_veh,[0]];
			_veh lock 2;
		},
		{(cursorTarget isKindOf "Plane") && (player distance cursorTarget < 5) && (!(player_objintersect getVariable ["locked",false]))}
	],
	["STR_Common_EnterDriver",
		{
			private _veh = cursorTarget;
			if (_veh getVariable ["locked",false]) exitwith {["STR_Config_Interactions_CannotEnterLockedVehicle" call A3PL_Localize, Color_Red] call A3PL_Notification;};
			_veh lock 1;
			player action ["getInDriver", _veh];
			_veh lock 2;
		},
		{(cursorTarget isKindOf "Ship") && (player distance cursorTarget < 5) && (!(player_objintersect getVariable ["locked",false])) && (isNil {Player_ObjIntersect getVariable ["bitem",nil]})}
	],
	["STR_Common_EnterPassenger",
		{
			private _veh = cursorTarget;
			if (_veh getVariable ["locked",false]) exitwith {["STR_Config_Interactions_CannotEnterLockedVehicle" call A3PL_Localize, Color_Red] call A3PL_Notification;};
			_veh lock 1;
			player moveInCargo _veh;
			_veh lock 2;
		},
		{(cursorTarget isKindOf "Plane") && (player distance cursorTarget < 5) && (!(player_objintersect getVariable ["locked",false]))}
	],
	["STR_Config_Interactions_ToggleAnchor",
		{[cursorTarget] spawn A3PL_Vehicle_Anchor;},
		{((typeOf cursorTarget) IN Config_Motorboat) && ((player distance cursorTarget) < 15) && (!(cursorTarget getVariable ["locked",true]))&& ((speed cursorTarget) < 5)}
	],
	["STR_Config_Interactions_AttachHelicopter",
		{[cursorTarget] call A3PL_Vehicle_SecureHelicopter;},
		{((typeOf cursorTarget) isEqualTo "A3PL_Cutter") && {((vehicle player) isEqualTo player) && ((speed vehicle player) < 1) && ((player distance cursorTarget) < 15)}}
	],
	["STR_Config_Interactions_SecureVehicle",
		{[cursorTarget] call A3PL_Vehicle_SecureVehicle;},
		{(vehicle player isEqualTo player) && {((player distance cursorTarget) < 10)} && {(count(player nearEntities [["A3FL_LCM"],20]) > 0)} && {(typeOf cursorTarget != "A3FL_LCM")}}
	],
	["STR_Config_Interactions_UnsecureVehicle",
		{[cursorTarget] call A3PL_Vehicle_UnsecureVehicle;},
		{(vehicle player isEqualTo player) && {((speed vehicle player) < 1)} && {((player distance cursorTarget) < 7)} && {(typeOf cursorTarget isEqualTo "A3FL_LCM")}}
	],
	["STR_Config_Interactions_DetachHelicopter",
		{[cursorTarget] call A3PL_Vehicle_UnsecureHelicopter;},
		{((typeOf cursorTarget) IN ["A3PL_Cutter"]) && (vehicle player isEqualTo player) && ((speed vehicle player) < 1) && ((player distance cursorTarget) < 15)}
	],
	["STR_Config_Interactions_ToggleAnchor",
		{[cursorObject] call A3PL_Vehicle_DisableSimulation;},
		{((typeOf cursorObject) IN ["A3PL_Cutter","A3FL_LCM"]) && ((player distance cursorObject) < 30) && ((speed cursorObject) < 4)}
	],
	["STR_Config_Interactions_StopTowing",
		{[player_objintersect] call A3PL_Police_UntowBoat;},
		{((typeOf player_objintersect) isEqualTo "A3PL_RBM") && {(player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) isEqualTo ("STR_Common_FISD" call A3PL_Localize)} && {(player_objintersect getVariable ["towing",false])}}
	],
	["STR_Config_Interactions_PrepareTowing",
		{
			player_objintersect spawn {
				A3FL_BoatTow = _this;
				["STR_Config_Interactions_RBMReadyForTowing" call A3PL_Localize, Color_Green] call A3PL_Notification;
				sleep 300;
				A3FL_BoatTow = nil;
				["STR_Config_Interactions_RBMTowingCancelled" call A3PL_Localize, Color_Red] call A3PL_Notification;
			};
		},
		{((typeOf player_objintersect) isEqualTo "A3PL_RBM") && {(player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) isEqualTo ("STR_Common_FISD" call A3PL_Localize)} && {!(player_objintersect getVariable ["towing",false])}}
	],
	["STR_Config_Interactions_TowBoat",
		{[A3FL_BoatTow,player_objintersect] call A3PL_Police_TowBoat;},
		{((typeOf player_objintersect) IN ["A3PL_RBM","A3PL_Motorboat","A3PL_RHIB","C_Scooter_Transport_01_F","A3FL_LCM"]) && {(player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) isEqualTo ("STR_Common_FISD" call A3PL_Localize)} && {!isNil {A3FL_BoatTow}}}
	],
	["STR_Config_Interactions_CheckRentalPapers",
		{
			private _rentedBy = player_objintersect getVariable ["rentedBy","Unknown"];
			[format ["Ce véhicule est loué par %1",_rentedBy],Color_Yellow] call A3PL_Notification;
		},
		{((player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) IN [("STR_Common_FISD" call A3PL_Localize)]) && ((player_objintersect getVariable["rentedBy","Unknown"]) isNotEqualTo "Unknown") && (((player distance player_objintersect) < 15)) && ((vehicle player) isEqualTo player)}
	]
];
publicVariable "A3PL_Interaction_VehOut";

A3PL_Interaction_Items =
[
	["STR_Config_Interactions_Plant",
		{call A3PL_JobFarming_Plant;},
		{(player_itemClass IN ["seed_wheat","seed_marijuana","seed_corn","seed_lettuce","seed_coca","seed_sugar","seed_carrot","seed_tobacco"]) && ((vehicle player) isEqualTo player) && (((surfaceType getpos player) == "#cype_plowedfield") || (([position player] call A3FL_JobFarming_InPlantation) isNotEqualTo 0))}
	],
	["STR_Config_Interactions_Eat",
		{call A3PL_Items_Food;},
		{(([Player_ItemClass, 'fnc'] call A3PL_Config_GetItem) isEqualTo 'A3PL_Items_Food') && !(underwater(vehicle player))}
	],
	["STR_Config_Interactions_Drink",
		{[] spawn A3PL_Items_Thirst;},
		{(([Player_ItemClass, 'fnc'] call A3PL_Config_GetItem) isEqualTo 'A3PL_Items_Thirst') && !(underwater(vehicle player))}
	],
	["STR_Config_Interactions_Consume",
		{[Player_ItemClass,1] call A3PL_Drugs_Use; },
		{(([Player_ItemClass, 'fnc'] call A3PL_Config_GetItem) isEqualTo 'A3PL_Drugs_Use')}
	],
	["STR_Config_Interactions_Store",
		{call A3PL_Inventory_PutBack;},
		{(!(player_itemClass isEqualTo "")) && (!(player_itemClass isEqualTo "ticket"))}
	],
	["STR_Config_Interactions_SmokeCigarette",
		{call A3PL_Items_Cigs;},
		{(([Player_ItemClass, 'fnc'] call A3PL_Config_GetItem) isEqualTo 'A3PL_Items_Cigs') && !(underwater(vehicle player))}
	],
	["STR_Config_Interactions_DestroyTicket",
		{[player_item] call A3PL_Inventory_Clear;},
		{((isNull Player_Item) isEqualTo false) && (player_itemClass isEqualTo "ticket")}
	],
	["STR_Config_Interactions_Throw",
		{[] spawn A3PL_Inventory_Throw;},
		{((isNull Player_Item) isEqualTo false) && ([Player_ItemClass, 'canDrop'] call A3PL_Config_GetItem) && ((vehicle player) isEqualTo player)}
	],
	["STR_Config_Interactions_Drop",
		{[] call A3PL_Inventory_Drop;},
		{([Player_ItemClass, 'canDrop'] call A3PL_Config_GetItem) && (!(isNull Player_Item)) && ((vehicle player) isEqualTo player)}
	],
	["STR_Config_Interactions_LightFire",
		{[] spawn A3PL_Fire_Matches;},
		{((player_itemclass isEqualTo "matches") && (vehicle player isEqualTo player))}
	],
	["STR_Config_Interactions_DeployHose",
		{[35] call A3PL_FD_DeployHose;},
		{player_ItemClass == "FD_Hose"}
	],
	["STR_Config_Interactions_PutOnMask",
		{call A3PL_FD_MaskOn;},
		{(player_itemClass) == "FD_Mask"}
	],
	["STR_Config_Interactions_DeployFuelHose",
		{[50] call A3PL_FD_GasDeployHose;},
		{(player_ItemClass == "FD_Hose")}
	]
];
publicVariable "A3PL_Interaction_Items";

A3PL_Interaction_Building =
[
	["STR_Config_Interactions_ToggleLock",
		{[player,cursorObject] remoteExec ["Server_Company_UpdateShopLocked",2];},
		{((typeOf cursorObject) isKindOf "House") && {([player getVariable ["character_id",""]] call A3PL_Config_GetCompanyID) isEqualTo (cursorObject getVariable["cid",-1])} && {((vehicle player) isEqualTo player)}}
	],
	["STR_Config_Interactions_RentGreenhouse",
		{[cursorObject] call A3PL_JobFarming_BuyGreenhouse;},
		{((player distance cursorObject) < 8) && ((typeOf cursorObject) isEqualTo "Land_A3PL_Greenhouse")}
	],
	["STR_Config_Interactions_ToggleGarage",
		{
			private _cursorObject = cursorObject;

			switch (typeOf _cursorObject) do {
				case "Land_A3PL_Firestation": {
					private _job = player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
					if !((["fifrvfd",player] call A3PL_DMV_Check) || (_job isEqualTo ("STR_Common_FIFR" call A3PL_Localize))) exitWith {["STR_Common_OnlyFIFRCanUseDoors" call A3PL_Localize, Color_Red] call A3PL_Notification;};
					private _memList = ["garagedoor1_button","garagedoor2_button","door_6","door_7","door_8","door_9","door_2","door_3","door_4","door_5",""];
					private _lastDist = 100;
					private _nearest = "";
					{
						private _dist = player distance2D (_cursorObject modelToWorldVisual (_cursorObject selectionPosition [_x, "Memory"]));
						if(_dist < _lastDist) then {
							_lastDist = _dist;
							_nearest = _x;

						};
					} foreach _memList;
					if !(_nearest isEqualTo "") then {
						private _split = _nearest splitstring "_";
						if((_split select 1) isEqualTo "button") then {
							[_cursorObject,(_split select 0)] call A3PL_Lib_ToggleAnimation;
						} else {
							[_cursorObject,_nearest,false] call A3PL_Lib_ToggleAnimation;
						};
					};
				};
				case "Land_A3FL_Warehouse": {
					private _distanceLeft = player distance2D (_cursorObject modelToWorldVisual (_cursorObject selectionPosition ["door_1", "Memory"]));
					private _distanceRight = player distance2D (_cursorObject modelToWorldVisual (_cursorObject selectionPosition ["door_5", "Memory"]));

					if (_distanceRight > _distanceLeft) then {
						[_cursorObject, "door_1", false] call A3PL_Lib_ToggleAnimation;
						[_cursorObject, "door_2", false] call A3PL_Lib_ToggleAnimation;
					} else {
						[_cursorObject, "door_5", false] call A3PL_Lib_ToggleAnimation;
						[_cursorObject, "door_6", false] call A3PL_Lib_ToggleAnimation;
					};
				};

				case "Land_John_Hangar": {
					[_cursorObject, "hangardoor"] call A3PL_Lib_ToggleAnimation;
				};

				default {
					[_cursorObject, "garagedoor"] call A3PL_Lib_ToggleAnimation;
				};
			};
		},
		{((typeOf cursorObject) isKindOf "House") && {(cursorObject getVariable ["unlocked", false]) || ((player getVariable ["character_id",""]) in (cursorObject getVariable ["owner", []])) || ((typeOf cursorObject) isEqualTo "Land_A3PL_Firestation")} && {(player distance cursorObject) < 35} && {(typeof player_objintersect) IN ["Land_A3PL_Ranch3","Land_A3PL_Ranch2","Land_A3PL_Ranch1","Land_Home4w_DED_Home4w_01_F","Land_Home3r_DED_Home3r_01_F","Land_Home6b_DED_Home6b_01_F","Land_Home5y_DED_Home5y_01_F","Land_Home1g_DED_Home1g_01_F","Land_Home2b_DED_Home2b_01_F","Land_John_Hangar","Land_A3FL_Warehouse","Land_A3PL_Firestation"]}}
	]
];
publicVariable "A3PL_Interaction_Building";

A3PL_Interaction_Other =
[
	["STR_Config_Interactions_Attach",
		{[cursorTarget] spawn A3PL_Vehicle_PalletLifterAttachObjects;},
		{(typeOf (([] call A3PL_Lib_Attached) select 0)) isEqualTo "A3PL_FD_HoseRolled" && (vehicle player isEqualTo player) && {(typeOf cursorTarget) isEqualTo "A3FL_PalletLifter"} && {!(cursorObject getVariable ["vehiclesLoaded",false])}}
	],
	["STR_Config_Interactions_Detach",
		{[cursorTarget] spawn A3PL_Vehicle_PalletLifterDetachObjects;},
		{(vehicle player isEqualTo player) && {(typeOf cursorTarget) isEqualTo "A3FL_PalletLifter"}}
	],
	["STR_Config_Interactions_EnableSimulation",
		{[cursorTarget] spawn A3PL_Vehicle_PalletLifterEnableSimulation;},
		{(vehicle player isEqualTo player) && {((player distance cursorTarget) < 10)} && {(count(player nearEntities [["A3FL_PalletLifter"],20]) > 0)} && {(typeOf cursorTarget != "A3FL_PalletLifter")}}
	],
	["STR_Config_Interactions_Seize",
		{[1] call A3PL_Police_SeizeItems;},
		{((player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) IN [("STR_Common_FISD" call A3PL_Localize)]) && (count ((nearestObjects [player, ["weaponholder"],3]) + (nearestObjects [player, ["groundWeaponHolder"],3])) > 0)}
	],
	["STR_Config_Interactions_Repair",
		{call A3PL_JobRoadworker_RepairTerrain;},
		{((((player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) IN [("STR_Common_Job_Roadworker" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize)]) && ((vehicle player) isEqualTo player)) || (((player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) IN [("STR_Common_Company" call A3PL_Localize)]) && ([player getVariable ["character_id",""]] call A3PL_Config_InCompany) && ([player,"impound"] call A3PL_Company_HasLicense))) && (!(player getVariable ["Cuffed",false]) && !(player getVariable ["Zipped",false]))}
	],
	["STR_Config_Interactions_PickSafe",
		{[cursorObject] spawn A3PL_Robberies_Evidence;},
		{(player_ItemClass isEqualTo "v_lockpick") && (cursorObject isEqualTo A3FL_Seize_Storage)}
	],
	["STR_Config_Interactions_SecureSafe",
		{
			cursorObject setVariable["locked",true,true];
			_name = player getVariable["name","unknown"];
			_fisd= [("STR_Common_FISD" call A3PL_Localize)] call A3PL_Lib_FactionPlayers;
			[format[("STR_Common_SecuredSeizeSafe" call A3PL_Localize),_name],Color_blue] remoteExec ["A3PL_Notification",_fisd];
		},
		{!(cursorObject getVariable["locked",true]) && (cursorObject isEqualTo A3FL_Seize_Storage) && ((player getVariable["faction","citizen"]) isEqualTo ("STR_Common_FISD" call A3PL_Localize))}
	]
];
publicVariable "A3PL_Interaction_Other";
