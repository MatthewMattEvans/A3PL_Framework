class Dialog_Hotbar
{
	idd = 8500;
	fadeout = 0;
	fadein = 0;
	duration = 1e+1000;
	onLoad = "disableSerialization; uiNamespace setVariable ['A3PL_HotbarDisplay', _this select 0];";

	class controlsBackground
	{
		class hotbar_background: RscPicture
		{
			idc = 84999;
			text = "\A3PL_Common\HUD\A3PL_Slotbar.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
	};

	class controls
	{
		// ============================================================
		// Slot 0 (Key 1) - IDCs 85000-85004
		// bg: x=0.306125 y=0.9158 w=0.0257812 h=0.055
		// ============================================================
		class slot0_bg: RscPicture
		{
			idc = 85000;
			text = "#(argb,8,8,3)color(0.1,0.1,0.1,0.7)";
			x = 0.306125 * safezoneW + safezoneX;
			y = 0.9158 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.055 * safezoneH;
		};
		class slot0_icon: RscPicture
		{
			idc = 85001;
			text = "";
			x = 0.308125 * safezoneW + safezoneX;
			y = 0.9308 * safezoneH + safezoneY;
			w = 0.0217812 * safezoneW;
			h = 0.035 * safezoneH;
		};
		class slot0_key: RscStructuredText
		{
			idc = 85002;
			text = "";
			x = 0.306125 * safezoneW + safezoneX;
			y = 0.9158 * safezoneH + safezoneY;
			w = 0.012 * safezoneW;
			h = 0.015 * safezoneH;
		};
		class slot0_amount: RscStructuredText
		{
			idc = 85003;
			text = "";
			x = 0.306125 * safezoneW + safezoneX;
			y = 0.9558 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.015 * safezoneH;
		};
		class slot0_lock: RscPicture
		{
			idc = 85004;
			text = "";
			x = 0.311516 * safezoneW + safezoneX;
			y = 0.9308 * safezoneH + safezoneY;
			w = 0.015 * safezoneW;
			h = 0.025 * safezoneH;
		};

		// ============================================================
		// Slot 1 (Key 2) - IDCs 85010-85014
		// bg: x=0.347375 y=0.9136 w=0.0257812 h=0.055
		// ============================================================
		class slot1_bg: RscPicture
		{
			idc = 85010;
			text = "#(argb,8,8,3)color(0.1,0.1,0.1,0.7)";
			x = 0.347375 * safezoneW + safezoneX;
			y = 0.9136 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.055 * safezoneH;
		};
		class slot1_icon: RscPicture
		{
			idc = 85011;
			text = "";
			x = 0.349375 * safezoneW + safezoneX;
			y = 0.9286 * safezoneH + safezoneY;
			w = 0.0217812 * safezoneW;
			h = 0.035 * safezoneH;
		};
		class slot1_key: RscStructuredText
		{
			idc = 85012;
			text = "";
			x = 0.347375 * safezoneW + safezoneX;
			y = 0.9136 * safezoneH + safezoneY;
			w = 0.012 * safezoneW;
			h = 0.015 * safezoneH;
		};
		class slot1_amount: RscStructuredText
		{
			idc = 85013;
			text = "";
			x = 0.347375 * safezoneW + safezoneX;
			y = 0.9536 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.015 * safezoneH;
		};
		class slot1_lock: RscPicture
		{
			idc = 85014;
			text = "";
			x = 0.352766 * safezoneW + safezoneX;
			y = 0.9286 * safezoneH + safezoneY;
			w = 0.015 * safezoneW;
			h = 0.025 * safezoneH;
		};

		// ============================================================
		// Slot 2 (Key 3) - IDCs 85020-85024
		// bg: x=0.388626 y=0.9136 w=0.0257812 h=0.055
		// ============================================================
		class slot2_bg: RscPicture
		{
			idc = 85020;
			text = "#(argb,8,8,3)color(0.1,0.1,0.1,0.7)";
			x = 0.388626 * safezoneW + safezoneX;
			y = 0.9136 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.055 * safezoneH;
		};
		class slot2_icon: RscPicture
		{
			idc = 85021;
			text = "";
			x = 0.390626 * safezoneW + safezoneX;
			y = 0.9286 * safezoneH + safezoneY;
			w = 0.0217812 * safezoneW;
			h = 0.035 * safezoneH;
		};
		class slot2_key: RscStructuredText
		{
			idc = 85022;
			text = "";
			x = 0.388626 * safezoneW + safezoneX;
			y = 0.9136 * safezoneH + safezoneY;
			w = 0.012 * safezoneW;
			h = 0.015 * safezoneH;
		};
		class slot2_amount: RscStructuredText
		{
			idc = 85023;
			text = "";
			x = 0.388626 * safezoneW + safezoneX;
			y = 0.9536 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.015 * safezoneH;
		};
		class slot2_lock: RscPicture
		{
			idc = 85024;
			text = "";
			x = 0.394017 * safezoneW + safezoneX;
			y = 0.9286 * safezoneH + safezoneY;
			w = 0.015 * safezoneW;
			h = 0.025 * safezoneH;
		};

		// ============================================================
		// Slot 3 (Key 4) - IDCs 85030-85034
		// bg: x=0.428845 y=0.9136 w=0.0257812 h=0.055
		// ============================================================
		class slot3_bg: RscPicture
		{
			idc = 85030;
			text = "#(argb,8,8,3)color(0.1,0.1,0.1,0.7)";
			x = 0.428845 * safezoneW + safezoneX;
			y = 0.9136 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.055 * safezoneH;
		};
		class slot3_icon: RscPicture
		{
			idc = 85031;
			text = "";
			x = 0.430845 * safezoneW + safezoneX;
			y = 0.9286 * safezoneH + safezoneY;
			w = 0.0217812 * safezoneW;
			h = 0.035 * safezoneH;
		};
		class slot3_key: RscStructuredText
		{
			idc = 85032;
			text = "";
			x = 0.428845 * safezoneW + safezoneX;
			y = 0.9136 * safezoneH + safezoneY;
			w = 0.012 * safezoneW;
			h = 0.015 * safezoneH;
		};
		class slot3_amount: RscStructuredText
		{
			idc = 85033;
			text = "";
			x = 0.428845 * safezoneW + safezoneX;
			y = 0.9536 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.015 * safezoneH;
		};
		class slot3_lock: RscPicture
		{
			idc = 85034;
			text = "";
			x = 0.434236 * safezoneW + safezoneX;
			y = 0.9286 * safezoneH + safezoneY;
			w = 0.015 * safezoneW;
			h = 0.025 * safezoneH;
		};

		// ============================================================
		// Slot 4 (Key 5) - IDCs 85040-85044
		// bg: x=0.469064 y=0.9136 w=0.0257812 h=0.055
		// ============================================================
		class slot4_bg: RscPicture
		{
			idc = 85040;
			text = "#(argb,8,8,3)color(0.1,0.1,0.1,0.7)";
			x = 0.469064 * safezoneW + safezoneX;
			y = 0.9136 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.055 * safezoneH;
		};
		class slot4_icon: RscPicture
		{
			idc = 85041;
			text = "";
			x = 0.471064 * safezoneW + safezoneX;
			y = 0.9286 * safezoneH + safezoneY;
			w = 0.0217812 * safezoneW;
			h = 0.035 * safezoneH;
		};
		class slot4_key: RscStructuredText
		{
			idc = 85042;
			text = "";
			x = 0.469064 * safezoneW + safezoneX;
			y = 0.9136 * safezoneH + safezoneY;
			w = 0.012 * safezoneW;
			h = 0.015 * safezoneH;
		};
		class slot4_amount: RscStructuredText
		{
			idc = 85043;
			text = "";
			x = 0.469064 * safezoneW + safezoneX;
			y = 0.9536 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.015 * safezoneH;
		};
		class slot4_lock: RscPicture
		{
			idc = 85044;
			text = "";
			x = 0.474455 * safezoneW + safezoneX;
			y = 0.9286 * safezoneH + safezoneY;
			w = 0.015 * safezoneW;
			h = 0.025 * safezoneH;
		};

		// ============================================================
		// Slot 5 (Key 6) - IDCs 85050-85054 [Premium]
		// bg: x=0.510312 y=0.9136 w=0.0257812 h=0.055
		// ============================================================
		class slot5_bg: RscPicture
		{
			idc = 85050;
			text = "#(argb,8,8,3)color(0.1,0.1,0.1,0.7)";
			x = 0.510312 * safezoneW + safezoneX;
			y = 0.9136 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.055 * safezoneH;
		};
		class slot5_icon: RscPicture
		{
			idc = 85051;
			text = "";
			x = 0.512312 * safezoneW + safezoneX;
			y = 0.9286 * safezoneH + safezoneY;
			w = 0.0217812 * safezoneW;
			h = 0.035 * safezoneH;
		};
		class slot5_key: RscStructuredText
		{
			idc = 85052;
			text = "";
			x = 0.510312 * safezoneW + safezoneX;
			y = 0.9136 * safezoneH + safezoneY;
			w = 0.012 * safezoneW;
			h = 0.015 * safezoneH;
		};
		class slot5_amount: RscStructuredText
		{
			idc = 85053;
			text = "";
			x = 0.510312 * safezoneW + safezoneX;
			y = 0.9536 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.015 * safezoneH;
		};
		class slot5_lock: RscPicture
		{
			idc = 85054;
			text = "";
			x = 0.515703 * safezoneW + safezoneX;
			y = 0.9286 * safezoneH + safezoneY;
			w = 0.015 * safezoneW;
			h = 0.025 * safezoneH;
		};

		// ============================================================
		// Slot 6 (Key 7) - IDCs 85060-85064 [Premium]
		// bg: x=0.550531 y=0.9136 w=0.0257812 h=0.055
		// ============================================================
		class slot6_bg: RscPicture
		{
			idc = 85060;
			text = "#(argb,8,8,3)color(0.1,0.1,0.1,0.7)";
			x = 0.550531 * safezoneW + safezoneX;
			y = 0.9136 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.055 * safezoneH;
		};
		class slot6_icon: RscPicture
		{
			idc = 85061;
			text = "";
			x = 0.552531 * safezoneW + safezoneX;
			y = 0.9286 * safezoneH + safezoneY;
			w = 0.0217812 * safezoneW;
			h = 0.035 * safezoneH;
		};
		class slot6_key: RscStructuredText
		{
			idc = 85062;
			text = "";
			x = 0.550531 * safezoneW + safezoneX;
			y = 0.9136 * safezoneH + safezoneY;
			w = 0.012 * safezoneW;
			h = 0.015 * safezoneH;
		};
		class slot6_amount: RscStructuredText
		{
			idc = 85063;
			text = "";
			x = 0.550531 * safezoneW + safezoneX;
			y = 0.9536 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.015 * safezoneH;
		};
		class slot6_lock: RscPicture
		{
			idc = 85064;
			text = "";
			x = 0.555922 * safezoneW + safezoneX;
			y = 0.9286 * safezoneH + safezoneY;
			w = 0.015 * safezoneW;
			h = 0.025 * safezoneH;
		};

		// ============================================================
		// Slot 7 (Key 8) - IDCs 85070-85074 [Premium]
		// bg: x=0.591781 y=0.9136 w=0.0257812 h=0.055
		// ============================================================
		class slot7_bg: RscPicture
		{
			idc = 85070;
			text = "#(argb,8,8,3)color(0.1,0.1,0.1,0.7)";
			x = 0.591781 * safezoneW + safezoneX;
			y = 0.9136 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.055 * safezoneH;
		};
		class slot7_icon: RscPicture
		{
			idc = 85071;
			text = "";
			x = 0.593781 * safezoneW + safezoneX;
			y = 0.9286 * safezoneH + safezoneY;
			w = 0.0217812 * safezoneW;
			h = 0.035 * safezoneH;
		};
		class slot7_key: RscStructuredText
		{
			idc = 85072;
			text = "";
			x = 0.591781 * safezoneW + safezoneX;
			y = 0.9136 * safezoneH + safezoneY;
			w = 0.012 * safezoneW;
			h = 0.015 * safezoneH;
		};
		class slot7_amount: RscStructuredText
		{
			idc = 85073;
			text = "";
			x = 0.591781 * safezoneW + safezoneX;
			y = 0.9536 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.015 * safezoneH;
		};
		class slot7_lock: RscPicture
		{
			idc = 85074;
			text = "";
			x = 0.597172 * safezoneW + safezoneX;
			y = 0.9286 * safezoneH + safezoneY;
			w = 0.015 * safezoneW;
			h = 0.025 * safezoneH;
		};

		// ============================================================
		// Slot 8 (Key 9) - IDCs 85080-85084 [Premium]
		// bg: x=0.632 y=0.9136 w=0.0257812 h=0.055
		// ============================================================
		class slot8_bg: RscPicture
		{
			idc = 85080;
			text = "#(argb,8,8,3)color(0.1,0.1,0.1,0.7)";
			x = 0.632 * safezoneW + safezoneX;
			y = 0.9136 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.055 * safezoneH;
		};
		class slot8_icon: RscPicture
		{
			idc = 85081;
			text = "";
			x = 0.634 * safezoneW + safezoneX;
			y = 0.9286 * safezoneH + safezoneY;
			w = 0.0217812 * safezoneW;
			h = 0.035 * safezoneH;
		};
		class slot8_key: RscStructuredText
		{
			idc = 85082;
			text = "";
			x = 0.632 * safezoneW + safezoneX;
			y = 0.9136 * safezoneH + safezoneY;
			w = 0.012 * safezoneW;
			h = 0.015 * safezoneH;
		};
		class slot8_amount: RscStructuredText
		{
			idc = 85083;
			text = "";
			x = 0.632 * safezoneW + safezoneX;
			y = 0.9536 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.015 * safezoneH;
		};
		class slot8_lock: RscPicture
		{
			idc = 85084;
			text = "";
			x = 0.637391 * safezoneW + safezoneX;
			y = 0.9286 * safezoneH + safezoneY;
			w = 0.015 * safezoneW;
			h = 0.025 * safezoneH;
		};

		// ============================================================
		// Slot 9 (Key 0) - IDCs 85090-85094 [Premium]
		// bg: x=0.672218 y=0.9136 w=0.0257812 h=0.055
		// ============================================================
		class slot9_bg: RscPicture
		{
			idc = 85090;
			text = "#(argb,8,8,3)color(0.1,0.1,0.1,0.7)";
			x = 0.672218 * safezoneW + safezoneX;
			y = 0.9136 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.055 * safezoneH;
		};
		class slot9_icon: RscPicture
		{
			idc = 85091;
			text = "";
			x = 0.674218 * safezoneW + safezoneX;
			y = 0.9286 * safezoneH + safezoneY;
			w = 0.0217812 * safezoneW;
			h = 0.035 * safezoneH;
		};
		class slot9_key: RscStructuredText
		{
			idc = 85092;
			text = "";
			x = 0.672218 * safezoneW + safezoneX;
			y = 0.9136 * safezoneH + safezoneY;
			w = 0.012 * safezoneW;
			h = 0.015 * safezoneH;
		};
		class slot9_amount: RscStructuredText
		{
			idc = 85093;
			text = "";
			x = 0.672218 * safezoneW + safezoneX;
			y = 0.9536 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.015 * safezoneH;
		};
		class slot9_lock: RscPicture
		{
			idc = 85094;
			text = "";
			x = 0.677609 * safezoneW + safezoneX;
			y = 0.9286 * safezoneH + safezoneY;
			w = 0.015 * safezoneW;
			h = 0.025 * safezoneH;
		};
	};
};
