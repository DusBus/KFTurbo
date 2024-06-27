class KFTurboRepLinkSettings extends Object;

//User and Group configuration.
var editinline array<KFTurboRepLinkSettingsUser> UserList;
var editinline array<KFTurboRepLinkSettingsGroup> GroupList;

//Mutator context.
var ServerPerksMut ServerPerksMut;
var KFTurboMut KFTurboMutator;

struct VariantWeapon
{
    var class<KFWeaponPickup> VariantClass;
    var String VariantID;
    var int ItemStatus;
};

struct WeaponVariantData
{
    var class<KFWeaponPickup> WeaponPickup;
    var array<VariantWeapon> VariantList;
};
var array<WeaponVariantData> VariantWeaponList;

// Built-in Variant Set Names:
//Common variants - accessible to all players.
const DefaultID = "DEF"; //All non-variants.
const GoldVariantID = "GOLD"; //Gold skins.
const CamoVariantID = "CAMO"; //Camo skins.
const TurboVariantID = "TURBO"; //KFTurbo sticker skins.
const VMVariantID = "VM"; //VM sticker skins.
const WLVariantID = "WEST"; //Westlondon sticker skins.

//Special variants - accessible to specific players.
const RetartVariantID = "RET";
const ScuddlesVariantID = "SCUD";
const CubicVariantID = "CUBIC";
const SMPVariantID = "SHOWME";


static final function DebugLog(string DebugString)
{
    log(DebugString, 'KFTurbo');
}

//For the given PlayerSteamID, provides back a list of all the Variant IDs they have access to.
function GetPlayerVariantIDList(String PlayerSteamID, out array<String> PlayerVariantIDList)
{
    local int PlayerIndex, GroupIDIndex;
    local int VariantIndex;
    local int GroupIndex;
    local KFTurboRepLinkSettingsUser UserObject;
    local KFTurboRepLinkSettingsGroup GroupObject;
    local array<String> UserGroupIDList;
    local bool bFoundGroupID;

    //DebugLog("| - | - GetPlayerVariantIDList");
    PlayerVariantIDList.Length = 0;

    for (PlayerIndex = 0; PlayerIndex < UserList.Length; PlayerIndex++)
    {
        if (UserList[PlayerIndex].PlayerSteamID != PlayerSteamID)
        {
            continue;
        }

        UserObject = UserList[PlayerIndex];
        PlayerVariantIDList = UserObject.VariantIDList;
        UserGroupIDList = UserObject.GroupIDList; //Cache group ID list.

        for (VariantIndex = 0; VariantIndex < PlayerVariantIDList.Length; VariantIndex++)
        {
            //DebugLog("| - | - | - (Adding user variant "$PlayerVariantIDList[VariantIndex]$")");
        }

        break;
    }

    for (GroupIndex = 0; GroupIndex < GroupList.Length; GroupIndex++)
    {
        GroupObject = GroupList[GroupIndex];

        if (!GroupObject.bDefaultGroup)
        {
            bFoundGroupID = false;

            for (GroupIDIndex = 0; GroupIDIndex < UserGroupIDList.Length; GroupIDIndex++)
            {
                if (GroupObject.GroupID == UserGroupIDList[GroupIDIndex])
                {
                    bFoundGroupID = true;
                    break;
                }
            }

            if (!bFoundGroupID)
            {
                continue;
            }
        }

        AppendPlayerVariantIDList(PlayerVariantIDList, GroupObject.VariantIDList);
    }
}

static final function AppendPlayerVariantIDList(out array<String> PlayerVariantIDList, array<String> NewVariantIDList)
{
    local int VariantIDIndex, PlayerVariantIDIndex;
    local bool bAlreadyInPlayerList;

    for (VariantIDIndex = NewVariantIDList.Length - 1; VariantIDIndex >= 0; VariantIDIndex--)
    {
        bAlreadyInPlayerList = false;
        for (PlayerVariantIDIndex = PlayerVariantIDList.Length - 1; PlayerVariantIDIndex >= 0; PlayerVariantIDIndex--)
        {
            if (NewVariantIDList[VariantIDIndex] == PlayerVariantIDList[PlayerVariantIDIndex])
            {
                bAlreadyInPlayerList = true;
                break;
            }
        }

        if (bAlreadyInPlayerList)
        {
            continue;
        }

        //DebugLog("| - | - | - (Adding group variant "$NewVariantIDList[VariantIDIndex]$")");
        PlayerVariantIDList[PlayerVariantIDList.Length] = NewVariantIDList[VariantIDIndex];
    }
}

