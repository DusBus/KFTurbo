class TurboBroadcastHandler extends Engine.BroadcastHandler;

function BroadcastLocalized( Actor Sender, PlayerController Receiver, class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
	switch(Message)
	{
		case class'KFMod.WaitingMessage':
			Message = class'TurboMessageWaiting';
			break;
		case class'UnrealGame.PickupMessagePlus':
			Message = class'TurboMessagePickup';
			break;
		case class'ServerPerks.KFVetEarnedMessageSR':
			Message = class'TurboMessageVeterancy';
			break;
	}
	
	Super.BroadcastLocalized(Sender, Receiver, Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}

defaultproperties
{

}
