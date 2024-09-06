//Killing Floor Turbo AfflictionHarpoon
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class AfflictionHarpoon extends AfflictionBase;

var float HarpoonSpeedModifier;

simulated function PreTick(float DeltaTime)
{
	if (OwningMonster == None || OwningMonster.bHarpoonStunned)
	{
		CachedMovementSpeedModifier = HarpoonSpeedModifier;
	}
	else
	{
		CachedMovementSpeedModifier = 1.f;
	}
}

defaultproperties
{
	HarpoonSpeedModifier = 0.75f;
}
