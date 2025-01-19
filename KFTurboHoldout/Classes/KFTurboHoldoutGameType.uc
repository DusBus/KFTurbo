// Killing Floor Turbo KFTurboHoldoutGameType
// Distributed under the terms of the GPL-2.0 License.
// For more information see https://github.com/KFPilot/KFTurbo.
class KFTurboHoldoutGameType extends KFTurboGameTypePlus;

const HOLDOUT_WAVE_COUNTDOWN = 5;

function PreBeginPlay()
{
	local ShopVolume Shop;
    Super(KFTurboGameType).PreBeginPlay();

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

    StartingCash = 100;
    MinRespawnCash = 100;
    WaveNextSquadSpawnTime = MIN_SPAWN_TIME;
}

event InitGame( string Options, out string Error )
{
    SetFinalWaveOverride(20);
    KFGameLength = GL_Long;

    Super(KFTurboGameType).InitGame(Options, Error);
}

event BroadcastLocalizedMessage( class<LocalMessage> MessageClass, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
    //Never broadcast these.
    if (class<WaitingMessage>(MessageClass) != None)
    {
        return;
    }    

    Super.BroadcastLocalizedMessage(MessageClass, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}

// State to handle match progress
State MatchInProgress
{
    function BeginState()
    {
	    class'KFTurboMut'.static.FindMutator(Level.Game).SetGameType(Self, "turboholdout");

        Super(KFTurboGameType).BeginState();

        WaveCountDown = HOLDOUT_WAVE_COUNTDOWN;
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
        bTradingDoorsOpen = true;
    }

    function CloseShops()
    {
        bTradingDoorsOpen = false;
    }

    function DoWaveEnd()
    {
        local KFDoorMover KFDM;
        
        RewardSurvivingPlayers();

        bWaveInProgress = false;
        bWaveBossInProgress = false;
        bNotifiedLastManStanding = false;
        KFGameReplicationInfo(GameReplicationInfo).bWaveInProgress = false;

        WaveCountDown = HOLDOUT_WAVE_COUNTDOWN;
        KFGameReplicationInfo(GameReplicationInfo).TimeToNextWave = HOLDOUT_WAVE_COUNTDOWN;
        WaveNum++;
        InvasionGameReplicationInfo(GameReplicationInfo).WaveNumber = WaveNum;

        PerformPendingVeterancyChanges();

        bUpdateViewTargs = true;

        foreach DynamicActors(class'KFDoorMover', KFDM)
        {
            KFDM.RespawnDoor();
        }

        class'KFTurboMut'.static.FindMutator(Self).OnWaveEnd();
		class'TurboWaveEventHandler'.static.BroadcastWaveEnded(Self, WaveNum - 1);
    }
}

function PerformPendingVeterancyChanges()
{
    local array<TurboPlayerController> PlayerList;
    local int Index;
    local TurboPlayerReplicationInfo TPRI;
    PlayerList = class'TurboGameplayHelper'.static.GetPlayerControllerList(Level);

    for (Index = 0; Index < PlayerList.Length; Index++)
    {
        TPRI = TurboPlayerReplicationInfo(PlayerList[Index].PlayerReplicationInfo);
        if (TPRI == None)
        {
            continue;
        }

        PlayerList[Index].bChangedVeterancyThisWave = false;

        if (TPRI.ClientVeteranSkill == PlayerList[Index].SelectedVeterancy)
        {
            continue;
        }

        PlayerList[Index].SendSelectedVeterancyToServer();
    }
}

function SetupWave()
{
    Super.SetupWave();
    
    WaveNextSquadSpawnTime = MIN_SPAWN_TIME; 
}

final function float GetScoreMultiplier()
{
    local float Multiplier;
    Multiplier = 1.f;

    if (GameDifficulty >= 5.0)
    {
        Multiplier *= 0.65;
    }
    else if (GameDifficulty >= 4.0)
    {
        Multiplier *= 0.85;
    }
    else if (GameDifficulty >= 2.0)
    {
        Multiplier *= 1.0;
    }
    else
    {
        Multiplier *= 2.0;
    }

    return Multiplier;
}

//Removed all team and assist scoring mechanisms.
function ScoreKill(Controller Killer, Controller Other)
{
    local PlayerReplicationInfo OtherPRI;
    local float KillScore;
    local Controller C;

    OtherPRI = Other.PlayerReplicationInfo;

    if (GameRulesModifiers != None)
    {
        GameRulesModifiers.ScoreKill(Killer, Other);
    }

    if (Killer == None || !Killer.bIsPlayer || (Killer == Other))
    {
        return;
    }

    if (LastKilledMonsterClass == None)
    {
        return;
    }

    if(Killer.PlayerReplicationInfo !=none)
    {
        KillScore = LastKilledMonsterClass.Default.ScoringValue;
        KillScore *= GetScoreMultiplier();

        KillScore = Max(1,int(KillScore));
        Killer.PlayerReplicationInfo.Kills++;

        HandleAssists(Killer, KFMonsterController(Other));
        Killer.PlayerReplicationInfo.NetUpdateTime = Level.TimeSeconds - 1;
    }

    if (Killer.PlayerReplicationInfo !=none && Killer.PlayerReplicationInfo.Score < 0)
    {
        Killer.PlayerReplicationInfo.Score = 0;
    }

    /* Begin Marco's Kill Messages */
    if( Class'HUDKillingFloor'.Default.MessageHealthLimit<=Other.Pawn.Default.Health || Class'HUDKillingFloor'.Default.MessageMassLimit<=Other.Pawn.Default.Mass )
    {
        for( C=Level.ControllerList; C!=None; C=C.nextController )
        {
            if( C.bIsPlayer && xPlayer(C)!=None )
            {
                xPlayer(C).ReceiveLocalizedMessage(Class'KillsMessage',1,Killer.PlayerReplicationInfo,,Other.Pawn.Class);
            }
        }
    }
    else
    {
        if( xPlayer(Killer)!=None )
        {
            xPlayer(Killer).ReceiveLocalizedMessage(Class'KillsMessage',,,,Other.Pawn.Class);
        }
    }
    /* End Marco's Kill Messages */
}

final function HandleAssists(Controller Killer, KFMonsterController KilledMonster)
{
    local int Index;
    local KFPlayerReplicationInfo KFPRI;
    if (KilledMonster == None)
    {
        return;
    }

    for (Index = 0; Index < KilledMonster.KillAssistants.Length; Index++)
    {
        KFPRI = KFPlayerReplicationInfo(KilledMonster.KillAssistants[Index].PC.PlayerReplicationInfo);

        if (KFPRI == None)
        {
            continue;
        }

        if(KilledMonster.KillAssistants[Index].PC != Killer)
        {
            KFPRI.KillAssists++;
        }
    }
}

// Default properties for the game type
defaultproperties
{
    bIsHighDifficulty = false
    
	Begin Object Name=TurboMonsterCollectionHoldoutImpl0 Class=TurboMonsterCollectionHoldoutImpl
	End Object
    TurboMonsterCollection=TurboMonsterCollectionHoldoutImpl'TurboMonsterCollectionHoldoutImpl0'

    MapPrefix="HO"
    BeaconName="HO"
    Acronym="HO"

    GameName = "Turbo Holdout Game Type"
    Description = "Holdout mode for Killing Floor Turbo"
    ScreenShotName = "KFTurbo.Generic.KFTurbo_FB"

    MonsterCollection=Class'KFTurbo.MC_DEF'

    StandardMonsterSquads=()
    MonsterSquad=()
    FinalSquads=()
    MonsterClasses=()

    SpecialEventMonsterCollections(0)=Class'KFTurbo.MC_Turbo'
    SpecialEventMonsterCollections(1)=Class'KFTurbo.MC_Turbo'
    SpecialEventMonsterCollections(2)=Class'KFTurbo.MC_Turbo'
    SpecialEventMonsterCollections(3)=Class'KFTurbo.MC_Turbo'
}
