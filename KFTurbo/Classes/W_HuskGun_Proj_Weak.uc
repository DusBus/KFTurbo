class W_HuskGun_Proj_Weak extends KFMod.HuskGunProjectile_Weak;

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
     class'WeaponHelper'.static.HuskGunProjTakeDamage(self, Damage, InstigatedBy, Hitlocation, Momentum, DamageType, HitIndex);
}

defaultproperties
{

}
