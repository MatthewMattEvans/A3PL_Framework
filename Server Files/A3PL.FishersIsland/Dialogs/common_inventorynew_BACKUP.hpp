/*
	common_inventorynew.hpp
	Controles de base pour le nouveau systeme d'inventaire A3PL
	Adapte du framework Edaly
*/

#ifndef A3PL_INVENTORYNEW_COMMON_HPP
#define A3PL_INVENTORYNEW_COMMON_HPP

// Include defines (IDCs, slots, etc.)
#include "defines_inventorynew.hpp"

// ============================================================================
// LOCAL DEFINES (pour les classes UI)
// ============================================================================

#define A3PL_INV_FONT "PuristaMedium"

#define SIZE_RELATIVE(VALUE) VALUE * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)

#define TOOLTIP_SHADE_COLOR {0,0,0,1}
#define TOOLTIP_BOX_COLOR {0,0,0,1}
#define TOOLTIP_TEXT_COLOR {1,1,1,1}

// Control types
#ifndef CT_STATIC
#define CT_STATIC                           0
#define CT_BUTTON                           1
#define CT_EDIT                             2
#define CT_SLIDER                           3
#define CT_COMBO                            4
#define CT_LISTBOX                          5
#define CT_TOOLBOX                          6
#define CT_CHECKBOXES                       7
#define CT_PROGRESS                         8
#define CT_HTML                             9
#define CT_STATIC_SKEW                      10
#define CT_ACTIVETEXT                       11
#define CT_TREE                             12
#define CT_STRUCTURED_TEXT                  13
#define CT_CONTEXT_MENU                     14
#define CT_CONTROLS_GROUP                   15
#define CT_SHORTCUTBUTTON                   16
#define CT_OBJECT                           80
#define CT_LISTNBOX                         102
#define CT_CHECKBOX                         77
#endif

// Static styles
#ifndef ST_LEFT
#define ST_POS                              0x0F
#define ST_HPOS                             0x03
#define ST_VPOS                             0x0C
#define ST_LEFT                             0x00
#define ST_RIGHT                            0x01
#define ST_CENTER                           0x02
#define ST_DOWN                             0x04
#define ST_UP                               0x08
#define ST_VCENTER                          0x0C
#define ST_TYPE                             0xF0
#define ST_SINGLE                           0x00
#define ST_MULTI                            0x10
#define ST_TITLE_BAR                        0x20
#define ST_PICTURE                          0x30
#define ST_FRAME                            0x40
#define ST_BACKGROUND                       0x50
#define ST_GROUP_BOX                        0x60
#define ST_GROUP_BOX2                       0x70
#define ST_HUD_BACKGROUND                   0x80
#define ST_TILE_PICTURE                     0x90
#define ST_WITH_RECT                        0xA0
#define ST_LINE                             0xB0
#define ST_SHADOW                           0x100
#define ST_NO_RECT                          0x200
#define ST_KEEP_ASPECT_RATIO                0x800
#define ST_TITLE                            ST_TITLE_BAR + ST_CENTER
#endif

// Listbox styles
#ifndef LB_TEXTURES
#define LB_TEXTURES                         0x10
#define LB_MULTI                            0x20
#endif

// ============================================================================
// BASE CONTROL CLASSES
// ============================================================================

class A3PL_Inv_RscFrame: RscFrame {
	colorText[]={0,0,0,0.6};
	shadow=0;
};

class A3PL_Inv_RscText: RscText {
	style=ST_CENTER;
	colorBackground[]={0,0,0,0};
	shadow=0;
	font=A3PL_INV_FONT;
};

class A3PL_Inv_RscTextRight: A3PL_Inv_RscText {
	style=ST_RIGHT;
};

class A3PL_Inv_RscTextLeft: A3PL_Inv_RscText {
	style=ST_LEFT;
};

class A3PL_Inv_RscTextMulti: A3PL_Inv_RscText {
	style=ST_MULTI + ST_NO_RECT;
	lineSpacing=1;
};

class A3PL_Inv_RscHeader: A3PL_Inv_RscText {
	sizeEx=SIZE_RELATIVE(1.3);
	colorBackground[]={
		"(profilenamespace getvariable ['GUI_BCG_RGB_R',0])",
		"(profilenamespace getvariable ['GUI_BCG_RGB_G',0])",
		"(profilenamespace getvariable ['GUI_BCG_RGB_B',0])",
		"1"
	};
};

class A3PL_Inv_RscButton: RscButton {
	shadow=0;
	colorBackground[]={0,0,0,0.8};
	colorBackgroundActive[]={0,0,0,1};
	colorBackgroundDisabled[]={1,1,1,0.2};
	colorText[]={1,1,1,1};
	colorActive[]={0,0,0,1};
	colorDisabled[]={1,1,1,0.4};
	colorFocused[]={0,0,0,1};
	font=A3PL_INV_FONT;
	sizeEx=SIZE_RELATIVE(1);
	tooltipColorText[]=TOOLTIP_TEXT_COLOR;
	tooltipColorShade[]=TOOLTIP_SHADE_COLOR;
	tooltipColorBox[]=TOOLTIP_BOX_COLOR;
};

