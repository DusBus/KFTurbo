class TurboHUDPlayer extends TurboHUDOverlay;

var int BaseFontSize;

//These sizes are based on % of monitor Y size.
var(Layout) Vector2D HealthBackplateSize;
var(Layout) Vector2D AmmoBackplateSize;
var(Layout) Vector2D AlternateAmmoBackplateSize; //Used by both secondary ammo and medic ammo.
var(Layout) Vector2D WeightBackplateSize;
var(Layout) Vector2D CashBackplateSize;
var(Layout) Vector2D PerkProgressSize;
var(Layout) Vector2D PerkProgressOffset;
var(Layout) Vector2D PerkIconOffset;

//Space for text centered around the above backplate sizes (so that there can be a margin at the edges of the backplate)
var(Layout) Vector2D HealthBackplateTextArea;
var(Layout) Vector2D AmmoBackplateTextArea;
var(Layout) Vector2D AlternateAmmoBackplateTextArea;
var(Layout) Vector2D WeightBackplateTextArea;
var(Layout) Vector2D CashBackplateTextArea;

var Vector2D BackplateSpacing; //Distance from top and middle.

var float EmptyDigitOpacityMultiplier;

var Color BackplateColor;
var Texture RoundedContainer;

var float CurrentHealth;
var float HealthInterpRate;

var float CurrentArmor;
var float ArmorInterpRate;

var Syringe CurrentSyringe;
var float CurrentSyringeCharge;
var float SyringeInterpRate;
var Texture SyringeIcon;

var Frag CurrentGrenade;
var float CurrentGrenadeCount;
var float MaxGrenadeCount;
var Texture GrenadeIcon;

var Welder CurrentWelder;
var float CurrentWelderCharge;
var float WelderInterpRate;

var float CurrentLoadedAmmo;
var float CurrentSpareAmmo;

var bool bIsMeleeGun;
var bool bIsWelderOrSyringe;
var bool bIsSingleShotWeapon;
var bool bIsHuskGun;
var bool bIsLargeCapacityMagazine;

var bool bWeaponHasSecondaryAmmo;
var bool bIsMedicGun;
var float CurrentSpareSecondaryAmmo;
var float CurrentMaxSecondaryAmmo;
var float SecondaryAmmoFade;
var float SecondaryAmmoFadeRate;
var localized string SecondaryAmmoHeader; //Can be anything - just make sure it's 3 or less characters.

var KFWeapon LastKnownWeapon;
var bool bIsReloading;
var float ReloadFade;
var float ReloadFadeRate;

var bool bIsOutOfAmmo;
var float OutOfAmmoFade;
var float OutOfAmmoFadeRate;

var bool bIsFlashlightOn;
var float FlashlightPower;
var float FlashlightPowerFade;
var float FlashlightPowerFadeRate;
var float FlashlightPosition;
var Texture FlashlightIcon;

var int CurrentWeight;
var int MaxCarryWeight;
var Texture WeightIcon;

var float CurrentPlayerCash;
var float TargetPlayerCash;
var float CurrentPlayerCashReceive;
var float CurrentPlayerCashReceiveDivisor;
var int LastPlayerCash, LastReceivedBonus;
var float LastCashLostTime;
var float ReceivedCashDecayDelay;
var float CashInterpRate;
var float CurrentCashBackplateX;
var float DesiredCashBackplateX;

var(Perk) int PerkLevel;
var(Perk) float PerkProgress;
var(Perk) Color PerkProgressColor;
var(Perk) class<TurboVeterancyTypes> PlayerPerk;
var(Perk) float PerkDrawScale;

simulated function Tick(float DeltaTime)
{
	if (KFPHUD == None || KFPHUD.PawnOwner == None || KFPHUD.PawnOwnerPRI == None || KFPHUD.PawnOwner.Health <= 0)
	{
		CurrentHealth = 0.f;
		CurrentArmor = 0.f;
		CurrentSyringeCharge = 0.f;
		CurrentGrenadeCount = 0;
		MaxGrenadeCount = 5;
		bIsMeleeGun = false;
		bIsWelderOrSyringe = false;
		bIsSingleShotWeapon = false;
		bIsReloading = false;
		ReloadFade = 0.f;
		bIsOutOfAmmo = false;
		OutOfAmmoFade = 0.f;
		CurrentPlayerCash = -1.f;
		return;
	}

	DeltaTime = FMin(DeltaTime, 0.1f);

	TickPlayerReplicationInfo(DeltaTime, KFPlayerReplicationInfo(KFPHUD.PawnOwnerPRI));

	FindSyringe();
	FindWelder();
	FindGrenade();

	CurrentHealth = Lerp(HealthInterpRate * DeltaTime, CurrentHealth, float(KFPHUD.PawnOwner.Health));
	if (Abs(CurrentHealth - float(KFPHUD.PawnOwner.Health)) < 0.1)
	{
		CurrentHealth = float(KFPHUD.PawnOwner.Health);
	}

	CurrentArmor = Lerp(ArmorInterpRate * DeltaTime, CurrentArmor, KFPHUD.PawnOwner.ShieldStrength);
	if (Abs(CurrentArmor - KFPHUD.PawnOwner.ShieldStrength) < 0.5)
	{
		CurrentArmor = KFPHUD.PawnOwner.ShieldStrength;
	}

	TickHumanPawn(DeltaTime, KFHumanPawn(KFPHUD.PawnOwner));
	TickSyringe(DeltaTime);
	TickWelder(DeltaTime);

	if (CurrentGrenade != None)
	{
		CurrentGrenade.GetAmmoCount(MaxGrenadeCount, CurrentGrenadeCount);
	}
	else
	{
		CurrentGrenadeCount = 0;
		MaxGrenadeCount = 5;
	}

	bIsReloading = false;
	bIsOutOfAmmo = false;
	if (KFWeapon(KFPHUD.PawnOwner.Weapon) != None)
	{
		WeaponUpdate(DeltaTime, KFWeapon(KFPHUD.PawnOwner.Weapon));
	}

	if (bIsFlashlightOn || FlashlightPower < 100.f)
	{
		FlashlightPowerFade = FMin(FlashlightPowerFade + (DeltaTime * FlashlightPowerFadeRate), 1.f);
	}
	else
	{
		FlashlightPowerFade = FMax(FlashlightPowerFade - (DeltaTime * FlashlightPowerFadeRate), 0.f);
	}

	if (bWeaponHasSecondaryAmmo)
	{
		FlashlightPosition = Lerp(DeltaTime * SecondaryAmmoFadeRate * 4.f, FlashlightPosition, 1.f);
		SecondaryAmmoFade = FMin(SecondaryAmmoFade + (DeltaTime * SecondaryAmmoFadeRate), 1.f);
	}
	else
	{
		FlashlightPosition = Lerp(DeltaTime * SecondaryAmmoFadeRate * 0.25f, FlashlightPosition, 0.f);
		SecondaryAmmoFade = FMax(SecondaryAmmoFade - (DeltaTime * SecondaryAmmoFadeRate), 0.f);
	}

	if (bIsReloading)
	{
		ReloadFade = FMin(ReloadFade + (DeltaTime * ReloadFadeRate), 1.f);
	}
	else
	{
		ReloadFade = FMax(ReloadFade - (DeltaTime * ReloadFadeRate), 0.f);
	}

	if (bIsOutOfAmmo)
	{
		OutOfAmmoFade = FMin(OutOfAmmoFade + (DeltaTime * OutOfAmmoFadeRate), 1.f);
	}
	else
	{
		OutOfAmmoFade = FMax(OutOfAmmoFade - (DeltaTime * OutOfAmmoFadeRate), 0.f);
	}

	CurrentCashBackplateX = Lerp(DeltaTime * 2.f, CurrentCashBackplateX, DesiredCashBackplateX);
}

