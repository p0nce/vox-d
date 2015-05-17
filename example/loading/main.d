import std.stdio;
import voxd;

void main(string[] args)
{
    VOX treeModel = decodeRawVOX("tree2.vox");

    writefln("width = %s", treeModel.width);
    writefln("height = %s", treeModel.height);
    writefln("depth = %s", treeModel.depth);
    writefln("That makes %s voxels total", treeModel.numVoxels());

    VoxColor color = treeModel.voxel(0, 1, 2);
    writefln("voxel (0, 1, 2) has color (r = %s, g = %s, b = %s, a = %s)", color.r, color.g, color.b, color.a);

    VOX flagModel = decodeKVX("FlagBlue.kvx");

    writefln("width = %s", flagModel.width);
    writefln("height = %s", flagModel.height);
    writefln("depth = %s", flagModel.depth);
    writefln("That makes %s voxels total", flagModel.numVoxels());
}
