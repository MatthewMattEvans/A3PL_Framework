/*
    A3PL GPS Navigation System - HUD Dialog
    Adapted from A3GPS by [Utopia] Amaury
    Integrated into A3PL Framework
*/

// GPS HUD - Main navigation display (RscTitles)
class A3PL_GPS_HUD {
    idd = 987654;
    name = "A3PL_GPS_HUD";
    onLoad = "uiNamespace setVariable ['A3PL_GPS_HUD', _this select 0];";
    movingEnable = 0;
    duration = 9999999;
    fadeIn = 0;
    fadeOut = 0;

    class controlsBackground {
        class RscPicture_1200: RscPicture
		{
			idc = 1200;
			text = "\A3PL_Common\GUI\A3PL_GPSHUD.paa";
			x = -0.374479 * safezoneW + safezoneX;
			y = -0.116667 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};

        // Mini-map control
        class gps_map: RscMapControl {
            idc = 2201;
            x = 0.0114583 * safezoneW + safezoneX;
            y = 0.238889 * safezoneH + safezoneY;
            w = 0.211406 * safezoneW;
            h = 0.319 * safezoneH;

            // Map settings
            mapOrientation = 1;
            moveOnEdges = 1;
            showCountourInterval = 1;

            // Zoom settings
            scaleMin = 0.1;
            scaleMax = 0.1;
            alphaFadeStartScale = 0;
            alphaFadeEndScale = 0;

            // Colors - simplified for GPS view
            colorBackground[] = {0,0,0,0.7};
            colorForest[] = {0,0,0,0};
            colorRocks[] = {0,0,0,0};
            colorForestBorder[] = {0,0,0,0};
            colorRocksBorder[] = {0,0,0,0};
            colorLevels[] = {0,0,0,0};
            colorPowerLines[] = {0,0,0,0};
            colorRailWay[] = {0,0,0,0};
            colorMainCountlines[] = {0,0,0,0};
            colorCountlinesWater[] = {0,0,0,0};
            colorCountlines[] = {0,0,0,0};

            // Hide trees and bushes
            class Tree {
                color[] = {0,0,0,0};
                icon = "\A3\ui_f\data\map\mapcontrol\bush_ca.paa";
                size = 12;
                importance = "0.9 * 16 * 0.05";
                coefMin = 0.25;
                coefMax = 4;
            };
            class SmallTree {
                color[] = {0,0,0,0};
                icon = "\A3\ui_f\data\map\mapcontrol\bush_ca.paa";
                size = 12;
                importance = "0.6 * 12 * 0.05";
                coefMin = 0.25;
                coefMax = 4;
            };
            class Bush {
                color[] = {0,0,0,0};
                icon = "\A3\ui_f\data\map\mapcontrol\bush_ca.paa";
                size = "14/2";
                importance = "0.2 * 14 * 0.05 * 0.05";
                coefMin = 0.25;
                coefMax = 4;
            };
            class Rock {
                color[] = {0,0,0,0};
                icon = "\A3\ui_f\data\map\mapcontrol\rock_ca.paa";
                size = 12;
                importance = "0.5 * 12 * 0.05";
                coefMin = 0.25;
                coefMax = 4;
            };
        };
    };

    class controls {
        // Status text - navigation instructions
        class status_text: RscStructuredText {
            idc = 1000;
            x = 0.0135417 * safezoneW + safezoneX;
            y = 0.610186 * safezoneH + safezoneY;
            w = 0.20625 * safezoneW;
            h = 0.022 * safezoneH;
            size = 0.025;
        };

        // Distance to destination
        class goal_distance: RscStructuredText {
            idc = 1002;
            x = 0.159896 * safezoneW + safezoneX;
            y = 0.192592 * safezoneH + safezoneY;
            w = 0.061875 * safezoneW;
            h = 0.022 * safezoneH;
            size = 0.03;
            style = ST_CENTER;
        };

    };
};

// QuickNav overlay - search results display
class A3PL_GPS_QuickNav {
    idd = 369853;
    name = "A3PL_GPS_QuickNav";
    onLoad = "[_this select 0] call A3PL_GPS_LoadQuickNav;";
    movingEnable = 0;
    duration = 9999999;
    fadeIn = 0;
    fadeOut = 0;

    class Controls {
        class RscPicture_1200: RscPicture
		{
			idc = 1200;
			text = "\A3PL_Common\GUI\A3PL_GPSQUICKNAV.paa";
			x = -0.324999 * safezoneW + safezoneX;
			y = -0.224074 * safezoneH + safezoneY;
			w = 0.871406 * safezoneW;
			h = 0.858 * safezoneH;
		};
        class RscButton_1600: RscButton {
            idc = 1600;
            x = 0.0156252 * safezoneW + safezoneX;
            y = 0.0805558 * safezoneH + safezoneY;
            w = 0.180469 * safezoneW;
            h = 0.022 * safezoneH;
            colorBackground[] = {0,0,0,0.5};
            colorBackgroundActive[] = {0,0,0,0.8};
        };
    };
};

// Legacy compatibility - keep old dialog working
class Dialog_HUD_GPS {
    idd = -1;
    name = "Dialog_HUD_GPS";
    onLoad = "uiNamespace setVariable ['Dialog_HUD_GPS', _this select 0]";
    movingEnable = 0;
    fadein = 6;
    duration = 9999999999999;
    fadeout = 0;

    class controlsBackground {
        class GPS_MAP: RscMapControl {
            idc = 23539;
            x = 0.0557291 * safezoneW + safezoneX;
            y = 0.817593 * safezoneH + safezoneY;
            w = 0.12375 * safezoneW;
            h = 0.143 * safezoneH;
        };
        class GPS_AZIMUT_INFO: RscStructuredText {
            idc = 23542;
            x = 0.0187501 * safezoneW + safezoneX;
            y = 0.838889 * safezoneH + safezoneY;
            w = 0.0309375 * safezoneW;
            h = 0.033 * safezoneH;
            style = ST_CENTER;
            sizeEx = "0.75 * safezoneH";
        };
        class GPS_ALTITUDE_INFO: RscStructuredText {
            idc = 23543;
            x = 0.0182295 * safezoneW + safezoneX;
            y = 0.886806 * safezoneH + safezoneY;
            w = 0.0309375 * safezoneW;
            h = 0.033 * safezoneH;
            style = ST_CENTER;
            sizeEx = "0.75 * safezoneH";
        };
        class GPS_POSITION_INFO: RscStructuredText {
            idc = 23544;
            x = 0.01875 * safezoneW + safezoneX;
            y = 0.934259 * safezoneH + safezoneY;
            w = 0.0309375 * safezoneW;
            h = 0.033 * safezoneH;
            style = ST_CENTER;
            sizeEx = "0.75 * safezoneH";
        };
    };
    class controls {};
};
