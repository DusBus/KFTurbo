class W_SeekerSix_Pickup extends SeekerSixPickup;

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
     Cost=1700
     InventoryType=Class'KFTurbo.W_SeekerSix_Weap'
}
