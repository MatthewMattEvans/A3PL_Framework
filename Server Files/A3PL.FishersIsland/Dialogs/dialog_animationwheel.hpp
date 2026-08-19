class Dialog_Animations_Menu
{
	idd = 6900;
	movingEnable = false;
	enableSimulation = true;

	class controlsBackground {

		/* Bottom */

		class RscPicture_1205: RscPicture
		{
			idc = 1205;
			text = "\A3PL_Common\InteractionData\Bottom.paa";
			x = 0.386562 * safezoneW + safezoneX;
			y = 0.313 * safezoneH + safezoneY;
			w = 0.216563 * safezoneW;
			h = 0.374 * safezoneH;
			colorBackground[] = {0,0,0,1};
		};

		/* Bottom Left */

		class RscPicture_1206: RscPicture
		{
			idc = 1206;
			text = "\A3PL_Common\InteractionData\BottomLeft.paa";
			x = 0.386562 * safezoneW + safezoneX;
			y = 0.313 * safezoneH + safezoneY;
			w = 0.216563 * safezoneW;
			h = 0.374 * safezoneH;
		};

		/* Center Left */
		
		class RscPicture_1208: RscPicture
		{
			idc = 1208;
			text = "\A3PL_Common\InteractionData\CenterLeft.paa";
			x = 0.386562 * safezoneW + safezoneX;
			y = 0.313 * safezoneH + safezoneY;
			w = 0.216563 * safezoneW;
			h = 0.374 * safezoneH;
		};

		/* Top Left */

		class RscPicture_1207: RscPicture
		{
			idc = 1207;
			text = "\A3PL_Common\InteractionData\TopLeft.paa";
			x = 0.386562 * safezoneW + safezoneX;
			y = 0.313 * safezoneH + safezoneY;
			w = 0.216563 * safezoneW;
			h = 0.374 * safezoneH;
		};
		/* Top */

		class RscPicture_1200: RscPicture
		{
			idc = 1200;
			text = "\A3PL_Common\InteractionData\Top.paa";
			x = 0.386562 * safezoneW + safezoneX;
			y = 0.313 * safezoneH + safezoneY;
			w = 0.216563 * safezoneW;
			h = 0.374 * safezoneH;
		};

		/* Top Right */

		class RscPicture_1201: RscPicture
		{
			idc = 1201;
			text = "\A3PL_Common\InteractionData\TopRight.paa";
			x = 0.386562 * safezoneW + safezoneX;
			y = 0.313 * safezoneH + safezoneY;
			w = 0.216563 * safezoneW;
			h = 0.374 * safezoneH;
		};

		/* Center Right */

		class RscPicture_1203: RscPicture
		{
			idc = 1203;
			text = "\A3PL_Common\InteractionData\CenterRight.paa";
			x = 0.386562 * safezoneW + safezoneX;
			y = 0.313 * safezoneH + safezoneY;
			w = 0.216563 * safezoneW;
			h = 0.374 * safezoneH;
		};
		
		/* Bottom Right */

		class RscPicture_1204: RscPicture
		{
			idc = 1204;
			text = "\A3PL_Common\InteractionData\BottomRight.paa";
			x = 0.386562 * safezoneW + safezoneX;
			y = 0.313 * safezoneH + safezoneY;
			w = 0.216563 * safezoneW;
			h = 0.374 * safezoneH;
		};
		
		/* Middle */

		class RscPicture_1202: RscPicture
		{
			idc = 1202;
			text = "\A3PL_Common\InteractionData\Middle.paa";
			x = 0.386562 * safezoneW + safezoneX;
			y = 0.313 * safezoneH + safezoneY;
			w = 0.216563 * safezoneW;
			h = 0.374 * safezoneH;
			colorBackground[] = {0,0,0,0.75};
		};
	};

	class controls {

		/* Center Left */

		class RscInteractionText_6901: RscInteractionText
		{
			idc = 6901;
			text = ""; 
			x = 0.386562 * safezoneW + safezoneX;
			y = 0.478 * safezoneH + safezoneY;
			w = 0.0567187 * safezoneW;
			h = 0.044 * safezoneH;
		};

		class RscCenterLeft: RscButtonInvisible
		{
			idc = 7100;
			action = "[0] spawn A3FL_Animations_animButtonPressed;";
			onMouseEnter = "ctrlSetText[1208, ""\A3PL_Common\InteractionData\CenterLeftActive.paa""];";
			onMouseExit = "ctrlSetText[1208, ""\A3PL_Common\InteractionData\CenterLeft.paa""];";
		};

		class RscButtonInvisible_1613: RscCenterLeft
		{
			idc = 1613;
			x = 0.386562 * safezoneW + safezoneX;
			y = 0.467 * safezoneH + safezoneY;
			w = 0.0567187 * safezoneW;
			h = 0.066 * safezoneH;
		};

		class RscButtonInvisible_1614: RscCenterLeft
		{
			idc = 1614;
			x = 0.389271 * safezoneW + safezoneX;
			y = 0.533 * safezoneH + safezoneY;
			w = 0.0436979 * safezoneW;
			h = 0.0132223 * safezoneH;
		};

		class RscButtonInvisible_1615: RscCenterLeft
		{
			idc = 1615;
			x = 0.387135 * safezoneW + safezoneX;
			y = 0.544 * safezoneH + safezoneY;
			w = 0.027552 * safezoneW;
			h = 0.0141484 * safezoneH;
		};

		class RscButtonInvisible_1616: RscCenterLeft
		{
			idc = 1616;
			x = 0.385938 * safezoneW + safezoneX;
			y = 0.45463 * safezoneH + safezoneY;
			w = 0.0436979 * safezoneW;
			h = 0.0132223 * safezoneH;
		};

		class RscButtonInvisible_1617: RscCenterLeft
		{
			idc = 1617;
			x = 0.386979 * safezoneW + safezoneX;
			y = 0.441667 * safezoneH + safezoneY;
			w = 0.027552 * safezoneW;
			h = 0.0141484 * safezoneH;
		};

		/* Top Left */

		class RscInteractionText_6902: RscInteractionText
		{
			idc = 6902;
			text = ""; 
			x = 0.402547 * safezoneW + safezoneX;
			y = 0.39286 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.044 * safezoneH;
		};

		class RscTopLeft: RscButtonInvisible
		{
			idc = 7101;
			action = "[1] spawn A3FL_Animations_animButtonPressed;";
			onMouseEnter = "ctrlSetText[1207, ""\A3PL_Common\InteractionData\TopLeftActive.paa""];";
			onMouseExit = "ctrlSetText[1207, ""\A3PL_Common\InteractionData\TopLeft.paa""];";
		};

		class RscButtonInvisible_1609: RscTopLeft
		{
			idc = 1609;
			x = 0.402031 * safezoneW + safezoneX;
			y = 0.379 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.055 * safezoneH;
		};

		class RscButtonInvisible_1610: RscTopLeft
		{
			idc = 1610;
			x = 0.4175 * safezoneW + safezoneX;
			y = 0.357 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.022 * safezoneH;
		};

		class RscButtonInvisible_1611: RscTopLeft
		{
			idc = 1611;
			x = 0.432136 * safezoneW + safezoneX;
			y = 0.336852 * safezoneH + safezoneY;
			w = 0.0225 * safezoneW;
			h = 0.0210741 * safezoneH;
		};

		class RscButtonInvisible_1612: RscTopLeft
		{
			idc = 1612;
			x = 0.424323 * safezoneW + safezoneX;
			y = 0.42763 * safezoneH + safezoneY;
			w = 0.0282292 * safezoneW;
			h = 0.0257037 * safezoneH;
		};

		/* Top */

		class RscInteractionText_6903: RscInteractionText
		{
			idc = 6903;
			text = ""; 
			x = 0.463906 * safezoneW + safezoneX;
			y = 0.335 * safezoneH + safezoneY;
			w = 0.061875 * safezoneW;
			h = 0.033 * safezoneH;
		};

		class RscTop: RscButtonInvisible
		{
			idc = 7102;
			action = "[2] spawn A3FL_Animations_animButtonPressed;";
			onMouseEnter = "ctrlSetText[1200, ""\A3PL_Common\InteractionData\TopActive.paa""];";
			onMouseExit = "ctrlSetText[1200, ""\A3PL_Common\InteractionData\Top.paa""];";
		};

		class RscButtonInvisible_1600: RscTop
		{
			idc = 1600;
			x = 0.474219 * safezoneW + safezoneX;
			y = 0.313 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.099 * safezoneH;
		};

		class RscButtonInvisible_1601: RscTop
		{
			idc = 1601;
			x = 0.464947 * safezoneW + safezoneX;
			y = 0.312889 * safezoneH + safezoneY;
			w = 0.0103125 * safezoneW;
			h = 0.066 * safezoneH;
		};

		class RscButtonInvisible_1602: RscTop
		{
			idc = 1602;
			x = 0.458854 * safezoneW + safezoneX;
			y = 0.325925 * safezoneH + safezoneY;
			w = 0.00770836 * safezoneW;
			h = 0.0317408 * safezoneH;
		};

		class RscButtonInvisible_1603: RscTop
		{
			idc = 1603;
			x = 0.514584 * safezoneW + safezoneX;
			y = 0.314814 * safezoneH + safezoneY;
			w = 0.0103125 * safezoneW;
			h = 0.066 * safezoneH;
		};

		class RscButtonInvisible_1604: RscTop
		{
			idc = 1604;
			x = 0.523437 * safezoneW + safezoneX;
			y = 0.318518 * safezoneH + safezoneY;
			w = 0.00770836 * safezoneW;
			h = 0.0317408 * safezoneH;
		};

		/* Top Right */

		class RscInteractionText_6904: RscInteractionText
		{
			idc = 6904;
			text = ""; 
			x = 0.520109 * safezoneW + safezoneX;
			y = 0.39286 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.033 * safezoneH;
		};

		class RscTopRight: RscButtonInvisible
		{
			idc = 7103;
			action = "[3] spawn A3FL_Animations_animButtonPressed;";
			onMouseEnter = "ctrlSetText[1201, ""\A3PL_Common\InteractionData\TopRightActive.paa""];";
			onMouseExit = "ctrlSetText[1201, ""\A3PL_Common\InteractionData\TopRight.paa""];";
		};

		class RscButtonInvisible_1605: RscTopRight
		{
			idc = 1605;
			x = 0.520625 * safezoneW + safezoneX;
			y = 0.379 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.055 * safezoneH;
		};

		class RscButtonInvisible_1606: RscTopRight
		{
			idc = 1606;
			x = 0.530937 * safezoneW + safezoneX;
			y = 0.357 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.022 * safezoneH;
		};

		class RscButtonInvisible_1607: RscTopRight
		{
			idc = 1607;
			x = 0.536094 * safezoneW + safezoneX;
			y = 0.335 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.022 * safezoneH;
		};

		class RscButtonInvisible_1608: RscTopRight
		{
			idc = 1608;
			x = 0.536145 * safezoneW + safezoneX;
			y = 0.432148 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.022 * safezoneH;
		};

		/* Center Right */

		class RscInteractionText_6905: RscInteractionText
		{
			idc = 6905;
			text = ""; 
			x = 0.546406 * safezoneW + safezoneX;
			y = 0.478 * safezoneH + safezoneY;
			w = 0.0567187 * safezoneW;
			h = 0.044 * safezoneH;
		};

		class RscCenterRight: RscButtonInvisible
		{
			idc = 7104;
			action = "[4] spawn A3FL_Animations_animButtonPressed;";
			onMouseEnter = "ctrlSetText[1203, ""\A3PL_Common\InteractionData\CenterRightActive.paa""];";
			onMouseExit = "ctrlSetText[1203, ""\A3PL_Common\InteractionData\CenterRight.paa""];";
		};

		class RscButtonInvisible_1618: RscCenterRight
		{
			idc = 1618;
			x = 0.546406 * safezoneW + safezoneX;
			y = 0.467 * safezoneH + safezoneY;
			w = 0.0567187 * safezoneW;
			h = 0.066 * safezoneH;
		};

		class RscButtonInvisible_1619: RscCenterRight
		{
			idc = 1619;
			x = 0.556719 * safezoneW + safezoneX;
			y = 0.533 * safezoneH + safezoneY;
			w = 0.0442187 * safezoneW;
			h = 0.0150741 * safezoneH;
		};

		class RscButtonInvisible_1620: RscCenterRight
		{
			idc = 1620;
			x = 0.576562 * safezoneW + safezoneX;
			y = 0.54537 * safezoneH + safezoneY;
			w = 0.0228646 * safezoneW;
			h = 0.0150741 * safezoneH;
		};

		class RscButtonInvisible_1621: RscCenterRight
		{
			idc = 1621;
			x = 0.557292 * safezoneW + safezoneX;
			y = 0.453704 * safezoneH + safezoneY;
			w = 0.0442187 * safezoneW;
			h = 0.0150741 * safezoneH;
		};

		class RscButtonInvisible_1622: RscCenterRight
		{
			idc = 1622;
			x = 0.573959 * safezoneW + safezoneX;
			y = 0.439815 * safezoneH + safezoneY;
			w = 0.0228646 * safezoneW;
			h = 0.0150741 * safezoneH;
		};

		/* Bottom Right */

		class RscInteractionText_6906: RscInteractionText
		{
			idc = 6906;
			text = ""; 
			x = 0.520625 * safezoneW + safezoneX;
			y = 0.566 * safezoneH + safezoneY;
			w = 0.061875 * safezoneW;
			h = 0.044 * safezoneH;
		};

		class RscBottomRight: RscButtonInvisible
		{
			idc = 7105;
			action = "[5] spawn A3FL_Animations_animButtonPressed;";
			onMouseEnter = "ctrlSetText[1204, ""\A3PL_Common\InteractionData\BottomRightActive.paa""];";
			onMouseExit = "ctrlSetText[1204, ""\A3PL_Common\InteractionData\BottomRight.paa""];";
		};

		class RscButtonInvisible_1633: RscBottomRight
		{
			idc = 1633;
			x = 0.532291 * safezoneW + safezoneX;
			y = 0.618519 * safezoneH + safezoneY;
			w = 0.0409895 * safezoneW;
			h = 0.0244444 * safezoneH;
		};

		class RscButtonInvisible_1634: RscBottomRight
		{
			idc = 1634;
			x = 0.536094 * safezoneW + safezoneX;
			y = 0.637444 * safezoneH + safezoneY;
			w = 0.023802 * safezoneW;
			h = 0.03 * safezoneH;
		};

		class RscButtonInvisible_1635: RscBottomRight
		{
			idc = 1635;
			x = 0.532292 * safezoneW + safezoneX;
			y = 0.547223 * safezoneH + safezoneY;
			w = 0.0352604 * safezoneW;
			h = 0.0281481 * safezoneH;
		};

		class RscButtonInvisible_1632: RscBottomRight
		{
			idc = 1632;
			x = 0.52448 * safezoneW + safezoneX;
			y = 0.567593 * safezoneH + safezoneY;
			w = 0.0639062 * safezoneW;
			h = 0.0512963 * safezoneH;
		};

		/* Bottom */

		class RscInteractionText_6907: RscInteractionText
		{
			idc = 6907;
			text = ""; 
			x = 0.463906 * safezoneW + safezoneX;
			y = 0.621 * safezoneH + safezoneY;
			w = 0.061875 * safezoneW;
			h = 0.044 * safezoneH;
		};

		class RscBottom: RscButtonInvisible
		{
			idc = 7106;
			action = "[6] spawn A3FL_Animations_animButtonPressed;";
			onMouseEnter = "ctrlSetText[1205, ""\A3PL_Common\InteractionData\BottomActive.paa""];";
			onMouseExit = "ctrlSetText[1205, ""\A3PL_Common\InteractionData\Bottom.paa""];";
		};

		class RscButtonInvisible_1623: RscBottom
		{
			idc = 1623;
			x = 0.479792 * safezoneW + safezoneX;
			y = 0.588296 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.099 * safezoneH;
		};

		class RscButtonInvisible_1624: RscBottom
		{
			idc = 1624;
			x = 0.469062 * safezoneW + safezoneX;
			y = 0.599 * safezoneH + safezoneY;
			w = 0.0124479 * safezoneW;
			h = 0.0871852 * safezoneH;
		};

		class RscButtonInvisible_1625: RscBottom
		{
			idc = 1625;
			x = 0.510312 * safezoneW + safezoneX;
			y = 0.599 * safezoneH + safezoneY;
			w = 0.0095312 * safezoneW;
			h = 0.0828147 * safezoneH;
		};

		class RscButtonInvisible_1626: RscBottom
		{
			idc = 1626;
			x = 0.518542 * safezoneW + safezoneX;
			y = 0.634778 * safezoneH + safezoneY;
			w = 0.0116145 * safezoneW;
			h = 0.0467036 * safezoneH;
		};
		
		class RscButtonInvisible_1627: RscBottom
		{
			idc = 1627;
			x = 0.459896 * safezoneW + safezoneX;
			y = 0.639815 * safezoneH + safezoneY;
			w = 0.0116145 * safezoneW;
			h = 0.0467036 * safezoneH;
		};

		/* Bottom Left */
		
		class RscInteractionText_6909: RscInteractionText
		{
			idc = 6909;
			text = ""; 
			x = 0.402031 * safezoneW + safezoneX;
			y = 0.566 * safezoneH + safezoneY;
			w = 0.061875 * safezoneW;
			h = 0.044 * safezoneH;
		};

		class RscBottomLeft: RscButtonInvisible
		{
			idc = 7107;
			action = "[] call A3FL_Animations_loadMoreOptions;";
			onMouseEnter = "ctrlSetText[1206, ""\A3PL_Common\InteractionData\BottomLeftActive.paa""];";
			onMouseExit = "ctrlSetText[1206, ""\A3PL_Common\InteractionData\BottomLeft.paa""];";
		};

		class RscButtonInvisible_1628: RscBottomLeft
		{
			idc = 1628;
			x = 0.396875 * safezoneW + safezoneX;
			y = 0.566 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.055 * safezoneH;
		};

		class RscButtonInvisible_1629: RscBottomLeft
		{
			idc = 1629;
			x = 0.41151 * safezoneW + safezoneX;
			y = 0.621 * safezoneH + safezoneY;
			w = 0.0472395 * safezoneW;
			h = 0.0151852 * safezoneH;
		};

		class RscButtonInvisible_1630: RscBottomLeft
		{
			idc = 1630;
			x = 0.426041 * safezoneW + safezoneX;
			y = 0.636111 * safezoneH + safezoneY;
			w = 0.0305728 * safezoneW;
			h = 0.017963 * safezoneH;
		};

		class RscButtonInvisible_1631: RscBottomLeft
		{
			idc = 1631;
			x = 0.420312 * safezoneW + safezoneX;
			y = 0.548148 * safezoneH + safezoneY;
			w = 0.0336979 * safezoneW;
			h = 0.0188889 * safezoneH;
		};

		/* Middle */
		class MiddleButton: RscButtonInvisible
		{
			action = "closeDialog 0;";
		};

		class RscButtonInvisible_1636: MiddleButton
		{
			idc = 1636;
			x = 0.45875 * safezoneW + safezoneX;
			y = 0.445 * safezoneH + safezoneY;
			w = 0.0721875 * safezoneW;
			h = 0.11 * safezoneH;
		};

		class RscButtonInvisible_1637: MiddleButton
		{
			idc = 1637;
			x = 0.461302 * safezoneW + safezoneX;
			y = 0.42763 * safezoneH + safezoneY;
			w = 0.0634375 * safezoneW;
			h = 0.0173704 * safezoneH;
		};

		class RscButtonInvisible_1638: MiddleButton
		{
			idc = 1638;
			x = 0.467552 * safezoneW + safezoneX;
			y = 0.555926 * safezoneH + safezoneY;
			w = 0.0535416 * safezoneW;
			h = 0.0182963 * safezoneH;
		};

		class RscButtonInvisible_1639: MiddleButton
		{
			idc = 1639;
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.467926 * safezoneH + safezoneY;
			w = 0.0108333 * safezoneW;
			h = 0.0655185 * safezoneH;
		};

		class RscButtonInvisible_1640: MiddleButton
		{
			idc = 1640;
			x = 0.530468 * safezoneW + safezoneX;
			y = 0.466074 * safezoneH + safezoneY;
			w = 0.0082291 * safezoneW;
			h = 0.0664444 * safezoneH;
		};
	};
};

