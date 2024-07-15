class P_Siren extends ZombieSiren DependsOn(PawnHelper);

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

function TakeFireDamage(int Damage, pawn DamageInstigator)
{
    class'PawnHelper'.static.BlockPlayDirectionalHit(AfflictionData);

    Super.TakeFireDamage(Damage, DamageInstigator);

    class'PawnHelper'.static.UnblockPlayDirectionalHit(AfflictionData);
}

function bool MeleeDamageTarget(int HitDamage, vector PushDirection)
{
    return class'PawnHelper'.static.MeleeDamageTarget(Self, HitDamage, PushDirection);
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

simulated function AnimEnd(int Channel)
{
    local name  Sequence;
	local float Frame, Rate;
    
	GetAnimParams(1, Sequence, Frame, Rate);

    Super.AnimEnd(Channel);

    if (!bShotAnim || Sequence != 'Siren_Scream')
    {
        return;
    }
    
    //If the anim that ended was Siren_Scream, make sure we set this to false.
    bShotAnim = false;
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

    if(class'PawnHelper'.static.ShouldPlayDirectionalHit(self, AfflictionData))
        Super.PlayDirectionalHit(HitLoc);

	bUnstunTimeReady = class'PawnHelper'.static.UpdateStunProperties(self, LastStunCount, UnstunTime, bUnstunTimeReady);
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
}

simulated function UnSetZappedBehavior()
{
    class'PawnHelper'.static.UnSetZappedBehavior(self, AfflictionData);
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

function RangedAttack(Actor A)
{
    local int LastFireTime;
    local float Dist;

    if ( bShotAnim )
    {
        return;
    }

    Dist = VSize(A.Location - Location);

    if ( Physics == PHYS_Swimming )
    {
        SetAnimAction('Claw');
        bShotAnim = true;
        LastFireTime = Level.TimeSeconds;
    }
    else if ( Dist < MeleeRange + CollisionRadius + A.CollisionRadius )
    {
        bShotAnim = true;
        LastFireTime = Level.TimeSeconds;
        SetAnimAction('Claw');
        //PlaySound(sound'Claw2s', SLOT_Interact); KFTODO: Replace this
        Controller.bPreparingMove = true;
        Acceleration = vect(0,0,0);
    }
    else if( Dist <= ScreamRadius && !bDecapitated && !bZapped && !bHarpoonStunned)
    {
        bShotAnim=true;
        SetAnimAction('Siren_Scream');
        // Only stop moving if we are close
        if( Dist < ScreamRadius * 0.25 )
        {
            Controller.bPreparingMove = true;
            Acceleration = vect(0,0,0);
        }
        else
        {
            Acceleration = AccelRate * Normal(A.Location - Location);
        }
    }
}

simulated function SpawnTwoShots()
{
    if( bDecapitated || bZapped || bHarpoonStunned )
    {
        return;
    }

    DoShakeEffect();

    if( Level.NetMode!=NM_Client )
    {
        // Deal Actual Damage.
        if( Controller!=None && KFDoorMover(Controller.Target)!=None )
            Controller.Target.TakeDamage(ScreamDamage*0.6,Self,Location,vect(0,0,0),ScreamDamageType);
        else HurtRadius(ScreamDamage ,ScreamRadius, ScreamDamageType, ScreamForce, Location);
    }
}

State ZombieDying
{
ignores AnimEnd, Trigger, Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, BreathTimer, Died, RangedAttack, SpawnTwoShots;
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
