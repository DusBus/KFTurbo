class KFProGameType extends KFGameType
    config (KFPro);

var int DTFStandardMaxZombiesOnce;
var int DTFStartingCash;
var int DTFMinRespawnCash;
var float DTFNextSpawnTime;
var int FakedPlayerHealth;

var bool bIsHighDifficulty;

function PreBeginPlay()
{
    local ZombieVolume ZV;
    Super.PreBeginPlay();
 
   foreach AllActors(Class'ZombieVolume',ZV)
   {
	   if (ZV != None)
	   {
		   ZV.CanRespawnTime = FMin(ZV.CanRespawnTime, DTFNextSpawnTime);
	   }
   }
}

function PostBeginPlay()
{
    local KFLevelRules KFLR;
    local KFGameType KFGT;

    Super.PostBeginPlay();
 
	foreach AllActors(class'KFLevelRules', KFLR)
	{
		break;
	}
 
	if (KFLR == None)
	{
		KFLR = Spawn(class'KFLevelRules');
	}

    KFLR.WaveSpawnPeriod = DTFNextSpawnTime;
 
    KFGT = KFGameType(Level.Game);
 
    if(KFGT != None)
    {
        KFGT.StartingCash = DTFStartingCash;
        KFGT.MinRespawnCash = DTFMinRespawnCash;
        KFGT.StandardMaxZombiesOnce = DTFStandardMaxZombiesOnce;
    }
}

State MatchInProgress
{
    function BeginState()
    {
        Super.BeginState();

        WaveCountDown = 60;
        OpenShops();
    }
}

simulated function float CalcNextSquadSpawnTime()
{
    return DTFNextSpawnTime;
}

