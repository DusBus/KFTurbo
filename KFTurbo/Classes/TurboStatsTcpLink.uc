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
    local KFTurboMut TurboMut;
    TurboMut = class'KFTurboMut'.static.FindMutator(GameInfo);
    return TurboMut.StatsTcpLink;
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
    log("Resolved domain"@StatsDomain$".", 'KFTurbo');
    StatsAddress = ResolvedAddress;
    StatsAddress.Port = StatsPort;

    if (!OpenNoSteam(StatsAddress))
    {
        log("OpenNoSteam failed for"@StatsDomain$"!", 'KFTurbo');
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
Data payload for a game starting looks like the following;

{
    "type": "gamebegin",
    "version": "5.2.2",
    "session": "<session ID>",
    "gametype" : "turbo"
}

type - refers to the type of payload this is.
version - The KFTurbo version currently running.
session - The session ID for this game."
gametype - The type of game being played. Can be "turbo", "turbocardgame", "turborandomizer", "turboplus".
*/

function SendGameStart()
{
    SendText(BuildGameStartPayload());
}

final function string BuildGameStartPayload()
{
    local string Payload;
    local KFTurboMut Mutator;
    Mutator = class'KFTurboMut'.static.FindMutator(Level.Game);

    Payload = "{%qtype%q:%qgamebegin%q,";
    Payload $= "%qversion%q:%q"$Mutator.GetTurboVersionID()$"%q,";
    Payload $= "%qsession%q:%q"$Mutator.GetSessionID()$"%q,";
    Payload $= "%qgametype%q:%q"$Mutator.GetGameType()$"%q}";
    
    Payload = Repl(Payload, "%q", Chr(34));
    return Payload;
}

/*
Data payload for a game ending looks like the following;

{
    "type": "gameend",
    "version": "5.2.2",
    "session": "<session ID>",
    "wavenum" : 3,
    "result" : "won"
}

type - refers to the type of payload this is.
version - The KFTurbo version currently running.
session - The session ID for this game."
wavenum - The wave this game ended on.
result - The result of the game. Can be "won", "lost", "aborted". Aborted refers to a map vote that occurred without a game end state being reached.
*/

function SendGameEnd(int Result)
{
    SendText(BuildGameEndPayload(Level.Game.GetCurrentWaveNum(), GetResultName(Result)));
}

final function string BuildGameEndPayload(int WaveNum, string Result)
{
    local string Payload;
    local KFTurboMut Mutator;
    Mutator = class'KFTurboMut'.static.FindMutator(Level.Game);

    Payload = "{%qtype%q:%qgameend%q,";
    Payload $= "%qversion%q:%q"$Mutator.GetTurboVersionID()$"%q,";
    Payload $= "%qsession%q:%q"$Mutator.GetSessionID()$"%q,";
    Payload $= "%qwavenum%q:"$WaveNum$",";
    Payload $= "%qresult%q:%q"$Result$"%q}";
    
    Payload = Repl(Payload, "%q", Chr(34));
    return Payload;
}

/*
Data payload for a wave starting looks like the following;

{
    "type": "gameend",
    "version": "5.2.2",
    "session": "<session ID>",
    "wavenum" : 2,
    "playerlist" : ["<steam ID 1>","<steam ID 2>", "<steam ID 3>", ...]
}

type - refers to the type of payload this is.
version - The KFTurbo version currently running.
session - The session ID for this game."
wavenum - The wave that started.
playerlist - The Steam IDs of the players in the game at the wave start.
*/

function SendWaveStart()
{
    SendText(BuildWaveStartPayload(Level.Game.GetCurrentWaveNum()));
}

final function string BuildWaveStartPayload(int WaveNum)
{
    local string Payload;
    local KFTurboMut Mutator;
    Mutator = class'KFTurboMut'.static.FindMutator(Level.Game);

    Payload = "{%qtype%q:%qwavestart%q,";
    Payload $= "%qversion%q:%q"$Mutator.GetTurboVersionID()$"%q,";
    Payload $= "%qsession%q:%q"$Mutator.GetSessionID()$"%q,";
    Payload $= "%qwavenum%q:"$WaveNum$",";
    Payload $= "%qplayerlist%q:["$GetPlayerList()$"]}";
    
    Payload = Repl(Payload, "%q", Chr(34));
    return Payload;
}

/*
Data payload for a player's wave stats looks like the following;

{
    "type": "wavestats",
    "version": "5.2.2",
    "session": "<session ID>",
    "wavenum" : 8,
    "player" : "<steam ID>",
    "playername" : "Player Name",
    "perk" : "<perk name>",
    "stats" :
        {
         "Kills"  : 2,
         "Damage" : 1000
        },
    "died" : false
}

type - refers to the type of payload this is.
version - The KFTurbo version currently running.
session - The session ID for this game.
wavenum - The wave this vote data came from during the game.
player - the steam ID of the player this payload is for.
playername - the username of the player this payload is for.
perk - the perk this player was during the wave.
stats - A map of tracked non-zero stats accrued during the wave.
    Map key list: Kills, KillsFP, KillsSC, Damage, DamageFP, DamageSC, ShotsFired, MeleeSwings, ShotsHit, ShotsHeadshot, Reloads, Heals, DamageTaken.
died - Wether or not the player died this wave.
*/

function SendWaveStats(TurboWavePlayerStatCollector Stats)
{
    if (Stats == None)
    {
        return;
    }

    SendText(BuildWaveStatsPayload(Stats));
}

final function string BuildWaveStatsPayload(TurboWavePlayerStatCollector Stats)
{
    local string Payload;
    local KFTurboMut TurboMut;
    TurboMut = class'KFTurboMut'.static.FindMutator(Level.Game);

    Payload = "{%qtype%q:%qwavestats%q,";
    Payload $= "%qversion%q:%q"$TurboMut.GetTurboVersionID()$"%q,";
    Payload $= "%qsession%q:%q"$TurboMut.GetSessionID()$"%q,";
    Payload $= "%qwavenum%q:"$Stats.Wave$",";
    Payload $= "%qplayer%q:%q"$Stats.GetPlayerSteamID()$"%q,";
    Payload $= "%qplayername%q:%q"$Stats.GetPlayerName()$"%q,";
    Payload $= "%qperk%q:%q"$GetPerkID(Stats.PlayerTPRI)$"%q,";
    Payload $= "%qstats%q:{"$BuildStatsMap(Stats)$"},";
    Payload $= "%qdied%q:"$Locs(string(Stats.Deaths > 0))$"}";
    
    Payload = Repl(Payload, "%q", Chr(34));
    return Payload;
}

static final function string GetPerkID(TurboPlayerReplicationInfo TPRI)
{
    if (TPRI == None || TPRI.ClientVeteranSkill == None)
    {
        return "NONE";
    }

    switch(TPRI.ClientVeteranSkill)
    {
        case class'KFTurbo.V_FieldMedic':
            return "MED";
        case class'KFTurbo.V_SupportSpec':
            return "SUP";
        case class'KFTurbo.V_Sharpshooter':
            return "SHA";
        case class'KFTurbo.V_Commando':
            return "COM";
        case class'KFTurbo.V_Berserker':
            return "BER";
        case class'KFTurbo.V_Firebug':
            return "FIR";
        case class'KFTurbo.V_Demolitions':
            return "DEM";
    }

    return "NONE";
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

    return ",%q"$StatName$"%q:"$StatAmount;
}

static final function string GetResultName(int GameResult)
{
    switch(GameResult)
    {
        case 1:
            return "won";
        case 2:
            return "lost";
    }

    return "aborted";
}

final function string GetPlayerList()
{
    local Controller C;
    local string PlayerList;
    PlayerList = "";

    for (C = Level.ControllerList; C != None; C = C.NextController)
    {
        if (!C.bIsPlayer || C.PlayerReplicationInfo == None || C.PlayerReplicationInfo.bOnlySpectator || PlayerController(C) == None)
        {
            continue;
        }

        PlayerList $= ",%q"$PlayerController(C).GetPlayerIDHash()$"%q";
    }

    if (PlayerList != "" && Left(PlayerList, 1) == ",")
    {
        PlayerList = Mid(PlayerList, 1);
    }

    return PlayerList;
}

defaultproperties
{
    LinkMode=MODE_Text

    bBroadcastAnalytics=false
    StatsDomain="";
    StatsPort=-1;
    StatsTcpLinkClassOverride=""
}