simulated function OnScreenSizeChange(Canvas C, Vector2D CurrentClipSize, Vector2D PreviousClipSize)
{
	if (C.ClipY > 1600)
	{
		BaseFontSize = 0;
	}
	else if (C.ClipY > 1000)
	{
		BaseFontSize = 1;
	}
	else
	{
		BaseFontSize = 2;
	}
}

simulated function FindSyringe()
{
	if (CurrentSyringe != None)
	{
		return;
	}	
	
	CurrentSyringe = Syringe(KFPHUD.PawnOwner.FindInventoryType(class'Syringe'));
}

simulated function FindWelder()
{
	if (CurrentWelder != None)
	{
		return;
	}	
	
	CurrentWelder = Welder(KFPHUD.PawnOwner.FindInventoryType(class'Welder'));
}

simulated function FindGrenade()
{
	if (CurrentGrenade != None)
	{
		return;
	}	
	
	CurrentGrenade = Frag(KFPHUD.PawnOwner.FindInventoryType(class'Frag'));
}

simulated function TickPlayerReplicationInfo(float DeltaTime, KFPlayerReplicationInfo KFPRI)
{
	local int CurrentScore;

	if (KFPRI == None)
	{
		PlayerPerk = None;
		return;
	}

	PlayerPerk = class<TurboVeterancyTypes>(KFPRI.ClientVeteranSkill);
	PerkLevel = KFPRI.ClientVeteranSkillLevel;

	if (PlayerPerk != None)
	{
		PerkProgress = Lerp(DeltaTime * 2.f, PerkProgress, PlayerPerk.static.GetTotalProgress(class'ClientPerkRepLink'.static.FindStats(KFPHUD.PlayerOwner), PerkLevel + 1));
	}

	if (CurrentPlayerCash == -1.f)
	{
		CurrentScore = KFPRI.Score;
		CurrentPlayerCash = CurrentScore;
		LastPlayerCash = CurrentScore;
		return;
	}

	CurrentScore = KFPRI.Score;
	CurrentPlayerCash = Lerp(DeltaTime * CashInterpRate, CurrentPlayerCash, CurrentScore);

	if (Abs(CurrentPlayerCash - CurrentScore) < 0.5)
	{
		CurrentPlayerCash = CurrentScore;
	}

	if (LastReceivedBonus + ReceivedCashDecayDelay < Level.TimeSeconds)
	{
		CurrentPlayerCashReceive = Lerp(DeltaTime * CashInterpRate * 2.f, CurrentPlayerCashReceive, 0.f);
	}

	if (CurrentScore == LastPlayerCash)
	{
		return;
	}

	if (CurrentScore < LastPlayerCash)
	{
		LastCashLostTime = Level.TimeSeconds;
		LastPlayerCash = KFPRI.Score;
		return;
	}

	if (CurrentScore > LastPlayerCash && (LastCashLostTime + 0.5f < Level.TimeSeconds))
	{
		CurrentPlayerCashReceive += CurrentScore - LastPlayerCash;
		CurrentPlayerCashReceiveDivisor = CurrentPlayerCashReceive;
		LastReceivedBonus = Level.TimeSeconds;
	}

	LastPlayerCash = KFPRI.Score;
}

simulated function TickHumanPawn(float DeltaTime, KFHumanPawn HumanPawn)
{
	local float CurrentFlashlightPower;

	if (HumanPawn == None)
	{
		FlashlightPower = 0.f;
		CurrentWeight = 0.f;
		MaxCarryWeight = 15.f;
		return;
	}

	CurrentWeight = HumanPawn.CurrentWeight;
	MaxCarryWeight = HumanPawn.MaxCarryWeight;

	CurrentFlashlightPower = (float(HumanPawn.TorchBatteryLife) / float(HumanPawn.default.TorchBatteryLife)) * 100.f;

	FlashlightPower = Lerp(SyringeInterpRate * DeltaTime * 0.25f, FlashlightPower, CurrentFlashlightPower);

	if (Abs(CurrentFlashlightPower - FlashlightPower) < 0.5)
	{
		FlashlightPower = CurrentFlashlightPower;
	}
}

simulated function TickSyringe(float DeltaTime)
{
	local float SyringeCharge;

	if (CurrentSyringe == None)
	{
		CurrentSyringeCharge = 0.f;
		return;
	}

	SyringeCharge = CurrentSyringe.ChargeBar() * 100.f;

	if (SyringeCharge < CurrentSyringeCharge)
	{
		CurrentSyringeCharge = SyringeCharge;
	}
	else
	{
		CurrentSyringeCharge = Lerp(SyringeInterpRate * DeltaTime, CurrentSyringeCharge, SyringeCharge);

		if (Abs(CurrentSyringeCharge - SyringeCharge) < 0.5)
		{
			CurrentSyringeCharge = SyringeCharge;
		}
	}
}

