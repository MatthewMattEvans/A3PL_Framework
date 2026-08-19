class Dialog_Shop
{
	idd = 20;
	name= "Dialog_Shop";
	movingEnable = false;
	enableSimulation = true;
	class controls
	{
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT START (by Winston, v1.063, #Lyruxu)
		////////////////////////////////////////////////////////
		class BACKGROUND: RscPicture
		{
			idc = 1200;
			text = "\A3PL_Common\GUI\A3PL_Shops.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class Items: RscListbox
		{
			idc = 1500;
			x = 0.00781257 * safezoneW + safezoneX;
			y = 0.197222  * safezoneH + safezoneY;
			w = 0.170156  * safezoneW;
			h = 0.473 * safezoneH;
		};
		class SliderCam: RscSlider
		{
			idc = 1900;
			x = 0.0134376  * safezoneW + safezoneX;
			y = 0.860186 * safezoneH + safezoneY;
			w = 0.159844 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class BUY: RscButtonEmpty
		{
			idc = 1602;
			text = "";
			x = 0.00781286 * safezoneW + safezoneX;
			y = 0.810186 * safezoneH + safezoneY;
			w = 0.061875 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class SELL: RscButtonEmpty
		{
			idc = 1603;
			text = "";
			x = 0.11823 * safezoneW + safezoneX;
			y = 0.810185 * safezoneH + safezoneY;
			w = 0.061875 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class QTY: RscEditInvisible
		{
			idc = 1400;
			text = "1";
			style = "16 + 512";
			x = 0.0739584 * safezoneW + safezoneX;
			y = 0.802778 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class Stock: RscStructuredText
		{
			idc = 1102;
			text = "";
			x = 0.0119792 * safezoneW + safezoneX;
			y = 0.765741 * safezoneH + safezoneY;
			w = 0.0515625 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class BUYPRICE: RscStructuredText
		{
			idc = 1100;
			text = "";
			x = 0.0692708 * safezoneW + safezoneX;
			y = 0.765741 * safezoneH + safezoneY;
			w = 0.0515625 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class SELLPRICE: RscStructuredText
		{
			idc = 1101;
			text = "";
			x = 0.126563 * safezoneW + safezoneX;
			y = 0.765741 * safezoneH + safezoneY;
			w = 0.0515625 * safezoneW;
			h = 0.022 * safezoneH;
		};
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT END
		////////////////////////////////////////////////////////

	};
};