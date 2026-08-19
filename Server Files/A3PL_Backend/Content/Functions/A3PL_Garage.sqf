/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Garage_Open", {
	disableSerialization;

	private _fail = false;
	if !(Player_ObjIntersect IN [AircraftPaint,AircraftPaint3]) then {
		private _nearBy = nearestObjects [player, ["Land_A3PL_Garage"], 20];
		A3PL_Company_Building = _nearBy select 0;
		private _onDuty = player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)];
		private _cid = [(player getVariable ["character_id",""])] call A3PL_Config_GetCompanyID;
		private _shopCid = A3PL_Company_Building getVariable["cid",0];
		private _hasLicense = [player,"custom"] call A3PL_Company_HasLicense;

		if (count _nearBy < 1) exitwith {[("STR_A3PL_Garage_NoGarageNearby" call A3PL_Localize),Color_Red] call A3PL_Notification; _fail = true;};

		_isCorporate = [(player getVariable ["character_id",""])] call A3PL_Config_InCompany;
		if(!(_isCorporate || _onDuty)) exitWith {[("STR_Common_NotInCompany" call A3PL_Localize),Color_Red] call A3PL_Notification; _fail = true;};
		
		if(!((_shopCid isEqualTo _cid) || _onDuty)) exitWith {[("STR_Common_LocalNotOwnedByCompany" call A3PL_Localize),Color_Red] call A3PL_Notification; _fail = true;};
		if (!(((player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) == ("STR_Common_Company" call A3PL_Localize)) || _onDuty)) exitwith {[("STR_A3PL_Garage_NotOnDuty" call A3PL_Localize),Color_Red] call A3PL_Notification; _fail = true;};
		
		if (!(_hasLicense || _onDuty)) exitWith {[("STR_A3PL_Garage_CompanyNoAccess" call A3PL_Localize),Color_Red] call A3PL_Notification; _fail = true;};
	};

	if (_fail) exitWith {};
	private _garage = param [0,objNull];
	private _job = player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];

	private ["_veh"];
	if (_garage IN [AircraftPaint, AircraftPaint3]) then {
		_veh = (nearestObjects [player,["Helicopter","plane","A3FL_PalletLifter"],25]) select 0;
	} else {
		_veh = (nearestObjects [player,["Car_F","Ship_F","Tank_F","A3FL_PalletLifter","A3FL_T440"],25]) select 0;
	};

	if (isNil "_veh") exitwith {[("STR_A3PL_Garage_NoVehiclesNearby" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (isNull _garage OR isNull _veh) exitwith {};

	private _typeOf = typeOf _veh;

	createDialog "Dialog_Garage";
	private _display = findDisplay 62;

	private _logic = "logic" createvehicleLocal [0,0,0];
	_logic setposASL [(getPosWorld _veh) select 0,(getposWorld _veh) select 1,((getposWorld _veh) select 2) - 0.5];
	_logic setDir (getDir _veh + 20);

	private _cam = "camera" camCreate [0,0,0];
	_cam camSetTarget _logic;
	_cam camSetPos (positionCameraToWorld [0,0,0]);
	_cam camCommit 0;
	_cam cameraEffect ["internal", "BACK"];

	if (_garage IN [AircraftPaint, AircraftPaint3]) then {
		_cam camSetRelPos [7,-3,0.9];
	} else {
		if(typeOf _veh IN ["A3PL_P362_TowTruck","A3FL_T440","A3FL_T440_Tow_Truck"]) then {
			_cam camSetRelPos [-0.5,13.5,1];
		} else {
			_cam camSetRelPos [0.3,5.2,0.9];
		};
	};

	_cam camCommit 1;

	private _control = _display displayCtrl 1502;
	private _i = _control lbAdd ("STR_A3PL_Garage_RepairAll" call A3PL_Localize);
	_control lbSetData [_i,"all"];

	private _allHitPoints = getAllHitPointsDamage _veh;

	private ["_hitArray"];
	if (count(_allHitPoints) > 0) then {
		_hitArray = _allHitPoints select 1;
	} else {
		_hitArray = [];
	};

	if (count(_hitArray) > 0) then {
		{
			if (_x != "") then {
				private ["_name"];
				_name = [_x,"title"] call A3PL_Config_GetGarageRepair;
				if (_name isEqualType true) then {_name = _x};
				_i = _control lbAdd _name;
				_control lbSetData [_i,_x];
			};
		} foreach _hitArray;
	};

	_control = _display displayCtrl 1504;
	private _textures = ["all",_typeOf,"",_job] call A3PL_Config_GetGaragePaint;
	{
		private ["_i"];
		_i = _control lbAdd (_x select 2);
		_control lbSetData [_i,(_x select 0)];
	} foreach _textures;

	_control = _display displayCtrl 1500;
	private _upgrades = ["all",_typeOf,""] call A3PL_Config_GetGarageUpgrade;
	{
		private ["_i"];
		_i = _control lbAdd (_x select 3);
		_control lbSetData [_i,(_x select 0)];
	} foreach _upgrades;

	_control = _display displayCtrl 1505;
	{
		private _i = _control lbAdd (_x select 1);
		_control lbSetData [_i,(_x select 0)];
	} foreach [["A3PL_Cars\common\rvmats\car_paint.rvmat",("STR_A3PL_Garage_Material_Default" call A3PL_Localize)],["A3PL_Cars\Common\rvmats\Metallic.rvmat",("STR_A3PL_Garage_Material_Metallic" call A3PL_Localize)],["A3PL_Cars\Common\rvmats\Black_Plastic.rvmat",("STR_A3PL_Garage_Material_Plastic" call A3PL_Localize)],["A3PL_Cars\Common\rvmats\CarbonFiber.rvmat",("STR_A3PL_Garage_Material_CarbonFiber" call A3PL_Localize)],["A3PL_Cars\Common\rvmats\CarbonFiber_Mat.rvmat",("STR_A3PL_Garage_Material_CarbonFiber_Mat" call A3PL_Localize)],["A3PL_Cars\Common\rvmats\Chrome_new.rvmat",("STR_A3PL_Garage_Material_Chrome" call A3PL_Localize)],["A3FL_Common\Materials\JDTools\JD_Gold.rvmat",("STR_A3PL_Garage_Material_Gold" call A3PL_Localize)],["A3FL_Common\Materials\JDTools\JD_Silver.rvmat",("STR_A3PL_Garage_Material_Silver" call A3PL_Localize)],["A3FL_Common\Materials\JDTools\JD_Copper.rvmat",("STR_A3PL_Garage_Material_Copper" call A3PL_Localize)]];

	_control = _display displayCtrl 1500;
	_control ctrlAddEventhandler ["LBSelChanged","_this call A3PL_Garage_ClickUpgrade"];

	_control = _display displayCtrl 1505;
	_control ctrlAddEventhandler ["LBSelChanged",format ["['%1',_this] call A3PL_Garage_ClickMaterial;",_veh]];

	_control = _display displayCtrl 1502;
	_control ctrlAddEventhandler ["LBSelChanged",format ["['%1'] call A3PL_Garage_LBRepair;",_veh]];

	_control = _display displayCtrl 1504;
	_control ctrlAddEventhandler ["LBSelChanged",format ["['%1','tex'] call A3PL_Garage_SetColour",_veh]];

	_control = _display displayCtrl 1400;
	_control ctrlAddEventhandler ["KeyDown",format ["['%1'] call A3PL_Garage_SetColour",_veh]];

	_control = _display displayCtrl 1401;
	_control ctrlAddEventhandler ["KeyDown",format ["['%1'] call A3PL_Garage_SetColour",_veh]];

	_control = _display displayCtrl 1402;
	_control ctrlAddEventhandler ["KeyDown",format ["['%1'] call A3PL_Garage_SetColour",_veh]];

	_control = _display displayCtrl 1600;
	_control buttonSetAction "['STR_A3PL_Garage_NoUpgradeSelected' call A3PL_Localize,Color_Red] call A3PL_Notification;";

	_control = _display displayCtrl 1601;
	_control buttonSetAction format ["['%1'] call A3PL_Garage_Repair",_veh];

	_control = _display displayCtrl 1602;
	_control buttonSetAction format ["['tex','%1'] call A3PL_Garage_ColourSet",_veh];

	_control = _display displayCtrl 1603;
	_control buttonSetAction "call A3PL_Garage_ColourSet";

	_control = _display displayCtrl 1605;
	_control buttonSetAction "call A3PL_Garage_SetMaterial";

	_control = _display displayCtrl 1606;
	_control buttonSetAction "call A3PL_Garage_SetLicensePlate";

	A3PL_Garage_Veh = _veh;
	A3PL_Garage_Cam = _cam;
	A3PL_Garage_Logic = _logic;

	A3PL_Garage_MyColor = "";
	A3PL_Garage_MyMaterial = "A3PL_Cars\common\rvmats\car_paint.rvmat";

	if (count(getObjectTextures _veh) > 0) then {
		A3PL_Garage_MyColor = ((getObjectTextures _veh) select 0);
		A3PL_Garage_MyMaterial = ((getObjectMaterials _veh) select 0);
	};

	while {!isNull _display} do {
		uiSleep 0.01;
	};

	camDestroy _cam;
	A3PL_Garage_Cam = nil;
	A3PL_Garage_Veh = nil;
	A3PL_Garage_Logic = nil;

	if ((missionNameSpace getVariable ["A3PL_Garage_NewColor",A3PL_Garage_MyColor]) != A3PL_Garage_MyColor) then {
		_file = A3PL_Garage_NewColor;
		_cnt = count _file;
		if (_cnt == 1) then {_file1 = _file select 0;_veh setObjectTextureGlobal [0,_file1]};
		if (_cnt == 2) then {_file1 = _file select 0;_file2 = _file select 1;_veh setObjectTextureGlobal [0,_file1];_veh setObjectTextureGlobal [1,_file2]};
		if (_cnt == 3) then {_file1 = _file select 0;_file2 = _file select 1;_file3 = _file select 2;_veh setObjectTextureGlobal [0,_file1];_veh setObjectTextureGlobal [1,_file2];_veh setObjectTextureGlobal [2,_file3]};
		if (_cnt == 4) then {_file1 = _file select 0;_file2 = _file select 1;_file3 = _file select 2;_file4 = _file select 3;_veh setObjectTextureGlobal [0,_file1];_veh setObjectTextureGlobal [1,_file2];_veh setObjectTextureGlobal [2,_file3];_veh setObjectTextureGlobal [3,_file4]};
	} else {
		_veh setObjectTextureGlobal [0,A3PL_Garage_MyColor];
	};

	if ((missionNameSpace getVariable ["A3PL_Garage_NewMaterial",A3PL_Garage_MyMaterial]) != A3PL_Garage_MyMaterial) then {
		_veh setObjectMaterialGlobal [0,A3PL_Garage_NewMaterial];
	} else {
		_veh setObjectMaterial [0,A3PL_Garage_MyMaterial];
	};

	if ((missionNameSpace getVariable ["A3PL_Garage_tUpgrade",""]) != "") then
	{
		private _getStock = [A3PL_Garage_tUpgrade,_typeOf,"stock"] call A3PL_Config_GetGarageUpgrade;
		if (_getStock isEqualTo false) then {
			[_veh,A3PL_Garage_tUpgrade,0] call A3PL_Garage_Upgrade;
		} else {
			[_veh,_getStock,1] call A3PL_Garage_Upgrade;
		};
	};

	A3PL_Garage_tUpgrade = nil;
	A3PL_Garage_MyColor = nil;
	A3PL_Garage_MyMaterial = nil;
	A3PL_Garage_NewMaterial = nil;
	A3PL_Garage_NewColor = nil;
	deleteVehicle _logic;
	player cameraEffect ["terminate", "BACK"];
}] call compile_Global;

//when we click the "change license plate" button
// ["A3PL_Garage_SetLicensePlate",
// {
// 	private ["_display","_control","_veh","_newLP","_allowedChars","_validChars","_owner","_target"];
// 	_veh = A3PL_Garage_Veh;
// 	_display = findDisplay 62;
// 	_control = _display displayCtrl 1405;
// 	_owner = _veh getVariable ["owner",["",""]];

// 	_target = [_owner#0] call A3PL_Lib_charIDToObject;
// 	if (isNull _target) exitWith {[("STR_A3PL_Garage_OwnerDisconnected" call A3PL_Localize),Color_Red] call A3PL_Notification;};
// 	private _getDay = _target getVariable["Player_Perkday",0];
// 	if (_getDay < 1) exitWith {[("STR_A3PL_Garage_NoPremium" call A3PL_Localize),Color_Red] call A3PL_Notification;};

// 	_pCash = player getVariable ["player_cash",0];
// 	if (Garage_LicensesPlate_Price > _pCash) exitwith {[format["Il vous manque $%1 pour changer la plaque d'immatriculation!",Garage_LicensesPlate_Price-_pCash]] call A3PL_Notification;};

// 	_newLP = ctrlText _control;
// 	_allowedChars = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"];
// 	if ((count _newLP) != 7) exitwith {["Votre plaque d'immatriculation personnalisée doit avoir 7 caractères!",Color_Red] call A3PL_Notification;};
// 	_validChars = true;

// 	for "_i" from 0 to ((count _newLP) - 1) do
// 	{
// 		private ["_test"];
// 		_test = _newLP select [_i,1];
// 		if (!(_test IN _allowedChars)) exitwith {_validChars = false;};
// 	};

// 	if (!(_validChars)) exitwith {["Votre plaque d'immatriculation contient des caractères non-autorisés (caractères autorisés: 0 à 9 et minuscules a-z).",Color_Red] call A3PL_Notification;};

// 	_cars = nearestObjects [player, ["Car"], 10];
// 	_car = _cars select 0;
// 	_id = _car getVariable "owner" select 1;

// 	if (_id IN Garage_Default_Plate) exitWith {["Vous ne pouvez pas changer la plaque de ces véhicules",Color_Red] call A3PL_Notification;};

// 	[player,_veh,_newLP] remoteExec ["Server_Vehicle_InitLPChange", 2, false];
// }] call compile_Global;

// ["A3PL_Garage_SetLicensePlateResponse",
// {
// 	private ["_response"];
// 	 _response = param [0,0];

// 	 switch (_response) do
// 	 {
// 		case (0): {["Cette plaque d'immatriculation est déjà utilisée",Color_Red] call A3PL_Notification;};
//     	case (1): {["Votre plaque d'immatriculation a bien été modifiée",Color_Green] call A3PL_Notification;};
// 		case (2): {["Vous avez déjà changé la plaque d'immatriculation récemment",Color_Red] call A3PL_Notification;};
// 		case (3): {["Vous n'avez pas assez d'argent pour changer votre plaque d'immatriculation",Color_Red] call A3PL_Notification;};
// 	};
// }] call compile_Global;

//when we click a component in the material list
["A3PL_Garage_ClickMaterial",
{
	private _veh = A3PL_Garage_Veh;
	private _display = findDisplay 62;
	private _control = _display displayCtrl 1505;
	private _newMaterial = _control lbData (lbCurSel _control);
	_veh setObjectMaterialGlobal [0,_newMaterial];
}] call compile_Global;

//when we click the set material button 
["A3PL_Garage_SetMaterial",
{
	private _display = findDisplay 62;
	private _control = _display displayCtrl 1505;
	private _veh = A3PL_Garage_Veh;
	private _selectedIndex = lbCurSel _control;
	private _owner = _veh getVariable ["owner",["",""]];

	private _target = [_owner#0] call A3PL_Lib_charIDToObject;
	if (isNull _target) exitWith {[("STR_A3PL_Garage_OwnerDisconnected" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	private _getDay = _target getVariable["Player_Perkday",0];
	if (_getDay < 1) exitWith {[("STR_A3PL_Garage_NoPremium" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	// Vérifier si le joueur est dans une entreprise et si le bâtiment appartient à cette entreprise
	private _isCorporate = [(player getVariable ["character_id",""])] call A3PL_Config_InCompany;
	private _cid = [(player getVariable ["character_id",""])] call A3PL_Config_GetCompanyID;
	private _nearBy = nearestObjects [player, ["Land_A3PL_Garage"], 20];
	private _shopCid = if (count _nearBy > 0) then {(_nearBy select 0) getVariable["cid",0]} else {0};
	private _isFree = _isCorporate && (_shopCid > 0) && (_shopCid == _cid);

	if (!_isFree) then {
		// Paiement normal par le joueur
		private _pCash = player getVariable["player_cash", 0];
		if (Garage_Material_Price > _pCash) exitwith{[format[("STR_A3PL_Garage_MaterialNoMoney" call A3PL_Localize),Garage_Material_Price-_pCash]] call A3PL_Notification;};
		player setVariable["Player_Cash", _pCash - Garage_Material_Price, true];
	};

	if ((lbCurSel _control) < 0) exitwith {[("STR_A3PL_Garage_NoMaterialSelected" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	A3PL_Garage_NewMaterial = _control lbData (lbCurSel _control);

	[format[("STR_A3PL_Garage_MaterialChanged" call A3PL_Localize),Garage_Material_Price],Color_Green] call A3PL_Notification;
}] call compile_Global;

//when we click a component in the repair list
["A3PL_Garage_LBRepair",
{
	private ["_veh","_allHitPoints","_hitArray","_dmgHitArray","_display","_control","_selHit","_selHiti","_dmgValue"];
	_veh = param [0,objNull];
	_display = findDisplay 62;
	if (_veh isEqualType "") then
	{
		_veh = [_veh] call A3PL_Lib_vehStringToObj;
	};

	_control = _display displayCtrl 1502;
	_selHit = _control lbData (lbCurSel _control);
	if(_selHit == "all") then {
		_dmgValue = 1-(damage _veh);
	} else {
		_allHitPoints = getAllHitPointsDamage _veh;
		_hitArray = _allHitPoints select 1;
		_dmghitArray = _allHitPoints select 2;
		_selHiti = _hitArray find _selHit;
		_dmgValue = _dmgHitArray select _selHiti;
	};

	_control = _display displayCtrl 1100;
	_control ctrlSetStructuredText parseText format ["<t align='center' size ='1.4'> %1%2 </t>",round(_dmgValue*100),"%"];
}] call compile_Global;

["A3PL_Garage_Repair",
{
	private _veh = param [0,objNull];
	if (_veh isEqualType "") then {_veh = [_veh] call A3PL_Lib_vehStringToObj;};

	private _display = findDisplay 62;
	private _control = _display displayCtrl 1502;
	private _selHit = _control lbData (lbCurSel _control);
	private _title = "your vehicle";
	private _price = Garage_Repair_Price;
	if(_selHit isEqualTo "all") then {_price = Garage_RepairAll_Price;};
	private _canRepair = false;
	_price = _price * 1.5;

	// Vérifier si le joueur est dans une entreprise et si le bâtiment appartient à cette entreprise
	private _isCorporate = [(player getVariable ["character_id",""])] call A3PL_Config_InCompany;
	private _cid = [(player getVariable ["character_id",""])] call A3PL_Config_GetCompanyID;
	private _nearBy = nearestObjects [player, ["Land_A3PL_Garage"], 20];
	private _shopCid = if (count _nearBy > 0) then {(_nearBy select 0) getVariable["cid",0]} else {0};
	private _isFree = _isCorporate && (_shopCid > 0) && (_shopCid == _cid);

	if (_isFree) then {
		// Service gratuit pour les membres de l'entreprise propriétaire
		_canRepair = true;
	} else {
		/* START HOW TO PAY */
		player setVariable ["paymentResult",objNull];
		[_price] spawn A3PL_Bank_HowToPay;
		waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
		if (!(player getVariable "paymentResult")) exitWith {};
		/* END HOW TO PAY */
		_canRepair = true;
	};

	if (!_canRepair) exitWith {};

	if(_selHit isEqualTo "all") then {
		_veh setDamage 0;
	} else {
		_veh setHit [_selHit,0];
		_title = [_selHit,"title"] call A3PL_Config_GetGarageRepair;
	};
	[format [("STR_A3PL_Garage_Repaired" call A3PL_Localize),_title],Color_Green] call A3PL_Notification;

	private _control = _display displayCtrl 1100;
	_control ctrlSetStructuredText parseText format ["<t align='center' size ='1.4'> %1%2 </t>",0,"%"];
}] call compile_Global;

["A3PL_Garage_ColourSet", {
	private ["_display","_control","_rSlider","_gSlider","_bSlider","_veh","_text","_texture"];
	if(!(call A3PL_Player_AntiSpam)) exitWith {};
	_texture = param [0,""];
	_veh = param [1,objNull];
	if (_veh isEqualType "") then {_veh = [_veh] call A3PL_Lib_vehStringToObj;};
	_display = findDisplay 62;

	_price = Garage_Color_Price;
	if (player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) then {
		_price = Garage_Color_PriceForFaction;
	};

	// Vérifier si le joueur est dans une entreprise et si le bâtiment appartient à cette entreprise
	private _isCorporate = [(player getVariable ["character_id",""])] call A3PL_Config_InCompany;
	private _cid = [(player getVariable ["character_id",""])] call A3PL_Config_GetCompanyID;
	private _nearBy = nearestObjects [player, ["Land_A3PL_Garage"], 20];
	private _shopCid = if (count _nearBy > 0) then {(_nearBy select 0) getVariable["cid",0]} else {0};
	private _isFree = _isCorporate && (_shopCid > 0) && (_shopCid == _cid);
	private _pCash = player getVariable["Player_Cash", 0];

	if (!_isFree) then {
		// Vérification normale pour le joueur
		if (_price > _pCash) exitwith{ [format[("STR_A3PL_Garage_ColourNoMoney" call A3PL_Localize),_price - _pCash],Color_Red] call A3PL_Notification; };
	};

	if (_texture != "") exitwith
	{
		private _control = _display displayCtrl 1504;
		private _id = _control lbData (lbCurSel _control);
		private _job = player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
		private _file = [_id,typeOf _veh,"file",_job] call A3PL_Config_GetGaragePaint;
		if (_file isEqualType []) then {
			_cnt = count _file;
			if (_cnt isEqualTo 1) then {_file1 = _file select 0;_veh setObjectTextureGlobal [0,_file1]};
			if (_cnt isEqualTo 2) then {_file1 = _file select 0;_file2 = _file select 1;_veh setObjectTextureGlobal [0,_file1];_veh setObjectTextureGlobal [1,_file2]};
			if (_cnt isEqualTo 3) then {_file1 = _file select 0;_file2 = _file select 1;_file3 = _file select 2;_veh setObjectTextureGlobal [0,_file1];_veh setObjectTextureGlobal [1,_file2];_veh setObjectTextureGlobal [2,_file3]};
			if (_cnt isEqualTo 4) then {_file1 = _file select 0;_file2 = _file select 1;_file3 = _file select 2;_file4 = _file select 3;_veh setObjectTextureGlobal [0,_file1];_veh setObjectTextureGlobal [1,_file2];_veh setObjectTextureGlobal [2,_file3];_veh setObjectTextureGlobal [3,_file4]};
		};
		A3PL_Garage_NewColor = _file select 0;
		A3PL_Garage_NewColorArry = _file;

		[_veh,_file] remoteExec ["Server_Vehicle_SetPaint",2];
		if (!_isFree) then {
			player setVariable["Player_Cash", _pCash - _price, true];
		};
		[format[("STR_A3PL_Garage_Repainted" call A3PL_Localize),_price],Color_Green] call A3PL_Notification;
	};

	_control = _display displayCtrl 1400;
	_red = parseNumber(ctrlText _control) / 255;
	_control = _display displayCtrl 1401;
	_green = parseNumber(ctrlText _control) / 255;
	_control = _display displayCtrl 1402;
	_blue = parseNumber(ctrlText _control) / 255;

	if((_red > 1) || (_red < 0) || (_green > 1) || (_green < 0) || (_blue > 1) || (_blue < 0)) exitWith {[("STR_A3PL_Garage_ColourInvalidNumber" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_text = format ["#(argb,8,8,3)color(%1,%2,%3,1.0,CO)",_red,_green,_blue];
	A3PL_Garage_NewColor = _text;

	[_veh,_text] remoteExec ["Server_Vehicle_SetPaint",2];
    if (player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)] IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) then {
        private _factionBalance = [player] call A3PL_Government_MyFactionBalance;
        if(_factionBalance < _price) exitwith {[("STR_A3PL_Garage_BudgetInsufficient" call A3PL_Localize),Color_Red] call A3PL_Notification;};
        private _balance = [_faction] call A3PL_Config_GetBalance;
        [_balance,-_price,"",format[("STR_A3PL_Garage_FactionColourChange" call A3PL_Localize)]] remoteExec ["Server_Government_AddBalance",2];
    } else {
		if (!_isFree) then {
			player setVariable["Player_Cash", _pCash - _price, true];
		};
    };
	[format[("STR_A3PL_Garage_Repainted" call A3PL_Localize),_price],Color_Green] call A3PL_Notification;
}] call compile_Global;

["A3PL_Garage_SetColour",
{
	private _veh = param [0,objNull];
	private _texture = param [1,""];
	private _display = findDisplay 62;
	if (_veh isEqualType "") then {
		_veh = [_veh] call A3PL_Lib_vehStringToObj;
	};
	if (isNull _veh) exitwith {};

	if (_texture != "") exitwith
	{
		private _control = _display displayCtrl 1504;
		private _id = _control lbData (lbCurSel _control);
		private _job = player getVariable["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
		private _file = [_id,typeOf _veh,"file",_job] call A3PL_Config_GetGaragePaint;
		if (_file isEqualType true) exitwith {};
		if (_file isEqualType []) then
		{
			_cnt = count _file;
			if (_cnt isEqualTo 1) then {_file1 = _file select 0;_veh setObjectTextureGlobal [0,_file1]};
			if (_cnt isEqualTo 2) then {_file1 = _file select 0;_file2 = _file select 1;_veh setObjectTextureGlobal [0,_file1];_veh setObjectTextureGlobal [1,_file2]};
			if (_cnt isEqualTo 3) then {_file1 = _file select 0;_file2 = _file select 1;_file3 = _file select 2;_veh setObjectTextureGlobal [0,_file1];_veh setObjectTextureGlobal [1,_file2];_veh setObjectTextureGlobal [2,_file3]};
			if (_cnt isEqualTo 4) then {_file1 = _file select 0;_file2 = _file select 1;_file3 = _file select 2;_file4 = _file select 3;_veh setObjectTextureGlobal [0,_file1];_veh setObjectTextureGlobal [1,_file2];_veh setObjectTextureGlobal [2,_file3];_veh setObjectTextureGlobal [3,_file4]};
		};
	};

	_control = _display displayCtrl 1400;
	_red = parseNumber(ctrlText _control) / 255;
	_control = _display displayCtrl 1401;
	_green = parseNumber(ctrlText _control) / 255;
	_control = _display displayCtrl 1402;
	_blue = parseNumber(ctrlText _control) / 255;

	if((_red > 1) || (_red < 0) || (_green > 1) || (_green < 0) || (_blue > 1) || (_blue < 0)) exitWith {[("STR_A3PL_Garage_ColourInvalidNumber" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	_text = format ["#(argb,8,8,3)color(%1,%2,%3,1.0,CO)",_red,_green,_blue];
	_veh setObjectTextureGlobal [0,_text];
}] call compile_Global;

//what happends when we click an upgrade in the listbox
["A3PL_Garage_ClickUpgrade",
{
	disableSerialization;
	private ["_display","_control","_veh","_typeOf","_tpos","_tOffset","_logic","_upgradeType","_title"];
	_display = findDisplay 62; //display of menu
	_control = param [0,controlNull]; //vehicle upgrade lb
	_i = param [1,0]; //index
	_veh = missionNameSpace getVariable ["A3PL_Garage_Veh",ObjNull];
	_cam = missionNameSpace getVariable ["A3PL_Garage_Cam",ObjNull];
	_logic = missionNameSpace getVariable ["A3PL_Garage_Logic",ObjNull];
	_typeOf = typeOf _veh;
	_id = _control lbData _i; //id of selected upgrade

	_upgradeType = [];
	_title = [_id,_typeOf,"title"] call A3PL_Config_GetGarageUpgrade;
	_tPos = [_id,_typeOf,"camTarget"] call A3PL_Config_GetGarageUpgrade; //new camera target
	if (_tPos isEqualType "") then {_tPos = _veh selectionPosition [_tPos,"memory"];}; //get model position of memory point
	_tOffset = [_id,_typeOf,"camOffset"] call A3PL_Config_GetGarageUpgrade; //new camera offset from target

	//set new cam positions
	_logic setpos (_veh modelToWorld _tPos);
	_cam camSetTarget _logic;
	_cam camSetRelPos _tOffset;
	_cam camCommit 2; //2 sec transition

	//set the description of the item
	_control = _display displayCtrl 1101;
	_control ctrlSetStructuredText parseText format ["<t align='center' size ='1'>%1</t>",([_id,_typeOf,"desc"] call A3PL_Config_GetGarageUpgrade)];

	//set the price
	_control = _display displayCtrl 1102;
	_control ctrlSetStructuredText parseText format ["<t align='center' size ='1.2'>$%1</t>",([_id,_typeOf,"price"] call A3PL_Config_GetGarageUpgrade)];

	_control = _display displayCtrl 1501;
	lbClear _control;
	_required = [_id,_typeOf,"required"] call A3PL_Config_GetGarageUpgrade;
	_lbArray = [];
	{
		private ["_i","_name","_amount","_class"];
		_class = _x select 0;
		_amount = _x select 1;
		_name = format ["%1x %2",_amount,([_class,"name"] call A3PL_Config_GetItem)];
		if ([_class,_amount] call A3PL_Inventory_Has) then
		{
			_lbArray pushback [_name,_class,true];
		} else
		{
			_lbArray pushback [_name,_class,false];
		};
	} foreach _required;
	lbClear _control;
	{
		_i = _control lbAdd (_x select 0);
		_control lbSetData [_i,(_x select 1)];
		if (_x select 2) then {_control lbSetColor [_i,[0, 1, 0, 1]];} else {_control lbSetColor [_i,[1, 0, 0, 1]];};
	} foreach _lbArray;

	//Set the button action for upgrading
	_control = _display displayCtrl 1600;
	_control buttonSetAction format
	[
		"
			private ['_installed'];
			if(!(call A3PL_Player_AntiSpam)) exitWith {};
			_installed = isNil 'A3PL_Garage_tUpgrade';
			if (_installed) then {_installed = 0;} else {_installed = 1};
			['%1','%2',_installed, false] call A3PL_Garage_Upgrade;
		",_veh,_id,_title,"green"
	];

	//undo any previous temp upgrades
	if ((missionNameSpace getVariable ["A3PL_Garage_tUpgrade",""]) != "") then
	{
		_getStock = [A3PL_Garage_tUpgrade,_typeOf,"stock"] call A3PL_Config_GetGarageUpgrade;
		if (_getStock isEqualTo false) then {
			[_veh,A3PL_Garage_tUpgrade,0] call A3PL_Garage_Upgrade;
		} else {
			[_veh,_getStock,1] call A3PL_Garage_Upgrade;
		};
	};

	//install the addon while we preview it
	if (!([_veh,_id] call A3PL_Garage_isInstalled)) then
	{
		[_veh,_id] call A3PL_Garage_Upgrade;
		A3PL_Garage_tUpgrade = _id;
	} else
	{
		A3PL_Garage_tUpgrade = nil;
	};
}] call compile_Global;

//check if an upgrade is already installed
["A3PL_Garage_isInstalled",
{
	private ["_veh","_id","_typeOf","_installed","_upgradeType"];
	_veh = param [0,objNull,[objNull,""]];
	if (_veh isEqualType "") then //edited bypass used in ATC so we can send object from setButtonAction
	{
		_veh = [_veh] call A3PL_Lib_vehStringToObj;
	};
	if (isNull _veh) exitwith {["Error code #03",Color_Red] call A3PL_Notification;};
	_id = param [1,""];
	_typeOf = typeOf _veh;
	_upgradeType = [_id,_typeOf,"type"] call A3PL_Config_GetGarageUpgrade;

	_installed = false;
	switch (_upgradeType) do
	{
		case ("addon"):
		{
			private ["_animation"];
			_animation = [_id,_typeOf,"class"] call A3PL_Config_GetGarageUpgrade;
			if (_veh animationSourcePhase _animation > 0.5) then
			{
				_installed = true;
			};
		};
	};
	_installed;
}] call compile_Global;

//either installs, or deinstalls an upgrade
["A3PL_Garage_Upgrade",
{
	private ["_veh","_id","_typeOf","_isInstalled","_upgradeType","_upgradeClass","_forceInstall"];
	_veh = param [0,objNull,[objNull,""]];
	_id = param [1,""];
	_forceInstall = param [2,-1]; //-1 dont force, 0 no, 1 yes NOTE: will also be used as new anim value
	_preview = param [3,true];

	if (_veh isEqualType "") then //edited bypass used in ATC so we can send object from setButtonAction
	{
		_veh = [_veh] call A3PL_Lib_vehStringToObj;
	};
	_typeOf = typeOf _veh;
	_upgradeType = [_id,_typeOf,"type"] call A3PL_Config_GetGarageUpgrade;
	_upgradeClass = [_id,_typeOf,"class"] call A3PL_Config_GetGarageUpgrade;
	if (isNil "_veh") exitwith {["Error code #05",Color_Red] call A3PL_Notification;};

	//determine if upgrade is already installed
	_isInstalled = [_veh,_id] call A3PL_Garage_isInstalled;

	_failed = false;
	if(!_preview) then {
		if(_forceInstall isEqualTo 1) then {
			_upgradePrice = [_id,_typeOf,"price"] call A3PL_Config_GetGarageUpgrade;
			_required = [_id,_typeOf,"required"] call A3PL_Config_GetGarageUpgrade;
			
			// Vérifier si le joueur est dans une entreprise et si le bâtiment appartient à cette entreprise
			private _isCorporate = [(player getVariable ["character_id",""])] call A3PL_Config_InCompany;
			private _cid = [(player getVariable ["character_id",""])] call A3PL_Config_GetCompanyID;
			private _nearBy = nearestObjects [player, ["Land_A3PL_Garage"], 20];
			private _shopCid = if (count _nearBy > 0) then {(_nearBy select 0) getVariable["cid",0]} else {0};
			private _isFree = _isCorporate && (_shopCid > 0) && (_shopCid == _cid);

			if (!_isFree) then {
				// Vérification normale pour le joueur
				_pCash = player getVariable ["Player_Cash",0];
				if (_pCash < _upgradePrice) exitwith {
					[format[("STR_A3PL_Garage_UpgradeNoMoney" call A3PL_Localize),_upgradePrice-_pCash],Color_Red] call A3PL_Notification;
					_failed=true;
				};
			};
			
			{if (!([_x select 0,_x select 1] call A3PL_Inventory_Has)) exitwith {[format[("STR_A3PL_Garage_UpgradeNoItem" call A3PL_Localize),[_id,_typeOf,"title"] call A3PL_Config_GetGarageUpgrade],Color_Red] call A3PL_Notification; _failed=true;};} foreach _required;
			if (_failed) exitwith {};
			
			// Paiement (gratuit si membre de l'entreprise propriétaire)
			if (!_isFree) then {
				player setVariable ["Player_Cash",(player getVariable ["Player_Cash",0]) - _upgradePrice,true];
			};
			
			{[_x select 0,-(_x select 1)] call A3PL_Inventory_Add;} foreach _required;
			[format[("STR_A3PL_Garage_UpgradeInstalled" call A3PL_Localize),[_id,_typeOf,"title"] call A3PL_Config_GetGarageUpgrade],Color_Green] call A3PL_Notification;
		};
	};

	if !(_failed) then {
		switch (_upgradeType) do
		{
			case ("addon"):
			{
				if (_forceInstall == -1) exitwith
				{
					if (!_isInstalled) then { [_veh, nil, [_upgradeClass, 1]] call A3PL_Garage_InstallUpgrades; } else { [_veh, nil, [_upgradeClass, 0]] call A3PL_Garage_InstallUpgrades; }; //just writing it on one line since its not that complicated
				};
				if ((_veh animationSourcePhase _upgradeClass) != _forceInstall) then
				{
					[_veh, nil, [_upgradeClass, _forceInstall]] call A3PL_Garage_InstallUpgrades;
				};
				if (_forceInstall == 1) then
				{
					A3PL_Garage_tUpgrade = nil;
				} else
				{
					A3PL_Garage_tUpgrade = _id;
				};
			};
		};
	};
}] call compile_Global;

//COMPILE BLOCK
["A3PL_Garage_InstallUpgrades",
{
	private ["_vehicle","_variant","_animations", "_bChangeMass"];
	_vehicle 	= param [0, objNull, [objNull]];
	_variant 	= param [1, false, ["STRING", false, 0, []]];
	_animations 	= param [2, false, [[], false, "STRING"]];
	_bChangeMass 	= param [3, false, [false, 0]];

	//if !(local _vehicle) exitWith {false};

	/*---------------------------------------------------------------------------
		Get parameters from the config & the vehicle & prepare the local variables
	---------------------------------------------------------------------------*/
	private ["_vehicleType", "_listToSkip", "_addMass","_isCampaign"];
	_vehicleType = typeOf _vehicle;
	_skipRandomization = ({(_vehicleType isEqualTo _x) || (_vehicleType isKindOf _x) || (format ["%1", _vehicle] isEqualTo _x)} count (getArray(missionConfigfile >> "disableRandomization")) > 0 || !(_vehicle getVariable ["BIS_enableRandomization", true]));

	if (_bChangeMass isEqualType 0) then {
		_addMass = _bChangeMass;
		_bChangeMass = true;
	} else {
		_addMass = 0;
	};

	if (getNumber(missionConfigfile >> "CfgVehicleTemplates" >> "disableMassChange") == 1) then {
		_bChangeMass = false;
	};

	_isCampaign = isClass(campaignConfigFile >> "CfgVehicleTemplates");

	/*---------------------------------------------------------------------------
		Texture source selection & Set the selected texture
	---------------------------------------------------------------------------*/
	if !(_variant isEqualTo false) then {
		private ["_texturesToApply","_textureList","_textureSources","_textureSource","_probabilities","_materialsToApply"];
		_texturesToApply = [];
		_materialsToApply = [];
		_textureList = getArray(configFile >> "CfgVehicles" >> _vehicleType >> "TextureList");

		if (_variant isEqualType []) then {
			_textureList = _variant;
			_variant = "";
		};

		if (_variant isEqualType true) Then {
			if (count _textureList > 0) Then {
				_variant = _textureList select 0;
			} else {
				_variant = "";
			};
		};

		// 1 Support for the old method from Pettka
		if (_variant isEqualType 0) then {
			_variant = if ((_variant >= 0) && ((_variant * 2) <= (count _textureList) -2)) then {_textureList select (_variant * 2)} else {""};
		};

		// 2 Try from the config file (parents only)
		if (_vehicleType in ([(configFile >> "CfgVehicles" >> _variant), true] call BIS_fnc_returnParents)) then {
			private ["_cfgRoot"];
			_textureList = getArray(configFile >> "CfgVehicles" >> _variant >> "TextureList");
			_textureSources = [];
			_probabilities = [];
			for "_i" from 0 to (count _textureList -1) step 2 do {
				_textureSources append [_textureList select _i];
				_probabilities append [_textureList select (_i +1)];
			};
			_cfgRoot = (configFile >> "CfgVehicles" >> _variant >> "textureSources" >> (_textureSources selectRandomWeighted _probabilities));
			_texturesToApply = getArray(_cfgRoot >> "textures");
			_materialsToApply = getArray(_cfgRoot >> "materials");
		};

		// 3 Try from the textureSources of the current vehicle
		if (count _texturesToApply == 0 && {isClass (configfile >> "CfgVehicles" >> _vehicleType >> "textureSources" >> _variant)}) then {
			_texturesToApply = getArray(configfile >> "CfgVehicles" >> _vehicleType >> "textureSources" >> _variant >> "textures");
			_materialsToApply = getArray(configfile >> "CfgVehicles" >> _vehicleType >> "textureSources" >> _variant >> "materials");
		};

		// 4 Valid class from the campaign config file
		if (_isCampaign && {isClass (campaignConfigFile >> "CfgVehicleTemplates" >> _variant)}) then {
			if (count (getArray(campaignConfigFile >> "CfgVehicleTemplates" >> _variant >> "textures")) >= 1) then {
				_texturesToApply = getArray(campaignConfigFile >> "CfgVehicleTemplates" >> _variant >> "textures");
				_materialsToApply = getArray(campaignConfigFile >> "CfgVehicleTemplates" >> _variant >> "materials");
			} else {
				_texturesToApply = [];
				_materialsToApply = [];
				_textureList = getArray(campaignConfigFile >> "CfgVehicleTemplates" >> _variant >> "textureList")
			};
		};

		// 5 If _variant is a valid class from the mission config file, override textureList and empty texturesToApply
		if (isClass (missionConfigFile >> "CfgVehicleTemplates" >> _variant)) then {
			if (count (getArray(missionConfigFile >> "CfgVehicleTemplates" >> _variant >> "textures")) >= 1) then {
				_texturesToApply = getArray(missionConfigFile >> "CfgVehicleTemplates" >> _variant >> "textures");
				_materialsToApply = getArray(missionConfigFile >> "CfgVehicleTemplates" >> _variant >> "materials");
			} else {
				_texturesToApply = [];
				_materialsToApply = [];
				_textureList = getArray(missionConfigFile >> "CfgVehicleTemplates" >> _variant >> "textureList")
			};
		};

		// 4 Else, randomize using the texture list (from the config of the current vehicle)
		if (!(_skipRandomization) && {count _texturesToApply == 0 && {count _textureList >= 2}}) then {
			private ["_cfgRoot"];
			_textureSources = [];
			_probabilities = [];
			for "_i" from 0 to (count _textureList -1) step 2 do {
				_textureSources append [_textureList select _i];
				_probabilities append [_textureList select (_i +1)];
			};
			_cfgRoot = configFile >> "CfgVehicles" >> _vehicleType >> "textureSources" >> (_textureSources selectRandomWeighted _probabilities);
			_texturesToApply = getArray(_cfgRoot >> "textures");
			_materialsToApply = getArray(_cfgRoot >> "materials");
		};

		// change the textures
		{_vehicle setObjectTextureGlobal [_forEachindex, _x];} forEach _texturesToApply;

		// change the materials when it is appropriate
		{if (_x != "") then {_vehicle setObjectMaterialGlobal [_forEachindex, _x];};} forEach _materialsToApply;
	};

	/*---------------------------------------------------------------------------
		Animation sources
	---------------------------------------------------------------------------*/
	if !(_animations isEqualTo false) then {
		private ["_animationList","_resetAnimationSources"];

		_animationList = getArray(configFile >> "CfgVehicles" >> _vehicleType >> "animationList");

		// Find if whether or not the reset of the animation sources should be reset
		_resetAnimationSources = if (_animations isEqualType [] && {count _animations > 0 && {(_animations select 0) isEqualType true}}) then
		{
			_animations deleteAt 0;
		} else {
			true
		};

		if (_resetAnimationSources) then {
			// reset animations
			{
				if (_x isEqualType "") then {
					_vehicle animatesource [_x, getNumber(configFile >> "CfgVehicles" >> _vehicleType >> "animationSources" >> _x >> "initPhase"), true];
				};
			} forEach _animationList;
		};

		// Exit if _animations is true (nothing else to do)
		if (_animations isEqualTo true) exitWith {};

		if (!(_skipRandomization) && {(_animations isEqualType "" || _variant isEqualType "")}) then {
			// 6 - Variant parameter - If the variant is a string and animation is either, an empty string or array
			if ((_variant isEqualType "") && {isClass (configFile >> "CfgVehicles" >> _variant) && {_animations isEqualTo "" || _animations isEqualTo []}}) then {
				_animationList = getArray(configFile >> "CfgVehicles" >> _variant >> "animationList");
			};

			// 5 - Variant parameter - Campaign
			if (_isCampaign && {(_variant isEqualType "") && {(_animations isEqualTo "" || _animations isEqualTo []) && {isClass (campaignConfigFile >> "CfgVehicleTemplates" >> _variant)}}}) then
			{
				_animationList = getArray(campaignConfigFile >> "CfgVehicleTemplates" >> _variant >> "animationList");
			};

			// 4 - Variant parameter - Try from the mission config (_variant)
			if ((_variant isEqualType "") && {isClass (missionConfigFile >> "CfgVehicleTemplates" >> _variant) && {_animations isEqualTo "" || _animations isEqualTo []}}) then {
				_animationList = getArray(missionConfigFile >> "CfgVehicleTemplates" >> _variant >> "animationList");
			};

			// 3 - animation parameter - Try from the config (_animations)
			if (_animations isEqualType "" && {isArray (configFile >> "CfgVehicles" >> _animations >> "animationList")}) then {
				_animationList = getArray(configFile >> "CfgVehicles" >> _animations >> "animationList");
			};

			// 2 - animation parameter - Campaign
			if (_isCampaign && {_animations isEqualType "" && {isArray (campaignConfigFile >> "CfgVehicleTemplates" >> _animations >> "animationList")}}) then {
				_animationList = getArray(campaignConfigFile >> "CfgVehicleTemplates" >> _animations >> "animationList");
			};

			// 1 - animation parameter - Try from the mission config (template class name)
			if (_animations isEqualType "" && {isArray (missionConfigFile >> "CfgVehicleTemplates" >> _animations >> "animationList")}) then {
				_animationList = getArray(missionConfigFile >> "CfgVehicleTemplates" >> _animations >> "animationList");
			};
		};

		// 4 If (_animations is an array) then, use it
		if (_animations isEqualType [] && {count _animations > 1 && {count _animations mod 2 == 0 && {(_animations select 1) isEqualType 0}}}) then {
			_animationList = _animations;
		};

		// Change animation sources
		_vehicle setvariable ["bis_fnc_initVehicle_animations",_animationList];
		if (count _animationList > 1) then {
			private ["_CfgPath"];
			_CfgPath = (configfile >> "CfgVehicles" >> _vehicleType >> "AnimationSources");

			for "_i" from 0 to (count _animationList -1) step 2 do {
				private ["_source", "_lockCargoAnimationPhase", "_lockCargo", "_chance", "_rand", "_bLockCargo", "_bLockTurret", "_forceAnimatePhase", "_forceAnimate", "_phase", "_lockTurretAnimationPhase", "_lockTurret"];

				_source = _animationList select _i;
				_lockCargoAnimationPhase = getNumber(_CfgPath >> _source >> "lockCargoAnimationPhase");
				_lockCargo = getArray(_CfgPath >> _source >> "lockCargo");
				_forceAnimatePhase = getNumber(_CfgPath >> _source >> "forceAnimatePhase");
				_forceAnimate = getArray(_CfgPath >> _source >> "forceAnimate");
				_chance = _animationList select (_i+1);

				_phase = if ((random 1) <= _chance) then {1} else {0};

				_vehicle animatesource [_source, _phase, true];

				if (_forceAnimatePhase == _phase) then {
					for "_i" from 0 to (count _forceAnimate -1) step 2 do {

						_vehicle animatesource [(_forceAnimate select _i), (_forceAnimate select (_i +1)), true];
					};
				};

				_blockCargo = (_lockCargoAnimationPhase == _phase);
				{_vehicle lockCargo [_x, _blockCargo];} forEach _lockCargo;
				[_vehicle, _phase] call compile (getText(configfile >> "CfgVehicles" >> _vehicleType >> "AnimationSources" >> _source >> "onPhaseChanged"));
			};

			//Update in DB
			_upgrades = ["all",(typeOf _vehicle),""] call A3PL_Config_GetGarageUpgrade;
			_addons = [];
			{_addons pushBack ([_x select 0, _vehicle animationSourcePhase (_x select 0)]);} foreach _upgrades;
			[_vehicle,_addons] remoteExec ["Server_Garage_UpdateAddons",2];
		};
	};

	/*---------------------------------------------------------------------------
		Mass change
	---------------------------------------------------------------------------*/
	if (_bChangeMass) then {
		_bChangeMass = [_vehicle, _bChangeMass, _addMass] call bis_fnc_setVehicleMass;
	};

	/*---------------------------------------------------------------------------
		End of function
	---------------------------------------------------------------------------*/

	//true
}] call compile_Global;

["A3PL_Garage_NPCRepair",
{
	if(!(call A3PL_Player_AntiSpam)) exitWith {};

	// Check if any mechanic (company with "custom" license) is online
	private _mechanicOnline = false;
	{
		private _isCompanyJob = (_x getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)]) isEqualTo ("STR_Common_Company" call A3PL_Localize);
		if (_isCompanyJob) then {
			private _hasLicense = [_x,"custom"] call A3PL_Company_HasLicense;
			if (_hasLicense) exitWith {_mechanicOnline = true;};
		};
	} forEach allPlayers;

	if (_mechanicOnline) exitWith {
		[("STR_A3PL_Garage_NPCRepair_MechanicOnline" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};

	// Find nearest vehicle
	private _veh = (nearestObjects [player,["Car_F","Ship_F","Tank_F"],25]) select 0;
	if (isNil "_veh") exitWith {
		[("STR_A3PL_Garage_NPCRepair_NoVehicle" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};
	if (isNull _veh) exitWith {
		[("STR_A3PL_Garage_NPCRepair_NoVehicle" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};

	private _allHitPoints = getAllHitPointsDamage _veh;
	private _isDamaged = false;
	if (damage _veh > 0) then {_isDamaged = true;};
	if (!_isDamaged && {count _allHitPoints > 2}) then {
		{if (_x > 0) exitWith {_isDamaged = true;};} forEach (_allHitPoints select 2);
	};
	if (!_isDamaged) exitWith {
		[("STR_A3PL_Garage_NPCRepair_NotDamaged" call A3PL_Localize),Color_Red] call A3PL_Notification;
	};

	private _price = Garage_NPC_RepairPrice;

	// Get the garage CID from the repair NPC
	private _repairNPC = player_objintersect;
	private _garage = _repairNPC getVariable ["parentGarage", objNull];
	private _garageCid = if (!isNull _garage) then {_garage getVariable ["cid", -1]} else {-1};

	/* START HOW TO PAY */
	player setVariable ["paymentResult",objNull];
	[_price] call A3PL_Bank_HowToPay;
	[_veh, _price, _garageCid] spawn {
		params ["_veh", "_price", "_garageCid"];
		waitUntil {(player getVariable ["paymentResult", objNull]) isNotEqualTo objNull};
		if (!(player getVariable "paymentResult")) exitWith {};
		/* END HOW TO PAY */

		Player_ActionInterrupted = false;
		Player_ActionCompleted = false;
		[("STR_A3PL_Garage_NPCRepair_Repairing" call A3PL_Localize), 10] spawn A3PL_Lib_LoadAction;
		waitUntil {Player_ActionCompleted || Player_ActionInterrupted};

		if (Player_ActionInterrupted) exitWith {
			[("STR_A3PL_Garage_NPCRepair_Interrupted" call A3PL_Localize),Color_Red] call A3PL_Notification;
			// Refund the player
			player setVariable ["player_cash",(player getVariable ["player_cash",0]) + _price, true];
		};

		_veh setDamage 0;

		// Pay the company that owns the garage
		if (_garageCid > 0) then {
			[_garageCid, _price, "NPC Repair"] remoteExec ["Server_Company_SetBank", 2];
		};

		[format [("STR_A3PL_Garage_NPCRepair_Done" call A3PL_Localize), _price], Color_Green] call A3PL_Notification;
	};
}] call compile_Global;
