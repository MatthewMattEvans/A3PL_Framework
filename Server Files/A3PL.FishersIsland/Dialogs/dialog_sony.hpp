class A3PL_Sony_Dialog {
	idd = 32999;
	name= "A3PL_Sony_Dialog";
	onLoad = "uiNamespace setVariable ['sony',0]";
	movingEnable = true;
	enableSimulation = false;
	class controlsBackground {};

	class controls {
		class SonyMenu : RscPicture {
			idc = 33001;
			text = "\A3PL_Common\GUI\newphone\Sony\Sony_Menu.paa";
			x = 0.200937 * safezoneW + safezoneX;
			y = 0.027 * safezoneH + safezoneY;
			w = 0.587812 * safezoneW;
			h = 1 * safezoneH;
		};
		class SonyMenuBtnAppel : RscButtonEmpty {
			idc = 33002;
			text = "";
			onButtonClick = "";
			x = 0.396875 * safezoneW + safezoneX;
			y = 0.687 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.077 * safezoneH;
		};
		class SonyMenuBtnSms : RscButtonEmpty {
			idc = 33003;
			text = "";
			onButtonClick = "";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.687 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.077 * safezoneH;
		};
		class SonyMenuBtnContact : RscButtonEmpty {
			idc = 33004;
			text = "";
			onButtonClick = "";
			x = 0.5 * safezoneW + safezoneX;
			y = 0.687 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.077 * safezoneH;
		};
		class SonyMenuBtnRegl : RscButtonEmpty {
			idc = 33005;
			text = "";
			onButtonClick = "";
			x = 0.551562 * safezoneW + safezoneX;
			y = 0.687 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.077 * safezoneH;
		};
		class SonyMenuBtnRadio : RscButtonEmpty {
			idc = 33006;
			text = "";
			onButtonClick = "";
			x = 0.670156 * safezoneW + safezoneX;
			y = 0.313 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.077 * safezoneH;
		};
		class SonyMenuBtnStation: RscButtonEmpty
		{
			idc = 45155;
			text = "";
			onButtonClick = "";
			x = 0.629687 * safezoneW + safezoneX;
			y = 0.306495 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.0549793 * safezoneH;
		};
		class SonyMenuBtnNotes: RscButtonEmpty
		{
			idc = 45156;
			text = "";
			onButtonClick = "";
			x = 0.674479 * safezoneW + safezoneX;
			y = 0.481658 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.0549793 * safezoneH;
		};
		class SonyMenuBtnClefs: RscButtonEmpty
		{
			idc = 45157;
			text = "";
			onButtonClick = "";
			x = 0.674479 * safezoneW + safezoneX;
			y = 0.394535 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.0549793 * safezoneH;
		};
		class SonyMenuBtnFilesManager: RscButtonEmpty
		{
			idc = 451581;
			text = "";
			onButtonClick = "";
			x = 0.629068 * safezoneW + safezoneX;
			y = 0.482368 * safezoneH + safezoneY;
			w = 0.0309253 * safezoneW;
			h = 0.0549908 * safezoneH;
		};
		class SonyMenuBtnTwitter: RscButtonEmpty
        {
            idc = 451591;
            onButtonClick = "";

            x = 0.628906 * safezoneW + safezoneX;
            y = 0.401 * safezoneH + safezoneY;
            w = 0.0309253 * safezoneW;
            h = 0.0549908 * safezoneH;
            colorText[] = {0,0,0,0};
            colorBackground[] = {0,0,0,0};
        };
		class SonyAppel : RscPicture {
			idc = 33007;
			text = "\A3PL_Common\GUI\newphone\Sony\Sony_Appel.paa";
			x = 0.200937 * safezoneW + safezoneX;
			y = 0.027 * safezoneH + safezoneY;
			w = 0.587812 * safezoneW;
			h = 1 * safezoneH;
		};
		class SonyAppelBtn : RscButtonEmpty {
			idc = 33008;
			text = "";
			onButtonClick = "";
			x = 0.474219 * safezoneW + safezoneX;
			y = 0.65863 * safezoneH + safezoneY;
			w = 0.0407292 * safezoneW;
			h = 0.068889 * safezoneH;
		};
		class SonyAppelEdit : RscEdit {
			idc = 33009;
			text = "";
			colorText[] = {0,0,0,1};
			colorBackground[] = {0,0,0,0};
			font = "HelveticaLTLight";
			sizeEx = 0.1;
			style = 2;
			shadow = 0;
			x = 0.382291 * safezoneW + safezoneX;
			y = 0.309259 * safezoneH + safezoneY;
			w = 0.223021 * safezoneW;
			h = 0.0596297 * safezoneH;
		};
		class SonyMenuLock : RscPicture {
			idc = 33010;
			text = "\A3PL_Common\GUI\newphone\Sony\Sony_MenuLock.paa";
			x = 0.200937 * safezoneW + safezoneX;
			y = 0.027 * safezoneH + safezoneY;
			w = 0.587812 * safezoneW;
			h = 1 * safezoneH;
		};
		class SonyInCall : RscPicture {
			idc = 33011;
			text = "\A3PL_Common\GUI\newphone\Sony\Sony_InCall.paa";
			x = 0.200937 * safezoneW + safezoneX;
			y = 0.027 * safezoneH + safezoneY;
			w = 0.587812 * safezoneW;
			h = 1 * safezoneH;
		};
		class SonyInCallHP : RscPicture {
			idc = 33012;
			text = "\A3PL_Common\GUI\newphone\Sony\Sony_InCall_HP.paa";
			x = 0.200937 * safezoneW + safezoneX;
			y = 0.027 * safezoneH + safezoneY;
			w = 0.587812 * safezoneW;
			h = 1 * safezoneH;
		};
		class SonyInCallMute : RscPicture {
			idc = 33013;
			text = "\A3PL_Common\GUI\newphone\Sony\Sony_InCall_Mute.paa";
			x = 0.200937 * safezoneW + safezoneX;
			y = 0.027 * safezoneH + safezoneY;
			w = 0.587812 * safezoneW;
			h = 1 * safezoneH;
		};
		class SonyInCallBtnVolp : RscButtonEmpty {
			idc = 33014;
			text = "";
			onButtonClick = "";
			x = 0.437604 * safezoneW + safezoneX;
			y = 0.465148 * safezoneH + safezoneY;
			w = 0.05375 * safezoneW;
			h = 0.0911111 * safezoneH;
		};
		class SonyInCallBtnVolm : RscButtonEmpty {
			idc = 33015;
			text = "";
			onButtonClick = "";
			x = 0.497969 * safezoneW + safezoneX;
			y = 0.465148 * safezoneH + safezoneY;
			w = 0.05375 * safezoneW;
			h = 0.0911111 * safezoneH;
		};
		class SonyInCallBtnHP : RscButtonEmpty {
			idc = 33016;
			text = "";
			onButtonClick = "";
			x = 0.556719 * safezoneW + safezoneX;
			y = 0.465148 * safezoneH + safezoneY;
			w = 0.05375 * safezoneW;
			h = 0.0911111 * safezoneH;
		};
		class SonyInCallBtnMute : RscButtonEmpty {
			idc = 33017;
			text = "";
			onButtonClick = "";
			x = 0.379167 * safezoneW + safezoneX;
			y = 0.465148 * safezoneH + safezoneY;
			w = 0.05375 * safezoneW;
			h = 0.0911111 * safezoneH;
		};
		class SonyRingCall : RscPicture {
			idc = 33018;
			text = "\A3PL_Common\GUI\newphone\Sony\Sony_ringCall.paa";
			x = 0.200937 * safezoneW + safezoneX;
			y = 0.027 * safezoneH + safezoneY;
			w = 0.587812 * safezoneW;
			h = 1 * safezoneH;
		};
		class SonyInCallName : RscStructuredText {
			idc = 33019;
			text = "";
			x = 0.273125 * safezoneW + safezoneX;
			y = 0.292852 * safezoneH + safezoneY;
			w = 0.326146 * safezoneW;
			h = 0.0707407 * safezoneH;
		};
		class SonyInCallNumber : RscStructuredText {
			idc = 33020;
			text = "";
			x = 0.272917 * safezoneW + safezoneX;
			y = 0.37037 * safezoneH + safezoneY;
			w = 0.211563 * safezoneW;
			h = 0.0587037 * safezoneH;
		};
		class SonyInCallTime : RscStructuredText {
			idc = 33021;
			text = "";
			x = 0.603646 * safezoneW + safezoneX;
			y = 0.314815 * safezoneH + safezoneY;
			w = 0.110521 * safezoneW;
			h = 0.0957408 * safezoneH;
		};
		class SonyInCallBtnRefuse : RscButtonEmpty {
			idc = 33022;
			text = "";
			onButtonClick = "";
			x = 0.467188 * safezoneW + safezoneX;
			y = 0.649074 * safezoneH + safezoneY;
			w = 0.05375 * safezoneW;
			h = 0.0911111 * safezoneH;
		};
		class SonyRingCallBtnDecrocher : RscButtonEmpty {
			idc = 33023;
			text = "";
			onButtonClick = "";
			x = 0.407187 * safezoneW + safezoneX;
			y = 0.643 * safezoneH + safezoneY;
			w = 0.050625 * safezoneW;
			h = 0.0864815 * safezoneH;
		};
		class SonyRingCallBtnRacrocher : RscButtonEmpty {
			idc = 33024;
			text = "";
			onButtonClick = "";
			x = 0.530937 * safezoneW + safezoneX;
			y = 0.643 * safezoneH + safezoneY;
			w = 0.050625 * safezoneW;
			h = 0.0864815 * safezoneH;
		};
		class SonyRegl : RscPicture {
			idc = 33025;
			text = "\A3PL_Common\GUI\newphone\Sony\Sony_Reglages.paa";
			x = 0.200937 * safezoneW + safezoneX;
			y = 0.027 * safezoneH + safezoneY;
			w = 0.587812 * safezoneW;
			h = 1 * safezoneH;
		};
		class SonyReglON1 : RscPicture {
			idc = 33026;
			text = "\A3PL_Common\GUI\newphone\Sony\Sony_Reglages_ON1.paa";
			x = 0.200937 * safezoneW + safezoneX;
			y = 0.027 * safezoneH + safezoneY;
			w = 0.587812 * safezoneW;
			h = 1 * safezoneH;
		};
		class SonyReglOFF1 : RscPicture {
			idc = 33027;
			text = "\A3PL_Common\GUI\newphone\Sony\Sony_Reglages_OFF1.paa";
			x = 0.200937 * safezoneW + safezoneX;
			y = 0.027 * safezoneH + safezoneY;
			w = 0.587812 * safezoneW;
			h = 1 * safezoneH;
		};
		class SonyReglON2 : RscPicture {
			idc = 33028;
			text = "\A3PL_Common\GUI\newphone\Sony\Sony_Reglages_ON2.paa";
			x = 0.200937 * safezoneW + safezoneX;
			y = 0.027 * safezoneH + safezoneY;
			w = 0.587812 * safezoneW;
			h = 1 * safezoneH;
		};
		class SonyReglOFF2 : RscPicture {
			idc = 33029;
			text = "\A3PL_Common\GUI\newphone\Sony\Sony_Reglages_OFF2.paa";
			x = 0.200937 * safezoneW + safezoneX;
			y = 0.027 * safezoneH + safezoneY;
			w = 0.587812 * safezoneW;
			h = 1 * safezoneH;
		};
		class SonyReglON3 : RscPicture {
			idc = 33030;
			text = "\A3PL_Common\GUI\newphone\Sony\Sony_Reglages_ON3.paa";
			x = 0.200937 * safezoneW + safezoneX;
			y = 0.027 * safezoneH + safezoneY;
			w = 0.587812 * safezoneW;
			h = 1 * safezoneH;
		};
		class SonyReglOFF3 : RscPicture {
			idc = 33031;
			text = "\A3PL_Common\GUI\newphone\Sony\Sony_Reglages_OFF3.paa";
			x = 0.200937 * safezoneW + safezoneX;
			y = 0.027 * safezoneH + safezoneY;
			w = 0.587812 * safezoneW;
			h = 1 * safezoneH;
		};
		class SonyReglBtnAvion : RscButtonEmpty {
			idc = 33032;
			text = "";
			onButtonClick = "";
			x = 0.659844 * safezoneW + safezoneX;
			y = 0.39 * safezoneH + safezoneY;
			w = 0.0464063 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class SonyReglBtnSilence : RscButtonEmpty {
			idc = 33033;
			text = "";
			onButtonClick = "";
			x = 0.659844 * safezoneW + safezoneX;
			y = 0.443518 * safezoneH + safezoneY;
			w = 0.0464063 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class SonyReglBtnAnon : RscButtonEmpty {
			idc = 33034;
			text = "";
			onButtonClick = "";
			x = 0.659844 * safezoneW + safezoneX;
			y = 0.5 * safezoneH + safezoneY;
			w = 0.0464063 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class SonyDate : RscStructuredText {
			idc = 33035;
			text = "";
			x = 0.396875 * safezoneW + safezoneX;
			y = 0.302 * safezoneH + safezoneY;
			w = 0.195937 * safezoneW;
			h = 0.121 * safezoneH;
		};
		class SonyRadio : RscPicture {
			idc = 33036;
			text = "\A3PL_Common\GUI\newphone\Sony\Sony_Radio.paa";
			x = 0.200937 * safezoneW + safezoneX;
			y = 0.027 * safezoneH + safezoneY;
			w = 0.587812 * safezoneW;
			h = 1 * safezoneH;
		};
		class SonyRadioBtn1 : RscButtonEmpty {
			idc = 33037;
			text = "";
			onButtonClick = "";
			x = 0.277136 * safezoneW + safezoneX;
			y = 0.294444 * safezoneH + safezoneY;
			w = 0.0761458 * safezoneW;
			h = 0.0735185 * safezoneH;
		};
		class SonyRadioBtn2 : RscButtonEmpty {
			idc = 33038;
			text = "";
			onButtonClick = "";
			x = 0.276563 * safezoneW + safezoneX;
			y = 0.37963 * safezoneH + safezoneY;
			w = 0.0761458 * safezoneW;
			h = 0.0735185 * safezoneH;
		};
		class SonyRadioBtn3 : RscButtonEmpty {
			idc = 33039;
			text = "";
			onButtonClick = "";
			x = 0.276563 * safezoneW + safezoneX;
			y = 0.464815 * safezoneH + safezoneY;
			w = 0.0761458 * safezoneW;
			h = 0.0735185 * safezoneH;
		};
		class SonyRadioBtn4 : RscButtonEmpty {
			idc = 33040;
			text = "";
			onButtonClick = "";
			x = 0.276563 * safezoneW + safezoneX;
			y = 0.550926 * safezoneH + safezoneY;
			w = 0.0761458 * safezoneW;
			h = 0.0735185 * safezoneH;
		};
		class SonyRadioBtn5 : RscButtonEmpty {
			idc = 33041;
			text = "";
			onButtonClick = "";
			x = 0.276563 * safezoneW + safezoneX;
			y = 0.635185 * safezoneH + safezoneY;
			w = 0.0761458 * safezoneW;
			h = 0.0735185 * safezoneH;
		};
		class SonyRadioBtn6 : RscButtonEmpty {
			idc = 33042;
			text = "";
			onButtonClick = "";
			x = 0.360937 * safezoneW + safezoneX;
			y = 0.29537 * safezoneH + safezoneY;
			w = 0.0761458 * safezoneW;
			h = 0.0735185 * safezoneH;
		};
		class SonyRadioBtn7 : RscButtonEmpty {
			idc = 33043;
			text = "";
			onButtonClick = "";
			x = 0.360417 * safezoneW + safezoneX;
			y = 0.380556 * safezoneH + safezoneY;
			w = 0.0761458 * safezoneW;
			h = 0.0735185 * safezoneH;
		};
		class SonyRadioBtn8 : RscButtonEmpty {
			idc = 33044;
			text = "";
			onButtonClick = "";
			x = 0.361458 * safezoneW + safezoneX;
			y = 0.464815 * safezoneH + safezoneY;
			w = 0.0761458 * safezoneW;
			h = 0.0735185 * safezoneH;
		};
		class SonyRadioBtn9 : RscButtonEmpty {
			idc = 33045;
			text = "";
			onButtonClick = "";
			x = 0.361458 * safezoneW + safezoneX;
			y = 0.549074 * safezoneH + safezoneY;
			w = 0.0761458 * safezoneW;
			h = 0.0735185 * safezoneH;
		};
		class SonyRadioBtn10 : RscButtonEmpty {
			idc = 33046;
			text = "";
			onButtonClick = "";
			x = 0.361458 * safezoneW + safezoneX;
			y = 0.636111 * safezoneH + safezoneY;
			w = 0.0761458 * safezoneW;
			h = 0.0735185 * safezoneH;
		};
		class SonyRadioBtn11 : RscButtonEmpty {
			idc = 33047;
			text = "";
			onButtonClick = "";
			x = 0.445833 * safezoneW + safezoneX;
			y = 0.29537 * safezoneH + safezoneY;
			w = 0.0761458 * safezoneW;
			h = 0.0735185 * safezoneH;
		};
		class SonyRadioBtn12 : RscButtonEmpty {
			idc = 33048;
			text = "";
			onButtonClick = "";
			x = 0.445833 * safezoneW + safezoneX;
			y = 0.380556 * safezoneH + safezoneY;
			w = 0.0761458 * safezoneW;
			h = 0.0735185 * safezoneH;
		};
		class SonyRadioBtn13 : RscButtonEmpty {
			idc = 33049;
			text = "";
			onButtonClick = "";
			x = 0.445833 * safezoneW + safezoneX;
			y = 0.465741 * safezoneH + safezoneY;
			w = 0.0761458 * safezoneW;
			h = 0.0735185 * safezoneH;
		};
		class SonyRadioBtn14 : RscButtonEmpty {
			idc = 33050;
			text = "";
			onButtonClick = "";
			x = 0.445833 * safezoneW + safezoneX;
			y = 0.55 * safezoneH + safezoneY;
			w = 0.0761458 * safezoneW;
			h = 0.0735185 * safezoneH;
		};
		class SonyRadioBtn15 : RscButtonEmpty {
			idc = 33051;
			text = "";
			onButtonClick = "";
			x = 0.445833 * safezoneW + safezoneX;
			y = 0.635185 * safezoneH + safezoneY;
			w = 0.0761458 * safezoneW;
			h = 0.0735185 * safezoneH;
		};
		class SonyRadioBtn16 : RscButtonEmpty {
			idc = 33052;
			text = "";
			onButtonClick = "";
			x = 0.528646 * safezoneW + safezoneX;
			y = 0.294444 * safezoneH + safezoneY;
			w = 0.0761458 * safezoneW;
			h = 0.0735185 * safezoneH;
		};
		class SonyRadioBtn17 : RscButtonEmpty {
			idc = 33053;
			text = "";
			onButtonClick = "";
			x = 0.528646 * safezoneW + safezoneX;
			y = 0.379 * safezoneH + safezoneY;
			w = 0.0761458 * safezoneW;
			h = 0.0735185 * safezoneH;
		};
		class SonyRadioBtn18 : RscButtonEmpty {
			idc = 33054;
			text = "";
			onButtonClick = "";
			x = 0.528646 * safezoneW + safezoneX;
			y = 0.464815 * safezoneH + safezoneY;
			w = 0.0761458 * safezoneW;
			h = 0.0735185 * safezoneH;
		};
		class SonyRadioBtn19 : RscButtonEmpty {
			idc = 33055;
			text = "";
			onButtonClick = "";
			x = 0.528646 * safezoneW + safezoneX;
			y = 0.55 * safezoneH + safezoneY;
			w = 0.0761458 * safezoneW;
			h = 0.0735185 * safezoneH;
		};
		class SonyRadioBtn20 : RscButtonEmpty {
			idc = 33056;
			text = "";
			onButtonClick = "";
			x = 0.528646 * safezoneW + safezoneX;
			y = 0.635185 * safezoneH + safezoneY;
			w = 0.0761458 * safezoneW;
			h = 0.0735185 * safezoneH;
		};
		class SonyRadioBtn21 : RscButtonEmpty {
			idc = 33057;
			text = "";
			onButtonClick = "";
			x = 0.6125 * safezoneW + safezoneX;
			y = 0.29537 * safezoneH + safezoneY;
			w = 0.0761458 * safezoneW;
			h = 0.0735185 * safezoneH;
		};
		class SonyRadioBtn22 : RscButtonEmpty {
			idc = 33058;
			text = "";
			onButtonClick = "";
			x = 0.6125 * safezoneW + safezoneX;
			y = 0.379 * safezoneH + safezoneY;
			w = 0.0761458 * safezoneW;
			h = 0.0735185 * safezoneH;
		};
		class SonyRadioCo1 : RscStructuredText {
			idc = 33059;
			text = "";
			onButtonClick = "";
			x = 0.282395 * safezoneW + safezoneX;
			y = 0.322148 * safezoneH + safezoneY;
			w = 0.0688542 * safezoneW;
			h = 0.017037 * safezoneH;
		};
		class SonyRadioCo2 : RscStructuredText {
			idc = 33060;
			text = "";
			onButtonClick = "";
			x = 0.282395 * safezoneW + safezoneX;
			y = 0.407407 * safezoneH + safezoneY;
			w = 0.0688542 * safezoneW;
			h = 0.017037 * safezoneH;
		};
		class SonyRadioCo3 : RscStructuredText {
			idc = 33061;
			text = "";
			onButtonClick = "";
			x = 0.282395 * safezoneW + safezoneX;
			y = 0.492593 * safezoneH + safezoneY;
			w = 0.0688542 * safezoneW;
			h = 0.017037 * safezoneH;
		};
		class SonyRadioCo4 : RscStructuredText {
			idc = 33062;
			text = "";
			onButtonClick = "";
			x = 0.282395 * safezoneW + safezoneX;
			y = 0.576852 * safezoneH + safezoneY;
			w = 0.0688542 * safezoneW;
			h = 0.017037 * safezoneH;
		};
		class SonyRadioCo5 : RscStructuredText {
			idc = 33063;
			text = "";
			onButtonClick = "";
			x = 0.282395 * safezoneW + safezoneX;
			y = 0.662037 * safezoneH + safezoneY;
			w = 0.0688542 * safezoneW;
			h = 0.017037 * safezoneH;
		};
		class SonyRadioCo6 : RscStructuredText {
			idc = 33064;
			text = "";
			onButtonClick = "";
			x = 0.366667 * safezoneW + safezoneX;
			y = 0.322148 * safezoneH + safezoneY;
			w = 0.0688542 * safezoneW;
			h = 0.017037 * safezoneH;
		};
		class SonyRadioCo7 : RscStructuredText {
			idc = 33065;
			text = "";
			onButtonClick = "";
			x = 0.366667 * safezoneW + safezoneX;
			y = 0.407407 * safezoneH + safezoneY;
			w = 0.0688542 * safezoneW;
			h = 0.017037 * safezoneH;
		};
		class SonyRadioCo8 : RscStructuredText {
			idc = 33066;
			text = "";
			onButtonClick = "";
			x = 0.366667 * safezoneW + safezoneX;
			y = 0.492593 * safezoneH + safezoneY;
			w = 0.0688542 * safezoneW;
			h = 0.017037 * safezoneH;
		};
		class SonyRadioCo9 : RscStructuredText {
			idc = 33067;
			text = "";
			onButtonClick = "";
			x = 0.366667 * safezoneW + safezoneX;
			y = 0.576852 * safezoneH + safezoneY;
			w = 0.0688542 * safezoneW;
			h = 0.017037 * safezoneH;
		};
		class SonyRadioCo10 : RscStructuredText {
			idc = 33068;
			text = "";
			onButtonClick = "";
			x = 0.366667 * safezoneW + safezoneX;
			y = 0.662037 * safezoneH + safezoneY;
			w = 0.0688542 * safezoneW;
			h = 0.017037 * safezoneH;
		};
		class SonyRadioCo11 : RscStructuredText {
			idc = 33069;
			text = "";
			onButtonClick = "";
			x = 0.451041 * safezoneW + safezoneX;
			y = 0.322148 * safezoneH + safezoneY;
			w = 0.0688542 * safezoneW;
			h = 0.017037 * safezoneH;
		};
		class SonyRadioCo12 : RscStructuredText {
			idc = 33070;
			text = "";
			onButtonClick = "";
			x = 0.451041 * safezoneW + safezoneX;
			y = 0.407407 * safezoneH + safezoneY;
			w = 0.0688542 * safezoneW;
			h = 0.017037 * safezoneH;
		};
		class SonyRadioCo13 : RscStructuredText {
			idc = 33071;
			text = "";
			onButtonClick = "";
			x = 0.451041 * safezoneW + safezoneX;
			y = 0.492593 * safezoneH + safezoneY;
			w = 0.0688542 * safezoneW;
			h = 0.017037 * safezoneH;
		};
		class SonyRadioCo14 : RscStructuredText {
			idc = 33072;
			text = "";
			onButtonClick = "";
			x = 0.451041 * safezoneW + safezoneX;
			y = 0.576852 * safezoneH + safezoneY;
			w = 0.0688542 * safezoneW;
			h = 0.017037 * safezoneH;
		};
		class SonyRadioCo15 : RscStructuredText {
			idc = 33073;
			text = "";
			onButtonClick = "";
			x = 0.451041 * safezoneW + safezoneX;
			y = 0.662037 * safezoneH + safezoneY;
			w = 0.0688542 * safezoneW;
			h = 0.017037 * safezoneH;
		};
		class SonyRadioCo16 : RscStructuredText {
			idc = 33074;
			text = "";
			onButtonClick = "";
			x = 0.533854 * safezoneW + safezoneX;
			y = 0.322148 * safezoneH + safezoneY;
			w = 0.0688542 * safezoneW;
			h = 0.017037 * safezoneH;
		};
		class SonyRadioCo17 : RscStructuredText {
			idc = 33075;
			text = "";
			onButtonClick = "";
			x = 0.533854 * safezoneW + safezoneX;
			y = 0.407407 * safezoneH + safezoneY;
			w = 0.0688542 * safezoneW;
			h = 0.017037 * safezoneH;
		};
		class SonyRadioCo18 : RscStructuredText {
			idc = 33076;
			text = "";
			onButtonClick = "";
			x = 0.533854 * safezoneW + safezoneX;
			y = 0.492593 * safezoneH + safezoneY;
			w = 0.0688542 * safezoneW;
			h = 0.017037 * safezoneH;
		};
		class SonyRadioCo19 : RscStructuredText {
			idc = 33077;
			text = "";
			onButtonClick = "";
			x = 0.533854 * safezoneW + safezoneX;
			y = 0.576852 * safezoneH + safezoneY;
			w = 0.0688542 * safezoneW;
			h = 0.017037 * safezoneH;
		};
		class SonyRadioCo20 : RscStructuredText {
			idc = 33078;
			text = "";
			onButtonClick = "";
			x = 0.533854 * safezoneW + safezoneX;
			y = 0.662037 * safezoneH + safezoneY;
			w = 0.0688542 * safezoneW;
			h = 0.017037 * safezoneH;
		};
		class SonyRadioCo21 : RscStructuredText {
			idc = 33079;
			text = "";
			onButtonClick = "";
			x = 0.617708 * safezoneW + safezoneX;
			y = 0.322148 * safezoneH + safezoneY;
			w = 0.0688542 * safezoneW;
			h = 0.017037 * safezoneH;
		};
		class SonyRadioCo22 : RscStructuredText {
			idc = 33080;
			text = "";
			onButtonClick = "";
			x = 0.617708 * safezoneW + safezoneX;
			y = 0.407408 * safezoneH + safezoneY;
			w = 0.0688542 * safezoneW;
			h = 0.017037 * safezoneH;
		};
		class SonyRadioNb1 : RscStructuredText {
			idc = 33081;
			text = "";
			onButtonClick = "";
			x = 0.295312 * safezoneW + safezoneX;
			y = 0.341666 * safezoneH + safezoneY;
			w = 0.230208 * safezoneW;
			h = 0.0207407 * safezoneH;
		};
		class SonyRadioNb2 : RscStructuredText {
			idc = 33082;
			text = "";
			onButtonClick = "";
			x = 0.295312 * safezoneW + safezoneX;
			y = 0.426852 * safezoneH + safezoneY;
			w = 0.230208 * safezoneW;
			h = 0.0207407 * safezoneH;
		};
		class SonyRadioNb3 : RscStructuredText {
			idc = 33083;
			text = "";
			onButtonClick = "";
			x = 0.295312 * safezoneW + safezoneX;
			y = 0.511111 * safezoneH + safezoneY;
			w = 0.230208 * safezoneW;
			h = 0.0207407 * safezoneH;
		};
		class SonyRadioNb4 : RscStructuredText {
			idc = 33084;
			text = "";
			onButtonClick = "";
			x = 0.295312 * safezoneW + safezoneX;
			y = 0.596296 * safezoneH + safezoneY;
			w = 0.230208 * safezoneW;
			h = 0.0207407 * safezoneH;
		};
		class SonyRadioNb5 : RscStructuredText {
			idc = 33085;
			text = "";
			onButtonClick = "";
			x = 0.295312 * safezoneW + safezoneX;
			y = 0.681481 * safezoneH + safezoneY;
			w = 0.230208 * safezoneW;
			h = 0.0207407 * safezoneH;
		};
		class SonyRadioNb6 : RscStructuredText {
			idc = 33086;
			text = "";
			onButtonClick = "";
			x = 0.379166 * safezoneW + safezoneX;
			y = 0.341666 * safezoneH + safezoneY;
			w = 0.230208 * safezoneW;
			h = 0.0207407 * safezoneH;
		};
		class SonyRadioNb7 : RscStructuredText {
			idc = 33087;
			text = "";
			onButtonClick = "";
			x = 0.379166 * safezoneW + safezoneX;
			y = 0.426852 * safezoneH + safezoneY;
			w = 0.230208 * safezoneW;
			h = 0.0207407 * safezoneH;
		};
		class SonyRadioNb8 : RscStructuredText {
			idc = 33088;
			text = "";
			onButtonClick = "";
			x = 0.379166 * safezoneW + safezoneX;
			y = 0.511111 * safezoneH + safezoneY;
			w = 0.230208 * safezoneW;
			h = 0.0207407 * safezoneH;
		};
		class SonyRadioNb9 : RscStructuredText {
			idc = 33089;
			text = "";
			onButtonClick = "";
			x = 0.379166 * safezoneW + safezoneX;
			y = 0.596296 * safezoneH + safezoneY;
			w = 0.230208 * safezoneW;
			h = 0.0207407 * safezoneH;
		};
		class SonyRadioNb10 : RscStructuredText {
			idc = 33090;
			text = "";
			onButtonClick = "";
			x = 0.379166 * safezoneW + safezoneX;
			y = 0.681481 * safezoneH + safezoneY;
			w = 0.230208 * safezoneW;
			h = 0.0207407 * safezoneH;
		};
		class SonyRadioNb11 : RscStructuredText {
			idc = 33091;
			text = "";
			onButtonClick = "";
			x = 0.463542 * safezoneW + safezoneX;
			y = 0.341666 * safezoneH + safezoneY;
			w = 0.230208 * safezoneW;
			h = 0.0207407 * safezoneH;
		};
		class SonyRadioNb12 : RscStructuredText {
			idc = 33092;
			text = "";
			onButtonClick = "";
			x = 0.463542 * safezoneW + safezoneX;
			y = 0.426852 * safezoneH + safezoneY;
			w = 0.230208 * safezoneW;
			h = 0.0207407 * safezoneH;
		};
		class SonyRadioNb13 : RscStructuredText {
			idc = 33093;
			text = "";
			onButtonClick = "";
			x = 0.463542 * safezoneW + safezoneX;
			y = 0.511111 * safezoneH + safezoneY;
			w = 0.230208 * safezoneW;
			h = 0.0207407 * safezoneH;
		};
		class SonyRadioNb14 : RscStructuredText {
			idc = 33094;
			text = "";
			onButtonClick = "";
			x = 0.463542 * safezoneW + safezoneX;
			y = 0.596296 * safezoneH + safezoneY;
			w = 0.230208 * safezoneW;
			h = 0.0207407 * safezoneH;
		};
		class SonyRadioNb15 : RscStructuredText {
			idc = 33095;
			text = "";
			onButtonClick = "";
			x = 0.463542 * safezoneW + safezoneX;
			y = 0.681481 * safezoneH + safezoneY;
			w = 0.230208 * safezoneW;
			h = 0.0207407 * safezoneH;
		};
		class SonyRadioNb16 : RscStructuredText {
			idc = 33096;
			text = "";
			onButtonClick = "";
			x = 0.548437 * safezoneW + safezoneX;
			y = 0.341666 * safezoneH + safezoneY;
			w = 0.230208 * safezoneW;
			h = 0.0207407 * safezoneH;
		};
		class SonyRadioNb17 : RscStructuredText {
			idc = 33097;
			text = "";
			onButtonClick = "";
			x = 0.548437 * safezoneW + safezoneX;
			y = 0.426852 * safezoneH + safezoneY;
			w = 0.230208 * safezoneW;
			h = 0.0207407 * safezoneH;
		};
		class SonyRadioNb18 : RscStructuredText {
			idc = 33098;
			text = "";
			onButtonClick = "";
			x = 0.548437 * safezoneW + safezoneX;
			y = 0.511111 * safezoneH + safezoneY;
			w = 0.230208 * safezoneW;
			h = 0.0207407 * safezoneH;
		};
		class SonyRadioNb19 : RscStructuredText {
			idc = 33099;
			text = "";
			onButtonClick = "";
			x = 0.548437 * safezoneW + safezoneX;
			y = 0.596296 * safezoneH + safezoneY;
			w = 0.230208 * safezoneW;
			h = 0.0207407 * safezoneH;
		};
		class SonyRadioNb20 : RscStructuredText {
			idc = 33100;
			text = "";
			onButtonClick = "";
			x = 0.548437 * safezoneW + safezoneX;
			y = 0.681481 * safezoneH + safezoneY;
			w = 0.230208 * safezoneW;
			h = 0.0207407 * safezoneH;
		};
		class SonyRadioNb21 : RscStructuredText {
			idc = 33101;
			text = "";
			onButtonClick = "";
			x = 0.63125 * safezoneW + safezoneX;
			y = 0.341666 * safezoneH + safezoneY;
			w = 0.230208 * safezoneW;
			h = 0.0207407 * safezoneH;
		};
		class SonyRadioNb22 : RscStructuredText {
			idc = 33102;
			text = "";
			onButtonClick = "";
			x = 0.63125 * safezoneW + safezoneX;
			y = 0.426852 * safezoneH + safezoneY;
			w = 0.230208 * safezoneW;
			h = 0.0207407 * safezoneH;
		};
		class SonyReglagesBtnVolp1 : RscButtonEmpty {
			idc = 33103;
			text = "";
			onButtonClick = "";
			x = 0.353177 * safezoneW + safezoneX;
			y = 0.625222 * safezoneH + safezoneY;
			w = 0.0211458 * safezoneW;
			h = 0.0376296 * safezoneH;
		};
		class SonyReglagesBtnVolm1 : RscButtonEmpty {
			idc = 33104;
			text = "";
			onButtonClick = "";
			x = 0.377605 * safezoneW + safezoneX;
			y = 0.625 * safezoneH + safezoneY;
			w = 0.0211458 * safezoneW;
			h = 0.0376296 * safezoneH;
		};
		class SonyMenuBtnCentral : RscButtonEmpty {
			idc = 33109;
			text = "";
			onButtonClick = "";
			x = 0.675312 * safezoneW + safezoneX;
			y = 0.566 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.088 * safezoneH;
		};
		class SonyContacts : RscPicture {
			idc = 33110;
			text = "\A3PL_Common\GUI\newphone\Sony\Sony_Contacts.paa";
			x = 0.200937 * safezoneW + safezoneX;
			y = 0.027 * safezoneH + safezoneY;
			w = 0.587812 * safezoneW;
			h = 1 * safezoneH;
		};
		class SonyContactsAdd : RscButtonEmpty {
			idc = 33111;
			text = "";
			x = 0.675312 * safezoneW + safezoneX;
			y = 0.291 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class SonyContactsTexte : RscStructuredText {
			idc = 33112;
			text = "";
			x = 0.310156 * safezoneW + safezoneX;
			y = 0.345 * safezoneH + safezoneY;
			w = 0.408959 * safezoneW;
			h = 0.0466666 * safezoneH;
		};
		class SonyContactsList : RscListBox {
			idc = 33113;
			text = "";
			colorText[] = {0,0,0,1};
			colorSelect[] = {0,0,0,1};
			colorSelect2[] = {0,0,0,1};
			colorBackground[] = {0,0,0,0};
			colorSelectBackground[] = {0.639,0.667,0.706,0.8};
			colorSelectBackground2[] = {0.639,0.667,0.706,0.8};
			font = "HelveticaLTLight";
			sizeEx = 0.065;
			x = 0.267709 * safezoneW + safezoneX;
			y = 0.386111 * safezoneH + safezoneY;
			w = 0.453751 * safezoneW;
			h = 0.338333 * safezoneH;
		};
		class SonyFiche : RscPicture {
			idc = 33114;
			text = "\A3PL_Common\GUI\newphone\Sony\Sony_Fiche.paa";
			x = 0.200937 * safezoneW + safezoneX;
			y = 0.027 * safezoneH + safezoneY;
			w = 0.587812 * safezoneW;
			h = 1 * safezoneH;
		};
		class SonyFicheName : RscStructuredText {
			idc = 33115;
			text = "";
			x = 0.269792 * safezoneW + safezoneX;
			y = 0.333334 * safezoneH + safezoneY;
			w = 0.449063 * safezoneW;
			h = 0.041111 * safezoneH;
		};
		class SonyFicheNum : RscStructuredText {
			idc = 33116;
			text = "";
			x = 0.270051 * safezoneW + safezoneX;
			y = 0.395889 * safezoneH + safezoneY;
			w = 0.136563 * safezoneW;
			h = 0.0318518 * safezoneH;
		};
		class SonyFicheBtnSms : RscButtonEmpty {
			idc = 33117;
			text = "";
			x = 0.269791 * safezoneW + safezoneX;
			y = 0.538889 * safezoneH + safezoneY;
			w = 0.0646875 * safezoneW;
			h = 0.0272222 * safezoneH;
		};
		class SonyFicheBtnAppel : RscButtonEmpty {
			idc = 33118;
			text = "";
			x = 0.269791 * safezoneW + safezoneX;
			y = 0.571296 * safezoneH + safezoneY;
			w = 0.0646875 * safezoneW;
			h = 0.0272222 * safezoneH;
		};
		class SonyFicheBtnSupprimer : RscButtonEmpty {
			idc = 33119;
			text = "";
			x = 0.26875 * safezoneW + safezoneX;
			y = 0.693519 * safezoneH + safezoneY;
			w = 0.0646875 * safezoneW;
			h = 0.0272222 * safezoneH;
		};

		class SonyCentral : RscPicture {
			idc = 33120;
			text = "\A3PL_Common\GUI\newphone\Sony\Sony_Central.paa";
			x = 0.200937 * safezoneW + safezoneX;
			y = 0.027 * safezoneH + safezoneY;
			w = 0.587812 * safezoneW;
			h = 1 * safezoneH;
		};
		class SonyCentralList : RscListBox {
			idc = 33121;
			text = "";
			colorText[] = {0,0,0,1};
			colorSelect[] = {0,0,0,1};
			colorSelect2[] = {0,0,0,1};
			colorBackground[] = {0,0,0,0};
			colorSelectBackground[] = {0.639,0.667,0.706,0.8};
			colorSelectBackground2[] = {0.639,0.667,0.706,0.8};
			font = "HelveticaLTLight";
			sizeEx = 0.035;
			x = 0.278125 * safezoneW + safezoneX;
			y = 0.298148 * safezoneH + safezoneY;
			w = 0.277708 * safezoneW;
			h = 0.424445 * safezoneH;
		};
		class SonyCentralBtnAppel : RscButtonEmpty {
			idc = 33122;
			text = "";
			x = 0.5875 * safezoneW + safezoneX;
			y = 0.306482 * safezoneH + safezoneY;
			w = 0.102708 * safezoneW;
			h = 0.0337037 * safezoneH;
		};
		class SonyCentralBtnRaf : RscButtonEmpty {
			idc = 33123;
			text = "";
			x = 0.5875 * safezoneW + safezoneX;
			y = 0.35463 * safezoneH + safezoneY;
			w = 0.102708 * safezoneW;
			h = 0.0337037 * safezoneH;
		};
		class SonyNewContact : RscPicture {
			idc = 33125;
			text = "\A3PL_Common\GUI\newphone\Sony\Sony_NewContact.paa";
			x = 0.200937 * safezoneW + safezoneX;
			y = 0.027 * safezoneH + safezoneY;
			w = 0.587812 * safezoneW;
			h = 1 * safezoneH;
		};
		class SonyNewContactAnn : RscButtonEmpty {
			idc = 33126;
			text = "";
			x = 0.666666 * safezoneW + safezoneX;
			y = 0.287037 * safezoneH + safezoneY;
			w = 0.05375 * safezoneW;
			h = 0.0401852 * safezoneH;
		};
		class SonyNewContactAdd : RscButtonEmpty {
			idc = 33127;
			text = "";
			x = 0.275 * safezoneW + safezoneX;
			y = 0.687037 * safezoneH + safezoneY;
			w = 0.05375 * safezoneW;
			h = 0.0401852 * safezoneH;
		};
		class SonyNewContactName : RscEdit {
			idc = 33128;
			text = "";
			colorText[] = {0,0,0,1};
			colorBackground[] = {0,0,0,0};
			font = "HelveticaLTLight";
			sizeEx = 0.035;
			style = 0;
			shadow = 0;
			x = 0.381406 * safezoneW + safezoneX;
			y = 0.335 * safezoneH + safezoneY;
			w = 0.336563 * safezoneW;
			h = 0.0383333 * safezoneH;
		};
		class SonyNewContactNum : RscEdit {
			idc = 33129;
			text = "";
			colorText[] = {0,0,0,1};
			colorBackground[] = {0,0,0,0};
			font = "HelveticaLTLight";
			sizeEx = 0.035;
			style = 0;
			shadow = 0;
			x = 0.392187 * safezoneW + safezoneX;
			y = 0.384259 * safezoneH + safezoneY;
			w = 0.325625 * safezoneW;
			h = 0.0392593 * safezoneH;
		};
		class SonyRadioRaf : RscButtonEmpty {
			idc = 33130;
			text = "";
			x = 0.648958 * safezoneW + safezoneX;
			y = 0.703704 * safezoneH + safezoneY;
			w = 0.063125 * safezoneW;
			h = 0.0346296 * safezoneH;
		};
		class SonyRecents : RscPicture {
			idc = 33131;
			text = "\A3PL_Common\GUI\newphone\Sony\Sony_Recents.paa";
			x = 0.200937 * safezoneW + safezoneX;
			y = 0.027 * safezoneH + safezoneY;
			w = 0.587812 * safezoneW;
			h = 1 * safezoneH;
		};
		class SonyRecentsList : RscListBox {
			idc = 33132;
			text = "";
			colorText[] = {0,0,0,1};
			colorSelect[] = {0,0,0,1};
			colorSelect2[] = {0,0,0,1};
			colorBackground[] = {0,0,0,0};
			colorSelectBackground[] = {0.639,0.667,0.706,0.8};
			colorSelectBackground2[] = {0.639,0.667,0.706,0.8};
			font = "HelveticaLTLight";
			sizeEx = 0.035;
			x = 0.267708 * safezoneW + safezoneX;
			y = 0.330556 * safezoneH + safezoneY;
			w = 0.330556 * safezoneW;
			h = 0.363333 * safezoneH;
		};
		class SonyRecentsVider : RscButtonEmpty {
			idc = 33133;
			text = "";
			x = 0.659844 * safezoneW + safezoneX;
			y = 0.291 * safezoneH + safezoneY;
			w = 0.0593228 * safezoneW;
			h = 0.0367037 * safezoneH;
		};
		class SonyRecentsApp : RscButtonEmpty {
			idc = 33134;
			text = "";
			x = 0.270834 * safezoneW + safezoneX;
			y = 0.702778 * safezoneH + safezoneY;
			w = 0.0593228 * safezoneW;
			h = 0.0367037 * safezoneH;
		};
		class SonyRecentsSms : RscButtonEmpty {
			idc = 33135;
			text = "";
			x = 0.65 * safezoneW + safezoneX;
			y = 0.703704 * safezoneH + safezoneY;
			w = 0.0593228 * safezoneW;
			h = 0.0367037 * safezoneH;
		};
		class SonyAppelRecents : RscButtonEmpty {
			idc = 33136;
			text = "";
			x = 0.666407 * safezoneW + safezoneX;
			y = 0.70737 * safezoneH + safezoneY;
			w = 0.0553125 * safezoneW;
			h = 0.0346296 * safezoneH;
		};
		class SonyReglagesFg : RscButtonEmpty {
			idc = 33137;
			text = "";
			x = 0.598958 * safezoneW + safezoneX;
			y = 0.625 * safezoneH + safezoneY;
			w = 0.02875 * safezoneW;
			h = 0.0161111 * safezoneH;
		};
		class SonyReglagesFm : RscButtonEmpty {
			idc = 33138;
			text = "";
			x = 0.628125 * safezoneW + safezoneX;
			y = 0.625 * safezoneH + safezoneY;
			w = 0.02875 * safezoneW;
			h = 0.0161111 * safezoneH;
		};
		class SonyReglagesFd : RscButtonEmpty {
			idc = 33139;
			text = "";
			x = 0.657812 * safezoneW + safezoneX;
			y = 0.625 * safezoneH + safezoneY;
			w = 0.02875 * safezoneW;
			h = 0.0161111 * safezoneH;
		};
		class SonyReglagesF2g : RscButtonEmpty {
			idc = 33140;
			text = "";
			x = 0.598958 * safezoneW + safezoneX;
			y = 0.658333 * safezoneH + safezoneY;
			w = 0.02875 * safezoneW;
			h = 0.0161111 * safezoneH;
		};
		class SonyReglagesF2m : RscButtonEmpty {
			idc = 33141;
			text = "";
			x = 0.628125 * safezoneW + safezoneX;
			y = 0.658333 * safezoneH + safezoneY;
			w = 0.02875 * safezoneW;
			h = 0.0161111 * safezoneH;
		};
		class SonyReglagesF2d : RscButtonEmpty {
			idc = 33142;
			text = "";
			x = 0.657812 * safezoneW + safezoneX;
			y = 0.658333 * safezoneH + safezoneY;
			w = 0.02875 * safezoneW;
			h = 0.0161111 * safezoneH;
		};
		class SonyMessages : RscPicture {
			idc = 33143;
			text = "\A3PL_Common\GUI\newphone\Sony\Sony_SmsList.paa";
			x = 0.200937 * safezoneW + safezoneX;
			y = 0.027 * safezoneH + safezoneY;
			w = 0.587812 * safezoneW;
			h = 1 * safezoneH;
		};
		class SonyMessagesLb : RscListBox {
			idc = 33144;
			text = "";
			colorText[] = {0,0,0,1};
			colorSelect[] = {0,0,0,1};
			colorSelect2[] = {0,0,0,1};
			colorBackground[] = {0,0,0,0};
			colorSelectBackground[] = {0.639,0.667,0.706,0.8};
			colorSelectBackground2[] = {0.639,0.667,0.706,0.8};
			font = "HelveticaLTLight";
			sizeEx = 0.035;
			onLBSelChanged = "[] call A3PL_Phone_lbChangedSmsSony;";
			x = 0.267708 * safezoneW + safezoneX;
			y = 0.32963 * safezoneH + safezoneY;
			w = 0.45375 * safezoneW;
			h = 0.155926 * safezoneH;
		};
		class SonyMessagesTexte : RscStructuredText {
			idc = 33145;
			text = "";
			x = 0.267708 * safezoneW + safezoneX;
			y = 0.484259 * safezoneH + safezoneY;
			w = 0.453229 * safezoneW;
			h = 0.210556 * safezoneH;
		};
		class SonyMessagesBtnRep : RscButtonEmpty {
			idc = 33146;
			text = "";
			x = 0.271042 * safezoneW + safezoneX;
			y = 0.699963 * safezoneH + safezoneY;
			w = 0.0641667 * safezoneW;
			h = 0.0411111 * safezoneH;
		};
		class SonyMessagesBtnSup : RscButtonEmpty {
			idc = 33147;
			text = "";
			x = 0.651042 * safezoneW + safezoneX;
			y = 0.7 * safezoneH + safezoneY;
			w = 0.0641667 * safezoneW;
			h = 0.0411111 * safezoneH;
		};
		class SonyMessagesBtnNew : RscButtonEmpty {
			idc = 33148;
			text = "";
			x = 0.669271 * safezoneW + safezoneX;
			y = 0.287037 * safezoneH + safezoneY;
			w = 0.0511459 * safezoneW;
			h = 0.042037 * safezoneH;
		};
		class SonyNewMessages : RscPicture {
			idc = 33149;
			text = "\A3PL_Common\GUI\newphone\Sony\Sony_NewSms.paa";
			x = 0.200937 * safezoneW + safezoneX;
			y = 0.027 * safezoneH + safezoneY;
			w = 0.587812 * safezoneW;
			h = 1 * safezoneH;
		};
		class SonyNewMessagesNameTexte : RscStructuredText {
			idc = 33150;
			text = "";
			style = 0;
			x = 0.295312 * safezoneW + safezoneX;
			y = 0.334259 * safezoneH + safezoneY;
			w = 0.160521 * safezoneW;
			h = 0.0355555 * safezoneH;
		};
		class SonyNewMessagesNumEdit : RscEdit {
			idc = 33151;
			text = "";
			colorText[] = {0,0,0,1};
			colorBackground[] = {0,0,0,0};
			font = "HelveticaLTLight";
			sizeEx = 0.05;
			style = 0;
			shadow = 0;
			x = 0.295312 * safezoneW + safezoneX;
			y = 0.334259 * safezoneH + safezoneY;
			w = 0.160521 * safezoneW;
			h = 0.0355555 * safezoneH;
		};
		class SonyNewMessagesSmsEdit : RscEdit {
			idc = 33152;
			text = "";
			colorText[] = {0,0,0,1};
			colorBackground[] = {0,0,0,0};
			font = "HelveticaLTLight";
			sizeEx = 0.035;
			style = 16;
			shadow = 0;
			x = 0.277239 * safezoneW + safezoneX;
			y = 0.464222 * safezoneH + safezoneY;
			w = 0.435521 * safezoneW;
			h = 0.267964 * safezoneH;
		};
		class SonyNewMessagesBtnAnn : RscButtonEmpty {
			idc = 33153;
			text = "";
			x = 0.669271 * safezoneW + safezoneX;
			y = 0.287037 * safezoneH + safezoneY;
			w = 0.0511459 * safezoneW;
			h = 0.042037 * safezoneH;
		};
		class SonyNewMessagesBtnSend : RscButtonEmpty {
			idc = 33154;
			text = "";
			x = 0.661458 * safezoneW + safezoneX;
			y = 0.426704 * safezoneH + safezoneY;
			w = 0.0511458 * safezoneW;
			h = 0.0355555 * safezoneH;
		};
		class SonyClefs : RscPicture {
			idc = 45158;
			text = "\A3PL_Common\GUI\newphone\Sony\Sony_Clefs.paa";
			x = 0.200937 * safezoneW + safezoneX;
			y = 0.027 * safezoneH + safezoneY;
			w = 0.587812 * safezoneW;
			h = 1 * safezoneH;
		};
		class SonyClefsBtnGive: RscButtonEmpty
		{
			idc = 45159;
			x = 0.464583 * safezoneW + safezoneX;
			y = 0.676998 * safezoneH + safezoneY;
			w = 0.061875 * safezoneW;
			h = 0.0219917 * safezoneH;
		};
		class SonyClefsListKeys: RscListbox
		{
			idc = 45160;
			x = 0.267916 * safezoneW + safezoneX;
			y = 0.367133 * safezoneH + safezoneY;
			w = 0.458906 * safezoneW;
			h = 0.296888 * safezoneH;
		};
		class SonyClefsComboPlayersList: RscCombo
		{
			idc = 45163;
			x = 0.364063 * safezoneW + safezoneX;
			y = 0.676997 * safezoneH + safezoneY;
			w = 0.0979687 * safezoneW;
			h = 0.0219917 * safezoneH;
		};
		class SonyStations : RscPicture {
			idc = 45161;
			text = "\A3PL_Common\GUI\newphone\Sony\Sony_Stations.paa";
			x = 0.200937 * safezoneW + safezoneX;
			y = 0.027 * safezoneH + safezoneY;
			w = 0.587812 * safezoneW;
			h = 1 * safezoneH;
		};
		class SonyStationsList: RscControlsGroup
		{
			idc = 45162;
			x = 0.268437 * safezoneW + safezoneX;
			y = 0.366216 * safezoneH + safezoneY;
			w = 0.458906 * safezoneW;
			h = 0.37386 * safezoneH;
			class VScrollbar
			{
				width = 0.004 * safezoneW;
				height = 0;
				autoScrollSpeed = -1;
				autoScrollDelay = 5;
				autoScrollRewind = 0;
				shadow = 0;
				scrollSpeed = 0.1;
				color[] = {1,0,0,0.6};
				colorActive[] = {0.5,0.5,1,1};
				colorDisabled[] = {1,1,1,0.3};
				thumb = "#(argb,8,8,3)color(0,0,0,0.25)";
				arrowEmpty = "#(argb,8,8,3)color(0,0,0,0.1)";
				arrowFull = "#(argb,8,8,3)color(0,0,0,0.1)";
				border = "#(argb,8,8,3)color(0,0,0,0.1)";
			};
			class HScrollbar : HScrollbar{height = 0;};
			class Controls{};
		};
		class SonyNotes: RscPicture
		{
			idc = 45164;
			text = "\A3PL_Common\GUI\newphone\Sony\Sony_Notes.paa";
			x = 0.200937 * safezoneW + safezoneX;
			y = 0.027 * safezoneH + safezoneY;
			w = 0.587812 * safezoneW;
			h = 1 * safezoneH;
		};
		class SonyNotes_Home_btncreatenewnote: RscButton
		{
			idc = 45165;
			text = "STR_UI_iPhone_CreateNote"; 
			x = 0.406771 * safezoneW + safezoneX;
			y = 0.356934 * safezoneH + safezoneY;
			w = 0.175313 * safezoneW;
			h = 0.0219917 * safezoneH;
		};
		class SonyNotes_Home_noteslistgroup: RscControlsGroup
		{
			idc = 45166;
			x = 0.269271 * safezoneW + safezoneX;
			y = 0.384447 * safezoneH + safezoneY;
			w = 0.45375 * safezoneW;
			h = 0.351868 * safezoneH;
			class VScrollbar
			{
				width = 0.004 * safezoneW;
				height = 0;
				autoScrollSpeed = -1;
				autoScrollDelay = 5;
				autoScrollRewind = 0;
				shadow = 0;
				scrollSpeed = 0.1;
				color[] = {1,0,0,0.6};
				colorActive[] = {0.5,0.5,1,1};
				colorDisabled[] = {1,1,1,0.3};
				thumb = "#(argb,8,8,3)color(0,0,0,0.25)";
				arrowEmpty = "#(argb,8,8,3)color(0,0,0,0.1)";
				arrowFull = "#(argb,8,8,3)color(0,0,0,0.1)";
				border = "#(argb,8,8,3)color(0,0,0,0.1)";
			};
			class HScrollbar : HScrollbar{height = 0;};
			class Controls{};
		};

		class SonyNotes_CreateNote_BtnCreate: RscButton
		{
			idc = 45167;
			text = "STR_UI_iPhone_CreateNewNote";
			x = 0.642136 * safezoneW + safezoneX;
			y = 0.548605 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.0219917 * safezoneH;
		};
		class SonyNotes_CreateNote_Title: RscEdit
		{
			idc = 45168;
			text = "STR_UI_iPhone_NoteTitle"; 
			x = 0.271354 * safezoneW + safezoneX;
			y = 0.385364 * safezoneH + safezoneY;
			w = 0.108281 * safezoneW;
			h = 0.0329876 * safezoneH;
			maxChars = 10;
			onMouseButtonClick = "_text = ctrlText 45168; if (_text isEqualTo ""STR_UI_iPhone_NoteTitle"") then {ctrlSetText [45168,""""]};";
		};
		class SonyNotes_CreateNote_Notebox: RscEdit
		{
			idc = 45169;
			text = "STR_UI_iPhone_WriteNoteContentHere"; 
			x = 0.271354 * safezoneW + safezoneX;
			y = 0.422965 * safezoneH + safezoneY;
			w = 0.438281 * safezoneW;
			h = 0.120955 * safezoneH;
			maxChars = 396;
			onMouseButtonClick = "_text = ctrlText 45169; if (_text isEqualTo ""STR_UI_iPhone_WriteNoteContentHere"") then {ctrlSetText [45169,""""]};";
		};
		class SonyNotes_GiveNote_Playerlist: RscCombo
		{
			idc = 45170;
			x = 0.407292 * safezoneW + safezoneX;
			y = 0.356934 * safezoneH + safezoneY;
			w = 0.175313 * safezoneW;
			h = 0.0219917 * safezoneH;
		};
		class SonyNotes_GiveNote_BtnGive: RscButton
		{
			idc = 45171;
			text = "STR_UI_iPhone_GiveCopyNote"; 
			x = 0.407292 * safezoneW + safezoneX;
			y = 0.382613 * safezoneH + safezoneY;
			w = 0.175313 * safezoneW;
			h = 0.0219917 * safezoneH;
		};
		class SonyNotes_EditNote_Title: RscEdit
		{
			idc = 45172;
			text = "STR_UI_iPhone_NoteTitle"; 
			x = 0.270833 * safezoneW + safezoneX;
			y = 0.378945 * safezoneH + safezoneY;
			w = 0.0979687 * safezoneW;
			h = 0.0329876 * safezoneH;
			maxChars = 10;
			onMouseButtonClick = "_text = ctrlText 45172; if (_text isEqualTo ""STR_UI_iPhone_NoteTitle"") then {ctrlSetText [45172,""""]};";
		};
		class SonyNotes_EditNote_Notebox: RscEdit
		{
			idc = 45173;
			text = "STR_UI_iPhone_WriteNoteContentHere";
			x = 0.270833 * safezoneW + safezoneX;
			y = 0.418379 * safezoneH + safezoneY;
			w = 0.443438 * safezoneW;
			h = 0.18693 * safezoneH;
			maxChars = 396;
			onMouseButtonClick = "_text = ctrlText 45173; if (_text isEqualTo ""STR_UI_iPhone_WriteNoteContentHere"") then {ctrlSetText [45173,""""]};";
		};
		class SonyNotes_EditNote_BtnSave: RscButton
		{
			idc = 45174;
			text = "Sauvegarder";
			x = 0.605365 * safezoneW + safezoneX;
			y = 0.61005 * safezoneH + safezoneY;
			w = 0.108281 * safezoneW;
			h = 0.0329876 * safezoneH;
		};
		class SonyNotes_EditNote_BtnGive: RscButton
		{
			idc = 45175;
			text = "Donner une copie"; 
			x = 0.49375 * safezoneW + safezoneX;
			y = 0.610051 * safezoneH + safezoneY;
			w = 0.108281 * safezoneW;
			h = 0.0329876 * safezoneH;
			action = "_name = ctrlText 45172; _text = ctrlText 45173; [_name,_text] call A3PL_Phone_SonySD_appGiveNote;";
		};

		class SonyTwitter: RscPicture
		{
			idc = 45176;
			text = "\A3PL_Common\GUI\newphone\Sony\Sony_Twitter.paa";
			x = 0.200937 * safezoneW + safezoneX;
			y = 0.027 * safezoneH + safezoneY;
			w = 0.587812 * safezoneW;
			h = 1 * safezoneH;
		};
		class SonyTwitter_TwitterListGroup: RscControlsGroup
		{
			idc = 45177;
			x = 0.272109 * safezoneW + safezoneX;
			y = 0.363844 * safezoneH + safezoneY;
			w = 0.443262 * safezoneW;
			h = 0.329945 * safezoneH;
			class VScrollbar
			{
				width = 0.004 * safezoneW;
				height = 0;
				autoScrollSpeed = -1;
				autoScrollDelay = 5;
				autoScrollRewind = 0;
				shadow = 0;
				scrollSpeed = 0.1;
				color[] = {1,0,0,0.6};
				colorActive[] = {0.5,0.5,1,1};
				colorDisabled[] = {1,1,1,0.3};
				thumb = "#(argb,8,8,3)color(0,0,0,0.25)";
				arrowEmpty = "#(argb,8,8,3)color(0,0,0,0.1)";
				arrowFull = "#(argb,8,8,3)color(0,0,0,0.1)";
				border = "#(argb,8,8,3)color(0,0,0,0.1)";
			};
			class HScrollbar : HScrollbar{height = 0;};
			class Controls{};
		};
		class SonyTwitter_BtnNewTweet: RscButton
		{
			idc = 45178;
			text = "NOUVEAU TWEET";
			x = 0.631337 * safezoneW + safezoneX;
			y = 0.706266 * safezoneH + safezoneY;
			w = 0.0824674 * safezoneW;
			h = 0.0329945 * safezoneH;
		};
		class SonyTwitter_WritePost: RscEdit
		{
			idc = 45179;
			x = 0.272109 * safezoneW + safezoneX;
			y = 0.363844 * safezoneH + safezoneY;
			w = 0.443262 * safezoneW;
			h = 0.329945 * safezoneH;
			style = "16";
			text = "";
            sizeEx = 0.015 * safezoneW;
            colorText[] = {1,1,1,1};
            colorBackground[] = {0,0,0,0};
            shadow = 0;
            maxChars = 100;
		};
		class SonyTwitter_BtnPostNewTweet: RscButton
		{
			idc = 45180;
			text = "ENVOYER LE TWEET"; 
			x = 0.621028 * safezoneW + safezoneX;
			y = 0.706266 * safezoneH + safezoneY;
			w = 0.0927759 * safezoneW;
			h = 0.0329945 * safezoneH;
		};

		class HomeBtn : RscButtonEmpty {
			idc = 33000;
			text = "";
			onButtonClick = "uiNamespace setVariable ['sony',0]; [] call A3PL_Phone_menuSony;";
			x = 0.48401 * safezoneW + safezoneX;
			y = 0.744778 * safezoneH + safezoneY;
			w = 0.0209375 * safezoneW;
			h = 0.0235186 * safezoneH;
		};
	};
};

class Sony_Tweet: RscControlsGroup
{
    idc = 02135;
    x = 0;
    y = 0;
    w = safeZoneW * 0.443262;
    h = safeZoneH * 0.052;
    class Controls
    {
        class Sony_TweetName: RscStructuredText
        {
            idc = 98301;
            style = ST_LEFT;
            x = 0;
            y = 0;
            w = safeZoneW * 0.443261;
            h = safeZoneH * 0.02;
            text = "";
            sizeEx = 0.02 * safezoneW;
            colorText[] = {1,1,1,1};
            shadow = 0;
        };
        class Sony_Tweet: RscStructuredText
        {
            idc = 98302;
			style = 0;
            x = 0;
            y = 0.02 * safezoneW;
            w = safeZoneW * 0.443261;
            h = safeZoneH * 0.018;
            text = "";
            sizeEx = 0.016 * safezoneW;
            colorText[] = {1,1,1,1};
            shadow = 0;
        };
        class Separator: RscText
        {
            idc = 98303;
            style = ST_HUD_BACKGROUND;
            x = 0;
            y = (0.02 * safezoneW) + (0.018 * safezoneW);
            w = safeZoneW * 0.443261;
            h = safeZoneH * 0.001;
            colorBackground[] = {0.737,0.733,0.733,1};
        };
    };
};

class Sony_Details_Fuel: RscControlsGroup
{
	idc = -1;
	x = 0;
	y = 0;
	w = safeZoneW * 0.135;
	h = safeZoneH * 0.0733333;
	class Controls
	{
		class Sony_fuelStationName: RscText
		{
			idc = 98002;
			style = ST_LEFT;
			x = 0;
			y = 0;
			w = safeZoneW * 0.135;
			h = safeZoneH * 0.02;
			text = "";
			sizeEx = 0.016 * safezoneW;
			colorText[] = {1,1,1,1};
			shadow = 0;
		};
		class Sony_petrol: RscText
		{
			idc = 98003;
			style = ST_LEFT;
			x = 0;
			y = 0.02 * safezoneW;
			w = safeZoneW * 0.135;
			h = safeZoneH * 0.018;
			text = "";
			sizeEx = 0.014 * safezoneW;
			colorText[] = {0.737,0.733,0.733,1};
			shadow = 0;
		};
		class Sony_cost: RscText
		{
			idc = 98004;
			style = ST_LEFT;
			x = 0;
			y = 0.036 * safezoneW;
			w = safeZoneW * 0.135;
			h = safeZoneH * 0.018;
			text = "";
			sizeEx = 0.014 * safezoneW;
			colorText[] = {0.737,0.733,0.733,1};
			shadow = 0;
		};
	};
};

class Sony_Details_Notes: RscControlsGroup
{
	idc = -1;
	x = 0;
	y = 0;
	w = safeZoneW * 0.170156;
	h = safeZoneH * 0.03;
	class Controls
	{
		class Sony_notesName: RscText
		{
			idc = 98002;
			style = ST_LEFT;
			x = 0;
			y = 0;
			w = safeZoneW * 0.170156;
			h = safeZoneH * 0.02;
			text = "";
			sizeEx = 0.016 * safezoneW;
			colorText[] = {1,1,1,1};
			shadow = 0;
		};
	};
};