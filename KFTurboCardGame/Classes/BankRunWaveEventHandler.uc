//Killing Floor Turbo BankRunWaveEventHandler
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class BankRunWaveEventHandler extends KFTurbo.TurboWaveEventHandler;

static function OnWaveStarted(KFTurboGameType GameType, int EndedWave)
{
	local Controller Controller;

    if (GameType == None)
    {
        return;
    }

    for (Controller = GameType.Level.ControllerList; Controller != None; Controller = Controller.NextController)
    {
        if (Controller.Pawn != None && PlayerController(Controller) != None && Controller.PlayerReplicationInfo != None)
        {
            Controller.PlayerReplicationInfo.Score = int(Controller.PlayerReplicationInfo.Score / 2.f);
        }
    }
}