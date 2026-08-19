class A3PL_iPhoneMenu_Dialog {
	idd = 56400;
	name= "A3PL_iPhoneMenu_Dialog";
	onLoad = "uiNamespace setVariable ['iphonemenu',0]";
	movingEnable = true;
	enableSimulation = false;
	class controlsBackground {};

	class controls {
		class bg1 : RscPicture {
			idc = 564001;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_fond_1.paa";
			x = 0.447657 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.455496 * safezoneW;
			h = 0.767101 * safezoneH;
		};
		class bg2 : RscPicture {
			idc = 564002;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_fond_2.paa";
			x = 0.447657 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.455496 * safezoneW;
			h = 0.767101 * safezoneH;
		};
		class bg3 : RscPicture {
			idc = 564003;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_fond_3.paa";
			x = 0.447657 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.455496 * safezoneW;
			h = 0.767101 * safezoneH;
		};
		class bg4 : RscPicture {
			idc = 564004;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_fond_4.paa";
			x = 0.447657 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.455496 * safezoneW;
			h = 0.767101 * safezoneH;
		};
		class bg5 : RscPicture {
			idc = 564005;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_fond_5.paa";
			x = 0.447657 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.455496 * safezoneW;
			h = 0.767101 * safezoneH;
		};
		class bg6 : RscPicture {
			idc = 564006;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_fond_6.paa";
			x = 0.447657 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.455496 * safezoneW;
			h = 0.767101 * safezoneH;
		};
		class bg7 : RscPicture {
			idc = 564007;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_fond_7.paa";
			x = 0.447657 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.455496 * safezoneW;
			h = 0.767101 * safezoneH;
		};
		class bg8 : RscPicture {
			idc = 564008;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_fond_8.paa";
			x = 0.447657 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.455496 * safezoneW;
			h = 0.767101 * safezoneH;
		};
		class bg9 : RscPicture {
			idc = 564009;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_fond_9.paa";
			x = 0.447657 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.455496 * safezoneW;
			h = 0.767101 * safezoneH;
		};
		class bg10 : RscPicture {
			idc = 564010;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_fond_10.paa";
			x = 0.447657 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.455496 * safezoneW;
			h = 0.767101 * safezoneH;
		};
		class menu1sim : RscPicture {
			idc = 56401;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_iPhone_1.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu1btntel : RscButtonEmpty {
			idc = 564011;
			text = "";
			onButtonClick = "";
			x = 0.595833 * safezoneW + safezoneX;
			y = 0.900926 * safezoneH + safezoneY;
			w = 0.0291407 * safezoneW;
			h = 0.0494443 * safezoneH;
		};
		class menu1btnsms : RscButtonEmpty {
			idc = 564012;
			text = "";
			onButtonClick = "";
			x = 0.639687 * safezoneW + safezoneX;
			y = 0.900167 * safezoneH + safezoneY;
			w = 0.029922 * safezoneW;
			h = 0.0501388 * safezoneH;
		};
		class menu1btncontacts : RscButtonEmpty {
			idc = 564013;
			text = "";
			onButtonClick = "";
			x = 0.727578 * safezoneW + safezoneX;
			y = 0.900861 * safezoneH + safezoneY;
			w = 0.0291407 * safezoneW;
			h = 0.0501388 * safezoneH;
		};
		class menu1btnreglages : RscButtonEmpty {
			idc = 564014;
			text = "";
			onButtonClick = "";
			x = 0.682656 * safezoneW + safezoneX;
			y = 0.900167 * safezoneH + safezoneY;
			w = 0.0295313 * safezoneW;
			h = 0.0501388 * safezoneH;
		};
		class menu1btnstation: RscButtonEmpty
		{
			idc = 1600;
			text = "";
			onButtonClick = "";
			x = 0.595833 * safezoneW + safezoneX;
			y = 0.351852 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.055 * safezoneH;
		};
		class menu1btnbank: RscButtonEmpty
		{
			idc = 1601;
			text = "";
			onButtonClick = "";
			x = 0.639063 * safezoneW + safezoneX;
			y = 0.351852 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.055 * safezoneH;
		};
		class menu1btnusine: RscButtonEmpty
		{
			idc = 1602;
			text = "";
			onButtonClick = "";
			x = 0.68177 * safezoneW + safezoneX;
			y = 0.351852 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.055 * safezoneH;
		};
		class menu1btntwitter: RscButtonEmpty
		{
			idc = 1603;
			text = "";
			onButtonClick = "";
			x = 0.595833 * safezoneW + safezoneX;
			y = 0.431481 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.055 * safezoneH;
		};
		class menu1btngang: RscButtonEmpty
		{
			idc = 1604;
			text = "";
			onButtonClick = "";
			x = 0.639063 * safezoneW + safezoneX;
			y = 0.430555 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.055 * safezoneH;
		};
		class menu1btnuber: RscButtonEmpty
		{
			idc = 1605;
			text = "";
			onButtonClick = "";
			x = 0.68177 * safezoneW + safezoneX;
			y = 0.430555 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.055 * safezoneH;
		};
		class menu1btnmaisons: RscButtonEmpty
		{
			idc = 1606;
			text = "";
			onButtonClick = "";
			x = 0.724479 * safezoneW + safezoneX;
			y = 0.430555 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.055 * safezoneH;
		};
		class menu1btnnotes: RscButtonEmpty
		{
			idc = 1607;
			text = "";
			onButtonClick = "";
			x = 0.595834 * safezoneW + safezoneX;
			y = 0.511112 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.055 * safezoneH;
		};
		class menu1btnclefs: RscButtonEmpty
		{
			idc = 1608;
			text = "";
			onButtonClick = "";
			x = 0.639062 * safezoneW + safezoneX;
			y = 0.510185 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.055 * safezoneH;
		};
		class menu1btnexp: RscButtonEmpty
		{
			idc = 1609;
			text = "";
			onButtonClick = "";
			x = 0.682292 * safezoneW + safezoneX;
			y = 0.511112 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.055 * safezoneH;
		};
		class menu1btnannonces: RscButtonEmpty
		{
			idc = 1610;
			text = "";
			onButtonClick = "";
			x = 0.724479 * safezoneW + safezoneX;
			y = 0.511111 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.055 * safezoneH;
		};
		class menu1btnfactures: RscButtonEmpty
		{
			idc = 1611;
			text = "";
			onButtonClick = "";
			x = 0.595833 * safezoneW + safezoneX;
			y = 0.587037 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.055 * safezoneH;
		};
		class menu1btnimportexport: RscButtonEmpty
		{
			idc = 1612;
			text = "";
			onButtonClick = "";
			x = 0.639354 * safezoneW + safezoneX;
			y = 0.588322 * safezoneH + safezoneY;
			w = 0.0309332 * safezoneW;
			h = 0.0549793 * safezoneH;
		};
		class menu1btnfishjobs: RscButtonEmpty
		{
			idc = 1613;
			text = "";
			onButtonClick = "";
			x = 0.682971 * safezoneW + safezoneX;
			y = 0.588851 * safezoneH + safezoneY;
			w = 0.0309253 * safezoneW;
			h = 0.0550114 * safezoneH;
		};
		class menu1btnachievements: RscButtonEmpty
		{
			idc = 1614;
			text = "";
			onButtonClick = "";
			x = 0.725521 * safezoneW + safezoneX;
			y = 0.58789 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.0549895 * safezoneH;
		};
		class menu1nosim : RscPicture {
			idc = 56402;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_iPhone_2.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu1nosimOK : RscButtonEmpty {
			idc = 564021;
			text = "";
			onButtonClick = "closeDialog 0;";
			x = 0.605469 * safezoneW + safezoneX;
			y = 0.65075 * safezoneH + safezoneY;
			w = 0.139949 * safezoneW;
			h = 0.0478148 * safezoneH;
		};
		class menu1appelentrant : RscPicture {
			idc = 56403;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_iPhone_4.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu1appel : RscPicture {
			idc = 56404;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_iPhone_5.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu1Name : RscStructuredText {
			idc = 564041;
			text = "";
			x = 0.581015 * safezoneW + safezoneX;
			y = 0.32986 * safezoneH + safezoneY;
			w = 0.18875 * safezoneW;
			h = 0.0495556 * safezoneH;
		};
		class menu1Num : RscStructuredText {
			idc = 564042;
			text = "";
			x = 0.606718 * safezoneW + safezoneX;
			y = 0.375 * safezoneH + safezoneY;
			w = 0.137084 * safezoneW;
			h = 0.0320742 * safezoneH;
		};
		class menu1Time : RscStructuredText {
			idc = 564043;
			text = "";
			x = 0.65151 * safezoneW + safezoneX;
			y = 0.475231 * safezoneH + safezoneY;
			w = 0.0473709 * safezoneW;
			h = 0.0228149 * safezoneH;
		};
		class menu1rouge : RscButtonEmpty {
			idc = 564044;
			text = "";
			x = 0.611094 * safezoneW + safezoneX;
			y = 0.812972 * safezoneH + safezoneY;
			w = 0.036693 * safezoneW;
			h = 0.0626297 * safezoneH;
		};
		class menu1vert : RscButtonEmpty {
			idc = 564045;
			text = "";
			x = 0.701328 * safezoneW + safezoneX;
			y = 0.812972 * safezoneH + safezoneY;
			w = 0.0374742 * safezoneW;
			h = 0.0626297 * safezoneH;
		};
		class menu1rouge2 : RscButtonEmpty {
			idc = 564046;
			text = "";
			x = 0.657578 * safezoneW + safezoneX;
			y = 0.8095 * safezoneH + safezoneY;
			w = 0.0363023 * safezoneW;
			h = 0.0619353 * safezoneH;
		};
		class menu1volp : RscButtonEmpty {
			idc = 564048;
			text = "";
			x = 0.658358 * safezoneW + safezoneX;
			y = 0.547001 * safezoneH + safezoneY;
			w = 0.0359116 * safezoneW;
			h = 0.0612407 * safezoneH;
		};
		class menu1volm : RscButtonEmpty {
			idc = 564049;
			text = "";
			x = 0.709139  * safezoneW + safezoneX;
			y = 0.547695 * safezoneH + safezoneY;
			w = 0.035521 * safezoneW;
			h = 0.0605463 * safezoneH;
		};
		class menu2telephone : RscPicture {
			idc = 56405;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_iPhone_3.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu2btnappel : RscButtonEmpty {
			idc = 564051;
			text = "";
			x = 0.657293 * safezoneW + safezoneX;
			y = 0.778593 * safezoneH + safezoneY;
			w = 0.0355211 * safezoneW;
			h = 0.0603147 * safezoneH;
		};
		class menu2numedit : RscEdit {
			idc = 564052;
			text = "";
			style = 0;
			colorBackground[] = {1,1,1,1};
			colorText[] = {0,0,0,1};
			shadow = 0;
			sizeEx = 0.05;
			x = 0.609115 * safezoneW + safezoneX;
			y = 0.405093 * safezoneH + safezoneY;
			w = 0.126667 * safezoneW;
			h = 0.0373982 * safezoneH;
		};
		class menu3contacts : RscPicture {
			idc = 56406;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_iPhone_6.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu3contactslist : RscListBox {
			idc = 564061;
			text = "";
			colorText[] = {1,1,1,1};
			colorSelect[] = {1,1,1,1};
			colorSelect2[] = {1,1,1,1};
			colorBackground[] = {0,0,0,0};
			colorSelectBackground[] = {1,1,1,0.22};
			colorSelectBackground2[] = {1,1,1,0.22};
			font = "HelveticaLTLight";
			sizeEx = 0.065;
			x = 0.588906 * safezoneW + safezoneX;
			y = 0.406722 * safezoneH + safezoneY;
			w = 0.17276 * safezoneW;
			h = 0.544 * safezoneH;
		};
		class menu3Name : RscStructuredText {
			idc = 564062;
			text = "";
			x = 0.627396 * safezoneW + safezoneX;
			y = 0.421148 * safezoneH + safezoneY;
			w = 0.134479 * safezoneW;
			h = 0.0262963 * safezoneH;
		};
		class menu3Num : RscStructuredText {
			idc = 564063;
			text = "";
			x = 0.649532 * safezoneW + safezoneX;
			y = 0.3755 * safezoneH + safezoneY;
			w = 0.108281 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu3btnadd : RscButtonEmpty {
			idc = 564064;
			text = "";
			x = 0.746719 * safezoneW + safezoneX;
			y = 0.323389 * safezoneH + safezoneY;
			w = 0.0153381 * safezoneW;
			h = 0.0252499 * safezoneH;
		};
		class menu3fiche : RscPicture {
			idc = 56407;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_iPhone_7.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu3fichename : RscStructuredText {
			idc = 564071;
			text = "";
			x = 0.621016 * safezoneW + safezoneX;
			y = 0.436 * safezoneH + safezoneY;
			w = 0.108672 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class menu3fichenum : RscStructuredText {
			idc = 564072;
			text = "";
			x = 0.59836 * safezoneW + safezoneX;
			y = 0.577057 * safezoneH + safezoneY;
			w = 0.108672 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu3fichebtnsms : RscButtonEmpty {
			idc = 564073;
			text = "";
			x = 0.592579 * safezoneW + safezoneX;
			y = 0.4875 * safezoneH + safezoneY;
			w = 0.038125 * safezoneW;
			h = 0.046898 * safezoneH;
		};
		class menu3fichebtnappel : RscButtonEmpty {
			idc = 564074;
			text = "";
			x = 0.634767 * safezoneW + safezoneX;
			y = 0.4875 * safezoneH + safezoneY;
			w = 0.0385157 * safezoneW;
			h = 0.046898 * safezoneH;
		};
		class menu3fichebtnsms2 : RscButtonEmpty {
			idc = 564075;
			text = "";
			x = 0.588932 * safezoneW + safezoneX;
			y = 0.866205 * safezoneH + safezoneY;
			w = 0.17276 * safezoneW;
			h = 0.0332405 * safezoneH;
		};
		class menu3fichebtnfiche : RscButtonEmpty {
			idc = 564076;
			text = "";
			x = 0.588932 * safezoneW + safezoneX;
			y = 0.93426 * safezoneH + safezoneY;
			w = 0.17276 * safezoneW;
			h = 0.0272222 * safezoneH;
		};
		class menu3retour : RscButtonEmpty {
			idc = 564077;
			text = "";
			x = 0.593984 * safezoneW + safezoneX;
			y = 0.330139 * safezoneH + safezoneY;
			w = 0.0485416 * safezoneW;
			h = 0.0144906 * safezoneH;
		};
		class menu3addcontact : RscPicture {
			idc = 56408;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_iPhone_8.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu3addname : RscEdit {
			idc = 564081;
			text = "";
			colorText[] = {0,0,0,1};
			colorBackground[] = {1,1,1,1};
			font = "HelveticaLTLight";
			sizeEx = 0.025;
			style = 0;
			shadow = 0;
			x = 0.648749 * safezoneW + safezoneX;
			y = 0.357 * safezoneH + safezoneY;
			w = 0.108672 * safezoneW;
			h = 0.0213056 * safezoneH;
		};
		class menu3addnum : RscEdit {
			idc = 564082;
			text = "";
			colorText[] = {0,0,0,1};
			colorBackground[] = {1,1,1,1};
			font = "HelveticaLTLight";
			sizeEx = 0.025;
			style = 0;
			shadow = 0;
			x = 0.667344 * safezoneW + safezoneX;
			y = 0.392084 * safezoneH + safezoneY;
			w = 0.0864844 * safezoneW;
			h = 0.0206111 * safezoneH;
		};
		class menu3btnOK : RscButtonEmpty {
			idc = 564083;
			text = "";
			x = 0.746719 * safezoneW + safezoneX;
			y = 0.323389 * safezoneH + safezoneY;
			w = 0.0153381 * safezoneW;
			h = 0.0252499 * safezoneH;
		};
		class menu3btnannuler : RscButtonEmpty {
			idc = 564084;
			text = "";
			x = 0.592812 * safezoneW + safezoneX;
			y = 0.328945 * safezoneH + safezoneY;
			w = 0.00479125 * safezoneW;
			h = 0.0134444 * safezoneH;
		};
		class menuNewMessage : RscPicture {
			idc = 56409;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_iPhone_9.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menuNMbtnannuler : RscButtonEmpty {
			idc = 564091;
			text = "";
			x = 0.729062 * safezoneW + safezoneX;
			y = 0.321695 * safezoneH + safezoneY;
			w = 0.0275782 * safezoneW;
			h = 0.0119444 * safezoneH;
		};
		class menuNMnumedit : RscEdit {
			idc = 564092;
			text = "";
			colorText[] = {0,0,0,1};
			colorBackground[] = {1,1,1,1};
			font = "HelveticaLTLight";
			sizeEx = 0.035;
			style = 16;
			shadow = 0;
			x = 0.620547 * safezoneW + safezoneX;
			y = 0.399611 * safezoneH + safezoneY;
			w = 0.144766 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menuNMnum : RscStructuredText {
			idc = 564093;
			text = "";
			x = 0.620545 * safezoneW + safezoneX;
			y = 0.398611 * safezoneH + safezoneY;
			w = 0.144375 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menuNMsmsedit : RscEdit {
			idc = 564094;
			text = "";
			colorText[] = {1,1,1,1};
			colorBackground[] = {0,0,0,0};
			font = "HelveticaLTLight";
			sizeEx = 0.035;
			style = 528;
			shadow = 0;
			x = 0.58164 * safezoneW + safezoneX;
			y = 0.6125 * safezoneH + safezoneY;
			w = 0.186953 * safezoneW;
			h = 0.250833 * safezoneH;
		};
		class menuNMbtnenvoyer : RscButtonEmpty {
			idc = 564095;
			text = "";
			x = 0.705469 * safezoneW + safezoneX;
			y = 0.877361 * safezoneH + safezoneY;
			w = 0.0628642 * safezoneW;
			h = 0.0239814 * safezoneH;
		};
		class iPhoneDate : RscStructuredText {
			idc = 564000;
			text = "";
			x = 0.589 * safezoneW + safezoneX;
			y = 0.296 * safezoneH + safezoneY;
			w = 0.0360937 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class MutePic : RscPicture {
			idc = 564096;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_bouton_appel_1.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class MuteBtn : RscButtonEmpty {
			idc = 564097;
			text = "";
			x = 0.607577 * safezoneW + safezoneX;
			y = 0.548389 * safezoneH + safezoneY;
			w = 0.035521 * safezoneW;
			h = 0.0612408 * safezoneH;
		};
		class SpeackersPic : RscPicture {
			idc = 564098;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_bouton_appel_2.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class SpeackersBtn : RscButtonEmpty {
			idc = 564099;
			text = "";
			x = 0.606405 * safezoneW + safezoneX;
			y = 0.640056 * safezoneH + safezoneY;
			w = 0.0359116 * safezoneW;
			h = 0.0612408 * safezoneH;
		};
		class menu5 : RscPicture {
			idc = 565050;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_iphone_10.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu5_btn1 : RscPicture {
			idc = 565053;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_bouton_reglages_OFF2.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu5_btn2 : RscPicture {
			idc = 565052;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_bouton_reglages_ON2.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu5_btn3 : RscPicture {
			idc = 565059;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_bouton_reglages_OFF3.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu5_btn4 : RscPicture {
			idc = 565058;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_bouton_reglages_ON3.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu5_Anonbtn : RscButtonEmpty {
			idc = 565051;
			text = "";
			x = 0.743906 * safezoneW + safezoneX;
			y = 0.529834 * safezoneH + safezoneY;
			w = 0.0189843 * safezoneW;
			h = 0.0202779 * safezoneH;
		};
		class menu5_viberbtn : RscButtonEmpty {
			idc = 565060;
			text = "";
			x = 0.743515 * safezoneW + safezoneX;
			y = 0.486084 * safezoneH + safezoneY;
			w = 0.0185937 * safezoneW;
			h = 0.0202778 * safezoneH;
		};
		class menu5_febtn : RscButtonEmpty {
			idc = 565055;
			text = "";
			x = 0.589218 * safezoneW + safezoneX;
			y = 0.629834 * safezoneH + safezoneY;
			w = 0.0611718 * safezoneW;
			h = 0.0279167 * safezoneH;
		};
		class menu5_ringbtn : RscButtonEmpty {
			idc = 565057;
			text = "";
			x = 0.589218 * safezoneW + safezoneX;
			y = 0.586778 * safezoneH + safezoneY;
			w = 0.0471093 * safezoneW;
			h = 0.0272223 * safezoneH;
		};
		class menu5_fetext : RscStructuredText {
			idc = 565054;
			text = "";
			x = 0.657657 * safezoneW + safezoneX;
			y = 0.633334 * safezoneH + safezoneY;
			w = 0.110625 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu5_ringtext : RscStructuredText {
			idc = 565056;
			text = "";
			x = 0.644375 * safezoneW + safezoneX;
			y = 0.590083 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu5_avionbtn : RscButtonEmpty {
			idc = 565061;
			text = "";
			x = 0.743124 * safezoneW + safezoneX;
			y = 0.443723 * safezoneH + safezoneY;
			w = 0.0185937 * safezoneW;
			h = 0.0195834 * safezoneH;
		};
		class menu5_btn5 : RscPicture {
			idc = 565062;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_bouton_reglages_OFF1.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu5_btn6 : RscPicture {
			idc = 565063;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_bouton_reglages_ON1.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu_radio : RscPicture {
			idc = 58256;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_iphone_radio_1.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu_radio_pic1 : RscPicture {
			idc = 582500;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_bouton_radio_1.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu_radio_pic2 : RscPicture {
			idc = 582501;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_bouton_radio_2.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu_radio_btn1 : RscButtonEmpty {
			idc = 582502;
			text = "";
			x = 0.640234 * safezoneW + safezoneX;
			y = 0.412499 * safezoneH + safezoneY;
			w = 0.0709375 * safezoneW;
			h = 0.0286112 * safezoneH;
		};
		class menu_radio_btn2 : RscButtonEmpty {
			idc = 582503;
			text = "";
			x = 0.640234 * safezoneW + safezoneX;
			y = 0.412499 * safezoneH + safezoneY;
			w = 0.0709375 * safezoneW;
			h = 0.0286112 * safezoneH;
		};
		class menu_radio_app : RscButtonEmpty {
			idc = 582504;
			text = "";
			x = 0.726017 * safezoneW + safezoneX;
			y = 0.354463 * safezoneH + safezoneY;
			w = 0.0289843 * safezoneW;
			h = 0.0491018 * safezoneH;
		};
		class menu_radio_edit : RscEdit {
			idc = 582505;
			text = "";
			colorText[] = {0,0,0,1};
			colorBackground[] = {0,0,0,0};
			font = "HelveticaLTLight";
			sizeEx = 0.1;
			style = 514;
			shadow = 0;
			x = 0.596223 * safezoneW + safezoneX;
			y = 0.473843 * safezoneH + safezoneY;
			w = 0.159089 * safezoneW;
			h = 0.0952778 * safezoneH;
		};
		class menu_radio_text : RscStructuredText {
			idc = 582506;
			text = "";
			x = 0.613515 * safezoneW + safezoneX;
			y = 0.660249 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu_radio_volp : RscButtonEmpty {
			idc = 582507;
			text = "";
			x = 0.596874 * safezoneW + safezoneX;
			y = 0.569443 * safezoneH + safezoneY;
			w = 0.0771875 * safezoneW;
			h = 0.0515278 * safezoneH;
		};
		class menu_radio_volm : RscButtonEmpty {
			idc = 582508;
			text = "";
			x = 0.676952 * safezoneW + safezoneX;
			y = 0.569443 * safezoneH + safezoneY;
			w = 0.0771875 * safezoneW;
			h = 0.0515278 * safezoneH;
		};
		class menu6pic : RscPicture {
			idc = 682560;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_iphone_11.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu6smslist : RscListBox {
			idc = 682561;
			text = "";
			colorText[] = {1,1,1,1};
			colorSelect[] = {1,1,1,1};
			colorSelect2[] = {1,1,1,1};
			colorBackground[] = {0,0,0,0};
			colorSelectBackground[] = {1,1,1,0.22};
			colorSelectBackground2[] = {1,1,1,0.22};
			shadow = 0;
			font = "HelveticaLTLight";
			sizeEx = 0.04;
			onLBSelChanged = "call A3PL_Phone_lbChangedSmsiPhone;";
			x = 0.588906 * safezoneW + safezoneX;
			y = 0.352833 * safezoneH + safezoneY;
			w = 0.173203 * safezoneW;
			h = 0.256556 * safezoneH;
		};
		class menu6smsview : RscStructuredText {
			idc = 682562;
			text = "";
			x = 0.589063 * safezoneW + safezoneX;
			y = 0.609027 * safezoneH + safezoneY;
			w = 0.173203 * safezoneW;
			h = 0.256556 * safezoneH;
		};
		class menu6_btnnew : RscButtonEmpty {
			idc = 682563;
			text = "";
			x = 0.746719 * safezoneW + safezoneX;
			y = 0.324778 * safezoneH + safezoneY;
			w = 0.0141664 * safezoneW;
			h = 0.0245555 * safezoneH;
		};
		class menu6_btnrep : RscButtonEmpty {
			idc = 682564;
			text = "";
			x = 0.588907 * safezoneW + safezoneX;
			y = 0.899083 * safezoneH + safezoneY;
			w = 0.17276 * safezoneW;
			h = 0.0342778 * safezoneH;
		};
		class menu6_btndel : RscButtonEmpty {
			idc = 682565;
			text = "";
			x = 0.588907 * safezoneW + safezoneX;
			y = 0.933805 * safezoneH + safezoneY;
			w = 0.17276 * safezoneW;
			h = 0.0280276 * safezoneH;
		};
		class menu8_recent : RscPicture {
			idc = 682566;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_iphone_12.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu8_recentlb : RscListBox {
			idc = 682567;
			text = "";
			colorText[] = {1,1,1,1};
			colorSelect[] = {1,1,1,1};
			colorSelect2[] = {1,1,1,1};
			colorBackground[] = {0,0,0,0};
			colorSelectBackground[] = {1,1,1,0.22};
			colorSelectBackground2[] = {1,1,1,0.22};
			shadow = 0;
			font = "HelveticaLTLight";
			sizeEx = 0.04;
			x = 0.588906 * safezoneW + safezoneX;
			y = 0.352528 * safezoneH + safezoneY;
			w = 0.172891 * safezoneW;
			h = 0.512639 * safezoneH;
		};
		class menu9_station : RscPicture {
			idc = 682568;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_iphone_15.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu9_FuelstationsListGroup: RscControlsGroup
		{
			idc = 682569;
			x = 0.587657 * safezoneW + safezoneX;
			y = 0.39 * safezoneH + safezoneY;
			w = 0.175313 * safezoneW;
			h = 0.517 * safezoneH;
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
		class menu10_bank : RscPicture {
			idc = 682570;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_iphone_22.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu10_SendAmount: RscEdit
		{
			idc = 682571;
			x = 0.592343 * safezoneW + safezoneX;
			y = 0.592074 * safezoneH + safezoneY;
			w = 0.165 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class menu10_btnGetBills: RscButtonEmpty
		{
			idc = 682572;
			x = 0.640782 * safezoneW + safezoneX;
			y = 0.883963 * safezoneH + safezoneY;
			w = 0.0721875 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class menu10_btnSendMoney: RscButtonEmpty
		{
			idc = 682573;
			x = 0.727708 * safezoneW + safezoneX;
			y = 0.628703 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.055 * safezoneH;
		};
		class menu10_BankAmount: RscStructuredText
		{
			idc = 682574;
			x = 0.627292 * safezoneW + safezoneX;
			y = 0.471296 * safezoneH + safezoneY;
			w = 0.0979687 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class menu10_BankPlayersList: RscCombo
		{
			idc = 682575;
			x = 0.591511 * safezoneW + safezoneX;
			y = 0.639482 * safezoneH + safezoneY;
			w = 0.134062 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class menu11_factories : RscPicture {
			idc = 682576;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_iphone_16.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu11_FactoriesListGroup: RscControlsGroup
		{
			idc = 682577;
			x = 0.587657 * safezoneW + safezoneX;
			y = 0.39 * safezoneH + safezoneY;
			w = 0.175313 * safezoneW;
			h = 0.517 * safezoneH;
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
		class menu12_twitter : RscPicture {
			idc = 682578;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_iphone_13.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu12_TwitterListGroup: RscControlsGroup
		{
			idc = 682579;
			x = 0.587552 * safezoneW + safezoneX;
			y = 0.37437 * safezoneH + safezoneY;
			w = 0.175313 * safezoneW;
			h = 0.517 * safezoneH;
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
		class menu12_btnNewTweet: RscButtonEmpty
		{
			idc = 682580;
			x = 0.728072 * safezoneW + safezoneX;
			y = 0.906482 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.055 * safezoneH;
		};
		class menu13_twitterpost : RscPicture {
			idc = 682581;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_iphone_14.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu13_btnTweet: RscButtonEmpty
		{
			idc = 682582;
			x = 0.721719 * safezoneW + safezoneX;
			y = 0.313 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class menu13_writeTweet: RscEdit
        {
            idc = 682583;
            style = "16";
            x = 0.615104 * safezoneW + safezoneX;
			y = 0.382407 * safezoneH + safezoneY;
			w = 0.149531 * safezoneW;
			h = 0.253 * safezoneH;
            text = "";
            sizeEx = 0.015 * safezoneW;
            colorText[] = {1,1,1,1};
            colorBackground[] = {0,0,0,0};
            shadow = 0;
            maxChars = 100;
        };
		class menu14_gangcreation : RscPicture {
			idc = 682584;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_iphone_25.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu14_gangname: RscEdit
		{
			idc = 682586;
			x = 0.595833 * safezoneW + safezoneX;
			y = 0.473148 * safezoneH + safezoneY;
			w = 0.165 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class menu14_btncreategang: RscButtonEmpty
		{
			idc = 682585;
			x = 0.649479 * safezoneW + safezoneX;
			y = 0.891333 * safezoneH + safezoneY;
			w = 0.0515625 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu15_gangmanagement : RscPicture {
			idc = 682587;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_iphone_27.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu15_btninvitegang: RscButtonEmpty
		{
			idc = 682588;
			x = 0.636979 * safezoneW + safezoneX;
			y = 0.715741 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu15_btnkick: RscButtonEmpty
		{
			idc = 682589;
			x = 0.585937 * safezoneW + safezoneX;
			y = 0.537037 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu15_btndefineleader: RscButtonEmpty
		{
			idc = 682590;
			x = 0.708854 * safezoneW + safezoneX;
			y = 0.536111 * safezoneH + safezoneY;
			w = 0.0567187 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu15_btncomptebancaire: RscButtonEmpty
		{
			idc = 682591;
			x = 0.5875 * safezoneW + safezoneX;
			y = 0.874075 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu15_btnquitgang: RscButtonEmpty
		{
			idc = 682592;
			x = 0.700521 * safezoneW + safezoneX;
			y = 0.860185 * safezoneH + safezoneY;
			w = 0.0567187 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu15_btndeletegang: RscButtonEmpty
		{
			idc = 682593;
			x = 0.693229 * safezoneW + safezoneX;
			y = 0.893519 * safezoneH + safezoneY;
			w = 0.0721875 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu15_Listbox_AllMembers: RscListbox
		{
			idc = 682594;
			x = 0.586458 * safezoneW + safezoneX;
			y = 0.416667 * safezoneH + safezoneY;
			w = 0.175313 * safezoneW;
			h = 0.11 * safezoneH;
		};
		class menu15_Combo_AllPlayers: RscCombo
		{
			idc = 682595;
			x = 0.583333 * safezoneW + safezoneX;
			y = 0.688889 * safezoneH + safezoneY;
			w = 0.185625 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu15_text_bank: RscStructuredText
		{
			idc = 682596;
			text = "STR_UI_iPhone_AccountBank";
			x = 0.583854 * safezoneW + safezoneX;
			y = 0.600925 * safezoneH + safezoneY;
			w = 0.0721875 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu15_text_money: RscStructuredText
		{
			idc = 682597;
			x = 0.657813 * safezoneW + safezoneX;
			y = 0.600926 * safezoneH + safezoneY;
			w = 0.0721875 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu16_gangbank : RscPicture {
			idc = 682598;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_iphone_26.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu16_SendAmount: RscEdit
		{
			idc = 682599;
			x = 0.590105 * safezoneW + safezoneX;
			y = 0.591666 * safezoneH + safezoneY;
			w = 0.165 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class menu16_btnSendAmount: RscButtonEmpty
		{
			idc = 682600;
			x = 0.728125 * safezoneW + safezoneX;
			y = 0.627778 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.055 * safezoneH;
		};
		class menu16_BankPlayersList: RscCombo
		{
			idc = 682601;
			x = 0.590104 * safezoneW + safezoneX;
			y = 0.637963 * safezoneH + safezoneY;
			w = 0.134062 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class menu16_BankAmount: RscStructuredText
		{
			idc = 682602;
			x = 0.617708 * safezoneW + safezoneX;
			y = 0.465741 * safezoneH + safezoneY;
			w = 0.118594 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class menu17_uber : RscPicture {
			idc = 682603;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_iphone_20.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu17_btnCallUber: RscButton
		{
			idc = 682604;
			text = "STR_UI_iPhone_CallUber";
			x = 0.589584 * safezoneW + safezoneX;
			y = 0.382407 * safezoneH + safezoneY;
			w = 0.170156 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class menu17_btnBecomeUber: RscButton
		{
			idc = 682605;
			text = "STR_UI_iPhone_BecomeUber";
			x = 0.590104 * safezoneW + safezoneX;
			y = 0.424074 * safezoneH + safezoneY;
			w = 0.170156 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class menu17_btnStopJobUber: RscButton
		{
			idc = 682606;
			text = "STR_UI_iPhone_QuitJobUber"; 
			x = 0.589583 * safezoneW + safezoneX;
			y = 0.466667 * safezoneH + safezoneY;
			w = 0.170156 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class menu18_housing : RscPicture {
			idc = 682607;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_iphone_17.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu18_HousingListGroup: RscControlsGroup {
			idc = 682608;
			x = 0.587135 * safezoneW + safezoneX;
			y = 0.393741 * safezoneH + safezoneY;
			w = 0.175313 * safezoneW;
			h = 0.55 * safezoneH;
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
		class menu19_notes : RscPicture {
			idc = 682609;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_iphone_19.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu19_nameNotes: RscEdit
		{
			idc = 682610;
			text = "STR_UI_iPhone_NoteTitle"; 
			x = 0.588021 * safezoneW + safezoneX;
			y = 0.37963 * safezoneH + safezoneY;
			w = 0.175313 * safezoneW;
			h = 0.022 * safezoneH;
			maxChars = 10;
			onMouseButtonClick = "_text = ctrlText 682610; if (_text isEqualTo ""STR_UI_iPhone_NoteTitle"") then {ctrlSetText [682610,""""]};";
		};
		class menu19_notesBox: RscEdit
		{
			idc = 682611;
			text = "STR_UI_iPhone_WriteNoteContentHere"; 
			x = 0.588021 * safezoneW + safezoneX;
			y = 0.40463 * safezoneH + safezoneY;
			w = 0.175313 * safezoneW;
			h = 0.143 * safezoneH;
			maxChars = 396;
			onMouseButtonClick = "_text = ctrlText 682611; if (_text isEqualTo ""STR_UI_iPhone_WriteNoteContentHere"") then {ctrlSetText [682611,""""]};";
		};
		class menu19_btnsaveNote: RscButton
		{
			idc = 682612;
			text = "STR_UI_iPhone_SaveNote"; 
			x = 0.696093 * safezoneW + safezoneX;
			y = 0.549074 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu19_btnopenGiveNote: RscButton
		{
			idc = 682613;
			text = "STR_UI_iPhone_GiveaCopy";
			x = 0.588021 * safezoneW + safezoneX;
			y = 0.55 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.022 * safezoneH;
			action = "_name = ctrlText 682610; _text = ctrlText 682611; [_name,_text] call A3PL_Phone_appGiveNote;";
		};
		class menu20_btnCreateNewNote: RscButton
		{
			idc = 682614;
			text = "STR_UI_iPhone_CreateNewNote";
			x = 0.586979 * safezoneW + safezoneX;
			y = 0.377778 * safezoneH + safezoneY;
			w = 0.175313 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu20_NotesListGroup: RscControlsGroup
		{
			idc = 682615;
			x = 0.592709 * safezoneW + safezoneX;
			y = 0.412963 * safezoneH + safezoneY;
			w = 0.170156 * safezoneW;
			h = 0.539 * safezoneH;
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
		class menu21_GiveNoteBtn: RscButton
		{
			idc = 682616;
			text = "STR_UI_iPhone_GiveCopyNote"; 
			x = 0.586458 * safezoneW + safezoneX;
			y = 0.405556 * safezoneH + safezoneY;
			w = 0.175313 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu21_PlayerComboBoxNotes: RscCombo
		{
			idc = 682617;
			x = 0.586979 * safezoneW + safezoneX;
			y = 0.378704 * safezoneH + safezoneY;
			w = 0.175313 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu22_nameNotes: RscEdit
		{
			idc = 682618;
			text = "STR_UI_iPhone_NoteTitle"; 
			x = 0.588021 * safezoneW + safezoneX;
			y = 0.37963 * safezoneH + safezoneY;
			w = 0.175313 * safezoneW;
			h = 0.022 * safezoneH;
			maxChars = 10;
			onMouseButtonClick = "_text = ctrlText 682618; if (_text isEqualTo ""STR_UI_iPhone_NoteTitle"") then {ctrlSetText [682618,""""]};";
		};
		class menu22_notesBox: RscEdit
		{
			idc = 682619;
			text = "STR_UI_iPhone_WriteNoteContentHere"; 
			x = 0.588021 * safezoneW + safezoneX;
			y = 0.40463 * safezoneH + safezoneY;
			w = 0.175313 * safezoneW;
			h = 0.143 * safezoneH;
			maxChars = 396;
			onMouseButtonClick = "_text = ctrlText 682619; if (_text isEqualTo ""STR_UI_iPhone_WriteNoteContentHere"") then {ctrlSetText [682619,""""]};";
		};
		class menu22_btncreateNote: RscButton
		{
			idc = 682620;
			text = "STR_UI_iPhone_CreateNote"; 
			x = 0.696093 * safezoneW + safezoneX;
			y = 0.549074 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu23_keys : RscPicture {
			idc = 682621;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_iphone_21.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu23_KeysList: RscListbox
		{
			idc = 682622;
			x = 0.58251 * safezoneW + safezoneX;
			y = 0.377926 * safezoneH + safezoneY;
			w = 0.185625 * safezoneW;
			h = 0.473 * safezoneH;
		};
		class menu23_KeysPlayerList: RscCombo
		{
			idc = 682623;
			x = 0.582292 * safezoneW + safezoneX;
			y = 0.854631 * safezoneH + safezoneY;
			w = 0.185625 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu23_btnGiveKeys: RscButtonEmpty
		{
			idc = 682624;
			x = 0.649479 * safezoneW + safezoneX;
			y = 0.889815 * safezoneH + safezoneY;
			w = 0.0515625 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu24_skills : RscPicture {
			idc = 682625;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_iphone_18.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu24_TOP_TEXT_LEFT: RscStructuredText
		{
			idc = 682626;
			x = 0.585416 * safezoneW + safezoneX;
			y = 0.376852 * safezoneH + safezoneY;
			w = 0.180469 * safezoneW;
			h = 0.022 * safezoneH;
			colorText[] = {1,1,1,0.75};
		};
		class menu24_SkillsGroup: RscControlsGroup
		{
			idc = 682627;
			x = 0.585937 * safezoneW + safezoneX;
			y = 0.40463 * safezoneH + safezoneY;
			w = 0.180469 * safezoneW;
			h = 0.55 * safezoneH;
			class VScrollbar 
			{
				color[] = {0.7, 0.7, 0.7, 1};
				width = 0.02;
				autoScrollSpeed = -1;
				autoScrollDelay = 0;
				autoScrollRewind = 0;
				arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa"; // Arrow 
				arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa"; // Arrow when clicked on 
				border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa"; // Slider background (stretched vertically) 
				thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa"; // Dragging element (stretched vertically) 
			};
			class HScrollbar 
			{
				color[] = {1, 1, 1, 0};
				height = 0;
			};
			class ScrollBar
			{
				color[] = {0.7, 0.7, 0.7, 1};
				colorActive[] = {1,1,1,1};
				colorDisabled[] = {1,1,1,0.3};
				arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa"; // Arrow 
				arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa"; // Arrow when clicked on 
				border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa"; // Slider background (stretched vertically) 
				thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa"; // Dragging element (stretched vertically) 
			};
			class Controls	{};
		};
		class menu25_announcements : RscPicture {
			idc = 682628;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_iphone_28.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu25_textprice: RscText
		{
			idc = 682629;
			text = "STR_UI_iPhone_AnnouncementPrice"; 
			x = 0.593437 * safezoneW + safezoneX;
			y = 0.389815 * safezoneH + safezoneY;
			w = 0.170156 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu25_news_title: RscEdit
		{
			idc = 682630;
			x = 0.583907 * safezoneW + safezoneX;
			y = 0.475 * safezoneH + safezoneY;
			w = 0.180469 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class menu25_news_message: RscEdit
		{
			idc = 682631;
			x = 0.584428 * safezoneW + safezoneX;
			y = 0.525 * safezoneH + safezoneY;
			w = 0.180469 * safezoneW;
			h = 0.308 * safezoneH;
		};
		class menu25_btnsendnews: RscButton
		{
			idc = 682632;
			text = "STR_UI_iPhone_SendAnnouncement"; 
			x = 0.584375 * safezoneW + safezoneX;
			y = 0.840741 * safezoneH + safezoneY;
			w = 0.180469 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class HomeBtn : RscButtonEmpty {
			idc = -1;
			text = "";
			onButtonClick = "uiNamespace setVariable ['iphonemenu',0]; call A3PL_Phone_menuiPhone;";
			x = 0.638907 * safezoneW + safezoneX;
			y = 0.963389 * safezoneH + safezoneY;
			w = 0.0721875 * safezoneW;
			h = 0.011 * safezoneH;
		};
		class menu26_bills : RscPicture {
			idc = 682633;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_iphone_23.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu26_BillsListBox: RscListbox
		{
			idc = 682634;
			x = 0.586979 * safezoneW + safezoneX;
			y = 0.383333 * safezoneH + safezoneY;
			w = 0.175313 * safezoneW;
			h = 0.231 * safezoneH;
		};
		class menu26_DetailsText: RscEdit
		{
			idc = 682635;
			x = 0.5875 * safezoneW + safezoneX;
			y = 0.618519 * safezoneH + safezoneY;
			w = 0.175313 * safezoneW;
			h = 0.253 * safezoneH;
		};
		class menu26_btncreatebills: RscButtonEmpty
		{
			idc = 682636;
			x = 0.6375 * safezoneW + safezoneX;
			y = 0.889815 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu27_sendbills : RscPicture {
			idc = 682637;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_iphone_24.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu27_sendbills_sendbtn: RscButtonEmpty
		{
			idc = 682638;
			x = 0.6375 * safezoneW + safezoneX;
			y = 0.889815 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu27_sendbills_playerlist: RscCombo
		{
			idc = 682639;
			x = 0.586458 * safezoneW + safezoneX;
			y = 0.388889 * safezoneH + safezoneY;
			w = 0.180469 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu27_sendbills_amount: RscEdit
		{
			idc = 682640;
			x = 0.627135 * safezoneW + safezoneX;
			y = 0.466666 * safezoneH + safezoneY;
			w = 0.0979687 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class menu27_sendbills_details: RscEdit
		{
			idc = 682641;
			x = 0.584375 * safezoneW + safezoneX;
			y = 0.637963 * safezoneH + safezoneY;
			w = 0.180469 * safezoneW;
			h = 0.231 * safezoneH;
		};
		class menu29_importexport : RscPicture {
			idc = 682642;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_iphone_29.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu29_ImportExportListGroup: RscControlsGroup
		{
			idc = 682643;
			x = 0.587657 * safezoneW + safezoneX;
			y = 0.39 * safezoneH + safezoneY;
			w = 0.175313 * safezoneW;
			h = 0.517 * safezoneH;
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
		class menu30_fishjobs : RscPicture {
			idc = 682644;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_iphone_30.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu30_FishJobsListGroup: RscControlsGroup
		{
			idc = 682645;
			x = 0.587657 * safezoneW + safezoneX;
			y = 0.39 * safezoneH + safezoneY;
			w = 0.175313 * safezoneW;
			h = 0.517 * safezoneH;
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
		class menu30_fishjobs_buttonNew: RscButtonEmpty
		{
			idc = 682646;
			x = 0.732682 * safezoneW + safezoneX;
			y = 0.924961 * safezoneH + safezoneY;
			w = 0.0257711 * safezoneW;
			h = 0.0440091 * safezoneH;
		};
		class menu31_fishjobsCreate_BG: RscPicture
		{
			idc = 682647;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_iphone_31.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};
		class menu31_fishjobsCreate_buttonCreate: RscButtonEmpty
		{
			idc = 682648;
			x = 0.605111 * safezoneW + safezoneX;
			y = 0.864035 * safezoneH + safezoneY;
			w = 0.139164 * safezoneW;
			h = 0.0440091 * safezoneH;
		};
		class menu31_fishjobsCreate_title: RscEdit
		{
			idc = 682649;
			x = 0.586545 * safezoneW + safezoneX;
			y = 0.410134 * safezoneH + safezoneY;
			w = 0.180398 * safezoneW;
			h = 0.0330069 * safezoneH;
		};
		class menu31_fishjobsCreate_description: RscEdit
		{
			idc = 682650;
			x = 0.587144 * safezoneW + safezoneX;
			y = 0.479183 * safezoneH + safezoneY;
			w = 0.180398 * safezoneW;
			h = 0.0880183 * safezoneH;
		};
		class menu31_fishjobsCreate_phone: RscEdit
		{
			idc = 682651;
			x = 0.587143 * safezoneW + safezoneX;
			y = 0.607129 * safezoneH + safezoneY;
			w = 0.180398 * safezoneW;
			h = 0.0330069 * safezoneH;
		};
		class menu31_fishjobsCreate_email: RscEdit
		{
			idc = 682652;
			x = 0.587144 * safezoneW + safezoneX;
			y = 0.684302 * safezoneH + safezoneY;
			w = 0.180398 * safezoneW;
			h = 0.0330069 * safezoneH;
		};
		class menu31_fishjobsCreate_duree: RscEdit
		{
			idc = 682653;
			x = 0.587742 * safezoneW + safezoneX;
			y = 0.755383 * safezoneH + safezoneY;
			w = 0.180398 * safezoneW;
			h = 0.0330069 * safezoneH;
		};
		class menu31_fishjobsCreate_topay: RscStructuredText
		{
			idc = 682654;
			x = 0.658416 * safezoneW + safezoneX;
			y = 0.797016 * safezoneH + safezoneY;
			w = 0.108239 * safezoneW;
			h = 0.0330069 * safezoneH;
		};
	};
};

class SkillElement: RscControlsGroup
{
	idc = 96;
	x = 0;
	y = 0;
	w = safeZoneW * 0.185469;
	h = safeZoneH * 0.055;
	class Controls
	{
		class SkillTitle: RscText
		{
			idc = 961;
			style = ST_LEFT;
			x = 0;
			y = 0.01;
			w = safeZoneW * 0.180468;
			h = safeZoneH * 0.03;
			text = "";
			sizeEx = 0.017 * safezoneW;
			colorText[] = {1,1,1,0.75};
			shadow = 0;
		};
		class SkillLevel: RscText
		{
			idc = 962;
			style = ST_RIGHT;
			x = 0;
			y = 0.01;
			w = safeZoneW * 0.180468;
			h = safeZoneH * 0.03;
			text = "";
			sizeEx = 0.017 * safezoneW;
			colorText[] = {1,1,1,0.75};
			shadow = 0;
		};
		class RscText_1000: RscText
		{
			idc = -1;
			x = 0.008;
			y = 0.028 * safezoneW;
			w = safeZoneW * 0.180468;
			h = safeZoneH * 0.015;
			colorBackground[] = {1,1,1,0.35};
		};
		class SkillProgress: RscProgress
		{
			idc = 963;
			x = 0.008;
			y = 0.028 * safezoneW;
			w = safeZoneW * 0.180468;
			h = safeZoneH * 0.015;
			colorFrame[] = {1,1,1,0};
			colorBar[] = {0.90588235294,0.49411764705,0.14901960784,1};
			shadow = 0;
		};		
	};
};

class iPhone_Details_Notes: RscControlsGroup
{
	idc = -1;
	x = 0;
	y = 0;
	w = safeZoneW * 0.170156;
	h = safeZoneH * 0.03;
	class Controls
	{
		class iPhone_X_notesName: RscText
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

class iPhone_Details_Housing: RscControlsGroup
{
	idc = -1;
	x = 0;
	y = 0;
	w = safeZoneW * 0.175313;
	h = safeZoneH * 0.03;
	class Controls
	{
		class iPhone_X_HousingName: RscText
		{
			idc = 98002;
			style = ST_LEFT;
			x = 0;
			y = 0;
			w = safeZoneW * 0.175313;
			h = safeZoneH * 0.02;
			text = "";
			sizeEx = 0.016 * safezoneW;
			colorText[] = {1,1,1,1};
			shadow = 0;
		};
		class iPhone_X_housingButton: RscButtonEmpty
		{
			idc = 98003;
			style = ST_LEFT;
			x = 0;
			y = 0;
			w = safeZoneW * 0.175313;
			h = safeZoneH * 0.02;
			text = "";
			sizeEx = 0.014 * safezoneW;
			colorText[] = {0.4,0.4,0.4,1};
			shadow = 0;
		};
	};
};

class iPhone_X_Tweet: RscControlsGroup
{
    idc = 98150;
    x = 0;
    y = 0;
    w = safeZoneW * 0.175313;
    h = safeZoneH * 0.052;
    class Controls
    {
        class iPhone_X_TweetName: RscStructuredText
        {
            idc = 98301;
            style = ST_LEFT;
            x = 0;
            y = 0;
            w = safeZoneW * 0.175312;
            h = safeZoneH * 0.02;
            text = "";
            sizeEx = 0.02 * safezoneW;
            colorText[] = {1,1,1,1};
            shadow = 0;
        };
        class iPhone_X_Tweet: RscStructuredText
        {
            idc = 98302;
			style = 0;
            x = 0;
            y = 0.02 * safezoneW;
            w = safeZoneW * 0.175312;
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
            w = safeZoneW * 0.175312;
            h = safeZoneH * 0.001;
            colorBackground[] = {0.737,0.733,0.733,1};
        };
    };
};

class iPhone_Details_Factory: RscControlsGroup
{
	idc = -1;
	x = 0;
	y = 0;
	w = safeZoneW * 0.135;
	h = safeZoneH * 0.055;
	class Controls
	{
		class iPhone_X_factoryName: RscText
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
		class iPhone_X_time: RscText
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
	};
};

class iPhone_Details_IE: RscControlsGroup
{
	idc = -1;
	x = 0;
	y = 0;
	w = safeZoneW * 0.135;
	h = safeZoneH * 0.0733333;
	class Controls
	{
		class iPhone_X_resourceName: RscText
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
		class iPhone_X_importprice: RscText
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
		class iPhone_X_exportprice: RscText
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

class iPhone_Details_FishJobs: RscControlsGroup
{
	idc = -1;
	x = 0;
	y = 0;
	w = safeZoneW * 0.180;
	h = safeZoneH * 0.115;
	class Controls
	{
		class iPhone_X_fishJobs_Title: RscText
		{
			idc = 98002;
			style = ST_LEFT;
			x = 0;
			y = 0;
			w = safeZoneW * 0.170;
			h = safeZoneH * 0.02;
			text = "";
			sizeEx = 0.016 * safezoneW;
			colorText[] = {1,1,1,1};
			shadow = 0;
		};
		class iPhone_X_fishJobs_Description: RscText
		{
			idc = 98003;
			style = ST_LEFT;
			x = 0;
			y = 0.02 * safezoneW;
			w = safeZoneW * 0.170;
			h = safeZoneH * 0.018;
			text = "";
			sizeEx = 0.014 * safezoneW;
			colorText[] = {0.737,0.733,0.733,1};
			shadow = 0;
		};
		class iPhone_X_fishJobs_Phone: RscText
		{
			idc = 98004;
			style = ST_LEFT;
			x = 0;
			y = 0.036 * safezoneW;
			w = safeZoneW * 0.170;
			h = safeZoneH * 0.018;
			text = "";
			sizeEx = 0.014 * safezoneW;
			colorText[] = {0.737,0.733,0.733,1};
			shadow = 0;
		};
		class iPhone_X_fishJobs_Email: RscText
		{
			idc = 98005;
			style = ST_LEFT;
			x = 0;
			y = 0.052 * safezoneW;
			w = safeZoneW * 0.170;
			h = safeZoneH * 0.018;
			text = "";
			sizeEx = 0.014 * safezoneW;
			colorText[] = {0.737,0.733,0.733,1};
			shadow = 0;
		};
		class iPhone_X_fishJobs_Time: RscText
		{
			idc = 98006;
			style = ST_LEFT;
			x = 0;
			y = 0.068 * safezoneW;
			w = safeZoneW * 0.170;
			h = safeZoneH * 0.018;
			text = "";
			sizeEx = 0.014 * safezoneW;
			colorText[] = {0.737,0.733,0.733,1};
			shadow = 0;
		};
	};
};

class iPhone_Details_Fuel: RscControlsGroup
{
	idc = -1;
	x = 0;
	y = 0;
	w = safeZoneW * 0.135;
	h = safeZoneH * 0.0733333;
	class Controls
	{
		class iPhone_X_fuelStationName: RscText
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
		class iPhone_X_petrol: RscText
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
		class iPhone_X_cost: RscText
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