//Killing Floor Turbo TurboCardActor
//Client-only actor. Responsible for doing CardScriptedTexture rendering so that the UI can use it.
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboCardActor extends Info;

var TurboCard Card, LastRenderedCard;
var bool bIsActiveCard;

var TurboCardScriptedTexture CardScriptedTexture;
var TurboCardTexRotator CardOpacity;
var TurboCardTexRotator CardDiffuse;
var TurboCardShader CardShader;
var Texture MaskTexture;

function PostBeginPlay()
{
    Super.PostBeginPlay();

	CardScriptedTexture = TurboCardScriptedTexture(Level.ObjectPool.AllocateObject(class'TurboCardScriptedTexture'));
	CardScriptedTexture.SetSize(256, 512);
	CardScriptedTexture.Client = self;
	
	CardOpacity = TurboCardTexRotator(Level.ObjectPool.AllocateObject(class'TurboCardTexRotator'));
	CardDiffuse = TurboCardTexRotator(Level.ObjectPool.AllocateObject(class'TurboCardTexRotator'));
	CardShader = TurboCardShader(Level.ObjectPool.AllocateObject(class'TurboCardShader'));
	CardShader.Diffuse = CardDiffuse;
	CardShader.Opacity = CardOpacity;

	RandomizeOscillation();
}

function RandomizeOscillation()
{
	local float Multiplier;
	local TurboHUDOverlay.Vector2D PhaseOffset;

	Multiplier = (FRand() * 0.4f) + 0.6f;

	PhaseOffset.X = FRand() * 10.f;
	PhaseOffset.Y = FRand() * 10.f;

	if (FRand() > 0.5f)
	{
		Multiplier *= -1.f;
	}

	CardOpacity.Initialize(MaskTexture, Multiplier, PhaseOffset);
	CardDiffuse.Initialize(CardScriptedTexture, Multiplier, PhaseOffset);
}

function SetCardClass(TurboCard NewCard)
{
	Card = NewCard;
	if (Card == None)
	{
		return;
	}

	RandomizeOscillation();

	//Update mask material to backplate.
	MaskTexture = Card.BackplateTexture;
	if (CardOpacity != None)
	{
		CardOpacity.Material = MaskTexture;
	}
}

function RenderOverlays(Canvas Canvas)
{
	if (LastRenderedCard != Card)
	{
		CardScriptedTexture.Revision++;
		LastRenderedCard = Card;
	}

	CardScriptedTexture.Client = Self;
	Super.RenderOverlays(Canvas);
}

simulated event RenderTexture(ScriptedTexture ScriptedTexture)
{
	if (Card != None)
	{
		Card.SetupScriptedTexture(ScriptedTexture);
		CardScriptedTexture.bCardReady = true;
	}
}

simulated event Destroyed()
{
	if (CardScriptedTexture != None)
	{
		CardScriptedTexture.Reset();
		Level.ObjectPool.FreeObject(CardScriptedTexture);
	}

	if (CardOpacity != None)
	{
		CardOpacity.Reset();
		Level.ObjectPool.FreeObject(CardOpacity);
	}

	if (CardDiffuse != None)
	{
		CardDiffuse.Reset();
		Level.ObjectPool.FreeObject(CardDiffuse);
	}

	if (CardShader != None)
	{
		CardShader.Reset();
		Level.ObjectPool.FreeObject(CardShader);
	}

	Super.Destroyed();
}

defaultproperties
{
	bIsActiveCard=false
}
