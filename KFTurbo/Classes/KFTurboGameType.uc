//Killing Floor Turbo KFTurboGameType
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class KFTurboGameType extends KFGameType;

var protected bool bIsHighDifficulty;
var protected bool bStatsAndAchievementsEnabled;
var protected bool bIsTestGameType;

//Used to block ending of a game. Helps with testing.
var protected bool bPreventGameOver;

//Allows a gametype modification to total waves without impacting spawns (eg the game wants to work like a Long game, but with a different number of waves).
var protected int FinalWaveOverride;
var protected bool bHasAttemptedToApplyFinalWaveOverride;
 
//Whatever spawn rate is set as, make sure it gets multiplied by these.
var float GameWaveSpawnRateModifier, MapWaveSpawnRateModifier;
//Whatever max monsters is set as, make sure it gets multiplied by these.
var float GameMaxMonstersModifier, MapMaxMonstersModifier;
//Whatever total monsters is set as, make sure it gets multiplied by this.
var float GameTotalMonstersModifier;
//Whatever trader time is set as, make sure it gets multiplied by this.
var float GameTraderTimeModifier;

//Set to true when the boss has been spawned. Used to prevent duplicate broadcasts of OnBossSpawned event.
var bool bHasSpawnedBoss;

//Event handler stored here so we have an easy way to find it.
//TODO: Slowly split these up into relevant categories so that a listener doesn't bloat the list of active handlers just to get one event it wants.
var array< class<TurboEventHandler> > EventHandlerList;
var array< class<TurboHealEventHandler> > HealEventHandlerList;
var array< class<TurboWaveEventHandler> > WaveEventHandlerList;
var array< class<TurboWaveSpawnEventHandler> > WaveSpawnEventHandlerList;

var MapConfigurationObject MapConfigurationObject; //MapConfigurationObject associated with the current map.

//Events that KFTurboServerMut binds to for bridging communication with ServerPerksMut.
Delegate OnStatsAndAchievementsDisabled();
Delegate LockPerkSelection(bool bLock);

event InitGame( string Options, out string Error )
{
    Super.InitGame(Options, Error);

    InitializeMapConfigurationObject();
}

function InitializeMapConfigurationObject()
{
    local string MapName;
    local int Index;
    MapName = Locs(GetCurrentMapName(Level));

    MapConfigurationObject = new(None, MapName) class'MapConfigurationObject';

    if (MapConfigurationObject != None && MapConfigurationObject.MapNameRedirect != "")
    {
        MapConfigurationObject = new(None, Locs(MapConfigurationObject.MapNameRedirect)) class'MapConfigurationObject';
    }

    if (MapConfigurationObject == None || MapConfigurationObject.bDisabled)
    {
        return;
    }

    log("Loaded MapConfigurationObject for level"@MapName$". Applying modifiers now.", 'KFTurbo');

    log("| Spawn Rate Modifier:"@MapWaveSpawnRateModifier@"| Max Monsters Modifier:"@MapMaxMonstersModifier, 'KFTurbo');

    MapWaveSpawnRateModifier = MapConfigurationObject.WaveSpawnRateMultiplier;
    MapMaxMonstersModifier = MapConfigurationObject.WaveMaxMonstersMultiplier;

    log("| Zombie Volume Respawn Modifier:"@MapConfigurationObject.ZombieVolumeCanRespawnTimeMultiplier@"| Zombie Volume Min Player Distance Modifier:"@MapConfigurationObject.ZombieVolumeMinDistanceToPlayerMultiplier, 'KFTurbo');

    for (Index = ZedSpawnList.Length - 1; Index >= 0; Index--)
    {
        ZedSpawnList[Index].CanRespawnTime *= MapConfigurationObject.ZombieVolumeCanRespawnTimeMultiplier;
        ZedSpawnList[Index].MinDistanceToPlayer *= MapConfigurationObject.ZombieVolumeMinDistanceToPlayerMultiplier;
    }
}
 
//Provide full context on something dying to TurboGameRules.
function Killed(Controller Killer, Controller Killed, Pawn KilledPawn, class<DamageType> DamageType)
{
    local GameRules GameRules;
    local TurboGameRules TurboGameRules;

    Super.Killed(Killer, Killed, KilledPawn, DamageType);

    GameRules = GameRulesModifiers;

    //Find the first TurboGameRules in the chain and start the event flow.
    while (GameRules != None)
    {
        TurboGameRules = TurboGameRules(GameRules);

        if (TurboGameRules != None)
        {
            break;
        }

        GameRules = GameRules.NextGameRules;
    }

    if (TurboGameRules != None)
    {
        TurboGameRules.Killed(Killer, Killed, KilledPawn, DamageType);
    }
}

