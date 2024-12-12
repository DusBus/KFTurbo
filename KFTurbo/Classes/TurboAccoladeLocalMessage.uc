//Killing Floor Turbo TurboAccoladeLocalMessage
//Player perk level/achievement notification base class.
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboAccoladeLocalMessage extends TurboLocalMessage;

//If true, the earner of the accolade will also display this local message.
var bool bDisplayForAccoladeEarner;

static function bool IgnoreLocalMessage(TurboPlayerController PlayerController, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    return default.bDisplayForAccoladeEarner || (PlayerController.PlayerReplicationInfo != RelatedPRI_1);
}

//ACCOLADES USE THIS.
static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    return "";
}

defaultproperties
{
    bDisplayForAccoladeEarner=false
    bComplexString=true //We're skipping ANY drawing by setting this to true but not implementing RenderComplexMessage
    bIsConsoleMessage=false
    Lifetime=10
    
    DrawColor=(R=255,G=255,B=255,A=255)

    DrawPivot=DP_UpperRight
    StackMode=SM_Down

    FontSize=3

    PosX=0.95f
    PosY=0.5f
}