class Dialog_AnimationsCat_Menu
{
	idd = 7000;
	movingEnable = false;
	enableSimulation = true;

	class controlsBackground {

		/* Bottom */

		class RscPicture_1205: RscPicture
		{
			idc = 1205;
			text = "\A3PL_Common\InteractionData\Bottom.paa";
			x = 0.386562 * safezoneW + safezoneX;
			y = 0.313 * safezoneH + safezoneY;
			w = 0.216563 * safezoneW;
			h = 0.374 * safezoneH;
			colorBackground[] = {0,0,0,1};
		};

		/* Bottom Left */

		class RscPicture_1206: RscPicture
		{
			idc = 1206;
			text = "\A3PL_Common\InteractionData\BottomLeft.paa";
			x = 0.386562 * safezoneW + safezoneX;
			y = 0.313 * safezoneH + safezoneY;
			w = 0.216563 * safezoneW;
			h = 0.374 * safezoneH;
		};

		/* Center Left */
		
		class RscPicture_1208: RscPicture
		{
			idc = 1208;
			text = "\A3PL_Common\InteractionData\CenterLeft.paa";
			x = 0.386562 * safezoneW + safezoneX;
			y = 0.313 * safezoneH + safezoneY;
			w = 0.216563 * safezoneW;
			h = 0.374 * safezoneH;
		};

