class RscDBGroup
{
	type = CT_CONTROLS_GROUP;
	idc = -1;
	style = ST_MULTI;
	x = (safeZoneX + (SafezoneW * 0.0163));  // scalability code which resizes correctly no matter what gui size or screen dimensions is used
	y = (safeZoneY + (SafezoneH * 0.132));   
	w = (SafezoneW  * 0.31);                 
	h = (SafezoneH  * 0.1);
	class VScrollbar 
	{
		color[] = {0.5, 0.5, 0.5, 1};
		width = 0.02;
		autoScrollSpeed = -1;
		autoScrollDelay = 0;
		autoScrollRewind = 0;
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa"; // Arrow 
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa"; // Arrow when clicked on 
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa"; // Slider background (stretched vertically) 
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa"; // Dragging element (stretched vertically) 
	};
	class HScrollbar 
	{
		color[] = {1, 1, 1, 0};
		height = 0;
	};
	class ScrollBar
	{
		color[] = {1,1,1,0.6};
		colorActive[] = {1,1,1,1};
		colorDisabled[] = {1,1,1,0.3};
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa"; // Arrow 
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa"; // Arrow when clicked on 
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa"; // Slider background (stretched vertically) 
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa"; // Dragging element (stretched vertically) 
	};
	class Controls {};
};
class UnitsList: RscControlsGroup
{
	idc = 96;
	x = 0;
	y = 0;
	w = safeZoneW * 0.165;
	h = safeZoneH * 0.074;
	class Controls
	{
		class Callsign: RscText
		{
			idc = 961;
			style = ST_LEFT;
			x = 0;
			y = 0.01;
			w = safeZoneW * 0.165;
			h = safeZoneH * 0.02;
			text = "";
			sizeEx = 0.02 * safezoneW;
			colorText[] = {0.8,0.8,0.8,1};
			shadow = 0;
		};
		class Spec: RscText
		{
			idc = 963;
			style = ST_RIGHT;
			x = 0;
			y = 0.01;
			w = safeZoneW * 0.162;
			h = safeZoneH * 0.02;
			text = "";
			sizeEx = 0.02 * safezoneW;
			colorText[] = {0.8,0.8,0.8,1};
			shadow = 0;
		};
		class Status: RscText
		{
			idc = 962;
			style = ST_LEFT;
			x = 0;
			y = 0.025 * safezoneW;
			w = safeZoneW * 0.165;
			h = safeZoneH * 0.018;
			text = "";
			sizeEx = 0.018 * safezoneW;
			colorText[] = {0.62,0.62,0.62,1};
			shadow = 0;
		};
		class District: RscText
		{
			idc = 964;
			style = ST_RIGHT;
			x = 0;
			y = 0.025 * safezoneW;
			w = safeZoneW * 0.162;
			h = safeZoneH * 0.018;
			text = "";
			sizeEx = 0.018 * safezoneW;
			colorText[] = {0.62,0.62,0.62,1};
			shadow = 0;
		};
		class Separator: RscText
		{
			idc = -1;
			style = ST_HUD_BACKGROUND;
			x = 0;
			y = (0.03 * safezoneW) + (0.018 * safezoneW);
			w = safeZoneW * 0.165;
			h = safeZoneH * 0.001;
			colorBackground[] = {0.8,0.8,0.8,1};
		};
	};
};
class Dialog_CAD {
	idd = 95;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "";
	onUnload = "call A3PL_Police_CloseMDT;";
	class ControlsBackground
	{
		class BACKGROUND: RscPicture
		{
			idc = -1;
			text = "\A3PL_Common\GUI\MDT.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class MDT_TITLE: RscStructuredText
		{
			idc = -1;
			text = "STR_UI_CAD_Title";
			x = 0.687 * safezoneW + safezoneX;
			y = 0.1 * safezoneH + safezoneY;
			w = 0.2241 * safezoneW;
			h = 0.055 * safezoneH;
		};
	};
	class controls
	{
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT START (by Winston, v1.063, #Helatu)
		////////////////////////////////////////////////////////
		class UnitsDisplayGroup: RscControlsGroup
		{
			idc = 960;
			x = 0.0875 * safezoneW + safezoneX;
			y = 0.098 * safezoneH + safezoneY;
			w = 0.165 * safezoneW;
			h = 0.525 * safezoneH;
			class VScrollbar 
			{
				color[] = {0.5, 0.5, 0.5, 1};
				width = 0.012;
				autoScrollSpeed = -1;
				autoScrollDelay = 0;
				autoScrollRewind = 0;
				arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa"; // Arrow 
				arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa"; // Arrow when clicked on 
				border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa"; // Slider background (stretched vertically) 
				thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa"; // Dragging element (stretched vertically) 
			};
			class HScrollbar 
			{
				color[] = {1, 1, 1, 0};
				height = 0;
			};
			class ScrollBar
			{
				color[] = {1,1,1,0.6};
				colorActive[] = {1,1,1,1};
				colorDisabled[] = {1,1,1,0.3};
				arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa"; // Arrow 
				arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa"; // Arrow when clicked on 
				border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa"; // Slider background (stretched vertically) 
				thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa"; // Dragging element (stretched vertically) 
			};
			class Controls{};
		};
		class Screen_Map: RscMapControl {
			idc = 1107;
			x = 0.262812 * safezoneW + safezoneX;
			y = 0.104 * safezoneH + safezoneY;
			w = 0.4125 * safezoneW;
			h = 0.517 * safezoneH;
		};
		class Screen: RscDBGroup {
			idc = 1106;
			x = 0.262812 * safezoneW + safezoneX;
			y = 0.104 * safezoneH + safezoneY;
			w = 0.4125 * safezoneW;
			h = 0.517 * safezoneH;
			colorBackground[] = {0,0,0,0};
			class Controls
			{
				class struc_policedb: RscStructuredText
				{
					idc = 1105;
					x = 0;
					y = 0;
					w = 0.402187 * safezoneW;
					h = 1 * safezoneH;
					text = "";
					class Attributes {
						font = "PuristaMedium";
						color = "#F6F6F6";
						align = "left";
						valign = "middle";
						shadow = 0;
						shadowColor = "#000000";
						size = "1";
					};
				};
			};
		};
		class CMD_LIST: RscCombo
		{
			idc = 2100;
			x = 0.687 * safezoneW + safezoneX;
			y = 0.52 * safezoneH + safezoneY;
			w = 0.2241 * safezoneW;
			h = 0.022 * safezoneH;
			colorBackground[] = {0.05,0.05,0.05,0.92};
		};
		class TEXT1: RscStructuredText
		{
			idc = 1100;
			text = "";
			x = 0.690781 * safezoneW + safezoneX;
			y = 0.148 * safezoneH + safezoneY;
			w = 0.216563 * safezoneW;
			h = 0.035 * safezoneH;
		};
		class TEXT2: RscStructuredText
		{
			idc = 1101;
			text = "";
			x = 0.690781 * safezoneW + safezoneX;
			y = 0.2184 * safezoneH + safezoneY;
			w = 0.216563 * safezoneW;
			h = 0.035 * safezoneH;
		};
		class TEXT3: RscStructuredText
		{
			idc = 1102;
			text = "";
			x = 0.690781 * safezoneW + safezoneX;
			y = 0.2888 * safezoneH + safezoneY;
			w = 0.216563 * safezoneW;
			h = 0.035 * safezoneH;
		};
		class TEXT4: RscStructuredText
		{
			idc = 1103;
			text = "";
			x = 0.690781 * safezoneW + safezoneX;
			y = 0.3592 * safezoneH + safezoneY;
			w = 0.216563 * safezoneW;
			h = 0.035 * safezoneH;
		};
		class TEXT5: RscStructuredText
		{
			idc = 1104;
			text = "";
			x = 0.690781 * safezoneW + safezoneX;
			y = 0.4296 * safezoneH + safezoneY;
			w = 0.216563 * safezoneW;
			h = 0.035 * safezoneH;
		};
		class INPUT1: RscEdit
		{
			idc = 1400;
			text = "";
			x = 0.690781 * safezoneW + safezoneX;
			y = 0.1832 * safezoneH + safezoneY;
			w = 0.216563 * safezoneW;
			h = 0.035 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.2)";
			colorSelection[] = {0.75294117647,0.30980392156,0.15686274509,1};
		};		
		class INPUT2: RscEdit
		{
			idc = 1401;
			text = "";
			x = 0.690781 * safezoneW + safezoneX;
			y = 0.2536 * safezoneH + safezoneY;
			w = 0.216563 * safezoneW;
			h = 0.035 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.2)";
			colorSelection[] = {0.75294117647,0.30980392156,0.15686274509,1};
		};
		class INPUT3: RscEdit
		{
			idc = 1402;
			text = "";
			x = 0.690781 * safezoneW + safezoneX;
			y = 0.324 * safezoneH + safezoneY;
			w = 0.216563 * safezoneW;
			h = 0.035 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.2)";
			colorSelection[] = {0.75294117647,0.30980392156,0.15686274509,1};
		};
		class INPUT4: RscEdit
		{
			idc = 1403;
			text = "";
			x = 0.690781 * safezoneW + safezoneX;
			y = 0.3944 * safezoneH + safezoneY;
			w = 0.216563 * safezoneW;
			h = 0.035 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.2)";
			colorSelection[] = {0.75294117647,0.30980392156,0.15686274509,1};
		};
		class INPUT5: RscEdit
		{
			idc = 1404;
			text = "";
			x = 0.690781 * safezoneW + safezoneX;
			y = 0.4648 * safezoneH + safezoneY;
			w = 0.216563 * safezoneW;
			h = 0.035 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.2)";
			colorSelection[] = {0.75294117647,0.30980392156,0.15686274509,1};
		};
		class STATUS: RscCombo
		{
			idc = 2101;
			x = 0.546406 * safezoneW + safezoneX;
			y = 0.665 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.033 * safezoneH;
			colorBackground[] = {0,0,0,0.6};
		};
		class SPEC: RscCombo
		{
			idc = 2102;
			x = 0.396875 * safezoneW + safezoneX;
			y = 0.665 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.033 * safezoneH;
			colorBackground[] = {0,0,0,0.6};
		};
		class DISTRICT: RscCombo
		{
			idc = 2103;
			x = 0.546406 * safezoneW + safezoneX;
			y = 0.73 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.033 * safezoneH;
			colorBackground[] = {0,0,0,0.6};
		};
		class CALLSIGN: RscEdit
		{
			idc = 1405;
			x = 0.273125 * safezoneW + safezoneX;
			y = 0.665 * safezoneH + safezoneY;
			w = 0.0928125 * safezoneW;
			h = 0.033 * safezoneH;
			colorSelection[] = {0.75294117647,0.30980392156,0.15686274509,1};
		};
		class ADD_INFO: RscEdit
		{
			idc = 1406;
			x = 0.273125 * safezoneW + safezoneX;
			y = 0.731 * safezoneH + safezoneY;
			w = 0.216563 * safezoneW;
			h = 0.055 * safezoneH;
			colorSelection[] = {0.75294117647,0.30980392156,0.15686274509,1};
		};
		class CSTM_BT1: RscButton
		{
			idc = -1;
			text = "STR_UI_CAD_Map";
			x = 0.267969 * safezoneW + safezoneX;
			y = 0.797 * safezoneH + safezoneY;
			w = 0.103125 * safezoneW;
			h = 0.044 * safezoneH;
			action = "call A3PL_Police_MapMDT;";
		};
		class CSTM_BT2: RscButton
		{
			idc = -1;
			text = "STR_UI_CAD_Confirm";
			x = 0.422656 * safezoneW + safezoneX;
			y = 0.797 * safezoneH + safezoneY;
			w = 0.103125 * safezoneW;
			h = 0.044 * safezoneH;
			action = "call A3PL_Police_SetCAD;";	
		};
		class CSTM_BT3: RscButton
		{
			idc = 999;
			text = "STR_UI_CAD_Panic";
			x = 0.267969 * safezoneW + safezoneX;
			y = 0.852 * safezoneH + safezoneY;
			w = 0.103125 * safezoneW;
			h = 0.044 * safezoneH;
			action = "[] spawn A3PL_Police_PanicMDT;";
		};
		class CSTM_BT4: RscButton
		{
			idc = -1;
			text = "STR_UI_CAD_Lock";
			x = 0.422656 * safezoneW + safezoneX;
			y = 0.852 * safezoneH + safezoneY;
			w = 0.103125 * safezoneW;
			h = 0.044 * safezoneH;
			action = "call A3PL_Police_ShutdownMDT;";
		};
		class EXECUTE: RscButton
		{
			idc = -1;
			text = "STR_UI_CAD_Exec";
			x = 0.814531 * safezoneW + safezoneX;
			y = 0.577 * safezoneH + safezoneY;
			w = 0.0928125 * safezoneW;
			h = 0.044 * safezoneH;
			action = "call A3PL_Police_ExecuteMDT;";
		};
		class CLEAR: RscButton
		{
			idc = -1;
			text = "STR_UI_CAD_Clear";
			x = 0.690781 * safezoneW + safezoneX;
			y = 0.577 * safezoneH + safezoneY;
			w = 0.0928125 * safezoneW;
			h = 0.044 * safezoneH;
			action = "[] spawn A3PL_Police_ClearMDT;";
		};
		class DISPATCHLIST: RscListbox
		{
			idc = 1501;
			x = 0.690781 * safezoneW + safezoneX;
			y = 0.647 * safezoneH + safezoneY;
			w = 0.216563 * safezoneW;
			h = 0.132 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.85)";
		};
		class DISPATCHUNIT: RscCombo
		{
			idc = 2105;
			x = 0.0926562 * safezoneW + safezoneX;
			y = 0.764 * safezoneH + safezoneY;
			w = 0.154687 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class DISPATCHUNITSTATUS: RscCombo
		{
			idc = 2104;
			x = 0.0926562 * safezoneW + safezoneX;
			y = 0.797 * safezoneH + safezoneY;
			w = 0.154687 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class DISPATCHUNITDSTRC: RscCombo
		{
			idc = 2106;
			x = 0.0926562 * safezoneW + safezoneX;
			y = 0.83 * safezoneH + safezoneY;
			w = 0.154687 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class DISPATCH_BT1: RscButton
		{
			idc = 888;
			text = "STR_UI_CAD_Assign";
			x = 0.690781 * safezoneW + safezoneX;
			y = 0.797 * safezoneH + safezoneY;
			w = 0.0876563 * safezoneW;
			h = 0.044 * safezoneH;
			action = "[true] call A3PL_Police_AttachCall;";
		};
		class DISPATCH_BT2: RscButton
		{
			idc = -1;
			text = "STR_UI_CAD_Map";
			x = 0.690781 * safezoneW + safezoneX;
			y = 0.852 * safezoneH + safezoneY;
			w = 0.0876563 * safezoneW;
			h = 0.044 * safezoneH;
			action = "call A3PL_Police_ShowCall;";
		};		
		class DISPATCH_BT3: RscButton
		{
			idc = -1;
			text = "STR_UI_CAD_CallInfo";
			x = 0.819688 * safezoneW + safezoneX;
			y = 0.797 * safezoneH + safezoneY;
			w = 0.0876563 * safezoneW;
			h = 0.044 * safezoneH;
			action = "call A3PL_Police_InfoCall;";
		};
		class DISPATCH_BT4: RscButton
		{
			idc = -1;
			text = "STR_UI_CAD_Solved";
			x = 0.819688 * safezoneW + safezoneX;
			y = 0.852 * safezoneH + safezoneY;
			w = 0.0876563 * safezoneW;
			h = 0.044 * safezoneH;
			action = "call A3PL_Police_ResolveCall;";
		};
		class ATTACH_OTHER: RscButton
		{
			idc = 889;
			text = "STR_UI_CAD_Assign";
			x = 0.0926562 * safezoneW + safezoneX;
			y = 0.863 * safezoneH + safezoneY;
			w = 0.154687 * safezoneW;
			h = 0.033 * safezoneH;
			action = "[false] call A3PL_Police_AttachCall;";
		};
		class UnitInfo: RscStructuredText
		{
			idc = 1109;
			text = "";
			x = 0.0926562 * safezoneW + safezoneX;
			y = 0.654 * safezoneH + safezoneY;
			w = 0.154687 * safezoneW;
			h = 0.077 * safezoneH;
		};
	};
};