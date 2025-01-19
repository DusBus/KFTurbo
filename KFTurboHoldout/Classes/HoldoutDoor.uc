class HoldoutDoor extends Mover
	placeable;


state() TriggerToggle
{
	//Only allow opening from triggers.
	function Trigger(Actor Other, Pawn EventInstigator)
	{
		if (KeyNum != 0 && KeyNum >= PrevKeyNum)
		{
			return;
		}

		Super.Trigger(Other, EventInstigator);
	}
}

defaultproperties
{
	InitialState="TriggerToggle"
    MoverEncroachType=ME_IgnoreWhenEncroach
	bNoAIRelevance=true
	bPathColliding=false
}