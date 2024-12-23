class W_SPSniper_Weap extends SPSniperRifle;

function AddReloadedAmmo()
{
	Super.AddReloadedAmmo();
	if (Role == ROLE_Authority) { class'WeaponHelper'.static.OnWeaponReload(Self); }
}

defaultproperties
{
     MagCapacity=7
     FireModeClass(0)=Class'KFTurbo.W_SPSniper_Fire'
     PickupClass=Class'KFTurbo.W_SPSniper_Pickup'
}
