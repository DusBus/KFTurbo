class TurboGameModifierReplicationLink extends ReplicationInfo
    abstract;

var TurboGameModifierReplicationLink NextGameModifierLink;
var TurboGameReplicationInfo OwnerGRI;

replication
{
    reliable if(bNetInitial && Role == ROLE_Authority)
        NextGameModifierLink, OwnerGRI;
}

//Reminder that if you override these functions, they must return the same value on the client and server.
simulated function float GetFireRateMultiplier() { if (NextGameModifierLink != None) { return NextGameModifierLink.GetFireRateMultiplier(); } return 1.f; }
simulated function float GetBerserkerFireRateMultiplier() { if (NextGameModifierLink != None) { return NextGameModifierLink.GetBerserkerFireRateMultiplier(); } return 1.f; }
simulated function float GetFirebugFireRateMultiplier() { if (NextGameModifierLink != None) { return NextGameModifierLink.GetFirebugFireRateMultiplier(); } return 1.f; }

simulated function float GetReloadRateMultiplier() { if (NextGameModifierLink != None) { return NextGameModifierLink.GetReloadRateMultiplier(); } return 1.f; }

simulated function float GetMagazineAmmoMultiplier() { if (NextGameModifierLink != None) { return NextGameModifierLink.GetMagazineAmmoMultiplier(); } return 1.f; }
simulated function float GetCommandoMagazineAmmoMultiplier() { if (NextGameModifierLink != None) { return NextGameModifierLink.GetCommandoMagazineAmmoMultiplier(); } return 1.f; }
simulated function float GetMedicMagazineAmmoMultiplier() { if (NextGameModifierLink != None) { return NextGameModifierLink.GetMedicMagazineAmmoMultiplier(); } return 1.f; }

simulated function float GetMaxAmmoMultiplier() { if (NextGameModifierLink != None) { return NextGameModifierLink.GetMaxAmmoMultiplier(); } return 1.f; }
simulated function float GetMedicMaxAmmoMultiplier() { if (NextGameModifierLink != None) { return NextGameModifierLink.GetMedicMaxAmmoMultiplier(); } return 1.f; }

simulated function float GetWeaponSpreadRecoilMultiplier() { if (NextGameModifierLink != None) { return NextGameModifierLink.GetWeaponSpreadRecoilMultiplier(); } return 1.f; }

simulated function float GetTraderCostMultiplier() { if (NextGameModifierLink != None) { return NextGameModifierLink.GetTraderCostMultiplier(); } return 1.f; }
simulated function float GetTraderGrenadeCostMultiplier() { if (NextGameModifierLink != None) { return NextGameModifierLink.GetTraderGrenadeCostMultiplier(); } return 1.f; }

simulated function float GetPlayerMovementSpeedMultiplier() { if (NextGameModifierLink != None) { return NextGameModifierLink.GetPlayerMovementSpeedMultiplier(); } return 1.f; }
simulated function float GetPlayerMaxHealthMultiplier() { if (NextGameModifierLink != None) { return NextGameModifierLink.GetPlayerMaxHealthMultiplier(); } return 1.f; }

//Make NetUpdateTime want to update now.
simulated function ForceNetUpdate()
{
    NetUpdateTime = Level.TimeSeconds - ((1.f / NetUpdateFrequency) + 1.f);
}

defaultproperties
{
    NetUpdateFrequency=0.1f
}