function GeneratePlayerVariantData(String PlayerSteamID, out array<WeaponVariantData> PlayerVariantWeaponList)
{
    local array<String> PlayerVariantIDList;
    local int VariantWeaponListIndex;
    local int VariantIndex;
    local int PlayerVariantIDIndex;
    local class<KFWeaponPickup> WeaponPickup;
    local array<VariantWeapon> PlayerVariantList;

    StopWatch(false);

    GetPlayerVariantIDList(PlayerSteamID, PlayerVariantIDList);

    //DebugLog("Just called KFTurboRepLinkSettings::GetPlayerVariantIDList. Printing out variant ID access.");
    for (VariantWeaponListIndex = PlayerVariantIDList.Length - 1; VariantWeaponListIndex >= 0; VariantWeaponListIndex--)
    {
        //DebugLog("| - "$ PlayerVariantIDList[VariantWeaponListIndex]);
    }

    PlayerVariantWeaponList.Length = 0;

    for (VariantWeaponListIndex = VariantWeaponList.Length - 1; VariantWeaponListIndex >= 0; VariantWeaponListIndex--)
    {
        PlayerVariantList.Length = 0;

        WeaponPickup = VariantWeaponList[VariantWeaponListIndex].WeaponPickup;
    
        for (VariantIndex = VariantWeaponList[VariantWeaponListIndex].VariantList.Length - 1; VariantIndex >= 0; VariantIndex--)
        {
            for (PlayerVariantIDIndex = PlayerVariantIDList.Length - 1; PlayerVariantIDIndex >= 0; PlayerVariantIDIndex--)
            {
                if (VariantWeaponList[VariantWeaponListIndex].VariantList[VariantIndex].VariantID == PlayerVariantIDList[PlayerVariantIDIndex])
                {
                    PlayerVariantList.Insert(PlayerVariantList.Length, 1);
                    PlayerVariantList[PlayerVariantList.Length - 1] = VariantWeaponList[VariantWeaponListIndex].VariantList[VariantIndex];
                }
            }
        }

        PlayerVariantWeaponList.Insert(PlayerVariantWeaponList.Length, 1);
        PlayerVariantWeaponList[PlayerVariantWeaponList.Length - 1].WeaponPickup = WeaponPickup;
        PlayerVariantWeaponList[PlayerVariantWeaponList.Length - 1].VariantList = PlayerVariantList;
    }

    StopWatch(true);
    log("The above time is KFTurboRepLinkSettings::GeneratePlayerVariantData duration.", 'KFTurbo');
}

//Setup a cache of all variant weapons and their associated IDs. This will prevent needing to refigure out what variants are available each time a player joins.
function Initialize()
{
    local int LoadInventoryIndex, LoadInventoryVariantIndex;
    local int NewVariantIndex;
    local class<KFWeaponPickup> KFWeaponPickupClass, KFWeaponVariantPickupClass;
    local VariantWeapon VariantWeaponEntry;

    StopWatch(false);

    KFTurboMutator = KFTurboMut(Outer);

    foreach KFTurboMutator.Level.AllActors( class'ServerPerksMut', ServerPerksMut )
		break;

    for (LoadInventoryIndex = ServerPerksMut.LoadInventory.Length - 1;  LoadInventoryIndex >= 0; LoadInventoryIndex--)
    {
        KFWeaponPickupClass = class<KFWeaponPickup>(ServerPerksMut.LoadInventory[LoadInventoryIndex]);

        if (KFWeaponPickupClass == none || KFWeaponPickupClass.default.VariantClasses.Length == 0)
        {
            continue;
        }

        VariantWeaponList.Insert(VariantWeaponList.Length, 1);
        NewVariantIndex = VariantWeaponList.Length - 1;

        VariantWeaponList[NewVariantIndex].WeaponPickup = KFWeaponPickupClass;
        
        //DebugLog("KFTurboRepLinkSettings::Initialize | Generating cache for: "$KFWeaponPickupClass$" (Has "$KFWeaponPickupClass.default.VariantClasses.Length$" variants.)");

        for (LoadInventoryVariantIndex = KFWeaponPickupClass.default.VariantClasses.Length - 1; LoadInventoryVariantIndex >= 0; LoadInventoryVariantIndex--)
        {
            KFWeaponVariantPickupClass = class<KFWeaponPickup>(KFWeaponPickupClass.default.VariantClasses[LoadInventoryVariantIndex]);

            //DebugLog("KFTurboRepLinkSettings::Initialize | |- Trying variant "$KFWeaponVariantPickupClass);

            if (KFWeaponVariantPickupClass == none)
            {
                continue;
            }

            if (KFWeaponVariantPickupClass == KFWeaponPickupClass)
            {
                VariantWeaponEntry.VariantClass = KFWeaponVariantPickupClass;
                VariantWeaponEntry.VariantID = DefaultID;
                VariantWeaponEntry.ItemStatus = 0; //Don't bother?
                VariantWeaponList[NewVariantIndex].VariantList[VariantWeaponList[NewVariantIndex].VariantList.Length] = VariantWeaponEntry;
                continue;
            }
            else
            {
                VariantWeaponEntry.VariantClass = KFWeaponVariantPickupClass;
                SetupVariantWeaponEntry(VariantWeaponEntry);
                VariantWeaponList[NewVariantIndex].VariantList[VariantWeaponList[NewVariantIndex].VariantList.Length] = VariantWeaponEntry;
            }

            //DebugLog("KFTurboRepLinkSettings::Initialize | | |- Result: VariantID "$VariantWeaponEntry.VariantID$" | Status "$VariantWeaponEntry.ItemStatus);
        }
    }

    StopWatch(true);
    log("The above time is KFTurboRepLinkSettings::Initialize duration.", 'KFTurbo');
}

