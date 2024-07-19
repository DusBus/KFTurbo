class KFTurboRandomizerLoadoutCollection extends Object;

var editinline array<KFTurboRandomizerLoadout> LoadoutList;

function int GetRandomIndex()
{
    return Rand(LoadoutList.Length);
}

defaultproperties
{
    
}