		/* Top Left */

		class RscPicture_1207: RscPicture
		{
			idc = 1207;
			text = "\A3PL_Common\InteractionData\TopLeft.paa";
			x = 0.386562 * safezoneW + safezoneX;
			y = 0.313 * safezoneH + safezoneY;
			w = 0.216563 * safezoneW;
			h = 0.374 * safezoneH;
		};
		/* Top */

		class RscPicture_1200: RscPicture
		{
			idc = 1200;
			text = "\A3PL_Common\InteractionData\Top.paa";
			x = 0.386562 * safezoneW + safezoneX;
			y = 0.313 * safezoneH + safezoneY;
			w = 0.216563 * safezoneW;
			h = 0.374 * safezoneH;
		};

		/* Top Right */

		class RscPicture_1201: RscPicture
		{
			idc = 1201;
			text = "\A3PL_Common\InteractionData\TopRight.paa";
			x = 0.386562 * safezoneW + safezoneX;
			y = 0.313 * safezoneH + safezoneY;
			w = 0.216563 * safezoneW;
			h = 0.374 * safezoneH;
		};

		/* Center Right */

		class RscPicture_1203: RscPicture
		{
			idc = 1203;
			text = "\A3PL_Common\InteractionData\CenterRight.paa";
			x = 0.386562 * safezoneW + safezoneX;
			y = 0.313 * safezoneH + safezoneY;
			w = 0.216563 * safezoneW;
			h = 0.374 * safezoneH;
		};
		
