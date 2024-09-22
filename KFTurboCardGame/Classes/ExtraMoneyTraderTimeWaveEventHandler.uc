//Killing Floor Turbo ExtraMoneyTraderTimeWaveEventHandler
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class ExtraMoneyTraderTimeWaveEventHandler extends KFTurbo.TurboWaveEventHandler;

static function OnWaveEnded(KFTurboGameType GameType, int EndedWave)
{   
	local Controller Controller;

    if (GameType.FinalWave <= EndedWave)
    {
        return;
    }

    for ( Controller = GameType.Level.ControllerList; Controller != None; Controller = Controller.NextController )
    {
        if (Controller.Pawn != None && Controller.Pawn.Health > 0 && PlayerController(Controller) != None && Controller.Pawn.ShieldStrength < 100.f)
        {
            Controller.PlayerReplicationInfo.Score += 500;

            if(PlayerController(Controller) != none)
            {
                PlayerController(Controller).ClientPlaySound(class'CashPickup'.default.PickupSound);
                PlayerController(Controller).ReceiveLocalizedMessage(class 'Msg_CashReward', 500);
            }
        }
    }

    GameType.WaveCountDown = float(GameType.WaveCountDown) * 0.75f;
    KFGameReplicationInfo(GameType.GameReplicationInfo).TimeToNextWave = GameType.WaveCountDown;
}