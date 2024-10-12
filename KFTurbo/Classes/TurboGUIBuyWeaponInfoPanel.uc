class TurboGUIBuyWeaponInfoPanel extends SRGUIBuyWeaponInfoPanel;

function Display(GUIBuyable NewBuyable)
{
	local TurboGUIBuyable TurboBuyable;
	local class<KFWeaponPickup> PickupClass;
	
	Super.Display(NewBuyable);

	TurboBuyable = TurboGUIBuyable(NewBuyable);

	if (TurboBuyable == None)
	{
		return;
	}

	PickupClass = class<KFWeaponPickup>(TurboBuyable.GetPickup());

	if (PickupClass == None)
	{
		return;
	}

	ItemName.Caption = PickupClass.default.ItemName;
	ItemImage.Image = class<KFWeapon>(PickupClass.default.InventoryType).default.TraderInfoTexture;
}

defaultproperties
{
}