static function bool IsHighDifficulty()
{
    return default.bIsHighDifficulty;
}

static final function bool StaticIsHighDifficulty( Actor Actor )
{
	local class<KFTurboGameType> GameClass;
	if(Actor == None || Actor.Level == None)
	{
		return false;
	}

	GameClass = class<KFTurboGameType>(Actor.Level.GetGameClass());
	
	if (GameClass == none)
	{
		return false;
	}

	return GameClass.static.IsHighDifficulty();
}

static function bool AreStatsAndAchievementsEnabled()
{
    return default.bStatsAndAchievementsEnabled;
}

static final function bool StaticAreStatsAndAchievementsEnabled( Actor Actor )
{
	local class<KFTurboGameType> GameClass;
	if(Actor == None || Actor.Level == None)
	{
		return false;
	}

	if (KFTurboGameType(Actor.Level.Game) != None)
	{
        //If the class defines by default that stats are not enabled, stick to that!
        if (!class<KFTurboGameType>(Actor.Level.Game.Class).default.bStatsAndAchievementsEnabled)
        {
            return false;
        }

		return KFTurboGameType(Actor.Level.Game).bStatsAndAchievementsEnabled;
	}

	GameClass = class<KFTurboGameType>(Actor.Level.GetGameClass());
	
	if (GameClass == none)
	{
		return false;
	}

	return GameClass.static.AreStatsAndAchievementsEnabled();
}

static final function StaticDisableStatsAndAchievements( Actor Actor )
{
	if(Actor == None || Actor.Level == None)
	{
		return;
	}

	if (KFTurboGameType(Actor.Level.Game) != None)
	{
		KFTurboGameType(Actor.Level.Game).bStatsAndAchievementsEnabled = false;
		KFTurboGameType(Actor.Level.Game).OnStatsAndAchievementsDisabled();
	}
}

static function bool IsTestGameType()
{
    return default.bIsTestGameType;
}

static final function bool StaticIsTestGameType( Actor Actor )
{
	local class<KFTurboGameType> GameClass;
	if(Actor == None || Actor.Level == None)
	{
		return false;
	}

	GameClass = class<KFTurboGameType>(Actor.Level.GetGameClass());
	
	if (GameClass == none)
	{
		return false;
	}

	return GameClass.static.IsTestGameType();
}

final function bool HasAnyTraders()
{
	local int Index;
	local bool bHasAnyTraders;
	bHasAnyTraders = false;

	for(Index = 0; Index < ShopList.Length; Index++)
	{
		if(ShopList[Index].bAlwaysClosed)
		{
			continue;
		}
		
		bHasAnyTraders = true;
		break;		
	}

	return bHasAnyTraders;
}

simulated function bool SetFinalWaveOverride(int NewOverride)
{
    if (bHasAttemptedToApplyFinalWaveOverride)
    {
        return false;
    }

    FinalWaveOverride = NewOverride;
    return true;
}

simulated function PrepareSpecialSquads()
{
    Super.PrepareSpecialSquads();

    if (FinalWaveOverride != -1)
    {
        FinalWave = FinalWaveOverride;
    }

    bHasAttemptedToApplyFinalWaveOverride = true;
}

function BuildNextSquad()
{
	Super.BuildNextSquad();

	class'TurboWaveSpawnEventHandler'.static.BroadcastNextSpawnSquadGenerated(Self, NextSpawnSquad);
}

function bool AddBoss()
{
    if (Super.AddBoss())
    {
        if (!bHasSpawnedBoss)
        {
            bHasSpawnedBoss = true;
	        class'TurboWaveSpawnEventHandler'.static.BroadcasBossSpawned(Self);
        }
        return true;
    }

    return false;
}

function AddSpecialSquad()
{
	Super.AddSpecialSquad();

	class'TurboWaveSpawnEventHandler'.static.BroadcastNextSpawnSquadGenerated(Self, NextSpawnSquad);
}

function AddSpecialPatriarchSquad()
{
    if( FinalSquads.Length == 0 )
    {
        AddSpecialPatriarchSquadFromCollection();
    }
    else
    {
        AddSpecialPatriarchSquadFromGameType();
    }

    if (NextSpawnSquad.Length > 0)
    {
	    class'TurboWaveSpawnEventHandler'.static.BroadcastNextSpawnSquadGenerated(Self, NextSpawnSquad);
    }
}

