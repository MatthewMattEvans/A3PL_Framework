class A3PL_NokiaMenu_Dialog {
	idd = 20000;
	name= "A3PL_NokiaMenu_Dialog";
	onLoad = "uiNamespace setVariable ['nokiamenu',0]";
	movingEnable = false;
	enableSimulation = false;
	class controlsBackground {};

	class controls {
		class menu1sim : RscPicture {
			idc = 200011;
			text = "\A3PL_Common\GUI\newphone\Nokia\nokia_1.paa";
			x = 0.567031 * safezoneW + safezoneX;
			y = 0.478 * safezoneH + safezoneY;
			w = 0.273281 * safezoneW;
			h = 0.528 * safezoneH;
		};
		class menu1nosim : RscPicture {
			idc = 200012;
			text = "\A3PL_Common\GUI\newphone\Nokia\nokia_2.paa";
			x = 0.567031 * safezoneW + safezoneX;
			y = 0.478 * safezoneH + safezoneY;
			w = 0.273281 * safezoneW;
			h = 0.528 * safezoneH;
		};
		class menu1incall : RscPicture {
			idc = 200013;
			text = "\A3PL_Common\GUI\newphone\Nokia\nokia_5.paa";
			x = 0.567031 * safezoneW + safezoneX;
			y = 0.478 * safezoneH + safezoneY;
			w = 0.273281 * safezoneW;
			h = 0.528 * safezoneH;
		};
		class menu1ring : RscPicture {
			idc = 200014;
			text = "\A3PL_Common\GUI\newphone\Nokia\nokia_4.paa";
			x = 0.567031 * safezoneW + safezoneX;
			y = 0.478 * safezoneH + safezoneY;
			w = 0.273281 * safezoneW;
			h = 0.528 * safezoneH;
		};
		class menu1try : RscPicture {
			idc = 200015;
			text = "\A3PL_Common\GUI\newphone\Nokia\nokia_9.paa";
			x = 0.567031 * safezoneW + safezoneX;
			y = 0.478 * safezoneH + safezoneY;
			w = 0.273281 * safezoneW;
			h = 0.528 * safezoneH;
		};
		class menu1phone : RscPicture {
			idc = 200016;
			text = "\A3PL_Common\GUI\newphone\Nokia\nokia_10.paa";
			x = 0.567031 * safezoneW + safezoneX;
			y = 0.478 * safezoneH + safezoneY;
			w = 0.273281 * safezoneW;
			h = 0.528 * safezoneH;
		};
		class datenokia : RscStructuredText {
			idc = 20001;
			text = "";
			x = 0.732813 * safezoneW + safezoneX;
			y = 0.651222 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.011 * safezoneH;
		};
		class menu1smsbtn : RscButtonEmpty {
			idc = 20002;
			text = "";
			onButtonClick = "uiNamespace setVariable ['nokiamenu',2]; call A3PL_Phone_menuNokia;";
			x = 0.644792 * safezoneW + safezoneX;
			y = 0.725 * safezoneH + safezoneY;
			w = 0.07 * safezoneW;
			h = 0.0174815 * safezoneH;
		};
		class menu1contactsbtn : RscButtonEmpty {
			idc = 20003;
			text = "";
			onButtonClick = "uiNamespace setVariable ['nokiamenu',1]; call A3PL_Phone_menuNokia;";
			x = 0.644792 * safezoneW + safezoneX;
			y = 0.755556 * safezoneH + safezoneY;
			w = 0.0731249 * safezoneW;
			h = 0.0184074 * safezoneH;
		};
		class menu1telephonebtn : RscButtonEmpty {
			idc = 200031;
			text = "";
			onButtonClick = "uiNamespace setVariable ['nokiamenu',3]; call A3PL_Phone_menuNokia;";
			x = 0.644792 * safezoneW + safezoneX;
			y = 0.786 * safezoneH + safezoneY;
			w = 0.0731249 * safezoneW;
			h = 0.0184074 * safezoneH;
		};
		class menu1name : RscStructuredText {
			idc = 200041;
			text = "";
			font = "NokiaCellphoneFC";
			x = 0.648438 * safezoneW + safezoneX;
			y = 0.721296 * safezoneH + safezoneY;
			w = 0.108281 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu1num : RscStructuredText {
			idc = 200042;
			text = "";
			font = "NokiaCellphoneFC";
			x = 0.64849 * safezoneW + safezoneX;
			y = 0.746297 * safezoneH + safezoneY;
			w = 0.108281 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu1Time : RscStructuredText {
			idc = 200043;
			text = "";
			font = "NokiaCellphoneFC";
			x = 0.64849 * safezoneW + safezoneX;
			y = 0.765 * safezoneH + safezoneY;
			w = 0.108281 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu1decrocher : RscButtonEmpty {
			idc = 20004;
			text = "";
			x = 0.670834 * safezoneW + safezoneX;
			y = 0.85463 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class menu1refuser : RscButtonEmpty {
			idc = 20005;
			text = "";
			x = 0.636979 * safezoneW + safezoneX;
			y = 0.876851 * safezoneH + safezoneY;
			w = 0.0360937 * safezoneW;
			h = 0.066 * safezoneH;
		};
		class menu1raccrocher : RscButtonEmpty {
			idc = 20006;
			text = "";
			x = 0.670834 * safezoneW + safezoneX;
			y = 0.85463 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class menu1quit : RscButtonEmpty {
			idc = 200061;
			text = "";
			onButtonClick = "closeDialog 0;";
			x = 0.711406 * safezoneW + safezoneX;
			y = 0.907 * safezoneH + safezoneY;
			w = 0.0360937 * safezoneW;
			h = 0.055 * safezoneH;
		};
		class menu1up : RscButtonEmpty {
			idc = 200062;
			text = "";
			x = 0.742344 * safezoneW + safezoneX;
			y = 0.874 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.055 * safezoneH;
		};
		class menu1down : RscButtonEmpty {
			idc = 200063;
			text = "";
			x = 0.711406 * safezoneW + safezoneX;
			y = 0.907 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.055 * safezoneH;
		};

		class menu2pic : RscPicture {
			idc = 20010;
			text = "\A3PL_Common\GUI\newphone\Nokia\nokia_6.paa";
			x = 0.567031 * safezoneW + safezoneX;
			y = 0.478 * safezoneH + safezoneY;
			w = 0.273281 * safezoneW;
			h = 0.528 * safezoneH;
		};
		class menu2contactslist : RscListBox {
			idc = 20011;
			text = "";
			colorBackground[] = {0,0,0,0};
			colorText[] = {0,0,0,1};
			font = "NokiaCellphoneFC";
			sizeEx = 0.02;
			x = 0.647396 * safezoneW + safezoneX;
			y = 0.666666 * safezoneH + safezoneY;
			w = 0.116562 * safezoneW;
			h = 0.0870741 * safezoneH;
		};
		class menu2appeler : RscButtonEmpty {
			idc = 20012;
			text = "";
			x = 0.646875 * safezoneW + safezoneX;
			y = 0.778704 * safezoneH + safezoneY;
			w = 0.0429166 * safezoneW;
			h = 0.0156295 * safezoneH;
		};
		class menu2sms : RscButtonEmpty {
			idc = 20013;
			text = "";
			onButtonClick = "[] spawn A3PL_Phone_smsContactNokia;";
			x = 0.646875 * safezoneW + safezoneX;
			y = 0.796296 * safezoneH + safezoneY;
			w = 0.0429166 * safezoneW;
			h = 0.0156295 * safezoneH;
		};
		class menu2supprimer : RscButtonEmpty {
			idc = 20014;
			text = "";
			onButtonClick = "[] spawn A3PL_Phone_deleteContactNokia;";
			x = 0.646875 * safezoneW + safezoneX;
			y = 0.758333 * safezoneH + safezoneY;
			w = 0.0392708 * safezoneW;
			h = 0.0147037 * safezoneH;
		};
		class menu2nameedit : RscEdit {
			idc = 20015;
			text = "";
			colorText[] = {0,0,0,1};
			colorBackground[] = {0,0,0,0};
			font = "NokiaCellphoneFC";
			sizeEx = 0.02;
			style = 0;
			lineSpacing = 0;
			shadow = 0;
			x = 0.710417 * safezoneW + safezoneX;
			y = 0.760185 * safezoneH + safezoneY;
			w = 0.0547917 * safezoneW;
			h = 0.0142592 * safezoneH;
		};
		class menu2numedit : RscEdit {
			idc = 20016;
			text = "";
			colorText[] = {0,0,0,1};
			colorBackground[] = {0,0,0,0};
			font = "NokiaCellphoneFC";
			sizeEx = 0.02;
			style = 0;
			lineSpacing = 0;
			shadow = 0;
			x = 0.710417 * safezoneW + safezoneX;
			y = 0.777778 * safezoneH + safezoneY;
			w = 0.0547917 * safezoneW;
			h = 0.0142592 * safezoneH;
		};
		class menu2ajouter : RscButtonEmpty {
			idc = 20017;
			text = "";
			onButtonClick = "[] spawn A3PL_Phone_addContactNokia;";
			x = 0.709896 * safezoneW + safezoneX;
			y = 0.793518 * safezoneH + safezoneY;
			w = 0.0340624 * safezoneW;
			h = 0.0165553 * safezoneH;
		};
		class menu2retour : RscButtonEmpty {
			idc = 200171;
			text = "";
			onButtonClick = "uiNamespace setVariable ['nokiamenu',0]; call A3PL_Phone_menuNokia;";
			x = 0.711406 * safezoneW + safezoneX;
			y = 0.907 * safezoneH + safezoneY;
			w = 0.0360937 * safezoneW;
			h = 0.055 * safezoneH;
		};

		class menu3pic : RscPicture {
			idc = 20018;
			text = "\A3PL_Common\GUI\newphone\Nokia\nokia_8.paa";
			x = 0.567031 * safezoneW + safezoneX;
			y = 0.478 * safezoneH + safezoneY;
			w = 0.273281 * safezoneW;
			h = 0.528 * safezoneH;
		};
		class menu3smsname : RscStructuredText {
			idc = 200181;
			text = "";
			font = "NokiaCellphoneFC";
			x = 0.706771 * safezoneW + safezoneX;
			y = 0.671296 * safezoneH + safezoneY;
			w = 0.0606249 * safezoneW;
			h = 0.0128518 * safezoneH;
		};
		class menu3numedit : RscEdit {
			idc = 200182;
			text = "";
			colorText[] = {0,0,0,1};
			colorBackground[] = {0,0,0,0};
			font = "NokiaCellphoneFC";
			sizeEx = 0.025;
			style = 0;
			lineSpacing = 0;
			shadow = 0;
			x = 0.706771 * safezoneW + safezoneX;
			y = 0.671296 * safezoneH + safezoneY;
			w = 0.0606249 * safezoneW;
			h = 0.0128518 * safezoneH;
		};
		class menu3smsedit : RscEdit {
			idc = 20019;
			text = "";
			colorText[] = {0,0,0,1};
			colorBackground[] = {0,0,0,0};
			font = "NokiaCellphoneFC";
			sizeEx = 0.025;
			style = 16;
			shadow = 0;
			x = 0.642188 * safezoneW + safezoneX;
			y = 0.695371 * safezoneH + safezoneY;
			w = 0.123542 * safezoneW;
			h = 0.092963 * safezoneH;
		};
		class menu3smsbtn : RscButtonEmpty {
			idc = 20020;
			text = "";
			x = 0.728125 * safezoneW + safezoneX;
			y = 0.794444 * safezoneH + safezoneY;
			w = 0.035104 * safezoneW;
			h = 0.0137777 * safezoneH;
		};
		class menu3retour : RscButtonEmpty {
			idc = 200201;
			text = "";
			onButtonClick = "uiNamespace setVariable ['nokiamenu',2]; call A3PL_Phone_menuNokia;";
			x = 0.711406 * safezoneW + safezoneX;
			y = 0.907 * safezoneH + safezoneY;
			w = 0.0360937 * safezoneW;
			h = 0.055 * safezoneH;
		};

		class menu4pic : RscPicture {
			idc = 200211;
			text = "\A3PL_Common\GUI\newphone\Nokia\nokia_7.paa";
			x = 0.567031 * safezoneW + safezoneX;
			y = 0.478 * safezoneH + safezoneY;
			w = 0.273281 * safezoneW;
			h = 0.528 * safezoneH;
		};
		class menu4smslist : RscListBox {
			idc = 20021;
			text = "";
			colorBackground[] = {0,0,0,0};
			colorText[] = {0,0,0,1};
			shadow = 0;
			font = "NokiaCellphoneFC";
			sizeEx = 0.02;
			onLBSelChanged = "[] call A3PL_Phone_lbChangedSmsNokia;";
			x = 0.640104 * safezoneW + safezoneX;
			y = 0.668518 * safezoneH + safezoneY;
			w = 0.0533333 * safezoneW;
			h = 0.0887777 * safezoneH;
		};
		class menu4smsview : RscStructuredText {
			idc = 20022;
			text = "";
			x = 0.695312 * safezoneW + safezoneX;
			y = 0.668519 * safezoneH + safezoneY;
			w = 0.073125 * safezoneW;
			h = 0.0887777 * safezoneH;
		};
		class menu4repondre : RscButtonEmpty {
			idc = 20023;
			text = "";
			x = 0.643229 * safezoneW + safezoneX;
			y = 0.766667 * safezoneH + safezoneY;
			w = 0.0507292 * safezoneW;
			h = 0.0174814 * safezoneH;
		};
		class menu4supprimer : RscButtonEmpty {
			idc = 20024;
			text = "";
			x = 0.643229 * safezoneW + safezoneX;
			y = 0.785185 * safezoneH + safezoneY;
			w = 0.0507292 * safezoneW;
			h = 0.0174814 * safezoneH;
		};
		class menu4newsms : RscButtonEmpty {
			idc = 20025;
			text = "";
			x = 0.70625 * safezoneW + safezoneX;
			y = 0.766667 * safezoneH + safezoneY;
			w = 0.0507292 * safezoneW;
			h = 0.0174814 * safezoneH;
		};
		class menu4retour : RscButtonEmpty {
			idc = 20026;
			text = "";
			x = 0.711406 * safezoneW + safezoneX;
			y = 0.907 * safezoneH + safezoneY;
			w = 0.0360937 * safezoneW;
			h = 0.055 * safezoneH;
		};

		class menurecent : RscPicture {
			idc = 20027;
			text = "\A3PL_Common\GUI\newphone\Nokia\nokia_11.paa";
			x = 0.567031 * safezoneW + safezoneX;
			y = 0.478 * safezoneH + safezoneY;
			w = 0.273281 * safezoneW;
			h = 0.528 * safezoneH;
		};
		class menunokiarecents : RscListBox {
			idc = 20028;
			text = "";
			colorBackground[] = {0,0,0,0};
			colorText[] = {0,0,0,1};
			shadow = 0;
			font = "NokiaCellphoneFC";
			sizeEx = 0.02;
			x = 0.640625 * safezoneW + safezoneX;
			y = 0.668519 * safezoneH + safezoneY;
			w = 0.125625 * safezoneW;
			h = 0.0883333 * safezoneH;
		};
	};
};

class A3PL_Inspect_Tel {
  idd = 754720;
  movingEnable = 0;
  enableSimulation = 1;
  onUnload = "if !(A3PL_InspectTelMarker isEqualTo """") then {deleteMarkerLocal A3PL_InspectTelMarker;};A3PL_InspectTelMarker = """";A3PL_InspectTelTarget = objNull;";

  class controlsBackground {
    class RscTitleBackground: RscText    {
      colorBackground[] = {"(profileNamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profileNamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profileNamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profileNamespace getvariable ['GUI_BCG_RGB_A',0.7])"};
      idc = -1;
      x = 0.335 * safezoneW + safezoneX;
      y = 0.335 * safezoneH + safezoneY;
      w = 0.4 * safezoneW;
      h = 0.022 * safezoneH;
    };

    class MainBackground: RscText {
      colorBackground[] = {0,0,0,0.7};
      idc = -1;
      x = 0.335 * safezoneW + safezoneX;
      y = 0.3592 * safezoneH + safezoneY;
      w = 0.4 * safezoneW;
      h = 0.4 * safezoneH;
    };

    class TitreGlobale: RscTitle {
      colorBackground[] = {0,0,0,0};
      idc = -1;
      text = "STR_UI_InspectTel_LocTelTitle";
      x = 0.334322 * safezoneW + safezoneX;
      y = 0.336111 * safezoneH + safezoneY;
      w = 0.4 * safezoneW;
      h = 0.022 * safezoneH;
    };

    class TitreNumero: RscTitle {
      colorBackground[] = {0,0,0,0};
      idc = -1;
      text = "STR_UI_InspectTel_Number";
      x = 0.335938 * safezoneW + safezoneX;
      y = 0.364815 * safezoneH + safezoneY;
      w = 0.13375 * safezoneW;
      h = 0.022 * safezoneH;
    };

    class TitreHistorique: RscTitle {
      colorBackground[] = {0,0,0,0};
      idc = -1;
      text = "STR_UI_InspectTel_History";
      x = 0.336979 * safezoneW + safezoneX;
      y = 0.436111 * safezoneH + safezoneY;
      w = 0.121771 * safezoneW;
      h = 0.0173704 * safezoneH;
    };

    class MapView : RscMapControl {
		idc = 754721;
		x = 0.46927 * safezoneW + safezoneX;
		y = 0.366667 * safezoneH + safezoneY;
		w = 0.261562 * safezoneW;
		h = 0.382778 * safezoneH;
		maxSatelliteAlpha = 0.75;//0.75;
		alphaFadeStartScale = 1.15;//0.15;
		alphaFadeEndScale = 1.29;//0.29;
    };
  };

  class controls {
    class HistoriqueListe: RscListBox {
		idc = 754722;
		text = "";
		sizeEx = 0.035;
		onLBSelChanged = "[3] call A3PL_Phone_menuInspectTel;";
		x = 0.340104 * safezoneW + safezoneX;
    	y = 0.458333 * safezoneH + safezoneY;
    	w = 0.1225 * safezoneW;
    	h = 0.276296 * safezoneH;
    };

    class NumeroEdit: RscEdit {
		idc = 754723;
		sizeEx = 0.036;
		text = "";
		x = 0.338542 * safezoneW + safezoneX;
    	y = 0.390741 * safezoneH + safezoneY;
    	w = 0.125625 * safezoneW;
    	h = 0.0216667 * safezoneH;
    };

    class OKButton: RscButton {
		idc = -1;
		text = "STR_UI_Common_Ok";
		onButtonClick = "[1] call A3PL_Phone_menuInspectTel;";
		x = 0.334896 * safezoneW + safezoneX;
    	y = 0.759259 * safezoneH + safezoneY;
    	w = 0.0644531 * safezoneW;
    	h = 0.022 * safezoneH;
	};
	
	class CloseButtonKey: RscButton {
		idc = -1;
		text = "STR_UI_Common_Close";
		onButtonClick = "closeDialog 0; ";
		x = 0.334896 * safezoneW + safezoneX;
    	y = 0.792259 * safezoneH + safezoneY;
    	w = 0.0644531 * safezoneW;
    	h = 0.022 * safezoneH;
	};
  };
};

class A3PL_SR_SMS_Tel {
	idd = 754721;
	movingEnable = 0;
	enableSimulation = 1;
	onUnload = "A3PL_InspectTelTarget = objNull;";

	class controlsBackground {
		class RscTitleBackground: RscText {
			colorBackground[] = {"(profileNamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profileNamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profileNamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profileNamespace getvariable ['GUI_BCG_RGB_A',0.7])"};
			idc = -1;
			x = 0.335 * safezoneW + safezoneX;
			y = 0.335 * safezoneH + safezoneY;
			w = 0.4 * safezoneW;
			h = 0.022 * safezoneH;
		};

		class MainBackground: RscText {
			colorBackground[] = {0,0,0,0.7};
			idc = -1;
			x = 0.335 * safezoneW + safezoneX;
			y = 0.3592 * safezoneH + safezoneY;
			w = 0.4 * safezoneW;
			h = 0.4 * safezoneH;
		};

		class TitreGlobale: RscTitle {
			colorBackground[] = {0,0,0,0};
			idc = -1;
			text = "STR_UI_InspectTel_LocSmsTitle";
			x = 0.334322 * safezoneW + safezoneX;
			y = 0.336111 * safezoneH + safezoneY;
			w = 0.4 * safezoneW;
			h = 0.022 * safezoneH;
		};

		class TitreNumero: RscTitle {
			colorBackground[] = {0,0,0,0};
			idc = -1;
			text = "STR_UI_InspectTel_Number";
			x = 0.335938 * safezoneW + safezoneX;
			y = 0.364815 * safezoneH + safezoneY;
			w = 0.13375 * safezoneW;
			h = 0.022 * safezoneH;
		};

		class TitreHistorique: RscTitle {
			colorBackground[] = {0,0,0,0};
			idc = -1;
			text = "STR_UI_InspectTel_History";
			x = 0.336979 * safezoneW + safezoneX;
			y = 0.436111 * safezoneH + safezoneY;
			w = 0.121771 * safezoneW;
			h = 0.0173704 * safezoneH;
		};

		class SMSText : RscStructuredText {
			idc = 754724;
			x = 0.46927 * safezoneW + safezoneX;
			y = 0.366667 * safezoneH + safezoneY;
			w = 0.261562 * safezoneW;
			h = 0.382778 * safezoneH;
		};
	 };

	class controls {
		class HistoriqueListe: RscListBox {
			idc = 754722;
			text = "";
			sizeEx = 0.035;
			x = 0.340104 * safezoneW + safezoneX;
			y = 0.458333 * safezoneH + safezoneY;
			w = 0.1225 * safezoneW;
			h = 0.276296 * safezoneH;
			onLBSelChanged = "[3] call A3PL_Phone_menuSMSSR;";
		};

		class NumeroEdit: RscEdit {
			idc = 754723;
			sizeEx = 0.036;
			text = "";
			x = 0.338542 * safezoneW + safezoneX;
			y = 0.390741 * safezoneH + safezoneY;
			w = 0.125625 * safezoneW;
			h = 0.0216667 * safezoneH;
		};
		
		class OKButton: RscButtonMenu {
			idc = -1;
			text = "STR_UI_Common_Ok";
			onButtonClick = "[1,ctrlText 754723] call A3PL_Phone_menuSMSSR;";
			x = 0.334896 * safezoneW + safezoneX;
			y = 0.759259 * safezoneH + safezoneY;
			w = 0.0644531 * safezoneW;
			h = 0.022 * safezoneH;
		};

		class CloseButtonKey: RscButtonMenu {
			idc = -1;
			text = "STR_UI_Common_Close";
			onButtonClick = "closeDialog 0; ";
			x = 0.334896 * safezoneW + safezoneX;
			y = 0.792259 * safezoneH + safezoneY;
			w = 0.0644531 * safezoneW;
			h = 0.022 * safezoneH;
		};
	};
};