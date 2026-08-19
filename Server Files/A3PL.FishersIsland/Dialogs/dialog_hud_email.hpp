// Email Notification Dialogs
// Similar structure to SMS/Twitter but with email-specific styling

class RSC_DOEMAIL4
{
	idd = 889542316;
	fadein=1;
	fadeout=1;
	duration = 6;
	name="RSC_DOEMAIL4";
	onLoad="uiNamespace setVariable ['RSC_DOEMAIL4',_this select 0]";
	objects[]={};
	class controlsBackground {
		class MainBackground: RscPicture {
			text = "\A3PL_Common\GUI\notifications\header_email.paa";
			idc = 163334;
			x = 0.762969 * safezoneW + safezoneX;
			y = 0.428 * safezoneH + safezoneY;
			w = 0.20625 * safezoneW;
			h = 0.33 * safezoneH;
		};
	};
	class controls
	{
		class A3PL_popup_text_basic4: RscStructuredText
		{
			idc=1633341;
			style=ST_LEFT;
			x = 0.773281 * safezoneW + safezoneX;
			y = 0.566 * safezoneH + safezoneY;
			w = 0.185625 * safezoneW;
			h = 0.055 * safezoneH;
			valign = "left";
			sizeEx=0.035;
			size=0.035;
			colorBackground[]={0,0,0,0};
			colorText[] = { 1 , 1 , 1 , 1 };
			shadow=false;
			text="";
		};
	};
};

class RSC_DOEMAIL3
{
	idd = 8858738;
	fadein=1;
	fadeout=1;
	duration = 6;
	name="RSC_DOEMAIL3";
	onLoad="uiNamespace setVariable ['RSC_DOEMAIL3',_this select 0]";
	objects[]={};
	class controlsBackground {
		class MainBackground: RscPicture {
			text = "\A3PL_Common\GUI\notifications\header_email.paa";
			idc = 163333;
			x = 0.762969 * safezoneW + safezoneX;
			y = 0.527 * safezoneH + safezoneY;
			w = 0.20625 * safezoneW;
			h = 0.33 * safezoneH;
		};
	};
	class controls
	{
		class A3PL_popup_text_basic3: RscStructuredText
		{
			idc=1633331;
			style=ST_LEFT;
			x = 0.773281 * safezoneW + safezoneX;
			y = 0.665 * safezoneH + safezoneY;
			w = 0.185625 * safezoneW;
			h = 0.055 * safezoneH;
			valign = "left";
			sizeEx=0.035;
			size=0.035;
			colorBackground[]={0,0,0,0};
			colorText[] = { 1 , 1 , 1 , 1 };
			shadow=false;
			text="";
		};
	};
};

class RSC_DOEMAIL2
{
	idd = 57324339;
	fadein=1;
	fadeout=1;
	duration = 6;
	name="RSC_DOEMAIL2";
	onLoad="uiNamespace setVariable ['RSC_DOEMAIL2',_this select 0]";
	objects[]={};
	class controlsBackground {
		class MainBackground: RscPicture {
			text = "\A3PL_Common\GUI\notifications\header_email.paa";
			idc = 163332;
			x = 0.762969 * safezoneW + safezoneX;
			y = 0.626 * safezoneH + safezoneY;
			w = 0.20625 * safezoneW;
			h = 0.33 * safezoneH;
		};
	};
	class controls
	{
		class A3PL_popup_text_basic2: RscStructuredText
		{
			idc=1633321;
			style=ST_LEFT;
			x = 0.773281 * safezoneW + safezoneX;
			y = 0.764 * safezoneH + safezoneY;
			w = 0.185625 * safezoneW;
			h = 0.055 * safezoneH;
			valign = "left";
			sizeEx=0.035;
			size=0.035;
			colorBackground[]={0,0,0,0};
			colorText[] = { 1 , 1 , 1 , 1 };
			shadow=false;
			text="";
		};
	};
};

class RSC_DOEMAIL1
{
	idd = 886321355;
	fadein=1;
	fadeout=1;
	duration = 6;
	name="RSC_DOEMAIL1";
	onLoad="uiNamespace setVariable ['RSC_DOEMAIL1',_this select 0]";
	objects[]={};
	class controlsBackground {
		class MainBackground: RscPicture {
			text = "\A3PL_Common\GUI\notifications\header_email.paa";
			idc = 163331;
			x = 0.762969 * safezoneW + safezoneX;
			y = 0.725 * safezoneH + safezoneY;
			w = 0.20625 * safezoneW;
			h = 0.33 * safezoneH;
		};
	};
	class controls
	{
		class A3PL_popup_text_basic1: RscStructuredText
		{
			idc=1633311;
			style=ST_LEFT;
			x = 0.773281 * safezoneW + safezoneX;
			y = 0.863 * safezoneH + safezoneY;
			w = 0.185625 * safezoneW;
			h = 0.055 * safezoneH;
			valign = "left";
			sizeEx=0.035;
			size=0.035;
			colorBackground[]={0,0,0,0};
			colorText[] = { 1 , 1 , 1 , 1 };
			shadow=false;
			text="";
		};
	};
};