function AddBossBuddySquad()
{
    local int TotalZeds, NumSpawned, TotalZedsValue;
    local int Index;
    local int TempMaxMonsters;
    local int TotalSpawned;
    local int SpawnDiff;

    if (NumPlayers == 1)
    {
        TotalZeds = 8;
    }
    else if (NumPlayers <= 3)
    {
        TotalZeds = 12;
    }
    else if (NumPlayers <= 5)
    {
        TotalZeds = 14;
    }
    else if (NumPlayers >= 6)
    {
        TotalZeds = 16;
    }
	
	class'TurboWaveSpawnEventHandler'.static.BroadcastAddBossBuddySquad(Self, TotalZeds);

    for (Index = 0; Index < 10; Index++)
    {
        if (TotalSpawned >= TotalZeds)
        {
            FinalSquadNum++;
            return;
        }

        NumSpawned = 0;
        NextSpawnSquad.Length = 0;
        AddSpecialPatriarchSquad();

        LastZVol = FindSpawningVolume();
        if (LastZVol != None)
		{
			LastSpawningVolume = LastZVol;
		}

        if (LastZVol == None)
        {
            LastZVol = FindSpawningVolume();
            if (LastZVol != None)
			{
                LastSpawningVolume = LastZVol;
			}

            if (LastZVol == None)
            {
                log("Error!!! Couldn't find a place for the Patriarch squad after 2 tries!!!");
            }
        }

        if ((NextSpawnSquad.Length + TotalSpawned) > TotalZeds)
        {
            SpawnDiff = (NextSpawnSquad.Length + TotalSpawned) - TotalZeds;

            if (NextSpawnSquad.Length > SpawnDiff)
            {
                NextSpawnSquad.Remove(0, SpawnDiff);
            }
            else
            {
                FinalSquadNum++;
                return;
            }

            if (NextSpawnSquad.Length == 0)
            {
                FinalSquadNum++;
                return;
            }
        }

        TempMaxMonsters = 999;
        if (LastZVol.SpawnInHere(NextSpawnSquad, , NumSpawned, TempMaxMonsters, 999, TotalZedsValue))
        {
            NumMonsters += NumSpawned;
            WaveMonsters += NumSpawned;
            TotalSpawned += NumSpawned;

            NextSpawnSquad.Remove(0, NumSpawned);
        }
    }

    FinalSquadNum++;
}

function SetupWave()
{
	Super.SetupWave();

    MaxMonsters = float(MaxMonsters) * GameMaxMonstersModifier * MapMaxMonstersModifier;

    TotalMaxMonsters = float(TotalMaxMonsters) * GameTotalMonstersModifier;
    KFGameReplicationInfo(Level.Game.GameReplicationInfo).MaxMonsters = TotalMaxMonsters;
	
    ClearTraderEndVotes();
	class'TurboWaveEventHandler'.static.BroadcastWaveStarted(Self, WaveNum);
}

//Function needs to be declared outside of state scope if it wants to be called outside of the state's scope...
function SelectShop() {}

function ClearEndGame(){}

state MatchInProgress
{
    function BeginState()
    {
        Super.BeginState();

        if (class'KFTurboMut'.static.HasVersionUpdate(Self))
        {
            BroadcastLocalized(Level.GRI, class'TurboVersionLocalMessage');
        }

        NotifyTurboMutatorGameStart();
		class'TurboWaveEventHandler'.static.BroadcastGameStarted(Self, WaveNum);
    }

	//Don't do these things if there are no traders (KFTurbo+ or Randomizer).
    function SelectShop()
    {
		if (!HasAnyTraders())
		{
			return;
		}

		Super.SelectShop();
    }

    function OpenShops()
    {
        if ( WaveCountDown == 59 && WaveNum % 3 == 0)
        {
            BroadcastLocalizedMessage(class'TurboEndTraderVoteMessage', 0); //EEndTraderVoteMessage.VoteHint
        }

		if (!HasAnyTraders())
		{
			return;
		}

		Super.OpenShops();
    }

    function CloseShops()
    {
        local Controller C;
        Super.CloseShops();

        for (C = Level.ControllerList; C != None; C = C.NextController)
        {
            if (TurboPlayerController(C) != None)
            {
                TurboPlayerController(C).bShopping = false;
            }
        }
    }

	function float CalcNextSquadSpawnTime()
	{
		return Super.CalcNextSquadSpawnTime() / (GameWaveSpawnRateModifier * MapWaveSpawnRateModifier);
	}
	
	function StartWaveBoss()
	{
		Super.StartWaveBoss();
		class'TurboWaveEventHandler'.static.BroadcastWaveStarted(Self, WaveNum);
	}

    function ClearEndGame()
    {
        local bool bPlayerAlive;
        local Controller C;

        if (!IsPreventGameOverEnabled())
        {
            return;
        }

        bPlayerAlive = false;

        for ( C=Level.ControllerList; C!=None; C=C.NextController )
        {
            if ( (C.PlayerReplicationInfo != None) && C.bIsPlayer && !C.PlayerReplicationInfo.bOutOfLives && !C.PlayerReplicationInfo.bOnlySpectator )
            {
                bPlayerAlive = true;
                break;
            }
        }

        if (!bPlayerAlive)
        {
            DoWaveEnd();
        }
    }
	
	function DoWaveEnd()
	{
		Super.DoWaveEnd();

        if (GameTraderTimeModifier != 1.f)
        {
            WaveCountDown = float(WaveCountDown) * GameTraderTimeModifier;
            KFGameReplicationInfo(GameReplicationInfo).TimeToNextWave = WaveCountDown;
        }

        InvasionGameReplicationInfo(GameReplicationInfo).WaveNumber = WaveNum;
		class'TurboWaveEventHandler'.static.BroadcastWaveEnded(Self, WaveNum - 1);
	}
}