class A3PL_Inv_RscButtonSilent: RscButton {
	shadow=0;
	colorBackground[]={0,0,0,0};
	colorBackgroundActive[]={0,0,0,0};
	colorBackgroundDisabled[]={0,0,0,0};
	colorDisabled[]={0,0,0,0};
	colorFocused[]={0,0,0,0};
	colorText[]={0,0,0,0};
	tooltipColorText[]=TOOLTIP_TEXT_COLOR;
	tooltipColorShade[]=TOOLTIP_SHADE_COLOR;
	tooltipColorBox[]=TOOLTIP_BOX_COLOR;
};

class A3PL_Inv_RscProgressBar: RscProgress {
	idc=-1;
	texture="\A3\ui_f\data\GUI\RscCommon\RscProgress\progressbar_ca.paa";
	colorExtBar[]={0,0,0,0};
	colorFrame[]={0,0,0,0};
	shadow=0;
};

class A3PL_Inv_RscEdit: RscEdit {
	shadow=0;
	font=A3PL_INV_FONT;
	style=ST_LEFT + ST_NO_RECT;
	colorBackground[]={0,0,0,0.8};
	colorText[]={1,1,1,1};
	tooltipColorText[]=TOOLTIP_TEXT_COLOR;
	tooltipColorShade[]=TOOLTIP_SHADE_COLOR;
	tooltipColorBox[]=TOOLTIP_BOX_COLOR;
};

class A3PL_Inv_RscListBox: RscListbox {
	font=A3PL_INV_FONT;
	colorBackground[]={0,0,0,0.6};
	tooltipColorText[]=TOOLTIP_TEXT_COLOR;
	tooltipColorShade[]=TOOLTIP_SHADE_COLOR;
	tooltipColorBox[]=TOOLTIP_BOX_COLOR;
};

class A3PL_Inv_RscListBoxMulti: RscListbox {
	font=A3PL_INV_FONT;
	colorBackground[]={0,0,0,0.6};
	tooltipColorText[]=TOOLTIP_TEXT_COLOR;
	tooltipColorShade[]=TOOLTIP_SHADE_COLOR;
	tooltipColorBox[]=TOOLTIP_BOX_COLOR;
	style=LB_MULTI;
};

class A3PL_Inv_RscStructuredText: RscStructuredText {
	colorBackground[]={0,0,0,0};
	shadow=0;
	class Attributes {
		align="left";
		color="#ffffff";
		colorLink="#D09B43";
		font=A3PL_INV_FONT;
		shadow=0;
	};
};

class A3PL_Inv_RscPicture: RscPicture {};

class A3PL_Inv_RscPictureKeepAspect: RscPicture {
	style=ST_PICTURE + ST_KEEP_ASPECT_RATIO;
};

class A3PL_Inv_IGUIBack: IGUIBack {
	colorBackground[]={0,0,0,0.3};
};

class A3PL_Inv_RscControlsGroupNoScrollbars: RscControlsGroupNoScrollbars {};

class A3PL_Inv_RscProgressBarGroup: A3PL_Inv_RscControlsGroupNoScrollbars {
	class BaseProgressControls {
		class ProgressBarHidden: A3PL_Inv_RscProgressBar {
			colorBar[]={
				"(profilenamespace getvariable ['GUI_BCG_RGB_R',0])",
				"(profilenamespace getvariable ['GUI_BCG_RGB_G',0])",
				"(profilenamespace getvariable ['GUI_BCG_RGB_B',0])",
				"0.4"
			};
			onLoad="(_this#0) progressSetPosition 1;";
			x=0;
			y=0;
		};
		class ProgressBarMain: A3PL_Inv_RscProgressBar {
			colorBar[]={
				"(profilenamespace getvariable ['GUI_BCG_RGB_R',0])",
				"(profilenamespace getvariable ['GUI_BCG_RGB_G',0])",
				"(profilenamespace getvariable ['GUI_BCG_RGB_B',0])",
				"1"
			};
			x=0;
			y=0;
		};
		class Text: A3PL_Inv_RscText {
			sizeEx=SIZE_RELATIVE(0.9);
			x=0;
			y=0;
		};
	};
};

// ============================================================================
// DEFAULT DISPLAY CLASS
// ============================================================================

class A3PL_Inv_RscDisplayDefault {
	idd=-1;
	fadein=0;
	fadeout=0;
	duration=1e+011;
	onLoad="";
	onUnload="";
	class controlsBackground {};
	class controls {};
};

#endif // A3PL_INVENTORYNEW_COMMON_HPP
