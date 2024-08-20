class TurboVeterancyTypes extends SRVeterancyTypes
	abstract;

var int LevelRankRequirement; //Denotes levels between new rank names.
var float HighDifficultyExtraAmmoMultiplier;

var	Texture StarTexture;

//Are we playing KFTurbo+? Fixed to be callable by clients.
static final function bool IsHighDifficulty( Actor Actor )
{
	return class'KFTurboGameType'.static.StaticIsHighDifficulty(Actor);
}

static function ApplyAdjustedMovementSpeedModifier(KFPlayerReplicationInfo KFPRI, KFGameReplicationInfo KFGRI, out float Multiplier)
{
	if (TurboGameReplicationInfo(KFGRI) != None)
	{
		Multiplier *= TurboGameReplicationInfo(KFGRI).GetPlayerMovementSpeedMultiplier();
	}
}

static function float GetMovementSpeedModifier(KFPlayerReplicationInfo KFPRI, KFGameReplicationInfo KFGRI)
{
	local float Multiplier;
	Multiplier = 1.f;
	ApplyAdjustedMovementSpeedModifier(KFPRI, KFGRI, Multiplier);
	return Multiplier;
}

//Split off from AddExtraAmmoFor. Applies HighDifficultyExtraAmmoMultiplier on High Difficulty game types and anyone else who wants to mutate ammo amounts separately from perk bonuses.
static function ApplyAdjustedExtraAmmo(KFPlayerReplicationInfo KFPRI, class<Ammunition> AmmoType, out float Multiplier)
{
	if (!IsHighDifficulty(KFPRI))
	{
		if (TurboGameReplicationInfo(KFPRI.Level.GRI) != None)
		{
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
		Multiplier *= TurboGameReplicationInfo(KFPRI.Level.GRI).GetMaxAmmoMultiplier();
	}
}

static function float AddExtraAmmoFor(KFPlayerReplicationInfo KFPRI, class<Ammunition> AmmoType)
{
	local float Multiplier;
	Multiplier = 1.f;
	ApplyAdjustedExtraAmmo(KFPRI, AmmoType, Multiplier);
	return Multiplier;
}

static function ApplyAdjustedFireRate(KFPlayerReplicationInfo KFPRI, Weapon Other, out float Multiplier)
{
	if (TurboGameReplicationInfo(KFPRI.Level.GRI) != None)
	{
		Multiplier *= TurboGameReplicationInfo(KFPRI.Level.GRI).GetFireRateMultiplier();
	}
}

static function float GetFireSpeedMod(KFPlayerReplicationInfo KFPRI, Weapon Other)
{
	local float Multiplier;
	Multiplier = 1.f;
	ApplyAdjustedFireRate(KFPRI, Other, Multiplier);
	return Multiplier;
}

static function ApplyAdjustedReloadRate(KFPlayerReplicationInfo KFPRI, Weapon Other, out float Multiplier)
{
	if (TurboGameReplicationInfo(KFPRI.Level.GRI) != None)
	{
		Multiplier *= TurboGameReplicationInfo(KFPRI.Level.GRI).GetReloadRateMultiplier();
	}
}

static function float GetReloadSpeedModifier(KFPlayerReplicationInfo KFPRI, KFWeapon Other)
{
	local float Multiplier;
	Multiplier = 1.f;
	ApplyAdjustedReloadRate(KFPRI, Other, Multiplier);
	return Multiplier;
}

static function ApplyAdjustedMagCapacityModifier(KFPlayerReplicationInfo KFPRI, KFWeapon Other, out float Multiplier)
{
	if (Other.default.MagCapacity > 1 && TurboGameReplicationInfo(KFPRI.Level.GRI) != None)
	{
		Multiplier *= TurboGameReplicationInfo(KFPRI.Level.GRI).GetMagazineAmmoMultiplier();
	}
}

static function float GetMagCapacityMod(KFPlayerReplicationInfo KFPRI, KFWeapon Other)
{
	local float Multiplier;
	Multiplier = 1.f;
	ApplyAdjustedMagCapacityModifier(KFPRI, Other, Multiplier);
	return Multiplier;
}

static function ApplyAdjustedRecoilSpreadModifier(KFPlayerReplicationInfo KFPRI, WeaponFire Other, out float Multiplier)
{
	if (TurboGameReplicationInfo(KFPRI.Level.GRI) != None)
	{
		Multiplier *= TurboGameReplicationInfo(KFPRI.Level.GRI).GetWeaponSpreadRecoilMultiplier();
	}
}

static function float ModifyRecoilSpread(KFPlayerReplicationInfo KFPRI, WeaponFire Other, out float Recoil)
{
	Recoil = 1.f;
	ApplyAdjustedRecoilSpreadModifier(KFPRI, Other, Recoil);
	return Recoil;
}

static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item)
{
	local float Multiplier;
	Multiplier = 1.f;
	ApplyCostScalingModifier(KFPRI, Item, Multiplier);
	return Multiplier;
}

