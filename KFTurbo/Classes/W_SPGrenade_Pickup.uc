class W_SPGrenade_Pickup extends SPGrenadePickup;

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
     Cost=800
     InventoryType=Class'KFTurbo.W_SPGrenade_Weap'
}