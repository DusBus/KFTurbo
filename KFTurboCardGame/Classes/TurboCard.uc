//Killing Floor Turbo TurboCard
//Base class for selectable cards.
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboCard extends Object
	instanced;

//Set during deck initialization. Used so that the server has an easier time figuring out how to tell the clients what card this is.
var class<TurboCardDeck> DeckClass;
var int CardIndex;

var localized array<string> CardName;
var localized array<string> CardDescriptionList;
var Texture CardIcon;
var bool bCanEverRepeat;

var Texture BackplateTexture;
var Texture BackplateMaskTexture;
var Texture LargeBackplateMaskTexture;
var Color BackplateColor;

var Color CardNameColor;
var Color CardDescriptionColor;
var Color CardTextShadowColor;

//Text modification
var bool bCardNameAllCaps;
var bool bCardDescriptionAllCaps;

var Color CardIDColor;

delegate OnActivateCard(TurboCardReplicationInfo CGRI);

static function int GetTitleFontSize(ScriptedTexture Tex)
{
	if (Tex.USize >= 512)
	{
		return 2;
	}

	return 4;
}

static function int GetTextFontSize(ScriptedTexture Tex)
{
	if (Tex.USize >= 512)
	{
		return 2;
	}

	return 4;
}

static function int GetSubTitleFontSize(ScriptedTexture Tex)
{
	if (Tex.USize >= 512)
	{
		return 5;
	}

	return 7;
}

static function float GetTitleShadowOffset(ScriptedTexture Tex)
{
	if (Tex.USize >= 512)
	{
		return 6.f;
	}

	return 3.f;
}

static function float GetTextShadowOffset(ScriptedTexture Tex)
{
	if (Tex.USize >= 512)
	{
		return 4.f;
	}

	return 2.f;
}

function SetupScriptedTexture(ScriptedTexture Tex)
{
	local float TempX, TempY;
	local float SizeX, SizeY;
	local int TextSizeX, TextSizeY;
	local Font TextFont;

	local string FullTitleString;

	//Draw card backplate.
	Tex.DrawTile(0, 0, Tex.USize, Tex.VSize, 0, 0, BackplateTexture.USize, BackplateTexture.VSize, BackplateTexture, BackplateColor);

	SizeX = Tex.USize;
	SizeY = Tex.VSize;

	FullTitleString = ApplyTitle(Tex);
	
	ApplyDescription(Tex);

	FullTitleString = Caps(FullTitleString@"| Killing Floor Turbo");
	TextFont = class'KFTurboFontHelper'.static.LoadFontStatic(GetSubTitleFontSize(Tex));
	Tex.TextSize(FullTitleString, TextFont, TextSizeX, TextSizeY);
	TempX = (SizeX * 0.92f) - TextSizeX;
	TempY = (SizeY * 0.8835f) - (TextSizeY);
	Tex.DrawText(TempX, TempY, FullTitleString, TextFont, CardIDColor);
}

function GetCardTitle(out array<string> Title)
{
	local int TitleIndex;

	Title = CardName;

	for (TitleIndex = 0; TitleIndex < Title.Length; TitleIndex++)
	{
		if (bCardNameAllCaps)
		{
			Title[TitleIndex] = Caps(Title[TitleIndex]);
		}
	}
}

