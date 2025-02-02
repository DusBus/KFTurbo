class W_Flamethrower_Pickup extends FlameThrowerPickup;

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
     VariantClasses(0)=Class'KFTurbo.W_FlameThrower_Pickup'
     VariantClasses(1)=Class'KFTurbo.W_V_FlameThrower_Gold_Pickup'
     InventoryType=Class'KFTurbo.W_FlameThrower_Weap'
}
