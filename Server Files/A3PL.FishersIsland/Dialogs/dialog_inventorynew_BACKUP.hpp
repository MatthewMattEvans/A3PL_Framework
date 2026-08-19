/*
	dialog_inventorynew.hpp
	Nouveau systeme d'inventaire A3PL
	Adapte du framework Edaly
*/

#include "common_inventorynew.hpp"

// ============================================================================
// MAIN INVENTORY DISPLAY
// ============================================================================

class A3PL_RscDisplayInventoryNew: A3PL_Inv_RscDisplayDefault
{
	idd=INVENTORY_DISPLAY_IDD;
	name=INVENTORY_DISPLAY_NAME;
	onLoad="(_this#0) spawn A3PL_InventoryNew_Open";
	onMouseButtonUp="_this call A3PL_InventoryNew_RightClick";

	class controlsBackground
	{
		class INVENTORY_BACKGROUND: A3PL_Inv_IGUIBack
		{
			x=0.546406 * safezoneW + safezoneX;
			y=0.247 * safezoneH + safezoneY;
			w=0.216563 * safezoneW;
			h=0.077 * safezoneH;
		};
		class EQUIPMENT_BACKGROUND: A3PL_Inv_IGUIBack
		{
			colorBackground[]={0,0,0,0.6};
			x=0.19074 * safezoneW + safezoneX;
			y=0.246932 * safezoneH + safezoneY;
			w=0.211327 * safezoneW;
			h=0.462124 * safezoneH;
		};
		class EQUIPMENT_UNIFORM_BACKGROUND: A3PL_Inv_IGUIBack
		{
			colorBackground[]={1,1,1,0.3};
			x=0.195895 * safezoneW + safezoneX;
			y=0.522006 * safezoneH + safezoneY;
			w=0.0464063 * safezoneW;
			h=0.077 * safezoneH;
		};
		class EQUIPMENT_BACKPACK_BACKGROUND: A3PL_Inv_IGUIBack
		{
			colorBackground[]={1,1,1,0.3};
			x=0.247438 * safezoneW + safezoneX;
			y=0.566018 * safezoneH + safezoneY;
			w=0.0464063 * safezoneW;
			h=0.077 * safezoneH;
		};
		class EQUIPMENT_GOGGLES_BACKGROUND: A3PL_Inv_IGUIBack
		{
			colorBackground[]={1,1,1,0.3};
			x=0.247438 * safezoneW + safezoneX;
			y=0.38997 * safezoneH + safezoneY;
			w=0.0464063 * safezoneW;
			h=0.077 * safezoneH;
		};
		class EQUIPMENT_VEST_BACKGROUND: A3PL_Inv_IGUIBack
		{
			colorBackground[]={1,1,1,0.3};
			x=0.247438 * safezoneW + safezoneX;
			y=0.477994 * safezoneH + safezoneY;
			w=0.0464063 * safezoneW;
			h=0.077 * safezoneH;
		};
		class EQUIPMENT_HEADGEAR_BACKGROUND: A3PL_Inv_IGUIBack
		{
			colorBackground[]={1,1,1,0.3};
			x=0.195895 * safezoneW + safezoneX;
			y=0.433982 * safezoneH + safezoneY;
			w=0.0464063 * safezoneW;
			h=0.077 * safezoneH;
		};
		class EQUIPMENT_SECONDARYWEAPON_BACKGROUND: A3PL_Inv_IGUIBack
		{
			colorBackground[]={1,1,1,0.3};
			x=0.298981 * safezoneW + safezoneX;
			y=0.466991 * safezoneH + safezoneY;
			w=0.0979322 * safezoneW;
			h=0.11003 * safezoneH;
		};
		class EQUIPMENT_PRIMARYWEAPON_BACKGROUND: A3PL_Inv_IGUIBack
		{
			colorBackground[]={1,1,1,0.3};
			x=0.298982 * safezoneW + safezoneX;
			y=0.345959 * safezoneH + safezoneY;
			w=0.0979322 * safezoneW;
			h=0.11003 * safezoneH;
		};
		class EQUIPMENT_HANDGUNWEAPON_BACKGROUND: A3PL_Inv_IGUIBack
		{
			colorBackground[]={1,1,1,0.3};
			x=0.298981 * safezoneW + safezoneX;
			y=0.588024 * safezoneH + safezoneY;
			w=0.0979322 * safezoneW;
			h=0.11003 * safezoneH;
		};
		class EQUIPMENT_BINOCULARS_BACKGROUND: A3PL_Inv_IGUIBack
		{
			colorBackground[]={1,1,1,0.3};
			x=0.247438 * safezoneW + safezoneX;
			y=0.257935 * safezoneH + safezoneY;
			w=0.0464063 * safezoneW;
			h=0.077 * safezoneH;
		};
		class EQUIPMENT_COMPASS_BACKGROUND: A3PL_Inv_IGUIBack
		{
			colorBackground[]={1,1,1,0.3};
			x=0.298981 * safezoneW + safezoneX;
			y=0.257935 * safezoneH + safezoneY;
			w=0.0464063 * safezoneW;
			h=0.077 * safezoneH;
		};
		class EQUIPMENT_WATCH_BACKGROUND: A3PL_Inv_IGUIBack
		{
			colorBackground[]={1,1,1,0.3};
			x=0.195895 * safezoneW + safezoneX;
			y=0.257935 * safezoneH + safezoneY;
			w=0.0464063 * safezoneW;
			h=0.077 * safezoneH;
		};
		class EQUIPMENT_MAP_BACKGROUND: A3PL_Inv_IGUIBack
		{
			colorBackground[]={1,1,1,0.3};
			x=0.350524 * safezoneW + safezoneX;
			y=0.257935 * safezoneH + safezoneY;
			w=0.0464063 * safezoneW;
			h=0.077 * safezoneH;
		};

