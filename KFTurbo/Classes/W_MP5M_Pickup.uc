class W_MP5M_Pickup extends MP5MPickup;

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
     Cost=600
     VariantClasses(0)=Class'KFTurbo.W_MP5M_Pickup'
     VariantClasses(1)=Class'KFTurbo.W_V_MP5M_Camo_Pickup'
     InventoryType=Class'KFTurbo.W_MP5M_Weap'
}
