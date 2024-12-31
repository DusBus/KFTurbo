//Killing Floor Turbo OopsAllScrakesWaveEventHandler
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class CardGameWaveSpawnEventHandler extends KFTurbo.TurboWaveSpawnEventHandler;

static function OnNextSpawnSquadGenerated(KFTurboGameType GameType, out array < class<KFMonster> > NextSpawnSquad)
{
    local KFTurboCardGameMut CardGameMut;

    CardGameMut = class'KFTurboCardGameMut'.static.FindMutator(GameType);

    if (CardGameMut == None)
    {
        return;
    }

    CardGameMut.TurboCardGameplayManagerInfo.OnNextSpawnSquadGenerated(NextSpawnSquad);
}