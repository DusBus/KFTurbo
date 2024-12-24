class W_Crossbow_Proj extends CrossbowArrow;

var bool bHasRegisteredHit;

simulated function ProcessTouch(Actor Other, vector HitLocation)
{
	local vector X,End,HL,HN;
	local Vector TempHitLocation, HitNormal;
	local array<int>	HitPoints;
    local KFPawn HitPawn;
	local bool	bHitWhipAttachment;
	local int DamageDealt;
	local bool bIsHeadshot;

	if (Other == None || Other == Instigator || Other.Base == Instigator || !Other.bBlockHitPointTraces || Other == IgnoreImpactPawn || (IgnoreImpactPawn != None && Other.Base == IgnoreImpactPawn))
	{
		return;
	}

	X =  Vector(Rotation);

 	if (ROBulletWhipAttachment(Other) != None)
	{
    	bHitWhipAttachment=true;
		
        if (Other.Base.bDeleteMe)
		{
			return;
		}

		Other = Instigator.HitPointTrace(TempHitLocation, HitNormal, HitLocation + (65535 * X), HitPoints, HitLocation,, 1);

		if (Other == None || HitPoints.Length == 0)
		{
			return;
		}

		HitPawn = KFPawn(Other);

		if (Role == ROLE_Authority && HitPawn != None)
		{
			if (!HitPawn.bDeleteMe)
			{
				HitPawn.ProcessLocationalDamage(Damage, Instigator, TempHitLocation, MomentumTransfer * X, MyDamageType,HitPoints);
			}

			Damage /= 1.25;
			Velocity *= 0.85;

			IgnoreImpactPawn = HitPawn;

			if (Level.NetMode != NM_Client)
			{
				PlayhitNoise(Pawn(Other) != None && Pawn(Other).ShieldStrength > 0);
			}
		}

		return;
	}

	if (Level.NetMode != NM_Client)
	{
		PlayhitNoise(Pawn(Other) != None && Pawn(Other).ShieldStrength > 0);
	}

	if (ExtendedZCollision(Other) != None)
	{
		Other = Other.Base;
	}

	if (Physics == PHYS_Projectile && Pawn(Other) != None && Vehicle(Other) == None)
	{
		IgnoreImpactPawn = Pawn(Other);
		DamageDealt = IgnoreImpactPawn.Health;
		bIsHeadshot = IgnoreImpactPawn.IsHeadShot(HitLocation, X, 1.0);

		if (bIsHeadshot)
		{
			Other.TakeDamage(Damage * HeadShotDamageMult, Instigator, HitLocation, MomentumTransfer * X, DamageTypeHeadShot);
		}
		else
		{
			Other.TakeDamage(Damage, Instigator, HitLocation, MomentumTransfer * X, MyDamageType);
		}

		if (!bHasRegisteredHit && Weapon(Owner) != None && Owner.Instigator != None)
		{
			bHasRegisteredHit = true;
			DamageDealt -= IgnoreImpactPawn.Health;
			class'TurboPlayerEventHandler'.static.BroadcastPlayerFireHit(Owner.Instigator.Controller, Weapon(Owner).GetFireMode(0), bIsHeadshot, DamageDealt);
		}

		Damage /= 1.25;
		Velocity *= 0.85;

		return;
	}

	if (Level.NetMode != NM_DedicatedServer && SkeletalMesh(Other.Mesh) != None && Other.DrawType == DT_Mesh && Pawn(Other) != None)
	{
		End = Other.Location + X * 600.f;

		if (Other.Trace(HL,HN,End,Other.Location,False) != None)
		{
			Spawn(Class'BodyAttacher', Other,, HitLocation).AttachEndPoint = HL - HN;
		}
	}

	Stick(Other, HitLocation);
}

defaultproperties
{

}