class W_BoomStick_Fire extends BoomStickFire;

function DoFireEffect()
{
     class'WeaponHelper'.static.OnShotgunFire(self);
     Super.DoFireEffect();
}

defaultproperties
{
     AmmoClass=Class'KFTurbo.W_BoomStick_Ammo'
     ProjectileClass=Class'KFTurbo.W_BoomStick_Proj'
}
