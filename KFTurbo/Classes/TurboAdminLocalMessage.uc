//Killing Floor Turbo TurboAdminLocalMessage.
//Local messages for admin commands.
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboAdminLocalMessage extends TurboLocalMessage;

enum EAdminCommand
{
	AC_SkipWave,//0
	AC_RestartWave,
	AC_SetWave,
	AC_SetTraderTime,
	AC_SetMaxPlayers,
    AC_PreventGameOver //5
};

//Debug commands.
var localized string SkippedWaveString;
var localized string RestartWaveString;
var localized string SetWaveString;

//Admin commands.
var localized string SetTraderString;
var localized string SetMaxPlayersString;
var localized string PreventGameOverString;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local int SwitchEnum;

    SwitchEnum = (Switch & 255);

    switch (EAdminCommand(SwitchEnum))
    {
        case AC_SkipWave:
            return FormatAdminString(default.SkippedWaveString, RelatedPRI_1);
        case AC_RestartWave:
            return FormatAdminString(default.RestartWaveString, RelatedPRI_1);
        case AC_SetWave:
            return Repl(FormatAdminString(default.SetWaveString, RelatedPRI_1), "%i", Switch >> 8);
        case AC_SetTraderTime:
            return Repl(FormatAdminString(default.SetTraderString, RelatedPRI_1), "%i", Switch >> 8);
        case AC_SetMaxPlayers:
            return Repl(FormatAdminString(default.SetMaxPlayersString, RelatedPRI_1), "%i", Switch >> 8);
        case AC_PreventGameOver:
            return FormatAdminString(default.PreventGameOverString, RelatedPRI_1);
    }

    return "";
}

static final function string FormatAdminString(string Input, PlayerReplicationInfo Invoker)
{
    Input = FormatString(Input);
    Input = Repl(Input, "%p", Invoker.PlayerName);
    return Input;
}

defaultproperties
{
    SkippedWaveString="%dThe %kcurrent wave%d has been %kskipped%d by %k%p%d."
    RestartWaveString="%dThe %kcurrent wave%d has been %krestarted%d by %k%p%d."
    SetWaveString="%dThe %kcurrent wave%d has been %kset to %i%d by %k%p%d."

    SetTraderString="%kTrader time%d has been %kset%d to %k%i seconds%d by %k%p%d."
    SetMaxPlayersString="%kMax players%d has been %kset%d to %k%i%d by %k%p%d."
    PreventGameOverString="%kPrevent Game Over%d has been %kenabled%d by %k%p%d."

    Lifetime=15
    bIsSpecial=false
    bIsConsoleMessage=true
}