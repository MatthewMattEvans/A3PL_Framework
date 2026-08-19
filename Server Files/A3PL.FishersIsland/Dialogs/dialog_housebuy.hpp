class Dialog_HouseBuy
{
	idd = 72;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "";
	onUnload = "";
	class controls
	{
		class RscPicture_1200: RscPicture
		{
			idc = 1200;
			text = "\A3PL_Common\GUI\A3PL_HouseBuy.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class button_yes: RscButtonEmpty
		{
			idc = -1;
			x = 0.416667 * safezoneW + safezoneX;
			y = 0.635185 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.033 * safezoneH;
			action = "call A3PL_Housing_Buy;";
		};
		class button_no: RscButtonEmpty
		{
			idc = -1;
			x = 0.505729 * safezoneW + safezoneX;
			y = 0.636111 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.033 * safezoneH;
			action = "closeDialog 0; A3PL_Housing_Object = nil;";
		};
		class text_currentPrice: RscText
		{
			idc = 1000;
			text = "$"; 
			x = 0.425521 * safezoneW + safezoneX;
			y = 0.518519 * safezoneH + safezoneY;
			w = 0.154687 * safezoneW;
			h = 0.044 * safezoneH;
			sizeEx = "0.03 * safezoneH";
		};
	};
};