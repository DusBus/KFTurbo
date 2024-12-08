class TurboInteraction extends Engine.Interaction
	dependson(TurboPlayerMarkReplicationInfo)
	dependson(TurboRepLink)
	config(KFTurbo);

var globalconfig bool bTraderBindingInitialized;
var globalconfig bool bMarkActorBindingInitialized;
var globalconfig TurboPlayerMarkReplicationInfo.EMarkColor MarkColor;

var bool bHasInitializedPerkTierPreference;
var globalconfig array<TurboRepLink.VeterancyTierPreference> PerkTierPreferenceList;

exec simulated function Trade()
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

exec simulated function SetMarkColor(TurboPlayerMarkReplicationInfo.EMarkColor Color)
{
	MarkColor = Color;
	SaveConfig();
}

exec simulated function MarkActor(optional TurboPlayerMarkReplicationInfo.EMarkColor Color)
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

simulated function CheckForVoiceCommandMark(Name Type, int Index)
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

simulated function SetVeterancyTierPreference(class<TurboVeterancyTypes> PerkClass, int TierPreference)
{
	local TurboRepLink TurboRepLink;

	TierPreference = Min(TierPreference, 7);
	switch(PerkClass)
	{
		case class'V_FieldMedic':
			PerkTierPreferenceList[0].TierPreference = TierPreference;
			break;
		case class'V_SupportSpec':
			PerkTierPreferenceList[1].TierPreference = TierPreference;
			break;
		case class'V_Sharpshooter':
			PerkTierPreferenceList[2].TierPreference = TierPreference;
			break;
		case class'V_Commando':
			PerkTierPreferenceList[3].TierPreference = TierPreference;
			break;
		case class'V_Berserker':
			PerkTierPreferenceList[4].TierPreference = TierPreference;
			break;
		case class'V_Firebug':
			PerkTierPreferenceList[5].TierPreference = TierPreference;
			break;
		case class'V_Demolitions':
			PerkTierPreferenceList[6].TierPreference = TierPreference;
			break;
		default:
			return;
	}

	TurboRepLink = TurboPlayerController(ViewportOwner.Actor).GetTurboRepLink();
	if (TurboRepLink == None)
	{
		return;
	}

	TurboRepLink.SetVeterancyTierPreference(PerkClass, TierPreference);
	SaveConfig();
}

simulated function bool InitializeVeterancyTierPreferences()
{
	local int Index;
	local TurboRepLink TurboRepLink;

	TurboRepLink = TurboPlayerController(ViewportOwner.Actor).GetTurboRepLink();

	if (TurboRepLink == None)
	{
		return false;
	}

	//Somehow we nuked the list. Reset it.
	if (PerkTierPreferenceList.Length == 0)
	{
		PerkTierPreferenceList = default.PerkTierPreferenceList;
	}

	for (Index = 0; Index < PerkTierPreferenceList.Length; Index++)
	{
		TurboRepLink.SetVeterancyTierPreference(PerkTierPreferenceList[Index].PerkClass, PerkTierPreferenceList[Index].TierPreference);
	}

	bHasInitializedPerkTierPreference = true;
	return true;
}

defaultproperties
{
	bNativeEvents=true
	
	bHasInitializedPerkTierPreference=false
	PerkTierPreferenceList(0)=(PerkClass=class'V_FieldMedic',TierPreference=7)
	PerkTierPreferenceList(1)=(PerkClass=class'V_SupportSpec',TierPreference=7)
	PerkTierPreferenceList(2)=(PerkClass=class'V_Sharpshooter',TierPreference=7)
	PerkTierPreferenceList(3)=(PerkClass=class'V_Commando',TierPreference=7)
	PerkTierPreferenceList(4)=(PerkClass=class'V_Berserker',TierPreference=7)
	PerkTierPreferenceList(5)=(PerkClass=class'V_Firebug',TierPreference=7)
	PerkTierPreferenceList(6)=(PerkClass=class'V_Demolitions',TierPreference=7)
}