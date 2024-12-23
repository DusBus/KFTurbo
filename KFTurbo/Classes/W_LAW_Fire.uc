class W_LAW_Fire extends LAWFire;

function DoFireEffect()
{
    class'WeaponHelper'.static.OnWeaponFire(self);
    Super.DoFireEffect();
}

function bool AllowFire()
{
    return ( Weapon.AmmoAmount(ThisModeNum) >= AmmoPerFire);
}

defaultproperties
{
     KickMomentum=(X=-75.000000,Z=30.000000)
     AmmoClass=Class'KFTurbo.W_LAW_Ammo'
     ProjectileClass=Class'KFTurbo.W_LAW_Proj'
     Spread=0.005000
}
