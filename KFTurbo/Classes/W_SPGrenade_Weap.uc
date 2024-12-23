class W_SPGrenade_Weap extends SPGrenadeLauncher;

function AddReloadedAmmo()
{
	Super.AddReloadedAmmo();
	if (Role == ROLE_Authority) { class'WeaponHelper'.static.OnWeaponReload(Self); }
}

defaultproperties
{
     FireModeClass(0)=Class'KFTurbo.W_SPGrenade_Fire'
     PickupClass=Class'KFTurbo.W_SPGrenade_Pickup'
}