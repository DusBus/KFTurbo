//Killing Floor Turbo TurboEndTraderVoteMessage
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboEndTraderVoteMessage extends TurboLocalMessage;

enum EEndTraderVoteMessage
{
    VoteHint,
    VoteStarted
};

var localized string AnonymousUserString;

var localized string EndTraderVoteHintString;
var localized string EndTraderVoteString;


static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
    if (Switch == EEndTraderVoteMessage.VoteStarted)
    {
        if (RelatedPRI_1 == None || RelatedPRI_1.PlayerName == "")
        {
            return FormatEndTraderString(default.EndTraderVoteString, default.AnonymousUserString);
        }

        return FormatEndTraderString(default.EndTraderVoteString, RelatedPRI_1.PlayerName);
    }
    else if (Switch == EEndTraderVoteMessage.VoteHint)
    {
        return FormatEndTraderString(default.EndTraderVoteHintString);
    }
}

static function final string FormatEndTraderString(string Input, optional string PlayerName)
{
    Input = FormatString(Input);
    
    if (PlayerName != "")
    {
        Input = Repl(Input, "%p", PlayerName);
    }

    return Input;
}

defaultproperties
{
    EndTraderVoteHintString = "%kTrader time %dcan be %kskipped %dby typing %dEndTrader in console%d."
    
    EndTraderVoteString = "%k%p %dstarted a vote to %kend trader%d. Type %kEndTrader in console %dto vote."
    AnonymousUserString = "Someone"

    Lifetime=10
    bIsSpecial=false
    bIsConsoleMessage=true
}