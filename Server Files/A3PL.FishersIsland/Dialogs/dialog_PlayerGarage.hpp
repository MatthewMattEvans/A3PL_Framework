class Dialog_PlayerGarage
{
	idd = 145;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "";
	onUnload = "";
	class controls
	{
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT START (by Winston, v1.063, #Dezulo)
		////////////////////////////////////////////////////////
		class P_Background: RscPicture
		{
			idc = -1;
			text = "\A3PL_Common\GUI\dialog_PlayerGarage.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class L_StoredVehicles: RscListbox
		{
			idc = 1500;
			x = 0.209896 * safezoneW + safezoneX;
			y = 0.232407 * safezoneH + safezoneY;
			w = 0.211406 * safezoneW;
			h = 0.506 * safezoneH;
			sizeEx = 0.85 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0};
		};
		class L_VehicleInformation: RscListbox
		{
			idc = 1501;
			x = 0.546874 * safezoneW + safezoneX;
			y = 0.234259 * safezoneH + safezoneY;
			w = 0.211406 * safezoneW;
			h = 0.209 * safezoneH;
			sizeEx = 0.85 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0};
		};
		class TE_VehicleName: RscText
		{
			idc = 1502;
			x = 0.547553 * safezoneW + safezoneX;
			y = 0.489815 * safezoneH + safezoneY;
			w = 0.211406 * safezoneW;
			h = 0.033  * safezoneH;
			style = "16 + 512";
			sizeEx = 1 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0};
		};
		class TE_NewVehicleName: RscEditInvisible
		{
			idc = 1503;
			x = 0.547396 * safezoneW + safezoneX;
			y = 0.534259 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.022  * safezoneH;
			style = "16 + 512";
			sizeEx = 1 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0};
		};
		class B_RetreiveVehicle: RscButtonEmpty
		{
			idc = -1;
			x = 0.271875 * safezoneW + safezoneX;
			y = 0.752778 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.033 * safezoneH;
			action = "call A3PL_Storage_CarRetrieveButton;";
		};
		class B_RenameVehicle: RscButtonEmpty
		{
			idc = -1;
			x = 0.677083 * safezoneW + safezoneX;
			y = 0.536111 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.033 * safezoneH;
			action = "call A3PL_Storage_ChangeVehicleName;";
		};
		class Btn_Insure: RscButtonEmpty
		{
			idc = -1;
			x = 0.546354 * safezoneW + safezoneX;
			y = 0.608333 * safezoneH + safezoneY;
			w = 0.0928125 * safezoneW;
			h = 0.044 * safezoneH;
			action = "[] spawn A3PL_Storage_Insure;";
		};
		class Btn_GPS: RscButtonEmpty
		{
			idc = -1;
			x = 0.66875 * safezoneW + safezoneX;
			y = 0.610185 * safezoneH + safezoneY;
			w = 0.0928125 * safezoneW;
			h = 0.044 * safezoneH;
			action = "[] spawn A3PL_Storage_GPS;";
		};
	};
};