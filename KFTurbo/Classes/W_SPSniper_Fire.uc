class W_SPSniper_Fire extends SPSniperFire;

function DoFireEffect()
{
     class'WeaponHelper'.static.OnWeaponFire(self);
     Super.DoFireEffect();
}

defaultproperties
{
     maxVerticalRecoilAngle=700
     maxHorizontalRecoilAngle=425
     MaxSpread=0.048000
     DamageType=Class'KFTurbo.W_SPSniper_DT'
     DamageMin=175
     DamageMax=200
     AmmoClass=Class'KFTurbo.W_SPSniper_Ammo'
     Spread=0.002000
}
