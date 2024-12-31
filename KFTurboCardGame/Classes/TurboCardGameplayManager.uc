//Killing Floor Turbo TurboCardGameplayManager
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboCardGameplayManager extends TurboCardGameplayManagerBase;

////////////////////
//GAME MODIFIERS

//WAVE
var automated CardModifierStack GameWaveSpeedModifier; //Distinct from the modifier that cards apply. Used to increase difficulty throughout card game.
var automated CardModifierStack WaveSpeedModifier;
var automated CardModifierStack MaxMonstersModifier;
var CardModifierStack TotalMonstersModifier;
var CardModifierStack CashBonusModifier;
var CardFlag BorrowedTimeFlag;
var PlayerBorrowedTimeActor BorrwedTimeManager;
var CardFlag PlainSightSpawnFlag;
//var PlainSightSpawningActor PlainSightManager;
var CardFlag RandomTraderChangeFlag;
var RandomTraderManager RandomTraderManager;

//CARD GAME
var CardDeltaStack CardSelectionCountDelta;
var CardFlag CurseOfRaFlag;

//FRIENDLY FIRE
var CardModifierStack FriendlyFireModifier;

//DAMAGE
var CardFlag BleedDamageFlag;
var CardFlag NoRestForTheWickedFlag;

//DEATH
var CardFlag SuddenDeathFlag;
var CardFlag CheatDeathFlag;

//INVENTORY
var CardFlag NoSyringeFlag;
var CardFlag SuperGrenadesFlag;

////////////////////
//PLAYER MODIFIERS

//HEALTH
var CardModifierStack PlayerMaxHealthModifier;

//CARRY CAPACITY
var CardDeltaStack PlayerCarryCapacityDelta;

//TRADER
var CardModifierStack TraderPriceModifier;
var CardModifierStack TraderGrenadePriceModifier;

//DAMAGE
var CardModifierStack PlayerDamageModifier;
var CardModifierStack PlayerRangedDamageModifier;
var CardModifierStack PlayerMeleeDamageModifier;
var CardModifierStack PlayerShotgunDamageModifier;
var CardModifierStack PlayerFireDamageModifier;
var CardModifierStack PlayerExplosiveDamageModifier;
var CardModifierStack PlayerExplosiveRadiusModifier;
var CardModifierStack PlayerOnPerkDamageModifier;
var CardModifierStack PlayerOffPerkDamageModifier;

var CardModifierStack PlayerMedicGrenadeDamageModifier;
var CardModifierStack PlayerBerserkerMeleeDamageModifier;

var CardModifierStack PlayerNonEliteDamageModifier;
var CardModifierStack PlayerNonEliteHeadshotDamageModifier;

var CardModifierStack PlayerSlomoDamageModifier;
var CardModifierStack PlayerLowHealthDamageModifier;

var CardModifierStack PlayerFleshpoundDamageModifier;
var CardModifierStack PlayerScrakeDamageModifier;

var CardFlag PlayerMassDetonationFlag;

//DAMAGE RECEIVED
var CardModifierStack PlayerArmorStrengthModifier;
var CardModifierStack PlayerFallDamageModifier;

//FIRE RATE
var CardModifierStack PlayerFireRateModifier;
var CardModifierStack PlayerBerserkerFireRateModifier;
var CardModifierStack PlayerFirebugFireRateModifier;
var CardModifierStack PlayerZedTimeDualWeaponFireRateModifier;

//MAGAZINE AMMO
var CardModifierStack PlayerMagazineAmmoModifier;
var CardModifierStack PlayerCommandoMagazineAmmoModifier;
var CardModifierStack PlayerMedicMagazineAmmoModifier;
var CardModifierStack PlayerDualWeaponMagazineAmmoModifier;

//RELOAD RATE
var CardModifierStack PlayerReloadRateModifier;
var CardModifierStack PlayerCommandoReloadRateModifier;
var CardModifierStack PlayerZedTimeDualWeaponReloadRateModifier;

//EQUIP RATE
var CardModifierStack PlayerEquipRateModifier;
var CardModifierStack PlayerZedTimeDualWeaponEquipRateModifier;

//MAX AMMO
var CardModifierStack PlayerMaxAmmoModifier;
var CardModifierStack PlayerCommandoMaxAmmoModifier;
var CardModifierStack PlayerMedicMaxAmmoModifier;
var CardModifierStack PlayerGrenadeMaxAmmoModifier;

