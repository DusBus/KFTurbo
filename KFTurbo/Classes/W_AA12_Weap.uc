class W_AA12_Weap extends AA12AutoShotgun;

function AddReloadedAmmo()
{
	Super.AddReloadedAmmo();
     if (Role == ROLE_Authority) { class'WeaponHelper'.static.OnWeaponReload(Self); }
}

defaultproperties
{
     FireModeClass(0)=Class'KFTurbo.W_AA12_Fire'
     PickupClass=Class'KFTurbo.W_AA12_Pickup'
}