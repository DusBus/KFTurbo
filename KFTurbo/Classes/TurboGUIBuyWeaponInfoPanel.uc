class TurboGUIBuyWeaponInfoPanel extends SRGUIBuyWeaponInfoPanel;

function Display(GUIBuyable NewBuyable)
{
	local TurboGUIBuyable TurboBuyable;
	local class<KFWeaponPickup> PickupClass;
	
	Super.Display(NewBuyable);

	if (NewBuyable == None)
	{
		return;
	}

	TurboBuyable = TurboGUIBuyable(NewBuyable);

	if (TurboBuyable != None)
	{
		PickupClass = class<KFWeaponPickup>(TurboBuyable.GetPickup());
	}
	else
	{
		PickupClass = NewBuyable.ItemPickupClass;
	}

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
