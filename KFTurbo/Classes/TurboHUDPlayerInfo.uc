class TurboHUDPlayerInfo extends TurboHUDOverlay;

struct PlayerInfoHitData
{
	var float HitAmount;
	var float Ratio;
	var float FadeRate;
};

struct PlayerInfoData
{
	var KFPlayerReplicationInfo KFPRI;
	var KFHumanPawn HumanPawn;
	var float DistanceSquared;
	
	var float CurrentHealth;
	var float LastCheckedHealth;
	var float PreviousHealth;
	
	var float CurrentHealToHealth;
	var float PreviousHealToHealth;

	var float CurrentShield;
	var float PreviousShield;

	var PlayerInfoHitData LastHit;
	var bool bInitialized;
	var float VisibilityFade;
};

var array<PlayerInfoData> PlayerInfoDataList;

var() float HealthInterpRate;
var() float ShieldInterpRate;

var() color HealthBarColor;
var() color HealthLossBarColor;
var() color HealthHitBarColor;
var() color HealToHealthBarColor;

var() color ShieldBarColor;
var() color ShieldLossBarColor;

var() color BarBackplateColor;

var Texture PerkBackplate;

static final simulated function float GetHealth(out PlayerInfoData PlayerInfo)
{
	if (PlayerInfo.HumanPawn != None)
	{
		return float(PlayerInfo.HumanPawn.Health) / PlayerInfo.HumanPawn.HealthMax;
	}

	if (PlayerInfo.KFPRI != None)
	{
		//A dead player is 100% alive! (So that no weird hit anim is played on client).
		if (PlayerInfo.KFPRI.PlayerHealth <= 0.f)
		{
			return 1.f;
		}

		return float(PlayerInfo.KFPRI.PlayerHealth) / 100.f;
	}

	return 1.f;
}

static final simulated function float GetHealthHealingTo(out PlayerInfoData PlayerInfo)
{
	local TurboHumanPawn TurboHumanPawn;
	TurboHumanPawn = TurboHumanPawn(PlayerInfo.HumanPawn);
	if (TurboHumanPawn != None)
	{
		if (TurboHumanPawn.HealthHealingTo == -1)
		{
			return -1.f;
		}

		return float(TurboHumanPawn.HealthHealingTo) / 100.f;
	}

	return 0.f;
}

static final simulated function float GetShield(out PlayerInfoData PlayerInfo)
{
	if (PlayerInfo.HumanPawn != None)
	{
		return PlayerInfo.HumanPawn.ShieldStrength / 100.f;
	}

	return 0.f;
}

