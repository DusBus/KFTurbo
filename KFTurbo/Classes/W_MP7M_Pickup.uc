class W_MP7M_Pickup extends MP7MPickup;

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
     Cost=350
     InventoryType=Class'KFTurbo.W_MP7M_Weap'
}