		/* Bottom Right */

		class RscPicture_1204: RscPicture
		{
			idc = 1204;
			text = "\A3PL_Common\InteractionData\BottomRight.paa";
			x = 0.386562 * safezoneW + safezoneX;
			y = 0.313 * safezoneH + safezoneY;
			w = 0.216563 * safezoneW;
			h = 0.374 * safezoneH;
		};
		
		/* Middle */

		class RscPicture_1202: RscPicture
		{
			idc = 1202;
			text = "\A3PL_Common\InteractionData\Middle.paa";
			x = 0.386562 * safezoneW + safezoneX;
			y = 0.313 * safezoneH + safezoneY;
			w = 0.216563 * safezoneW;
			h = 0.374 * safezoneH;
			colorBackground[] = {0,0,0,0.75};
		};
	};

	class controls {

		/* Center Left */

		class RscInteractionText_7001: RscInteractionText
		{
			idc = 7001;
			text = ""; 
			x = 0.386562 * safezoneW + safezoneX;
			y = 0.478 * safezoneH + safezoneY;
			w = 0.0567187 * safezoneW;
			h = 0.044 * safezoneH;
		};

		class RscCenterLeft: RscButtonInvisible
		{
			idc = 7200;
			action = "[""STR_A3PL_Animations_Dance""] call A3FL_Animations_loadAnimations;";
			onMouseEnter = "ctrlSetText[1208, ""\A3PL_Common\InteractionData\CenterLeftActive.paa""];";
			onMouseExit = "ctrlSetText[1208, ""\A3PL_Common\InteractionData\CenterLeft.paa""];";
		};

