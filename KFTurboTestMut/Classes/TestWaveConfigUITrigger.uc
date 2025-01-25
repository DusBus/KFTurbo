class TestWaveConfigUITrigger extends UseTrigger
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

simulated function UsedBy(Pawn User)
{
	if (User.Controller == None || !User.Controller.bIsPlayer || !User.IsLocallyControlled())
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
		PlayerController.ReceiveLocalizedMessage(HintMessageClass,, PlayerController.PlayerReplicationInfo);
	}
}

simulated event TriggerEvent(Name EventName, Actor Other, Pawn EventInstigator)
{
	if (EventInstigator == None || !EventInstigator.IsLocallyControlled())
	{
		return;
	}

	KFTTPlayerController(EventInstigator.Controller).ShowWaveControlUI(LaneManager);
}

defaultproperties
{
	Texture=Texture'Engine.SubActionTrigger'
	HintMessageClass=class'TestWaveConfigUITrigger'
	DrawScale=1.5f
}
