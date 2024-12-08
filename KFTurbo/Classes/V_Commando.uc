class V_Commando extends TurboVeterancyTypes
	abstract;


static function AddCustomStats(ClientPerkRepLink Other)
{
	Super.AddCustomStats(Other);

	Other.AddCustomValue(class'VP_BullpupDamage');
	Other.AddCustomValue(class'VP_StalkerKills');
}

static function int GetStalkerKillStatAsDamage(ClientPerkRepLink StatOther)
{
	return StatOther.RBullpupDamageStat + StatOther.GetCustomValueInt(class'VP_BullpupDamage')
		+ (float(StatOther.GetCustomValueInt(class'VP_StalkerKills')) * (class'P_Stalker'.default.HealthMax * 1.5f));
}

static function int GetPerkProgressInt(ClientPerkRepLink StatOther, out int FinalInt, byte CurLevel, byte ReqNum)
{
	switch (CurLevel)
	{
	case 0:
		FinalInt = 10000;
		break;
	case 1:
		FinalInt = 25000;
		break;
	case 2:
		FinalInt = 100000;
		break;
	case 3:
		FinalInt = 500000;
		break;
	case 4:
		FinalInt = 1500000;
		break;
	case 5:
		FinalInt = 3500000;
		break;
	case 6:
		FinalInt = 5500000;
		break;
	default:
		FinalInt = 5500000 + GetScaledRequirement(CurLevel - 5, 250000);
	}

	return Min(GetStalkerKillStatAsDamage(StatOther), FinalInt);
}

static function SpecialHUDInfo(KFPlayerReplicationInfo KFPRI, Canvas C)
{
	local KFMonster KFEnemy;
	local HUDKillingFloor HKF;
	local Pawn P;

	HKF = HUDKillingFloor(C.ViewPort.Actor.myHUD);
	P = Pawn(C.ViewPort.Actor.ViewTarget);
	if (HKF == none || P == none || P.Health <= 0)
		return;

	foreach P.CollidingActors(class'KFMonster', KFEnemy, LerpStat(KFPRI, 0.f, 800.f))
	{
		if (KFEnemy.Health > 0 && (!KFEnemy.Cloaked() || KFEnemy.bZapped || KFEnemy.bSpotted))
		{
			HKF.DrawHealthBar(C, KFEnemy, KFEnemy.Health, KFEnemy.HealthMax, 50.0);
		}
	}
}

static function bool ShowStalkers(KFPlayerReplicationInfo KFPRI)
{
	return true;
}

static function float GetStalkerViewDistanceMulti(KFPlayerReplicationInfo KFPRI)
{
	return LerpStat(KFPRI, 0.25f, 2.f);
}

static function ApplyAdjustedMagCapacityModifier(KFPlayerReplicationInfo KFPRI, KFWeapon Other, out float Multiplier)
{
	if (Multiplier > 1.f && Other.default.MagCapacity > 1 && TurboGameReplicationInfo(KFPRI.Level.GRI) != None)
	{
		Multiplier *= TurboGameReplicationInfo(KFPRI.Level.GRI).GetCommandoMagazineAmmoMultiplier(KFPRI, Other);
	}

	if (!IsHighDifficulty(KFPRI))
	{
		Super.ApplyAdjustedMagCapacityModifier(KFPRI, Other, Multiplier);
		return;
	}

	if(SCARMK17AssaultRifle(Other) != None)
	{
		Multiplier *= 1.2f;
	}
	else if(Other.default.MagCapacity > 1 && Multiplier > 1.f)
	{
		Multiplier *= 1.25f;
	}

	Super.ApplyAdjustedMagCapacityModifier(KFPRI, Other, Multiplier);
}

