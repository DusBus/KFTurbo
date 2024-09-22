//Killing Floor Turbo GorefastToClotWaveEventHandler
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class GorefastToClotWaveEventHandler extends KFTurbo.TurboWaveEventHandler;

static function OnNextSpawnSquadGenerated(KFTurboGameType GameType, out array < class<KFMonster> > NextSpawnSquad)
{
    local int Index;
    for (Index = NextSpawnSquad.Length - 1; Index >= 0; Index--)
    {
        if (class<P_Gorefast>(NextSpawnSquad[Index]) != None)
        {
            NextSpawnSquad[Index] = class'KFTurbo.P_Clot_STA';
        }
    }
}