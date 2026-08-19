-- ═══════════════════════════════════════════════════════════════════════════════
-- A3PL Server Language Configuration
-- This table stores the server language setting
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `config_lang` (
    `id` INT(11) NOT NULL DEFAULT 1,
    `lang_code` VARCHAR(5) NOT NULL DEFAULT 'FR' COMMENT 'Language code: FR, EN',
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default language (French)
INSERT INTO `config_lang` (`id`, `lang_code`) VALUES (1, 'FR')
ON DUPLICATE KEY UPDATE `id` = `id`;

-- ═══════════════════════════════════════════════════════════════════════════════
-- Usage:
-- To change server language to English:
--   UPDATE config_lang SET lang_code = 'EN' WHERE id = 1;
--
-- To change server language to French:
--   UPDATE config_lang SET lang_code = 'FR' WHERE id = 1;
--
-- Note: Server restart required for changes to take effect
-- ═══════════════════════════════════════════════════════════════════════════════
