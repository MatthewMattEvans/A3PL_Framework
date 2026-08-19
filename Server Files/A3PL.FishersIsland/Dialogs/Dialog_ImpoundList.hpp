class Dialog_ImpoundList
{
	idd = 42;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "";
	onUnload = "";
	class controls
	{
		class BACKGRND: RscPicture
		{
			idc = 1200;
			text = "\A3PL_Common\GUI\dialog_PlayerGarage.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class L_ImpoundedVehicles: RscListbox
		{
			idc = 1500;
			x = 0.209896 * safezoneW + safezoneX;
			y = 0.232407 * safezoneH + safezoneY;
			w = 0.211406 * safezoneW;
			h = 0.506 * safezoneH;
			sizeEx = 0.85 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0};
		};
		class L_VehicleInfo: RscListbox
		{
			idc = 1501;
			x = 0.546874 * safezoneW + safezoneX;
			y = 0.234259 * safezoneH + safezoneY;
			w = 0.211406 * safezoneW;
			h = 0.350 * safezoneH;
			sizeEx = 0.85 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0};
		};
		class B_ReleaseVehicle: RscButtonEmpty
		{
			idc = -1;
			x = 0.271875 * safezoneW + safezoneX;
			y = 0.752778 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.033 * safezoneH;
			action = "call A3PL_JobRoadWorker_ReleaseVehicle;";
		};
	};
};
