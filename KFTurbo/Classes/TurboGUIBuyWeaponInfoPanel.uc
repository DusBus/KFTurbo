class TurboGUIBuyWeaponInfoPanel extends SRGUIBuyWeaponInfoPanel;

function Display(GUIBuyable NewBuyable)
{
	local TurboGUIBuyable KFPBuyable;
	local class<KFWeaponPickup> PickupClass;
	
	Super.Display(NewBuyable);

	KFPBuyable = TurboGUIBuyable(NewBuyable);

	if (KFPBuyable == None)
	{
		return;
	}

	PickupClass = class<KFWeaponPickup>(KFPBuyable.GetPickup());

	ItemName.Caption = PickupClass.default.ItemName;
	ItemImage.Image = class<KFWeapon>(PickupClass.default.InventoryType).default.TraderInfoTexture;
}

defaultproperties
{
}
