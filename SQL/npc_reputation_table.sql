-- Table de réputation des NPCs
-- À exécuter sur la base de données du serveur

CREATE TABLE IF NOT EXISTS `npc_reputation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `charid` varchar(50) NOT NULL,
  `npc_name` varchar(100) NOT NULL,
  `reputation` int NOT NULL DEFAULT 0,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `charid_npc` (`charid`, `npc_name`),
  KEY `charid` (`charid`),
  KEY `npc_name` (`npc_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

