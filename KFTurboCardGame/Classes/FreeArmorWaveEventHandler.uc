//Killing Floor Turbo FreeArmorWaveEventHandler
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class FreeArmorWaveEventHandler extends KFTurbo.TurboWaveEventHandler;

static function OnWaveStarted(KFTurboGameType GameType, int StartedWave)
{
	local Controller Controller;

    for ( Controller = GameType.Level.ControllerList; Controller != None; Controller = Controller.NextController )
    {
        if (Controller.Pawn != None && Controller.Pawn.Health > 0 && PlayerController(Controller) != None && Controller.Pawn.ShieldStrength < 100.f)
        {
            PlayerController(Controller).ClientPlaySound(Sound'KF_InventorySnd.Vest_Pickup');
            Controller.Pawn.ShieldStrength = 100.f;
        }
    }
}