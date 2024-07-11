class ChatIcon extends Actor;

simulated function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);

	if (bDeleteMe)
	{
		return;
	}

	if (Owner == None)
	{
		Destroy();
	}
}

defaultproperties
{
     Texture=Texture'KFTurboContent.Generic.ChatIcon_a00'
     DrawScale=0.05
     Style=STY_Masked
}
