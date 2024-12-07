//Killing Floor Turbo KFTurboLaneHelper
//Actor that represents a lane that can be managed by a KFTurboLaneManager.
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class KFTurboLane extends Actor
	placeable
	hidecategories(Advanced,Display,Events,Sound);

//Tag for doors relevant to this lane.
var(Lane) Name DoorTag;
//Tag for spawners exclusive to this lane.
var(Lane) Name SpawnerTag;

var KFTurboLaneManager OwningManager;
var array<KFDoorMover> DoorList;
var array<ZombieVolume> SpawnerList;

var int DoorIndex;
var int SpawnerIndex;
var int ZombieIndex;

var int NextSpawnerIndex;

function PostBeginPlay()
{
	local KFDoorMover Door;
	local ZombieVolume Spawner;
	Super.PostBeginPlay();

	if (Role != ROLE_Authority)
	{
		return;
	}

	foreach AllActors(class'KFDoorMover', Door, DoorTag)
	{
		DoorList.Length = DoorList.Length + 1;
		DoorList[DoorList.Length - 1] = Door;
	}

	foreach AllActors(class'ZombieVolume', Spawner, SpawnerTag)
	{
		SpawnerList.Length = SpawnerList.Length + 1;
		SpawnerList[SpawnerList.Length - 1] = Spawner;
	}
}

function RegisterLaneManager(KFTurboLaneManager Manager)
{
	OwningManager = Manager;
}

state Open
{
	function Trigger(Actor Other, Pawn EventInstigator)
	{
		if (Role != ROLE_Authority && !OwningManager.CanLaneChangeState(Self))
		{
			return;
		}

		GotoState('Closed');
	}

Begin:
	if (OwningManager == None)
	{
		stop;
	}

	for (DoorIndex=0; DoorIndex < DoorList.Length; DoorIndex++)
	{
		DoorList[DoorIndex].DoOpen();
	}

	for (SpawnerIndex=0; SpawnerIndex < SpawnerList.Length; SpawnerIndex++)
	{
		SpawnerList[SpawnerIndex].bVolumeIsEnabled = true;
	}
}

state Closed
{
	function Trigger(Actor Other, Pawn EventInstigator)
	{
		if (Role != ROLE_Authority && !OwningManager.CanLaneChangeState(Self))
		{
			return;
		}
		
		GotoState('Open');
	}

Begin:
	if (OwningManager == None)
	{
		stop;
	}

	for (DoorIndex=0; DoorIndex < DoorList.Length; DoorIndex++)
	{
		DoorList[DoorIndex].DoClose();
	}

	for (SpawnerIndex=0; SpawnerIndex < SpawnerList.Length; SpawnerIndex++)
	{
		SpawnerList[SpawnerIndex].bVolumeIsEnabled = false;
	}

	for (SpawnerIndex=0; SpawnerIndex < SpawnerList.Length; SpawnerIndex++)
	{
		while(SpawnerList[SpawnerIndex].ZEDList.Length > 0)
		{
			Sleep(0.1f);
			MoveMonster(SpawnerList[SpawnerIndex].ZEDList[0]);
		}
	}
}

//Teleports a monster out to another open lane.
final function MoveMonster(KFMonster Monster)
{
	local ZombieVolume DestinationVolume;
	DestinationVolume = OwningManager.GetNextZombieVolume();

	if (DestinationVolume == None)
	{
		return;
	}

	if (Monster.SpawnVolume != None)
	{
		Monster.SpawnVolume.RemoveZEDFromSpawnList(Monster);
	}

	DestinationVolume.AddZEDToSpawnList(Monster);

	Monster.SetLocation(DestinationVolume.SpawnPos[Rand(DestinationVolume.SpawnPos.Length)]);
}

function ZombieVolume GetNextZombieVolume()
{
	local ZombieVolume NextZombieVolume;
	if (SpawnerList.Length == 0)
	{
		return None;
	}
	
	if (NextSpawnerIndex >= SpawnerList.Length)
	{
		NextSpawnerIndex = 0;
	}

	NextZombieVolume = SpawnerList[NextSpawnerIndex];
	NextSpawnerIndex++;

	return NextZombieVolume;
}

defaultproperties
{
	bHidden=True
	bLightingVisibility=False
	DrawScale=2.000000
	Texture=Texture'Engine.S_KHinge'

	RemoteRole=ROLE_None

	CollisionRadius=40.000000
	CollisionHeight=40.000000
	bCollideActors=False
	bBlockZeroExtentTraces=False
	bBlockNonZeroExtentTraces=False
	bSmoothKarmaStateUpdates=False
	bBlockHitPointTraces=False
}