simulated function TickPlayerInfo(float DeltaTime, out PlayerInfoData PlayerInfo)
{
	local float Value;
	Value = GetHealth(PlayerInfo);
	PlayerInfo.CurrentHealth = Value;
	Value = GetShield(PlayerInfo);
	PlayerInfo.CurrentShield = Value;
	Value = GetHealthHealingTo(PlayerInfo);
	PlayerInfo.CurrentHealToHealth = Value;

	PlayerInfo.VisibilityFade = FMax(PlayerInfo.VisibilityFade - DeltaTime, 0.f);

	if (!PlayerInfo.bInitialized)
	{
		PlayerInfo.LastCheckedHealth = PlayerInfo.CurrentHealth;
		PlayerInfo.PreviousHealth = PlayerInfo.CurrentHealth;
		PlayerInfo.PreviousShield = PlayerInfo.CurrentShield;
		PlayerInfo.PreviousHealToHealth = PlayerInfo.CurrentHealToHealth;
		PlayerInfo.LastHit.Ratio = 1.f; //Mark as done playing.
		PlayerInfo.bInitialized = true;
		return;
	}

	if (PlayerInfo.LastHit.Ratio < 1.f)
	{
		PlayerInfo.LastHit.Ratio += PlayerInfo.LastHit.FadeRate * DeltaTime;
		PlayerInfo.LastHit.Ratio = FMin(PlayerInfo.LastHit.Ratio, 1.f);
	}

	if (PlayerInfo.CurrentHealth != PlayerInfo.LastCheckedHealth)
	{
		if (PlayerInfo.CurrentHealth < PlayerInfo.LastCheckedHealth)
		{
			InitializeHitData(PlayerInfo);
		}
		PlayerInfo.LastCheckedHealth = PlayerInfo.CurrentHealth;
	}

	if (PlayerInfo.CurrentHealth < PlayerInfo.PreviousHealth)
	{
		PlayerInfo.PreviousHealth = Lerp(default.HealthInterpRate * DeltaTime, PlayerInfo.PreviousHealth, PlayerInfo.CurrentHealth);

		if (Abs(PlayerInfo.PreviousHealth - PlayerInfo.CurrentHealth) < 0.01f)
		{
			PlayerInfo.PreviousHealth = PlayerInfo.CurrentHealth;
		}
	}
	else if (PlayerInfo.CurrentHealth > PlayerInfo.PreviousHealth)
	{
		PlayerInfo.PreviousHealth = PlayerInfo.CurrentHealth;
	}

	if (PlayerInfo.CurrentHealToHealth <= 0.f)
	{
		PlayerInfo.PreviousHealToHealth = PlayerInfo.CurrentHealToHealth;
	}
	else if (PlayerInfo.CurrentHealToHealth != PlayerInfo.PreviousHealToHealth)
	{
		PlayerInfo.PreviousHealToHealth = Lerp(default.HealthInterpRate * 4.f * DeltaTime, FMax(PlayerInfo.PreviousHealToHealth, PlayerInfo.CurrentHealth), PlayerInfo.CurrentHealToHealth);

		if (Abs(PlayerInfo.PreviousHealToHealth - PlayerInfo.CurrentHealToHealth) < 0.01f)
		{
			PlayerInfo.PreviousHealToHealth = PlayerInfo.CurrentHealToHealth;
		}
	}

	if (PlayerInfo.CurrentShield < PlayerInfo.PreviousShield)
	{
		PlayerInfo.PreviousShield = Lerp(default.ShieldInterpRate * DeltaTime, PlayerInfo.PreviousShield, PlayerInfo.CurrentShield);

		if (Abs(PlayerInfo.PreviousShield - PlayerInfo.CurrentShield) < 0.01f)
		{
			PlayerInfo.PreviousShield = PlayerInfo.CurrentShield;
		}
	}
	else if (PlayerInfo.CurrentShield > PlayerInfo.PreviousShield)
	{
		PlayerInfo.PreviousShield = PlayerInfo.CurrentShield;
	}
}

simulated function InitializeHitData(out PlayerInfoData PlayerInfo)
{
	local float NewLostHealth;
	NewLostHealth = PlayerInfo.PreviousHealth - PlayerInfo.CurrentHealth;
	if ( PlayerInfo.LastHit.Ratio >= 1.f )
	{
		PlayerInfo.LastHit.HitAmount = NewLostHealth;
		PlayerInfo.LastHit.FadeRate = Lerp(FMin(NewLostHealth / 0.5f, 1.f), 4.f, 1.f);
		PlayerInfo.LastHit.Ratio = 0.f;
		return;
	}
	
	if (NewLostHealth < PlayerInfo.LastHit.HitAmount * 0.5f && PlayerInfo.LastHit.Ratio < 0.75f)
	{
		return;
	}

	PlayerInfo.LastHit.HitAmount = NewLostHealth;
	PlayerInfo.LastHit.FadeRate = Lerp(FMin(NewLostHealth / 0.5f, 1.f), 4.f, 1.f);
	PlayerInfo.LastHit.Ratio = 0.f;
}

