class Dialog_ExecutiveMenu
{
	idd = 98;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "";
	onUnload = "";
	class controls
	{
		class static_bg: RscPicture
		{
			idc = 1200;
			text = "A3PL_Common\GUI\ExecutivePanel.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class PlayersList: RscListbox
		{
			idc = 1500;
			x = 0.226719 * safezoneW + safezoneX;
			y = 0.225 * safezoneH + safezoneY;
			w = 0.0876563 * safezoneW;
			h = 0.572 * safezoneH;
			sizeEx = .95 * GUI_GRID_H;
		};
		class FactoriesList: RscListbox
		{
			idc = 1501;
			x = 0.319531 * safezoneW + safezoneX;
			y = 0.225 * safezoneH + safezoneY;
			w = 0.144375 * safezoneW;
			h = 0.231 * safezoneH;
			sizeEx = 0.8 * GUI_GRID_H;
		};
		class InventoryList: RscListbox
		{
			idc = 1502;
			x = 0.474219 * safezoneW + safezoneX;
			y = 0.225 * safezoneH + safezoneY;
			w = 0.144375 * safezoneW;
			h = 0.231 * safezoneH;
			sizeEx = 0.8 * GUI_GRID_H;
		};
		class PlayersSearch: RscEdit
		{
			idc = 1400;
			x = 0.226719 * safezoneW + safezoneX;
			y = 0.203 * safezoneH + safezoneY;
			w = 0.0876563 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class FactoriesSwitch: RscCombo
		{
			idc = 2100;
			x = 0.319531 * safezoneW + safezoneX;
			y = 0.203 * safezoneH + safezoneY;
			w = 0.144375 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class InventorySwitch: RscCombo
		{
			idc = 2101;
			x = 0.474219 * safezoneW + safezoneX;
			y = 0.203 * safezoneH + safezoneY;
			w = 0.144375 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class PlayerInformation: RscListbox
		{
			idc = 1503;
			x = 0.634061 * safezoneW + safezoneX;
			y = 0.203 * safezoneH + safezoneY;
			w = 0.134062 * safezoneW;
			h = 0.187 * safezoneH;
		};
		class ActionsList: RscListbox
		{
			idc = 1504;
			x = 0.319531 * safezoneW + safezoneX;
			y = 0.478 * safezoneH + safezoneY;
			w = 0.144375 * safezoneW;
			h = 0.319 * safezoneH;
		};
		/*class TwitterTags: RscCombo
		{
			idc = 2102;
			x = 0.634062 * safezoneW + safezoneX;
			y = 0.401 * safezoneH + safezoneY;
			w = 0.134062 * safezoneW;
			h = 0.022 * safezoneH;
		};*/
		class FactionsList: RscCombo
		{
			idc = 2103;
			x = 0.634062 * safezoneW + safezoneX;
			y = 0.434 * safezoneH + safezoneY;
			w = 0.134062 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class MessageBox: RscEdit
		{
			idc = 1402;
			x = 0.474219 * safezoneW + safezoneX;
			y = 0.478 * safezoneH + safezoneY;
			w = 0.293906 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class DirectMessage: RscButton
		{
			idc = 2001;
			text = "STR_UI_ExecutiveMenu_DirectMessage";
			x = 0.654688 * safezoneW + safezoneX;
			y = 0.522 * safezoneH + safezoneY;
			w = 0.113437 * safezoneW;
			h = 0.022 * safezoneH;
			action = "call A3PL_Admin_DirectMessage;";
		};
		class GlobalMessage: RscButton
		{
			idc = 2002;
			text = "STR_UI_ExecutiveMenu_GlobalMessage";
			x = 0.474219 * safezoneW + safezoneX;
			y = 0.522 * safezoneH + safezoneY;
			w = 0.108281 * safezoneW;
			h = 0.022 * safezoneH;
			action = "call A3PL_Admin_GlobalMessage;";
		};
		class AdminOption_1: RscButton
		{
			idc = 2003;
			text = "STR_UI_ExecutiveMenu_AdminOption1";
			x = 0.474219 * safezoneW + safezoneX;
			y = 0.555 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.022 * safezoneH;
			action = "call A3PL_Admin_AddToPlayer;";
		};
		class AdminOption_2: RscButton
		{
			idc = 2004;
			text = "STR_UI_ExecutiveMenu_AdminOption2";
			x = 0.474219 * safezoneW + safezoneX;
			y = 0.588 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.022 * safezoneH;
			action = "call A3PL_Admin_AddToFactory;";
		};
		class AdminOption_3: RscButton
		{
			idc = 2005;
			text = "STR_UI_ExecutiveMenu_AdminOption3";
			x = 0.474219 * safezoneW + safezoneX;
			y = 0.621 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.022 * safezoneH;
			action = "['house'] call A3PL_Admin_AddToHouse;";
		};
		class AdminOption_4: RscButton
		{
			idc = 2006;
			text = "STR_UI_ExecutiveMenu_AdminOption4";
			x = 0.474219 * safezoneW + safezoneX;
			y = 0.654 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.022 * safezoneH;
			action = "['warehouse'] call A3PL_Admin_AddToHouse;";
		};
		class AdminOption_5: RscButton
		{
			idc = 2007;
			text = "STR_UI_ExecutiveMenu_AdminOption5";
			x = 0.474219 * safezoneW + safezoneX;
			y = 0.687 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.022 * safezoneH;
			action = "call A3PL_Admin_RemoveItem;";
		};
		class AdminOption_6: RscButton
		{
			idc = 2008;
            text = "STR_UI_ExecutiveMenu_AdminOption6";
			x = 0.474219 * safezoneW + safezoneX;
			y = 0.72 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.022 * safezoneH;
			action = "call A3PL_Admin_BypassTFAR;";
		};
		class AdminOption_7: RscButton
		{
			idc = 2009;
            text = "STR_UI_ExecutiveMenu_AdminOption7";
			x = 0.474219 * safezoneW + safezoneX;
			y = 0.753 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.022 * safezoneH;
			action = "call A3PL_Admin_PlayerMute;";
		};
		class AdminOption_8: RscButton
		{
			idc = 1016;
			text = "STR_UI_ExecutiveMenu_AdminOption8";
			x = 0.577344 * safezoneW + safezoneX;
			y = 0.555 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.022 * safezoneH;
			action = "[] spawn A3PL_Admin_MapTeleport;";
		};
		class AdminOption_9: RscButton
		{
			idc = 2010;
			text = "STR_UI_ExecutiveMenu_AdminOption9";
			x = 0.577344 * safezoneW + safezoneX;
			y = 0.753 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.022 * safezoneH;
			action = "hint 'AdminOption_9';";
		};
		class AdminOption_10: RscButton
		{
			idc = 2011;
			text = "STR_UI_ExecutiveMenu_AdminOption10";
			x = 0.577344 * safezoneW + safezoneX;
			y = 0.588 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.022 * safezoneH;
			action = "[] spawn A3PL_Admin_TeleportToMe;";
		};
		class AdminOption_11: RscButton
		{
			idc = 2012;
			text = "STR_UI_ExecutiveMenu_AdminOption11";
			x = 0.577344 * safezoneW + safezoneX;
			y = 0.621 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.022 * safezoneH;
			action = "call A3PL_Admin_TeleportTo;";
		};
		class AdminOption_12: RscButton
		{
			idc = 2013;
			text = "STR_UI_ExecutiveMenu_AdminOption12";
			x = 0.577344 * safezoneW + safezoneX;
			y = 0.654 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.022 * safezoneH;
			action = "call A3PL_Admin_Freeze;";
		};
		class AdminOption_13: RscButton
		{
			idc = 2014;
			text = "STR_UI_ExecutiveMenu_AdminOption13";
			x = 0.577344 * safezoneW + safezoneX;
			y = 0.687 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.022 * safezoneH;
			action = "call A3PL_Admin_HealPlayer;";
		};
		class AdminOption_14: RscButton
		{
			idc = 1017;
			text = "STR_UI_ExecutiveMenu_AdminOption14";
			x = 0.577344 * safezoneW + safezoneX;
			y = 0.72 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.022 * safezoneH;
			action = "[] spawn A3PL_Admin_Noclip;";
		};
		class AdminOption_15: RscButton
		{
			idc = 1015;
			text = "STR_UI_ExecutiveMenu_AdminOption15";
			x = 0.685625 * safezoneW + safezoneX;
			y = 0.555 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.022 * safezoneH;
			action = "[] spawn A3PL_Admin_RedName;";
		};
		class AdminOption_16: RscButton
		{
			idc = 2015;
			text = "STR_A3PL_Admin_FBIGear";
			x = 0.685625 * safezoneW + safezoneX;
			y = 0.588 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.022 * safezoneH;
			action = "[0] spawn A3PL_Admin_TakeGear;";
		};
		class AdminOption_17: RscButton
		{
			idc = 2016;
			text = "STR_A3PL_Admin_FDGear";
			x = 0.685625 * safezoneW + safezoneX;
			y = 0.621 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.022 * safezoneH;
			action = "[2] spawn A3PL_Admin_TakeGear;";
		};
		class AdminOption_18: RscButton
		{
			idc = 2017;
			text = "STR_A3PL_Admin_SavedGear";
			x = 0.685625 * safezoneW + safezoneX;
			y = 0.654 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.022 * safezoneH;
			action = "[1] spawn A3PL_Admin_TakeGear;";
		};
		class AdminOption_19: RscButton
		{
			idc = 2018;
			text = "STR_UI_ExecutiveMenu_AdminOption19";
			x = 0.685625 * safezoneW + safezoneX;
			y = 0.687 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.022 * safezoneH;
			action = "call A3PL_Admin_AdminIsland;";
		};
		class AdminOption_20: RscButton
		{
			idc = 2019;
			text = "STR_UI_ExecutiveMenu_AdminOption20";
			x = 0.685625 * safezoneW + safezoneX;
			y = 0.72 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.022 * safezoneH;
			action = "call A3PL_Admin_SaveServer;";
		};
		class AdminOption_21: RscButton
		{
			idc = 2020;
			text = "STR_UI_ExecutiveMenu_AdminOption21";
			x = 0.685625 * safezoneW + safezoneX;
			y = 0.753 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.022 * safezoneH;
			action = "call A3PL_Admin_CallLogger;";
		};
		class FactoriesSearch: RscEdit
		{
			idc = 1401;
			x = 0.319531 * safezoneW + safezoneX;
			y = 0.456 * safezoneH + safezoneY;
			w = 0.113437 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class FactoriesAmount: RscEdit
		{
			idc = 1403;
			text = "1";
			x = 0.432969 * safezoneW + safezoneX;
			y = 0.456 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.022 * safezoneH;
		};
	};
};

class Dialog_ExecutiveCallLogger
{
	idd = 99;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "";
	onUnload = "";
	class controls
	{
		class static_bg: RscPicture
		{
			idc = 1200;
			text = "A3PL_Common\GUI\ExecutivePanel.paa";
			x = 0.185469 * safezoneW + safezoneX;
			y = 0.159 * safezoneH + safezoneY;
			w = 0.629062 * safezoneW;
			h = 0.66 * safezoneH;
		};
		class RscText_1000: RscStructuredText
		{
			idc = 1000;
			text = "STR_UI_ExecutiveMenu_Player";
			x = 0.432969 * safezoneW + safezoneX;
			y = 0.357 * safezoneH + safezoneY;
			w = 0.134062 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class RscText_1001: RscStructuredText
		{
			idc = 1001;
			text = "STR_UI_ExecutiveMenu_Situation";
			x = 0.427812 * safezoneW + safezoneX;
			y = 0.445 * safezoneH + safezoneY;
			w = 0.134062 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class TargetHelped: RscCombo
		{
			idc = 2100;
			text = "";
			x = 0.407187 * safezoneW + safezoneX;
			y = 0.395 * safezoneH + safezoneY;
			w = 0.185625 * safezoneW;
			h = 0.021 * safezoneH;
			colorBackground[] = {0,0,0,0.7};
		};
		class SituationDetails: RscEdit
		{
			idc = 1401;
			text = "";
			x = 0.37625 * safezoneW + safezoneX;
			y = 0.489 * safezoneH + safezoneY;
			w = 0.2475 * safezoneW;
			h = 0.077 * safezoneH;
		};
		class Presets: RscCombo
		{
			idc = 2101;
			x = 0.37625 * safezoneW + safezoneX;
			y = 0.566 * safezoneH + safezoneY;
			w = 0.2475 * safezoneW;
			h = 0.022 * safezoneH;
			colorBackground[] = {0,0,0,0.7};
		};
		class SubmitCall: RscButton
		{
			idc = 2021;
			text = "STR_Common_Send";
			x = 0.45875 * safezoneW + safezoneX;
			y = 0.621 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.044 * safezoneH;
			action = "call A3PL_Admin_LogCall;";
		};
	};
};
