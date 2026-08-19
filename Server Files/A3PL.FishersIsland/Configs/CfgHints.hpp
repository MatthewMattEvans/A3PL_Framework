/*
    Code written by NORTHBRIDGE INTERACTIVE
	58, RUE DE MONCEAU, 75008 PARIS, FRANCE
	SIRET : 93008862000016 
    @Copyright NORTHBRIDGE INTERACTIVE (https://northbridgeinteractive.com)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : contact@northbridgeinteractive.com
*/
class CfgHints
{
	class InfantryMovement
	{
		// Topic title (displayed only in topic listbox in Field Manual)
		displayName = "Infantry Controls";
		class SteppingOver
		{
			// Hint title, filled by arguments from 'arguments' param
			displayName = "Stepping over obstacles";
			// Optional hint subtitle, filled by arguments from 'arguments' param
			displayNameShort = "Stepping over";
			// Structured text, filled by arguments from 'arguments' param
			description = "Press %11 to step over low obstacle. Your %12 is %13.";
			// Optional structured text, filled by arguments from 'arguments' param (first argument is %11, see notes below), grey color of text
			tip = "The free look represents turning the head sideways and up or down.";
			arguments[] = {
				{{"getOver"}}, // Double nested array means assigned key (will be specially formatted)
				{"name"}, // Nested array means element (specially formatted part of text)
				"name player" // Simple string will be simply compiled and called, String can also link to localization database in case it starts by str_
			};
			// Optional image
			image = "\a3\ui_f\data\gui\cfg\hints\steppingover_ca.paa";
			// optional parameter for not showing of image in context hint in mission (default false))
			noImage = false;
			// -1 Creates no log in player diary, 0 Creates diary log ( default when not provided )
			// if a dlc's appID Number is used ( see command getDLCs ) and the user does not have the required dlc installed then the advHint will be replaced with
			// configfile >> "CfgHints" >> "DlcMessage" >> "Dlc#"; where # is this properties ( dlc appID ) number
			dlc = -1;
		};
	};
};
