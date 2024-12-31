//Killing Floor Turbo TurboCardStatsTcpLink
//Sends data regarding card voting to a specified place.
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboCardStatsTcpLink extends TcpLink;

var globalconfig bool bBroadcastAnalytics;
var globalconfig string CardStatsDomain;
var globalconfig int CardStatsPort;
var globalconfig string StatsTcpLinkClassOverride;

var IpAddr CardStatsAddress;

var string CRLF;

//Cached list of shown cards. Slowly built up using SendVote()'s VoteSelectionList.
var array<TurboCard> ShownCardList;

static function bool ShouldBroadcastAnalytics()
{
    return default.bBroadcastAnalytics && default.CardStatsDomain != "" && default.CardStatsPort >= 0;
}

static function class<TurboCardStatsTcpLink> GetCardStatsTcpLinkClass()
{
    local class<TurboCardStatsTcpLink> TcpLinkClass;
    if (default.StatsTcpLinkClassOverride != "")
    {
        TcpLinkClass = class<TurboCardStatsTcpLink>(DynamicLoadObject(default.StatsTcpLinkClassOverride, class'class'));
    }

    if (TcpLinkClass == None)
    {
        TcpLinkClass = class'TurboCardStatsTcpLink';
    }

    return TcpLinkClass;
}

//static final function KFTurboCardGameMut FindMutator(GameInfo GameInfo)
static final function TurboCardStatsTcpLink FindStats(GameInfo GameInfo)
{
    local KFTurboCardGameMut CardGameMut;
    CardGameMut = class'KFTurboCardGameMut'.static.FindMutator(GameInfo);

    if (CardGameMut == None)
    {
        return None;
    }

    return CardGameMut.TurboCardStats;
}

function PostBeginPlay()
{
    log("KFTurbo Card Game is starting up stats TCP link!", 'KFTurboCardGame');

	CRLF = Chr(13) $ Chr(10);

    LinkMode = MODE_Text;
    ReceiveMode = RMODE_Event;
    BindPort();
    Resolve(CardStatsDomain);
}

event Resolved(IpAddr ResolvedAddress)
{
    CardStatsAddress = ResolvedAddress;
    CardStatsAddress.Port = CardStatsPort;

    if (!OpenNoSteam(CardStatsAddress))
    {
        Close();
        LifeSpan = 1.f;
    }
}

event ResolveFailed()
{
    log("Failed to resolve version domain.", 'KFTurboCardGame');

    if (!OpenNoSteam(CardStatsAddress))
    {
        Close();
        LifeSpan = 1.f;
    }
}

function Opened()
{
    log("Connection to"@CardStatsDomain@"opened.", 'KFTurboCardGame');
}

//Analytics event for a vote that occurred.
function OnVoteComplete(array<TurboCard> ActiveCardList, array<TurboCard> VoteSelectionList, TurboCard SelectedCard)
{
    local int ShownStartingIndex, Index;

    //Append vote selection to shown cards.
    ShownStartingIndex = ShownCardList.Length;
    ShownCardList.Length = ShownCardList.Length + VoteSelectionList.Length;
    for (Index = 0; Index < VoteSelectionList.Length; Index++)
    {
        ShownCardList[ShownStartingIndex + Index] = VoteSelectionList[Index];
    }

    SendText(BuildVotePayload(Level.Game.GetCurrentWaveNum() - 1, ConvertCardToCardID(ActiveCardList), ConvertCardToCardID(VoteSelectionList), SelectedCard.CardID));
}

/*
Data payload for a vote looks like the following;

{
    "version": "4.4.1",
    "wavenum" : 8,
    "activecards" : ["CARD1", "CARD2", "CARD3", "CARD4", "CARD5", "CARD6", "CARD7"],
    "voteselection" : ["CARD8", "CARD9", "CARD10"],
    "votedcard" : "CARD9"
}

version - The KFTurbo version currently running.
wavenum - The wave this vote data came from during the game.
activecards - The cards that have been selected so far.
voteselection - The cards to vote on for this round of voting.
votedcard - The card that was ultimately selected.
*/

static final function string BuildVotePayload(int WaveNumber, array<string> ActiveCardList, array<string> VoteSelectionList, string VotedCardList)
{
    local string Payload;
    local string QC;
    QC = Chr(34);

    Payload = "{"$QC$"version"$QC$":"$QC$class'KFTurboMut'.static.GetTurboVersionID()$QC$",";
    Payload $= QC$"wavenum"$QC$":"$WaveNumber$",";
    Payload $= QC$"activecards"$QC$":["$ConvertToString(ActiveCardList)$"],";
    Payload $= QC$"voteselection"$QC$":["$ConvertToString(VoteSelectionList)$"],";
    Payload $= QC$"votedcard"$QC$":"$VotedCardList$"}";
    
    return Payload;
}

function OnGameEnd(int WaveNumber, bool bWonGame, array<TurboCard> ActiveCardList)
{
    SendText(BuildEndGamePayload(WaveNumber, bWonGame, ConvertCardToCardID(ActiveCardList), ConvertCardToCardID(ShownCardList)));
}

/*
Data payload for a game end looks like the following;

{
    "version": "4.4.1",
    "win" : false,
    "wavenum" : 3,
    "activecards" : ["CARD2", "CARD4", "CARD8"],
    "showncards" : ["CARD1", "CARD3", "CARD5", ...]
}

version - The KFTurbo version currently running.
win - Whether or not this game resulted in a win or not.
wavenum - The wave this game ended on.
activecards - The cards that were selected during the game.
showncards - The cards that were not selected during the game.
*/

//Analytics event for a game ending.
static final function string BuildEndGamePayload(int WaveNumber, bool bWonGame, array<string> ActiveCardList, array<string> ShownCardList)
{
    local string Payload;
    local string QC;
    QC = Chr(34);

    Payload = "{"$QC$"version"$QC$":"$QC$class'KFTurboMut'.static.GetTurboVersionID()$QC$",";
    Payload $= QC$"win"$QC$":"$bWonGame$",";
    Payload $= QC$"wavenum"$QC$":"$WaveNumber$",";
    Payload $= QC$"activecards"$QC$":["$ConvertToString(ActiveCardList)$"],";
    Payload $= QC$"showncards"$QC$":["$ConvertToString(ShownCardList)$"]}";
    
    return Payload;
}

static final function string ConvertToString(array<string> StringList)
{
    local string Result;
    local int Index;
    local string QuoteChar;
    QuoteChar = Chr(34);

    Result = "";

    for (Index = 0; Index < StringList.Length; Index++)
    {
        Result $= QuoteChar$StringList[Index]$QuoteChar;

        if (Index < StringList.Length - 1)
        {
            Result $= ",";
        }
    }

    return Result;
}

static final function array<string> ConvertCardToCardID(array<TurboCard> CardList)
{
    local array<string> Result;
    local int Index;

    Result.Length = CardList.Length;

    for (Index = 0; Index < CardList.Length; Index++)
    {
        Result[Index] = CardList[Index].CardID;
    }

    return Result;
}


defaultproperties
{
    LinkMode=MODE_Text

    bBroadcastAnalytics=false
    CardStatsDomain="";
    CardStatsPort=-1;
    StatsTcpLinkClassOverride=""
}