# Hatari for the browser — Radio Équinoxe build

*Version française en bas de page.*

This repository contains the **modified source code** of the [Hatari](https://www.hatari-emu.org/)
Atari ST emulator used on the "Captain Blood" page of the Radio Équinoxe website, where it runs
in the browser (compiled to WebAssembly with Emscripten). It is published to comply with the
GNU General Public License (Hatari and EmuTOS are GPL software).

- **Base:** upstream Hatari 2.6.1-devel, commit `96c7228` of <https://github.com/hatari/hatari>.
- **Our changes:** the second commit of this repository, on top of an unmodified snapshot of the
  upstream tree (first commit) — `git show HEAD` shows exactly what was changed.
- **Operating system:** EmuTOS 1.4, 192 KB UK image (`etos192uk.img`), **unmodified**. Its complete
  source code is included in [`third_party/emutos/`](third_party/emutos/).
- **No game is distributed.** Visitors load their own disk images; they stay in the browser.
- The published build does **not** include the SPS / CAPSImage library (no `.ipf` support).

## What was changed

| File | Change |
|---|---|
| `CMakeLists.txt` | Emscripten flags: `-DEMSCRIPTEN` (newer Emscripten only defines `__EMSCRIPTEN__`, which disabled Hatari's browser code) and `-sSUPPORT_LONGJMP=wasm`. |
| `src/CMakeLists.txt` | JSPI instead of Asyncify (`-sJSPI`), C++ runtime libraries, exported functions used by the page (floppy insert/eject/flush), exported runtime methods (`ccall`, `cwrap`, `FS`). |
| `src/cpu/CMakeLists.txt` | The CPU table generators are compiled with Emscripten and run with Node.js (no native host compiler needed). |
| `src/sdl/timing.c` | Yield to the browser once per VBL (`emscripten_sleep`), otherwise the page freezes. |
| `src/floppy.c`, `src/includes/floppy.h` | New `Floppy_FlushDisk()`: writes a modified `.st`/`.msa` image back to its file without ejecting it (used for the game save disk). |
| `src/sdl/statusbar.c` | Reports the floppy drive LED to the page (`Module.onFloppyLed`). |
| `src/emscripten.js` | Default command line (Atari ST, 1 MB, no status bar, borders). Disk images are added at boot by the page. |
| `src/emscripten_shell.html` | Minimal page (canvas only) driven by the parent page through `postMessage`: boot with disk images, add/insert/eject disks, read back the save disk, keyboard focus, mouse capture. |

## How to build

Tested on Windows with Git Bash; the same steps work on Linux/macOS.

1. Install [emsdk](https://emscripten.org/docs/getting_started/downloads.html) and activate
   **Emscripten 7.0.1**, plus CMake and Ninja.
2. Put the EmuTOS 192 KB UK image in the build directory as `files/tos.img`
   (from the official EmuTOS 1.4 release, `emutos-192k-1.4.zip`, file `etos192uk.img`;
   or build it from `third_party/emutos/`).
3. Configure and build, **without** CAPSImage:

   ```sh
   mkdir build && cd build
   mkdir files && cp /path/to/etos192uk.img files/tos.img
   emcmake cmake .. -G Ninja \
     -DCAPSIMAGE_INCLUDE_DIR=CAPSIMAGE_INCLUDE_DIR-NOTFOUND \
     -DCAPSIMAGE_LIBRARY=CAPSIMAGE_LIBRARY-NOTFOUND
   cmake --build . --target hatari
   ```

4. The result is in `build/src/`: `hatari.html`, `hatari.js`, `hatari.wasm`, `hatari.data`.
   It needs a browser with JSPI (WebAssembly JavaScript Promise Integration) support, such as
   recent Chrome or Firefox.

## Licences

- **Hatari:** GNU GPL version 2 or later — see [`gpl.txt`](gpl.txt) and [`readme.txt`](readme.txt).
- **EmuTOS:** GNU GPL version 2 or later — see `third_party/emutos/` (`doc/license.txt` in the archive).
- Emscripten ports: **SDL2** and **zlib** (zlib licence).

---

## En français

Ce dépôt contient le **code source modifié** de l'émulateur Atari ST [Hatari](https://www.hatari-emu.org/),
utilisé dans le navigateur sur la page « Captain Blood » du site de Radio Équinoxe. Il est publié
pour respecter la licence GNU GPL d'Hatari et d'EmuTOS.

- Base : Hatari 2.6.1-devel, commit `96c7228` du dépôt officiel (1er commit, copie exacte) ; nos
  modifications forment le 2e commit (détail dans le tableau ci-dessus).
- Système : EmuTOS 1.4 (image 192 Ko anglaise), **non modifié** ; son code source complet est dans
  `third_party/emutos/`.
- **Aucun jeu n'est fourni** : le visiteur charge ses propres images de disquette, qui restent dans
  son navigateur.
- La version publiée n'inclut **pas** la bibliothèque SPS / CAPSImage (pas de lecture des `.ipf`).
