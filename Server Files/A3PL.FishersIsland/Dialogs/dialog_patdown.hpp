/* #Nuduhi
$[
	1.063,
	["PatDown",[[0,0,1,1],0.025,0.04,"GUI_GRID"],0,0,0],
	[1200,"static_bg",[1,"\A3PL_Common\GUI\A3PL_PatDown.paa",["0 * safezoneW + safezoneX","0 * safezoneH + safezoneY","1 * safezoneW","1 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1500,"lb_items",[1,"",["0.204583 * safezoneW + safezoneX","0.324 * safezoneH + safezoneY","0.183021 * safezoneW","0.382222 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1501,"lb_weapons",[1,"",["0.40849 * safezoneW + safezoneX","0.324259 * safezoneH + safezoneY","0.183073 * safezoneW","0.381704 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1502,"lb_magazines",[1,"",["0.612552 * safezoneW + safezoneX","0.322852 * safezoneH + safezoneY","0.182552 * safezoneW","0.384481 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1600,"button_itemTake",[1,"",["0.258698 * safezoneW + safezoneX","0.729148 * safezoneH + safezoneY","0.0751041 * safezoneW","0.033 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1601,"button_weapontake",[1,"",["0.463854 * safezoneW + safezoneX","0.729148 * safezoneH + safezoneY","0.0745834 * safezoneW","0.0320741 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1602,"button_magtake",[1,"",["0.670834 * safezoneW + safezoneX","0.729037 * safezoneH + safezoneY","0.0761458 * safezoneW","0.033 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]]
]
*/

class Dialog_PatDown
{
	idd = 93;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "";
	onUnload = "";
	class controls
	{
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT START (by Kane, v1.063, #Nuduhi)
		////////////////////////////////////////////////////////

		class static_bg: RscPicture
		{
			idc = 1200;
			text = "\A3PL_Common\GUI\A3PL_PatDown.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class lb_items: RscListbox
		{
			idc = 1500;
			x = 0.619792 * safezoneW + safezoneX;
			y = 0.271296 * safezoneH + safezoneY;
			w = 0.190781 * safezoneW;
			h = 0.462 * safezoneH;
		};
		class lb_weapons: RscListbox
		{
			idc = 1501;
			x = 0.405729 * safezoneW + safezoneX;
			y = 0.275926 * safezoneH + safezoneY;
			w = 0.190781 * safezoneW;
			h = 0.462 * safezoneH;
		};
		class lb_magazines: RscListbox
		{
			idc = 1502;
			x = 0.191146 * safezoneW + safezoneX;
			y = 0.275926 * safezoneH + safezoneY;
			w = 0.190781 * safezoneW;
			h = 0.462 * safezoneH;
		};
		class button_itemTake: RscButtonEmpty
		{
			idc = 1600;
			x = 0.677604 * safezoneW + safezoneX;
			y = 0.753704 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class button_weapontake: RscButtonEmpty
		{
			idc = 1601;
			x = 0.463021 * safezoneW + safezoneX;
			y = 0.752778 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class button_magtake: RscButtonEmpty
		{
			idc = 1602;
			x = 0.248437 * safezoneW + safezoneX;
			y = 0.75 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class DisplayName: RscStructuredText
		{
			idc = 1100;
			text = "STR_UI_Patdown_Search";
			x = 0.393698 * safezoneW + safezoneX;
			y = 0.166296 * safezoneH + safezoneY;
			w = 0.262969 * safezoneW;
			h = 0.044 * safezoneH;
			sizeEx = 2 * GUI_GRID_H;
		};
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT END
		////////////////////////////////////////////////////////
	};
};