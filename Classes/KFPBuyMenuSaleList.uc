//A rewrite to change how buying custom skins works.
class KFPBuyMenuSaleList extends SRBuyMenuSaleList
	config(KFProTrader); //uses config to persist user selection.

var	Texture	ButtonTexture;
var	Texture	ButtonHoverTexture;
var	Texture	ButtonDisabledTexture;

var	Texture	NoSkinTexture;
var	Texture	GoldSkinTexture;
var	Texture	StickerSkinTexture;
var	Texture CamoSkinTexture;
var Texture LockedDLCTexture;

var ClientPerkRepLink ClientPerkRepLink;	
var KFPRepLink KFPRepLink;

var String KFTurboBuyMenuSettingsClassString;
var KFTurboBuyMenuSettings BuyMenuSettings;

struct HoverCacheInfo
{
	var int LastKnownMouseOverIndex;
	var int LastKnownMouseOverSubIndex;
};
var HoverCacheInfo HoverCache;

var int MouseOverSubIndex;

//Used soley to be compliant with how DrawInvItem is implemented.
struct VariantListContainer
{
	var array<KFTurboRepLinkSettings.VariantWeapon> VariantList;
	var int Selection;
};
var array<VariantListContainer> VariantClasses;

struct StoredVariantSelection
{
	var class<KFWeapon> WeaponClass;
	var int Selection;
};
var config array<StoredVariantSelection> VariantSelection;

struct ButtonExtent
{
	var bool bLocked;
	var float ButtonLocation[2];
	var float ButtonSize[2];
};

var array<ButtonExtent> ItemButtonList;

function ClientPerkRepLink GetClientPerkRepLink()
{
	if (ClientPerkRepLink == none)
	{
		ClientPerkRepLink = Class'ClientPerkRepLink'.Static.FindStats(PlayerOwner());
	}

	return ClientPerkRepLink;
}

function KFPRepLink GetKFPRepLink()
{
	if (KFPRepLink == none)
	{
		KFPRepLink = class'KFPRepLink'.static.GetKFPRepLink(PlayerOwner().PlayerReplicationInfo);
	}

	return KFPRepLink;
}

event Opened(GUIComponent Sender)
{
	local class<KFTurboBuyMenuSettings> BuyMenuSettingsClass;
	if (BuyMenuSettings == none)
	{
		BuyMenuSettingsClass = class<KFTurboBuyMenuSettings>(DynamicLoadObject(KFTurboBuyMenuSettingsClassString, class'Class'));

		if (BuyMenuSettingsClass == none)
		{
			BuyMenuSettingsClass = class'KFTurboBuyMenuSettings';
		}

		BuyMenuSettings = new(self) BuyMenuSettingsClass;
	}
	
	if (ClientPerkRepLink == None)
	{
		ClientPerkRepLink = Class'ClientPerkRepLink'.Static.FindStats(PlayerOwner());
	}
	
	if (KFPRepLink == None)
	{
		KFPRepLink = class'KFPRepLink'.static.GetKFPRepLink(PlayerOwner().PlayerReplicationInfo);
	}
	
	Super.Opened(Sender);

	OpenCurrentPerkCategory();
}

simulated function OpenCurrentPerkCategory()
{
	local int ShopCategoryIndex;
	local class<KFVeterancyTypes> PlayerPerk;

    if ( KFPlayerController(PlayerOwner()) != none && KFPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo).ClientVeteranSkill != none )
    {
        PlayerPerk = KFPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo).ClientVeteranSkill;
    }
    else
    {
        PlayerPerk = class'V_Sharpshooter';
    }

	for (ShopCategoryIndex = ClientPerkRepLink.ShopCategories.Length - 1; ShopCategoryIndex >= 0; ShopCategoryIndex--)
	{
		if (ClientPerkRepLink.ShopCategories[ShopCategoryIndex].PerkIndex == PlayerPerk.Default.PerkIndex)
		{
			break;
		}
	}
	
	SetCategoryNum(ShopCategoryIndex, true);
}

event Closed(GUIComponent Sender, bool bCancelled)
{
	SaveConfig();
	Super.Closed(Sender, bCancelled);
}

