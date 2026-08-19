# Système FactoryV2 - Documentation

## Fichiers créés

1. **A3PL_Backend/Content/Functions/A3PL_FactoryV2.sqf** - Fonctions client pour l'UI
2. **A3PL_Backend/Content/Server/Server_FactoryV2.sqf** - Logique serveur persistante
3. **A3PL.FishersIsland/Dialogs/Dialog_Factory_V2.hpp** - Interface utilisateur
4. **A3PL_Backend/Content/Server/FactoryV2_Database.sql** - Structure de base de données
5. **A3PL.FishersIsland/stringtable.xml** - Textes multilingues (ajoutés)

## Structure de base de données

Le fichier `FactoryV2_Database.sql` contient toutes les tables nécessaires. À exécuter sur la base de données.

### Tables principales:
- `factoryv2_factories` - Données des usines (slots, vitesse, efficacité, stockage)
- `factoryv2_storage` - Stockage des items par entreprise
- `factoryv2_crafts` - Crafts actifs en cours
- `factoryv2_owned_crafts` - Crafts possédés par les entreprises
- `factoryv2_owned_upgrades` - Upgrades possédés
- `factoryv2_shares` - Partages de crafts
- `config_factoryv2_crafts` - Configuration des crafts (à remplir)
- `config_factoryv2_licenses` - Configuration des licences (à remplir)
- `config_factoryv2_upgrades` - Configuration des upgrades (à remplir)

## Configuration requise

### 1. Remplir les tables de configuration

#### config_factoryv2_crafts
```sql
INSERT INTO config_factoryv2_crafts (name, description, classname, class_type, base_duration, required_items, output_amount, price, license_id) 
VALUES ('Nom du craft', 'Description', 'classname_item', 'item', 60, '[["item1", 5], ["item2", 10]]', 1, 1000.00, NULL);
```

#### config_factoryv2_licenses
```sql
INSERT INTO config_factoryv2_licenses (name, description, price) 
VALUES ('Licence BMW', 'Tous les crafts BMW', 50000.00);
```

#### config_factoryv2_upgrades
```sql
INSERT INTO config_factoryv2_upgrades (name, description, upgrade_type, upgrade_value, price) 
VALUES ('Slot supplémentaire', 'Ajoute un slot de fabrication', 'slots', 1, 10000.00);
```

Types d'upgrades disponibles:
- `slots` - Ajoute des slots de fabrication
- `speed` - Augmente la vitesse (multiplicateur)
- `efficiency` - Augmente l'efficacité (pourcentage)
- `storage` - Augmente la capacité de stockage

## Utilisation

### Ouvrir l'usine
```sqf
[_cid] call A3PL_FactoryV2_Open;
```

Où `_cid` est l'ID de l'entreprise.

## Fonctionnalités

### 1. My Factory
- Affiche les crafts actifs en cours
- Permet de lancer de nouveaux crafts
- Les crafts continuent même si le joueur se déconnecte

### 2. Crafts
- Liste tous les crafts disponibles
- Affiche les licences et crafts individuels
- Recherche par nom
- Achat de crafts ou licences

### 3. Storage
- Ajouter/retirer des items du stockage
- Stockage limité (améliorable via upgrades)
- Utilisé pour les crafts

### 4. Upgrades
- Affiche les stats actuelles
- Liste des upgrades disponibles
- Achat d'upgrades pour améliorer l'usine

### 5. Share
- Partager des crafts avec d'autres joueurs/entreprises
- Recherche de cibles (joueurs ou entreprises)
- Prix par craft ou abonnement/jour
- Les abonnements sont prélevés automatiquement toutes les 24h

## Système de licences

Les licences utilisent le système existant `Server_Company_SetLicenses`. Les licences sont stockées avec le préfixe `factoryv2_license_` suivi de l'ID de la licence.

## Scheduled Tasks

- **Server_FactoryV2_CraftLoop** - Vérifie les crafts terminés toutes les 5 secondes
- **Server_FactoryV2_SubscriptionLoop** - Prélève les abonnements toutes les 24h (86400 secondes)

## Persistance

Tous les crafts actifs sont sauvegardés en base de données et rechargés au démarrage du serveur. Le système fonctionne donc entre les restarts.

## Notes importantes

1. Les crafts utilisent des timestamps Unix pour calculer le temps restant
2. L'efficacité peut donner des items bonus ou économiser des matériaux
3. Les slots limitent le nombre de crafts simultanés
4. Le stockage est calculé en poids (utilise le système de poids des items existant)
5. Les abonnements sont désactivés automatiquement si le compte n'a pas assez d'argent

