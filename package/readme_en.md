# 1885 Start Support 1.0.0-alpha – Windows package

The package includes **anleitung_de.pdf**, a German illustrated step-by-step guide. This English readme remains available as a text reference.

Created by Lord. Vibecoding by Codex. Includes companion mod revision 5 and a separate Windows menu patch tool. Python is not required. No base-game archive, models or textures are bundled.

## Install

1. Extract the complete package to its own folder and close TF3 completely.
2. Find the game installation folder containing `TransportFever3.exe`. In Steam, use Manage → Browse local files.
3. Open PowerShell in the extracted package folder. Replace the example installation path and run:

```powershell
powershell.exe -NoProfile -ExecutionPolicy RemoteSigned -File .\menu_patch.ps1 -Mode apply -GamePath "C:\Program Files (x86)\Steam\steamapps\common\Transport Fever 3"
```

The execution policy applies to this process only. If Windows blocks a downloaded Internet-marked script, review the script, open its file properties and use Unblock where available. No persistent security settings are changed. The game folder must be writable.

4. Copy `start_year_1885` into the TF3 userdata `mods` folder. Steam location: `<Steam>/userdata/<account-ID>/3493540/local/mods/`. New technical mod ID: `start_year_1885`. Disable the previous companion mod, remove its old folder from the mod directory and enable this version once. Do not keep parallel versions. A development copy in `staging_area` takes precedence over manual/subscribed versions: update it too or move it out of staging.
5. Launch TF3, enable 1885 Start Support revision 5 and create a new free game, explicitly selecting 1885. Keep the old Start Year 1850 calendar-reset prototype disabled.

The mod extends private horse coaches, early depots, maintenance buildings and early street terminals to 1885. Purchasable vehicles retain all original statistics and availability dates; the first passenger droshky remains available from 1892. Small roadside stops retain cargo-unloading-only behavior. Use the universal cargo terminal to collect goods.

## Inspect, restore and limitations

Use the same command with `-Mode inspect` for a read-only check (also the default mode). With the game closed, `-Mode restore` restores the original 1900 menu. It does not remove the mod or alter savegames.

Only the exact original/patched archive and content-index hashes in `patch.json` are supported (the examined Windows build 40423). Unknown files or newer versions are rejected. The original backup is stored beside `gui.zip` as `gui.1885-original-<hash>.bak`; an invalid backup is never overwritten. A verified patched archive can also be reversed into the byte-identical original backup. A leftover `gui.1885-patch.tmp` blocks further changes and is retained for inspection.

Updates or Steam verification may reset the menu. A new build requires a newly verified patch. Consoles and other operating systems are not supported by this complete package. Removing the companion mod before 1900 and save compatibility are unverified; use a separate saved copy for testing.

The user reports that the private-traffic fix appears to work. Offline checks cover native models/constructions, terminal factories, unchanged vehicle data, external-tool installation/restoration/rejection cases and a round trip on a copy of the real archive. An engine test of the complete package, including loading goods, maintenance and save/load, is outstanding. No ModHub approval is claimed.

## Publish

This complete download is **not a ModHub upload package**. The official guidelines prohibit shell scripts and external executables inside mods. Publish this package externally. The separate `TF3_1885_Starthilfe_ModHub_1.0.0-alpha.zip` contains only the companion mod folder. Add the actual external patch download link to both languages of its description, validate it from the developer staging area and upload through Mod Hub → My Mods. Platform approval remains unverified. Subscribing to the companion mod alone does not change the start-year menu.

Sources: [Requirements](https://wiki.transportfever3.com/doku.php?id=modding:general:guidelines), [Publishing](https://wiki.transportfever3.com/doku.php?id=modding:general:publishing), [Mod scripts](https://wiki.transportfever3.com/doku.php?id=modding:general:modscripts), [File locations](https://wiki.transportfever3.com/doku.php?id=gamemanual:installation:gamefilelocations).

No license has been declared. Original scripts and targeted byte edits only; installed Urban Games resources are processed locally.
