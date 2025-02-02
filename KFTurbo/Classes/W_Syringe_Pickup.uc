class W_Syringe_Pickup extends KFMod.SyringePickup;

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
    InventoryType=Class'W_Syringe_Weap'
}