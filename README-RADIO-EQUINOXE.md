# Hatari for the browser — Radio Équinoxe build

*Version française en bas de page.*

This repository contains the **modified source code** of the [Hatari](https://www.hatari-emu.org/)
Atari ST emulator used on the "Captain Blood" page of the Radio Équinoxe website, where it runs
in the browser (compiled to WebAssembly with Emscripten). It is published to comply with the
GNU General Public License (Hatari and EmuTOS are GPL software).

- **Base:** upstream Hatari 2.6.1-devel, commit `96c7228` of <https://github.com/hatari/hatari>.
- **Our changes:** the commits after the first one, which is an unmodified snapshot of the
  upstream tree — `git diff 651983e HEAD -- . ':!third_party'` shows exactly what was changed in
  Hatari itself; `third_party/` holds the EmuTOS and SPS Decoder Library sources.
- **Operating system:** EmuTOS 1.4, 192 KB UK image (`etos192uk.img`), **unmodified**. Its complete
  source code is included in [`third_party/emutos/`](third_party/emutos/).
- **No game is distributed.** Visitors load their own disk images; they stay in the browser.
- **`.ipf` disk images** are read with the **SPS Decoder Library (CAPSImage)**, used with the
  permission of KryoFlux GmbH (non-commercial use). Its source code, the small `config.h` added to
  compile it with Emscripten and the build script are in [`third_party/capsimg/`](third_party/capsimg/).

## What was changed

| File | Change |
|---|---|
| `CMakeLists.txt` | Emscripten flags: `-DEMSCRIPTEN` (newer Emscripten only defines `__EMSCRIPTEN__`, which disabled Hatari's browser code) and `-sSUPPORT_LONGJMP=wasm`. |
| `src/CMakeLists.txt` | JSPI instead of Asyncify (`-sJSPI`), C++ runtime libraries, exported functions used by the page (floppy insert/eject/flush, touch input, key presses), exported runtime methods (`ccall`, `cwrap`, `FS`). |
| `src/cpu/CMakeLists.txt` | The CPU table generators are compiled with Emscripten and run with Node.js (no native host compiler needed). |
| `src/sdl/timing.c` | Yield to the browser once per VBL (`emscripten_sleep`), otherwise the page freezes. |
| `src/floppy.c`, `src/includes/floppy.h` | New `Floppy_FlushDisk()`: writes a modified `.st`/`.msa` image back to its file without ejecting it (used for the game save disk). |
| `src/sdl/gui_event.c`, `src/includes/gui_event.h` | Touch screens (iPad): `GuiEvent_TouchMouseMove()` and `GuiEvent_TouchMouseButton()`, called by the page, which turns finger gestures into mouse movement and clicks. |
| `src/sdl/statusbar.c` | Reports the floppy drive LED to the page (`Module.onFloppyLed`). |
| `src/emscripten.js` | Default command line (Atari ST, 1 MB, no status bar, borders). Disk images are added at boot by the page. |
| `src/emscripten_shell.html` | Minimal page (canvas only) driven by the parent page through `postMessage`: boot with disk images, add/insert/eject disks, read back the save disk, keyboard focus, mouse capture, touch commands (pointer movement, buttons, Atari keys via `IKBD_PressSTKey`). |

## How to build

Tested on Windows with Git Bash; the same steps work on Linux/macOS.

1. Install [emsdk](https://emscripten.org/docs/getting_started/downloads.html) and activate
   **Emscripten 7.0.1**, plus CMake and Ninja.
2. Put the EmuTOS 192 KB UK image in the build directory as `files/tos.img`
   (from the official EmuTOS 1.4 release, `emutos-192k-1.4.zip`, file `etos192uk.img`;
   or build it from `third_party/emutos/`).
3. Build the SPS Decoder Library (CAPSImage), for `.ipf` support:

   ```sh
   sh third_party/capsimg/build-wasm.sh /path/to/capsimg-wasm
   ```

4. Configure and build Hatari with it:

   ```sh
   mkdir build && cd build
   mkdir files && cp /path/to/etos192uk.img files/tos.img
   emcmake cmake .. -G Ninja -DCMAKE_BUILD_TYPE=Release \
     -DCAPSIMAGE_INCLUDE_DIR=/path/to/capsimg-wasm/include \
     -DCAPSIMAGE_LIBRARY=/path/to/capsimg-wasm/lib/libcapsimage.a
   cmake --build . --target hatari
   ```

   Without `.ipf` support: skip step 3 and pass `CAPSIMAGE_INCLUDE_DIR-NOTFOUND` and
   `CAPSIMAGE_LIBRARY-NOTFOUND` instead.

5. The result is in `build/src/`: `hatari.html`, `hatari.js`, `hatari.wasm`, `hatari.data`.
   It needs a browser with JSPI (WebAssembly JavaScript Promise Integration) support, such as
   recent Chrome or Firefox.

## Licences

- **Hatari:** GNU GPL version 2 or later — see [`gpl.txt`](gpl.txt) and [`readme.txt`](readme.txt).
- **EmuTOS:** GNU GPL version 2 or later — see `third_party/emutos/` (`doc/license.txt` in the archive).
- Emscripten ports: **SDL2** and **zlib** (zlib licence).
- **SPS Decoder Library (CAPSImage):** SPS DECODER LIBRARY Copyright (c) 2001-2014 by István Fábián
  under exclusive licence to KryoFlux Products & Services Ltd. **Non-commercial use only**; used here
  with the permission of KryoFlux GmbH. Copyright notice, licence conditions and disclaimer:
  [`third_party/capsimg/LICENCE.txt`](third_party/capsimg/LICENCE.txt). Source: unmodified
  [FrodeSolheim/capsimg](https://github.com/FrodeSolheim/capsimg), commit `ed4cb09`, plus
  `CAPSImg/config.h` (two lines) and `build-wasm.sh`. Hatari explicitly allows being used with it
  (see `readme.txt`, section 3.3).

---

## En français

Ce dépôt contient le **code source modifié** de l'émulateur Atari ST [Hatari](https://www.hatari-emu.org/),
utilisé dans le navigateur sur la page « Captain Blood » du site de Radio Équinoxe. Il est publié
pour respecter la licence GNU GPL d'Hatari et d'EmuTOS.

- Base : Hatari 2.6.1-devel, commit `96c7228` du dépôt officiel (1er commit, copie exacte) ; nos
  modifications sont les commits suivants (détail dans le tableau ci-dessus) ; `third_party/`
  contient les sources d'EmuTOS et de la bibliothèque SPS.
- Système : EmuTOS 1.4 (image 192 Ko anglaise), **non modifié** ; son code source complet est dans
  `third_party/emutos/`.
- **Aucun jeu n'est fourni** : le visiteur charge ses propres images de disquette, qui restent dans
  son navigateur.
- Lecture des images **`.ipf`** : bibliothèque **SPS Decoder Library (CAPSImage)**, utilisée avec
  l'accord de KryoFlux GmbH (usage non commercial uniquement). Ses sources, le petit `config.h`
  ajouté pour la compiler avec Emscripten et le script de compilation sont dans
  `third_party/capsimg/` ; licence, conditions et clause de non-responsabilité dans
  `third_party/capsimg/LICENCE.txt`.
