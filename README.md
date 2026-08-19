# 🎮 ArmA 3 Project Life Framework

<div align="center">
  <img src="https://arma3projectlife.com/img/logo.png" alt="A3PL Logo" height="160"/>
  
  **Framework de Roleplay Complet pour ArmA 3**
  
  [![License](https://img.shields.io/badge/License-Proprietary-red.svg)](LICENSE)
  [![Version](https://img.shields.io/badge/Version-A3PL%202024-blue.svg)]()
  [![ArmA 3](https://img.shields.io/badge/ArmA%203-Compatible-green.svg)]()
</div>

---

## 📋 À Propos

**ArmA 3 Project Life (A3PL)** est un framework de roleplay avancé pour ArmA 3, développé conjointement par les associations **Pure Objective** et **Polarion**. Ce mod transforme complètement ArmA 3 en une expérience de roleplay civil immersive avec des systèmes économiques, de factions, et d'activités complexes.

### ✨ Caractéristiques Principales

- 🏛️ **4 Factions** spécialisées (Police, Pompiers, Justice, Gouvernement)
- 💰 **Système économique** complet avec entreprises et bourses
- 🏠 **Immobilier** dynamique (maisons, entrepôts)
- 📱 **Communications** réalistes (téléphones, radios, réseaux sociaux)
- 🎯 **Métiers** civils et illégaux
- 🏆 **Système d'événements** et d'activités

---

## 📁 Structure du Projet

```
framework/
├── 📂 Configs/              # Configuration serveur ArmA 3
├── 📂 Server Files/
│   ├── 📂 PO.FishersIsland/ # Mission client (dialogues, configs)
│   └── 📂 PO_Backend/       # Backend serveur (logique métier)
├── 📂 SQL/                  # Base de données MySQL
├── 📂 Sources TFAR/         # Task Force Radio (communications)
├── 📂 PBOManager/           # Outils de compilation
└── 📂 Powershell Scripts/   # Scripts d'automatisation
```

### 🔧 Architecture Technique

- **Client-Serveur** : Séparation claire entre interface utilisateur et logique métier
- **Modulaire** : 82+ modules fonctionnels organisés par système
- **Base de données** : MySQL avec tables optimisées pour les performances
- **Communications** : Intégration TFAR pour réalisme vocal

---

## 🚀 Installation Rapide

### Prérequis
- **ArmA 3** avec DLCs recommandés
- **Serveur MySQL** 8.0+
- **Task Force Radio** pour les communications
- **Windows Server** ou équivalent

### Installation
1. **Cloner le repository**
   ```bash
   git clone https://git.arma3projectlife.app/arma3projectlife/framework.git
   cd ArmA3ProjectLife/framework
   ```

2. **Configuration Base de Données**
   ```sql
   mysql -u root -p < SQL/database.sql
   ```

3. **Compilation des PBOs**
   ```powershell
   # Utiliser les scripts PowerShell fournis
   .\Powershell Scripts\fetch and pbo.ps1
   ```

4. **Configuration Serveur**
   - Éditer `Configs/Server_A3_1.cfg`
   - Configurer les paramètres réseau et performances

---

## 🎭 Systèmes Principaux

### 👮 Factions d'Urgence
| Faction | Nom Complet |
- | **RCSO** | Redwater County Sheriff's Office |
- | **RCFD** | Redwater County Fire Department |
- |  **RCC** | Redwater County Court |
- |  **RC**  | Redwater County |

### 💼 Économie
- **Entreprises** : 20+ entreprises actives avec employés et hiérarchies
- **Banques** : Comptes
- **Immobilier** : Achat/vente de propriétés

### 🔨 Métiers Disponibles
**Civils** : Livreur, Agriculteur, Pêcheur, Taxi, Transporteur, Mécanicien...  
**Illégaux** : Trafic de drogue, Braquages, Gangs, Chopshop...

---

## 📖 Documentation

### 📚 Guides Principaux
- [🔧 Installation et Configuration](docs/installation.md)

### 🔍 Documentation Technique
- [🏗️ Architecture](docs/architecture.md)

---

## 🛠️ Développement

### Technologies Utilisées
- **SQF** (Scripting ArmA 3)
- **MySQL** (Base de données)
- **PowerShell** (Automatisation)
- **Task Force Radio** (Communications)

### Structure du Code
```
PO_Backend/Content/
├── 📂 Configs/     # 22 fichiers de configuration
├── 📂 Functions/   # 82 modules client
└── 📂 Server/      # 40+ modules serveur
```

### Contribution
1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/nouvelle-fonctionnalite`)
3. Commit les changements (`git commit -am 'Ajout nouvelle fonctionnalité'`)
4. Push la branche (`git push origin feature/nouvelle-fonctionnalite`)
5. Ouvrir une Pull Request

---

## 📄 Licence et Droits

```
Copyright © POLARION (SIREN 930088620)
Tous droits réservés - https://www.polarion.fr

USAGE RESTREINT : Ce framework est protégé par les droits d'auteur.
Distribution ou modification non autorisée strictement interdite.
Consulter : https://www.bistudio.com/community/game-content-usage-rules
Contact : hello@polarion.fr
```

---

## 📞 Support et Contact

### 🆘 Support Technique
- **Site Web** : [https://www.polarion.fr](https://www.polarion.fr)
- **Email** : hello@polarion.fr
- **Discord** : [Serveur Communauté](https://discord.gg/votre-serveur)

### 🐛 Rapport de Bugs
Utilisez le système d'issues GitHub pour signaler les problèmes :
```
[BUG] Titre du problème
- Description détaillée
- Étapes de reproduction
- Logs/captures d'écran
```

### 🤝 Communauté
- **Forum** : Discussions et entraide
- **Wiki** : Documentation communautaire
- **YouTube** : Tutoriels et gameplay

---

## 🏆 Crédits

### 👨‍💻 Équipe de Développement
**Pure Objective** - Association française de développement  
**Polarion** - Association partenaire  
Développé conjointement par les deux associations

### 🙏 Remerciements
- **Bohemia Interactive** pour ArmA 3
- **Communauté TFAR** pour les communications
- **Serveur ArmA 3 Project Life** pour les tests
- **Communauté francophone** ArmA 3 RP

---

<div align="center">
  <strong>🎮 ArmA 3 Project Life - Votre aventure roleplay commence ici ! 🌊</strong>
  
  ⭐ **N'oubliez pas de mettre une étoile si ce projet vous plaît !** ⭐
</div>