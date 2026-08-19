# A3PL Localization System

This document explains how the A3PL localization system works and how to add new translations.

## Overview

The localization system uses a custom runtime translation approach instead of ArmA 3's built-in stringtable.xml. All translations are stored in SQF files and loaded into a HashMap at server startup.

### Supported Languages
- **FR** (French) - Default
- **EN** (English)

The active language is set in `Config_00_Localization.sqf` via `Server_Lang = "FR";`

---

## Architecture

```
Server Startup
     |
     v
A3PL_Localization_Init
     |  (loads all *_Localization functions)
     v
Localization_Strings[] (temporary array)
     |
     v
A3PL_Localization_Build
     |  (builds HashMap from array)
     v
Localization (HashMap) -> publicVariable to all clients
```

---

## Translation Files Structure

Translation files are located in:
```
A3PL_Backend/Content/Configs/Localization/
```

Each file follows this pattern:

```sqf
["MyFeature_Localization", {
    Localization_Strings append [
        // ["KEY",                    "French",           "English"],
        ["STR_MyFeature_Title",       "Mon Titre",        "My Title"],
        ["STR_MyFeature_Description", "Ma Description",   "My Description"]
    ];
}] call compile_Server;
```

### Key Naming Convention

Keys should follow the pattern: `STR_<Category>_<Name>`

Examples:
- `STR_Common_Yes` - Common strings
- `STR_A3PL_Bank_Title` - Bank feature strings
- `STR_UI_Inventory_Weight` - UI-specific strings
- `STR_Mission_Config_SmartMarkers_Springfield` - Mission config strings

---

## How to Add New Translations

### Step 1: Create or Edit a Localization File

Create a new file or edit an existing one in the Localization folder:

```sqf
["A3PL_MyNewFeature_Localization", {
    Localization_Strings append [
        ["STR_MyNewFeature_Welcome",     "Bienvenue!",       "Welcome!"],
        ["STR_MyNewFeature_Goodbye",     "Au revoir!",       "Goodbye!"]
    ];
}] call compile_Server;
```

### Step 2: Register the Localization Function

Add your function name to the `_locFuncs` array in `Config_00_Localization.sqf`:

```sqf
private _locFuncs = [
    "A3PL_ATC_Localization",
    // ... other functions ...
    "A3PL_MyNewFeature_Localization"  // <-- Add your function here
];
```

### Step 3: Use the Translation in Code

```sqf
// Simple translation
private _text = "STR_MyNewFeature_Welcome" call A3PL_Localize;
hint _text; // Shows "Bienvenue!" or "Welcome!" based on Server_Lang
```

---

## Translation Functions

### A3PL_Localize
**Usage:** `"STR_Key" call A3PL_Localize`

Translates a string key to the current language. Returns the key itself if not found.

```sqf
private _yes = "STR_Common_Yes" call A3PL_Localize;
// Returns: "Oui" (FR) or "Yes" (EN)
```

### A3PL_LocalizeConfig
**Usage:** `"STR_Key" call A3PL_LocalizeConfig`

Used for translating text retrieved from .hpp config files. Only translates if the string starts with `STR_`.

```sqf
private _configText = getText(missionConfigFile >> "CfgMarkers" >> "marker1" >> "name");
private _translated = _configText call A3PL_LocalizeConfig;
```

### A3PL_Dialog_Localize
**Usage:** `findDisplay <IDD> call A3PL_Dialog_Localize`

Automatically translates all controls in a dialog that have text starting with `STR_`. Also handles tooltips.

```sqf
createDialog "MyDialog";
(findDisplay 12345) call A3PL_Dialog_Localize;
```

---

## Dialog Localization

### Step 1: Use STR_ Keys in .hpp Files

In your dialog definition:

```cpp
class MyDialog {
    idd = 12345;
    class Controls {
        class Title: RscText {
            idc = 1000;
            text = "STR_MyDialog_Title";  // <-- Use STR_ key here
        };
        class Button: RscButton {
            idc = 1600;
            text = "STR_MyDialog_Confirm";
            tooltip = "STR_MyDialog_ConfirmTooltip";  // <-- Tooltips work too
        };
    };
};
```

### Step 2: Call A3PL_Dialog_Localize After createDialog

In your SQF code that opens the dialog:

```sqf
["A3PL_MyFeature_OpenDialog", {
    if (!dialog) then {
        createDialog "MyDialog";
    };
    disableSerialization;
    (findDisplay 12345) call A3PL_Dialog_Localize;  // <-- Add this line

    // ... rest of your dialog initialization
}] call compile_Global;
```

---

## Config File Localization

For mission config files (CfgNotifications, CfgSmartMarkers, CfgMapAreas, etc.):

### Step 1: Use STR_ Keys in .hpp Configs

```cpp
class CfgNotifications {
    class Patterns {
        class Error {
            defaultTitle = "STR_Mission_Config_Notifications_Error";
            color[] = {1, 0, 0, 1};
        };
    };
};
```

### Step 2: Translate When Reading from Config

```sqf
private _title = getText(missionConfigFile >> "CfgNotifications" >> "Patterns" >> "Error" >> "defaultTitle");
private _translatedTitle = _title call A3PL_LocalizeConfig;
```

---

## Dynamic Text with Variables

For strings that need dynamic values, use `format` after translation:

```sqf
// In localization file:
["STR_Shop_Price", "Prix: %1$", "Price: %1$"],

// In code:
private _priceText = format ["STR_Shop_Price" call A3PL_Localize, 500];
// Result: "Prix: 500$" or "Price: 500$"
```

For multiple variables:

```sqf
// In localization file:
["STR_Transfer_Success", "%1 a envoyé %2$ à %3", "%1 sent %2$ to %3"],

// In code:
private _msg = format ["STR_Transfer_Success" call A3PL_Localize, _sender, _amount, _receiver];
```

---

## Debugging

The system logs translation activity to the RPT file:

```
[A3PL] Calling 170 localization functions
[A3PL] Localization_Strings filled with 5000 entries
[A3PL] Localization loaded: 5000 keys, Language: FR
[A3PL_Dialog_Localize] Found 25 controls
[A3PL_Dialog_Localize] IDC 1000: 'STR_MyDialog_Title' -> 'Mon Titre'
```

To check if a key exists:

```sqf
private _key = "STR_Test_Key";
private _translated = _key call A3PL_Localize;
if (_translated == _key) then {
    diag_log format ["WARNING: Translation key not found: %1", _key];
};
```

---

## Best Practices

1. **Always use the STR_ prefix** for translation keys
2. **Group related translations** in the same localization file
3. **Use descriptive key names** that indicate the feature and purpose
4. **Add translations for both languages** to avoid missing text
5. **Test dialogs after adding localization** to ensure all controls are translated
6. **Keep format placeholders consistent** between languages (%1, %2, etc.)

---

## File Reference

| File | Purpose |
|------|---------|
| `Config_00_Localization.sqf` | Core localization system and functions |
| `Localization/*_Localization.sqf` | Translation string definitions |
| `Dialogs/*.hpp` | Dialog definitions with STR_ keys |
| `Mission configs (Cfg*.hpp)` | Mission config files with STR_ keys |

---

## Changing the Server Language

Edit `Config_00_Localization.sqf`:

```sqf
["A3PL_Localization_Init", {
    Server_Lang = "EN";  // Change from "FR" to "EN"
    // ...
}] call compile_Server;
```

After changing, restart the server for the new language to take effect.
