class W_SealSqueal_Weap extends SealSquealHarpoonBomber;

function AddReloadedAmmo()
{
	Super.AddReloadedAmmo();
	if (Role == ROLE_Authority) { class'WeaponHelper'.static.OnWeaponReload(Self); }
}

defaultproperties
{
     ReloadRate=2.666666
     ReloadAnimRate=1.500000

     FireModeClass(0)=Class'KFTurbo.W_SealSqueal_Fire'
     PickupClass=Class'KFTurbo.W_SealSqueal_Pickup'
}
