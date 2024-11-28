//Killing Floor Turbo TurboCardReplicationInfo
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboCardReplicationInfo extends Engine.ReplicationInfo;

var int SelectionCount;
var KFTurboCardGameMut OwnerMutator;

var TurboCardDeck GoodGameDeck;
var TurboCardDeck SuperGameDeck;
var TurboCardDeck ProConGameDeck;
var TurboCardDeck EvilGameDeck;

struct CardReference
{
    var class<TurboCardDeck> Deck;
    var int CardIndex;
};

//List of cards players can pick from. If any cards are active, we are in card vote mode.
const MAX_SELECTABLE_CARDS = 9;
var TurboCard AuthSelectableCardList[MAX_SELECTABLE_CARDS]; //Needed to call activation delegate on server.
var CardReference SelectableCardList[MAX_SELECTABLE_CARDS];
//List of active cards. Game can have a maximum of 30 active cards.
const MAX_ACTIVE_CARDS = 30;
var CardReference ActiveCardList[MAX_ACTIVE_CARDS];
//Counter that is incremented whenever some action is done to the two above replicated arrays.
var byte SelectionUpdateCounter;

//Starts at 0, represents the last index we knew had a card in it.
var int LastKnownActiveCardIndex;
//Starts as false, represents if we were voting on a card last time PostNetReceive was called.
var bool bCurrentlyVoting;
//List of cards that are active but still pending the client acknowledging them.
var array< CardReference > PendingActiveCardList;

var TurboCardOverlay TurboCardOverlay;
var TurboCardInteraction TurboCardInteraction;

var PlayerBleedActor BleedManager;
var PlayerBorrowedTimeActor BorrwedTimeManage;
var PlayerNoRestForTheWickedActor NoRestForTheWickedManager;
var CurseOfRaManager CurseOfRaManager;
var RandomTraderManager RandomTraderManager;

delegate OnSelectableCardsUpdated(TurboCardReplicationInfo CGRI);
delegate OnActiveCardsUpdated(TurboCardReplicationInfo CGRI);

replication
{
	reliable if (bNetDirty && Role == ROLE_Authority )
		SelectableCardList, ActiveCardList, SelectionUpdateCounter;
}

//Resolves a card object from a deck CDO. DO NOT CALL INSTANCE FUNCTIONS ON THESE.
static final function TurboCard ResolveCard(CardReference Reference)
{
    if (Reference.Deck == None)
    {
        return None;
    }

    return Reference.Deck.static.GetCardFromReference(Reference);
}

static final function CardReference GetCardReference(TurboCard Card)
{
    local CardReference Reference;
    if (Card.DeckClass == None)
    {
        Reference.Deck = None;
        Reference.CardIndex = -1;
        return Reference;
    }

    Reference.Deck = Card.DeckClass;
    Reference.CardIndex = Card.CardIndex;
    return Reference;
}

//Returns index (usually is wave - 1) that Curse Of Ra was selected.
simulated function int GetCurseOfRaCardIndex()
{
    local int Index;
    local TurboCard Card;

    for (Index = 0; Index < ArrayCount(ActiveCardList); Index++)
    {
        Card = ResolveCard(ActiveCardList[Index]);

        if (Card == None)
        {
            return -1;
        }

        if (TurboCard_Evil_Ra(Card) != None)
        {
            return Index;
        }
    }

    return -1;
}

simulated function PostNetBeginPlay()
{
    Super.PostNetBeginPlay();

    if (Role != ROLE_Authority)
    {
        CheckForSelectableCardUpdates();
        CheckForActiveCardUpdates();
    }
}

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    
    if (Role == ROLE_Authority)
    {
        class'TurboWaveEventHandler'.static.RegisterWaveHandler(Self, class'CardSelectionWaveEventHandler');
    }
}

simulated function Tick(float DeltaTime)
{
    if (Level.NetMode == NM_DedicatedServer)
    {
        Disable('Tick');
        return;
    }

    if (Level.GetLocalPlayerController() != None)
    {
        if (TurboCardOverlay == None)
        { 
            AddOverlay(Level.GetLocalPlayerController());
        }

        SetupTurboCardInteraction();
        if (TurboCardOverlay != None && TurboCardInteraction != None)
        {
            Disable('Tick');
        }
    }
}

simulated function SetupTurboCardInteraction()
{
    if (TurboCardInteraction != None || Level.GetLocalPlayerController() == None || Level.GetLocalPlayerController().Player == None)
    {
        return;
    }
    
    TurboCardInteraction = TurboCardInteraction(Level.GetLocalPlayerController().Player.InteractionMaster.AddInteraction("KFTurboCardGame.TurboCardInteraction", Level.GetLocalPlayerController().Player));
}

simulated function Destroyed()
{
    //Cleanup overlay.
    if (TurboCardOverlay != None)
    {
        TurboCardOverlay.Destroy();
    }

    Super.Destroyed();
}

simulated function AddOverlay(PlayerController PlayerController)
{
    TurboCardOverlay = Spawn(class'TurboCardOverlay', PlayerController.myHUD);
    TurboCardOverlay.Initialize(TurboHUDKillingFloor(PlayerController.myHUD));
    TurboCardOverlay.InitializeCardGameHUD(Self);
    PlayerController.myHUD.AddHudOverlay(TurboCardOverlay);
}

simulated function PostNetReceive()
{
    Super.PostNetReceive();

    CheckForActiveCardUpdates();
    CheckForSelectableCardUpdates();
}

