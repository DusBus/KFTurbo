//Killing Floor Turbo CardGameWaveEventHandler
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class CardGameWaveEventHandler extends KFTurbo.TurboWaveEventHandler;

var int GameStartWaitTime;

static function OnGameStarted(KFTurboGameType GameType, int StartedWave)
{
    GameType.WaveCountDown = Max(default.GameStartWaitTime, GameType.WaveCountDown);
    OnWaveEnded(GameType, StartedWave - 1);
}

static function OnGameEnded(KFTurboGameType GameType, int Result)
{
    local KFTurboCardGameMut CardGameMut;
    local TurboCardStatsTcpLink StatsTcpLink;

    CardGameMut = class'KFTurboCardGameMut'.static.FindMutator(GameType);

    if (CardGameMut == None || CardGameMut.TurboCardReplicationInfo == None)
    {
        return;
    }

    StatsTcpLink = class'TurboCardStatsTcpLink'.static.FindStats(GameType);

    if (StatsTcpLink == None)
    {
        return;
    }

    StatsTcpLink.OnGameEnd(GameType.WaveNum, Result == 1, CardGameMut.TurboCardReplicationInfo.GetActiveCardList());
}

static function OnWaveStarted(KFTurboGameType GameType, int StartedWave)
{
    local KFTurboCardGameMut CardGameMut;

    CardGameMut = class'KFTurboCardGameMut'.static.FindMutator(GameType);

    if (CardGameMut == None)
    {
        return;
    }
    
    CardGameMut.TurboCardReplicationInfo.OnSelectionTimeEnd();

    switch (StartedWave)
    {
        case 0:
            ModifyWaveSize(GameType, 0.25f);
            break;
        case 1:
            ModifyWaveSize(GameType, 0.3f);
            break;
        case 2:
            ModifyWaveSize(GameType, 0.35f);
            break;
        case 3:
            ModifyWaveSize(GameType, 0.4f);
            break;
        case 4:
            ModifyWaveSize(GameType, 0.5f);
            break;
        case 5:
            ModifyWaveSize(GameType, 0.6f);
            break;
        case 6:
            ModifyWaveSize(GameType, 0.7f);
            break;
        case 7:
            ModifyWaveSize(GameType, 0.8f);
            break;
        case 8:
            ModifyWaveSize(GameType, 0.9f);
            break;
    }
    
    CardGameMut.TurboCardGameplayManagerInfo.OnWaveStart(StartedWave);
}

static function ModifyWaveSize(KFTurboGameType GameType, float Multiplier)
{
    GameType.TotalMaxMonsters = Max(float(GameType.TotalMaxMonsters) * Multiplier, 15);
    KFGameReplicationInfo(GameType.GameReplicationInfo).MaxMonsters = GameType.TotalMaxMonsters;
}

static function OnWaveEnded(KFTurboGameType GameType, int EndedWave)
{
    local KFTurboCardGameMut CardGameMut;

    if (GameType.FinalWave <= EndedWave)
    {
        return;
    }

    CardGameMut = class'KFTurboCardGameMut'.static.FindMutator(GameType);

    if (CardGameMut == None)
    {
        return;
    }

    CardGameMut.TurboCardGameplayManagerInfo.OnWaveEnd(EndedWave);
    CardGameMut.TurboCardReplicationInfo.StartSelection(EndedWave + 1);
}

defaultproperties
{
    GameStartWaitTime=60
}