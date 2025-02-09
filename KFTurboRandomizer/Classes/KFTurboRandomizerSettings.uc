//Killing Floor Turbo KFTurboRandomizerSettings
//Configures the randomizer. Allows for modular implementations for the randomizer.
//Distributed under the terms of the MIT License.
//For more information see https://github.com/KFPilot/KFTurbo.
class KFTurboRandomizerSettings extends Object;

var editinline KFTurboRandomizerLoadoutCollection FleshpoundLoadout; //33% of lobby will have a loadout from this list (minimum of 1).
var editinline KFTurboRandomizerLoadoutCollection ScrakeLoadout; //33% of lobby will have a loadout from this list (minimum of 1).
var editinline KFTurboRandomizerLoadoutCollection EarlyWaveLoadout; //50% of lobby will have a loadout from this list (minimum of 1) (for the pre-fleshpound waves).
var editinline KFTurboRandomizerLoadoutCollection MiscLoadout; //Remainder of lobby will have a loadout from this list.
var editinline KFTurboRandomizerLoadoutCollection FunnyLoadout; //Randomly a Misc loadout will be swapped out for a funny one.

var editinline KFTurboRandomizerLoadoutCollection PatriarchTypeALoadout; //33% of lobby will receive a loadout from this list during Patriarch wave.
var editinline KFTurboRandomizerLoadoutCollection PatriarchTypeBLoadout; //33% of lobby will receive a loadout from this list during Patriarch wave
var editinline KFTurboRandomizerLoadoutCollection PatriarchFunnyLoadout; //Randomly a type A or B loadout will be swapped out for a funny one.

//Classes for starting equipment.
var class<KFWeapon> SingleWeaponClass;
var class<KFWeapon> DualiesWeaponClass;
var class<KFWeapon> FragWeaponClass;
var class<KFWeapon> SyringeWeaponClass;
var class<KFWeapon> WelderWeaponClass;
var class<KFWeapon> KnifeWeaponClass;

var array<KFTurboRandomizerLoadout> UsedEarlyWaveLoadoutList;

var array<KFTurboRandomizerLoadout> UsedFleshpoundLoadoutList;
var array<KFTurboRandomizerLoadout> UsedScrakeLoadoutList;

var array<KFTurboRandomizerLoadout> UsedMiscLoadoutList;
var array<KFTurboRandomizerLoadout> UsedFunnyLoadoutList;

var array<KFTurboRandomizerLoadout> UsedPatriarchTypeALoadoutList;
var array<KFTurboRandomizerLoadout> UsedPatriarchTypeBLoadoutList;
var array<KFTurboRandomizerLoadout> UsedPatriarchFunnyLoadoutList;

static final function RestoreLoadoutCollection(KFTurboRandomizerLoadoutCollection LoadoutCollection, out array<KFTurboRandomizerLoadout> UsedLoadoutList)
{
    local int LoadoutIndex, UsedLoadoutIndex;
    local bool bFoundLoadout;

    //Reset the loadout collection list.
    LoadoutCollection.LoadoutList = LoadoutCollection.default.LoadoutList;

    //Go through the used loadouts for this loadout collection and remove the ones we've used.
    for (LoadoutIndex = LoadoutCollection.LoadoutList.Length - 1; LoadoutIndex >= 0; LoadoutIndex--)
    {
        //Get rid of any accidentally empty elements.
        if (LoadoutCollection.LoadoutList[LoadoutIndex] == None)
        {
            LoadoutCollection.LoadoutList.Remove(LoadoutIndex, 1);
            continue;
        }

        bFoundLoadout = false;
        for (UsedLoadoutIndex = UsedLoadoutList.Length - 1; UsedLoadoutIndex >= 0; UsedLoadoutIndex--)
        {
            if (LoadoutCollection.LoadoutList[LoadoutIndex] != UsedLoadoutList[UsedLoadoutIndex])
            {
                continue;
            }

            bFoundLoadout = true;
            break;
        }

        if (!bFoundLoadout)
        {
            continue;
        }

        LoadoutCollection.LoadoutList.Remove(LoadoutIndex, 1);
    }

    //Empty the used loadout list.
    UsedLoadoutList.Length = 0;
}

static final function KFTurboRandomizerLoadout TakeLoadout(int Index, KFTurboRandomizerLoadoutCollection LoadoutCollection, out array<KFTurboRandomizerLoadout> UsedLoadoutList)
{
    local KFTurboRandomizerLoadout Loadout;
    Loadout = LoadoutCollection.LoadoutList[Index];
    LoadoutCollection.LoadoutList.Remove(Index, 1);
    UsedLoadoutList[UsedLoadoutList.Length] = Loadout;
    return Loadout;
}

function PrepareRandomization()
{
    RestoreLoadoutCollection(EarlyWaveLoadout, UsedEarlyWaveLoadoutList);

    RestoreLoadoutCollection(FleshpoundLoadout, UsedFleshpoundLoadoutList);
    RestoreLoadoutCollection(ScrakeLoadout,  UsedScrakeLoadoutList);
    
    RestoreLoadoutCollection(MiscLoadout, UsedMiscLoadoutList);
    RestoreLoadoutCollection(FunnyLoadout,  UsedFunnyLoadoutList);

    RestoreLoadoutCollection(PatriarchTypeALoadout, UsedPatriarchTypeALoadoutList);
    RestoreLoadoutCollection(PatriarchTypeBLoadout, UsedPatriarchTypeBLoadoutList);
    RestoreLoadoutCollection(PatriarchFunnyLoadout, UsedPatriarchFunnyLoadoutList);
}

