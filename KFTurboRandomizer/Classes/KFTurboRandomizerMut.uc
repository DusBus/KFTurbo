class KFTurboRandomizerMut extends Mutator
		config(KFTurboRandomizer);

var KFGameType KFGT;

enum ELoadoutType
{
	LT_FleshpoundLoadout,
	LT_ScrakeLoadout,
	LT_EarlyWave,
	LT_MiscLoadout,
	LT_FunnyLoadout
};

struct PlayerLoadout
{
	var KFPlayerController Player;
	var ELoadoutType LoadoutType;
	var KFTurboRandomizerLoadout Loadout;
};
var array<PlayerLoadout> PlayerLoadoutList;

var config string RandomizerSettingsClassString;
var class<KFTurboRandomizerSettings> RandomizerSettingsClass;
var KFTurboRandomizerSettings RandomizerSettings;

var int ScrakeAndFleshpoundWaveNum;

function PreBeginPlay()
{
	local ShopVolume Shop;

	foreach AllActors(Class'ShopVolume',Shop) 
	{
		Shop.bAlwaysClosed = true;
	}
}

function PostBeginPlay()
{
	AddToPackageMap("KFTurboRandomizer");

	if (RandomizerSettingsClassString != "")
	{
		RandomizerSettingsClass = class<KFTurboRandomizerSettings>(DynamicLoadObject(RandomizerSettingsClassString, class'Class'));
	}

	if (RandomizerSettingsClass == None)
	{
		RandomizerSettingsClass = class'KFTurboRandomizerSettings';
	}

	if (RandomizerSettings == None)
	{
		RandomizerSettings = new(Self) RandomizerSettingsClass;
	}

	KFGT = KFGameType(Level.Game);

	if(KFGT == None)
	{
		Destroy();
		return;
	}

	SetTimer(1.f, false);
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	if (KFRandomItemSpawn(Other) != None)
	{
		UpdateRandomItemPickup(KFRandomItemSpawn(Other));
	}

	return true;
}

function UpdateRandomItemPickup(KFRandomItemSpawn PickupSpawner)
{
	PickupSpawner.PickupClasses[0] = None;
	PickupSpawner.PickupClasses[1] = None;
	PickupSpawner.PickupClasses[2] = None;
	PickupSpawner.PickupClasses[3] = None;
	PickupSpawner.PickupClasses[4] = None;
	PickupSpawner.PickupClasses[5] = None;
	PickupSpawner.PickupClasses[6] = None;
	PickupSpawner.PickupClasses[7] = None;
}

function Timer()
{
	if (KFGT.bWaitingToStartMatch)
	{
		SetTimer(0.5f, false);
	}

	InitializeRandomizer();
}

//Do basic init here.
function InitializeRandomizer()
{
	if (KFTurboGameType(KFGT) != None && KFTurboGameType(KFGT).IsHighDifficulty())
	{
		ScrakeAndFleshpoundWaveNum = 0;
	}

	GotoState('WaitingToRandomize');
}

state WaitingToRandomize
{
Begin:
	while(KFGT != None && KFGT.WaveCountDown > 10)
	{
		if (KFGT.WaveCountDown > 45)
		{
			KFGT.WaveCountDown = 20;
		}
		Sleep(0.1f);
	}
	
	Sleep(0.1f);

	if (KFGT == None)
	{
		Stop;
	}

	GotoState('SettingUpLoadouts');
}

state SettingUpLoadouts
{
Begin:
	if (!PrepareRandomizerSettings())
	{
		log ("Failed PrepareRandomizerSettings!", 'KFTurboRandomizer');
		GotoState('AwaitingWaveCompletion');
	}

	Sleep(0.1f);

	if (!SetupLoadoutTypes())
	{
		log ("Failed SetupLoadoutTypes!", 'KFTurboRandomizer');
		GotoState('AwaitingWaveCompletion');
		Stop;
	}

	Sleep(0.1f);

	if (!SelectLoadouts())
	{
		log ("Failed SetupLoadoutTypes!", 'KFTurboRandomizer');
		GotoState('AwaitingWaveCompletion');
		Stop;
	}

	Sleep(0.1f);
	GotoState('ApplyingLoadouts');

}

state ApplyingLoadouts
{
Begin:
	while (PlayerLoadoutList.Length > 0)
	{
		ApplyLoadout(PlayerLoadoutList[PlayerLoadoutList.Length - 1]);
		PlayerLoadoutList.Length = PlayerLoadoutList.Length - 1;
		
		Sleep(0.25f);
	}
 
	GotoState('AwaitingWaveCompletion');
}

