class W_PipeBomb_Weap extends PipeBombExplosive;

function AddReloadedAmmo()
{
	Super.AddReloadedAmmo();
	if (Role == ROLE_Authority) { class'WeaponHelper'.static.OnWeaponReload(Self); }
}

defaultproperties
{
     FireModeClass(0)=Class'KFTurbo.W_PipeBomb_Fire'
     PickupClass=Class'KFTurbo.W_PipeBomb_Pickup'
     InventoryGroup=5
}