function bool IsPreventGameOverEnabled()
{
    return bPreventGameOver;
}

function PreventGameOver()
{
    bPreventGameOver = true;
}

function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
    local bool bGameIsOver, bResult;

    if (WaveNum <= FinalWave && bPreventGameOver)
    {
        return false;
    }

    bGameIsOver = KFGameReplicationInfo(GameReplicationInfo).EndGameType != 0;

    bResult = Super.CheckEndGame(Winner, Reason);

    if (!bGameIsOver && KFGameReplicationInfo(GameReplicationInfo).EndGameType != 0)
    {
		class'TurboWaveEventHandler'.static.BroadcastGameEnded(Self, KFGameReplicationInfo(GameReplicationInfo).EndGameType);
        NotifyTurboMutatorGameEnd(KFGameReplicationInfo(GameReplicationInfo).EndGameType);
    }

    return bResult;
}

//Check if enough people have voted to end the trader and end it.
function AttemptTraderEnd(TurboPlayerController VoteInstigator)
{
    local int Index, NumVoters, NumVotes;
    local TurboPlayerReplicationInfo TPRI;
    local float VotePercent;
    local bool bAdminVoted;
    
    if (bWaveInProgress || WaveCountDown <= 10)
	{
		return;
	}

    if (StaticIsTestGameType(Self))
    {
        return;
    }

    NumVoters = 0;
    NumVotes = 0;
    bAdminVoted = false;

	for (Index = Level.GRI.PRIArray.Length - 1; Index >= 0; Index--)
	{
		TPRI = TurboPlayerReplicationInfo(Level.GRI.PRIArray[Index]);

        if (TPRI == None || TPRI.bOnlySpectator)
        {
            continue;
        }

        NumVoters++;
        
        if (TPRI.bVotedForTraderEnd)
        {
            NumVotes++;

            if (TPRI.bAdmin)
            {
                bAdminVoted = true;
            }
        }
    }

    if (NumVoters == 0)
    {
        return;
    }

    VotePercent = float(NumVotes) / float(NumVoters);

    if (bAdminVoted || VotePercent >= 0.51f)
    {
        WaveCountDown = Min(WaveCountDown, 10);
        TurboGameReplicationInfo(GameReplicationInfo).TimeToNextWave = WaveCountDown;
        return;
    }
    
    //This means someone instigated a vote.
    if (NumVotes == 1)
    {
        BroadcastLocalizedMessage(class'TurboEndTraderVoteMessage', 1, VoteInstigator.PlayerReplicationInfo); //EEndTraderVoteMessage.VoteStarted
    }
}

function ClearTraderEndVotes()
{
    local int Index;
    local TurboPlayerReplicationInfo TPRI;

	for (Index = Level.GRI.PRIArray.Length - 1; Index >= 0; Index--)
	{
		TPRI = TurboPlayerReplicationInfo(Level.GRI.PRIArray[Index]);

        if (TPRI == None)
        {
            continue;
        }

        TPRI.ClearTraderEndVote();
    }
}

function NotifyTurboMutatorGameStart()
{
    local KFTurboMut TurboMut;
    TurboMut = class'KFTurboMut'.static.FindMutator(Self);
    TurboMut.OnGameStart();
}

function NotifyTurboMutatorGameEnd(int Result)
{
    local KFTurboMut TurboMut;
    TurboMut = class'KFTurboMut'.static.FindMutator(Self);
    TurboMut.OnGameEnd(Result);
}

