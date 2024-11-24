//Killing Floor Turbo OverclockedHuskWaveEventHandler
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class OverclockedHuskWaveEventHandler extends KFTurbo.TurboWaveSpawnEventHandler;

static function OnNextSpawnSquadGenerated(KFTurboGameType GameType, out array < class<KFMonster> > NextSpawnSquad)
{
    local int Index;
    local int HuskCount;
    HuskCount = 0;

    for (Index = NextSpawnSquad.Length - 1; Index >= 0; Index--)
    {
        if (class<P_Husk>(NextSpawnSquad[Index]) != None)
        {
            HuskCount++;
        }
    }

    while (HuskCount > 0)
    {
        HuskCount--;

        if (FRand() < 0.5f)
        {
            NextSpawnSquad[NextSpawnSquad.Length] = class'P_Husk_STA';
        }
    }
}