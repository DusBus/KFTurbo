//Killing Floor Turbo TurboVersionLocalMessage
//Message to say there's an update available.
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboVersionLocalMessage extends TurboLocalMessage;

var localized string VersionChangeString;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    return default.VersionChangeString;
}

defaultproperties
{
    VersionChangeString="A new version of Killing Floor Turbo is available! The latest build can be found at github.com/KFPilot/KFTurbo/releases."

    Lifetime=20
    bIsSpecial=false
    bIsConsoleMessage=true
    DrawColor=(B=255,G=255,R=255,A=255)
}