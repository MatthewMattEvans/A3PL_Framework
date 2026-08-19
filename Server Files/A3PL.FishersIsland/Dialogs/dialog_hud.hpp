class Dialog_HUD
{
	idd = 1234;
	fadeout = 0;
	fadein = 0;
	duration = 1e+1000;
	onLoad = "disableSerialization; uiNamespace setVariable ['A3PL_HUDDisplay',_this select 0];";
	onUnload = "";
	class controlsBackground
	{
		class HUD_BACK: RscPicture
		{
			idc = 1500;
			text = "A3PL_Common\HUD\SingleHUD.paa";
			x = -0.0168236 * safezoneW + safezoneX;
			y = 0.156 * safezoneH + safezoneY;
			w = 0.912656 * safezoneW;
			h = 0.869  * safezoneH;
		};
		class JailTime: RscText
		{
			idc = 1000;
			text = "";
			x = 0.824844 * safezoneW + safezoneX;
			y = 0.819 * safezoneH + safezoneY;
			w = 0.170156 * safezoneW;
			h = 0.066 * safezoneH;
			sizeEx = "0.03 * safezoneH";
			style = 0x01;
		};
		class Icon_1: RscPicture
		{
			idc = 1200;

			x = 0.97025 * safezoneW + safezoneX;
			y = 0.159 * safezoneH + safezoneY;
			w = 0.02475 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class Icon_2: RscPicture
		{
			idc = 1201;

			x = 0.97025 * safezoneW + safezoneX;
			y = 0.214 * safezoneH + safezoneY;
			w = 0.02475 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class Icon_3: RscPicture
		{
			idc = 1202;

			x = 0.97025 * safezoneW + safezoneX;
			y = 0.269 * safezoneH + safezoneY;
			w = 0.02475 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class Icon_4: RscPicture
		{
			idc = 1203;

			x = 0.97025 * safezoneW + safezoneX;
			y = 0.324 * safezoneH + safezoneY;
			w = 0.02475 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class Icon_5: RscPicture
		{
			idc = 1204;

			x = 0.97025 * safezoneW + safezoneX;
			y = 0.379 * safezoneH + safezoneY;
			w = 0.02475 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class Icon_6: RscPicture
		{
			idc = 1205;

			x = 0.97025 * safezoneW + safezoneX;
			y = 0.434 * safezoneH + safezoneY;
			w = 0.02475 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class Icon_7: RscPicture
		{
			idc = 1206;
	
			x = 0.97025 * safezoneW + safezoneX;
			y = 0.489 * safezoneH + safezoneY;
			w = 0.02475 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class Icon_8: RscPicture
		{
			idc = 1207;

			x = 0.97025 * safezoneW + safezoneX;
			y = 0.544 * safezoneH + safezoneY;
			w = 0.02475 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class Icon_9: RscPicture
		{
			idc = 1208;

			x = 0.97025 * safezoneW + safezoneX;
			y = 0.599 * safezoneH + safezoneY;
			w = 0.02475 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class Icon_10: RscPicture
		{
			idc = 1209;

			x = 0.97025 * safezoneW + safezoneX;
			y = 0.654 * safezoneH + safezoneY;
			w = 0.02475 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class struc_system: RscStructuredText
		{
			idc = 1104;
			x = 0.0101562 * safezoneW + safezoneX;
			y = 0.25 * safezoneH + safezoneY;
			w = 0.45937 * safezoneW;
			h = 0.4 * safezoneH;
		};
	};
	class controls
	{
		class RscStreetBack: RscPicture
		{
			idc = 9521;
			text = "\A3PL_Common\HUD\street.paa";
			x = 0.340156 * safezoneW + safezoneX;
			y = -0.017 * safezoneH + safezoneY;
			w = 0.319688 * safezoneW;
			h = 0.308 * safezoneH;
		};
		class RscStreetText: RscStructuredText
		{
			idc = 9520;
			text = "Fisher Lane";
			x = 0.37625 * safezoneW + safezoneX;
			y = 0.038 * safezoneH + safezoneY;
			w = 0.252656 * safezoneW;
			h = 0.088 * safezoneH;
			colorBackground[] = {0,0,0,0};
		};
		class weaponpicture: RscPicture
        {
            idc = 16418;
            text = "";
            x = 0.768125 * safezoneW + safezoneX;
            y = 0.03 * safezoneH + safezoneY;
            w = 0.0567187 * safezoneW;
            h = 0.088 * safezoneH;
        };
        class weaponstatus: RscStructuredText
        {
            idc = 16419;
            text = "";
            x = 0.7475 * safezoneW + safezoneX;
            y = 0.01 * safezoneH + safezoneY;
            w = 0.0979687 * safezoneW;
            h = 0.033 * safezoneH;
            font = "EtelkaNarrowMediumPro";
        };
        class weaponname: RscStructuredText
        {
            idc = 16420;
            text = "";
            x = 0.824844 * safezoneW + safezoneX;
            y = 0.01 * safezoneH + safezoneY;
            w = 0.170156 * safezoneW;
            h = 0.033 * safezoneH;
            font = "EtelkaNarrowMediumPro";
        };
        class ammostatus: RscStructuredText
        {
            idc = 16421;
            text = "";
            x = 0.824844 * safezoneW + safezoneX;
            y = 0.05 * safezoneH + safezoneY;
            w = 0.170156 * safezoneW;
            h = 0.033 * safezoneH;
            font = "EtelkaNarrowMediumPro";
        };
        class magazinestatus: RscStructuredText
        {
            idc = 16422;
            text = "";
            x = 0.824844 * safezoneW + safezoneX;
            y = 0.08 * safezoneH + safezoneY;
            w = 0.170156 * safezoneW;
            h = 0.033 * safezoneH;
            font = "EtelkaNarrowMediumPro";
        };
        class zeroing: RscStructuredText
        {
            idc = 16423;
            text = "";
            x = 0.902187 * safezoneW + safezoneX;
            y = 0.049 * safezoneH + safezoneY;
            w = 0.0928125 * safezoneW;
            h = 0.033 * safezoneH;
            font = "EtelkaNarrowMediumPro";
        };
        class throwablestatus: RscStructuredText
        {
            idc = 16424;
            text = "";
            x = 0.783594 * safezoneW + safezoneX;
            y = 0.17 * safezoneH + safezoneY;
            w = 0.185625 * safezoneW;
            h = 0.033 * safezoneH;
            font = "EtelkaNarrowMediumPro";
        };
		class stuc_name: RscStructuredText
		{
			idc = 1600;
			text = "";
			x = 0.0145834 * safezoneW + safezoneX;
			y = 0.743518 * safezoneH + safezoneY;
			w = 0.113437 * safezoneW;
			h = 0.033 * safezoneH;
			sizeEx = "0.5 * safezoneH";
			class Attributes
			{
				font="RalewayExtraBold";
				color="#FFFFFF";
				align="left";
				shadow=0;
			};
		};
		class struc_job: RscStructuredText
		{
			idc = 1601;
			text = "";
			x = 0.0151042 * safezoneW + safezoneX;
			y = 0.774074 * safezoneH + safezoneY;
			w = 0.113437 * safezoneW;
			h = 0.033 * safezoneH;
			sizeEx = "1.5 * safezoneH";
			class Attributes
			{
				font="Raleway";
				color="#FFFFFF";
				align="left";
				shadow=0;
			};
		};
        class threatpicture: RscPicture
        {
            idc = 16576;
            text = "\A3PL_Common\HUD\threatLevel.paa";
            x = 0.977489 * safezoneW + safezoneX;
            y = 0.942638 * safezoneH + safezoneY;
            w = 0.0193328 * safezoneW;
            h = 0.044 * safezoneH;
        };
        class threatstatus: RscStructuredText
        {
            idc = 16577;
            text = "";
            x = 0.913872 * safezoneW + safezoneX;
            y = 0.942778 * safezoneH + safezoneY;
            w = 0.061865 * safezoneW;
            h = 0.044 * safezoneH;
            font = "EtelkaNarrowMediumPro";
        };
	};
};

class A3FL_SkilledUp
{
	idd = -1;
	movingEnable = 0;
	enableSimulation = 1;
	fadeout = 0.2;
	fadein = 0.2;
	duration = 6;
	onLoad = "uiNamespace setVariable ['A3FL_SkilledUp',_this#0];";
	class controls
	{
		class textExpInfo: RscStructuredText
		{
			idc = 1;
			text = "";
            x = 0.0046874 * safezoneW + safezoneX;
            y = 0.765279 * safezoneH + safezoneY;
            w = 0.0979687 * safezoneW;
            h = 0.022 * safezoneH;
			colorText[] = {0,0,0,1};
		};
		class textActionText: RscStructuredText
		{
			idc = 2;
			text = "";
			x = 0.103672 * safezoneW + safezoneX;
            y = 0.766334 * safezoneH + safezoneY;
            w = 0.0257812 * safezoneW;
            h = 0.022 * safezoneH;
			colorText[] = {0,0,0,1};
		};
		class progressLevelProgress: RscProgress
		{
			idc = 3;
			x = 0.00781284 * safezoneW + safezoneX;
			y = 0.786807 * safezoneH + safezoneY;
			w = 0.118594 * safezoneW;
			h = 0.011 * safezoneH;
			colorFrame[] = {0,0,0,0};
    		colorBackground[] = {0,0,0,0};
   	 		colorBar[] = {0.90588235294,0.49411764705,0.14901960784,0.9};
		};
	};
};
