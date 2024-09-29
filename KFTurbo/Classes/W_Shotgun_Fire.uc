class W_Shotgun_Fire extends ShotgunFire;

function DoFireEffect()
{
     class'WeaponHelper'.static.OnShotgunFire(self);
     Super.DoFireEffect();
}

defaultproperties
{
     ProjPerFire=9
     FireAnimRate=1.020000
     FireRate=0.900000
     AmmoClass=Class'KFTurbo.W_Shotgun_Ammo'
     ProjectileClass=Class'KFTurbo.W_Shotgun_Proj'
     Spread=1250.000000
}
