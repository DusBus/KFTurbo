//Killing Floor Turbo TurboCardGameModifierRepLink
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboCardGameModifierRepLink extends TurboGameModifierReplicationLink
    hidecategories(Advanced,Display,Events,Object,Sound);

//Higher means faster.
var(Turbo) float FireRateMultiplier;
var(Turbo) float ZedTimeDualPistolFireRateMultiplier;
var(Turbo) float BerserkerFireRateMultiplier;
var(Turbo) float FirebugFireRateMultiplier;

var(Turbo) float ReloadRateMultiplier;

var(Turbo) float MagazineAmmoMultiplier;
var(Turbo) float DualWeaponMagazineAmmoMultiplier;
var(Turbo) float CommandoMagazineAmmoMultiplier;
var(Turbo) float MedicMagazineAmmoMultiplier;

var(Turbo) float MaxAmmoMultiplier;
var(Turbo) float MedicMaxAmmoMultiplier;
var(Turbo) float GrenadeMaxAmmoMultiplier;

var(Turbo) float WeaponPenetrationMultiplier;
var(Turbo) float WeaponSpreadRecoilMultiplier;
var(Turbo) float ShotgunPelletCountMultiplier;
var(Turbo) float ShotgunSpreadRecoilMultiplier;
var(Turbo) float ShotgunKickBackMultiplier;

var(Turbo) float TraderCostMultiplier;
var(Turbo) float TraderGrenadeCostMultiplier;
var(Turbo) bool bDisableArmorPurchase;

//Modify this variable via ApplyPlayerMovementSpeedModifier since it needs to notify pawns to update movement speed.
var(Turbo) float PlayerMovementSpeedMultiplier;
var(Turbo) float PlayerMovementAccelMultiplier;
var(Turbo) bool bFreezePlayersDuringWave;
var(Turbo) bool bMoneySlowsPlayers;
var(Turbo) bool bMissingHealthStronglySlows;

//Same as above but for max health.
var(Turbo) float PlayerMaxHealthMultiplier;
var(Turbo) int PlayerMaxCarryWeightModifier;

var(Turbo) int PlayerZedTimeExtensionsModifier;
var(Turbo) int PlayerDualPistolZedTimeExtensionsModifier;

var(Turbo) float MedicHealPotencyMultiplier, NonMedicHealPotencyMultiplier;
var(Turbo) float BodyArmorDamageModifier;
var(Turbo) float HealRechargeMultiplier;

replication
{
    reliable if(bNetDirty && Role == ROLE_Authority)
        FireRateMultiplier, ZedTimeDualPistolFireRateMultiplier, BerserkerFireRateMultiplier, FirebugFireRateMultiplier,
        ReloadRateMultiplier, 
        MagazineAmmoMultiplier, CommandoMagazineAmmoMultiplier, MedicMagazineAmmoMultiplier,
        MaxAmmoMultiplier, MedicMaxAmmoMultiplier, GrenadeMaxAmmoMultiplier,
        WeaponPenetrationMultiplier,
        WeaponSpreadRecoilMultiplier, ShotgunSpreadRecoilMultiplier,
        TraderCostMultiplier, TraderGrenadeCostMultiplier, bDisableArmorPurchase,
        PlayerMovementSpeedMultiplier, PlayerMovementAccelMultiplier, bFreezePlayersDuringWave, bMoneySlowsPlayers, bMissingHealthStronglySlows,
        PlayerMaxHealthMultiplier,
        HealRechargeMultiplier;
} 

simulated function float GetFireRateMultiplier(KFPlayerReplicationInfo KFPRI, Weapon Other)
{
    local float Multiplier;
    Multiplier = Super.GetFireRateMultiplier(KFPRI, Other);
    Multiplier *= FireRateMultiplier;   

    if (Level.TimeDilation < 1.f && KFWeapon(Other) != None && KFWeapon(Other).bDualWeapon)
    {
        Multiplier *= ZedTimeDualPistolFireRateMultiplier;
    }

    return Multiplier;
}

simulated function float GetBerserkerFireRateMultiplier(KFPlayerReplicationInfo KFPRI, Weapon Other) { return Super.GetBerserkerFireRateMultiplier(KFPRI, Other) * BerserkerFireRateMultiplier; }
simulated function float GetFirebugFireRateMultiplier(KFPlayerReplicationInfo KFPRI, Weapon Other) { return Super.GetFirebugFireRateMultiplier(KFPRI, Other) * FirebugFireRateMultiplier; }