simulated function TickWelder(float DeltaTime)
{
	local float WelderCharge;

	if (CurrentWelder == None)
	{
		CurrentWelderCharge = 0.f;
		return;
	}

	WelderCharge = CurrentWelder.ChargeBar() * 100.f;

	CurrentWelderCharge = Lerp(WelderInterpRate * DeltaTime, CurrentWelderCharge, WelderCharge);

	if (Abs(CurrentWelderCharge - WelderCharge) < 0.5)
	{
		CurrentWelderCharge = WelderCharge;
	}
}

simulated function WeaponUpdate(float DeltaTime, KFWeapon Weapon)
{
	if (LastKnownWeapon != Weapon)
	{
		LastKnownWeapon = Weapon;
		OutOfAmmoFade = 0.f;
	}

	bIsReloading = Weapon.bIsReloading;
	bIsOutOfAmmo = false;

	bIsFlashlightOn = Weapon.FlashLight != None && Weapon.FlashLight.bHasLight;
	
	bIsMeleeGun = KFMeleeGun(KFPHUD.PawnOwner.Weapon) != None;
	bIsWelderOrSyringe = (KFPHUD.PawnOwner.Weapon == CurrentWelder) || (KFPHUD.PawnOwner.Weapon == CurrentSyringe);

	bIsSingleShotWeapon = false;
	bIsHuskGun = false;
	bIsLargeCapacityMagazine = false;

	bIsMedicGun = false;
	bWeaponHasSecondaryAmmo = false;

	if (bIsMeleeGun)
	{
		if (bIsWelderOrSyringe)
		{
			if (KFPHUD.PawnOwner.Weapon == CurrentSyringe)
			{
				CurrentLoadedAmmo = CurrentSyringeCharge;
			}
			else if (KFPHUD.PawnOwner.Weapon == CurrentWelder)
			{
				CurrentLoadedAmmo = CurrentWelderCharge;
			}
			else
			{
				Weapon.GetAmmoCount(CurrentSpareAmmo, CurrentLoadedAmmo);
				CurrentLoadedAmmo = (CurrentLoadedAmmo / CurrentSpareAmmo) * 100.f;
			}

			CurrentSpareAmmo = 0;
		}
		else
		{
			CurrentLoadedAmmo = 0;
			CurrentSpareAmmo = 0;
		}
		return;
	}

	bIsMedicGun = KFMedicGun(Weapon) != None;
	bWeaponHasSecondaryAmmo = Weapon.bHasSecondaryAmmo && !Weapon.bReduceMagAmmoOnSecondaryFire;
	if (bWeaponHasSecondaryAmmo)
	{
		if (!bIsMedicGun)
		{
			Weapon.GetSecondaryAmmoCount(CurrentMaxSecondaryAmmo, CurrentSpareSecondaryAmmo);
		}
		else
		{
			MedicGunUpdate(DeltaTime, KFMedicGun(Weapon));
		}
	}

	if (Weapon.MagCapacity == 1)
	{
		bIsHuskGun = HuskGun(Weapon) != None;

		bIsSingleShotWeapon = !bIsHuskGun;
		
		if (bIsSingleShotWeapon)
		{
			Weapon.GetAmmoCount(CurrentSpareAmmo, CurrentLoadedAmmo);
			CurrentSpareAmmo = 0;
			bIsOutOfAmmo = CurrentLoadedAmmo <= 0;
			return;
		}
	}
	else if (Weapon.MagCapacity > 99)
	{
		bIsLargeCapacityMagazine = true;
	}

	if (bIsHuskGun)
	{
		HuskGunUpdate(HuskGun(Weapon));
		return;
	}

	Weapon.GetAmmoCount(CurrentLoadedAmmo, CurrentSpareAmmo);
	CurrentLoadedAmmo = Weapon.MagAmmoRemaining;
	bIsOutOfAmmo = (CurrentSpareAmmo - CurrentLoadedAmmo) <= 0;

	//Large capacity magazines need to do this. We only support two digits!
	if (bIsLargeCapacityMagazine)
	{
		CurrentSpareAmmo = ((CurrentSpareAmmo - CurrentLoadedAmmo) / float(Weapon.MagCapacity)) * 100.f;
		CurrentLoadedAmmo = (CurrentLoadedAmmo / float(Weapon.MagCapacity)) * 99.f;
	}
}

simulated function HuskGunUpdate(HuskGun HuskGun)
{
	local HuskGunFire FireMode;
	FireMode = HuskGunFire(HuskGun.GetFireMode(0));

	HuskGun.GetAmmoCount(CurrentLoadedAmmo, CurrentSpareAmmo);
	CurrentLoadedAmmo = (FireMode.HoldTime / FireMode.MaxChargeTime) * 99.f;
}

simulated function MedicGunUpdate(float DeltaTime, KFMedicGun MedicGun)
{
	local float MedicGunCharge;
	MedicGunCharge = MedicGun.ChargeBar() * 100.f;

	if (CurrentSpareSecondaryAmmo > MedicGunCharge)
	{
		MedicGunCharge = CurrentMaxSecondaryAmmo;
		return;
	}

	CurrentSpareSecondaryAmmo = Lerp(DeltaTime * SyringeInterpRate, CurrentSpareSecondaryAmmo, MedicGunCharge);
}

simulated function Render(Canvas C)
{
	local Vector2D BackplateACenter, BackplateBCenter;
	local Vector2D LeftAnchor, RightAnchor;

	Super.Render(C);

	if (KFPHUD.PawnOwner == None || KFPHUD.PawnOwner.Health <= 0)
	{
		return;
	}

	DrawBackplates(C, BackplateACenter, BackplateBCenter, LeftAnchor, RightAnchor);
	DrawHealthText(C, BackplateACenter);
	DrawAmmoText(C, BackplateBCenter);

	DrawAlternativeAmmo(C, RightAnchor);
	DrawWeight(C, LeftAnchor);
	DrawCash(C);

	DrawPerk(C);
}

