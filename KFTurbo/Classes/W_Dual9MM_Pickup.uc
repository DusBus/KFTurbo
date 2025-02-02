class W_Dual9MM_Pickup extends DualiesPickup;

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
	Weight=1
     InventoryType=Class'KFTurbo.W_Dual9MM_Weap'
}