simulated function float GetReloadRateMultiplier(KFPlayerReplicationInfo KFPRI, Weapon Other) { return Super.GetFirebugFireRateMultiplier(KFPRI, Other) * ReloadRateMultiplier; }

simulated function float GetMagazineAmmoMultiplier(KFPlayerReplicationInfo KFPRI, KFWeapon Other)
{
    local float Multiplier;
    Multiplier = MagazineAmmoMultiplier;

    if (Other.bDualWeapon)
    {
        Multiplier *= DualWeaponMagazineAmmoMultiplier;
    }

    return Super.GetMagazineAmmoMultiplier(KFPRI, Other) * Multiplier;
}

simulated function float GetCommandoMagazineAmmoMultiplier(KFPlayerReplicationInfo KFPRI, KFWeapon Other) { return Super.GetCommandoMagazineAmmoMultiplier(KFPRI, Other) * CommandoMagazineAmmoMultiplier; }
simulated function float GetMedicMagazineAmmoMultiplier(KFPlayerReplicationInfo KFPRI, KFWeapon Other) { return Super.GetMedicMagazineAmmoMultiplier(KFPRI, Other) * MedicMagazineAmmoMultiplier; }

simulated function float GetMaxAmmoMultiplier(KFPlayerReplicationInfo KFPRI, class<Ammunition> AmmoType)
{
    local float Multiplier;
    Multiplier = MaxAmmoMultiplier;
    if (class<FragAmmo>(AmmoType) != None)
    {
        Multiplier *= GrenadeMaxAmmoMultiplier;
    }

    return Super.GetMaxAmmoMultiplier(KFPRI, AmmoType) * Multiplier;
}

simulated function float GetMedicMaxAmmoMultiplier(KFPlayerReplicationInfo KFPRI, class<Ammunition> AmmoType) { return Super.GetMedicMaxAmmoMultiplier(KFPRI, AmmoType) * MedicMaxAmmoMultiplier; }

simulated function float GetWeaponPenetrationMultiplier(KFPlayerReplicationInfo KFPRI, WeaponFire Other) { return Super.GetWeaponPenetrationMultiplier(KFPRI, Other) * WeaponPenetrationMultiplier; }
simulated function float GetWeaponSpreadRecoilMultiplier(KFPlayerReplicationInfo KFPRI, WeaponFire Other)
{
    local float Multiplier;
    Multiplier = Super.GetWeaponSpreadRecoilMultiplier(KFPRI, Other) * WeaponSpreadRecoilMultiplier;
    
    if (ShotgunSpreadRecoilMultiplier != 1.f && ShotgunFire(Other) != None && ShotgunFire(Other).default.ProjPerFire > 1)
    {
        Multiplier *= ShotgunSpreadRecoilMultiplier;
    }

    return Multiplier;
}

simulated function float GetTraderCostMultiplier(KFPlayerReplicationInfo KFPRI, class<Pickup> Item)
{
    if (bDisableArmorPurchase && class<Vest>(Item) != None)
    {
        return -1.f;
    }
    
    return Super.GetTraderCostMultiplier(KFPRI, Item) * TraderCostMultiplier; 
}
simulated function float GetTraderGrenadeCostMultiplier(KFPlayerReplicationInfo KFPRI, class<Pickup> Item) { return Super.GetTraderGrenadeCostMultiplier(KFPRI, Item) * TraderGrenadeCostMultiplier; }

simulated function float GetPlayerMovementSpeedMultiplier(KFPlayerReplicationInfo KFPRI, KFGameReplicationInfo KFGRI) 
{
    local float Multiplier;
    if (bFreezePlayersDuringWave && KFGRI != None && KFGRI.bWaveInProgress)
    {
        return 0.0001f;
    }

    Multiplier = PlayerMovementSpeedMultiplier;

    if (bMoneySlowsPlayers)
    {
        Multiplier *= FClamp(Lerp((KFPRI.Score - 800.f) / 5200.f, 1.f, 0.01f), 0.01f, 1.f);
    }

    if (bMissingHealthStronglySlows && Controller(KFPRI.Owner) != None && (float(Controller(KFPRI.Owner).Pawn.Health) / Controller(KFPRI.Owner).Pawn.HealthMax) < 0.75f)
    {
        Multiplier *= 0.75f;
    }
    
    return Super.GetPlayerMovementSpeedMultiplier(KFPRI, KFGRI) * Multiplier;
}

simulated function float GetPlayerMovementAccelMultiplier(KFPlayerReplicationInfo KFPRI, KFGameReplicationInfo KFGRI)
{
    return Super.GetPlayerMovementAccelMultiplier(KFPRI, KFGRI) * PlayerMovementAccelMultiplier;
}

