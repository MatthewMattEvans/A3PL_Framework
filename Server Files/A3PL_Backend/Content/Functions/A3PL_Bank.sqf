/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
["A3PL_Bank_Dashboard", {
	private["_display"];
	if(!dialog) then {
		createDialog "A3PL_Bank_Dialog";
	};
	disableSerialization;
	(findDisplay 21500) call A3PL_Dialog_Localize;

	/*
	if (!_CommonActive) ---------------------------------- Si aucun compte bancaire
	if (_CommonActive && !_SavingsActive) ---------------- Si uniquement compte chèque
	if (_CommonActive && _SavingsActive && !_CODActive) -- Si compte chèque et Savings Account
	if (_CommonActive && _SavingsActive && _CODActive) --- Si tous les comptes
	
	*/

	// Récupération des affichages des comptes
	_display = findDisplay 21500;
	_NoAccountBG = _display displayCtrl 1201;
	_HasCommonAccountBG = _display displayCtrl 1202;
	_HasSavingsAccountBG = _display displayCtrl 1203;
	_HasCODAccountBG = _display displayCtrl 1204;

	// Par défaut, les comptes sont cachés
	_NoAccountBG ctrlShow false;
	_HasCommonAccountBG ctrlShow false;
	_HasSavingsAccountBG ctrlShow false;
	_HasCODAccountBG ctrlShow false;

	// Récupération de l'affichage des montants des comptes et de la créance
	_commonAmount = _display displayCtrl 1221;
	_debts = _display displayCtrl 12211;
	_savingsAmount = _display displayCtrl 1222;
	_codAmount = _display displayCtrl 1223;

	// Récupération des boutons d'accès/achat
	_opencommon = _display displayCtrl 1227;
	_opensavings = _display displayCtrl 1228;
	_opencod = _display displayCtrl 1229;

	// Récupération du bouton lier/délier
	_linkunlink = _display displayCtrl 1226;

	// Détermination du plafond de la carte (Dans l'ordre de priorité Platinum > Gold > Classique) et du texte à afficher
	_maxpayment = _display displayCtrl 1224;
	_LimitCB = player getVariable ["Player_LimitCB",0];
	_LimitText = "";
	if ("A3PL_CB_Platinum" in (magazines player)) then {
		_LimitText = format[("STR_A3PL_Bank_Illimited" call A3PL_Localize),[_LimitCB] call BIS_fnc_numberText];
	} else {
		if ("A3PL_CB_Gold" in (magazines player)) then {
			_LimitText = format[("STR_A3PL_Bank_PerHour" call A3PL_Localize),[_LimitCB] call BIS_fnc_numberText,[Bank_AmericanExpressLimit_Gold] call BIS_fnc_numberText];
		} else {
			if ("A3PL_CB" in (magazines player)) then {
				_LimitText = format[("STR_A3PL_Bank_PerHour" call A3PL_Localize),[_LimitCB] call BIS_fnc_numberText,[Bank_AmericanExpressLimit_Standard] call BIS_fnc_numberText];
			} else {
				_LimitText = ("STR_A3PL_Bank_NoCardFound" call A3PL_Localize);
			};
		};
	};

	// Récupération du plafond et du statut de liaison de la carte
	_ActiveCB = player getVariable ["Player_ActiveCB",0];
	_linked = _display displayCtrl 1225;

	// Récupération des statuts des comptes, et de leurs soldes, en plus de la créance du joueur
	_CommonActive = player getVariable ["Player_BankActive",false];
	_pBank = player getVariable ["Player_Bank",0];
	_pDebts = player getVariable ["Player_Debt",0];
	_SavingsActive = player getVariable ["Player_SavingsAccountActive",false];
	_Sbank = player getVariable ["Player_SavingsAccount",0];
	_CODActive = player getVariable ["Player_CertificateOfDepositActive",false];
	_CODbank = player getVariable ["Player_CertificateOfDeposit",0];

	// Détermination de la couleur du solde du Compte chèque
	_commonamountcolor = [0,0,0,1];
	switch (true) do {
		case (_pBank >= 15000): {_commonamountcolor = [0.106,0.592,0.071,1.0]};
		case ((-1 < _pBank) && (_pBank < 15000)): {_commonamountcolor = [0.741,0.431,0.000,1.0]};
		case (_pBank < 0): {_commonamountcolor = [0.745,0.016,0.016,1.0]};
	};

	// Détermination de la couleur du solde du Savings Account
	_savingsamountcolor = [0,0,0,1];
	switch (true) do {
		case (_Sbank >= 15000): {_savingsamountcolor = [0.106,0.592,0.071,1.0]};
		case ((-1 < _Sbank) && (_Sbank < 15000)): {_savingsamountcolor = [0.741,0.431,0.000,1.0]};
		case (_Sbank < 0): {_savingsamountcolor = [0.745,0.016,0.016,1.0]};
	};

	// Détermination de la couleur du solde du Certificate of Deposit
	_codamountcolor = [0,0,0,1];
	switch (true) do {
		case (_CODbank >= 15000): {_codamountcolor = [0.106,0.592,0.071,1.0]};
		case ((-1 < _CODbank) && (_CODbank < 15000)): {_codamountcolor = [0.741,0.431,0.000,1.0]};
		case (_CODbank < 0): {_codamountcolor = [0.745,0.016,0.016,1.0]};
	};

	// Détermination de la couleur de la créance
	_debtscolor = [0,0,0,1];
	switch (true) do {
		case (_pDebts > 0): {_debtscolor = [0.106,0.592,0.071,1.0]};
		case (_pDebts < 0): {_debtscolor = [0.745,0.016,0.016,1.0]};
	};

	// Détermination du texte de la créance: Dans l'ordre, créance positive, créance nulle, créance négative
	_debtsText = "";
	if (_pDebts > 0) then {_debtsText = format[("STR_A3PL_Bank_DebtPositive" call A3PL_Localize),_pDebts]};
	if (_pDebts == 0) then {_debtsText = ("STR_A3PL_Bank_NoDebt" call A3PL_Localize)};
	if (_pDebts < 0) then {_debtsText = format[("STR_A3PL_Bank_DebtNegative" call A3PL_Localize),abs _pDebts]};

	
	if (!_CommonActive) then {
		// Affichage contenant aucun compte acheté
		_NoAccountBG ctrlShow true;

		// Le bouton lier/délier est désactivé, faute de compte
		_linkunlink ctrlShow false;

		// achat possible du Compte chèque, impossible pour le Savings Account ni pour le Certificate of Deposit
		_opencommon buttonSetAction "[0] spawn A3PL_Bank_achatCompteBancaire";
		_opensavings buttonSetAction "['STR_A3PL_Bank_NoCommonAccount' call A3PL_Localize,Color_Red] call A3PL_Notification";
		_opencod buttonSetAction "['STR_A3PL_Bank_NoCommonAccount' call A3PL_Localize,Color_Red] call A3PL_Notification";
		
	};
	if (_CommonActive && !_SavingsActive) then {
		// Affichage contenant le compte chèque uniquement
		_HasCommonAccountBG ctrlShow true;

		// Accès uniquement au Compte chèque, achat possible du Savings Account, impossible pour le Certificate of Deposit
		_opencommon buttonSetAction "[0] spawn A3PL_Bank_CommonPages";
		_opensavings buttonSetAction "[1] spawn A3PL_Bank_achatCompteBancaire";
		_opencod buttonSetAction "['STR_A3PL_Bank_NoSavingsAccount' call A3PL_Localize,Color_Red] call A3PL_Notification";

		// Affichage du solde du Compte chèque et de la créance uniquement
		_commonAmount ctrlSetText format["$%1",[_pBank] call BIS_fnc_numberText];
		_commonAmount ctrlSetTextColor _commonamountcolor;
		_debts ctrlSetText format["%1",_debtsText];
		_debts ctrlSetTextColor _debtscolor;

		// Affichage du plafond de la plus haute carte, et de l'état de liaison
		_maxpayment ctrlSetText format["%1",_LimitText];
		_linked ctrlSetText format["%1",if (_ActiveCB isEqualTo 1) then {("STR_Common_Yes" call A3PL_Localize)} else {("STR_Common_No" call A3PL_Localize)}];
	};
	if (_CommonActive && _SavingsActive && !_CODActive) then {
		// Affichage contenant le compte chèque et le Savings Account
		_HasSavingsAccountBG ctrlShow true;

		// L'utilisateur peut accéder aux deux premiers, et peut acheter le troisième
		_opencommon buttonSetAction "[0] spawn A3PL_Bank_CommonPages";
		_opensavings buttonSetAction "[0] spawn A3PL_Bank_SparePages";
		_opencod buttonSetAction "[2] spawn A3PL_Bank_achatCompteBancaire";

		// Affichage du solde du Compte chèque, de la créance et du Savings Account
		_commonAmount ctrlSetText format["$%1",[_pBank] call BIS_fnc_numberText];
		_commonAmount ctrlSetTextColor _commonamountcolor;
		_debts ctrlSetText format["%1",_debtsText];
		_debts ctrlSetTextColor _debtscolor;
		_savingsAmount ctrlSetText format["$%1",[_Sbank] call BIS_fnc_numberText];
		_savingsAmount ctrlSetTextColor _savingsamountcolor;

		// Affichage du plafond de la plus haute carte, et de l'état de liaison
		_maxpayment ctrlSetText format["%1",_LimitText];
		_linked ctrlSetText format["%1",if (_ActiveCB isEqualTo 1) then {("STR_Common_Yes" call A3PL_Localize)} else {("STR_Common_No" call A3PL_Localize)}];
	};
	if (_CommonActive && _SavingsActive && _CODActive) then {
		// Affichage contenant tout les comptes et soldes
		_HasCODAccountBG ctrlShow true;

		// L'utilisateur a tout les comptes, accès possible
		_opencommon buttonSetAction "[0] spawn A3PL_Bank_CommonPages";
		_opensavings buttonSetAction "[0] spawn A3PL_Bank_SparePages";
		_opencod buttonSetAction "[1] spawn A3PL_Bank_SparePages";

		// Affichage du solde des 3 comptes et de la créance
		_commonAmount ctrlSetText format["$%1",[_pBank] call BIS_fnc_numberText];
		_commonAmount ctrlSetTextColor _commonamountcolor;
		_debts ctrlSetText format["%1",_debtsText];
		_debts ctrlSetTextColor _debtscolor;
		_savingsAmount ctrlSetText format["$%1",[_Sbank] call BIS_fnc_numberText];
		_savingsAmount ctrlSetTextColor _savingsamountcolor;
		_codAmount ctrlSetText format["$%1",[_CODbank] call BIS_fnc_numberText];
		_codAmount ctrlSetTextColor _codamountcolor;

		// Affichage du plafond de la plus haute carte, et de l'état de liaison
		_maxpayment ctrlSetText format["%1",_LimitText];
		_linked ctrlSetText format["%1",if (_ActiveCB isEqualTo 1) then {("STR_Common_Yes" call A3PL_Localize)} else {("STR_Common_No" call A3PL_Localize)}];
	};


	// Récupération et affichage du prénom du joueur
	_name = _display displayCtrl 1211;
	_pname = (player getVariable ["name","unknown"]) splitString " ";
	_name ctrlSetStructuredText parseText format["%1",_pname#0];

	// Boutons d'achat des cartes
	_buyclassic = _display displayCtrl 1230;
	_buygold = _display displayCtrl 1231;
	_buyplatinum = _display displayCtrl 1232;
	_buyclassic buttonSetAction "[Bank_AmericanExpressPrice_Standard] call A3PL_Bank_HowToPay; [] spawn {waitUntil {(player getVariable['paymentResult', objNull]) isNotEqualTo objNull};if (player getVariable 'paymentResult') then {player addMagazines ['A3PL_CB',1];};[3] spawn A3PL_Bank_updateCompteBancaire;}";
	_buygold buttonSetAction "[Bank_AmericanExpressPrice_Gold] call A3PL_Bank_HowToPay; [] spawn {waitUntil {(player getVariable['paymentResult', objNull]) isNotEqualTo objNull};if (player getVariable 'paymentResult') then {player addMagazines ['A3PL_CB_Gold',1];};[3] spawn A3PL_Bank_updateCompteBancaire;}";
	_buyplatinum buttonSetAction "[Bank_AmericanExpressPrice_Platinum] call A3PL_Bank_HowToPay; [] spawn {waitUntil {(player getVariable['paymentResult', objNull]) isNotEqualTo objNull};if (player getVariable 'paymentResult') then {player addMagazines ['A3PL_CB_Platinum',1];};[3] spawn A3PL_Bank_updateCompteBancaire;}";


	// Plafond, prix et frais de la carte classique
	_classicmax = _display displayCtrl 1212;
	_classicmax ctrlSetStructuredText parseText format["$%1/h",Bank_AmericanExpressLimit_Standard];
	_classicprice = _display displayCtrl 1213;
	_classicprice ctrlSetStructuredText parseText format["$%1",Bank_AmericanExpressPrice_Standard];
	_classicfees = _display displayCtrl 1214;
	_classicfees ctrlSetStructuredText parseText format["$%1/h",Bank_AmericanExpressCost_Standard];

	// Plafond, prix et frais de la carte gold
	_goldcmax = _display displayCtrl 1215;
	_goldcmax ctrlSetStructuredText parseText format["$%1/h",Bank_AmericanExpressLimit_Gold];
	_goldprice = _display displayCtrl 1216;
	_goldprice ctrlSetStructuredText parseText format["$%1",Bank_AmericanExpressPrice_Gold];
	_goldfees = _display displayCtrl 1217;
	_goldfees ctrlSetStructuredText parseText format["$%1/h",Bank_AmericanExpressCost_Gold];

	// Prix et frais de la carte platinum
	_platinumprice = _display displayCtrl 1219;
	_platinumprice ctrlSetStructuredText parseText format["$%1",Bank_AmericanExpressPrice_Platinum];
	_platinumfees = _display displayCtrl 1220;
	_platinumfees ctrlSetStructuredText parseText format["$%1/h",Bank_AmericanExpressCost_Platinum];

	// Action lier/délier la carte
	_linkunlink buttonSetAction "[] spawn A3PL_Bank_cbParametre";
}] call compile_Global;

["A3PL_Bank_CommonPages", {
	private["_display"];
	_mode = _this select 0;

	_display = findDisplay 22500;

	if(isNull _display) then {
		createDialog "A3PL_Bank_Account_Common_Dialog";
	};

	disableSerialization;

	/*
	0 - Common Account avec rectangle droit en mode virement vers comptes épargne
	1 - Common Account avec rectangle droit en mode virement vers une personne morale
	2 - Common Account avec rectangle droit en mode virement vers une personne physique
	*/

	// Récupération de l'affichage du common en ses 4 déclinaisons: classique, classique sans compte épargne, 
	// virement vers personne physique et virement vers personne morale
	_display = findDisplay 22500;
	_Common = _display displayCtrl 2201;
	_CommonNoSpare = _display displayCtrl 2202;
	_CommonToPhysical = _display displayCtrl 2203;
	_CommonToMoral = _display displayCtrl 2204;

	// Par défaut, les comptes sont cachés
	_Common ctrlShow false;
	_CommonNoSpare ctrlShow false;
	_CommonToPhysical ctrlShow false;
	_CommonToMoral ctrlShow false;

	// Récupération et affichage du prénom du joueur
	_name = _display displayCtrl 2205;
	_pname = (player getVariable ["name","unknown"]) splitString " ";
	_name ctrlSetStructuredText parseText format["%1",_pname#0];

	// Récupération et affichage du numéro de compte du joueur
	_accnum = _display displayCtrl 2206;
	_pacc = [player getVariable "Player_NumAcc"] call CBA_fnc_formatNumber;
	_accnum ctrlSetStructuredText parseText format["%1",_pacc];

	// Initialisation du bouton "retour arrière"
	_back = _display displayCtrl 2211;
	_back buttonSetAction "closeDialog 0;";

	// Initialisation du bouton "déconnexion", présent dans tous les Dialogs de la banque
	_disconnect = _display displayCtrl 2218;
	_disconnect buttonSetAction "(findDisplay 22500) closeDisplay 0;(findDisplay 21500) closeDisplay 0;";

	// Récupération de l'affichage du compte commun, du liquide et de la créance
	_commonAmount = _display displayCtrl 2207;
	_debts = _display displayCtrl 22071;
	_cash = _display displayCtrl 2208;

	// Récupération du statut du Savings Account (pour l'affichage ou non de la déclinaison "Classique sans compte épargne),
	// du solde du compte commun, du liquide, et de la créance du joueur
	_pBank = player getVariable ["Player_Bank",0];
	_pCash = player getVariable ["Player_Cash",0];
	_pDebts = player getVariable ["Player_Debt",0];
	_SavingsActive = player getVariable ["Player_SavingsAccountActive",false];

	// Détermination de la couleur du solde du Compte chèque
	_commonamountcolor = [0,0,0,1];
	switch (true) do {
		case (_pBank >= 15000): {_commonamountcolor = [0.106,0.592,0.071,1.0]};
		case ((-1 < _pBank) && (_pBank < 15000)): {_commonamountcolor = [0.741,0.431,0.000,1.0]};
		case (_pBank < 0): {_commonamountcolor = [0.745,0.016,0.016,1.0]};
	};

	// Détermination de la couleur de la créance
	_debtscolor = [0,0,0,1];
	switch (true) do {
		case (_pDebts > 0): {_debtscolor = [0.106,0.592,0.071,1.0]};
		case (_pDebts < 0): {_debtscolor = [0.745,0.016,0.016,1.0]};
	};

	// Détermination de la couleur du liquide
	_cashcolor = [0,0,0,1];
	switch (true) do {
		case (_pCash >= 15000): {_cashcolor = [0.106,0.592,0.071,1.0]};
		case ((-1 < _pCash) && (_pCash < 15000)): {_cashcolor = [0.741,0.431,0.000,1.0]};
	};

	// Détermination du texte de la créance: Dans l'ordre, créance positive, créance nulle, créance négative
	_debtsText = "";
	if (_pDebts > 0) then {_debtsText = format[("STR_A3PL_Bank_DebtPositive" call A3PL_Localize),_pDebts]};
	if (_pDebts == 0) then {_debtsText = ("STR_A3PL_Bank_NoDebt" call A3PL_Localize)};
	if (_pDebts < 0) then {_debtsText = format[("STR_A3PL_Bank_DebtNegative" call A3PL_Localize),abs _pDebts]};

	// Affichage du solde du Compte chèque, de la créance et du liquide
	_commonAmount ctrlSetText format["$%1",[_pBank] call BIS_fnc_numberText];
	_commonAmount ctrlSetTextColor _commonamountcolor;
	_debts ctrlSetText format["%1",_debtsText];
	_debts ctrlSetTextColor _debtscolor;
	_cash ctrlSetText format["$%1",[_pCash] call BIS_fnc_numberText];
	_cash ctrlSetTextColor _cashcolor;

	// Récupération et initialisation des boutons retirer et déposer
	_withdraw = _display displayCtrl 2212;
	_deposit = _display displayCtrl 2213;
	_withdraw buttonSetAction "[0] call A3PL_Bank_retirerCompteBancaire;";
	_deposit buttonSetAction "[0] call A3PL_Bank_deposerCompteBancaire;";

	// Récupération et initialisation des boutons "Transfert vers personne physique" et "Transfert vers personne morale"
	_tophysical = _display displayCtrl 2214;
	_tomoral = _display displayCtrl 2215;
	_tophysical buttonSetAction "[2] call A3PL_Bank_CommonPages;";
	_tomoral buttonSetAction "[1] call A3PL_Bank_CommonPages;";

	// Section contenant les boutons et RscEdit des déclinaisons "Transfers vers personnes morales et physiques", avec les boutons "Autres"
	_transfertoamount = _display displayCtrl 21201;
	_transfernumber = _display displayCtrl 212011;
	_moralname = _display displayCtrl 212012;
	_transfer = _display displayCtrl 21202;
	_transfertoperson = _display displayCtrl 21203;
	_transfertospare = _display displayCtrl 21204;
	_transfertospare buttonSetAction "[0] call A3PL_Bank_CommonPages";

	// Récupération et initialisation des boutons de transfert vers les comptes épargnes
	_tosavings = _display displayCtrl 2216;
	_tocod = _display displayCtrl 2217;
	_transferamount = _display displayCtrl 2210;
	_tosavings buttonSetAction "[0,22500,2210] call A3PL_Bank_transferCompteBancaire;";
	_tocod buttonSetAction "[1,22500,2210] call A3PL_Bank_transferCompteBancaire;";

	// Mode Compte chèque classique et classique sans compte épargne
	switch (_mode) do {
		case 0 : {
			// Affichage de la zone des transferts 
			_tophysical ctrlShow true;
			_tomoral ctrlShow true;
			
			// Désactivation des boutons et du RscEdit de la section transfert vers compte épargne,
			// ceux-ci étant affichés séparément dans le prochain if
			_transferamount ctrlShow false;
			_tosavings ctrlShow false;
			_tocod ctrlShow false;

			// Désactivation des boutons spécifiques des déclinaisons de transfert vers une personne physique et morale 
			_transfertoamount ctrlShow false;
			_transfernumber ctrlShow false;
			_moralname ctrlShow false;
			_transfer ctrlShow false;
			_transfertoperson ctrlShow false;
			_transfertospare ctrlShow false;

			// Si l'utilisateur possède un compte épargne 
			if (_SavingsActive) then {
				// Affichage de la section transfert vers compte épargne
				_Common ctrlShow true;
				_tosavings ctrlShow true;
				_tocod ctrlShow true;
				_transferamount ctrlShow true;
			} else {
				// Affichage de l'interface spécifique sans transferts vers compte épargne
				_CommonNoSpare ctrlShow true;
			};
		};
		// Mode transfert vers une personne morale
		case 1 : {
			// Affichage de l'interface spécifique pour les transferts vers une personne morale
			_CommonToMoral ctrlShow true;

			// Désactivation des boutons classiques de transfert 
			_tophysical ctrlShow false;
			_tomoral ctrlShow false;
			_transferamount ctrlShow false;
			_tosavings ctrlShow false;
			_tocod ctrlShow false;

			// Affichage de la section transferts vers une personne morale, sans le RscEdit des numéros de compte,
			// les comptes des personnes morales étant listés dans un RscCombo
			_transfertoamount ctrlShow true;
			_transfernumber ctrlShow false;
			_moralname ctrlShow true;
			_transfer ctrlShow true;
			_transfertoperson ctrlShow true;
			_transfertospare ctrlShow true;

			// Récupération de la liste des entreprises du serveur, et affichage dans le RscCombo
			{
				_index = _moralname lbAdd format[("STR_A3PL_Bank_Company" call A3PL_Localize), _x select 1];
				_moralname lbSetData [_index, str(_x select 0)];
			} foreach (Server_Companies);

			// Récupération de la liste des services publics du serveur, et affichage dans le RscCombo
			{
				_index = _moralname lbAdd format[("STR_A3PL_Bank_Service" call A3PL_Localize), toUpper (_x#0)];
			} foreach (Server_Government_FactionRanks);

			// Initialisation des boutons de transfert, et du bouton de transfert vers une personne physique
			_transfer buttonSetAction "[1] call A3PL_Bank_transferExtCompteBancaire";
			_transfertoperson buttonSetAction "[2] call A3PL_Bank_CommonPages";
		};
		// Mode transfert vers une personne physique
		case 2 : {
			// Affichage de l'interface spécifique pour les transferts vers une personne morale
			_CommonToPhysical ctrlShow true;

			// Désactivation des boutons classiques de transfert 
			_tophysical ctrlShow false;
			_tomoral ctrlShow false;
			_transferamount ctrlShow false;
			_tosavings ctrlShow false;
			_tocod ctrlShow false;

			// Affichage de la section transferts vers une personne physique, sans le RscCombo des personnes morales
			_transfertoamount ctrlShow true;
			_transfernumber ctrlShow true;
			_moralname ctrlShow false;
			_transfer ctrlShow true;
			_transfertoperson ctrlShow true;
			_transfertospare ctrlShow true;

			// Initialisation des boutons de transfert, et du bouton de transfert vers une personne morale
			_transfer buttonSetAction "[0] call A3PL_Bank_transferExtCompteBancaire";
			_transfertoperson buttonSetAction "[1] call A3PL_Bank_CommonPages";
		};
	};
}] call compile_Global;

["A3PL_Bank_SparePages", {
	private["_display"];
	_mode = _this select 0;

	_display = findDisplay 23500;

	if(isNull _display) then {
		createDialog "A3PL_Bank_Accounts_Spare_Dialog";
	};
	disableSerialization;

	/*
	0 - Savings Account
	1 - Certificate of Deposit
	*/

	// Récupération de l'affichage des comptes épargnes
	_display = findDisplay 23500;
	_SavingsBG = _display displayCtrl 3201;
	_CODBG = _display displayCtrl 3202;

	// Par défaut, les comptes sont cachés
	_SavingsBG ctrlShow false;
	_CODBG ctrlShow false;

	// Récupération de l'affichage du compte (réutilisé dans le switch), du Compte chèque et de la créance
	_accountamount = _display displayCtrl 3204;
	_commonAmount = _display displayCtrl 3205;
	_debts = _display displayCtrl 3206;

	// Récupération de l'affichage des intérêts du compte
	_interests = _display displayCtrl 3207;

	// Récupération de l'affichage de la zone de transfert vers un autre compte interne
	_transfertamount = _display displayCtrl 3208;
	_tocommon = _display displayCtrl 3210;
	_tospare = _display displayCtrl 3211;

	// Récupération et affichage du prénom du joueur
	_name = _display displayCtrl 3203;
	_pname = (player getVariable ["name","unknown"]) splitString " ";
	_name ctrlSetStructuredText parseText format["%1",_pname#0];

	// Initialisation du bouton "retour arrière"
	_back = _display displayCtrl 3209;
	_back buttonSetAction "closeDialog 0;";

	// Initialisation du bouton "déconnexion", présent dans tous les Dialogs de la banque
	_disconnect = _display displayCtrl 3212;
	_disconnect buttonSetAction "(findDisplay 23500) closeDisplay 0;(findDisplay 21500) closeDisplay 0;";

	// Récupération du solde du compte commun, de la créance du joueur, et des soldes des comptes épargne
	_pBank = player getVariable ["Player_Bank",0];
	_pDebts = player getVariable ["Player_Debt",0];
	_sBank = player getVariable ["Player_SavingsAccount",0];
	_CODbank = player getVariable ["Player_CertificateOfDeposit",0];

	// Détermination de la couleur du solde du Compte chèque
	_commonamountcolor = [0,0,0,1];
	switch (true) do {
		case (_pBank >= 15000): {_commonamountcolor = [0.106,0.592,0.071,1.0]};
		case ((-1 < _pBank) && (_pBank < 15000)): {_commonamountcolor = [0.741,0.431,0.000,1.0]};
		case (_pBank < 0): {_commonamountcolor = [0.745,0.016,0.016,1.0]};
	};

	// Détermination de la couleur du solde du Savings Account
	_savingsamountcolor = [0,0,0,1];
	switch (true) do {
		case (_Sbank >= 15000): {_savingsamountcolor = [0.106,0.592,0.071,1.0]};
		case ((-1 < _Sbank) && (_Sbank < 15000)): {_savingsamountcolor = [0.741,0.431,0.000,1.0]};
		case (_Sbank < 0): {_savingsamountcolor = [0.745,0.016,0.016,1.0]};
	};

	// Détermination de la couleur du solde du Certificate of Deposit
	_codamountcolor = [0,0,0,1];
	switch (true) do {
		case (_CODbank >= 15000): {_codamountcolor = [0.106,0.592,0.071,1.0]};
		case ((-1 < _CODbank) && (_CODbank < 15000)): {_codamountcolor = [0.741,0.431,0.000,1.0]};
		case (_CODbank < 0): {_codamountcolor = [0.745,0.016,0.016,1.0]};
	};

	// Détermination de la couleur de la créance
	_debtscolor = [0,0,0,1];
	switch (true) do {
		case (_pDebts > 0): {_debtscolor = [0.106,0.592,0.071,1.0]};
		case (_pDebts < 0): {_debtscolor = [0.745,0.016,0.016,1.0]};
	};

	// Détermination du texte de la créance: Dans l'ordre, créance positive, créance nulle, créance négative
	_debtsText = "";
	if (_pDebts > 0) then {_debtsText = format[("STR_A3PL_Bank_DebtPositive" call A3PL_Localize),_pDebts]};
	if (_pDebts == 0) then {_debtsText = ("STR_A3PL_Bank_NoDebt" call A3PL_Localize)};
	if (_pDebts < 0) then {_debtsText = format[("STR_A3PL_Bank_DebtNegative" call A3PL_Localize),abs _pDebts]};

	// Affichage du solde du Compte chèque et de la créance
	_commonAmount ctrlSetText format["$%1",[_pBank] call BIS_fnc_numberText];
	_commonAmount ctrlSetTextColor _commonamountcolor;
	_debts ctrlSetText format["%1",_debtsText];
	_debts ctrlSetTextColor _debtscolor;

	switch (_mode) do {
		// Savings Account
		case 0: {
			// Affichage du Savings Account uniquement
			_SavingsBG ctrlShow true;

			// Affichage du solde du Savings account
			_accountamount ctrlSetText format["$%1",[_Sbank] call BIS_fnc_numberText];
			_accountamount ctrlSetTextColor _savingsamountcolor;

			// Initialisation des boutons de transfert vers un autre compte interne, dans leur mode "Savings Account"
			_tocommon buttonSetAction "[2,23500,3208] call A3PL_Bank_transferCompteBancaire";
			_tospare buttonSetAction "[3,23500,3208] call A3PL_Bank_transferCompteBancaire";

			// Affichage des intérêts -> Valeur fixe pour l'instant
			_interests ctrlSetText format[("STR_A3PL_Bank_Interests1" call A3PL_Localize)];
		};
		// Certificate of Deposit
		case 1: {
			// Affichage du Certificate of Deposit uniquement
			_CODBG ctrlShow true;

			// Affichage du solde du Certificate of Deposit
			_accountamount ctrlSetText format["$%1",[_CODbank] call BIS_fnc_numberText];
			_accountamount ctrlSetTextColor _codamountcolor;

			// Initialisation des boutons de transfert vers un autre compte interne, dans leur mode "Certificate of Deposit"
			_tocommon buttonSetAction "[4,23500,3208] call A3PL_Bank_transferCompteBancaire";
			_tospare buttonSetAction "[5,23500,3208] call A3PL_Bank_transferCompteBancaire";

			// Affichage des intérêts -> Valeur fixe pour l'instant
			_interests ctrlSetText format[("STR_A3PL_Bank_Interests3" call A3PL_Localize)];
		};
	};
}] call compile_Global;

["A3PL_Bank_achatCompteBancaire", {
	private["_display","_mode"];
	_mode = _this select 0;
	_PCash = player getVariable ["Player_Cash",0];
	_pBank = player getVariable ["Player_Bank",0];
	_CommonActive = player getVariable ["Player_BankActive",0];

	/*
	0 - Acheter Common Account
	1 - Acheter Savings Account
	2 - Savings Certificate of Deposit
	*/

	switch (_mode) do {
		case 0 : {
			_price = Bank_CommonAccount_Price;
			private _action = [format[("STR_A3PL_Bank_BuyCommonAccount" call A3PL_Localize),_price]] call A3PL_Lib_ConfirmationDialog;
			if (!_action) exitWith {};
			if(_PCash < _price) exitWith {[format[("STR_A3PL_Bank_MissingCash" call A3PL_Localize),_price - _PCash],Color_Red] call A3PL_Notification;};
			player setVariable ["Player_Cash",_PCash-_price,true];
			player setVariable ["Player_BankActive",true,true];
			["bank_common"] call PO_Achievement_Learn;
			[0,player] remoteExecCall ["Server_Bank_BuyBankAccount",2];
			[format[("STR_A3PL_Bank_BuyCommonAccountOK" call A3PL_Localize),_price],Color_Green] call A3PL_Notification;
			[getPlayerUID player,(player getVariable ["character_id",""]),"Bank",["Common account opening"]] remoteExec ["Server_Log_New",2];
		};
		case 1 : {
			_price = Bank_SavingsAccount_Price;
			private _action = [format[("STR_A3PL_Bank_BuySavingsAccount" call A3PL_Localize),_price]] call A3PL_Lib_ConfirmationDialog;
			if (!_action) exitWith {};
			if (!_CommonActive) exitWith {[("STR_A3PL_Bank_NeedCommonAccount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			if(_pBank < _price) exitWith {[format[("STR_A3PL_Bank_MissingCash" call A3PL_Localize),_price - _pBank],Color_Red] call A3PL_Notification;};
			player setVariable ["Player_Bank",_pBank-_price,true];
			player setVariable ["Player_SavingsAccountActive",true,true];
			["bank_savings"] call PO_Achievement_Learn;
			[1,player] remoteExecCall ["Server_Bank_BuyBankAccount",2];
			[format[("STR_A3PL_Bank_BuySavingsAccountOK" call A3PL_Localize),_price],Color_Green] call A3PL_Notification;
			[getPlayerUID player,(player getVariable ["character_id",""]),"Bank",["Saving Account Opening"]] remoteExec ["Server_Log_New",2];
		};
		case 2 : {
			_price = Bank_CertificateOfDeposit_Price;
			private _action = [format[("STR_A3PL_Bank_BuyCODAccount" call A3PL_Localize),_price]] call A3PL_Lib_ConfirmationDialog;
			if (!_action) exitWith {};
			if (!_SavingsActive) exitWith {[("STR_A3PL_Bank_NeedSavingsAccount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			if(_pBank < _price) exitWith {[format[("STR_A3PL_Bank_MissingCash" call A3PL_Localize),_price - _pBank],Color_Red] call A3PL_Notification;};
			player setVariable ["Player_Bank",_pBank-_price,true];
			player setVariable ["Player_CertificateOfDepositActive",true,true];
			["bank_cod"] call PO_Achievement_Learn;
			[2,player] remoteExecCall ["Server_Bank_BuyBankAccount",2];
			[format[("STR_A3PL_Bank_BuyCODAccountOK" call A3PL_Localize),_price],Color_Green] call A3PL_Notification;
			[getPlayerUID player,(player getVariable ["character_id",""]),"Bank",["Certificate of Deposit Opening"]] remoteExec ["Server_Log_New",2];
		};
	};
}] call compile_Global;

["A3PL_Bank_afterTransferCompteBancaire", {
	private["_numacc","_number","_pBank"];
	_numacc = _this select 0;
	_number = _this select 1;
	_pBank = player getVariable ["Player_Bank",0];
	player setVariable ["Player_Bank",_pBank-_number,true];
	[format[("STR_A3PL_Bank_Transfer" call A3PL_Localize),_number,_numacc],Color_Green] call A3PL_Notification;
	[0] spawn A3PL_Bank_updateCompteBancaire;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Bank",[format ["Transfer $%1 from COMMON ACCOUNT to account number %2. Common account now at $%3",_number,_numacc,_pBank]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

["A3PL_Bank_badTransferCompteBancaire", {
	private["_raison"];
	_raison = _this select 0;
	switch (_raison) do {
		case 0 : {
			[("STR_A3PL_Bank_AccountDoesntExist" call A3PL_Localize),Color_Red] call A3PL_Notification;
		};
		case 1 : {
			[("STR_A3PL_Bank_CantTransfer" call A3PL_Localize),Color_Red] call A3PL_Notification;
		};
	};
}] call compile_Global;

["A3PL_Bank_cbParametre", {
	private["_activeCB"];
	_ActiveCB = player getVariable ["Player_ActiveCB",0];
	if (_ActiveCB isEqualTo 0) then {
		private _action = [("STR_A3PL_Bank_LinkCB" call A3PL_Localize)] call A3PL_Lib_ConfirmationDialog;
		if (!_action) exitWith {};
		player setVariable ["Player_ActiveCB",1,true];
		[("STR_A3PL_Bank_LinkCBOK" call A3PL_Localize),Color_Green] call A3PL_Notification;
		[player,1] remoteExecCall ["Server_Bank_cbParametre",2];
		[3] spawn A3PL_Bank_updateCompteBancaire;
	};
	if (_ActiveCB isEqualTo 1) then {
		private _action = [("STR_A3PL_Bank_LinkCB" call A3PL_Localize)] call A3PL_Lib_ConfirmationDialog;
		if (!_action) exitWith {};
		player setVariable ["Player_ActiveCB",0,true];
		[("STR_A3PL_Bank_UnlinkCBOK" call A3PL_Localize),Color_Green] call A3PL_Notification;
		[player,0] remoteExecCall ["Server_Bank_cbParametre",2];
		[3] spawn A3PL_Bank_updateCompteBancaire;
	};	
}] call compile_Global;

["A3PL_Bank_deposerCompteBancaire", {
	private _mode = _this select 0;
	private _display = objNull;

	if(!([] call A3PL_Player_AntiSpam)) exitWith {};

	disableSerialization;

	switch (_mode) do {
		case 0 : {
			_display = findDisplay 22500;
			_number = parseNumber(ctrlText 2209);

			_pCash = player getVariable ["Player_Cash",0];
			_pBank = player getVariable ["Player_Bank",0];

			if(!([str(_number)] call A3PL_Lib_isNumber)) exitWith {[("STR_A3PL_Bank_NotConform" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			if (_pCash < _number) exitWith {[("STR_A3PL_Bank_NotEnoughMoneyOnYou" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			if(_number < 0) exitWith {[("STR_A3PL_Bank_NegativeNumber" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			if(_number isEqualTo 0) exitWith {};
			if(_number > 999999) exitWith {[("STR_A3PL_Bank_TooMuchMoney" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			player setvariable ["Player_Bank",_pBank+_number,true];
			player setvariable ["Player_Cash",_pCash-_number,true];
			[format[("STR_A3PL_Bank_DepositCommonAccount" call A3PL_Localize),_number],Color_Green] call A3PL_Notification;
			[getPlayerUID player,(player getVariable ["character_id",""]),"Bank",[format ["Deposit $%1 on Common account. Common account now at %2. Cash now at $%3",_number,_pBank,_PCash]]] remoteExec ["Server_Log_New",2];
			[0] spawn A3PL_Bank_updateCompteBancaire;
		};
		case 1 : {
			_display = findDisplay 253;
			_number = parseNumber(ctrlText 5372);

			_pCash = player getVariable ["Player_Cash",0];
			_pBank = player getVariable ["Player_Bank",0];

			private _lastTime = player getVariable ["ATMDeposit_Timer",serverTime-Bank_ATM_Deposit_Timer];
			if(_lastTime > (serverTime-Bank_ATM_Deposit_Timer)) exitWith {[("STR_A3PL_Bank_AlreadyDeposited" call A3PL_Localize),Color_Red] call A3PL_Notification;};

			if(!([str(_number)] call A3PL_Lib_isNumber)) exitWith {[("STR_A3PL_Bank_NotConform" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			if (_pCash < _number) exitWith {[("STR_A3PL_Bank_NotEnoughMoneyOnYou" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			if(_number < 0) exitWith {[("STR_A3PL_Bank_NegativeNumber" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			if(_number isEqualTo 0) exitWith {};
			if(_number > Bank_ATM_Max_Deposit) exitWith {[format[("STR_A3PL_Bank_TooMuchMoneyATM" call A3PL_Localize),Bank_ATM_Max_Deposit],Color_Red] call A3PL_Notification;};
			player setvariable ["Player_Bank",_pBank+_number,true];
			player setvariable ["Player_Cash",_pCash-_number,true];
			[format[("STR_A3PL_Bank_DepositCommonAccount" call A3PL_Localize),_number],Color_Green] call A3PL_Notification;
			[getPlayerUID player,(player getVariable ["character_id",""]),"Bank",[format ["Deposit $%1 on Common account. Common account now at %2. Cash now at $%3",_number,_pBank,_PCash]]] remoteExec ["Server_Log_New",2];
			[0] spawn A3PL_Bank_updateCompteBancaire;
		};
	};
}] call compile_Global;

["A3PL_Bank_infoTransferCompteBancaire", {
	private["_number","_ciblenumberacc"];
	_number = _this select 0;
	_ciblenumberacc = _this select 1;
	_pBank = player getVariable ["Player_Bank",0];
	player setvariable ["Player_Bank",_pBank+_number,true];
	if !(isNull (findDisplay 22500)) then {[0] spawn A3PL_Bank_updateCompteBancaire; };
	if !(isNull (findDisplay 253)) then {[4] spawn A3PL_Bank_updateCompteBancaire;};
	_number = [_number] call A3PL_Lib_NumberText;
	[format[("STR_A3PL_Bank_TransferFrom" call A3PL_Localize),_number,_ciblenumberacc],Color_Red] call A3PL_Notification;
	[getPlayerUID player,(player getVariable ["character_id",""]),"Bank",[format ["Received $%1 from %2 on Common account",_number,_ciblenumberacc]]] remoteExec ["Server_Log_New",2];
}] call compile_Global;

["A3PL_Bank_retirerCompteBancaire", {
	private _mode = _this select 0;
	private _display = objNull;

	if(!([] call A3PL_Player_AntiSpam)) exitWith {};

	disableSerialization;

	switch (_mode) do {
		case 0 : {
			_display = findDisplay 22500;
			_number = parseNumber(ctrlText 2209);

			_pCash = player getVariable ["Player_Cash",0];
			_pBank = player getVariable ["Player_Bank",0];

			if(!([str(_number)] call A3PL_Lib_isNumber)) exitWith {[("STR_A3PL_Bank_NotConform" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			if (_pBank < _number) exitWith {[("STR_A3PL_Bank_NoMoney" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			if(_number < 0) exitWith {[("STR_A3PL_Bank_NegativeNumber" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			if(_number isEqualTo 0) exitWith {};
			if(_number > 999999) exitWith {[("STR_A3PL_Bank_TooMuchMoney" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			player setvariable ["Player_Bank",_pBank-_number,true];
			player setvariable ["Player_Cash",_PCash+_number,true];
			[format[("STR_A3PL_Bank_Withdraw" call A3PL_Localize),_number],Color_Green] call A3PL_Notification;
			[getPlayerUID player,(player getVariable ["character_id",""]),"Bank",[format ["Withdraw $%1 from Common account. Common account now at %2. Cash now at $%3",_number,_pBank,_PCash]]] remoteExec ["Server_Log_New",2];
			[0] spawn A3PL_Bank_updateCompteBancaire;
		};

		case 1 : {
			_display = findDisplay 253;
			_number = parseNumber(ctrlText 5372);

			_pCash = player getVariable ["Player_Cash",0];
			_pBank = player getVariable ["Player_Bank",0];

			if(!([str(_number)] call A3PL_Lib_isNumber)) exitWith {[("STR_A3PL_Bank_NotConform" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			if (_pBank < _number) exitWith {[("STR_A3PL_Bank_NoMoney" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			if(_number < 0) exitWith {[("STR_A3PL_Bank_NegativeNumber" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			if(_number isEqualTo 0) exitWith {};
			if(_number > 50000) exitWith {[("STR_A3PL_Bank_TooMuchMoneyATMWithdraw" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			player setvariable ["Player_Bank",_pBank-_number,true];
			player setvariable ["Player_Cash",_PCash+_number,true];
			[format[("STR_A3PL_Bank_Withdraw" call A3PL_Localize),_number],Color_Green] call A3PL_Notification;
			[getPlayerUID player,(player getVariable ["character_id",""]),"Bank",[format ["Withdraw $%1 from Common account (ATM). Common account now at %2. Cash now at $%3",_number,_pBank,_PCash]]] remoteExec ["Server_Log_New",2];
			[4] spawn A3PL_Bank_updateCompteBancaire;
		};
	};
}] call compile_Global;

["A3PL_Bank_transferCompteBancaire", {
	params["_mode","_display","_number"];

	disableSerialization;
	/*
	0 - Compte chèque vers Savings Account
	1 - Compte chèque vers Certificate of Deposit
	2 - Savings Account vers Compte chèque
	3 - Savings Account vers Certificate of Deposit
	4 - Certificate of Deposit vers Compte chèque
	5 - Certificate of Deposit vers Savings Account
	*/

	_mode = _this select 0;
	_display = findDisplay _display;
	_number = parseNumber(ctrlText _number);

	if(!([] call A3PL_Player_AntiSpam)) exitWith {};

	_pBank = player getVariable ["Player_Bank",0];
	_sBank = player getVariable ["Player_SavingsAccount",0];
	_SavingsAccount = player getVariable ["Player_SavingsAccountActive",0];
	_codBank = player getVariable ["Player_CertificateOfDeposit",0];
	_codAccount = player getVariable ["Player_CertificateOfDepositActive",0];

	if(!([str(_number)] call A3PL_Lib_isNumber)) exitWith {[("STR_A3PL_Bank_NotConform" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if(_number < 0) exitWith {[("STR_A3PL_Bank_NegativeNumber" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if(_number > 999999) exitWith {[("STR_A3PL_Bank_TooMuchMoney" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	switch (_mode) do {
		case 0 : {
			if (!_SavingsAccount) exitWith {[("STR_A3PL_Bank_NoSavingsAccount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			if (_pBank < _number) exitWith {[("STR_A3PL_Bank_NotEnoughMoneyOnCommonAccount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			if ((_sBank + _number) > Bank_SavingsAccount_Limit) exitWith {[format[("STR_A3PL_Bank_TooMuchMoneyOnSavingsAccount" call A3PL_Localize),Bank_SavingsAccount_Limit],Color_Red] call A3PL_Notification;};
			player setVariable ["Player_Bank",_pBank-_number,true];
			player setVariable ["Player_SavingsAccount",_sBank+_number,true];
			[format[("STR_A3PL_Bank_TransferToSavings" call A3PL_Localize),_number],Color_Green] call A3PL_Notification;
			[getPlayerUID player,(player getVariable ["character_id",""]),"Bank",[format ["Transfer $%1 from Common account to Savings Account. Common account now at %2. Savings Account now at $%3",_number,_pBank,_sBank]]] remoteExec ["Server_Log_New",2];
			[0] spawn A3PL_Bank_updateCompteBancaire;
		};
		case 1 : {
			if (!_codAccount) exitWith {[("STR_A3PL_Bank_NoCODAccount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			if (_pBank < _number) exitWith {[("STR_A3PL_Bank_NotEnoughMoneyOnCommonAccount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			if ((_codBank + _number) > Bank_CertificateOfDeposit_Limit) exitWith {[format[("STR_A3PL_Bank_TooMuchMoneyOnCODAccount" call A3PL_Localize),Bank_CertificateOfDeposit_Limit],Color_Red] call A3PL_Notification;};
			player setVariable ["Player_Bank",_pBank-_number,true];
			player setVariable ["Player_CertificateOfDeposit",_codBank+_number,true];
			[format[("STR_A3PL_Bank_TransferToCOD" call A3PL_Localize),_number],Color_Green] call A3PL_Notification;
			[getPlayerUID player,(player getVariable ["character_id",""]),"Bank",[format ["Transfer $%1 from Common account to Certificate of Deposit. Common account now at %2. Certificate of Deposit now at $%3",_number,_pBank,_codBank]]] remoteExec ["Server_Log_New",2];
			[0] spawn A3PL_Bank_updateCompteBancaire;
		};
		case 2 : {
			if (_sBank < _number) exitWith {[("STR_A3PL_Bank_NotEnoughMoneyOnSavingsAccount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			player setVariable ["Player_SavingsAccount",_sBank-_number,true];
			player setVariable ["Player_Bank",_pBank+_number,true];
			[format[("STR_A3PL_Bank_TransferToCommon" call A3PL_Localize),_number],Color_Green] call A3PL_Notification;
			[getPlayerUID player,(player getVariable ["character_id",""]),"Bank",[format ["Transfer $%1 from Savings Account to Common account. Savings Account now at %2. Common account now at $%3",_number,_sBank,_pBank]]] remoteExec ["Server_Log_New",2];
			[1] spawn A3PL_Bank_updateCompteBancaire;
		};
		case 3 : {
			if (!_codAccount) exitWith {[("STR_A3PL_Bank_NoCODAccount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			if (_sBank < _number) exitWith {[("STR_A3PL_Bank_NotEnoughMoneyOnSavingsAccount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			if ((_codBank + _number) > Bank_CertificateOfDeposit_Limit) exitWith {[format[("STR_A3PL_Bank_TooMuchMoneyOnCODAccount" call A3PL_Localize),Bank_CertificateOfDeposit_Limit],Color_Red] call A3PL_Notification;};
			player setVariable ["Player_SavingsAccount",_sBank-_number,true];
			player setVariable ["Player_CertificateOfDeposit",_codBank+_number,true];
			[format[("STR_A3PL_Bank_TransferToCODfromSavings" call A3PL_Localize),_number],Color_Green] call A3PL_Notification;
			[getPlayerUID player,(player getVariable ["character_id",""]),"Bank",[format ["Transfer $%1 from Savings Account to Certificate of Deposit. Savings Account now at %2. Certificate of Deposit now at $%3",_number,_sBank,_codBank]]] remoteExec ["Server_Log_New",2];
			[1] spawn A3PL_Bank_updateCompteBancaire;
		};
		case 4 : {
			if (_codBank < _number) exitWith {[("STR_A3PL_Bank_NotEnoughMoneyOnCODAccount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			player setVariable ["Player_CertificateOfDeposit",_codBank-_number,true];
			player setVariable ["Player_Bank",_pBank+_number,true];
			[format[("STR_A3PL_Bank_TransferToCommonfromCOD" call A3PL_Localize),_number],Color_Green] call A3PL_Notification;
			[getPlayerUID player,(player getVariable ["character_id",""]),"Bank",[format ["Transfer $%1 from Certificate of Deposit to Common account. Certificate of Deposit now at %2. Common account now at $%3",_number,_codBank,_pBank]]] remoteExec ["Server_Log_New",2];
			[2] spawn A3PL_Bank_updateCompteBancaire;
		};
		case 5 : {
			if (_codBank < _number) exitWith {[("STR_A3PL_Bank_NotEnoughMoneyOnCODAccount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			if ((_sBank + _number) > Bank_SavingsAccount_Limit) exitWith {[format[("STR_A3PL_Bank_TooMuchMoneyOnSavingsAccount" call A3PL_Localize),Bank_SavingsAccount_Limit],Color_Red] call A3PL_Notification;};
			player setVariable ["Player_CertificateOfDeposit",_codBank-_number,true];
			player setVariable ["Player_SavingsAccount",_sBank+_number,true];
			[format[("STR_A3PL_Bank_TransferToSavingsfromCOD" call A3PL_Localize),_number],Color_Green] call A3PL_Notification;
			[getPlayerUID player,(player getVariable ["character_id",""]),"Bank",[format ["Transfer $%1 from Certificate of Deposit to Savings Account. Certificate of Deposit now at %2. Savings Account now at $%3",_number,_codBank,_sBank]]] remoteExec ["Server_Log_New",2];
			[2] spawn A3PL_Bank_updateCompteBancaire;
		};
	};
}] call compile_Global;

["A3PL_Bank_transferExtCompteBancaire", {
	private _mode = _this select 0;
	if(!([] call A3PL_Player_AntiSpam)) exitWith {};

	disableSerialization;

	_display = findDisplay 22500;
	_amount = parseNumber(ctrlText 21201);
	_pBank = player getVariable ["Player_Bank",0];

	switch (_mode) do {
		case 0: {
			_numacc = ctrlText 212011;

			if(!([str(_amount)] call A3PL_Lib_isNumber)) exitWith {[("STR_A3PL_Bank_NotConform" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			if !([_numacc] call A3PL_Lib_isNumber) exitWith {[("STR_A3PL_Bank_InvalidAccountNumber" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			if(_amount < 0) exitWith {[("STR_A3PL_Bank_NegativeNumber" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			if(_amount > 999999) exitWith {[("STR_A3PL_Bank_TooMuchMoney" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			if (_pBank < _amount) exitWith {[("STR_A3PL_Bank_NotEnoughMoneyOnCommonAccount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
			
			[_numacc,player,_amount] remoteExecCall ["Server_Bank_transferExtCompteBancaire",2];
		};

		case 1: {
			_moralname = _display displayCtrl 212012;
			_accountnum = _display displayCtrl 2206;
			_accountnum = ctrlText _accountnum;

			private _companyTransfer = [("STR_Common_Company" call A3PL_Localize), _moralname lbText (lbCurSel _moralname)] call BIS_fnc_inString;
			private _factionTransfer = ("STR_Common_Faction" call A3PL_Localize) IN (_moralname lbText (lbCurSel _moralname));
			private _notf = "";

			if (_pBank < _amount) exitWith {[("STR_A3PL_Bank_NotEnoughMoneyOnCommonAccount" call A3PL_Localize),Color_Red] call A3PL_Notification;};

			if (_factionTransfer) then {
				private _mName = ((_moralname lbText (lbCurSel _moralname)) splitString " ")#1;
				private _faction = toLower _mName;
				switch (_faction) do {
					case ("STR_Common_FIFR" call A3PL_Localize): {_mName = ("STR_Common_FireDepartment" call A3PL_Localize)};
					case ("STR_Common_FISD" call A3PL_Localize): {_mName = ("STR_Common_SheriffsDepartment" call A3PL_Localize)};
					case ("STR_Common_DOJ" call A3PL_Localize): {_mName = ("STR_Common_DepartmentOfJustice" call A3PL_Localize)};
					case ("STR_Common_GOV" call A3PL_Localize): {_mName = ("STR_Common_Government" call A3PL_Localize)};
					default {_mName = ("STR_Common_FederalReserve" call A3PL_Localize)};
				};
				[_mName,_amount] remoteExec ["Server_Government_AddBalance",2];
				_notf = format[("STR_A3PL_Bank_TransferToFaction" call A3PL_Localize), [_amount] call CBA_fnc_formatNumber,_mName];
				[getPlayerUID player,(player getVariable ["character_id",""]),"Bank_TransferFaction",[format ["Sent to %1 | Amount: %2 | PrevBalance: %4 | NewBalance: %3",_mName,_amount,_pBank,str(_pBank - _amount)]]] remoteExec ["Server_Log_New",2];
				private _factionMembers = [_faction] call A3PL_Lib_FactionPlayers;
				if (count _factionMembers > 0) then {
					[format[("STR_A3PL_Bank_TransferToFactionReceive" call A3PL_Localize),_amount,_accountnum], Color_green] remoteExec ["A3PL_Notification",_factionMembers];
				};
			} else {
				private _cid = parseNumber(_moralname lbData (lbCurSel _moralname));
				private _mName = [_cid, "name"] call A3PL_Config_GetCompanyData;
				[_cid, _amount, format[("STR_A3PL_Bank_TransferToCompanyReceive" call A3PL_Localize),_accountnum]] remoteExec ["Server_Company_SetBank",2];
				_notf = format[("STR_A3PL_Bank_TransferToCompany" call A3PL_Localize), [_amount] call CBA_fnc_formatNumber,_mName];
				[getPlayerUID player,(player getVariable ["character_id",""]),"ATM_TransferCompany",[format ["Sent to ID: %1 | Sent To Name: %2 | Amount: %3 | PrevBalance: %5 | NewBalance: %4",_cid,_mName,_amount,_pBank,str(_pBank - _amount)]]] remoteExec ["Server_Log_New",2];
			};
			[format["%1",_notf],Color_Green] call A3PL_Notification;
			[player, 'Player_Bank', ((player getVariable 'Player_Bank') - _amount)] remoteExec ["Server_Core_ChangeVar",2];
			[0] spawn A3PL_Bank_updateCompteBancaire;
		};
	};
}] call compile_Global;

["A3PL_Bank_updateCompteBancaire", {
	private["_display"];
	_mode = _this select 0;

	disableSerialization;
	/*
	0 - Update Common + Accueil
	1 - Update Savings + Accueil
	2 - Update COD + Accueil
	3 - Update Accueil
	4 - Update DAB
	*/

	_CommonActive = player getVariable ["Player_BankActive",false];
	_pCash = player getVariable ["Player_Cash",0];
	_pBank = player getVariable ["Player_Bank",0];
	_pDebts = player getVariable ["Player_Debt",0];
	_SavingsActive = player getVariable ["Player_SavingsAccountActive",false];
	_SBank = player getVariable ["Player_SavingsAccount",0];
	_CODActive = player getVariable ["Player_CertificateOfDepositActive",false];
	_codBank = player getVariable ["Player_CertificateOfDeposit",0];
	_LimitCB = player getVariable ["Player_LimitCB",0];
	_ActiveCB = player getVariable ["Player_ActiveCB",0];

	switch (_mode) do {
		case 0 : {
			// Partie 1: Update Common
			_display = findDisplay 22500;

			_commonamount = _display displayCtrl 2207;
			_debts = _display displayCtrl 22071;
			_cash = _display displayCtrl 2208;

			_commonamountcolor = [0,0,0,1];
			switch (true) do {
				case (_pBank >= 15000): {_commonamountcolor = [0.106,0.592,0.071,1.0]};
				case ((-1 < _pBank) && (_pBank < 15000)): {_commonamountcolor = [0.741,0.431,0.000,1.0]};
				case (_pBank < 0): {_commonamountcolor = [0.745,0.016,0.016,1.0]};
			};

			_debtscolor = [0,0,0,1];
			switch (true) do {
				case (_pDebts > 0): {_debtscolor = [0.106,0.592,0.071,1.0]};
				case (_pDebts < 0): {_debtscolor = [0.745,0.016,0.016,1.0]};
			};

			_cashcolor = [0,0,0,1];
			switch (true) do {
				case (_pCash >= 15000): {_cashcolor = [0.106,0.592,0.071,1.0]};
				case ((-1 < _pCash) && (_pCash < 15000)): {_cashcolor = [0.741,0.431,0.000,1.0]};
			};

			_debtsText = "";
			if (_pDebts > 0) then {_debtsText = format[("STR_A3PL_Bank_DebtReceive" call A3PL_Localize),_pDebts]};
			if (_pDebts == 0) then {_debtsText = ("STR_A3PL_Bank_NoDebt" call A3PL_Localize)};
			if (_pDebts < 0) then {_debtsText = format[("STR_A3PL_Bank_DebtPay" call A3PL_Localize),abs _pDebts]};
			
			_commonAmount ctrlSetText format["$%1",[_pBank] call BIS_fnc_numberText];
			_commonAmount ctrlSetTextColor _commonamountcolor;
			_debts ctrlSetText format["%1",_debtsText];
			_debts ctrlSetTextColor _debtscolor;
			_cash ctrlSetText format["$%1",[_pCash] call BIS_fnc_numberText];
			_cash ctrlSetTextColor _cashcolor;

			// Partie 2: Update Accueil
			[3] spawn A3PL_Bank_updateCompteBancaire;
		};
		case 1 : {
			// Partie 1: Update Savings
			_display = findDisplay 23500;

			_accountamount = _display displayCtrl 3204;
			_commonAmount = _display displayCtrl 3205;
			_debts = _display displayCtrl 3206;

			_commonamountcolor = [0,0,0,1];
			switch (true) do {
				case (_pBank >= 15000): {_commonamountcolor = [0.106,0.592,0.071,1.0]};
				case ((-1 < _pBank) && (_pBank < 15000)): {_commonamountcolor = [0.741,0.431,0.000,1.0]};
				case (_pBank < 0): {_commonamountcolor = [0.745,0.016,0.016,1.0]};
			};

			_savingsamountcolor = [0,0,0,1];
			switch (true) do {
				case (_Sbank >= 15000): {_savingsamountcolor = [0.106,0.592,0.071,1.0]};
				case ((-1 < _Sbank) && (_Sbank < 15000)): {_savingsamountcolor = [0.741,0.431,0.000,1.0]};
				case (_Sbank < 0): {_savingsamountcolor = [0.745,0.016,0.016,1.0]};
			};

			_debtscolor = [0,0,0,1];
			switch (true) do {
				case (_pDebts > 0): {_debtscolor = [0.106,0.592,0.071,1.0]};
				case (_pDebts < 0): {_debtscolor = [0.745,0.016,0.016,1.0]};
			};

			_debtsText = "";
			if (_pDebts > 0) then {_debtsText = format[("STR_A3PL_Bank_DebtReceive" call A3PL_Localize),_pDebts]};
			if (_pDebts == 0) then {_debtsText = ("STR_A3PL_Bank_NoDebt" call A3PL_Localize)};
			if (_pDebts < 0) then {_debtsText = format[("STR_A3PL_Bank_DebtPay" call A3PL_Localize),abs _pDebts]};

			_commonAmount ctrlSetText format["$%1",[_pBank] call BIS_fnc_numberText];
			_commonAmount ctrlSetTextColor _commonamountcolor;
			_debts ctrlSetText format["%1",_debtsText];
			_debts ctrlSetTextColor _debtscolor;

			_accountamount ctrlSetText format["$%1",[_Sbank] call BIS_fnc_numberText];
			_accountamount ctrlSetTextColor _savingsamountcolor;

			// Partie 2: Update Accueil
			[3] spawn A3PL_Bank_updateCompteBancaire;
		};
		case 2 : {
			// Partie 1: Update COD
			_display = findDisplay 23500;

			_accountamount = _display displayCtrl 3204;
			_commonAmount = _display displayCtrl 3205;
			_debts = _display displayCtrl 3206;

			_commonamountcolor = [0,0,0,1];
			switch (true) do {
				case (_pBank >= 15000): {_commonamountcolor = [0.106,0.592,0.071,1.0]};
				case ((-1 < _pBank) && (_pBank < 15000)): {_commonamountcolor = [0.741,0.431,0.000,1.0]};
				case (_pBank < 0): {_commonamountcolor = [0.745,0.016,0.016,1.0]};
			};

			_codamountcolor = [0,0,0,1];
			switch (true) do {
				case (_CODbank >= 15000): {_codamountcolor = [0.106,0.592,0.071,1.0]};
				case ((-1 < _CODbank) && (_CODbank < 15000)): {_codamountcolor = [0.741,0.431,0.000,1.0]};
				case (_CODbank < 0): {_codamountcolor = [0.745,0.016,0.016,1.0]};
			};

			_debtscolor = [0,0,0,1];
			switch (true) do {
				case (_pDebts > 0): {_debtscolor = [0.106,0.592,0.071,1.0]};
				case (_pDebts < 0): {_debtscolor = [0.745,0.016,0.016,1.0]};
			};

			_debtsText = "";
			if (_pDebts > 0) then {_debtsText = format[("STR_A3PL_Bank_DebtReceive" call A3PL_Localize),_pDebts]};
			if (_pDebts == 0) then {_debtsText = ("STR_A3PL_Bank_NoDebt" call A3PL_Localize)};
			if (_pDebts < 0) then {_debtsText = format[("STR_A3PL_Bank_DebtPay" call A3PL_Localize),abs _pDebts]};

			_commonAmount ctrlSetText format["$%1",[_pBank] call BIS_fnc_numberText];
			_commonAmount ctrlSetTextColor _commonamountcolor;
			_debts ctrlSetText format["%1",_debtsText];
			_debts ctrlSetTextColor _debtscolor;

			_accountamount ctrlSetText format["$%1",[_codBank] call BIS_fnc_numberText];
			_accountamount ctrlSetTextColor _codamountcolor;

			// Partie 2: Update Accueil
			[3] spawn A3PL_Bank_updateCompteBancaire;
		};
		case 3 : {
			// Update Accueil
			_display = findDisplay 21500;

			_NoAccountBG = _display displayCtrl 1201;
			_HasCommonAccountBG = _display displayCtrl 1202;
			_HasSavingsAccountBG = _display displayCtrl 1203;
			_HasCODAccountBG = _display displayCtrl 1204;

			_commonAmount = _display displayCtrl 1221;
			_debts = _display displayCtrl 12211;
			_savingsAmount = _display displayCtrl 1222;
			_codAmount = _display displayCtrl 1223;

			_NoAccountBG ctrlShow false;
			_HasCommonAccountBG ctrlShow false;
			_HasSavingsAccountBG ctrlShow false;
			_HasCODAccountBG ctrlShow false;

			_opencommon = _display displayCtrl 1227;
			_opensavings = _display displayCtrl 1228;
			_opencod = _display displayCtrl 1229;

			_linkunlink = _display displayCtrl 1226;

			_LimitText = "";
			if ("A3PL_CB_Platinum" in (magazines player)) then {
				_LimitText = format[("STR_A3PL_Bank_Illimited" call A3PL_Localize),[_LimitCB] call BIS_fnc_numberText];
			} else {
				if ("A3PL_CB_Gold" in (magazines player)) then {
					_LimitText = format[("STR_A3PL_Bank_LimitPerHour" call A3PL_Localize),[_LimitCB] call BIS_fnc_numberText,[Bank_AmericanExpressLimit_Gold] call BIS_fnc_numberText];
				} else {
					if ("A3PL_CB" in (magazines player)) then {
						_LimitText = format[("STR_A3PL_Bank_LimitPerHour" call A3PL_Localize),[_LimitCB] call BIS_fnc_numberText,[Bank_AmericanExpressLimit_Standard] call BIS_fnc_numberText];
					} else {
						_LimitText = ("STR_A3PL_Bank_NoCardFound" call A3PL_Localize);
					};
				};
			};

			_maxpayment = _display displayCtrl 1224;
			_linked = _display displayCtrl 1225;

			_commonamountcolor = [0,0,0,1];
			switch (true) do {
				case (_pBank >= 15000): {_commonamountcolor = [0.106,0.592,0.071,1.0]};
				case ((-1 < _pBank) && (_pBank < 15000)): {_commonamountcolor = [0.741,0.431,0.000,1.0]};
				case (_pBank < 0): {_commonamountcolor = [0.745,0.016,0.016,1.0]};
			};

			_savingsamountcolor = [0,0,0,1];
			switch (true) do {
				case (_Sbank >= 15000): {_savingsamountcolor = [0.106,0.592,0.071,1.0]};
				case ((-1 < _Sbank) && (_Sbank < 15000)): {_savingsamountcolor = [0.741,0.431,0.000,1.0]};
				case (_Sbank < 0): {_savingsamountcolor = [0.745,0.016,0.016,1.0]};
			};

			_codamountcolor = [0,0,0,1];
			switch (true) do {
				case (_CODbank >= 15000): {_codamountcolor = [0.106,0.592,0.071,1.0]};
				case ((-1 < _CODbank) && (_CODbank < 15000)): {_codamountcolor = [0.741,0.431,0.000,1.0]};
				case (_CODbank < 0): {_codamountcolor = [0.745,0.016,0.016,1.0]};
			};

			_debtscolor = [0,0,0,1];
			switch (true) do {
				case (_pDebts > 0): {_debtscolor = [0.106,0.592,0.071,1.0]};
				case (_pDebts < 0): {_debtscolor = [0.745,0.016,0.016,1.0]};
			};

			_debtsText = "";
			if (_pDebts > 0) then {_debtsText = format[("STR_A3PL_Bank_DebtReceive" call A3PL_Localize),_pDebts]};
			if (_pDebts == 0) then {_debtsText = ("STR_A3PL_Bank_NoDebt" call A3PL_Localize)};
			if (_pDebts < 0) then {_debtsText = format[("STR_A3PL_Bank_DebtPay" call A3PL_Localize),abs _pDebts]};

			
			if (!_CommonActive) then {
				_NoAccountBG ctrlShow true;
				_linkunlink ctrlShow false;

				_opencommon buttonSetAction "[0] spawn A3PL_Bank_achatCompteBancaire";
				_opensavings buttonSetAction "['STR_A3PL_Bank_NoCommonAccount' call A3PL_Localize,Color_Red] call A3PL_Notification";
				_opencod buttonSetAction "['STR_A3PL_Bank_NoCommonAccount' call A3PL_Localize,Color_Red] call A3PL_Notification";
				
			};
			if (_CommonActive && !_SavingsActive) then {
				_HasCommonAccountBG ctrlShow true;
				_linkunlink ctrlShow true;

				_opencommon buttonSetAction "[0] spawn A3PL_Bank_CommonPages";
				_opensavings buttonSetAction "[1] spawn A3PL_Bank_achatCompteBancaire";
				_opencod buttonSetAction "['STR_A3PL_Bank_NoSavingsAccount' call A3PL_Localize,Color_Red] call A3PL_Notification";

				_commonAmount ctrlSetText format["$%1",[_pBank] call BIS_fnc_numberText];
				_commonAmount ctrlSetTextColor _commonamountcolor;
				_debts ctrlSetText format["%1",_debtsText];
				_debts ctrlSetTextColor _debtscolor;
				_maxpayment ctrlSetText format["%1",_LimitText];
				_linked ctrlSetText format["%1",if (_ActiveCB isEqualTo 1) then {("STR_Common_Yes" call A3PL_Localize)} else {("STR_Common_No" call A3PL_Localize)}];
				
			};
			if (_CommonActive && _SavingsActive && !_CODActive) then {
				_HasSavingsAccountBG ctrlShow true;
				_linkunlink ctrlShow true;

				_opencommon buttonSetAction "[0] spawn A3PL_Bank_CommonPages";
				_opensavings buttonSetAction "[0] spawn A3PL_Bank_SparePages";
				_opencod buttonSetAction "[2] spawn A3PL_Bank_achatCompteBancaire";

				_commonAmount ctrlSetText format["$%1",[_pBank] call BIS_fnc_numberText];
				_commonAmount ctrlSetTextColor _commonamountcolor;
				_debts ctrlSetText format["%1",_debtsText];
				_debts ctrlSetTextColor _debtscolor;
				_savingsAmount ctrlSetText format["$%1",[_Sbank] call BIS_fnc_numberText];
				_savingsAmount ctrlSetTextColor _savingsamountcolor;

				_maxpayment ctrlSetText format["%1",_LimitText];
				_linked ctrlSetText format["%1",if (_ActiveCB isEqualTo 1) then {("STR_Common_Yes" call A3PL_Localize)} else {("STR_Common_No" call A3PL_Localize)}];
			};
			if (_CommonActive && _SavingsActive && _CODActive) then {
				_HasCODAccountBG ctrlShow true;
				_linkunlink ctrlShow true;

				_opencommon buttonSetAction "[0] spawn A3PL_Bank_CommonPages";
				_opensavings buttonSetAction "[0] spawn A3PL_Bank_SparePages";
				_opencod buttonSetAction "[1] spawn A3PL_Bank_SparePages";

				_commonAmount ctrlSetText format["$%1",[_pBank] call BIS_fnc_numberText];
				_commonAmount ctrlSetTextColor _commonamountcolor;
				_debts ctrlSetText format["%1",_debtsText];
				_debts ctrlSetTextColor _debtscolor;
				_savingsAmount ctrlSetText format["$%1",[_Sbank] call BIS_fnc_numberText];
				_savingsAmount ctrlSetTextColor _savingsamountcolor;
				_codAmount ctrlSetText format["$%1",[_CODbank] call BIS_fnc_numberText];
				_codAmount ctrlSetTextColor _codamountcolor;

				_maxpayment ctrlSetText format["%1",_LimitText];
				_linked ctrlSetText format["%1",if (_ActiveCB isEqualTo 1) then {("STR_Common_Yes" call A3PL_Localize)} else {("STR_Common_No" call A3PL_Localize)}];

			};
		};
		case 4 : {
			_display = findDisplay 253;

			_money = _display displayCtrl 4974;
			_money ctrlSetStructuredText parseText format["%1",[_pBank] call BIS_fnc_numberText];
		};
	};
}] call compile_Global;

["A3PL_Bank_HowToPay", {
	params ["_price"];
	price = param [0,0];
	createDialog "A3PL_HowToPay_Dialog";
	disableSerialization;

	private _display = findDisplay 458762;
	private _text = _display displayCtrl 1400;
	private _buttonCB = _display displayCtrl 1600;
	private _bgCBPRO = _display displayCtrl 1201;
	private _buttonCBPro = _display displayCtrl 1601;
	private _buttonCASH = _display displayCtrl 1602;

	private _job = player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
	if (_job IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize),("STR_Common_Company" call A3PL_Localize)]) then {
		_bgCBPRO ctrlShow true;
		_buttonCBPro ctrlShow true;
	} else {
		_bgCBPRO ctrlShow false;
		_buttonCBPro ctrlShow false;
	};

	_text ctrlSetText format[("STR_A3PL_Bank_PaymentMethod" call A3PL_Localize),price];

	player setVariable["payment",objNull];
	player setVariable["paymentResult",objNull];

	_buttonCASH buttonSetAction "[0, price] call A3PL_Bank_HowToPayConfirm;";

    _buttonCB buttonSetAction "[1, price] call A3PL_Bank_HowToPayConfirm;";

    _buttonCBPro buttonSetAction "[2, price] call A3PL_Bank_HowToPayConfirm;";

	[_display,_price] spawn
	{
		private _display = param[0,displayNull];
		private _price = param[1,0];
		private _paymentResult = objNull;
		private _t = 0;
		while {!isNull _display} do
			{
				sleep 1;
				_t = _t + 1;
				if (isNull _display) exitwith {
					if ((player getVariable "payment") isEqualTo objNull) then {
						player setVariable["payment",false];
						[format[("STR_A3PL_Bank_CancelPayment" call A3PL_Localize),_price],Color_Red] call A3PL_Notification;
					};
				};
				if (_t > 19) exitwith {
					closeDialog 0;
					[format[("STR_A3PL_Bank_Timeout" call A3PL_Localize),_price],Color_Red] call A3PL_Notification;
					player setVariable["payment",false];
				};
			};
		player setVariable["paymentResult",(player getVariable "payment")];
	};
}] call compile_Global;

["A3PL_Bank_HowToPayConfirm", {
	params ["_selection", "_price"];
	private _paymentSuccess = false;
	switch (_selection) do {
		case 0: { 
			private _pCash = player getVariable ["Player_Cash", 0];
			if (_pCash >= _price) then {
				closeDialog 0;
				[format[("STR_A3PL_Bank_CashPayment" call A3PL_Localize),_price],Color_Green] call A3PL_Notification;
				player setVariable ["Player_Cash",_pCash - _price, true];
				_paymentSuccess = true;
			} else {
				[format[("STR_A3PL_Bank_NotEnoughCash" call A3PL_Localize),_price],Color_Red] call A3PL_Notification;
				_paymentSuccess = false;
			};
		};
		case 1: {
			_paymentSuccess = [_price] call A3PL_Bank_handleCB;
			if (_paymentSuccess) then {closeDialog 0;};
		};
		case 2: {
			private _pName = player getVariable["name","John Doe"];
			private _pJob = player getVariable ["job",("STR_Common_Job_Unemployed" call A3PL_Localize)];
			private _inCompany = [(player getVariable ["character_id",""])] call A3PL_Config_InCompany;
			
			if(_inCompany && {_pJob isEqualTo ("STR_Common_Company" call A3PL_Localize)}) then {
				private _charID = (player getVariable ["character_id",""]);
				private _cid = [_charID] call A3PL_Config_GetCompanyID;
				private _hasPermBank = [_cid,"bank",_charID] call A3FL_Config_GetCompanyPermissions;
				private _isBoss = ([_charID] call A3PL_Config_IsCompanyBoss);
				if(!(_hasPermBank) && !(_isBoss)) exitWith {
					[("STR_Common_BankAccessDenied" call A3PL_Localize),Color_Red] call A3PL_Notification;
					_paymentSuccess = false;
					player setVariable ["payment",_paymentSuccess];
				};
				private _companyBank = [_cid, "bank"] call A3PL_Config_GetCompanyData;
				if(_companyBank < _price) exitWith {
					[("STR_A3PL_Bank_CompanyNoMoney" call A3PL_Localize),Color_Red] call A3PL_Notification;
					_paymentSuccess = false;
					player setVariable ["payment",_paymentSuccess];
				};
				[_cid, -_price, ""] remoteExec ["Server_Company_SetBank",2];
				_paymentSuccess = true;
				closeDialog 0;
				[_cid, _price, format["%1 used his card for an amount of $%2",_pName,_price]] remoteExec ["Server_Company_AddLog",2];
			};

			if (_pJob IN [("STR_Common_FISD" call A3PL_Localize),("STR_Common_FIFR" call A3PL_Localize),("STR_Common_DOJ" call A3PL_Localize),("STR_Common_GOV" call A3PL_Localize)]) then {
				if (!([_pJob] call A3PL_Government_isFactionLeader)) exitwith {
					[("STR_A3PL_Bank_ProCardUsage" call A3PL_Localize), Color_Red] call A3PL_Notification;
					_paymentSuccess = false;
					player setVariable ["payment",_paymentSuccess];
				};
				private _factionBalance = [player] call A3PL_Government_MyFactionBalance;
				if(_factionBalance < _price) exitWith {
					[("STR_A3PL_Bank_FactionNoMoney" call A3PL_Localize),Color_Red] call A3PL_Notification;
					_paymentSuccess = false;
					player setVariable ["payment",_paymentSuccess];
				};
				[_factionBalance, -_price] remoteExec ["Server_Government_AddBalance",2];
				_paymentSuccess = true;
				closeDialog 0;
			};
		};
	};
	player setVariable ["payment",_paymentSuccess];
}] call compile_Global;

["A3PL_Bank_HasAccount", {
	params [
		["_targetplayer",objNull],
		["_mode",4]
	];
	private _return = false;

	switch (_mode) do {
		case 1: {
			private _LAactive = player getVariable ["Player_BankActive",0];
			if (_LAactive) exitWith {_return = true};
			_return = false;
		};
		case 2: {
			private _LBactive = player getVariable ["Player_SavingsAccountActive",0];
			if (_LBactive) exitWith {_return = true};
			_return = false;
		};
		case 3: {
			private _LCactive = player getVariable ["Player_CertificateOfDepositActive",0];
			if (_LCactive) exitWith {_return = true};
			_return = false;
		};
		case 4: {
			private _LAactive = player getVariable ["Player_BankActive",0];
			private _LBactive = player getVariable ["Player_SavingsAccountActive",0];
			private _LCactive = player getVariable ["Player_CertificateOfDepositActive",0];
			if (_LAactive || _LBactive || _LCactive) exitWith {_return = true};
			_return = false;
		};
	};
	_return;
}] call compile_Global;

["A3PL_Bank_CollectDebts",
{
    private _debt = player getVariable["Player_Debt",0];
	private _hasAccount = [player,1] call A3PL_Bank_hasAccount;
	if (_hasAccount) then {
		private _pABank = player getVariable["Player_Bank",0];
		player setVariable ["Player_Bank",_pABank+_debt];
		player setVariable ["Player_Debt",0,true];
	};
	if (!_hasAccount) then {
		if (_debt > 0) exitWith {[format[("STR_A3PL_Bank_DebtNoAccountPositive" call A3PL_Localize),_debt],Color_Red] call A3PL_Notification;};
		if (_debt < 0) exitWith {[format[("STR_A3PL_Bank_DebtNoAccountNegative" call A3PL_Localize),_debt],Color_Red] call A3PL_Notification;};
	};
}] call compile_Global;

["A3PL_Bank_AmericanExpressCosts",
{
	private _hasAccount = [player,1] call A3PL_Bank_hasAccount;
	private _pABank = player getVariable["Player_Bank",0];
	if (_hasAccount) then {
		if("A3PL_CB" in (magazines player)) then {
			_costsStandard = Bank_AmericanExpressCost_Standard;
			[format[("STR_A3PL_Bank_AmericanExpressStandardFee" call A3PL_Localize),_costsStandard], Color_green] call A3PL_Notification;
			player setVariable ["Player_Bank",_pABank-_costsStandard];
		};

		if("A3PL_CB_Gold" in (magazines player)) then {
			_costsGold = Bank_AmericanExpressCost_Gold;
			[format[("STR_A3PL_Bank_AmericanExpressGoldFee" call A3PL_Localize),_costsGold], Color_green] call A3PL_Notification;
			player setVariable ["Player_Bank",_pABank-_costsGold];
		};

		if("A3PL_CB_Platinum" in (magazines player)) then {
			_costsPlatinum = Bank_AmericanExpressCost_Platinum;
			[format[("STR_A3PL_Bank_AmericanExpressPlatinumFee" call A3PL_Localize),_costsPlatinum], Color_green] call A3PL_Notification;
			player setVariable ["Player_Bank",_pABank-_costsPlatinum];
		};
	};
}] call compile_Global;

["A3PL_Bank_handleCB", {
	private _number = _this select 0;
	private _paymentSuccess = false;
	private _nomoney = false;

	_PCash = player getVariable ["Player_Cash",0];
	_pBank = player getVariable ["Player_Bank",0];
	_ActiveCB = player getVariable ["Player_ActiveCB",0];

	[player] remoteExec ["Server_Bank_getLimitCB",2];
	_LimitCB = player getVariable ["Player_LimitCB",0];

	if("A3PL_CB" in (magazines player) OR {"A3PL_CB_Gold" in (magazines player)} OR {"A3PL_CB_Platinum" in (magazines player)}) then {
		switch (_ActiveCB) do {
			case 0 : {
				[("STR_A3PL_Bank_UnlinkedCard" call A3PL_Localize),Color_Red] call A3PL_Notification;
				_paymentSuccess = false;
			};
			case 1 : {
				if (_number > _pBank) exitWith {_paymentSuccess = false; _nomoney = true;};
				if (("A3PL_CB_Platinum" in (magazines player)) && ((_LimitCB + _number) > Bank_AmericanExpressLimit_Platinum)) exitWith {
					[format[("STR_A3PL_Bank_PaymentLimitReached" call A3PL_Localize), Bank_AmericanExpressLimit_Platinum], Color_Red] call A3PL_Notification;
					_paymentSuccess = false;
				};
				if (("A3PL_CB_Gold" in (magazines player)) && ((_LimitCB + _number) > Bank_AmericanExpressLimit_Gold)) exitWith {
					[format[("STR_A3PL_Bank_PaymentLimitReached" call A3PL_Localize), Bank_AmericanExpressLimit_Gold], Color_Red] call A3PL_Notification;
					_paymentSuccess = false;
				};
				if (("A3PL_CB" in (magazines player)) && ((_LimitCB + _number) > Bank_AmericanExpressLimit_Standard)) exitWith {
					[format[("STR_A3PL_Bank_PaymentLimitReached" call A3PL_Localize), Bank_AmericanExpressLimit_Standard], Color_Red] call A3PL_Notification;
					_paymentSuccess = false;
				};
				player setVariable ["Player_Bank",_pBank-_number,true];
				player setVariable ["Player_LimitCB",_LimitCB+_number,true];
				[_LimitCB, player] remoteExec ["Server_Bank_updateLimitCB",2];
				if (_number == 1) then {[("STR_A3PL_Bank_CommonAccountDebit" call A3PL_Localize),Color_Green] call A3PL_Notification;};
				if (_number > 1) then {[format[("STR_A3PL_Bank_CommonAccountDebitMultiple" call A3PL_Localize),_number,_LimitCB],Color_Green] call A3PL_Notification;};	
				_paymentSuccess = true;
			};
		};
	} else {
		[("STR_A3PL_Bank_NoCard" call A3PL_Localize),Color_Red] call A3PL_Notification;
		_paymentSuccess = false;
	};
	if (_nomoney) then {
		[format[("STR_A3PL_Bank_PaymentDeclined" call A3PL_Localize),_number],Color_Red] call A3PL_Notification;
		_paymentSuccess = false;
	};
	_paymentSuccess;
}] call compile_Global;

["A3PL_Bank_ATM",
{
	_CommonActive = player getVariable ["Player_BankActive",false];
	_ActiveCB = player getVariable ["Player_ActiveCB",0];
	_pBank = [player getVariable "Player_Bank"] call CBA_fnc_formatNumber;

	if (!("A3PL_CB" in magazines player) && !("A3PL_CB_Gold" in magazines player) && !("A3PL_CB_Platinum" in magazines player))  exitWith {[("STR_A3PL_Bank_NoCard" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (!_CommonActive) exitWith {[("STR_A3PL_Bank_NoCommonAccount" call A3PL_Localize),Color_Red] call A3PL_Notification;};
	if (_ActiveCB isEqualTo 0) exitWith {[("STR_A3PL_Bank_UnlinkedCard" call A3PL_Localize),Color_Red] call A3PL_Notification;};

	if(!dialog) then {
		createDialog "A3PL_Bank_ATM_Dialog";
	};
	disableSerialization;

	private _display = findDisplay 253;
	private _money = _display displayCtrl 4974;

	_money ctrlSetStructuredText parseText format["%1",_pBank];

	[4] call A3PL_Bank_updateCompteBancaire;
	/*
	private _hour = date select 3;
	private _min = date select 4;
	if(_min >= 0 && _min <= 9) then {_min = format["0%1", _min];};
	private _time = format["%1:%2",_hour,_min];

	private _atm = _this select 0;
	private _nearPlayers = (position _atm) nearEntities [["Man"],15];
	private _nearPlayersFace = [];
	{
		if !((headgear player) in HeadgearList AND {(goggles player) in GogglesList}) then {
			_nearPlayersFace pushBack (_x getVariable "adnface" select 1);
		};
	} forEach _nearPlayers;

	[_atm,_time,_nearPlayersFace] remoteExecCall ["Server_Camera_setCameraVar",2];*/
}] call compile_Global;