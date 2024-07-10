class KFPHUDPlayerInfo extends KFPHUDObject;

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
	
	var float CurrentHealth;
	var float LastCheckedHealth;
	var float PreviousHealth;
	
	var float CurrentShield;
	var float PreviousShield;

	var PlayerInfoHitData LastHit;
	var bool bInitialized;
};

var array<PlayerInfoData> PlayerInfoDataList;

var() float HealthInterpRate;
var() float ShieldInterpRate;

var() color HealthBarColor;
var() color HealthLossBarColor;
var() color HealthHitBarColor;

var() color ShieldBarColor;
var() color ShieldLossBarColor;

var() color BarBackplateColor;

static final simulated function float GetHealth(out PlayerInfoData PlayerInfo)
{
	if (PlayerInfo.HumanPawn != None)
	{
		return float(PlayerInfo.HumanPawn.Health) / PlayerInfo.HumanPawn.HealthMax;
	}

	if (PlayerInfo.KFPRI != None)
	{
		return float(PlayerInfo.KFPRI.PlayerHealth) / 100.f;
	}

	return 1.f;
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

	if (!PlayerInfo.bInitialized)
	{
		PlayerInfo.LastCheckedHealth = PlayerInfo.CurrentHealth;
		PlayerInfo.PreviousHealth = PlayerInfo.CurrentHealth;
		PlayerInfo.PreviousShield = PlayerInfo.CurrentShield;
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
			PlayerInfo.CurrentHealth = PlayerInfo.PreviousHealth;
		}
	}
	else if (PlayerInfo.CurrentHealth > PlayerInfo.PreviousHealth)
	{
		PlayerInfo.PreviousHealth = PlayerInfo.CurrentHealth;
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
		PlayerInfo.LastHit.FadeRate = Lerp(FMin(NewLostHealth / 0.3f, 1.f), 6.f, 2.f);
		PlayerInfo.LastHit.Ratio = 0.f;
		return;
	}
	
	if (NewLostHealth < PlayerInfo.LastHit.HitAmount * 0.5f && PlayerInfo.LastHit.Ratio < 0.75f)
	{
		return;
	}

	PlayerInfo.LastHit.HitAmount = NewLostHealth;
	PlayerInfo.LastHit.FadeRate = Lerp(FMin(NewLostHealth / 0.3f, 1.f), 6.f, 2.f);
	PlayerInfo.LastHit.Ratio = 0.f;
}

simulated function Tick(float DeltaTime)
{
	local int Index;
	local array<PlayerReplicationInfo> PRIArray;
	local PlayerReplicationInfo PRI;
	local bool bFoundPRI;
	local KFHumanPawn HumanPawn;
	local PlayerInfoData PlayerInfo;
	PRIArray = Level.GRI.PRIArray;

	if (!Level.GRI.bMatchHasBegun)
	{
		return;
	}
	
	for (Index = PRIArray.Length - 1; Index >= 0; Index--)
	{
		PRI = PRIArray[Index];

		if ( PRI.bOnlySpectator )
		{
			PRIArray.Remove(Index, 1);
			continue;
		}

		if ( PRI.bOutOfLives || KFPlayerReplicationInfo(PRI).PlayerHealth <= 0)
		{
			PRIArray.Remove(Index, 1);
			continue;
		}
	}

	//Look for new PRIs to track.
	for (Index = PRIArray.Length - 1; Index >= 0; Index--)
	{
		PRI = PRIArray[Index];
		if (PRI == None)
		{
			continue;
		}

		bFoundPRI = false;
		for (Index = PlayerInfoDataList.Length - 1; Index >= 0; Index--)
		{
			if (PlayerInfoDataList[Index].KFPRI == PRI)
			{
				bFoundPRI = true;
				break;
			}
		}

		if (bFoundPRI)
		{
			continue;
		}

		PlayerInfoDataList.Insert(PlayerInfoDataList.Length, 1);
		PlayerInfoDataList[PlayerInfoDataList.Length - 1].KFPRI = KFPlayerReplicationInfo(PRI);
		PlayerInfoDataList[PlayerInfoDataList.Length - 1].bInitialized = false;
	}

	//Link up pawns.
	foreach CollidingActors(Class'KFHumanPawn', HumanPawn, 1000.f, PlayerOwner.CalcViewLocation)
	{
		for (Index = PlayerInfoDataList.Length - 1; Index >= 0; Index--)
		{
			HumanPawn.bNoTeamBeacon = true;

			if (PlayerInfoDataList[Index].KFPRI != HumanPawn.PlayerReplicationInfo)
			{
				continue;
			}

			PlayerInfoDataList[Index].HumanPawn = HumanPawn;
		}
	}

	//Tick entries.
	for (Index = PlayerInfoDataList.Length - 1; Index >= 0; Index--)
	{
		if (PlayerInfoDataList[Index].KFPRI == None)
		{
			PlayerInfoDataList.Remove(Index, 1);
			continue;
		}
		
		PlayerInfo = PlayerInfoDataList[Index];
		TickPlayerInfo(DeltaTime, PlayerInfo);
		PlayerInfoDataList[Index] = PlayerInfo;
	}
}

