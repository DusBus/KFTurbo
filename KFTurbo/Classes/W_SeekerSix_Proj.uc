class W_SeekerSix_Proj extends SeekerSixRocketProjectile;

var Actor LastTouchedOverride;
var bool bAlreadyDidHitRegister;

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
	class'WeaponHelper'.static.SeekerSixProjTakeDamage(self, Damage, InstigatedBy, Hitlocation, Momentum, DamageType, HitIndex);
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	local int Index;
	local W_SeekerSix_Proj SeekerSixProjectile;

	if ( Other == none || Other == Instigator || Other.Base == Instigator )
	{
		return;
	}

    if( KFBulletWhipAttachment(Other) != none )
    {
        return;
    }

    if( KFHumanPawn(Other) != none && Instigator != none
        && KFHumanPawn(Other).PlayerReplicationInfo.Team.TeamIndex == Instigator.PlayerReplicationInfo.Team.TeamIndex )
    {
        return;
    }

	//TODO: Check if this is necessary.
	//Tell our flock we just hit someone so if anyone else blows up during Super.ProcessTouch they know to apply impact damage to this actor.
	if (LastTouchedOverride == None)
	{
		LastTouchedOverride = Other;

		for(Index = 0; Index < 6; Index++)
		{
			SeekerSixProjectile = W_SeekerSix_Proj(Flock[Index]);
			if (SeekerSixProjectile != None)
			{
				SeekerSixProjectile.LastTouchedOverride = Other;

				if (SeekerSixProjectile != Self)
				{
					SeekerSixProjectile.bAlreadyDidHitRegister = true;
				}
			}
		}
	}

	Super.ProcessTouch(Other, HitLocation);

	//Untell our flock now that we've blown up.
	LastTouchedOverride = None;
	for(Index = 0; Index < 6; Index++)
	{
		SeekerSixProjectile = W_SeekerSix_Proj(Flock[Index]);
		if (SeekerSixProjectile != None)
		{
			SeekerSixProjectile.LastTouchedOverride = None;
		}
	}
}

