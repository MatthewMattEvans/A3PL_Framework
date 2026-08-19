class Dialog_Inventory
{
	idd = 1001;
	name = "Dialog_Inventory";
	movingEnable = false;
	enableSimulation = true;
	onUnload = "player setVariable ['Inventory_Opened', nil, true];";
	class controls
	{
		class static_background: RscPicture
		{
			idc = IDC_DIALOG_INVENTORY_BACKGROUND;
			text = "\A3PL_Common\GUI\A3PL_Inventory.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class itemList: RscListbox
		{
			idc = IDC_DIALOG_INVENTORY_ITEMLIST;
			x = 0.243218 * safezoneW + safezoneX;
			y = 0.126 * safezoneH + safezoneY;
			w = 0.328 * safezoneW;
			h = 0.466 * safezoneH;
			colorText[] = {0.95, 0.95, 0.95, 1};
			colorSelect[] = {1, 1, 1, 1};
			onLBDblClick = "[] call A3PL_Inventory_Use;";
		};
		class PitemsList: RscListbox
		{
			idc = IDC_DIALOG_INVENTORY_PITEMSLIST;
			x = 0.578376 * safezoneW + safezoneX;
			y = 0.126 * safezoneH + safezoneY;
			w = 0.1842 * safezoneW;
			h = 0.466 * safezoneH;
			colorText[] = {0.95, 0.95, 0.95, 1};
			colorSelect[] = {1, 1, 1, 1};
			onLBDblClick = "[] call A3PL_Inventory_Use;";
		};
		class amount: RscEditInvisible
		{
			idc = IDC_DIALOG_INVENTORY_AMOUNT;
			style = "16 + 512";
			x = 0.244254 * safezoneW + safezoneX;
			y = 0.6232 * safezoneH + safezoneY;
			w = 0.128906 * safezoneW;
			h = 0.022 * safezoneH;
			colorText[] = {0.95, 0.95, 0.95, 1};
		};
		class UseButton: RscButtonEmpty
		{
			idc = IDC_DIALOG_INVENTORY_USEBUTTON;
			x = 0.309219 * safezoneW + safezoneX;
			y = 0.648 * safezoneH + safezoneY;
			w = 0.064 * safezoneW;
			h = 0.025 * safezoneH;
			tooltip = "STR_UI_Inventory_Use";
		};
		class dropButton: RscButtonEmpty
		{
			idc = IDC_DIALOG_INVENTORY_DROPBUTTON;
			x = 0.243218 * safezoneW + safezoneX;
			y = 0.648 * safezoneH + safezoneY;
			w = 0.064 * safezoneW;
			h = 0.025 * safezoneH;
			tooltip = "STR_UI_Inventory_Drop";
		};
		class closeButton: RscButtonEmpty
		{
			idc = IDC_DIALOG_INVENTORY_CLOSEBUTTON;
			x = 0.740281 * safezoneW + safezoneX;
			y = 0.027 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.055 * safezoneH;
			tooltip = "STR_UI_Inventory_Close";
		};
		class listbox_keys: RscListbox
		{
			idc = 1900;
			x = 0.378312 * safezoneW + safezoneX;
			y = 0.698 * safezoneH + safezoneY;
			w = 0.1935 * safezoneW;
			h = 0.0905 * safezoneH;
			colorText[] = {0.95, 0.95, 0.95, 1};
			colorSelect[] = {1, 1, 1, 1};
			onLBDblClick = "[] call A3PL_Housing_Grabkey;";
		};
		class button_usekey: RscButtonEmpty
		{
			idc = 1604;
			x = 0.442249 * safezoneW + safezoneX;
			y = 0.8 * safezoneH + safezoneY;
			w = 0.064 * safezoneW;
			h = 0.025 * safezoneH;
			action = "[] call A3PL_Housing_Grabkey";
			tooltip = "STR_UI_Inventory_GrabKey";
		};
		class list_licenses: RscListbox
		{
			idc = 1503;
			x = 0.578376 * safezoneW + safezoneX;
			y = 0.6235 * safezoneH + safezoneY;
			w = 0.1842 * safezoneW;
			h = 0.2 * safezoneH;
			colorText[] = {0.95, 0.95, 0.95, 1};
			colorSelect[] = {1, 1, 1, 1};
		};
		class playerinfos: RscStructuredText
		{
			idc = 1605;
			x = 0.378313 * safezoneW + safezoneX;
			y = 0.621 * safezoneH + safezoneY;
			w = 0.1943 * safezoneW;
			h = 0.0495 * safezoneH;
		};
	};
};