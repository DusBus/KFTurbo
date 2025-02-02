class W_DualMK23_Pickup extends DualMK23Pickup;

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
     VariantClasses(0)=Class'KFTurbo.W_DualMK23_Pickup'
     VariantClasses(1)=Class'KFTurbo.W_V_DualMK23_Turbo_Pickup'
     VariantClasses(2)=Class'KFTurbo.W_V_DualMK23_Cyber_Pickup'

     InventoryType=Class'KFTurbo.W_DualMK23_Weap'    
}
