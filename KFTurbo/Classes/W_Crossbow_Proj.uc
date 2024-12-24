class W_Crossbow_Proj extends CrossbowArrow;

var byte bHasRegisteredHit;

simulated function ProcessTouch(Actor Other, vector HitLocation)
{
	class'WeaponHelper'.static.CrossbowProjectileProcessTouch(Self, HeadShotDamageMult, DamageTypeHeadShot, Other, HitLocation, Arrow_hitarmor, Arrow_hitflesh, IgnoreImpactPawn, bHasRegisteredHit);

	Stick(Other, HitLocation);
}

defaultproperties
{

}