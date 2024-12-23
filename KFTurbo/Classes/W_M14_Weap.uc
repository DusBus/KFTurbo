class W_M14_Weap extends M14EBRBattleRifle;

function AddReloadedAmmo()
{
	Super.AddReloadedAmmo();
	if (Role == ROLE_Authority) { class'WeaponHelper'.static.OnWeaponReload(Self); }
}

defaultproperties
{
     FireModeClass(0)=Class'W_M14_Fire'
     PickupClass=Class'KFTurbo.W_M14_Pickup'
}
