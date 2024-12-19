//Killing Floor Turbo TurboAdminLocalMessage.
//Local messages for admin commands.
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboAdminLocalMessage extends TurboLocalMessage;

enum EAdminCommand
{
	AC_SkipWave,
	AC_RestartWave,
	AC_SetWave,
	AC_ResetTrader,
};

var localized string SkippedWaveString;
var localized string RestartWaveString;
var localized string SetWaveString;

var localized string ResetTraderString;

var Color KeywordColor;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local int SwitchEnum;
    SwitchEnum = (Switch & 255);

    if (SwitchEnum == EAdminCommand.AC_SetWave)
    {
        return FormatSetWaveString(default.SetWaveString, Switch, RelatedPRI_1);
    }

    switch (EAdminCommand(SwitchEnum))
    {
        case AC_SkipWave:
            return FormatString(default.SkippedWaveString, RelatedPRI_1);
        case AC_RestartWave:
            return FormatString(default.RestartWaveString, RelatedPRI_1);
        case AC_ResetTrader:
            return FormatString(default.ResetTraderString, RelatedPRI_1);
    }

    return "";
}

static function final string FormatSetWaveString(string Input, int Data, PlayerReplicationInfo Invoker)
{
    local string Result;
    Result = FormatString(Input, Invoker);
    Data = Data >> 8;
    Result = Repl(Result, "%i", Data);
    return Result;
}

static function final string FormatString(string Input, PlayerReplicationInfo Invoker)
{
    Input = Repl(Input, "%d", class'GameInfo'.static.MakeColorCode(default.DrawColor));
    Input = Repl(Input, "%k", class'GameInfo'.static.MakeColorCode(default.KeywordColor));
    Input = Repl(Input, "%p", Invoker.PlayerName);
    return Input;
}

defaultproperties
{
    SkippedWaveString="%dThe %kcurrent wave%d has been %kskipped%d by %k%p%d."
    RestartWaveString="%dThe %kcurrent wave%d has been %krestarted%d by %k%p%d."
    SetWaveString="%dThe %kcurrent wave%d has been %kset to %i%d by %k%p%d."
    ResetTraderString="%kTrader time%d has been %kreset%d by %k%p%d."

    Lifetime=20
    bIsSpecial=false
    bIsConsoleMessage=true

    DrawColor=(B=255,G=255,R=255,A=255)
    KeywordColor=(R=120,G=145,B=255,A=255)
}