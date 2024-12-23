class W_AK47_Weap extends AK47AssaultRifle;

function AddReloadedAmmo()
{
	Super.AddReloadedAmmo();
     if (Role == ROLE_Authority) { class'WeaponHelper'.static.OnWeaponReload(Self); }
}

defaultproperties
{
     Weight=5.000000
     FireModeClass(0)=Class'KFTurbo.W_AK47_Fire'
     PickupClass=Class'KFTurbo.W_AK47_Pickup'
}
