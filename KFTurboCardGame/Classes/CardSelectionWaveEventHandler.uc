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

static function OnWaveStarted(KFTurboGameType GameType, int StartedWave)
{
    local KFTurboCardGameMut CardGameMut;
    local Mutator Mutator;
    for ( Mutator = GameType.BaseMutator; Mutator != None; Mutator = Mutator.NextMutator )
    {
        CardGameMut = KFTurboCardGameMut(Mutator);

        if (CardGameMut == None)
        {
            continue;
        }

        CardGameMut.TurboCardReplicationInfo.OnSelectionTimeEnd();
        break;
    }
}

static function OnWaveEnded(KFTurboGameType GameType, int EndedWave)
{
    local KFTurboCardGameMut CardGameMut;
    local Mutator Mutator;

    if (GameType.FinalWave <= EndedWave)
    {
        return;
    }
    
    for ( Mutator = GameType.BaseMutator; Mutator != None; Mutator = Mutator.NextMutator )
    {
        CardGameMut = KFTurboCardGameMut(Mutator);

        if (CardGameMut == None)
        {
            continue;
        }

        CardGameMut.TurboCardReplicationInfo.StartSelection(EndedWave + 1);
        break;
    }
}

defaultproperties
{
    GameStartWaitTime=60
}