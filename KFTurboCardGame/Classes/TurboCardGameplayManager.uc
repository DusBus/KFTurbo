//Killing Floor Turbo TurboCardGameplayManager
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboCardGameplayManager extends TurboCardGameplayManagerBase;

////////////////////
//GAME MODIFIERS

//WAVE
var CardModifierStack GameWaveSpeedModifier; //Distinct from the modifier that cards apply. Used to increase difficulty throughout card game.
var CardModifierStack WaveSpeedModifier;
var CardModifierStack MaxMonstersModifier;
var CardModifierStack TotalMonstersModifier;

var CardModifierStack CashBonusModifier;

var CardFlag BorrowedTimeFlag;
var PlayerBorrowedTimeActor BorrowedTimeManager;
var CardFlag PlainSightSpawnFlag;
var PlainSightSpawningActor PlainSightManager;
var CardFlag RandomTraderChangeFlag;
var RandomTraderManager RandomTraderManager;

//CARD GAME
var CardDeltaStack CardSelectionCountDelta;
var CardFlag CurseOfRaFlag;
var CurseOfRaManager CurseOfRaManager;

//FRIENDLY FIRE
var CardModifierStack FriendlyFireModifier;

//DAMAGE
var CardFlag BleedDamageFlag;
var PlayerBleedActor BleedManager;
var CardFlag NoRestForTheWickedFlag;
var PlayerNoRestForTheWickedActor NoRestForTheWickedManager;

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
    TurboGameType.GameWaveSpawnRateModifier = GameWaveSpeedModifier.GetModifier() * WaveSpeedModifier.GetModifier();
}

function MaxMonstersModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    local float OriginalModifier;
    OriginalModifier = TurboGameType.GameMaxMonstersModifier;
    TurboGameType.GameMaxMonstersModifier = MaxMonstersModifier.GetModifier();

    //If the change occurs while the wave is in progress, we need to apply this to it.
    if (!TurboGameType.bWaveInProgress)
    {
        return;
    }
    
    TurboGameType.MaxMonsters *= TurboGameType.GameMaxMonstersModifier / OriginalModifier;
}

function TotalMonstersModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    local float OriginalModifier;
    OriginalModifier = TurboGameType.GameTotalMonstersModifier;
    TurboGameType.GameTotalMonstersModifier = TotalMonstersModifier.GetModifier();

    if (!TurboGameType.bWaveInProgress)
    {
        return;
    }
    
    TurboGameType.TotalMaxMonsters *= TurboGameType.GameTotalMonstersModifier / OriginalModifier;
}

function CashBonusModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameRules.BonusCashMultiplier = CashBonusModifier.GetModifier();
}

function BorrowedTimeCardFlagChanged(CardFlag Flag, bool bIsEnabled)
{
    if (bIsEnabled)
    {
        if (BorrowedTimeManager == None)
        {
            BorrowedTimeManager = Spawn(class'PlayerBorrowedTimeActor', Self);
        }
    }
    else
    {
        if (BorrowedTimeManager != None)
        {
            BorrowedTimeManager.Destroy();
        }
    }
}

function PlainSightSpawnCardFlagChanged(CardFlag Flag, bool bIsEnabled)
{
    if (bIsEnabled)
    {
        if (PlainSightManager == None)
        {
            PlainSightManager = Spawn(class'PlainSightSpawningActor', Self);
        }
    }
    else
    {
        if (PlainSightManager != None)
        {
            PlainSightManager.Destroy();
        }
    }
}

function RandomTraderChangeFlagChanged(CardFlag Flag, bool bIsEnabled)
{
    if (bIsEnabled)
    {
        if (RandomTraderManager == None)
        {
            RandomTraderManager = Spawn(class'RandomTraderManager', Self);
        }
    }
    else
    {
        if (RandomTraderManager != None)
        {
            RandomTraderManager.Destroy();
        }
    }
}

//CARD GAME
function CardSelectionCountDeltaChanged(CardDeltaStack ChangedDelta, int Delta)
{
    CardReplicationInfo.SelectionCount = CardReplicationInfo.default.SelectionCount + Delta;
}

function CurseOfRaFlagChanged(CardFlag Flag, bool bIsEnabled)
{
    if (bIsEnabled)
    {
        if (CurseOfRaManager == None)
        {
            CurseOfRaManager = Spawn(class'CurseOfRaManager', Self);
        }
    }
    else
    {
        if (CurseOfRaManager != None)
        {
            CurseOfRaManager.Destroy();
        }
    }
}

//FRIENDLY FIRE
function FriendlyFireModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    if (Modifier <= 1.f)
    {
        TeamGame(Level.Game).FriendlyFireScale = 0.0001f;
        return;
    }

    TeamGame(Level.Game).FriendlyFireScale = (Modifier - 1.f);
}

//DAMAGE
function BleedDamageFlagChanged(CardFlag Flag, bool bIsEnabled)
{
    if (bIsEnabled)
    {
        if (BleedManager == None)
        {
            BleedManager = Spawn(class'PlayerBleedActor', Self);
        }
    }
    else
    {
        if (BleedManager != None)
        {
            BleedManager.Destroy();
        }
    }
}

function NoRestForTheWickedFlagChanged(CardFlag Flag, bool bIsEnabled)
{
    if (bIsEnabled)
    {
        if (NoRestForTheWickedManager == None)
        {
            NoRestForTheWickedManager = Spawn(class'PlayerNoRestForTheWickedActor', Self);
        }
    }
    else
    {
        if (NoRestForTheWickedManager != None)
        {
            NoRestForTheWickedManager.Destroy();
        }
    }
}

function SuddenDeathFlagChanged(CardFlag Flag, bool bIsEnabled)
{
    CardGameRules.bSuddenDeathEnabled = bIsEnabled;
}

function CheatDeathFlagChanged(CardFlag Flag, bool bIsEnabled)
{
    CardGameRules.bCheatDeathEnabled = bIsEnabled;

    if (!bIsEnabled)
    {
        CardGameRules.CheatedDeathPlayerList.Length = 0;
    }
}

