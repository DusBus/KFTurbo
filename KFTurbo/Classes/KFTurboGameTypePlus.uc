// Killing Floor Turbo KFTurboGameTypePlus
// Distributed under the terms of the GPL-2.0 License.
// For more information see https://github.com/KFPilot/KFTurbo.
class KFTurboGameTypePlus extends KFTurboGameType;

var TurboMonsterCollection TurboMonsterCollection;

// Refers to the last squad we used to fill out NextSpawnSquad.
var TurboMonsterSquad CurrentSquad;
var float WaveNextSquadSpawnTime;

// Constants for initial game setup
const INITIAL_CASH = 42069;
const MIN_SPAWN_TIME = 0.01f;
const WAVE_COUNTDOWN = 60;

// Function called before the game begins
function PreBeginPlay()
{
    local ZombieVolume ZV;
	local ShopVolume Shop;
    Super.PreBeginPlay();

    // Adjust respawn time for each zombie volume
    foreach AllActors(Class'ZombieVolume', ZV)
    {
        if (ZV != None)
        {
            ZV.CanRespawnTime = FMin(ZV.CanRespawnTime, MIN_SPAWN_TIME);
        }
    }

    // Close all shops! We don't use them at this difficulty.
	foreach AllActors(Class'ShopVolume',Shop) 
	{
		Shop.bAlwaysClosed = true;
        Shop.bAlwaysEnabled = false;
	}
}

// Function called after the game begins
function PostBeginPlay()
{
    local KFLevelRules KFLR;

    Super.PostBeginPlay();

    // Find or spawn level rules
    foreach AllActors(class'KFLevelRules', KFLR)
    {
        break;
    }

    if (KFLR == None)
    {
        KFLR = Spawn(class'KFLevelRules');
    }

    // Set wave spawn period
    KFLR.WaveSpawnPeriod = MIN_SPAWN_TIME;

    StartingCash = INITIAL_CASH;
    MinRespawnCash = INITIAL_CASH;
    WaveNextSquadSpawnTime = MIN_SPAWN_TIME;

    Spawn(class'TurboZombieHuntManager', Self); //Always pull zombies out of hunting.
}

event InitGame( string Options, out string Error )
{
    SetFinalWaveOverride(7);
    KFGameLength = GL_Long;

    Super.InitGame(Options, Error);
}

// State to handle match progress
State MatchInProgress
{
    function BeginState()
    {
	    class'KFTurboMut'.static.FindMutator(Level.Game).SetGameType(Self, "turboplus");

        Super.BeginState();

        WaveCountDown = WAVE_COUNTDOWN;
        
        BroadcastLocalizedMessage(class'KFTurboPlusMessage', 0); //ETurboPlusMessage.TraderHint
    }

    // Don't select shops.
    function SelectShop() {}
    
    function float CalcNextSquadSpawnTime()
    {
        WaveNextSquadSpawnTime = TurboMonsterCollection.GetNextSquadSpawnTime(WaveNum, NumPlayers + NumBots);
        if (WaveNextSquadSpawnTime < MIN_SPAWN_TIME)
        {
            WaveNextSquadSpawnTime = MIN_SPAWN_TIME;
        }
        WaveNextSquadSpawnTime /= (GameWaveSpawnRateModifier * MapWaveSpawnRateModifier* AdminSpawnRateModifier);
        
        return WaveNextSquadSpawnTime;
    }

    function OpenShops()
    {
        local Controller C;
        local int Index;

        if (bTradingDoorsOpen)
        {
            return;
        }
    
        for (Index = 0; Index < ShopList.Length; Index++)
        {
            ShopList[Index].OpenShop();
        }
    
        bTradingDoorsOpen = True;

        for( C=Level.ControllerList; C!=None; C=C.NextController )
        {
            if( C.Pawn!=None && C.Pawn.Health>0 )
            {
                if( KFPlayerController(C) !=None )
                {
                    if ( WaveNum < FinalWave )
                    {
                        KFPlayerController(C).ClientLocationalVoiceMessage(C.PlayerReplicationInfo, none, 'TRADER', 2);
                    }
                    else
                    {
                        KFPlayerController(C).ClientLocationalVoiceMessage(C.PlayerReplicationInfo, none, 'TRADER', 3);
                    }

                    KFPlayerController(C).CheckForHint(31);
                    HintTime_1 = Level.TimeSeconds + 11;
                }
            }
        }

        BroadcastLocalizedMessage(class'KFTurboPlusMessage', 0); //ETurboPlusMessage.TraderHint
        
        Super.OpenShops();
    }

    // It's ok to call this I think.
    function CloseShops()
    {
        Super.CloseShops();
    }
}