state AwaitingWaveCompletion
{
Begin:
	while(KFGT != None && !KFGT.bWaveInProgress)
	{
		Sleep(0.1f);
	}
	
	while(KFGT != None && KFGT.bWaveInProgress)
	{
		Sleep(0.25f);
	}

	GotoState('WaitingToRandomize');
}

function bool ShouldWaveHaveScrakeAndFleshpoundLoadouts()
{
	return KFGT.WaveNum + 1 >= ScrakeAndFleshpoundWaveNum;
}

//Called at the start of a randomization pass. Allows randomizer settings to prepare.
function bool PrepareRandomizerSettings()
{
	RandomizerSettings.PrepareRandomization();
	return true;
}

function bool SetupLoadoutTypes()
{
	local Controller C;
	local int TotalPlayerCount, PlayerCount, PlayerTypeCount;
	local int RandomPlayerIndex;
	local array<PlayerLoadout> PendingPlayerLoadoutList;
	
	PlayerCount = 0;
	PlayerLoadoutList.Length = 0;

	for(C = Level.ControllerList; C != none; C = C.NextController)
	{
		if(KFPlayerController(C) != None && C.Pawn != none)
		{
			PendingPlayerLoadoutList.Insert(PendingPlayerLoadoutList.Length, 1);
			PendingPlayerLoadoutList[PendingPlayerLoadoutList.Length - 1].Player = KFPlayerController(C);
			PlayerCount++;
		}
	}

	TotalPlayerCount = PlayerCount;

	if (TotalPlayerCount == 0)
	{
		return false;
	}

	//If we've reached a wave with Scrakes and Fleshpounds, give us loadouts for them.
	if (ShouldWaveHaveScrakeAndFleshpoundLoadouts())
	{
		PlayerTypeCount = Max(float(TotalPlayerCount) * 0.34f, 1);

		while (PlayerTypeCount > 0)
		{
			PlayerTypeCount--;
			PlayerCount--;
			RandomPlayerIndex = Rand(PendingPlayerLoadoutList.Length - 1);
			PendingPlayerLoadoutList[RandomPlayerIndex].LoadoutType = LT_FleshpoundLoadout;

			PlayerLoadoutList[PlayerLoadoutList.Length] = PendingPlayerLoadoutList[RandomPlayerIndex];
			PendingPlayerLoadoutList.Remove(RandomPlayerIndex, 1);
		}

		PlayerTypeCount = Round(FMin(float(TotalPlayerCount) * 0.33f, 1.f));
		PlayerTypeCount = Min(PlayerCount, PlayerTypeCount);

		if (PlayerTypeCount == 0)
		{
			return true;
		}

		while (PlayerTypeCount > 0)
		{
			PlayerTypeCount--;
			PlayerCount--;

			RandomPlayerIndex = Rand(PendingPlayerLoadoutList.Length - 1);
			PendingPlayerLoadoutList[RandomPlayerIndex].LoadoutType = LT_ScrakeLoadout;

			PlayerLoadoutList[PlayerLoadoutList.Length] = PendingPlayerLoadoutList[RandomPlayerIndex];
			PendingPlayerLoadoutList.Remove(RandomPlayerIndex, 1);
		}
	}
	else
	{
		PlayerTypeCount = Max(float(TotalPlayerCount) * 0.51f, 1);

		while (PlayerTypeCount > 0)
		{
			PlayerTypeCount--;
			PlayerCount--;

			RandomPlayerIndex = Rand(PendingPlayerLoadoutList.Length - 1);
			PendingPlayerLoadoutList[RandomPlayerIndex].LoadoutType = LT_EarlyWave;

			PlayerLoadoutList[PlayerLoadoutList.Length] = PendingPlayerLoadoutList[RandomPlayerIndex];
			PendingPlayerLoadoutList.Remove(RandomPlayerIndex, 1);
		}
	}

	while (PlayerCount > 0)
	{
		PlayerCount--;
		RandomPlayerIndex = Rand(PendingPlayerLoadoutList.Length - 1);

		if (FRand() > 0.1f)
		{
			PendingPlayerLoadoutList[RandomPlayerIndex].LoadoutType = LT_MiscLoadout;
		}
		else
		{
			PendingPlayerLoadoutList[RandomPlayerIndex].LoadoutType = LT_FunnyLoadout;
		}
		
		PlayerLoadoutList[PlayerLoadoutList.Length] = PendingPlayerLoadoutList[RandomPlayerIndex];
		PendingPlayerLoadoutList.Remove(RandomPlayerIndex, 1);
	}

	return true;
}