		class INVENTORY_TITLE: A3PL_Inv_RscHeader
		{
			idc=INVENTORY_TITLE_IDC;
			text="Inventory";
			x=0.546406 * safezoneW + safezoneX;
			y=0.214 * safezoneH + safezoneY;
			w=0.216563 * safezoneW;
			h=0.033 * safezoneH;
		};
		class EQUIPMENT_TITLE: A3PL_Inv_RscHeader
		{
			idc=EQUIPMENT_TITLE_IDC;
			text="Equipment";
			x=0.19074 * safezoneW + safezoneX;
			y=0.214 * safezoneH + safezoneY;
			w=0.211406 * safezoneW;
			h=0.033 * safezoneH;
		};

	};

	class controls
	{
		// Search edit box
		class INVENTORY_SEARCH_EDIT: A3PL_Inv_RscEdit
		{
			idc=INVENTORY_SEARCH_EDIT_IDC;
			x=0.551562 * safezoneW + safezoneX;
			y=0.291 * safezoneH + safezoneY;
			w=0.118594 * safezoneW;
			h=0.022 * safezoneH;
		};

		// Filter buttons
		// ========== LIGNE 1: all, uniform, backpack, vest ==========
		class INVENTORY_FILTER_1_IMAGE: A3PL_Inv_RscPictureKeepAspect
		{
			idc=INVENTORY_FILTER_1_IMAGE_IDC;
			x=0.680469 * safezoneW + safezoneX;
			y=0.278 * safezoneH + safezoneY;
			w=0.0103125 * safezoneW;
			h=0.022 * safezoneH;
		};
		class INVENTORY_FILTER_1_BUTTON: A3PL_Inv_RscButtonSilent
		{
			idc=INVENTORY_FILTER_1_BUTTON_IDC;
			x=0.680469 * safezoneW + safezoneX;
			y=0.278 * safezoneH + safezoneY;
			w=0.0103125 * safezoneW;
			h=0.022 * safezoneH;
		};

		class INVENTORY_FILTER_2_IMAGE: A3PL_Inv_RscPictureKeepAspect
		{
			idc=INVENTORY_FILTER_2_IMAGE_IDC;
			x=0.701094 * safezoneW + safezoneX;
			y=0.278 * safezoneH + safezoneY;
			w=0.0103125 * safezoneW;
			h=0.022 * safezoneH;
		};
		class INVENTORY_FILTER_2_BUTTON: A3PL_Inv_RscButtonSilent
		{
			idc=INVENTORY_FILTER_2_BUTTON_IDC;
			x=0.701094 * safezoneW + safezoneX;
			y=0.278 * safezoneH + safezoneY;
			w=0.0103125 * safezoneW;
			h=0.022 * safezoneH;
		};

		class INVENTORY_FILTER_3_IMAGE: A3PL_Inv_RscPictureKeepAspect
		{
			idc=INVENTORY_FILTER_3_IMAGE_IDC;
			x=0.721719 * safezoneW + safezoneX;
			y=0.278 * safezoneH + safezoneY;
			w=0.0103125 * safezoneW;
			h=0.022 * safezoneH;
		};
		class INVENTORY_FILTER_3_BUTTON: A3PL_Inv_RscButtonSilent
		{
			idc=INVENTORY_FILTER_3_BUTTON_IDC;
			x=0.721719 * safezoneW + safezoneX;
			y=0.278 * safezoneH + safezoneY;
			w=0.0103125 * safezoneW;
			h=0.022 * safezoneH;
		};

		class INVENTORY_FILTER_4_IMAGE: A3PL_Inv_RscPictureKeepAspect
		{
			idc=INVENTORY_FILTER_4_IMAGE_IDC;
			x=0.742344 * safezoneW + safezoneX;
			y=0.278 * safezoneH + safezoneY;
			w=0.0103125 * safezoneW;
			h=0.022 * safezoneH;
		};
		class INVENTORY_FILTER_4_BUTTON: A3PL_Inv_RscButtonSilent
		{
			idc=INVENTORY_FILTER_4_BUTTON_IDC;
			x=0.742344 * safezoneW + safezoneX;
			y=0.278 * safezoneH + safezoneY;
			w=0.0103125 * safezoneW;
			h=0.022 * safezoneH;
		};

		// ========== LIGNE 2: virtual, keys, licenses ==========
		class INVENTORY_FILTER_5_IMAGE: A3PL_Inv_RscPictureKeepAspect
		{
			idc=INVENTORY_FILTER_5_IMAGE_IDC;
			x=0.690781 * safezoneW + safezoneX;
			y=0.302 * safezoneH + safezoneY;
			w=0.0103125 * safezoneW;
			h=0.022 * safezoneH;
		};
		class INVENTORY_FILTER_5_BUTTON: A3PL_Inv_RscButtonSilent
		{
			idc=INVENTORY_FILTER_5_BUTTON_IDC;
			x=0.690781 * safezoneW + safezoneX;
			y=0.302 * safezoneH + safezoneY;
			w=0.0103125 * safezoneW;
			h=0.022 * safezoneH;
		};

		class INVENTORY_FILTER_6_IMAGE: A3PL_Inv_RscPictureKeepAspect
		{
			idc=INVENTORY_FILTER_6_IMAGE_IDC;
			x=0.711406 * safezoneW + safezoneX;
			y=0.302 * safezoneH + safezoneY;
			w=0.0103125 * safezoneW;
			h=0.022 * safezoneH;
		};
		class INVENTORY_FILTER_6_BUTTON: A3PL_Inv_RscButtonSilent
		{
			idc=INVENTORY_FILTER_6_BUTTON_IDC;
			x=0.711406 * safezoneW + safezoneX;
			y=0.302 * safezoneH + safezoneY;
			w=0.0103125 * safezoneW;
			h=0.022 * safezoneH;
		};

