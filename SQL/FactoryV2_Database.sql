-- Structure de base de données pour le système FactoryV2
-- À exécuter sur la base de données du serveur

-- Table principale des usines
CREATE TABLE IF NOT EXISTS `factoryv2_factories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` int NOT NULL,
  `slots` int NOT NULL DEFAULT 1,
  `speed_multiplier` decimal(10,2) NOT NULL DEFAULT 1.00,
  `efficiency` decimal(10,2) NOT NULL DEFAULT 0.00,
  `max_storage` int NOT NULL DEFAULT 1000,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cid` (`cid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table de stockage des usines
CREATE TABLE IF NOT EXISTS `factoryv2_storage` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` int NOT NULL,
  `items` text NOT NULL,
  `current_storage` int NOT NULL DEFAULT 0,
  `max_storage` int NOT NULL DEFAULT 1000,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cid` (`cid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table des crafts actifs
CREATE TABLE IF NOT EXISTS `factoryv2_crafts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` int NOT NULL,
  `craft_id` int NOT NULL,
  `amount` int NOT NULL DEFAULT 1,
  `start_time` bigint NOT NULL,
  `duration` int NOT NULL,
  `required_items` text NOT NULL,
  `status` enum('active','completed','cancelled') NOT NULL DEFAULT 'active',
  `completed_time` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `cid` (`cid`),
  KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table des crafts possédés par les entreprises
CREATE TABLE IF NOT EXISTS `factoryv2_owned_crafts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` int NOT NULL,
  `craft_id` int NOT NULL,
  `purchased_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cid_craft` (`cid`,`craft_id`),
  KEY `cid` (`cid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table des upgrades possédés par les entreprises
CREATE TABLE IF NOT EXISTS `factoryv2_owned_upgrades` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` int NOT NULL,
  `upgrade_id` int NOT NULL,
  `purchased_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cid_upgrade` (`cid`,`upgrade_id`),
  KEY `cid` (`cid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table des partages de crafts
CREATE TABLE IF NOT EXISTS `factoryv2_shares` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` int NOT NULL,
  `craft_id` int NOT NULL,
  `target_type` enum('player','company') NOT NULL,
  `target_id` int NOT NULL,
  `share_type` enum('subscription','craft') NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `cid` (`cid`),
  KEY `target` (`target_type`,`target_id`),
  KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table de configuration des crafts (à remplir manuellement)
CREATE TABLE IF NOT EXISTS `config_factoryv2_crafts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  `classname` varchar(255) NOT NULL,
  `class_type` enum('item','weapon','magazine','uniform','vest','headgear','backpack','car','plane') NOT NULL DEFAULT 'item',
  `base_duration` int NOT NULL DEFAULT 60,
  `required_items` text NOT NULL,
  `output_amount` int NOT NULL DEFAULT 1,
  `price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `license_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table de configuration des licences (à remplir manuellement)
CREATE TABLE IF NOT EXISTS `config_factoryv2_licenses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  `price` decimal(10,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table de configuration des upgrades (à remplir manuellement)
CREATE TABLE IF NOT EXISTS `config_factoryv2_upgrades` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  `upgrade_type` enum('slots','speed','efficiency','storage') NOT NULL,
  `upgrade_value` decimal(10,2) NOT NULL,
  `price` decimal(10,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

