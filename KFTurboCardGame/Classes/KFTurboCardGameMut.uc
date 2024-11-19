//Killing Floor Turbo KFTurboCardGameMut
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class KFTurboCardGameMut extends Mutator
		config(KFTurboCardGame);

#exec obj load file="..\Textures\TurboCardGame.utx" package=KFTurboCardGame

var TurboCardReplicationInfo TurboCardReplicationInfo;
var TurboCardGameModifierRepLink TurboCardGameModifier;
var TurboCardClientModifierRepLink TurboCardClientModifier;
var CardGameRules CardGameRules;

var globalconfig string TurboGoodDeckClassOverrideString;
var globalconfig string TurboSuperDeckClassOverrideString;
var globalconfig string TurboProConDeckClassOverrideString;
var globalconfig string TurboEvilDeckClassOverrideString;

function PostBeginPlay()
{
	AddToPackageMap("KFTurbo");
	AddToPackageMap("KFTurboCardGame");

	TurboCardReplicationInfo = CreateTurboCardReplicationInfo();
	CardGameRules = CreateCardGameRules();

	Super.PostBeginPlay();

	AttemptModifyGameLength();
}

//Make game 14 waves long, with first few waves being very small.
function AttemptModifyGameLength()
{
	if (KFGameType(Level.Game) == None)
	{
		return;
	}

	class'TurboWaveEventHandler'.static.RegisterWaveHandler(Self, class'CardGameWaveEventHandler');
	KFTurboGameType(Level.Game).SetFinalWaveOverride(14);
}

function TurboCardReplicationInfo CreateTurboCardReplicationInfo()
{
	local TurboCardReplicationInfo TCRI;
	TCRI = Spawn(class'TurboCardReplicationInfo', Self);
	TCRI.Initialize(Self);
	return TCRI;
}

function CardGameRules CreateCardGameRules()
{
	local CardGameRules CGR;
	CGR = Spawn(class'CardGameRules', Self);
	CGR.MutatorOwner = Self;
    CGR.NextGameRules = Level.Game.GameRulesModifiers;
    Level.Game.GameRulesModifiers = CGR;
	return CGR;	
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	if (KFPlayerReplicationInfo(Other) != None)
	{
		AddCardGamePlayerReplicationInfo(KFPlayerReplicationInfo(Other));
	}

	if (TurboGameReplicationInfo(Other) != None)
	{
		AddTurboCardGameModifier(TurboGameReplicationInfo(Other));
	}
	
	if (CardGameRules != None)
	{
		CardGameRules.ModifyActor(Other);
	}

	return true;
}

function AddCardGamePlayerReplicationInfo(KFPlayerReplicationInfo PlayerReplicationInfo)
{
	local CardGamePlayerReplicationInfo CardGamePRI;
	CardGamePRI = Spawn(class'CardGamePlayerReplicationInfo', PlayerReplicationInfo.Owner);
	CardGamePRI.NextReplicationInfo = PlayerReplicationInfo.CustomReplicationInfo;
	CardGamePRI.OwningReplicationInfo = PlayerReplicationInfo;
	CardGamePRI.TurboCardReplicationInfo = TurboCardReplicationInfo;
	PlayerReplicationInfo.CustomReplicationInfo = CardGamePRI;
}

function AddTurboCardGameModifier(TurboGameReplicationInfo TGRI)
{
	TurboCardGameModifier = Spawn(class'TurboCardGameModifierRepLink', TGRI);
	TurboCardGameModifier.OwnerGRI = TGRI;
	TurboCardGameModifier.NextGameModifierLink = TGRI.CustomTurboModifier;
	TGRI.CustomTurboModifier = TurboCardGameModifier;

	TurboCardClientModifier = Spawn(class'TurboCardClientModifierRepLink', TGRI);
	TurboCardClientModifier.OwnerGRI = TGRI;
	TurboCardClientModifier.NextClientModifierLink = TGRI.CustomTurboClientModifier;
	TGRI.CustomTurboClientModifier = TurboCardClientModifier;
}

function ModifyPlayer(Pawn Other)
{
	Super.ModifyPlayer(Other);
	
	if (CardGameRules != None)
	{
		CardGameRules.ModifyPlayer(Other);
	}
}

simulated function String GetHumanReadableName()
{
	return FriendlyName;
}

defaultproperties
{
	bAddToServerPackages=True
	GroupName="KF-CardGame"
	FriendlyName="Killing Floor Turbo Card Game"
	Description="Killing Floor Turbo's card game mutator. Before each wave, users are asked to vote between a selection of gameplay modifiers (cards)."
}
