/**
 * AzerothCore mod-two-names: Client Wow.exe Patcher (Node.js)
 * 
 * Patches Wow.exe (3.3.5a build 12340):
 * 1. Patches ValidateName (offset 0x2B0390) so that spaces in character names
 *    (e.g. "John Doe") are accepted during character creation and sent to the server.
 * 2. Patches EditBox::InsertChar (offset 0x564F23) to unlock the 12-character keyboard
 *    typing limit so players can create longer names (e.g. "Illegal Immigrant").
 *
 * Usage:
 *   node patch_wow_exe.js [path/to/Wow.exe]
 */

const fs = require('fs');
const path = require('path');

const targetPath = process.argv[2] || 'Wow.exe';

if (!fs.existsSync(targetPath)) {
  console.error(`[Error] Target file '${targetPath}' not found.`);
  console.error('Usage: node patch_wow_exe.js <path-to-Wow.exe>');
  process.exit(1);
}

const backupPath = targetPath + '.bak_two_names';
if (!fs.existsSync(backupPath)) {
  fs.copyFileSync(targetPath, backupPath);
  console.log(`[Backup] Created backup at '${backupPath}'`);
}

const buf = fs.readFileSync(targetPath);

// 1. Space support in ValidateName (Offset: 0x2B0390, VA: 0x006B0F90)
const offset = 0x2B0390;
const patch = Buffer.from([0xB8, 0x57, 0x00, 0x00, 0x00, 0xC3]); // mov eax, 0x57; ret
patch.copy(buf, offset);

// 2. Unlock character input length limit (Offset: 0x564F23, VA: 0x00965B23)
const lenOffset = 0x564F23;
const lenPatch = Buffer.from([0xE9, 0xF5, 0x00, 0x00, 0x00, 0x90]); // jmp 0x965c1d; nop
lenPatch.copy(buf, lenOffset);

fs.writeFileSync(targetPath, buf);
console.log(`[Success] Successfully patched '${targetPath}' for dual names & expanded name length!`);