simulated function CheckForActiveCardUpdates()
{
    local int ActiveCardIndex;
    local bool bHasNewActiveCards;

    bHasNewActiveCards = false;
    for (ActiveCardIndex = 0; ActiveCardIndex < ArrayCount(ActiveCardList); ActiveCardIndex++)
    {
        if (ResolveCard(ActiveCardList[ActiveCardIndex]) == None)
        {
            break;
        }

        if (LastKnownActiveCardIndex < ActiveCardIndex)
        {
            PendingActiveCardList[PendingActiveCardList.Length] = ActiveCardList[ActiveCardIndex];
            bHasNewActiveCards = true;
        }
    }

    if (!bHasNewActiveCards)
    {
        return;
    }

    LastKnownActiveCardIndex = ActiveCardIndex - 1;
    OnActiveCardsUpdated(Self);
}

simulated function CheckForSelectableCardUpdates()
{
    local bool bHasSelectableCards;
    bHasSelectableCards = ResolveCard(SelectableCardList[0]) != None;

    if (bHasSelectableCards == bCurrentlyVoting)
    {
        return;
    }
    
    bCurrentlyVoting = bHasSelectableCards;
    OnSelectableCardsUpdated(Self);
}

function Initialize(KFTurboCardGameMut Mutator)
{
    local class<TurboCardDeck> GoodTurboDeckClass;
    local class<TurboCardDeck> SuperTurboDeckClass;
    local class<TurboCardDeck> ProConTurboDeckClass;
    local class<TurboCardDeck> EvilTurboDeckClass;

    OwnerMutator = Mutator;

    GoodTurboDeckClass = class'TurboCardDeck_Good';
	if (Mutator.TurboGoodDeckClassOverrideString != "")
	{
		GoodTurboDeckClass = class<TurboCardDeck>(DynamicLoadObject(Mutator.TurboGoodDeckClassOverrideString, class'Class'));

        if (GoodTurboDeckClass == None)
        {
            GoodTurboDeckClass = class'TurboCardDeck_Good';
        }
	}

    SuperTurboDeckClass = class'TurboCardDeck_Super';
	if (Mutator.TurboSuperDeckClassOverrideString != "")
	{
		SuperTurboDeckClass = class<TurboCardDeck>(DynamicLoadObject(Mutator.TurboSuperDeckClassOverrideString, class'Class'));

        if (SuperTurboDeckClass == None)
        {
            SuperTurboDeckClass = class'TurboCardDeck_Super';
        }
	}

    ProConTurboDeckClass = class'TurboCardDeck_ProCon';
	if (Mutator.TurboProConDeckClassOverrideString != "")
	{
		ProConTurboDeckClass = class<TurboCardDeck>(DynamicLoadObject(Mutator.TurboProConDeckClassOverrideString, class'Class'));

        if (ProConTurboDeckClass == None)
        {
            ProConTurboDeckClass = class'TurboCardDeck_ProCon';
        }
	}

    EvilTurboDeckClass = class'TurboCardDeck_Evil';
	if (Mutator.TurboEvilDeckClassOverrideString != "")
	{
		EvilTurboDeckClass = class<TurboCardDeck>(DynamicLoadObject(Mutator.TurboEvilDeckClassOverrideString, class'Class'));

        if (EvilTurboDeckClass == None)
        {
            EvilTurboDeckClass = class'TurboCardDeck_Evil';
        }
	}

    GoodGameDeck = new(Self) GoodTurboDeckClass;
    SuperGameDeck = new(Self) SuperTurboDeckClass;
    ProConGameDeck = new(Self) ProConTurboDeckClass;
    EvilGameDeck = new(Self) EvilTurboDeckClass;

    GoodGameDeck.InitializeDeck();
    SuperGameDeck.InitializeDeck();
    ProConGameDeck.InitializeDeck();
    EvilGameDeck.InitializeDeck();
}

//Append to end of active card list this newly selected card.
function SelectCard(TurboCard SelectedCard)
{
    local int Index;
    
    if (SelectedCard == None)
    {
        return;
    }
    
    for (Index = 0; Index < ArrayCount(ActiveCardList); Index++)
    {
        if (ResolveCard(ActiveCardList[Index]) != None)
        {
            continue;
        }

        ActiveCardList[Index] = GetCardReference(SelectedCard);
        break;
    }

    SelectionUpdateCounter++;
    ClearSelection();

    log("Executing OnActivateCard delegate for"@SelectedCard.CardName[0]);
    SelectedCard.OnActivateCard(Self);
    
    CheckForActiveCardUpdates();
}

function SelectRandomCard()
{
    local int Index;
    for (Index = 0; Index < ArrayCount(AuthSelectableCardList); Index++)
    {
        if (AuthSelectableCardList[Index] != None)
        {
            continue;
        }

        break;
    }

    Index = Rand(Index);
    SelectCard(AuthSelectableCardList[Index]);
}

