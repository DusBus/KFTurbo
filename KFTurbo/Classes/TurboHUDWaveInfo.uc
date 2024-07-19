class TurboHUDWaveInfo extends TurboHUDOverlay;

var KFGameReplicationInfo KFGRI;

//Trader
var bool bNeedTraderWaveInitialization;
var float TraderFadeRatio;
var float TraderFadeRate;

var float WaveTimeRemaining;
var int WaveTimeSecondsRemaining;

//Active Wave
var bool bNeedActiveWaveInitialization;
var float ActiveWaveFadeRatio;
var float ActiveWaveFadeRate;

var float ActiveWaveSizeRate;
var float DesiredXSize, DesiredYSize;

var float NumberZedsRemaining;
var float NumberZedsInterpRate;

var Vector2D BackplateSize;
var Vector2D ActiveBackplateSize;
var Vector2D BackplateSpacing; //Distance from top and middle.

var Color BackplateColor;
var Texture RoundedContainer;
var Texture SquareContainer;

var Font LargeNumbeFont;

simulated function Initialize(TurboHUDKillingFloor OwnerHUD)
{
	Super.Initialize(OwnerHUD);

	KFGRI = KFGameReplicationInfo(KFPHUD.Level.GRI);
	
	class'KFTurboFonts'.static.LoadLargeNumberFont(2);

	ActiveBackplateSize = BackplateSize;
}

simulated function Tick(float DeltaTime)
{
	if (KFGRI == None)
	{
		KFGRI = KFGameReplicationInfo(KFPHUD.Level.GRI);

		if (KFGRI == None)
		{
			return;
		}
	}

	if (KFGRI.bWaveInProgress)
	{
		GotoState('ActiveWave');
	}
	else
	{
		GotoState('WaitingWave');
	}
}

simulated function DrawWaveData(Canvas C, Vector2D Center)
{

}

state ActiveWave
{
	simulated function BeginState()
	{
		NumberZedsRemaining = KFGRI.MaxMonsters;
		ActiveWaveFadeRatio = 0.f;
	}

	simulated function Tick(float DeltaTime)
	{
		if (KFGRI == None)
		{
			return;
		}

		TickActiveWave(DeltaTime);

		if (!KFGRI.bWaveInProgress)
		{
			TickActiveFadeOut(DeltaTime);
		}
		else
		{
			TickActiveFadeIn(DeltaTime);
		}
	}

	simulated function DrawWaveData(Canvas C, Vector2D Center)
	{
		DrawActiveWave(C, Center);
	}
}

simulated function TickActiveFadeOut(float DeltaTime)
{
	ActiveWaveFadeRatio = FMax(ActiveWaveFadeRatio - (ActiveWaveFadeRate * DeltaTime), 0.f);

	ActiveBackplateSize.X = Lerp(2.f * ActiveWaveSizeRate * DeltaTime, ActiveBackplateSize.X, BackplateSize.X);

	if (ActiveWaveFadeRatio <= 0.001f)
	{
		ActiveWaveFadeRatio = 0.f;
	}

	if (Abs(BackplateSize.X - ActiveBackplateSize.X) > 0.0001f)
	{
		return;
	}

	ActiveBackplateSize.X = BackplateSize.X;
	
	GotoState('WaitingWave');
}

simulated function TickActiveFadeIn(float DeltaTime)
{
	if (Abs(DesiredXSize - ActiveBackplateSize.X) > 0.0001f)
	{
		ActiveBackplateSize.X = Lerp(ActiveWaveSizeRate * DeltaTime, ActiveBackplateSize.X, DesiredXSize);
		return;
	}

	ActiveBackplateSize.X = DesiredXSize;

	if (ActiveWaveFadeRatio >= 0.999f)
	{
		ActiveWaveFadeRatio = 1.f;
		return;
	}

	ActiveWaveFadeRatio = FMin(ActiveWaveFadeRatio + (ActiveWaveFadeRate * DeltaTime), 1.f);
}

simulated function TickActiveWave(float DeltaTime)
{
	NumberZedsRemaining = Lerp(DeltaTime * NumberZedsInterpRate, NumberZedsRemaining, float(KFGRI.MaxMonsters));
}

