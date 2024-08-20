class V_FieldMedic extends KFTurbo.SRVetFieldMedic
	abstract;

static function AddCustomStats(ClientPerkRepLink Other)
{
	Super.AddCustomStats(Other);

	Other.AddCustomValue(class'VP_DamageHealed');
}

static function int GetPerkProgressInt(ClientPerkRepLink StatOther, out int FinalInt, byte CurLevel, byte ReqNum)
{
	switch (CurLevel)
	{
	case 0:
		FinalInt = 100;
		break;
	case 1:
		FinalInt = 200;
		break;
	case 2:
		FinalInt = 750;
		break;
	case 3:
		FinalInt = 4000;
		break;
	case 4:
		FinalInt = 12000;
		break;
	case 5:
		FinalInt = 25000;
		break;
	case 6:
		FinalInt = 100000;
		break;
	default:
		FinalInt = 85000 + GetScaledRequirement(CurLevel - 4, 6000);
	}
	return Min(StatOther.RDamageHealedStat + StatOther.GetCustomValueInt(class'VP_DamageHealed'), FinalInt);
}

static function ApplyAdjustedExtraAmmo(KFPlayerReplicationInfo KFPRI, class<Ammunition> AmmoType, out float Multiplier)
{
	if (!IsHighDifficulty(KFPRI))
	{
		if (TurboGameReplicationInfo(KFPRI.Level.GRI) != None)
		{
			if (class<MP7MAmmo>(AmmoType) != none || class<MP5MAmmo>(AmmoType) != none || class<M7A3MAmmo>(AmmoType) != none
       			|| class<KrissMAmmo>(AmmoType) != none || class<BlowerThrowerAmmo>(AmmoType) != none)
			{
				Multiplier *= TurboGameReplicationInfo(KFPRI.Level.GRI).GetMedicMaxAmmoMultiplier();
			}

			Multiplier *= TurboGameReplicationInfo(KFPRI.Level.GRI).GetMaxAmmoMultiplier();
		}

		return;
	}

	if (Multiplier > 1.f)
	{
		Multiplier *= default.HighDifficultyExtraAmmoMultiplier;
	}

	if (TurboGameReplicationInfo(KFPRI.Level.GRI) != None)
	{
		if (class<MP7MAmmo>(AmmoType) != none || class<MP5MAmmo>(AmmoType) != none || class<M7A3MAmmo>(AmmoType) != none
			|| class<KrissMAmmo>(AmmoType) != none || class<BlowerThrowerAmmo>(AmmoType) != none)
		{
			Multiplier *= TurboGameReplicationInfo(KFPRI.Level.GRI).GetMedicMaxAmmoMultiplier();
		}
		
		Multiplier *= TurboGameReplicationInfo(KFPRI.Level.GRI).GetMaxAmmoMultiplier();
	}
}

static function float AddExtraAmmoFor(KFPlayerReplicationInfo KFPRI, Class<Ammunition> AmmoType)
{
	local float Multiplier;
	Multiplier = 1.f;

	switch(AmmoType)
	{
	case class'W_M7A3M_Ammo' :
		Multiplier *= LerpStat(KFPRI, 1.f, 1.2f);
		break;
	}

	ApplyAdjustedExtraAmmo(KFPRI, AmmoType, Multiplier);

	return Multiplier;
}

static function class<Grenade> GetNadeType(KFPlayerReplicationInfo KFPRI)
{
	return class'V_FieldMedic_Grenade';
}

static function float GetSyringeChargeRate(KFPlayerReplicationInfo KFPRI)
{
	return LerpStat(KFPRI, 1.1f, 3.f);
}

static function float GetHealPotency(KFPlayerReplicationInfo KFPRI)
{
	return LerpStat(KFPRI, 1.1f, 1.75f);
}

static function float GetMovementSpeedModifier(KFPlayerReplicationInfo KFPRI, KFGameReplicationInfo KFGRI)
{
	return Super.GetMovementSpeedModifier(KFPRI, KFGRI) * LerpStat(KFPRI, 1.f, 1.2f);
}

