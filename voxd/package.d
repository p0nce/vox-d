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

    try
    {
        return decodeRawVOX(filepath);
    }
    catch(Exception e)
    {
    }
}
