class PurchaseWeaponMessage extends PurchaseMessage;

var localized string PurchaseString;
var localized string CannotPurchaseString;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string WeaponName;
    WeaponName = class<KFWeaponPickup>(OptionalObject).default.ItemShortName;
    if (WeaponName == "")
    {
        WeaponName = class<KFWeaponPickup>(OptionalObject).default.ItemName;
    }

    return FormatString(Repl(Repl(Eval(Switch <= RelatedPRI_1.Score, default.PurchaseString, default.CannotPurchaseString), "%w", WeaponName), "%c", Switch$class'KFTab_BuyMenu'.default.MoneyCaption));
}

defaultproperties
{
    PurchaseString="%dPurchase %k%w%d for %k%c%d."
    CannotPurchaseString="%dPurchase %k%w%d for %nk%c%d."
}