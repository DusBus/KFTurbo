class W_M32_Weap extends M32GrenadeLauncher;

var int AddReloadCount;

function AddReloadedAmmo()
{
	Super.AddReloadedAmmo();
     if (Role == ROLE_Authority && ++AddReloadCount >= MagCapacity) { class'WeaponHelper'.static.OnWeaponReload(Self); AddReloadCount = 0; }
}

defaultproperties
{
     FireModeClass(0)=Class'KFTurbo.W_M32_Fire'
     PickupClass=Class'KFTurbo.W_M32_Pickup'
}
