class W_HuskGun_Proj_Weak extends W_HuskGun_Proj_Medium;

function TakeDamage(int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
     class'WeaponHelper'.static.HuskGunProjTakeDamage(self, Damage, InstigatedBy, Hitlocation, Momentum, DamageType, HitIndex);
}

defaultproperties
{
     ExplosionEmitter=Class'KFMod.FlameImpact_Weak'
     FlameTrailEmitterClass=Class'KFMod.FlameThrowerHusk_Weak'
     ExplosionSoundVolume=1.250000
     ExplosionDecal=Class'KFMod.FlameThrowerBurnMark_Small'
}