simulated function Tick(float DeltaTime)
{
	local int Index, PlayerInfoIndex;
	local PlayerReplicationInfo PRI;
	local bool bFoundData;
	local PlayerInfoData PlayerInfo;
	local KFHumanPawn HumanPawn;
	local array<PlayerInfoData> SortedPlayerInfoList;

	if (KFPHUD.Level.GRI == None || !KFPHUD.Level.GRI.bMatchHasBegun)
	{
		return;
	}
	
	for (PlayerInfoIndex = PlayerInfoDataList.Length - 1; PlayerInfoIndex >= 0; PlayerInfoIndex--)
	{
		PRI = PlayerInfoDataList[PlayerInfoIndex].KFPRI;

		if (PRI == None || PRI.bOnlySpectator || PRI.bIsSpectator )
		{
			PlayerInfoDataList.Remove(PlayerInfoIndex, 1);
			continue;
		}
	}
	
	foreach KFPHUD.CollidingActors(Class'KFHumanPawn', HumanPawn, KFPHUD.HealthBarCutoffDist, KFPHUD.PlayerOwner.CalcViewLocation)
	{
		PRI = HumanPawn.PlayerReplicationInfo;

		if (PRI == None || KFPHUD.PlayerOwner.PlayerReplicationInfo == PRI)
		{
			continue;
		}

		HumanPawn.bNoTeamBeacon = true;

		bFoundData = false;
		for (PlayerInfoIndex = PlayerInfoDataList.Length - 1; PlayerInfoIndex >= 0; PlayerInfoIndex--)
		{
			if (PlayerInfoDataList[PlayerInfoIndex].KFPRI == PRI)
			{
				PlayerInfoDataList[PlayerInfoIndex].DistanceSquared = VSizeSquared(KFPHUD.PlayerOwner.CalcViewLocation - HumanPawn.Location);
				PlayerInfoDataList[PlayerInfoIndex].HumanPawn = HumanPawn;
				bFoundData = true;
				break;
			}
		}

		if (bFoundData)
		{
			continue;
		}

		PlayerInfoIndex = PlayerInfoDataList.Length;
		PlayerInfoDataList.Insert(PlayerInfoIndex, 1);
		PlayerInfoDataList[PlayerInfoIndex].KFPRI = KFPlayerReplicationInfo(PRI);
		PlayerInfoDataList[PlayerInfoIndex].HumanPawn = HumanPawn;
		PlayerInfoDataList[PlayerInfoIndex].DistanceSquared = VSizeSquared(KFPHUD.PlayerOwner.CalcViewLocation - HumanPawn.Location);
		PlayerInfoDataList[PlayerInfoIndex].bInitialized = false;
	}

	//Sort entries.
	for (PlayerInfoIndex = PlayerInfoDataList.Length - 1; PlayerInfoIndex >= 0; PlayerInfoIndex--)
	{
		bFoundData = false;
		for (Index = 0; Index < SortedPlayerInfoList.Length; Index++)
		{
			if (SortedPlayerInfoList[Index].DistanceSquared < PlayerInfoDataList[PlayerInfoIndex].DistanceSquared)
			{
				continue;
			}

			bFoundData = true;
			SortedPlayerInfoList.Insert(Index, 1);
			SortedPlayerInfoList[Index] = PlayerInfoDataList[PlayerInfoIndex];
			break;
		}

		if (bFoundData)
		{
			continue;
		}

		SortedPlayerInfoList[SortedPlayerInfoList.Length] = PlayerInfoDataList[PlayerInfoIndex];
	}

	PlayerInfoDataList = SortedPlayerInfoList;

	//Tick entries.
	for (PlayerInfoIndex = PlayerInfoDataList.Length - 1; PlayerInfoIndex >= 0; PlayerInfoIndex--)
	{
		if (PlayerInfoDataList[PlayerInfoIndex].KFPRI == None)
		{
			PlayerInfoDataList.Remove(PlayerInfoIndex, 1);
			continue;
		}
		
		PlayerInfo = PlayerInfoDataList[PlayerInfoIndex];
		TickPlayerInfo(DeltaTime, PlayerInfo);
		PlayerInfoDataList[PlayerInfoIndex] = PlayerInfo;
	}
}

static final simulated function bool ShouldDrawPlayerInfo(vector CameraPosition, vector CameraDirection, out PlayerInfoData PlayerInfo)
{
	if (PlayerInfo.KFPRI == None || PlayerInfo.HumanPawn == None)
	{
		return false;
	}
		
	if (PlayerInfo.HumanPawn.FastTrace(PlayerInfo.HumanPawn.Location, CameraPosition))
	{
		PlayerInfo.VisibilityFade = 1.f;
	}

	if (PlayerInfo.CurrentHealth <= 0)
	{
		return false;
	}

	if ((Normal(PlayerInfo.HumanPawn.Location - CameraPosition) Dot CameraDirection) > 0.f )
	{
		return false;
	}
	
	return true;
}

