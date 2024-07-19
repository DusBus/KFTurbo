class TurboPlusWaveMidGame extends TurboPlusWaveEarly;

defaultproperties
{
     MaxMonsters=32
     TotalMonsters=32
     WaveDifficulty=1.f

     RegularSequenceSize=7
     MinMixInSquadCount=2
     MaxMixInSquadCount=3
     BeatSize=1

	Begin Object Class=TurboMonsterCollectionSquad Name=MidGameSquad2
          Squad(0)=(Monster=Bloat,Count=1)
          Squad(1)=(Monster=Clot,Count=2)
	End Object
	RegularSquad(2)=TurboMonsterCollectionSquad'KFTurbo.TurboPlusWaveMidGame.MidGameSquad2'

	Begin Object Class=TurboMonsterCollectionSquad Name=MidGameSquad3
          Squad(0)=(Monster=Husk,Count=1)
          Squad(1)=(Monster=Crawler,Count=3)
	End Object
	RegularSquad(3)=TurboMonsterCollectionSquad'KFTurbo.TurboPlusWaveMidGame.MidGameSquad3'

	Begin Object Class=TurboMonsterCollectionSquad Name=MidGameSquad4
          Squad(0)=(Monster=Siren,Count=1)
          Squad(1)=(Monster=Stalker,Count=2)
	End Object
	RegularSquad(4)=TurboMonsterCollectionSquad'KFTurbo.TurboPlusWaveMidGame.MidGameSquad4'

	Begin Object Class=TurboMonsterCollectionSquad Name=MidGameBeatSquad2
          Squad(0)=(Monster=Scrake,Count=3)
	End Object
	MixInSquad(2)=TurboMonsterCollectionSquad'KFTurbo.TurboPlusWaveMidGame.MidGameBeatSquad2'

	Begin Object Class=TurboMonsterCollectionSquad Name=MidGameBeatSquad0
          Squad(0)=(Monster=Fleshpound,Count=2)
	End Object
	BeatSquad(1)=TurboMonsterCollectionSquad'KFTurbo.TurboPlusWaveMidGame.MidGameBeatSquad0'
}
