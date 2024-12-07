class TurboPlayerController extends KFPCServ;

var private ClientPerkRepLink ClientPerkRepLink;	
var private TurboRepLink TurboRepLink;
var class<WeaponRemappingSettings> WeaponRemappingSettings;
var TurboInteraction TurboInteraction;
var TurboChatInteraction TurboChatInteraction;

var float ClientNextMarkTime, NextMarkTime;

var bool bInLoginMenu, bHasClosedLoginMenu;
var float LoginMenuTime;

replication
{
	reliable if( Role == ROLE_Authority )
		ClientCloseBuyMenu;
	reliable if( Role < ROLE_Authority )
		ServerDebugSkipWave, EndTrader, ServerMarkActor, ServerNotifyShoppingState, ServerNotifyLoginMenuState;
}

simulated function PostBeginPlay()
{
	//For some reason this really does not like getting set!
	if (class<TurboPlayerReplicationInfo>(PlayerReplicationInfoClass) == None)
	{
		PlayerReplicationInfoClass = class'TurboPlayerReplicationInfo';
	}

	Super.PostBeginPlay();

	if (Role != ROLE_Authority)
	{
		//Spin up CPRL fixer
		Spawn(class'TurboRepLinkFix', Self);
	}
}

simulated function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);

	if (LoginMenuTime >= 0.f && (LoginMenuTime < Level.TimeSeconds) && IsLocalPlayerController())
	{
		ServerNotifyLoginMenuState(false);
		LoginMenuTime = -1.f;
	}
}

simulated final function bool IsLocalPlayerController()
{
	return Viewport(Player) != None;
}

function ClientPerkRepLink GetClientPerkRepLink()
{
	if (ClientPerkRepLink == none)
	{
		ClientPerkRepLink = Class'ClientPerkRepLink'.Static.FindStats(Self);
	}

	return ClientPerkRepLink;
}

function TurboRepLink GetTurboRepLink()
{
	if (TurboRepLink == none)
	{
		TurboRepLink = class'TurboRepLink'.static.FindTurboRepLink(PlayerReplicationInfo);
	}

	return TurboRepLink;
}

simulated function SetupTurboInteraction()
{
	if (Level.NetMode == NM_DedicatedServer)
	{
		return;
	}

	if (TurboInteraction == None)
	{
		TurboInteraction = TurboInteraction(Player.InteractionMaster.AddInteraction("KFTurbo.TurboInteraction", Player));
	}

	if (TurboChatInteraction == None)
	{
		TurboChatInteraction = TurboChatInteraction(Player.InteractionMaster.AddInteraction("KFTurbo.TurboChatInteraction", Player));
	}
}

function ServerNotifyShoppingState(bool bNewShoppingState)
{
	if (KFGameType(Level.Game) == None || KFGameType(Level.Game).bWaveInProgress)
	{
		bNewShoppingState = false;
	}

	bShopping = bNewShoppingState;
}

//Holding escape would allow for people to spam the server with the ServerNotifyLoginMenuState RPC inadvertently...
simulated function SetLoginMenuState(bool bNewLoginMenuState)
{
	if (bNewLoginMenuState)
	{
		if (bHasClosedLoginMenu)
		{
			ServerNotifyLoginMenuState(true);
			LoginMenuTime = -1.f;
			bHasClosedLoginMenu = false;
		}
	}
	else
	{
		LoginMenuTime = Level.TimeSeconds + 1.f;
		bHasClosedLoginMenu = true;
	}
}

function ServerNotifyLoginMenuState(bool bNewLoginMenuState)
{
	bInLoginMenu = bNewLoginMenuState;
}

simulated function ClientSetHUD(class<HUD> newHUDClass, class<Scoreboard> newScoringClass )
{
	if (class'KFTurboMut'.static.GetHUDReplacementClass(string(newHUDClass)) ~= string(class'KFTurbo.TurboHUDKillingFloor'))
	{
		Super.ClientSetHUD(class'KFTurbo.TurboHUDKillingFloor', newScoringClass);
	}
	else
	{
		Super.ClientSetHUD(newHUDClass, newScoringClass);
	}
}

event ClientOpenMenu(string Menu, optional bool bDisconnect,optional string Msg1, optional string Msg2)
{
	//Attempt fix weird issue where wrong login menu is present.
	if (Menu ~= string(class'ServerPerks.SRInvasionLoginMenu') || Menu ~= string(class'KFGui.KFInvasionLoginMenu'))
	{
		Menu = string(class'KFTurbo.TurboInvasionLoginMenu');
	}

	if (Menu ~= string(class'ServerPerks.SRLobbyMenu') || Menu ~= string(class'KFGui.LobbyMenu'))
	{
		Menu = string(class'KFTurbo.TurboLobbyMenu');
	}

	Super.ClientOpenMenu(Menu, bDisconnect, Msg1, Msg2);	
}