//Populates the SelectableCardList with pickable cards.
function StartSelection(int WaveNumber)
{
    local TurboCardDeck Deck;
    local int Count;

    ClearSelection();

    Deck = None;

    log ("Selecting for wave number:"@WaveNumber);
    switch(WaveNumber + 1)
    {
        case 0:
        case 1:
            Deck = SuperGameDeck;
            break;
        case 2:
            Deck = EvilGameDeck;
            break;
        case 3:
            Deck = ProConGameDeck;
            break;
        case 4:
            Deck = GoodGameDeck;
            break;
        case 5:
            Deck = SuperGameDeck;
            break;
        case 6:
            Deck = EvilGameDeck;
            break;
        case 7:
            Deck = ProConGameDeck;
            break;
        case 8:
            Deck = GoodGameDeck;
            break;
        case 9:
            Deck = EvilGameDeck;
            break;
        case 10:
            Deck = ProConGameDeck;
            break;
        case 11:
            Deck = EvilGameDeck;
            break;
        case 12:
            Deck = GoodGameDeck;
            break;
        case 13:
            Deck = EvilGameDeck;
            break;
        case 14:
            Deck = SuperGameDeck;
            break;
        case 15:
            Deck = EvilGameDeck;
            break;
    }

    //We pick specific card order for the first 15 waves.
    //After that, space out card occurances in a way that leans towards more difficulty.
    if (Deck == None)
    {
        if (WaveNumber % 3 == 0)
        {
            Deck = EvilGameDeck;
        }
        else if (WaveNumber % 5 == 0)
        {
            Deck = SuperGameDeck;
        }
        else if (WaveNumber % 2 == 0)
        {
            Deck = ProConGameDeck;
        }
        else 
        {
            Deck = GoodGameDeck;
        }
    }

    log ("Selected Deck:"@Deck);
    Count = GetSelectionCount();
    Count--;
    while (Count >= 0)
    {
        AuthSelectableCardList[Count] = Deck.PopRandomCardObject();
        SelectableCardList[Count] = GetCardReference(AuthSelectableCardList[Count]);
        log ("- Selected Card:"@Count@AuthSelectableCardList[Count].CardName[0]);
        Count--;
    }
    
    SelectionUpdateCounter++;
    CheckForSelectableCardUpdates();
}

function ActivateRandomSuperCard()
{
    local TurboCard Card;
    if (SuperGameDeck == None)
    {
        return;
    }

    Card = SuperGameDeck.PopRandomCardObject();
    SelectCard(Card);
}

function ActivateRandomEvilCard()
{
    local TurboCard Card;
    if (EvilGameDeck == None)
    {
        return;
    }

    Card = EvilGameDeck.PopRandomCardObject();
    SelectCard(Card);
}

function int GetSelectionCount()
{
    return SelectionCount;
}

//Clears out SelectableCardList.
function ClearSelection()
{
    local int Index;
    local CardReference EmptyReference;
    EmptyReference.Deck = None;
    EmptyReference.CardIndex = -1;
    for (Index = ArrayCount(SelectableCardList) - 1; Index >= 0; Index--)
    {
        SelectableCardList[Index] = EmptyReference;
        AuthSelectableCardList[Index] = None;
    }

    SelectionUpdateCounter++;
    CheckForSelectableCardUpdates();
}

//Called when a majority have voted or the next wave has begun.
function OnSelectionTimeEnd()
{
    local array<int> VotingList;
    local array<int> TiedVotingList;

    local int CardIndex;
    local int Index;
    local int TopVotedCount;
    local CardGamePlayerReplicationInfo CardLRI;

    TopVotedCount = 1;

    //Voting is done via 1-based indexing but the selectable card array and the vote tally array are 0-based so index conversion is done during tally. 
    for (Index = 0; Index < Level.GRI.PRIArray.Length; Index++)
    {
        if (Level.GRI.PRIArray[Index].bIsSpectator)
        {
            continue;
        }

        CardLRI = class'CardGamePlayerReplicationInfo'.static.GetCardGameLRI(Level.GRI.PRIArray[Index]);

        if (CardLRI == None || CardLRI.VoteIndex <= 0)
        {
            continue;
        }

        CardIndex = CardLRI.VoteIndex - 1;

        if (VotingList.Length > CardIndex)
        {
            VotingList[CardIndex] = VotingList[CardIndex] + 1;

            if (TopVotedCount < VotingList[CardIndex])
            {
                TopVotedCount = VotingList[CardIndex];
            }
        }
        else
        {
            VotingList.Length = CardIndex + 1;
            VotingList[CardIndex] = 1;
        }
    }

    if (VotingList.Length == 0)
    {
        SelectRandomCard();
    }
    else
    {
        for (Index = 0; Index < VotingList.Length; Index++)
        {
            if (VotingList[Index] < TopVotedCount)
            {
                continue;
            }

            TiedVotingList.Length = TiedVotingList.Length + 1;
            TiedVotingList[TiedVotingList.Length - 1] = Index;
        }

        if (TiedVotingList.Length == 1)
        {
            SelectCard(AuthSelectableCardList[TiedVotingList[0]]);
        }
        else if (TiedVotingList.Length > 1)
        {
            SelectCard(AuthSelectableCardList[TiedVotingList[Rand(TiedVotingList.Length)]]);
        }
        else 
        {
            SelectRandomCard();
        }
    }

    ResetPlayerVotes();
}

function ResetPlayerVotes()
{
    local int Index;
    local CardGamePlayerReplicationInfo CardLRI;

    //Voting is done via 1-based indexing but the selectable card array and the vote tally array are 0-based so index conversion is done during tally. 
    for ( Index = 0; Index < Level.GRI.PRIArray.Length; Index++)
    {
        CardLRI = class'CardGamePlayerReplicationInfo'.static.GetCardGameLRI(Level.GRI.PRIArray[Index]);

        if (CardLRI == None || CardLRI.VoteIndex <= 0)
        {
            continue;
        }

        CardLRI.ResetVote();
    }
}