		class RscButtonInvisible_1613: RscCenterLeft
		{
			idc = 1613;
			x = 0.386562 * safezoneW + safezoneX;
			y = 0.467 * safezoneH + safezoneY;
			w = 0.0567187 * safezoneW;
			h = 0.066 * safezoneH;
		};

		class RscButtonInvisible_1614: RscCenterLeft
		{
			idc = 1614;
			x = 0.389271 * safezoneW + safezoneX;
			y = 0.533 * safezoneH + safezoneY;
			w = 0.0436979 * safezoneW;
			h = 0.0132223 * safezoneH;
		};

		class RscButtonInvisible_1615: RscCenterLeft
		{
			idc = 1615;
			x = 0.387135 * safezoneW + safezoneX;
			y = 0.544 * safezoneH + safezoneY;
			w = 0.027552 * safezoneW;
			h = 0.0141484 * safezoneH;
		};

		class RscButtonInvisible_1616: RscCenterLeft
		{
			idc = 1616;
			x = 0.385938 * safezoneW + safezoneX;
			y = 0.45463 * safezoneH + safezoneY;
			w = 0.0436979 * safezoneW;
			h = 0.0132223 * safezoneH;
		};

		class RscButtonInvisible_1617: RscCenterLeft
		{
			idc = 1617;
			x = 0.386979 * safezoneW + safezoneX;
			y = 0.441667 * safezoneH + safezoneY;
			w = 0.027552 * safezoneW;
			h = 0.0141484 * safezoneH;
		};

