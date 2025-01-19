class HoldoutDoorPathNode extends Door
	placeable;

function MoverOpened()
{
	bBlocked = false;
	bDoorOpen = true;
}

function MoverClosed()
{
	bBlocked = true;
	bDoorOpen = false;
}

defaultproperties
{
	bInitiallyClosed = true
	bBlockedWhenClosed = true
	bBlockable = true
}