class HoldoutPurchaseRoomTrigger extends HoldoutPurchaseTrigger
	placeable;

var HoldoutRoomManager RoomManager;
var bool bDisabled;

replication
{
	reliable if (bNetDirty && Role == ROLE_Authority)
		bDisabled, RoomManager;
}

//Attempt to associate this with a manager in case it fails to do so from the manager side.
simulated function PostNetBeginPlay()
{
	local HoldoutRoomManager Manager;
	if (RoomManager == None)
	{
		foreach AllActors(class'HoldoutRoomManager', Manager)
		{
			if (Manager.PurchaseTriggerTag == Tag)
			{
				RegisterManager(Manager);
				break;
			}
		}
	}
}

simulated function PostNetReceive()
{
	Super.PostNetReceive();

	if (bDisabled)
	{
		SetCollision(false, false, false);
		Disable('Touch');
	}
}

simulated function Object GetBroadcastMessageOptionalObject()
{
	return RoomManager;
}

simulated function int GetPurchasePrice()
{
	return RoomManager.GetPurchasePrice();
}

simulated function RegisterManager(HoldoutRoomManager Manager)
{
	RoomManager = Manager;
}

simulated function BroadcastMessage(PlayerController PlayerController)
{
	if (bDisabled)
	{
		return;
	}

	Super.BroadcastMessage(PlayerController);
}

function PerformPurchase(Pawn EventInstigator)
{
	if (bDisabled)
	{
		return;
	}

	if (EventInstigator != None && RoomManager != None)
	{
		if (RoomManager.PurchaseRoom(EventInstigator))
		{
			Super.PerformPurchase(EventInstigator);
		}
	}
}

function OnPurchase()
{
	bDisabled = true;
	NetUpdateTime = FMax(0.1f, Level.TimeSeconds - (1.f / NetUpdateFrequency));

	PostNetReceive();
}

defaultproperties
{
	bNetNotify=true
	NetUpdateFrequency=0.100000

	PurchaseMessageClass=class'KFTurboHoldout.PurchaseRoomMessage'
	
	Texture=Texture'Engine.SubActionTrigger'
	PurchaseSound=Sound'Steamland_SND.SlotMachine_Win'
}
