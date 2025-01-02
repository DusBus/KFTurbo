//Killing Floor Turbo CurseOfRawWaveEventHandler
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class CurseOfRawWaveEventHandler extends KFTurbo.TurboWaveSpawnEventHandler;

static function OnBossSpawned(KFTurboGameType GameType)
{
    local KFTurboCardGameMut CardGameMutator;
    local CurseOfRaManager Manager;

    if (GameType == None)
    {
        return;
    }

    CardGameMutator = class'KFTurboCardGameMut'.static.FindMutator(GameType);

    if (CardGameMutator == None)
    {
        return;
    }

    Manager = CardGameMutator.TurboCardGameplayManagerInfo.CurseOfRaManager;

    if (Manager != None)
    {
        Manager.OnBossSpawned();
    }
}