simulated function Render(Canvas C)
{
	local int Index;
	local vector CamPos, ViewDir, ScreenPos;
	local rotator CamRot;
	local KFHumanPawn HumanPawn;

	if (KFPHUD == None || KFPHUD.Level.GRI == None)
	{
		return;
	}

	Super.Render(C);

	// Grab our View Direction
	C.GetCameraLocation(CamPos,CamRot);
	ViewDir = vector(CamRot);

	for (Index = PlayerInfoDataList.Length - 1; Index >= 0; Index--)
	{
		HumanPawn = PlayerInfoDataList[Index].HumanPawn;

		if (HumanPawn == None)
		{
			continue;
		}

		if (!ShouldDrawPlayerInfo(CamPos, ViewDir, PlayerInfoDataList[Index]))
		{
			continue;
		}

		if (PlayerInfoDataList[Index].VisibilityFade <= 0.f)
		{
			continue;
		}

		if (HumanPawn.Health <= 0.f)
		{
			continue;
		}

		ScreenPos = C.WorldToScreen(HumanPawn.Location + (vect(0,0,1) * HumanPawn.CollisionHeight));
		
		if( ScreenPos.X>=0 && ScreenPos.Y>=0 && ScreenPos.X<=C.ClipX && ScreenPos.Y<=C.ClipY )
		{
			DrawPlayerInfo(C, PlayerInfoDataList[Index], ScreenPos.X, ScreenPos.Y);
		}
	}
}

