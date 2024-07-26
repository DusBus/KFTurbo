class TurboHUDScoreboard extends SRScoreBoard
	dependson(TurboHUDOverlay);

var(Layout) TurboHUDOverlay.Vector2D ScoreboardHeaderSize;
var(Layout) TurboHUDOverlay.Vector2D ScoreboardSize;

var(Color) Color ScoreboardBackplateColor;
var Texture ScoreboardBackplate;
var(Color) Color ScoreboardBackplateLeftColor;
var Texture ScoreboardBackplateLeft;

var(Color) Color ScoreboardTextColor;
var(Layout) float ScoreboardTextY;

//Perk
var(Layout) float PerkIconSizeY;
var(Layout) float PerkIconOffsetX;

//Username
var(Layout) float UsernameSizeY;
var(Layout) float UsernameOffsetX;

//Health
var(Layout) float HealthOffsetX;
var(Layout) float HealthSizeY;
var(Color) Color HealthIconColor;
var Texture HealthIcon;

//Kills
var(Layout) float KillsOffsetX;
var(Layout) float KillSizeY;
var(Color) Color KillIconColor;
var Texture KillIcon;

//Healed Health
var(Layout) float HealedHealthOffsetX;
var(Layout) float HealedHealthSizeY;
var(Color) Color HealedHealthIconColor;
var Texture HealedHealthIcon;

//Cash
var(Layout) float CashOffsetX;
var(Layout) float CashSizeY;
var(Color) Color CashIconColor;
var Texture CashIcon;

//Ping
var(Layout) float PingOffsetX;
var(Layout) float PingSizeY;
var(Layout) float PingTextSizeY;
var(Color) Color PingIconColor;
var Texture PingIcon;

simulated event UpdateScoreBoard(Canvas Canvas)
{
	local KFPlayerReplicationInfo OwnerPRI, KFPRI;
	local int Index, PlayerCount;
	local float EntrySizeY, TempY;
	local float ScoreboardHeaderCenterX;

	Canvas.Style = ERenderStyle.STY_Alpha;

	PlayerCount = 0;
	OwnerPRI = KFPlayerReplicationInfo(KFPlayerController(Owner).PlayerReplicationInfo);
	TempY = ((1.f - ScoreboardSize.Y) * 0.3f) * Canvas.ClipY;
	DrawScoreboardHeader(Canvas, TempY, ((1.f - ScoreboardSize.Y) * 0.25f) * Canvas.ClipY);

	for ( Index = 0; Index < GRI.PRIArray.Length; Index++)
	{
		KFPRI = KFPlayerReplicationInfo(GRI.PRIArray[Index]);

		if (KFPRI.bOnlySpectator)
		{
			continue;
		}

		PlayerCount++;
	}

	if (PlayerCount <= 0)
	{
		return;
	}

	TempY = ((1.f - ScoreboardSize.Y) * 0.5f) * Canvas.ClipY;
	
	EntrySizeY = (ScoreboardSize.Y * Canvas.ClipY) / float(PlayerCount);
	EntrySizeY = Max(Min(EntrySizeY, Canvas.ClipY * 0.035f), 32.f);

	for ( Index = 0; Index < GRI.PRIArray.Length; Index++)
	{
		KFPRI = KFPlayerReplicationInfo(GRI.PRIArray[Index]);

		if (KFPRI.bOnlySpectator)
		{
			continue;
		}

		DrawPlayerEntry(Canvas, KFPRI, EntrySizeY, TempY, OwnerPRI == KFPRI);
		TempY += EntrySizeY * 1.2f;	
	}
}