//SPREAD AND RECOIL
var CardModifierStack PlayerSpreadRecoilModifier;
var CardModifierStack PlayerShotgunSpreadRecoilModifier;

//PENETRATION
var CardModifierStack PlayerPenetrationModifier;

//SHOTGUN
var CardModifierStack PlayerShotgunPelletModifier;
var CardModifierStack PlayerShotgunKickbackModifier;

//ZED TIME EXTENSIONS
var CardDeltaStack PlayerZedTimeExtensionDelta;
var CardDeltaStack PlayerDualWeaponZedTimeExtensionDelta;

//DAMAGE TAKEN
var CardModifierStack PlayerExplosiveDamageTakenModifier;

//HEALING
var CardModifierStack PlayerNonMedicHealPotencyModifier;
var CardModifierStack PlayerMedicHealPotencyModifier;
var CardModifierStack PlayerHealRechargeModifier;

//MOVEMENT
var CardModifierStack PlayerMovementSpeedModifier;
var CardModifierStack PlayerMovementAccelModifier;
var CardModifierStack PlayerMovementFrictionModifier;
var CardFlag PlayerFreezeTagFlag;
var CardFlag PlayerGreedSlowsFlag;
var CardFlag PlayerLowHealthSlowsFlag;

//THORNS
var CardModifierStack PlayerThornsModifier;

////////////////////
//MONSTER MODIFIERS

//DAMAGE
var CardModifierStack MonsterDamageModifier;
var CardModifierStack MonsterDamageMomentumModifier;
var CardModifierStack MonsterMeleeDamageModifier;
var CardModifierStack MonsterRangedDamageModifier;
var CardModifierStack MonsterStalkerMeleeDamageModifier;
var CardModifierStack MonsterSirenScreamDamageModifier;
var CardModifierStack MonsterSirenScreamRangeModifier;

//SCALING
var CardModifierStack MonsterHeadSizeModifier;
var CardModifierStack MonsterStalkerDistractionModifier;

//MOVEMENT
var CardModifierStack MonsterBloatMovementSpeedModifier;

//AI
var CardModifierStack MonsterFleshpoundRageThresholdModifier;
var CardModifierStack MonsterScrakeRageThresholdModifier;
var CardModifierStack MonsterHuskRefireTimeModifier;

function WaveSpeedModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    //MaxMonstersModifier.CachedModifier;
}

function MaxMonstersModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    //MaxMonstersModifier.CachedModifier;
}

function TotalMonstersModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    //MaxMonstersModifier.CachedModifier;
}

function CashBonusModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function BorrowedTimeCardFlagChanged(CardFlag Flag, bool bIsEnabled)
{

}

function PlainSightSpawnCardFlagChanged(CardFlag Flag, bool bIsEnabled)
{

}

function RandomTraderChangeFlagChanged(CardFlag Flag, bool bIsEnabled)
{

}

//CARD GAME
function CardSelectionCountDeltaChanged(CardDeltaStack ChangedDelta, int Delta)
{

}

function CurseOfRaFlagChanged(CardFlag Flag, bool bIsEnabled)
{

}

//FRIENDLY FIRE
function FriendlyFireModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

//DAMAGE
function BleedDamageFlagChanged(CardFlag Flag, bool bIsEnabled)
{

}

function NoRestForTheWickedFlagChanged(CardFlag Flag, bool bIsEnabled)
{

}

function SuddenDeathFlagChanged(CardFlag Flag, bool bIsEnabled)
{

}

function CheatDeathFlagChanged(CardFlag Flag, bool bIsEnabled)
{

}

//INVENTORY
function NoSyringeFlagChanged(CardFlag Flag, bool bIsEnabled)
{

}

function SuperGrenadesFlagChanged(CardFlag Flag, bool bIsEnabled)
{

}

////////////////////
//PLAYER MODIFIERS

//HEALTH
function PlayerMaxHealthModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

//CARRY CAPACITY
function PlayerCarryCapacityDeltaChanged(CardDeltaStack ChangedDelta, int Delta)
{

}

//TRADER
function TraderPriceModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function TraderGrenadePriceModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