		class INVENTORY_FILTER_7_IMAGE: A3PL_Inv_RscPictureKeepAspect
		{
			idc=INVENTORY_FILTER_7_IMAGE_IDC;
			x=0.732031 * safezoneW + safezoneX;
			y=0.302 * safezoneH + safezoneY;
			w=0.0103125 * safezoneW;
			h=0.022 * safezoneH;
		};
		class INVENTORY_FILTER_7_BUTTON: A3PL_Inv_RscButtonSilent
		{
			idc=INVENTORY_FILTER_7_BUTTON_IDC;
			x=0.732031 * safezoneW + safezoneX;
			y=0.302 * safezoneH + safezoneY;
			w=0.0103125 * safezoneW;
			h=0.022 * safezoneH;
		};

		// Main inventory grid (replaces old listbox)
		class INVENTORY_GRID_GROUP: RscControlsGroup
		{
			idc=INVENTORY_GRID_GROUP_IDC;
			x=0.546406 * safezoneW + safezoneX;
			y=0.324 * safezoneH + safezoneY;
			w=0.216563 * safezoneW;
			h=0.385 * safezoneH;
			class VScrollbar
			{
				color[]={1,1,1,0.6};
				colorActive[]={1,1,1,1};
				colorDisabled[]={1,1,1,0.3};
				width=0.012;
				autoScrollEnabled=1;
			};
			class HScrollbar
			{
				color[]={1,1,1,0.6};
				colorActive[]={1,1,1,1};
				colorDisabled[]={1,1,1,0.3};
				height=0.012;
			};
			class Controls
			{
				// Grid cells and items will be created dynamically
			};
		};

		// Legacy listbox (hidden, kept for compatibility during transition)
		class INVENTORY_LIST: A3PL_Inv_RscListBox
		{
			idc=INVENTORY_LIST_IDC;
			rowHeight=SIZE_RELATIVE(2);
			onMouseButtonDown="if ((_this#1) isEqualTo 1) then {uiNamespace setVariable ['InventoryClickTarget', _this#0]}";
			onLBSelChanged="[] call A3PL_InventoryNew_ClearRightClick;";
			x=10 * safezoneW + safezoneX;
			y=10 * safezoneH + safezoneY;
			w=0;
			h=0;
		};

		// Drag preview picture (follows mouse during drag)
		class INVENTORY_GRID_DRAG_PICTURE: A3PL_Inv_RscPictureKeepAspect
		{
			idc=INVENTORY_GRID_DRAG_PICTURE_IDC;
			x=0;
			y=0;
			w=0;
			h=0;
			colorBackground[]={0,0,0,0};
		};

		// Tooltip for grid items
		class INVENTORY_GRID_TOOLTIP: A3PL_Inv_RscStructuredText
		{
			idc=INVENTORY_GRID_TOOLTIP_IDC;
			x=0;
			y=0;
			w=0.15 * safezoneW;
			h=0.1 * safezoneH;
			colorBackground[]={0,0,0,0.8};
		};

		// Player info (playtime and premium)
		class INVENTORY_PLAYTIME: A3PL_Inv_RscStructuredText
		{
			idc=INVENTORY_PLAYTIME_IDC;
			x=0.546406 * safezoneW + safezoneX;
			y=0.715 * safezoneH + safezoneY;
			w=0.216563 * safezoneW;
			h=0.022 * safezoneH;
			size=SIZE_RELATIVE(0.85);
		};
		class INVENTORY_PREMIUM: A3PL_Inv_RscStructuredText
		{
			idc=INVENTORY_PREMIUM_IDC;
			x=0.546406 * safezoneW + safezoneX;
			y=0.737 * safezoneH + safezoneY;
			w=0.216563 * safezoneW;
			h=0.022 * safezoneH;
			size=SIZE_RELATIVE(0.85);
		};

		// Progress bar group
		class INVENTORY_PROGRESS: A3PL_Inv_RscControlsGroupNoScrollbars
		{
			x=0.551562 * safezoneW + safezoneX;
			y=0.258 * safezoneH + safezoneY;
			w=0.20625 * safezoneW;
			h=0.022 * safezoneH;
			class Controls
			{
				class ProgressBarHidden: A3PL_Inv_RscProgressBar
				{
					colorBar[]={
						"(profilenamespace getvariable ['GUI_BCG_RGB_R',0])",
						"(profilenamespace getvariable ['GUI_BCG_RGB_G',0])",
						"(profilenamespace getvariable ['GUI_BCG_RGB_B',0])",
						"0.4"
					};
					onLoad="(_this#0) progressSetPosition 1;";
					x=0;
					y=0;
					w=0.20625 * safezoneW;
					h=0.022 * safezoneH;
				};
				class ProgressBarMain: A3PL_Inv_RscProgressBar
				{
					idc=INVENTORY_PROGRESS_BAR_IDC;
					colorBar[]={
						"(profilenamespace getvariable ['GUI_BCG_RGB_R',0])",
						"(profilenamespace getvariable ['GUI_BCG_RGB_G',0])",
						"(profilenamespace getvariable ['GUI_BCG_RGB_B',0])",
						"1"
					};
					x=0;
					y=0;
					w=0.20625 * safezoneW;
					h=0.022 * safezoneH;
				};
				class Text: A3PL_Inv_RscText
				{
					idc=INVENTORY_PROGRESS_TITLE_IDC;
					sizeEx=SIZE_RELATIVE(0.9);
					x=0;
					y=0;
					w=0.20625 * safezoneW;
					h=0.022 * safezoneH;
				};
			};
		};

