class KFTurboHoldoutMut extends Mutator;

#exec obj load file="..\Textures\TurboHoldout.utx" package=KFTurboHoldout
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if(Role != ROLE_Authority)
	{
		return;
	}

	if (!ClassIsChildOf(Level.Game.PlayerControllerClass, class'HoldoutPlayerController'))
	{
		Level.Game.PlayerControllerClass = class'HoldoutPlayerController';
		Level.Game.PlayerControllerClassName = string(class'HoldoutPlayerController');
	}
}

simulated function String GetHumanReadableName()
{
	return FriendlyName;
}

defaultproperties
{
    bAddToServerPackages=True
	GroupName="KF-Holdout"
	FriendlyName="Killing Floor Turbo Holdout"
	Description="Mutator for the KFTurbo Holdout Game Type."
}