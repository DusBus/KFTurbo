class TurboGameReplicationInfo extends KFGameReplicationInfo;

//Higher means faster.
var(Turbo) float FireRateMultiplier;
var(Turbo) float ReloadRateMultiplier;

var(Turbo) float MagazineAmmoMultiplier;
var(Turbo) float MaxAmmoMultiplier;

var(Turbo) float WeaponSpreadMultiplier;

replication
{
    reliable if(bNetDirty && Role == ROLE_Authority)
        FireRateMultiplier, ReloadRateMultiplier, 
        MagazineAmmoMultiplier, MaxAmmoMultiplier,
        WeaponSpreadMultiplier;
}

defaultproperties
{
    FireRateMultiplier=1.f
    ReloadRateMultiplier=1.f

    MagazineAmmoMultiplier=1.f
    MaxAmmoMultiplier=1.f

    WeaponSpreadMultiplier=1.f
}