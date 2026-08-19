class Dialog_CrackhouseBuy
{
	idd = 75;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "";
	onUnload = "";
	class controls
	{
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT START (by David White, v1.063, #Surihy)
		////////////////////////////////////////////////////////
		class BackgroundImage: RscPicture
		{
			idc = 1200;
			text = "\A3PL_Common\GUI\A3FL_Warehouse.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class button_yes: RscButtonEmpty
		{
			idc = 1600;
			x = 0.416667 * safezoneW + safezoneX;
			y = 0.635185 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.033 * safezoneH;
			action = "call A3PL_Crackhouses_Buy; A3PL_Crackhouses_Object = nil;";
		};
		class button_no: RscButtonEmpty
		{
			idc = 1601;
			x = 0.505729 * safezoneW + safezoneX;
			y = 0.636111 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.033 * safezoneH;
			action = "closeDialog 0; A3PL_Crackhouses_Object = nil;";
		};
		class static_currentPrice: RscText
		{
			idc = 1000;
			text = "";
			x = 0.425521 * safezoneW + safezoneX;
			y = 0.518519 * safezoneH + safezoneY;
			w = 0.154687 * safezoneW;
			h = 0.044 * safezoneH;
			sizeEx = 1.3 * GUI_GRID_H;
		};
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT END
		////////////////////////////////////////////////////////
	};
};