function ResetZombieVolumes()
{
    local int Index;
    for(Index = ZedSpawnList.Length - 1; Index >= 0; Index-- )
    {
        ZedSpawnList[Index].Reset();
    }
}

function LoadUpMonsterList()
{
    local int Index;
    for( Index = Index; Index < MonsterCollection.default.MonsterClasses.Length; Index++ )
    {
        TurboMonsterCollection.LoadedMonsterList[TurboMonsterCollection.LoadedMonsterList.Length] = Class<KFMonster>(DynamicLoadObject(MonsterCollection.default.MonsterClasses[Index].MClassName,Class'Class', false));
        TurboMonsterCollection.LoadedMonsterList[TurboMonsterCollection.LoadedMonsterList.Length - 1].static.PreCacheAssets(Level);
    }

    TurboMonsterCollection.InitializeCollection();
}

function SetupWave()
{
    TraderProblemLevel = 0;
    ZombiesKilled = 0;
    WaveMonsters = 0;
    WaveNumClasses = 0;

    MaxMonsters = TurboMonsterCollection.GetWaveMaxMonsters(WaveNum, GameDifficulty, NumPlayers);
    MaxMonsters = float(MaxMonsters) * GameMaxMonstersModifier * MapMaxMonstersModifier * AdminMaxMonstersModifier;

    TotalMaxMonsters = CalculateTotalMaxMonster();
    KFGameReplicationInfo(Level.Game.GameReplicationInfo).MaxMonsters = TotalMaxMonsters;
    KFGameReplicationInfo(Level.Game.GameReplicationInfo).MaxMonstersOn = true;

    WaveNextSquadSpawnTime = TurboMonsterCollection.GetNextSquadSpawnTime(WaveNum, NumPlayers);
    if (WaveNextSquadSpawnTime < MIN_SPAWN_TIME)
    {
        WaveNextSquadSpawnTime = MIN_SPAWN_TIME;
    }
    WaveNextSquadSpawnTime /= (GameWaveSpawnRateModifier * MapWaveSpawnRateModifier * AdminSpawnRateModifier);

    WaveEndTime = Level.TimeSeconds + 255;
    AdjustedDifficulty = GameDifficulty + TurboMonsterCollection.GetWaveDifficulty(WaveNum);

    ResetZombieVolumes();
    SquadsToUse.Length = 0;

    TurboMonsterCollection.InitializeForWave(WaveNum);

    BuildNextSquad();
    
    ClearTraderEndVotes();
    class'KFTurboMut'.static.FindMutator(Self).OnWaveStart();
	class'TurboWaveEventHandler'.static.BroadcastWaveStarted(Self, WaveNum);
}

function int CalculateTotalMaxMonster()
{
    return float(TurboMonsterCollection.GetWaveTotalMonsters(WaveNum, GameDifficulty, GetMaxMonsterPlayerCount())) * GameTotalMonstersModifier;
}

function AddSpecialSquad()
{
    BuildNextSquad();
}

function BuildNextSquad()
{
    local TurboMonsterSquad Squad;

    if (NextSpawnSquad.Length != 0)
    {
        return;
    }

    Squad = TurboMonsterCollection.GetNextMonsterSquad();

    if (Squad == None)
    {
        return;
    }

    //Update this each time a squad is set so that it scales as players die.
    MaxMonsters = TurboMonsterCollection.GetWaveMaxMonsters(WaveNum, GameDifficulty, NumPlayers + NumBots);

    NextSpawnSquad = Squad.MonsterList;
    CurrentSquad = Squad;
    
	class'TurboWaveSpawnEventHandler'.static.BroadcastNextSpawnSquadGenerated(Self, NextSpawnSquad);
}

