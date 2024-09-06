//Killing Floor Turbo ChatIcon
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
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
     Texture=Texture'KFTurbo.Generic.ChatIcon_a00'
     DrawScale=0.05
     Style=STY_Masked
}
