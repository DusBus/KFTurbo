class W_LAW_Proj extends LAWProj;

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
	class'WeaponHelper'.static.LawProjTakeDamage(self, Damage, InstigatedBy, Hitlocation, Momentum, DamageType, HitIndex);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	if (bHasExploded)
	{
		return;
	}

	Super.Explode(HitLocation, HitNormal);
}

simulated function HurtRadius(float DamageAmount, float Radius, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
	local PipeBombProjectile HitPipebomb;
	local bool bFoundPipebomb;
	local float OriginalRadius;

	bFoundPipebomb = false;
	foreach CollidingActors (class'PipeBombProjectile', HitPipebomb, Radius * 0.33f, HitLocation)
	{
		HitPipebomb.TakeDamage(default.Damage, DetonationInstigator, Pipebomb.Location, vect(0,0,0), default.ImpactDamageType);
		bFoundPipebomb = true;
	}

	if (bFoundPipebomb)
	{
		DamageAmount *= 2.f;
	}

	Super.HurtRadius(DamageAmount, Radius, DamageType, Momentum, HitLocation);
}

defaultproperties
{
	ArmDistSquared=202500.000000
	ImpactDamage=475
	Damage=1000.000000
}
