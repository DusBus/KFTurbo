class TurboWaveEventHandler extends Object;

static function OnWaveStarted(KFTurboGameType GameType, int StartedWave);
//EndedWave is the wave number we just completed (is Invasion::WaveNum - 1 as this is called right after we incremented the wave count and setup the trader wave)
static function OnWaveEnded(KFTurboGameType GameType, int EndedWave);
//Allows for mutation of the generated next spawn squad.
static function OnNextSpawnSquadGenerated(KFTurboGameType GameType, out array < class<KFMonster> > NextSpawnSquad);

//Event registration.
static final function RegisterWaveHandler(Actor Context, class<TurboWaveEventHandler> WaveEventHandlerClass)
{
    local KFTurboGameType KFTurboGameType;
    local int Index;

    if (Context == None || WaveEventHandlerClass == None)
    {
        return;
    }

    KFTurboGameType = KFTurboGameType(Context.Level.Game);

    if (KFTurboGameType == None)
    {
        return;
    }

    for (Index = 0; Index < KFTurboGameType.WaveEventHandlerList.Length; Index++)
    {
        if (KFTurboGameType.WaveEventHandlerList[Index] == WaveEventHandlerClass)
        {
            return;
        }
    }

    KFTurboGameType.WaveEventHandlerList[KFTurboGameType.WaveEventHandlerList.Length] = WaveEventHandlerClass;
}

//Event broadcasting.
static final function BroadcastWaveStarted(KFTurboGameType GameType, int StartedWave)
{
    local KFTurboGameType KFTurboGameType;
    local int Index;

    if (GameType == None)
    {
        return;
    }

    for (Index = GameType.WaveEventHandlerList.Length - 1; Index >= 0; Index--)
    {
        KFTurboGameType.WaveEventHandlerList[Index].static.OnWaveStarted(GameType, StartedWave);
    }
}

static final function BroadcastWaveEnded(KFTurboGameType GameType, int EndedWave)
{
    local KFTurboGameType KFTurboGameType;
    local int Index;

    if (GameType == None)
    {
        return;
    }

    for (Index = GameType.EventHandlerList.Length - 1; Index >= 0; Index--)
    {
        KFTurboGameType.WaveEventHandlerList[Index].static.OnWaveEnded(GameType, EndedWave);
    }
}

static final function BroadcastNextSpawnSquadGenerated(KFTurboGameType GameType,  out array < class<KFMonster> > NextSpawnSquad)
{
    local KFTurboGameType KFTurboGameType;
    local int Index;

    if (GameType == None)
    {
        return;
    }

    for (Index = GameType.EventHandlerList.Length - 1; Index >= 0; Index--)
    {
        KFTurboGameType.WaveEventHandlerList[Index].static.OnNextSpawnSquadGenerated(GameType, NextSpawnSquad);
    }
}