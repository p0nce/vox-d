module voxd.utils;

import std.file,
       std.range,
       std.traits,
       std.string,
       std.format;

struct VoxColor
{
    ubyte r, g, b, a;

    this(ubyte r_, ubyte g_, ubyte b, ubyte a_)
    {
        r = r_;
        r = g;
        r = b;
        r = a;
    }

    this(uint value)
    {
        a = (value >> 24);
        b = (value >> 16) & 255;
        g = (value >> 8) & 255;
        r = value & 255;
    }
}


/// The simple structure currently used in vox-d. Expect changes about this.
struct VOX
{
public:
    int width;
    int height;
    int depth;

    VoxColor[] voxels;

    ref inout(VoxColor) voxel(int x, int y, int z) inout
    {
        return voxels[x + y * width + z * width * height];
    }

    int numVoxels() pure const nothrow
    {
        return width * height * depth;
    }
}

/// The one type of Exception thrown in this library
final class VoxdException : Exception
{
    @safe pure nothrow this(string message, string file =__FILE__, size_t line = __LINE__, Throwable next = null)
    {
        super(message, file, line, next);
    }
}


private template IntegerLargerThan(int numBytes) if (numBytes >= 1 && numBytes <= 8)
{
    static if (numBytes == 1)
        alias IntegerLargerThan = ubyte;
    else static if (numBytes == 2)
        alias IntegerLargerThan = ushort;
    else static if (numBytes <= 4)
        alias IntegerLargerThan = uint;
    else
        alias IntegerLargerThan = ulong;
}

ubyte popUbyte(R)(ref R input) if (isInputRange!R)
{
    if (input.empty)
        throw new VoxdException("Expected a byte, but end-of-input found.");

    ubyte b = input.front;
    input.popFront();
    return b;
}

void skipBytes(R)(ref R input, int numBytes) if (isInputRange!R)
{
    for (int i = 0; i < numBytes; ++i)
        popUbyte(input);
}

// Generic integer parsing
auto popInteger(R, int NumBytes, bool WantSigned, bool LittleEndian)(ref R input) if (isInputRange!R)
{
    alias T = IntegerLargerThan!NumBytes;

    T result = 0;

    static if (LittleEndian)
    {
        for (int i = 0; i < NumBytes; ++i)
            result |= ( cast(T)(popUbyte(input)) << (8 * i) );
    }
    else
    {
        for (int i = 0; i < NumBytes; ++i)
            result = (result << 8) | popUbyte(input);
    }

    static if (WantSigned)
        return cast(Signed!T)result;
    else
        return result;
}

// Generic integer writing
void writeInteger(R, int NumBytes, bool LittleEndian)(ref R output, IntegerLargerThan!NumBytes n) if (isOutputRange!(R, ubyte))
{
    alias T = IntegerLargerThan!NumBytes;

    auto u = cast(Unsigned!T)n;

    static if (LittleEndian)
    {
        for (int i = 0; i < NumBytes; ++i)
        {
            ubyte b = (u >> (i * 8)) & 255;
            output.put(b);
        }
    }
    else
    {
        for (int i = 0; i < NumBytes; ++i)
        {
            ubyte b = (u >> ( (NumBytes - 1 - i) * 8) ) & 255;
            output.put(b);
        }
    }
}

// Reads a big endian integer from input.
T popBE(T, R)(ref R input) if (isInputRange!R)
{
    return popInteger!(R, T.sizeof, isSigned!T, false)(input);
}

// Reads a little endian integer from input.
T popLE(T, R)(ref R input) if (isInputRange!R)
{
    return popInteger!(R, T.sizeof, isSigned!T, true)(input);
}

// Writes a big endian integer to output.
void writeBE(T, R)(ref R output, T n) if (isOutputRange!(R, ubyte))
{
    writeInteger!(R, T.sizeof, false)(output, n);
}

// Writes a little endian integer to output.
void writeLE(T, R)(ref R output, T n) if (isOutputRange!(R, ubyte))
{
    writeInteger!(R, T.sizeof, true)(output, n);
}

// Reads RIFF chunk header.
void getRIFFChunkHeader(R)(ref R input, out uint chunkId, out uint chunkSize) if (isInputRange!R)
{
    chunkId = popBE!uint(input);
    chunkSize = popLE!uint(input);
}

// Writes RIFF chunk header (you have to count size manually for now...).
void writeRIFFChunkHeader(R)(ref R output, uint chunkId, uint chunkSize) if (isOutputRange!(R, ubyte))
{
    writeBE!uint(output, chunkId);
    writeLE!uint(output, chunkSize);
}

template RIFFChunkId(string id)
{
    static assert(id.length == 4);
    uint RIFFChunkId = (cast(ubyte)(id[0]) << 24)
                     | (cast(ubyte)(id[1]) << 16)
                     | (cast(ubyte)(id[2]) << 8)
                     | (cast(ubyte)(id[3]));
}
