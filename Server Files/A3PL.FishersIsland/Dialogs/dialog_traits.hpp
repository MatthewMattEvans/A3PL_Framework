/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/

class RscDisplayTraits
{
	idd = 87000;
	movingEnable = 0;
	enableSimulation = 1;
	enableDisplay = 1;
	class controls
	{
		class static_bg: RscPicture
		{
			idc = 1200;
			text = "\A3PL_Common\GUI\A3PL_Traits.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class TRAITS_TREE: RscTree
		{
			idc = 87001;
			onTreeSelChanged = "_this call A3PL_Traits_OnTreeSelChanged;";
			colorBackground[] = {0, 0, 0, 0.6};
			colorLines[] = {1, 1, 1, 1};

			x = 0.300521 * safezoneW + safezoneX;
			y = 0.50926 * safezoneH + safezoneY;
			w = 0.20625  * safezoneW;
			h = 0.253 * safezoneH;
		};

		class TRAITS_DESCRIPTION_CONTROL: RscControlsGroup
		{
			idc = 87002;
			x = 0.520834 * safezoneW + safezoneX;
			y = 0.40463 * safezoneH + safezoneY;
			w = 0.180469  * safezoneW;
			h = 0.319 * safezoneH;

			class Controls
			{
				class TRAITS_DESCRIPTION: RscStructuredText
				{
					idc = 87003;
					x = 0;
					y = 0;
					w = 0.165247 * safezoneW;
					h = 0.440118 * safezoneH;
					colorBackground[] = {0, 0, 0, 0.6};
				};
			};
		};

		class CHARACTER_PLAYTIME: RscStructuredText
		{
			idc = 87006;
			x = 0.299479 * safezoneW + safezoneX;
			y = 0.384259 * safezoneH + safezoneY;
			w = 0.118594 * safezoneW;
			h = 0.022 * safezoneH;
			colorBackground[] = {0, 0, 0, 0.6};
		};

		class CHARACTER_POINTS: RscStructuredText
		{
			idc = 87007;
			x = 0.299479 * safezoneW + safezoneX;
			y = 0.420371 * safezoneH + safezoneY;
			w = 0.118594 * safezoneW;
			h = 0.022  * safezoneH;
			colorBackground[] = {0, 0, 0, 0.6};
		};

		class CHARACTER_ACQUIRE: RscButtonEmpty
		{
			idc = 87008;
			x = 0.623958 * safezoneW + safezoneX;
			y = 0.737963  * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.033 * safezoneH;
		};

		class button_close: RscButtonEmpty
		{
			idc = 1602;
			x = 0.688542 * safezoneW + safezoneX;
			y = 0.313889 * safezoneH + safezoneY;
			w = 0.020625 * safezoneW;
			h = 0.044 * safezoneH;
			action = "closeDialog 0;";
		};
	};
};
