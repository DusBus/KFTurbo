//=============================================================================
// Berzerker Zap Nade
//=============================================================================
class V_Berserker_Grenade extends KFMod.Nade;

var float ZapAmount;

simulated function Disintegrate(vector HitLocation, vector HitNormal)
{
	//Immune to disintegration.
}

simulated function ProcessTouch( actor Other, vector HitLocation )
{
	if (KFMonster(Other) == none)
	{
		return;
	}

	//Explode on contact.
	Super(Grenade).ProcessTouch(Other, HitLocation);
}

//Removed AvoidMarker.
simulated function HitWall( vector HitNormal, actor Wall )
{
    local Vector VNorm;
	local PlayerController PC;

	if ( (Pawn(Wall) != None) || (GameObjective(Wall) != None) )
	{
		Explode(Location, HitNormal);
		return;
	}

    if (!bTimerSet)
    {
        SetTimer(ExplodeTimer, false);
        bTimerSet = true;
    }

    VNorm = (Velocity dot HitNormal) * HitNormal;
    Velocity = -VNorm * DampenFactor + (Velocity - VNorm) * DampenFactorParallel;

    RandSpin(100000);
    Speed = VSize(Velocity);

    if ( Speed < 10 )
    {
        bBounce = False;
		class'WeaponHelper'.static.BeginGrenadeSmoothRotation(self, 5);

        if ( Trail != None )
            Trail.mRegen = false; // stop the emitter from regenerating
    }
    else
    {
		if ( (Level.NetMode != NM_DedicatedServer) && (Speed > 50) )
		{
			PlaySound(ImpactSound, SLOT_Misc );
		}

        if ( !Level.bDropDetail && (Level.DetailMode != DM_Low) && (Level.TimeSeconds - LastSparkTime > 0.5) && EffectIsRelevant(Location,false) )
        {
			PC = Level.GetLocalPlayerController();
			if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 6000 )
				Spawn(HitEffectClass,,, Location, Rotator(HitNormal));
            LastSparkTime = Level.TimeSeconds;
        }
    }
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local PlayerController LocalPlayer;

	if (bHasExploded)
	{
		return;
	}

	bHasExploded = True;
	BlowUp(HitLocation);

	PlaySound(ExplodeSounds[rand(ExplodeSounds.length)],,1.65f);
	
	if ( EffectIsRelevant(Location,false) )
	{
		Spawn(Class'KFTurbo.V_Berserker_Grenade_Explosion',,,HitLocation + HitNormal*20,rotator(HitNormal));
        Spawn(Class'KFTurbo.V_Berserker_Grenade_Impact',self,,HitLocation, rotator(-HitNormal));
	}

	// Shake nearby players screens
	LocalPlayer = Level.GetLocalPlayerController();
	if ( (LocalPlayer != None) && (VSize(Location - LocalPlayer.ViewTarget.Location) < (DamageRadius * 1.5)) )
		LocalPlayer.ShakeView(RotMag, RotRate, RotTime, OffsetMag, OffsetRate, OffsetTime);

	Destroy();
}

simulated function HurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
	local actor Victim;
	local int NumKilled;
	local KFMonster KFMonsterVictim;
	local Pawn P;
	local array<Pawn> CheckedPawns;
	local int i;
	local bool bAlreadyChecked;
	local bool bWasZapped;

	if ( bHurtEntry )
	{
		return;
	}

	bHurtEntry = true;

	foreach CollidingActors (class 'Actor', Victim, DamageRadius, HitLocation)
	{
		if ((Victim == Self) || (Hurtwall == Victim) || (Victim.Role != ROLE_Authority) || Victim.IsA('FluidSurfaceInfo') || (ExtendedZCollision(Victim) != None))
		{
			continue;
		}

		if ( Instigator == None || Instigator.Controller == None )
		{
			Victim.SetDelayedDamageInstigatorController( InstigatorController );
		}

		P = Pawn(Victim);

		if ( P == None)
		{
			continue;
		}

		for (i = 0; i < CheckedPawns.Length; i++)
		{
			if (CheckedPawns[i] == P)
			{
				bAlreadyChecked = true;
				break;
			}
		}

		if( bAlreadyChecked )
		{
			bAlreadyChecked = false;
			P = none;
			continue;
		}

		KFMonsterVictim = KFMonster(Victim);

		if( KFMonsterVictim != none && KFMonsterVictim.Health <= 0 )
		{
			KFMonsterVictim = none;
		}

		CheckedPawns[CheckedPawns.Length] = P;

		if( KFMonsterVictim == none )
		{
			P = none;
			continue;
		}
		else
		{
			// Zap zeds only
			if( Role == ROLE_Authority )
			{
				bWasZapped = KFMonsterVictim.bZapped;
				KFMonsterVictim.SetZapped(ZapAmount, Instigator);
				class'TurboEventHandler'.static.BroadcastPawnZapped(Instigator, KFMonsterVictim, ZapAmount, bWasZapped != KFMonsterVictim.bZapped);
				NumKilled++;
			}
		}

		P = none;
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
    ExplodeTimer=2.0
    Damage=0 //Doesn't do damage.
    DamageRadius=260.0
	ZapAmount = 1.5;

    DampenFactor=0.200000
    DampenFactorParallel=0.300000
	
	LightType=LT_Pulse
    LightBrightness=128
	LightPeriod=16
    LightRadius=0.500000
    LightHue=128
    LightSaturation=64
    bDynamicLight=True

    StaticMesh=StaticMesh'KFTurbo.XM84.XM84Projectile'
	Skins(0)=Shader'KFTurbo.XM84.XM84-Glow'
    DrawScale=0.75

    ExplodeSounds=(sound'KF_FY_ZEDV2SND.WEP_ZEDV2_Secondary_Explode')

	Physics=PHYS_Falling
	bUseCollisionStaticMesh = false
	bUseCylinderCollision = false
	bFixedRotationDir = true

	CollisionRadius=5
    CollisionHeight=5
    RotationRate=(Roll=0)
	PrePivot=(Z=6);
}
