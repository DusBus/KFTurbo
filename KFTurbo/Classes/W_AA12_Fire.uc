class W_AA12_Fire extends AA12Fire;

function DoFireEffect()
{
     class'WeaponHelper'.static.OnShotgunFire(self);
     Super.DoFireEffect();
}

defaultproperties
{
     AmmoClass=Class'KFTurbo.W_AA12_Ammo'
     ProjectileClass=Class'KFTurbo.W_AA12_Proj'
}