simulated function DrawScoreboardHeader(Canvas Canvas, float CenterY, float SizeY)
{
	local string DrawString;
	local float TextSizeX, TextSizeY;
	local float CenterX;
	local KF_StoryObjective Objective;

	CenterX = Canvas.ClipX * 0.5f;

	Canvas.DrawColor = Canvas.MakeColor(255, 255, 255, 255);

	//Draw Difficulty
	Canvas.FontScaleX = 1.f;
	Canvas.FontScaleY = 1.f;
	Canvas.Font = class'KFTurboFonts'.static.LoadFontStatic(2);
	DrawString = SkillLevel[Clamp(InvasionGameReplicationInfo(GRI).BaseDifficulty, 0, 7)];
	Canvas.TextSize(DrawString, TextSizeX, TextSizeY);
	Canvas.FontScaleY = (SizeY * 0.125f) / (TextSizeY * 0.5f);
	Canvas.FontScaleX = Canvas.FontScaleY;
	Canvas.TextSize(DrawString, TextSizeX, TextSizeY);
	Canvas.SetPos(CenterX - (TextSizeX * 0.5f), CenterY - (SizeY * 0.25f));
	Canvas.DrawText(DrawString);

	//Draw Map Name
	DrawString = Level.Title;
	Canvas.TextSize(DrawString, TextSizeX, TextSizeY);
	Canvas.SetPos(CenterX - (TextSizeX * 0.5f), CenterY - (SizeY * 0.05f));
	Canvas.DrawText(DrawString);

	//Draw Wave
	if(KF_StoryGRI(GRI) != none)
	{
		Objective = KF_StoryGRI(GRI).GetCurrentObjective();
		if(Objective != none)
		{
			DrawString = Objective.HUD_Header.Header_Text;
		}
	}
	else
	{
		DrawString = WaveString @ (InvasionGameReplicationInfo(GRI).WaveNumber + 1);
	}

	Canvas.TextSize(DrawString, TextSizeX, TextSizeY);
	Canvas.SetPos(CenterX - (TextSizeX * 0.5f), CenterY + (SizeY * 0.15f));
	Canvas.DrawText(DrawString);
	
	//Draw Time
	DrawString = FormatTime(GRI.ElapsedTime);
	Canvas.TextSize(class'TurboHUDOverlay'.static.GetStringOfZeroes(Len(DrawString)), TextSizeX, TextSizeY);
	Canvas.SetPos(CenterX - (TextSizeX * 0.5f), CenterY + (SizeY * 0.35f));
	class'TurboHUDOverlay'.static.DrawCounterTextMeticulous(Canvas, DrawString, TextSizeX, 1.f);
}

