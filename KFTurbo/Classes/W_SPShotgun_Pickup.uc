class W_SPShotgun_Pickup extends SPShotgunPickup;

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
     Weight=8.000000
     cost=1500
     InventoryType=Class'KFTurbo.W_SPShotgun_Weap'
}
