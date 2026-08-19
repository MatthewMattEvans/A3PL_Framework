class A3PL_Bank_Dialog {
	idd = 21500;
	name= "A3PL_Bank_Dialog";
	movingEnable = false;
	enableSimulation = true;
	class controlsBackground {
		class MainBackground: RscPicture
		{
			idc = 1200;

			text = "\A3PL_Common\GUI\Bank\NewBank\fishersbank.paa";
			x = 0.213828 * safezoneW + safezoneX;
			y = 0.14162 * safezoneH + safezoneY;
			w = 0.578542 * safezoneW;
			h = 0.993593 * safezoneH;
		};
	};

	class controls {
		class NoAccountBG: RscPicture
		{
			idc = 1201;

			text = "\A3PL_Common\GUI\Bank\NewBank\fishersbank_noaccount.paa";
			x = 0.213828 * safezoneW + safezoneX;
			y = 0.14162 * safezoneH + safezoneY;
			w = 0.578542 * safezoneW;
			h = 0.993593 * safezoneH;
		};
		class HasCommonAccountBG: RscPicture
		{
			idc = 1202;

			text = "\A3PL_Common\GUI\Bank\NewBank\fishersbank_common.paa";
			x = 0.213828 * safezoneW + safezoneX;
			y = 0.14162 * safezoneH + safezoneY;
			w = 0.578542 * safezoneW;
			h = 0.993593 * safezoneH;
		};
		class HasSavingsAccountBG: RscPicture
		{
			idc = 1203;

			text = "\A3PL_Common\GUI\Bank\NewBank\fishersbank_savings.paa";
			x = 0.213828 * safezoneW + safezoneX;
			y = 0.14162 * safezoneH + safezoneY;
			w = 0.578542 * safezoneW;
			h = 0.993593 * safezoneH;
		};
		class HasCODAccountBG: RscPicture
		{
			idc = 1204;

			text = "\A3PL_Common\GUI\Bank\NewBank\fishersbank_allaccounts.paa";
			x = 0.213828 * safezoneW + safezoneX;
			y = 0.14162 * safezoneH + safezoneY;
			w = 0.578542 * safezoneW;
			h = 0.993593 * safezoneH;
		};
		class menu_Name: RscStructuredText
		{
			idc = 1211;
			text = "";
			x = 0.329844 * safezoneW + safezoneX;
			y = 0.4494 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.022 * safezoneH;
			class Attributes
			{
				font="RalewayExtraBold";
				color="#000000";
				align="left";
				shadow=0;
			};
		};
		class menu_classicmax: RscStructuredText
		{
			idc = 1212;
			x = 0.617564 * safezoneW + safezoneX;
			y = 0.8014 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.011 * safezoneH;
			size = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.48)";
			class Attributes
			{
				font="Raleway";
				color="#000000";
				align="left";
				shadow=0;
			};
		};
		class menu_classicprice: RscStructuredText
		{
			idc = 1213;
			x = 0.608419 * safezoneW + safezoneX;
			y = 0.81377 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.011 * safezoneH;
			size = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.48)";
			class Attributes
			{
				font="Raleway";
				color="#000000";
				align="left";
				shadow=0;
			};
		};
		class menu_classicfees: RscStructuredText
		{
			idc = 1214;
			x = 0.610566 * safezoneW + safezoneX;
			y = 0.824533 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.011 * safezoneH;
			size = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.48)";
			class Attributes
			{
				font="Raleway";
				color="#000000";
				align="left";
				shadow=0;
			};
		};
		class menu_goldmax: RscStructuredText
		{
			idc = 1215;
			x = 0.669125 * safezoneW + safezoneX;
			y = 0.8014 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.011 * safezoneH;
			size = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.45)";
			class Attributes
			{
				font="Raleway";
				color="#000000";
				align="left";
				shadow=0;
			};
		};
		class menu_goldprice: RscStructuredText
		{
			idc = 1216;
			x = 0.65946 * safezoneW + safezoneX;
			y = 0.81377 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.011 * safezoneH;
			size = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.48)";
			class Attributes
			{
				font="Raleway";
				color="#000000";
				align="left";
				shadow=0;
			};
		};
		class menu_goldfees: RscStructuredText
		{
			idc = 1217;
			x = 0.661618 * safezoneW + safezoneX;
			y = 0.824533 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.011 * safezoneH;
			size = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.48)";
			class Attributes
			{
				font="Raleway";
				color="#000000";
				align="left";
				shadow=0;
			};
		};
		class menu_platiniummax: RscStructuredText
		{
			idc = 1218;
			text = "STR_A3PL_Bank_Unlimited";
			x = 0.720688 * safezoneW + safezoneX;
			y = 0.8014 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.011 * safezoneH;
			size = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.48)";
			class Attributes
			{
				font="Raleway";
				color="#000000";
				align="left";
				shadow=0;
			};
		};
		class menu_platiniumprice: RscStructuredText
		{
			idc = 1219;
			x = 0.71047 * safezoneW + safezoneX;
			y = 0.811919 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.011 * safezoneH;
			size = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.48)";
			class Attributes
			{
				font="Raleway";
				color="#000000";
				align="left";
				shadow=0;
			};
		};
		class menu_platiniumfees: RscStructuredText
		{
			idc = 1220;
			x = 0.712639 * safezoneW + safezoneX;
			y = 0.824304 * safezoneH + safezoneY;
			w = 0.0309375 * safezoneW;
			h = 0.011 * safezoneH;
			size = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.48)";
			class Attributes
			{
				font="Raleway";
				color="#000000";
				align="left";
				shadow=0;
			};
		};
		class menu_commonamount: RscText
		{
			idc = 1221;
			style = ST_CENTER;		
			x = 0.264876 * safezoneW + safezoneX;
			y = 0.566 * safezoneH + safezoneY;
			w = 0.309375 * safezoneW;
			h = 0.033 * safezoneH;
			text = "";
			font="RalewayExtraBold";
			colorText[] = {0,0,0,1};
			shadow=0;
		};
		class menu_debtsamount: RscText
		{
			idc = 12211;
			style = ST_CENTER;
			x = 0.264876 * safezoneW + safezoneX;
			y = 0.599 * safezoneH + safezoneY;
			w = 0.309375 * safezoneW;
			h = 0.033 * safezoneH;
			text = "";
			font="RalewayExtraBold";
			colorText[] = {0,0,0,1};
			shadow=0;
		};
		class menu_savingsamount: RscText
		{
			idc = 1222;
			style = ST_CENTER;
			x = 0.264876 * safezoneW + safezoneX;
			y = 0.676 * safezoneH + safezoneY;
			w = 0.309375 * safezoneW;
			h = 0.055 * safezoneH;
			text = "";
			font="RalewayExtraBold";
			colorText[] = {0,0,0,1};
			shadow=0;
		};
		class menu_codamount: RscText
		{
			idc = 1223;
			style = ST_CENTER;
			x = 0.264876 * safezoneW + safezoneX;
			y = 0.7794 * safezoneH + safezoneY;
			w = 0.309375 * safezoneW;
			h = 0.055 * safezoneH;
			text = "";
			font="RalewayExtraBold";
			colorText[] = {0,0,0,1};
			shadow=0;
		};
		class menu_max: RscText
		{
			idc = 1224;
			style = ST_CENTER;
			x = 0.588687 * safezoneW + safezoneX;
			y = 0.5682 * safezoneH + safezoneY;
			w = 0.165 * safezoneW;
			h = 0.055 * safezoneH;
			text = "";
			font="RalewayExtraBold";
			colorText[] = {0,0,0,1};
			shadow=0;
		};
		class menu_linked: RscText
		{
			idc = 1225;
			style = ST_CENTER;
			x = 0.588687 * safezoneW + safezoneX;
			y = 0.665 * safezoneH + safezoneY;
			w = 0.165 * safezoneW;
			h = 0.055 * safezoneH;
			text = "";
			font="RalewayExtraBold";
			colorText[] = {0,0,0,1};
			shadow=0;
		};
		class menu_linkunlink: RscButtonEmpty
		{
			idc = 1226;
			x = 0.678405 * safezoneW + safezoneX;
			y = 0.7046 * safezoneH + safezoneY;
			w = 0.0721875 * safezoneW;
			h = 0.011 * safezoneH;
		};
		class menu_opencommon: RscButtonEmpty
		{
			idc = 1227;
			x = 0.422657 * safezoneW + safezoneX;
			y = 0.4428 * safezoneH + safezoneY;
			w = 0.0979687 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class menu_opensavings: RscButtonEmpty
		{
			idc = 1228;
			x = 0.530937 * safezoneW + safezoneX;
			y = 0.4428 * safezoneH + safezoneY;
			w = 0.0979687 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class menu_opencod: RscButtonEmpty
		{
			idc = 1229;
			x = 0.639219 * safezoneW + safezoneX;
			y = 0.4428 * safezoneH + safezoneY;
			w = 0.0979687 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class menu_buyclassic: RscButtonEmpty
		{
			idc = 1230;
			x = 0.596226 * safezoneW + safezoneX;
			y = 0.776852 * safezoneH + safezoneY;
			w = 0.0464063 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu_buygold: RscButtonEmpty
		{
			idc = 1231;
			x = 0.647469 * safezoneW + safezoneX;
			y = 0.7772 * safezoneH + safezoneY;
			w = 0.0464063 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu_buyplatinium: RscButtonEmpty
		{
			idc = 1232;
			x = 0.699033 * safezoneW + safezoneX;
			y = 0.7772 * safezoneH + safezoneY;
			w = 0.0464063 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu_disconnect: RscButtonEmpty
		{
			idc = 1233;
			action="closeDialog 0;";
			x = 0.711406 * safezoneW + safezoneX;
			y = 0.346 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.022 * safezoneH;
		};
	};
};

class A3PL_Bank_Account_Common_Dialog {
	idd = 22500;
	name= "A3PL_Bank_Account_Common_Dialog";
	movingEnable = false;
	enableSimulation = true;
	class controlsBackground {
		class MainBackground: RscPicture
		{
			idc = 2200;

			text = "\A3PL_Common\GUI\Bank\NewBank\fishersbank.paa";
			x = 0.213828 * safezoneW + safezoneX;
			y = 0.14162 * safezoneH + safezoneY;
			w = 0.578542 * safezoneW;
			h = 0.993593 * safezoneH;
		};
	};

	class controls {
		class Common: RscPicture
		{
			idc = 2201;

			text = "\A3PL_Common\GUI\Bank\NewBank\fishersbank_account_common.paa";
			x = 0.213828 * safezoneW + safezoneX;
			y = 0.14162 * safezoneH + safezoneY;
			w = 0.578542 * safezoneW;
			h = 0.993593 * safezoneH;
		};
		class CommonNoSpare: RscPicture
		{
			idc = 2202;

			text = "\A3PL_Common\GUI\Bank\NewBank\fishersbank_account_common_nospare.paa";
			x = 0.213828 * safezoneW + safezoneX;
			y = 0.14162 * safezoneH + safezoneY;
			w = 0.578542 * safezoneW;
			h = 0.993593 * safezoneH;
		};
		class CommonToPhysical: RscPicture
		{
			idc = 2203;

			text = "\A3PL_Common\GUI\Bank\NewBank\fishersbank_account_common_tophysical.paa";
			x = 0.213828 * safezoneW + safezoneX;
			y = 0.14162 * safezoneH + safezoneY;
			w = 0.578542 * safezoneW;
			h = 0.993593 * safezoneH;
		};
		class CommonToMoral: RscPicture
		{
			idc = 2204;

			text = "\A3PL_Common\GUI\Bank\NewBank\fishersbank_account_common_tomoral.paa";
			x = 0.213828 * safezoneW + safezoneX;
			y = 0.14162 * safezoneH + safezoneY;
			w = 0.578542 * safezoneW;
			h = 0.993593 * safezoneH;
		};
		class menu2_Name: RscStructuredText
		{
			idc = 2205;
			text = "";
			x = 0.329844 * safezoneW + safezoneX;
			y = 0.4494 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.022 * safezoneH;
			class Attributes
			{
				font="RalewayExtraBold";
				color="#000000";
				align="left";
				shadow=0;
			};
		};
		class menu2_accountnum: RscStructuredText
		{
			idc = 2206;
			x = 0.350469 * safezoneW + safezoneX;
			y = 0.5 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.022 * safezoneH;
			class Attributes
			{
				font="Raleway";
				color="#000000";
				align="left";
				shadow=0;
			};
		};
		class menu2_commonamount: RscText
		{
			idc = 2207;
			style = ST_CENTER;
			x = 0.264876 * safezoneW + safezoneX;
			y = 0.566 * safezoneH + safezoneY;
			w = 0.309375 * safezoneW;
			h = 0.033 * safezoneH;
			text = "";
			font="RalewayExtraBold";
			colorText[] = {0,0,0,1};
			shadow=0;
		};
		class menu2_debtsamount: RscText
		{
			idc = 22071;
			style = ST_CENTER;
			x = 0.264876 * safezoneW + safezoneX;
			y = 0.599 * safezoneH + safezoneY;
			w = 0.309375 * safezoneW;
			h = 0.033 * safezoneH;
			text = "";
			font="RalewayExtraBold";
			colorText[] = {0,0,0,1};
			shadow=0;
		};
		class menu2_cash: RscText
		{
			idc = 2208;
			style = ST_CENTER;
			x = 0.262812 * safezoneW + safezoneX;
			y = 0.676 * safezoneH + safezoneY;
			w = 0.314531 * safezoneW;
			h = 0.055 * safezoneH;
			text = "";
			font="RalewayExtraBold";
			colorText[] = {0,0,0,1};
			shadow=0;
		};
		class menu2_amount: RscEdit
		{
			idc = 2209;
			x = 0.396875 * safezoneW + safezoneX;
			y = 0.7838 * safezoneH + safezoneY;
			w = 0.0464063 * safezoneW;
			h = 0.016 * safezoneH;
			style=ST_CENTER+ST_NO_RECT;
			sizeEx = 0.012 * safezoneW;
			colorText[] = {0,0,0,1};
			font="Raleway";
			shadow = 0;	
		};
		class menu2_transferamount: RscEdit
		{
			idc = 2210;
			x = 0.6485 * safezoneW + safezoneX;
			y = 0.6738 * safezoneH + safezoneY;
			w = 0.0464063 * safezoneW;
			h = 0.016 * safezoneH;
			style=ST_CENTER+ST_NO_RECT;
			sizeEx = 0.012 * safezoneW;
			colorText[] = {0,0,0,1};
			font="Raleway";
			shadow = 0;		
		};
		class menu2_back: RscButtonEmpty
		{
			idc = 2211;
			x = 0.689749 * safezoneW + safezoneX;
			y = 0.4428 * safezoneH + safezoneY;
			w = 0.061875 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class menu2_withdraw: RscButtonEmpty
		{
			idc = 2212;
			x = 0.3515 * safezoneW + safezoneX;
			y = 0.8102 * safezoneH + safezoneY;
			w = 0.061875 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu2_deposit: RscButtonEmpty
		{
			idc = 2213;
			x = 0.42575 * safezoneW + safezoneX;
			y = 0.8102 * safezoneH + safezoneY;
			w = 0.061875 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu2_tophysical: RscButtonEmpty
		{
			idc = 2214;
			x = 0.603317 * safezoneW + safezoneX;
			y = 0.585185 * safezoneH + safezoneY;
			w = 0.061875 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu2_tomoral: RscButtonEmpty
		{
			idc = 2215;
			x = 0.676343 * safezoneW + safezoneX;
			y = 0.5858 * safezoneH + safezoneY;
			w = 0.061875 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu2_tosavings: RscButtonEmpty
		{
			idc = 2216;
			x = 0.626843 * safezoneW + safezoneX;
			y = 0.7002 * safezoneH + safezoneY;
			w = 0.0876563 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu2_tocod: RscButtonEmpty
		{
			idc = 2217;
			x = 0.626844 * safezoneW + safezoneX;
			y = 0.7266 * safezoneH + safezoneY;
			w = 0.0876563 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu2_disconnect: RscButtonEmpty
		{
			idc = 2218;
			action="closeDialog 0;";
			x = 0.711406 * safezoneW + safezoneX;
			y = 0.346 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.022 * safezoneH;
		};
		// Transfer to physical or moral person
		class menu21_transfertoamount: RscEdit
		{
			idc = 21201;
			x = 0.648088 * safezoneW + safezoneX;
			y = 0.57348 * safezoneH + safezoneY;
			w = 0.0464063 * safezoneW;
			h = 0.016 * safezoneH;
			style=ST_CENTER+ST_NO_RECT;
			sizeEx = 0.012 * safezoneW;
			colorText[] = {0,0,0,1};
			font="Raleway";
			shadow = 0;	
		};
		class menu21_transfernumber: RscEdit
		{
			idc = 212011;
			x = 0.648603 * safezoneW + safezoneX;
			y = 0.5968 * safezoneH + safezoneY;
			w = 0.0464063 * safezoneW;
			h = 0.016 * safezoneH;
			style=ST_CENTER+ST_NO_RECT;
			sizeEx = 0.012 * safezoneW;
			colorText[] = {0,0,0,1};
			font="Raleway";
			shadow = 0;	
		};
		class menu21_moralname: RscCombo
		{
			idc = 212012;
			x = 0.618594 * safezoneW + safezoneX;
			y = 0.599 * safezoneH + safezoneY;
			w = 0.103125 * safezoneW;
			h = 0.011 * safezoneH;
			font="Raleway";
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.5)";
			style=ST_CENTER;
			colorBackground[] = {1,1,1,1};
			colorText[] = {0,0,0,1};
		};
		class menu21_transfer: RscButtonEmpty
		{
			idc = 21202;
			x = 0.637157 * safezoneW + safezoneX;
			y = 0.6254 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu21_transfertoperson: RscButtonEmpty
		{
			idc = 21203;
			x = 0.611375 * safezoneW + safezoneX;
			y = 0.7046 * safezoneH + safezoneY;
			w = 0.118594 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu21_transfertospare: RscButtonEmpty
		{
			idc = 21204;
			x = 0.610961 * safezoneW + safezoneX;
			y = 0.733444 * safezoneH + safezoneY;
			w = 0.118594 * safezoneW;
			h = 0.022 * safezoneH;
		};
	};
};

class A3PL_Bank_Accounts_Spare_Dialog {
	idd = 23500;
	name= "A3PL_Bank_Accounts_Spare_Dialog";
	movingEnable = false;
	enableSimulation = true;
	class controlsBackground {
		class MainBackground: RscPicture
		{
			idc = 3200;

			text = "\A3PL_Common\GUI\Bank\NewBank\fishersbank.paa";
			x = 0.213828 * safezoneW + safezoneX;
			y = 0.14162 * safezoneH + safezoneY;
			w = 0.578542 * safezoneW;
			h = 0.993593 * safezoneH;
		};
	};

	class controls {
		class SavingsBG: RscPicture
		{
			idc = 3201;
			text = "\A3PL_Common\GUI\Bank\NewBank\fishersbank_account_savings.paa";
			x = 0.213828 * safezoneW + safezoneX;
			y = 0.14162 * safezoneH + safezoneY;
			w = 0.578542 * safezoneW;
			h = 0.993593 * safezoneH;
		};
		class CODBG: RscPicture
		{
			idc = 3202;
			text = "\A3PL_Common\GUI\Bank\NewBank\fishersbank_account_cod.paa";
			x = 0.213828 * safezoneW + safezoneX;
			y = 0.14162 * safezoneH + safezoneY;
			w = 0.578542 * safezoneW;
			h = 0.993593 * safezoneH;
		};
		class menu3_Name: RscStructuredText
		{
			idc = 3203;
			text = "";
			x = 0.329844 * safezoneW + safezoneX;
			y = 0.4494 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.022 * safezoneH;
			class Attributes
			{
				font="RalewayExtraBold";
				color="#000000";
				align="left";
				shadow=0;
			};
		};
		class menu3_accountamount: RscText
		{
			idc = 3204;
			style = ST_CENTER;
			x = 0.264875 * safezoneW + safezoneX;
			y = 0.5682 * safezoneH + safezoneY;
			w = 0.309375 * safezoneW;
			h = 0.066 * safezoneH;
			text = "";
			font="RalewayExtraBold";
			colorText[] = {0,0,0,1};
			shadow=0;
		};
		class menu3_commonamount: RscText
		{
			idc = 3205;
			style = ST_CENTER;
			x = 0.264874 * safezoneW + safezoneX;
			y = 0.7024 * safezoneH + safezoneY;
			w = 0.309375 * safezoneW;
			h = 0.077 * safezoneH;
			text = "";
			font="RalewayExtraBold";
			colorText[] = {0,0,0,1};
			shadow=0;
		};
		class menu3_debtsamount: RscText
		{
			idc = 3206;
			style = ST_CENTER;
			x = 0.264876 * safezoneW + safezoneX;
			y = 0.7816 * safezoneH + safezoneY;
			w = 0.309375 * safezoneW;
			h = 0.055 * safezoneH;
			text = "";
			font="RalewayExtraBold";
			colorText[] = {0,0,0,1};
			shadow=0;
		};
		class menu3_interests: RscText
		{
			idc = 3207;
			x = 0.588687 * safezoneW + safezoneX;
			y = 0.6738 * safezoneH + safezoneY;
			w = 0.165 * safezoneW;
			h = 0.165 * safezoneH;
			text = "";
			font="RalewayExtraBold";
			colorText[] = {0,0,0,1};
			shadow=0;
		};
		class menu3_transferamount: RscEdit
		{
			idc = 3208;
			x = 0.6485 * safezoneW + safezoneX;
			y = 0.577 * safezoneH + safezoneY;
			w = 0.0464063 * safezoneW;
			h = 0.016 * safezoneH;
			style=ST_CENTER+ST_NO_RECT;
			sizeEx = 0.012 * safezoneW;
			colorText[] = {0,0,0,1};
			font="Raleway";
			shadow = 0;		
		};
		class menu3_back: RscButtonEmpty
		{
			idc = 3209;
			x = 0.689749 * safezoneW + safezoneX;
			y = 0.4428 * safezoneH + safezoneY;
			w = 0.061875 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class menu3_tocommon: RscButtonEmpty
		{
			idc = 3210;
			x = 0.623749 * safezoneW + safezoneX;
			y = 0.6056 * safezoneH + safezoneY;
			w = 0.0928125 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu3_tospare: RscButtonEmpty
		{
			idc = 3211;
			x = 0.623751 * safezoneW + safezoneX;
			y = 0.632 * safezoneH + safezoneY;
			w = 0.0928125 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class menu3_disconnect: RscButtonEmpty
		{
			idc = 3212;
			action="closeDialog 0;";
			x = 0.711406 * safezoneW + safezoneX;
			y = 0.346 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.022 * safezoneH;
		};
	};
};

class A3PL_Bank_ATM_Dialog {
    idd = 253;
    name= "A3PL_Bank_ATM_Dialog";
    movingEnable = false;
    enableSimulation = true;
    class Controls
    {
        class BackPicture: RscPicture
        {
            idc = -1;
            text = "\A3PL_Common\GUI\A3PL_ATM.paa";
            x = 0.190625 * safezoneW + safezoneX;
            y = 0.181 * safezoneH + safezoneY;
            w = 0.629062 * safezoneW;
            h = 0.649 * safezoneH;
			action = "closeDialog 0;";
        };
        class ButtonWithdraw: RscButtonEmpty
        {
            idc = 5575;
            x = 0.365937 * safezoneW + safezoneX;
            y = 0.632 * safezoneH + safezoneY;
            w = 0.020625 * safezoneW;
            h = 0.022 * safezoneH;
            action = "[1] call A3PL_Bank_retirerCompteBancaire;";
        };
		class ButtonDeposit: RscButtonEmpty
        {
            idc = 5576;
            x = 0.365937 * safezoneW + safezoneX;
			y = 0.599 * safezoneH + safezoneY;
			w = 0.020625 * safezoneW;
			h = 0.022 * safezoneH;
            action = "[1] call A3PL_Bank_deposerCompteBancaire;";
        };
        class ButtonClose: RscButtonEmpty
        {
            idc = 5574;
            x = 0.62375 * safezoneW + safezoneX;
            y = 0.632 * safezoneH + safezoneY;
            w = 0.020625 * safezoneW;
            h = 0.022 * safezoneH;
            action = "closeDialog 0";
        };
        class MoneyAmount: RscEdit
        {
            idc = 5372;
            x = 0.463906 * safezoneW + safezoneX;
            y = 0.566 * safezoneH + safezoneY;
            w = 0.0825 * safezoneW;
            h = 0.022 * safezoneH;
            style = "16 + 512";
            colorText[] = {0,0,0,1};
            class Attributes {align = "center";};
        };
        class MoneyDisplay: RscStructuredText
        {
            idc = 4974;
            x = 0.463906 * safezoneW + safezoneX;
            y = 0.5 * safezoneH + safezoneY;
            w = 0.0825 * safezoneW;
            h = 0.022 * safezoneH;
            colorBackground[] = {0,0,0,0};
            colorText[] = {0,0,0,1};
            class Attributes {align = "center";};
        };
    };
};

class A3PL_HowToPay_Dialog {
	idd = 458762;
	name= "A3PL_DabMenu_Dialog";
	movingEnable = false;
	enableSimulation = true;
	class controlsBackground {
	};
	class controls {
		class bg: RscPicture
		{
			idc = 1200;
			text = "\A3PL_Common\GUI\Bank\MeansToPay_civ.paa";
			x = -0.0774299 * safezoneW + safezoneX;
			y = -0.104649 * safezoneH + safezoneY;
			w = 1.15525 * safezoneW;
			h = 1.22079 * safezoneH;
		};
		class cartepro: RscPicture
		{
			idc = 1201;
			text = "\A3PL_Common\GUI\Bank\procard.paa";
			x = -0.088843 * safezoneW + safezoneX;
			y = 0.00279997 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class CB: RscButtonEmpty
		{
			idc = 1600;
			x = 0.511345 * safezoneW + safezoneX;
			y = 0.5704 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.03 * safezoneH;
		};
		class CBPRO: RscButtonEmpty
		{
			idc = 1601;
			x = 0.357687 * safezoneW + safezoneX;
			y = 0.5704 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.03 * safezoneH;
		};
		class CASH: RscButtonEmpty
		{
			idc = 1602;
			x = 0.431904 * safezoneW + safezoneX;
			y = 0.5704 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.03 * safezoneH;
		};
		class rscedit: RscText
		{
			idc = 1400;
			x = 0.349513 * safezoneW + safezoneX;
			y = 0.4164 * safezoneH + safezoneY;
			w = 0.304219 * safezoneW;
			h = 0.154 * safezoneH;
		};
	};
};
