//Killing Floor Turbo MarkedForDeathLocalMessage
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class MarkedForDeathLocalMessage extends SayMessagePlus;

var localized string MarkedForDeathString;

static function RenderComplexMessage(
	Canvas Canvas,
	out float XL,
	out float YL,
	optional string MessageString,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{}

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string Result;
    Result = default.MarkedForDeathString;
    Result = Repl(Result, "%player", RelatedPRI_1.PlayerName);
    return Result;
}

static function string AssembleString(
	HUD myHUD,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional String MessageString
	)
{
	if ( RelatedPRI_1 == None )
		return "";
	if ( RelatedPRI_1.PlayerName == "" )
		return "";
	return GetString(Switch, RelatedPRI_1);
}

defaultproperties
{
    bIsConsoleMessage=true
    Lifetime=10
    
    DrawColor=(R=255,G=255,B=255,A=255)

    MarkedForDeathString="%player has been marked for death this wave!"
}