function StoreVariantSelection(class<KFWeapon> WeaponClass, int Selection)
{
	local int i;

	for (i = 0; i < VariantSelection.Length; i++)
	{
		if (VariantSelection[i].WeaponClass == WeaponClass)
		{
			VariantSelection[i].Selection = Selection;
			return;
		}
	}

	VariantSelection.Length = VariantSelection.Length + 1;
	VariantSelection[VariantSelection.Length - 1].WeaponClass = WeaponClass;
	VariantSelection[VariantSelection.Length - 1].Selection = Selection;
}

function int GetVariantSelection(class<KFWeapon> WeaponClass)
{
	local int i;

	for (i = 0; i < VariantSelection.Length; i++)
	{
		if (VariantSelection[i].WeaponClass == WeaponClass)
		{
			return VariantSelection[i].Selection;
		}
	}

	return -1;
}

function bool InternalOnClick(GUIComponent Sender)
{
	if (!Super.InternalOnClick(Sender))
	{
		return false;
	}
	
	UpdateSelectedAlternateSkin(Sender);

	return false;
}

function UpdateSelectedAlternateSkin(GUIComponent Sender)
{
	local KFPGUIBuyable Buyable;
	local int ButtonIndex;

	Buyable = KFPGUIBuyable(GetSelectedBuyable());

	if (MouseOverIndex != Index)
	{
		return;
	}

	if (MouseOverIndex == -1 || MouseOverIndex >= CanBuys.Length)
	{
		return;
	}

	if (CanBuys[MouseOverIndex] < 1)
	{
		return;
	}

	if (!HasAlternateSkin(Buyable))
	{
		if (Buyable != None)
		{
			Buyable.VariantSelection = -1;
		}
		return;
	}

	ButtonIndex = GetButtonIndex(Buyable);

	if (ButtonIndex != -1)
	{
		Buyable.VariantSelection = ButtonIndex;
	}

	StoreVariantSelection(Buyable.ItemWeaponClass, Buyable.VariantSelection);
	UpdateList();

	if (bNotify)
	{
		OnChange(Sender);
	}
}

function int GetButtonIndex(optional KFPGUIBuyable Buyable)
{
	local int i;
	local float X, Y;

	for (i = 0; i < ItemButtonList.Length; i++)
	{
		X = ItemButtonList[i].ButtonLocation[0];
		Y = ItemButtonList[i].ButtonLocation[1];

		if (Controller.MouseX < X || Controller.MouseX > X + ItemButtonList[i].ButtonSize[0])
		{
			continue;
		}

		if (Controller.MouseY < Y || Controller.MouseY > Y + ItemButtonList[i].ButtonSize[1])
		{
			continue;
		}

		if (ItemButtonList[i].bLocked)
		{
			PlayerOwner().SteamStatsAndAchievements.PurchaseWeaponDLC(class<KFWeapon>(Buyable.VariantList[i].VariantClass.default.InventoryType).default.AppID);
			return -1;
		}

		return i;
	}

	return -1;
}

static function bool HasAlternateSkin(KFPGUIBuyable Buyable)
{
	if (Buyable == None || Buyable.VariantList.Length == 0)
	{
		return false;
	}

	return true;
}

static function VariantListContainer GetAlternateSkins(KFPGUIBuyable Buyable)
{
	local VariantListContainer VariantContainer;

	if (Buyable == None)
	{
		VariantContainer.VariantList.Length = 0;
		VariantContainer.Selection = -1;
		return VariantContainer;
	}

	VariantContainer.VariantList = Buyable.VariantList;
	VariantContainer.Selection = Buyable.VariantSelection;

	return VariantContainer;
}

function bool PreDraw(Canvas Canvas)
{
	local bool bReturn;
	local bool bUpdateHint;
	bReturn = Super.PreDraw(Canvas);

	bUpdateHint = HoverCache.LastKnownMouseOverIndex != MouseOverIndex || HoverCache.LastKnownMouseOverSubIndex != MouseOverSubIndex;

	if (bUpdateHint)
	{
		if (MouseOverIndex == -1 || MouseOverSubIndex == -1 || MouseOverIndex >= CanBuys.Length || CanBuys[MouseOverIndex] < 1)
		{
			SetHint("");
		}
		else
		{
			if (VariantClasses[MouseOverIndex].VariantList.Length > MouseOverSubIndex)
			{
				SetHint(BuyMenuSettings.GetHintForPickup(VariantClasses[MouseOverIndex].VariantList[MouseOverSubIndex].VariantID));
			}
			else
			{
				SetHint("");
			}
		}

		HoverCache.LastKnownMouseOverIndex = MouseOverIndex;
		HoverCache.LastKnownMouseOverSubIndex = MouseOverSubIndex;
	}

	return bReturn;
}

