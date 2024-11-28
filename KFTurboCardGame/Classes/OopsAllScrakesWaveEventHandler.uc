//Killing Floor Turbo OopsAllScrakesWaveEventHandler
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class OopsAllScrakesWaveEventHandler extends KFTurbo.TurboWaveSpawnEventHandler;

static function OnNextSpawnSquadGenerated(KFTurboGameType GameType, out array < class<KFMonster> > NextSpawnSquad)
{
    local int Index;
    Index = NextSpawnSquad.Length - 1;

    while (Index > 0)
    {
        if (FRand() < 0.05f)
        {
            NextSpawnSquad[Index] = class'P_Scrake_STA';
        }
        
        Index--;
    }
}