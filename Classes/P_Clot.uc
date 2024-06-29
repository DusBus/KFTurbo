class P_Clot extends ZombieClot DependsOn(PawnHelper);

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
    
    Super.Tick(DeltaTime);

    class'PawnHelper'.static.TickAfflictionData(DeltaTime, self, AfflictionData);

    if(bSTUNNED && bUnstunTimeReady && UnstunTime < Level.TimeSeconds)
    {
        bSTUNNED = false;
        bUnstunTimeReady = false;
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
    //BurnRatio = 0.f;
}

simulated function UnSetBurningBehavior()
{
    class'PawnHelper'.static.UnSetBurningBehavior(self, AfflictionData);
    //BurnRatio = 0.f;
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