simulated function DrawBackplates(Canvas C, out Vector2D BackplateACenter, out Vector2D BackplateBCenter, out Vector2D LeftAnchor, out Vector2D RightAnchor)
{
	local float CenterX, TopY;
	local float TempX, TempY;

	CenterX = C.ClipX * 0.5f;
	TopY = C.ClipY * (1.f - (BackplateSpacing.Y + HealthBackplateSize.Y));

	TempX = CenterX - (C.ClipY * (BackplateSpacing.X + HealthBackplateSize.X));
	TempY = TopY;

	C.DrawColor = BackplateColor;

	C.SetPos(TempX, TempY);
	BackplateACenter.X = TempX + (C.ClipY * HealthBackplateSize.X * 0.5f);
	BackplateACenter.Y = TempY + (C.ClipY * HealthBackplateSize.Y * 0.5f);

	C.DrawTileStretched(RoundedContainer, C.ClipY * HealthBackplateSize.X, C.ClipY * HealthBackplateSize.Y);
	
	LeftAnchor.X = TempX - (C.ClipY * BackplateSpacing.X * 0.5f);
	LeftAnchor.Y = C.ClipY * (1.f - BackplateSpacing.Y);

	TempX = CenterX + (C.ClipY * BackplateSpacing.X);
	TopY = C.ClipY * (1.f - (BackplateSpacing.Y + AmmoBackplateSize.Y));
	TempY = TopY;

	C.SetPos(TempX, TempY);
	BackplateBCenter.X = TempX + (C.ClipY * AmmoBackplateSize.X * 0.5f);
	BackplateBCenter.Y = TempY + (C.ClipY * AmmoBackplateSize.Y * 0.5f);

	C.DrawTileStretched(RoundedContainer, C.ClipY * AmmoBackplateSize.X, C.ClipY * AmmoBackplateSize.Y);

	RightAnchor.X = TempX + (C.ClipY * ((BackplateSpacing.X * 0.5f) + AmmoBackplateSize.X));
	RightAnchor.Y = LeftAnchor.Y;
}

simulated function DrawHealthText(Canvas C, Vector2D BackplateACenter)
{
	local float BackplateSizeX, BackplateSizeY;
	local float HealthSizeX, ArmorSizeX, SyringeSizeX;
	local float DefaultTextSizeX, DefaultTextSizeY;
	local float TextSizeX, TextSizeY, TextScale;
	local string HealthString, ArmorString, SyringeString;
	local byte SyringeOpacity;

	BackplateSizeX = HealthBackplateTextArea.X * C.ClipY;
	BackplateSizeY = HealthBackplateTextArea.Y * C.ClipY;
	HealthSizeX = BackplateSizeX * 0.667f;
	ArmorSizeX = BackplateSizeX - HealthSizeX;
	SyringeSizeX = ArmorSizeX * 0.667f;

	C.SetPos(BackplateACenter.X - (HealthSizeX - (BackplateSizeX * 0.5f)), BackplateACenter.Y - (BackplateSizeY * 0.5f));

	//Get how big this font is in general for 3 digit numbers.
	C.FontScaleX = 1.f;
	C.FontScaleY = 1.f;
	C.Font = class'KFTurboFonts'.static.LoadLargeNumberFont(BaseFontSize);
	C.TextSize(GetStringOfZeroes(3), DefaultTextSizeX, DefaultTextSizeY);
	
	//Health
	//Scale Health text to fit the right 2/3 of the backplate.
	C.DrawColor = C.MakeColor(220, 255, 170, 220);
	TextScale = HealthSizeX / DefaultTextSizeX;
	C.FontScaleX = TextScale;
	C.FontScaleY = TextScale;
	C.TextSize(GetStringOfZeroes(3), TextSizeX, TextSizeY);
	
	C.SetPos(BackplateACenter.X - (HealthSizeX - (BackplateSizeX * 0.5f)), BackplateACenter.Y - (TextSizeY * 0.515f));

	HealthString = FillStringWithZeroes(Min(int(CurrentHealth), 999), 3);
	DrawCounterTextMeticulous(C, HealthString, TextSizeX, EmptyDigitOpacityMultiplier);

	//Armor
	C.FontScaleX = 1.f;
	C.FontScaleY = 1.f;
	C.DrawColor = C.MakeColor(170, 220, 255, 220);
	C.Font = class'KFTurboFonts'.static.LoadLargeNumberFont(BaseFontSize + 1);
	C.TextSize(GetStringOfZeroes(3), DefaultTextSizeX, DefaultTextSizeY);
	TextScale = ArmorSizeX / DefaultTextSizeX;
	C.FontScaleX = TextScale;
	C.FontScaleY = TextScale;
	C.TextSize(GetStringOfZeroes(3), TextSizeX, TextSizeY);

	C.SetPos(((BackplateACenter.X - (BackplateSizeX * 0.48f)) + (ArmorSizeX * 0.5f)) - (TextSizeX * 0.5f), (BackplateACenter.Y + (BackplateSizeY * 0.475f)) - TextSizeY);

	ArmorString = FillStringWithZeroes(Min(int(CurrentArmor), 999), 3);
	DrawCounterTextMeticulous(C, ArmorString, TextSizeX, EmptyDigitOpacityMultiplier);

	//Syringe
	C.FontScaleX = 1.f;
	C.FontScaleY = 1.f;
	C.Font = class'KFTurboFonts'.static.LoadLargeNumberFont(BaseFontSize + 2);
	C.TextSize(GetStringOfZeroes(3), DefaultTextSizeX, DefaultTextSizeY);
	TextScale = SyringeSizeX / DefaultTextSizeX;
	C.FontScaleX = TextScale;
	C.FontScaleY = TextScale;
	C.TextSize(GetStringOfZeroes(3), TextSizeX, TextSizeY);

	C.SetPos(BackplateACenter.X - ((BackplateSizeX * 0.275f) + (TextSizeX * 0.5f)), (BackplateACenter.Y - (BackplateSizeY * 0.21f)) - (TextSizeY * 0.5f));

	if (CurrentSyringeCharge >= 100.f)
	{
		SyringeOpacity = 220;
	}
	else if (CurrentSyringeCharge >= 50.f)
	{
		SyringeOpacity = 180;
	}
	else
	{
		SyringeOpacity = 100;
	}

	C.DrawColor = C.MakeColor(255, 255, 255, SyringeOpacity);
	
	SyringeString = FillStringWithZeroes(Min(int(CurrentSyringeCharge), 999), 3);
	DrawCounterTextMeticulous(C, SyringeString, TextSizeX, EmptyDigitOpacityMultiplier);
	
	C.DrawColor = C.MakeColor(255, 255, 255, 255);

	C.SetPos(BackplateACenter.X - ((BackplateSizeX * 0.5f)), (BackplateACenter.Y - (BackplateSizeY * 0.22f)) - (TextSizeY * 0.4f));
	C.DrawTileScaled(SyringeIcon, (TextSizeY / float(SyringeIcon.VSize)) * 0.8f, (TextSizeY / float(SyringeIcon.VSize)) * 0.8f);
}


