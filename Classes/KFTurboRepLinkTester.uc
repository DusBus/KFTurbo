class KFTurboRepLinkTester extends Info;

var KFTurboMut KFTurboMutator;
var ClientPerkRepLink ClientPerkRepLink;
var PlayerController LocalPlayerController;

simulated function PostBeginPlay()
{
    foreach DynamicActors(class'KFTurboMut', KFTurboMutator)
        break;

    SetTimer(1.f, true);

    if (Level.GetLocalPlayerController() != None)
    {
        LocalPlayerController = Level.GetLocalPlayerController();
    }
}

static simulated function DebugPrint(string String, bool bIsAuthority)
{
    if (bIsAuthority)
    {
        log ("AUTHORITY:"@String);
    }
    else
    {
        log ("CLIENT:"@String);
    }
}

simulated function Timer()
{
    local bool bIsAuthority;
    local ClientPerkRepLink CPRL;
    local int NumCPRL;

    if (Level.Game == None)
    {
        return;
    }

    if (Level.Game.bWaitingToStartMatch)
    {
        return;
    }

    foreach DynamicActors(class'KFTurboMut', KFTurboMutator)
        break;

    if (KFTurboMutator == None)
    {
        DebugPrint("NO KFTURBO MUTATOR PRESENT", bIsAuthority);
        return;
    }

    foreach DynamicActors(class'ClientPerkRepLink', CPRL)
        break;

    bIsAuthority = KFTurboMutator.Role == ROLE_Authority;

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

        if (CPRL.OwnerPRI == None || PlayerController(CPRL.OwnerPRI.Owner) == None)
        {
            continue;
        }

        DebugPrint(" - Ownership:"@CPRL.OwnerPRI@"("$CPRL.OwnerPRI.PlayerName$")", bIsAuthority);
        DebugPrint(" - Rep Complete:"@CPRL.bRepCompleted@"( Perks:"@CPRL.CachePerks.Length@"| Shop:"@CPRL.ShopInventory.Length@")", bIsAuthority);
        
        NumCPRL++;
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
        Destroy();
    }
}