//INVENTORY
function NoSyringeFlagChanged(CardFlag Flag, bool bIsEnabled)
{
    local array<TurboHumanPawn> HumanPawnList;
    local int Index;

    CardGameRules.bDisableSyringe = bIsEnabled;

    HumanPawnList = class'TurboGameplayHelper'.static.GetPlayerPawnList(Level);
    
    if (bIsEnabled)
    {
        for (Index = HumanPawnList.Length - 1; Index >= 0; Index--)
        {
            CardGameRules.DestorySyringe(HumanPawnList[Index]);
        }
    }
    else
    {
        for (Index = HumanPawnList.Length - 1; Index >= 0; Index--)
        {
            HumanPawnList[Index].CreateInventory(string(class'W_Syringe_Weap'));
        }
    }
}

function SuperGrenadesFlagChanged(CardFlag Flag, bool bIsEnabled)
{
    CardGameRules.bSuperGrenades = bIsEnabled;
}

////////////////////
//PLAYER MODIFIERS

//HEALTH
function PlayerMaxHealthModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameModifier.PlayerMaxHealthMultiplier = Modifier;
    TurboGameReplicationInfo(Level.GRI).NotifyPlayerMaxHealthChanged();
    CardGameModifier.ForceNetUpdate();
}

//CARRY CAPACITY
function PlayerCarryCapacityDeltaChanged(CardDeltaStack ChangedDelta, int Delta)
{
    CardGameModifier.PlayerMaxCarryWeightModifier = Delta;
    TurboGameReplicationInfo(Level.GRI).NotifyPlayerCarryWeightChanged();
}

//TRADER
function TraderPriceModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameModifier.TraderCostMultiplier = Modifier;
    CardGameModifier.ForceNetUpdate();
}

function TraderGrenadePriceModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameModifier.TraderGrenadeCostMultiplier = Modifier;
    CardGameModifier.ForceNetUpdate();
}

//DAMAGE
function PlayerDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameRules.PlayerDamageMultiplier = Modifier;
}

function PlayerRangedDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameRules.PlayerRangedDamageMultiplier = Modifier;
}

function PlayerMeleeDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameRules.MeleeDamageMultiplier = Modifier;
}

function PlayerShotgunDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameRules.ShotgunDamageMultiplier = Modifier;
}

function PlayerFireDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameRules.FireDamageMultiplier = Modifier;
}

function PlayerExplosiveDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameRules.ExplosiveDamageMultiplier = Modifier;
}

function PlayerOnPerkDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameRules.OnPerkDamageMultiplier = Modifier;
}

function PlayerOffPerkDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameRules.OffPerkDamageMultiplier = Modifier;
}

function PlayerMedicGrenadeDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameRules.MedicGrenadeDamageMultiplier = Modifier;
}

function PlayerBerserkerMeleeDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameRules.BerserkerMeleeDamageMultiplier = Modifier;
}

function PlayerNonEliteDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameRules.TrashDamageMultiplier = Modifier;
}

function PlayerNonEliteHeadshotDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameRules.TrashHeadshotDamageMultiplier = Modifier;
}

function PlayerSlomoDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameRules.SlomoDamageMultiplier = Modifier;
}

function PlayerLowHealthDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameRules.LowHealthDamageMultiplier = Modifier;
}

function PlayerFleshpoundDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameRules.FleshpoundDamageMultiplier = Modifier;
}

function PlayerScrakeDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameRules.ScrakeDamageMultiplier = Modifier;
}

function PlayerMassDetonationCardFlagChanged(CardFlag Flag, bool bIsEnabled)
{
    CardGameRules.bMassDetonationEnabled = bIsEnabled;
}

//DAMAGE RECEIVED
function PlayerArmorStrengthModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameModifier.BodyArmorDamageModifier = Modifier;
    CardGameModifier.ForceNetUpdate();
}

function PlayerFallDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameRules.FallDamageTakenMultiplier = Modifier;
}

//FIRERATE
function PlayerFireRateModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameModifier.FireRateMultiplier = Modifier;
    CardGameModifier.ForceNetUpdate();
}

function PlayerBerserkerFireRateModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameModifier.BerserkerFireRateMultiplier = Modifier;
    CardGameModifier.ForceNetUpdate();
}

function PlayerFirebugFireRateModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameModifier.FirebugFireRateMultiplier = Modifier;
    CardGameModifier.ForceNetUpdate();
}

function PlayerZedTimeDualWeaponFireRateModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameModifier.ZedTimeDualPistolFireRateMultiplier = Modifier;
    CardGameModifier.ForceNetUpdate();
}

//MAGAZINE AMMO
function PlayerMagazineAmmoModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameModifier.MagazineAmmoMultiplier = Modifier;
    CardGameModifier.ForceNetUpdate();
}

function PlayerCommandoMagazineAmmoModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameModifier.CommandoMagazineAmmoMultiplier = Modifier;
    CardGameModifier.ForceNetUpdate();
}

function PlayerMedicMagazineAmmoModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameModifier.MedicMagazineAmmoMultiplier = Modifier;
    CardGameModifier.ForceNetUpdate();
}

function PlayerDualWeaponMagazineAmmoModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameModifier.DualWeaponMagazineAmmoMultiplier = Modifier;
    CardGameModifier.ForceNetUpdate();
}

//RELOAD RATE
function PlayerReloadRateModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameModifier.ReloadRateMultiplier = Modifier;
    CardGameModifier.ForceNetUpdate();
}

function PlayerCommandoReloadRateModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameModifier.CommandoReloadRateMultiplier = Modifier;
    CardGameModifier.ForceNetUpdate();
}

function PlayerZedTimeDualWeaponReloadRateModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameModifier.ZedTimeDualWeaponReloadRateMultiplier = Modifier;
    CardGameModifier.ForceNetUpdate();
}

//EQUIP RATE
function PlayerEquipRateModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardClientModifier.WeaponBringUpSpeedModifier = Modifier;
    CardClientModifier.WeaponPutDownSpeedModifier = Modifier;
    CardClientModifier.ForceNetUpdate();
}

function PlayerZedTimeDualWeaponEquipRateModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardClientModifier.ZedTimeWeaponBringUpSpeedModifier = Modifier;
    CardClientModifier.ZedTimeWeaponPutDownSpeedModifier = Modifier;
    CardClientModifier.ForceNetUpdate();
}

//MAX AMMO
function PlayerMaxAmmoModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameModifier.MaxAmmoMultiplier = Modifier;
    CardGameModifier.ForceNetUpdate();
}

function PlayerCommandoMaxAmmoModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameModifier.CommandoMaxAmmoMultiplier = Modifier;
    CardGameModifier.ForceNetUpdate();
}

function PlayerMedicMaxAmmoModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameModifier.MedicMaxAmmoMultiplier = Modifier;
    CardGameModifier.ForceNetUpdate();
}

function PlayerGrenadeMaxAmmoModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameModifier.GrenadeMaxAmmoMultiplier = Modifier;
    CardGameModifier.ForceNetUpdate();
}

//SPREAD AND RECOIL
function PlayerSpreadRecoilModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameModifier.WeaponSpreadRecoilMultiplier = Modifier;
    CardGameModifier.ForceNetUpdate();
}

function PlayerShotgunSpreadRecoilModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameModifier.ShotgunSpreadRecoilMultiplier = Modifier;
    CardGameModifier.ForceNetUpdate();
}

//PENETRATION
function PlayerPenetrationModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameModifier.WeaponPenetrationMultiplier = Modifier;
    CardGameModifier.ForceNetUpdate();
}

//SHOTGUN
function PlayerShotgunPelletModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameModifier.ShotgunPelletCountMultiplier = Modifier;
    CardGameModifier.ForceNetUpdate();
}

function PlayerShotgunKickbackModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameModifier.ShotgunKickBackMultiplier = Modifier;
    CardGameModifier.ForceNetUpdate();
}

//ZED TIME EXTENSIONS
function PlayerZedTimeExtensionDeltaChanged(CardDeltaStack DeltaStack, int Delta)
{
    CardGameModifier.PlayerZedTimeExtensionsModifier = CardGameModifier.default.PlayerZedTimeExtensionsModifier + Delta;
    CardGameModifier.ForceNetUpdate();
}

function PlayerDualWeaponZedTimeExtensionDeltaChanged(CardDeltaStack DeltaStack, int Delta)
{
    CardGameModifier.PlayerDualPistolZedTimeExtensionsModifier = CardGameModifier.default.PlayerDualPistolZedTimeExtensionsModifier + Delta;
    CardGameModifier.ForceNetUpdate();
}

//DAMAGE TAKEN
function PlayerExplosiveDamageTakenModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameRules.ExplosiveDamageMultiplier = Modifier;
}

//HEALING
function PlayerNonMedicHealPotencyModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameModifier.NonMedicHealPotencyMultiplier = Modifier;
    CardGameModifier.ForceNetUpdate();
}

function PlayerMedicHealPotencyModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameModifier.MedicHealPotencyMultiplier = Modifier;
    CardGameModifier.ForceNetUpdate();
}

function PlayerHealRechargeModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameModifier.HealRechargeMultiplier = Modifier;
    CardGameModifier.ForceNetUpdate();
}

//MOVEMENT
function PlayerMovementSpeedModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameModifier.PlayerMovementSpeedMultiplier = Modifier;
    TurboGameReplicationInfo(Level.GRI).NotifyPlayerMovementSpeedChanged();
    CardGameModifier.ForceNetUpdate();
}

function PlayerMovementAccelModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameModifier.PlayerMovementAccelMultiplier = Modifier;
    TurboGameReplicationInfo(Level.GRI).NotifyPlayerMovementSpeedChanged();
    CardGameModifier.ForceNetUpdate();
}

function PlayerMovementFrictionModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardClientModifier.GroundFrictionModifier = Modifier;
    CardClientModifier.UpdatePhysicsVolumes();
    CardClientModifier.ForceNetUpdate();
}

function PlayerFreezeTagFlagChanged(Cardflag ModifiedStack, bool bIsEnabled)
{
    CardGameModifier.bFreezePlayersDuringWave = bIsEnabled;
    CardGameModifier.ForceNetUpdate();
}

function PlayerGreedSlowsFlagChanged(Cardflag ModifiedStack, bool bIsEnabled)
{
    CardGameModifier.bMoneySlowsPlayers = bIsEnabled;
    CardGameModifier.ForceNetUpdate();
}

function PlayerLowHealthSlowsFlagChanged(Cardflag ModifiedStack, bool bIsEnabled)
{
    CardGameModifier.bMissingHealthStronglySlows = bIsEnabled;
    CardGameModifier.ForceNetUpdate();
}

//THORNS
function PlayerThornsModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameRules.PlayerThornsDamageMultiplier = Modifier;
}

////////////////////
//MONSTER MODIFIERS

//DAMAGE
function MonsterDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameRules.MonsterDamageMultiplier = Modifier;
}

function MonsterDamageMomentumModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameRules.MonsterMeleeDamageMomentumMultiplier = Modifier;
}

function MonsterMeleeDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameRules.MonsterMeleeDamageMultiplier = Modifier;
}

function MonsterRangedDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameRules.MonsterRangedDamageMultiplier = Modifier;
}

function MonsterStalkerMeleeDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameRules.MonsterStalkerDamageMultiplier = Modifier;
}

function MonsterSirenScreamDamageModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameRules.SirenScreamDamageMultiplier = Modifier;
}

function MonsterSirenScreamRangeModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameRules.SirenScreamRangeModifier = Modifier;
}

//SCALING
function MonsterHeadSizeModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardClientModifier.MonsterHeadSizeModifier = Modifier;
    CardClientModifier.ForceNetUpdate();
}

function MonsterStalkerDistractionModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardClientModifier.StalkerDistractionModifier = Modifier;
    CardClientModifier.ForceNetUpdate();
}

//MOVEMENT
function MonsterBloatMovementSpeedModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameRules.BloatMovementSpeedModifier = Modifier;
}

