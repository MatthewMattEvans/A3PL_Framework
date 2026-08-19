/*
    A3PL GPS Navigation System - Menu Dialogs
    Adapted from A3GPS by [Utopia] Amaury
*/

// ============================================================================
// MAIN GPS MENU
// ============================================================================
class A3PL_GPS_Menu {
    idd = 369852;
    name = "A3PL_GPS_Menu";
    movingEnable = 0;
    onLoad = "uiNamespace setVariable ['A3PL_GPS_Menu', _this select 0]";

    class controls {
        class RscPicture_1200: RscPicture
		{
			idc = 1200;
			text = "\A3PL_Common\GUI\A3PL_GPS.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};

        // Row 1: Navigation / Map Click
        class btn_navigate: RscButtonEmpty {
            idc = 2400;
            x = 0.385833 * safezoneW + safezoneX;
            y = 0.348149 * safezoneH + safezoneY;
            w = 0.0979687 * safezoneW;
            h = 0.033 * safezoneH;
        };
        class btn_mapclick: RscButtonEmpty {
            idc = 2401;
            x = 0.502135 * safezoneW + safezoneX;
            y = 0.349704 * safezoneH + safezoneY;
            w = 0.0979687 * safezoneW;
            h = 0.033 * safezoneH;
        };

        // Row 2: Nearest Fuel / Nearest Town
        class btn_fuel: RscButtonEmpty {
            idc = 2402;
            x = 0.384375 * safezoneW + safezoneX;
            y = 0.428704 * safezoneH + safezoneY;
            w = 0.0979687 * safezoneW;
            h = 0.033 * safezoneH;
        };
        class btn_town: RscButtonEmpty {
            idc = 2403;
            x = 0.384895 * safezoneW + safezoneX;
            y = 0.474074 * safezoneH + safezoneY;
            w = 0.0979687 * safezoneW;
            h = 0.033 * safezoneH;
        };

        // Row 3: Open HUD / Stop Navigation
        class btn_hud: RscButtonEmpty {
            idc = 2404;
            x = 0.384896 * safezoneW + safezoneX;
            y = 0.549074 * safezoneH + safezoneY;
            w = 0.0979687 * safezoneW;
            h = 0.033 * safezoneH;
        };
        class btn_stop: RscButtonEmpty {
            idc = 2405;
            x = 0.501041 * safezoneW + safezoneX;
            y = 0.548148 * safezoneH + safezoneY;
            w = 0.0979687 * safezoneW;
            h = 0.033 * safezoneH;
        };

        // Saved routes list
        class saved_list: RscListbox {
            idc = 1500;
            x = 0.392708 * safezoneW + safezoneX;
            y = 0.627778 * safezoneH + safezoneY;
            w = 0.20625 * safezoneW;
            h = 0.077 * safezoneH;
        };
        class btn_load_saved: RscButtonEmpty {
            idc = 2407;
            x = 0.528646 * safezoneW + safezoneX;
            y = 0.723148 * safezoneH + safezoneY;
            w = 0.0721875 * safezoneW;
            h = 0.033 * safezoneH;
        };
        class btn_delete_saved: RscButtonEmpty {
            idc = 2408;
            x = 0.385938 * safezoneW + safezoneX;
            y = 0.721296 * safezoneH + safezoneY;
            w = 0.0567187 * safezoneW;
            h = 0.033 * safezoneH;
        };
        class btn_save_route: RscButtonEmpty {
            idc = 2410;
            x = 0.45 * safezoneW + safezoneX;
            y = 0.723148 * safezoneH + safezoneY;
            w = 0.0721875 * safezoneW;
            h = 0.033 * safezoneH;
        };

        // Close button
        class btn_close: RscButtonEmpty {
            idc = 2409;
            x = 0.579688 * safezoneW + safezoneX;
            y = 0.299075 * safezoneH + safezoneY;
            w = 0.020625 * safezoneW;
            h = 0.044 * safezoneH;
        };
    };
};

// ============================================================================
// NAVIGATION MAP MENU (click on map to navigate)
// ============================================================================
class A3PL_GPS_NavMap {
    idd = 369856;
    name = "A3PL_GPS_NavMap";
    movingEnable = 0;
    onLoad = "uiNamespace setVariable ['A3PL_GPS_NavMap', _this select 0]";

    class controlsBackground {
        class map: RscMapControl {
            idc = 2201;
            x = 0.15 * safezoneW + safezoneX;
            y = 0.1 * safezoneH + safezoneY;
            w = 0.7 * safezoneW;
            h = 0.75 * safezoneH;
        };
    };

    class controls {
        // Header
        class header: RscStructuredText {
            idc = 1004;
            text = "STR_A3PL_GPS_NavMapHeader";
            x = 0.15 * safezoneW + safezoneX;
            y = 0.1 * safezoneH + safezoneY;
            w = 0.7 * safezoneW;
            h = 0.035 * safezoneH;
            colorBackground[] = {0, 0, 0, 0.8};
        };

        // Close / Cancel
        class btn_close: RscButton {
            idc = 1600;
            text = "STR_A3PL_GPS_Close";
            x = 0.44 * safezoneW + safezoneX;
            y = 0.865 * safezoneH + safezoneY;
            w = 0.12 * safezoneW;
            h = 0.035 * safezoneH;
            colorBackground[] = {0.3, 0.3, 0.3, 0.9};
            colorBackgroundActive[] = {0.5, 0.5, 0.5, 1};
            colorFocused[] = {0.5, 0.5, 0.5, 1};
        };
    };
};