state WaitingWave
{
	simulated function BeginState()
	{
		WaveTimeSecondsRemaining = KFGRI.TimeToNextWave;
		TraderFadeRatio = 0.f;
	}

	simulated function Tick(float DeltaTime)
	{
		if (KFGRI == None)
		{
			return;
		}

		TickTraderWave(DeltaTime);

		if (KFGRI.bWaveInProgress)
		{
			TickTraderFadeOut(DeltaTime);
		}
		else
		{
			TickTraderFadeIn(DeltaTime);
		}
	}
	
	simulated function DrawWaveData(Canvas C, Vector2D Center)
	{
		DrawTraderWave(C, Center);
	}
}

simulated function TickTraderWave(float DeltaTime)
{
	if (KFGRI.TimeToNextWave != WaveTimeSecondsRemaining && Abs(WaveTimeRemaining - float(KFGRI.TimeToNextWave)) > 0.15f)
	{
		WaveTimeSecondsRemaining = KFGRI.TimeToNextWave;
		WaveTimeRemaining = (float(KFGRI.TimeToNextWave) - 0.0001f);
	}
	else
	{
		WaveTimeRemaining -= DeltaTime * 0.95f;
	}
}

simulated function TickTraderFadeOut(float DeltaTime)
{
	TraderFadeRatio = FMax(TraderFadeRatio - (TraderFadeRate * DeltaTime), 0.f);

	if (TraderFadeRatio <= 0.001f)
	{
		TraderFadeRatio = 0.f;
		GotoState('ActiveWave');
	}
}

simulated function TickTraderFadeIn(float DeltaTime)
{
	TraderFadeRatio = FMin(TraderFadeRatio + (TraderFadeRate * DeltaTime), 1.f);
}

simulated function Render(Canvas C)
{
	local Vector2D BackplateACenter, BackplateBCenter;
	
	Super.Render(C);

	if (KFGRI == None)
	{
		return;
	}
	
	DrawGameBackplate(C, BackplateACenter, BackplateBCenter);
	DrawCurrentWave(C, BackplateACenter);
	DrawWaveData(C, BackplateBCenter);
}

simulated function DrawGameBackplate(Canvas C, out Vector2D BackplateACenter, out Vector2D BackplateBCenter)
{
	local float CenterX, TopY;
	local float TempX, TempY;

	CenterX = C.ClipX * 0.5f;
	TopY = C.ClipY * BackplateSpacing.Y;

	TempX = CenterX - (C.ClipX * (BackplateSpacing.X + BackplateSize.X));
	TempY = TopY;

	C.DrawColor = BackplateColor;

	C.SetPos(TempX, TempY);
	BackplateACenter.X = TempX + (C.ClipX * BackplateSize.X * 0.5f);
	BackplateACenter.Y = TempY + (C.ClipY * BackplateSize.Y * 0.5f);

	if (RoundedContainer != None)
	{
		C.DrawTileStretched(RoundedContainer, C.ClipX * BackplateSize.X, C.ClipY * BackplateSize.Y);
	}
	
	TempX = CenterX + (C.ClipX * BackplateSpacing.X);

	C.SetPos(TempX, TempY);
	BackplateBCenter.X = TempX + (C.ClipX * ActiveBackplateSize.X * 0.5f);
	BackplateBCenter.Y = BackplateACenter.Y;

	if (RoundedContainer != None)
	{
		C.DrawTileStretched(RoundedContainer, C.ClipX * ActiveBackplateSize.X, C.ClipY * ActiveBackplateSize.Y);
	}
}

simulated function DrawCurrentWave(Canvas C, Vector2D Center)
{
	local String CurrentWaveString;
	local float TextSizeX, TextSizeY, TextScale;

	C.DrawColor = C.MakeColor(255, 255, 255, 220);
	CurrentWaveString = FillStringWithZeroes(string(KFGRI.WaveNumber + 1), 2);
	CurrentWaveString = CurrentWaveString $ "/";
	CurrentWaveString = CurrentWaveString $ FillStringWithZeroes(string(KFGRI.FinalWave), 2);
	
	C.FontScaleX = 1.f;
	C.FontScaleY = 1.f;
	C.Font = class'KFTurboFonts'.static.LoadLargeNumberFont(2);
	C.TextSize(GetStringOfZeroes(Len(CurrentWaveString)), TextSizeX, TextSizeY);
	
	TextScale = (C.ClipY * BackplateSize.Y) / TextSizeY;
	C.FontScaleX = TextScale;
	C.FontScaleY = TextScale;
	
	C.TextSize(GetStringOfZeroes(Len(CurrentWaveString)), TextSizeX, TextSizeY);

	C.SetPos(Center.X - (TextSizeX * 0.5f), Center.Y - (TextSizeY * 0.5f));
	DrawTextMeticulous(C, CurrentWaveString, TextSizeX);
}

