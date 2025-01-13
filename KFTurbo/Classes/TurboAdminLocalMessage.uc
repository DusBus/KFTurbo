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
    AC_PreventGameOver, //5
    AC_SetFakedPlayerCount,
    AC_SetPlayerHealthCount,
    AC_SetSpawnRateModifier,
    AC_SetMaxMonstersModifier //9
};

//Debug commands.
var localized string SkippedWaveString;
var localized string RestartWaveString;
var localized string SetWaveString;

//Admin commands.
var localized string SetTraderString;
var localized string SetMaxPlayersString;
var localized string PreventGameOverString;
var localized string SetFakedPlayerCountString;
var localized string SetPlayerHealthCountString;
var localized string SetSpawnRateModifierString;
var localized string SetMaxMonstersModifierString;

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
        case AC_SetFakedPlayerCount:
            return Repl(FormatAdminString(default.SetFakedPlayerCountString, RelatedPRI_1), "%i", Switch >> 8);
        case AC_SetPlayerHealthCount:
            return Repl(FormatAdminString(default.SetPlayerHealthCountString, RelatedPRI_1), "%i", Switch >> 8);
        case AC_SetSpawnRateModifier:
            return Repl(FormatAdminString(default.SetSpawnRateModifierString, RelatedPRI_1), "%f", DecodeFloat(Switch >> 8));
        case AC_SetMaxMonstersModifier:
            return Repl(FormatAdminString(default.SetMaxMonstersModifierString, RelatedPRI_1), "%f", DecodeFloat(Switch >> 8));
    }

    return "";
}

static final function string FormatAdminString(string Input, PlayerReplicationInfo Invoker)
{
    Input = FormatString(Input);
    Input = Repl(Input, "%p", Invoker.PlayerName);
    return Input;
}

static final function int EncodeFloat(float Value)
{
    Value *= 1000.f;
    return int(Value);
}

static final function float DecodeFloat(int Data)
{
    return float(Data) / 1000.f;
}

defaultproperties
{
    SkippedWaveString="%dThe %kcurrent wave%d has been %kskipped%d by %k%p%d."
    RestartWaveString="%dThe %kcurrent wave%d has been %krestarted%d by %k%p%d."
    SetWaveString="%dThe %kcurrent wave%d has been %kset to %i%d by %k%p%d."

    SetTraderString="%kTrader time%d has been %kset%d to %k%i seconds%d by %k%p%d."
    SetMaxPlayersString="%kMax players%d has been %kset%d to %k%i%d by %k%p%d."
    PreventGameOverString="%kPrevent Game Over%d has been %kenabled%d by %k%p%d."

    SetFakedPlayerCountString="%kFaked player%d count has been %kset%d to %k%i%d by %k%p%d."
    SetPlayerHealthCountString="%kMonster player health%d count has been %kset%d to %k%i%d by %k%p%d."
    SetSpawnRateModifierString="%kSpawn rate%d modifier has been %kset%d to %k%fx%d by %k%p%d."
    SetMaxMonstersModifierString="%kMax monster%d modifier has been %kset%d to %k%fx%d by %k%p%d."
    
    Lifetime=15
    bIsSpecial=false
    bIsConsoleMessage=true
}