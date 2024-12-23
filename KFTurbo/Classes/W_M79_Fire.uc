class W_M79_Fire extends KFMod.M79Fire;

function DoFireEffect()
{
    class'WeaponHelper'.static.OnWeaponFire(self);
    Super.DoFireEffect();
}

defaultproperties
{
    AmmoClass=Class'W_M79_Ammo'
    ProjectileClass=Class'W_M79_Proj'
}
