class KFPHUDWaveInfo extends KFPHUDObject;

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
var float NumberZedsRemaining;
var float NumberZedsInterpRate;

var Vector2D BackplateSize;
var Vector2D BackplateSpacing; //Distance from top and middle.

var Color BackplateColor;
var Texture RoundedContainer;
var Texture SquareContainer;

var Font LargeNumbeFont;

simulated function Initialize()
{
	KFGRI = KFGameReplicationInfo(Level.GRI);
	
	LoadLargeNumberFont(4);
}

simulated function Tick(float DeltaTime)
{
	if (KFGRI == None)
	{
		KFGRI = KFGameReplicationInfo(Level.GRI);

		if (KFGRI == None)
		{
			return;
		}
	}

	if (!KFGRI.bWaveInProgress)
	{
		TickTraderWave(DeltaTime);
	}
	else
	{
		TickActiveWave(DeltaTime);
	}
}

simulated function TickTraderWave(float DeltaTime)
{
	if (bNeedTraderWaveInitialization || KFGRI.TimeToNextWave != WaveTimeSecondsRemaining)
	{
		bNeedTraderWaveInitialization = false;
		bNeedActiveWaveInitialization = true;

		WaveTimeSecondsRemaining = KFGRI.TimeToNextWave;

		//Received a wave time update, check if we're aligned.
		if (Abs(WaveTimeRemaining - float(KFGRI.TimeToNextWave)) > 0.1f)
		{
			WaveTimeRemaining = KFGRI.TimeToNextWave;
		}
	}

	if (ActiveWaveFadeRatio > 0.f)
	{
		ActiveWaveFadeRatio = FMax(ActiveWaveFadeRatio - (ActiveWaveFadeRate * DeltaTime * 0.5f), 0.f);
	}
	else if (TraderFadeRatio < 1.f)
	{
		TraderFadeRatio = FMin(TraderFadeRatio + (TraderFadeRate * DeltaTime), 1.f);
	}
	
	WaveTimeRemaining -= DeltaTime * 0.95f;
}

simulated function TickActiveWave(float DeltaTime)
{
	if (bNeedActiveWaveInitialization)
	{
		bNeedActiveWaveInitialization = false;
		bNeedTraderWaveInitialization = true;

		NumberZedsRemaining = KFGRI.MaxMonsters;
	}

	NumberZedsRemaining = Lerp(DeltaTime * NumberZedsInterpRate, NumberZedsRemaining, float(KFGRI.MaxMonsters));
	
	if (TraderFadeRatio > 0.f)
	{
		TraderFadeRatio = FMax(TraderFadeRatio - (TraderFadeRate * DeltaTime * 0.5f), 0.f);
	}
	else if (ActiveWaveFadeRatio < 1.f)
	{
		ActiveWaveFadeRatio = FMin(ActiveWaveFadeRatio + (ActiveWaveFadeRate * DeltaTime), 1.f);
	}
}

simulated function Draw(Canvas C)
{
	local Vector2D BackplateACenter, BackplateBCenter;
	
	Super.Draw(C);

	if (KFGRI == None)
	{
		return;
	}

	DrawGameBackplate(C, BackplateACenter, BackplateBCenter);
	DrawCurrentWave(C, BackplateACenter);
	DrawTraderWave(C, BackplateBCenter);
	DrawActiveWave(C, BackplateBCenter);
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
	C.DrawTileStretched(RoundedContainer, C.ClipX * BackplateSize.X, C.ClipY * BackplateSize.Y);
	
	TempX = CenterX + (C.ClipX * BackplateSpacing.X);

	C.SetPos(TempX, TempY);
	BackplateBCenter.X = TempX + (C.ClipX * BackplateSize.X * 0.5f);
	BackplateBCenter.Y = BackplateACenter.Y;
	C.DrawTileStretched(RoundedContainer, C.ClipX * BackplateSize.X, C.ClipY * BackplateSize.Y);
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
	C.Font = LoadLargeNumberFont(4);
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

	C.DrawColor = C.MakeColor(255, 255, 255, byte(float(220) * TraderFadeRatio));

	if ( WaveTimeSecondsRemaining > 10.f)
	{
		if (WaveTimeSecondsRemaining >= 60.f)
		{
			TraderTime = "01:" $ FillStringWithZeroes(string(Max(WaveTimeSecondsRemaining - 60, 0)), 2);
		}
		else
		{
			TraderTime = "00:" $ FillStringWithZeroes(string(Max(WaveTimeSecondsRemaining,0)), 2);
		}
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
	C.Font = LoadLargeNumberFont(4);
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

	if (ActiveWaveFadeRatio <= 0.001f)
	{
		return;
	}

	ActiveWaveString = string(int(NumberZedsRemaining));
	ActiveWaveString = FillStringWithZeroes(ActiveWaveString, 4);

	C.DrawColor = C.MakeColor(255, 255, 255, byte(float(220) * ActiveWaveFadeRatio));

	C.FontScaleX = 1.f;
	C.FontScaleY = 1.f;
	C.Font = LoadLargeNumberFont(4);
	C.TextSize(GetStringOfZeroes(Len(ActiveWaveString)), TextSizeX, TextSizeY);
	
	TextScale = (C.ClipY * BackplateSize.Y) / TextSizeY;
	C.FontScaleX = TextScale;
	C.FontScaleY = TextScale;
	
	C.TextSize(GetStringOfZeroes(Len(ActiveWaveString)), TextSizeX, TextSizeY);

	C.SetPos(Center.X - (TextSizeX * 0.5f), Center.Y - (TextSizeY * 0.5f));
	DrawTextMeticulous(C, ActiveWaveString, TextSizeX);
}

defaultproperties
{
	bNeedTraderWaveInitialization=true
	TraderFadeRate=2.f

	bNeedActiveWaveInitialization=false
	ActiveWaveFadeRate=2.f
	NumberZedsInterpRate=1.f

	BackplateColor=(R=0,G=0,B=0,A=220)

	BackplateSize=(X=0.075f,Y=0.05f)
	BackplateSpacing=(X=0.01f,Y=0.02f)
	
	RoundedContainer=Texture'KFTurbo.HUD.ContainerRounded_D'
	SquareContainer=Texture'KFTurbo.HUD.ContainerSquare_D'
}