//Killing Floor Turbo CurseOfRawWaveEventHandler
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class CurseOfRawWaveEventHandler extends KFTurbo.TurboWaveSpawnEventHandler;

static function OnBossSpawned(KFTurboGameType GameType)
{
    local CurseOfRaManager Manager;

    if (GameType == None)
    {
        return;
    }

    foreach GameType.DynamicActors(class'CurseOfRaManager', Manager)
    {
        Manager.OnBossSpawned();
    }
}