		/* Top Left */

		class RscInteractionText_1002: RscInteractionText
		{
			idc = 7002;
			text = ""; 
			x = 0.402547 * safezoneW + safezoneX;
			y = 0.39286 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.044 * safezoneH;
		};

		class RscTopLeft: RscButtonInvisible
		{
			idc = 7201;
			action = "[""STR_A3PL_Animations_Exercise""] call A3FL_Animations_loadAnimations;";
			onMouseEnter = "ctrlSetText[1207, ""\A3PL_Common\InteractionData\TopLeftActive.paa""];";
			onMouseExit = "ctrlSetText[1207, ""\A3PL_Common\InteractionData\TopLeft.paa""];";
		};

		class RscButtonInvisible_1609: RscTopLeft
		{
			idc = 1609;
			x = 0.402031 * safezoneW + safezoneX;
			y = 0.379 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.055 * safezoneH;
		};

		class RscButtonInvisible_1610: RscTopLeft
		{
			idc = 1610;
			x = 0.4175 * safezoneW + safezoneX;
			y = 0.357 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.022 * safezoneH;
		};

		class RscButtonInvisible_1611: RscTopLeft
		{
			idc = 1611;
			x = 0.432136 * safezoneW + safezoneX;
			y = 0.336852 * safezoneH + safezoneY;
			w = 0.0225 * safezoneW;
			h = 0.0210741 * safezoneH;
		};

		class RscButtonInvisible_1612: RscTopLeft
		{
			idc = 1612;
			x = 0.424323 * safezoneW + safezoneX;
			y = 0.42763 * safezoneH + safezoneY;
			w = 0.0282292 * safezoneW;
			h = 0.0257037 * safezoneH;
		};

		/* Top */

		class RscInteractionText_7003: RscInteractionText
		{
			idc = 7003;
			text = ""; 
			x = 0.463906 * safezoneW + safezoneX;
			y = 0.335 * safezoneH + safezoneY;
			w = 0.061875 * safezoneW;
			h = 0.033 * safezoneH;
		};

		class RscTop: RscButtonInvisible
		{
			idc = 7202;
			action = "[""STR_A3PL_Animations_Static""] call A3FL_Animations_loadAnimations;";
			onMouseEnter = "ctrlSetText[1200, ""\A3PL_Common\InteractionData\TopActive.paa""];";
			onMouseExit = "ctrlSetText[1200, ""\A3PL_Common\InteractionData\Top.paa""];";
		};

		class RscButtonInvisible_1600: RscTop
		{
			idc = 1600;
			x = 0.474219 * safezoneW + safezoneX;
			y = 0.313 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.099 * safezoneH;
		};

		class RscButtonInvisible_1601: RscTop
		{
			idc = 1601;
			x = 0.464947 * safezoneW + safezoneX;
			y = 0.312889 * safezoneH + safezoneY;
			w = 0.0103125 * safezoneW;
			h = 0.066 * safezoneH;
		};

		class RscButtonInvisible_1602: RscTop
		{
			idc = 1602;
			x = 0.458854 * safezoneW + safezoneX;
			y = 0.325925 * safezoneH + safezoneY;
			w = 0.00770836 * safezoneW;
			h = 0.0317408 * safezoneH;
		};

		class RscButtonInvisible_1603: RscTop
		{
			idc = 1603;
			x = 0.514584 * safezoneW + safezoneX;
			y = 0.314814 * safezoneH + safezoneY;
			w = 0.0103125 * safezoneW;
			h = 0.066 * safezoneH;
		};

		class RscButtonInvisible_1604: RscTop
		{
			idc = 1604;
			x = 0.523437 * safezoneW + safezoneX;
			y = 0.318518 * safezoneH + safezoneY;
			w = 0.00770836 * safezoneW;
			h = 0.0317408 * safezoneH;
		};

		/* Top Right */

		class RscInteractionText_7004: RscInteractionText
		{
			idc = 7004;
			text = ""; 
			x = 0.520109 * safezoneW + safezoneX;
			y = 0.39286 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.033 * safezoneH;
		};

		class RscTopRight: RscButtonInvisible
		{
			idc = 7203;
			action = "[""STR_A3PL_Animations_Gesture""] call A3FL_Animations_loadAnimations;";
			onMouseEnter = "ctrlSetText[1201, ""\A3PL_Common\InteractionData\TopRightActive.paa""];";
			onMouseExit = "ctrlSetText[1201, ""\A3PL_Common\InteractionData\TopRight.paa""];";
		};

