class A3PL_StockManage
{
	idd = 1102;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "";
	onUnload = "";
	class controls
	{
		class MainPic: RscPicture
		{
			idc = -1;
			text = "\A3PL_Common\GUI\A3PL_StockMan.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class LB_Internal: RscListBox
		{
			idc = 1500;

			x = 0.409375 * safezoneW + safezoneX;
			y = 0.164815 * safezoneH + safezoneY;
			w = 0.190781 * safezoneW;
			h = 0.308 * safezoneH;
		};
		class LB_Logs: RscListBox
		{
			idc = 1501;

			x = 0.608333 * safezoneW + safezoneX;
			y = 0.172222 * safezoneH + safezoneY;
			w = 0.232031 * safezoneW;
			h = 0.737 * safezoneH;
		};
		class LB_ExternalInv: RscListBox
		{
			idc = 1502;

			x = 0.166146 * safezoneW + safezoneX;
			y = 0.164815 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.308 * safezoneH;
		};
		class LB_Ranks: RscListBox
		{
			idc = 1503;

			x = 0.520833 * safezoneW + safezoneX;
			y = 0.547222 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.308 * safezoneH;
		};
		class EditDesc: RscEditInvisible
		{
			idc = 1504;
			style = "16 + 512";

			x = 0.314583 * safezoneW + safezoneX;
			y = 0.267593 * safezoneH + safezoneY;
			w = 0.0721875 * safezoneW;
			h = 0.088 * safezoneH;
		};
		class EditName: RscEditInvisible
		{
			idc = 1509;
			style = "16 + 512";

			x = 0.315104 * safezoneW + safezoneX;
			y = 0.427777 * safezoneH + safezoneY;
			w = 0.0721875 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class BTN_Add: RscButtonEmpty
		{
			idc = 1510;
			action = "call A3PL_Stock_Man_AddObject;";

			x = 0.313021 * safezoneW + safezoneX;
			y = 0.162037 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.033 * safezoneH;
			colorText[] = {0,0,0,0};
			colorBackground[] = {0,0,0,0};
		};
		class LB_Licenses: RscListBox
		{
			idc = 1513;

			x = 0.409896 * safezoneW + safezoneX;
			y = 0.544445 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.308 * safezoneH;
		};
		class BTN_Remove: RscButtonEmpty
		{
			idc = 1514;
			action = "call A3PL_Stock_Man_RemoveObject;";

			x = 0.3125 * safezoneW + safezoneX;
			y = 0.197222 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.033 * safezoneH;
			colorText[] = {0,0,0,0};
			colorBackground[] = {0,0,0,0};
		};
		class BTN_ModifyDesc: RscButtonEmpty
		{
			idc = 1515;
			action = "[1] call A3PL_Stock_Man_ModifyDescOrName;";

			x = 0.3125 * safezoneW + safezoneX;
			y = 0.359259 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.033 * safezoneH;
			colorText[] = {0,0,0,0};
			colorBackground[] = {0,0,0,0};
		};
		class BTN_ModifyName: RscButtonEmpty
		{
			idc = 1516;
			action = "[0] call A3PL_Stock_Man_ModifyDescOrName;";

			x = 0.311979 * safezoneW + safezoneX;
			y = 0.453704 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.033 * safezoneH;
			colorText[] = {0,0,0,0};
			colorBackground[] = {0,0,0,0};
		};
		class BTN_RankAdd: RscButtonEmpty
		{
			idc = 1517;
			action = "[0] call A3PL_Stock_Man_ModifyRankOrLicense;";

			x = 0.519271  * safezoneW + safezoneX;
			y = 0.866667 * safezoneH + safezoneY;
			w = 0.020625  * safezoneW;
			h = 0.044 * safezoneH;
			colorText[] = {0,0,0,0};
			colorBackground[] = {0,0,0,0};
		};
		class BTN_RankIndiff: RscButtonEmpty
		{
			idc = 1518;
			action = "[1] call A3PL_Stock_Man_ModifyRankOrLicense;";

			x = 0.549479 * safezoneW + safezoneX;
			y = 0.864814 * safezoneH + safezoneY;
			w = 0.020625 * safezoneW;
			h = 0.044 * safezoneH;
			colorText[] = {0,0,0,0};
			colorBackground[] = {0,0,0,0};
		};
		class BTN_RankRemove: RscButtonEmpty
		{
			idc = 1519;
			action = "[2] call A3PL_Stock_Man_ModifyRankOrLicense;";

			x = 0.578646 * safezoneW + safezoneX;
			y = 0.864815 * safezoneH + safezoneY;
			w = 0.020625 * safezoneW;
			h = 0.044 * safezoneH;
			colorText[] = {0,0,0,0};
			colorBackground[] = {0,0,0,0};
		};
		class BTN_LicenseAdd: RscButtonEmpty
		{
			idc = 1520;
			action = "[3] call A3PL_Stock_Man_ModifyRankOrLicense;";

			x = 0.409375 * safezoneW + safezoneX;
			y = 0.867593 * safezoneH + safezoneY;
			w = 0.020625 * safezoneW;
			h = 0.044 * safezoneH;
			colorText[] = {0,0,0,0};
			colorBackground[] = {0,0,0,0};
		};
		class BTN_LicenseIndiff: RscButtonEmpty
		{
			idc = 1521;
			action = "[4] call A3PL_Stock_Man_ModifyRankOrLicense;";

			x = 0.439063  * safezoneW + safezoneX;
			y = 0.866667  * safezoneH + safezoneY;
			w = 0.020625 * safezoneW;
			h = 0.044 * safezoneH;
			colorText[] = {0,0,0,0};
			colorBackground[] = {0,0,0,0};
		};
		class BTN_LicenseRemove: RscButtonEmpty
		{
			idc = 1522;
			action = "[5] call A3PL_Stock_Man_ModifyRankOrLicense;";

