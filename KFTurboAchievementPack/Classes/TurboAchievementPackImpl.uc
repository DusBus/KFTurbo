class TurboAchievementPackImpl extends AchievementPackPartImpl;

var bool bNotifyOtherPlayers;
var localized string OtherPlayerUnlockedAchievementString;
var Color AchievementTextColor, AchievementTitleColor;

function PostBeginPlay()
{
    Super.PostBeginPlay();

    class'KFTurbo.TurboEventHandler'.static.RegisterHandler(Self, class'TurboAchievementEventHandler');
    class'KFTurbo.TurboHealEventHandler'.static.RegisterHealHandler(Self, class'TurboAchievementHealEventHandler');
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

function AchievementCompleted(int Index)
{
    if (Achievements[Index].Completed != 0)
    {
        return;
    }

    Super.AchievementCompleted(Index);

    if (bNotifyOtherPlayers)
    {
        NotifyOtherPlayers(Index);
    }
}

function NotifyOtherPlayers(int Index)
{
    local PlayerReplicationInfo OwnerPRI;

    if (Role != ROLE_Authority || OwnerController == None)
    {
        return;
    }

    if (Index < 0 || Achievements.Length <= Index)
    {
        return;
    }

    OwnerPRI = OwnerController.PlayerReplicationInfo;

    if (OwnerPRI == None)
    {
        return;
    }

    BroadcastLocalizedMessage(class'TurboAccoladeAchievementLocalMessage', Index, OwnerPRI, None, Class);
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

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
    local string Result, TextColorCode, AchievementColorCode;

    if (RelatedPRI_1 == None || Switch < 0 || default.Achievements.Length <= Switch)
    {
        return "";
    }

    TextColorCode = class'GameInfo'.static.MakeColorCode(default.AchievementTextColor);
    AchievementColorCode = class'GameInfo'.static.MakeColorCode(default.AchievementTitleColor);

    Result = default.OtherPlayerUnlockedAchievementString;
    Result = Repl(Result, "%player", AchievementColorCode $ RelatedPRI_1.PlayerName $ TextColorCode);
    Result = Repl(Result, "%ach", AchievementColorCode $ default.Achievements[Switch].Title $ TextColorCode);
    Result = Repl(Result, "%pack", AchievementColorCode $ default.PackName $ TextColorCode);
    return Result;
}

defaultproperties
{
    packName=""
    bNotifyOtherPlayers=true
    OtherPlayerUnlockedAchievementString="%player has unlocked the achievement %ach (%pack)!"
    AchievementTextColor=(R=255,G=255,B=255,A=255)
    AchievementTitleColor=(R=120,G=145,B=255,A=255)
}