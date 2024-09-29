class W_KSG_Fire extends KSGFire;

function DoFireEffect()
{
     class'WeaponHelper'.static.OnShotgunFire(self);
     Super.DoFireEffect();
}

defaultproperties
{
     AmmoClass=Class'KFTurbo.W_KSG_Ammo'
     ProjectileClass=Class'KFTurbo.W_KSG_Proj'
     Spread=800.000000
}
