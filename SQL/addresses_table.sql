-- Structure de la table addresses pour le système d'adresses
-- Table unique pour stocker les villes et les routes

CREATE TABLE IF NOT EXISTS `addresses` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `type` ENUM('city', 'road') NOT NULL,
    
    -- Champs pour les villes (type = 'city')
    `pos_x` FLOAT DEFAULT NULL COMMENT 'Position X pour les villes',
    `pos_y` FLOAT DEFAULT NULL COMMENT 'Position Y pour les villes',
    `pos_z` FLOAT DEFAULT NULL COMMENT 'Position Z pour les villes',
    `radius` INT(11) DEFAULT NULL COMMENT 'Rayon de la ville en mètres',
    
    -- Champs pour les routes (type = 'road')
    `start_x` FLOAT DEFAULT NULL COMMENT 'Position X de début pour les routes',
    `start_y` FLOAT DEFAULT NULL COMMENT 'Position Y de début pour les routes',
    `start_z` FLOAT DEFAULT NULL COMMENT 'Position Z de début pour les routes',
    `end_x` FLOAT DEFAULT NULL COMMENT 'Position X de fin pour les routes',
    `end_y` FLOAT DEFAULT NULL COMMENT 'Position Y de fin pour les routes',
    `end_z` FLOAT DEFAULT NULL COMMENT 'Position Z de fin pour les routes',
    
    -- Champ commun
    `name` VARCHAR(255) NOT NULL COMMENT 'Nom de la ville ou de la route',
    
    PRIMARY KEY (`id`),
    INDEX `idx_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Exemples de données pour les villes
INSERT INTO `addresses` (`type`, `pos_x`, `pos_y`, `pos_z`, `radius`, `name`) VALUES
('city', 2580.85, 5514.1, 0, 800, 'Silverton'),
('city', 3500.00, 6200.00, 0, 600, 'Northpoint'),
('city', 4200.50, 4800.75, 0, 700, 'Eastside'),
('city', 6500.00, 7000.00, 0, 900, 'Central District');

-- Exemples de données pour les routes
INSERT INTO `addresses` (`type`, `start_x`, `start_y`, `start_z`, `end_x`, `end_y`, `end_z`, `name`) VALUES
('road', 3862.1, 6369.8, 0, 6261.9, 7080.7, 0, 'Fishers Island MSR'),
('road', 2500.0, 5400.0, 0, 3800.0, 6300.0, 0, 'Silverton Highway'),
('road', 4000.0, 4500.0, 0, 5000.0, 5500.0, 0, 'Eastside Boulevard'),
('road', 3000.0, 6000.0, 0, 4500.0, 6500.0, 0, 'Main Street'),
('road', 5500.0, 6800.0, 0, 6800.0, 7200.0, 0, 'Central Avenue');

-- Note: Les positions doivent correspondre aux coordonnées réelles de la carte Arma 3
-- Les routes doivent avoir des points de début et de fin qui correspondent à des segments de route existants