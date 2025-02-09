//Killing Floor Turbo TurboGameModifierReplicationLink
//ReplicationInfo that represents a voting instance. All voting through this is done via Yes/No.
//Distributed under the terms of the MIT License.
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboGameVoteBase extends ReplicationInfo
    abstract;

var TurboGameReplicationInfo OwnerGRI;

var config float VoteDuration; //Duration of this vote. Once this time is reached, the vote will expire.

enum EVote
{
    Unset,
    Yes,
    No
};
struct PlayerVoteEntry
{
    var TurboPlayerReplicationInfo TPRI;
    var EVote Vote;
};
var array<PlayerVoteEntry> VoteList;

enum EVotingState
{
    Initializing, //Default state.
    Started,
    InProgress,
    
    Expired,
    Succeeded,
    Failed
};
var EVotingState VoteState, LastVoteState;

var int VoteYesCount, LastVoteYesCount;
var int VoteNoCount, LastVoteNoCount;
var int TotalVoterCount;

var float VoteStartTime, VoteEndTime;

delegate OnVoteTallyChanged(TurboGameVoteBase VoteInstance);
delegate OnVoteStateChanged(TurboGameVoteBase VoteInstance);

replication
{
    reliable if(Role == ROLE_Authority)
        VoteState, VoteYesCount, VoteNoCount, TotalVoterCount, VoteStartTime, VoteEndTime;
}

simulated function PreBeginPlay()
{
    Super.PreBeginPlay();

    OwnerGRI = TurboGameReplicationInfo(Level.GRI);
}

simulated function PostNetBeginPlay()
{
    Super.PostNetBeginPlay();

    if (Role == ROLE_Authority)
    {
        return;
    }

    if (OwnerGRI == None)
    {
        OwnerGRI = TurboGameReplicationInfo(Level.GRI);

        if (OwnerGRI == None)
        {
            GotoState('WaitingForGameReplicationInfo');
        }
    }
}

simulated function PostNetReceive()
{

}

function ReceivedVote(TurboPlayerReplicationInfo TPRI, EVote Vote)
{
    EvaluateVote('ReceivedVote');
}

function SetVoteState(EVotingState NewVoteState)
{
    VoteState = NewVoteState;
    ForceNetUpdate();

    if (VoteState >= Expired)
    {
        GotoState('VoteComplete');
    }
}

function EvaluateVote(name Reason)
{
    
}

//Client-only state. Await reception of the GRI.
state WaitingForGameReplicationInfo
{
Begin:
    while (Level.GRI == None)
    {
        sleep(0.1f);
    }

    OwnerGRI = TurboGameReplicationInfo(Level.GRI);
    GotoState('VoteInProgress');
}

//Server-only state.
state VoteInProgress
{
Begin:
    sleep(VoteDuration);
    
}

state VoteComplete
{
    function ReceivedVote(TurboPlayerReplicationInfo TPRI, EVote Vote) {}
    function SetVoteState(EVotingState NewVoteState) {}

Begin:
    sleep(2.f);
    bTearOff = true;
    LifeSpan = 5.f;
}

//Make NetUpdateTime want to update now.
simulated function ForceNetUpdate()
{
    NetUpdateTime = Max(Level.TimeSeconds - ((1.f / NetUpdateFrequency) + 1.f), 0.1f);
}

defaultproperties
{
    NetUpdateFrequency=0.1f
}