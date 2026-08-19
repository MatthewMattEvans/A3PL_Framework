-- Exemples de crafts pour le nouveau système d'usines
-- Basé sur l'analyse du fichier Config_Factories.sqf existant

-- Exemples de crafts simples (Admin Tools)
INSERT INTO `factory_crafts` (`factory_type`, `craft_id`, `item_class`, `item_type`, `craft_time`, `required_items`, `output_amount`, `xp_gain`, `level_required`, `description`) VALUES
('Admin Tools', 'f_candy', 'candy', 'item', 5, '[]', 1, 1, 0, 'Bonbon sucre'),
('Admin Tools', 'f_beer', 'beer', 'item', 10, '[]', 1, 2, 0, 'Biere rafraichissante'),
('Admin Tools', 'f_sand', 'sand', 'item', 3, '[]', 1, 1, 0, 'Sable fin'),

-- Exemples de crafts avec composants requis
('Metallurgy', 'steel_ingot', 'steel_ingot', 'item', 300, '[["iron_ore", 2], ["coal", 1]]', 1, 15, 5, 'Lingot acier forge'),
('Metallurgy', 'aluminum_sheet', 'aluminum_sheet', 'item', 180, '[["aluminum_ore", 3]]', 2, 10, 3, 'Plaque aluminium'),

-- Exemples de crafts d armes (nécessitent déblocage)
('Weaponry', 'pistol_craft', 'hgun_Pistol_heavy_01_F', 'weapon', 600, '[["steel_ingot", 3], ["plastic", 2], ["screws", 5]]', 1, 25, 10, 'Pistolet artisanal'),

-- Exemples de crafts pharmaceutiques
('Medical', 'bandage_craft', 'med_bandage', 'item', 60, '[["cotton", 2], ["antiseptic", 1]]', 5, 5, 1, 'Bandages medicaux'),
('Medical', 'morphine_craft', 'med_morphine', 'item', 240, '[["opium", 1], ["chemicals", 2]]', 1, 20, 8, 'Morphine injectable'),

-- Exemples de crafts alimentaires
('Food', 'bread_craft', 'bread', 'item', 120, '[["wheat", 3], ["yeast", 1]]', 2, 8, 2, 'Pain frais'),
('Food', 'coffee_craft', 'coffee_cup_large', 'item', 30, '[["coffee_beans", 1], ["milk", 1]]', 1, 3, 0, 'Grand cafe'),

-- Exemples de crafts de véhicules (temps très longs)
('Automotive', 'repair_kit', 'repair_kit', 'item', 900, '[["steel_ingot", 5], ["plastic", 3], ["electronics", 2]]', 1, 50, 15, 'Kit de reparation avance'),

-- Exemples de crafts d electronique
('Electronics', 'radio_craft', 'radio', 'item', 450, '[["electronics", 3], ["plastic", 2], ["battery", 1]]', 1, 30, 7, 'Radio portable'),

-- Exemples de crafts de drogue (illegaux, necessitent deblocages speciaux)
('Illegal', 'processed_weed', 'weed_bag_10g', 'item', 180, '[["cannabis_plant_stage4", 2], ["plastic_bag", 1]]', 1, 15, 0, 'Cannabis traite'),

-- Crafts d ameliorations specialises par type d usine
('Chemical', 'acid_craft', 'sulphuric_acid', 'item', 360, '[["sulphur_ore", 2], ["water", 3]]', 1, 25, 12, 'Acide sulfurique');

-- Inserer quelques craft unlocks specialises
INSERT INTO `factory_upgrades` (`factory_type`, `upgrade_type`, `upgrade_id`, `name`, `description`, `tier`, `cost`, `prerequisite_tier`, `effect_value`) VALUES
-- Deblocages de crafts specialises
('Weaponry', 'craft_unlock', 'pistol_unlock', 'Deblocage Armes de Poing', 'Permet la fabrication d armes de poing', 1, 100000, NULL, 1.0),
('Weaponry', 'craft_unlock', 'rifle_unlock', 'Deblocage Fusils', 'Permet la fabrication de fusils', 2, 250000, 1, 1.0),
('Medical', 'craft_unlock', 'advanced_medical', 'Medicaments Avances', 'Debloque la fabrication de medicaments complexes', 1, 75000, NULL, 1.0),
('Illegal', 'craft_unlock', 'drug_processing', 'Traitement de Drogues', 'Debloque le traitement de substances illicites', 1, 150000, NULL, 1.0),
('Electronics', 'craft_unlock', 'advanced_electronics', 'Electronique Avancee', 'Debloque les composants electroniques complexes', 1, 80000, NULL, 1.0),
('Chemical', 'craft_unlock', 'dangerous_chemicals', 'Produits Chimiques Dangereux', 'Debloque la fabrication d acides et explosifs', 1, 200000, NULL, 1.0);