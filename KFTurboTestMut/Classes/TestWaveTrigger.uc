class TestWaveTrigger extends UseTrigger
	hidecategories(Advanced,Force,Karma,LightColor,Lighting,Sound,UseTrigger)
	placeable;

var TestLaneWaveManager LaneManager;
var class<TurboLocalMessage> HintMessageClass;
var HoldoutHumanPawn TargetPawn;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	foreach AllActors(class'TestLaneWaveManager', LaneManager, Tag)
	{
		break;
	}
}

function UsedBy(Pawn User)
{
	if (User.Role != ROLE_Authority || User.Controller == None || !User.Controller.bIsPlayer)
	{
		return;
	}
	
	Super.UsedBy(User);
}

simulated function Touch(Actor Other)
{
	local HoldoutHumanPawn Pawn;
	
	Pawn = HoldoutHumanPawn(Other);
	if (Pawn == None || !Pawn.IsLocallyControlled())
	{
		return;
	}

	TargetPawn = Pawn;
	BroadcastMessage(PlayerController(Pawn.Controller));
	SetTimer(0.5f, false);
}

simulated function Timer()
{
	local HoldoutHumanPawn TouchingPawn;
	if (TargetPawn == None || TargetPawn.Health <= 0)
	{
		return;
	}

	foreach TouchingActors(class'HoldoutHumanPawn', TouchingPawn)
	{
		if (TouchingPawn == TargetPawn)
		{
			BroadcastMessage(PlayerController(TargetPawn.Controller));
			SetTimer(0.5f, false);
			break;
		}
	}
}

simulated function BroadcastMessage(PlayerController PlayerController)
{
	if (HintMessageClass != None)
	{
		PlayerController.ReceiveLocalizedMessage(HintMessageClass,, PlayerController.PlayerReplicationInfo,,LaneManager);
	}
}

function TriggerEvent(Name EventName, Actor Other, Pawn EventInstigator)
{
	if (LaneManager == None)
	{
		return;
	}

	if (LaneManager.bIsActive)
	{
		LaneManager.Deactivate();
	}
	else
	{
		LaneManager.Activate(TurboHumanPawn(EventInstigator));
	}
}

defaultproperties
{
	HintMessageClass=class'TestToggleLaneMessage'
	Texture=Texture'Engine.SubActionTrigger'
}