//DAMAGE
function PlayerDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function PlayerRangedDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function PlayerMeleeDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function PlayerShotgunDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function PlayerFireDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function PlayerExplosiveDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function PlayerOnPerkDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function PlayerOffPerkDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function PlayerMedicGrenadeDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function PlayerBerserkerMeleeDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function PlayerNonEliteDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function PlayerNonEliteHeadshotDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function PlayerSlomoDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function PlayerLowHealthDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function PlayerFleshpoundDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function PlayerScrakeDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function PlayerMassDetonationCardFlagChanged(CardFlag Flag, bool bIsEnabled)
{
    
}

//DAMAGE RECEIVED
function PlayerArmorStrengthModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function PlayerFallDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

//FIRERATE
function PlayerFireRateModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function PlayerBerserkerFireRateModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function PlayerFirebugFireRateModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function PlayerZedTimeDualWeaponFireRateModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

//MAGAZINE AMMO
function PlayerMagazineAmmoModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function PlayerCommandoMagazineAmmoModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function PlayerMedicMagazineAmmoModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function PlayerDualWeaponMagazineAmmoModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

//RELOAD RATE
function PlayerReloadRateModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function PlayerCommandoReloadRateModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function PlayerZedTimeDualWeaponReloadRateModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

//EQUIP RATE
function PlayerEquipRateModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function PlayerZedTimeDualWeaponEquipRateModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

//MAX AMMO
function PlayerMaxAmmoModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function PlayerCommandoMaxAmmoModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function PlayerMedicMaxAmmoModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function PlayerGrenadeMaxAmmoModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

//SPREAD AND RECOIL
function PlayerSpreadRecoilModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function PlayerShotgunSpreadRecoilModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

//PENETRATION
function PlayerPenetrationModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

//SHOTGUN
function PlayerShotgunPelletModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function PlayerShotgunKickbackModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

//ZED TIME EXTENSIONS
function PlayerZedTimeExtensionDeltaChanged(CardDeltaStack DeltaStack, int Delta)
{
    
}

function PlayerDualWeaponZedTimeExtensionDeltaChanged(CardDeltaStack DeltaStack, int Delta)
{
    
}

//DAMAGE TAKEN
function PlayerExplosiveDamageTakenModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

//HEALING
function PlayerNonMedicHealPotencyModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function PlayerMedicHealPotencyModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function PlayerHealRechargeModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

//MOVEMENT
function PlayerMovementSpeedModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function PlayerMovementAccelModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function PlayerMovementFrictionModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function PlayerFreezeTagFlagChanged(Cardflag ModifiedStack, bool bIsEnabled)
{
    
}

function PlayerGreedSlowsFlagChanged(Cardflag ModifiedStack, bool bIsEnabled)
{
    
}

function PlayerLowHealthSlowsFlagChanged(Cardflag ModifiedStack, bool bIsEnabled)
{
    
}

//THORNS
function PlayerThornsModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

////////////////////
//MONSTER MODIFIERS

//DAMAGE
function MonsterDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function MonsterDamageMomentumModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function MonsterMeleeDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function MonsterRangedDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function MonsterStalkerMeleeDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function MonsterSirenScreamDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function MonsterSirenScreamRangeModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

//SCALING
function MonsterHeadSizeModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function MonsterStalkerDistractionModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

//MOVEMENT
function MonsterBloatMovementSpeedModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

//AI
function MonsterFleshpoundRageThresholdModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function MonsterScrakeRageThresholdModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

function MonsterHuskRefireTimeModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    
}

