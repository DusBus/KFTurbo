class W_MKb42_Weap extends MKb42AssaultRifle;

function AddReloadedAmmo()
{
	Super.AddReloadedAmmo();
	if (Role == ROLE_Authority) { class'WeaponHelper'.static.OnWeaponReload(Self); }
}

defaultproperties
{
     ReloadRate=2.70000
     ReloadAnimRate=1.100000
     FireModeClass(0)=Class'KFTurbo.W_MKb42_Fire'
     PickupClass=Class'KFTurbo.W_MKb42_Pickup'
}