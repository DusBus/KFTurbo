class W_M99_Weap extends M99SniperRifle;

simulated event StopFire(int Mode)
{
    if (Role == ROLE_Authority) { class'WeaponHelper'.static.OnWeaponReload(Self); }
    Super.StopFire(Mode);
}

defaultproperties
{
     Weight=12.000000
     FireModeClass(0)=Class'KFTurbo.W_M99_Fire'
     PickupClass=Class'KFTurbo.W_M99_Pickup'
}
