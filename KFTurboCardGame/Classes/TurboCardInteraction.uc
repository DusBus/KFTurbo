//Killing Floor Turbo TurboCardInteraction
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboCardInteraction extends Engine.Interaction;

var bool bShiftIsPressed;

static final function CardGamePlayerReplicationInfo FindCGPRI(PlayerController PlayerController)
{
	return class'CardGamePlayerReplicationInfo'.static.GetCardGameLRI(PlayerController.PlayerReplicationInfo);
}

static final function bool SendVoteKeyPressEvent(PlayerController PlayerController, Interactions.EInputKey Key)
{
	local CardGamePlayerReplicationInfo CGPRI;

	CGPRI = FindCGPRI(PlayerController);

	if (CGPRI == None)
	{
		return false;
	}

	return CGPRI.ProcessVoteKeyPressEvent(Key);
}

simulated function bool KeyEvent( out EInputKey Key, out EInputAction Action, FLOAT Delta )
{
	if (Action == IST_Press)
	{
		if (Key == IK_MouseWheelUp || Key == IK_MouseWheelDown)
		{
			return class'TurboCardOverlay'.static.FindCardOverlay(ViewportOwner.Actor).ReceivedKeyEvent(Key, Action);
		}

		if (Key == IK_Shift)
		{
			class'TurboCardOverlay'.static.FindCardOverlay(ViewportOwner.Actor).ReceivedKeyEvent(Key, Action);
			bShiftIsPressed = true;
		}
		else if (bShiftIsPressed)
		{
			return SendVoteKeyPressEvent(ViewportOwner.Actor, Key);
		}
	}
	else if (Action == IST_Release)
	{
		if (Key == IK_Shift)
		{
			class'TurboCardOverlay'.static.FindCardOverlay(ViewportOwner.Actor).ReceivedKeyEvent(Key, Action);
			bShiftIsPressed = false;
		}
	}
	
	return false;
}

defaultproperties
{

}