/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
/*
	Paramaters:  
	targets[] - the format is {enableServer,enableClient,enableHC}. 1 means enable, 0 means disable. From the above example targets[] = {1,0,1}; means: enable server, disable client, enable HC.
	args[] - the format is {{leftArgumentType},{rightArgumentType}}
*/

class CfgDisabledCommands
{
	class COPYTOCLIPBOARD
	{
		class SYNTAX1
		{
			targets[] = {0, 0, 0};
			args[] = {{}, {"STRING"}};
		};
	};
	class SCREENSHOT
	{
		class SYNTAX1
		{
			targets[] = {0, 0, 0};
			args[] = {{}, {"STRING"}};
		};
	};
	class REMOTECONTROL
	{
		class SYNTAX1
		{
			targets[] = {0, 0, 0};
			args[] = {{"OBJECT"}, {"OBJECT"}};
		};
	};
	class SETWAYPOINTSTATEMENTS
	{
		class SYNTAX1
		{
			targets[] = {0, 0, 0};
			args[] = {{"ARRAY"}, {"ARRAY"}};
		};
	};
	class ALLVARIABLES
	{
		class SYNTAX1
		{
			targets[] = {0, 0, 0};
			args[] = {{}, {"CONTROL"}};
		};

		class SYNTAX2
		{
			targets[] = {0, 0, 0};
			args[] = {{}, {"TEAM_MEMBER"}};
		};

		class SYNTAX3
		{
			targets[] = {1, 0, 1};
			args[] = {{}, {"NAMESPACE"}};
		};

		class SYNTAX4
		{
			targets[] = {1, 1, 1};
			args[] = {{}, {"OBJECT"}};
		};

		class SYNTAX5
		{
			targets[] = {0, 0, 0};
			args[] = {{}, {"GROUP"}};
		};
	};
	class LOADFILE
	{
		class SYNTAX1
		{
			targets[] = {1, 1, 1};
			args[] = {{}, {"STRING"}};
		};
	};
	class SETFRIEND
	{
		class SYNTAX1
		{
			targets[] = {1, 0, 0};
			args[] = {{"SIDE"}, {"ARRAY"}};
		};
	};
	class REMOVEALLACTIONS
	{
		class SYNTAX1
		{
			targets[] = {0, 0, 0};
			args[] = {{}, {"OBJECT"}};
		};
	};
	class REMOVEALLITEMS
	{
		class SYNTAX1
		{
			targets[] = {0, 0, 0};
			args[] = {{}, {"OBJECT"}};
		};
	};
	class REMOVEALLMPEVENTHANDLERS
	{
		class SYNTAX1
		{
			targets[] = {0, 0, 0};
			args[] = {{"OBJECT"}, {"STRING"}};
		};
	};
	class ADDMPEVENTHANDLER
	{
		class SYNTAX1
		{
			targets[] = {1, 0, 1};
			args[] = {{"OBJECT"}, {"ARRAY"}};
		};
	};
	class SERVERCOMMAND
	{
		class SYNTAX1
		{
			targets[] = {1, 0, 1};
			args[] = {{"STRING"}, {"STRING"}};
		};
		class SYNTAX2
		{
			targets[] = {0, 0, 0};
			args[] = {{}, {"STRING"}};
		};
	};
	class SERVERCOMMANDEXECUTABLE
	{
		class SYNTAX1
		{
			targets[] = {0, 0, 0};
			args[] = {{}, {"STRING"}};
		};
	};
	class DRAWLINE
	{
		class SYNTAX1
		{
			targets[] = {1, 1, 1};
			args[] = {{"CONTROL"}, {"ARRAY"}};
		};
	};
	class DRAWLINE3D
	{
		class SYNTAX1
		{
			targets[] = {0, 0, 0};
			args[] = {{}, {"ARRAY"}};
		};
	};
	class ADDFORCE
	{
		class SYNTAX1
		{
			targets[] = {0, 0, 0};
			args[] = {{"OBJECT"}, {"ARRAY"}};
		};
	};
	class SETVEHICLEARMOR
	{
		class SYNTAX1
		{
			targets[] = {0, 0, 0};
			args[] = {{"OBJECT"}, {"SCALAR"}};
		};
	};
	class SETHITINDEX
	{
		class SYNTAX1
		{
			targets[] = {0, 0, 0};
			args[] = {{"OBJECT"}, {"ARRAY"}};
		};
	};
	class SETCENTEROFMASS
	{
		class SYNTAX1
		{
			targets[] = {1, 0, 1};
			args[] = {{"OBJECT"}, {"ARRAY"}};
		};
	};
};
