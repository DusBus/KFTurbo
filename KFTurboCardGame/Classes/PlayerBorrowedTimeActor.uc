//Killing Floor Turbo PlayerBorrowedTimeActor
//Distributed under the terms of the MIT License.
//For more information see https://github.com/KFPilot/KFTurbo.
class PlayerBorrowedTimeActor extends Engine.ReplicationInfo;

var int BorrowedTimeStart, BorrowedTimeEnd;
var int ServerTimeSeconds, LastServerTimeSeconds;
var float CurrentServerTime;
var bool bHasExecutedBorrowedTime;

replication
{
	reliable if (bNetDirty && Role == ROLE_Authority )
		BorrowedTimeStart, BorrowedTimeEnd, ServerTimeSeconds;
}

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();

    if (Level.NetMode == NM_DedicatedServer)
    {
        return;
    }

    if (Role == ROLE_Authority)
    {
        ServerTimeSeconds = Level.TimeSeconds;
    }

    SetTimer(0.1f, false);
}

simulated function SetServerTimeSeconds(int NewServerTimeSeconds)
{
    if (NewServerTimeSeconds == ServerTimeSeconds)
    {
        return;
    }

    ServerTimeSeconds = NewServerTimeSeconds;
    NetUpdateTime = Level.TimeSeconds - 20.f;
}

simulated function Timer()
{
    if (Level.GetLocalPlayerController() != None && RegisterToOverlay(Level.GetLocalPlayerController()))
    {
        return;
    }

    SetTimer(0.1f, false);
}

simulated function bool RegisterToOverlay(PlayerController PlayerController)
{
    local TurboCardOverlay CardOverlay;

    CardOverlay = class'TurboCardOverlay'.static.FindCardOverlay(PlayerController);

    if (CardOverlay == None)
    {
        return false;
    }

    CardOverlay.BorrowedTimeActor = Self;
    return true;
}

function StartBorrowedTime()
{
    BorrowedTimeStart = Level.TimeSeconds;
    BorrowedTimeEnd = BorrowedTimeStart + GetWaveBorrowedTime();
}

function int GetWaveBorrowedTime()
{
    local float TotalTime;

    if (KFGameType(Level.Game).WaveNum >= KFGameType(Level.Game).FinalWave)
    {
        return 60.f * 5.f;
    }

    TotalTime = 60.f; //Give 60 seconds base.
    TotalTime += float(KFGameType(Level.Game).TotalMaxMonsters) * 1.5f;
    return TotalTime;
}

function StopBorrowedTime()
{
    BorrowedTimeStart = -1;
    BorrowedTimeEnd = -1;
}

simulated function Tick(float DeltaTime)
{
    TickBorrowedTime(DeltaTime);

    //Keep up to date a float server time to use later.

    if (ServerTimeSeconds > LastServerTimeSeconds)
    {
        LastServerTimeSeconds = ServerTimeSeconds;
        CurrentServerTime = float(LastServerTimeSeconds);
    }

    CurrentServerTime = FMin(CurrentServerTime + (DeltaTime * 0.9f), LastServerTimeSeconds + 1);
}

function TickBorrowedTime(float DeltaTime)
{
    local Controller C;
    if (BorrowedTimeEnd < 0)
    {
        if (KFGameType(Level.Game).bWaveInProgress)
        {
            StartBorrowedTime();
        }
        return;
    }

    if (!KFGameType(Level.Game).bWaveInProgress)
    {
        StopBorrowedTime();
        return;
    }

    SetServerTimeSeconds(Level.TimeSeconds);

    if (BorrowedTimeEnd > Level.TimeSeconds)
    {
        return;
    }

    if (bHasExecutedBorrowedTime)
    {
        return;
    }

    bHasExecutedBorrowedTime = true;
    for (C = Level.ControllerList; C != None; C = C.NextController)
    {
        if (PlayerController(C) != None && PlayerController(C).Pawn != None && !PlayerController(C).Pawn.bDeleteMe && PlayerController(C).Pawn.Health > 0)
        {
            PlayerController(C).Pawn.Died(None, class'OutOfBorrowedTime_DT', PlayerController(C).Pawn.Location);
        }
    }
}

defaultproperties
{
    BorrowedTimeStart = -1;
    BorrowedTimeEnd = -1;
    bHasExecutedBorrowedTime = false

    ServerTimeSeconds = -1
    LastServerTimeSeconds = -1
    CurrentServerTime = -1.f
}