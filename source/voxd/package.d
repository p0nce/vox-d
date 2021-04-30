module voxd;

public import voxd.vox,
              voxd.rawvox,
              voxd.utils;


VOX decodeVOXFromFile(string filepath)
{
    try
    {
        return decodeMagicaVOXFromFile(filepath);
    }
    catch(Exception e)
    {
    }

    return decodeRawVOXFromFile(filepath);
}

VOX decodeFromMemory(ubyte[] data)
{
    try
    {
        return decodeMagicaVOXFromMemory(data);
    }
    catch(Exception e)
    {
    }

    return decodeRawVOXFromMemory(data);
}
