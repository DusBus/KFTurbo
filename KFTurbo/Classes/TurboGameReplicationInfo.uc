class TurboGameReplicationInfo extends KFGameReplicationInfo;

var TurboGameModifierReplicationLink CustomTurboModifier;

replication
{
    reliable if(bNetInitial && Role == ROLE_Authority)
        CustomTurboModifier;
}

//Reminder that if you override these functions, they must return the same value on the client and server.
simulated function float GetFireRateMultiplier(KFPlayerReplicationInfo KFPRI, Weapon Other) { if (CustomTurboModifier != None) { return CustomTurboModifier.GetFireRateMultiplier(KFPRI, Other); } return 1.f; }
simulated function float GetBerserkerFireRateMultiplier(KFPlayerReplicationInfo KFPRI, Weapon Other) { if (CustomTurboModifier != None) { return CustomTurboModifier.GetBerserkerFireRateMultiplier(KFPRI, Other); } return 1.f; }
simulated function float GetFirebugFireRateMultiplier(KFPlayerReplicationInfo KFPRI, Weapon Other) { if (CustomTurboModifier != None) { return CustomTurboModifier.GetFirebugFireRateMultiplier(KFPRI, Other); } return 1.f; }

simulated function float GetReloadRateMultiplier(KFPlayerReplicationInfo KFPRI, Weapon Other) { if (CustomTurboModifier != None) { return CustomTurboModifier.GetReloadRateMultiplier(KFPRI, Other); } return 1.f; }

simulated function float GetMagazineAmmoMultiplier(KFPlayerReplicationInfo KFPRI, KFWeapon Other) { if (CustomTurboModifier != None) { return CustomTurboModifier.GetMagazineAmmoMultiplier(KFPRI, Other); } return 1.f; }
simulated function float GetCommandoMagazineAmmoMultiplier(KFPlayerReplicationInfo KFPRI, KFWeapon Other) { if (CustomTurboModifier != None) { return CustomTurboModifier.GetCommandoMagazineAmmoMultiplier(KFPRI, Other); } return 1.f; }
simulated function float GetMedicMagazineAmmoMultiplier(KFPlayerReplicationInfo KFPRI, KFWeapon Other) { if (CustomTurboModifier != None) { return CustomTurboModifier.GetMedicMagazineAmmoMultiplier(KFPRI, Other); } return 1.f; }

simulated function float GetMaxAmmoMultiplier(KFPlayerReplicationInfo KFPRI, class<Ammunition> AmmoType) { if (CustomTurboModifier != None) { return CustomTurboModifier.GetMaxAmmoMultiplier(KFPRI, AmmoType); } return 1.f; }
simulated function float GetMedicMaxAmmoMultiplier(KFPlayerReplicationInfo KFPRI, class<Ammunition> AmmoType) { if (CustomTurboModifier != None) { return CustomTurboModifier.GetMedicMaxAmmoMultiplier(KFPRI, AmmoType); } return 1.f; }

simulated function float GetWeaponSpreadRecoilMultiplier(KFPlayerReplicationInfo KFPRI, WeaponFire Other) { if (CustomTurboModifier != None) { return CustomTurboModifier.GetWeaponSpreadRecoilMultiplier(KFPRI, Other); } return 1.f; }

simulated function float GetTraderCostMultiplier(KFPlayerReplicationInfo KFPRI, class<Pickup> Item) { if (CustomTurboModifier != None) { return CustomTurboModifier.GetTraderCostMultiplier(KFPRI, Item); } return 1.f; }
simulated function float GetTraderGrenadeCostMultiplier(KFPlayerReplicationInfo KFPRI, class<Pickup> Item) { if (CustomTurboModifier != None) { return CustomTurboModifier.GetTraderGrenadeCostMultiplier(KFPRI, Item); } return 1.f; }

simulated function float GetPlayerMovementSpeedMultiplier(KFPlayerReplicationInfo KFPRI, KFGameReplicationInfo KFGRI) { if (CustomTurboModifier != None) { return CustomTurboModifier.GetPlayerMovementSpeedMultiplier(KFPRI, KFGRI); } return 1.f; }
simulated function float GetPlayerMaxHealthMultiplier(Pawn Pawn) { if (CustomTurboModifier != None) { return CustomTurboModifier.GetPlayerMaxHealthMultiplier(Pawn); } return 1.f; }

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
            Controller.Pawn.HealthMax = Controller.Pawn.default.HealthMax * GetPlayerMaxHealthMultiplier(Controller.Pawn);
            Controller.Pawn.Health = Min(Controller.Pawn.Health, Controller.Pawn.HealthMax);
        }
    }
}