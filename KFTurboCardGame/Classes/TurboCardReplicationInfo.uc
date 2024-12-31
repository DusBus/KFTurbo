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
var TurboCard AuthActiveCardList[MAX_ACTIVE_CARDS];
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
    local TurboHUDKillingFloor TurboHUD;
    TurboHUD = TurboHUDKillingFloor(PlayerController.myHUD);

    if (TurboHUD == None)
    {
        return;
    }

    TurboCardOverlay = Spawn(class'TurboCardOverlay', TurboHUD);
    TurboCardOverlay.Initialize(TurboHUD);
    TurboCardOverlay.InitializeCardGameHUD(Self);
    TurboHUD.AddPreDrawOverlay(TurboCardOverlay);
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

final function array<TurboCard> GetActiveCardList()
{
    local int Index;
    local array<TurboCard> CardList;

    CardList.Length = ArrayCount(AuthActiveCardList);

    for (Index = 0; Index < ArrayCount(AuthActiveCardList); Index++)
    {
        if (AuthActiveCardList[Index] != None)
        {
            continue;
        }

        CardList[Index] = AuthActiveCardList[Index];
        break;
    }

    CardList.Length = Index;
    return CardList;
}

final function array<TurboCard> GetSelectableCardList()
{
    local int Index;
    local array<TurboCard> CardList;

    CardList.Length = ArrayCount(AuthSelectableCardList);

    for (Index = 0; Index < ArrayCount(AuthSelectableCardList); Index++)
    {
        if (AuthSelectableCardList[Index] != None)
        {
            continue;
        }

        CardList[Index] = AuthSelectableCardList[Index];
        break;
    }

    CardList.Length = Index;
    return CardList;
}

//Sends vote result to stats.
function SendVoteResult(TurboCard SelectedCard)
{
    local TurboCardStatsTcpLink StatsTcpLink;

    StatsTcpLink = class'TurboCardStatsTcpLink'.static.FindStats(Level.Game);

    if (StatsTcpLink == None)
    {
        return;
    }

    StatsTcpLink.OnVoteComplete(GetActiveCardList(), GetSelectableCardList(), SelectedCard);
}

//Append to end of active card list this newly selected card. DO NOT PASS CARDREFERENCE-RESOLVED CARDS HERE.
function SelectCard(TurboCard SelectedCard, optional bool bFromVote)
{
    local int Index;
    
    if (SelectedCard == None)
    {
        return;
    }

    if (bFromVote)
    {
        SendVoteResult(SelectedCard);
    }
    
    for (Index = 0; Index < ArrayCount(ActiveCardList); Index++)
    {
        if (ResolveCard(ActiveCardList[Index]) != None)
        {
            continue;
        }

        ActiveCardList[Index] = GetCardReference(SelectedCard);
        AuthActiveCardList[Index] = SelectedCard;
        break;
    }

    SelectionUpdateCounter++;
    ClearSelection();

    log("Executing OnActivateCard delegate for"@SelectedCard.CardID, 'KFTurboCardGame');
    SelectedCard.OnActivateCard(OwnerMutator.TurboCardGameplayManagerInfo, SelectedCard, true);
    
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
    SelectCard(AuthSelectableCardList[Index], true);
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
        if (Level.GRI.PRIArray[Index].bOnlySpectator)
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
            SelectCard(AuthSelectableCardList[TiedVotingList[0]], true);
        }
        else if (TiedVotingList.Length > 1)
        {
            SelectCard(AuthSelectableCardList[TiedVotingList[Rand(TiedVotingList.Length)]], true);
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

        if (CardLRI == None)
        {
            continue;
        }

        CardLRI.ResetVote();
    }
}

defaultproperties
{
    bAlwaysRelevant=true
    bNetNotify=true
    SelectionCount = 3
    LastKnownActiveCardIndex = -1
}