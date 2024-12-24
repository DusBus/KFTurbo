class W_HuskGun_Proj_Medium extends KFMod.HuskGunProjectile;

function TakeDamage( int Damage, Pawn InstigatedBy, vector Hitlocation, vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
    class'WeaponHelper'.static.HuskGunProjTakeDamage(self, Damage, InstigatedBy, Hitlocation, Momentum, DamageType, HitIndex);
}

simulated function ProcessTouch(Actor Other, vector HitLocation)
{
    local vector X;
	local vector TempHitLocation, HitNormal;
    local vector OtherLocation;
	local array<int> HitPoints;
    local KFPawn HitPawn;

    local KFMonster HitMonster;
    local int DamageDealt;
    local bool bIsHeadshot;

	if (Other == none || Other == Instigator || Other.Base == Instigator || KFBulletWhipAttachment(Other) != None)
    {
		return;
    }

    OtherLocation = Other.Location;

    if (KFHumanPawn(Other) != None && Instigator != None && KFHumanPawn(Other).PlayerReplicationInfo.Team.TeamIndex == Instigator.PlayerReplicationInfo.Team.TeamIndex)
    {
        return;
    }

	if (Instigator != None)
	{
		OrigLoc = Instigator.Location;
	}

    X = vector(Rotation);

    if (Role != ROLE_Authority)
    {
        if (!bDud)
        {
            Explode(HitLocation, Normal(HitLocation - Other.Location));
        }

        return;
    }

    if( ROBulletWhipAttachment(Other) != none )
    {
        if(!Other.Base.bDeleteMe)
        {
            Other = Instigator.HitPointTrace(TempHitLocation, HitNormal, HitLocation + (200 * X), HitPoints, HitLocation,, 1);

            if (Other == None || HitPoints.Length == 0)
            {
                return;
            }

            HitPawn = KFPawn(Other);

            if (Role == ROLE_Authority && HitPawn != None && !HitPawn.bDeleteMe)
            {
                HitPawn.ProcessLocationalDamage(ImpactDamage, Instigator, TempHitLocation, MomentumTransfer * Normal(Velocity), ImpactDamageType,HitPoints);
            }
        }
    }
    else
    {
        HitMonster = KFMonster(Other);
        if (HitMonster == None)
        {
            HitMonster = KFMonster(Other.Base);
        }

        if (HitMonster != None && Owner != None && Owner.Instigator != None)
        {
            bIsHeadshot = HitMonster.IsHeadShot(HitLocation, X, 1.f);
            DamageDealt = HitMonster.Health;
        }

        if (Pawn(Other) != None && Pawn(Other).IsHeadShot(HitLocation, X, 1.0))
        {
            Pawn(Other).TakeDamage(ImpactDamage * HeadShotDamageMult, Instigator, HitLocation, MomentumTransfer * Normal(Velocity), ImpactDamageType);
        }
        else
        {
            Other.TakeDamage(ImpactDamage, Instigator, HitLocation, MomentumTransfer * Normal(Velocity), ImpactDamageType);
        }

        if (DamageDealt > 0 && Weapon(Owner) != None && Owner.Instigator != None)
        {
            if (HitMonster != None)
            {
                DamageDealt -= HitMonster.Health;
            }

            class'TurboPlayerEventHandler'.static.BroadcastPlayerFireHit(Owner.Instigator.Controller, Weapon(Owner).GetFireMode(0), bIsHeadshot, DamageDealt);
        }
    }

	if (!bDud)
	{
	    Explode(HitLocation, Normal(HitLocation - OtherLocation));
	}
}

defaultproperties
{

}