simulated event ReceiveLocalizedMessage( class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
	switch(Message)
	{
		case class'KFMod.WaitingMessage':
			Message = class'TurboMessageWaiting';
			break;
		case class'UnrealGame.PickupMessagePlus':
			Message = class'TurboMessagePickup';
			break;
		case class'ServerPerks.KFVetEarnedMessageSR':
			Message = class'TurboMessageVeterancy';
			break;
	}

	//Accolades are a bit special.
	if (class<TurboAccoladeLocalMessage>(Message) != None)
	{
		CheckAccoladeLocalizedMessage(class<TurboAccoladeLocalMessage>(Message), Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
		return;
	}
	
	Super.ReceiveLocalizedMessage(Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}

function ClientLocationalVoiceMessage(PlayerReplicationInfo Sender, PlayerReplicationInfo Recipient, name MessageType, byte MessageIndex, optional Pawn SoundSender, optional vector SenderLocation)
{
	Super.ClientLocationalVoiceMessage(Sender, Recipient, MessageType, MessageIndex, SoundSender, SenderLocation);

	if (TurboHUDKillingFloor(myHUD) != None)
	{
		TurboHUDKillingFloor(myHUD).ReceivedVoiceMessage(Sender, MessageType, MessageIndex, SoundSender, SenderLocation);
	}
}

simulated function CheckAccoladeLocalizedMessage(class<TurboAccoladeLocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	if (!Message.default.bDisplayForAccoladeEarner && PlayerReplicationInfo == RelatedPRI_1)
	{
		return;
	}

	AccoladeMessage(RelatedPRI_1, Message, Message.static.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject));
}

simulated function AccoladeMessage(PlayerReplicationInfo PRI, class<TurboAccoladeLocalMessage> Message, string AccoladeMessage)
{
	if ( Level.NetMode == NM_DedicatedServer || GameReplicationInfo == None )
	{
		return;
	}

	if( AllowTextToSpeech(PRI, 'Accolade') )
	{
		TextToSpeech(AccoladeMessage, TextToSpeechVoiceVolume );
	}

	if ( myHUD != None )
	{
		myHUD.AddTextMessage(AccoladeMessage, Message, PRI);
	}

	if (Player != None && Player.Console != None)
	{
		Player.Console.Chat(AccoladeMessage, 6.0, PRI );
	}
}

exec function Speech( Name Type, int Index, string CallSign )
{
	if (Pawn != None && TurboInteraction != None)
	{
		TurboInteraction.CheckForVoiceCommandMark(Type, Index);
	}

	Super.Speech(Type, Index, CallSign);
}

function AttemptMarkActor(vector Start, vector End, Actor TargetActor, class<TurboMarkerType> DataClassOverride, int DataOverride, TurboPlayerMarkReplicationInfo.EMarkColor Color)
{
	local TurboPlayerMarkReplicationInfo TurboMarkPRI;
	local Pickup FoundPickup;

	if ((TargetActor == None || TargetActor.bWorldGeometry) && (Player != None))
	{
		foreach CollidingActors(class'Pickup', FoundPickup, 40.f, End)
			break;

		if (FoundPickup == None)
		{
			return;
		}

		TargetActor = FoundPickup;

		if (TargetActor == None || TargetActor.bWorldGeometry)
		{
			return;
		}
	}
	
    if (Pawn(TargetActor.Base) != None)
    {
        TargetActor = TargetActor.Base;
    }
	
	if (Role != ROLE_Authority)
	{
		ServerMarkActor(Start, End, TargetActor, DataClassOverride, DataOverride, Color);
		return;
	}

	if (NextMarkTime > Level.TimeSeconds)
	{
		return;
	}

	NextMarkTime = Level.TimeSeconds + 0.1f;

	TurboMarkPRI = class'TurboPlayerMarkReplicationInfo'.static.GetTurboMarkPRI(PlayerReplicationInfo);

	if (TurboMarkPRI != None)
	{
		TurboMarkPRI.MarkerColor = Color;
		TurboMarkPRI.MarkActor(TargetActor, DataClassOverride, DataOverride);
	}
}

function ServerMarkActor(vector Start, vector End, Actor TargetActor, class<TurboMarkerType> DataClassOverride, int DataOverride, TurboPlayerMarkReplicationInfo.EMarkColor Color)
{
	AttemptMarkActor(Start, End, TargetActor, DataClassOverride, DataOverride, Color);
}

function ClientCloseBuyMenu()
{
	local GUIController GUIController;
	local TurboGUIBuyMenu BuyMenu;

	if (Player == None || GUIController(Player.GUIController) == None)
	{
		return;
	}
	
	GUIController = GUIController(Player.GUIController);

	BuyMenu = TurboGUIBuyMenu(GUIController.FindMenuByClass(Class'TurboGUIBuyMenu'));
	
	if (BuyMenu != None)
	{
		BuyMenu.CloseSale(false);
	}
}

function ShowBuyMenu(string wlTag,float maxweight)
{
	StopForceFeedback();
	ClientOpenMenu(string(Class'TurboGUIBuyMenu'),,wlTag,string(maxweight));
}

function Possess(Pawn P)
{
	Super.Possess(P);

	SetupTurboInteraction();
}

simulated function AcknowledgePossession(Pawn P)
{
	Super.AcknowledgePossession(P);

	SetupTurboInteraction();
}

function ServerSetWantsTraderPath(bool bNewWantsTraderPath)
{
	if (class'KFTurboGameType'.static.StaticIsHighDifficulty(Self))
	{
		return;
	}

	Super.ServerSetWantsTraderPath(bNewWantsTraderPath);
}

simulated function ClientReceiveLoginMenu(string MenuClass, bool bForce)
{
	if (MenuClass ~= "ServerPerks.SRInvasionLoginMenu" || MenuClass ~= "KFGui.KFInvasionLoginMenu")
	{
		MenuClass = string(class'KFTurbo.TurboInvasionLoginMenu');
	}

	Super.ClientReceiveLoginMenu(MenuClass, bForce);
}

simulated function ShowLoginMenu()
{
	if (Pawn != None && Pawn.Health > 0)
	{
		return;
	}

	if (PlayerReplicationInfo != None && PlayerReplicationInfo.bReadyToPlay)
	{
		return;
	}

	if (GameReplicationInfo != None)
	{
		ClientReplaceMenu(LobbyMenuClassString);
	}
}

function ServerInitializeSteamStatInt(byte Index, int Value)
{
	local ClientPerkRepLink CPRL;
	local SRCustomProgressInt Progress;
	local class<SRCustomProgressInt> ProgressClass;

	CPRL = GetClientPerkRepLink();

	if (!class'KFTurboGameType'.static.StaticAreStatsAndAchievementsEnabled(Self))
	{
		return;
	}

	if (CPRL == None)
	{
		return;
	}

	Value = Max(Value, 0);

	switch (Index)
	{
	case 0:
		ProgressClass = class'VP_DamageHealed';
		break;
	case 1:
		ProgressClass = class'VP_WeldingPoints';
		break;
	case 2:
		ProgressClass = class'VP_ShotgunDamage';
		break;
	case 3:
		ProgressClass = class'VP_HeadshotKills';
		break;
	case 4:
		ProgressClass = class'VP_StalkerKills';
		break;
	case 5:
		ProgressClass = class'VP_BullpupDamage';
		break;
	case 6:
		ProgressClass = class'VP_MeleeDamage';
		break;
	case 7:
		ProgressClass = class'VP_FlamethrowerDamage';
		break;
	case 21:
		ProgressClass = class'VP_ExplosiveDamage';
		break;
	default:
		return;
	}

	Progress = SRCustomProgressInt(CPRL.AddCustomValue(ProgressClass));

	if (Progress == None)
	{
		return;
	}

	if (Progress.CurrentValue < Value)
	{
		Progress.CurrentValue = Value;
		Progress.ValueUpdated();
	}
}

exec function GetWeapon(class<Weapon> NewWeaponClass )
{
	if (WeaponRemappingSettings != None)
	{
		NewWeaponClass = WeaponRemappingSettings.static.GetRemappedWeapon(Self, NewWeaponClass);
	}
	
	Super.GetWeapon(NewWeaponClass);
}

exec function ServerDebugSkipWave()
{
	if (PlayerReplicationInfo == None || !PlayerReplicationInfo.bAdmin)
	{
		return;
	}

	if (KFGameType(Level.Game) == None || !KFGameType(Level.Game).bWaveInProgress)
	{
		return;
	}

	class'KFTurboGameType'.static.StaticDisableStatsAndAchievements(Self);

	KFGameType(Level.Game).TotalMaxMonsters = 0;
	KFGameType(Level.Game).NextSpawnSquad.Length = 0;
	KFGameType(Level.Game).KillZeds();
}

exec function EndTrader()
{
	if (KFGameType(Level.Game) == None || KFGameType(Level.Game).bWaveInProgress)
	{
		return;
	}

	if (TurboPlayerReplicationInfo(PlayerReplicationInfo) == None)
	{
		return;
	}

	TurboPlayerReplicationInfo(PlayerReplicationInfo).RequestTraderEnd();
}

defaultproperties
{
	LobbyMenuClassString="KFTurbo.TurboLobbyMenu"
	PawnClass=Class'KFTurbo.TurboHumanPawn'
    PlayerReplicationInfoClass=Class'KFTurbo.TurboPlayerReplicationInfo'

	WeaponRemappingSettings=class'WeaponRemappingSettingsImpl'

	bInLoginMenu=false
	bHasClosedLoginMenu=true //Starts as closed.
	LoginMenuTime=-1.f
}
