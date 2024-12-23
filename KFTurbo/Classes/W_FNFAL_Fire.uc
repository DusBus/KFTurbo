class W_FNFAL_Fire extends FNFALFire;

function DoFireEffect()
{
     class'WeaponHelper'.static.OnWeaponFire(self);
     Super.DoFireEffect();
}

defaultproperties
{
     DamageType=Class'KFTurbo.W_FNFAL_DT'
     DamageMin=52
     DamageMax=52
     bWaitForRelease=True
     AmmoClass=Class'KFTurbo.W_FNFAL_Ammo'
     MaxSpread=0.048000
}
