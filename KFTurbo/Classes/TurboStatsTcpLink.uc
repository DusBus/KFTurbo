//Killing Floor Turbo TurboStatsTcpLink
//Sends data regarding player stats to a specified place.
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboStatsTcpLink extends TcpLink
    config(KFTurbo);

var globalconfig bool bBroadcastAnalytics;
var globalconfig string StatsDomain;
var globalconfig int StatsPort;
var globalconfig string StatsTcpLinkClassOverride;

var IpAddr StatsAddress;

var string CRLF;

static function bool ShouldBroadcastAnalytics()
{
    return default.bBroadcastAnalytics && default.StatsDomain != "" && default.StatsPort >= 0;
}

static function class<TurboStatsTcpLink> GetStatsTcpLinkClass()
{
    local class<TurboStatsTcpLink> TcpLinkClass;
    if (default.StatsTcpLinkClassOverride != "")
    {
        TcpLinkClass = class<TurboStatsTcpLink>(DynamicLoadObject(default.StatsTcpLinkClassOverride, class'class'));
    }

    if (TcpLinkClass == None)
    {
        TcpLinkClass = class'TurboStatsTcpLink';
    }

    return TcpLinkClass;
}

static final function TurboStatsTcpLink FindStats(GameInfo GameInfo)
{
    local KFTurboMut CardGameMut;
    CardGameMut = class'KFTurboMut'.static.FindMutator(GameInfo);

    if (CardGameMut == None)
    {
        return None;
    }

    return CardGameMut.StatsTcpLink;
}

function PostBeginPlay()
{
    log("KFTurbo is starting up stats TCP link!", 'KFTurbo');

	CRLF = Chr(13) $ Chr(10);

    LinkMode = MODE_Text;
    ReceiveMode = RMODE_Event;
    BindPort();
    Resolve(StatsDomain);
}

event Resolved(IpAddr ResolvedAddress)
{
    StatsAddress = ResolvedAddress;
    StatsAddress.Port = StatsPort;

    if (!OpenNoSteam(StatsAddress))
    {
        Close();
        LifeSpan = 1.f;
    }
}

event ResolveFailed()
{
    log("Failed to resolve stats domain.", 'KFTurbo');

    Close();
    LifeSpan = 1.f;
}

function Opened()
{
    log("Connection to"@StatsDomain@"opened.", 'KFTurbo');
}

/*
Data payload for a player's wave stats looks like the following;

{
    "type": "wavestats",
    "version": "5.2.2",
    "wavenum" : 8,
    "player" : "<steam ID>",
    "playername" : "Player Name",
    "stats" :
        {
         "Kills"  : 2,
         "Damage" : 1000
        },
    "died" : false
}

type - refers to the type of payload this is.
version - The KFTurbo version currently running.
wavenum - The wave this vote data came from during the game.
player - the steam ID of the player this payload is for.
playername - the username of the player this payload is for.
stats - A map of tracked non-zero stats accrued during the wave.
    Map key list: Kills, KillsFP, KillsSC, Damage, DamageFP, DamageSC, ShotsFired, MeleeSwings, ShotsHit, ShotsHeadshot, Reloads, Heals.
died - Wether or not the player died this wave.
*/

final function SendWaveStats(TurboWavePlayerStatCollector Stats)
{
    if (Stats == None)
    {
        return;
    }

    SendText(BuildWaveStatsPayload(Stats));
}

static final function string BuildWaveStatsPayload(TurboWavePlayerStatCollector Stats)
{
    local string Payload;

    Payload = "{%qtype%q:%qwavestats%q,";
    Payload $= "%qversion%q:%q"$class'KFTurboMut'.static.GetTurboVersionID()$"%q,";
    Payload $= "%qwavenum%q:"$Stats.Wave$",";
    Payload $= "%qplayer%q:"$Stats.GetPlayerSteamID()$",";
    Payload $= "%qplayername%q:"$Stats.GetPlayerName()$",";
    Payload $= "%qstats%q:{"$BuildStatsMap(Stats)$"},";
    Payload $= "%died%q:"$(Stats.Deaths > 0)$"}";
    
    Payload = Repl(Payload, "%q", Chr(34));
    return Payload;
}

static final function string BuildStatsMap(TurboWavePlayerStatCollector Stats)
{
    local string StatMap;
    StatMap = "";
    StatMap $= AppendStat("Kills", Stats.Kills);
    StatMap $= AppendStat("KillsFP", Stats.KillsFleshpound);
    StatMap $= AppendStat("KillsSC", Stats.KillsScrake);
    
    StatMap $= AppendStat("Damage", Stats.DamageDone);
    StatMap $= AppendStat("DamageFP", Stats.DamageDoneFleshpound);
    StatMap $= AppendStat("DamageSC", Stats.DamageDoneScrake);
    
    StatMap $= AppendStat("ShotsFired", Stats.ShotsFired);
    StatMap $= AppendStat("MeleeSwings", Stats.MeleeSwings);
    StatMap $= AppendStat("ShotsHit", Stats.ShotsHit);
    StatMap $= AppendStat("ShotsHeadshot", Stats.ShotsHeadshot);

    StatMap $= AppendStat("Reloads", Stats.Reloads);

    StatMap $= AppendStat("Heals", Stats.HealingDone);

    //Remove starting comma.
    if (StatMap != "" && Left(StatMap, 1) == ",")
    {
        StatMap = Mid(StatMap, 1);
    }

    return StatMap;
}

static final function string AppendStat(string StatName, int StatAmount)
{
    if (StatAmount <= 0)
    {
        return "";
    }

    return ",%q"$StatName$"%q : "$StatAmount;
}

defaultproperties
{
    LinkMode=MODE_Text

    bBroadcastAnalytics=false
    StatsDomain="";
    StatsPort=-1;
    StatsTcpLinkClassOverride=""
}