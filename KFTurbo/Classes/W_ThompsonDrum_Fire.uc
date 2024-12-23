class W_ThompsonDrum_Fire extends ThompsonDrumFire;

function DoFireEffect()
{
     class'WeaponHelper'.static.OnWeaponFire(self);
     Super.DoFireEffect();
}

defaultproperties
{
     DamageMin=31
     DamageMax=31
     DamageType=Class'KFTurbo.W_ThompsonDrum_DT'
     AmmoClass=Class'KFTurbo.W_ThompsonDrum_Ammo'
     MaxSpread=0.096000
}
