class TurboMonsterCollection extends Object
     editinlinenew;

var TurboMonsterCollectionWave WaveList[10];
var TurboMonsterCollectionSquad BossSquadList[3];

//These arrays are a cached list of a wave's squads. We construct sequences with them using them to reset squad lists once they're empty.
var array<TurboMonsterCollectionSquad> RegularSquadList;
var array<TurboMonsterCollectionSquad> MixInList;
var array<TurboMonsterCollectionSquad> BeatSquadList;

final function InitializeForWave(int WaveNumber)
{
     local int Index, WaveMask;
     local TurboMonsterCollectionWave WaveObject;

     RegularSquadList.Length = 0;
     MixInList.Length = 0;
     BeatSquadList.Length = 0;

     WaveMask = 1;
     
     WaveObject = WaveList[WaveNumber];

     //All arrays are the same size.
     for (Index = 0; Index < ArrayCount(WaveObject.RegularSquad); Index++)
     {
          if ((WaveObject.RegularWaveMask & WaveMask) != 0)
          {
               RegularSquadList[RegularSquadList.Length] = WaveObject.RegularSquad[Index];
          }

          if ((WaveObject.MixInWaveMask & WaveMask) != 0)
          {
               MixInList[MixInList.Length] = WaveObject.MixInSquad[Index];
          }

          if ((WaveObject.BeatWaveMask & WaveMask) != 0)
          {
               BeatSquadList[BeatSquadList.Length] = WaveObject.BeatSquad[Index];
          }

          WaveMask *= 2;
     }
}

final function float GetDifficultModifier(float GameDifficulty)
{
    if ( GameDifficulty >= 7.0 ) // Hell on Earth
    {
        return 1.7f;
    }
    else if ( GameDifficulty >= 5.0 ) // Suicidal
    {
        return 1.5f;
    }
    else if ( GameDifficulty >= 4.0 ) // Hard
    {
        return 1.3f;
    }
    else if ( GameDifficulty >= 2.0 ) // Normal
    {
        return 1.0f;
    }
    
    return 0.7f;
}

final function float GetPlayerCountModifier(int PlayerCount)
{
    switch ( PlayerCount )
    {
        case 1:
            return 1.f;
        case 2:
            return 2.f;
        case 3:
            return 2.75f;
        case 4:
            return 3.5f;
        case 5:
            return 4.f;
        case 6:
            return 4.5f;
    }

    return float(PlayerCount) *0.8f;
}

final function int GetWaveTotalMonsters(int WaveNumber, float GameDifficulty, int PlayerCount )
{
     return float(WaveList[Clamp(WaveNumber, 0, 9)].TotalMonsters) * GetDifficultModifier(GameDifficulty) * GetPlayerCountModifier(PlayerCount);
}

final function int GetWaveMaxMonsters(int WaveNumber, float GameDifficulty, int PlayerCount)
{
     return WaveList[Clamp(WaveNumber, 0, 9)].MaxMonsters;
}

final function float GetWaveDifficulty(int WaveNumber)
{
     return WaveList[Clamp(WaveNumber, 0, 9)].WaveDifficulty;
}

defaultproperties
{

}
