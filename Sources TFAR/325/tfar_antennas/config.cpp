class CfgPatches
{
	class tfar_antennas
	{
		units[]=
		{
			"TFAR_Land_Communication_F"
		};
		weapons[]={};
		requiredVersion=1.72;
		requiredAddons[]=
		{
			"A3_Modules_F",
			"tfar_core"
		};
		Url="https://github.com/michail-nikolaev/task-force-arma-3-radio";
	};
};
class Extended_PreInit_EventHandlers
{
	class tfar_antennas
	{
		init="call compile preProcessFileLineNumbers '\z\tfar\addons\antennas\XEH_preInit.sqf'";
	};
};
class Extended_InitPost_EventHandlers
{
	class TFAR_Land_Communication_F
	{
		class tfar_antennas
		{
			clientInit="[_this select 0,50000] call tfar_antennas_fnc_initRadioTower";
		};
	};
};
class Extended_Deleted_EventHandlers
{
	class TFAR_Land_Communication_F
	{
		tfar_antennas="(_this param [0,_this]) call tfar_antennas_fnc_deleteRadioTower";
	};
};
class CfgVehicles
{
	class Land_Communication_F;
	class TFAR_Land_Communication_F: Land_Communication_F
	{
		scope=2;
		scopeCurator=2;
		author="$STR_tfar_core_AUTHORS";
		category="TFAR";
		editorCategory="TFAR";
		displayName="$STR_tfar_antennas_TowerName";
	};
};
