class KFTurboGameType extends KFGameType;

var protected bool bIsHighDifficulty;
var protected bool bStatsAndAchievementsEnabled;
var protected bool bIsTestGameType;

//Event handler stored here so we have an easy way to find it.
var array< class<KFTurboEventHandler> > EventHandlerList;

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

	GameClass = class<KFTurboGameType>(Actor.Level.GetGameClass());
	
	if (GameClass == none)
	{
		return false;
	}

	return GameClass.static.AreStatsAndAchievementsEnabled();
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

    GameName="Killing Floor Turbo Game Type"
    Description="KF Turbo version of default Killing Floor Game Type."
    ScreenShotName="KFTurbo.Generic.KFTurbo_FB"
}
