class TurboHUDPlayer extends TurboHUDOverlay;

var int BaseFontSize;

//These sizes are based on % of monitor Y size.
var(Layout) Vector2D HealthBackplateSize;
var(Layout) Vector2D AmmoBackplateSize;

//Space for text centered around the above backplate sizes (so that there can be a margin at the edges of the backplate)
var(Layout) Vector2D HealthBackplateTextArea;
var(Layout) Vector2D AmmoBackplateTextArea;

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
var Texture WelderIcon;

var float CurrentLoadedAmmo;
var float CurrentSpareAmmo;

var bool bIsMeleeGun;
var bool bIsWelderOrSyringe;
var bool bIsSingleShotWeapon;

var bool bIsReloading;
var float ReloadFade;
var float ReloadFadeRate;

var bool bIsOutOfAmmo;
var float OutOfAmmoFade;
var float OutOfAmmoFadeRate;

simulated function Tick(float DeltaTime)
{

	if (KFPHUD == None || KFPHUD.PawnOwner == None || KFPHUD.PawnOwner.Health <= 0)
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
		return;
	}

	FindSyringe();
	FindWelder();
	FindGrenade();

	CurrentHealth = Lerp(HealthInterpRate * DeltaTime, CurrentHealth, float(KFPHUD.PawnOwner.Health));
	if (Abs(CurrentHealth - float(KFPHUD.PawnOwner.Health)) < 0.1)
	{
		CurrentHealth = float(KFPHUD.PawnOwner.Health);
	}

	CurrentArmor = Lerp(ArmorInterpRate * DeltaTime, CurrentArmor, KFPHUD.PawnOwner.ShieldStrength);
	if (Abs(CurrentArmor - KFPHUD.PawnOwner.ShieldStrength) < 0.1)
	{
		CurrentArmor = KFPHUD.PawnOwner.ShieldStrength;
	}

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
		WeaponUpdate(KFWeapon(KFPHUD.PawnOwner.Weapon));
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

simulated function WeaponUpdate(KFWeapon Weapon)
{
	bIsReloading = Weapon.bIsReloading;

	bIsMeleeGun = KFMeleeGun(KFPHUD.PawnOwner.Weapon) != None;
	bIsWelderOrSyringe = (KFPHUD.PawnOwner.Weapon == CurrentWelder) || (KFPHUD.PawnOwner.Weapon == CurrentSyringe);

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

	bIsSingleShotWeapon = Weapon.MagCapacity == 1;

	if (bIsSingleShotWeapon)
	{
		Weapon.GetAmmoCount(CurrentSpareAmmo, CurrentLoadedAmmo);
		CurrentSpareAmmo = 0;
		bIsOutOfAmmo = CurrentLoadedAmmo <= 0;
		return;
	}

	Weapon.GetAmmoCount(CurrentLoadedAmmo, CurrentSpareAmmo);
	CurrentLoadedAmmo = Weapon.MagAmmoRemaining;
	bIsOutOfAmmo = (CurrentSpareAmmo - CurrentLoadedAmmo) <= 0;
}

simulated function Render(Canvas C)
{
	local Vector2D BackplateACenter, BackplateBCenter;

	Super.Render(C);

	if (KFPHUD.PawnOwner == None || KFPHUD.PawnOwner.Health <= 0)
	{
		return;
	}

	DrawBackplates(C, BackplateACenter, BackplateBCenter);
	DrawHealthText(C, BackplateACenter);
	DrawAmmoText(C, BackplateBCenter);
}

simulated function DrawBackplates(Canvas C, out Vector2D BackplateACenter, out Vector2D BackplateBCenter)
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
	
	TempX = CenterX + (C.ClipY * BackplateSpacing.X);
	TopY = C.ClipY * (1.f - (BackplateSpacing.Y + AmmoBackplateSize.Y));
	TempY = TopY;

	C.SetPos(TempX, TempY);
	BackplateBCenter.X = TempX + (C.ClipY * AmmoBackplateSize.X * 0.5f);
	BackplateBCenter.Y = TempY + (C.ClipY * AmmoBackplateSize.Y * 0.5f);

	C.DrawTileStretched(RoundedContainer, C.ClipY * AmmoBackplateSize.X, C.ClipY * AmmoBackplateSize.Y);
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

	C.SetPos(((BackplateACenter.X - (BackplateSizeX * 0.49f)) + (ArmorSizeX * 0.5f)) - (TextSizeX * 0.5f), (BackplateACenter.Y + (BackplateSizeY * 0.485f)) - TextSizeY);

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

	C.SetPos(BackplateACenter.X - ((BackplateSizeX * 0.275f) + (TextSizeX * 0.5f)), (BackplateACenter.Y - (BackplateSizeY * 0.23f)) - (TextSizeY * 0.5f));

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

	C.SetPos(BackplateACenter.X - ((BackplateSizeX * 0.5f)), (BackplateACenter.Y - (BackplateSizeY * 0.235f)) - (TextSizeY * 0.4f));
	C.DrawTileScaled(SyringeIcon, (TextSizeY / float(SyringeIcon.VSize)) * 0.8f, (TextSizeY / float(SyringeIcon.VSize)) * 0.8f);
}


