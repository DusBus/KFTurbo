class W_SPSniper_Pickup extends SPSniperPickup;

function Destroyed()
{
	if (Inventory != None)
	{
		Super.Destroyed();
	}
	else
	{
		Super(WeaponPickup).Destroyed();
	}
}

defaultproperties
{
      cost=1750
      InventoryType=Class'KFTurbo.W_SPSniper_Weap'
      VariantClasses=()
}
