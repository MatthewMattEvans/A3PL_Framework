class Dialog_SpawnMenu
{
	idd = 130;
	name= "Dialog_SpawnMenu";
	movingEnable = false;
	enableSimulation = true;
	class controls
	{
		class RscPicture_1200: RscPicture
		{
			idc = 1200;
			text = "\A3PL_Common\GUI\A3FL_SpawnMenu.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class button_spawn: RscButtonEmpty
		{
			idc = 1603;
			x = 0.630208 * safezoneW + safezoneX;
			y = 0.744445  * safezoneH + safezoneY;
			w = 0.185625 * safezoneW;
			h = 0.044 * safezoneH;
			action = "call A3PL_Player_SelectSpawn;";
		};
		class list: RscListbox
		{
			idc = 1500;
			x = 0.207813 * safezoneW + safezoneX;
			y = 0.237963 * safezoneH + safezoneY;
			w = 0.170156 * safezoneW;
			h = 0.495 * safezoneH;
			size = 0.7;
		};
		class map: RscMapControl
		{
			idc = 1700;
			x = 0.389584 * safezoneW + safezoneX;
			y = 0.243518 * safezoneH + safezoneY;
			w = 0.422812 * safezoneW;
			h = 0.484 * safezoneH;
		};
	};
};