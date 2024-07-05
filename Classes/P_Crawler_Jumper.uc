class P_Crawler_Jumper extends P_Crawler_SUM;

var float PounceWindupDuration;
var float TimeSpentInWindup;
var bool bDidPounceWindupAnim;

function bool CanPounce()
{
    if ( bZapped || bDecapitated || bIsCrouched || bWantsToCrouch || (Physics != PHYS_Walking) || VSize(Location - Controller.Target.Location) > (MeleeRange * 25) )
    {
        return false;
    }

    return true;
}

function bool DoPounce()
{
    if ( !CanPounce() )
    {
        return false;
    }

    GotoState('PounceWindup');
    return true;
}

simulated event SetAnimAction(name NewAction)
{
    Super.SetAnimAction(NewAction);
}

simulated function int DoAnimAction( name AnimName )
{
    if (AnimName == 'PounceWindup')
    {
		AnimBlendParams(1, 0.75f);
		PlayAnim('KnockDown',0.5f, 0.33f, 1.f);
        bDidPounceWindupAnim = true;
		return 1;
    }

    if (bDidPounceWindupAnim)
    {
        StopAnimating(true);
    }

    return Super.DoAnimAction(AnimName);
}

State ZombieDying
{
ignores DoPounce;
}

State RegularMoving
{

}

State PounceWindup
{
ignores HitWall, RangedAttack, PlayDirectionalHit;

    function BeginState()
    {
        TimeSpentInWindup = 0.f;

        Super.BeginState();

        SetAnimAction('PounceWindup');
    }

    function SetBurningBehavior()
    {
        if (bHarpoonStunned)
        {
            GotoState('RegularMoving');
        }

        Global.SetBurningBehavior();
    }

    function SetZappedBehavior()
    {
        GotoState('RegularMoving');
        Global.SetZappedBehavior();
    }

    function bool CanGetOutOfWay()
    {
        return false;
    }

    function bool HitCanInterruptAction()
    {
        return false;
    }

	function Tick( float DeltaTime )
	{
        Acceleration = vect(0,0,0);
        Velocity = vect(0,0,0);
        TimeSpentInWindup += DeltaTime;

        if (!CanPounce() || TimeSpentInWindup > (PounceWindupDuration * 1.1f))
        {
            GotoState('RegularMoving');
        }

        Global.Tick(DeltaTime);
	}

    function bool DoPounce()
    {
        return true;
    }

    function PerformPounce()
    {
        GotoState('RegularMoving');
        
        if ( !CanPounce() )
        {
            return;
        }

        Velocity = Normal(Controller.Target.Location-Location)*PounceSpeed;
        Velocity.Z = JumpZ;
        SetPhysics(PHYS_Falling);
        ZombieSpringAnim();
        bPouncing=true;
        return;
    }

Begin:
    Sleep(PounceWindupDuration);
    PerformPounce();
}

defaultproperties
{
    PounceWindupDuration=1.f
    bDidPounceWindupAnim = false;
    PounceSpeed=1650.f

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
    
    ControllerClass=class'KFTurbo.AI_Crawler_Jumper'
    MenuName="Raptor"
}
