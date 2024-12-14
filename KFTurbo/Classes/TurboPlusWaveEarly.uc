class TurboPlusWaveEarly extends TurboMonsterWave;

defaultproperties
{
	MaxMonsters=45
	TotalMonsters=25
	WaveDifficulty=2.f
	RegularSequenceSize=9
	MinMixInSquadCount=2
	MaxMixInSquadCount=2
	BeatSize=2
	NextSquadSpawnTime=1.5f

	//REGULARS
	Begin Object Class=TurboMonsterSquad Name=EarlySquad0
		Squad(0)=(Monster=Clot,Count=2)
		Squad(1)=(Monster=Crawler,Count=2)
	End Object
	RegularSquad(0)=TurboMonsterSquad'EarlySquad0'

	Begin Object Class=TurboMonsterSquad Name=EarlySquad1
		Squad(0)=(Monster=Gorefast,Count=2)
		Squad(1)=(Monster=Clot,Count=2)
	End Object
	RegularSquad(1)=TurboMonsterSquad'EarlySquad1'

	Begin Object Class=TurboMonsterSquad Name=EarlySquad2
		Squad(0)=(Monster=Bloat,Count=1)
		Squad(1)=(Monster=Crawler,Count=2)
	End Object
	RegularSquad(2)=TurboMonsterSquad'EarlySquad2'

	Begin Object Class=TurboMonsterSquad Name=EarlySquad3
		Squad(0)=(Monster=Siren,Count=1)
		Squad(1)=(Monster=Clot,Count=2)
	End Object
	RegularSquad(3)=TurboMonsterSquad'EarlySquad3'

	Begin Object Class=TurboMonsterSquad Name=EarlySquad4
		Squad(0)=(Monster=Stalker,Count=2)
		Squad(1)=(Monster=Gorefast,Count=2)
	End Object
	RegularSquad(4)=TurboMonsterSquad'EarlySquad4'

	Begin Object Class=TurboMonsterSquad Name=EarlySquad5
		Squad(0)=(Monster=Husk,Count=1)
		Squad(1)=(Monster=Crawler,Count=2)
	End Object
	RegularSquad(5)=TurboMonsterSquad'EarlySquad5'

	Begin Object Class=TurboMonsterSquad Name=EarlySquad6
		Squad(0)=(Monster=Bloat,Count=2)
		Squad(1)=(Monster=Clot,Count=2)
	End Object
	RegularSquad(6)=TurboMonsterSquad'EarlySquad6'

	Begin Object Class=TurboMonsterSquad Name=EarlySquad7
		Squad(0)=(Monster=Husk,Count=2)
		Squad(1)=(Monster=Crawler,Count=2)
	End Object
	RegularSquad(7)=TurboMonsterSquad'EarlySquad7'

	Begin Object Class=TurboMonsterSquad Name=EarlySquad8
		Squad(0)=(Monster=Siren,Count=2)
		Squad(1)=(Monster=Clot,Count=2)
	End Object
	RegularSquad(8)=TurboMonsterSquad'EarlySquad8'

	//MIXINS
	Begin Object Class=TurboMonsterSquad Name=EarlyMixInSquad0
		Squad(0)=(Monster=Scrake,Count=1)
		Squad(1)=(Monster=Siren,Count=1)
	End Object
	MixInSquad(0)=TurboMonsterSquad'EarlyMixInSquad0'

	Begin Object Class=TurboMonsterSquad Name=EarlyMixInSquad1
		Squad(0)=(Monster=Scrake,Count=2)
	End Object
	MixInSquad(1)=TurboMonsterSquad'EarlyMixInSquad1'

	Begin Object Class=TurboMonsterSquad Name=EarlyMixInSquad2
		Squad(0)=(Monster=Scrake,Count=1)
		Squad(1)=(Monster=Husk,Count=1)
	End Object
	MixInSquad(2)=TurboMonsterSquad'EarlyMixInSquad2'

	Begin Object Class=TurboMonsterSquad Name=EarlyMixInSquad3
		Squad(0)=(Monster=Scrake,Count=1)
		Squad(1)=(Monster=Bloat,Count=1)
	End Object
	MixInSquad(3)=TurboMonsterSquad'EarlyMixInSquad3'

	Begin Object Class=TurboMonsterSquad Name=EarlyMixInSquad4
		Squad(0)=(Monster=Scrake,Count=1)
		Squad(1)=(Monster=Gorefast,Count=2)
	End Object
	MixInSquad(4)=TurboMonsterSquad'EarlyMixInSquad4'

	Begin Object Class=TurboMonsterSquad Name=EarlyMixInSquad5
          Squad(0)=(Monster=Scrake,Count=2)
	End Object
	MixInSquad(5)=TurboMonsterSquad'EarlyMixInSquad5'

	//BEATS
	Begin Object Class=TurboMonsterSquad Name=EarlyBeatSquad0
		Squad(0)=(Monster=Fleshpound,Count=1)
	End Object
	BeatSquad(0)=TurboMonsterSquad'EarlyBeatSquad0'

	Begin Object Class=TurboMonsterSquad Name=EarlyBeatSquad1
		Squad(0)=(Monster=Fleshpound,Count=1)
		Squad(1)=(Monster=Scrake,Count=1)
	End Object
	BeatSquad(1)=TurboMonsterSquad'EarlyBeatSquad1'

	Begin Object Class=TurboMonsterSquad Name=EarlyBeatSquad2
		Squad(0)=(Monster=Fleshpound,Count=1)
		Squad(1)=(Monster=Bloat,Count=1)
	End Object
	BeatSquad(2)=TurboMonsterSquad'EarlyBeatSquad2'

	Begin Object Class=TurboMonsterSquad Name=EarlyBeatSquad3
		Squad(0)=(Monster=Fleshpound,Count=1)
		Squad(1)=(Monster=Siren,Count=1)
	End Object
	BeatSquad(3)=TurboMonsterSquad'EarlyBeatSquad3'
}