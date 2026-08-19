class Dialog_DeveloperDebug {
	idd = 155;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "[_this] spawn A3FL_Debug_Init";
	onUnload = "";
	class ControlsBackground {
		class DebugTitle {
			type = 0;
			idc = -1;
			x = safeZoneX + safeZoneW * 0.30375;
			y = safeZoneY + safeZoneH * 0.07777778;
			w = safeZoneW * 0.3925;
			h = safeZoneH * 0.03;
			style = 0;
			text = "STR_UI_DeveloperDebug_Title";
			colorBackground[] = { 0.827, 0.322, 0.153 };
			colorText[] = { 1, 1, 1, 1 };
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
		};
		class DebugBackground {
			type = 0;
			idc = -1;
			x = safeZoneX + safeZoneW * 0.30375;
			y = safeZoneY + safeZoneH * 0.10777778;
			w = safeZoneW * 0.3925;
			h = safeZoneH * 0.48;
			style = 0;
			text = "";
			colorBackground[] = { 0.03, 0.03, 0.03, 0.7 };
			colorText[] = { 0.3216, 0.102, 0.5569, 1 };
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
		};
		class WatchTitle : DebugTitle {
			x = safeZoneX + safeZoneW * 0.30375;
			y = safeZoneY + safeZoneH * 0.59777778;
			h = safeZoneH * 0.03;
			text = "STR_UI_DeveloperDebug_Watch";
		};
		class WatchBackground : DebugBackground {
			x = safeZoneX + safeZoneW * 0.30375;
			y = safeZoneY + safeZoneH * 0.62777778;
			h = safeZoneH * 0.24555556;
		};
		class InfoTitle : DebugTitle {
			x = safeZoneX + safeZoneW * 0.02875;
			y = safeZoneY + safeZoneH * 0.03555556;
			w = safeZoneW * 0.1675;
			h = safeZoneH * 0.03;
			text = "STR_UI_DeveloperDebug_Info";
		};
		class InfoBackground : DebugBackground {
			x = safeZoneX + safeZoneW * 0.02875;
			y = safeZoneY + safeZoneH * 0.06555556;
			w = safeZoneW * 0.1675;
			h = safeZoneH * 0.24555556;
		};
	};
	class Controls {
		class Debug {
			type = 2;
			idc = 51;
			x = safeZoneX + safeZoneW * 0.31375;
			y = safeZoneY + safeZoneH * 0.18777778;
			w = safeZoneW * 0.3725;
			h = safeZoneH * 0.29;
			style = 16;
			text = "";
			autocomplete = "scripting";
			colorBackground[] = { 0, 0, 0, 0 };
			colorDisabled[] = { 0.2, 0.2, 0.2, 1 };
			colorSelection[] = { 1, 0, 0, 1 };
			colorText[] = { 0.902, 0.902, 0.902, 1 };
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
		};
		class DebugReturn {
			type = 2;
			idc = 52;
			x = safeZoneX + safeZoneW * 0.31375;
			y = safeZoneY + safeZoneH * 0.48777778;
			w = safeZoneW * 0.3725;
			h = safeZoneH * 0.03;
			style = 0;
			canModify = 0;
			text = "";
			autocomplete = "";
			colorBackground[] = { 0, 0, 0, 1 };
			colorDisabled[] = { 0.2, 0.2, 0.2, 1 };
			colorSelection[] = { 1, 0, 0, 1 };
			colorText[] = { 0.8, 0.8, 0.8, 1 };
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
		};
		class ExecLocal {
			type = 16;
			idc = -1;
			x = safeZoneX + safeZoneW * 0.60375;
			y = safeZoneY + safeZoneH * 0.52777778;
			w = safeZoneW * 0.0825;
			h = safeZoneH * 0.04;
			style = 2;
			text = "STR_UI_DeveloperDebug_LocalExec";
			action = "[] call A3FL_Debug_Exec;";
			animTextureDefault = "#(argb,8,8,3)color(1,1,1,1)";
			animTextureDisabled = "#(argb,8,8,3)color(0.2,0.2,0.2,1)";
			animTextureFocused = "#(argb,8,8,3)color(1,1,1,1)";
			animTextureNormal = "#(argb,8,8,3)color(1,1,1,1)";
			animTextureOver = "#(argb,8,8,3)color(1,1,1,1)";
			animTexturePressed = "#(argb,8,8,3)color(1,1,1,1)";
			color[] = { 1, 1, 1, 1 };
			color2[] = { 1, 1, 1, 1 };
			colorBackground[] = { 0.827, 0.322, 0.153 };
			colorBackground2[] = { 0.702, 0.302, 0.102, 1 };
			colorBackgroundFocused[] = { 0.702, 0.302, 0.102, 1 };
			colorDisabled[] = { 0.3294, 0.2287, 0.1783, 1 };
			colorFocused[] = { 1, 1, 0.302, 1 };
			font = "PuristaMedium";
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			soundClick[] = { "\A3\ui_f\data\sound\RscButtonMenu\soundClick", 0.09, 1.0 };
			soundEnter[] = { "\A3\ui_f\data\sound\RscButtonMenu\soundEnter", 0.09, 1.0 };
			soundEscape[] = { "\A3\ui_f\data\sound\RscButtonMenu\soundEscape", 0.09, 1.0 };
			soundPush[] = { "\A3\ui_f\data\sound\RscButtonMenu\soundPush", 0.09, 1.0 };
			textureNoShortcut = "";
			class HitZone {
				top = 0;
				right = 0;
				bottom = 0;
				left = 0;
			};
			class ShortcutPos {
				top = 0;
				left = 0;
				w = 0;
				h = 0;
			};
			class TextPos {
				top = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) - (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)) / 2;
				right = 0.005;
				bottom = 0;
				left = 0.25 * (((safezoneW / safezoneH) min 1.2) / 40);
			};
		};
		class ExecServer : ExecLocal {
			idc = -1;
			x = safeZoneX + safeZoneW * 0.31375;
			w = safeZoneW * 0.0825;
			text = "STR_UI_DeveloperDebug_ServerExec";
			action = "['server'] call A3FL_Debug_Exec;";
		};
		class ExecGlobal : ExecLocal {
			idc = -1;
			x = safeZoneX + safeZoneW * 0.40375;
			w = safeZoneW * 0.0925;
			text = "STR_UI_DeveloperDebug_GlobalExec";
			action = "['global'] call A3FL_Debug_Exec;";
		};
		class ExecClients : ExecLocal {
			idc = -1;
			x = safeZoneX + safeZoneW * 0.50375;
			w = safeZoneW * 0.0925;
			text = "STR_UI_DeveloperDebug_ClientExec";
			action = "['clients'] call A3FL_Debug_Exec;";
		};
		class PrevStatement : ExecLocal {
			idc = 141;
			x = safeZoneX + safeZoneW * 0.31375;
			y = safeZoneY + safeZoneH * 0.12777778;
			w = safeZoneW * 0.1225;
			text = "STR_UI_DeveloperDebug_Previous";
			action = "";
		};
		class NextStatement : PrevStatement {
			idc = 142;
			x = safeZoneX + safeZoneW * 0.56375;
			text = "STR_UI_DeveloperDebug_Next";
			action = "";
		};
		class Clear : PrevStatement {
			idc = 160;
			x = safeZoneX + safeZoneW * 0.44375;
			w = safeZoneW * 0.1125;
			text = "STR_UI_DeveloperDebug_Clear";
			action = "";
		};
		class Watch1 : Debug {
			idc = 11;
			x = safeZoneX + safeZoneW * 0.31375;
			y = safeZoneY + safeZoneH * 0.63777778;
			w = safeZoneW * 0.3725;
			h = safeZoneH * 0.03;
		};
		class Watch2 : Watch1 {
			idc = 12;
			x = safeZoneX + safeZoneW * 0.31375;
			y = safeZoneY + safeZoneH * 0.71111112;
			w = safeZoneW * 0.3725;
			h = safeZoneH * 0.03;
		};
		class Watch3 : Watch1 {
			idc = 13;
			x = safeZoneX + safeZoneW * 0.31375;
			y = safeZoneY + safeZoneH * 0.78444445;
			w = safeZoneW * 0.3725;
			h = safeZoneH * 0.03;
		};
		class WatchReturn1 : DebugReturn {
			idc = 21;
			x = safeZoneX + safeZoneW * 0.31375;
			y = safeZoneY + safeZoneH * 0.67777778;
			w = safeZoneW * 0.3725;
			h = safeZoneH * 0.03;
		};
		class WatchReturn2 : WatchReturn1 {
			idc = 22;
			x = safeZoneX + safeZoneW * 0.31375;
			y = safeZoneY + safeZoneH * 0.75111112;
			w = safeZoneW * 0.3725;
			h = safeZoneH * 0.03;
		};
		class WatchReturn3 : WatchReturn1 {
			idc = 23;
			x = safeZoneX + safeZoneW * 0.31375;
			y = safeZoneY + safeZoneH * 0.82444445;
			w = safeZoneW * 0.3725;
			h = safeZoneH * 0.03;
		};
		class Info {
			type = 13;
			idc = 34;
			x = safeZoneX + safeZoneW * 0.03375;
			y = safeZoneY + safeZoneH * 0.07555556;
			w = safeZoneW * 0.1575;
			h = safeZoneH * 0.22777778;
			style = 0;
			text = "STR_UI_DeveloperDebug_InfoLine";
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			colorBackground[] = { 1, 1, 1, 0 };
			class Attributes {};
		};
	};
};
