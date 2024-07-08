class P_Siren_Caroler extends P_Siren_XMA;

var float ExtraEffectCooldownTime;
var float NextExtraEffectSpawnTime;

simulated function SpawnTwoShots()
{
    if( bDecapitated || bZapped || bHarpoonStunned )
    {
        return;
    }

    SpawnExtraSirenScreamEffect();

    Super.SpawnTwoShots();
}

simulated function SpawnExtraSirenScreamEffect()
{
     local Emitter ExtraEffect;

     if (Level.NetMode == NM_DedicatedServer)
     {
          return;
     }

     if (Level.TimeSeconds < NextExtraEffectSpawnTime)
     {
          return;
     }

     NextExtraEffectSpawnTime = Level.TimeSeconds + ExtraEffectCooldownTime;
     ExtraEffect = Spawn(class'P_Siren_Caroler_Scream', self);
     ExtraEffect.AttachToBone(self, 'Collision_Attach');
}

defaultproperties
{
     MenuName="Caroler"
     
     ScreamForce=-3000000
     ScreamDamage=4

     ExtraEffectCooldownTime=4.5f
     NextExtraEffectSpawnTime=0.f
}
