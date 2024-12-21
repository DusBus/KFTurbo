class TurboPlusWaveChallenge extends TurboPlusWaveLateGame; 

defaultproperties
{
	MaxMonsters=50
	TotalMonsters=48
	WaveDifficulty=2.75f
	RegularSequenceSize=11
	MinMixInSquadCount=4
	MaxMixInSquadCount=4
	BeatSize=3
	NextSquadSpawnTime=1.25f

    //REGULARS
	Begin Object Class=TurboMonsterSquad Name=ChallengeSquad0
		Squad(0)=(Monster=Siren,Count=2)
		Squad(1)=(Monster=Gorefast,Count=1)
	End Object
	RegularSquad(15)=TurboMonsterSquad'ChallengeSquad0'

	Begin Object Class=TurboMonsterSquad Name=ChallengeSquad1
		Squad(0)=(Monster=Husk,Count=2)
		Squad(1)=(Monster=Gorefast,Count=1)
	End Object
	RegularSquad(16)=TurboMonsterSquad'ChallengeSquad1'

	Begin Object Class=TurboMonsterSquad Name=ChallengeSquad2
		Squad(0)=(Monster=Bloat,Count=2)
	End Object
	RegularSquad(17)=TurboMonsterSquad'ChallengeSquad2'

    //MIXINS
	Begin Object Class=TurboMonsterSquad Name=ChallengeMixInSquad0
		Squad(0)=(Monster=Scrake,Count=2)
	End Object
	MixInSquad(9)=TurboMonsterSquad'ChallengeMixInSquad0'

	//BEATS
	Begin Object Class=TurboMonsterSquad Name=ChallengeBeatSquad0
		Squad(0)=(Monster=Fleshpound,Count=1)
	End Object
	BeatSquad(6)=TurboMonsterSquad'ChallengeBeatSquad0'
}
