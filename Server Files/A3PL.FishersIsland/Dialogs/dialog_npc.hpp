/* #Mecewa
$[
	1.063,
	["Dialog_NPC",[[0,0,1,1],0.025,0.04,"GUI_GRID"],0,0,0],
	[1201,"static_bg",[1,"P:\A3PL_Common\GUI\A3PL_NPCt.paa",["0 * safezoneW + safezoneX","0 * safezoneH + safezoneY","1 * safezoneW","1 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1200,"",[1,"#(argb,8,8,3)color(1,1,1,1)",["0.356146 * safezoneW + safezoneX","0.440481 * safezoneH + safezoneY","0.0696353 * safezoneW","0.0737777 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1600,"button_1",[1,"1. Hey! I would like to start working at mcfishers.",["0.453594 * safezoneW + safezoneX","0.566 * safezoneH + safezoneY","0.221719 * safezoneW","0.022 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1601,"",[1,"2. I am hungry, I would like to buy food.",["0.453594 * safezoneW + safezoneX","0.588 * safezoneH + safezoneY","0.221719 * safezoneW","0.022 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1100,"",[1,"",["0.453594 * safezoneW + safezoneX","0.423 * safezoneH + safezoneY","0.221719 * safezoneW","0.132 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]]
]
*/

////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Kane, v1.063, #Vyvesa)
////////////////////////////////////////////////////////

class Dialog_NPC
{
	idd = 27;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "";
	onUnload = "if (!isNull A3PL_NPC_Cam) then {A3PL_NPC_Cam cameraEffect ['TERMINATE', 'BACK']; camDestroy A3PL_NPC_Cam};";
	class controls
	{
		class static_bg: RscPicture
		{
			idc = 1201;
			text = "\A3PL_Common\GUI\A3PL_NPC.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class RscPicture_1200: RscPicture
		{
			idc = 1200;
			text = "#(argb,256,256,1)r2t(A3PL_NPC_RT,1.0);";
			x = 0.305209 * safezoneW + safezoneX;
			y = 0.394445 * safezoneH + safezoneY;
			w = 0.0928125 * safezoneW;
			h = 0.099 * safezoneH;
		};
		class RscStructuredText_1100: RscStructuredText
		{
			idc = 1100;
			x = 0.40724 * safezoneW + safezoneX;
			y = 0.388741 * safezoneH + safezoneY;
			w = 0.293906 * safezoneW;
			h = 0.187 * safezoneH;
		};
		class button_close: RscButtonEmpty
		{
			idc = 1600;
			x = 0.6875 * safezoneW + safezoneX;
			y = 0.315741 * safezoneH + safezoneY;
			w = 0.020625 * safezoneW;
			h = 0.044 * safezoneH;
			action = "closeDialog 0;";
		};
	};
};


