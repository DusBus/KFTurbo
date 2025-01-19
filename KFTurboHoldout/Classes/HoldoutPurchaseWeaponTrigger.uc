class HoldoutPurchaseWeaponTrigger extends HoldoutPurchaseTrigger
	placeable;

var(Purchase) class<KFWeaponPickup> WeaponPickupClass;
var(Purchase) int WeaponPrice;

simulated function Object GetBroadcastMessageOptionalObject()
{
	return WeaponPickupClass;
}

simulated function int GetPurchasePrice()
{
	return WeaponPrice;
}

simulated function Touch(Actor Other)
{
	if (Pawn(Other) == None || HasWeapon(Pawn(Other)))
	{
		return;
	}

	Super.Touch(Other);
}

function PerformPurchase(Pawn EventInstigator)
{
	local class<Inventory> WeaponClass;
	local Inventory NewInventory;
	local KFWeapon NewWeapon;
	if (EventInstigator == None || WeaponPickupClass == None)
	{
		return;
	}

	if (EventInstigator.PlayerReplicationInfo.Score < WeaponPrice)
	{
		return;
	}

	if (HasWeapon(EventInstigator))
	{
		return;
	}

	WeaponClass = WeaponPickupClass.default.InventoryType;


	NewInventory = Spawn(WeaponClass);
	NewWeapon = KFWeapon(NewInventory);

	if (NewInventory == None)
	{
		return;
	}

	if (NewWeapon == None)
	{
		NewInventory.Destroy();
		return;
	}

	if (KFGameType(Level.Game) != None)
	{
		KFGameType(Level.Game).WeaponSpawned(NewInventory);
	}

	NewWeapon.UpdateMagCapacity(EventInstigator.PlayerReplicationInfo);
	NewWeapon.FillToInitialAmmo();
	NewWeapon.SellValue = 0;
		
	NewWeapon.GiveTo(EventInstigator);
	EventInstigator.PlayerReplicationInfo.Score -= WeaponPrice;

	if (KFPawn(EventInstigator) != None)
	{
		KFPawn(EventInstigator).ClientForceChangeWeapon(NewInventory);
	}

	Super.PerformPurchase(EventInstigator);
}

simulated function Timer()
{
	if (TargetPawn == None || HasWeapon(TargetPawn))
	{
		return;
	}

	Super.Timer();
}

simulated function bool HasWeapon(Pawn Pawn)
{
	local Inventory Inv;
	local class<Inventory> WeaponClass;

	Inv = Pawn.Inventory;
	WeaponClass = WeaponPickupClass.default.InventoryType;
	
	while (Inv != None)
	{
		if (Inv.IsA(WeaponClass.Name))
		{
			return true;
		}

		Inv = Inv.Inventory;
	}

	return false;
}

defaultproperties
{
	WeaponPrice=100
	PurchaseMessageClass=class'KFTurboHoldout.PurchaseWeaponMessage'
	Texture=Texture'Engine.S_Weapon'
}
