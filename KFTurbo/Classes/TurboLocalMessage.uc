//Killing Floor Turbo TurboLocalMessage
//Base class for KFTurbo local messages. Adds the ability to conditionally ignore a local message per player (on the client's end).
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboLocalMessage extends LocalMessage;

static function bool IgnoreLocalMessage(TurboPlayerController PlayerController, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    return false;
}

defaultproperties
{

}