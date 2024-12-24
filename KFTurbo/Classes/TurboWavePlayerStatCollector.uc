//Killing Floor Turbo TurboWavePlayerStatCollector
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboWavePlayerStatCollector extends TurboPlayerStatCollectorBase;

var int Wave;

var int Kills;
var int DamageDone;

var int ShotsFired, ShotsHit, ShotsHeadshot;
var int MeleeSwings;

var int Reloads;

var int HealingDone, HealingReceived;

var KFTurboGameType GameType;

replication
{
	reliable if (Role == ROLE_Authority)
		Wave,
		Kills,
		DamageDone,
		ShotsFired, ShotsHit, ShotsHeadshot,
		MeleeSwings,
		Reloads,
		HealingDone, HealingReceived;
}

//API to convert a stat collector into a stat replicator.
function PushStats(TurboPlayerStatCollectorBase Source)
{
	local TurboWavePlayerStatCollector WaveStatsSource;
	WaveStatsSource = TurboWavePlayerStatCollector(Source);

	Wave = WaveStatsSource.Wave;

	Kills = WaveStatsSource.Kills;
	DamageDone = WaveStatsSource.DamageDone;
	
	ShotsFired = WaveStatsSource.ShotsFired;
	ShotsHit = WaveStatsSource.ShotsHit;
	ShotsHeadshot = WaveStatsSource.ShotsHeadshot;

	MeleeSwings = WaveStatsSource.MeleeSwings;
	
	HealingDone = WaveStatsSource.HealingDone;
	HealingReceived = WaveStatsSource.HealingReceived;
}

function PostBeginPlay()
{
	Super.PostBeginPlay();

	GameType = KFTurboGameType(Level.Game);
	Wave = GameType.GetCurrentWaveNum();
}

final function bool ShouldCollectStats()
{
	return true; //GameType.bWaveInProgress;
}

function IncrementKills(class<KFMonster> MonsterClass)
{
	Kills++;
}

function IncrementDamageDone(int Damage, class<KFMonster> MonsterClass)
{
	DamageDone += Damage;
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

defaultproperties
{
	PlayerStatReplicatorClass=class'TurboWavePlayerStatReplicator'
}