class Dialog_ImpoundMark
{
	idd = 41;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "";
	onUnload = "";
	class controls
	{
		class BACKGRND: RscPicture
		{
			idc = 1200;
			text = "\A3PL_Common\GUI\Confirmation.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class button_confirm: RscButton
		{
			idc = 1600;
			x = 0.413542 * safezoneW + safezoneX;
			y = 0.448148 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.033 * safezoneH;
			action = "call A3PL_Police_ImpoundConfirm;";
		};
		class button_cancel: RscButton
		{
			idc = 1601;
			x = 0.502604 * safezoneW + safezoneX;
			y = 0.447222 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.033 * safezoneH;
			action = "closeDialog 0;";
		};
		class static_label: RscText
		{
			idc = 1000;
			text = "STR_UI_ImpoundMark_Duration";
			x = 0.435938 * safezoneW + safezoneX;
			y = 0.327778 * safezoneH + safezoneY;
			w = 0.128906 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class edit_duration: RscEdit
		{
			idc = 1400;
			x = 0.436458 * safezoneW + safezoneX;
			y = 0.367592 * safezoneH + safezoneY;
			w = 0.080 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class combo_unit: RscCombo
		{
			idc = 1401;
			x = 0.520 * safezoneW + safezoneX;
			y = 0.367592 * safezoneH + safezoneY;
			w = 0.048 * safezoneW;
			h = 0.022 * safezoneH;
			onLoad = "(_this select 0) lbAdd 'Minutes'; (_this select 0) lbAdd 'Hours'; (_this select 0) lbAdd 'Days'; (_this select 0) lbSetCurSel 2;";
		};
		class CLOSE: RscButtonEmpty
		{
			idc = 1103;
			x = 0.6875 * safezoneW + safezoneX;
			y = 0.265629 * safezoneH + safezoneY;
			w = 0.020625 * safezoneW;
			h = 0.044 * safezoneH;
		};
	};
};
