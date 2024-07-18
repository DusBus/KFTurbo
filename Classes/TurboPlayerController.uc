class TurboPlayerController extends KFPCServ;

var class<WeaponRemappingSettings> WeaponRemappingSettings;
var config bool bHasInitializedTraderBinding;

replication
{
	reliable if( Role==ROLE_Authority )
		ClientCloseBuyMenu;
	reliable if( Role<ROLE_Authority )
		ServerDebugSkipWave, ServerDebugSkipTrader;
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

exec function Trade()
{
	if (!class'KFTurboGameType'.static.StaticIsHighDifficulty(Self))
	{
		return;
	}

	if (KFHumanPawn(Pawn) == None || Pawn.Health <= 0.f)
	{
		return;
	}

	if (KFGameReplicationInfo(Level.GRI) == None || KFGameReplicationInfo(Level.GRI).bWaveInProgress)
	{
		return;
	}

	Player.GUIController.CloseMenu();
	ShowBuyMenu("WeaponLocker", KFHumanPawn(Pawn).maxCarryWeight);
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

function AcknowledgePossession(Pawn P)
{
	Super.AcknowledgePossession(P);

	if (!class'KFTurboGameType'.static.StaticIsHighDifficulty(Self))
	{
		return;
	}

	if (!bHasInitializedTraderBinding)
	{
		bHasInitializedTraderBinding = false;
		ConsoleCommand("set input h Trade");
		ClientMessage("Welcome to KFTurbo+. Your keybind to open trader has been initialized to H.");
	}
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

	Super.ServerInitializeSteamStatInt(Index, Value);

	CPRL = class'ClientPerkRepLink'.static.FindStats(self);

	if (CPRL == None)
	{
		return;
	}

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

	Progress.CurrentValue = Value;
	Progress.ValueUpdated();
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

exec function ServerDebugSkipTrader()
{
	if (PlayerReplicationInfo == None || !PlayerReplicationInfo.bAdmin)
	{
		return;
	}

	if (KFGameType(Level.Game) == None || KFGameType(Level.Game).bWaveInProgress)
	{
		return;
	}
	
	class'KFTurboGameType'.static.StaticDisableStatsAndAchievements(Self);

	KFGameType(Level.Game).WaveCountDown = 10;
}

defaultproperties
{
	LobbyMenuClassString="KFTurbo.TurboLobbyMenu"
	PawnClass=Class'KFTurbo.TurboHumanPawn'

	WeaponRemappingSettings=class'WeaponRemappingSettingsImpl'
}
