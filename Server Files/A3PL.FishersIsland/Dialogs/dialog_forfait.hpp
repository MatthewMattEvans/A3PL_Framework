class Dialog_Forfait {
	idd = 15000;
	name= "Dialog_Forfait";
	movingEnable = false;
	enableSimulation = true;
	class controlsBackground {
		class ForfaitMenu: RscPicture {
			text = "\A3PL_Common\GUI\newphone\orange.paa";
			idc = -1;
			x = 0.213854 * safezoneW + safezoneX;
			y = 0.141629 * safezoneH + safezoneY;
			w = 0.578542 * safezoneW;
			h = 0.993593 * safezoneH;
		};
	};

	class controls {
		class ForfaitTexte1: RscStructuredText
		{
			idc = 15001;
			text = "";
			style = 0;
			x = 0.553646 * safezoneW + safezoneX;
			y = 0.521297 * safezoneH + safezoneY;
			w = 0.202708 * safezoneW;
			h = 0.0364819 * safezoneH;
		};
		class Offre1: RscButtonEmpty {
			idc = 15002;
			text = "";
			onButtonClick = "[1,1] spawn A3PL_Phone_buyForfait;";
			x = 0.288489 * safezoneW + safezoneX;
			y = 0.585222 * safezoneH + safezoneY;
			w = 0.0797916 * safezoneW;
			h = 0.247593 * safezoneH;
		};
		class Offre2: RscButtonEmpty {
			idc = 15003;
			text = "";
			onButtonClick = "[1,2] spawn A3PL_Phone_buyForfait;";
			x = 0.375521 * safezoneW + safezoneX;
			y = 0.585222 * safezoneH + safezoneY;
			w = 0.0797916 * safezoneW;
			h = 0.247593 * safezoneH;
		};
		class Offre3: RscButtonEmpty {
			idc = 15004;
			text = "";
			onButtonClick = "[1,3] spawn A3PL_Phone_buyForfait;";
			x = 0.463021 * safezoneW + safezoneX;
			y = 0.585222 * safezoneH + safezoneY;
			w = 0.0797916 * safezoneW;
			h = 0.247593 * safezoneH;
		};
		class Offre4: RscButtonEmpty {
			idc = 15005;
			text = "";
			onButtonClick = "[1,4] spawn A3PL_Phone_buyForfait;";
			x = 0.551562 * safezoneW + safezoneX;
			y = 0.585222 * safezoneH + safezoneY;
			w = 0.0797916 * safezoneW;
			h = 0.247593 * safezoneH;
		};
		class Offre5: RscButtonEmpty {
			idc = 15006;
			text = "";
			onButtonClick = "[2,0] spawn A3PL_Phone_buyForfait;";
			x = 0.671354 * safezoneW + safezoneX;
			y = 0.585222 * safezoneH + safezoneY;
			w = 0.0797916 * safezoneW;
			h = 0.247593 * safezoneH;
		};
	};
};