		class RscButtonInvisible_1605: RscTopRight
		{
			idc = 1605;
			x = 0.520625 * safezoneW + safezoneX;
			y = 0.379 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.055 * safezoneH;
		};

		class RscButtonInvisible_1606: RscTopRight
		{
			idc = 1606;
			x = 0.530937 * safezoneW + safezoneX;
			y = 0.357 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.022 * safezoneH;
		};

		class RscButtonInvisible_1607: RscTopRight
		{
			idc = 1607;
			x = 0.536094 * safezoneW + safezoneX;
			y = 0.335 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.022 * safezoneH;
		};

		class RscButtonInvisible_1608: RscTopRight
		{
			idc = 1608;
			x = 0.536145 * safezoneW + safezoneX;
			y = 0.432148 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.022 * safezoneH;
		};

		/* Center Right */

		class RscInteractionText_7005: RscInteractionText
		{
			idc = 7005;
			text = ""; 
			x = 0.546406 * safezoneW + safezoneX;
			y = 0.478 * safezoneH + safezoneY;
			w = 0.0567187 * safezoneW;
			h = 0.044 * safezoneH;
		};

		class RscCenterRight: RscButtonInvisible
		{
			idc = 7204;
			action = "[""STR_A3PL_Animations_Actions""] call A3FL_Animations_loadAnimations;";
			onMouseEnter = "ctrlSetText[1203, ""\A3PL_Common\InteractionData\CenterRightActive.paa""];";
			onMouseExit = "ctrlSetText[1203, ""\A3PL_Common\InteractionData\CenterRight.paa""];";
		};

		class RscButtonInvisible_1618: RscCenterRight
		{
			idc = 1618;
			x = 0.546406 * safezoneW + safezoneX;
			y = 0.467 * safezoneH + safezoneY;
			w = 0.0567187 * safezoneW;
			h = 0.066 * safezoneH;
		};

		class RscButtonInvisible_1619: RscCenterRight
		{
			idc = 1619;
			x = 0.556719 * safezoneW + safezoneX;
			y = 0.533 * safezoneH + safezoneY;
			w = 0.0442187 * safezoneW;
			h = 0.0150741 * safezoneH;
		};

		class RscButtonInvisible_1620: RscCenterRight
		{
			idc = 1620;
			x = 0.576562 * safezoneW + safezoneX;
			y = 0.54537 * safezoneH + safezoneY;
			w = 0.0228646 * safezoneW;
			h = 0.0150741 * safezoneH;
		};

		class RscButtonInvisible_1621: RscCenterRight
		{
			idc = 1621;
			x = 0.557292 * safezoneW + safezoneX;
			y = 0.453704 * safezoneH + safezoneY;
			w = 0.0442187 * safezoneW;
			h = 0.0150741 * safezoneH;
		};

		class RscButtonInvisible_1622: RscCenterRight
		{
			idc = 1622;
			x = 0.573959 * safezoneW + safezoneX;
			y = 0.439815 * safezoneH + safezoneY;
			w = 0.0228646 * safezoneW;
			h = 0.0150741 * safezoneH;
		};

		/* Bottom Right */

		class RscInteractionText_7006: RscInteractionText
		{
			idc = 7006;
			text = ""; 
			x = 0.520625 * safezoneW + safezoneX;
			y = 0.566 * safezoneH + safezoneY;
			w = 0.061875 * safezoneW;
			h = 0.044 * safezoneH;
		};

		class RscBottomRight: RscButtonInvisible
		{
			idc = 7205;
			action = "";
			onMouseEnter = "ctrlSetText[1204, ""\A3PL_Common\InteractionData\BottomRightActive.paa""];";
			onMouseExit = "ctrlSetText[1204, ""\A3PL_Common\InteractionData\BottomRight.paa""];";
		};

		class RscButtonInvisible_1633: RscBottomRight
		{
			idc = 1633;
			x = 0.532291 * safezoneW + safezoneX;
			y = 0.618519 * safezoneH + safezoneY;
			w = 0.0409895 * safezoneW;
			h = 0.0244444 * safezoneH;
		};

		class RscButtonInvisible_1634: RscBottomRight
		{
			idc = 1634;
			x = 0.536094 * safezoneW + safezoneX;
			y = 0.637444 * safezoneH + safezoneY;
			w = 0.023802 * safezoneW;
			h = 0.03 * safezoneH;
		};

		class RscButtonInvisible_1635: RscBottomRight
		{
			idc = 1635;
			x = 0.532292 * safezoneW + safezoneX;
			y = 0.547223 * safezoneH + safezoneY;
			w = 0.0352604 * safezoneW;
			h = 0.0281481 * safezoneH;
		};

		class RscButtonInvisible_1632: RscBottomRight
		{
			idc = 1632;
			x = 0.52448 * safezoneW + safezoneX;
			y = 0.567593 * safezoneH + safezoneY;
			w = 0.0639062 * safezoneW;
			h = 0.0512963 * safezoneH;
		};

		/* Bottom */

		class RscInteractionText_7007: RscInteractionText
		{
			idc = 7007;
			text = "STR_UI_AnimationWheel_Stop"; 
			x = 0.463906 * safezoneW + safezoneX;
			y = 0.621 * safezoneH + safezoneY;
			w = 0.061875 * safezoneW;
			h = 0.044 * safezoneH;
		};