simulated function DrawAmmoText(Canvas C, Vector2D BackplateCenter)
{
	local float BackplateSizeX, BackplateSizeY;
	local float LoadedAmmoSizeX, SpareAmmoSizeX;
	local float DefaultTextSizeX, DefaultTextSizeY, LoadedAmmoSizeY;
	local float TextSizeX, TextSizeY, TextScale;
	local string CurrentLoadedAmmoString, CurrentSpareAmmoString, CurrentGrenadeCountString;

	BackplateSizeX = AmmoBackplateTextArea.X * C.ClipY;
	BackplateSizeY = AmmoBackplateTextArea.Y * C.ClipY;
	LoadedAmmoSizeX = BackplateSizeX * 0.5f;
	
	C.DrawColor = C.MakeColor(255, 255, 255, 255);

	//Get how big this font is in general for 3 digit numbers.
	C.FontScaleX = 1.f;
	C.FontScaleY = 1.f;
	C.Font = class'KFTurboFonts'.static.LoadLargeNumberFont(BaseFontSize);
	C.TextSize(GetStringOfZeroes(3), DefaultTextSizeX, DefaultTextSizeY);

	//Weapon Name
	CurrentLoadedAmmoString = LastKnownWeapon.ItemName;
	C.SetPos(BackplateCenter.X - (BackplateSizeX * 0.5f), (BackplateCenter.Y - (BackplateSizeY * 0.5f)));
	
	C.Font = class'KFTurboFonts'.static.LoadFontStatic(BaseFontSize + 3);
	C.TextSize(CurrentLoadedAmmoString, TextSizeX, TextSizeY);
	C.FontScaleX = 0.75f;
	C.FontScaleY = 0.75f;

	C.SetPos((BackplateCenter.X - (BackplateSizeX * 0.5f)) + 2.f, ((BackplateCenter.Y - (BackplateSizeY * 0.5f)) - (TextSizeY * 0.75f)));
	C.DrawText(CurrentLoadedAmmoString);

	//Loaded Ammo
	CurrentLoadedAmmoString = GetLoadedAmmoString();
	C.DrawColor = C.MakeColor(255, 255, 255, Lerp(ReloadFade, 220, 120));

	TextScale = (BackplateSizeY / DefaultTextSizeY) * 1.25f;
	C.FontScaleX = TextScale;
	C.FontScaleY = TextScale;
	C.Font = class'KFTurboFonts'.static.LoadLargeNumberFont(BaseFontSize);
	C.TextSize(GetStringOfZeroes(Len(CurrentLoadedAmmoString)), TextSizeX, TextSizeY);

	C.SetPos(BackplateCenter.X - (BackplateSizeX * 0.5f), BackplateCenter.Y - (TextSizeY * 0.515f));

	if (bIsSingleShotWeapon)
	{
		C.DrawColor.G = Lerp(OutOfAmmoFade, 255, 40);
		C.DrawColor.B = Lerp(OutOfAmmoFade, 255, 40);
	}
	else if (bIsMeleeGun && !bIsWelderOrSyringe)
	{
		C.DrawColor.A = 120;
	}
	
	DrawCounterTextMeticulous(C, CurrentLoadedAmmoString, TextSizeX, EmptyDigitOpacityMultiplier);

	LoadedAmmoSizeY = TextSizeY;
	SpareAmmoSizeX = BackplateSizeX - TextSizeX;

	//Spare Ammo
	CurrentSpareAmmoString = GetSpareAmmoString(); 

	C.FontScaleX = 1.f;
	C.FontScaleY = 1.f;
	C.Font = class'KFTurboFonts'.static.LoadLargeNumberFont(BaseFontSize + 1);
	C.TextSize(GetStringOfZeroes(Len(CurrentSpareAmmoString)), TextSizeX, TextSizeY);
	
	TextScale = ((LoadedAmmoSizeY * 0.5f) / TextSizeY);
	C.FontScaleX = TextScale;
	C.FontScaleY = TextScale;
	C.TextSize(GetStringOfZeroes(Len(CurrentSpareAmmoString)), TextSizeX, TextSizeY);

	C.SetPos(BackplateCenter.X + ((BackplateSizeX * 0.485f) - (TextSizeX)), (BackplateCenter.Y + (BackplateSizeY * 0.19f)) - (TextSizeY * 0.5f));

	C.DrawColor = C.MakeColor(255, 255, 255, 220);

	if (!bIsSingleShotWeapon && (!bIsMeleeGun || bIsWelderOrSyringe))
	{
		C.DrawColor.G = Lerp(OutOfAmmoFade, 255, 40);
		C.DrawColor.B = Lerp(OutOfAmmoFade, 255, 40);
	}
	else
	{
		C.DrawColor.A = 120;
	}

	DrawCounterTextMeticulous(C, CurrentSpareAmmoString, TextSizeX, EmptyDigitOpacityMultiplier);

	//Grenade Ammo
	C.DrawColor = C.MakeColor(255, 255, 255, 220);

	if (MaxGrenadeCount >= 10)
	{
		CurrentGrenadeCountString = FillStringWithZeroes(Min(CurrentGrenadeCount, 99), 2);
	}
	else
	{
		CurrentGrenadeCountString = string(Min(CurrentGrenadeCount, 9));
	}

	C.FontScaleX = 1.f;
	C.FontScaleY = 1.f;
	C.Font = class'KFTurboFonts'.static.LoadLargeNumberFont(BaseFontSize + 2);
	C.TextSize(GetStringOfZeroes(Len(CurrentGrenadeCountString)), TextSizeX, TextSizeY);

	TextScale = ((LoadedAmmoSizeY * 0.35f) / TextSizeY);
	C.FontScaleX = TextScale;
	C.FontScaleY = TextScale;
	C.TextSize(GetStringOfZeroes(Len(CurrentGrenadeCountString)), TextSizeX, TextSizeY);

	C.SetPos(BackplateCenter.X + (BackplateSizeX * 0.49f) - (TextSizeY * 0.6f), (BackplateCenter.Y - (BackplateSizeY * 0.24f)) - (TextSizeY * 0.3f));
	C.DrawTileScaled(GrenadeIcon, (TextSizeY / float(SyringeIcon.VSize)) * 0.6f, (TextSizeY / float(SyringeIcon.USize)) * 0.6f);

	C.SetPos((BackplateCenter.X + ((BackplateSizeX * 0.49f)) - TextSizeX) - (TextSizeY * 0.6f), (BackplateCenter.Y - (BackplateSizeY * 0.24f)) - (TextSizeY * 0.5f));
	DrawCounterTextMeticulous(C, CurrentGrenadeCountString, TextSizeX, EmptyDigitOpacityMultiplier);
}

