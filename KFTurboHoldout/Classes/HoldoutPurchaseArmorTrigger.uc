class HoldoutPurchaseArmorTrigger extends HoldoutPurchaseTrigger
	placeable;

var(Purchase) int ArmorPrice;

replication
{
	reliable if (bNetDirty && Role == ROLE_Authority)
		ArmorPrice;
}

simulated function Object GetBroadcastMessageOptionalObject()
{
	return class'BuyableVest';
}

simulated function int GetPurchasePrice()
{
	return ArmorPrice;
}

simulated function Touch(Actor Other)
{
	if (Pawn(Other) == None || Pawn(Other).ShieldStrength >= 100.f)
	{
		return;
	}

	Super.Touch(Other);
}

function PerformPurchase(Pawn EventInstigator)
{
	if (EventInstigator == None)
	{
		return;
	}

	if (EventInstigator.PlayerReplicationInfo.Score < ArmorPrice)
	{
		return;
	}
	
	EventInstigator.PlayerReplicationInfo.Score -= ArmorPrice;

	PlayerController(EventInstigator.Controller).ClientPlaySound(Sound'KF_InventorySnd.Vest_Pickup');
	EventInstigator.ShieldStrength = 100.f;
	Super.PerformPurchase(EventInstigator);
}

simulated function Timer()
{
	if (TargetPawn == None || TargetPawn.ShieldStrength >= 100.f)
	{
		return;
	}

	Super.Timer();
}

defaultproperties
{
	ArmorPrice=100
	PurchaseMessageClass=class'KFTurboHoldout.PurchaseArmorMessage'
	PurchaseNotificationMessageClass=class'KFTurboHoldout.PurchaseArmorNotificationMessage'
	Texture=Texture'Engine.S_Pawn'
}
