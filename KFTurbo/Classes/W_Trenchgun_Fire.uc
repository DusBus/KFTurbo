class W_Trenchgun_Fire extends TrenchgunFire;

function DoFireEffect()
{
     class'WeaponHelper'.static.OnShotgunFire(self);
     Super.DoFireEffect();
}

defaultproperties
{
     KickMomentum=(X=-40.000000,Z=8.000000)
     ProjectileClass=Class'KFTurbo.W_Trenchgun_Proj'
     AmmoClass=class'W_Trenchgun_Ammo'
}