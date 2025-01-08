//Killing Floor Turbo TurboStatsGameRules
//Responsible for managing stat collectors/replications and broadcasting events related to kills/damage.
//Needs to be at the front of the GameRules list so it can make sure all rules have gone first.
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboStatsGameRules extends TurboGameRules
	config(KFTurbo);

//Used during spin up state.
var bool bGeneratingStatCollectors;
var array<TurboHumanPawn> PawnList;
var int PawnListIndex;

//Used during spin down state.
var bool bReplicatingStatCollectors;
var array<TurboPlayerController> ControllerList;
var int ControllerListIndex;

var KFTurboGameType TurboGameType;
var KFTurboMut Mutator;

//Turns on collector/replicator system. False for now until tested.
var globalconfig bool bEnableStatCollector;

function PostBeginPlay()
{
    Super.PostBeginPlay();

    TurboGameType = KFTurboGameType(Level.Game);
    Mutator = KFTurboMut(Owner);
}

function int NetDamage(int OriginalDamage, int Damage, Pawn Injured, Pawn InstigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType)
{
    Damage = Super.NetDamage(OriginalDamage, Damage, Injured, InstigatedBy, HitLocation, Momentum, DamageType);

    if (InstigatedBy != None && KFMonster(Injured) != None)
    {
        class'TurboPlayerEventHandler'.static.BroadcastPlayerDamagedMonster(InstigatedBy.Controller, KFMonster(Injured), Damage);
    }

    return Damage;
}

function Killed(Controller Killer, Controller Killed, Pawn KilledPawn, class<DamageType> DamageType)
{
    Super.Killed(Killer, Killed, KilledPawn, DamageType);

    if (KFMonster(KilledPawn) != None)
    {
        class'TurboPlayerEventHandler'.static.BroadcastPlayerKilledMonster(Killer, KFMonster(KilledPawn), DamageType);
    }

    if (TurboPlayerController(Killed) != None)
    {
        class'TurboPlayerEventHandler'.static.BroadcastPlayerDied(TurboPlayerController(Killed), Killer, DamageType);
    }
}

//Does initial kick-off.
function Tick(float DeltaTime)
{
    if (!bEnableStatCollector || class'KFTurboGameType'.static.StaticIsTestGameType(Self))
    {
        Disable('Tick');
        return;
    }
    
    if (!TurboGameType.bWaveInProgress)
    {
        return;
    }

    GotoState('WaveStart');
}

state WaveStart
{
    function Tick(float DeltaTime)
    {
        if (bGeneratingStatCollectors)
        {
            return;
        }

        if (TurboGameType.bWaveInProgress)
        {
            return;
        }

        GotoState('WaveEnd');
    }

Begin:
    bGeneratingStatCollectors = true;
    PawnList = class'TurboGameplayHelper'.static.GetPlayerPawnList(Level);
    for (PawnListIndex = 0; PawnListIndex < PawnList.Length; PawnListIndex++)
    {
        Sleep(0.1f);
        CreateStatCollector(PawnList[PawnListIndex]);
    }
    bGeneratingStatCollectors = false;
}

state WaveEnd
{
    function Tick(float DeltaTime)
    {
        if (bReplicatingStatCollectors)
        {
            return;
        }

        if (!TurboGameType.bWaveInProgress)
        {
            return;
        }

        GotoState('WaveStart');
    }

Begin:
    bReplicatingStatCollectors = true;
    ControllerList = class'TurboGameplayHelper'.static.GetPlayerControllerList(Level);
    for (ControllerListIndex = 0; ControllerListIndex < ControllerList.Length; ControllerListIndex++)
    {
        Sleep(0.1f);
        ReplicateStatCollector(ControllerList[ControllerListIndex]);
    }
    bReplicatingStatCollectors = false;
}

function CreateStatCollector(TurboHumanPawn Pawn)
{
    if (Pawn == None || Pawn.Health < 0 || Pawn.PlayerReplicationInfo == None || Pawn.PlayerReplicationInfo.bOnlySpectator || Pawn.PlayerReplicationInfo.bBot)
    {
        return;
    }

    Spawn(class'TurboWavePlayerStatCollector', Pawn.PlayerReplicationInfo);
}

function ReplicateStatCollector(TurboPlayerController Controller)
{
    local TurboPlayerStatCollectorBase StatsCollector;
    StatsCollector = class'TurboWavePlayerStatCollector'.static.FindStats(TurboPlayerReplicationInfo(Controller.PlayerReplicationInfo));

    if (StatsCollector == None)
    {
        return;
    }
    
    if (Mutator != None && Mutator.StatsTcpLink != None)
    {
        Mutator.StatsTcpLink.SendWaveStats(TurboWavePlayerStatCollector(StatsCollector));
    }

    StatsCollector.ReplicateStats();
}

defaultproperties
{
    bEnableStatCollector=true
}