class W_M79_Proj extends KFMod.M79GrenadeProjectile;

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    class'WeaponHelper'.static.M79GrenadeTakeDamage(self, Damage, InstigatedBy, Hitlocation, Momentum, DamageType, HitIndex);
}

defaultproperties
{
    MyDamageType=Class'KFMod.DamTypeM79Grenade'
}
