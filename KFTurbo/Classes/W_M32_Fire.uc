class W_M32_Fire extends KFMod.M32Fire;

function DoFireEffect()
{
    class'WeaponHelper'.static.OnWeaponFire(self);
    Super.DoFireEffect();
}


defaultproperties
{
    AmmoClass=Class'W_M32_Ammo'
    ProjectileClass=Class'W_M32_Proj'
}
