//Killing Floor Turbo TurboDoorManager
//Monitors doors and makes sure any door pairs are not bugged (only one is broken).
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboDoorManager extends Info;

var array<KFUseTrigger> UseTriggerList;
var int TriggerIndex;

function PostBeginPlay()
{
    Super.PostBeginPlay();

    SetTimer(1.f, false);
}

//Defer collection of use triggers to make sure doors had time to link up.
function Timer()
{
    local KFUseTrigger UserTrigger;

    foreach DynamicActors(class'KFUseTrigger', UserTrigger)
    {
        if (UserTrigger == None || UserTrigger.DoorOwners.Length == 0)
        {
            continue;
        }

        UseTriggerList[UseTriggerList.Length] = UserTrigger;
    }
}

auto state WatchDoors
{
Begin:
    while (true)
    {
        for (TriggerIndex = 0; TriggerIndex < UseTriggerList.Length; TriggerIndex++)
        {
            CheckUseTrigger(UseTriggerList[TriggerIndex]);
            Sleep(0.05f);
        }

        Sleep(0.05f);
    }
}

final function CheckUseTrigger(KFUseTrigger UseTrigger)
{
    local int DoorIndex;
    local bool bHasBrokenDoor;
    local bool bHasAliveDoor;
    local KFDoorMover Door;

    bHasBrokenDoor = false;
    bHasAliveDoor = false;

    for (DoorIndex = 0; DoorIndex < UseTrigger.DoorOwners.Length; DoorIndex++)
    {
        if (UseTrigger.DoorOwners[DoorIndex].bDoorIsDead)
        {
            bHasBrokenDoor = true;
        }
        else
        {
            bHasAliveDoor = true;
        }
    }

    //Check if both are present.
    if (bHasBrokenDoor && bHasAliveDoor)
    {
        for (DoorIndex = 0; DoorIndex < UseTrigger.DoorOwners.Length; DoorIndex++)
        {
            Door = UseTrigger.DoorOwners[DoorIndex];

            if (Door.bDoorIsDead)
            {
                continue;
            }

            Door.GoBang(None, Door.Location, vect(0.f, 0.f, 0.f), None);
        }
    }
}

defaultproperties
{
    TriggerIndex = 0
}