class W_KrissM_Pickup extends KrissMPickup;

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
     Weight=4.000000
     Cost=1000
     InventoryType=Class'KFTurbo.W_KrissM_Weap'
     
     VariantClasses(0)=class'KFTurbo.W_KrissM_Pickup'
     VariantClasses(1)=class'KFTurbo.W_V_KrissM_Vet_Pickup'
}
