class W_SPGrenade_Fire extends SPGrenadeFire;

function DoFireEffect()
{
     class'WeaponHelper'.static.OnWeaponFire(self);
     Super.DoFireEffect();
}

function Projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    return class'WeaponHelper'.static.SpawnProjectile(Self, Start, Dir);
}

function Projectile ForceSpawnProjectile(Vector Start, Rotator Dir) { return None; }

defaultproperties
{
     ProjectileClass=Class'KFTurbo.W_SPGrenade_Proj'
     AmmoClass=Class'KFTurbo.W_SPGrenade_Ammo'
}