simulated function DrawAmmoText(Canvas C, Vector2D BackplateACenter)
{
	local float BackplateSizeX, BackplateSizeY;
	local float LoadedAmmoSizeX, SpareAmmoSizeX;
	local float DefaultTextSizeX, DefaultTextSizeY, LoadedAmmoSizeY;
	local float TextSizeX, TextSizeY, TextScale;
	local string CurrentLoadedAmmoString, CurrentSpareAmmoString, CurrentGrenadeCountString;

	BackplateSizeX = AmmoBackplateTextArea.X * C.ClipY;
	BackplateSizeY = AmmoBackplateTextArea.Y * C.ClipY;
	LoadedAmmoSizeX = BackplateSizeX * 0.5f;

	C.SetPos(BackplateACenter.X - (BackplateSizeX * 0.5f), BackplateACenter.Y - (BackplateSizeY * 0.5f));
	
	//Get how big this font is in general for 3 digit numbers.
	C.FontScaleX = 1.f;
	C.FontScaleY = 1.f;
	C.Font = class'KFTurboFonts'.static.LoadLargeNumberFont(BaseFontSize);
	C.TextSize(GetStringOfZeroes(3), DefaultTextSizeX, DefaultTextSizeY);

	//Loaded Ammo
	CurrentLoadedAmmoString = GetLoadedAmmoString();

	TextScale = (BackplateSizeY / DefaultTextSizeY) * 1.25f;
	C.FontScaleX = TextScale;
	C.FontScaleY = TextScale;
	C.TextSize(GetStringOfZeroes(Len(CurrentLoadedAmmoString)), TextSizeX, TextSizeY);

	C.SetPos(BackplateACenter.X - (BackplateSizeX * 0.5f), BackplateACenter.Y - (TextSizeY * 0.515f));

	C.DrawColor = C.MakeColor(255, 255, 255, Lerp(ReloadFade, 220, 120));

	if (bIsSingleShotWeapon)
	{
		C.DrawColor.G = Lerp(OutOfAmmoFade, 255, 120);
		C.DrawColor.B = Lerp(OutOfAmmoFade, 255, 120);
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

	C.SetPos(BackplateACenter.X + ((BackplateSizeX * 0.485f) - (TextSizeX)), (BackplateACenter.Y + (BackplateSizeY * 0.19f)) - (TextSizeY * 0.5f));

	C.DrawColor = C.MakeColor(255, 255, 255, 220);

	if (!bIsSingleShotWeapon && (!bIsMeleeGun || bIsWelderOrSyringe))
	{
		C.DrawColor.G = Lerp(OutOfAmmoFade, 255, 120);
		C.DrawColor.B = Lerp(OutOfAmmoFade, 255, 120);
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

	C.SetPos(BackplateACenter.X + (BackplateSizeX * 0.51f) - TextSizeY, (BackplateACenter.Y - (BackplateSizeY * 0.24f)) - (TextSizeY * 0.4f));
	C.DrawTileScaled(GrenadeIcon, (TextSizeY / float(SyringeIcon.VSize)) * 0.8f, (TextSizeY / float(SyringeIcon.USize)) * 0.8f);

	C.SetPos((BackplateACenter.X + (BackplateSizeX * 0.5f) - TextSizeY) - TextSizeX, (BackplateACenter.Y - (BackplateSizeY * 0.24f)) - (TextSizeY * 0.5f));
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
		if (bIsWelderOrSyringe)
		{
			return "00";
		}

		return "000";
	}

	if (bIsSingleShotWeapon)
	{
		return "00";
	}

	
	return FillStringWithZeroes(Min(CurrentSpareAmmo - CurrentLoadedAmmo, 999), 3);
}

defaultproperties
{
	BaseFontSize = 2

	BackplateColor=(R=0,G=0,B=0,A=140)
	HealthBackplateSize=(X=0.215f,Y=0.08f)
	HealthBackplateTextArea=(X=0.205f,Y=0.08f)

	AmmoBackplateSize=(X=0.22f,Y=0.1f)
	AmmoBackplateTextArea=(X=0.21f,Y=0.1f)

	BackplateSpacing=(X=0.04f,Y=0.02f)

	EmptyDigitOpacityMultiplier = 0.5f

	RoundedContainer=Texture'KFTurbo.HUD.ContainerRounded_D'

	CurrentHealth=-1.f
	HealthInterpRate=8.f
	CurrentArmor=-1.f
	ArmorInterpRate=4.f
	CurrentSyringeCharge=-1.f
	SyringeInterpRate=4.f
	WelderInterpRate=2.f

	ReloadFadeRate=6.f
	OutOfAmmoFadeRate=3.f
	
	SyringeIcon=Texture'KFTurbo.Ammo.SyringeIcon_D'
	GrenadeIcon=Texture'KFTurbo.Ammo.NadeIcon_D'
}