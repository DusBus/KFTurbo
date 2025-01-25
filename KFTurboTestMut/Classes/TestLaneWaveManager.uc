class TestLaneWaveManager extends Info
	hidecategories(Advanced,Force,Karma,LightColor,Lighting,Sound,UseTrigger)
	placeable;

var TurboMonsterCollection TurboMonsterCollection;

var(LaneManager) Name VolumeTag;
var array<ZombieVolume> VolumeList;

var bool bIsActive;
var int WaveNumber;
var int PlayerCount;

//Properties that need to be reset when we start a wave.
var int TotalMonsters, MaxMonsters, RemainingMaxMonsters;
var float NextSpawnTime, SpawnTimer;
var array< class<KFMonster> > CurrentSquad;
var array<ZombieVolume> CurrentVolumeList;
var TurboHumanPawn WaveInstigator;

replication
{
	reliable if (Role == ROLE_Authority)
		WaveNumber, PlayerCount;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
}

simulated function ForceNetUpdate()
{
	NetUpdateTime = FMax(Level.TimeSeconds - (1.f / NetUpdateFrequency), 0.1f);
}

function SetWaveConfig(int NewWaveNumber, int NewPlayerCount)
{
	WaveNumber = NewWaveNumber;
	PlayerCount = NewPlayerCount;
	Deactivate();
}

function Activate(TurboHumanPawn NewWaveInstigator)
{
	WaveInstigator = NewWaveInstigator;
	GotoState('ActiveWave');
}

function Deactivate() {} //Does nothing if not activated.

function int GetMonsterCount()
{
	local int Index;
	local int Count;
	
	Count = 0;

	for (Index = 0; Index < VolumeList.Length; Index++)
	{
		Count += VolumeList[Index].ZEDList.Length;
	}	

	return Count;
}

state ActiveWave
{
	function BeginState()
	{
		bIsActive = true;
		TotalMonsters = TurboMonsterCollection.GetWaveTotalMonsters(WaveNumber, Level.Game.GameDifficulty, PlayerCount);
		MaxMonsters = TurboMonsterCollection.GetWaveMaxMonsters(WaveNumber, Level.Game.GameDifficulty, PlayerCount);
		NextSpawnTime = TurboMonsterCollection.GetNextSquadSpawnTime(WaveNumber, PlayerCount);
		SpawnTimer = NextSpawnTime;

		CurrentSquad.Length = 0;
		CurrentVolumeList.Length = 0;

		Enable('Tick');
		ForceNetUpdate();
	}

	function EndState()
	{
		ClearAllZeds();
		WaveInstigator = None;
		Disable('Tick');
		TurboMonsterCollection.Reset();
		bIsActive = false;
		ForceNetUpdate();
	}

	function Tick(float DeltaTime)
	{
		if (WaveInstigator == None || WaveInstigator.Health <= 0)
		{
			return;
		}

		UpdateCurrentSquad(DeltaTime);

		PerformSpawn();

		CheckIfWaveComplete();
	}

	function Activate(TurboHumanPawn NewWaveInstigator) {} //Does nothing if already activated.

	function Deactivate()
	{
		GotoState('');
	}
}

function UpdateCurrentSquad(float DeltaTime)
{
	local TurboMonsterSquad Squad;
	SpawnTimer -= DeltaTime;
	
	if (SpawnTimer > 0.f)
	{
		return;
	}

	if (CurrentSquad.Length != 0)
	{
		return;
	}

	Squad = TurboMonsterCollection.GetNextMonsterSquad();

	if (Squad == None)
	{
		return;
	}

	CurrentSquad = Squad.MonsterList;
	SpawnTimer += NextSpawnTime;
}

function PerformSpawn()
{
	local ZombieVolume Volume;

	if (CurrentSquad.Length == 0)
	{
		return;
	}

	if (CurrentVolumeList.Length == 0)
	{
		CurrentVolumeList = VolumeList;
	}

	if (CurrentVolumeList.Length == 0)
	{
		return;
	}

	RemainingMaxMonsters = Max(MaxMonsters - GetMonsterCount(), 0);

	Volume = CurrentVolumeList[0];
	CurrentVolumeList.Remove(0, 1);

	Volume.SpawnInHere(CurrentSquad, false,, TotalMonsters, RemainingMaxMonsters);
}

function CheckIfWaveComplete()
{
	if (TotalMonsters > 0)
	{
		return;
	}

	Deactivate();
}

function ClearAllZeds()
{
	local int Index, ZedIndex;
	local Controller DeathInstigator;
	
	DeathInstigator = None;
	if (WaveInstigator != None)
	{
		DeathInstigator = WaveInstigator.Controller;
	}

	for (Index = 0; Index < VolumeList.Length; Index++)
	{
		for (ZedIndex = 0; ZedIndex < VolumeList[Index].ZEDList.Length; ZedIndex++)
		{
			if (VolumeList[Index].ZEDList[ZedIndex] != None)
			{
				VolumeList[Index].ZEDList[ZedIndex].Died(DeathInstigator, class'KFMod.DamTypeDwarfAxe', VolumeList[Index].ZEDList[ZedIndex].Location);
			}
		}
	}	
}

defaultproperties
{
	bAlwaysRelevant=true
	bReplicateMovement=false
	NetUpdateFrequency=0.1f
	RemoteRole=ROLE_SimulatedProxy

	Texture=Texture'Engine.SubActionGameSpeed'
	DrawScale=2.f

	Begin Object Name=TurboPlusMonsterCollectionWaveImpl0 Class=TurboPlusMonsterCollectionWaveImpl
	End Object
    TurboMonsterCollection=TurboPlusMonsterCollectionWaveImpl'TurboPlusMonsterCollectionWaveImpl0'

	WaveNumber=1
	PlayerCount=1
}
