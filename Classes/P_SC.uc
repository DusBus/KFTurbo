class P_SC extends ZombieScrake
    abstract
    DependsOn(PawnHelper);

var PawnHelper.AfflictionData AfflictionData;

var bool bUnstunTimeReady;
var float UnstunTime;

var AI_SC ProAI;

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();

    //In unrealscript it's probably more expensive to check role/if controller exists rather than just cast a null.
    ProAI = AI_SC(Controller);

    class'PawnHelper'.static.InitializePawnHelper(self, AfflictionData);
}

function TakeDamage(int Damage, Pawn InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
	if (Role == ROLE_Authority)
	{
		class'PawnHelper'.static.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitIndex, AfflictionData);

        if ( Level.Game.GameDifficulty >= 5.0  && (class<DamTypeFlareProjectileImpact>(damageType) != none) )
        {
            Damage *= 0.75; // flare impact damage reduction
        }
        if ( Level.Game.GameDifficulty >= 5.0  && (class<DamTypeFlareRevolver>(damageType) != none) )
        {
            Damage *= 0.75; // flare explosion damage reduction
        }
	}

	Super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitIndex);
}

simulated function Tick(float DeltaTime)
{
    class'PawnHelper'.static.PreTickAfflictionData(DeltaTime, self, AfflictionData);
    
    Super.Tick(DeltaTime);

    class'PawnHelper'.static.TickAfflictionData(DeltaTime, self, AfflictionData);

    if(bSTUNNED && bUnstunTimeReady && UnstunTime < Level.TimeSeconds)
    {
        bSTUNNED = false;
        bUnstunTimeReady = false;
    }
}

simulated function PostNetReceive()
{
    if (!bHarpoonStunned)
    {
        if (bCharging)
        {
            MovementAnims[0]='ChargeF';
        }
        else
        {
            MovementAnims[0]=default.MovementAnims[0];
        }
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

simulated function float GetOriginalGroundSpeed()
{
    return Super.GetOriginalGroundSpeed() * class'PawnHelper'.static.GetSpeedMultiplier(AfflictionData);
}

function PlayDirectionalHit(Vector HitLoc)
{
    local int LastStunCount;
    LastStunCount = StunsRemaining;

    if(!bUnstunTimeReady && class'PawnHelper'.static.ShouldPlayDirectionalHit(self))
        Super.PlayDirectionalHit(HitLoc);

	bUnstunTimeReady = class'PawnHelper'.static.UpdateStunProperties(self, LastStunCount, UnstunTime, bUnstunTimeReady);
}

simulated function SetBurningBehavior()
{
    class'PawnHelper'.static.SetBurningBehavior(self, AfflictionData);

    if( Level.NetMode != NM_DedicatedServer && !bHarpoonStunned)
        PostNetReceive();
}

simulated function UnSetBurningBehavior()
{
    class'PawnHelper'.static.UnSetBurningBehavior(self, AfflictionData);

    GoToState('');

    if( Level.NetMode != NM_DedicatedServer )
        PostNetReceive();    
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

State SawingLoop
{
    function AnimEnd( int Channel )
    {
        Super(KFMonster).AnimEnd(Channel);

        if( Controller!=None && Controller.Enemy!=None && CanAttack(Controller.Enemy))
            RangedAttack(Controller.Enemy);
    }
}

simulated function SetZappedBehavior()
{
    if(ProAI != None && ProAI.bForcedRage)
        return;

    class'PawnHelper'.static.SetZappedBehavior(self, AfflictionData);
}

simulated function UnSetZappedBehavior()
{
    class'PawnHelper'.static.UnSetZappedBehavior(self, AfflictionData);
}


state RunningState
{
    simulated function SetBurningBehavior()
    {
		Global.SetBurningBehavior();
    }

    simulated function UnSetBurningBehavior()
    {
		Global.UnSetBurningBehavior();
    }

    simulated function SetZappedBehavior()
    {
		Global.SetZappedBehavior();
    }

    simulated function UnSetZappedBehavior()
    {
		Global.UnSetZappedBehavior();
    }

	function BeginState()
	{
		if(bZapped)
        {
            GoToState('');
        }
        else
        {
    		SetGroundSpeed(OriginalGroundSpeed * 3.5);
    		bCharging = true;
    		if( Level.NetMode!=NM_DedicatedServer )
    			PostNetReceive();

    		NetUpdateTime = Level.TimeSeconds - 1;
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
        HarpoonSpeedModifier=0.75f
    End Object

    AfflictionData=(Burn=A_Burn'BurnAffliction',Zap=A_Zap'ZapAffliction',Harpoon=A_Harpoon'HarpoonAffliction')

    EventClasses(0)="KFTurbo.P_SC_DEF"
    ControllerClass=Class'KFTurbo.AI_SC'
}