//===========
//GAMEPLAY MODIFICATION FUNCTIONS:

function ModifyWaveSpeed(float Multiplier)
{
    KFTurboGameType(Level.Game).WaveSpawnRateModifier *= Multiplier;
    log("WaveSpawnRateModifier"@KFTurboGameType(Level.Game).WaveSpawnRateModifier);
}

function ModifyCashBonus(float Multiplier)
{
    OwnerMutator.CardGameRules.BonusCashMultiplier *= Multiplier;
    log("BonusCashMultiplier"@OwnerMutator.CardGameRules.BonusCashMultiplier);
}

function ModifyTraderPriceMultiplier(float Multiplier)
{
    OwnerMutator.TurboCardGameModifier.TraderCostMultiplier *= Multiplier;
    log("TraderCostMultiplier"@OwnerMutator.TurboCardGameModifier.TraderCostMultiplier);
    OwnerMutator.TurboCardGameModifier.ForceNetUpdate();
}

function ModifyGrenadeTraderPriceMultiplier(float Multiplier)
{
    OwnerMutator.TurboCardGameModifier.TraderGrenadeCostMultiplier *= Multiplier;
    log("TraderGrenadeCostMultiplier"@OwnerMutator.TurboCardGameModifier.TraderGrenadeCostMultiplier);
    OwnerMutator.TurboCardGameModifier.ForceNetUpdate();
}

function DisableArmorPurchase()
{
    OwnerMutator.TurboCardGameModifier.bDisableArmorPurchase = true;
    OwnerMutator.TurboCardGameModifier.ForceNetUpdate();
}

function ModifyPlayerDamage(float Multiplier)
{
    OwnerMutator.CardGameRules.PlayerDamageMultiplier *= Multiplier;
    log("PlayerDamageMultiplier"@OwnerMutator.CardGameRules.PlayerDamageMultiplier);
}

function ModifyPlayerRangedDamage(float Multiplier)
{
    OwnerMutator.CardGameRules.PlayerRangedDamageMultiplier *= Multiplier;
    log("PlayerRangedDamageMultiplier"@OwnerMutator.CardGameRules.PlayerRangedDamageMultiplier);
}

function ModifyOnPerkDamage(float Multiplier)
{
    OwnerMutator.CardGameRules.OnPerkDamageMultiplier *= Multiplier;
    log("OnPerkDamageMultiplier"@OwnerMutator.CardGameRules.OnPerkDamageMultiplier);
}

function ModifyOffPerkDamage(float Multiplier)
{
    OwnerMutator.CardGameRules.OffPerkDamageMultiplier *= Multiplier;
    log("OffPerkDamageMultiplier"@OwnerMutator.CardGameRules.OffPerkDamageMultiplier);
}

function ModifyExplosiveDamage(float Multiplier)
{
    OwnerMutator.CardGameRules.ExplosiveDamageMultiplier *= Multiplier;
    log("ExplosiveDamageMultiplier"@OwnerMutator.CardGameRules.ExplosiveDamageMultiplier);
}

function ModifyExplosiveRadius(float Multiplier)
{
    OwnerMutator.CardGameRules.ExplosiveRadiusMultiplier *= Multiplier;
    log("ExplosiveRadiusMultiplier"@OwnerMutator.CardGameRules.ExplosiveRadiusMultiplier);
}

function ModifyShotgunDamage(float Multiplier)
{
    OwnerMutator.CardGameRules.ShotgunDamageMultiplier *= Multiplier;
    log("ShotgunDamageMultiplier"@OwnerMutator.CardGameRules.ShotgunDamageMultiplier);
}

function ModifyMedicGrenadeDamage(float DamageMultiplier)
{
    OwnerMutator.CardGameRules.MedicGrenadeDamageMultiplier *= DamageMultiplier;
    log("MedicGrenadeDamageMultiplier"@OwnerMutator.CardGameRules.MedicGrenadeDamageMultiplier);
}

function ModifyFireDamage(float Multiplier)
{
    OwnerMutator.CardGameRules.FireDamageMultiplier *= Multiplier;
    log("FireDamageMultiplier"@OwnerMutator.CardGameRules.FireDamageMultiplier);
}

function ModifyBerserkerMeleeDamage(float Multiplier)
{
    OwnerMutator.CardGameRules.BerserkerMeleeDamageMultiplier *= Multiplier;
    log("BerserkerMeleeDamageMultiplier"@OwnerMutator.CardGameRules.BerserkerMeleeDamageMultiplier);
}

function ModifyTrashHeadshotDamage(float Multiplier)
{
    OwnerMutator.CardGameRules.TrashHeadshotDamageMultiplier *= Multiplier;
    log("TrashHeadshotDamageMultiplier"@OwnerMutator.CardGameRules.TrashHeadshotDamageMultiplier);
}

function ModifyTrashDamage(float Multiplier)
{
    OwnerMutator.CardGameRules.TrashDamageMultiplier *= Multiplier;
    log("TrashDamageMultiplier"@OwnerMutator.CardGameRules.TrashDamageMultiplier);
}

function ModifySlomoDamage(float Multiplier)
{
    OwnerMutator.CardGameRules.SlomoDamageMultiplier *= Multiplier;
    log("SlomoDamageMultiplier"@OwnerMutator.CardGameRules.SlomoDamageMultiplier);
}

