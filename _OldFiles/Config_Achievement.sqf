/*
    POLARION
    Code written by non-profit organization "POLARION" (SIREN 930088620)
    @Copyright POLARION (https://www.polarion.fr)
    YOU ARE NOT ALLOWED TO COPY OR DISTRIBUTE THE CONTENT OF THIS FILE WITHOUT AUTHOR AGREEMENT
    More informations : https://www.bistudio.com/community/game-content-usage-rules
    Contact : hello@polarion.fr
*/
//Class, Title, Description, EXP, Need, Icon
// Config_Achievement = createHashMapFromArray [
// 	["ElkCity_Center",["Elk City Centre","Vous avez découvert la région d'Elk City Centre",100,[],"po_ui\Data\succes\Region.paa"]],
// 	["ElkCity_South",["Elk City Sud","Vous avez découvert la région d'Elk City Sud",100,[],"po_ui\Data\succes\Region.paa"]],
// 	["Oakside_Village",["Oakside Village","Vous avez découvert la région d'Oakside Village",100,[],"po_ui\Data\succes\Region.paa"]],
// 	["Lakeview_Estates",["Lakeview Estates","Vous avez découvert la région de Lakeview Estates",100,[],"po_ui\Data\succes\Region.paa"]],
// 	["Jamestown",["Jamestown","Vous avez découvert la région de Jamestown",100,[],"po_ui\Data\succes\Region.paa"]],
// 	["Ragging_Hill",["Ragging Hill","Vous avez découvert la région de Ragging Hill",100,[],"po_ui\Data\succes\Region.paa"]],
// 	["Janitors_Peak",["Janitor's Peak","Vous avez découvert la région de Janitor's Peak",100,[],"po_ui\Data\succes\Region.paa"]],
// 	["Deadwood",["Deadwood","Vous avez découvert la région de Deadwood",100,[],"po_ui\Data\succes\Region.paa"]],
// 	["Blackwood",["Blackwood","Vous avez découvert la région de Blackwood",100,[],"po_ui\Data\succes\Region.paa"]],
// 	["Blackwood_Industrial_Park",["Blackwood Industrial Park","Vous avez découvert la région de Blackwood Industrial Park",100,[],"po_ui\Data\succes\Region.paa"]],
// 	["Northdale_North",["Northdale Nord","Vous avez découvert la région de Northdale Nord",100,[],"po_ui\Data\succes\Region.paa"]],
// 	["Northdale_Center",["Northdale Centre","Vous avez découvert la région de Northdale Centre",100,[],"po_ui\Data\succes\Region.paa"]],
// 	["Northdale_South",["Northdale Sud","Vous avez découvert la région de Northdale Sud",100,[],"po_ui\Data\succes\Region.paa"]],
// 	["Springfield_Center",["Springfield Centre","Vous avez découvert la région de Springfield Centre",100,[],"po_ui\Data\succes\Region.paa"]],
// 	["Springfield_North",["Springfield Nord","Vous avez découvert la région de Springfield Nord",100,[],"po_ui\Data\succes\Region.paa"]],
// 	["Boyd_Manor",["Boyd Manor","Vous avez découvert la région de Boyd Manor",100,[],"po_ui\Data\succes\Region.paa"]],
// 	["Rusty_Retreat_Trailer_Park",["Rusty Retreat Trailer Park","Vous avez découvert la région de Rusty Retreat Trailer Park",100,[],"po_ui\Data\succes\Region.paa"]],
// 	["Sunnyside_Trailer_Park",["SunnySide Trailer Park","Vous avez découvert la région de SunnySide Trailer Park",100,[],"po_ui\Data\succes\Region.paa"]],
// 	["Erie",["Erie","Vous avez découvert la région d'Erie",100,[],"po_ui\Data\succes\Region.paa"]],
// 	["Paradise_Falls",["Paradise Falls","Vous avez découvert la région de Paradise Falls",100,[],"po_ui\Data\succes\Region.paa"]],
// 	["Axels_Garden",["Axel's Garden","Vous avez découvert la région d'Axel's Garden",100,[],"po_ui\Data\succes\Region.paa"]],
// 	["Beach_Valley",["Beach Valley","Vous avez découvert la région de Beach Valley",100,[],"po_ui\Data\succes\Region.paa"]],
// 	["Palm_Beach_Hotel",["Palm Beach","Vous avez découvert la région de Palm Beach",100,[],"po_ui\Data\succes\Region.paa"]],
// 	["Stoney_Creek",["Stoney Creek","Vous avez découvert la région de Stoney Creek",100,[],"po_ui\Data\succes\Region.paa"]],
// 	["Star_Air_Base",["Star Air Base","Vous avez découvert la région de Star Air Base",100,[],"po_ui\Data\succes\Region.paa"]],
// 	["DepartmentOfCorrections",["Department of Corrections","Vous avez découvert la région de Department of Corrections",100,[],"po_ui\Data\succes\Region.paa"]],
// 	["Industrial_Power_Plant",["Industrial Power Plant","Vous avez découvert la région d'Industrial Power Plant",100,[],"po_ui\Data\succes\Region.paa"]],
// 	["Coral_Cove",["Coral Cove","Vous avez découvert la région de Coral Cove",100,[],"po_ui\Data\succes\Region.paa"]],
// 	["Silverton",["Silverton","Vous avez découvert la région de Silverton",100,[],"po_ui\Data\succes\Region.paa"]],
// 	["exploration",["Explorateur","Vous avez découvert toute la carte !",100,["ElkCity_Center","ElkCity_South","Oakside_Village","Lakeview_Estates","Jamestown","Ragging_Hill","Janitors_Peak","Deadwood","Blackwood","Blackwood_Industrial_Park","Northdale_North","Northdale_Center","Northdale_South","Springfield_Center","Springfield_North","Boyd_Manor","Rusty_Retreat_Trailer_Park","Sunnyside_Trailer_Park","Erie","Paradise_Falls","Axels_Garden","Beach_Valley","Palm_Beach_Hotel","Stoney_Creek","Star_Air_Base","DepartmentOfCorrections","Industrial_Power_Plant","Coral_Cove","Silverton"],"po_ui\Data\succes\Region.paa"]],
// 	["bowling",["La quille","Vous avez joué au Bowling",100,[],"po_ui\Data\succes\stars.paa"]],
// 	["karting",["Mario Kart","Vous avez joué au Karting",100,[],"po_ui\Data\succes\stars.paa"]],
// 	["sport1",["Gros sac","Vous avez atteint le niveau 1 sportif",100,[],"po_ui\Data\succes\stars.paa"]],
// 	["sport2",["Coureur","Vous avez atteint le niveau 2 sportif",100,[],"po_ui\Data\succes\stars.paa"]],
// 	["sport3",["Sprinteur","Vous avez atteint le niveau 3 sportif",100,[],"po_ui\Data\succes\stars.paa"]],
// 	["sportall",["Comme Lebron","Vous avez obtenu tous les niveaux sportifs",100,["sport1","sport2","sport3"],"po_ui\Data\succes\stars.paa"]],
// 	["bank_common",["Des sous SVP","Vous avez ouvert un compte courant",100,[],"po_ui\Data\succes\money.paa"]],
// 	["bank_savings",["Fini le RSA","Vous avez ouvert un savings account",100,[],"po_ui\Data\succes\money.paa"]],
// 	["bank_cod",["Elon Musk","Vous avez ouvert un certificate of deposit",100,[],"po_ui\Data\succes\money.paa"]],
// 	["combine",["Equipier","Vous avez fabriqué un burger",100,[],"po_ui\Data\succes\stars.paa"]],
// 	["company_create",["Entrepreneur","Vous avez créé votre société",100,[],"po_ui\Data\succes\money.paa"]],
// 	["company_shop",["Va chier, Amazon","Votre premier achat chez un commerçant local!",100,[],"po_ui\Data\succes\money.paa"]],
// 	["company_paybill",["J'ai dit: PAYE!","Vous avez payé votre première facture",100,[],"po_ui\Data\succes\money.paa"]],
// 	["cocaine_brick",["Pablo Escobar","Votre première brique de cocaine!",100,[],"po_ui\Data\succes\stars.paa"]],
// 	["moonshine",["Contrebandier en herbe","Vous avez fabriqué votre alcool de contrebande",100,[],"po_ui\Data\succes\stars.paa"]],
// 	["shrooms",["Champignon de Paris","Votre premier champignon, mais pas à manger",100,[],"po_ui\Data\succes\stars.paa"]],
// 	["christmas",["Nowwel","C'est noel et vous avez récupéré votre premier cadeau!",100,[],"po_ui\Data\succes\stars.paa"]],
// 	["ratz",["Rat","Vous avez échangé un cadeau qui date d'halloween... Rat",100,[],"po_ui\Data\succes\stars.paa"]],
// 	["woaf",["Woaf Woaf","Vous avez adopté une jolie chienne",100,[],"po_ui\Data\succes\stars.paa"]],
// 	["pyromane",["Feu, action!","Vous avez allumé votre premier incendie criminel",100,[],"po_ui\Data\succes\stars.paa"]]
// ];
// publicVariable "Config_Achievement";