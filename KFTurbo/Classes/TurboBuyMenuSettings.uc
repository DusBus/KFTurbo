class TurboBuyMenuSettings extends Object;

function Texture GetIconForPickup(String VariantID)
{
    switch (VariantID)
    {
        case "DEF":
            return Texture'KFTurbo.HUD.NoSkinIcon_D';
        case "GOLD":
            return Texture'KFTurbo.HUD.GoldIcon_D';
        case "CAMO":
            return Texture'KFTurbo.HUD.CamoIcon_D';
        case "TURBO":
            return Texture'KFTurbo.HUD.TurboIcon_D';
        case "VM":
            return Texture'KFTurbo.HUD.VMIcon_D';
        case "WEST":
            return Texture'KFTurbo.HUD.WestLondonIcon_D';
        case "RET":
            return Texture'KFTurbo.HUD.LevelIcon_D';
        case "SCUD":
            return Texture'KFTurbo.HUD.ScrubblesIcon_D';
        case "CUBIC":
            return Texture'KFTurbo.HUD.SkellIcon_D';
        case "SHOWME":
            return Texture'KFTurbo.HUD.ShowMeProIcon_D';
        case "CYB":
            return Texture'KFTurbo.HUD.CyberIcon_D';
        case "STP":
            return Texture'KFTurbo.HUD.SteampunkIcon_D';
    }

    return Texture'KFTurbo.HUD.StickerIcon_D';
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