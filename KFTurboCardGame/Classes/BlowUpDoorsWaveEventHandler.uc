//Killing Floor Turbo BlowUpDoorsWaveEventHandler
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class BlowUpDoorsWaveEventHandler extends KFTurbo.TurboWaveEventHandler;

static function OnWaveEnded(KFTurboGameType GameType, int EndedWave)
{
    local ExplodeDoorsActor ExplodeDoorsActor;

    if (GameType == None)
    {
        return;
    }
    
    foreach GameType.DynamicActors(class'ExplodeDoorsActor', ExplodeDoorsActor)
    {
        ExplodeDoorsActor.ExplodeDoors();
    }

    if (ExplodeDoorsActor == None)
    {
        GameType.Spawn(class'ExplodeDoorsActor');
    }
}