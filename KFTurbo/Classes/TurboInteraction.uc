class TurboInteraction extends Engine.Interaction
	dependson(TurboPlayerMarkReplicationInfo)
	config(KFTurbo);

var globalconfig bool bTraderBindingInitialized;
var globalconfig bool bMarkActorBindingInitialized;
var globalconfig TurboPlayerMarkReplicationInfo.EMarkColor MarkColor;

simulated function ApplyTurboKeybinds()
{
	if (ViewportOwner == None || ViewportOwner.Actor == None)
	{
		return;
	}

	if (class'KFTurboGameType'.static.StaticIsHighDifficulty(ViewportOwner.Actor))
	{
		ApplyTraderKeybind();
	}

	ApplyMarkActorKeybind();
}

final function bool SetOrAppendCommandToKey(String Key, String Command)
{
	local String GetInputResult, CapsGetInputResult;

	GetInputResult = ViewportOwner.Actor.ConsoleCommand("get input"@Key);
	CapsGetInputResult = Caps(GetInputResult);

	while (CapsGetInputResult != "" && Left(CapsGetInputResult, 1) == " ")
	{
		CapsGetInputResult = Right(CapsGetInputResult, Len(CapsGetInputResult) - 1);
	}

	while (CapsGetInputResult != "" && Right(CapsGetInputResult, 1) == " ")
	{
		CapsGetInputResult = Left(CapsGetInputResult, Len(CapsGetInputResult) - 1);
	}

	if (CapsGetInputResult == Caps(Command))
	{
		return false;
	}

	if (InStr(CapsGetInputResult, Caps(Command)@"|") == 0 || InStr(CapsGetInputResult, "|"@Caps(Command)) != -1)
	{
		return false;
	}
	
	ViewportOwner.Actor.ConsoleCommand("set input"@Key@GetInputResult@"|"@Command);
	
	return true;
}

simulated function ApplyTraderKeybind()
{
	if (bTraderBindingInitialized)
	{
		return;
	}

	bTraderBindingInitialized = true;

	if (!SetOrAppendCommandToKey("H", "Trade"))
	{
		return;
	}

	ViewportOwner.Actor.ClientMessage("Welcome to KFTurbo+. Your keybind to open trader has been initialized to the H key.");
}

simulated function ApplyMarkActorKeybind()
{
	if (bMarkActorBindingInitialized)
	{
		return;
	}

	bMarkActorBindingInitialized = true;

	if (!SetOrAppendCommandToKey("X", "MarkActor"))
	{
		return;
	}

	if (class'KFTurboGameType'.static.StaticIsHighDifficulty(ViewportOwner.Actor))
	{
		ViewportOwner.Actor.ClientMessage("Welcome to KFTurbo+. Your keybind to mark actors has been initialized to the X key.");
	}
	else
	{
		ViewportOwner.Actor.ClientMessage("Welcome to KFTurbo. Your keybind to mark actors has been initialized to the X key.");
	}
}

exec function Trade()
{
	if (ViewportOwner == None || ViewportOwner.Actor == None || ViewportOwner.Actor.Pawn == None)
	{
		return;
	}

	if (!class'KFTurboGameType'.static.StaticIsHighDifficulty(ViewportOwner.Actor))
	{
		return;
	}

	if (KFHumanPawn(ViewportOwner.Actor.Pawn) == None || ViewportOwner.Actor.Pawn.Health <= 0.f)
	{
		return;
	}

	if (KFGameReplicationInfo(ViewportOwner.Actor.Level.GRI) == None || KFGameReplicationInfo(ViewportOwner.Actor.Level.GRI).bWaveInProgress)
	{
		return;
	}

	ViewportOwner.GUIController.CloseMenu();
	KFPlayerController(ViewportOwner.Actor).ShowBuyMenu("WeaponLocker", KFHumanPawn(ViewportOwner.Actor.Pawn).MaxCarryWeight);
}

exec function SetMarkColor(TurboPlayerMarkReplicationInfo.EMarkColor Color)
{
	MarkColor = Color;
	SaveConfig();
}

exec function MarkActor(optional TurboPlayerMarkReplicationInfo.EMarkColor Color)
{
	local Vector HitLocation, HitNormal;
	local Vector StartMarkTrace, X, Y, Z;
	local Vector EndMarkTrace;
	local Actor Actor;

	if (TurboPlayerController(ViewportOwner.Actor) == None)
	{
		return;
	}

	if (KFHumanPawn(ViewportOwner.Actor.Pawn) == None || ViewportOwner.Actor.Pawn.Health <= 0.f || ViewportOwner.Actor.Pawn.Weapon == None)
	{
		return;
	}

	if (KFGameReplicationInfo(ViewportOwner.Actor.Level.GRI) == None)
	{
		return;
	}
	
	if (Color == Invalid)
	{
		Color = MarkColor;
	}

	StartMarkTrace = ViewportOwner.Actor.Pawn.Location + ViewportOwner.Actor.Pawn.EyePosition();
	ViewportOwner.Actor.Pawn.Weapon.GetViewAxes(X, Y, Z);
	
	EndMarkTrace = StartMarkTrace + (X * 500.f);

	Actor = ViewportOwner.Actor.Pawn.Trace(HitLocation, HitNormal, EndMarkTrace, StartMarkTrace, true, vect(10, 10, 10));

	if (Actor != None)
	{
		TurboPlayerController(ViewportOwner.Actor).AttemptMarkActor(StartMarkTrace, HitLocation, Actor, None, -1, MarkColor);
		return;
	}
	
	EndMarkTrace += (X * 1000.f);
	Actor = ViewportOwner.Actor.Pawn.Trace(HitLocation, HitNormal, EndMarkTrace, StartMarkTrace, true, vect(5, 5, 5));

	if (Actor != None)
	{
		TurboPlayerController(ViewportOwner.Actor).AttemptMarkActor(StartMarkTrace, HitLocation, Actor, None, -1, MarkColor);
		return;
	}

	EndMarkTrace += (X * 1000.f);
	Actor = ViewportOwner.Actor.Pawn.Trace(HitLocation, HitNormal, EndMarkTrace, StartMarkTrace, true, vect(2, 2, 2));

	if (Actor != None)
	{
		TurboPlayerController(ViewportOwner.Actor).AttemptMarkActor(StartMarkTrace, HitLocation, Actor, None, -1, MarkColor);
		return;
	}
}

function CheckForVoiceCommandMark(Name Type, int Index)
{
	local int VoiceCommandMarkData;

	if (Type == 'ALERT' && Index == 0)
	{
		MarkActor(Invalid);
		return;
	}

	VoiceCommandMarkData = class'TurboMarkerType_VoiceCommand'.static.GetGenerateMarkerDataFromVoiceCommand(Type, Index);
	
	if (VoiceCommandMarkData == -1)
	{
		return;
	}

	//Mark the pawn with this data.
	TurboPlayerController(ViewportOwner.Actor).AttemptMarkActor(ViewportOwner.Actor.Pawn.Location, ViewportOwner.Actor.Pawn.Location, ViewportOwner.Actor.Pawn, class'TurboMarkerType_VoiceCommand', VoiceCommandMarkData, MarkColor);
}

defaultproperties
{
	bNativeEvents=true
}