simulated function DrawPlayerEntry(Canvas Canvas, KFPlayerReplicationInfo KFPRI, float SizeY, float PositionY, bool bIsLocalPlayer)
{
	local float CenterX, CenterY;
	local float SizeX;
	local float TempX, TempY;
	local Material PerkIcon, PerkStarIcon;
	local float PerkX, PerkY, PerkStarSize;
	local int Index, StarCounter, NumStars;
	local float TextSizeX, TextSizeY;
	local string DrawText;
	local TurboPlayerReplicationInfo TPRI;

	CenterX = Canvas.ClipX * 0.5f;
	CenterY = PositionY + (SizeY * 0.5f);

	SizeX = (ScoreboardSize.X * Canvas.ClipX);
	
	TempX = CenterX - (SizeX * 0.5f);
	Canvas.DrawColor = ScoreboardBackplateColor;

	if (bIsLocalPlayer)
	{
		Canvas.DrawColor.A = 220;
	}

	Canvas.SetPos(TempX, PositionY);
	Canvas.DrawTileScaled(ScoreboardBackplate, ScoreboardSize.X * Canvas.ClipX / float(ScoreboardBackplate.USize), SizeY / float(ScoreboardBackplate.VSize));

	//Draw Perk
	TempX += SizeX * PerkIconOffsetX;
	if (Class<SRVeterancyTypes>(KFPRI.ClientVeteranSkill) != None)
	{
		NumStars = Class<SRVeterancyTypes>(KFPRI.ClientVeteranSkill).static.PreDrawPerk(Canvas, KFPRI.ClientVeteranSkillLevel, PerkIcon, PerkStarIcon);

		Canvas.SetPos(TempX - (SizeX * PerkIconOffsetX), PositionY);
		Canvas.DrawTileScaled(ScoreboardBackplateLeft, SizeY / float(ScoreboardBackplateLeft.USize), SizeY / float(ScoreboardBackplateLeft.VSize));

		Canvas.SetPos(TempX, CenterY - (SizeY * PerkIconSizeY * 0.5f));
		Canvas.DrawTile(PerkIcon, SizeY * PerkIconSizeY, SizeY * PerkIconSizeY, 0, 0, PerkIcon.MaterialUSize(), PerkIcon.MaterialVSize());

		StarCounter = 0;
		PerkStarSize = SizeY * PerkIconSizeY * 0.15f;
		PerkX = TempX + ((SizeY * PerkIconSizeY) - (PerkStarSize * 1.5f));
		PerkY = PositionY + (((SizeY * PerkIconSizeY) - (PerkStarSize * 0.5f)) * 0.75f);

		for ( Index = 0; Index < NumStars; Index++ )
		{
			Canvas.SetPos(PerkX, PerkY - (float(StarCounter) * SizeY * PerkIconSizeY * 0.15f));
			Canvas.DrawTileScaled(PerkStarIcon, PerkStarSize / float(PerkStarIcon.MaterialUSize()), PerkStarSize / float(PerkStarIcon.MaterialVSize()));
			StarCounter++;
		}
	}

	DrawText = "000";

	Canvas.Font = class'KFTurboFonts'.static.LoadFontStatic(3);
	Canvas.FontScaleX = 1.f;
	Canvas.FontScaleY = 1.f;
	Canvas.TextSize(DrawText, TextSizeX, TextSizeY);
	Canvas.FontScaleX = (SizeY * ScoreboardTextY) / TextSizeY;
	Canvas.FontScaleY = Canvas.FontScaleX;

	//Draw Name
	Canvas.DrawColor = ScoreboardTextColor;
	DrawText = KFPRI.PlayerName;
	Canvas.TextSize(DrawText, TextSizeX, TextSizeY);
	TempX = (CenterX - (SizeX * 0.5f)) + (SizeX * UsernameOffsetX);
	TempY = CenterY;
	Canvas.SetPos(TempX, CenterY - (TextSizeY * 0.5f));
	class'TurboHUDOverlay'.static.DrawCounterTextMeticulous(Canvas, DrawText, TextSizeX, 1.f);

	//Draw Kills
	Canvas.DrawColor = KillIconColor;
	TempX = (CenterX - (SizeX * 0.5f)) + (SizeX * KillsOffsetX);
	TempY = CenterY - (SizeY * KillSizeY * 0.5f);
	Canvas.SetPos(TempX - (SizeY * KillSizeY * 0.5f), TempY);
	Canvas.DrawTileScaled(KillIcon, (SizeY * KillSizeY) / float(KillIcon.USize), (SizeY * KillSizeY) / float(KillIcon.VSize));

	Canvas.DrawColor = ScoreboardTextColor;
	DrawText = string(KFPRI.Kills);
	Canvas.TextSize(DrawText, TextSizeX, TextSizeY);
	Canvas.SetPos(TempX - (TextSizeX * 0.5f), CenterY - (TextSizeY * 0.5f));
	class'TurboHUDOverlay'.static.DrawCounterTextMeticulous(Canvas, DrawText, TextSizeX, 1.f);

	Canvas.DrawColor.A = 120;
	DrawText = " ("$KFPRI.KillAssists$")";
	TempX += (TextSizeX * 0.5f);
	Canvas.TextSize(DrawText, TextSizeX, TextSizeY);
	Canvas.SetPos(TempX, CenterY - (TextSizeY * 0.5f));
	class'TurboHUDOverlay'.static.DrawCounterTextMeticulous(Canvas, DrawText, TextSizeX, 1.f);

	//Draw Health
	Canvas.DrawColor = HealthIconColor;
	TempX = (CenterX - (SizeX * 0.5f)) + (SizeX * HealthOffsetX);
	TempY = CenterY - (SizeY * HealthSizeY * 0.5f);
	Canvas.SetPos(TempX - (SizeY * HealthSizeY * 0.5f), TempY);
	Canvas.DrawTileScaled(HealthIcon, (SizeY * HealthSizeY) / float(HealthIcon.USize), (SizeY * HealthSizeY) / float(HealthIcon.VSize));

	Canvas.DrawColor = ScoreboardTextColor;
	DrawText = string(KFPRI.PlayerHealth)$HealthyString;
	Canvas.TextSize(DrawText, TextSizeX, TextSizeY);
	Canvas.SetPos(TempX - (TextSizeX * 0.5f), CenterY - (TextSizeY * 0.5f));
	class'TurboHUDOverlay'.static.DrawCounterTextMeticulous(Canvas, DrawText, TextSizeX, 1.f);

	//Draw Healing
	Canvas.DrawColor = HealedHealthIconColor;
	TempX = (CenterX - (SizeX * 0.5f)) + (SizeX * HealedHealthOffsetX);
	TempY = CenterY - (SizeY * HealedHealthSizeY * 0.5f);
	Canvas.SetPos(TempX - (SizeY * HealedHealthSizeY * 0.5f), TempY);
	Canvas.DrawTileScaled(HealedHealthIcon, (SizeY * HealedHealthSizeY) / float(HealedHealthIcon.USize), (SizeY * HealedHealthSizeY) / float(HealedHealthIcon.VSize));

    TPRI = class'TurboPlayerReplicationInfo'.static.GetTurboPRI(KFPRI);
	Canvas.DrawColor = ScoreboardTextColor;

	if (TPRI != None)
	{
		DrawText = string(TPRI.HealthHealed);
	}
	else
	{
		DrawText = string(0);
	}

	Canvas.TextSize(DrawText, TextSizeX, TextSizeY);
	Canvas.SetPos(TempX - (TextSizeX * 0.5f), CenterY - (TextSizeY * 0.5f));
	class'TurboHUDOverlay'.static.DrawCounterTextMeticulous(Canvas, DrawText, TextSizeX, 1.f);

	//Draw Cash
	Canvas.DrawColor = CashIconColor;
	TempX = (CenterX - (SizeX * 0.5f)) + (SizeX * CashOffsetX);
	TempY = CenterY - (SizeY * CashSizeY * 0.5f);
	Canvas.SetPos(TempX - (SizeY * CashSizeY * 0.5f), TempY);
	Canvas.DrawTileScaled(CashIcon, (SizeY * CashSizeY) / float(CashIcon.USize), (SizeY * CashSizeY) / float(CashIcon.VSize));
	
	Canvas.DrawColor = ScoreboardTextColor;
	DrawText = string(int(KFPRI.Score)) $ class'KFTab_BuyMenu'.default.MoneyCaption;
	Canvas.TextSize(DrawText, TextSizeX, TextSizeY);
	Canvas.SetPos(TempX - (TextSizeX * 0.5f), CenterY - (TextSizeY * 0.5f));
	class'TurboHUDOverlay'.static.DrawCounterTextMeticulous(Canvas, DrawText, TextSizeX, 1.f);

	//Draw Ping
	Canvas.DrawColor = PingIconColor;
	TempX = (CenterX - (SizeX * 0.5f)) + (SizeX * PingOffsetX);
	TempY = CenterY - (SizeY * PingSizeY * 0.5f);
	Canvas.SetPos(TempX - (SizeY * PingSizeY * 0.5f), TempY);
	Canvas.DrawTileScaled(PingIcon, (SizeY * PingSizeY) / float(PingIcon.USize), (SizeY * PingSizeY) / float(PingIcon.VSize));

	Canvas.DrawColor = ScoreboardTextColor;
	DrawText = string(KFPRI.Ping);
	Canvas.TextSize(DrawText, TextSizeX, TextSizeY);
	Canvas.SetPos(TempX - (TextSizeX * 0.5f), CenterY - (TextSizeY * 0.5f));
	class'TurboHUDOverlay'.static.DrawCounterTextMeticulous(Canvas, DrawText, TextSizeX, 1.f);
}

