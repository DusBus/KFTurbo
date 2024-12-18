class KFTurboLaneUseTrigger extends UseTrigger;

var float UseCooldown;
var float LastUseTime;

var float MessageCooldown;
var float LastMessageTime;

function UsedBy(Pawn Pawn)
{
	if (Level.TimeSeconds < (LastUseTime + UseCooldown) || KFHumanPawn(Pawn) == None)
	{
		return;
	}
	
	LastUseTime = Level.TimeSeconds;
	
	Super.UsedBy(Pawn);
}

function Touch(Actor Other)
{
	local Pawn Pawn;
	local PlayerController PlayerController;

	if (Level.TimeSeconds < (LastMessageTime + MessageCooldown))
	{
		return;
	}
	
	Pawn = KFHumanPawn(Other);
	if (Pawn == None || Pawn.Health <= 0)
	{
		return;
	}

	PlayerController = PlayerController(Pawn.Controller);

	if (PlayerController == None)
	{
		return;
	}

	LastMessageTime = Level.TimeSeconds;

	PlayerController.ReceiveLocalizedMessage(class'KFTurboLaneLocalMessage');
}

defaultproperties
{
    UseCooldown=1.f
	MessageCooldown=1.f
}