function bool SelectLoadouts()
{
	local int PlayerIndex;
	local bool bAssignedLoadout;
	bAssignedLoadout = true;
	
	for (PlayerIndex = 0; PlayerIndex < PlayerLoadoutList.Length; PlayerIndex++)
	{
		switch (PlayerLoadoutList[PlayerIndex].LoadoutType)
		{
			case LT_FleshpoundLoadout:
				PlayerLoadoutList[PlayerIndex].Loadout = RandomizerSettings.GetRandomFleshpoundLoadout();
				break;
			case LT_ScrakeLoadout:
				PlayerLoadoutList[PlayerIndex].Loadout = RandomizerSettings.GetRandomScrakeLoadout();
				break;
			case LT_EarlyWave:
				PlayerLoadoutList[PlayerIndex].Loadout = RandomizerSettings.GetRandomEarlyWaveLoadout();
				break;
			case LT_MiscLoadout:
				PlayerLoadoutList[PlayerIndex].Loadout = RandomizerSettings.GetRandomMiscLoadout();
				break;
			case LT_FunnyLoadout:
				PlayerLoadoutList[PlayerIndex].Loadout = RandomizerSettings.GetRandomFunnyLoadout();
				break;
		}

		bAssignedLoadout = PlayerLoadoutList[PlayerIndex].Loadout != None;
	}

	return bAssignedLoadout;
}

static function KFWeapon CreateWeapon(KFHumanPawn HumanPawn, class<KFWeapon> WeaponClass)
{
	local KFWeapon Weapon;

	Weapon = HumanPawn.Spawn(WeaponClass,,,HumanPawn.Location);
	
	Weapon.GiveTo(HumanPawn);
	Weapon.bCanThrow = false;
	Weapon.MaxOutAmmo();
	return Weapon;
}

static function FillUpGrenades(Frag Frag, KFPlayerReplicationInfo KFPRI)
{
	Frag.AddAmmo(5.f * KFPRI.ClientVeteranSkill.Static.AddExtraAmmoFor(KFPRI, Frag.FireModeClass[0].default.AmmoClass), 0);
}

function bool ApplyLoadout(out PlayerLoadout Loadout)
{
	local KFHumanPawn HumanPawn;
	local Controller C;
	local KFPlayerController KFPC;
	local String LoadoutString;
	local int LoadoutWeaponIndex;
	local KFWeapon Weapon;
	local array<KFWeapon> LoadoutWeaponList;

	if (Loadout.Loadout == None || Loadout.Player == None || Loadout.Player.Pawn == None)
	{
		return false;
	}

	HumanPawn = KFHumanPawn(Loadout.Player.Pawn);

	ApplyVeterancy(Loadout);

	if (HumanPawn == None)
	{
		return false;
	}

	KFGT.DiscardInventory(HumanPawn);

	if (Loadout.Loadout.bSingle && !Loadout.Loadout.HasWeapon(RandomizerSettings.DualiesWeaponClass))
	{
		CreateWeapon(HumanPawn, RandomizerSettings.SingleWeaponClass);
	}
	
	Weapon = CreateWeapon(HumanPawn, RandomizerSettings.FragWeaponClass);
	if(KFPlayerReplicationInfo(Loadout.Player.PlayerReplicationInfo) != None)
	{
		FillUpGrenades(Frag(Weapon), KFPlayerReplicationInfo(Loadout.Player.PlayerReplicationInfo));
	}

	if (Loadout.Loadout.bSyringe)
	{
		CreateWeapon(HumanPawn, RandomizerSettings.SyringeWeaponClass);
	}
	
	if (Loadout.Loadout.bWelder)
	{
		CreateWeapon(HumanPawn, RandomizerSettings.WelderWeaponClass);
	}
	
	if (Loadout.Loadout.bKnife)
	{
		CreateWeapon(HumanPawn, RandomizerSettings.KnifeWeaponClass);
	}

	LoadoutString = Loadout.Player.PlayerReplicationInfo.PlayerName @ "("$Loadout.Loadout.Perk.default.VeterancyName$")"@":";

	for (LoadoutWeaponIndex = 0; LoadoutWeaponIndex < Loadout.Loadout.WeaponList.Length; LoadoutWeaponIndex++)
	{
		Weapon = CreateWeapon(HumanPawn, Loadout.Loadout.WeaponList[LoadoutWeaponIndex]);

		if (LoadoutWeaponIndex != Loadout.Loadout.WeaponList.Length - 1)
		{
			LoadoutString = LoadoutString @ Weapon.ItemName $ ",";
		}
		else
		{
			LoadoutString = LoadoutString @ Weapon.ItemName;
		}

		LoadoutWeaponList[LoadoutWeaponList.Length] = Weapon;
	}

	FillUpAmmo(HumanPawn);

	for(C = Level.ControllerList; C != None; C = C.NextController)
	{
		KFPC = KFPlayerController(C);
		if(KFPC != None)
		{
			KFPC.ClientMessage(LoadoutString);

			for (LoadoutWeaponIndex = 0; LoadoutWeaponIndex < Loadout.Loadout.WeaponList.Length; LoadoutWeaponIndex++)
			{
				KFPC.ClientWeaponSpawned(Loadout.Loadout.WeaponList[LoadoutWeaponIndex], LoadoutWeaponList[LoadoutWeaponIndex]);
			}
		}
	}
}

