class Dialog_Loading
{
	idd = 15;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "";
	onUnload = "";
	class controls
	{
		class static_loadingImage: RscPicture
		{
			idc = IDC_DIALOG_LOADING_BACKGROUND;
			text = "\A3PL_Common\GUI\A3FL_Loading_Screen.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class Progress_loadingbar: RscProgress
		{
			idc = IDC_DIALOG_LOADING_LOADINGBAR;
			colorFrame[] = {0.72,0.72,0.72,1};
			colorBar[] = {0.641,0.25,0.109,1};
			text = "#(argb,8,8,3)color(1,1,1,1)";
			x = 0.299389 * safezoneW + safezoneX;
			y = 0.757413 * safezoneH + safezoneY;
			w = 0.402029 * safezoneW;
			h = 0.0330069 * safezoneH;
		};
		class text_percentage: RscStructuredText
		{
			idc = IDC_DIALOG_LOADING_LOADINGHEADER;
			text = "50%"; 
			x = 0.300857 * safezoneW + safezoneX;
			y = 0.756399 * safezoneH + safezoneY;
			w = 0.396875 * safezoneW;
			h = 0.0330069 * safezoneH;
			sizeEx = 1 * GUI_GRID_H;
		};
	};
};