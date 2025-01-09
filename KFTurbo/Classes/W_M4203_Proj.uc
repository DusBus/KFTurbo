class W_M4203_Proj extends M203GrenadeProjectile;

function TakeDamage(int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    class'WeaponHelper'.static.M79GrenadeTakeDamage(self, Damage, InstigatedBy, Hitlocation, Momentum, DamageType, HitIndex);
}

defaultproperties
{
    MyDamageType=Class'KFTurbo.W_M4203_DT'
    ImpactDamageType=Class'KFTurbo.W_M4203_Impact_DT'
    bGameRelevant=false
}
