class TurboPlusWaveLateGame extends TurboPlusWaveMidGame;

defaultproperties
{
	MaxMonsters=50
	TotalMonsters=75
	WaveDifficulty=3.f
	RegularSequenceSize=8
	MinMixInSquadCount=3
	MaxMixInSquadCount=3
	BeatSize=2
	NextSquadSpawnTime=1.f

    //REGULARS
	Begin Object Class=TurboMonsterSquad Name=LateGameSquad5
		Squad(0)=(Monster=Siren,Count=3)
	End Object
	RegularSquad(9)=TurboMonsterSquad'LateGameSquad5'

	Begin Object Class=TurboMonsterSquad Name=LateGameSquad6
		Squad(0)=(Monster=Husk,Count=3)
	End Object
	RegularSquad(10)=TurboMonsterSquad'LateGameSquad6'

	Begin Object Class=TurboMonsterSquad Name=LateGameSquad7
		Squad(0)=(Monster=Bloat,Count=3)
	End Object
	RegularSquad(11)=TurboMonsterSquad'LateGameSquad7'

    //MIXINS
	Begin Object Class=TurboMonsterSquad Name=LateGameBeatSquad3
		Squad(0)=(Monster=Scrake,Count=2)
	End Object
	MixInSquad(6)=TurboMonsterSquad'LateGameBeatSquad3'

	//BEATS
	Begin Object Class=TurboMonsterSquad Name=LateGameBeatSquad0
		Squad(0)=(Monster=Fleshpound,Count=2)
	End Object
	BeatSquad(4)=TurboMonsterSquad'LateGameBeatSquad0' 

	Begin Object Class=TurboMonsterSquad Name=LateGameBeatSquad1
		Squad(0)=(Monster=Fleshpound,Count=2)
	End Object
	BeatSquad(5)=TurboMonsterSquad'LateGameBeatSquad1'
}
