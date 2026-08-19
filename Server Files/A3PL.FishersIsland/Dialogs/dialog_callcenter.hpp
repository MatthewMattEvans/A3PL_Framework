class A3PL_CallCenterChoice_Dialog {
	idd = 458764;
	name= "A3PL_CallCenterChoice_Dialog";
	movingEnable = false;
	enableSimulation = true;
	class controlsBackground {
	};
	class controls {
		class bg: RscPicture
		{
			idc = 1200;
			text = "\A3PL_Common\GUI\CallCenterChoice.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class SD: RscButtonEmpty
		{
			idc = 1600;
			x = 0.364063 * safezoneW + safezoneX;
			y = 0.612963 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class FD: RscButtonEmpty
		{
			idc = 1601;
			x = 0.458334 * safezoneW + safezoneX;
			y = 0.612037 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class DOJ: RscButtonEmpty
		{
			idc = 1602;
			x = 0.549999 * safezoneW + safezoneX;
			y = 0.612963 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class rscedit: RscText
		{
			idc = 1400;
			x = 0.298437 * safezoneW + safezoneX;
			y = 0.341666 * safezoneH + safezoneY;
			w = 0.402187 * safezoneW;
			h = 0.242 * safezoneH;
		};
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT END
		////////////////////////////////////////////////////////

	};
};