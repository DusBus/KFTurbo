class KFTurboGameType extends KFGameType;

var protected bool bIsHighDifficulty;
var protected bool bStatsAndAchievementsEnabled;
var protected bool bIsTestGameType;

//Event handler stored here so we have an easy way to find it.
//TODO: Slowly split these up into relevant categories so that a listener doesn't bloat the list of active handlers just to get one event it wants.
var array< class<TurboEventHandler> > EventHandlerList;
var array< class<TurboHealEventHandler> > HealEventHandlerList;
var array< class<TurboWaveEventHandler> > WaveEventHandlerList;

Delegate OnStatsAndAchievementsDisabled();

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

function BuildNextSquad()
{
	Super.BuildNextSquad();

	class'TurboWaveEventHandler'.static.BroadcastNextSpawnSquadGenerated(Self, NextSpawnSquad);
}

state MatchInProgress
{
    function BeginState()
    {
        Super.BeginState();

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
		if (!HasAnyTraders())
		{
			return;
		}

		Super.OpenShops();
    }
	
	//Generic event broadcasting.
	function SetupWave()
	{
		Super.SetupWave();
		class'TurboWaveEventHandler'.static.BroadcastWaveStarted(Self, WaveNum);
	}
	
	function StartWaveBoss()
	{
		Super.StartWaveBoss();
		class'TurboWaveEventHandler'.static.BroadcastWaveStarted(Self, WaveNum);
	}
	
	function DoWaveEnd()
	{
		Super.DoWaveEnd();
		class'TurboWaveEventHandler'.static.BroadcastWaveEnded(Self, WaveNum - 1);
	}
}

defaultproperties
{
    bIsHighDifficulty=false
    bStatsAndAchievementsEnabled=true
	bIsTestGameType=false

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
}
