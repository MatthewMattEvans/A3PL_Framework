-- Factory Storage Table for Company-Based Factory System
-- Stores items produced by factories for each company
-- ✅ EXECUTED SUCCESSFULLY

CREATE TABLE IF NOT EXISTS `factory_storage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `factory_type` varchar(50) NOT NULL,
  `item_class` varchar(100) NOT NULL,
  `amount` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_company_factory_item` (`company_id`, `factory_type`, `item_class`),
  KEY `idx_company_factory` (`company_id`, `factory_type`),
  KEY `idx_item_class` (`item_class`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Migration: factory_active_crafts table already has company_id structure
-- ✅ EXECUTED SUCCESSFULLY

-- Cleanup orphaned records with NULL company_id
-- DELETE FROM factory_active_crafts WHERE company_id IS NULL; -- ✅ 3 records removed

-- Make company_id NOT NULL (already done)
-- ALTER TABLE factory_active_crafts MODIFY COLUMN company_id int(11) NOT NULL; -- ✅ Applied

-- Indexes already exist:
-- - idx_company_factory_status (company_id, factory_type, status)
-- - idx_company_slot (company_id, factory_type, slot_index) 
-- - idx_end_time_status (end_time, status)

-- ✅ MIGRATION COMPLETED SUCCESSFULLY
-- ✅ Factory storage table created
-- ✅ Active crafts table cleaned up
-- ✅ All constraints and indexes verified
