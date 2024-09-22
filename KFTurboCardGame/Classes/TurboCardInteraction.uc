//Killing Floor Turbo TurboCardInteraction
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboCardInteraction extends Engine.Interaction;

var bool bShiftIsPressed;

static final function CardGamePlayerReplicationInfo FindCGPRI(PlayerController PlayerController)
{
	return class'CardGamePlayerReplicationInfo'.static.GetCardGameLRI(PlayerController.PlayerReplicationInfo);
}

static final function TurboCardOverlay FindCardOverlay(PlayerController PlayerController)
{
	local int Index;

	for (Index = 0; Index < PlayerController.myHUD.Overlays.Length; Index++)
	{
		if (TurboCardOverlay(PlayerController.myHUD.Overlays[Index]) != None)
		{
			return TurboCardOverlay(PlayerController.myHUD.Overlays[Index]);
		}
	}

	return None;
}

simulated function bool KeyEvent( out EInputKey Key, out EInputAction Action, FLOAT Delta )
{
	if (Action == IST_Press)
	{
		if (Key == IK_MouseWheelUp || Key == IK_MouseWheelDown)
		{
			return FindCardOverlay(ViewportOwner.Actor).ReceivedKeyEvent(Key);
		}
		if (Key == IK_Shift)
		{
			bShiftIsPressed = true;
		}
		else if (bShiftIsPressed)
		{
			return FindCGPRI(ViewportOwner.Actor).ProcessVoteKeyPressEvent(Key);
		}
	}
	else if (Action == IST_Release)
	{
		if (Key == IK_Shift)
		{
			bShiftIsPressed = false;
		}
	}
	
	return false;
}

defaultproperties
{

}