function DrawInvItem(Canvas Canvas, int CurIndex, float X, float Y, float Width, float Height, bool bSelected, bool bPending)
{
	Super.DrawInvItem(Canvas, CurIndex, X, Y, Width, Height, bSelected, bPending);

	if (CanBuys[CurIndex] < 2 && VariantClasses[CurIndex].VariantList.Length != 0)
	{
		DrawAlternateSkinButtons(Canvas, CurIndex, X, Y, Width, Height, bSelected, bPending);
	}

	Canvas.SetDrawColor(255, 255, 255, 255);
}

function DrawAlternateSkinButtons(Canvas Canvas, int CurIndex, float X, float Y, float Width, float Height, bool bSelected, bool bPending)
{
	local float TextX, TextY;
	local float ButtonSize;
	local int i;
	local float TempX, TempY;
	local bool bHovered, bSubButtonHovered;
	local ButtonExtent ItemButton;
	local Texture VariantIconTexture;

	//Update bounds data to what's relevant to use.
	//Handle perk icon space
	X += ((Height - ItemSpacing) - 1);
	Width -= ((Height - ItemSpacing) - 1);

	//Handle text spacer
	X += (0.2 * Height);
	Width -= (0.2 * Height);

	Canvas.TextSize(PrimaryStrings[CurIndex], TextX, TextY);

	//Handle item name text
	X += TextX;
	Width -= TextX;

	Canvas.TextSize(SecondaryStrings[CurIndex], TextX, TextY);

	//Handle item price text
	Width -= (0.2 * Height);
	Width -= TextX;

	//Allow for further spacing
	X += (0.2 * Height);
	Width -= (0.4 * Height);

	Height -= 12.f;
	Y += 6.f;

	ButtonSize = FMin(Width / VariantClasses[CurIndex].VariantList.Length, Height * 0.7) - 0.05f;

	TempX = X + Width;
	TempY = Y + (Height * 0.5f) - (ButtonSize * 0.5f);

	Canvas.SetDrawColor(255, 255, 255, 255);

	//Prepare for extent tests on sub buttons
	if (CurIndex == MouseOverIndex)
	{
		bHovered = true;
		ItemButton.ButtonSize[0] = ButtonSize;
		ItemButton.ButtonSize[1] = ButtonSize;
		ItemButtonList.Length = 0;
		MouseOverSubIndex = -1;
	}

	for (i = 0; i < VariantClasses[CurIndex].VariantList.Length; i++)
	{
		TempX -= ButtonSize;
		Canvas.SetPos(TempX, TempY);
		bSubButtonHovered = false;

		if (bHovered)
		{
			ItemButton.bLocked = VariantClasses[CurIndex].VariantList[i].ItemStatus != 0;
			ItemButton.ButtonLocation[0] = TempX;
			ItemButton.ButtonLocation[1] = TempY;

			ItemButtonList[ItemButtonList.Length] = ItemButton;

			if (IsSkinButtonHovered(ItemButton, Controller.MouseX, Controller.MouseY))
			{
				bSubButtonHovered = true;
				MouseOverSubIndex = i;
			}
		}
		
		if (CanBuys[CurIndex] != 1)
		{
			Canvas.SetDrawColor(50, 50, 50, 150);
			Canvas.DrawTileStretched(ButtonDisabledTexture, ButtonSize, ButtonSize);
			Canvas.SetDrawColor(200, 200, 200, 100);
		}
		else if (VariantClasses[CurIndex].VariantList[i].ItemStatus != 0)
		{
			Canvas.DrawTileStretched(ButtonDisabledTexture, ButtonSize, ButtonSize);
			Canvas.SetDrawColor(200, 200, 200, 100);
		}
		else if ((i == 0 && VariantClasses[CurIndex].Selection == -1) || i == VariantClasses[CurIndex].Selection) //If we don't have a selection, highlight the default.
		{
			Canvas.DrawTileStretched(ButtonTexture, ButtonSize, ButtonSize);
		}
		else if (bHovered && bSubButtonHovered)
		{
			Canvas.DrawTileStretched(ButtonHoverTexture, ButtonSize, ButtonSize);
		}
		else
		{
			Canvas.DrawTileStretched(ButtonDisabledTexture, ButtonSize, ButtonSize);
		}

		if (CanBuys[CurIndex] == 1)
		{
			Canvas.SetDrawColor(255, 255, 255, 255);
		}

		VariantIconTexture = BuyMenuSettings.GetIconForPickup(VariantClasses[CurIndex].VariantList[i].VariantID);

		if (VariantIconTexture != None)
		{
			Canvas.DrawRect(VariantIconTexture, ButtonSize, ButtonSize);
		}

		if (VariantClasses[CurIndex].VariantList[i].ItemStatus != 0)
		{
			Canvas.SetPos(TempX, TempY);
			Canvas.DrawRect(LockedDLCTexture, ButtonSize, ButtonSize);
		}

		TempX -= 2.f;
	}
}

