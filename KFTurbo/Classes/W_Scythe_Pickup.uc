class W_Scythe_Pickup extends ScythePickup;

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
     Weight=7.000000
     cost=2000
     InventoryType=Class'KFTurbo.W_Scythe_Weap'
}