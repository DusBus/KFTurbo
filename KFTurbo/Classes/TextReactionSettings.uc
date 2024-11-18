//Killing Floor Turbo TextReactionSettings
//Object that handles when a player receives a text message.
//NOTE: This is an object so actor members are not properly memory managed!
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class TextReactionSettings extends Object
	instanced
	abstract;

simulated function Initialize(TurboHUDKillingFloor HUD)
{
	
}

simulated function ReceivedMessage(TurboPlayerController PlayerController, string M, class<LocalMessage> MessageClass, PlayerReplicationInfo PRI)
{

}

defaultproperties
{

}