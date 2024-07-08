class KFPCustomZedHandler extends Actor;

struct MonsterReplacement
{
    var class<KFMonster> TargetParentClass;
    var class<KFMonster> ReplacementClass;
    var float ChanceToReplace;
};

var array<MonsterReplacement> ReplacementList;

function PostBeginPlay()
{
    local KFGameType KFGT;

    KFGT = KFGameType(Level.Game);

    Super.PostBeginPlay();
    
    SetTimer(10.f, false);
}

event Timer()
{
    local int Index;
    local KFGameType KFGT;

    if (AlreadyReplacedZedInSquad())
    {
        SetTimer(8.f + (FRand() * 4.f), false);
        return;
    }

    KFGT = KFGameType(Level.Game);

    if (FRand() < 0.5f)
    {
        SetTimer(8.f + (FRand() * 4.f), false);
        return;
    }

    for(Index = 0; Index < KFGT.NextSpawnSquad.Length; Index++)
    {
        AttemptReplaceMonster(KFGT.NextSpawnSquad[Index]);
    }

    SetTimer(8.f + (FRand() * 4.f), false);
}

function bool AlreadyReplacedZedInSquad()
{
    local int Index;
    local KFGameType KFGT;
    KFGT = KFGameType(Level.Game);

    if (KFGT == None)
    {
        return true;
    }
    
    for (Index = 0; Index < KFGT.NextSpawnSquad.Length; Index++)
    {
        switch (KFGT.NextSpawnSquad[Index])
        {
            case class'P_Gorefast_Classy':
            case class'P_Crawler_Jumper':
            case class'P_Bloat_Fathead':
                return true;
        }
    }

    return false;
}

function bool AttemptReplaceMonster(out class<KFMonster> Monster)
{
    local int Index;
    local bool bReplacedMonster;

    for (Index = 0; Index < ReplacementList.Length; Index++)
    {
        if (ClassIsChildOf(Monster, ReplacementList[Index].TargetParentClass) && (FRand() < ReplacementList[Index].ChanceToReplace))
        {
            Monster = ReplacementList[Index].ReplacementClass;
            bReplacedMonster = true;
        }
    }

    return bReplacedMonster;
}

defaultproperties
{
    ReplacementList(0)=(TargetParentClass=class'P_Gorefast',ReplacementClass=class'P_Gorefast_Classy',ChanceToReplace=0.25f)
    ReplacementList(1)=(TargetParentClass=class'P_Crawler',ReplacementClass=class'P_Crawler_Jumper',ChanceToReplace=0.1f)
    ReplacementList(2)=(TargetParentClass=class'P_Bloat',ReplacementClass=class'P_Bloat_Fathead',ChanceToReplace=0.1f)
    ReplacementList(3)=(TargetParentClass=class'P_Siren',ReplacementClass=class'P_Siren_Caroler',ChanceToReplace=0.1f)
}