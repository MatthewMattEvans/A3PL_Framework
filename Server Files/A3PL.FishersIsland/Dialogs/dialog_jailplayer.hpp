/* #Qifyxy
$[
	1.063,
	["JailPlayer",[[0,0,1,1],0.025,0.04,"GUI_GRID"],0,0,0],
	[2200,"",[1,"",["0.407187 * safezoneW + safezoneX","0.434 * safezoneH + safezoneY","0.195937 * safezoneW","0.165 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1600,"",[1,"Jail Player",["0.45875 * safezoneW + safezoneX","0.544 * safezoneH + safezoneY","0.0928125 * safezoneW","0.033 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1000,"static_amount",[1,"Amount:",["0.484531 * safezoneW + safezoneX","0.456 * safezoneH + safezoneY","0.0515625 * safezoneW","0.022 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1400,"",[1,"",["0.448438 * safezoneW + safezoneX","0.5 * safezoneH + safezoneY","0.113437 * safezoneW","0.022 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]]
]
*/

class Dialog_JailPlayer
{
	idd = 40;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "";
	onUnload = "";
	class controls
	{

		class BACKGRND: RscPicture
		{
			idc = 1200;
			text = "\A3PL_Common\GUI\Confirmation.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class button_createticket: RscButton
		{
			idc = 1600;
			x = 0.413542 * safezoneW + safezoneX;
			y = 0.448148 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.033 * safezoneH;
			action = "call A3PL_Police_JailPlayer;";
		};
		class button_cancel: RscButton
		{
			idc = 1600;
			x = 0.502604 * safezoneW + safezoneX;
			y = 0.447222 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.033 * safezoneH;
			action = "closeDialog 0;";
		};
		class static_amount: RscText
		{
			idc = 1000;
			text = "STR_UI_JailPlayer_Time";
			x = 0.435938 * safezoneW + safezoneX;
			y = 0.327778  * safezoneH + safezoneY;
			w = 0.128906 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class edit_amount: RscEdit
		{
			idc = 1400;
			x = 0.436458 * safezoneW + safezoneX;
			y = 0.367592 * safezoneH + safezoneY;
			w = 0.128906 * safezoneW;
			h = 0.022 * safezoneH;
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