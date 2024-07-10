class KFPHUDKillingFloor extends SRHUDKillingFloor;

#exec obj load file="../Textures/KFTurboHUD.utx" package="KFTurbo"
#exec obj load file="SkeletonHUDFonts.utx" package="KFTurbo"

var Sound WinSound, LoseSound;
var float EndGameHUDAnimationDuration;
var Material EndGameHUDMaterial;
var bool bHasInitializedEndGameHUD;
var float EndGameHUDAnimationProgress;

var KFPHUDObject PlayerInfoHUD;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	PlayerInfoHUD = new(self) class'KFPHUDPlayerInfo';
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

defaultproperties
{
	WinSound=Sound'KFTurbo.YouWin_S'
	LoseSound=Sound'KFTurbo.YouLose_S'
	EndGameHUDAnimationDuration=8.f

	bHasInitializedEndGameHUD=false
	EndGameHUDAnimationProgress=0.f

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
}
