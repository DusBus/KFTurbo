class W_Deagle_Pickup_G extends GoldenDeaglePickup;

function inventory SpawnCopy(pawn Other)
{
	local Inventory I;
	local int Index;
	local bool bIsSingleVariant;

	for (I = Other.Inventory; I != none; I = I.Inventory)
	{
		bIsSingleVariant = false;

		for (Index = 0; Index < default.VariantClasses.Length; Index++)
		{
			if (default.VariantClasses[Index] == I.default.PickupClass)
			{
				bIsSingleVariant = true;
				break;
			}
		}

		if (bIsSingleVariant)
		{
			if (Inventory != none)
				Inventory.Destroy();
			InventoryType = Class'W_DualDeagle_Weap_G';
			AmmoAmount[0] += Deagle(I).AmmoAmount(0);
			MagAmmoRemaining += Deagle(I).MagAmmoRemaining;
			I.Destroyed();
			I.Destroy();
			Return Super(KFWeaponPickup).SpawnCopy(Other);
		}
	}

	InventoryType = Default.InventoryType;
	Return Super(KFWeaponPickup).SpawnCopy(Other);
}

defaultproperties
{
     VariantClasses(0)=Class'KFTurbo.W_Deagle_Pickup'
     VariantClasses(1)=Class'KFTurbo.W_Deagle_Pickup_G'
     InventoryType=Class'KFTurbo.W_Deagle_Weap_G'
}
