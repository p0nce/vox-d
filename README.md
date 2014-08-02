## What's this?

vox-d is a tiny library to load/save VOX voxel files.


## Licenses

See UNLICENSE.txt


## Usage


```d

import std.stdio;
import voxd;

void main()
{
    VOX input = decodeVOX("my_model.vox");
    writefln("width = %s", input.width);
    writefln("height = %s", input.height);
    writefln("depth = %s", input.depth);
    input.encodeVOX("terrain.vox");
}

```
