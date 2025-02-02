class W_SealSqueal_Pickup extends SealSquealPickup;

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
     Cost=1200
     InventoryType=Class'KFTurbo.W_SealSqueal_Weap'
     VariantClasses(0)=Class'KFTurbo.W_SealSqueal_Pickup'
     VariantClasses(1)=Class'KFTurbo.W_V_SealSqueal_WL_Pickup'
}