defaultproperties
{
    Begin Object Name=GameWaveSpeedModifierStack Class=CardModifierStack
        OnModifierChanged=WaveSpeedModifierChanged
    End Object
    GameWaveSpeedModifier=CardModifierStack'GameWaveSpeedModifierStack'

    Begin Object Name=WaveSpeedModifierStack Class=CardModifierStack
        OnModifierChanged=WaveSpeedModifierChanged
    End Object
    WaveSpeedModifier=CardModifierStack'WaveSpeedModifierStack'

    Begin Object Name=MaxMonstersModifierStack Class=CardModifierStack
        OnModifierChanged=MaxMonstersModifierChanged
    End Object
    MaxMonstersModifier=CardModifierStack'MaxMonstersModifierStack'

    Begin Object Name=TotalMonstersModifierStack Class=CardModifierStack
        OnModifierChanged=TotalMonstersModifierChanged
    End Object
    TotalMonstersModifier=CardModifierStack'TotalMonstersModifierStack'

    Begin Object Name=CashBonusModifierStack Class=CardModifierStack
        OnModifierChanged=CashBonusModifierChanged
    End Object
    CashBonusModifier=CardModifierStack'CashBonusModifierStack'

    Begin Object Name=BorrowedTimeCardFlag Class=CardFlag
        OnFlagSetChanged=BorrowedTimeCardFlagChanged
    End Object
    BorrowedTimeFlag=CardFlag'BorrowedTimeCardFlag'

    Begin Object Name=PlainSightSpawnCardFlag Class=CardFlag
        OnFlagSetChanged=PlainSightSpawnCardFlagChanged
    End Object
    PlainSightSpawnFlag=CardFlag'PlainSightSpawnCardFlag'

    Begin Object Name=RandomTraderChangeCardFlag Class=CardFlag
        OnFlagSetChanged=RandomTraderChangeFlagChanged
    End Object
    RandomTraderChangeFlag=CardFlag'RandomTraderChangeCardFlag'

//CARD GAME
    Begin Object Name=CardSelectionCountDeltaStack Class=CardDeltaStack
        OnDeltaChanged=CardSelectionCountDeltaChanged
    End Object
    CardSelectionCountDelta=CardDeltaStack'CardSelectionCountDeltaStack'
    
    Begin Object Name=CurseOfRaCardFlag Class=CardFlag
        OnFlagSetChanged=CurseOfRaFlagChanged
    End Object
    CurseOfRaFlag=CardFlag'CurseOfRaCardFlag'

//FRIENDLY FIRE
    Begin Object Name=FriendlyFireModifierStack Class=CardModifierStack
        OnModifierChanged=FriendlyFireModifierChanged
    End Object
    FriendlyFireModifier=CardModifierStack'FriendlyFireModifierStack'
    
//DAMAGE
    Begin Object Name=BleedDamageCardFlag Class=CardFlag
        OnFlagSetChanged=BleedDamageFlagChanged
    End Object
    BleedDamageFlag=CardFlag'BleedDamageCardFlag'
    
    Begin Object Name=NoRestForTheWickedCardFlag Class=CardFlag
        OnFlagSetChanged=NoRestForTheWickedFlagChanged
    End Object
    NoRestForTheWickedFlag=CardFlag'NoRestForTheWickedCardFlag'

//DEATH
    Begin Object Name=SuddenDeathCardFlag Class=CardFlag
        OnFlagSetChanged=SuddenDeathFlagChanged
    End Object
    SuddenDeathFlag=CardFlag'SuddenDeathCardFlag'

    Begin Object Name=CheatDeathCardFlag Class=CardFlag
        OnFlagSetChanged=CheatDeathFlagChanged
    End Object
    CheatDeathFlag=CardFlag'CheatDeathCardFlag'
    
//INVENTORY
    Begin Object Name=NoSyringeCardFlag Class=CardFlag
        OnFlagSetChanged=NoSyringeFlagChanged
    End Object
    NoSyringeFlag=CardFlag'NoSyringeCardFlag'

    Begin Object Name=SuperGrenadesCardFlag Class=CardFlag
        OnFlagSetChanged=SuperGrenadesFlagChanged
    End Object
    SuperGrenadesFlag=CardFlag'SuperGrenadesCardFlag'
    

////////////////////
//PLAYER MODIFIERS

//HEALTH
    Begin Object Name=PlayerMaxHealthModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerMaxHealthModifierChanged
    End Object
    PlayerMaxHealthModifier=CardModifierStack'PlayerMaxHealthModifierStack'

//CARRY CAPACITY
    Begin Object Name=PlayerCarryCapacityDeltaStack Class=CardDeltaStack
        OnDeltaChanged=PlayerCarryCapacityDeltaChanged
    End Object
    PlayerCarryCapacityDelta=CardDeltaStack'PlayerCarryCapacityDeltaStack'

//TRADER
    Begin Object Name=TraderPriceModifierStack Class=CardModifierStack
        OnModifierChanged=TraderPriceModifierChanged
    End Object
    TraderPriceModifier=CardModifierStack'TraderPriceModifierStack'

    Begin Object Name=TraderGrenadePriceStack Class=CardModifierStack
        OnModifierChanged=TraderGrenadePriceModifierChanged
    End Object
    TraderGrenadePriceModifier=CardModifierStack'TraderGrenadePriceStack'

//DAMAGE
    Begin Object Name=PlayerDamageModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerDamageModifierChanged
    End Object
    PlayerDamageModifier=CardModifierStack'PlayerDamageModifierStack'

    Begin Object Name=PlayerRangedDamageModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerRangedDamageModifierChanged
    End Object
    PlayerRangedDamageModifier=CardModifierStack'PlayerRangedDamageModifierStack'

    Begin Object Name=PlayerMeleeDamageModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerMeleeDamageModifierChanged
    End Object
    PlayerMeleeDamageModifier=CardModifierStack'PlayerMeleeDamageModifierStack'

    Begin Object Name=PlayerShotgunDamageModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerShotgunDamageModifierChanged
    End Object
    PlayerShotgunDamageModifier=CardModifierStack'PlayerShotgunDamageModifierStack'

    Begin Object Name=PlayerFireDamageModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerFireDamageModifierChanged
    End Object
    PlayerFireDamageModifier=CardModifierStack'PlayerFireDamageModifierStack'

    Begin Object Name=PlayerExplosiveDamageModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerExplosiveDamageModifierChanged
    End Object
    PlayerExplosiveDamageModifier=CardModifierStack'PlayerExplosiveDamageModifierStack'

    Begin Object Name=PlayerOnPerkDamageModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerOnPerkDamageModifierChanged
    End Object
    PlayerOnPerkDamageModifier=CardModifierStack'PlayerFireDamageModifierStack'

    Begin Object Name=PlayerOffPerkDamageModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerOffPerkDamageModifierChanged
    End Object
    PlayerOffPerkDamageModifier=CardModifierStack'PlayerOffPerkDamageModifierStack'

    Begin Object Name=PlayerMedicGrenadeDamageModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerMedicGrenadeDamageModifierChanged
    End Object
    PlayerMedicGrenadeDamageModifier=CardModifierStack'PlayerMedicGrenadeDamageModifierStack'

    Begin Object Name=PlayerBerserkerMeleeDamageModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerBerserkerMeleeDamageModifierChanged
    End Object
    PlayerBerserkerMeleeDamageModifier=CardModifierStack'PlayerBerserkerMeleeDamageModifierStack'

    Begin Object Name=PlayerNonEliteDamageModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerNonEliteDamageModifierChanged
    End Object
    PlayerNonEliteDamageModifier=CardModifierStack'PlayerNonEliteDamageModifierStack'

    Begin Object Name=PlayerNonEliteHeadshotDamageModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerNonEliteHeadshotDamageModifierChanged
    End Object
    PlayerNonEliteHeadshotDamageModifier=CardModifierStack'PlayerNonEliteHeadshotDamageModifierStack'

    Begin Object Name=PlayerSlomoDamageModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerSlomoDamageModifierChanged
    End Object
    PlayerSlomoDamageModifier=CardModifierStack'PlayerSlomoDamageModifierStack'

    Begin Object Name=PlayerLowHealthDamageModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerLowHealthDamageModifierChanged
    End Object
    PlayerLowHealthDamageModifier=CardModifierStack'PlayerLowHealthDamageModifierStack'

    Begin Object Name=PlayerFleshpoundDamageModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerFleshpoundDamageModifierChanged
    End Object
    PlayerFleshpoundDamageModifier=CardModifierStack'PlayerFleshpoundDamageModifierStack'

    Begin Object Name=PlayerScrakeDamageModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerScrakeDamageModifierChanged
    End Object
    PlayerScrakeDamageModifier=CardModifierStack'PlayerScrakeDamageModifierStack'

    Begin Object Name=PlayerMassDetonationCardFlag Class=CardFlag
        OnFlagSetChanged=PlayerMassDetonationCardFlagChanged
    End Object
    PlayerMassDetonationFlag=CardFlag'PlayerMassDetonationCardFlag'

//DAMAGE RECEIVED
    Begin Object Name=PlayerArmorStrengthModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerArmorStrengthModifierChanged
    End Object
    PlayerArmorStrengthModifier=CardModifierStack'PlayerArmorStrengthModifierStack'

    Begin Object Name=PlayerFallDamageModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerFallDamageModifierChanged
    End Object
    PlayerFallDamageModifier=CardModifierStack'PlayerFallDamageModifierStack'

//FIRE RATE
    Begin Object Name=PlayerFireRateModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerFireRateModifierChanged
    End Object
    PlayerFireRateModifier=CardModifierStack'PlayerFireRateModifierStack'

    Begin Object Name=PlayerBerserkerFireRateModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerBerserkerFireRateModifierChanged
    End Object
    PlayerBerserkerFireRateModifier=CardModifierStack'PlayerBerserkerFireRateModifierStack'

    Begin Object Name=PlayerFirebugFireRateModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerFirebugFireRateModifierChanged
    End Object
    PlayerFirebugFireRateModifier=CardModifierStack'PlayerFirebugFireRateModifierStack'

    Begin Object Name=PlayerZedTimeDualWeaponFireRateModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerZedTimeDualWeaponFireRateModifierChanged
    End Object
    PlayerZedTimeDualWeaponFireRateModifier=CardModifierStack'PlayerZedTimeDualWeaponFireRateModifierStack'

//MAGAZINE AMMO
    Begin Object Name=PlayerMagazineAmmoModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerMagazineAmmoModifierChanged
    End Object
    PlayerMagazineAmmoModifier=CardModifierStack'PlayerMagazineAmmoModifierStack'
    
    Begin Object Name=PlayerCommandoMagazineAmmoModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerCommandoMagazineAmmoModifierChanged
    End Object
    PlayerCommandoMagazineAmmoModifier=CardModifierStack'PlayerCommandoMagazineAmmoModifierStack'
    
    Begin Object Name=PlayerMedicMagazineAmmoModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerMedicMagazineAmmoModifierChanged
    End Object
    PlayerMedicMagazineAmmoModifier=CardModifierStack'PlayerMedicMagazineAmmoModifierStack'
    
    Begin Object Name=PlayerDualWeaponMagazineAmmoModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerDualWeaponMagazineAmmoModifierChanged
    End Object
    PlayerDualWeaponMagazineAmmoModifier=CardModifierStack'PlayerDualWeaponMagazineAmmoModifierStack'

//RELOAD RATE
    Begin Object Name=PlayerReloadRateModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerReloadRateModifierChanged
    End Object
    PlayerReloadRateModifier=CardModifierStack'PlayerReloadRateModifierStack'
    
    Begin Object Name=PlayerCommandoReloadRateModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerCommandoReloadRateModifierChanged
    End Object
    PlayerCommandoReloadRateModifier=CardModifierStack'PlayerCommandoReloadRateModifierStack'
    
    Begin Object Name=PlayerZedTimeDualWeaponReloadRateModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerZedTimeDualWeaponReloadRateModifierChanged
    End Object
    PlayerZedTimeDualWeaponReloadRateModifier=CardModifierStack'PlayerZedTimeDualWeaponReloadRateModifierStack'

//EQUIP RATE
    Begin Object Name=PlayerEquipRateModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerEquipRateModifierChanged
    End Object
    PlayerEquipRateModifier=CardModifierStack'PlayerEquipRateModifierStack'
    
    Begin Object Name=PlayerZedTimeDualWeaponEquipRateModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerZedTimeDualWeaponEquipRateModifierChanged
    End Object
    PlayerZedTimeDualWeaponEquipRateModifier=CardModifierStack'PlayerZedTimeDualWeaponEquipRateModifierStack'

//MAX AMMO
    Begin Object Name=PlayerMaxAmmoModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerMaxAmmoModifierChanged
    End Object
    PlayerMaxAmmoModifier=CardModifierStack'PlayerMaxAmmoModifierStack'
    
    Begin Object Name=PlayerCommandoMaxAmmoModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerCommandoMaxAmmoModifierChanged
    End Object
    PlayerCommandoMaxAmmoModifier=CardModifierStack'PlayerCommandoMaxAmmoModifierStack'
    
    Begin Object Name=PlayerMedicMaxAmmoModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerMedicMaxAmmoModifierChanged
    End Object
    PlayerMedicMaxAmmoModifier=CardModifierStack'PlayerMedicMaxAmmoModifierStack'
    
    Begin Object Name=PlayerGrenadeMaxAmmoModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerGrenadeMaxAmmoModifierChanged
    End Object
    PlayerGrenadeMaxAmmoModifier=CardModifierStack'PlayerGrenadeMaxAmmoModifierStack'

//SPREAD AND RECOIL
    Begin Object Name=PlayerSpreadRecoilModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerSpreadRecoilModifierChanged
    End Object
    PlayerSpreadRecoilModifier=CardModifierStack'PlayerSpreadRecoilModifierStack'
    
    Begin Object Name=PlayerShotgunSpreadRecoilModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerShotgunSpreadRecoilModifierChanged
    End Object
    PlayerShotgunSpreadRecoilModifier=CardModifierStack'PlayerShotgunSpreadRecoilModifierStack'

//PENETRATION
    Begin Object Name=PlayerPenetrationModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerPenetrationModifierChanged
    End Object
    PlayerPenetrationModifier=CardModifierStack'PlayerPenetrationModifierStack'

//SHOTGUN
    Begin Object Name=PlayerShotgunPelletModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerShotgunPelletModifierChanged
    End Object
    PlayerShotgunPelletModifier=CardModifierStack'PlayerShotgunPelletModifierStack'
    
    Begin Object Name=PlayerShotgunKickbackModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerShotgunKickbackModifierChanged
    End Object
    PlayerShotgunKickbackModifier=CardModifierStack'PlayerShotgunKickbackModifierStack'

//ZED TIME EXTENSIONS
    Begin Object Name=PlayerZedTimeExtensionDeltaStack Class=CardDeltaStack
        OnDeltaChanged=PlayerZedTimeExtensionDeltaChanged
    End Object
    PlayerZedTimeExtensionDelta=CardDeltaStack'PlayerZedTimeExtensionDeltaStack'
    
    Begin Object Name=PlayerDualWeaponZedTimeExtensionDeltaStack Class=CardDeltaStack
        OnDeltaChanged=PlayerDualWeaponZedTimeExtensionDeltaChanged
    End Object
    PlayerDualWeaponZedTimeExtensionDelta=CardDeltaStack'PlayerDualWeaponZedTimeExtensionDeltaStack'

//DAMAGE TAKEN
    Begin Object Name=PlayerExplosiveDamageTakenModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerExplosiveDamageTakenModifierChanged
    End Object
    PlayerExplosiveDamageTakenModifier=CardModifierStack'PlayerExplosiveDamageTakenModifierStack'

//HEALING
    Begin Object Name=PlayerNonMedicHealPotencyModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerNonMedicHealPotencyModifierChanged
    End Object
    PlayerNonMedicHealPotencyModifier=CardModifierStack'PlayerNonMedicHealPotencyModifierStack'
    
    Begin Object Name=PlayerMedicHealPotencyModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerMedicHealPotencyModifierChanged
    End Object
    PlayerMedicHealPotencyModifier=CardModifierStack'PlayerMedicHealPotencyModifierStack'
    
    Begin Object Name=PlayerHealRechargeModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerHealRechargeModifierChanged
    End Object
    PlayerHealRechargeModifier=CardModifierStack'PlayerHealRechargeModifierStack'

//MOVEMENT
    Begin Object Name=PlayerMovementSpeedModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerMovementSpeedModifierChanged
    End Object
    PlayerMovementSpeedModifier=CardModifierStack'PlayerMovementSpeedModifierStack'

    Begin Object Name=PlayerMovementAccelModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerMovementAccelModifierChanged
    End Object
    PlayerMovementAccelModifier=CardModifierStack'PlayerMovementAccelModifierStack'

    Begin Object Name=PlayerMovementFrictionModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerMovementFrictionModifierChanged
    End Object
    PlayerMovementFrictionModifier=CardModifierStack'PlayerMovementFrictionModifierStack'

    Begin Object Name=PlayerFreezeTagCardFlag Class=CardFlag
        OnFlagSetChanged=PlayerFreezeTagFlagChanged
    End Object
    PlayerFreezeTagFlag=CardFlag'PlayerFreezeTagCardFlag'

    Begin Object Name=PlayerGreedSlowsCardFlag Class=CardFlag
        OnFlagSetChanged=PlayerGreedSlowsFlagChanged
    End Object
    PlayerGreedSlowsFlag=CardFlag'PlayerGreedSlowsCardFlag'

    Begin Object Name=PlayerLowHealthSlowsCardFlag Class=CardFlag
        OnFlagSetChanged=PlayerLowHealthSlowsFlagChanged
    End Object
    PlayerLowHealthSlowsFlag=CardFlag'PlayerLowHealthSlowsCardFlag'

//THORNS
    Begin Object Name=PlayerThornsModifierStack Class=CardModifierStack
        OnModifierChanged=PlayerThornsModifierChanged
    End Object
    PlayerThornsModifier=CardModifierStack'PlayerThornsModifierStack'

////////////////////
//MONSTER MODIFIERS

//DAMAGE
    Begin Object Name=MonsterDamageModifierStack Class=CardModifierStack
        OnModifierChanged=MonsterDamageModifierChanged
    End Object
    MonsterDamageModifier=CardModifierStack'MonsterDamageModifierStack'
    
    Begin Object Name=MonsterDamageMomentumModifierStack Class=CardModifierStack
        OnModifierChanged=MonsterDamageMomentumModifierChanged
    End Object
    MonsterDamageMomentumModifier=CardModifierStack'MonsterDamageMomentumModifierStack'
    
    Begin Object Name=MonsterMeleeDamageModifierStack Class=CardModifierStack
        OnModifierChanged=MonsterMeleeDamageModifierChanged
    End Object
    MonsterMeleeDamageModifier=CardModifierStack'MonsterMeleeDamageModifierStack'
    
    Begin Object Name=MonsterRangedDamageModifierStack Class=CardModifierStack
        OnModifierChanged=MonsterRangedDamageModifierChanged
    End Object
    MonsterRangedDamageModifier=CardModifierStack'MonsterRangedDamageModifierStack'
    
    Begin Object Name=MonsterStalkerMeleeDamageModifierStack Class=CardModifierStack
        OnModifierChanged=MonsterStalkerMeleeDamageModifierChanged
    End Object
    MonsterStalkerMeleeDamageModifier=CardModifierStack'MonsterStalkerMeleeDamageModifierStack'
    
    Begin Object Name=MonsterSirenScreamDamageModifierStack Class=CardModifierStack
        OnModifierChanged=MonsterSirenScreamDamageModifierChanged
    End Object
    MonsterSirenScreamDamageModifier=CardModifierStack'MonsterSirenScreamDamageModifierStack'
    
    Begin Object Name=MonsterSirenScreamRangeModifierStack Class=CardModifierStack
        OnModifierChanged=MonsterSirenScreamRangeModifierChanged
    End Object
    MonsterSirenScreamRangeModifier=CardModifierStack'MonsterSirenScreamRangeModifierStack'

//SCALING
    Begin Object Name=MonsterHeadSizeModifierStack Class=CardModifierStack
        OnModifierChanged=MonsterHeadSizeModifierChanged
    End Object
    MonsterHeadSizeModifier=CardModifierStack'MonsterHeadSizeModifierStack'
    
    Begin Object Name=MonsterStalkerDistractionModifierStack Class=CardModifierStack
        OnModifierChanged=MonsterStalkerDistractionModifierChanged
    End Object
    MonsterStalkerDistractionModifier=CardModifierStack'MonsterStalkerDistractionModifierStack'

//MOVEMENT
    Begin Object Name=MonsterBloatMovementSpeedModifierStack Class=CardModifierStack
        OnModifierChanged=MonsterBloatMovementSpeedModifierChanged
    End Object
    MonsterBloatMovementSpeedModifier=CardModifierStack'MonsterBloatMovementSpeedModifierStack'

//AI
    Begin Object Name=MonsterFleshpoundRageThresholdModifierStack Class=CardModifierStack
        OnModifierChanged=MonsterFleshpoundRageThresholdModifierChanged
    End Object
    MonsterFleshpoundRageThresholdModifier=CardModifierStack'MonsterFleshpoundRageThresholdModifierStack'
    
    Begin Object Name=MonsterScrakeRageThresholdModifierStack Class=CardModifierStack
        OnModifierChanged=MonsterScrakeRageThresholdModifierChanged
    End Object
    MonsterScrakeRageThresholdModifier=CardModifierStack'MonsterScrakeRageThresholdModifierStack'
    
    Begin Object Name=MonsterHuskRefireTimeModifierStack Class=CardModifierStack
        OnModifierChanged=MonsterHuskRefireTimeModifierChanged
    End Object
    MonsterHuskRefireTimeModifier=CardModifierStack'MonsterHuskRefireTimeModifierStack'
}