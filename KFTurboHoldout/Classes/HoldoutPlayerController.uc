class HoldoutPlayerController extends TurboPlayerController;

simulated function ClientSetHUD(class<HUD> newHUDClass, class<Scoreboard> newScoringClass )
{
	if (class<HoldoutHUDKillingFloor>(newHUDClass) == None)
	{
		Super.ClientSetHUD(class'HoldoutHUDKillingFloor', newScoringClass);
	}

	Super.ClientSetHUD(newHUDClass, newScoringClass);
}

defaultproperties
{
	PawnClass=Class'KFTurboHoldout.HoldoutHumanPawn'
}