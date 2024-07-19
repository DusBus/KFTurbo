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

defaultproperties
{
     MaxMonsters=32
     TotalMonsters=32
     WaveDifficulty=1.f

     RegularSequenceSize=4
     MinMixInSquadCount=1
     MaxMixInSquadCount=1
     BeatSize=1
}
