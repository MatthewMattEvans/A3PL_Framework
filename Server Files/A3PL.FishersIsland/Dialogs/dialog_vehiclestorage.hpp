class Dialog_VehicleStorage
{
	idd = 30;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "";
	onUnload = "A3PL_Veh_Interact setVariable ['inuse',nil,true]; A3PL_Veh_Interact = nil;";
	class controls
	{
		class static_bg: RscPicture
		{
			idc = 1200;
			text = "\A3PL_Common\GUI\A3PL_HouseVirtual.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class lb_inventory: RscListbox
		{
			idc = 1500;
			x = 0.214062 * safezoneW + safezoneX;
			y = 0.275 * safezoneH + safezoneY;
			w = 0.211406 * safezoneW;
			h = 0.528 * safezoneH;
		};
		class lb_storage: RscListbox
		{
			idc = 1501;
			x = 0.553125 * safezoneW + safezoneX;
			y = 0.275926 * safezoneH + safezoneY;
			w = 0.211406 * safezoneW;
			h = 0.528 * safezoneH;
		};
		class button_store: RscButtonEmpty
		{
			idc = 1600;
			x = 0.459375 * safezoneW + safezoneX;
			y = 0.312963 * safezoneH + safezoneY;
			w = 0.061875 * safezoneW;
			h = 0.022 * safezoneH;
			action = "call A3PL_Vehicle_AddToVehicle;";
		};
		class button_close: RscButtonEmpty
		{
			idc = -1;
			x = 0.745313 * safezoneW + safezoneX;
			y = 0.167593 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.055 * safezoneH;
			action = "closeDialog 0;";
		};
		class button_take: RscButtonEmpty
		{
			idc = 1601;
			x = 0.45677 * safezoneW + safezoneX;
			y = 0.771296 * safezoneH + safezoneY;
			w = 0.061875 * safezoneW;
			h = 0.022 * safezoneH;
			action = "call A3PL_Vehicle_TakeFromVehicle;";
		};
		class edit_store: RscEditInvisible
		{
			idc = 1400;
			text = "1";
			style = "16 + 512";
			x = 0.445313 * safezoneW + safezoneX;
			y = 0.285185 * safezoneH + safezoneY;
			w = 0.0876563 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class edit_take: RscEditInvisible
		{
			idc = 1401;
			text = "1";
			style = "16 + 512";
			x = 0.446354 * safezoneW + safezoneX;
			y = 0.744444 * safezoneH + safezoneY;
			w = 0.0876563 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class InventoryCapacity: RscStructuredText
		{
			idc = 1100;
			x = 0.373177 * safezoneW + safezoneX;
			y = 0.236111 * safezoneH + safezoneY;
			w = 0.0515625 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class VehcileCapacity: RscStructuredText
		{
			idc = 1101;
			x = 0.7125 * safezoneW + safezoneX;
			y = 0.236111 * safezoneH + safezoneY;
			w = 0.0515625 * safezoneW;
			h = 0.033 * safezoneH;
		};
	};
};