class KFPHUDKillingFloor extends SRHUDKillingFloor;

#exec obj load file="../Textures/KFTurboHUD.utx" package="KFTurbo"
//#exec obj load file="SkeletonHUDFonts.utx" package="KFTurbo"

var	localized string HUDLargeNumberFontNames[9];
var	Font HUDLargeNumberFonts[9];

var Sound WinSound, LoseSound;
var float EndGameHUDAnimationDuration;
var Material EndGameHUDMaterial;
var bool bHasInitializedEndGameHUD;
var float EndGameHUDAnimationProgress;

var KFPHUDObject PlayerInfoHUD;
var KFPHUDObject WaveInfoHUD;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	PlayerInfoHUD = new(self) class'KFPHUDPlayerInfo';
	PlayerInfoHUD.Initialize(Self);
	WaveInfoHUD = new(self) class'KFPHUDWaveInfo';
	WaveInfoHUD.Initialize(Self);
}

simulated function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);

	if (bHasInitializedEndGameHUD)
	{
		EndGameHUDAnimationProgress += DeltaTime;
	}
	
	if (PlayerInfoHUD != None)
	{
		PlayerInfoHUD.Tick(DeltaTime);
	}
	
	if (WaveInfoHUD != None)
	{
		WaveInfoHUD.Tick(DeltaTime);
	}
}

simulated function DrawHud(Canvas C)
{
	RenderDelta = Level.TimeSeconds - LastHUDRenderTime;
    LastHUDRenderTime = Level.TimeSeconds;

	if ( FontsPrecached < 2 )
	{
		PrecacheFonts(C);
	}

	UpdateHud();

	PassStyle = STY_Modulated;
	DrawModOverlay(C);

	if ( bUseBloom )
	{
		PlayerOwner.PostFX_SetActive(0, true);
	}

	if ( bHideHud )
	{
		// Draw fade effects even if the hud is hidden so poeple can't just turn off thier hud
		C.Style = ERenderStyle.STY_Alpha;
		DrawFadeEffect(C);
		return;
	}

	if ( !KFPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo).bViewingMatineeCinematic )
	{
		DrawGameHud(C);
	}
	else
	{
		PassStyle = STY_Alpha;
		DrawCinematicHUD(C);
	}

	if ( bShowNotification )
	{
		DrawPopupNotification(C);
	}
}

simulated function DrawGameHud(Canvas C)
{
	local KFGameReplicationInfo CurrentGame;

	CurrentGame = KFGameReplicationInfo(Level.GRI);

	if ( bShowTargeting )
	{
		DrawTargeting(C);
	}

	if (PlayerInfoHUD != None)
	{
		PlayerInfoHUD.Draw(C);
		log ("PlayerInfoHUD Complete");
	}

	PassStyle = STY_Alpha;
	DrawDamageIndicators(C);
	DrawHudPassA(C);
	DrawHudPassC(C);

	if ( KFPlayerController(PlayerOwner) != None && KFPlayerController(PlayerOwner).ActiveNote != None )
	{
		if( PlayerOwner.Pawn == none )
		{
			KFPlayerController(PlayerOwner).ActiveNote = None;
		}
		else
		{
			KFPlayerController(PlayerOwner).ActiveNote.RenderNote(C);
		}
	}

	PassStyle = STY_None;
	DisplayLocalMessages(C);
	DrawWeaponName(C);
	DrawVehicleName(C);

	PassStyle = STY_Alpha;

	if ( CurrentGame!=None && CurrentGame.EndGameType > 0 )
	{
		DrawEndGameHUD(C, (CurrentGame.EndGameType==2));
		return;
	}

	RenderFlash(C);
	C.Style = PassStyle;
	DrawKFHUDTextElements(C);
}