		class RscBottom: RscButtonInvisible
		{
			idc = 7206;
			action = "[] call A3FL_Animations_Stop;";
			onMouseEnter = "ctrlSetText[1205, ""\A3PL_Common\InteractionData\BottomActive.paa""];";
			onMouseExit = "ctrlSetText[1205, ""\A3PL_Common\InteractionData\Bottom.paa""];";
		};

		class RscButtonInvisible_1623: RscBottom
		{
			idc = 1623;
			x = 0.479792 * safezoneW + safezoneX;
			y = 0.588296 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.099 * safezoneH;
		};

		class RscButtonInvisible_1624: RscBottom
		{
			idc = 1624;
			x = 0.469062 * safezoneW + safezoneX;
			y = 0.599 * safezoneH + safezoneY;
			w = 0.0124479 * safezoneW;
			h = 0.0871852 * safezoneH;
		};

		class RscButtonInvisible_1625: RscBottom
		{
			idc = 1625;
			x = 0.510312 * safezoneW + safezoneX;
			y = 0.599 * safezoneH + safezoneY;
			w = 0.0095312 * safezoneW;
			h = 0.0828147 * safezoneH;
		};

		class RscButtonInvisible_1626: RscBottom
		{
			idc = 1626;
			x = 0.518542 * safezoneW + safezoneX;
			y = 0.634778 * safezoneH + safezoneY;
			w = 0.0116145 * safezoneW;
			h = 0.0467036 * safezoneH;
		};
		
		class RscButtonInvisible_1627: RscBottom
		{
			idc = 1627;
			x = 0.459896 * safezoneW + safezoneX;
			y = 0.639815 * safezoneH + safezoneY;
			w = 0.0116145 * safezoneW;
			h = 0.0467036 * safezoneH;
		};

		/* Bottom Left */
		
		class RscInteractionText_7009: RscInteractionText
		{
			idc = 7009;
			text = ""; 
			x = 0.402031 * safezoneW + safezoneX;
			y = 0.566 * safezoneH + safezoneY;
			w = 0.061875 * safezoneW;
			h = 0.044 * safezoneH;
		};

		class RscBottomLeft: RscButtonInvisible
		{
			idc = 7207;
			action = "";
			onMouseEnter = "ctrlSetText[1206, ""\A3PL_Common\InteractionData\BottomLeftActive.paa""];";
			onMouseExit = "ctrlSetText[1206, ""\A3PL_Common\InteractionData\BottomLeft.paa""];";
		};

		class RscButtonInvisible_1628: RscBottomLeft
		{
			idc = 1628;
			x = 0.396875 * safezoneW + safezoneX;
			y = 0.566 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.055 * safezoneH;
		};

		class RscButtonInvisible_1629: RscBottomLeft
		{
			idc = 1629;
			x = 0.41151 * safezoneW + safezoneX;
			y = 0.621 * safezoneH + safezoneY;
			w = 0.0472395 * safezoneW;
			h = 0.0151852 * safezoneH;
		};

		class RscButtonInvisible_1630: RscBottomLeft
		{
			idc = 1630;
			x = 0.426041 * safezoneW + safezoneX;
			y = 0.636111 * safezoneH + safezoneY;
			w = 0.0305728 * safezoneW;
			h = 0.017963 * safezoneH;
		};

		class RscButtonInvisible_1631: RscBottomLeft
		{
			idc = 1631;
			x = 0.420312 * safezoneW + safezoneX;
			y = 0.548148 * safezoneH + safezoneY;
			w = 0.0336979 * safezoneW;
			h = 0.0188889 * safezoneH;
		};

		/* Middle */
		class MiddleButton: RscButtonInvisible
		{
			action = "closeDialog 0;";
		};

		class RscButtonInvisible_1636: MiddleButton
		{
			idc = 1636;
			x = 0.45875 * safezoneW + safezoneX;
			y = 0.445 * safezoneH + safezoneY;
			w = 0.0721875 * safezoneW;
			h = 0.11 * safezoneH;
		};

		class RscButtonInvisible_1637: MiddleButton
		{
			idc = 1637;
			x = 0.461302 * safezoneW + safezoneX;
			y = 0.42763 * safezoneH + safezoneY;
			w = 0.0634375 * safezoneW;
			h = 0.0173704 * safezoneH;
		};

		class RscButtonInvisible_1638: MiddleButton
		{
			idc = 1638;
			x = 0.467552 * safezoneW + safezoneX;
			y = 0.555926 * safezoneH + safezoneY;
			w = 0.0535416 * safezoneW;
			h = 0.0182963 * safezoneH;
		};

		class RscButtonInvisible_1639: MiddleButton
		{
			idc = 1639;
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.467926 * safezoneH + safezoneY;
			w = 0.0108333 * safezoneW;
			h = 0.0655185 * safezoneH;
		};

		class RscButtonInvisible_1640: MiddleButton
		{
			idc = 1640;
			x = 0.530468 * safezoneW + safezoneX;
			y = 0.466074 * safezoneH + safezoneY;
			w = 0.0082291 * safezoneW;
			h = 0.0664444 * safezoneH;
		};
	};
};