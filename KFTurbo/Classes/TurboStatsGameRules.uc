//Killing Floor Turbo TurboStatsGameRules
//Responsible for broadcasting events related to kills/damage. Needs to be at the front of the GameRules list so it can make sure all rules have gone first.
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboStatsGameRules extends TurboGameRules;

function int NetDamage(int OriginalDamage, int Damage, Pawn Injured, Pawn InstigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType)
{
    Damage = Super.NetDamage(OriginalDamage, Damage, Injured, InstigatedBy, HitLocation, Momentum, DamageType);

    if (InstigatedBy != None && KFMonster(Injured) != None)
    {
        class'TurboPlayerEventHandler'.static.BroadcastPlayerDamagedMonster(InstigatedBy.Controller, KFMonster(Injured), Damage);
    }

    return Damage;
}

function Killed(Controller Killer, Controller Killed, Pawn KilledPawn, class<DamageType> DamageType)
{
    Super.Killed(Killer, Killed, KilledPawn, DamageType);

    if (KFMonster(KilledPawn) != None)
    {
        class'TurboPlayerEventHandler'.static.BroadcastPlayerKilledMonster(Killer, KFMonster(KilledPawn));
    }
}

defaultproperties
{

}