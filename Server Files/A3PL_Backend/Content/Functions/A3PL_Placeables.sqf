/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
['A3PL_Placeables_Pickup', {
	params [["_obj",Player_ObjIntersect,[objNull]]];
	private _attachedTo = attachedTo _obj;
	if ((isPlayer _attachedTo) && {!(_attachedTo isKindOf "Car")}) exitwith {[("STR_A3PL_Placeables_ObjectAlreadyAttachedToOther" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _locked = _obj getVariable ["locked",false];
	if (_locked) exitwith {[("STR_A3PL_Placeables_ObjectIsLocked" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	private _localityCheck = if (typeOf _obj IN ["A3FL_Stretcher","A3FL_Wheelchair","A3PL_WheelieBin","A3FL_DrugBag","C_IDAP_supplyCrate_F"]) then {true} else {local _obj};
	if (!_localityCheck) then
	{
		private _owner = _obj getVariable ["owner",nil];
		private _cid = [(player getVariable ["character_id",""])] call A3PL_Config_GetCompanyID;
		private _pJob = player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
		private _objCid = _obj getVariable ["cid",0];
		private _objJob = _obj getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
		if (!isNil "_owner") then
		{
			if (_owner isEqualType []) then
			{
				if ((player getVariable ["character_id",""]) IN _owner || {_cid isEqualTo _objCid} || (_pJob isEqualTo _objJob)) then
				{
					[_obj,player] remoteExec ["A3PL_Lib_ChangeLocality", 2];
					_localityCheck = true;
				};
			} else {
				if ((player getVariable ["character_id",""]) isEqualTo _owner || {_cid isEqualTo _objCid} || (_pJob isEqualTo _objJob)) then
				{
					[_obj,player] remoteExec ["A3PL_Lib_ChangeLocality", 2];
					_localityCheck = true;
				};
			};
		};
		if (typeOf _obj == "A3PL_DeliveryBox") then
		{
			private _packageOwner = _obj getVariable ["owner",(player getVariable ["character_id",""])];
			if (_packageOwner isEqualTo (player getVariable ["character_id",""])) then
			{
				[_obj,player] remoteExec ["A3PL_Lib_ChangeLocality", 2];
				_localityCheck = true;
			};
		};
	};
	if(!_localityCheck) exitwith {};

	private _type = typeOf _obj;
	if (_type isEqualTo "GroundWeaponHolder") then {
		_obj attachTo [player, [0,0,0.65], "RightHand"];
	} else {
		_dir = getDir _obj;
		_obj attachTo [player];
		_obj setDir (_dir + (360 - (getDir player)));
	};
	if (_type IN Config_Furniture) then {
		[_obj] spawn A3FL_Placeables_ObjectMovement;
	};
	[_obj] spawn A3PL_Placeable_AttachedLoop;
}] call compile_Global;

["A3PL_Placeable_GetZOffset",
{
	private _obj = param [0,""];
	private _isVehicle = param [1,false];
	private _objMap = Config_Items_ZOffset;
	private _objData = _objMap getOrDefault [(typeOf _obj), [0,0]];

	[_objData#1,_objData#0] select (_isVehicle);
}] call compile_Global;

["A3PL_Placeable_AttachedLoop",
{
	private _obj = param [0,objNull];
	private _attach = param [1,[0,0,0]];
	private _type = typeOf _obj;
	private _distance = player distance _obj;
	while {(_obj IN (attachedObjects player)) && (!isNull _obj)} do
	{
		_sleep = 0.5;
		if (!alive player) exitwith {detach _obj; [] call A3PL_Inventory_Drop;};
		if ((animationState player) == "a3pl_takenhostage") exitwith
		{
			private _isItem = false;
			{
				private _item = _x;
				private _data = _y;
				if (_y#2 isEqualTo (typeOf _obj)) exitwith {
					[true] call A3PL_Inventory_PutBack;
					_isItem = true;
				};
			} foreach Config_ItemMap;
			if (!(_isItem)) then {
				detach _obj;
			} else {
				[] call A3PL_Inventory_Drop;
			};
		};
		if (Player_NameIntersect IN ["trunkinside","trunkinside1","trunkinside2","trunkinside3","trunkinside4","trunkinside5","trunkinside6","trunkinside7","trunkinside8","trunkinside9","trunkinside10","trunkinside11","lockerbottom","lockertop","mcfishertable","mcfisherstable1","mcfisherstable2","mcfishergrill","mcFishersGrill1","mcFishersGrill1"]) then
		{
			private _objClass = _obj getVariable ["class",""];
			if ((Player_NameIntersect IN ["mcfishergrill","mcFishersGrill1","mcFishersGrill1"]) && !(_objClass IN ["burger_raw","burger_burnt","burger_cooked","fish_raw","fish_cooked","fish_burned"])) exitWith {};
			private ["_interDist","_dist","_begPosASL","_endPosASL","_posAGL"];
			_interDist = [player_objintersect, "VIEW"] intersect [positionCameraToWorld [0,0,0],positionCameraToWorld [0,0,1000]];
			if (count _interDist < 1) exitwith {};
			_dist = (_interDist select 0) select 1;
			_begPosASL = AGLToASL positionCameraToWorld [0,0,0];
			_endPosASL = AGLToASL positionCameraToWorld [0,0,1000];
			_posAGL = ASLToAGL (_begPosASL vectorAdd ((_begPosASL vectorFromTo _endPosASL) vectorMultiply _dist));
			_obj attachto [player,[(player worldToModelVisual _posAGL) select 0,(player worldToModelVisual _posAGL) select 1,((player worldToModelVisual _posAGL) select 2) + ([_obj,true] call A3PL_Placeable_GetZOffset)]];
			_sleep = 0.1;
			if (_type == "GroundWeaponHolder") exitwith
			{
				detach _obj;
				_obj attachTo [player, [0, 1.5,
				((player WorldToModel (Player_ObjIntersect modelToWorld(Player_ObjIntersect selectionPosition player_nameIntersect))) select 2) + ([_obj,true] call A3PL_Placeable_GetZOffset)] ];
			};
		}
		else
		{
			if (Player_Item == _obj) exitwith
			{
				switch (Player_ItemClass) do
				{
					case ("popcornBucket"):
					{
						if (!isNil "A3PL_EatingPopcorn") exitwith {};
						Player_Item attachTo [player, [0,0,0], 'LeftHand'];
					};
					case ("beer"):
					{
						Player_Item attachTo [player, [0,0,0], 'LeftHand'];
					};
					case ("coke"):
					{
						Player_Item attachTo [player, [0,0,0], 'LeftHand'];
					};
					case ("waterbottle"):
					{
						Player_Item attachTo [player, [0,0,0], 'LeftHand'];
					};
					case ("dildo"):
					{
						Player_Item attachTo [player, [0,0,0.05], 'RightHand'];
      					Player_Item setVectorUp [1,0,0];
					};
					case ("beer_gold"):
					{
						Player_Item attachTo [player, [0,0,0], 'LeftHand'];
					};
					case ("beer_carlton"):
					{
						Player_Item attachTo [player, [0,0,0], 'LeftHand'];
					};
					case ("beer_coopers"):
					{
						Player_Item attachTo [player, [0,0,0], 'LeftHand'];
					};
					case ("beer_tooheys"):
					{
						Player_Item attachTo [player, [0,0,0], 'LeftHand'];
					};
					case ("beer_vb"):
					{
						Player_Item attachTo [player, [0,0,0], 'LeftHand'];
					};
					case ("whiskey_jimbeam"):
					{
						Player_Item attachTo [player, [0,0,0], 'LeftHand'];
					};
					case ("coffee_cup_large"):
					{
						Player_Item attachTo [player, [0,0,0], 'LeftHand'];
					};
					case ("coffee_cup_medium"):
					{
						Player_Item attachTo [player, [0,0,0], 'LeftHand'];
					};
					case ("coffee_cup_small"):
					{
						Player_Item attachTo [player, [0,0,0], 'LeftHand'];
					};
					case ("stinger"):
					{
						Player_Item attachto [player,
						[
							0,
							(player worldToModel (getposATL Player_Item)) select 1,
							0.1
						]];
					};
					case default {Player_Item attachTo [player, _attach, 'RightHand'];};
				};
			};

			if (_type isEqualTo "GroundWeaponHolder") then
			{
				_obj attachTo [player, [0.6,0,0.1], 'RightHand'];
				_obj setVectorUp [1,0,0];
			} else {
				_obj setposATL [getposATL _obj select 0,getposATL _obj select 1,(getposATL _obj select 2) -+ ([_obj] call A3PL_Placeable_ObjectZFix)];
				if([_obj,false] call A3PL_Placeable_GetZOffset != 0) then {
					_obj attachto [player,[0,1,[_obj,false] call A3PL_Placeable_GetZOffset]];
				} else {
					_obj attachTo[player];
				};
				switch (typeOf _obj) do {
					case ("A3FL_Stretcher"): { _obj attachTo [player,[0,1.4,1.36]]; };
					case ("A3FL_Wheelchair"): { _obj attachTo [player,[0,1,1.38]]; };
					case ("A3PL_DeliveryBox"): { _obj attachTo [player,[-0.2,0,0],"RightHand"]; };
					case ("A3FL_DrugBag"): { _obj attachTo [player,[-0.21,0,0],"RightHand"];};
					case ("A3PL_RoadCone_x10"): { _obj attachTo [player,[0,0,0],"RightHand"]; };
				};
			};
		};
		sleep _sleep;
	};
}] call compile_Global;

['A3PL_Placeable_ObjectZFix',
{
	private _obj = _this select 0;
	private _posZ = (boundingboxReal _obj) select 0; // Okay now we have a x,y,z model coordinate relative to model center
	_posZ = _obj modelToWorld _posZ; // lets convert this to world coordinates
	_posZ = (_posZ select 2); //Okay we have world coordinates, lets get rid of X and Y, we will now end up with the difference between terrain and object
	_posZ = _posZ - ((getposATL player) select 2); // Okay now we add the Z of the player on top of that
	_posZ;
}] call compile_Global;

['A3PL_Placeables_QuickAction',
{
	private _attached = [] call A3PL_Lib_Attached;
	if (count _attached > 0) exitwith
	{
		private ["_obj","_dir","_collision","_except"];
		_obj = _attached select 0;
		_collision = [_obj] call A3PL_Lib_checkCollision;
		{
			if ((_x isKindOf "Car") OR (_x isKindOf "Jonzie_Public_Trailer_Base")) exitwith
			{
				_collision = _collision - [_x];
			};
		} foreach _collision;

		if (Player_NameIntersect IN ["trunkinside","trunkinside1","trunkinside2","trunkinside3","trunkinside4","trunkinside5","trunkinside6","trunkinside7","trunkinside8","trunkinside9","trunkinside10","trunkinside11","lockerbottom","lockertop","mcfishertable","mcfishergrill","mcFishersGrill1","mcFishersGrill1"]) then
		{
			_collision = _collision - [player_objintersect];
		};

		if (typeOf _obj == "GroundWeaponHolder") then
		{
			_collision = [];
		};

		_except = ["A3FL_Stretcher","A3PL_Ski_Base","A3PL_Ladder","A3FL_Wheelchair"];
		if ((count _collision > 0) && !((typeOf _obj) IN _except)) exitwith {[("STR_A3PL_Placeables_CantPlaceObjectIntoAnotherOne" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		if (freeLook) exitwith {[("STR_A3PL_Placeables_CantPlaceObjectIfYouAreNotLooking" call A3PL_Localize),Color_Red] call A3PL_Notification;};

		if (Player_NameIntersect IN ["trunkinside","trunkinside1","trunkinside2","trunkinside3","trunkinside4","trunkinside5","trunkinside6","trunkinside7","trunkinside8","trunkinside9","trunkinside10","trunkinside11","lockerbottom","lockertop","mcfishertable","mcfishergrill","mcFishersGrill1","mcFishersGrill1"]) exitwith
		{
			if (Player_NameIntersect IN ["lockerbottom","lockertop"]) exitwith
			{
				if (Player_ObjIntersect AnimationPhase "door1" < 0.5) exitwith {};
				detach _obj;
				_obj attachto [Player_ObjIntersect];
				_obj setDir 180;
				_obj setPos getPos _obj;

				if (_obj == Player_Item) then
				{
					[false] call A3PL_Inventory_Drop;
				};
			};
			if (Player_NameIntersect IN ["mcfishertable","mcfishergrill","mcFishersGrill1","mcFishersGrill1"]) exitwith
			{
				private _new = createVehicle [typeOf _obj,getPosATL _obj, [], 0, "CAN_COLLIDE"];
				_new setVariable["class",Player_ItemClass,true];
				_new setVariable["amount",1,true];
				_new attachto [player_objintersect];
				if(!isNil 'Player_ItemAmount') then {
					Player_ItemAmount = Player_ItemAmount - 1;
					[Player_ItemClass,-1] call A3PL_Inventory_Add;
					if(Player_ItemAmount isEqualTo 0) then{[] call A3PL_Inventory_Clear;};
				};
				[_new] call A3PL_JobMcfisher_CookBurger;
			};
			if (Player_NameIntersect IN ["trunkinside","trunkinside1","trunkinside2","trunkinside3","trunkinside4","trunkinside5","trunkinside6","trunkinside7","trunkinside8","trunkinside9","trunkinside10","trunkinside11"]) exitwith
			{
				_dir = getDir _obj;
				detach _obj;
				_obj setvelocity [0,0,0];
				_obj attachto [Player_ObjIntersect];
				_obj setDir (_dir + (360 - (getDir player_objintersect)));
				_obj setpos (getpos _obj);

				if (_obj == Player_Item) then
				{
					[false] call A3PL_Inventory_Drop;
				};
			};
		};
		if (typeOf _obj == "GroundWeaponHolder") exitwith {detach _obj; _obj setpos [(getpos player select 0),(getpos player select 1),(getposATL player select 2)]};
		private _ground = (getposATL _obj)#2;
		if(-0.2 > _ground) exitwith {[("STR_A3PL_Placeables_CantPlaceObjectInGround" call A3PL_Localize),Color_Red] call A3PL_Notification;};
		detach _obj;
		_obj setvelocity [0,0,0];
		_obj setposATL (getPosATL _obj);
	};
	if (!(isNull player_item)) exitwith {[("STR_A3PL_Placeables_YouHaveSomethingInHands" call A3PL_Localize),Color_Red] call A3PL_Notification};
	call A3PL_Placeables_Pickup;
}] call compile_Global;

["A3PL_Placeables_PlaceCone",
{
	private _cones = ([] call A3PL_Lib_Attached) select 0;
	if (isNil "_cones") then {_cones = objNull;};
	if ((typeOf _cones) != "A3PL_RoadCone_x10") exitwith {[("STR_A3PL_Placeables_YouDoNotHaveConeToPlace" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _sourcePhase = _cones animationSourcePhase "cone_hide";
	if (_sourcePhase >= 9) exitwith {detach _cones;};
	_cones animateSource ["cone_hide",_sourcePhase + 1];
	private _cone = createVehicle ["A3PL_RoadCone", (getPosATL _cones), [], 0, "CAN_COLLIDE"];
	_cone setVariable ["class","roadcone",true];
	[("STR_A3PL_Placeables_YouPlacedCone" call A3PL_Localize),Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Placeables_StackCone",
{
	private ["_cone","_nearCone","_pos","_animPhase"];
	_cone = param [0,objNull];

	_nearCone = nearestObjects [_cone,["A3PL_RoadCone","A3PL_RoadCone_x10"],4];
	_nearCone = _nearCone - [_cone];
	if (count _nearCone <= 0) exitwith {[("STR_A3PL_Placeables_NoConeAtProximity" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	_nearCone = _nearCone select 0;

	if ((((_cone animationSourcePhase "cone_hide") <= 0) && (typeOf _cone == "A3PL_RoadCone_x10")) OR (((_nearcone animationSourcePhase "cone_hide") <= 0) && (typeOf _nearcone == "A3PL_RoadCone_x10"))) exitwith {[("STR_A3PL_Placeables_10ConeMax" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if ((typeOf _nearCone == "A3PL_RoadCone_x10") && (typeOf _cone == "A3PL_RoadCone_x10")) exitwith
	{
		_animPhase = 10 - (_nearCone animationSourcePhase "cone_hide");
		deleteVehicle _nearCone;
		_cone animateSource ["cone_hide",(_cone animationSourcePhase "cone_hide") - _animPhase];
		if(((_cone animationSourcePhase "cone_hide") - _animPhase) isEqualTo 0) then {
			_cone setVariable ["class","roadcones",true];
		};
	};
	if ((typeOf _nearCone == "A3PL_RoadCone_x10") OR (typeOf _cone == "A3PL_RoadCone_x10")) exitwith
	{
		if (typeOf _nearCone == "A3PL_RoadCone_x10") then
		{
			if (typeOf _cone == "A3PL_RoadCone") then {_animPhase = 1;} else {_animPhase = _cone animationSourcePhase "cone_hide";};
			deleteVehicle _cone;
			_nearCone animateSource ["cone_hide",((_nearcone animationSourcePhase "cone_hide") - _animPhase)];
			if(((_cone animationSourcePhase "cone_hide") - _animPhase) isEqualTo 0) then {
				_cone setVariable ["class","roadcones",true];
			};
		} else
		{
			if (typeOf _nearcone == "A3PL_RoadCone") then {_animPhase = 1;} else {_animPhase = _nearcone animationSourcePhase "cone_hide";};
			deleteVehicle _nearcone;
			_cone animateSource ["cone_hide",((_cone animationSourcePhase "cone_hide") - _animPhase)];
			if(((_cone animationSourcePhase "cone_hide") - _animPhase) isEqualTo 0) then {
				_cone setVariable ["class","roadcones",true];
			};
		};
	};

	_pos = getposATL _cone;
	deleteVehicle _cone;
	deleteVehicle _nearCone;
	_cone = createVehicle ["A3PL_RoadCone_x10", _pos, [], 0, "CAN_COLLIDE"];
	_cone animateSource ["cone_hide",8,true];
	_cone setVariable ["class","roadcone",true];
}] call compile_Global;

["A3FL_Placeables_ObjectMovement",
{
	params[["_obj",objNull,[objNull]]];
	objectKeyDown =
	{
		private _key = (_this#0)#1;
		private _obj = [_this#1] call A3PL_Lib_vehStringToObj;
		private _VecNormal = [0,0,1];
		private _dir = _obj getVariable["ObjectAttached_Dir",0];
		private _height = _obj getVariable["ObjectAttached_Height",0];
		private _relPosition = player worldToModel ASLToAGL getPosASL _obj;
		private _return = false;
		switch _key do
		{
			case 201: {
				_height = _height + 0.1;
				_obj setVariable["ObjectAttached_Height",_height];

				_return = true;
			};
			case 209: {
				_height = _height - 0.1;
				_obj setVariable["ObjectAttached_Height",_height];
				_return = true;
			};
			case 199: {
				_dir = _dir + -4;
				if(_dir >= 360) then {_dir = _dir - 360;};
				if(_dir < 0) then {_dir = _dir + 360;};
				_obj setVariable["ObjectAttached_Dir",_dir];
				_return = true;
			};
			case 207: {
				_dir = _dir + 4;
				if(_dir >= 360) then {_dir = _dir - 360;};
				if(_dir < 0) then {_dir = _dir + 360;};
				_obj setVariable["ObjectAttached_Dir",_dir];
				_return = true;
			};
		};
		if(_return) then {
			_obj attachTo [player, [_relPosition#0,_relPosition#1,_height]];
			_VecDir = [-cos _dir, sin _dir, 0] vectorCrossProduct _VecNormal;
			_obj setVectorDirAndUp [_VecDir, _VecNormal];
		};
		_return;
	};
	waitUntil {!isNull findDisplay 46};
	_objectKeyDown = (findDisplay 46) DisplayAddEventHandler ["keydown",format["[_this,'%1'] call objectKeyDown",_obj]];
	waitUntil {!(_obj IN (attachedObjects player))};
	(findDisplay 46) displayRemoveEventHandler ["keydown",_objectKeyDown];
}] call compile_Global;
