//Killing Floor Turbo ExplodeDoorsActor
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class ExplodeDoorsActor extends Engine.Info;

var array<KFDoorMover> DoorList;
var int DoorListIndex;

function PostBeginPlay()
{
    Super.PostBeginPlay();

    SetTimer(0.5f, false);
}

function Timer()
{
    local KFDoorMover Door;

    if (Level.Game == None)
    {
        SetTimer(0.5f, false);
        return;
    }

    if (Level.Game.bWaitingToStartMatch)
    {
        SetTimer(0.5f, false);
        return;
    }

    if (KFGameType(Level.Game) != None && !KFGameType(Level.Game).bWaveInProgress)
    {
        SetTimer(0.5f, false);
        return;
    }
    
    foreach DynamicActors(class'KFDoorMover', Door)
    {
        if (Door.MyTrigger == None)
        {
            continue;
        }

        DoorList[DoorList.Length] = Door;
    }

    ExplodeDoors();
}

function ExplodeDoors()
{
    GotoState('ExplodingDoors');
}

state ExplodingDoors
{
Begin:
    DoorListIndex = 0;
    Sleep(1.f);
    while(DoorListIndex < DoorList.Length)
    {
        DoorList[DoorListIndex].GoBang(None, vect(0, 0, 0), vect(0, 0, 0), class'DamageType');
        DoorListIndex++;
        Sleep(0.1f);
    }

    GotoState('WaitingToExplodeDoors');
}

state WaitingToExplodeDoors
{
    function BeginState()
    {
        SetTimer(0.5f, false);
    }

    function Timer()
    {
        if (KFGameType(Level.Game) != None && !KFGameType(Level.Game).bWaveInProgress)
        {
            SetTimer(0.5f, false);
            return;
        }

        ExplodeDoors();
    }
}

defaultproperties
{

}