class Dialog_CCTV
{
	idd = 27;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "";
	onUnload = "if (!isNull A3PL_NPC_Cam) then {A3PL_NPC_Cam cameraEffect ['TERMINATE', 'BACK']; camDestroy A3PL_NPC_Cam};";
	class controls
	{
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT START (by Kane, v1.063, #Jezuri)
		////////////////////////////////////////////////////////

		class static_bg: RscPicture
		{
			idc = 1200;
			text = "\A3PL_Common\GUI\A3PL_CCTV2.paa";
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 1 * safezoneH;
		};
		class A3PL_CCTV_3: RscPicture
		{
			idc = 1202;
			text = "#(argb,256,256,1)r2t(A3PL_CCTV_3_RT,1.0)";
			x = 0.201562 * safezoneW + safezoneX;
			y = 0.404055 * safezoneH + safezoneY;
			w = 0.221719 * safezoneW;
			h = 0.264 * safezoneH;
		};
		class A3PL_CCTV_2: RscPicture
		{
			idc = 1203;
			text = "#(argb,256,256,1)r2t(A3PL_CCTV_2_RT,1.0)";
			x = 0.577735 * safezoneW + safezoneX;
			y = 0.121527 * safezoneH + safezoneY;
			w = 0.221719 * safezoneW;
			h = 0.253 * safezoneH;
		};
		class A3PL_CCTV_4: RscPicture
		{
			idc = 1204;
			text = "#(argb,256,256,1)r2t(A3PL_CCTV_4_RT,1.0)";
			x = 0.576953 * safezoneW + safezoneX;
			y = 0.404862 * safezoneH + safezoneY;
			w = 0.221719 * safezoneW;
			h = 0.264 * safezoneH;
		};
		class A3PL_CCTV_1: RscPicture
		{
			idc = 1201;
			text = "#(argb,256,256,1)r2t(A3PL_CCTV_1_RT,1.0))";
			x = 0.201563 * safezoneW + safezoneX;
			y = 0.125695 * safezoneH + safezoneY;
			w = 0.221719 * safezoneW;
			h = 0.253 * safezoneH;
		};
		class combo_cam1: RscCombo
		{
			idc = 2100;
			x = 0.20164 * safezoneW + safezoneX;
			y = 0.0731111 * safezoneH + safezoneY;
			w = 0.221719 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class combo_cam2: RscCombo
		{
			idc = 2101;
			x = 0.576563 * safezoneW + safezoneX;
			y = 0.0743056 * safezoneH + safezoneY;
			w = 0.221719 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class combo_cam3: RscCombo
		{
			idc = 2102;
			x = 0.202343 * safezoneW + safezoneX;
			y = 0.675694 * safezoneH + safezoneY;
			w = 0.221719 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class combo_cam4: RscCombo
		{
			idc = 2103;
			x = 0.577344 * safezoneW + safezoneX;
			y = 0.675694 * safezoneH + safezoneY;
			w = 0.221719 * safezoneW;
			h = 0.044 * safezoneH;
		};		
		
		class check_normal: RscTextCheckbox
		{
			idc = 2500;
			x = 0.427735 * safezoneW + safezoneX;
			y = 0.0673616 * safezoneH + safezoneY;
			w = 0.154687 * safezoneW;
			h = 0.055 * safezoneH;
			strings[] = 
			{
				"NORMAL"
			};
			checked_strings[] = 
			{
				"NORMAL"
			};			
		};
		class check_night: RscTextCheckbox
		{
			idc = 2501;
			text = "Normal";
			x = 0.427344 * safezoneW + safezoneX;
			y = 0.117361 * safezoneH + safezoneY;
			w = 0.154687 * safezoneW;
			h = 0.055 * safezoneH;
			strings[] = 
			{
				"NV"
			};
			checked_strings[] = 
			{
				"NV"
			};				
		};
		class check_thermal: RscTextCheckbox
		{
			idc = 2502;
			text = "Normal";
			x = 0.426953 * safezoneW + safezoneX;
			y = 0.165972 * safezoneH + safezoneY;
			w = 0.154687 * safezoneW;
			h = 0.055 * safezoneH;
			strings[] = 
			{
				"THERMAL"
			};
			checked_strings[] = 
			{
				"THERMAL"
			};			
		};	
	};
};