simulated function float GetPlayerMaxHealthMultiplier(Pawn Pawn)
{
    return Super.GetPlayerMaxHealthMultiplier(Pawn) * PlayerMaxHealthMultiplier;
}

simulated function float GetHealRechargeMultiplier(KFPlayerReplicationInfo KFPRI)
{
    return Super.GetHealRechargeMultiplier(KFPRI) * HealRechargeMultiplier;
}

function GetPlayerCarryWeightModifier(KFPlayerReplicationInfo KFPRI, out int OutCarryWeightModifier)
{
    Super.GetPlayerCarryWeightModifier(KFPRI, OutCarryWeightModifier);

    OutCarryWeightModifier += PlayerMaxCarryWeightModifier;
}

function GetPlayerZedExtensionModifier(KFPlayerReplicationInfo KFPRI, out int OutZedExtensions)
{
    Super.GetPlayerZedExtensionModifier(KFPRI, OutZedExtensions);

    OutZedExtensions += PlayerZedTimeExtensionsModifier;

    if (PlayerDualPistolZedTimeExtensionsModifier != 0 && ShouldApplyDualPistolZedTimeExtensionModifier(KFPRI))
    {
        OutZedExtensions += PlayerDualPistolZedTimeExtensionsModifier;
    }
}

function bool ShouldApplyDualPistolZedTimeExtensionModifier(KFPlayerReplicationInfo KFPRI)
{
    local Controller Controller;
    local Pawn Pawn;
    local KFWeapon Weapon;

    Controller = Controller(KFPRI.Owner);
    if (Controller == None)
    {
        return false;
    }

    Pawn = Controller.Pawn;
    if (Pawn == None)
    {
        return false;
    }

    Weapon = KFWeapon(Pawn.Weapon);
    if (Weapon == None)
    {
        return false;
    }

    return Weapon.bDualWeapon;
}

function float GetHealPotencyMultiplier(KFPlayerReplicationInfo KFPRI)
{
    local float Multiplier;
    Multiplier = Super.GetHealPotencyMultiplier(KFPRI);

    if (KFPRI != None && class<V_FieldMedic>(KFPRI.ClientVeteranSkill) != None)
    {
        Multiplier *= MedicHealPotencyMultiplier;
    }
    else
    {
        Multiplier *= NonMedicHealPotencyMultiplier;
    }

    return Multiplier;
}

function GetBodyArmorDamageModifier(KFPlayerReplicationInfo KFPRI, out float Multiplier)
{
    Multiplier *= BodyArmorDamageModifier;
}

function OnShotgunFire(KFShotgunFire ShotgunFire)
{
    if (ShotgunFire.default.ProjPerFire > 1)
    {
        ShotgunFire.ProjPerFire = float(ShotgunFire.default.ProjPerFire) * ShotgunPelletCountMultiplier;
    }
    
    ShotgunFire.KickMomentum = ShotgunFire.default.KickMomentum * ShotgunKickBackMultiplier;
}

defaultproperties
{
    FireRateMultiplier=1.f
    ZedTimeDualPistolFireRateMultiplier=1.f
    BerserkerFireRateMultiplier=1.f
    FirebugFireRateMultiplier=1.f

    ReloadRateMultiplier=1.f

    MagazineAmmoMultiplier=1.f
    DualWeaponMagazineAmmoMultiplier=1.f
    CommandoMagazineAmmoMultiplier=1.f
    MedicMagazineAmmoMultiplier=1.f

    MaxAmmoMultiplier=1.f
    MedicMaxAmmoMultiplier=1.f
    GrenadeMaxAmmoMultiplier=1.f

    WeaponPenetrationMultiplier=1.f
    WeaponSpreadRecoilMultiplier=1.f
    ShotgunPelletCountMultiplier=1.f
    ShotgunSpreadRecoilMultiplier=1.f
    ShotgunKickBackMultiplier=1.f

    TraderCostMultiplier=1.f
    TraderGrenadeCostMultiplier=1.f
    bDisableArmorPurchase=false

    PlayerMovementSpeedMultiplier=1.f
    PlayerMovementAccelMultiplier=1.f
    bFreezePlayersDuringWave=false
    bMoneySlowsPlayers=false
    bMissingHealthStronglySlows=false
    
    PlayerMaxHealthMultiplier=1.f
    
    PlayerMaxCarryWeightModifier=0

    MedicHealPotencyMultiplier=1.f
    NonMedicHealPotencyMultiplier=1.f
    BodyArmorDamageModifier=1.f
    HealRechargeMultiplier=1.f
}