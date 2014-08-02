module voxd.vox;

import std.range,
       std.file,
       std.array,
       std.string;

import voxd.utils;

/// Supports VOX format

/// Decodes a VOX file.
/// Throws: VoxdException on error.
VOX decodeVOX(string filepath)
{
    auto bytes = cast(ubyte[]) std.file.read(filepath);
    return decodeVOX(bytes);
}

/// Decodes a VOX.
/// Throws: VoxdException on error.
VOX decodeVOX(R)(R input) if (isInputRange!R)
{
    VOX result;
    return result;
}