simulated function HurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
	local Actor Target;
	local float Distance;
	local float DamageScale;
	local vector Direction;
	local float UsedMomentum;

	local Pawn Pawn;
	local array<Pawn> CheckedPawns;
	local bool bAlreadyChecked;

	local KFMonster Monster;
	local bool bHitMonster;
	local bool bIsHeadshot;
	local int DamageDealt;

	local int Index, NumKilled;

	if ( bHurtEntry )
	{
		return;
	}

	bHurtEntry = true;
	
	if (LastTouchedOverride == None)
	{
		LastTouchedOverride = LastTouched;
	}
		
	if (ExtendedZCollision(LastTouchedOverride) != None)
	{
		LastTouchedOverride = LastTouchedOverride.Base;
	}

	if (KFMonster(LastTouchedOverride) != None)
	{
		bHitMonster = true;
	}

	foreach CollidingActors (class'Actor', Target, DamageRadius, HitLocation)
	{
		if (Target == self || Target == Hurtwall || Target == None || Target.Role != ROLE_Authority || FluidSurfaceInfo(Target) != None || ExtendedZCollision(Target) != None)
		{
			continue;
		}
		
		Direction = Target.Location - HitLocation;
		Distance = FMax(VSize(Direction), 1.f);
		Direction = Direction / Distance;

		Distance = class'WeaponHelper'.static.GetDistanceToClosestPointOnActor(HitLocation, Target);

		if ( Instigator == None || Instigator.Controller == None )
		{
			Target.SetDelayedDamageInstigatorController( InstigatorController );
		}

		if ( Target == LastTouchedOverride )
		{
			DamageScale = 1.f;
		}
		else
		{
			DamageScale = FMax(1.f - (Distance / DamageRadius), 0.f);
		}
		
		UsedMomentum = Momentum;
		UsedMomentum *= InterpCurveEval(AppliedMomentumCurve, Target.Mass);

		Pawn = Pawn(Target);

		if( Pawn == none )
		{
			UsedMomentum *= DamageScale;
			Target.TakeDamage(DamageScale * DamageAmount, Instigator, Location, Direction * UsedMomentum, DamageType);
			continue;
		}

		if( Pawn.Health <= 0 )
		{
			continue;
		}

		bAlreadyChecked = false;
		for (Index = 0; Index < CheckedPawns.Length; Index++)
		{
			if (CheckedPawns[Index] == Pawn)
			{
				bAlreadyChecked = true;
				break;
			}
		}

		CheckedPawns[CheckedPawns.Length] = Pawn;

		if( bAlreadyChecked )
		{
			continue;
		}		

		Monster = KFMonster(Target);
		if( Monster != none )
		{
			DamageScale *= Monster.GetExposureTo(HitLocation);
		}
		else if( KFPawn(Target) != none )
		{
			DamageScale *= KFPawn(Target).GetExposureTo(HitLocation);
		}

		if ( DamageScale <= 0.f)
		{
			continue;
		}

		UsedMomentum *= DamageScale;

		Target.TakeDamage(DamageScale * DamageAmount, Instigator, Location, Direction * UsedMomentum, DamageType);

		if (Vehicle(Target) != None && Vehicle(Target).Health > 0)
		{
			Vehicle(Target).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, UsedMomentum, HitLocation);
		}

		if( Role == ROLE_Authority && Monster != none && Monster.Health <= 0 )
		{
			NumKilled++;
		}
	}

	//Do impact damage.
	if (LastTouchedOverride != None)
	{
		//Somehow the above check is missing an explosive hit.
		bAlreadyChecked = false;
		for (Index = 0; Index < CheckedPawns.Length; Index++)
		{
			if (CheckedPawns[Index] == LastTouchedOverride)
			{
				bAlreadyChecked = true;
				break;
			}
		}

		Target = LastTouchedOverride;
		LastTouchedOverride = None;
		LastTouched = None;

		if (!bAlreadyChecked)
		{
			UsedMomentum = Momentum;
			UsedMomentum *= InterpCurveEval(AppliedMomentumCurve, Target.Mass);
			Target.TakeDamage(DamageAmount, Instigator, Location, Direction * UsedMomentum, DamageType);
		}

		Monster = KFMonster(Target);

		if (Monster != None && !bAlreadyDidHitRegister)
		{
			bIsHeadshot = Monster.IsHeadshot(Location, Normal(Velocity), 1.f);
			DamageDealt = Monster.Health;
		}

		Target.TakeDamage(ImpactDamage, Instigator, Location, Normal(Velocity), ImpactDamageType);

		if (bHitMonster && !bAlreadyDidHitRegister && Weapon(Owner) != None && Owner.Instigator != None)
		{
			if (Monster != None)
			{
				DamageDealt -= Monster.Health;
			}
			
			//No flock index means primary, flock means alt.
			if (FlockIndex == 0)
			{
				class'TurboPlayerEventHandler'.static.BroadcastPlayerFireHit(Owner.Instigator.Controller, Weapon(Owner).GetFireMode(0), bIsHeadshot, DamageDealt);
			}
			else
			{
				class'TurboPlayerEventHandler'.static.BroadcastPlayerFireHit(Owner.Instigator.Controller, Weapon(Owner).GetFireMode(1), bIsHeadshot, DamageDealt);
			}
		}
	}
	else if (bHitMonster) //Fallback in case monster gets destroyed during AOE damage.
	{
		if (FlockIndex == 0)
		{
			class'TurboPlayerEventHandler'.static.BroadcastPlayerFireHit(Owner.Instigator.Controller, Weapon(Owner).GetFireMode(0), bIsHeadshot, DamageDealt);
		}
		else
		{
			class'TurboPlayerEventHandler'.static.BroadcastPlayerFireHit(Owner.Instigator.Controller, Weapon(Owner).GetFireMode(1), bIsHeadshot, DamageDealt);
		}
	}

	if( Role == ROLE_Authority )
	{
		if( NumKilled >= 4 )
		{
			KFGameType(Level.Game).DramaticEvent(0.05);
		}
		else if( NumKilled >= 2 )
		{
			KFGameType(Level.Game).DramaticEvent(0.03);
		}
	}

	bHurtEntry = false;
}

defaultproperties
{
	SoundPitch=48

	AppliedMomentumCurve=(Points=((OutVal=0.500000),(InVal=100.000000,OutVal=0.500000),(InVal=350.000000,OutVal=1.000000),(InVal=600.000000,OutVal=1.000000)))
	ArmDistSquared=10000.000000
	Speed=2000.000000
	MaxSpeed=2000.000000
	DrawScale=3.000000
	RotationRate=(Roll=50000)
	
	FlockRadius=10.000000
	FlockStiffness=-100.000000
	FlockMaxForce=600.000000
	FlockCurlForce=450.000000

	ImpactDamage=150
	Damage=350.000000
	DamageRadius=150.000000
}

