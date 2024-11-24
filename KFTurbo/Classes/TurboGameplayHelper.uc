class TurboGameplayHelper extends Object;

const ASSUMED_PAWN_COUNT = 6;

static final function array<TurboHumanPawn> GetPlayerPawnList(LevelInfo Level)
{
    local Controller Controller;
    local TurboHumanPawn TurboHumanPawn;
    local array<TurboHumanPawn> HumanPawnList;
    local int FoundPawns;

    HumanPawnList.Length = ASSUMED_PAWN_COUNT;
    FoundPawns = 0;

    for ( Controller = Level.ControllerList; Controller != None; Controller = Controller.NextController )
    {
        if (Controller.bDeleteMe || !Controller.bIsPlayer)
        {
            continue;
        }

        if (Controller.Pawn == None || Controller.Pawn.bDeleteMe || Controller.Pawn.Health <= 0)
        {
            continue;
        }

        TurboHumanPawn = TurboHumanPawn(Controller.Pawn);

        if (TurboHumanPawn != None)
        {
            if (HumanPawnList.Length <= FoundPawns)
            {
                HumanPawnList.Length = FoundPawns + 2; //Allocate in steps of 2.
            }

            HumanPawnList[FoundPawns] = TurboHumanPawn;
            FoundPawns++;
        }
    }

    if (FoundPawns < HumanPawnList.Length)
    {
        HumanPawnList.Length = FoundPawns;
    }

    return HumanPawnList;
}


static final function array<Monster> GetMonsterPawnList(LevelInfo Level, optional class<Monster> FilterClass)
{
    local Controller Controller;
    local Monster MonsterPawn;
    local array<Monster> MonsterPawnList;
    local int FoundPawns;
    local int Index;

    for ( Controller = Level.ControllerList; Controller != None; Controller = Controller.NextController )
    {
        if (Controller.bDeleteMe || Controller.bIsPlayer)
        {
            continue;
        }

        if (Controller.Pawn == None || Controller.Pawn.bDeleteMe || Controller.Pawn.Health <= 0)
        {
            continue;
        }

        MonsterPawn = Monster(Controller.Pawn);

        if (MonsterPawn != None)
        {
            if (MonsterPawnList.Length <= FoundPawns)
            {
                MonsterPawnList.Length = FoundPawns + 8; //Allocate in steps of 4.
            }

            MonsterPawnList[FoundPawns] = MonsterPawn;
            FoundPawns++;
        }
    }

    if (FoundPawns < MonsterPawnList.Length)
    {
        MonsterPawnList.Length = FoundPawns;
    }

    if (FilterClass != None)
    {
        for (Index = MonsterPawnList.Length - 1; Index >= 0; Index--)
        {
            if (MonsterPawnList[Index] == None || !ClassIsChildOf(MonsterPawnList[Index].Class, FilterClass))
            {
                MonsterPawnList.Remove(Index, 1);
            }
        }
    }

    return MonsterPawnList;
}