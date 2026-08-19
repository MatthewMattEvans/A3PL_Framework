class Dialog_FactionSetup
{
	idd = 111;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "";
	onUnload = "";
	class controls
	{
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT START (by Winston, v1.063, #Wowavu)
		////////////////////////////////////////////////////////
		class RscPicture_1200: RscPicture
		{
			idc = 1200;
			text = "\A3PL_Common\GUI\FactionSetup.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class RankName: RscEditInvisible
		{
			idc = 1400;
			style = "16 + 512";
			x = 0.613021 * safezoneW + safezoneX;
			y = 0.331482 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class RankPay: RscEditInvisible
		{
			idc = 1401;
			style = "16 + 512";
			x = 0.6125 * safezoneW + safezoneX;
			y = 0.389815 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class RanksList: RscListbox
		{
			idc = 1502;
			x = 0.225 * safezoneW + safezoneX;
			y = 0.272222 * safezoneH + safezoneY;
			w = 0.211406 * safezoneW;
			h = 0.165 * safezoneH;
		};
		class FactionMembers: RscListbox
		{
			idc = 1501;
			x = 0.225521 * safezoneW + safezoneX;
			y = 0.574075 * safezoneH + safezoneY;
			w = 0.211406 * safezoneW;
			h = 0.253 * safezoneH;
		};
		class RankMembers: RscListbox
		{
			idc = 1500;
			x = 0.563542 * safezoneW + safezoneX;
			y = 0.574074 * safezoneH + safezoneY;
			w = 0.211406 * safezoneW;
			h = 0.253 * safezoneH;
		};
		class MoveRankUp: RscButtonEmpty
		{
			idc = -1;
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.266667 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.055 * safezoneH;
		};
		class MoveRankDown: RscButtonEmpty
		{
			idc = -1;
			x = 0.447916 * safezoneW + safezoneX;
			y = 0.380556 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.055 * safezoneH;
		};
		class CreateNewRank: RscButtonEmpty
		{
			idc = -1;
			x = 0.223958 * safezoneW + safezoneX;
			y = 0.453704 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.033 * safezoneH;
			action = "call A3PL_Government_AddRank;";
		};
		class FireMember: RscButtonEmpty
		{
			idc = -1;
			x = 0.440104 * safezoneW + safezoneX;
			y = 0.793519 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.033 * safezoneH;
			action = "call A3PL_Government_Fire;";
		};
		class AssignRank: RscButtonEmpty
		{
			idc = -1;
			x = 0.441146 * safezoneW + safezoneX;
			y = 0.753704 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.033 * safezoneH;
			action = "call A3PL_Government_SetRank;";
		};
		class SetPay: RscButtonEmpty
		{
			idc = -1;
			x = 0.36198 * safezoneW + safezoneX;
			y = 0.472222 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.033 * safezoneH;
			action = "call A3PL_Government_SetPay;";
		};
		class DeleteRank: RscButtonEmpty
		{
			idc = -1;
			x = 0.223438  * safezoneW + safezoneX;
			y = 0.495371 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.033 * safezoneH;
			action = "call A3PL_Government_RemoveRank;";
		};
	};
};