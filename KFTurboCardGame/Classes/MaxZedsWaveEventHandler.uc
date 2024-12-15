//Killing Floor Turbo MaxZedsWaveEventHandler
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class MaxZedsWaveEventHandler extends KFTurbo.TurboWaveEventHandler;

var float MaxMonsterMultiplier;

static function OnWaveStarted(KFTurboGameType GameType, int EndedWave)
{
    GameType.MaxMonsters = float(GameType.MaxMonsters) * default.MaxMonsterMultiplier;
}

defaultproperties
{
    MaxMonsterMultiplier=1.4f
}