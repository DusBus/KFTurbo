class W_Chainsaw_Pickup extends ChainsawPickup;

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
     InventoryType=Class'KFTurbo.W_Chainsaw_Weap'
     VariantClasses(0)=Class'KFTurbo.W_Chainsaw_Pickup'
     VariantClasses(1)=Class'KFTurbo.W_V_Chainsaw_Gold_Pickup'
}
