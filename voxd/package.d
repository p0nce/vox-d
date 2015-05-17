module voxd;

public import voxd.vox,
              voxd.rawvox,
              voxd.utils;


VOX decodeAny(string filepath)
{
    try
    {
        return decodeVOX(filepath);
    }
    catch(Exception e)
    {
    }

    return decodeRawVOX(filepath);
}
