## What's this?

vox-d is a library to load VOX voxel files (used by eg. MagicaVoxel).


## Licenses

See UNLICENSE.txt


## Usage


```d

import std.stdio;
import voxd;

void main()
{
    VOX model = decodeVOX("dragon.vox");

    writefln("width = %s", model.width);
    writefln("height = %s", model.height);
    writefln("depth = %s", model.depth);
    writefln("That makes %s voxels total", model.numVoxels());

    VoxColor color = model.voxel(0, 1, 2);
    writefln("voxel (0, 1, 2) has color (r = %s, g = %s, b = %s, a = %s)", color.r, color.g, color.b, color.a);
}

```
