class P_FleshPound_AvoidArea extends FleshPoundAvoidArea;

function bool RelevantTo(Pawn P)
{
	if (ZombieFleshpoundBase(P) != None)
	{
		return false;
	}

	return Super.RelevantTo(P);
}

defaultproperties
{

}