static final simulated function bool ShouldDrawPlayerInfo(vector CameraPosition, vector CameraDirection, out PlayerInfoData PlayerInfo)
{
	if (PlayerInfo.KFPRI == None)
	{
		return false;
	}

	if (PlayerInfo.CurrentHealth <= 0)
	{
		return false;
	}

	if (((PlayerInfo.HumanPawn.Location - CameraPosition) Dot CameraDirection) < 0.8 )
	{
		return false;
	}

	if (!PlayerInfo.HumanPawn.FastTrace(PlayerInfo.HumanPawn.Location, CameraPosition))
	{
		return false;
	}

	return true;
}

simulated function Draw(Canvas C)
{
	local int Index;
	local vector CamPos, ViewDir, ScreenPos;
	local rotator CamRot;
	local KFHumanPawn HumanPawn;

	// Grab our View Direction
	C.GetCameraLocation(CamPos,CamRot);
	ViewDir = vector(CamRot);

	// Draw the Name, Health, Armor, and Veterancy above other players (using this way to fix portal's beacon errors).
	for (Index = PlayerInfoDataList.Length - 1; Index >= 0; Index--)
	{
		if (/*PlayerInfoDataList[Index].HumanPawn == PawnOwner ||*/ !ShouldDrawPlayerInfo(CamPos, ViewDir, PlayerInfoDataList[Index]))
		{
			continue;
		}

		HumanPawn = PlayerInfoDataList[Index].HumanPawn;

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

	Dist = vsize(PlayerInfo.HumanPawn.Location - PlayerOwner.CalcViewLocation);
	Dist -= HealthBarFullVisDist;
	Dist = FClamp(Dist, 0, HealthBarCutoffDist-HealthBarFullVisDist);
	Dist = Dist / (HealthBarCutoffDist - HealthBarFullVisDist);
	BeaconAlpha = byte((1.f - Dist) * 255.f);

	if ( BeaconAlpha == 0 )
	{
		return;
	}

	OldZ = C.Z;
	C.Z = 1.0;
	C.Style = ERenderStyle.STY_Alpha;
	C.Font = GetConsoleFont(C);
	Class'SRScoreBoard'.Static.TextSizeCountry(C, PlayerInfo.KFPRI, XL, YL);
	TempX = ScreenLocX - ((XL + BarLength) * 0.5);
	TempY = ScreenLocY - (YL * 1.f);

	C.SetDrawColor(0, 0, 0, BeaconAlpha);
	Class'SRScoreBoard'.Static.DrawCountryName(C, PlayerInfo.KFPRI, TempX + 2.f, TempY + 2.f);
	C.SetDrawColor(255, 255, 255, BeaconAlpha);
	Class'SRScoreBoard'.Static.DrawCountryName(C, PlayerInfo.KFPRI, TempX, TempY);

	OffsetX = (36.f * VeterancyMatScaleFactor * 0.6);

	if ( Class<SRVeterancyTypes>(PlayerInfo.KFPRI.ClientVeteranSkill)!=none && PlayerInfo.KFPRI.ClientVeteranSkill.default.OnHUDIcon!=none )
	{
		TempLevel = Class<SRVeterancyTypes>(PlayerInfo.KFPRI.ClientVeteranSkill).Static.PreDrawPerk(C, PlayerInfo.KFPRI.ClientVeteranSkillLevel, TempMaterial, TempStarMaterial);

		TempSize = 32.f * VeterancyMatScaleFactor;
		TempX = ((ScreenLocX + ((BarLength) * 0.5)) - (TempSize * 0.15)) - OffsetX;
		TempY = ScreenLocY - YL - (TempSize * (0.75f + 0.0625f));

		C.SetPos(TempX, TempY);
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
				TempX+=VetStarSize;
			}
		}
	}

	// Health
	bDrawLostHealth = PlayerInfo.PreviousHealth > PlayerInfo.CurrentHealth;
	if (bDrawLostHealth)
	{
		HealthLossBarColor.A = BeaconAlpha;
		DrawBar(C, ScreenLocX - OffsetX, (ScreenLocY - YL) - 0.4 * BarHeight, FClamp(PlayerInfo.PreviousHealth, 0, 1), HealthLossBarColor, true, 1.f);
	}

	if ( PlayerInfo.CurrentHealth > 0.f )
	{
		HealthBarColor.A = BeaconAlpha;
		DrawBar(C, ScreenLocX - OffsetX, (ScreenLocY - YL) - 0.4 * BarHeight, FClamp(PlayerInfo.CurrentHealth, 0, 1), HealthBarColor, !bDrawLostHealth, 1.f);
	}
		
	// Armor
	bDrawLostShield = PlayerInfo.PreviousShield > PlayerInfo.CurrentShield;
	if (bDrawLostShield)
	{
		HealthLossBarColor.A = BeaconAlpha;
		DrawBar(C, ScreenLocX - OffsetX, (ScreenLocY - YL) - 1.4 * BarHeight, FClamp(PlayerInfo.PreviousShield, 0, 1), ShieldBarColor, true, 0.5f);
	}
	
	if ( PlayerInfo.CurrentShield > 0.f )
	{
		ShieldBarColor.A = BeaconAlpha;
		DrawBar(C, ScreenLocX - OffsetX, (ScreenLocY - YL) - 1.4 * BarHeight, FClamp(PlayerInfo.CurrentShield, 0, 1), ShieldLossBarColor, !bDrawLostShield, 0.5f);
	}

	if ( PlayerInfo.LastHit.Ratio < 1.f)
	{
		LastHitScale = 1.f - ((PlayerInfo.LastHit.Ratio - 1.f) ** 4.f);
		LastHitAlpha = 1.f - (((2.f * PlayerInfo.LastHit.Ratio) - 1.f) ** 4.f);
		LastHitAlpha *= (float(BeaconAlpha) / 255.f);
		LastHitAlpha *= (float(HealthHitBarColor.A) / 255.f);
		
		C.DrawColor = HealthHitBarColor;
		C.DrawColor.A = (LastHitAlpha * 255.f);
		C.SetPos(((ScreenLocX - OffsetX) - 0.5 * BarLength) + (BarLength * FClamp(PlayerInfo.CurrentHealth, 0, 1)), ((ScreenLocY - YL) - 0.4 * BarHeight) - (0.5 * BarHeight * LastHitScale * 1.5f));
		C.DrawTileStretched(WhiteMaterial, (BarLength * PlayerInfo.LastHit.HitAmount * Lerp(LastHitScale, 0.75f, 1.f)) + ((BarLength * 0.05f) / PlayerInfo.LastHit.FadeRate), BarHeight * LastHitScale * 1.5f);
	}

	C.Z = OldZ;
}

