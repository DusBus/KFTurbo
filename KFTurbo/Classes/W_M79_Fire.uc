class W_M79_Fire extends KFMod.M79Fire;

function DoFireEffect()
{
    class'WeaponHelper'.static.OnWeaponFire(self);
    Super.DoFireEffect();
}

function Projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    return class'WeaponHelper'.static.SpawnProjectile(Self, Start, Dir);
}

function Projectile ForceSpawnProjectile(Vector Start, Rotator Dir)
{
    return class'WeaponHelper'.static.ForceSpawnProjectile(Self, Start, Dir);
}

defaultproperties
{
    AmmoClass=Class'W_M79_Ammo'
    ProjectileClass=Class'W_M79_Proj'
}
