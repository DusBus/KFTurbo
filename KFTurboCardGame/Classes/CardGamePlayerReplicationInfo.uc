//Killing Floor Turbo CardGamePlayerReplicationInfo
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class CardGamePlayerReplicationInfo extends Engine.LinkedReplicationInfo
    dependson(Interactions);

var KFPlayerReplicationInfo OwningReplicationInfo;
var TurboCardReplicationInfo TurboCardReplicationInfo;
var int VoteIndex;

var array< class<TurboCard> > SelectedCardList;

replication
{
	reliable if ( bNetDirty && Role == ROLE_Authority )
		OwningReplicationInfo, TurboCardReplicationInfo, VoteIndex;
	reliable if ( Role < ROLE_Authority )
        SetVoteIndex;
}

static simulated final function CardGamePlayerReplicationInfo GetCardGameLRI(PlayerReplicationInfo PRI)
{
    local LinkedReplicationInfo LRI;

    if (PRI == None)
    {
        return None;
    }

    for (LRI = PRI.CustomReplicationInfo; LRI != None; LRI = LRI.NextReplicationInfo)
    {
        if (CardGamePlayerReplicationInfo(LRI) != None)
        {
            return CardGamePlayerReplicationInfo(LRI);
        }
    }
    
    return None;
}

simulated function bool ProcessVoteKeyPressEvent(Interactions.EInputKey Key)
{
    local float KeyVoteIndex;
    local Interactions.EInputKey Offset;

	if (!TurboCardReplicationInfo.bCurrentlyVoting)
    {
        return false;
    }

    if (Key <= IK_0 || Key > IK_9)
    {
        return false;
    }
    else
    {
        Offset = IK_0;
        KeyVoteIndex = int(Key) - int(Offset);

        if (class'TurboCardReplicationInfo'.static.ResolveCard(TurboCardReplicationInfo.SelectableCardList[KeyVoteIndex - 1]) == None)
        {
            KeyVoteIndex = 0;
        }
    }

    SetVoteIndex(KeyVoteIndex);
    return true;
}

function SetVoteIndex(int Index)
{
	if (!TurboCardReplicationInfo.bCurrentlyVoting)
    {
        return;
    }

    if (Index <= 0 || Index > 9 || class'TurboCardReplicationInfo'.static.ResolveCard(TurboCardReplicationInfo.SelectableCardList[Index - 1]) == None)
    {
        Index = 0;
    }

    VoteIndex = Index;
    NetUpdateTime = Level.TimeSeconds - 11.f;
}

function ResetVote()
{
    VoteIndex = 0;
}

defaultproperties
{
    VoteIndex = 0
    NetUpdateFrequency=0.1
}
