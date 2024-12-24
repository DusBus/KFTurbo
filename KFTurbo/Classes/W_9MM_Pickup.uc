class W_9MM_Pickup extends SinglePickup;

function Inventory SpawnCopy(Pawn Other)
{
	class'WeaponHelper'.static.SingleWeaponSpawnCopy(Self, Other, class'W_Dual9MM_Weap');
	return Super(KFWeaponPickup).SpawnCopy(Other);
}

defaultproperties
{
     InventoryType=class'KFTurbo.W_9MM_Weap'
}