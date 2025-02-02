class W_Knife_Pickup extends KnifePickup;

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
    InventoryType=class'W_Knife_Weap'
}