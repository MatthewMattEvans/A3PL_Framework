class Dialog_Budget_Manage
{
	idd = 140;
	movingEnable = 0;
	enableSimulation = 1;
	name="Dialog_Budget_Manage";

	class Controls
	{
		class RscPictureBudget: RscPicture
		{
			idc = -1;
			text = "\A3PL_Common\GUI\A3PL_Budget_Manage.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class amount: RscStructuredText
		{
			idc = 1201;
			x = 0.433333 * safezoneW + safezoneX;
			y = 0.428704 * safezoneH + safezoneY;
			w = 0.118594 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class edit_amount: RscEdit
		{
			idc = 1202;
			x = 0.428593 * safezoneW + safezoneX;
			y = 0.527778 * safezoneH + safezoneY;
			w = 0.128906 * safezoneW;
			h = 0.022 * safezoneH;
			style = "16 + 512";
		};
		class button_transfert: RscButtonEmpty
		{
			idc = 1203;
			text = "";
			x = 0.448047 * safezoneW + safezoneX;
			y = 0.591667 * safezoneH + safezoneY;
			w = 0.103125 * safezoneW;
			h = 0.044 * safezoneH;
			action = "call A3PL_Government_BudgetAdd;";
		};
		class button_withdraw: RscButtonEmpty
		{
			idc = 1204;
			text = "";
			x = 0.429687 * safezoneW + safezoneX;
			y = 0.558333 * safezoneH + safezoneY;
			w = 0.061875 * safezoneW;
			h = 0.022 * safezoneH;
			action = "call A3PL_Government_BudgetWithdraw;";
		};
	};
};