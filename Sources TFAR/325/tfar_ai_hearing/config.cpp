class CfgPatches
{
	class tfar_ai_hearing
	{
		units[]={};
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
	class tfar_ai_hearing
	{
		init="call compile preProcessFileLineNumbers '\z\tfar\addons\ai_hearing\XEH_PreInit.sqf'";
	};
};