static function int ReduceDamage(KFPlayerReplicationInfo KFPRI, KFPawn Injured, Pawn Instigator, int InDamage, class<DamageType> DmgType)
{
	if (class<DamTypeVomit>(DmgType) != none)
	{
		if (Injured == Instigator)
		{
			return 0.f;
		}

		return float(InDamage) * LerpStat(KFPRI, 0.9f, 0.25f);
	}

	return InDamage;
}
static function ApplyAdjustedMagCapacityModifier(KFPlayerReplicationInfo KFPRI, KFWeapon Other, out float Multiplier)
{
	if (Multiplier > 1.f && TurboGameReplicationInfo(KFPRI.Level.GRI) != None)
	{
		Multiplier *= TurboGameReplicationInfo(KFPRI.Level.GRI).GetMedicMagazineAmmoMultiplier();
	}

	Super.ApplyAdjustedMagCapacityModifier(KFPRI, Other, Multiplier);
}

static function float GetMagCapacityMod(KFPlayerReplicationInfo KFPRI, KFWeapon Other)
{
	local float Multiplier;
	Multiplier = 1.f;

	if(W_M7A3M_Weap(Other) != None)
	{
		Multiplier *= LerpStat(KFPRI, 1.f, 1.5f);
	}
	else if (KFMedicGun(Other) != None)
	{
		Multiplier *= LerpStat(KFPRI, 1.f, 2.f);
	}

	ApplyAdjustedMagCapacityModifier(KFPRI, Other, Multiplier);
	return Multiplier;
}

static function float GetAmmoPickupMod(KFPlayerReplicationInfo KFPRI, KFAmmunition Other)
{
	if(W_M7A3M_Ammo(Other) != None)
	{
		return LerpStat(KFPRI, 1.f, 1.5f);
	}
	else if (MP7MAmmo(Other) != None || MP5MAmmo(Other) != None || KrissMAmmo(Other) != None)
	{
		return LerpStat(KFPRI, 1.f, 2.f);
	}
	else if (BlowerThrowerAmmo(Other) != None)
	{
		return LerpStat(KFPRI, 1.f, 2.f);
	}

	return 1.f;
}

static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item)
{
	local float Multiplier;
	Multiplier = 1.f;
	
	switch(Item)
	{
	case class'W_MP7M_Pickup' :
	case class'W_MP5M_Pickup' :
	case class'W_KrissM_Pickup' :
	case class'W_M7A3M_Pickup' :
	case class'BlowerThrowerPickup' :
		Multiplier *= LerpStat(KFPRI, 0.25f, 0.13f);// Up to 87% discount on Medic Gun
		break;
	case class'Vest':
		Multiplier *= LerpStat(KFPRI, 0.9f, 0.3f);// Up to 87% discount on Medic Gun
		break;
	}

	ApplyCostScalingModifier(KFPRI, Item, Multiplier);
	return Multiplier;
}

static function float GetBodyArmorDamageModifier(KFPlayerReplicationInfo KFPRI)
{
	return LerpStat(KFPRI, 1.f, 0.25f);
}

static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P)
{
	P.ShieldStrength = 100;
	KFHumanPawn(P).CreateInventoryVeterancy(string(class'W_MP7M_Weap'), default.StartingWeaponSellPriceLevel6);
}

static function string GetCustomLevelInfo(byte Level)
{
	return default.SRLevelEffects[6];
}

defaultproperties
{
     OnHUDGoldIcon=Texture'KFTurbo.Perks.Medic_D'
	 SRLevelEffects(6)="200% faster syringe recharge|75% more potent healing|75% less damage from Bloat bile|20% faster movement speed|100% larger medic gun clips|75% better body armor|70% discount on body armor|87% discount on medic guns|Grenades heal teammates and hurt enemies|Spawn with full armor and MP7M"
}
