//Killing Floor Turbo TurboEndTraderVoteMessage
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboEndTraderVoteMessage extends LocalMessage;

enum EEndTraderVoteMessage
{
    VoteHint,
    VoteStarted
};

var localized string EndTraderVoteHintString;

var localized string EndTraderVoteString;
var localized string AnonymousVoteUserString;

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
            return Repl(default.EndTraderVoteString, "%p", default.AnonymousVoteUserString);
        }

        return Repl(default.EndTraderVoteString, "%p", RelatedPRI_1.PlayerName);
    }
    else if (Switch == EEndTraderVoteMessage.VoteHint)
    {
        return default.EndTraderVoteHintString;
    }
}

defaultproperties
{
    EndTraderVoteHintString = "Trader time can be skipped by typing EndTrader in console."
    
    EndTraderVoteString = "%p started a vote to end trader. Type EndTrader in console to vote."
    AnonymousVoteUserString = "Someone"

    Lifetime=10
    bIsSpecial=false
    bIsConsoleMessage=true
}