function DrawPlayerInfo(Canvas C, out PlayerInfoData PlayerInfo, float ScreenLocX, float ScreenLocY)
{
	local float XL, YL, TempX, TempY, TempSize, TempStartSize;
	local float Dist, OffsetX;
	local byte BeaconAlpha,Counter;
	local float OldZ;
	local Material TempMaterial, TempStarMaterial;
	local byte i, TempLevel;
	local bool bDrawLostHealth;
	local bool bDrawLostShield;
	local float LastHitScale;
	local float LastHitAlpha;

	if ( PlayerInfo.KFPRI.bViewingMatineeCinematic  )
	{
		return;
	}

	Dist = vsize(PlayerInfo.HumanPawn.Location - KFPHUD.PlayerOwner.CalcViewLocation);
	Dist -= KFPHUD.HealthBarFullVisDist;
	Dist = FClamp(Dist, 0, KFPHUD.HealthBarCutoffDist-KFPHUD.HealthBarFullVisDist);
	Dist = Dist / (KFPHUD.HealthBarCutoffDist - KFPHUD.HealthBarFullVisDist);
	BeaconAlpha = byte((1.f - Dist) * 255.f);
	BeaconAlpha = byte(255.f * FMin(PlayerInfo.VisibilityFade * 2.f, 1.f));

	if ( BeaconAlpha == 0 )
	{
		return;
	}

	OldZ = C.Z;
	C.Z = 1.0;
	C.Style = KFPHUD.ERenderStyle.STY_Alpha;

	OffsetX = KFPHUD.BarLength * 0.5f;

	C.Font = KFPHUD.GetConsoleFont(C);
	Class'SRScoreBoard'.Static.TextSizeCountry(C, PlayerInfo.KFPRI, XL, YL);
	TempX = ScreenLocX - (XL * 0.5);
	TempY = ScreenLocY - (YL * 1.f);
	TempX = int(TempX);
	TempY = int(TempY);
	ScreenLocY -= YL * 1.25f;

	ScreenLocX = int(ScreenLocX);
	ScreenLocY = int(ScreenLocY);

	if ( Class<SRVeterancyTypes>(PlayerInfo.KFPRI.ClientVeteranSkill)!=none && PlayerInfo.KFPRI.ClientVeteranSkill.default.OnHUDIcon!=none )
	{
		TempSize = 48.f * KFPHUD.VeterancyMatScaleFactor;

		TempX = ScreenLocX + (KFPHUD.BarLength * 0.5f);
		TempX = TempX - (TempSize * 0.15);
		TempY = (ScreenLocY - (TempSize * 0.5f));
		
		C.SetPos(TempX - (TempSize * 0.125f), TempY - (TempSize * 0.125f));
		C.DrawColor = BarBackplateColor;
		C.DrawColor.A = int(float(BeaconAlpha) * 0.5f);
		C.DrawTile(PerkBackplate, TempSize * 1.25f, TempSize * 1.25f, 0, 0, PerkBackplate.MaterialUSize(), PerkBackplate.MaterialVSize());

		C.SetPos(TempX, TempY);
		TempLevel = Class<SRVeterancyTypes>(PlayerInfo.KFPRI.ClientVeteranSkill).Static.PreDrawPerk(C, PlayerInfo.KFPRI.ClientVeteranSkillLevel, TempMaterial, TempStarMaterial);
		C.DrawColor.A = BeaconAlpha;
		C.DrawTile(TempMaterial, TempSize, TempSize, 0, 0, TempMaterial.MaterialUSize(), TempMaterial.MaterialVSize());

		TempStartSize = TempSize * 0.175f;

		TempX += (TempSize * 0.8f);
		TempY += (TempSize - (TempStartSize * 1.5f));

		for ( i = 0; i < TempLevel; i++ )
		{
			C.SetPos(TempX, TempY - (Counter * TempStartSize));
			C.DrawTile(TempStarMaterial, TempStartSize, TempStartSize, 0, 0, TempStarMaterial.MaterialUSize(), TempStarMaterial.MaterialVSize());

			if( ++Counter==5 )
			{
				Counter = 0;
				TempX+=KFPHUD.VetStarSize;
			}
		}
	}

	TempX = ScreenLocX - (XL * 0.5);
	TempY = ScreenLocY + (KFPHUD.BarHeight * 0.5f) - (YL * 0.125f);
	TempX = int(TempX);
	TempY = int(TempY);
	C.SetDrawColor(0, 0, 0, byte(0.75f * float(BeaconAlpha)));
	Class'SRScoreBoard'.Static.DrawCountryName(C, PlayerInfo.KFPRI, TempX + 2.f, TempY + 2.f);
	C.SetDrawColor(255, 255, 255, BeaconAlpha);
	Class'SRScoreBoard'.Static.DrawCountryName(C, PlayerInfo.KFPRI, TempX, TempY);

	TempX = ScreenLocX - (XL * 0.5);
	TempY = ScreenLocY + (KFPHUD.BarHeight * 0.5f);
	TempX = int(TempX);
	TempY = int(TempY);

	// Health
	bDrawLostHealth = PlayerInfo.PreviousHealth > PlayerInfo.CurrentHealth;
	DrawBackplate(C, ScreenLocX, ScreenLocY, BeaconAlpha, 1.f);

	if (PlayerInfo.PreviousHealToHealth > 0.f && PlayerInfo.PreviousHealToHealth > PlayerInfo.CurrentHealth)
	{
		HealToHealthBarColor.A = byte(float(default.HealToHealthBarColor.A) * (float(BeaconAlpha) / 255.f));
		DrawBar(C, ScreenLocX + FMax((KFPHUD.BarLength * (PlayerInfo.CurrentHealth - 0.01f)), 0.f), ScreenLocY, FClamp((PlayerInfo.PreviousHealToHealth - PlayerInfo.CurrentHealth) + 0.01f, 0, 1), HealToHealthBarColor, 1.f);
	}

	if (bDrawLostHealth)
	{
		HealthLossBarColor.A = byte(float(default.HealthLossBarColor.A) * (float(BeaconAlpha) / 255.f));
		DrawBar(C, ScreenLocX + FMax((KFPHUD.BarLength * (PlayerInfo.CurrentHealth - 0.01f)), 0.f), ScreenLocY, FClamp((PlayerInfo.PreviousHealth - PlayerInfo.CurrentHealth) + 0.01f, 0, 1), HealthLossBarColor, 1.f);
	}

	if ( PlayerInfo.CurrentHealth > 0.f )
	{
		HealthBarColor.A = byte(float(default.HealthBarColor.A) * (float(BeaconAlpha) / 255.f));
		DrawBar(C, ScreenLocX, ScreenLocY, FClamp(PlayerInfo.CurrentHealth, 0, 1), HealthBarColor, 1.f);
	}
		
	// Armor
	if (PlayerInfo.PreviousShield > 0.f || PlayerInfo.CurrentShield > 0.f)
	{
		bDrawLostShield = PlayerInfo.PreviousShield > PlayerInfo.CurrentShield;
		DrawBackplate(C, ScreenLocX, ScreenLocY - (KFPHUD.BarHeight + 2.f), BeaconAlpha, 0.5f);
		if (bDrawLostShield)
		{
			ShieldLossBarColor.A = byte(float(default.ShieldLossBarColor.A) * (float(BeaconAlpha) / 255.f));
			DrawBar(C, ScreenLocX + FMax((KFPHUD.BarLength * (PlayerInfo.CurrentShield - 0.01f)), 0.f), ScreenLocY - (KFPHUD.BarHeight + 2.f), FClamp((PlayerInfo.PreviousShield - PlayerInfo.CurrentShield) + 0.01f, 0, 1), ShieldLossBarColor, 0.5f);
		}
		
		if ( PlayerInfo.CurrentShield > 0.f )
		{
			ShieldBarColor.A = byte(float(default.ShieldBarColor.A) * (float(BeaconAlpha) / 255.f));
			DrawBar(C, ScreenLocX, ScreenLocY - (KFPHUD.BarHeight + 2.f), FClamp(PlayerInfo.CurrentShield, 0, 1), ShieldBarColor, 0.5f);
		}
	}

	if ( PlayerInfo.LastHit.Ratio < 1.f)
	{
		LastHitScale = 1.f - ((PlayerInfo.LastHit.Ratio - 1.f) ** 4.f);
		LastHitAlpha = 1.f - (((2.f * PlayerInfo.LastHit.Ratio) - 1.f) ** 4.f);
		LastHitAlpha *= (float(BeaconAlpha) / 255.f);
		LastHitAlpha *= (float(HealthHitBarColor.A) / 255.f);
		
		C.DrawColor = HealthHitBarColor;
		C.DrawColor.A = (LastHitAlpha * 255.f);
		C.SetPos((ScreenLocX - (0.5 * KFPHUD.BarLength)) + (KFPHUD.BarLength * FClamp(PlayerInfo.CurrentHealth, 0, 1)), (ScreenLocY - (KFPHUD.BarHeight * 0.5f)) - (0.25f * KFPHUD.BarHeight * (LastHitScale * 1.f)));
		C.DrawTileStretched(KFPHUD.WhiteMaterial, (KFPHUD.BarLength * PlayerInfo.LastHit.HitAmount * 1.1f) + ((KFPHUD.BarLength * 0.05f) / PlayerInfo.LastHit.FadeRate), KFPHUD.BarHeight * (1.f + (LastHitScale * 0.5f)));
	}

	C.Z = OldZ;
}

