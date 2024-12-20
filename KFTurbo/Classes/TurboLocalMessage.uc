//Killing Floor Turbo TurboLocalMessage
//Base class for KFTurbo local messages. Adds the ability to conditionally ignore a local message per player (on the client's end).
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboLocalMessage extends LocalMessage;

var Color KeywordColor;

static final function string FormatString(string Input)
{
    Input = Repl(Input, "%d", class'GameInfo'.static.MakeColorCode(default.DrawColor));
    Input = Repl(Input, "%k", class'GameInfo'.static.MakeColorCode(default.KeywordColor));
    return Input;
}

static function bool IgnoreLocalMessage(TurboPlayerController PlayerController, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    return false;
}

defaultproperties
{
    DrawColor=(B=255,G=255,R=255,A=255)
    KeywordColor=(R=120,G=145,B=255,A=255)
}