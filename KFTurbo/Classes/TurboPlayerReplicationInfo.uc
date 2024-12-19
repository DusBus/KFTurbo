//Killing Floor Turbo TurboPlayerReplicationInfo
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboPlayerReplicationInfo extends KFPlayerReplicationInfo;

var int ShieldStrength;

var int HealthMax;
var int HealthHealed;
var bool bVotedForTraderEnd;

replication
{
	reliable if ( bNetDirty && (Role == Role_Authority) )
		ShieldStrength, HealthMax, HealthHealed, bVotedForTraderEnd;
}

function Timer()
{
    Super.Timer();
    
    if(Controller(Owner) != None && Controller(Owner).Pawn != None)
    {
        ShieldStrength = Controller(Owner).Pawn.ShieldStrength;
        HealthMax = Controller(Owner).Pawn.HealthMax;
    }
	else
    {
        ShieldStrength = 0.f;
		HealthMax = 100;
    }

    if (bOnlySpectator && bVotedForTraderEnd)
    {
        bVotedForTraderEnd = false;
    }
}

function RequestTraderEnd()
{
    local KFTurboGameType GameType;
    GameType = KFTurboGameType(Level.Game);
    
    if (GameType == None || GameType.bWaveInProgress || GameType.WaveCountDown <= 10)
    {
        return;
    }

    if (bAdmin)
    {
        bVotedForTraderEnd = true;
        GameType.AttemptTraderEnd(TurboPlayerController(Owner));
        return;
    }

    if (bVotedForTraderEnd)
    {
        return;
    }

    bVotedForTraderEnd = true;
    GameType.AttemptTraderEnd(TurboPlayerController(Owner));
}

function ClearTraderEndVote()
{
    bVotedForTraderEnd = false;
}

defaultproperties
{
    ShieldStrength=0

    HealthMax=100
    HealthHealed=0

    bVotedForTraderEnd=false
}