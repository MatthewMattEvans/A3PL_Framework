class RscDisplayVehicleRepair
{
	idd = 2900;
	name = "RscDisplayVehicleRepair";
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "";
	onUnload = "";
	class controls
	{
		class BackgroundImage: RscPicture
		{
			idc = -1;
			text = "\A3PL_Common\GUI\Repair.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class REPAIR_LIST: RscListBox
		{
			idc = 2901;
			onLBSelChanged = "_this call A3PL_Vehicle_RepairLbSelChanged;";
			rowHeight = 0.04;

			x = 0.276042 * safezoneW + safezoneX;
			y = 0.488889 * safezoneH + safezoneY;
			w = 0.118594 * safezoneW;
			h = 0.143 * safezoneH;
		};

		class REPAIR_CHECKBOX: RscCheckBox
		{
			idc = 2902;
			onCheckedChanged = "[] call A3PL_Vehicle_RepairUpdate;";

			x = 0.40625 * safezoneW + safezoneX;
			y = 0.612963 * safezoneH + safezoneY;
			w = 0.01 * safezoneW;
			h = 0.02 * safezoneH;
		};
		class VEHICLE_STATE: RscStructuredText
		{
			idc = 2903;
			colorBackground[] = {0, 0, 0, 0.6};

			x = 0.275521 * safezoneW + safezoneX;
			y = 0.439815 * safezoneH + safezoneY;
			w = 0.118594 * safezoneW;
			h = 0.022 * safezoneH;
		};

		class PART_NAME: RscStructuredText
		{
			idc = 2905;
			colorBackground[] = {0, 0, 0, 0.6};

			x = 0.410417 * safezoneW + safezoneX;
			y = 0.439814  * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.022 * safezoneH;
		};

		class PART_STATE: RscStructuredText
		{
			idc = 2907;
			colorBackground[] = {0, 0, 0, 0.6};

			x = 0.490104 * safezoneW + safezoneX;
			y = 0.439815 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.022 * safezoneH;
		};

		class PART_TOOL: RscStructuredText
		{
			idc = 2908;
			colorBackground[] = {0, 0, 0, 0.6};

			x = 0.569792 * safezoneW + safezoneX;
			y = 0.439814 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.022 * safezoneH;
		};

		class PART_ITEM: RscStructuredText
		{
			idc = 2909;
			colorBackground[] = {0, 0, 0, 0.6};

			x = 0.65052 * safezoneW + safezoneX;
			y = 0.439815 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.022 * safezoneH;
		};

		class REPAIR_ACTION: RscButtonEmpty
		{
			idc = 2906;
			action = "[] spawn A3PL_Vehicle_RepairAction;";

			x = 0.655729 * safezoneW + safezoneX;
			y = 0.606481 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.033 * safezoneH;
		};
	};
};