function ModifyPlayerFleshpoundDamage(float Multiplier)
{
    OwnerMutator.CardGameRules.FleshpoundDamageMultiplier *= Multiplier;
    log("FleshpoundDamageMultiplier"@OwnerMutator.CardGameRules.FleshpoundDamageMultiplier);
}

function ModifyPlayerScrakeDamage(float Multiplier)
{
    OwnerMutator.CardGameRules.ScrakeDamageMultiplier *= Multiplier;
    log("ScrakeDamageMultiplier"@OwnerMutator.CardGameRules.ScrakeDamageMultiplier);
}

function ModifyWeaponFireRate(float Multiplier)
{
    OwnerMutator.TurboCardGameModifier.FireRateMultiplier *= Multiplier;
    log("FireRateMultiplier"@OwnerMutator.TurboCardGameModifier.FireRateMultiplier);
    OwnerMutator.TurboCardGameModifier.ForceNetUpdate();
}

function ModifyWeaponZedTimeDualPistolFireRate(float Multiplier)
{
    OwnerMutator.TurboCardGameModifier.ZedTimeDualPistolFireRateMultiplier *= Multiplier;
    log("WeaponZedTimeDualPistolFireRate"@OwnerMutator.TurboCardGameModifier.ZedTimeDualPistolFireRateMultiplier);
    OwnerMutator.TurboCardGameModifier.ForceNetUpdate();
}

function ModifyWeaponZedTimeExtensions(int Modifier)
{
    OwnerMutator.TurboCardGameModifier.PlayerZedTimeExtensionsModifier += Modifier;
    log("PlayerZedTimeExtensionsModifier"@OwnerMutator.TurboCardGameModifier.PlayerZedTimeExtensionsModifier);
}

function ModifyWeaponZedTimeDualPistolExtensions(int Modifier)
{
    OwnerMutator.TurboCardGameModifier.PlayerDualPistolZedTimeExtensionsModifier += Modifier;
    log("PlayerDualPistolZedTimeExtensionsModifier"@OwnerMutator.TurboCardGameModifier.PlayerDualPistolZedTimeExtensionsModifier);
}

function ModifyDualWeaponMagazineAmmo(float Multiplier)
{
    OwnerMutator.TurboCardGameModifier.DualWeaponMagazineAmmoMultiplier *= Multiplier;
    log("DualWeaponMagazineAmmoMultiplier"@OwnerMutator.TurboCardGameModifier.DualWeaponMagazineAmmoMultiplier);
    OwnerMutator.TurboCardGameModifier.ForceNetUpdate();
}

function ModifyBerserkerWeaponFireRate(float Multiplier)
{
    OwnerMutator.TurboCardGameModifier.BerserkerFireRateMultiplier *= Multiplier;
    log("BerserkerFireRateMultiplier"@OwnerMutator.TurboCardGameModifier.BerserkerFireRateMultiplier);
    OwnerMutator.TurboCardGameModifier.ForceNetUpdate();
}

function ModifyFirebugWeaponFireRate(float Multiplier)
{
    OwnerMutator.TurboCardGameModifier.FirebugFireRateMultiplier *= Multiplier;
    log("FirebugFireRateMultiplier"@OwnerMutator.TurboCardGameModifier.FirebugFireRateMultiplier);
    OwnerMutator.TurboCardGameModifier.ForceNetUpdate();
}

function ModifyWeaponReloadRate(float Multiplier)
{
    OwnerMutator.TurboCardGameModifier.ReloadRateMultiplier *= Multiplier;
    log("ReloadRateMultiplier"@OwnerMutator.TurboCardGameModifier.ReloadRateMultiplier);
    OwnerMutator.TurboCardGameModifier.ForceNetUpdate();
}

function ModifyWeaponMagazineAmmo(float Multiplier)
{
    OwnerMutator.TurboCardGameModifier.MagazineAmmoMultiplier *= Multiplier;
    log("MagazineAmmoMultiplier"@OwnerMutator.TurboCardGameModifier.MagazineAmmoMultiplier);
    OwnerMutator.TurboCardGameModifier.ForceNetUpdate();
}

function ModifyCommandoWeaponMagazineAmmo(float Multiplier)
{
    OwnerMutator.TurboCardGameModifier.CommandoMagazineAmmoMultiplier *= Multiplier;
    log("CommandoMagazineAmmoMultiplier"@OwnerMutator.TurboCardGameModifier.CommandoMagazineAmmoMultiplier);
    OwnerMutator.TurboCardGameModifier.ForceNetUpdate();
}

function ModifyMedicWeaponMagazineAmmo(float Multiplier)
{
    OwnerMutator.TurboCardGameModifier.MedicMagazineAmmoMultiplier *= Multiplier;
    log("MedicMagazineAmmoMultiplier"@OwnerMutator.TurboCardGameModifier.MedicMagazineAmmoMultiplier);
    OwnerMutator.TurboCardGameModifier.ForceNetUpdate();
}

function ModifyWeaponMaxAmmo(float Multiplier)
{
    OwnerMutator.TurboCardGameModifier.MaxAmmoMultiplier *= Multiplier;
    log("MaxAmmoMultiplier"@OwnerMutator.TurboCardGameModifier.MaxAmmoMultiplier);
    OwnerMutator.TurboCardGameModifier.ForceNetUpdate();
}