			x = 0.468229 * safezoneW + safezoneX;
			y = 0.865741  * safezoneH + safezoneY;
			w = 0.020625  * safezoneW;
			h = 0.044 * safezoneH;
			colorText[] = {0,0,0,0};
			colorBackground[] = {0,0,0,0};
		};
		class VehicleInfos: RscListBox
		{
			idc = 1523;

			x = 0.165104 * safezoneW + safezoneX;
			y = 0.510185 * safezoneH + safezoneY;
			w = 0.221719 * safezoneW;
			h = 0.352 * safezoneH;
			sizeEx = 0.65 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0};
		};
	};
};

class A3PL_Stock
{
	idd = 1103;
	movingEnable = false;
	enableSimulation = true;
	onLoad = "";
	onUnload = "";
	class controls
	{
		class BACKGROUND: RscPicture
		{
			idc = -1;
			text = "\A3PL_Common\GUI\A3PL_Stock.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class Items: RscListBox
		{
			idc = 1600;

			x = 0.00781254 * safezoneW + safezoneX;
			y = 0.19537  * safezoneH + safezoneY;
			w = 0.170156 * safezoneW;
			h = 0.473 * safezoneH;
		};
		class SliderCam: RscSlider
		{
			idc = 1601;

			x = 0.0140625 * safezoneW + safezoneX;
			y = 0.862963 * safezoneH + safezoneY;
			w = 0.159844  * safezoneW;
			h = 0.044 * safezoneH;
		};
		class Withdraw: RscButtonEmpty
		{
			idc = 1602;

			x = 0.0104167 * safezoneW + safezoneX;
			y = 0.810185 * safezoneH + safezoneY;
			w = 0.061875 * safezoneW;
			h = 0.022 * safezoneH;
			colorText[] = {0,0,0,0};
			colorBackground[] = {0,0,0,0};
		};
		class Deposit: RscButtonEmpty
		{
			idc = 1603;

			x = 0.119271 * safezoneW + safezoneX;
			y = 0.809259 * safezoneH + safezoneY;
			w = 0.061875 * safezoneW;
			h = 0.022 * safezoneH;
			colorText[] = {0,0,0,0};
			colorBackground[] = {0,0,0,0};
		};
		class QTY: RscEditInvisible
		{
			idc = 1604;
			style = "16 + 512";

			text = "1";
			x = 0.0744791 * safezoneW + safezoneX;
			y = 0.802778 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class Stock: RscStructuredText
		{
			idc = 1605;

			x = 0.0119792 * safezoneW + safezoneX;
			y = 0.743518 * safezoneH + safezoneY;
			w = 0.0515625 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class Desc: RscStructuredText
		{
			idc = 1606;

			x = 0.0713543 * safezoneW + safezoneX;
			y = 0.730555 * safezoneH + safezoneY;
			w = 0.103125 * safezoneW;
			h = 0.055 * safezoneH;
		};

	};
};

class A3PL_StockVeh
{
	idd = 1104;
	movingEnable = false;
	enableSimulation = true;
	onLoad = "";
	onUnload = "";
	class controls
	{
		class BACKGROUND: RscPicture
		{
			idc = -1;
			text = "\A3PL_Common\GUI\A3PL_StockVeh.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class Items: RscListBox
		{
			idc = 1600;

			x = 0.00781254 * safezoneW + safezoneX;
			y = 0.19537  * safezoneH + safezoneY;
			w = 0.170156 * safezoneW;
			h = 0.473 * safezoneH;
		};
		class SliderCam: RscSlider
		{
			idc = 1601;

			x = 0.19375 * safezoneW + safezoneX;
			y = 0.919445  * safezoneH + safezoneY;
			w = 0.159844  * safezoneW;
			h = 0.044 * safezoneH;
		};
		class Withdraw: RscButtonEmpty
		{
			idc = 1602;

			x = 0.00937504 * safezoneW + safezoneX;
			y = 0.922222 * safezoneH + safezoneY;
			w = 0.061875 * safezoneW;
			h = 0.022 * safezoneH;
			colorText[] = {0,0,0,0};
			colorBackground[] = {0,0,0,0};
		};
		class Deposit: RscButtonEmpty
		{
			idc = 1603;

			x = 0.117188 * safezoneW + safezoneX;
			y = 0.922222 * safezoneH + safezoneY;
			w = 0.061875 * safezoneW;
			h = 0.022 * safezoneH;
			colorText[] = {0,0,0,0};
			colorBackground[] = {0,0,0,0};
		};
		class QTY: RscEdit
		{
			idc = 1604;
			style = "16 + 512";

			text = "1";
			x = 0.0745312 * safezoneW + safezoneX;
			y = 0.916815 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class Stock: RscStructuredText
		{
			idc = 1605;

			x = 0.0119792  * safezoneW + safezoneX;
			y = 0.743518 * safezoneH + safezoneY;
			w = 0.0515625 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class Desc: RscStructuredText
		{
			idc = 1606;

			x = 0.0713543 * safezoneW + safezoneX;
			y = 0.730555 * safezoneH + safezoneY;
			w = 0.103125 * safezoneW;
			h = 0.055 * safezoneH;
		};
		class VehicleInfos: RscListBox
		{
			idc = 1607;

			x = 0.0114584 * safezoneW + safezoneX;
			y = 0.801852 * safezoneH + safezoneY;
			w = 0.165 * safezoneW;
			h = 0.099 * safezoneH;
			sizeEx = 0.65 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0};
		};
	};
};