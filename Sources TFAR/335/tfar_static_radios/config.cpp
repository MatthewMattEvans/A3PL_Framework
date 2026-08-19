class CfgPatches
{
	class tfar_static_radios
	{
		units[]=
		{
			"TFAR_Module_staticRadio"
		};
		weapons[]={};
		requiredVersion=1.72;
		requiredAddons[]=
		{
			"A3_Modules_F",
			"tfar_core",
			"3DEN"
		};
		Url="https://github.com/michail-nikolaev/task-force-arma-3-radio";
		version="1.-1.0.335";
		versionStr="1.-1.0.335";
		versionAr[]={1,-1,0,335};
	};
};
class Extended_PreStart_EventHandlers
{
	class tfar_static_radios
	{
		init="call compile preprocessFileLineNumbers '\z\tfar\addons\static_radios\XEH_preStart.sqf'";
	};
};
class Extended_PreInit_EventHandlers
{
	class tfar_static_radios
	{
		init="call compile preprocessFileLineNumbers '\z\tfar\addons\static_radios\XEH_preInit.sqf'";
	};
};
class Extended_PostInit_EventHandlers
{
	class tfar_static_radios
	{
		init="call compile preprocessFileLineNumbers '\z\tfar\addons\static_radios\XEH_postInit.sqf'";
	};
};
class Cfg3DEN
{
	class Attributes
	{
		class slider;
		class tfar_static_radios_volumeSlider: slider
		{
			attributeLoad="params [""_ctrlGroup""]; private _slider = _ctrlGroup controlsGroupCtrl 100; private _edit = _ctrlGroup controlsGroupCtrl 101; _slider sliderSetPosition _value; _edit ctrlSetText ([_value, 1, 1] call CBA_fnc_formatNumber); ";
			attributeSave="params [""_ctrlGroup""]; sliderPosition (_ctrlGroup controlsGroupCtrl 100); ";
			onLoad="params [""_ctrlGroup""]; private _slider = _ctrlGroup controlsGroupCtrl 100; private _edit = _ctrlGroup controlsGroupCtrl 101; _slider sliderSetRange [1, 50]; _slider ctrlAddEventHandler [""SliderPosChanged"", { params [""_slider""]; private _edit = (ctrlParentControlsGroup _slider) controlsGroupCtrl 101; private _value = sliderPosition _slider;  _edit ctrlSetText ([_value, 1, 1] call CBA_fnc_formatNumber); }]; _edit ctrlAddEventHandler [""KillFocus"", { params [""_edit""]; private _slider = (ctrlParentControlsGroup _edit) controlsGroupCtrl 100; private _value = ((parseNumber ctrlText _edit) min 50) max 1; _slider sliderSetPosition _value; _edit ctrlSetText str _value; }];";
		};
	};
};
class RscCombo;
class RscText;
class RscEdit;
class RscPicture;
class RscTree;
class RscControlsGroupNoScrollbars;
class RscCheckBox;
class RscSlider;
class ctrlXSliderH;
class RscAttributeTFARStaticRadioThingy: RscControlsGroupNoScrollbars
{
	idc=2611800;
	x="7 *      (   ((safezoneW / safezoneH) min 1.2) / 40) +   (safezoneX + (safezoneW -      ((safezoneW / safezoneH) min 1.2))/2)";
	y="5 *      (   (   ((safezoneW / safezoneH) min 1.2) / 1.2) / 25) +   (safezoneY + (safezoneH -      (   ((safezoneW / safezoneH) min 1.2) / 1.2))/2)";
	w="26 *      (   ((safezoneW / safezoneH) min 1.2) / 40)";
	h="16 *      (   (   ((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
	class controls
	{
		class FreqTitle: RscText
		{
			idc=2611803;
			text="$STR_tfar_static_radios_moduleStaticRadio_FreqTitle";
			x="0 *      (   ((safezoneW / safezoneH) min 1.2) / 40)";
			y="1.1 *      (   (   ((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			w="6 *      (   ((safezoneW / safezoneH) min 1.2) / 40)";
			h="1 *      (   (   ((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			colorBackground[]={0,0,0,0.5};
		};
		class FreqEdit: RscEdit
		{
			idc=2611804;
			x="6 *      (   ((safezoneW / safezoneH) min 1.2) / 40)";
			y="1.1 *      (   (   ((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			w="20 *      (   ((safezoneW / safezoneH) min 1.2) / 40)";
			h="1 *      (   (   ((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			colorBackground[]={1,1,1,0.1};
		};
		class ChannelTitle: RscText
		{
			idc=2611805;
			text="$STR_tfar_static_radios_moduleStaticRadio_ChannelTitle";
			x="0 *      (   ((safezoneW / safezoneH) min 1.2) / 40)";
			y="2.2 *      (   (   ((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			w="26 *      (   ((safezoneW / safezoneH) min 1.2) / 40)";
			h="1 *      (   (   ((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			colorBackground[]={0,0,0,0.5};
		};
		class ChannelEdit: RscEdit
		{
			style=16;
			idc=2611806;
			x="10 *      (   ((safezoneW / safezoneH) min 1.2) / 40)";
			y="2.2 *      (   (   ((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			w="16 *      (   ((safezoneW / safezoneH) min 1.2) / 40)";
			h="1 *      (   (   ((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			colorBackground[]={1,1,1,0.1};
		};
		class SpeakerTitle: RscText
		{
			idc=2611807;
			text="$STR_tfar_static_radios_moduleStaticRadio_SpeakerTitle";
			x="0 *      (   ((safezoneW / safezoneH) min 1.2) / 40)";
			y="3.3 *      (   (   ((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			w="26 *      (   ((safezoneW / safezoneH) min 1.2) / 40)";
			h="1 *      (   (   ((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			colorBackground[]={0,0,0,0.5};
		};
		class SpeakerCheckbox: RscCheckBox
		{
			idc=2611808;
			text="#(argb,8,8,3)color(0,0,0,0)";
			x="10 *      (   ((safezoneW / safezoneH) min 1.2) / 40)";
			y="3.3 *      (   (   ((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			w="1 *      (   ((safezoneW / safezoneH) min 1.2) / 40)";
			h="1 *      (   (   ((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
		};
		class VolumeTitle: RscText
		{
			idc=2611809;
			text="$STR_tfar_static_radios_moduleStaticRadio_VolumeTitle";
			x="0 *      (   ((safezoneW / safezoneH) min 1.2) / 40)";
			y="4.4 *      (   (   ((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			w="26 *      (   ((safezoneW / safezoneH) min 1.2) / 40)";
			h="1 *      (   (   ((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			colorBackground[]={0,0,0,0.5};
		};
		class VolumeSlider: ctrlXSliderH
		{
			idc=2611810;
			x="10 *      (   ((safezoneW / safezoneH) min 1.2) / 40)";
			y="4.4 *      (   (   ((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			w="11 *      (   ((safezoneW / safezoneH) min 1.2) / 40)";
			h="1 *      (   (   ((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
		};
		class VolumeEdit: RscEdit
		{
			style=16;
			idc=2611811;
			x="(10+12) *      (   ((safezoneW / safezoneH) min 1.2) / 40)";
			y="4.4 *      (   (   ((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			w="4 *      (   ((safezoneW / safezoneH) min 1.2) / 40)";
			h="1 *      (   (   ((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			colorBackground[]={1,1,1,0.1};
		};
	};
};
class ButtonOK;
class ButtonCancel;
class Background;
class Title;
class Content;
class controls;
class RscDisplayAttributes;
class RscAttributeOwners;
class RscAttributeDiaryRecord;
class RscDisplayAttributesModuleTFARStaticRadio: RscDisplayAttributes
{
	onLoad="[""onLoad"",_this,""RscDisplayAttributesModuleTFARStaticRadio""] call TFAR_static_radios_fnc_zeusAttributes";
	onUnload="[""onUnload"",_this,""RscDisplayAttributesModuleTFARStaticRadio""] call TFAR_static_radios_fnc_zeusAttributes";
	class Controls: controls
	{
		class Background: Background
		{
		};
		class Title: Title
		{
		};
		class Content: Content
		{
			class Controls: controls
			{
				class StaticRadioSettings: RscAttributeTFARStaticRadioThingy
				{
				};
			};
		};
		class ButtonOK: ButtonOK
		{
			onLoad="_this call TFAR_static_radios_fnc_moduleStaticRadio";
		};
		class ButtonCancel: ButtonCancel
		{
		};
	};
};
class CfgVehicles
{
	class Module_F;
	class TFAR_Module_staticRadio: Module_F
	{
		author="$STR_tfar_core_AUTHORS";
		category="TFAR";
		functionPriority=1;
		isGlobal=1;
		isTriggerActivated=0;
		scope=1;
		scopeCurator=2;
		curatorCanAttach=1;
		displayName="$STR_tfar_static_radios_moduleStaticRadio_DisplayName";
		icon="";
		curatorInfoType="RscDisplayAttributesModuleTFARStaticRadio";
	};
};
