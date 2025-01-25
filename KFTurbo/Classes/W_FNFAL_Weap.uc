class W_FNFAL_Weap extends FNFAL_ACOG_AssaultRifle;

function AddReloadedAmmo()
{
	Super.AddReloadedAmmo();
	if (Role == ROLE_Authority) { class'WeaponHelper'.static.OnWeaponReload(Self); }
}

defaultproperties
{
     MagCapacity=12
     ReloadRate=3.200000
     ReloadAnimRate=1.125000
     FireModeClass(0)=Class'KFTurbo.W_FNFAL_Fire'
     PickupClass=Class'KFTurbo.W_FNFAL_Pickup'
}
