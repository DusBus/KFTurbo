class P_Gorefast_Assassin extends P_GoreFast_SUM;

simulated function PostBeginPlay()
{
      Super.PostBeginPlay();

      if (Level.NetMode != NM_DedicatedServer)
      {
            SetBoneScale(19, 1.5f, 'CHR_RArmForeArm');
      }
}

defaultproperties
{
      MeleeDamage=29
      MenuName="Assassin"
}