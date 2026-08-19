class Dialog_Keypad
{
	idd = 697356;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "";
	onUnload = "";
	class controls
	{
		class keypad_background: RscPicture
		{
			idc = 1200;
			text = "\A3PL_Common\GUI\keypad\keypad.paa";
			x = 0.398255 * safezoneW + safezoneX;
			y = 0.296456 * safezoneH + safezoneY;
			w = 0.185625 * safezoneW;
			h = 0.38445 * safezoneH;
		};
		class faded_1: RscPicture
		{
			idc = 1201;
			text = "\A3PL_Common\GUI\keypad\faded_1.paa";
			x = 0.398169 * safezoneW + safezoneX;
			y = 0.306779 * safezoneH + safezoneY;
			w = 0.185625 * safezoneW;
			h = 0.354877 * safezoneH;
		};
		class faded_2: RscPicture
		{
			idc = 1202;
			text = "\A3PL_Common\GUI\keypad\faded_2.paa";
			x = 0.401496 * safezoneW + safezoneX;
			y = 0.303672 * safezoneH + safezoneY;
			w = 0.17875 * safezoneW;
			h = 0.364734 * safezoneH;
		};
		class faded_3: RscPicture
		{
			idc = 1203;
			text = "\A3PL_Common\GUI\keypad\faded_3.paa";
			x = 0.402907 * safezoneW + safezoneX;
			y = 0.303402 * safezoneH + safezoneY;
			w = 0.17875 * safezoneW;
			h = 0.364734 * safezoneH;
		};
		class faded_4: RscPicture
		{
			idc = 1204;
			text = "\A3PL_Common\GUI\keypad\faded_4.paa";
			x = 0.401744 * safezoneW + safezoneX;
			y = 0.305486 * safezoneH + safezoneY;
			w = 0.17875 * safezoneW;
			h = 0.364734 * safezoneH;
		};
		class faded_5: RscPicture
		{
			idc = 1205;
			text = "\A3PL_Common\GUI\keypad\faded_5.paa";
			x = 0.400262 * safezoneW + safezoneX;
			y = 0.305625 * safezoneH + safezoneY;
			w = 0.17875 * safezoneW;
			h = 0.364734 * safezoneH;
		};
		class faded_6: RscPicture
		{
			idc = 1206;
			text = "\A3PL_Common\GUI\keypad\faded_6.paa";
			x = 0.402907 * safezoneW + safezoneX;
			y = 0.305486 * safezoneH + safezoneY;
			w = 0.17875 * safezoneW;
			h = 0.364734 * safezoneH;
		};
		class faded_7: RscPicture
		{
			idc = 1207;
			text = "\A3PL_Common\GUI\keypad\faded_7.paa";
			x = 0.4 * safezoneW + safezoneX;
			y = 0.30757 * safezoneH + safezoneY;
			w = 0.17875 * safezoneW;
			h = 0.364734 * safezoneH;
		};
		class faded_8: RscPicture
		{
			idc = 1208;
			text = "\A3PL_Common\GUI\keypad\faded_8.paa";
			x = 0.401744 * safezoneW + safezoneX;
			y = 0.306876 * safezoneH + safezoneY;
			w = 0.17875 * safezoneW;
			h = 0.364734 * safezoneH;
		};
		class faded_9: RscPicture
		{
			idc = 1209;
			text = "\A3PL_Common\GUI\keypad\faded_9.paa";
			x = 0.402907 * safezoneW + safezoneX;
			y = 0.30757 * safezoneH + safezoneY;
			w = 0.17875 * safezoneW;
			h = 0.364734 * safezoneH;
		};
		class faded_0: RscPicture
		{
			idc = 1210;
			text = "\A3PL_Common\GUI\keypad\faded_9.paa";
			x = 0.365116 * safezoneW + safezoneX;
			y = 0.344388 * safezoneH + safezoneY;
			w = 0.17875 * safezoneW;
			h = 0.364734 * safezoneH;
		};
		class faded_hashtag: RscPicture
		{
			idc = 1211;
			text = "\A3PL_Common\GUI\keypad\faded_9.paa";
			x = 0.402907 * safezoneW + safezoneX;
			y = 0.343695 * safezoneH + safezoneY;
			w = 0.17875 * safezoneW;
			h = 0.364734 * safezoneH;
		};
		class faded_star: RscPicture
		{
			idc = 1212;
			text = "\A3PL_Common\GUI\keypad\faded_9.paa";
			x = 0.326744 * safezoneW + safezoneX;
			y = 0.343695 * safezoneH + safezoneY;
			w = 0.17875 * safezoneW;
			h = 0.364734 * safezoneH;
		};
		class button_1: RscButtonEmpty
		{
			idc = 1600;
			x = 0.437209 * safezoneW + safezoneX;
			y = 0.419416 * safezoneH + safezoneY;
			w = 0.0275 * safezoneW;
			h = 0.0295731 * safezoneH;
		};
		class button_2: RscButtonEmpty
		{
			idc = 1601;
			x = 0.475 * safezoneW + safezoneX;
			y = 0.418721 * safezoneH + safezoneY;
			w = 0.0275 * safezoneW;
			h = 0.0295731 * safezoneH;
		};
		class button_3: RscButtonEmpty
		{
			idc = 1602;
			x = 0.514535 * safezoneW + safezoneX;
			y = 0.415943 * safezoneH + safezoneY;
			w = 0.0275 * safezoneW;
			h = 0.0295731 * safezoneH;
		};
		class button_4: RscButtonEmpty
		{
			idc = 1603;
			x = 0.438372 * safezoneW + safezoneX;
			y = 0.454845 * safezoneH + safezoneY;
			w = 0.0275 * safezoneW;
			h = 0.0295731 * safezoneH;
		};
		class button_5: RscButtonEmpty
		{
			idc = 1604;
			x = 0.476163 * safezoneW + safezoneX;
			y = 0.455539 * safezoneH + safezoneY;
			w = 0.0275 * safezoneW;
			h = 0.0295731 * safezoneH;
		};
		class button_6: RscButtonEmpty
		{
			idc = 1605;
			x = 0.514535 * safezoneW + safezoneX;
			y = 0.454845 * safezoneH + safezoneY;
			w = 0.0275 * safezoneW;
			h = 0.0295731 * safezoneH;
		};
		class button_7: RscButtonEmpty
		{
			idc = 1606;
			x = 0.438372 * safezoneW + safezoneX;
			y = 0.491664 * safezoneH + safezoneY;
			w = 0.0275 * safezoneW;
			h = 0.0295731 * safezoneH;
		};
		class button_8: RscButtonEmpty
		{
			idc = 1607;
			x = 0.475 * safezoneW + safezoneX;
			y = 0.490275 * safezoneH + safezoneY;
			w = 0.0275 * safezoneW;
			h = 0.0295731 * safezoneH;
		};
		class button_9: RscButtonEmpty
		{
			idc = 1608;
			x = 0.514535 * safezoneW + safezoneX;
			y = 0.492359 * safezoneH + safezoneY;
			w = 0.0275 * safezoneW;
			h = 0.0295731 * safezoneH;
		};
		class button_0: RscButtonEmpty
		{
			idc = 1609;
			x = 0.475581 * safezoneW + safezoneX;
			y = 0.528483 * safezoneH + safezoneY;
			w = 0.0275 * safezoneW;
			h = 0.0295731 * safezoneH;
		};
		class button_hashtag: RscButtonEmpty
		{
			idc = 1610;
			x = 0.514535 * safezoneW + safezoneX;
			y = 0.530567 * safezoneH + safezoneY;
			w = 0.0275 * safezoneW;
			h = 0.0295731 * safezoneH;
		};
		class button_star: RscButtonEmpty
		{
			idc = 1611;
			x = 0.437209 * safezoneW + safezoneX;
			y = 0.527788 * safezoneH + safezoneY;
			w = 0.0275 * safezoneW;
			h = 0.0295731 * safezoneH;
		};
		class text: RscText
		{
			idc = 1000;
			text = "";
			x = 0.587297 * safezoneW + safezoneX;
			y = 0.326458 * safezoneH + safezoneY;
			w = 0.1925 * safezoneW;
			h = 0.325304 * safezoneH;
		};
	};
};
