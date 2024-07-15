class KFPHUDPlayerHealth extends KFPHUDOverlay;

var Vector2D BackplateSize;
var Vector2D BackplateSpacing; //Distance from top and middle.

var Color BackplateColor;
var Texture RoundedContainer;

var float CurrentHealth;
var float HealthInterpRate;

simulated function Tick(float DeltaTime)
{
	if (KFPHUD.PawnOwner == None)
	{
		CurrentHealth = -1.f;
		return;
	}

	CurrentHealth = Lerp(HealthInterpRate * DeltaTime, CurrentHealth, float(KFPHUD.PawnOwner.Health));
}

//DrawCounterTextMeticulous(Canvas C, String String, float SizeX, float EmptyDigitOpacityMultiplier)
simulated function Render(Canvas C)
{
	local Vector2D BackplateACenter, BackplateBCenter;

	Super.Render(C);

	if (KFPHUD.PawnOwner == None)
	{
		return;
	}

	DrawGameBackplate(C, BackplateACenter, BackplateBCenter);
	DrawHealthText(C, BackplateACenter);
}

simulated function DrawGameBackplate(Canvas C, out Vector2D BackplateACenter, out Vector2D BackplateBCenter)
{
	local float CenterX, TopY;
	local float TempX, TempY;

	CenterX = C.ClipX * 0.5f;
	TopY = C.ClipY * (1.f - (BackplateSpacing.Y + BackplateSize.Y));

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
	BackplateBCenter.X = TempX + (C.ClipX * BackplateSize.X * 0.5f);
	BackplateBCenter.Y = BackplateACenter.Y;

	if (RoundedContainer != None)
	{
		C.DrawTileStretched(RoundedContainer, C.ClipX * BackplateSize.X, C.ClipY * BackplateSize.Y);
	}
}

simulated function DrawHealthText(Canvas C, Vector2D BackplateACenter)
{
	local float TextSizeX, TextSizeY, TextScale;
	local string HealthString;

	C.SetPos(BackplateACenter.X, BackplateACenter.Y - (C.ClipY * BackplateSize.Y * 0.5f));

	C.DrawColor = C.MakeColor(255, 255, 255, 220);
	
	C.FontScaleX = 1.f;
	C.FontScaleY = 1.f;
	C.Font = class'KFTurboFonts'.static.LoadLargeNumberFont(0);
	C.TextSize(GetStringOfZeroes(3), TextSizeX, TextSizeY);
	
	TextScale = (C.ClipY * BackplateSize.Y) / TextSizeY;
	C.FontScaleX = TextScale;
	C.FontScaleY = TextScale;
	C.TextSize(GetStringOfZeroes(3), TextSizeX, TextSizeY);

	HealthString = FillStringWithZeroes(Min(int(CurrentHealth), 999), 3);
	DrawCounterTextMeticulous(C, HealthString, TextSizeX, 0.5f);
}

defaultproperties
{
	BackplateColor=(R=0,G=0,B=0,A=140)
	BackplateSize=(X=0.15f,Y=0.075f)
	BackplateSpacing=(X=0.01f,Y=0.02f)

	CurrentHealth=-1.f
	HealthInterpRate=4.f

	RoundedContainer=Texture'KFTurbo.HUD.ContainerRounded_D'
}