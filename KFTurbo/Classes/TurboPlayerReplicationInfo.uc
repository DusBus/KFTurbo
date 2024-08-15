class TurboPlayerReplicationInfo extends KFPlayerReplicationInfo;

var int ShieldStrength;
var int HealthHealed;

replication
{
	reliable if ( bNetDirty && (Role == Role_Authority) )
		ShieldStrength, HealthHealed;
}

defaultproperties
{
    ShieldStrength=0
    HealthHealed=0
}