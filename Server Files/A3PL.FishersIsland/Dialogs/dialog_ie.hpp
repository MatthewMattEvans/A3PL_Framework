class Dialog_IE
{
	idd = 48;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "";
	onUnload = "";
	class controls
	{
		class static_bg: RscPicture
		{
			idc = 1200;
			text = "\A3PL_Common\GUI\A3PL_ImportSystem.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class lb_availableitems: RscListbox
		{
			idc = 1500;
			x = 0.195781 * safezoneW + safezoneX;
			y = 0.269 * safezoneH + safezoneY;
			w = 0.20625 * safezoneW;
			h = 0.506 * safezoneH;
		};
		class lb_myshipments: RscListbox
		{
			idc = 1501;
			x = 0.601041 * safezoneW + safezoneX;
			y = 0.266667 * safezoneH + safezoneY;
			w = 0.20625 * safezoneW;
			h = 0.506 * safezoneH;
		};
		class edit_currentimport: RscEditInvisible
		{
			idc = 1400;
			x = 0.458854 * safezoneW + safezoneX;
			y = 0.267593 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.022 * safezoneH;
			canModify = 0;
			style = "16 + 512";
		};
		class edit_currentexport: RscEditInvisible
		{
			idc = 1401;
			x = 0.458854 * safezoneW + safezoneX;
			y = 0.337963 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.022 * safezoneH;
			canModify = 0;
			style = "16 + 512";
		};
		class edit_amount: RscEditInvisible
		{
			idc = 1402;
			x = 0.458854 * safezoneW + safezoneX;
			y = 0.407407 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.022 * safezoneH;
			text = "1";
			style = "16 + 512";
		};
		class button_import: RscButtonEmpty
		{
			idc = -1;
			x = 0.463647 * safezoneW + safezoneX;
			y = 0.534259 * safezoneH + safezoneY;
			w = 0.0721875 * safezoneW;
			h = 0.033 * safezoneH;
			action = "[true] call A3PL_IE_addShipment;";
		};
		class button_export: RscButtonEmpty
		{
			idc = -1;
			x = 0.463021 * safezoneW + safezoneX;
			y = 0.570371 * safezoneH + safezoneY;
			w = 0.0721875 * safezoneW;
			h = 0.033 * safezoneH;
			action = "[false] call A3PL_IE_addShipment;";
		};
		class button_retrieve: RscButtonEmpty
		{
			idc = -1;
			x = 0.517187 * safezoneW + safezoneX;
			y = 0.753704 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.033 * safezoneH;
			action = "call A3PL_IE_collectShipment;";
		};
		class edit_totalprice: RscEditInvisible
		{
			idc = 1403;
			x = 0.458854 * safezoneW + safezoneX;
			y = 0.477778 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.022 * safezoneH;
			sizeEx = 0.025;
			canModify = 0;
			style = "16 + 512";
		};
		class close: RscButtonEmpty
		{
			idc = 1603;
			x = 0.790625 * safezoneW + safezoneX;
			y = 0.163889 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.055 * safezoneH;
			action="closeDialog 0;";
		};
	};
};