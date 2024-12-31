//Killing Floor Turbo CardGameWaveEventHandler
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class CardGameWaveEventHandler extends KFTurbo.TurboWaveEventHandler;

static function OnWaveStarted(KFTurboGameType GameType, int StartedWave)
{
    switch (StartedWave)
    {
        case 0:
            ModifyWaveSize(GameType, 0.1f);
            break;
        case 1:
            ModifyWaveSize(GameType, 0.15f);
            break;
        case 2:
            ModifyWaveSize(GameType, 0.2f);
            break;
        case 3:
            ModifyWaveSize(GameType, 0.25f);
            break;
        case 4:
            ModifyWaveSize(GameType, 0.35f);
            break;
        case 5:
            ModifyWaveSize(GameType, 0.45f);
            break;
        case 6:
            ModifyWaveSize(GameType, 0.6f);
            break;
        case 7:
            ModifyWaveSize(GameType, 0.75f);
            break;
        case 8:
            ModifyWaveSize(GameType, 0.9f);
            break;
    }

    if (StartedWave >= 7)
    {
        GameType.GameWaveSpawnRateModifier *= 1.1f;
    }
}

static function ModifyWaveSize(KFTurboGameType GameType, float Multiplier)
{
    GameType.TotalMaxMonsters = Max(float(GameType.TotalMaxMonsters) * Multiplier, 1);
    KFGameReplicationInfo(GameType.GameReplicationInfo).MaxMonsters = GameType.TotalMaxMonsters;
}