defaultproperties
{
	ScoreboardHeaderSize=(X=0.6f,Y=0.1f)
	ScoreboardSize=(X=0.5f,Y=0.6f)
	ScoreboardBackplateColor=(R=24,G=24,B=24,A=160)
	ScoreboardBackplate=Texture'KFTurbo.Scoreboard.ScoreboardBackplate_D'
	ScoreboardBackplateLeftColor=(R=4,G=4,B=4,A=220)
	ScoreboardBackplateLeft=Texture'KFTurbo.Scoreboard.ScoreboardBackplateLeft_D'

	ScoreboardTextY=0.75f
	ScoreboardTextColor=(R=255,G=255,B=255,A=220)

	PerkIconOffsetX=0.005f
	PerkIconSizeY=1.f
	
	UsernameSizeY=0.8f
	UsernameOffsetX=0.05f

	HealthOffsetX=0.275f
	HealthSizeY=1.f
	HealthIconColor=(R=0,G=0,B=0,A=200)
	HealthIcon=Texture'KFTurbo.Scoreboard.ScoreboardHealth_D'

	HealedHealthOffsetX=0.625f
	HealedHealthSizeY=0.925f
	HealedHealthIconColor=(R=0,G=0,B=0,A=200)
	HealedHealthIcon=Texture'KFTurbo.Ammo.SyringeIcon_D'

	KillsOffsetX=0.45f
	KillSizeY=1.f
	KillIconColor=(R=0,G=0,B=0,A=200)
	KillIcon=Texture'KFTurbo.Scoreboard.ScoreboardKill_D'

	CashOffsetX=0.8f
	CashSizeY=1.125f
	CashIconColor=(R=0,G=0,B=0,A=200)
	CashIcon=Texture'KFTurbo.Scoreboard.ScoreboardCash_D'

	PingOffsetX = 0.975f
	PingSizeY = 0.95f
	PingIconColor=(R=0,G=0,B=0,A=200)
	PingIcon=Texture'KFTurbo.Scoreboard.ScoreboardPing_D'
}