simulated function DrawKFHUDTextElements(Canvas C)
{
	local vector Pos, FixedZPos;
	local rotator  ShopDirPointerRotation;
	local float    CircleSize;
	local float    ResScale;

	if ( PlayerOwner == none || KFGRI == none || !KFGRI.bMatchHasBegun || KFPlayerController(PlayerOwner).bShopping )
	{
		return;
	}

	if (WaveInfoHUD != None)
	{
		WaveInfoHUD.Draw(C);
	}

    ResScale =  C.SizeX / 1024.0;
    CircleSize = FMin(128 * ResScale,128);
	C.FontScaleX = FMin(ResScale,1.f);
	C.FontScaleY = FMin(ResScale,1.f);

	C.FontScaleX = 1;
	C.FontScaleY = 1;


	if ( KFPRI == none || KFPRI.Team == none || KFPRI.bOnlySpectator || PawnOwner == none )
	{
		return;
	}

	// Draw the shop pointer
	if ( ShopDirPointer == None )
	{
		ShopDirPointer = Spawn(Class'KFShopDirectionPointer');
		ShopDirPointer.bHidden = bHideHud;
	}

	Pos.X = C.SizeX / 18.0;
	Pos.Y = C.SizeX / 18.0;
	Pos = PlayerOwner.Player.Console.ScreenToWorld(Pos) * 10.f * (PlayerOwner.default.DefaultFOV / PlayerOwner.FovAngle) + PlayerOwner.CalcViewLocation;
	ShopDirPointer.SetLocation(Pos);

	if ( KFGRI.CurrentShop != none )
	{
		// Let's check for a real Z difference (i.e. different floor) doesn't make sense to rotate the arrow
		// only because the trader is a midget or placed slightly wrong
		if ( KFGRI.CurrentShop.Location.Z > PawnOwner.Location.Z + 50.f || KFGRI.CurrentShop.Location.Z < PawnOwner.Location.Z - 50.f )
		{
		    ShopDirPointerRotation = rotator(KFGRI.CurrentShop.Location - PawnOwner.Location);
		}
		else
		{
		    FixedZPos = KFGRI.CurrentShop.Location;
		    FixedZPos.Z = PawnOwner.Location.Z;
		    ShopDirPointerRotation = rotator(FixedZPos - PawnOwner.Location);
		}
	}
	else
	{
		ShopDirPointer.bHidden = true;
		return;
	}

   	ShopDirPointer.SetRotation(ShopDirPointerRotation);

	if ( Level.TimeSeconds > Hint_45_Time && Level.TimeSeconds < Hint_45_Time + 2 )
	{
		if ( KFPlayerController(PlayerOwner) != none )
		{
			KFPlayerController(PlayerOwner).CheckForHint(45);
		}
	}

	C.DrawActor(None, False, True); // Clear Z.
	ShopDirPointer.bHidden = false;
	C.DrawActor(ShopDirPointer, False, false);
	ShopDirPointer.bHidden = true;
	DrawTraderDistance(C);
}

simulated function DrawEndGameHUD(Canvas C, bool bVictory)
{
	local float YScalar, XScalar, FadeAlpha, ScaleAlpha;

	InitializeEndGameUI(bVictory);

	//Reset draw.
	C.DrawColor = WhiteColor;
	C.Style = ERenderStyle.STY_Alpha;

	FadeAlpha = FMin(EndGameHUDAnimationProgress / (EndGameHUDAnimationDuration * 0.5f), 1.f);
	ScaleAlpha = FMin(EndGameHUDAnimationProgress / EndGameHUDAnimationDuration, 1.f);

	YScalar = FClamp(C.ClipY, 256, 2056) * Lerp(1.f - Square(Square(ScaleAlpha - 1.f)), 0.9f, 1.f); //Scale is based on screen Y size.
	XScalar = YScalar * 2.f;

	C.DrawColor.A = Lerp(FadeAlpha, 0, 255);

	C.CurX = C.ClipX / 2 - XScalar / 2;
	C.CurY = C.ClipY / 2 - YScalar / 2;

	C.DrawTile(EndGameHUDMaterial, XScalar, YScalar, 0, 0, 2048, 1024);

	if ( bShowScoreBoard && ScoreBoard != None )
	{
		ScoreBoard.DrawScoreboard(C);
	}
}

