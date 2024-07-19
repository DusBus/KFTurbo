class TurboRepLinkTester extends Info;

var ClientPerkRepLink ClientPerkRepLink;
var PlayerController LocalPlayerController;

simulated function PostBeginPlay()
{
    local bool bIsAuthority;
    
    Super.PostBeginPlay();

    SetTimer(1.f, true);

    bIsAuthority = Role == ROLE_Authority;

    if (Level.GetLocalPlayerController() != None)
    {
        LocalPlayerController = Level.GetLocalPlayerController();
    }

    DebugPrint("SPINNING UP REP LINK TESTER", bIsAuthority);
}

static simulated function DebugPrint(string String, bool bIsAuthority)
{
    if (bIsAuthority)
    {
        log ("AUTHORITY:"@String, 'KFTurbo');
    }
    else
    {
        log ("CLIENT:"@String, 'KFTurbo');
    }
}

simulated function Timer()
{
    local bool bIsAuthority;
    local ClientPerkRepLink CPRL;
    local int NumCPRL;

    bIsAuthority = Role == ROLE_Authority;

    if (Level.GRI == None)
    {
        if (!bIsAuthority)
        {
            DebugPrint("NO GRI IS PRESENT", bIsAuthority);
        }
        return;
    }

    if (!Level.GRI.bMatchHasBegun)
    {
        if (!bIsAuthority)
        {
            DebugPrint("GRI MATCH HAS NOT STARTED", bIsAuthority);
        }
        return;
    }

    foreach DynamicActors(class'ClientPerkRepLink', CPRL)
        break;
    
    if (CPRL == None)
    {
        DebugPrint("NO CPRLS ARE PRESENT", bIsAuthority);
        return;
    }

    DebugPrint("======================", bIsAuthority);
    DebugPrint("STARTING REP LINK TEST", bIsAuthority);
    DebugPrint("CHECKING FOR CPRLS", bIsAuthority);

    foreach DynamicActors(class'ClientPerkRepLink', CPRL)
    {
        DebugPrint(NumCPRL$":"@CPRL, bIsAuthority);
        NumCPRL++;

        if (CPRL.OwnerPRI == None || PlayerController(CPRL.OwnerPRI.Owner) == None)
        {
            continue;
        }

        DebugPrint(" - Ownership:"@CPRL.OwnerPRI@"("$CPRL.OwnerPRI.PlayerName$")", bIsAuthority);
        DebugPrint(" - Rep Complete:"@CPRL.bRepCompleted@"( Perks:"@CPRL.CachePerks.Length@"| Shop:"@CPRL.ShopInventory.Length@")", bIsAuthority);
    }

    DebugPrint("-> FOUND"@NumCPRL, bIsAuthority);

    if (bIsAuthority)
    {
        return;
    }

    DebugPrint("FINDING CPRL FOR LOCAL PLAYER", bIsAuthority);
    CPRL = class'ClientPerkRepLink'.static.FindStats(LocalPlayerController);

    if (CPRL != None && CPRL.bRepCompleted && CPRL.CachePerks.Length != 0 && CPRL.ShopInventory.Length != 0)
    {
        DebugPrint("CLIENT REP COMPLETED AND PERK AND SHOP NON ZERO LIST SIZE. ASSUMING SUCCESS.", bIsAuthority);
        SetTimer(0.f, false);
    }
}

defaultproperties
{
    bSkipActorPropertyReplication=true
    bAlwaysRelevant=True
    RemoteRole=ROLE_SimulatedProxy
}