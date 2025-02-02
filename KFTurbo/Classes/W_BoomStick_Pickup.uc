class W_BoomStick_Pickup extends BoomStickPickup;

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
     cost=750
     InventoryType=Class'KFTurbo.W_BoomStick_Weap'

     VariantClasses(0)=class'KFTurbo.W_BoomStick_Pickup'
     VariantClasses(1)=class'KFTurbo.W_V_BoomStick_Vet_Pickup'
}