function ModifyMedicWeaponMaxAmmo(float Multiplier)
{
    OwnerMutator.TurboCardGameModifier.MedicMaxAmmoMultiplier *= Multiplier;
    log("MedicMaxAmmoMultiplier"@OwnerMutator.TurboCardGameModifier.MedicMaxAmmoMultiplier);
    OwnerMutator.TurboCardGameModifier.ForceNetUpdate();
}

function ModifyGrenadeMaxAmmo(float Multiplier)
{
    OwnerMutator.TurboCardGameModifier.GrenadeMaxAmmoMultiplier *= Multiplier;
    log("GrenadeMaxAmmoMultiplier"@OwnerMutator.TurboCardGameModifier.GrenadeMaxAmmoMultiplier);
    OwnerMutator.TurboCardGameModifier.ForceNetUpdate();
}

function ModifyWeaponPenetration(float Multiplier)
{
    OwnerMutator.TurboCardGameModifier.WeaponPenetrationMultiplier *= Multiplier;
    log("WeaponPenetrationMultiplier"@OwnerMutator.TurboCardGameModifier.WeaponPenetrationMultiplier);
    OwnerMutator.TurboCardGameModifier.ForceNetUpdate();
}

function ModifyWeaponSpreadAndRecoil(float Multiplier)
{
    OwnerMutator.TurboCardGameModifier.WeaponSpreadRecoilMultiplier *= Multiplier;
    log("WeaponSpreadRecoilMultiplier"@OwnerMutator.TurboCardGameModifier.WeaponSpreadRecoilMultiplier);
    OwnerMutator.TurboCardGameModifier.ForceNetUpdate();
}

function ModifyShotgunPelletCount(float Multiplier)
{
    OwnerMutator.TurboCardGameModifier.ShotgunPelletCountMultiplier *= Multiplier;
    log("ShotgunPelletCountMultiplier"@OwnerMutator.TurboCardGameModifier.ShotgunPelletCountMultiplier);
    OwnerMutator.TurboCardGameModifier.ForceNetUpdate();
}

function ModifyShotgunRecoil(float Multiplier)
{
    OwnerMutator.TurboCardGameModifier.ShotgunSpreadRecoilMultiplier *= Multiplier;
    log("ShotgunSpreadRecoilMultiplier"@OwnerMutator.TurboCardGameModifier.ShotgunSpreadRecoilMultiplier);
    OwnerMutator.TurboCardGameModifier.ForceNetUpdate();
}

function ModifyShotgunKickBack(float Multiplier)
{
    OwnerMutator.TurboCardGameModifier.ShotgunKickBackMultiplier *= Multiplier;
    log("ShotgunKickBackMultiplier"@OwnerMutator.TurboCardGameModifier.ShotgunKickBackMultiplier);
    OwnerMutator.TurboCardGameModifier.ForceNetUpdate();
}

function ModifyExplosiveDamageTaken(float Multiplier)
{
    OwnerMutator.CardGameRules.ExplosiveDamageTakenMultiplier *= Multiplier;
    log("ModifyExplosiveDamageTaken"@OwnerMutator.CardGameRules.ExplosiveDamageTakenMultiplier);
}

function ModifyNonMedicHealPotency(float Multiplier)
{
    OwnerMutator.TurboCardGameModifier.NonMedicHealPotencyMultiplier *= Multiplier;
    log("NonMedicHealPotencyMultiplier"@OwnerMutator.TurboCardGameModifier.NonMedicHealPotencyMultiplier);
}

function ModifyMedicHealPotency(float Multiplier)
{
    OwnerMutator.TurboCardGameModifier.MedicHealPotencyMultiplier *= Multiplier;
    log("MedicHealPotencyMultiplier"@OwnerMutator.TurboCardGameModifier.MedicHealPotencyMultiplier);
}

function ModifyHealRecharge(float Multiplier)
{
    OwnerMutator.TurboCardGameModifier.HealRechargeMultiplier *= Multiplier;
    log("HealRechargeMultiplier"@OwnerMutator.TurboCardGameModifier.HealRechargeMultiplier);
}

function IncreaseSelectionCount()
{
    SelectionCount++;
}

function DecreaseSelectionCount()
{
    SelectionCount--;
    SelectionCount = Max(1, SelectionCount);
}

function ModifyZombieHeadSize(float Multiplier)
{
    OwnerMutator.TurboCardClientModifier.MonsterHeadSizeModifier *= Multiplier;
    log("MonsterHeadSizeModifier"@OwnerMutator.TurboCardClientModifier.MonsterHeadSizeModifier);
    OwnerMutator.TurboCardClientModifier.ForceNetUpdate();
}

function ModifyZombieDamage(float Multiplier)
{
    OwnerMutator.CardGameRules.MonsterDamageMultiplier *= Multiplier;
    log("MonsterDamageMultiplier"@OwnerMutator.CardGameRules.MonsterDamageMultiplier);
}

function ModifyZombieMeleeDamage(float Multiplier)
{
    OwnerMutator.CardGameRules.MonsterMeleeDamageMultiplier *= Multiplier;
    log("MonsterMeleeDamageMultiplier"@OwnerMutator.CardGameRules.MonsterMeleeDamageMultiplier);
}

function ModifyZombieRangedDamage(float Multiplier)
{
    OwnerMutator.CardGameRules.MonsterRangedDamageMultiplier *= Multiplier;
    log("MonsterRangedDamageMultiplier"@OwnerMutator.CardGameRules.MonsterRangedDamageMultiplier);
}