function int GetPlayerVeterancyLevel(out PlayerLoadout Loadout)
{
	local ClientPerkRepLink CPRL;
	local int Index;

	CPRL = class'ClientPerkRepLink'.static.FindStats(Loadout.Player);

	if (CPRL == None)
	{
		return 0;
	}

	for( Index = 0; Index < CPRL.CachePerks.Length; Index++ )
	{
		if (CPRL.CachePerks[Index].PerkClass == Loadout.Loadout.Perk)
		{
			return CPRL.CachePerks[Index].CurrentLevel - 1;
		}
	}

	return 0;
}

function ApplyVeterancy(out PlayerLoadout Loadout)
{
	local KFPlayerReplicationInfo KFPRI;
	local KFHumanPawn HumanPawn;

	KFPRI = KFPlayerReplicationInfo(Loadout.Player.PlayerReplicationInfo);

	if (KFPRI == None)
	{
		return;
	}

	HumanPawn = KFHumanPawn(Loadout.Player.Pawn);

	Loadout.Player.SelectedVeterancy = Loadout.Loadout.Perk;

    if(KFPRI.ClientVeteranSkill != Loadout.Player.SelectedVeterancy)
	{
		KFPRI.ClientVeteranSkill = Loadout.Loadout.Perk;
		KFPRI.ClientVeteranSkillLevel = GetPlayerVeterancyLevel(Loadout);
    	HumanPawn.VeterancyChanged();

    	Loadout.Player.bChangedVeterancyThisWave = true;
	}

    Loadout.Player.PlayerReplicationInfo.NumLives = 2;
    Loadout.Player.bSpawnedThisWave=true;

    HumanPawn.ShieldStrength = FMax(HumanPawn.ShieldStrength, Loadout.Loadout.GetArmor());
}

function FillUpAmmo(KFHumanPawn HumanPawn)
{
	local Inventory Inv;
	local KFWeapon Weapon;
	local int MaxAmmo, CurAmmo;

	for(Inv = HumanPawn.Inventory; Inv != None; Inv = Inv.Inventory)
	{
		Weapon = KFWeapon(Inv);
		
		if(Weapon == None)
		{
			continue;
		}

		GetAmmoCount(Weapon, MaxAmmo, CurAmmo);
		Weapon.AddAmmo(MaxAmmo - CurAmmo, 0);

		if(!Weapon.bHasSecondaryAmmo)
		{
			continue;
		}

		MaxAmmo = Weapon.MaxAmmo(1);
		CurAmmo = Weapon.AmmoAmount(1);
		Weapon.AddAmmo(MaxAmmo - CurAmmo, 1);
	}
}

static final function GetAmmoCount(KFWeapon KFW, out int MaxAmmo, out int CurAmmo)
{
	local float retMax, retCur;
	
	KFW.GetAmmoCount(retMax, retCur);

	MaxAmmo = int(retMax);
	CurAmmo = int(retCur);
}

simulated function String GetHumanReadableName()
{
	return FriendlyName;
}

defaultproperties
{
	 ScrakeAndFleshpoundWaveNum = 5

     bAddToServerPackages=True
     GroupName="KF-Randomizer"
     FriendlyName="Killing Floor Turbo Randomizer"
     Description="Killing Floor Turbo's randomizer mutator. Uses large lists of predefined loadouts with specific roles (good vs Fleshpound/Scrake) incorporated into selection."
}