static final function bool IsSkinButtonHovered(out ButtonExtent Button, float MouseX, float MouseY)
{
	if (Button.ButtonLocation[0] > MouseX || Button.ButtonLocation[0] + Button.ButtonSize[0] < MouseX)
	{
		return false;
	}

	if (Button.ButtonLocation[1] > MouseY || Button.ButtonLocation[1] + Button.ButtonSize[1] < MouseY)
	{
		return false;
	}

	return true;
}

//MODIFICATION TO GUIBUYABLE
//We have to completely copy paste the following functions to make minute changes...
final function KFPGUIBuyable AllocateKFPEntry(ClientPerkRepLink L)
{
	local KFPGUIBuyable NewBuyable;
	local int i;

	//Since potentially not all of these are the type we're looking for...
	for (i = 0; i < L.AllocatedObjects.Length; i++)
	{
		NewBuyable = KFPGUIBuyable(L.AllocatedObjects[i]);

		if (NewBuyable != None)
		{
			L.AllocatedObjects.Remove(i, 1);
			break;
		}
	}

	if (NewBuyable == None)
	{
		return new Class'KFPGUIBuyable';
	}

	L.ResetItem(NewBuyable);

	NewBuyable.VariantList.Length = 0;
	NewBuyable.VariantSelection = -1;
	
	return NewBuyable;
}

