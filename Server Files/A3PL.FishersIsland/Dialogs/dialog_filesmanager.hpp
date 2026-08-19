class A3PL_Computer 
{
	idd = 130900;
	onLoad = "uiNamespace setVariable ['A3PL_ComputerDisplay', _this select 0];"; 
	class ControlsBackground
	{
		class Background: RscPicture
		{
			idc = 1500;
			text = "\A3PL_Common\GUI\filesmanager\FilesMan.paa";
			x = 0.039032 * safezoneW + safezoneX;
			y = 0.000599937 * safezoneH + safezoneY;
			w = 0.922969 * safezoneW;
			h = 1.089 * safezoneH;
		};
		class BackgroundMSI: RscPicture
		{
			idc = 1501;
			text = "\A3PL_Common\GUI\filesmanager\FilesManMSI.paa";
			x = -0.0960638 * safezoneW + safezoneX;
			y = -0.3294 * safezoneH + safezoneY;
			w = 1.19109 * safezoneW;
			h = 1.694 * safezoneH;
		};
	};
	class Controls
	{
		// Logos
		class Logo: RscPicture
		{
			idc = 15803;
			text = "";
			x = 0.142155 * safezoneW + safezoneX;
			y = 0.1194 * safezoneH + safezoneY;
			w = 0.0979687 * safezoneW;
			h = 0.165 * safezoneH;
		};
		// Boutons
		class FileTreeResearch: RscEdit
		{
			idc = 130906;
			
			x = 0.109156 * safezoneW + safezoneX;
			y = 0.302 * safezoneH + safezoneY;
			w = 0.0928125 * safezoneW;
			h = 0.022 * safezoneH;
			style = 0;
			text = "STR_UI_FilesManager_Search";
			colorBackground[] = {0.423, 0.415, 0.415, 0.6};
			colorText[] = {1, 1, 1, 1};
		};
		class FileTreeView : RscTree
		{
			type = 12;
			idc = 130901;
			x = 0.109156 * safezoneW + safezoneX;
			y = 0.335 * safezoneH + safezoneY;
			w = 0.139219 * safezoneW;
			h = 0.462 * safezoneH;
			style = 16;
			colorBackground[] = {0.423, 0.415, 0.415, 0.6};
			colorDisabled[] = {0.76, 0.64, 0.164,0.8};
			colorSelect[] = {0.176, 0.164, 0.164, 0.8};
			colorText[] = {1 ,1 , 1,1};
			soundSelect[] = {"",0.1,1};
			soundExpand[] = {"",0.1,1};
			soundCollapse[] = {"",0.1,1};
			onTreeSelChanged = "[] spawn A3PL_FilesManager_showData;";
			canDrag = 1;
			class ListScrollBar
			{
				color[] = {1,1,1,1};
				thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
				arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
				arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
				border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
			};
			deletable = 0;
			fade = 0;
			access = 0;
			colorSelectText[] = {0,0,0,1};
			colorBorder[] = {0,0,0,0};
			colorSearch[] =
			{
				"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.13])",
				"(profilenamespace getvariable ['GUI_BCG_RGB_G',0.54])",
				"(profilenamespace getvariable ['GUI_BCG_RGB_B',0.21])",
				"(profilenamespace getvariable ['GUI_BCG_RGB_A',0.8])"
			};
			colorMarked[] = {0.2,0.3,0.7,1};
			colorMarkedText[] = {0,0,0,1};
			colorMarkedSelected[] = {0,0.5,0.5,1};
			multiselectEnabled = 0;
			colorPicture[] = {1,1,1,1};
			colorPictureSelected[] = {0,0,0,1};
			colorPictureDisabled[] = {1,1,1,0.25};
			colorPictureRight[] = {1,1,1,1};
			colorPictureRightSelected[] = {0,0,0,1};
			colorPictureRightDisabled[] = {1,1,1,0.25};
			colorArrow[] = {1,1,1,1};
			maxHistoryDelay = 1;
			shadow = 0;
			font = "RobotoCondensed";
			expandedTexture = "A3\ui_f\data\gui\rsccommon\rsctree\expandedTexture_ca.paa";
			hiddenTexture = "A3\ui_f\data\gui\rsccommon\rsctree\hiddenTexture_ca.paa";
			rowHeight = 0.0439091;
			colorSelectBackground[] = {0,0,0,0.5};
			colorLines[] = {0,0,0,0};
			borderSize = 0;
			expandOnDoubleclick = 1;
			class ScrollBar : ScrollBar
			{
			};
		};
		class FilePreviewGroup : RscControlsGroup {
			idc = 230902;
			x = 0.560844 * safezoneW + safezoneX;
			y = 0.17 * safezoneH + safezoneY;
			w = 0.319688 * safezoneW;
			h = 0.627 * safezoneH;

			class controls {
				class FilePreview : RscStructuredText {
					idc = 130902;
					x = 0;
					y = 0;
					w = 0.309688 * safezoneW;
					h = 2;
					text = "";
					colorBackground[] = {0.423, 0.415, 0.415, 0.6};
					colorText[] = {1, 1, 1, 1};
				};
			};

			class VScrollbar {
				color[] = {0.624,0.616,0.616,1.0};
				width = 0.01;
				autoScrollEnabled = 1;
				scrollSpeed = 0.1;
			};

			class HScrollbar {
				color[] = {0,0,0,0};
				height = 0;
			};
		};
		class FileInfo : RscStructuredText
		{
			idc = 130903;
			x = 0.274156 * safezoneW + safezoneX;
			y = 0.72 * safezoneH + safezoneY;
			w = 0.257813 * safezoneW;
			h = 0.077 * safezoneH;
			text = "";
			colorBackground[] = {0.423, 0.415, 0.415, 0.6};
			colorText[] = {1, 1, 1, 1};
		};
		class FileEditor : RscEditMulti
		{
			idc = 130904;
			x = 0.274156 * safezoneW + safezoneX;
			y = 0.2162 * safezoneH + safezoneY;
			w = 0.257813 * safezoneW;
			h = 0.484 * safezoneH;
			text = "";
			colorBackground[] = {0.423, 0.415, 0.415, 0.6};
			colorText[] = {1, 1, 1, 1};
			sizeEx = 0.04;
			onKeyDown = "call A3PL_FilesManager_updatePreview;";
		};
		class FileManagerLabel : RscEdit
		{
			idc = 130905;
			x = 0.274156 * safezoneW + safezoneX;
			y = 0.17 * safezoneH + safezoneY;
			w = 0.257813 * safezoneW;
			h = 0.033 * safezoneH;
			style = 0;
			text = "STR_UI_FilesManager_FileName";
			colorBackground[] = {0.423, 0.415, 0.415, 0.6};
			colorText[] = {1, 1, 1, 1};
		};
		class Search: RscButton
		{
			idc = -1;
			x = 0.204033 * safezoneW + safezoneX;
			y = 0.302 * safezoneH + safezoneY;
			w = 0.0154688 * safezoneW;
			h = 0.022 * safezoneH;
			text = "";
			colorBackground[] = {0,0,0,0};
			onButtonClick = "[] spawn A3PL_FilesManager_Search;";
		};
		class SearchImage: RscPicture
		{
			idc = -1;
			x = 0.204033 * safezoneW + safezoneX;
			y = 0.302 * safezoneH + safezoneY;
			w = 0.0154688 * safezoneW;
			h = 0.022 * safezoneH;
			text = "\A3PL_Common\GUI\filesmanager\search.paa";
		};
		class CreateNewFile : RscButton
		{
			idc = -1;
			x = 0.221562 * safezoneW + safezoneX;
			y = 0.302 * safezoneH + safezoneY;
			w = 0.0154688 * safezoneW;
			h = 0.022 * safezoneH;
			text = "";
			colorBackground[] = {0,0,0,0};
			onButtonClick = "[] spawn A3PL_FilesManager_createFile;";
		};
		class CreateNewFileImage : RscPicture
		{
			idc = -1;
			x = 0.221562 * safezoneW + safezoneX;
			y = 0.302 * safezoneH + safezoneY;
			w = 0.0154688 * safezoneW;
			h = 0.022 * safezoneH;
			text = "\A3PL_Common\GUI\filesmanager\newFile.paa";
		};
		class CreateNewFolder : RscButton
		{
			idc = -1;
			x = 0.241156 * safezoneW + safezoneX;
			y = 0.302 * safezoneH + safezoneY;
			w = 0.0154688 * safezoneW;
			h = 0.022 * safezoneH;
			text = "";
			colorBackground[] = {0,0,0,0};
			onButtonClick = "[] spawn A3PL_FilesManager_createFolder;";
		};
		class CreateNewFolderImage : RscPicture
		{
			idc = -1;
			x = 0.241156 * safezoneW + safezoneX;
			y = 0.302 * safezoneH + safezoneY;
			w = 0.0154688 * safezoneW;
			h = 0.022 * safezoneH;
			text = "\A3PL_Common\GUI\filesmanager\newFolder.paa";
		};
		class SaveFile : RscButton
		{
			idc = -1;
			x = 0.272095 * safezoneW + safezoneX;
			y = 0.1436 * safezoneH + safezoneY;
			w = 0.0154688 * safezoneW;
			h = 0.022 * safezoneH;
			text = "";
			colorBackground[] = {0,0,0,0};
			onButtonClick = "[] spawn A3PL_FilesManager_saveFile;";
		};
		class SaveFileImage : RscPicture
		{
			idc = -1;
			x = 0.272095 * safezoneW + safezoneX;
			y = 0.1436 * safezoneH + safezoneY;
			w = 0.0154688 * safezoneW;
			h = 0.022 * safezoneH;
			text = "\A3PL_Common\GUI\filesmanager\save.paa";
		};
		class Lock : RscButton
		{
			idc = -1;
			x = 0.500988 * safezoneW + safezoneX;
			y = 0.1436 * safezoneH + safezoneY;
			w = 0.0154688 * safezoneW;
			h = 0.022 * safezoneH;
			text = "";
			colorBackground[] = {0,0,0,0};
			onButtonClick = "[] spawn A3PL_FilesManager_statusFile;";
		};
		class LockImage: RscPicture
		{
			idc = -1;
			text = "\A3PL_Common\GUI\filesmanager\lock.paa";
			x = 0.500988 * safezoneW + safezoneX;
			y = 0.1436 * safezoneH + safezoneY;
			w = 0.0154688 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class Delete : RscButton
		{
			idc = -1;
			x = 0.517483 * safezoneW + safezoneX;
			y = 0.1436 * safezoneH + safezoneY;
			w = 0.0154688 * safezoneW;
			h = 0.022 * safezoneH;
			text = "";
			colorBackground[] = {0,0,0,0};
			onButtonClick = "[] spawn A3PL_FilesManager_Delete;";
		};
		class DeleteImage: RscPicture
		{
			idc = -1;
			text = "\A3PL_Common\GUI\filesmanager\delete.paa";
			x = 0.517483 * safezoneW + safezoneX;
			y = 0.1436 * safezoneH + safezoneY;
			w = 0.0154688 * safezoneW;
			h = 0.022 * safezoneH;
		};
	};
};

