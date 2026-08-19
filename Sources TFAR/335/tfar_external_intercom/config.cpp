class CfgPatches
{
	class tfar_external_intercom
	{
		name="TFAR - Intercom Phone";
		units[]={};
		weapons[]={};
		requiredVersion=1.72;
		requiredAddons[]=
		{
			"tfar_core"
		};
		author="$STR_tfar_core_AUTHORS";
		server_api=1;
		version="1.-1.0.335";
		versionStr="1.-1.0.335";
		versionAr[]={1,-1,0,335};
	};
};
class Extended_PreStart_EventHandlers
{
	class tfar_external_intercom
	{
		init="call compile preprocessFileLineNumbers '\z\tfar\addons\external_intercom\XEH_preStart.sqf'";
	};
};
class Extended_PreInit_EventHandlers
{
	class tfar_external_intercom
	{
		init="call compile preprocessFileLineNumbers '\z\tfar\addons\external_intercom\XEH_preInit.sqf'";
	};
};
class Extended_PostInit_EventHandlers
{
	class tfar_external_intercom
	{
		init="call compile preprocessFileLineNumbers '\z\tfar\addons\external_intercom\XEH_postInit.sqf'";
	};
};
class CfgUIGrids
{
	class IGUI
	{
		class Presets
		{
			class Arma3
			{
				class Variables
				{
					grid_TFAR_External_Intercom_Phone[]=
					{
						
						{
							"0.80 * safezoneW + safezoneX",
							"0.9 * safezoneH + safezoneY",
							"(4 * (1.5 * (((safezoneW / safezoneH) min 1.2) / 50)))",
							"(4 * (1.8 * (((safezoneW / safezoneH) min 1.2) / 50)))"
						},
						"(1 * (((safezoneW / safezoneH) min 1.2) / 50))",
						"(1 * (((safezoneW / safezoneH) min 1.2) / 50))"
					};
				};
			};
		};
		class Variables
		{
			class grid_TFAR_External_Intercom_Phone
			{
				displayName="$STR_tfar_external_intercom_PHONE_INDICATOR";
				description="$STR_tfar_external_intercom_PHONE_INDICATOR";
				preview="\z\tfar\addons\external_intercom\ui\tfar_external_intercom_phone.paa";
				saveToProfile[]={0,1,2,3};
				canResize=1;
			};
		};
	};
};
class ace_arsenal_stats
{
	class statBase;
	class TFAR_ExternalIntercom_WirelessEnabled: statBase
	{
		scope=2;
		displayName="Wireless Intercom Enabled";
		priority=1;
		stats[]=
		{
			"TFAR_ExternalIntercomWirelessCapable"
		};
		showBar=0;
		showText=1;
		textStatement="params ['_stats','_config']; format ['%1',getNumber (_config >> _stats select 0) > 0 || {(configName _config) in TFAR_externalIntercomWirelessHeadgear}]";
		condition="params ['','_config']; getNumber (_config >> 'TFAR_ExternalIntercomWirelessCapable') > 0 || {(configName _config) in TFAR_externalIntercomWirelessHeadgear}";
		tabs[]=
		{
			{6},
			{}
		};
	};
};
class Cfg3DEN
{
	class Attributes
	{
		class Default;
		class Title: Default
		{
			class Controls;
		};
		class Slider: Title
		{
			class Controls: Controls
			{
				class Title;
				class Value;
				class Edit;
			};
		};
		class TFAR_RangeSlider: Slider
		{
			onLoad="      _ctrlGroup = _this select 0;        [_ctrlGroup controlsgroupctrl 100,_ctrlGroup controlsgroupctrl 101,''] call bis_fnc_initSliderValue;        ";
			attributeLoad="        _ctrlGroup = _this;        [_ctrlGroup controlsgroupctrl 100,_ctrlGroup controlsgroupctrl 101,'',_value] call bis_fnc_initSliderValue;    ";
			class Controls: Controls
			{
				class Title: Title
				{
				};
				class Value: Value
				{
					sliderRange[]={0,20};
					sliderPosition=0;
					lineSize=20;
					sliderStep=1;
				};
				class Edit: Edit
				{
				};
			};
		};
	};
	class Object
	{
		class AttributeCategories
		{
			class TFAR_attributes
			{
				displayName="$STR_tfar_core_3DEN_Properties";
				collapsed=1;
				class Attributes
				{
					class TFAR_ExternalIntercomMaxRange_Phone
					{
						property="TFAR_ExternalIntercomMaxRange_Phone";
						control="TFAR_RangeSlider";
						displayName="$STR_tfar_external_intercom_3DEN_ATTRIBUTE_MAX_RANGE_PHONE_HEADER";
						tooltip="$STR_tfar_external_intercom_3DEN_ATTRIBUTE_MAX_RANGE_PHONE_DESC";
						expression="if (_value > 0) then {_this setVariable ['TFAR_externalIntercomMaxRange_Phone',_value]};";
						typeName="NUMBER";
						validate="number";
						condition="objectVehicle";
						defaultValue="TFAR_externalIntercomMaxRange_Phone";
					};
					class TFAR_ExternalIntercomMaxRange_Wireless
					{
						property="TFAR_ExternalIntercomMaxRange_Wireless";
						control="TFAR_RangeSlider";
						displayName="$STR_tfar_external_intercom_3DEN_ATTRIBUTE_MAX_RANGE_WIRELESS_HEADER";
						tooltip="$STR_tfar_external_intercom_3DEN_ATTRIBUTE_MAX_RANGE_WIRELESS_DESC";
						expression="if (_value > 0) then {_this setVariable ['TFAR_externalIntercomMaxRange_Wireless',_value]};";
						typeName="NUMBER";
						validate="number";
						condition="objectVehicle";
						defaultValue="TFAR_externalIntercomMaxRange_Wireless";
					};
				};
			};
		};
	};
};
class RscPictureKeepAspect;
class RscTitles
{
	class tfar_external_intercom_PhoneConnectionIndicatorRsc
	{
		idd=-1;
		movingEnable=1;
		duration=9999999;
		fadein=0;
		fadeout=0;
		onLoad="uiNamespace setVariable [""tfar_external_intercom_PhoneConnectionIndicatorRscDisplay"",_this select 0];";
		class controls
		{
			class ConnectionIndicator: RscPictureKeepAspect
			{
				idc=1112;
				type=0;
				style="0x30 + 0x800";
				colorText[]={1,1,1,1};
				colorBackground[]={0,0,0,0};
				font="PuristaMedium";
				sizeEx="(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
				text="\z\tfar\addons\external_intercom\ui\tfar_external_intercom_phone.paa";
				x="(profilenamespace getvariable [""IGUI_grid_TFAR_External_Intercom_Phone_X"",  0.85 * safezoneW + safezoneX])";
				y="(profilenamespace getvariable [""IGUI_grid_TFAR_External_Intercom_Phone_Y"",  0.9 * safezoneH + safezoneY])";
				w="(profilenamespace getvariable [""IGUI_grid_TFAR_External_Intercom_Phone_W"",  2 * (((safezoneW / safezoneH) min 1.2) / 50)])";
				h="(profilenamespace getvariable [""IGUI_grid_TFAR_External_Intercom_Phone_W"",  2 * (((safezoneW / safezoneH) min 1.2) / 50)])";
			};
		};
	};
};
class CfgVehicles
{
	class Man;
	class CAManBase: Man
	{
		class ACE_SelfActions
		{
			class TFAR_Radio
			{
				condition="(([] call TFAR_fnc_haveSWRadio) || {([] call TFAR_fnc_haveLRRadio) || !isNil {_player getVariable 'TFAR_ExternalIntercomVehicle'}})";
				insertChildren="([_player] call tfar_core_fnc_getOwnRadiosChildren) + (call TFAR_external_intercom_fnc_addWirelessIntercomMenu)";
				statement=" ";
			};
		};
	};
	class B_APC_Tracked_01_base_F;
	class B_APC_Tracked_01_AA_F: B_APC_Tracked_01_base_F
	{
		TFAR_ExternalIntercomInteractionPoint[]={1.56836,-4.7997899,-1.1637};
	};
	class AFV_Wheeled_01_up_base_F;
	class B_AFV_Wheeled_01_up_cannon_F: AFV_Wheeled_01_up_base_F
	{
		TFAR_ExternalIntercomInteractionPoint[]={1.21875,-4.34796,-0.82896};
	};
	class AFV_Wheeled_01_base_F;
	class B_AFV_Wheeled_01_cannon_F: AFV_Wheeled_01_base_F
	{
		TFAR_ExternalIntercomInteractionPoint[]={1.21875,-4.34796,-0.82896};
	};
	class B_APC_Tracked_01_CRV_F: B_APC_Tracked_01_base_F
	{
		TFAR_ExternalIntercomInteractionPoint[]={1.55518,-4.7996602,-0.81127203};
	};
	class B_APC_Tracked_01_rcws_F: B_APC_Tracked_01_base_F
	{
		TFAR_ExternalIntercomInteractionPoint[]={1.54883,-4.79953,-0.84446001};
	};
	class B_APC_Wheeled_01_base_F;
	class B_APC_Wheeled_01_cannon_F: B_APC_Wheeled_01_base_F
	{
		TFAR_ExternalIntercomInteractionPoint[]={0.56689501,-4.3974099,-0.89377701};
	};
	class B_MBT_01_mlrs_base_F;
	class B_MBT_01_mlrs_F: B_MBT_01_mlrs_base_F
	{
		TFAR_ExternalIntercomInteractionPoint[]={1.31592,-4.8209,-1.43332};
	};
	class B_MBT_01_arty_base_F;
	class B_MBT_01_arty_F: B_MBT_01_arty_base_F
	{
		TFAR_ExternalIntercomInteractionPoint[]={1.31592,-4.8209,-1.43332};
	};
	class B_MBT_01_base_F;
	class B_MBT_01_cannon_F: B_MBT_01_base_F
	{
		TFAR_ExternalIntercomInteractionPoint[]={1.2895499,-4.3982701,-1.06652};
	};
	class O_APC_Tracked_02_base_F;
	class O_APC_Tracked_02_AA_F: O_APC_Tracked_02_base_F
	{
		TFAR_ExternalIntercomInteractionPoint[]={0.93603498,-4.9436798,-0.98450702};
	};
	class APC_Wheeled_02_base_v2_F;
	class O_APC_Wheeled_02_rcws_v2_F: APC_Wheeled_02_base_v2_F
	{
		TFAR_ExternalIntercomInteractionPoint[]={0.67089802,-4.3208399,-0.72567201};
	};
	class O_APC_Tracked_02_cannon_F: O_APC_Tracked_02_base_F
	{
		TFAR_ExternalIntercomInteractionPoint[]={0.96435499,-4.9380202,-0.76562202};
	};
	class O_MBT_02_arty_base_F;
	class O_MBT_02_arty_F: O_MBT_02_arty_base_F
	{
		TFAR_ExternalIntercomInteractionPoint[]={-1.24561,-5.4189601,-1.4492};
	};
	class Tank_F;
	class MBT_04_base_F: Tank_F
	{
		TFAR_ExternalIntercomInteractionPoint[]={-1.44043,-5.6528201,-1.23575};
	};
	class MBT_02_base_F: Tank_F
	{
		TFAR_ExternalIntercomInteractionPoint[]={-1.26074,-4.7558398,-0.93804598};
	};
	class LT_01_base_F: Tank_F
	{
		TFAR_ExternalIntercomInteractionPoint[]={0.68310499,-1.6731,-0.883865};
	};
	class APC_Tracked_03_base_F: Tank_F
	{
		TFAR_ExternalIntercomInteractionPoint[]={1.07031,-3.8564701,-0.85696298};
	};
	class I_APC_Wheeled_03_base_F;
	class I_APC_Wheeled_03_cannon_F: I_APC_Wheeled_03_base_F
	{
		TFAR_ExternalIntercomInteractionPoint[]={-0.70214802,-4.40593,-0.68762201};
	};
	class MBT_03_base_F: Tank_F
	{
		TFAR_ExternalIntercomInteractionPoint[]={0.0117188,-5.45996,-0.75563002};
	};
	class Rope;
	class TFAR_RopeSmallWire: Rope
	{
		maxRelLenght=1.1;
		maxExtraLenght=0;
		springFactor=1;
		segmentType="TFAR_RopeSegmentSmallWire";
		torqueFactor=0.5;
		dampingFactor[]={1,2.5,1};
		model="\z\tfar\addons\external_intercom\data\TFAR_wire.p3d";
	};
};
class CfgNonAIVehicles
{
	class TFAR_RopeSegmentSmallWire
	{
		scope=2;
		displayName="";
		simulation="ropesegment";
		autocenter=0;
		animated=0;
		model="\z\tfar\addons\external_intercom\data\TFAR_wire.p3d";
	};
};
class Extended_GetOutMan_EventHandlers
{
	class CAManBase
	{
		class TFAR_ExternalIntercom
		{
			clientGetOutMan="params['_player','_role','_vehicle']; if (alive (_player) && isPlayer _player && (headgear (_player)) in TFAR_externalIntercomWirelessHeadgear && !((_role) isEqualTo 'cargo') && local _player && [(typeOf _vehicle),'TFAR_hasIntercom',0] call TFAR_fnc_getVehicleConfigProperty == 1) then { [_vehicle,_player,[true]] call TFAR_external_intercom_fnc_connect; };";
		};
	};
};
class Extended_InitPost_Eventhandlers
{
	class Car
	{
		class TFAR_ExternalIntercom_Interactions
		{
			init="call tfar_external_intercom_fnc_addWirelessInteractions;call tfar_external_intercom_fnc_addPhoneInteractions";
		};
	};
	class Tank
	{
		class TFAR_ExternalIntercom_Interactions
		{
			init="call tfar_external_intercom_fnc_addWirelessInteractions;call tfar_external_intercom_fnc_addPhoneInteractions";
		};
	};
	class Helicopter
	{
		class TFAR_ExternalIntercom_Interactions
		{
			init="call tfar_external_intercom_fnc_addWirelessInteractions";
		};
	};
	class Plane
	{
		class TFAR_ExternalIntercom_Interactions
		{
			init="call tfar_external_intercom_fnc_addWirelessInteractions";
		};
	};
};
class CfgWeapons
{
	class H_HelmetB;
	class H_HelmetCrew_B: H_HelmetB
	{
		TFAR_ExternalIntercomWirelessCapable=1;
	};
	class H_HelmetCrew_O: H_HelmetCrew_B
	{
		TFAR_ExternalIntercomWirelessCapable=1;
	};
	class H_HelmetCrew_I: H_HelmetCrew_B
	{
		TFAR_ExternalIntercomWirelessCapable=1;
	};
	class H_PilotHelmetHeli_B: H_HelmetB
	{
		TFAR_ExternalIntercomWirelessCapable=1;
	};
	class H_PilotHelmetHeli_O: H_PilotHelmetHeli_B
	{
		TFAR_ExternalIntercomWirelessCapable=1;
	};
	class H_PilotHelmetHeli_I: H_PilotHelmetHeli_B
	{
		TFAR_ExternalIntercomWirelessCapable=1;
	};
	class H_CrewHelmetHeli_B: H_HelmetB
	{
		TFAR_ExternalIntercomWirelessCapable=1;
	};
	class H_CrewHelmetHeli_O: H_CrewHelmetHeli_B
	{
		TFAR_ExternalIntercomWirelessCapable=1;
	};
	class H_CrewHelmetHeli_I: H_CrewHelmetHeli_B
	{
		TFAR_ExternalIntercomWirelessCapable=1;
	};
	class H_HelmetCrew_O_ghex_F: H_HelmetCrew_O
	{
		TFAR_ExternalIntercomWirelessCapable=1;
	};
	class H_HelmetCrew_I_E: H_HelmetCrew_I
	{
		TFAR_ExternalIntercomWirelessCapable=1;
	};
	class H_PilotHelmetHeli_I_E: H_PilotHelmetHeli_O
	{
		TFAR_ExternalIntercomWirelessCapable=1;
	};
	class H_CrewHelmetHeli_I_E: H_CrewHelmetHeli_O
	{
		TFAR_ExternalIntercomWirelessCapable=1;
	};
	class H_Tank_base_F;
	class H_Tank_black_F: H_Tank_base_F
	{
		TFAR_ExternalIntercomWirelessCapable=1;
	};
	class H_Tank_eaf_F: H_Tank_black_F
	{
		TFAR_ExternalIntercomWirelessCapable=1;
	};
};