function UpdateForSaleBuyables()
{
	local class<KFVeterancyTypes> PlayerVeterancy;
	local KFPlayerReplicationInfo KFPRI;
	local ClientPerkRepLink CPRL;
	local KFPRepLink KFPL;
	local KFPGUIBuyable ForSaleBuyable;
	local class<KFWeaponPickup> ForSalePickup;
	local int j, DualDivider, i, Num, z, PerkSaleOffset;
	local class<KFWeapon> ForSaleWeapon, SecType;
	local class<SRVeterancyTypes> Blocker;
	local KFShopVolume_Story CurrentShop;
	local byte DLCLocked;

	// Clear the ForSaleBuyables array
	CopyAllBuyables();
	ForSaleBuyables.Length = 0;

	// Grab the items for sale
	CPRL = GetClientPerkRepLink();
	if (CPRL == None)
		return; // Hmmmm?

	KFPL = GetKFPRepLink();

	KFPRI = KFPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo);

	// Grab Players Veterancy for quick reference
	if (KFPRI != none)
	{
		PlayerVeterancy = KFPRI.ClientVeteranSkill;
	}

	if (PlayerVeterancy == None)
	{
		PlayerVeterancy = class'KFVeterancyTypes';
	}

	CurrentShop = GetCurrentShop();

	DebugFavouriteList();
	// Grab the weapons!
	if (ActiveCategory >= -1)
	{
		if (CurrentShop != None)
			Num = CurrentShop.SaleItems.Length;
		else Num = CPRL.ShopInventory.Length;
		for (z = 0; z < Num; z++)
		{
			if (CurrentShop != None)
			{
				// Allow story mode volume limit weapon availability.
				ForSalePickup = class<KFWeaponPickup>(CurrentShop.SaleItems[z]);
				if (ForSalePickup == None)
					continue;
				for (j = (CPRL.ShopInventory.Length - 1); j >= CPRL.ShopInventory.Length; --j)
					if (CPRL.ShopInventory[j].PC == ForSalePickup)
						break;
				if (j < 0)
					continue;
			}
			else
			{
				ForSalePickup = class<KFWeaponPickup>(CPRL.ShopInventory[z].PC);
				j = z;
			}

			if (ForSalePickup == None || class<KFWeapon>(ForSalePickup.default.InventoryType) == None || class<KFWeapon>(ForSalePickup.default.InventoryType).default.bKFNeverThrow
				|| IsInInventory(ForSalePickup))
			{
				continue;
			}

			if (ActiveCategory == -1)
			{
				if (!Class'SRClientSettings'.Static.IsFavorite(ForSalePickup))
				{
					continue;
				}
				log("- Favourite");
			}
			else if (ActiveCategory != CPRL.ShopInventory[j].CatNum)
			{
				continue;
			}

			// Remove single weld.
			ForSaleWeapon = class<KFWeapon>(ForSalePickup.default.InventoryType);

			if (class'DualWeaponsManager'.Static.HasDualies(ForSaleWeapon, PlayerOwner().Pawn.Inventory) || (ForSalePickup.Default.VariantClasses.Length > 0 && CheckGoldGunAvailable(ForSalePickup)))
			{
				continue;
			}
			else if (ForSalePickup.default.VariantClasses.Length > 0) //We need to check if ANY of the variants of this weapon in their dual forms is being held
			{
				Blocker = None;
				for (i = 0; i < ForSalePickup.default.VariantClasses.Length; i++)
				{
					ForSaleWeapon = class<KFWeapon>(ForSalePickup.default.VariantClasses[i].default.InventoryType);

					if (class'DualWeaponsManager'.Static.HasDualies(ForSaleWeapon, PlayerOwner().Pawn.Inventory) || (ForSalePickup.Default.VariantClasses.Length > 0 && CheckGoldGunAvailable(ForSalePickup)))
					{
						Blocker = class'SRVeterancyTypes'; //set it to not null for tracking purposes
						break;
					}
				}

				if (Blocker != None)
				{
					continue;
				}

				ForSaleWeapon = class<KFWeapon>(ForSalePickup.default.InventoryType);
			}

			DualDivider = 1;

			// Make cheaper.
			if (ForSaleWeapon != class'Dualies' && class'DualWeaponsManager'.Static.IsDualWeapon(ForSaleWeapon, SecType) && IsInInventoryWep(SecType))
			{
				DualDivider = 2;
			}
			else if (ForSalePickup.default.VariantClasses.Length > 0) //We need to check if ANY of the variants of this weapon in their single form is being held
			{
				for (i = 0; i < ForSalePickup.default.VariantClasses.Length; i++)
				{
					ForSaleWeapon = class<KFWeapon>(ForSalePickup.default.VariantClasses[i].default.InventoryType);

					if (ForSaleWeapon != class'Dualies' && class'DualWeaponsManager'.Static.IsDualWeapon(ForSaleWeapon, SecType) && IsInInventoryWep(SecType))
					{
						DualDivider = 2;
						break;
					}
				}

				ForSaleWeapon = class<KFWeapon>(ForSalePickup.default.InventoryType);
			}

			Blocker = None;
			for (i = 0; i < CPRL.CachePerks.Length; ++i)
				if (!CPRL.CachePerks[i].PerkClass.Static.AllowWeaponInTrader(ForSalePickup, KFPRI, CPRL.CachePerks[i].CurrentLevel))
				{
					Blocker = CPRL.CachePerks[i].PerkClass;
					break;
				}
			if (Blocker != None && Blocker.Default.DisableTag == "")
				continue;

			ForSaleBuyable = AllocateKFPEntry(CPRL);

			ForSaleBuyable.ItemName = ForSalePickup.default.ItemName;
			ForSaleBuyable.ItemDescription = ForSalePickup.default.Description;
			ForSaleBuyable.ItemImage = ForSaleWeapon.default.TraderInfoTexture;
			ForSaleBuyable.ItemWeaponClass = ForSaleWeapon;
			ForSaleBuyable.ItemAmmoClass = ForSaleWeapon.default.FireModeClass[0].default.AmmoClass;
			ForSaleBuyable.ItemPickupClass = ForSalePickup;
			ForSaleBuyable.ItemCost = int((float(ForSalePickup.default.Cost)
				* PlayerVeterancy.static.GetCostScaling(KFPRI, ForSalePickup)) / DualDivider);
			ForSaleBuyable.ItemAmmoCost = 0;
			ForSaleBuyable.ItemFillAmmoCost = 0;

			if (KFPL != None)
			{
				KFPL.GetVariantsForWeapon(ForSalePickup, ForSaleBuyable.VariantList);
			}
			else
			{
				ForSaleBuyable.VariantList.Length = 0;
			}

			ForSaleBuyable.VariantSelection = Clamp(GetVariantSelection(ForSaleWeapon), 0, ForSaleBuyable.VariantList.Length - 1);

			ForSaleBuyable.ItemWeight = ForSaleWeapon.default.Weight;
			if (DualDivider == 2)
				ForSaleBuyable.ItemWeight -= SecType.Default.Weight;

			ForSaleBuyable.ItemPower = ForSalePickup.default.PowerValue;
			ForSaleBuyable.ItemRange = ForSalePickup.default.RangeValue;
			ForSaleBuyable.ItemSpeed = ForSalePickup.default.SpeedValue;
			ForSaleBuyable.ItemAmmoMax = 0;
			ForSaleBuyable.ItemPerkIndex = ForSalePickup.default.CorrespondingPerkIndex;

			// Make sure we mark the list as a sale list
			ForSaleBuyable.bSaleList = true;

			// Sort same perk weapons in front.
			if (ForSalePickup.default.CorrespondingPerkIndex == PlayerVeterancy.default.PerkIndex)
			{
				ForSaleBuyables.Insert(PerkSaleOffset, 1);
				i = PerkSaleOffset++;
			}
			else
			{
				i = ForSaleBuyables.Length;
				ForSaleBuyables.Length = i + 1;
			}
			ForSaleBuyables[i] = ForSaleBuyable;
			DLCLocked = CPRL.ShopInventory[j].bDLCLocked;
			if (DLCLocked == 0 && Blocker != None)
			{
				ForSaleBuyable.ItemCategorie = Blocker.Default.DisableTag$":"$Blocker.Default.DisableDescription;
				DLCLocked = 3;
			}
			ForSaleBuyable.ItemAmmoCurrent = DLCLocked; // DLC info.
		}
	}

	// Now Update the list
	UpdateList();
}


