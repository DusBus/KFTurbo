class W_LAW_Proj extends LAWProj;

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
	class'WeaponHelper'.static.LawProjTakeDamage(self, Damage, InstigatedBy, Hitlocation, Momentum, DamageType, HitIndex);
}

simulated function HurtRadius(float DamageAmount, float Radius, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
	local PipeBombProjectile HitPipebomb;

	Super.HurtRadius(DamageAmount, Radius, DamageType, Momentum, HitLocation);

	Radius *= 0.25f;

	foreach CollidingActors (class'PipeBombProjectile', HitPipebomb, Radius, HitLocation)
	{
		DetonatePipebomb(HitPipebomb, Instigator);
	}
}

static final function DetonatePipebomb(Actor Actor, Pawn DetonationInstigator)
{
	local PipeBombProjectile Pipebomb;
	Pipebomb = PipeBombProjectile(Actor);

	if(Pipebomb == None)
	{
		return;
	}

	Pipebomb.TakeDamage(default.Damage, DetonationInstigator, Actor.Location, vect(0,0,0), default.ImpactDamageType);
}

defaultproperties
{
     ArmDistSquared=202500.000000
     ImpactDamage=475
     Damage=1000.000000
}
