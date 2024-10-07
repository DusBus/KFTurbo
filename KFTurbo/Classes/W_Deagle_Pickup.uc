class W_Deagle_Pickup extends DeaglePickup;

function inventory SpawnCopy(pawn Other)
{
	class'WeaponHelper'.static.SingleWeaponSpawnCopy(Self, Other, class'W_DualDeagle_Weap');
	Return Super(KFWeaponPickup).SpawnCopy(Other);
}

defaultproperties
{
	InventoryType=Class'KFTurbo.W_Deagle_Weap'
	
	VariantClasses(0)=Class'KFTurbo.W_Deagle_Pickup'
	VariantClasses(1)=Class'KFTurbo.W_V_Deagle_Gold_Pickup'
}
