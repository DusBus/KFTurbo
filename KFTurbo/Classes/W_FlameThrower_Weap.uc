class W_FlameThrower_Weap extends FlameThrower;

function AddReloadedAmmo()
{
	Super.AddReloadedAmmo();
	if (Role == ROLE_Authority) { class'WeaponHelper'.static.OnWeaponReload(Self); }
}

simulated function BringUp(optional Weapon PrevWeapon)
{
     class'WeaponHelper'.static.WeaponCheckForHint(Self, 18);

     Super.BringUp(PrevWeapon);
}

defaultproperties
{
     FireModeClass(0)=Class'KFTurbo.W_FlameThrower_Fire'
     PickupClass=Class'KFTurbo.W_FlameThrower_Pickup'
}
