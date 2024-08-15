class TurboGameReplicationInfo extends KFGameReplicationInfo;

var TurboGameModifierReplicationLink CustomTurboModifier;

replication
{
    reliable if(bNetInitial && Role == ROLE_Authority)
        CustomTurboModifier;
}

//Reminder that if you override these functions, they must return the same value on the client and server.
simulated function float GetFireRateMultiplier() { if (CustomTurboModifier != None) { return CustomTurboModifier.GetFireRateMultiplier(); } return 1.f; }
simulated function float GetBerserkerFireRateMultiplier() { if (CustomTurboModifier != None) { return CustomTurboModifier.GetBerserkerFireRateMultiplier(); } return 1.f; }
simulated function float GetFirebugFireRateMultiplier() { if (CustomTurboModifier != None) { return CustomTurboModifier.GetFirebugFireRateMultiplier(); } return 1.f; }

simulated function float GetReloadRateMultiplier() { if (CustomTurboModifier != None) { return CustomTurboModifier.GetReloadRateMultiplier(); } return 1.f; }

simulated function float GetMagazineAmmoMultiplier() { if (CustomTurboModifier != None) { return CustomTurboModifier.GetMagazineAmmoMultiplier(); } return 1.f; }
simulated function float GetCommandoMagazineAmmoMultiplier() { if (CustomTurboModifier != None) { return CustomTurboModifier.GetCommandoMagazineAmmoMultiplier(); } return 1.f; }
simulated function float GetMedicMagazineAmmoMultiplier() { if (CustomTurboModifier != None) { return CustomTurboModifier.GetMedicMagazineAmmoMultiplier(); } return 1.f; }

simulated function float GetMaxAmmoMultiplier() { if (CustomTurboModifier != None) { return CustomTurboModifier.GetMaxAmmoMultiplier(); } return 1.f; }
simulated function float GetMedicMaxAmmoMultiplier() { if (CustomTurboModifier != None) { return CustomTurboModifier.GetMedicMaxAmmoMultiplier(); } return 1.f; }

simulated function float GetWeaponSpreadRecoilMultiplier() { if (CustomTurboModifier != None) { return CustomTurboModifier.GetWeaponSpreadRecoilMultiplier(); } return 1.f; }

simulated function float GetTraderCostMultiplier() { if (CustomTurboModifier != None) { return CustomTurboModifier.GetTraderCostMultiplier(); } return 1.f; }
simulated function float GetTraderGrenadeCostMultiplier() { if (CustomTurboModifier != None) { return CustomTurboModifier.GetTraderGrenadeCostMultiplier(); } return 1.f; }

simulated function float GetPlayerMovementSpeedMultiplier() { if (CustomTurboModifier != None) { return CustomTurboModifier.GetPlayerMovementSpeedMultiplier(); } return 1.f; }
simulated function float GetPlayerMaxHealthMultiplier() { if (CustomTurboModifier != None) { return CustomTurboModifier.GetPlayerMaxHealthMultiplier(); } return 1.f; }

//Helpers TurboGameModifierReplicationLinks can call to propagate updates for multiplier changes.
function NotifyPlayerMovementSpeedChanged()
{
    local Controller Controller;
    for ( Controller = Level.ControllerList; Controller != None; Controller = Controller.NextController )
    {
        if (Controller.Pawn != None && Controller.Pawn.Health > 0 && PlayerController(Controller) != None)
        {
            Controller.Pawn.ModifyVelocity(0.f, Controller.Pawn.Velocity);
        }
    }
}

function NotifyPlayerMaxHealthChanged()
{
    local Controller Controller;
    for ( Controller = Level.ControllerList; Controller != None; Controller = Controller.NextController )
    {
        if (Controller.Pawn != None && Controller.Pawn.Health > 0 && PlayerController(Controller) != None)
        {
            Controller.Pawn.HealthMax = Controller.Pawn.default.HealthMax * GetPlayerMaxHealthMultiplier();
            Controller.Pawn.Health = Min(Controller.Pawn.Health, Controller.Pawn.HealthMax);
        }
    }
}