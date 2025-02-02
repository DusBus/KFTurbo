class W_DualDeagle_Pickup extends DualDeaglePickup;

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
     VariantClasses(0)=Class'KFTurbo.W_DualDeagle_Pickup'
     VariantClasses(1)=Class'KFTurbo.W_V_DualDeagle_Gold_Pickup'
	VariantClasses(2)=Class'KFTurbo.W_V_DualDeagle_Vet_Pickup'	
     InventoryType=Class'KFTurbo.W_DualDeagle_Weap'
}
