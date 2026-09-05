# Quake4SDK

SDK to develop mods for Quake 4 on Linux.

# Dependencies
- You must have CMake 3.13 or greater.
- GCC compiler.
- A VALID COPY OF QUAKE 4 SOMEWHERE!!!

# Setup

## Quake 4 on Linux

Quake 4 did not ship with any Linux binaries, but id software USED TO provide a binary to patch it. I have created a script to automate most of the setup.

```
./install.sh [-o OUTPUT_DIR] [-s QUAKE_DIR]

-o		Specifies where the new Linux version will live. Defaults to "~/Games/Quake 4"
-s		Specifies where the old Quake 4 lives. Defaults to "~/.local/share/Steam/steamapps/common/Quake 4"
```

Make sure you have the following x86 libraries. On Arch, the following packages are:

- lib32-glibc
- lib32-libxau
- lib32-libxdmcp
- lib32-libxcb
- lib32-libxext
- lib32-libx11
- lib32-libz
- lib32-gcc-libs*
- lib32-sdl12-compat*

For Ubuntu, I think it's these libraries:
- pipewire-alsa:i386
- libsdl1.2debian:i386*


* these libs come with the binaries, so they don't need to be installed but can be.


## Developing with the SDK

Simply use your favorite IDE to modify the source code. When you want to build it, simply run `build.sh`. This will provide a `gamex86.so` file in the `build` directory. Simply copy this into your Quake 4 game folder.

For more inquiries, refer to [here](notes.md)
