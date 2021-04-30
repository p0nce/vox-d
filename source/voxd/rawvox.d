module voxd.rawvox;

import std.range,
       std.file,
       std.array,
       std.string;

import voxd.utils;

/// Supports the VOX format used by the Build engine.
/// It is just a raw bitmap of 8-bit values.

/// Decodes a VOX file.
/// Throws: VoxdException on error.
VOX decodeRawVOXFromFile(string filepath)
{
    auto bytes = cast(ubyte[]) std.file.read(filepath);
    return decodeRawVOXFromMemory(bytes);
}

/// Decodes a VOX.
/// Throws: VoxdException on error.
VOX decodeRawVOXFromMemory(ubyte[] input)
{

    // check header
    int width = popLE!int(input);
    int height = popLE!int(input);
    int depth = popLE!int(input);

    if (width < 0 || height < 0 || depth < 0)
        throw new VoxdException("Strange value for dimensions, probably not such a VOX file");

    ubyte[] indices;
    indices.length = width * height * depth;
    for (size_t i = 0; i < indices.length; ++i)
    {
        indices[i] = popUbyte(input);
    }

    struct PalColor
    {
        ubyte r, g, b;
    }

    PalColor[256] palette;
    for (int i = 0; i < 256; i++)
    {
        palette[i].r = popUbyte(input);
        palette[i].g = popUbyte(input);
        palette[i].b = popUbyte(input);
    }

    VOX result;
    result.width = width;
    result.height = height;
    result.depth = depth;
    result.voxels.length = width * height * depth;

    for(int x = 0; x < width; x++)
        for(int y = 0; y < height; y++)
            for(int z = 0; z < depth; z++)
            {
                int position = z + y * depth + x * width * height;
                auto color = palette[indices[position]];
                result.voxel(x, y, z) = VoxColor(color.tupleof, 255);
            }

    return result;
}