simulated function DebugFavouriteList()
{
	local SRClientSettings ClientSettings;
	local int FavIndex;
	local string FavString;

	ClientSettings = Class'SRClientSettings'.Static.GetSettings();
	FavString = "- |";

	for (FavIndex = 0; FavIndex < ClientSettings.Fav.Length; FavIndex++)
	{
		FavString = FavString @ ClientSettings.Fav[FavIndex] @ "|";
	}

	log(FavString);
}

function UpdateList()
{
	local int i, j;
	local ClientPerkRepLink CPRL;

	CPRL = GetClientPerkRepLink();

	// Update the ItemCount and select the first item
	ItemCount = CPRL.ShopCategories.Length + ForSaleBuyables.Length + 1;

	// Clear the arrays
	if (ForSaleBuyables.Length < PrimaryStrings.Length)
	{
		PrimaryStrings.Length = ItemCount;
		SecondaryStrings.Length = ItemCount;
		CanBuys.Length = ItemCount;
		ListPerkIcons.Length = ItemCount;
		VariantClasses.Length = ItemCount;
	}

	// Update categories
	if (ActiveCategory >= -1)
	{
		for (i = -1; i < (ActiveCategory + 1); ++i)
		{
			if (i == -1)
			{
				PrimaryStrings[j] = FavoriteGroupName;
				ListPerkIcons[j] = None;
			}
			else
			{
				PrimaryStrings[j] = CPRL.ShopCategories[i].Name;
				if (CPRL.ShopCategories[i].PerkIndex < CPRL.ShopPerkIcons.Length)
					ListPerkIcons[j] = CPRL.ShopPerkIcons[CPRL.ShopCategories[i].PerkIndex];
				else ListPerkIcons[j] = None;
			}
			CanBuys[j] = 3 + i;
			++j;
		}
	}
	else
	{
		PrimaryStrings[j] = FavoriteGroupName;
		CanBuys[j] = 2;
		++j;
		for (i = 0; i < CPRL.ShopCategories.Length; ++i)
		{
			PrimaryStrings[j] = CPRL.ShopCategories[i].Name;
			if (CPRL.ShopCategories[i].PerkIndex < CPRL.ShopPerkIcons.Length)
				ListPerkIcons[j] = CPRL.ShopPerkIcons[CPRL.ShopCategories[i].PerkIndex];
			else ListPerkIcons[j] = None;
			CanBuys[j] = 3 + i;
			++j;
		}
	}

	// Update the players inventory list
	for (i = 0; i < ForSaleBuyables.Length; i++)
	{
		PrimaryStrings[j] = ForSaleBuyables[i].ItemName;
		SecondaryStrings[j] = "£" @ int(ForSaleBuyables[i].ItemCost);

		VariantClasses[j] = GetAlternateSkins(KFPGUIBuyable(ForSaleBuyables[i]));

		if (ForSaleBuyables[i].ItemPerkIndex < CPRL.ShopPerkIcons.Length)
			ListPerkIcons[j] = CPRL.ShopPerkIcons[ForSaleBuyables[i].ItemPerkIndex];
		else ListPerkIcons[j] = None;

		if (ForSaleBuyables[i].ItemAmmoCurrent != 0)
		{
			CanBuys[j] = 0;
			if (ForSaleBuyables[i].ItemAmmoCurrent == 1)
				SecondaryStrings[j] = "DLC";
			else if (ForSaleBuyables[i].ItemAmmoCurrent == 2)
				SecondaryStrings[j] = "LOCKED";
			else SecondaryStrings[j] = Left(ForSaleBuyables[i].ItemCategorie, InStr(ForSaleBuyables[i].ItemCategorie, ":"));
		}
		else if (ForSaleBuyables[i].ItemCost > PlayerOwner().PlayerReplicationInfo.Score ||
			ForSaleBuyables[i].ItemWeight + KFHumanPawn(PlayerOwner().Pawn).CurrentWeight > KFHumanPawn(PlayerOwner().Pawn).MaxCarryWeight)
		{
			CanBuys[j] = 0;
		}
		else
		{
			CanBuys[j] = 1;
		}
		++j;
	}

	if (ActiveCategory >= -1)
	{
		for (i = (ActiveCategory + 1); i < CPRL.ShopCategories.Length; ++i)
		{
			PrimaryStrings[j] = CPRL.ShopCategories[i].Name;
			if (CPRL.ShopCategories[i].PerkIndex < CPRL.ShopPerkIcons.Length)
				ListPerkIcons[j] = CPRL.ShopPerkIcons[CPRL.ShopCategories[i].PerkIndex];
			else ListPerkIcons[j] = None;
			CanBuys[j] = 3 + i;
			++j;
		}
	}

	if (bNotify)
	{
		CheckLinkedObjects(Self);
	}

	if (MyScrollBar != none)
	{
		MyScrollBar.AlignThumb();
	}

	bNeedsUpdate = false;
}

