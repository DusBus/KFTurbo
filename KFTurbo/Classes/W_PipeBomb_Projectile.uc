class W_PipeBomb_Projectile extends PipeBombProjectile;

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    if (ClassIsChildOf(DamageType, class'DamTypePipeBomb') || ClassIsChildOf(DamageType, class'DamTypeMelee') || (Damage < 25 && ClassIsChildOf(DamageType, class'SirenScreamDamage')))
    {
        return;
    }
	
    if (InstigatedBy == none || InstigatedBy != none && InstigatedBy.PlayerReplicationInfo != none &&
		InstigatedBy.PlayerReplicationInfo.Team != none && InstigatedBy.PlayerReplicationInfo.Team.TeamIndex == PlacedTeam &&
		Class<KFWeaponDamageType>(DamageType) != none && (Class<KFWeaponDamageType>(DamageType).default.bIsExplosive || InstigatedBy != Instigator))
    {
        return;
    }

     if (class<SirenScreamDamage>(DamageType) != None)
    {
        if (Damage >= 5)
        {
            Disintegrate(HitLocation, vect(0,0,1));
        }
    }
    else
    {
        Explode(HitLocation, vect(0,0,1));
    }
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	if (bHasExploded)
	{
		return;
	}

	Super.Explode(HitLocation, HitNormal);
}

defaultproperties
{
    ShrapnelClass=Class'KFTurbo.W_PipeBomb_Shrapnel'
}
