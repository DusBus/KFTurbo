class W_Bullpup_brrt_Weap extends Bullpup;

simulated function DoToggle()
{

}

function ServerChangeFireMode(bool bNewWaitForRelease)
{

}

defaultproperties
{
     MagCapacity=80
     FireModeClass(0)=Class'KFTurboRandomizer.W_Bullpup_brrt_Fire'
     PickupClass=Class'KFTurboRandomizer.W_Bullpup_brrt_Pickup'
     ItemName="Questionable Bullpup"
}