function AddBossBuddySquad()
{
    local int TempMaxMonsters, NumMonstersSpawned, TotalZombiesValue;
    local int MaxAttemptCount;

    TurboMonsterCollection.ApplyFinalSquad(FinalSquadNum, NumPlayers + NumBots, NextSpawnSquad);
    FinalSquadNum++;

    LastZVol = FindSpawningVolume();

    if(LastZVol != None)
    {
        LastSpawningVolume = LastZVol;
    }

    if(LastZVol == None)
    {
        LastZVol = FindSpawningVolume();

        if(LastZVol != None)
        {
            LastSpawningVolume = LastZVol;
        }
    }

    if (LastZVol == None)
    {
        return;
    }

    NumMonstersSpawned = 0;
    TempMaxMonsters = 999;
    MaxAttemptCount = NextSpawnSquad.Length;

    while (MaxAttemptCount >= 0 && NextSpawnSquad.Length > 0)
    {
        MaxAttemptCount--;

        if(LastZVol.SpawnInHere(NextSpawnSquad,,NumMonstersSpawned, TempMaxMonsters, 999, TotalZombiesValue))
        {
            NumMonsters += NumMonstersSpawned;
            WaveMonsters += NumMonstersSpawned;
            NextSpawnSquad.Remove(0, NumMonstersSpawned);
        }
    }
}

// Default properties for the game type
defaultproperties
{
    bIsHighDifficulty = true

	Begin Object Name=TurboPlusMonsterCollectionWaveImpl0 Class=TurboPlusMonsterCollectionWaveImpl
	End Object
    TurboMonsterCollection=TurboPlusMonsterCollectionWaveImpl'TurboPlusMonsterCollectionWaveImpl0'

    LongWaves(0)=(WaveMask=4032,WaveMaxMonsters=40,WaveDifficulty=2.000000)
    LongWaves(1)=(WaveMask=4032,WaveMaxMonsters=45,WaveDifficulty=2.000000)
    LongWaves(2)=(WaveMask=4032,WaveMaxMonsters=45,WaveDifficulty=2.000000)
    LongWaves(3)=(WaveMask=4032,WaveMaxMonsters=50,WaveDifficulty=2.000000)
    LongWaves(4)=(WaveMask=258048,WaveMaxMonsters=50,WaveDifficulty=2.000000)
    LongWaves(5)=(WaveMask=258042,WaveMaxMonsters=55,WaveDifficulty=2.000000)
    LongWaves(6)=(WaveMask=16515072,WaveMaxMonsters=60,WaveDifficulty=2.000000)
    LongWaves(7)=(WaveMask=16515072,WaveMaxMonsters=60,WaveDifficulty=2.000000)
    LongWaves(8)=(WaveMask=16515072,WaveMaxMonsters=60,WaveDifficulty=2.000000)
    LongWaves(9)=(WaveMask=16515072,WaveMaxMonsters=60,WaveDifficulty=2.000000)

    MonsterCollection=Class'KFTurbo.MC_DEF'

    StandardMonsterSquads=()
    MonsterSquad=()
    FinalSquads=()
    MonsterClasses=()

    SpecialEventMonsterCollections(0)=Class'KFTurbo.MC_Turbo'
    SpecialEventMonsterCollections(1)=Class'KFTurbo.MC_Turbo'
    SpecialEventMonsterCollections(2)=Class'KFTurbo.MC_Turbo'
    SpecialEventMonsterCollections(3)=Class'KFTurbo.MC_Turbo'

    MapPrefix="KF"
    BeaconName="KF"
    Acronym="KF"

    GameName = "Killing Floor Turbo+ Game Type"
    Description = "Turbo+ mode of the Killing Floor Game Type."
    ScreenShotName = "KFTurbo.Generic.KFTurbo_FB"
}
