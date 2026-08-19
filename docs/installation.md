# 🔧 Installation et Configuration - ArmA 3 Project Life

## 📋 Prérequis Système

### Serveur Requis
- **OS** : Windows Server 2019+ ou Windows 10/11
- **RAM** : 16 GB minimum (32 GB recommandé)
- **CPU** : Intel Core i7-8700K ou équivalent AMD
- **Stockage** : 100 GB SSD libre
- **Réseau** : Connexion stable 100 Mbps+

### Logiciels Requis
- **ArmA 3 Dedicated Server**
- **MySQL Server 8.0+**
- **PowerShell 5.1+**
- **Visual C++ Redistributable 2019+**
- **.NET Framework 4.8**

### Ports Réseau
```
2302 (UDP) - Serveur de jeu principal
2303 (UDP) - Steam query port
2304 (UDP) - Steam master port
2305 (UDP) - Rcon port
3306 (TCP) - MySQL (si externe)
```

---

## 🚀 Installation Étape par Étape

### 1. Configuration de la Base de Données

#### Installation MySQL
```bash
# Télécharger MySQL 8.0 Community Server
# Configurer avec les paramètres :
# - Port : 3306
# - Charset : utf8mb4
# - Authentication : mysql_native_password
```

#### Création de la Base
```sql
-- Se connecter à MySQL en tant qu'administrateur
mysql -u root -p

-- Créer la base de données
CREATE DATABASE a3pl_prod CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- Créer l'utilisateur dédié
CREATE USER 'a3pl_user'@'localhost' IDENTIFIED BY 'your_secure_password';
GRANT ALL PRIVILEGES ON a3pl_prod.* TO 'a3pl_user'@'localhost';
FLUSH PRIVILEGES;

-- Importer le schéma
USE a3pl_prod;
SOURCE SQL/database.sql;
```

### 2. Configuration du Serveur ArmA 3

#### Structure des Dossiers
```
D:\ArmA3Server\
├── arma3server.exe
├── @a3pl_framework\        # Mod du framework
├── @tfar\                  # Task Force Radio
├── MPMissions\
│   └── PO.FishersIsland.pbo
└── userconfig\
```

#### Fichier basic.cfg
```cpp
// Copier depuis Configs/basic.cfg
MaxMsgSend = 1024;
MaxSizeGuaranteed = 512;
MaxSizeNonguaranteed = 256;
MinBandwidth = 131072;
MaxBandwidth = 1073741824000;
MinErrorToSend = 0.001;
MinErrorToSendNear = 0.01;
MaxCustomFileSize = 160000;
```

#### Fichier server.cfg
```cpp
// Copier depuis Configs/Server_A3_1.cfg et adapter :

hostname = "ArmA 3 Project Life - Serveur RP";
password = "";
passwordAdmin = "admin_password_here";
serverCommandPassword = "rcon_password_here";

maxPlayers = 110;
persistent = 1;

// Base de données (adapter selon votre config)
class DB_Custom_V2 {
    class Identifiers {
        Database = "a3pl_prod";
        Username = "a3pl_user";
        Password = "your_secure_password";
    };
};
```

### 3. Compilation des PBOs

#### Utilisation du Script PowerShell
```powershell
# Ouvrir PowerShell en tant qu'administrateur
cd "D:\Github\ArmA3ProjectLife\framework"

# Exécuter le script de compilation
.\Powershell Scripts\fetch and pbo.ps1

# Les PBOs seront générés dans le dossier de sortie
```

#### Compilation Manuelle
```powershell
# Utiliser PBOManager pour compiler :
# 1. PO_Backend -> @a3pl_framework\addons\po_backend.pbo
# 2. PO.FishersIsland -> MPMissions\PO.FishersIsland.pbo
```

### 4. Configuration Task Force Radio

#### Installation TFAR
```
1. Télécharger TFAR depuis Steam Workshop
2. Copier dans @tfar du serveur
3. Configurer les plugins TeamSpeak
4. Distribuer aux joueurs
```

