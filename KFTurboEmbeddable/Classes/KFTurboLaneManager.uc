//Killing Floor Turbo KFTurboLaneHelper
//Actor that assists with lane management for lane orientated maps.
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class KFTurboLaneManager extends Actor
	placeable
	hidecategories(Advanced,Collision,Display,Events,Force,Karma,LightColor,Lighting,Sound);

//If true, players may open and/or close waves during the game.
var(LaneManager) bool bAllowLaneChangesDuringWave;

var array<KFTurboLane> LaneList;
var int LastZombieVolumeLaneIndex;

function PostBeginPlay()
{
	local KFTurboLane LaneActor;
	Super.PostBeginPlay();

	foreach AllActors(class'KFTurboLane', LaneActor)
	{
		LaneList.Length = LaneList.Length + 1;
		LaneList[LaneList.Length - 1] = LaneActor;
		LaneActor.RegisterLaneManager(Self);
	}
}

function bool CanLaneChangeState(KFTurboLane Lane)
{
	if (!bAllowLaneChangesDuringWave && KFGameType(Level.Game).bWaveInProgress)
	{
		return false;
	}

	return true;
}

//Returns the next zombie volume to distribute teleporting zeds to.
function ZombieVolume GetNextZombieVolume()
{
	local ZombieVolume NextZombieVolume;
	if (LaneList.Length == 0)
	{
		return None;
	}

	if (LastZombieVolumeLaneIndex >= LaneList.Length)
	{
		LastZombieVolumeLaneIndex = 0;
	}

	NextZombieVolume = LaneList[LastZombieVolumeLaneIndex].GetNextZombieVolume();
	LastZombieVolumeLaneIndex++;

	return NextZombieVolume;
}

defaultproperties
{
	bAllowLaneChangesDuringWave = true

	bHidden=true
	bLightingVisibility=False
	DrawScale=2.000000
	Texture=Texture'Engine.S_NavP'

	RemoteRole=ROLE_None

	CollisionRadius=40.000000
	CollisionHeight=40.000000
	bCollideActors=False
	bBlockZeroExtentTraces=False
	bBlockNonZeroExtentTraces=False
	bSmoothKarmaStateUpdates=False
	bBlockHitPointTraces=False
}