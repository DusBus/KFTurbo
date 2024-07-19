class TurboMonsterCollectionWave extends Object
     editinlinenew;

//Monster cap for this wave.
var int MaxMonsters;

//Total monsters for this wave (scaled by player/difficulty).
var int TotalMonsters;

var float WaveDifficulty;

//Squads that are shuffled in between "beats".
var TurboMonsterCollectionSquad RegularSquad[31];
var int RegularWaveMask; //Allows for a "base" class to define a bunch of squads and then use a wave mask to filter.

//Squads that are randomly placed into squads between "beats". 
var TurboMonsterCollectionSquad MixInSquad[31];
var int MixInWaveMask; //Allows for a "base" class to define a bunch of squads and then use a wave mask to filter.

//Squads that can be used for "beats".
var TurboMonsterCollectionSquad BeatSquad[31];
var int BeatWaveMask; //Allows for a "base" class to define a bunch of squads and then use a wave mask to filter.

//Number of regular squads to "roll" for a sequence between beats.
var int RegularSequenceSize;
//Number of MixIn squads to randomly add to the sequence between beats.
var int MinMixInSquadCount;
var int MaxMixInSquadCount;
//Number of Beat squads to use for beats between sequences.
var int BeatSize;

final function InitializeSquads(TurboMonsterCollection TurboCollection)
{
     local int Index;

     for (Index = ArrayCount(RegularSquad) - 1; Index >= 0; Index--)
     {
          if (RegularSquad[Index] == None)
          {
               continue;
          }

          RegularSquad[Index].InitializeSquad(TurboCollection);
     }

     for (Index = ArrayCount(MixInSquad) - 1; Index >= 0; Index--)
     {
          if (MixInSquad[Index] == None)
          {
               continue;
          }

          MixInSquad[Index].InitializeSquad(TurboCollection);
     }

     for (Index = ArrayCount(BeatSquad) - 1; Index >= 0; Index--)
     {
          if (BeatSquad[Index] == None)
          {
               continue;
          }

          BeatSquad[Index].InitializeSquad(TurboCollection);
     }
}

defaultproperties
{
     MaxMonsters=32
     TotalMonsters=32
     WaveDifficulty=1.f

     RegularSequenceSize=8
     MinMixInSquadCount=2
     MaxMixInSquadCount=4
     BeatSize=1
}
