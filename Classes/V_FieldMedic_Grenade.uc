class V_FieldMedic_Grenade extends KFMod.MedicNade;

simulated function Explode(vector HitLocation, vector HitNormal)
{
    Super.Explode(HitLocation, HitNormal);

    LightType = LT_None;
    bDynamicLight = false;
}

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

    // Reflect off Wall w/damping
    VNorm = (Velocity dot HitNormal) * HitNormal;
    Velocity = -VNorm * DampenFactor + (Velocity - VNorm) * DampenFactorParallel;

    RandSpin(100000);
    Speed = VSize(Velocity);

    if ( Speed < 10 )
    {
        bBounce = False;
        Timer();
        SetTimer(0.0,False);

		class'WeaponHelper'.static.BeginGrenadeSmoothRotation(self, 20);

		if( Fear == none )
		{
		    //(jc) Changed to use MedicNade-specific grenade that's overridden to not make the ringmaster fear it
		    Fear = Spawn(class'AvoidMarker_MedicNade');
    		Fear.SetCollisionSize(DamageRadius,DamageRadius);
    		Fear.StartleBots();
		}

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

defaultproperties
{
	LightType=LT_Pulse
    LightBrightness=64
	LightPeriod=16
    LightRadius=0.500000
    LightHue=62
    LightSaturation=150
    bDynamicLight=True

    DampenFactor=0.250000
    DampenFactorParallel=0.35

    StaticMesh=StaticMesh'KFTurboExtra.T10.T10Projectile'
	Skins(0)=Texture'KFTurboExtra.G28.G28MedicGrenade'
    DrawScale=0.2
	
	Physics=PHYS_Falling
	bUseCollisionStaticMesh = false
	bUseCylinderCollision = false
	bFixedRotationDir = true

	CollisionRadius=6
    CollisionHeight=6
    RotationRate=(Roll=0)
}
