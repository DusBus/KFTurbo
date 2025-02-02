class W_FlareRevolver_Pickup extends FlareRevolverPickup;

function inventory SpawnCopy( pawn Other )
{
	class'WeaponHelper'.static.SingleWeaponSpawnCopy(Self, Other, class'W_DualFlare_Weap');
	return Super(KFWeaponPickup).SpawnCopy(Other);
}

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
     InventoryType=Class'KFTurbo.W_FlareRevolver_Weap'
}