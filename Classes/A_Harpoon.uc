class A_Harpoon extends A_BaseAffliction;

var float HarpoonSpeedModifier;

simulated function PreTick(float DeltaTime)
{
	if (OwningMonster.bHarpoonStunned)
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