		// Equipment pictures
		class EQUIPMENT_HANDGUNWEAPON_PICTURE: A3PL_Inv_RscPictureKeepAspect
		{
			idc=EQUIPMENT_HANDGUNWEAPON_PICTURE_IDC;
			text="\A3PL_Common\GUI\inventory\ui_handgun_gs.paa";
			x=0.298981 * safezoneW + safezoneX;
			y=0.588024 * safezoneH + safezoneY;
			w=0.0979687 * safezoneW;
			h=0.077 * safezoneH;
		};
		class EQUIPMENT_BINOCULARS_PICTURE: A3PL_Inv_RscPictureKeepAspect
		{
			idc=EQUIPMENT_BINOCULARS_PICTURE_IDC;
			text="\A3PL_Common\GUI\inventory\ui_binoculars_gs.paa";
			x=0.247438 * safezoneW + safezoneX;
			y=0.257935 * safezoneH + safezoneY;
			w=0.0464063 * safezoneW;
			h=0.077 * safezoneH;
		};
		class EQUIPMENT_COMPASS_PICTURE: A3PL_Inv_RscPictureKeepAspect
		{
			idc=EQUIPMENT_COMPASS_PICTURE_IDC;
			text="\A3PL_Common\GUI\inventory\ui_compass_gs.paa";
			x=0.298981 * safezoneW + safezoneX;
			y=0.257935 * safezoneH + safezoneY;
			w=0.0464063 * safezoneW;
			h=0.077 * safezoneH;
		};
		class EQUIPMENT_MAP_PICTURE: A3PL_Inv_RscPictureKeepAspect
		{
			idc=EQUIPMENT_MAP_PICTURE_IDC;
			text="\A3PL_Common\GUI\inventory\ui_map_gs.paa";
			x=0.350524 * safezoneW + safezoneX;
			y=0.257935 * safezoneH + safezoneY;
			w=0.0464063 * safezoneW;
			h=0.077 * safezoneH;
		};
		class EQUIPMENT_WATCH_PICTURE: A3PL_Inv_RscPictureKeepAspect
		{
			idc=EQUIPMENT_WATCH_PICTURE_IDC;
			text="\A3PL_Common\GUI\inventory\ui_watch_gs.paa";
			x=0.195895 * safezoneW + safezoneX;
			y=0.257935 * safezoneH + safezoneY;
			w=0.0464063 * safezoneW;
			h=0.077 * safezoneH;
		};
		class EQUIPMENT_PRIMARYWEAPON_PICTURE: A3PL_Inv_RscPictureKeepAspect
		{
			idc=EQUIPMENT_PRIMARYWEAPON_PICTURE_IDC;
			text="\A3PL_Common\GUI\inventory\ui_primary_gs.paa";
			x=0.298981 * safezoneW + safezoneX;
			y=0.345959 * safezoneH + safezoneY;
			w=0.0979687 * safezoneW;
			h=0.077 * safezoneH;
		};
		class EQUIPMENT_SECONDARYWEAPON_PICTURE: A3PL_Inv_RscPictureKeepAspect
		{
			idc=EQUIPMENT_SECONDARYWEAPON_PICTURE_IDC;
			text="\A3PL_Common\GUI\inventory\ui_secondary_gs.paa";
			x=0.298981 * safezoneW + safezoneX;
			y=0.466991 * safezoneH + safezoneY;
			w=0.0979687 * safezoneW;
			h=0.077 * safezoneH;
		};
		class EQUIPMENT_PRIMARYWEAPON_FLASHLIGHT_PICTURE: A3PL_Inv_RscPictureKeepAspect
		{
			idc=EQUIPMENT_PRIMARYWEAPON_FLASHLIGHT_PICTURE_IDC;
			text="\A3PL_Common\GUI\inventory\ui_flashlight_gs.paa";
			x=0.298981 * safezoneW + safezoneX;
			y=0.422979 * safezoneH + safezoneY;
			w=0.020625 * safezoneW;
			h=0.033 * safezoneH;
		};
		class EQUIPMENT_SECONDARYWEAPON_FLASHLIGHT_PICTURE: A3PL_Inv_RscPictureKeepAspect
		{
			idc=EQUIPMENT_SECONDARYWEAPON_FLASHLIGHT_PICTURE_IDC;
			text="\A3PL_Common\GUI\inventory\ui_flashlight_gs.paa";
			x=0.298981 * safezoneW + safezoneX;
			y=0.544012 * safezoneH + safezoneY;
			w=0.020625 * safezoneW;
			h=0.033 * safezoneH;
		};
		class EQUIPMENT_HANDGUNWEAPON_FLASHLIGHT_PICTURE: A3PL_Inv_RscPictureKeepAspect
		{
			idc=EQUIPMENT_HANDGUNWEAPON_FLASHLIGHT_PICTURE_IDC;
			text="\A3PL_Common\GUI\inventory\ui_flashlight_gs.paa";
			x=0.298981 * safezoneW + safezoneX;
			y=0.665044 * safezoneH + safezoneY;
			w=0.020625 * safezoneW;
			h=0.033 * safezoneH;
		};
		class EQUIPMENT_HANDGUNWEAPON_MAGAZINE_PICTURE: A3PL_Inv_RscPictureKeepAspect
		{
			idc=EQUIPMENT_HANDGUNWEAPON_MAGAZINE_PICTURE_IDC;
			text="\A3PL_Common\GUI\inventory\ui_magazine_gs.paa";
			x=0.376296 * safezoneW + safezoneX;
			y=0.665044 * safezoneH + safezoneY;
			w=0.020625 * safezoneW;
			h=0.033 * safezoneH;
		};
		class EQUIPMENT_SECONDARYWEAPON_MAGAZINE_PICTURE: A3PL_Inv_RscPictureKeepAspect
		{
			idc=EQUIPMENT_SECONDARYWEAPON_MAGAZINE_PICTURE_IDC;
			text="\A3PL_Common\GUI\inventory\ui_magazine_gs.paa";
			x=0.376296 * safezoneW + safezoneX;
			y=0.544012 * safezoneH + safezoneY;
			w=0.020625 * safezoneW;
			h=0.033 * safezoneH;
		};
		class EQUIPMENT_PRIMARYWEAPON_MAGAZINE_PICTURE: A3PL_Inv_RscPictureKeepAspect
		{
			idc=EQUIPMENT_PRIMARYWEAPON_MAGAZINE_PICTURE_IDC;
			text="\A3PL_Common\GUI\inventory\ui_magazine_gs.paa";
			x=0.376296 * safezoneW + safezoneX;
			y=0.422979 * safezoneH + safezoneY;
			w=0.020625 * safezoneW;
			h=0.033 * safezoneH;
		};
		class EQUIPMENT_SECONDARYWEAPON_MUZZLE_PICTURE: A3PL_Inv_RscPictureKeepAspect
		{
			idc=EQUIPMENT_SECONDARYWEAPON_MUZZLE_PICTURE_IDC;
			text="\A3PL_Common\GUI\inventory\ui_muzzle_gs.paa";
			x=0.350524 * safezoneW + safezoneX;
			y=0.544012 * safezoneH + safezoneY;
			w=0.020625 * safezoneW;
			h=0.033 * safezoneH;
		};
		class EQUIPMENT_PRIMARYWEAPON_MUZZLE_PICTURE: A3PL_Inv_RscPictureKeepAspect
		{
			idc=EQUIPMENT_PRIMARYWEAPON_MUZZLE_PICTURE_IDC;
			text="\A3PL_Common\GUI\inventory\ui_muzzle_gs.paa";
			x=0.350524 * safezoneW + safezoneX;
			y=0.422979 * safezoneH + safezoneY;
			w=0.020625 * safezoneW;
			h=0.033 * safezoneH;
		};
		class EQUIPMENT_HANDGUNWEAPON_MUZZLE_PICTURE: A3PL_Inv_RscPictureKeepAspect
		{
			idc=EQUIPMENT_HANDGUNWEAPON_MUZZLE_PICTURE_IDC;
			text="\A3PL_Common\GUI\inventory\ui_muzzle_gs.paa";
			x=0.350524 * safezoneW + safezoneX;
			y=0.665044 * safezoneH + safezoneY;
			w=0.020625 * safezoneW;
			h=0.033 * safezoneH;
		};
		class EQUIPMENT_HANDGUNWEAPON_OPTIC_PICTURE: A3PL_Inv_RscPictureKeepAspect
		{
			idc=EQUIPMENT_HANDGUNWEAPON_OPTIC_PICTURE_IDC;
			text="\A3PL_Common\GUI\inventory\ui_optic_gs.paa";
			x=0.324753 * safezoneW + safezoneX;
			y=0.665044 * safezoneH + safezoneY;
			w=0.020625 * safezoneW;
			h=0.033 * safezoneH;
		};
		class EQUIPMENT_SECONDARYWEAPON_OPTIC_PICTURE: A3PL_Inv_RscPictureKeepAspect
		{
			idc=EQUIPMENT_SECONDARYWEAPON_OPTIC_PICTURE_IDC;
			text="\A3PL_Common\GUI\inventory\ui_optic_gs.paa";
			x=0.324753 * safezoneW + safezoneX;
			y=0.544012 * safezoneH + safezoneY;
			w=0.020625 * safezoneW;
			h=0.033 * safezoneH;
		};
		class EQUIPMENT_PRIMARYWEAPON_OPTIC_PICTURE: A3PL_Inv_RscPictureKeepAspect
		{
			idc=EQUIPMENT_PRIMARYWEAPON_OPTIC_PICTURE_IDC;
			text="\A3PL_Common\GUI\inventory\ui_optic_gs.paa";
			x=0.324753 * safezoneW + safezoneX;
			y=0.422979 * safezoneH + safezoneY;
			w=0.020625 * safezoneW;
			h=0.033 * safezoneH;
		};
		class EQUIPMENT_UNIFORM_PICTURE: A3PL_Inv_RscPictureKeepAspect
		{
			idc=EQUIPMENT_UNIFORM_PICTURE_IDC;
			text="\A3PL_Common\GUI\inventory\ui_uniform_gs.paa";
			x=0.195895 * safezoneW + safezoneX;
			y=0.522006 * safezoneH + safezoneY;
			w=0.0464063 * safezoneW;
			h=0.077 * safezoneH;
		};
		class EQUIPMENT_BACKPACK_PICTURE: A3PL_Inv_RscPictureKeepAspect
		{
			idc=EQUIPMENT_BACKPACK_PICTURE_IDC;
			text="\A3PL_Common\GUI\inventory\ui_backpack_gs.paa";
			x=0.247438 * safezoneW + safezoneX;
			y=0.566018 * safezoneH + safezoneY;
			w=0.0464063 * safezoneW;
			h=0.077 * safezoneH;
		};
		class EQUIPMENT_VEST_PICTURE: A3PL_Inv_RscPictureKeepAspect
		{
			idc=EQUIPMENT_VEST_PICTURE_IDC;
			text="\A3PL_Common\GUI\inventory\ui_vest_gs.paa";
			x=0.247438 * safezoneW + safezoneX;
			y=0.477994 * safezoneH + safezoneY;
			w=0.0464063 * safezoneW;
			h=0.077 * safezoneH;
		};
		class EQUIPMENT_HEADGEAR_PICTURE: A3PL_Inv_RscPictureKeepAspect
		{
			idc=EQUIPMENT_HEADGEAR_PICTURE_IDC;
			text="\A3PL_Common\GUI\inventory\ui_headgear_gs.paa";
			x=0.195895 * safezoneW + safezoneX;
			y=0.433982 * safezoneH + safezoneY;
			w=0.0464063 * safezoneW;
			h=0.077 * safezoneH;
		};
		class EQUIPMENT_GOGGLES_PICTURE: A3PL_Inv_RscPictureKeepAspect
		{
			idc=EQUIPMENT_GOGGLES_PICTURE_IDC;
			text="\A3PL_Common\GUI\inventory\ui_goggles_gs.paa";
			x=0.247438 * safezoneW + safezoneX;
			y=0.38997 * safezoneH + safezoneY;
			w=0.0464063 * safezoneW;
			h=0.077 * safezoneH;
		};