//AI
function MonsterFleshpoundRageThresholdModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameRules.FleshpoundRageThresholdModifier = Modifier;
}

function MonsterScrakeRageThresholdModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameRules.ScrakeRageThresholdModifier = Modifier;
}

function MonsterHuskRefireTimeModifierChanged(CardModifierStack ModifiedStack, float Modifier)
{
    CardGameRules.HuskRefireTimeModifier = Modifier;
}

defaultproperties
{
    Begin Object Name=GameWaveSpeedModifierStack Class=CardModifierStack
        ModifierStackID="GameWaveSpeed"
        OnModifierChanged=WaveSpeedModifierChanged
    End Object
    GameWaveSpeedModifier=CardModifierStack'GameWaveSpeedModifierStack'

    Begin Object Name=WaveSpeedModifierStack Class=CardModifierStack
        ModifierStackID="WaveSpeed"
        OnModifierChanged=WaveSpeedModifierChanged
    End Object
    WaveSpeedModifier=CardModifierStack'WaveSpeedModifierStack'

    Begin Object Name=MaxMonstersModifierStack Class=CardModifierStack
        ModifierStackID="MaxMonsters"
        OnModifierChanged=MaxMonstersModifierChanged
    End Object
    MaxMonstersModifier=CardModifierStack'MaxMonstersModifierStack'

    Begin Object Name=TotalMonstersModifierStack Class=CardModifierStack
        ModifierStackID="TotalMonsters"
        OnModifierChanged=TotalMonstersModifierChanged
    End Object
    TotalMonstersModifier=CardModifierStack'TotalMonstersModifierStack'

    Begin Object Name=CashBonusModifierStack Class=CardModifierStack
        ModifierStackID="CashBonus"
        OnModifierChanged=CashBonusModifierChanged
    End Object
    CashBonusModifier=CardModifierStack'CashBonusModifierStack'

    Begin Object Name=BorrowedTimeCardFlag Class=CardFlag
        FlagID="BorrowedTime"
        OnFlagSetChanged=BorrowedTimeCardFlagChanged
    End Object
    BorrowedTimeFlag=CardFlag'BorrowedTimeCardFlag'

    Begin Object Name=PlainSightSpawnCardFlag Class=CardFlag
        FlagID="PlainSightSpawn"
        OnFlagSetChanged=PlainSightSpawnCardFlagChanged
    End Object
    PlainSightSpawnFlag=CardFlag'PlainSightSpawnCardFlag'

    Begin Object Name=RandomTraderChangeCardFlag Class=CardFlag
        FlagID="RandomTraderChange"
        OnFlagSetChanged=RandomTraderChangeFlagChanged
    End Object
    RandomTraderChangeFlag=CardFlag'RandomTraderChangeCardFlag'

//CARD GAME
    Begin Object Name=CardSelectionCountDeltaStack Class=CardDeltaStack
        DeltaStackID="CardSelectionCount"
        OnDeltaChanged=CardSelectionCountDeltaChanged
    End Object
    CardSelectionCountDelta=CardDeltaStack'CardSelectionCountDeltaStack'
    
    Begin Object Name=CurseOfRaCardFlag Class=CardFlag
        FlagID="CurseOfRa"
        OnFlagSetChanged=CurseOfRaFlagChanged
    End Object
    CurseOfRaFlag=CardFlag'CurseOfRaCardFlag'

//FRIENDLY FIRE
    Begin Object Name=FriendlyFireModifierStack Class=CardModifierStack
        ModifierStackID="FriendlyFire"
        OnModifierChanged=FriendlyFireModifierChanged
    End Object
    FriendlyFireModifier=CardModifierStack'FriendlyFireModifierStack'
    
//DAMAGE
    Begin Object Name=BleedDamageCardFlag Class=CardFlag
        FlagID="BleedDamage"
        OnFlagSetChanged=BleedDamageFlagChanged
    End Object
    BleedDamageFlag=CardFlag'BleedDamageCardFlag'
    
    Begin Object Name=NoRestForTheWickedCardFlag Class=CardFlag
        FlagID="NoRestForTheWicked"
        OnFlagSetChanged=NoRestForTheWickedFlagChanged
    End Object
    NoRestForTheWickedFlag=CardFlag'NoRestForTheWickedCardFlag'

//DEATH
    Begin Object Name=SuddenDeathCardFlag Class=CardFlag
        FlagID="SuddenDeath"
        OnFlagSetChanged=SuddenDeathFlagChanged
    End Object
    SuddenDeathFlag=CardFlag'SuddenDeathCardFlag'

    Begin Object Name=CheatDeathCardFlag Class=CardFlag
        FlagID="CheatDeath"
        OnFlagSetChanged=CheatDeathFlagChanged
    End Object
    CheatDeathFlag=CardFlag'CheatDeathCardFlag'
    
//INVENTORY
    Begin Object Name=NoSyringeCardFlag Class=CardFlag
        FlagID="NoSyringe"
        OnFlagSetChanged=NoSyringeFlagChanged
    End Object
    NoSyringeFlag=CardFlag'NoSyringeCardFlag'

    Begin Object Name=SuperGrenadesCardFlag Class=CardFlag
        FlagID="SuperGrenades"
        OnFlagSetChanged=SuperGrenadesFlagChanged
    End Object
    SuperGrenadesFlag=CardFlag'SuperGrenadesCardFlag'
    

////////////////////
//PLAYER MODIFIERS

//HEALTH
    Begin Object Name=PlayerMaxHealthModifierStack Class=CardModifierStack
        ModifierStackID="PlayerMaxHealth"
        OnModifierChanged=PlayerMaxHealthModifierChanged
    End Object
    PlayerMaxHealthModifier=CardModifierStack'PlayerMaxHealthModifierStack'

//CARRY CAPACITY
    Begin Object Name=PlayerCarryCapacityDeltaStack Class=CardDeltaStack
        DeltaStackID="PlayerCarryCapacity"
        OnDeltaChanged=PlayerCarryCapacityDeltaChanged
    End Object
    PlayerCarryCapacityDelta=CardDeltaStack'PlayerCarryCapacityDeltaStack'

//TRADER
    Begin Object Name=TraderPriceModifierStack Class=CardModifierStack
        ModifierStackID="TraderPrice"
        OnModifierChanged=TraderPriceModifierChanged
    End Object
    TraderPriceModifier=CardModifierStack'TraderPriceModifierStack'

    Begin Object Name=TraderGrenadePriceStack Class=CardModifierStack
        ModifierStackID="TraderGrenade"
        OnModifierChanged=TraderGrenadePriceModifierChanged
    End Object
    TraderGrenadePriceModifier=CardModifierStack'TraderGrenadePriceStack'

//DAMAGE
    Begin Object Name=PlayerDamageModifierStack Class=CardModifierStack
        ModifierStackID="PlayerDamage"
        OnModifierChanged=PlayerDamageModifierChanged
    End Object
    PlayerDamageModifier=CardModifierStack'PlayerDamageModifierStack'

    Begin Object Name=PlayerRangedDamageModifierStack Class=CardModifierStack
        ModifierStackID="PlayerRangedDamage"
        OnModifierChanged=PlayerRangedDamageModifierChanged
    End Object
    PlayerRangedDamageModifier=CardModifierStack'PlayerRangedDamageModifierStack'

    Begin Object Name=PlayerMeleeDamageModifierStack Class=CardModifierStack
        ModifierStackID="PlayerMeleeDamage"
        OnModifierChanged=PlayerMeleeDamageModifierChanged
    End Object
    PlayerMeleeDamageModifier=CardModifierStack'PlayerMeleeDamageModifierStack'

    Begin Object Name=PlayerShotgunDamageModifierStack Class=CardModifierStack
        ModifierStackID="PlayerShotgunDamage"
        OnModifierChanged=PlayerShotgunDamageModifierChanged
    End Object
    PlayerShotgunDamageModifier=CardModifierStack'PlayerShotgunDamageModifierStack'

    Begin Object Name=PlayerFireDamageModifierStack Class=CardModifierStack
        ModifierStackID="PlayerFireDamage"
        OnModifierChanged=PlayerFireDamageModifierChanged
    End Object
    PlayerFireDamageModifier=CardModifierStack'PlayerFireDamageModifierStack'

    Begin Object Name=PlayerExplosiveDamageModifierStack Class=CardModifierStack
        ModifierStackID="PlayerExplosiveDamage"
        OnModifierChanged=PlayerExplosiveDamageModifierChanged
    End Object
    PlayerExplosiveDamageModifier=CardModifierStack'PlayerExplosiveDamageModifierStack'

    Begin Object Name=PlayerOnPerkDamageModifierStack Class=CardModifierStack
        ModifierStackID="PlayerOnPerkDamage"
        OnModifierChanged=PlayerOnPerkDamageModifierChanged
    End Object
    PlayerOnPerkDamageModifier=CardModifierStack'PlayerFireDamageModifierStack'

    Begin Object Name=PlayerOffPerkDamageModifierStack Class=CardModifierStack
        ModifierStackID="PlayerOffPerkDamage"
        OnModifierChanged=PlayerOffPerkDamageModifierChanged
    End Object
    PlayerOffPerkDamageModifier=CardModifierStack'PlayerOffPerkDamageModifierStack'

    Begin Object Name=PlayerMedicGrenadeDamageModifierStack Class=CardModifierStack
        ModifierStackID="PlayerMedicGrenadeDamage"
        OnModifierChanged=PlayerMedicGrenadeDamageModifierChanged
    End Object
    PlayerMedicGrenadeDamageModifier=CardModifierStack'PlayerMedicGrenadeDamageModifierStack'

    Begin Object Name=PlayerBerserkerMeleeDamageModifierStack Class=CardModifierStack
        ModifierStackID="PlayerBerserkerMeleeDamage"
        OnModifierChanged=PlayerBerserkerMeleeDamageModifierChanged
    End Object
    PlayerBerserkerMeleeDamageModifier=CardModifierStack'PlayerBerserkerMeleeDamageModifierStack'

    Begin Object Name=PlayerNonEliteDamageModifierStack Class=CardModifierStack
        ModifierStackID="PlayerNonEliteDamage"
        OnModifierChanged=PlayerNonEliteDamageModifierChanged
    End Object
    PlayerNonEliteDamageModifier=CardModifierStack'PlayerNonEliteDamageModifierStack'

    Begin Object Name=PlayerNonEliteHeadshotDamageModifierStack Class=CardModifierStack
        ModifierStackID="PlayerNonEliteHeadshotDamage"
        OnModifierChanged=PlayerNonEliteHeadshotDamageModifierChanged
    End Object
    PlayerNonEliteHeadshotDamageModifier=CardModifierStack'PlayerNonEliteHeadshotDamageModifierStack'

    Begin Object Name=PlayerSlomoDamageModifierStack Class=CardModifierStack
        ModifierStackID="PlayerSlomoDamage"
        OnModifierChanged=PlayerSlomoDamageModifierChanged
    End Object
    PlayerSlomoDamageModifier=CardModifierStack'PlayerSlomoDamageModifierStack'

    Begin Object Name=PlayerLowHealthDamageModifierStack Class=CardModifierStack
        ModifierStackID="PlayerLowHealthDamage"
        OnModifierChanged=PlayerLowHealthDamageModifierChanged
    End Object
    PlayerLowHealthDamageModifier=CardModifierStack'PlayerLowHealthDamageModifierStack'

    Begin Object Name=PlayerFleshpoundDamageModifierStack Class=CardModifierStack
        ModifierStackID="PlayerFleshpoundDamage"
        OnModifierChanged=PlayerFleshpoundDamageModifierChanged
    End Object
    PlayerFleshpoundDamageModifier=CardModifierStack'PlayerFleshpoundDamageModifierStack'

    Begin Object Name=PlayerScrakeDamageModifierStack Class=CardModifierStack
        ModifierStackID="PlayerScrakeDamage"
        OnModifierChanged=PlayerScrakeDamageModifierChanged
    End Object
    PlayerScrakeDamageModifier=CardModifierStack'PlayerScrakeDamageModifierStack'

    Begin Object Name=PlayerMassDetonationCardFlag Class=CardFlag
        FlagID="PlayerMassDetonation"
        OnFlagSetChanged=PlayerMassDetonationCardFlagChanged
    End Object
    PlayerMassDetonationFlag=CardFlag'PlayerMassDetonationCardFlag'

//DAMAGE RECEIVED
    Begin Object Name=PlayerArmorStrengthModifierStack Class=CardModifierStack
        ModifierStackID="PlayerArmorStrength"
        OnModifierChanged=PlayerArmorStrengthModifierChanged
    End Object
    PlayerArmorStrengthModifier=CardModifierStack'PlayerArmorStrengthModifierStack'

    Begin Object Name=PlayerFallDamageModifierStack Class=CardModifierStack
        ModifierStackID="PlayerFallDamage"
        OnModifierChanged=PlayerFallDamageModifierChanged
    End Object
    PlayerFallDamageModifier=CardModifierStack'PlayerFallDamageModifierStack'

//FIRE RATE
    Begin Object Name=PlayerFireRateModifierStack Class=CardModifierStack
        ModifierStackID="PlayerFireRate"
        OnModifierChanged=PlayerFireRateModifierChanged
    End Object
    PlayerFireRateModifier=CardModifierStack'PlayerFireRateModifierStack'

    Begin Object Name=PlayerBerserkerFireRateModifierStack Class=CardModifierStack
        ModifierStackID="PlayerBerserkerFireRate"
        OnModifierChanged=PlayerBerserkerFireRateModifierChanged
    End Object
    PlayerBerserkerFireRateModifier=CardModifierStack'PlayerBerserkerFireRateModifierStack'

    Begin Object Name=PlayerFirebugFireRateModifierStack Class=CardModifierStack
        ModifierStackID="PlayerFirebugFireRate"
        OnModifierChanged=PlayerFirebugFireRateModifierChanged
    End Object
    PlayerFirebugFireRateModifier=CardModifierStack'PlayerFirebugFireRateModifierStack'

    Begin Object Name=PlayerZedTimeDualWeaponFireRateModifierStack Class=CardModifierStack
        ModifierStackID="PlayerZedTimeDualWeaponFireRate"
        OnModifierChanged=PlayerZedTimeDualWeaponFireRateModifierChanged
    End Object
    PlayerZedTimeDualWeaponFireRateModifier=CardModifierStack'PlayerZedTimeDualWeaponFireRateModifierStack'

//MAGAZINE AMMO
    Begin Object Name=PlayerMagazineAmmoModifierStack Class=CardModifierStack
        ModifierStackID="PlayerMagazineAmmo"
        OnModifierChanged=PlayerMagazineAmmoModifierChanged
    End Object
    PlayerMagazineAmmoModifier=CardModifierStack'PlayerMagazineAmmoModifierStack'
    
    Begin Object Name=PlayerCommandoMagazineAmmoModifierStack Class=CardModifierStack
        ModifierStackID="PlayerCommandoMagazineAmmo"
        OnModifierChanged=PlayerCommandoMagazineAmmoModifierChanged
    End Object
    PlayerCommandoMagazineAmmoModifier=CardModifierStack'PlayerCommandoMagazineAmmoModifierStack'
    
    Begin Object Name=PlayerMedicMagazineAmmoModifierStack Class=CardModifierStack
        ModifierStackID="PlayerMedicMagazineAmmo"
        OnModifierChanged=PlayerMedicMagazineAmmoModifierChanged
    End Object
    PlayerMedicMagazineAmmoModifier=CardModifierStack'PlayerMedicMagazineAmmoModifierStack'
    
    Begin Object Name=PlayerDualWeaponMagazineAmmoModifierStack Class=CardModifierStack
        ModifierStackID="PlayerDualWeaponMagazineAmmo"
        OnModifierChanged=PlayerDualWeaponMagazineAmmoModifierChanged
    End Object
    PlayerDualWeaponMagazineAmmoModifier=CardModifierStack'PlayerDualWeaponMagazineAmmoModifierStack'

//RELOAD RATE
    Begin Object Name=PlayerReloadRateModifierStack Class=CardModifierStack
        ModifierStackID="PlayerReloadRate"
        OnModifierChanged=PlayerReloadRateModifierChanged
    End Object
    PlayerReloadRateModifier=CardModifierStack'PlayerReloadRateModifierStack'
    
    Begin Object Name=PlayerCommandoReloadRateModifierStack Class=CardModifierStack
        ModifierStackID="PlayerCommandoReloadRate"
        OnModifierChanged=PlayerCommandoReloadRateModifierChanged
    End Object
    PlayerCommandoReloadRateModifier=CardModifierStack'PlayerCommandoReloadRateModifierStack'
    
    Begin Object Name=PlayerZedTimeDualWeaponReloadRateModifierStack Class=CardModifierStack
        ModifierStackID="PlayerZedTimeDualWeaponReloadRate"
        OnModifierChanged=PlayerZedTimeDualWeaponReloadRateModifierChanged
    End Object
    PlayerZedTimeDualWeaponReloadRateModifier=CardModifierStack'PlayerZedTimeDualWeaponReloadRateModifierStack'

//EQUIP RATE
    Begin Object Name=PlayerEquipRateModifierStack Class=CardModifierStack
        ModifierStackID="PlayerEquipRate"
        OnModifierChanged=PlayerEquipRateModifierChanged
    End Object
    PlayerEquipRateModifier=CardModifierStack'PlayerEquipRateModifierStack'
    
    Begin Object Name=PlayerZedTimeDualWeaponEquipRateModifierStack Class=CardModifierStack
        ModifierStackID="PlayerZedTimeDualWeaponEquipRate"
        OnModifierChanged=PlayerZedTimeDualWeaponEquipRateModifierChanged
    End Object
    PlayerZedTimeDualWeaponEquipRateModifier=CardModifierStack'PlayerZedTimeDualWeaponEquipRateModifierStack'

//MAX AMMO
    Begin Object Name=PlayerMaxAmmoModifierStack Class=CardModifierStack
        ModifierStackID="PlayerMaxAmmo"
        OnModifierChanged=PlayerMaxAmmoModifierChanged
    End Object
    PlayerMaxAmmoModifier=CardModifierStack'PlayerMaxAmmoModifierStack'
    
    Begin Object Name=PlayerCommandoMaxAmmoModifierStack Class=CardModifierStack
        ModifierStackID="PlayerCommandoMaxAmmo"
        OnModifierChanged=PlayerCommandoMaxAmmoModifierChanged
    End Object
    PlayerCommandoMaxAmmoModifier=CardModifierStack'PlayerCommandoMaxAmmoModifierStack'
    
    Begin Object Name=PlayerMedicMaxAmmoModifierStack Class=CardModifierStack
        ModifierStackID="PlayerMedicMaxAmmo"
        OnModifierChanged=PlayerMedicMaxAmmoModifierChanged
    End Object
    PlayerMedicMaxAmmoModifier=CardModifierStack'PlayerMedicMaxAmmoModifierStack'
    
    Begin Object Name=PlayerGrenadeMaxAmmoModifierStack Class=CardModifierStack
        ModifierStackID="PlayerGrenadeMaxAmmo"
        OnModifierChanged=PlayerGrenadeMaxAmmoModifierChanged
    End Object
    PlayerGrenadeMaxAmmoModifier=CardModifierStack'PlayerGrenadeMaxAmmoModifierStack'

//SPREAD AND RECOIL
    Begin Object Name=PlayerSpreadRecoilModifierStack Class=CardModifierStack
        ModifierStackID="PlayerSpreadRecoil"
        OnModifierChanged=PlayerSpreadRecoilModifierChanged
    End Object
    PlayerSpreadRecoilModifier=CardModifierStack'PlayerSpreadRecoilModifierStack'
    
    Begin Object Name=PlayerShotgunSpreadRecoilModifierStack Class=CardModifierStack
        ModifierStackID="PlayerShotgunSpreadRecoil"
        OnModifierChanged=PlayerShotgunSpreadRecoilModifierChanged
    End Object
    PlayerShotgunSpreadRecoilModifier=CardModifierStack'PlayerShotgunSpreadRecoilModifierStack'

//PENETRATION
    Begin Object Name=PlayerPenetrationModifierStack Class=CardModifierStack
        ModifierStackID="PlayerPenetration"
        OnModifierChanged=PlayerPenetrationModifierChanged
    End Object
    PlayerPenetrationModifier=CardModifierStack'PlayerPenetrationModifierStack'

//SHOTGUN
    Begin Object Name=PlayerShotgunPelletModifierStack Class=CardModifierStack
        ModifierStackID="PlayerShotgunPellet"
        OnModifierChanged=PlayerShotgunPelletModifierChanged
    End Object
    PlayerShotgunPelletModifier=CardModifierStack'PlayerShotgunPelletModifierStack'
    
    Begin Object Name=PlayerShotgunKickbackModifierStack Class=CardModifierStack
        ModifierStackID="PlayerShotgunKickback"
        OnModifierChanged=PlayerShotgunKickbackModifierChanged
    End Object
    PlayerShotgunKickbackModifier=CardModifierStack'PlayerShotgunKickbackModifierStack'

//ZED TIME EXTENSIONS
    Begin Object Name=PlayerZedTimeExtensionDeltaStack Class=CardDeltaStack
        DeltaStackID="PlayerZedTimeExtension"
        OnDeltaChanged=PlayerZedTimeExtensionDeltaChanged
    End Object
    PlayerZedTimeExtensionDelta=CardDeltaStack'PlayerZedTimeExtensionDeltaStack'
    
    Begin Object Name=PlayerDualWeaponZedTimeExtensionDeltaStack Class=CardDeltaStack
        DeltaStackID="PlayerDualWeaponZedTime"
        OnDeltaChanged=PlayerDualWeaponZedTimeExtensionDeltaChanged
    End Object
    PlayerDualWeaponZedTimeExtensionDelta=CardDeltaStack'PlayerDualWeaponZedTimeExtensionDeltaStack'

//DAMAGE TAKEN
    Begin Object Name=PlayerExplosiveDamageTakenModifierStack Class=CardModifierStack
        ModifierStackID="PlayerExplosiveDamageTaken"
        OnModifierChanged=PlayerExplosiveDamageTakenModifierChanged
    End Object
    PlayerExplosiveDamageTakenModifier=CardModifierStack'PlayerExplosiveDamageTakenModifierStack'

//HEALING
    Begin Object Name=PlayerNonMedicHealPotencyModifierStack Class=CardModifierStack
        ModifierStackID="PlayerNonMedicHealPotency"
        OnModifierChanged=PlayerNonMedicHealPotencyModifierChanged
    End Object
    PlayerNonMedicHealPotencyModifier=CardModifierStack'PlayerNonMedicHealPotencyModifierStack'
    
    Begin Object Name=PlayerMedicHealPotencyModifierStack Class=CardModifierStack
        ModifierStackID="PlayerMedicHealPotency"
        OnModifierChanged=PlayerMedicHealPotencyModifierChanged
    End Object
    PlayerMedicHealPotencyModifier=CardModifierStack'PlayerMedicHealPotencyModifierStack'
    
    Begin Object Name=PlayerHealRechargeModifierStack Class=CardModifierStack
        ModifierStackID="PlayerHealRecharge"
        OnModifierChanged=PlayerHealRechargeModifierChanged
    End Object
    PlayerHealRechargeModifier=CardModifierStack'PlayerHealRechargeModifierStack'

//MOVEMENT
    Begin Object Name=PlayerMovementSpeedModifierStack Class=CardModifierStack
        ModifierStackID="PlayerMovementSpeed"
        OnModifierChanged=PlayerMovementSpeedModifierChanged
    End Object
    PlayerMovementSpeedModifier=CardModifierStack'PlayerMovementSpeedModifierStack'

    Begin Object Name=PlayerMovementAccelModifierStack Class=CardModifierStack
        ModifierStackID="PlayerMovementAccel"
        OnModifierChanged=PlayerMovementAccelModifierChanged
    End Object
    PlayerMovementAccelModifier=CardModifierStack'PlayerMovementAccelModifierStack'

    Begin Object Name=PlayerMovementFrictionModifierStack Class=CardModifierStack
        ModifierStackID="PlayerMovementFriction"
        OnModifierChanged=PlayerMovementFrictionModifierChanged
    End Object
    PlayerMovementFrictionModifier=CardModifierStack'PlayerMovementFrictionModifierStack'

    Begin Object Name=PlayerFreezeTagCardFlag Class=CardFlag
        FlagID="PlayerFreezeTag"
        OnFlagSetChanged=PlayerFreezeTagFlagChanged
    End Object
    PlayerFreezeTagFlag=CardFlag'PlayerFreezeTagCardFlag'

    Begin Object Name=PlayerGreedSlowsCardFlag Class=CardFlag
        FlagID="PlayerGreedSlows"
        OnFlagSetChanged=PlayerGreedSlowsFlagChanged
    End Object
    PlayerGreedSlowsFlag=CardFlag'PlayerGreedSlowsCardFlag'

    Begin Object Name=PlayerLowHealthSlowsCardFlag Class=CardFlag
        FlagID="PlayerLowHealthSlows"
        OnFlagSetChanged=PlayerLowHealthSlowsFlagChanged
    End Object
    PlayerLowHealthSlowsFlag=CardFlag'PlayerLowHealthSlowsCardFlag'

//THORNS
    Begin Object Name=PlayerThornsModifierStack Class=CardModifierStack
        ModifierStackID="PlayerThorns"
        OnModifierChanged=PlayerThornsModifierChanged
    End Object
    PlayerThornsModifier=CardModifierStack'PlayerThornsModifierStack'

////////////////////
//MONSTER MODIFIERS

//DAMAGE
    Begin Object Name=MonsterDamageModifierStack Class=CardModifierStack
        ModifierStackID="MonsterDamage"
        OnModifierChanged=MonsterDamageModifierChanged
    End Object
    MonsterDamageModifier=CardModifierStack'MonsterDamageModifierStack'
    
    Begin Object Name=MonsterDamageMomentumModifierStack Class=CardModifierStack
        ModifierStackID="MonsterDamageMomentum"
        OnModifierChanged=MonsterDamageMomentumModifierChanged
    End Object
    MonsterDamageMomentumModifier=CardModifierStack'MonsterDamageMomentumModifierStack'
    
    Begin Object Name=MonsterMeleeDamageModifierStack Class=CardModifierStack
        ModifierStackID="MonsterMeleeDamage"
        OnModifierChanged=MonsterMeleeDamageModifierChanged
    End Object
    MonsterMeleeDamageModifier=CardModifierStack'MonsterMeleeDamageModifierStack'
    
    Begin Object Name=MonsterRangedDamageModifierStack Class=CardModifierStack
        ModifierStackID="MonsterRangedDamage"
        OnModifierChanged=MonsterRangedDamageModifierChanged
    End Object
    MonsterRangedDamageModifier=CardModifierStack'MonsterRangedDamageModifierStack'
    
    Begin Object Name=MonsterStalkerMeleeDamageModifierStack Class=CardModifierStack
        ModifierStackID="MonsterStalkerMeleeDamage"
        OnModifierChanged=MonsterStalkerMeleeDamageModifierChanged
    End Object
    MonsterStalkerMeleeDamageModifier=CardModifierStack'MonsterStalkerMeleeDamageModifierStack'
    
    Begin Object Name=MonsterSirenScreamDamageModifierStack Class=CardModifierStack
        ModifierStackID="MonsterSirenScreamDamage"
        OnModifierChanged=MonsterSirenScreamDamageModifierChanged
    End Object
    MonsterSirenScreamDamageModifier=CardModifierStack'MonsterSirenScreamDamageModifierStack'
    
    Begin Object Name=MonsterSirenScreamRangeModifierStack Class=CardModifierStack
        ModifierStackID="MonsterSirenScreamRange"
        OnModifierChanged=MonsterSirenScreamRangeModifierChanged
    End Object
    MonsterSirenScreamRangeModifier=CardModifierStack'MonsterSirenScreamRangeModifierStack'

//SCALING
    Begin Object Name=MonsterHeadSizeModifierStack Class=CardModifierStack
        ModifierStackID="MonsterHeadSize"
        OnModifierChanged=MonsterHeadSizeModifierChanged
    End Object
    MonsterHeadSizeModifier=CardModifierStack'MonsterHeadSizeModifierStack'
    
    Begin Object Name=MonsterStalkerDistractionModifierStack Class=CardModifierStack
        ModifierStackID="MonsterStalkerDistraction"
        OnModifierChanged=MonsterStalkerDistractionModifierChanged
    End Object
    MonsterStalkerDistractionModifier=CardModifierStack'MonsterStalkerDistractionModifierStack'

//MOVEMENT
    Begin Object Name=MonsterBloatMovementSpeedModifierStack Class=CardModifierStack
        ModifierStackID="MonsterBloatMovementSpeed"
        OnModifierChanged=MonsterBloatMovementSpeedModifierChanged
    End Object
    MonsterBloatMovementSpeedModifier=CardModifierStack'MonsterBloatMovementSpeedModifierStack'

//AI
    Begin Object Name=MonsterFleshpoundRageThresholdModifierStack Class=CardModifierStack
        ModifierStackID="MonsterFleshpoundRageThreshold"
        OnModifierChanged=MonsterFleshpoundRageThresholdModifierChanged
    End Object
    MonsterFleshpoundRageThresholdModifier=CardModifierStack'MonsterFleshpoundRageThresholdModifierStack'
    
    Begin Object Name=MonsterScrakeRageThresholdModifierStack Class=CardModifierStack
        ModifierStackID="MonsterScrakeRageThreshold"
        OnModifierChanged=MonsterScrakeRageThresholdModifierChanged
    End Object
    MonsterScrakeRageThresholdModifier=CardModifierStack'MonsterScrakeRageThresholdModifierStack'
    
    Begin Object Name=MonsterHuskRefireTimeModifierStack Class=CardModifierStack
        ModifierStackID="MonsterHuskRefireTime"
        OnModifierChanged=MonsterHuskRefireTimeModifierChanged
    End Object
    MonsterHuskRefireTimeModifier=CardModifierStack'MonsterHuskRefireTimeModifierStack'
}