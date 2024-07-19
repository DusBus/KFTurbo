class KFTurboFonts extends Object;

#exec new TrueTypeFontFactory Name=BahnschriftNumbers134 FontName="Bahnschrift Regular" Height=134 Chars="0123456789:/" AntiAlias=1 XPad=4
#exec new TrueTypeFontFactory Name=BahnschriftNumbers110 FontName="Bahnschrift Regular" Height=110 Chars="0123456789:/" AntiAlias=1 XPad=4
#exec new TrueTypeFontFactory Name=BahnschriftNumbers72 FontName="Bahnschrift Regular" Height=72 Chars="0123456789:/" AntiAlias=1 XPad=4
#exec new TrueTypeFontFactory Name=Bahnschrift48 FontName="Bahnschrift Regular" Height=48 AntiAlias=1 XPad=2
#exec new TrueTypeFontFactory Name=Bahnschrift36 FontName="Bahnschrift Regular" Height=36 AntiAlias=1 XPad=2
#exec new TrueTypeFontFactory Name=Bahnschrift24 FontName="Bahnschrift Regular" Height=24 AntiAlias=1 XPad=2
#exec new TrueTypeFontFactory Name=Bahnschrift18 FontName="Bahnschrift Regular" Height=18 AntiAlias=1 XPad=2
#exec new TrueTypeFontFactory Name=Bahnschrift12 FontName="Bahnschrift Regular" Height=12 AntiAlias=1 XPad=2
#exec new TrueTypeFontFactory Name=Bahnschrift9 FontName="Bahnschrift Regular" Height=9 AntiAlias=1 XPad=2

#exec new TrueTypeFontFactory Name=BahnschriftSemiLight36 FontName="Bahnschrift SemiLight Condensed" Height=36 AntiAlias=1 XPad=2 Kerning=1
#exec new TrueTypeFontFactory Name=BahnschriftSemiLight24 FontName="Bahnschrift SemiLight Condensed" Height=24 AntiAlias=1 XPad=2 Kerning=1
#exec new TrueTypeFontFactory Name=BahnschriftSemiLight18 FontName="Bahnschrift SemiLight Condensed" Height=18 AntiAlias=1 XPad=2 Kerning=1
#exec new TrueTypeFontFactory Name=BahnschriftSemiLight12 FontName="Bahnschrift SemiLight Condensed" Height=12 AntiAlias=1 XPad=2 Kerning=1
#exec new TrueTypeFontFactory Name=BahnschriftSemiLight12DropShadow FontName="Bahnschrift SemiLight Condensed" Height=9 AntiAlias=1 XPad=2 Kerning=1 DropShadowX=1 DropShadowY=1
#exec new TrueTypeFontFactory Name=BahnschriftSemiLight9 FontName="Bahnschrift SemiLight Condensed" Height=9 AntiAlias=1 XPad=2 Kerning=1 DropShadowX=1 DropShadowY=1

var	localized string HUDLargeFontNames[8];
var	Font HUDLargeFonts[8];

var	localized string HUDFontArrayNames[9];
var	Font HUDFontArrayFonts[9];

static function Font LoadLargeNumberFont(int i)
{
	if (default.HUDLargeFonts[i] == none)
	{
		default.HUDLargeFonts[i] = Font(DynamicLoadObject(default.HUDLargeFontNames[i], class'Font'));
		if (default.HUDLargeFonts[i] == none)
			Log("Warning: "$default.Class$" Couldn't dynamically load font "$default.HUDLargeFontNames[i]);
	}

	return default.HUDLargeFonts[i];
}

static function Font LoadFontStatic(int i)
{
	if( default.HUDFontArrayFonts[i] == None )
	{
		default.HUDFontArrayFonts[i] = Font(DynamicLoadObject(default.HUDFontArrayNames[i], class'Font'));
		if( default.HUDFontArrayFonts[i] == None )
			Log("Warning: "$default.Class$" Couldn't dynamically load font "$default.HUDFontArrayNames[i]);
	}

	return default.HUDFontArrayFonts[i];
}

defaultproperties
{
	HUDLargeFontNames(0)="KFTurboFonts.BahnschriftNumbers134"
	HUDLargeFontNames(1)="KFTurboFonts.BahnschriftNumbers110"
	HUDLargeFontNames(2)="KFTurboFonts.BahnschriftNumbers72"
	HUDLargeFontNames(3)="KFTurboFonts.Bahnschrift48"
	HUDLargeFontNames(4)="KFTurboFonts.Bahnschrift36"
	HUDLargeFontNames(5)="KFTurboFonts.Bahnschrift24"
	HUDLargeFontNames(6)="KFTurboFonts.Bahnschrift18"
	HUDLargeFontNames(7)="KFTurboFonts.Bahnschrift12"

	HUDFontArrayNames(0)="KFTurboFonts.BahnschriftSemiLight36"
	HUDFontArrayNames(1)="KFTurboFonts.BahnschriftSemiLight36"
	HUDFontArrayNames(2)="KFTurboFonts.BahnschriftSemiLight24"
	HUDFontArrayNames(3)="KFTurboFonts.BahnschriftSemiLight24"
	HUDFontArrayNames(4)="KFTurboFonts.BahnschriftSemiLight18"
	HUDFontArrayNames(5)="KFTurboFonts.BahnschriftSemiLight18"
	HUDFontArrayNames(6)="KFTurboFonts.BahnschriftSemiLight12"
	HUDFontArrayNames(7)="KFTurboFonts.BahnschriftSemiLight12DropShadow"
	HUDFontArrayNames(8)="KFTurboFonts.BahnschriftSemiLight9"


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
