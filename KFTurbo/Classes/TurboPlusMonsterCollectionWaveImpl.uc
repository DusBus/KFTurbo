class TurboPlusMonsterCollectionWaveImpl extends TurboMonsterCollectionWaveBase;

defaultproperties
{
     //Early-Game Waves:
	Begin Object Class=TurboPlusWaveEarly Name=Wave1
          MaxMonsters=40
          TotalMonsters=15
          BeatSize=1
	     WaveDifficulty=2.f
	     NextSquadSpawnTime=1.6f
	End Object
	WaveList(0)=TurboMonsterWave'Wave1'

	Begin Object Class=TurboPlusWaveEarly Name=Wave2
          MaxMonsters=42
          TotalMonsters=20
	     WaveDifficulty=2.15f
	     NextSquadSpawnTime=1.55f
	End Object
	WaveList(1)=TurboMonsterWave'Wave2'

	Begin Object Class=TurboPlusWaveEarly Name=Wave3
          MaxMonsters=44
          TotalMonsters=25
	     WaveDifficulty=2.3f
	     NextSquadSpawnTime=1.45f
	End Object
	WaveList(2)=TurboMonsterWave'Wave3'

	Begin Object Class=TurboPlusWaveEarly Name=Wave4
          MaxMonsters=45
          TotalMonsters=29
	     WaveDifficulty=2.4f
	     NextSquadSpawnTime=1.4f
	End Object
	WaveList(3)=TurboMonsterWave'Wave4'

     //Mid-Game Waves:
	Begin Object Class=TurboPlusWaveMidGame Name=Wave5
          MaxMonsters=45
          TotalMonsters=33
          WaveDifficulty=2.5f
	     NextSquadSpawnTime=1.375f
	End Object
	WaveList(4)=TurboMonsterWave'Wave5'

	Begin Object Class=TurboPlusWaveMidGame Name=Wave6
          MaxMonsters=46
          TotalMonsters=37
          WaveDifficulty=2.55f
	     NextSquadSpawnTime=1.35f
	End Object
	WaveList(5)=TurboMonsterWave'Wave6'

	Begin Object Class=TurboPlusWaveMidGame Name=Wave7
          MaxMonsters=47
          TotalMonsters=40
          WaveDifficulty=2.6f
	     NextSquadSpawnTime=1.325f
	End Object
	WaveList(6)=TurboMonsterWave'Wave7'

	Begin Object Class=TurboPlusWaveMidGame Name=Wave8
          MaxMonsters=48
          TotalMonsters=43
          RegularSequenceSize=8
          WaveDifficulty=2.65f
	     NextSquadSpawnTime=1.3f
	End Object
	WaveList(7)=TurboMonsterWave'Wave8'

     //End-Game Waves:
     Begin Object Class=TurboPlusWaveLateGame Name=Wave9
          MaxMonsters=49
          TotalMonsters=46
          RegularSequenceSize=8
	     WaveDifficulty=2.7f
	     NextSquadSpawnTime=1.275f
     End Object
	WaveList(8)=TurboMonsterWave'Wave9'
     
	Begin Object Class=TurboPlusWaveLateGame Name=Wave10
          MaxMonsters=50
          TotalMonsters=48
          RegularSequenceSize=7
          BeatSize=2
	     WaveDifficulty=2.75f
	     NextSquadSpawnTime=1.25f
	End Object
	WaveList(9)=TurboMonsterWave'Wave10'

     //Example definition of boss helper squads, their containing boss squads, then storing them into the BossSquadList.

     //Helper squads for each heal round boss squad.
     Begin Object Class=TurboMonsterSquad Name=HelperSquad0
          Squad(0)=(Monster=Clot,Count=4)
	End Object
     Begin Object Class=TurboMonsterSquad Name=HelperSquad1
          Squad(0)=(Monster=Clot,Count=4)
          Squad(1)=(Monster=Crawler,Count=4)
	End Object
     Begin Object Class=TurboMonsterSquad Name=HelperSquad2
          Squad(0)=(Monster=Clot,Count=4)
          Squad(1)=(Monster=Crawler,Count=4)
          Squad(2)=(Monster=Stalker,Count=4)
	End Object

     //Each heal round's boss squad.
	Begin Object Class=TurboMonsterBossSquad Name=BossSquad0
          Squad=TurboMonsterSquad'KFTurbo.TurboPlusMonsterCollectionWaveImpl.HelperSquad0'
	End Object

	Begin Object Class=TurboMonsterBossSquad Name=BossSquad1
          Squad=TurboMonsterSquad'KFTurbo.TurboPlusMonsterCollectionWaveImpl.HelperSquad1'
          SquadSizePerPlayerCount(0)=12
          SquadSizePerPlayerCount(1)=12
          SquadSizePerPlayerCount(2)=16
          SquadSizePerPlayerCount(3)=16
          SquadSizePerPlayerCount(4)=18
          SquadSizePerPlayerCount(5)=22
	End Object
     
	Begin Object Class=TurboMonsterBossSquad Name=BossSquad2
          Squad=TurboMonsterSquad'KFTurbo.TurboPlusMonsterCollectionWaveImpl.HelperSquad2'
          SquadSizePerPlayerCount(0)=16
          SquadSizePerPlayerCount(1)=16
          SquadSizePerPlayerCount(2)=20
          SquadSizePerPlayerCount(3)=20
          SquadSizePerPlayerCount(4)=22
          SquadSizePerPlayerCount(5)=26
	End Object

     //Storing the boss squads for each heal round.
     BossSquadList(0)=TurboMonsterBossSquad'KFTurbo.TurboPlusMonsterCollectionWaveImpl.BossSquad0'
     BossSquadList(1)=TurboMonsterBossSquad'KFTurbo.TurboPlusMonsterCollectionWaveImpl.BossSquad1'
     BossSquadList(2)=TurboMonsterBossSquad'KFTurbo.TurboPlusMonsterCollectionWaveImpl.BossSquad2'

}