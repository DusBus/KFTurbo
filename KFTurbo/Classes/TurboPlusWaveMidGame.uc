class TurboPlusWaveMidGame extends TurboPlusWaveEarly;

defaultproperties
{
     MaxMonsters=47
     TotalMonsters=44
     WaveDifficulty=2.45f
     RegularSequenceSize=20
     MinMixInSquadCount=5
     MaxMixInSquadCount=5
     BeatSize=3
	NextSquadSpawnTime=0.f

     //REGULARS
     Begin Object Class=TurboMonsterSquad Name=MidGameSquad0
          Squad(0)=(Monster=Bloat,Count=1)
          Squad(1)=(Monster=Clot,Count=2)
	End Object
	RegularSquad(11)=TurboMonsterSquad'MidGameSquad0'

	Begin Object Class=TurboMonsterSquad Name=MidGameSquad1
          Squad(0)=(Monster=Husk,Count=1)
          Squad(1)=(Monster=Crawler,Count=2)
	End Object
	RegularSquad(12)=TurboMonsterSquad'MidGameSquad1'

	Begin Object Class=TurboMonsterSquad Name=MidGameSquad2
          Squad(0)=(Monster=Siren,Count=1)
          Squad(1)=(Monster=Stalker,Count=2)
	End Object
	RegularSquad(13)=TurboMonsterSquad'MidGameSquad2'

     //MIXINS
	Begin Object Class=TurboMonsterSquad Name=MidGameMixInSquad0
          Squad(0)=(Monster=Scrake,Count=2)
	End Object
	MixInSquad(6)=TurboMonsterSquad'MidGameMixInSquad0'

     //BEATS
	Begin Object Class=TurboMonsterSquad Name=MidGameBeatSquad0
          Squad(0)=(Monster=Fleshpound,Count=1)
	End Object
	BeatSquad(4)=TurboMonsterSquad'MidGameBeatSquad0'
}