		// Equipment buttons
		class EQUIPMENT_SECONDARYWEAPON_BUTTON: A3PL_Inv_RscButtonSilent
		{
			idc=EQUIPMENT_SECONDARYWEAPON_BUTTON_IDC;
			x=0.298981 * safezoneW + safezoneX;
			y=0.466991 * safezoneH + safezoneY;
			w=0.0979687 * safezoneW;
			h=0.077 * safezoneH;
		};
		class EQUIPMENT_PRIMARYWEAPON_BUTTON: A3PL_Inv_RscButtonSilent
		{
			idc=EQUIPMENT_PRIMARYWEAPON_BUTTON_IDC;
			x=0.298981 * safezoneW + safezoneX;
			y=0.345959 * safezoneH + safezoneY;
			w=0.0979687 * safezoneW;
			h=0.077 * safezoneH;
		};
		class EQUIPMENT_HANDGUNWEAPON_BUTTON: A3PL_Inv_RscButtonSilent
		{
			idc=EQUIPMENT_HANDGUNWEAPON_BUTTON_IDC;
			x=0.298981 * safezoneW + safezoneX;
			y=0.588024 * safezoneH + safezoneY;
			w=0.0979322 * safezoneW;
			h=0.0770207 * safezoneH;
		};
		class EQUIPMENT_BINOCULARS_BUTTON: A3PL_Inv_RscButtonSilent
		{
			idc=EQUIPMENT_BINOCULARS_BUTTON_IDC;
			x=0.247438 * safezoneW + safezoneX;
			y=0.257935 * safezoneH + safezoneY;
			w=0.0464063 * safezoneW;
			h=0.077 * safezoneH;
		};
		class EQUIPMENT_COMPASS_BUTTON: A3PL_Inv_RscButtonSilent
		{
			idc=EQUIPMENT_COMPASS_BUTTON_IDC;
			x=0.298981 * safezoneW + safezoneX;
			y=0.257935 * safezoneH + safezoneY;
			w=0.0464063 * safezoneW;
			h=0.077 * safezoneH;
		};
		class EQUIPMENT_HEADGEAR_BUTTON: A3PL_Inv_RscButtonSilent
		{
			idc=EQUIPMENT_HEADGEAR_BUTTON_IDC;
			x=0.195895 * safezoneW + safezoneX;
			y=0.433982 * safezoneH + safezoneY;
			w=0.0464063 * safezoneW;
			h=0.077 * safezoneH;
		};
		class EQUIPMENT_WATCH_BUTTON: A3PL_Inv_RscButtonSilent
		{
			idc=EQUIPMENT_WATCH_BUTTON_IDC;
			x=0.195895 * safezoneW + safezoneX;
			y=0.257935 * safezoneH + safezoneY;
			w=0.0464063 * safezoneW;
			h=0.077 * safezoneH;
		};
		class EQUIPMENT_GOGGLES_BUTTON: A3PL_Inv_RscButtonSilent
		{
			idc=EQUIPMENT_GOGGLES_BUTTON_IDC;
			x=0.247438 * safezoneW + safezoneX;
			y=0.38997 * safezoneH + safezoneY;
			w=0.0464063 * safezoneW;
			h=0.077 * safezoneH;
		};
		class EQUIPMENT_VEST_BUTTON: A3PL_Inv_RscButtonSilent
		{
			idc=EQUIPMENT_VEST_BUTTON_IDC;
			x=0.247438 * safezoneW + safezoneX;
			y=0.477994 * safezoneH + safezoneY;
			w=0.0464063 * safezoneW;
			h=0.077 * safezoneH;
		};
		class EQUIPMENT_UNIFORM_BUTTON: A3PL_Inv_RscButtonSilent
		{
			idc=EQUIPMENT_UNIFORM_BUTTON_IDC;
			x=0.195895 * safezoneW + safezoneX;
			y=0.522006 * safezoneH + safezoneY;
			w=0.0464063 * safezoneW;
			h=0.077 * safezoneH;
		};
		class EQUIPMENT_BACKPACK_BUTTON: A3PL_Inv_RscButtonSilent
		{
			idc=EQUIPMENT_BACKPACK_BUTTON_IDC;
			x=0.247438 * safezoneW + safezoneX;
			y=0.566018 * safezoneH + safezoneY;
			w=0.0464063 * safezoneW;
			h=0.077 * safezoneH;
		};

