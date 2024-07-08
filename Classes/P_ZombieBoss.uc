class P_ZombieBoss extends ZombieBoss
    DependsOn(PawnHelper);

var PawnHelper.AfflictionData AfflictionData;

var array<Material> CloakedSkinList;
var Sound HelpMeSound;

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

function bool MeleeDamageTarget(int HitDamage, vector PushDirection)
{
	if( Controller.Target!=None && Controller.Target.IsA('NetKActor') )
    {
        PushDirection = Normal(Controller.Target.Location-Location) * 100000.f;
    }
	
    return class'PawnHelper'.static.MeleeDamageTarget(Self, HitDamage, PushDirection);
}

simulated function Tick(float DeltaTime)
{
    class'PawnHelper'.static.PreTickAfflictionData(DeltaTime, self, AfflictionData);

    TickCloak(DeltaTime);

    Super.Tick(DeltaTime);

    class'PawnHelper'.static.TickAfflictionData(DeltaTime, self, AfflictionData);
}

//We do our own cloak check. Setting LastCheckTimes means ZombieBoss:Tick will never perform its cloak behaviour.
simulated function TickCloak(float DeltaTime)
{
    local KFHumanPawn HumanPawn;

    if (Level.NetMode == NM_DedicatedServer)
    {
        return;
    }

    if (!bCloaked || Level.TimeSeconds < LastCheckTimes)
    {
        return;
    }

    LastCheckTimes = Level.TimeSeconds + 0.25f;

    //Ignore visibility, if any pawns around him are capable of showing stalkers, they are using V_Commando as a perk.
    foreach CollidingActors(Class'KFHumanPawn', HumanPawn, 1600.f, Location)
    {
        if( HumanPawn.Health <= 0 || !HumanPawn.ShowStalkers() )
        {
            continue;
        }

        if( !bSpotted )
        {
            bSpotted = True;
            CloakBoss();
        }
        
        return;
    }
    
    if( bSpotted )
    {
        bSpotted = False;
        bUnlit = false;
        CloakBoss();
    }
}

simulated function CloakBoss()
{
	local Controller C;
	local int Index;

    if( bZapped )
    {
        return;
    }

	if( bSpotted )
	{
		Visibility = 120;

		if( Level.NetMode==NM_DedicatedServer )
        {
			Return;
        }
		
        Skins[0] = Finalblend'KFX.StalkerGlow';
		Skins[1] = Finalblend'KFX.StalkerGlow';
		bUnlit = true;
		return;
	}

	Visibility = 1;
	bCloaked = true;

	if( Level.NetMode!=NM_Client )
	{
		for( C=Level.ControllerList; C!=None; C=C.NextController )
		{
			if( C.bIsPlayer && C.Enemy==Self )
            {
				C.Enemy = None; // Make bots lose sight with me.
            }
		}
	}
	
    if( Level.NetMode==NM_DedicatedServer )
    {
        return;
    }	

    Skins = CloakedSkinList;

	if(PlayerShadow != none)
    {
        PlayerShadow.bShadowActive = false;
    }
    
	Projectors.Remove(0, Projectors.Length);
	bAcceptsProjectors = false;
    SetOverlayMaterial(FinalBlend'KF_Specimens_Trip_T.patriarch_fizzle_FB', 1.0, true);

	// Randomly send out a message about Patriarch going invisible(10% chance)
	if ( FRand() < 0.10 )
	{
		// Pick a random Player to say the message
		Index = Rand(Level.Game.NumPlayers);

		for ( C = Level.ControllerList; C != none; C = C.NextController )
		{
			if ( PlayerController(C) != none )
			{
				if ( Index == 0 )
				{
					PlayerController(C).Speech('AUTO', 8, "");
					break;
				}

				Index--;
			}
		}
	}
}

simulated function UnCloakBoss()
{
    if( bZapped )
    {
        return;
    }

	Visibility = default.Visibility;
	bCloaked = false;
	bSpotted = False;
	bUnlit = False;
	
    if( Level.NetMode == NM_DedicatedServer )
    {
		return;
    }

	Skins = Default.Skins;

	if (PlayerShadow != none)
    {
        PlayerShadow.bShadowActive = true;
    }

	bAcceptsProjectors = true;
    SetOverlayMaterial( none, 0.0, true );
}

state KnockDown
{
	function bool ShouldChargeFromDamage()
	{
		return false;
	}

Begin:
	if ( Health > 0 )
	{
		Sleep(GetAnimDuration('KnockDown'));
		CloakBoss();
		PlaySound(HelpMeSound, SLOT_Misc, 2.0,,500.0);

		if ( KFGameType(Level.Game).FinalSquadNum == SyringeCount )
		{
		   KFGameType(Level.Game).AddBossBuddySquad();
		}

		GotoState('Escaping');
	}
	else
	{
	   GotoState('');
	}
}

function float NumPlayersHealthModifer()
{
    return class'PawnHelper'.static.GetBodyHealthModifier(self, Level);
}

function float NumPlayersHeadHealthModifer()
{
    return class'PawnHelper'.static.GetHeadHealthModifier(self, Level);
}

defaultproperties
{
    //NOTE: Affliction move speed modifiers are not used by the boss. They exist, but are not used.
    Begin Object Class=A_Burn Name=BurnAffliction
    End Object

    Begin Object Class=A_Zap Name=ZapAffliction
        ZapDischargeDelay=2.f
        ZapDischargeRate=0.25f
    End Object

    Begin Object Class=A_Harpoon Name=HarpoonAffliction
    End Object

    AfflictionData=(Burn=A_Burn'BurnAffliction',Zap=A_Zap'ZapAffliction',Harpoon=A_Harpoon'HarpoonAffliction')

	CloakedSkinList(0) = Shader'KF_Specimens_Trip_T.patriarch_invisible_gun'
	CloakedSkinList(1) = Shader'KF_Specimens_Trip_T.patriarch_invisible'
    HelpMeSound=Sound'KF_EnemiesFinalSnd.Patriarch.Kev_SaveMe'
}
