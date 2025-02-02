class W_M32_Pickup extends M32Pickup;

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
     Cost=2400
     VariantClasses(0)=Class'KFTurbo.W_M32_Pickup'
     VariantClasses(1)=Class'KFTurbo.W_V_M32_Camo_Pickup'
     VariantClasses(2)=Class'KFTurbo.W_V_M32_Turbo_Pickup'
     VariantClasses(3)=Class'KFTurbo.W_V_M32_Vet_Pickup'
     InventoryType=Class'KFTurbo.W_M32_Weap'
}
