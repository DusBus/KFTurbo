//Killing Floor Turbo TurboClientModifierReplicationLink
//Linked list of client modifications. Forwards mutator-like events but for things only the client cares about.
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboClientModifierReplicationLink extends ReplicationInfo
    abstract;

var TurboClientModifierReplicationLink NextClientModifierLink;
var TurboGameReplicationInfo OwnerGRI;

replication
{
    reliable if(bNetInitial && Role == ROLE_Authority)
        NextClientModifierLink, OwnerGRI;
}

simulated function ModifyMonster(KFMonster Monster) { if (NextClientModifierLink != None) { NextClientModifierLink.ModifyMonster(Monster); } }

//Make NetUpdateTime want to update now.
simulated function ForceNetUpdate()
{
    NetUpdateTime = Level.TimeSeconds - ((1.f / NetUpdateFrequency) + 1.f);
}

defaultproperties
{
    NetUpdateFrequency=0.1f
}