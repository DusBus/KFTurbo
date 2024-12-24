//Killing Floor Turbo TurboPlayerEventHandler
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboPlayerEventHandler extends Object;

struct MonsterHitData
{
    var KFMonster Monster;
    var class<KFMonster> MonsterClass;
    var bool bIsHeadshot;
    var int DamageDealt;
};

static function OnPlayerFire(TurboPlayerController Player, WeaponFire FireMode);
static function OnPlayerFireHit(TurboPlayerController Player, WeaponFire FireMode, KFMonster HitMonster, class<KFMonster> MonsterClass, bool bHeadshot, int Damage);

static function OnPlayerMeleeFire(TurboPlayerController Player, KFMeleeFire FireMode);

static function OnPlayerMedicDartFire(TurboPlayerController Player, WeaponFire FireMode);

static function OnPlayerReload(TurboPlayerController Player, KFWeapon Weapon);

static function OnPlayerDealDamage(TurboPlayerController Player, Pawn Target, int Damage);

//Event registration.
static final function RegisterWaveHandler(Controller Target, class<TurboPlayerEventHandler> PlayerEventHandlerClass)
{
    local TurboPlayerController TurboPlayerController;
    local int Index;

    if (Target == None || PlayerEventHandlerClass == None)
    {
        return;
    }

    TurboPlayerController = TurboPlayerController(Target);

    if (TurboPlayerController == None)
    {
        return;
    }

    for (Index = 0; Index < TurboPlayerController.TurboPlayerEventHandlerList.Length; Index++)
    {
        if (TurboPlayerController.TurboPlayerEventHandlerList[Index] == PlayerEventHandlerClass)
        {
            return;
        }
    }

    TurboPlayerController.TurboPlayerEventHandlerList[TurboPlayerController.TurboPlayerEventHandlerList.Length] = PlayerEventHandlerClass;
}

//Event broadcasting.
static final function BroadcastPlayerFire(Controller Player, WeaponFire FireMode)
{
    local TurboPlayerController TurboPlayerController;
    local int Index;

    TurboPlayerController = TurboPlayerController(Player);

    if (TurboPlayerController == None)
    {
        return;
    }
    TurboPlayerController.ClientMessage("WeaponFire:"@FireMode.Weapon);

    for (Index = TurboPlayerController.TurboPlayerEventHandlerList.Length - 1; Index >= 0; Index--)
    {
        TurboPlayerController.TurboPlayerEventHandlerList[Index].static.OnPlayerFire(TurboPlayerController, FireMode);
    }
}

static final function CollectMonsterHitData(Actor Other, vector HitLocation, vector Direction, out MonsterHitData HitData, optional float HeadshotAdditionalScale)
{
    HitData.Monster = None;
    HitData.MonsterClass = None;
    HitData.bIsHeadshot = false;
    HitData.DamageDealt = 0;
    
    HitData.Monster = KFMonster(Other);
    if (HitData.Monster == None)
    {
        HitData.Monster = KFMonster(Other.Base);
    }

    if (HitData.Monster != None)
    {
        if (HeadshotAdditionalScale == 0.f)
        {
            HeadshotAdditionalScale = 1.f;
        }

        HitData.bIsHeadshot = !HitData.Monster.bDecapitated && HitData.Monster.IsHeadShot(HitLocation, Direction, HeadshotAdditionalScale);
        HitData.DamageDealt = HitData.Monster.Health;
    }
}

static final function FinalizeMonsterHitData(out MonsterHitData HitData)
{
    if (HitData.Monster != None)
    {
        HitData.DamageDealt -= HitData.Monster.Health;
    }
}

static final function BroadcastPlayerFireHit(Controller Player, WeaponFire FireMode, MonsterHitData HitData)
{
    local TurboPlayerController TurboPlayerController;
    local int Index;

    TurboPlayerController = TurboPlayerController(Player);

    if (TurboPlayerController == None || TurboPlayerController.Role != ROLE_Authority)
    {
        return;
    }

    FinalizeMonsterHitData(HitData);

    TurboPlayerController.ClientMessage("WeaponHit:"@FireMode.Weapon);

    for (Index = TurboPlayerController.TurboPlayerEventHandlerList.Length - 1; Index >= 0; Index--)
    {
        TurboPlayerController.TurboPlayerEventHandlerList[Index].static.OnPlayerFireHit(TurboPlayerController, FireMode, HitData.Monster, HitData.MonsterClass, HitData.bIsHeadshot, HitData.DamageDealt);
    }
}

static final function BroadcastPlayerMeleeFire(Controller Player, KFMeleeFire FireMode)
{
    local TurboPlayerController TurboPlayerController;
    local int Index;

    TurboPlayerController = TurboPlayerController(Player);

    if (TurboPlayerController == None)
    {
        return;
    }

    for (Index = TurboPlayerController.TurboPlayerEventHandlerList.Length - 1; Index >= 0; Index--)
    {
        TurboPlayerController.TurboPlayerEventHandlerList[Index].static.OnPlayerMeleeFire(TurboPlayerController, FireMode);
    }
}

static final function BroadcastPlayerMedicDartFire(Controller Player, WeaponFire FireMode)
{
    local TurboPlayerController TurboPlayerController;
    local int Index;

    TurboPlayerController = TurboPlayerController(Player);

    if (TurboPlayerController == None)
    {
        return;
    }

    for (Index = TurboPlayerController.TurboPlayerEventHandlerList.Length - 1; Index >= 0; Index--)
    {
        TurboPlayerController.TurboPlayerEventHandlerList[Index].static.OnPlayerMedicDartFire(TurboPlayerController, FireMode);
    }
}

static final function BroadcastPlayerReload(Controller Player, KFWeapon Weapon)
{
    local TurboPlayerController TurboPlayerController;
    local int Index;

    TurboPlayerController = TurboPlayerController(Player);

    if (TurboPlayerController == None)
    {
        return;
    }

    for (Index = TurboPlayerController.TurboPlayerEventHandlerList.Length - 1; Index >= 0; Index--)
    {
        TurboPlayerController.TurboPlayerEventHandlerList[Index].static.OnPlayerReload(TurboPlayerController, Weapon);
    }
}

static final function BroadcastPlayerDealDamage(Controller Player, Pawn Target, int Damage)
{
    local TurboPlayerController TurboPlayerController;
    local int Index;

    TurboPlayerController = TurboPlayerController(Player);

    if (TurboPlayerController == None)
    {
        return;
    }

    for (Index = TurboPlayerController.TurboPlayerEventHandlerList.Length - 1; Index >= 0; Index--)
    {
        TurboPlayerController.TurboPlayerEventHandlerList[Index].static.OnPlayerDealDamage(TurboPlayerController, Target, Damage);
    }
}