static function float GetMagCapacityMod(KFPlayerReplicationInfo KFPRI, KFWeapon Other)
{
	local float Multiplier;
	Multiplier = 1.f;

	if (Bullpup(Other) != none 
		|| AK47AssaultRifle(Other) != none 
		|| SCARMK17AssaultRifle(Other) != none 
		|| FNFAL_ACOG_AssaultRifle(Other) != none 
		|| MKb42AssaultRifle(Other) != none)
	{
		Multiplier *= LerpStat(KFPRI, 1.f, 1.25f);
	}

	if (ThompsonDrumSMG(Other) != None || SPThompsonSMG(Other) != none)
	{
		Multiplier *= LerpStat(KFPRI, 1.f, 1.6f);
	}

	if (ThompsonSMG(Other) != None)
	{
		Multiplier *= LerpStat(KFPRI, 1.f, 1.2f);
	}

	if (M4AssaultRifle(Other) != None)
	{
		Multiplier *= LerpStat(KFPRI, 1.f, 1.34f);
	}

	if (W_FNFAL_Weap(Other) != None)
	{
		Multiplier *= LerpStat(KFPRI, 1.f, 1.67f);
	}

	ApplyAdjustedMagCapacityModifier(KFPRI, Other, Multiplier);

	return Multiplier;
}

static function float GetAmmoPickupMod(KFPlayerReplicationInfo KFPRI, KFAmmunition Other)
{
	local float Multiplier;

	Multiplier = 1.f;

	if ((BullpupAmmo(Other) != none || AK47Ammo(Other) != none ||
		SCARMK17Ammo(Other) != none || M4Ammo(Other) != none
		|| FNFALAmmo(Other) != none || MKb42Ammo(Other) != none
		|| ThompsonAmmo(Other) != none || GoldenAK47Ammo(Other) != none
		|| ThompsonDrumAmmo(Other) != none || SPThompsonAmmo(Other) != none
		|| CamoM4Ammo(Other) != none || NeonAK47Ammo(Other) != none) &&
		KFPRI.ClientVeteranSkillLevel > 0)
	{
		Multiplier *= LerpStat(KFPRI, 1.f, 1.25f);
	}
	else if (FNFALAmmo(Other) != None)
	{
		Multiplier *= LerpStat(KFPRI, 1.f, 1.2f);
	}

	return Multiplier;
}

static function float AddExtraAmmoFor(KFPlayerReplicationInfo KFPRI, class<Ammunition> AmmoType)
{
	local float Multiplier;
	Multiplier = 1.f;

	switch (AmmoType)
	{
	case class'SCARMK17Ammo' :
	case class'MKb42Ammo' :
	case class'W_ThompsonSMG_Ammo' :
	case class'W_Bullpup_Ammo' :
	case class'W_AK47_Ammo' :
	case class'W_ThompsonDrum_Ammo' :
	case class'W_M4203_Ammo_Bullet' :
	case class'W_FNFAL_Ammo' :
		Multiplier *= LerpStat(KFPRI, 1.f, 1.25f);
		break;
	}

	ApplyAdjustedExtraAmmo(KFPRI, AmmoType, Multiplier);

	return Multiplier;
}

static function ApplyAdjustedExtraAmmo(KFPlayerReplicationInfo KFPRI, class<Ammunition> AmmoType, out float Multiplier)
{
	if (!IsHighDifficulty(KFPRI))
	{
		if (Multiplier > 1.f)
		{
			if (TurboGameReplicationInfo(KFPRI.Level.GRI) != None)
			{
				Multiplier *= TurboGameReplicationInfo(KFPRI.Level.GRI).GetCommandoMaxAmmoMultiplier(KFPRI, AmmoType);
			}
		}

		Super.ApplyAdjustedExtraAmmo(KFPRI, AmmoType, Multiplier);
		return;
	}

	switch (AmmoType)
	{
		case class'FragAmmo':
			Multiplier *= 1.1f;
			break;
	}

	Super.ApplyAdjustedExtraAmmo(KFPRI, AmmoType, Multiplier);
}

static function int AddDamage(KFPlayerReplicationInfo KFPRI, KFMonster Injured, KFPawn Instigator, int InDamage, class<DamageType> DmgType)
{
	switch (DmgType)
	{
	case class'DamTypeBullpup' :
	case class'DamTypeAK47AssaultRifle' :
	case class'DamTypeSCARMK17AssaultRifle' :
	case class'DamTypeAK47AssaultRifle' :
	case class'DamTypeM4AssaultRifle' :
	case class'DamTypeMKb42AssaultRifle' :

	case class'W_M4203_DT_Bullet' :
	case class'W_FNFAL_DT' :
	case class'W_ThompsonDrum_DT' :
		return float(InDamage) * LerpStat(KFPRI, 1.05f, 1.5f);
	case class'W_ThompsonSMG_DT' : //left this here for future balancing
		return float(InDamage) * LerpStat(KFPRI, 1.05f, 1.5f);
	}

	return InDamage;
}

