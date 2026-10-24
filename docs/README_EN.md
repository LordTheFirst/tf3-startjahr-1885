# 1885 Start for Transport Fever 3

[Deutsch](../README.md) · [Download v1.0.0-alpha](https://github.com/LordTheFirst/tf3-startjahr-1885/releases/tag/v1.0.0-alpha) · [German PDF manual](TF3_1885_Anleitung_DE.pdf)

Start a new free game in **1885**. The local menu patch enables the year selection; the companion mod enables early private AI coaches, depots, maintenance buildings and street terminals. Purchasable vehicles retain their original statistics and availability dates.

**Windows only; exact inspected game files from Build 40423. Alpha / companion revision 5.** Offline checks passed. Full in-game testing, including loading/unloading, maintenance and save/load, is still pending. Use a separate test save.

## Install

1. Download **`TF3_1885_Start_Windows_Komplett_1.0.0-alpha.zip`** from the release assets. GitHub's automatic “Source code” downloads are not the Windows complete package. Extract the entire ZIP and close the game.
2. Open PowerShell in the extracted folder and run:

   ```powershell
   powershell.exe -NoProfile -ExecutionPolicy RemoteSigned -File .\menu_patch.ps1 -Mode apply
   ```

   Supply the game installation folder containing `TransportFever3.exe` when prompted. If Windows blocks the downloaded script, inspect it and use its file properties to unblock it if appropriate. The game folder must be writable. No Python installation is required.
3. Copy the complete `start_year_1885` folder to `<Steam-folder>/userdata/<account-ID>/3493540/local/mods/`. Disable the previous companion mod and move its old folder out of the mod directory. A developer copy in `staging_area` takes precedence.
4. Enable “1885 Start Support”, revision 5, then explicitly choose **1885** for a new free game. Keep the old “Start Year 1850” calendar-reset prototype disabled.

See the [full English text instructions](../package/readme_en.md) for details.

## Availability

The small goods horse cart remains available from **1885**; the first passenger carriage from **1892**. Small roadside stops unload cargo; use a universal cargo terminal to collect goods. Later building eras and purchasable vehicle data are retained.

## Inspect or restore

Close the game, then use the same command with `-Mode inspect` to check the menu or `-Mode restore` to restore the original 1900 menu. A backup is created before patching. Only known, checksum-verified originals and patched files are accepted. Updates and Steam file verification may reset the patch; unknown versions require a newly checked patch.

Restoring the menu does not remove the companion mod. Removing it from a pre-1900 save and save compatibility are unverified. A companion mod subscription alone does not modify the menu; the external patch is required.

## Feedback and credits

Use [Issues](https://github.com/LordTheFirst/tf3-startjahr-1885/issues/new/choose) with the build, revision, start year, reproduction steps and relevant log excerpt. Review logs for personal information before uploading.

**Created by Lord. Vibecoding by Codex.** Community project; not an official Urban Games release. No license has been declared. No base-game archives, models or textures are distributed. Project graphics are schematic illustrations rather than gameplay screenshots.