defaultproperties
{
    DTFStartingCash=42069
    DTFMinRespawnCash=42069
    DTFStandardMaxZombiesOnce=48
    DTFNextSpawnTime=1.f
    FakedPlayerHealth=0
    bIsHighDifficulty=true

    ShortWaves(0)=(WaveMask=37748732,WaveMaxMonsters=15,WaveDifficulty=2.000000)
    ShortWaves(1)=(WaveMask=100250113,WaveMaxMonsters=35,WaveDifficulty=2.000000)
    ShortWaves(2)=(WaveMask=100250113,WaveMaxMonsters=50,WaveDifficulty=2.000000)
    ShortWaves(3)=(WaveMask=100250113,WaveMaxMonsters=60,WaveDifficulty=2.000000)
    NormalWaves(0)=(WaveMask=37748732,WaveMaxMonsters=15,WaveDifficulty=2.000000)
    NormalWaves(1)=(WaveMask=37748732,WaveMaxMonsters=35,WaveDifficulty=2.000000)
    NormalWaves(3)=(WaveMask=100250113,WaveMaxMonsters=40,WaveDifficulty=2.000000)
    NormalWaves(5)=(WaveMask=100250113,WaveMaxMonsters=45,WaveDifficulty=2.000000)
    NormalWaves(7)=(WaveMask=100250113,WaveMaxMonsters=50,WaveDuration=255,WaveDifficulty=2.000000)
    NormalWaves(8)=(WaveMask=100250113,WaveMaxMonsters=50,WaveDuration=255,WaveDifficulty=2.000000)
    NormalWaves(9)=(WaveMask=100250113,WaveMaxMonsters=60,WaveDuration=255,WaveDifficulty=2.000000)
    LongWaves(0)=(WaveMask=37748732,WaveMaxMonsters=35,WaveDifficulty=2.000000)
    LongWaves(1)=(WaveMask=37748732,WaveMaxMonsters=35,WaveDifficulty=2.000000)
    LongWaves(2)=(WaveMask=100250113,WaveMaxMonsters=40,WaveDifficulty=2.000000)
    LongWaves(3)=(WaveMask=100250113,WaveMaxMonsters=40,WaveDifficulty=2.000000)
    LongWaves(4)=(WaveMask=100250113,WaveMaxMonsters=45,WaveDifficulty=2.000000)
    LongWaves(5)=(WaveMask=100250113,WaveMaxMonsters=45,WaveDifficulty=2.000000)
    LongWaves(6)=(WaveMask=100250113,WaveMaxMonsters=50,WaveDifficulty=2.000000)
    LongWaves(7)=(WaveMask=100250113,WaveMaxMonsters=50,WaveDifficulty=2.000000)
    LongWaves(8)=(WaveMask=100250113,WaveMaxMonsters=55,WaveDifficulty=2.000000)
    LongWaves(9)=(WaveMask=100250113,WaveMaxMonsters=60,WaveDifficulty=2.000000)
    MonsterCollection=Class'KFTurbo.MC_DEF'
    StandardMonsterSquads(2)="2B2I"
    StandardMonsterSquads(6)="3A2C12"
    StandardMonsterSquads(9)="1A3C2H"
    StandardMonsterSquads(11)="4A4C2H"
    StandardMonsterSquads(12)="3A1B2D1G1H"
    StandardMonsterSquads(13)="3A"
    StandardMonsterSquads(14)="2A1E"
    StandardMonsterSquads(15)="2A3C1E"
    StandardMonsterSquads(16)="2B3D1G1H"
    StandardMonsterSquads(17)="4A1C"
    StandardMonsterSquads(18)="4A"
    StandardMonsterSquads(19)="4D"
    StandardMonsterSquads(20)="2G"
    StandardMonsterSquads(21)="2E"
    StandardMonsterSquads(22)="2I13H4B"
    StandardMonsterSquads(24)="2F"
    StandardMonsterSquads(25)="3F"
    StandardMonsterSquads(26)="2H"
    StandardMonsterSquads(27)="2I"
    ShortSpecialSquads(2)=(ZedClass=("KFTurbo.P_Bloat_STA","KFTurbo.P_Siren_STA","KFTurbo.P_SC_STA","KFTurbo.P_FP_STA"),NumZeds=(1,2,1,1))
    ShortSpecialSquads(3)=(ZedClass=("KFTurbo.P_Bloat_STA","KFTurbo.P_Siren_STA","KFTurbo.P_SC_STA","KFTurbo.P_FP_STA"),NumZeds=(1,2,1,2))
    NormalSpecialSquads(3)=(ZedClass=("KFTurbo.P_FP_HAL"),NumZeds=(1))
    NormalSpecialSquads(4)=(ZedClass=("KFTurbo.P_Bloat_STA","KFTurbo.P_Siren_STA","KFTurbo.P_FP_STA"),NumZeds=(1,1,1))
    NormalSpecialSquads(5)=(ZedClass=("KFTurbo.P_Bloat_STA","KFTurbo.P_Siren_STA","KFTurbo.P_SC_STA","KFTurbo.P_FP_STA"),NumZeds=(1,2,1,1))
    NormalSpecialSquads(6)=(ZedClass=("KFTurbo.P_Bloat_STA","KFTurbo.P_Siren_STA","KFTurbo.P_SC_STA","KFTurbo.P_FP_STA"),NumZeds=(1,2,1,2))
    LongSpecialSquads(4)=(ZedClass=("KFTurbo.P_Crawler_STA","KFTurbo.P_Gorefast_XMA","KFTurbo.P_Stalker_STA","KFTurbo.P_SC_HAL"),NumZeds=(2,2,1,1))
    LongSpecialSquads(6)=(ZedClass=("KFTurbo.P_FP_HAL"),NumZeds=(1))
    LongSpecialSquads(7)=(ZedClass=("KFTurbo.P_Bloat_STA","KFTurbo.P_Siren_STA","KFTurbo.P_FP_STA"),NumZeds=(1,1,1))
    LongSpecialSquads(8)=(ZedClass=("KFTurbo.P_Bloat_STA","KFTurbo.P_Siren_STA","KFTurbo.P_SC_STA","KFTurbo.P_FP_STA"),NumZeds=(1,2,1,1))
    LongSpecialSquads(9)=(ZedClass=("KFTurbo.P_Bloat_STA","KFTurbo.P_Siren_STA","KFTurbo.P_SC_STA","KFTurbo.P_FP_STA"),NumZeds=(1,2,1,2))
    FinalSquads(0)=(ZedClass=("KFTurbo.P_Siren_HAL"),NumZeds=(4))
    FinalSquads(1)=(ZedClass=("KFTurbo.P_SC_HAL","KFTurbo.P_Crawler_STA"),NumZeds=(3,1))
    FinalSquads(2)=(ZedClass=("KFTurbo.P_Siren_XMA","KFTurbo.P_Stalker_STA","KFTurbo.P_FP_HAL"),NumZeds=(3,1,1))
    SpecialEventMonsterCollections(0)=Class'KFTurbo.MC_DEF'
    SpecialEventMonsterCollections(1)=Class'KFTurbo.MC_SUM'
    SpecialEventMonsterCollections(2)=Class'KFTurbo.MC_HAL'
    SpecialEventMonsterCollections(3)=Class'KFTurbo.MC_XMA'

    GameName="Killing Floor Turbo+ Mode"
    Description="Turbo+ mode of the vanilla Killing Floor Game Type."
    ScreenShotName="KFTurbo.Generic.KFTurbo_FB"
}
