//Killing Floor Turbo CurseOfRawWaveEventHandler
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class CurseOfRawWaveEventHandler extends KFTurbo.TurboWaveSpawnEventHandler;

static function OnBossSpawned(KFTurboGameType GameType)
{
    local Mutator Mutator;
    local KFTurboCardGameMut CardGameMutator;
    local CurseOfRaManager Manager;

    if (GameType == None)
    {
        return;
    }

    for (Mutator = GameType.BaseMutator; Mutator != None; Mutator = Mutator.NextMutator)
    {
        CardGameMutator = KFTurboCardGameMut(Mutator);

        if (CardGameMutator == None)
        {
            continue;
        }

        Manager = CardGameMutator.TurboCardReplicationInfo.CurseOfRaManager;
        break;
    }

    if (Manager != None)
    {
        Manager.OnBossSpawned();
    }
}