class W_MP7M_Fire_Alt extends MP7MAltFire;

function DoFireEffect()
{
     class'WeaponHelper'.static.OnMedicDartFire(self);
     Super.DoFireEffect();
}

defaultproperties
{
     ProjectileClass=Class'KFTurbo.W_MP7M_Proj'
}
