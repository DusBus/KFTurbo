//Killing Floor Turbo TurboCardGameplayManager
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboCardGameplayManager extends Engine.Info;

////////////////////
//GAME MODIFIERS

//WAVE
var CardModifierStack WaveSpeedModifier;
var CardModifierStack CashBonusModifier;
var CardFlag BorrowedTimeFlag;
var CardFlag PlainSightSpawnFlag;
var CardFlag RandomTraderChangeFlag;

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
var CardModifierStack PlayerZedTimeExtensionModifier;
var CardModifierStack PlayerDualWeaponZedTimeExtensionModifier;

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

defaultproperties
{

}