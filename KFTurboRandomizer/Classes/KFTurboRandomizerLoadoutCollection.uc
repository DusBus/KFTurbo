//Killing Floor Turbo KFTurboRandomizerLoadoutCollection
//Represents a collection of loadouts.
//Distributed under the terms of the MIT License.
//For more information see https://github.com/KFPilot/KFTurbo.
class KFTurboRandomizerLoadoutCollection extends Object;

var editinline array<KFTurboRandomizerLoadout> LoadoutList;

function int GetRandomIndex()
{
    return Rand(LoadoutList.Length);
}

defaultproperties
{
    
}