function ModifyStalkerMeleeDamage(float Multiplier)
{
    OwnerMutator.CardGameRules.MonsterStalkerDamageMultiplier *= Multiplier;
    log("MonsterStalkerDamageMultiplier"@OwnerMutator.CardGameRules.MonsterStalkerDamageMultiplier);
}

function ModifyStalkerDistraction(float Multiplier)
{
    OwnerMutator.TurboCardClientModifier.StalkerDistractionModifier *= Multiplier;
    log("StalkerDistractionModifier"@OwnerMutator.TurboCardClientModifier.StalkerDistractionModifier);
    OwnerMutator.TurboCardClientModifier.ForceNetUpdate();
}

function ModifyZombieMeleeMomentum(float Multiplier)
{
    OwnerMutator.CardGameRules.MonsterMeleeDamageMomentumMultiplier *= Multiplier;
    log("MonsterMeleeDamageMomentumMultiplier"@OwnerMutator.CardGameRules.MonsterMeleeDamageMomentumMultiplier);
}

function ModifySirenScreamDamage(float Multiplier)
{
    OwnerMutator.CardGameRules.SirenScreamDamageMultiplier *= Multiplier;
    log("SirenScreamDamageMultiplier"@OwnerMutator.CardGameRules.SirenScreamDamageMultiplier);
}

function ModifySirenScreamRangeModifier(float Multiplier)
{
    OwnerMutator.CardGameRules.SirenScreamRangeModifier *= Multiplier;
    log("SirenScreamRangeModifier"@OwnerMutator.CardGameRules.SirenScreamRangeModifier);
}

function ModifyBloatMovementSpeed(float Multiplier)
{
    OwnerMutator.CardGameRules.BloatMovementSpeedModifier *= Multiplier;
    log("BloatMovementSpeedModifier"@OwnerMutator.CardGameRules.BloatMovementSpeedModifier);
}

function ModifyFleshpoundRageThreshold(float Multiplier)
{
    OwnerMutator.CardGameRules.FleshpoundRageThresholdModifier *= Multiplier;
    log("FleshpoundRageThresholdModifier"@OwnerMutator.CardGameRules.FleshpoundRageThresholdModifier);
}

function ModifyHuskRefireTime(float Multiplier)
{
    OwnerMutator.CardGameRules.HuskRefireTimeModifier *= Multiplier;
    log("HuskRefireTimeModifier"@OwnerMutator.CardGameRules.HuskRefireTimeModifier);
}

function ModifySirenScreamRange(float Multiplier)
{
    OwnerMutator.CardGameRules.SirenScreamRangeModifier *= Multiplier;
    log("SirenScreamRangeModifier"@OwnerMutator.CardGameRules.SirenScreamRangeModifier);
}

function ModifyScrakeRageThreshold(float Multiplier)
{
    OwnerMutator.CardGameRules.ScrakeRageThresholdModifier *= Multiplier;
    log("ScrakeRageThresholdModifier"@OwnerMutator.CardGameRules.ScrakeRageThresholdModifier);
}

function GrantThorns(float ThornsPower)
{
    OwnerMutator.CardGameRules.PlayerThornsDamageMultiplier *= ThornsPower;
    log("PlayerThornsDamageMultiplier"@OwnerMutator.CardGameRules.PlayerThornsDamageMultiplier);
}

function ModifyPlayerSpeed(float Multiplier)
{
    OwnerMutator.TurboCardGameModifier.PlayerMovementSpeedMultiplier *= Multiplier;
    TurboGameReplicationInfo(Level.GRI).NotifyPlayerMovementSpeedChanged();
    OwnerMutator.TurboCardGameModifier.ForceNetUpdate();
}

function ModifyPlayerAccel(float Multiplier)
{
    OwnerMutator.TurboCardGameModifier.PlayerMovementAccelMultiplier *= Multiplier;
    TurboGameReplicationInfo(Level.GRI).NotifyPlayerMovementSpeedChanged();
    OwnerMutator.TurboCardGameModifier.ForceNetUpdate();
}

function ModifyMovementFriction(float Multiplier)
{
    OwnerMutator.TurboCardClientModifier.GroundFrictionModifier *= Multiplier;
    OwnerMutator.TurboCardClientModifier.UpdatePhysicsVolumes();

    OwnerMutator.TurboCardClientModifier.ForceNetUpdate();
}

function ModifyPlayerMaxHealth(float Multiplier)
{
    OwnerMutator.TurboCardGameModifier.PlayerMaxHealthMultiplier *= Multiplier;
    TurboGameReplicationInfo(Level.GRI).NotifyPlayerMaxHealthChanged();
    OwnerMutator.TurboCardGameModifier.ForceNetUpdate();
}

function ModifyPlayerMaxCarryWeight(int Modifier)
{
    OwnerMutator.TurboCardGameModifier.PlayerMaxCarryWeightModifier += Modifier;
    log("PlayerMaxCarryWeightModifier"@OwnerMutator.TurboCardGameModifier.PlayerMaxCarryWeightModifier);
    TurboGameReplicationInfo(Level.GRI).NotifyPlayerCarryWeightChanged();
}

function ModifyPlayerLowHealthDamageBonus(float Multiplier)
{
    OwnerMutator.CardGameRules.LowHealthDamageMultiplier *= Multiplier;
    log("LowHealthDamageMultiplier"@OwnerMutator.CardGameRules.LowHealthDamageMultiplier);
}

