class W_Benelli_Fire extends BenelliFire;

function DoFireEffect()
{
     class'WeaponHelper'.static.OnShotgunFire(self);
     Super.DoFireEffect();
}

defaultproperties
{
     KickMomentum=(X=-10.000000,Z=2.000000)
     maxVerticalRecoilAngle=1250
     maxHorizontalRecoilAngle=750
     AmmoClass=Class'KFTurbo.W_Benelli_Ammo'
     ProjectileClass=Class'KFTurbo.W_Benelli_Proj'
}
