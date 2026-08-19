class Dialog_HUD_Twitter
{
	idd = -1;
	duration = 1e+012;
	onLoad = "uiNamespace setVariable [""Dialog_HUD_Twitter"", _this select 0]";
	class Controls
	{
		class static_header: RscText
		{
			idc = 1000;
			text = ""; 
			font = "EtelkaNarrowMediumPro";
			sizeEx = 0.06;
			x = safeZoneX;
			y = safeZoneY + safeZoneH*1.62/3.05;
			w = 0.6 * safeZoneW;
			h = 0.05 * 8;
		};		

		class struc_messages: RscStructuredText
		{
			idc = 100;
			style = 256;
			colorText[] = {0,0,0,1};
			colorBackground[] = {0,0,0,0};
			colorShadow[] = {0.2,0.2,0.2,1};
			size = 0.06;
			sizeEx = 0.03;
			x = "safeZoneX";
			y = "safeZoneY + safeZoneH*2/3";
			w = "0.399472 * safeZoneW";
			h = "0.05 * 8";
			text = "Message 1<br />Message 2";
			class Attributes
			{
				font = "PuristaBold";
				color = "#ffffff";
				align = "left";
				valign = "middle";
				shadow = 1;
				shadowColor = "#333333";
				size = 0.8;
			};
		};
	};
};

class RSC_DOTWITTER4
{
	idd = 789542315;
	fadein=1;
  	fadeout=1;
	duration = 6;
	name="RSC_DOTWITTER4";
	onLoad="uiNamespace setVariable ['RSC_DOTWITTER4',_this select 0]";
	objects[]={};
	class controlsBackground {
		class MainBackground: RscPicture {
			text = "\A3PL_Common\GUI\notifications\header_twitter.paa";
			idc = 193334;
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
			idc=1833341;
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

class RSC_DOTWITTER3
{
	idd = 8758737;
	fadein=1;
  	fadeout=1;
	duration = 6;
	name="RSC_DOTWITTER3";
	onLoad="uiNamespace setVariable ['RSC_DOTWITTER3',_this select 0]";
	objects[]={};
	class controlsBackground {
		class MainBackground: RscPicture {
			text = "\A3PL_Common\GUI\notifications\header_twitter.paa";
			idc = 173333;
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

class RSC_DOTWITTER2
{
	idd = 47324338;
	fadein=1;
  	fadeout=1;
	duration = 6;
	name="RSC_DOTWITTER2";
	onLoad="uiNamespace setVariable ['RSC_DOTWITTER2',_this select 0]";
	objects[]={};
	class controlsBackground {
		class MainBackground: RscPicture {
			text = "\A3PL_Common\GUI\notifications\header_twitter.paa";
			idc = 153332;
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
			idc=1433321;
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

class RSC_DOTWITTER1
{
	idd = 786321354;
	fadein=1;
  	fadeout=1;
	duration = 6;
	name="RSC_DOTWITTER1";
	onLoad="uiNamespace setVariable ['RSC_DOTWITTER1',_this select 0]";
	objects[]={};
	class controlsBackground {
		class MainBackground: RscPicture {
			text = "\A3PL_Common\GUI\notifications\header_twitter.paa";
			idc = 143331;
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
			idc=1433311;
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