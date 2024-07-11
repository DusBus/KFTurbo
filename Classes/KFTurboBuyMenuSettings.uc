class KFTurboBuyMenuSettings extends Object;

function Texture GetIconForPickup(String VariantID)
{
    switch (VariantID)
    {
        case "DEF":
            return Texture'KFTurboContent.HUD.NoSkinIcon_D';
        case "GOLD":
            return Texture'KFTurboContent.HUD.GoldIcon_D';
        case "CAMO":
            return Texture'KFTurboContent.HUD.CamoIcon_D';
        case "TURBO":
            return Texture'KFTurboContent.HUD.TurboIcon_D';
        case "VM":
            return Texture'KFTurboContent.HUD.VMIcon_D';
        case "WEST":
            return Texture'KFTurboContent.HUD.WestLondonIcon_D';
        case "RET":
            return Texture'KFTurboContent.HUD.LevelIcon_D';
        case "SCUD":
            return Texture'KFTurboContent.HUD.ScrubblesIcon_D';
        case "CUBIC":
            return Texture'KFTurboContent.HUD.SkellIcon_D';
        case "SHOWME":
            return Texture'KFTurboContent.HUD.ShowMeProIcon_D';
    }

    return Texture'KFTurboContent.HUD.StickerIcon_D';
}

function String GetHintForPickup(String VariantID)
{
    switch (VariantID)
    {
        case "DEF":
            return "Default";
        case "GOLD":
            return "Gold";
        case "CAMO":
            return "Camo";
        case "TURBO":
        case "VM":
        case "WEST":
        case "RET":
        case "SCUD":
        case "CUBIC":
        case "SHOWME":
            return "Sticker";
    }
    
    return "Sticker";
}