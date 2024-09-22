class TurboPlayerReplicationInfo extends KFPlayerReplicationInfo;

var int ShieldStrength;

var int HealthMax;
var int HealthHealed;

replication
{
	reliable if ( bNetDirty && (Role == Role_Authority) )
		ShieldStrength, HealthMax, HealthHealed;
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
}

defaultproperties
{
    ShieldStrength=0

    HealthMax=100
    HealthHealed=0
}