		// Weapon attachments buttons
		class EQUIPMENT_PRIMARYWEAPON_FLASHLIGHT_BUTTON: A3PL_Inv_RscButtonSilent
		{
			idc=EQUIPMENT_PRIMARYWEAPON_FLASHLIGHT_BUTTON_IDC;
			x=0.298981 * safezoneW + safezoneX;
			y=0.422979 * safezoneH + safezoneY;
			w=0.020625 * safezoneW;
			h=0.033 * safezoneH;
		};
		class EQUIPMENT_PRIMARYWEAPON_MAGAZINE_BUTTON: A3PL_Inv_RscButtonSilent
		{
			idc=EQUIPMENT_PRIMARYWEAPON_MAGAZINE_BUTTON_IDC;
			x=0.376296 * safezoneW + safezoneX;
			y=0.422979 * safezoneH + safezoneY;
			w=0.020625 * safezoneW;
			h=0.033 * safezoneH;
		};
		class EQUIPMENT_PRIMARYWEAPON_MUZZLE_BUTTON: A3PL_Inv_RscButtonSilent
		{
			idc=EQUIPMENT_PRIMARYWEAPON_MUZZLE_BUTTON_IDC;
			x=0.350524 * safezoneW + safezoneX;
			y=0.422979 * safezoneH + safezoneY;
			w=0.020625 * safezoneW;
			h=0.033 * safezoneH;
		};
		class EQUIPMENT_PRIMARYWEAPON_OPTIC_BUTTON: A3PL_Inv_RscButtonSilent
		{
			idc=EQUIPMENT_PRIMARYWEAPON_OPTIC_BUTTON_IDC;
			x=0.324753 * safezoneW + safezoneX;
			y=0.422979 * safezoneH + safezoneY;
			w=0.020625 * safezoneW;
			h=0.033 * safezoneH;
		};
		class EQUIPMENT_SECONDARYWEAPON_FLASHLIGHT_BUTTON: A3PL_Inv_RscButtonSilent
		{
			idc=EQUIPMENT_SECONDARYWEAPON_FLASHLIGHT_BUTTON_IDC;
			x=0.298981 * safezoneW + safezoneX;
			y=0.544012 * safezoneH + safezoneY;
			w=0.020625 * safezoneW;
			h=0.033 * safezoneH;
		};
		class EQUIPMENT_SECONDARYWEAPON_MAGAZINE_BUTTON: A3PL_Inv_RscButtonSilent
		{
			idc=EQUIPMENT_SECONDARYWEAPON_MAGAZINE_BUTTON_IDC;
			x=0.376296 * safezoneW + safezoneX;
			y=0.544012 * safezoneH + safezoneY;
			w=0.020625 * safezoneW;
			h=0.033 * safezoneH;
		};
		class EQUIPMENT_SECONDARYWEAPON_MUZZLE_BUTTON: A3PL_Inv_RscButtonSilent
		{
			idc=EQUIPMENT_SECONDARYWEAPON_MUZZLE_BUTTON_IDC;
			x=0.350524 * safezoneW + safezoneX;
			y=0.544012 * safezoneH + safezoneY;
			w=0.020625 * safezoneW;
			h=0.033 * safezoneH;
		};
		class EQUIPMENT_SECONDARYWEAPON_OPTIC_BUTTON: A3PL_Inv_RscButtonSilent
		{
			idc=EQUIPMENT_SECONDARYWEAPON_OPTIC_BUTTON_IDC;
			x=0.324753 * safezoneW + safezoneX;
			y=0.544012 * safezoneH + safezoneY;
			w=0.020625 * safezoneW;
			h=0.033 * safezoneH;
		};
		class EQUIPMENT_HANDGUNWEAPON_FLASHLIGHT_BUTTON: A3PL_Inv_RscButtonSilent
		{
			idc=EQUIPMENT_HANDGUNWEAPON_FLASHLIGHT_BUTTON_IDC;
			x=0.298981 * safezoneW + safezoneX;
			y=0.665044 * safezoneH + safezoneY;
			w=0.020625 * safezoneW;
			h=0.033 * safezoneH;
		};
		class EQUIPMENT_HANDGUNWEAPON_MAGAZINE_BUTTON: A3PL_Inv_RscButtonSilent
		{
			idc=EQUIPMENT_HANDGUNWEAPON_MAGAZINE_BUTTON_IDC;
			x=0.376296 * safezoneW + safezoneX;
			y=0.665044 * safezoneH + safezoneY;
			w=0.020625 * safezoneW;
			h=0.033 * safezoneH;
		};
		class EQUIPMENT_HANDGUNWEAPON_MUZZLE_BUTTON: A3PL_Inv_RscButtonSilent
		{
			idc=EQUIPMENT_HANDGUNWEAPON_MUZZLE_BUTTON_IDC;
			x=0.350524 * safezoneW + safezoneX;
			y=0.665044 * safezoneH + safezoneY;
			w=0.020625 * safezoneW;
			h=0.033 * safezoneH;
		};
		class EQUIPMENT_HANDGUNWEAPON_OPTIC_BUTTON: A3PL_Inv_RscButtonSilent
		{
			idc=EQUIPMENT_HANDGUNWEAPON_OPTIC_BUTTON_IDC;
			x=0.324753 * safezoneW + safezoneX;
			y=0.665044 * safezoneH + safezoneY;
			w=0.020625 * safezoneW;
			h=0.033 * safezoneH;
		};
		class EQUIPMENT_MAP_BUTTON: A3PL_Inv_RscButtonSilent
		{
			idc=EQUIPMENT_MAP_BUTTON_IDC;
			x=0.350524 * safezoneW + safezoneX;
			y=0.257935 * safezoneH + safezoneY;
			w=0.0464063 * safezoneW;
			h=0.077 * safezoneH;
		};

	};
};

