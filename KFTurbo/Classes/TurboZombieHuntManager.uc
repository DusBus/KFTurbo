//Killing Floor Turbo TurboZombieHuntManager
//Monitors doors and makes sure any door pairs are not bugged (only one is broken).
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboZombieHuntManager extends Info;

var int MonsterIndex;
var array<Monster> MonsterList;

function PostBeginPlay()
{
    Super.PostBeginPlay();

    SetTimer(1.f, false);
}

function Timer()
{
    GotoState('WatchMonsters');
}

state WatchMonsters
{
Begin:
    while (true)
    {
        MonsterList = class'TurboGameplayHelper'.static.GetMonsterPawnList(Level);
        for (MonsterIndex = MonsterList.Length - 1; MonsterIndex >= 0; MonsterIndex--)
        {
            UpdateMonster(MonsterList[MonsterIndex]);
            Sleep(0.025f);
        }

        Sleep(0.01f);
    }
}

final function UpdateMonster(Monster Monster)
{
    if (Monster == None || Monster.Health <= 0)
    {
        return;
    }

    if (Monster.Controller == None || Monster.Controller.Enemy == None || !Monster.Controller.IsInState('ZombieHunt'))
    {
        return;
    }

    if (KFMonsterController(Monster.Controller) == None)
    {
        return;
    }

    Monster.Controller.SeePlayer(Monster.Controller.Enemy);
}

defaultproperties
{
    MonsterIndex = 0
}