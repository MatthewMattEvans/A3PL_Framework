-- Migration script for the new factory system
-- This script creates the new tables for persistent crafting system

-- Create factory_crafts table (replaces Config_Factories)
CREATE TABLE IF NOT EXISTS `factory_crafts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `factory_type` varchar(50) NOT NULL,
  `craft_id` varchar(50) NOT NULL,
  `item_class` varchar(100) NOT NULL,
  `item_type` varchar(50) NOT NULL,
  `craft_time` int NOT NULL DEFAULT 0,
  `required_items` text NOT NULL,
  `output_amount` int NOT NULL DEFAULT 1,
  `xp_gain` int NOT NULL DEFAULT 0,
  `level_required` int NOT NULL DEFAULT 0,
  `description` varchar(500) DEFAULT '',
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `factory_craft_unique` (`factory_type`, `craft_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Factory craft recipes configuration';

-- Create factory_active_crafts table for persistent crafting
CREATE TABLE IF NOT EXISTS `factory_active_crafts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `character_id` varchar(50) NOT NULL,
  `factory_type` varchar(50) NOT NULL,
  `craft_id` varchar(50) NOT NULL,
  `start_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `end_time` datetime NOT NULL,
  `output_item` varchar(100) NOT NULL,
  `output_amount` int NOT NULL,
  `slot_index` int NOT NULL DEFAULT 0,
  `status` enum('active','completed','failed') NOT NULL DEFAULT 'active',
  PRIMARY KEY (`id`),
  INDEX `idx_character_factory` (`character_id`, `factory_type`),
  INDEX `idx_end_time` (`end_time`),
  INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Active factory crafts in progress';

-- Create factory_upgrades table for upgrade definitions
CREATE TABLE IF NOT EXISTS `factory_upgrades` (
  `id` int NOT NULL AUTO_INCREMENT,
  `factory_type` varchar(50) NOT NULL,
  `upgrade_type` enum('craft_unlock','speed_boost','multi_craft') NOT NULL,
  `upgrade_id` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(500) DEFAULT '',
  `tier` int NOT NULL DEFAULT 1,
  `cost` int NOT NULL DEFAULT 0,
  `prerequisite_tier` int DEFAULT NULL,
  `effect_value` float NOT NULL DEFAULT 1.0,
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `factory_upgrade_unique` (`factory_type`, `upgrade_type`, `upgrade_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Factory upgrade definitions';

-- Create player_factory_upgrades table for purchased upgrades
CREATE TABLE IF NOT EXISTS `player_factory_upgrades` (
  `id` int NOT NULL AUTO_INCREMENT,
  `character_id` varchar(50) NOT NULL,
  `factory_type` varchar(50) NOT NULL,
  `upgrade_type` enum('craft_unlock','speed_boost','multi_craft') NOT NULL,
  `upgrade_id` varchar(50) NOT NULL,
  `tier` int NOT NULL DEFAULT 1,
  `purchased_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `player_upgrade_unique` (`character_id`, `factory_type`, `upgrade_type`, `upgrade_id`),
  INDEX `idx_character_factory_type` (`character_id`, `factory_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Player purchased factory upgrades';

-- Insert default speed boost upgrades
INSERT INTO `factory_upgrades` (`factory_type`, `upgrade_type`, `upgrade_id`, `name`, `description`, `tier`, `cost`, `prerequisite_tier`, `effect_value`) VALUES
-- Speed upgrades (apply to all factory types)
('all', 'speed_boost', 'speed_tier_1', 'Amélioration de vitesse Tier 1', 'Réduit le temps de fabrication de 20% (x1.25)', 1, 50000, NULL, 1.25),
('all', 'speed_boost', 'speed_tier_2', 'Amélioration de vitesse Tier 2', 'Réduit le temps de fabrication de 33% (x1.5)', 2, 100000, 1, 1.5),
('all', 'speed_boost', 'speed_tier_3', 'Amélioration de vitesse Tier 3', 'Réduit le temps de fabrication de 50% (x2.0)', 3, 200000, 2, 2.0),

-- Multi-craft upgrades (apply to all factory types)
('all', 'multi_craft', 'slot_tier_1', 'Slot supplémentaire Tier 1', 'Permet 2 crafts simultanés', 1, 75000, NULL, 2.0),
('all', 'multi_craft', 'slot_tier_2', 'Slot supplémentaire Tier 2', 'Permet 3 crafts simultanés', 2, 150000, 1, 3.0),
('all', 'multi_craft', 'slot_tier_3', 'Slot supplémentaire Tier 3', 'Permet 4 crafts simultanés', 3, 300000, 2, 4.0);