function SetupVariantWeaponEntry(out VariantWeapon Entry)
{
    Entry.VariantID = "";

    if (AssignSpecialVariantID(Entry))
    {
        return;
    }

    if (IsGenericGoldSkin(Entry.VariantClass))
    {
        Entry.VariantID = GoldVariantID;
        Entry.ItemStatus = 255; //Flag Gold weapons as awaiting DLC update.
    }
    else if (IsGenericCamoSkin(Entry.VariantClass))
    {
        Entry.VariantID = CamoVariantID;
        Entry.ItemStatus = 255; //Flag Camo weapons as awaiting DLC update.
    }
    else if (IsGenericTurboSkin(Entry.VariantClass))
    {
        Entry.VariantID = TurboVariantID;
        Entry.ItemStatus = 0;
    }
    else if (IsGenericVMSkin(Entry.VariantClass))
    {
        Entry.VariantID = VMVariantID;
        Entry.ItemStatus = 0;
    }
    else if (IsGenericWestLondonSkin(Entry.VariantClass))
    {
        Entry.VariantID = WLVariantID;
        Entry.ItemStatus = 0;
    }
}

function bool AssignSpecialVariantID(out VariantWeapon Entry)
{
    switch (Entry.VariantClass)
    {
        case class'W_V_M4203_Retart_Pickup' :
            Entry.VariantID = RetartVariantID;
            break;
        case class'W_V_M4203_Scuddles_Pickup' :
            Entry.VariantID = ScuddlesVariantID;
            break;
        case class'W_V_M14_Cubic_Pickup' :
            Entry.VariantID = CubicVariantID;
            break;
        case class'W_V_M14_SMP_Pickup' :
        case class'W_V_AA12_SMP_Pickup' :
            Entry.VariantID = SMPVariantID;
            break;
    }
    return Entry.VariantID != "";
}

static final function bool IsGenericGoldSkin(class<Pickup> PickupClass)
{
	return InStr(Caps(PickupClass), "_GOLD_") != -1;
}

static final function bool IsGenericCamoSkin(class<Pickup> PickupClass)
{
	return InStr(Caps(PickupClass), "_CAMO_") != -1;
}

static final function bool IsGenericTurboSkin(class<Pickup> PickupClass)
{
	return InStr(Caps(PickupClass), "_TURBO_") != -1;
}

static final function bool IsGenericVMSkin(class<Pickup> PickupClass)
{
	return InStr(Caps(PickupClass), "_VM_") != -1;
}

static final function bool IsGenericWestLondonSkin(class<Pickup> PickupClass)
{
	return InStr(Caps(PickupClass), "_WL_") != -1;
}

defaultproperties
{
    //Default group that gives all players access to a set weapon skins.
    Begin Object Class=KFTurboRepLinkSettingsGroup Name=RepLinkDefaultGroup
        DisplayName="DefaultGroup"
        bDefaultGroup=true
        VariantIDList(0)="DEF"
        VariantIDList(1)="GOLD"
        VariantIDList(2)="CAMO"
        VariantIDList(3)="TURBO"
        VariantIDList(4)="VM"
        VariantIDList(5)="WEST"
    End Object
    GroupList(0)=KFTurboRepLinkSettingsGroup'KFTurbo.KFTurboRepLinkSettings.RepLinkDefaultGroup'

    Begin Object Class=KFTurboRepLinkSettingsUser Name=RepLinkTestUser
        PlayerSteamID="20b300195d48c2ccc2651885cfea1a2f"
        DisplayName="Retard"
        VariantIDList(0)="RET"
        VariantIDList(1)="SCUD"
        VariantIDList(2)="CUBIC"
        VariantIDList(3)="SHOWME"
    End Object
    UserList(0)=KFTurboRepLinkSettingsUser'KFTurbo.KFTurboRepLinkSettings.RepLinkTestUser'

}