static function float ModifyRecoilSpread(KFPlayerReplicationInfo KFPRI, WeaponFire Other, out float Recoil)
{
	Recoil = Super.ModifyRecoilSpread(KFPRI, Other, Recoil);

	if (Bullpup(Other.Weapon) != none || AK47AssaultRifle(Other.Weapon) != none ||
		SCARMK17AssaultRifle(Other.Weapon) != none || M4AssaultRifle(Other.Weapon) != none
		|| FNFAL_ACOG_AssaultRifle(Other.Weapon) != none || MKb42AssaultRifle(Other.Weapon) != none
		|| ThompsonSMG(Other.Weapon) != none || ThompsonDrumSMG(Other.Weapon) != none
		|| SPThompsonSMG(Other.Weapon) != none || MAC10MP(Other.Weapon) != none)
	{
		Recoil *= LerpStat(KFPRI, 0.95f, 0.6f);
	}

	return Recoil;
	//wtf is this syntax (by ref and return???)
}

static function ApplyAdjustedReloadRate(KFPlayerReplicationInfo KFPRI, Weapon Other, out float Multiplier)
{
	if (class'V_Commando'.static.IsPerkWeapon(class<KFWeapon>(Other.Class)))
	{
		if (TurboGameReplicationInfo(KFPRI.Level.GRI) != None)
		{
			Multiplier *= TurboGameReplicationInfo(KFPRI.Level.GRI).GetCommandoReloadRateMultiplier(KFPRI, Other);
		}
	}

	Super.ApplyAdjustedReloadRate(KFPRI, Other, Multiplier);
}

static function float GetReloadSpeedModifier(KFPlayerReplicationInfo KFPRI, KFWeapon Other)
{
	local float Multiplier;
	Multiplier = LerpStat(KFPRI, 1.05f, 1.35f);
	ApplyAdjustedReloadRate(KFPRI, Other, Multiplier);
	return Multiplier;
}

static function int ZedTimeExtensions(KFPlayerReplicationInfo KFPRI)
{
	return Super.ZedTimeExtensions(KFPRI) + LerpStat(KFPRI, 0, 4);
}

static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item)
{
	local float Multiplier;
	Multiplier = 1.f;

	switch (Item)
	{
	case class'W_MKb42_Pickup':
	case class'W_Bullpup_Pickup':
	case class'W_AK47_Pickup' :
	case class'W_M4203_Pickup' :
	case class'W_ThompsonDrum_Pickup':
	case class'W_FNFAL_Pickup' :
	case class'W_SCARMK17_Pickup' :
	case class'W_ThompsonSMG_Pickup' :
		Multiplier *= LerpStat(KFPRI, 0.9f, 0.3f);
		break;
	default:
		break;
	}

	ApplyCostScalingModifier(KFPRI, Item, Multiplier);
	return Multiplier;
}

static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P)
{
	KFHumanPawn(P).CreateInventoryVeterancy(string(class'W_Bullpup_Weap'), default.StartingWeaponSellPriceLevel6);
}

static function string GetCustomLevelInfo(byte Level)
{
	return default.SRLevelEffects[6];
}

defaultproperties
{
	StartingWeaponSellPriceLevel5=255.000000
	StartingWeaponSellPriceLevel6=255.000000

	OnHUDIcon=Texture'KillingFloorHUD.Perks.Perk_Commando'
	OnHUDGoldIcon=Texture'KFTurbo.Perks.Commando_D'
	OnHUDIconMaxTier=Shader'KFTurbo.Perks.Commando_SHDR'
	
	VeterancyName="Commando"
    PerkIndex=3
	CustomLevelInfo=""
	Requirements(0)="Deal %x damage with Assault Rifles."
	SRLevelEffects(6)="50% more damage with assault/battle rifles|40% less recoil with assault/battle rifles and SMGs|25% - 60% larger magazines for assault/battle rifles|25% more maximum ammo for assault/battle rifles|35% faster reload with all weapons|70% discount on assault/battle rifles|Spawn with an AK47|Can see cloaked Stalkers from 32m|Can see enemy health from 16m|Up to 4 zed-time extensions"
}
