class W_BoomStick_Fire_Alt extends BoomStickAltFire;

function DoFireEffect()
{
     class'WeaponHelper'.static.OnShotgunFire(self);
     Super.DoFireEffect();
}

defaultproperties
{
     AmmoClass=Class'KFTurbo.W_BoomStick_Ammo'
}
