//Killing Floor Turbo TurboWavePlayerStatCollector
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboWavePlayerStatCollector extends TurboPlayerStatCollectorBase;

var int Kills;
var int ShotsFired, ShotsHit, ShotsHeadshot;
var int HealingDone, HealingReceived;
var int DamageDone;

replication
{
	reliable if (Role == ROLE_Authority)
		Kills;
}

//API to convert a stat collector into a stat replicator.
function PushStats(TurboPlayerStatCollectorBase Source)
{
	local TurboWavePlayerStatCollector WaveStatsSource;
	WaveStatsSource = TurboWavePlayerStatCollector(Source);

	Kills = WaveStatsSource.Kills;
	
	ShotsFired = WaveStatsSource.ShotsFired;
	ShotsHit = WaveStatsSource.ShotsHit;
	ShotsHeadshot = WaveStatsSource.ShotsHeadshot;
	
	HealingDone = WaveStatsSource.HealingDone;
	HealingReceived = WaveStatsSource.HealingReceived;
	
	DamageDone = WaveStatsSource.DamageDone;
}

defaultproperties
{
	PlayerStatReplicatorClass=class'TurboWavePlayerStatReplicator'
}