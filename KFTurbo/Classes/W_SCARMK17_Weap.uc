class W_SCARMK17_Weap extends SCARMK17AssaultRifle;

function AddReloadedAmmo()
{
	Super.AddReloadedAmmo();
	if (Role == ROLE_Authority) { class'WeaponHelper'.static.OnWeaponReload(Self); }
}

defaultproperties
{
     PickupClass=Class'KFTurbo.W_SCARMK17_Pickup'
     FireModeClass(0)=Class'KFTurbo.W_SCARMK17_Fire'
}