simulated function DrawBackplate(Canvas C, float XCentre, float YCentre, byte Alpha, float HeightScale)
{
	BarBackplateColor.A = int(float(default.BarBackplateColor.A) * (float(Alpha) / 255.f));
	C.DrawColor = BarBackplateColor;
	C.SetPos(XCentre - 0.5 * KFPHUD.BarLength, YCentre - (0.5 * KFPHUD.BarHeight * HeightScale));
	C.DrawTileStretched(KFPHUD.WhiteMaterial, KFPHUD.BarLength, KFPHUD.BarHeight * HeightScale);
}

simulated function DrawBar(Canvas C, float XCentre, float YCentre, float BarPercentage, color Color, float HeightScale)
{
	C.DrawColor = Color;
	C.SetPos(XCentre - 0.5 * KFPHUD.BarLength, YCentre - (0.5 * KFPHUD.BarHeight * HeightScale));
	C.DrawTileStretched(KFPHUD.WhiteMaterial, KFPHUD.BarLength * BarPercentage, KFPHUD.BarHeight * HeightScale);
}

defaultproperties
{
	PerkBackplate=Texture'KFTurbo.HUD.PerkBackplate_D'

	HealthInterpRate=1.f;
	ShieldInterpRate=2.f;

	HealthBarColor=(R=232,G=41,B=41,A=255)
	HealthLossBarColor=(R=222,G=171,B=47,A=255)
	HealthHitBarColor=(R=222,G=171,B=47,A=215)
	HealToHealthBarColor=(R=44,G=255,B=24,A=120)

	ShieldBarColor=(R=27,G=181,B=213,A=255)
	ShieldLossBarColor=(R=50,G=140,B=180,A=200)

	BarBackplateColor=(R=16,G=16,B=16,A=255)
}