#### Configuration userconfig
```cpp
// userconfig\task_force_radio\radio_keys.hpp
TF_give_personal_radio_to_regular_soldier = true;
TF_give_microdagr_to_soldier = true;
TF_no_auto_long_range_radio = false;
```

---

## ⚙️ Configuration Avancée

### Performance et Optimisation

#### Paramètres Serveur
```bash
# Ligne de commande serveur recommandée
arma3server.exe -port=2302 -config=server.cfg -cfg=basic.cfg -profiles=ServerProfile -name=server -filePatching -mod="@a3pl_framework;@tfar" -servermod="" -world=FishersIsland -autoInit
```

#### Configuration MySQL
```sql
-- my.ini optimisations pour ArmA 3
[mysqld]
max_connections = 200
innodb_buffer_pool_size = 2G
innodb_log_file_size = 256M
query_cache_size = 128M
thread_cache_size = 50
```

### Sécurité

#### Protection DDoS
```cpp
// Dans server.cfg
kickDuplicate = 1;
verifySignatures = 2;
requiredSecureId = 2;
```

#### Configuration Firewall
```bash
# Autoriser les ports ArmA 3
New-NetFirewallRule -DisplayName "ArmA 3 Server" -Direction Inbound -Protocol UDP -LocalPort 2302-2305
New-NetFirewallRule -DisplayName "MySQL Server" -Direction Inbound -Protocol TCP -LocalPort 3306
```

### Monitoring et Logs

#### Configuration des Logs
```cpp
// Dans server.cfg
RPTTimestamp = 1;
logFile = "server_console.log";

class EventHandlers {
    init = "diag_log ['FYD Server Started'];";
};
```

#### Scripts de Monitoring
```powershell
# Script de surveillance serveur
while ($true) {
    $process = Get-Process "arma3server" -ErrorAction SilentlyContinue
    if (!$process) {
        Write-Host "Serveur arrêté, redémarrage..."
        Start-Process "arma3server.exe" -ArgumentList "-port=2302 ..."
    }
    Start-Sleep 60
}
```

---

## 🔧 Maintenance

### Sauvegardes Automatiques

#### Script de Sauvegarde MySQL
```bash
@echo off
set BACKUP_DIR=D:\Backups\A3PL
set DATE=%date:~-4,4%%date:~-10,2%%date:~-7,2%
mysqldump -u a3pl_user -p a3pl_prod > %BACKUP_DIR%\a3pl_backup_%DATE%.sql
```

#### Sauvegarde des Configurations
```powershell
# Script PowerShell de sauvegarde complète
$BackupPath = "D:\Backups\A3PL_Config"
Copy-Item "Configs\*" $BackupPath -Recurse -Force
Copy-Item "Server Files\*" $BackupPath -Recurse -Force
```

### Mises à Jour

#### Procédure de Mise à Jour
1. **Arrêter le serveur** proprement
2. **Sauvegarder** la base de données
3. **Compiler** les nouveaux PBOs
4. **Tester** sur serveur de développement
5. **Déployer** en production
6. **Redémarrer** et vérifier

### Dépannage Courant

#### Problèmes de Connexion Base de Données
```sql
-- Vérifier la connexion
SHOW PROCESSLIST;
SHOW STATUS LIKE 'Connections';

-- Réinitialiser les connexions
FLUSH STATUS;
```

#### Problèmes de Performance
```bash
# Monitorer les ressources
Get-Process arma3server | Select-Object CPU, WorkingSet, PagedMemorySize
```

---

## 📞 Support

### Logs à Fournir
- **arma3server.rpt** - Log principal du serveur
- **server_console.log** - Console serveur  
- **MySQL error log** - Erreurs base de données
- **Windows Event Log** - Erreurs système

### Commandes de Diagnostic
```bash
# Test connectivité serveur
Test-NetConnection -ComputerName your-server.com -Port 2302

# Vérification processus
Get-Process | Where-Object {$_.Name -like "*arma*"}

# État MySQL
Get-Service MySQL80
```

---

**⚠️ Important** : Toujours tester les configurations sur un environnement de développement avant la mise en production !