simulated function InitializeEndGameUI(bool bVictory)
{
	if (bHasInitializedEndGameHUD)
	{
		return;
	}

	bHasInitializedEndGameHUD = true;

	if ( bVictory )
	{
		EndGameHUDMaterial = Texture'KFTurbo.EndGame.You_Won_D';
		PlayerOwner.PlaySound(WinSound, SLOT_Talk, 255.0,,,, false);
	}
	else
	{
		EndGameHUDMaterial = Texture'KFTurbo.EndGame.You_Died_D';
		PlayerOwner.PlaySound(LoseSound, SLOT_Talk,255.0,,,, false);
	}
}

static function Font LoadLargeNumberFont(int i)
{
	if (default.MenuFontArrayFonts[i] == none)
	{
		default.MenuFontArrayFonts[i] = Font(DynamicLoadObject(default.MenuFontArrayNames[i], class'Font'));
		if (default.MenuFontArrayFonts[i] == none)
			Log("Warning: "$default.Class$" Couldn't dynamically load font "$default.MenuFontArrayNames[i]);
	}

	return default.MenuFontArrayFonts[i];
}

defaultproperties
{
	WinSound=Sound'KFTurbo.YouWin_S'
	LoseSound=Sound'KFTurbo.YouLose_S'
	EndGameHUDAnimationDuration=8.f

	bHasInitializedEndGameHUD=false
	EndGameHUDAnimationProgress=0.f

	BarLength=70.000000
	BarHeight=10.000000

	/*
	HUDLargeNumberFontNames(0)="KFTurbo.FalenaText72Numbers"
	HUDLargeNumberFontNames(1)="KFTurbo.FalenaText72Numbers"
	HUDLargeNumberFontNames(2)="KFTurbo.FalenaText60Numbers"
	HUDLargeNumberFontNames(3)="KFTurbo.FalenaText60Numbers"
	HUDLargeNumberFontNames(4)="KFTurbo.FalenaText48"
	HUDLargeNumberFontNames(5)="KFTurbo.FalenaText48"
	HUDLargeNumberFontNames(6)="KFTurbo.FalenaText36"
	HUDLargeNumberFontNames(7)="KFTurbo.FalenaText36"
	HUDLargeNumberFontNames(8)="KFTurbo.FalenaText24"
	
	SmallFontArrayNames(0)="KFTurbo.BahnschriftText24"
	SmallFontArrayNames(1)="KFTurbo.BahnschriftText24"
	SmallFontArrayNames(2)="KFTurbo.BahnschriftText18"
	SmallFontArrayNames(3)="KFTurbo.BahnschriftText18"
	SmallFontArrayNames(4)="KFTurbo.BahnschriftText14"
	SmallFontArrayNames(5)="KFTurbo.BahnschriftText14"
	SmallFontArrayNames(6)="KFTurbo.BahnschriftText12"
	SmallFontArrayNames(7)="KFTurbo.BahnschriftText12"
	SmallFontArrayNames(8)="KFTurbo.BahnschriftText9"

	MenuFontArrayNames(0)="KFTurbo.BahnschriftText18"
	MenuFontArrayNames(1)="KFTurbo.BahnschriftText14"
	MenuFontArrayNames(2)="KFTurbo.BahnschriftText12"
	MenuFontArrayNames(3)="KFTurbo.BahnschriftText9"
	MenuFontArrayNames(4)="KFTurbo.BahnschriftText9"

	WaitingFontArrayNames(0)="KFTurbo.FalenaTitle60"
	WaitingFontArrayNames(1)="KFTurbo.FalenaTitle48"
	WaitingFontArrayNames(2)="KFTurbo.FalenaTitle36"

	FontArrayNames(0)="KFTurbo.BahnschriftText36"
	FontArrayNames(1)="KFTurbo.BahnschriftText36"
	FontArrayNames(2)="KFTurbo.BahnschriftText24"
	FontArrayNames(3)="KFTurbo.BahnschriftText24"
	FontArrayNames(4)="KFTurbo.BahnschriftText18"
	FontArrayNames(5)="KFTurbo.BahnschriftText18"
	FontArrayNames(6)="KFTurbo.BahnschriftText14"
	FontArrayNames(7)="KFTurbo.BahnschriftText12"
	FontArrayNames(8)="KFTurbo.BahnschriftText9"
	*/
}
