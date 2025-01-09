class RoulettePlayerEffect extends RouletteEffect;

#exec OBJ LOAD FILE=ProjectileSounds.uax

simulated function PostNetBeginPlay()
{
    Super(Emitter).PostNetBeginPlay();

    if (Level.NetMode != NM_DedicatedServer)
    {
        PlayOwnedSound(Sound'Steamland_SND.UI_Objective_Fail', SLOT_None, 4.f,, 5000.f);
    }
}

defaultproperties                                                                                                                             
{
    
}