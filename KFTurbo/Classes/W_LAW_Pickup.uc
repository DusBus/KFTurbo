class W_LAW_Pickup extends LAWPickup;

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
     Weight=11.000000
     Cost=2500
     VariantClasses(0)=Class'KFTurbo.W_LAW_Pickup'
     VariantClasses(1)=Class'KFTurbo.W_V_LAW_Turbo_Pickup'
     InventoryType=Class'KFTurbo.W_LAW_Weap'
}
