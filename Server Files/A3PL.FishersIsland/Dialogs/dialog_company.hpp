class Dialog_Company_Create
{
	idd = 136;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "";
	onUnload = "";
	class controls
	{
		class MainPic: RscPicture
		{
			idc = -1;
			text = "\A3PL_Common\GUI\A3PL_Company_Create.paa";
			x = 0.0333333 * safezoneW + safezoneX;
			y = 0.112037 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class BTN_Valid: RscButtonEmpty
		{
			idc = 1601;
			x = 0.406249 * safezoneW + safezoneX;
			y = 0.597222 * safezoneH + safezoneY;
			w = 0.0721875 * safezoneW;
			h = 0.033 * safezoneH;
			action = "call A3PL_Company_Create;";
		};
		class BTN_Close: RscButtonEmpty
		{
			idc = 1602;
			x = 0.705729 * safezoneW + safezoneX;
			y = 0.343519 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.055 * safezoneH;
			action = "closeDialog 0;";
		};
		class Edit_Name: RscEditInvisible
		{
			idc = 1400;
			x = 0.409375 * safezoneW + safezoneX;
			y = 0.424074 * safezoneH + safezoneY;
			w = 0.314531 * safezoneW;
			h = 0.033 * safezoneH;
			style = "16 + 512";
		};
		class Edit_Desc: RscEditInvisible
		{
			idc = 1401;
			x = 0.410416 * safezoneW + safezoneX;
			y = 0.471296 * safezoneH + safezoneY;
			w = 0.314531 * safezoneW;
			h = 0.077 * safezoneH;
			style = "16 + 512";
		};
		class SectorOfActivity: RscListBox
		{
			idc = 1402;
			x = 0.275 * safezoneW + safezoneX;
			y = 0.425926 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.198 * safezoneH;
		};
	};
};

class Dialog_Company_History
{
	idd = 138;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "";
	onUnload = "";
	class controls
	{
		class static_bg: RscPicture
		{
			idc = -1;
			text = "\A3PL_Common\GUI\A3PL_Company_History.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class History: RscListbox
		{
			idc = 1500;
			x = 0.239583 * safezoneW + safezoneX;
			y = 0.29537 * safezoneH + safezoneY;
			w = 0.458906 * safezoneW;
			h = 0.539 * safezoneH;
		};
		class BTN_Close: RscButtonEmpty
		{
			idc = 1600;
			action = "closeDialog 0;";
			x = 0.672396 * safezoneW + safezoneX;
			y = 0.230556 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.055 * safezoneH;
		};
	};
};

class Dialog_Company_Manage
{
	idd = 137;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "";
	onUnload = "";
	class controls
	{
		class MainPic: RscPicture
		{
			idc = -1;
			text = "\A3PL_Common\GUI\A3FL_Company_Manage.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class AccountValue: RscStructuredText
		{
			idc = 1100;
			x = 0.743229 * safezoneW + safezoneX;
			y = 0.205556  * safezoneH + safezoneY;
			w = 0.0928125 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class LB_Employees: RscListbox
		{
			idc = 1500;
			x = 0.38802 * safezoneW + safezoneX;
			y = 0.239815 * safezoneH + safezoneY;
			w = 0.149531 * safezoneW;
			h = 0.44 * safezoneH;
		};
		class LB_Transfer: RscListbox
		{
			idc = 5472;
			x = 0.627161 * safezoneW + safezoneX;
			y = 0.239768 * safezoneH + safezoneY;
			w = 0.211406 * safezoneW;
			h = 0.11 * safezoneH;
		};
		class LB_PeopleRanks: RscListbox
		{
			idc = 5473;
			x = 0.164063 * safezoneW + safezoneX;
			y = 0.235185 * safezoneH + safezoneY;
			w = 0.165 * safezoneW;
			h = 0.44 * safezoneH;
		};
		class LB_Ranks: RscListbox
		{
			idc = 5474;
			x = 0.1625 * safezoneW + safezoneX;
			y = 0.728704 * safezoneH + safezoneY;
			w = 0.165 * safezoneW;
			h = 0.198 * safezoneH;
		};
		class LB_Perms: RscListbox
		{
			idc = 5475;
			x = 0.627083 * safezoneW + safezoneX;
			y = 0.470371 * safezoneH + safezoneY;
			w = 0.211406 * safezoneW;
			h = 0.297 * safezoneH;
		};
		class EditTransfer: RscEditInvisible
		{
			idc = 5372;
			x = 0.626563 * safezoneW + safezoneX;
			y = 0.359259 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.022 * safezoneH;
			style = "16 + 512";
		};
		class EditPay: RscEditInvisible
		{
			idc = 1401;
			x = 0.333854 * safezoneW + safezoneX;
			y = 0.803704 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.022 * safezoneH;
			style = "16 + 512";
		};
		class EditDesc: RscEditInvisible
		{
			idc = 1402;
			x = 0.671354 * safezoneW + safezoneX;
			y = 0.856481 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.022 * safezoneH;
			style = "16 + 512";
		};
		class BTN_Fire: RscButtonEmpty
		{
			idc = 1700;
			x = 0.333855 * safezoneW + safezoneX;
			y = 0.472222 * safezoneH + safezoneY;
			w = 0.0515625 * safezoneW;
			h = 0.022 * safezoneH;
			action = "call A3PL_Company_Fire;";
		};
		class BTN_PayEdit: RscButtonEmpty
		{
			idc = 1701;
			x = 0.40625 * safezoneW + safezoneX;
			y = 0.826852 * safezoneH + safezoneY;
			w = 0.0515625 * safezoneW;
			h = 0.022 * safezoneH;
			action = "call A3PL_Company_SetPay;";
		};
		class BTN_DescEdit: RscButtonEmpty
		{
			idc = 1702;
			x = 0.742708 * safezoneW + safezoneX;
			y = 0.878704 * safezoneH + safezoneY;
			w = 0.0515625 * safezoneW;
			h = 0.022 * safezoneH;
			action = "call A3PL_Company_DescEdit;";
		};
		class BTN_Close: RscButtonEmpty
		{
			idc = 1703;
			x = 0.819792 * safezoneW + safezoneX;
			y = 0.125 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.055 * safezoneH;
			action = "closeDialog 0;";
		};
		class BTN_Transfer: RscButtonEmpty
		{
			idc = 1704;
			x = 0.766145 * safezoneW + safezoneX;
			y = 0.371296 * safezoneH + safezoneY;
			w = 0.0515625 * safezoneW;
			h = 0.022 * safezoneH;
			action = "call A3PL_Company_Transfer;";
		};
		class BTN_SetRank: RscButtonEmpty
		{
			idc = 1707;
			x = 0.333333 * safezoneW + safezoneX;
			y = 0.412963 * safezoneH + safezoneY;
			w = 0.0515625 * safezoneW;
			h = 0.022 * safezoneH;
			action = "call A3FL_Company_SetRank;";
		};
		class EditRank: RscEditInvisible
		{
			idc = 1708;
			x = 0.334375 * safezoneW + safezoneX;
			y = 0.726852 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.022 * safezoneH;
			style = "16 + 512";
		};
		class BTN_DeleteRank: RscButtonEmpty
		{
			idc = 1709;
			x = 0.366485 * safezoneW + safezoneX;
			y = 0.881074 * safezoneH + safezoneY;
			w = 0.061875 * safezoneW;
			h = 0.022 * safezoneH;
			action = "call A3FL_Company_DeleteRank;";
		};
		class BTN_RankEdit: RscButtonEmpty
		{
			idc = 1710;
			x = 0.405729 * safezoneW + safezoneX;
			y = 0.750926 * safezoneH + safezoneY;
			w = 0.0515625 * safezoneW;
			h = 0.022 * safezoneH;
			action = "call A3FL_Company_AddRank;";
		};
		class BTN_SetPerm: RscButtonEmpty
		{
			idc = 1711;
			x = 0.677604 * safezoneW + safezoneX;
			y = 0.778703 * safezoneH + safezoneY;
			w = 0.0515625 * safezoneW;
			h = 0.022 * safezoneH;
			action = "call A3FL_Company_SetPerm;";
		};
		class BTN_UnsetPerm: RscButtonEmpty
		{
			idc = 1712;
			x = 0.735416 * safezoneW + safezoneX;
			y = 0.778704 * safezoneH + safezoneY;
			w = 0.0515625 * safezoneW;
			h = 0.022 * safezoneH;
			action = "call A3FL_Company_UnsetPerm;";
		};
	};
};

class Dialog_CompanyShop_Buy
{
	idd = 130;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "";
	onUnload = "A3PL_Company_BuyObject = nil;";
	class controls
	{
		class MainPic: RscPicture
		{
			idc = -1;
			text = "A3PL_Common\GUI\A3FL_CompanyShop_Buy.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class ButtonBuy: RscButtonEmpty
		{
			idc = -1;
			x = 0.416146 * safezoneW + safezoneX;
			y = 0.699074 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.033 * safezoneH;
			action = "call A3PL_Company_BuyShop;";
		};
		class ButtonClose: RscButtonEmpty
		{
			idc = -1;
			x = 0.50625 * safezoneW + safezoneX;
			y = 0.700926 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.033 * safezoneH;
			action = "closeDialog 0;";
		};
		class DisplayPrice: RscStructuredText
		{
			idc = 1100;
			x = 0.427604 * safezoneW + safezoneX;
			y = 0.518519 * safezoneH + safezoneY;
			w = 0.149531 * safezoneW;
			h = 0.044 * safezoneH;
		};
	};
};

class Dialog_CompanyShop_Sell
{
	idd = 130;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "";
	onUnload = "A3PL_Company_BuyObject = nil;";
	class controls
	{
		class MainPic: RscPicture
		{
			idc = -1;
			text = "A3PL_Common\GUI\A3FL_CompanyShop_Sell.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class ButtonBuy: RscButtonEmpty
		{
			idc = -1;
			x = 0.416146 * safezoneW + safezoneX;
			y = 0.699074 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.033 * safezoneH;
			action = "call A3PL_Company_SellShop;";
		};
		class ButtonClose: RscButtonEmpty
		{
			idc = -1;
			x = 0.50625 * safezoneW + safezoneX;
			y = 0.700926 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.033 * safezoneH;
			action = "closeDialog 0;";
		};
		class DisplayPrice: RscStructuredText
		{
			idc = 1100;
			x = 0.427604 * safezoneW + safezoneX;
			y = 0.518519 * safezoneH + safezoneY;
			w = 0.149531 * safezoneW;
			h = 0.044 * safezoneH;
		};
	};
};

class Dialog_CompanyShop_Management
{
	idd = 130;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "";
	onUnload = "A3PL_Company_Building setVariable['inUse',false,true];A3PL_Company_Building = nil;";
	class controls
	{
		class MainPic: RscPicture
		{
			idc = -1;
			text = "A3PL_Common\GUI\A3FL_CompanyShop_Management.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};

		// Top
		class PlayerInventory: RscListBox
		{
			idc = 1301;

			x = 0.260417 * safezoneW + safezoneX;
			y = 0.157407 * safezoneH + safezoneY;
			w = 0.495 * safezoneW;
			h = 0.176 * safezoneH;
		};

		// Left
		class ButtonPutToBuying: RscButtonEmpty
		{
			idc = -1;
			action = "[1] spawn A3PL_CompanyShop_Man_Put;";

			x = 0.269948 * safezoneW + safezoneX;
			y = 0.343407 * safezoneH + safezoneY;
			w = 0.0721875 * safezoneW;
			h = 0.033 * safezoneH;
			colorText[] = {0,0,0,0};
			colorBackground[] = {0,0,0,0};
		};
		class ButtonWithdrawFromBuying: RscButtonEmpty
		{
			idc = -1;
			action = "[1] spawn A3PL_CompanyShop_Man_Remove;";

			x = 0.344792 * safezoneW + safezoneX;
			y = 0.343518 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.033 * safezoneH;
			colorText[] = {0,0,0,0};
			colorBackground[] = {0,0,0,0};
		};
		class EditTakeBuying: RscEditInvisible
		{
			idc = 1302;
			style = "16 + 512";

			text = "1";
			x = 0.263542 * safezoneW + safezoneX;
			y = 0.386111 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class ButtonTakeBuying: RscButtonEmpty
		{
			idc = -1;
			action = "[1] spawn A3PL_CompanyShop_Man_Withdraw;";

			x = 0.347396 * safezoneW + safezoneX;
			y = 0.388889 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class EditLimit: RscEditInvisible
		{
			idc = 1303;
			style = "16 + 512";

			text = "1";
			x = 0.264063  * safezoneW + safezoneX;
			y = 0.433333 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class ButtonLimit: RscButtonEmpty
		{
			idc = -1;
			action = "[0] spawn A3PL_CompanyShop_Man_SetLimit;";

			x = 0.346354 * safezoneW + safezoneX;
			y = 0.434259 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.033 * safezoneH;
			colorText[] = {0,0,0,0};
			colorBackground[] = {0,0,0,0};
		};
		class ShopStockBuying: RscListBox
		{
			idc = 1304;

			x = 0.263021 * safezoneW + safezoneX;
			y = 0.487037 * safezoneH + safezoneY;
			w = 0.149531 * safezoneW;
			h = 0.44 * safezoneH;
		};

		// Center
		class History: RscListBox
		{
			idc = 1305;

			x = 0.438021 * safezoneW + safezoneX;
			y = 0.386111 * safezoneH + safezoneY;
			w = 0.134062 * safezoneW;
			h = 0.495 * safezoneH;
			sizeEx = 0.65 * GUI_GRID_H;
		};
		class EditPrice: RscEditInvisible
		{
			idc = 1306;
			style = "16 + 512";

			text = "1"; //--- ToDo: Localize;
			x = 0.440105 * safezoneW + safezoneX;
			y = 0.899074 * safezoneH + safezoneY;
			w = 0.0773437  * safezoneW;
			h = 0.022 * safezoneH;
		};
		class ButtonPrice: RscButtonEmpty
		{
			idc = -1;
			action = "[] spawn A3PL_CompanyShop_UpdatePrice;";

			x = 0.522916 * safezoneW + safezoneX;
			y = 0.899074 * safezoneH + safezoneY;
			w = 0.0567187  * safezoneW;
			h = 0.033 * safezoneH;
			colorText[] = {0,0,0,0};
			colorBackground[] = {0,0,0,0};
		};

		// Right
		class ButtonPutToSelling: RscButtonEmpty
		{
			idc = -1;
			action = "[0] spawn A3PL_CompanyShop_Man_Put;";

			x = 0.607292 * safezoneW + safezoneX;
			y = 0.339815  * safezoneH + safezoneY;
			w = 0.0721875 * safezoneW;
			h = 0.033 * safezoneH;
			colorText[] = {0,0,0,0};
			colorBackground[] = {0,0,0,0};
		};
		class ButtonWithdrawFromSelling: RscButtonEmpty
		{
			idc = -1;
			action = "[0] spawn A3PL_CompanyShop_Man_Remove;";

			x = 0.683333 * safezoneW + safezoneX;
			y = 0.343518 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.033 * safezoneH;
			colorText[] = {0,0,0,0};
			colorBackground[] = {0,0,0,0};
		};
		class EditWithdrawSelling: RscEditInvisible
		{
			idc = 1307;
			style = "16 + 512";

			text = "1"; //--- ToDo: Localize;
			x = 0.602605 * safezoneW + safezoneX;
			y = 0.385185 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class ButtonWithdrawSelling: RscButtonEmpty
		{
			idc = -1;
			action = "[0] spawn A3PL_CompanyShop_Man_Withdraw;";

			x = 0.684895 * safezoneW + safezoneX;
			y = 0.387963 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.033 * safezoneH;
			colorText[] = {0,0,0,0};
			colorBackground[] = {0,0,0,0};
		};
		class EditDepositSelling: RscEditInvisible
		{
			idc = 1308;
			style = "16 + 512";

			text = "1";
			x = 0.602084 * safezoneW + safezoneX;
			y = 0.433333 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class ButtonDepositSelling: RscButtonEmpty
		{
			idc = -1;
			action = "[] spawn A3PL_CompanyShop_Man_Deposit;";

			x = 0.686458 * safezoneW + safezoneX;
			y = 0.433333 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.033 * safezoneH;
			colorText[] = {0,0,0,0};
			colorBackground[] = {0,0,0,0};
		};
		class ShopStockSelling: RscListBox
		{
			idc = 1309;

			x = 0.601563 * safezoneW + safezoneX;
			y = 0.489815 * safezoneH + safezoneY;
			w = 0.149531 * safezoneW;
			h = 0.44 * safezoneH;
		};
	};
};

class Dialog_CompanyShop_Customer
{
	idd = 130;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "";
	onUnload = "A3PL_Company_Building setVariable['inUse',false,true];A3PL_Company_Building = nil;";
	class controls
	{
		class MainPic: RscPicture
		{
			idc = -1;
			text = "A3PL_Common\GUI\A3FL_CompanyShop_Customer.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};

		// Top Left
		class TextCompany: RscStructuredText
		{
			idc = 1301;

			x = 0.00572922  * safezoneW + safezoneX;
			y = 0.00833337 * safezoneH + safezoneY;
			w = 0.99 * safezoneW;
			h = 0.044 * safezoneH;
		};

		// Top Center
		class SliderCam: RscSlider
		{
			idc = 1601;

			x = 0.254167  * safezoneW + safezoneX;
			y = 0.958111 * safezoneH + safezoneY;
			w = 0.489844 * safezoneW;
			h = 0.033 * safezoneH;
		};

		// Left
		class TextStockBuy: RscStructuredText
		{
			idc = 1302;

			x = 0.0125 * safezoneW + safezoneX;
			y = 0.767593 * safezoneH + safezoneY;
			w = 0.0515625 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class TextLimit: RscStructuredText
		{
			idc = 1303;

			x = 0.0697914 * safezoneW + safezoneX;
			y = 0.766667 * safezoneH + safezoneY;
			w = 0.0515625 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class EditSell: RscEdit
		{
			idc = 1304;
			style = "16 + 512";

			text = "1";
			x = 0.126563 * safezoneW + safezoneX;
			y = 0.765741 * safezoneH + safezoneY;
			w = 0.0515625 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class TextPriceSell: RscStructuredText
		{
			idc = 1305;

			x = 0.0421875 * safezoneW + safezoneX;
			y = 0.724074 * safezoneH + safezoneY;
			w = 0.103125 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class ButtonSell: RscButtonEmpty
		{
			idc = -1;
			action = "[] spawn A3PL_CompanyShop_View_Sell;";

			x = 0.0536458 * safezoneW + safezoneX;
			y = 0.807407 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.033 * safezoneH;
			colorText[] = {0,0,0,0};
			colorBackground[] = {0,0,0,0};
		};

		// Center Left
		class ItemsSelling: RscListBox
		{
			idc = 1307;

			x = 0.00854169 * safezoneW + safezoneX;
			y = 0.196037 * safezoneH + safezoneY;
			w = 0.170156 * safezoneW;
			h = 0.473 * safezoneH;
		};

		// Center Right
		class ItemsBuying: RscListBox
		{
			idc = 1306;

			x = 0.821874 * safezoneW + safezoneX;
			y = 0.193519 * safezoneH + safezoneY;
			w = 0.170156 * safezoneW;
			h = 0.473 * safezoneH;
		};

		// Right
		class TextStockSell: RscStructuredText
		{
			idc = 1308;

			x = 0.825521 * safezoneW + safezoneX;
			y = 0.765741 * safezoneH + safezoneY;
			w = 0.0515625 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class EditBuy: RscEdit
		{
			idc = 1309;
			style = "16 + 512";

			text = "1";
			x = 0.939584 * safezoneW + safezoneX;
			y = 0.766667 * safezoneH + safezoneY;
			w = 0.0515625 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class TextPriceBuy: RscStructuredText
		{
			idc = 1310;

			x = 0.854687 * safezoneW + safezoneX;
			y = 0.725 * safezoneH + safezoneY;
			w = 0.103125 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class ButtonBuy: RscButtonEmpty
		{
			idc = -1;
			action = "[] spawn A3PL_CompanyShop_View_Buy;";

			x = 0.866667 * safezoneW + safezoneX;
			y = 0.803703 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.033 * safezoneH;
			colorText[] = {0,0,0,0};
			colorBackground[] = {0,0,0,0};
		};
	};
};

class Dialog_CompanyShop_MarkerConfig
{
	idd = 141;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "";
	onUnload = "";
	class controls
	{
		class Background: RscText
		{
			idc = -1;
			x = 0.3 * safezoneW + safezoneX;
			y = 0.2 * safezoneH + safezoneY;
			w = 0.4 * safezoneW;
			h = 0.5 * safezoneH;
			colorBackground[] = {0, 0, 0, 0.85};
		};
		class Title: RscText
		{
			idc = -1;
			x = 0.3 * safezoneW + safezoneX;
			y = 0.2 * safezoneH + safezoneY;
			w = 0.4 * safezoneW;
			h = 0.04 * safezoneH;
			colorBackground[] = {0.15, 0.15, 0.15, 1};
			text = "Configure Shop Marker";
			style = 2;
			sizeEx = 0.04;
		};
		class IconLabel: RscText
		{
			idc = -1;
			x = 0.31 * safezoneW + safezoneX;
			y = 0.25 * safezoneH + safezoneY;
			w = 0.38 * safezoneW;
			h = 0.03 * safezoneH;
			text = "Icon:";
			colorText[] = {0.8, 0.8, 0.8, 1};
		};
		class IconList: RscListBox
		{
			idc = 1410;
			x = 0.31 * safezoneW + safezoneX;
			y = 0.28 * safezoneH + safezoneY;
			w = 0.38 * safezoneW;
			h = 0.2 * safezoneH;
		};
		class DescLabel: RscText
		{
			idc = -1;
			x = 0.31 * safezoneW + safezoneX;
			y = 0.49 * safezoneH + safezoneY;
			w = 0.38 * safezoneW;
			h = 0.03 * safezoneH;
			text = "Description:";
			colorText[] = {0.8, 0.8, 0.8, 1};
		};
		class DescEdit: RscEdit
		{
			idc = 1411;
			x = 0.31 * safezoneW + safezoneX;
			y = 0.52 * safezoneH + safezoneY;
			w = 0.38 * safezoneW;
			h = 0.04 * safezoneH;
		};
		class BtnConfirm: RscButton
		{
			idc = 1412;
			x = 0.31 * safezoneW + safezoneX;
			y = 0.58 * safezoneH + safezoneY;
			w = 0.18 * safezoneW;
			h = 0.04 * safezoneH;
			text = "Confirm";
			action = "call A3PL_Company_ConfigShopMarker_Confirm;";
			colorBackground[] = {0.2, 0.6, 0.2, 1};
		};
		class BtnCancel: RscButton
		{
			idc = 1413;
			x = 0.51 * safezoneW + safezoneX;
			y = 0.58 * safezoneH + safezoneY;
			w = 0.18 * safezoneW;
			h = 0.04 * safezoneH;
			text = "Cancel";
			action = "closeDialog 0;";
			colorBackground[] = {0.6, 0.2, 0.2, 1};
		};
	};
};