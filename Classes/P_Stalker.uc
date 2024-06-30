class P_Stalker extends ZombieStalker DependsOn(PawnHelper);

var Material DefaultSkin[2];
var Material CloakedSkin[2];

var PawnHelper.AfflictionData AfflictionData;

var bool bUnstunTimeReady;
var float UnstunTime;

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();

    class'PawnHelper'.static.InitializePawnHelper(self, AfflictionData);
}

function TakeDamage(int Damage, Pawn InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
	if (Role == ROLE_Authority)
	{
		class'PawnHelper'.static.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitIndex, AfflictionData);
	}

	Super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitIndex);
}

simulated function Tick(float DeltaTime)
{
    class'PawnHelper'.static.PreTickAfflictionData(DeltaTime, self, AfflictionData);

    Super(KFMonster).Tick(DeltaTime);

    class'PawnHelper'.static.TickAfflictionData(DeltaTime, self, AfflictionData);

    if(bSTUNNED && bUnstunTimeReady && UnstunTime < Level.TimeSeconds)
    {
        bSTUNNED = false;
        bUnstunTimeReady = false;
    }

    TickCloak(DeltaTime);
}

function float NumPlayersHealthModifer()
{
    return class'PawnHelper'.static.GetBodyHealthModifier(self, Level);
}

function float NumPlayersHeadHealthModifer()
{
    return class'PawnHelper'.static.GetHeadHealthModifier(self, Level);
}

simulated function float GetOriginalGroundSpeed()
{
    return class'PawnHelper'.static.GetOriginalGroundSpeed(self, AfflictionData);
}

function PlayDirectionalHit(Vector HitLoc)
{
    local int LastStunCount;

    LastStunCount = StunsRemaining;

    if(class'PawnHelper'.static.ShouldPlayDirectionalHit(self))
        Super.PlayDirectionalHit(HitLoc);

    if(LastStunCount != StunsRemaining)
    {
        UnstunTime = Level.TimeSeconds + StunTime;
        bUnstunTimeReady = true;
    }
}

simulated function SetBurningBehavior()
{
    class'PawnHelper'.static.SetBurningBehavior(self, AfflictionData);
}

simulated function UnSetBurningBehavior()
{
    class'PawnHelper'.static.UnSetBurningBehavior(self, AfflictionData);
}

simulated function SetZappedBehavior()
{
    class'PawnHelper'.static.SetZappedBehavior(self, AfflictionData);

    bUnlit = false;

    if( Level.Netmode != NM_DedicatedServer )
	{
        Skins[0] = DefaultSkin[0];
        Skins[1] = DefaultSkin[1];

		if (PlayerShadow != none)
			PlayerShadow.bShadowActive = true;

		bAcceptsProjectors = true;
		SetOverlayMaterial(Material'KFZED_FX_T.Energy.ZED_overlay_Hit_Shdr', 999, true);
	}
}

simulated function UnSetZappedBehavior()
{
    class'PawnHelper'.static.UnSetZappedBehavior(self, AfflictionData);
    
    if( Level.Netmode != NM_DedicatedServer )
	{
        NextCheckTime = Level.TimeSeconds;
        SetOverlayMaterial(None, 0.0f, true);
	}
}

simulated function ZombieCrispUp()
{
    class'PawnHelper'.static.ZombieCrispUp(self);
}

simulated function Timer()
{
    if (BurnDown > 0)
    {
        TakeFireDamage(LastBurnDamage + rand(2) + 3 , LastDamagedBy);
        SetTimer(1.0,false);
    }
    else
    {
        UnSetBurningBehavior();

        RemoveFlamingEffects();
        StopBurnFX();
        SetTimer(0, false);
    }
}

