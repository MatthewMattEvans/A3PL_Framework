class Dialog_Factory_V2 {
	idd = 2500;
	movingEnable = false;
	enableSimulation = true;
	class controls
	{
		////////////////////////////////////////////////////////
		//                BACKGROUND PICTURES                 //
		////////////////////////////////////////////////////////
		class FactoryBackground: RscPicture
		{
			idc = 250000;

			text = "A3PL_Common\GUI\factories\A3PL_Factory_myFactory.paa";
			x = 4.99852e-05 * safezoneW + safezoneX;
			y = 0.00214001 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 0.999999 * safezoneH;
		};
		class StorageBackground: RscPicture
		{
			idc = 26000;

			text = "A3PL_Common\GUI\factories\A3PL_Factory_Storage.paa";
			x = 4.99852e-05 * safezoneW + safezoneX;
			y = 0.00214001 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 0.999999 * safezoneH;
		};
		class UpgradesBackground: RscPicture
		{
			idc = 27000;

			text = "A3PL_Common\GUI\factories\A3PL_Factory_Upgrades.paa";
			x = 4.99852e-05 * safezoneW + safezoneX;
			y = 0.00214001 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 0.999999 * safezoneH;
		};
		class CraftsBackground: RscPicture
		{
			idc = 28000;

			text = "A3PL_Common\GUI\factories\A3PL_Factory_Crafts.paa";
			x = 4.99852e-05 * safezoneW + safezoneX;
			y = 0.00214001 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 0.999999 * safezoneH;
		};
		class ShareBackground: RscPicture
		{
			idc = 29000;

			text = "A3PL_Common\GUI\factories\A3PL_Factory_ShareCraft.paa";
			x = 4.99852e-05 * safezoneW + safezoneX;
			y = 0.00214001 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 0.999999 * safezoneH;
		};

		////////////////////////////////////////////////////////
		//                  ACCESS BUTTONS                    //
		////////////////////////////////////////////////////////
		class FactoryAccess: RscButtonEmpty
		{
			idc = 25001;
			x = 0.422656 * safezoneW + safezoneX;
			y = 0.098 * safezoneH + safezoneY;
			w = 0.0245 * safezoneW;
			h = 0.0565 * safezoneH;
		};
		class StorageAccess: RscButtonEmpty
		{
			idc = 26001;
			x = 0.454625 * safezoneW + safezoneX;
			y = 0.098 * safezoneH + safezoneY;
			w = 0.0245 * safezoneW;
			h = 0.0565 * safezoneH;
		};
		class UpgradesAccess: RscButtonEmpty
		{
			idc = 27001;
			x = 0.488 * safezoneW + safezoneX;
			y = 0.098 * safezoneH + safezoneY;
			w = 0.0245 * safezoneW;
			h = 0.0565 * safezoneH;
		};
		class CraftsAccess: RscButtonEmpty
		{
			idc = 28001;
			x = 0.52 * safezoneW + safezoneX;
			y = 0.098 * safezoneH + safezoneY;
			w = 0.0245 * safezoneW;
			h = 0.0565 * safezoneH;
		};
		class ShareAccess: RscButtonEmpty
		{
			idc = 29001;
			x = 0.5535 * safezoneW + safezoneX;
			y = 0.098 * safezoneH + safezoneY;
			w = 0.0245 * safezoneW;
			h = 0.0565 * safezoneH;
		};

		////////////////////////////////////////////////////////
		//                   FACTORY PAGE                     //
		////////////////////////////////////////////////////////
		
		// LEFT SIDE
		class Factory_AvailableCrafts: RscTree
		{
			idc = 25002;
			type = 12;
			x = 0.213312 * safezoneW + safezoneX;
			y = 0.1876 * safezoneH + safezoneY;
			w = 0.159844 * safezoneW;
			h = 0.33 * safezoneH;
			style = 16;
			colorBackground[] = {0.1, 0.1, 0.1, 0.6};
			colorSelect[] = {0.176, 0.164, 0.164, 0.8};
			colorText[] = {1, 1, 1, 1};
			colorSelectText[] = {1, 1, 1, 1};
			colorBorder[] = {0, 0, 0, 0};
			colorSearch[] = {0.13, 0.54, 0.21, 0.8};
			colorMarked[] = {0.2, 0.3, 0.7, 1};
			colorMarkedText[] = {1, 1, 1, 1};
			colorMarkedSelected[] = {0, 0.5, 0.5, 1};
			colorPicture[] = {1, 1, 1, 1};
			colorPictureSelected[] = {1, 1, 1, 1};
			colorPictureDisabled[] = {1, 1, 1, 0.25};
			colorPictureRight[] = {1, 1, 1, 1};
			colorPictureRightSelected[] = {1, 1, 1, 1};
			colorPictureRightDisabled[] = {1, 1, 1, 0.25};
			colorArrow[] = {1, 1, 1, 1};
			soundSelect[] = {"", 0.1, 1};
			soundExpand[] = {"", 0.1, 1};
			soundCollapse[] = {"", 0.1, 1};
			multiselectEnabled = 0;
			maxHistoryDelay = 1;
			shadow = 0;
			font = "RobotoCondensed";
			expandedTexture = "A3\ui_f\data\gui\rsccommon\rsctree\expandedTexture_ca.paa";
			hiddenTexture = "A3\ui_f\data\gui\rsccommon\rsctree\hiddenTexture_ca.paa";
			rowHeight = 0.04;
			colorSelectBackground[] = {0, 0, 0, 0.5};
			colorLines[] = {0, 0, 0, 0};
			borderSize = 0;
			expandOnDoubleclick = 1;
			class ScrollBar
			{
				color[] = {1, 1, 1, 1};
				thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
				arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
				arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
				border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
			};
		};
		class Factory_SearchBar: RscEdit
		{
			idc = 25003;
			x = 0.2135 * safezoneW + safezoneX;
			y = 0.5378 * safezoneH + safezoneY;
			w = 0.1525 * safezoneW;
			h = 0.013 * safezoneH;
		};
		class Factory_Craft_Desc: RscStructuredText
		{
			idc = 25004;
			x = 0.2135 * safezoneW + safezoneX;
			y = 0.571 * safezoneH + safezoneY;
			w = 0.115 * safezoneW;
			h = 0.019 * safezoneH;
		};
		class Factory_Crafted_Amount: RscStructuredText
		{
			idc = 25005;
			x = 0.33294 * safezoneW + safezoneX;
			y = 0.571 * safezoneH + safezoneY;
			w = 0.04 * safezoneW;
			h = 0.019 * safezoneH;
		};
		class Factory_RequiredItems: RscListbox
		{
			idc = 25006;
			x = 0.213313 * safezoneW + safezoneX;
			y = 0.633 * safezoneH + safezoneY;
			w = 0.1586 * safezoneW;
			h = 0.13 * safezoneH;
		};
		
		// CENTER
		class Factory_Preview: RscPicture
		{
			idc = 25007;
			text = "#(argb,8,8,3)color(1,1,1,1)";
			x = 0.389 * safezoneW + safezoneX;
			y = 0.18 * safezoneH + safezoneY;
			w = 0.315 * safezoneW;
			h = 0.594 * safezoneH;
		};

		// RIGHT SIDE
		class Factory_Slot1Name: RscStructuredText
		{
			idc = 25008;
			x = 0.720687 * safezoneW + safezoneX;
			y = 0.19 * safezoneH + safezoneY;
			w = 0.075 * safezoneW;
			h = 0.018 * safezoneH;
		};
		class Factory_Slot1Object: RscStructuredText
		{
			idc = 25009;
			x = 0.720688 * safezoneW + safezoneX;
			y = 0.2074 * safezoneH + safezoneY;
			w = 0.075 * safezoneW;
			h = 0.018 * safezoneH;
		};
		class Factory_Slot1Progress: RscProgress
		{
			idc = 25010;
			x = 0.720688 * safezoneW + safezoneX;
			y = 0.225 * safezoneH + safezoneY;
			w = 0.075 * safezoneW;
			h = 0.018 * safezoneH;
		};
		class Factory_Slot2Name: RscStructuredText
		{
			idc = 25011;
			x = 0.720688 * safezoneW + safezoneX;
			y = 0.2492 * safezoneH + safezoneY;
			w = 0.075 * safezoneW;
			h = 0.018 * safezoneH;
		};
		class Factory_Slot2Object: RscStructuredText
		{
			idc = 25012;
			x = 0.720688 * safezoneW + safezoneX;
			y = 0.2668 * safezoneH + safezoneY;
			w = 0.075 * safezoneW;
			h = 0.018 * safezoneH;
		};
		class Factory_Slot2Progress: RscProgress
		{
			idc = 25013;
			x = 0.720688 * safezoneW + safezoneX;
			y = 0.2844 * safezoneH + safezoneY;
			w = 0.075 * safezoneW;
			h = 0.018 * safezoneH;
		};
		class Factory_Slot3Name: RscStructuredText
		{
			idc = 25014;
			x = 0.720688 * safezoneW + safezoneX;
			y = 0.3086 * safezoneH + safezoneY;
			w = 0.075 * safezoneW;
			h = 0.018 * safezoneH;
		};
		class Factory_Slot3Object: RscStructuredText
		{
			idc = 25015;
			x = 0.720688 * safezoneW + safezoneX;
			y = 0.3262 * safezoneH + safezoneY;
			w = 0.075 * safezoneW;
			h = 0.018 * safezoneH;
		};
		class Factory_Slot3Progress: RscProgress
		{
			idc = 25016;
			x = 0.720687 * safezoneW + safezoneX;
			y = 0.3438 * safezoneH + safezoneY;
			w = 0.075 * safezoneW;
			h = 0.018 * safezoneH;
		};
		class Factory_Slot4Name: RscStructuredText
		{
			idc = 25017;
			x = 0.720689 * safezoneW + safezoneX;
			y = 0.368 * safezoneH + safezoneY;
			w = 0.075 * safezoneW;
			h = 0.018 * safezoneH;
		};
		class Factory_Slot4Object: RscStructuredText
		{
			idc = 25018;
			x = 0.720688 * safezoneW + safezoneX;
			y = 0.3856 * safezoneH + safezoneY;
			w = 0.075 * safezoneW;
			h = 0.018 * safezoneH;
		};
		class Factory_Slot4Progress: RscProgress
		{
			idc = 25019;
			x = 0.720688 * safezoneW + safezoneX;
			y = 0.4032 * safezoneH + safezoneY;
			w = 0.075 * safezoneW;
			h = 0.018 * safezoneH;
		};
		class Factory_Slot5Name: RscStructuredText
		{
			idc = 25020;
			x = 0.720688 * safezoneW + safezoneX;
			y = 0.4274 * safezoneH + safezoneY;
			w = 0.075 * safezoneW;
			h = 0.018 * safezoneH;
		};
		class Factory_Slot5Object: RscStructuredText
		{
			idc = 25021;
			x = 0.720688 * safezoneW + safezoneX;
			y = 0.445 * safezoneH + safezoneY;
			w = 0.075 * safezoneW;
			h = 0.018 * safezoneH;
		};
		class Factory_Slot5Progress: RscProgress
		{
			idc = 25022;
			x = 0.720689 * safezoneW + safezoneX;
			y = 0.4626 * safezoneH + safezoneY;
			w = 0.075 * safezoneW;
			h = 0.018 * safezoneH;
		};
		class Factory_Slot6Name: RscStructuredText
		{
			idc = 25023;
			x = 0.720688 * safezoneW + safezoneX;
			y = 0.4868 * safezoneH + safezoneY;
			w = 0.075 * safezoneW;
			h = 0.018 * safezoneH;
		};
		class Factory_Slot6Object: RscStructuredText
		{
			idc = 25024;
			x = 0.720688 * safezoneW + safezoneX;
			y = 0.5044 * safezoneH + safezoneY;
			w = 0.075 * safezoneW;
			h = 0.018 * safezoneH;
		};
		class Factory_Slot6Progress: RscProgress
		{
			idc = 25025;
			x = 0.720688 * safezoneW + safezoneX;
			y = 0.522 * safezoneH + safezoneY;
			w = 0.075 * safezoneW;
			h = 0.018 * safezoneH;
		};
		class Factory_Slot7Name: RscStructuredText
		{
			idc = 25026;
			x = 0.720687 * safezoneW + safezoneX;
			y = 0.5462 * safezoneH + safezoneY;
			w = 0.075 * safezoneW;
			h = 0.018 * safezoneH;
		};
		class Factory_Slot7Object: RscStructuredText
		{
			idc = 25027;
			x = 0.720689 * safezoneW + safezoneX;
			y = 0.5638 * safezoneH + safezoneY;
			w = 0.075 * safezoneW;
			h = 0.018 * safezoneH;
		};
		class Factory_Slot7Progress: RscProgress
		{
			idc = 25028;
			x = 0.720688 * safezoneW + safezoneX;
			y = 0.5814 * safezoneH + safezoneY;
			w = 0.075 * safezoneW;
			h = 0.018 * safezoneH;
		};
		class Factory_Slot8Name: RscStructuredText
		{
			idc = 25029;
			x = 0.720688 * safezoneW + safezoneX;
			y = 0.6056 * safezoneH + safezoneY;
			w = 0.075 * safezoneW;
			h = 0.018 * safezoneH;
		};
		class Factory_Slot8Object: RscStructuredText
		{
			idc = 25030;
			x = 0.720688 * safezoneW + safezoneX;
			y = 0.6232 * safezoneH + safezoneY;
			w = 0.075 * safezoneW;
			h = 0.018 * safezoneH;
		};
		class Factory_Slot8Progress: RscProgress
		{
			idc = 25031;
			x = 0.720689 * safezoneW + safezoneX;
			y = 0.6408 * safezoneH + safezoneY;
			w = 0.075 * safezoneW;
			h = 0.018 * safezoneH;
		};
		class Factory_AmountToProduce: RscEdit
		{
			idc = 25032;
			x = 0.720688 * safezoneW + safezoneX;
			y = 0.712 * safezoneH + safezoneY;
			w = 0.075 * safezoneW;
			h = 0.0205 * safezoneH;
		};
		class Factory_StartStopButton: RscButtonEmpty
		{
			idc = 25033;
			x = 0.7199 * safezoneW + safezoneX;
			y = 0.7376 * safezoneH + safezoneY;
			w = 0.0753 * safezoneW;
			h = 0.033 * safezoneH;
		};

		////////////////////////////////////////////////////////
		//                   STORAGE PAGE                     //
		////////////////////////////////////////////////////////
		
		// LEFT SIDE
		class Storage_FactoryStorage: RscListbox
		{
			idc = 26002;
			x = 0.2139 * safezoneW + safezoneX;
			y = 0.188 * safezoneH + safezoneY;
			w = 0.1585 * safezoneW;
			h = 0.50325 * safezoneH;
		};
		class Storage_AmountToMove1: RscEdit
		{
			idc = 26003;
			x = 0.255 * safezoneW + safezoneX;
			y = 0.7134 * safezoneH + safezoneY;
			w = 0.0765 * safezoneW;
			h = 0.0185 * safezoneH;
		};
		class Storage_MoveToInventory: RscButtonEmpty
		{
			idc = 26004;
			x = 0.254563 * safezoneW + safezoneX;
			y = 0.739 * safezoneH + safezoneY;
			w = 0.077 * safezoneW;
			h = 0.0328 * safezoneH;
		};

		// CENTER
		class Storage_Preview: RscPicture
		{
			idc = 26005;
			text = "#(argb,8,8,3)color(1,1,1,1)";
			x = 0.388624 * safezoneW + safezoneX;
			y = 0.176 * safezoneH + safezoneY;
			w = 0.223 * safezoneW;
			h = 0.599 * safezoneH;
		};

		// RIGHT SIDE
		class Storage_MyStorage: RscListbox
		{
			idc = 26006;
			x = 0.627874 * safezoneW + safezoneX;
			y = 0.188 * safezoneH + safezoneY;
			w = 0.1585 * safezoneW;
			h = 0.50325 * safezoneH;
		};
		class Storage_AmountToMove2: RscEdit
		{
			idc = 26007;
			x = 0.669126 * safezoneW + safezoneX;
			y = 0.7134 * safezoneH + safezoneY;
			w = 0.0765 * safezoneW;
			h = 0.0185 * safezoneH;
		};
		
		class Storage_MoveToFactory: RscButtonEmpty
		{
			idc = 26008;
			x = 0.6685 * safezoneW + safezoneX;
			y = 0.739 * safezoneH + safezoneY;
			w = 0.077 * safezoneW;
			h = 0.0328 * safezoneH;
		};

		////////////////////////////////////////////////////////
		//                   UPGRADES PAGE                    //
		////////////////////////////////////////////////////////
		
		// LEFT SIDE
		class Upgrades_MyUpgrades: RscTree
		{
			idc = 27002;
			type = 12;
			x = 0.2139 * safezoneW + safezoneX;
			y = 0.1884 * safezoneH + safezoneY;
			w = 0.19 * safezoneW;
			h = 0.516 * safezoneH;
			style = 16;
			colorBackground[] = {0.1, 0.1, 0.1, 0.6};
			colorSelect[] = {0.176, 0.164, 0.164, 0.8};
			colorText[] = {1, 1, 1, 1};
			colorSelectText[] = {1, 1, 1, 1};
			colorBorder[] = {0, 0, 0, 0};
			colorSearch[] = {0.13, 0.54, 0.21, 0.8};
			colorMarked[] = {0.2, 0.3, 0.7, 1};
			colorMarkedText[] = {1, 1, 1, 1};
			colorMarkedSelected[] = {0, 0.5, 0.5, 1};
			colorPicture[] = {1, 1, 1, 1};
			colorPictureSelected[] = {1, 1, 1, 1};
			colorPictureDisabled[] = {1, 1, 1, 0.25};
			colorPictureRight[] = {1, 1, 1, 1};
			colorPictureRightSelected[] = {1, 1, 1, 1};
			colorPictureRightDisabled[] = {1, 1, 1, 0.25};
			colorArrow[] = {1, 1, 1, 1};
			soundSelect[] = {"", 0.1, 1};
			soundExpand[] = {"", 0.1, 1};
			soundCollapse[] = {"", 0.1, 1};
			multiselectEnabled = 0;
			maxHistoryDelay = 1;
			shadow = 0;
			font = "RobotoCondensed";
			expandedTexture = "A3\ui_f\data\gui\rsccommon\rsctree\expandedTexture_ca.paa";
			hiddenTexture = "A3\ui_f\data\gui\rsccommon\rsctree\hiddenTexture_ca.paa";
			rowHeight = 0.04;
			colorSelectBackground[] = {0, 0, 0, 0.5};
			colorLines[] = {0, 0, 0, 0};
			borderSize = 0;
			expandOnDoubleclick = 1;
			class ScrollBar
			{
				color[] = {1, 1, 1, 1};
				thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
				arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
				arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
				border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
			};
		};
		class Upgrades_CurrentEfficiency: RscStructuredText
		{
			idc = 27003;
			x = 0.213313 * safezoneW + safezoneX;
			y = 0.726 * safezoneH + safezoneY;
			w = 0.19145 * safezoneW;
			h = 0.038 * safezoneH;
		};

		class Upgrades_AvailableUpgrades: RscTree
		{
			idc = 27004;
			type = 12;
			x = 0.409499 * safezoneW + safezoneX;
			y = 0.1884 * safezoneH + safezoneY;
			w = 0.19 * safezoneW;
			h = 0.444 * safezoneH;
			style = 16;
			colorBackground[] = {0.1, 0.1, 0.1, 0.6};
			colorSelect[] = {0.176, 0.164, 0.164, 0.8};
			colorText[] = {1, 1, 1, 1};
			colorSelectText[] = {1, 1, 1, 1};
			colorBorder[] = {0, 0, 0, 0};
			colorSearch[] = {0.13, 0.54, 0.21, 0.8};
			colorMarked[] = {0.2, 0.3, 0.7, 1};
			colorMarkedText[] = {1, 1, 1, 1};
			colorMarkedSelected[] = {0, 0.5, 0.5, 1};
			colorPicture[] = {1, 1, 1, 1};
			colorPictureSelected[] = {1, 1, 1, 1};
			colorPictureDisabled[] = {1, 1, 1, 0.25};
			colorPictureRight[] = {1, 1, 1, 1};
			colorPictureRightSelected[] = {1, 1, 1, 1};
			colorPictureRightDisabled[] = {1, 1, 1, 0.25};
			colorArrow[] = {1, 1, 1, 1};
			soundSelect[] = {"", 0.1, 1};
			soundExpand[] = {"", 0.1, 1};
			soundCollapse[] = {"", 0.1, 1};
			multiselectEnabled = 0;
			maxHistoryDelay = 1;
			shadow = 0;
			font = "RobotoCondensed";
			expandedTexture = "A3\ui_f\data\gui\rsccommon\rsctree\expandedTexture_ca.paa";
			hiddenTexture = "A3\ui_f\data\gui\rsccommon\rsctree\hiddenTexture_ca.paa";
			rowHeight = 0.04;
			colorSelectBackground[] = {0, 0, 0, 0.5};
			colorLines[] = {0, 0, 0, 0};
			borderSize = 0;
			expandOnDoubleclick = 1;
			class ScrollBar
			{
				color[] = {1, 1, 1, 1};
				thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
				arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
				arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
				border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
			};
		};
		class Upgrades_Description: RscStructuredText
		{
			idc = 27005;
			x = 0.409 * safezoneW + safezoneX;
			y = 0.655 * safezoneH + safezoneY;
			w = 0.19145 * safezoneW;
			h = 0.0378 * safezoneH;
		};
		class Upgrades_UpgradePrice: RscStructuredText
		{
			idc = 27006;
			x = 0.465968 * safezoneW + safezoneX;
			y = 0.7138 * safezoneH + safezoneY;
			w = 0.0765 * safezoneW;
			h = 0.018 * safezoneH;
		};
		class Upgrades_BuyUpgradeButton: RscButtonEmpty
		{
			idc = 27007;
			x = 0.4655 * safezoneW + safezoneX;
			y = 0.739 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.0325 * safezoneH;
		};

		// RIGHT SIDE
		class Upgrades_Slot1Name: RscStructuredText
		{
			idc = 27008;
			x = 0.628 * safezoneW + safezoneX;
			y = 0.19 * safezoneH + safezoneY;
			w = 0.159 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class Upgrades_Slot1Status: RscStructuredText
		{
			idc = 27009;
			x = 0.627875 * safezoneW + safezoneX;
			y = 0.2118 * safezoneH + safezoneY;
			w = 0.159 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class Upgrades_Slot2Name: RscStructuredText
		{
			idc = 27010;
			x = 0.627876 * safezoneW + safezoneX;
			y = 0.2536 * safezoneH + safezoneY;
			w = 0.159 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class Upgrades_Slot2Status: RscStructuredText
		{
			idc = 27011;
			x = 0.627876 * safezoneW + safezoneX;
			y = 0.2756 * safezoneH + safezoneY;
			w = 0.159 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class Upgrades_Slot3Name: RscStructuredText
		{
			idc = 27012;
			x = 0.627875 * safezoneW + safezoneX;
			y = 0.3196 * safezoneH + safezoneY;
			w = 0.159 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class Upgrades_Slot3Status: RscStructuredText
		{
			idc = 27013;
			x = 0.627878 * safezoneW + safezoneX;
			y = 0.3416 * safezoneH + safezoneY;
			w = 0.159 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class Upgrades_Slot4Name: RscStructuredText
		{
			idc = 27014;
			x = 0.627875 * safezoneW + safezoneX;
			y = 0.3856 * safezoneH + safezoneY;
			w = 0.159 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class Upgrades_Slot4Status: RscStructuredText
		{
			idc = 27015;
			x = 0.627876 * safezoneW + safezoneX;
			y = 0.4076 * safezoneH + safezoneY;
			w = 0.159 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class Upgrades_Slot5Name: RscStructuredText
		{
			idc = 27016;
			x = 0.627876 * safezoneW + safezoneX;
			y = 0.4516 * safezoneH + safezoneY;
			w = 0.159 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class Upgrades_Slot5Status: RscStructuredText
		{
			idc = 27017;
			x = 0.627875 * safezoneW + safezoneX;
			y = 0.4736 * safezoneH + safezoneY;
			w = 0.159 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class Upgrades_Slot6Name: RscStructuredText
		{
			idc = 27018;
			x = 0.627875 * safezoneW + safezoneX;
			y = 0.5154 * safezoneH + safezoneY;
			w = 0.159 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class Upgrades_Slot6Status: RscStructuredText
		{
			idc = 27019;
			x = 0.627878 * safezoneW + safezoneX;
			y = 0.5374 * safezoneH + safezoneY;
			w = 0.159 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class Upgrades_Slot7Name: RscStructuredText
		{
			idc = 27020;
			x = 0.627874 * safezoneW + safezoneX;
			y = 0.5792 * safezoneH + safezoneY;
			w = 0.159 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class Upgrades_Slot7Status: RscStructuredText
		{
			idc = 27021;
			x = 0.627878 * safezoneW + safezoneX;
			y = 0.6012 * safezoneH + safezoneY;
			w = 0.159 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class Upgrades_Slot8Name: RscStructuredText
		{
			idc = 27022;
			x = 0.627875 * safezoneW + safezoneX;
			y = 0.643 * safezoneH + safezoneY;
			w = 0.159 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class Upgrades_Slot8Status: RscStructuredText
		{
			idc = 27023;
			x = 0.627876 * safezoneW + safezoneX;
			y = 0.665 * safezoneH + safezoneY;
			w = 0.159 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class Upgrades_SlotPrice: RscStructuredText
		{
			idc = 27024;
			x = 0.669038 * safezoneW + safezoneX;
			y = 0.7138 * safezoneH + safezoneY;
			w = 0.0765 * safezoneW;
			h = 0.018 * safezoneH;
		};	
		class Upgrades_BuySlotButton: RscButtonEmpty
		{
			idc = 27025;
			x = 0.669 * safezoneW + safezoneX;
			y = 0.739 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.0325 * safezoneH;
		};

		////////////////////////////////////////////////////////
		//                    CRAFTS PAGE                     //
		////////////////////////////////////////////////////////

		// LEFT SIDE
		class Crafts_MyCrafts: RscTree
		{
			idc = 28002;
			type = 12;
			x = 0.214 * safezoneW + safezoneX;
			y = 0.188 * safezoneH + safezoneY;
			w = 0.1585 * safezoneW;
			h = 0.57455 * safezoneH;
			style = 16;
			colorBackground[] = {0.1, 0.1, 0.1, 0.6};
			colorSelect[] = {0.176, 0.164, 0.164, 0.8};
			colorText[] = {1, 1, 1, 1};
			colorSelectText[] = {1, 1, 1, 1};
			colorBorder[] = {0, 0, 0, 0};
			colorSearch[] = {0.13, 0.54, 0.21, 0.8};
			colorMarked[] = {0.2, 0.3, 0.7, 1};
			colorMarkedText[] = {1, 1, 1, 1};
			colorMarkedSelected[] = {0, 0.5, 0.5, 1};
			colorPicture[] = {1, 1, 1, 1};
			colorPictureSelected[] = {1, 1, 1, 1};
			colorPictureDisabled[] = {1, 1, 1, 0.25};
			colorPictureRight[] = {1, 1, 1, 1};
			colorPictureRightSelected[] = {1, 1, 1, 1};
			colorPictureRightDisabled[] = {1, 1, 1, 0.25};
			colorArrow[] = {1, 1, 1, 1};
			soundSelect[] = {"", 0.1, 1};
			soundExpand[] = {"", 0.1, 1};
			soundCollapse[] = {"", 0.1, 1};
			multiselectEnabled = 0;
			maxHistoryDelay = 1;
			shadow = 0;
			font = "RobotoCondensed";
			expandedTexture = "A3\ui_f\data\gui\rsccommon\rsctree\expandedTexture_ca.paa";
			hiddenTexture = "A3\ui_f\data\gui\rsccommon\rsctree\hiddenTexture_ca.paa";
			rowHeight = 0.04;
			colorSelectBackground[] = {0, 0, 0, 0.5};
			colorLines[] = {0, 0, 0, 0};
			borderSize = 0;
			expandOnDoubleclick = 1;
			class ScrollBar
			{
				color[] = {1, 1, 1, 1};
				thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
				arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
				arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
				border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
			};
		};

		// CENTER
		class Crafts_Preview: RscPicture
		{
			idc = 28003;
			text = "#(argb,8,8,3)color(1,1,1,1)";
			x = 0.388624 * safezoneW + safezoneX;
			y = 0.1766 * safezoneH + safezoneY;
			w = 0.2235 * safezoneW;
			h = 0.598 * safezoneH;
		};

		// RIGHT SIDE
		class Crafts_AvailableCrafts: RscTree
		{
			idc = 28004;
			type = 12;
			x = 0.627876 * safezoneW + safezoneX;
			y = 0.1883 * safezoneH + safezoneY;
			w = 0.1585 * safezoneW;
			h = 0.5035 * safezoneH;
			style = 16;
			colorBackground[] = {0.1, 0.1, 0.1, 0.6};
			colorSelect[] = {0.176, 0.164, 0.164, 0.8};
			colorText[] = {1, 1, 1, 1};
			colorSelectText[] = {1, 1, 1, 1};
			colorBorder[] = {0, 0, 0, 0};
			colorSearch[] = {0.13, 0.54, 0.21, 0.8};
			colorMarked[] = {0.2, 0.3, 0.7, 1};
			colorMarkedText[] = {1, 1, 1, 1};
			colorMarkedSelected[] = {0, 0.5, 0.5, 1};
			colorPicture[] = {1, 1, 1, 1};
			colorPictureSelected[] = {1, 1, 1, 1};
			colorPictureDisabled[] = {1, 1, 1, 0.25};
			colorPictureRight[] = {1, 1, 1, 1};
			colorPictureRightSelected[] = {1, 1, 1, 1};
			colorPictureRightDisabled[] = {1, 1, 1, 0.25};
			colorArrow[] = {1, 1, 1, 1};
			soundSelect[] = {"", 0.1, 1};
			soundExpand[] = {"", 0.1, 1};
			soundCollapse[] = {"", 0.1, 1};
			multiselectEnabled = 0;
			maxHistoryDelay = 1;
			shadow = 0;
			font = "RobotoCondensed";
			expandedTexture = "A3\ui_f\data\gui\rsccommon\rsctree\expandedTexture_ca.paa";
			hiddenTexture = "A3\ui_f\data\gui\rsccommon\rsctree\hiddenTexture_ca.paa";
			rowHeight = 0.04;
			colorSelectBackground[] = {0, 0, 0, 0.5};
			colorLines[] = {0, 0, 0, 0};
			borderSize = 0;
			expandOnDoubleclick = 1;
			class ScrollBar
			{
				color[] = {1, 1, 1, 1};
				thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
				arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
				arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
				border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
			};
		};
		class Crafts_Price: RscStructuredText
		{
			idc = 28005;
			x = 0.669126 * safezoneW + safezoneX;
			y = 0.7134 * safezoneH + safezoneY;
			w = 0.0768 * safezoneW;
			h = 0.0185 * safezoneH;
		};
		class Crafts_BuyButton: RscButtonEmpty
		{
			idc = 28006;
			x = 0.669 * safezoneW + safezoneX;
			y = 0.739 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.0325 * safezoneH;
		};

		////////////////////////////////////////////////////////
		//                     SHARE PAGE                     //
		////////////////////////////////////////////////////////

		// LEFT SIDE
		class Share_MyCrafts: RscTree
		{
			idc = 29002;
			type = 12;
			x = 0.214 * safezoneW + safezoneX;
			y = 0.188 * safezoneH + safezoneY;
			w = 0.1585 * safezoneW;
			h = 0.57455 * safezoneH;
			style = 16;
			colorBackground[] = {0.1, 0.1, 0.1, 0.6};
			colorSelect[] = {0.176, 0.164, 0.164, 0.8};
			colorText[] = {1, 1, 1, 1};
			colorSelectText[] = {1, 1, 1, 1};
			colorBorder[] = {0, 0, 0, 0};
			colorSearch[] = {0.13, 0.54, 0.21, 0.8};
			colorMarked[] = {0.2, 0.3, 0.7, 1};
			colorMarkedText[] = {1, 1, 1, 1};
			colorMarkedSelected[] = {0, 0.5, 0.5, 1};
			colorPicture[] = {1, 1, 1, 1};
			colorPictureSelected[] = {1, 1, 1, 1};
			colorPictureDisabled[] = {1, 1, 1, 0.25};
			colorPictureRight[] = {1, 1, 1, 1};
			colorPictureRightSelected[] = {1, 1, 1, 1};
			colorPictureRightDisabled[] = {1, 1, 1, 0.25};
			colorArrow[] = {1, 1, 1, 1};
			soundSelect[] = {"", 0.1, 1};
			soundExpand[] = {"", 0.1, 1};
			soundCollapse[] = {"", 0.1, 1};
			multiselectEnabled = 0;
			maxHistoryDelay = 1;
			shadow = 0;
			font = "RobotoCondensed";
			expandedTexture = "A3\ui_f\data\gui\rsccommon\rsctree\expandedTexture_ca.paa";
			hiddenTexture = "A3\ui_f\data\gui\rsccommon\rsctree\hiddenTexture_ca.paa";
			rowHeight = 0.04;
			colorSelectBackground[] = {0, 0, 0, 0.5};
			colorLines[] = {0, 0, 0, 0};
			borderSize = 0;
			expandOnDoubleclick = 1;
			class ScrollBar
			{
				color[] = {1, 1, 1, 1};
				thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
				arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
				arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
				border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
			};
		};

		// CENTER
		class Share_Preview: RscPicture
		{
			idc = 29003;
			text = "#(argb,8,8,3)color(1,1,1,1)";
			x = 0.388624 * safezoneW + safezoneX;
			y = 0.1766 * safezoneH + safezoneY;
			w = 0.2235 * safezoneW;
			h = 0.6 * safezoneH;
		};

		// RIGHT SIDE
		class Share_SharedPerson: RscListbox
		{
			idc = 29004;
			x = 0.6278 * safezoneW + safezoneX;
			y = 0.1876 * safezoneH + safezoneY;
			w = 0.1598 * safezoneW;
			h = 0.176 * safezoneH;
			sizeEx = 0.025;
			rowHeight = 0.03;
		};
		class Share_IDSearchBar: RscEdit
		{
			idc = 29005;
			x = 0.6275 * safezoneW + safezoneX;
			y = 0.385 * safezoneH + safezoneY;
			w = 0.159844 * safezoneW;
			h = 0.017 * safezoneH;
		};
		class Share_ResearchList: RscListbox
		{
			idc = 29012;
			x = 0.6278 * safezoneW + safezoneX;
			y = 0.423 * safezoneH + safezoneY;
			w = 0.1598 * safezoneW;
			h = 0.141 * safezoneH;
		};
		class Share_ShareButton: RscButtonEmpty
		{
			idc = 29006;
			x = 0.62786 * safezoneW + safezoneX;
			y = 0.57084 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.032 * safezoneH;
		};
		class Share_RemoveAccessButton: RscButtonEmpty
		{
			idc = 29007;
			x = 0.7098 * safezoneW + safezoneX;
			y = 0.57084 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.032 * safezoneH;
		};
		class Share_SetSubscriptionButton: RscButtonEmpty
		{
			idc = 29008;
			x = 0.62786 * safezoneW + safezoneX;
			y = 0.6365 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.0329 * safezoneH;
		};
		class Share_SetCraftPriceButton: RscButtonEmpty
		{
			idc = 29009;
			x = 0.70965 * safezoneW + safezoneX;
			y = 0.6365 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.0329 * safezoneH;
		};
		class Share_Price: RscEdit
		{
			idc = 29010;
			x = 0.669 * safezoneW + safezoneX;
			y = 0.6914 * safezoneH + safezoneY;
			w = 0.0774 * safezoneW;
			h = 0.0305 * safezoneH;
		};
		class Share_SetPriceButton: RscButtonEmpty
		{
			idc = 29011;
			x = 0.6685 * safezoneW + safezoneX;
			y = 0.73009 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.0329 * safezoneH;
		};
	};
};