// ============================================================================
// TRANSFER DISPLAY
// ============================================================================

class A3PL_RscDisplayTransferNew: A3PL_Inv_RscDisplayDefault
{
	idd=TRANSFER_DISPLAY_IDD;
	name=TRANSFER_DISPLAY_NAME;

	class controlsBackground
	{
		class TRANSFER_TARGET_BACKGROUND: A3PL_Inv_IGUIBack
		{
			x=0.293827 * safezoneW + safezoneX;
			y=0.257935 * safezoneH + safezoneY;
			w=0.180401 * safezoneW;
			h=0.517139 * safezoneH;
		};
		class TRANSFER_PLAYER_BACKGROUND: A3PL_Inv_IGUIBack
		{
			x=0.520617 * safezoneW + safezoneX;
			y=0.257935 * safezoneH + safezoneY;
			w=0.185556 * safezoneW;
			h=0.517139 * safezoneH;
		};
	};

	class controls
	{
		class TRANSFER_TARGET_HEADER: A3PL_Inv_RscHeader
		{
			idc=TRANSFER_TARGET_HEADER_IDC;
			text="Target";
			x=0.293827 * safezoneW + safezoneX;
			y=0.224926 * safezoneH + safezoneY;
			w=0.180401 * safezoneW;
			h=0.0330089 * safezoneH;
		};
		class TRANSFER_TARGET_PROGRESS: A3PL_Inv_RscControlsGroupNoScrollbars
		{
			x=0.298981 * safezoneW + safezoneX;
			y=0.742065 * safezoneH + safezoneY;
			w=0.170093 * safezoneW;
			h=0.0220059 * safezoneH;
			class Controls
			{
				class ProgressBarHidden: A3PL_Inv_RscProgressBar
				{
					colorBar[]={
						"(profilenamespace getvariable ['GUI_BCG_RGB_R',0])",
						"(profilenamespace getvariable ['GUI_BCG_RGB_G',0])",
						"(profilenamespace getvariable ['GUI_BCG_RGB_B',0])",
						"0.4"
					};
					onLoad="(_this#0) progressSetPosition 1;";
					x=0;
					y=0;
					w=0.170093 * safezoneW;
					h=0.0220059 * safezoneH;
				};
				class ProgressBarMain: A3PL_Inv_RscProgressBar
				{
					idc=TRANSFER_TARGET_PROGRESSBAR_IDC;
					colorBar[]={
						"(profilenamespace getvariable ['GUI_BCG_RGB_R',0])",
						"(profilenamespace getvariable ['GUI_BCG_RGB_G',0])",
						"(profilenamespace getvariable ['GUI_BCG_RGB_B',0])",
						"1"
					};
					x=0;
					y=0;
					w=0.170093 * safezoneW;
					h=0.0220059 * safezoneH;
				};
				class Text: A3PL_Inv_RscText
				{
					idc=TRANSFER_TARGET_PROGRESS_INFO_IDC;
					sizeEx=SIZE_RELATIVE(0.9);
					x=0;
					y=0;
					w=0.170093 * safezoneW;
					h=0.0220059 * safezoneH;
				};
			};
		};
		class TRANSFER_TARGET_INVENTORY_LIST: A3PL_Inv_RscListBoxMulti
		{
			idc=TRANSFER_TARGET_INVENTORY_LIST_IDC;
			rowHeight=SIZE_RELATIVE(2);
			onLBDrop="_this call A3PL_InventoryNew_TransferMenuOnLbDropTarget;";
			onLBDblClick="_this call A3PL_InventoryNew_TransferMenuOnLbDblClickTarget;";
			canDrag=1;
			x=0.298981 * safezoneW + safezoneX;
			y=0.268938 * safezoneH + safezoneY;
			w=0.170093 * safezoneW;
			h=0.462124 * safezoneH;
		};

