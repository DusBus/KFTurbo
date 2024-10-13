//Killing Floor Turbo CardGameWaveEventHandler
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class DeEvolutionWaveEventHandler extends KFTurbo.TurboWaveEventHandler;

struct DeEvolutionMonsterReplacement
{
    var class<KFMonster> TargetParentClass;
    var class<KFMonster> ReplacementClass;
};

var array<DeEvolutionMonsterReplacement> ReplacementList; //List of KFMonster parent classes, their replacement, and individual chance to be applied.

static function OnNextSpawnSquadGenerated(KFTurboGameType GameType, out array < class<KFMonster> > NextSpawnSquad)
{
    local int SquadIndex;
    for (SquadIndex = 0; SquadIndex < NextSpawnSquad.Length; SquadIndex++)
    {
        if (FRand() < 0.1f)
        {
            AttemptReplaceMonster(NextSpawnSquad[SquadIndex]);
        }
    }
}

static final function AttemptReplaceMonster(out class<KFMonster> Monster)
{
    local int ReplacementIndex;
    for (ReplacementIndex = 0; ReplacementIndex < default.ReplacementList.Length; ReplacementIndex++)
    {
        if (ClassIsChildOf(Monster, default.ReplacementList[ReplacementIndex].TargetParentClass))
        {
            Monster = default.ReplacementList[ReplacementIndex].ReplacementClass;
            return;
        }
    }
}

defaultproperties
{
    ReplacementList(0)=(TargetParentClass=class'P_Clot',ReplacementClass=class'P_Clot_Weak')
    ReplacementList(1)=(TargetParentClass=class'P_Gorefast',ReplacementClass=class'P_Gorefast_Weak')
    ReplacementList(2)=(TargetParentClass=class'P_Crawler',ReplacementClass=class'P_Crawler_Weak')
    ReplacementList(3)=(TargetParentClass=class'P_Bloat',ReplacementClass=class'P_Bloat_Weak')
    ReplacementList(4)=(TargetParentClass=class'P_Husk',ReplacementClass=class'P_Husk_Weak')
    ReplacementList(5)=(TargetParentClass=class'P_Siren',ReplacementClass=class'P_Siren_Weak')
    ReplacementList(6)=(TargetParentClass=class'P_Scrake',ReplacementClass=class'P_Scrake_Weak')
    ReplacementList(7)=(TargetParentClass=class'P_Fleshpound',ReplacementClass=class'P_Fleshpound_Weak')
}