class V_Sharpshooter extends SRVetSharpshooter
	abstract;

static function AddCustomStats(ClientPerkRepLink Other)
{
	Super.AddCustomStats(Other);

	Other.AddCustomValue(class'VP_HeadshotKills');
}

static function int GetPerkProgressInt(ClientPerkRepLink StatOther, out int FinalInt, byte CurLevel, byte ReqNum)
{
	switch (CurLevel)
	{
	case 0:
		FinalInt = 10;
		break;
	case 1:
		FinalInt = 30;
		break;
	case 2:
		FinalInt = 100;
		break;
	case 3:
		FinalInt = 700;
		break;
	case 4:
		FinalInt = 2500;
		break;
	case 5:
		FinalInt = 5500;
		break;
	case 6:
		FinalInt = 8500;
		break;
	default:
		FinalInt = 8000 + GetScaledRequirement(CurLevel - 4, 500);
	}
	return Min(StatOther.RHeadshotKillsStat + StatOther.GetCustomValueInt(class'VP_HeadshotKills'), FinalInt);
}

static function float AddExtraAmmoFor(KFPlayerReplicationInfo KFPRI, Class<Ammunition> AmmoType)
{
	local float Multiplier;

	Multiplier = Super.AddExtraAmmoFor(KFPRI, AmmoType);

	AddAdjustedExtraAmmoFor(KFPRI, AmmoType, Multiplier);

	return Multiplier;
}

static function AddAdjustedExtraAmmoFor(KFPlayerReplicationInfo KFPRI, class<Ammunition> AmmoType, out float Multiplier)
{
	if (!IsHighDifficulty(KFPRI))
	{
		return;
	}

	if (Multiplier > 1.f)
	{
		Multiplier *= 1.25f;
	}
}

static function float GetHeadShotDamMulti(KFPlayerReplicationInfo KFPRI, KFPawn P, class<DamageType> DmgType)
{
	local float Multiplier;

	Multiplier = 1.f;

	switch (DmgType)
	{
	case class'DamTypeCrossbow' :
	case class'DamTypeCrossbowHeadShot' :
	case class'DamTypeWinchester' :
	case class'DamTypeDeagle' :
	case class'DamTypeDualDeagle' :
	case class'DamTypeM14EBR' :
	case class'DamTypeMagnum44Pistol' :
	case class'DamTypeDual44Magnum' :
	case class'DamTypeMK23Pistol' :
	case class'DamTypeDualMK23Pistol' :
	case class'DamTypeM99SniperRifle' :
	case class'DamTypeM99HeadShot' :
	case class'DamTypeSPSniper' :
	case class'W_SPSniper_DT' :
		Multiplier = LerpStat(KFPRI, 1.05f, 1.6f);
		break;
	case class'W_Magnum44_DT' :
	case class'W_Dual44_DT' :
		return LerpStat(KFPRI, 1.05f, 1.45f);
		break;
	case class'DamTypeDualies' :
		return LerpStat(KFPRI, 1.05f, 1.4f);
	}

	return Multiplier * LerpStat(KFPRI, 1.1f, 1.5f);
}

static function float ModifyRecoilSpread(KFPlayerReplicationInfo KFPRI, WeaponFire Other, out float Recoil)
{
	if (Crossbow(Other.Weapon) != none || Winchester(Other.Weapon) != none
		|| Single(Other.Weapon) != none || Dualies(Other.Weapon) != none
		|| Deagle(Other.Weapon) != none || DualDeagle(Other.Weapon) != none
		|| M14EBRBattleRifle(Other.Weapon) != none || M99SniperRifle(Other.Weapon) != none
		|| SPSniperRifle(Other.Weapon) != none)
	{
		Recoil = 0.25;
		return Recoil;
	}

	Recoil = 1.f;
	return Recoil;
}

static function float GetFireSpeedMod(KFPlayerReplicationInfo KFPRI, Weapon Other)
{
	if (Crossbow(Other) != None || M99SniperRifle(Other) != None)
	{
		return LerpStat(KFPRI, 1.f, 1.15f);
	}
	else if (SPSniperRifle(Other) != None)
	{
		return LerpStat(KFPRI, 1.f, 1.3f);
	}
	else if (Winchester(Other) != None)
	{
		return LerpStat(KFPRI, 1.f, 1.6f);
	}

	return 1.0;
}

static function float GetReloadSpeedModifier(KFPlayerReplicationInfo KFPRI, KFWeapon Other)
{
	if (Crossbow(Other) != None || M99SniperRifle(Other) != None)
	{
		return LerpStat(KFPRI, 1.f, 1.15f);
	}

	if(Magnum44Pistol(Other) != None || Dual44Magnum(Other) != None)
	{
		return LerpStat(KFPRI, 1.f, 1.25f);
	}

	if (Winchester(Other) != None
		|| Single(Other) != None || Dualies(Other) != None
		|| Deagle(Other) != None || DualDeagle(Other) != None
		|| MK23Pistol(Other) != None || DualMK23Pistol(Other) != None
		|| M14EBRBattleRifle(Other) != None
		|| SPSniperRifle(Other) != None)
	{
		return LerpStat(KFPRI, 1.f, 1.6f);
	}

	return 1.f;
}

static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item)
{
	switch(Item)
	{
		case class'W_MK23_Pickup':
		case class'W_DualMK23_Pickup':
		case class'W_Magnum44_Pickup':
		case class'W_Dual44_Pickup':
		case class'W_Deagle_Pickup':
		case class'W_DualDeagle_Pickup':
		case class'W_Deagle_Pickup_G':
		case class'W_DualDeagle_Pickup_G':
		case class'W_M14_Pickup' :
		case class'W_SPSniper_Pickup' :
			return LerpStat(KFPRI, 0.9f, 0.3f);
			break;

		case class'W_Crossbow_Pickup' :
		case class'W_M99_Pickup' :
			return 1.f;
			break;
	}

	return 1.f;
}

static function float GetAmmoCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item)
{
	switch(Item)
	{
		case class'W_Crossbow_Pickup':
		case class'W_M99_Pickup' :
			return LerpStat(KFPRI, 1.f, 0.7f);
			break;
	}

	return 1.f;
}

static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P)
{
	KFHumanPawn(P).CreateInventoryVeterancy(string(class'W_LAR_Weap'), default.StartingWeaponSellPriceLevel6);
}

static function string GetCustomLevelInfo(byte Level)
{
	return default.SRLevelEffects[6];
}

defaultproperties
{
     StartingWeaponSellPriceLevel5=255.000000
     StartingWeaponSellPriceLevel6=255.000000
     OnHUDGoldIcon=Texture'KFTurbo.Perks.Sharp_D'
}
