//Killing Floor Turbo NegateDamageWaveEventHandler
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class NegateDamageWaveEventHandler extends KFTurbo.TurboWaveEventHandler;

static function OnWaveStarted(KFTurboGameType GameType, int StartedWave)
{
    local KFTurboCardGameMut CardGameMutator;
    CardGameMutator = class'KFTurboCardGameMut'.static.FindMutator(GameType);

    if (CardGameMutator == None || CardGameMutator.CardGameRules == None)
    {
        return;
    }

    CardGameMutator.CardGameRules.ResetNegateDamageList();
}