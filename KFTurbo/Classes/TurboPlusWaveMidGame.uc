class TurboPlusWaveMidGame extends TurboPlusWaveEarly;

defaultproperties
{
     MaxMonsters=45
     TotalMonsters=40
     WaveDifficulty=2.5f
     RegularSequenceSize=9
     MinMixInSquadCount=2
     MaxMixInSquadCount=3
     BeatSize=2
	NextSquadSpawnTime=1.4f

     //REGULARS
     Begin Object Class=TurboMonsterSquad Name=MidGameSquad0
          Squad(0)=(Monster=Bloat,Count=2)
          Squad(1)=(Monster=Clot,Count=2)
	End Object
	RegularSquad(9)=TurboMonsterSquad'MidGameSquad0'

	Begin Object Class=TurboMonsterSquad Name=MidGameSquad1
          Squad(0)=(Monster=Husk,Count=2)
          Squad(1)=(Monster=Crawler,Count=2)
	End Object
	RegularSquad(10)=TurboMonsterSquad'MidGameSquad1'

	Begin Object Class=TurboMonsterSquad Name=MidGameSquad2
          Squad(0)=(Monster=Siren,Count=2)
          Squad(1)=(Monster=Clot,Count=2)
	End Object
	RegularSquad(11)=TurboMonsterSquad'MidGameSquad2'

     //MIXINS
	Begin Object Class=TurboMonsterSquad Name=MidGameMixInSquad0
          Squad(0)=(Monster=Scrake,Count=2)
	End Object
	MixInSquad(6)=TurboMonsterSquad'MidGameMixInSquad0'

     //BEATS
	Begin Object Class=TurboMonsterSquad Name=MidGameBeatSquad0
          Squad(0)=(Monster=Fleshpound,Count=2)
	End Object
	BeatSquad(4)=TurboMonsterSquad'MidGameBeatSquad0'
}