simulated function string GetLoadedAmmoString()
{
	if (bIsMeleeGun)
	{
		if (bIsWelderOrSyringe)
		{
			return FillStringWithZeroes(Min(CurrentLoadedAmmo, 99), 2);
		}

		return "00";
	}

	return FillStringWithZeroes(Min(CurrentLoadedAmmo, 99), 2);
}

simulated function string GetSpareAmmoString()
{
	if (bIsMeleeGun)
	{
		return "000";
	}

	if (bIsSingleShotWeapon)
	{
		return "000";
	}

	if (bIsHuskGun)
	{
		return FillStringWithZeroes(Min(CurrentSpareAmmo, 999), 3);
	}

	if (bIsLargeCapacityMagazine)
	{
		return FillStringWithZeroes(Min(CurrentSpareAmmo, 999), 3);
	}

	return FillStringWithZeroes(Min(CurrentSpareAmmo - CurrentLoadedAmmo, 999), 3);
}

//Secondary Ammo/Flashlight
simulated function DrawAlternativeAmmo(Canvas C, Vector2D RightAnchor)
{
	local float BackplateSizeX, BackplateSizeY;
	local float BackplateTextSizeX, BackplateTextSizeY;
	local float BackplateCenterX, BackplateCenterY;
	local float SpacingX;
	local float TempX, TempY;
	local float TextSizeX, TextSizeY;
	local string FlashlightString;

	SpacingX = C.ClipY * BackplateSpacing.X;
	BackplateSizeX = C.ClipY * AlternateAmmoBackplateSize.X;
	BackplateSizeY = C.ClipY * AlternateAmmoBackplateSize.Y;

	BackplateTextSizeX = C.ClipY * AlternateAmmoBackplateTextArea.X;
	BackplateTextSizeY = C.ClipY * AlternateAmmoBackplateTextArea.Y;

	if (FlashlightPowerFade > 0.01f)
	{
		TempX = RightAnchor.X;
		TempY = RightAnchor.Y;

		TempX += FlashlightPosition * ((SpacingX * 0.5f) + BackplateSizeX);

		C.DrawColor = BackplateColor;
		C.DrawColor.A = Lerp(1.f - FlashlightPowerFade, C.DrawColor.A, 0);

		C.SetPos(TempX, TempY - BackplateSizeY);
		C.DrawTileStretched(RoundedContainer, BackplateSizeX, BackplateSizeY);

		BackplateCenterX = TempX + (BackplateSizeX * 0.5f);
		BackplateCenterY = TempY - (BackplateSizeY * 0.5f);

		C.DrawColor = C.MakeColor(255, 255, 255, Max(Lerp(1.f - FlashlightPowerFade, 220, 0), 0));

		if (!bIsFlashlightOn)
		{
			C.DrawColor.A = Max(float(C.DrawColor.A) * 0.5f, 0);
		}

		//Draw bulb.
		TempX = BackplateCenterX;
		TempY = BackplateCenterY - (BackplateTextSizeY * 0.25f);
		C.SetPos(TempX - (BackplateTextSizeX * 0.4f), TempY - (BackplateTextSizeX * 0.375f));
		C.DrawTileScaled(FlashlightIcon, (BackplateTextSizeX * 0.8f) / float(SyringeIcon.USize), (BackplateTextSizeX * 0.8f) / float(SyringeIcon.VSize));

		//Draw current power.
		FlashlightString = FillStringWithZeroes(int(FlashlightPower), 3);
		
		C.FontScaleX = 1.f;
		C.FontScaleY = 1.f;
		C.Font = class'KFTurboFonts'.static.LoadLargeNumberFont(BaseFontSize + 3);
		C.TextSize(GetStringOfZeroes(Len(FlashlightString)), TextSizeX, TextSizeY);
		TempY = BackplateCenterY + (BackplateTextSizeY * 0.3f);
		C.FontScaleX = BackplateTextSizeX / TextSizeX;
		C.FontScaleY = C.FontScaleX;
		C.TextSize(GetStringOfZeroes(Len(FlashlightString)), TextSizeX, TextSizeY);

		C.DrawColor = C.MakeColor(255, 255, 255, Max(Lerp(1.f - FlashlightPowerFade, 220, 0), 0));

		C.SetPos(TempX - (TextSizeX * 0.5f), TempY - (TextSizeY * 0.5f));
		DrawCounterTextMeticulous(C, FlashlightString, TextSizeX, EmptyDigitOpacityMultiplier);
	}

	if (SecondaryAmmoFade > 0.01f)
	{
		TempX = RightAnchor.X;
		TempY = RightAnchor.Y;

		C.DrawColor = BackplateColor;
		C.DrawColor.A = Lerp(1.f - SecondaryAmmoFade, C.DrawColor.A, 0);

		C.SetPos(TempX, TempY - BackplateSizeY);
		C.DrawTileStretched(RoundedContainer, BackplateSizeX, BackplateSizeY);
		
		BackplateCenterX = TempX + (BackplateSizeX * 0.5f);
		BackplateCenterY = TempY - (BackplateSizeY * 0.5f);
	
		C.DrawColor = C.MakeColor(255, 255, 255, Max(Lerp(1.f - SecondaryAmmoFade, 220, 0), 0));

		TempX = BackplateCenterX;
		TempY = BackplateCenterY - (BackplateTextSizeY * 0.25f);

		//Draw "ALT" header text.
		C.FontScaleX = 1.f;
		C.FontScaleY = 1.f;
		C.Font = class'KFTurboFonts'.static.LoadLargeNumberFont(BaseFontSize + 3);
		C.TextSize(GetStringOfZeroes(3), TextSizeX, TextSizeY);
		C.FontScaleX = BackplateTextSizeX / TextSizeX;
		C.FontScaleY = C.FontScaleX;
		C.TextSize(GetStringOfZeroes(3), TextSizeX, TextSizeY);

		C.SetPos(TempX - (TextSizeX * 0.5f), TempY - (TextSizeY * 0.5f));
		DrawTextMeticulous(C, Eval(SecondaryAmmoHeader != "", SecondaryAmmoHeader, "ALT"), TextSizeX);

		//Draw Secondary Ammo amount.
		FlashlightString = FillStringWithZeroes(Min(int(CurrentSpareSecondaryAmmo),99), 2);
		
		C.FontScaleX = 1.f;
		C.FontScaleY = 1.f;
		C.Font = class'KFTurboFonts'.static.LoadLargeNumberFont(BaseFontSize + 3);
		C.TextSize(GetStringOfZeroes(3), TextSizeX, TextSizeY);
		TempY = BackplateCenterY + (BackplateTextSizeY * 0.3f);
		C.FontScaleX = BackplateTextSizeX / TextSizeX;
		C.FontScaleY = C.FontScaleX;
		C.TextSize(GetStringOfZeroes(Len(FlashlightString)), TextSizeX, TextSizeY);

		C.DrawColor = C.MakeColor(255, 255, 255, Max(Lerp(1.f - SecondaryAmmoFade, 220, 0), 0));

		C.SetPos(TempX - (TextSizeX * 0.5f), TempY - (TextSizeY * 0.5f));
		DrawCounterTextMeticulous(C, FlashlightString, TextSizeX, EmptyDigitOpacityMultiplier);
	}
}

