//Killing Floor Turbo CurseOfRaManager
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class CurseOfRaManager extends Engine.Info;

var int NumExtraToSpawn;
var bool bSpawnedExtra;

struct RatedSpawner
{
    var ZombieVolume Volume;
    var float Score;
};

function PostBeginPlay()
{
    Super.PostBeginPlay();

    SetTimer(17.f, true);
}

function OnBossSpawned()
{
    AddBosses();
}

function AddBosses()
{
    local KFGameType KFGT;
    local int Index, ScoredIndex;
    local float Score;
    local bool bFoundPlace;

    local int MaxMonsters;
    local int ZombiesAtOnceLeft;
    local int NumSpawned;
    local array<RatedSpawner> SpawnerList;

    local array< class<KFMonster> > NextSpawnSquad;

    local ZombieBoss ZombieBoss;

    if (bSpawnedExtra)
    {
        return;
    }

    bSpawnedExtra = true;
    KFGT = KFGameType(Level.Game);
    KFGT.NextSpawnSquad.Length = 1;

    if(KFGT.KFGameLength != KFGT.GL_Custom)
    {
        KFGT.NextSpawnSquad[0] = Class<KFMonster>(DynamicLoadObject(KFGT.MonsterCollection.default.EndGameBossClass, Class'Class'));
    }
    else
    {
        KFGT.NextSpawnSquad[0] = Class<KFMonster>(DynamicLoadObject(KFGT.EndGameBossClass, Class'Class'));
    }

    NextSpawnSquad = KFGT.NextSpawnSquad;

    for(Index = KFGT.ZedSpawnList.Length - 1; Index >= 0; Index--)
    {
        Score = KFGT.ZedSpawnList[Index].RateZombieVolume(KFGT, KFGT.LastSpawningVolume, None, false, true);
        KFGT.ZedSpawnList[Index].LastFailedSpawnTime = Level.TimeSeconds;
        
        if (Score < 0.f)
        {
            continue;
        }

        bFoundPlace = false;
        for (ScoredIndex = 0; ScoredIndex < SpawnerList.Length; ScoredIndex++)
        {
            if (Score > SpawnerList[ScoredIndex].Score)
            {
                bFoundPlace = true;
                SpawnerList.Insert(ScoredIndex, 1);
                AddSpawner(SpawnerList[ScoredIndex], KFGT.ZedSpawnList[Index], Score);
                break;
            }
        }

        if (bFoundPlace || SpawnerList.Length >= NumExtraToSpawn)
        {
            continue;
        }

        SpawnerList.Length = SpawnerList.Length + 1;
        AddSpawner(SpawnerList[SpawnerList.Length - 1], KFGT.ZedSpawnList[Index], Score);
    }

    for(Index = 0; Index < SpawnerList.Length; Index++)
    {
        NumExtraToSpawn--;
        KFGT.NextSpawnSquad = NextSpawnSquad;
        MaxMonsters = 1;
        ZombiesAtOnceLeft = 1;
        SpawnerList[Index].Volume.SpawnInHere(KFGT.NextSpawnSquad, false, NumSpawned, MaxMonsters, ZombiesAtOnceLeft);

        if (NumExtraToSpawn <= 0)
        {
            break;
        }
    }
 
    foreach DynamicActors(class'ZombieBoss', ZombieBoss)
    {
        if (!ZombieBoss.IsInState('MakingEntrance'))
        {
            ZombieBoss.MakeGrandEntry();
        }
    }
}

function AddSpawner(out RatedSpawner Entry, ZombieVolume Volume, float Score)
{
    Entry.Volume = Volume;
    Entry.Score = Score;
}

//Randomly do something strange sometimes.
function Timer()
{
    local float Random;

    SetTimer(15.f + (FRand() * 4.f), true);

    if (KFGameType(Level.Game) != None && !KFGameType(Level.Game).bWaveInProgress)
    {
        return;
    }

    if (FRand() < 0.9f)
    {
        return;
    }

    Random = FRand();

    if (Random < 0.1f)
    {
        RandomlyRageScrake();
    }
    else if (Random < 0.2f)
    {
        RandomlyRageFleshpound();
    }
    else if (Random < 0.3f)
    {
        RandomlySetOffPipebomb();
    }
    else if (Random < 0.4f)
    {
        ForceAReload();
    }
    else if (Random < 0.5f)
    {
        ForceDropCash();
    }
    else if (Random < 0.6f)
    {
        KillRandomMonster();
    }
}

