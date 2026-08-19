class Dialog_Roommates
{
	idd = 87;
	name = "Dialog_Roommates";
	movingEnable = false;
	enableSimulation = true;
	class controls
	{
		class BackPicture: RscPicture
		{
			idc = -1;
			// Fix location.
			text = "\A3PL_Common\GUI\A3FL_Roommates.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class RoommateList: RscListbox
		{
			idc = 1500;
			x = 0.206771 * safezoneW + safezoneX;
			y = 0.241667 * safezoneH + safezoneY;
			w = 0.608437 * safezoneW;
			h = 0.484 * safezoneH;
		};
		class button_remove: RscButtonEmpty
		{
			idc = 1601;
			x = 0.369791 * safezoneW + safezoneX;
			y = 0.742592 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;
			action = "call A3PL_Housing_RemoveRoommate;";
		};
		class button_close: RscButtonEmpty
		{
			idc = 1602;
			x = 0.506771 * safezoneW + safezoneX;
			y = 0.744445 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;
			action = "A3PL_Warehouses_RoommatesOpen = nil; closeDialog 0;";
		};
	};
};
