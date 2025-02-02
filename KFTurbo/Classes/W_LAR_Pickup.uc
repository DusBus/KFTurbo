class W_LAR_Pickup extends WinchesterPickup;

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
     VariantClasses(0)=Class'KFTurbo.W_LAR_Pickup'
     VariantClasses(1)=Class'KFTurbo.W_V_LAR_Turbo_Pickup'
     InventoryType=Class'KFTurbo.W_LAR_Weap'
}
