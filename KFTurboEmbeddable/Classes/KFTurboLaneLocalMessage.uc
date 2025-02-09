//Killing Floor Turbo KFTurboLaneLocalMessage
//Distributed under the terms of the MIT License.
//For more information see https://github.com/KFPilot/KFTurbo.
class KFTurboLaneLocalMessage extends LocalMessage;

var localized string ToggleLaneMessage;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    return default.ToggleLaneMessage;
}

defaultproperties
{
    bIsSpecial=false
    bIsConsoleMessage=false

    ToggleLaneMessage="Press 'USE' to toggle lane."
}