class TurboEventHandler extends Object;

static function OnPawnIgnited(Pawn Instigator, Pawn Target, class<KFWeaponDamageType> DamageType, int BurnDamage);
static function OnPawnZapped(Pawn Instigator, Pawn Target, float ZapAmount, bool bCausedZapped);
static function OnPawnHarpooned(Pawn Instigator, Pawn Target, int CurrentHarpoonCount);

static function OnPawnDartHealed(Pawn Instigator, Pawn Target, int HealingAmount, HealingProjectile HealDart);
static function OnPawnSyringeHealed(Pawn Instigator, Pawn Target, int HealingAmount);
static function OnPawnGrenadeHealed(Pawn Instigator, Pawn Target, int HealingAmount);

static function OnBurnMitigatedDamage(Pawn Instigator, Pawn Target, int Damage, int MitigatedDamage);

static function OnPawnPushedWithMCZThrower(Pawn Instigator, Pawn Target, Vector VelocityAdded);


//Event registration.
static final function RegisterHandler(Actor Context, class<TurboEventHandler> EventHandlerClass)
{
    local KFTurboGameType KFTurboGameType;
    local int Index;

    if (Context == None)
    {
        return;
    }

    KFTurboGameType = KFTurboGameType(Context.Level.Game);

    if (KFTurboGameType == None)
    {
        return;
    }

    for (Index = 0; Index < KFTurboGameType.EventHandlerList.Length; Index++)
    {
        if (KFTurboGameType.EventHandlerList[Index] == EventHandlerClass)
        {
            return;
        }
    }

    KFTurboGameType.EventHandlerList[KFTurboGameType.EventHandlerList.Length] = EventHandlerClass;
}

//Event broadcasting.
static final function BroadcastPawnIgnited(Pawn Instigator, Pawn Target, class<KFWeaponDamageType> DamageType, int BurnDamage)
{
    local KFTurboGameType KFTurboGameType;
    local int Index;

    if (Instigator == None)
    {
        return;
    }

    KFTurboGameType = KFTurboGameType(Instigator.Level.Game);

    if (KFTurboGameType == None)
    {
        return;
    }

    for (Index = KFTurboGameType.EventHandlerList.Length - 1; Index >= 0; Index--)
    {
        KFTurboGameType.EventHandlerList[Index].static.OnPawnIgnited(Instigator, Target, DamageType, BurnDamage);
    }
}

static final function BroadcastPawnZapped(Pawn Instigator, Pawn Target, float ZapAmount, bool bCausedZapped)
{
    local KFTurboGameType KFTurboGameType;
    local int Index;

    if (Instigator == None)
    {
        return;
    }

    KFTurboGameType = KFTurboGameType(Instigator.Level.Game);

    if (KFTurboGameType == None)
    {
        return;
    }

    for (Index = KFTurboGameType.EventHandlerList.Length - 1; Index >= 0; Index--)
    {
        KFTurboGameType.EventHandlerList[Index].static.OnPawnZapped(Instigator, Target, ZapAmount, bCausedZapped);
    }
}

static final function BroadcastPawnHarpooned(Pawn Instigator, Pawn Target, int CurrentHarpoonCount)
{
    local KFTurboGameType KFTurboGameType;
    local int Index;

    if (Instigator == None)
    {
        return;
    }

    KFTurboGameType = KFTurboGameType(Instigator.Level.Game);

    if (KFTurboGameType == None)
    {
        return;
    }

    for (Index = KFTurboGameType.EventHandlerList.Length - 1; Index >= 0; Index--)
    {
        KFTurboGameType.EventHandlerList[Index].static.OnPawnHarpooned(Instigator, Target, CurrentHarpoonCount);
    }
}

static final function BroadcastPawnDartHealed(Pawn Instigator, Pawn Target, int HealingAmount, HealingProjectile HealDart)
{
    local KFTurboGameType KFTurboGameType;
    local int Index;

    if (Instigator == None)
    {
        return;
    }

    KFTurboGameType = KFTurboGameType(Instigator.Level.Game);

    if (KFTurboGameType == None)
    {
        return;
    }

    for (Index = KFTurboGameType.EventHandlerList.Length - 1; Index >= 0; Index--)
    {
        KFTurboGameType.EventHandlerList[Index].static.OnPawnDartHealed(Instigator, Target, HealingAmount, HealDart);
    }
}

static final function BroadcastPawnSyringeHealed(Pawn Instigator, Pawn Target, int HealingAmount)
{
    local KFTurboGameType KFTurboGameType;
    local int Index;

    if (Instigator == None)
    {
        return;
    }

    KFTurboGameType = KFTurboGameType(Instigator.Level.Game);

    if (KFTurboGameType == None)
    {
        return;
    }

    for (Index = KFTurboGameType.EventHandlerList.Length - 1; Index >= 0; Index--)
    {
        KFTurboGameType.EventHandlerList[Index].static.OnPawnSyringeHealed(Instigator, Target, HealingAmount);
    }
}

static final function BroadcastPawnGrenadeHealed(Pawn Instigator, Pawn Target, int HealingAmount)
{
    local KFTurboGameType KFTurboGameType;
    local int Index;

    if (Instigator == None)
    {
        return;
    }

    KFTurboGameType = KFTurboGameType(Instigator.Level.Game);

    if (KFTurboGameType == None)
    {
        return;
    }

    for (Index = KFTurboGameType.EventHandlerList.Length - 1; Index >= 0; Index--)
    {
        KFTurboGameType.EventHandlerList[Index].static.OnPawnGrenadeHealed(Instigator, Target, HealingAmount);
    }
}

static final function BroadcastBurnMitigatedDamage(Pawn Instigator, Pawn Target, int Damage, int MitigatedDamage)
{
    local KFTurboGameType KFTurboGameType;
    local int Index;

    if (Instigator == None)
    {
        return;
    }

    KFTurboGameType = KFTurboGameType(Instigator.Level.Game);

    if (KFTurboGameType == None)
    {
        return;
    }

    for (Index = KFTurboGameType.EventHandlerList.Length - 1; Index >= 0; Index--)
    {
        KFTurboGameType.EventHandlerList[Index].static.OnBurnMitigatedDamage(Instigator, Target, Damage, MitigatedDamage);
    }
}

static final function BroadcastPawnPushedWithMCZThrower(Pawn Instigator, Pawn Target, Vector VelocityAdded)
{
    local KFTurboGameType KFTurboGameType;
    local int Index;

    if (Instigator == None)
    {
        return;
    }

    KFTurboGameType = KFTurboGameType(Instigator.Level.Game);

    if (KFTurboGameType == None)
    {
        return;
    }

    for (Index = KFTurboGameType.EventHandlerList.Length - 1; Index >= 0; Index--)
    {
        KFTurboGameType.EventHandlerList[Index].static.OnPawnPushedWithMCZThrower(Instigator, Target, VelocityAdded);
    }
}