simulated function DrawBar(Canvas C, float XCentre, float YCentre, float BarPercentage, color Color, bool bDrawBackplate, float HeightScale)
{
	if (bDrawBackplate)
	{
		C.SetDrawColor(16, 16, 16, Color.A);
		C.SetPos(XCentre - 0.5 * BarLength, YCentre - (0.5 * BarHeight * HeightScale));
		C.DrawTileStretched(WhiteMaterial, BarLength, BarHeight * HeightScale);
	}

	C.DrawColor = Color;
	C.SetPos(XCentre - 0.5 * BarLength, YCentre - (0.5 * BarHeight * HeightScale));
	C.DrawTileStretched(WhiteMaterial, BarLength * BarPercentage, BarHeight * HeightScale);
}

defaultproperties
{
	HealthInterpRate=1.f;
	ShieldInterpRate=4.f;

	HealthBarColor=(R=232,G=41,B=41,A=255)
	HealthLossBarColor=(R=222,G=171,B=47,A=255)
	HealthHitBarColor=(R=222,G=171,B=47,A=215)

	ShieldBarColor=(R=27,G=181,B=213,A=255)
	ShieldLossBarColor=(R=50,G=140,B=180,A=255)

	BarBackplateColor=(R=25,G=192,B=255,A=255)
}