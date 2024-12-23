//Killing Floor Turbo CardSelectionWaveEventHandler
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class CardSelectionWaveEventHandler extends KFTurbo.TurboWaveEventHandler;

var int GameStartWaitTime;

static function OnGameStarted(KFTurboGameType GameType, int StartedWave)
{
    GameType.WaveCountDown = Max(default.GameStartWaitTime, GameType.WaveCountDown);
    
    OnWaveEnded(GameType, StartedWave - 1);
}

static function OnGameEnded(KFTurboGameType GameType, int Result)
{
    local TurboCardStatsTcpLink StatsTcpLink;
    local KFTurboCardGameMut CardGameMut;
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

    CardGameMut.TurboCardReplicationInfo.StartSelection(EndedWave + 1);
}

defaultproperties
{
    GameStartWaitTime=60
}