simulated function DrawWeight(Canvas C, Vector2D LeftAnchor)
{
	local float BackplateSizeX, BackplateSizeY;
	local float BackplateTextSizeX, BackplateTextSizeY;
	local float BackplateCenterX, BackplateCenterY;
	local float WeightTextSpaceX;
	local float SpacingX;
	local float TempX, TempY;
	local float TextSizeX, TextSizeY;
	local string WeightString;

	SpacingX = C.ClipY * BackplateSpacing.X;
	BackplateSizeX = C.ClipY * WeightBackplateSize.X;
	BackplateSizeY = C.ClipY * WeightBackplateSize.Y;

	BackplateTextSizeX = C.ClipY * WeightBackplateTextArea.X;
	BackplateTextSizeY = C.ClipY * WeightBackplateTextArea.Y;

	TempX = LeftAnchor.X;
	TempY = LeftAnchor.Y;
	BackplateCenterX = TempX - (BackplateSizeX * 0.5f);
	BackplateCenterY = TempY - (BackplateSizeY * 0.5f);

	C.DrawColor = BackplateColor;

	C.SetPos(TempX - BackplateSizeX, TempY - BackplateSizeY);
	C.DrawTileStretched(RoundedContainer, BackplateSizeX, BackplateSizeY);
	
	C.DrawColor = C.MakeColor(255, 255, 255, 220);
	C.SetPos(BackplateCenterX - (BackplateTextSizeX * 0.5f), (BackplateCenterY - (BackplateTextSizeY * 0.4f)));
	C.DrawTileScaled(WeightIcon, (BackplateTextSizeY / float(WeightIcon.VSize)) * 0.8f, (BackplateTextSizeY / float(WeightIcon.USize)) * 0.8f);

	WeightTextSpaceX = BackplateTextSizeX - (BackplateTextSizeY * 0.8f);

	C.FontScaleX = 1.f;
	C.FontScaleY = 1.f;
	C.Font = class'KFTurboFonts'.static.LoadLargeNumberFont(BaseFontSize + 2);
	C.TextSize(GetStringOfZeroes(Len("00/00")), TextSizeX, TextSizeY);
	C.FontScaleX = WeightTextSpaceX / TextSizeX;
	C.FontScaleY = C.FontScaleX;

	WeightString = FillStringWithZeroes(Min(CurrentWeight,99), 2) $ "/" $ FillStringWithZeroes(Min(MaxCarryWeight,99), 2);
	C.TextSize(GetStringOfZeroes(Len(WeightString)), TextSizeX, TextSizeY);

	C.SetPos(BackplateCenterX + (BackplateTextSizeX * 0.5f) - (WeightTextSpaceX), BackplateCenterY - (TextSizeY * 0.5f));
	DrawTextMeticulous(C, WeightString, TextSizeX);
}

simulated function DrawCash(Canvas C)
{
	local float BackplateSizeX, BackplateSizeY;
	local float BackplateTextSizeX, BackplateTextSizeY;
	local float BackplateCenterX, BackplateCenterY;
	local float SpacingX;
	local float TempX, TempY;
	local float TextSizeX, TextSizeY;
	local string DrawString;
	local float TotalSizeX;

	SpacingX = C.ClipY * BackplateSpacing.Y;
	BackplateSizeX = C.ClipY * CashBackplateSize.X;
	BackplateSizeY = C.ClipY * CashBackplateSize.Y;
	BackplateTextSizeX = C.ClipY * CashBackplateTextArea.X;
	BackplateTextSizeY = C.ClipY * CashBackplateTextArea.Y;

	C.DrawColor = BackplateColor;
	C.SetPos(C.ClipX * 0.5f, C.ClipY * 0.5f);

	C.FontScaleX = 1.f;
	C.FontScaleY = 1.f;
	C.Font = class'KFTurboFonts'.static.LoadLargeNumberFont(BaseFontSize + 2);
	DrawString = Max(CurrentPlayerCash, TargetPlayerCash) @ "£";
	C.TextSize(GetStringOfZeroes(Len(DrawString)), TextSizeX, TextSizeY);
	C.FontScaleY = (BackplateTextSizeY / TextSizeY) * 1.25f;
	C.FontScaleX = C.FontScaleY;
	C.TextSize(GetStringOfZeroes(Len(DrawString)), TextSizeX, TextSizeY);

	DesiredCashBackplateX = TextSizeX;

	if (CurrentCashBackplateX < DesiredCashBackplateX)
	{
		CurrentCashBackplateX = DesiredCashBackplateX;
	}

	TotalSizeX = CurrentCashBackplateX + (BackplateSizeX - BackplateTextSizeX);

	DrawString = int(CurrentPlayerCash) @ "£";
	
	TempX = (C.ClipX - SpacingX) - TotalSizeX;
	TempY = (C.ClipY - (C.ClipY * BackplateSpacing.Y)) - BackplateSizeY;
	BackplateCenterX = TempX + (TotalSizeX * 0.5f);
	BackplateCenterY = TempY + (BackplateSizeY * 0.5f);
	
	C.SetPos(TempX, TempY);
	C.DrawTileStretched(RoundedContainer, TotalSizeX, BackplateSizeY);
	
	C.DrawColor = C.MakeColor(255, 255, 255, 220);
	C.TextSize(GetStringOfZeroes(Len(DrawString)), TextSizeX, TextSizeY);
	C.SetPos(((TempX + TotalSizeX) - ((BackplateSizeX - BackplateTextSizeX) * 0.5f)) - TextSizeX, BackplateCenterY - (TextSizeY * 0.5f));
	DrawCounterTextMeticulous(C, DrawString, TextSizeX, EmptyDigitOpacityMultiplier);

	if (CurrentPlayerCashReceive > 0.25f)
	{
		C.DrawColor = C.MakeColor(32, 255, 96, 255);
		C.FontScaleY = C.FontScaleY * Lerp(FMin(CurrentPlayerCashReceive / CurrentPlayerCashReceiveDivisor, 1.f), 0.25f, 0.75f);
		C.FontScaleY *= Lerp(FMin(CurrentPlayerCashReceiveDivisor / 1000.f, 1.f), 1.f, 2.f);
		C.FontScaleX = C.FontScaleY;
		C.DrawColor.A = 255.f * Lerp(FMin(CurrentPlayerCashReceive / CurrentPlayerCashReceiveDivisor, 1.f), 0.f, 1.f);

		DrawString = int(CurrentPlayerCashReceive) $ "+";
		C.TextSize(GetStringOfZeroes(Len(DrawString)), TextSizeX, TextSizeY);
		C.SetPos(TempX - TextSizeX, BackplateCenterY - (TextSizeY * 0.5f));
		DrawCounterTextMeticulous(C, DrawString, TextSizeX, EmptyDigitOpacityMultiplier);
		C.bCenter = false;
	}
}

