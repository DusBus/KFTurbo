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
simulated function float GetFireRateMultiplier(KFPlayerReplicationInfo KFPRI, Weapon Other) { if (NextGameModifierLink != None) { return NextGameModifierLink.GetFireRateMultiplier(KFPRI, Other); } return 1.f; }
simulated function float GetBerserkerFireRateMultiplier(KFPlayerReplicationInfo KFPRI, Weapon Other) { if (NextGameModifierLink != None) { return NextGameModifierLink.GetBerserkerFireRateMultiplier(KFPRI, Other); } return 1.f; }
simulated function float GetFirebugFireRateMultiplier(KFPlayerReplicationInfo KFPRI, Weapon Other) { if (NextGameModifierLink != None) { return NextGameModifierLink.GetFirebugFireRateMultiplier(KFPRI, Other); } return 1.f; }

simulated function float GetReloadRateMultiplier(KFPlayerReplicationInfo KFPRI, Weapon Other) { if (NextGameModifierLink != None) { return NextGameModifierLink.GetReloadRateMultiplier(KFPRI, Other); } return 1.f; }

simulated function float GetMagazineAmmoMultiplier(KFPlayerReplicationInfo KFPRI, KFWeapon Other) { if (NextGameModifierLink != None) { return NextGameModifierLink.GetMagazineAmmoMultiplier(KFPRI, Other); } return 1.f; }
simulated function float GetCommandoMagazineAmmoMultiplier(KFPlayerReplicationInfo KFPRI, KFWeapon Other) { if (NextGameModifierLink != None) { return NextGameModifierLink.GetCommandoMagazineAmmoMultiplier(KFPRI, Other); } return 1.f; }
simulated function float GetMedicMagazineAmmoMultiplier(KFPlayerReplicationInfo KFPRI, KFWeapon Other) { if (NextGameModifierLink != None) { return NextGameModifierLink.GetMedicMagazineAmmoMultiplier(KFPRI, Other); } return 1.f; }

simulated function float GetMaxAmmoMultiplier(KFPlayerReplicationInfo KFPRI, class<Ammunition> AmmoType) { if (NextGameModifierLink != None) { return NextGameModifierLink.GetMaxAmmoMultiplier(KFPRI, AmmoType); } return 1.f; }
simulated function float GetMedicMaxAmmoMultiplier(KFPlayerReplicationInfo KFPRI, class<Ammunition> AmmoType) { if (NextGameModifierLink != None) { return NextGameModifierLink.GetMedicMaxAmmoMultiplier(KFPRI, AmmoType); } return 1.f; }

simulated function float GetWeaponSpreadRecoilMultiplier(KFPlayerReplicationInfo KFPRI, WeaponFire Other) { if (NextGameModifierLink != None) { return NextGameModifierLink.GetWeaponSpreadRecoilMultiplier(KFPRI, Other); } return 1.f; }

simulated function float GetTraderCostMultiplier(KFPlayerReplicationInfo KFPRI, class<Pickup> Item) { if (NextGameModifierLink != None) { return NextGameModifierLink.GetTraderCostMultiplier(KFPRI, Item); } return 1.f; }
simulated function float GetTraderGrenadeCostMultiplier(KFPlayerReplicationInfo KFPRI, class<Pickup> Item) { if (NextGameModifierLink != None) { return NextGameModifierLink.GetTraderGrenadeCostMultiplier(KFPRI, Item); } return 1.f; }

simulated function float GetPlayerMovementSpeedMultiplier(KFPlayerReplicationInfo KFPRI, KFGameReplicationInfo KFGRI) { if (NextGameModifierLink != None) { return NextGameModifierLink.GetPlayerMovementSpeedMultiplier(KFPRI, KFGRI); } return 1.f; }
simulated function float GetPlayerMaxHealthMultiplier(Pawn Pawn) { if (NextGameModifierLink != None) { return NextGameModifierLink.GetPlayerMaxHealthMultiplier(Pawn); } return 1.f; }

//Make NetUpdateTime want to update now.
simulated function ForceNetUpdate()
{
    NetUpdateTime = Level.TimeSeconds - ((1.f / NetUpdateFrequency) + 1.f);
}

defaultproperties
{
    NetUpdateFrequency=0.1f
}