class W_M7A3M_Pickup extends M7A3MPickup;

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
     BuyClipSize=10
     InventoryType=Class'KFTurbo.W_M7A3M_Weap'
}
