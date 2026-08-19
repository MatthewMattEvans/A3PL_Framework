/* #Likany
$[
	1.063,
	["TaxiMeter",[[0,0,1,1],0.025,0.04,"GUI_GRID"],0,0,0],
	[1200,"static_bg",[1,"\A3PL_Common\GUI\A3PL_TaxiMeter.paa",["-0.0259375 * safezoneW + safezoneX","0.00500001 * safezoneH + safezoneY","1.00547 * safezoneW","0.99 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1400,"edit_initial",[1,"",["0.528854 * safezoneW + safezoneX","0.398222 * safezoneH + safezoneY","0.0873958 * safezoneW","0.022 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1401,"edit_miles",[1,"",["0.528854 * safezoneW + safezoneX","0.460519 * safezoneH + safezoneY","0.0873959 * safezoneW","0.022 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1402,"edit_60sec",[1,"",["0.528802 * safezoneW + safezoneX","0.515519 * safezoneH + safezoneY","0.086875 * safezoneW","0.0247777 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1403,"edit_60secstat",[1,"",["0.560313 * safezoneW + safezoneX","0.58337 * safezoneH + safezoneY","0.055625 * safezoneW","0.0229259 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1600,"button_change",[1,"",["0.462656 * safezoneW + safezoneX","0.634667 * safezoneH + safezoneY","0.075573 * safezoneW","0.0302222 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]]
]
*/


class Dialog_TaxiMeter
{
	idd = 29;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "";
	onUnload = "";
	class controls
	{
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT START (by Kane, v1.063, #Likany)
		////////////////////////////////////////////////////////

		class static_bg: RscPicture
		{
			idc = 1200;
			text = "\A3PL_Common\GUI\A3PL_TaxiMeter.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class edit_initial: RscEditInvisible
		{
			idc = 1400;
			style = "16 + 512";
			x = 0.436979 * safezoneW + safezoneX;
			y = 0.35463 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class edit_miles: RscEditInvisible
		{
			idc = 1401;
			style = "16 + 512";
			x = 0.43698 * safezoneW + safezoneX;
			y = 0.417593 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class edit_60sec: RscEditInvisible
		{
			idc = 1402;
			style = "16 + 512";
			x = 0.4375 * safezoneW + safezoneX;
			y = 0.47963 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class edit_60secstat: RscEditInvisible
		{
			idc = 1403;
			style = "16 + 512";
			x = 0.4375 * safezoneW + safezoneX;
			y = 0.540741 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class button_change: RscButtonEmpty
		{
			idc = 1600;
			x = 0.435417 * safezoneW + safezoneX;
			y = 0.607408 * safezoneH + safezoneY;
			w = 0.128906 * safezoneW;
			h = 0.055 * safezoneH;
		};
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT END
		////////////////////////////////////////////////////////

		
	};
};