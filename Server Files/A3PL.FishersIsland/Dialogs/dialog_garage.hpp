class Dialog_Garage
{
	idd = 62;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "";
	onUnload = "";
	class controls
	{
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT START (by Kane, v1.063, #Sisisa)
		////////////////////////////////////////////////////////

		class static_bg: RscPicture
		{
			idc = 1200;
			text = "\A3PL_Common\GUI\A3PL_Garage.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class lb_upgrades: RscListbox
		{
			idc = 1500;
			x = 0.730729 * safezoneW + safezoneX;
			y = 0.0898143  * safezoneH + safezoneY;
			w = 0.2475 * safezoneW;
			h = 0.22 * safezoneH;
		};
		class lb_requiredupgrade: RscListbox
		{
			idc = 1501;
			x = 0.734375 * safezoneW + safezoneX;
			y = 0.439815 * safezoneH + safezoneY;
			w = 0.242344 * safezoneW;
			h = 0.132 * safezoneH;
		};
		class lb_repairlist: RscListbox
		{
			idc = 1502;
			x = 0.0229164 * safezoneW + safezoneX;
			y = 0.0916664 * safezoneH + safezoneY;
			w = 0.242344 * safezoneW;
			h = 0.154 * safezoneH;
		};
		class lb_requiredrepair: RscListbox
		{
			idc = 1503;
			x = 0.025 * safezoneW + safezoneX;
			y = 0.350926 * safezoneH + safezoneY;
			w = 0.242344 * safezoneW;
			h = 0.132 * safezoneH;
		};
		class lb_painttextures: RscListbox
		{
			idc = 1504;
			x = 0.0197919 * safezoneW + safezoneX;
			y = 0.790407 * safezoneH + safezoneY;
			w = 0.252656 * safezoneW;
			h = 0.11 * safezoneH;
		};
		class struc_damage: RscStructuredText
		{
			idc = 1100;
			text = "<t align='center' size ='1.4'> 0% </t>";
			x = 0.0723959 * safezoneW + safezoneX;
			y = 0.257407 * safezoneH + safezoneY;
			w = 0.108281 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class struc_desc: RscStructuredText
		{
			idc = 1101;
			text = "<t align='center' size ='1'></t>";
			x = 0.778125 * safezoneW + safezoneX;
			y = 0.321296 * safezoneH + safezoneY;
			w = 0.195937 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class struc_upgradeprice: RscStructuredText
		{
			idc = 1102;
			text = "<t align='center' size ='1.2'></t>";
			x = 0.751563 * safezoneW + safezoneX;
			y = 0.357407 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class button_upgrade: RscButtonEmpty
		{
			idc = 1600;
			x = 0.791146 * safezoneW + safezoneX;
			y = 0.600926 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class button_repair: RscButtonEmpty
		{
			idc = 1601;
			x = 0.0781247 * safezoneW + safezoneX;
			y = 0.511111 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class button_painttexture: RscButtonEmpty
		{
			idc = 1602;
			x = 0.0291664 * safezoneW + safezoneX;
			y = 0.908334 * safezoneH + safezoneY;
			w = 0.108281 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class button_paintrgb: RscButtonEmpty
		{
			idc = 1603;
			x = 0.151042 * safezoneW + safezoneX;
			y = 0.908333 * safezoneH + safezoneY;
			w = 0.108281 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class button_close: RscButtonEmpty
		{
			idc = 1604;
			x = 0.959427 * safezoneW + safezoneX;
			y = 0.02037 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.055 * safezoneH;
			action = "closeDialog 0;";
		};
		class RscEditRed: RscEdit
		{
			idc = 1400;
			text = "0";
			style = "16 + 512";
			x = 0.0489583 * safezoneW + safezoneX;
			y = 0.677778 * safezoneH + safezoneY;
			w = 0.221719 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class RscEditGreen: RscEdit
		{
			idc = 1401;
			text = "0";
			style = "16 + 512";
			x = 0.0483857 * safezoneW + safezoneX;
			y = 0.716667 * safezoneH + safezoneY;
			w = 0.221719 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class RscEditBlue: RscEdit
		{
			idc = 1402;
			text = "0";
			style = "16 + 512";
			x = 0.0483855 * safezoneW + safezoneX;
			y = 0.75463 * safezoneH + safezoneY;
			w = 0.221719 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class lb_materials: RscListbox
		{
			idc = 1505;
			x = 0.380208 * safezoneW + safezoneX;
			y = 0.0962965 * safezoneH + safezoneY;
			w = 0.242344 * safezoneW;
			h = 0.132 * safezoneH;
		};
		class button_setMaterial: RscButtonEmpty
		{
			idc = 1605;
			x = 0.4375 * safezoneW + safezoneX;
			y = 0.25463 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;
		};

		class edit_licenseplate: RscEditInvisible
		{
			idc = 1405;
			style = "16 + 512";
			x = 0.736458 * safezoneW + safezoneX;
			y = 0.814815 * safezoneH + safezoneY;
			w = 0.237187 * safezoneW;
			h = 0.066 * safezoneH;
		};
		
		class button_setLicensePlate: RscButtonEmpty
		{
			idc = 1606;
			x = 0.791667 * safezoneW + safezoneX;
			y = 0.912963 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;
		};		
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT END
		////////////////////////////////////////////////////////
	};
};