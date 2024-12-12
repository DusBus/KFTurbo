//Killing Floor Turbo KFTurboPlusMessage
//For more information see https://github.com/KFPilot/KFTurbo.
class KFTurboPlusMessage extends TurboLocalMessage;

enum ETurboPlusMessage
{
    TraderHint
};

var localized string HowToTradeHint;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    switch(ETurboPlusMessage(Switch))
    {
        case TraderHint:
            return default.HowToTradeHint;
    }

    return "";
}

static function bool IgnoreLocalMessage(TurboPlayerController PlayerController, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    if (PlayerController == None && PlayerController.TurboInteraction == None)
    {
        return false;
    }

    if (Switch == ETurboPlusMessage.TraderHint)
    {
        return !class'TurboInteraction'.static.IsShiftTradeEnabled(PlayerController);
    }

    return true; //Undefined switch.
}

defaultproperties
{
    bIsSpecial=False
    bIsConsoleMessage=False
    Lifetime=3
    DrawColor=(B=255,G=255,R=255,A=255)

    HowToTradeHint="During trader time, press SHIFT to open the trader menu anywhere. The console command TRADE can also be used."
}
