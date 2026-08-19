/* #Posuli
$[
	1.063,
	["DMV",[[0,0,1,1],0.025,0.04,"GUI_GRID"],0,0,0],
	[1200,"static_bg",[1,"A3PL_Common\GUI\A3PL_DMV.paa",["0 * safezoneW + safezoneX","0 * safezoneH + safezoneY","1 * safezoneW","1 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1500,"list_players",[1,"",["0.351875 * safezoneW + safezoneX","0.344037 * safezoneH + safezoneY","0.302552 * safezoneW","0.122963 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1501,"list_mylicenses",[1,"",["0.350781 * safezoneW + safezoneX","0.530667 * safezoneH + safezoneY","0.304115 * safezoneW","0.0907778 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[2100,"combo_licenses",[1,"",["0.407187 * safezoneW + safezoneX","0.654926 * safezoneH + safezoneY","0.185365 * safezoneW","0.020963 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1600,"button_add",[1,"",["0.406719 * safezoneW + safezoneX","0.690704 * safezoneH + safezoneY","0.0745313 * safezoneW","0.0302222 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1601,"button_revoke",[1,"",["0.518906 * safezoneW + safezoneX","0.690556 * safezoneH + safezoneY","0.0745313 * safezoneW","0.0311481 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]]
]
*/
class Dialog_DMV
{
	idd = 21;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "";
	onUnload = "";
	
	class controls
	{
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT START (by Kane, v1.063, #Posuli)
		////////////////////////////////////////////////////////
		class static_bg: RscPicture
		{
			idc = 1200;
			text = "A3PL_Common\GUI\A3PL_DMV.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class list_players: RscListbox
		{
			idc = 1500;
			x = 0.241667 * safezoneW + safezoneX;
			y = 0.315741 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.187 * safezoneH;
		};
		class list_mylicenses: RscListbox
		{
			idc = 1501;
			x = 0.376562 * safezoneW + safezoneX;
			y = 0.422222 * safezoneH + safezoneY;
			w = 0.314531 * safezoneW;
			h = 0.066 * safezoneH;
		};
		class combo_licenses: RscCombo
		{
			idc = 2100;
			x = 0.378646 * safezoneW + safezoneX;
			y = 0.315741 * safezoneH + safezoneY;
			w = 0.309375 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class button_add: RscButtonEmpty
		{
			idc = 1600;
			x = 0.554688 * safezoneW + safezoneX;
			y = 0.344444 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class button_revoke: RscButtonEmpty
		{
			idc = 1601;
			x = 0.624479 * safezoneW + safezoneX;
			y = 0.344445 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.033 * safezoneH;
		};
	};
};