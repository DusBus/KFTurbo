class MassDetonationExplosion extends KFNadeExplosion;

var array<Sound> ExplodeSounds;
var float ExplosionVolume;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
    
    if (Level.NetMode == NM_DedicatedServer)
    {
        return;
    }

	PlaySound(ExplodeSounds[Rand(ExplodeSounds.length)], ESoundSlot.SLOT_None, ExplosionVolume);
}

defaultproperties
{
    ExplosionVolume=2.f
    ExplodeSounds(0)=SoundGroup'KF_GrenadeSnd.Nade_Explode_1'
    ExplodeSounds(1)=SoundGroup'KF_GrenadeSnd.Nade_Explode_2'
    ExplodeSounds(2)=SoundGroup'KF_GrenadeSnd.Nade_Explode_3'
}