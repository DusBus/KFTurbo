class P_FleshPound_AvoidArea extends FleshPoundAvoidArea;

function bool RelevantTo(Pawn P)
{	
	if (KFMonster(P) != None && (P.AnimAction == 'KnockDown' || !KFMonster(P).CanGetOutOfWay()))
	{
		return false;
	}

	if (ZombieFleshpoundBase(P) != None)
	{
		return false;
	}

	return Super.RelevantTo(P);
}

defaultproperties
{

}
