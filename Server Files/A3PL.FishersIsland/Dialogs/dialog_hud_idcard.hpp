class Dialog_HUD_IDCard
{
	idd = 12345;
	fadeout = 0;
	fadein = 0;
	duration = 1e+1000;
	onLoad = "disableSerialization; uiNamespace setVariable ['A3PL_HUD_IDCard',_this select 0];";
	onUnload = "";
	class controlsBackground
	{
		class RscIDCard: RscPicture
		{
			idc = 999;
			text = "\A3PL_Common\GUI\Cards\Card_CIV.paa";
			x = 0.619427 * safezoneW + safezoneX;
			y = 0.212037 * safezoneH + safezoneY;
			w = 0.319688 * safezoneW;
			h = 0.572 * safezoneH;
		};
	};
	class controls
	{
		class PLAYERID: RscStructuredText
		{
			idc = 1000;
			x = 0.739583 * safezoneW + safezoneX;
			y = 0.405556 * safezoneH + safezoneY;
			w = 0.190781 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class PLAYERFNAME: RscStructuredText
		{
			idc = 1001;
			x = 0.761458 * safezoneW + safezoneX;
			y = 0.460185 * safezoneH + safezoneY;
			w = 0.165 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class PLAYERLNAME: RscStructuredText
		{
			idc = 1002;
			x = 0.761459 * safezoneW + safezoneX;
			y = 0.431481 * safezoneH + safezoneY;
			w = 0.165 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class PLAYERDOB: RscStructuredText
		{
			idc = 1003;
			x = 0.837187 * safezoneW + safezoneX;
			y = 0.48889 * safezoneH + safezoneY;
			w = 0.0876563 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class PLAYERGENDER: RscStructuredText
		{
			idc = 1004;
			x = 0.735417 * safezoneW + safezoneX;
			y = 0.488889 * safezoneH + safezoneY;
			w = 0.061875 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class PLAYERPASS: RscStructuredText
		{
			idc = 1005;
			x = 0.769792 * safezoneW + safezoneX;
			y = 0.576851 * safezoneH + safezoneY;
			w = 0.154687 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class PLAYERLICENSES: RscStructuredText
		{
			idc = 1006;
			x = 0.753801 * safezoneW + safezoneX;
			y = 0.516889 * safezoneH + safezoneY;
			w = 0.175313 * safezoneW;
			h = 0.055 * safezoneH;
		};
	};
};

class Dialog_HUD_FactionCard
{
	idd = 12346;
	fadeout = 0;
	fadein = 0;
	duration = 1e+1000;
	onLoad = "disableSerialization; uiNamespace setVariable ['A3PL_HUD_FactionCard',_this select 0];";
	onUnload = "";
	class controlsBackground
	{
		class RscFactionCard: RscPicture
		{
			idc = 999;
			text = "";
			x = 0.619427 * safezoneW + safezoneX;
			y = 0.212037 * safezoneH + safezoneY;
			w = 0.319688 * safezoneW;
			h = 0.572 * safezoneH;
		};
	};
	class controls
	{
		class PLAYERID: RscStructuredText
        {
            idc = 1000;
            x = 0.739583 * safezoneW + safezoneX;
			y = 0.405556 * safezoneH + safezoneY;
			w = 0.190781 * safezoneW;
			h = 0.022 * safezoneH;
        };
        class PLAYERFNAME: RscStructuredText
        {
            idc = 1001;
            x = 0.761458 * safezoneW + safezoneX;
			y = 0.460185 * safezoneH + safezoneY;
			w = 0.165 * safezoneW;
			h = 0.022 * safezoneH;
        };
        class PLAYERLNAME: RscStructuredText
        {
            idc = 1002;
            x = 0.761459 * safezoneW + safezoneX;
			y = 0.431481 * safezoneH + safezoneY;
			w = 0.165 * safezoneW;
			h = 0.022 * safezoneH;
        };
		class PLAYERFACTION: RscStructuredText
		{
			idc = 1003;
			x = 0.748438 * safezoneW + safezoneX;
			y = 0.487963 * safezoneH + safezoneY;
			w = 0.134062 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class PLAYERRANK: RscStructuredText
		{
			idc = 1004;
			x = 0.741301 * safezoneW + safezoneX;
			y = 0.518741 * safezoneH + safezoneY;
			w = 0.139219 * safezoneW;
			h = 0.022 * safezoneH;
		};
	};
};

class Dialog_HUD_CompanyCard
{
	idd = 12347;
	fadeout = 0;
	fadein = 0;
	duration = 1e+1000;
	onLoad = "disableSerialization; uiNamespace setVariable ['A3FL_HUD_CompanyCard',_this select 0];";
	onUnload = "";
	class controlsBackground
	{
		class RscCompanyCard: RscPicture
		{
			idc = 999;
			text = "";
			x = 0.619427 * safezoneW + safezoneX;
			y = 0.212037 * safezoneH + safezoneY;
			w = 0.319688 * safezoneW;
			h = 0.572 * safezoneH;
		};
	};
	class controls
	{
		class PLAYERID: RscStructuredText
        {
            idc = 1000;
           x = 0.739583 * safezoneW + safezoneX;
			y = 0.405556 * safezoneH + safezoneY;
			w = 0.190781 * safezoneW;
			h = 0.022 * safezoneH;
        };
        class PLAYERFNAME: RscStructuredText
        {
            idc = 1001;
             x = 0.761458 * safezoneW + safezoneX;
			y = 0.460185 * safezoneH + safezoneY;
			w = 0.165 * safezoneW;
			h = 0.022 * safezoneH;
        };
        class PLAYERLNAME: RscStructuredText
        {
            idc = 1002;
            x = 0.761459 * safezoneW + safezoneX;
			y = 0.431481 * safezoneH + safezoneY;
			w = 0.165 * safezoneW;
			h = 0.022 * safezoneH;
        };
		class COMPANYNAME: RscStructuredText
		{
			idc = 1003;
			x = 0.757813 * safezoneW + safezoneX;
			y = 0.488889 * safezoneH + safezoneY;
			w = 0.134062 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class COMPANYRANK: RscStructuredText
		{
			idc = 1004;
			x = 0.776197 * safezoneW + safezoneX;
			y = 0.517815 * safezoneH + safezoneY;
			w = 0.139219 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class COMPANYLICENSES: RscStructuredText
		{
			idc = 1005;
			x = 0.785416 * safezoneW + safezoneX;
			y = 0.545371 * safezoneH + safezoneY;
			w = 0.144375 * safezoneW;
			h = 0.055 * safezoneH;
		};
	};
};
