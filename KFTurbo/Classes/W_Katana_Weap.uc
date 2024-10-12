class W_Katana_Weap extends Katana;

//Fix for bloody material being forced to be a combiner in KFMeleeGun.
static function PreloadAssets(Inventory Inv, optional bool bSkipRefCount)
{
	Super(KFWeapon).PreloadAssets(Inv, bSkipRefCount);

	default.BloodyMaterial = Material(DynamicLoadObject(default.BloodyMaterialRef, class'Material', true));

	if (KFMeleeGun(Inv) != None)
	{
		KFMeleeGun(Inv).BloodyMaterial = default.BloodyMaterial;
	}
}

defaultproperties
{
     PickupClass=Class'KFTurbo.W_Katana_Pickup'
}
