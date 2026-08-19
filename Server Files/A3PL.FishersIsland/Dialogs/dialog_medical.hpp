class Dialog_Medical
{
	idd = 73;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "";
	onUnload = "";
	class controls
	{
		class static_bg: RscPicture
		{
			idc = 1200;
			text = "\A3PL_Common\GUI\medical\dialog_medical.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class static_manbase: RscPicture
		{
			idc = 1201;
			text = "\A3PL_Common\GUI\medical\man_base.paa";
			x = 0.341092 * safezoneW + safezoneX;
			y = 0.291667 * safezoneH + safezoneY;
			w = 0.28875 * safezoneW;
			h = 0.495 * safezoneH;
		};
		class lb_log: RscListbox
		{
			idc = 1500;
			x = 0.184375 * safezoneW + safezoneX;
			y = 0.44537 * safezoneH + safezoneY;
			w = 0.20625 * safezoneW;
			h = 0.308 * safezoneH;
			sizeEx = "0.015 * safezoneH";
		};
		class lb_injuries: RscListbox
		{
			idc = 1501;
			x = 0.575 * safezoneW + safezoneX;
			y = 0.352778 * safezoneH + safezoneY;
			w = 0.211406 * safezoneW;
			h = 0.176 * safezoneH;
		};
		class lb_treatments: RscListbox
		{
			idc = 1502;
			x = 0.57552 * safezoneW + safezoneX;
			y = 0.582408 * safezoneH + safezoneY;
			w = 0.211406 * safezoneW;
			h = 0.176 * safezoneH;
			onLBDblClick = "call A3PL_Medical_TreatWoundButton;";
		};
		class struc_patient: RscStructuredText
		{
			idc = 1100;
			text = "STR_UI_Medical_Patient";
			x = 0.242187  * safezoneW + safezoneX;
			y = 0.224999 * safezoneH + safezoneY;
			w = 0.149531 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class struc_heart: RscStructuredText
		{
			idc = 1101;
			text = "STR_UI_Medical_Heart"; 
			x = 0.260417 * safezoneW + safezoneX;
			y = 0.308334  * safezoneH + safezoneY;
			w = 0.0721875  * safezoneW;
			h = 0.022 * safezoneH;
		};
		class struc_blood: RscStructuredText
		{
			idc = 1102;
			text = "STR_UI_Medical_Blood"; 
			x = 0.242708 * safezoneW + safezoneX;
			y = 0.273149 * safezoneH + safezoneY;
			w = 0.0721875 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class struc_bloodlvl: RscStructuredText
		{
			idc = 1103;
			text = "&lt;t size=&apos;1&apos; align=&apos;center&apos; font=&apos;PuristaSemiBold&apos;&gt;N/A&lt;/t&gt;"; 
			x = 0.251562 * safezoneW + safezoneX;
			y = 0.340741 * safezoneH + safezoneY;
			w = 0.0721875 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class struc_part: RscStructuredText
		{
			idc = 1104;
			text = "&lt;t size=&apos;1&apos; align=&apos;center&apos;&gt;Left lower arm&lt;/t&gt;";
			x = 0.635417  * safezoneW + safezoneX;
			y = 0.266667 * safezoneH + safezoneY;
			w = 0.149531 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class button_clear: RscButtonEmpty
		{
			idc = 1600;
			x = 0.347396 * safezoneW + safezoneX;
			y = 0.779629 * safezoneH + safezoneY;
			w = 0.128906 * safezoneW;
			h = 0.055 * safezoneH;
			action = "[] call A3PL_Medical_ClearLog;";
		};
		class button_treat: RscButtonEmpty
		{
			idc = 1601;
			x = 0.482812 * safezoneW + safezoneX;
			y = 0.779629 * safezoneH + safezoneY;
			w = 0.128906 * safezoneW;
			h = 0.055 * safezoneH;
			action = "call A3PL_Medical_TreatWoundButton;";
		};
		class button_close: RscButtonEmpty
		{
			idc = 1600;
			x = 0.770833  * safezoneW + safezoneX;
			y = 0.153704 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.055 * safezoneH;
			action = "closeDialog 0;";
		};
		class button_head: RscButtonEmpty
		{
			idc = 1602;
			x = 0.477084 * safezoneW + safezoneX;
			y = 0.364592 * safezoneH + safezoneY;
			w = 0.0154688 * safezoneW;
			h = 0.033 * safezoneH;
			tooltip = "STR_UI_Medical_Head";
			action = "['head'] call A3PL_Medical_SelectPart;";
		};
		class button_spine1: RscButtonEmpty
		{
			idc = 1603;
			x = 0.464583 * safezoneW + safezoneX;
			y = 0.417593 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.044 * safezoneH;
			tooltip = "STR_UI_Medical_Chest";
			action = "['chest'] call A3PL_Medical_SelectPart;";
		};
		class button_spine2: RscButtonEmpty
		{
			idc = 1604;
			x = 0.465624 * safezoneW + safezoneX;
			y = 0.463889 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.044 * safezoneH;
			tooltip = "STR_UI_Medical_Torso";
			action = "['torso'] call A3PL_Medical_SelectPart;";
		};
		class button_spine3: RscButtonEmpty
		{
			idc = 1605;
			x = 0.464583 * safezoneW + safezoneX;
			y = 0.511111 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.044 * safezoneH;
			tooltip = "STR_UI_Medical_Pelvis";
			action = "['pelvis'] call A3PL_Medical_SelectPart;";
		};
		class button_rightupperleg: RscButtonEmpty
		{
			idc = 1606;
			x = 0.463021 * safezoneW + safezoneX;
			y = 0.557407 * safezoneH + safezoneY;
			w = 0.0154688 * safezoneW;
			h = 0.066 * safezoneH;
			
			tooltip = "STR_UI_Medical_RightUpperLeg";
			action = "['right upper leg'] call A3PL_Medical_SelectPart;";
		};
		class button_rightlowerleg: RscButtonEmpty
		{
			idc = 1607;
			x = 0.459895 * safezoneW + safezoneX;
			y = 0.628704 * safezoneH + safezoneY;
			w = 0.0154688 * safezoneW;
			h = 0.066 * safezoneH;
			tooltip = "STR_UI_Medical_RightLowerLeg";
			action = "['right lower leg'] call A3PL_Medical_SelectPart;";
		};
		class button_leftupperleg: RscButtonEmpty
		{
			idc = 1608;
			x = 0.492188 * safezoneW + safezoneX;
			y = 0.559259 * safezoneH + safezoneY;
			w = 0.0154688 * safezoneW;
			h = 0.066 * safezoneH;
			tooltip = "STR_UI_Medical_LeftUpperLeg";
			action = "['left upper leg'] call A3PL_Medical_SelectPart;";
		};
		class button_leftlowerleg: RscButtonEmpty
		{
			idc = 1609;
			x = 0.495312 * safezoneW + safezoneX;
			y = 0.62963 * safezoneH + safezoneY;
			w = 0.0154688 * safezoneW;
			h = 0.066 * safezoneH;
			
			tooltip = "STR_UI_Medical_LeftLowerLeg";
			action = "['left lower leg'] call A3PL_Medical_SelectPart;";
		};
		class button_leftupperarm: RscButtonEmpty
		{
			idc = 1610;
			x = 0.506771 * safezoneW + safezoneX;
			y = 0.421296 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.055 * safezoneH;
			tooltip = "STR_UI_Medical_LeftUpperArm";
			action = "['left upper arm'] call A3PL_Medical_SelectPart;";
		};
		class button_rightupperarm: RscButtonEmpty
		{
			idc = 1611;
			x = 0.438646 * safezoneW + safezoneX;
			y = 0.423111 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.055 * safezoneH;
			
			tooltip = "STR_UI_Medical_RightUpperArm";
			action = "['right upper arm'] call A3PL_Medical_SelectPart;";
		};
		class button_rightlowerarm: RscButtonEmpty
		{
			idc = 1612;
			x = 0.4125 * safezoneW + safezoneX;
			y = 0.463889 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.055 * safezoneH;
			tooltip = "STR_UI_Medical_RightLowerArm";
			action = "['right lower arm'] call A3PL_Medical_SelectPart;";
		};
		class button_leftlowerarm: RscButtonEmpty
		{
			idc = 1613;
			x = 0.532813 * safezoneW + safezoneX;
			y = 0.466667 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.055 * safezoneH;
			
			tooltip = "STR_UI_Medical_LeftLowerArm";
			action = "['left lower arm'] call A3PL_Medical_SelectPart;";
		};
	};
};

/*class Dialog_DeathScreen
{
	idd = 7300;
	movingEnable = 0;
    enableSimulation = 1;
	onLoad = "";
	onUnload = "if(!isNil 'A3PL_deathCam') then {A3PL_deathCam cameraEffect ['TERMINATE','BACK'];camDestroy A3PL_deathCam;};";
	class controlsBackground { };
	class controls
	{
		class DeathInformation: RscStructuredText
		{
			idc = 1001;
			text = "";
			x = 0.29375 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.4125 * safezoneW;
			h = 0.44 * safezoneH;
		};
	};
};
*/