defaultproperties
{
	ButtonTexture=Texture'KF_InterfaceArt_tex.Menu.Button'
	ButtonHoverTexture=Texture'KF_InterfaceArt_tex.Menu.button_Highlight'
	ButtonDisabledTexture=Texture'KF_InterfaceArt_tex.Menu.button_Disabled'
	NoSkinTexture=Texture'KFTurbo.HUD.NoSkinIcon_D'
	GoldSkinTexture=Texture'KFTurbo.HUD.GoldIcon_D'
	StickerSkinTexture=Texture'KFTurbo.HUD.StickerIcon_D'
	CamoSkinTexture=Texture'KFTurbo.HUD.CamoIcon_D'
	LockedDLCTexture=Texture'KFTurbo.HUD.DLCLocked_D'
	HoverCache=(LastKnownMouseOverIndex=-1,LastKnownMouseOverSubIndex=-1)
	MouseOverSubIndex=-1
	Begin Object Class=GUIToolTip Name=GUIListVariantToolTip
		bTrackMouse=True
		bTrackInput=False
		InitialDelay=0.000000
		ExpirationSeconds=0.000000
	End Object
	ToolTip=GUIToolTip'KFTurbo.KFPBuyMenuSaleList.GUIListVariantToolTip'

	KFTurboBuyMenuSettingsClassString="KFTurbo.KFTurboBuyMenuSettings"
}
