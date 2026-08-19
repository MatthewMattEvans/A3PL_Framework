class A3PL_Achievements {
	idd = 2060;
	movingEnable = true;
	enableSimulation = true;	
	class controlsBackground {	
		class Background: RscPicture
		{
			idc = -1;
			text = "\A3PL_Common\GUI\newphone\iPhone\ALF_iphone_32.paa";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.454324 * safezoneW;
			h = 0.766407 * safezoneH;
		};		
	};
	class controls {
		class MasterButtonGroup: RscControlsGroup
		{
			idc = 2061;
			x = 0.584479 * safezoneW + safezoneX;
			y = 0.382467 * safezoneH + safezoneY;
			w = 0.180469 * safezoneW;
			h = 0.560893 * safezoneH;
			colorBackground[] = {0,0,0,0.6};
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
	};
};