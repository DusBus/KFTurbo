class W_M99_Fire extends M99Fire;

function DoFireEffect()
{
    class'WeaponHelper'.static.OnWeaponFire(self);
    Super.DoFireEffect();
}

defaultproperties
{
     KickMomentum=(X=-225.000000,Z=100.000000)
     AmmoClass=Class'KFTurbo.W_M99_Ammo'
     ProjectileClass=Class'KFTurbo.W_M99_Proj'
}