//Fixing up Stalker material issues;
simulated function TickCloak(float DeltaTime)
{
    if( Level.NetMode==NM_DedicatedServer )
		return; // Servers aren't intrested in this info.

    if( bZapped )
    {
        // Make sure we check if we need to be cloaked as soon as the zap wears off
        NextCheckTime = Level.TimeSeconds;
    }
	else if( Level.TimeSeconds > NextCheckTime && Health > 0 )
	{
		NextCheckTime = Level.TimeSeconds + 0.5;

		if( LocalKFHumanPawn != none && LocalKFHumanPawn.Health > 0 && LocalKFHumanPawn.ShowStalkers() &&
			VSizeSquared(Location - LocalKFHumanPawn.Location) < LocalKFHumanPawn.GetStalkerViewDistanceMulti() * 640000.0 ) // 640000 = 800 Units
		{
			bSpotted = True;
		}
		else
		{
			bSpotted = false;
		}

		if ( !bSpotted && !bCloaked && Skins[0] != DefaultSkin[0] )
		{
			UncloakStalker();
		}
		else if ( Level.TimeSeconds - LastUncloakTime > 1.2 )
		{
			// if we're uberbrite, turn down the light
			if( bSpotted && Skins[0] != Finalblend'KFX.StalkerGlow' )
			{
				bUnlit = false;
				CloakStalker();
			}
			else if ( Skins[0] != CloakedSkin[0] )
			{
				CloakStalker();
			}
		}
	}
}

function RemoveHead()
{
	Super(KFMonster).RemoveHead();

	if ( !bCrispified )
	{
        Skins[0] = DefaultSkin[0];
        Skins[1] = DefaultSkin[1];
	}
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	Super(KFMonster).PlayDying(DamageType,HitLoc);

	if ( bUnlit )
	{
		bUnlit=!bUnlit;
	}

	LocalKFHumanPawn = none;

	if ( !bCrispified )
	{
        Skins[0] = DefaultSkin[0];
        Skins[1] = DefaultSkin[1];
	}
}

simulated function CloakStalker()
{
    // No cloaking if zapped
    if( bZapped )
    {
        return;
    }

	if ( bSpotted )
	{
		if( Level.NetMode == NM_DedicatedServer )
			return;

		Skins[0] = Finalblend'KFX.StalkerGlow';
		Skins[1] = Finalblend'KFX.StalkerGlow';
		bUnlit = true;
		return;
	}

	if ( !bDecapitated && !bCrispified ) // No head, no cloak, honey.  updated :  Being charred means no cloak either :D
	{
		Visibility = 1;
		bCloaked = true;

		if( Level.NetMode == NM_DedicatedServer )
			Return;

        Skins[0] = CloakedSkin[0];
        Skins[1] = CloakedSkin[1];

		// Invisible - no shadow
		if(PlayerShadow != none)
			PlayerShadow.bShadowActive = false;
		if(RealTimeShadow != none)
			RealTimeShadow.Destroy();

		// Remove/disallow projectors on invisible people
		Projectors.Remove(0, Projectors.Length);
		bAcceptsProjectors = false;
		SetOverlayMaterial(Material'KFX.FBDecloakShader', 0.25, true);
	}
}

simulated function UnCloakStalker()
{
    if( bZapped )
    {
        return;
    }

	if( !bCrispified )
	{
		LastUncloakTime = Level.TimeSeconds;

		Visibility = default.Visibility;
		bCloaked = false;
		bUnlit = false;

		// 25% chance of our Enemy saying something about us being invisible
		if ( Level.NetMode!=NM_Client && !KFGameType(Level.Game).bDidStalkerInvisibleMessage && FRand()<0.25 && Controller.Enemy!=none &&
		 	 PlayerController(Controller.Enemy.Controller)!=none )
		{
			PlayerController(Controller.Enemy.Controller).Speech('AUTO', 17, "");
			KFGameType(Level.Game).bDidStalkerInvisibleMessage = true;
		}

		if ( Level.NetMode == NM_DedicatedServer )
		{
			Return;
		}

		if ( Skins[0] != DefaultSkin[0] )
		{
            Skins[0] = DefaultSkin[0];
            Skins[1] = DefaultSkin[1];

			if ( PlayerShadow != none )
			{
				PlayerShadow.bShadowActive = true;
			}

			bAcceptsProjectors = true;

			SetOverlayMaterial(Material'KFX.FBDecloakShader', 0.25, true);
		}
	}
}

defaultproperties
{

    Begin Object Class=A_Burn Name=BurnAffliction
        BurnDurationModifier=1.f
    End Object

    Begin Object Class=A_Zap Name=ZapAffliction
        ZapDischargeRate=0.5f
    End Object

    Begin Object Class=A_Harpoon Name=HarpoonAffliction
        HarpoonSpeedModifier=0.5f
    End Object

    AfflictionData=(Burn=A_Burn'BurnAffliction',Zap=A_Zap'ZapAffliction',Harpoon=A_Harpoon'HarpoonAffliction')
}
