class TurboPlusWaveLateGame extends TurboPlusWaveMidGame; 

defaultproperties
{
	MaxMonsters=49
	TotalMonsters=48
	WaveDifficulty=2.6f
	RegularSequenceSize=11
	MinMixInSquadCount=3
	MaxMixInSquadCount=3
	BeatSize=2
	NextSquadSpawnTime=1.15f

    //REGULARS
	Begin Object Class=TurboMonsterSquad Name=LateGameSquad0
		Squad(0)=(Monster=Siren,Count=2)
		Squad(1)=(Monster=Gorefast,Count=2)
	End Object
	RegularSquad(12)=TurboMonsterSquad'LateGameSquad0'

	Begin Object Class=TurboMonsterSquad Name=LateGameSquad1
		Squad(0)=(Monster=Husk,Count=2)
		Squad(1)=(Monster=Gorefast,Count=1)
	End Object
	RegularSquad(13)=TurboMonsterSquad'LateGameSquad1'

	Begin Object Class=TurboMonsterSquad Name=LateGameSquad2
		Squad(0)=(Monster=Bloat,Count=2)
		Squad(1)=(Monster=Gorefast,Count=1)
	End Object
	RegularSquad(14)=TurboMonsterSquad'LateGameSquad2'

    //MIXINS
	Begin Object Class=TurboMonsterSquad Name=LateGameMixInSquad0
		Squad(0)=(Monster=Scrake,Count=1)
		Squad(1)=(Monster=Siren,Count=1)
	End Object
	MixInSquad(7)=TurboMonsterSquad'LateGameMixInSquad0'

	Begin Object Class=TurboMonsterSquad Name=LateGameMixInSquad1
		Squad(0)=(Monster=Scrake,Count=2)
	End Object
	MixInSquad(8)=TurboMonsterSquad'LateGameMixInSquad1'

	//BEATS
	Begin Object Class=TurboMonsterSquad Name=LateGameBeatSquad0
		Squad(0)=(Monster=Fleshpound,Count=2)
	End Object
	BeatSquad(5)=TurboMonsterSquad'LateGameBeatSquad0'
}
