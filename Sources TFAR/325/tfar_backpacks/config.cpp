class CfgPatches
{
	class tfar_backpacks
	{
		units[]=
		{
			"TFAR_NATO_Radio_Crate",
			"TFAR_EAST_Radio_Crate",
			"TFAR_IND_Radio_Crate",
			"TFAR_rt1523g",
			"TFAR_anprc155",
			"TFAR_mr3000",
			"TFAR_anarc164",
			"TFAR_mr6000l",
			"TFAR_anarc210",
			"TFAR_mr3000_multicam",
			"TFAR_anprc155_coyote",
			"TFAR_rt1523g_sage",
			"TFAR_rt1523g_green",
			"TFAR_rt1523g_fabric",
			"TFAR_rt1523g_big",
			"TFAR_rt1523g_black",
			"TFAR_rt1523g_big_bwmod",
			"TFAR_mr3000_bwmod",
			"TFAR_rt1523g_bwmod",
			"TFAR_mr3000_bwmod_tropen",
			"TFAR_rt1523g_big_bwmod_tropen",
			"TFAR_rt1523g_big_rhs",
			"TFAR_rt1523g_rhs",
			"TFAR_mr3000_rhs",
			"TFAR_bussole"
		};
		weapons[]={};
		requiredVersion=1.72;
		requiredAddons[]=
		{
			"A3_Modules_F",
			"A3_UI_F",
			"A3_Structures_F_Items_Electronics",
			"A3_Weapons_F_ItemHolders",
			"tfar_core",
			"tfar_static_radios"
		};
		Url="https://github.com/michail-nikolaev/task-force-arma-3-radio";
	};
};
class Extended_PreInit_EventHandlers
{
	class tfar_backpacks
	{
		init="call compile preProcessFileLineNumbers '\z\tfar\addons\backpacks\XEH_preInit.sqf'";
	};
};
class CfgFactionClasses
{
	class TFAR
	{
		displayName="TFAR";
		priority=10;
		side=7;
	};
	class BLU_G_F
	{
		backpack_tf_faction_radio="TFAR_rt1523g_sage";
	};
};
class CfgVehicles
{
	class ReammoBox;
	class Item_Base_F;
	class Bag_Base: ReammoBox
	{
		tf_hasLRradio=0;
		tf_encryptionCode="";
		tf_range=20000;
	};
	class TFAR_Bag_Base: Bag_Base
	{
		tf_dialogUpdate="call TFAR_fnc_updateLRDialogToChannel;";
		tf_hasLRradio=1;
		scope=1;
		scopeCurator=1;
		editorCategory="TFAR";
		class Attributes
		{
			class staticRadioFrequency
			{
				displayName="$STR_tfar_static_radios_moduleStaticRadio_FreqTitle";
				tooltip="$STR_tfar_static_radios_moduleStaticRadio_ATT_Frequency_tooltip";
				property="staticRadioFrequency";
				control="Edit";
				expression="if (isMultiplayer) then {[_this,call compile _value] call TFAR_static_radios_fnc_setFrequencies}";
				defaultValue="str (_this call TFAR_static_radios_fnc_generateFrequencies)";
				validate="none";
				condition="objectHasInventoryCargo";
				typeName="STRING";
			};
			class staticRadioChannel
			{
				displayName="$STR_tfar_static_radios_moduleStaticRadio_ChannelTitle";
				tooltip="$STR_tfar_static_radios_moduleStaticRadio_ATT_Channel_tooltip";
				property="staticRadioChannel";
				control="Edit";
				expression="if (isMultiplayer) then {[_this,_value] call TFAR_static_radios_fnc_setActiveChannel}";
				defaultValue="'1'";
				validate="none";
				condition="objectHasInventoryCargo";
				typeName="NUMBER";
			};
			class staticRadioSpeaker
			{
				displayName="$STR_tfar_static_radios_moduleStaticRadio_ATT_SpeakerEnabled";
				tooltip="$STR_tfar_static_radios_moduleStaticRadio_ATT_SpeakerEnabled_tooltip";
				property="staticRadioSpeaker";
				control="Checkbox";
				expression="if (isMultiplayer) then {[_this,_value] call TFAR_static_radios_fnc_setSpeakers}";
				defaultValue="false";
				validate="none";
				condition="objectHasInventoryCargo";
				typeName="NUMBER";
			};
			class staticRadioVolume
			{
				displayName="$STR_tfar_static_radios_moduleStaticRadio_ATT_RadioVolume";
				tooltip="$STR_tfar_static_radios_moduleStaticRadio_ATT_RadioVolume_tooltip";
				property="staticRadioVolume";
				control="tfar_static_radios_volumeSlider";
				expression="if (isMultiplayer) then {[_this,_value] call TFAR_static_radios_fnc_setVolume}";
				defaultValue=7;
				validate="none";
				condition="objectHasInventoryCargo";
				typeName="NUMBER";
			};
		};
	};
	class TFAR_anarc164: TFAR_Bag_Base
	{
		scope=2;
		scopeCurator=2;
		displayName="$STR_tfar_backpacks_ANARC164";
		descriptionShort="$STR_tfar_backpacks_ANARC164_Desc";
		picture="\z\tfar\addons\backpacks\anarc164\ui\anarc164_icon.paa";
		model="\z\tfar\addons\backpacks\models\TFR_BACKPACK";
		hiddenSelections[]=
		{
			"camo"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\tfar\addons\backpacks\models\data\camo\backpack_dpcu_co.paa"
		};
		maximumLoad=20;
		mass=160;
		tf_range=40000;
		tf_encryptionCode="tf_independent_radio_code";
		tf_dialog="anarc164_radio_dialog";
		tf_subtype="airborne";
		tf_dialogUpdate="[""%1""] call TFAR_fnc_updateLRDialogToChannel;";
	};
	class tf_anarc164: TFAR_anarc164
	{
		scope=1;
		scopeCurator=1;
		scopeArsenal=1;
		displayName="tf_anarc164 : TFAR_anarc164 deprecated item";
	};
	class TFAR_anarc210: TFAR_Bag_Base
	{
		scope=2;
		scopeCurator=2;
		displayName="$STR_tfar_backpacks_ANARC210";
		descriptionShort="$STR_tfar_backpacks_ANARC210_Desc";
		picture="\z\tfar\addons\backpacks\anarc210\ui\anarc210_icon.paa";
		model="\z\tfar\addons\backpacks\models\TFR_BACKPACK";
		hiddenSelections[]=
		{
			"camo"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\tfar\addons\backpacks\models\data\camo\backpack_mcam_co.paa"
		};
		maximumLoad=20;
		mass=160;
		tf_range=40000;
		tf_encryptionCode="tf_west_radio_code";
		tf_dialog="anarc210_radio_dialog";
		tf_subtype="airborne";
		tf_dialogUpdate="[""CH%1""] call TFAR_fnc_updateLRDialogToChannel;";
	};
	class tf_anarc210: TFAR_anarc210
	{
		scope=1;
		scopeCurator=1;
		scopeArsenal=1;
		displayName="tf_anarc210 : TFAR_anarc210 deprecated item";
	};
	class TFAR_anprc155: TFAR_Bag_Base
	{
		scope=2;
		scopeCurator=2;
		author="Raspu, Gandi, Nkey";
		displayName="$STR_tfar_backpacks_ANPRC155";
		descriptionShort="$STR_tfar_backpacks_ANPRC155_Desc";
		picture="\z\tfar\addons\backpacks\anprc155\ui\155_icon.paa";
		maximumLoad=160;
		mass=160;
		model="\z\tfar\addons\backpacks\models\clf_nicecomm2";
		hiddenSelections[]=
		{
			"camo"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\tfar\addons\backpacks\models\data\clf_nicecomm2_aff_digital_co.paa"
		};
		tf_encryptionCode="tf_independent_radio_code";
		tf_dialog="anprc155_radio_dialog";
		tf_subtype="digital_lr";
	};
	class tf_anprc155: TFAR_anprc155
	{
		scope=1;
		scopeCurator=1;
		scopeArsenal=1;
		displayName="tf_anprc155 : TFAR_anprc155 deprecated item";
	};
	class TFAR_anprc155_coyote: TFAR_anprc155
	{
		author="Raspu, Gandi, Nkey";
		displayName="$STR_tfar_backpacks_ANPRC155_Coyote";
		descriptionShort="$STR_tfar_backpacks_ANPRC155_Coyote_Desc";
		hiddenSelections[]=
		{
			"camo"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\tfar\addons\backpacks\models\data\clf_nicecomm2_coyote_co.paa"
		};
	};
	class tf_anprc155_coyote: TFAR_anprc155_coyote
	{
		scope=1;
		scopeCurator=1;
		scopeArsenal=1;
		displayName="tf_anprc155_coyote : TFAR_anprc155_coyote deprecated item";
	};
	class TFAR_bussole: TFAR_Bag_Base
	{
		scope=2;
		scopeCurator=2;
		author="Raspu";
		displayName="$STR_tfar_backpacks_Bussole";
		descriptionShort="$STR_tfar_backpacks_Bussole_Desc";
		picture="\z\tfar\addons\backpacks\bussole\ui\bussole_icon.paa";
		maximumLoad=30;
		mass=120;
		model="\z\tfar\addons\backpacks\models\tf_bussole";
		hiddenSelections[]=
		{
			"camo"
		};
		hiddenSelectionsTextures[]=
		{
			""
		};
		tf_encryptionCode="tf_east_radio_code";
		tf_dialog="bussole_radio_dialog";
		tf_subtype="digital_lr";
	};
	class tf_bussole: TFAR_bussole
	{
		scope=1;
		scopeCurator=1;
		scopeArsenal=1;
		displayName="tf_bussole : TFAR_bussole deprecated item";
	};
	class TFAR_mr3000: TFAR_Bag_Base
	{
		scope=2;
		scopeCurator=2;
		author="Raspu, Gandi, Nkey";
		displayName="$STR_tfar_backpacks_MR3000";
		descriptionShort="$STR_tfar_backpacks_MR3000_Desc";
		picture="\z\tfar\addons\backpacks\mr3000\ui\mr3000_icon.paa";
		maximumLoad=160;
		mass=160;
		model="\z\tfar\addons\backpacks\models\clf_nicecomm2_prc117g";
		hiddenSelections[]=
		{
			"camo"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\tfar\addons\backpacks\models\data\clf_nicecomm2_csat_multi_co.paa"
		};
		tf_encryptionCode="tf_east_radio_code";
		tf_dialog="mr3000_radio_dialog";
		tf_subtype="digital_lr";
	};
	class tf_mr3000: TFAR_mr3000
	{
		scope=1;
		scopeCurator=1;
		scopeArsenal=1;
		displayName="tf_mr3000 : TFAR_mr3000 deprecated item";
	};
	class TFAR_mr3000_multicam: TFAR_mr3000
	{
		author="Raspu, Gandi, Nkey";
		displayName="$STR_tfar_backpacks_MR3000_Multicam";
		descriptionShort="$STR_tfar_backpacks_MR3000_Multicam_Desc";
		hiddenSelections[]=
		{
			"camo"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\tfar\addons\backpacks\models\data\clf_nicecomm2_co.paa"
		};
	};
	class tf_mr3000_multicam: TFAR_mr3000_multicam
	{
		scope=1;
		scopeCurator=1;
		scopeArsenal=1;
		displayName="tf_mr3000_multicam : TFAR_mr3000_multicam deprecated item";
	};
	class TFAR_mr3000_bwmod: TFAR_mr3000
	{
		displayName="$STR_tfar_backpacks_MR3000_BWMOD";
		descriptionShort="$STR_tfar_backpacks_MR3000_BWMOD_Desc";
		hiddenSelections[]=
		{
			"camo"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\tfar\addons\backpacks\models\data\clf_nicecomm2_bwmod_co.paa"
		};
		tf_encryptionCode="tf_west_radio_code";
	};
	class tf_mr3000_bwmod: TFAR_mr3000_bwmod
	{
		scope=1;
		scopeCurator=1;
		scopeArsenal=1;
		displayName="tf_mr3000_bwmod : TFAR_mr3000_bwmod deprecated item";
	};
	class TFAR_mr3000_bwmod_tropen: TFAR_mr3000_bwmod
	{
		displayName="$STR_tfar_backpacks_MR3000_BWMOD_Tropen";
		hiddenSelectionsTextures[]=
		{
			"\z\tfar\addons\backpacks\models\data\jgbtl14_marcbook_bwmod_tropen_co.paa"
		};
	};
	class tf_mr3000_bwmod_tropen: TFAR_mr3000_bwmod_tropen
	{
		scope=1;
		scopeCurator=1;
		scopeArsenal=1;
		displayName="tf_mr3000_bwmod_tropen : TFAR_mr3000_bwmod_tropen deprecated item";
	};
	class TFAR_mr3000_rhs: TFAR_mr3000
	{
		displayName="$STR_tfar_backpacks_MR3000_RHS";
		descriptionShort="$STR_tfar_backpacks_MR3000_RHS_Desc";
		hiddenSelections[]=
		{
			"camo"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\tfar\addons\backpacks\models\data\clf_nicecomm2_rhs_digital_co.paa"
		};
	};
	class tf_mr3000_rhs: TFAR_mr3000_rhs
	{
		scope=1;
		scopeCurator=1;
		scopeArsenal=1;
		displayName="tf_mr3000_rhs : TFAR_mr3000_rhs deprecated item";
	};
	class TFAR_mr6000l: TFAR_Bag_Base
	{
		scope=2;
		scopeCurator=2;
		displayName="$STR_tfar_backpacks_MR6000L";
		descriptionShort="$STR_tfar_backpacks_MR6000L_Desc";
		model="\z\tfar\addons\backpacks\models\TFR_BACKPACK";
		picture="\z\tfar\addons\backpacks\mr6000l\ui\mr6000l_icon.paa";
		maximumLoad=20;
		mass=160;
		tf_range=40000;
		tf_encryptionCode="tf_east_radio_code";
		tf_dialog="mr6000l_radio_dialog";
		tf_subtype="airborne";
		tf_dialogUpdate="[""PRE %1""] call TFAR_fnc_updateLRDialogToChannel;";
	};
	class tf_mr6000l: TFAR_mr6000l
	{
		scope=1;
		scopeCurator=1;
		scopeArsenal=1;
		displayName="tf_mr6000l : TFAR_mr6000l deprecated item";
	};
	class TFAR_rt1523g: TFAR_Bag_Base
	{
		scope=2;
		scopeCurator=2;
		author="Raspu, Gandi, Nkey";
		displayName="$STR_tfar_backpacks_RT1523G";
		descriptionShort="$STR_tfar_backpacks_RT1523G_Desc";
		picture="\z\tfar\addons\backpacks\rt1523g\ui\rt1523g_icon.paa";
		model="\z\tfar\addons\backpacks\models\clf_prc117g_ap";
		hiddenSelections[]=
		{
			"camo"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\tfar\addons\backpacks\models\data\clf_prc117g_ap_co.paa"
		};
		maximumLoad=50;
		mass=80;
		tf_encryptionCode="tf_west_radio_code";
		tf_dialog="rt1523g_radio_dialog";
		tf_subtype="digital_lr";
	};
	class tf_rt1523g: TFAR_rt1523g
	{
		scope=1;
		scopeCurator=1;
		scopeArsenal=1;
		displayName="tf_rt1523g : TFAR_rt1523g deprecated item";
	};
	class TFAR_rt1523g_bwmod: TFAR_rt1523g
	{
		displayName="$STR_tfar_backpacks_RT1523G_BWMOD";
		descriptionShort="$STR_tfar_backpacks_RT1523G_BWMOD_Desc";
		hiddenSelections[]=
		{
			"camo"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\tfar\addons\backpacks\models\data\clf_prc117g_bwmod_co.paa"
		};
	};
	class tf_rt1523g_bwmod: TFAR_rt1523g_bwmod
	{
		scope=1;
		scopeCurator=1;
		scopeArsenal=1;
		displayName="tf_rt1523g_bwmod : TFAR_rt1523g_bwmod deprecated item";
	};
	class TFAR_rt1523g_rhs: TFAR_rt1523g
	{
		displayName="$STR_tfar_backpacks_RT1523G_RHS";
		descriptionShort="$STR_tfar_backpacks_RT1523G_RHS_Desc";
		hiddenSelections[]=
		{
			"camo"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\tfar\addons\backpacks\models\data\clf_prc117g_rhs_co.paa"
		};
	};
	class tf_rt1523g_rhs: TFAR_rt1523g_rhs
	{
		scope=1;
		scopeCurator=1;
		scopeArsenal=1;
		displayName="tf_rt1523g_rhs : TFAR_rt1523g_rhs deprecated item";
	};
	class TFAR_rt1523g_big: TFAR_rt1523g
	{
		author="Raspu, Gandi, Nkey";
		displayName="$STR_tfar_backpacks_RT1523G_Big";
		descriptionShort="$STR_tfar_backpacks_RT1523G_Big_Desc";
		maximumLoad=160;
		mass=160;
		hiddenSelections[]=
		{
			"camo"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\tfar\addons\backpacks\models\data\clf_nicecomm2_nato_multi_co.paa"
		};
		model="\z\tfar\addons\backpacks\models\clf_nicecomm2";
	};
	class tf_rt1523g_big: TFAR_rt1523g_big
	{
		scope=1;
		scopeCurator=1;
		scopeArsenal=1;
		displayName="tf_rt1523g_big : TFAR_rt1523g_big deprecated item";
	};
	class TFAR_rt1523g_big_bwmod: TFAR_rt1523g_big
	{
		displayName="$STR_tfar_backpacks_RT1523G_BigBWMOD";
		descriptionShort="$STR_tfar_backpacks_RT1523G_BigBWMOD_Desc";
		hiddenSelections[]=
		{
			"camo"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\tfar\addons\backpacks\models\data\clf_nicecomm2_bwmod_co.paa"
		};
	};
	class tf_rt1523g_big_bwmod: TFAR_rt1523g_big_bwmod
	{
		scope=1;
		scopeCurator=1;
		scopeArsenal=1;
		displayName="tf_rt1523g_big_bwmod : TFAR_rt1523g_big_bwmod deprecated item";
	};
	class TFAR_rt1523g_big_bwmod_tropen: TFAR_rt1523g_big_bwmod
	{
		displayName="$STR_tfar_backpacks_RT1523G_BigBWMOD_Tropen";
		hiddenSelectionsTextures[]=
		{
			"\z\tfar\addons\backpacks\models\data\jgbtl14_marcbook_bwmod_tropen_co.paa"
		};
	};
	class tf_rt1523g_big_bwmod_tropen: TFAR_rt1523g_big_bwmod_tropen
	{
		scope=1;
		scopeCurator=1;
		scopeArsenal=1;
		displayName="tf_rt1523g_big_bwmod_tropen : TFAR_rt1523g_big_bwmod_tropen deprecated item";
	};
	class TFAR_rt1523g_big_rhs: TFAR_rt1523g_big
	{
		displayName="$STR_tfar_backpacks_RT1523G_BigRHS";
		descriptionShort="$STR_tfar_backpacks_RT1523G_BigRHS_Desc";
		hiddenSelections[]=
		{
			"camo"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\tfar\addons\backpacks\models\data\clf_nicecomm2_rhs_co.paa"
		};
	};
	class tf_rt1523g_big_rhs: TFAR_rt1523g_big_rhs
	{
		scope=1;
		scopeCurator=1;
		scopeArsenal=1;
		displayName="tf_rt1523g_big_rhs : TFAR_rt1523g_big_rhs deprecated item";
	};
	class TFAR_rt1523g_sage: TFAR_rt1523g
	{
		displayName="$STR_tfar_backpacks_RT1523G_Sage";
		descriptionShort="$STR_tfar_backpacks_RT1523G_Sage_Desc";
		maximumLoad=100;
		mass=120;
		hiddenSelections[]=
		{
			"camo"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\tfar\addons\backpacks\models\data\camo\backpack_sage_co.paa"
		};
		model="\z\tfar\addons\backpacks\models\TFR_BACKPACK";
	};
	class tf_rt1523g_sage: TFAR_rt1523g_sage
	{
		scope=1;
		scopeCurator=1;
		scopeArsenal=1;
		displayName="tf_rt1523g_sage : TFAR_rt1523g_sage deprecated item";
	};
	class TFAR_rt1523g_green: TFAR_rt1523g_sage
	{
		displayName="$STR_tfar_backpacks_RT1523G_Green";
		descriptionShort="$STR_tfar_backpacks_RT1523G_Green_Desc";
		hiddenSelections[]=
		{
			"camo"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\tfar\addons\backpacks\models\data\camo\backpack_green_co.paa"
		};
	};
	class tf_rt1523g_green: TFAR_rt1523g_green
	{
		scope=1;
		scopeCurator=1;
		scopeArsenal=1;
		displayName="tf_rt1523g_green : TFAR_rt1523g_green deprecated item";
	};
	class TFAR_rt1523g_fabric: TFAR_rt1523g_sage
	{
		displayName="$STR_tfar_backpacks_RT1523G_Fabric";
		descriptionShort="$STR_tfar_backpacks_RT1523G_Fabric_Desc";
		hiddenSelections[]=
		{
			"camo"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\tfar\addons\backpacks\models\data\camo\backpack_fabric_co.paa"
		};
	};
	class tf_rt1523g_fabric: TFAR_rt1523g_fabric
	{
		scope=1;
		scopeCurator=1;
		scopeArsenal=1;
		displayName="tf_rt1523g_fabric : TFAR_rt1523g_fabric deprecated item";
	};
	class TFAR_rt1523g_black: TFAR_rt1523g_sage
	{
		displayName="$STR_tfar_backpacks_RT1523G_Black";
		descriptionShort="$STR_tfar_backpacks_RT1523G_Black_Desc";
		hiddenSelections[]=
		{
			"camo"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\tfar\addons\backpacks\models\data\camo\backpack_black_co.paa"
		};
	};
	class tf_rt1523g_black: TFAR_rt1523g_black
	{
		scope=1;
		scopeCurator=1;
		scopeArsenal=1;
		displayName="tf_rt1523g_black : TFAR_rt1523g_black deprecated item";
	};
	class Box_NATO_Support_F;
	class TFAR_NATO_Radio_Crate: Box_NATO_Support_F
	{
		author="$STR_tfar_core_AUTHORS";
		displayName="$STR_tfar_core_NATO_crate";
		class TransportItems
		{
		};
		class TransportMagazines
		{
		};
		class TransportWeapons
		{
		};
		class TransportBackpacks
		{
			class _xx_TFAR_rt1523g
			{
				backpack="TFAR_rt1523g";
				count=10;
			};
			class _xx_TFAR_rt1523g_big
			{
				backpack="TFAR_rt1523g_big";
				count=3;
			};
			class _xx_TFAR_rt1523g_sage
			{
				backpack="TFAR_rt1523g_sage";
				count=3;
			};
			class _xx_TFAR_rt1523g_green
			{
				backpack="TFAR_rt1523g_green";
				count=3;
			};
			class _xx_TFAR_rt1523g_black
			{
				backpack="TFAR_rt1523g_black";
				count=3;
			};
			class _xx_TFAR_rt1523g_fabric
			{
				backpack="TFAR_rt1523g_fabric";
				count=3;
			};
			class _xx_TFAR_rt1523g_bwmod
			{
				backpack="TFAR_rt1523g_bwmod";
				count=1;
			};
			class _xx_TFAR_rt1523g_big_bwmod
			{
				backpack="TFAR_rt1523g_big_bwmod";
				count=1;
			};
			class _xx_TFAR_rt1523g_big_bwmod_tropen
			{
				backpack="TFAR_rt1523g_big_bwmod_tropen";
				count=1;
			};
			class _xx_TFAR_rt1523g_big_rhs
			{
				backpack="TFAR_rt1523g_big_rhs";
				count=1;
			};
			class _xx_TFAR_rt1523g_rhs
			{
				backpack="TFAR_rt1523g_rhs";
				count=1;
			};
		};
	};
	class TF_NATO_Radio_Crate: TFAR_NATO_Radio_Crate
	{
		scope=1;
		scopeCurator=1;
		scopeArsenal=1;
		displayName="TF_NATO_Radio_Crate : TFAR_NATO_Radio_Crate deprecated item";
	};
	class Box_EAST_Support_F;
	class TFAR_EAST_Radio_Crate: Box_EAST_Support_F
	{
		author="$STR_tfar_core_AUTHORS";
		displayName="$STR_tfar_core_EAST_crate";
		class TransportItems
		{
		};
		class TransportMagazines
		{
		};
		class TransportWeapons
		{
		};
		class TransportBackpacks
		{
			class _xx_TFAR_mr3000
			{
				backpack="TFAR_mr3000";
				count=10;
			};
			class _xx_TFAR_mr3000_multicam
			{
				backpack="TFAR_mr3000_multicam";
				count=3;
			};
			class _xx_TFAR_mr3000_bwmod
			{
				backpack="TFAR_mr3000_bwmod";
				count=1;
			};
			class _xx_TFAR_mr3000_bwmod_tropen
			{
				backpack="TFAR_mr3000_bwmod_tropen";
				count=1;
			};
			class _xx_TFAR_mr3000_rhs
			{
				backpack="TFAR_mr3000_rhs";
				count=1;
			};
			class _xx_TFAR_bussole
			{
				backpack="TFAR_bussole";
				count=3;
			};
		};
	};
	class TF_EAST_Radio_Crate: TFAR_EAST_Radio_Crate
	{
		scope=1;
		scopeCurator=1;
		scopeArsenal=1;
		displayName="TF_EAST_Radio_Crate : TFAR_EAST_Radio_Crate deprecated item";
	};
	class Box_IND_Support_F;
	class TFAR_IND_Radio_Crate: Box_IND_Support_F
	{
		author="$STR_tfar_core_AUTHORS";
		displayName="$STR_tfar_core_IND_crate";
		class TransportItems
		{
		};
		class TransportMagazines
		{
		};
		class TransportWeapons
		{
		};
		class TransportBackpacks
		{
			class _xx_TFAR_anprc155
			{
				backpack="TFAR_anprc155";
				count=10;
			};
			class _xx_TFAR_anprc155_coyote
			{
				backpack="TFAR_anprc155_coyote";
				count=10;
			};
		};
	};
	class TF_IND_Radio_Crate: TFAR_IND_Radio_Crate
	{
		scope=1;
		scopeCurator=1;
		scopeArsenal=1;
		displayName="TF_IND_Radio_Crate : TFAR_IND_Radio_Crate deprecated item";
	};
};
class RscBackPicture;
class RscEditLCD;
class HiddenButton;
class HiddenRotator;
class HiddenFlip;
class anarc164_radio_dialog
{
	idd=3174;
	movingEnable=1;
	controlsBackground[]={};
	onUnload="['OnRadioOpen', [player, TF_lr_dialog_radio, true, 'anarc164_radio_dialog', false]] call TFAR_fnc_fireEventHandlers;";
	objects[]={};
	controls[]=
	{
		"background",
		"enter",
		"channel_edit",
		"edit",
		"clear",
		"prev_channel",
		"increase_volume",
		"stereo",
		"additional",
		"speakers"
	};
	class background: RscBackPicture
	{
		idc=67676;
		text="\z\tfar\addons\backpacks\anarc164\ui\anarc164.paa";
		x="0.0413536 * safezoneW + safezoneX";
		y="0.0434751 * safezoneH + safezoneY";
		w="0.431062 * safezoneW";
		h="0.7513 * safezoneH";
		moving=1;
	};
	class channel_edit: RscEditLCD
	{
		idc=1411;
		x="0.288078 * safezoneW + safezoneX";
		y="0.2382 * safezoneH + safezoneY";
		w="0.0324844 * safezoneW";
		h="0.0374 * safezoneH";
		colorText[]={1,0.5,0,1};
		colorBackground[]={0,0,0,0};
		colorActive[]={0,1,0,1};
		font="TFAR_font_segments";
		shadow=1;
		sizeEx="(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.2)";
		tooltip="$STR_tfar_core_current_channel";
		canModify=0;
	};
	class edit: RscEditLCD
	{
		idc=1410;
		x="0.201969 * safezoneW + safezoneX";
		y="0.3515 * safezoneH + safezoneY";
		w="0.0995156 * safezoneW";
		h="0.0352 * safezoneH";
		colorText[]={1,0.5,0,1};
		colorBackground[]={0,0,0,0};
		colorActive[]={0,0,0,1};
		font="TFAR_font_segments";
		shadow=1;
		sizeEx="(((((safezoneW / safezoneH) min 1.2) / 1.2) / 23) * 1.2)";
		tooltip="$STR_tfar_core_current_freq";
		canModify=1;
		onKeyUp="if (_this select 1 in [28,156]) then { [((ctrlParent (_this select 0))) displayCtrl 1410] call TFAR_backpacks_fnc_onButtonClick_Enter; };";
	};
	class enter: HiddenRotator
	{
		idc=3575;
		x="0.233422 * safezoneW + safezoneX";
		y="0.4373 * safezoneH + safezoneY";
		w="0.037125 * safezoneW";
		h="0.0693 * safezoneH";
		tooltip="$STR_tfar_core_set_frequency";
		onButtonClick="playSound 'TFAR_rotatorPush'; [((ctrlParent (_this select 0))) displayCtrl 1410] call TFAR_backpacks_fnc_onButtonClick_Enter;";
		action="";
	};
	class clear: HiddenRotator
	{
		idc=3576;
		x="0.168453 * safezoneW + safezoneX";
		y="0.4362 * safezoneH + safezoneY";
		w="0.0376406 * safezoneW";
		h="0.0715 * safezoneH";
		tooltip="$STR_tfar_core_clear_frequency";
		action="playSound 'TFAR_rotatorPush'; ctrlSetText [1410,'']; ctrlSetFocus ((findDisplay 3174) displayCtrl 1410);";
	};
	class prev_channel: HiddenRotator
	{
		idc=3577;
		x="0.297875 * safezoneW + safezoneX";
		y="0.4384 * safezoneH + safezoneY";
		w="0.0360937 * safezoneW";
		h="0.0671 * safezoneH";
		tooltip="$STR_tfar_core_rotator_channel";
		onMouseButtonDown="[_this select 1, true, '%1'] call TFAR_fnc_setChannelViaDialog;";
	};
	class increase_volume: HiddenRotator
	{
		idc=3579;
		x="0.239094 * safezoneW + safezoneX";
		y="0.5451 * safezoneH + safezoneY";
		w="0.02475 * safezoneW";
		h="0.0462 * safezoneH";
		tooltip="$STR_tfar_core_rotator_volume";
		onMouseButtonDown="[_this select 1, true] call TFAR_fnc_setVolumeViaDialog;";
	};
	class stereo: HiddenRotator
	{
		idc=3580;
		x="0.115344 * safezoneW + safezoneX";
		y="0.566 * safezoneH + safezoneY";
		w="0.0665527 * safezoneW";
		h="0.110006 * safezoneH";
		action="playSound 'TFAR_rotatorPush'; [TF_lr_dialog_radio,((TF_lr_dialog_radio call TFAR_fnc_getCurrentLrStereo) + 1) mod 3] call TFAR_fnc_setLrStereo; [TF_lr_dialog_radio] call TFAR_fnc_showRadioVolume;";
		tooltip="$STR_tfar_core_stereo_settings";
	};
	class additional: HiddenRotator
	{
		idc=12345;
		x="0.103008 * safezoneW + safezoneX";
		y="0.434185 * safezoneH + safezoneY";
		w="0.0374025 * safezoneW";
		h="0.0700156 * safezoneH";
		tooltip="$STR_tfar_core_set_additional";
		action="playSound 'TFAR_rotatorPush';[TF_lr_dialog_radio,TF_lr_dialog_radio call TFAR_fnc_getLrChannel] call TFAR_fnc_setAdditionalLrChannel;call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
	};
	class speakers: HiddenFlip
	{
		idc=123456;
		x="0.27633 * safezoneW + safezoneX";
		y="0.630886 * safezoneH + safezoneY";
		w="0.0293761 * safezoneW";
		h="0.0406957 * safezoneH";
		tooltip="$STR_tfar_core_speakers_settings_true";
		action="TF_lr_dialog_radio call TFAR_fnc_setLrSpeakers;[TF_lr_dialog_radio] call TFAR_fnc_showRadioSpeakers;";
	};
};
class anarc210_radio_dialog
{
	idd=8423;
	movingEnable=1;
	controlsBackground[]={};
	objects[]={};
	onUnload="['OnRadioOpen', [player, TF_lr_dialog_radio, true, 'anarc210_radio_dialog', false]] call TFAR_fnc_fireEventHandlers;";
	controls[]=
	{
		"background",
		"channel_edit",
		"edit",
		"enter",
		"clear",
		"increase_volume",
		"stereo",
		"channel_01",
		"channel_02",
		"channel_03",
		"channel_04",
		"channel_05",
		"channel_06",
		"channel_07",
		"channel_08",
		"channel_09",
		"additional",
		"speakers",
		"channel_Switch"
	};
	class background: RscBackPicture
	{
		idc=67676;
		text="\z\tfar\addons\backpacks\anarc210\ui\anarc210.paa";
		x="0.0880156 * safezoneW + safezoneX";
		y="-0.1677 * safezoneH + safezoneY";
		w="0.634594 * safezoneW";
		h="1.10205 * safezoneH";
		moving=1;
	};
	class channel_edit: RscEditLCD
	{
		idc=1411;
		text="";
		x="0.360781 * safezoneW + safezoneX";
		y="0.2305 * safezoneH + safezoneY";
		w="0.0485625 * safezoneW";
		h="0.0658147 * safezoneH";
		colorBackground[]={0,0,0,0};
		colorText[]={1,0.5,0,1};
		font="TFAR_font_segments";
		shadow=1;
		sizeEx="(((((safezoneW / safezoneH) min 1.2) / 1.2) / 32) * 1.2)";
		tooltip="$STR_tfar_core_current_channel";
		canModify=0;
	};
	class edit: RscEditLCD
	{
		idc=1410;
		text="";
		x="0.4093435 * safezoneW + safezoneX";
		y="0.2305 * safezoneH + safezoneY";
		w="0.0585934 * safezoneW";
		h="0.0682 * safezoneH";
		colorBackground[]={0,0,0,0};
		colorText[]={1,0.5,0,1};
		font="TFAR_font_segments";
		shadow=1;
		sizeEx="(((((safezoneW / safezoneH) min 1.2) / 1.2) / 32) * 1.2)";
		tooltip="$STR_tfar_core_current_freq";
		canModify=1;
		onKeyUp="if (_this select 1 in [28,156]) then { [((ctrlParent (_this select 0))) displayCtrl 1410] call TFAR_backpacks_fnc_onButtonClick_Enter; };";
	};
	class enter: HiddenButton
	{
		idc=3552;
		x="0.490203 * safezoneW + safezoneX";
		y="0.3394 * safezoneH + safezoneY";
		w="0.03 * safezoneW";
		h="0.05 * safezoneH";
		tooltip="$STR_tfar_core_set_frequency";
		onButtonClick="[((ctrlParent (_this select 0))) displayCtrl 1410] call TFAR_backpacks_fnc_onButtonClick_Enter;";
		action="";
	};
	class clear: HiddenButton
	{
		idc=3553;
		x="0.354078 * safezoneW + safezoneX";
		y="0.522 * safezoneH + safezoneY";
		w="0.03 * safezoneW";
		h="0.05 * safezoneH";
		tooltip="$STR_tfar_core_clear_frequency";
		action="ctrlSetText [1410,'']; ctrlSetFocus ((findDisplay 8423) displayCtrl 1410);";
	};
	class increase_volume: HiddenRotator
	{
		idc=3556;
		x="0.539187 * safezoneW + safezoneX";
		y="0.5176 * safezoneH + safezoneY";
		w="0.04 * safezoneW";
		h="0.06 * safezoneH";
		tooltip="$STR_tfar_core_rotator_volume";
		onMouseButtonDown="[_this select 1,true] call TFAR_fnc_setVolumeViaDialog;";
	};
	class stereo: HiddenButton
	{
		idc=3557;
		x="0.444828 * safezoneW + safezoneX";
		y="0.5253 * safezoneH + safezoneY";
		w="0.03 * safezoneW";
		h="0.05 * safezoneH";
		action="[TF_lr_dialog_radio,((TF_lr_dialog_radio call TFAR_fnc_getCurrentLrStereo) + 1) mod 3] call TFAR_fnc_setLrStereo; [TF_lr_dialog_radio] call TFAR_fnc_showRadioVolume;";
		tooltip="$STR_tfar_core_stereo_settings";
	};
	class channel_01: HiddenButton
	{
		idc=3558;
		x="0.353562 * safezoneW + safezoneX";
		y="0.3394 * safezoneH + safezoneY";
		w="0.0335156 * safezoneW";
		h="0.0484 * safezoneH";
		action="[TF_lr_dialog_radio, 0] call TFAR_fnc_setLrChannel;[""CH%1""] call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_1";
	};
	class channel_02: HiddenButton
	{
		idc=3559;
		x="0.399453 * safezoneW + safezoneX";
		y="0.3416 * safezoneH + safezoneY";
		w="0.0335156 * safezoneW";
		h="0.0484 * safezoneH";
		action="[TF_lr_dialog_radio, 1] call TFAR_fnc_setLrChannel;[""CH%1""] call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_2";
	};
	class channel_03: HiddenButton
	{
		idc=3560;
		x="0.443797 * safezoneW + safezoneX";
		y="0.3416 * safezoneH + safezoneY";
		w="0.0335156 * safezoneW";
		h="0.0484 * safezoneH";
		action="[TF_lr_dialog_radio, 2] call TFAR_fnc_setLrChannel;[""CH%1""] call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_3";
	};
	class channel_04: HiddenButton
	{
		idc=3561;
		x="0.353047 * safezoneW + safezoneX";
		y="0.4032 * safezoneH + safezoneY";
		w="0.0335156 * safezoneW";
		h="0.0484 * safezoneH";
		action="[TF_lr_dialog_radio, 3] call TFAR_fnc_setLrChannel;[""CH%1""] call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_4";
	};
	class channel_05: HiddenButton
	{
		idc=3562;
		x="0.397906 * safezoneW + safezoneX";
		y="0.4021 * safezoneH + safezoneY";
		w="0.0335156 * safezoneW";
		h="0.0484 * safezoneH";
		action="[TF_lr_dialog_radio, 4] call TFAR_fnc_setLrChannel;[""CH%1""] call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_5";
	};
	class channel_06: HiddenButton
	{
		idc=3563;
		x="0.443281 * safezoneW + safezoneX";
		y="0.3999 * safezoneH + safezoneY";
		w="0.0335156 * safezoneW";
		h="0.0484 * safezoneH";
		action="[TF_lr_dialog_radio, 5] call TFAR_fnc_setLrChannel;[""CH%1""] call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_6";
	};
	class channel_07: HiddenButton
	{
		idc=3564;
		x="0.353562 * safezoneW + safezoneX";
		y="0.4637 * safezoneH + safezoneY";
		w="0.0335156 * safezoneW";
		h="0.0484 * safezoneH";
		action="[TF_lr_dialog_radio, 6] call TFAR_fnc_setLrChannel;[""CH%1""] call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_7";
	};
	class channel_08: HiddenButton
	{
		idc=3565;
		x="0.398422 * safezoneW + safezoneX";
		y="0.4659 * safezoneH + safezoneY";
		w="0.0335156 * safezoneW";
		h="0.0484 * safezoneH";
		action="[TF_lr_dialog_radio, 7] call TFAR_fnc_setLrChannel;[""CH%1""] call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_8";
	};
	class channel_09: HiddenButton
	{
		idc=3566;
		x="0.442766 * safezoneW + safezoneX";
		y="0.4659 * safezoneH + safezoneY";
		w="0.0335156 * safezoneW";
		h="0.0484 * safezoneH";
		action="[TF_lr_dialog_radio, 8] call TFAR_fnc_setLrChannel;[""CH%1""] call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_9";
	};
	class channel_Switch: HiddenRotator
	{
		idc=3554;
		x="0.245797 * safezoneW + safezoneX";
		y="0.2547 * safezoneH + safezoneY";
		w="0.0510469 * safezoneW";
		h="0.0957 * safezoneH";
		tooltip="$STR_tfar_core_rotator_channel";
		onMouseButtonDown="[_this select 1, true] call TFAR_fnc_setChannelViaDialog;";
	};
	class additional: HiddenButton
	{
		idc=12345;
		x="0.486594 * safezoneW + safezoneX";
		y="0.4021 * safezoneH + safezoneY";
		w="0.0367463 * safezoneW";
		h="0.0462103 * safezoneH";
		tooltip="$STR_tfar_core_set_additional";
		action="[TF_lr_dialog_radio,TF_lr_dialog_radio call TFAR_fnc_getLrChannel] call TFAR_fnc_setAdditionalLrChannel;call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
	};
	class speakers: HiddenButton
	{
		idc=123456;
		x="0.398422 * safezoneW + safezoneX";
		y="0.5231 * safezoneH + safezoneY";
		w="0.0304219 * safezoneW";
		h="0.0495 * safezoneH";
		tooltip="$STR_tfar_core_speakers_settings_true";
		action="playSound 'TFAR_rotatorPush';TF_lr_dialog_radio call TFAR_fnc_setLrSpeakers;[TF_lr_dialog_radio] call TFAR_fnc_showRadioSpeakers";
	};
};
class anprc155_radio_dialog
{
	idd=7666;
	movingEnable=1;
	controlsBackground[]={};
	objects[]={};
	onUnload="['OnRadioOpen', [player, TF_lr_dialog_radio, true, 'anprc155_radio_dialog', false]] call TFAR_fnc_fireEventHandlers;";
	onLoad="if(sunOrMoon < 0.2) then {((_this select 0) displayCtrl 67676) ctrlSetText '\z\tfar\addons\backpacks\anprc155\ui\155_n.paa';};";
	controls[]=
	{
		"background",
		"enter",
		"channel_edit",
		"edit",
		"clear",
		"prev_channel",
		"next_channel",
		"volume_Switch",
		"stereo",
		"additional",
		"speakers"
	};
	class background: RscBackPicture
	{
		idc=67676;
		text="\z\tfar\addons\backpacks\anprc155\ui\155.paa";
		x="0.0869844 * safezoneW + safezoneX";
		y="-0.1182 * safezoneH + safezoneY";
		w="0.634594 * safezoneW";
		h="1.10205 * safezoneH";
		moving=1;
	};
	class channel_edit: RscEditLCD
	{
		idc=1411;
		x="0.327 * safezoneW + safezoneX";
		y="0.3416 * safezoneH + safezoneY";
		w="0.0485625 * safezoneW";
		h="0.0658147 * safezoneH";
		font="TFAR_font_segments";
		tooltip="$STR_tfar_core_current_channel";
		moving=1;
		canModify=0;
	};
	class edit: RscEditLCD
	{
		idc=1410;
		x="0.374187 * safezoneW + safezoneX";
		y="0.3416 * safezoneH + safezoneY";
		w="0.06 * safezoneW";
		h="0.066 * safezoneH";
		font="TFAR_font_segments";
		tooltip="$STR_tfar_core_current_freq";
		moving=1;
		canModify=1;
		onKeyUp="if (_this select 1 in [28,156]) then { [((ctrlParent (_this select 0))) displayCtrl 1410] call TFAR_backpacks_fnc_onButtonClick_Enter; };";
	};
	class enter: HiddenButton
	{
		idc=3606;
		x="0.4175 * safezoneW + safezoneX";
		y="0.5066 * safezoneH + safezoneY";
		w="0.0185625 * safezoneW";
		h="0.0209 * safezoneH";
		tooltip="$STR_tfar_core_set_frequency";
		onButtonClick="[((ctrlParent (_this select 0))) displayCtrl 1410] call TFAR_backpacks_fnc_onButtonClick_Enter;";
		action="";
	};
	class clear: HiddenButton
	{
		idc=3607;
		x="0.408781 * safezoneW + safezoneX";
		y="0.473394 * safezoneH + safezoneY";
		w="0.0180469 * safezoneW";
		h="0.0286 * safezoneH";
		tooltip="$STR_tfar_core_clear_frequency";
		action="ctrlSetText [1410,'']; ctrlSetFocus ((findDisplay 7666) displayCtrl 1410);";
	};
	class prev_channel: HiddenButton
	{
		idc=3608;
		x="0.362844 * safezoneW + safezoneX";
		y="0.537808 * safezoneH + safezoneY";
		w="0.02625 * safezoneW";
		h="0.0294066 * safezoneH";
		tooltip="$STR_tfar_core_previous_channel";
		action="[0, true] call TFAR_fnc_setChannelViaDialog;";
	};
	class next_channel: HiddenButton
	{
		idc=3609;
		x="0.362844 * safezoneW + safezoneX";
		y="0.470593 * safezoneH + safezoneY";
		w="0.0249375 * safezoneW";
		h="0.0280062 * safezoneH";
		tooltip="$STR_tfar_core_next_channel";
		action="[1, true] call TFAR_fnc_setChannelViaDialog;";
	};
	class volume_Switch: HiddenRotator
	{
		idc=3610;
		x="0.224656 * safezoneW + safezoneX";
		y="0.2987 * safezoneH + safezoneY";
		w="0.0458906 * safezoneW";
		h="0.0836 * safezoneH";
		tooltip="$STR_tfar_core_rotator_volume";
		onMouseButtonDown="[_this select 1, true] call TFAR_fnc_setVolumeViaDialog;";
	};
	class stereo: HiddenButton
	{
		idc=3611;
		x="0.324687 * safezoneW + safezoneX";
		y="0.5363 * safezoneH + safezoneY";
		w="0.0180469 * safezoneW";
		h="0.0275 * safezoneH";
		action="[TF_lr_dialog_radio,((TF_lr_dialog_radio call TFAR_fnc_getCurrentLrStereo) + 1) mod 3] call TFAR_fnc_setLrStereo; [TF_lr_dialog_radio] call TFAR_fnc_showRadioVolume;";
		tooltip="$STR_tfar_core_stereo_settings";
	};
	class additional: HiddenButton
	{
		idc=12345;
		x="0.315406 * safezoneW + safezoneX";
		y="0.5055 * safezoneH + safezoneY";
		w="0.0190781 * safezoneW";
		h="0.0275 * safezoneH";
		tooltip="$STR_tfar_core_set_additional";
		action="[TF_lr_dialog_radio,TF_lr_dialog_radio call TFAR_fnc_getLrChannel] call TFAR_fnc_setAdditionalLrChannel; call TFAR_fnc_updateLRDialogToChannel; [TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
	};
	class speakers: HiddenButton
	{
		idc=123456;
		x="0.408219 * safezoneW + safezoneX";
		y="0.5374 * safezoneH + safezoneY";
		w="0.0190781 * safezoneW";
		h="0.0242 * safezoneH";
		tooltip="$STR_tfar_core_speakers_settings_true";
		action="TF_lr_dialog_radio call TFAR_fnc_setLrSpeakers;[TF_lr_dialog_radio] call TFAR_fnc_showRadioSpeakers;";
	};
};
class bussole_radio_dialog
{
	idd=8666;
	movingEnable=1;
	controlsBackground[]={};
	objects[]={};
	onUnload="['OnRadioOpen', [player, TF_lr_dialog_radio, true, 'bussole_radio_dialog', false]] call TFAR_fnc_fireEventHandlers;";
	onLoad="if(sunOrMoon < 0.2) then {((_this select 0) displayCtrl 67676) ctrlSetText '\z\tfar\addons\backpacks\bussole\ui\bussole_n.paa';};";
	controls[]=
	{
		"background",
		"enter",
		"channel_edit",
		"edit",
		"clear",
		"prev_channel",
		"next_channel",
		"volume_Switch",
		"stereo",
		"additional",
		"speakers",
		"channel_01",
		"channel_02",
		"channel_03",
		"channel_04",
		"channel_05",
		"channel_06",
		"channel_07",
		"channel_08",
		"channel_09"
	};
	class background: RscBackPicture
	{
		idc=67676;
		text="\z\tfar\addons\backpacks\bussole\ui\bussole.paa";
		x="0.0864688 * safezoneW + safezoneX";
		y="-0.1182 * safezoneH + safezoneY";
		w="0.634594 * safezoneW";
		h="1.10205 * safezoneH";
		moving=1;
	};
	class channel_edit: RscEditLCD
	{
		idc=1411;
		x="0.324781 * safezoneW + safezoneX";
		y="0.291915 * safezoneH + safezoneY";
		w="0.05775 * safezoneW";
		h="0.1155 * safezoneH";
		font="TFAR_font_segments";
		tooltip="$STR_tfar_core_current_channel";
		moving=1;
		canModify=0;
		sizeEx=0.059999999;
	};
	class edit: RscEditLCD
	{
		idc=1410;
		x="0.375218 * safezoneW + safezoneX";
		y="0.2921 * safezoneH + safezoneY";
		w="0.0546562 * safezoneW";
		h="0.1155 * safezoneH";
		font="TFAR_font_segments";
		tooltip="$STR_tfar_core_current_freq";
		moving=1;
		canModify=1;
		sizeEx=0.059999999;
		onKeyUp="if (_this select 1 in [28,156]) then { [((ctrlParent (_this select 0))) displayCtrl 1410] call TFAR_backpacks_fnc_onButtonClick_Enter; };";
	};
	class enter: HiddenButton
	{
		idc=8667;
		x="0.469578 * safezoneW + safezoneX";
		y="0.5616 * safezoneH + safezoneY";
		w="0.0211406 * safezoneW";
		h="0.0286 * safezoneH";
		tooltip="$STR_tfar_core_set_frequency";
		onButtonClick="[((ctrlParent (_this select 0))) displayCtrl 1410] call TFAR_backpacks_fnc_onButtonClick_Enter;";
		action="";
	};
	class clear: HiddenButton
	{
		idc=8668;
		x="0.470094 * safezoneW + safezoneX";
		y="0.5209 * safezoneH + safezoneY";
		w="0.020625 * safezoneW";
		h="0.0286 * safezoneH";
		tooltip="$STR_tfar_core_clear_frequency";
		action="ctrlSetText [1410,'']; ctrlSetFocus ((findDisplay 8666) displayCtrl 1410);";
	};
	class prev_channel: HiddenButton
	{
		idc=8669;
		x="0.440187 * safezoneW + safezoneX";
		y="0.5627 * safezoneH + safezoneY";
		w="0.0216562 * safezoneW";
		h="0.0275 * safezoneH";
		tooltip="$STR_tfar_core_previous_channel";
		action="[0, true] call TFAR_fnc_setChannelViaDialog;";
	};
	class next_channel: HiddenButton
	{
		idc=8670;
		x="0.439672 * safezoneW + safezoneX";
		y="0.5209 * safezoneH + safezoneY";
		w="0.0226875 * safezoneW";
		h="0.0275 * safezoneH";
		tooltip="$STR_tfar_core_next_channel";
		action="[1, true] call TFAR_fnc_setChannelViaDialog;";
	};
	class volume_Switch: HiddenRotator
	{
		idc=8671;
		x="0.315922 * safezoneW + safezoneX";
		y="0.5209 * safezoneH + safezoneY";
		w="0.0216562 * safezoneW";
		h="0.0286 * safezoneH";
		tooltip="$STR_tfar_core_rotator_volume";
		onMouseButtonDown="[_this select 1, true] call TFAR_fnc_setVolumeViaDialog;";
	};
	class stereo: HiddenButton
	{
		idc=8672;
		x="0.315922 * safezoneW + safezoneX";
		y="0.5605 * safezoneH + safezoneY";
		w="0.0211406 * safezoneW";
		h="0.0308 * safezoneH";
		action="[TF_lr_dialog_radio, ((TF_lr_dialog_radio call TFAR_fnc_getCurrentLrStereo) + 1) mod TFAR_MAX_STEREO] call TFAR_fnc_setLrStereo;[TF_lr_dialog_radio] call TFAR_fnc_showRadioVolume;";
		tooltip="$STR_tfar_core_stereo_settings";
	};
	class additional: HiddenButton
	{
		idc=12345;
		x="0.469062 * safezoneW + safezoneX";
		y="0.4747 * safezoneH + safezoneY";
		w="0.0216562 * safezoneW";
		h="0.0297 * safezoneH";
		tooltip="$STR_tfar_core_set_additional";
		action="[TF_lr_dialog_radio,TF_lr_dialog_radio call TFAR_fnc_getLrChannel] call TFAR_fnc_setAdditionalLrChannel; call TFAR_fnc_updateLRDialogToChannel; [TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
	};
	class speakers: HiddenButton
	{
		idc=123456;
		x="0.440187 * safezoneW + safezoneX";
		y="0.4769 * safezoneH + safezoneY";
		w="0.0216562 * safezoneW";
		h="0.0275 * safezoneH";
		tooltip="$STR_tfar_core_speakers_settings_true";
		action="TF_lr_dialog_radio call TFAR_fnc_setLrSpeakers;[TF_lr_dialog_radio] call TFAR_fnc_showRadioSpeakers;";
	};
	class channel_01: HiddenButton
	{
		idc=8673;
		x="0.345828 * safezoneW + safezoneX";
		y="0.4747 * safezoneH + safezoneY";
		w="0.0216562 * safezoneW";
		h="0.0297 * safezoneH";
		action="[TF_lr_dialog_radio, 0] call TFAR_fnc_setLrChannel; [""CH%1""] call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_1";
	};
	class channel_02: HiddenButton
	{
		idc=8674;
		x="0.37625 * safezoneW + safezoneX";
		y="0.4758 * safezoneH + safezoneY";
		w="0.0216562 * safezoneW";
		h="0.0297 * safezoneH";
		action="[TF_lr_dialog_radio, 1] call TFAR_fnc_setLrChannel; [""CH%1""] call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_2";
	};
	class channel_03: HiddenButton
	{
		idc=8675;
		x="0.40925 * safezoneW + safezoneX";
		y="0.4758 * safezoneH + safezoneY";
		w="0.0216562 * safezoneW";
		h="0.0297 * safezoneH";
		action="[TF_lr_dialog_radio, 2] call TFAR_fnc_setLrChannel; [""PRE %1""] call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_3";
	};
	class channel_04: HiddenButton
	{
		idc=8676;
		x="0.345312 * safezoneW + safezoneX";
		y="0.5198 * safezoneH + safezoneY";
		w="0.0221719 * safezoneW";
		h="0.0308 * safezoneH";
		action="[TF_lr_dialog_radio, 3] call TFAR_fnc_setLrChannel; [""PRE %1""] call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_4";
	};
	class channel_05: HiddenButton
	{
		idc=8677;
		x="0.376766 * safezoneW + safezoneX";
		y="0.5198 * safezoneH + safezoneY";
		w="0.0216562 * safezoneW";
		h="0.0297 * safezoneH";
		action="[TF_lr_dialog_radio, 4] call TFAR_fnc_setLrChannel; [""PRE %1""] call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_5";
	};
	class channel_06: HiddenButton
	{
		idc=8678;
		x="0.40925 * safezoneW + safezoneX";
		y="0.5198 * safezoneH + safezoneY";
		w="0.0216562 * safezoneW";
		h="0.0297 * safezoneH";
		action="[TF_lr_dialog_radio, 5] call TFAR_fnc_setLrChannel; [""PRE %1""] call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_6";
	};
	class channel_07: HiddenButton
	{
		idc=8679;
		x="0.345828 * safezoneW + safezoneX";
		y="0.5605 * safezoneH + safezoneY";
		w="0.0216562 * safezoneW";
		h="0.0297 * safezoneH";
		action="[TF_lr_dialog_radio, 6] call TFAR_fnc_setLrChannel; [""PRE %1""] call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_7";
	};
	class channel_08: HiddenButton
	{
		idc=8680;
		x="0.37625 * safezoneW + safezoneX";
		y="0.5605 * safezoneH + safezoneY";
		w="0.0216562 * safezoneW";
		h="0.0297 * safezoneH";
		action="[TF_lr_dialog_radio, 7] call TFAR_fnc_setLrChannel; [""PRE %1""] call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_8";
	};
	class channel_09: HiddenButton
	{
		idc=8681;
		x="0.409766 * safezoneW + safezoneX";
		y="0.5616 * safezoneH + safezoneY";
		w="0.0216562 * safezoneW";
		h="0.0297 * safezoneH";
		action="[TF_lr_dialog_radio, 8] call TFAR_fnc_setLrChannel; [""PRE %1""] call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_9";
	};
};
class mr3000_radio_dialog
{
	idd=1998;
	movingEnable=1;
	controlsBackground[]={};
	objects[]={};
	onUnload="['OnRadioOpen', [player, TF_lr_dialog_radio, true, 'mr3000_radio_dialog', false]] call TFAR_fnc_fireEventHandlers;";
	onLoad="if (sunOrMoon < 0.2) then {((_this select 0) displayCtrl 67676) ctrlSetText '\z\tfar\addons\backpacks\mr3000\ui\mr3000_n.paa';};";
	controls[]=
	{
		"background",
		"enter",
		"clear",
		"next_channel",
		"previous_channel",
		"increase_volume",
		"decrease_volume",
		"volume_switch",
		"channel_1",
		"channel_2",
		"channel_3",
		"channel_4",
		"channel_5",
		"channel_6",
		"channel_7",
		"channel_8",
		"channel_9",
		"edit",
		"channel_edit",
		"stereo",
		"additional",
		"channel_switch",
		"speakers"
	};
	class background: RscBackPicture
	{
		idc=67676;
		text="\z\tfar\addons\backpacks\mr3000\ui\mr3000.paa";
		x="0.0993594 * safezoneW + safezoneX";
		y="0.1722 * safezoneH + safezoneY";
		w="0.66825 * safezoneW";
		h="0.5962 * safezoneH";
		moving=1;
	};
	class enter: HiddenButton
	{
		idc=2392;
		x="0.562391 * safezoneW + safezoneX";
		y="0.4208 * safezoneH + safezoneY";
		w="0.0223125 * safezoneW";
		h="0.0308069 * safezoneH";
		tooltip="$STR_tfar_core_set_frequency";
		onButtonClick="[((ctrlParent (_this select 0))) displayCtrl 1410] call TFAR_backpacks_fnc_onButtonClick_Enter;";
		action="";
	};
	class clear: HiddenButton
	{
		idc=2393;
		x="0.562391 * safezoneW + safezoneX";
		y="0.3548 * safezoneH + safezoneY";
		w="0.0223125 * safezoneW";
		h="0.0308069 * safezoneH";
		tooltip="$STR_tfar_core_clear_frequency";
		action="ctrlSetText [1410,'']; ctrlSetFocus ((findDisplay 1998) displayCtrl 1410);";
	};
	class next_channel: HiddenButton
	{
		idc=2394;
		x="0.568062 * safezoneW + safezoneX";
		y="0.5396 * safezoneH + safezoneY";
		w="0.0190313 * safezoneW";
		h="0.0280062 * safezoneH";
		tooltip="$STR_tfar_core_next_channel";
		action="[1, true] call TFAR_fnc_setChannelViaDialog;";
	};
	class previous_channel: HiddenButton
	{
		idc=2395;
		x="0.529391 * safezoneW + safezoneX";
		y="0.5374 * safezoneH + safezoneY";
		w="0.0203438 * safezoneW";
		h="0.0280062 * safezoneH";
		tooltip="$STR_tfar_core_previous_channel";
		action="[0, true] call TFAR_fnc_setChannelViaDialog;";
	};
	class increase_volume: HiddenButton
	{
		idc=2396;
		x="0.550531 * safezoneW + safezoneX";
		y="0.4989 * safezoneH + safezoneY";
		w="0.0190313 * safezoneW";
		h="0.0294066 * safezoneH";
		tooltip="$STR_tfar_core_increase_volume";
		action="[1, true] call TFAR_fnc_setVolumeViaDialog;";
	};
	class decrease_volume: HiddenButton
	{
		idc=2397;
		x="0.548469 * safezoneW + safezoneX";
		y="0.5726 * safezoneH + safezoneY";
		w="0.021 * safezoneW";
		h="0.0266059 * safezoneH";
		action="[0, true] call TFAR_fnc_setVolumeViaDialog;";
		tooltip="$STR_tfar_core_decrease_volume";
	};
	class channel_1: HiddenButton
	{
		idc=2399;
		x="0.365422 * safezoneW + safezoneX";
		y="0.4989 * safezoneH + safezoneY";
		w="0.0190313 * safezoneW";
		h="0.0322072 * safezoneH";
		action="[TF_lr_dialog_radio, 0] call TFAR_fnc_setLrChannel;call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_1";
	};
	class channel_2: HiddenButton
	{
		idc=2400;
		x="0.397906 * safezoneW + safezoneX";
		y="0.5011 * safezoneH + safezoneY";
		w="0.0223125 * safezoneW";
		h="0.0294066 * safezoneH";
		action="[TF_lr_dialog_radio, 1] call TFAR_fnc_setLrChannel; call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_2";
	};
	class channel_3: HiddenButton
	{
		idc=2401;
		x="0.432453 * safezoneW + safezoneX";
		y="0.5 * safezoneH + safezoneY";
		w="0.0203438 * safezoneW";
		h="0.0322072 * safezoneH";
		action="[TF_lr_dialog_radio, 2] call TFAR_fnc_setLrChannel; call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_3";
	};
	class channel_4: HiddenButton
	{
		idc=2402;
		x="0.465453 * safezoneW + safezoneX";
		y="0.4989 * safezoneH + safezoneY";
		w="0.021 * safezoneW";
		h="0.0308069 * safezoneH";
		action="[TF_lr_dialog_radio, 3] call TFAR_fnc_setLrChannel; call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_4";
	};
	class channel_5: HiddenButton
	{
		idc=2403;
		x="0.497937 * safezoneW + safezoneX";
		y="0.5011 * safezoneH + safezoneY";
		w="0.0223125 * safezoneW";
		h="0.0322072 * safezoneH";
		action="[TF_lr_dialog_radio, 4] call TFAR_fnc_setLrChannel; call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_5";
	};
	class channel_6: HiddenButton
	{
		idc=2404;
		x="0.365937 * safezoneW + safezoneX";
		y="0.5561 * safezoneH + safezoneY";
		w="0.021 * safezoneW";
		h="0.0294066 * safezoneH";
		action="[TF_lr_dialog_radio, 5] call TFAR_fnc_setLrChannel; call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_6";
	};
	class channel_7: HiddenButton
	{
		idc=2405;
		x="0.399969 * safezoneW + safezoneX";
		y="0.555 * safezoneH + safezoneY";
		w="0.021 * safezoneW";
		h="0.0294066 * safezoneH";
		action="[TF_lr_dialog_radio, 6] call TFAR_fnc_setLrChannel; call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_7";
	};
	class channel_8: HiddenButton
	{
		idc=2406;
		x="0.431937 * safezoneW + safezoneX";
		y="0.5539 * safezoneH + safezoneY";
		w="0.021 * safezoneW";
		h="0.0294066 * safezoneH";
		action="[TF_lr_dialog_radio, 7] call TFAR_fnc_setLrChannel; call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_8";
	};
	class channel_9: HiddenButton
	{
		idc=2407;
		x="0.464937 * safezoneW + safezoneX";
		y="0.555 * safezoneH + safezoneY";
		w="0.021 * safezoneW";
		h="0.0294066 * safezoneH";
		action="[TF_lr_dialog_radio, 8] call TFAR_fnc_setLrChannel; call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_9";
	};
	class edit: RscEditLCD
	{
		idc=1410;
		x="0.459266 * safezoneW + safezoneX";
		y="0.3768 * safezoneH + safezoneY";
		w="0.0531563 * safezoneW";
		h="0.03 * safezoneH";
		font="TFAR_font_dots";
		shadow=1;
		sizeEx="(((((safezoneW / safezoneH) min 1.2) / 1.2) / 30) * 1.2)";
		tooltip="$STR_tfar_core_current_freq";
		canModify=1;
		onKeyUp="if (_this select 1 in [28,156]) then { [((ctrlParent (_this select 0))) displayCtrl 1410] call TFAR_backpacks_fnc_onButtonClick_Enter; };";
	};
	class channel_edit: RscEditLCD
	{
		idc=1411;
		x="0.416469 * safezoneW + safezoneX";
		y="0.3768 * safezoneH + safezoneY";
		w="0.0427969 * safezoneW";
		h="0.0297 * safezoneH";
		font="TFAR_font_dots";
		shadow=1;
		sizeEx="(((((safezoneW / safezoneH) min 1.2) / 1.2) / 30) * 1.2)";
		tooltip="$STR_tfar_core_current_channel";
		canModify=0;
	};
	class stereo: HiddenButton
	{
		idc=2408;
		x="0.499484 * safezoneW + safezoneX";
		y="0.5572 * safezoneH + safezoneY";
		w="0.0216563 * safezoneW";
		h="0.0308069 * safezoneH";
		action="[TF_lr_dialog_radio,((TF_lr_dialog_radio call TFAR_fnc_getCurrentLrStereo) + 1) mod 3] call TFAR_fnc_setLrStereo; [TF_lr_dialog_radio] call TFAR_fnc_showRadioVolume;";
		tooltip="$STR_tfar_core_stereo_settings";
	};
	class additional: HiddenRotator
	{
		idc=12345;
		x="0.295812 * safezoneW + safezoneX";
		y="0.4197 * safezoneH + safezoneY";
		w="0.0367463 * safezoneW";
		h="0.0812181 * safezoneH";
		tooltip="$STR_tfar_core_set_additional";
		action="playSound 'TFAR_rotatorPush'; [TF_lr_dialog_radio,TF_lr_dialog_radio call TFAR_fnc_getLrChannel] call TFAR_fnc_setAdditionalLrChannel; call TFAR_fnc_updateLRDialogToChannel; [TF_lr_dialog_radio,true] call TFAR_fnc_showRadioInfo;";
	};
	class volume_switch: HiddenRotator
	{
		idc=2398;
		x="0.300453 * safezoneW + safezoneX";
		y="0.3218 * safezoneH + safezoneY";
		w="0.0360938 * safezoneW";
		h="0.0728162 * safezoneH";
		tooltip="$STR_tfar_core_rotator_volume";
		onMouseButtonDown="[_this select 1, true] call TFAR_fnc_setVolumeViaDialog;";
	};
	class channel_switch: HiddenRotator
	{
		idc=2399;
		x="0.292203 * safezoneW + safezoneX";
		y="0.5407 * safezoneH + safezoneY";
		w="0.033499 * safezoneW";
		h="0.0659931 * safezoneH";
		tooltip="$STR_tfar_core_rotator_channel";
		onMouseButtonDown="[_this select 1, true] call TFAR_fnc_setChannelViaDialog;";
	};
	class speakers: HiddenButton
	{
		idc=123456;
		x="0.603125 * safezoneW + safezoneX";
		y="0.5682 * safezoneH + safezoneY";
		w="0.0159844 * safezoneW";
		h="0.0715 * safezoneH";
		tooltip="$STR_tfar_core_speakers_settings_true";
		action="TF_lr_dialog_radio call TFAR_fnc_setLrSpeakers;[TF_lr_dialog_radio] call TFAR_fnc_showRadioSpeakers;";
	};
};
class mr6000l_radio_dialog
{
	idd=20135;
	movingEnable=1;
	controlsBackground[]={};
	objects[]={};
	onUnload="['OnRadioOpen', [player, TF_lr_dialog_radio, true, 'mr6000l_radio_dialog', false]] call TFAR_fnc_fireEventHandlers;";
	controls[]=
	{
		"background",
		"enter",
		"channel_edit",
		"edit",
		"clear",
		"prev_channel",
		"next_channel",
		"increase_volume",
		"stereo",
		"channel_01",
		"channel_02",
		"channel_03",
		"channel_04",
		"channel_05",
		"channel_06",
		"channel_07",
		"channel_08",
		"channel_09",
		"additional",
		"speakers"
	};
	class background: RscBackPicture
	{
		idc=67676;
		text="\z\tfar\addons\backpacks\mr6000l\ui\mr6000l.paa";
		x="0.0413536 * safezoneW + safezoneX";
		y="0.0434751 * safezoneH + safezoneY";
		w="0.533454 * safezoneW";
		h="0.926251 * safezoneH";
		moving=1;
	};
	class channel_edit: RscEditLCD
	{
		idc=1411;
		text="";
		x="0.188905 * safezoneW + safezoneX";
		y="0.396594 * safezoneH + safezoneY";
		w="0.135685 * safezoneW";
		h="0.055003 * safezoneH";
		colorText[]={0,0.94999999,0,1};
		colorBackground[]={0,0,0,0};
		font="TFAR_font_dots";
		shadow=2;
		sizeEx="(((((safezoneW / safezoneH) min 1.2) / 1.2) / 22) * 1.2)";
		tooltip="$STR_tfar_core_current_channel";
		canModify=0;
	};
	class edit: RscEditLCD
	{
		idc=1410;
		x="0.189421 * safezoneW + safezoneX";
		y="0.329491 * safezoneH + safezoneY";
		w="0.136717 * safezoneW";
		h="0.0638035 * safezoneH";
		colorText[]={0,0.94999999,0,1};
		colorBackground[]={0,0,0,0};
		font="TFAR_font_dots";
		shadow=2;
		sizeEx="(((((safezoneW / safezoneH) min 1.2) / 1.2) / 22) * 1.2)";
		tooltip="$STR_tfar_core_current_freq";
		canModify=1;
		onKeyUp="if (_this select 1 in [28,156]) then { [((ctrlParent (_this select 0))) displayCtrl 1410] call TFAR_backpacks_fnc_onButtonClick_Enter; };";
	};
	class enter: HiddenButton
	{
		idc=20536;
		x="0.405588 * safezoneW + safezoneX";
		y="0.610006 * safezoneH + safezoneY";
		w="0.0500435 * safezoneW";
		h="0.0880048 * safezoneH";
		tooltip="$STR_tfar_core_set_frequency";
		onButtonClick="[((ctrlParent (_this select 0))) displayCtrl 1410] call TFAR_backpacks_fnc_onButtonClick_Enter;";
		action="";
	};
	class clear: HiddenButton
	{
		idc=20537;
		x="0.23998 * safezoneW + safezoneX";
		y="0.5011 * safezoneH + safezoneY";
		w="0.03 * safezoneW";
		h="0.05 * safezoneH";
		tooltip="$STR_tfar_core_clear_frequency";
		action="ctrlSetText [1410,'']; ctrlSetFocus ((findDisplay 20135) displayCtrl 1410);";
	};
	class prev_channel: HiddenButton
	{
		idc=20538;
		x="0.347271 * safezoneW + safezoneX";
		y="0.610006 * safezoneH + safezoneY";
		w="0.0495276 * safezoneW";
		h="0.0869047 * safezoneH";
		tooltip="$STR_tfar_core_previous_channel";
		action="[0, true, 'PRE %1'] call TFAR_fnc_setChannelViaDialog;";
	};
	class next_channel: HiddenButton
	{
		idc=20539;
		x="0.461822 * safezoneW + safezoneX";
		y="0.611106 * safezoneH + safezoneY";
		w="0.0500435 * safezoneW";
		h="0.0880048 * safezoneH";
		tooltip="$STR_tfar_core_next_channel";
		action="[1, true, 'PRE %1'] call TFAR_fnc_setChannelViaDialog;";
	};
	class increase_volume: HiddenRotator
	{
		idc=20540;
		x="0.117193 * safezoneW + safezoneX";
		y="0.326191 * safezoneH + safezoneY";
		w="0.0495276 * safezoneW";
		h="0.0803044 * safezoneH";
		tooltip="$STR_tfar_core_rotator_volume";
		onMouseButtonDown="[_this select 1, true] call TFAR_fnc_setVolumeViaDialog;";
	};
	class stereo: HiddenRotator
	{
		idc=20541;
		x="0.114613 * safezoneW + safezoneX";
		y="0.572604 * safezoneH + safezoneY";
		w="0.0665527 * safezoneW";
		h="0.110006 * safezoneH";
		action="playSound 'TFAR_rotatorPush'; [TF_lr_dialog_radio,((TF_lr_dialog_radio call TFAR_fnc_getCurrentLrStereo) + 1) mod 3] call TFAR_fnc_setLrStereo; [TF_lr_dialog_radio] call TFAR_fnc_showRadioVolume;";
		tooltip="$STR_tfar_core_stereo_settings";
	};
	class channel_01: HiddenButton
	{
		idc=20542;
		x="0.347806 * safezoneW + safezoneX";
		y="0.31079 * safezoneH + safezoneY";
		w="0.0469481 * safezoneW";
		h="0.0814044 * safezoneH";
		action="[TF_lr_dialog_radio, 0] call TFAR_fnc_setLrChannel; [""PRE %1""] call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_1";
	};
	class channel_02: HiddenButton
	{
		idc=20543;
		x="0.40662 * safezoneW + safezoneX";
		y="0.30859 * safezoneH + safezoneY";
		w="0.0469481 * safezoneW";
		h="0.0847046 * safezoneH";
		action="[TF_lr_dialog_radio, 1] call TFAR_fnc_setLrChannel; [""PRE %1""] call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_2";
	};
	class channel_03: HiddenButton
	{
		idc=20544;
		x="0.46337 * safezoneW + safezoneX";
		y="0.30969 * safezoneH + safezoneY";
		w="0.0500435 * safezoneW";
		h="0.0847046 * safezoneH";
		action="[TF_lr_dialog_radio, 2] call TFAR_fnc_setLrChannel; [""PRE %1""] call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_3";
	};
	class channel_04: HiddenButton
	{
		idc=20545;
		x="0.348838 * safezoneW + safezoneX";
		y="0.408695 * safezoneH + safezoneY";
		w="0.0479799 * safezoneW";
		h="0.0880048 * safezoneH";
		action="[TF_lr_dialog_radio, 3] call TFAR_fnc_setLrChannel; [""PRE %1""] call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_4";
	};
	class channel_05: HiddenButton
	{
		idc=20546;
		x="0.406104 * safezoneW + safezoneX";
		y="0.410895 * safezoneH + safezoneY";
		w="0.0490117 * safezoneW";
		h="0.0869047 * safezoneH";
		action="[TF_lr_dialog_radio, 4] call TFAR_fnc_setLrChannel; [""PRE %1""] call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_5";
	};
	class channel_06: HiddenButton
	{
		idc=20547;
		x="0.464402 * safezoneW + safezoneX";
		y="0.410895 * safezoneH + safezoneY";
		w="0.0490117 * safezoneW";
		h="0.0869047 * safezoneH";
		action="[TF_lr_dialog_radio, 5] call TFAR_fnc_setLrChannel; [""PRE %1""] call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_6";
	};
	class channel_07: HiddenButton
	{
		idc=20548;
		x="0.347806 * safezoneW + safezoneX";
		y="0.509901 * safezoneH + safezoneY";
		w="0.0479799 * safezoneW";
		h="0.0891049 * safezoneH";
		action="[TF_lr_dialog_radio, 6] call TFAR_fnc_setLrChannel; [""PRE %1""] call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_7";
	};
	class channel_08: HiddenButton
	{
		idc=20549;
		x="0.407652 * safezoneW + safezoneX";
		y="0.511001 * safezoneH + safezoneY";
		w="0.0479799 * safezoneW";
		h="0.0880048 * safezoneH";
		action="[TF_lr_dialog_radio, 7] call TFAR_fnc_setLrChannel; [""PRE %1""] call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_8";
	};
	class channel_09: HiddenButton
	{
		idc=20550;
		x="0.462338 * safezoneW + safezoneX";
		y="0.512101 * safezoneH + safezoneY";
		w="0.053139 * safezoneW";
		h="0.0880048 * safezoneH";
		action="[TF_lr_dialog_radio, 8] call TFAR_fnc_setLrChannel; [""PRE %1""] call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_9";
	};
	class additional: HiddenFlip
	{
		idc=12345;
		x="0.127943 * safezoneW + safezoneX";
		y="0.464992 * safezoneH + safezoneY";
		w="0.0334654 * safezoneW";
		h="0.0560125 * safezoneH";
		tooltip="$STR_tfar_core_set_additional";
		action="[TF_lr_dialog_radio,TF_lr_dialog_radio call TFAR_fnc_getLrChannel] call TFAR_fnc_setAdditionalLrChannel; call TFAR_fnc_updateLRDialogToChannel; [TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
	};
	class speakers: HiddenButton
	{
		idc="IDC_MR6000L_RADIO_DIALOG_SPEAKERS";
		x="0.195417 * safezoneW + safezoneX";
		y="0.584691 * safezoneH + safezoneY";
		w="0.0520523 * safezoneW";
		h="0.085791 * safezoneH";
		tooltip="$STR_tfar_core_speakers_settings_true";
		action="TF_lr_dialog_radio call TFAR_fnc_setLrSpeakers;[TF_lr_dialog_radio] call TFAR_fnc_showRadioSpeakers;";
	};
};
class rt1523g_radio_dialog
{
	idd=1666;
	movingEnable=1;
	controlsBackground[]={};
	objects[]={};
	onUnload="['OnRadioOpen', [player, TF_lr_dialog_radio, true, 'rt1523g_radio_dialog', false]] call TFAR_fnc_fireEventHandlers;";
	onLoad="if (sunOrMoon < 0.2) then {((_this select 0) displayCtrl 67676) ctrlSetText '\z\tfar\addons\backpacks\rt1523g\ui\rt1523g_n.paa';};";
	controls[]=
	{
		"background",
		"enter",
		"edit",
		"channel_edit",
		"clear",
		"channel01",
		"channel02",
		"channel03",
		"channel04",
		"channel05",
		"channel06",
		"channel07",
		"channel08",
		"channel09",
		"increase_volume",
		"decrease_volume",
		"stereo",
		"additional",
		"speakers"
	};
	class background: RscBackPicture
	{
		idc=67676;
		text="\z\tfar\addons\backpacks\rt1523g\ui\rt1523g.paa";
		x="0.0935937 * safezoneW + safezoneX";
		y="0.0252042 * safezoneH + safezoneY";
		w="0.510056 * safezoneW";
		h="0.942975 * safezoneH";
		moving=1;
	};
	class edit: RscEditLCD
	{
		moving=1;
		idc=1410;
		x="0.356037 * safezoneW + safezoneX";
		y="0.363875 * safezoneH + safezoneY";
		w="0.0600188 * safezoneW";
		h="0.055 * safezoneH";
		font="TFAR_font_dots";
		shadow=2;
		tooltip="$STR_tfar_core_current_freq";
		canModify=1;
		onKeyUp="if (_this select 1 in [28,156]) then { [((ctrlParent (_this select 0))) displayCtrl 1410] call TFAR_backpacks_fnc_onButtonClick_Enter; };";
	};
	class channel_edit: RscEditLCD
	{
		moving=1;
		idc=1411;
		x="0.29354 * safezoneW + safezoneX";
		y="0.3636 * safezoneH + safezoneY";
		w="0.0443218 * safezoneW";
		h="0.05335 * safezoneH";
		font="TFAR_font_dots";
		shadow=2;
		tooltip="$STR_tfar_core_current_channel";
		canModify=0;
	};
	class clear: HiddenButton
	{
		idc=1611;
		x="0.263806 * safezoneW + safezoneX";
		y="0.623256 * safezoneH + safezoneY";
		w="0.036975 * safezoneW";
		h="0.0403769 * safezoneH";
		tooltip="$STR_tfar_core_clear_frequency";
		action="ctrlSetText [1410,'']; ctrlSetFocus ((findDisplay 1666) displayCtrl 1410);";
	};
	class enter: HiddenButton
	{
		idc=1610;
		x="0.400869 * safezoneW + safezoneX";
		y="0.470249 * safezoneH + safezoneY";
		w="0.0357 * safezoneW";
		h="0.0378267 * safezoneH";
		tooltip="$STR_tfar_core_set_frequency";
		onButtonClick="[((ctrlParent (_this select 0))) displayCtrl 1410] call TFAR_backpacks_fnc_onButtonClick_Enter;";
		action="";
	};
	class channel01: HiddenButton
	{
		idc=1701;
		x="0.266994 * safezoneW + safezoneX";
		y="0.472799 * safezoneH + safezoneY";
		w="0.0306 * safezoneW";
		h="0.0378267 * safezoneH";
		action="[TF_lr_dialog_radio, 0] call TFAR_fnc_setLrChannel;call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_1";
	};
	class channel02: HiddenButton
	{
		idc=1702;
		x="0.310344 * safezoneW + safezoneX";
		y="0.474499 * safezoneH + safezoneY";
		w="0.0334688 * safezoneW";
		h="0.0365517 * safezoneH";
		action="[TF_lr_dialog_radio, 1] call TFAR_fnc_setLrChannel; call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_2";
	};
	class channel03: HiddenButton
	{
		idc=1703;
		x="0.356881 * safezoneW + safezoneX";
		y="0.475774 * safezoneH + safezoneY";
		w="0.031875 * safezoneW";
		h="0.0340016 * safezoneH";
		action="[TF_lr_dialog_radio, 2] call TFAR_fnc_setLrChannel; call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_3";
	};
	class channel04: HiddenButton
	{
		idc=1704;
		x="0.266356 * safezoneW + safezoneX";
		y="0.525076 * safezoneH + safezoneY";
		w="0.0306 * safezoneW";
		h="0.0314514 * safezoneH";
		action="[TF_lr_dialog_radio, 3] call TFAR_fnc_setLrChannel; call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_4";
	};
	class channel05: HiddenButton
	{
		idc=1705;
		x="0.310344 * safezoneW + safezoneX";
		y="0.525076 * safezoneH + safezoneY";
		w="0.0328313 * safezoneW";
		h="0.0340016 * safezoneH";
		action="[TF_lr_dialog_radio, 4] call TFAR_fnc_setLrChannel; call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_5";
	};
	class channel06: HiddenButton
	{
		idc=1706;
		x="0.357519 * safezoneW + safezoneX";
		y="0.525076 * safezoneH + safezoneY";
		w="0.0306 * safezoneW";
		h="0.0340016 * safezoneH";
		action="[TF_lr_dialog_radio, 5] call TFAR_fnc_setLrChannel; call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_6";
	};
	class channel07: HiddenButton
	{
		idc=1707;
		x="0.266356 * safezoneW + safezoneX";
		y="0.574378 * safezoneH + safezoneY";
		w="0.0312375 * safezoneW";
		h="0.0340016 * safezoneH";
		action="[TF_lr_dialog_radio, 6] call TFAR_fnc_setLrChannel; call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_7";
	};
	class channel08: HiddenButton
	{
		idc=1708;
		x="0.311938 * safezoneW + safezoneX";
		y="0.575653 * safezoneH + safezoneY";
		w="0.0312375 * safezoneW";
		h="0.0327265 * safezoneH";
		action="[TF_lr_dialog_radio, 7] call TFAR_fnc_setLrChannel; call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_8";
	};
	class channel09: HiddenButton
	{
		idc=1709;
		x="0.358156 * safezoneW + safezoneX";
		y="0.574378 * safezoneH + safezoneY";
		w="0.0312375 * safezoneW";
		h="0.0340016 * safezoneH";
		action="[TF_lr_dialog_radio, 8] call TFAR_fnc_setLrChannel; call TFAR_fnc_updateLRDialogToChannel;[TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
		tooltip="$STR_tfar_core_radio_channel_9";
	};
	class increase_volume: HiddenButton
	{
		idc=1612;
		x="0.4031 * safezoneW + safezoneX";
		y="0.576079 * safezoneH + safezoneY";
		w="0.0312375 * safezoneW";
		h="0.0327265 * safezoneH";
		action="[1, true] call TFAR_fnc_setVolumeViaDialog;";
		tooltip="$STR_tfar_core_increase_volume";
	};
	class decrease_volume: HiddenButton
	{
		idc=1613;
		x="0.4031 * safezoneW + safezoneX";
		y="0.628356 * safezoneH + safezoneY";
		w="0.0302813 * safezoneW";
		h="0.0323015 * safezoneH";
		action="[0, true] call TFAR_fnc_setVolumeViaDialog;";
		tooltip="$STR_tfar_core_decrease_volume";
	};
	class stereo: HiddenButton
	{
		idc=1710;
		x="0.357725 * safezoneW + safezoneX";
		y="0.627078 * safezoneH + safezoneY";
		w="0.030975 * safezoneW";
		h="0.0318571 * safezoneH";
		action="[TF_lr_dialog_radio,((TF_lr_dialog_radio call TFAR_fnc_getCurrentLrStereo) + 1) mod 3] call TFAR_fnc_setLrStereo; [TF_lr_dialog_radio] call TFAR_fnc_showRadioVolume;";
		tooltip="$STR_tfar_core_stereo_settings";
	};
	class additional: HiddenButton
	{
		idc=12345;
		x="0.40131 * safezoneW + safezoneX";
		y="0.523805 * safezoneH + safezoneY";
		w="0.035434 * safezoneW";
		h="0.0385086 * safezoneH";
		tooltip="$STR_tfar_core_set_additional";
		action="[TF_lr_dialog_radio,TF_lr_dialog_radio call TFAR_fnc_getLrChannel] call TFAR_fnc_setAdditionalLrChannel; call TFAR_fnc_updateLRDialogToChannel; [TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
	};
	class speakers: HiddenButton
	{
		idc=123456;
		x="0.309932 * safezoneW + safezoneX";
		y="0.622912 * safezoneH + safezoneY";
		w="0.0366943 * safezoneW";
		h="0.0420706 * safezoneH";
		tooltip="$STR_tfar_core_speakers_settings_true";
		action="TF_lr_dialog_radio call TFAR_fnc_setLrSpeakers;[TF_lr_dialog_radio] call TFAR_fnc_showRadioSpeakers;";
	};
};
