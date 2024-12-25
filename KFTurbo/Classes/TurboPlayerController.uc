//Killing Floor Turbo TurboPlayerController
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboPlayerController extends KFPCServ;

var private ClientPerkRepLink ClientPerkRepLink;	
var private TurboRepLink TurboRepLink;
var class<WeaponRemappingSettings> WeaponRemappingSettings;
var TurboInteraction TurboInteraction;
var TurboChatInteraction TurboChatInteraction;

var float ClientNextMarkTime, NextMarkTime;

var bool bInLoginMenu, bHasClosedLoginMenu;
var float LoginMenuTime;

var array< class<TurboPlayerEventHandler> > TurboPlayerEventHandlerList;

var bool bPipebombUsesSpecialGroup;

replication
{
	reliable if( Role == ROLE_Authority )
		ClientCloseBuyMenu;
	reliable if( Role < ROLE_Authority )
		ClientSetPipebombUsesSpecialGroup;
	reliable if( Role < ROLE_Authority )
		EndTrader, ServerMarkActor, ServerNotifyShoppingState, ServerNotifyLoginMenuState;
	reliable if( Role < ROLE_Authority )
		ServerDebugSkipWave, ServerDebugRestartWave, ServerDebugSetWave, ServerDebugPreventGameOver, AdminSetTraderTime, AdminSetMaxPlayers;
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

	if (Role == ROLE_Authority)
	{
		class'TurboPlayerEventHandler'.static.RegisterPlayerEventHandler(Self, class'TurboPlayerStatsEventHandler');
	}
}

simulated function InitInputSystem()
{
	Super.InitInputSystem();

	SetupTurboInteraction();
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
	if (ClientPerkRepLink == None)
	{
		ClientPerkRepLink = Class'ClientPerkRepLink'.Static.FindStats(Self);
	}

	return ClientPerkRepLink;
}

function TurboRepLink GetTurboRepLink()
{
	if (TurboRepLink == None)
	{
		TurboRepLink = class'TurboRepLink'.static.FindTurboRepLink(Self);
	}

	return TurboRepLink;
}

