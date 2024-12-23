class W_M79_Weap extends M79GrenadeLauncher;

simulated event StopFire(int Mode)
{
    if (Role == ROLE_Authority) { class'WeaponHelper'.static.OnWeaponReload(Self); }
    Super.StopFire(Mode);
}

defaultproperties
{
     FireModeClass(0)=Class'KFTurbo.W_M79_Fire'
     PickupClass=Class'KFTurbo.W_M79_Pickup'
}
