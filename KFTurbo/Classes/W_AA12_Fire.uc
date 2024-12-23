class W_AA12_Fire extends AA12Fire;

var int FireEffectCount;
var array<W_BaseShotgunBullet.HitRegisterEntry> HitRegistryList;

function DoFireEffect()
{
     class'WeaponHelper'.static.OnShotgunFire(Self, FireEffectCount, HitRegistryList);
     Super.DoFireEffect();
     FireEffectCount++;
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
     AmmoClass=Class'KFTurbo.W_AA12_Ammo'
     ProjectileClass=Class'KFTurbo.W_AA12_Proj'
}
