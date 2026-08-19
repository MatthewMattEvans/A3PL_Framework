/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
class CfgNotification {
	class Patterns {
		class Error {

			defaultTitle = "STR_Mission_Config_Notifications_Error";

			color[] = {1,0.2,0,1};

			sound = "addItemFailed";
		};
		class Successful {
			defaultTitle = "STR_Mission_Config_Notifications_Successful";

			color[] = {0.11,0.663,0.2,1};

			sound = "Orange_PeriodSwitch_Notification";  //EXP_m05_dramatic
		};
		class Accepted {
			defaultTitle = "STR_Mission_Config_Notifications_Accepted";

			color[] = {0.11,0.663,0.2,1};

			sound = "addItemOK";
		};
		class Info {
			defaultTitle = "STR_Mission_Config_Notifications_Information";

			color[] = {0.129,0.482,0.698,1};

			sound = "";
		};
		class InfoWithSound {
			defaultTitle = "STR_Mission_Config_Notifications_Information";

			color[] = {0.129,0.482,0.698,1};

			sound = "Orange_PeriodSwitch_Notification";
		};
		class Warning {
			defaultTitle = "STR_Mission_Config_Notifications_Warning";

			color[] = {1,0.353,0,1};

			sound = "defaultNotification";
		};
	};	
};