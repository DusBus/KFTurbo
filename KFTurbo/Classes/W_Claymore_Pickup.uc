class W_Claymore_Pickup extends ClaymoreSwordPickup;

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
     cost=2500
     InventoryType=Class'KFTurbo.W_Claymore_Weap'
}