function string ApplyTitle(ScriptedTexture Tex)
{
	local array<string> FullTitleString;
	local string StrippedTitleString;
	local string TitleString;

	local float TempX, TempY;
	local int TextSizeX, TextSizeY;
	local float TextLineBreakSize;
	local Font TextFont;
	local float ShadowOffset;
	local int TitleIndex;

	GetCardTitle(FullTitleString);
	TitleString = "";
	ShadowOffset = GetTitleShadowOffset(Tex);

	if (FullTitleString.Length != 0)
	{
		TextFont = class'KFTurboFontHelper'.static.LoadBoldFontStatic(GetTitleFontSize(Tex));
		Tex.TextSize(FullTitleString[0], TextFont, TextSizeX, TextSizeY);

		//Space from top of texture to top of card + card margin + half of card header size
		TempY = float(Tex.VSize) * 0.218f;
		TextLineBreakSize = 0.8f ** (FullTitleString.Length - 1);
		TempY = TempY - (TextSizeY * float(CardName.Length) * TextLineBreakSize * 0.5f);

		for (TitleIndex = 0; TitleIndex < CardName.Length; TitleIndex++)
		{
			StrippedTitleString = class'GUIComponent'.static.StripColorCodes(FullTitleString[TitleIndex]);
			TitleString = TitleString @ StrippedTitleString;

			Tex.TextSize(StrippedTitleString, TextFont, TextSizeX, TextSizeY);
			TempX = (float(Tex.USize) * 0.5f) - (float(TextSizeX) * 0.5f);
			Tex.DrawText(TempX + ShadowOffset, TempY + ShadowOffset, StrippedTitleString, TextFont, CardTextShadowColor);
			Tex.DrawText(TempX, TempY, FullTitleString[TitleIndex], TextFont, CardNameColor);
			TempY += float(TextSizeY) * TextLineBreakSize;
		}
	}

	return TitleString;
}

function GetCardDescription(out array<string> Description)
{
	local int DescriptionIndex;
	
	Description = CardDescriptionList;

	for (DescriptionIndex = 0; DescriptionIndex < Description.Length; DescriptionIndex++)
	{
		if (bCardDescriptionAllCaps)
		{
			Description[DescriptionIndex] = Caps(Description[DescriptionIndex]);
		}
	}
}

function ApplyDescription(ScriptedTexture Tex)
{
	local array<string> FullDescriptionString;
	local string StrippedDescriptionString;

	local float TempX, TempY;
	local int TextSizeX, TextSizeY;
	local Font TextFont;
	local float ShadowOffset;
	local int DescriptionIndex;

	GetCardDescription(FullDescriptionString);
	ShadowOffset = GetTextShadowOffset(Tex);

	if (FullDescriptionString.Length != 0)
	{
		TextFont = class'KFTurboFontHelper'.static.LoadFontStatic(GetTextFontSize(Tex));
		Tex.TextSize(FullDescriptionString[0], TextFont, TextSizeX, TextSizeY);

		//Space from top of texture to top of card + card margin + half of card header size
		TempY = float(Tex.VSize) * 0.586f;
		TempY = TempY - (TextSizeY * float(FullDescriptionString.Length) * 0.4f);

		for (DescriptionIndex = 0; DescriptionIndex < FullDescriptionString.Length; DescriptionIndex++)
		{
			StrippedDescriptionString = class'GUIComponent'.static.StripColorCodes(FullDescriptionString[DescriptionIndex]);

			Tex.TextSize(FullDescriptionString[DescriptionIndex], TextFont, TextSizeX, TextSizeY);
			TempX = (float(Tex.USize) * 0.5f) - (float(TextSizeX) * 0.5f);
			Tex.DrawText(TempX + ShadowOffset, TempY + ShadowOffset, StrippedDescriptionString, TextFont, CardTextShadowColor);
			Tex.DrawText(TempX, TempY, FullDescriptionString[DescriptionIndex], TextFont, CardDescriptionColor);
			TempY += float(TextSizeY) * 0.8f;
		}
	}
}

defaultproperties
{
	bCanEverRepeat=false

	BackplateTexture=Texture'KFTurboCardGame.Card.CardBackplate_D'
	BackplateMaskTexture=Texture'KFTurboCardGame.Card.CardBackplate_D'
	LargeBackplateMaskTexture=Texture'KFTurboCardGame.Card.CardBackplate_Large_D'
	BackplateColor=(R=255,G=255,B=255,A=255)
	
	CardNameColor=(R=0,G=0,B=0,A=255)
	CardDescriptionColor=(R=0,G=0,B=0,A=255)
	CardIDColor=(R=0,G=0,B=0,A=100)
}