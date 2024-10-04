Class TurboSteamStatsGet extends KFSteamStatsAndAchievements
	transient;

var TurboRepLink Link;

simulated event PostBeginPlay()
{
	PCOwner = Level.GetLocalPlayerController();
	Initialize(PCOwner);
	GetStatsAndAchievements();
}

simulated event PostNetBeginPlay();

simulated event OnStatsAndAchievementsReady()
{
	local int WeaponIndex, VariantIndex, WeaponLockID;
	local class<KFWeapon> WeaponClass;
	local ClientPerkRepLink CPRL;

	if (Link == None || PCOwner == None)
	{
		LifeSpan = 1.f;
		return;
	}

	InitStatInt(OwnedWeaponDLC, GetOwnedWeaponDLC());

	for (WeaponIndex = Link.PlayerVariantList.Length - 1; WeaponIndex >= 0; --WeaponIndex)
	{
		for (VariantIndex = Link.PlayerVariantList[WeaponIndex].VariantList.Length - 1; VariantIndex >= 0; --VariantIndex)
		{
			//Skip items that don't need a lock.
			if (Link.PlayerVariantList[WeaponIndex].VariantList[VariantIndex].ItemStatus == 0)
			{
				continue;
			}

			WeaponClass = class<KFWeapon>(Link.PlayerVariantList[WeaponIndex].VariantList[VariantIndex].VariantClass.default.InventoryType);

			//Test DLC status.
			WeaponLockID = WeaponClass.default.AppID;
			if (WeaponLockID != 0)
			{
				if (PlayerOwnsWeaponDLC(WeaponLockID))
				{
					Link.PlayerVariantList[WeaponIndex].VariantList[VariantIndex].ItemStatus = 0;
				}
				else if (WeaponClass.default.UnlockedByAchievement != -1)
				{
					Link.PlayerVariantList[WeaponIndex].VariantList[VariantIndex].ItemStatus = 2;
				}
				else
				{
					Link.PlayerVariantList[WeaponIndex].VariantList[VariantIndex].ItemStatus = 1;
				}

				continue;
			}
			
			//Test achievement status.
			WeaponLockID = WeaponClass.default.UnlockedByAchievement;
			if (WeaponLockID != -1)
			{
				if (Achievements[WeaponLockID].bCompleted == 1)
				{
					Link.PlayerVariantList[WeaponIndex].VariantList[VariantIndex].ItemStatus = 0;
				}
				else
				{
					Link.PlayerVariantList[WeaponIndex].VariantList[VariantIndex].ItemStatus = 2;
				}

				continue;
			}

			Link.PlayerVariantList[WeaponIndex].VariantList[VariantIndex].ItemStatus = 0;
		}
	}

	CPRL = class'ClientPerkRepLink'.static.FindStats(PCOwner);
	for(WeaponIndex = (CPRL.ShopInventory.Length - 1); WeaponIndex>=0; --WeaponIndex)
	{
		if(CPRL.ShopInventory[WeaponIndex].bDLCLocked == 0 )
		{
			continue;
		}
		
		WeaponLockID = class<KFWeapon>(CPRL.ShopInventory[WeaponIndex].PC.Default.InventoryType).Default.AppID;
		if(WeaponLockID != 0)
		{
			if(PlayerOwnsWeaponDLC(WeaponLockID))
			{
				CPRL.ShopInventory[WeaponIndex].bDLCLocked = 0;
			}
			else if(class<KFWeapon>(CPRL.ShopInventory[WeaponIndex].PC.Default.InventoryType).Default.UnlockedByAchievement != -1)
			{
				CPRL.ShopInventory[WeaponIndex].bDLCLocked = 2; // Special hack for dwarf axe.
			}
			else
			{
				CPRL.ShopInventory[WeaponIndex].bDLCLocked = 1;
			}

			continue;
		}

		WeaponLockID = class<KFWeapon>(CPRL.ShopInventory[WeaponIndex].PC.Default.InventoryType).Default.UnlockedByAchievement;

		if( Achievements[WeaponLockID].bCompleted == 1 )
		{
			CPRL.ShopInventory[WeaponIndex].bDLCLocked = 0;
		}
		else
		{
			CPRL.ShopInventory[WeaponIndex].bDLCLocked = 2;
		}
	}

	UpdatePerkStats();

	LifeSpan = 1.f;
}

//Since we don't push these anymore, we need to do so now.
simulated function UpdatePerkStats()
{
	local TurboPlayerController PlayerController;
	local TurboSteamStatsHandler Handler;
	PlayerController = TurboPlayerController(PCOwner);
	if (PlayerController == None)
	{
		return;
	}

	//This guy will take our stats and wait patiently for server perks to finish reading from the ftp before notifying stats of their value.
	Handler = Spawn(class'TurboSteamStatsHandler', PCOwner);
	
	GetStatInt(DamageHealedStat, SteamNameStat[0]);
	Handler.SteamDamageHealedStat = DamageHealedStat.Value;
	GetStatInt(WeldingPointsStat, SteamNameStat[1]);
	Handler.SteamWeldingPointsStat = WeldingPointsStat.Value;
	GetStatInt(ShotgunDamageStat, SteamNameStat[2]);
	Handler.SteamShotgunDamageStat = ShotgunDamageStat.Value;
	GetStatInt(HeadshotKillsStat, SteamNameStat[3]);
	Handler.SteamHeadshotKillsStat = HeadshotKillsStat.Value;
	GetStatInt(StalkerKillsStat, SteamNameStat[4]);
	Handler.SteamStalkerKillsStat = StalkerKillsStat.Value;
	GetStatInt(BullpupDamageStat, SteamNameStat[5]);
	Handler.SteamBullpupDamageStat = BullpupDamageStat.Value;
	GetStatInt(MeleeDamageStat, SteamNameStat[6]);
	Handler.SteamMeleeDamageStat = MeleeDamageStat.Value;
	GetStatInt(FlameThrowerDamageStat, SteamNameStat[7]);
	Handler.SteamFlameThrowerDamageStat = FlameThrowerDamageStat.Value;
	GetStatInt(ExplosivesDamageStat, SteamNameStat[21]);
	Handler.SteamExplosivesDamageStat = ExplosivesDamageStat.Value;
}

defaultproperties
{
	RemoteRole=ROLE_None
	LifeSpan=10.000000
}