simulated function DrawTraderWave(Canvas C, Vector2D Center)
{
	local String TraderTime;
	local float SecondTime, MillisecondTime;
	local float TextSizeX, TextSizeY, TextScale;

	if (TraderFadeRatio <= 0.001f)
	{
		return;
	}

	C.MakeColor(255, 255, 255, byte(Lerp(TraderFadeRatio, 0, 255)));

	if (WaveTimeSecondsRemaining >= 60.f)
	{
		TraderTime = "01:" $ FillStringWithZeroes(string(Max(WaveTimeSecondsRemaining - 60, 0)), 2);
	}
	else if ( WaveTimeSecondsRemaining > 10.f)
	{
		TraderTime = "00:" $ FillStringWithZeroes(string(Max(WaveTimeSecondsRemaining,0)), 2);
	}
	else
	{
		SecondTime = Max(int(WaveTimeRemaining), 0);
		MillisecondTime = WaveTimeRemaining - SecondTime;
		MillisecondTime = MillisecondTime * 100.f;

		TraderTime = "0"$int(SecondTime)$":";
		TraderTime = TraderTime $ FillStringWithZeroes(string(Max(int(MillisecondTime), 0)), 2);
	}
	
	C.FontScaleX = 1.f;
	C.FontScaleY = 1.f;
	C.Font = class'KFTurboFonts'.static.LoadLargeNumberFont(2);
	C.TextSize(GetStringOfZeroes(Len(TraderTime)), TextSizeX, TextSizeY);
	
	TextScale = (C.ClipY * BackplateSize.Y) / TextSizeY;
	C.FontScaleX = TextScale;
	C.FontScaleY = TextScale;
	
	C.TextSize(GetStringOfZeroes(Len(TraderTime)), TextSizeX, TextSizeY);

	C.SetPos(Center.X - (TextSizeX * 0.5f), Center.Y - (TextSizeY * 0.5f));
	DrawTextMeticulous(C, TraderTime, TextSizeX);
}

simulated function DrawActiveWave(Canvas C, Vector2D Center)
{
	local float TextSizeX, TextSizeY, TextScale;
	local string ActiveWaveString;

	ActiveWaveString = string(int(NumberZedsRemaining));
	C.FontScaleX = 1.f;
	C.FontScaleY = 1.f;
	C.Font = class'KFTurboFonts'.static.LoadLargeNumberFont(2);
	C.TextSize(GetStringOfZeroes(Len(ActiveWaveString)), TextSizeX, TextSizeY);
	TextScale = (C.ClipY * BackplateSize.Y) / TextSizeY;
	C.FontScaleX = TextScale;
	C.FontScaleY = TextScale;
	C.TextSize(GetStringOfZeroes(Len(ActiveWaveString)), TextSizeX, TextSizeY);

	DesiredXSize = TextSizeX;
	DesiredXSize /= C.ClipX;
	DesiredXSize += 0.01f;

	if (ActiveBackplateSize.X < DesiredXSize)
	{
		ActiveBackplateSize.X = DesiredXSize;
	}

	if (ActiveWaveFadeRatio <= 0.001f)
	{
		return;
	}

	C.MakeColor(255, 255, 255, byte(Lerp(ActiveWaveFadeRatio, 0, 255)));

	C.SetPos(Center.X - (TextSizeX * 0.5f), Center.Y - (TextSizeY * 0.5f));
	DrawTextMeticulous(C, ActiveWaveString, TextSizeX);
}

defaultproperties
{
	bNeedTraderWaveInitialization=true
	TraderFadeRate=2.f

	bNeedActiveWaveInitialization=false
	ActiveWaveFadeRate=2.f
	ActiveWaveSizeRate=4.f
	NumberZedsInterpRate=2.f

	BackplateColor=(R=0,G=0,B=0,A=140)

	BackplateSize=(X=0.075f,Y=0.05f)
	BackplateSpacing=(X=0.01f,Y=0.02f)
	
	RoundedContainer=Texture'KFTurbo.HUD.ContainerRounded_D'
	SquareContainer=Texture'KFTurbo.HUD.ContainerSquare_D'
}