function RandomlyRageScrake()
{
    local P_Scrake Scrake;
    local array<P_Scrake> ScrakeList;
    foreach DynamicActors(class'P_Scrake', Scrake)
    {
        ScrakeList.Length = ScrakeList.Length + 1;
        ScrakeList[ScrakeList.Length - 1] = Scrake;
    }

    if (ScrakeList.Length == 0)
    {
        return;
    }

    Scrake = ScrakeList[Rand(ScrakeList.Length)];

    if (Scrake == None || Scrake.Health <= 0)
    {
        return;
    }

	Scrake.HealthRageThreshold = FMax(1.1f, Scrake.HealthRageThreshold);
    Scrake.RangedAttack(None);
}

function RandomlyRageFleshpound()
{
    local AI_Fleshpound Fleshpound;
    local array<AI_Fleshpound> FleshpoundList;
    foreach DynamicActors(class'AI_Fleshpound', Fleshpound)
    {
        FleshpoundList.Length = FleshpoundList.Length + 1;
        FleshpoundList[FleshpoundList.Length - 1] = Fleshpound;
    }

    if (FleshpoundList.Length == 0)
    {
        return;
    }

    Fleshpound = FleshpoundList[Rand(FleshpoundList.Length)];

    if (Fleshpound == None || Fleshpound.Pawn == None || Fleshpound.Pawn.Health <= 0)
    {
        return;
    }

	Fleshpound.bForcedRage = true;
	P_Fleshpound(Fleshpound.Pawn).StartCharging();
	P_Fleshpound(Fleshpound.Pawn).bFrustrated = true;
}

function RandomlySetOffPipebomb()
{
    local PipeBombProjectile Pipebomb;
    local array<PipeBombProjectile> PipebombList;
    foreach DynamicActors(class'PipeBombProjectile', Pipebomb)
    {
        PipebombList.Length = PipebombList.Length + 1;
        PipebombList[PipebombList.Length - 1] = Pipebomb;
    }

    if (PipebombList.Length == 0)
    {
        return;
    }

    Pipebomb = PipebombList[Rand(PipebombList.Length)];

    if (Pipebomb == None)
    {
        return;
    }

    Pipebomb.Explode(Pipebomb.Location,vect(0,0,1));
}

function ForceAReload()
{
    local TurboHumanPawn HumanPawn;
    local array<TurboHumanPawn> HumanPawnList;
    foreach DynamicActors(class'TurboHumanPawn', HumanPawn)
    {
        HumanPawnList.Length = HumanPawnList.Length + 1;
        HumanPawnList[HumanPawnList.Length - 1] = HumanPawn;
    }

    if (HumanPawnList.Length == 0)
    {
        return;
    }

    HumanPawn = HumanPawnList[Rand(HumanPawnList.Length)];

    if (HumanPawn == None || KFWeapon(HumanPawn.Weapon) == None)
    {
        return;
    }

    KFWeapon(HumanPawn.Weapon).ReloadMeNow();
}

function ForceDropCash()
{
    local TurboHumanPawn HumanPawn;
    local array<TurboHumanPawn> HumanPawnList;
    foreach DynamicActors(class'TurboHumanPawn', HumanPawn)
    {
        HumanPawnList.Length = HumanPawnList.Length + 1;
        HumanPawnList[HumanPawnList.Length - 1] = HumanPawn;
    }

    if (HumanPawnList.Length == 0)
    {
        return;
    }

    HumanPawn = HumanPawnList[Rand(HumanPawnList.Length)];

    if (HumanPawn == None)
    {
        return;
    }
    
    HumanPawn.TossCash(50);
}


function KillRandomMonster()
{
    local Controller C;
    local array<Monster> MonsterList;
    local Monster SelectedMonster;

	for (C = Level.ControllerList; C != None; C = C.NextController)
	{
		if(C != None && Monster(C.Pawn) != None && C.Pawn.Health > 0)
		{
			MonsterList[MonsterList.Length] = Monster(C.Pawn);
		}
	}

    if (MonsterList.Length < 6)
    {
        return;
    }

    SelectedMonster = MonsterList[Rand(MonsterList.Length)];
    
    if (SelectedMonster == None || ZombieBoss(SelectedMonster) != None)
    {
        return;
    }

    SelectedMonster.Died(None, class'TurboCurseOfRaKillMonster_DT', SelectedMonster.Location);
}

defaultproperties
{
    NumExtraToSpawn=1
    bSpawnedExtra=false
}