simulated function SetupTurboInteraction()
{
	if (Level.NetMode == NM_DedicatedServer)
	{
		return;
	}

	if (Player == None || Player.InteractionMaster == None)
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

simulated event ReceiveLocalizedMessage(class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
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

	if (class<TurboLocalMessage>(Message) != None && class<TurboLocalMessage>(Message).static.IgnoreLocalMessage(Self, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject))
	{
		return;
	}
	
	Super.ReceiveLocalizedMessage(Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}

function ClientLocationalVoiceMessage(PlayerReplicationInfo Sender, PlayerReplicationInfo Recipient, name MessageType, byte MessageIndex, optional Pawn SoundSender, optional vector SenderLocation)
{
	local class<VoicePack> VoicePack;
	VoicePack = Sender.VoiceType;
	if (MessageType == 'TRADER' && class'TurboInteraction'.static.UseMerchantReplacement(Self))
	{
		Sender.VoiceType = class'MerchantVoicePack';
	}

	Super.ClientLocationalVoiceMessage(Sender, Recipient, MessageType, MessageIndex, SoundSender, SenderLocation);

	Sender.VoiceType = VoicePack;

	if (TurboHUDKillingFloor(myHUD) != None)
	{
		TurboHUDKillingFloor(myHUD).ReceivedVoiceMessage(Sender, MessageType, MessageIndex, SoundSender, SenderLocation);
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

function bool AllowTextMessage(string Msg)
{
	if (Level.NetMode == NM_Standalone || PlayerReplicationInfo.bAdmin || PlayerReplicationInfo.bSilentAdmin)
	{
		return true;
	}

	if (Level.TimeSeconds - LastBroadcastTime > 1.f)
	{
		return true;
	}

	return false;
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
	local KFTurboGameType TurboGameType;

	if (Role != ROLE_Authority)
	{
		return;
	}

	if (PlayerReplicationInfo == None || (Level.NetMode != NM_Standalone && !PlayerReplicationInfo.bAdmin))
	{
		return;
	}

	TurboGameType = KFTurboGameType(Level.Game);

	if (TurboGameType == None || !TurboGameType.bWaveInProgress)
	{
		return;
	}

	class'KFTurboGameType'.static.StaticDisableStatsAndAchievements(Self);

	TurboGameType.TotalMaxMonsters = 0;
	TurboGameType.NextSpawnSquad.Length = 0;
	TurboGameType.KillZeds();
	
	//TurboGameType.ClearEndGame();

	Level.Game.BroadcastLocalized(Level.GRI, class'TurboAdminLocalMessage', 0, PlayerReplicationInfo); //EAdminCommand.AC_SkipWave
}

exec function ServerDebugRestartWave()
{
	local KFTurboGameType TurboGameType;

	if (Role != ROLE_Authority)
	{
		return;
	}

	if (PlayerReplicationInfo == None || (Level.NetMode != NM_Standalone && !PlayerReplicationInfo.bAdmin))
	{
		return;
	}

	TurboGameType = KFTurboGameType(Level.Game);

	if (TurboGameType == None || !TurboGameType.bWaveInProgress)
	{
		return;
	}

	class'KFTurboGameType'.static.StaticDisableStatsAndAchievements(Self);

	TurboGameType.WaveNum = TurboGameType.WaveNum - 1;

	TurboGameType.TotalMaxMonsters = 0;
	TurboGameType.NextSpawnSquad.Length = 0;
	TurboGameType.KillZeds();
	
	TurboGameType.ClearEndGame();
	
	Level.Game.BroadcastLocalized(Level.GRI, class'TurboAdminLocalMessage', 1, PlayerReplicationInfo); //EAdminCommand.AC_RestartWave
}

exec function ServerDebugSetWave(int NewWaveNum)
{
	local KFTurboGameType TurboGameType;

	if (Role != ROLE_Authority)
	{
		return;
	}

	if (PlayerReplicationInfo == None || (Level.NetMode != NM_Standalone && !PlayerReplicationInfo.bAdmin))
	{
		return;
	}

	TurboGameType = KFTurboGameType(Level.Game);

	if (TurboGameType == None)
	{
		return;
	}

	NewWaveNum = Max(NewWaveNum - 1, 0);

	class'KFTurboGameType'.static.StaticDisableStatsAndAchievements(Self);
	
	if (TurboGameType.bWaveInProgress)
	{
		TurboGameType.WaveNum = NewWaveNum - 1;
        InvasionGameReplicationInfo(GameReplicationInfo).WaveNumber = NewWaveNum;

		TurboGameType.TotalMaxMonsters = 0;
		TurboGameType.NextSpawnSquad.Length = 0;
		TurboGameType.KillZeds();
	}
	else
	{
		TurboGameType.WaveNum = NewWaveNum;
        InvasionGameReplicationInfo(GameReplicationInfo).WaveNumber = NewWaveNum;
	}

	TurboGameType.ClearEndGame();
	
	//Encode the wave number into the switch value.
	Level.Game.BroadcastLocalized(Level.GRI, class'TurboAdminLocalMessage', (2 | ((NewWaveNum + 1) << 8)), PlayerReplicationInfo); //EAdminCommand.AC_SetWave
}

exec function ServerDebugPreventGameOver()
{
	local KFTurboGameType TurboGameType;

	if (Role != ROLE_Authority)
	{
		return;
	}

	if (PlayerReplicationInfo == None || (Level.NetMode != NM_Standalone && !PlayerReplicationInfo.bAdmin))
	{
		return;
	}

	TurboGameType = KFTurboGameType(Level.Game);

	if (TurboGameType == None || TurboGameType.IsPreventGameOverEnabled())
	{
		return;
	}

	class'KFTurboGameType'.static.StaticDisableStatsAndAchievements(Self);

	KFTurboGameType(Level.Game).PreventGameOver();
	
	Level.Game.BroadcastLocalized(Level.GRI, class'TurboAdminLocalMessage', 5, PlayerReplicationInfo); //EAdminCommand.AC_PreventGameOver
}

exec function AdminSetTraderTime(int Time)
{
	local KFTurboGameType TurboGameType;

	if (Role != ROLE_Authority)
	{
		return;
	}

	if (PlayerReplicationInfo == None || (Level.NetMode != NM_Standalone && !PlayerReplicationInfo.bAdmin))
	{
		return;
	}

	TurboGameType = KFTurboGameType(Level.Game);

	if (TurboGameType == None || TurboGameType.bWaveInProgress)
	{
		return;
	}

	Time = Max(10, Time);
	Time = Min(99999, Time);

	TurboGameType.WaveCountDown = Time;
	if (KFGameReplicationInfo(Level.GRI) != None)
	{
		KFGameReplicationInfo(Level.GRI).TimeToNextWave = TurboGameType.WaveCountDown;
	}
	
	Level.Game.BroadcastLocalized(Level.GRI, class'TurboAdminLocalMessage', (3 | ((Time) << 8)), PlayerReplicationInfo); //EAdminCommand.AC_SetTraderTime
}

exec function AdminSetMaxPlayers(int PlayerCount)
{
	local KFTurboGameType TurboGameType;

	if (Role != ROLE_Authority)
	{
		return;
	}

	if (PlayerReplicationInfo == None || (Level.NetMode != NM_Standalone && !PlayerReplicationInfo.bAdmin))
	{
		return;
	}

	PlayerCount = Max(1, PlayerCount);
	PlayerCount = Min(12, PlayerCount);

	TurboGameType = KFTurboGameType(Level.Game);

	if (TurboGameType == None || TurboGameType.bWaveInProgress)
	{
		return;
	}

 	TurboGameType.MaxPlayers = PlayerCount;
    TurboGameType.default.MaxPlayers = PlayerCount;
	
	Level.Game.BroadcastLocalized(Level.GRI, class'TurboAdminLocalMessage', (4 | ((PlayerCount) << 8)), PlayerReplicationInfo); //EAdminCommand.AC_SetMaxPlayers
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

simulated function ClientWeaponSpawned(class<Weapon> WeaponClass, Inventory Inv)
{
	local class<KFWeapon> KFWeaponClass;
	local class<KFWeaponAttachment> KFAttachmentClass;
	local bool bNeedsWeaponLoad, bNeedsAttachmentLoad;

	KFWeaponClass = class<KFWeapon>(WeaponClass);

	if (KFWeaponClass == None)
	{
		return;
	}

	bNeedsWeaponLoad = KFWeaponClass.default.Mesh == None || (KFWeaponClass.default.MeshRef != "" && string(KFWeaponClass.default.Mesh) != KFWeaponClass.default.MeshRef);
	//Need to also check if skins didn't load or are different. Happens when variant weapons are loaded after non-variants are.
	bNeedsWeaponLoad = bNeedsWeaponLoad || KFWeaponClass.default.Skins.Length == 0 || KFWeaponClass.default.Skins[0] == None;
	bNeedsWeaponLoad = bNeedsWeaponLoad || (KFWeaponClass.default.SkinRefs.Length != 0 && KFWeaponClass.default.SkinRefs[0] != "" && string(KFWeaponClass.default.Skins[0]) != KFWeaponClass.default.SkinRefs[0]);

	if (bNeedsWeaponLoad)
	{
		KFWeaponClass.static.PreloadAssets(Inv);
	}

	KFAttachmentClass = class<KFWeaponAttachment>(KFWeaponClass.default.AttachmentClass);
	bNeedsAttachmentLoad = KFAttachmentClass != None && (KFAttachmentClass.default.Mesh == None || (KFAttachmentClass.default.MeshRef != "" && string(KFAttachmentClass.default.Mesh) != KFAttachmentClass.default.MeshRef));

	if (bNeedsAttachmentLoad)
	{
		if (Inv != None)
		{
			KFAttachmentClass.static.PreloadAssets(KFWeaponAttachment(Inv.ThirdPersonActor));    
		}
		else
		{
			KFAttachmentClass.static.PreloadAssets();
		}
	}

	PreloadFireModeAssets(KFWeaponClass.default.FireModeClass[0]);
	PreloadFireModeAssets(KFWeaponClass.default.FireModeClass[1]);
}

simulated function SetPipebombUsesSpecialGroup(bool bNewPipebombUsesSpecialGroup)
{
	local W_Pipebomb_Weap Pipebomb;
	local bool bWasEquipped;

	if (bNewPipebombUsesSpecialGroup == bPipebombUsesSpecialGroup)
	{
		return;
	}

	bPipebombUsesSpecialGroup = bNewPipebombUsesSpecialGroup;

	if (Role != ROLE_Authority)
	{
		ClientSetPipebombUsesSpecialGroup(bNewPipebombUsesSpecialGroup);
	}

	if (Pawn == None)
	{
		return;
	}

	Pipebomb = W_Pipebomb_Weap(Pawn.FindInventoryType(class'W_Pipebomb_Weap'));

	if (Pipebomb == None)
	{
		return;
	}

	Pipebomb.UpdateInventoryGroup(bPipebombUsesSpecialGroup);

	//Only auth should reshuffle.
	if (Role == ROLE_Authority)
	{
		Pawn.DeleteInventory(Pipebomb);
		Pawn.AddInventory(Pipebomb);
	}
}

function ClientSetPipebombUsesSpecialGroup(bool bNewPipebombUsesSpecialGroup)
{
	local W_Pipebomb_Weap Pipebomb;

	if (Role != ROLE_Authority || bNewPipebombUsesSpecialGroup == bPipebombUsesSpecialGroup)
	{
		return;
	}

	bPipebombUsesSpecialGroup = bNewPipebombUsesSpecialGroup;

	if (Pawn == None)
	{
		return;
	}

	Pipebomb = W_Pipebomb_Weap(Pawn.FindInventoryType(class'W_Pipebomb_Weap'));

	if (Pipebomb == None)
	{
		return;
	}

	Pipebomb.UpdateInventoryGroup(bPipebombUsesSpecialGroup);
	Pawn.DeleteInventory(Pipebomb);
	Pawn.AddInventory(Pipebomb);
}

function bool ShouldPipebombUseSpecialGroup()
{
	return bPipebombUsesSpecialGroup;
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