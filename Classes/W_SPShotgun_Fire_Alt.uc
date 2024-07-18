class W_SPShotgun_Fire_Alt extends SPShotgunAltFire;

function HandleAchievement( Pawn Victim )
{
    local vector VelocityAdded;
    Super.HandleAchievement(Victim);

    if (Instigator == None)
    {
        return;
    }

    VelocityAdded = Normal((Victim.Location + Victim.EyePosition()) - Instigator.Location);
    VelocityAdded = VelocityAdded * InterpCurveEval(AppliedMomentumCurve, Victim.Mass) / Victim.Mass;

    class'KFTurboEventHandler'.static.BroadcastPawnPushedWithMCZThrower(Instigator, Victim, VelocityAdded);
}

defaultproperties
{
}
