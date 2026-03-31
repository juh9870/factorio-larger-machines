[![Release](https://github.com/juh9870/factorio-larger-machines/actions/workflows/release.yml/badge.svg?branch=main)](https://github.com/juh9870/factorio-larger-machines/actions/workflows/release.yml)

# Larger Machines mod

Mod and a library for enlarging machines. Enlarged machines connect to ducts from Fluid Must Flow instead of regular pipes

## Machines
- **Foundry** - Enlarged to 10x10
- **EM Plant** - Enlarged to 8x8
- **Cryogenic plant** - Enlarged to 10x10
- **Biolab** - Enlarged to 10x10
- **Advanced Furnace** (if K2SO is installed) - Enlarged to 14x14
- **Diesel Foundry** (if Diesel Foundry is installed) - Enlarged to 10x10

Disabled by default (can be enabled in mod settings):
- **Centrifuge** - Enlarged to 6x6.
- **Biochamber** - Enlarged to 6x6 (looks bad)
- **Big Mining Drill** - Enlarged to 10x10
- **Singularity Lab** (if K2SO is installed) - Enlarged to 16x16
- **Calciner** (if Pelagos or standalone Calciner is installed) - Enlarged to 6x6

Speed of enlarged machines is not affected (but you can place more beacons around them)

## Compatibility
- [Maraxsis](https://mods.factorio.com/mod/maraxsis) - Maraxsis gates ducts into itself, soft-locking the usage of enlarged machines. To combat this, the ducts recipe is moved back to Nauvis and switched to use steel+concrete instead of tungsten