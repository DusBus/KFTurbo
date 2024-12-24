class W_Crossbuzzsaw_Proj extends CrossbuzzsawBlade;

var byte bHasRegisteredHit;

simulated function ProcessTouch(Actor Other, vector HitLocation)
{
	class'WeaponHelper'.static.CrossbowProjectileProcessTouch(Self, HeadShotDamageMult, DamageTypeHeadShot, Other, HitLocation, BladeHitArmor, BladeHitFlesh, IgnoreImpactPawn, bHasRegisteredHit);
}

defaultproperties
{
     HeadShotDamageMult=2.000000
     Damage=275.000000
}
