class W_AA12_Pickup extends AA12Pickup;

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
     VariantClasses(0)=Class'KFTurbo.W_AA12_Pickup'
     VariantClasses(1)=Class'KFTurbo.W_V_AA12_SMP_Pickup'
     VariantClasses(2)=Class'KFTurbo.W_V_AA12_Gold_Pickup'
     InventoryType=Class'KFTurbo.W_AA12_Weap'
}