		class TRANSFER_PLAYER_HEADER: A3PL_Inv_RscHeader
		{
			idc=TRANSFER_PLAYER_HEADER_IDC;
			text="You";
			x=0.520617 * safezoneW + safezoneX;
			y=0.224926 * safezoneH + safezoneY;
			w=0.185556 * safezoneW;
			h=0.0330089 * safezoneH;
		};
		class TRANSFER_PLAYER_PROGRESS: A3PL_Inv_RscControlsGroupNoScrollbars
		{
			x=0.525772 * safezoneW + safezoneX;
			y=0.742065 * safezoneH + safezoneY;
			w=0.175247 * safezoneW;
			h=0.0220059 * safezoneH;
			class Controls
			{
				class ProgressBarHidden: A3PL_Inv_RscProgressBar
				{
					colorBar[]={
						"(profilenamespace getvariable ['GUI_BCG_RGB_R',0])",
						"(profilenamespace getvariable ['GUI_BCG_RGB_G',0])",
						"(profilenamespace getvariable ['GUI_BCG_RGB_B',0])",
						"0.4"
					};
					onLoad="(_this#0) progressSetPosition 1;";
					x=0;
					y=0;
					w=0.175247 * safezoneW;
					h=0.0220059 * safezoneH;
				};
				class ProgressBarMain: A3PL_Inv_RscProgressBar
				{
					idc=TRANSFER_PLAYER_PROGRESSBAR_IDC;
					colorBar[]={
						"(profilenamespace getvariable ['GUI_BCG_RGB_R',0])",
						"(profilenamespace getvariable ['GUI_BCG_RGB_G',0])",
						"(profilenamespace getvariable ['GUI_BCG_RGB_B',0])",
						"1"
					};
					x=0;
					y=0;
					w=0.175247 * safezoneW;
					h=0.0220059 * safezoneH;
				};
				class Text: A3PL_Inv_RscText
				{
					idc=TRANSFER_PLAYER_PROGRESS_INFO_IDC;
					sizeEx=SIZE_RELATIVE(0.9);
					x=0;
					y=0;
					w=0.175247 * safezoneW;
					h=0.0220059 * safezoneH;
				};
			};
		};
		class TRANSFER_PLAYER_INVENTORY_LIST: A3PL_Inv_RscListBoxMulti
		{
			idc=TRANSFER_PLAYER_INVENTORY_LIST_IDC;
			onLBDrop="_this call A3PL_InventoryNew_TransferMenuOnLbDropPlayer;";
			onLBDblClick="_this call A3PL_InventoryNew_TransferMenuOnLbDblClickPlayer;";
			rowHeight=SIZE_RELATIVE(2);
			canDrag=1;
			x=0.525772 * safezoneW + safezoneX;
			y=0.268938 * safezoneH + safezoneY;
			w=0.175247 * safezoneW;
			h=0.462124 * safezoneH;
		};

		class TRANSFER_TOOLTIP: A3PL_Inv_RscStructuredText
		{
			idc=TRANSFER_TOOLTIP_IDC;
			text="Drag and drop items to transfer them";
			colorBackground[]={0, 0, 0, 0.8};
			x=0.35 * safezoneW + safezoneX;
			y=0.786077 * safezoneH + safezoneY;
			w=0.295 * safezoneW;
			h=0.055 * safezoneH;
			class Attributes
			{
				align="center";
				valign="middle";
			};
		};
	};
};
