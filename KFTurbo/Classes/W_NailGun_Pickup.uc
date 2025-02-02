class W_NailGun_Pickup extends NailGunPickup;

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
     cost=3000
     InventoryType=Class'KFTurbo.W_NailGun_Weap'
}
