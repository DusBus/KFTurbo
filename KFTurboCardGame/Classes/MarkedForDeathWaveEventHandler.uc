//Killing Floor Turbo MarkedForDeathWaveEventHandler
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class MarkedForDeathWaveEventHandler extends KFTurbo.TurboWaveEventHandler;

static function OnWaveStarted(KFTurboGameType GameType, int EndedWave)
{
    local TurboHumanPawn HumanPawn;
    local array<TurboHumanPawn> HumanPawnList;
    local KFTurboCardGameMut CardGameMutator;

    HumanPawnList = class'TurboGameplayHelper'.static.GetPlayerPawnList(GameType.Level);

    if (HumanPawnList.Length == 0)
    {
        return;
    }

    HumanPawn = HumanPawnList[Rand(HumanPawnList.Length)];

    if (HumanPawn == None || HumanPawn.bDeleteMe || HumanPawn.Health <= 0 || KFWeapon(HumanPawn.Weapon) == None)
    {
        return;
    }

    CardGameMutator = class'KFTurboCardGameMut'.static.FindMutator(GameType);

    if (CardGameMutator == None)
    {
        return;
    }

    CardGameMutator.CardGameRules.MarkedForDeathPawn = HumanPawn;
    GameType.Level.BroadcastLocalizedMessage(class'MarkedForDeathLocalMessage', 0, HumanPawn.PlayerReplicationInfo);
}


static function OnWaveEnded(KFTurboGameType GameType, int EndedWave)
{
    local KFTurboCardGameMut CardGameMutator;

    CardGameMutator = class'KFTurboCardGameMut'.static.FindMutator(GameType);

    if (CardGameMutator == None)
    {
        return;
    }

    CardGameMutator.CardGameRules.MarkedForDeathPawn = None;
}