class KFPHUDPlayerInfo extends KFPHUDObject;

struct PlayerInfoHitData
{
	var float PreHitHealth;
	var float Ratio;
	var float FadeRate;
};

struct PlayerInfoData
{
	var KFPlayerReplicationInfo KFPRI;
	var KFHumanPawn HumanPawn;
	
	var float CurrentHealth;
	var float PreviousHealth;
	
	var float CurrentShield;
	var float PreviousShield;

	var PlayerInfoHitData LastHit;
	var bool bInitialized;
};

var array<PlayerInfoData> PlayerInfoDataList;

var() float HealthInterpRate;
var() float ShieldInterpRate;

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
		PlayerInfo.PreviousHealth = PlayerInfo.CurrentHealth;
		PlayerInfo.PreviousShield = PlayerInfo.CurrentShield;
		PlayerInfo.LastHit.Ratio = 1.f; //Mark as done playing.
		PlayerInfo.bInitialized = true;
		return;
	}

	if (PlayerInfo.CurrentHealth < PlayerInfo.PreviousHealth)
	{
		PlayerInfo.PreviousHealth = Lerp(default.HealthInterpRate * DeltaTime, PlayerInfo.PreviousHealth, PlayerInfo.CurrentHealth);
	}
	else if (PlayerInfo.CurrentHealth > PlayerInfo.PreviousHealth)
	{
		PlayerInfo.PreviousHealth = PlayerInfo.CurrentHealth;
	}

	if (PlayerInfo.CurrentShield < PlayerInfo.PreviousShield)
	{
		PlayerInfo.PreviousShield = Lerp(default.ShieldInterpRate * DeltaTime, PlayerInfo.PreviousShield, PlayerInfo.CurrentShield);
	}
	else if (PlayerInfo.CurrentShield > PlayerInfo.PreviousShield)
	{
		PlayerInfo.PreviousShield = PlayerInfo.CurrentShield;
	}
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
		//log("health was 0");
		return false;
	}

	if (((PlayerInfo.HumanPawn.Location - CameraPosition) Dot CameraDirection) < 0.8 )
	{
		//log("Dot product no good");
		return false;
	}

	if (!PlayerInfo.HumanPawn.FastTrace(PlayerInfo.HumanPawn.Location, CameraPosition))
	{
		//log("Fast trace no good");
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
		if (PlayerInfoDataList[Index].HumanPawn == PawnOwner || !ShouldDrawPlayerInfo(CamPos, ViewDir, PlayerInfoDataList[Index]))
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
	local float XL, YL, TempX, TempY, TempSize;
	local float Dist, OffsetX;
	local byte BeaconAlpha,Counter;
	local float OldZ;
	local Material TempMaterial, TempStarMaterial;
	local byte i, TempLevel;

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
	C.SetDrawColor(255, 255, 255, BeaconAlpha);
	C.Font = GetConsoleFont(C);
	Class'SRScoreBoard'.Static.TextSizeCountry(C, PlayerInfo.KFPRI, XL, YL);
	Class'SRScoreBoard'.Static.DrawCountryName(C, PlayerInfo.KFPRI, ScreenLocX-(XL * 0.5),ScreenLocY-(YL * 0.75));

	OffsetX = (36.f * VeterancyMatScaleFactor * 0.6) - (HealthIconSize + 2.0);

	if ( Class<SRVeterancyTypes>(PlayerInfo.KFPRI.ClientVeteranSkill)!=none && PlayerInfo.KFPRI.ClientVeteranSkill.default.OnHUDIcon!=none )
	{
		TempLevel = Class<SRVeterancyTypes>(PlayerInfo.KFPRI.ClientVeteranSkill).Static.PreDrawPerk(C, PlayerInfo.KFPRI.ClientVeteranSkillLevel, TempMaterial, TempStarMaterial);

		TempSize = 36.f * VeterancyMatScaleFactor;
		TempX = ScreenLocX + ((BarLength + HealthIconSize) * 0.5) - (TempSize * 0.25) - OffsetX;
		TempY = ScreenLocY - YL - (TempSize * 0.75);

		C.SetPos(TempX, TempY);
		C.DrawTile(TempMaterial, TempSize, TempSize, 0, 0, TempMaterial.MaterialUSize(), TempMaterial.MaterialVSize());

		TempX += (TempSize - (VetStarSize * 0.75));
		TempY += (TempSize - (VetStarSize * 1.5));

		for ( i = 0; i < TempLevel; i++ )
		{
			C.SetPos(TempX, TempY-(Counter*VetStarSize*0.7f));
			C.DrawTile(TempStarMaterial, VetStarSize * 0.7, VetStarSize * 0.7, 0, 0, TempStarMaterial.MaterialUSize(), TempStarMaterial.MaterialVSize());

			if( ++Counter==5 )
			{
				Counter = 0;
				TempX+=VetStarSize;
			}
		}
	}

	// Health
	if ( PlayerInfo.CurrentHealth > 0.f )
		DrawKFBar(C, ScreenLocX - OffsetX, (ScreenLocY - YL) - 0.4 * BarHeight, FClamp(PlayerInfo.CurrentHealth, 0, 1), BeaconAlpha);

	// Armor
	if ( PlayerInfo.CurrentShield > 0.f )
		DrawKFBar(C, ScreenLocX - OffsetX, (ScreenLocY - YL) - 1.5 * BarHeight, FClamp(PlayerInfo.CurrentShield, 0, 1), BeaconAlpha, true);

	C.Z = OldZ;
}

defaultproperties
{
	HealthInterpRate=2.f;
	ShieldInterpRate=2.f;
}