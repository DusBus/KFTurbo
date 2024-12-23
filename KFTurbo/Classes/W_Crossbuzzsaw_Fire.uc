class W_Crossbuzzsaw_Fire extends CrossbuzzsawFire;

function DoFireEffect()
{
    class'WeaponHelper'.static.OnWeaponFire(self);
    Super.DoFireEffect();
}

defaultproperties
{
     AmmoClass=Class'KFTurbo.W_Crossbuzzsaw_Ammo'
     ProjectileClass=Class'KFTurbo.W_Crossbuzzsaw_Proj'
}
