class W_Benelli_Pickup extends BenelliPickup;

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
     VariantClasses(0)=Class'KFTurbo.W_Benelli_Pickup'
     VariantClasses(1)=Class'KFTurbo.W_V_Benelli_Gold_Pickup'
     InventoryType=Class'KFTurbo.W_Benelli_Weap'
}
