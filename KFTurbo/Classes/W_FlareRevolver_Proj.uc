class W_FlareRevolver_Proj extends FlareRevolverProjectile;

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
    class'WeaponHelper'.static.FlareRevolverProjTakeDamage(self, Damage, InstigatedBy, Hitlocation, Momentum, DamageType, HitIndex);
}

defaultproperties
{
     HeadShotDamageMult=1.500000
     ImpactDamageType=Class'KFTurbo.W_FlareRevolver_Impact_DT'
     ImpactDamage=100
     Damage=25.000000
     DamageRadius=100.000000
     MyDamageType=Class'KFMod.DamTypeFlareRevolver'
}