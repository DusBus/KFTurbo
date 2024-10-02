//Killing Floor Turbo CurseOfRaManager
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class CurseOfRaManager extends Engine.Info;

var int NumExtraToSpawn;

struct RatedSpawner
{
    var ZombieVolume Volume;
    var float Score;
};

function PostBeginPlay()
{
    Super.PostBeginPlay();
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

defaultproperties
{
    NumExtraToSpawn=2
}