function ModifyBodyArmorDamageModifier(float Multiplier)
{
    OwnerMutator.TurboCardGameModifier.BodyArmorDamageModifier *= Multiplier;
    log("BodyArmorDamageModifier"@OwnerMutator.TurboCardGameModifier.BodyArmorDamageModifier);
}

function EnableWaveMovementFreeze()
{
    OwnerMutator.TurboCardGameModifier.bFreezePlayersDuringWave = true;
    OwnerMutator.TurboCardGameModifier.ForceNetUpdate();
}

function EnableSuddenDeath()
{
    OwnerMutator.CardGameRules.bSuddenDeathEnabled = true;
    log("EnableSuddenDeath"@OwnerMutator.CardGameRules.bSuddenDeathEnabled);
}

function EnableMoneySlowsPlayers()
{
    OwnerMutator.TurboCardGameModifier.bMoneySlowsPlayers = true;
    log("bMoneySlowsPlayers"@OwnerMutator.TurboCardGameModifier.bMoneySlowsPlayers);
    OwnerMutator.TurboCardGameModifier.ForceNetUpdate();
}

function EnableMissingHealthStronglySlows()
{
    OwnerMutator.TurboCardGameModifier.bMissingHealthStronglySlows = true;
    log("bMissingHealthStronglySlows"@OwnerMutator.TurboCardGameModifier.bMissingHealthStronglySlows);
    OwnerMutator.TurboCardGameModifier.ForceNetUpdate();
}

function EnableCheatingDeath()
{
    OwnerMutator.CardGameRules.bCheatDeathEnabled = true;
    log("EnableCheatingDeath"@OwnerMutator.CardGameRules.bCheatDeathEnabled);
}

function EnableRussianRoulette()
{
    OwnerMutator.CardGameRules.bRussianRouletteEnabled = true;
    log("bRussianRouletteEnabled"@OwnerMutator.CardGameRules.bRussianRouletteEnabled);
}

function DisableSyringe()
{
    local array<TurboHumanPawn> HumanPawnList;
    local int Index;

    OwnerMutator.CardGameRules.bDisableSyringe = true;
    log("bDisableSyringe"@OwnerMutator.CardGameRules.bDisableSyringe);

    HumanPawnList = class'TurboGameplayHelper'.static.GetPlayerPawnList(Level);
    for (Index = HumanPawnList.Length - 1; Index >= 0; Index--)
    {
        OwnerMutator.CardGameRules.DestorySyringe(HumanPawnList[Index]);
    }
}

function EnablePlayerBleeding()
{
    if (BleedManager != None)
    {
        BleedManager.ModifyBleedCount(1.75f);
        return;
    }

    BleedManager = Spawn(class'PlayerBleedActor', Self);
}

function ModifyPlayerFallDamage(float Multiplier)
{
    OwnerMutator.CardGameRules.FallDamageTakenMultiplier *= Multiplier;
    log("WeaponPelletCountMultiplier"@OwnerMutator.CardGameRules.FallDamageTakenMultiplier);
}

function EnableBorrowedTime()
{
    if (BorrwedTimeManage != None)
    {
        return;
    }

    BorrwedTimeManage = Spawn(class'PlayerBorrowedTimeActor', Self);
}

function EnableNoRestForTheWicked()
{
    if (NoRestForTheWickedManager != None)
    {
        return;
    }

    NoRestForTheWickedManager = Spawn(class'PlayerNoRestForTheWickedActor', Self);
}

function EnableCurseOfRa()
{
    if (CurseOfRaManager != None)
    {
        return;
    }

    CurseOfRaManager = Spawn(class'CurseOfRaManager', Self);
    class'TurboWaveSpawnEventHandler'.static.RegisterWaveHandler(Self, class'CurseOfRawWaveEventHandler');
}

function EnableSuperGrenades()
{
    OwnerMutator.CardGameRules.bSuperGrenades = true;
    log("bSuperGrenades"@OwnerMutator.CardGameRules.bSuperGrenades);
}

function ModifyFriendlyFireScale(float FriendlyFireScaleModifier)
{
    if (FriendlyFireScaleModifier <= 1.f)
    {
        return;
    }

    if (TeamGame(OwnerMutator.Level.Game).FriendlyFireScale < 0.01f)
    {
        TeamGame(OwnerMutator.Level.Game).FriendlyFireScale = (FriendlyFireScaleModifier - 1.f);
    }
    else
    {
        TeamGame(OwnerMutator.Level.Game).FriendlyFireScale *= FriendlyFireScaleModifier;
    }
}

function EnablePlainSightSpawning()
{
    local int Index;
    local KFGameType KFGT;
    KFGT = KFGameType(Level.Game);

    for (Index = 0; Index < KFGT.ZedSpawnList.Length; Index++)
    {
        if (KFGT.ZedSpawnList[Index].bAllowPlainSightSpawns)
        {
            continue;
        }

        KFGT.ZedSpawnList[Index].MinDistanceToPlayer = FMax(768.f, KFGT.ZedSpawnList[Index].MinDistanceToPlayer);
        KFGT.ZedSpawnList[Index].bAllowPlainSightSpawns = true;
    }
}

function EnableRandomlyChangingTrader()
{
    if (RandomTraderManager != None)
    {
        return;
    }

    RandomTraderManager = Spawn(class'RandomTraderManager', Self);
}

defaultproperties
{
    bAlwaysRelevant=true
    bNetNotify=true
    SelectionCount = 3
    LastKnownActiveCardIndex = -1
}