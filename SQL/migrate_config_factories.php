<?php
/**
 * Script de migration des données Config_Factories vers la base de données
 * Ce script extrait les données du fichier Config_Factories.sqf et les insère dans la table factory_crafts
 */

// Configuration de la base de données (à adapter)
$host = 'localhost';
$dbname = 'fyd_prod';
$username = 'root';
$password = '';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    echo "Connexion à la base de données réussie.\n";
    
    // Lire le fichier Config_Factories.sqf
    $configFile = '../Server Files/PO_Backend/Content/Configs/Config_Factories.sqf';
    
    if (!file_exists($configFile)) {
        throw new Exception("Le fichier Config_Factories.sqf n'existe pas à : $configFile");
    }
    
    $content = file_get_contents($configFile);
    
    // Parser le contenu du fichier (version simplifiée)
    // Format: ["factory_ID","classname","type",time,[["required",3],["components",200]],output,xpGain,levelRequired,description]
    
    preg_match_all('/\["([^"]+)".*?\]/', $content, $matches);
    
    $stmt = $pdo->prepare("
        INSERT INTO factory_crafts 
        (factory_type, craft_id, item_class, item_type, craft_time, required_items, output_amount, xp_gain, level_required, description) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE 
            item_class = VALUES(item_class),
            item_type = VALUES(item_type),
            craft_time = VALUES(craft_time),
            required_items = VALUES(required_items),
            output_amount = VALUES(output_amount),
            xp_gain = VALUES(xp_gain),
            level_required = VALUES(level_required),
            description = VALUES(description)
    ");
    
    // Exemple d'insertion pour quelques crafts courants
    // À adapter selon la structure exacte du fichier Config_Factories.sqf
    
    $crafts = [
        // Exemples basés sur l'analyse du fichier
        ['Admin Tools', 'f_candy', 'candy', 'item', 0, '[]', 1, 0, 0, 'Bonbon'],
        ['Admin Tools', 'f_beer', 'beer', 'item', 0, '[]', 1, 0, 0, 'Bière'],
        ['Admin Tools', 'f_sand', 'sand', 'item', 0, '[]', 1, 0, 0, 'Sable'],
        // Ajouter plus de crafts selon le contenu réel du fichier
    ];
    
    $insertedCount = 0;
    
    foreach ($crafts as $craft) {
        try {
            $stmt->execute($craft);
            $insertedCount++;
            echo "Craft inséré : {$craft[0]} -> {$craft[1]}\n";
        } catch (PDOException $e) {
            echo "Erreur lors de l'insertion du craft {$craft[1]} : " . $e->getMessage() . "\n";
        }
    }
    
    echo "Migration terminée. $insertedCount crafts traités.\n";
    
} catch (PDOException $e) {
    echo "Erreur de base de données : " . $e->getMessage() . "\n";
} catch (Exception $e) {
    echo "Erreur : " . $e->getMessage() . "\n";
}

echo "\nATTENTION : Ce script est un exemple de base.\n";
echo "Vous devez l'adapter pour parser correctement le format exact de Config_Factories.sqf\n";
echo "et extraire toutes les données nécessaires (temps de craft, items requis, etc.).\n";
?>