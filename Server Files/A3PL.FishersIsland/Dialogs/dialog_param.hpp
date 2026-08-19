////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Franklin Hawks, v1.063, #Livypi)
////////////////////////////////////////////////////////
class Dialog_Param
{
	idd = 984210;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "";
	onUnload = "";
	class controls
	{
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT START (by Franklin Hawks, v1.063, #Gikopy)
		////////////////////////////////////////////////////////

		class IGUIBack_2200: IGUIBack
		{
			idc = 2200;
			x = 0.26 * GUI_GRID_W + GUI_GRID_X;
			y = 0.26 * GUI_GRID_H + GUI_GRID_Y;
			w = 39.5 * GUI_GRID_W;
			h = 24.5 * GUI_GRID_H;
		};
		class IGUIBack_2201: IGUIBack
		{
			idc = 2201;
			x = 0.303644 * safezoneW + safezoneX;
			y = 0.283012 * safezoneH + safezoneY;
			w = 0.391768 * safezoneW;
			h = 0.473054 * safezoneH;
		};
		class RscText_1000: RscText
		{
			idc = 1000;
			text = "STR_UI_Settings_Title"; //--- ToDo: Localize;
			x = 0.302105 * safezoneW + safezoneX;
			y = 0.243644 * safezoneH + safezoneY;
			w = 0.0927871 * safezoneW;
			h = 0.0440051 * safezoneH;
		};





		class TwitterBtn: RscButton
		{
			idc = 1600;
			text = "STR_UI_Settings_ActiveOrNot"; //--- ToDo: Localize;
			x = 0.305654 * safezoneW + safezoneX;
			y = 0.2966 * safezoneH + safezoneY;
			w = 0.0824774 * safezoneW;
			h = 0.0330038 * safezoneH;
			action = "[1600] call A3PL_Player_ParamToggle;";
		};
		class TwitterText: RscText
		{
			idc = 1001;
			text = "STR_UI_Settings_ShowTwitter"; //--- ToDo: Localize;
			x = 0.392336 * safezoneW + safezoneX;
			y = 0.296135 * safezoneH + safezoneY;
			w = 0.0927871 * safezoneW;
			h = 0.0220025 * safezoneH;
		};
		class TwitterActiveText: RscText
		{
			idc = 1002;
			x = 0.392849 * safezoneW + safezoneX;
			y = 0.318629 * safezoneH + safezoneY;
			w = 0.0463935 * safezoneW;
			h = 0.0220025 * safezoneH;
		};





		class PlayerIDActiveText: RscText
		{
			idc = 1005;
			x = 0.393875 * safezoneW + safezoneX;
			y = 0.449853 * safezoneH + safezoneY;
			w = 0.0463935 * safezoneW;
			h = 0.0220025 * safezoneH;
		};
		class RscText_1004: RscText
		{
			idc = 1004;
			text = "STR_UI_Settings_ShowID"; //--- ToDo: Localize;
			x = 0.393874 * safezoneW + safezoneX;
			y = 0.428296 * safezoneH + safezoneY;
			w = 0.17011 * safezoneW;
			h = 0.0220025 * safezoneH;
		};
		class PlayerIDBtn: RscButton
		{
			idc = 1601;
			text = "STR_UI_Settings_ActiveOrNot"; //--- ToDo: Localize;
			x = 0.305695 * safezoneW + safezoneX;
			y = 0.43017 * safezoneH + safezoneY;
			w = 0.0824774 * safezoneW;
			h = 0.0330038 * safezoneH;
			action = "[1601] call A3PL_Player_ParamToggle;";
		};





		class HUDButton: RscButton
		{
			idc = 1605;
			text = "STR_UI_Settings_ActiveOrNot"; //--- ToDo: Localize;
			x = 0.309283 * safezoneW + safezoneX;
			y = 0.627006 * safezoneH + safezoneY;
			w = 0.0824774 * safezoneW;
			h = 0.0330038 * safezoneH;
			action = "[1605] call A3PL_Player_ParamToggle;";
		};
		class RscText_1011: RscText
		{
			idc = 1011;
			text = "STR_UI_Settings_ShowHUD"; //--- ToDo: Localize;
			x = 0.394901 * safezoneW + safezoneX;
			y = 0.626069 * safezoneH + safezoneY;
			w = 0.17011 * safezoneW;
			h = 0.0220025 * safezoneH;
		};
		class HUDActiveText: RscText
		{
			idc = 1012;
			x = 0.3949 * safezoneW + safezoneX;
			y = 0.647627 * safezoneH + safezoneY;
			w = 0.0463935 * safezoneW;
			h = 0.0220025 * safezoneH;
		};





		class MetricsBtn: RscButton
		{
			idc = 1606;
			text = "STR_UI_Settings_ActiveOrNot"; //--- ToDo: Localize;
			x = 0.310308 * safezoneW + safezoneX;
			y = 0.694493 * safezoneH + safezoneY;
			w = 0.0824774 * safezoneW;
			h = 0.0330038 * safezoneH;
			action = "[1606] call A3PL_Player_ParamToggle;";
		};
		class RscText_1013: RscText
		{
			idc = 1013;
			text = "STR_UI_Settings_UseMetrics"; //--- ToDo: Localize;
			x = 0.394901 * safezoneW + safezoneX;
			y = 0.691681 * safezoneH + safezoneY;
			w = 0.17011 * safezoneW;
			h = 0.0220025 * safezoneH;
		};
		class UseMetricsActiveText: RscText
		{
			idc = 1014;
			x = 0.395414 * safezoneW + safezoneX;
			y = 0.714176 * safezoneH + safezoneY;
			w = 0.0463935 * safezoneW;
			h = 0.0220025 * safezoneH;
		};
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT END
		////////////////////////////////////////////////////////

	};
};