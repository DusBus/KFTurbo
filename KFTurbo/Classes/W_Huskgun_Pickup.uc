class W_Huskgun_Pickup extends HuskGunPickup;

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
     AmmoCost=50
     BuyClipSize=40
     InventoryType=Class'KFTurbo.W_Huskgun_Weap'
}