defaultproperties
{
    bIsHighDifficulty=false
    bStatsAndAchievementsEnabled=true
	bIsTestGameType=false

    FinalWaveOverride=-1
    bHasAttemptedToApplyFinalWaveOverride=false

	GameWaveSpawnRateModifier=1.f
    MapWaveSpawnRateModifier=1.f
    GameMaxMonstersModifier=1.f
    MapMaxMonstersModifier=1.f
    GameTotalMonstersModifier=1.f
    GameTraderTimeModifier=1.f
    bHasSpawnedBoss=false

    MonsterClasses(0)=(MClassName="KFTurbo.P_Clot_STA",Mid="A")
    MonsterClasses(1)=(MClassName="KFTurbo.P_Crawler_STA",Mid="B")
    MonsterClasses(2)=(MClassName="KFTurbo.P_GoreFast_STA",Mid="C")
    MonsterClasses(3)=(MClassName="KFTurbo.P_Stalker_STA",Mid="D")
    MonsterClasses(4)=(MClassName="KFTurbo.P_Scrake_STA",Mid="E")
    MonsterClasses(5)=(MClassName="KFTurbo.P_Fleshpound_STA",Mid="F")
    MonsterClasses(6)=(MClassName="KFTurbo.P_Bloat_STA",Mid="G")
    MonsterClasses(7)=(MClassName="KFTurbo.P_Siren_STA",Mid="H")
    MonsterClasses(8)=(MClassName="KFTurbo.P_Husk_STA",Mid="I")

    MonsterCollection=Class'KFTurbo.MC_DEF'
    SpecialEventMonsterCollections(0)=Class'KFTurbo.MC_DEF'
    SpecialEventMonsterCollections(1)=Class'KFTurbo.MC_SUM'
    SpecialEventMonsterCollections(2)=Class'KFTurbo.MC_HAL'
    SpecialEventMonsterCollections(3)=Class'KFTurbo.MC_XMA'

	GameReplicationInfoClass=Class'KFTurbo.TurboGameReplicationInfo'
	
    GameName="Killing Floor Turbo Game Type"
    Description="KF Turbo version of default Killing Floor Game Type."
    ScreenShotName="KFTurbo.Generic.KFTurbo_FB"

	ScoreBoardType="KFTurbo.TurboHUDScoreboard"

    Waves(0)=(WaveMask=196611,WaveMaxMonsters=20,WaveDuration=255,WaveDifficulty=0.100000)
    Waves(1)=(WaveMask=19662621,WaveMaxMonsters=32,WaveDuration=255,WaveDifficulty=0.100000)
    Waves(2)=(WaveMask=39337661,WaveMaxMonsters=35,WaveDuration=255,WaveDifficulty=0.200000)
    Waves(3)=(WaveMask=73378265,WaveMaxMonsters=42,WaveDuration=255,WaveDifficulty=0.300000)
    Waves(4)=(WaveMask=20713149,WaveMaxMonsters=35,WaveDuration=255,WaveDifficulty=0.200000)
    Waves(5)=(WaveMask=39337661,WaveMaxMonsters=35,WaveDuration=255,WaveDifficulty=0.200000)
    Waves(6)=(WaveMask=39337661,WaveMaxMonsters=35,WaveDuration=255,WaveDifficulty=0.200000)
    Waves(7)=(WaveMask=41839087,WaveMaxMonsters=40,WaveDuration=255,WaveDifficulty=0.300000)
    Waves(8)=(WaveMask=41839087,WaveMaxMonsters=40,WaveDuration=255,WaveDifficulty=0.300000)
    Waves(9)=(WaveMask=39840217,WaveMaxMonsters=45,WaveDuration=255,WaveDifficulty=0.300000)
    Waves(10)=(WaveMask=65026687,WaveMaxMonsters=45,WaveDuration=255,WaveDifficulty=0.300000)
    Waves(11)=(WaveMask=63750079,WaveMaxMonsters=45,WaveDuration=255,WaveDifficulty=0.300000)
    Waves(12)=(WaveMask=64810679,WaveMaxMonsters=50,WaveDuration=255,WaveDifficulty=0.300000)
    Waves(13)=(WaveMask=62578607,WaveMaxMonsters=50,WaveDuration=255,WaveDifficulty=0.300000)
    Waves(14)=(WaveMask=100663295,WaveMaxMonsters=50,WaveDuration=255,WaveDifficulty=0.300000)
    Waves(15)=(WaveMask=125892608,WaveMaxMonsters=50,WaveDuration=255,WaveDifficulty=0.300000)
}
