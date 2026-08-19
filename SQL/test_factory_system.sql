-- Script de test pour le nouveau système d'usines V2
-- Ce script valide que toutes les tables et données sont correctement configurées

-- Test 1: Vérifier que toutes les tables existent
SELECT 'Testing table existence...' as test_phase;

SELECT 
    CASE WHEN COUNT(*) = 4 THEN 'PASS: All 4 factory tables exist' 
         ELSE CONCAT('FAIL: Only ', COUNT(*), ' factory tables found') 
    END as result
FROM information_schema.tables 
WHERE table_schema = DATABASE() 
AND table_name IN ('factory_crafts', 'factory_active_crafts', 'factory_upgrades', 'player_factory_upgrades');

-- Test 2: Vérifier que les crafts d'exemple sont présents
SELECT 'Testing craft data...' as test_phase;

SELECT 
    CASE WHEN COUNT(*) > 0 THEN CONCAT('PASS: ', COUNT(*), ' craft recipes found') 
         ELSE 'FAIL: No craft recipes found' 
    END as result
FROM factory_crafts 
WHERE enabled = 1;

-- Test 3: Vérifier que les améliorations par défaut sont présentes
SELECT 'Testing upgrade data...' as test_phase;

SELECT 
    CASE WHEN COUNT(*) >= 6 THEN CONCAT('PASS: ', COUNT(*), ' default upgrades found') 
         ELSE CONCAT('FAIL: Only ', COUNT(*), ' default upgrades found, expected at least 6') 
    END as result
FROM factory_upgrades 
WHERE factory_type = 'all' AND enabled = 1;

-- Test 4: Vérifier les contraintes d'unicité
SELECT 'Testing unique constraints...' as test_phase;

SELECT 
    CASE WHEN COUNT(*) = 0 THEN 'PASS: No duplicate factory crafts found' 
         ELSE CONCAT('FAIL: ', COUNT(*), ' duplicate factory crafts found') 
    END as result
FROM (
    SELECT factory_type, craft_id, COUNT(*) as cnt
    FROM factory_crafts 
    GROUP BY factory_type, craft_id 
    HAVING cnt > 1
) as duplicates;

-- Test 5: Vérifier la structure des données JSON
SELECT 'Testing JSON data structure...' as test_phase;

SELECT 
    craft_id,
    CASE WHEN JSON_VALID(required_items) THEN 'VALID' ELSE 'INVALID' END as json_status,
    required_items
FROM factory_crafts 
WHERE enabled = 1 
LIMIT 5;

-- Test 6: Simuler un craft actif (pour test)
SELECT 'Testing active craft insertion...' as test_phase;

-- Insérer un craft de test (remplacez 'test_character_id' par un ID valide)
INSERT INTO factory_active_crafts 
(character_id, factory_type, craft_id, start_time, end_time, output_item, output_amount, slot_index, status) 
VALUES 
('test_character_id', 'Food', 'bread_craft', NOW(), DATE_ADD(NOW(), INTERVAL 2 MINUTE), 'bread', 2, 0, 'active');

SELECT 
    CASE WHEN COUNT(*) > 0 THEN 'PASS: Test active craft inserted successfully' 
         ELSE 'FAIL: Could not insert test active craft' 
    END as result
FROM factory_active_crafts 
WHERE character_id = 'test_character_id';

-- Test 7: Tester la récupération des crafts par type d'usine
SELECT 'Testing craft retrieval by factory type...' as test_phase;

SELECT 
    factory_type, 
    COUNT(*) as craft_count
FROM factory_crafts 
WHERE enabled = 1 
GROUP BY factory_type 
ORDER BY craft_count DESC;

-- Test 8: Vérifier les paliers d'améliorations
SELECT 'Testing upgrade tiers...' as test_phase;

SELECT 
    upgrade_type,
    COUNT(DISTINCT tier) as tier_count,
    MIN(tier) as min_tier,
    MAX(tier) as max_tier
FROM factory_upgrades 
WHERE factory_type = 'all' 
GROUP BY upgrade_type;

-- Test 9: Vérifier les coûts d'améliorations
SELECT 'Testing upgrade costs...' as test_phase;

SELECT 
    upgrade_type,
    tier,
    cost,
    CASE WHEN cost > 0 THEN 'VALID' ELSE 'INVALID' END as cost_status
FROM factory_upgrades 
WHERE factory_type = 'all' 
ORDER BY upgrade_type, tier;

-- Nettoyage du test
SELECT 'Cleaning up test data...' as test_phase;

DELETE FROM factory_active_crafts WHERE character_id = 'test_character_id';

SELECT 'Factory System V2 Testing Complete!' as final_message;

-- Statistiques finales
SELECT 
    'SUMMARY' as section,
    CONCAT('Crafts: ', (SELECT COUNT(*) FROM factory_crafts WHERE enabled = 1)) as crafts,
    CONCAT('Upgrades: ', (SELECT COUNT(*) FROM factory_upgrades WHERE enabled = 1)) as upgrades,
    CONCAT('Active Crafts: ', (SELECT COUNT(*) FROM factory_active_crafts WHERE status = 'active')) as active_crafts;

-- Recommandations
SELECT 'RECOMMENDATIONS' as section;
SELECT 'Remember to:' as reminder;
SELECT '1. Update character IDs in test scripts' as step_1;
SELECT '2. Configure automatic cleanup of completed crafts' as step_2;
SELECT '3. Set up monitoring for active crafts table size' as step_3;
SELECT '4. Test with actual player data before production' as step_4;
SELECT '5. Create indexes on frequently queried columns' as step_5;