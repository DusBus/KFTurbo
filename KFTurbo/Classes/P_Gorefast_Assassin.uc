class P_Gorefast_Assassin extends P_GoreFast_SUM;

simulated function PostBeginPlay()
{
      Super.PostBeginPlay();

      if (Level.NetMode != NM_DedicatedServer)
      {
            SetBoneScale(19, 1.5f, 'CHR_RArmForeArm');
      }
}

static simulated function PreCacheMaterials(LevelInfo myLevel)
{
      Super.PreCacheMaterials(myLevel);
	myLevel.AddPrecacheMaterial(Shader'KFTurbo.Assassin.Assassin_SHDR');
}

defaultproperties
{
      MenuName="Assassin"
      Skins(0)=Shader'KFTurbo.Assassin.Assassin_SHDR'
      
      MeleeDamage=29
}