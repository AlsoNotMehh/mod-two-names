# ![logo](https://raw.githubusercontent.com/azerothcore/azerothcore.github.io/master/images/logo-github.png) AzerothCore Module: mod-two-names

[![AzerothCore Module](https://img.shields.io/badge/AzerothCore-Module-red?style=flat-square&logo=github)](https://github.com/azerothcore/azerothcore-wotlk)
[![C++20](https://img.shields.io/badge/Language-C++20-00599C?style=flat-square&logo=c%2B%2B)](https://isocpp.org/)
[![Branch 3.3.5a](https://img.shields.io/badge/Branch-3.3.5a-orange?style=flat-square)](https://github.com/azerothcore/azerothcore-wotlk)
[![License MIT](https://img.shields.io/badge/License-MIT-blue?style=flat-square)](LICENSE)
[![GitHub Stars](https://img.shields.io/github/stars/AlsoNotMehh/mod-two-names?style=flat-square&color=yellow&logo=github)](https://github.com/AlsoNotMehh/mod-two-names/stargazers)

A seamless character naming module for **AzerothCore (WotLK 3.3.5a)** that allows players to create characters with **two names** (First Name and Last Name separated by a single space, e.g. `John Doe`, `Arthas Menethil`, `Jane Smith`) directly from the standard character creation screen using the native name input box.

---

### 💡 Why this module?
In standard World of Warcraft 3.3.5a, character names are strictly limited to a single continuous word. Many RP, custom, and modern servers desire first and last names for richer immersion, family lineages, and distinct character identities.

**`mod-two-names`** seamlessly integrates directly into AzerothCore's character creation, name normalization, and validation pipeline:
- **Same Native Name Box:** Players type their full name (e.g. `John Doe`) directly into the standard character creation and rename input box.
- **Smart Auto-Capitalization:** Automatically formats each name part with proper casing regardless of how it was typed (`john doe` ➔ `John Doe`, `JOHN DOE` ➔ `John Doe`, `jOhN dOE` ➔ `John Doe`).
- **WoW Regulation Compliant:** Enforces strict boundary rules, valid alphabetic character sets, minimum length per name part, and triple consecutive identical letter checks.
- **Dual-Layer Filter Protection:** Validates the entire name **and** each individual name part against the server's Reserved Names and Profanity Filter tables.
- **Complete In-Game Systems Compatibility:** Full support for Chat Whispers, `/who`, `/invite`, Friends list, Ignore list, Guild management, In-Game Mail, and GM commands.

---

## 📊 Feature Comparison

| Feature | Standard 3.3.5 Server | mod-two-names |
| :--- | :---: | :---: |
| **Two Names (First & Last)** | ❌ Hard rejected with "Invalid Name" | ✅ **Fully supported (`John Doe`, `Arthas Menethil`)** |
| **UI Integration** | ⚠️ Often requires complex custom UI frames | ✅ **Native standard character creation box** |
| **Auto-Capitalization** | ❌ Only capitalizes the first character | ✅ **Automatically capitalizes each word part** |
| **Per-Part Length Rules** | ❌ Checks only overall length | ✅ **Configurable minimum length for first & last name** |
| **Reserved Name Check** | ⚠️ Checks only full string | ✅ **Checks both full name and each individual part** |
| **Profanity Filter** | ⚠️ Checks only full string | ✅ **Checks both full name and each individual part** |
| **Whispers & Social Systems** | ❌ Spaces break player lookups | ✅ **Seamless integration with whispers, `/who`, mail, guild** |

---

## ⚙️ Configuration Reference (`mod_two_names.conf`)

| Setting | Default | Description |
| :--- | :---: | :--- |
| `TwoNames.Enable` | `1` | Master switch to enable or disable the two names module. |
| `TwoNames.RequireTwoNames` | `0` | If `1`, requires all characters to have 2 names. If `0`, allows both 1 and 2 names. |
| `TwoNames.MinNameLength` | `2` | Minimum total character length for character names. |
| `TwoNames.MaxNameLength` | `25` | Maximum total character length (default `25` = 12 first name + 1 space + 12 last name, exactly like WoW Forever). |
| `TwoNames.MinPartLength` | `2` | Minimum character length for each individual word part (e.g. `Jo` and `Do` are valid; `J D` is blocked). |
| `TwoNames.MaxPartLength` | `12` | Maximum character length for each individual word part (standard WoW 12 letters per word). |
| `TwoNames.AllowMultipleSpaces` | `0` | If `0`, allows only 1 separating space (First and Last name). If `1`, allows 3+ names. |
| `TwoNames.StrictPlayerNames` | `-1` | Strict language mask (`-1` uses core setting, `0` = any language, `1` = basic latin, `2` = realm). |

---

## 🎮 In-Game Systems Compatibility

- 💬 **Chat & Whispers:** Whisper players via `/w "John Doe" hello`, `/w John Doe hello`, or simply clicking `[John Doe]` chat links.
- 🔍 **/who Query:** Search and filter players using `/who John Doe`.
- ⚔️ **Party & Raid:** Invite members directly with `/invite John Doe`.
- 🏰 **Guild System:** `/guildinvite John Doe`, roster listing, promotion, demotion, and officer notes.
- 📜 **In-Game Mail:** Send mail by entering `John Doe` in the recipient field.
- 👥 **Social Lists:** Add two-named characters to your Friend list and Ignore list.
- 🛠️ **GM Commands:** Works with `.character rename`, `.tele name "John Doe"`, `.lookup player`, and all admin tools.

---

## 📦 Installation Guide

### Step 1: Install Server Module
1. Place the module in your `azerothcore/modules/` directory:
   ```bash
   cd azerothcore/modules
   git clone https://github.com/AlsoNotMehh/mod-two-names.git
   ```
2. Re-run CMake and compile your server:
   ```bash
   cmake -B build
   cmake --build build --config Release
   ```
3. Copy `conf/mod_two_names.conf.dist` to your `worldserver` configs folder as `mod_two_names.conf`.
4. *(Optional)* If you configure `TwoNames.MaxNameLength > 12`, run `data/sql/db-characters/01_two_names_table_size.sql` on your characters database.

---

### Step 2: Client `Wow.exe` Patch (Why & How)

#### ❓ Why is a client patch needed?
In the unmodified World of Warcraft 3.3.5a client (`build 12340`), `Wow.exe` contains a hardcoded client-side alphabetical validation routine (`ValidateName` at virtual address `0x006B0F90` / file offset `0x2B0390`). 

When a player types a space in the character name box, this client function intercepts it before sending any network packets and immediately displays the pop-up error:
> *"Names can only contain letters."*

By applying a quick 6-byte patch (`mov eax, 0x57; ret`), `Wow.exe` skips the client-side blocker and forwards the character name straight to AzerothCore via `CMSG_CHAR_CREATE`, where `mod-two-names` handles all the security, word checks, auto-capitalization, and database persistence.

#### 🔧 1-Click Patching Methods:

- **Option A: 1-Click Drag & Drop (`patch_wow.bat`) - Recommended for Players & Admins**
  - Simply double-click [`patch_wow.bat`](patch_wow.bat) (or drag & drop your `Wow.exe` onto it).
  - Automatically patches both the space validation check and unlocks character name input length!

- **Option B: PowerShell (Windows native)**
  ```powershell
  cd modules/mod-two-names/tools
  .\patch_wow_exe.ps1 "C:\Path\To\World of Warcraft\Wow.exe"
  ```

- **Option C: Node.js**
  ```bash
  cd modules/mod-two-names/tools
  node patch_wow_exe.js "C:\Path\To\World of Warcraft\Wow.exe"
  ```

- **Option D: Python**
  ```bash
  cd modules/mod-two-names/tools
  python patch_wow_exe.py "C:\Path\To\World of Warcraft\Wow.exe"
  ```

- **Option D: Manual Hex Editor (HxD)**
  - Open `Wow.exe` in any Hex Editor.
  - Navigate to offset `0x2B0390`.
  - Replace the 6 bytes: `55 8B EC 8B 45 08` with `B8 57 00 00 00 C3`.
  - Save the file.

---

## ⭐ Show your support

If you find this module helpful for your server, please consider giving it a **star on GitHub**! It helps more developers in the AzerothCore community discover the project.

---

## 👥 Credits

- **Author:** [AlsoNotMehh](https://github.com/AlsoNotMehh) ([Discord](https://discord.com/users/1063304041419001966) / [Email](mailto:itsbrayanrodriguez@gmail.com))
- **Framework:** [AzerothCore](https://www.azerothcore.org)

---

## 📄 License

This project is licensed under the [GNU AGPL v3 License](LICENSE).