static function ApplyCostScalingModifier(KFPlayerReplicationInfo KFPRI, class<Pickup> Item, out float Multiplier)
{
	if (TurboGameReplicationInfo(KFPRI.Level.GRI) != None)
	{
		Multiplier *= TurboGameReplicationInfo(KFPRI.Level.GRI).GetTraderCostMultiplier();
	}
}

static function float GetAmmoCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item)
{
	local float Multiplier;
	Multiplier = 1.f;
	ApplyAmmoCostScalingModifier(KFPRI, Item, Multiplier);
	return Multiplier;
}

static function ApplyAmmoCostScalingModifier(KFPlayerReplicationInfo KFPRI, class<Pickup> Item, out float Multiplier)
{
	if (TurboGameReplicationInfo(KFPRI.Level.GRI) != None)
	{
		Multiplier *= TurboGameReplicationInfo(KFPRI.Level.GRI).GetTraderCostMultiplier();

		if (class<FragPickup>(Item) != None)
		{
			Multiplier *= TurboGameReplicationInfo(KFPRI.Level.GRI).GetTraderGrenadeCostMultiplier();
		}
	}
}

static final function int GetScaledRequirement(byte CurLevel, int InValue)
{
	return CurLevel * CurLevel * InValue;
}

static function class<DamageType> GetMAC10DamageType(KFPlayerReplicationInfo KFPRI)
{
	return none; //We no longer use this function anymore, W_MAC10_Fire extends KFFire
}

//Slight change to how this works:
//0 - returns this perk's title
//1 - always returns TurboVeterancyTypes::GetCustomLevelInfo()'s result
//2 - returns SRVeterancyTypes::GetVetInfoText()'s result
//3 - returns the full perk name, including perk title.
//4 - returns perk veterancy name, without title.
static function string GetVetInfoText(byte Level, byte Type, optional byte RequirementNum)
{
	switch (Type)
	{
	case 0:
		return GetPerkTitle(Level);
	case 1:
		return GetCustomLevelInfo(Level);
	case 3:
		return GetFullPerkName(Level);
	case 4:
		return Default.VeterancyName;
	}

	return Super.GetVetInfoText(Level, Type, RequirementNum);
}

//Includes perk's title suffixed to perk name.
static function string GetFullPerkName(byte Level)
{
	local string Title;

	Title = GetPerkTitle(Level);

	if (Title != "")
	{
		return Title @ Default.VeterancyName;
	}

	return Default.VeterancyName;
}

static function string GetPerkTitle(byte Level)
{
	local int Index;
	Index = Min(Level / Default.LevelRankRequirement, ArrayCount(Default.LevelNames) - 1);
	return Default.LevelNames[Index];
}

//Lerp function but written so that we mutate our exact behaviour in a centralized location.
//Right now just immediately returns the highest value we want.
static function float LerpStat(KFPlayerReplicationInfo KFPRI, float A, float B)
{
	return B;

	/*local float Level;
	Level = FClamp(float(KFPRI.ClientVeteranSkillLevel) / 6.f, 0.f, 1.f);
	return Lerp(Level, A, B);*/
}

static function Color GetPerkColor(byte Level)
{
	local int Index;
	Index = Level / Default.LevelRankRequirement;

	switch (Index)
	{
	case 0:
		return class'Canvas'.static.MakeColor(255,32,32,255); //Red
	case 1:
		return class'Canvas'.static.MakeColor(25,208,0,255); //Green
	case 2:
		return class'Canvas'.static.MakeColor(10,120,255,255); //Blue
	case 3:
		return class'Canvas'.static.MakeColor(255,0,255,255); //Pink
	case 4:
		return class'Canvas'.static.MakeColor(150,30,255,255); //Purple
	case 5:
		return class'Canvas'.static.MakeColor(255,110,0,255); //Orange
	case 6:
		return class'Canvas'.static.MakeColor(255,190,10,255); //Gold
	case 7:
		return class'Canvas'.static.MakeColor(255,235,225,255); //Platinum
	case 8:
		return class'Canvas'.static.MakeColor(255,235,225, 255); //Platinum
	}
}

static function byte PreDrawPerk(Canvas C, byte Level, out Material PerkIcon, out Material StarIcon)
{
	local int Index;
	local byte DrawColorAlpha;
	Index = Level / Default.LevelRankRequirement;

	StarIcon = Default.StarTexture;
	PerkIcon = Default.OnHUDGoldIcon;

	DrawColorAlpha = C.DrawColor.A;
	C.DrawColor = GetPerkColor(Level);
	C.DrawColor.A = DrawColorAlpha;

	return Level % Default.LevelRankRequirement;
}

defaultproperties
{
	LevelRankRequirement=5
	HighDifficultyExtraAmmoMultiplier=1.5f
	
	StarTexture=Texture'KFTurbo.Perks.Star_D'

	LevelNames(1)="Experienced"
	LevelNames(2)="Skilled"
	LevelNames(3)="Adept"
	LevelNames(4)="Masterful"
	LevelNames(5)="Inhuman"
	LevelNames(6)="Godlike"
}
