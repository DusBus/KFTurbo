class TurboPlusWaveMidGame extends TurboPlusWaveEarly;

defaultproperties
{
     MaxMonsters=45
     TotalMonsters=60
     WaveDifficulty=2.f
     RegularSequenceSize=9
     MinMixInSquadCount=2
     MaxMixInSquadCount=2
     BeatSize=2
	NextSquadSpawnTime=1.5f

     //REGULARS
     Begin Object Class=TurboMonsterSquad Name=MidGameSquad0
          Squad(0)=(Monster=Bloat,Count=2)
          Squad(1)=(Monster=Clot,Count=2)
	End Object
	RegularSquad(6)=TurboMonsterSquad'MidGameSquad0'

	Begin Object Class=TurboMonsterSquad Name=MidGameSquad1
          Squad(0)=(Monster=Husk,Count=2)
          Squad(1)=(Monster=Crawler,Count=2)
	End Object
	RegularSquad(7)=TurboMonsterSquad'MidGameSquad1'

	Begin Object Class=TurboMonsterSquad Name=MidGameSquad2
          Squad(0)=(Monster=Siren,Count=2)
          Squad(1)=(Monster=Clot,Count=2)
	End Object
	RegularSquad(8)=TurboMonsterSquad'MidGameSquad2'

     //MIXINS
	Begin Object Class=TurboMonsterSquad Name=MidGameBeatSquad1
          Squad(0)=(Monster=Scrake,Count=2)
	End Object
	MixInSquad(5)=TurboMonsterSquad'MidGameBeatSquad1'

     //BEATS
	Begin Object Class=TurboMonsterSquad Name=MidGameBeatSquad0
          Squad(0)=(Monster=Fleshpound,Count=2)
	End Object
	BeatSquad(3)=TurboMonsterSquad'MidGameBeatSquad0'
}