simulated function DrawPerk(Canvas C)
{
	local float TopX, TopY, PerkX, PerkY;
	local float SizeX, SizeY;
	local int NumStars, Index, Counter;
	local Material PerkMaterial, PerkStarMaterial;
	local float PerkDrawSize, PerkStarSize;

	if (PlayerPerk == None)
	{
		return;
	}

	TopX = C.ClipY * (BackplateSpacing.Y + PerkProgressOffset.X);
	TopY = C.ClipY * ((1.f - BackplateSpacing.Y) + PerkProgressOffset.Y);
	SizeX = C.ClipY * PerkProgressSize.X;
	SizeY = C.ClipY * PerkProgressSize.Y;
	TopY -= SizeY;

	NumStars = PlayerPerk.Static.PreDrawPerk(C, PerkLevel, PerkMaterial, PerkStarMaterial);
	C.DrawColor.A = 240;
	PerkX = TopX + (SizeX * PerkIconOffset.X);
	PerkY = TopY + (SizeY * PerkIconOffset.Y);
	PerkDrawSize = SizeX * PerkDrawScale;
	PerkY -= PerkDrawSize;

	C.SetPos(PerkX, PerkY);
	C.DrawTile(PerkMaterial, PerkDrawSize, PerkDrawSize, 0, 0, PerkMaterial.MaterialUSize(), PerkMaterial.MaterialVSize());

	Counter = 0;
	PerkStarSize = PerkDrawSize * 0.15f;
	PerkX += ((PerkDrawSize) - (PerkStarSize * 1.5f));
	PerkY += (PerkDrawSize - (PerkStarSize * 0.5f)) * 0.75f;

	for ( Index = 0; Index < NumStars; Index++ )
	{
		C.SetPos(PerkX, PerkY - (float(Counter) * PerkDrawSize * 0.15f));
		C.DrawTile(PerkStarMaterial, PerkStarSize, PerkStarSize, 0, 0, PerkStarMaterial.MaterialUSize(), PerkStarMaterial.MaterialVSize());

		if( ++Counter==5 )
		{
			Counter = 0;
			PerkX += (PerkStarSize * 0.75);
		}
	}
	
	C.DrawColor.A = 255;
	class'TurboHUDPerkProgressDrawer'.static.DrawPerkProgress(C, TopX, TopY, SizeX, SizeY, PerkProgress, C.MakeColor(16,16,16,240), C.DrawColor);
}

defaultproperties
{
	BaseFontSize = 2

	BackplateColor=(R=0,G=0,B=0,A=140)

	HealthBackplateSize=(X=0.15f,Y=0.06f)
	HealthBackplateTextArea=(X=0.14f,Y=0.06f)

	AmmoBackplateSize=(X=0.1725f,Y=0.075f)
	AmmoBackplateTextArea=(X=0.16f,Y=0.075f)

	AlternateAmmoBackplateSize=(X=0.06f,Y=0.075f)
	AlternateAmmoBackplateTextArea=(X=0.045f,Y=0.065f)
	FlashlightPowerFadeRate=2.f
	SecondaryAmmoFadeRate=4.f
	SecondaryAmmoHeader="ALT"

	WeightBackplateSize=(X=0.1125f,Y=0.035f)
	WeightBackplateTextArea=(X=0.1f,Y=0.035f)

	CashBackplateSize=(X=0.2f,Y=0.045f)
	CashBackplateTextArea=(X=0.18f,Y=0.035f)

	PerkProgressSize=(X=0.075f,Y=0.075f)
	PerkProgressOffset=(X=-0.01f,Y=0.01f)
	PerkIconOffset=(X=0.275f,Y=0.41f)
	PerkProgressColor=(R=255,G=32,B=32,A=255)
	PerkDrawScale=1.f

	BackplateSpacing=(X=0.04f,Y=0.02f)

	EmptyDigitOpacityMultiplier = 0.5f

	RoundedContainer=Texture'KFTurbo.HUD.ContainerRounded_D'

	CurrentHealth=-1.f
	HealthInterpRate=8.f
	CurrentArmor=-1.f
	ArmorInterpRate=6.f
	CurrentSyringeCharge=-1.f
	SyringeInterpRate=4.f
	WelderInterpRate=2.f
	CashInterpRate=2.f
	ReceivedCashDecayDelay=2.f

	ReloadFadeRate=6.f
	OutOfAmmoFadeRate=3.f
	
	SyringeIcon=Texture'KFTurbo.Ammo.SyringeIcon_D'
	GrenadeIcon=Texture'KFTurbo.Ammo.NadeIcon_D'
	FlashlightIcon=Texture'KFTurbo.Ammo.BulbIcon_D'
	WeightIcon=Texture'KFTurbo.Ammo.WeightIcon_D'
}