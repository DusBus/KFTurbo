class TurboPlusWaveEarly extends TurboMonsterCollectionWave;

defaultproperties
{
     MaxMonsters=32
     TotalMonsters=32
     WaveDifficulty=1.f

     RegularSequenceSize=8
     MinMixInSquadCount=1
     MaxMixInSquadCount=2

     BeatSize=0

     //Here is an example of a squad with 2 clots and 3 crawlers.
	Begin Object Class=TurboMonsterCollectionSquad Name=EarlySquad0
          Squad(0)=(Monster=Clot,Count=2)
          Squad(1)=(Monster=Crawler,Count=3)
	End Object
     //These TurboMonsterCollectionSquad'KFTurbo.TurboPlusWaveEarly.EarlySquad0' are fully qualified paths - that means that you can define a squad in this class and then reuse the squad in another class!
	RegularSquad(0)=TurboMonsterCollectionSquad'KFTurbo.TurboPlusWaveEarly.EarlySquad0'

     //Here is an example of a squad with 2 gorefasts and 1 clot.
	Begin Object Class=TurboMonsterCollectionSquad Name=EarlySquad1
          Squad(0)=(Monster=Gorefast,Count=2)
          Squad(1)=(Monster=Clot,Count=1)
	End Object
	RegularSquad(1)=TurboMonsterCollectionSquad'KFTurbo.TurboPlusWaveEarly.EarlySquad1'

     //An example of a couple of "mix in" squads.
	Begin Object Class=TurboMonsterCollectionSquad Name=EarlyMixInSquad0
          Squad(0)=(Monster=Scrake,Count=1)
          Squad(1)=(Monster=Stalker,Count=3)
	End Object
	MixInSquad(0)=TurboMonsterCollectionSquad'KFTurbo.TurboPlusWaveEarly.EarlyMixInSquad0'

	Begin Object Class=TurboMonsterCollectionSquad Name=EarlyMixInSquad1
          Squad(0)=(Monster=Scrake,Count=2)
          Squad(1)=(Monster=Clot,Count=1)
	End Object
	MixInSquad(1)=TurboMonsterCollectionSquad'KFTurbo.TurboPlusWaveEarly.EarlyMixInSquad1'

     //An example of a "beat" squad. Remember that if the wave's BeatSize is less than or equal to 0, these won't get used (but we can define them anyways).
	Begin Object Class=TurboMonsterCollectionSquad Name=EarlyBeatSquad0
          Squad(0)=(Monster=Fleshpound,Count=1)
	End Object
	BeatSquad(0)=TurboMonsterCollectionSquad'KFTurbo.TurboPlusWaveEarly.EarlyBeatSquad0'
}
