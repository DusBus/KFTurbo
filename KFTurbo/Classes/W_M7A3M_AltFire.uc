class W_M7A3M_AltFire extends M7A3MAltFire;

function DoFireEffect()
{
     class'WeaponHelper'.static.OnMedicDartFire(self);
     Super.DoFireEffect();
}

defaultproperties
{
     AmmoPerFire=375
     ProjectileClass=Class'KFTurbo.W_M7A3M_Proj'
}
