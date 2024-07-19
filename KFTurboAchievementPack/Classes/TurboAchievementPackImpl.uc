class TurboAchievementPackImpl extends AchievementPackPartImpl;

function PostBeginPlay()
{
    Super.PostBeginPlay();

    class'KFTurbo.TurboEventHandler'.static.RegisterHandler(Self, class'TurboAchievementEventHandler');
}

final function bool IsAchievementComplete(int Index)
{
    return Achievements[Index].Completed != 0;
}

final function ResetProgress(int Index)
{
    if (IsAchievementComplete(Index))
    {
        return;
    }

    AddProgress(Index, -Achievements[Index].Progress);
}

//Only counts first time burn.
event OnPawnIgnited(Pawn Target, class<KFWeaponDamageType> DamageType, int BurnDamage);
event OnPawnZapped(Pawn Target, float ZapAmount, bool bCausedZapped);
event OnPawnHarpooned(Pawn Target, int CurrentHarpoonCount);

//HealedPawn will get called after DartHealPawn/SyringeHealPawn/GrenadeHealPawn
event OnPawnDartHeal(Pawn Target, int HealingAmount, HealingProjectile HealDart);
event OnPawnSyringeHeal(Pawn Target, int HealingAmount);
event OnPawnGrenadeHeal(Pawn Target, int HealingAmount);
event OnPawnHealed(Pawn Target, int HealingAmount);

event OnBurnMitigatedDamage(Pawn Target, int Damage, int MitigatedDamage);

event OnPawnPushedWithMCZThrower(Pawn Target, Vector VelocityAdded);

defaultproperties
{
    packName=""
}