function KFTurboRandomizerLoadout GetRandomFleshpoundLoadout()
{
    return TakeLoadout(FleshpoundLoadout.GetRandomIndex(), FleshpoundLoadout, UsedFleshpoundLoadoutList);
}

function KFTurboRandomizerLoadout GetRandomScrakeLoadout()
{
    return TakeLoadout(ScrakeLoadout.GetRandomIndex(), ScrakeLoadout, UsedScrakeLoadoutList);
}

function KFTurboRandomizerLoadout GetRandomEarlyWaveLoadout()
{
    return TakeLoadout(EarlyWaveLoadout.GetRandomIndex(), EarlyWaveLoadout, UsedEarlyWaveLoadoutList);
}

final function KFTurboRandomizerLoadout GetRandomMiscLoadout()
{
    return TakeLoadout(MiscLoadout.GetRandomIndex(), MiscLoadout, UsedMiscLoadoutList);
}

final function KFTurboRandomizerLoadout GetRandomFunnyLoadout()
{
    return TakeLoadout(FunnyLoadout.GetRandomIndex(), FunnyLoadout, UsedFunnyLoadoutList);
}

final function KFTurboRandomizerLoadout GetRandomPatriarchTypeALoadout()
{
    return TakeLoadout(PatriarchTypeALoadout.GetRandomIndex(), PatriarchTypeALoadout, UsedPatriarchTypeALoadoutList);
}

final function KFTurboRandomizerLoadout GetRandomPatriarchTypeBLoadout()
{
    return TakeLoadout(PatriarchTypeBLoadout.GetRandomIndex(), PatriarchTypeBLoadout, UsedPatriarchTypeBLoadoutList);
}

final function KFTurboRandomizerLoadout GetRandomPatriarchFunnyLoadout()
{
    return TakeLoadout(PatriarchFunnyLoadout.GetRandomIndex(), PatriarchFunnyLoadout, UsedPatriarchFunnyLoadoutList);
}

defaultproperties
{
    SingleWeaponClass=class'KFTurbo.W_9MM_Weap'
    DualiesWeaponClass=class'KFTurbo.W_Dual9MM_Weap'
    FragWeaponClass=class'KFTurbo.W_Frag_Weap'
    SyringeWeaponClass=class'KFTurbo.W_Syringe_Weap'
    WelderWeaponClass=class'KFMod.Welder'
    KnifeWeaponClass=class'KFTurbo.W_Knife_Weap'

    Begin Object Class=LoadoutCollection_Fleshpound Name=FleshpoundLoadoutCollection
    End Object
    FleshpoundLoadout=KFTurboRandomizerLoadoutCollection'KFTurboRandomizer.KFTurboRandomizerSettings.FleshpoundLoadoutCollection'

    Begin Object Class=LoadoutCollection_Scrake Name=ScrakeLoadoutCollection
    End Object
    ScrakeLoadout=KFTurboRandomizerLoadoutCollection'KFTurboRandomizer.KFTurboRandomizerSettings.ScrakeLoadoutCollection'

    Begin Object Class=LoadoutCollection_EarlyWave Name=EarlyWaveLoadoutCollection
    End Object
    EarlyWaveLoadout=KFTurboRandomizerLoadoutCollection'KFTurboRandomizer.KFTurboRandomizerSettings.EarlyWaveLoadoutCollection'
    
    Begin Object Class=LoadoutCollection_Misc Name=MiscLoadoutCollection
    End Object
    MiscLoadout=KFTurboRandomizerLoadoutCollection'KFTurboRandomizer.KFTurboRandomizerSettings.MiscLoadoutCollection'

    Begin Object Class=LoadoutCollection_Funny Name=FunnyLoadoutCollection
    End Object
    FunnyLoadout=KFTurboRandomizerLoadoutCollection'KFTurboRandomizer.KFTurboRandomizerSettings.FunnyLoadoutCollection'

    Begin Object Class=LoadoutCollection_PatriarchA Name=PatriarchALoadoutCollection
    End Object
    PatriarchTypeALoadout=KFTurboRandomizerLoadoutCollection'KFTurboRandomizer.KFTurboRandomizerSettings.PatriarchALoadoutCollection'

    Begin Object Class=LoadoutCollection_PatriarchB Name=PatriarchBLoadoutCollection
    End Object
    PatriarchTypeBLoadout=KFTurboRandomizerLoadoutCollection'KFTurboRandomizer.KFTurboRandomizerSettings.PatriarchBLoadoutCollection'

    Begin Object Class=LoadoutCollection_PatriarchFunny Name=PatriarchFunnyLoadoutCollection
    End Object
    PatriarchFunnyLoadout=KFTurboRandomizerLoadoutCollection'KFTurboRandomizer.KFTurboRandomizerSettings.PatriarchFunnyLoadoutCollection'
}