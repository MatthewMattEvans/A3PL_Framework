class Dialog_CompanyBillList {
	idd = 139;
	name= "Dialog_CompanyBillList";
	movingEnable = false;
	enableSimulation = true;
	class controls
	{
		class RscPicture_1200: RscPicture
		{
			idc = 1200;
			text = "A3PL_Common\GUI\A3PL_Company_BillList.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class bill_list: RscListbox
		{
			idc = 1500;
			x = 0.242187 * safezoneW + safezoneX;
			y = 0.31937 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.187 * safezoneH;
		};
		class Company_Name: RscText
		{
			idc = 1000;
			text = ""; //--- ToDo: Localize;
			x = 0.377604 * safezoneW + safezoneX;
			y = 0.314815 * safezoneH + safezoneY;
			w = 0.180469 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class Bill_Amount: RscText
		{
			idc = 1001;
			text = ""; //--- ToDo: Localize;
			x = 0.570833 * safezoneW + safezoneX;
			y = 0.315741 * safezoneH + safezoneY;
			w = 0.118594 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class Desc_Bill: RscStructuredText
		{
			idc = 1100;
			x = 0.377083 * safezoneW + safezoneX;
			y = 0.360185 * safezoneH + safezoneY;
			w = 0.314531 * safezoneW;
			h = 0.077 * safezoneH;
		};
		class PayCitizen: RscButtonEmpty
		{
			idc = 1600;
			x = 0.375 * safezoneW + safezoneX;
			y = 0.482407 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class Pic_Pay_Faction: RscPicture
		{
			idc = 1201;
			text = "A3PL_Common\GUI\A3PL_Company_BillButtonFaction.paa";
			x = -0.0846877 * safezoneW + safezoneX;
			y = 0.0144076 * safezoneH + safezoneY;
			w = 1.02609 * safezoneW;
			h = 0.968 * safezoneH;
		};
		class Pic_Pay_Company: RscPicture
		{
			idc = 1202;
			text = "A3PL_Common\GUI\A3PL_Company_BillButtonCompany.paa";
			x = 0.079687 * safezoneW + safezoneX;
			y = 0.0138887 * safezoneH + safezoneY;
			w = 1.02609 * safezoneW;
			h = 0.968 * safezoneH;
		};
		class Btn_Pay_Faction: RscButtonEmpty
		{
			idc = 1602;
			x = 0.457292 * safezoneW + safezoneX;
			y = 0.480556 * safezoneH + safezoneY;
			w = 0.0670312  * safezoneW;
			h = 0.033 * safezoneH;
		};
		class Btn_Pay_Company: RscButtonEmpty
		{
			idc = 1603;
			x = 0.543751 * safezoneW + safezoneX;
			y = 0.47963 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class close: RscButtonEmpty
		{
			idc = 1601;
			x = 0.625 * safezoneW + safezoneX;
			y = 0.484259 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.033 * safezoneH;
			action = "closeDialog 0;";
		};
	};
};

class Dialog_CompanyBillListInfo {
	idd = 140;
	name= "Dialog_CompanyBillListInfo";
	movingEnable = false;
	enableSimulation = true;
	class controls
	{
		class RscPicture_1200: RscPicture
		{
			idc = 1200;
			text = "A3PL_Common\GUI\A3PL_Company_BillListCompany.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class bill_list: RscListbox
		{
			idc = 1500;
			x = 0.241146 * safezoneW + safezoneX;
			y = 0.319445 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.187 * safezoneH;
		};
		class Player_Name: RscText
		{
			idc = 1000;
			text = ""; //--- ToDo: Localize;
			x = 0.377604 * safezoneW + safezoneX;
			y = 0.315741 * safezoneH + safezoneY;
			w = 0.180469 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class Bill_Amount: RscText
		{
			idc = 1001;
			text = ""; //--- ToDo: Localize;
			x = 0.570312 * safezoneW + safezoneX;
			y = 0.31574 * safezoneH + safezoneY;
			w = 0.118594 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class Desc_Bill: RscStructuredText
		{
			idc = 1100;
			x = 0.377084 * safezoneW + safezoneX;
			y = 0.360185 * safezoneH + safezoneY;
			w = 0.314531 * safezoneW;
			h = 0.077 * safezoneH;
		};
		class close: RscButtonEmpty
		{
			idc = 1601;
			x = 0.625521 * safezoneW + safezoneX;
			y = 0.490741 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.022 * safezoneH;
			action = "closeDialog 0;";
		};
	};
};