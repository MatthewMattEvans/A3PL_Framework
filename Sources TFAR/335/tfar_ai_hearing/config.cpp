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
		version="1.-1.0.335";
		versionStr="1.-1.0.335";
		versionAr[]={1,-1,0,335};
	};
};
class Extended_PreInit_EventHandlers
{
	class tfar_ai_hearing
	{
		init="call compile preprocessFileLineNumbers '\z\tfar\addons\ai_hearing\XEH_PreInit.sqf'";
	};
};
