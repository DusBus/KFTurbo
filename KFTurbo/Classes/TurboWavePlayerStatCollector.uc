//Killing Floor Turbo TurboWavePlayerStatCollector
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboWavePlayerStatCollector extends TurboPlayerStatCollectorBase;

var int Wave;

var int Kills, KillsFleshpound, KillsScrake;
var int DamageDone, DamageDoneFleshpound, DamageDoneScrake;

var int ShotsFired, ShotsHit, ShotsHeadshot;
var int MeleeSwings;

var int Reloads;

var int HealingDone;

var KFTurboGameType GameType;

replication
{
	reliable if (Role == ROLE_Authority)
		Wave,
		Kills, KillsFleshpound, KillsScrake,
		DamageDone, DamageDoneFleshpound, DamageDoneScrake,
		ShotsFired, ShotsHit, ShotsHeadshot,
		MeleeSwings,
		Reloads,
		HealingDone;
}

//API to convert a stat collector into a stat replicator.
function PushStats(TurboPlayerStatCollectorBase Source)
{
	local TurboWavePlayerStatCollector WaveStatsSource;
	WaveStatsSource = TurboWavePlayerStatCollector(Source);

	Wave = WaveStatsSource.Wave;

	Kills = WaveStatsSource.Kills;
	KillsFleshpound = WaveStatsSource.KillsFleshpound;
	KillsScrake = WaveStatsSource.KillsScrake;

	DamageDone = WaveStatsSource.DamageDone;
	DamageDoneFleshpound = WaveStatsSource.DamageDoneFleshpound;
	DamageDoneScrake = WaveStatsSource.DamageDoneScrake;
	
	ShotsFired = WaveStatsSource.ShotsFired;
	ShotsHit = WaveStatsSource.ShotsHit;
	ShotsHeadshot = WaveStatsSource.ShotsHeadshot;

	MeleeSwings = WaveStatsSource.MeleeSwings;

	Reloads = WaveStatsSource.Reloads;
	
	HealingDone = WaveStatsSource.HealingDone;
}

function PostBeginPlay()
{
	Super.PostBeginPlay();

	GameType = KFTurboGameType(Level.Game);
	Wave = GameType.GetCurrentWaveNum();
}

final function bool ShouldCollectStats()
{
	return GameType.bWaveInProgress;
}

function IncrementKills(class<KFMonster> MonsterClass)
{
	if (!ShouldCollectStats())
	{
		return;
	}

	Kills++;

	if (class<ZombieFleshPound>(MonsterClass) != None)
	{
		KillsFleshpound++;
	}
	else if (class<ZombieScrake>(MonsterClass) != None)
	{
		KillsScrake++;
	}
}

function IncrementDamageDone(int Damage, class<KFMonster> MonsterClass)
{
	if (!ShouldCollectStats())
	{
		return;
	}

	DamageDone += Damage;

	if (class<ZombieFleshPound>(MonsterClass) != None)
	{
		DamageDoneFleshpound += Damage;
	}
	else if (class<ZombieScrake>(MonsterClass) != None)
	{
		DamageDoneScrake += Damage;
	}
}

function IncrementShotsFired()
{
	if (!ShouldCollectStats())
	{
		return;
	}

	ShotsFired++;
}

function IncrementShotsHit(bool bIsHeadshot)
{
	if (!ShouldCollectStats())
	{
		return;
	}

	ShotsHit++;
	
	if (bIsHeadshot)
	{
		ShotsHeadshot++;
	}
}

function IncrementMeleeSwings()
{
	if (!ShouldCollectStats())
	{
		return;
	}

	MeleeSwings++;
}

function IncrementReloads()
{
	if (!ShouldCollectStats())
	{
		return;
	}

	Reloads++;
}

function IncrementHealthHealed(int HealAmount)
{
	if (!ShouldCollectStats())
	{
		return;
	}

	HealingDone += HealAmount;
}

defaultproperties
{
	PlayerStatReplicatorClass=class'TurboWavePlayerStatReplicator'
}