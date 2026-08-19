class Dialog_Confirmation
{
	idd = 94;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "";
	onUnload = "";
	class controls
	{
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT START (by Winston, v1.063, #Luguko)
		////////////////////////////////////////////////////////
		class BACKGRND: RscPicture
		{
			idc = 1200;
			text = "\A3PL_Common\GUI\Confirmation.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class TEXT: RscStructuredText
		{
			idc = 1100;
			text = "";
			x = 0.296354 * safezoneW + safezoneX;
			y = 0.318519 * safezoneH + safezoneY;
			w = 0.407344 * safezoneW;
			h = 0.121 * safezoneH;
		};
		class YES: RscButtonEmpty
		{
			idc = 1101;
			x = 0.413542 * safezoneW + safezoneX;
			y = 0.45 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class NO: RscButtonEmpty
		{
			idc = 1102;
			x = 0.504687  * safezoneW + safezoneX;
			y = 0.45 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class CLOSE: RscButtonEmpty
		{
			idc = 1103;
			x = 0.6875 * safezoneW + safezoneX;
			y = 0.265629 * safezoneH + safezoneY;
			w = 0.020625 * safezoneW;
			h = 0.044 * safezoneH;
		};
	};
};