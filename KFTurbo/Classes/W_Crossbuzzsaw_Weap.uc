class W_Crossbuzzsaw_Weap extends Crossbuzzsaw;

simulated event StopFire(int Mode)
{
    if (Role == ROLE_Authority) { class'WeaponHelper'.static.OnWeaponReload(Self); }
    Super.StopFire(Mode);
}

defaultproperties
{
     FireModeClass(0)=Class'KFTurbo.W_Crossbuzzsaw_Fire'
     PickupClass=Class'KFTurbo.W_Crossbuzzsaw_Pickup'
}
