//Killing Floor Turbo CheatDeathLocalMessage
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class CheatDeathLocalMessage extends SayMessagePlus;

var localized string CheatDeathString;

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
    Result = default.CheatDeathString;
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

    CheatDeathString="%player has cheated death!"
}